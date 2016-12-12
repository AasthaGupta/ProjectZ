entity BOOTH_MULTIPLIER is
    port(A,B : IN bit_vector(3 downto 0);
         P : OUT bit_vector(7 downto 0);
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
    signal lsb : bit;
    signal Opcode : bit_vector(1 downto 0);
    signal q1 : bit := '0';
    signal reset : bit := '0';
    signal inc : bit := '0';
    signal ashr : bit_vector(3 downto 0);
    signal ac_in , ac_out , q_in , q_out , br_in , br_out : bit_vector(3 downto 0) := (others => '0');
    signal counter_in : bit_vector(2 downto 0);
    signal counter_out : bit_vector(2 downto 0);
    signal reg_clk : bit := '0';

    signal B_bar: bit_vector(3 downto 0);
    signal add_b,sub_b: bit_vector(3 downto 0);
    signal one: bit_vector(3 downto 0) := (others => '0');
    signal zero: bit_vector(3 downto 0) := (others => '0');

begin

    B_bar <= not B;
    SUB: ADDER
	 	generic map(4)
		port map(ac_out,b_bar,'1',sub_b);
    ADD: ADDER
	 	generic map(4)
		port map(ac_out,B,'0',add_b);

    reg_clk <= not reg_clk after 5 ns;
    AC : PP_REGISTER
		generic map (4)
		port map (ac_in,ac_out,'0',reg_clk,reset,'1');
	Q : PP_REGISTER
		generic map (4)
		port map (q_in,q_out,'0',reg_clk,reset,'1');
	BR : PP_REGISTER
		generic map (4)
		port map (br_in,br_out,'0',reg_clk,reset,'1');
    COUNTER : PP_REGISTER
        generic map (3)
        port map (counter_in,counter_out,inc,reg_clk,reset,'1');


    process(CLOCK)
    begin

            present_state <= next_state;

            if(CLOCK'event and CLOCK='1')then
            case present_state is

            WHEN Initial =>
                READY <= '0';
                ac_in <="0000";
                br_in <= B;
                q_in  <= A;
                counter_in <= (others => '0');
                if(START='1')then
                    next_state <= OpcodeGen;
                end if;

            WHEN OpcodeGen =>
                Opcode(0) <= Opcode(1);
                Opcode(1) <= q_out(0);
                next_state <= Logic;

            WHEN Logic=>
                inc <= '1';
                --Logic
                case Opcode is
                WHEN "01" =>
                    ashr <= add_b;
                WHEN "10" =>
                    ashr <= sub_b;
                WHEN others =>
                    ashr <= ac_out;
                end case;
                next_state <= Shift;


            WHEN Shift =>
                --Shifting
                ac_in(3) <= ashr(3);
                ac_in(2 downto 0) <= ashr(3 downto 1);
                q_in(3) <= ashr(0);
                q_in(2 downto 0) <= q_out(3 downto 1);
                q1 <= q_out(0);
                if(counter_out="011")then
                    next_state <= Done;
                else
                    next_state <= OpcodeGen;
                end if;
                counter_in <= counter_out;

            WHEN Done =>
                READY <= '1';

            end case;

        end if;

    end process;

    P(7 downto 4) <= ac_out;
    P(3 downto 0) <= q_out;

end architecture;
