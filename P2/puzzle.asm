.data
  graph: .space 256
  
.macro get_arguments(%ans)
  li $v0,5
  syscall
  move %ans,$v0
.end_macro

.macro get_graph(%ans,%i,%j)
  sll %ans,%i,3
  add %ans,%ans,%j
  sll %ans,%ans,2
.end_macro

.macro push(%ans)
  sw %ans,0($sp)
  addi $sp,$sp,-4
.end_macro

.macro pop(%ans)
  addi $sp,$sp,4
  lw %ans,0($sp)
.end_macro

.text
  get_arguments($s0)
  get_arguments($s1)
  li $s2,8                         
  li $s3,1
  #################################   $s0=n,$s1=m   $s2=constant=8,$s3=constant=1
  li $t0,0
  li $t1,0
  
initialize_i:
  beq $t0,$s2,initialize_graph_i_pre
  
initialize_j:
  beq $t1,$s2,initialize_j_end
  get_graph($t2,$t0,$t1)
  sw $s3,graph($t2)
  addi $t1,$t1,1
  j initialize_j
  
initialize_j_end:
  addi $t0,$t0,1
  li $t1,0
  j initialize_i
  
initialize_graph_i_pre:
  li $t0,0
  li $t1,0
  
initialize_graph_i:
  beq $t0,$s0,initialize_graph_i_end
  
initialize_graph_j:
  beq $t1,$s1,initialize_graph_j_end
  li $v0,5
  syscall
  get_graph($t2,$t0,$t1)
  sw $v0,graph($t2)
  addi $t1,$t1,1
  j initialize_graph_j
  
initialize_graph_j_end:
  addi $t0,$t0,1
  li $t1,0
  j initialize_graph_i
  
initialize_graph_i_end:
  get_arguments($s4)
  get_arguments($s5)
  get_arguments($s6)
  get_arguments($s7)
  
  ############################################ $s4=src_i,$s5=src_j,$s6=des_i,$s7=des_j
  addi $s4,$s4,-1
  addi $s5,$s5,-1
  addi $s6,$s6,-1
  addi $s7,$s7,-1
  
  get_graph($t2,$s4,$s5)
  sw $s3,graph($t2)
  push($s4)                                       #push pos_i into stack
  push($s5)                                       #push pos_j into stack
  li $t3,0                                        #sum=0
  jal dfs
  move $a0,$t3                                    #$t3=sum
  li $v0,1
  syscall
  li $v0,10
  syscall
  
dfs:
  push($ra)
  
check1:
  bne $s4,$s6,right
  bne $s5,$s7,right
  addi $t3,$t3,1
  pop($ra)
  jr $ra
  
right:
  addi $s5,$s5,1                                        #$s5=pos_j+1
  slt $t7,$s5,$s1                                       #if(pos_j+1<m) $t7=1
  beq $t7,$0,left_pre
  get_graph($t6,$s4,$s5)
  lw $t8,graph($t6)                                     #$t8=graph[pos_i][pos_j+1]
  bne $t8,$0,left_pre
  sw $s3,graph($t6)                                     #graph[pos_i][pos_j+1]=1
  push($s4)                                             #push pos_i into stack
  push($s5)
  jal dfs
  pop($s5)
  pop($s4)
  get_graph($t6,$s4,$s5)
  sw $0,graph($t6)                                      #graph[][]=0
  addi $s5,$s5,-1
  j left
  
left_pre:
  addi $s5,$s5,-1                                      #pos_j--

left:
  addi $s5,$s5,-1                                        #$s5=pos_j-1
  slt $t7,$s5,$0                                       #if(pos_j-1<0) $t7=1
  bne $t7,$0,up_pre
  get_graph($t6,$s4,$s5)
  lw $t8,graph($t6)                                     #$t6=graph[pos_i][pos_j-1]
  bne $t8,$0,up_pre
  sw $s3,graph($t6)                                     #graph[pos_i][pos_j+1]=1
  push($s4)                                             #push pos_i into stack
  push($s5)
  jal dfs
  pop($s5)
  pop($s4)
  get_graph($t6,$s4,$s5)
  sw $0,graph($t6)                                      #graph[][]=0
  addi $s5,$s5,1
  j up
  
up_pre:
  addi $s5,$s5,1
  
up:
  addi $s4,$s4,1                                        #$s4=pos_i+1
  slt $t7,$s4,$s0                                       #if(pos_i+1<n) $t7=1
  beq $t7,$0,down_pre
  get_graph($t6,$s4,$s5)
  lw $t8,graph($t6)
  bne $t8,$0,down_pre
  sw $s3,graph($t6)
  push($s4)
  push($s5)
  jal dfs
  pop($s5)
  pop($s4)
  get_graph($t6,$s4,$s5)
  sw $0,graph($t6)                                      #graph[][]=0
  addi $s4,$s4,-1
  j down
  
down_pre:
  addi $s4,$s4,-1
  
down:
  addi $s4,$s4,-1                                        #$s4=pos_i-1
  slt $t7,$s4,$0                                       #if(pos_i-1<0) $t7=1
  bne $t7,$0,end_pre
  get_graph($t6,$s4,$s5)
  lw $t8,graph($t6)
  bne $t8,$0,end_pre
  sw $s3,graph($t6)
  push($s4)
  push($s5)
  jal dfs
  pop($s5)
  pop($s4)
  get_graph($t6,$s4,$s5)
  sw $0,graph($t6)                                      #graph[][]=0
  addi $s4,$s4,1                                        #return to normal pos_i,pos_j
  j end
  
end_pre:
  addi $s4,$s4,1                                        #adjust
 
end:
  pop($ra)                                              #return
  jr $ra












