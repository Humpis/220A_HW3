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

