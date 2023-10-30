all: inst_fet control reg8 regfile alu print calc

inst_fet: 

	/usr/local/bin/ghdl -a --ieee=synopsys inst_fet.vhdl
	/usr/local/bin/ghdl -a --ieee=synopsys inst_tb.vhdl
	/usr/local/bin/ghdl -e --ieee=synopsys inst_tb
	/usr/local/bin/ghdl -r --ieee=synopsys inst_tb
	echo instruction fetch test done
control: 

	/usr/local/bin/ghdl -a --ieee=synopsys control.vhdl
	/usr/local/bin/ghdl -a --ieee=synopsys control_tb.vhdl
	/usr/local/bin/ghdl -e --ieee=synopsys control_tb
	/usr/local/bin/ghdl -r --ieee=synopsys control_tb
	echo controller test done

reg8: 

	/usr/local/bin/ghdl -a --ieee=synopsys reg8.vhdl
	/usr/local/bin/ghdl -a --ieee=synopsys reg_tb.vhdl
	/usr/local/bin/ghdl -e --ieee=synopsys reg_tb
	/usr/local/bin/ghdl -r --ieee=synopsys reg_tb --stop-time=32ns
	echo  8-bit register test done

regfile: 

	/usr/local/bin/ghdl -a --ieee=synopsys regfile.vhdl
	/usr/local/bin/ghdl -a --ieee=synopsys regfile_tb.vhdl
	/usr/local/bin/ghdl -e --ieee=synopsys regfile_tb
	/usr/local/bin/ghdl -r --ieee=synopsys regfile_tb --stop-time=81ns
	echo register file test done

alu: 

	/usr/local/bin/ghdl -a --ieee=synopsys alu.vhdl
	/usr/local/bin/ghdl -a --ieee=synopsys alu_tb.vhdl
	/usr/local/bin/ghdl -e --ieee=synopsys alu_tb
	/usr/local/bin/ghdl -r --ieee=synopsys alu_tb
	echo alu test done


print: 

	/usr/local/bin/ghdl -a --ieee=synopsys print.vhdl
	/usr/local/bin/ghdl -a --ieee=synopsys print_tb.vhdl
	/usr/local/bin/ghdl -e --ieee=synopsys print_tb
	/usr/local/bin/ghdl -r --ieee=synopsys print_tb  --stop-time=20ns
	echo print function test done
calc: 

	/usr/local/bin/ghdl -a --ieee=synopsys calc.vhdl
	/usr/local/bin/ghdl -a --ieee=synopsys calc_tb.vhdl
	/usr/local/bin/ghdl -e --ieee=synopsys calc_tb
	/usr/local/bin/ghdl -r --ieee=synopsys calc_tb
	echo calculator test done

clean:
	
	rm work-obj93.cf

