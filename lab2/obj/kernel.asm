
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 90 11 00       	mov    $0x119000,%eax
    movl %eax, %cr3
c0100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
c0100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
c010000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
c0100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
c0100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
c010001c:	ff e0                	jmp    *%eax

c010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
c010001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
c0100020:	a3 00 90 11 c0       	mov    %eax,0xc0119000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 80 11 c0       	mov    $0xc0118000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	55                   	push   %ebp
c0100037:	89 e5                	mov    %esp,%ebp
c0100039:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c010003c:	b8 28 bf 11 c0       	mov    $0xc011bf28,%eax
c0100041:	2d 00 b0 11 c0       	sub    $0xc011b000,%eax
c0100046:	83 ec 04             	sub    $0x4,%esp
c0100049:	50                   	push   %eax
c010004a:	6a 00                	push   $0x0
c010004c:	68 00 b0 11 c0       	push   $0xc011b000
c0100051:	e8 d9 57 00 00       	call   c010582f <memset>
c0100056:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
c0100059:	e8 48 14 00 00       	call   c01014a6 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005e:	c7 45 f4 c0 59 10 c0 	movl   $0xc01059c0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100065:	83 ec 08             	sub    $0x8,%esp
c0100068:	ff 75 f4             	pushl  -0xc(%ebp)
c010006b:	68 dc 59 10 c0       	push   $0xc01059dc
c0100070:	e8 c2 02 00 00       	call   c0100337 <cprintf>
c0100075:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
c0100078:	e8 bd 07 00 00       	call   c010083a <print_kerninfo>

    grade_backtrace();
c010007d:	e8 74 00 00 00       	call   c01000f6 <grade_backtrace>

    pmm_init();                 // init physical memory management
c0100082:	e8 73 40 00 00       	call   c01040fa <pmm_init>

    pic_init();                 // init interrupt controller
c0100087:	e8 93 15 00 00       	call   c010161f <pic_init>
    idt_init();                 // init interrupt descriptor table
c010008c:	e8 d6 16 00 00       	call   c0101767 <idt_init>

    clock_init();               // init clock interrupt
c0100091:	e8 0c 0c 00 00       	call   c0100ca2 <clock_init>
    intr_enable();              // enable irq interrupt
c0100096:	e8 f6 14 00 00       	call   c0101591 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c010009b:	eb fe                	jmp    c010009b <kern_init+0x65>

c010009d <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009d:	55                   	push   %ebp
c010009e:	89 e5                	mov    %esp,%ebp
c01000a0:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
c01000a3:	83 ec 04             	sub    $0x4,%esp
c01000a6:	6a 00                	push   $0x0
c01000a8:	6a 00                	push   $0x0
c01000aa:	6a 00                	push   $0x0
c01000ac:	e8 0b 0b 00 00       	call   c0100bbc <mon_backtrace>
c01000b1:	83 c4 10             	add    $0x10,%esp
}
c01000b4:	90                   	nop
c01000b5:	c9                   	leave  
c01000b6:	c3                   	ret    

c01000b7 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000b7:	55                   	push   %ebp
c01000b8:	89 e5                	mov    %esp,%ebp
c01000ba:	53                   	push   %ebx
c01000bb:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000be:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000c1:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000c4:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01000ca:	51                   	push   %ecx
c01000cb:	52                   	push   %edx
c01000cc:	53                   	push   %ebx
c01000cd:	50                   	push   %eax
c01000ce:	e8 ca ff ff ff       	call   c010009d <grade_backtrace2>
c01000d3:	83 c4 10             	add    $0x10,%esp
}
c01000d6:	90                   	nop
c01000d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01000da:	c9                   	leave  
c01000db:	c3                   	ret    

c01000dc <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000dc:	55                   	push   %ebp
c01000dd:	89 e5                	mov    %esp,%ebp
c01000df:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
c01000e2:	83 ec 08             	sub    $0x8,%esp
c01000e5:	ff 75 10             	pushl  0x10(%ebp)
c01000e8:	ff 75 08             	pushl  0x8(%ebp)
c01000eb:	e8 c7 ff ff ff       	call   c01000b7 <grade_backtrace1>
c01000f0:	83 c4 10             	add    $0x10,%esp
}
c01000f3:	90                   	nop
c01000f4:	c9                   	leave  
c01000f5:	c3                   	ret    

c01000f6 <grade_backtrace>:

void
grade_backtrace(void) {
c01000f6:	55                   	push   %ebp
c01000f7:	89 e5                	mov    %esp,%ebp
c01000f9:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c01000fc:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c0100101:	83 ec 04             	sub    $0x4,%esp
c0100104:	68 00 00 ff ff       	push   $0xffff0000
c0100109:	50                   	push   %eax
c010010a:	6a 00                	push   $0x0
c010010c:	e8 cb ff ff ff       	call   c01000dc <grade_backtrace0>
c0100111:	83 c4 10             	add    $0x10,%esp
}
c0100114:	90                   	nop
c0100115:	c9                   	leave  
c0100116:	c3                   	ret    

c0100117 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100117:	55                   	push   %ebp
c0100118:	89 e5                	mov    %esp,%ebp
c010011a:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c010011d:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100120:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100123:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100126:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100129:	66 8b 45 f6          	mov    -0xa(%ebp),%ax
c010012d:	0f b7 c0             	movzwl %ax,%eax
c0100130:	83 e0 03             	and    $0x3,%eax
c0100133:	89 c2                	mov    %eax,%edx
c0100135:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c010013a:	83 ec 04             	sub    $0x4,%esp
c010013d:	52                   	push   %edx
c010013e:	50                   	push   %eax
c010013f:	68 e1 59 10 c0       	push   $0xc01059e1
c0100144:	e8 ee 01 00 00       	call   c0100337 <cprintf>
c0100149:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
c010014c:	66 8b 45 f6          	mov    -0xa(%ebp),%ax
c0100150:	0f b7 d0             	movzwl %ax,%edx
c0100153:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c0100158:	83 ec 04             	sub    $0x4,%esp
c010015b:	52                   	push   %edx
c010015c:	50                   	push   %eax
c010015d:	68 ef 59 10 c0       	push   $0xc01059ef
c0100162:	e8 d0 01 00 00       	call   c0100337 <cprintf>
c0100167:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
c010016a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010016d:	0f b7 d0             	movzwl %ax,%edx
c0100170:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c0100175:	83 ec 04             	sub    $0x4,%esp
c0100178:	52                   	push   %edx
c0100179:	50                   	push   %eax
c010017a:	68 fd 59 10 c0       	push   $0xc01059fd
c010017f:	e8 b3 01 00 00       	call   c0100337 <cprintf>
c0100184:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
c0100187:	66 8b 45 f2          	mov    -0xe(%ebp),%ax
c010018b:	0f b7 d0             	movzwl %ax,%edx
c010018e:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c0100193:	83 ec 04             	sub    $0x4,%esp
c0100196:	52                   	push   %edx
c0100197:	50                   	push   %eax
c0100198:	68 0b 5a 10 c0       	push   $0xc0105a0b
c010019d:	e8 95 01 00 00       	call   c0100337 <cprintf>
c01001a2:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
c01001a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01001a8:	0f b7 d0             	movzwl %ax,%edx
c01001ab:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c01001b0:	83 ec 04             	sub    $0x4,%esp
c01001b3:	52                   	push   %edx
c01001b4:	50                   	push   %eax
c01001b5:	68 19 5a 10 c0       	push   $0xc0105a19
c01001ba:	e8 78 01 00 00       	call   c0100337 <cprintf>
c01001bf:	83 c4 10             	add    $0x10,%esp
    round ++;
c01001c2:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c01001c7:	40                   	inc    %eax
c01001c8:	a3 00 b0 11 c0       	mov    %eax,0xc011b000
}
c01001cd:	90                   	nop
c01001ce:	c9                   	leave  
c01001cf:	c3                   	ret    

c01001d0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001d0:	55                   	push   %ebp
c01001d1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
    asm volatile (
c01001d3:	83 ec 08             	sub    $0x8,%esp
c01001d6:	cd 78                	int    $0x78
c01001d8:	89 ec                	mov    %ebp,%esp
       */
      "movl %%ebp, %%esp"
      :
      : "i"(T_SWITCH_TOU)
      );
}
c01001da:	90                   	nop
c01001db:	5d                   	pop    %ebp
c01001dc:	c3                   	ret    

c01001dd <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001dd:	55                   	push   %ebp
c01001de:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    asm volatile (
c01001e0:	cd 79                	int    $0x79
c01001e2:	89 ec                	mov    %ebp,%esp
      // 参考 kernel_to_user 注释
      "movl %%ebp, %%esp \n"
      :
      : "i"(T_SWITCH_TOK)
      );
}
c01001e4:	90                   	nop
c01001e5:	5d                   	pop    %ebp
c01001e6:	c3                   	ret    

c01001e7 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001e7:	55                   	push   %ebp
c01001e8:	89 e5                	mov    %esp,%ebp
c01001ea:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
c01001ed:	e8 25 ff ff ff       	call   c0100117 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c01001f2:	83 ec 0c             	sub    $0xc,%esp
c01001f5:	68 28 5a 10 c0       	push   $0xc0105a28
c01001fa:	e8 38 01 00 00       	call   c0100337 <cprintf>
c01001ff:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
c0100202:	e8 c9 ff ff ff       	call   c01001d0 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100207:	e8 0b ff ff ff       	call   c0100117 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010020c:	83 ec 0c             	sub    $0xc,%esp
c010020f:	68 48 5a 10 c0       	push   $0xc0105a48
c0100214:	e8 1e 01 00 00       	call   c0100337 <cprintf>
c0100219:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
c010021c:	e8 bc ff ff ff       	call   c01001dd <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100221:	e8 f1 fe ff ff       	call   c0100117 <lab1_print_cur_status>
}
c0100226:	90                   	nop
c0100227:	c9                   	leave  
c0100228:	c3                   	ret    

c0100229 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100229:	55                   	push   %ebp
c010022a:	89 e5                	mov    %esp,%ebp
c010022c:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
c010022f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100233:	74 13                	je     c0100248 <readline+0x1f>
        cprintf("%s", prompt);
c0100235:	83 ec 08             	sub    $0x8,%esp
c0100238:	ff 75 08             	pushl  0x8(%ebp)
c010023b:	68 67 5a 10 c0       	push   $0xc0105a67
c0100240:	e8 f2 00 00 00       	call   c0100337 <cprintf>
c0100245:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
c0100248:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c010024f:	e8 6d 01 00 00       	call   c01003c1 <getchar>
c0100254:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100257:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010025b:	79 0a                	jns    c0100267 <readline+0x3e>
            return NULL;
c010025d:	b8 00 00 00 00       	mov    $0x0,%eax
c0100262:	e9 81 00 00 00       	jmp    c01002e8 <readline+0xbf>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100267:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c010026b:	7e 2b                	jle    c0100298 <readline+0x6f>
c010026d:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100274:	7f 22                	jg     c0100298 <readline+0x6f>
            cputchar(c);
c0100276:	83 ec 0c             	sub    $0xc,%esp
c0100279:	ff 75 f0             	pushl  -0x10(%ebp)
c010027c:	e8 dc 00 00 00       	call   c010035d <cputchar>
c0100281:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
c0100284:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100287:	8d 50 01             	lea    0x1(%eax),%edx
c010028a:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010028d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100290:	88 90 20 b0 11 c0    	mov    %dl,-0x3fee4fe0(%eax)
c0100296:	eb 4b                	jmp    c01002e3 <readline+0xba>
        }
        else if (c == '\b' && i > 0) {
c0100298:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c010029c:	75 19                	jne    c01002b7 <readline+0x8e>
c010029e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002a2:	7e 13                	jle    c01002b7 <readline+0x8e>
            cputchar(c);
c01002a4:	83 ec 0c             	sub    $0xc,%esp
c01002a7:	ff 75 f0             	pushl  -0x10(%ebp)
c01002aa:	e8 ae 00 00 00       	call   c010035d <cputchar>
c01002af:	83 c4 10             	add    $0x10,%esp
            i --;
c01002b2:	ff 4d f4             	decl   -0xc(%ebp)
c01002b5:	eb 2c                	jmp    c01002e3 <readline+0xba>
        }
        else if (c == '\n' || c == '\r') {
c01002b7:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002bb:	74 06                	je     c01002c3 <readline+0x9a>
c01002bd:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002c1:	75 8c                	jne    c010024f <readline+0x26>
            cputchar(c);
c01002c3:	83 ec 0c             	sub    $0xc,%esp
c01002c6:	ff 75 f0             	pushl  -0x10(%ebp)
c01002c9:	e8 8f 00 00 00       	call   c010035d <cputchar>
c01002ce:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
c01002d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002d4:	05 20 b0 11 c0       	add    $0xc011b020,%eax
c01002d9:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002dc:	b8 20 b0 11 c0       	mov    $0xc011b020,%eax
c01002e1:	eb 05                	jmp    c01002e8 <readline+0xbf>
        c = getchar();
c01002e3:	e9 67 ff ff ff       	jmp    c010024f <readline+0x26>
        }
    }
}
c01002e8:	c9                   	leave  
c01002e9:	c3                   	ret    

c01002ea <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002ea:	55                   	push   %ebp
c01002eb:	89 e5                	mov    %esp,%ebp
c01002ed:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c01002f0:	83 ec 0c             	sub    $0xc,%esp
c01002f3:	ff 75 08             	pushl  0x8(%ebp)
c01002f6:	e8 dc 11 00 00       	call   c01014d7 <cons_putc>
c01002fb:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
c01002fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100301:	8b 00                	mov    (%eax),%eax
c0100303:	8d 50 01             	lea    0x1(%eax),%edx
c0100306:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100309:	89 10                	mov    %edx,(%eax)
}
c010030b:	90                   	nop
c010030c:	c9                   	leave  
c010030d:	c3                   	ret    

c010030e <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c010030e:	55                   	push   %ebp
c010030f:	89 e5                	mov    %esp,%ebp
c0100311:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c0100314:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c010031b:	ff 75 0c             	pushl  0xc(%ebp)
c010031e:	ff 75 08             	pushl  0x8(%ebp)
c0100321:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100324:	50                   	push   %eax
c0100325:	68 ea 02 10 c0       	push   $0xc01002ea
c010032a:	e8 ae 4d 00 00       	call   c01050dd <vprintfmt>
c010032f:	83 c4 10             	add    $0x10,%esp
    return cnt;
c0100332:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100335:	c9                   	leave  
c0100336:	c3                   	ret    

c0100337 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100337:	55                   	push   %ebp
c0100338:	89 e5                	mov    %esp,%ebp
c010033a:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010033d:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100340:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100343:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100346:	83 ec 08             	sub    $0x8,%esp
c0100349:	50                   	push   %eax
c010034a:	ff 75 08             	pushl  0x8(%ebp)
c010034d:	e8 bc ff ff ff       	call   c010030e <vcprintf>
c0100352:	83 c4 10             	add    $0x10,%esp
c0100355:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100358:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010035b:	c9                   	leave  
c010035c:	c3                   	ret    

c010035d <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c010035d:	55                   	push   %ebp
c010035e:	89 e5                	mov    %esp,%ebp
c0100360:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c0100363:	83 ec 0c             	sub    $0xc,%esp
c0100366:	ff 75 08             	pushl  0x8(%ebp)
c0100369:	e8 69 11 00 00       	call   c01014d7 <cons_putc>
c010036e:	83 c4 10             	add    $0x10,%esp
}
c0100371:	90                   	nop
c0100372:	c9                   	leave  
c0100373:	c3                   	ret    

c0100374 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100374:	55                   	push   %ebp
c0100375:	89 e5                	mov    %esp,%ebp
c0100377:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c010037a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100381:	eb 14                	jmp    c0100397 <cputs+0x23>
        cputch(c, &cnt);
c0100383:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100387:	83 ec 08             	sub    $0x8,%esp
c010038a:	8d 55 f0             	lea    -0x10(%ebp),%edx
c010038d:	52                   	push   %edx
c010038e:	50                   	push   %eax
c010038f:	e8 56 ff ff ff       	call   c01002ea <cputch>
c0100394:	83 c4 10             	add    $0x10,%esp
    while ((c = *str ++) != '\0') {
c0100397:	8b 45 08             	mov    0x8(%ebp),%eax
c010039a:	8d 50 01             	lea    0x1(%eax),%edx
c010039d:	89 55 08             	mov    %edx,0x8(%ebp)
c01003a0:	8a 00                	mov    (%eax),%al
c01003a2:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003a5:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003a9:	75 d8                	jne    c0100383 <cputs+0xf>
    }
    cputch('\n', &cnt);
c01003ab:	83 ec 08             	sub    $0x8,%esp
c01003ae:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003b1:	50                   	push   %eax
c01003b2:	6a 0a                	push   $0xa
c01003b4:	e8 31 ff ff ff       	call   c01002ea <cputch>
c01003b9:	83 c4 10             	add    $0x10,%esp
    return cnt;
c01003bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003bf:	c9                   	leave  
c01003c0:	c3                   	ret    

c01003c1 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003c1:	55                   	push   %ebp
c01003c2:	89 e5                	mov    %esp,%ebp
c01003c4:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003c7:	90                   	nop
c01003c8:	e8 53 11 00 00       	call   c0101520 <cons_getc>
c01003cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003d4:	74 f2                	je     c01003c8 <getchar+0x7>
        /* do nothing */;
    return c;
c01003d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003d9:	c9                   	leave  
c01003da:	c3                   	ret    

c01003db <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003db:	55                   	push   %ebp
c01003dc:	89 e5                	mov    %esp,%ebp
c01003de:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003e1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003e4:	8b 00                	mov    (%eax),%eax
c01003e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003e9:	8b 45 10             	mov    0x10(%ebp),%eax
c01003ec:	8b 00                	mov    (%eax),%eax
c01003ee:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01003f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01003f8:	e9 c9 00 00 00       	jmp    c01004c6 <stab_binsearch+0xeb>
        int true_m = (l + r) / 2, m = true_m;
c01003fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100400:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100403:	01 d0                	add    %edx,%eax
c0100405:	89 c2                	mov    %eax,%edx
c0100407:	c1 ea 1f             	shr    $0x1f,%edx
c010040a:	01 d0                	add    %edx,%eax
c010040c:	d1 f8                	sar    %eax
c010040e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100411:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100414:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100417:	eb 03                	jmp    c010041c <stab_binsearch+0x41>
            m --;
c0100419:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c010041c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010041f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100422:	7c 1e                	jl     c0100442 <stab_binsearch+0x67>
c0100424:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100427:	89 d0                	mov    %edx,%eax
c0100429:	01 c0                	add    %eax,%eax
c010042b:	01 d0                	add    %edx,%eax
c010042d:	c1 e0 02             	shl    $0x2,%eax
c0100430:	89 c2                	mov    %eax,%edx
c0100432:	8b 45 08             	mov    0x8(%ebp),%eax
c0100435:	01 d0                	add    %edx,%eax
c0100437:	8a 40 04             	mov    0x4(%eax),%al
c010043a:	0f b6 c0             	movzbl %al,%eax
c010043d:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100440:	75 d7                	jne    c0100419 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
c0100442:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100445:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100448:	7d 09                	jge    c0100453 <stab_binsearch+0x78>
            l = true_m + 1;
c010044a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010044d:	40                   	inc    %eax
c010044e:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100451:	eb 73                	jmp    c01004c6 <stab_binsearch+0xeb>
        }

        // actual binary search
        any_matches = 1;
c0100453:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010045a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010045d:	89 d0                	mov    %edx,%eax
c010045f:	01 c0                	add    %eax,%eax
c0100461:	01 d0                	add    %edx,%eax
c0100463:	c1 e0 02             	shl    $0x2,%eax
c0100466:	89 c2                	mov    %eax,%edx
c0100468:	8b 45 08             	mov    0x8(%ebp),%eax
c010046b:	01 d0                	add    %edx,%eax
c010046d:	8b 40 08             	mov    0x8(%eax),%eax
c0100470:	39 45 18             	cmp    %eax,0x18(%ebp)
c0100473:	76 11                	jbe    c0100486 <stab_binsearch+0xab>
            *region_left = m;
c0100475:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100478:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010047b:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010047d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100480:	40                   	inc    %eax
c0100481:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100484:	eb 40                	jmp    c01004c6 <stab_binsearch+0xeb>
        } else if (stabs[m].n_value > addr) {
c0100486:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100489:	89 d0                	mov    %edx,%eax
c010048b:	01 c0                	add    %eax,%eax
c010048d:	01 d0                	add    %edx,%eax
c010048f:	c1 e0 02             	shl    $0x2,%eax
c0100492:	89 c2                	mov    %eax,%edx
c0100494:	8b 45 08             	mov    0x8(%ebp),%eax
c0100497:	01 d0                	add    %edx,%eax
c0100499:	8b 40 08             	mov    0x8(%eax),%eax
c010049c:	39 45 18             	cmp    %eax,0x18(%ebp)
c010049f:	73 14                	jae    c01004b5 <stab_binsearch+0xda>
            *region_right = m - 1;
c01004a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004a4:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004a7:	8b 45 10             	mov    0x10(%ebp),%eax
c01004aa:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004af:	48                   	dec    %eax
c01004b0:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004b3:	eb 11                	jmp    c01004c6 <stab_binsearch+0xeb>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004b5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004bb:	89 10                	mov    %edx,(%eax)
            l = m;
c01004bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004c3:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
c01004c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004c9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004cc:	0f 8e 2b ff ff ff    	jle    c01003fd <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
c01004d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004d6:	75 0f                	jne    c01004e7 <stab_binsearch+0x10c>
        *region_right = *region_left - 1;
c01004d8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004db:	8b 00                	mov    (%eax),%eax
c01004dd:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004e0:	8b 45 10             	mov    0x10(%ebp),%eax
c01004e3:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c01004e5:	eb 3d                	jmp    c0100524 <stab_binsearch+0x149>
        l = *region_right;
c01004e7:	8b 45 10             	mov    0x10(%ebp),%eax
c01004ea:	8b 00                	mov    (%eax),%eax
c01004ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01004ef:	eb 03                	jmp    c01004f4 <stab_binsearch+0x119>
c01004f1:	ff 4d fc             	decl   -0x4(%ebp)
c01004f4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004f7:	8b 00                	mov    (%eax),%eax
c01004f9:	39 45 fc             	cmp    %eax,-0x4(%ebp)
c01004fc:	7e 1e                	jle    c010051c <stab_binsearch+0x141>
c01004fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100501:	89 d0                	mov    %edx,%eax
c0100503:	01 c0                	add    %eax,%eax
c0100505:	01 d0                	add    %edx,%eax
c0100507:	c1 e0 02             	shl    $0x2,%eax
c010050a:	89 c2                	mov    %eax,%edx
c010050c:	8b 45 08             	mov    0x8(%ebp),%eax
c010050f:	01 d0                	add    %edx,%eax
c0100511:	8a 40 04             	mov    0x4(%eax),%al
c0100514:	0f b6 c0             	movzbl %al,%eax
c0100517:	39 45 14             	cmp    %eax,0x14(%ebp)
c010051a:	75 d5                	jne    c01004f1 <stab_binsearch+0x116>
        *region_left = l;
c010051c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010051f:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100522:	89 10                	mov    %edx,(%eax)
}
c0100524:	90                   	nop
c0100525:	c9                   	leave  
c0100526:	c3                   	ret    

c0100527 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100527:	55                   	push   %ebp
c0100528:	89 e5                	mov    %esp,%ebp
c010052a:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c010052d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100530:	c7 00 6c 5a 10 c0    	movl   $0xc0105a6c,(%eax)
    info->eip_line = 0;
c0100536:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100539:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100540:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100543:	c7 40 08 6c 5a 10 c0 	movl   $0xc0105a6c,0x8(%eax)
    info->eip_fn_namelen = 9;
c010054a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054d:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100554:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100557:	8b 55 08             	mov    0x8(%ebp),%edx
c010055a:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c010055d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100560:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100567:	c7 45 f4 b8 6c 10 c0 	movl   $0xc0106cb8,-0xc(%ebp)
    stab_end = __STAB_END__;
c010056e:	c7 45 f0 64 2f 11 c0 	movl   $0xc0112f64,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100575:	c7 45 ec 65 2f 11 c0 	movl   $0xc0112f65,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c010057c:	c7 45 e8 89 5a 11 c0 	movl   $0xc0115a89,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c0100583:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100586:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100589:	76 0a                	jbe    c0100595 <debuginfo_eip+0x6e>
c010058b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010058e:	48                   	dec    %eax
c010058f:	8a 00                	mov    (%eax),%al
c0100591:	84 c0                	test   %al,%al
c0100593:	74 0a                	je     c010059f <debuginfo_eip+0x78>
        return -1;
c0100595:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010059a:	e9 99 02 00 00       	jmp    c0100838 <debuginfo_eip+0x311>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c010059f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005a9:	2b 45 f4             	sub    -0xc(%ebp),%eax
c01005ac:	c1 f8 02             	sar    $0x2,%eax
c01005af:	89 c2                	mov    %eax,%edx
c01005b1:	89 d0                	mov    %edx,%eax
c01005b3:	c1 e0 02             	shl    $0x2,%eax
c01005b6:	01 d0                	add    %edx,%eax
c01005b8:	c1 e0 02             	shl    $0x2,%eax
c01005bb:	01 d0                	add    %edx,%eax
c01005bd:	c1 e0 02             	shl    $0x2,%eax
c01005c0:	01 d0                	add    %edx,%eax
c01005c2:	89 c1                	mov    %eax,%ecx
c01005c4:	c1 e1 08             	shl    $0x8,%ecx
c01005c7:	01 c8                	add    %ecx,%eax
c01005c9:	89 c1                	mov    %eax,%ecx
c01005cb:	c1 e1 10             	shl    $0x10,%ecx
c01005ce:	01 c8                	add    %ecx,%eax
c01005d0:	01 c0                	add    %eax,%eax
c01005d2:	01 d0                	add    %edx,%eax
c01005d4:	48                   	dec    %eax
c01005d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005d8:	ff 75 08             	pushl  0x8(%ebp)
c01005db:	6a 64                	push   $0x64
c01005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005e0:	50                   	push   %eax
c01005e1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005e4:	50                   	push   %eax
c01005e5:	ff 75 f4             	pushl  -0xc(%ebp)
c01005e8:	e8 ee fd ff ff       	call   c01003db <stab_binsearch>
c01005ed:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
c01005f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005f3:	85 c0                	test   %eax,%eax
c01005f5:	75 0a                	jne    c0100601 <debuginfo_eip+0xda>
        return -1;
c01005f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005fc:	e9 37 02 00 00       	jmp    c0100838 <debuginfo_eip+0x311>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100601:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100604:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100607:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010060a:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c010060d:	ff 75 08             	pushl  0x8(%ebp)
c0100610:	6a 24                	push   $0x24
c0100612:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100615:	50                   	push   %eax
c0100616:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100619:	50                   	push   %eax
c010061a:	ff 75 f4             	pushl  -0xc(%ebp)
c010061d:	e8 b9 fd ff ff       	call   c01003db <stab_binsearch>
c0100622:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
c0100625:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100628:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010062b:	39 c2                	cmp    %eax,%edx
c010062d:	7f 78                	jg     c01006a7 <debuginfo_eip+0x180>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c010062f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100632:	89 c2                	mov    %eax,%edx
c0100634:	89 d0                	mov    %edx,%eax
c0100636:	01 c0                	add    %eax,%eax
c0100638:	01 d0                	add    %edx,%eax
c010063a:	c1 e0 02             	shl    $0x2,%eax
c010063d:	89 c2                	mov    %eax,%edx
c010063f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100642:	01 d0                	add    %edx,%eax
c0100644:	8b 10                	mov    (%eax),%edx
c0100646:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100649:	2b 45 ec             	sub    -0x14(%ebp),%eax
c010064c:	39 c2                	cmp    %eax,%edx
c010064e:	73 22                	jae    c0100672 <debuginfo_eip+0x14b>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100650:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100653:	89 c2                	mov    %eax,%edx
c0100655:	89 d0                	mov    %edx,%eax
c0100657:	01 c0                	add    %eax,%eax
c0100659:	01 d0                	add    %edx,%eax
c010065b:	c1 e0 02             	shl    $0x2,%eax
c010065e:	89 c2                	mov    %eax,%edx
c0100660:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100663:	01 d0                	add    %edx,%eax
c0100665:	8b 10                	mov    (%eax),%edx
c0100667:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010066a:	01 c2                	add    %eax,%edx
c010066c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010066f:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c0100672:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100675:	89 c2                	mov    %eax,%edx
c0100677:	89 d0                	mov    %edx,%eax
c0100679:	01 c0                	add    %eax,%eax
c010067b:	01 d0                	add    %edx,%eax
c010067d:	c1 e0 02             	shl    $0x2,%eax
c0100680:	89 c2                	mov    %eax,%edx
c0100682:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100685:	01 d0                	add    %edx,%eax
c0100687:	8b 50 08             	mov    0x8(%eax),%edx
c010068a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010068d:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c0100690:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100693:	8b 40 10             	mov    0x10(%eax),%eax
c0100696:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c0100699:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010069c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c010069f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006a2:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006a5:	eb 15                	jmp    c01006bc <debuginfo_eip+0x195>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006aa:	8b 55 08             	mov    0x8(%ebp),%edx
c01006ad:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006b9:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006bf:	8b 40 08             	mov    0x8(%eax),%eax
c01006c2:	83 ec 08             	sub    $0x8,%esp
c01006c5:	6a 3a                	push   $0x3a
c01006c7:	50                   	push   %eax
c01006c8:	e8 f0 4f 00 00       	call   c01056bd <strfind>
c01006cd:	83 c4 10             	add    $0x10,%esp
c01006d0:	89 c2                	mov    %eax,%edx
c01006d2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d5:	8b 40 08             	mov    0x8(%eax),%eax
c01006d8:	29 c2                	sub    %eax,%edx
c01006da:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006dd:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01006e0:	83 ec 0c             	sub    $0xc,%esp
c01006e3:	ff 75 08             	pushl  0x8(%ebp)
c01006e6:	6a 44                	push   $0x44
c01006e8:	8d 45 d0             	lea    -0x30(%ebp),%eax
c01006eb:	50                   	push   %eax
c01006ec:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c01006ef:	50                   	push   %eax
c01006f0:	ff 75 f4             	pushl  -0xc(%ebp)
c01006f3:	e8 e3 fc ff ff       	call   c01003db <stab_binsearch>
c01006f8:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
c01006fb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01006fe:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100701:	39 c2                	cmp    %eax,%edx
c0100703:	7f 24                	jg     c0100729 <debuginfo_eip+0x202>
        info->eip_line = stabs[rline].n_desc;
c0100705:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100708:	89 c2                	mov    %eax,%edx
c010070a:	89 d0                	mov    %edx,%eax
c010070c:	01 c0                	add    %eax,%eax
c010070e:	01 d0                	add    %edx,%eax
c0100710:	c1 e0 02             	shl    $0x2,%eax
c0100713:	89 c2                	mov    %eax,%edx
c0100715:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100718:	01 d0                	add    %edx,%eax
c010071a:	66 8b 40 06          	mov    0x6(%eax),%ax
c010071e:	0f b7 d0             	movzwl %ax,%edx
c0100721:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100724:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100727:	eb 11                	jmp    c010073a <debuginfo_eip+0x213>
        return -1;
c0100729:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010072e:	e9 05 01 00 00       	jmp    c0100838 <debuginfo_eip+0x311>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100733:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100736:	48                   	dec    %eax
c0100737:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c010073a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010073d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100740:	39 c2                	cmp    %eax,%edx
c0100742:	7c 54                	jl     c0100798 <debuginfo_eip+0x271>
           && stabs[lline].n_type != N_SOL
c0100744:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100747:	89 c2                	mov    %eax,%edx
c0100749:	89 d0                	mov    %edx,%eax
c010074b:	01 c0                	add    %eax,%eax
c010074d:	01 d0                	add    %edx,%eax
c010074f:	c1 e0 02             	shl    $0x2,%eax
c0100752:	89 c2                	mov    %eax,%edx
c0100754:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100757:	01 d0                	add    %edx,%eax
c0100759:	8a 40 04             	mov    0x4(%eax),%al
c010075c:	3c 84                	cmp    $0x84,%al
c010075e:	74 38                	je     c0100798 <debuginfo_eip+0x271>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100760:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100763:	89 c2                	mov    %eax,%edx
c0100765:	89 d0                	mov    %edx,%eax
c0100767:	01 c0                	add    %eax,%eax
c0100769:	01 d0                	add    %edx,%eax
c010076b:	c1 e0 02             	shl    $0x2,%eax
c010076e:	89 c2                	mov    %eax,%edx
c0100770:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100773:	01 d0                	add    %edx,%eax
c0100775:	8a 40 04             	mov    0x4(%eax),%al
c0100778:	3c 64                	cmp    $0x64,%al
c010077a:	75 b7                	jne    c0100733 <debuginfo_eip+0x20c>
c010077c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010077f:	89 c2                	mov    %eax,%edx
c0100781:	89 d0                	mov    %edx,%eax
c0100783:	01 c0                	add    %eax,%eax
c0100785:	01 d0                	add    %edx,%eax
c0100787:	c1 e0 02             	shl    $0x2,%eax
c010078a:	89 c2                	mov    %eax,%edx
c010078c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010078f:	01 d0                	add    %edx,%eax
c0100791:	8b 40 08             	mov    0x8(%eax),%eax
c0100794:	85 c0                	test   %eax,%eax
c0100796:	74 9b                	je     c0100733 <debuginfo_eip+0x20c>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c0100798:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010079b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010079e:	39 c2                	cmp    %eax,%edx
c01007a0:	7c 42                	jl     c01007e4 <debuginfo_eip+0x2bd>
c01007a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007a5:	89 c2                	mov    %eax,%edx
c01007a7:	89 d0                	mov    %edx,%eax
c01007a9:	01 c0                	add    %eax,%eax
c01007ab:	01 d0                	add    %edx,%eax
c01007ad:	c1 e0 02             	shl    $0x2,%eax
c01007b0:	89 c2                	mov    %eax,%edx
c01007b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007b5:	01 d0                	add    %edx,%eax
c01007b7:	8b 10                	mov    (%eax),%edx
c01007b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01007bc:	2b 45 ec             	sub    -0x14(%ebp),%eax
c01007bf:	39 c2                	cmp    %eax,%edx
c01007c1:	73 21                	jae    c01007e4 <debuginfo_eip+0x2bd>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007c6:	89 c2                	mov    %eax,%edx
c01007c8:	89 d0                	mov    %edx,%eax
c01007ca:	01 c0                	add    %eax,%eax
c01007cc:	01 d0                	add    %edx,%eax
c01007ce:	c1 e0 02             	shl    $0x2,%eax
c01007d1:	89 c2                	mov    %eax,%edx
c01007d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007d6:	01 d0                	add    %edx,%eax
c01007d8:	8b 10                	mov    (%eax),%edx
c01007da:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007dd:	01 c2                	add    %eax,%edx
c01007df:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007e2:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c01007e4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01007e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01007ea:	39 c2                	cmp    %eax,%edx
c01007ec:	7d 45                	jge    c0100833 <debuginfo_eip+0x30c>
        for (lline = lfun + 1;
c01007ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01007f1:	40                   	inc    %eax
c01007f2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01007f5:	eb 16                	jmp    c010080d <debuginfo_eip+0x2e6>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c01007f7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007fa:	8b 40 14             	mov    0x14(%eax),%eax
c01007fd:	8d 50 01             	lea    0x1(%eax),%edx
c0100800:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100803:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c0100806:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100809:	40                   	inc    %eax
c010080a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010080d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100810:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
c0100813:	39 c2                	cmp    %eax,%edx
c0100815:	7d 1c                	jge    c0100833 <debuginfo_eip+0x30c>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100817:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010081a:	89 c2                	mov    %eax,%edx
c010081c:	89 d0                	mov    %edx,%eax
c010081e:	01 c0                	add    %eax,%eax
c0100820:	01 d0                	add    %edx,%eax
c0100822:	c1 e0 02             	shl    $0x2,%eax
c0100825:	89 c2                	mov    %eax,%edx
c0100827:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010082a:	01 d0                	add    %edx,%eax
c010082c:	8a 40 04             	mov    0x4(%eax),%al
c010082f:	3c a0                	cmp    $0xa0,%al
c0100831:	74 c4                	je     c01007f7 <debuginfo_eip+0x2d0>
        }
    }
    return 0;
c0100833:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100838:	c9                   	leave  
c0100839:	c3                   	ret    

c010083a <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c010083a:	55                   	push   %ebp
c010083b:	89 e5                	mov    %esp,%ebp
c010083d:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100840:	83 ec 0c             	sub    $0xc,%esp
c0100843:	68 76 5a 10 c0       	push   $0xc0105a76
c0100848:	e8 ea fa ff ff       	call   c0100337 <cprintf>
c010084d:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100850:	83 ec 08             	sub    $0x8,%esp
c0100853:	68 36 00 10 c0       	push   $0xc0100036
c0100858:	68 8f 5a 10 c0       	push   $0xc0105a8f
c010085d:	e8 d5 fa ff ff       	call   c0100337 <cprintf>
c0100862:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100865:	83 ec 08             	sub    $0x8,%esp
c0100868:	68 b3 59 10 c0       	push   $0xc01059b3
c010086d:	68 a7 5a 10 c0       	push   $0xc0105aa7
c0100872:	e8 c0 fa ff ff       	call   c0100337 <cprintf>
c0100877:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
c010087a:	83 ec 08             	sub    $0x8,%esp
c010087d:	68 00 b0 11 c0       	push   $0xc011b000
c0100882:	68 bf 5a 10 c0       	push   $0xc0105abf
c0100887:	e8 ab fa ff ff       	call   c0100337 <cprintf>
c010088c:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
c010088f:	83 ec 08             	sub    $0x8,%esp
c0100892:	68 28 bf 11 c0       	push   $0xc011bf28
c0100897:	68 d7 5a 10 c0       	push   $0xc0105ad7
c010089c:	e8 96 fa ff ff       	call   c0100337 <cprintf>
c01008a1:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008a4:	b8 28 bf 11 c0       	mov    $0xc011bf28,%eax
c01008a9:	2d 36 00 10 c0       	sub    $0xc0100036,%eax
c01008ae:	05 ff 03 00 00       	add    $0x3ff,%eax
c01008b3:	85 c0                	test   %eax,%eax
c01008b5:	79 05                	jns    c01008bc <print_kerninfo+0x82>
c01008b7:	05 ff 03 00 00       	add    $0x3ff,%eax
c01008bc:	c1 f8 0a             	sar    $0xa,%eax
c01008bf:	83 ec 08             	sub    $0x8,%esp
c01008c2:	50                   	push   %eax
c01008c3:	68 f0 5a 10 c0       	push   $0xc0105af0
c01008c8:	e8 6a fa ff ff       	call   c0100337 <cprintf>
c01008cd:	83 c4 10             	add    $0x10,%esp
}
c01008d0:	90                   	nop
c01008d1:	c9                   	leave  
c01008d2:	c3                   	ret    

c01008d3 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c01008d3:	55                   	push   %ebp
c01008d4:	89 e5                	mov    %esp,%ebp
c01008d6:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c01008dc:	83 ec 08             	sub    $0x8,%esp
c01008df:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01008e2:	50                   	push   %eax
c01008e3:	ff 75 08             	pushl  0x8(%ebp)
c01008e6:	e8 3c fc ff ff       	call   c0100527 <debuginfo_eip>
c01008eb:	83 c4 10             	add    $0x10,%esp
c01008ee:	85 c0                	test   %eax,%eax
c01008f0:	74 15                	je     c0100907 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c01008f2:	83 ec 08             	sub    $0x8,%esp
c01008f5:	ff 75 08             	pushl  0x8(%ebp)
c01008f8:	68 1a 5b 10 c0       	push   $0xc0105b1a
c01008fd:	e8 35 fa ff ff       	call   c0100337 <cprintf>
c0100902:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c0100905:	eb 63                	jmp    c010096a <print_debuginfo+0x97>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100907:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010090e:	eb 1a                	jmp    c010092a <print_debuginfo+0x57>
            fnname[j] = info.eip_fn_name[j];
c0100910:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100913:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100916:	01 d0                	add    %edx,%eax
c0100918:	8a 00                	mov    (%eax),%al
c010091a:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100920:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100923:	01 ca                	add    %ecx,%edx
c0100925:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100927:	ff 45 f4             	incl   -0xc(%ebp)
c010092a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010092d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0100930:	7c de                	jl     c0100910 <print_debuginfo+0x3d>
        fnname[j] = '\0';
c0100932:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100938:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010093b:	01 d0                	add    %edx,%eax
c010093d:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
c0100940:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100943:	8b 55 08             	mov    0x8(%ebp),%edx
c0100946:	89 d1                	mov    %edx,%ecx
c0100948:	29 c1                	sub    %eax,%ecx
c010094a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010094d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100950:	83 ec 0c             	sub    $0xc,%esp
c0100953:	51                   	push   %ecx
c0100954:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010095a:	51                   	push   %ecx
c010095b:	52                   	push   %edx
c010095c:	50                   	push   %eax
c010095d:	68 36 5b 10 c0       	push   $0xc0105b36
c0100962:	e8 d0 f9 ff ff       	call   c0100337 <cprintf>
c0100967:	83 c4 20             	add    $0x20,%esp
}
c010096a:	90                   	nop
c010096b:	c9                   	leave  
c010096c:	c3                   	ret    

c010096d <read_eip>:

static __noinline uint32_t
read_eip(void) {
c010096d:	55                   	push   %ebp
c010096e:	89 e5                	mov    %esp,%ebp
c0100970:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100973:	8b 45 04             	mov    0x4(%ebp),%eax
c0100976:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100979:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010097c:	c9                   	leave  
c010097d:	c3                   	ret    

c010097e <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c010097e:	55                   	push   %ebp
c010097f:	89 e5                	mov    %esp,%ebp
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
c0100981:	90                   	nop
c0100982:	5d                   	pop    %ebp
c0100983:	c3                   	ret    

c0100984 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100984:	55                   	push   %ebp
c0100985:	89 e5                	mov    %esp,%ebp
c0100987:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
c010098a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100991:	eb 0c                	jmp    c010099f <parse+0x1b>
            *buf ++ = '\0';
c0100993:	8b 45 08             	mov    0x8(%ebp),%eax
c0100996:	8d 50 01             	lea    0x1(%eax),%edx
c0100999:	89 55 08             	mov    %edx,0x8(%ebp)
c010099c:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c010099f:	8b 45 08             	mov    0x8(%ebp),%eax
c01009a2:	8a 00                	mov    (%eax),%al
c01009a4:	84 c0                	test   %al,%al
c01009a6:	74 1d                	je     c01009c5 <parse+0x41>
c01009a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01009ab:	8a 00                	mov    (%eax),%al
c01009ad:	0f be c0             	movsbl %al,%eax
c01009b0:	83 ec 08             	sub    $0x8,%esp
c01009b3:	50                   	push   %eax
c01009b4:	68 c8 5b 10 c0       	push   $0xc0105bc8
c01009b9:	e8 cf 4c 00 00       	call   c010568d <strchr>
c01009be:	83 c4 10             	add    $0x10,%esp
c01009c1:	85 c0                	test   %eax,%eax
c01009c3:	75 ce                	jne    c0100993 <parse+0xf>
        }
        if (*buf == '\0') {
c01009c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01009c8:	8a 00                	mov    (%eax),%al
c01009ca:	84 c0                	test   %al,%al
c01009cc:	74 62                	je     c0100a30 <parse+0xac>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c01009ce:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c01009d2:	75 12                	jne    c01009e6 <parse+0x62>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c01009d4:	83 ec 08             	sub    $0x8,%esp
c01009d7:	6a 10                	push   $0x10
c01009d9:	68 cd 5b 10 c0       	push   $0xc0105bcd
c01009de:	e8 54 f9 ff ff       	call   c0100337 <cprintf>
c01009e3:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
c01009e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009e9:	8d 50 01             	lea    0x1(%eax),%edx
c01009ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01009ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01009f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01009f9:	01 c2                	add    %eax,%edx
c01009fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01009fe:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100a00:	eb 03                	jmp    c0100a05 <parse+0x81>
            buf ++;
c0100a02:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100a05:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a08:	8a 00                	mov    (%eax),%al
c0100a0a:	84 c0                	test   %al,%al
c0100a0c:	74 91                	je     c010099f <parse+0x1b>
c0100a0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a11:	8a 00                	mov    (%eax),%al
c0100a13:	0f be c0             	movsbl %al,%eax
c0100a16:	83 ec 08             	sub    $0x8,%esp
c0100a19:	50                   	push   %eax
c0100a1a:	68 c8 5b 10 c0       	push   $0xc0105bc8
c0100a1f:	e8 69 4c 00 00       	call   c010568d <strchr>
c0100a24:	83 c4 10             	add    $0x10,%esp
c0100a27:	85 c0                	test   %eax,%eax
c0100a29:	74 d7                	je     c0100a02 <parse+0x7e>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a2b:	e9 6f ff ff ff       	jmp    c010099f <parse+0x1b>
            break;
c0100a30:	90                   	nop
        }
    }
    return argc;
c0100a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100a34:	c9                   	leave  
c0100a35:	c3                   	ret    

c0100a36 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100a36:	55                   	push   %ebp
c0100a37:	89 e5                	mov    %esp,%ebp
c0100a39:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100a3c:	83 ec 08             	sub    $0x8,%esp
c0100a3f:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100a42:	50                   	push   %eax
c0100a43:	ff 75 08             	pushl  0x8(%ebp)
c0100a46:	e8 39 ff ff ff       	call   c0100984 <parse>
c0100a4b:	83 c4 10             	add    $0x10,%esp
c0100a4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100a51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100a55:	75 0a                	jne    c0100a61 <runcmd+0x2b>
        return 0;
c0100a57:	b8 00 00 00 00       	mov    $0x0,%eax
c0100a5c:	e9 80 00 00 00       	jmp    c0100ae1 <runcmd+0xab>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100a61:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a68:	eb 56                	jmp    c0100ac0 <runcmd+0x8a>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100a6a:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0100a6d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
c0100a70:	89 c8                	mov    %ecx,%eax
c0100a72:	01 c0                	add    %eax,%eax
c0100a74:	01 c8                	add    %ecx,%eax
c0100a76:	c1 e0 02             	shl    $0x2,%eax
c0100a79:	05 00 80 11 c0       	add    $0xc0118000,%eax
c0100a7e:	8b 00                	mov    (%eax),%eax
c0100a80:	83 ec 08             	sub    $0x8,%esp
c0100a83:	52                   	push   %edx
c0100a84:	50                   	push   %eax
c0100a85:	e8 6b 4b 00 00       	call   c01055f5 <strcmp>
c0100a8a:	83 c4 10             	add    $0x10,%esp
c0100a8d:	85 c0                	test   %eax,%eax
c0100a8f:	75 2c                	jne    c0100abd <runcmd+0x87>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100a91:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100a94:	89 d0                	mov    %edx,%eax
c0100a96:	01 c0                	add    %eax,%eax
c0100a98:	01 d0                	add    %edx,%eax
c0100a9a:	c1 e0 02             	shl    $0x2,%eax
c0100a9d:	05 08 80 11 c0       	add    $0xc0118008,%eax
c0100aa2:	8b 10                	mov    (%eax),%edx
c0100aa4:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100aa7:	83 c0 04             	add    $0x4,%eax
c0100aaa:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100aad:	49                   	dec    %ecx
c0100aae:	83 ec 04             	sub    $0x4,%esp
c0100ab1:	ff 75 0c             	pushl  0xc(%ebp)
c0100ab4:	50                   	push   %eax
c0100ab5:	51                   	push   %ecx
c0100ab6:	ff d2                	call   *%edx
c0100ab8:	83 c4 10             	add    $0x10,%esp
c0100abb:	eb 24                	jmp    c0100ae1 <runcmd+0xab>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100abd:	ff 45 f4             	incl   -0xc(%ebp)
c0100ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ac3:	83 f8 02             	cmp    $0x2,%eax
c0100ac6:	76 a2                	jbe    c0100a6a <runcmd+0x34>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100ac8:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100acb:	83 ec 08             	sub    $0x8,%esp
c0100ace:	50                   	push   %eax
c0100acf:	68 eb 5b 10 c0       	push   $0xc0105beb
c0100ad4:	e8 5e f8 ff ff       	call   c0100337 <cprintf>
c0100ad9:	83 c4 10             	add    $0x10,%esp
    return 0;
c0100adc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ae1:	c9                   	leave  
c0100ae2:	c3                   	ret    

c0100ae3 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100ae3:	55                   	push   %ebp
c0100ae4:	89 e5                	mov    %esp,%ebp
c0100ae6:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100ae9:	83 ec 0c             	sub    $0xc,%esp
c0100aec:	68 04 5c 10 c0       	push   $0xc0105c04
c0100af1:	e8 41 f8 ff ff       	call   c0100337 <cprintf>
c0100af6:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
c0100af9:	83 ec 0c             	sub    $0xc,%esp
c0100afc:	68 2c 5c 10 c0       	push   $0xc0105c2c
c0100b01:	e8 31 f8 ff ff       	call   c0100337 <cprintf>
c0100b06:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
c0100b09:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100b0d:	74 0e                	je     c0100b1d <kmonitor+0x3a>
        print_trapframe(tf);
c0100b0f:	83 ec 0c             	sub    $0xc,%esp
c0100b12:	ff 75 08             	pushl  0x8(%ebp)
c0100b15:	e8 eb 0d 00 00       	call   c0101905 <print_trapframe>
c0100b1a:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100b1d:	83 ec 0c             	sub    $0xc,%esp
c0100b20:	68 51 5c 10 c0       	push   $0xc0105c51
c0100b25:	e8 ff f6 ff ff       	call   c0100229 <readline>
c0100b2a:	83 c4 10             	add    $0x10,%esp
c0100b2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100b30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b34:	74 e7                	je     c0100b1d <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
c0100b36:	83 ec 08             	sub    $0x8,%esp
c0100b39:	ff 75 08             	pushl  0x8(%ebp)
c0100b3c:	ff 75 f4             	pushl  -0xc(%ebp)
c0100b3f:	e8 f2 fe ff ff       	call   c0100a36 <runcmd>
c0100b44:	83 c4 10             	add    $0x10,%esp
c0100b47:	85 c0                	test   %eax,%eax
c0100b49:	78 02                	js     c0100b4d <kmonitor+0x6a>
        if ((buf = readline("K> ")) != NULL) {
c0100b4b:	eb d0                	jmp    c0100b1d <kmonitor+0x3a>
                break;
c0100b4d:	90                   	nop
            }
        }
    }
}
c0100b4e:	90                   	nop
c0100b4f:	c9                   	leave  
c0100b50:	c3                   	ret    

c0100b51 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100b51:	55                   	push   %ebp
c0100b52:	89 e5                	mov    %esp,%ebp
c0100b54:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b57:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b5e:	eb 3b                	jmp    c0100b9b <mon_help+0x4a>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100b60:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b63:	89 d0                	mov    %edx,%eax
c0100b65:	01 c0                	add    %eax,%eax
c0100b67:	01 d0                	add    %edx,%eax
c0100b69:	c1 e0 02             	shl    $0x2,%eax
c0100b6c:	05 04 80 11 c0       	add    $0xc0118004,%eax
c0100b71:	8b 10                	mov    (%eax),%edx
c0100b73:	8b 4d f4             	mov    -0xc(%ebp),%ecx
c0100b76:	89 c8                	mov    %ecx,%eax
c0100b78:	01 c0                	add    %eax,%eax
c0100b7a:	01 c8                	add    %ecx,%eax
c0100b7c:	c1 e0 02             	shl    $0x2,%eax
c0100b7f:	05 00 80 11 c0       	add    $0xc0118000,%eax
c0100b84:	8b 00                	mov    (%eax),%eax
c0100b86:	83 ec 04             	sub    $0x4,%esp
c0100b89:	52                   	push   %edx
c0100b8a:	50                   	push   %eax
c0100b8b:	68 55 5c 10 c0       	push   $0xc0105c55
c0100b90:	e8 a2 f7 ff ff       	call   c0100337 <cprintf>
c0100b95:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b98:	ff 45 f4             	incl   -0xc(%ebp)
c0100b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b9e:	83 f8 02             	cmp    $0x2,%eax
c0100ba1:	76 bd                	jbe    c0100b60 <mon_help+0xf>
    }
    return 0;
c0100ba3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ba8:	c9                   	leave  
c0100ba9:	c3                   	ret    

c0100baa <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100baa:	55                   	push   %ebp
c0100bab:	89 e5                	mov    %esp,%ebp
c0100bad:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100bb0:	e8 85 fc ff ff       	call   c010083a <print_kerninfo>
    return 0;
c0100bb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bba:	c9                   	leave  
c0100bbb:	c3                   	ret    

c0100bbc <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100bbc:	55                   	push   %ebp
c0100bbd:	89 e5                	mov    %esp,%ebp
c0100bbf:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100bc2:	e8 b7 fd ff ff       	call   c010097e <print_stackframe>
    return 0;
c0100bc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bcc:	c9                   	leave  
c0100bcd:	c3                   	ret    

c0100bce <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100bce:	55                   	push   %ebp
c0100bcf:	89 e5                	mov    %esp,%ebp
c0100bd1:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
c0100bd4:	a1 20 b4 11 c0       	mov    0xc011b420,%eax
c0100bd9:	85 c0                	test   %eax,%eax
c0100bdb:	75 5f                	jne    c0100c3c <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
c0100bdd:	c7 05 20 b4 11 c0 01 	movl   $0x1,0xc011b420
c0100be4:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100be7:	8d 45 14             	lea    0x14(%ebp),%eax
c0100bea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100bed:	83 ec 04             	sub    $0x4,%esp
c0100bf0:	ff 75 0c             	pushl  0xc(%ebp)
c0100bf3:	ff 75 08             	pushl  0x8(%ebp)
c0100bf6:	68 5e 5c 10 c0       	push   $0xc0105c5e
c0100bfb:	e8 37 f7 ff ff       	call   c0100337 <cprintf>
c0100c00:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c0100c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c06:	83 ec 08             	sub    $0x8,%esp
c0100c09:	50                   	push   %eax
c0100c0a:	ff 75 10             	pushl  0x10(%ebp)
c0100c0d:	e8 fc f6 ff ff       	call   c010030e <vcprintf>
c0100c12:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c0100c15:	83 ec 0c             	sub    $0xc,%esp
c0100c18:	68 7a 5c 10 c0       	push   $0xc0105c7a
c0100c1d:	e8 15 f7 ff ff       	call   c0100337 <cprintf>
c0100c22:	83 c4 10             	add    $0x10,%esp
    
    cprintf("stack trackback:\n");
c0100c25:	83 ec 0c             	sub    $0xc,%esp
c0100c28:	68 7c 5c 10 c0       	push   $0xc0105c7c
c0100c2d:	e8 05 f7 ff ff       	call   c0100337 <cprintf>
c0100c32:	83 c4 10             	add    $0x10,%esp
    print_stackframe();
c0100c35:	e8 44 fd ff ff       	call   c010097e <print_stackframe>
c0100c3a:	eb 01                	jmp    c0100c3d <__panic+0x6f>
        goto panic_dead;
c0100c3c:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
c0100c3d:	e8 56 09 00 00       	call   c0101598 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100c42:	83 ec 0c             	sub    $0xc,%esp
c0100c45:	6a 00                	push   $0x0
c0100c47:	e8 97 fe ff ff       	call   c0100ae3 <kmonitor>
c0100c4c:	83 c4 10             	add    $0x10,%esp
c0100c4f:	eb f1                	jmp    c0100c42 <__panic+0x74>

c0100c51 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100c51:	55                   	push   %ebp
c0100c52:	89 e5                	mov    %esp,%ebp
c0100c54:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
c0100c57:	8d 45 14             	lea    0x14(%ebp),%eax
c0100c5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100c5d:	83 ec 04             	sub    $0x4,%esp
c0100c60:	ff 75 0c             	pushl  0xc(%ebp)
c0100c63:	ff 75 08             	pushl  0x8(%ebp)
c0100c66:	68 8e 5c 10 c0       	push   $0xc0105c8e
c0100c6b:	e8 c7 f6 ff ff       	call   c0100337 <cprintf>
c0100c70:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c0100c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c76:	83 ec 08             	sub    $0x8,%esp
c0100c79:	50                   	push   %eax
c0100c7a:	ff 75 10             	pushl  0x10(%ebp)
c0100c7d:	e8 8c f6 ff ff       	call   c010030e <vcprintf>
c0100c82:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c0100c85:	83 ec 0c             	sub    $0xc,%esp
c0100c88:	68 7a 5c 10 c0       	push   $0xc0105c7a
c0100c8d:	e8 a5 f6 ff ff       	call   c0100337 <cprintf>
c0100c92:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c0100c95:	90                   	nop
c0100c96:	c9                   	leave  
c0100c97:	c3                   	ret    

c0100c98 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100c98:	55                   	push   %ebp
c0100c99:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100c9b:	a1 20 b4 11 c0       	mov    0xc011b420,%eax
}
c0100ca0:	5d                   	pop    %ebp
c0100ca1:	c3                   	ret    

c0100ca2 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100ca2:	55                   	push   %ebp
c0100ca3:	89 e5                	mov    %esp,%ebp
c0100ca5:	83 ec 18             	sub    $0x18,%esp
c0100ca8:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
c0100cae:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100cb2:	8a 45 ed             	mov    -0x13(%ebp),%al
c0100cb5:	66 8b 55 ee          	mov    -0x12(%ebp),%dx
c0100cb9:	ee                   	out    %al,(%dx)
c0100cba:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100cc0:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100cc4:	8a 45 f1             	mov    -0xf(%ebp),%al
c0100cc7:	66 8b 55 f2          	mov    -0xe(%ebp),%dx
c0100ccb:	ee                   	out    %al,(%dx)
c0100ccc:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
c0100cd2:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
c0100cd6:	8a 45 f5             	mov    -0xb(%ebp),%al
c0100cd9:	66 8b 55 f6          	mov    -0xa(%ebp),%dx
c0100cdd:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100cde:	c7 05 0c bf 11 c0 00 	movl   $0x0,0xc011bf0c
c0100ce5:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100ce8:	83 ec 0c             	sub    $0xc,%esp
c0100ceb:	68 ac 5c 10 c0       	push   $0xc0105cac
c0100cf0:	e8 42 f6 ff ff       	call   c0100337 <cprintf>
c0100cf5:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
c0100cf8:	83 ec 0c             	sub    $0xc,%esp
c0100cfb:	6a 00                	push   $0x0
c0100cfd:	e8 f1 08 00 00       	call   c01015f3 <pic_enable>
c0100d02:	83 c4 10             	add    $0x10,%esp
}
c0100d05:	90                   	nop
c0100d06:	c9                   	leave  
c0100d07:	c3                   	ret    

c0100d08 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100d08:	55                   	push   %ebp
c0100d09:	89 e5                	mov    %esp,%ebp
c0100d0b:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100d0e:	9c                   	pushf  
c0100d0f:	58                   	pop    %eax
c0100d10:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100d16:	25 00 02 00 00       	and    $0x200,%eax
c0100d1b:	85 c0                	test   %eax,%eax
c0100d1d:	74 0c                	je     c0100d2b <__intr_save+0x23>
        intr_disable();
c0100d1f:	e8 74 08 00 00       	call   c0101598 <intr_disable>
        return 1;
c0100d24:	b8 01 00 00 00       	mov    $0x1,%eax
c0100d29:	eb 05                	jmp    c0100d30 <__intr_save+0x28>
    }
    return 0;
c0100d2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d30:	c9                   	leave  
c0100d31:	c3                   	ret    

c0100d32 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100d32:	55                   	push   %ebp
c0100d33:	89 e5                	mov    %esp,%ebp
c0100d35:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100d38:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100d3c:	74 05                	je     c0100d43 <__intr_restore+0x11>
        intr_enable();
c0100d3e:	e8 4e 08 00 00       	call   c0101591 <intr_enable>
    }
}
c0100d43:	90                   	nop
c0100d44:	c9                   	leave  
c0100d45:	c3                   	ret    

c0100d46 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100d46:	55                   	push   %ebp
c0100d47:	89 e5                	mov    %esp,%ebp
c0100d49:	83 ec 10             	sub    $0x10,%esp
c0100d4c:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100d52:	66 8b 45 f2          	mov    -0xe(%ebp),%ax
c0100d56:	89 c2                	mov    %eax,%edx
c0100d58:	ec                   	in     (%dx),%al
c0100d59:	88 45 f1             	mov    %al,-0xf(%ebp)
c0100d5c:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100d62:	66 8b 45 f6          	mov    -0xa(%ebp),%ax
c0100d66:	89 c2                	mov    %eax,%edx
c0100d68:	ec                   	in     (%dx),%al
c0100d69:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100d6c:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100d72:	66 8b 45 fa          	mov    -0x6(%ebp),%ax
c0100d76:	89 c2                	mov    %eax,%edx
c0100d78:	ec                   	in     (%dx),%al
c0100d79:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100d7c:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
c0100d82:	66 8b 45 fe          	mov    -0x2(%ebp),%ax
c0100d86:	89 c2                	mov    %eax,%edx
c0100d88:	ec                   	in     (%dx),%al
c0100d89:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100d8c:	90                   	nop
c0100d8d:	c9                   	leave  
c0100d8e:	c3                   	ret    

c0100d8f <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100d8f:	55                   	push   %ebp
c0100d90:	89 e5                	mov    %esp,%ebp
c0100d92:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100d95:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100d9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100d9f:	66 8b 00             	mov    (%eax),%ax
c0100da2:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100da6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100da9:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100dae:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100db1:	66 8b 00             	mov    (%eax),%ax
c0100db4:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100db8:	74 12                	je     c0100dcc <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100dba:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100dc1:	66 c7 05 46 b4 11 c0 	movw   $0x3b4,0xc011b446
c0100dc8:	b4 03 
c0100dca:	eb 13                	jmp    c0100ddf <cga_init+0x50>
    } else {
        *cp = was;
c0100dcc:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100dcf:	66 8b 45 fa          	mov    -0x6(%ebp),%ax
c0100dd3:	66 89 02             	mov    %ax,(%edx)
        addr_6845 = CGA_BASE;
c0100dd6:	66 c7 05 46 b4 11 c0 	movw   $0x3d4,0xc011b446
c0100ddd:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ddf:	66 a1 46 b4 11 c0    	mov    0xc011b446,%ax
c0100de5:	0f b7 c0             	movzwl %ax,%eax
c0100de8:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100dec:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100df0:	8a 45 e5             	mov    -0x1b(%ebp),%al
c0100df3:	66 8b 55 e6          	mov    -0x1a(%ebp),%dx
c0100df7:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100df8:	66 a1 46 b4 11 c0    	mov    0xc011b446,%ax
c0100dfe:	40                   	inc    %eax
c0100dff:	0f b7 c0             	movzwl %ax,%eax
c0100e02:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e06:	66 8b 45 ea          	mov    -0x16(%ebp),%ax
c0100e0a:	89 c2                	mov    %eax,%edx
c0100e0c:	ec                   	in     (%dx),%al
c0100e0d:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
c0100e10:	8a 45 e9             	mov    -0x17(%ebp),%al
c0100e13:	0f b6 c0             	movzbl %al,%eax
c0100e16:	c1 e0 08             	shl    $0x8,%eax
c0100e19:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100e1c:	66 a1 46 b4 11 c0    	mov    0xc011b446,%ax
c0100e22:	0f b7 c0             	movzwl %ax,%eax
c0100e25:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100e29:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e2d:	8a 45 ed             	mov    -0x13(%ebp),%al
c0100e30:	66 8b 55 ee          	mov    -0x12(%ebp),%dx
c0100e34:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100e35:	66 a1 46 b4 11 c0    	mov    0xc011b446,%ax
c0100e3b:	40                   	inc    %eax
c0100e3c:	0f b7 c0             	movzwl %ax,%eax
c0100e3f:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e43:	66 8b 45 f2          	mov    -0xe(%ebp),%ax
c0100e47:	89 c2                	mov    %eax,%edx
c0100e49:	ec                   	in     (%dx),%al
c0100e4a:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
c0100e4d:	8a 45 f1             	mov    -0xf(%ebp),%al
c0100e50:	0f b6 c0             	movzbl %al,%eax
c0100e53:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100e56:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e59:	a3 40 b4 11 c0       	mov    %eax,0xc011b440
    crt_pos = pos;
c0100e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100e61:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
}
c0100e67:	90                   	nop
c0100e68:	c9                   	leave  
c0100e69:	c3                   	ret    

c0100e6a <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100e6a:	55                   	push   %ebp
c0100e6b:	89 e5                	mov    %esp,%ebp
c0100e6d:	83 ec 38             	sub    $0x38,%esp
c0100e70:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
c0100e76:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e7a:	8a 45 d1             	mov    -0x2f(%ebp),%al
c0100e7d:	66 8b 55 d2          	mov    -0x2e(%ebp),%dx
c0100e81:	ee                   	out    %al,(%dx)
c0100e82:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
c0100e88:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
c0100e8c:	8a 45 d5             	mov    -0x2b(%ebp),%al
c0100e8f:	66 8b 55 d6          	mov    -0x2a(%ebp),%dx
c0100e93:	ee                   	out    %al,(%dx)
c0100e94:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
c0100e9a:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
c0100e9e:	8a 45 d9             	mov    -0x27(%ebp),%al
c0100ea1:	66 8b 55 da          	mov    -0x26(%ebp),%dx
c0100ea5:	ee                   	out    %al,(%dx)
c0100ea6:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100eac:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
c0100eb0:	8a 45 dd             	mov    -0x23(%ebp),%al
c0100eb3:	66 8b 55 de          	mov    -0x22(%ebp),%dx
c0100eb7:	ee                   	out    %al,(%dx)
c0100eb8:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
c0100ebe:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
c0100ec2:	8a 45 e1             	mov    -0x1f(%ebp),%al
c0100ec5:	66 8b 55 e2          	mov    -0x1e(%ebp),%dx
c0100ec9:	ee                   	out    %al,(%dx)
c0100eca:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
c0100ed0:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
c0100ed4:	8a 45 e5             	mov    -0x1b(%ebp),%al
c0100ed7:	66 8b 55 e6          	mov    -0x1a(%ebp),%dx
c0100edb:	ee                   	out    %al,(%dx)
c0100edc:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100ee2:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
c0100ee6:	8a 45 e9             	mov    -0x17(%ebp),%al
c0100ee9:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
c0100eed:	ee                   	out    %al,(%dx)
c0100eee:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ef4:	66 8b 45 ee          	mov    -0x12(%ebp),%ax
c0100ef8:	89 c2                	mov    %eax,%edx
c0100efa:	ec                   	in     (%dx),%al
c0100efb:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100efe:	8a 45 ed             	mov    -0x13(%ebp),%al
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100f01:	3c ff                	cmp    $0xff,%al
c0100f03:	0f 95 c0             	setne  %al
c0100f06:	0f b6 c0             	movzbl %al,%eax
c0100f09:	a3 48 b4 11 c0       	mov    %eax,0xc011b448
c0100f0e:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f14:	66 8b 45 f2          	mov    -0xe(%ebp),%ax
c0100f18:	89 c2                	mov    %eax,%edx
c0100f1a:	ec                   	in     (%dx),%al
c0100f1b:	88 45 f1             	mov    %al,-0xf(%ebp)
c0100f1e:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0100f24:	66 8b 45 f6          	mov    -0xa(%ebp),%ax
c0100f28:	89 c2                	mov    %eax,%edx
c0100f2a:	ec                   	in     (%dx),%al
c0100f2b:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0100f2e:	a1 48 b4 11 c0       	mov    0xc011b448,%eax
c0100f33:	85 c0                	test   %eax,%eax
c0100f35:	74 0d                	je     c0100f44 <serial_init+0xda>
        pic_enable(IRQ_COM1);
c0100f37:	83 ec 0c             	sub    $0xc,%esp
c0100f3a:	6a 04                	push   $0x4
c0100f3c:	e8 b2 06 00 00       	call   c01015f3 <pic_enable>
c0100f41:	83 c4 10             	add    $0x10,%esp
    }
}
c0100f44:	90                   	nop
c0100f45:	c9                   	leave  
c0100f46:	c3                   	ret    

c0100f47 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0100f47:	55                   	push   %ebp
c0100f48:	89 e5                	mov    %esp,%ebp
c0100f4a:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0100f4d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0100f54:	eb 08                	jmp    c0100f5e <lpt_putc_sub+0x17>
        delay();
c0100f56:	e8 eb fd ff ff       	call   c0100d46 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0100f5b:	ff 45 fc             	incl   -0x4(%ebp)
c0100f5e:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0100f64:	66 8b 45 fa          	mov    -0x6(%ebp),%ax
c0100f68:	89 c2                	mov    %eax,%edx
c0100f6a:	ec                   	in     (%dx),%al
c0100f6b:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0100f6e:	8a 45 f9             	mov    -0x7(%ebp),%al
c0100f71:	84 c0                	test   %al,%al
c0100f73:	78 09                	js     c0100f7e <lpt_putc_sub+0x37>
c0100f75:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0100f7c:	7e d8                	jle    c0100f56 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
c0100f7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100f81:	0f b6 c0             	movzbl %al,%eax
c0100f84:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
c0100f8a:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f8d:	8a 45 ed             	mov    -0x13(%ebp),%al
c0100f90:	66 8b 55 ee          	mov    -0x12(%ebp),%dx
c0100f94:	ee                   	out    %al,(%dx)
c0100f95:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0100f9b:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c0100f9f:	8a 45 f1             	mov    -0xf(%ebp),%al
c0100fa2:	66 8b 55 f2          	mov    -0xe(%ebp),%dx
c0100fa6:	ee                   	out    %al,(%dx)
c0100fa7:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c0100fad:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
c0100fb1:	8a 45 f5             	mov    -0xb(%ebp),%al
c0100fb4:	66 8b 55 f6          	mov    -0xa(%ebp),%dx
c0100fb8:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c0100fb9:	90                   	nop
c0100fba:	c9                   	leave  
c0100fbb:	c3                   	ret    

c0100fbc <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c0100fbc:	55                   	push   %ebp
c0100fbd:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c0100fbf:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0100fc3:	74 0d                	je     c0100fd2 <lpt_putc+0x16>
        lpt_putc_sub(c);
c0100fc5:	ff 75 08             	pushl  0x8(%ebp)
c0100fc8:	e8 7a ff ff ff       	call   c0100f47 <lpt_putc_sub>
c0100fcd:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c0100fd0:	eb 1e                	jmp    c0100ff0 <lpt_putc+0x34>
        lpt_putc_sub('\b');
c0100fd2:	6a 08                	push   $0x8
c0100fd4:	e8 6e ff ff ff       	call   c0100f47 <lpt_putc_sub>
c0100fd9:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
c0100fdc:	6a 20                	push   $0x20
c0100fde:	e8 64 ff ff ff       	call   c0100f47 <lpt_putc_sub>
c0100fe3:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
c0100fe6:	6a 08                	push   $0x8
c0100fe8:	e8 5a ff ff ff       	call   c0100f47 <lpt_putc_sub>
c0100fed:	83 c4 04             	add    $0x4,%esp
}
c0100ff0:	90                   	nop
c0100ff1:	c9                   	leave  
c0100ff2:	c3                   	ret    

c0100ff3 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0100ff3:	55                   	push   %ebp
c0100ff4:	89 e5                	mov    %esp,%ebp
c0100ff6:	53                   	push   %ebx
c0100ff7:	83 ec 24             	sub    $0x24,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0100ffa:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ffd:	b0 00                	mov    $0x0,%al
c0100fff:	85 c0                	test   %eax,%eax
c0101001:	75 07                	jne    c010100a <cga_putc+0x17>
        c |= 0x0700;
c0101003:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c010100a:	8b 45 08             	mov    0x8(%ebp),%eax
c010100d:	0f b6 c0             	movzbl %al,%eax
c0101010:	83 f8 0a             	cmp    $0xa,%eax
c0101013:	74 4a                	je     c010105f <cga_putc+0x6c>
c0101015:	83 f8 0d             	cmp    $0xd,%eax
c0101018:	74 54                	je     c010106e <cga_putc+0x7b>
c010101a:	83 f8 08             	cmp    $0x8,%eax
c010101d:	75 77                	jne    c0101096 <cga_putc+0xa3>
    case '\b':
        if (crt_pos > 0) {
c010101f:	66 a1 44 b4 11 c0    	mov    0xc011b444,%ax
c0101025:	66 85 c0             	test   %ax,%ax
c0101028:	0f 84 8e 00 00 00    	je     c01010bc <cga_putc+0xc9>
            crt_pos --;
c010102e:	66 a1 44 b4 11 c0    	mov    0xc011b444,%ax
c0101034:	48                   	dec    %eax
c0101035:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c010103b:	8b 45 08             	mov    0x8(%ebp),%eax
c010103e:	b0 00                	mov    $0x0,%al
c0101040:	83 c8 20             	or     $0x20,%eax
c0101043:	89 c2                	mov    %eax,%edx
c0101045:	8b 0d 40 b4 11 c0    	mov    0xc011b440,%ecx
c010104b:	66 a1 44 b4 11 c0    	mov    0xc011b444,%ax
c0101051:	0f b7 c0             	movzwl %ax,%eax
c0101054:	01 c0                	add    %eax,%eax
c0101056:	01 c1                	add    %eax,%ecx
c0101058:	89 d0                	mov    %edx,%eax
c010105a:	66 89 01             	mov    %ax,(%ecx)
        }
        break;
c010105d:	eb 5d                	jmp    c01010bc <cga_putc+0xc9>
    case '\n':
        crt_pos += CRT_COLS;
c010105f:	66 a1 44 b4 11 c0    	mov    0xc011b444,%ax
c0101065:	83 c0 50             	add    $0x50,%eax
c0101068:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c010106e:	66 8b 0d 44 b4 11 c0 	mov    0xc011b444,%cx
c0101075:	66 a1 44 b4 11 c0    	mov    0xc011b444,%ax
c010107b:	bb 50 00 00 00       	mov    $0x50,%ebx
c0101080:	ba 00 00 00 00       	mov    $0x0,%edx
c0101085:	66 f7 f3             	div    %bx
c0101088:	89 d0                	mov    %edx,%eax
c010108a:	29 c1                	sub    %eax,%ecx
c010108c:	89 c8                	mov    %ecx,%eax
c010108e:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
        break;
c0101094:	eb 27                	jmp    c01010bd <cga_putc+0xca>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c0101096:	8b 0d 40 b4 11 c0    	mov    0xc011b440,%ecx
c010109c:	66 a1 44 b4 11 c0    	mov    0xc011b444,%ax
c01010a2:	8d 50 01             	lea    0x1(%eax),%edx
c01010a5:	66 89 15 44 b4 11 c0 	mov    %dx,0xc011b444
c01010ac:	0f b7 c0             	movzwl %ax,%eax
c01010af:	01 c0                	add    %eax,%eax
c01010b1:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01010b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01010b7:	66 89 02             	mov    %ax,(%edx)
        break;
c01010ba:	eb 01                	jmp    c01010bd <cga_putc+0xca>
        break;
c01010bc:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01010bd:	66 a1 44 b4 11 c0    	mov    0xc011b444,%ax
c01010c3:	66 3d cf 07          	cmp    $0x7cf,%ax
c01010c7:	76 58                	jbe    c0101121 <cga_putc+0x12e>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01010c9:	a1 40 b4 11 c0       	mov    0xc011b440,%eax
c01010ce:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01010d4:	a1 40 b4 11 c0       	mov    0xc011b440,%eax
c01010d9:	83 ec 04             	sub    $0x4,%esp
c01010dc:	68 00 0f 00 00       	push   $0xf00
c01010e1:	52                   	push   %edx
c01010e2:	50                   	push   %eax
c01010e3:	e8 86 47 00 00       	call   c010586e <memmove>
c01010e8:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01010eb:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c01010f2:	eb 15                	jmp    c0101109 <cga_putc+0x116>
            crt_buf[i] = 0x0700 | ' ';
c01010f4:	8b 15 40 b4 11 c0    	mov    0xc011b440,%edx
c01010fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01010fd:	01 c0                	add    %eax,%eax
c01010ff:	01 d0                	add    %edx,%eax
c0101101:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101106:	ff 45 f4             	incl   -0xc(%ebp)
c0101109:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101110:	7e e2                	jle    c01010f4 <cga_putc+0x101>
        }
        crt_pos -= CRT_COLS;
c0101112:	66 a1 44 b4 11 c0    	mov    0xc011b444,%ax
c0101118:	83 e8 50             	sub    $0x50,%eax
c010111b:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101121:	66 a1 46 b4 11 c0    	mov    0xc011b446,%ax
c0101127:	0f b7 c0             	movzwl %ax,%eax
c010112a:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c010112e:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
c0101132:	8a 45 e5             	mov    -0x1b(%ebp),%al
c0101135:	66 8b 55 e6          	mov    -0x1a(%ebp),%dx
c0101139:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c010113a:	66 a1 44 b4 11 c0    	mov    0xc011b444,%ax
c0101140:	66 c1 e8 08          	shr    $0x8,%ax
c0101144:	0f b6 d0             	movzbl %al,%edx
c0101147:	66 a1 46 b4 11 c0    	mov    0xc011b446,%ax
c010114d:	40                   	inc    %eax
c010114e:	0f b7 c0             	movzwl %ax,%eax
c0101151:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0101155:	88 55 e9             	mov    %dl,-0x17(%ebp)
c0101158:	8a 45 e9             	mov    -0x17(%ebp),%al
c010115b:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
c010115f:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101160:	66 a1 46 b4 11 c0    	mov    0xc011b446,%ax
c0101166:	0f b7 c0             	movzwl %ax,%eax
c0101169:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c010116d:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
c0101171:	8a 45 ed             	mov    -0x13(%ebp),%al
c0101174:	66 8b 55 ee          	mov    -0x12(%ebp),%dx
c0101178:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101179:	66 a1 44 b4 11 c0    	mov    0xc011b444,%ax
c010117f:	0f b6 d0             	movzbl %al,%edx
c0101182:	66 a1 46 b4 11 c0    	mov    0xc011b446,%ax
c0101188:	40                   	inc    %eax
c0101189:	0f b7 c0             	movzwl %ax,%eax
c010118c:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101190:	88 55 f1             	mov    %dl,-0xf(%ebp)
c0101193:	8a 45 f1             	mov    -0xf(%ebp),%al
c0101196:	66 8b 55 f2          	mov    -0xe(%ebp),%dx
c010119a:	ee                   	out    %al,(%dx)
}
c010119b:	90                   	nop
c010119c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010119f:	c9                   	leave  
c01011a0:	c3                   	ret    

c01011a1 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01011a1:	55                   	push   %ebp
c01011a2:	89 e5                	mov    %esp,%ebp
c01011a4:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01011a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01011ae:	eb 08                	jmp    c01011b8 <serial_putc_sub+0x17>
        delay();
c01011b0:	e8 91 fb ff ff       	call   c0100d46 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01011b5:	ff 45 fc             	incl   -0x4(%ebp)
c01011b8:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01011be:	66 8b 45 fa          	mov    -0x6(%ebp),%ax
c01011c2:	89 c2                	mov    %eax,%edx
c01011c4:	ec                   	in     (%dx),%al
c01011c5:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01011c8:	8a 45 f9             	mov    -0x7(%ebp),%al
c01011cb:	0f b6 c0             	movzbl %al,%eax
c01011ce:	83 e0 20             	and    $0x20,%eax
c01011d1:	85 c0                	test   %eax,%eax
c01011d3:	75 09                	jne    c01011de <serial_putc_sub+0x3d>
c01011d5:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01011dc:	7e d2                	jle    c01011b0 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
c01011de:	8b 45 08             	mov    0x8(%ebp),%eax
c01011e1:	0f b6 c0             	movzbl %al,%eax
c01011e4:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c01011ea:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01011ed:	8a 45 f5             	mov    -0xb(%ebp),%al
c01011f0:	66 8b 55 f6          	mov    -0xa(%ebp),%dx
c01011f4:	ee                   	out    %al,(%dx)
}
c01011f5:	90                   	nop
c01011f6:	c9                   	leave  
c01011f7:	c3                   	ret    

c01011f8 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c01011f8:	55                   	push   %ebp
c01011f9:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c01011fb:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01011ff:	74 0d                	je     c010120e <serial_putc+0x16>
        serial_putc_sub(c);
c0101201:	ff 75 08             	pushl  0x8(%ebp)
c0101204:	e8 98 ff ff ff       	call   c01011a1 <serial_putc_sub>
c0101209:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c010120c:	eb 1e                	jmp    c010122c <serial_putc+0x34>
        serial_putc_sub('\b');
c010120e:	6a 08                	push   $0x8
c0101210:	e8 8c ff ff ff       	call   c01011a1 <serial_putc_sub>
c0101215:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
c0101218:	6a 20                	push   $0x20
c010121a:	e8 82 ff ff ff       	call   c01011a1 <serial_putc_sub>
c010121f:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
c0101222:	6a 08                	push   $0x8
c0101224:	e8 78 ff ff ff       	call   c01011a1 <serial_putc_sub>
c0101229:	83 c4 04             	add    $0x4,%esp
}
c010122c:	90                   	nop
c010122d:	c9                   	leave  
c010122e:	c3                   	ret    

c010122f <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c010122f:	55                   	push   %ebp
c0101230:	89 e5                	mov    %esp,%ebp
c0101232:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101235:	eb 33                	jmp    c010126a <cons_intr+0x3b>
        if (c != 0) {
c0101237:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010123b:	74 2d                	je     c010126a <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c010123d:	a1 64 b6 11 c0       	mov    0xc011b664,%eax
c0101242:	8d 50 01             	lea    0x1(%eax),%edx
c0101245:	89 15 64 b6 11 c0    	mov    %edx,0xc011b664
c010124b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010124e:	88 90 60 b4 11 c0    	mov    %dl,-0x3fee4ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101254:	a1 64 b6 11 c0       	mov    0xc011b664,%eax
c0101259:	3d 00 02 00 00       	cmp    $0x200,%eax
c010125e:	75 0a                	jne    c010126a <cons_intr+0x3b>
                cons.wpos = 0;
c0101260:	c7 05 64 b6 11 c0 00 	movl   $0x0,0xc011b664
c0101267:	00 00 00 
    while ((c = (*proc)()) != -1) {
c010126a:	8b 45 08             	mov    0x8(%ebp),%eax
c010126d:	ff d0                	call   *%eax
c010126f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101272:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c0101276:	75 bf                	jne    c0101237 <cons_intr+0x8>
            }
        }
    }
}
c0101278:	90                   	nop
c0101279:	c9                   	leave  
c010127a:	c3                   	ret    

c010127b <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c010127b:	55                   	push   %ebp
c010127c:	89 e5                	mov    %esp,%ebp
c010127e:	83 ec 10             	sub    $0x10,%esp
c0101281:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101287:	66 8b 45 fa          	mov    -0x6(%ebp),%ax
c010128b:	89 c2                	mov    %eax,%edx
c010128d:	ec                   	in     (%dx),%al
c010128e:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101291:	8a 45 f9             	mov    -0x7(%ebp),%al
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c0101294:	0f b6 c0             	movzbl %al,%eax
c0101297:	83 e0 01             	and    $0x1,%eax
c010129a:	85 c0                	test   %eax,%eax
c010129c:	75 07                	jne    c01012a5 <serial_proc_data+0x2a>
        return -1;
c010129e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01012a3:	eb 29                	jmp    c01012ce <serial_proc_data+0x53>
c01012a5:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012ab:	66 8b 45 f6          	mov    -0xa(%ebp),%ax
c01012af:	89 c2                	mov    %eax,%edx
c01012b1:	ec                   	in     (%dx),%al
c01012b2:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01012b5:	8a 45 f5             	mov    -0xb(%ebp),%al
    }
    int c = inb(COM1 + COM_RX);
c01012b8:	0f b6 c0             	movzbl %al,%eax
c01012bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01012be:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01012c2:	75 07                	jne    c01012cb <serial_proc_data+0x50>
        c = '\b';
c01012c4:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01012cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01012ce:	c9                   	leave  
c01012cf:	c3                   	ret    

c01012d0 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01012d0:	55                   	push   %ebp
c01012d1:	89 e5                	mov    %esp,%ebp
c01012d3:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
c01012d6:	a1 48 b4 11 c0       	mov    0xc011b448,%eax
c01012db:	85 c0                	test   %eax,%eax
c01012dd:	74 10                	je     c01012ef <serial_intr+0x1f>
        cons_intr(serial_proc_data);
c01012df:	83 ec 0c             	sub    $0xc,%esp
c01012e2:	68 7b 12 10 c0       	push   $0xc010127b
c01012e7:	e8 43 ff ff ff       	call   c010122f <cons_intr>
c01012ec:	83 c4 10             	add    $0x10,%esp
    }
}
c01012ef:	90                   	nop
c01012f0:	c9                   	leave  
c01012f1:	c3                   	ret    

c01012f2 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c01012f2:	55                   	push   %ebp
c01012f3:	89 e5                	mov    %esp,%ebp
c01012f5:	83 ec 28             	sub    $0x28,%esp
c01012f8:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101301:	89 c2                	mov    %eax,%edx
c0101303:	ec                   	in     (%dx),%al
c0101304:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101307:	8a 45 ef             	mov    -0x11(%ebp),%al
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c010130a:	0f b6 c0             	movzbl %al,%eax
c010130d:	83 e0 01             	and    $0x1,%eax
c0101310:	85 c0                	test   %eax,%eax
c0101312:	75 0a                	jne    c010131e <kbd_proc_data+0x2c>
        return -1;
c0101314:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101319:	e9 52 01 00 00       	jmp    c0101470 <kbd_proc_data+0x17e>
c010131e:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101324:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101327:	89 c2                	mov    %eax,%edx
c0101329:	ec                   	in     (%dx),%al
c010132a:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010132d:	8a 45 eb             	mov    -0x15(%ebp),%al
    }

    data = inb(KBDATAP);
c0101330:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101333:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101337:	75 17                	jne    c0101350 <kbd_proc_data+0x5e>
        // E0 escape character
        shift |= E0ESC;
c0101339:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c010133e:	83 c8 40             	or     $0x40,%eax
c0101341:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
        return 0;
c0101346:	b8 00 00 00 00       	mov    $0x0,%eax
c010134b:	e9 20 01 00 00       	jmp    c0101470 <kbd_proc_data+0x17e>
    } else if (data & 0x80) {
c0101350:	8a 45 f3             	mov    -0xd(%ebp),%al
c0101353:	84 c0                	test   %al,%al
c0101355:	79 44                	jns    c010139b <kbd_proc_data+0xa9>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101357:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c010135c:	83 e0 40             	and    $0x40,%eax
c010135f:	85 c0                	test   %eax,%eax
c0101361:	75 08                	jne    c010136b <kbd_proc_data+0x79>
c0101363:	8a 45 f3             	mov    -0xd(%ebp),%al
c0101366:	83 e0 7f             	and    $0x7f,%eax
c0101369:	eb 03                	jmp    c010136e <kbd_proc_data+0x7c>
c010136b:	8a 45 f3             	mov    -0xd(%ebp),%al
c010136e:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101371:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101375:	8a 80 40 80 11 c0    	mov    -0x3fee7fc0(%eax),%al
c010137b:	83 c8 40             	or     $0x40,%eax
c010137e:	0f b6 c0             	movzbl %al,%eax
c0101381:	f7 d0                	not    %eax
c0101383:	89 c2                	mov    %eax,%edx
c0101385:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c010138a:	21 d0                	and    %edx,%eax
c010138c:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
        return 0;
c0101391:	b8 00 00 00 00       	mov    $0x0,%eax
c0101396:	e9 d5 00 00 00       	jmp    c0101470 <kbd_proc_data+0x17e>
    } else if (shift & E0ESC) {
c010139b:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c01013a0:	83 e0 40             	and    $0x40,%eax
c01013a3:	85 c0                	test   %eax,%eax
c01013a5:	74 11                	je     c01013b8 <kbd_proc_data+0xc6>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01013a7:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01013ab:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c01013b0:	83 e0 bf             	and    $0xffffffbf,%eax
c01013b3:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
    }

    shift |= shiftcode[data];
c01013b8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01013bc:	8a 80 40 80 11 c0    	mov    -0x3fee7fc0(%eax),%al
c01013c2:	0f b6 d0             	movzbl %al,%edx
c01013c5:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c01013ca:	09 d0                	or     %edx,%eax
c01013cc:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
    shift ^= togglecode[data];
c01013d1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01013d5:	8a 80 40 81 11 c0    	mov    -0x3fee7ec0(%eax),%al
c01013db:	0f b6 d0             	movzbl %al,%edx
c01013de:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c01013e3:	31 d0                	xor    %edx,%eax
c01013e5:	a3 68 b6 11 c0       	mov    %eax,0xc011b668

    c = charcode[shift & (CTL | SHIFT)][data];
c01013ea:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c01013ef:	83 e0 03             	and    $0x3,%eax
c01013f2:	8b 14 85 40 85 11 c0 	mov    -0x3fee7ac0(,%eax,4),%edx
c01013f9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01013fd:	01 d0                	add    %edx,%eax
c01013ff:	8a 00                	mov    (%eax),%al
c0101401:	0f b6 c0             	movzbl %al,%eax
c0101404:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101407:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c010140c:	83 e0 08             	and    $0x8,%eax
c010140f:	85 c0                	test   %eax,%eax
c0101411:	74 22                	je     c0101435 <kbd_proc_data+0x143>
        if ('a' <= c && c <= 'z')
c0101413:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101417:	7e 0c                	jle    c0101425 <kbd_proc_data+0x133>
c0101419:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c010141d:	7f 06                	jg     c0101425 <kbd_proc_data+0x133>
            c += 'A' - 'a';
c010141f:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101423:	eb 10                	jmp    c0101435 <kbd_proc_data+0x143>
        else if ('A' <= c && c <= 'Z')
c0101425:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101429:	7e 0a                	jle    c0101435 <kbd_proc_data+0x143>
c010142b:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c010142f:	7f 04                	jg     c0101435 <kbd_proc_data+0x143>
            c += 'a' - 'A';
c0101431:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101435:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c010143a:	f7 d0                	not    %eax
c010143c:	83 e0 06             	and    $0x6,%eax
c010143f:	85 c0                	test   %eax,%eax
c0101441:	75 2a                	jne    c010146d <kbd_proc_data+0x17b>
c0101443:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c010144a:	75 21                	jne    c010146d <kbd_proc_data+0x17b>
        cprintf("Rebooting!\n");
c010144c:	83 ec 0c             	sub    $0xc,%esp
c010144f:	68 c7 5c 10 c0       	push   $0xc0105cc7
c0101454:	e8 de ee ff ff       	call   c0100337 <cprintf>
c0101459:	83 c4 10             	add    $0x10,%esp
c010145c:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101462:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101466:	8a 45 e7             	mov    -0x19(%ebp),%al
c0101469:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010146c:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c010146d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101470:	c9                   	leave  
c0101471:	c3                   	ret    

c0101472 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c0101472:	55                   	push   %ebp
c0101473:	89 e5                	mov    %esp,%ebp
c0101475:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
c0101478:	83 ec 0c             	sub    $0xc,%esp
c010147b:	68 f2 12 10 c0       	push   $0xc01012f2
c0101480:	e8 aa fd ff ff       	call   c010122f <cons_intr>
c0101485:	83 c4 10             	add    $0x10,%esp
}
c0101488:	90                   	nop
c0101489:	c9                   	leave  
c010148a:	c3                   	ret    

c010148b <kbd_init>:

static void
kbd_init(void) {
c010148b:	55                   	push   %ebp
c010148c:	89 e5                	mov    %esp,%ebp
c010148e:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
c0101491:	e8 dc ff ff ff       	call   c0101472 <kbd_intr>
    pic_enable(IRQ_KBD);
c0101496:	83 ec 0c             	sub    $0xc,%esp
c0101499:	6a 01                	push   $0x1
c010149b:	e8 53 01 00 00       	call   c01015f3 <pic_enable>
c01014a0:	83 c4 10             	add    $0x10,%esp
}
c01014a3:	90                   	nop
c01014a4:	c9                   	leave  
c01014a5:	c3                   	ret    

c01014a6 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01014a6:	55                   	push   %ebp
c01014a7:	89 e5                	mov    %esp,%ebp
c01014a9:	83 ec 08             	sub    $0x8,%esp
    cga_init();
c01014ac:	e8 de f8 ff ff       	call   c0100d8f <cga_init>
    serial_init();
c01014b1:	e8 b4 f9 ff ff       	call   c0100e6a <serial_init>
    kbd_init();
c01014b6:	e8 d0 ff ff ff       	call   c010148b <kbd_init>
    if (!serial_exists) {
c01014bb:	a1 48 b4 11 c0       	mov    0xc011b448,%eax
c01014c0:	85 c0                	test   %eax,%eax
c01014c2:	75 10                	jne    c01014d4 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
c01014c4:	83 ec 0c             	sub    $0xc,%esp
c01014c7:	68 d3 5c 10 c0       	push   $0xc0105cd3
c01014cc:	e8 66 ee ff ff       	call   c0100337 <cprintf>
c01014d1:	83 c4 10             	add    $0x10,%esp
    }
}
c01014d4:	90                   	nop
c01014d5:	c9                   	leave  
c01014d6:	c3                   	ret    

c01014d7 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01014d7:	55                   	push   %ebp
c01014d8:	89 e5                	mov    %esp,%ebp
c01014da:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01014dd:	e8 26 f8 ff ff       	call   c0100d08 <__intr_save>
c01014e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c01014e5:	83 ec 0c             	sub    $0xc,%esp
c01014e8:	ff 75 08             	pushl  0x8(%ebp)
c01014eb:	e8 cc fa ff ff       	call   c0100fbc <lpt_putc>
c01014f0:	83 c4 10             	add    $0x10,%esp
        cga_putc(c);
c01014f3:	83 ec 0c             	sub    $0xc,%esp
c01014f6:	ff 75 08             	pushl  0x8(%ebp)
c01014f9:	e8 f5 fa ff ff       	call   c0100ff3 <cga_putc>
c01014fe:	83 c4 10             	add    $0x10,%esp
        serial_putc(c);
c0101501:	83 ec 0c             	sub    $0xc,%esp
c0101504:	ff 75 08             	pushl  0x8(%ebp)
c0101507:	e8 ec fc ff ff       	call   c01011f8 <serial_putc>
c010150c:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c010150f:	83 ec 0c             	sub    $0xc,%esp
c0101512:	ff 75 f4             	pushl  -0xc(%ebp)
c0101515:	e8 18 f8 ff ff       	call   c0100d32 <__intr_restore>
c010151a:	83 c4 10             	add    $0x10,%esp
}
c010151d:	90                   	nop
c010151e:	c9                   	leave  
c010151f:	c3                   	ret    

c0101520 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101520:	55                   	push   %ebp
c0101521:	89 e5                	mov    %esp,%ebp
c0101523:	83 ec 18             	sub    $0x18,%esp
    int c = 0;
c0101526:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c010152d:	e8 d6 f7 ff ff       	call   c0100d08 <__intr_save>
c0101532:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101535:	e8 96 fd ff ff       	call   c01012d0 <serial_intr>
        kbd_intr();
c010153a:	e8 33 ff ff ff       	call   c0101472 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010153f:	8b 15 60 b6 11 c0    	mov    0xc011b660,%edx
c0101545:	a1 64 b6 11 c0       	mov    0xc011b664,%eax
c010154a:	39 c2                	cmp    %eax,%edx
c010154c:	74 30                	je     c010157e <cons_getc+0x5e>
            c = cons.buf[cons.rpos ++];
c010154e:	a1 60 b6 11 c0       	mov    0xc011b660,%eax
c0101553:	8d 50 01             	lea    0x1(%eax),%edx
c0101556:	89 15 60 b6 11 c0    	mov    %edx,0xc011b660
c010155c:	8a 80 60 b4 11 c0    	mov    -0x3fee4ba0(%eax),%al
c0101562:	0f b6 c0             	movzbl %al,%eax
c0101565:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101568:	a1 60 b6 11 c0       	mov    0xc011b660,%eax
c010156d:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101572:	75 0a                	jne    c010157e <cons_getc+0x5e>
                cons.rpos = 0;
c0101574:	c7 05 60 b6 11 c0 00 	movl   $0x0,0xc011b660
c010157b:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c010157e:	83 ec 0c             	sub    $0xc,%esp
c0101581:	ff 75 f0             	pushl  -0x10(%ebp)
c0101584:	e8 a9 f7 ff ff       	call   c0100d32 <__intr_restore>
c0101589:	83 c4 10             	add    $0x10,%esp
    return c;
c010158c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010158f:	c9                   	leave  
c0101590:	c3                   	ret    

c0101591 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101591:	55                   	push   %ebp
c0101592:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c0101594:	fb                   	sti    
    sti();
}
c0101595:	90                   	nop
c0101596:	5d                   	pop    %ebp
c0101597:	c3                   	ret    

c0101598 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101598:	55                   	push   %ebp
c0101599:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c010159b:	fa                   	cli    
    cli();
}
c010159c:	90                   	nop
c010159d:	5d                   	pop    %ebp
c010159e:	c3                   	ret    

c010159f <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c010159f:	55                   	push   %ebp
c01015a0:	89 e5                	mov    %esp,%ebp
c01015a2:	83 ec 14             	sub    $0x14,%esp
c01015a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01015a8:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01015ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01015af:	66 a3 50 85 11 c0    	mov    %ax,0xc0118550
    if (did_init) {
c01015b5:	a1 6c b6 11 c0       	mov    0xc011b66c,%eax
c01015ba:	85 c0                	test   %eax,%eax
c01015bc:	74 32                	je     c01015f0 <pic_setmask+0x51>
        outb(IO_PIC1 + 1, mask);
c01015be:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01015c1:	0f b6 c0             	movzbl %al,%eax
c01015c4:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c01015ca:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015cd:	8a 45 f9             	mov    -0x7(%ebp),%al
c01015d0:	66 8b 55 fa          	mov    -0x6(%ebp),%dx
c01015d4:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01015d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01015d8:	66 c1 e8 08          	shr    $0x8,%ax
c01015dc:	0f b6 c0             	movzbl %al,%eax
c01015df:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
c01015e5:	88 45 fd             	mov    %al,-0x3(%ebp)
c01015e8:	8a 45 fd             	mov    -0x3(%ebp),%al
c01015eb:	66 8b 55 fe          	mov    -0x2(%ebp),%dx
c01015ef:	ee                   	out    %al,(%dx)
    }
}
c01015f0:	90                   	nop
c01015f1:	c9                   	leave  
c01015f2:	c3                   	ret    

c01015f3 <pic_enable>:

void
pic_enable(unsigned int irq) {
c01015f3:	55                   	push   %ebp
c01015f4:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
c01015f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01015f9:	ba 01 00 00 00       	mov    $0x1,%edx
c01015fe:	88 c1                	mov    %al,%cl
c0101600:	d3 e2                	shl    %cl,%edx
c0101602:	89 d0                	mov    %edx,%eax
c0101604:	f7 d0                	not    %eax
c0101606:	89 c2                	mov    %eax,%edx
c0101608:	66 a1 50 85 11 c0    	mov    0xc0118550,%ax
c010160e:	21 d0                	and    %edx,%eax
c0101610:	0f b7 c0             	movzwl %ax,%eax
c0101613:	50                   	push   %eax
c0101614:	e8 86 ff ff ff       	call   c010159f <pic_setmask>
c0101619:	83 c4 04             	add    $0x4,%esp
}
c010161c:	90                   	nop
c010161d:	c9                   	leave  
c010161e:	c3                   	ret    

c010161f <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c010161f:	55                   	push   %ebp
c0101620:	89 e5                	mov    %esp,%ebp
c0101622:	83 ec 40             	sub    $0x40,%esp
    did_init = 1;
c0101625:	c7 05 6c b6 11 c0 01 	movl   $0x1,0xc011b66c
c010162c:	00 00 00 
c010162f:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c0101635:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
c0101639:	8a 45 c9             	mov    -0x37(%ebp),%al
c010163c:	66 8b 55 ca          	mov    -0x36(%ebp),%dx
c0101640:	ee                   	out    %al,(%dx)
c0101641:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c0101647:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
c010164b:	8a 45 cd             	mov    -0x33(%ebp),%al
c010164e:	66 8b 55 ce          	mov    -0x32(%ebp),%dx
c0101652:	ee                   	out    %al,(%dx)
c0101653:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101659:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
c010165d:	8a 45 d1             	mov    -0x2f(%ebp),%al
c0101660:	66 8b 55 d2          	mov    -0x2e(%ebp),%dx
c0101664:	ee                   	out    %al,(%dx)
c0101665:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c010166b:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c010166f:	8a 45 d5             	mov    -0x2b(%ebp),%al
c0101672:	66 8b 55 d6          	mov    -0x2a(%ebp),%dx
c0101676:	ee                   	out    %al,(%dx)
c0101677:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c010167d:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
c0101681:	8a 45 d9             	mov    -0x27(%ebp),%al
c0101684:	66 8b 55 da          	mov    -0x26(%ebp),%dx
c0101688:	ee                   	out    %al,(%dx)
c0101689:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c010168f:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
c0101693:	8a 45 dd             	mov    -0x23(%ebp),%al
c0101696:	66 8b 55 de          	mov    -0x22(%ebp),%dx
c010169a:	ee                   	out    %al,(%dx)
c010169b:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c01016a1:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
c01016a5:	8a 45 e1             	mov    -0x1f(%ebp),%al
c01016a8:	66 8b 55 e2          	mov    -0x1e(%ebp),%dx
c01016ac:	ee                   	out    %al,(%dx)
c01016ad:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c01016b3:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
c01016b7:	8a 45 e5             	mov    -0x1b(%ebp),%al
c01016ba:	66 8b 55 e6          	mov    -0x1a(%ebp),%dx
c01016be:	ee                   	out    %al,(%dx)
c01016bf:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c01016c5:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
c01016c9:	8a 45 e9             	mov    -0x17(%ebp),%al
c01016cc:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
c01016d0:	ee                   	out    %al,(%dx)
c01016d1:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c01016d7:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
c01016db:	8a 45 ed             	mov    -0x13(%ebp),%al
c01016de:	66 8b 55 ee          	mov    -0x12(%ebp),%dx
c01016e2:	ee                   	out    %al,(%dx)
c01016e3:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c01016e9:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
c01016ed:	8a 45 f1             	mov    -0xf(%ebp),%al
c01016f0:	66 8b 55 f2          	mov    -0xe(%ebp),%dx
c01016f4:	ee                   	out    %al,(%dx)
c01016f5:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c01016fb:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
c01016ff:	8a 45 f5             	mov    -0xb(%ebp),%al
c0101702:	66 8b 55 f6          	mov    -0xa(%ebp),%dx
c0101706:	ee                   	out    %al,(%dx)
c0101707:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c010170d:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
c0101711:	8a 45 f9             	mov    -0x7(%ebp),%al
c0101714:	66 8b 55 fa          	mov    -0x6(%ebp),%dx
c0101718:	ee                   	out    %al,(%dx)
c0101719:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c010171f:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
c0101723:	8a 45 fd             	mov    -0x3(%ebp),%al
c0101726:	66 8b 55 fe          	mov    -0x2(%ebp),%dx
c010172a:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c010172b:	66 a1 50 85 11 c0    	mov    0xc0118550,%ax
c0101731:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101735:	74 12                	je     c0101749 <pic_init+0x12a>
        pic_setmask(irq_mask);
c0101737:	66 a1 50 85 11 c0    	mov    0xc0118550,%ax
c010173d:	0f b7 c0             	movzwl %ax,%eax
c0101740:	50                   	push   %eax
c0101741:	e8 59 fe ff ff       	call   c010159f <pic_setmask>
c0101746:	83 c4 04             	add    $0x4,%esp
    }
}
c0101749:	90                   	nop
c010174a:	c9                   	leave  
c010174b:	c3                   	ret    

c010174c <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c010174c:	55                   	push   %ebp
c010174d:	89 e5                	mov    %esp,%ebp
c010174f:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101752:	83 ec 08             	sub    $0x8,%esp
c0101755:	6a 64                	push   $0x64
c0101757:	68 00 5d 10 c0       	push   $0xc0105d00
c010175c:	e8 d6 eb ff ff       	call   c0100337 <cprintf>
c0101761:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c0101764:	90                   	nop
c0101765:	c9                   	leave  
c0101766:	c3                   	ret    

c0101767 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0101767:	55                   	push   %ebp
c0101768:	89 e5                	mov    %esp,%ebp
c010176a:	83 ec 10             	sub    $0x10,%esp
    // gate：处理函数的入口地址
    // istrap：系统段设置为1，中断门设置为0
    // sel：段选择子
    // off：偏移量
    // dpl：特权级
    for (int i = 0; i < 256; ++i)
c010176d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101774:	e9 b8 00 00 00       	jmp    c0101831 <idt_init+0xca>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c0101779:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010177c:	8b 04 85 e0 85 11 c0 	mov    -0x3fee7a20(,%eax,4),%eax
c0101783:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101786:	66 89 04 d5 80 b6 11 	mov    %ax,-0x3fee4980(,%edx,8)
c010178d:	c0 
c010178e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101791:	66 c7 04 c5 82 b6 11 	movw   $0x8,-0x3fee497e(,%eax,8)
c0101798:	c0 08 00 
c010179b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010179e:	8a 14 c5 84 b6 11 c0 	mov    -0x3fee497c(,%eax,8),%dl
c01017a5:	83 e2 e0             	and    $0xffffffe0,%edx
c01017a8:	88 14 c5 84 b6 11 c0 	mov    %dl,-0x3fee497c(,%eax,8)
c01017af:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01017b2:	8a 14 c5 84 b6 11 c0 	mov    -0x3fee497c(,%eax,8),%dl
c01017b9:	83 e2 1f             	and    $0x1f,%edx
c01017bc:	88 14 c5 84 b6 11 c0 	mov    %dl,-0x3fee497c(,%eax,8)
c01017c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01017c6:	8a 14 c5 85 b6 11 c0 	mov    -0x3fee497b(,%eax,8),%dl
c01017cd:	83 e2 f0             	and    $0xfffffff0,%edx
c01017d0:	83 ca 0e             	or     $0xe,%edx
c01017d3:	88 14 c5 85 b6 11 c0 	mov    %dl,-0x3fee497b(,%eax,8)
c01017da:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01017dd:	8a 14 c5 85 b6 11 c0 	mov    -0x3fee497b(,%eax,8),%dl
c01017e4:	83 e2 ef             	and    $0xffffffef,%edx
c01017e7:	88 14 c5 85 b6 11 c0 	mov    %dl,-0x3fee497b(,%eax,8)
c01017ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01017f1:	8a 14 c5 85 b6 11 c0 	mov    -0x3fee497b(,%eax,8),%dl
c01017f8:	83 e2 9f             	and    $0xffffff9f,%edx
c01017fb:	88 14 c5 85 b6 11 c0 	mov    %dl,-0x3fee497b(,%eax,8)
c0101802:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101805:	8a 14 c5 85 b6 11 c0 	mov    -0x3fee497b(,%eax,8),%dl
c010180c:	83 ca 80             	or     $0xffffff80,%edx
c010180f:	88 14 c5 85 b6 11 c0 	mov    %dl,-0x3fee497b(,%eax,8)
c0101816:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101819:	8b 04 85 e0 85 11 c0 	mov    -0x3fee7a20(,%eax,4),%eax
c0101820:	c1 e8 10             	shr    $0x10,%eax
c0101823:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101826:	66 89 04 d5 86 b6 11 	mov    %ax,-0x3fee497a(,%edx,8)
c010182d:	c0 
    for (int i = 0; i < 256; ++i)
c010182e:	ff 45 fc             	incl   -0x4(%ebp)
c0101831:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0101838:	0f 8e 3b ff ff ff    	jle    c0101779 <idt_init+0x12>
    // T_SWITCH_TOK 定义于kern/trap/trap/h，也可以使用T_SWITCH_TOU
    // 用于设置用户态到内核态的切换
    SETGATE(idt[T_SWITCH_TOK], 1, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c010183e:	a1 c4 87 11 c0       	mov    0xc01187c4,%eax
c0101843:	66 a3 48 ba 11 c0    	mov    %ax,0xc011ba48
c0101849:	66 c7 05 4a ba 11 c0 	movw   $0x8,0xc011ba4a
c0101850:	08 00 
c0101852:	a0 4c ba 11 c0       	mov    0xc011ba4c,%al
c0101857:	83 e0 e0             	and    $0xffffffe0,%eax
c010185a:	a2 4c ba 11 c0       	mov    %al,0xc011ba4c
c010185f:	a0 4c ba 11 c0       	mov    0xc011ba4c,%al
c0101864:	83 e0 1f             	and    $0x1f,%eax
c0101867:	a2 4c ba 11 c0       	mov    %al,0xc011ba4c
c010186c:	a0 4d ba 11 c0       	mov    0xc011ba4d,%al
c0101871:	83 c8 0f             	or     $0xf,%eax
c0101874:	a2 4d ba 11 c0       	mov    %al,0xc011ba4d
c0101879:	a0 4d ba 11 c0       	mov    0xc011ba4d,%al
c010187e:	83 e0 ef             	and    $0xffffffef,%eax
c0101881:	a2 4d ba 11 c0       	mov    %al,0xc011ba4d
c0101886:	a0 4d ba 11 c0       	mov    0xc011ba4d,%al
c010188b:	83 c8 60             	or     $0x60,%eax
c010188e:	a2 4d ba 11 c0       	mov    %al,0xc011ba4d
c0101893:	a0 4d ba 11 c0       	mov    0xc011ba4d,%al
c0101898:	83 c8 80             	or     $0xffffff80,%eax
c010189b:	a2 4d ba 11 c0       	mov    %al,0xc011ba4d
c01018a0:	a1 c4 87 11 c0       	mov    0xc01187c4,%eax
c01018a5:	c1 e8 10             	shr    $0x10,%eax
c01018a8:	66 a3 4e ba 11 c0    	mov    %ax,0xc011ba4e
c01018ae:	c7 45 f8 60 85 11 c0 	movl   $0xc0118560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c01018b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01018b8:	0f 01 18             	lidtl  (%eax)
    // load IDT
    lidt(&idt_pd);
}
c01018bb:	90                   	nop
c01018bc:	c9                   	leave  
c01018bd:	c3                   	ret    

c01018be <trapname>:

static const char *
trapname(int trapno) {
c01018be:	55                   	push   %ebp
c01018bf:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c01018c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01018c4:	83 f8 13             	cmp    $0x13,%eax
c01018c7:	77 0c                	ja     c01018d5 <trapname+0x17>
        return excnames[trapno];
c01018c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01018cc:	8b 04 85 60 60 10 c0 	mov    -0x3fef9fa0(,%eax,4),%eax
c01018d3:	eb 18                	jmp    c01018ed <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c01018d5:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c01018d9:	7e 0d                	jle    c01018e8 <trapname+0x2a>
c01018db:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c01018df:	7f 07                	jg     c01018e8 <trapname+0x2a>
        return "Hardware Interrupt";
c01018e1:	b8 0a 5d 10 c0       	mov    $0xc0105d0a,%eax
c01018e6:	eb 05                	jmp    c01018ed <trapname+0x2f>
    }
    return "(unknown trap)";
c01018e8:	b8 1d 5d 10 c0       	mov    $0xc0105d1d,%eax
}
c01018ed:	5d                   	pop    %ebp
c01018ee:	c3                   	ret    

c01018ef <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01018ef:	55                   	push   %ebp
c01018f0:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01018f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01018f5:	66 8b 40 3c          	mov    0x3c(%eax),%ax
c01018f9:	66 83 f8 08          	cmp    $0x8,%ax
c01018fd:	0f 94 c0             	sete   %al
c0101900:	0f b6 c0             	movzbl %al,%eax
}
c0101903:	5d                   	pop    %ebp
c0101904:	c3                   	ret    

c0101905 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101905:	55                   	push   %ebp
c0101906:	89 e5                	mov    %esp,%ebp
c0101908:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
c010190b:	83 ec 08             	sub    $0x8,%esp
c010190e:	ff 75 08             	pushl  0x8(%ebp)
c0101911:	68 5e 5d 10 c0       	push   $0xc0105d5e
c0101916:	e8 1c ea ff ff       	call   c0100337 <cprintf>
c010191b:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
c010191e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101921:	83 ec 0c             	sub    $0xc,%esp
c0101924:	50                   	push   %eax
c0101925:	e8 ba 01 00 00       	call   c0101ae4 <print_regs>
c010192a:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c010192d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101930:	66 8b 40 2c          	mov    0x2c(%eax),%ax
c0101934:	0f b7 c0             	movzwl %ax,%eax
c0101937:	83 ec 08             	sub    $0x8,%esp
c010193a:	50                   	push   %eax
c010193b:	68 6f 5d 10 c0       	push   $0xc0105d6f
c0101940:	e8 f2 e9 ff ff       	call   c0100337 <cprintf>
c0101945:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101948:	8b 45 08             	mov    0x8(%ebp),%eax
c010194b:	66 8b 40 28          	mov    0x28(%eax),%ax
c010194f:	0f b7 c0             	movzwl %ax,%eax
c0101952:	83 ec 08             	sub    $0x8,%esp
c0101955:	50                   	push   %eax
c0101956:	68 82 5d 10 c0       	push   $0xc0105d82
c010195b:	e8 d7 e9 ff ff       	call   c0100337 <cprintf>
c0101960:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101963:	8b 45 08             	mov    0x8(%ebp),%eax
c0101966:	66 8b 40 24          	mov    0x24(%eax),%ax
c010196a:	0f b7 c0             	movzwl %ax,%eax
c010196d:	83 ec 08             	sub    $0x8,%esp
c0101970:	50                   	push   %eax
c0101971:	68 95 5d 10 c0       	push   $0xc0105d95
c0101976:	e8 bc e9 ff ff       	call   c0100337 <cprintf>
c010197b:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c010197e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101981:	66 8b 40 20          	mov    0x20(%eax),%ax
c0101985:	0f b7 c0             	movzwl %ax,%eax
c0101988:	83 ec 08             	sub    $0x8,%esp
c010198b:	50                   	push   %eax
c010198c:	68 a8 5d 10 c0       	push   $0xc0105da8
c0101991:	e8 a1 e9 ff ff       	call   c0100337 <cprintf>
c0101996:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101999:	8b 45 08             	mov    0x8(%ebp),%eax
c010199c:	8b 40 30             	mov    0x30(%eax),%eax
c010199f:	83 ec 0c             	sub    $0xc,%esp
c01019a2:	50                   	push   %eax
c01019a3:	e8 16 ff ff ff       	call   c01018be <trapname>
c01019a8:	83 c4 10             	add    $0x10,%esp
c01019ab:	89 c2                	mov    %eax,%edx
c01019ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01019b0:	8b 40 30             	mov    0x30(%eax),%eax
c01019b3:	83 ec 04             	sub    $0x4,%esp
c01019b6:	52                   	push   %edx
c01019b7:	50                   	push   %eax
c01019b8:	68 bb 5d 10 c0       	push   $0xc0105dbb
c01019bd:	e8 75 e9 ff ff       	call   c0100337 <cprintf>
c01019c2:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
c01019c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01019c8:	8b 40 34             	mov    0x34(%eax),%eax
c01019cb:	83 ec 08             	sub    $0x8,%esp
c01019ce:	50                   	push   %eax
c01019cf:	68 cd 5d 10 c0       	push   $0xc0105dcd
c01019d4:	e8 5e e9 ff ff       	call   c0100337 <cprintf>
c01019d9:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c01019dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01019df:	8b 40 38             	mov    0x38(%eax),%eax
c01019e2:	83 ec 08             	sub    $0x8,%esp
c01019e5:	50                   	push   %eax
c01019e6:	68 dc 5d 10 c0       	push   $0xc0105ddc
c01019eb:	e8 47 e9 ff ff       	call   c0100337 <cprintf>
c01019f0:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c01019f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01019f6:	66 8b 40 3c          	mov    0x3c(%eax),%ax
c01019fa:	0f b7 c0             	movzwl %ax,%eax
c01019fd:	83 ec 08             	sub    $0x8,%esp
c0101a00:	50                   	push   %eax
c0101a01:	68 eb 5d 10 c0       	push   $0xc0105deb
c0101a06:	e8 2c e9 ff ff       	call   c0100337 <cprintf>
c0101a0b:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101a0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a11:	8b 40 40             	mov    0x40(%eax),%eax
c0101a14:	83 ec 08             	sub    $0x8,%esp
c0101a17:	50                   	push   %eax
c0101a18:	68 fe 5d 10 c0       	push   $0xc0105dfe
c0101a1d:	e8 15 e9 ff ff       	call   c0100337 <cprintf>
c0101a22:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101a25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101a2c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101a33:	eb 43                	jmp    c0101a78 <print_trapframe+0x173>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101a35:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a38:	8b 50 40             	mov    0x40(%eax),%edx
c0101a3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101a3e:	21 d0                	and    %edx,%eax
c0101a40:	85 c0                	test   %eax,%eax
c0101a42:	74 29                	je     c0101a6d <print_trapframe+0x168>
c0101a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a47:	8b 04 85 80 85 11 c0 	mov    -0x3fee7a80(,%eax,4),%eax
c0101a4e:	85 c0                	test   %eax,%eax
c0101a50:	74 1b                	je     c0101a6d <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
c0101a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a55:	8b 04 85 80 85 11 c0 	mov    -0x3fee7a80(,%eax,4),%eax
c0101a5c:	83 ec 08             	sub    $0x8,%esp
c0101a5f:	50                   	push   %eax
c0101a60:	68 0d 5e 10 c0       	push   $0xc0105e0d
c0101a65:	e8 cd e8 ff ff       	call   c0100337 <cprintf>
c0101a6a:	83 c4 10             	add    $0x10,%esp
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101a6d:	ff 45 f4             	incl   -0xc(%ebp)
c0101a70:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101a73:	01 c0                	add    %eax,%eax
c0101a75:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0101a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a7b:	83 f8 17             	cmp    $0x17,%eax
c0101a7e:	76 b5                	jbe    c0101a35 <print_trapframe+0x130>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101a80:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a83:	8b 40 40             	mov    0x40(%eax),%eax
c0101a86:	c1 e8 0c             	shr    $0xc,%eax
c0101a89:	83 e0 03             	and    $0x3,%eax
c0101a8c:	83 ec 08             	sub    $0x8,%esp
c0101a8f:	50                   	push   %eax
c0101a90:	68 11 5e 10 c0       	push   $0xc0105e11
c0101a95:	e8 9d e8 ff ff       	call   c0100337 <cprintf>
c0101a9a:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
c0101a9d:	83 ec 0c             	sub    $0xc,%esp
c0101aa0:	ff 75 08             	pushl  0x8(%ebp)
c0101aa3:	e8 47 fe ff ff       	call   c01018ef <trap_in_kernel>
c0101aa8:	83 c4 10             	add    $0x10,%esp
c0101aab:	85 c0                	test   %eax,%eax
c0101aad:	75 32                	jne    c0101ae1 <print_trapframe+0x1dc>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101aaf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab2:	8b 40 44             	mov    0x44(%eax),%eax
c0101ab5:	83 ec 08             	sub    $0x8,%esp
c0101ab8:	50                   	push   %eax
c0101ab9:	68 1a 5e 10 c0       	push   $0xc0105e1a
c0101abe:	e8 74 e8 ff ff       	call   c0100337 <cprintf>
c0101ac3:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101ac6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ac9:	66 8b 40 48          	mov    0x48(%eax),%ax
c0101acd:	0f b7 c0             	movzwl %ax,%eax
c0101ad0:	83 ec 08             	sub    $0x8,%esp
c0101ad3:	50                   	push   %eax
c0101ad4:	68 29 5e 10 c0       	push   $0xc0105e29
c0101ad9:	e8 59 e8 ff ff       	call   c0100337 <cprintf>
c0101ade:	83 c4 10             	add    $0x10,%esp
    }
}
c0101ae1:	90                   	nop
c0101ae2:	c9                   	leave  
c0101ae3:	c3                   	ret    

c0101ae4 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101ae4:	55                   	push   %ebp
c0101ae5:	89 e5                	mov    %esp,%ebp
c0101ae7:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101aea:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aed:	8b 00                	mov    (%eax),%eax
c0101aef:	83 ec 08             	sub    $0x8,%esp
c0101af2:	50                   	push   %eax
c0101af3:	68 3c 5e 10 c0       	push   $0xc0105e3c
c0101af8:	e8 3a e8 ff ff       	call   c0100337 <cprintf>
c0101afd:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101b00:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b03:	8b 40 04             	mov    0x4(%eax),%eax
c0101b06:	83 ec 08             	sub    $0x8,%esp
c0101b09:	50                   	push   %eax
c0101b0a:	68 4b 5e 10 c0       	push   $0xc0105e4b
c0101b0f:	e8 23 e8 ff ff       	call   c0100337 <cprintf>
c0101b14:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101b17:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b1a:	8b 40 08             	mov    0x8(%eax),%eax
c0101b1d:	83 ec 08             	sub    $0x8,%esp
c0101b20:	50                   	push   %eax
c0101b21:	68 5a 5e 10 c0       	push   $0xc0105e5a
c0101b26:	e8 0c e8 ff ff       	call   c0100337 <cprintf>
c0101b2b:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101b2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b31:	8b 40 0c             	mov    0xc(%eax),%eax
c0101b34:	83 ec 08             	sub    $0x8,%esp
c0101b37:	50                   	push   %eax
c0101b38:	68 69 5e 10 c0       	push   $0xc0105e69
c0101b3d:	e8 f5 e7 ff ff       	call   c0100337 <cprintf>
c0101b42:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101b45:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b48:	8b 40 10             	mov    0x10(%eax),%eax
c0101b4b:	83 ec 08             	sub    $0x8,%esp
c0101b4e:	50                   	push   %eax
c0101b4f:	68 78 5e 10 c0       	push   $0xc0105e78
c0101b54:	e8 de e7 ff ff       	call   c0100337 <cprintf>
c0101b59:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101b5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b5f:	8b 40 14             	mov    0x14(%eax),%eax
c0101b62:	83 ec 08             	sub    $0x8,%esp
c0101b65:	50                   	push   %eax
c0101b66:	68 87 5e 10 c0       	push   $0xc0105e87
c0101b6b:	e8 c7 e7 ff ff       	call   c0100337 <cprintf>
c0101b70:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101b73:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b76:	8b 40 18             	mov    0x18(%eax),%eax
c0101b79:	83 ec 08             	sub    $0x8,%esp
c0101b7c:	50                   	push   %eax
c0101b7d:	68 96 5e 10 c0       	push   $0xc0105e96
c0101b82:	e8 b0 e7 ff ff       	call   c0100337 <cprintf>
c0101b87:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101b8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b8d:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101b90:	83 ec 08             	sub    $0x8,%esp
c0101b93:	50                   	push   %eax
c0101b94:	68 a5 5e 10 c0       	push   $0xc0105ea5
c0101b99:	e8 99 e7 ff ff       	call   c0100337 <cprintf>
c0101b9e:	83 c4 10             	add    $0x10,%esp
}
c0101ba1:	90                   	nop
c0101ba2:	c9                   	leave  
c0101ba3:	c3                   	ret    

c0101ba4 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101ba4:	55                   	push   %ebp
c0101ba5:	89 e5                	mov    %esp,%ebp
c0101ba7:	83 ec 18             	sub    $0x18,%esp
    char c;

    switch (tf->tf_trapno) {
c0101baa:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bad:	8b 40 30             	mov    0x30(%eax),%eax
c0101bb0:	83 f8 2f             	cmp    $0x2f,%eax
c0101bb3:	77 1d                	ja     c0101bd2 <trap_dispatch+0x2e>
c0101bb5:	83 f8 2e             	cmp    $0x2e,%eax
c0101bb8:	0f 83 be 01 00 00    	jae    c0101d7c <trap_dispatch+0x1d8>
c0101bbe:	83 f8 21             	cmp    $0x21,%eax
c0101bc1:	74 7d                	je     c0101c40 <trap_dispatch+0x9c>
c0101bc3:	83 f8 24             	cmp    $0x24,%eax
c0101bc6:	74 51                	je     c0101c19 <trap_dispatch+0x75>
c0101bc8:	83 f8 20             	cmp    $0x20,%eax
c0101bcb:	74 1c                	je     c0101be9 <trap_dispatch+0x45>
c0101bcd:	e9 74 01 00 00       	jmp    c0101d46 <trap_dispatch+0x1a2>
c0101bd2:	83 f8 78             	cmp    $0x78,%eax
c0101bd5:	0f 84 8c 00 00 00    	je     c0101c67 <trap_dispatch+0xc3>
c0101bdb:	83 f8 79             	cmp    $0x79,%eax
c0101bde:	0f 84 f4 00 00 00    	je     c0101cd8 <trap_dispatch+0x134>
c0101be4:	e9 5d 01 00 00       	jmp    c0101d46 <trap_dispatch+0x1a2>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ++ticks;
c0101be9:	a1 0c bf 11 c0       	mov    0xc011bf0c,%eax
c0101bee:	40                   	inc    %eax
c0101bef:	a3 0c bf 11 c0       	mov    %eax,0xc011bf0c
        if (ticks % TICK_NUM == 0)
c0101bf4:	a1 0c bf 11 c0       	mov    0xc011bf0c,%eax
c0101bf9:	b9 64 00 00 00       	mov    $0x64,%ecx
c0101bfe:	ba 00 00 00 00       	mov    $0x0,%edx
c0101c03:	f7 f1                	div    %ecx
c0101c05:	89 d0                	mov    %edx,%eax
c0101c07:	85 c0                	test   %eax,%eax
c0101c09:	0f 85 70 01 00 00    	jne    c0101d7f <trap_dispatch+0x1db>
            print_ticks();
c0101c0f:	e8 38 fb ff ff       	call   c010174c <print_ticks>
        break;
c0101c14:	e9 66 01 00 00       	jmp    c0101d7f <trap_dispatch+0x1db>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101c19:	e8 02 f9 ff ff       	call   c0101520 <cons_getc>
c0101c1e:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101c21:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101c25:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101c29:	83 ec 04             	sub    $0x4,%esp
c0101c2c:	52                   	push   %edx
c0101c2d:	50                   	push   %eax
c0101c2e:	68 b4 5e 10 c0       	push   $0xc0105eb4
c0101c33:	e8 ff e6 ff ff       	call   c0100337 <cprintf>
c0101c38:	83 c4 10             	add    $0x10,%esp
        break;
c0101c3b:	e9 46 01 00 00       	jmp    c0101d86 <trap_dispatch+0x1e2>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101c40:	e8 db f8 ff ff       	call   c0101520 <cons_getc>
c0101c45:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101c48:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101c4c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101c50:	83 ec 04             	sub    $0x4,%esp
c0101c53:	52                   	push   %edx
c0101c54:	50                   	push   %eax
c0101c55:	68 c6 5e 10 c0       	push   $0xc0105ec6
c0101c5a:	e8 d8 e6 ff ff       	call   c0100337 <cprintf>
c0101c5f:	83 c4 10             	add    $0x10,%esp
        break;
c0101c62:	e9 1f 01 00 00       	jmp    c0101d86 <trap_dispatch+0x1e2>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
c0101c67:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c6a:	66 8b 40 3c          	mov    0x3c(%eax),%ax
c0101c6e:	66 83 f8 1b          	cmp    $0x1b,%ax
c0101c72:	0f 84 0a 01 00 00    	je     c0101d82 <trap_dispatch+0x1de>
            tf->tf_ds = tf->tf_es = tf->tf_fs = tf->tf_gs = tf->tf_ss = USER_DS;
c0101c78:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c7b:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
c0101c81:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c84:	66 8b 40 48          	mov    0x48(%eax),%ax
c0101c88:	8b 55 08             	mov    0x8(%ebp),%edx
c0101c8b:	66 89 42 20          	mov    %ax,0x20(%edx)
c0101c8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c92:	66 8b 40 20          	mov    0x20(%eax),%ax
c0101c96:	8b 55 08             	mov    0x8(%ebp),%edx
c0101c99:	66 89 42 24          	mov    %ax,0x24(%edx)
c0101c9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ca0:	66 8b 40 24          	mov    0x24(%eax),%ax
c0101ca4:	8b 55 08             	mov    0x8(%ebp),%edx
c0101ca7:	66 89 42 28          	mov    %ax,0x28(%edx)
c0101cab:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cae:	66 8b 40 28          	mov    0x28(%eax),%ax
c0101cb2:	8b 55 08             	mov    0x8(%ebp),%edx
c0101cb5:	66 89 42 2c          	mov    %ax,0x2c(%edx)
            tf->tf_cs = USER_CS;
c0101cb9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cbc:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
            // 开启IO权限
            tf->tf_eflags |= FL_IOPL_MASK;
c0101cc2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cc5:	8b 40 40             	mov    0x40(%eax),%eax
c0101cc8:	80 cc 30             	or     $0x30,%ah
c0101ccb:	89 c2                	mov    %eax,%edx
c0101ccd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cd0:	89 50 40             	mov    %edx,0x40(%eax)
        }
        break;
c0101cd3:	e9 aa 00 00 00       	jmp    c0101d82 <trap_dispatch+0x1de>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
c0101cd8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cdb:	66 8b 40 3c          	mov    0x3c(%eax),%ax
c0101cdf:	66 83 f8 08          	cmp    $0x8,%ax
c0101ce3:	0f 84 9c 00 00 00    	je     c0101d85 <trap_dispatch+0x1e1>
            tf->tf_ds = tf->tf_es = tf->tf_fs = tf->tf_gs = tf->tf_ss = KERNEL_DS;
c0101ce9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cec:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
c0101cf2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cf5:	66 8b 40 48          	mov    0x48(%eax),%ax
c0101cf9:	8b 55 08             	mov    0x8(%ebp),%edx
c0101cfc:	66 89 42 20          	mov    %ax,0x20(%edx)
c0101d00:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d03:	66 8b 40 20          	mov    0x20(%eax),%ax
c0101d07:	8b 55 08             	mov    0x8(%ebp),%edx
c0101d0a:	66 89 42 24          	mov    %ax,0x24(%edx)
c0101d0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d11:	66 8b 40 24          	mov    0x24(%eax),%ax
c0101d15:	8b 55 08             	mov    0x8(%ebp),%edx
c0101d18:	66 89 42 28          	mov    %ax,0x28(%edx)
c0101d1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d1f:	66 8b 40 28          	mov    0x28(%eax),%ax
c0101d23:	8b 55 08             	mov    0x8(%ebp),%edx
c0101d26:	66 89 42 2c          	mov    %ax,0x2c(%edx)
            tf->tf_cs = KERNEL_CS;
c0101d2a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d2d:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            // 关闭IO权限
            tf->tf_eflags &= ~FL_IOPL_MASK;
c0101d33:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d36:	8b 40 40             	mov    0x40(%eax),%eax
c0101d39:	80 e4 cf             	and    $0xcf,%ah
c0101d3c:	89 c2                	mov    %eax,%edx
c0101d3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d41:	89 50 40             	mov    %edx,0x40(%eax)
        }
        break;
c0101d44:	eb 3f                	jmp    c0101d85 <trap_dispatch+0x1e1>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101d46:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d49:	66 8b 40 3c          	mov    0x3c(%eax),%ax
c0101d4d:	0f b7 c0             	movzwl %ax,%eax
c0101d50:	83 e0 03             	and    $0x3,%eax
c0101d53:	85 c0                	test   %eax,%eax
c0101d55:	75 2f                	jne    c0101d86 <trap_dispatch+0x1e2>
            print_trapframe(tf);
c0101d57:	83 ec 0c             	sub    $0xc,%esp
c0101d5a:	ff 75 08             	pushl  0x8(%ebp)
c0101d5d:	e8 a3 fb ff ff       	call   c0101905 <print_trapframe>
c0101d62:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
c0101d65:	83 ec 04             	sub    $0x4,%esp
c0101d68:	68 d5 5e 10 c0       	push   $0xc0105ed5
c0101d6d:	68 ca 00 00 00       	push   $0xca
c0101d72:	68 f1 5e 10 c0       	push   $0xc0105ef1
c0101d77:	e8 52 ee ff ff       	call   c0100bce <__panic>
        break;
c0101d7c:	90                   	nop
c0101d7d:	eb 07                	jmp    c0101d86 <trap_dispatch+0x1e2>
        break;
c0101d7f:	90                   	nop
c0101d80:	eb 04                	jmp    c0101d86 <trap_dispatch+0x1e2>
        break;
c0101d82:	90                   	nop
c0101d83:	eb 01                	jmp    c0101d86 <trap_dispatch+0x1e2>
        break;
c0101d85:	90                   	nop
        }
    }
}
c0101d86:	90                   	nop
c0101d87:	c9                   	leave  
c0101d88:	c3                   	ret    

c0101d89 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101d89:	55                   	push   %ebp
c0101d8a:	89 e5                	mov    %esp,%ebp
c0101d8c:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101d8f:	83 ec 0c             	sub    $0xc,%esp
c0101d92:	ff 75 08             	pushl  0x8(%ebp)
c0101d95:	e8 0a fe ff ff       	call   c0101ba4 <trap_dispatch>
c0101d9a:	83 c4 10             	add    $0x10,%esp
}
c0101d9d:	90                   	nop
c0101d9e:	c9                   	leave  
c0101d9f:	c3                   	ret    

c0101da0 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101da0:	1e                   	push   %ds
    pushl %es
c0101da1:	06                   	push   %es
    pushl %fs
c0101da2:	0f a0                	push   %fs
    pushl %gs
c0101da4:	0f a8                	push   %gs
    pushal
c0101da6:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101da7:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101dac:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101dae:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101db0:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101db1:	e8 d3 ff ff ff       	call   c0101d89 <trap>

    # pop the pushed stack pointer
    popl %esp
c0101db6:	5c                   	pop    %esp

c0101db7 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101db7:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101db8:	0f a9                	pop    %gs
    popl %fs
c0101dba:	0f a1                	pop    %fs
    popl %es
c0101dbc:	07                   	pop    %es
    popl %ds
c0101dbd:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101dbe:	83 c4 08             	add    $0x8,%esp
    iret
c0101dc1:	cf                   	iret   

c0101dc2 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101dc2:	6a 00                	push   $0x0
  pushl $0
c0101dc4:	6a 00                	push   $0x0
  jmp __alltraps
c0101dc6:	e9 d5 ff ff ff       	jmp    c0101da0 <__alltraps>

c0101dcb <vector1>:
.globl vector1
vector1:
  pushl $0
c0101dcb:	6a 00                	push   $0x0
  pushl $1
c0101dcd:	6a 01                	push   $0x1
  jmp __alltraps
c0101dcf:	e9 cc ff ff ff       	jmp    c0101da0 <__alltraps>

c0101dd4 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101dd4:	6a 00                	push   $0x0
  pushl $2
c0101dd6:	6a 02                	push   $0x2
  jmp __alltraps
c0101dd8:	e9 c3 ff ff ff       	jmp    c0101da0 <__alltraps>

c0101ddd <vector3>:
.globl vector3
vector3:
  pushl $0
c0101ddd:	6a 00                	push   $0x0
  pushl $3
c0101ddf:	6a 03                	push   $0x3
  jmp __alltraps
c0101de1:	e9 ba ff ff ff       	jmp    c0101da0 <__alltraps>

c0101de6 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101de6:	6a 00                	push   $0x0
  pushl $4
c0101de8:	6a 04                	push   $0x4
  jmp __alltraps
c0101dea:	e9 b1 ff ff ff       	jmp    c0101da0 <__alltraps>

c0101def <vector5>:
.globl vector5
vector5:
  pushl $0
c0101def:	6a 00                	push   $0x0
  pushl $5
c0101df1:	6a 05                	push   $0x5
  jmp __alltraps
c0101df3:	e9 a8 ff ff ff       	jmp    c0101da0 <__alltraps>

c0101df8 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101df8:	6a 00                	push   $0x0
  pushl $6
c0101dfa:	6a 06                	push   $0x6
  jmp __alltraps
c0101dfc:	e9 9f ff ff ff       	jmp    c0101da0 <__alltraps>

c0101e01 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101e01:	6a 00                	push   $0x0
  pushl $7
c0101e03:	6a 07                	push   $0x7
  jmp __alltraps
c0101e05:	e9 96 ff ff ff       	jmp    c0101da0 <__alltraps>

c0101e0a <vector8>:
.globl vector8
vector8:
  pushl $8
c0101e0a:	6a 08                	push   $0x8
  jmp __alltraps
c0101e0c:	e9 8f ff ff ff       	jmp    c0101da0 <__alltraps>

c0101e11 <vector9>:
.globl vector9
vector9:
  pushl $0
c0101e11:	6a 00                	push   $0x0
  pushl $9
c0101e13:	6a 09                	push   $0x9
  jmp __alltraps
c0101e15:	e9 86 ff ff ff       	jmp    c0101da0 <__alltraps>

c0101e1a <vector10>:
.globl vector10
vector10:
  pushl $10
c0101e1a:	6a 0a                	push   $0xa
  jmp __alltraps
c0101e1c:	e9 7f ff ff ff       	jmp    c0101da0 <__alltraps>

c0101e21 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101e21:	6a 0b                	push   $0xb
  jmp __alltraps
c0101e23:	e9 78 ff ff ff       	jmp    c0101da0 <__alltraps>

c0101e28 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101e28:	6a 0c                	push   $0xc
  jmp __alltraps
c0101e2a:	e9 71 ff ff ff       	jmp    c0101da0 <__alltraps>

c0101e2f <vector13>:
.globl vector13
vector13:
  pushl $13
c0101e2f:	6a 0d                	push   $0xd
  jmp __alltraps
c0101e31:	e9 6a ff ff ff       	jmp    c0101da0 <__alltraps>

c0101e36 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101e36:	6a 0e                	push   $0xe
  jmp __alltraps
c0101e38:	e9 63 ff ff ff       	jmp    c0101da0 <__alltraps>

c0101e3d <vector15>:
.globl vector15
vector15:
  pushl $0
c0101e3d:	6a 00                	push   $0x0
  pushl $15
c0101e3f:	6a 0f                	push   $0xf
  jmp __alltraps
c0101e41:	e9 5a ff ff ff       	jmp    c0101da0 <__alltraps>

c0101e46 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101e46:	6a 00                	push   $0x0
  pushl $16
c0101e48:	6a 10                	push   $0x10
  jmp __alltraps
c0101e4a:	e9 51 ff ff ff       	jmp    c0101da0 <__alltraps>

c0101e4f <vector17>:
.globl vector17
vector17:
  pushl $17
c0101e4f:	6a 11                	push   $0x11
  jmp __alltraps
c0101e51:	e9 4a ff ff ff       	jmp    c0101da0 <__alltraps>

c0101e56 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101e56:	6a 00                	push   $0x0
  pushl $18
c0101e58:	6a 12                	push   $0x12
  jmp __alltraps
c0101e5a:	e9 41 ff ff ff       	jmp    c0101da0 <__alltraps>

c0101e5f <vector19>:
.globl vector19
vector19:
  pushl $0
c0101e5f:	6a 00                	push   $0x0
  pushl $19
c0101e61:	6a 13                	push   $0x13
  jmp __alltraps
c0101e63:	e9 38 ff ff ff       	jmp    c0101da0 <__alltraps>

c0101e68 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101e68:	6a 00                	push   $0x0
  pushl $20
c0101e6a:	6a 14                	push   $0x14
  jmp __alltraps
c0101e6c:	e9 2f ff ff ff       	jmp    c0101da0 <__alltraps>

c0101e71 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101e71:	6a 00                	push   $0x0
  pushl $21
c0101e73:	6a 15                	push   $0x15
  jmp __alltraps
c0101e75:	e9 26 ff ff ff       	jmp    c0101da0 <__alltraps>

c0101e7a <vector22>:
.globl vector22
vector22:
  pushl $0
c0101e7a:	6a 00                	push   $0x0
  pushl $22
c0101e7c:	6a 16                	push   $0x16
  jmp __alltraps
c0101e7e:	e9 1d ff ff ff       	jmp    c0101da0 <__alltraps>

c0101e83 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101e83:	6a 00                	push   $0x0
  pushl $23
c0101e85:	6a 17                	push   $0x17
  jmp __alltraps
c0101e87:	e9 14 ff ff ff       	jmp    c0101da0 <__alltraps>

c0101e8c <vector24>:
.globl vector24
vector24:
  pushl $0
c0101e8c:	6a 00                	push   $0x0
  pushl $24
c0101e8e:	6a 18                	push   $0x18
  jmp __alltraps
c0101e90:	e9 0b ff ff ff       	jmp    c0101da0 <__alltraps>

c0101e95 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101e95:	6a 00                	push   $0x0
  pushl $25
c0101e97:	6a 19                	push   $0x19
  jmp __alltraps
c0101e99:	e9 02 ff ff ff       	jmp    c0101da0 <__alltraps>

c0101e9e <vector26>:
.globl vector26
vector26:
  pushl $0
c0101e9e:	6a 00                	push   $0x0
  pushl $26
c0101ea0:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101ea2:	e9 f9 fe ff ff       	jmp    c0101da0 <__alltraps>

c0101ea7 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101ea7:	6a 00                	push   $0x0
  pushl $27
c0101ea9:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101eab:	e9 f0 fe ff ff       	jmp    c0101da0 <__alltraps>

c0101eb0 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101eb0:	6a 00                	push   $0x0
  pushl $28
c0101eb2:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101eb4:	e9 e7 fe ff ff       	jmp    c0101da0 <__alltraps>

c0101eb9 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101eb9:	6a 00                	push   $0x0
  pushl $29
c0101ebb:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101ebd:	e9 de fe ff ff       	jmp    c0101da0 <__alltraps>

c0101ec2 <vector30>:
.globl vector30
vector30:
  pushl $0
c0101ec2:	6a 00                	push   $0x0
  pushl $30
c0101ec4:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101ec6:	e9 d5 fe ff ff       	jmp    c0101da0 <__alltraps>

c0101ecb <vector31>:
.globl vector31
vector31:
  pushl $0
c0101ecb:	6a 00                	push   $0x0
  pushl $31
c0101ecd:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101ecf:	e9 cc fe ff ff       	jmp    c0101da0 <__alltraps>

c0101ed4 <vector32>:
.globl vector32
vector32:
  pushl $0
c0101ed4:	6a 00                	push   $0x0
  pushl $32
c0101ed6:	6a 20                	push   $0x20
  jmp __alltraps
c0101ed8:	e9 c3 fe ff ff       	jmp    c0101da0 <__alltraps>

c0101edd <vector33>:
.globl vector33
vector33:
  pushl $0
c0101edd:	6a 00                	push   $0x0
  pushl $33
c0101edf:	6a 21                	push   $0x21
  jmp __alltraps
c0101ee1:	e9 ba fe ff ff       	jmp    c0101da0 <__alltraps>

c0101ee6 <vector34>:
.globl vector34
vector34:
  pushl $0
c0101ee6:	6a 00                	push   $0x0
  pushl $34
c0101ee8:	6a 22                	push   $0x22
  jmp __alltraps
c0101eea:	e9 b1 fe ff ff       	jmp    c0101da0 <__alltraps>

c0101eef <vector35>:
.globl vector35
vector35:
  pushl $0
c0101eef:	6a 00                	push   $0x0
  pushl $35
c0101ef1:	6a 23                	push   $0x23
  jmp __alltraps
c0101ef3:	e9 a8 fe ff ff       	jmp    c0101da0 <__alltraps>

c0101ef8 <vector36>:
.globl vector36
vector36:
  pushl $0
c0101ef8:	6a 00                	push   $0x0
  pushl $36
c0101efa:	6a 24                	push   $0x24
  jmp __alltraps
c0101efc:	e9 9f fe ff ff       	jmp    c0101da0 <__alltraps>

c0101f01 <vector37>:
.globl vector37
vector37:
  pushl $0
c0101f01:	6a 00                	push   $0x0
  pushl $37
c0101f03:	6a 25                	push   $0x25
  jmp __alltraps
c0101f05:	e9 96 fe ff ff       	jmp    c0101da0 <__alltraps>

c0101f0a <vector38>:
.globl vector38
vector38:
  pushl $0
c0101f0a:	6a 00                	push   $0x0
  pushl $38
c0101f0c:	6a 26                	push   $0x26
  jmp __alltraps
c0101f0e:	e9 8d fe ff ff       	jmp    c0101da0 <__alltraps>

c0101f13 <vector39>:
.globl vector39
vector39:
  pushl $0
c0101f13:	6a 00                	push   $0x0
  pushl $39
c0101f15:	6a 27                	push   $0x27
  jmp __alltraps
c0101f17:	e9 84 fe ff ff       	jmp    c0101da0 <__alltraps>

c0101f1c <vector40>:
.globl vector40
vector40:
  pushl $0
c0101f1c:	6a 00                	push   $0x0
  pushl $40
c0101f1e:	6a 28                	push   $0x28
  jmp __alltraps
c0101f20:	e9 7b fe ff ff       	jmp    c0101da0 <__alltraps>

c0101f25 <vector41>:
.globl vector41
vector41:
  pushl $0
c0101f25:	6a 00                	push   $0x0
  pushl $41
c0101f27:	6a 29                	push   $0x29
  jmp __alltraps
c0101f29:	e9 72 fe ff ff       	jmp    c0101da0 <__alltraps>

c0101f2e <vector42>:
.globl vector42
vector42:
  pushl $0
c0101f2e:	6a 00                	push   $0x0
  pushl $42
c0101f30:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101f32:	e9 69 fe ff ff       	jmp    c0101da0 <__alltraps>

c0101f37 <vector43>:
.globl vector43
vector43:
  pushl $0
c0101f37:	6a 00                	push   $0x0
  pushl $43
c0101f39:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101f3b:	e9 60 fe ff ff       	jmp    c0101da0 <__alltraps>

c0101f40 <vector44>:
.globl vector44
vector44:
  pushl $0
c0101f40:	6a 00                	push   $0x0
  pushl $44
c0101f42:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101f44:	e9 57 fe ff ff       	jmp    c0101da0 <__alltraps>

c0101f49 <vector45>:
.globl vector45
vector45:
  pushl $0
c0101f49:	6a 00                	push   $0x0
  pushl $45
c0101f4b:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101f4d:	e9 4e fe ff ff       	jmp    c0101da0 <__alltraps>

c0101f52 <vector46>:
.globl vector46
vector46:
  pushl $0
c0101f52:	6a 00                	push   $0x0
  pushl $46
c0101f54:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101f56:	e9 45 fe ff ff       	jmp    c0101da0 <__alltraps>

c0101f5b <vector47>:
.globl vector47
vector47:
  pushl $0
c0101f5b:	6a 00                	push   $0x0
  pushl $47
c0101f5d:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101f5f:	e9 3c fe ff ff       	jmp    c0101da0 <__alltraps>

c0101f64 <vector48>:
.globl vector48
vector48:
  pushl $0
c0101f64:	6a 00                	push   $0x0
  pushl $48
c0101f66:	6a 30                	push   $0x30
  jmp __alltraps
c0101f68:	e9 33 fe ff ff       	jmp    c0101da0 <__alltraps>

c0101f6d <vector49>:
.globl vector49
vector49:
  pushl $0
c0101f6d:	6a 00                	push   $0x0
  pushl $49
c0101f6f:	6a 31                	push   $0x31
  jmp __alltraps
c0101f71:	e9 2a fe ff ff       	jmp    c0101da0 <__alltraps>

c0101f76 <vector50>:
.globl vector50
vector50:
  pushl $0
c0101f76:	6a 00                	push   $0x0
  pushl $50
c0101f78:	6a 32                	push   $0x32
  jmp __alltraps
c0101f7a:	e9 21 fe ff ff       	jmp    c0101da0 <__alltraps>

c0101f7f <vector51>:
.globl vector51
vector51:
  pushl $0
c0101f7f:	6a 00                	push   $0x0
  pushl $51
c0101f81:	6a 33                	push   $0x33
  jmp __alltraps
c0101f83:	e9 18 fe ff ff       	jmp    c0101da0 <__alltraps>

c0101f88 <vector52>:
.globl vector52
vector52:
  pushl $0
c0101f88:	6a 00                	push   $0x0
  pushl $52
c0101f8a:	6a 34                	push   $0x34
  jmp __alltraps
c0101f8c:	e9 0f fe ff ff       	jmp    c0101da0 <__alltraps>

c0101f91 <vector53>:
.globl vector53
vector53:
  pushl $0
c0101f91:	6a 00                	push   $0x0
  pushl $53
c0101f93:	6a 35                	push   $0x35
  jmp __alltraps
c0101f95:	e9 06 fe ff ff       	jmp    c0101da0 <__alltraps>

c0101f9a <vector54>:
.globl vector54
vector54:
  pushl $0
c0101f9a:	6a 00                	push   $0x0
  pushl $54
c0101f9c:	6a 36                	push   $0x36
  jmp __alltraps
c0101f9e:	e9 fd fd ff ff       	jmp    c0101da0 <__alltraps>

c0101fa3 <vector55>:
.globl vector55
vector55:
  pushl $0
c0101fa3:	6a 00                	push   $0x0
  pushl $55
c0101fa5:	6a 37                	push   $0x37
  jmp __alltraps
c0101fa7:	e9 f4 fd ff ff       	jmp    c0101da0 <__alltraps>

c0101fac <vector56>:
.globl vector56
vector56:
  pushl $0
c0101fac:	6a 00                	push   $0x0
  pushl $56
c0101fae:	6a 38                	push   $0x38
  jmp __alltraps
c0101fb0:	e9 eb fd ff ff       	jmp    c0101da0 <__alltraps>

c0101fb5 <vector57>:
.globl vector57
vector57:
  pushl $0
c0101fb5:	6a 00                	push   $0x0
  pushl $57
c0101fb7:	6a 39                	push   $0x39
  jmp __alltraps
c0101fb9:	e9 e2 fd ff ff       	jmp    c0101da0 <__alltraps>

c0101fbe <vector58>:
.globl vector58
vector58:
  pushl $0
c0101fbe:	6a 00                	push   $0x0
  pushl $58
c0101fc0:	6a 3a                	push   $0x3a
  jmp __alltraps
c0101fc2:	e9 d9 fd ff ff       	jmp    c0101da0 <__alltraps>

c0101fc7 <vector59>:
.globl vector59
vector59:
  pushl $0
c0101fc7:	6a 00                	push   $0x0
  pushl $59
c0101fc9:	6a 3b                	push   $0x3b
  jmp __alltraps
c0101fcb:	e9 d0 fd ff ff       	jmp    c0101da0 <__alltraps>

c0101fd0 <vector60>:
.globl vector60
vector60:
  pushl $0
c0101fd0:	6a 00                	push   $0x0
  pushl $60
c0101fd2:	6a 3c                	push   $0x3c
  jmp __alltraps
c0101fd4:	e9 c7 fd ff ff       	jmp    c0101da0 <__alltraps>

c0101fd9 <vector61>:
.globl vector61
vector61:
  pushl $0
c0101fd9:	6a 00                	push   $0x0
  pushl $61
c0101fdb:	6a 3d                	push   $0x3d
  jmp __alltraps
c0101fdd:	e9 be fd ff ff       	jmp    c0101da0 <__alltraps>

c0101fe2 <vector62>:
.globl vector62
vector62:
  pushl $0
c0101fe2:	6a 00                	push   $0x0
  pushl $62
c0101fe4:	6a 3e                	push   $0x3e
  jmp __alltraps
c0101fe6:	e9 b5 fd ff ff       	jmp    c0101da0 <__alltraps>

c0101feb <vector63>:
.globl vector63
vector63:
  pushl $0
c0101feb:	6a 00                	push   $0x0
  pushl $63
c0101fed:	6a 3f                	push   $0x3f
  jmp __alltraps
c0101fef:	e9 ac fd ff ff       	jmp    c0101da0 <__alltraps>

c0101ff4 <vector64>:
.globl vector64
vector64:
  pushl $0
c0101ff4:	6a 00                	push   $0x0
  pushl $64
c0101ff6:	6a 40                	push   $0x40
  jmp __alltraps
c0101ff8:	e9 a3 fd ff ff       	jmp    c0101da0 <__alltraps>

c0101ffd <vector65>:
.globl vector65
vector65:
  pushl $0
c0101ffd:	6a 00                	push   $0x0
  pushl $65
c0101fff:	6a 41                	push   $0x41
  jmp __alltraps
c0102001:	e9 9a fd ff ff       	jmp    c0101da0 <__alltraps>

c0102006 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102006:	6a 00                	push   $0x0
  pushl $66
c0102008:	6a 42                	push   $0x42
  jmp __alltraps
c010200a:	e9 91 fd ff ff       	jmp    c0101da0 <__alltraps>

c010200f <vector67>:
.globl vector67
vector67:
  pushl $0
c010200f:	6a 00                	push   $0x0
  pushl $67
c0102011:	6a 43                	push   $0x43
  jmp __alltraps
c0102013:	e9 88 fd ff ff       	jmp    c0101da0 <__alltraps>

c0102018 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102018:	6a 00                	push   $0x0
  pushl $68
c010201a:	6a 44                	push   $0x44
  jmp __alltraps
c010201c:	e9 7f fd ff ff       	jmp    c0101da0 <__alltraps>

c0102021 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102021:	6a 00                	push   $0x0
  pushl $69
c0102023:	6a 45                	push   $0x45
  jmp __alltraps
c0102025:	e9 76 fd ff ff       	jmp    c0101da0 <__alltraps>

c010202a <vector70>:
.globl vector70
vector70:
  pushl $0
c010202a:	6a 00                	push   $0x0
  pushl $70
c010202c:	6a 46                	push   $0x46
  jmp __alltraps
c010202e:	e9 6d fd ff ff       	jmp    c0101da0 <__alltraps>

c0102033 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102033:	6a 00                	push   $0x0
  pushl $71
c0102035:	6a 47                	push   $0x47
  jmp __alltraps
c0102037:	e9 64 fd ff ff       	jmp    c0101da0 <__alltraps>

c010203c <vector72>:
.globl vector72
vector72:
  pushl $0
c010203c:	6a 00                	push   $0x0
  pushl $72
c010203e:	6a 48                	push   $0x48
  jmp __alltraps
c0102040:	e9 5b fd ff ff       	jmp    c0101da0 <__alltraps>

c0102045 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102045:	6a 00                	push   $0x0
  pushl $73
c0102047:	6a 49                	push   $0x49
  jmp __alltraps
c0102049:	e9 52 fd ff ff       	jmp    c0101da0 <__alltraps>

c010204e <vector74>:
.globl vector74
vector74:
  pushl $0
c010204e:	6a 00                	push   $0x0
  pushl $74
c0102050:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102052:	e9 49 fd ff ff       	jmp    c0101da0 <__alltraps>

c0102057 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102057:	6a 00                	push   $0x0
  pushl $75
c0102059:	6a 4b                	push   $0x4b
  jmp __alltraps
c010205b:	e9 40 fd ff ff       	jmp    c0101da0 <__alltraps>

c0102060 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102060:	6a 00                	push   $0x0
  pushl $76
c0102062:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102064:	e9 37 fd ff ff       	jmp    c0101da0 <__alltraps>

c0102069 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102069:	6a 00                	push   $0x0
  pushl $77
c010206b:	6a 4d                	push   $0x4d
  jmp __alltraps
c010206d:	e9 2e fd ff ff       	jmp    c0101da0 <__alltraps>

c0102072 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102072:	6a 00                	push   $0x0
  pushl $78
c0102074:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102076:	e9 25 fd ff ff       	jmp    c0101da0 <__alltraps>

c010207b <vector79>:
.globl vector79
vector79:
  pushl $0
c010207b:	6a 00                	push   $0x0
  pushl $79
c010207d:	6a 4f                	push   $0x4f
  jmp __alltraps
c010207f:	e9 1c fd ff ff       	jmp    c0101da0 <__alltraps>

c0102084 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102084:	6a 00                	push   $0x0
  pushl $80
c0102086:	6a 50                	push   $0x50
  jmp __alltraps
c0102088:	e9 13 fd ff ff       	jmp    c0101da0 <__alltraps>

c010208d <vector81>:
.globl vector81
vector81:
  pushl $0
c010208d:	6a 00                	push   $0x0
  pushl $81
c010208f:	6a 51                	push   $0x51
  jmp __alltraps
c0102091:	e9 0a fd ff ff       	jmp    c0101da0 <__alltraps>

c0102096 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102096:	6a 00                	push   $0x0
  pushl $82
c0102098:	6a 52                	push   $0x52
  jmp __alltraps
c010209a:	e9 01 fd ff ff       	jmp    c0101da0 <__alltraps>

c010209f <vector83>:
.globl vector83
vector83:
  pushl $0
c010209f:	6a 00                	push   $0x0
  pushl $83
c01020a1:	6a 53                	push   $0x53
  jmp __alltraps
c01020a3:	e9 f8 fc ff ff       	jmp    c0101da0 <__alltraps>

c01020a8 <vector84>:
.globl vector84
vector84:
  pushl $0
c01020a8:	6a 00                	push   $0x0
  pushl $84
c01020aa:	6a 54                	push   $0x54
  jmp __alltraps
c01020ac:	e9 ef fc ff ff       	jmp    c0101da0 <__alltraps>

c01020b1 <vector85>:
.globl vector85
vector85:
  pushl $0
c01020b1:	6a 00                	push   $0x0
  pushl $85
c01020b3:	6a 55                	push   $0x55
  jmp __alltraps
c01020b5:	e9 e6 fc ff ff       	jmp    c0101da0 <__alltraps>

c01020ba <vector86>:
.globl vector86
vector86:
  pushl $0
c01020ba:	6a 00                	push   $0x0
  pushl $86
c01020bc:	6a 56                	push   $0x56
  jmp __alltraps
c01020be:	e9 dd fc ff ff       	jmp    c0101da0 <__alltraps>

c01020c3 <vector87>:
.globl vector87
vector87:
  pushl $0
c01020c3:	6a 00                	push   $0x0
  pushl $87
c01020c5:	6a 57                	push   $0x57
  jmp __alltraps
c01020c7:	e9 d4 fc ff ff       	jmp    c0101da0 <__alltraps>

c01020cc <vector88>:
.globl vector88
vector88:
  pushl $0
c01020cc:	6a 00                	push   $0x0
  pushl $88
c01020ce:	6a 58                	push   $0x58
  jmp __alltraps
c01020d0:	e9 cb fc ff ff       	jmp    c0101da0 <__alltraps>

c01020d5 <vector89>:
.globl vector89
vector89:
  pushl $0
c01020d5:	6a 00                	push   $0x0
  pushl $89
c01020d7:	6a 59                	push   $0x59
  jmp __alltraps
c01020d9:	e9 c2 fc ff ff       	jmp    c0101da0 <__alltraps>

c01020de <vector90>:
.globl vector90
vector90:
  pushl $0
c01020de:	6a 00                	push   $0x0
  pushl $90
c01020e0:	6a 5a                	push   $0x5a
  jmp __alltraps
c01020e2:	e9 b9 fc ff ff       	jmp    c0101da0 <__alltraps>

c01020e7 <vector91>:
.globl vector91
vector91:
  pushl $0
c01020e7:	6a 00                	push   $0x0
  pushl $91
c01020e9:	6a 5b                	push   $0x5b
  jmp __alltraps
c01020eb:	e9 b0 fc ff ff       	jmp    c0101da0 <__alltraps>

c01020f0 <vector92>:
.globl vector92
vector92:
  pushl $0
c01020f0:	6a 00                	push   $0x0
  pushl $92
c01020f2:	6a 5c                	push   $0x5c
  jmp __alltraps
c01020f4:	e9 a7 fc ff ff       	jmp    c0101da0 <__alltraps>

c01020f9 <vector93>:
.globl vector93
vector93:
  pushl $0
c01020f9:	6a 00                	push   $0x0
  pushl $93
c01020fb:	6a 5d                	push   $0x5d
  jmp __alltraps
c01020fd:	e9 9e fc ff ff       	jmp    c0101da0 <__alltraps>

c0102102 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102102:	6a 00                	push   $0x0
  pushl $94
c0102104:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102106:	e9 95 fc ff ff       	jmp    c0101da0 <__alltraps>

c010210b <vector95>:
.globl vector95
vector95:
  pushl $0
c010210b:	6a 00                	push   $0x0
  pushl $95
c010210d:	6a 5f                	push   $0x5f
  jmp __alltraps
c010210f:	e9 8c fc ff ff       	jmp    c0101da0 <__alltraps>

c0102114 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102114:	6a 00                	push   $0x0
  pushl $96
c0102116:	6a 60                	push   $0x60
  jmp __alltraps
c0102118:	e9 83 fc ff ff       	jmp    c0101da0 <__alltraps>

c010211d <vector97>:
.globl vector97
vector97:
  pushl $0
c010211d:	6a 00                	push   $0x0
  pushl $97
c010211f:	6a 61                	push   $0x61
  jmp __alltraps
c0102121:	e9 7a fc ff ff       	jmp    c0101da0 <__alltraps>

c0102126 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102126:	6a 00                	push   $0x0
  pushl $98
c0102128:	6a 62                	push   $0x62
  jmp __alltraps
c010212a:	e9 71 fc ff ff       	jmp    c0101da0 <__alltraps>

c010212f <vector99>:
.globl vector99
vector99:
  pushl $0
c010212f:	6a 00                	push   $0x0
  pushl $99
c0102131:	6a 63                	push   $0x63
  jmp __alltraps
c0102133:	e9 68 fc ff ff       	jmp    c0101da0 <__alltraps>

c0102138 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102138:	6a 00                	push   $0x0
  pushl $100
c010213a:	6a 64                	push   $0x64
  jmp __alltraps
c010213c:	e9 5f fc ff ff       	jmp    c0101da0 <__alltraps>

c0102141 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102141:	6a 00                	push   $0x0
  pushl $101
c0102143:	6a 65                	push   $0x65
  jmp __alltraps
c0102145:	e9 56 fc ff ff       	jmp    c0101da0 <__alltraps>

c010214a <vector102>:
.globl vector102
vector102:
  pushl $0
c010214a:	6a 00                	push   $0x0
  pushl $102
c010214c:	6a 66                	push   $0x66
  jmp __alltraps
c010214e:	e9 4d fc ff ff       	jmp    c0101da0 <__alltraps>

c0102153 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102153:	6a 00                	push   $0x0
  pushl $103
c0102155:	6a 67                	push   $0x67
  jmp __alltraps
c0102157:	e9 44 fc ff ff       	jmp    c0101da0 <__alltraps>

c010215c <vector104>:
.globl vector104
vector104:
  pushl $0
c010215c:	6a 00                	push   $0x0
  pushl $104
c010215e:	6a 68                	push   $0x68
  jmp __alltraps
c0102160:	e9 3b fc ff ff       	jmp    c0101da0 <__alltraps>

c0102165 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102165:	6a 00                	push   $0x0
  pushl $105
c0102167:	6a 69                	push   $0x69
  jmp __alltraps
c0102169:	e9 32 fc ff ff       	jmp    c0101da0 <__alltraps>

c010216e <vector106>:
.globl vector106
vector106:
  pushl $0
c010216e:	6a 00                	push   $0x0
  pushl $106
c0102170:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102172:	e9 29 fc ff ff       	jmp    c0101da0 <__alltraps>

c0102177 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102177:	6a 00                	push   $0x0
  pushl $107
c0102179:	6a 6b                	push   $0x6b
  jmp __alltraps
c010217b:	e9 20 fc ff ff       	jmp    c0101da0 <__alltraps>

c0102180 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102180:	6a 00                	push   $0x0
  pushl $108
c0102182:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102184:	e9 17 fc ff ff       	jmp    c0101da0 <__alltraps>

c0102189 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102189:	6a 00                	push   $0x0
  pushl $109
c010218b:	6a 6d                	push   $0x6d
  jmp __alltraps
c010218d:	e9 0e fc ff ff       	jmp    c0101da0 <__alltraps>

c0102192 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102192:	6a 00                	push   $0x0
  pushl $110
c0102194:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102196:	e9 05 fc ff ff       	jmp    c0101da0 <__alltraps>

c010219b <vector111>:
.globl vector111
vector111:
  pushl $0
c010219b:	6a 00                	push   $0x0
  pushl $111
c010219d:	6a 6f                	push   $0x6f
  jmp __alltraps
c010219f:	e9 fc fb ff ff       	jmp    c0101da0 <__alltraps>

c01021a4 <vector112>:
.globl vector112
vector112:
  pushl $0
c01021a4:	6a 00                	push   $0x0
  pushl $112
c01021a6:	6a 70                	push   $0x70
  jmp __alltraps
c01021a8:	e9 f3 fb ff ff       	jmp    c0101da0 <__alltraps>

c01021ad <vector113>:
.globl vector113
vector113:
  pushl $0
c01021ad:	6a 00                	push   $0x0
  pushl $113
c01021af:	6a 71                	push   $0x71
  jmp __alltraps
c01021b1:	e9 ea fb ff ff       	jmp    c0101da0 <__alltraps>

c01021b6 <vector114>:
.globl vector114
vector114:
  pushl $0
c01021b6:	6a 00                	push   $0x0
  pushl $114
c01021b8:	6a 72                	push   $0x72
  jmp __alltraps
c01021ba:	e9 e1 fb ff ff       	jmp    c0101da0 <__alltraps>

c01021bf <vector115>:
.globl vector115
vector115:
  pushl $0
c01021bf:	6a 00                	push   $0x0
  pushl $115
c01021c1:	6a 73                	push   $0x73
  jmp __alltraps
c01021c3:	e9 d8 fb ff ff       	jmp    c0101da0 <__alltraps>

c01021c8 <vector116>:
.globl vector116
vector116:
  pushl $0
c01021c8:	6a 00                	push   $0x0
  pushl $116
c01021ca:	6a 74                	push   $0x74
  jmp __alltraps
c01021cc:	e9 cf fb ff ff       	jmp    c0101da0 <__alltraps>

c01021d1 <vector117>:
.globl vector117
vector117:
  pushl $0
c01021d1:	6a 00                	push   $0x0
  pushl $117
c01021d3:	6a 75                	push   $0x75
  jmp __alltraps
c01021d5:	e9 c6 fb ff ff       	jmp    c0101da0 <__alltraps>

c01021da <vector118>:
.globl vector118
vector118:
  pushl $0
c01021da:	6a 00                	push   $0x0
  pushl $118
c01021dc:	6a 76                	push   $0x76
  jmp __alltraps
c01021de:	e9 bd fb ff ff       	jmp    c0101da0 <__alltraps>

c01021e3 <vector119>:
.globl vector119
vector119:
  pushl $0
c01021e3:	6a 00                	push   $0x0
  pushl $119
c01021e5:	6a 77                	push   $0x77
  jmp __alltraps
c01021e7:	e9 b4 fb ff ff       	jmp    c0101da0 <__alltraps>

c01021ec <vector120>:
.globl vector120
vector120:
  pushl $0
c01021ec:	6a 00                	push   $0x0
  pushl $120
c01021ee:	6a 78                	push   $0x78
  jmp __alltraps
c01021f0:	e9 ab fb ff ff       	jmp    c0101da0 <__alltraps>

c01021f5 <vector121>:
.globl vector121
vector121:
  pushl $0
c01021f5:	6a 00                	push   $0x0
  pushl $121
c01021f7:	6a 79                	push   $0x79
  jmp __alltraps
c01021f9:	e9 a2 fb ff ff       	jmp    c0101da0 <__alltraps>

c01021fe <vector122>:
.globl vector122
vector122:
  pushl $0
c01021fe:	6a 00                	push   $0x0
  pushl $122
c0102200:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102202:	e9 99 fb ff ff       	jmp    c0101da0 <__alltraps>

c0102207 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102207:	6a 00                	push   $0x0
  pushl $123
c0102209:	6a 7b                	push   $0x7b
  jmp __alltraps
c010220b:	e9 90 fb ff ff       	jmp    c0101da0 <__alltraps>

c0102210 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102210:	6a 00                	push   $0x0
  pushl $124
c0102212:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102214:	e9 87 fb ff ff       	jmp    c0101da0 <__alltraps>

c0102219 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102219:	6a 00                	push   $0x0
  pushl $125
c010221b:	6a 7d                	push   $0x7d
  jmp __alltraps
c010221d:	e9 7e fb ff ff       	jmp    c0101da0 <__alltraps>

c0102222 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102222:	6a 00                	push   $0x0
  pushl $126
c0102224:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102226:	e9 75 fb ff ff       	jmp    c0101da0 <__alltraps>

c010222b <vector127>:
.globl vector127
vector127:
  pushl $0
c010222b:	6a 00                	push   $0x0
  pushl $127
c010222d:	6a 7f                	push   $0x7f
  jmp __alltraps
c010222f:	e9 6c fb ff ff       	jmp    c0101da0 <__alltraps>

c0102234 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102234:	6a 00                	push   $0x0
  pushl $128
c0102236:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c010223b:	e9 60 fb ff ff       	jmp    c0101da0 <__alltraps>

c0102240 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102240:	6a 00                	push   $0x0
  pushl $129
c0102242:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102247:	e9 54 fb ff ff       	jmp    c0101da0 <__alltraps>

c010224c <vector130>:
.globl vector130
vector130:
  pushl $0
c010224c:	6a 00                	push   $0x0
  pushl $130
c010224e:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102253:	e9 48 fb ff ff       	jmp    c0101da0 <__alltraps>

c0102258 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102258:	6a 00                	push   $0x0
  pushl $131
c010225a:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c010225f:	e9 3c fb ff ff       	jmp    c0101da0 <__alltraps>

c0102264 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102264:	6a 00                	push   $0x0
  pushl $132
c0102266:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c010226b:	e9 30 fb ff ff       	jmp    c0101da0 <__alltraps>

c0102270 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102270:	6a 00                	push   $0x0
  pushl $133
c0102272:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102277:	e9 24 fb ff ff       	jmp    c0101da0 <__alltraps>

c010227c <vector134>:
.globl vector134
vector134:
  pushl $0
c010227c:	6a 00                	push   $0x0
  pushl $134
c010227e:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102283:	e9 18 fb ff ff       	jmp    c0101da0 <__alltraps>

c0102288 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102288:	6a 00                	push   $0x0
  pushl $135
c010228a:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c010228f:	e9 0c fb ff ff       	jmp    c0101da0 <__alltraps>

c0102294 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102294:	6a 00                	push   $0x0
  pushl $136
c0102296:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c010229b:	e9 00 fb ff ff       	jmp    c0101da0 <__alltraps>

c01022a0 <vector137>:
.globl vector137
vector137:
  pushl $0
c01022a0:	6a 00                	push   $0x0
  pushl $137
c01022a2:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01022a7:	e9 f4 fa ff ff       	jmp    c0101da0 <__alltraps>

c01022ac <vector138>:
.globl vector138
vector138:
  pushl $0
c01022ac:	6a 00                	push   $0x0
  pushl $138
c01022ae:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c01022b3:	e9 e8 fa ff ff       	jmp    c0101da0 <__alltraps>

c01022b8 <vector139>:
.globl vector139
vector139:
  pushl $0
c01022b8:	6a 00                	push   $0x0
  pushl $139
c01022ba:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c01022bf:	e9 dc fa ff ff       	jmp    c0101da0 <__alltraps>

c01022c4 <vector140>:
.globl vector140
vector140:
  pushl $0
c01022c4:	6a 00                	push   $0x0
  pushl $140
c01022c6:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c01022cb:	e9 d0 fa ff ff       	jmp    c0101da0 <__alltraps>

c01022d0 <vector141>:
.globl vector141
vector141:
  pushl $0
c01022d0:	6a 00                	push   $0x0
  pushl $141
c01022d2:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c01022d7:	e9 c4 fa ff ff       	jmp    c0101da0 <__alltraps>

c01022dc <vector142>:
.globl vector142
vector142:
  pushl $0
c01022dc:	6a 00                	push   $0x0
  pushl $142
c01022de:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01022e3:	e9 b8 fa ff ff       	jmp    c0101da0 <__alltraps>

c01022e8 <vector143>:
.globl vector143
vector143:
  pushl $0
c01022e8:	6a 00                	push   $0x0
  pushl $143
c01022ea:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01022ef:	e9 ac fa ff ff       	jmp    c0101da0 <__alltraps>

c01022f4 <vector144>:
.globl vector144
vector144:
  pushl $0
c01022f4:	6a 00                	push   $0x0
  pushl $144
c01022f6:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01022fb:	e9 a0 fa ff ff       	jmp    c0101da0 <__alltraps>

c0102300 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102300:	6a 00                	push   $0x0
  pushl $145
c0102302:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102307:	e9 94 fa ff ff       	jmp    c0101da0 <__alltraps>

c010230c <vector146>:
.globl vector146
vector146:
  pushl $0
c010230c:	6a 00                	push   $0x0
  pushl $146
c010230e:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102313:	e9 88 fa ff ff       	jmp    c0101da0 <__alltraps>

c0102318 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102318:	6a 00                	push   $0x0
  pushl $147
c010231a:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c010231f:	e9 7c fa ff ff       	jmp    c0101da0 <__alltraps>

c0102324 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102324:	6a 00                	push   $0x0
  pushl $148
c0102326:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c010232b:	e9 70 fa ff ff       	jmp    c0101da0 <__alltraps>

c0102330 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102330:	6a 00                	push   $0x0
  pushl $149
c0102332:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102337:	e9 64 fa ff ff       	jmp    c0101da0 <__alltraps>

c010233c <vector150>:
.globl vector150
vector150:
  pushl $0
c010233c:	6a 00                	push   $0x0
  pushl $150
c010233e:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102343:	e9 58 fa ff ff       	jmp    c0101da0 <__alltraps>

c0102348 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102348:	6a 00                	push   $0x0
  pushl $151
c010234a:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c010234f:	e9 4c fa ff ff       	jmp    c0101da0 <__alltraps>

c0102354 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102354:	6a 00                	push   $0x0
  pushl $152
c0102356:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c010235b:	e9 40 fa ff ff       	jmp    c0101da0 <__alltraps>

c0102360 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102360:	6a 00                	push   $0x0
  pushl $153
c0102362:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102367:	e9 34 fa ff ff       	jmp    c0101da0 <__alltraps>

c010236c <vector154>:
.globl vector154
vector154:
  pushl $0
c010236c:	6a 00                	push   $0x0
  pushl $154
c010236e:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102373:	e9 28 fa ff ff       	jmp    c0101da0 <__alltraps>

c0102378 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102378:	6a 00                	push   $0x0
  pushl $155
c010237a:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c010237f:	e9 1c fa ff ff       	jmp    c0101da0 <__alltraps>

c0102384 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102384:	6a 00                	push   $0x0
  pushl $156
c0102386:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c010238b:	e9 10 fa ff ff       	jmp    c0101da0 <__alltraps>

c0102390 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102390:	6a 00                	push   $0x0
  pushl $157
c0102392:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102397:	e9 04 fa ff ff       	jmp    c0101da0 <__alltraps>

c010239c <vector158>:
.globl vector158
vector158:
  pushl $0
c010239c:	6a 00                	push   $0x0
  pushl $158
c010239e:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c01023a3:	e9 f8 f9 ff ff       	jmp    c0101da0 <__alltraps>

c01023a8 <vector159>:
.globl vector159
vector159:
  pushl $0
c01023a8:	6a 00                	push   $0x0
  pushl $159
c01023aa:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c01023af:	e9 ec f9 ff ff       	jmp    c0101da0 <__alltraps>

c01023b4 <vector160>:
.globl vector160
vector160:
  pushl $0
c01023b4:	6a 00                	push   $0x0
  pushl $160
c01023b6:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c01023bb:	e9 e0 f9 ff ff       	jmp    c0101da0 <__alltraps>

c01023c0 <vector161>:
.globl vector161
vector161:
  pushl $0
c01023c0:	6a 00                	push   $0x0
  pushl $161
c01023c2:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01023c7:	e9 d4 f9 ff ff       	jmp    c0101da0 <__alltraps>

c01023cc <vector162>:
.globl vector162
vector162:
  pushl $0
c01023cc:	6a 00                	push   $0x0
  pushl $162
c01023ce:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c01023d3:	e9 c8 f9 ff ff       	jmp    c0101da0 <__alltraps>

c01023d8 <vector163>:
.globl vector163
vector163:
  pushl $0
c01023d8:	6a 00                	push   $0x0
  pushl $163
c01023da:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01023df:	e9 bc f9 ff ff       	jmp    c0101da0 <__alltraps>

c01023e4 <vector164>:
.globl vector164
vector164:
  pushl $0
c01023e4:	6a 00                	push   $0x0
  pushl $164
c01023e6:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01023eb:	e9 b0 f9 ff ff       	jmp    c0101da0 <__alltraps>

c01023f0 <vector165>:
.globl vector165
vector165:
  pushl $0
c01023f0:	6a 00                	push   $0x0
  pushl $165
c01023f2:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01023f7:	e9 a4 f9 ff ff       	jmp    c0101da0 <__alltraps>

c01023fc <vector166>:
.globl vector166
vector166:
  pushl $0
c01023fc:	6a 00                	push   $0x0
  pushl $166
c01023fe:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102403:	e9 98 f9 ff ff       	jmp    c0101da0 <__alltraps>

c0102408 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102408:	6a 00                	push   $0x0
  pushl $167
c010240a:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c010240f:	e9 8c f9 ff ff       	jmp    c0101da0 <__alltraps>

c0102414 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102414:	6a 00                	push   $0x0
  pushl $168
c0102416:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c010241b:	e9 80 f9 ff ff       	jmp    c0101da0 <__alltraps>

c0102420 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102420:	6a 00                	push   $0x0
  pushl $169
c0102422:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102427:	e9 74 f9 ff ff       	jmp    c0101da0 <__alltraps>

c010242c <vector170>:
.globl vector170
vector170:
  pushl $0
c010242c:	6a 00                	push   $0x0
  pushl $170
c010242e:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102433:	e9 68 f9 ff ff       	jmp    c0101da0 <__alltraps>

c0102438 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102438:	6a 00                	push   $0x0
  pushl $171
c010243a:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c010243f:	e9 5c f9 ff ff       	jmp    c0101da0 <__alltraps>

c0102444 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102444:	6a 00                	push   $0x0
  pushl $172
c0102446:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c010244b:	e9 50 f9 ff ff       	jmp    c0101da0 <__alltraps>

c0102450 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102450:	6a 00                	push   $0x0
  pushl $173
c0102452:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102457:	e9 44 f9 ff ff       	jmp    c0101da0 <__alltraps>

c010245c <vector174>:
.globl vector174
vector174:
  pushl $0
c010245c:	6a 00                	push   $0x0
  pushl $174
c010245e:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102463:	e9 38 f9 ff ff       	jmp    c0101da0 <__alltraps>

c0102468 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102468:	6a 00                	push   $0x0
  pushl $175
c010246a:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c010246f:	e9 2c f9 ff ff       	jmp    c0101da0 <__alltraps>

c0102474 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102474:	6a 00                	push   $0x0
  pushl $176
c0102476:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c010247b:	e9 20 f9 ff ff       	jmp    c0101da0 <__alltraps>

c0102480 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102480:	6a 00                	push   $0x0
  pushl $177
c0102482:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102487:	e9 14 f9 ff ff       	jmp    c0101da0 <__alltraps>

c010248c <vector178>:
.globl vector178
vector178:
  pushl $0
c010248c:	6a 00                	push   $0x0
  pushl $178
c010248e:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102493:	e9 08 f9 ff ff       	jmp    c0101da0 <__alltraps>

c0102498 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102498:	6a 00                	push   $0x0
  pushl $179
c010249a:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c010249f:	e9 fc f8 ff ff       	jmp    c0101da0 <__alltraps>

c01024a4 <vector180>:
.globl vector180
vector180:
  pushl $0
c01024a4:	6a 00                	push   $0x0
  pushl $180
c01024a6:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c01024ab:	e9 f0 f8 ff ff       	jmp    c0101da0 <__alltraps>

c01024b0 <vector181>:
.globl vector181
vector181:
  pushl $0
c01024b0:	6a 00                	push   $0x0
  pushl $181
c01024b2:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c01024b7:	e9 e4 f8 ff ff       	jmp    c0101da0 <__alltraps>

c01024bc <vector182>:
.globl vector182
vector182:
  pushl $0
c01024bc:	6a 00                	push   $0x0
  pushl $182
c01024be:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c01024c3:	e9 d8 f8 ff ff       	jmp    c0101da0 <__alltraps>

c01024c8 <vector183>:
.globl vector183
vector183:
  pushl $0
c01024c8:	6a 00                	push   $0x0
  pushl $183
c01024ca:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c01024cf:	e9 cc f8 ff ff       	jmp    c0101da0 <__alltraps>

c01024d4 <vector184>:
.globl vector184
vector184:
  pushl $0
c01024d4:	6a 00                	push   $0x0
  pushl $184
c01024d6:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01024db:	e9 c0 f8 ff ff       	jmp    c0101da0 <__alltraps>

c01024e0 <vector185>:
.globl vector185
vector185:
  pushl $0
c01024e0:	6a 00                	push   $0x0
  pushl $185
c01024e2:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01024e7:	e9 b4 f8 ff ff       	jmp    c0101da0 <__alltraps>

c01024ec <vector186>:
.globl vector186
vector186:
  pushl $0
c01024ec:	6a 00                	push   $0x0
  pushl $186
c01024ee:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01024f3:	e9 a8 f8 ff ff       	jmp    c0101da0 <__alltraps>

c01024f8 <vector187>:
.globl vector187
vector187:
  pushl $0
c01024f8:	6a 00                	push   $0x0
  pushl $187
c01024fa:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01024ff:	e9 9c f8 ff ff       	jmp    c0101da0 <__alltraps>

c0102504 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102504:	6a 00                	push   $0x0
  pushl $188
c0102506:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c010250b:	e9 90 f8 ff ff       	jmp    c0101da0 <__alltraps>

c0102510 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102510:	6a 00                	push   $0x0
  pushl $189
c0102512:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102517:	e9 84 f8 ff ff       	jmp    c0101da0 <__alltraps>

c010251c <vector190>:
.globl vector190
vector190:
  pushl $0
c010251c:	6a 00                	push   $0x0
  pushl $190
c010251e:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102523:	e9 78 f8 ff ff       	jmp    c0101da0 <__alltraps>

c0102528 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102528:	6a 00                	push   $0x0
  pushl $191
c010252a:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c010252f:	e9 6c f8 ff ff       	jmp    c0101da0 <__alltraps>

c0102534 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102534:	6a 00                	push   $0x0
  pushl $192
c0102536:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c010253b:	e9 60 f8 ff ff       	jmp    c0101da0 <__alltraps>

c0102540 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102540:	6a 00                	push   $0x0
  pushl $193
c0102542:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102547:	e9 54 f8 ff ff       	jmp    c0101da0 <__alltraps>

c010254c <vector194>:
.globl vector194
vector194:
  pushl $0
c010254c:	6a 00                	push   $0x0
  pushl $194
c010254e:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102553:	e9 48 f8 ff ff       	jmp    c0101da0 <__alltraps>

c0102558 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102558:	6a 00                	push   $0x0
  pushl $195
c010255a:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c010255f:	e9 3c f8 ff ff       	jmp    c0101da0 <__alltraps>

c0102564 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102564:	6a 00                	push   $0x0
  pushl $196
c0102566:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c010256b:	e9 30 f8 ff ff       	jmp    c0101da0 <__alltraps>

c0102570 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102570:	6a 00                	push   $0x0
  pushl $197
c0102572:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102577:	e9 24 f8 ff ff       	jmp    c0101da0 <__alltraps>

c010257c <vector198>:
.globl vector198
vector198:
  pushl $0
c010257c:	6a 00                	push   $0x0
  pushl $198
c010257e:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102583:	e9 18 f8 ff ff       	jmp    c0101da0 <__alltraps>

c0102588 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102588:	6a 00                	push   $0x0
  pushl $199
c010258a:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c010258f:	e9 0c f8 ff ff       	jmp    c0101da0 <__alltraps>

c0102594 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102594:	6a 00                	push   $0x0
  pushl $200
c0102596:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c010259b:	e9 00 f8 ff ff       	jmp    c0101da0 <__alltraps>

c01025a0 <vector201>:
.globl vector201
vector201:
  pushl $0
c01025a0:	6a 00                	push   $0x0
  pushl $201
c01025a2:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01025a7:	e9 f4 f7 ff ff       	jmp    c0101da0 <__alltraps>

c01025ac <vector202>:
.globl vector202
vector202:
  pushl $0
c01025ac:	6a 00                	push   $0x0
  pushl $202
c01025ae:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01025b3:	e9 e8 f7 ff ff       	jmp    c0101da0 <__alltraps>

c01025b8 <vector203>:
.globl vector203
vector203:
  pushl $0
c01025b8:	6a 00                	push   $0x0
  pushl $203
c01025ba:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c01025bf:	e9 dc f7 ff ff       	jmp    c0101da0 <__alltraps>

c01025c4 <vector204>:
.globl vector204
vector204:
  pushl $0
c01025c4:	6a 00                	push   $0x0
  pushl $204
c01025c6:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01025cb:	e9 d0 f7 ff ff       	jmp    c0101da0 <__alltraps>

c01025d0 <vector205>:
.globl vector205
vector205:
  pushl $0
c01025d0:	6a 00                	push   $0x0
  pushl $205
c01025d2:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01025d7:	e9 c4 f7 ff ff       	jmp    c0101da0 <__alltraps>

c01025dc <vector206>:
.globl vector206
vector206:
  pushl $0
c01025dc:	6a 00                	push   $0x0
  pushl $206
c01025de:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01025e3:	e9 b8 f7 ff ff       	jmp    c0101da0 <__alltraps>

c01025e8 <vector207>:
.globl vector207
vector207:
  pushl $0
c01025e8:	6a 00                	push   $0x0
  pushl $207
c01025ea:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01025ef:	e9 ac f7 ff ff       	jmp    c0101da0 <__alltraps>

c01025f4 <vector208>:
.globl vector208
vector208:
  pushl $0
c01025f4:	6a 00                	push   $0x0
  pushl $208
c01025f6:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01025fb:	e9 a0 f7 ff ff       	jmp    c0101da0 <__alltraps>

c0102600 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102600:	6a 00                	push   $0x0
  pushl $209
c0102602:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102607:	e9 94 f7 ff ff       	jmp    c0101da0 <__alltraps>

c010260c <vector210>:
.globl vector210
vector210:
  pushl $0
c010260c:	6a 00                	push   $0x0
  pushl $210
c010260e:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102613:	e9 88 f7 ff ff       	jmp    c0101da0 <__alltraps>

c0102618 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102618:	6a 00                	push   $0x0
  pushl $211
c010261a:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c010261f:	e9 7c f7 ff ff       	jmp    c0101da0 <__alltraps>

c0102624 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102624:	6a 00                	push   $0x0
  pushl $212
c0102626:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c010262b:	e9 70 f7 ff ff       	jmp    c0101da0 <__alltraps>

c0102630 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102630:	6a 00                	push   $0x0
  pushl $213
c0102632:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102637:	e9 64 f7 ff ff       	jmp    c0101da0 <__alltraps>

c010263c <vector214>:
.globl vector214
vector214:
  pushl $0
c010263c:	6a 00                	push   $0x0
  pushl $214
c010263e:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102643:	e9 58 f7 ff ff       	jmp    c0101da0 <__alltraps>

c0102648 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102648:	6a 00                	push   $0x0
  pushl $215
c010264a:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c010264f:	e9 4c f7 ff ff       	jmp    c0101da0 <__alltraps>

c0102654 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102654:	6a 00                	push   $0x0
  pushl $216
c0102656:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c010265b:	e9 40 f7 ff ff       	jmp    c0101da0 <__alltraps>

c0102660 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102660:	6a 00                	push   $0x0
  pushl $217
c0102662:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102667:	e9 34 f7 ff ff       	jmp    c0101da0 <__alltraps>

c010266c <vector218>:
.globl vector218
vector218:
  pushl $0
c010266c:	6a 00                	push   $0x0
  pushl $218
c010266e:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102673:	e9 28 f7 ff ff       	jmp    c0101da0 <__alltraps>

c0102678 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102678:	6a 00                	push   $0x0
  pushl $219
c010267a:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010267f:	e9 1c f7 ff ff       	jmp    c0101da0 <__alltraps>

c0102684 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102684:	6a 00                	push   $0x0
  pushl $220
c0102686:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c010268b:	e9 10 f7 ff ff       	jmp    c0101da0 <__alltraps>

c0102690 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102690:	6a 00                	push   $0x0
  pushl $221
c0102692:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102697:	e9 04 f7 ff ff       	jmp    c0101da0 <__alltraps>

c010269c <vector222>:
.globl vector222
vector222:
  pushl $0
c010269c:	6a 00                	push   $0x0
  pushl $222
c010269e:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01026a3:	e9 f8 f6 ff ff       	jmp    c0101da0 <__alltraps>

c01026a8 <vector223>:
.globl vector223
vector223:
  pushl $0
c01026a8:	6a 00                	push   $0x0
  pushl $223
c01026aa:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01026af:	e9 ec f6 ff ff       	jmp    c0101da0 <__alltraps>

c01026b4 <vector224>:
.globl vector224
vector224:
  pushl $0
c01026b4:	6a 00                	push   $0x0
  pushl $224
c01026b6:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01026bb:	e9 e0 f6 ff ff       	jmp    c0101da0 <__alltraps>

c01026c0 <vector225>:
.globl vector225
vector225:
  pushl $0
c01026c0:	6a 00                	push   $0x0
  pushl $225
c01026c2:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01026c7:	e9 d4 f6 ff ff       	jmp    c0101da0 <__alltraps>

c01026cc <vector226>:
.globl vector226
vector226:
  pushl $0
c01026cc:	6a 00                	push   $0x0
  pushl $226
c01026ce:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01026d3:	e9 c8 f6 ff ff       	jmp    c0101da0 <__alltraps>

c01026d8 <vector227>:
.globl vector227
vector227:
  pushl $0
c01026d8:	6a 00                	push   $0x0
  pushl $227
c01026da:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01026df:	e9 bc f6 ff ff       	jmp    c0101da0 <__alltraps>

c01026e4 <vector228>:
.globl vector228
vector228:
  pushl $0
c01026e4:	6a 00                	push   $0x0
  pushl $228
c01026e6:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01026eb:	e9 b0 f6 ff ff       	jmp    c0101da0 <__alltraps>

c01026f0 <vector229>:
.globl vector229
vector229:
  pushl $0
c01026f0:	6a 00                	push   $0x0
  pushl $229
c01026f2:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01026f7:	e9 a4 f6 ff ff       	jmp    c0101da0 <__alltraps>

c01026fc <vector230>:
.globl vector230
vector230:
  pushl $0
c01026fc:	6a 00                	push   $0x0
  pushl $230
c01026fe:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102703:	e9 98 f6 ff ff       	jmp    c0101da0 <__alltraps>

c0102708 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102708:	6a 00                	push   $0x0
  pushl $231
c010270a:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c010270f:	e9 8c f6 ff ff       	jmp    c0101da0 <__alltraps>

c0102714 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102714:	6a 00                	push   $0x0
  pushl $232
c0102716:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c010271b:	e9 80 f6 ff ff       	jmp    c0101da0 <__alltraps>

c0102720 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102720:	6a 00                	push   $0x0
  pushl $233
c0102722:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102727:	e9 74 f6 ff ff       	jmp    c0101da0 <__alltraps>

c010272c <vector234>:
.globl vector234
vector234:
  pushl $0
c010272c:	6a 00                	push   $0x0
  pushl $234
c010272e:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102733:	e9 68 f6 ff ff       	jmp    c0101da0 <__alltraps>

c0102738 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102738:	6a 00                	push   $0x0
  pushl $235
c010273a:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c010273f:	e9 5c f6 ff ff       	jmp    c0101da0 <__alltraps>

c0102744 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102744:	6a 00                	push   $0x0
  pushl $236
c0102746:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c010274b:	e9 50 f6 ff ff       	jmp    c0101da0 <__alltraps>

c0102750 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102750:	6a 00                	push   $0x0
  pushl $237
c0102752:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102757:	e9 44 f6 ff ff       	jmp    c0101da0 <__alltraps>

c010275c <vector238>:
.globl vector238
vector238:
  pushl $0
c010275c:	6a 00                	push   $0x0
  pushl $238
c010275e:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102763:	e9 38 f6 ff ff       	jmp    c0101da0 <__alltraps>

c0102768 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102768:	6a 00                	push   $0x0
  pushl $239
c010276a:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010276f:	e9 2c f6 ff ff       	jmp    c0101da0 <__alltraps>

c0102774 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102774:	6a 00                	push   $0x0
  pushl $240
c0102776:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c010277b:	e9 20 f6 ff ff       	jmp    c0101da0 <__alltraps>

c0102780 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102780:	6a 00                	push   $0x0
  pushl $241
c0102782:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102787:	e9 14 f6 ff ff       	jmp    c0101da0 <__alltraps>

c010278c <vector242>:
.globl vector242
vector242:
  pushl $0
c010278c:	6a 00                	push   $0x0
  pushl $242
c010278e:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102793:	e9 08 f6 ff ff       	jmp    c0101da0 <__alltraps>

c0102798 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102798:	6a 00                	push   $0x0
  pushl $243
c010279a:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010279f:	e9 fc f5 ff ff       	jmp    c0101da0 <__alltraps>

c01027a4 <vector244>:
.globl vector244
vector244:
  pushl $0
c01027a4:	6a 00                	push   $0x0
  pushl $244
c01027a6:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01027ab:	e9 f0 f5 ff ff       	jmp    c0101da0 <__alltraps>

c01027b0 <vector245>:
.globl vector245
vector245:
  pushl $0
c01027b0:	6a 00                	push   $0x0
  pushl $245
c01027b2:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01027b7:	e9 e4 f5 ff ff       	jmp    c0101da0 <__alltraps>

c01027bc <vector246>:
.globl vector246
vector246:
  pushl $0
c01027bc:	6a 00                	push   $0x0
  pushl $246
c01027be:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01027c3:	e9 d8 f5 ff ff       	jmp    c0101da0 <__alltraps>

c01027c8 <vector247>:
.globl vector247
vector247:
  pushl $0
c01027c8:	6a 00                	push   $0x0
  pushl $247
c01027ca:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01027cf:	e9 cc f5 ff ff       	jmp    c0101da0 <__alltraps>

c01027d4 <vector248>:
.globl vector248
vector248:
  pushl $0
c01027d4:	6a 00                	push   $0x0
  pushl $248
c01027d6:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01027db:	e9 c0 f5 ff ff       	jmp    c0101da0 <__alltraps>

c01027e0 <vector249>:
.globl vector249
vector249:
  pushl $0
c01027e0:	6a 00                	push   $0x0
  pushl $249
c01027e2:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01027e7:	e9 b4 f5 ff ff       	jmp    c0101da0 <__alltraps>

c01027ec <vector250>:
.globl vector250
vector250:
  pushl $0
c01027ec:	6a 00                	push   $0x0
  pushl $250
c01027ee:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01027f3:	e9 a8 f5 ff ff       	jmp    c0101da0 <__alltraps>

c01027f8 <vector251>:
.globl vector251
vector251:
  pushl $0
c01027f8:	6a 00                	push   $0x0
  pushl $251
c01027fa:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01027ff:	e9 9c f5 ff ff       	jmp    c0101da0 <__alltraps>

c0102804 <vector252>:
.globl vector252
vector252:
  pushl $0
c0102804:	6a 00                	push   $0x0
  pushl $252
c0102806:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c010280b:	e9 90 f5 ff ff       	jmp    c0101da0 <__alltraps>

c0102810 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102810:	6a 00                	push   $0x0
  pushl $253
c0102812:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102817:	e9 84 f5 ff ff       	jmp    c0101da0 <__alltraps>

c010281c <vector254>:
.globl vector254
vector254:
  pushl $0
c010281c:	6a 00                	push   $0x0
  pushl $254
c010281e:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102823:	e9 78 f5 ff ff       	jmp    c0101da0 <__alltraps>

c0102828 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102828:	6a 00                	push   $0x0
  pushl $255
c010282a:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c010282f:	e9 6c f5 ff ff       	jmp    c0101da0 <__alltraps>

c0102834 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102834:	55                   	push   %ebp
c0102835:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102837:	a1 24 bf 11 c0       	mov    0xc011bf24,%eax
c010283c:	8b 55 08             	mov    0x8(%ebp),%edx
c010283f:	29 c2                	sub    %eax,%edx
c0102841:	89 d0                	mov    %edx,%eax
c0102843:	c1 f8 02             	sar    $0x2,%eax
c0102846:	89 c2                	mov    %eax,%edx
c0102848:	89 d0                	mov    %edx,%eax
c010284a:	c1 e0 02             	shl    $0x2,%eax
c010284d:	01 d0                	add    %edx,%eax
c010284f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
c0102856:	01 c8                	add    %ecx,%eax
c0102858:	01 c0                	add    %eax,%eax
c010285a:	01 d0                	add    %edx,%eax
c010285c:	89 c1                	mov    %eax,%ecx
c010285e:	c1 e1 08             	shl    $0x8,%ecx
c0102861:	01 c8                	add    %ecx,%eax
c0102863:	89 c1                	mov    %eax,%ecx
c0102865:	c1 e1 10             	shl    $0x10,%ecx
c0102868:	01 c8                	add    %ecx,%eax
c010286a:	c1 e0 02             	shl    $0x2,%eax
c010286d:	01 d0                	add    %edx,%eax
}
c010286f:	5d                   	pop    %ebp
c0102870:	c3                   	ret    

c0102871 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102871:	55                   	push   %ebp
c0102872:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0102874:	ff 75 08             	pushl  0x8(%ebp)
c0102877:	e8 b8 ff ff ff       	call   c0102834 <page2ppn>
c010287c:	83 c4 04             	add    $0x4,%esp
c010287f:	c1 e0 0c             	shl    $0xc,%eax
}
c0102882:	c9                   	leave  
c0102883:	c3                   	ret    

c0102884 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0102884:	55                   	push   %ebp
c0102885:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102887:	8b 45 08             	mov    0x8(%ebp),%eax
c010288a:	8b 00                	mov    (%eax),%eax
}
c010288c:	5d                   	pop    %ebp
c010288d:	c3                   	ret    

c010288e <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c010288e:	55                   	push   %ebp
c010288f:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102891:	8b 45 08             	mov    0x8(%ebp),%eax
c0102894:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102897:	89 10                	mov    %edx,(%eax)
}
c0102899:	90                   	nop
c010289a:	5d                   	pop    %ebp
c010289b:	c3                   	ret    

c010289c <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c010289c:	55                   	push   %ebp
c010289d:	89 e5                	mov    %esp,%ebp
c010289f:	83 ec 10             	sub    $0x10,%esp
c01028a2:	c7 45 fc 10 bf 11 c0 	movl   $0xc011bf10,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01028a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01028ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01028af:	89 50 04             	mov    %edx,0x4(%eax)
c01028b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01028b5:	8b 50 04             	mov    0x4(%eax),%edx
c01028b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01028bb:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c01028bd:	c7 05 18 bf 11 c0 00 	movl   $0x0,0xc011bf18
c01028c4:	00 00 00 
}
c01028c7:	90                   	nop
c01028c8:	c9                   	leave  
c01028c9:	c3                   	ret    

c01028ca <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c01028ca:	55                   	push   %ebp
c01028cb:	89 e5                	mov    %esp,%ebp
c01028cd:	83 ec 38             	sub    $0x38,%esp
    assert(n > 0);
c01028d0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01028d4:	75 16                	jne    c01028ec <default_init_memmap+0x22>
c01028d6:	68 b0 60 10 c0       	push   $0xc01060b0
c01028db:	68 b6 60 10 c0       	push   $0xc01060b6
c01028e0:	6a 6d                	push   $0x6d
c01028e2:	68 cb 60 10 c0       	push   $0xc01060cb
c01028e7:	e8 e2 e2 ff ff       	call   c0100bce <__panic>
    struct Page *p = base;
c01028ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01028ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01028f2:	eb 6c                	jmp    c0102960 <default_init_memmap+0x96>
        // 保证本页是保留页
        assert(PageReserved(p));
c01028f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028f7:	83 c0 04             	add    $0x4,%eax
c01028fa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102901:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102904:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102907:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010290a:	0f a3 10             	bt     %edx,(%eax)
c010290d:	19 c0                	sbb    %eax,%eax
c010290f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0102912:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0102916:	0f 95 c0             	setne  %al
c0102919:	0f b6 c0             	movzbl %al,%eax
c010291c:	85 c0                	test   %eax,%eax
c010291e:	75 16                	jne    c0102936 <default_init_memmap+0x6c>
c0102920:	68 e1 60 10 c0       	push   $0xc01060e1
c0102925:	68 b6 60 10 c0       	push   $0xc01060b6
c010292a:	6a 71                	push   $0x71
c010292c:	68 cb 60 10 c0       	push   $0xc01060cb
c0102931:	e8 98 e2 ff ff       	call   c0100bce <__panic>
        p->flags = p->property = 0;
c0102936:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102939:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0102940:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102943:	8b 50 08             	mov    0x8(%eax),%edx
c0102946:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102949:	89 50 04             	mov    %edx,0x4(%eax)
        // 清空引用
        set_page_ref(p, 0);
c010294c:	83 ec 08             	sub    $0x8,%esp
c010294f:	6a 00                	push   $0x0
c0102951:	ff 75 f4             	pushl  -0xc(%ebp)
c0102954:	e8 35 ff ff ff       	call   c010288e <set_page_ref>
c0102959:	83 c4 10             	add    $0x10,%esp
    for (; p != base + n; p ++) {
c010295c:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102960:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102963:	89 d0                	mov    %edx,%eax
c0102965:	c1 e0 02             	shl    $0x2,%eax
c0102968:	01 d0                	add    %edx,%eax
c010296a:	c1 e0 02             	shl    $0x2,%eax
c010296d:	89 c2                	mov    %eax,%edx
c010296f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102972:	01 d0                	add    %edx,%eax
c0102974:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102977:	0f 85 77 ff ff ff    	jne    c01028f4 <default_init_memmap+0x2a>
    }
    // 连续内存空闲块的大小为n，属于物理页管理链表
    base->property = n;
c010297d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102980:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102983:	89 50 08             	mov    %edx,0x8(%eax)
    // 除了首位的base，其他块均不是 the head page of a free memory block
    // 参考 mm/memlatput.h 中 PG_property 的定义
    SetPageProperty(base);
c0102986:	8b 45 08             	mov    0x8(%ebp),%eax
c0102989:	83 c0 04             	add    $0x4,%eax
c010298c:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0102993:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102996:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102999:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010299c:	0f ab 10             	bts    %edx,(%eax)
    // 有n个free块
    nr_free += n;
c010299f:	8b 15 18 bf 11 c0    	mov    0xc011bf18,%edx
c01029a5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01029a8:	01 d0                	add    %edx,%eax
c01029aa:	a3 18 bf 11 c0       	mov    %eax,0xc011bf18
    // 插入空闲页的链表里面
    list_add_before(&free_list, &(base->page_link)); 
c01029af:	8b 45 08             	mov    0x8(%ebp),%eax
c01029b2:	83 c0 0c             	add    $0xc,%eax
c01029b5:	c7 45 e4 10 bf 11 c0 	movl   $0xc011bf10,-0x1c(%ebp)
c01029bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01029bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01029c2:	8b 00                	mov    (%eax),%eax
c01029c4:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01029c7:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01029ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01029cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01029d0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01029d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01029d6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01029d9:	89 10                	mov    %edx,(%eax)
c01029db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01029de:	8b 10                	mov    (%eax),%edx
c01029e0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01029e3:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01029e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01029e9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01029ec:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01029ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01029f2:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01029f5:	89 10                	mov    %edx,(%eax)
}
c01029f7:	90                   	nop
c01029f8:	c9                   	leave  
c01029f9:	c3                   	ret    

c01029fa <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c01029fa:	55                   	push   %ebp
c01029fb:	89 e5                	mov    %esp,%ebp
c01029fd:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0102a00:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102a04:	75 19                	jne    c0102a1f <default_alloc_pages+0x25>
c0102a06:	68 b0 60 10 c0       	push   $0xc01060b0
c0102a0b:	68 b6 60 10 c0       	push   $0xc01060b6
c0102a10:	68 83 00 00 00       	push   $0x83
c0102a15:	68 cb 60 10 c0       	push   $0xc01060cb
c0102a1a:	e8 af e1 ff ff       	call   c0100bce <__panic>
    // 如果所有的空闲页的加起来的大小都不够，则返回 NULL
    if (n > nr_free) {
c0102a1f:	a1 18 bf 11 c0       	mov    0xc011bf18,%eax
c0102a24:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102a27:	76 0a                	jbe    c0102a33 <default_alloc_pages+0x39>
        return NULL;
c0102a29:	b8 00 00 00 00       	mov    $0x0,%eax
c0102a2e:	e9 82 01 00 00       	jmp    c0102bb5 <default_alloc_pages+0x1bb>
    }
    struct Page *page = NULL;
c0102a33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0102a3a:	c7 45 f0 10 bf 11 c0 	movl   $0xc011bf10,-0x10(%ebp)
    // 找到 first fit
    while ((le = list_next(le)) != &free_list) {
c0102a41:	eb 1c                	jmp    c0102a5f <default_alloc_pages+0x65>
        struct Page *p = le2page(le, page_link);
c0102a43:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102a46:	83 e8 0c             	sub    $0xc,%eax
c0102a49:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c0102a4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102a4f:	8b 40 08             	mov    0x8(%eax),%eax
c0102a52:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102a55:	77 08                	ja     c0102a5f <default_alloc_pages+0x65>
            page = p;
c0102a57:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102a5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0102a5d:	eb 18                	jmp    c0102a77 <default_alloc_pages+0x7d>
c0102a5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102a62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c0102a65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102a68:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0102a6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102a6e:	81 7d f0 10 bf 11 c0 	cmpl   $0xc011bf10,-0x10(%ebp)
c0102a75:	75 cc                	jne    c0102a43 <default_alloc_pages+0x49>
        }
    }
    if (page != NULL) {
c0102a77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102a7b:	0f 84 31 01 00 00    	je     c0102bb2 <default_alloc_pages+0x1b8>
        // 保证当前页面可以被分配
        assert(PageProperty(page));
c0102a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a84:	83 c0 04             	add    $0x4,%eax
c0102a87:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102a8e:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102a91:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102a94:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102a97:	0f a3 10             	bt     %edx,(%eax)
c0102a9a:	19 c0                	sbb    %eax,%eax
c0102a9c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0102a9f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0102aa3:	0f 95 c0             	setne  %al
c0102aa6:	0f b6 c0             	movzbl %al,%eax
c0102aa9:	85 c0                	test   %eax,%eax
c0102aab:	75 19                	jne    c0102ac6 <default_alloc_pages+0xcc>
c0102aad:	68 f1 60 10 c0       	push   $0xc01060f1
c0102ab2:	68 b6 60 10 c0       	push   $0xc01060b6
c0102ab7:	68 94 00 00 00       	push   $0x94
c0102abc:	68 cb 60 10 c0       	push   $0xc01060cb
c0102ac1:	e8 08 e1 ff ff       	call   c0100bce <__panic>
        // 如果找到的 page 过大，则需要分割
        if (page->property > n) {
c0102ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ac9:	8b 40 08             	mov    0x8(%eax),%eax
c0102acc:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102acf:	0f 83 8c 00 00 00    	jae    c0102b61 <default_alloc_pages+0x167>
            struct Page *p = page + n;
c0102ad5:	8b 55 08             	mov    0x8(%ebp),%edx
c0102ad8:	89 d0                	mov    %edx,%eax
c0102ada:	c1 e0 02             	shl    $0x2,%eax
c0102add:	01 d0                	add    %edx,%eax
c0102adf:	c1 e0 02             	shl    $0x2,%eax
c0102ae2:	89 c2                	mov    %eax,%edx
c0102ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ae7:	01 d0                	add    %edx,%eax
c0102ae9:	89 45 e8             	mov    %eax,-0x18(%ebp)
            // 分为大小为 n 的部分和剩余部分
            p->property = page->property - n;
c0102aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102aef:	8b 40 08             	mov    0x8(%eax),%eax
c0102af2:	2b 45 08             	sub    0x8(%ebp),%eax
c0102af5:	89 c2                	mov    %eax,%edx
c0102af7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102afa:	89 50 08             	mov    %edx,0x8(%eax)
            // 设置 p 开头的页可以被分配
            SetPageProperty(p);
c0102afd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102b00:	83 c0 04             	add    $0x4,%eax
c0102b03:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0102b0a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102b0d:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102b10:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102b13:	0f ab 10             	bts    %edx,(%eax)
            // 将 p 插入 list
            list_add_after(&(page->page_link), &(p->page_link));
c0102b16:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102b19:	83 c0 0c             	add    $0xc,%eax
c0102b1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102b1f:	83 c2 0c             	add    $0xc,%edx
c0102b22:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102b25:	89 45 d0             	mov    %eax,-0x30(%ebp)
    __list_add(elm, listelm, listelm->next);
c0102b28:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102b2b:	8b 40 04             	mov    0x4(%eax),%eax
c0102b2e:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102b31:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0102b34:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102b37:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0102b3a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    prev->next = next->prev = elm;
c0102b3d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102b40:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102b43:	89 10                	mov    %edx,(%eax)
c0102b45:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102b48:	8b 10                	mov    (%eax),%edx
c0102b4a:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102b4d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102b50:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102b53:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102b56:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102b59:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102b5c:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102b5f:	89 10                	mov    %edx,(%eax)
        }
        list_del(&(page->page_link));
c0102b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b64:	83 c0 0c             	add    $0xc,%eax
c0102b67:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102b6a:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102b6d:	8b 40 04             	mov    0x4(%eax),%eax
c0102b70:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102b73:	8b 12                	mov    (%edx),%edx
c0102b75:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0102b78:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102b7b:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102b7e:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102b81:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102b84:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102b87:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0102b8a:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
c0102b8c:	a1 18 bf 11 c0       	mov    0xc011bf18,%eax
c0102b91:	2b 45 08             	sub    0x8(%ebp),%eax
c0102b94:	a3 18 bf 11 c0       	mov    %eax,0xc011bf18
        // 设置为不可被分配
        ClearPageProperty(page);
c0102b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b9c:	83 c0 04             	add    $0x4,%eax
c0102b9f:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0102ba6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102ba9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102bac:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102baf:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c0102bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102bb5:	c9                   	leave  
c0102bb6:	c3                   	ret    

c0102bb7 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102bb7:	55                   	push   %ebp
c0102bb8:	89 e5                	mov    %esp,%ebp
c0102bba:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
c0102bc0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102bc4:	75 19                	jne    c0102bdf <default_free_pages+0x28>
c0102bc6:	68 b0 60 10 c0       	push   $0xc01060b0
c0102bcb:	68 b6 60 10 c0       	push   $0xc01060b6
c0102bd0:	68 a9 00 00 00       	push   $0xa9
c0102bd5:	68 cb 60 10 c0       	push   $0xc01060cb
c0102bda:	e8 ef df ff ff       	call   c0100bce <__panic>
    struct Page *p = base;
c0102bdf:	8b 45 08             	mov    0x8(%ebp),%eax
c0102be2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    // 把将要回收的 n 个块进行 init
    for (; p != base + n; ++p) {
c0102be5:	e9 8f 00 00 00       	jmp    c0102c79 <default_free_pages+0xc2>
        assert(!PageReserved(p) && !PageProperty(p));
c0102bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bed:	83 c0 04             	add    $0x4,%eax
c0102bf0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102bf7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102bfa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102bfd:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102c00:	0f a3 10             	bt     %edx,(%eax)
c0102c03:	19 c0                	sbb    %eax,%eax
c0102c05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0102c08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102c0c:	0f 95 c0             	setne  %al
c0102c0f:	0f b6 c0             	movzbl %al,%eax
c0102c12:	85 c0                	test   %eax,%eax
c0102c14:	75 2c                	jne    c0102c42 <default_free_pages+0x8b>
c0102c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c19:	83 c0 04             	add    $0x4,%eax
c0102c1c:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102c23:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102c26:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102c29:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102c2c:	0f a3 10             	bt     %edx,(%eax)
c0102c2f:	19 c0                	sbb    %eax,%eax
c0102c31:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0102c34:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0102c38:	0f 95 c0             	setne  %al
c0102c3b:	0f b6 c0             	movzbl %al,%eax
c0102c3e:	85 c0                	test   %eax,%eax
c0102c40:	74 19                	je     c0102c5b <default_free_pages+0xa4>
c0102c42:	68 04 61 10 c0       	push   $0xc0106104
c0102c47:	68 b6 60 10 c0       	push   $0xc01060b6
c0102c4c:	68 ad 00 00 00       	push   $0xad
c0102c51:	68 cb 60 10 c0       	push   $0xc01060cb
c0102c56:	e8 73 df ff ff       	call   c0100bce <__panic>
        p->flags = 0;
c0102c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c5e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0102c65:	83 ec 08             	sub    $0x8,%esp
c0102c68:	6a 00                	push   $0x0
c0102c6a:	ff 75 f4             	pushl  -0xc(%ebp)
c0102c6d:	e8 1c fc ff ff       	call   c010288e <set_page_ref>
c0102c72:	83 c4 10             	add    $0x10,%esp
    for (; p != base + n; ++p) {
c0102c75:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102c79:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102c7c:	89 d0                	mov    %edx,%eax
c0102c7e:	c1 e0 02             	shl    $0x2,%eax
c0102c81:	01 d0                	add    %edx,%eax
c0102c83:	c1 e0 02             	shl    $0x2,%eax
c0102c86:	89 c2                	mov    %eax,%edx
c0102c88:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c8b:	01 d0                	add    %edx,%eax
c0102c8d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102c90:	0f 85 54 ff ff ff    	jne    c0102bea <default_free_pages+0x33>
    }
    base->property = n;
c0102c96:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c99:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102c9c:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102c9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ca2:	83 c0 04             	add    $0x4,%eax
c0102ca5:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0102cac:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102caf:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102cb2:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102cb5:	0f ab 10             	bts    %edx,(%eax)
c0102cb8:	c7 45 d4 10 bf 11 c0 	movl   $0xc011bf10,-0x2c(%ebp)
    return listelm->next;
c0102cbf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102cc2:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0102cc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    nr_free += n;
c0102cc8:	8b 15 18 bf 11 c0    	mov    0xc011bf18,%edx
c0102cce:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102cd1:	01 d0                	add    %edx,%eax
c0102cd3:	a3 18 bf 11 c0       	mov    %eax,0xc011bf18
    // 把将要回收的块插入合适的位置
    while (le != &free_list) {                      
c0102cd8:	eb 34                	jmp    c0102d0e <default_free_pages+0x157>
        p = le2page(le, page_link);                 
c0102cda:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102cdd:	83 e8 0c             	sub    $0xc,%eax
c0102ce0:	89 45 f4             	mov    %eax,-0xc(%ebp)
        // 使得插入后地址是从低到高的
        if (base + base->property <= p) {           
c0102ce3:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ce6:	8b 50 08             	mov    0x8(%eax),%edx
c0102ce9:	89 d0                	mov    %edx,%eax
c0102ceb:	c1 e0 02             	shl    $0x2,%eax
c0102cee:	01 d0                	add    %edx,%eax
c0102cf0:	c1 e0 02             	shl    $0x2,%eax
c0102cf3:	89 c2                	mov    %eax,%edx
c0102cf5:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cf8:	01 d0                	add    %edx,%eax
c0102cfa:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102cfd:	73 1a                	jae    c0102d19 <default_free_pages+0x162>
c0102cff:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d02:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102d05:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102d08:	8b 40 04             	mov    0x4(%eax),%eax
            break;                                  
        }                                           
        le = list_next(le);                         
c0102d0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {                      
c0102d0e:	81 7d f0 10 bf 11 c0 	cmpl   $0xc011bf10,-0x10(%ebp)
c0102d15:	75 c3                	jne    c0102cda <default_free_pages+0x123>
c0102d17:	eb 01                	jmp    c0102d1a <default_free_pages+0x163>
            break;                                  
c0102d19:	90                   	nop
c0102d1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d1d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->prev;
c0102d20:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102d23:	8b 00                	mov    (%eax),%eax
    }                                               
    // 考虑和前面的 page 合并
    p = le2page(list_prev(le), page_link);
c0102d25:	83 e8 0c             	sub    $0xc,%eax
c0102d28:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p + p->property == base) {
c0102d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d2e:	8b 50 08             	mov    0x8(%eax),%edx
c0102d31:	89 d0                	mov    %edx,%eax
c0102d33:	c1 e0 02             	shl    $0x2,%eax
c0102d36:	01 d0                	add    %edx,%eax
c0102d38:	c1 e0 02             	shl    $0x2,%eax
c0102d3b:	89 c2                	mov    %eax,%edx
c0102d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d40:	01 d0                	add    %edx,%eax
c0102d42:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102d45:	75 5e                	jne    c0102da5 <default_free_pages+0x1ee>
        p->property += base->property;
c0102d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d4a:	8b 50 08             	mov    0x8(%eax),%edx
c0102d4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d50:	8b 40 08             	mov    0x8(%eax),%eax
c0102d53:	01 c2                	add    %eax,%edx
c0102d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d58:	89 50 08             	mov    %edx,0x8(%eax)
        ClearPageProperty(base);
c0102d5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d5e:	83 c0 04             	add    $0x4,%eax
c0102d61:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c0102d68:	89 45 b0             	mov    %eax,-0x50(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102d6b:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102d6e:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102d71:	0f b3 10             	btr    %edx,(%eax)
        base = p;
c0102d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d77:	89 45 08             	mov    %eax,0x8(%ebp)
        list_del(&(p->page_link));
c0102d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d7d:	83 c0 0c             	add    $0xc,%eax
c0102d80:	89 45 c0             	mov    %eax,-0x40(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102d83:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102d86:	8b 40 04             	mov    0x4(%eax),%eax
c0102d89:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102d8c:	8b 12                	mov    (%edx),%edx
c0102d8e:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0102d91:	89 45 b8             	mov    %eax,-0x48(%ebp)
    prev->next = next;
c0102d94:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102d97:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102d9a:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102d9d:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102da0:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102da3:	89 10                	mov    %edx,(%eax)
    }
    // 考虑和后面的 page 合并
    p = le2page(le, page_link); 
c0102da5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102da8:	83 e8 0c             	sub    $0xc,%eax
c0102dab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (base + base->property == p) {
c0102dae:	8b 45 08             	mov    0x8(%ebp),%eax
c0102db1:	8b 50 08             	mov    0x8(%eax),%edx
c0102db4:	89 d0                	mov    %edx,%eax
c0102db6:	c1 e0 02             	shl    $0x2,%eax
c0102db9:	01 d0                	add    %edx,%eax
c0102dbb:	c1 e0 02             	shl    $0x2,%eax
c0102dbe:	89 c2                	mov    %eax,%edx
c0102dc0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dc3:	01 d0                	add    %edx,%eax
c0102dc5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102dc8:	75 67                	jne    c0102e31 <default_free_pages+0x27a>
        base->property += p->property;
c0102dca:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dcd:	8b 50 08             	mov    0x8(%eax),%edx
c0102dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dd3:	8b 40 08             	mov    0x8(%eax),%eax
c0102dd6:	01 c2                	add    %eax,%edx
c0102dd8:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ddb:	89 50 08             	mov    %edx,0x8(%eax)
        ClearPageProperty(p);
c0102dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102de1:	83 c0 04             	add    $0x4,%eax
c0102de4:	c7 45 9c 01 00 00 00 	movl   $0x1,-0x64(%ebp)
c0102deb:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102dee:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102df1:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102df4:	0f b3 10             	btr    %edx,(%eax)
c0102df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102dfa:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return listelm->next;
c0102dfd:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102e00:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0102e03:	89 45 f0             	mov    %eax,-0x10(%ebp)
        list_del(&(p->page_link));
c0102e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e09:	83 c0 0c             	add    $0xc,%eax
c0102e0c:	89 45 ac             	mov    %eax,-0x54(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102e0f:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102e12:	8b 40 04             	mov    0x4(%eax),%eax
c0102e15:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0102e18:	8b 12                	mov    (%edx),%edx
c0102e1a:	89 55 a8             	mov    %edx,-0x58(%ebp)
c0102e1d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    prev->next = next;
c0102e20:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102e23:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102e26:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102e29:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102e2c:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102e2f:	89 10                	mov    %edx,(%eax)
    }
    list_add_before(le, &(base->page_link));
c0102e31:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e34:	8d 50 0c             	lea    0xc(%eax),%edx
c0102e37:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e3a:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0102e3d:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
c0102e40:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102e43:	8b 00                	mov    (%eax),%eax
c0102e45:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102e48:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0102e4b:	89 45 88             	mov    %eax,-0x78(%ebp)
c0102e4e:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102e51:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
c0102e54:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0102e57:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0102e5a:	89 10                	mov    %edx,(%eax)
c0102e5c:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0102e5f:	8b 10                	mov    (%eax),%edx
c0102e61:	8b 45 88             	mov    -0x78(%ebp),%eax
c0102e64:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102e67:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102e6a:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0102e6d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102e70:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102e73:	8b 55 88             	mov    -0x78(%ebp),%edx
c0102e76:	89 10                	mov    %edx,(%eax)
}
c0102e78:	90                   	nop
c0102e79:	c9                   	leave  
c0102e7a:	c3                   	ret    

c0102e7b <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102e7b:	55                   	push   %ebp
c0102e7c:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102e7e:	a1 18 bf 11 c0       	mov    0xc011bf18,%eax
}
c0102e83:	5d                   	pop    %ebp
c0102e84:	c3                   	ret    

c0102e85 <basic_check>:

static void
basic_check(void) {
c0102e85:	55                   	push   %ebp
c0102e86:	89 e5                	mov    %esp,%ebp
c0102e88:	83 ec 38             	sub    $0x38,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102e8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e95:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e9b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102e9e:	83 ec 0c             	sub    $0xc,%esp
c0102ea1:	6a 01                	push   $0x1
c0102ea3:	e8 e4 0c 00 00       	call   c0103b8c <alloc_pages>
c0102ea8:	83 c4 10             	add    $0x10,%esp
c0102eab:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102eae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102eb2:	75 19                	jne    c0102ecd <basic_check+0x48>
c0102eb4:	68 29 61 10 c0       	push   $0xc0106129
c0102eb9:	68 b6 60 10 c0       	push   $0xc01060b6
c0102ebe:	68 da 00 00 00       	push   $0xda
c0102ec3:	68 cb 60 10 c0       	push   $0xc01060cb
c0102ec8:	e8 01 dd ff ff       	call   c0100bce <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102ecd:	83 ec 0c             	sub    $0xc,%esp
c0102ed0:	6a 01                	push   $0x1
c0102ed2:	e8 b5 0c 00 00       	call   c0103b8c <alloc_pages>
c0102ed7:	83 c4 10             	add    $0x10,%esp
c0102eda:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102edd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102ee1:	75 19                	jne    c0102efc <basic_check+0x77>
c0102ee3:	68 45 61 10 c0       	push   $0xc0106145
c0102ee8:	68 b6 60 10 c0       	push   $0xc01060b6
c0102eed:	68 db 00 00 00       	push   $0xdb
c0102ef2:	68 cb 60 10 c0       	push   $0xc01060cb
c0102ef7:	e8 d2 dc ff ff       	call   c0100bce <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102efc:	83 ec 0c             	sub    $0xc,%esp
c0102eff:	6a 01                	push   $0x1
c0102f01:	e8 86 0c 00 00       	call   c0103b8c <alloc_pages>
c0102f06:	83 c4 10             	add    $0x10,%esp
c0102f09:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102f0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102f10:	75 19                	jne    c0102f2b <basic_check+0xa6>
c0102f12:	68 61 61 10 c0       	push   $0xc0106161
c0102f17:	68 b6 60 10 c0       	push   $0xc01060b6
c0102f1c:	68 dc 00 00 00       	push   $0xdc
c0102f21:	68 cb 60 10 c0       	push   $0xc01060cb
c0102f26:	e8 a3 dc ff ff       	call   c0100bce <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0102f2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f2e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102f31:	74 10                	je     c0102f43 <basic_check+0xbe>
c0102f33:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f36:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102f39:	74 08                	je     c0102f43 <basic_check+0xbe>
c0102f3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f3e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102f41:	75 19                	jne    c0102f5c <basic_check+0xd7>
c0102f43:	68 80 61 10 c0       	push   $0xc0106180
c0102f48:	68 b6 60 10 c0       	push   $0xc01060b6
c0102f4d:	68 de 00 00 00       	push   $0xde
c0102f52:	68 cb 60 10 c0       	push   $0xc01060cb
c0102f57:	e8 72 dc ff ff       	call   c0100bce <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0102f5c:	83 ec 0c             	sub    $0xc,%esp
c0102f5f:	ff 75 ec             	pushl  -0x14(%ebp)
c0102f62:	e8 1d f9 ff ff       	call   c0102884 <page_ref>
c0102f67:	83 c4 10             	add    $0x10,%esp
c0102f6a:	85 c0                	test   %eax,%eax
c0102f6c:	75 24                	jne    c0102f92 <basic_check+0x10d>
c0102f6e:	83 ec 0c             	sub    $0xc,%esp
c0102f71:	ff 75 f0             	pushl  -0x10(%ebp)
c0102f74:	e8 0b f9 ff ff       	call   c0102884 <page_ref>
c0102f79:	83 c4 10             	add    $0x10,%esp
c0102f7c:	85 c0                	test   %eax,%eax
c0102f7e:	75 12                	jne    c0102f92 <basic_check+0x10d>
c0102f80:	83 ec 0c             	sub    $0xc,%esp
c0102f83:	ff 75 f4             	pushl  -0xc(%ebp)
c0102f86:	e8 f9 f8 ff ff       	call   c0102884 <page_ref>
c0102f8b:	83 c4 10             	add    $0x10,%esp
c0102f8e:	85 c0                	test   %eax,%eax
c0102f90:	74 19                	je     c0102fab <basic_check+0x126>
c0102f92:	68 a4 61 10 c0       	push   $0xc01061a4
c0102f97:	68 b6 60 10 c0       	push   $0xc01060b6
c0102f9c:	68 df 00 00 00       	push   $0xdf
c0102fa1:	68 cb 60 10 c0       	push   $0xc01060cb
c0102fa6:	e8 23 dc ff ff       	call   c0100bce <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0102fab:	83 ec 0c             	sub    $0xc,%esp
c0102fae:	ff 75 ec             	pushl  -0x14(%ebp)
c0102fb1:	e8 bb f8 ff ff       	call   c0102871 <page2pa>
c0102fb6:	83 c4 10             	add    $0x10,%esp
c0102fb9:	8b 15 80 be 11 c0    	mov    0xc011be80,%edx
c0102fbf:	c1 e2 0c             	shl    $0xc,%edx
c0102fc2:	39 d0                	cmp    %edx,%eax
c0102fc4:	72 19                	jb     c0102fdf <basic_check+0x15a>
c0102fc6:	68 e0 61 10 c0       	push   $0xc01061e0
c0102fcb:	68 b6 60 10 c0       	push   $0xc01060b6
c0102fd0:	68 e1 00 00 00       	push   $0xe1
c0102fd5:	68 cb 60 10 c0       	push   $0xc01060cb
c0102fda:	e8 ef db ff ff       	call   c0100bce <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0102fdf:	83 ec 0c             	sub    $0xc,%esp
c0102fe2:	ff 75 f0             	pushl  -0x10(%ebp)
c0102fe5:	e8 87 f8 ff ff       	call   c0102871 <page2pa>
c0102fea:	83 c4 10             	add    $0x10,%esp
c0102fed:	8b 15 80 be 11 c0    	mov    0xc011be80,%edx
c0102ff3:	c1 e2 0c             	shl    $0xc,%edx
c0102ff6:	39 d0                	cmp    %edx,%eax
c0102ff8:	72 19                	jb     c0103013 <basic_check+0x18e>
c0102ffa:	68 fd 61 10 c0       	push   $0xc01061fd
c0102fff:	68 b6 60 10 c0       	push   $0xc01060b6
c0103004:	68 e2 00 00 00       	push   $0xe2
c0103009:	68 cb 60 10 c0       	push   $0xc01060cb
c010300e:	e8 bb db ff ff       	call   c0100bce <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103013:	83 ec 0c             	sub    $0xc,%esp
c0103016:	ff 75 f4             	pushl  -0xc(%ebp)
c0103019:	e8 53 f8 ff ff       	call   c0102871 <page2pa>
c010301e:	83 c4 10             	add    $0x10,%esp
c0103021:	8b 15 80 be 11 c0    	mov    0xc011be80,%edx
c0103027:	c1 e2 0c             	shl    $0xc,%edx
c010302a:	39 d0                	cmp    %edx,%eax
c010302c:	72 19                	jb     c0103047 <basic_check+0x1c2>
c010302e:	68 1a 62 10 c0       	push   $0xc010621a
c0103033:	68 b6 60 10 c0       	push   $0xc01060b6
c0103038:	68 e3 00 00 00       	push   $0xe3
c010303d:	68 cb 60 10 c0       	push   $0xc01060cb
c0103042:	e8 87 db ff ff       	call   c0100bce <__panic>

    list_entry_t free_list_store = free_list;
c0103047:	a1 10 bf 11 c0       	mov    0xc011bf10,%eax
c010304c:	8b 15 14 bf 11 c0    	mov    0xc011bf14,%edx
c0103052:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103055:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103058:	c7 45 dc 10 bf 11 c0 	movl   $0xc011bf10,-0x24(%ebp)
    elm->prev = elm->next = elm;
c010305f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103062:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103065:	89 50 04             	mov    %edx,0x4(%eax)
c0103068:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010306b:	8b 50 04             	mov    0x4(%eax),%edx
c010306e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103071:	89 10                	mov    %edx,(%eax)
c0103073:	c7 45 e0 10 bf 11 c0 	movl   $0xc011bf10,-0x20(%ebp)
    return list->next == list;
c010307a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010307d:	8b 40 04             	mov    0x4(%eax),%eax
c0103080:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0103083:	0f 94 c0             	sete   %al
c0103086:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103089:	85 c0                	test   %eax,%eax
c010308b:	75 19                	jne    c01030a6 <basic_check+0x221>
c010308d:	68 37 62 10 c0       	push   $0xc0106237
c0103092:	68 b6 60 10 c0       	push   $0xc01060b6
c0103097:	68 e7 00 00 00       	push   $0xe7
c010309c:	68 cb 60 10 c0       	push   $0xc01060cb
c01030a1:	e8 28 db ff ff       	call   c0100bce <__panic>

    unsigned int nr_free_store = nr_free;
c01030a6:	a1 18 bf 11 c0       	mov    0xc011bf18,%eax
c01030ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c01030ae:	c7 05 18 bf 11 c0 00 	movl   $0x0,0xc011bf18
c01030b5:	00 00 00 

    assert(alloc_page() == NULL);
c01030b8:	83 ec 0c             	sub    $0xc,%esp
c01030bb:	6a 01                	push   $0x1
c01030bd:	e8 ca 0a 00 00       	call   c0103b8c <alloc_pages>
c01030c2:	83 c4 10             	add    $0x10,%esp
c01030c5:	85 c0                	test   %eax,%eax
c01030c7:	74 19                	je     c01030e2 <basic_check+0x25d>
c01030c9:	68 4e 62 10 c0       	push   $0xc010624e
c01030ce:	68 b6 60 10 c0       	push   $0xc01060b6
c01030d3:	68 ec 00 00 00       	push   $0xec
c01030d8:	68 cb 60 10 c0       	push   $0xc01060cb
c01030dd:	e8 ec da ff ff       	call   c0100bce <__panic>

    free_page(p0);
c01030e2:	83 ec 08             	sub    $0x8,%esp
c01030e5:	6a 01                	push   $0x1
c01030e7:	ff 75 ec             	pushl  -0x14(%ebp)
c01030ea:	e8 db 0a 00 00       	call   c0103bca <free_pages>
c01030ef:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c01030f2:	83 ec 08             	sub    $0x8,%esp
c01030f5:	6a 01                	push   $0x1
c01030f7:	ff 75 f0             	pushl  -0x10(%ebp)
c01030fa:	e8 cb 0a 00 00       	call   c0103bca <free_pages>
c01030ff:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0103102:	83 ec 08             	sub    $0x8,%esp
c0103105:	6a 01                	push   $0x1
c0103107:	ff 75 f4             	pushl  -0xc(%ebp)
c010310a:	e8 bb 0a 00 00       	call   c0103bca <free_pages>
c010310f:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
c0103112:	a1 18 bf 11 c0       	mov    0xc011bf18,%eax
c0103117:	83 f8 03             	cmp    $0x3,%eax
c010311a:	74 19                	je     c0103135 <basic_check+0x2b0>
c010311c:	68 63 62 10 c0       	push   $0xc0106263
c0103121:	68 b6 60 10 c0       	push   $0xc01060b6
c0103126:	68 f1 00 00 00       	push   $0xf1
c010312b:	68 cb 60 10 c0       	push   $0xc01060cb
c0103130:	e8 99 da ff ff       	call   c0100bce <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103135:	83 ec 0c             	sub    $0xc,%esp
c0103138:	6a 01                	push   $0x1
c010313a:	e8 4d 0a 00 00       	call   c0103b8c <alloc_pages>
c010313f:	83 c4 10             	add    $0x10,%esp
c0103142:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103145:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103149:	75 19                	jne    c0103164 <basic_check+0x2df>
c010314b:	68 29 61 10 c0       	push   $0xc0106129
c0103150:	68 b6 60 10 c0       	push   $0xc01060b6
c0103155:	68 f3 00 00 00       	push   $0xf3
c010315a:	68 cb 60 10 c0       	push   $0xc01060cb
c010315f:	e8 6a da ff ff       	call   c0100bce <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103164:	83 ec 0c             	sub    $0xc,%esp
c0103167:	6a 01                	push   $0x1
c0103169:	e8 1e 0a 00 00       	call   c0103b8c <alloc_pages>
c010316e:	83 c4 10             	add    $0x10,%esp
c0103171:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103174:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103178:	75 19                	jne    c0103193 <basic_check+0x30e>
c010317a:	68 45 61 10 c0       	push   $0xc0106145
c010317f:	68 b6 60 10 c0       	push   $0xc01060b6
c0103184:	68 f4 00 00 00       	push   $0xf4
c0103189:	68 cb 60 10 c0       	push   $0xc01060cb
c010318e:	e8 3b da ff ff       	call   c0100bce <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103193:	83 ec 0c             	sub    $0xc,%esp
c0103196:	6a 01                	push   $0x1
c0103198:	e8 ef 09 00 00       	call   c0103b8c <alloc_pages>
c010319d:	83 c4 10             	add    $0x10,%esp
c01031a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01031a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01031a7:	75 19                	jne    c01031c2 <basic_check+0x33d>
c01031a9:	68 61 61 10 c0       	push   $0xc0106161
c01031ae:	68 b6 60 10 c0       	push   $0xc01060b6
c01031b3:	68 f5 00 00 00       	push   $0xf5
c01031b8:	68 cb 60 10 c0       	push   $0xc01060cb
c01031bd:	e8 0c da ff ff       	call   c0100bce <__panic>

    assert(alloc_page() == NULL);
c01031c2:	83 ec 0c             	sub    $0xc,%esp
c01031c5:	6a 01                	push   $0x1
c01031c7:	e8 c0 09 00 00       	call   c0103b8c <alloc_pages>
c01031cc:	83 c4 10             	add    $0x10,%esp
c01031cf:	85 c0                	test   %eax,%eax
c01031d1:	74 19                	je     c01031ec <basic_check+0x367>
c01031d3:	68 4e 62 10 c0       	push   $0xc010624e
c01031d8:	68 b6 60 10 c0       	push   $0xc01060b6
c01031dd:	68 f7 00 00 00       	push   $0xf7
c01031e2:	68 cb 60 10 c0       	push   $0xc01060cb
c01031e7:	e8 e2 d9 ff ff       	call   c0100bce <__panic>

    free_page(p0);
c01031ec:	83 ec 08             	sub    $0x8,%esp
c01031ef:	6a 01                	push   $0x1
c01031f1:	ff 75 ec             	pushl  -0x14(%ebp)
c01031f4:	e8 d1 09 00 00       	call   c0103bca <free_pages>
c01031f9:	83 c4 10             	add    $0x10,%esp
c01031fc:	c7 45 d8 10 bf 11 c0 	movl   $0xc011bf10,-0x28(%ebp)
c0103203:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103206:	8b 40 04             	mov    0x4(%eax),%eax
c0103209:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c010320c:	0f 94 c0             	sete   %al
c010320f:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103212:	85 c0                	test   %eax,%eax
c0103214:	74 19                	je     c010322f <basic_check+0x3aa>
c0103216:	68 70 62 10 c0       	push   $0xc0106270
c010321b:	68 b6 60 10 c0       	push   $0xc01060b6
c0103220:	68 fa 00 00 00       	push   $0xfa
c0103225:	68 cb 60 10 c0       	push   $0xc01060cb
c010322a:	e8 9f d9 ff ff       	call   c0100bce <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c010322f:	83 ec 0c             	sub    $0xc,%esp
c0103232:	6a 01                	push   $0x1
c0103234:	e8 53 09 00 00       	call   c0103b8c <alloc_pages>
c0103239:	83 c4 10             	add    $0x10,%esp
c010323c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010323f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103242:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103245:	74 19                	je     c0103260 <basic_check+0x3db>
c0103247:	68 88 62 10 c0       	push   $0xc0106288
c010324c:	68 b6 60 10 c0       	push   $0xc01060b6
c0103251:	68 fd 00 00 00       	push   $0xfd
c0103256:	68 cb 60 10 c0       	push   $0xc01060cb
c010325b:	e8 6e d9 ff ff       	call   c0100bce <__panic>
    assert(alloc_page() == NULL);
c0103260:	83 ec 0c             	sub    $0xc,%esp
c0103263:	6a 01                	push   $0x1
c0103265:	e8 22 09 00 00       	call   c0103b8c <alloc_pages>
c010326a:	83 c4 10             	add    $0x10,%esp
c010326d:	85 c0                	test   %eax,%eax
c010326f:	74 19                	je     c010328a <basic_check+0x405>
c0103271:	68 4e 62 10 c0       	push   $0xc010624e
c0103276:	68 b6 60 10 c0       	push   $0xc01060b6
c010327b:	68 fe 00 00 00       	push   $0xfe
c0103280:	68 cb 60 10 c0       	push   $0xc01060cb
c0103285:	e8 44 d9 ff ff       	call   c0100bce <__panic>

    assert(nr_free == 0);
c010328a:	a1 18 bf 11 c0       	mov    0xc011bf18,%eax
c010328f:	85 c0                	test   %eax,%eax
c0103291:	74 19                	je     c01032ac <basic_check+0x427>
c0103293:	68 a1 62 10 c0       	push   $0xc01062a1
c0103298:	68 b6 60 10 c0       	push   $0xc01060b6
c010329d:	68 00 01 00 00       	push   $0x100
c01032a2:	68 cb 60 10 c0       	push   $0xc01060cb
c01032a7:	e8 22 d9 ff ff       	call   c0100bce <__panic>
    free_list = free_list_store;
c01032ac:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01032af:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01032b2:	a3 10 bf 11 c0       	mov    %eax,0xc011bf10
c01032b7:	89 15 14 bf 11 c0    	mov    %edx,0xc011bf14
    nr_free = nr_free_store;
c01032bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01032c0:	a3 18 bf 11 c0       	mov    %eax,0xc011bf18

    free_page(p);
c01032c5:	83 ec 08             	sub    $0x8,%esp
c01032c8:	6a 01                	push   $0x1
c01032ca:	ff 75 e4             	pushl  -0x1c(%ebp)
c01032cd:	e8 f8 08 00 00       	call   c0103bca <free_pages>
c01032d2:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c01032d5:	83 ec 08             	sub    $0x8,%esp
c01032d8:	6a 01                	push   $0x1
c01032da:	ff 75 f0             	pushl  -0x10(%ebp)
c01032dd:	e8 e8 08 00 00       	call   c0103bca <free_pages>
c01032e2:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c01032e5:	83 ec 08             	sub    $0x8,%esp
c01032e8:	6a 01                	push   $0x1
c01032ea:	ff 75 f4             	pushl  -0xc(%ebp)
c01032ed:	e8 d8 08 00 00       	call   c0103bca <free_pages>
c01032f2:	83 c4 10             	add    $0x10,%esp
}
c01032f5:	90                   	nop
c01032f6:	c9                   	leave  
c01032f7:	c3                   	ret    

c01032f8 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c01032f8:	55                   	push   %ebp
c01032f9:	89 e5                	mov    %esp,%ebp
c01032fb:	81 ec 88 00 00 00    	sub    $0x88,%esp
    int count = 0, total = 0;
c0103301:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103308:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c010330f:	c7 45 ec 10 bf 11 c0 	movl   $0xc011bf10,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103316:	eb 5f                	jmp    c0103377 <default_check+0x7f>
        struct Page *p = le2page(le, page_link);
c0103318:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010331b:	83 e8 0c             	sub    $0xc,%eax
c010331e:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103321:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103324:	83 c0 04             	add    $0x4,%eax
c0103327:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c010332e:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103331:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103334:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103337:	0f a3 10             	bt     %edx,(%eax)
c010333a:	19 c0                	sbb    %eax,%eax
c010333c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c010333f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103343:	0f 95 c0             	setne  %al
c0103346:	0f b6 c0             	movzbl %al,%eax
c0103349:	85 c0                	test   %eax,%eax
c010334b:	75 19                	jne    c0103366 <default_check+0x6e>
c010334d:	68 ae 62 10 c0       	push   $0xc01062ae
c0103352:	68 b6 60 10 c0       	push   $0xc01060b6
c0103357:	68 11 01 00 00       	push   $0x111
c010335c:	68 cb 60 10 c0       	push   $0xc01060cb
c0103361:	e8 68 d8 ff ff       	call   c0100bce <__panic>
        count ++, total += p->property;
c0103366:	ff 45 f4             	incl   -0xc(%ebp)
c0103369:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010336c:	8b 50 08             	mov    0x8(%eax),%edx
c010336f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103372:	01 d0                	add    %edx,%eax
c0103374:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103377:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010337a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c010337d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103380:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0103383:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103386:	81 7d ec 10 bf 11 c0 	cmpl   $0xc011bf10,-0x14(%ebp)
c010338d:	75 89                	jne    c0103318 <default_check+0x20>
    }
    assert(total == nr_free_pages());
c010338f:	e8 6b 08 00 00       	call   c0103bff <nr_free_pages>
c0103394:	89 c2                	mov    %eax,%edx
c0103396:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103399:	39 c2                	cmp    %eax,%edx
c010339b:	74 19                	je     c01033b6 <default_check+0xbe>
c010339d:	68 be 62 10 c0       	push   $0xc01062be
c01033a2:	68 b6 60 10 c0       	push   $0xc01060b6
c01033a7:	68 14 01 00 00       	push   $0x114
c01033ac:	68 cb 60 10 c0       	push   $0xc01060cb
c01033b1:	e8 18 d8 ff ff       	call   c0100bce <__panic>

    basic_check();
c01033b6:	e8 ca fa ff ff       	call   c0102e85 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c01033bb:	83 ec 0c             	sub    $0xc,%esp
c01033be:	6a 05                	push   $0x5
c01033c0:	e8 c7 07 00 00       	call   c0103b8c <alloc_pages>
c01033c5:	83 c4 10             	add    $0x10,%esp
c01033c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c01033cb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01033cf:	75 19                	jne    c01033ea <default_check+0xf2>
c01033d1:	68 d7 62 10 c0       	push   $0xc01062d7
c01033d6:	68 b6 60 10 c0       	push   $0xc01060b6
c01033db:	68 19 01 00 00       	push   $0x119
c01033e0:	68 cb 60 10 c0       	push   $0xc01060cb
c01033e5:	e8 e4 d7 ff ff       	call   c0100bce <__panic>
    assert(!PageProperty(p0));
c01033ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01033ed:	83 c0 04             	add    $0x4,%eax
c01033f0:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01033f7:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01033fa:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01033fd:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103400:	0f a3 10             	bt     %edx,(%eax)
c0103403:	19 c0                	sbb    %eax,%eax
c0103405:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103408:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c010340c:	0f 95 c0             	setne  %al
c010340f:	0f b6 c0             	movzbl %al,%eax
c0103412:	85 c0                	test   %eax,%eax
c0103414:	74 19                	je     c010342f <default_check+0x137>
c0103416:	68 e2 62 10 c0       	push   $0xc01062e2
c010341b:	68 b6 60 10 c0       	push   $0xc01060b6
c0103420:	68 1a 01 00 00       	push   $0x11a
c0103425:	68 cb 60 10 c0       	push   $0xc01060cb
c010342a:	e8 9f d7 ff ff       	call   c0100bce <__panic>

    list_entry_t free_list_store = free_list;
c010342f:	a1 10 bf 11 c0       	mov    0xc011bf10,%eax
c0103434:	8b 15 14 bf 11 c0    	mov    0xc011bf14,%edx
c010343a:	89 45 80             	mov    %eax,-0x80(%ebp)
c010343d:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103440:	c7 45 b0 10 bf 11 c0 	movl   $0xc011bf10,-0x50(%ebp)
    elm->prev = elm->next = elm;
c0103447:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010344a:	8b 55 b0             	mov    -0x50(%ebp),%edx
c010344d:	89 50 04             	mov    %edx,0x4(%eax)
c0103450:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103453:	8b 50 04             	mov    0x4(%eax),%edx
c0103456:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103459:	89 10                	mov    %edx,(%eax)
c010345b:	c7 45 b4 10 bf 11 c0 	movl   $0xc011bf10,-0x4c(%ebp)
    return list->next == list;
c0103462:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103465:	8b 40 04             	mov    0x4(%eax),%eax
c0103468:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c010346b:	0f 94 c0             	sete   %al
c010346e:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103471:	85 c0                	test   %eax,%eax
c0103473:	75 19                	jne    c010348e <default_check+0x196>
c0103475:	68 37 62 10 c0       	push   $0xc0106237
c010347a:	68 b6 60 10 c0       	push   $0xc01060b6
c010347f:	68 1e 01 00 00       	push   $0x11e
c0103484:	68 cb 60 10 c0       	push   $0xc01060cb
c0103489:	e8 40 d7 ff ff       	call   c0100bce <__panic>
    assert(alloc_page() == NULL);
c010348e:	83 ec 0c             	sub    $0xc,%esp
c0103491:	6a 01                	push   $0x1
c0103493:	e8 f4 06 00 00       	call   c0103b8c <alloc_pages>
c0103498:	83 c4 10             	add    $0x10,%esp
c010349b:	85 c0                	test   %eax,%eax
c010349d:	74 19                	je     c01034b8 <default_check+0x1c0>
c010349f:	68 4e 62 10 c0       	push   $0xc010624e
c01034a4:	68 b6 60 10 c0       	push   $0xc01060b6
c01034a9:	68 1f 01 00 00       	push   $0x11f
c01034ae:	68 cb 60 10 c0       	push   $0xc01060cb
c01034b3:	e8 16 d7 ff ff       	call   c0100bce <__panic>

    unsigned int nr_free_store = nr_free;
c01034b8:	a1 18 bf 11 c0       	mov    0xc011bf18,%eax
c01034bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c01034c0:	c7 05 18 bf 11 c0 00 	movl   $0x0,0xc011bf18
c01034c7:	00 00 00 

    free_pages(p0 + 2, 3);
c01034ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01034cd:	83 c0 28             	add    $0x28,%eax
c01034d0:	83 ec 08             	sub    $0x8,%esp
c01034d3:	6a 03                	push   $0x3
c01034d5:	50                   	push   %eax
c01034d6:	e8 ef 06 00 00       	call   c0103bca <free_pages>
c01034db:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
c01034de:	83 ec 0c             	sub    $0xc,%esp
c01034e1:	6a 04                	push   $0x4
c01034e3:	e8 a4 06 00 00       	call   c0103b8c <alloc_pages>
c01034e8:	83 c4 10             	add    $0x10,%esp
c01034eb:	85 c0                	test   %eax,%eax
c01034ed:	74 19                	je     c0103508 <default_check+0x210>
c01034ef:	68 f4 62 10 c0       	push   $0xc01062f4
c01034f4:	68 b6 60 10 c0       	push   $0xc01060b6
c01034f9:	68 25 01 00 00       	push   $0x125
c01034fe:	68 cb 60 10 c0       	push   $0xc01060cb
c0103503:	e8 c6 d6 ff ff       	call   c0100bce <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0103508:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010350b:	83 c0 28             	add    $0x28,%eax
c010350e:	83 c0 04             	add    $0x4,%eax
c0103511:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103518:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010351b:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010351e:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103521:	0f a3 10             	bt     %edx,(%eax)
c0103524:	19 c0                	sbb    %eax,%eax
c0103526:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103529:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c010352d:	0f 95 c0             	setne  %al
c0103530:	0f b6 c0             	movzbl %al,%eax
c0103533:	85 c0                	test   %eax,%eax
c0103535:	74 0e                	je     c0103545 <default_check+0x24d>
c0103537:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010353a:	83 c0 28             	add    $0x28,%eax
c010353d:	8b 40 08             	mov    0x8(%eax),%eax
c0103540:	83 f8 03             	cmp    $0x3,%eax
c0103543:	74 19                	je     c010355e <default_check+0x266>
c0103545:	68 0c 63 10 c0       	push   $0xc010630c
c010354a:	68 b6 60 10 c0       	push   $0xc01060b6
c010354f:	68 26 01 00 00       	push   $0x126
c0103554:	68 cb 60 10 c0       	push   $0xc01060cb
c0103559:	e8 70 d6 ff ff       	call   c0100bce <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c010355e:	83 ec 0c             	sub    $0xc,%esp
c0103561:	6a 03                	push   $0x3
c0103563:	e8 24 06 00 00       	call   c0103b8c <alloc_pages>
c0103568:	83 c4 10             	add    $0x10,%esp
c010356b:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010356e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103572:	75 19                	jne    c010358d <default_check+0x295>
c0103574:	68 38 63 10 c0       	push   $0xc0106338
c0103579:	68 b6 60 10 c0       	push   $0xc01060b6
c010357e:	68 27 01 00 00       	push   $0x127
c0103583:	68 cb 60 10 c0       	push   $0xc01060cb
c0103588:	e8 41 d6 ff ff       	call   c0100bce <__panic>
    assert(alloc_page() == NULL);
c010358d:	83 ec 0c             	sub    $0xc,%esp
c0103590:	6a 01                	push   $0x1
c0103592:	e8 f5 05 00 00       	call   c0103b8c <alloc_pages>
c0103597:	83 c4 10             	add    $0x10,%esp
c010359a:	85 c0                	test   %eax,%eax
c010359c:	74 19                	je     c01035b7 <default_check+0x2bf>
c010359e:	68 4e 62 10 c0       	push   $0xc010624e
c01035a3:	68 b6 60 10 c0       	push   $0xc01060b6
c01035a8:	68 28 01 00 00       	push   $0x128
c01035ad:	68 cb 60 10 c0       	push   $0xc01060cb
c01035b2:	e8 17 d6 ff ff       	call   c0100bce <__panic>
    assert(p0 + 2 == p1);
c01035b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035ba:	83 c0 28             	add    $0x28,%eax
c01035bd:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01035c0:	74 19                	je     c01035db <default_check+0x2e3>
c01035c2:	68 56 63 10 c0       	push   $0xc0106356
c01035c7:	68 b6 60 10 c0       	push   $0xc01060b6
c01035cc:	68 29 01 00 00       	push   $0x129
c01035d1:	68 cb 60 10 c0       	push   $0xc01060cb
c01035d6:	e8 f3 d5 ff ff       	call   c0100bce <__panic>

    p2 = p0 + 1;
c01035db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035de:	83 c0 14             	add    $0x14,%eax
c01035e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c01035e4:	83 ec 08             	sub    $0x8,%esp
c01035e7:	6a 01                	push   $0x1
c01035e9:	ff 75 e4             	pushl  -0x1c(%ebp)
c01035ec:	e8 d9 05 00 00       	call   c0103bca <free_pages>
c01035f1:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
c01035f4:	83 ec 08             	sub    $0x8,%esp
c01035f7:	6a 03                	push   $0x3
c01035f9:	ff 75 dc             	pushl  -0x24(%ebp)
c01035fc:	e8 c9 05 00 00       	call   c0103bca <free_pages>
c0103601:	83 c4 10             	add    $0x10,%esp
    assert(PageProperty(p0) && p0->property == 1);
c0103604:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103607:	83 c0 04             	add    $0x4,%eax
c010360a:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0103611:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103614:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103617:	8b 55 a0             	mov    -0x60(%ebp),%edx
c010361a:	0f a3 10             	bt     %edx,(%eax)
c010361d:	19 c0                	sbb    %eax,%eax
c010361f:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0103622:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0103626:	0f 95 c0             	setne  %al
c0103629:	0f b6 c0             	movzbl %al,%eax
c010362c:	85 c0                	test   %eax,%eax
c010362e:	74 0b                	je     c010363b <default_check+0x343>
c0103630:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103633:	8b 40 08             	mov    0x8(%eax),%eax
c0103636:	83 f8 01             	cmp    $0x1,%eax
c0103639:	74 19                	je     c0103654 <default_check+0x35c>
c010363b:	68 64 63 10 c0       	push   $0xc0106364
c0103640:	68 b6 60 10 c0       	push   $0xc01060b6
c0103645:	68 2e 01 00 00       	push   $0x12e
c010364a:	68 cb 60 10 c0       	push   $0xc01060cb
c010364f:	e8 7a d5 ff ff       	call   c0100bce <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0103654:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103657:	83 c0 04             	add    $0x4,%eax
c010365a:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0103661:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103664:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103667:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010366a:	0f a3 10             	bt     %edx,(%eax)
c010366d:	19 c0                	sbb    %eax,%eax
c010366f:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0103672:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0103676:	0f 95 c0             	setne  %al
c0103679:	0f b6 c0             	movzbl %al,%eax
c010367c:	85 c0                	test   %eax,%eax
c010367e:	74 0b                	je     c010368b <default_check+0x393>
c0103680:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103683:	8b 40 08             	mov    0x8(%eax),%eax
c0103686:	83 f8 03             	cmp    $0x3,%eax
c0103689:	74 19                	je     c01036a4 <default_check+0x3ac>
c010368b:	68 8c 63 10 c0       	push   $0xc010638c
c0103690:	68 b6 60 10 c0       	push   $0xc01060b6
c0103695:	68 2f 01 00 00       	push   $0x12f
c010369a:	68 cb 60 10 c0       	push   $0xc01060cb
c010369f:	e8 2a d5 ff ff       	call   c0100bce <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01036a4:	83 ec 0c             	sub    $0xc,%esp
c01036a7:	6a 01                	push   $0x1
c01036a9:	e8 de 04 00 00       	call   c0103b8c <alloc_pages>
c01036ae:	83 c4 10             	add    $0x10,%esp
c01036b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01036b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01036b7:	83 e8 14             	sub    $0x14,%eax
c01036ba:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01036bd:	74 19                	je     c01036d8 <default_check+0x3e0>
c01036bf:	68 b2 63 10 c0       	push   $0xc01063b2
c01036c4:	68 b6 60 10 c0       	push   $0xc01060b6
c01036c9:	68 31 01 00 00       	push   $0x131
c01036ce:	68 cb 60 10 c0       	push   $0xc01060cb
c01036d3:	e8 f6 d4 ff ff       	call   c0100bce <__panic>
    free_page(p0);
c01036d8:	83 ec 08             	sub    $0x8,%esp
c01036db:	6a 01                	push   $0x1
c01036dd:	ff 75 e4             	pushl  -0x1c(%ebp)
c01036e0:	e8 e5 04 00 00       	call   c0103bca <free_pages>
c01036e5:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01036e8:	83 ec 0c             	sub    $0xc,%esp
c01036eb:	6a 02                	push   $0x2
c01036ed:	e8 9a 04 00 00       	call   c0103b8c <alloc_pages>
c01036f2:	83 c4 10             	add    $0x10,%esp
c01036f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01036f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01036fb:	83 c0 14             	add    $0x14,%eax
c01036fe:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103701:	74 19                	je     c010371c <default_check+0x424>
c0103703:	68 d0 63 10 c0       	push   $0xc01063d0
c0103708:	68 b6 60 10 c0       	push   $0xc01060b6
c010370d:	68 33 01 00 00       	push   $0x133
c0103712:	68 cb 60 10 c0       	push   $0xc01060cb
c0103717:	e8 b2 d4 ff ff       	call   c0100bce <__panic>

    free_pages(p0, 2);
c010371c:	83 ec 08             	sub    $0x8,%esp
c010371f:	6a 02                	push   $0x2
c0103721:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103724:	e8 a1 04 00 00       	call   c0103bca <free_pages>
c0103729:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c010372c:	83 ec 08             	sub    $0x8,%esp
c010372f:	6a 01                	push   $0x1
c0103731:	ff 75 d8             	pushl  -0x28(%ebp)
c0103734:	e8 91 04 00 00       	call   c0103bca <free_pages>
c0103739:	83 c4 10             	add    $0x10,%esp

    assert((p0 = alloc_pages(5)) != NULL);
c010373c:	83 ec 0c             	sub    $0xc,%esp
c010373f:	6a 05                	push   $0x5
c0103741:	e8 46 04 00 00       	call   c0103b8c <alloc_pages>
c0103746:	83 c4 10             	add    $0x10,%esp
c0103749:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010374c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103750:	75 19                	jne    c010376b <default_check+0x473>
c0103752:	68 f0 63 10 c0       	push   $0xc01063f0
c0103757:	68 b6 60 10 c0       	push   $0xc01060b6
c010375c:	68 38 01 00 00       	push   $0x138
c0103761:	68 cb 60 10 c0       	push   $0xc01060cb
c0103766:	e8 63 d4 ff ff       	call   c0100bce <__panic>
    assert(alloc_page() == NULL);
c010376b:	83 ec 0c             	sub    $0xc,%esp
c010376e:	6a 01                	push   $0x1
c0103770:	e8 17 04 00 00       	call   c0103b8c <alloc_pages>
c0103775:	83 c4 10             	add    $0x10,%esp
c0103778:	85 c0                	test   %eax,%eax
c010377a:	74 19                	je     c0103795 <default_check+0x49d>
c010377c:	68 4e 62 10 c0       	push   $0xc010624e
c0103781:	68 b6 60 10 c0       	push   $0xc01060b6
c0103786:	68 39 01 00 00       	push   $0x139
c010378b:	68 cb 60 10 c0       	push   $0xc01060cb
c0103790:	e8 39 d4 ff ff       	call   c0100bce <__panic>

    assert(nr_free == 0);
c0103795:	a1 18 bf 11 c0       	mov    0xc011bf18,%eax
c010379a:	85 c0                	test   %eax,%eax
c010379c:	74 19                	je     c01037b7 <default_check+0x4bf>
c010379e:	68 a1 62 10 c0       	push   $0xc01062a1
c01037a3:	68 b6 60 10 c0       	push   $0xc01060b6
c01037a8:	68 3b 01 00 00       	push   $0x13b
c01037ad:	68 cb 60 10 c0       	push   $0xc01060cb
c01037b2:	e8 17 d4 ff ff       	call   c0100bce <__panic>
    nr_free = nr_free_store;
c01037b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01037ba:	a3 18 bf 11 c0       	mov    %eax,0xc011bf18

    free_list = free_list_store;
c01037bf:	8b 45 80             	mov    -0x80(%ebp),%eax
c01037c2:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01037c5:	a3 10 bf 11 c0       	mov    %eax,0xc011bf10
c01037ca:	89 15 14 bf 11 c0    	mov    %edx,0xc011bf14
    free_pages(p0, 5);
c01037d0:	83 ec 08             	sub    $0x8,%esp
c01037d3:	6a 05                	push   $0x5
c01037d5:	ff 75 e4             	pushl  -0x1c(%ebp)
c01037d8:	e8 ed 03 00 00       	call   c0103bca <free_pages>
c01037dd:	83 c4 10             	add    $0x10,%esp

    le = &free_list;
c01037e0:	c7 45 ec 10 bf 11 c0 	movl   $0xc011bf10,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01037e7:	eb 1c                	jmp    c0103805 <default_check+0x50d>
        struct Page *p = le2page(le, page_link);
c01037e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037ec:	83 e8 0c             	sub    $0xc,%eax
c01037ef:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c01037f2:	ff 4d f4             	decl   -0xc(%ebp)
c01037f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01037f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01037fb:	8b 40 08             	mov    0x8(%eax),%eax
c01037fe:	29 c2                	sub    %eax,%edx
c0103800:	89 d0                	mov    %edx,%eax
c0103802:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103805:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103808:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c010380b:	8b 45 88             	mov    -0x78(%ebp),%eax
c010380e:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0103811:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103814:	81 7d ec 10 bf 11 c0 	cmpl   $0xc011bf10,-0x14(%ebp)
c010381b:	75 cc                	jne    c01037e9 <default_check+0x4f1>
    }
    assert(count == 0);
c010381d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103821:	74 19                	je     c010383c <default_check+0x544>
c0103823:	68 0e 64 10 c0       	push   $0xc010640e
c0103828:	68 b6 60 10 c0       	push   $0xc01060b6
c010382d:	68 46 01 00 00       	push   $0x146
c0103832:	68 cb 60 10 c0       	push   $0xc01060cb
c0103837:	e8 92 d3 ff ff       	call   c0100bce <__panic>
    assert(total == 0);
c010383c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103840:	74 19                	je     c010385b <default_check+0x563>
c0103842:	68 19 64 10 c0       	push   $0xc0106419
c0103847:	68 b6 60 10 c0       	push   $0xc01060b6
c010384c:	68 47 01 00 00       	push   $0x147
c0103851:	68 cb 60 10 c0       	push   $0xc01060cb
c0103856:	e8 73 d3 ff ff       	call   c0100bce <__panic>
}
c010385b:	90                   	nop
c010385c:	c9                   	leave  
c010385d:	c3                   	ret    

c010385e <page2ppn>:
page2ppn(struct Page *page) {
c010385e:	55                   	push   %ebp
c010385f:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103861:	a1 24 bf 11 c0       	mov    0xc011bf24,%eax
c0103866:	8b 55 08             	mov    0x8(%ebp),%edx
c0103869:	29 c2                	sub    %eax,%edx
c010386b:	89 d0                	mov    %edx,%eax
c010386d:	c1 f8 02             	sar    $0x2,%eax
c0103870:	89 c2                	mov    %eax,%edx
c0103872:	89 d0                	mov    %edx,%eax
c0103874:	c1 e0 02             	shl    $0x2,%eax
c0103877:	01 d0                	add    %edx,%eax
c0103879:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
c0103880:	01 c8                	add    %ecx,%eax
c0103882:	01 c0                	add    %eax,%eax
c0103884:	01 d0                	add    %edx,%eax
c0103886:	89 c1                	mov    %eax,%ecx
c0103888:	c1 e1 08             	shl    $0x8,%ecx
c010388b:	01 c8                	add    %ecx,%eax
c010388d:	89 c1                	mov    %eax,%ecx
c010388f:	c1 e1 10             	shl    $0x10,%ecx
c0103892:	01 c8                	add    %ecx,%eax
c0103894:	c1 e0 02             	shl    $0x2,%eax
c0103897:	01 d0                	add    %edx,%eax
}
c0103899:	5d                   	pop    %ebp
c010389a:	c3                   	ret    

c010389b <page2pa>:
page2pa(struct Page *page) {
c010389b:	55                   	push   %ebp
c010389c:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c010389e:	ff 75 08             	pushl  0x8(%ebp)
c01038a1:	e8 b8 ff ff ff       	call   c010385e <page2ppn>
c01038a6:	83 c4 04             	add    $0x4,%esp
c01038a9:	c1 e0 0c             	shl    $0xc,%eax
}
c01038ac:	c9                   	leave  
c01038ad:	c3                   	ret    

c01038ae <pa2page>:
pa2page(uintptr_t pa) {
c01038ae:	55                   	push   %ebp
c01038af:	89 e5                	mov    %esp,%ebp
c01038b1:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c01038b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01038b7:	c1 e8 0c             	shr    $0xc,%eax
c01038ba:	89 c2                	mov    %eax,%edx
c01038bc:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c01038c1:	39 c2                	cmp    %eax,%edx
c01038c3:	72 14                	jb     c01038d9 <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c01038c5:	83 ec 04             	sub    $0x4,%esp
c01038c8:	68 54 64 10 c0       	push   $0xc0106454
c01038cd:	6a 5a                	push   $0x5a
c01038cf:	68 73 64 10 c0       	push   $0xc0106473
c01038d4:	e8 f5 d2 ff ff       	call   c0100bce <__panic>
    return &pages[PPN(pa)];
c01038d9:	8b 15 24 bf 11 c0    	mov    0xc011bf24,%edx
c01038df:	8b 45 08             	mov    0x8(%ebp),%eax
c01038e2:	c1 e8 0c             	shr    $0xc,%eax
c01038e5:	89 c1                	mov    %eax,%ecx
c01038e7:	89 c8                	mov    %ecx,%eax
c01038e9:	c1 e0 02             	shl    $0x2,%eax
c01038ec:	01 c8                	add    %ecx,%eax
c01038ee:	c1 e0 02             	shl    $0x2,%eax
c01038f1:	01 d0                	add    %edx,%eax
}
c01038f3:	c9                   	leave  
c01038f4:	c3                   	ret    

c01038f5 <page2kva>:
page2kva(struct Page *page) {
c01038f5:	55                   	push   %ebp
c01038f6:	89 e5                	mov    %esp,%ebp
c01038f8:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
c01038fb:	ff 75 08             	pushl  0x8(%ebp)
c01038fe:	e8 98 ff ff ff       	call   c010389b <page2pa>
c0103903:	83 c4 04             	add    $0x4,%esp
c0103906:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103909:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010390c:	c1 e8 0c             	shr    $0xc,%eax
c010390f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103912:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c0103917:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010391a:	72 14                	jb     c0103930 <page2kva+0x3b>
c010391c:	ff 75 f4             	pushl  -0xc(%ebp)
c010391f:	68 84 64 10 c0       	push   $0xc0106484
c0103924:	6a 61                	push   $0x61
c0103926:	68 73 64 10 c0       	push   $0xc0106473
c010392b:	e8 9e d2 ff ff       	call   c0100bce <__panic>
c0103930:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103933:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103938:	c9                   	leave  
c0103939:	c3                   	ret    

c010393a <pte2page>:
pte2page(pte_t pte) {
c010393a:	55                   	push   %ebp
c010393b:	89 e5                	mov    %esp,%ebp
c010393d:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
c0103940:	8b 45 08             	mov    0x8(%ebp),%eax
c0103943:	83 e0 01             	and    $0x1,%eax
c0103946:	85 c0                	test   %eax,%eax
c0103948:	75 14                	jne    c010395e <pte2page+0x24>
        panic("pte2page called with invalid pte");
c010394a:	83 ec 04             	sub    $0x4,%esp
c010394d:	68 a8 64 10 c0       	push   $0xc01064a8
c0103952:	6a 6c                	push   $0x6c
c0103954:	68 73 64 10 c0       	push   $0xc0106473
c0103959:	e8 70 d2 ff ff       	call   c0100bce <__panic>
    return pa2page(PTE_ADDR(pte));
c010395e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103961:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103966:	83 ec 0c             	sub    $0xc,%esp
c0103969:	50                   	push   %eax
c010396a:	e8 3f ff ff ff       	call   c01038ae <pa2page>
c010396f:	83 c4 10             	add    $0x10,%esp
}
c0103972:	c9                   	leave  
c0103973:	c3                   	ret    

c0103974 <pde2page>:
pde2page(pde_t pde) {
c0103974:	55                   	push   %ebp
c0103975:	89 e5                	mov    %esp,%ebp
c0103977:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
c010397a:	8b 45 08             	mov    0x8(%ebp),%eax
c010397d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103982:	83 ec 0c             	sub    $0xc,%esp
c0103985:	50                   	push   %eax
c0103986:	e8 23 ff ff ff       	call   c01038ae <pa2page>
c010398b:	83 c4 10             	add    $0x10,%esp
}
c010398e:	c9                   	leave  
c010398f:	c3                   	ret    

c0103990 <page_ref>:
page_ref(struct Page *page) {
c0103990:	55                   	push   %ebp
c0103991:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103993:	8b 45 08             	mov    0x8(%ebp),%eax
c0103996:	8b 00                	mov    (%eax),%eax
}
c0103998:	5d                   	pop    %ebp
c0103999:	c3                   	ret    

c010399a <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c010399a:	55                   	push   %ebp
c010399b:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c010399d:	8b 45 08             	mov    0x8(%ebp),%eax
c01039a0:	8b 55 0c             	mov    0xc(%ebp),%edx
c01039a3:	89 10                	mov    %edx,(%eax)
}
c01039a5:	90                   	nop
c01039a6:	5d                   	pop    %ebp
c01039a7:	c3                   	ret    

c01039a8 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c01039a8:	55                   	push   %ebp
c01039a9:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c01039ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01039ae:	8b 00                	mov    (%eax),%eax
c01039b0:	8d 50 01             	lea    0x1(%eax),%edx
c01039b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01039b6:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01039b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01039bb:	8b 00                	mov    (%eax),%eax
}
c01039bd:	5d                   	pop    %ebp
c01039be:	c3                   	ret    

c01039bf <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c01039bf:	55                   	push   %ebp
c01039c0:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c01039c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01039c5:	8b 00                	mov    (%eax),%eax
c01039c7:	8d 50 ff             	lea    -0x1(%eax),%edx
c01039ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01039cd:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01039cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01039d2:	8b 00                	mov    (%eax),%eax
}
c01039d4:	5d                   	pop    %ebp
c01039d5:	c3                   	ret    

c01039d6 <__intr_save>:
__intr_save(void) {
c01039d6:	55                   	push   %ebp
c01039d7:	89 e5                	mov    %esp,%ebp
c01039d9:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01039dc:	9c                   	pushf  
c01039dd:	58                   	pop    %eax
c01039de:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01039e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01039e4:	25 00 02 00 00       	and    $0x200,%eax
c01039e9:	85 c0                	test   %eax,%eax
c01039eb:	74 0c                	je     c01039f9 <__intr_save+0x23>
        intr_disable();
c01039ed:	e8 a6 db ff ff       	call   c0101598 <intr_disable>
        return 1;
c01039f2:	b8 01 00 00 00       	mov    $0x1,%eax
c01039f7:	eb 05                	jmp    c01039fe <__intr_save+0x28>
    return 0;
c01039f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01039fe:	c9                   	leave  
c01039ff:	c3                   	ret    

c0103a00 <__intr_restore>:
__intr_restore(bool flag) {
c0103a00:	55                   	push   %ebp
c0103a01:	89 e5                	mov    %esp,%ebp
c0103a03:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103a06:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103a0a:	74 05                	je     c0103a11 <__intr_restore+0x11>
        intr_enable();
c0103a0c:	e8 80 db ff ff       	call   c0101591 <intr_enable>
}
c0103a11:	90                   	nop
c0103a12:	c9                   	leave  
c0103a13:	c3                   	ret    

c0103a14 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103a14:	55                   	push   %ebp
c0103a15:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103a17:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a1a:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103a1d:	b8 23 00 00 00       	mov    $0x23,%eax
c0103a22:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103a24:	b8 23 00 00 00       	mov    $0x23,%eax
c0103a29:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103a2b:	b8 10 00 00 00       	mov    $0x10,%eax
c0103a30:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103a32:	b8 10 00 00 00       	mov    $0x10,%eax
c0103a37:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103a39:	b8 10 00 00 00       	mov    $0x10,%eax
c0103a3e:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103a40:	ea 47 3a 10 c0 08 00 	ljmp   $0x8,$0xc0103a47
}
c0103a47:	90                   	nop
c0103a48:	5d                   	pop    %ebp
c0103a49:	c3                   	ret    

c0103a4a <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103a4a:	55                   	push   %ebp
c0103a4b:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103a4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a50:	a3 a4 be 11 c0       	mov    %eax,0xc011bea4
}
c0103a55:	90                   	nop
c0103a56:	5d                   	pop    %ebp
c0103a57:	c3                   	ret    

c0103a58 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103a58:	55                   	push   %ebp
c0103a59:	89 e5                	mov    %esp,%ebp
c0103a5b:	83 ec 10             	sub    $0x10,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103a5e:	b8 00 80 11 c0       	mov    $0xc0118000,%eax
c0103a63:	50                   	push   %eax
c0103a64:	e8 e1 ff ff ff       	call   c0103a4a <load_esp0>
c0103a69:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
c0103a6c:	66 c7 05 a8 be 11 c0 	movw   $0x10,0xc011bea8
c0103a73:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103a75:	66 c7 05 28 8a 11 c0 	movw   $0x68,0xc0118a28
c0103a7c:	68 00 
c0103a7e:	b8 a0 be 11 c0       	mov    $0xc011bea0,%eax
c0103a83:	66 a3 2a 8a 11 c0    	mov    %ax,0xc0118a2a
c0103a89:	b8 a0 be 11 c0       	mov    $0xc011bea0,%eax
c0103a8e:	c1 e8 10             	shr    $0x10,%eax
c0103a91:	a2 2c 8a 11 c0       	mov    %al,0xc0118a2c
c0103a96:	a0 2d 8a 11 c0       	mov    0xc0118a2d,%al
c0103a9b:	83 e0 f0             	and    $0xfffffff0,%eax
c0103a9e:	83 c8 09             	or     $0x9,%eax
c0103aa1:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103aa6:	a0 2d 8a 11 c0       	mov    0xc0118a2d,%al
c0103aab:	83 e0 ef             	and    $0xffffffef,%eax
c0103aae:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103ab3:	a0 2d 8a 11 c0       	mov    0xc0118a2d,%al
c0103ab8:	83 e0 9f             	and    $0xffffff9f,%eax
c0103abb:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103ac0:	a0 2d 8a 11 c0       	mov    0xc0118a2d,%al
c0103ac5:	83 c8 80             	or     $0xffffff80,%eax
c0103ac8:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103acd:	a0 2e 8a 11 c0       	mov    0xc0118a2e,%al
c0103ad2:	83 e0 f0             	and    $0xfffffff0,%eax
c0103ad5:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103ada:	a0 2e 8a 11 c0       	mov    0xc0118a2e,%al
c0103adf:	83 e0 ef             	and    $0xffffffef,%eax
c0103ae2:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103ae7:	a0 2e 8a 11 c0       	mov    0xc0118a2e,%al
c0103aec:	83 e0 df             	and    $0xffffffdf,%eax
c0103aef:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103af4:	a0 2e 8a 11 c0       	mov    0xc0118a2e,%al
c0103af9:	83 c8 40             	or     $0x40,%eax
c0103afc:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103b01:	a0 2e 8a 11 c0       	mov    0xc0118a2e,%al
c0103b06:	83 e0 7f             	and    $0x7f,%eax
c0103b09:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103b0e:	b8 a0 be 11 c0       	mov    $0xc011bea0,%eax
c0103b13:	c1 e8 18             	shr    $0x18,%eax
c0103b16:	a2 2f 8a 11 c0       	mov    %al,0xc0118a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103b1b:	68 30 8a 11 c0       	push   $0xc0118a30
c0103b20:	e8 ef fe ff ff       	call   c0103a14 <lgdt>
c0103b25:	83 c4 04             	add    $0x4,%esp
c0103b28:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103b2e:	66 8b 45 fe          	mov    -0x2(%ebp),%ax
c0103b32:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103b35:	90                   	nop
c0103b36:	c9                   	leave  
c0103b37:	c3                   	ret    

c0103b38 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103b38:	55                   	push   %ebp
c0103b39:	89 e5                	mov    %esp,%ebp
c0103b3b:	83 ec 08             	sub    $0x8,%esp
    pmm_manager = &default_pmm_manager;
c0103b3e:	c7 05 1c bf 11 c0 38 	movl   $0xc0106438,0xc011bf1c
c0103b45:	64 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103b48:	a1 1c bf 11 c0       	mov    0xc011bf1c,%eax
c0103b4d:	8b 00                	mov    (%eax),%eax
c0103b4f:	83 ec 08             	sub    $0x8,%esp
c0103b52:	50                   	push   %eax
c0103b53:	68 d4 64 10 c0       	push   $0xc01064d4
c0103b58:	e8 da c7 ff ff       	call   c0100337 <cprintf>
c0103b5d:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
c0103b60:	a1 1c bf 11 c0       	mov    0xc011bf1c,%eax
c0103b65:	8b 40 04             	mov    0x4(%eax),%eax
c0103b68:	ff d0                	call   *%eax
}
c0103b6a:	90                   	nop
c0103b6b:	c9                   	leave  
c0103b6c:	c3                   	ret    

c0103b6d <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103b6d:	55                   	push   %ebp
c0103b6e:	89 e5                	mov    %esp,%ebp
c0103b70:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->init_memmap(base, n);
c0103b73:	a1 1c bf 11 c0       	mov    0xc011bf1c,%eax
c0103b78:	8b 40 08             	mov    0x8(%eax),%eax
c0103b7b:	83 ec 08             	sub    $0x8,%esp
c0103b7e:	ff 75 0c             	pushl  0xc(%ebp)
c0103b81:	ff 75 08             	pushl  0x8(%ebp)
c0103b84:	ff d0                	call   *%eax
c0103b86:	83 c4 10             	add    $0x10,%esp
}
c0103b89:	90                   	nop
c0103b8a:	c9                   	leave  
c0103b8b:	c3                   	ret    

c0103b8c <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103b8c:	55                   	push   %ebp
c0103b8d:	89 e5                	mov    %esp,%ebp
c0103b8f:	83 ec 18             	sub    $0x18,%esp
    struct Page *page=NULL;
c0103b92:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103b99:	e8 38 fe ff ff       	call   c01039d6 <__intr_save>
c0103b9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103ba1:	a1 1c bf 11 c0       	mov    0xc011bf1c,%eax
c0103ba6:	8b 40 0c             	mov    0xc(%eax),%eax
c0103ba9:	83 ec 0c             	sub    $0xc,%esp
c0103bac:	ff 75 08             	pushl  0x8(%ebp)
c0103baf:	ff d0                	call   *%eax
c0103bb1:	83 c4 10             	add    $0x10,%esp
c0103bb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103bb7:	83 ec 0c             	sub    $0xc,%esp
c0103bba:	ff 75 f0             	pushl  -0x10(%ebp)
c0103bbd:	e8 3e fe ff ff       	call   c0103a00 <__intr_restore>
c0103bc2:	83 c4 10             	add    $0x10,%esp
    return page;
c0103bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103bc8:	c9                   	leave  
c0103bc9:	c3                   	ret    

c0103bca <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103bca:	55                   	push   %ebp
c0103bcb:	89 e5                	mov    %esp,%ebp
c0103bcd:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103bd0:	e8 01 fe ff ff       	call   c01039d6 <__intr_save>
c0103bd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103bd8:	a1 1c bf 11 c0       	mov    0xc011bf1c,%eax
c0103bdd:	8b 40 10             	mov    0x10(%eax),%eax
c0103be0:	83 ec 08             	sub    $0x8,%esp
c0103be3:	ff 75 0c             	pushl  0xc(%ebp)
c0103be6:	ff 75 08             	pushl  0x8(%ebp)
c0103be9:	ff d0                	call   *%eax
c0103beb:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c0103bee:	83 ec 0c             	sub    $0xc,%esp
c0103bf1:	ff 75 f4             	pushl  -0xc(%ebp)
c0103bf4:	e8 07 fe ff ff       	call   c0103a00 <__intr_restore>
c0103bf9:	83 c4 10             	add    $0x10,%esp
}
c0103bfc:	90                   	nop
c0103bfd:	c9                   	leave  
c0103bfe:	c3                   	ret    

c0103bff <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103bff:	55                   	push   %ebp
c0103c00:	89 e5                	mov    %esp,%ebp
c0103c02:	83 ec 18             	sub    $0x18,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103c05:	e8 cc fd ff ff       	call   c01039d6 <__intr_save>
c0103c0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103c0d:	a1 1c bf 11 c0       	mov    0xc011bf1c,%eax
c0103c12:	8b 40 14             	mov    0x14(%eax),%eax
c0103c15:	ff d0                	call   *%eax
c0103c17:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103c1a:	83 ec 0c             	sub    $0xc,%esp
c0103c1d:	ff 75 f4             	pushl  -0xc(%ebp)
c0103c20:	e8 db fd ff ff       	call   c0103a00 <__intr_restore>
c0103c25:	83 c4 10             	add    $0x10,%esp
    return ret;
c0103c28:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103c2b:	c9                   	leave  
c0103c2c:	c3                   	ret    

c0103c2d <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103c2d:	55                   	push   %ebp
c0103c2e:	89 e5                	mov    %esp,%ebp
c0103c30:	57                   	push   %edi
c0103c31:	56                   	push   %esi
c0103c32:	53                   	push   %ebx
c0103c33:	83 ec 7c             	sub    $0x7c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103c36:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103c3d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103c44:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103c4b:	83 ec 0c             	sub    $0xc,%esp
c0103c4e:	68 eb 64 10 c0       	push   $0xc01064eb
c0103c53:	e8 df c6 ff ff       	call   c0100337 <cprintf>
c0103c58:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103c5b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103c62:	e9 f3 00 00 00       	jmp    c0103d5a <page_init+0x12d>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103c67:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103c6a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103c6d:	89 d0                	mov    %edx,%eax
c0103c6f:	c1 e0 02             	shl    $0x2,%eax
c0103c72:	01 d0                	add    %edx,%eax
c0103c74:	c1 e0 02             	shl    $0x2,%eax
c0103c77:	01 c8                	add    %ecx,%eax
c0103c79:	8b 50 08             	mov    0x8(%eax),%edx
c0103c7c:	8b 40 04             	mov    0x4(%eax),%eax
c0103c7f:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103c82:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103c85:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103c88:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103c8b:	89 d0                	mov    %edx,%eax
c0103c8d:	c1 e0 02             	shl    $0x2,%eax
c0103c90:	01 d0                	add    %edx,%eax
c0103c92:	c1 e0 02             	shl    $0x2,%eax
c0103c95:	01 c8                	add    %ecx,%eax
c0103c97:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103c9a:	8b 58 10             	mov    0x10(%eax),%ebx
c0103c9d:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103ca0:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103ca3:	01 c8                	add    %ecx,%eax
c0103ca5:	11 da                	adc    %ebx,%edx
c0103ca7:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103caa:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103cad:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103cb0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103cb3:	89 d0                	mov    %edx,%eax
c0103cb5:	c1 e0 02             	shl    $0x2,%eax
c0103cb8:	01 d0                	add    %edx,%eax
c0103cba:	c1 e0 02             	shl    $0x2,%eax
c0103cbd:	01 c8                	add    %ecx,%eax
c0103cbf:	83 c0 14             	add    $0x14,%eax
c0103cc2:	8b 00                	mov    (%eax),%eax
c0103cc4:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0103cc7:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103cca:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103ccd:	83 c0 ff             	add    $0xffffffff,%eax
c0103cd0:	83 d2 ff             	adc    $0xffffffff,%edx
c0103cd3:	89 c1                	mov    %eax,%ecx
c0103cd5:	89 d3                	mov    %edx,%ebx
c0103cd7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0103cda:	89 55 80             	mov    %edx,-0x80(%ebp)
c0103cdd:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ce0:	89 d0                	mov    %edx,%eax
c0103ce2:	c1 e0 02             	shl    $0x2,%eax
c0103ce5:	01 d0                	add    %edx,%eax
c0103ce7:	c1 e0 02             	shl    $0x2,%eax
c0103cea:	03 45 80             	add    -0x80(%ebp),%eax
c0103ced:	8b 50 10             	mov    0x10(%eax),%edx
c0103cf0:	8b 40 0c             	mov    0xc(%eax),%eax
c0103cf3:	ff 75 84             	pushl  -0x7c(%ebp)
c0103cf6:	53                   	push   %ebx
c0103cf7:	51                   	push   %ecx
c0103cf8:	ff 75 bc             	pushl  -0x44(%ebp)
c0103cfb:	ff 75 b8             	pushl  -0x48(%ebp)
c0103cfe:	52                   	push   %edx
c0103cff:	50                   	push   %eax
c0103d00:	68 f8 64 10 c0       	push   $0xc01064f8
c0103d05:	e8 2d c6 ff ff       	call   c0100337 <cprintf>
c0103d0a:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103d0d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103d10:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103d13:	89 d0                	mov    %edx,%eax
c0103d15:	c1 e0 02             	shl    $0x2,%eax
c0103d18:	01 d0                	add    %edx,%eax
c0103d1a:	c1 e0 02             	shl    $0x2,%eax
c0103d1d:	01 c8                	add    %ecx,%eax
c0103d1f:	83 c0 14             	add    $0x14,%eax
c0103d22:	8b 00                	mov    (%eax),%eax
c0103d24:	83 f8 01             	cmp    $0x1,%eax
c0103d27:	75 2e                	jne    c0103d57 <page_init+0x12a>
            if (maxpa < end && begin < KMEMSIZE) {
c0103d29:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103d2c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103d2f:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0103d32:	89 d0                	mov    %edx,%eax
c0103d34:	1b 45 b4             	sbb    -0x4c(%ebp),%eax
c0103d37:	73 1e                	jae    c0103d57 <page_init+0x12a>
c0103d39:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
c0103d3e:	b8 00 00 00 00       	mov    $0x0,%eax
c0103d43:	3b 55 b8             	cmp    -0x48(%ebp),%edx
c0103d46:	1b 45 bc             	sbb    -0x44(%ebp),%eax
c0103d49:	72 0c                	jb     c0103d57 <page_init+0x12a>
                maxpa = end;
c0103d4b:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103d4e:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103d51:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103d54:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c0103d57:	ff 45 dc             	incl   -0x24(%ebp)
c0103d5a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103d5d:	8b 00                	mov    (%eax),%eax
c0103d5f:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103d62:	0f 8c ff fe ff ff    	jl     c0103c67 <page_init+0x3a>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103d68:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0103d6d:	b8 00 00 00 00       	mov    $0x0,%eax
c0103d72:	3b 55 e0             	cmp    -0x20(%ebp),%edx
c0103d75:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
c0103d78:	73 0e                	jae    c0103d88 <page_init+0x15b>
        maxpa = KMEMSIZE;
c0103d7a:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103d81:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0103d88:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103d8b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103d8e:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103d92:	c1 ea 0c             	shr    $0xc,%edx
c0103d95:	89 c1                	mov    %eax,%ecx
c0103d97:	89 d3                	mov    %edx,%ebx
c0103d99:	89 c8                	mov    %ecx,%eax
c0103d9b:	a3 80 be 11 c0       	mov    %eax,0xc011be80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103da0:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0103da7:	b8 28 bf 11 c0       	mov    $0xc011bf28,%eax
c0103dac:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103daf:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103db2:	01 d0                	add    %edx,%eax
c0103db4:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103db7:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103dba:	ba 00 00 00 00       	mov    $0x0,%edx
c0103dbf:	f7 75 ac             	divl   -0x54(%ebp)
c0103dc2:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103dc5:	29 d0                	sub    %edx,%eax
c0103dc7:	a3 24 bf 11 c0       	mov    %eax,0xc011bf24

    for (i = 0; i < npage; i ++) {
c0103dcc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103dd3:	eb 2e                	jmp    c0103e03 <page_init+0x1d6>
        SetPageReserved(pages + i);
c0103dd5:	8b 0d 24 bf 11 c0    	mov    0xc011bf24,%ecx
c0103ddb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103dde:	89 d0                	mov    %edx,%eax
c0103de0:	c1 e0 02             	shl    $0x2,%eax
c0103de3:	01 d0                	add    %edx,%eax
c0103de5:	c1 e0 02             	shl    $0x2,%eax
c0103de8:	01 c8                	add    %ecx,%eax
c0103dea:	83 c0 04             	add    $0x4,%eax
c0103ded:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0103df4:	89 45 8c             	mov    %eax,-0x74(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103df7:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103dfa:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103dfd:	0f ab 10             	bts    %edx,(%eax)
    for (i = 0; i < npage; i ++) {
c0103e00:	ff 45 dc             	incl   -0x24(%ebp)
c0103e03:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e06:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c0103e0b:	39 c2                	cmp    %eax,%edx
c0103e0d:	72 c6                	jb     c0103dd5 <page_init+0x1a8>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0103e0f:	8b 15 80 be 11 c0    	mov    0xc011be80,%edx
c0103e15:	89 d0                	mov    %edx,%eax
c0103e17:	c1 e0 02             	shl    $0x2,%eax
c0103e1a:	01 d0                	add    %edx,%eax
c0103e1c:	c1 e0 02             	shl    $0x2,%eax
c0103e1f:	89 c2                	mov    %eax,%edx
c0103e21:	a1 24 bf 11 c0       	mov    0xc011bf24,%eax
c0103e26:	01 d0                	add    %edx,%eax
c0103e28:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0103e2b:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0103e32:	77 17                	ja     c0103e4b <page_init+0x21e>
c0103e34:	ff 75 a4             	pushl  -0x5c(%ebp)
c0103e37:	68 28 65 10 c0       	push   $0xc0106528
c0103e3c:	68 dc 00 00 00       	push   $0xdc
c0103e41:	68 4c 65 10 c0       	push   $0xc010654c
c0103e46:	e8 83 cd ff ff       	call   c0100bce <__panic>
c0103e4b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103e4e:	05 00 00 00 40       	add    $0x40000000,%eax
c0103e53:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0103e56:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103e5d:	e9 58 01 00 00       	jmp    c0103fba <page_init+0x38d>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103e62:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e65:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e68:	89 d0                	mov    %edx,%eax
c0103e6a:	c1 e0 02             	shl    $0x2,%eax
c0103e6d:	01 d0                	add    %edx,%eax
c0103e6f:	c1 e0 02             	shl    $0x2,%eax
c0103e72:	01 c8                	add    %ecx,%eax
c0103e74:	8b 50 08             	mov    0x8(%eax),%edx
c0103e77:	8b 40 04             	mov    0x4(%eax),%eax
c0103e7a:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103e7d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103e80:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e83:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e86:	89 d0                	mov    %edx,%eax
c0103e88:	c1 e0 02             	shl    $0x2,%eax
c0103e8b:	01 d0                	add    %edx,%eax
c0103e8d:	c1 e0 02             	shl    $0x2,%eax
c0103e90:	01 c8                	add    %ecx,%eax
c0103e92:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103e95:	8b 58 10             	mov    0x10(%eax),%ebx
c0103e98:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103e9b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103e9e:	01 c8                	add    %ecx,%eax
c0103ea0:	11 da                	adc    %ebx,%edx
c0103ea2:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0103ea5:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0103ea8:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103eab:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103eae:	89 d0                	mov    %edx,%eax
c0103eb0:	c1 e0 02             	shl    $0x2,%eax
c0103eb3:	01 d0                	add    %edx,%eax
c0103eb5:	c1 e0 02             	shl    $0x2,%eax
c0103eb8:	01 c8                	add    %ecx,%eax
c0103eba:	83 c0 14             	add    $0x14,%eax
c0103ebd:	8b 00                	mov    (%eax),%eax
c0103ebf:	83 f8 01             	cmp    $0x1,%eax
c0103ec2:	0f 85 ef 00 00 00    	jne    c0103fb7 <page_init+0x38a>
            if (begin < freemem) {
c0103ec8:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103ecb:	ba 00 00 00 00       	mov    $0x0,%edx
c0103ed0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0103ed3:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0103ed6:	19 d1                	sbb    %edx,%ecx
c0103ed8:	73 0d                	jae    c0103ee7 <page_init+0x2ba>
                begin = freemem;
c0103eda:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103edd:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103ee0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0103ee7:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0103eec:	b8 00 00 00 00       	mov    $0x0,%eax
c0103ef1:	3b 55 c8             	cmp    -0x38(%ebp),%edx
c0103ef4:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0103ef7:	73 0e                	jae    c0103f07 <page_init+0x2da>
                end = KMEMSIZE;
c0103ef9:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0103f00:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0103f07:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103f0a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103f0d:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103f10:	89 d0                	mov    %edx,%eax
c0103f12:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0103f15:	0f 83 9c 00 00 00    	jae    c0103fb7 <page_init+0x38a>
                begin = ROUNDUP(begin, PGSIZE);
c0103f1b:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0103f22:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103f25:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103f28:	01 d0                	add    %edx,%eax
c0103f2a:	48                   	dec    %eax
c0103f2b:	89 45 98             	mov    %eax,-0x68(%ebp)
c0103f2e:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103f31:	ba 00 00 00 00       	mov    $0x0,%edx
c0103f36:	f7 75 9c             	divl   -0x64(%ebp)
c0103f39:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103f3c:	29 d0                	sub    %edx,%eax
c0103f3e:	ba 00 00 00 00       	mov    $0x0,%edx
c0103f43:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103f46:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0103f49:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103f4c:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0103f4f:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0103f52:	ba 00 00 00 00       	mov    $0x0,%edx
c0103f57:	89 c3                	mov    %eax,%ebx
c0103f59:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c0103f5f:	89 de                	mov    %ebx,%esi
c0103f61:	89 d0                	mov    %edx,%eax
c0103f63:	83 e0 00             	and    $0x0,%eax
c0103f66:	89 c7                	mov    %eax,%edi
c0103f68:	89 75 c8             	mov    %esi,-0x38(%ebp)
c0103f6b:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c0103f6e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103f71:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103f74:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103f77:	89 d0                	mov    %edx,%eax
c0103f79:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0103f7c:	73 39                	jae    c0103fb7 <page_init+0x38a>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0103f7e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103f81:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103f84:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0103f87:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0103f8a:	89 c1                	mov    %eax,%ecx
c0103f8c:	89 d3                	mov    %edx,%ebx
c0103f8e:	89 c8                	mov    %ecx,%eax
c0103f90:	89 da                	mov    %ebx,%edx
c0103f92:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103f96:	c1 ea 0c             	shr    $0xc,%edx
c0103f99:	89 c3                	mov    %eax,%ebx
c0103f9b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103f9e:	83 ec 0c             	sub    $0xc,%esp
c0103fa1:	50                   	push   %eax
c0103fa2:	e8 07 f9 ff ff       	call   c01038ae <pa2page>
c0103fa7:	83 c4 10             	add    $0x10,%esp
c0103faa:	83 ec 08             	sub    $0x8,%esp
c0103fad:	53                   	push   %ebx
c0103fae:	50                   	push   %eax
c0103faf:	e8 b9 fb ff ff       	call   c0103b6d <init_memmap>
c0103fb4:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < memmap->nr_map; i ++) {
c0103fb7:	ff 45 dc             	incl   -0x24(%ebp)
c0103fba:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103fbd:	8b 00                	mov    (%eax),%eax
c0103fbf:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103fc2:	0f 8c 9a fe ff ff    	jl     c0103e62 <page_init+0x235>
                }
            }
        }
    }
}
c0103fc8:	90                   	nop
c0103fc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0103fcc:	5b                   	pop    %ebx
c0103fcd:	5e                   	pop    %esi
c0103fce:	5f                   	pop    %edi
c0103fcf:	5d                   	pop    %ebp
c0103fd0:	c3                   	ret    

c0103fd1 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0103fd1:	55                   	push   %ebp
c0103fd2:	89 e5                	mov    %esp,%ebp
c0103fd4:	83 ec 28             	sub    $0x28,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0103fd7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103fda:	33 45 14             	xor    0x14(%ebp),%eax
c0103fdd:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103fe2:	85 c0                	test   %eax,%eax
c0103fe4:	74 19                	je     c0103fff <boot_map_segment+0x2e>
c0103fe6:	68 5a 65 10 c0       	push   $0xc010655a
c0103feb:	68 71 65 10 c0       	push   $0xc0106571
c0103ff0:	68 fa 00 00 00       	push   $0xfa
c0103ff5:	68 4c 65 10 c0       	push   $0xc010654c
c0103ffa:	e8 cf cb ff ff       	call   c0100bce <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0103fff:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0104006:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104009:	25 ff 0f 00 00       	and    $0xfff,%eax
c010400e:	89 c2                	mov    %eax,%edx
c0104010:	8b 45 10             	mov    0x10(%ebp),%eax
c0104013:	01 c2                	add    %eax,%edx
c0104015:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104018:	01 d0                	add    %edx,%eax
c010401a:	48                   	dec    %eax
c010401b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010401e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104021:	ba 00 00 00 00       	mov    $0x0,%edx
c0104026:	f7 75 f0             	divl   -0x10(%ebp)
c0104029:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010402c:	29 d0                	sub    %edx,%eax
c010402e:	c1 e8 0c             	shr    $0xc,%eax
c0104031:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104034:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104037:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010403a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010403d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104042:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104045:	8b 45 14             	mov    0x14(%ebp),%eax
c0104048:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010404b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010404e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104053:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104056:	eb 56                	jmp    c01040ae <boot_map_segment+0xdd>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0104058:	83 ec 04             	sub    $0x4,%esp
c010405b:	6a 01                	push   $0x1
c010405d:	ff 75 0c             	pushl  0xc(%ebp)
c0104060:	ff 75 08             	pushl  0x8(%ebp)
c0104063:	e8 52 01 00 00       	call   c01041ba <get_pte>
c0104068:	83 c4 10             	add    $0x10,%esp
c010406b:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c010406e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104072:	75 19                	jne    c010408d <boot_map_segment+0xbc>
c0104074:	68 86 65 10 c0       	push   $0xc0106586
c0104079:	68 71 65 10 c0       	push   $0xc0106571
c010407e:	68 00 01 00 00       	push   $0x100
c0104083:	68 4c 65 10 c0       	push   $0xc010654c
c0104088:	e8 41 cb ff ff       	call   c0100bce <__panic>
        *ptep = pa | PTE_P | perm;
c010408d:	8b 45 14             	mov    0x14(%ebp),%eax
c0104090:	0b 45 18             	or     0x18(%ebp),%eax
c0104093:	83 c8 01             	or     $0x1,%eax
c0104096:	89 c2                	mov    %eax,%edx
c0104098:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010409b:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c010409d:	ff 4d f4             	decl   -0xc(%ebp)
c01040a0:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01040a7:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01040ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01040b2:	75 a4                	jne    c0104058 <boot_map_segment+0x87>
    }
}
c01040b4:	90                   	nop
c01040b5:	c9                   	leave  
c01040b6:	c3                   	ret    

c01040b7 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01040b7:	55                   	push   %ebp
c01040b8:	89 e5                	mov    %esp,%ebp
c01040ba:	83 ec 18             	sub    $0x18,%esp
    struct Page *p = alloc_page();
c01040bd:	83 ec 0c             	sub    $0xc,%esp
c01040c0:	6a 01                	push   $0x1
c01040c2:	e8 c5 fa ff ff       	call   c0103b8c <alloc_pages>
c01040c7:	83 c4 10             	add    $0x10,%esp
c01040ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01040cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01040d1:	75 17                	jne    c01040ea <boot_alloc_page+0x33>
        panic("boot_alloc_page failed.\n");
c01040d3:	83 ec 04             	sub    $0x4,%esp
c01040d6:	68 93 65 10 c0       	push   $0xc0106593
c01040db:	68 0c 01 00 00       	push   $0x10c
c01040e0:	68 4c 65 10 c0       	push   $0xc010654c
c01040e5:	e8 e4 ca ff ff       	call   c0100bce <__panic>
    }
    return page2kva(p);
c01040ea:	83 ec 0c             	sub    $0xc,%esp
c01040ed:	ff 75 f4             	pushl  -0xc(%ebp)
c01040f0:	e8 00 f8 ff ff       	call   c01038f5 <page2kva>
c01040f5:	83 c4 10             	add    $0x10,%esp
}
c01040f8:	c9                   	leave  
c01040f9:	c3                   	ret    

c01040fa <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01040fa:	55                   	push   %ebp
c01040fb:	89 e5                	mov    %esp,%ebp
c01040fd:	83 ec 18             	sub    $0x18,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c0104100:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104105:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104108:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010410f:	77 17                	ja     c0104128 <pmm_init+0x2e>
c0104111:	ff 75 f4             	pushl  -0xc(%ebp)
c0104114:	68 28 65 10 c0       	push   $0xc0106528
c0104119:	68 16 01 00 00       	push   $0x116
c010411e:	68 4c 65 10 c0       	push   $0xc010654c
c0104123:	e8 a6 ca ff ff       	call   c0100bce <__panic>
c0104128:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010412b:	05 00 00 00 40       	add    $0x40000000,%eax
c0104130:	a3 20 bf 11 c0       	mov    %eax,0xc011bf20
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104135:	e8 fe f9 ff ff       	call   c0103b38 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010413a:	e8 ee fa ff ff       	call   c0103c2d <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c010413f:	e8 31 03 00 00       	call   c0104475 <check_alloc_page>

    check_pgdir();
c0104144:	e8 4f 03 00 00       	call   c0104498 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104149:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010414e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104151:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104158:	77 17                	ja     c0104171 <pmm_init+0x77>
c010415a:	ff 75 f0             	pushl  -0x10(%ebp)
c010415d:	68 28 65 10 c0       	push   $0xc0106528
c0104162:	68 2c 01 00 00       	push   $0x12c
c0104167:	68 4c 65 10 c0       	push   $0xc010654c
c010416c:	e8 5d ca ff ff       	call   c0100bce <__panic>
c0104171:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104174:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c010417a:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010417f:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104184:	83 ca 03             	or     $0x3,%edx
c0104187:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0104189:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010418e:	83 ec 0c             	sub    $0xc,%esp
c0104191:	6a 02                	push   $0x2
c0104193:	6a 00                	push   $0x0
c0104195:	68 00 00 00 38       	push   $0x38000000
c010419a:	68 00 00 00 c0       	push   $0xc0000000
c010419f:	50                   	push   %eax
c01041a0:	e8 2c fe ff ff       	call   c0103fd1 <boot_map_segment>
c01041a5:	83 c4 20             	add    $0x20,%esp

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01041a8:	e8 ab f8 ff ff       	call   c0103a58 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01041ad:	e8 4c 08 00 00       	call   c01049fe <check_boot_pgdir>

    print_pgdir();
c01041b2:	e8 34 0c 00 00       	call   c0104deb <print_pgdir>

}
c01041b7:	90                   	nop
c01041b8:	c9                   	leave  
c01041b9:	c3                   	ret    

c01041ba <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01041ba:	55                   	push   %ebp
c01041bb:	89 e5                	mov    %esp,%ebp
c01041bd:	83 ec 28             	sub    $0x28,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c01041c0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01041c3:	c1 e8 16             	shr    $0x16,%eax
c01041c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01041cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01041d0:	01 d0                	add    %edx,%eax
c01041d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
c01041d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041d8:	8b 00                	mov    (%eax),%eax
c01041da:	83 e0 01             	and    $0x1,%eax
c01041dd:	85 c0                	test   %eax,%eax
c01041df:	0f 85 9f 00 00 00    	jne    c0104284 <get_pte+0xca>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
c01041e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01041e9:	74 16                	je     c0104201 <get_pte+0x47>
c01041eb:	83 ec 0c             	sub    $0xc,%esp
c01041ee:	6a 01                	push   $0x1
c01041f0:	e8 97 f9 ff ff       	call   c0103b8c <alloc_pages>
c01041f5:	83 c4 10             	add    $0x10,%esp
c01041f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01041fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01041ff:	75 0a                	jne    c010420b <get_pte+0x51>
            return NULL;
c0104201:	b8 00 00 00 00       	mov    $0x0,%eax
c0104206:	e9 ca 00 00 00       	jmp    c01042d5 <get_pte+0x11b>
        }
        set_page_ref(page, 1);
c010420b:	83 ec 08             	sub    $0x8,%esp
c010420e:	6a 01                	push   $0x1
c0104210:	ff 75 f0             	pushl  -0x10(%ebp)
c0104213:	e8 82 f7 ff ff       	call   c010399a <set_page_ref>
c0104218:	83 c4 10             	add    $0x10,%esp
        uintptr_t pa = page2pa(page);
c010421b:	83 ec 0c             	sub    $0xc,%esp
c010421e:	ff 75 f0             	pushl  -0x10(%ebp)
c0104221:	e8 75 f6 ff ff       	call   c010389b <page2pa>
c0104226:	83 c4 10             	add    $0x10,%esp
c0104229:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c010422c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010422f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104232:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104235:	c1 e8 0c             	shr    $0xc,%eax
c0104238:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010423b:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c0104240:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104243:	72 17                	jb     c010425c <get_pte+0xa2>
c0104245:	ff 75 e8             	pushl  -0x18(%ebp)
c0104248:	68 84 64 10 c0       	push   $0xc0106484
c010424d:	68 72 01 00 00       	push   $0x172
c0104252:	68 4c 65 10 c0       	push   $0xc010654c
c0104257:	e8 72 c9 ff ff       	call   c0100bce <__panic>
c010425c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010425f:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104264:	83 ec 04             	sub    $0x4,%esp
c0104267:	68 00 10 00 00       	push   $0x1000
c010426c:	6a 00                	push   $0x0
c010426e:	50                   	push   %eax
c010426f:	e8 bb 15 00 00       	call   c010582f <memset>
c0104274:	83 c4 10             	add    $0x10,%esp
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c0104277:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010427a:	83 c8 07             	or     $0x7,%eax
c010427d:	89 c2                	mov    %eax,%edx
c010427f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104282:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c0104284:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104287:	8b 00                	mov    (%eax),%eax
c0104289:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010428e:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104291:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104294:	c1 e8 0c             	shr    $0xc,%eax
c0104297:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010429a:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c010429f:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01042a2:	72 17                	jb     c01042bb <get_pte+0x101>
c01042a4:	ff 75 e0             	pushl  -0x20(%ebp)
c01042a7:	68 84 64 10 c0       	push   $0xc0106484
c01042ac:	68 75 01 00 00       	push   $0x175
c01042b1:	68 4c 65 10 c0       	push   $0xc010654c
c01042b6:	e8 13 c9 ff ff       	call   c0100bce <__panic>
c01042bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01042be:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01042c3:	89 c2                	mov    %eax,%edx
c01042c5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01042c8:	c1 e8 0c             	shr    $0xc,%eax
c01042cb:	25 ff 03 00 00       	and    $0x3ff,%eax
c01042d0:	c1 e0 02             	shl    $0x2,%eax
c01042d3:	01 d0                	add    %edx,%eax
}
c01042d5:	c9                   	leave  
c01042d6:	c3                   	ret    

c01042d7 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01042d7:	55                   	push   %ebp
c01042d8:	89 e5                	mov    %esp,%ebp
c01042da:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01042dd:	83 ec 04             	sub    $0x4,%esp
c01042e0:	6a 00                	push   $0x0
c01042e2:	ff 75 0c             	pushl  0xc(%ebp)
c01042e5:	ff 75 08             	pushl  0x8(%ebp)
c01042e8:	e8 cd fe ff ff       	call   c01041ba <get_pte>
c01042ed:	83 c4 10             	add    $0x10,%esp
c01042f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01042f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01042f7:	74 08                	je     c0104301 <get_page+0x2a>
        *ptep_store = ptep;
c01042f9:	8b 45 10             	mov    0x10(%ebp),%eax
c01042fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01042ff:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104301:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104305:	74 1f                	je     c0104326 <get_page+0x4f>
c0104307:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010430a:	8b 00                	mov    (%eax),%eax
c010430c:	83 e0 01             	and    $0x1,%eax
c010430f:	85 c0                	test   %eax,%eax
c0104311:	74 13                	je     c0104326 <get_page+0x4f>
        return pte2page(*ptep);
c0104313:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104316:	8b 00                	mov    (%eax),%eax
c0104318:	83 ec 0c             	sub    $0xc,%esp
c010431b:	50                   	push   %eax
c010431c:	e8 19 f6 ff ff       	call   c010393a <pte2page>
c0104321:	83 c4 10             	add    $0x10,%esp
c0104324:	eb 05                	jmp    c010432b <get_page+0x54>
    }
    return NULL;
c0104326:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010432b:	c9                   	leave  
c010432c:	c3                   	ret    

c010432d <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c010432d:	55                   	push   %ebp
c010432e:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
c0104330:	90                   	nop
c0104331:	5d                   	pop    %ebp
c0104332:	c3                   	ret    

c0104333 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0104333:	55                   	push   %ebp
c0104334:	89 e5                	mov    %esp,%ebp
c0104336:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104339:	83 ec 04             	sub    $0x4,%esp
c010433c:	6a 00                	push   $0x0
c010433e:	ff 75 0c             	pushl  0xc(%ebp)
c0104341:	ff 75 08             	pushl  0x8(%ebp)
c0104344:	e8 71 fe ff ff       	call   c01041ba <get_pte>
c0104349:	83 c4 10             	add    $0x10,%esp
c010434c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c010434f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104353:	74 14                	je     c0104369 <page_remove+0x36>
        page_remove_pte(pgdir, la, ptep);
c0104355:	83 ec 04             	sub    $0x4,%esp
c0104358:	ff 75 f4             	pushl  -0xc(%ebp)
c010435b:	ff 75 0c             	pushl  0xc(%ebp)
c010435e:	ff 75 08             	pushl  0x8(%ebp)
c0104361:	e8 c7 ff ff ff       	call   c010432d <page_remove_pte>
c0104366:	83 c4 10             	add    $0x10,%esp
    }
}
c0104369:	90                   	nop
c010436a:	c9                   	leave  
c010436b:	c3                   	ret    

c010436c <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c010436c:	55                   	push   %ebp
c010436d:	89 e5                	mov    %esp,%ebp
c010436f:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0104372:	83 ec 04             	sub    $0x4,%esp
c0104375:	6a 01                	push   $0x1
c0104377:	ff 75 10             	pushl  0x10(%ebp)
c010437a:	ff 75 08             	pushl  0x8(%ebp)
c010437d:	e8 38 fe ff ff       	call   c01041ba <get_pte>
c0104382:	83 c4 10             	add    $0x10,%esp
c0104385:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0104388:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010438c:	75 0a                	jne    c0104398 <page_insert+0x2c>
        return -E_NO_MEM;
c010438e:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0104393:	e9 8b 00 00 00       	jmp    c0104423 <page_insert+0xb7>
    }
    page_ref_inc(page);
c0104398:	83 ec 0c             	sub    $0xc,%esp
c010439b:	ff 75 0c             	pushl  0xc(%ebp)
c010439e:	e8 05 f6 ff ff       	call   c01039a8 <page_ref_inc>
c01043a3:	83 c4 10             	add    $0x10,%esp
    if (*ptep & PTE_P) {
c01043a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043a9:	8b 00                	mov    (%eax),%eax
c01043ab:	83 e0 01             	and    $0x1,%eax
c01043ae:	85 c0                	test   %eax,%eax
c01043b0:	74 40                	je     c01043f2 <page_insert+0x86>
        struct Page *p = pte2page(*ptep);
c01043b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043b5:	8b 00                	mov    (%eax),%eax
c01043b7:	83 ec 0c             	sub    $0xc,%esp
c01043ba:	50                   	push   %eax
c01043bb:	e8 7a f5 ff ff       	call   c010393a <pte2page>
c01043c0:	83 c4 10             	add    $0x10,%esp
c01043c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01043c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043c9:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01043cc:	75 10                	jne    c01043de <page_insert+0x72>
            page_ref_dec(page);
c01043ce:	83 ec 0c             	sub    $0xc,%esp
c01043d1:	ff 75 0c             	pushl  0xc(%ebp)
c01043d4:	e8 e6 f5 ff ff       	call   c01039bf <page_ref_dec>
c01043d9:	83 c4 10             	add    $0x10,%esp
c01043dc:	eb 14                	jmp    c01043f2 <page_insert+0x86>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01043de:	83 ec 04             	sub    $0x4,%esp
c01043e1:	ff 75 f4             	pushl  -0xc(%ebp)
c01043e4:	ff 75 10             	pushl  0x10(%ebp)
c01043e7:	ff 75 08             	pushl  0x8(%ebp)
c01043ea:	e8 3e ff ff ff       	call   c010432d <page_remove_pte>
c01043ef:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01043f2:	83 ec 0c             	sub    $0xc,%esp
c01043f5:	ff 75 0c             	pushl  0xc(%ebp)
c01043f8:	e8 9e f4 ff ff       	call   c010389b <page2pa>
c01043fd:	83 c4 10             	add    $0x10,%esp
c0104400:	0b 45 14             	or     0x14(%ebp),%eax
c0104403:	83 c8 01             	or     $0x1,%eax
c0104406:	89 c2                	mov    %eax,%edx
c0104408:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010440b:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c010440d:	83 ec 08             	sub    $0x8,%esp
c0104410:	ff 75 10             	pushl  0x10(%ebp)
c0104413:	ff 75 08             	pushl  0x8(%ebp)
c0104416:	e8 0a 00 00 00       	call   c0104425 <tlb_invalidate>
c010441b:	83 c4 10             	add    $0x10,%esp
    return 0;
c010441e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104423:	c9                   	leave  
c0104424:	c3                   	ret    

c0104425 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0104425:	55                   	push   %ebp
c0104426:	89 e5                	mov    %esp,%ebp
c0104428:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c010442b:	0f 20 d8             	mov    %cr3,%eax
c010442e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0104431:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c0104434:	8b 45 08             	mov    0x8(%ebp),%eax
c0104437:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010443a:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104441:	77 17                	ja     c010445a <tlb_invalidate+0x35>
c0104443:	ff 75 f4             	pushl  -0xc(%ebp)
c0104446:	68 28 65 10 c0       	push   $0xc0106528
c010444b:	68 cf 01 00 00       	push   $0x1cf
c0104450:	68 4c 65 10 c0       	push   $0xc010654c
c0104455:	e8 74 c7 ff ff       	call   c0100bce <__panic>
c010445a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010445d:	05 00 00 00 40       	add    $0x40000000,%eax
c0104462:	39 d0                	cmp    %edx,%eax
c0104464:	75 0c                	jne    c0104472 <tlb_invalidate+0x4d>
        invlpg((void *)la);
c0104466:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104469:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c010446c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010446f:	0f 01 38             	invlpg (%eax)
    }
}
c0104472:	90                   	nop
c0104473:	c9                   	leave  
c0104474:	c3                   	ret    

c0104475 <check_alloc_page>:

static void
check_alloc_page(void) {
c0104475:	55                   	push   %ebp
c0104476:	89 e5                	mov    %esp,%ebp
c0104478:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->check();
c010447b:	a1 1c bf 11 c0       	mov    0xc011bf1c,%eax
c0104480:	8b 40 18             	mov    0x18(%eax),%eax
c0104483:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0104485:	83 ec 0c             	sub    $0xc,%esp
c0104488:	68 ac 65 10 c0       	push   $0xc01065ac
c010448d:	e8 a5 be ff ff       	call   c0100337 <cprintf>
c0104492:	83 c4 10             	add    $0x10,%esp
}
c0104495:	90                   	nop
c0104496:	c9                   	leave  
c0104497:	c3                   	ret    

c0104498 <check_pgdir>:

static void
check_pgdir(void) {
c0104498:	55                   	push   %ebp
c0104499:	89 e5                	mov    %esp,%ebp
c010449b:	83 ec 28             	sub    $0x28,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c010449e:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c01044a3:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01044a8:	76 19                	jbe    c01044c3 <check_pgdir+0x2b>
c01044aa:	68 cb 65 10 c0       	push   $0xc01065cb
c01044af:	68 71 65 10 c0       	push   $0xc0106571
c01044b4:	68 dc 01 00 00       	push   $0x1dc
c01044b9:	68 4c 65 10 c0       	push   $0xc010654c
c01044be:	e8 0b c7 ff ff       	call   c0100bce <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01044c3:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01044c8:	85 c0                	test   %eax,%eax
c01044ca:	74 0e                	je     c01044da <check_pgdir+0x42>
c01044cc:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01044d1:	25 ff 0f 00 00       	and    $0xfff,%eax
c01044d6:	85 c0                	test   %eax,%eax
c01044d8:	74 19                	je     c01044f3 <check_pgdir+0x5b>
c01044da:	68 e8 65 10 c0       	push   $0xc01065e8
c01044df:	68 71 65 10 c0       	push   $0xc0106571
c01044e4:	68 dd 01 00 00       	push   $0x1dd
c01044e9:	68 4c 65 10 c0       	push   $0xc010654c
c01044ee:	e8 db c6 ff ff       	call   c0100bce <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01044f3:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01044f8:	83 ec 04             	sub    $0x4,%esp
c01044fb:	6a 00                	push   $0x0
c01044fd:	6a 00                	push   $0x0
c01044ff:	50                   	push   %eax
c0104500:	e8 d2 fd ff ff       	call   c01042d7 <get_page>
c0104505:	83 c4 10             	add    $0x10,%esp
c0104508:	85 c0                	test   %eax,%eax
c010450a:	74 19                	je     c0104525 <check_pgdir+0x8d>
c010450c:	68 20 66 10 c0       	push   $0xc0106620
c0104511:	68 71 65 10 c0       	push   $0xc0106571
c0104516:	68 de 01 00 00       	push   $0x1de
c010451b:	68 4c 65 10 c0       	push   $0xc010654c
c0104520:	e8 a9 c6 ff ff       	call   c0100bce <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0104525:	83 ec 0c             	sub    $0xc,%esp
c0104528:	6a 01                	push   $0x1
c010452a:	e8 5d f6 ff ff       	call   c0103b8c <alloc_pages>
c010452f:	83 c4 10             	add    $0x10,%esp
c0104532:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0104535:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010453a:	6a 00                	push   $0x0
c010453c:	6a 00                	push   $0x0
c010453e:	ff 75 f4             	pushl  -0xc(%ebp)
c0104541:	50                   	push   %eax
c0104542:	e8 25 fe ff ff       	call   c010436c <page_insert>
c0104547:	83 c4 10             	add    $0x10,%esp
c010454a:	85 c0                	test   %eax,%eax
c010454c:	74 19                	je     c0104567 <check_pgdir+0xcf>
c010454e:	68 48 66 10 c0       	push   $0xc0106648
c0104553:	68 71 65 10 c0       	push   $0xc0106571
c0104558:	68 e2 01 00 00       	push   $0x1e2
c010455d:	68 4c 65 10 c0       	push   $0xc010654c
c0104562:	e8 67 c6 ff ff       	call   c0100bce <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0104567:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010456c:	83 ec 04             	sub    $0x4,%esp
c010456f:	6a 00                	push   $0x0
c0104571:	6a 00                	push   $0x0
c0104573:	50                   	push   %eax
c0104574:	e8 41 fc ff ff       	call   c01041ba <get_pte>
c0104579:	83 c4 10             	add    $0x10,%esp
c010457c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010457f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104583:	75 19                	jne    c010459e <check_pgdir+0x106>
c0104585:	68 74 66 10 c0       	push   $0xc0106674
c010458a:	68 71 65 10 c0       	push   $0xc0106571
c010458f:	68 e5 01 00 00       	push   $0x1e5
c0104594:	68 4c 65 10 c0       	push   $0xc010654c
c0104599:	e8 30 c6 ff ff       	call   c0100bce <__panic>
    assert(pte2page(*ptep) == p1);
c010459e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045a1:	8b 00                	mov    (%eax),%eax
c01045a3:	83 ec 0c             	sub    $0xc,%esp
c01045a6:	50                   	push   %eax
c01045a7:	e8 8e f3 ff ff       	call   c010393a <pte2page>
c01045ac:	83 c4 10             	add    $0x10,%esp
c01045af:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01045b2:	74 19                	je     c01045cd <check_pgdir+0x135>
c01045b4:	68 a1 66 10 c0       	push   $0xc01066a1
c01045b9:	68 71 65 10 c0       	push   $0xc0106571
c01045be:	68 e6 01 00 00       	push   $0x1e6
c01045c3:	68 4c 65 10 c0       	push   $0xc010654c
c01045c8:	e8 01 c6 ff ff       	call   c0100bce <__panic>
    assert(page_ref(p1) == 1);
c01045cd:	83 ec 0c             	sub    $0xc,%esp
c01045d0:	ff 75 f4             	pushl  -0xc(%ebp)
c01045d3:	e8 b8 f3 ff ff       	call   c0103990 <page_ref>
c01045d8:	83 c4 10             	add    $0x10,%esp
c01045db:	83 f8 01             	cmp    $0x1,%eax
c01045de:	74 19                	je     c01045f9 <check_pgdir+0x161>
c01045e0:	68 b7 66 10 c0       	push   $0xc01066b7
c01045e5:	68 71 65 10 c0       	push   $0xc0106571
c01045ea:	68 e7 01 00 00       	push   $0x1e7
c01045ef:	68 4c 65 10 c0       	push   $0xc010654c
c01045f4:	e8 d5 c5 ff ff       	call   c0100bce <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01045f9:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01045fe:	8b 00                	mov    (%eax),%eax
c0104600:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104605:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104608:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010460b:	c1 e8 0c             	shr    $0xc,%eax
c010460e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104611:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c0104616:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104619:	72 17                	jb     c0104632 <check_pgdir+0x19a>
c010461b:	ff 75 ec             	pushl  -0x14(%ebp)
c010461e:	68 84 64 10 c0       	push   $0xc0106484
c0104623:	68 e9 01 00 00       	push   $0x1e9
c0104628:	68 4c 65 10 c0       	push   $0xc010654c
c010462d:	e8 9c c5 ff ff       	call   c0100bce <__panic>
c0104632:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104635:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010463a:	83 c0 04             	add    $0x4,%eax
c010463d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0104640:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104645:	83 ec 04             	sub    $0x4,%esp
c0104648:	6a 00                	push   $0x0
c010464a:	68 00 10 00 00       	push   $0x1000
c010464f:	50                   	push   %eax
c0104650:	e8 65 fb ff ff       	call   c01041ba <get_pte>
c0104655:	83 c4 10             	add    $0x10,%esp
c0104658:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010465b:	74 19                	je     c0104676 <check_pgdir+0x1de>
c010465d:	68 cc 66 10 c0       	push   $0xc01066cc
c0104662:	68 71 65 10 c0       	push   $0xc0106571
c0104667:	68 ea 01 00 00       	push   $0x1ea
c010466c:	68 4c 65 10 c0       	push   $0xc010654c
c0104671:	e8 58 c5 ff ff       	call   c0100bce <__panic>

    p2 = alloc_page();
c0104676:	83 ec 0c             	sub    $0xc,%esp
c0104679:	6a 01                	push   $0x1
c010467b:	e8 0c f5 ff ff       	call   c0103b8c <alloc_pages>
c0104680:	83 c4 10             	add    $0x10,%esp
c0104683:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0104686:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010468b:	6a 06                	push   $0x6
c010468d:	68 00 10 00 00       	push   $0x1000
c0104692:	ff 75 e4             	pushl  -0x1c(%ebp)
c0104695:	50                   	push   %eax
c0104696:	e8 d1 fc ff ff       	call   c010436c <page_insert>
c010469b:	83 c4 10             	add    $0x10,%esp
c010469e:	85 c0                	test   %eax,%eax
c01046a0:	74 19                	je     c01046bb <check_pgdir+0x223>
c01046a2:	68 f4 66 10 c0       	push   $0xc01066f4
c01046a7:	68 71 65 10 c0       	push   $0xc0106571
c01046ac:	68 ed 01 00 00       	push   $0x1ed
c01046b1:	68 4c 65 10 c0       	push   $0xc010654c
c01046b6:	e8 13 c5 ff ff       	call   c0100bce <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01046bb:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01046c0:	83 ec 04             	sub    $0x4,%esp
c01046c3:	6a 00                	push   $0x0
c01046c5:	68 00 10 00 00       	push   $0x1000
c01046ca:	50                   	push   %eax
c01046cb:	e8 ea fa ff ff       	call   c01041ba <get_pte>
c01046d0:	83 c4 10             	add    $0x10,%esp
c01046d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01046d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01046da:	75 19                	jne    c01046f5 <check_pgdir+0x25d>
c01046dc:	68 2c 67 10 c0       	push   $0xc010672c
c01046e1:	68 71 65 10 c0       	push   $0xc0106571
c01046e6:	68 ee 01 00 00       	push   $0x1ee
c01046eb:	68 4c 65 10 c0       	push   $0xc010654c
c01046f0:	e8 d9 c4 ff ff       	call   c0100bce <__panic>
    assert(*ptep & PTE_U);
c01046f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046f8:	8b 00                	mov    (%eax),%eax
c01046fa:	83 e0 04             	and    $0x4,%eax
c01046fd:	85 c0                	test   %eax,%eax
c01046ff:	75 19                	jne    c010471a <check_pgdir+0x282>
c0104701:	68 5c 67 10 c0       	push   $0xc010675c
c0104706:	68 71 65 10 c0       	push   $0xc0106571
c010470b:	68 ef 01 00 00       	push   $0x1ef
c0104710:	68 4c 65 10 c0       	push   $0xc010654c
c0104715:	e8 b4 c4 ff ff       	call   c0100bce <__panic>
    assert(*ptep & PTE_W);
c010471a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010471d:	8b 00                	mov    (%eax),%eax
c010471f:	83 e0 02             	and    $0x2,%eax
c0104722:	85 c0                	test   %eax,%eax
c0104724:	75 19                	jne    c010473f <check_pgdir+0x2a7>
c0104726:	68 6a 67 10 c0       	push   $0xc010676a
c010472b:	68 71 65 10 c0       	push   $0xc0106571
c0104730:	68 f0 01 00 00       	push   $0x1f0
c0104735:	68 4c 65 10 c0       	push   $0xc010654c
c010473a:	e8 8f c4 ff ff       	call   c0100bce <__panic>
    assert(boot_pgdir[0] & PTE_U);
c010473f:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104744:	8b 00                	mov    (%eax),%eax
c0104746:	83 e0 04             	and    $0x4,%eax
c0104749:	85 c0                	test   %eax,%eax
c010474b:	75 19                	jne    c0104766 <check_pgdir+0x2ce>
c010474d:	68 78 67 10 c0       	push   $0xc0106778
c0104752:	68 71 65 10 c0       	push   $0xc0106571
c0104757:	68 f1 01 00 00       	push   $0x1f1
c010475c:	68 4c 65 10 c0       	push   $0xc010654c
c0104761:	e8 68 c4 ff ff       	call   c0100bce <__panic>
    assert(page_ref(p2) == 1);
c0104766:	83 ec 0c             	sub    $0xc,%esp
c0104769:	ff 75 e4             	pushl  -0x1c(%ebp)
c010476c:	e8 1f f2 ff ff       	call   c0103990 <page_ref>
c0104771:	83 c4 10             	add    $0x10,%esp
c0104774:	83 f8 01             	cmp    $0x1,%eax
c0104777:	74 19                	je     c0104792 <check_pgdir+0x2fa>
c0104779:	68 8e 67 10 c0       	push   $0xc010678e
c010477e:	68 71 65 10 c0       	push   $0xc0106571
c0104783:	68 f2 01 00 00       	push   $0x1f2
c0104788:	68 4c 65 10 c0       	push   $0xc010654c
c010478d:	e8 3c c4 ff ff       	call   c0100bce <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104792:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104797:	6a 00                	push   $0x0
c0104799:	68 00 10 00 00       	push   $0x1000
c010479e:	ff 75 f4             	pushl  -0xc(%ebp)
c01047a1:	50                   	push   %eax
c01047a2:	e8 c5 fb ff ff       	call   c010436c <page_insert>
c01047a7:	83 c4 10             	add    $0x10,%esp
c01047aa:	85 c0                	test   %eax,%eax
c01047ac:	74 19                	je     c01047c7 <check_pgdir+0x32f>
c01047ae:	68 a0 67 10 c0       	push   $0xc01067a0
c01047b3:	68 71 65 10 c0       	push   $0xc0106571
c01047b8:	68 f4 01 00 00       	push   $0x1f4
c01047bd:	68 4c 65 10 c0       	push   $0xc010654c
c01047c2:	e8 07 c4 ff ff       	call   c0100bce <__panic>
    assert(page_ref(p1) == 2);
c01047c7:	83 ec 0c             	sub    $0xc,%esp
c01047ca:	ff 75 f4             	pushl  -0xc(%ebp)
c01047cd:	e8 be f1 ff ff       	call   c0103990 <page_ref>
c01047d2:	83 c4 10             	add    $0x10,%esp
c01047d5:	83 f8 02             	cmp    $0x2,%eax
c01047d8:	74 19                	je     c01047f3 <check_pgdir+0x35b>
c01047da:	68 cc 67 10 c0       	push   $0xc01067cc
c01047df:	68 71 65 10 c0       	push   $0xc0106571
c01047e4:	68 f5 01 00 00       	push   $0x1f5
c01047e9:	68 4c 65 10 c0       	push   $0xc010654c
c01047ee:	e8 db c3 ff ff       	call   c0100bce <__panic>
    assert(page_ref(p2) == 0);
c01047f3:	83 ec 0c             	sub    $0xc,%esp
c01047f6:	ff 75 e4             	pushl  -0x1c(%ebp)
c01047f9:	e8 92 f1 ff ff       	call   c0103990 <page_ref>
c01047fe:	83 c4 10             	add    $0x10,%esp
c0104801:	85 c0                	test   %eax,%eax
c0104803:	74 19                	je     c010481e <check_pgdir+0x386>
c0104805:	68 de 67 10 c0       	push   $0xc01067de
c010480a:	68 71 65 10 c0       	push   $0xc0106571
c010480f:	68 f6 01 00 00       	push   $0x1f6
c0104814:	68 4c 65 10 c0       	push   $0xc010654c
c0104819:	e8 b0 c3 ff ff       	call   c0100bce <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c010481e:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104823:	83 ec 04             	sub    $0x4,%esp
c0104826:	6a 00                	push   $0x0
c0104828:	68 00 10 00 00       	push   $0x1000
c010482d:	50                   	push   %eax
c010482e:	e8 87 f9 ff ff       	call   c01041ba <get_pte>
c0104833:	83 c4 10             	add    $0x10,%esp
c0104836:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104839:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010483d:	75 19                	jne    c0104858 <check_pgdir+0x3c0>
c010483f:	68 2c 67 10 c0       	push   $0xc010672c
c0104844:	68 71 65 10 c0       	push   $0xc0106571
c0104849:	68 f7 01 00 00       	push   $0x1f7
c010484e:	68 4c 65 10 c0       	push   $0xc010654c
c0104853:	e8 76 c3 ff ff       	call   c0100bce <__panic>
    assert(pte2page(*ptep) == p1);
c0104858:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010485b:	8b 00                	mov    (%eax),%eax
c010485d:	83 ec 0c             	sub    $0xc,%esp
c0104860:	50                   	push   %eax
c0104861:	e8 d4 f0 ff ff       	call   c010393a <pte2page>
c0104866:	83 c4 10             	add    $0x10,%esp
c0104869:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010486c:	74 19                	je     c0104887 <check_pgdir+0x3ef>
c010486e:	68 a1 66 10 c0       	push   $0xc01066a1
c0104873:	68 71 65 10 c0       	push   $0xc0106571
c0104878:	68 f8 01 00 00       	push   $0x1f8
c010487d:	68 4c 65 10 c0       	push   $0xc010654c
c0104882:	e8 47 c3 ff ff       	call   c0100bce <__panic>
    assert((*ptep & PTE_U) == 0);
c0104887:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010488a:	8b 00                	mov    (%eax),%eax
c010488c:	83 e0 04             	and    $0x4,%eax
c010488f:	85 c0                	test   %eax,%eax
c0104891:	74 19                	je     c01048ac <check_pgdir+0x414>
c0104893:	68 f0 67 10 c0       	push   $0xc01067f0
c0104898:	68 71 65 10 c0       	push   $0xc0106571
c010489d:	68 f9 01 00 00       	push   $0x1f9
c01048a2:	68 4c 65 10 c0       	push   $0xc010654c
c01048a7:	e8 22 c3 ff ff       	call   c0100bce <__panic>

    page_remove(boot_pgdir, 0x0);
c01048ac:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01048b1:	83 ec 08             	sub    $0x8,%esp
c01048b4:	6a 00                	push   $0x0
c01048b6:	50                   	push   %eax
c01048b7:	e8 77 fa ff ff       	call   c0104333 <page_remove>
c01048bc:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
c01048bf:	83 ec 0c             	sub    $0xc,%esp
c01048c2:	ff 75 f4             	pushl  -0xc(%ebp)
c01048c5:	e8 c6 f0 ff ff       	call   c0103990 <page_ref>
c01048ca:	83 c4 10             	add    $0x10,%esp
c01048cd:	83 f8 01             	cmp    $0x1,%eax
c01048d0:	74 19                	je     c01048eb <check_pgdir+0x453>
c01048d2:	68 b7 66 10 c0       	push   $0xc01066b7
c01048d7:	68 71 65 10 c0       	push   $0xc0106571
c01048dc:	68 fc 01 00 00       	push   $0x1fc
c01048e1:	68 4c 65 10 c0       	push   $0xc010654c
c01048e6:	e8 e3 c2 ff ff       	call   c0100bce <__panic>
    assert(page_ref(p2) == 0);
c01048eb:	83 ec 0c             	sub    $0xc,%esp
c01048ee:	ff 75 e4             	pushl  -0x1c(%ebp)
c01048f1:	e8 9a f0 ff ff       	call   c0103990 <page_ref>
c01048f6:	83 c4 10             	add    $0x10,%esp
c01048f9:	85 c0                	test   %eax,%eax
c01048fb:	74 19                	je     c0104916 <check_pgdir+0x47e>
c01048fd:	68 de 67 10 c0       	push   $0xc01067de
c0104902:	68 71 65 10 c0       	push   $0xc0106571
c0104907:	68 fd 01 00 00       	push   $0x1fd
c010490c:	68 4c 65 10 c0       	push   $0xc010654c
c0104911:	e8 b8 c2 ff ff       	call   c0100bce <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104916:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010491b:	83 ec 08             	sub    $0x8,%esp
c010491e:	68 00 10 00 00       	push   $0x1000
c0104923:	50                   	push   %eax
c0104924:	e8 0a fa ff ff       	call   c0104333 <page_remove>
c0104929:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
c010492c:	83 ec 0c             	sub    $0xc,%esp
c010492f:	ff 75 f4             	pushl  -0xc(%ebp)
c0104932:	e8 59 f0 ff ff       	call   c0103990 <page_ref>
c0104937:	83 c4 10             	add    $0x10,%esp
c010493a:	85 c0                	test   %eax,%eax
c010493c:	74 19                	je     c0104957 <check_pgdir+0x4bf>
c010493e:	68 05 68 10 c0       	push   $0xc0106805
c0104943:	68 71 65 10 c0       	push   $0xc0106571
c0104948:	68 00 02 00 00       	push   $0x200
c010494d:	68 4c 65 10 c0       	push   $0xc010654c
c0104952:	e8 77 c2 ff ff       	call   c0100bce <__panic>
    assert(page_ref(p2) == 0);
c0104957:	83 ec 0c             	sub    $0xc,%esp
c010495a:	ff 75 e4             	pushl  -0x1c(%ebp)
c010495d:	e8 2e f0 ff ff       	call   c0103990 <page_ref>
c0104962:	83 c4 10             	add    $0x10,%esp
c0104965:	85 c0                	test   %eax,%eax
c0104967:	74 19                	je     c0104982 <check_pgdir+0x4ea>
c0104969:	68 de 67 10 c0       	push   $0xc01067de
c010496e:	68 71 65 10 c0       	push   $0xc0106571
c0104973:	68 01 02 00 00       	push   $0x201
c0104978:	68 4c 65 10 c0       	push   $0xc010654c
c010497d:	e8 4c c2 ff ff       	call   c0100bce <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0104982:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104987:	8b 00                	mov    (%eax),%eax
c0104989:	83 ec 0c             	sub    $0xc,%esp
c010498c:	50                   	push   %eax
c010498d:	e8 e2 ef ff ff       	call   c0103974 <pde2page>
c0104992:	83 c4 10             	add    $0x10,%esp
c0104995:	83 ec 0c             	sub    $0xc,%esp
c0104998:	50                   	push   %eax
c0104999:	e8 f2 ef ff ff       	call   c0103990 <page_ref>
c010499e:	83 c4 10             	add    $0x10,%esp
c01049a1:	83 f8 01             	cmp    $0x1,%eax
c01049a4:	74 19                	je     c01049bf <check_pgdir+0x527>
c01049a6:	68 18 68 10 c0       	push   $0xc0106818
c01049ab:	68 71 65 10 c0       	push   $0xc0106571
c01049b0:	68 03 02 00 00       	push   $0x203
c01049b5:	68 4c 65 10 c0       	push   $0xc010654c
c01049ba:	e8 0f c2 ff ff       	call   c0100bce <__panic>
    free_page(pde2page(boot_pgdir[0]));
c01049bf:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01049c4:	8b 00                	mov    (%eax),%eax
c01049c6:	83 ec 0c             	sub    $0xc,%esp
c01049c9:	50                   	push   %eax
c01049ca:	e8 a5 ef ff ff       	call   c0103974 <pde2page>
c01049cf:	83 c4 10             	add    $0x10,%esp
c01049d2:	83 ec 08             	sub    $0x8,%esp
c01049d5:	6a 01                	push   $0x1
c01049d7:	50                   	push   %eax
c01049d8:	e8 ed f1 ff ff       	call   c0103bca <free_pages>
c01049dd:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c01049e0:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01049e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c01049eb:	83 ec 0c             	sub    $0xc,%esp
c01049ee:	68 3f 68 10 c0       	push   $0xc010683f
c01049f3:	e8 3f b9 ff ff       	call   c0100337 <cprintf>
c01049f8:	83 c4 10             	add    $0x10,%esp
}
c01049fb:	90                   	nop
c01049fc:	c9                   	leave  
c01049fd:	c3                   	ret    

c01049fe <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c01049fe:	55                   	push   %ebp
c01049ff:	89 e5                	mov    %esp,%ebp
c0104a01:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104a04:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104a0b:	e9 a3 00 00 00       	jmp    c0104ab3 <check_boot_pgdir+0xb5>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a13:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a19:	c1 e8 0c             	shr    $0xc,%eax
c0104a1c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104a1f:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c0104a24:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104a27:	72 17                	jb     c0104a40 <check_boot_pgdir+0x42>
c0104a29:	ff 75 f0             	pushl  -0x10(%ebp)
c0104a2c:	68 84 64 10 c0       	push   $0xc0106484
c0104a31:	68 0f 02 00 00       	push   $0x20f
c0104a36:	68 4c 65 10 c0       	push   $0xc010654c
c0104a3b:	e8 8e c1 ff ff       	call   c0100bce <__panic>
c0104a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a43:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104a48:	89 c2                	mov    %eax,%edx
c0104a4a:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104a4f:	83 ec 04             	sub    $0x4,%esp
c0104a52:	6a 00                	push   $0x0
c0104a54:	52                   	push   %edx
c0104a55:	50                   	push   %eax
c0104a56:	e8 5f f7 ff ff       	call   c01041ba <get_pte>
c0104a5b:	83 c4 10             	add    $0x10,%esp
c0104a5e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104a61:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104a65:	75 19                	jne    c0104a80 <check_boot_pgdir+0x82>
c0104a67:	68 5c 68 10 c0       	push   $0xc010685c
c0104a6c:	68 71 65 10 c0       	push   $0xc0106571
c0104a71:	68 0f 02 00 00       	push   $0x20f
c0104a76:	68 4c 65 10 c0       	push   $0xc010654c
c0104a7b:	e8 4e c1 ff ff       	call   c0100bce <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104a80:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104a83:	8b 00                	mov    (%eax),%eax
c0104a85:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104a8a:	89 c2                	mov    %eax,%edx
c0104a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a8f:	39 c2                	cmp    %eax,%edx
c0104a91:	74 19                	je     c0104aac <check_boot_pgdir+0xae>
c0104a93:	68 99 68 10 c0       	push   $0xc0106899
c0104a98:	68 71 65 10 c0       	push   $0xc0106571
c0104a9d:	68 10 02 00 00       	push   $0x210
c0104aa2:	68 4c 65 10 c0       	push   $0xc010654c
c0104aa7:	e8 22 c1 ff ff       	call   c0100bce <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c0104aac:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104ab3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104ab6:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c0104abb:	39 c2                	cmp    %eax,%edx
c0104abd:	0f 82 4d ff ff ff    	jb     c0104a10 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104ac3:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104ac8:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104acd:	8b 00                	mov    (%eax),%eax
c0104acf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104ad4:	89 c2                	mov    %eax,%edx
c0104ad6:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104adb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104ade:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0104ae5:	77 17                	ja     c0104afe <check_boot_pgdir+0x100>
c0104ae7:	ff 75 e4             	pushl  -0x1c(%ebp)
c0104aea:	68 28 65 10 c0       	push   $0xc0106528
c0104aef:	68 13 02 00 00       	push   $0x213
c0104af4:	68 4c 65 10 c0       	push   $0xc010654c
c0104af9:	e8 d0 c0 ff ff       	call   c0100bce <__panic>
c0104afe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b01:	05 00 00 00 40       	add    $0x40000000,%eax
c0104b06:	39 d0                	cmp    %edx,%eax
c0104b08:	74 19                	je     c0104b23 <check_boot_pgdir+0x125>
c0104b0a:	68 b0 68 10 c0       	push   $0xc01068b0
c0104b0f:	68 71 65 10 c0       	push   $0xc0106571
c0104b14:	68 13 02 00 00       	push   $0x213
c0104b19:	68 4c 65 10 c0       	push   $0xc010654c
c0104b1e:	e8 ab c0 ff ff       	call   c0100bce <__panic>

    assert(boot_pgdir[0] == 0);
c0104b23:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104b28:	8b 00                	mov    (%eax),%eax
c0104b2a:	85 c0                	test   %eax,%eax
c0104b2c:	74 19                	je     c0104b47 <check_boot_pgdir+0x149>
c0104b2e:	68 e4 68 10 c0       	push   $0xc01068e4
c0104b33:	68 71 65 10 c0       	push   $0xc0106571
c0104b38:	68 15 02 00 00       	push   $0x215
c0104b3d:	68 4c 65 10 c0       	push   $0xc010654c
c0104b42:	e8 87 c0 ff ff       	call   c0100bce <__panic>

    struct Page *p;
    p = alloc_page();
c0104b47:	83 ec 0c             	sub    $0xc,%esp
c0104b4a:	6a 01                	push   $0x1
c0104b4c:	e8 3b f0 ff ff       	call   c0103b8c <alloc_pages>
c0104b51:	83 c4 10             	add    $0x10,%esp
c0104b54:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0104b57:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104b5c:	6a 02                	push   $0x2
c0104b5e:	68 00 01 00 00       	push   $0x100
c0104b63:	ff 75 e0             	pushl  -0x20(%ebp)
c0104b66:	50                   	push   %eax
c0104b67:	e8 00 f8 ff ff       	call   c010436c <page_insert>
c0104b6c:	83 c4 10             	add    $0x10,%esp
c0104b6f:	85 c0                	test   %eax,%eax
c0104b71:	74 19                	je     c0104b8c <check_boot_pgdir+0x18e>
c0104b73:	68 f8 68 10 c0       	push   $0xc01068f8
c0104b78:	68 71 65 10 c0       	push   $0xc0106571
c0104b7d:	68 19 02 00 00       	push   $0x219
c0104b82:	68 4c 65 10 c0       	push   $0xc010654c
c0104b87:	e8 42 c0 ff ff       	call   c0100bce <__panic>
    assert(page_ref(p) == 1);
c0104b8c:	83 ec 0c             	sub    $0xc,%esp
c0104b8f:	ff 75 e0             	pushl  -0x20(%ebp)
c0104b92:	e8 f9 ed ff ff       	call   c0103990 <page_ref>
c0104b97:	83 c4 10             	add    $0x10,%esp
c0104b9a:	83 f8 01             	cmp    $0x1,%eax
c0104b9d:	74 19                	je     c0104bb8 <check_boot_pgdir+0x1ba>
c0104b9f:	68 26 69 10 c0       	push   $0xc0106926
c0104ba4:	68 71 65 10 c0       	push   $0xc0106571
c0104ba9:	68 1a 02 00 00       	push   $0x21a
c0104bae:	68 4c 65 10 c0       	push   $0xc010654c
c0104bb3:	e8 16 c0 ff ff       	call   c0100bce <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0104bb8:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104bbd:	6a 02                	push   $0x2
c0104bbf:	68 00 11 00 00       	push   $0x1100
c0104bc4:	ff 75 e0             	pushl  -0x20(%ebp)
c0104bc7:	50                   	push   %eax
c0104bc8:	e8 9f f7 ff ff       	call   c010436c <page_insert>
c0104bcd:	83 c4 10             	add    $0x10,%esp
c0104bd0:	85 c0                	test   %eax,%eax
c0104bd2:	74 19                	je     c0104bed <check_boot_pgdir+0x1ef>
c0104bd4:	68 38 69 10 c0       	push   $0xc0106938
c0104bd9:	68 71 65 10 c0       	push   $0xc0106571
c0104bde:	68 1b 02 00 00       	push   $0x21b
c0104be3:	68 4c 65 10 c0       	push   $0xc010654c
c0104be8:	e8 e1 bf ff ff       	call   c0100bce <__panic>
    assert(page_ref(p) == 2);
c0104bed:	83 ec 0c             	sub    $0xc,%esp
c0104bf0:	ff 75 e0             	pushl  -0x20(%ebp)
c0104bf3:	e8 98 ed ff ff       	call   c0103990 <page_ref>
c0104bf8:	83 c4 10             	add    $0x10,%esp
c0104bfb:	83 f8 02             	cmp    $0x2,%eax
c0104bfe:	74 19                	je     c0104c19 <check_boot_pgdir+0x21b>
c0104c00:	68 6f 69 10 c0       	push   $0xc010696f
c0104c05:	68 71 65 10 c0       	push   $0xc0106571
c0104c0a:	68 1c 02 00 00       	push   $0x21c
c0104c0f:	68 4c 65 10 c0       	push   $0xc010654c
c0104c14:	e8 b5 bf ff ff       	call   c0100bce <__panic>

    const char *str = "ucore: Hello world!!";
c0104c19:	c7 45 dc 80 69 10 c0 	movl   $0xc0106980,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0104c20:	83 ec 08             	sub    $0x8,%esp
c0104c23:	ff 75 dc             	pushl  -0x24(%ebp)
c0104c26:	68 00 01 00 00       	push   $0x100
c0104c2b:	e8 50 09 00 00       	call   c0105580 <strcpy>
c0104c30:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0104c33:	83 ec 08             	sub    $0x8,%esp
c0104c36:	68 00 11 00 00       	push   $0x1100
c0104c3b:	68 00 01 00 00       	push   $0x100
c0104c40:	e8 b0 09 00 00       	call   c01055f5 <strcmp>
c0104c45:	83 c4 10             	add    $0x10,%esp
c0104c48:	85 c0                	test   %eax,%eax
c0104c4a:	74 19                	je     c0104c65 <check_boot_pgdir+0x267>
c0104c4c:	68 98 69 10 c0       	push   $0xc0106998
c0104c51:	68 71 65 10 c0       	push   $0xc0106571
c0104c56:	68 20 02 00 00       	push   $0x220
c0104c5b:	68 4c 65 10 c0       	push   $0xc010654c
c0104c60:	e8 69 bf ff ff       	call   c0100bce <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0104c65:	83 ec 0c             	sub    $0xc,%esp
c0104c68:	ff 75 e0             	pushl  -0x20(%ebp)
c0104c6b:	e8 85 ec ff ff       	call   c01038f5 <page2kva>
c0104c70:	83 c4 10             	add    $0x10,%esp
c0104c73:	05 00 01 00 00       	add    $0x100,%eax
c0104c78:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0104c7b:	83 ec 0c             	sub    $0xc,%esp
c0104c7e:	68 00 01 00 00       	push   $0x100
c0104c83:	e8 a4 08 00 00       	call   c010552c <strlen>
c0104c88:	83 c4 10             	add    $0x10,%esp
c0104c8b:	85 c0                	test   %eax,%eax
c0104c8d:	74 19                	je     c0104ca8 <check_boot_pgdir+0x2aa>
c0104c8f:	68 d0 69 10 c0       	push   $0xc01069d0
c0104c94:	68 71 65 10 c0       	push   $0xc0106571
c0104c99:	68 23 02 00 00       	push   $0x223
c0104c9e:	68 4c 65 10 c0       	push   $0xc010654c
c0104ca3:	e8 26 bf ff ff       	call   c0100bce <__panic>

    free_page(p);
c0104ca8:	83 ec 08             	sub    $0x8,%esp
c0104cab:	6a 01                	push   $0x1
c0104cad:	ff 75 e0             	pushl  -0x20(%ebp)
c0104cb0:	e8 15 ef ff ff       	call   c0103bca <free_pages>
c0104cb5:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(boot_pgdir[0]));
c0104cb8:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104cbd:	8b 00                	mov    (%eax),%eax
c0104cbf:	83 ec 0c             	sub    $0xc,%esp
c0104cc2:	50                   	push   %eax
c0104cc3:	e8 ac ec ff ff       	call   c0103974 <pde2page>
c0104cc8:	83 c4 10             	add    $0x10,%esp
c0104ccb:	83 ec 08             	sub    $0x8,%esp
c0104cce:	6a 01                	push   $0x1
c0104cd0:	50                   	push   %eax
c0104cd1:	e8 f4 ee ff ff       	call   c0103bca <free_pages>
c0104cd6:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0104cd9:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104cde:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0104ce4:	83 ec 0c             	sub    $0xc,%esp
c0104ce7:	68 f4 69 10 c0       	push   $0xc01069f4
c0104cec:	e8 46 b6 ff ff       	call   c0100337 <cprintf>
c0104cf1:	83 c4 10             	add    $0x10,%esp
}
c0104cf4:	90                   	nop
c0104cf5:	c9                   	leave  
c0104cf6:	c3                   	ret    

c0104cf7 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0104cf7:	55                   	push   %ebp
c0104cf8:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0104cfa:	8b 45 08             	mov    0x8(%ebp),%eax
c0104cfd:	83 e0 04             	and    $0x4,%eax
c0104d00:	85 c0                	test   %eax,%eax
c0104d02:	74 04                	je     c0104d08 <perm2str+0x11>
c0104d04:	b0 75                	mov    $0x75,%al
c0104d06:	eb 02                	jmp    c0104d0a <perm2str+0x13>
c0104d08:	b0 2d                	mov    $0x2d,%al
c0104d0a:	a2 08 bf 11 c0       	mov    %al,0xc011bf08
    str[1] = 'r';
c0104d0f:	c6 05 09 bf 11 c0 72 	movb   $0x72,0xc011bf09
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0104d16:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d19:	83 e0 02             	and    $0x2,%eax
c0104d1c:	85 c0                	test   %eax,%eax
c0104d1e:	74 04                	je     c0104d24 <perm2str+0x2d>
c0104d20:	b0 77                	mov    $0x77,%al
c0104d22:	eb 02                	jmp    c0104d26 <perm2str+0x2f>
c0104d24:	b0 2d                	mov    $0x2d,%al
c0104d26:	a2 0a bf 11 c0       	mov    %al,0xc011bf0a
    str[3] = '\0';
c0104d2b:	c6 05 0b bf 11 c0 00 	movb   $0x0,0xc011bf0b
    return str;
c0104d32:	b8 08 bf 11 c0       	mov    $0xc011bf08,%eax
}
c0104d37:	5d                   	pop    %ebp
c0104d38:	c3                   	ret    

c0104d39 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0104d39:	55                   	push   %ebp
c0104d3a:	89 e5                	mov    %esp,%ebp
c0104d3c:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0104d3f:	8b 45 10             	mov    0x10(%ebp),%eax
c0104d42:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104d45:	72 0d                	jb     c0104d54 <get_pgtable_items+0x1b>
        return 0;
c0104d47:	b8 00 00 00 00       	mov    $0x0,%eax
c0104d4c:	e9 98 00 00 00       	jmp    c0104de9 <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0104d51:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c0104d54:	8b 45 10             	mov    0x10(%ebp),%eax
c0104d57:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104d5a:	73 18                	jae    c0104d74 <get_pgtable_items+0x3b>
c0104d5c:	8b 45 10             	mov    0x10(%ebp),%eax
c0104d5f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104d66:	8b 45 14             	mov    0x14(%ebp),%eax
c0104d69:	01 d0                	add    %edx,%eax
c0104d6b:	8b 00                	mov    (%eax),%eax
c0104d6d:	83 e0 01             	and    $0x1,%eax
c0104d70:	85 c0                	test   %eax,%eax
c0104d72:	74 dd                	je     c0104d51 <get_pgtable_items+0x18>
    }
    if (start < right) {
c0104d74:	8b 45 10             	mov    0x10(%ebp),%eax
c0104d77:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104d7a:	73 68                	jae    c0104de4 <get_pgtable_items+0xab>
        if (left_store != NULL) {
c0104d7c:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0104d80:	74 08                	je     c0104d8a <get_pgtable_items+0x51>
            *left_store = start;
c0104d82:	8b 45 18             	mov    0x18(%ebp),%eax
c0104d85:	8b 55 10             	mov    0x10(%ebp),%edx
c0104d88:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0104d8a:	8b 45 10             	mov    0x10(%ebp),%eax
c0104d8d:	8d 50 01             	lea    0x1(%eax),%edx
c0104d90:	89 55 10             	mov    %edx,0x10(%ebp)
c0104d93:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104d9a:	8b 45 14             	mov    0x14(%ebp),%eax
c0104d9d:	01 d0                	add    %edx,%eax
c0104d9f:	8b 00                	mov    (%eax),%eax
c0104da1:	83 e0 07             	and    $0x7,%eax
c0104da4:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0104da7:	eb 03                	jmp    c0104dac <get_pgtable_items+0x73>
            start ++;
c0104da9:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0104dac:	8b 45 10             	mov    0x10(%ebp),%eax
c0104daf:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104db2:	73 1d                	jae    c0104dd1 <get_pgtable_items+0x98>
c0104db4:	8b 45 10             	mov    0x10(%ebp),%eax
c0104db7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104dbe:	8b 45 14             	mov    0x14(%ebp),%eax
c0104dc1:	01 d0                	add    %edx,%eax
c0104dc3:	8b 00                	mov    (%eax),%eax
c0104dc5:	83 e0 07             	and    $0x7,%eax
c0104dc8:	89 c2                	mov    %eax,%edx
c0104dca:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104dcd:	39 c2                	cmp    %eax,%edx
c0104dcf:	74 d8                	je     c0104da9 <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
c0104dd1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0104dd5:	74 08                	je     c0104ddf <get_pgtable_items+0xa6>
            *right_store = start;
c0104dd7:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0104dda:	8b 55 10             	mov    0x10(%ebp),%edx
c0104ddd:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0104ddf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104de2:	eb 05                	jmp    c0104de9 <get_pgtable_items+0xb0>
    }
    return 0;
c0104de4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104de9:	c9                   	leave  
c0104dea:	c3                   	ret    

c0104deb <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0104deb:	55                   	push   %ebp
c0104dec:	89 e5                	mov    %esp,%ebp
c0104dee:	57                   	push   %edi
c0104def:	56                   	push   %esi
c0104df0:	53                   	push   %ebx
c0104df1:	83 ec 2c             	sub    $0x2c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0104df4:	83 ec 0c             	sub    $0xc,%esp
c0104df7:	68 14 6a 10 c0       	push   $0xc0106a14
c0104dfc:	e8 36 b5 ff ff       	call   c0100337 <cprintf>
c0104e01:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
c0104e04:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104e0b:	e9 e1 00 00 00       	jmp    c0104ef1 <print_pgdir+0x106>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104e10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e13:	83 ec 0c             	sub    $0xc,%esp
c0104e16:	50                   	push   %eax
c0104e17:	e8 db fe ff ff       	call   c0104cf7 <perm2str>
c0104e1c:	83 c4 10             	add    $0x10,%esp
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0104e1f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0104e22:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104e25:	29 d1                	sub    %edx,%ecx
c0104e27:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104e29:	89 d6                	mov    %edx,%esi
c0104e2b:	c1 e6 16             	shl    $0x16,%esi
c0104e2e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104e31:	89 d3                	mov    %edx,%ebx
c0104e33:	c1 e3 16             	shl    $0x16,%ebx
c0104e36:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104e39:	89 d1                	mov    %edx,%ecx
c0104e3b:	c1 e1 16             	shl    $0x16,%ecx
c0104e3e:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0104e41:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104e44:	29 d7                	sub    %edx,%edi
c0104e46:	89 fa                	mov    %edi,%edx
c0104e48:	83 ec 08             	sub    $0x8,%esp
c0104e4b:	50                   	push   %eax
c0104e4c:	56                   	push   %esi
c0104e4d:	53                   	push   %ebx
c0104e4e:	51                   	push   %ecx
c0104e4f:	52                   	push   %edx
c0104e50:	68 45 6a 10 c0       	push   $0xc0106a45
c0104e55:	e8 dd b4 ff ff       	call   c0100337 <cprintf>
c0104e5a:	83 c4 20             	add    $0x20,%esp
        size_t l, r = left * NPTEENTRY;
c0104e5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104e60:	c1 e0 0a             	shl    $0xa,%eax
c0104e63:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0104e66:	eb 4d                	jmp    c0104eb5 <print_pgdir+0xca>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104e68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e6b:	83 ec 0c             	sub    $0xc,%esp
c0104e6e:	50                   	push   %eax
c0104e6f:	e8 83 fe ff ff       	call   c0104cf7 <perm2str>
c0104e74:	83 c4 10             	add    $0x10,%esp
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0104e77:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0104e7a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104e7d:	29 d1                	sub    %edx,%ecx
c0104e7f:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104e81:	89 d6                	mov    %edx,%esi
c0104e83:	c1 e6 0c             	shl    $0xc,%esi
c0104e86:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104e89:	89 d3                	mov    %edx,%ebx
c0104e8b:	c1 e3 0c             	shl    $0xc,%ebx
c0104e8e:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104e91:	89 d1                	mov    %edx,%ecx
c0104e93:	c1 e1 0c             	shl    $0xc,%ecx
c0104e96:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0104e99:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104e9c:	29 d7                	sub    %edx,%edi
c0104e9e:	89 fa                	mov    %edi,%edx
c0104ea0:	83 ec 08             	sub    $0x8,%esp
c0104ea3:	50                   	push   %eax
c0104ea4:	56                   	push   %esi
c0104ea5:	53                   	push   %ebx
c0104ea6:	51                   	push   %ecx
c0104ea7:	52                   	push   %edx
c0104ea8:	68 64 6a 10 c0       	push   $0xc0106a64
c0104ead:	e8 85 b4 ff ff       	call   c0100337 <cprintf>
c0104eb2:	83 c4 20             	add    $0x20,%esp
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0104eb5:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0104eba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104ebd:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104ec0:	89 d3                	mov    %edx,%ebx
c0104ec2:	c1 e3 0a             	shl    $0xa,%ebx
c0104ec5:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104ec8:	89 d1                	mov    %edx,%ecx
c0104eca:	c1 e1 0a             	shl    $0xa,%ecx
c0104ecd:	83 ec 08             	sub    $0x8,%esp
c0104ed0:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c0104ed3:	52                   	push   %edx
c0104ed4:	8d 55 d8             	lea    -0x28(%ebp),%edx
c0104ed7:	52                   	push   %edx
c0104ed8:	56                   	push   %esi
c0104ed9:	50                   	push   %eax
c0104eda:	53                   	push   %ebx
c0104edb:	51                   	push   %ecx
c0104edc:	e8 58 fe ff ff       	call   c0104d39 <get_pgtable_items>
c0104ee1:	83 c4 20             	add    $0x20,%esp
c0104ee4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104ee7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104eeb:	0f 85 77 ff ff ff    	jne    c0104e68 <print_pgdir+0x7d>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104ef1:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c0104ef6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104ef9:	83 ec 08             	sub    $0x8,%esp
c0104efc:	8d 55 dc             	lea    -0x24(%ebp),%edx
c0104eff:	52                   	push   %edx
c0104f00:	8d 55 e0             	lea    -0x20(%ebp),%edx
c0104f03:	52                   	push   %edx
c0104f04:	51                   	push   %ecx
c0104f05:	50                   	push   %eax
c0104f06:	68 00 04 00 00       	push   $0x400
c0104f0b:	6a 00                	push   $0x0
c0104f0d:	e8 27 fe ff ff       	call   c0104d39 <get_pgtable_items>
c0104f12:	83 c4 20             	add    $0x20,%esp
c0104f15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104f18:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104f1c:	0f 85 ee fe ff ff    	jne    c0104e10 <print_pgdir+0x25>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0104f22:	83 ec 0c             	sub    $0xc,%esp
c0104f25:	68 88 6a 10 c0       	push   $0xc0106a88
c0104f2a:	e8 08 b4 ff ff       	call   c0100337 <cprintf>
c0104f2f:	83 c4 10             	add    $0x10,%esp
}
c0104f32:	90                   	nop
c0104f33:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0104f36:	5b                   	pop    %ebx
c0104f37:	5e                   	pop    %esi
c0104f38:	5f                   	pop    %edi
c0104f39:	5d                   	pop    %ebp
c0104f3a:	c3                   	ret    

c0104f3b <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0104f3b:	55                   	push   %ebp
c0104f3c:	89 e5                	mov    %esp,%ebp
c0104f3e:	83 ec 38             	sub    $0x38,%esp
c0104f41:	8b 45 10             	mov    0x10(%ebp),%eax
c0104f44:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104f47:	8b 45 14             	mov    0x14(%ebp),%eax
c0104f4a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0104f4d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104f50:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104f53:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104f56:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0104f59:	8b 45 18             	mov    0x18(%ebp),%eax
c0104f5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104f5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104f62:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104f65:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104f68:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0104f6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104f71:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104f75:	74 1c                	je     c0104f93 <printnum+0x58>
c0104f77:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f7a:	ba 00 00 00 00       	mov    $0x0,%edx
c0104f7f:	f7 75 e4             	divl   -0x1c(%ebp)
c0104f82:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0104f85:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f88:	ba 00 00 00 00       	mov    $0x0,%edx
c0104f8d:	f7 75 e4             	divl   -0x1c(%ebp)
c0104f90:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104f93:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104f96:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104f99:	f7 75 e4             	divl   -0x1c(%ebp)
c0104f9c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104f9f:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0104fa2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104fa5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104fa8:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104fab:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0104fae:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104fb1:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0104fb4:	8b 45 18             	mov    0x18(%ebp),%eax
c0104fb7:	ba 00 00 00 00       	mov    $0x0,%edx
c0104fbc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0104fbf:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0104fc2:	19 d1                	sbb    %edx,%ecx
c0104fc4:	72 35                	jb     c0104ffb <printnum+0xc0>
        printnum(putch, putdat, result, base, width - 1, padc);
c0104fc6:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0104fc9:	48                   	dec    %eax
c0104fca:	83 ec 04             	sub    $0x4,%esp
c0104fcd:	ff 75 20             	pushl  0x20(%ebp)
c0104fd0:	50                   	push   %eax
c0104fd1:	ff 75 18             	pushl  0x18(%ebp)
c0104fd4:	ff 75 ec             	pushl  -0x14(%ebp)
c0104fd7:	ff 75 e8             	pushl  -0x18(%ebp)
c0104fda:	ff 75 0c             	pushl  0xc(%ebp)
c0104fdd:	ff 75 08             	pushl  0x8(%ebp)
c0104fe0:	e8 56 ff ff ff       	call   c0104f3b <printnum>
c0104fe5:	83 c4 20             	add    $0x20,%esp
c0104fe8:	eb 1a                	jmp    c0105004 <printnum+0xc9>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0104fea:	83 ec 08             	sub    $0x8,%esp
c0104fed:	ff 75 0c             	pushl  0xc(%ebp)
c0104ff0:	ff 75 20             	pushl  0x20(%ebp)
c0104ff3:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ff6:	ff d0                	call   *%eax
c0104ff8:	83 c4 10             	add    $0x10,%esp
        while (-- width > 0)
c0104ffb:	ff 4d 1c             	decl   0x1c(%ebp)
c0104ffe:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105002:	7f e6                	jg     c0104fea <printnum+0xaf>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0105004:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105007:	05 3c 6b 10 c0       	add    $0xc0106b3c,%eax
c010500c:	8a 00                	mov    (%eax),%al
c010500e:	0f be c0             	movsbl %al,%eax
c0105011:	83 ec 08             	sub    $0x8,%esp
c0105014:	ff 75 0c             	pushl  0xc(%ebp)
c0105017:	50                   	push   %eax
c0105018:	8b 45 08             	mov    0x8(%ebp),%eax
c010501b:	ff d0                	call   *%eax
c010501d:	83 c4 10             	add    $0x10,%esp
}
c0105020:	90                   	nop
c0105021:	c9                   	leave  
c0105022:	c3                   	ret    

c0105023 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105023:	55                   	push   %ebp
c0105024:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105026:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010502a:	7e 14                	jle    c0105040 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c010502c:	8b 45 08             	mov    0x8(%ebp),%eax
c010502f:	8b 00                	mov    (%eax),%eax
c0105031:	8d 48 08             	lea    0x8(%eax),%ecx
c0105034:	8b 55 08             	mov    0x8(%ebp),%edx
c0105037:	89 0a                	mov    %ecx,(%edx)
c0105039:	8b 50 04             	mov    0x4(%eax),%edx
c010503c:	8b 00                	mov    (%eax),%eax
c010503e:	eb 30                	jmp    c0105070 <getuint+0x4d>
    }
    else if (lflag) {
c0105040:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105044:	74 16                	je     c010505c <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0105046:	8b 45 08             	mov    0x8(%ebp),%eax
c0105049:	8b 00                	mov    (%eax),%eax
c010504b:	8d 48 04             	lea    0x4(%eax),%ecx
c010504e:	8b 55 08             	mov    0x8(%ebp),%edx
c0105051:	89 0a                	mov    %ecx,(%edx)
c0105053:	8b 00                	mov    (%eax),%eax
c0105055:	ba 00 00 00 00       	mov    $0x0,%edx
c010505a:	eb 14                	jmp    c0105070 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c010505c:	8b 45 08             	mov    0x8(%ebp),%eax
c010505f:	8b 00                	mov    (%eax),%eax
c0105061:	8d 48 04             	lea    0x4(%eax),%ecx
c0105064:	8b 55 08             	mov    0x8(%ebp),%edx
c0105067:	89 0a                	mov    %ecx,(%edx)
c0105069:	8b 00                	mov    (%eax),%eax
c010506b:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105070:	5d                   	pop    %ebp
c0105071:	c3                   	ret    

c0105072 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0105072:	55                   	push   %ebp
c0105073:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105075:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105079:	7e 14                	jle    c010508f <getint+0x1d>
        return va_arg(*ap, long long);
c010507b:	8b 45 08             	mov    0x8(%ebp),%eax
c010507e:	8b 00                	mov    (%eax),%eax
c0105080:	8d 48 08             	lea    0x8(%eax),%ecx
c0105083:	8b 55 08             	mov    0x8(%ebp),%edx
c0105086:	89 0a                	mov    %ecx,(%edx)
c0105088:	8b 50 04             	mov    0x4(%eax),%edx
c010508b:	8b 00                	mov    (%eax),%eax
c010508d:	eb 28                	jmp    c01050b7 <getint+0x45>
    }
    else if (lflag) {
c010508f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105093:	74 12                	je     c01050a7 <getint+0x35>
        return va_arg(*ap, long);
c0105095:	8b 45 08             	mov    0x8(%ebp),%eax
c0105098:	8b 00                	mov    (%eax),%eax
c010509a:	8d 48 04             	lea    0x4(%eax),%ecx
c010509d:	8b 55 08             	mov    0x8(%ebp),%edx
c01050a0:	89 0a                	mov    %ecx,(%edx)
c01050a2:	8b 00                	mov    (%eax),%eax
c01050a4:	99                   	cltd   
c01050a5:	eb 10                	jmp    c01050b7 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01050a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01050aa:	8b 00                	mov    (%eax),%eax
c01050ac:	8d 48 04             	lea    0x4(%eax),%ecx
c01050af:	8b 55 08             	mov    0x8(%ebp),%edx
c01050b2:	89 0a                	mov    %ecx,(%edx)
c01050b4:	8b 00                	mov    (%eax),%eax
c01050b6:	99                   	cltd   
    }
}
c01050b7:	5d                   	pop    %ebp
c01050b8:	c3                   	ret    

c01050b9 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01050b9:	55                   	push   %ebp
c01050ba:	89 e5                	mov    %esp,%ebp
c01050bc:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
c01050bf:	8d 45 14             	lea    0x14(%ebp),%eax
c01050c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01050c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050c8:	50                   	push   %eax
c01050c9:	ff 75 10             	pushl  0x10(%ebp)
c01050cc:	ff 75 0c             	pushl  0xc(%ebp)
c01050cf:	ff 75 08             	pushl  0x8(%ebp)
c01050d2:	e8 06 00 00 00       	call   c01050dd <vprintfmt>
c01050d7:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c01050da:	90                   	nop
c01050db:	c9                   	leave  
c01050dc:	c3                   	ret    

c01050dd <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01050dd:	55                   	push   %ebp
c01050de:	89 e5                	mov    %esp,%ebp
c01050e0:	56                   	push   %esi
c01050e1:	53                   	push   %ebx
c01050e2:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01050e5:	eb 17                	jmp    c01050fe <vprintfmt+0x21>
            if (ch == '\0') {
c01050e7:	85 db                	test   %ebx,%ebx
c01050e9:	0f 84 7c 03 00 00    	je     c010546b <vprintfmt+0x38e>
                return;
            }
            putch(ch, putdat);
c01050ef:	83 ec 08             	sub    $0x8,%esp
c01050f2:	ff 75 0c             	pushl  0xc(%ebp)
c01050f5:	53                   	push   %ebx
c01050f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01050f9:	ff d0                	call   *%eax
c01050fb:	83 c4 10             	add    $0x10,%esp
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01050fe:	8b 45 10             	mov    0x10(%ebp),%eax
c0105101:	8d 50 01             	lea    0x1(%eax),%edx
c0105104:	89 55 10             	mov    %edx,0x10(%ebp)
c0105107:	8a 00                	mov    (%eax),%al
c0105109:	0f b6 d8             	movzbl %al,%ebx
c010510c:	83 fb 25             	cmp    $0x25,%ebx
c010510f:	75 d6                	jne    c01050e7 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105111:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105115:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c010511c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010511f:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105122:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105129:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010512c:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c010512f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105132:	8d 50 01             	lea    0x1(%eax),%edx
c0105135:	89 55 10             	mov    %edx,0x10(%ebp)
c0105138:	8a 00                	mov    (%eax),%al
c010513a:	0f b6 d8             	movzbl %al,%ebx
c010513d:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105140:	83 f8 55             	cmp    $0x55,%eax
c0105143:	0f 87 fa 02 00 00    	ja     c0105443 <vprintfmt+0x366>
c0105149:	8b 04 85 60 6b 10 c0 	mov    -0x3fef94a0(,%eax,4),%eax
c0105150:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105152:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105156:	eb d7                	jmp    c010512f <vprintfmt+0x52>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105158:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c010515c:	eb d1                	jmp    c010512f <vprintfmt+0x52>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010515e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105165:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105168:	89 d0                	mov    %edx,%eax
c010516a:	c1 e0 02             	shl    $0x2,%eax
c010516d:	01 d0                	add    %edx,%eax
c010516f:	01 c0                	add    %eax,%eax
c0105171:	01 d8                	add    %ebx,%eax
c0105173:	83 e8 30             	sub    $0x30,%eax
c0105176:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105179:	8b 45 10             	mov    0x10(%ebp),%eax
c010517c:	8a 00                	mov    (%eax),%al
c010517e:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105181:	83 fb 2f             	cmp    $0x2f,%ebx
c0105184:	7e 35                	jle    c01051bb <vprintfmt+0xde>
c0105186:	83 fb 39             	cmp    $0x39,%ebx
c0105189:	7f 30                	jg     c01051bb <vprintfmt+0xde>
            for (precision = 0; ; ++ fmt) {
c010518b:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
c010518e:	eb d5                	jmp    c0105165 <vprintfmt+0x88>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0105190:	8b 45 14             	mov    0x14(%ebp),%eax
c0105193:	8d 50 04             	lea    0x4(%eax),%edx
c0105196:	89 55 14             	mov    %edx,0x14(%ebp)
c0105199:	8b 00                	mov    (%eax),%eax
c010519b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c010519e:	eb 1c                	jmp    c01051bc <vprintfmt+0xdf>

        case '.':
            if (width < 0)
c01051a0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01051a4:	79 89                	jns    c010512f <vprintfmt+0x52>
                width = 0;
c01051a6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01051ad:	eb 80                	jmp    c010512f <vprintfmt+0x52>

        case '#':
            altflag = 1;
c01051af:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01051b6:	e9 74 ff ff ff       	jmp    c010512f <vprintfmt+0x52>
            goto process_precision;
c01051bb:	90                   	nop

        process_precision:
            if (width < 0)
c01051bc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01051c0:	0f 89 69 ff ff ff    	jns    c010512f <vprintfmt+0x52>
                width = precision, precision = -1;
c01051c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01051c9:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01051cc:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01051d3:	e9 57 ff ff ff       	jmp    c010512f <vprintfmt+0x52>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01051d8:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c01051db:	e9 4f ff ff ff       	jmp    c010512f <vprintfmt+0x52>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01051e0:	8b 45 14             	mov    0x14(%ebp),%eax
c01051e3:	8d 50 04             	lea    0x4(%eax),%edx
c01051e6:	89 55 14             	mov    %edx,0x14(%ebp)
c01051e9:	8b 00                	mov    (%eax),%eax
c01051eb:	83 ec 08             	sub    $0x8,%esp
c01051ee:	ff 75 0c             	pushl  0xc(%ebp)
c01051f1:	50                   	push   %eax
c01051f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01051f5:	ff d0                	call   *%eax
c01051f7:	83 c4 10             	add    $0x10,%esp
            break;
c01051fa:	e9 67 02 00 00       	jmp    c0105466 <vprintfmt+0x389>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01051ff:	8b 45 14             	mov    0x14(%ebp),%eax
c0105202:	8d 50 04             	lea    0x4(%eax),%edx
c0105205:	89 55 14             	mov    %edx,0x14(%ebp)
c0105208:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c010520a:	85 db                	test   %ebx,%ebx
c010520c:	79 02                	jns    c0105210 <vprintfmt+0x133>
                err = -err;
c010520e:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0105210:	83 fb 06             	cmp    $0x6,%ebx
c0105213:	7f 0b                	jg     c0105220 <vprintfmt+0x143>
c0105215:	8b 34 9d 20 6b 10 c0 	mov    -0x3fef94e0(,%ebx,4),%esi
c010521c:	85 f6                	test   %esi,%esi
c010521e:	75 19                	jne    c0105239 <vprintfmt+0x15c>
                printfmt(putch, putdat, "error %d", err);
c0105220:	53                   	push   %ebx
c0105221:	68 4d 6b 10 c0       	push   $0xc0106b4d
c0105226:	ff 75 0c             	pushl  0xc(%ebp)
c0105229:	ff 75 08             	pushl  0x8(%ebp)
c010522c:	e8 88 fe ff ff       	call   c01050b9 <printfmt>
c0105231:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105234:	e9 2d 02 00 00       	jmp    c0105466 <vprintfmt+0x389>
                printfmt(putch, putdat, "%s", p);
c0105239:	56                   	push   %esi
c010523a:	68 56 6b 10 c0       	push   $0xc0106b56
c010523f:	ff 75 0c             	pushl  0xc(%ebp)
c0105242:	ff 75 08             	pushl  0x8(%ebp)
c0105245:	e8 6f fe ff ff       	call   c01050b9 <printfmt>
c010524a:	83 c4 10             	add    $0x10,%esp
            break;
c010524d:	e9 14 02 00 00       	jmp    c0105466 <vprintfmt+0x389>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105252:	8b 45 14             	mov    0x14(%ebp),%eax
c0105255:	8d 50 04             	lea    0x4(%eax),%edx
c0105258:	89 55 14             	mov    %edx,0x14(%ebp)
c010525b:	8b 30                	mov    (%eax),%esi
c010525d:	85 f6                	test   %esi,%esi
c010525f:	75 05                	jne    c0105266 <vprintfmt+0x189>
                p = "(null)";
c0105261:	be 59 6b 10 c0       	mov    $0xc0106b59,%esi
            }
            if (width > 0 && padc != '-') {
c0105266:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010526a:	7e 74                	jle    c01052e0 <vprintfmt+0x203>
c010526c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105270:	74 6e                	je     c01052e0 <vprintfmt+0x203>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105272:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105275:	83 ec 08             	sub    $0x8,%esp
c0105278:	50                   	push   %eax
c0105279:	56                   	push   %esi
c010527a:	e8 d3 02 00 00       	call   c0105552 <strnlen>
c010527f:	83 c4 10             	add    $0x10,%esp
c0105282:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105285:	29 c2                	sub    %eax,%edx
c0105287:	89 d0                	mov    %edx,%eax
c0105289:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010528c:	eb 16                	jmp    c01052a4 <vprintfmt+0x1c7>
                    putch(padc, putdat);
c010528e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0105292:	83 ec 08             	sub    $0x8,%esp
c0105295:	ff 75 0c             	pushl  0xc(%ebp)
c0105298:	50                   	push   %eax
c0105299:	8b 45 08             	mov    0x8(%ebp),%eax
c010529c:	ff d0                	call   *%eax
c010529e:	83 c4 10             	add    $0x10,%esp
                for (width -= strnlen(p, precision); width > 0; width --) {
c01052a1:	ff 4d e8             	decl   -0x18(%ebp)
c01052a4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01052a8:	7f e4                	jg     c010528e <vprintfmt+0x1b1>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01052aa:	eb 34                	jmp    c01052e0 <vprintfmt+0x203>
                if (altflag && (ch < ' ' || ch > '~')) {
c01052ac:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01052b0:	74 1c                	je     c01052ce <vprintfmt+0x1f1>
c01052b2:	83 fb 1f             	cmp    $0x1f,%ebx
c01052b5:	7e 05                	jle    c01052bc <vprintfmt+0x1df>
c01052b7:	83 fb 7e             	cmp    $0x7e,%ebx
c01052ba:	7e 12                	jle    c01052ce <vprintfmt+0x1f1>
                    putch('?', putdat);
c01052bc:	83 ec 08             	sub    $0x8,%esp
c01052bf:	ff 75 0c             	pushl  0xc(%ebp)
c01052c2:	6a 3f                	push   $0x3f
c01052c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01052c7:	ff d0                	call   *%eax
c01052c9:	83 c4 10             	add    $0x10,%esp
c01052cc:	eb 0f                	jmp    c01052dd <vprintfmt+0x200>
                }
                else {
                    putch(ch, putdat);
c01052ce:	83 ec 08             	sub    $0x8,%esp
c01052d1:	ff 75 0c             	pushl  0xc(%ebp)
c01052d4:	53                   	push   %ebx
c01052d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01052d8:	ff d0                	call   *%eax
c01052da:	83 c4 10             	add    $0x10,%esp
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01052dd:	ff 4d e8             	decl   -0x18(%ebp)
c01052e0:	89 f0                	mov    %esi,%eax
c01052e2:	8d 70 01             	lea    0x1(%eax),%esi
c01052e5:	8a 00                	mov    (%eax),%al
c01052e7:	0f be d8             	movsbl %al,%ebx
c01052ea:	85 db                	test   %ebx,%ebx
c01052ec:	74 24                	je     c0105312 <vprintfmt+0x235>
c01052ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01052f2:	78 b8                	js     c01052ac <vprintfmt+0x1cf>
c01052f4:	ff 4d e4             	decl   -0x1c(%ebp)
c01052f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01052fb:	79 af                	jns    c01052ac <vprintfmt+0x1cf>
                }
            }
            for (; width > 0; width --) {
c01052fd:	eb 13                	jmp    c0105312 <vprintfmt+0x235>
                putch(' ', putdat);
c01052ff:	83 ec 08             	sub    $0x8,%esp
c0105302:	ff 75 0c             	pushl  0xc(%ebp)
c0105305:	6a 20                	push   $0x20
c0105307:	8b 45 08             	mov    0x8(%ebp),%eax
c010530a:	ff d0                	call   *%eax
c010530c:	83 c4 10             	add    $0x10,%esp
            for (; width > 0; width --) {
c010530f:	ff 4d e8             	decl   -0x18(%ebp)
c0105312:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105316:	7f e7                	jg     c01052ff <vprintfmt+0x222>
            }
            break;
c0105318:	e9 49 01 00 00       	jmp    c0105466 <vprintfmt+0x389>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c010531d:	83 ec 08             	sub    $0x8,%esp
c0105320:	ff 75 e0             	pushl  -0x20(%ebp)
c0105323:	8d 45 14             	lea    0x14(%ebp),%eax
c0105326:	50                   	push   %eax
c0105327:	e8 46 fd ff ff       	call   c0105072 <getint>
c010532c:	83 c4 10             	add    $0x10,%esp
c010532f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105332:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105335:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105338:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010533b:	85 d2                	test   %edx,%edx
c010533d:	79 23                	jns    c0105362 <vprintfmt+0x285>
                putch('-', putdat);
c010533f:	83 ec 08             	sub    $0x8,%esp
c0105342:	ff 75 0c             	pushl  0xc(%ebp)
c0105345:	6a 2d                	push   $0x2d
c0105347:	8b 45 08             	mov    0x8(%ebp),%eax
c010534a:	ff d0                	call   *%eax
c010534c:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
c010534f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105352:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105355:	f7 d8                	neg    %eax
c0105357:	83 d2 00             	adc    $0x0,%edx
c010535a:	f7 da                	neg    %edx
c010535c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010535f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105362:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105369:	e9 9f 00 00 00       	jmp    c010540d <vprintfmt+0x330>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c010536e:	83 ec 08             	sub    $0x8,%esp
c0105371:	ff 75 e0             	pushl  -0x20(%ebp)
c0105374:	8d 45 14             	lea    0x14(%ebp),%eax
c0105377:	50                   	push   %eax
c0105378:	e8 a6 fc ff ff       	call   c0105023 <getuint>
c010537d:	83 c4 10             	add    $0x10,%esp
c0105380:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105383:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105386:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010538d:	eb 7e                	jmp    c010540d <vprintfmt+0x330>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c010538f:	83 ec 08             	sub    $0x8,%esp
c0105392:	ff 75 e0             	pushl  -0x20(%ebp)
c0105395:	8d 45 14             	lea    0x14(%ebp),%eax
c0105398:	50                   	push   %eax
c0105399:	e8 85 fc ff ff       	call   c0105023 <getuint>
c010539e:	83 c4 10             	add    $0x10,%esp
c01053a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01053a4:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c01053a7:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c01053ae:	eb 5d                	jmp    c010540d <vprintfmt+0x330>

        // pointer
        case 'p':
            putch('0', putdat);
c01053b0:	83 ec 08             	sub    $0x8,%esp
c01053b3:	ff 75 0c             	pushl  0xc(%ebp)
c01053b6:	6a 30                	push   $0x30
c01053b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01053bb:	ff d0                	call   *%eax
c01053bd:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
c01053c0:	83 ec 08             	sub    $0x8,%esp
c01053c3:	ff 75 0c             	pushl  0xc(%ebp)
c01053c6:	6a 78                	push   $0x78
c01053c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01053cb:	ff d0                	call   *%eax
c01053cd:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c01053d0:	8b 45 14             	mov    0x14(%ebp),%eax
c01053d3:	8d 50 04             	lea    0x4(%eax),%edx
c01053d6:	89 55 14             	mov    %edx,0x14(%ebp)
c01053d9:	8b 00                	mov    (%eax),%eax
c01053db:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01053de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c01053e5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c01053ec:	eb 1f                	jmp    c010540d <vprintfmt+0x330>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c01053ee:	83 ec 08             	sub    $0x8,%esp
c01053f1:	ff 75 e0             	pushl  -0x20(%ebp)
c01053f4:	8d 45 14             	lea    0x14(%ebp),%eax
c01053f7:	50                   	push   %eax
c01053f8:	e8 26 fc ff ff       	call   c0105023 <getuint>
c01053fd:	83 c4 10             	add    $0x10,%esp
c0105400:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105403:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105406:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c010540d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105411:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105414:	83 ec 04             	sub    $0x4,%esp
c0105417:	52                   	push   %edx
c0105418:	ff 75 e8             	pushl  -0x18(%ebp)
c010541b:	50                   	push   %eax
c010541c:	ff 75 f4             	pushl  -0xc(%ebp)
c010541f:	ff 75 f0             	pushl  -0x10(%ebp)
c0105422:	ff 75 0c             	pushl  0xc(%ebp)
c0105425:	ff 75 08             	pushl  0x8(%ebp)
c0105428:	e8 0e fb ff ff       	call   c0104f3b <printnum>
c010542d:	83 c4 20             	add    $0x20,%esp
            break;
c0105430:	eb 34                	jmp    c0105466 <vprintfmt+0x389>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105432:	83 ec 08             	sub    $0x8,%esp
c0105435:	ff 75 0c             	pushl  0xc(%ebp)
c0105438:	53                   	push   %ebx
c0105439:	8b 45 08             	mov    0x8(%ebp),%eax
c010543c:	ff d0                	call   *%eax
c010543e:	83 c4 10             	add    $0x10,%esp
            break;
c0105441:	eb 23                	jmp    c0105466 <vprintfmt+0x389>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105443:	83 ec 08             	sub    $0x8,%esp
c0105446:	ff 75 0c             	pushl  0xc(%ebp)
c0105449:	6a 25                	push   $0x25
c010544b:	8b 45 08             	mov    0x8(%ebp),%eax
c010544e:	ff d0                	call   *%eax
c0105450:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105453:	ff 4d 10             	decl   0x10(%ebp)
c0105456:	eb 03                	jmp    c010545b <vprintfmt+0x37e>
c0105458:	ff 4d 10             	decl   0x10(%ebp)
c010545b:	8b 45 10             	mov    0x10(%ebp),%eax
c010545e:	48                   	dec    %eax
c010545f:	8a 00                	mov    (%eax),%al
c0105461:	3c 25                	cmp    $0x25,%al
c0105463:	75 f3                	jne    c0105458 <vprintfmt+0x37b>
                /* do nothing */;
            break;
c0105465:	90                   	nop
    while (1) {
c0105466:	e9 7a fc ff ff       	jmp    c01050e5 <vprintfmt+0x8>
                return;
c010546b:	90                   	nop
        }
    }
}
c010546c:	8d 65 f8             	lea    -0x8(%ebp),%esp
c010546f:	5b                   	pop    %ebx
c0105470:	5e                   	pop    %esi
c0105471:	5d                   	pop    %ebp
c0105472:	c3                   	ret    

c0105473 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105473:	55                   	push   %ebp
c0105474:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105476:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105479:	8b 40 08             	mov    0x8(%eax),%eax
c010547c:	8d 50 01             	lea    0x1(%eax),%edx
c010547f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105482:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105485:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105488:	8b 10                	mov    (%eax),%edx
c010548a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010548d:	8b 40 04             	mov    0x4(%eax),%eax
c0105490:	39 c2                	cmp    %eax,%edx
c0105492:	73 12                	jae    c01054a6 <sprintputch+0x33>
        *b->buf ++ = ch;
c0105494:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105497:	8b 00                	mov    (%eax),%eax
c0105499:	8d 48 01             	lea    0x1(%eax),%ecx
c010549c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010549f:	89 0a                	mov    %ecx,(%edx)
c01054a1:	8b 55 08             	mov    0x8(%ebp),%edx
c01054a4:	88 10                	mov    %dl,(%eax)
    }
}
c01054a6:	90                   	nop
c01054a7:	5d                   	pop    %ebp
c01054a8:	c3                   	ret    

c01054a9 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c01054a9:	55                   	push   %ebp
c01054aa:	89 e5                	mov    %esp,%ebp
c01054ac:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01054af:	8d 45 14             	lea    0x14(%ebp),%eax
c01054b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c01054b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054b8:	50                   	push   %eax
c01054b9:	ff 75 10             	pushl  0x10(%ebp)
c01054bc:	ff 75 0c             	pushl  0xc(%ebp)
c01054bf:	ff 75 08             	pushl  0x8(%ebp)
c01054c2:	e8 0b 00 00 00       	call   c01054d2 <vsnprintf>
c01054c7:	83 c4 10             	add    $0x10,%esp
c01054ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01054cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01054d0:	c9                   	leave  
c01054d1:	c3                   	ret    

c01054d2 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c01054d2:	55                   	push   %ebp
c01054d3:	89 e5                	mov    %esp,%ebp
c01054d5:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c01054d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01054db:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01054de:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054e1:	8d 50 ff             	lea    -0x1(%eax),%edx
c01054e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01054e7:	01 d0                	add    %edx,%eax
c01054e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01054ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c01054f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01054f7:	74 0a                	je     c0105503 <vsnprintf+0x31>
c01054f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01054fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054ff:	39 c2                	cmp    %eax,%edx
c0105501:	76 07                	jbe    c010550a <vsnprintf+0x38>
        return -E_INVAL;
c0105503:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105508:	eb 20                	jmp    c010552a <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c010550a:	ff 75 14             	pushl  0x14(%ebp)
c010550d:	ff 75 10             	pushl  0x10(%ebp)
c0105510:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105513:	50                   	push   %eax
c0105514:	68 73 54 10 c0       	push   $0xc0105473
c0105519:	e8 bf fb ff ff       	call   c01050dd <vprintfmt>
c010551e:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
c0105521:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105524:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105527:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010552a:	c9                   	leave  
c010552b:	c3                   	ret    

c010552c <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c010552c:	55                   	push   %ebp
c010552d:	89 e5                	mov    %esp,%ebp
c010552f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105532:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105539:	eb 03                	jmp    c010553e <strlen+0x12>
        cnt ++;
c010553b:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
c010553e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105541:	8d 50 01             	lea    0x1(%eax),%edx
c0105544:	89 55 08             	mov    %edx,0x8(%ebp)
c0105547:	8a 00                	mov    (%eax),%al
c0105549:	84 c0                	test   %al,%al
c010554b:	75 ee                	jne    c010553b <strlen+0xf>
    }
    return cnt;
c010554d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105550:	c9                   	leave  
c0105551:	c3                   	ret    

c0105552 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105552:	55                   	push   %ebp
c0105553:	89 e5                	mov    %esp,%ebp
c0105555:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105558:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c010555f:	eb 03                	jmp    c0105564 <strnlen+0x12>
        cnt ++;
c0105561:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105564:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105567:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010556a:	73 0f                	jae    c010557b <strnlen+0x29>
c010556c:	8b 45 08             	mov    0x8(%ebp),%eax
c010556f:	8d 50 01             	lea    0x1(%eax),%edx
c0105572:	89 55 08             	mov    %edx,0x8(%ebp)
c0105575:	8a 00                	mov    (%eax),%al
c0105577:	84 c0                	test   %al,%al
c0105579:	75 e6                	jne    c0105561 <strnlen+0xf>
    }
    return cnt;
c010557b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010557e:	c9                   	leave  
c010557f:	c3                   	ret    

c0105580 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105580:	55                   	push   %ebp
c0105581:	89 e5                	mov    %esp,%ebp
c0105583:	57                   	push   %edi
c0105584:	56                   	push   %esi
c0105585:	83 ec 20             	sub    $0x20,%esp
c0105588:	8b 45 08             	mov    0x8(%ebp),%eax
c010558b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010558e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105591:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105594:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105597:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010559a:	89 d1                	mov    %edx,%ecx
c010559c:	89 c2                	mov    %eax,%edx
c010559e:	89 ce                	mov    %ecx,%esi
c01055a0:	89 d7                	mov    %edx,%edi
c01055a2:	ac                   	lods   %ds:(%esi),%al
c01055a3:	aa                   	stos   %al,%es:(%edi)
c01055a4:	84 c0                	test   %al,%al
c01055a6:	75 fa                	jne    c01055a2 <strcpy+0x22>
c01055a8:	89 fa                	mov    %edi,%edx
c01055aa:	89 f1                	mov    %esi,%ecx
c01055ac:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01055af:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01055b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c01055b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
c01055b8:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c01055b9:	83 c4 20             	add    $0x20,%esp
c01055bc:	5e                   	pop    %esi
c01055bd:	5f                   	pop    %edi
c01055be:	5d                   	pop    %ebp
c01055bf:	c3                   	ret    

c01055c0 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c01055c0:	55                   	push   %ebp
c01055c1:	89 e5                	mov    %esp,%ebp
c01055c3:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c01055c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01055c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c01055cc:	eb 1c                	jmp    c01055ea <strncpy+0x2a>
        if ((*p = *src) != '\0') {
c01055ce:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055d1:	8a 10                	mov    (%eax),%dl
c01055d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01055d6:	88 10                	mov    %dl,(%eax)
c01055d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01055db:	8a 00                	mov    (%eax),%al
c01055dd:	84 c0                	test   %al,%al
c01055df:	74 03                	je     c01055e4 <strncpy+0x24>
            src ++;
c01055e1:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
c01055e4:	ff 45 fc             	incl   -0x4(%ebp)
c01055e7:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
c01055ea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01055ee:	75 de                	jne    c01055ce <strncpy+0xe>
    }
    return dst;
c01055f0:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01055f3:	c9                   	leave  
c01055f4:	c3                   	ret    

c01055f5 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c01055f5:	55                   	push   %ebp
c01055f6:	89 e5                	mov    %esp,%ebp
c01055f8:	57                   	push   %edi
c01055f9:	56                   	push   %esi
c01055fa:	83 ec 20             	sub    $0x20,%esp
c01055fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105600:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105603:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105606:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c0105609:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010560c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010560f:	89 d1                	mov    %edx,%ecx
c0105611:	89 c2                	mov    %eax,%edx
c0105613:	89 ce                	mov    %ecx,%esi
c0105615:	89 d7                	mov    %edx,%edi
c0105617:	ac                   	lods   %ds:(%esi),%al
c0105618:	ae                   	scas   %es:(%edi),%al
c0105619:	75 08                	jne    c0105623 <strcmp+0x2e>
c010561b:	84 c0                	test   %al,%al
c010561d:	75 f8                	jne    c0105617 <strcmp+0x22>
c010561f:	31 c0                	xor    %eax,%eax
c0105621:	eb 04                	jmp    c0105627 <strcmp+0x32>
c0105623:	19 c0                	sbb    %eax,%eax
c0105625:	0c 01                	or     $0x1,%al
c0105627:	89 fa                	mov    %edi,%edx
c0105629:	89 f1                	mov    %esi,%ecx
c010562b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010562e:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105631:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c0105634:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
c0105637:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105638:	83 c4 20             	add    $0x20,%esp
c010563b:	5e                   	pop    %esi
c010563c:	5f                   	pop    %edi
c010563d:	5d                   	pop    %ebp
c010563e:	c3                   	ret    

c010563f <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c010563f:	55                   	push   %ebp
c0105640:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105642:	eb 09                	jmp    c010564d <strncmp+0xe>
        n --, s1 ++, s2 ++;
c0105644:	ff 4d 10             	decl   0x10(%ebp)
c0105647:	ff 45 08             	incl   0x8(%ebp)
c010564a:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010564d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105651:	74 17                	je     c010566a <strncmp+0x2b>
c0105653:	8b 45 08             	mov    0x8(%ebp),%eax
c0105656:	8a 00                	mov    (%eax),%al
c0105658:	84 c0                	test   %al,%al
c010565a:	74 0e                	je     c010566a <strncmp+0x2b>
c010565c:	8b 45 08             	mov    0x8(%ebp),%eax
c010565f:	8a 10                	mov    (%eax),%dl
c0105661:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105664:	8a 00                	mov    (%eax),%al
c0105666:	38 c2                	cmp    %al,%dl
c0105668:	74 da                	je     c0105644 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c010566a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010566e:	74 16                	je     c0105686 <strncmp+0x47>
c0105670:	8b 45 08             	mov    0x8(%ebp),%eax
c0105673:	8a 00                	mov    (%eax),%al
c0105675:	0f b6 d0             	movzbl %al,%edx
c0105678:	8b 45 0c             	mov    0xc(%ebp),%eax
c010567b:	8a 00                	mov    (%eax),%al
c010567d:	0f b6 c0             	movzbl %al,%eax
c0105680:	29 c2                	sub    %eax,%edx
c0105682:	89 d0                	mov    %edx,%eax
c0105684:	eb 05                	jmp    c010568b <strncmp+0x4c>
c0105686:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010568b:	5d                   	pop    %ebp
c010568c:	c3                   	ret    

c010568d <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c010568d:	55                   	push   %ebp
c010568e:	89 e5                	mov    %esp,%ebp
c0105690:	83 ec 04             	sub    $0x4,%esp
c0105693:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105696:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105699:	eb 12                	jmp    c01056ad <strchr+0x20>
        if (*s == c) {
c010569b:	8b 45 08             	mov    0x8(%ebp),%eax
c010569e:	8a 00                	mov    (%eax),%al
c01056a0:	38 45 fc             	cmp    %al,-0x4(%ebp)
c01056a3:	75 05                	jne    c01056aa <strchr+0x1d>
            return (char *)s;
c01056a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01056a8:	eb 11                	jmp    c01056bb <strchr+0x2e>
        }
        s ++;
c01056aa:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c01056ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01056b0:	8a 00                	mov    (%eax),%al
c01056b2:	84 c0                	test   %al,%al
c01056b4:	75 e5                	jne    c010569b <strchr+0xe>
    }
    return NULL;
c01056b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01056bb:	c9                   	leave  
c01056bc:	c3                   	ret    

c01056bd <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c01056bd:	55                   	push   %ebp
c01056be:	89 e5                	mov    %esp,%ebp
c01056c0:	83 ec 04             	sub    $0x4,%esp
c01056c3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056c6:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01056c9:	eb 0d                	jmp    c01056d8 <strfind+0x1b>
        if (*s == c) {
c01056cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01056ce:	8a 00                	mov    (%eax),%al
c01056d0:	38 45 fc             	cmp    %al,-0x4(%ebp)
c01056d3:	74 0e                	je     c01056e3 <strfind+0x26>
            break;
        }
        s ++;
c01056d5:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c01056d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01056db:	8a 00                	mov    (%eax),%al
c01056dd:	84 c0                	test   %al,%al
c01056df:	75 ea                	jne    c01056cb <strfind+0xe>
c01056e1:	eb 01                	jmp    c01056e4 <strfind+0x27>
            break;
c01056e3:	90                   	nop
    }
    return (char *)s;
c01056e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01056e7:	c9                   	leave  
c01056e8:	c3                   	ret    

c01056e9 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c01056e9:	55                   	push   %ebp
c01056ea:	89 e5                	mov    %esp,%ebp
c01056ec:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c01056ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c01056f6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01056fd:	eb 03                	jmp    c0105702 <strtol+0x19>
        s ++;
c01056ff:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c0105702:	8b 45 08             	mov    0x8(%ebp),%eax
c0105705:	8a 00                	mov    (%eax),%al
c0105707:	3c 20                	cmp    $0x20,%al
c0105709:	74 f4                	je     c01056ff <strtol+0x16>
c010570b:	8b 45 08             	mov    0x8(%ebp),%eax
c010570e:	8a 00                	mov    (%eax),%al
c0105710:	3c 09                	cmp    $0x9,%al
c0105712:	74 eb                	je     c01056ff <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
c0105714:	8b 45 08             	mov    0x8(%ebp),%eax
c0105717:	8a 00                	mov    (%eax),%al
c0105719:	3c 2b                	cmp    $0x2b,%al
c010571b:	75 05                	jne    c0105722 <strtol+0x39>
        s ++;
c010571d:	ff 45 08             	incl   0x8(%ebp)
c0105720:	eb 13                	jmp    c0105735 <strtol+0x4c>
    }
    else if (*s == '-') {
c0105722:	8b 45 08             	mov    0x8(%ebp),%eax
c0105725:	8a 00                	mov    (%eax),%al
c0105727:	3c 2d                	cmp    $0x2d,%al
c0105729:	75 0a                	jne    c0105735 <strtol+0x4c>
        s ++, neg = 1;
c010572b:	ff 45 08             	incl   0x8(%ebp)
c010572e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105735:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105739:	74 06                	je     c0105741 <strtol+0x58>
c010573b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c010573f:	75 20                	jne    c0105761 <strtol+0x78>
c0105741:	8b 45 08             	mov    0x8(%ebp),%eax
c0105744:	8a 00                	mov    (%eax),%al
c0105746:	3c 30                	cmp    $0x30,%al
c0105748:	75 17                	jne    c0105761 <strtol+0x78>
c010574a:	8b 45 08             	mov    0x8(%ebp),%eax
c010574d:	40                   	inc    %eax
c010574e:	8a 00                	mov    (%eax),%al
c0105750:	3c 78                	cmp    $0x78,%al
c0105752:	75 0d                	jne    c0105761 <strtol+0x78>
        s += 2, base = 16;
c0105754:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105758:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c010575f:	eb 28                	jmp    c0105789 <strtol+0xa0>
    }
    else if (base == 0 && s[0] == '0') {
c0105761:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105765:	75 15                	jne    c010577c <strtol+0x93>
c0105767:	8b 45 08             	mov    0x8(%ebp),%eax
c010576a:	8a 00                	mov    (%eax),%al
c010576c:	3c 30                	cmp    $0x30,%al
c010576e:	75 0c                	jne    c010577c <strtol+0x93>
        s ++, base = 8;
c0105770:	ff 45 08             	incl   0x8(%ebp)
c0105773:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c010577a:	eb 0d                	jmp    c0105789 <strtol+0xa0>
    }
    else if (base == 0) {
c010577c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105780:	75 07                	jne    c0105789 <strtol+0xa0>
        base = 10;
c0105782:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105789:	8b 45 08             	mov    0x8(%ebp),%eax
c010578c:	8a 00                	mov    (%eax),%al
c010578e:	3c 2f                	cmp    $0x2f,%al
c0105790:	7e 19                	jle    c01057ab <strtol+0xc2>
c0105792:	8b 45 08             	mov    0x8(%ebp),%eax
c0105795:	8a 00                	mov    (%eax),%al
c0105797:	3c 39                	cmp    $0x39,%al
c0105799:	7f 10                	jg     c01057ab <strtol+0xc2>
            dig = *s - '0';
c010579b:	8b 45 08             	mov    0x8(%ebp),%eax
c010579e:	8a 00                	mov    (%eax),%al
c01057a0:	0f be c0             	movsbl %al,%eax
c01057a3:	83 e8 30             	sub    $0x30,%eax
c01057a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01057a9:	eb 42                	jmp    c01057ed <strtol+0x104>
        }
        else if (*s >= 'a' && *s <= 'z') {
c01057ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01057ae:	8a 00                	mov    (%eax),%al
c01057b0:	3c 60                	cmp    $0x60,%al
c01057b2:	7e 19                	jle    c01057cd <strtol+0xe4>
c01057b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01057b7:	8a 00                	mov    (%eax),%al
c01057b9:	3c 7a                	cmp    $0x7a,%al
c01057bb:	7f 10                	jg     c01057cd <strtol+0xe4>
            dig = *s - 'a' + 10;
c01057bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01057c0:	8a 00                	mov    (%eax),%al
c01057c2:	0f be c0             	movsbl %al,%eax
c01057c5:	83 e8 57             	sub    $0x57,%eax
c01057c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01057cb:	eb 20                	jmp    c01057ed <strtol+0x104>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c01057cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01057d0:	8a 00                	mov    (%eax),%al
c01057d2:	3c 40                	cmp    $0x40,%al
c01057d4:	7e 39                	jle    c010580f <strtol+0x126>
c01057d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01057d9:	8a 00                	mov    (%eax),%al
c01057db:	3c 5a                	cmp    $0x5a,%al
c01057dd:	7f 30                	jg     c010580f <strtol+0x126>
            dig = *s - 'A' + 10;
c01057df:	8b 45 08             	mov    0x8(%ebp),%eax
c01057e2:	8a 00                	mov    (%eax),%al
c01057e4:	0f be c0             	movsbl %al,%eax
c01057e7:	83 e8 37             	sub    $0x37,%eax
c01057ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c01057ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057f0:	3b 45 10             	cmp    0x10(%ebp),%eax
c01057f3:	7d 19                	jge    c010580e <strtol+0x125>
            break;
        }
        s ++, val = (val * base) + dig;
c01057f5:	ff 45 08             	incl   0x8(%ebp)
c01057f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01057fb:	0f af 45 10          	imul   0x10(%ebp),%eax
c01057ff:	89 c2                	mov    %eax,%edx
c0105801:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105804:	01 d0                	add    %edx,%eax
c0105806:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c0105809:	e9 7b ff ff ff       	jmp    c0105789 <strtol+0xa0>
            break;
c010580e:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c010580f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105813:	74 08                	je     c010581d <strtol+0x134>
        *endptr = (char *) s;
c0105815:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105818:	8b 55 08             	mov    0x8(%ebp),%edx
c010581b:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c010581d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105821:	74 07                	je     c010582a <strtol+0x141>
c0105823:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105826:	f7 d8                	neg    %eax
c0105828:	eb 03                	jmp    c010582d <strtol+0x144>
c010582a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c010582d:	c9                   	leave  
c010582e:	c3                   	ret    

c010582f <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c010582f:	55                   	push   %ebp
c0105830:	89 e5                	mov    %esp,%ebp
c0105832:	57                   	push   %edi
c0105833:	83 ec 24             	sub    $0x24,%esp
c0105836:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105839:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c010583c:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105840:	8b 55 08             	mov    0x8(%ebp),%edx
c0105843:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105846:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105849:	8b 45 10             	mov    0x10(%ebp),%eax
c010584c:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c010584f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105852:	8a 45 f7             	mov    -0x9(%ebp),%al
c0105855:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105858:	89 d7                	mov    %edx,%edi
c010585a:	f3 aa                	rep stos %al,%es:(%edi)
c010585c:	89 fa                	mov    %edi,%edx
c010585e:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105861:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105864:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105867:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105868:	83 c4 24             	add    $0x24,%esp
c010586b:	5f                   	pop    %edi
c010586c:	5d                   	pop    %ebp
c010586d:	c3                   	ret    

c010586e <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c010586e:	55                   	push   %ebp
c010586f:	89 e5                	mov    %esp,%ebp
c0105871:	57                   	push   %edi
c0105872:	56                   	push   %esi
c0105873:	53                   	push   %ebx
c0105874:	83 ec 30             	sub    $0x30,%esp
c0105877:	8b 45 08             	mov    0x8(%ebp),%eax
c010587a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010587d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105880:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105883:	8b 45 10             	mov    0x10(%ebp),%eax
c0105886:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105889:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010588c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010588f:	73 42                	jae    c01058d3 <memmove+0x65>
c0105891:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105894:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105897:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010589a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010589d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01058a0:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c01058a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01058a6:	c1 e8 02             	shr    $0x2,%eax
c01058a9:	89 c1                	mov    %eax,%ecx
    asm volatile (
c01058ab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01058ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058b1:	89 d7                	mov    %edx,%edi
c01058b3:	89 c6                	mov    %eax,%esi
c01058b5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01058b7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01058ba:	83 e1 03             	and    $0x3,%ecx
c01058bd:	74 02                	je     c01058c1 <memmove+0x53>
c01058bf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01058c1:	89 f0                	mov    %esi,%eax
c01058c3:	89 fa                	mov    %edi,%edx
c01058c5:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c01058c8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01058cb:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c01058ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
c01058d1:	eb 36                	jmp    c0105909 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c01058d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01058d6:	8d 50 ff             	lea    -0x1(%eax),%edx
c01058d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01058dc:	01 c2                	add    %eax,%edx
c01058de:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01058e1:	8d 48 ff             	lea    -0x1(%eax),%ecx
c01058e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058e7:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c01058ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01058ed:	89 c1                	mov    %eax,%ecx
c01058ef:	89 d8                	mov    %ebx,%eax
c01058f1:	89 d6                	mov    %edx,%esi
c01058f3:	89 c7                	mov    %eax,%edi
c01058f5:	fd                   	std    
c01058f6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01058f8:	fc                   	cld    
c01058f9:	89 f8                	mov    %edi,%eax
c01058fb:	89 f2                	mov    %esi,%edx
c01058fd:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105900:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105903:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c0105906:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105909:	83 c4 30             	add    $0x30,%esp
c010590c:	5b                   	pop    %ebx
c010590d:	5e                   	pop    %esi
c010590e:	5f                   	pop    %edi
c010590f:	5d                   	pop    %ebp
c0105910:	c3                   	ret    

c0105911 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105911:	55                   	push   %ebp
c0105912:	89 e5                	mov    %esp,%ebp
c0105914:	57                   	push   %edi
c0105915:	56                   	push   %esi
c0105916:	83 ec 20             	sub    $0x20,%esp
c0105919:	8b 45 08             	mov    0x8(%ebp),%eax
c010591c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010591f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105922:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105925:	8b 45 10             	mov    0x10(%ebp),%eax
c0105928:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010592b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010592e:	c1 e8 02             	shr    $0x2,%eax
c0105931:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105933:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105936:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105939:	89 d7                	mov    %edx,%edi
c010593b:	89 c6                	mov    %eax,%esi
c010593d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010593f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105942:	83 e1 03             	and    $0x3,%ecx
c0105945:	74 02                	je     c0105949 <memcpy+0x38>
c0105947:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105949:	89 f0                	mov    %esi,%eax
c010594b:	89 fa                	mov    %edi,%edx
c010594d:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105950:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105953:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c0105956:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
c0105959:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c010595a:	83 c4 20             	add    $0x20,%esp
c010595d:	5e                   	pop    %esi
c010595e:	5f                   	pop    %edi
c010595f:	5d                   	pop    %ebp
c0105960:	c3                   	ret    

c0105961 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105961:	55                   	push   %ebp
c0105962:	89 e5                	mov    %esp,%ebp
c0105964:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105967:	8b 45 08             	mov    0x8(%ebp),%eax
c010596a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c010596d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105970:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105973:	eb 2a                	jmp    c010599f <memcmp+0x3e>
        if (*s1 != *s2) {
c0105975:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105978:	8a 10                	mov    (%eax),%dl
c010597a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010597d:	8a 00                	mov    (%eax),%al
c010597f:	38 c2                	cmp    %al,%dl
c0105981:	74 16                	je     c0105999 <memcmp+0x38>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105983:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105986:	8a 00                	mov    (%eax),%al
c0105988:	0f b6 d0             	movzbl %al,%edx
c010598b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010598e:	8a 00                	mov    (%eax),%al
c0105990:	0f b6 c0             	movzbl %al,%eax
c0105993:	29 c2                	sub    %eax,%edx
c0105995:	89 d0                	mov    %edx,%eax
c0105997:	eb 18                	jmp    c01059b1 <memcmp+0x50>
        }
        s1 ++, s2 ++;
c0105999:	ff 45 fc             	incl   -0x4(%ebp)
c010599c:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
c010599f:	8b 45 10             	mov    0x10(%ebp),%eax
c01059a2:	8d 50 ff             	lea    -0x1(%eax),%edx
c01059a5:	89 55 10             	mov    %edx,0x10(%ebp)
c01059a8:	85 c0                	test   %eax,%eax
c01059aa:	75 c9                	jne    c0105975 <memcmp+0x14>
    }
    return 0;
c01059ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01059b1:	c9                   	leave  
c01059b2:	c3                   	ret    
