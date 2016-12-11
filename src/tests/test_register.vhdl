entity test_register is
end entity;

architecture test_register_arch of test_register is
    component PP_REGISTER is
        generic(BIT_COUNT : integer);
        port(IN_PORT : in bit_vector(BIT_COUNT - 1 downto 0);
            OUT_PORT : out bit_vector(BIT_COUNT - 1 downto 0);
            INC : in bit;
            CLOCK : in bit;
            RESET : in bit;
            LOAD_ENABLE : in bit);
    end component;
    signal clk, rst, le, inc : bit := '0';
    signal my_in, my_out : bit_vector(31 downto 0) := (others => '0');
begin
    inst0: PP_REGISTER
    generic map(32)
    port map (my_in, my_out, inc, clk, rst, le);

    clk <= not clk after 50 ns;
    process
    begin
        inc <= '0';
        my_in(5 downto 0) <= (others => '1');
        le <= '1';
        wait for 100 ns;
        le <= '0';
        inc <= '1';
        wait for 100 ns;
        wait for 100 ns;
        wait for 100 ns;
    end process;
end architecture;