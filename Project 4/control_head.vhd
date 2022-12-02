library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- make adc component
use work.pointer_pkg.all;

entity control_head is 
port(en_write:		out	boolean;
	  clock_in:		in		std_logic;
	  reset:			in		std_logic;
	  tail:			in		natural range 0 to 7;
	  head_ptr:		out	natural range 0 to 7;
	  data:			out	std_logic_vector(11 downto 0);
	  clock_adc:	out	std_logic
	  );


end entity control_head;

architecture rtl of control_head is
signal head:	natural range 0 to 7;

component max10_adc
PORT
(
		pll_clk:	in	std_logic;
		chsel:		in	natural range 0 to 2**5 - 1;
		soc:		in	std_logic;
		tsen:		in	std_logic;
		dout:		out	natural range 0 to 2**12 - 1;
		eoc:		out	std_logic;
		clk_dft:	out	std_logic
		);
end component max10_adc;


type states is record
eoc_m:			std_logic;
have_room_m:	std_logic;
soc:				std_logic;
write_data:		std_logic;

end record states;

type state_array is array (natural range <>) of states;


constant state_table: state_array  := (
	(eoc_m => '1', have_room_m => '1', soc => '1', write_data => '0'),	-- start
	(eoc_m => '0', have_room_m => '1', soc => '1', write_data => '0'),	-- wait for eoc
	(eoc_m => '1', have_room_m => '0', soc => '0', write_data => '0'),	-- wait for room
	(eoc_m => '1', have_room_m => '1', soc => '0', write_data => '1')		-- write data
	);
	subtype upc_type is natural range state_table'range;
	signal upc: upc_type;
	signal uinstruction: states;
	signal eoc:		std_logic;
	signal soc:			std_logic;
	function checkstate_h(	head_pointer:	natural range 0 to 7;
							tail_pointer:	natural range 0 to 7)
							return boolean is
							variable flag_h: boolean;
							begin
							
							if((head_pointer > tail_pointer) and (not(head_pointer = 7 and tail_pointer = 0))) then
									flag_h := True;
							elsif((tail_pointer > head_pointer) and (tail_pointer - head_pointer > 1)) then
									flag_h := True;
							else
								flag_h := False;							
							end if;
		return flag_h;
	
	end function;

	signal clock: std_logic;
	signal adc_data: natural range 0 to 2**12 - 1;
begin
	clock_adc <= clock;
	uinstruction <= state_table(upc);
	head_ptr <= head;
	en_write <= uinstruction.write_data = '1';

	data <= std_logic_vector(to_unsigned(adc_data, 12));
	
	sequencer: process(clock, reset) is
	begin
		if reset = '0' then
			upc <= 0;
		elsif rising_edge(clock) then
			if (uinstruction.eoc_m or eoc) = '1' and (uinstruction.have_room_m = '1' or checkstate_h(head,tail))  then
				if upc = upc_type'high then
					upc <= 0;
				else
					upc <= upc + 1;
				end if;
			else
				upc <= upc;
			end if;
		end if;
	end process sequencer;

	increment_head: process(clock, reset) is
	begin
		if reset = '0' then
			head <= 0;
		elsif rising_edge(clock) then
			if uinstruction.write_data = '1' then
				if head = 7 then
					head <= 0;
				else
					head <= head + 1;
				end if;
			end if;
		end if;
	end process increment_head;
	
	max10_adc_inst : max10_adc PORT MAP(
		pll_clk 	=> clock_in,
		chsel			=> 0,
		soc			=> uinstruction.soc,
		tsen			=> '1',
		dout		   => adc_data,
		eoc 			=> eoc,
		clk_dft 		=> clock
	);

end architecture rtl;