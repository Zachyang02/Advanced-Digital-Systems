library ieee;
use ieee.std_logic_1164.all;

library vga;
use vga.vga_data.all;

entity vga_fsm is
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
end entity vga_fsm;

architecture fsm of vga_fsm is
	-- any internal signals you may need
	signal point_coord : coordinate;
begin
	-- implement methodology to drive outputs here
	-- use vga_data functions and types to make your life easier
	process (vga_clock) is
	begin
		if rising_edge(vga_clock) then
			if reset = '0' then
				point_coord <= make_coordinate(0, 0);
			else
				point_coord <= next_coordinate(point_coord, vga_res);
			end if;
		end if;
	end process;

	h_sync <= do_horizontal_sync(point_coord);
	v_sync <= do_vertical_sync(point_coord);
	
	point <= point_coord;
	point_valid <= point_visible(point_coord);
	

end architecture fsm;