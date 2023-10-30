library ieee;
use ieee.std_logic_1164.all;

--  A testbench has no ports.
entity inst_tb is
end inst_tb;

architecture behav of inst_tb is
--  Declaration of the component that will be instantiated.
component inst_fet
port( 		data_in        : in std_logic_vector(7 downto 0); --8 bit instruction code from user input
		op_out         : out std_logic_vector(2 downto 0); -- decoded 3-bit  op code from user input
		rs,rt,rd,addr  : out std_logic_vector(1 downto 0); -- registers fro reg file and label (write data)
		imm            : out std_logic_vector(3 downto 0)  --immediate entry
);
end component;

-- signals that connect to component 
signal DATA_IN : std_logic_vector(7 downto 0);
signal OP_OUT : std_logic_vector(2 downto 0);
signal RS,RT,RD,ADDR : std_logic_vector(1 downto 0);
signal IMM : std_logic_vector(3 downto 0);
begin
--  Component instantiation.
	inst_fet_0: entity work.inst_fet(behav)
	port map (data_in => DATA_IN, op_out => OP_OUT, rs => RS, rt => RT, rd => RD, addr => ADDR, imm => IMM );

--  This process does the real job.
process
type pattern_type is record
--  The inputs of the inst_fet.
DATA_IN : std_logic_vector(7 downto 0);
--  The expected outputs of the inst_fet.
OP_OUT : std_logic_vector(2 downto 0);
RS,RT,RD,ADDR : std_logic_vector(1 downto 0);
IMM : std_logic_vector(3 downto 0);
end record;
--  The patterns to apply.
type pattern_array is array (natural range <>) of pattern_type;
constant patterns : pattern_array := 
(("00000000", "000", "00","00","00","00", "0000"), --000 opcode output
("00101010", "100", "10","10","10","10", "1010"), -- 100 opcode output
("01001100", "001", "11","00","00","00", "1100"), --001 opcode output 
("11111111", "011", "11","11","11","11", "1111"), --011 opcode output 
("10000000", "010", "00","00","00","00", "0000")); --010 opcode output 

begin
--  Check each pattern.
for n in patterns'range loop
--  Set the inputs.
DATA_IN <= patterns(n).DATA_IN;
--  Wait for the results.
wait for 1 ns;
--  Check the outputs.
assert OP_OUT = patterns(n).OP_OUT;
assert RS = patterns(n).RS;
assert RT = patterns(n).RT;
assert RD = patterns(n).RD;
assert ADDR = patterns(n).ADDR;
assert IMM = patterns(n).IMM

report "bad output value" severity error;
end loop;
assert false report "end of test" severity note;
--  Wait forever; this will finish the simulation.
wait;
end process;
end behav;
