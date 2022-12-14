library ieee;
use ieee.std_logic_1164.all;

library work;
use work.project_pkg.all;

library ads;
use ads.ads_fixed.all;
use ads.ads_complex_pkg.all;

entity mandelbrot_pipeline is
	generic (
		stages_total: natural := 8;
		threshold: ads_sfixed := to_ads_sfixed(2)
	);
	port (
		clock:	in	std_logic;
		reset:	in	std_logic;
		z_seed:	in	ads_complex;
		c_seed:	in	ads_complex;

		iteration_count:	out	natural
	);
end entity mandelbrot_pipeline;

architecture rtl of mandelbrot_pipeline is
	type signal_z_type is array(0 to stages_total) of ads_complex;
	type signal_stage_type is array(0 to stages_total) of natural;
	
	signal in_z: signal_z_type;
	signal out_z: signal_z_type;
	
	-- add other types and signals here
	signal in_c: signal_z_type;
	signal in_ov: std_logic_vector(0 to stages_total);
	signal in_stage: signal_stage_type;
	
	signal out_c: signal_z_type;
	signal out_ov: std_logic_vector(0 to stages_total);
	signal out_stage: signal_stage_type;
	
begin
	-- create the pipeline stages
	pipeline: for stage in 0 to stages_total - 1 generate
		s: pipeline_stage
			generic map (
				threshold => threshold,
				stage_number => stage
			)
			port map (
				in_z => in_z(stage),
				-- other stuff
				in_c => in_c(stage),
				in_ov => in_ov(stage),
				in_stage => in_stage(stage),
				
				out_z => out_z(stage),
				-- other stuff
				out_c => out_c(stage),
				out_ov => out_ov(stage),
				out_stage => out_stage(stage)
			);
	end generate pipeline;

	-- create the connections with the registers:
	connection: for stage in 1 to stages_total - 1 generate
		stage_register: process(clock) is
		begin
			-- the output of the previous stage goes into
			-- the next stage
			if rising_edge(clock) then
				if reset = '0' then
					in_z(stage) <= complex_zero;
					in_c(stage) <= complex_zero;
					in_ov(stage) <= '0';
					in_stage(stage) <= 0;
				else
					in_z(stage) <= out_z(stage - 1);
					-- other signals
					in_c(stage) <= out_c(stage - 1);
					in_ov(stage) <= out_ov(stage - 1);
					in_stage(stage) <= out_stage(stage - 1);
				end if;
			end if;
		end process stage_register;
	end generate connection;

	-- drive the first stage:
	in_z(0) <= z_seed;
	in_c(0) <= c_seed;
	
	-- add other signals
	in_ov(0) <= '0';
	in_stage(0) <= 0;

	-- drive the output
	iteration_count <= out_stage(stages_total - 1);

end architecture rtl;

