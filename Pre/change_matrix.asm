.data
  matrix: .space 10000             #int matrix[50][50] 50*50*4(byte)
  str_space: .asciiz " "
  str_enter: .asciiz "\n"
  
.macro getindex(%ans,%i,%j,%k)       #intialize the matrix
  li %k,50                           #%k=50
  mult %i,%k
  mflo %ans
  add %ans,%ans,%j
  sll %ans,%ans,2                    #%ans=(i*50+j)*4
.end_macro

.text
intialize_the_matrix:
  li $v0,5                        #read n
  syscall
  move $s0,$v0                    #$s0=n
  li $v0,5                        #read m
  syscall
  move $s1,$v0                    #$s1=m
  li $t0,0                        #$t0=i=0
  li $t1,0                        #$t1=j=0
  
  
in_j:
  beq $t1,$s1,in_j_end            #j=m
  li $v0,5
  syscall                         #$v0=input the integar
  getindex($t2,$t0,$t1,$t3)       #change the arguments $t2
  sw $v0,matrix($t2)              #matrix[i][j]=$v0
  addi $t1,$t1,1                  #j=j+1
  j in_j                          #for(j=0;j<m;j++)
  
in_j_end:
  addi $t0,$t0,1                  #i=i+1
  beq $t0,$s0,adjust              #i=n
  li $t1,0                        #if(i<n) j=0 re initialize
  j in_j                          #i++,j=0
                                  #already initialize the matrix
adjust:
  addi $t0,$t0,-1                 #i=n-1 
  addi $t1,$t1,-1                 #j=m-1
  li $t6,-1                       #break point                                
out_j:
  beq $t0,$t6,end                 #if i=-1 end the execution
  beq $t1,$t6,decrease_i          #if j=-1 i=i-1
  getindex($t2,$t0,$t1,$t3)       #get the memory address//$t2=matrix[i][j]
  lw $t4,matrix($t2)              #$t4=matrix[i][j]
  beq $t4,$0,extra                #whether matrix[i][j]==0? if yes,not print;else print i,j,matrix[i][j]
  move $a0,$t0                    #print i
  addi $a0,$a0,1                  #i=i+1
  li $v0,1
  syscall
  la $a0,str_space                #print space " "
  li $v0,4
  syscall                       
  move $a0,$t1                    #print j
  addi $a0,$a0,1                  #j=j+1
  li $v0,1
  syscall
  la $a0,str_space                #print space " "
  li $v0,4
  syscall
  lw $a0,matrix($t2)              #print matrix[i][j]
  li $v0,1
  syscall
  la $a0,str_enter                #print enter
  li $v0,4
  syscall
  addi $t1,$t1,-1                 #j=j-1
  j out_j
  
extra:
  addi $t1,$t1,-1
  j out_j

decrease_i:
  addi $t0,$t0,-1                 #i--
  move $t1,$s1                    #j=m
  j out_j                         #return

end:
  li $v0,10
  syscall                         #exit
  
  

  
  
  
  
  
  