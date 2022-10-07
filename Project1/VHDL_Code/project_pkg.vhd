library ieee;
use ieee.std_logic_1164.all;

package project_pkg is
	-- ring oscillator component
	component ring_oscillator is
		generic (
			chain_size: positive := 14 - 1
		);
		port (
        enable:     in    std_logic;
        osc_out:    out    std_logic
		);
	end component ring_oscillator;

end package;

package body project_pkg is
end package body project_pkg;