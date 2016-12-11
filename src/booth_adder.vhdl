entity BOOTH_ADDER is
    generic(N:Integer);
    port(A,B: IN bit_vector(N-1 downto 0);
         S: OUT bit_vector(N-1 downto 0);
         S0: OUT bit;
         OPCODE: IN bit_vector(1 downto 0));
end entity;
architecture BOOTH_ADDER_arch of BOOTH_ADDER is
    component ADDER
		generic(BIT_COUNT:integer);
		port(A,B:in bit_vector(BIT_COUNT-1 downto 0);
			 SUM:out bit_vector(BIT_COUNT-1 downto 0));
	end component;
    signal nb: bit_vector(N-1 downto 0);
    signal b_bar: bit_vector(N-1 downto 0);
    signal b_in: bit_vector(N-1 downto 0);
    signal sum: bit_vector(N-1 downto 0);
    signal one: bit_vector(N-1 downto 0) := (others => '0');
    signal zero: bit_vector(N-1 downto 0) := (others => '0');
    
begin

    b_bar <= not B;
    one(0) <= '1';
    NEG_B: ADDER
	 	generic map(N)
		port map(b_bar,one,nb);
    ADD: ADDER
	 	generic map(N)
		port map(A,b_in,sum);
    b_in <= B WHEN OPCODE="01" ELSE
            nb WHEN OPCODE="10" ELSE
            zero;
    S(N-1) <= sum(N-1);
    S(N-2 downto 0) <= sum(N-1 downto 1);
    S0 <= sum(0);

end architecture;
