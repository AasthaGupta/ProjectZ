entity D_FF is
    port(D : in bit;
        RESET : in bit;
        CLOCK : in bit;
        Q : out bit);
end entity;

architecture D_FF_arch of D_FF is
begin
    process(CLOCK)
    begin
        if CLOCK'event and CLOCK = '1' then
            Q <= D;
        end if;
    end process;
end architecture;