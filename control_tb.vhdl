library ieee;
use ieee.std_logic_1164.all;

--  A testbench has no ports.
entity control_tb is
end control_tb;

architecture behav of control_tb is
-- component declaration
component control
port( 		opcode         : in std_logic_vector(2 downto 0); -- opcode from instruction fetch
		alu_ctr        : out std_logic_vector(1 downto 0); -- ALU control switch
		dst_reg        : out std_logic; -- destination write register switch
		imm_value      : out std_logic; -- immediate value switch
		write_en       : out std_logic; -- register write enable signal
		sign_ext       : out std_logic; -- extended sign signal
		alu_src        : out std_logic; -- select switch for second ALU input
		alu_zero_A     : out std_logic; -- select switch for first ALU input
		print_en       : out std_logic -- print enable signal
);
end component;

signal OPCODE : std_logic_vector(2 downto 0);
signal DST_REG, IMM_VALUE, WRITE_EN, SIGN_EXT, ALU_SRC, ALU_ZERO_A, PRINT_EN : std_logic;
signal ALU_CTR: std_logic_vector(1 downto 0);

begin
--  Component instantiation.
	control_0: entity work.control(behav)
	port map ( opcode     => OPCODE,
		   alu_ctr    => ALU_CTR,
		   dst_reg    => DST_REG, 
		   imm_value  => IMM_VALUE, 
	           write_en   => WRITE_EN, 
		   sign_ext   => SIGN_EXT, 
		   alu_src    => ALU_SRC,
		   alu_zero_A => ALU_ZERO_A,
		   print_en   => PRINT_EN );

--  This process does the real job.
process
type pattern_type is record
--  The inputs of the shift_reg.
OPCODE : std_logic_vector(2 downto 0);
--  The expected outputs of the shift_reg.
ALU_CTR: std_logic_vector(1 downto 0);
DST_REG, IMM_VALUE, WRITE_EN, SIGN_EXT, ALU_SRC, ALU_ZERO_A,  PRINT_EN : std_logic;
end record;
--  The patterns to apply.
type pattern_array is array (natural range <>) of pattern_type;
constant patterns : pattern_array := --WRONG test vectors. replace with your own.
(("000", "00", '0', '1','1','0','1','1','0'), --000 opcode output
("001", "00", '1', '0','1','1','1','0','0'), --001 opcode output
("010", "00", '1', '1','1','0','0','1','0'), --010 opcode output
("011", "01", '1', '0','1','1','0','1','0'), --011 opcode output
("100", "10", '0', '1','0','0','1','1','1')); --100 opcode output

begin
--  Check each pattern.
for n in patterns'range loop
--  Set the inputs.
OPCODE <= patterns(n).OPCODE;
--  Wait for the results.
wait for 1 ns;
--  Check the outputs.
assert ALU_CTR = patterns(n).ALU_CTR;
assert DST_REG = patterns(n).DST_REG;
assert IMM_VALUE = patterns(n).IMM_VALUE;
assert WRITE_EN = patterns(n).WRITE_EN;
assert SIGN_EXT = patterns(n).SIGN_EXT;
assert ALU_SRC = patterns(n).ALU_SRC;
assert ALU_ZERO_A = patterns(n).ALU_ZERO_A;
assert PRINT_EN = patterns(n).PRINT_EN

report "bad output value" severity error;
end loop;
assert false report "end of test" severity note;
--  Wait forever; this will finish the simulation.
wait;
end process;
end behav;
