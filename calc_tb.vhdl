library ieee;
use ieee.std_logic_1164.all;

--  A testbench has no ports.
entity calc_tb is
	end calc_tb;

architecture behav of calc_tb is
--  Declaration of the component that will be instantiated.
component calc is
port( 		int_data       : in std_logic_vector(7 downto 0); --8 bit instruction code from user input
		clk            : in  std_logic -- clock
);
end component;
signal int_data : std_logic_vector(7 downto 0);
signal CLK : std_logic;
begin

--  Component instantiation.
	calc_0 : calc port map (int_data => int_data,clk => CLK );

--  This process does the real job.
process
type pattern_type is record
--  The inputs of the calc.
int_data : std_logic_vector(7 downto 0);
clk : std_logic;
end record;
--  The patterns to apply.
type pattern_array is array (natural range <>) of pattern_type;
constant patterns : pattern_array := 
-- test display opcode "100" ("001")
-- all registers intialized to "00000000"
-- expected output should be 0 
(("00100000",'0'),
("00100000",'1'), --print reg 0 contents
("00100100",'0'), 
("00100100",'1'), --print reg 1 contents
("00101000",'0'), 
("00101000",'1'), --print reg 2 contents
("00101100",'0'), 
("00101100",'1'), --print reg 3 contents

-- test Load address opcode"000"
-- how address is established is explained in report
--reg 0
("00000011",'0'), 
("00000011",'1'), --load address of "11" into reg 0 
("00100000",'0'), 
("00100000",'1'), --print reg 0 contents
("00000001",'0'), 
("00000001",'1'), --load address of "01" into reg 0 
("00100000",'0'), 
("00100000",'1'),  --print reg 0 contents

--reg 1
("00000110",'0'), 
("00000110",'1'), --load address of "10" into reg 1 
("00100100",'0'), 
("00100100",'1'), --print reg 1 contents
("00000101",'0'), 
("00000101",'1'), --load address of "01" into reg 1 
("00100100",'0'), 
("00100100",'1'), --print reg 1 contents

--reg 2
("00001001",'0'), 
("00001001",'1'), --load address of "01" into reg 2 
("00101000",'0'), 
("00101000",'1'), --print reg 2 contents
("00001001",'0'), 
("00001001",'1'), --load address of "01" into reg 2 
("00101000",'0'), 
("00101000",'1'),  --print reg 2 contents

--reg 3
("00001111",'0'), 
("00001111",'1'), --load address of "11" into reg 3 
("00101100",'0'), 
("00101100",'1'), --print reg 3 contents
("00001101",'0'), 
("00001101",'1'), --load address of "01" into reg 3 
("00101100",'0'), 
("00101100",'1'), --print reg 3 contents


-- test Load immediate opcode "001" (compressed as "01")
--reg 0
("01000001",'0'), 
("01000001",'1'), --load "0001" into reg 0 
("00100000",'0'), 
("00100000",'1'), --print reg 0 contents: 1
("01000100",'0'), 
("01000100",'1'), --load "0100" into reg 0 
("00100000",'0'), 
("00100000",'1'),  --print reg 0 contents: 4

--reg 1
("01011111",'0'), 
("01011111",'1'), --load "1111" into reg 1 
("00100100",'0'), 
("00100100",'1'), --print reg 1 contents: -1
("01011101",'0'), 
("01011101",'1'), --load "1101" into reg 1 
("00100100",'0'), 
("00100100",'1'),  --print reg 1 contents: -3

--reg 2
("01100110",'0'), 
("01100110",'1'), --load "0110" into reg 2 
("00101000",'0'), 
("00101000",'1'), --print reg 2 contents: 6
("01101001",'0'), 
("01101001",'1'), --load "1001" into reg 2 
("00101000",'0'), 
("00101000",'1'),  --print reg 2 contents: -7

--reg 3
("01110111",'0'), 
("01110111",'1'), --load "0111" into reg 3 
("00101100",'0'), 
("00101100",'1'), --print reg 3 contents: 7
("01110010",'0'), 
("01110010",'1'), --load "0010" into reg 3 
("00101100",'0'), 
("00101100",'1'),  --print reg 3 contents: 2

-- test ADD opcode "010" (compressed as "10")

-- reg 0 as dest reg
-- rs = reg 0 and rt = other registers
("10000000",'0'), 
("10000000",'1'), -- add reg 0 and reg 0 and load in reg 0 
("00100000",'0'), 
("00100000",'1'), --print reg 0 contents: 8
("10000001",'0'), 
("10000001",'1'), --add reg 0 and reg 1 and load in reg 0
("00100000",'0'), 
("00100000",'1'),  --print reg 0 contents: 5
("10000010",'0'), 
("10000010",'1'), -- add reg 0 and reg 2 and load in reg 0 
("00100000",'0'), 
("00100000",'1'), --print reg 0 contents: -2
("10000011",'0'), 
("10000011",'1'), --add reg 0 and reg 3 and load in reg 0
("00100000",'0'), 
("00100000",'1'),  --print reg 0 contents: 0

--rs = reg 1 and rt = other registers
("10000100",'0'), 
("10000100",'1'), -- add reg 1 and reg 0 and load in reg 0 
("00100000",'0'), 
("00100000",'1'), --print reg 0 contents: -3
("10000101",'0'), 
("10000101",'1'), --add reg 1 and reg 1 and load in reg 0
("00100000",'0'), 
("00100000",'1'),  --print reg 0 contents: -6
("10000110",'0'), 
("10000110",'1'), -- add reg 1 and reg 2 and load in reg 0 
("00100000",'0'), 
("00100000",'1'), --print reg 0 contents: -10
("10000111",'0'), 
("10000111",'1'), --add reg 1 and reg 3 and load in reg 0
("00100000",'0'), 
("00100000",'1'),  --print reg 0 contents: -1

--rs = reg 2 and rt = other registers
("10001000",'0'), 
("10001000",'1'), -- add reg 2 and reg 0 and load in reg 0 
("00100000",'0'), 
("00100000",'1'), --print reg 0 contents: -8
("10001001",'0'), 
("10001001",'1'), --add reg 2 and reg 1 and load in reg 0
("00100000",'0'), 
("00100000",'1'),  --print reg 0 contents: -10
("10001010",'0'), 
("10001010",'1'), -- add reg 2 and reg 2 and load in reg 0 
("00100000",'0'), 
("00100000",'1'), --print reg 0 contents: -14
("10001011",'0'), 
("10001011",'1'), --add reg 2 and reg 3 and load in reg 0
("00100000",'0'), 
("00100000",'1'),  --print reg 0 contents: -5

--rs = reg 3 and rt = other registers
("10001100",'0'), 
("10001100",'1'), -- add reg 3 and reg 0 and load in reg 0 
("00100000",'0'), 
("00100000",'1'), --print reg 0 contents: -3
("10001101",'0'), 
("10001101",'1'), --add reg 3 and reg 1 and load in reg 0
("00100000",'0'), 
("00100000",'1'),  --print reg 0 contents: -1
("10001110",'0'), 
("10001110",'1'), -- add reg 3 and reg 2 and load in reg 0 
("00100000",'0'), 
("00100000",'1'), --print reg 0 contents: -5
("10001111",'0'), 
("10001111",'1'), --add reg 3 and reg 3 and load in reg 0
("00100000",'0'), 
("00100000",'1'),  --print reg 0 contents: 4

-- reg 1 as dest reg
-- rs = reg 0 and rt = other registers
("10010000",'0'), 
("10010000",'1'), -- add reg 0 and reg 0 and load in reg 1 
("00100100",'0'), 
("00100100",'1'), --print reg 1 contents: 8
("10010001",'0'), 
("10010001",'1'), --add reg 0 and reg 1 and load in reg 1
("00100100",'0'), 
("00100100",'1'),  --print reg 1 contents: 12
("10010010",'0'), 
("10010010",'1'), -- add reg 0 and reg 2 and load in reg 1 
("00100100",'0'), 
("00100100",'1'), --print reg 1 contents: -3
("10010011",'0'), 
("10010011",'1'), --add reg 0 and reg 3 and load in reg 1
("00100100",'0'), 
("00100100",'1'),  --print reg 1 contents: 6

--rs = reg 1 and rt = other registers
("10010100",'0'), 
("10010100",'1'), -- add reg 1 and reg 0 and load in reg 1 
("00100100",'0'), 
("00100100",'1'), --print reg 1 contents: 10
("10010101",'0'), 
("10010101",'1'), --add reg 1 and reg 1 and load in reg 1
("00100100",'0'), 
("00100100",'1'),  --print reg 1 contents: 20
("10010110",'0'), 
("10010110",'1'), -- add reg 1 and reg 2 and load in reg 1 
("00100100",'0'), 
("00100100",'1'), --print reg 1 contents: 13 
("10010111",'0'), 
("10010111",'1'), --add reg 1 and reg 3 and load in reg 1
("00100100",'0'), 
("00100100",'1'),  --print reg 1 contents: 15

--rs = reg 2 and rt = other registers
("10011000",'0'), 
("10011000",'1'), -- add reg 2 and reg 0 and load in reg 1 
("00100100",'0'), 
("00100100",'1'), --print reg 1 contents: -3
("10011001",'0'), 
("10011001",'1'), --add reg 2 and reg 1 and load in reg 1
("00100100",'0'), 
("00100100",'1'),  --print reg 1 contents: -10
("10011010",'0'), 
("10011010",'1'), -- add reg 2 and reg 2 and load in reg 1 
("00100100",'0'), 
("00100100",'1'), --print reg 1 contents: -14
("10011011",'0'), 
("10011011",'1'), --add reg 2 and reg 3 and load in reg 1
("00100100",'0'), 
("00100100",'1'),  --print reg 1 contents: -5

--rs = reg 3 and rt = other registers
("10011100",'0'), 
("10011100",'1'), -- add reg 3 and reg 1 and load in reg 1 
("00100100",'0'), 
("00100100",'1'), --print reg 1 contents: 6 
("10011101",'0'), 
("10011101",'1'), --add reg 3 and reg 1 and load in reg 1
("00100100",'0'), 
("00100100",'1'),  --print reg 1 contents: 8
("10011110",'0'), 
("10011110",'1'), -- add reg 3 and reg 2 and load in reg 1 
("00100100",'0'), 
("00100100",'1'), --print reg 1 contents: -5
("10011111",'0'), 
("10011111",'1'), --add reg 3 and reg 3 and load in reg 1
("00100100",'0'), 
("00100100",'1'),  --print reg 1 contents: 4

-- reg 2 as dest reg
-- rs = reg 0 and rt = other registers
("10100000",'0'), 
("10100000",'1'), -- add reg 0 and reg 0 and load in reg 2 
("00101000",'0'), 
("00101000",'1'), --print reg 2 contents: 8
("10100001",'0'), 
("10100001",'1'), --add reg 0 and reg 1 and load in reg 2
("00101000",'0'), 
("00101000",'1'),  --print reg 2 contents: 8 
("10100010",'0'), 
("10100010",'1'), -- add reg 0 and reg 2 and load in reg 2 
("00101000",'0'), 
("00101000",'1'), --print reg 2 contents: 12
("10100011",'0'), 
("10100011",'1'), --add reg 0 and reg 3 and load in reg 2
("00101000",'0'), 
("00101000",'1'),  --print reg 2 contents: 6

--rs = reg 1 and rt = other registers
("10100100",'0'), 
("10100100",'1'), -- add reg 1 and reg 0 and load in reg 2 
("00101000",'0'), 
("00101000",'1'), --print reg 2 contents: 8 
("10100101",'0'), 
("10100101",'1'), --add reg 1 and reg 1 and load in reg 2
("00101000",'0'), 
("00101000",'1'),  --print reg 2 contents: 8 
("10100110",'0'), 
("10100110",'1'), -- add reg 1 and reg 2 and load in reg 2 
("00101000",'0'), 
("00101000",'1'), --print reg 2 contents: 12 
("10100111",'0'), 
("10100111",'1'), --add reg 1 and reg 3 and load in reg 2
("00101000",'0'), 
("00101000",'1'),  --print reg 2 contents: 6 

--rs = reg 2 and rt = other registers
("10101000",'0'), 
("10101000",'1'), -- add reg 2 and reg 0 and load in reg 2 
("00101000",'0'), 
("00101000",'1'), --print reg 2 contents: 10
("10101001",'0'), 
("10101001",'1'), --add reg 2 and reg 1 and load in reg 2
("00101000",'0'), 
("00101000",'1'),  --print reg 2 contents: 14 
("10101010",'0'), 
("10101010",'1'), -- add reg 2 and reg 2 and load in reg 2 
("00101000",'0'), 
("00101000",'1'), --print reg 2 contents: 28 
("10101011",'0'), 
("10101011",'1'), --add reg 2 and reg 3 and load in reg 2
("00101000",'0'), 
("00101000",'1'),  --print reg 2 contents: 30

--rs = reg 3 and rt = other registers
("10101100",'0'), 
("10101100",'1'), -- add reg 3 and reg 1 and load in reg 2 
("00101000",'0'), 
("00101000",'1'), --print reg 2 contents: 6 
("10101101",'0'), 
("10101101",'1'), --add reg 3 and reg 1 and load in reg 2
("00101000",'0'), 
("00101000",'1'),  --print reg 2 contents: 6
("10101110",'0'), 
("10101110",'1'), -- add reg 3 and reg 2 and load in reg 2 
("00101000",'0'), 
("00101000",'1'), --print reg 2 contents: 8 
("10101111",'0'), 
("10101111",'1'), --add reg 3 and reg 3 and load in reg 2
("00101000",'0'), 
("00101000",'1'),  --print reg 2 contents: 4

-- reg 3 as dest reg
-- rs = reg 0 and rt = other registers
("10110000",'0'), 
("10110000",'1'), -- add reg 0 and reg 0 and load in reg 3 
("00101100",'0'), 
("00101100",'1'), --print reg 3 contents: 8
("10110001",'0'), 
("10110001",'1'), --add reg 0 and reg 1 and load in reg 3
("00101100",'0'), 
("00101100",'1'),  --print reg 3 contents: 8 
("10110010",'0'), 
("10110010",'1'), -- add reg 0 and reg 2 and load in reg 3 
("00101100",'0'), 
("00101100",'1'), --print reg 3 contents: 8 
("10110011",'0'), 
("10110011",'1'), --add reg 0 and reg 3 and load in reg 3
("00101100",'0'), 
("00101100",'1'),  --print reg 3 contents: 12

--rs = reg 1 and rt = other registers
("10110100",'0'), 
("10110100",'1'), -- add reg 1 and reg 0 and load in reg 3 
("00101100",'0'), 
("00101100",'1'), --print reg 3 contents: 8 
("10110101",'0'), 
("10110101",'1'), --add reg 1 and reg 1 and load in reg 3
("00101100",'0'), 
("00101100",'1'),  --print reg 3 contents: 8 
("10110110",'0'), 
("10110110",'1'), -- add reg 1 and reg 2 and load in reg 3 
("00101100",'0'), 
("00101100",'1'), --print reg 3 contents: 8  
("10110111",'0'), 
("10110111",'1'), --add reg 1 and reg 3 and load in reg 3
("00101100",'0'), 
("00101100",'1'),  --print reg 3 contents: 12

--rs = reg 2 and rt = other registers
("10111000",'0'), 
("10111000",'1'), -- add reg 2 and reg 0 and load in reg 3 
("00101100",'0'), 
("00101100",'1'), --print reg 3 contents: 8 
("10111001",'0'), 
("10111001",'1'), --add reg 2 and reg 1 and load in reg 3
("00101100",'0'), 
("00101100",'1'),  --print reg 3 contents: 8  
("10111010",'0'), 
("10111010",'1'), -- add reg 2 and reg 2 and load in reg 3 
("00101100",'0'), 
("00101100",'1'), --print reg 3 contents: 8  
("10111011",'0'), 
("10111011",'1'), --add reg 2 and reg 3 and load in reg 3
("00101100",'0'), 
("00101100",'1'),  --print reg 3 contents: 12

--rs = reg 3 and rt = other registers
("10111100",'0'), 
("10111100",'1'), -- add reg 3 and reg 1 and load in reg 3 
("00101100",'0'), 
("00101100",'1'), --print reg 3 contents: 16
("10111101",'0'), 
("10111101",'1'), --add reg 3 and reg 1 and load in reg 3
("00101100",'0'), 
("00101100",'1'),  --print reg 3 contents: 20
("10111110",'0'), 
("10111110",'1'), -- add reg 3 and reg 2 and load in reg 3 
("00101100",'0'), 
("00101100",'1'), --print reg 3 contents: 24
("10111111",'0'), 
("10111111",'1'), --add reg 3 and reg 3 and load in reg 3
("00101100",'0'), 
("00101100",'1'),  --print reg 3 contents: 48

--test overflow dectection
("10111111",'0'), 
("10111111",'1'), --add reg 3 and reg 3 and load in reg 3 : reg3 = 96
("10111111",'0'), 
("10111111",'1'), --add reg 3 and reg 3 and load in reg 3 : overflow error 
("00101100",'0'), 
("00101100",'1'),  --print reg 3 contents: 96 => regwrite = 0 when overflow dectected

-- Test SUB opcode "011" (compressed as "11")
-- reg 0 as dest reg
-- rs = reg 0 and rt = other registers
("11000000",'0'), 
("11000000",'1'), -- sub: reg 0 - reg 0 and load in reg 0 
("00100000",'0'), 
("00100000",'1'), --print reg 0 contents: 0
("11000001",'0'), 
("11000001",'1'), --sub: reg 0 - reg 1 and load in reg 0
("00100000",'0'), 
("00100000",'1'),  --print reg 0 contents: -4
("11000010",'0'), 
("11000010",'1'), -- sub: reg 0 - reg 2 and load in reg 0 
("00100000",'0'), 
("00100000",'1'), --print reg 0 contents: -8
("11000011",'0'), 
("11000011",'1'), --sub: reg 0 - reg 3 and load in reg 0
("00100000",'0'), 
("00100000",'1'),  --print reg 0 contents: -104

--rs = reg 1 and rt = other registers
("11000100",'0'), 
("11000100",'1'), -- sub: reg 1 - reg 0 and load in reg 0 
("00100000",'0'), 
("00100000",'1'), --print reg 0 contents: 108
("11000101",'0'), 
("11000101",'1'), --sub: reg 1 - reg 1 and load in reg 0
("00100000",'0'), 
("00100000",'1'),  --print reg 0 contents: 0 
("11000110",'0'), 
("11000110",'1'), -- sub: reg 1 - reg 2 and load in reg 0 
("00100000",'0'), 
("00100000",'1'), --print reg 0 contents: 0  
("11000111",'0'), 
("11000111",'1'), --sub: reg 1 - reg 3 and load in reg 0
("00100000",'0'), 
("00100000",'1'),  --print reg 0 contents: -92

--rs = reg 2 and rt = other registers
("11001000",'0'), 
("11001000",'1'), -- sub: reg 2 - reg 0 and load in reg 0 
("00100000",'0'), 
("00100000",'1'), --print reg 0 contents: 96 
("11001001",'0'), 
("11001001",'1'), --sub: reg 2 - reg 1 and load in reg 0
("00100000",'0'), 
("00100000",'1'),  --print reg 0 contents: 0  
("11001010",'0'), 
("11001010",'1'), -- sub: reg 2 - reg 2 and load in reg 0 
("00100000",'0'), 
("00100000",'1'), --print reg 0 contents: 0  
("11001011",'0'), 
("11001011",'1'), --sub: reg 2 - reg 3 and load in reg 0
("00100000",'0'), 
("00100000",'1'),  --print reg 0 contents: -92

--rs = reg 3 and rt = other registers
("11001100",'0'), 
("11001100",'1'), -- sub: reg 3 - reg 0 and load in reg 0 
("00100000",'0'), 
("00100000",'1'), --print reg 0 contents: -92
("11001101",'0'), 
("11001101",'1'), --sub: reg 3 - reg 1 and load in reg 0
("00100000",'0'), 
("00100000",'1'),  --print reg 0 contents: 92 
("11001110",'0'), 
("11001110",'1'), -- sub: reg 3 - reg 2 and load in reg 0 
("00100000",'0'), 
("00100000",'1'), --print reg 0 contents: 92
("11001111",'0'), 
("11001111",'1'), --sub: reg 3 - reg 3 and load in reg 0
("00100000",'0'), 
("00100000",'1'),  --print reg 0 contents: 0

-- reg 1 as dest reg
-- rs = reg 0 and rt = other registers
("11010000",'0'), 
("11010000",'1'), -- sub: reg 0 - reg 0 and load in reg 1 
("00100100",'0'), 
("00100100",'1'), --print reg 1 contents: 0
("11010001",'0'), 
("11010001",'1'), --sub: reg 0 - reg 1 and load in reg 1
("00100100",'0'), 
("00100100",'1'),  --print reg 1 contents: 0 
("11010010",'0'), 
("11010010",'1'), -- sub: reg 0 - reg 2 and load in reg 1 
("00100100",'0'), 
("00100100",'1'), --print reg 1 contents: -4
("11010011",'0'), 
("11010011",'1'), --sub: reg 0 - reg 3 and load in reg 1
("00100100",'0'), 
("00100100",'1'),  --print reg 1 contents: -96

--rs = reg 1 and rt = other registers
("11010100",'0'), 
("11010100",'1'), -- sub: reg 1 - reg 0 and load in reg 1 
("00100100",'0'), 
("00100100",'1'), --print reg 1 contents: -96
("11010101",'0'), 
("11010101",'1'), --sub: reg 1 - reg 1 and load in reg 1
("00100100",'0'), 
("00100100",'1'),  --print reg 1 contents: 0 
("11010110",'0'), 
("11010110",'1'), -- sub: reg 1 - reg 2 and load in reg 1 
("00100100",'0'), 
("00100100",'1'), --print reg 1 contents: -4 
("11010111",'0'), 
("11010111",'1'), --sub: reg 1 - reg 3 and load in reg 1
("00100100",'0'), 
("00100100",'1'),  --print reg 1 contents: -100

--rs = reg 2 and rt = other registers
("11011000",'0'), 
("11011000",'1'), -- sub: reg 2 - reg 0 and load in reg 1 
("00100100",'0'), 
("00100100",'1'), --print reg 1 contents: 4 
("11011001",'0'), 
("11011001",'1'), --sub: reg 2 - reg 1 and load in reg 1
("00100100",'0'), 
("00100100",'1'),  --print reg 1 contents: 0  
("11011010",'0'), 
("11011010",'1'), -- sub: reg 2 - reg 2 and load in reg 1 
("00100100",'0'), 
("00100100",'1'), --print reg 1 contents: 0  
("11011011",'0'), 
("11011011",'1'), --sub: reg 2 - reg 3 and load in reg 1
("00100100",'0'), 
("00100100",'1'),  --print reg 1 contents: -92

--rs = reg 3 and rt = other registers
("11011100",'0'), 
("11011100",'1'), -- sub: reg 3 - reg 1 and load in reg 1 
("00100100",'0'), 
("00100100",'1'), --print reg 1 contents: 96
("11011101",'0'), 
("11011101",'1'), --sub: reg 3 - reg 1 and load in reg 1
("00100100",'0'), 
("00100100",'1'),  --print reg 1 contents: 0
("11011110",'0'), 
("11011110",'1'), -- sub: reg 3 - reg 2 and load in reg 1 
("00100100",'0'), 
("00100100",'1'), --print reg 1 contents: 92
("11011111",'0'), 
("11011111",'1'), --sub: reg 3 - reg 3 and load in reg 1
("00100100",'0'), 
("00100100",'1'),  --print reg 1 contents: 0

-- reg 2 as dest reg
-- rs = reg 0 and rt = other registers
("11100000",'0'), 
("11100000",'1'), -- sub: reg 0 - reg 0 and load in reg 2 
("00101000",'0'), 
("00101000",'1'), --print reg 2 contents: 0
("11100001",'0'), 
("11100001",'1'), --sub: reg 0 - reg 1 and load in reg 2
("00101000",'0'), 
("00101000",'1'),  --print reg 2 contents: 0 
("11100010",'0'), 
("11100010",'1'), -- sub: reg 0 -reg 2 and load in reg 2 
("00101000",'0'), 
("00101000",'1'), --print reg 2 contents: 0 
("11100011",'0'), 
("11100011",'1'), --sub: reg 0 - reg 3 and load in reg 2
("00101000",'0'), 
("00101000",'1'),  --print reg 2 contents: 96

--rs = reg 1 and rt = other registers
("11100100",'0'), 
("11100100",'1'), -- sub: reg 1 - reg 0 and load in reg 2 
("00101000",'0'), 
("00101000",'1'), --print reg 2 contents: 0 
("11100101",'0'), 
("11100101",'1'), --sub: reg 1 - reg 1 and load in reg 2
("00101000",'0'), 
("00101000",'1'),  --print reg 2 contents: 0 
("11100110",'0'), 
("11100110",'1'), -- sub: reg 1 - reg 2 and load in reg 2 
("00101000",'0'), 
("00101000",'1'), --print reg 2 contents: 0  
("11100111",'0'), 
("11100111",'1'), --sub: reg 1 - reg 3 and load in reg 2
("00101000",'0'), 
("00101000",'1'),  --print reg 2 contents: -96

--rs = reg 2 and rt = other registers
("11101000",'0'), 
("11101000",'1'), -- sub: reg 2 - reg 0 and load in reg 2 
("00101000",'0'), 
("00101000",'1'), --print reg 2 contents: -96
("11101001",'0'), 
("11101001",'1'), --sub: reg 2 - reg 1 and load in reg 2
("00101000",'0'), 
("00101000",'1'),  --print reg 2 contents: -96
("11101010",'0'), 
("11101010",'1'), -- sub: reg 2 - reg 2 and load in reg 2 
("00101000",'0'), 
("00101000",'1'), --print reg 2 contents: 0  
("11101011",'0'), 
("11101011",'1'), --sub: reg 2 - reg 3 and load in reg 2
("00101000",'0'), 
("00101000",'1'),  --print reg 2 contents: -96

--rs = reg 3 and rt = other registers
("11101100",'0'), 
("11101100",'1'), -- sub: reg 3 - reg 1 and load in reg 2 
("00101000",'0'), 
("00101000",'1'), --print reg 2 contents: 96
("11101101",'0'), 
("11101101",'1'), --sub: reg 3 - reg 1 and load in reg 2
("00101000",'0'), 
("00101000",'1'),  --print reg 2 contents: 96
("11101110",'0'), 
("11101110",'1'), -- sub: reg 3 - reg 2 and load in reg 2 
("00101000",'0'), 
("00101000",'1'), --print reg 2 contents: 0 
("11101111",'0'), 
("11101111",'1'), --sub: reg 3 - reg 3 and load in reg 2
("00101000",'0'), 
("00101000",'1'),  --print reg 2 contents: 0

--------test overflow with SUB command--------
("11000011",'0'),
("11000011",'1'), -- sub: reg 0 - reg 3 and load into reg 0 : 0 - 96
("11000011",'0'),
("11000011",'1'), -- sub: reg 0 - reg 3 : -96 -96 = overflow error
("00100000",'0'), 
("00100000",'1'),  --print reg 0 contents: -96


-- reg 3 as dest reg
-- rs = reg 0 and rt = other registers
("11110000",'0'), 
("11110000",'1'), -- sub: reg 0 - reg 0 and load in reg 3 
("00101100",'0'), 
("00101100",'1'), --print reg 3 contents: 0
("11110001",'0'), 
("11110001",'1'), --sub: reg 0 - reg 1 and load in reg 3
("00101100",'0'), 
("00101100",'1'),  --print reg 3 contents: -96
("11110010",'0'), 
("11110010",'1'), -- sub: reg 0 - reg 2 and load in reg 3 
("00101100",'0'), 
("00101100",'1'), --print reg 3 contents: -96
("11110011",'0'), 
("11110011",'1'), --sub: reg 0 - reg 3 and load in reg 3
("00101100",'0'), 
("00101100",'1'),  --print reg 3 contents: 0  

--rs = reg 1 and rt = other registers
("11110100",'0'), 
("11110100",'1'), -- sub reg 1 - reg 0 and load in reg 3 
("00101100",'0'), 
("00101100",'1'), --print reg 3 contents: 96
("11110101",'0'), 
("11110101",'1'), --sub: reg 1 - reg 1 and load in reg 3
("00101100",'0'), 
("00101100",'1'),  --print reg 3 contents: 0 
("11110110",'0'), 
("11110110",'1'), -- sub: reg 1 - reg 2 and load in reg 3 
("00101100",'0'), 
("00101100",'1'), --print reg 3 contents: 0  
("11110111",'0'), 
("11110111",'1'), --sub: reg 1 - reg 3 and load in reg 3
("00101100",'0'), 
("00101100",'1'),  --print reg 3 contents: 0 

--rs = reg 2 and rt = other registers
("11111000",'0'), 
("11111000",'1'), -- sub: reg 2 - reg 0 and load in reg 3 
("00101100",'0'), 
("00101100",'1'), --print reg 3 contents: 96
("11111001",'0'), 
("11111001",'1'), --sub: reg 2 - reg 1 and load in reg 3
("00101100",'0'), 
("00101100",'1'),  --print reg 3 contents: 0  
("11111010",'0'), 
("11111010",'1'), -- sub: reg 2 - reg 2 and load in reg 3 
("00101100",'0'), 
("00101100",'1'), --print reg 3 contents: 0  
("11111011",'0'), 
("11111011",'1'), --sub: reg 2 - reg 3 and load in reg 3
("00101100",'0'), 
("00101100",'1'),  --print reg 3 contents: 0 

--rs = reg 3 and rt = other registers
("11111100",'0'), 
("11111100",'1'), -- sub: reg 3 - reg 1 and load in reg 3 
("00101100",'0'), 
("00101100",'1'), --print reg 3 contents: 96
("11111101",'0'), 
("11111101",'1'), --sub: reg 3 - reg 1 and load in reg 3
("00101100",'0'), 
("00101100",'1'),  --print reg 3 contents: 96
("11111110",'0'), 
("11111110",'1'), -- sub: reg 3 - reg 2 and load in reg 3 
("00101100",'0'), 
("00101100",'1'), --print reg 3 contents: 96
("11111111",'0'), 
("11111111",'1'), --sub: reg 3 - reg 3 and load in reg 3
("00101100",'0'), 
("00101100",'1')  --print reg 3 contents: 0 


);
begin
--  Check each pattern.
for n in patterns'range loop
--  Set the inputs.
int_data <= patterns(n).int_data;
clk <= patterns(n).clk;
--  Wait for the results.
wait for 2 ns;
--  Check the outputs.
end loop;
assert false report "end of test" severity note;
--  Wait forever; this will finish the simulation.
wait;
end process;
end behav;
