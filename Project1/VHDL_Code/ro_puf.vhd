library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library work;
use work.project_pkg.all;

entity ro_puf is
    generic (
        -- ring oscillator length parameter and amount of oscillator
		  ro_length : positive := 13;
		  ro_count : positive := 16
	 );
    port (
        reset:      in    std_logic;
        enable:     in    std_logic;
		  challenge:  in    std_logic;
		  response:   out   std_logic
    );
end entity ro_puf;

architecture puf of ro_puf is
	-- types
	type counter_type is array(0 to ro_count - 1)
		of natural range 0 to 2**16 - 1;

	-- signal enable for each ring oscillator
	signal enable_all:		std_logic_vector(ro_count downto 0);
	-- signal to connect to counters for each oscillator
	signal clk: 	std_logic_vector(ro_count downto 0);
	-- counter define, reset is active low, 16-bit counter
	signal counters: counter_type;
	-- challenge output
	signal chal:		std_logic_vector(ro_count downto 0);
	 
begin
	
	-- generate ro and counters
	ro_chain: for stage in 0 to ro_count - 1 generate
		-- connect enable to each ro
		enable_all(stage) <= enable;
		-- create ring oscillators
		ro: ring_oscillator
			generic map (
				chain_size	=> ro_length
			)
			port map (		
				enable => enable_all(stage),
				osc_out => clk(stage)
			);
			
		-- generating the counters for each ro:
		Co: process(clk(stage))
			begin
			if reset = '0' then
				counters(stage) <= 0;
			elsif rising_edge(clk(stage)) then
				if enable = '1' then
					counters(stage) <= counters(stage) + 1;
				else
					counters(stage) <= counters(stage);
				end if;
			end if;
			end process;
			
	end generate ro_chain;
	
	-- counter array index for mux and comparision
	
	
	-- Check if num of ro is power of 2, if odd then fail
	assert (to_unsigned(ro_count, 4) AND to_unsigned(ro_count - 1, 4)) = 0
		report "invalid power" severity error;
end architecture puf;
