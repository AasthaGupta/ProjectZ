entity BOOTH_MULTIPLIER is
    port(A,B:IN bit_vector(3 downto 0);
         P: OUT bit_vector(7 downto 0);
         START,CLOCK: IN bit;
         READY: OUT bit);
end entity;

architecture BOOTH_MULTIPLIER_arch of BOOTH_MULTIPLIER is
    type state is(Initial,Multiply,Done);

    component PP_REGISTER is
	    generic(BIT_COUNT : integer);
	    port(IN_PORT : in bit_vector(BIT_COUNT - 1 downto 0);
	        OUT_PORT : out bit_vector(BIT_COUNT - 1 downto 0);
	        CLOCK : in bit;
	        RESET : in bit;
	        LOAD_ENABLE : in bit);
	end component;
    component BOOTH_ADDER is
        generic(N:Integer);
		port(A,B: IN bit_vector(N-1 downto 0);
	         S: OUT bit_vector(N-1 downto 0);
	         S0: OUT bit;
	         OPCODE: IN bit_vector(1 downto 0));
    end component;
    component COUNTER is
		port(CLOCK,CLEAR:IN bit;
	         COUNT: OUT bit_vector(1 downto 0));
    end component;

    signal present_state: state := Initial;
    signal next_state: state := Initial;
    signal lsb : bit;
    signal Opcode: bit_vector(1 downto 0);
    signal q1: bit := '0';
    signal step: bit_vector(1 downto 0);
    signal reset: bit := '0';
    signal clear: bit := '1';
    signal ashr : bit_vector(3 downto 0);
    signal ac_in,ac_out,q_in,q_out,br_in,br_out : bit_vector(3 downto 0):= (others => '0');

begin

    AC: PP_REGISTER
		generic map(4)
		port map(ac_in,ac_out,CLOCK,reset,'1');
	Q: PP_REGISTER
		generic map(4)
		port map(q_in,q_out,CLOCK,reset,'1');
	BR: PP_REGISTER
		generic map(4)
		port map(br_in,br_out,CLOCK,reset,'1');

    AddAndShift: BOOTH_ADDER
                 generic map(4)
                 port map (ac_out,br_out,ashr,lsb,Opcode);
    INDEX: COUNTER
         port map(CLOCK,clear,step);

    process(CLOCK)
    begin
        if(CLOCK'event and CLOCK='1')then
            present_state <= next_state;
        end if;
    end process;

    process(present_state,CLOCK)
    begin
        case present_state is

        WHEN Initial =>
            READY <= '0';
            ac_in <="0000";
            br_in <= B;
            q_in  <= A;

            if(START='1')then
                next_state <= Multiply;
            end if;

        WHEN Multiply =>
            clear <= '0';
            Opcode(0) <= q1;
            Opcode(1) <= q_out(0);
            ac_in <= ashr;
            q_in(2 downto 0) <= q_out(3 downto 1);
            q_in(3) <=lsb;
            q1 <= Opcode(1);
            if(step="11")then
                next_state <= Done;
            end if;

        WHEN Done =>
            READY <= '1';

        end case;
    end process;

    P(7 downto 4) <= ac_out;
    P(3 downto 0) <= q_out;

end architecture;
