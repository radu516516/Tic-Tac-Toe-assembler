.model small
.stack 100h
.data

    msgwin db ' a castigat','$'
    
    msgegal db ' egalitate','$'

	harta db '1'  ; harta[0]
	      db '2'  ; harta[1]
	      db '3'  ; harta[2]
	      db '4'  ; harta[3]
	      db '5'  ; harta[4]
	      db '6'  ; harta[5]
	      db '7'  ; harta[6]
	      db '8'  ; harta[7]
	      db '9'  ; harta[8]
	      
	      
	jucator db 'O'
	
	
	ok db 0
	
;###########################################################################################################################################
.code
	mov ax, data
	mov ds, ax

	mov jucator, 'O'; 	                               ;initializare player; player incepe de la 2 pt ca 'X' sa fie primul
	mov cx, 9                                          ;cx = nr maxim de repetari while
	
	 
	repeta:
	
	;{
        call cls
		call afisareharta
		
		                     ; la prima rulare player e 1
		mov al, jucator       ; vedem ce jucator isi face miscarea
		cmp al, 'X'            ; vedem daca e randul primului jucator
		 
		 
		je schimba           ;if ( player == 1) schimbam in player= 2 ,daca player ==2 schimba player 1  
			
			mov jucator, 'X'    ; ( player == 2) jucatorul de dinainte a fost player 2
			jmp saripeste
		schimba:             ; ( player == 1) jucatorul de dinainte a fost player 1 
			mov jucator ,'O'    ;  daca player e 1 schimba in 2	
		saripeste:           ; sari peste e folosit cand schimbam jucatorul in player 1 ca sa nu il schimbam dinou in player 2 la eticheta player2: trebuie sa sarim peste ea
		
		
		
		
		call citirepozitie   ;  dupa executie bx pointeaza la pozitia de inserare
		mov dl, jucator       ;  vedem ce inseram X sau O
		cmp dl, 'X'
		jne zero             ;  daca dl !=1 scriem 0 else scriem X
		mov dl, 'X'
		jmp insereaza
		zero:
		mov dl, 'O'
		insereaza:
		mov [bx], dl         ; pune dl la pozitia bx din harta
	    
	    mov dl,jucator
		call verificare       ; verifica daca cineva a castigat iar daca a castigat iese din loop
		e1:
		
		loop repeta
	;}	
	
	 ;daca iese din while -> ca e egalitate
	 egal:
     call cls
	 mov ah,9h
	 mov dx,offset msgegal
	 int 21h
	 jmp end
	 castiga:
	 
	   call cls
	   mov ah,02h
	   mov dl,jucator
	   int 21h
	   
	   mov ah,9h
	   mov dx,offset msgwin
	   int 21h	 
	end:
	mov ax, 4ch
	int 21h
	
;############################################################################################################################	

cls:
	mov ah, 0fh
	int 10h
	mov ah, 0
	int 10h
	ret
;############################################################################################################################	
citirepozitie:
	                
	mov ah,01              ; citim o pozitie,pozitia e in al;un character;hexazecimal
	int 21h
		                   ;Verificare 1
    mov ok,0               ;ok e 0, daca ok = 1 inseamna ca e cifra intre 1 si 9
	cmp al,'1'             ;comparam nr citit cu 1
	jl sari                ;daca e mai mic decat 1 sarim deci ah nu se face 1 deci nu e bun
	cmp al,'9'             ;jump if less, jump if greater
	jg sari                ;daca e mai mare decat 9 sarim deci nu e bun
	mov ok,1
	sari:
	
	cmp ok, 1              ;vedem daca al,pozitia citita e intre 1 si 9 adica daca ok e 1
	je  continuare         ;  sare if ( ok == 1)	                      ;  else ok == 0 trebuie sa citim dinou o pozitie care sa fie intre 1 si 9
	jmp citirepozitie      ; citeste o pozitie noua pana cand e >=1 <=9
	
	continuare:            ; verifica daca caracterul de pe pozitia noastra are codul ascii mai mare decat '9' ADICA daca este x sau O(litera)
	mov bx,offset harta    ; bx pointeaza la harta	
	sub al, '1'            ; de la tastatura citiim nr intre 1 si 9 in vector se insereaza de la harta[0]...harta[8]
	mov ah, 0              ; sub al,'1' transforma nr hexazecimal in numar zecimal cu o unitate mai mica pt ca utilizatoru baga un nr cu o onitate mai mare, ex cand baga 9 noi inseram pe poz 8 iar 9 e 39 hexazecimal si nu putem pune harta[39] de exemplu
	add bx, ax             ; ah se face 0 deci tot ax acuma e numai pozitia pe care trebuie sa inseram iar bx pointeaza la acea pozitie din harta
	mov al, [bx]           ; al e pozitia iar harta[bx] e locul unde punem
	cmp al, '9'            ; al primeste valoarea la care pointeaza bx din harta,care poate fi un numar sau x sau O 
	jng terminaremiscare   ; verifica daca aceasta valoare e mai mare decat '9' adica e x sau O
	jmp citirepozitie
	terminaremiscare:      ; daca al nu e x sau O am terminat si o sa inseram la harta[bx] x sau O in functie de jucator
	ret
	
;################################################################################################################################
afisareharta:

	mov bx,offset harta      ;bx -> primu element din vector
	
	mov ah,02h              ;space
	mov dl,' '
    int 21h
	
    mov ah, 02h             ;valoarea afisata se afla in dl                
	mov dl,[bx]
	int 21h                 ;harta[0]
	add bx,1
	
	mov ah,02h              ;space
	mov dl,' '
	int 21h
	
	mov ah, 02h             ;harta[1]
	mov dl,[bx]
	int 21h 
	add bx,1
	
	mov ah,02h              ;space
	mov dl,' '
	int 21h
	
	mov ah,02h              ;harta[2]
	mov dl,[bx]
	int 21h 
	add bx,1
	
	mov ah,02h              ;space
	mov dl,' '
	int 21h
	
	mov ah,02h              ;enterx2
	mov dl,0dh
	int 21h
	
	mov ah,02h              
	mov dl,0ah
	int 21h
	
	mov ah,02h              
	mov dl,0dh
	int 21h
	
	mov ah,02h              
	mov dl,0ah
	int 21h
	
	mov ah,02h              ;space
	mov dl,' '
    int 21h
			
	mov ah,02h              ;harta[3]
	mov dl,[bx]
	int 21h
	add bx,1
	
	mov ah,02h              ;space
	mov dl,' '
	int 21h
	
	mov ah,02h              ;harta[4]
	mov dl,[bx]
	int 21h
	add bx,1
	
	mov ah,02h              ;space
	mov dl,' '
	int 21h
	
	mov ah,02h              ;harta[5]
	mov dl,[bx]
	int 21h
	add bx,1
	
	mov ah,02h              ;space
	mov dl,' '
	int 21h
	
	mov ah,02h              ;enter
	mov dl,0dh
	int 21h
	
	mov ah,02h              
	mov dl,0ah
	int 21h
	
	mov ah,02h              ;enter
	mov dl,0dh
	int 21h
	
	mov ah,02h              
	mov dl,0ah
	int 21h
	
	mov ah,02h              ;space
	mov dl,' '
    int 21h 
	
	mov ah,02h              ;harta[6]
	mov dl,[bx]
	int 21h
	add bx,1
	
	mov ah,02h              ;space
	mov dl,' '
	int 21h
	
	mov ah,02h              ;harta[7]
	mov dl,[bx]
	int 21h
	add bx,1
	
	mov ah,02h              ;space
	mov dl,' '
	int 21h
	
	mov ah,02h              ;harta[8]
	mov dl,[bx]
	int 21h 
	add bx,1
	
	mov ah,02h              ;enter
	mov dl,0dh
	int 21h
	
	mov ah,02h              
	mov dl,0ah
	int 21h
		
	ret
;###############################################################################################################################

verificare:   ;dl e x sau 0
   
   rand1:
   mov bx,offset harta       ;bx = 0 1 2
   mov al,0
   cmp [bx],dl
   jne rand2
   inc al
   inc bx
   cmp [bx],dl
   jne rand2
   inc al
   inc bx
   cmp [bx],dl
   jne rand2
   inc al
   cmp al,3
   je win
   
   rand2:
   mov bx,offset harta       ;bx = 3 4 5
   mov al,0
   add bx,3
   cmp [bx],dl
   jne rand3
   inc al
   inc bx
   cmp [bx],dl
   jne rand3
   inc al
   inc bx
   cmp [bx],dl
   jne rand3
   inc al
   cmp al,3
   je win
                         ;bx = 6 7 8
   rand3:
   mov bx,offset harta
   mov al,0
   add bx,6
   cmp [bx],dl
   jne col1
   inc al
   cmp [bx],dl
   jne col1
   inc al
   inc bx
   cmp [bx],dl
   jne col1
   inc al
   cmp al,3
   je win
   
   col1:
   mov bx,offset harta          ;bx = 0 3 6
   mov al,0
   cmp [bx],dl
   jne col2
   inc al
   add bx,3
   cmp [bx],dl
   jne col2
   inc al
   add bx,3
   cmp [bx],dl
   jne col2
   inc al
   cmp al,3
   je win
                           ; bx = 1 4 7
   col2:
   mov bx,offset harta
   mov al,0
   inc bx
   cmp [bx],dl
   jne col3
   inc al
   add bx,3
   cmp [bx],dl
   jne col3
   inc al
   add bx,3
   cmp [bx],dl
   jne col3
   inc al
   cmp al,3
   je win
   
   col3:                   ;bx = 2 5 8
   mov bx,offset harta
   mov al,0
   add bx,2
   cmp [bx],dl
   jne diag1
   inc al
   add bx,3
   cmp [bx],dl
   jne diag1
   inc al
   add bx,3
   cmp [bx],dl
   jne diag1
   inc al
   cmp al,3
   je win
   
   diag1:                ;bx = 0 4 8                
   mov bx,offset harta
   mov al,0
   cmp [bx],dl
   jne diag2
   inc al
   add bx,4
   cmp [bx],dl
   jne diag2
   inc al
   add bx,4
   cmp [bx],dl
   jne diag2
   inc al
   cmp al,3
   je win
   
   
   diag2:                ;bx = 2,4,6
   mov bx,offset harta
   mov al,0
   add bx,2
   cmp [bx],dl
   jne nimeni_nu_castiga
   inc al
   add bx,2
   cmp [bx],dl
   jne nimeni_nu_castiga
   inc al
   add bx,2
   cmp [bx],dl
   jne nimeni_nu_castiga
   inc al
   cmp al,3
   je win
   
   nimeni_nu_castiga:
   jmp e1   
   ;daca s-a ajuns aici inseamna ca nu a sarit la win deci nu a castigat nimeni
   
   win:
    jmp castiga
    
    ret


	
