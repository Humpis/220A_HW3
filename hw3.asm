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
	li $t3, 1					# offset
	li $t4, 0xffff0000				# base adress
	
smiley_loop:
	beq $t3, 201, black_done			# offset out of bounds
	add $t5, $t4, $t3				# t5 = base + offset
	sb $t0, ($t5)					# store the color
	addi $t3, $t3, 2				# add 2 to counter
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
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    li $v0, -200
    ###########################################
    jr $ra

close_file:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    li $v0, -200
    ###########################################
    jr $ra

load_map:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    li $v0, -200
    ###########################################
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

