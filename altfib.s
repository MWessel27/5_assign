# Mikalangelo Wessel - 04/06/2018
# FSUID: mdw15d
# altfib.s - 
# Register use:
#	$a0	parameters for terms and polish start number and syscall
#	$v0	syscall and return parameter
#	$t0, $t1 temporary calculations
#   $s0-$s7 preserving and restoring certain values on the stack for functions

fib:
       addi	$sp, $sp, -12	# save $ra and $s0-$s3
       sw	$ra, 8($sp)
       sw   $s1, 4($sp)
       sw	$s0, 0($sp)

       move $s0, $a0
       li $t1, 0

for1:
       beq $t1, 5, exitfib

       la	$a0, blank		# print a space after each number 
	   li	$v0, 4
	   syscall

       addi $s1, $s0, 0

       move	$a0, $s0		# display answer
	   li	$v0, 1
	   syscall

       addi $s0, $s0, 1

       addi $t1, $t1, 1
       j for1

exitfib:

       la	$a0, space		# print a new line after 5th number 
	   li	$v0, 4
	   syscall

       move $v0, $s1        # move next number in sequence to return value
       lw	$s0, 0($sp)	    # restore values from stack
       lw   $s1, 4($sp)
	   lw	$ra, 8($sp)
	   addi	$sp, $sp, 12

	   jr	$ra		# return to calling routine

main:  la    $a0, intro      # print intro
       li    $v0, 4
       syscall

       li $a0, 1

loop:  
       beq $t0, 10, out

       jal fib             # call fib procedure

       move  $a0, $v0

       addi $t0, $t0, 1
       j loop                # branch back for next value of n

out:   
       la	$a0, space		# print a new line after each series 
	   li	$v0, 4
	   syscall

       la    $a0, adios      # display closing
       li    $v0, 4
       syscall
       li    $v0, 10         # exit from the program
       syscall

       .data
intro: .asciiz "Here are the alternating Fibonacci numbers that I produced:\n\n"
adios: .asciiz "Value causing overflow: "
blank: .asciiz	" "
space: .asciiz "\n"