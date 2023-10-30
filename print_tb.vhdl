library ieee;
use ieee.std_logic_1164.all;

--  A testbench has no ports.
entity print_tb is
end print_tb;

architecture behav of print_tb is
--  Declaration of the component that will be instantiated.
component print is
port (          I              : in std_logic_vector (7 downto 0);
		clk,EN,oflow   : in std_logic
);
end component;

--  Specifies which entity is bound with the component.
for print_0: print use entity work.print(behav);
signal I         	: std_logic_vector(7 downto 0);
signal EN, oflow 	: std_logic;
signal CLK		: std_logic := '1';

begin
	process
	begin
		CLK <= not CLK;
		wait for 2 ns;
	end process;	

--  Component instantiation.
print_0: print port map (	I => I, 
				EN => EN, 
				clk => CLK, 
				oflow => oflow);

--  This process does the real job.
process
type pattern_type is record
--  The inputs of the print.
I : std_logic_vector (7 downto 0);
EN, oflow  :std_logic;
end record;

--  The patterns to apply.
type pattern_array is array (natural range <>) of pattern_type;
constant patterns : pattern_array := 
(

("00000001", '0', '0'), -- no print should occur
("00000001", '0', '0'), -- no print should occur en = 0
("00000001", '1', '0'), -- no print should occur
("00000001", '1', '0'), -- print "   1"
("11111111", '0', '0'), -- no printing should occur
("11111111", '0', '0'), -- no printing should occur en = 0
("11111111", '1', '0'), -- no printing should occur
("11111111", '1', '0'), -- print "  -1"
("00000011", '0', '1'), -- no printing should occur
("00000011", '0', '1') -- print overflow error

-- note: oflow and print_en will never be '1' at the same time due to ALU operations
-- so it is not included in testbench
); 

begin
--  Check each pattern.
for n in patterns'range loop
--  Set the inputs.
I  <= patterns(n).I;
EN <= patterns(n).EN;
oflow <= patterns(n).oflow;

--  Wait for the results.

wait for 2 ns;
--  Check the outputs.
--only three messages should be printed out
end loop;
assert false report "end of test" severity note;
--  Wait forever; this will finish the simulation.
wait;
end process;
end behav;
