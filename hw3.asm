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
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    li $v0, -200
    ###########################################
    jr $ra

reveal_map:
    #Define your code here
    jr $ra


##############################
# PART 4 FUNCTIONS
##############################

perform_action:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    li $v0, -200
    ##########################################
    jr $ra

game_status:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    li $v0, -200
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

