entity test_booth_adder is
end entity;

architecture test_booth_adder_arch of test_booth_adder is
    component booth_adder is
        generic(N:Integer);
        port(a,b: IN bit_vector(N-1 downto 0);
             s: OUT bit_vector(N-1 downto 0);
             s0: OUT bit;
             Opcode: IN bit_vector(1 downto 0));
    end component;
    signal my_a: bit_vector(7 downto 0);
    signal my_b: bit_vector(7 downto 0);
    signal my_s: bit_vector(7 downto 0);
    signal my_s0: bit;
    signal my_opcode: bit_vector(1 downto 0);
begin
    inst: booth_adder
        generic map(8)
        port map (my_a,my_b,my_s,my_s0,my_opcode);

    process
    begin

        my_a <= "00001001";
        my_b <= "00000110";
        my_opcode <= "00";
        wait for 10 ns;
        my_a <= "00001001";
        my_b <= "00000110";
        my_opcode <= "01";
        wait for 10 ns;
        my_a <= "00001001";
        my_b <= "00000111";
        my_opcode <= "01";
        wait for 10 ns;
        my_a <= "00001001";
        my_b <= "00000101";
        my_opcode <= "10";
        wait for 10 ns;

    end process;
end architecture;
