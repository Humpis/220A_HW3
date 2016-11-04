##############################################################
# Homework #3
# name: Vidar Minkovsky
# sbuid: 109756598
##############################################################
.text

##############################
# PART 1 FUNCTIONS
##############################

smiley:
	li $t0, 0x0000000f				# black bg white fg
	li $t1, 0x000000b7				# yellow bg grey fg
	li $t2, 0x00000017				# red bg white fg
	li $t3, 0					# offset
	li $t4, 0xffff0000				# base adress
	li $t6, '\0'
	
  smiley_loop:
	beq $t3, 200, black_done			# offset out of bounds
	add $t5, $t4, $t3				# t5 = base + offset
	sb $t6, ($t5)					# store the charactor
	addi $t3, $t3, 1				# offset++
	add $t5, $t4, $t3				# t5 = base + offset
	sb $t0, ($t5)					# store the color
	addi $t3, $t3, 1				# offset++
	j smiley_loop
	
  black_done:
	addi $t5, $t4, 46				# eyes adress
	li $t6, 'b'					# bomb char
	sb $t6, ($t5)					# store bomb
	addi $t5, $t5, 1				# color adress
	sb $t1, ($t5)					# store color
	
	addi $t5, $t4, 52				# eyes adress
	sb $t6, ($t5)					# store bomb
	addi $t5, $t5, 1				# color adress
	sb $t1, ($t5)					# store color
	
	addi $t5, $t4, 66				# eyes adress
	sb $t6, ($t5)					# store bomb
	addi $t5, $t5, 1				# color adress
	sb $t1, ($t5)					# store color
	
	addi $t5, $t4, 72				# eyes adress
	sb $t6, ($t5)					# store bomb
	addi $t5, $t5, 1				# color adress
	sb $t1, ($t5)					# store color
	
	addi $t5, $t4, 124				# mouth adress
	li $t6, 'e'					# exploded bomb char
	sb $t6, ($t5)					# store bomb
	addi $t5, $t5, 1				# color adress
	sb $t2, ($t5)					# store color
	
	addi $t5, $t4, 134				# eyes adress
	sb $t6, ($t5)					# store bomb
	addi $t5, $t5, 1				# color adress
	sb $t2, ($t5)					# store color
	
	addi $t5, $t4, 146				# eyes adress
	sb $t6, ($t5)					# store bomb
	addi $t5, $t5, 1				# color adress
	sb $t2, ($t5)					# store color
	
	addi $t5, $t4, 152				# eyes adress
	sb $t6, ($t5)					# store bomb
	addi $t5, $t5, 1				# color adress
	sb $t2, ($t5)					# store color
	
	addi $t5, $t4, 168				# eyes adress
	sb $t6, ($t5)					# store bomb
	addi $t5, $t5, 1				# color adress
	sb $t2, ($t5)					# store color
	
	addi $t5, $t4, 170				# eyes adress
	sb $t6, ($t5)					# store bomb
	addi $t5, $t5, 1				# color adress
	sb $t2, ($t5)					# store color
	
  smiley_done:
	jr $ra

##############################
# PART 2 FUNCTIONS
##############################

open_file:
	# a0 is already the file name
	li $a1, 0					# read only
	li $a2, 0					# ignore mode
	li $v0, 13					# syscall for open file
 	syscall						# v0 contains file descriptor
	jr $ra

close_file:
	#a0 is already the file desc
	li $v0, 16					# sycall to close
	syscall
  	jr $ra

load_map:
	li $t0, 0					# to set row and col to default
	sw $t0, cursor_row
	sw $t0, cursor_col
	li $t1, 0					# to set things to 0
	move $t2, $a1					# put cells array in t2
	li $t3, 0					# counter 

  clear_cellsArray:
	beq $t3, 100, clear_done			# out of bounds
	sb $t1, ($t2)					# store 0 for cells array
	addi $t3, $t3, 1				# counter++
	addi $t2, $t2, 1				# inc to next adress
	j clear_cellsArray

  clear_done:
	addi $t2, $t2, -100				# reset to beggining of cells array
	li $t6, -1					# set q1 to -1

  load_bombs:
	#a0 is file desc
	la $a1, buffer					# input buffer
	li $a2, 1					# num chars to read
	li $v0, 14
	syscall
	beqz $v0, load_bombs_done
	lw $t0, ($a1)					# char read
	beq $t0, ' ', load_bombs			# char is space
	beq $t0, '\t', load_bombs			# char is space
	beq $t0, '\r', load_bombs			# char is space
	beq $t0, '\n', load_bombs			# char is space
	blt $t0, 48, load_map_error			# char less than 0
	bgt $t0, 57, load_map_error			# char gt 9
	bne $t6, -1, secondq
	move $t6, $t0					# put char in q1
	j load_bombs

  secondq:
	addi $t6, $t6, -48				# make q1 the number
	addi $t0, $t0, -48				# same for q2
	li $t7, 10					# for mult
	mul $t6, $t6, $t7				# mult q1 for the thing
	add $t0, $t6, $t0				# add coords together
	move $t6, $t2					# save a copy of cells array!!!!!
	add $t6, $t6, $t0				# t6 = position in mem of the cell that has a bomb
	li $t5, 16
	sb $t5, ($t6)	

	li $t6, -1					#reset q1
	j load_bombs

  load_bombs_done:
	bne $t6, -1, load_map_error			# uneven nummber of numbers
	
  load_map_numbers:
	move $t0, $t2					# base adress of cells array
	li $t1, 0					# offset

  load_map_number_loop:
  	beq $t1, 100, load_map_number_loop_done		# offset out of bounds
  	li $t4, 0					# number of bombs adj
  	li $t2, 10					# for mod
  	div $t1, $t2					# hi = offset mod 10
  	mfhi $t2					# t2 = hi
  	beqz $t2, load_map_left				# left edge
  	beq $t2, 9, load_map_right			# right edge
  		
    load_map_top_row:
    	addi $t2, $t1, -11				# top left corner w/r to offset
  	add $t2, $t2, $t0				# ^^ but in mem 
  	addi $t2, $t2, 2				# temp for jump to middle
    	blt $t1, 10, load_map_middle_row		# top edge
    	addi $t2, $t2, -2				# undotemp for jump to middle
  	lb $t3, ($t2)					# number in mem
  	blt $t3, 16, load_map_top_row2			# no bomb
  	addi $t4, $t4, 1				# bombs adj++
    load_map_top_row2:
  	addi $t2, $t2, 1				# mem of next pos
  	lb $t3, ($t2)					# number in mem
  	blt $t3, 16, load_map_top_row3			# no bomb
  	addi $t4, $t4, 1				# bombs adj++
    load_map_top_row3:
    	addi $t2, $t2, 1				# mem of next pos
  	lb $t3, ($t2)					# number in mem
  	blt $t3, 16, load_map_middle_row		# no bomb
  	addi $t4, $t4, 1				# bombs adj++
    load_map_middle_row:
  	addi $t2, $t2, 10				# mem of next pos(000,0o*,000)
  	lb $t3, ($t2)					# number in mem
  	blt $t3, 16, load_map_middle_row2		# no bomb
  	addi $t4, $t4, 1				# bombs adj++
    load_map_middle_row2:
  	addi $t2, $t2, -2				# mem of next pos(000,*o0,000)
  	lb $t3, ($t2)					# number in mem
  	blt $t3, 16, load_map_bottom_row		# no bomb
  	addi $t4, $t4, 1				# bombs adj++
    load_map_bottom_row:
    	bgt $t1, 89, load_map_norm_done			# offset is bottom row
  	addi $t2, $t2, 10				# mem of next pos(000,0o0,*00)
  	lb $t3, ($t2)					# number in mem
  	blt $t3, 16, load_map_bottom_row2		# no bomb
  	addi $t4, $t4, 1				# bombs adj++	
    load_map_bottom_row2:
  	addi $t2, $t2, 1				# mem of next pos
  	lb $t3, ($t2)					# number in mem
  	blt $t3, 16, load_map_bottom_row3		# no bomb
  	addi $t4, $t4, 1				# bombs adj++
    load_map_bottom_row3:
  	addi $t2, $t2, 1				# mem of next pos
  	lb $t3, ($t2)					# number in mem
  	blt $t3, 16, load_map_norm_done			# no bomb
  	addi $t4, $t4, 1				# bombs adj++
     load_map_norm_done:
  	add $t2, $t1, $t0				# store bombs adj. mem of cell
  	lb $t3, ($t2)					# number in mem
  	add $t3, $t3, $t4				# t3 = num in mem of cell + bombs adj
  	sb $t3, ($t2)					# store bombs adj + orig num in cell
  	addi $t1, $t1, 1				# offset++
  	j load_map_number_loop
  
  load_map_left:	
  	addi $t2, $t1, -10				# top left corner w/r to offset
  	add $t2, $t2, $t0				# ^^ but in mem 
  	addi $t2, $t2, 1				# temp for jump to middle
  	blt $t1, 10, load_map_left_middle_row		# top edge
  	addi $t2, $t2, -1				# undo temp for jump to middle
  	lb $t3, ($t2)					# number in mem
  	blt $t3, 16, load_map_left_top_row3		# no bomb
  	addi $t4, $t4, 1				# bombs adj++
    load_map_left_top_row3:
    	addi $t2, $t2, 1				# mem of next pos
  	lb $t3, ($t2)					# number in mem
  	blt $t3, 16, load_map_left_middle_row		# no bomb
  	addi $t4, $t4, 1				# bombs adj++
    load_map_left_middle_row:
  	addi $t2, $t2, 10				# mem of next pos(00,o*,00)
  	lb $t3, ($t2)					# number in mem
  	blt $t3, 16, load_map_left_bottom_row		# no bomb
  	addi $t4, $t4, 1				# bombs adj++
    load_map_left_bottom_row:
    	bgt $t1, 89, load_map_left_done			# offset is bottom row
  	addi $t2, $t2, 10				# mem of next pos(00,o0,0*)
  	lb $t3, ($t2)					# number in mem
  	blt $t3, 16, load_map_left_bottom_row2		# no bomb
  	addi $t4, $t4, 1				# bombs adj++	
    load_map_left_bottom_row2:
  	addi $t2, $t2, -1				# mem of next pos(00,o0,*0)
  	lb $t3, ($t2)					# number in mem
  	blt $t3, 16, load_map_left_done			# no bomb
  	addi $t4, $t4, 1				# bombs adj++
     load_map_left_done:
  	add $t2, $t1, $t0				# store bombs adj. mem of cell
  	lb $t3, ($t2)					# number in mem
  	add $t3, $t3, $t4				# t3 = num in mem of cell + bombs adj
  	sb $t3, ($t2)					# store bombs adj + orig num in cell
  	addi $t1, $t1, 1				# offset++
  	j load_map_number_loop
  
  load_map_right:
  	addi $t2, $t1, -11				# top left corner w/r to offset
  	add $t2, $t2, $t0				# ^^ but in mem 
  	addi $t2, $t2, 1				# temp for jump to middle
  	blt $t1, 10, load_map_right_middle_row		# top edge
  	addi $t2, $t2, -1				# undo temp for jump to middle
  	lb $t3, ($t2)					# number in mem
  	blt $t3, 16, load_map_right_top_row3		# no bomb
  	addi $t4, $t4, 1				# bombs adj++
    load_map_right_top_row3:
    	addi $t2, $t2, 1				# mem of next pos
  	lb $t3, ($t2)					# number in mem
  	blt $t3, 16, load_map_right_middle_row		# no bomb
  	addi $t4, $t4, 1				# bombs adj++
    load_map_right_middle_row:
  	addi $t2, $t2, 9				# mem of next pos(00,*o,00)
  	lb $t3, ($t2)					# number in mem
  	blt $t3, 16, load_map_right_bottom_row		# no bomb
  	addi $t4, $t4, 1				# bombs adj++
    load_map_right_bottom_row:
    	bgt $t1, 89, load_map_right_done			# offset is bottom row
  	addi $t2, $t2, 10				# mem of next pos(00,o0,*0)
  	lb $t3, ($t2)					# number in mem
  	blt $t3, 16, load_map_right_bottom_row2		# no bomb
  	addi $t4, $t4, 1				# bombs adj++	
    load_map_right_bottom_row2:
  	addi $t2, $t2, 1				# mem of next pos(00,o0,0*)
  	lb $t3, ($t2)					# number in mem
  	blt $t3, 16, load_map_right_done			# no bomb
  	addi $t4, $t4, 1				# bombs adj++
     load_map_right_done:
  	add $t2, $t1, $t0				# store bombs adj. mem of cell
  	lb $t3, ($t2)					# number in mem
  	add $t3, $t3, $t4				# t3 = num in mem of cell + bombs adj
  	sb $t3, ($t2)					# store bombs adj + orig num in cell
  	addi $t1, $t1, 1				# offset++
  	j load_map_number_loop
  
    load_map_number_loop_done:
	j load_map_done					
	
  load_map_error:
	li $v0, -1					# error
	jr $ra

  load_map_done:
	li $v0, 0					# sucsess
	jr $ra

##############################
# PART 3 FUNCTIONS
##############################

init_display:
	li $t0, 0xffff0000				# base adress
	li $t1, '\0'					# to set things to 0
	li $t4, 0xffff00c8				# when the screen is full
	li $t5, 0x00000077				# grey on grey
	
  clear_display:
	beq $t0, $t4, clear_display_done		# out of bounds
	sb $t1, ($t0)					# store 0 char
	addi $t0, $t0, 1				# inc
	sb $t5, ($t0)					# store grey in adress for map
	addi $t0, $t0, 1				# inc to next adress
	j clear_display

  clear_display_done:
	li $t5, 0xffff0001				# base adress
	li $t0, 0x000000b7				# grey on yellow
	sb $t0, ($t5)					# store cursor color
	
  init_display_done:
    	jr $ra

set_cell:
	lw $t0, ($sp)					# new bg color
	bltz $a0, set_cell_error			# check row	
	bge $a0, 10, set_cell_error
	bltz $a1, set_cell_error			# check col
	bge $a1, 10, set_cell_error
	bltz $a3, set_cell_error			# check fg
	bgt $a3, 15, set_cell_error
	bltz $t0, set_cell_error			# check bg
	bgt $t0, 15, set_cell_error
	li $t1, 10					# for mult
	mul $t1, $a0, $t1				# t1 = row * 10
	add $t1, $t1, $a1				# t1 = row + col in mem
	sll $t0, $t0, 4					# shift bg to where it should be
	add $t0, $t0, $a3				# bg + fg
	sll $t1, $t1, 1					# because mmio is 2 bytes per cell
	li $t2, 0xffff0000				# base
	add $t2, $t2, $t1				# base + offset
	sb $a2, ($t2)					# store char
	addi $t2, $t2, 1				# next byte
	sb $t0, ($t2)					# store char
	j set_cell_done
	
set_cell_error:
	li $v0, -1					# error
	jr $ra

set_cell_done:
	li $v0, 0					# sucess
	jr $ra

reveal_map:
	addi $sp, $sp, -16				# save
	sw $ra, 0($sp)	
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	
	move $s0, $a1					# cell array
    	beqz $a0, reveal_map_done			# game in progress
    	beq $a0, 1, reveal_win
 	# else lost
 	li $s1, 0					# offset
 	li $s2, 0xffff0000				# base mmio
 	
 reveal_map_loop:
 	beq $s1, 100, reveal_map_cursor
    	add $t0, $s0, $s1				# cell array + offset 
    	lb $t1, ($t0)					# data in cell
    	li $t2, 8					# for mask
    	and $t3, $t2, $t1				# bit 4(flag)
    	bne $t3, $t2, no_flag				# bit 4 is 0, j		flag presentvvvvv
    	li $t2, 16					# for mask
    	and $t3, $t2, $t1				# bomb bit 5
    	beq $t3, $t2, flag_correct			# correctly flagged bomb
    	
 flag_incorrect:
 	li $t0, 10					# for divide
 	div $s1, $t0					# offset/10
 	mflo $a0					# row
 	mfhi $a1					# col
 	li $a2, 'f'					# char
 	li $a3, 12					# fg
 	li $t0, 9					# bg
 	addi $sp, $sp, -4				# store bg
 	sw $t0, ($sp)
 	jal set_cell					# set cell
 	addi $sp, $sp, 4				# remove bg from stack
 	addi $s1, $s1, 1				# offset++
 	j reveal_map_loop
 
 flag_correct:
    	li $t0, 10					# for divide
 	div $s1, $t0					# offset/10
 	mflo $a0					# row
 	mfhi $a1					# col
 	li $a2, 'f'					# char
 	li $a3, 12					# fg
 	li $t0, 10					# bg
 	addi $sp, $sp, -4				# store bg
 	sw $t0, ($sp)
 	jal set_cell					# set cell
 	addi $sp, $sp, 4				# remove bg from stack
 	addi $s1, $s1, 1				# offset++
 	j reveal_map_loop
    	
  no_flag:
  	li $t2, 16					# for mask
    	and $t3, $t2, $t1				# bomb bit 5
    	bne $t3, $t2, no_bomb				# no bomb found, j bombvvvvv
    	li $t0, 10					# for divide
 	div $s1, $t0					# offset/10
 	mflo $a0					# row
 	mfhi $a1					# col
 	li $a2, 'b'					# char
 	li $a3, 7					# fg
 	li $t0, 0					# bg
 	addi $sp, $sp, -4				# store bg
 	sw $t0, ($sp)
 	jal set_cell					# set cell
 	addi $sp, $sp, 4				# remove bg from stack
 	addi $s1, $s1, 1				# offset++
 	j reveal_map_loop
    	
  no_bomb:
    	li $t2, 7					# for mask
    	and $t3, $t2, $t1				# number bits 0-3
    	beqz $t3, no_number			# no number found, j nmum,nertvvvvv
    	li $t0, 10					# for divide
 	div $s1, $t0					# offset/10
 	mflo $a0					# row
 	mfhi $a1					# col
 	addi $t3, $t3, 48				# asciio
 	move $a2, $t3					# char
 	li $a3, 13					# fg
 	li $t0, 0					# bg
 	addi $sp, $sp, -4				# store bg
 	sw $t0, ($sp)
 	jal set_cell					# set cell
 	addi $sp, $sp, 4				# remove bg from stack
 	addi $s1, $s1, 1				# offset++
 	j reveal_map_loop
 	
  no_number:
  	li $t0, 10					# for divide
 	div $s1, $t0					# offset/10
 	mflo $a0					# row
 	mfhi $a1					# col
 	li $a2, '\0'					# char
 	li $a3, 15					# fg
 	li $t0, 0					# bg
 	addi $sp, $sp, -4				# store bg
 	sw $t0, ($sp)
 	jal set_cell					# set cell
 	addi $sp, $sp, 4				# remove bg from stack
 	addi $s1, $s1, 1				# offset++
 	j reveal_map_loop
    	
  reveal_map_cursor:
  	lw $a0, cursor_row
  	lw $a1, cursor_col 
 	li $a2, 'e'					# char
 	li $a3, 15					# fg
 	li $t0, 9					# bg
 	addi $sp, $sp, -4				# store bg
 	sw $t0, ($sp)
 	jal set_cell					# set cell
 	addi $sp, $sp, 4				# remove bg from stack
  	j reveal_map_done
    	
reveal_win:
	jal smiley
	j reveal_map_done
    	
reveal_map_done:
	lw $ra, 0($sp)	
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	addi $sp, $sp, 20				# load
    	jr $ra


##############################
# PART 4 FUNCTIONS
##############################

perform_action:
	addi $sp, $sp, -4				# save
	sw $ra, 0($sp)	
	

	li $a3, -1
 	jal set_cell					# gayyyyyy

	
	
  	lw $t0, cursor_row
  	lw $t1, cursor_col
  	beq $a1, 'f', perform_flag
  	beq $a1, 'F', perform_flag
  	beq $a1, 'r', perform_reveal
  	beq $a1, 'R', perform_reveal
  	beq $a1, 'w', perform_up
  	beq $a1, 'W', perform_up
  	beq $a1, 'a', perform_left
  	beq $a1, 'A', perform_left
  	beq $a1, 's', perform_down
  	beq $a1, 'S', perform_down
  	beq $a1, 'd', perform_right
  	beq $a1, 'D', perform_right
  	j perform_action_error
  	
  perform_flag:
  	li $t2, 10					# for mult
  	mul $t2, $t0, $t2				# row*10
  	add $t5, $t2, $t1				# row + col
  	add $t2, $t5, $a0				# location in mem
  	lb $t3, ($t2)					# stuf in cell
  	bge $t3, 64, perform_action_error		# cell already revealed
  	li $t7, 8					# for mask
  	and $t4, $t7, $t3				# cell and 8. flag bit
  	beq $t4, $t7, perform_flag_remove		# flag there, remove
  	addi $t3, $t3, 8				# put flag
  	sb $t3, ($t2)					# store it back
  	sll $t5, $t5, 1					# because mmio is 2 bytes
  	li $t6, 0xffff0000
  	add $t5, $t6, $t5				# loaction in mmio
  	li $t6, 'f'					# flag to be stores
  	sb $t6, ($t5)					# add flag visual
  	addi $t5, $t5, 1				# next mem adress
  	li $t6, 0x0000007c				# bright blue on grey
  	sb $t6, ($t5)					# add bg visual
  	j perform_action_done
  	
  perform_flag_remove:
  	addi $t3, $t3, -8				# remove flag
  	sb $t3, ($t2)					# store it back
  	sll $t5, $t5, 1					# because mmio is 2 bytes
  	li $t6, 0xffff0000
  	add $t5, $t6, $t5				# loaction in mmio
  	li $t6, '\0'					# blank to be stores
  	sb $t6, ($t5)					# remove flag visual
  	addi $t5, $t5, 1				# next mem adress
  	li $t6, 0x00000077				# grey on grey
  	sb $t6, ($t5)					# add bg visual
  	j perform_action_done
  	
  perform_reveal:
  	li $t2, 10					# for mult
  	mul $t2, $t0, $t2				# row*10
  	add $t5, $t2, $t1				# row + col
  	add $t2, $t5, $a0				# location in mem
  	lb $t3, ($t2)					# stuf in cell
  	bge $t3, 64, perform_action_error		# cell already revealed
  	li $t7, 8					# for mask
  	and $t4, $t7, $t3				# cell and 8. flag bit
  	bne $t4, $t7, perform_reveal_noflag		# no flag. if flagVVVVV
  	addi $t3, $t3, -8				# remove flag
  	sb $t3, ($t2)					# store it back
  perform_reveal_noflag:
  	addi $t3, $t3, 64				# revealed!!!!!!
  	sb $t3, ($t2)					# store it back
  	li $t2, 7					# for mask
  	and $t4, $t2, $t3				# cell and 8. flag bit
  	beqz $t4, perform_reveal_empty			#  empty cell
  	sll $t5, $t5, 1					# because mmio is 2 bytes
  	li $t6, 0xffff0000
  	add $t5, $t6, $t5				# loaction in mmio
  	#li $t6, '\0'					# blank to be stores
  	sb $t4, ($t5)					# store char
  	addi $t5, $t5, 1				# next mem adress
  	li $t6, 0x00000000d				# bright magenta on black
  	sb $t6, ($t5)					# add bg visual
  	j perform_action_done
  	
  perform_reveal_empty:
  	######search cell. idkkkkkkk
  	jal search_cells
  	j perform_action_done
  	
  perform_up:
  	beqz $t0, perform_action_error			# row = 0, cant move up
  	li $t2, 10					# for mult
  	mul $t2, $t0, $t2				# row*10
  	add $t5, $t2, $t1				# row + col
  	add $t2, $t5, $a0				# location in mem
  	lb $t3, ($t2)					# stuf in cell
  	bge $t3, 64, perform_up_revealed	
  	sll $t5, $t5, 1					# because mmio is 2 bytes
  	li $t6, 0xffff0000
  	add $t5, $t6, $t5				# loaction in mmio	
  	lb $a2, ($t5)					# charactor
  	addi $t5, $t5, 1				# next mem adress
  	lb $t6, ($t5)					# mimmo stuff
  	li $t7, 0x0000000f				# mask to get fg
  	and $a3, $t6, $t7				# fg
  	li $t7, 7					# grey bg
  	addi $sp, $sp, -4				# store bg
 	sw $t7, ($sp)
 	move $a0, $t0					# row
 	move $a1, $t1					# col
 	jal set_cell					# set cell
	addi $sp, $sp, 4				# remove bg from stack
  	
  	lw $t0, cursor_row
  	lw $t1, cursor_col
  	addi $t0, $t0, -1				# row--
  	sw $t0, cursor_row
  	li $t2, 10					# for mult
  	mul $t2, $t0, $t2				# row*10
  	add $t5, $t2, $t1				# row + col
  	add $t2, $t5, $a0				# location in mem	
  	sll $t5, $t5, 1					# because mmio is 2 bytes
  	li $t6, 0xffff0000
  	add $t5, $t6, $t5				# loaction in mmio	
  	lb $a2, ($t5)					# charactor
  	addi $t5, $t5, 1				# next mem adress
  	lb $t6, ($t5)					# mimmo stuff
  	li $t7, 0x0000000f				# mask to get fg
  	and $a3, $t6, $t7				# fg
  	li $t7, 11					# yellow bg
  	addi $sp, $sp, -4				# store bg
 	sw $t7, ($sp)
 	move $a0, $t0					# row
 	move $a1, $t1					# col
 	jal set_cell					# set cell
	addi $sp, $sp, 4				# remove bg from stack
  	
  	j perform_action_done
  	
  perform_up_revealed:		
  	sll $t5, $t5, 1					# because mmio is 2 bytes
  	li $t6, 0xffff0000
  	add $t5, $t6, $t5				# loaction in mmio	
  	lb $a2, ($t5)					# charactor
  	addi $t5, $t5, 1				# next mem adress
  	lb $t6, ($t5)					# mimmo stuff
  	li $t7, 0x0000000f				# mask to get fg
  	and $a3, $t6, $t7				# fg
  	li $t7, 0					# black bg
  	addi $sp, $sp, -4				# store bg
 	sw $t7, ($sp)
 	move $a0, $t0					# row
 	move $a1, $t1					# col
 	jal set_cell					# set cell
	addi $sp, $sp, 4				# remove bg from stack
  	
  	lw $t0, cursor_row
  	lw $t1, cursor_col
  	addi $t0, $t0, -1				# row--
  	sw $t0, cursor_row
  	li $t2, 10					# for mult
  	mul $t2, $t0, $t2				# row*10
  	add $t5, $t2, $t1				# row + col
  	add $t2, $t5, $a0				# location in mem	
  	sll $t5, $t5, 1					# because mmio is 2 bytes
  	li $t6, 0xffff0000
  	add $t5, $t6, $t5				# loaction in mmio	
  	lb $a2, ($t5)					# charactor
  	addi $t5, $t5, 1				# next mem adress
  	lb $t6, ($t5)					# mimmo stuff
  	li $t7, 0x0000000f				# mask to get fg
  	and $a3, $t6, $t7				# fg
  	li $t7, 11					# yellow bg
  	addi $sp, $sp, -4				# store bg
 	sw $t7, ($sp)
 	move $a0, $t0					# row
 	move $a1, $t1					# col
 	jal set_cell					# set cell
	addi $sp, $sp, 4				# remove bg from stack	
  	j perform_action_done
  	
    perform_down:
  	beq $t0, 9 perform_action_error			# row = 9, cant move down
  	li $t2, 10					# for mult
  	mul $t2, $t0, $t2				# row*10
  	add $t5, $t2, $t1				# row + col
  	add $t2, $t5, $a0				# location in mem
  	lb $t3, ($t2)					# stuf in cell
  	bge $t3, 64, perform_down_revealed	
  	sll $t5, $t5, 1					# because mmio is 2 bytes
  	li $t6, 0xffff0000
  	add $t5, $t6, $t5				# loaction in mmio	
  	lb $a2, ($t5)					# charactor
  	addi $t5, $t5, 1				# next mem adress
  	lb $t6, ($t5)					# mimmo stuff
  	li $t7, 0x0000000f				# mask to get fg
  	and $a3, $t6, $t7				# fg
  	li $t7, 7					# grey bg
  	addi $sp, $sp, -4				# store bg
 	sw $t7, ($sp)
 	move $a0, $t0					# row
 	move $a1, $t1					# col
 	jal set_cell					# set cell
	addi $sp, $sp, 4				# remove bg from stack
  	
  	lw $t0, cursor_row
  	lw $t1, cursor_col
  	addi $t0, $t0, 1				# row++
  	sw $t0, cursor_row
  	li $t2, 10					# for mult
  	mul $t2, $t0, $t2				# row*10
  	add $t5, $t2, $t1				# row + col
  	add $t2, $t5, $a0				# location in mem	
  	sll $t5, $t5, 1					# because mmio is 2 bytes
  	li $t6, 0xffff0000
  	add $t5, $t6, $t5				# loaction in mmio	
  	lb $a2, ($t5)					# charactor
  	addi $t5, $t5, 1				# next mem adress
  	lb $t6, ($t5)					# mimmo stuff
  	li $t7, 0x0000000f				# mask to get fg
  	and $a3, $t6, $t7				# fg
  	li $t7, 11					# yellow bg
  	addi $sp, $sp, -4				# store bg
 	sw $t7, ($sp)
 	move $a0, $t0					# row
 	move $a1, $t1					# col
 	jal set_cell					# set cell
	addi $sp, $sp, 4				# remove bg from stack
  	
  	j perform_action_done
  	
  perform_down_revealed:	
  	sll $t5, $t5, 1					# because mmio is 2 bytes
  	li $t6, 0xffff0000
  	add $t5, $t6, $t5				# loaction in mmio	
  	lb $a2, ($t5)					# charactor
  	addi $t5, $t5, 1				# next mem adress
  	lb $t6, ($t5)					# mimmo stuff
  	li $t7, 0x0000000f				# mask to get fg
  	and $a3, $t6, $t7				# fg
  	li $t7, 0					# black bg
  	addi $sp, $sp, -4				# store bg
 	sw $t7, ($sp)
 	move $a0, $t0					# row
 	move $a1, $t1					# col
 	jal set_cell					# set cell
	addi $sp, $sp, 4				# remove bg from stack
  	
  	lw $t0, cursor_row
  	lw $t1, cursor_col
  	addi $t0, $t0, 1				# row++
  	sw $t0, cursor_row
  	li $t2, 10					# for mult
  	mul $t2, $t0, $t2				# row*10
  	add $t5, $t2, $t1				# row + col
  	add $t2, $t5, $a0				# location in mem	
  	sll $t5, $t5, 1					# because mmio is 2 bytes
  	li $t6, 0xffff0000
  	add $t5, $t6, $t5				# loaction in mmio	
  	lb $a2, ($t5)					# charactor
  	addi $t5, $t5, 1				# next mem adress
  	lb $t6, ($t5)					# mimmo stuff
  	li $t7, 0x0000000f				# mask to get fg
  	and $a3, $t6, $t7				# fg
  	li $t7, 11					# yellow bg
  	addi $sp, $sp, -4				# store bg
 	sw $t7, ($sp)
 	move $a0, $t0					# row
 	move $a1, $t1					# col
 	jal set_cell					# set cell
	addi $sp, $sp, 4				# remove bg from stack	
  	j perform_action_done
  	
  perform_left:
  	beqz $t1,  perform_action_error			# col = 0, cant move down
  	li $t2, 10					# for mult
  	mul $t2, $t0, $t2				# row*10
  	add $t5, $t2, $t1				# row + col
  	add $t2, $t5, $a0				# location in mem
  	lb $t3, ($t2)					# stuf in cell
  	bge $t3, 64, perform_left_revealed	
  	sll $t5, $t5, 1					# because mmio is 2 bytes
  	li $t6, 0xffff0000
  	add $t5, $t6, $t5				# loaction in mmio	
  	lb $a2, ($t5)					# charactor
  	addi $t5, $t5, 1				# next mem adress
  	lb $t6, ($t5)					# mimmo stuff
  	li $t7, 0x0000000f				# mask to get fg
  	and $a3, $t6, $t7				# fg
  	li $t7, 7					# grey bg
  	addi $sp, $sp, -4				# store bg
 	sw $t7, ($sp)
 	move $a0, $t0					# row
 	move $a1, $t1					# col
 	jal set_cell					# set cell
	addi $sp, $sp, 4				# remove bg from stack
  	
  	lw $t0, cursor_row
  	lw $t1, cursor_col
  	addi $t1, $t1, -1				# col--
  	sw $t1, cursor_col
  	li $t2, 10					# for mult
  	mul $t2, $t0, $t2				# row*10
  	add $t5, $t2, $t1				# row + col
  	add $t2, $t5, $a0				# location in mem	
  	sll $t5, $t5, 1					# because mmio is 2 bytes
  	li $t6, 0xffff0000
  	add $t5, $t6, $t5				# loaction in mmio	
  	lb $a2, ($t5)					# charactor
  	addi $t5, $t5, 1				# next mem adress
  	lb $t6, ($t5)					# mimmo stuff
  	li $t7, 0x0000000f				# mask to get fg
  	and $a3, $t6, $t7				# fg
  	li $t7, 11					# yellow bg
  	addi $sp, $sp, -4				# store bg
 	sw $t7, ($sp)
 	move $a0, $t0					# row
 	move $a1, $t1					# col
 	jal set_cell					# set cell
	addi $sp, $sp, 4				# remove bg from stack
  	
  	j perform_action_done
  	
  perform_left_revealed:	
  	sll $t5, $t5, 1					# because mmio is 2 bytes
  	li $t6, 0xffff0000
  	add $t5, $t6, $t5				# loaction in mmio	
  	lb $a2, ($t5)					# charactor
  	addi $t5, $t5, 1				# next mem adress
  	lb $t6, ($t5)					# mimmo stuff
  	li $t7, 0x0000000f				# mask to get fg
  	and $a3, $t6, $t7				# fg
  	li $t7, 0					# black bg
  	addi $sp, $sp, -4				# store bg
 	sw $t7, ($sp)
 	move $a0, $t0					# row
 	move $a1, $t1					# col
 	jal set_cell					# set cell
	addi $sp, $sp, 4				# remove bg from stack
  	
  	lw $t0, cursor_row
  	lw $t1, cursor_col
  	addi $t1, $t1, -1				# col--
  	sw $t1, cursor_col
  	li $t2, 10					# for mult
  	mul $t2, $t0, $t2				# row*10
  	add $t5, $t2, $t1				# row + col
  	add $t2, $t5, $a0				# location in mem	
  	sll $t5, $t5, 1					# because mmio is 2 bytes
  	li $t6, 0xffff0000
  	add $t5, $t6, $t5				# loaction in mmio	
  	lb $a2, ($t5)					# charactor
  	addi $t5, $t5, 1				# next mem adress
  	lb $t6, ($t5)					# mimmo stuff
  	li $t7, 0x0000000f				# mask to get fg
  	and $a3, $t6, $t7				# fg
  	li $t7, 11					# yellow bg
  	addi $sp, $sp, -4				# store bg
 	sw $t7, ($sp)
 	move $a0, $t0					# row
 	move $a1, $t1					# col
 	jal set_cell					# set cell
	addi $sp, $sp, 4				# remove bg from stack	
  	j perform_action_done
  	
  perform_right:
  	beq $t1, 9 perform_action_error			# col = 9, cant move down
  	li $t2, 10					# for mult
  	mul $t2, $t0, $t2				# row*10
  	add $t5, $t2, $t1				# row + col
  	add $t2, $t5, $a0				# location in mem
  	lb $t3, ($t2)					# stuf in cell
  	bge $t3, 64, perform_right_revealed	
  	sll $t5, $t5, 1					# because mmio is 2 bytes
  	li $t6, 0xffff0000
  	add $t5, $t6, $t5				# loaction in mmio	
  	lb $a2, ($t5)					# charactor
  	addi $t5, $t5, 1				# next mem adress
  	lb $t6, ($t5)					# mimmo stuff
  	li $t7, 0x0000000f				# mask to get fg
  	and $a3, $t6, $t7				# fg
  	li $t7, 7					# grey bg
  	addi $sp, $sp, -4				# store bg
 	sw $t7, ($sp)
 	move $a0, $t0					# row
 	move $a1, $t1					# col
 	jal set_cell					# set cell
	addi $sp, $sp, 4				# remove bg from stack
  	
  	lw $t0, cursor_row
  	lw $t1, cursor_col
  	addi $t1, $t1, 1				# col++
  	sw $t1, cursor_col
  	li $t2, 10					# for mult
  	mul $t2, $t0, $t2				# row*10
  	add $t5, $t2, $t1				# row + col
  	add $t2, $t5, $a0				# location in mem	
  	sll $t5, $t5, 1					# because mmio is 2 bytes
  	li $t6, 0xffff0000
  	add $t5, $t6, $t5				# loaction in mmio	
  	lb $a2, ($t5)					# charactor
  	addi $t5, $t5, 1				# next mem adress
  	lb $t6, ($t5)					# mimmo stuff
  	li $t7, 0x0000000f				# mask to get fg
  	and $a3, $t6, $t7				# fg
  	li $t7, 11					# yellow bg
  	addi $sp, $sp, -4				# store bg
 	sw $t7, ($sp)
 	move $a0, $t0					# row
 	move $a1, $t1					# col
 	jal set_cell					# set cell
	addi $sp, $sp, 4				# remove bg from stack
  	
  	j perform_action_done
  	
  perform_right_revealed:	
  	sll $t5, $t5, 1					# because mmio is 2 bytes
  	li $t6, 0xffff0000
  	add $t5, $t6, $t5				# loaction in mmio	
  	lb $a2, ($t5)					# charactor
  	addi $t5, $t5, 1				# next mem adress
  	lb $t6, ($t5)					# mimmo stuff
  	li $t7, 0x0000000f				# mask to get fg
  	and $a3, $t6, $t7				# fg
  	li $t7, 0					# black bg
  	addi $sp, $sp, -4				# store bg
 	sw $t7, ($sp)
 	move $a0, $t0					# row
 	move $a1, $t1					# col
 	jal set_cell					# set cell
	addi $sp, $sp, 4				# remove bg from stack
  	
  	lw $t0, cursor_row
  	lw $t1, cursor_col
  	addi $t1, $t1, 1				# col++
  	sw $t1, cursor_col
  	li $t2, 10					# for mult
  	mul $t2, $t0, $t2				# row*10
  	add $t5, $t2, $t1				# row + col
  	add $t2, $t5, $a0				# location in mem	
  	sll $t5, $t5, 1					# because mmio is 2 bytes
  	li $t6, 0xffff0000
  	add $t5, $t6, $t5				# loaction in mmio	
  	lb $a2, ($t5)					# charactor
  	addi $t5, $t5, 1				# next mem adress
  	lb $t6, ($t5)					# mimmo stuff
  	li $t7, 0x0000000f				# mask to get fg
  	and $a3, $t6, $t7				# fg
  	li $t7, 11					# yellow bg
  	addi $sp, $sp, -4				# store bg
 	sw $t7, ($sp)
 	move $a0, $t0					# row
 	move $a1, $t1					# col
 	jal set_cell					# set cell
	addi $sp, $sp, 4				# remove bg from stack	
  	j perform_action_done
  	
  perform_action_error:
	lw $ra, 0($sp)	
	addi $sp, $sp, 4				# load
  	li $v0, -1
  	jr $ra

 perform_action_done:
 	lw $ra, 0($sp)	
	addi $sp, $sp, 4				# load
  	li $v0, 0
  	jr $ra
  	
game_status:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    #li $v0, -200
    li $v0, 0
    ##########################################
    jr $ra

##############################
# PART 5 FUNCTIONS
##############################

search_cells:
    #Define your code here
    jr $ra


#################################################################
# Student defined data section
#################################################################
.data
.align 2  # Align next items to word boundary
cursor_row: .word -1
cursor_col: .word -1

#place any additional data declarations here
buffer: .word 0

