;------------------------------------------------
;
; Video 10 Print
; for Atari VCS
;
; Adapted from 10 PRINT CHR$(205.5+RND(1));:GOTO 10 
; A book about a one-line Commodore 64 BASIC program
; http://10print.org
;
; by Ian Bogost, 2011 – 2016
; 
; This code is released under a Creative Commons 
; Attribution 4.0 International License.
; http://creativecommons.org/licenses/by/4.0/
;
; This version scrolls, but doesn't have as unique
; a pattern as the alternate, static version.
;
;------------------------------------------------
	processor 	6502
	include 	vcs.h
	include 	macro.h

;------------------------------------------------
; Constants
;------------------------------------------------
MAZE_HEIGHT = #76
MARGIN_HEIGHT = #20

;------------------------------------------------
; RAM
;------------------------------------------------
    SEG.U   variables
    ORG     $80

frame			.byte	; frame counter
random			.byte	; random seed/value
slashStart		.byte	; for scrolling
slashLine		.byte	; track which line of slashes we are on
slash1ptr		ds 2	; active screen GRP0 pointer
slash2ptr		ds 2	; active screen GRP1 pointer
slash1ptrs		ds 58	; enough for a whole screen + 1/3 more (for scrolling)
slash2ptrs		ds 58	; (we use the extra for scrolling)
dummy			.byte	; used in sleep subroutine

;------------------------------------------------
; Start of ROM
;------------------------------------------------
	SEG   Bank0
	ORG   $F800       		; 2k ROM start point

Start 
	CLEAN_START				; Clear RAM and Registers (via macro)

	;---- Init the sprite settings
	lda		#$0F			; Set both sprite colors to white
	sta		COLUP0
	sta		COLUP1
	lda		#3				; Set both sprites to three copies, closely spaced
	sta		NUSIZ0
	sta		NUSIZ1
	
	;---- Init the playfield settings
	lda		#%00110101		; Set playfield to: mirror, PF on top, ball @ 8 clocks wide
	sta		CTRLPF			; We use the playfield as a kind of rug under which to hide
							; the mess at the edges of the screen from overlap
	lda		#2							
	sta		ENABL			; And we use the ball as touch-up hiding
	lda		#%11000000		; Turn on 6 chunks of edge PF 
	sta		PF1
	lda		#%11110000
	sta		PF0

	jmp		MainLoop		; Skip the reset to force the user to give us a new random
							; value. This has the additional benefit (er?) of starting the
							; program with a blank screen (reset switch to start)
		
Reset	
	ldy		#58				; 34 rows of slashes, x2 to accommodate 16-bit pointers
							; (Only 19 are visible; the others are used for scrolling)
.reset
	;====== Set up sprite pointers for GRP0
	jsr		Rand8			; Get a new random value (subroutine return value in A)
	and		#%00000011		; Mask off all but 0-3 for an index
	tax						; Store in X register for Absolute,X addressing 

	;----- now store the pointer in the right location
	lda		SlashesLow,x	; Load/store the low byte
	sta		slash1ptrs,y	; of the 16-bit address
	lda		SlashesHigh,x	; Load/store the hi byte
	sta		slash1ptrs+1,y	; of the 16-bit address

	;====== Set up sprite pointers for GRP1
	; this is identical to the above, just repeated for a second value
	; and stored in the slash2ptrs RAM space
	jsr		Rand8
	and		#%00000011
	tax		

	lda		SlashesLow,x
	sta		slash2ptrs,y
	lda		SlashesHigh,x
	sta		slash2ptrs+1,y
	
	dey						; We decrement twice because the RAM locations
	dey						; are 2 bytes apart (16 bit pointer values)
	bne		.reset	
	sty		slashStart		; reset the screen scroll
	
;------------------------------------------------
; Vertical Blank
;------------------------------------------------
MainLoop
	lda		#0
	sta		VBLANK			; Turn off Vertical Blank
	VERTICAL_SYNC			; Perform the vertical sync (via macro)
    lda     #43				; Set the timer for the vblank period  
    sta     TIM64T

	inc		frame			; Increment the frame counter (used as random seed)
	lda		#0				; Reset the slash scanline reference
	sta		slashLine		; so it restarts every screen
	
ResetSwitch
    lda     #%0000001		; See if the reset switch was released
    bit     SWCHB			;    (this is the register and bit to test)
    bne		DoScrolling
	lda		frame			; Use the frame counter as a random seed (thus the reset switch)
	bne		.randOK			; Make sure it's non-zero, or we won't get random values
	lda		#$CF			; Otherwise use an arbitrary value
.randOK
	sta		random			; Store the new random seed
	jmp		Reset			; And jump to the RAM reset 

DoScrolling					; Scroll the maze pattern up endlessly
	lda		#15				; Mask and check the frame counter so it's not too fast
	bit		frame
	bne		WaitForVBlank	
	inc		slashStart		; Increment the slash pointer lookup table offset
	inc		slashStart		; (have to inc by 2 because they are 16-bit addresses)
	lda		slashStart		; We stored 7 extra pointers than we need for the screen
	cmp		#20				; Any more than that and we'll get garbage data
	bcc		WaitForVBlank	
	lda		#0				; Reset the slash start offset back to zero 
	sta		slashStart

WaitForVBlank
	lda		INTIM			; Loop here until the timer's done
	bne		WaitForVBlank
	sta		WSYNC

;------------------------------------------------
; Kernel
;------------------------------------------------	
DrawScreen
	;----- Position the ball
	; we're using the ball as a "cover" for unused, messy parts of the screen
	; in addition the PF0, since the timing is such that the 12 columns of 
	; slashes aren't precisely centered.
	jsr		Sleep61			; Delay to position the ball in the right place
							;    (easier to time, plus using NOPs uses more ROM
							;     than a subroutine that eats the right number of cycles.)
	sta		RESBL 			; Strobe the ball position reset
	sta		WSYNC
	
	ldx		#MARGIN_HEIGHT	; 20 lines of spacing at the top of the screen
TopMargin						; Loop to create the top margin
	dex
	sta		WSYNC
	bne		TopMargin
				
	ldx		#MAZE_HEIGHT	; 75 total lines of maze pattern
							;    (+1 so we can loop and branch if not zero)
	lda		#1				; Only half the screen is drawn in each frame
	bit		frame			; so, every other frame...		
	bne		Scanline2.start	; switch to the opposite half of the screen					
							; (this is hardly the most efficient way to do this -- 
							;  it duplicates a lot of code -- but it's more legible)

Scanline1.start
	sta		WSYNC
Scanline
	sleep	6				; For timing
	cpx		#MAZE_HEIGHT	
	beq		loadNext
	sta 	RESM0			; strobing the missile resets for timing, geez
	sta 	RESM1			; could have done something else but this times perfectly,
	sta 	RESM0			; sooooooo...
	sta 	RESM1
	sta 	RESM0			
	sta 	RESM1			
	sta 	RESM0			
	sta 	RESM1
	
	sta		RESP0
	sta 	RESP1			; Continuously strobe RESP0 and RESP1 to fool the TIA into
	sta		RESP0			; reseting the sprite counter and beginning to render new
	sta		RESP1			; sprites every 4 processor cycles.
	sta		RESP0						
	sta		RESP1			; This results in some overlapping on the edges, as sprite
	sta		RESP0			; "cover up" (LOL) with the PF and the ball. 
	sta		RESP1			; triplets begin to wrap around due to timing, which we
	sta		RESP0			; You'll notice there are far more strobes than there are
	sta		RESP1			; visible columns. Needed to get the pattern stable.

loadNext
	lda		(slash1ptr),y	; Indirect loads of the sprite gfx for the next line
	sta		GRP0
	lda		(slash2ptr),y
	sta		GRP1

	iny						
	cpy		#4				; If we've done 3, then we need to change slash pointers
	bne		.skipResetSlashes

LoadNextSlash	
	;---- load new pointer values for the next row of slashes
	; If you don't want it to scroll, just reset slashStart to 0
	; or simply remove/comment out those lines
	
	; (note that this code trucks right through the second scanline)
	
	lda		slashLine		; Grab the current line reference
	clc						; clear the carry flag
	adc		#2				; Add two to get the next 16-bit address
	sta		slashLine		; Store that for later
	adc		slashStart		; Add the start line offset
	tay						; and use that as the offset for the next pointer
	lda		slash1ptrs,y	; Grab that address 
	sta		slash1ptr		; and put it into the GRP0 pointer for next line 
	lda		slash1ptrs+1,y
	sta		slash1ptr+1

	lda		slashLine		; Same as above, for the GRP1 pointer 
	lda		slash2ptrs,y
	sta		slash2ptr
	lda		slash2ptrs+1,y
	sta		slash2ptr+1

	ldy		#0				; Also reset the slash height counter
.skipResetSlashes
	dex						; Decrement the line count
	sta		WSYNC			
	bne		Scanline		; and loop until they're all done
	beq		ScanlineDone

Scanline2.start
	sta		WSYNC
Scanline2
	sleep	7				; For timing
	cpx		#MAZE_HEIGHT	 
	beq		loadNext2
	sta 	RESP0			; Continuously strobe RESP0 and RESP1 to fool the TIA into
	sta 	RESP1			; reseting the sprite counter and beginning to render new
	sta 	RESP0			; sprites every 4 processor cycles.
	sta 	RESP1
	sta 	RESP0			; This results in some overlapping on the edges, as sprite
	sta 	RESP1			; triplets begin to wrap around due to timing, which we 
	sta 	RESP0			; cover up with the PF and the ball. 
	sta 	RESP1
	sta 	RESP0			
	sta 	RESP1			
	sta 	GRP0
	sta 	GRP1			
	sta 	RESP0			
	sta 	RESP1			
	sta 	RESP0			
	sta 	RESP1			
	sta 	RESP0
	sta 	RESP1

loadNext2
	lda		(slash1ptr),y	; Indirect loads of the sprite gfx for the next line
	sta		GRP0
	lda		(slash2ptr),y
	sta		GRP1

	iny						
	cpy		#4				; If we've done 3, then we need to change slash pointers
	bne		.skipResetSlashes2

LoadNextSlash2
	;---- load new pointer values for the next row of slashes
	; same as above... hardly 

	lda		slashLine		; Grab the current line reference
	clc						; clear the carry flag
	adc		#2				; Add two to get the next 16-bit address
	sta		slashLine		; Store that for later
	adc		#0				; Just a few cycles to offset the second side
	adc		slashStart		; Add the start line offset
	tay						; and use that as the offset for the next pointer
	lda		slash2ptrs,y	; Grab that address 
	sta		slash2ptr		; and put it into the GRP0 pointer for next line 
	lda		slash2ptrs+1,y
	sta		slash2ptr+1

	lda		slashLine		; Same as above, for the GRP1 pointer 
	lda		slash1ptrs,y
	sta		slash1ptr
	lda		slash1ptrs+1,y
	sta		slash1ptr+1

	ldy		#0				; Also reset the slash height counter
.skipResetSlashes2
	lda		#0
	dex						; Decrement the line count
	sta		WSYNC			
	bne		Scanline2		; and loop until they're all done

ScanlineDone
	ldx		#MARGIN_HEIGHT	; 20 lines of bottom border
	lda		#1				; except on odd numbered frames
	bit		frame			
	bne		BottomMargin	; in which case
	dex						; we need to accomodate the extra line above
BottomMargin
	dex
	sta		WSYNC
	bne		BottomMargin

	lda		#1				; Because of timing, the pattern is one scanline tall
	bit		frame			;    instead of two. So we just add another scanline
	bne		WaitForOverscan	;    every other frame, and it makes them square 
	sta		WSYNC			;    

;------------------------------------------------
; Overscan
;------------------------------------------------
	lda		#%01000010
	sta		VBLANK			; Turn on vertical blank
	lda		#36				; Set the timer for overscan
    sta		TIM64T

WaitForOverscan
	lda     INTIM			
	bne     WaitForOverscan	; Loop until the timer's elapsed

	jmp		MainLoop		; When we're done, start a new frame

;------------------------------------------------
; Subroutines
;------------------------------------------------
Rand8 SUBROUTINE			
	lda		random			; get seed (can't be zero!)
	asl						; shift byte
	bcc		Rand8.no_eor	; branch if no carry
	eor		#$CF			; else EOR with $CF
Rand8.no_eor
	sta		random			; save number as next seed
	rts

Sleep61	SUBROUTINE			; 6 cycles to get here
	ldx		#0				; 2 (I hope you didn't need whatever was in the x register!)
	ror		dummy,x			; 6, a safe RAM address
	ror		dummy,x			; 6
	ror		dummy,x			; 6
	ror		dummy,x			; 6 (this isn't the most efficient way to do this, but
	ror		dummy,x			; 6  it's sufficiently more efficient and readable than NOPs)
	ror		dummy,x			; 6
	ror		dummy,x			; 6
	ror		dummy,x			; 6
	rts						; 6 to get back

;------------------------------------------------
; ROM Tables
;------------------------------------------------
; There are four permutations of 2 slash patterns: 
; 	\\ /\ // \/
; It's easier and smaller just to keep all four in ROM than to
; construct them in code out of single, one nybble slashes
Slash1	; \\
	.byte #%10001000
	.byte #%01000100
	.byte #%00100010
	.byte #%00010001

Slash2	; /\
	.byte #%00011000
	.byte #%00100100
	.byte #%01000010
	.byte #%10000001

Slash3 ; //
	.byte #%00010001
	.byte #%00100010
	.byte #%01000100
	.byte #%10001000

Slash4 ; \/
	.byte #%10000001
	.byte #%01000010
	.byte #%00100100
	.byte #%00011000

SlashesLow
	.byte <Slash1, <Slash2, <Slash3, <Slash4
	
SlashesHigh
	.byte >Slash1, >Slash2, >Slash3, >Slash4
	
;------------------------------------------------
; Interrupt Vectors
;------------------------------------------------
	echo [*-$F800]d, " ROM bytes used"
	ORG    $FFFA
	.word  Start         ; NMI
	.word  Start         ; RESET
	.word  Start         ; IRQ
    
	END