.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    mv t0 a1 # number of elements / current index
    addi t1, x0, 1
    lw t2 0(a0) # have the current max value
    mv t3 x0 # store the largest index with t3
    lw t4 0(a0) # current element
    mv t5 x0
    bgt t0, x0, loop_start
    li a0 36
    j exit

loop_start:
    # check the values // t2 has the array from a0
    blt t0, t1, loop_end
    # t2 is the value at the new index
    # if value is the max, then update in loop_continue
    lw t4 0(a0)
    blt t4, t2, loop_continue
    mv t2 t4
    sub t3 a1 t0
    # else set to zero
    # sw zero 0(a0)
    # loop continue
    j loop_continue
    
loop_continue:
    addi t0, t0, -1
    addi a0, a0, 4
    j loop_start
    
loop_end:
    mv a0 t3
    jr ra
