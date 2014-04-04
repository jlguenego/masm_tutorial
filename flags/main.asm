include \masm32\include\masm32rt.inc

show_esp MACRO n
	mov my_esp, esp
	printf("my_esp(%d)=0x%08x\n", n, my_esp);
ENDM

get_flags MACRO
	;show_esp 1
	pushfd
	;show_esp 2
	mov eax, 0
	mov eax, [esp]
	mov flags, eax
	;show_esp 3
	popfd
	;show_esp 4
ENDM

show_flags MACRO f, p_mask
	cld
	mov eax, flags
	and eax, p_mask
	mov my_eax, eax
	printf("%s=0x%08X (%i)\n", f, my_eax, my_eax);
ENDM

show_add_CF MACRO v1, v2
	printf("Checking carry flag.\n");
	mov a, v1
	mov b, v2
	mov eax, v1
	add eax, v2
	mov r, eax
	printf("0x%08X (%i) plus 0x%08X (%i) = 0x%08X (%i)\n", a, a, b, b, r, r);
	mov eax, v1
	add eax, v2
	get_flags
	show_flags "CF", 1
ENDM

show_sub_CF MACRO v1, v2
	printf("Checking carry flag.\n");
	mov a, v1
	mov b, v2
	mov eax, v1
	sub eax, v2
	mov r, eax
	printf("0x%08X (%i) minus 0x%08X (%i) = 0x%08X (%i)\n", a, a, b, b, r, r);
	mov eax, v1
	sub eax, v2
	get_flags
	show_flags "CF", 1
ENDM

show_add_PF MACRO v1, v2
	printf("Checking parity flag.\n");
	mov a, v1
	mov b, v2
	mov eax, v1
	add eax, v2
	mov r, eax
	printf("adding 0x%08X (%i) add 0x%08X (%i) = 0x%08X (%i)\n", a, a, b, b, r, r);
	mov eax, v1
	add eax, v2
	get_flags
	show_flags "PF", 4
ENDM

show_add_AF MACRO v1, v2
	printf("Checking adjust flag (BCD).\n");
	mov a, v1
	mov b, v2
	mov eax, v1
	add eax, v2
	daa
	mov r, eax
	printf("adding 0x%08X (%i) bcd add 0x%08X (%i) = 0x%08X (%i)\n", a, a, b, b, r, r);
	mov eax, v1
	add eax, v2
	get_flags
	show_flags "AF", 10h
ENDM

show_add_ZF MACRO v1, v2
	printf("Checking Zero Flag.\n");
	mov a, v1
	mov b, v2
	mov eax, v1
	add eax, v2
	mov r, eax
	printf("adding 0x%08X (%i) add 0x%08X (%i) = 0x%08X (%i)\n", a, a, b, b, r, r);
	mov eax, v1
	add eax, v2
	get_flags
	show_flags "ZF", 40h
ENDM

show_add_SF MACRO v1, v2
	printf("Checking Sign Flag.\n");
	mov a, v1
	mov b, v2
	mov eax, v1
	add eax, v2
	mov r, eax
	printf("adding 0x%08X (%i) add 0x%08X (%i) = 0x%08X (%i)\n", a, a, b, b, r, r);
	mov eax, v1
	add eax, v2
	get_flags
	show_flags "SF", 80h
ENDM

show_TF MACRO
	printf("Checking Trap Flag.\n");
	get_flags
	show_flags "TF", 100h
ENDM

show_IF MACRO
	printf("Checking Interrupt Flag.\n");
	get_flags
	show_flags "IF", 200h
ENDM

show_DF MACRO
	get_flags
	cld
	printf("Checking Direction Flag.\n");
	show_flags "DF", 400h
ENDM

show_add_OF MACRO v1, v2
	printf("Checking overflow flag with add.\n");
	mov a, v1
	mov b, v2
	mov eax, v1
	add eax, v2
	mov r, eax
	printf("0x%08X (%i) plus 0x%08X (%i) = 0x%08X (%i)\n", a, a, b, b, r, r);
	mov eax, v1
	add eax, v2
	get_flags
	show_flags "OF", 800h
ENDM

show_sub_OF MACRO v1, v2
	printf("Checking overflow flag with sub.\n");
	mov a, v1
	mov b, v2
	mov eax, v1
	sub eax, v2
	mov r, eax
	printf("0x%08X (%i) minus 0x%08X (%i) = 0x%08X (%i)\n", a, a, b, b, r, r);
	mov eax, v1
	sub eax, v2
	get_flags
	show_flags "OF", 800h
ENDM

show_iopl MACRO
	printf("Checking IOPL flags.\n");
	get_flags
	show_flags "IOPL1", 1000h
	show_flags "IOPL2", 2000h
ENDM

show_nt MACRO
	printf("Checking Nested Task flags.\n");
	get_flags
	show_flags "NT", 4000h
ENDM

show_vm MACRO
	printf("Checking Virtual-8086 mode flags.\n");
	get_flags
	show_flags "VM", 8000h
ENDM

show_ac MACRO
	printf("Checking Alignment Check flags.\n");
	get_flags
	show_flags "AC", 10000h
ENDM

show_vif MACRO
	printf("Checking Virtual Interrupt flags.\n");
	get_flags
	show_flags "VIF", 20000h
ENDM

show_vip MACRO
	printf("Checking Virtual Interrupt Pending flags.\n");
	get_flags
	show_flags "VIP", 40000h
ENDM

show_id MACRO
	printf("Checking CPU Identification flags.\n");
	get_flags
	show_flags "ID", 80000h
ENDM

.data?
	my_esp DWORD ?
	my_eax DWORD ?
	flags DWORD ?
	a DWORD ?
	b DWORD ?
	r DWORD ?

.code
start:
	show_add_CF 0FFFFFFFEh, 2
	show_add_CF 56, -66
	show_sub_CF 56, 66

	show_add_PF 1, 2
	show_add_PF 4, 2
	show_add_PF 4, 3
	show_add_PF 0FFFFFF00h, 34h

	show_add_AF 4, 2
	show_add_AF 4, 8
	show_add_AF 4, 13

	show_add_ZF 4, -4
	show_add_ZF 1, 0

	show_add_SF 1, 1
	show_add_SF 1, -2
	show_add_SF 1, -1

	show_TF
	show_IF

	show_DF
	std
	show_DF
	cld
	show_DF

	show_add_OF 07FFFFFFFh, 1
	show_add_OF 07FFFFFFEh, 1
	show_sub_OF -07FFFFFFFh, 1
	show_sub_OF -07FFFFFFFh, 2

	show_iopl
	show_nt

	; 17.	VM : Virtual-8086 Mode. Set if in 8086 compatibility mode.
	show_vm
	; 18.	AC : Alignment Check. Set if alignment checking of memory references is done.
	show_ac
	; 19.	VIF : Virtual Interrupt Flag. Virtual image of IF.
	show_vif
	; 20.	VIP : Virtual Interrupt Pending flag. Set if an interrupt is pending.
	show_vip
	; 21.	ID : Identification Flag. Support for CPUID instruction if can be set.
	show_id

	invoke ExitProcess, 0
end start