library ieee;
library STD;
use ieee.std_logic_1164.all;
use STD.textio.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;

-- File is the display function, prints out error if overflow occurs and value of display instruction
entity print is 

port( 		I       : in std_logic_vector(7 downto 0); --value from alu_out
		clk, EN, oflow : in std_logic -- inputs from ALU, clock and Control (print_EN)
    );
end entity;

architecture behav of print is
signal intial : integer := 0; --intialized to zero

begin
	
	intial <= to_integer(signed( I)); -- equals to input data
	
	process(clk)
	variable output_line : line;

	begin	
	
		if (rising_edge(clk)) and  (EN = '1') then --print register value
			
			write( output_line, intial, right, 4);
			writeline(output, output_line);
		elsif ( rising_edge(clk)) and (oflow = '1') then -- print overflow error
			
			write( output_line, string'("ERROR: OVERFLOW!"));
			writeline(output, output_line);
	
		end if;
	end process;

end behav;

