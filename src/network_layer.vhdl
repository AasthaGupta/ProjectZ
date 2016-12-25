use work.neuron_types.all;

entity network_layer is
    port(LAYER_INPUT : IN network_vector;
         LAYER_OUTPUT : OUT network_vector;
         START : IN bit;
         CLOCK : IN bit;
         READY : OUT bit);
end entity;

architecture network_layer_arch of network_layer is
    component neuron is
        port(DATA_IN : IN network_vector;
             DATA_OUT : OUT bit_vector(39 downto 0);
             START : IN bit;
             CLOCK : IN bit;
             READY : OUT bit);
    end component;

    signal neuron_ready : bit_vector(8 downto 0) := (others => '0');

    begin
        GEN_LAYER : for i in 0 to 8 generate
            NEURON_X : neuron port map (LAYER_INPUT,LAYER_OUTPUT(i),START,CLOCK,neuron_ready(i));
        end generate;

    process(CLOCK)

    begin

        if CLOCK'event and CLOCK = '1'then

            if START = '1' and neuron_ready = "111111111" then
                READY <= '1';
            else
                READY <= '0';
            end if;

        end if;

    end process;

end architecture;
