       ;-----------------------------
       ;Title   :PIC 16F1823 PROGRAM
       ;FileName:pic_led1.asm
       ;Author  :B. Green
       ;-----------------------------
       ;Version  0.000  Jan 05, 2014     Demo for PIC Class,  Flash LED on RA5
       ;


       ;------------------------------------------------------------
       ; 16F1823 Features available
       ; 1.8-5.5 Vdd (2.5V min above 16Mhz),
       ; 32MHz max 8Mhz default ( 500ns instruction cycle )
       ; 2K Words Program FLASH
       ; 256 8 bit Data memory,  Self write flash
       ; 128 8 bit Registers
       ; 16 level stack
       ; Has internal
       ;      POR, BOR, PWRT, MCLR, TMR0,TMR1,TMR2, OSC 0.031-32M, NCO
       ;      ADC 10 bit (8 chan), CWG, 10 bit PWM (2), 5 bit DAC
       ;      CLC (config Logic Block with S/R Latch),  MSSP, EUSART
       ;      Extended WTD 1ms < WDT < 256 sec
       ; RETURN, RETLW, RETFIE
       ;
       ;  EEProm is at 00 to FF but is allocated to 1E000h-1E1FFh in the hex file
       ;
       ;-----------------------------


       ; Pin connections used
       ; pin | name                | PgmHdr |  connection
       ;----- --------------------- -------- ----------------
       ;  1  | VDD                 |     2  |  +5V
       ;  2  | RA5                 |        |  LED+ (&1K to gnd)
       ;  3  | RA4                 |        |
       ;  4  | VPP / MCLRn / RA3   |     1  |  Pgm Hdr pin 1
       ;  5  | RC5                 |        |
       ;  6  | RC4                 |        |
       ;  7  | RC3                 |        |

       ;  8  | RC2                 |        |
       ;  9  | RC1                 |        |
       ; 10  | RC0                 |        |
       ; 11  | RA2                 |        |
       ; 12  | RA1 / ICSPCLK       |     5  |
       ; 13  | RA0 / ICSPDAT       |     4  |
       ; 14  | VSS                 |     3  |  Gnd



       list      p=16f1823, r=dec

       #include <p16f1823.inc>


    ;  Assembler Directives for Program and configuration options
    __CONFIG _CONFIG1, _FOSC_INTOSC & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _CP_OFF & _CPD_OFF & _BOREN_OFF & _CLKOUTEN_OFF & _IESO_OFF & _FCMEN_OFF
    __CONFIG _CONFIG2, _WRT_OFF & _PLLEN_ON & _STVREN_OFF & _LVP_OFF



;   ----------------------------------------
;  -----    Variables and Defines     -------
;   ----------------------------------------


LED0            EQU  RA5



       ;----- GPIO Bits --------------------------------------------------------


       ;  ------------------------------------
       ; ----   General purpose Registars  ----
       ; ----   16F1823  20h - 6Fh         ----
       ;  ------------------------------------

       cblock  0x20                    ; 12F1822/16F1823 register space starts at 0x20.

       loopd500ns                      ; delay loop variables 500ns inner loop
       loopd100us                      ; delay loop variables 100us loop
       loopd1ms                        ; delay loop variables 1ms loop

       endc




       ;  ------------------------------------
       ; ----         Commom RAM           ----
       ; ----      12F1822  70h - 7Fh      ----
       ;  ------------------------------------

       cblock        0x70                    ; 12F1822/16F1822 common ram space starts at 0x70


       endc





       ;  ------------------------------
       ; ----   Start of code block  ----
       ;  ------------------------------

       ORG     0x00               ;  At POR all pins are inputs
       goto    Start              ;        (reset vector)

       ORG     0x04               ; Interrupt routine

       retfie


;   ----------------------------------------
;  -----          Subroutines         -------
;   ----------------------------------------


    ;   ----------------------------------------
    ;  -----          1S delay            -------
    ;   ----------------------------------------
WAIT_1S
       call    WAIT_250MS
       call    WAIT_250MS
       call    WAIT_250MS
       call    WAIT_250MS
       retlw   d'0'

    ;   ----------------------------------------
    ;  -----          250ms delay         -------
    ;   ----------------------------------------
WAIT_250MS
       movlw   d'250'                  ; 251.251 ms
       goto    WAIT_W_MS

    ;   ----------------------------------------
    ;  -----          200ms delay         -------
    ;   ----------------------------------------
WAIT_200MS
       movlw   d'200'                  ; 251.251 ms
       goto    WAIT_W_MS

    ;   ----------------------------------------
    ;  -----          100ms delay         -------
    ;   ----------------------------------------
WAIT_100MS
       movlw   d'100'                  ; ~ 100.501 ms
       goto    WAIT_W_MS

    ;   ----------------------------------------
    ;  -----          50ms delay          -------
    ;   ----------------------------------------
WAIT_50MS
       movlw   d'50'                   ; ~ 50.251 ms
       goto    WAIT_W_MS

    ;   ----------------------------------------
    ;  -----          30ms delay          -------
    ;   ----------------------------------------
WAIT_30MS
       movlw   d'30'                   ; ~ 50.251 ms
       goto    WAIT_W_MS

    ;   ----------------------------------------
    ;  -----          20ms delay          -------
    ;   ----------------------------------------
WAIT_20MS
       movlw   d'20'                   ;
       goto    WAIT_W_MS

    ;   ----------------------------------------
    ;  -----          10ms delay          -------
    ;   ----------------------------------------
WAIT_10MS
       movlw   d'10'                   ;
       goto    WAIT_W_MS

    ;   ----------------------------------------
    ;  -----          4ms delay           -------
    ;   ----------------------------------------
WAIT_4MS
       movlw   d'4'                    ;
       goto    WAIT_W_MS

    ;   ----------------------------------------
    ;  -----          2ms delay           -------
    ;   ----------------------------------------
WAIT_2MS
       movlw   d'2'                    ;
       goto    WAIT_W_MS

    ;   ----------------------------------------
    ;  -----          1ms delay           -------
    ;   ----------------------------------------
WAIT_1MS
       movlw   d'1'                    ; ~ 1.006 ms
       goto    WAIT_W_MS


    ;   ----------------------------------------
    ;  -----          w ms delay          -------
    ;   ----------------------------------------
    ;
WAIT_W_MS

       ; aprox delay = (w * 1ms) + (w * 5us) + 1us
       movwf   loopd1ms                ; 0.125us
w_1ms
       movlw   d'10'                   ; 0.125us
       movwf   loopd100us              ; 0.125us
w_100us
       ; inner loop 0.5us * 200 + 0.250us = 0.100ms
       movlw   d'200'                  ; 0.125us
       movwf   loopd500ns              ; 0.125us
w_500ns                                ; next 3 instructions = 0,500us loop
       nop                             ; 0.125us
       decfsz  loopd500ns, F           ; 0.125us (0.250us if skip)
       goto    w_500ns                 ; 0.250us

       decfsz  loopd100us, F           ; 0.1250us (0.250us if skip)
       goto    w_100us                 ; 0.250us

       decfsz  loopd1ms, F             ; 0.1250us (0.250us if skip)
       goto    w_1ms                   ; 0.250us
       retlw   d'0'




       ;   -------------------------------------------------------------
       ; -------------       Start of Main Section   ---------------------
       ;   -------------------------------------------------------------

Start
       ;  Set the oscillator to 32MHz and wait for it to start.  (must enable_PLLEN_ON in config bits)
       BANKSEL OSCCON
       movlw   B'11110000'             ; Set OSCAL to 32 Mhz
       movwf   OSCCON

       BANKSEL OSCSTAT
WaitOsc
       btfss   OSCSTAT, HFIOFL
       goto    WaitOsc


       ; Clear all the ports at startup
       BANKSEL PORTA                   ;
       CLRF    PORTA                   ; Init PORTA

       BANKSEL LATA                    ; Data Latch
       CLRF    LATA                    ;

       BANKSEL ANSELA                  ;
       CLRF    ANSELA                  ; digital I/O

       BANKSEL PORTC                   ;
       CLRF    PORTC                   ; Init PORTC

       BANKSEL LATC                    ; Data Latch
       CLRF    LATC                    ;

       BANKSEL ANSELC                  ;
       CLRF    ANSELC                  ; digital I/O



       BANKSEL TRISC                   ;
       ;Set RC<5:0> as inputs  (0=driver enabled)
       MOVLW   b'00111111'             ;
                ;00------              ;  reserved
                ;--1-----              ;  TRISC5
                ;---1----              ;  TRISC4
                ;----1---              ;  TRISC3
                ;-----1--              ;  TRISC2     I2C
                ;------1-              ;  TRISC1     I2C
                ;-------1              ;  TRISC0
       MOVWF TRISC

       BANKSEL TRISA                   ;
       ;Set RA5 as output and set RA<4:0> as inputs  (0=driver enabled)
       MOVLW   b'00011111'             ;
                ;00------              ;  reserved
                ;--0-----              ;  TRISA5
                ;---1----              ;  TRISA4
                ;----1---              ;  TRISA3
                ;-----1--              ;  TRISA2
                ;------1-              ;  TRISA1
                ;-------1              ;  TRISA0
       MOVWF TRISA


main_loop
       BANKSEL PORTA                   ;

       BSF     PORTA,LED0
       call    WAIT_200MS

       BCF     PORTA,LED0
       call    WAIT_200MS

       goto    main_loop



       ; -------------------------------
       ;   EEProm location 1E000h-1E0FFh
       ; -------------------------------
       ; Table: EEPROM Start Address by Device
       ; Device           asmbler Address
       ; ---------------  ---------------  --------
       ; Most PIC1X MCUs  0x2100
       ; PIC18 MCUs       0xF00000
       ; PIC16F19XX MCUs  0xF000

       ORG     0xF000            ;  hex file location (hex file addresses are double



       END
