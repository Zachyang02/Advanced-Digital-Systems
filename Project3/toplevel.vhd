library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.project_pkg.all;
use work.seed_table.all;

library ads;
use ads.ads_fixed.all;
use ads.ads_complex_pkg.all;

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
	-- functions
		
	function is_at_end_of_frame(
			pt:	in	coordinate
		) return boolean
	is
	begin
		return (pt.x = vga_res_default.horizontal.active)
				and (pt.y = vga_res_default.vertical.active);
	end function is_at_end_of_frame;

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
	signal point_std_logic, point_std_logic_out: std_logic;
	signal point_valid: boolean;
	signal clock_out: std_logic;
	signal point_current: coordinate;
	signal iteration_count: natural;
	
	signal seed: ads_complex;
	
	signal vga_h_sync: std_logic;
	signal vga_v_sync: std_logic;
	
	type color_type is
	record
		r: std_logic_vector(3 downto 0);
		g: std_logic_vector(3 downto 0);
		b: std_logic_vector(3 downto 0);
	end record color_type;
	
	type color_map_type is array(natural range<>) of color_type;
	constant color_map: color_map_type := (
			( r => "0000", g => "0000", b => "1111" ),
			( r => "0001", g => "0001", b => "1111" ),
			( r => "0010", g => "0010", b => "1111" ),
			( r => "0011", g => "0011", b => "1111" ),
			( r => "0100", g => "0100", b => "1111" ),
			( r => "0101", g => "0101", b => "1111" ),
			( r => "0110", g => "0110", b => "1111" ),
			( r => "0111", g => "0111", b => "1111" ),
			( r => "1000", g => "1000", b => "1111" ),
			( r => "1001", g => "1001", b => "1111" ),
			( r => "1010", g => "1010", b => "1111" ),
			( r => "1011", g => "1011", b => "1111" ),
			( r => "1100", g => "1100", b => "1111" ),
			( r => "1101", g => "1101", b => "1111" ),
			( r => "1110", g => "1110", b => "1111" ),
			( r => "1111", g => "1111", b => "1111" ),
			-- ( r => "1111", g => "1111", b => "1111"),
			( r => "1111", g => "1111", b => "1110"),
			( r => "1111", g => "1111", b => "1101"),
			( r => "1111", g => "1111", b => "1100"),
			( r => "1111", g => "1111", b => "1011"),
			( r => "1111", g => "1111", b => "1010"),
			( r => "1111", g => "1111", b => "1001"),
			( r => "1111", g => "1111", b => "1000"),
			( r => "1111", g => "1111", b => "0111"),
			( r => "1111", g => "1111", b => "0110"),
			( r => "1111", g => "1111", b => "0101" ),
			( r => "1111", g => "1111", b => "0100" ),
			( r => "1111", g => "1111", b => "0011" ),
			( r => "1111", g => "1111", b => "0010" ),
			--( r => "1111", g => "1111", b => "0001" ),
			--( r => "1111", g => "1111", b => "0000" ),
			( r => "0000", g => "0000", b => "0000" )
		);
		
	signal seed_index: seed_index_type;
		
begin
	-- seed selection
	seed_select: process (clock) is
	begin
		if rising_edge(clock) then
			if reset = '0' then
				seed_index <= 0;
			elsif is_at_end_of_frame(point_current) then 
				seed_index <= get_next_seed_index(seed_index);
			end if;
		end if;
	end process seed_select;

	-- sync signals
	sr0: shift_register
		generic map (
			sr_depth => color_map'high
		)
		port map (
			clk => clock_out,
			rst => reset,
				
			sr_in => vga_h_sync,
			sr_out => h_sync_out
		);
		
	sr1: shift_register
		generic map (
			sr_depth => color_map'high
		)
		port map (
			clk => clock_out,
			rst => reset,
				
			sr_in => vga_v_sync,
			sr_out => v_sync_out
		);
	
	point_std_logic <= '1' when point_bool else '0';
	point_valid <= point_std_logic_out = '1';
	sr2: shift_register
		generic map (
			sr_depth => color_map'high
		)
		port map (
			clk => clock_out,
			rst => reset,
				
			sr_in => point_std_logic,
			sr_out => point_std_logic_out
		);

	-- output
	vfsm: vga_fsm
		port map (
			
			vga_clock		=> clock_out,
			reset			=> reset,

			point			=> point_current,
			point_valid	=> point_bool,

			h_sync			=> vga_h_sync,
			v_sync			=> vga_v_sync
		);
	
	process (clock_out) is
	begin
	if rising_edge(clock_out) then
	seed <= (
			re => to_ads_sfixed(x_range.min) + dx * to_ads_sfixed((point_current.x)),
			im => to_ads_sfixed(y_range.max) - dy * to_ads_sfixed((point_current.y))
		);
	end if;
	end process;
	
	-- generator
	generator: mandelbrot_pipeline
		generic map (
			stages_total => color_map'high + 1,
			threshold => to_ads_sfixed(4)
		)
		port map (
			
			clock => clock_out,
			reset => reset,
			z_seed => seed,
			c_seed => seed_rom(seed_index),
			iteration_count => iteration_count
			
	);
		
	-- make an instance of pll, inclk takes 50 Mhz (from clock) , clk output to all other designs
	pll_inst : pll PORT MAP (
		inclk0	 => clock,
		c0	 => clock_out 
	);
	 
	
	-- color output transmit data to screen, compute set first, then draw it, to draw we send color data out of the 12 color lines
	red_out <= color_map(iteration_count).r when point_valid else "0000";
	green_out <= color_map(iteration_count).g when point_valid else "0000";
	blue_out <= color_map(iteration_count).b when point_valid else "0000";

	
	
	
	
	
	
	
--	red_out <= std_logic_vector(to_unsigned(iteration_count, 4)) when point_valid else "0000";
--	green_out <= "0000";
--	blue_out <= "0000";
	
end architecture arch;