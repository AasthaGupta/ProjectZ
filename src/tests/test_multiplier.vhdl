entity test_multiplier is
end entity;

architecture test_multiplier_arch of test_multiplier is
    component  BOOTH_MULTIPLIER is
        port(A,B:IN bit_vector(3 downto 0);
             P: OUT bit_vector(7 downto 0);
             START,CLOCK: IN bit;
             READY: OUT bit);
    end component;
    signal my_in1,my_in2: bit_vector(3 downto 0);
    signal my_out: bit_vector(7 downto 0);
    signal my_start,my_clock,my_ready: bit;
begin
    my_clock <= not my_clock after 10 ns;
    inst: booth_multiplier
            port map (my_in1,my_in2,my_out,my_start,my_clock,my_ready);

    process
    begin
        my_start <= '1';
        my_in1 <= "1000";
        my_in2 <= "0001";
        wait until my_ready ='1';
    end process;
end architecture;
