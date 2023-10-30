library ieee;
use ieee.std_logic_1164.all;

-- 8-bit register file that regfile reads and writes to
entity reg8 is 

port( 		I              : in std_logic_vector(7 downto 0); -- write data
		clk, EN, oflow : in std_logic;                    -- clock and write enable
		O              : out std_logic_vector(7 downto 0) -- output data
    );
end entity;

architecture behav of reg8 is
signal output : std_logic_vector ( 7 downto 0) := "00000000";	--intialize all registers to zero
begin
	process(clk)
	begin	
		if (rising_edge(clk)) then
			if (EN = '1') and (oflow = '0') then 
				output <= I;      -- write to register on rising edge and EN ='1'
			else
				output <= output;
			end if;
		end if;
	end process;
	O <= output; --sends value of register to regfile
end behav;

