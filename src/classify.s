.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    addi sp, sp, -64
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw ra, 32(sp)
    
    mv s0, a0
    mv s1, a1
    mv s2, a2
    
    li t0 5
    bne a0, t0, error_cmdline
    # Read pretrained m0
    lw a0 4(s1)
    addi a1 sp 40
    addi a2 sp 44
    jal read_matrix
    mv s3 a0 # s3 contains m1

    # Read pretrained m1
    lw a0 8(s1)
    addi a1 sp 48
    addi a2 sp 52
    jal read_matrix
    mv s4 a0 # s4 contains m2

    # Read input matrix
    lw a0 12(s1)
    addi a1 sp 56
    addi a2 sp 60
    jal read_matrix
    mv s5 a0 # s5 contains input matrix


    # Compute h = matmul(m0, input)
    # malloc to fit h: num row of m0 x col of input
    lw t0 40(sp)
    lw t1 60(sp)
    mul a0 t0 t1
    slli a0 a0 2
    jal malloc
    beq a0 x0 error_malloc
    mv s7 a0 #s7 contains pointer to resulting matrix of matmul
    # call matmul
    mv a0 s3
    lw a1 40(sp)
    lw a2 44(sp)
    mv a3 s5
    lw a4 56(sp)
    lw a5 60(sp)
    mv a6 s7
    jal matmul
    

    # Compute h = relu(h)
    mv a0 s7
    lw t0 40(sp)
    lw t1 60(sp)
    mul a1 t0 t1
    jal relu

    # Compute o = matmul(m1, h)
    lw t0 48(sp)
    lw t1 60(sp)
    mul a0 t0 t1
    slli a0 a0 2
    jal malloc
    beq a0 x0 error_malloc
    mv s6 a0 #s6 contains pointer to resulting matrix of matmul
    # call matmul
    mv a0 s4
    lw a1 48(sp)
    lw a2 52(sp)
    mv a3 s7
    lw a4 40(sp)
    lw a5 60(sp)
    mv a6 s6
    jal matmul    

    # Write output matrix o
    lw a0 16(s1)
    mv a1 s6
    lw a2 48(sp)
    lw a3 60(sp)
    jal write_matrix
        
        
    # Compute and return argmax(o)
    mv a0 s6
    lw t0 48(sp)
    lw t1 60(sp)
    mul a1 t0 t1
    jal argmax #a0 contains argmax(o)
    mv s0 a0

    # If enabled, print argmax(o) and newline
    bne s2 x0 end
    jal print_int
    li a0 '\n'
    jal print_char
    
    # free data
    mv a0 s0
    jal ra free
    mv a0 s1
    jal ra free
    mv a0 s2
    jal ra free
    mv a0 s3
    jal ra free
    mv a0 s4
    jal ra free
    mv a0 s5
    jal ra free
    mv a0 s6
    jal ra free
    mv a0 s7
    jal ra free
    sw x0 40(sp)
    sw x0 44(sp)
    sw x0 48(sp)
    sw x0 52(sp)
    sw x0 56(sp)
    sw x0 60(sp) 
    
    mv a0 s0
end:  
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw ra, 32(sp)
    addi sp, sp, 64

    jr ra

error_cmdline:
    li a0 31
    j exit
    
error_malloc:
    li a0 26
    j exit
