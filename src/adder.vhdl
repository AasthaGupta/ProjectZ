entity ADDER is
	generic(BIT_COUNT:integer);
	port(A,B:in bit_vector(BIT_COUNT-1 downto 0);
		 SUM:out bit_vector(BIT_COUNT-1 downto 0));
end entity;

architecture ADDER_arch of ADDER is
	component FULL_ADDER is
		port(A,B,CARRY_IN:in bit;
	         S,CARRY_OUT:out bit);
	end component;
	signal carry:bit_vector(BIT_COUNT downto 0) := (others => '0');
begin
	GEN: for index in 0 to BIT_COUNT-1 generate
		inst: FULL_ADDER port map(A(index), B(index), carry(index), SUM(index), carry(index+1));
	end generate;
end architecture;
