library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity gen is
    port (		in_z: in ads_complex;
			in_c: in ads_complex;
			in_ou: in std_logic;
			in_stage: in natural;
			
			out_z: out ads_complex;
			out_c: out ads_complex;
			out_ou: out std_logic;
			out_stage: out natural

    );
end entity gen;

--In the architecture of the body, you should use a generate statement

architecture mgen of Mandelbrot_gen is
    -- signals
	 
begin


z.re <= z.re * z.re;
z.im <= z.im * z.im;
z <= z.im * z.re;
out_ou <= '1' if in_ou = '1' else abs2(z) > 2; --error on this line
out_c <= in_c;
out_stage <= in_stage when in_ou = '1' else stage_number;

	
	
end function algorithm1;
	 
end architecture mgen;
