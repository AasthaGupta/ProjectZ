entity test_adder is
end entity;

architecture test_adder_arch of test_adder is
    component adder is
        generic(BIT_COUNT : integer);
    	port(Adder : in bit_vector(BIT_COUNT - 1 downto 0);
    		Addend : in bit_vector(BIT_COUNT - 1 downto 0);
    		CarryIn : in bit;
    		RESULT : out bit_vector(BIT_COUNT - 1 downto 0));
    end component;
    signal my_in1,my_in2,my_result : bit_vector(7 downto 0);
    signal my_carryin : bit;
begin
    inst: adder
        generic map(8)
        port map (my_in1,my_in2,my_carryin,my_result);
    process
    begin
        my_in1 <= "00001100";
        my_in2 <= "00001010";
        my_carryin <= '1';
        wait for 200 ns;
        my_in1 <= "00010001";
        my_in2 <= "00100010";
        my_carryin <= '0';
        wait for 200 ns;
    end process;
end architecture;
