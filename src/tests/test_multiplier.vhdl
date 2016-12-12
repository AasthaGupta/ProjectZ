entity test_multiplier is
end entity;

architecture test_multiplier_arch of test_multiplier is
    component  BOOTH_MULTIPLIER is
        port(A,B : IN bit_vector(39 downto 0);
             P : OUT bit_vector(39 downto 0);
             START,CLOCK : IN bit;
             READY : OUT bit);
    end component;
    signal my_in1,my_in2: bit_vector(39 downto 0);
    signal my_out: bit_vector(39 downto 0);
    signal my_start,my_clock,my_ready: bit;
begin
    my_clock <= not my_clock after 6 ns;
    inst: booth_multiplier
            port map (my_in1,my_in2,my_out,my_start,my_clock,my_ready);

    process
    begin
        my_start <= '1';
        my_in1 <= (others => '0');
        my_in2 <= (others => '0');
        my_in1(6 downto 0) <= "1100101";    --  101
        my_in2(6 downto 0) <= "1100110";    --  102
        --      10100000111110 := 10302
        --      01.01 * 01.02 := 0001.0302 := (01.03)
        --      1100111 := 103
        wait until my_ready ='1';
    end process;
end architecture;
