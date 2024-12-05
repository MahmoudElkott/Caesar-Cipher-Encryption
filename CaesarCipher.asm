.model small

.data
msg_input db "Enter a 10-character string: $"
msg_key db "Enter Key: $"
msg_shift db 10,13,"Encrypted text: $" 
buffer1 db 10 dup (00)    ; Allocate 10 bytes for buffer1
buffer2 db 10 dup(00), '$' ; Allocate 10 bytes for buffer2
key db 0

.code

caesar macro al, shift
   cmp al, 'z' ; AL > 'z' ?
   ja exit     ; if greater, not a letter, exit
   cmp al, 'A' ; AL < 'A' ?
   jb exit     ; if less, not a letter, exit
   cmp al, 'Z' ; AL = 'Z' ?
   je adjust   ; if equal, go to adjust (AL - 23)
   cmp al, 'z' ; AL = 'z' ?
   je adjust   ; if equal, go to adjust
   cmp al, 'Y' ; AL = 'Y' ?
   je adjust   ; if equal, go to adjust
   cmp al, 'y' ; AL = 'y' ?
   je adjust   ; if equal, go to adjust
   cmp al, 'X' ; AL = 'X' ?
   je adjust   ; if equal, go to adjust
   cmp al, 'x' ; AL = 'x' ?
   je adjust   ; if equal, go to adjust

   ; If the character is not 'X', 'Y', 'Z', 'x', 'y', 'z', add shift
   add al, shift
   jmp exit

   ; If the character is 'X', 'Y', 'Z', 'x', 'y', 'z'
   adjust:
   add al, shift
   sub al, 26
   jmp exit

   exit:
   endm           

   mov ax, @data
   mov ds, ax      ; Initialize data segment
   lea si, buffer1 ; Load address of buffer1 into SI
   lea di, buffer2 ; Load address of buffer2 into DI

   ; Display "Enter a 10-character string: " message
   mov ah, 09h
   lea dx, msg_input
   int 21h
   
   mov cx, 0010  ; Set counter to 10

   ; Read 10 characters from the keyboard
   input: 
   mov ah, 01h
   int 21h                                                                                                                                                         
   mov [si], al      ; Store each character in buffer1
   inc si 
   loop input                      

   ; Display "Enter Key: " message
   mov ah, 09h
   lea dx, msg_key
   int 21h

   ; Read the shift key from the keyboard
   mov ah, 01h
   int 21h
   sub al, '0'       ; Convert ASCII to integer
   mov [key], al

   mov dx, 0000
   mov cx, 0010  ; Reset counter to 10
   lea si, buffer1

   ; Encrypt each character in buffer1 using Caesar cipher
   ; Store encrypted characters in buffer2   
   encrypt: mov al, [si] 
   mov bl, [key]
   caesar al, bl      
   mov [di], al
   inc si  
   inc di
   loop encrypt

   ; Display "Encrypted text: " message
   mov ah, 09h 
   lea dx, msg_shift
   int 21h 
    
   ; Display the encrypted string (buffer2)
   mov ah, 09h
   lea dx, buffer2
   int 21h   
       
   ; Exit
   mov ah, 4ch
   int 21h 
   end
