library ieee;
use ieee.std_logic_1164.all;

library vga;
use vga.vga_data.all;

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
end package;

package body project_pkg is

end package body project_pkg;