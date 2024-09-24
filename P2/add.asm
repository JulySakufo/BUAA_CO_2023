.data
  matrix_1: .space 256
  change_1: .space 256
  matrix_2: .space 256
  change_2: .space 256
  str_before: .asciiz "The result is:\n"
  str_space: .asciiz " "
  str_enter: .asciiz "\n"
.macro print_str_before
  la $a0,str_before
  li $v0,4
  syscall
.end_macro

.macro print_str_space
  la $a0,str_space
  li $v0,4
  syscall
.end_macro

.macro print_str_enter
  la $a0,str_enter
  li $v0,4
  syscall
.end_macro

.macro get_arguments(%ans)
  li $v0,5
  syscall
  move %ans,$v0
.end_macro

.macro get_matrix(%ans,%i,%j)
  sll %ans,%i,3
  add %ans,%ans,%j
  sll %ans,%ans,2
.end_macro

.text
  get_arguments($s0)                                                 #$s0=n
  get_arguments($s1)                                                 #$s1=m
  li $t0,0                                                           #$t0=i=0
  
  
loop1_i:
  beq $t0,$s0,loop1_i_end                                            #i-for
  li $t1,0                                                           #$t1=j=0
  
loop1_j:  
  beq $t1,$s1,loop1_j_end                                            #j-for
  li $v0,5
  syscall
  move $t2,$v0
  get_matrix($t3,$t1,$t0)
  sw $t2,change_1($t3)                                               #change_1[j][i]=matrix_1[i][j]
  addi $t1,$t1,1
  j loop1_j
  
loop1_j_end:
  addi $t0,$t0,1
  j loop1_i
  
loop1_i_end:
  li $t0,0
  
loop2_i:
  beq $t0,$s0,loop2_i_end
  li $t1,0

loop2_j:  
  beq $t1,$s1,loop2_j_end                                            #j-for
  li $v0,5
  syscall
  move $t2,$v0
  get_matrix($t3,$t1,$t0)
  sw $t2,change_2($t3)                                               #change_2[j][i]=matrix_2[i][j]
  addi $t1,$t1,1
  j loop2_j
  
loop2_j_end:
  addi $t0,$t0,1
  j loop2_i
  
loop2_i_end:
  print_str_before
  li $t0,0
  
loop3_i:
  beq $t0,$s1,loop3_i_end
  li $t1,0
  
loop3_j:
  beq $t1,$s0,loop3_j_end
  get_matrix($t2,$t0,$t1)
  get_matrix($t3,$t0,$t1)
  lw $t4,change_1($t2)
  lw $t5,change_2($t3)
  add $t6,$t4,$t5
  move $a0,$t6
  li $v0,1
  syscall
  print_str_space
  addi $t1,$t1,1
  j loop3_j
  
loop3_j_end:
  print_str_enter
  addi $t0,$t0,1
  j loop3_i
  
loop3_i_end:
  li $v0,10
  syscall
  
  
  
  
  
  
  
  






  