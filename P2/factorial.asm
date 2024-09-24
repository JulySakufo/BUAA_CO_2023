.data
  ans: .space 4020
  
.macro get_arguments(%ans)
  li $v0,5
  syscall
  move %ans,$v0  
.end_macro

.macro get_array(%ans,%i)
  sll %ans,%i,2
.end_macro

.text
  get_arguments($s0)                                   #$s0=n
  li $t0,0
  li $s1,1                                             #$s1=constant=1
  li $s2,1005                                          #$s2=constant=1005
  li $s3,10                                            #$s3=constant=10
  sw $s1,ans($t0)                                      #ans[0]=1
  addi $s0,$s0,1                                       #$s0=n+1
  li $t0,1                                             #i
  li $t1,0                                             #j
  
pre:
  beq $t0,$s0,pre_end
  
loop1:
  beq $t1,$s2,loop1_end
  get_array($t3,$t1)
  lw $t4,ans($t3)                                      #$t4=ans[j]
  mult $t0,$t4              
  mflo $t4                                             #$t4=ans[j]*i
  sw $t4,ans($t3)
  addi $t1,$t1,1
  j loop1
  
  
loop1_end:
  li $t1,0
  
loop2:
  beq $t1,$s2,loop2_end
  get_array($t3,$t1)
  lw $t4,ans($t3)                                      #$t4=ans[j]
  slt $t5,$t4,$s3                                      #if(ans[j]<10) $t5=1
  beq $t5,$s1,j_add 
  addi $t6,$t1,1
  get_array($t7,$t6)
  lw $t8,ans($t7)                                      #$t8=ans[j+1]
  div $t4,$s3
  mfhi $s4                                             #$s4=ans[j]%10
  mflo $s5                                             #$s5=ans[j]/10
  add $t8,$t8,$s5
  move $t4,$s4
  sw $t4,ans($t3)                                      #ans[j]=ans[j]%10
  sw $t8,ans($t7)                                      #ans[j+1]=ans[j+1]+ans[j]/10
  addi $t1,$t1,1
  j loop2
  
loop2_end:
  addi $t0,$t0,1
  li $t1,0
  j pre
  
j_add:
  addi $t1,$t1,1
  j loop2
  
pre_end:
  li $t0,1004
  
loop3:
  slt $t3,$t0,$0                    #if(k<0) $t3=1
  bne $t3,$0,loop3_end
  get_array($t1,$t0)
  lw $t2,ans($t1)
  bne $t2,$0,loop3_end
  addi $t0,$t0,-1
  j loop3
  
loop3_end:
  slt $t3,$t0,$0                    #if(k<0) $t3=1
  bne $t3,$0,end
  get_array($t1,$t0)
  lw $t2,ans($t1)
  move $a0,$t2
  li $v0,1
  syscall
  addi $t0,$t0,-1
  j loop3_end
  
end:
  li $v0,10
  syscall
  
  
  
  
  
  
  
  
  
  
  
  
  
  