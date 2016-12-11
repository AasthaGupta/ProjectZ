entity test_adder is
end entity;

architecture test_adder_arch of test_adder is
    component adder is
    	generic(BIT_COUNT:integer);
    	port(a,b:in bit_vector(BIT_COUNT-1 downto 0);
    		 sum:out bit_vector(BIT_COUNT-1 downto 0));
    end component;
    signal in1,in2,outp : bit_vector(7 downto 0);
begin
    inst: adder
        generic map(8)
        port map (in1,in2,outp);
    process
    begin
        in1 <= "00001100";
        in2 <= "00001010";
        wait for 200 ns;
        in1 <= "00010001";
        in2 <= "00100010";
        wait for 200 ns;
    end process;
end architecture;