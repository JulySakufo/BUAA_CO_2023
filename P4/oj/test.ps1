python codeGenerate.py

java -jar .\mars.jar mips_code.txt nc mc CompactLargeText a dump .text HexText code.txt

cp code.txt ..\code.txt

java -jar .\mars.jar mips_code.txt mc CompactLargeText coL1 ig | Select-String "^@" > correct.txt

java -jar .\mars.jar mips_code.txt mc CompactLargeText coL2 ig > debug.txt

cp mips_tb.v ..\mips_tb.v

python mkprj.py

cd ..
D:\XLINX\14.7\ISE_DS\ISE/bin/nt64/fuse -nodebug -prj mips.prj -o mips.exe mips_tb

.\mips.exe -nolog -tclbatch mips.tcl | Select-String "^@" > .\oj\result.txt

cd oj

python logdiff.py