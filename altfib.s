# Mikalangelo Wessel - 04/06/2018
# FSUID: mdw15d
# altfib.s - 
# Register use:
#	$a0	parameters for terms and polish start number and syscall
#	$v0	syscall and return parameter
#	$t0, $t1 temporary calculations
#   $s0-$s7 preserving and restoring certain values on the stack for functions

overflowtest:
       addi	$sp, $sp, -12	# save $ra and $s0-$s3
       sw	$ra, 8($sp)
       sw   $s3, 4($sp)
       sw   $s2, 0($sp)

       subu $t0, $s2, $s3    # $t0 = difference
       
       negu $s3, $s3
       xor $t3, $s2, $s3
       slt $t3, $t3, $zero
       bne $t3, $zero, nooverflow
       xor $t3, $t0, $s2
       slt $t3, $t3, $zero
       bne $t3, $zero, out

       lw	$s2, 0($sp)	    # restore values from stack
       lw   $s3, 4($sp)
       lw   $ra, 8($sp)
	   addi	$sp, $sp, 12

       jr $ra

nooverflow:
       lw	$s2, 0($sp)	    # restore values from stack
       lw   $s3, 4($sp)
       lw   $ra, 8($sp)
	   addi	$sp, $sp, 12

       jr $ra

fib:
       addi	$sp, $sp, -20	# save $ra and $s0-$s3
       sw	$ra, 16($sp)
       sw   $s3, 12($sp)
       sw   $s2, 8($sp)
       sw   $s1, 4($sp)
       sw	$s0, 0($sp)

       addi $s2, $s2, 1
       addi $s3, $s3, 0

       move $s0, $a0
       li $t1, 0

for1:
       beq $t1, 5, after

       la	$a0, blank		# print a space after each number 
	   li	$v0, 4
	   syscall

       addi $s1, $s0, 0

       jal overflowtest

       sub $t0, $s2, $s3   # subtract the last two nums to get next

       addi $s2, $s3, 0    # shift nums for calculation
       addi $s3, $t0, 0

       move	$a0, $t0		# display answer
	   li	$v0, 1
	   syscall

       addi $s0, $s0, 1

       addi $t1, $t1, 1
       j for1

after:
       la	$a0, space		# print a new line after 5th number 
	   li	$v0, 4
	   syscall
       move $a0, $s1        # move next number in sequence to return value
       li $t1, 0
       j for1               # JUMP

exitfib:

       la	$a0, space		# print a new line after 5th number 
	   li	$v0, 4
	   syscall

       move $v0, $s1        # move next number in sequence to return value
       lw	$s0, 0($sp)	    # restore values from stack
       lw   $s1, 4($sp)
       lw   $s2, 8($sp)
       lw   $s3, 12($sp)
	   lw	$ra, 16($sp)
	   addi	$sp, $sp, 20

	   jr	$ra		# return to calling routine

main:  la    $a0, intro      # print intro
       li    $v0, 4
       syscall

       jal fib             # call fib procedure

out:   

       la	$a0, space		# print a new line after each series 
	   li	$v0, 4
	   syscall

       la    $a0, adios      # display closing
       li    $v0, 4
       syscall

       move	$a0, $t0		# display answer
	   li	$v0, 1
	   syscall

       li    $v0, 10         # exit from the program
       syscall

       .data
intro: .asciiz "Here are the alternating Fibonacci numbers that I produced:\n\n"
adios: .asciiz "\nValue causing overflow: "
blank: .asciiz	" "
space: .asciiz "\n"