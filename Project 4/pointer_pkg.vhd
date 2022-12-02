	library ieee;
	use ieee.std_logic_1164.all;
	
	
	
	
	package pointer_pkg is
	
	function checkstate_h (
			head: in natural range 0 to 7;
			tail: in natural range 0 to 7
			) return boolean;
	
	function checkstate_t (
			head: in natural range 0 to 7;
			tail: in natural range 0 to 7
			) return boolean;
	
	
	
	end package pointer_pkg;
	
	
	
	package body pointer_pkg is
	
	function checkstate_h(	head:	natural range 0 to 7;
									tail:	natural range 0 to 7)
					return boolean is
						variable flag_h: boolean;
		begin
							
				if((head > tail) and (not(head = 7 and tail = 0))) then
						flag_h := True;
							if((tail > head) and (tail - head > 1)) then
								flag_h := True;
							else
								flag_h := False;							
			end if;
	end if;

		return flag_h;
end function;
	
	
	function checkstate_t(	head:	natural range 0 to 7;
								tail:	natural range 0 to 7)
	return boolean is
			variable flag_t: boolean;
	begin
							
	if (head > tail) and (head - tail > 1) then
		flag_t := True;
	elsif (head < tail) and (not(head = 0 and tail = 7)) then
		flag_t := True;
	else
		flag_t := False;
	end if;	
		
	return flag_t;
end function;




end package body pointer_pkg;

	
	