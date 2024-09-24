.data
  str_is: .asciiz "1"
  str_is_not: .asciiz "0"

.text
  li $v0,5
  syscall                     #read an integar
  move $s0,$v0                #$s0=n
  li $t0,400                  #$t0=400
  div $s0,$t0                 #hi=$s0%t0
  mfhi $t1                    #$t1=hi
  beq $t1,$0,print_1          #n%400==0
  li $t0,4                    #div=4
  div $s0,$t0                 #n/4
  mfhi $t1
  beq $t1,$0,judge_1          #n%4==0
  j print_0                   #n isn't a leap year
  
print_1:
  la $a0,str_is
  li $v0,4
  syscall                     #print 1
  j done

judge_1:
  li $t0,100
  div $s0,,$t0
  mfhi $t1
  bne $t1,$0,print_1          #n%4==0&&n%100!=0
  j print_0                   #n isn't a leap year
  
print_0:
  la $a0,str_is_not           
  li $v0,4
  syscall
  j done


done:
  li $v0,10                   #exit
  syscall
  