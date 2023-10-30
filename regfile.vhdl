library ieee;
use ieee.std_logic_1164.all;

entity regfile is 

	port( 	rs,rt,rd      : in std_logic_vector(1 downto 0);  --registers input ports for read from (rs,rt) and write to (wd)
		wd            : in std_logic_vector( 7 downto 0); -- write data port
		clk, WE,oflow : in std_logic;                     -- clock, write enable and overflow
		rA,rB         : out std_logic_vector(7 downto 0)  -- rs and rt register value outputs
    );
end entity;

architecture behav of regfile is

-- component instantiation of reg8.vhdl
component reg8
port( 	I              : in std_logic_vector(7 downto 0);
      	clk, EN, oflow : in std_logic;
      	O              : out std_logic_vector(7 downto 0)
      );
end component;

signal mem0, mem1, mem2, mem3 : std_logic_vector( 7 downto 0) := "00000000"; --stores registers value
signal en1, en2, en3, en4 : std_logic; --enables for all four regs

for reg0 : reg8 use entity WORK.reg8(behav);
for reg1 : reg8 use entity WORK.reg8(behav);
for reg2 : reg8 use entity WORK.reg8(behav);
for reg3 : reg8 use entity WORK.reg8(behav);
	
begin

	write: process(WE, rd)
	begin	
				if (rd = "00") then				-- write to reg 1
					en1 <= WE;
					en2 <= '0';
					en3 <= '0';
					en4 <= '0';
				elsif (rd = "01") then 				-- write to reg 2 
					en1 <= '0';
					en2 <= WE;
					en3 <= '0';
					en4 <= '0';
				elsif (rd = "10") then 				-- write to reg 3
					en1 <= '0';
					en2 <= '0';
					en3 <= WE;
					en4 <= '0';
				else 						--write to reg 4
					en1 <= '0';
					en2 <= '0';
					en3 <= '0';
					en4 <= WE;
				end if;
	end process;

				reg0: reg8 port map(I => wd, clk => clk, EN => en1, oflow => oflow, O => mem0 );
				reg1: reg8 port map(I => wd, clk => clk, EN => en2, oflow => oflow, O => mem1 );
				reg2: reg8 port map(I => wd, clk => clk, EN => en3, oflow => oflow, O => mem2 );
				reg3: reg8 port map(I => wd, clk => clk, EN => en4, oflow => oflow, O => mem3 );
						 
	read: process(WE,rs,rt,mem0,mem1,mem2,mem3)
	begin

	       if ( rs = "00") then   --reg 0
			rA <= mem0;

	       elsif ( rs = "01") then --reg 1
		       rA <= mem1;
		
	       elsif ( rs = "10") then --reg 2
		       rA <= mem2;
	      	
	       elsif ( rs = "11") then	--reg 3       
		       rA <= mem3;
		
	       else -- if error
			rA <= "ZZZZZZZZ";
	       end if;
	      
			
	       if ( rt = "00") then  --reg 0
			rB <= mem0;
	       elsif ( rt = "01") then --reg 1
			rB <= mem1;
	       elsif ( rt = "10") then --reg 2
			rB <= mem2;
	       elsif ( rt = "11") then --reg 3
	      		rB <= mem3;
	       else -- if error
		       rB <= "ZZZZZZZZ";
	       end if;

	end process;

end behav;

