library ieee;
use ieee.std_logic_1164.all;
library work;
use work.project_pkg.all;

entity clock_crossing is
generic(size : natural := 8);
port(bin_in:	in		std_logic_vector (size -1 downto 0);
	  bin_out:	out	std_logic_vector (size -1 downto 0);
		clk1:		in		std_logic;
		clk2:		in		std_logic;
		rst:		in		std_logic
	);
end entity clock_crossing;


architecture arch of clock_crossing is
signal bin2gray_out:	std_logic_vector (size -1 downto 0);
signal gray2bin_in: 	std_logic_vector (size -1 downto 0);
signal ff:				std_logic_vector (size -1 downto 0);
signal sr1:	std_logic_vector (size -1 downto 0);
signal sr2:	std_logic_vector (size -1 downto 0);

begin

	b2g: bin_to_gray
		generic map (
		input_width	=> size
		)
		port map (
			bin_in => bin_in,
			gray_out => bin2gray_out
		);
	g2b: gray_to_bin
		generic map (
		input_width	=> size
		)
		port map (
			gray_in => sr2,
			bin_out => bin_out
		);

process(clk1, rst) 
begin
	if(rst = '0') then
		ff <= (others => '0');
	elsif(rising_edge(clk1)) then
		ff <= bin2gray_out;
	end if;
end process;
	
process(clk2, rst)
begin
	if(rst = '0') then
		sr1 <= (others => '0');
		sr2 <= (others => '0');
	elsif(rising_edge(clk2)) then
		sr1 <= ff;
		sr2 <= sr1;
	end if;
end process;
end architecture arch;