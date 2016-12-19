entity PP_REGISTER is
    generic(BIT_COUNT : integer);
    port(IN_PORT : in bit_vector(BIT_COUNT - 1 downto 0);
        OUT_PORT : out bit_vector(BIT_COUNT - 1 downto 0);
        INC : in bit;
        CLOCK : in bit;
        RESET : in bit;
        LOAD_ENABLE : in bit);
end entity;

architecture PP_REGISTER_arch of PP_REGISTER is

    component D_FF is
        port(D : in bit;
            RESET : in bit;
            CLOCK : in bit;
            Q : out bit);
    end component;

    signal DATA_PORT : bit_vector(BIT_COUNT - 1 downto 0);

begin

    GEN: for index in BIT_COUNT - 1 downto 0 generate
        inst: D_FF port map(DATA_PORT(index), RESET, CLOCK, OUT_PORT(index));
    end generate;

    process(CLOCK)
        variable Carry : bit;
        variable Sum : bit;
    begin

        if RESET = '1' then
            DATA_PORT <= (others => '0');
        end if;

        if CLOCK'event and CLOCK = '1' then

		    if LOAD_ENABLE = '1' then
                DATA_PORT <= IN_PORT;
            end if;

            if INC = '1' then
                Carry := '1';
                for index in 0 to BIT_COUNT - 1 loop
                    Sum := Carry xor DATA_PORT(index);
                    Carry := Carry and DATA_PORT(index);
                    DATA_PORT(index) <= Sum;
                end loop;
            end if;

        end if;

    end process;

end architecture;
