INCLUDE 'EMU8086.INC'
.MODEL SMALL
.STACK 100H              

.DATA
    THRESHOLD DW 50       
    VAR1 DW ?             
    CEL DW ?           
    MESSAGE_PRINT DB "SELECT TEMPERATURE UNIT: PRESS (C) FOR CELSIUS OR (F) FOR FAHRENHEIT: $"
    MESSAGE_ERROR DB "ERROR: INVALID CHOICE. PLEASE TRY AGAIN. $"
    ENTER_CELSIUS DB "ENTER THE TEMPERATURE IN CELSIUS: $"
    ENTER_FAHRENHEIT DB "ENTER THE TEMPERATURE IN FAHRENHEIT: $"
    MESSAGE_GREEN DB "STATUS: TEMPERATURE IS BELOW THRESHOLD.GREEN LED IS ON. $"
    MESSAGE_YELLOW DB "STATUS: TEMPERATURE IS EQUAL TO THRESHOLD.YELLOW LED IS ON. $"
    MESSAGE_RED DB "STATUS: TEMPERATURE IS ABOVE THRESHOLD.RED LED AND BUZZER ARE ON! $"
    MESSAGE_BLUE DB "STATUS: TEMPERATURE IS TOO LOW.BLUE LED IS ON. $"
    MESSAGE_CONTINUE DB "DO YOU WANT TO CONTINUE USING THE APP OR NOT: PRESS (Y) FOR YES OR (N) FOR NOT: $"
    CONVERTED_CELSIUS DB "CONVERTED TEMPERATURE (CELSIUS): $" 
    MESSAGE_THANKS DB "THANK YOU FOR USING THE HEATER ALARM SYSTEM.PROGRAM TERMINATED SUCCESSFULLY. $"
    NEWLINE DB 0AH, 0DH, '$'  

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    PRINT "==================================WELCOME TO THE HEATER ALARM SYSTEM==============================="
    
    
    START:   
    CALL PRINT_NEWLINE
    
    LEA DX,MESSAGE_PRINT
    MOV AH,09H
    INT 21H 
    
    MOV AH, 01H
    INT 21H
    MOV BL, AL              ; Store input character in BL
           
    AND AL, 0DFH            ; Clear bit 5 to convert to uppercase ('a'-'z' -> 'A'-'Z')
    
    CMP AL, 'C'       
    JE CELSIUS
    CMP AL, 'F'       
    JE FAHRENHEIT


    CALL PRINT_NEWLINE
    
    LEA DX,MESSAGE_ERROR
    MOV AH,09H
    INT 21H
     
    LEA DX, NEWLINE
    MOV AH, 9H
    INT 21H 
    JMP START

CELSIUS:
    CALL PRINT_NEWLINE

    LEA DX,ENTER_CELSIUS
    MOV AH,09H
    INT 21H 
    
    CALL SCAN_NUM
    MOV VAR1, CX
  
              
    MOV AX, VAR1
    MOV CEL, AX 
             
    JMP COMPARE_TEMP

FAHRENHEIT:
    CALL PRINT_NEWLINE  

    LEA DX,ENTER_FAHRENHEIT
    MOV AH,09H
    INT 21H
    
    CALL SCAN_NUM
    MOV VAR1, CX          
    
    CALL FAHRENHEIT_C          
  
    CALL PRINT_NEWLINE 
    
    LEA DX,CONVERTED_CELSIUS
    MOV AH,09H
    INT 21H
    MOV AX, CEL
    CALL PRINT_NUM
    
    JMP COMPARE_TEMP

COMPARE_TEMP: 
    
    MOV AX,CEL
   
    CMP AX,15
    JL BLUE_LED   
    CMP AX, THRESHOLD    
    JL GREEN_LED
    JE YELLOW_LED
    JMP RED_LED
                
BLUE_LED:  

    CALL PRINT_NEWLINE
    
    MOV CX, 46            
    MOV AX, 0920H         
    MOV BH, 0             
    MOV BL, 01H           
    MOV DL, 0             
    MOV DH, 10            
    INT 10H                 
     
    LEA DX,MESSAGE_BLUE
    MOV AH,09H
    INT 21H
    JMP RESTART

GREEN_LED:
    CALL PRINT_NEWLINE
    
     ; Set text color to green
    MOV CX, 56              ; Length of the line (adjust as needed)
    MOV AX, 0920H           
    MOV BH, 0              
    MOV BL, 02H             ; Green attribute
    MOV DL, 0             
    MOV DH, 10             
    INT 10H                 ; BIOS write character and attribute 

    LEA DX,MESSAGE_GREEN
    MOV AH,09H
    INT 21H
     
    JMP RESTART

YELLOW_LED:
    CALL PRINT_NEWLINE 
    
      ; Set text color to yellow
    MOV CX, 59              ; Length of the line (adjust as needed)
    MOV AX, 0920H          
    MOV BH, 0               
    MOV BL, 0EH             ; yellow attribute
    MOV DL, 0               
    MOV DH, 10             
    INT 10H                 ; BIOS write character and attribute 

    LEA DX,MESSAGE_YELLOW
    MOV AH,09H
    INT 21H
    
    JMP RESTART

RED_LED:
    CALL PRINT_NEWLINE  
    
      ; Set text color to Red
    MOV CX, 65              ; Length of the line (adjust as needed)
    MOV AX, 0920H           
    MOV BH, 0               
    MOV BL, 04H             ; red attribute
    MOV DL, 0              
    MOV DH, 10             
    INT 10H                 ; BIOS write character and attribute  
    
    LEA DX,MESSAGE_RED
    MOV AH,09H
    INT 21H
    
    ; Beep sound
    MOV AL, 07H           ; ASCII Bell character (BEL)
    MOV AH, 0EH           ; BIOS teletype function
    INT 10H               ; BIOS interrupt  
    JMP RESTART
    
RESTART:
    CALL PRINT_NEWLINE   
  
    LEA DX,MESSAGE_CONTINUE
    MOV AH,09H
    INT 21H 
    MOV AH, 01H
    INT 21H
            
    ; Convert to uppercase
    AND AL, 0DFH            ; Convert to uppercase ('a'-'z' -> 'A'-'Z')
    
    CMP AL, 'Y'       
    JE START         
    CMP AL, 'N'       
    JE END_PROGRAM     

    CALL PRINT_NEWLINE
    
    LEA DX,MESSAGE_ERROR
    MOV AH,09H
    INT 21H 
    JMP RESTART        

END_PROGRAM:
    CALL PRINT_NEWLINE
    
    PRINT ""
    
    CALL PRINT_NEWLINE
    
    LEA DX,MESSAGE_THANKS
    MOV AH,09H
    INT 21H
    MOV AH, 4CH
    INT 21H

MAIN ENDP

            
PRINT_NEWLINE PROC        
    LEA DX, NEWLINE
    MOV AH, 9H
    INT 21H
    RET
PRINT_NEWLINE ENDP  

FAHRENHEIT_C PROC 
    ; Convert F to C: C = (F - 32) * 5 / 9
    MOV AX, VAR1          
    SUB AX, 32            
    MOV BX, 5             
    IMUL BX
    MOV BX, 9             
    IDIV BX
    MOV CEL, AX 
    RET
FAHRENHEIT_C ENDP
DEFINE_SCAN_NUM
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS
END MAIN