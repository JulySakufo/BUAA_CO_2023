.data
  strings_1: .space 100
  strings_2: .space 100
  strings_is: .asciiz "1"
  strings_is_not: .asciiz "0"
.macro get_array(%ans,%i)
  sll %ans,%i,2
.end_macro

.macro print_is
  la $a0,strings_is
  li $v0,4
  syscall
.end_macro

.macro print_is_not
  la $a0,strings_is_not
  li $v0,4
  syscall
.end_macro

.macro get_arguments(%ans)
  li $v0,5
  syscall
  move %ans,$v0
.end_macro

.text
  get_arguments($s0)                                     #$s0=n
  li $t0,0                                               #$t0=i=0
  move $t1,$s0
  addi $t1,$t1,-1                                        #$t1=n-1-i
  
loop1:
  beq $t0,$s0,loop1_end                                  #for(i=0;i<n;i++)
  get_array($t2,$t0)                                     #strings_1[i]
  get_array($t3,$t1)                                     #strings_2[n-1-i]
  li $v0,12
  syscall
  sw $v0,strings_1($t2)
  sw $v0,strings_2($t3)                                  #strings_2[n-1-i]=strings_1[i]
  addi $t0,$t0,1                                         #i++
  addi $t1,$t1,-1                                        #n-1-i-1
  j loop1
  
loop1_end:
  li $t0,0
  li $s1,0                                               #flag=0
  
loop2:
  beq $t0,$s0,loop2_end                                  #normally end means equal
  get_array($t2,$t0)
  lw $t3,strings_1($t2)
  lw $t4,strings_2($t2)
  bne $t3,$t4,print                                      #not equal
  addi $t0,$t0,1
  j loop2
  
loop2_end:
  print_is
  li $v0,10
  syscall

print:
  print_is_not
  li $v0,10
  syscall








