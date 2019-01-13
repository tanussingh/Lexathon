################### HEADER ############################################################

# Group Memebers: 
# Maliha Haque
# Haneya Khan
# Deeksha Deepak
# Tanushri Singh
# Class: CS 3340.501
# Professor: Nhut Ngyuen
# Due Date: December 1st, 2016
#
# Register Usage:
# $s0 is the array of the 9 letters 
# $s1 the file / word list buffer
# $s2 inputted string / word
# $s3 points / score
# $s4 to validate that no word is used twice
# $s5 new line
# $s6 period and others
# $s7 slash and others
#

#######################################################################################

.data
fin :		.asciiz "words.txt"
prompt:		.asciiz "\n\nEnter word in lowercase: "
notinlist: 	.asciiz "*Not a valid word in dictionary.\nPlease try again.\n"
correct:	.asciiz "*Correct!\n"
exitstatement: 	.asciiz "*Goodbye!"
vowels: 	.asciiz "aeiou"
score: 		.asciiz "Score: "
notvalid:	.asciiz "*Please try again using the given letters and make sure to use the last letter."
alreadyused:	.asciiz	"*This word has already been used try again."

welcome:	.asciiz "\nWelcome to LEXATHON!!!\n"
rules:		.asciiz "\nRules:\n1. Use the letters below to make words.\n2. The words must be lowercase and between 4 and 9 alphabetic letters.\n3. You must use the last letter in the given set.\n4. Use the singular tense of words. The dictionary does not recognize plural forms.\n5. Enter '1' when you want a new set of letters.\n6. Enter '0' when you want to exit the game.\n"
stars: 		.asciiz "\n*******************************************************************************\n"

period: 	.asciiz "."
slash: 		.asciiz "/"
newline:	.asciiz "\n"

used:		.align 0 
		.space 5000		#save correct words in a buffer
characters: 	.space 10		#creating array to store characters
input:		.space 80		#array to hold input
input2:		.space 40		#array to hold a copy of input
buffer:		.space 6000000		#array for file

.text
	
######################## MAIN #########################################################

main:
	li $v0, 4
	la $a0, stars 			#output stars
	syscall
	
	li $v0, 4
	la $a0, welcome 		#output welcome to lexathon
	syscall
	
	li $v0, 4
	la $a0, rules  			#output rules of the game
	syscall
	
	li $v0, 4
	la $a0, stars  			#output stars
	syscall

########################### OPEN AND READ FILE #############################################

readFile:
	#open a file 
	li   $v0, 13       		# system call for open file
	la   $a0, fin      		# board file name
	li   $a1, 0        		# Open for reading
	li   $a2, 0
	syscall            		# open a file (file descriptor returned in $v0)
	move $t1, $v0      		# save the file descriptor 
	
	#read from file
	move $a0, $v0      		# file descriptor 
	li   $v0, 14       		# system call for read from file
	la   $a1, buffer   		# address of buffer to which to read
	move $s1, $a1	   		# reload buffer	
	li  $a2, 1000000
	syscall            		# read from file
	

###############################RANDOM LETTERS############################################	
	
randomLetters:       
	la $s0, characters 		#storing it in register $s0
	li $t7, 0 			#temporary register $t0 to store counter 
	
loop:  li $a1, 26 			#range of characters
       li $v0, 42 			#random character
       syscall
       addi $a0, $a0, 97 		#starting at lower case a - lower case z
       sb $a0, ($s0)
       
       addi $s0, $s0, 1 		#moving to next character 
       addi $t7, $t7, 1 		#incrementing counter 
       blt $t7, 8, loop 		#branching through to get 8 random characters
       sb $zero, 0($s0)
       add $t6, $zero, $zero
       addi $t1, $zero, 1
       addi $t2, $zero, 2
       addi $t3, $zero, 3
       addi $t4, $zero, 4
       addi $t5, $zero, 5
       
generateVowels:
       li $a1, 6 			#range of characters
       li $v0, 42 			#random character
       syscall
       move $t0, $a0
       beq $t0, $t1, addA
       beq $t0, $t2, addE
       beq $t0, $t3, addI
       beq $t0, $t4, addO
       beq $t0, $t5, addU
            
       addA: 
       la $s6, vowels			# generate random vowels
       lb $s7, 0($s6) 
       sb $s7, ($s0)
       j printLetters
       addE:
       la $s6, vowels
       lb $s7, 1($s6)
       sb $s7, ($s0) 
       j printLetters
       addI:
       la $s6, vowels
       lb $s7, 2($s6) 
       sb $s7, ($s0)
       j printLetters
       addO:
       la $s6, vowels
       lb $s7, 3($s6) 
       sb $s7, ($s0)
       j printLetters
       addU:
       la $s6, vowels
       lb $s7, 4($s6) 
       sb $s7, ($s0)
       j printLetters      
       
printLetters: 
       li $v0, 4
       la $a0, newline	
       syscall				# print a blank line
       
       la $a0, characters 		# printing the random characters	
       li $v0, 4
       syscall
       
       move $t0, $zero			# reset registers that were used to generate random letters
       move $t1, $zero
       move $t2, $zero
       move $t3, $zero
       move $t4, $zero
       move $t5, $zero
       move $t6, $zero 
       move $t7, $zero
       move $s6, $zero
       move $s7, $zero

######################## SETUP #########################################################

setup:	
	lb $s6, period			#period
	lb $s7, slash 			#slash
	lb $s5, newline			#new line
	la $s2, input 			#get input address
	move $s3, $zero

	
######################## GET INPUT #########################################################
			
getInput:   
   	addi $t7, $zero, -1  		#initialize input pointer
   	la $a0, prompt      		#ask user to enter string
    	li $v0, 4
    	syscall

    	move $a0, $s2       		#read in string into $s2
    	li $a1,50
    	li $v0,8
    	syscall
    	
    	sw $s2, 0($sp)			#save $s2 on stack
    	sw $t7, 4($sp)			#save $t7 on stack
    	sw $t9, 8($sp)			#save $t9 on stack
    	sw $s4, 12($sp)			#save $s4 on stack
    	sw $t1, 16($sp)			#save $t1 on stack
    	sw $t2, 20($sp)			#save $t2 on stack
    	sw $t3, 24($sp)			#save $t3 on stack
    	
    	la $t1, input			#load address of input into $t1
    	la $s2, input2			#load address of input2 into $s2
    	
Looptime:
	lb $t2, 0($t1)			#keep incrementing to find /n
	addi $t1, $t1, 1		#increment $t1 by 1
	lb $t3, 0($t1)
	sb $t2, 0($s2)
	addi $s2, $s2, 1
	sb $t3, 0($s2)			#To override
	bne $t2, 10, Looptime
	la $s2, input2
	bne $t3, $zero, Looptime

    	la $s4, used			#load address of used into $s4
    	la $s2, input2			#load address of input2 into $s2
	
cmpUsed:
	lb $t7, 0($s4)
	addi $s4, $s4, 1		#increment $s4
	lb $t9, 0($s2)
	addi $s2, $s2, 1		#increment $s2
	beq $t9, $zero, erroroccured
	beq $t7, $zero, resetbeforevalidation
	beq $t7, $t9, cmpUsed		#if equal compare the next character
	la $s2, input2			#la of input into $s2 again b/c no match found
	j cmpUsed

erroroccured:
	lw $s2, 0($sp)			#Bring registers back from the stack
	lw $t7, 4($sp)
	lw $t9, 8($sp)
	lw $s4, 12($sp)
	lw $t1, 16($sp)
	lw $t2, 20($sp)
	lw $t3, 24($sp)
	li $v0, 4
	la $a0, alreadyused  		#output that error occured, same word cannot be reused
	syscall
	la $a0,newline
    	li $v0,4
    	syscall
    	la $a0,score
    	li $v0,4
    	syscall
    	move $a0, $s3
    	li $v0,1
    	syscall
	j getInput			#jump back to get new input
	
resetbeforevalidation:
	lw $s2, 0($sp)			#Bring registers back from the stack
	lw $t7, 4($sp)
	lw $t9, 8($sp)
	lw $s4, 12($sp)
	lw $t1, 16($sp)
	lw $t2, 20($sp)
	lw $t3, 24($sp)
	
inputValidation:	
 	addi $t2, $zero, 48		#load the ascii value of 0 in $s7
	addi $t3, $zero, 49		#load the ascii value of 1 in $s6
	lb $t1, ($s2)
	beq $t2, $t1, finalExit		#if input is 0, branch to exit
	beq $t3, $t1, reset	        #if input is 1, branch back to the beginning
	
	lb $t2, newline			# set $t2 to newline
	la $t0, characters		
	move $t4, $s2			# move input to $t4
	addi $t0, $t0, 8		# move to 9th letter in characters
	lb $t9, ($t0)			# load 9th character
	move $t0, $zero			# reset characters in $t0
	la $t0, characters
	
root:	lb $t5, ($t4)			# load byte from input
	beq $t5, $t2, nope		# check if new line
	beq $t5, $t9, rootfound		# check if equal to last letter
	j noroot			# if not equal
	
rootfound: 
	move $t5, $zero			# if equal reset $t5
	move $t4, $zero			# reset $t4 to input
	move $t4, $s2	
	j loop2				# jump to loop2
	
noroot: addi $t4, $t4, 1		# move to next byte in input
	j root				# jump to root

loop2:	lb $t5,($t4)			# get next char from input
	beq $t5, $t2, end		# loop until end of input
					# Check if input is using only the 9 random letters that are generated, if found, jump to found function
	         			# for every letter in the input, loops through 9 letters until found; else error message
	lb $t3, ($t0)			# load byte from 9 letters
	beq $t5, $t3, found		# check if 9 letters byte and word byte are equal; if so. jump to found
	addi $t0, $t0, 1		# else update 9 letters byte
	lb $t3, ($t0)			# repeat
	beq $t5, $t3, found
	addi $t0, $t0, 1
	lb $t3, ($t0)
	beq $t5, $t3, found
	addi $t0, $t0, 1
	lb $t3, ($t0)
	beq $t5, $t3, found
	addi $t0, $t0, 1
	lb $t3, ($t0)
	beq $t5, $t3, found
	addi $t0, $t0, 1
	lb $t3, ($t0)
	beq $t5, $t3, found
	addi $t0, $t0, 1
	lb $t3, ($t0)
	beq $t5, $t3, found
	addi $t0, $t0, 1
	lb $t3, ($t0)
	beq $t5, $t3, found
	addi $t0, $t0, 1
	lb $t3, ($t0)
	beq $t5, $t3, found
	addi $t0, $t0, 1
	j nope				# if letter not found in 9 letters
	
found: 	move $t0, $zero			# reset 9 letters 
	la $t0, characters
	addi $t4, $t4, 1		# update input byte
	j loop2				# loop through 9 letters again
	
nope:	li $v0, 4			# if the input uses a  letter not in the 9 letters
	la $a0, notvalid
	syscall	
	la $a0,newline
    	li $v0,4
    	syscall
    	la $a0,score
    	li $v0,4
    	syscall
    	move $a0, $s3
    	li $v0,1
    	syscall
	move $t6, $zero			# print error message
	j getInput			# get Input
	
end: 	move $t0, $zero			# reset registers
	move $t3, $zero
	move $t5, $zero
	move $t2, $zero
	move $t4, $zero
	move $t6, $zero
	move $t8, $zero
	move $t9, $zero

##################### COMPARE ###############################################################

cmpLoop:
	addi $t7, $t7, 1		# add one to input counter
	lb $t4, ($s2)                   # get next char from str1	
	lb $t5, ($s1)                   # get next char from file
	beq $t5, $s7, slashFound	# end of file
	beq $t5, $s6, periodFound       # check if period-correct words
	bne $t4, $t5, noMatch           # no match

	addi $s1,$s1,1                  # point to next char
    	addi $s2,$s2,1                  # point to next char
    	j cmpLoop 

slashFound:
	li $v0,4			# print not in list
	la $a0, notinlist
	syscall
    	la $a0,score
    	li $v0,4
    	syscall
	li $v0, 1       
	move $a0, $s3       		# print score
	syscall
	move $s1, $zero			# reset file buffer
	la $s1, buffer
	j getInput   			# get input again
	
periodFound:
    	la $a0,correct			# word found
    	li $v0,4			# print Correct! message
    	syscall
    	la $a0,score
    	li $v0,4
    	syscall
    	addi $s3, $s3, 1 		# add one to total score
    	la $t8, used
    	la $s2, input
    	j movetobuffer  		# move $s2 into buffer

movetobuffer:
	lb $t9, 0($s2)
	bne $t9, $zero, putintobuffer
	j nextInput			#get input

putintobuffer:
	sb $t9, 0($t8)
	addi $t8, $t8, 1		#increment $t8
	addi $s2, $s2, 1		#increment $s2
	j movetobuffer

nextInput:
	li $v0, 1       
	move $a0, $s3       		# $integer to print
	syscall
	 
	move $s1, $zero			# reset buffer
	la $s1, buffer
	
	j getInput			# get input again
	
noMatch:
    	beq $t5, $s6, cmpLoop         	# end of string
    	
    	sub $s2, $s2, $t7		# set input address back to beginning of input string
    	addi $t7, $zero, -1 		# set input counter back to zero
    
    	j updateFileLocation		# move to next word
    	
updateFileLocation:
	addi    $s1,$s1,1		# move pointer in file buffer until it hits a period
	lb      $t5,($s1)    		# get next char from str2
	beq	$t5, $s6,ifPeriod	#if where the pointer is equal to period, go back to loop
	j updateFileLocation		#if pointer is not equal to period then loop again
	
ifPeriod:
	addi    $s1,$s1,1		# move pointer in file buffer to kove past period
	j cmpLoop			# check if in dictionary 
	
finalExit:	
	li $v0, 4
	la $a0, exitstatement		# Output goodbye to the user 
	syscall
	
	li $v0,10			# exit syscall
	syscall
	
reset:
	move $t0, $zero			# reset all the registers
	move $t1, $zero
	move $t2, $zero
	move $t3, $zero
	move $t4, $zero
	move $t5, $zero
	move $t7, $zero
	move $s6, $zero
	move $s7, $zero
	move $t9, $zero
	move $t8, $zero
	move $s0, $zero
	la $s0, characters 		# storing it in register $s0
	
	li $v0, 4
	la $a0, stars			# Output stars to the user
	syscall
	
	j randomLetters			# restart program by lauching randomLetters
