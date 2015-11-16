.data
		
PI:	# PI
	.long	0x40490fda
dPI:	# 2*PI
	.long	0x40c90fdb
hPI:	# PI/2
	.long	0x3fc90fdb
qPI:	# PI/4
	.long	0x3f490fdb
ONE:	# 1.0
	.long	0x3f800000
TWO:	# 2.0
	.long	0x40000000
HALF:	# 0.5
	.long	0xbf000000
		
lf.1:	# 8388608.0
	.long	0x4b000000
lf.2:	# -8388608.0
	.long	0xcb000000	

lks.1:	#  -0.16666668
	.long	0xbe2aaaac
lks.2:	#  0.008332824
	.long	0x3c088666

lkc.1:	#  0.04166368
	.long	0x3d2aa789
lkc.2:	#  -0.0013695068
	.long	0xbab38106

lsc.1:	# 
	.long	0x80000000

lka.1:	# -0.3333333
	.long	0xbeaaaaaa
lka.2:	# 0.2
	.long	0x3e4ccccd
lka.3:	# -0.142857142
	.long	0xbe124925
lka.4:	# 0.111111104
	.long	0x3de38e38
lka.5:	# -0.08976446
	.long	0xbdb7d66e
lka.6:	# 0.060035485
	.long	0x3d75e7c5

la.1:	# 0.4375
	.long	0x3ee00000
la.2:	# 2.4375
	.long	0x401c0000


		
.text
		
# int read_int(void)
.globl	min_caml_read_int
min_caml_read_int:
	rrb	$v0
	sll	$v0, $v0, 24
	rrb	$s0
	sll	$s0, $s0, 16
	add	$v0, $v0, $s0
	rrb	$s0
	sll	$s0, $s0, 8
	add	$v0, $v0, $s0
	rrb	$s0
	add	$v0, $v0, $s0
	jr $ra

# float read_float(void)
.globl	min_caml_read_float
min_caml_read_float:
	rrb	$v0
	sll	$v0, $v0, 24
	rrb	$s0
	sll	$s0, $s0, 16
	add	$v0, $v0, $s0
	rrb	$s0
	sll	$s0, $s0, 8
	add	$v0, $v0, $s0
	rrb	$s0
	add	$v0, $v0, $s0
	jr $ra

# int(void) print_char(char x)
.globl min_caml_print_char
min_caml_print_char:
	rsb	$a0
	jr	$ra

# int(void) print_int(int x)	
.globl	min_caml_print_int
min_caml_print_int:
	srl	$s0, $a0, 24
	rsb	$s0
	srl	$s0, $a0, 16
	rsb	$s0
	srl	$s0, $a0, 8
	rsb	$s0
	rsb	$a0
	jr $ra

# int(void) print_float(float x)
.globl	min_caml_print_float
min_caml_print_float:
	srl	$s0, $a0, 24
	rsb	$s0
	srl	$s0, $a0, 16
	rsb	$s0
	srl	$s0, $a0, 8
	rsb	$s0
	rsb	$a0
	jr $ra
		
# bool fequal(float x, float y)
.globl min_caml_fequal
min_caml_fequal:
	beq	$a0, $a1, fequal_true
	move	$v0, $zero 
	jr	$ra
fequal_true:
	addi	$v0, $zero, 1
	jr	$ra

# bool fless(float x, float y)
.globl min_caml_fless
min_caml_fless:
	fslt	$at, $a0, $a1
	bne	$at, $zero, fless_true
	move	$v0, $zero 
	jr	$ra
fless_true:
	addi	$v0, $zero, 1
	jr	$ra

# bool fispos(float x)
.globl min_caml_fispos
min_caml_fispos:
	fslt	$at, $zero, $a0
	bne	$at, $zero, fispos_true
	move	$v0, $zero 
	jr	$ra
fispos_true:
	addi	$v0, $zero, 1
	jr	$ra

# bool fisneg(float x)
.globl min_caml_fisneg
min_caml_fisneg:
	fslt	$at, $a0, $zero
	bne	$at, $zero, fisneg_true
	move	$v0, $zero 
	jr	$ra
fisneg_true:
	addi	$v0, $zero, 1
	jr	$ra

# bool fiszero(float x)
.globl min_caml_fiszero
min_caml_fiszero:
	beq	$a0, $zero, fiszero_true
	move	$v0, $zero 
	jr	$ra
fiszero_true:
	addi	$v0, $zero, 1
	jr	$ra

# float fhalf(float x)
.globl min_caml_fhalf
min_caml_fhalf:
	llw	$s0, (HALF)
	fmul	$v0, $a0, $s0
	jr	$ra

# float fspr(float x)
.globl min_caml_fsqr
min_caml_fsqr:
	fmul	$v0, $a0, $a0
	jr	$ra

# float fabs(float x)
.grobal	min_caml_fabs
min_caml_fabs:
	fslt	$at, $a0, $zero
	bne	$at, $zero, fabs_plus
	move	$v0, $a0
	fneg	$v0, $v0
fabs_plus:
	jr	$ra

# float fneg(float x)
.globl min_caml_fneg
min_caml_fneg:
	fneg	$v0, $a0
	jr	$ra

# float fneg(float x)
.globl min_caml_fneg
min_caml_fneg:
	fneg	$v0, $a0
	jr	$ra

# float sqrt(float x)
.globl min_caml_sqrt
min_caml_sqrt:
	llw	$s0, (HALF)			
	fmul	$s1, $a0, $s0
	addi	$s3, 10
sqrt_loop:
	beq	$s3, $zero, sqrt_end
	finv	$s2, $s1
	fmul	$s2, $s2, $a0
	fadd	$s1, $s1, $s2
	fmul	$s1, $s1, $s0
	addi	$s3, $s3, -1
	beq	$zero, $zero, sqrt_loop
sqrt_end:
	move	$v0, $s1
	jr	$ra

# float floor(float x)
.globl	floor
min_caml_floor:
		move	$s0, $zero               
        llw	$s2, (lf.1)                  
        llw	$s3, (ONE)                   
        llw	$s4, (lf.2)                   
        beq	$a0, $s0, floor_zero             
        fslt	$at, $a0, $s0             
        bne	$at, $zero, floor_neg                   
        fslt	$at, $s2, $a0                  
        bne	$at, $zero, floor_badend                  
        fadd	$s1, $a0, $s2            
        fadd	$s1, $s1, $s4            
        fslt	$at, $a0, $s1                 
        beq	$at, $zero, floor_end                   
		fneg	$v0, $s3
        fadd	$v0, $s1, $v0         
        jr	$ra                   	
floor_neg:                                 
        fslt	$at, $a0, $s4                
        bne	$at, $zero, floor_badend                
        fadd   $s1, $a0, $s4           
        fadd   $s1, $s1, $s2           
        fslt $at, $a0, $s1               
        beq $at, $zero, floor_end                 
		fneg	$v0, $s3
        fadd	$v0, $s1, $v0            
        jr	$ra                      
floor_zero:                                
        move	$v0, $s0                 
floor_badend:                                
        jr	$ra                     
floor_end:
        move	$v0, $s1                
        jr	$ra                      

# int int_of_float(float x)
.globl	int_of_float
min_caml_int_of_float:
	fslt	$at, $a0, $zero
	beq	$at, $zero, ftoi_main	
	move	$s5, $zero
	fneg	$a0, $a0	
	addi	$s5, $s5, 1
ftoi_main:
	addi	$s0, $zero, 8388608
	llw	$s1, (lf.1)
	llw	$s2, (lf.2)
	fslt	$at, $a0, $s1 		
	beq	$at, $zero, ftoi_large		
	subi	$v0, $a0, 0x4b000000	
	beq	$zero, $zero, ftoi_flag
	nop
ftoi_large:
	move	$s3, $zero			
	move $s4, $a0
ftoi_loop:
	addi	$s3, $s3, 1		
	fadd	$s4, $s4, $s2		
	fslt	$at, $s4, $s1
	beq	$at, $zero, ftoi_loop	
	move	$v0, $zero
ftoi_loop2:
	add	$v0, $s0, $v0	
	addi	$s3, $s3, -1
	slt	$at, 0, $s3
	bne	$at, $zero, ftoi_loop2
	subi	$s4, $s4, 0x4b000000		
	add	$v0, $s4, $v0	
ftoi_flag:
	beq	$s5, $zero, ftoi_end
	nop
	sub	$v0, $zero, $v0
ftoi_end:
	jr	$ra

# float float_of_int(int x)
.globl	float_of_int
min_caml_float_of_int:
	slt	$at, $a0, $zero
	beq	$at, $zero, itof_main	
	move	$s4, $zero
	sub	$a0, $zero, $a0	
	addi	$s4, $s4, 1
itof_main:
	addi	$s0, $zero, 8388608
	llw	$s1, (lf.1)
	slt	$at, $a0, $s0 		
	beq	$at, $zero, itof_large		
	ori	$v0, $a0, 0x4b000000	
	beq	$zero, $zero, itof_flag
	nop
itof_large:
	move	$s2, $zero			
	move $s3, $a0
itof_loop:
	addi	$s2, $s2, 1		
	sub	$s3, $s3, $s0		
	slt	$at, $s3, $s0
	beq	$at, $zero, itof_loop	
	move	$v0, $zero
itof_loop2:
	fadd	$v0, $s1, $v0	
	addi	$s2, $s2, -1
	slt	$at, 0, $s2
	bne	$at, $zero, itof_loop2
	ori	$s3, $s3, 0x4b000000		
	fadd	$v0, $s3, $v0	
itof_flag:
	beq	$s4, $zero, itof_end
	nop
	ori	$v0, $v0, 0x80000000
itof_end:
	jr	$ra

# int *create_array(int x, int y)
# float *create_array(int x, float y)
.globl min_caml_create_array
min_caml_create_array:
	move	$s0, $gp
	move	$v0, $gp
	add	$gp, $gp, $a0
create_array_loop:
	beq	$a0, $zero, create_array_end
	sw	$a1, 0($s0)
	addi	$s0, $s0, 1
	addi	$a0, $a0, -1
	bne	$zero, $zero, create_array_loop
create_array_end:
	jr	$ra

# unsigned int div10(unsigned int x)
.globl	div10
min_caml_div10:
	add	$a0 $zero $v0
	addi	$s0 $zero 2
	srl	$v0 $a0 $s0
	add	$v0 $v0 $a0
	addi	$s0 $zero 1
	srl	$v0 $v0 $s0
	add	$v0 $v0 $a0
	addi	$s1 $zero 3
	srl	$v0 $v0 $s1
	add	$v0 $v0 $a0
	srl	$v0 $v0 $s0
	add	$v0 $v0 $a0
	srl	$v0 $v0 $s1
	add	$v0 $v0 $a0
	srl	$v0 $v0 $s0
	add	$v0 $v0 $a0
	srl	$v0 $v0 $s1
	add	$v0 $v0 $a0
	srl	$v0 $v0 $s0
	add	$v0 $v0 $a0
	srl	$v0 $v0 $s1
	add	$v0 $v0 $a0
	srl	$v0 $v0 $s0
	add	$v0 $v0 $a0
	srl	$v0 $v0 $s1
	add	$v0 $v0 $a0
	srl	$v0 $v0 $s0
	add	$v0 $v0 $a0
	srl	$v0 $v0 $s1
	add	$v0 $v0 $a0
	srl	$v0 $v0 $s0
	add	$v0 $v0 $a0
	srl	$v0 $v0 $s1
	add	$v0 $v0 $a0
	srl	$v0 $v0 $s0
	add	$v0 $v0 $a0
	addi	$s1 $zero 4
	srl	$v0 $v0 $s1
	jr	$ra
		
# reduction
min_caml_reduction:
		llw $s0, (PI)          
        llw	$s1, (dPI)              
        llw	$s2, (TWO)                 
        llw	$s3, (HALF)                
reduction_loop_plus:                    
        fmul	$s0, $s0, $s2            
        fslt	$at, $a0, $s0               
        beq	$at, $zero, reduction_loop_plus
reduction_loop_minus:  	                
        fslt	$at, $a0, $s0                 
        beq	$at, $zero, reduction_endif    
		fneg	$s4, $s0
        fadd	$a0, $a0, $s4            
reduction_endif:                   
        fmul	$s0, $s0, $s3            
        fslt	$at, $a0, $s1                  
        beq	$at, $zero, reduction_loop_minus      
		move $v0, $a0
        jr	$ra

# float kernel_sin(float x)
# x + 0xbe2aaaac * x^3 + 0x3c088666 * x^5 + 0xb94d64b6 * x^7
min_caml_kernel_sin:
        llw $s2, (lks.1)                 
        llw $s3, (lks.2)                 
        llw $s4, (TWO)                 
        fmul	$s0, $a0, $a0            
        fmul	$s1, $s0, $a0           
        fmul	$s2, $s2, $s1            
        fadd	$a0, $a0, $a2            
        fmul	$s1, $s1, $s0            
        fmul	$s3, $s3, $s1            
        fadd	$a0, $a0, $s3          
        fmul	$s1, $s1, $s0             
        fmul	$s4, $s4, $s1            
        fadd	$v0, $a0, $s4            
        jr      $ra

		
# float kernel_cos(float x)
# = 1.0 + 0xbf000000 * x^2 + 0x3d2aa789 * x^4 + 0xbab38106 * x^6
min_caml_kernel_cos:
        llw	$s3, (HALF)                  
        llw	$s4, (lkc.1)                  
        llw $s5, (lkc.2)                 
        fmul	$s0, $a0, $a0            
        llw	$s0, (ONE)                  
        fmul	$s3, $s3, $a0             
        fadd	$a0, $a0, $s3             
        fmul	$s2, $s3, $s3             
        fmul	$s4, $s4, $s2             
        fadd	$a0, $a0, $s4          
        fmul	$s1, $s0, $s2             
        fmul   $s5, $s5, $s1            
        fadd   $v0, $a0, $s5             
        jr	$ra
	
# float sin(float x)
.grobal	sin
min_caml_sin:
        srl	$s1, $a0, 0x1f          
        sll	$a0, $a0, 1
        srl	$a0, $a0, 1                  
        addi	$sp, $sp, -2             
        sw	$ra, 1($sp)               
        sw	$s1, 0($sp)            
        jal	min_caml_reduction    
        lw	$s1, 0($sp)               
        move	$s2, $zero               
        llw	$s3, (PI)                 
        fslt	$at, $a0, $s3                 
        beq	$at, $zero, sin_elarge_pi               
		fneg	$v0, $s3
        fadd	$a0, $a0, $v0             
        addi	$s1, $s1, 0x1            
sin_elarge_pi:                              
        llw	$s4, (hPI)                  
        fslt	$at, $a0, $s4                  
        beq	$at, $zero, sin_elarge_hpi			
		fneg	$v0, $a0
        fadd	$a0, $s3, $v0             
sin_elaege_hpi:                              
        llw	$s5, (qPI)                 
        sw	$s1, 0($sp)              
        fslt	$at, $s5, $a0                  
        beq	$at, $zero, sin_small_qpi                
		nop
        jal	min_caml_kernel_sin       
        beq	$zero, $zero, sin_end               
sin_small_qpi:                              
		fneg	$v0, $a0
        fadd	$a0, $s4, $v0             
        jal	min_caml_kernel_cos       
sin_end:                              
        lw	$s0, 0($sp)               
        sll	$s0, $s1, 31          
		fadd	$v0, $v0, $s0
        llw	$s0, (lsc.1)                  
        fadd	$v0, $v0, $s0             
        lw	$ra, 1($sp)
        addi	$sp, $sp, 2
        jr	$ra

# float cos(float x)
.globl	cos
min_caml_cos:
        sll	$a0, $a0, 1
        srl	$a0, $a0, 1			
        addi	$sp, $sp, -2
        sw	$ra, 1($sp)
        jal	min_caml_reduction     
        move	$s0, $zero                
        move	$s1, $zero                
        llw	$s2, (PI)                  
        fslt	$at, $a0, $s2                  
        beq	$at, $zero, cos_elarge_pi               
		fneg	$v0, $s2
        fadd	$a0, $a0, $v0             
        addi	$s0, $s0, 0x1             
cos_elarge_pi:                              
        llw	$s3, (hPI)                  
        fslt	$at, $a0, $s3                 
        beq $at, $zero, cos_elarge_hpi               
		fneg	$v0, $a0
        fadd	$a0, $s2, $v0             
        addi	$s0, $s0, 0x1             
cos_elarge_hpi:                              
        llw	$s4, (qPI)                 
        sw	$s0, 0($sp)               
        fslt	$at, $s4, $a0                 
        beq	$at, $zero, cos_small_qpi                
		nop
        jal	min_caml_kernel_cos      
        beq	$zero, $zero, cos_end               
cos_small_qpi:                             
		fneg	$v0, $a0
        fadd	$a0, $s3, $v0           
        jal	min_caml_kernel_sin      
cos_end:                              
        lw	$s0, 0($sp)               
        sll	$s0, $s0, 31			  
		fadd	$v0, $v0, $s0
        llw	$s0, (lsc.1)                  
        add	$v0, $v0, $s0            
        lw	$ra, 1($sp)
        addi	$sp, $sp, 2
        jr	$ra

# float kernel_atan(float x)
# x + 0xbeaaaaaa * x^3  +  0x3e4ccccd * x^5  + 0xbe124925 * x^7
#   + 0x3de38e38 * x^9  +  0xbdb7d66e * x^11 + 0x3d75e7c5 * x^13
min_caml_kernel_atan:
        llw	$s2, (lka.1)                 
        llw	$s3, (lka.2)                 
        llw	$s4, (lka.3)                 
        fmul	$s0, $a0, $a0            
        fmul	$s1, $s0, $a0            
        fmul	$s2, $s2, $s1            
        fadd	$a0, $a0, $s2            
        fmul	$s1, $s1, $s0            
        fmul	$s3, $s3, $s1           
        fadd	$a0, $a0, $s3            
        fmul	$s1, $s1, $s0           
        fmul	$s4, $s4, $s1           
        fadd	$a0, $a0, $s4            
        llw	s2, (lka.4)                 
        llw	s3, (lka.5)                 
        llw	s4, (lka.6)                 
        fmul	$s1, $s1, $s0             
        fmul	$s2, $s2, $s1             
        fadd	$a0, $a0, $s2            
        fmul	$s1, $s1, $s0            
        fmul	$s3, $s3, $s1            
        fadd	$a0, $a0, $s3             
        fmul	$s1, $s1, $s0            
        fmul	$s4, $s4, $s1            
        fadd	$v0, $a0, $s4            
        jr	$ra	
		
# float atan(float x)
.globl	atan
min_caml_atan:
		move	$s0, $a0
        sll     $s0, $s0, 1               
        srl     $s0, $s0, 1                 
        llw	$s1, (la.1)                 
        fslt	$at, $s0, $s1                 
        bne	$at, $zero, atan_small_04375               
        llw	$s1, (la.2)                 
        fslt	$at, $s0, $s1                 
        bne	$at, $zero, atan_small_24375              
		nop
        beq	$zero, $zero, atan_else             
# Case 1: |A| < 0.4375
atan_small_04375:
        addi	$sp, $sp, -1              
        sw	$ra, 0($sp)               
        jal	min_caml_kernel_atan      
        lw	$ra, 0($sp)               
        addi	$sp, $sp,  1              
        jr	$ra                       
atan_small_24375:
        addi	$sp, $sp, -2              
        sw	$ra, 1($sp)               
        move	$s1, $a0                  
        srl	$s1, $s1, 31              
        sw	$s1, 0($sp)               
        llw	$s2, (ONE)                 
		fneg	$v0, $a2
        fadd	$s3, $s0, $v0             
        fadd	$s4, $s0, $s2            
		finv	$v0, $s4
        fmul	$a0, $s3, $v0           
        jal	min_caml_kernel_atan     
        llw	$s1, (qPI)                 
        fadd	$v0, $v0, $s1             
        lw	$s0, 0($sp)              
        sll	$s0, $s0, 31             
        or	$v0, $s0, $v0            
        lw	$ra, 1($sp)              
        addi	$sp, $sp, 2               
        jr	$ra                       
atan_else:
        addi	$sp, $sp, -2              
        sw	$ra, 1($sp)               
        sw	$ra, 1($sp)               
        move	$s1, $a0                  
        srl	$s1, $s1, 31              
        sw	$s1, 0($sp)              
        llw	$s2, (ONE)                 
		finv	$v0, $s0
        fmul	$a0, $s2, $v0           
        jal	min_caml_kernel_atan     
        llw	$s1, (hPI)                 
		fneg	$s0, $v0
        fadd	$v0, $s1, $s0             
        lw	$s0, 0($sp)              
        sll	$s0, $s0, 31             
        or	$v0, $s0, $vo            
        lw	$ra, 1($sp)               
        addi	$sp, $sp, 2               
        jr	$ra                       
