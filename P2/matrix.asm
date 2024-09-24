.data
  matrix_1: .space 256
  matrix_2: .space 256
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

.macro get_matrix(%ans,%i,%j)
  sll %ans,%i,3
  add %ans,%ans,%j
  sll %ans,%ans,2
.end_macro

.text
  get_arguments($s0)                                 #$s0=n
  li $t0,0                                           #$t0=i=0
  li $t1,0                                           #$t1=j=0

initialize_matrix_1_i:
  beq $t0,$s0,initialize_matrix_1_i_end              #for(i=0;i<n;i++)
  
initialize_matrix_1_j:
  beq $t1,$s0,initialize_matrix_1_j_end              #for(j=0;j<n;j++)
  li $v0,5
  syscall
  move $t2,$v0
  get_matrix($t3,$t0,$t1)
  sw $t2,matrix_1($t3)                               #matrix_1[i][j]=%d
  addi $t1,$t1,1
  j initialize_matrix_1_j
  
initialize_matrix_1_i_end:
  li $t0,0
  li $t1,0
  j initialize_matrix_2_i
  
initialize_matrix_1_j_end:
  addi $t0,$t0,1                                     #i++
  li $t1,0                                           #j=0
  j initialize_matrix_1_i
  
  ###########################################
initialize_matrix_2_i:
  beq $t0,$s0,initialize_matrix_2_i_end
  
  initialize_matrix_2_j:
  beq $t1,$s0,initialize_matrix_2_j_end              #for(j=0;j<n;j++)
  li $v0,5
  syscall
  move $t2,$v0
  get_matrix($t3,$t0,$t1)
  sw $t2,matrix_2($t3)                               #matrix_2[i][j]=%d
  addi $t1,$t1,1
  j initialize_matrix_2_j
  
initialize_matrix_2_i_end:
  li $t0,0
  li $t1,0
  j calculate_pre
  
initialize_matrix_2_j_end:
  addi $t0,$t0,1                                     #i++
  li $t1,0                                           #j=0
  j initialize_matrix_2_i
 
 ################################################3
calculate_pre:
  li $t0,0
  li $t1,0
  li $t2,0
  li $s1,0
  
calculate_i:
  beq $t0,$s0,calculate_i_end                        #for(i=0;i<n;i++)
  
calculate_j:
  beq $t1,$s0,calculate_j_end                        #for(j=0;j<n;j++)
  li $s1,0                                           #sum=0
  
calculate_k:
  beq $t2,$s0,calculate_k_end
  get_matrix($t3,$t0,$t2)                           #matrix_1[i][k]
  get_matrix($t4,$t2,$t1)                           #matrix_2[k][j]
  lw $t3,matrix_1($t3)                              #$t3=matrix_1[i][k]
  lw $t4,matrix_2($t4)                              #$t4=matrix_2[k][j]
  mult $t3,$t4
  mflo $t5                                          #$t5=matrix_1[i][k]*matrix_2[k][j]
  add $s1,$s1,$t5                                   #sum=sum+$t5
  addi $t2,$t2,1
  j calculate_k
  
calculate_k_end:
  move $a0,$s1
  li $v0,1
  syscall                                           #print(sum)
  print_space                                       #print" "
  addi $t1,$t1,1                                    #j++
  li $t2,0                                          #k=0
  j calculate_j
  
calculate_j_end:
  print_enter
  addi $t0,$t0,1
  li $t1,0                                          #j=0
  j calculate_i
  
calculate_i_end:
  li $v0,10
  syscall