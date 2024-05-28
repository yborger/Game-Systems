; Disassembly of 10Print-scrolling.bin
; Disassembled Mon Oct  2 15:19:56 2023
; Using DiStella v3.02-SNAPSHOT
;
; Command Line: distella -pas 10Print-scrolling.bin 
;

      processor 6502
VSYNC   =  $00
VBLANK  =  $01
WSYNC   =  $02
NUSIZ0  =  $04
NUSIZ1  =  $05
COLUP0  =  $06
COLUP1  =  $07
CTRLPF  =  $0A
PF0     =  $0D
PF1     =  $0E
RESP0   =  $10
RESP1   =  $11
RESM0   =  $12
RESM1   =  $13
RESBL   =  $14
GRP0    =  $1B
GRP1    =  $1C
ENABL   =  $1F
SWCHB   =  $0282
INTIM   =  $0284
TIM64T  =  $0296

       ORG $F800

START:
       SEI            ;2
       CLD            ;2
       LDX    #$00    ;2
       TXA            ;2
       TAY            ;2
LF806: DEX            ;2
       TXS            ;2
       PHA            ;3
       BNE    LF806   ;2
       LDA    #$0F    ;2
       STA    COLUP0  ;3
       STA    COLUP1  ;3
       LDA    #$03    ;2
       STA    NUSIZ0  ;3
       STA    NUSIZ1  ;3
       LDA    #$35    ;2
       STA    CTRLPF  ;3
       LDA    #$02    ;2
       STA    ENABL   ;3
       LDA    #$C0    ;2
       STA    PF1     ;3
       LDA    #$F0    ;2
       STA    PF0     ;3
       JMP    LF856   ;3
LF82A: LDY    #$3A    ;2
LF82C: JSR    LF9A1   ;6
       AND    #$03    ;2
       TAX            ;2
       LDA    LF9CE,X ;4
       STA    $0088,Y ;5
       LDA    LF9D2,X ;4
       STA    $0089,Y ;5
       JSR    LF9A1   ;6
       AND    #$03    ;2
       TAX            ;2
       LDA    LF9CE,X ;4
       STA    $00C2,Y ;5
       LDA    LF9D2,X ;4
       STA    $00C3,Y ;5
       DEY            ;2
       DEY            ;2
       BNE    LF82C   ;2
       STY    $82     ;3
LF856: LDA    #$00    ;2
       STA    VBLANK  ;3
       LDA    #$0E    ;2
LF85C: STA    WSYNC   ;3
       STA    VSYNC   ;3
       LSR            ;2
       BNE    LF85C   ;2
       LDA    #$2B    ;2
       STA    TIM64T  ;4
       INC    $80     ;5
       LDA    #$00    ;2
       STA    $83     ;3
       LDA    #$01    ;2
       BIT    SWCHB   ;4
       BNE    LF880   ;2
       LDA    $80     ;3
       BNE    LF87B   ;2
       LDA    #$CF    ;2
LF87B: STA    $81     ;3
       JMP    LF82A   ;3
LF880: LDA    #$0F    ;2
       BIT    $80     ;3
       BNE    LF894   ;2
       INC    $82     ;5
       INC    $82     ;5
       LDA    $82     ;3
       CMP    #$14    ;2
       BCC    LF894   ;2
       LDA    #$00    ;2
       STA    $82     ;3
LF894: LDA    INTIM   ;4
       BNE    LF894   ;2
       STA    WSYNC   ;3
       JSR    LF9AB   ;6
       STA    RESBL   ;3
       STA    WSYNC   ;3
       LDX    #$14    ;2
LF8A4: DEX            ;2
       STA    WSYNC   ;3
       BNE    LF8A4   ;2
       LDX    #$4C    ;2
       LDA    #$01    ;2
       BIT    $80     ;3
       BNE    LF914   ;2
       STA    WSYNC   ;3
LF8B3: NOP            ;2
       NOP            ;2
       NOP            ;2
       CPX    #$4C    ;2
       BEQ    LF8DE   ;2
       STA    RESM0   ;3
       STA    RESM1   ;3
       STA    RESM0   ;3
       STA    RESM1   ;3
       STA    RESM0   ;3
       STA    RESM1   ;3
       STA    RESM0   ;3
       STA    RESM1   ;3
       STA    RESP0   ;3
       STA    RESP1   ;3
       STA    RESP0   ;3
       STA    RESP1   ;3
       STA    RESP0   ;3
       STA    RESP1   ;3
       STA    RESP0   ;3
       STA    RESP1   ;3
       STA    RESP0   ;3
       STA    RESP1   ;3
LF8DE: LDA    ($84),Y ;5
       STA    GRP0    ;3
       LDA    ($86),Y ;5
       STA    GRP1    ;3
       INY            ;2
       CPY    #$04    ;2
       BNE    LF90D   ;2
       LDA    $83     ;3
       CLC            ;2
       ADC    #$02    ;2
       STA    $83     ;3
       ADC    $82     ;3
       TAY            ;2
       LDA    $0088,Y ;4
       STA    $84     ;3
       LDA    $0089,Y ;4
       STA    $85     ;3
       LDA    $83     ;3
       LDA    $00C2,Y ;4
       STA    $86     ;3
       LDA    $00C3,Y ;4
       STA    $87     ;3
       LDY    #$00    ;2
LF90D: DEX            ;2
       STA    WSYNC   ;3
       BNE    LF8B3   ;2
       BEQ    LF97A   ;2
LF914: STA    WSYNC   ;3
LF916: .byte $04 ;.NOP;3
       BRK            ;7
       NOP            ;2
       NOP            ;2
       CPX    #$4C    ;2
       BEQ    LF942   ;2
       STA    RESP0   ;3
       STA    RESP1   ;3
       STA    RESP0   ;3
       STA    RESP1   ;3
       STA    RESP0   ;3
       STA    RESP1   ;3
       STA    RESP0   ;3
       STA    RESP1   ;3
       STA    RESP0   ;3
       STA    RESP1   ;3
       STA    GRP0    ;3
       STA    GRP1    ;3
       STA    RESP0   ;3
       STA    RESP1   ;3
       STA    RESP0   ;3
       STA    RESP1   ;3
       STA    RESP0   ;3
       STA    RESP1   ;3
LF942: LDA    ($84),Y ;5
       STA    GRP0    ;3
       LDA    ($86),Y ;5
       STA    GRP1    ;3
       INY            ;2
       CPY    #$04    ;2
       BNE    LF973   ;2
       LDA    $83     ;3
       CLC            ;2
       ADC    #$02    ;2
       STA    $83     ;3
       ADC    #$00    ;2
       ADC    $82     ;3
       TAY            ;2
       LDA    $00C2,Y ;4
       STA    $86     ;3
       LDA    $00C3,Y ;4
       STA    $87     ;3
       LDA    $83     ;3
       LDA    $0088,Y ;4
       STA    $84     ;3
       LDA    $0089,Y ;4
       STA    $85     ;3
       LDY    #$00    ;2
LF973: LDA    #$00    ;2
       DEX            ;2
       STA    WSYNC   ;3
       BNE    LF916   ;2
LF97A: LDX    #$14    ;2
       LDA    #$01    ;2
       BIT    $80     ;3
       BNE    LF983   ;2
       DEX            ;2
LF983: DEX            ;2
       STA    WSYNC   ;3
       BNE    LF983   ;2
       LDA    #$01    ;2
       BIT    $80     ;3
       BNE    LF999   ;2
       STA    WSYNC   ;3
       LDA    #$42    ;2
       STA    VBLANK  ;3
       LDA    #$24    ;2
       STA    TIM64T  ;4
LF999: LDA    INTIM   ;4
       BNE    LF999   ;2
       JMP    LF856   ;3
LF9A1: LDA    $81     ;3
       ASL            ;2
       BCC    LF9A8   ;2
       EOR    #$CF    ;2
LF9A8: STA    $81     ;3
       RTS            ;6

LF9AB: LDX    #$00    ;2
       ROR    $FC,X   ;6
       ROR    $FC,X   ;6
       ROR    $FC,X   ;6
       ROR    $FC,X   ;6
       ROR    $FC,X   ;6
       ROR    $FC,X   ;6
       ROR    $FC,X   ;6
       ROR    $FC,X   ;6
       RTS            ;6

LF9BE: .byte $88,$44,$22,$11,$18,$24,$42,$81,$11,$22,$44,$88,$81,$42,$24,$18
LF9CE: .byte $BE,$C2,$C6,$CA
LF9D2: .byte $F9,$F9,$F9,$F9,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$00,$F8,$00,$F8,$00,$F8
