library ieee;
use ieee.std_logic_1164.all;

use std.textio.all;

library ads;
use ads.ads_complex_pkg.all;
use ads.ads_fixed.all;

use work.netpbm_config.all;

entity mandelbrot_netpbm_generator is
	generic (
		stages_total: natural := 32;
		threshold: ads_sfixed := to_ads_sfixed(4)
	);
end entity mandelbrot_netpbm_generator;

architecture test_fixture of mandelbrot_netpbm_generator is

	-- your mandelbrot computational engine here (EDIT NEEDED HERE)
	-- update how the component entity is declared and instanced
	component mandelbrot_pipeline is
		generic (
			stages_total:	natural range 8 to 64		:= 32;
			threshold:		ads_sfixed	:= to_ads_sfixed(4)
		);
		port (
			
			clock:				in	std_logic;
			reset:				in	std_logic;
			seed:				in	ads_complex;
	
			iteration_count:	out	natural range 0 to stages_total - 1
	
		);
	end component mandelbrot_pipeline;
	-- update how the component entity is declared and instanced
	-- (EDIT STOPS HERE)
	

	signal iteration_test: natural range 0 to iterations + 1;

	signal seed: ads_complex := complex_zero;
	signal clock: std_logic		:= '0';
	signal reset: std_logic		:= '0';
	
	signal iteration_count: natural range 0 to iterations;
	
	signal finished: boolean	:= false;

begin

	clock <= not clock after 1 ps when not finished else '0';
	
	
-- (EDITS START HERE)
-- update how the component entity is declared and instanced
	generator: mandelbrot_pipeline
		generic map (
			stages_total => stages_total,
			threshold => threshold
		)
		port map (
			
			clock => clock,
			reset => reset,
			seed => seed,
			iteration_count => iteration_count
			
		);
-- update how the component entity is declared and instanced
--(EDITS END HERE)



	make_pgm: process
		variable x_coord: ads_sfixed;
		variable y_coord: ads_sfixed;
		variable output_line: line;
	begin
		-- header information
		---- P2
		write(output_line, string'("P2"));
		writeline(output, output_line);
		---- resolution
		write(output_line, integer'image(x_steps) & string'(" ")
				& integer'image(y_steps));
		writeline(output, output_line);
		---- maximum value
		write(output_line, integer'image(stages_total - 1));
		writeline(output, output_line);

		-- from here onwards, stimulus depends on your implementation

		-- reset generator
		wait until rising_edge(clock);
		reset <= '0';
		wait until rising_edge(clock);
		reset <= '1';

		-- iterate Y coordinates (rows)
		for y_pt in 0 to y_steps-1 loop
			-- imaginary portion computation
			y_coord := to_ads_sfixed(y_range.min) + to_ads_sfixed(y_pt) * dy;

			-- iterate X coordinates (columns)
			for x_pt in 0 to x_steps-1 loop

				-- real portion computation
				x_coord := to_ads_sfixed(x_range.min) + to_ads_sfixed(x_pt) * dx;

				-- set seed
				seed <= (re => x_coord, im => y_coord);

				-- TODO: modify stimulus here depending on your core!
				wait until rising_edge(clock);

				write(output_line, integer'image(iterations -
						iteration_count-1));
				writeline(output, output_line);
				-- Need Number of clock cycles since first put data into the pipeline
				-- When # of clock cycles = # of Pipeline Stages
				-- Pass the output is valid and start to print 
				--(Edit Starts Here)
				-- TODO: actually truncate the output
				--if output_valid then
				--	write(output_line, integer'image(stages_total - 1 - iteration_count));
				--	writeline(output, output_line);
				-- flush(output);
				--end if;
				--(Edit END Here)
				
			
			end loop;
		end loop;

		for i in 0 to stages_total - 1 loop
			wait until rising_edge(clock);
			write(output_line, integer'image(stages_total - 1 - iteration_count));
			writeline(output, output_line);
			-- flush(output);
		end loop;

		-- all done
		finished <= true;
		wait;
	end process make_pgm;

end architecture test_fixture;
