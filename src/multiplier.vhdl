entity BOOTH_MULTIPLIER is
    port(A,B : IN bit_vector(39 downto 0);
         P : OUT bit_vector(39 downto 0);
         START,CLOCK : IN bit;
         READY : OUT bit);
end entity;

architecture BOOTH_MULTIPLIER_arch of BOOTH_MULTIPLIER is
    type state is(Initial,OpcodeGen,Logic,Shift,Done);

    component PP_REGISTER is
        generic(BIT_COUNT : integer);
        port(IN_PORT : in bit_vector(BIT_COUNT - 1 downto 0);
            OUT_PORT : out bit_vector(BIT_COUNT - 1 downto 0);
            INC : in bit;
            CLOCK : in bit;
            RESET : in bit;
            LOAD_ENABLE : in bit);
	end component;
    component ADDER is
    generic(BIT_COUNT : integer);
    port(Adder : in bit_vector(BIT_COUNT - 1 downto 0);
		Addend : in bit_vector(BIT_COUNT - 1 downto 0);
		CarryIn : in bit;
		RESULT : out bit_vector(BIT_COUNT - 1 downto 0));
	end component;

    signal present_state : state := Initial;
    signal next_state : state := Initial;
    signal Opcode : bit_vector(1 downto 0);
    signal reset : bit := '0';
    signal inc : bit := '0';
    signal ac_in , ac_out , q_in , q_out : bit_vector(39 downto 0) := (others => '0');
    signal counter_in : bit_vector(39 downto 0);
    signal counter_out : bit_vector(39 downto 0);
    signal register_clock : bit := '0';

    signal B_bar: bit_vector(39 downto 0);
    signal add_b,sub_b: bit_vector(39 downto 0);


begin

    B_bar <= not B;
    SUB: ADDER
	 	generic map(40)
		port map(ac_out,B_bar,'1',sub_b);
    ADD: ADDER
	 	generic map(40)
		port map(ac_out,B,'0',add_b);

    --#IMPORTANT: register_clock must be atleast twice as fast
    register_clock <= not register_clock after 3 ns;
    AC : PP_REGISTER
		generic map (40)
		port map (ac_in,ac_out,'0',register_clock,reset,'1');
	Q : PP_REGISTER
		generic map (40)
		port map (q_in,q_out,'0',register_clock,reset,'1');
    COUNTER : PP_REGISTER
        generic map (40)
        port map (counter_in,counter_out,inc,CLOCK,reset,'0');


    process(CLOCK)
    begin

            present_state <= next_state;

            if(CLOCK'event and CLOCK='1')then
            inc <= '0';
            case present_state is

            WHEN Initial =>
                READY <= '0';
                reset <= '1';
                ac_in <= (others => '0');
                Opcode <= (others => '0');
                q_in  <= A;
                if(START='1')then
                    next_state <= OpcodeGen;
                end if;

            WHEN OpcodeGen =>
                Opcode(0) <= Opcode(1);
                Opcode(1) <= q_out(0);

                next_state <= Logic;

            WHEN Logic=>
                reset <= '0';
                --Logic
                case Opcode is
                WHEN "01" =>
                    ac_in <= add_b;
                WHEN "10" =>
                    ac_in <= sub_b;
                WHEN others =>
                    ac_in <= ac_out;
                end case;

                next_state <= Shift;

            WHEN Shift =>
                --Shifting
                ac_in(38 downto 0) <= ac_out(39 downto 1);
                q_in(39) <= ac_out(0);
                q_in(38 downto 0) <= q_out(39 downto 1);
                -- x -- x --

                --0b100111=39
                if(counter_out(5 downto 0)="100111")then
                    next_state <= Done;
                else
                    next_state <= OpcodeGen;
                end if;
                inc <= '1';


            WHEN Done =>
                READY <= '1';
                next_state <= Initial;
                P(39 downto 8) <= ac_out(31 downto 0);
                P(7 downto 0) <= q_out( 39 downto 32);
            end case;

        end if;

    end process;

end architecture;
