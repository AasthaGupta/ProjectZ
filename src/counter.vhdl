entity COUNTER is
    port(CLOCK,CLEAR:IN bit;
         COUNT: OUT bit_vector(1 downto 0));
end entity;

architecture COUNTER_arch of COUNTER is
    component adder is
    	generic(BIT_COUNT:integer);
    	port(A,B:in bit_vector(BIT_COUNT-1 downto 0);
    		 SUM:out bit_vector(BIT_COUNT-1 downto 0));
    end component;
    signal c_in:bit_vector(1 downto 0):=(others => '0');
    signal c_out:bit_vector(1 downto 0):=(others => '0');
begin
    INC: adder
	 	generic map(2)
		port map(c_in,"01",c_out);

    process(CLOCK,CLEAR)
    begin
        if CLEAR='1'then
            COUNT <= "00";
            c_in <= "00";
        elsif(CLOCK'event and CLOCK='1')then
            COUNT <=c_out;
            c_in <= c_out;
        end if;
    end process;

end architecture;
