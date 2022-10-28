library ieee;
use ieee.std_logic_1164.all;

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
end package;

package body project_pkg is

end package body project_pkg;