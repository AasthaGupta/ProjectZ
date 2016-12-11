library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity PP_REGISTER is
    generic(BIT_COUNT : integer);
    port(IN_PORT : in bit_vector(BIT_COUNT - 1 downto 0);
        OUT_PORT : out bit_vector(BIT_COUNT - 1 downto 0);
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
    signal DATA_PORT : bit_vector(BIT_COUNT - 1 downto 0) := (others => '0');
begin
    GEN: for index in BIT_COUNT - 1 downto 0 generate
        inst: D_FF port map(DATA_PORT(index), RESET, CLOCK, OUT_PORT(index));
    end generate;
    process(LOAD_ENABLE)
    begin
        if LOAD_ENABLE = '1' then
            DATA_PORT <= IN_PORT;
        end if;
    end process;
end architecture;