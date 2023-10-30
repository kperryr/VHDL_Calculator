library ieee;
use ieee.std_logic_1164.all;

--  A testbench has no ports.
entity alu_tb is
end alu_tb;

architecture behav of alu_tb is
--  Declaration of the component that will be instantiated.
component alu
port (		rA,rB             : in std_logic_vector (7 downto 0);
		op                : in std_logic_vector (1 downto 0);
		oflow             : out std_logic;
		O                 : out std_logic_vector(7 downto 0) 
);
end component;
--  Specifies which entity is bound with the component.
for ALU_0: ALU use entity work.ALU(behav);

signal RA,RB,o : std_logic_vector(7 downto 0);
signal oflow : std_logic;
signal op : std_logic_vector(1 downto 0);

begin
--  Component instantiation.
ALU_0: ALU port map (		rA => RA, 
				rB => RB, 
				oflow => oflow, 
				op => op, 
				O =>o);

--  This process does the real job.
process
type pattern_type is record
--  The inputs of the alu.
rA,rB: std_logic_vector (7 downto 0);
op: std_logic_vector(1 downto 0);
--  The expected outputs of the alu.
oflow :std_logic;
o: std_logic_vector (7 downto 0);
end record;
--  The patterns to apply.
type pattern_array is array (natural range <>) of pattern_type;
constant patterns : pattern_array :=
(
--Test add
("00000000", "00000001",  "00",   '0', "00000001"), -- 0 + 1 no overflow
("11111111", "11111111",  "00",   '0', "11111110"), -- -1 + -1 no overflow

--Test sub
("00000001", "00000000",  "01",   '0', "00000001"), -- 1 - 0 no overflow
("00011110", "01100100",  "01",   '0', "10111010"), -- 30 - 100 no overflow

--test overflow
("10000001", "00001010",  "01",   '1', "01110111"), -- -127 - (10) overflow should occur
("10010100", "01100100",  "01",   '1', "00110000"), -- -108 - (100) overflow should occur
("01111111", "00000001",  "00",   '1', "10000000"), -- -127 + 1  overflow should occur
("01100100", "01100100",  "00",   '1', "11001000"), --  100 + 100 overflow should occur

--Test print
("00000001", "00000000",  "10",   '0', "00000001"), -- output should be equal to rA
("11111111", "00000001",  "11",   '0', "11111111") -- output should be equal to rA


); 

begin
--  Check each pattern.
for n in patterns'range loop
--  Set the inputs.
rA<= patterns(n).rA;
rB<= patterns(n).rB;
op <= patterns(n).op;

--  Wait for the results.

wait for 1 ns;
--  Check the outputs.
assert oflow = patterns(n).oflow;
assert o = patterns(n).o

report "bad output value" severity error;
end loop;
assert false report "end of test" severity note;
--  Wait forever; this will finish the simulation.
wait;
end process;
end behav;
