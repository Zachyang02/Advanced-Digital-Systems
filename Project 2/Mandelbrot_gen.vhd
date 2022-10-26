library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library ads;
use ads.ads_fixed.all;
use ads.ads_complex_pkg.all;

entity pipeline_stage is
	generic (
		threshold: ads_sfixed := to_ads_sfixed(2);
		stage_number: natural := 0
	);

    port (		
			in_z: in ads_complex;
			in_c: in ads_complex;
			in_ov: in std_logic;
			in_stage: in natural;
			
			out_z: out ads_complex;
			out_c: out ads_complex;
			out_ov: out std_logic;
			out_stage: out natural
    );
end entity pipeline_stage ;

architecture mgen of pipeline_stage is
begin

	z.re <= z.re * z.re;
	z.im <= z.im * z.im;
	z <= z.im * z.re;
	out_ov <= '1' when (in_ov = '1' or abs2(z) > to_ads_sfixed(2)) else '0';

	out_c <= in_c;
	out_stage <= in_stage when in_ov = '1' else stage_number;	

end architecture mgen;