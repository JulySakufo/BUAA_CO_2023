.data
  str_space: .asciiz "\n"

.macro print_space
  la $a0,str_space
  li $v0,4
  syscall
.end_macro
  
.macro get_arguments(%ans)
  li $v0,5
  syscall
  move %ans,$v0
.end_macro

.macro multiple(%i,%j)
  mult %i,%i
  mflo %j
  mult %i,%j
  mflo %j
.end_macro

.text
  get_arguments($s0)                                                 #$s0=m
  get_arguments($s1)                                                 #$s1=n
  move $t1,$s0                                                       #$t1=i=m
  li $s2,10                                                          #$s2=divider=10
loop1:
  beq $t1,$s1,out                                              #for(i=m;i<n;i++)
  move $t2,$t1                                                       #$t2=origin=i
  div $t2,$s2                                                        
  mfhi $t3                                                           #$t3=a
  mflo $t2
  div $t2,$s2
  mfhi $t4                                                           #$t4=b
  mflo $t2
  div $t2,$s2
  mfhi $t5                                                           #$t5=c
  
  multiple($t3,$s3)                                                  #a*a*a
  multiple($t4,$s4)                                                  #b*b*b
  multiple($t5,$s5)                                                  #c*c*c
  add $s6,$s3,$s4
  add $s7,$s6,$s5
  beq $s7,$t1,loop1_end                                              #if(sum==i) print
  addi $t1,$t1,1
  j loop1
loop1_end:
  move $a0,$s7
  li $v0,1
  syscall
  print_space
  addi $t1,$t1,1
  j loop1
  
out:
  li $v0,10
  syscall