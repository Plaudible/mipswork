       .data #defines variable section of an assembly routine

array:     .word 5, 3, 4, 2, -9, 7, 6, -3, -8, 0 #defines variable array as a word array with 10 integers
preprompt:  .asciiz "Here is the array before: " 
postprompt: .asciiz "Here is the array after: " 
gap:        .asciiz "\n"
       .text
       .globl main #start code
main:
la $a0, array #moves the address of array into register $a0, set argument 1 to the array
addi $a1, $zero, 10 #set argument 2  to the array (n=10)
jal pancakeSort #call pancakesort
li $v0, 10 #terminate program
syscall

pancakeSort:
    j printPre
    return1:
    la $a0, gap #stores prompt into $a0
    li $v0, 4 #syscall to print preprompt
    syscall
    addi $sp, $sp, -16 #allocate 4 words from stack
    sw $a1, 0($sp) #store address of array
    sw $a2, 4($sp) #n variable allocation
    sw $s3, 8($sp)  #size variable allocation
    sw $ra, 12($sp) #stack allocation
    add $t6, $a2, $zero #store n into variable to count
    pancakeLoop:
       addi $t8, $zero, 1 #compare to 1
       slt $t7, $t8, $t6 #if less than 1 then true/false
       beq $t7, $zero, printPost #exit case. This is where my code fails: It jumps to the end, and I can't figure out why.
       jal findMax #findmax
       jal flip #flip
       addi $t7, $t7, -1
       add $a2, $t7, $zero
       jal flip #flip
       addi $t6, $t6, -1
       j pancakeLoop
       return2:
       lw $a1, 0($sp) #deallocate array address
       lw $a2, 4($sp) #deallocate for variable n
       lw $s3, 8($sp) #deallocate for size
       lw $ra, 12($sp) #deallocate for ra
       addi $sp, $sp, 16 #deallocate 4 words from stack
       jr $ra
    
printPre:
    la $t2, array #load the array into $t2
    la $a0, preprompt #stores prompt into $a0
    li $v0, 4 #syscall to print preprompt
    syscall
printPreLoop:
    bge $t1, 10, exitPrintPre # load word from one spot in array, exits if looped through entire array
    lw      $t3, 0($t2) #gets value at next position in array
    addi    $t2, $t2, 4  #adds 4 to increment
    move    $a0, $t3 #move value to $a0
    li      $v0, 1 #syscall to print int    
    syscall
    li      $a0, 32 #syscall to print a white space
    li      $v0, 11  #syscall to print char
    syscall
    addi    $t1, $t1, 1 #increment counter for loop
    j      printPreLoop #return to start of loop and repeat for entire array
exitPrintPre:
    li $t1 0
    j return1
    
findMax:
addi $sp $sp -16 #allocate 4 words to the stack
sw $a1, 0($sp) #allocated space to store array address
sw $a2, 4($sp) #allocated space for variable n
sw $s3, 8 ($sp) #allocated space for variable i
sw $s4, 12($sp) #mi(maximum value index)
addi $s3, $zero, 1 #store 1 into 
add $s4, $zero, $zero #store zero as the current maximum value index
forFindMax:
slt $t1, $s3, $a2 #get 0 or 1 for if $t0 < int
beq $t1, $zero, exitfindMax #if equal to 0, go to exitfindmax
addi $t9, $zero, 4 #store 4 to multiply
mul $t2, $s3, $t9 #scale by 4 for word
add $t2, $t2, $a1 #adjust array index
lw $t3, 0($t2) #$t3 is equated to the value at array position i
mul $t4, $s4, $t9 #scale by 4 for word
add $t4, $t4, $a1 #adjust to new index
lw $t5, 0($t4) #$t5 is equated to the value at array position mi
slt $t1, $t5, $t3 #compare if bigger than current
bne $t0, $zero, inc #
add $s4, $s3, $zero #mi = i
inc:
Addi $s3, $s3, 1 #increment index
j forFindMax #jump back to loop 
addi $v0, $s0, 0 #start at new beginning point
exitfindMax:
sw $a1, 0($sp) #deallocate space for array address
sw $a2, 4($sp) #deallocate space for variable n
sw $s3, 8($sp) #deallocate space for variable i
sw $s4, 12($sp) #deallocate space for variable mi
addi $sp, $sp, 16 #deallocate 4 word stack
jr $ra

flip:
addi $sp $sp -12 #allocate 3 words to the stack
sw $a1, 0($sp) #int arr[] input from function call
sw $a2, 4($sp) #int k input from function call
sw $s3, 8($sp) #allocate for swap, int start
add $s3 $zero, $zero #initialize s3 to zero
forFlip:
slt $t0, $s3, $a2 #get 0 or 1 for $t0 < int 
beq $zero, $t0, exitflip #if equal to 0, go to exitflip
addi $t9, $zero, 4 #store 4 to multiply 
mul $t2, $t9, $s3 #increment index
add $t3, $a1, $a1 #store array into $t1
lw $t4, 0($t3) #stores the value in arr[start] into $t4
mul $t5, $a2, $t9 #4 to multiply 
add $t5, $t5, $a1 #store array into $t5
lw $t6, 0($t5) #get val at first position in array
sw $t4, 0($t5) #swap the value here with $t4
sw $t6, 0($t3) #arr[k] stores the temporary value
addi $s3, $s3, 1 #increment start
addi $a2, $a2, -1 #decrement k
exitflip:
lw $a1, 0($sp)
lw $a2, 4($sp)
lw $s3, 8($sp) 
addi $sp, $sp, 12 #deallocate stack
jr $ra

printPost:
la $t2, array #load the array into $t2
la $a0, postprompt #stores prompt into $a0
li $v0, 4 #syscall to print postprompt
syscall
printPostLoop:
    bge $t1, 10, exitPrintPost # load word from one spot in array, exits if looped through entire array
    lw      $t3, 0($t2) #gets value at next position in array
    addi    $t2, $t2, 4  #adds 4 to increment
    move    $a0, $t3 #move value to $a0
    li      $v0, 1 #syscall to print int    
    syscall
    li      $a0, 32 #syscall to print a white space
    li      $v0, 11  #syscall to print char
    syscall
    addi    $t1, $t1, 1 #increment counter for loop
    j      printPostLoop #return to start of loop and repeat for entire array
exitPrintPost:
    li $t1 0
    j return2
 #reverses arr[0..i]
 #void flip(int arr[], int k] {
   #int temp, start = 0;
   #while (start < k) {
      #temp = arr[start];
      #arr[start] = arr[k];
      #arr[k] = temp;
      #start++;
      #k--;
 #NOTE - ALLOCATE + DEALLOCATE STACK AFTER EVERY STEP
 
 #returns index of maximum element in arr[0..n-1]
 #int findMax(int arr[], int n) {
    #int max = arr[0];
    #int mi = 0;
    #for (int i = 1; i < n; ++i) {
       #if (arr[i] > arr[mi]){
          #mi = i;
       #}
     #}
   #return mi;   
              
#main function: pancakesort (int *arr, int n)
   #int size,i;
   #print original list
   #for (size = n; size > 1; size --)
      # int mi = findMax(arr, size);
      #if (mi != size) {
         #flip (arr,mi);
         #flip(arr, size-1);
 #print sorted
