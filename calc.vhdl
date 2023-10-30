library ieee;
library STD;
use STD.textio.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Main file that connects all MUXs and components
entity calc is 
	port( Int_data : in std_logic_vector (7 downto 0); --input instruction code
	      clk: in std_logic --clock
      );
end entity calc;



architecture structural of calc is
	-- component declarations
	-- instruction fetch	
	component inst_fet is

		port( 		data_in        : in std_logic_vector(7 downto 0);  --8 bit instruction code from user input
				op_out         : out std_logic_vector(2 downto 0); -- decoded 3-bit  op code from user input
				rs,rt,rd,addr  : out std_logic_vector(1 downto 0); -- registers to regfile and label (write data)
				imm            : out std_logic_vector(3 downto 0)  --immediate entry
   		 );
	end component inst_fet;

	--controller
	component control is
		
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
	end component control;

	--register file
	component regfile is

	port( 	rs,rt,rd          : in std_logic_vector(1 downto 0); --register read from and write to (wd)
		wd                : in std_logic_vector( 7 downto 0); -- write data
		clk, WE,oflow     : in std_logic;		      -- clock, write enable, and overflow
		rA,rB             : out std_logic_vector(7 downto 0) -- read data from rs and rt
   	 );
	end component regfile;
	
	--ALU
	component alu is

		port( 	rA,rB   : in std_logic_vector(7 downto 0); -- read data from signals determine by control
			op      : in std_logic_vector(1 downto 0); -- ALU_ctr
			oflow   : out std_logic;                   -- over flow
			O       : out std_logic_vector(7 downto 0) -- alu_out
    		);
	end component alu;
	
	--DISPLAY function
	component print is

		port(  I              : in std_logic_vector(7 downto 0); --value from alu_out
		       clk, EN, oflow : in std_logic -- clock, print_en and overflow value
		);
	end component print;

	--signals connecting components
	signal rs,rt,rd,addr,alu_ctr : std_logic_vector(1 downto 0);
	signal op_code : std_logic_vector(2 downto 0);
	signal imm : std_logic_vector(3 downto 0);
	signal ALU_out, reg_A,reg_B : std_logic_vector(7 downto 0);
	signal dst_reg,imm_value, write_en,sign_ext,alu_src,alu_zero_A, print_en, oflow : std_logic;
	
	--signals connecting muxs determines by control switches
	signal dst_reg_out : std_logic_vector (1 downto 0);
	signal sign_ext_out, alu_rA, alu_rB : std_logic_vector (7 downto 0);
	
	
	for instruction_fetch_0: inst_fet use entity WORK.inst_fet(behav);
	for controller_0: control use entity WORK.control(behav);
	for regfile_0: regfile use entity WORK.regfile(behav);
	for alu_0: alu use entity WORK.alu(behav);
	for print_0: print use entity WORK.print(behav);

	begin
		--see RTL for clear picture of connections between components

		--instruction fetch instantiation
		instruction_fetch_0 : inst_fet port map (  int_data, op_code, rs, rt, rd,addr,imm);
		
		--control instantiation
		controller_0 : control port map (  op_code,alu_ctr, dst_reg,imm_value,write_en,sign_ext,alu_src,alu_zero_A,print_en);

		-- DST_REG MUX
		with dst_reg select dst_reg_out <=
			rs when '0',
			rd when others;

		--Imm_value MUX
		with imm_value select sign_ext_out(3 downto 0) <=
			imm when '0',
			'0' & '0' & addr when others;
			
		-- register file port instantiation
		regfile_0 : regfile port map (  rs, rt, dst_reg_out, ALU_out, clk, write_en, oflow, reg_A, reg_B);

		--sign extension MUX
		with sign_ext select sign_ext_out(7 downto 4) <= 
			"0000" when '0',
			sign_ext_out(3) & sign_ext_out(3) & sign_ext_out(3) & sign_ext_out(3) when others;
		
		--ALU MUX for input 2
		with alu_src select alu_rB <=
			reg_B when '0',
			sign_ext_out when others;
			
		-- ALU MUX for input 1
		with alu_zero_A select alu_rA <=
			"00000000" when '0',
			reg_A when others;	

		-- ALU instantiation
		alu_0 : alu port map ( 	alu_rA, alu_rB, alu_ctr, oflow, ALU_out);
		
	
		-- Display function instantiation
		print_0 : print port map (ALU_out, clk, print_en, oflow);

end structural;

