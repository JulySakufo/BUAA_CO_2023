.data
  array: .space 4000
  str_find: .asciiz "1\n"
  str_not_find: .asciiz "0\n"
  
.macro get_arguments(%ans)
  li $v0,5
  syscall
  move %ans,$v0
.end_macro

.macro get_array(%ans,%i)
  sll %ans,%i,2
.end_macro

.macro print0
  la $a0,str_not_find
  li $v0,4
  syscall
.end_macro

.macro print1
  la $a0,str_find
  li $v0,4
  syscall
.end_macro

.text
  get_arguments($s0)                                          #$s0=m
  li $t0,0                                                    #$t0=i=0
  
loop1:
  beq $t0,$s0,loop1_end
  li $v0,5
  syscall
  move $t1,$v0
  get_array($t2,$t0)
  sw $t1,array($t2)                                           #array[i]=$t1
  addi $t0,$t0,1
  j loop1
  
loop1_end:
  get_arguments($s1)                                          #$s1=n
  li $t0,0
  
loop2:
  beq $t0,$s1,loop2_end
  li $v0,5
  syscall
  move $t1,$v0                                                #$t1=key
  jal binary_search                                           #go into binary function
  addi $t0,$t0,1
  j loop2

binary_search:
  li $t2,0                                                    #$t2=low=0
  addi $s5,$s0,-1
  move $t3,$s5                                                #$t3=high=m-1
  li $s2,1
binary_search_process:
  slt $t4,$t3,$t2
  beq $t4,$s2,out0                                             #if(low>high) print 0
  
  sub $t9,$t3,$t2
  srl $t9,$t9,1
  add $t5,$t2,$t9                                              #mid=low+(high-low)/2
  get_array($t6,$t5)
  lw $t7,array($t6)                                           #$t7=array[mid]
  
  beq $t7,$t1,out1                                            #if(key==array[mid])
  slt $t8,$t1,$t7                                             #$t8=flag
  beq $t8,$s2,left                                            #if(key<array[mid])
  j right                                                     #if(key>array[mid])
  
left:
  addi $t5,$t5,-1
  move $t3,$t5                                                #$t3=high=mid-1
  j binary_search_process

right:
  addi $t5,$t5,1
  move $t2,$t5                                                #$t2=low=mid+1
  j binary_search_process
  
out0:
  print0
  jr $ra                                                      #go back to main

out1:
  print1
  jr $ra
  
loop2_end:
  li $v0,10
  syscall
  
  
  
  
  
  
  
  