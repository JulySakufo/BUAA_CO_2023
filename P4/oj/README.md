# 这是一个自动测试机
## 本版本为v7.0,由YEZ制作
## 在使用之前

## __确认你有本地非虚拟机的ISE__  
找到你的ISE安装路径，通常以 ise/14.7/ISE_DS/ISE/ 结尾。  
将该路径加入到脚本test.ps1中，替换掉如下的条目：
```
D:\XLINX\14.7\ISE_DS\ISE/bin/nt64/fuse -nodebug -prj mips.prj -o mips.exe mips_tb
```  
注意，只需要更改到/ISE即可，其余不必理会  
将oj文件夹解压到你的工程文件夹目录下（注意要带着文件夹解压）  

请确认你的powershell和python版本够高，并且 __有运行脚本文件的权限__ 

并且确认你有python环境（表现为在终端中直接输入python回车有反应），如果没有请将脚本中的python更换为你的本地python路径  

## 在使用过程中

我们会自动添加名为mips_tb.v的testBench以防你没有写，如果原有这个文件我们会覆盖，请做好备份

## 运行完毕后
``mips_code.txt`` 为本次测试的mips代码

``code.txt`` 为本次测试的机器码

``diff.txt`` 为最终区别

``correct.txt`` 为mars输出结果

``result.txt`` 为你的输出结果

``debug.txt`` 包含了诸多调试信息，可供debug


## 实现概要：
由一个python程序生成测试代码  
之后进入powershell  
powershell唤起mars生成机器码  
powershell唤起mars跑机器码生成正确输出  
powershell搭建prj文件和tcl文件，并进行测试  
powershell唤起logdiff.py进行比对  
## powered by：石睿知学长搭建的超级mars
# 最后，作者YEZ祝您生活愉快