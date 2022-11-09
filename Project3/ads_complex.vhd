---- this file is part of the ADS library

library ads;
use ads.ads_fixed.all;

package ads_complex_pkg is
	-- complex number in rectangular form
	type ads_complex is
	record
		re: ads_sfixed;
		im: ads_sfixed;
	end record ads_complex;

	---- functions

	-- make a complex number
	function ads_cmplx (
			re, im: in ads_sfixed
		) return ads_complex;

	-- returns l + r
	function "+" (
			l, r: in ads_complex
		) return ads_complex;

	-- returns l - r
	function "-" (
			l, r: in ads_complex
		) return ads_complex;

	-- returns l * r
	function "*" (
			l, r: in ads_complex
		) return ads_complex;

	-- returns the complex conjugate of arg
	function conj (
			arg: in ads_complex
		) return ads_complex;

	-- returns || arg || ** 2
	function abs2 (
			arg: in ads_complex
		) return ads_sfixed;

	-- constants
	constant complex_zero: ads_complex :=
					ads_cmplx(to_ads_sfixed(0), to_ads_sfixed(0));

end package ads_complex_pkg;

package body ads_complex_pkg is

	-- function implementations
		function ads_cmplx (
			re, im: in ads_sfixed
		) return ads_complex
	is
		variable ret: ads_complex;
	begin
		ret.re := re;
		ret.im := im;
		return ret;
	end function ads_cmplx;

	-- this is for "+"
	function "+" (
			l, r: in ads_complex
		) return ads_complex
	is
		variable ret: ads_complex;
	begin
		ret.re := l.re + r.re;
		ret.im := l.im + r.im;
		return ret;
	end function "+";
	

	-- implement all other functions here
	-- this is for "-"
	function "-" (
			l, r: in ads_complex
		) return ads_complex
	is
		variable ret: ads_complex;
	begin
		ret.re := l.re - r.re;
		ret.im := l.im - r.im;
		return ret;
	end function "-";
	
	-- this is for "*"
	function "*" (
			l, r: in ads_complex
		) return ads_complex
	is
		variable ret: ads_complex;
	begin
		ret.re := l.re * r.re;
		ret.im := l.im * r.im;
		return ret;
	end function "*";
	
	-- complex conjugate
	function conj (
			arg: in ads_complex
		) return ads_complex
	is
		variable ret: ads_complex;
	begin
		-- conjugate is just the imaginary sign flip
		ret.im := -arg.im;
		ret.re := arg.re;
		return ret;
	end function conj;
	
	-- absolute square
		function abs2 (
			arg: in ads_complex
		) return ads_sfixed
	is
		variable ret: ads_complex;
	begin
		return arg.re * arg.re + arg.im * arg.im;
	end function abs2;
	
end package body ads_complex_pkg;