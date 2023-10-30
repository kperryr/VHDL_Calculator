library ieee;
use ieee.std_logic_1164.all;

--  A testbench has no ports.
entity reg_tb is
end reg_tb;

architecture behav of reg_tb is
--  Declaration of the component that will be instantiated.
component reg8
port (		--rs1,rs2,ws        : in std_logic_vector (1 downto 0);
	        I        : in std_logic_vector (7 downto 0);
		clk,EN,oflow      : in std_logic;
		O          : out std_logic_vector(7 downto 0) 
);
end component;
--  Specifies which entity is bound with the component.
for reg8_0: reg8 use entity work.reg8(behav);
signal I,O 	: std_logic_vector(7 downto 0);
signal EN,oflow	: std_logic;
signal CLK		: std_logic := '1';

begin
	process
	begin
		CLK <= not CLK;
		wait for 2 ns;
	end process;	
--  Component instantiation.
reg8_0: reg8 port map (		I => I, 
				EN => EN, 
				clk => CLK,
			        oflow => oflow,	
				O => O);

--  This process does the real job.
process
type pattern_type is record
--  The inputs of the reg8.
I : std_logic_vector (7 downto 0);
EN  :std_logic;
oflow : std_logic;
--  The expected outputs of the reg8.
O : std_logic_vector (7 downto 0);
end record;
--  The patterns to apply.
type pattern_array is array (natural range <>) of pattern_type;
constant patterns : pattern_array := --WRONG test vectors. replace with your own.
(
-- overflow isnt detected
("00000010", '1','0', "00000000"), -- write to register with no rising edge
("00000010", '1','0', "00000010"), -- write to register at rising edge
("00000110", '0','0', "00000010"), -- write to register with no rising edge and enable = 0
("00000110", '0','0', "00000010"), -- write to register at rising edge and enable = 0
("00000011", '1','0', "00000010"), -- write to register with no rising edge
("00000011", '1','0', "00000011"), -- write to register at rising edge
("00000111", '0','0', "00000011"), -- write to register with no rising edge and enable = 0
("00000111", '0','0', "00000011"),  -- write to register at rising edge and enable = 0

--overflow is detected : no writing should occur
("00000010", '1','1', "00000011"), -- try to write to register with no rising edge
("00000010", '1','1', "00000011"), -- try to write to register at rising edge
("00000110", '0','1', "00000011"), -- try to write to register with no rising edge and enable = 0
("00000110", '0','1', "00000011"), -- try to write to register at rising edge and enable = 0
("00000011", '1','1', "00000011"), -- try to write to register with no rising edge
("00000011", '1','1', "00000011"), -- try to write to register at rising edge
("00000111", '0','1', "00000011"), -- try to write to register with no rising edge and enable = 0
("00000111", '0','1', "00000011")  -- try to write to register at rising edge and enable = 0

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
assert O = patterns(n).O

report "bad output value" severity error;
end loop;
assert false report "end of test" severity note;
--  Wait forever; this will finish the simulation.
wait;
end process;
end behav;
