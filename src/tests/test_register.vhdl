library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity test_register is
end entity;

architecture test_register_arch of test_register is
    component PP_REGISTER is
        generic(BIT_COUNT : integer);
        port(IN_PORT : in bit_vector(BIT_COUNT - 1 downto 0);
            OUT_PORT : out bit_vector(BIT_COUNT - 1 downto 0);
            CLOCK : in bit;
            RESET : in bit;
            LOAD_ENABLE : in bit);
    end component;
    signal clk, rst, le : bit;
    signal my_in, my_out : bit_vector(31 downto 0);
begin
    inst0: PP_REGISTER
    generic map(BIT_COUNT => 32)
    port map (my_in, my_out, clk, rst, le);

    clk <= not clk after 50 ns;
    process
    begin
        my_in <= (others => '1');
        my_in(10 downto 5) <= (others => '0');
        le <= '1';
        wait for 200 ns;
        le <= '0';
        my_in <= (others => '0');
        my_in(10 downto 5) <= (others => '0');
        wait for 200 ns;
        le <= '1';
        wait for 200 ns;
        le <= '0';
        rst <= '1';
        wait for 200 ns;
    end process;
end architecture;