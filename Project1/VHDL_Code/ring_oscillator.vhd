library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ring_oscillator is
    generic (
        -- ring oscillator length parameter
		  chain_size : positive := 14);
    port (
        enable:        in    std_logic;
        osc_out:    out    std_logic
    );
end entity ring_oscillator;

--In the architecture of the body, you should use a generate statement

architecture rtl of ring_oscillator is
    -- one signal that will contain the input of all inverters based on the ring oscillator length generic parameter	
	 signal invert_out: std_logic_vector(chain_size - 1 downto 0);
	 
	 -- REMEMBER: back to back oscillators cancel one another, the tool will try to simplify it! Tell it to keep your signals!
	 attribute keep : boolean;
	 attribute keep of invert_out : signal is true;
	 
begin
    -- assign to osc_out the output of the last inverter
	osc_out <= invert_out(chain_size - 1);
	
    -- a nand gate, you can use the `nand' operator
	invert_out(0) <= enable nand invert_out(chain_size -1);
	
	-- Check if N is even, if odd then fail
	 assert (chain_size rem 2) = 1
		report "invalid chain size" severity error;
		
    ro: for i in 1 to chain_size - 1 generate
        -- assign so that the input of the next inverter in the chain is the output of the current inverter
		  invert_out(i) <= not invert_out(i - 1);
	 
    end generate ro;
	 
end architecture rtl;