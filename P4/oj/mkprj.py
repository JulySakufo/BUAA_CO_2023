import os

src_dir = os.path.abspath('../')

verilog_files = [os.path.join(root, filename) for root, _, filenames in os.walk(
    src_dir) for filename in filenames if filename.endswith('.v')]

verilog_work_statements = [
    f'Verilog work "{filename}"' for filename in verilog_files]

# Write the Verilog work statements to the mips.prj file
with open('../mips.prj', 'w', encoding='utf-8') as f:
    f.write('\n'.join(verilog_work_statements))

with open('../mips.tcl', 'w', encoding='utf-8') as f:
    f.write('run 200us;\nexit')
