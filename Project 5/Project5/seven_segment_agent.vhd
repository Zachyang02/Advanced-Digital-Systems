library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.seven_segment_pkg.all;

entity seven_segment_agent is
generic(	lamp_mode:			lamp_configuration := common_anode;
			decimal_support:	boolean := true;
			implementer:		natural range 1 to 255 := 255;
			revision:			natural	range 0 to 255 := 0
			);

port(		clk:			in		std_logic;
			reset_n:		in		std_logic;
			address:		in		std_logic_vector(1 downto 0);
			read:			in		std_logic;
			readdata:	out	std_logic_vector(31 downto 0);
			write:		in		std_logic;
			writedata:	in		std_logic_vector(31 downto 0);
			lamps:			out	std_logic_vector(41 downto 0)
			);

end entity seven_segment_agent;


architecture rtl of seven_segment_agent is
signal data:		std_logic_vector(31 downto 0);
signal control:	std_logic_vector(31 downto 0);

constant magic_number :	natural := 16#41445335#;
 
function to_vector ( arr:	seven_segment_output)
		return std_logic_vector is
		variable concatenated_result:	std_logic_vector(41 downto 0);
		begin
			for i in 0 to 5 loop
				concatenated_result(7*i+6 downto 7*i) := arr(i).g & arr(i).f & arr(i).e & arr(i).d & arr(i).c & arr(i).b & arr(i).a;
			end loop;
			return concatenated_result;
		end function;
		
		function get_features
			return std_logic_vector
		is
			variable feature: std_logic_vector(31 downto 0);
		begin
		feature := (others => '0');
		
		feature(31 downto 24) := std_logic_vector(to_unsigned(implementer, 8));
		feature(23 downto 16) := std_logic_vector(to_unsigned(revision, 8));
		if default_lamp_config = common_anode then
			feature(3 downto 3) := "1";
		end if;
		
		
		if decimal_support = true then
			feature(0 downto 0) := "1";
		end if;
		
		return feature;
		end function get_features;
		
		
		function to_bcd (
			data_value:	in	std_logic_vector(15 downto 0)
			) return std_logic_vector
			is
				variable ret:	std_logic_vector(19 downto 0);
				variable temp:	std_logic_vector(data_value'range);
			begin
				temp := data_value;
				ret := (others => '0');
				for i in data_value'range loop
					for j in 0 to ret'length/4 -1 loop
						if unsigned(ret(4*j + 3 downto 4*j)) >= 5 then
							ret(4*j + 3 downto 4*j) := 
								std_logic_vector(
									unsigned(ret(4*j + 3 downto 4 * j)) +3);
						end if;
					end loop;
					ret := ret(ret'high - 1 downto 0) & temp(temp'high);
					temp := temp(temp'high - 1 downto 0) & '0';
				end loop;
				return ret;
			end function to_bcd;

		signal hex_digits: seven_segment_output;
			
begin
	lamps <= to_vector(hex_digits);

	output_process: process(data, control) is
		variable bcd_value: std_logic_vector(23 downto 0);
	begin
		bcd_value(23 downto 20) := (others => '0');
		bcd_value(19 downto 0) := to_bcd(data(15 downto 0));
		
		if control(0) = '1' then
			for digit in seven_segment_output'range loop
				if decimal_support and control(1) = '1' then
					hex_digits(digit) <= get_hex_digit(to_integer(unsigned(bcd_value(4*digit+3 downto 4*digit))));
				else
					hex_digits(digit) <= get_hex_digit(to_integer(unsigned(data(4*digit + 3 downto 4*digit))));
				end if;
			end loop;
		else
			for digit in seven_segment_output'range loop
				hex_digits(digit) <= lamps_off(lamp_mode);
			end loop;
		end if;
	
	end process;

	process(clk) is
	begin
		if rising_edge(clk) then
			if reset_n = '0' then
				data <= (others => '0');
				control <= (others => '0');
			
			elsif read = '1' then
				case address is
			
			when "00" => readdata <= data;
			when "01" => readdata <= control;
			when "10" => readdata <= get_features; 
			when "11" => readdata <= std_logic_vector(to_unsigned(magic_number, 32));
			when others => null;
				end case;
			
			elsif write = '1' then
				case address is
			
			when "00" => data <= writedata;
			when "01" =>
					control(31 downto 2) <= (others => '0');
					if decimal_support = true then
						control(1) <= writedata(1);
					else
						control(1) <= '0';
					end if;
					control(0) <= writedata(0);
			when others => null;
		
				end case;
		
			end if;
		end if;
	end process;
end architecture rtl;