library ieee;
use ieee.std_logic_1164.all;

entity mandelbrot_pipeline is
	generic (
		stages_total: natural := 8;
		threshold: ads_sfixed := to_ads_sfixed(2)
	);
	port map (
		clock:	in	std_logic;
		reset:	in	std_logic;
		seed:	in	ads_complex;

		iteration:	out	natural
	);
end entity mandelbrot_pipeline;

architecture rtl of mandelbrot_pipeline is
	type signal_z_type is array(0 to stages_total) of ads_complex;
	signal in_z: signal_z_type;
	signal out_z: signal_z_type;
	-- add other types and signals here
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
				out_z => out_z(stage),
				-- other stuff
			);
	end generate pipeline;

	-- create the connections with the registers:
	connection: for stage in 1 to stages_total - 1 generate
		stage_register: process(clock) is
		begin
			-- the output of the previous stage goes into
			-- the next stage
			if rising_edge(clock) then
				in_z(stage) <= out_z(stage - 1);
				-- other signals
			end if;
		end process stage_register;
	end generate connection;

	-- drive the first stage:
	in_z(0) <= ( re => ads_sfixed(0), im => ads_sfixed(0) );
	in_c(0) <= seed;
	-- add other signals

	-- drive the output
	iteration <= out_stage(stage_total - 1);

end architecture rtl;

