use work.neuron_types.all;

entity neuron is
    port(DATA_IN : IN neuron_in;
         DATA_OUT : OUT bit_vector(39 downto 0);
         START : INOUT bit;
         CLOCK : IN bit;
         READY : OUT bit);
end entity;

architecture neuron_arch of neuron is

    component BOOTH_MULTIPLIER is
        port(A,B : IN bit_vector(39 downto 0);
             P : OUT bit_vector(39 downto 0);
             START : IN bit;
             CLOCK : IN bit;
             READY : OUT bit);
    end component;

    component ADDER is
        generic(BIT_COUNT : integer);
        port(Adder : in bit_vector(BIT_COUNT - 1 downto 0);
             Addend : in bit_vector(BIT_COUNT - 1 downto 0);
             CarryIn : in bit;
             RESULT : out bit_vector(BIT_COUNT - 1 downto 0));
    end component;

    component PP_REGISTER is
        generic(BIT_COUNT : integer);
        port(IN_PORT : in bit_vector(BIT_COUNT - 1 downto 0);
            OUT_PORT : out bit_vector(BIT_COUNT - 1 downto 0);
            INC : in bit;
            CLOCK : in bit;
            RESET : in bit;
            LOAD_ENABLE : in bit);
    end component;

signal counter_out, counter_in : bit_vector(3 downto 0) := (others => '0');
signal mul_ready, mul_start, counter_inc, counter_rst : bit := '0';
signal mul_in_a, mul_in_b, mul_out, add_in_a, add_in_b, add_out : bit_vector(39 downto 0) := (others => '0');

signal weights : neuron_in := ("0000000000000000000000000000000000000000",
                               "0000000000000000000000000000000000000000",
                               "0000000000000000000000000000000000000000",
                               "0000000000000000000000000000000000000000",
                               "0000000000000000000000000000000000000000",
                               "0000000000000000000000000000000000000000",
                               "0000000000000000000000000000000000000000",
                               "0000000000000000000000000000000000000000",
                               "0000000000000000000000000000000000000000");

begin

    MUL : BOOTH_MULTIPLIER port map(mul_in_a, mul_in_b, mul_out, mul_start, CLOCK, mul_ready);

    ADD : ADDER
          generic map(40)
          port map(add_in_a, add_in_b, '0', add_out);

    CNT : PP_REGISTER
          generic map (4)
          port map(counter_in, counter_out, counter_inc, CLOCK, counter_rst, '0');

    process(CLOCK)

    begin

        if CLOCK'event and CLOCK = '1' then
            counter_inc <= '0';

            if START = '1' and mul_start = '0' then

                case counter_out is

                    when "0000" =>
                        mul_in_a <= DATA_IN(0);
                        mul_in_b <= weights(0);
                        mul_start <= '1';

                    when "0001" =>
                        mul_in_a <= DATA_IN(1);
                        mul_in_b <= weights(1);
                        mul_start <= '1';

                    when "0010" =>
                        mul_in_a <= DATA_IN(2);
                        mul_in_b <= weights(2);
                        mul_start <= '1';

                    when "0011" =>
                        mul_in_a <= DATA_IN(3);
                        mul_in_b <= weights(3);
                        mul_start <= '1';

                    when "0100" =>
                        mul_in_a <= DATA_IN(4);
                        mul_in_b <= weights(4);
                        mul_start <= '1';

                    when "0101" =>
                        mul_in_a <= DATA_IN(5);
                        mul_in_b <= weights(5);
                        mul_start <= '1';

                    when "0110" =>
                        mul_in_a <= DATA_IN(6);
                        mul_in_b <= weights(6);
                        mul_start <= '1';

                    when "0111" =>
                        mul_in_a <= DATA_IN(7);
                        mul_in_b <= weights(7);
                        mul_start <= '1';

                    when "1000" =>
                        mul_in_a <= DATA_IN(8);
                        mul_in_b <= weights(8);
                        mul_start <= '1';

                    when others =>
                        DATA_OUT <= add_out;
                        counter_rst <= '1';
                        START <= '0';
                        READY <= '1';

                end case;

            elsif START = '1' and mul_ready = '1' then

                counter_inc <= '1';
                mul_start <= '0';
                add_in_a <= add_out;
                add_in_b <= mul_out;

            end if;

        end if;

    end process;

end architecture;