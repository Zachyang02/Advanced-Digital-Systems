library ieee;
use ieee.std_logic_1164.all;






package project_pkg is


	--bin_to_gray component
	component bin_to_gray is
	generic(
			input_width:			positive := 16
			);
	port(
		bin_in:		in		std_logic_vector(input_width -1 downto 0);
		gray_out:	out	std_logic_vector(input_width -1 downto 0)
				);
		end component bin_to_gray;

	--gray_to_bin component
	
	component gray_to_bin is
	generic(input_width:		positive := 16);
	port(gray_in: in std_logic_vector(input_width - 1 downto 0);
		bin_out: out std_logic_vector(input_width - 1 downto 0)
		);
		end component gray_to_bin;

	--pll component
	component pll is
	port(
		inclk0		: IN STD_LOGIC  := '0';
			c0		: OUT STD_LOGIC 
	);
	end component pll;
	
	
	--clock_crossing component
	
	component clock_crossing is
	generic(size : natural := 8);
	port(	bin_in:	in		std_logic_vector (size -1 downto 0);
			bin_out:	out	std_logic_vector (size -1 downto 0);
			clk1:		in		std_logic;
			clk2:		in		std_logic;
			rst:		in		std_logic
	);
	end component clock_crossing;
	
	
	-- ram component
	
	component true_dual_port_ram_dual_clock is
	generic 
	(
		DATA_WIDTH : natural := 12;
		ADDR_WIDTH : natural := 6
	);
	port 
	(
		clk_a	: in std_logic;
		clk_b	: in std_logic;
		addr_a	: in natural range 0 to 2**ADDR_WIDTH - 1;
		addr_b	: in natural range 0 to 2**ADDR_WIDTH - 1;
		data_a	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		data_b	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		we_a	: in std_logic := '1';
		we_b	: in std_logic := '1';
		q_a		: out std_logic_vector((DATA_WIDTH -1) downto 0);
		q_b		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);
	end component true_dual_port_ram_dual_clock;
	
	
	
	-- control_head component
	component control_head is 
	port(en_write:		out	boolean;
		  clock_in:			in		std_logic;
		  reset:			in		std_logic;
		  tail:			in		natural range 0 to 7;
		  head_ptr:		out		natural range 0 to 7;
		  data:			out	std_logic_vector( 11 downto 0);
		  clock_adc:	out	std_logic
		  );
	end component control_head;
	
	--control_tail component
	component control_tail is
	port(	en_read:		out		boolean;
		clock:		in			std_logic;
		reset:		in			std_logic;
		head:			in			natural range 0 to 7;
		tail_ptr:	out		natural range 0 to 7
		);
	end component control_tail;
	
	
	
	
	end package;
	
	package body project_pkg is
	
	end package body project_pkg;

