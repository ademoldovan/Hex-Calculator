.386
.model flat,stdcall

includelib msvcrt.lib
extern exit: proc
extern printf: proc
extern scanf: proc

public start

.data
text1 db "Rezultatul expresiei este:",0
text db "Introduceti o expresie:",13,10,0
ex db 100 dup(0)				;sirul in care pun expresia
lgexpresie dd 0				;lungimea expresiei introduse
format db "%s",0			;formatul cu care citesc sirul
sirn dd 100 dup(0)			;sir in care pun numerele din expresie
sirc dd 100 dup(0)			;sir in care pun caracterele din expresie
nrsirc dd 0					;numarul de operatori din expresie
nrsirn dd 0					;numarul de operanzi din expresie
format1 db "%x",0			
format2 db "%s %x",0
format3 db "%c",0
a dd 0						;a,b,ce,d,var,a1,b1,rez- variabile pe care le folosesc pe parcursul proiectului
b dd 0
ce dd 0
d dd 0
var dd 0
rez dd 0
a1 dd 0
b1 dd 0
variab db 13,10,0
ok dd 0
.code
	;functiile pentru adunare,scadere,inmultire,impartire
	adunare proc
	push EBP
	mov EBP,ESP
	add EAX,EBX
	mov ESP,EBP
	pop EBP
	ret
	adunare endp
	
	
	scadere proc
	push EBP
	mov EBP,ESP
	sub EAX,EBX
	mov ESP,EBP
	pop EBP
	ret
	scadere endp
	
	
	inmultire proc
	push EBP
	mov EBP,ESP
	mul EBX
	mov ESP,EBP
	pop EBP
	ret
	inmultire endp
	
	
	impartire proc
	push EBP
	mov EBP,ESP
	xor EDX,EDX
	div EBX
	mov ESP,EBP
	pop EBP
	ret
	impartire endp
	
	;caut caracterele 0,1,2,... si cand le gasesc in locul lor pun cifra 0,1,2...
	cautare_caracter proc
	push EBP
	mov EBP,ESP
	cmp EAX,'0'
	je zero
	cmp EAX,'1'
	je unu
	cmp EAX,'2'
	je doi
	cmp EAX,'3'
	je trei
	cmp EAX,'4'
	je patru
	cmp EAX,'5'
	je cinci
	cmp EAX,'6'
	je sase
	cmp EAX,'7'
	je sapte
	cmp EAX,'8'
	je opt
	cmp EAX, '9'
	je noua
	cmp EAX,'A'
	je zece
	cmp EAX,'B'
	je unsprezece
	cmp EAX,'C'
	je doisprezece
	cmp EAX,'D'
	je treisprezece
	cmp EAX,'E'
	je paisprezece
	cmp EAX,'F'
	je cinsprezece
	cmp EAX,'a'
	je zece1
	cmp EAX,'b'
	je unsprezece1
	cmp EAX,'c'
	je doisprezece1
	cmp EAX,'d'
	je treisprezece1
	cmp EAX,'e'
	je paisprezece1
	cmp EAX,'f'
	je cinsprezece1
	jmp lol
	
	zero: mov EAX,0								;in EAX in locul caracterului '0' vom pune cifra zero
	jmp lol										;asa vom proceda pentru fiecare caracter
	unu: mov EAX,1
	jmp lol										;daca am gasit caracterul vom sari la finalul etichetelor 
	doi: mov EAX,2
	jmp lol
	trei: mov EAX,3
	jmp lol
	patru: mov EAX,4
	jmp lol
	cinci: mov EAX,5
	jmp lol
	sase: mov EAX,6
	jmp lol
	sapte: mov EAX,7
	jmp lol
	opt: mov EAX,8
	jmp lol
	noua: mov EAX,9
	jmp lol
	zece: mov EAX,0Ah
	jmp lol
	unsprezece: mov EAX,0Bh
	jmp lol
	doisprezece: mov EAX,0ch
	jmp lol
	treisprezece: mov EAX,0dh
	jmp lol
	paisprezece: mov EAX,0eh
	jmp lol
	cinsprezece: mov EAX,0fh
	jmp lol
	zece1: mov EAX,0Ah
	jmp lol
	unsprezece1: mov EAX,0Bh
	jmp lol
	doisprezece1: mov EAX,0ch
	jmp lol
	treisprezece1: mov EAX,0dh
	jmp lol
	paisprezece1: mov EAX,0eh
	jmp lol
	cinsprezece1: mov EAX,0fh
	jmp lol
	lol:
	mov ESP,EBP
	pop EBP
	ret
	cautare_caracter endp
	
	
	nr_caractere proc
	push EBP
	mov EBP,ESP
	mov ECX,500							;punem in ECX numarul maxim de caractere pe care il putem introduce 
	mov EAX,0
	mov ESI,0							; cu ESI parcurgem expresia
	et_loop1:
	cmp ex[ESI],'='						;comparam fiecare caracter cu  '=', cand ajungem la = iesim din loop
	je suntegale						
	inc EAX								;in EAX punem numarul de caractere din sir
	inc ESI
	loop et_loop1
	suntegale:
	inc EAX
	mov lgexpresie,EAX					;punem in lgexpresie valoarea din EAX si anume lungimea expresiei introduse 
	mov ESP,EBP
	pop EBP
	ret
	nr_caractere endp
	
	;functie in care calculam cati operatori si cati operanzi avem
	nr_caract_speciale proc
	push EBP
	mov EBP,ESP
	mov ECX,lgexpresie
	mov ESI,0
	mov EAX,0
	et_loop2:	
	cmp ex[ESI],'*'						;comparam fiecare caracter din expresie cu caracterele speciale
	je egale							;cand gasim un caracter incrementam EAX
	cmp ex[ESI],'/'
	je egale
	cmp ex[ESI],'+'
	je egale
	cmp ex[ESI],'-'
	je egale
	jmp sfarsit					;daca caracterul din expresie nu este un operator,trecem la urmatorul caracter
	egale:
	inc EAX
	sfarsit:
	inc ESI
	loop et_loop2
	mov nrsirc,EAX							;in nrsirc punem nuamrul de operatori
	inc EAX
	mov nrsirn,EAX							;in nrsirn punem numarul de operanzi, nr de operanzi =numarul de operatori+1
	mov ESP,EBP
	pop EBP
	ret
	nr_caract_speciale endp
	
	
	creare_siruri proc
	push EBP
	mov EBP,ESP
	xor ECX,ECX
	mov ECX,lgexpresie
	
	xor ESI,ESI
	xor EDI,EDI								;initializam registrii
	xor EBX,EBX
	xor EDX,EDX								;il folosim pentru a parcurge expresia
	mov EBX,16
	xor EAX,EAX
	mov AL, ex[EDX]							;punem in EAX primul caracter din expresie
	call cautare_caracter					;apelam functia care va pune in EAX in loc de caracterul '0', cifra 0...										;...sau in loc de caracterul '1', cifra 1 si tot asa
	mov a,EAX								;in a vom memora valoarea lui EAX inainte sa il inmultim cu 16
	mul EBX
	mov b,EAX								;in b vom memora valoarea lui EAX dupe ce il inmultim cu 16
	inc EDX

	;in urmatorul loop vom proceda la fel pentru toate caracterele
	
	loo:
	xor EAX,EAX
	mov AL, ex[EDX]
	call cautare_caracter
	;verificam daca nu cumva caracterul este un operator
	cmp EAX,'='								;daca este '=' iesim din loop
	je iesire_din_loop
	cmp EAX,'+'
	je fin									;daca este un caracter special il punem in sirc
	cmp EAX,'/'
	je fin 
	cmp EAX,'-'
	je fin
	cmp EAX,'*'
	je fin
	add EAX,b								;la EAX adunam valoarea din b (b memora valoarea lui EAX inmultita cu 16)	
	mov a,EAX								;in a vom memora valoarea lua Eax inainte sa o inmultim cu 16
	mov ce,EDX								;la inmultire registrul EDX se face 0, asa ca valoarea lui o pastram in variabila ce
	mul EBX									;daca nu este un caracter special il inmultim pe EAX cu 16
	mov EDX,ce								;punem inapoi valoarea lui EDX
	mov b,EAX								;in b punem valoarea lui EAX dupa inmultirea cu 16
	jmp gata								;sarim peste partea in care scriem in siruri
	fin:
	mov sirc[EDI],EAX						;cand gasim un caracter il punem in sir
	add EDI,4
	
	mov EAX,a								;punem si operandul in sir
	mov sirn[ESI],EAX
	add ESI,4
	
	xor EBX,EBX								;resetam variabilele a si b pentru urmatorul numar
	mov a,EBX
	mov b,EBX
	mov EBX,16
	gata:
	inc EDX									;incremetam registrul EDX pentru a prelucra urmatorul caracter din sir
	loop loo
	iesire_din_loop:
	xor EAX,EAX								;cand iesim din loop ultimul operand nu se pune in sir
	mov EAX,a								;punem si ultimul operand 
	mov sirn[ESI],EAX
	xor EBX,EBX								;resetam variabilele a si b pentru urmatorul numar
	mov a,EBX
	mov b,EBX
	mov ESP,EBP
	pop EBP
	ret
	creare_siruri endp

	creare_siruri2 proc
	push EBP
	mov EBP,ESP
	xor ECX,ECX
	mov ECX,lgexpresie
	
	xor ESI,ESI
	xor eax,eax
	mov Eax,rez
	mov sirn[ESI],EAX
	add esi,4
	xor EDI,EDI								;initializam registrii
	xor EBX,EBX
	xor EDX,EDX								;il folosim pentru a parcurge expresia
	mov EBX,16
	xor EAX,EAX
	mov AL, ex[EDX]							;punem in EAX primul caracter din expresie,care este un operator
	mov sirc[EDI],EAX
	add EDI,4
	inc EDX

	;in urmatorul loop vom proceda la fel pentru toate caracterele
	
	loo:
	xor EAX,EAX
	mov AL, ex[EDX]
	call cautare_caracter
	;verificam daca nu cumva caracterul este un operator
	cmp EAX,'='								;daca este '=' iesim din loop
	je iesire_din_loop
	cmp EAX,'+'
	je fin									;daca este un caracter special il punem in sirc
	cmp EAX,'/'
	je fin 
	cmp EAX,'-'
	je fin
	cmp EAX,'*'
	je fin
	add EAX,b								;la EAX adunam valoarea din b (b memora valoarea lui EAX inmultita cu 16)	
	mov a,EAX								;in a vom memora valoarea lua Eax inainte sa o inmultim cu 16
	mov ce,EDX								;la inmultire registrul EDX se face 0, asa ca valoarea lui o pastram in variabila ce
	mul EBX									;daca nu este un caracter special il inmultim pe EAX cu 16
	mov EDX,ce								;punem inapoi valoarea lui EDX
	mov b,EAX								;in b punem valoarea lui EAX dupa inmultirea cu 16
	jmp gata								;sarim peste partea in care scriem in siruri
	fin:
	mov sirc[EDI],EAX						;cand gasim un caracter il punem in sir
	add EDI,4
	
	xor EAX,EAX
	mov EAX,a								;punem si operandul in sir
	mov sirn[ESI],EAX
	add ESI,4
	
	xor EBX,EBX								;resetam variabilele a si b pentru urmatorul numar
	mov a,EBX
	mov b,EBX
	mov EBX,16
	gata:
	inc EDX									;incremetam registrul EDX pentru a prelucra urmatorul caracter din sir
	loop loo
	iesire_din_loop:
	xor EAX,EAX								;cand iesim din loop ultimul operand nu se pune in sir
	mov EAX,a								;punem si ultimul operand 
	mov sirn[ESI],EAX
	xor EBX,EBX								;resetam variabilele a si b pentru urmatorul numar
	mov a,EBX
	mov b,EBX
	mov ESP,EBP
	pop EBP
	ret
	creare_siruri2 endp
	
	;functie care calculeaza expresia
	calculare_expresie proc
	push EBP
	mov EBP,ESP
	xor EAX,EAX
	xor EBX,EBX
	xor ECX,ECX
	xor EDX,EDX
	mov ECX,nrsirc
	
	xor ESI,ESI								;pt sirul de caractere
	xor EDI,EDI								;pt sirul de numere	
	;parcurgem sirul prima data si facem inmultirile si impartirile
	et_loop:
	cmp sirc[ESI],'*'
	je egale4
	cmp sirc[ESI],'/'
	je egale1
	jmp final
	egale4:
	mov EAX,sirn[ESI]
	add ESI,4
	mov EBX,sirn[ESI]
	call inmultire

	mov sirn[ESI],EAX
	sub ESI,4
	mov sirn[ESI],'?'
	jmp final
	egale1:
	mov EAX,sirn[ESI]
	add ESI,4
	mov EBX,sirn[ESI]
	mov EDX,0
	call impartire
	
	mov sirn[ESI],EAX
	sub ESI,4
	mov sirn[ESI],'?'					
	final:
	add ESI,4
	loop et_loop

	;parcurgem sirul a doua oara ca sa facem adunarile si scaderile
	xor ECX,ECX
	mov ECX,nrsirn
	xor ESI,ESI
	xor EDI,EDI
	
	et_lo:
	mov b1,ECX
	cmp sirc[ESI],'+'
	je egl
	cmp sirc[ESI],'-'
	je egl
	jmp fin1
	egl:
	mov EAX,sirn[ESI]
	mov sirn[ESI],'?'
	mov EDI,ESI
	add EDI,4
	mov ECX,nrsirn
	lo:
	cmp sirn[EDI],'?'
	jne afara
	add EDI,4
	loop lo
	afara:
	mov EBX,sirn[EDI]
	
	cmp sirc[ESI],'+'
	jne jos
	call adunare
	mov sirn[EDI],EAX
	jmp fin1
	jos:
	cmp sirc[ESI],'-'
	jne fin1
	call scadere
	mov sirn[EDI],EAX
	
	fin1:
	mov ECX,b1
	add ESI,4
	loop et_lo
	;la finalul functiei sirul cu operazi va avea semnul ? peste tot in afara de ultima pozitie
	;pe care se afla rezultatul expresiei
	mov ESP,EBP
	pop EBP
	ret
	calculare_expresie endp
	
	;functie care afiseaza rezultatul
	afisare_rezultat proc
	push EBP
	mov EBP,ESP
	mov ECX, nrsirn
	xor ESI,ESI
	loop_et:				;parcurgem sirul pana gasim un operand diferit de ?, acela este rezultatul expresiei
	mov a,ECX
	cmp sirn[ESI],'?'
	jne afisare
	add ESI,4
	mov ECX,a
	loop loop_et
	afisare:
	mov EAX,sirn[ESI]
	mov rez,EAX				;in variabila rez, pastram rezultatul expresiei curente
	mov ok,0

	push rez
	push offset text1
	push offset format2
	call printf
	add ESP,12
	mov ESP,EBP
	pop EBP
	ret
	afisare_rezultat endp
	
	;functie care trece pe un rand nou
	rand_nou proc
	push EBP
	mov EBP,ESP
	push offset variab
	call printf
	add ESP,8
	mov ESP,EBP
	pop EBP
	ret
	rand_nou endp
	
	;functie in care afisam mesajul "Introduceti o expresie:" si citim de la tastatura o expresie
	introducere_expresie proc
	push EBP
	mov EBP,ESP
	;resetam sirurile pentru operatori si operanzi
	xor ECX,ECX
	MOV ECX,nrsirn
	xor ESI,ESI
	et_loop3:
	mov sirn[ESI],0
	ADD ESI,4
	loop et_loop3
	
	xor ECX,ECX
	MOV ECX,nrsirc
	xor ESI,ESI
	et_loop4:
	mov sirc[ESI],0
	ADD ESI,4
	loop et_loop4
	
	;afisam sirul "Introduceti o expresie:"
	push offset text
	call printf
	add ESP,4
	
	;citim expresia de la tastatura
	push offset ex
	push offset format
	call scanf
	add ESP,8
	mov ESP,EBP
	pop EBP
	ret
	introducere_expresie endp
	
	;verificam daca primul caracter este un operator, daca da in variabila ok punem 1
	verificare_primul_caracter proc
	push EBP
	mov EBP,ESP
	xor ESI,ESI
	cmp ex[ESI],'+'
	je eticheta
	cmp ex[ESI],'-'
	je eticheta
	cmp ex[ESI],'*'
	je eticheta
	cmp ex[ESI],'/'
	je eticheta
	jmp primul_nu_e_operator
	eticheta:
	xor EAX,EAX
	inc EAX
	mov ok,EAX

	primul_nu_e_operator:
	mov ESP,EBP
	pop EBP
	ret
	verificare_primul_caracter endp
	
	
start:
	;afisam sirul "Introduceti o expresie:"
	push offset text
	call printf
	add ESP,4
	
	;citim expresia de la tastatura
	push offset ex
	push offset format
	call scanf
	add ESP,8
	
	mov ECX,500
	et_loop_mare:
	;verificam daca am introdus "exit"
	xor ESI,ESI
	cmp ex[ESI],'e'
	jne next
	inc ESI
	cmp ex[ESI],'x'
	jne next
	inc ESI
	cmp ex[ESI],'i'
	jne next
	inc ESI
	cmp ex[ESI],'t'
	jne next
	je jump
	jump:
	jmp final_de_cod
	next:
	
	;aflam lungimea expresiei introduse
	call nr_caractere
	
	;aflam cate caractere speciale avem in expresie 
	call nr_caract_speciale

	;verificam daca primul caracter e operator
	call verificare_primul_caracter
	
	;in sirul sirn vom pune operanzii si in sirul sirc vom pune operatorii
	;pentru a separa numerele de caractere am ales sa compar fiecare caracter din expresie cu caracterele de la 1 la F
	;numerele de mai multe cifre le voi calcula inmultind prima cifra cu 16 , la care adunam urmatoarea cifra si tot asa
	
	;daca ok=1 inseamna ca primul caracter este un operaator, inseamna ca primul operand va fi rezultatul expresiei anterioare
	;am facut functii diferite pentru cazul in care primul e un operator(ok=1) sau un operand(ok=0)
	cmp ok,1
	jne nusuntegale1
	call creare_siruri2
	jmp nxt
	nusuntegale1: 
	call creare_siruri
	nxt:
	
	;calculam expresia 
	call calculare_expresie
	
	;afisarea rezultatului
	call afisare_rezultat
	
	;trecem pe o linie noua
	call rand_nou
	
	;introducem o expresei noua
	call introducere_expresie

	loop et_loop_mare
	final_de_cod:
	
	push 0
	call exit
end start