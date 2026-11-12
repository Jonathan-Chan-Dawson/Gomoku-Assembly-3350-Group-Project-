# Main Setup For Gomoku: Best Assembly Project.
# Team Members: Jonathan Dawson, Bejamin Bruns, Graydon Isom, Caleb Lewis (Gomoku Gangstas)
# Step 1: Make the Background and the Grid
# Step 2: Have Player Be Player 1. Pointer Piece Starts In Middle
# Step 3: Use Move_Loop and li and move to continue moving and implementing
# Step 4: Win Condition is 5 In a Row. Place, Move, Repeat.

# Notes: Use t For Temporary, a For Into-Functions, v for syscalls
 .data
 BOARD_START: .word 0x10040000 # start in top left corner
 BOARD_COLOR: .word 0x00E8D3A8 # Dark brown board color
 LINE_COLOR: .word 0x004A3B2A # light tan
 imageBuffer: .space 0x80000 # allocate space for 512 x 256 x 4 (each pixel is stored with a word)
 
 # Grid
 GRID_X: .word 50 # Start X
 GRID_Y: .word 50 # Start Y
 GRID_ROWS: .word 15 # Number Rows. Note: Space Lines 8 Pixels Between
 GRID_COLUMNS: .word 15 # Number Columns. Note: Each Pixel is 8 In Between, Space Lines 8 Pixels Between
  
 # Pieces
 PIECE_COLOR_P1: .word 0x00FFA500 # Orange Piece For Player 1
 PIECE_COLOR_P2: .word 0x00000080 # Navy Blue Piece For Player 2. P2 Has Legendary Aura.
  
 # Array
 .align 2 # Used Since Last Element Was Word
 GOMOKU_GRID: .word 0:225 # 15*15 Array is 225
  
 # Variables
 current_player: .word 1
 player_col_start: .word 7 # Middle.
 player_row_start: .word 7 # Middle.
  
 .text
 .globl main
 
 main: 

 # GET THE S VALUES
  lw $s0, current_player
  lw $s1, player_col_start
  lw $s2, player_row_start
 
  li $s3, 0 # Unknown Tile Number
  la $s4, GOMOKU_GRID # The 15 * 15 array. 0 = no piece, 1 = P1, 2 = P2
 
  jal drawBoard # <= All Good 
  j game_loop # Enter Eternal Loop

 
# Draw Grid: a0 = x, a1 = y, a2 = width, a3 = height. t0 will be color. 
# DRAW BOARD ------------------------------------------------------------ 
# Fill 512x512 Bitmap display with brown
# Unit width x height is 2 x 2
# Start is at 0x10040000 on the heap
# DRAW BOARD ------------------------------------------------------------
# Fill a 15x15 Gomoku board starting from 0,0
# 50x50 pixel diff in grid space

 drawBoard:
   lw $t4, BOARD_COLOR       # background color
   lw $t7, LINE_COLOR        # grid line color
   li $t1, 0                 # y = 0

   drawRow:
     bge $t1, 256, drawExit

     lw $t0, BOARD_START
     sll $t3, $t1, 10        # y * 1024 bytes per row
     add $t0, $t0, $t3       # row starting address

     # Per-row flags, computed once per row instead of once per pixel
     li $t8, 0               # $t8 = 1 if this row is a horizontal line
     li $t9, 0               # $t9 = 1 if this row is inside the grid's y range
     
     # early exit
     blt $t1, 22, rowFlagsDone # y < 22 outside grid range
     bgt $t1, 232, rowFlagsDone # y > 232 outside grid range
     
     li $t9, 1
     addi $t5, $t1, -22
     rem  $t6, $t5, 15
     seq  $t8, $t6, 0        # 1 if (y-22) % 15 == 0
     
   rowFlagsDone:
     li $t2, 0               # x = 0

     drawCol:
       bge $t2, 256, nextRow
       
       # not a grid line
       move $t3, $t4         # brown
       beq $t9, $zero, paintBoard       # paint brown if outside of range
       blt $t2, 22, paintBoard   # x < 22 --> paint brown
       bgt $t2, 232, paintBoard   # x > 232 --> paint brown
       
       # grid line
       bne $t8, $zero, useLine     # horizontal line row -> line color
       addi $t5, $t2, -22
       rem  $t6, $t5, 15
       bne $t6, $zero, paintBoard      # if x - 22 % 15 == 0 then grid line
     useLine:
       move $t3, $t7         # line color

     paintBoard:
       sw  $t3, 0($t0)

       addi $t2, $t2, 1
       addi $t0, $t0, 4
       j drawCol

     nextRow:
       addi $t1, $t1, 1
       j drawRow

   drawExit:
     jr $ra

 # VGhlIGtleSBpcyBoaWRkZW4gaW4gdGhlIGVycm9yIGxvZ3Mu 
  
 # Board Utility: Update Board Pieces.
 # Value = 0: EMPTY
 # Value = 1: P1 (orange)
 # Value = 2: P2 (navy)
 update_board:
  li $a0, 0 # Start Column
  li $a1, 0 # Start Row
  
  check_row_loop:
   # start of loop
   lw $t0, GRID_ROWS
   lw $t1, GRID_COLUMNS

   bge $a0, $t0, next_row
   addi $a0, $a0, 1
   
   jal update_board_at_pos
   
   next_row:
    bge $a0, $t1, end_update_board
    addi $a1, $a1, 1
    j check_row_loop
 
 end_update_board:
  j game_loop # Enter Eternal Suffering (Episode 2)
 
 get_tile_number: # Gets the Tile's Color Number From $a0 column # and $a1 row #
  # Calculation For Array: Base + (row * Col #) * 4 (4 Bytes Allocated Per Word)
  # Start The Piece On the Top Right
  move $t0, $s1 #base $t0 = number or rows
  lw $t1, GRID_COLUMNS #t1 = number of columns
  mult $t1, $s2 #t1 *= row #
  add $t2, $t0, $t1 #t2 = total sum
  
  sll $t2, $t2, 2 #Shift 2 literals. We are Now Smart.
  lw $s3, 0($s4)
  jr $ra
  

 # Update Board At Pos
 update_board_at_pos: #$a0 is column, $a1 is row
  # start of loop

  lw $t0, PIECE_COLOR_P1
  lw $t1, PIECE_COLOR_P2
   
  jal get_tile_number #a0 is x, a1 is y, s3 = tile number
   
  # switch to the function: paint or skip?
  li $t2, 0
  li $t3, 1
  li $t4, 2
  beq $s3, $t2, skip_update
  beq $s3, $t3, update_color_p1
  beq $s3, $t4, update_color_p2
  
  j skip_update # Fall Back
   
  # update board functions
   
  update_color_p1: #orange
   move $a2, $t2
   jal paint_piece
   j end_update
  
  update_color_p2: #navy
   move $a2, $t3
   jal paint_piece
   j end_update
  
  skip_update: # color it back to the grid or skip
   j end_update
 
  end_update:
   jr $ra
  
 
 paint_piece: 
   # piece is painted at position $a0, $a1, $a2 is color
   # paint the pieces here: $a0 and $a1 are row, column
   # shape tba 
  jr $ra
 
 
 
 
 
 # Game Loop + Insert Piece Functions. A.K.A Code => Bug => Regret => Despair => Wake Up => Repeat
 # Game Loop
 # 1) Checks For Keyboard Input
 # 2) If Keyboard Moves WASD, Move the Piece Pointer (Update The Pointer)
 # 3) If Keyboard Presses Space, Insert a Piece at a Position
 # 4) Inserting a Piece Updates the Array and Grid
 # 5) It Will Check For a Win, Switch Players, Then  Go Back to Game Loop to Reset Start Piece
 # 6) On Win, Press 'r' To Reset (Loop) and Then Show Player Won and End
 
 game_loop:
  lw $t0, current_player
  lw $t1, player_col_start
  lw $t2, player_row_start
  
 wait_for_keyboard: # Loop Constatnly Checking For Inputs Of WASD Keys. When Insert (Space), Inset Piece At That Location
  
  lui $t0, 0xFFFF # Base MMIO Address
  lw $t1, 0($t0) # Loads Control
  andi $t1, $t1, 1 # Checks If Bit Is Ready
  beq $t1, $zero, wait_for_keyboard
 
  lw $t2, 4($t0) # Loads Keyboard Address
 
 check_up: #Check Up Key
  li $t3, 'w'
  bne $t2, $t3, check_down
  ble $s2, $zero, jump_to_game_loop
  move $a0, $s2
  li $a1, 0 # 0 = vertical, 2 = horizontal
  addi $s2, $s2, -1 # row -= 1
  
  addi $a0, $s1, 0 # column
  addi $a1, $s2, 1 # row
  jal update_board_at_pos
  
  move $a1, $s2
  j update_pointer_piece
 
 check_down:
  li $t3, 's'
  bne $t2, $t3, check_left
  lw $t4, GRID_COLUMNS
  bge $s2, $t4, jump_to_game_loop
  addi $s2, $s2, 1 # row += 1
  
  addi $a0, $s1, 0 # column
  addi $a1, $s2, -1 # row
  jal update_board_at_pos
  
  move $a1, $s2
  j update_pointer_piece
 
 check_left:
  li $t3, 'a'
  bne $t2, $t3, check_right
  ble $s2, $zero, jump_to_game_loop
  addi $s1, $s1, -1 # column -= 1
  
  addi $a0, $s1, 1 # column
  addi $a1, $s2, 0 # row
  jal update_board_at_pos
  
  move $a0, $s1
  j update_pointer_piece
  
  
 check_right:
  li $t3, 'd'
  bne $t2, $t3, check_space
  lw $t4, GRID_ROWS
  bge $s2, $t4, jump_to_game_loop
  addi $s1, $s1, 1 # column += 1
  
  addi $a0, $s1, -1 # column
  addi $a1, $s2, 0 # row
  jal update_board_at_pos
  
  li $a1, 0
  j update_pointer_piece 
  
 check_space: # Move to Insert Piece
  li $t3, ' '
  bne $t2, $t3, jump_to_game_loop
  j insert_piece #s1 is col, s2 is row 
 
 
  
  
 
 # Just a Bit: Draw The Pointer Piece After Updating Board
 # $a0 and $a1 updates the piece
 # It draws...a piece
 update_pointer_piece: 
  move $a0, $s1
  move $a1, $s2
  
  beq $s0, 1, get_color_p1
  beq $s0, 2, get_color_p2
  
  get_color_p1:
   lw $a2, PIECE_COLOR_P1
   j update_piece_paint
  get_color_p2:
   lw $a2, PIECE_COLOR_P2
   j update_piece_paint
  
  update_piece_paint:
   jal paint_piece
  
 # Use $a0, $a1 for position
 # Will Update the Last Piece
 insert_piece: # Inserts Piece
  # Hellscape Activated: place piece in array!
  
  # Update Position
  move $a0, $s1
  move $a1, $s2
  jal update_board_at_pos
  
 
 check_win: # Check For Win. Check Vertical, Horizontal, Right-Left Diagonals, and Left-Right Diagonals
 
 switch_players: # Switch Players After Check Win, Then End Turn. Think a Speed-Bump
  li $t0, 1 # <= 1
  li $t1, 2 # <= 2
  beq $s0, $t0, set_to_p1 #If Player is not 1, Switch To P2, Else Switch To P1
  beq $s0, $t1, set_to_p2 #If Player is not 1, Switch To P2, Else Switch To P1
  
  j jump_to_game_loop # reset
  
  set_to_p1:
   #li $s0, 1
   #la $t0, current_player
   #sw $s0, 0($t0) # Tutorial on switching to current_player to 0($t0)
  
   li $s0, 1
   j jump_to_game_loop
 
  set_to_p2:
   li $s0, 2
   j jump_to_game_loop
 
 jump_to_game_loop:
  lw $s1, player_row_start
  lw $s2, player_col_start
  jal update_board
  j game_loop
 
 # Win Functions
 # When Won, Will Show Text You Won In Bottom, and Cannot Place More Pieces.
 # Steps:
 # 1) Get Current Piece
 # 2) Check Horizontal, Diagonal, and Vertical Both Directions in 4 Functions.
 #    If Any Have >= 5 In a Row, Game Is Won For That Player.
 simulate_win: 
 
 wait_for_keyboard_after_win:
 
 # Restart Function, Press 'r'
 func_restart_game: 
  li $t0, 0
  move $t1, $s4
  
  clear_loop: 
   bge $t0, 225, clear_done # Crisis Averted
   sw $zero, 0($t1)
   addi $t0, $t0, 1 
   addi $t1, $t1, 4 
   j clear_loop
   
  clear_done:
   jal update_board
   j main
 
 # Smart, Neccesary...and Dangerous
 end_program: 
  li $v0, 10 
  syscall # A Force of Nature
  
 # Idea: Dark Mode. 
 
 # Idea: Flip Board?
 
 # Here be Dragons
 
 # More Ideas To Be Added By Graydom Isom <= Senior Dev
 
 # Maybe Benjamin Bruns <= Duct Tape Warrior :)
 
 # Final Step: Put This On LinkedIn Homepage!
 
 # Other Idea: "Hard Mode." Hard-vard is Still Cooking Up Database Research. Or... Dad-abase Research!!! (Get it?? Get It..?)
 
 
