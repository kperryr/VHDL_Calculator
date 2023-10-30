library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- File is instruction fetch: determines opcodes and registers/immediate bit locations values

entity inst_fet is 

port( 		data_in        : in std_logic_vector(7 downto 0);  -- 8-bit instruction code from user input
		op_out         : out std_logic_vector(2 downto 0); -- outputs a decoded 3-bit op-code from user input
		rs,rt,rd,addr  : out std_logic_vector(1 downto 0); -- outputs registers to regfile and write data bits
		imm            : out std_logic_vector(3 downto 0)  -- outputs immediate write data bit
    );
end entity;

architecture behav of inst_fet is

	
begin
	process(data_in)
	begin	
			
			
			if (data_in(7 downto 6) = "00") then   -- "00" can be two different instruction (Load Addr or display)
				
				if (data_in(5) = '0') then  -- data_in(5) decides MSB for op_out  when "00"
					op_out <= "000"; -- instruction code for load address
				else
					op_out <= "100"; -- instruction code for display
				end if;
			else                             -- instrutions codes for load immediate, add, and sub
				op_out(2) <= '0';
				op_out(1 downto 0) <= data_in(7 downto 6);	
		
			end if;

			rs   <=  data_in( 3 downto 2); -- bits for register one
			rt   <=  data_in( 1 downto 0); -- bits for register two
			rd   <=  data_in( 5 downto 4); -- bits for register that calculator writes to
			addr <=  data_in( 1 downto 0); -- bits for label to address
			imm  <=	 data_in( 3 downto 0); -- bits for immediate value	       
	end process;
end behav;

