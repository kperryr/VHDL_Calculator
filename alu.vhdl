library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- File is ALU and executes ADD and SUB, as well as LOAD, LA and DISPLAY, ALU also 
-- detemines overflow only if both inputs are of the same sign otherwise oflow = '0'
entity ALU is 

port( 		rA,rB   : in std_logic_vector(7 downto 0); --inputs data from two signals
		op      : in std_logic_vector(1 downto 0); --alu_ctr op codes
		oflow   : out std_logic; -- overflow port
		O       : out std_logic_vector(7 downto 0) -- alu output
    );
end entity;

architecture behav of ALU is
signal a            : std_logic; -- bit for comparsion of MSB of both inputs
signal ext_A, ext_B : std_logic_vector(8 downto 0); --sign extended signal of rA and rB
signal result       : std_logic_vector(8 downto 0); -- sign extended signal of output used to determine overflow

begin
	a <= rA(7) xnor rB(7); -- if a = '1' both inputs are of the same sign
	ext_A <= rA(7) & rA; -- sign extend rA
        ext_B <= rB(7) & rB; -- sign extend rB
	
	process(ext_A,ext_B,rA,result)
	begin	
		if (op = "00") then  -- ADD and LA and LOAD
			if (a = '1') then --if the same sign calculate overflow

			     result <= std_logic_vector(unsigned(ext_A) + unsigned(ext_B));
			     
			     if (rA(7) = '0') then               --if both are positive
				 oflow  <= result(8) or result(7); -- overflow is '1' if the result has changed signs
			     else                               -- if both are negative
				 oflow  <= not result(7);       -- overflow is '1' if the result has changed signs
			     end if;

		        else
			
			     result     <= std_logic_vector(unsigned(ext_A) + unsigned(ext_B));
			     oflow <= '0';
			end if;

		elsif (op = "01") then --SUB

			if (a = '0') then -- if the opposite sign calculate overflow
				result <= std_logic_vector(unsigned(ext_A) + (unsigned(not(ext_B)) + 1 )); -- A - B = A + -(B)
				
				if (rA(7) = '0') then             -- if both positive after taking two's comp
			     		oflow  <= result(8) or result(7);
				else                              -- if both are negative after taking two's comp
					oflow  <= not result(7);
			     	end if;
			else
			
				result <= std_logic_vector(unsigned(ext_A) + (unsigned(not(ext_B)) + 1 )); -- A - B = A + -(B)
				oflow  <= '0';
			end if;
		
		else                 -- DISPLAY
			result    <= rA(7) & rA; --Display first value
			oflow <= '0';
		end if;
	end process;

	O <= result( 7 downto 0); --output
end behav;

