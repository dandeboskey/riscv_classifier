.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:
    # Error checks
    bne a2, a4, error
    addi t0, x0, 1
    blt a1, t0, error
    blt a2, t0, error
    blt a4, t0, error
    blt a5, t0, error
    #Prologue  
    addi sp, sp, -44
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw s9, 36(sp)
    sw ra 40(sp)
    
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    mv s6, a6
    
    mv s7, x0 # counter for outerloop
    mv s8, x0 # counter for innerloop
    mv s9, a6
outer_loop_start:
    # iterate over every row of m0
    beq s7, s1, outer_loop_end
    j inner_loop_start
    
inner_loop_start:
    # iterate over every column of m1
    beq s8, s5, inner_loop_end
    
    li t0 4 # set t0 to 4
    mul t0 s2 t0 # multiply columns by 4
    mul t0 s7 t0 # multiply by outer loop counter
    add a0 s0 t0 # add to a0
    
    li t0 4 # reset to 4
    mul t0, t0, s8 # offset -> t0 * inner loop ctr
    add a1, s3, t0 # column position + offset -> a1
    
    mv a2, s2 # matrix 0 width, 
    li a3, 1 # stride of v0
    mv a4, s5
    
    jal ra dot
    
    sw a0 0(s6)
    addi s6, s6, 4 # add 4 to move d over 1 int
    addi s8, s8, 1 # increment ctr
    j inner_loop_start
inner_loop_end:
    li s8, 0 # reset counter
    addi s7, s7, 1
    j outer_loop_start
    # call the outer loop start again
outer_loop_end:
    mv a6, s9
    
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw ra 40(sp)
    addi sp, sp, 44
    jr ra

error:
    li a0 38
    j exit