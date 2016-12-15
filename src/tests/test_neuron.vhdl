use work.neuron_types.all;

entity test_neuron is
end entity;

architecture test_neuron_arch of test_neuron is

	component neuron is

		port(DATA_IN : IN neuron_in;
        	 DATA_OUT : OUT bit_vector(39 downto 0);
        	 START : IN bit;
        	 CLOCK : IN bit;
        	 READY : OUT bit);

	end component;

	signal neuron_inputs : neuron_in := ("0000000100000000000000000000000000000000",  -- 1.0
    	                        	     "0000000010000000000000000000000000000000",  -- 0.5
	                            	     "0000000100000000000000000000000000000000",  -- 1.0
	                            	     "0000000010000000000000000000000000000000",  -- 0.5
	                            	     "0000000100000000000000000000000000000000",  -- 1.0
	                            	     "0000000010000000000000000000000000000000",  -- 0.5
	                            	     "0000000100000000000000000000000000000000",  -- 1.0
	                            	     "0000000010000000000000000000000000000000",  -- 0.5
	                            	     "0000000100000000000000000000000000000000"); -- 1.0

	signal neuron_start, clk, ready : bit;
	signal neuron_out : bit_vector(39 downto 0);

	begin

	NEU : neuron port map(neuron_inputs, neuron_out, neuron_start, clk, ready);

	clk <= not clk after 10 ns;

	process
	begin
		-- (0.074949 + 0.048939 + 0.029983 + 0.031349 + 0.092399) + (0.032323 + 0.043349 + 0.034899 + 0.017483) * 0.5
		neuron_start <= '1';
		wait until ready = '1';

	end process;

end architecture;