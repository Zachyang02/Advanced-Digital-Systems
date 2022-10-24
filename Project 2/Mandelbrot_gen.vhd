library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity gen is
    port (

    );
end entity gen;

--In the architecture of the body, you should use a generate statement

architecture mgen of Mandelbrot_gen is
    -- signals
	 
begin


function algorithm1 (c	: ads_complex:
				iterations	: natural )
	return ads_complex is variable result; 

		begin
			 z <= 0;
			iteration <= 0;
			
			while iteration < iterations loop 
				z <= (z * z) + c ;
					if abs2(z) > 2 then
						exit;
					end if;
				 iteration <= iteration + 1;
			end while;
end function algorithm1;
	 
end architecture mgen;
