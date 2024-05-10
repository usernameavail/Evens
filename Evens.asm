.data 

prompt_user: .asciiz "Enter the amount of values between 1 and 10: "
whitespace: .asciiz " "
prompt_loop: .asciiz "Enter in an integer value: "
error_msg: .asciiz "Invalid Input. Exiting."
avg_msg: .asciiz "\nThe average of even values is: "
even_display: .asciiz "The even values are: "
			.align 2

even_array: .space 40 #10 max ints

.text
.globl main

main:

	#init counters
	li $t0, 0
	li $t1, 0 #init array index to 0
	li $t3, 0 #addsum
	li $t6, 0 #even_num_count
	li $t7, 0

	#prompt for number 1-10
	li $v0, 4
	la $a0, prompt_user
	syscall
	
	#take input
	li $v0, 5
	syscall

	move $t2, $v0
	
	#input validation
	blt $t2, 1, input_error
	bgt $t2, 10, input_error
	
	
	
	
loop:

	
	li $v0, 4
	la $a0, prompt_loop
	syscall
	
	#take input
	li $v0, 5
	syscall

	move $s0, $v0
	
	li $t4, 2
	div $t4, $s0, $t4
	mfhi $t5
	beqz $t5, store_even_values
	bnez $t5, continue
	
	j continue
	
	
store_even_values: 
	
	sw $s0, even_array($t1)
	addi $t1, $t1, 4
	add $t3, $s0, $t3
	add $t6, $t6, 1 # increment num of even values 
	
	
	j continue
		

continue:
	
	sub $t2, $t2, 1 # decrement the counter for n
	
	beqz $t2, evens_prompt
	
	j loop
	
	
evens_prompt:
	
	li $v0, 4
	la $a0, even_display
	syscall


display_nums:
	
	beq $t1, $t0, display_avg #exit the loop
	
	li $v0, 1
	lw $a0, even_array($t0)
	syscall
	
	addi $t0, $t0, 4
	
	li $v0, 4
	la $a0, whitespace
	syscall
	
	j display_nums #loop to display all even nums
	

display_avg:

	mtc1 $t3, $f0
	cvt.s.w $f0, $f0
	mtc1 $t6, $f1
	cvt.s.w $f1, $f1
	
	div.s $f3, $f0, $f1
	
	li $v0, 4
	la $a0, avg_msg
	syscall
	
	
	mov.s $f12, $f3
	li $v0, 2
	syscall
	
	j exit
	
	
	
input_error:
	
	li $v0, 4
	la $a0, error_msg
	syscall
	
	j exit
	
exit:
	
	li $v0, 10
	syscall
	