.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

    # Prologue
   
    addi sp, sp, -20
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw ra, 16(sp)
    
    mv s0 a0
    mv s1 a1
    mv s2 a2
    
    # call fopen
    mv a1 x0 #set permission to read only
    jal fopen
    addi t0, x0, -1
    beq t0, a0, error_fopen
    mv s0 a0 # s0 now contains pointer to file description
    
    ebreak
    # call malloc
    addi t2 x0 8
    mv a0 t2
    jal malloc
    beq a0 x0 error_malloc
    
    # call fread
    mv a1 a0 #a1 now contains array from prev malloc
    mv a0 s0 #s0 contains array descriptor
    jal ra free
    addi a2 x0 8
    addi sp, sp, -4
    sw a1 0(sp)
    
    jal fread

    lw a1 0(sp)
    addi sp, sp, 4    

    lw t0 0(a1) #s1 contains num rows of matrix
    lw t1 4(a1) #s2 contains num cols of matrix
    sw t0 0(s1)
    sw t1 0(s2)
    
    # call malloc
    mul t2, t0, t1
    slli t2 t2 2
    mv a0 t2
    jal malloc
    beq a0 x0 error_malloc
    mv s3 a0 #s3 contains pointer to array buffer
    lw t0 0(s1)
    lw t1 0(s2)
       
    # call fread
    mv a0 s0 #s0 contains array descriptor
    mv a1 s3 #s3 contains matrix array pointer
    mul a2 t0 t1
    slli a2 a2 2
    jal fread
    
    lw t0 0(s1)
    lw t1 0(s2)
    
    mul t2 t0 t1
    slli t2 t2 2
    bne t2 a0 error_fread
    
    mv a0 s0
    jal fclose
    addi t1 x0 -1
    beq t1 a0 error_fclose

    mv a0 s3
    
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw ra, 16(sp)
    addi sp, sp, 20

    jr ra

error_malloc:
    li a0 26
    j exit

error_fopen:
    li a0 27
    j exit
    
error_fclose:
    li a0 28
    j exit
    
error_fread:
    li a0 29
    j exit
