entity test_counter is
end entity;

architecture test_counter_arch of test_counter is
    component counter is
        port(clk,clr:IN bit;
             count: OUT bit_vector(2 downto 0));
    end component;
    signal my_clk: bit;
    signal my_clr: bit;
    signal my_count: bit_vector(2 downto 0);
begin
    inst: counter
        port map (my_clk,my_clr,my_count);
    my_clk <= not my_clk after 30 ns;
    process
    begin
        my_clr <= '0';
        wait for 300 ns;
        my_clr <= '1';
        wait for 90 ns;
    end process;
end architecture;
