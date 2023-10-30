library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- File is for calculating values of control signal and switches

entity control is 

port( 		opcode         : in std_logic_vector(2 downto 0); -- opcode from instruction fetch
		alu_ctr        : out std_logic_vector(1 downto 0); -- ALU control switch ("00" -ADD; "01" - SUB; else display)
		dst_reg        : out std_logic; -- destination write register switch ('0' -rs; '1' -rd)
		imm_value      : out std_logic; -- immediate value switch ('0'- imm; '1' -addr)
		write_en       : out std_logic; -- register write enable signal 
		sign_ext       : out std_logic; -- extended sign signal ('0'-zeros; '1'-sign-extended)
		alu_src        : out std_logic; -- select switch for second ALU input ('0'-reg value; '1'-immediate value)
		alu_zero_A     : out std_logic; -- select switch for first ALU input ('0'- all zeros; '1'- reg value)
		print_en       : out std_logic -- print enable signal
    );
end entity;

architecture behav of control is

	
begin
	process(opcode)  -- combo logic
	begin

		alu_ctr(1) <= opcode(2);
		alu_ctr(0) <= opcode(1) and opcode(0);
		dst_reg    <= opcode(1) or opcode(0);
		imm_value  <= not (opcode(0));
		write_en   <= not (opcode(2));
		sign_ext   <= opcode(0);
		alu_src    <= not (opcode(1));
		alu_zero_A <= (not opcode(0)) or opcode(1);
		print_en   <= opcode(2);

	end process;
end behav;

