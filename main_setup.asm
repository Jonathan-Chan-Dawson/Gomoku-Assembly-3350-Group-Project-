# Main Setup For Connect Four
# Team Members: Jonathan Dawson, Bejamin Bruns, Graydon Isom, Caleb Lewis

 .data
  Example_Array: .word 1, 2, 3, 4, 5
  boardStart: .word 0x10040000 # start in top left corner
  boardColor: .word 0xFF87633A # Dark brown board color
  
 .text
 .globl main
 
 main: 
 jal drawBoard
 li $v0, 10
 syscall
 
# DRAW BOARD ------------------------------------------------------------ 
# Fill a 15x15 Gomoku board starting from 0,0
# 50x50 pixel diff in grid space

 drawBoard:
   li $t1, 0 # y=0
   lw  $t4, boardColor
   
   drawRow:
     bge $t1, 256, drawExit # y
     
     # row address = boardStart + row*512
     lw $t0, boardStart
     sll $t3, $t1, 10 # y * 512 in t3
     add $t0, $t0, $t3 # row starting address
     
     li $t2, 0 # x = 0
     
     drawCol:
       bge $t2, 256, nextRow # x > 300 then go to nextRow
       
       # Paint pixel
       sw  $t4, 0($t0)
       
       addi $t2, $t2, 1 # x+=1
       addi $t0, $t0, 4 # current pixel
       
       j drawCol
     
     nextRow:
       addi $t1, $t1, 1
       j drawRow
   
   drawExit:
     jr $ra
     
