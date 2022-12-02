library ieee;
use ieee.std_logic_1164.all;

use work.pointer_pkg.all;


entity control_tail is 
port(	en_read:		out		boolean;
		clock:		in			std_logic;
		reset:		in			std_logic;
		head:			in			natural range 0 to 7;
		tail_ptr:	out		natural range 0 to 7
);


end entity control_tail;

architecture rtl of control_tail is
signal tail:	natural range 0 to 7;

type micro_code is record
	have_data_m:	std_logic;
	advance_tail:		std_logic;

end record micro_code;

type micro_array is array (natural range <>) of micro_code;

constant micro_table: micro_array  := (
		(have_data_m => '0', advance_tail => '0'),	-- wait
		(have_data_m => '1' , advance_tail => '1')	-- advance
	);

	subtype upc_type is natural range micro_table'range;
	signal upc: upc_type;
	signal uinstruction: micro_code;
	
	
begin
	tail_ptr <= tail;
	uinstruction <= micro_table(upc);
	
	sequencer: process (clock, reset) is
	begin
	if reset = '0' then
			upc <= 0;
		elsif rising_edge(clock) then
			if  checkstate_t(head,tail) or uinstruction.have_data_m = '1' then
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


	increment_tail: process(clock) is
	begin
		--if reset = '0' then
		--	tail <= 7;
		if rising_edge(clock) then
			if reset = '0' then
				tail <= 7;
			elsif uinstruction.advance_tail = '1' then
				if tail = 7 then
					tail <= 0;
				else
					tail <= tail + 1;
				end if;
			end if;
		end if;
	end process increment_tail;

end architecture rtl;