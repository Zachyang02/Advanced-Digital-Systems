library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.project_pkg.all;

entity ro_puf is
    generic (
        -- ring oscillator length parameter and amount of oscillator
		  ro_length : positive := 14;
		  ro_count : positive := 16
	 );
    port (
        reset:      in    std_logic;
        enable:     in    std_logic;
		  challenge:  in    std_logic;
		  response:   out   std_logic
    );
end entity ro_puf;

architecture puf of ro_puf is

	 
begin

	 
end architecture puf;