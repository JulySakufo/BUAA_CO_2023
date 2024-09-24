.data
  symbol: .space 28
  array: .space 28
  str_space: .asciiz " "
  str_enter: .asciiz "\n"
  
.macro print_space
  la $a0,str_space
  li $v0,4
  syscall
.end_macro

.macro print_enter
  la $a0,str_enter
  li $v0,4
  syscall
.end_macro

.macro get_arguments(%ans)
  li $v0,5
  syscall
  move %ans,$v0
.end_macro

.macro push(%ans)
  sw %ans,0($sp)
  addi $sp,$sp,-4
.end_macro

.macro pop(%ans)
  addi $sp,$sp,4
  lw %ans,0($sp)
.end_macro

.macro get_array(%ans,%i)
  sll %ans,%i,2
.end_macro

.text
  get_arguments($s0)                                      #$s0=n
  li $s1,0                                                #$s1=index=0
  li $s2,1                                                #constant=1
  push($s1)
  jal full_arrange
  li $v0,10
  syscall
  
full_arrange:
  push($ra)
  slt $t0,$s1,$s0
  bne $t0,$0,loop_pre                                #if(index>=n) -> loop
  li $t5,0
  
loop2:
  beq $t5,$s0,loop2_end
  get_array($t6,$t5)
  lw $t6,array($t6)
  move $a0,$t6
  li $v0,1
  syscall
  print_space
  addi $t5,$t5,1
  j loop2
  
loop2_end:
  print_enter
  pop($ra)
  pop($s1)
  jr $ra
  
loop_pre:
  li $t1,0                                           #$t1=i=0
  
loop:
  beq $t1,$s0,loop_end
  get_array($t2,$t1)
  lw $t7,symbol($t2)                                      #$t7=symbol[i]
  bne $t7,$0,i_add
  
  get_array($t3,$s1)
  addi $t4,$t1,1                                          #$t4=i+1
  sw $t4,array($t3)                                       #array[index]=i+1
  sw $s2,symbol($t2)                                      #symbol[i]=1
  addi $s1,$s1,1                                          #$s1=index+1
  push($t1)                                               #push i into stack
  push($s1)                                               #push index+1 into stack
  jal full_arrange
  pop($t1)                                                #pop i
  addi $s1,$s1,-1
  get_array($t2,$t1)
  sw $0,symbol($t2)                                       #symbol[i]=0
  
  addi $t1,$t1,1
  j loop
  
loop_end:
  pop($ra)
  pop($s1)
  jr $ra
  
i_add:
  addi $t1,$t1,1
  j loop
  
  
  
  
  
  
  
  









