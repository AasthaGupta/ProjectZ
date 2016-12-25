use work.neuron_types.all;

entity test_network_layer is
end entity;

architecture test_network_layer_arch of test_network_layer is

	component network_layer is
        port(LAYER_INPUT : IN network_vector;
             LAYER_OUTPUT : OUT network_vector;
             START : IN bit;
             CLOCK : IN bit;
             READY : OUT bit);
    end component;

	signal network_inputs : network_vector := ("0000000100000000000000000000000000000000",  -- 1.0
		    	                        	   "0000000010000000000000000000000000000000",  -- 0.5
			                            	   "0000000100000000000000000000000000000000",  -- 1.0
			                            	   "0000000010000000000000000000000000000000",  -- 0.5
			                            	   "0000000100000000000000000000000000000000",  -- 1.0
			                            	   "0000000010000000000000000000000000000000",  -- 0.5
			                            	   "0000000100000000000000000000000000000000",  -- 1.0
			                            	   "0000000010000000000000000000000000000000",  -- 0.5
			                            	   "0000000100000000000000000000000000000000"); -- 1.0

    signal network_out : network_vector;
	signal network_start, clk, network_ready : bit;

	begin

	NETWORK : network_layer port map(network_inputs, network_out, network_start, clk, network_ready);

	clk <= not clk after 10 ns;

	process
	begin
		network_start <= '1';
		wait until network_ready = '1';

	end process;

end architecture;
