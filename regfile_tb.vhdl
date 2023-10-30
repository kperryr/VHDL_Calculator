library ieee;
use ieee.std_logic_1164.all;

--  A testbench has no ports.
entity regfile_tb is
end regfile_tb;

architecture behav of regfile_tb is
--  Declaration of the component that will be instantiated.
component regfile
port (		rs,rt,rd        : in std_logic_vector (1 downto 0);
		wd              : in std_logic_vector (7 downto 0);
		clk,WE, oflow   : in std_logic;
		rA,rB           : out std_logic_vector(7 downto 0) 
);
end component;
--  Specifies which entity is bound with the component.
for regfile_0: regfile use entity work.regfile(behav);
signal WD,RA,RB 	: std_logic_vector(7 downto 0);
signal we,oflow		: std_logic;
signal CLK		: std_logic := '1';
signal RS,RT,RD	: std_logic_vector(1 downto 0);

begin
	process
	begin
		CLK <= not CLK;
		wait for 2 ns;
	end process;	
--  Component instantiation.
regfile_0: regfile port map (	rs => RS, 
				rt => RT, 
				rd  => RD, 
				wd  => WD, 
				clk => CLK, 
				WE  => we,
			        oflow => oflow,	
				rA  => RA,
				rB  => RB);

--  This process does the real job.
process
type pattern_type is record
--  The inputs of the regfile.
wd: std_logic_vector (7 downto 0);
rs,rt,rd: std_logic_vector(1 downto 0);
WE, oflow  :std_logic;
--  The expected outputs of the regfile.
rA,rB : std_logic_vector (7 downto 0);
end record;
--  The patterns to apply.
type pattern_array is array (natural range <>) of pattern_type;
constant patterns : pattern_array := 
(
-- test intialization
-- reads are combo so clock should not interfere
-- no writing should occur
-- rs and rt read reg 0
("11111111", "00","01","00",'0','0', "00000000","00000000"), -- no rising edge and en = 0
("11111111", "00","01","00",'0','0', "00000000","00000000"), -- rising edge and en = 0
--rs and rt read reg 1
("11111111", "01","00","01",'0', '0', "00000000","00000000"), -- no rising edge and en = 0
("11111111", "01","00","01",'0', '0', "00000000","00000000"), -- rising edge and en = 0
-- rs and rt read reg 2
("11111111", "10","11","10",'0','0',  "00000000","00000000"), -- no rising edge and en = 0
("11111111", "10","11","10",'0','0',  "00000000","00000000"), -- rising edge and en = 0
-- rs and rt read reg 3
("11111111", "11","10","11",'0','0',  "00000000","00000000"), -- no rising edge and en = 0
("11111111", "11","10","11",'0','0',  "00000000","00000000"), -- rising edge and en = 0

--test writing with data set 1
-- writing should occur when rising edge and en = 1

--write to reg 0
("11111111", "00","01","00",'1', '0', "00000000","00000000"), -- no rising edge and en = 1
("11111111", "00","01","00",'1', '0', "11111111","00000000"), -- rising edge and en = 1
 -- if there is overflow no writing occurs
("11000111", "00","01","00",'1', '1', "11111111","00000000"), -- no rising edge and en = 1 and overflow detected
("11000111", "00","01","00",'1', '1', "11111111","00000000"), -- rising edge and en = 1 and overflow detected

-- write to reg 1
("11111110", "01","00","01",'1','0',  "00000000","11111111"), -- no rising edge and en = 1
("11111110", "01","00","01",'1','0',  "11111110","11111111"), -- rising edge and en = 1
  -- if there is overflow no writing occurs
("00001110", "01","00","01",'1','1',  "11111110","11111111"), -- no rising edge and en = 1 and overflow detected
("00001110", "01","00","01",'1','1',  "11111110","11111111"), -- rising edge and en = 1 and overflow detected

-- write to reg 2
("11111100", "10","11","10",'1','0',  "00000000","00000000"), -- no rising edge and en = 1
("11111100", "10","11","10",'1','0',  "11111100","00000000"), -- rising edge and en = 1
--if there is  overflow no writing occurs
("10011100", "10","11","10",'1','1',  "11111100","00000000"), -- no rising edge and en = 1 and overflow detected
("10011100", "10","11","10",'1','1',  "11111100","00000000"), -- rising edge and en = 1 and overflow detected

-- write to reg 3
("11111000", "11","10","11",'1','0',  "00000000","11111100"), -- no rising edge and en = 1
("11111000", "11","10","11",'1','0',  "11111000","11111100"), -- rising edge and en = 1
-- if there is overflow no writing occurs
("00000000", "11","10","11",'1','1',  "11111000","11111100"), -- no rising edge and en = 1 and overflow detected
("00000000", "11","10","11",'1','1', "11111000","11111100"), -- rising edge and en = 1 and oveflow detected 

-- test writing with data set 2
-- writing should occur when rising edge and en = 1

--write to reg 0
("00001111", "00","01","00",'1','0',  "11111111","11111110"), -- no rising edge and en = 1
("00001111", "00","01","00",'1','0',  "00001111","11111110"), --  rising edge and en = 1
-- if there is overflow no writing occurs
("11111111", "00","01","00",'1','1',  "00001111","11111110"), --  no rising edge and en = 1 and overflow detected
("11111111", "00","01","00",'1','1',  "00001111","11111110"), --  rising edge and en = 1 and overflow detected

--write to reg 1
("00011111", "01","00","01",'1','0',  "11111110","00001111"), -- no rising edge and en = 1 
("00011111", "01","00","01",'1','0',  "00011111","00001111"), --  rising edge and en = 1 
-- if there is overflow no writing occurs
("11111111", "01","00","01",'1','1',  "00011111","00001111"), -- no  rising edge and en = 1 and overflow detected
("11111111", "01","00","01",'1','1', "00011111","00001111"), --  rising edge and en = 1 and overflow detected

-- write to reg 2
("00111111", "10","11","10",'1','0',  "11111100","11111000"), -- no rising edge and en = 1
("00111111", "10","11","10",'1','0',  "00111111","11111000"), -- rising edge and en = 1
-- if there is overflow no writing occurs
("11111111", "10","11","10",'1','1',  "00111111","11111000"), -- no rising edge and en = 1 and overflow detected
("11111111", "10","11","10",'1','1', "00111111","11111000"), -- rising edge and en = 1 and overflow detected 

-- write to reg 3
("01111111", "11","10","11",'1','0',  "11111000","00111111"), -- no rising edge and en = 1
("01111111", "11","10","11",'1','0', "01111111","00111111"), -- rising edge and en = 1
-- if there is overflow no writing occurs
("11111111", "11","10","11",'1','1',  "01111111","00111111"), -- no rising edge and en = 1 and overflow detected
("11111111", "11","10","11",'1','1',  "01111111","00111111") -- rising edge and en = 1 and overflow detected

); 

begin
--  Check each pattern.
for n in patterns'range loop
--  Set the inputs.
rd<= patterns(n).rd;
rs<= patterns(n).rs;
rt<= patterns(n).rt;
wd<= patterns(n).wd;
WE<= patterns(n).WE;
oflow<= patterns(n).oflow;

--  Wait for the results.

wait for 2 ns;
--  Check the outputs.
assert rA = patterns(n).rA;
assert rB = patterns(n).rB

report "bad output value" severity error;
end loop;
assert false report "end of test" severity note;
--  Wait forever; this will finish the simulation.
wait;
end process;
end behav;
