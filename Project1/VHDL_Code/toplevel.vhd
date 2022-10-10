library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.project_pkg.all;

entity ro_puf is
end entity ro_puf is;

architecture reset of ro_puf is 
begin
process is 
    
assert reset = --;

--provide challenge to the ro_puf entity (still need this part of code)

end process;
end architecture;

entity ro_puf is
begin

process
assert enable = --;
wait for probe_delay µs; 



