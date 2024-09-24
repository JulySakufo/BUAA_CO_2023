.data
  matrix: .space 484
  core: .space 484
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

.macro get_matrix(%ans,%i,%j)
  li $s0,11
  mult %i,$s0
  mflo %ans
  add %ans,%ans,%j
  sll %ans,%ans,2
.end_macro

.macro get_arguments(%ans)
  li $v0,5
  syscall
  move %ans,$v0
.end_macro

.text
  get_arguments($s1)
  get_arguments($s2)
  get_arguments($s3)
  get_arguments($s4)
  ######################################## $s1=m1,$s2=n1,$s3=m2,$s4=n2
  
  li $t0,0
  li $t1,0
  
initialize_matrix_i:
  beq $t0,$s1,initialize_matrix_i_end
  
initialize_matrix_j:
  beq $t1,$s2,initialize_matrix_j_end
  li $v0,5
  syscall
  get_matrix($t2,$t0,$t1)
  sw $v0,matrix($t2)                                      #matrix[i][j]
  addi $t1,$t1,1
  j initialize_matrix_j
  
  
initialize_matrix_j_end:
  addi $t0,$t0,1
  li $t1,0
  j initialize_matrix_i
  
initialize_matrix_i_end:
  li $t0,0
  li $t1,0
  
 #########################################
initialize_core_i:
  beq $t0,$s3,initialize_core_i_end
  
initialize_core_j:
  beq $t1,$s4,initialize_core_j_end
  li $v0,5
  syscall
  get_matrix($t2,$t0,$t1)
  sw $v0,core($t2)                                             #core[i][j]
  addi $t1,$t1,1
  j initialize_core_j
  
initialize_core_j_end:
  addi $t0,$t0,1
  li $t1,0
  j initialize_core_i

initialize_core_i_end:
  sub $s5,$s1,$s3
  addi $s5,$s5,1                                               #i_difference=m1-m2+1
  sub $s6,$s2,$s4
  addi $s6,$s6,1                                               #j_difference=n1-n2+1
  li $t0,0                                                     #i
  li $t1,0                                                     #j
  li $t2,0                                                     #p
  li $t3,0                                                     #q
  li $t4,0                                                     #sum
  
loop1:
  beq $t0,$s5,loop1_end
  
loop2:
  beq $t1,$s6,loop2_end
  li $t4,0
  
loop3:
  beq $t2,$s3,loop3_end
  
loop4:
  beq $t3,$s4,loop4_end
  get_matrix($t5,$t2,$t3)                                      
  lw $t5,core($t5)                                            #$t5=core[p][q]
  add $t6,$t0,$t2                                             #$t6=i+p
  add $t7,$t1,$t3                                             #$t7=j+q
  get_matrix($t8,$t6,$t7)
  lw $t8,matrix($t8)                                          #$t8=matrix[i+p][j+q]
  mult $t5,$t8
  mflo $t9                                                    #$t9=matrix[i+p][j+q]*core[p][q]
  add $t4,$t4,$t9                                             #sum=sum+$t9
  
  addi $t3,$t3,1
  j loop4
  
loop4_end:
  addi $t2,$t2,1
  li $t3,0
  j loop3
  
loop3_end:
  move $a0,$t4
  li $v0,1
  syscall
  print_space
  addi $t1,$t1,1
  li $t2,0
  j loop2
loop2_end:
  print_enter
  addi $t0,$t0,1
  li $t1,0
  j loop1

loop1_end:
  li $v0,10
  syscall












