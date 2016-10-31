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
	li $t0, 0xffff0000				# base adress
	li $t1, 0					# to set things to 0
	move $t2, $a1					# put cells array in t2
	li $t3, 0					# counter 
	li $t4, 0xffff00c8				# when the screen is full
	
clear_map:
	beq $t0, $t4, clear_cellsArray			# out of bounds
	sb $t1, ($t0)					# store 0 in adress for map
	addi $t0, $t0, 1				# inc to next adress
	j clear_map

clear_cellsArray:
	beq $t3, 100, clear_done			# out of bounds
	sb $t1, ($t2)					# store 0 for cells array
	addi $t3, $t3, 1				# counter++
	addi $t2, $t2, 1				# inc to next adress
	j clear_cellsArray

clear_done:


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
    #Define your code here
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

