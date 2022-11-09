library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

library vga;
use vga.vga_data.all;

library ads;
use ads.ads_fixed.all;
use ads.ads_complex_pkg.all;

package project_pkg is
	-- vga_fsm component to be called into top level
	component vga_fsm is
		generic (
			vga_res:	vga_timing := vga_res_default
		);
		port (
			
			vga_clock:		in	std_logic;
			reset:			in	std_logic;

			point:			out	coordinate;
			point_valid:	out	boolean;

			h_sync:			out	std_logic;
			v_sync:			out std_logic
		);
	end component vga_fsm;
	
	-- pipeline component
	component pipeline_stage is
		generic (
			threshold: ads_sfixed := to_ads_sfixed(2);
			stage_number: natural := 0
		);

		 port (		
				in_z: in ads_complex;
				in_c: in ads_complex;
				in_ov: in std_logic;
				in_stage: in natural;
				
				out_z: out ads_complex;
				out_c: out ads_complex;
				out_ov: out std_logic;
				out_stage: out natural
    );
	 end component pipeline_stage;
	 
	 -- mandelbrot component
	component mandelbrot_pipeline is
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
	end component mandelbrot_pipeline;
	
	-- shift register component
	component shift_register is 
		generic (
			sr_depth : natural
		);
	
		port(
			clk: in std_logic;
			rst: in std_logic;
				
			sr_in: in std_logic;
			sr_out: out std_logic
		);
	end component shift_register;
	
	
		-- record for minimum and maximum
	type plot_range is
	record
		min:	real;
		max:	real;
	end record plot_range;

	constant x_range: plot_range := (
			min => -2.2,
			max =>  2.2
		);
	constant y_range: plot_range := (
			min => -1.2,
			max =>  1.2
		);

	constant y_steps: natural range 10 to natural'high := 480;
	constant x_steps: natural range 10 to natural'high := 640;

	-- other stuff
	constant dy: ads_sfixed := to_ads_sfixed((y_range.max - y_range.min)
									/ real(y_steps));
	constant dx: ads_sfixed := to_ads_sfixed((x_range.max - x_range.min)
									/ real(x_steps));
	
end package;

package body project_pkg is

end package body project_pkg;