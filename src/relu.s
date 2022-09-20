.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    mv t0 a1
    mv t2 a0
    addi t3, x0, 1
    blt t0, t3, error
    j loop_start

loop_start:
    # check the values // t2 has the array from a0
    blt t0, x0, loop_end
    lw t2 0(a0)
    # if value is not negative -> skip
    blt x0, t2, loop_continue
    # else set to zero
    sw zero 0(a0)
    # loop continue
    j loop_continue
    
loop_continue:
    addi t0, t0, -1
    addi a0, a0, 4
    j loop_start
    
loop_end:
    # Epilogue
    jr ra

error:
    li a0 36
    j exit