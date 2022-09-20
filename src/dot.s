.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    # Prologue
    ebreak
    
    mv t0, x0 # total: starts at 0
    mv t1, x0 # counter: starts at 0
       
    slli a3, a3, 2 # change stride step to byte step counts
    slli a4, a4, 2 
    
    # addi t5 x0 1 # set t5 = 1
    bgt a2 x0 check_error_1
    li a0 36
    j exit
    
check_error_1:
    bgt a3 x0 check_error_2
    li a0 37
    j exit
    
check_error_2:
    bgt a4 x0 loop_start
    li a0 37
    j exit

loop_start:
    beq a2, t1, loop_end
    
    lw t2 0(a0) # temporary variables to load number from a0
    lw t3 0(a1) # temp var to load from a1
    
    mul t4 t2 t3 # multiply
    
    add t0 t0 t4 # add to total
    
    add a0 a0 a3 # add by the stride
    add a1 a1 a4 
        
    addi t1 t1 1
    j loop_start
    
loop_end:
    # Epilogue
    mv a0 t0
    jr ra
