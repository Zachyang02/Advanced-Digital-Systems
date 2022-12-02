library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.project_pkg.all;
use work.seven_segment_pkg.all;

entity top_level is
	port(	
			clock_10: in std_logic;
			clock_50: in std_logic;
			reset:	in	std_logic;
			hex_digit:	out	seven_segment_output
);


end top_level;


architecture Behavioral of top_level is
signal pll_clock_out:	std_logic;
signal clock_adc:			std_logic;
signal en_write:		boolean;
signal head_ptr_10, tail_ptr_10:		natural range 0 to 7;
signal head_ptr_50, tail_ptr_50:		natural range 0 to 7;

signal head_ptr_50_v, tail_ptr_10_v: std_logic_vector(2 downto 0);

signal data_segment:		std_logic_vector(23 downto 0);
signal adc_data:		std_logic_vector(11 downto 0);

signal en_write_logic: std_logic;
	
begin

	en_write_logic <= '1' when en_write else '0';
	-- make an instance of pll, inclk takes 10 Mhz (from clock) and outputs 10 mhz to adc
	pll_inst : pll PORT MAP (
		inclk0	 => clock_10,
		c0	 => pll_clock_out 
	);
	--pll_clock_out <= clock_10;

	
	--instance of ram 
	ram_inst : true_dual_port_ram_dual_clock
	generic map(
	DATA_WIDTH => 12,
	ADDR_WIDTH => 6
	)
	port map (
		clk_a		=> clock_adc,
		clk_b		=>	clock_50,
		addr_a	=> head_ptr_10,
		addr_b	=> tail_ptr_50,
		data_a	=> adc_data,
		data_b	=> (others => '0'),
		we_a	   => en_write_logic,
		we_b		=> '0',
		q_a		=> open,
		q_b		=> data_segment(11 downto 0)
	);
	
	data_segment(23 downto 12) <= (others => '0');
	
	--instance of control_head
	control_head_inst	:	control_head port map(
	  en_write	=> en_write,
	  clock_in	=>	pll_clock_out,
	  reset		=>	reset,
	  tail		=> tail_ptr_10,
	  head_ptr	=> head_ptr_10,
	  data		=>	adc_data,
	  clock_adc	=> clock_adc
	  );
	
	
	--instance of control_tail
	control_tail_inst	:	control_tail port map(
		en_read	=>	open,
		clock		=>	clock_50,
		reset		=>	reset,
		head		=> head_ptr_50,
		tail_ptr	=>	tail_ptr_50
	);
	
	
	--instance of first clock_crossing
	clock_crossing_10_to_50:	clock_crossing 
	generic map(size => 3)
	port map (
		bin_in	=> std_logic_vector(to_unsigned(head_ptr_10, 3)),
	   bin_out	=> head_ptr_50_v,
		clk1		=> clock_adc,
		clk2		=> clock_50,
		rst		=> reset
	);
	head_ptr_50 <= to_integer(unsigned(head_ptr_50_v));
	
	
	
	--instance of second clock_crossing
	clock_crossing_50_to_10:	clock_crossing
	generic map(size => 3)
	port map (
		bin_in	=> std_logic_vector(to_unsigned(tail_ptr_50, 3)),
	   bin_out	=> tail_ptr_10_v,
		clk1		=> clock_50,
		clk2		=> clock_adc,
		rst		=> reset
	);
	tail_ptr_10 <= to_integer(unsigned(tail_ptr_10_v));
	
	assign_output: for digit in seven_segment_output'range generate
		hex_digit(digit) <= get_hex_digit(to_integer(unsigned(data_segment(4*digit + 3 downto 4*digit))));
	end generate assign_output;

end Behavioral;




