library ieee;
use ieee.std_logic_1164.all;

library work;
use work.project_pkg.all;

entity toplevel is
	port (		
		reset:		in	std_logic;
		clock:		in	std_logic;
		
		v_sync_out:		out	std_logic;
		h_sync_out:		out	std_logic;
		
		-- 4 bits per color output
		red_out: out std_logic_vector(3 downto 0);
		green_out: out std_logic_vector(3 downto 0);
		blue_out: out std_logic_vector(3 downto 0)
	);
	
end entity toplevel;

architecture arch of toplevel is

begin
	-- output, incomplete right now
	vfsm: vga_fsm
		port (
			
			vga_clock:		=> clock
			reset:			=> reset

			point:			=> -- add
			point_valid:	=> -- add

			h_sync:			=> h_sync_out;
			v_sync:			=> v_sync_out;
		);
	-- make an instance of pll, inclk takes 50 Mhz (from clock) , clk output to all other designs
	-- color output transmit data to screen, compute set first, then draw it, to draw we send color data out of the 12 color lines

end architecture arch;