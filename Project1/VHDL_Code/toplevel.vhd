library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;

library work;
use work.project_pkg.all;

entity ro_puf is
end entity ro_puf;

architecture reset of ro_puf is 
begin
demonstration: process is 
    
assert reset = -- need reset value

--provide challenge to the ro_puf entity (still need this part of code)

end process;
end architecture;

architecture enable of ro_puf is 
begin
demonstration: process is
    variable out_line: line;
  begin
     for i in 0 to 10 loop -- not sure what range loop is. 13? 
			write(out_line, "now looping on number " & integer'image(i));
			writeline(output, out_line);
			-- the condition must be false for the assertion to trigger!
			assert enable /= 3 report "we have reached value 3" severity note; --need to change assert value
			wait for 1 ns;
		end loop; 
wait for probe_delay µs; --need probe delay



