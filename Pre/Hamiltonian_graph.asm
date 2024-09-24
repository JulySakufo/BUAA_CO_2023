.macro get_matrix(%ans,%i,%j)
  sll %ans,%i,3
  add %ans,%ans,%j
  sll %ans,%ans,2
.end_macro
  
.macro get_array(%ans,%i)
  sll %ans,%i,2
.end_macro

.macro get_arguments(%ans)
  li $v0,5
  syscall
  move %ans,$v0
.end_macro

.data
  graph: .space 256
  book:  .space 32
  
.text
  get_arguments($s0)                      #$s0=n
  get_arguments($s1)                      #$s1=m
  li $t0,0                                #$t0=i=0
initialize_graph:
  beq $t0,$s1,end_graph
  get_arguments($s2)                      #$s2=x
  get_arguments($s3)                      #$s3=y
  addi $s2,$s2,-1                         #$s2=x-1
  addi $s3,$s3,-1                         #$s3=y-1
  li $s4,1                                #presents for 1
  get_matrix($t1,$s2,$s3)
  sw $s4,graph($t1)                       #graph[x-1][y-1]=1
  get_matrix($t1,$s3,$s2)
  sw $s4,graph($t1)                       #graph[y-1][x-1]=1
  addi $t0,$t0,1                          #i++
  j initialize_graph
  
end_graph:                                #have initialized the graph
  li $s5,0                                #$s5=ans=0
  li $t4,0                                #$t4=0 for recursion(int x)
  jal dfs                                 #begin recursion
  move $a0,$s5                            #print ans
  li $v0,1
  syscall
  li $v0,10
  syscall                                 #exit the execution
  

check_1:
  beq $t0,$s0,check_1_end
  lw $t7,book($t8)
  and $t6,$t6,$t7                         #flag&=book[i]
  addi $t0,$t0,1
  sll $t8,$t0,2                           #$t8=4*i for offset
  j check_1
  
check_1_end:
  beq $t6,$0,loop_2                       #if flag==0 not return
  get_matrix($t1,$t4,$0)
  lw $t1,graph($t1)                       #$t1=graph[x][0]
  beq $t1,$0,loop_2                       #if graph[x][0]==0 not return
  li $s5,1                                #ans=1
  addi $sp,$sp,8
  lw $ra,0($sp)                                  
  jr $ra                                  #end this dfs
  
loop_2:
  li $t4,0                                #i=0
##################   $t4 and $t9 should be saved into memory  
##################    stack: $ra,x,i;
loop_3:
  sw $t4,0($sp)                           #push presentive i into stack for return
  addi $sp,$sp,-4                         #push into stack in time
  beq $t4,$s0,out                         #for(i=0;i<n;i++)
  get_array($t7,$t4)
  lw $t7,book($t7)                        #$t7=book[i]
  bne $t7,$0,loop_4                       #if book[i]!=0 not return 
  lw $t9,8($sp)                           #get memory's x
  get_matrix($t1,$t9,$t4)
  lw $t1,graph($t1)                       #$t1=graph[x][i]
  beq $t1,$0,loop_4                       #if graph[x][i]==0 not return
 # sw $t4,0($sp)                           #push presentive i into stack for return
 # addi $sp,$sp,-4
##################  wrong reason:don't push i into stack in time
  jal dfs                                 #deeply recursion
  lw $t4,4($sp)                           #get back i
  lw $t9,8($sp)                           #get back x

loop_4:
  addi $t4,$t4,1                          #i++
  addi $sp,$sp,4                          #don't need this i,so push back,but we can save i in time
  j loop_3
      
out:
  lw $t9,8($sp)
  addi $sp,$sp,4                          #after the recursion and get back the x
  get_array($t7,$t9)
  sw $0,book($t7)                         #book[x]=0
  addi $sp,$sp,8
  lw $ra,0($sp)
  jr $ra                                  #end the dfs

dfs:
  
  sw $ra,0($sp)                           #push the $ra into stack
  addi $sp,$sp,-4
  get_array($t5,$t4)                      #$t4=x
  sw $s4,book($t5)                        #book[x]=1
  sw $t4,0($sp)                           #push the x into the stack
  addi $sp,$sp,-4
  li $t6,1                                #$t6=flag=1
  li $t0,0                                #$t0=i=0
  li $t8,0
  j check_1
  

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
