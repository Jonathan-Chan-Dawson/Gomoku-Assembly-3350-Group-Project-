# Main Setup For Connect Four
# Team Members: Jonathan Dawson, Bejamin Bruns, Graydon Isom, Caleb Lewis
# Step 1: Make the Background and the Grid
# Step 2: Make the Ball
# Step 3: Use Move_Loop and li and move to continue moving and implementing
 .data
  imageBuffer: .space 0x80000 # allocate space for 512 x 256 x 4 (each pixel is stored with a word)
  
  # Grid
  GRID_X: .word 50 # Start X
  GRID_Y: .word 50 # Start Y
  GRID_ROWS: .word 8 # Number Rows. Note: Space Lines 8 Pixels Between
  GRID_COLUMNS: .word 8 # Number Columns. Note: Each Pixel is 8 In Between, Space Lines 8 Pixels Between
  
  GRID_COLOR: .word 0x000000AA # First Four Characters Are Filler Reminder
  BALL_COLOR: .word 0x00FF0000 # Red Ball
  
 .text
 .globl main
 
 main: 
 
 
 
 
 li $v0, 10
 syscall
 
 # Draw Grid: a0 = x, a1 = y, a2 = width, a3 = height. t0 will be color.
 draw_grid:
 
 jal $ra
 
 # Insert Piece Functions
 insert_piece:
 
 simulate_gravity:
 li $v0, 32 # Syscall 32 is the MARS "Sleep/Delay" tool
 li $a0, 33 # Pause the CPU for 33 milliseconds
 syscall
 
 # Win Functions
 simulat_win:
 
 # Idea: AI says "Cash Me Outside" And Can 1v1 You With Never-Soft Quotes On Top
 
 # Idea: Add an Undo Button, More Themes
 
 # Idea: "Hard" Mode
 
 # Idea: Rage Quit Button?
 
 # Idea: 
 