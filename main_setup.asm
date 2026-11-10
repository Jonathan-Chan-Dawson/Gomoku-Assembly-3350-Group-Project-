# Main Setup For Connect Four
# Team Members: Jonathan Dawson, Bejamin Bruns, Graydon Isom, Caleb Lewis
# Step 1: Make the Background and the Grid
# Step 2: Have Player Be Player 1. Place a Piece in the 
# Step 3: Use Move_Loop and li and move to continue moving and implementing

# Notes: Use t For Temporary, a For Into-Functions, v for outputted or
 .data
 imageBuffer: .space 0x80000 # allocate space for 512 x 256 x 4 (each pixel is stored with a word)
 
 # Grid
 GRID_X: .word 50 # Start X
 GRID_Y: .word 50 # Start Y
 GRID_ROWS: .word 15 # Number Rows. Note: Space Lines 8 Pixels Between
 GRID_COLUMNS: .word 15 # Number Columns. Note: Each Pixel is 8 In Between, Space Lines 8 Pixels Between
  
 GRID_COLOR: .word 0x000000AA # First Four Characters Are Filler Reminder
 boardStart: .word 0x10040000 # start in top left corner
 boardColor: .word 0xFF87633A # Dark brown board color
  
 # Pieces
 PIECE_COLOR_P1: .word 0x00FFFFFF # White Piece For Player 1
 PIECE_COLOR_P2: .word 0x00000000 # Black Piece For Player 2
  
 # Array
 .align 2 # Used Since Last Element Was Word
 GOMOKU_GRID: .word 0:225 # 15*15 Array is 225
  
 # Variables
 current_player: .word 1
 player_col: .word 7 # Middle
 player_row: .word 7 # Middle
  
 .text
 .globl main
 
 main: 
 lw $s0, current_player
 lw $s1, player_col
 lw $s2, player_row
 
 j drawBoard
 
 
 li $v0, 10
 syscall
 
# Draw Grid: a0 = x, a1 = y, a2 = width, a3 = height. t0 will be color. # DRAW BOARD ------------------------------------------------------------ 
# Fill 512x512 Bitmap display with brown
# Unit width x height is 2 x 2
# DRAW BOARD ------------------------------------------------------------
# DRAW BOARD ------------------------------------------------------------ 
# Fill a 15x15 Gomoku board starting from 0,0
# 50x50 pixel diff in grid space

 drawBoard:
<<<<<<< Updated upstream
   li $t1, 0 # y=0
   lw  $t4, boardColor
 
   drawRow:
     bge $t1, 256, drawExit # y
     
     # row address = boardStart + row * 512
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
     
=======
  li $t1, 0 # y=0
  lw $t4, boardColor
 
  drawRow:
   bge $t1, 256, drawExit # y
     
   # row address = boardStart + row * 512
   lw $t0, boardStart
   sll $t3, $t1, 10 # y * 512 in t3
   add $t0, $t0, $t3 # row starting address
     
   li $t2, 0 # x = 0
     
  drawCol:
   bge $t2, 256, nextRow # x > 300 then go to nextRow
       
   # Paint pixel
   sw $t4, 0($t0)
       
   addi $t2, $t2, 1 # x+=1
   addi $t0, $t0, 4 # current pixel
       
   j drawCol
     
  nextRow:
   addi $t1, $t1, 1
   j drawRow
   
  drawExit:
   jr $ra
     
 # UPDATE GRID AND GET COLOR: Checks The Grid and Then the Color For Because What's Inside the Actual Grid
 update_grid: 
  # Updates Pointer For Grid # Update Grid ~ s3 is the last color
  jal get_tile_color
  sw $t5, 0($t0) 
  # Jump to Keyboard
  j jump_to_keyboard
>>>>>>> Stashed changes
 
 
 # Insert Piece Functions. Worst Case Scenario: One Piece Duplicates Recursively Into The Full Board Wingspan.
 wait_for_keyboard: # Loop Constatnly Checking For Inputs Of WASD Keys. When Insert (Space), Inset Piece At That Location
 lui $t0, 0xFFFF # Base MMIO Address
 lw $t1, 0($t0) # Loads Control
 andi $t1, $t1, 1 # Checks If Bit Is Ready
 beq $t1, $zero, wait_for_keyboard
 
 lw $t2, 4($t0) # Loads Keyboard Address
 
 check_up: #Check Up Key
  li $t3, 'w'
  bne $t2, $t3, check_down
  ble $s2, $zero, jump_to_keyboard
  addi $s2, $s2, -1 # row -= 1
  j update_grid
 
 check_down:
  li $t3, 's'
  bne $t2, $t3, check_left
  lw $t4, GRID_COLUMNS
  bge $s2, $t4, jump_to_keyboard
  addi $s2, $s2, 1 # row += 1
 
 check_left:
  li $t3, 'a'
  bne $t2, $t3, check_right
  ble $s2, $zero, jump_to_keyboard
  addi $s1, $s1, -1 # column -= 1
  
 check_right:
  li $t3, 'd'
  bne $t2, $t3, check_space
  lw $t4, GRID_ROWS
  bge $s2, $t4, jump_to_keyboard
  addi $s1, $s1, 1 # column += 1
  
 check_space: #Move to Insert Piece
  li $t3, ' '
  bne $t2, $t3, jump_to_keyboard
  j insert_piece #s1 is col, s2 is row
  
 
 update_grid: # Updates Pointer For Grid
  # Update Grid
  # Jump to Keyboard
  
  j jump_to_keyboard
  
 insert_piece: # Inserts Piece
 # Calculation For Array: Base + (row * Col #) * 4 (4 Bytes Allocated Per Word)
 # Start The Piece On the Top Right
 li $t0, 0 #base
 lw $t1, GRID_ROW
 mult $t2, $s2, $t1
 mult $t2, $t2, 4
 
 check_win: # Check For Win. Check Vertical, Horizontal, Right-Left Diagonals, and Left-Right Diagonals
 
 switch_players: # Switch Players After Check Win, Then End Turn
 li $t0, 1 
 bne $s0, $t0 #If Player is not 1, Switch To P2, Else Switch To P1
 
 set_to_p1:
 #li $s0, 1
 #la $t0, current_player
 #sw $s0, 0($t0) # Tutorial on switching to current_player to 0($t0)
 
 li $s0, 1
 j jump_to_keyboard
 
 set_to_p2:
 li $s0, 2
 j jump_to_keyboard
 
 jump_to_keyboard:
 j wait_for_keyboard
 
 # Win Functions
 simulate_win: # When Won, Will Show Text You Won In Bottom, and Cannot Place More Pieces.
 
 # Restart Function
 func_restart_board: # Clears the Board and Restarts
 
 # Idea: Use "On Claude" AI. Sends quotes
 
 # Idea: Add an Undo Button. Plus Add a Dark Mode.
 
 # Idea: "Hard" Mode
 
 # Idea: Rage Quit Button?
 
 # Idea: The Rubric Is the Insturctions or Add A Tutorial
 
 # Idea: You Can Flip the Board Sideways Multiple Times or Expand It In Different Directions
 
 # Idea: Dark Mode
 
 # More Ideas To Be Added By Graydom Isom
 
 
