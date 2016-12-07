entity adder is
	port(a,b:in bit_vector(7 downto 0);
		 sum:out bit_vector(7 downto 0));
end entity;

architecture adder_arch of adder is
signal carry:bit_vector(8 downto 0) := (others => '0');
begin
	process(a,b)
	begin
		for i in 0 to 7 loop
			sum(i) <= a(i) xor b(i) xor carry(i);
			carry(i+1) <= (a(i) and b(i)) or (b(i) and carry(i)) or (carry(i) and a(i));
		end loop;
	end process;
end architecture;

