library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.project_pkg.all;

entity ro_puf is
begin

process
assert reset;

--provide challenge to the ro_puf entity (still need this part of code)

end process;
end;

entity ro_puf is
begin

process
assert enable;
wait for probe_delay µs; 



