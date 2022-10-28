library ieee;
use ieee.std_logic_1164.all;

library work;
use work.project_pkg.all;

library vga;
use vga.vga_data.all;

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

-- add to libary, goto properties, libary -> ads (ads_fixed, ads_complex)/ vga (vga_data/vga_fsm)
architecture arch of toplevel is
	-- components
	component pll
	PORT
	(
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC 
	);
	end component pll;
	
	-- signals
  	signal point_bool: 	boolean;
	signal clock_out: std_logic;
	signal point_current: coordinate; 
begin
	-- output
	vfsm: vga_fsm
		port map (
			
			vga_clock		=> clock_out,
			reset			=> reset,

			point			=> point_current,
			point_valid	=> point_bool,

			h_sync			=> h_sync_out,
			v_sync			=> v_sync_out
		);
	-- make an instance of pll, inclk takes 50 Mhz (from clock) , clk output to all other designs
	pll_inst : pll PORT MAP (
		inclk0	 => clock,
		c0	 => clock_out 
	);
	
	-- color output transmit data to screen, compute set first, then draw it, to draw we send color data out of the 12 color lines
	red_out <= "0000";
	green_out <= "1111" when point_bool else "0000";
	blue_out <= "0000";
	
end architecture arch;