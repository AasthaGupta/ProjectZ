library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity multiplier is
	generic(N,M: Integer);
	port(a,b: in bit_vector(N+M-1 downto 0);
		 c: out bit_vector(N+M-1 downto 0));
end entity;

architecture multiplier_arch of multiplier is
	component PP_REGISTER is
	    generic(BIT_COUNT : integer);
	    port(IN_PORT : in bit_vector(BIT_COUNT - 1 downto 0);
	        OUT_PORT : out bit_vector(BIT_COUNT - 1 downto 0);
	        CLOCK : in bit;
	        RESET : in bit;
	        LOAD_ENABLE : in bit);
	end component;
	component adder
		port(a,b:in bit_vector(7 downto 0);
			 sum:out bit_vector(7 downto 0));
	end component;
	signal ac_in,ac_out,q_in,q_out,br_in,br_out,br_bar_in,br_bar_out : bit_vector(N+M-1 downto 0);
	signal rst,clk,ac_le,q_le,br_le,br_bar_le:bit;
	signal one: bit_vector(7 downto 0):= (others => '0');
	signal nbr: bit_vector(N+M-1 downto 0);
	signal addend,sum: bit_vector(N+M-1 downto 0):= (others => '0');
begin
	clk <= not clk after 50 ns;
	one(0) <= '1';
	nbr <= not b;
	AC: PP_REGISTER
		generic map(N+M)
		port map(ac_in,ac_out,clk,rst,ac_le);
	Q: PP_REGISTER
		generic map(N+M)
		port map(q_in,q_out,clk,rst,q_le);
	BR: PP_REGISTER
		generic map(N+M)
		port map(br_in,br_out,clk,rst,br_le);
	BR_BAR: PP_REGISTER
		generic map(N+M)
		port map(br_bar_in,br_bar_out,clk,rst,br_bar_le);
	ADD1: adder port map(nbr,one,br_bar_in);
	ADD2: adder port map(ac_out,addend,sum);

	process(a,b)
	variable q1: bit;
	begin
		rst <= '1';
		q_le <= '1';
		q_in <= a;
		br_le <= '1';
		br_in <= b;
		br_bar_le <= '1';
		q1 :='0';

		for i in N+M-1 downto 0 loop
			if( q_out(0) = '1' ) and ( q1 = '0' ) then 
				addend <= br_bar_out;
			elsif( q_out(0) = '0' ) and ( q1 = '1' ) then 
				addend <= br_out;
			end if;
			ac_in <= sum;
			ac_le <= '1';
			q1 := q_out(0);
			q_in(N+M-2 downto 0) <= q_out(N+M-1 downto 1);
			q_in(N+M-1) <= ac_out(0);
			ac_in(N+M-2 downto 0) <= ac_out(N+M-1 downto 1);
			q_le <= '1';
			q_le <= '0';
			ac_le <= '0';
		end loop;

		c(N+M-1 downto M) <= ac_out(M-1 downto 0);
		c(M-1 downto 0) <= q_out(N+M-1 downto M);
	end process;
end architecture;

