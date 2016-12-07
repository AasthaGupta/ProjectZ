entity mul_test is
end entity;

architecture mul_test_arch of mul_test is
    component multiplier is
        generic(N,M: Integer);
        port(a,b: in bit_vector(N+M-1 downto 0);
             c: out bit_vector(N+M-1 downto 0));
    end component;
    signal in1,in2,outp : bit_vector(7 downto 0);
begin
    inst0: multiplier
    generic map(4,4)
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
