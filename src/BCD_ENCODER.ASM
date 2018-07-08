;-----------------------------------------------
;
;     BCD ENCODER
;
;     Author: Austin Atteberry
;     Description: A simple active-low BCD
;                  encoder for the PIC16F628A
;
;-----------------------------------------------

#header
                  errorlevel -216
                  errorlevel -302
                  errorlevel -303
#endheader

;-----------------------------------------------
;     CONFIGURATION
;-----------------------------------------------
                  list              p=16f628a
                  radix             dec
                  #include          "p16f628a.inc"
                  __config          _FOSC_INTOSCIO & _WDT_OFF & _PWRTE_OFF & _MCLRE_OFF & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF

;-----------------------------------------------
;     CODE
;-----------------------------------------------
                  org               0x0000
                  goto              INIT_PORTA

                  org               0x0010

INIT_PORTA:       clrf              PORTA             ; Clear PORTA
                  movlw             0x0007            ; Move 0b00000111 to ACC
                  movwf             CMCON             ; Disable CMCON
                  bcf               STATUS, RP1       ; Clear RP1
                  bsf               STATUS, RP0       ; Set RP0
                  movlw             0x00FF            ; Move 0b11111111 to ACC
                  movwf             TRISA             ; Set PORTA as input
                  bcf               STATUS, RP0       ; Clear RP0
                  goto              INIT_PORTB

                  org               0x0020

INIT_PORTB:       clrf              PORTB             ; Clear PORTB
                  bsf               STATUS, RP0       ; Set RP0
                  movlw             0x0000            ; Move 0b00000000 to ACC
                  movwf             TRISB             ; Set PORTB as output
                  bcf               STATUS, RP0       ; Clear RP0
                  movlw             0x00FF            ; Move 0b11111111 to ACC
                  movwf             PORTB             ; Set PORTB high
                  goto              START

                  org               0x0030

START:            btfss             PORTA, 3          ; Check A.3 bit
                  goto              FOUR_DIG          ; A.3 bit active (low)
                  btfss             PORTA, 2          ; Check A.2 bit
                  goto              THREE_DIG         ; A.2 bit active (low)
                  btfss             PORTA, 1          ; Check A.1 bit
                  goto              TWO_DIG           ; A.1 bit active (low)
                  btfss             PORTA, 0          ; Check A.0 bit
                  goto              DISP_ONE          ; A.0 bit active (low)
                  goto              DISP_ZERO

FOUR_DIG          btfss             PORTA, 2          ; Check A.2 bit
                  goto              DISP_OFF          ; A.2 bit active (low)
                  btfss             PORTA, 1          ; Check A.1 bit
                  goto              DISP_OFF          ; A.1 bit active (low)
                  btfss             PORTA, 0          ; Check A.0 bit
                  goto              DISP_NINE         ; A.0 bit active (low)
                  goto              DISP_EIGHT

THREE_DIG         btfss             PORTA, 1          ; Check A.1 bit
                  goto              THREE_DIG_1       ; A.1 bit active (low)
                  btfss             PORTA, 0          ; Check A.0 bit
                  goto              DISP_FIVE         ; A.0 bit active (low)
                  goto              DISP_FOUR

THREE_DIG_1       btfss             PORTA, 0          ; Check A.0 bit
                  goto              DISP_SEVEN        ; A.0 bit active (low)
                  goto              DISP_SIX

TWO_DIG           btfss             PORTA, 0          ; Check A.0 bit
                  goto              DISP_THREE        ; A.0 bit active (low)
                  goto              DISP_TWO

DISP_ZERO         movlw             0x0081            ; Move 0b10000001 to ACC
                  movwf             PORTB             ; Move ACC to PORTB
                  goto              START

DISP_ONE          movlw             0x00CF            ; Move 0b11001111 to ACC
                  movwf             PORTB             ; Move ACC to PORTB
                  goto              START

DISP_TWO          movlw             0x0092            ; Move 0b10010010 to ACC
                  movwf             PORTB             ; Move ACC to PORTB
                  goto              START

DISP_THREE        movlw             0x0086            ; Move 0b10000110 to ACC
                  movwf             PORTB             ; Move ACC to PORTB
                  goto              START

DISP_FOUR         movlw             0x00CC            ; Move 0b11001100 to ACC
                  movwf             PORTB             ; Move ACC to PORTB
                  goto              START

DISP_FIVE         movlw             0x00A4            ; Move 0b10100100 to ACC
                  movwf             PORTB             ; Move ACC to PORTB
                  goto              START

DISP_SIX          movlw             0x00A0            ; Move 0b10100000 to ACC
                  movwf             PORTB             ; Move ACC to PORTB
                  goto              START

DISP_SEVEN        movlw             0x008F            ; Move 0b10001111 to ACC
                  movwf             PORTB             ; Move ACC to PORTB
                  goto              START

DISP_EIGHT        movlw             0x0080            ; Move 0b10000000 to ACC
                  movwf             PORTB             ; Move ACC to PORTB
                  goto              START

DISP_NINE         movlw             0x008C            ; Move 0b10001100 to ACC
                  movwf             PORTB             ; Move ACC to PORTB
                  goto              START

DISP_OFF          movlw             0x00FF            ; Move 0b11111111 to ACC
                  movwf             PORTB             ; Move ACC to PORTB
                  goto              START

                  end