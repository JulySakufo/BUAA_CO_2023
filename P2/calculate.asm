.data
  array: .space 104
  array_sequence: .space 104
  str_enter: .asciiz "\n"
  str_space: .asciiz " "
.macro get_array(%ans,%i)
  sll %ans,%i,2
.end_macro
.text
  li $v0,5
  syscall
  move $s0,$v0                     #$s0=n
  li $t0,0                         #$t0=i=0
  li $t4,0                         #$t4=j=0
  li $s1,'\n'                      #$s1='\n' to skip enter
  li $s2,'a'                       #$s2='a' to sub
  li $s3,26                    
loop1:
  beq $t0,$s0,loop1_end
  li $v0,12
  syscall
  move $s4,$v0                     #put v0 into s4
  beq $s4,$s1,loop1                #if(ch=='\n' skip)
  ###################### if ch!='\n'
  jal loop3
  sub $t1,$s4,$s2                  #make sure the correct address
  get_array($t2,$t1)
  lw $t3,array($t2)                #$t3=array[ch-'a']
  addi $t3,$t3,1                   #array[ch-'a']++
  sw $t3,array($t2)                #recite in memory
  addi $t0,$t0,1                   #i++
  j loop1
  
loop1_end:
  li $t0,0
loop2:
  beq $t0,$s3,end
  get_array($t4,$t0)
  lw $t5,array_sequence($t4)                            #$t5=appear[i]
  beq $t5,$0,check                                       #if(appear[i]=0) means not have char
  subi $t6,$t5,'a'                                       #$t6=appear[i]-'a'
  get_array($t2,$t6)
  lw $t3,array($t2)                                     #$t3=cnt[appear[i]-'a']
  beq $t3,$0,nothing
  li $v0,11
  move $a0,$t5
  syscall                                               #print the ch
  la $a0,str_space
  li $v0,4
  syscall                                               #print the space
  move $a0,$t3
  li $v0,1
  syscall                                               #print the sum
  la $a0,str_enter
  li $v0,4
  syscall
  addi $t0,$t0,1
  j loop2
  
check:
  addi $t0,$t0,1
  j loop2
  
  
loop3:
  beq $t4,$s3,out
  get_array($t6,$t4)
  lw $t5,array_sequence($t6)                           #$t5=appear[j]
  beq $t5,$s4,out                                      #if(appear[j]==ch) break
  beq $t5,$0,loop3_end
  addi $t4,$t4,1                                       #j++
  j loop3

loop3_end:
  sw $s4,array_sequence($t6)                           #appear[j]=ch
  li $t4,0                                             #reset j
  jr $ra                                               #go back to loop1
  
out:
  li $t4,0                                             #reset
  jr $ra                                               #go back to loop1
  
  
nothing:
  addi $t0,$t0,1
  j loop2

end:
  li $v0,10
  syscall









  
