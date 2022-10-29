library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

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
	signal z_re_squared: ads_sfixed;
	signal z_im_squared: ads_sfixed;
	signal z_re_times_im: ads_sfixed;

begin
	z_re_squared <= in_z.re * in_z.re;
	z_im_squared <= in_z.im * in_z.im;
	z_re_times_im <= in_z.re * in_z.im;
	
	out_z.re <= z_re_squared - z_im_squared + in_c.re;
	out_z.im <= in_c.im + to_ads_sfixed(to_signed(z_re_times_im) sll 1);

	out_ov <= '1' when ((in_ov = '1') or (z_re_squared + z_im_squared) > threshold) else '0';

	out_c <= in_c;
	out_stage <= in_stage when in_ov = '1' else stage_number;	

end architecture mgen;