library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity shift_register is 
	generic (sr_depth : integer);
	
		port(clk: in std_logic;
				rst: in std_logic;
				
				sr_in: in std_logic;
				sr_out: in std_logic);
end;



architecture slicing of shift_register is

	signal sr : std_logic_vector(sr_depth - 2 downto 0);
	
	begin
	
	process(clk)
	begin
	
		if rising_edge(clk) then
			
			
			sr <= sr(sr'high -1 downto sr'low) & sr_in;
			sr_out <= sr(sr'high);
			
			
		end if;
	end process;
end architecture slicing;
	
		
