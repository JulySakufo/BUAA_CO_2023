.data
list: .space 400
enter: .asciiz"\n"

.macro print_enter
  la $a0,enter
  li $v0,4
  syscall
.end_macro

.macro get_arguments(%ans)
  li $v0,5
  syscall
  move %ans,$v0
.end_macro

.text
  get_arguments($s0)                        #$s0=n
  get_arguments($s1)                        #$s1=m
  li $t0,0
  
initialize_list:
  beq $t0,$s0,end_list
  addi $t1,$t0,1
  sll $t2,$t0,2
  sll $t1,$t1,2
  sw $t1,list($t2)                          #p->link=q and its value is next pointer's address
  addi $t0,$t0,1
  j initialize_list
  
end_list:
  addi $t0,$t0,-1
  sll $t2,$t0,2
  sw $0,list($t2)                           #rear->link=head
  move $t3,$t2
  move $t4,$0
  li $t0,1
  
josef:
  lw $s2,list($t4)
  beq $s2,$t4,end                           #head->link=head
  beq $t0,$s1,josef_out
  lw $t3,list($t3)                          #prev 0000_0000
  lw $t4,list($t4)                          #now  0000_0004
  addi $t0,$t0,1
  j josef
  
josef_out:
  lw $t5,list($t3)
  srl $t5,$t5,2
  addi $t5,$t5,1
  move $a0,$t5
  li $v0,1
  syscall
  print_enter
  lw $t4,list($t4)
  sw $t4,list($t3)                          #prev->link=now->link
  li $t0,1
  j josef
  
end:
  srl $s2,$s2,2
  addi $s2,$s2,1
  move $a0,$s2
  li $v0,1                                  #print the last
  syscall
  li $v0,10
  syscall
  
  
  
  
  
  
  