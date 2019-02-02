
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
c0100051:	e8 a5 56 00 00       	call   c01056fb <memset>
c0100056:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
c0100059:	e8 48 14 00 00       	call   c01014a6 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005e:	c7 45 f4 80 58 10 c0 	movl   $0xc0105880,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100065:	83 ec 08             	sub    $0x8,%esp
c0100068:	ff 75 f4             	pushl  -0xc(%ebp)
c010006b:	68 9c 58 10 c0       	push   $0xc010589c
c0100070:	e8 c2 02 00 00       	call   c0100337 <cprintf>
c0100075:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
c0100078:	e8 bd 07 00 00       	call   c010083a <print_kerninfo>

    grade_backtrace();
c010007d:	e8 74 00 00 00       	call   c01000f6 <grade_backtrace>

    pmm_init();                 // init physical memory management
c0100082:	e8 65 40 00 00       	call   c01040ec <pmm_init>

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
c010013f:	68 a1 58 10 c0       	push   $0xc01058a1
c0100144:	e8 ee 01 00 00       	call   c0100337 <cprintf>
c0100149:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
c010014c:	66 8b 45 f6          	mov    -0xa(%ebp),%ax
c0100150:	0f b7 d0             	movzwl %ax,%edx
c0100153:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c0100158:	83 ec 04             	sub    $0x4,%esp
c010015b:	52                   	push   %edx
c010015c:	50                   	push   %eax
c010015d:	68 af 58 10 c0       	push   $0xc01058af
c0100162:	e8 d0 01 00 00       	call   c0100337 <cprintf>
c0100167:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
c010016a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010016d:	0f b7 d0             	movzwl %ax,%edx
c0100170:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c0100175:	83 ec 04             	sub    $0x4,%esp
c0100178:	52                   	push   %edx
c0100179:	50                   	push   %eax
c010017a:	68 bd 58 10 c0       	push   $0xc01058bd
c010017f:	e8 b3 01 00 00       	call   c0100337 <cprintf>
c0100184:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
c0100187:	66 8b 45 f2          	mov    -0xe(%ebp),%ax
c010018b:	0f b7 d0             	movzwl %ax,%edx
c010018e:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c0100193:	83 ec 04             	sub    $0x4,%esp
c0100196:	52                   	push   %edx
c0100197:	50                   	push   %eax
c0100198:	68 cb 58 10 c0       	push   $0xc01058cb
c010019d:	e8 95 01 00 00       	call   c0100337 <cprintf>
c01001a2:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
c01001a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01001a8:	0f b7 d0             	movzwl %ax,%edx
c01001ab:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c01001b0:	83 ec 04             	sub    $0x4,%esp
c01001b3:	52                   	push   %edx
c01001b4:	50                   	push   %eax
c01001b5:	68 d9 58 10 c0       	push   $0xc01058d9
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
c01001f5:	68 e8 58 10 c0       	push   $0xc01058e8
c01001fa:	e8 38 01 00 00       	call   c0100337 <cprintf>
c01001ff:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
c0100202:	e8 c9 ff ff ff       	call   c01001d0 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100207:	e8 0b ff ff ff       	call   c0100117 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010020c:	83 ec 0c             	sub    $0xc,%esp
c010020f:	68 08 59 10 c0       	push   $0xc0105908
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
c010023b:	68 27 59 10 c0       	push   $0xc0105927
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
c010032a:	e8 7a 4c 00 00       	call   c0104fa9 <vprintfmt>
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
c0100530:	c7 00 2c 59 10 c0    	movl   $0xc010592c,(%eax)
    info->eip_line = 0;
c0100536:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100539:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100540:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100543:	c7 40 08 2c 59 10 c0 	movl   $0xc010592c,0x8(%eax)
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
c0100567:	c7 45 f4 78 6b 10 c0 	movl   $0xc0106b78,-0xc(%ebp)
    stab_end = __STAB_END__;
c010056e:	c7 45 f0 08 2c 11 c0 	movl   $0xc0112c08,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100575:	c7 45 ec 09 2c 11 c0 	movl   $0xc0112c09,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c010057c:	c7 45 e8 17 57 11 c0 	movl   $0xc0115717,-0x18(%ebp)

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
c01006c8:	e8 bc 4e 00 00       	call   c0105589 <strfind>
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
c0100843:	68 36 59 10 c0       	push   $0xc0105936
c0100848:	e8 ea fa ff ff       	call   c0100337 <cprintf>
c010084d:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100850:	83 ec 08             	sub    $0x8,%esp
c0100853:	68 36 00 10 c0       	push   $0xc0100036
c0100858:	68 4f 59 10 c0       	push   $0xc010594f
c010085d:	e8 d5 fa ff ff       	call   c0100337 <cprintf>
c0100862:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100865:	83 ec 08             	sub    $0x8,%esp
c0100868:	68 7f 58 10 c0       	push   $0xc010587f
c010086d:	68 67 59 10 c0       	push   $0xc0105967
c0100872:	e8 c0 fa ff ff       	call   c0100337 <cprintf>
c0100877:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
c010087a:	83 ec 08             	sub    $0x8,%esp
c010087d:	68 00 b0 11 c0       	push   $0xc011b000
c0100882:	68 7f 59 10 c0       	push   $0xc010597f
c0100887:	e8 ab fa ff ff       	call   c0100337 <cprintf>
c010088c:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
c010088f:	83 ec 08             	sub    $0x8,%esp
c0100892:	68 28 bf 11 c0       	push   $0xc011bf28
c0100897:	68 97 59 10 c0       	push   $0xc0105997
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
c01008c3:	68 b0 59 10 c0       	push   $0xc01059b0
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
c01008f8:	68 da 59 10 c0       	push   $0xc01059da
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
c010095d:	68 f6 59 10 c0       	push   $0xc01059f6
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
c01009b4:	68 88 5a 10 c0       	push   $0xc0105a88
c01009b9:	e8 9b 4b 00 00       	call   c0105559 <strchr>
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
c01009d9:	68 8d 5a 10 c0       	push   $0xc0105a8d
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
c0100a1a:	68 88 5a 10 c0       	push   $0xc0105a88
c0100a1f:	e8 35 4b 00 00       	call   c0105559 <strchr>
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
c0100a85:	e8 37 4a 00 00       	call   c01054c1 <strcmp>
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
c0100acf:	68 ab 5a 10 c0       	push   $0xc0105aab
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
c0100aec:	68 c4 5a 10 c0       	push   $0xc0105ac4
c0100af1:	e8 41 f8 ff ff       	call   c0100337 <cprintf>
c0100af6:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
c0100af9:	83 ec 0c             	sub    $0xc,%esp
c0100afc:	68 ec 5a 10 c0       	push   $0xc0105aec
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
c0100b20:	68 11 5b 10 c0       	push   $0xc0105b11
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
c0100b8b:	68 15 5b 10 c0       	push   $0xc0105b15
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
c0100bf6:	68 1e 5b 10 c0       	push   $0xc0105b1e
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
c0100c18:	68 3a 5b 10 c0       	push   $0xc0105b3a
c0100c1d:	e8 15 f7 ff ff       	call   c0100337 <cprintf>
c0100c22:	83 c4 10             	add    $0x10,%esp
    
    cprintf("stack trackback:\n");
c0100c25:	83 ec 0c             	sub    $0xc,%esp
c0100c28:	68 3c 5b 10 c0       	push   $0xc0105b3c
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
c0100c66:	68 4e 5b 10 c0       	push   $0xc0105b4e
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
c0100c88:	68 3a 5b 10 c0       	push   $0xc0105b3a
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
c0100ceb:	68 6c 5b 10 c0       	push   $0xc0105b6c
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
c01010e3:	e8 52 46 00 00       	call   c010573a <memmove>
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
c010144f:	68 87 5b 10 c0       	push   $0xc0105b87
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
c01014c7:	68 93 5b 10 c0       	push   $0xc0105b93
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
c0101757:	68 c0 5b 10 c0       	push   $0xc0105bc0
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
c01018cc:	8b 04 85 20 5f 10 c0 	mov    -0x3fefa0e0(,%eax,4),%eax
c01018d3:	eb 18                	jmp    c01018ed <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c01018d5:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c01018d9:	7e 0d                	jle    c01018e8 <trapname+0x2a>
c01018db:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c01018df:	7f 07                	jg     c01018e8 <trapname+0x2a>
        return "Hardware Interrupt";
c01018e1:	b8 ca 5b 10 c0       	mov    $0xc0105bca,%eax
c01018e6:	eb 05                	jmp    c01018ed <trapname+0x2f>
    }
    return "(unknown trap)";
c01018e8:	b8 dd 5b 10 c0       	mov    $0xc0105bdd,%eax
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
c0101911:	68 1e 5c 10 c0       	push   $0xc0105c1e
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
c010193b:	68 2f 5c 10 c0       	push   $0xc0105c2f
c0101940:	e8 f2 e9 ff ff       	call   c0100337 <cprintf>
c0101945:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101948:	8b 45 08             	mov    0x8(%ebp),%eax
c010194b:	66 8b 40 28          	mov    0x28(%eax),%ax
c010194f:	0f b7 c0             	movzwl %ax,%eax
c0101952:	83 ec 08             	sub    $0x8,%esp
c0101955:	50                   	push   %eax
c0101956:	68 42 5c 10 c0       	push   $0xc0105c42
c010195b:	e8 d7 e9 ff ff       	call   c0100337 <cprintf>
c0101960:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101963:	8b 45 08             	mov    0x8(%ebp),%eax
c0101966:	66 8b 40 24          	mov    0x24(%eax),%ax
c010196a:	0f b7 c0             	movzwl %ax,%eax
c010196d:	83 ec 08             	sub    $0x8,%esp
c0101970:	50                   	push   %eax
c0101971:	68 55 5c 10 c0       	push   $0xc0105c55
c0101976:	e8 bc e9 ff ff       	call   c0100337 <cprintf>
c010197b:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c010197e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101981:	66 8b 40 20          	mov    0x20(%eax),%ax
c0101985:	0f b7 c0             	movzwl %ax,%eax
c0101988:	83 ec 08             	sub    $0x8,%esp
c010198b:	50                   	push   %eax
c010198c:	68 68 5c 10 c0       	push   $0xc0105c68
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
c01019b8:	68 7b 5c 10 c0       	push   $0xc0105c7b
c01019bd:	e8 75 e9 ff ff       	call   c0100337 <cprintf>
c01019c2:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
c01019c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01019c8:	8b 40 34             	mov    0x34(%eax),%eax
c01019cb:	83 ec 08             	sub    $0x8,%esp
c01019ce:	50                   	push   %eax
c01019cf:	68 8d 5c 10 c0       	push   $0xc0105c8d
c01019d4:	e8 5e e9 ff ff       	call   c0100337 <cprintf>
c01019d9:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c01019dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01019df:	8b 40 38             	mov    0x38(%eax),%eax
c01019e2:	83 ec 08             	sub    $0x8,%esp
c01019e5:	50                   	push   %eax
c01019e6:	68 9c 5c 10 c0       	push   $0xc0105c9c
c01019eb:	e8 47 e9 ff ff       	call   c0100337 <cprintf>
c01019f0:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c01019f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01019f6:	66 8b 40 3c          	mov    0x3c(%eax),%ax
c01019fa:	0f b7 c0             	movzwl %ax,%eax
c01019fd:	83 ec 08             	sub    $0x8,%esp
c0101a00:	50                   	push   %eax
c0101a01:	68 ab 5c 10 c0       	push   $0xc0105cab
c0101a06:	e8 2c e9 ff ff       	call   c0100337 <cprintf>
c0101a0b:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101a0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a11:	8b 40 40             	mov    0x40(%eax),%eax
c0101a14:	83 ec 08             	sub    $0x8,%esp
c0101a17:	50                   	push   %eax
c0101a18:	68 be 5c 10 c0       	push   $0xc0105cbe
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
c0101a60:	68 cd 5c 10 c0       	push   $0xc0105ccd
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
c0101a90:	68 d1 5c 10 c0       	push   $0xc0105cd1
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
c0101ab9:	68 da 5c 10 c0       	push   $0xc0105cda
c0101abe:	e8 74 e8 ff ff       	call   c0100337 <cprintf>
c0101ac3:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101ac6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ac9:	66 8b 40 48          	mov    0x48(%eax),%ax
c0101acd:	0f b7 c0             	movzwl %ax,%eax
c0101ad0:	83 ec 08             	sub    $0x8,%esp
c0101ad3:	50                   	push   %eax
c0101ad4:	68 e9 5c 10 c0       	push   $0xc0105ce9
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
c0101af3:	68 fc 5c 10 c0       	push   $0xc0105cfc
c0101af8:	e8 3a e8 ff ff       	call   c0100337 <cprintf>
c0101afd:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101b00:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b03:	8b 40 04             	mov    0x4(%eax),%eax
c0101b06:	83 ec 08             	sub    $0x8,%esp
c0101b09:	50                   	push   %eax
c0101b0a:	68 0b 5d 10 c0       	push   $0xc0105d0b
c0101b0f:	e8 23 e8 ff ff       	call   c0100337 <cprintf>
c0101b14:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101b17:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b1a:	8b 40 08             	mov    0x8(%eax),%eax
c0101b1d:	83 ec 08             	sub    $0x8,%esp
c0101b20:	50                   	push   %eax
c0101b21:	68 1a 5d 10 c0       	push   $0xc0105d1a
c0101b26:	e8 0c e8 ff ff       	call   c0100337 <cprintf>
c0101b2b:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101b2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b31:	8b 40 0c             	mov    0xc(%eax),%eax
c0101b34:	83 ec 08             	sub    $0x8,%esp
c0101b37:	50                   	push   %eax
c0101b38:	68 29 5d 10 c0       	push   $0xc0105d29
c0101b3d:	e8 f5 e7 ff ff       	call   c0100337 <cprintf>
c0101b42:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101b45:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b48:	8b 40 10             	mov    0x10(%eax),%eax
c0101b4b:	83 ec 08             	sub    $0x8,%esp
c0101b4e:	50                   	push   %eax
c0101b4f:	68 38 5d 10 c0       	push   $0xc0105d38
c0101b54:	e8 de e7 ff ff       	call   c0100337 <cprintf>
c0101b59:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101b5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b5f:	8b 40 14             	mov    0x14(%eax),%eax
c0101b62:	83 ec 08             	sub    $0x8,%esp
c0101b65:	50                   	push   %eax
c0101b66:	68 47 5d 10 c0       	push   $0xc0105d47
c0101b6b:	e8 c7 e7 ff ff       	call   c0100337 <cprintf>
c0101b70:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101b73:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b76:	8b 40 18             	mov    0x18(%eax),%eax
c0101b79:	83 ec 08             	sub    $0x8,%esp
c0101b7c:	50                   	push   %eax
c0101b7d:	68 56 5d 10 c0       	push   $0xc0105d56
c0101b82:	e8 b0 e7 ff ff       	call   c0100337 <cprintf>
c0101b87:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101b8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b8d:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101b90:	83 ec 08             	sub    $0x8,%esp
c0101b93:	50                   	push   %eax
c0101b94:	68 65 5d 10 c0       	push   $0xc0105d65
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
c0101c2e:	68 74 5d 10 c0       	push   $0xc0105d74
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
c0101c55:	68 86 5d 10 c0       	push   $0xc0105d86
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
c0101d68:	68 95 5d 10 c0       	push   $0xc0105d95
c0101d6d:	68 ca 00 00 00       	push   $0xca
c0101d72:	68 b1 5d 10 c0       	push   $0xc0105db1
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
c01028d6:	68 70 5f 10 c0       	push   $0xc0105f70
c01028db:	68 76 5f 10 c0       	push   $0xc0105f76
c01028e0:	6a 6d                	push   $0x6d
c01028e2:	68 8b 5f 10 c0       	push   $0xc0105f8b
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
c0102920:	68 a1 5f 10 c0       	push   $0xc0105fa1
c0102925:	68 76 5f 10 c0       	push   $0xc0105f76
c010292a:	6a 71                	push   $0x71
c010292c:	68 8b 5f 10 c0       	push   $0xc0105f8b
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
c0102a06:	68 70 5f 10 c0       	push   $0xc0105f70
c0102a0b:	68 76 5f 10 c0       	push   $0xc0105f76
c0102a10:	68 83 00 00 00       	push   $0x83
c0102a15:	68 8b 5f 10 c0       	push   $0xc0105f8b
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
c0102aad:	68 b1 5f 10 c0       	push   $0xc0105fb1
c0102ab2:	68 76 5f 10 c0       	push   $0xc0105f76
c0102ab7:	68 94 00 00 00       	push   $0x94
c0102abc:	68 8b 5f 10 c0       	push   $0xc0105f8b
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
c0102bc6:	68 70 5f 10 c0       	push   $0xc0105f70
c0102bcb:	68 76 5f 10 c0       	push   $0xc0105f76
c0102bd0:	68 a9 00 00 00       	push   $0xa9
c0102bd5:	68 8b 5f 10 c0       	push   $0xc0105f8b
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
c0102c42:	68 c4 5f 10 c0       	push   $0xc0105fc4
c0102c47:	68 76 5f 10 c0       	push   $0xc0105f76
c0102c4c:	68 ad 00 00 00       	push   $0xad
c0102c51:	68 8b 5f 10 c0       	push   $0xc0105f8b
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
    while (le != &free_list) {                      // 把将要回收的块插入合适的位置
c0102cd8:	eb 34                	jmp    c0102d0e <default_free_pages+0x157>
        p = le2page(le, page_link);                 //
c0102cda:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102cdd:	83 e8 0c             	sub    $0xc,%eax
c0102ce0:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {           // 使得插入后地址是从低到高的
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
            break;                                  //
        }                                           //
        le = list_next(le);                         //
c0102d0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {                      // 把将要回收的块插入合适的位置
c0102d0e:	81 7d f0 10 bf 11 c0 	cmpl   $0xc011bf10,-0x10(%ebp)
c0102d15:	75 c3                	jne    c0102cda <default_free_pages+0x123>
c0102d17:	eb 01                	jmp    c0102d1a <default_free_pages+0x163>
            break;                                  //
c0102d19:	90                   	nop
c0102d1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d1d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->prev;
c0102d20:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102d23:	8b 00                	mov    (%eax),%eax
    }                                               //
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
c0102ea3:	e8 d6 0c 00 00       	call   c0103b7e <alloc_pages>
c0102ea8:	83 c4 10             	add    $0x10,%esp
c0102eab:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102eae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102eb2:	75 19                	jne    c0102ecd <basic_check+0x48>
c0102eb4:	68 e9 5f 10 c0       	push   $0xc0105fe9
c0102eb9:	68 76 5f 10 c0       	push   $0xc0105f76
c0102ebe:	68 d8 00 00 00       	push   $0xd8
c0102ec3:	68 8b 5f 10 c0       	push   $0xc0105f8b
c0102ec8:	e8 01 dd ff ff       	call   c0100bce <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102ecd:	83 ec 0c             	sub    $0xc,%esp
c0102ed0:	6a 01                	push   $0x1
c0102ed2:	e8 a7 0c 00 00       	call   c0103b7e <alloc_pages>
c0102ed7:	83 c4 10             	add    $0x10,%esp
c0102eda:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102edd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102ee1:	75 19                	jne    c0102efc <basic_check+0x77>
c0102ee3:	68 05 60 10 c0       	push   $0xc0106005
c0102ee8:	68 76 5f 10 c0       	push   $0xc0105f76
c0102eed:	68 d9 00 00 00       	push   $0xd9
c0102ef2:	68 8b 5f 10 c0       	push   $0xc0105f8b
c0102ef7:	e8 d2 dc ff ff       	call   c0100bce <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102efc:	83 ec 0c             	sub    $0xc,%esp
c0102eff:	6a 01                	push   $0x1
c0102f01:	e8 78 0c 00 00       	call   c0103b7e <alloc_pages>
c0102f06:	83 c4 10             	add    $0x10,%esp
c0102f09:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102f0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102f10:	75 19                	jne    c0102f2b <basic_check+0xa6>
c0102f12:	68 21 60 10 c0       	push   $0xc0106021
c0102f17:	68 76 5f 10 c0       	push   $0xc0105f76
c0102f1c:	68 da 00 00 00       	push   $0xda
c0102f21:	68 8b 5f 10 c0       	push   $0xc0105f8b
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
c0102f43:	68 40 60 10 c0       	push   $0xc0106040
c0102f48:	68 76 5f 10 c0       	push   $0xc0105f76
c0102f4d:	68 dc 00 00 00       	push   $0xdc
c0102f52:	68 8b 5f 10 c0       	push   $0xc0105f8b
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
c0102f92:	68 64 60 10 c0       	push   $0xc0106064
c0102f97:	68 76 5f 10 c0       	push   $0xc0105f76
c0102f9c:	68 dd 00 00 00       	push   $0xdd
c0102fa1:	68 8b 5f 10 c0       	push   $0xc0105f8b
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
c0102fc6:	68 a0 60 10 c0       	push   $0xc01060a0
c0102fcb:	68 76 5f 10 c0       	push   $0xc0105f76
c0102fd0:	68 df 00 00 00       	push   $0xdf
c0102fd5:	68 8b 5f 10 c0       	push   $0xc0105f8b
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
c0102ffa:	68 bd 60 10 c0       	push   $0xc01060bd
c0102fff:	68 76 5f 10 c0       	push   $0xc0105f76
c0103004:	68 e0 00 00 00       	push   $0xe0
c0103009:	68 8b 5f 10 c0       	push   $0xc0105f8b
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
c010302e:	68 da 60 10 c0       	push   $0xc01060da
c0103033:	68 76 5f 10 c0       	push   $0xc0105f76
c0103038:	68 e1 00 00 00       	push   $0xe1
c010303d:	68 8b 5f 10 c0       	push   $0xc0105f8b
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
c010308d:	68 f7 60 10 c0       	push   $0xc01060f7
c0103092:	68 76 5f 10 c0       	push   $0xc0105f76
c0103097:	68 e5 00 00 00       	push   $0xe5
c010309c:	68 8b 5f 10 c0       	push   $0xc0105f8b
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
c01030bd:	e8 bc 0a 00 00       	call   c0103b7e <alloc_pages>
c01030c2:	83 c4 10             	add    $0x10,%esp
c01030c5:	85 c0                	test   %eax,%eax
c01030c7:	74 19                	je     c01030e2 <basic_check+0x25d>
c01030c9:	68 0e 61 10 c0       	push   $0xc010610e
c01030ce:	68 76 5f 10 c0       	push   $0xc0105f76
c01030d3:	68 ea 00 00 00       	push   $0xea
c01030d8:	68 8b 5f 10 c0       	push   $0xc0105f8b
c01030dd:	e8 ec da ff ff       	call   c0100bce <__panic>

    free_page(p0);
c01030e2:	83 ec 08             	sub    $0x8,%esp
c01030e5:	6a 01                	push   $0x1
c01030e7:	ff 75 ec             	pushl  -0x14(%ebp)
c01030ea:	e8 cd 0a 00 00       	call   c0103bbc <free_pages>
c01030ef:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c01030f2:	83 ec 08             	sub    $0x8,%esp
c01030f5:	6a 01                	push   $0x1
c01030f7:	ff 75 f0             	pushl  -0x10(%ebp)
c01030fa:	e8 bd 0a 00 00       	call   c0103bbc <free_pages>
c01030ff:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0103102:	83 ec 08             	sub    $0x8,%esp
c0103105:	6a 01                	push   $0x1
c0103107:	ff 75 f4             	pushl  -0xc(%ebp)
c010310a:	e8 ad 0a 00 00       	call   c0103bbc <free_pages>
c010310f:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
c0103112:	a1 18 bf 11 c0       	mov    0xc011bf18,%eax
c0103117:	83 f8 03             	cmp    $0x3,%eax
c010311a:	74 19                	je     c0103135 <basic_check+0x2b0>
c010311c:	68 23 61 10 c0       	push   $0xc0106123
c0103121:	68 76 5f 10 c0       	push   $0xc0105f76
c0103126:	68 ef 00 00 00       	push   $0xef
c010312b:	68 8b 5f 10 c0       	push   $0xc0105f8b
c0103130:	e8 99 da ff ff       	call   c0100bce <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103135:	83 ec 0c             	sub    $0xc,%esp
c0103138:	6a 01                	push   $0x1
c010313a:	e8 3f 0a 00 00       	call   c0103b7e <alloc_pages>
c010313f:	83 c4 10             	add    $0x10,%esp
c0103142:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103145:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103149:	75 19                	jne    c0103164 <basic_check+0x2df>
c010314b:	68 e9 5f 10 c0       	push   $0xc0105fe9
c0103150:	68 76 5f 10 c0       	push   $0xc0105f76
c0103155:	68 f1 00 00 00       	push   $0xf1
c010315a:	68 8b 5f 10 c0       	push   $0xc0105f8b
c010315f:	e8 6a da ff ff       	call   c0100bce <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103164:	83 ec 0c             	sub    $0xc,%esp
c0103167:	6a 01                	push   $0x1
c0103169:	e8 10 0a 00 00       	call   c0103b7e <alloc_pages>
c010316e:	83 c4 10             	add    $0x10,%esp
c0103171:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103174:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103178:	75 19                	jne    c0103193 <basic_check+0x30e>
c010317a:	68 05 60 10 c0       	push   $0xc0106005
c010317f:	68 76 5f 10 c0       	push   $0xc0105f76
c0103184:	68 f2 00 00 00       	push   $0xf2
c0103189:	68 8b 5f 10 c0       	push   $0xc0105f8b
c010318e:	e8 3b da ff ff       	call   c0100bce <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103193:	83 ec 0c             	sub    $0xc,%esp
c0103196:	6a 01                	push   $0x1
c0103198:	e8 e1 09 00 00       	call   c0103b7e <alloc_pages>
c010319d:	83 c4 10             	add    $0x10,%esp
c01031a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01031a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01031a7:	75 19                	jne    c01031c2 <basic_check+0x33d>
c01031a9:	68 21 60 10 c0       	push   $0xc0106021
c01031ae:	68 76 5f 10 c0       	push   $0xc0105f76
c01031b3:	68 f3 00 00 00       	push   $0xf3
c01031b8:	68 8b 5f 10 c0       	push   $0xc0105f8b
c01031bd:	e8 0c da ff ff       	call   c0100bce <__panic>

    assert(alloc_page() == NULL);
c01031c2:	83 ec 0c             	sub    $0xc,%esp
c01031c5:	6a 01                	push   $0x1
c01031c7:	e8 b2 09 00 00       	call   c0103b7e <alloc_pages>
c01031cc:	83 c4 10             	add    $0x10,%esp
c01031cf:	85 c0                	test   %eax,%eax
c01031d1:	74 19                	je     c01031ec <basic_check+0x367>
c01031d3:	68 0e 61 10 c0       	push   $0xc010610e
c01031d8:	68 76 5f 10 c0       	push   $0xc0105f76
c01031dd:	68 f5 00 00 00       	push   $0xf5
c01031e2:	68 8b 5f 10 c0       	push   $0xc0105f8b
c01031e7:	e8 e2 d9 ff ff       	call   c0100bce <__panic>

    free_page(p0);
c01031ec:	83 ec 08             	sub    $0x8,%esp
c01031ef:	6a 01                	push   $0x1
c01031f1:	ff 75 ec             	pushl  -0x14(%ebp)
c01031f4:	e8 c3 09 00 00       	call   c0103bbc <free_pages>
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
c0103216:	68 30 61 10 c0       	push   $0xc0106130
c010321b:	68 76 5f 10 c0       	push   $0xc0105f76
c0103220:	68 f8 00 00 00       	push   $0xf8
c0103225:	68 8b 5f 10 c0       	push   $0xc0105f8b
c010322a:	e8 9f d9 ff ff       	call   c0100bce <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c010322f:	83 ec 0c             	sub    $0xc,%esp
c0103232:	6a 01                	push   $0x1
c0103234:	e8 45 09 00 00       	call   c0103b7e <alloc_pages>
c0103239:	83 c4 10             	add    $0x10,%esp
c010323c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010323f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103242:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103245:	74 19                	je     c0103260 <basic_check+0x3db>
c0103247:	68 48 61 10 c0       	push   $0xc0106148
c010324c:	68 76 5f 10 c0       	push   $0xc0105f76
c0103251:	68 fb 00 00 00       	push   $0xfb
c0103256:	68 8b 5f 10 c0       	push   $0xc0105f8b
c010325b:	e8 6e d9 ff ff       	call   c0100bce <__panic>
    assert(alloc_page() == NULL);
c0103260:	83 ec 0c             	sub    $0xc,%esp
c0103263:	6a 01                	push   $0x1
c0103265:	e8 14 09 00 00       	call   c0103b7e <alloc_pages>
c010326a:	83 c4 10             	add    $0x10,%esp
c010326d:	85 c0                	test   %eax,%eax
c010326f:	74 19                	je     c010328a <basic_check+0x405>
c0103271:	68 0e 61 10 c0       	push   $0xc010610e
c0103276:	68 76 5f 10 c0       	push   $0xc0105f76
c010327b:	68 fc 00 00 00       	push   $0xfc
c0103280:	68 8b 5f 10 c0       	push   $0xc0105f8b
c0103285:	e8 44 d9 ff ff       	call   c0100bce <__panic>

    assert(nr_free == 0);
c010328a:	a1 18 bf 11 c0       	mov    0xc011bf18,%eax
c010328f:	85 c0                	test   %eax,%eax
c0103291:	74 19                	je     c01032ac <basic_check+0x427>
c0103293:	68 61 61 10 c0       	push   $0xc0106161
c0103298:	68 76 5f 10 c0       	push   $0xc0105f76
c010329d:	68 fe 00 00 00       	push   $0xfe
c01032a2:	68 8b 5f 10 c0       	push   $0xc0105f8b
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
c01032cd:	e8 ea 08 00 00       	call   c0103bbc <free_pages>
c01032d2:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c01032d5:	83 ec 08             	sub    $0x8,%esp
c01032d8:	6a 01                	push   $0x1
c01032da:	ff 75 f0             	pushl  -0x10(%ebp)
c01032dd:	e8 da 08 00 00       	call   c0103bbc <free_pages>
c01032e2:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c01032e5:	83 ec 08             	sub    $0x8,%esp
c01032e8:	6a 01                	push   $0x1
c01032ea:	ff 75 f4             	pushl  -0xc(%ebp)
c01032ed:	e8 ca 08 00 00       	call   c0103bbc <free_pages>
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
c010334d:	68 6e 61 10 c0       	push   $0xc010616e
c0103352:	68 76 5f 10 c0       	push   $0xc0105f76
c0103357:	68 0f 01 00 00       	push   $0x10f
c010335c:	68 8b 5f 10 c0       	push   $0xc0105f8b
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
c010338f:	e8 5d 08 00 00       	call   c0103bf1 <nr_free_pages>
c0103394:	89 c2                	mov    %eax,%edx
c0103396:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103399:	39 c2                	cmp    %eax,%edx
c010339b:	74 19                	je     c01033b6 <default_check+0xbe>
c010339d:	68 7e 61 10 c0       	push   $0xc010617e
c01033a2:	68 76 5f 10 c0       	push   $0xc0105f76
c01033a7:	68 12 01 00 00       	push   $0x112
c01033ac:	68 8b 5f 10 c0       	push   $0xc0105f8b
c01033b1:	e8 18 d8 ff ff       	call   c0100bce <__panic>

    basic_check();
c01033b6:	e8 ca fa ff ff       	call   c0102e85 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c01033bb:	83 ec 0c             	sub    $0xc,%esp
c01033be:	6a 05                	push   $0x5
c01033c0:	e8 b9 07 00 00       	call   c0103b7e <alloc_pages>
c01033c5:	83 c4 10             	add    $0x10,%esp
c01033c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c01033cb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01033cf:	75 19                	jne    c01033ea <default_check+0xf2>
c01033d1:	68 97 61 10 c0       	push   $0xc0106197
c01033d6:	68 76 5f 10 c0       	push   $0xc0105f76
c01033db:	68 17 01 00 00       	push   $0x117
c01033e0:	68 8b 5f 10 c0       	push   $0xc0105f8b
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
c0103416:	68 a2 61 10 c0       	push   $0xc01061a2
c010341b:	68 76 5f 10 c0       	push   $0xc0105f76
c0103420:	68 18 01 00 00       	push   $0x118
c0103425:	68 8b 5f 10 c0       	push   $0xc0105f8b
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
c0103475:	68 f7 60 10 c0       	push   $0xc01060f7
c010347a:	68 76 5f 10 c0       	push   $0xc0105f76
c010347f:	68 1c 01 00 00       	push   $0x11c
c0103484:	68 8b 5f 10 c0       	push   $0xc0105f8b
c0103489:	e8 40 d7 ff ff       	call   c0100bce <__panic>
    assert(alloc_page() == NULL);
c010348e:	83 ec 0c             	sub    $0xc,%esp
c0103491:	6a 01                	push   $0x1
c0103493:	e8 e6 06 00 00       	call   c0103b7e <alloc_pages>
c0103498:	83 c4 10             	add    $0x10,%esp
c010349b:	85 c0                	test   %eax,%eax
c010349d:	74 19                	je     c01034b8 <default_check+0x1c0>
c010349f:	68 0e 61 10 c0       	push   $0xc010610e
c01034a4:	68 76 5f 10 c0       	push   $0xc0105f76
c01034a9:	68 1d 01 00 00       	push   $0x11d
c01034ae:	68 8b 5f 10 c0       	push   $0xc0105f8b
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
c01034d6:	e8 e1 06 00 00       	call   c0103bbc <free_pages>
c01034db:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
c01034de:	83 ec 0c             	sub    $0xc,%esp
c01034e1:	6a 04                	push   $0x4
c01034e3:	e8 96 06 00 00       	call   c0103b7e <alloc_pages>
c01034e8:	83 c4 10             	add    $0x10,%esp
c01034eb:	85 c0                	test   %eax,%eax
c01034ed:	74 19                	je     c0103508 <default_check+0x210>
c01034ef:	68 b4 61 10 c0       	push   $0xc01061b4
c01034f4:	68 76 5f 10 c0       	push   $0xc0105f76
c01034f9:	68 23 01 00 00       	push   $0x123
c01034fe:	68 8b 5f 10 c0       	push   $0xc0105f8b
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
c0103545:	68 cc 61 10 c0       	push   $0xc01061cc
c010354a:	68 76 5f 10 c0       	push   $0xc0105f76
c010354f:	68 24 01 00 00       	push   $0x124
c0103554:	68 8b 5f 10 c0       	push   $0xc0105f8b
c0103559:	e8 70 d6 ff ff       	call   c0100bce <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c010355e:	83 ec 0c             	sub    $0xc,%esp
c0103561:	6a 03                	push   $0x3
c0103563:	e8 16 06 00 00       	call   c0103b7e <alloc_pages>
c0103568:	83 c4 10             	add    $0x10,%esp
c010356b:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010356e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103572:	75 19                	jne    c010358d <default_check+0x295>
c0103574:	68 f8 61 10 c0       	push   $0xc01061f8
c0103579:	68 76 5f 10 c0       	push   $0xc0105f76
c010357e:	68 25 01 00 00       	push   $0x125
c0103583:	68 8b 5f 10 c0       	push   $0xc0105f8b
c0103588:	e8 41 d6 ff ff       	call   c0100bce <__panic>
    assert(alloc_page() == NULL);
c010358d:	83 ec 0c             	sub    $0xc,%esp
c0103590:	6a 01                	push   $0x1
c0103592:	e8 e7 05 00 00       	call   c0103b7e <alloc_pages>
c0103597:	83 c4 10             	add    $0x10,%esp
c010359a:	85 c0                	test   %eax,%eax
c010359c:	74 19                	je     c01035b7 <default_check+0x2bf>
c010359e:	68 0e 61 10 c0       	push   $0xc010610e
c01035a3:	68 76 5f 10 c0       	push   $0xc0105f76
c01035a8:	68 26 01 00 00       	push   $0x126
c01035ad:	68 8b 5f 10 c0       	push   $0xc0105f8b
c01035b2:	e8 17 d6 ff ff       	call   c0100bce <__panic>
    assert(p0 + 2 == p1);
c01035b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035ba:	83 c0 28             	add    $0x28,%eax
c01035bd:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01035c0:	74 19                	je     c01035db <default_check+0x2e3>
c01035c2:	68 16 62 10 c0       	push   $0xc0106216
c01035c7:	68 76 5f 10 c0       	push   $0xc0105f76
c01035cc:	68 27 01 00 00       	push   $0x127
c01035d1:	68 8b 5f 10 c0       	push   $0xc0105f8b
c01035d6:	e8 f3 d5 ff ff       	call   c0100bce <__panic>

    p2 = p0 + 1;
c01035db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035de:	83 c0 14             	add    $0x14,%eax
c01035e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c01035e4:	83 ec 08             	sub    $0x8,%esp
c01035e7:	6a 01                	push   $0x1
c01035e9:	ff 75 e4             	pushl  -0x1c(%ebp)
c01035ec:	e8 cb 05 00 00       	call   c0103bbc <free_pages>
c01035f1:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
c01035f4:	83 ec 08             	sub    $0x8,%esp
c01035f7:	6a 03                	push   $0x3
c01035f9:	ff 75 dc             	pushl  -0x24(%ebp)
c01035fc:	e8 bb 05 00 00       	call   c0103bbc <free_pages>
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
c010363b:	68 24 62 10 c0       	push   $0xc0106224
c0103640:	68 76 5f 10 c0       	push   $0xc0105f76
c0103645:	68 2c 01 00 00       	push   $0x12c
c010364a:	68 8b 5f 10 c0       	push   $0xc0105f8b
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
c010368b:	68 4c 62 10 c0       	push   $0xc010624c
c0103690:	68 76 5f 10 c0       	push   $0xc0105f76
c0103695:	68 2d 01 00 00       	push   $0x12d
c010369a:	68 8b 5f 10 c0       	push   $0xc0105f8b
c010369f:	e8 2a d5 ff ff       	call   c0100bce <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01036a4:	83 ec 0c             	sub    $0xc,%esp
c01036a7:	6a 01                	push   $0x1
c01036a9:	e8 d0 04 00 00       	call   c0103b7e <alloc_pages>
c01036ae:	83 c4 10             	add    $0x10,%esp
c01036b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01036b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01036b7:	83 e8 14             	sub    $0x14,%eax
c01036ba:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01036bd:	74 19                	je     c01036d8 <default_check+0x3e0>
c01036bf:	68 72 62 10 c0       	push   $0xc0106272
c01036c4:	68 76 5f 10 c0       	push   $0xc0105f76
c01036c9:	68 2f 01 00 00       	push   $0x12f
c01036ce:	68 8b 5f 10 c0       	push   $0xc0105f8b
c01036d3:	e8 f6 d4 ff ff       	call   c0100bce <__panic>
    free_page(p0);
c01036d8:	83 ec 08             	sub    $0x8,%esp
c01036db:	6a 01                	push   $0x1
c01036dd:	ff 75 e4             	pushl  -0x1c(%ebp)
c01036e0:	e8 d7 04 00 00       	call   c0103bbc <free_pages>
c01036e5:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01036e8:	83 ec 0c             	sub    $0xc,%esp
c01036eb:	6a 02                	push   $0x2
c01036ed:	e8 8c 04 00 00       	call   c0103b7e <alloc_pages>
c01036f2:	83 c4 10             	add    $0x10,%esp
c01036f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01036f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01036fb:	83 c0 14             	add    $0x14,%eax
c01036fe:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103701:	74 19                	je     c010371c <default_check+0x424>
c0103703:	68 90 62 10 c0       	push   $0xc0106290
c0103708:	68 76 5f 10 c0       	push   $0xc0105f76
c010370d:	68 31 01 00 00       	push   $0x131
c0103712:	68 8b 5f 10 c0       	push   $0xc0105f8b
c0103717:	e8 b2 d4 ff ff       	call   c0100bce <__panic>

    free_pages(p0, 2);
c010371c:	83 ec 08             	sub    $0x8,%esp
c010371f:	6a 02                	push   $0x2
c0103721:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103724:	e8 93 04 00 00       	call   c0103bbc <free_pages>
c0103729:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c010372c:	83 ec 08             	sub    $0x8,%esp
c010372f:	6a 01                	push   $0x1
c0103731:	ff 75 d8             	pushl  -0x28(%ebp)
c0103734:	e8 83 04 00 00       	call   c0103bbc <free_pages>
c0103739:	83 c4 10             	add    $0x10,%esp

    assert((p0 = alloc_pages(5)) != NULL);
c010373c:	83 ec 0c             	sub    $0xc,%esp
c010373f:	6a 05                	push   $0x5
c0103741:	e8 38 04 00 00       	call   c0103b7e <alloc_pages>
c0103746:	83 c4 10             	add    $0x10,%esp
c0103749:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010374c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103750:	75 19                	jne    c010376b <default_check+0x473>
c0103752:	68 b0 62 10 c0       	push   $0xc01062b0
c0103757:	68 76 5f 10 c0       	push   $0xc0105f76
c010375c:	68 36 01 00 00       	push   $0x136
c0103761:	68 8b 5f 10 c0       	push   $0xc0105f8b
c0103766:	e8 63 d4 ff ff       	call   c0100bce <__panic>
    assert(alloc_page() == NULL);
c010376b:	83 ec 0c             	sub    $0xc,%esp
c010376e:	6a 01                	push   $0x1
c0103770:	e8 09 04 00 00       	call   c0103b7e <alloc_pages>
c0103775:	83 c4 10             	add    $0x10,%esp
c0103778:	85 c0                	test   %eax,%eax
c010377a:	74 19                	je     c0103795 <default_check+0x49d>
c010377c:	68 0e 61 10 c0       	push   $0xc010610e
c0103781:	68 76 5f 10 c0       	push   $0xc0105f76
c0103786:	68 37 01 00 00       	push   $0x137
c010378b:	68 8b 5f 10 c0       	push   $0xc0105f8b
c0103790:	e8 39 d4 ff ff       	call   c0100bce <__panic>

    assert(nr_free == 0);
c0103795:	a1 18 bf 11 c0       	mov    0xc011bf18,%eax
c010379a:	85 c0                	test   %eax,%eax
c010379c:	74 19                	je     c01037b7 <default_check+0x4bf>
c010379e:	68 61 61 10 c0       	push   $0xc0106161
c01037a3:	68 76 5f 10 c0       	push   $0xc0105f76
c01037a8:	68 39 01 00 00       	push   $0x139
c01037ad:	68 8b 5f 10 c0       	push   $0xc0105f8b
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
c01037d8:	e8 df 03 00 00       	call   c0103bbc <free_pages>
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
c0103823:	68 ce 62 10 c0       	push   $0xc01062ce
c0103828:	68 76 5f 10 c0       	push   $0xc0105f76
c010382d:	68 44 01 00 00       	push   $0x144
c0103832:	68 8b 5f 10 c0       	push   $0xc0105f8b
c0103837:	e8 92 d3 ff ff       	call   c0100bce <__panic>
    assert(total == 0);
c010383c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103840:	74 19                	je     c010385b <default_check+0x563>
c0103842:	68 d9 62 10 c0       	push   $0xc01062d9
c0103847:	68 76 5f 10 c0       	push   $0xc0105f76
c010384c:	68 45 01 00 00       	push   $0x145
c0103851:	68 8b 5f 10 c0       	push   $0xc0105f8b
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
c01038c8:	68 14 63 10 c0       	push   $0xc0106314
c01038cd:	6a 5a                	push   $0x5a
c01038cf:	68 33 63 10 c0       	push   $0xc0106333
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
c010391f:	68 44 63 10 c0       	push   $0xc0106344
c0103924:	6a 61                	push   $0x61
c0103926:	68 33 63 10 c0       	push   $0xc0106333
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
c010394d:	68 68 63 10 c0       	push   $0xc0106368
c0103952:	6a 6c                	push   $0x6c
c0103954:	68 33 63 10 c0       	push   $0xc0106333
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

c010399a <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c010399a:	55                   	push   %ebp
c010399b:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c010399d:	8b 45 08             	mov    0x8(%ebp),%eax
c01039a0:	8b 00                	mov    (%eax),%eax
c01039a2:	8d 50 01             	lea    0x1(%eax),%edx
c01039a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01039a8:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01039aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01039ad:	8b 00                	mov    (%eax),%eax
}
c01039af:	5d                   	pop    %ebp
c01039b0:	c3                   	ret    

c01039b1 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c01039b1:	55                   	push   %ebp
c01039b2:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c01039b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01039b7:	8b 00                	mov    (%eax),%eax
c01039b9:	8d 50 ff             	lea    -0x1(%eax),%edx
c01039bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01039bf:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01039c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01039c4:	8b 00                	mov    (%eax),%eax
}
c01039c6:	5d                   	pop    %ebp
c01039c7:	c3                   	ret    

c01039c8 <__intr_save>:
__intr_save(void) {
c01039c8:	55                   	push   %ebp
c01039c9:	89 e5                	mov    %esp,%ebp
c01039cb:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01039ce:	9c                   	pushf  
c01039cf:	58                   	pop    %eax
c01039d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01039d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01039d6:	25 00 02 00 00       	and    $0x200,%eax
c01039db:	85 c0                	test   %eax,%eax
c01039dd:	74 0c                	je     c01039eb <__intr_save+0x23>
        intr_disable();
c01039df:	e8 b4 db ff ff       	call   c0101598 <intr_disable>
        return 1;
c01039e4:	b8 01 00 00 00       	mov    $0x1,%eax
c01039e9:	eb 05                	jmp    c01039f0 <__intr_save+0x28>
    return 0;
c01039eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01039f0:	c9                   	leave  
c01039f1:	c3                   	ret    

c01039f2 <__intr_restore>:
__intr_restore(bool flag) {
c01039f2:	55                   	push   %ebp
c01039f3:	89 e5                	mov    %esp,%ebp
c01039f5:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01039f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01039fc:	74 05                	je     c0103a03 <__intr_restore+0x11>
        intr_enable();
c01039fe:	e8 8e db ff ff       	call   c0101591 <intr_enable>
}
c0103a03:	90                   	nop
c0103a04:	c9                   	leave  
c0103a05:	c3                   	ret    

c0103a06 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103a06:	55                   	push   %ebp
c0103a07:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103a09:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a0c:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103a0f:	b8 23 00 00 00       	mov    $0x23,%eax
c0103a14:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103a16:	b8 23 00 00 00       	mov    $0x23,%eax
c0103a1b:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103a1d:	b8 10 00 00 00       	mov    $0x10,%eax
c0103a22:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103a24:	b8 10 00 00 00       	mov    $0x10,%eax
c0103a29:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103a2b:	b8 10 00 00 00       	mov    $0x10,%eax
c0103a30:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103a32:	ea 39 3a 10 c0 08 00 	ljmp   $0x8,$0xc0103a39
}
c0103a39:	90                   	nop
c0103a3a:	5d                   	pop    %ebp
c0103a3b:	c3                   	ret    

c0103a3c <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103a3c:	55                   	push   %ebp
c0103a3d:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103a3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a42:	a3 a4 be 11 c0       	mov    %eax,0xc011bea4
}
c0103a47:	90                   	nop
c0103a48:	5d                   	pop    %ebp
c0103a49:	c3                   	ret    

c0103a4a <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103a4a:	55                   	push   %ebp
c0103a4b:	89 e5                	mov    %esp,%ebp
c0103a4d:	83 ec 10             	sub    $0x10,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103a50:	b8 00 80 11 c0       	mov    $0xc0118000,%eax
c0103a55:	50                   	push   %eax
c0103a56:	e8 e1 ff ff ff       	call   c0103a3c <load_esp0>
c0103a5b:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
c0103a5e:	66 c7 05 a8 be 11 c0 	movw   $0x10,0xc011bea8
c0103a65:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103a67:	66 c7 05 28 8a 11 c0 	movw   $0x68,0xc0118a28
c0103a6e:	68 00 
c0103a70:	b8 a0 be 11 c0       	mov    $0xc011bea0,%eax
c0103a75:	66 a3 2a 8a 11 c0    	mov    %ax,0xc0118a2a
c0103a7b:	b8 a0 be 11 c0       	mov    $0xc011bea0,%eax
c0103a80:	c1 e8 10             	shr    $0x10,%eax
c0103a83:	a2 2c 8a 11 c0       	mov    %al,0xc0118a2c
c0103a88:	a0 2d 8a 11 c0       	mov    0xc0118a2d,%al
c0103a8d:	83 e0 f0             	and    $0xfffffff0,%eax
c0103a90:	83 c8 09             	or     $0x9,%eax
c0103a93:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103a98:	a0 2d 8a 11 c0       	mov    0xc0118a2d,%al
c0103a9d:	83 e0 ef             	and    $0xffffffef,%eax
c0103aa0:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103aa5:	a0 2d 8a 11 c0       	mov    0xc0118a2d,%al
c0103aaa:	83 e0 9f             	and    $0xffffff9f,%eax
c0103aad:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103ab2:	a0 2d 8a 11 c0       	mov    0xc0118a2d,%al
c0103ab7:	83 c8 80             	or     $0xffffff80,%eax
c0103aba:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103abf:	a0 2e 8a 11 c0       	mov    0xc0118a2e,%al
c0103ac4:	83 e0 f0             	and    $0xfffffff0,%eax
c0103ac7:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103acc:	a0 2e 8a 11 c0       	mov    0xc0118a2e,%al
c0103ad1:	83 e0 ef             	and    $0xffffffef,%eax
c0103ad4:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103ad9:	a0 2e 8a 11 c0       	mov    0xc0118a2e,%al
c0103ade:	83 e0 df             	and    $0xffffffdf,%eax
c0103ae1:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103ae6:	a0 2e 8a 11 c0       	mov    0xc0118a2e,%al
c0103aeb:	83 c8 40             	or     $0x40,%eax
c0103aee:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103af3:	a0 2e 8a 11 c0       	mov    0xc0118a2e,%al
c0103af8:	83 e0 7f             	and    $0x7f,%eax
c0103afb:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103b00:	b8 a0 be 11 c0       	mov    $0xc011bea0,%eax
c0103b05:	c1 e8 18             	shr    $0x18,%eax
c0103b08:	a2 2f 8a 11 c0       	mov    %al,0xc0118a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103b0d:	68 30 8a 11 c0       	push   $0xc0118a30
c0103b12:	e8 ef fe ff ff       	call   c0103a06 <lgdt>
c0103b17:	83 c4 04             	add    $0x4,%esp
c0103b1a:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103b20:	66 8b 45 fe          	mov    -0x2(%ebp),%ax
c0103b24:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103b27:	90                   	nop
c0103b28:	c9                   	leave  
c0103b29:	c3                   	ret    

c0103b2a <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103b2a:	55                   	push   %ebp
c0103b2b:	89 e5                	mov    %esp,%ebp
c0103b2d:	83 ec 08             	sub    $0x8,%esp
    pmm_manager = &default_pmm_manager;
c0103b30:	c7 05 1c bf 11 c0 f8 	movl   $0xc01062f8,0xc011bf1c
c0103b37:	62 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103b3a:	a1 1c bf 11 c0       	mov    0xc011bf1c,%eax
c0103b3f:	8b 00                	mov    (%eax),%eax
c0103b41:	83 ec 08             	sub    $0x8,%esp
c0103b44:	50                   	push   %eax
c0103b45:	68 94 63 10 c0       	push   $0xc0106394
c0103b4a:	e8 e8 c7 ff ff       	call   c0100337 <cprintf>
c0103b4f:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
c0103b52:	a1 1c bf 11 c0       	mov    0xc011bf1c,%eax
c0103b57:	8b 40 04             	mov    0x4(%eax),%eax
c0103b5a:	ff d0                	call   *%eax
}
c0103b5c:	90                   	nop
c0103b5d:	c9                   	leave  
c0103b5e:	c3                   	ret    

c0103b5f <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103b5f:	55                   	push   %ebp
c0103b60:	89 e5                	mov    %esp,%ebp
c0103b62:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->init_memmap(base, n);
c0103b65:	a1 1c bf 11 c0       	mov    0xc011bf1c,%eax
c0103b6a:	8b 40 08             	mov    0x8(%eax),%eax
c0103b6d:	83 ec 08             	sub    $0x8,%esp
c0103b70:	ff 75 0c             	pushl  0xc(%ebp)
c0103b73:	ff 75 08             	pushl  0x8(%ebp)
c0103b76:	ff d0                	call   *%eax
c0103b78:	83 c4 10             	add    $0x10,%esp
}
c0103b7b:	90                   	nop
c0103b7c:	c9                   	leave  
c0103b7d:	c3                   	ret    

c0103b7e <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103b7e:	55                   	push   %ebp
c0103b7f:	89 e5                	mov    %esp,%ebp
c0103b81:	83 ec 18             	sub    $0x18,%esp
    struct Page *page=NULL;
c0103b84:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103b8b:	e8 38 fe ff ff       	call   c01039c8 <__intr_save>
c0103b90:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103b93:	a1 1c bf 11 c0       	mov    0xc011bf1c,%eax
c0103b98:	8b 40 0c             	mov    0xc(%eax),%eax
c0103b9b:	83 ec 0c             	sub    $0xc,%esp
c0103b9e:	ff 75 08             	pushl  0x8(%ebp)
c0103ba1:	ff d0                	call   *%eax
c0103ba3:	83 c4 10             	add    $0x10,%esp
c0103ba6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103ba9:	83 ec 0c             	sub    $0xc,%esp
c0103bac:	ff 75 f0             	pushl  -0x10(%ebp)
c0103baf:	e8 3e fe ff ff       	call   c01039f2 <__intr_restore>
c0103bb4:	83 c4 10             	add    $0x10,%esp
    return page;
c0103bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103bba:	c9                   	leave  
c0103bbb:	c3                   	ret    

c0103bbc <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103bbc:	55                   	push   %ebp
c0103bbd:	89 e5                	mov    %esp,%ebp
c0103bbf:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103bc2:	e8 01 fe ff ff       	call   c01039c8 <__intr_save>
c0103bc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103bca:	a1 1c bf 11 c0       	mov    0xc011bf1c,%eax
c0103bcf:	8b 40 10             	mov    0x10(%eax),%eax
c0103bd2:	83 ec 08             	sub    $0x8,%esp
c0103bd5:	ff 75 0c             	pushl  0xc(%ebp)
c0103bd8:	ff 75 08             	pushl  0x8(%ebp)
c0103bdb:	ff d0                	call   *%eax
c0103bdd:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c0103be0:	83 ec 0c             	sub    $0xc,%esp
c0103be3:	ff 75 f4             	pushl  -0xc(%ebp)
c0103be6:	e8 07 fe ff ff       	call   c01039f2 <__intr_restore>
c0103beb:	83 c4 10             	add    $0x10,%esp
}
c0103bee:	90                   	nop
c0103bef:	c9                   	leave  
c0103bf0:	c3                   	ret    

c0103bf1 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103bf1:	55                   	push   %ebp
c0103bf2:	89 e5                	mov    %esp,%ebp
c0103bf4:	83 ec 18             	sub    $0x18,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103bf7:	e8 cc fd ff ff       	call   c01039c8 <__intr_save>
c0103bfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103bff:	a1 1c bf 11 c0       	mov    0xc011bf1c,%eax
c0103c04:	8b 40 14             	mov    0x14(%eax),%eax
c0103c07:	ff d0                	call   *%eax
c0103c09:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103c0c:	83 ec 0c             	sub    $0xc,%esp
c0103c0f:	ff 75 f4             	pushl  -0xc(%ebp)
c0103c12:	e8 db fd ff ff       	call   c01039f2 <__intr_restore>
c0103c17:	83 c4 10             	add    $0x10,%esp
    return ret;
c0103c1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103c1d:	c9                   	leave  
c0103c1e:	c3                   	ret    

c0103c1f <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103c1f:	55                   	push   %ebp
c0103c20:	89 e5                	mov    %esp,%ebp
c0103c22:	57                   	push   %edi
c0103c23:	56                   	push   %esi
c0103c24:	53                   	push   %ebx
c0103c25:	83 ec 7c             	sub    $0x7c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103c28:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103c2f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103c36:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103c3d:	83 ec 0c             	sub    $0xc,%esp
c0103c40:	68 ab 63 10 c0       	push   $0xc01063ab
c0103c45:	e8 ed c6 ff ff       	call   c0100337 <cprintf>
c0103c4a:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103c4d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103c54:	e9 f3 00 00 00       	jmp    c0103d4c <page_init+0x12d>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103c59:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103c5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103c5f:	89 d0                	mov    %edx,%eax
c0103c61:	c1 e0 02             	shl    $0x2,%eax
c0103c64:	01 d0                	add    %edx,%eax
c0103c66:	c1 e0 02             	shl    $0x2,%eax
c0103c69:	01 c8                	add    %ecx,%eax
c0103c6b:	8b 50 08             	mov    0x8(%eax),%edx
c0103c6e:	8b 40 04             	mov    0x4(%eax),%eax
c0103c71:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103c74:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103c77:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103c7a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103c7d:	89 d0                	mov    %edx,%eax
c0103c7f:	c1 e0 02             	shl    $0x2,%eax
c0103c82:	01 d0                	add    %edx,%eax
c0103c84:	c1 e0 02             	shl    $0x2,%eax
c0103c87:	01 c8                	add    %ecx,%eax
c0103c89:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103c8c:	8b 58 10             	mov    0x10(%eax),%ebx
c0103c8f:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103c92:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103c95:	01 c8                	add    %ecx,%eax
c0103c97:	11 da                	adc    %ebx,%edx
c0103c99:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103c9c:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103c9f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103ca2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ca5:	89 d0                	mov    %edx,%eax
c0103ca7:	c1 e0 02             	shl    $0x2,%eax
c0103caa:	01 d0                	add    %edx,%eax
c0103cac:	c1 e0 02             	shl    $0x2,%eax
c0103caf:	01 c8                	add    %ecx,%eax
c0103cb1:	83 c0 14             	add    $0x14,%eax
c0103cb4:	8b 00                	mov    (%eax),%eax
c0103cb6:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0103cb9:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103cbc:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103cbf:	83 c0 ff             	add    $0xffffffff,%eax
c0103cc2:	83 d2 ff             	adc    $0xffffffff,%edx
c0103cc5:	89 c1                	mov    %eax,%ecx
c0103cc7:	89 d3                	mov    %edx,%ebx
c0103cc9:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0103ccc:	89 55 80             	mov    %edx,-0x80(%ebp)
c0103ccf:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103cd2:	89 d0                	mov    %edx,%eax
c0103cd4:	c1 e0 02             	shl    $0x2,%eax
c0103cd7:	01 d0                	add    %edx,%eax
c0103cd9:	c1 e0 02             	shl    $0x2,%eax
c0103cdc:	03 45 80             	add    -0x80(%ebp),%eax
c0103cdf:	8b 50 10             	mov    0x10(%eax),%edx
c0103ce2:	8b 40 0c             	mov    0xc(%eax),%eax
c0103ce5:	ff 75 84             	pushl  -0x7c(%ebp)
c0103ce8:	53                   	push   %ebx
c0103ce9:	51                   	push   %ecx
c0103cea:	ff 75 bc             	pushl  -0x44(%ebp)
c0103ced:	ff 75 b8             	pushl  -0x48(%ebp)
c0103cf0:	52                   	push   %edx
c0103cf1:	50                   	push   %eax
c0103cf2:	68 b8 63 10 c0       	push   $0xc01063b8
c0103cf7:	e8 3b c6 ff ff       	call   c0100337 <cprintf>
c0103cfc:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103cff:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103d02:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103d05:	89 d0                	mov    %edx,%eax
c0103d07:	c1 e0 02             	shl    $0x2,%eax
c0103d0a:	01 d0                	add    %edx,%eax
c0103d0c:	c1 e0 02             	shl    $0x2,%eax
c0103d0f:	01 c8                	add    %ecx,%eax
c0103d11:	83 c0 14             	add    $0x14,%eax
c0103d14:	8b 00                	mov    (%eax),%eax
c0103d16:	83 f8 01             	cmp    $0x1,%eax
c0103d19:	75 2e                	jne    c0103d49 <page_init+0x12a>
            if (maxpa < end && begin < KMEMSIZE) {
c0103d1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103d1e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103d21:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0103d24:	89 d0                	mov    %edx,%eax
c0103d26:	1b 45 b4             	sbb    -0x4c(%ebp),%eax
c0103d29:	73 1e                	jae    c0103d49 <page_init+0x12a>
c0103d2b:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
c0103d30:	b8 00 00 00 00       	mov    $0x0,%eax
c0103d35:	3b 55 b8             	cmp    -0x48(%ebp),%edx
c0103d38:	1b 45 bc             	sbb    -0x44(%ebp),%eax
c0103d3b:	72 0c                	jb     c0103d49 <page_init+0x12a>
                maxpa = end;
c0103d3d:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103d40:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103d43:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103d46:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c0103d49:	ff 45 dc             	incl   -0x24(%ebp)
c0103d4c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103d4f:	8b 00                	mov    (%eax),%eax
c0103d51:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103d54:	0f 8c ff fe ff ff    	jl     c0103c59 <page_init+0x3a>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103d5a:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0103d5f:	b8 00 00 00 00       	mov    $0x0,%eax
c0103d64:	3b 55 e0             	cmp    -0x20(%ebp),%edx
c0103d67:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
c0103d6a:	73 0e                	jae    c0103d7a <page_init+0x15b>
        maxpa = KMEMSIZE;
c0103d6c:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103d73:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0103d7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103d7d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103d80:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103d84:	c1 ea 0c             	shr    $0xc,%edx
c0103d87:	89 c1                	mov    %eax,%ecx
c0103d89:	89 d3                	mov    %edx,%ebx
c0103d8b:	89 c8                	mov    %ecx,%eax
c0103d8d:	a3 80 be 11 c0       	mov    %eax,0xc011be80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103d92:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0103d99:	b8 28 bf 11 c0       	mov    $0xc011bf28,%eax
c0103d9e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103da1:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103da4:	01 d0                	add    %edx,%eax
c0103da6:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103da9:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103dac:	ba 00 00 00 00       	mov    $0x0,%edx
c0103db1:	f7 75 ac             	divl   -0x54(%ebp)
c0103db4:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103db7:	29 d0                	sub    %edx,%eax
c0103db9:	a3 24 bf 11 c0       	mov    %eax,0xc011bf24

    for (i = 0; i < npage; i ++) {
c0103dbe:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103dc5:	eb 2e                	jmp    c0103df5 <page_init+0x1d6>
        SetPageReserved(pages + i);
c0103dc7:	8b 0d 24 bf 11 c0    	mov    0xc011bf24,%ecx
c0103dcd:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103dd0:	89 d0                	mov    %edx,%eax
c0103dd2:	c1 e0 02             	shl    $0x2,%eax
c0103dd5:	01 d0                	add    %edx,%eax
c0103dd7:	c1 e0 02             	shl    $0x2,%eax
c0103dda:	01 c8                	add    %ecx,%eax
c0103ddc:	83 c0 04             	add    $0x4,%eax
c0103ddf:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0103de6:	89 45 8c             	mov    %eax,-0x74(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103de9:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103dec:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103def:	0f ab 10             	bts    %edx,(%eax)
    for (i = 0; i < npage; i ++) {
c0103df2:	ff 45 dc             	incl   -0x24(%ebp)
c0103df5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103df8:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c0103dfd:	39 c2                	cmp    %eax,%edx
c0103dff:	72 c6                	jb     c0103dc7 <page_init+0x1a8>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0103e01:	8b 15 80 be 11 c0    	mov    0xc011be80,%edx
c0103e07:	89 d0                	mov    %edx,%eax
c0103e09:	c1 e0 02             	shl    $0x2,%eax
c0103e0c:	01 d0                	add    %edx,%eax
c0103e0e:	c1 e0 02             	shl    $0x2,%eax
c0103e11:	89 c2                	mov    %eax,%edx
c0103e13:	a1 24 bf 11 c0       	mov    0xc011bf24,%eax
c0103e18:	01 d0                	add    %edx,%eax
c0103e1a:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0103e1d:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0103e24:	77 17                	ja     c0103e3d <page_init+0x21e>
c0103e26:	ff 75 a4             	pushl  -0x5c(%ebp)
c0103e29:	68 e8 63 10 c0       	push   $0xc01063e8
c0103e2e:	68 dc 00 00 00       	push   $0xdc
c0103e33:	68 0c 64 10 c0       	push   $0xc010640c
c0103e38:	e8 91 cd ff ff       	call   c0100bce <__panic>
c0103e3d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103e40:	05 00 00 00 40       	add    $0x40000000,%eax
c0103e45:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0103e48:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103e4f:	e9 58 01 00 00       	jmp    c0103fac <page_init+0x38d>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103e54:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e57:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e5a:	89 d0                	mov    %edx,%eax
c0103e5c:	c1 e0 02             	shl    $0x2,%eax
c0103e5f:	01 d0                	add    %edx,%eax
c0103e61:	c1 e0 02             	shl    $0x2,%eax
c0103e64:	01 c8                	add    %ecx,%eax
c0103e66:	8b 50 08             	mov    0x8(%eax),%edx
c0103e69:	8b 40 04             	mov    0x4(%eax),%eax
c0103e6c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103e6f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103e72:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e75:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e78:	89 d0                	mov    %edx,%eax
c0103e7a:	c1 e0 02             	shl    $0x2,%eax
c0103e7d:	01 d0                	add    %edx,%eax
c0103e7f:	c1 e0 02             	shl    $0x2,%eax
c0103e82:	01 c8                	add    %ecx,%eax
c0103e84:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103e87:	8b 58 10             	mov    0x10(%eax),%ebx
c0103e8a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103e8d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103e90:	01 c8                	add    %ecx,%eax
c0103e92:	11 da                	adc    %ebx,%edx
c0103e94:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0103e97:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0103e9a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e9d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ea0:	89 d0                	mov    %edx,%eax
c0103ea2:	c1 e0 02             	shl    $0x2,%eax
c0103ea5:	01 d0                	add    %edx,%eax
c0103ea7:	c1 e0 02             	shl    $0x2,%eax
c0103eaa:	01 c8                	add    %ecx,%eax
c0103eac:	83 c0 14             	add    $0x14,%eax
c0103eaf:	8b 00                	mov    (%eax),%eax
c0103eb1:	83 f8 01             	cmp    $0x1,%eax
c0103eb4:	0f 85 ef 00 00 00    	jne    c0103fa9 <page_init+0x38a>
            if (begin < freemem) {
c0103eba:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103ebd:	ba 00 00 00 00       	mov    $0x0,%edx
c0103ec2:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0103ec5:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0103ec8:	19 d1                	sbb    %edx,%ecx
c0103eca:	73 0d                	jae    c0103ed9 <page_init+0x2ba>
                begin = freemem;
c0103ecc:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103ecf:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103ed2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0103ed9:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0103ede:	b8 00 00 00 00       	mov    $0x0,%eax
c0103ee3:	3b 55 c8             	cmp    -0x38(%ebp),%edx
c0103ee6:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0103ee9:	73 0e                	jae    c0103ef9 <page_init+0x2da>
                end = KMEMSIZE;
c0103eeb:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0103ef2:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0103ef9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103efc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103eff:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103f02:	89 d0                	mov    %edx,%eax
c0103f04:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0103f07:	0f 83 9c 00 00 00    	jae    c0103fa9 <page_init+0x38a>
                begin = ROUNDUP(begin, PGSIZE);
c0103f0d:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0103f14:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103f17:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103f1a:	01 d0                	add    %edx,%eax
c0103f1c:	48                   	dec    %eax
c0103f1d:	89 45 98             	mov    %eax,-0x68(%ebp)
c0103f20:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103f23:	ba 00 00 00 00       	mov    $0x0,%edx
c0103f28:	f7 75 9c             	divl   -0x64(%ebp)
c0103f2b:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103f2e:	29 d0                	sub    %edx,%eax
c0103f30:	ba 00 00 00 00       	mov    $0x0,%edx
c0103f35:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103f38:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0103f3b:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103f3e:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0103f41:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0103f44:	ba 00 00 00 00       	mov    $0x0,%edx
c0103f49:	89 c3                	mov    %eax,%ebx
c0103f4b:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c0103f51:	89 de                	mov    %ebx,%esi
c0103f53:	89 d0                	mov    %edx,%eax
c0103f55:	83 e0 00             	and    $0x0,%eax
c0103f58:	89 c7                	mov    %eax,%edi
c0103f5a:	89 75 c8             	mov    %esi,-0x38(%ebp)
c0103f5d:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c0103f60:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103f63:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103f66:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103f69:	89 d0                	mov    %edx,%eax
c0103f6b:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0103f6e:	73 39                	jae    c0103fa9 <page_init+0x38a>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0103f70:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103f73:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103f76:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0103f79:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0103f7c:	89 c1                	mov    %eax,%ecx
c0103f7e:	89 d3                	mov    %edx,%ebx
c0103f80:	89 c8                	mov    %ecx,%eax
c0103f82:	89 da                	mov    %ebx,%edx
c0103f84:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103f88:	c1 ea 0c             	shr    $0xc,%edx
c0103f8b:	89 c3                	mov    %eax,%ebx
c0103f8d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103f90:	83 ec 0c             	sub    $0xc,%esp
c0103f93:	50                   	push   %eax
c0103f94:	e8 15 f9 ff ff       	call   c01038ae <pa2page>
c0103f99:	83 c4 10             	add    $0x10,%esp
c0103f9c:	83 ec 08             	sub    $0x8,%esp
c0103f9f:	53                   	push   %ebx
c0103fa0:	50                   	push   %eax
c0103fa1:	e8 b9 fb ff ff       	call   c0103b5f <init_memmap>
c0103fa6:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < memmap->nr_map; i ++) {
c0103fa9:	ff 45 dc             	incl   -0x24(%ebp)
c0103fac:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103faf:	8b 00                	mov    (%eax),%eax
c0103fb1:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103fb4:	0f 8c 9a fe ff ff    	jl     c0103e54 <page_init+0x235>
                }
            }
        }
    }
}
c0103fba:	90                   	nop
c0103fbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0103fbe:	5b                   	pop    %ebx
c0103fbf:	5e                   	pop    %esi
c0103fc0:	5f                   	pop    %edi
c0103fc1:	5d                   	pop    %ebp
c0103fc2:	c3                   	ret    

c0103fc3 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0103fc3:	55                   	push   %ebp
c0103fc4:	89 e5                	mov    %esp,%ebp
c0103fc6:	83 ec 28             	sub    $0x28,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0103fc9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103fcc:	33 45 14             	xor    0x14(%ebp),%eax
c0103fcf:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103fd4:	85 c0                	test   %eax,%eax
c0103fd6:	74 19                	je     c0103ff1 <boot_map_segment+0x2e>
c0103fd8:	68 1a 64 10 c0       	push   $0xc010641a
c0103fdd:	68 31 64 10 c0       	push   $0xc0106431
c0103fe2:	68 fa 00 00 00       	push   $0xfa
c0103fe7:	68 0c 64 10 c0       	push   $0xc010640c
c0103fec:	e8 dd cb ff ff       	call   c0100bce <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0103ff1:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0103ff8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103ffb:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104000:	89 c2                	mov    %eax,%edx
c0104002:	8b 45 10             	mov    0x10(%ebp),%eax
c0104005:	01 c2                	add    %eax,%edx
c0104007:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010400a:	01 d0                	add    %edx,%eax
c010400c:	48                   	dec    %eax
c010400d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104010:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104013:	ba 00 00 00 00       	mov    $0x0,%edx
c0104018:	f7 75 f0             	divl   -0x10(%ebp)
c010401b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010401e:	29 d0                	sub    %edx,%eax
c0104020:	c1 e8 0c             	shr    $0xc,%eax
c0104023:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104026:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104029:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010402c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010402f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104034:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104037:	8b 45 14             	mov    0x14(%ebp),%eax
c010403a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010403d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104040:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104045:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104048:	eb 56                	jmp    c01040a0 <boot_map_segment+0xdd>
        pte_t *ptep = get_pte(pgdir, la, 1);
c010404a:	83 ec 04             	sub    $0x4,%esp
c010404d:	6a 01                	push   $0x1
c010404f:	ff 75 0c             	pushl  0xc(%ebp)
c0104052:	ff 75 08             	pushl  0x8(%ebp)
c0104055:	e8 52 01 00 00       	call   c01041ac <get_pte>
c010405a:	83 c4 10             	add    $0x10,%esp
c010405d:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104060:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104064:	75 19                	jne    c010407f <boot_map_segment+0xbc>
c0104066:	68 46 64 10 c0       	push   $0xc0106446
c010406b:	68 31 64 10 c0       	push   $0xc0106431
c0104070:	68 00 01 00 00       	push   $0x100
c0104075:	68 0c 64 10 c0       	push   $0xc010640c
c010407a:	e8 4f cb ff ff       	call   c0100bce <__panic>
        *ptep = pa | PTE_P | perm;
c010407f:	8b 45 14             	mov    0x14(%ebp),%eax
c0104082:	0b 45 18             	or     0x18(%ebp),%eax
c0104085:	83 c8 01             	or     $0x1,%eax
c0104088:	89 c2                	mov    %eax,%edx
c010408a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010408d:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c010408f:	ff 4d f4             	decl   -0xc(%ebp)
c0104092:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0104099:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01040a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01040a4:	75 a4                	jne    c010404a <boot_map_segment+0x87>
    }
}
c01040a6:	90                   	nop
c01040a7:	c9                   	leave  
c01040a8:	c3                   	ret    

c01040a9 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01040a9:	55                   	push   %ebp
c01040aa:	89 e5                	mov    %esp,%ebp
c01040ac:	83 ec 18             	sub    $0x18,%esp
    struct Page *p = alloc_page();
c01040af:	83 ec 0c             	sub    $0xc,%esp
c01040b2:	6a 01                	push   $0x1
c01040b4:	e8 c5 fa ff ff       	call   c0103b7e <alloc_pages>
c01040b9:	83 c4 10             	add    $0x10,%esp
c01040bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01040bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01040c3:	75 17                	jne    c01040dc <boot_alloc_page+0x33>
        panic("boot_alloc_page failed.\n");
c01040c5:	83 ec 04             	sub    $0x4,%esp
c01040c8:	68 53 64 10 c0       	push   $0xc0106453
c01040cd:	68 0c 01 00 00       	push   $0x10c
c01040d2:	68 0c 64 10 c0       	push   $0xc010640c
c01040d7:	e8 f2 ca ff ff       	call   c0100bce <__panic>
    }
    return page2kva(p);
c01040dc:	83 ec 0c             	sub    $0xc,%esp
c01040df:	ff 75 f4             	pushl  -0xc(%ebp)
c01040e2:	e8 0e f8 ff ff       	call   c01038f5 <page2kva>
c01040e7:	83 c4 10             	add    $0x10,%esp
}
c01040ea:	c9                   	leave  
c01040eb:	c3                   	ret    

c01040ec <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01040ec:	55                   	push   %ebp
c01040ed:	89 e5                	mov    %esp,%ebp
c01040ef:	83 ec 18             	sub    $0x18,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c01040f2:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01040f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01040fa:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104101:	77 17                	ja     c010411a <pmm_init+0x2e>
c0104103:	ff 75 f4             	pushl  -0xc(%ebp)
c0104106:	68 e8 63 10 c0       	push   $0xc01063e8
c010410b:	68 16 01 00 00       	push   $0x116
c0104110:	68 0c 64 10 c0       	push   $0xc010640c
c0104115:	e8 b4 ca ff ff       	call   c0100bce <__panic>
c010411a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010411d:	05 00 00 00 40       	add    $0x40000000,%eax
c0104122:	a3 20 bf 11 c0       	mov    %eax,0xc011bf20
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104127:	e8 fe f9 ff ff       	call   c0103b2a <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010412c:	e8 ee fa ff ff       	call   c0103c1f <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0104131:	e8 0b 02 00 00       	call   c0104341 <check_alloc_page>

    check_pgdir();
c0104136:	e8 29 02 00 00       	call   c0104364 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c010413b:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104140:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104143:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010414a:	77 17                	ja     c0104163 <pmm_init+0x77>
c010414c:	ff 75 f0             	pushl  -0x10(%ebp)
c010414f:	68 e8 63 10 c0       	push   $0xc01063e8
c0104154:	68 2c 01 00 00       	push   $0x12c
c0104159:	68 0c 64 10 c0       	push   $0xc010640c
c010415e:	e8 6b ca ff ff       	call   c0100bce <__panic>
c0104163:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104166:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c010416c:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104171:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104176:	83 ca 03             	or     $0x3,%edx
c0104179:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c010417b:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104180:	83 ec 0c             	sub    $0xc,%esp
c0104183:	6a 02                	push   $0x2
c0104185:	6a 00                	push   $0x0
c0104187:	68 00 00 00 38       	push   $0x38000000
c010418c:	68 00 00 00 c0       	push   $0xc0000000
c0104191:	50                   	push   %eax
c0104192:	e8 2c fe ff ff       	call   c0103fc3 <boot_map_segment>
c0104197:	83 c4 20             	add    $0x20,%esp

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c010419a:	e8 ab f8 ff ff       	call   c0103a4a <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c010419f:	e8 26 07 00 00       	call   c01048ca <check_boot_pgdir>

    print_pgdir();
c01041a4:	e8 0e 0b 00 00       	call   c0104cb7 <print_pgdir>

}
c01041a9:	90                   	nop
c01041aa:	c9                   	leave  
c01041ab:	c3                   	ret    

c01041ac <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01041ac:	55                   	push   %ebp
c01041ad:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
c01041af:	90                   	nop
c01041b0:	5d                   	pop    %ebp
c01041b1:	c3                   	ret    

c01041b2 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01041b2:	55                   	push   %ebp
c01041b3:	89 e5                	mov    %esp,%ebp
c01041b5:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01041b8:	6a 00                	push   $0x0
c01041ba:	ff 75 0c             	pushl  0xc(%ebp)
c01041bd:	ff 75 08             	pushl  0x8(%ebp)
c01041c0:	e8 e7 ff ff ff       	call   c01041ac <get_pte>
c01041c5:	83 c4 0c             	add    $0xc,%esp
c01041c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01041cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01041cf:	74 08                	je     c01041d9 <get_page+0x27>
        *ptep_store = ptep;
c01041d1:	8b 45 10             	mov    0x10(%ebp),%eax
c01041d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01041d7:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01041d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01041dd:	74 1f                	je     c01041fe <get_page+0x4c>
c01041df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041e2:	8b 00                	mov    (%eax),%eax
c01041e4:	83 e0 01             	and    $0x1,%eax
c01041e7:	85 c0                	test   %eax,%eax
c01041e9:	74 13                	je     c01041fe <get_page+0x4c>
        return pte2page(*ptep);
c01041eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041ee:	8b 00                	mov    (%eax),%eax
c01041f0:	83 ec 0c             	sub    $0xc,%esp
c01041f3:	50                   	push   %eax
c01041f4:	e8 41 f7 ff ff       	call   c010393a <pte2page>
c01041f9:	83 c4 10             	add    $0x10,%esp
c01041fc:	eb 05                	jmp    c0104203 <get_page+0x51>
    }
    return NULL;
c01041fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104203:	c9                   	leave  
c0104204:	c3                   	ret    

c0104205 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0104205:	55                   	push   %ebp
c0104206:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
c0104208:	90                   	nop
c0104209:	5d                   	pop    %ebp
c010420a:	c3                   	ret    

c010420b <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c010420b:	55                   	push   %ebp
c010420c:	89 e5                	mov    %esp,%ebp
c010420e:	83 ec 10             	sub    $0x10,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104211:	6a 00                	push   $0x0
c0104213:	ff 75 0c             	pushl  0xc(%ebp)
c0104216:	ff 75 08             	pushl  0x8(%ebp)
c0104219:	e8 8e ff ff ff       	call   c01041ac <get_pte>
c010421e:	83 c4 0c             	add    $0xc,%esp
c0104221:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
c0104224:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0104228:	74 11                	je     c010423b <page_remove+0x30>
        page_remove_pte(pgdir, la, ptep);
c010422a:	ff 75 fc             	pushl  -0x4(%ebp)
c010422d:	ff 75 0c             	pushl  0xc(%ebp)
c0104230:	ff 75 08             	pushl  0x8(%ebp)
c0104233:	e8 cd ff ff ff       	call   c0104205 <page_remove_pte>
c0104238:	83 c4 0c             	add    $0xc,%esp
    }
}
c010423b:	90                   	nop
c010423c:	c9                   	leave  
c010423d:	c3                   	ret    

c010423e <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c010423e:	55                   	push   %ebp
c010423f:	89 e5                	mov    %esp,%ebp
c0104241:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0104244:	6a 01                	push   $0x1
c0104246:	ff 75 10             	pushl  0x10(%ebp)
c0104249:	ff 75 08             	pushl  0x8(%ebp)
c010424c:	e8 5b ff ff ff       	call   c01041ac <get_pte>
c0104251:	83 c4 0c             	add    $0xc,%esp
c0104254:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0104257:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010425b:	75 0a                	jne    c0104267 <page_insert+0x29>
        return -E_NO_MEM;
c010425d:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0104262:	e9 88 00 00 00       	jmp    c01042ef <page_insert+0xb1>
    }
    page_ref_inc(page);
c0104267:	ff 75 0c             	pushl  0xc(%ebp)
c010426a:	e8 2b f7 ff ff       	call   c010399a <page_ref_inc>
c010426f:	83 c4 04             	add    $0x4,%esp
    if (*ptep & PTE_P) {
c0104272:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104275:	8b 00                	mov    (%eax),%eax
c0104277:	83 e0 01             	and    $0x1,%eax
c010427a:	85 c0                	test   %eax,%eax
c010427c:	74 40                	je     c01042be <page_insert+0x80>
        struct Page *p = pte2page(*ptep);
c010427e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104281:	8b 00                	mov    (%eax),%eax
c0104283:	83 ec 0c             	sub    $0xc,%esp
c0104286:	50                   	push   %eax
c0104287:	e8 ae f6 ff ff       	call   c010393a <pte2page>
c010428c:	83 c4 10             	add    $0x10,%esp
c010428f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0104292:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104295:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104298:	75 10                	jne    c01042aa <page_insert+0x6c>
            page_ref_dec(page);
c010429a:	83 ec 0c             	sub    $0xc,%esp
c010429d:	ff 75 0c             	pushl  0xc(%ebp)
c01042a0:	e8 0c f7 ff ff       	call   c01039b1 <page_ref_dec>
c01042a5:	83 c4 10             	add    $0x10,%esp
c01042a8:	eb 14                	jmp    c01042be <page_insert+0x80>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01042aa:	83 ec 04             	sub    $0x4,%esp
c01042ad:	ff 75 f4             	pushl  -0xc(%ebp)
c01042b0:	ff 75 10             	pushl  0x10(%ebp)
c01042b3:	ff 75 08             	pushl  0x8(%ebp)
c01042b6:	e8 4a ff ff ff       	call   c0104205 <page_remove_pte>
c01042bb:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01042be:	83 ec 0c             	sub    $0xc,%esp
c01042c1:	ff 75 0c             	pushl  0xc(%ebp)
c01042c4:	e8 d2 f5 ff ff       	call   c010389b <page2pa>
c01042c9:	83 c4 10             	add    $0x10,%esp
c01042cc:	0b 45 14             	or     0x14(%ebp),%eax
c01042cf:	83 c8 01             	or     $0x1,%eax
c01042d2:	89 c2                	mov    %eax,%edx
c01042d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042d7:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01042d9:	83 ec 08             	sub    $0x8,%esp
c01042dc:	ff 75 10             	pushl  0x10(%ebp)
c01042df:	ff 75 08             	pushl  0x8(%ebp)
c01042e2:	e8 0a 00 00 00       	call   c01042f1 <tlb_invalidate>
c01042e7:	83 c4 10             	add    $0x10,%esp
    return 0;
c01042ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01042ef:	c9                   	leave  
c01042f0:	c3                   	ret    

c01042f1 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01042f1:	55                   	push   %ebp
c01042f2:	89 e5                	mov    %esp,%ebp
c01042f4:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01042f7:	0f 20 d8             	mov    %cr3,%eax
c01042fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01042fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c0104300:	8b 45 08             	mov    0x8(%ebp),%eax
c0104303:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104306:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010430d:	77 17                	ja     c0104326 <tlb_invalidate+0x35>
c010430f:	ff 75 f4             	pushl  -0xc(%ebp)
c0104312:	68 e8 63 10 c0       	push   $0xc01063e8
c0104317:	68 c3 01 00 00       	push   $0x1c3
c010431c:	68 0c 64 10 c0       	push   $0xc010640c
c0104321:	e8 a8 c8 ff ff       	call   c0100bce <__panic>
c0104326:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104329:	05 00 00 00 40       	add    $0x40000000,%eax
c010432e:	39 d0                	cmp    %edx,%eax
c0104330:	75 0c                	jne    c010433e <tlb_invalidate+0x4d>
        invlpg((void *)la);
c0104332:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104335:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0104338:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010433b:	0f 01 38             	invlpg (%eax)
    }
}
c010433e:	90                   	nop
c010433f:	c9                   	leave  
c0104340:	c3                   	ret    

c0104341 <check_alloc_page>:

static void
check_alloc_page(void) {
c0104341:	55                   	push   %ebp
c0104342:	89 e5                	mov    %esp,%ebp
c0104344:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->check();
c0104347:	a1 1c bf 11 c0       	mov    0xc011bf1c,%eax
c010434c:	8b 40 18             	mov    0x18(%eax),%eax
c010434f:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0104351:	83 ec 0c             	sub    $0xc,%esp
c0104354:	68 6c 64 10 c0       	push   $0xc010646c
c0104359:	e8 d9 bf ff ff       	call   c0100337 <cprintf>
c010435e:	83 c4 10             	add    $0x10,%esp
}
c0104361:	90                   	nop
c0104362:	c9                   	leave  
c0104363:	c3                   	ret    

c0104364 <check_pgdir>:

static void
check_pgdir(void) {
c0104364:	55                   	push   %ebp
c0104365:	89 e5                	mov    %esp,%ebp
c0104367:	83 ec 28             	sub    $0x28,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c010436a:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c010436f:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0104374:	76 19                	jbe    c010438f <check_pgdir+0x2b>
c0104376:	68 8b 64 10 c0       	push   $0xc010648b
c010437b:	68 31 64 10 c0       	push   $0xc0106431
c0104380:	68 d0 01 00 00       	push   $0x1d0
c0104385:	68 0c 64 10 c0       	push   $0xc010640c
c010438a:	e8 3f c8 ff ff       	call   c0100bce <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c010438f:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104394:	85 c0                	test   %eax,%eax
c0104396:	74 0e                	je     c01043a6 <check_pgdir+0x42>
c0104398:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010439d:	25 ff 0f 00 00       	and    $0xfff,%eax
c01043a2:	85 c0                	test   %eax,%eax
c01043a4:	74 19                	je     c01043bf <check_pgdir+0x5b>
c01043a6:	68 a8 64 10 c0       	push   $0xc01064a8
c01043ab:	68 31 64 10 c0       	push   $0xc0106431
c01043b0:	68 d1 01 00 00       	push   $0x1d1
c01043b5:	68 0c 64 10 c0       	push   $0xc010640c
c01043ba:	e8 0f c8 ff ff       	call   c0100bce <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01043bf:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01043c4:	83 ec 04             	sub    $0x4,%esp
c01043c7:	6a 00                	push   $0x0
c01043c9:	6a 00                	push   $0x0
c01043cb:	50                   	push   %eax
c01043cc:	e8 e1 fd ff ff       	call   c01041b2 <get_page>
c01043d1:	83 c4 10             	add    $0x10,%esp
c01043d4:	85 c0                	test   %eax,%eax
c01043d6:	74 19                	je     c01043f1 <check_pgdir+0x8d>
c01043d8:	68 e0 64 10 c0       	push   $0xc01064e0
c01043dd:	68 31 64 10 c0       	push   $0xc0106431
c01043e2:	68 d2 01 00 00       	push   $0x1d2
c01043e7:	68 0c 64 10 c0       	push   $0xc010640c
c01043ec:	e8 dd c7 ff ff       	call   c0100bce <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01043f1:	83 ec 0c             	sub    $0xc,%esp
c01043f4:	6a 01                	push   $0x1
c01043f6:	e8 83 f7 ff ff       	call   c0103b7e <alloc_pages>
c01043fb:	83 c4 10             	add    $0x10,%esp
c01043fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0104401:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104406:	6a 00                	push   $0x0
c0104408:	6a 00                	push   $0x0
c010440a:	ff 75 f4             	pushl  -0xc(%ebp)
c010440d:	50                   	push   %eax
c010440e:	e8 2b fe ff ff       	call   c010423e <page_insert>
c0104413:	83 c4 10             	add    $0x10,%esp
c0104416:	85 c0                	test   %eax,%eax
c0104418:	74 19                	je     c0104433 <check_pgdir+0xcf>
c010441a:	68 08 65 10 c0       	push   $0xc0106508
c010441f:	68 31 64 10 c0       	push   $0xc0106431
c0104424:	68 d6 01 00 00       	push   $0x1d6
c0104429:	68 0c 64 10 c0       	push   $0xc010640c
c010442e:	e8 9b c7 ff ff       	call   c0100bce <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0104433:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104438:	83 ec 04             	sub    $0x4,%esp
c010443b:	6a 00                	push   $0x0
c010443d:	6a 00                	push   $0x0
c010443f:	50                   	push   %eax
c0104440:	e8 67 fd ff ff       	call   c01041ac <get_pte>
c0104445:	83 c4 10             	add    $0x10,%esp
c0104448:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010444b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010444f:	75 19                	jne    c010446a <check_pgdir+0x106>
c0104451:	68 34 65 10 c0       	push   $0xc0106534
c0104456:	68 31 64 10 c0       	push   $0xc0106431
c010445b:	68 d9 01 00 00       	push   $0x1d9
c0104460:	68 0c 64 10 c0       	push   $0xc010640c
c0104465:	e8 64 c7 ff ff       	call   c0100bce <__panic>
    assert(pte2page(*ptep) == p1);
c010446a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010446d:	8b 00                	mov    (%eax),%eax
c010446f:	83 ec 0c             	sub    $0xc,%esp
c0104472:	50                   	push   %eax
c0104473:	e8 c2 f4 ff ff       	call   c010393a <pte2page>
c0104478:	83 c4 10             	add    $0x10,%esp
c010447b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010447e:	74 19                	je     c0104499 <check_pgdir+0x135>
c0104480:	68 61 65 10 c0       	push   $0xc0106561
c0104485:	68 31 64 10 c0       	push   $0xc0106431
c010448a:	68 da 01 00 00       	push   $0x1da
c010448f:	68 0c 64 10 c0       	push   $0xc010640c
c0104494:	e8 35 c7 ff ff       	call   c0100bce <__panic>
    assert(page_ref(p1) == 1);
c0104499:	83 ec 0c             	sub    $0xc,%esp
c010449c:	ff 75 f4             	pushl  -0xc(%ebp)
c010449f:	e8 ec f4 ff ff       	call   c0103990 <page_ref>
c01044a4:	83 c4 10             	add    $0x10,%esp
c01044a7:	83 f8 01             	cmp    $0x1,%eax
c01044aa:	74 19                	je     c01044c5 <check_pgdir+0x161>
c01044ac:	68 77 65 10 c0       	push   $0xc0106577
c01044b1:	68 31 64 10 c0       	push   $0xc0106431
c01044b6:	68 db 01 00 00       	push   $0x1db
c01044bb:	68 0c 64 10 c0       	push   $0xc010640c
c01044c0:	e8 09 c7 ff ff       	call   c0100bce <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01044c5:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01044ca:	8b 00                	mov    (%eax),%eax
c01044cc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01044d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01044d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01044d7:	c1 e8 0c             	shr    $0xc,%eax
c01044da:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01044dd:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c01044e2:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01044e5:	72 17                	jb     c01044fe <check_pgdir+0x19a>
c01044e7:	ff 75 ec             	pushl  -0x14(%ebp)
c01044ea:	68 44 63 10 c0       	push   $0xc0106344
c01044ef:	68 dd 01 00 00       	push   $0x1dd
c01044f4:	68 0c 64 10 c0       	push   $0xc010640c
c01044f9:	e8 d0 c6 ff ff       	call   c0100bce <__panic>
c01044fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104501:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104506:	83 c0 04             	add    $0x4,%eax
c0104509:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c010450c:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104511:	83 ec 04             	sub    $0x4,%esp
c0104514:	6a 00                	push   $0x0
c0104516:	68 00 10 00 00       	push   $0x1000
c010451b:	50                   	push   %eax
c010451c:	e8 8b fc ff ff       	call   c01041ac <get_pte>
c0104521:	83 c4 10             	add    $0x10,%esp
c0104524:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104527:	74 19                	je     c0104542 <check_pgdir+0x1de>
c0104529:	68 8c 65 10 c0       	push   $0xc010658c
c010452e:	68 31 64 10 c0       	push   $0xc0106431
c0104533:	68 de 01 00 00       	push   $0x1de
c0104538:	68 0c 64 10 c0       	push   $0xc010640c
c010453d:	e8 8c c6 ff ff       	call   c0100bce <__panic>

    p2 = alloc_page();
c0104542:	83 ec 0c             	sub    $0xc,%esp
c0104545:	6a 01                	push   $0x1
c0104547:	e8 32 f6 ff ff       	call   c0103b7e <alloc_pages>
c010454c:	83 c4 10             	add    $0x10,%esp
c010454f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0104552:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104557:	6a 06                	push   $0x6
c0104559:	68 00 10 00 00       	push   $0x1000
c010455e:	ff 75 e4             	pushl  -0x1c(%ebp)
c0104561:	50                   	push   %eax
c0104562:	e8 d7 fc ff ff       	call   c010423e <page_insert>
c0104567:	83 c4 10             	add    $0x10,%esp
c010456a:	85 c0                	test   %eax,%eax
c010456c:	74 19                	je     c0104587 <check_pgdir+0x223>
c010456e:	68 b4 65 10 c0       	push   $0xc01065b4
c0104573:	68 31 64 10 c0       	push   $0xc0106431
c0104578:	68 e1 01 00 00       	push   $0x1e1
c010457d:	68 0c 64 10 c0       	push   $0xc010640c
c0104582:	e8 47 c6 ff ff       	call   c0100bce <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104587:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010458c:	83 ec 04             	sub    $0x4,%esp
c010458f:	6a 00                	push   $0x0
c0104591:	68 00 10 00 00       	push   $0x1000
c0104596:	50                   	push   %eax
c0104597:	e8 10 fc ff ff       	call   c01041ac <get_pte>
c010459c:	83 c4 10             	add    $0x10,%esp
c010459f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01045a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01045a6:	75 19                	jne    c01045c1 <check_pgdir+0x25d>
c01045a8:	68 ec 65 10 c0       	push   $0xc01065ec
c01045ad:	68 31 64 10 c0       	push   $0xc0106431
c01045b2:	68 e2 01 00 00       	push   $0x1e2
c01045b7:	68 0c 64 10 c0       	push   $0xc010640c
c01045bc:	e8 0d c6 ff ff       	call   c0100bce <__panic>
    assert(*ptep & PTE_U);
c01045c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045c4:	8b 00                	mov    (%eax),%eax
c01045c6:	83 e0 04             	and    $0x4,%eax
c01045c9:	85 c0                	test   %eax,%eax
c01045cb:	75 19                	jne    c01045e6 <check_pgdir+0x282>
c01045cd:	68 1c 66 10 c0       	push   $0xc010661c
c01045d2:	68 31 64 10 c0       	push   $0xc0106431
c01045d7:	68 e3 01 00 00       	push   $0x1e3
c01045dc:	68 0c 64 10 c0       	push   $0xc010640c
c01045e1:	e8 e8 c5 ff ff       	call   c0100bce <__panic>
    assert(*ptep & PTE_W);
c01045e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045e9:	8b 00                	mov    (%eax),%eax
c01045eb:	83 e0 02             	and    $0x2,%eax
c01045ee:	85 c0                	test   %eax,%eax
c01045f0:	75 19                	jne    c010460b <check_pgdir+0x2a7>
c01045f2:	68 2a 66 10 c0       	push   $0xc010662a
c01045f7:	68 31 64 10 c0       	push   $0xc0106431
c01045fc:	68 e4 01 00 00       	push   $0x1e4
c0104601:	68 0c 64 10 c0       	push   $0xc010640c
c0104606:	e8 c3 c5 ff ff       	call   c0100bce <__panic>
    assert(boot_pgdir[0] & PTE_U);
c010460b:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104610:	8b 00                	mov    (%eax),%eax
c0104612:	83 e0 04             	and    $0x4,%eax
c0104615:	85 c0                	test   %eax,%eax
c0104617:	75 19                	jne    c0104632 <check_pgdir+0x2ce>
c0104619:	68 38 66 10 c0       	push   $0xc0106638
c010461e:	68 31 64 10 c0       	push   $0xc0106431
c0104623:	68 e5 01 00 00       	push   $0x1e5
c0104628:	68 0c 64 10 c0       	push   $0xc010640c
c010462d:	e8 9c c5 ff ff       	call   c0100bce <__panic>
    assert(page_ref(p2) == 1);
c0104632:	83 ec 0c             	sub    $0xc,%esp
c0104635:	ff 75 e4             	pushl  -0x1c(%ebp)
c0104638:	e8 53 f3 ff ff       	call   c0103990 <page_ref>
c010463d:	83 c4 10             	add    $0x10,%esp
c0104640:	83 f8 01             	cmp    $0x1,%eax
c0104643:	74 19                	je     c010465e <check_pgdir+0x2fa>
c0104645:	68 4e 66 10 c0       	push   $0xc010664e
c010464a:	68 31 64 10 c0       	push   $0xc0106431
c010464f:	68 e6 01 00 00       	push   $0x1e6
c0104654:	68 0c 64 10 c0       	push   $0xc010640c
c0104659:	e8 70 c5 ff ff       	call   c0100bce <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c010465e:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104663:	6a 00                	push   $0x0
c0104665:	68 00 10 00 00       	push   $0x1000
c010466a:	ff 75 f4             	pushl  -0xc(%ebp)
c010466d:	50                   	push   %eax
c010466e:	e8 cb fb ff ff       	call   c010423e <page_insert>
c0104673:	83 c4 10             	add    $0x10,%esp
c0104676:	85 c0                	test   %eax,%eax
c0104678:	74 19                	je     c0104693 <check_pgdir+0x32f>
c010467a:	68 60 66 10 c0       	push   $0xc0106660
c010467f:	68 31 64 10 c0       	push   $0xc0106431
c0104684:	68 e8 01 00 00       	push   $0x1e8
c0104689:	68 0c 64 10 c0       	push   $0xc010640c
c010468e:	e8 3b c5 ff ff       	call   c0100bce <__panic>
    assert(page_ref(p1) == 2);
c0104693:	83 ec 0c             	sub    $0xc,%esp
c0104696:	ff 75 f4             	pushl  -0xc(%ebp)
c0104699:	e8 f2 f2 ff ff       	call   c0103990 <page_ref>
c010469e:	83 c4 10             	add    $0x10,%esp
c01046a1:	83 f8 02             	cmp    $0x2,%eax
c01046a4:	74 19                	je     c01046bf <check_pgdir+0x35b>
c01046a6:	68 8c 66 10 c0       	push   $0xc010668c
c01046ab:	68 31 64 10 c0       	push   $0xc0106431
c01046b0:	68 e9 01 00 00       	push   $0x1e9
c01046b5:	68 0c 64 10 c0       	push   $0xc010640c
c01046ba:	e8 0f c5 ff ff       	call   c0100bce <__panic>
    assert(page_ref(p2) == 0);
c01046bf:	83 ec 0c             	sub    $0xc,%esp
c01046c2:	ff 75 e4             	pushl  -0x1c(%ebp)
c01046c5:	e8 c6 f2 ff ff       	call   c0103990 <page_ref>
c01046ca:	83 c4 10             	add    $0x10,%esp
c01046cd:	85 c0                	test   %eax,%eax
c01046cf:	74 19                	je     c01046ea <check_pgdir+0x386>
c01046d1:	68 9e 66 10 c0       	push   $0xc010669e
c01046d6:	68 31 64 10 c0       	push   $0xc0106431
c01046db:	68 ea 01 00 00       	push   $0x1ea
c01046e0:	68 0c 64 10 c0       	push   $0xc010640c
c01046e5:	e8 e4 c4 ff ff       	call   c0100bce <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01046ea:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01046ef:	83 ec 04             	sub    $0x4,%esp
c01046f2:	6a 00                	push   $0x0
c01046f4:	68 00 10 00 00       	push   $0x1000
c01046f9:	50                   	push   %eax
c01046fa:	e8 ad fa ff ff       	call   c01041ac <get_pte>
c01046ff:	83 c4 10             	add    $0x10,%esp
c0104702:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104705:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104709:	75 19                	jne    c0104724 <check_pgdir+0x3c0>
c010470b:	68 ec 65 10 c0       	push   $0xc01065ec
c0104710:	68 31 64 10 c0       	push   $0xc0106431
c0104715:	68 eb 01 00 00       	push   $0x1eb
c010471a:	68 0c 64 10 c0       	push   $0xc010640c
c010471f:	e8 aa c4 ff ff       	call   c0100bce <__panic>
    assert(pte2page(*ptep) == p1);
c0104724:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104727:	8b 00                	mov    (%eax),%eax
c0104729:	83 ec 0c             	sub    $0xc,%esp
c010472c:	50                   	push   %eax
c010472d:	e8 08 f2 ff ff       	call   c010393a <pte2page>
c0104732:	83 c4 10             	add    $0x10,%esp
c0104735:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104738:	74 19                	je     c0104753 <check_pgdir+0x3ef>
c010473a:	68 61 65 10 c0       	push   $0xc0106561
c010473f:	68 31 64 10 c0       	push   $0xc0106431
c0104744:	68 ec 01 00 00       	push   $0x1ec
c0104749:	68 0c 64 10 c0       	push   $0xc010640c
c010474e:	e8 7b c4 ff ff       	call   c0100bce <__panic>
    assert((*ptep & PTE_U) == 0);
c0104753:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104756:	8b 00                	mov    (%eax),%eax
c0104758:	83 e0 04             	and    $0x4,%eax
c010475b:	85 c0                	test   %eax,%eax
c010475d:	74 19                	je     c0104778 <check_pgdir+0x414>
c010475f:	68 b0 66 10 c0       	push   $0xc01066b0
c0104764:	68 31 64 10 c0       	push   $0xc0106431
c0104769:	68 ed 01 00 00       	push   $0x1ed
c010476e:	68 0c 64 10 c0       	push   $0xc010640c
c0104773:	e8 56 c4 ff ff       	call   c0100bce <__panic>

    page_remove(boot_pgdir, 0x0);
c0104778:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010477d:	83 ec 08             	sub    $0x8,%esp
c0104780:	6a 00                	push   $0x0
c0104782:	50                   	push   %eax
c0104783:	e8 83 fa ff ff       	call   c010420b <page_remove>
c0104788:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
c010478b:	83 ec 0c             	sub    $0xc,%esp
c010478e:	ff 75 f4             	pushl  -0xc(%ebp)
c0104791:	e8 fa f1 ff ff       	call   c0103990 <page_ref>
c0104796:	83 c4 10             	add    $0x10,%esp
c0104799:	83 f8 01             	cmp    $0x1,%eax
c010479c:	74 19                	je     c01047b7 <check_pgdir+0x453>
c010479e:	68 77 65 10 c0       	push   $0xc0106577
c01047a3:	68 31 64 10 c0       	push   $0xc0106431
c01047a8:	68 f0 01 00 00       	push   $0x1f0
c01047ad:	68 0c 64 10 c0       	push   $0xc010640c
c01047b2:	e8 17 c4 ff ff       	call   c0100bce <__panic>
    assert(page_ref(p2) == 0);
c01047b7:	83 ec 0c             	sub    $0xc,%esp
c01047ba:	ff 75 e4             	pushl  -0x1c(%ebp)
c01047bd:	e8 ce f1 ff ff       	call   c0103990 <page_ref>
c01047c2:	83 c4 10             	add    $0x10,%esp
c01047c5:	85 c0                	test   %eax,%eax
c01047c7:	74 19                	je     c01047e2 <check_pgdir+0x47e>
c01047c9:	68 9e 66 10 c0       	push   $0xc010669e
c01047ce:	68 31 64 10 c0       	push   $0xc0106431
c01047d3:	68 f1 01 00 00       	push   $0x1f1
c01047d8:	68 0c 64 10 c0       	push   $0xc010640c
c01047dd:	e8 ec c3 ff ff       	call   c0100bce <__panic>

    page_remove(boot_pgdir, PGSIZE);
c01047e2:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01047e7:	83 ec 08             	sub    $0x8,%esp
c01047ea:	68 00 10 00 00       	push   $0x1000
c01047ef:	50                   	push   %eax
c01047f0:	e8 16 fa ff ff       	call   c010420b <page_remove>
c01047f5:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
c01047f8:	83 ec 0c             	sub    $0xc,%esp
c01047fb:	ff 75 f4             	pushl  -0xc(%ebp)
c01047fe:	e8 8d f1 ff ff       	call   c0103990 <page_ref>
c0104803:	83 c4 10             	add    $0x10,%esp
c0104806:	85 c0                	test   %eax,%eax
c0104808:	74 19                	je     c0104823 <check_pgdir+0x4bf>
c010480a:	68 c5 66 10 c0       	push   $0xc01066c5
c010480f:	68 31 64 10 c0       	push   $0xc0106431
c0104814:	68 f4 01 00 00       	push   $0x1f4
c0104819:	68 0c 64 10 c0       	push   $0xc010640c
c010481e:	e8 ab c3 ff ff       	call   c0100bce <__panic>
    assert(page_ref(p2) == 0);
c0104823:	83 ec 0c             	sub    $0xc,%esp
c0104826:	ff 75 e4             	pushl  -0x1c(%ebp)
c0104829:	e8 62 f1 ff ff       	call   c0103990 <page_ref>
c010482e:	83 c4 10             	add    $0x10,%esp
c0104831:	85 c0                	test   %eax,%eax
c0104833:	74 19                	je     c010484e <check_pgdir+0x4ea>
c0104835:	68 9e 66 10 c0       	push   $0xc010669e
c010483a:	68 31 64 10 c0       	push   $0xc0106431
c010483f:	68 f5 01 00 00       	push   $0x1f5
c0104844:	68 0c 64 10 c0       	push   $0xc010640c
c0104849:	e8 80 c3 ff ff       	call   c0100bce <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c010484e:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104853:	8b 00                	mov    (%eax),%eax
c0104855:	83 ec 0c             	sub    $0xc,%esp
c0104858:	50                   	push   %eax
c0104859:	e8 16 f1 ff ff       	call   c0103974 <pde2page>
c010485e:	83 c4 10             	add    $0x10,%esp
c0104861:	83 ec 0c             	sub    $0xc,%esp
c0104864:	50                   	push   %eax
c0104865:	e8 26 f1 ff ff       	call   c0103990 <page_ref>
c010486a:	83 c4 10             	add    $0x10,%esp
c010486d:	83 f8 01             	cmp    $0x1,%eax
c0104870:	74 19                	je     c010488b <check_pgdir+0x527>
c0104872:	68 d8 66 10 c0       	push   $0xc01066d8
c0104877:	68 31 64 10 c0       	push   $0xc0106431
c010487c:	68 f7 01 00 00       	push   $0x1f7
c0104881:	68 0c 64 10 c0       	push   $0xc010640c
c0104886:	e8 43 c3 ff ff       	call   c0100bce <__panic>
    free_page(pde2page(boot_pgdir[0]));
c010488b:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104890:	8b 00                	mov    (%eax),%eax
c0104892:	83 ec 0c             	sub    $0xc,%esp
c0104895:	50                   	push   %eax
c0104896:	e8 d9 f0 ff ff       	call   c0103974 <pde2page>
c010489b:	83 c4 10             	add    $0x10,%esp
c010489e:	83 ec 08             	sub    $0x8,%esp
c01048a1:	6a 01                	push   $0x1
c01048a3:	50                   	push   %eax
c01048a4:	e8 13 f3 ff ff       	call   c0103bbc <free_pages>
c01048a9:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c01048ac:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01048b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c01048b7:	83 ec 0c             	sub    $0xc,%esp
c01048ba:	68 ff 66 10 c0       	push   $0xc01066ff
c01048bf:	e8 73 ba ff ff       	call   c0100337 <cprintf>
c01048c4:	83 c4 10             	add    $0x10,%esp
}
c01048c7:	90                   	nop
c01048c8:	c9                   	leave  
c01048c9:	c3                   	ret    

c01048ca <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c01048ca:	55                   	push   %ebp
c01048cb:	89 e5                	mov    %esp,%ebp
c01048cd:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c01048d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01048d7:	e9 a3 00 00 00       	jmp    c010497f <check_boot_pgdir+0xb5>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c01048dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048df:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01048e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048e5:	c1 e8 0c             	shr    $0xc,%eax
c01048e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01048eb:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c01048f0:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c01048f3:	72 17                	jb     c010490c <check_boot_pgdir+0x42>
c01048f5:	ff 75 f0             	pushl  -0x10(%ebp)
c01048f8:	68 44 63 10 c0       	push   $0xc0106344
c01048fd:	68 03 02 00 00       	push   $0x203
c0104902:	68 0c 64 10 c0       	push   $0xc010640c
c0104907:	e8 c2 c2 ff ff       	call   c0100bce <__panic>
c010490c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010490f:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104914:	89 c2                	mov    %eax,%edx
c0104916:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010491b:	83 ec 04             	sub    $0x4,%esp
c010491e:	6a 00                	push   $0x0
c0104920:	52                   	push   %edx
c0104921:	50                   	push   %eax
c0104922:	e8 85 f8 ff ff       	call   c01041ac <get_pte>
c0104927:	83 c4 10             	add    $0x10,%esp
c010492a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010492d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104931:	75 19                	jne    c010494c <check_boot_pgdir+0x82>
c0104933:	68 1c 67 10 c0       	push   $0xc010671c
c0104938:	68 31 64 10 c0       	push   $0xc0106431
c010493d:	68 03 02 00 00       	push   $0x203
c0104942:	68 0c 64 10 c0       	push   $0xc010640c
c0104947:	e8 82 c2 ff ff       	call   c0100bce <__panic>
        assert(PTE_ADDR(*ptep) == i);
c010494c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010494f:	8b 00                	mov    (%eax),%eax
c0104951:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104956:	89 c2                	mov    %eax,%edx
c0104958:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010495b:	39 c2                	cmp    %eax,%edx
c010495d:	74 19                	je     c0104978 <check_boot_pgdir+0xae>
c010495f:	68 59 67 10 c0       	push   $0xc0106759
c0104964:	68 31 64 10 c0       	push   $0xc0106431
c0104969:	68 04 02 00 00       	push   $0x204
c010496e:	68 0c 64 10 c0       	push   $0xc010640c
c0104973:	e8 56 c2 ff ff       	call   c0100bce <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c0104978:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c010497f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104982:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c0104987:	39 c2                	cmp    %eax,%edx
c0104989:	0f 82 4d ff ff ff    	jb     c01048dc <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c010498f:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104994:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104999:	8b 00                	mov    (%eax),%eax
c010499b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01049a0:	89 c2                	mov    %eax,%edx
c01049a2:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01049a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01049aa:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c01049b1:	77 17                	ja     c01049ca <check_boot_pgdir+0x100>
c01049b3:	ff 75 e4             	pushl  -0x1c(%ebp)
c01049b6:	68 e8 63 10 c0       	push   $0xc01063e8
c01049bb:	68 07 02 00 00       	push   $0x207
c01049c0:	68 0c 64 10 c0       	push   $0xc010640c
c01049c5:	e8 04 c2 ff ff       	call   c0100bce <__panic>
c01049ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01049cd:	05 00 00 00 40       	add    $0x40000000,%eax
c01049d2:	39 d0                	cmp    %edx,%eax
c01049d4:	74 19                	je     c01049ef <check_boot_pgdir+0x125>
c01049d6:	68 70 67 10 c0       	push   $0xc0106770
c01049db:	68 31 64 10 c0       	push   $0xc0106431
c01049e0:	68 07 02 00 00       	push   $0x207
c01049e5:	68 0c 64 10 c0       	push   $0xc010640c
c01049ea:	e8 df c1 ff ff       	call   c0100bce <__panic>

    assert(boot_pgdir[0] == 0);
c01049ef:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01049f4:	8b 00                	mov    (%eax),%eax
c01049f6:	85 c0                	test   %eax,%eax
c01049f8:	74 19                	je     c0104a13 <check_boot_pgdir+0x149>
c01049fa:	68 a4 67 10 c0       	push   $0xc01067a4
c01049ff:	68 31 64 10 c0       	push   $0xc0106431
c0104a04:	68 09 02 00 00       	push   $0x209
c0104a09:	68 0c 64 10 c0       	push   $0xc010640c
c0104a0e:	e8 bb c1 ff ff       	call   c0100bce <__panic>

    struct Page *p;
    p = alloc_page();
c0104a13:	83 ec 0c             	sub    $0xc,%esp
c0104a16:	6a 01                	push   $0x1
c0104a18:	e8 61 f1 ff ff       	call   c0103b7e <alloc_pages>
c0104a1d:	83 c4 10             	add    $0x10,%esp
c0104a20:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0104a23:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104a28:	6a 02                	push   $0x2
c0104a2a:	68 00 01 00 00       	push   $0x100
c0104a2f:	ff 75 e0             	pushl  -0x20(%ebp)
c0104a32:	50                   	push   %eax
c0104a33:	e8 06 f8 ff ff       	call   c010423e <page_insert>
c0104a38:	83 c4 10             	add    $0x10,%esp
c0104a3b:	85 c0                	test   %eax,%eax
c0104a3d:	74 19                	je     c0104a58 <check_boot_pgdir+0x18e>
c0104a3f:	68 b8 67 10 c0       	push   $0xc01067b8
c0104a44:	68 31 64 10 c0       	push   $0xc0106431
c0104a49:	68 0d 02 00 00       	push   $0x20d
c0104a4e:	68 0c 64 10 c0       	push   $0xc010640c
c0104a53:	e8 76 c1 ff ff       	call   c0100bce <__panic>
    assert(page_ref(p) == 1);
c0104a58:	83 ec 0c             	sub    $0xc,%esp
c0104a5b:	ff 75 e0             	pushl  -0x20(%ebp)
c0104a5e:	e8 2d ef ff ff       	call   c0103990 <page_ref>
c0104a63:	83 c4 10             	add    $0x10,%esp
c0104a66:	83 f8 01             	cmp    $0x1,%eax
c0104a69:	74 19                	je     c0104a84 <check_boot_pgdir+0x1ba>
c0104a6b:	68 e6 67 10 c0       	push   $0xc01067e6
c0104a70:	68 31 64 10 c0       	push   $0xc0106431
c0104a75:	68 0e 02 00 00       	push   $0x20e
c0104a7a:	68 0c 64 10 c0       	push   $0xc010640c
c0104a7f:	e8 4a c1 ff ff       	call   c0100bce <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0104a84:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104a89:	6a 02                	push   $0x2
c0104a8b:	68 00 11 00 00       	push   $0x1100
c0104a90:	ff 75 e0             	pushl  -0x20(%ebp)
c0104a93:	50                   	push   %eax
c0104a94:	e8 a5 f7 ff ff       	call   c010423e <page_insert>
c0104a99:	83 c4 10             	add    $0x10,%esp
c0104a9c:	85 c0                	test   %eax,%eax
c0104a9e:	74 19                	je     c0104ab9 <check_boot_pgdir+0x1ef>
c0104aa0:	68 f8 67 10 c0       	push   $0xc01067f8
c0104aa5:	68 31 64 10 c0       	push   $0xc0106431
c0104aaa:	68 0f 02 00 00       	push   $0x20f
c0104aaf:	68 0c 64 10 c0       	push   $0xc010640c
c0104ab4:	e8 15 c1 ff ff       	call   c0100bce <__panic>
    assert(page_ref(p) == 2);
c0104ab9:	83 ec 0c             	sub    $0xc,%esp
c0104abc:	ff 75 e0             	pushl  -0x20(%ebp)
c0104abf:	e8 cc ee ff ff       	call   c0103990 <page_ref>
c0104ac4:	83 c4 10             	add    $0x10,%esp
c0104ac7:	83 f8 02             	cmp    $0x2,%eax
c0104aca:	74 19                	je     c0104ae5 <check_boot_pgdir+0x21b>
c0104acc:	68 2f 68 10 c0       	push   $0xc010682f
c0104ad1:	68 31 64 10 c0       	push   $0xc0106431
c0104ad6:	68 10 02 00 00       	push   $0x210
c0104adb:	68 0c 64 10 c0       	push   $0xc010640c
c0104ae0:	e8 e9 c0 ff ff       	call   c0100bce <__panic>

    const char *str = "ucore: Hello world!!";
c0104ae5:	c7 45 dc 40 68 10 c0 	movl   $0xc0106840,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0104aec:	83 ec 08             	sub    $0x8,%esp
c0104aef:	ff 75 dc             	pushl  -0x24(%ebp)
c0104af2:	68 00 01 00 00       	push   $0x100
c0104af7:	e8 50 09 00 00       	call   c010544c <strcpy>
c0104afc:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0104aff:	83 ec 08             	sub    $0x8,%esp
c0104b02:	68 00 11 00 00       	push   $0x1100
c0104b07:	68 00 01 00 00       	push   $0x100
c0104b0c:	e8 b0 09 00 00       	call   c01054c1 <strcmp>
c0104b11:	83 c4 10             	add    $0x10,%esp
c0104b14:	85 c0                	test   %eax,%eax
c0104b16:	74 19                	je     c0104b31 <check_boot_pgdir+0x267>
c0104b18:	68 58 68 10 c0       	push   $0xc0106858
c0104b1d:	68 31 64 10 c0       	push   $0xc0106431
c0104b22:	68 14 02 00 00       	push   $0x214
c0104b27:	68 0c 64 10 c0       	push   $0xc010640c
c0104b2c:	e8 9d c0 ff ff       	call   c0100bce <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0104b31:	83 ec 0c             	sub    $0xc,%esp
c0104b34:	ff 75 e0             	pushl  -0x20(%ebp)
c0104b37:	e8 b9 ed ff ff       	call   c01038f5 <page2kva>
c0104b3c:	83 c4 10             	add    $0x10,%esp
c0104b3f:	05 00 01 00 00       	add    $0x100,%eax
c0104b44:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0104b47:	83 ec 0c             	sub    $0xc,%esp
c0104b4a:	68 00 01 00 00       	push   $0x100
c0104b4f:	e8 a4 08 00 00       	call   c01053f8 <strlen>
c0104b54:	83 c4 10             	add    $0x10,%esp
c0104b57:	85 c0                	test   %eax,%eax
c0104b59:	74 19                	je     c0104b74 <check_boot_pgdir+0x2aa>
c0104b5b:	68 90 68 10 c0       	push   $0xc0106890
c0104b60:	68 31 64 10 c0       	push   $0xc0106431
c0104b65:	68 17 02 00 00       	push   $0x217
c0104b6a:	68 0c 64 10 c0       	push   $0xc010640c
c0104b6f:	e8 5a c0 ff ff       	call   c0100bce <__panic>

    free_page(p);
c0104b74:	83 ec 08             	sub    $0x8,%esp
c0104b77:	6a 01                	push   $0x1
c0104b79:	ff 75 e0             	pushl  -0x20(%ebp)
c0104b7c:	e8 3b f0 ff ff       	call   c0103bbc <free_pages>
c0104b81:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(boot_pgdir[0]));
c0104b84:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104b89:	8b 00                	mov    (%eax),%eax
c0104b8b:	83 ec 0c             	sub    $0xc,%esp
c0104b8e:	50                   	push   %eax
c0104b8f:	e8 e0 ed ff ff       	call   c0103974 <pde2page>
c0104b94:	83 c4 10             	add    $0x10,%esp
c0104b97:	83 ec 08             	sub    $0x8,%esp
c0104b9a:	6a 01                	push   $0x1
c0104b9c:	50                   	push   %eax
c0104b9d:	e8 1a f0 ff ff       	call   c0103bbc <free_pages>
c0104ba2:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0104ba5:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104baa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0104bb0:	83 ec 0c             	sub    $0xc,%esp
c0104bb3:	68 b4 68 10 c0       	push   $0xc01068b4
c0104bb8:	e8 7a b7 ff ff       	call   c0100337 <cprintf>
c0104bbd:	83 c4 10             	add    $0x10,%esp
}
c0104bc0:	90                   	nop
c0104bc1:	c9                   	leave  
c0104bc2:	c3                   	ret    

c0104bc3 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0104bc3:	55                   	push   %ebp
c0104bc4:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0104bc6:	8b 45 08             	mov    0x8(%ebp),%eax
c0104bc9:	83 e0 04             	and    $0x4,%eax
c0104bcc:	85 c0                	test   %eax,%eax
c0104bce:	74 04                	je     c0104bd4 <perm2str+0x11>
c0104bd0:	b0 75                	mov    $0x75,%al
c0104bd2:	eb 02                	jmp    c0104bd6 <perm2str+0x13>
c0104bd4:	b0 2d                	mov    $0x2d,%al
c0104bd6:	a2 08 bf 11 c0       	mov    %al,0xc011bf08
    str[1] = 'r';
c0104bdb:	c6 05 09 bf 11 c0 72 	movb   $0x72,0xc011bf09
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0104be2:	8b 45 08             	mov    0x8(%ebp),%eax
c0104be5:	83 e0 02             	and    $0x2,%eax
c0104be8:	85 c0                	test   %eax,%eax
c0104bea:	74 04                	je     c0104bf0 <perm2str+0x2d>
c0104bec:	b0 77                	mov    $0x77,%al
c0104bee:	eb 02                	jmp    c0104bf2 <perm2str+0x2f>
c0104bf0:	b0 2d                	mov    $0x2d,%al
c0104bf2:	a2 0a bf 11 c0       	mov    %al,0xc011bf0a
    str[3] = '\0';
c0104bf7:	c6 05 0b bf 11 c0 00 	movb   $0x0,0xc011bf0b
    return str;
c0104bfe:	b8 08 bf 11 c0       	mov    $0xc011bf08,%eax
}
c0104c03:	5d                   	pop    %ebp
c0104c04:	c3                   	ret    

c0104c05 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0104c05:	55                   	push   %ebp
c0104c06:	89 e5                	mov    %esp,%ebp
c0104c08:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0104c0b:	8b 45 10             	mov    0x10(%ebp),%eax
c0104c0e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104c11:	72 0d                	jb     c0104c20 <get_pgtable_items+0x1b>
        return 0;
c0104c13:	b8 00 00 00 00       	mov    $0x0,%eax
c0104c18:	e9 98 00 00 00       	jmp    c0104cb5 <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0104c1d:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c0104c20:	8b 45 10             	mov    0x10(%ebp),%eax
c0104c23:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104c26:	73 18                	jae    c0104c40 <get_pgtable_items+0x3b>
c0104c28:	8b 45 10             	mov    0x10(%ebp),%eax
c0104c2b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104c32:	8b 45 14             	mov    0x14(%ebp),%eax
c0104c35:	01 d0                	add    %edx,%eax
c0104c37:	8b 00                	mov    (%eax),%eax
c0104c39:	83 e0 01             	and    $0x1,%eax
c0104c3c:	85 c0                	test   %eax,%eax
c0104c3e:	74 dd                	je     c0104c1d <get_pgtable_items+0x18>
    }
    if (start < right) {
c0104c40:	8b 45 10             	mov    0x10(%ebp),%eax
c0104c43:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104c46:	73 68                	jae    c0104cb0 <get_pgtable_items+0xab>
        if (left_store != NULL) {
c0104c48:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0104c4c:	74 08                	je     c0104c56 <get_pgtable_items+0x51>
            *left_store = start;
c0104c4e:	8b 45 18             	mov    0x18(%ebp),%eax
c0104c51:	8b 55 10             	mov    0x10(%ebp),%edx
c0104c54:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0104c56:	8b 45 10             	mov    0x10(%ebp),%eax
c0104c59:	8d 50 01             	lea    0x1(%eax),%edx
c0104c5c:	89 55 10             	mov    %edx,0x10(%ebp)
c0104c5f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104c66:	8b 45 14             	mov    0x14(%ebp),%eax
c0104c69:	01 d0                	add    %edx,%eax
c0104c6b:	8b 00                	mov    (%eax),%eax
c0104c6d:	83 e0 07             	and    $0x7,%eax
c0104c70:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0104c73:	eb 03                	jmp    c0104c78 <get_pgtable_items+0x73>
            start ++;
c0104c75:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0104c78:	8b 45 10             	mov    0x10(%ebp),%eax
c0104c7b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104c7e:	73 1d                	jae    c0104c9d <get_pgtable_items+0x98>
c0104c80:	8b 45 10             	mov    0x10(%ebp),%eax
c0104c83:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104c8a:	8b 45 14             	mov    0x14(%ebp),%eax
c0104c8d:	01 d0                	add    %edx,%eax
c0104c8f:	8b 00                	mov    (%eax),%eax
c0104c91:	83 e0 07             	and    $0x7,%eax
c0104c94:	89 c2                	mov    %eax,%edx
c0104c96:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104c99:	39 c2                	cmp    %eax,%edx
c0104c9b:	74 d8                	je     c0104c75 <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
c0104c9d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0104ca1:	74 08                	je     c0104cab <get_pgtable_items+0xa6>
            *right_store = start;
c0104ca3:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0104ca6:	8b 55 10             	mov    0x10(%ebp),%edx
c0104ca9:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0104cab:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104cae:	eb 05                	jmp    c0104cb5 <get_pgtable_items+0xb0>
    }
    return 0;
c0104cb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104cb5:	c9                   	leave  
c0104cb6:	c3                   	ret    

c0104cb7 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0104cb7:	55                   	push   %ebp
c0104cb8:	89 e5                	mov    %esp,%ebp
c0104cba:	57                   	push   %edi
c0104cbb:	56                   	push   %esi
c0104cbc:	53                   	push   %ebx
c0104cbd:	83 ec 2c             	sub    $0x2c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0104cc0:	83 ec 0c             	sub    $0xc,%esp
c0104cc3:	68 d4 68 10 c0       	push   $0xc01068d4
c0104cc8:	e8 6a b6 ff ff       	call   c0100337 <cprintf>
c0104ccd:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
c0104cd0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104cd7:	e9 e1 00 00 00       	jmp    c0104dbd <print_pgdir+0x106>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104cdc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104cdf:	83 ec 0c             	sub    $0xc,%esp
c0104ce2:	50                   	push   %eax
c0104ce3:	e8 db fe ff ff       	call   c0104bc3 <perm2str>
c0104ce8:	83 c4 10             	add    $0x10,%esp
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0104ceb:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0104cee:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104cf1:	29 d1                	sub    %edx,%ecx
c0104cf3:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104cf5:	89 d6                	mov    %edx,%esi
c0104cf7:	c1 e6 16             	shl    $0x16,%esi
c0104cfa:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104cfd:	89 d3                	mov    %edx,%ebx
c0104cff:	c1 e3 16             	shl    $0x16,%ebx
c0104d02:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104d05:	89 d1                	mov    %edx,%ecx
c0104d07:	c1 e1 16             	shl    $0x16,%ecx
c0104d0a:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0104d0d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104d10:	29 d7                	sub    %edx,%edi
c0104d12:	89 fa                	mov    %edi,%edx
c0104d14:	83 ec 08             	sub    $0x8,%esp
c0104d17:	50                   	push   %eax
c0104d18:	56                   	push   %esi
c0104d19:	53                   	push   %ebx
c0104d1a:	51                   	push   %ecx
c0104d1b:	52                   	push   %edx
c0104d1c:	68 05 69 10 c0       	push   $0xc0106905
c0104d21:	e8 11 b6 ff ff       	call   c0100337 <cprintf>
c0104d26:	83 c4 20             	add    $0x20,%esp
        size_t l, r = left * NPTEENTRY;
c0104d29:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104d2c:	c1 e0 0a             	shl    $0xa,%eax
c0104d2f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0104d32:	eb 4d                	jmp    c0104d81 <print_pgdir+0xca>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104d34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d37:	83 ec 0c             	sub    $0xc,%esp
c0104d3a:	50                   	push   %eax
c0104d3b:	e8 83 fe ff ff       	call   c0104bc3 <perm2str>
c0104d40:	83 c4 10             	add    $0x10,%esp
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0104d43:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0104d46:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104d49:	29 d1                	sub    %edx,%ecx
c0104d4b:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104d4d:	89 d6                	mov    %edx,%esi
c0104d4f:	c1 e6 0c             	shl    $0xc,%esi
c0104d52:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104d55:	89 d3                	mov    %edx,%ebx
c0104d57:	c1 e3 0c             	shl    $0xc,%ebx
c0104d5a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104d5d:	89 d1                	mov    %edx,%ecx
c0104d5f:	c1 e1 0c             	shl    $0xc,%ecx
c0104d62:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0104d65:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104d68:	29 d7                	sub    %edx,%edi
c0104d6a:	89 fa                	mov    %edi,%edx
c0104d6c:	83 ec 08             	sub    $0x8,%esp
c0104d6f:	50                   	push   %eax
c0104d70:	56                   	push   %esi
c0104d71:	53                   	push   %ebx
c0104d72:	51                   	push   %ecx
c0104d73:	52                   	push   %edx
c0104d74:	68 24 69 10 c0       	push   $0xc0106924
c0104d79:	e8 b9 b5 ff ff       	call   c0100337 <cprintf>
c0104d7e:	83 c4 20             	add    $0x20,%esp
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0104d81:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0104d86:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104d89:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104d8c:	89 d3                	mov    %edx,%ebx
c0104d8e:	c1 e3 0a             	shl    $0xa,%ebx
c0104d91:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104d94:	89 d1                	mov    %edx,%ecx
c0104d96:	c1 e1 0a             	shl    $0xa,%ecx
c0104d99:	83 ec 08             	sub    $0x8,%esp
c0104d9c:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c0104d9f:	52                   	push   %edx
c0104da0:	8d 55 d8             	lea    -0x28(%ebp),%edx
c0104da3:	52                   	push   %edx
c0104da4:	56                   	push   %esi
c0104da5:	50                   	push   %eax
c0104da6:	53                   	push   %ebx
c0104da7:	51                   	push   %ecx
c0104da8:	e8 58 fe ff ff       	call   c0104c05 <get_pgtable_items>
c0104dad:	83 c4 20             	add    $0x20,%esp
c0104db0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104db3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104db7:	0f 85 77 ff ff ff    	jne    c0104d34 <print_pgdir+0x7d>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104dbd:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c0104dc2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104dc5:	83 ec 08             	sub    $0x8,%esp
c0104dc8:	8d 55 dc             	lea    -0x24(%ebp),%edx
c0104dcb:	52                   	push   %edx
c0104dcc:	8d 55 e0             	lea    -0x20(%ebp),%edx
c0104dcf:	52                   	push   %edx
c0104dd0:	51                   	push   %ecx
c0104dd1:	50                   	push   %eax
c0104dd2:	68 00 04 00 00       	push   $0x400
c0104dd7:	6a 00                	push   $0x0
c0104dd9:	e8 27 fe ff ff       	call   c0104c05 <get_pgtable_items>
c0104dde:	83 c4 20             	add    $0x20,%esp
c0104de1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104de4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104de8:	0f 85 ee fe ff ff    	jne    c0104cdc <print_pgdir+0x25>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0104dee:	83 ec 0c             	sub    $0xc,%esp
c0104df1:	68 48 69 10 c0       	push   $0xc0106948
c0104df6:	e8 3c b5 ff ff       	call   c0100337 <cprintf>
c0104dfb:	83 c4 10             	add    $0x10,%esp
}
c0104dfe:	90                   	nop
c0104dff:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0104e02:	5b                   	pop    %ebx
c0104e03:	5e                   	pop    %esi
c0104e04:	5f                   	pop    %edi
c0104e05:	5d                   	pop    %ebp
c0104e06:	c3                   	ret    

c0104e07 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0104e07:	55                   	push   %ebp
c0104e08:	89 e5                	mov    %esp,%ebp
c0104e0a:	83 ec 38             	sub    $0x38,%esp
c0104e0d:	8b 45 10             	mov    0x10(%ebp),%eax
c0104e10:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104e13:	8b 45 14             	mov    0x14(%ebp),%eax
c0104e16:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0104e19:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104e1c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104e1f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104e22:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0104e25:	8b 45 18             	mov    0x18(%ebp),%eax
c0104e28:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104e2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104e2e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104e31:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104e34:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0104e37:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104e3d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104e41:	74 1c                	je     c0104e5f <printnum+0x58>
c0104e43:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e46:	ba 00 00 00 00       	mov    $0x0,%edx
c0104e4b:	f7 75 e4             	divl   -0x1c(%ebp)
c0104e4e:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0104e51:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e54:	ba 00 00 00 00       	mov    $0x0,%edx
c0104e59:	f7 75 e4             	divl   -0x1c(%ebp)
c0104e5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104e5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104e62:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104e65:	f7 75 e4             	divl   -0x1c(%ebp)
c0104e68:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104e6b:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0104e6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104e71:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104e74:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104e77:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0104e7a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104e7d:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0104e80:	8b 45 18             	mov    0x18(%ebp),%eax
c0104e83:	ba 00 00 00 00       	mov    $0x0,%edx
c0104e88:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0104e8b:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0104e8e:	19 d1                	sbb    %edx,%ecx
c0104e90:	72 35                	jb     c0104ec7 <printnum+0xc0>
        printnum(putch, putdat, result, base, width - 1, padc);
c0104e92:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0104e95:	48                   	dec    %eax
c0104e96:	83 ec 04             	sub    $0x4,%esp
c0104e99:	ff 75 20             	pushl  0x20(%ebp)
c0104e9c:	50                   	push   %eax
c0104e9d:	ff 75 18             	pushl  0x18(%ebp)
c0104ea0:	ff 75 ec             	pushl  -0x14(%ebp)
c0104ea3:	ff 75 e8             	pushl  -0x18(%ebp)
c0104ea6:	ff 75 0c             	pushl  0xc(%ebp)
c0104ea9:	ff 75 08             	pushl  0x8(%ebp)
c0104eac:	e8 56 ff ff ff       	call   c0104e07 <printnum>
c0104eb1:	83 c4 20             	add    $0x20,%esp
c0104eb4:	eb 1a                	jmp    c0104ed0 <printnum+0xc9>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0104eb6:	83 ec 08             	sub    $0x8,%esp
c0104eb9:	ff 75 0c             	pushl  0xc(%ebp)
c0104ebc:	ff 75 20             	pushl  0x20(%ebp)
c0104ebf:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ec2:	ff d0                	call   *%eax
c0104ec4:	83 c4 10             	add    $0x10,%esp
        while (-- width > 0)
c0104ec7:	ff 4d 1c             	decl   0x1c(%ebp)
c0104eca:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0104ece:	7f e6                	jg     c0104eb6 <printnum+0xaf>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0104ed0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104ed3:	05 fc 69 10 c0       	add    $0xc01069fc,%eax
c0104ed8:	8a 00                	mov    (%eax),%al
c0104eda:	0f be c0             	movsbl %al,%eax
c0104edd:	83 ec 08             	sub    $0x8,%esp
c0104ee0:	ff 75 0c             	pushl  0xc(%ebp)
c0104ee3:	50                   	push   %eax
c0104ee4:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ee7:	ff d0                	call   *%eax
c0104ee9:	83 c4 10             	add    $0x10,%esp
}
c0104eec:	90                   	nop
c0104eed:	c9                   	leave  
c0104eee:	c3                   	ret    

c0104eef <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0104eef:	55                   	push   %ebp
c0104ef0:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0104ef2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0104ef6:	7e 14                	jle    c0104f0c <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0104ef8:	8b 45 08             	mov    0x8(%ebp),%eax
c0104efb:	8b 00                	mov    (%eax),%eax
c0104efd:	8d 48 08             	lea    0x8(%eax),%ecx
c0104f00:	8b 55 08             	mov    0x8(%ebp),%edx
c0104f03:	89 0a                	mov    %ecx,(%edx)
c0104f05:	8b 50 04             	mov    0x4(%eax),%edx
c0104f08:	8b 00                	mov    (%eax),%eax
c0104f0a:	eb 30                	jmp    c0104f3c <getuint+0x4d>
    }
    else if (lflag) {
c0104f0c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104f10:	74 16                	je     c0104f28 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0104f12:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f15:	8b 00                	mov    (%eax),%eax
c0104f17:	8d 48 04             	lea    0x4(%eax),%ecx
c0104f1a:	8b 55 08             	mov    0x8(%ebp),%edx
c0104f1d:	89 0a                	mov    %ecx,(%edx)
c0104f1f:	8b 00                	mov    (%eax),%eax
c0104f21:	ba 00 00 00 00       	mov    $0x0,%edx
c0104f26:	eb 14                	jmp    c0104f3c <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0104f28:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f2b:	8b 00                	mov    (%eax),%eax
c0104f2d:	8d 48 04             	lea    0x4(%eax),%ecx
c0104f30:	8b 55 08             	mov    0x8(%ebp),%edx
c0104f33:	89 0a                	mov    %ecx,(%edx)
c0104f35:	8b 00                	mov    (%eax),%eax
c0104f37:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0104f3c:	5d                   	pop    %ebp
c0104f3d:	c3                   	ret    

c0104f3e <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0104f3e:	55                   	push   %ebp
c0104f3f:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0104f41:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0104f45:	7e 14                	jle    c0104f5b <getint+0x1d>
        return va_arg(*ap, long long);
c0104f47:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f4a:	8b 00                	mov    (%eax),%eax
c0104f4c:	8d 48 08             	lea    0x8(%eax),%ecx
c0104f4f:	8b 55 08             	mov    0x8(%ebp),%edx
c0104f52:	89 0a                	mov    %ecx,(%edx)
c0104f54:	8b 50 04             	mov    0x4(%eax),%edx
c0104f57:	8b 00                	mov    (%eax),%eax
c0104f59:	eb 28                	jmp    c0104f83 <getint+0x45>
    }
    else if (lflag) {
c0104f5b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104f5f:	74 12                	je     c0104f73 <getint+0x35>
        return va_arg(*ap, long);
c0104f61:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f64:	8b 00                	mov    (%eax),%eax
c0104f66:	8d 48 04             	lea    0x4(%eax),%ecx
c0104f69:	8b 55 08             	mov    0x8(%ebp),%edx
c0104f6c:	89 0a                	mov    %ecx,(%edx)
c0104f6e:	8b 00                	mov    (%eax),%eax
c0104f70:	99                   	cltd   
c0104f71:	eb 10                	jmp    c0104f83 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0104f73:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f76:	8b 00                	mov    (%eax),%eax
c0104f78:	8d 48 04             	lea    0x4(%eax),%ecx
c0104f7b:	8b 55 08             	mov    0x8(%ebp),%edx
c0104f7e:	89 0a                	mov    %ecx,(%edx)
c0104f80:	8b 00                	mov    (%eax),%eax
c0104f82:	99                   	cltd   
    }
}
c0104f83:	5d                   	pop    %ebp
c0104f84:	c3                   	ret    

c0104f85 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0104f85:	55                   	push   %ebp
c0104f86:	89 e5                	mov    %esp,%ebp
c0104f88:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
c0104f8b:	8d 45 14             	lea    0x14(%ebp),%eax
c0104f8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0104f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f94:	50                   	push   %eax
c0104f95:	ff 75 10             	pushl  0x10(%ebp)
c0104f98:	ff 75 0c             	pushl  0xc(%ebp)
c0104f9b:	ff 75 08             	pushl  0x8(%ebp)
c0104f9e:	e8 06 00 00 00       	call   c0104fa9 <vprintfmt>
c0104fa3:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c0104fa6:	90                   	nop
c0104fa7:	c9                   	leave  
c0104fa8:	c3                   	ret    

c0104fa9 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0104fa9:	55                   	push   %ebp
c0104faa:	89 e5                	mov    %esp,%ebp
c0104fac:	56                   	push   %esi
c0104fad:	53                   	push   %ebx
c0104fae:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0104fb1:	eb 17                	jmp    c0104fca <vprintfmt+0x21>
            if (ch == '\0') {
c0104fb3:	85 db                	test   %ebx,%ebx
c0104fb5:	0f 84 7c 03 00 00    	je     c0105337 <vprintfmt+0x38e>
                return;
            }
            putch(ch, putdat);
c0104fbb:	83 ec 08             	sub    $0x8,%esp
c0104fbe:	ff 75 0c             	pushl  0xc(%ebp)
c0104fc1:	53                   	push   %ebx
c0104fc2:	8b 45 08             	mov    0x8(%ebp),%eax
c0104fc5:	ff d0                	call   *%eax
c0104fc7:	83 c4 10             	add    $0x10,%esp
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0104fca:	8b 45 10             	mov    0x10(%ebp),%eax
c0104fcd:	8d 50 01             	lea    0x1(%eax),%edx
c0104fd0:	89 55 10             	mov    %edx,0x10(%ebp)
c0104fd3:	8a 00                	mov    (%eax),%al
c0104fd5:	0f b6 d8             	movzbl %al,%ebx
c0104fd8:	83 fb 25             	cmp    $0x25,%ebx
c0104fdb:	75 d6                	jne    c0104fb3 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c0104fdd:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0104fe1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0104fe8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104feb:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0104fee:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104ff5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104ff8:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0104ffb:	8b 45 10             	mov    0x10(%ebp),%eax
c0104ffe:	8d 50 01             	lea    0x1(%eax),%edx
c0105001:	89 55 10             	mov    %edx,0x10(%ebp)
c0105004:	8a 00                	mov    (%eax),%al
c0105006:	0f b6 d8             	movzbl %al,%ebx
c0105009:	8d 43 dd             	lea    -0x23(%ebx),%eax
c010500c:	83 f8 55             	cmp    $0x55,%eax
c010500f:	0f 87 fa 02 00 00    	ja     c010530f <vprintfmt+0x366>
c0105015:	8b 04 85 20 6a 10 c0 	mov    -0x3fef95e0(,%eax,4),%eax
c010501c:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c010501e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105022:	eb d7                	jmp    c0104ffb <vprintfmt+0x52>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105024:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105028:	eb d1                	jmp    c0104ffb <vprintfmt+0x52>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010502a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105031:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105034:	89 d0                	mov    %edx,%eax
c0105036:	c1 e0 02             	shl    $0x2,%eax
c0105039:	01 d0                	add    %edx,%eax
c010503b:	01 c0                	add    %eax,%eax
c010503d:	01 d8                	add    %ebx,%eax
c010503f:	83 e8 30             	sub    $0x30,%eax
c0105042:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105045:	8b 45 10             	mov    0x10(%ebp),%eax
c0105048:	8a 00                	mov    (%eax),%al
c010504a:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c010504d:	83 fb 2f             	cmp    $0x2f,%ebx
c0105050:	7e 35                	jle    c0105087 <vprintfmt+0xde>
c0105052:	83 fb 39             	cmp    $0x39,%ebx
c0105055:	7f 30                	jg     c0105087 <vprintfmt+0xde>
            for (precision = 0; ; ++ fmt) {
c0105057:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
c010505a:	eb d5                	jmp    c0105031 <vprintfmt+0x88>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c010505c:	8b 45 14             	mov    0x14(%ebp),%eax
c010505f:	8d 50 04             	lea    0x4(%eax),%edx
c0105062:	89 55 14             	mov    %edx,0x14(%ebp)
c0105065:	8b 00                	mov    (%eax),%eax
c0105067:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c010506a:	eb 1c                	jmp    c0105088 <vprintfmt+0xdf>

        case '.':
            if (width < 0)
c010506c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105070:	79 89                	jns    c0104ffb <vprintfmt+0x52>
                width = 0;
c0105072:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0105079:	eb 80                	jmp    c0104ffb <vprintfmt+0x52>

        case '#':
            altflag = 1;
c010507b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105082:	e9 74 ff ff ff       	jmp    c0104ffb <vprintfmt+0x52>
            goto process_precision;
c0105087:	90                   	nop

        process_precision:
            if (width < 0)
c0105088:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010508c:	0f 89 69 ff ff ff    	jns    c0104ffb <vprintfmt+0x52>
                width = precision, precision = -1;
c0105092:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105095:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105098:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c010509f:	e9 57 ff ff ff       	jmp    c0104ffb <vprintfmt+0x52>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01050a4:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c01050a7:	e9 4f ff ff ff       	jmp    c0104ffb <vprintfmt+0x52>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01050ac:	8b 45 14             	mov    0x14(%ebp),%eax
c01050af:	8d 50 04             	lea    0x4(%eax),%edx
c01050b2:	89 55 14             	mov    %edx,0x14(%ebp)
c01050b5:	8b 00                	mov    (%eax),%eax
c01050b7:	83 ec 08             	sub    $0x8,%esp
c01050ba:	ff 75 0c             	pushl  0xc(%ebp)
c01050bd:	50                   	push   %eax
c01050be:	8b 45 08             	mov    0x8(%ebp),%eax
c01050c1:	ff d0                	call   *%eax
c01050c3:	83 c4 10             	add    $0x10,%esp
            break;
c01050c6:	e9 67 02 00 00       	jmp    c0105332 <vprintfmt+0x389>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01050cb:	8b 45 14             	mov    0x14(%ebp),%eax
c01050ce:	8d 50 04             	lea    0x4(%eax),%edx
c01050d1:	89 55 14             	mov    %edx,0x14(%ebp)
c01050d4:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01050d6:	85 db                	test   %ebx,%ebx
c01050d8:	79 02                	jns    c01050dc <vprintfmt+0x133>
                err = -err;
c01050da:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c01050dc:	83 fb 06             	cmp    $0x6,%ebx
c01050df:	7f 0b                	jg     c01050ec <vprintfmt+0x143>
c01050e1:	8b 34 9d e0 69 10 c0 	mov    -0x3fef9620(,%ebx,4),%esi
c01050e8:	85 f6                	test   %esi,%esi
c01050ea:	75 19                	jne    c0105105 <vprintfmt+0x15c>
                printfmt(putch, putdat, "error %d", err);
c01050ec:	53                   	push   %ebx
c01050ed:	68 0d 6a 10 c0       	push   $0xc0106a0d
c01050f2:	ff 75 0c             	pushl  0xc(%ebp)
c01050f5:	ff 75 08             	pushl  0x8(%ebp)
c01050f8:	e8 88 fe ff ff       	call   c0104f85 <printfmt>
c01050fd:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105100:	e9 2d 02 00 00       	jmp    c0105332 <vprintfmt+0x389>
                printfmt(putch, putdat, "%s", p);
c0105105:	56                   	push   %esi
c0105106:	68 16 6a 10 c0       	push   $0xc0106a16
c010510b:	ff 75 0c             	pushl  0xc(%ebp)
c010510e:	ff 75 08             	pushl  0x8(%ebp)
c0105111:	e8 6f fe ff ff       	call   c0104f85 <printfmt>
c0105116:	83 c4 10             	add    $0x10,%esp
            break;
c0105119:	e9 14 02 00 00       	jmp    c0105332 <vprintfmt+0x389>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c010511e:	8b 45 14             	mov    0x14(%ebp),%eax
c0105121:	8d 50 04             	lea    0x4(%eax),%edx
c0105124:	89 55 14             	mov    %edx,0x14(%ebp)
c0105127:	8b 30                	mov    (%eax),%esi
c0105129:	85 f6                	test   %esi,%esi
c010512b:	75 05                	jne    c0105132 <vprintfmt+0x189>
                p = "(null)";
c010512d:	be 19 6a 10 c0       	mov    $0xc0106a19,%esi
            }
            if (width > 0 && padc != '-') {
c0105132:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105136:	7e 74                	jle    c01051ac <vprintfmt+0x203>
c0105138:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c010513c:	74 6e                	je     c01051ac <vprintfmt+0x203>
                for (width -= strnlen(p, precision); width > 0; width --) {
c010513e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105141:	83 ec 08             	sub    $0x8,%esp
c0105144:	50                   	push   %eax
c0105145:	56                   	push   %esi
c0105146:	e8 d3 02 00 00       	call   c010541e <strnlen>
c010514b:	83 c4 10             	add    $0x10,%esp
c010514e:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105151:	29 c2                	sub    %eax,%edx
c0105153:	89 d0                	mov    %edx,%eax
c0105155:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105158:	eb 16                	jmp    c0105170 <vprintfmt+0x1c7>
                    putch(padc, putdat);
c010515a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c010515e:	83 ec 08             	sub    $0x8,%esp
c0105161:	ff 75 0c             	pushl  0xc(%ebp)
c0105164:	50                   	push   %eax
c0105165:	8b 45 08             	mov    0x8(%ebp),%eax
c0105168:	ff d0                	call   *%eax
c010516a:	83 c4 10             	add    $0x10,%esp
                for (width -= strnlen(p, precision); width > 0; width --) {
c010516d:	ff 4d e8             	decl   -0x18(%ebp)
c0105170:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105174:	7f e4                	jg     c010515a <vprintfmt+0x1b1>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105176:	eb 34                	jmp    c01051ac <vprintfmt+0x203>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105178:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010517c:	74 1c                	je     c010519a <vprintfmt+0x1f1>
c010517e:	83 fb 1f             	cmp    $0x1f,%ebx
c0105181:	7e 05                	jle    c0105188 <vprintfmt+0x1df>
c0105183:	83 fb 7e             	cmp    $0x7e,%ebx
c0105186:	7e 12                	jle    c010519a <vprintfmt+0x1f1>
                    putch('?', putdat);
c0105188:	83 ec 08             	sub    $0x8,%esp
c010518b:	ff 75 0c             	pushl  0xc(%ebp)
c010518e:	6a 3f                	push   $0x3f
c0105190:	8b 45 08             	mov    0x8(%ebp),%eax
c0105193:	ff d0                	call   *%eax
c0105195:	83 c4 10             	add    $0x10,%esp
c0105198:	eb 0f                	jmp    c01051a9 <vprintfmt+0x200>
                }
                else {
                    putch(ch, putdat);
c010519a:	83 ec 08             	sub    $0x8,%esp
c010519d:	ff 75 0c             	pushl  0xc(%ebp)
c01051a0:	53                   	push   %ebx
c01051a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01051a4:	ff d0                	call   *%eax
c01051a6:	83 c4 10             	add    $0x10,%esp
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01051a9:	ff 4d e8             	decl   -0x18(%ebp)
c01051ac:	89 f0                	mov    %esi,%eax
c01051ae:	8d 70 01             	lea    0x1(%eax),%esi
c01051b1:	8a 00                	mov    (%eax),%al
c01051b3:	0f be d8             	movsbl %al,%ebx
c01051b6:	85 db                	test   %ebx,%ebx
c01051b8:	74 24                	je     c01051de <vprintfmt+0x235>
c01051ba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01051be:	78 b8                	js     c0105178 <vprintfmt+0x1cf>
c01051c0:	ff 4d e4             	decl   -0x1c(%ebp)
c01051c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01051c7:	79 af                	jns    c0105178 <vprintfmt+0x1cf>
                }
            }
            for (; width > 0; width --) {
c01051c9:	eb 13                	jmp    c01051de <vprintfmt+0x235>
                putch(' ', putdat);
c01051cb:	83 ec 08             	sub    $0x8,%esp
c01051ce:	ff 75 0c             	pushl  0xc(%ebp)
c01051d1:	6a 20                	push   $0x20
c01051d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01051d6:	ff d0                	call   *%eax
c01051d8:	83 c4 10             	add    $0x10,%esp
            for (; width > 0; width --) {
c01051db:	ff 4d e8             	decl   -0x18(%ebp)
c01051de:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01051e2:	7f e7                	jg     c01051cb <vprintfmt+0x222>
            }
            break;
c01051e4:	e9 49 01 00 00       	jmp    c0105332 <vprintfmt+0x389>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c01051e9:	83 ec 08             	sub    $0x8,%esp
c01051ec:	ff 75 e0             	pushl  -0x20(%ebp)
c01051ef:	8d 45 14             	lea    0x14(%ebp),%eax
c01051f2:	50                   	push   %eax
c01051f3:	e8 46 fd ff ff       	call   c0104f3e <getint>
c01051f8:	83 c4 10             	add    $0x10,%esp
c01051fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01051fe:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105201:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105204:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105207:	85 d2                	test   %edx,%edx
c0105209:	79 23                	jns    c010522e <vprintfmt+0x285>
                putch('-', putdat);
c010520b:	83 ec 08             	sub    $0x8,%esp
c010520e:	ff 75 0c             	pushl  0xc(%ebp)
c0105211:	6a 2d                	push   $0x2d
c0105213:	8b 45 08             	mov    0x8(%ebp),%eax
c0105216:	ff d0                	call   *%eax
c0105218:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
c010521b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010521e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105221:	f7 d8                	neg    %eax
c0105223:	83 d2 00             	adc    $0x0,%edx
c0105226:	f7 da                	neg    %edx
c0105228:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010522b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c010522e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105235:	e9 9f 00 00 00       	jmp    c01052d9 <vprintfmt+0x330>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c010523a:	83 ec 08             	sub    $0x8,%esp
c010523d:	ff 75 e0             	pushl  -0x20(%ebp)
c0105240:	8d 45 14             	lea    0x14(%ebp),%eax
c0105243:	50                   	push   %eax
c0105244:	e8 a6 fc ff ff       	call   c0104eef <getuint>
c0105249:	83 c4 10             	add    $0x10,%esp
c010524c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010524f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105252:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105259:	eb 7e                	jmp    c01052d9 <vprintfmt+0x330>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c010525b:	83 ec 08             	sub    $0x8,%esp
c010525e:	ff 75 e0             	pushl  -0x20(%ebp)
c0105261:	8d 45 14             	lea    0x14(%ebp),%eax
c0105264:	50                   	push   %eax
c0105265:	e8 85 fc ff ff       	call   c0104eef <getuint>
c010526a:	83 c4 10             	add    $0x10,%esp
c010526d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105270:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105273:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c010527a:	eb 5d                	jmp    c01052d9 <vprintfmt+0x330>

        // pointer
        case 'p':
            putch('0', putdat);
c010527c:	83 ec 08             	sub    $0x8,%esp
c010527f:	ff 75 0c             	pushl  0xc(%ebp)
c0105282:	6a 30                	push   $0x30
c0105284:	8b 45 08             	mov    0x8(%ebp),%eax
c0105287:	ff d0                	call   *%eax
c0105289:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
c010528c:	83 ec 08             	sub    $0x8,%esp
c010528f:	ff 75 0c             	pushl  0xc(%ebp)
c0105292:	6a 78                	push   $0x78
c0105294:	8b 45 08             	mov    0x8(%ebp),%eax
c0105297:	ff d0                	call   *%eax
c0105299:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c010529c:	8b 45 14             	mov    0x14(%ebp),%eax
c010529f:	8d 50 04             	lea    0x4(%eax),%edx
c01052a2:	89 55 14             	mov    %edx,0x14(%ebp)
c01052a5:	8b 00                	mov    (%eax),%eax
c01052a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01052aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c01052b1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c01052b8:	eb 1f                	jmp    c01052d9 <vprintfmt+0x330>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c01052ba:	83 ec 08             	sub    $0x8,%esp
c01052bd:	ff 75 e0             	pushl  -0x20(%ebp)
c01052c0:	8d 45 14             	lea    0x14(%ebp),%eax
c01052c3:	50                   	push   %eax
c01052c4:	e8 26 fc ff ff       	call   c0104eef <getuint>
c01052c9:	83 c4 10             	add    $0x10,%esp
c01052cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01052cf:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c01052d2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c01052d9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c01052dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01052e0:	83 ec 04             	sub    $0x4,%esp
c01052e3:	52                   	push   %edx
c01052e4:	ff 75 e8             	pushl  -0x18(%ebp)
c01052e7:	50                   	push   %eax
c01052e8:	ff 75 f4             	pushl  -0xc(%ebp)
c01052eb:	ff 75 f0             	pushl  -0x10(%ebp)
c01052ee:	ff 75 0c             	pushl  0xc(%ebp)
c01052f1:	ff 75 08             	pushl  0x8(%ebp)
c01052f4:	e8 0e fb ff ff       	call   c0104e07 <printnum>
c01052f9:	83 c4 20             	add    $0x20,%esp
            break;
c01052fc:	eb 34                	jmp    c0105332 <vprintfmt+0x389>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01052fe:	83 ec 08             	sub    $0x8,%esp
c0105301:	ff 75 0c             	pushl  0xc(%ebp)
c0105304:	53                   	push   %ebx
c0105305:	8b 45 08             	mov    0x8(%ebp),%eax
c0105308:	ff d0                	call   *%eax
c010530a:	83 c4 10             	add    $0x10,%esp
            break;
c010530d:	eb 23                	jmp    c0105332 <vprintfmt+0x389>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c010530f:	83 ec 08             	sub    $0x8,%esp
c0105312:	ff 75 0c             	pushl  0xc(%ebp)
c0105315:	6a 25                	push   $0x25
c0105317:	8b 45 08             	mov    0x8(%ebp),%eax
c010531a:	ff d0                	call   *%eax
c010531c:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
c010531f:	ff 4d 10             	decl   0x10(%ebp)
c0105322:	eb 03                	jmp    c0105327 <vprintfmt+0x37e>
c0105324:	ff 4d 10             	decl   0x10(%ebp)
c0105327:	8b 45 10             	mov    0x10(%ebp),%eax
c010532a:	48                   	dec    %eax
c010532b:	8a 00                	mov    (%eax),%al
c010532d:	3c 25                	cmp    $0x25,%al
c010532f:	75 f3                	jne    c0105324 <vprintfmt+0x37b>
                /* do nothing */;
            break;
c0105331:	90                   	nop
    while (1) {
c0105332:	e9 7a fc ff ff       	jmp    c0104fb1 <vprintfmt+0x8>
                return;
c0105337:	90                   	nop
        }
    }
}
c0105338:	8d 65 f8             	lea    -0x8(%ebp),%esp
c010533b:	5b                   	pop    %ebx
c010533c:	5e                   	pop    %esi
c010533d:	5d                   	pop    %ebp
c010533e:	c3                   	ret    

c010533f <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c010533f:	55                   	push   %ebp
c0105340:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105342:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105345:	8b 40 08             	mov    0x8(%eax),%eax
c0105348:	8d 50 01             	lea    0x1(%eax),%edx
c010534b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010534e:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105351:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105354:	8b 10                	mov    (%eax),%edx
c0105356:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105359:	8b 40 04             	mov    0x4(%eax),%eax
c010535c:	39 c2                	cmp    %eax,%edx
c010535e:	73 12                	jae    c0105372 <sprintputch+0x33>
        *b->buf ++ = ch;
c0105360:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105363:	8b 00                	mov    (%eax),%eax
c0105365:	8d 48 01             	lea    0x1(%eax),%ecx
c0105368:	8b 55 0c             	mov    0xc(%ebp),%edx
c010536b:	89 0a                	mov    %ecx,(%edx)
c010536d:	8b 55 08             	mov    0x8(%ebp),%edx
c0105370:	88 10                	mov    %dl,(%eax)
    }
}
c0105372:	90                   	nop
c0105373:	5d                   	pop    %ebp
c0105374:	c3                   	ret    

c0105375 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105375:	55                   	push   %ebp
c0105376:	89 e5                	mov    %esp,%ebp
c0105378:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010537b:	8d 45 14             	lea    0x14(%ebp),%eax
c010537e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105381:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105384:	50                   	push   %eax
c0105385:	ff 75 10             	pushl  0x10(%ebp)
c0105388:	ff 75 0c             	pushl  0xc(%ebp)
c010538b:	ff 75 08             	pushl  0x8(%ebp)
c010538e:	e8 0b 00 00 00       	call   c010539e <vsnprintf>
c0105393:	83 c4 10             	add    $0x10,%esp
c0105396:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105399:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010539c:	c9                   	leave  
c010539d:	c3                   	ret    

c010539e <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c010539e:	55                   	push   %ebp
c010539f:	89 e5                	mov    %esp,%ebp
c01053a1:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c01053a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01053a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01053aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01053ad:	8d 50 ff             	lea    -0x1(%eax),%edx
c01053b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01053b3:	01 d0                	add    %edx,%eax
c01053b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01053b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c01053bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01053c3:	74 0a                	je     c01053cf <vsnprintf+0x31>
c01053c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01053c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053cb:	39 c2                	cmp    %eax,%edx
c01053cd:	76 07                	jbe    c01053d6 <vsnprintf+0x38>
        return -E_INVAL;
c01053cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c01053d4:	eb 20                	jmp    c01053f6 <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c01053d6:	ff 75 14             	pushl  0x14(%ebp)
c01053d9:	ff 75 10             	pushl  0x10(%ebp)
c01053dc:	8d 45 ec             	lea    -0x14(%ebp),%eax
c01053df:	50                   	push   %eax
c01053e0:	68 3f 53 10 c0       	push   $0xc010533f
c01053e5:	e8 bf fb ff ff       	call   c0104fa9 <vprintfmt>
c01053ea:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
c01053ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01053f0:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c01053f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01053f6:	c9                   	leave  
c01053f7:	c3                   	ret    

c01053f8 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c01053f8:	55                   	push   %ebp
c01053f9:	89 e5                	mov    %esp,%ebp
c01053fb:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01053fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105405:	eb 03                	jmp    c010540a <strlen+0x12>
        cnt ++;
c0105407:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
c010540a:	8b 45 08             	mov    0x8(%ebp),%eax
c010540d:	8d 50 01             	lea    0x1(%eax),%edx
c0105410:	89 55 08             	mov    %edx,0x8(%ebp)
c0105413:	8a 00                	mov    (%eax),%al
c0105415:	84 c0                	test   %al,%al
c0105417:	75 ee                	jne    c0105407 <strlen+0xf>
    }
    return cnt;
c0105419:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010541c:	c9                   	leave  
c010541d:	c3                   	ret    

c010541e <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c010541e:	55                   	push   %ebp
c010541f:	89 e5                	mov    %esp,%ebp
c0105421:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105424:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c010542b:	eb 03                	jmp    c0105430 <strnlen+0x12>
        cnt ++;
c010542d:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105430:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105433:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105436:	73 0f                	jae    c0105447 <strnlen+0x29>
c0105438:	8b 45 08             	mov    0x8(%ebp),%eax
c010543b:	8d 50 01             	lea    0x1(%eax),%edx
c010543e:	89 55 08             	mov    %edx,0x8(%ebp)
c0105441:	8a 00                	mov    (%eax),%al
c0105443:	84 c0                	test   %al,%al
c0105445:	75 e6                	jne    c010542d <strnlen+0xf>
    }
    return cnt;
c0105447:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010544a:	c9                   	leave  
c010544b:	c3                   	ret    

c010544c <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c010544c:	55                   	push   %ebp
c010544d:	89 e5                	mov    %esp,%ebp
c010544f:	57                   	push   %edi
c0105450:	56                   	push   %esi
c0105451:	83 ec 20             	sub    $0x20,%esp
c0105454:	8b 45 08             	mov    0x8(%ebp),%eax
c0105457:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010545a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010545d:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105460:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105463:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105466:	89 d1                	mov    %edx,%ecx
c0105468:	89 c2                	mov    %eax,%edx
c010546a:	89 ce                	mov    %ecx,%esi
c010546c:	89 d7                	mov    %edx,%edi
c010546e:	ac                   	lods   %ds:(%esi),%al
c010546f:	aa                   	stos   %al,%es:(%edi)
c0105470:	84 c0                	test   %al,%al
c0105472:	75 fa                	jne    c010546e <strcpy+0x22>
c0105474:	89 fa                	mov    %edi,%edx
c0105476:	89 f1                	mov    %esi,%ecx
c0105478:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010547b:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010547e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105481:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
c0105484:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105485:	83 c4 20             	add    $0x20,%esp
c0105488:	5e                   	pop    %esi
c0105489:	5f                   	pop    %edi
c010548a:	5d                   	pop    %ebp
c010548b:	c3                   	ret    

c010548c <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c010548c:	55                   	push   %ebp
c010548d:	89 e5                	mov    %esp,%ebp
c010548f:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105492:	8b 45 08             	mov    0x8(%ebp),%eax
c0105495:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105498:	eb 1c                	jmp    c01054b6 <strncpy+0x2a>
        if ((*p = *src) != '\0') {
c010549a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010549d:	8a 10                	mov    (%eax),%dl
c010549f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01054a2:	88 10                	mov    %dl,(%eax)
c01054a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01054a7:	8a 00                	mov    (%eax),%al
c01054a9:	84 c0                	test   %al,%al
c01054ab:	74 03                	je     c01054b0 <strncpy+0x24>
            src ++;
c01054ad:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
c01054b0:	ff 45 fc             	incl   -0x4(%ebp)
c01054b3:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
c01054b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01054ba:	75 de                	jne    c010549a <strncpy+0xe>
    }
    return dst;
c01054bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01054bf:	c9                   	leave  
c01054c0:	c3                   	ret    

c01054c1 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c01054c1:	55                   	push   %ebp
c01054c2:	89 e5                	mov    %esp,%ebp
c01054c4:	57                   	push   %edi
c01054c5:	56                   	push   %esi
c01054c6:	83 ec 20             	sub    $0x20,%esp
c01054c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01054cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01054cf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c01054d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01054d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054db:	89 d1                	mov    %edx,%ecx
c01054dd:	89 c2                	mov    %eax,%edx
c01054df:	89 ce                	mov    %ecx,%esi
c01054e1:	89 d7                	mov    %edx,%edi
c01054e3:	ac                   	lods   %ds:(%esi),%al
c01054e4:	ae                   	scas   %es:(%edi),%al
c01054e5:	75 08                	jne    c01054ef <strcmp+0x2e>
c01054e7:	84 c0                	test   %al,%al
c01054e9:	75 f8                	jne    c01054e3 <strcmp+0x22>
c01054eb:	31 c0                	xor    %eax,%eax
c01054ed:	eb 04                	jmp    c01054f3 <strcmp+0x32>
c01054ef:	19 c0                	sbb    %eax,%eax
c01054f1:	0c 01                	or     $0x1,%al
c01054f3:	89 fa                	mov    %edi,%edx
c01054f5:	89 f1                	mov    %esi,%ecx
c01054f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01054fa:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01054fd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c0105500:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
c0105503:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105504:	83 c4 20             	add    $0x20,%esp
c0105507:	5e                   	pop    %esi
c0105508:	5f                   	pop    %edi
c0105509:	5d                   	pop    %ebp
c010550a:	c3                   	ret    

c010550b <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c010550b:	55                   	push   %ebp
c010550c:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010550e:	eb 09                	jmp    c0105519 <strncmp+0xe>
        n --, s1 ++, s2 ++;
c0105510:	ff 4d 10             	decl   0x10(%ebp)
c0105513:	ff 45 08             	incl   0x8(%ebp)
c0105516:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105519:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010551d:	74 17                	je     c0105536 <strncmp+0x2b>
c010551f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105522:	8a 00                	mov    (%eax),%al
c0105524:	84 c0                	test   %al,%al
c0105526:	74 0e                	je     c0105536 <strncmp+0x2b>
c0105528:	8b 45 08             	mov    0x8(%ebp),%eax
c010552b:	8a 10                	mov    (%eax),%dl
c010552d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105530:	8a 00                	mov    (%eax),%al
c0105532:	38 c2                	cmp    %al,%dl
c0105534:	74 da                	je     c0105510 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105536:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010553a:	74 16                	je     c0105552 <strncmp+0x47>
c010553c:	8b 45 08             	mov    0x8(%ebp),%eax
c010553f:	8a 00                	mov    (%eax),%al
c0105541:	0f b6 d0             	movzbl %al,%edx
c0105544:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105547:	8a 00                	mov    (%eax),%al
c0105549:	0f b6 c0             	movzbl %al,%eax
c010554c:	29 c2                	sub    %eax,%edx
c010554e:	89 d0                	mov    %edx,%eax
c0105550:	eb 05                	jmp    c0105557 <strncmp+0x4c>
c0105552:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105557:	5d                   	pop    %ebp
c0105558:	c3                   	ret    

c0105559 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105559:	55                   	push   %ebp
c010555a:	89 e5                	mov    %esp,%ebp
c010555c:	83 ec 04             	sub    $0x4,%esp
c010555f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105562:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105565:	eb 12                	jmp    c0105579 <strchr+0x20>
        if (*s == c) {
c0105567:	8b 45 08             	mov    0x8(%ebp),%eax
c010556a:	8a 00                	mov    (%eax),%al
c010556c:	38 45 fc             	cmp    %al,-0x4(%ebp)
c010556f:	75 05                	jne    c0105576 <strchr+0x1d>
            return (char *)s;
c0105571:	8b 45 08             	mov    0x8(%ebp),%eax
c0105574:	eb 11                	jmp    c0105587 <strchr+0x2e>
        }
        s ++;
c0105576:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0105579:	8b 45 08             	mov    0x8(%ebp),%eax
c010557c:	8a 00                	mov    (%eax),%al
c010557e:	84 c0                	test   %al,%al
c0105580:	75 e5                	jne    c0105567 <strchr+0xe>
    }
    return NULL;
c0105582:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105587:	c9                   	leave  
c0105588:	c3                   	ret    

c0105589 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105589:	55                   	push   %ebp
c010558a:	89 e5                	mov    %esp,%ebp
c010558c:	83 ec 04             	sub    $0x4,%esp
c010558f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105592:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105595:	eb 0d                	jmp    c01055a4 <strfind+0x1b>
        if (*s == c) {
c0105597:	8b 45 08             	mov    0x8(%ebp),%eax
c010559a:	8a 00                	mov    (%eax),%al
c010559c:	38 45 fc             	cmp    %al,-0x4(%ebp)
c010559f:	74 0e                	je     c01055af <strfind+0x26>
            break;
        }
        s ++;
c01055a1:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c01055a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01055a7:	8a 00                	mov    (%eax),%al
c01055a9:	84 c0                	test   %al,%al
c01055ab:	75 ea                	jne    c0105597 <strfind+0xe>
c01055ad:	eb 01                	jmp    c01055b0 <strfind+0x27>
            break;
c01055af:	90                   	nop
    }
    return (char *)s;
c01055b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01055b3:	c9                   	leave  
c01055b4:	c3                   	ret    

c01055b5 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c01055b5:	55                   	push   %ebp
c01055b6:	89 e5                	mov    %esp,%ebp
c01055b8:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c01055bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c01055c2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01055c9:	eb 03                	jmp    c01055ce <strtol+0x19>
        s ++;
c01055cb:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c01055ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01055d1:	8a 00                	mov    (%eax),%al
c01055d3:	3c 20                	cmp    $0x20,%al
c01055d5:	74 f4                	je     c01055cb <strtol+0x16>
c01055d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01055da:	8a 00                	mov    (%eax),%al
c01055dc:	3c 09                	cmp    $0x9,%al
c01055de:	74 eb                	je     c01055cb <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
c01055e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01055e3:	8a 00                	mov    (%eax),%al
c01055e5:	3c 2b                	cmp    $0x2b,%al
c01055e7:	75 05                	jne    c01055ee <strtol+0x39>
        s ++;
c01055e9:	ff 45 08             	incl   0x8(%ebp)
c01055ec:	eb 13                	jmp    c0105601 <strtol+0x4c>
    }
    else if (*s == '-') {
c01055ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01055f1:	8a 00                	mov    (%eax),%al
c01055f3:	3c 2d                	cmp    $0x2d,%al
c01055f5:	75 0a                	jne    c0105601 <strtol+0x4c>
        s ++, neg = 1;
c01055f7:	ff 45 08             	incl   0x8(%ebp)
c01055fa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105601:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105605:	74 06                	je     c010560d <strtol+0x58>
c0105607:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c010560b:	75 20                	jne    c010562d <strtol+0x78>
c010560d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105610:	8a 00                	mov    (%eax),%al
c0105612:	3c 30                	cmp    $0x30,%al
c0105614:	75 17                	jne    c010562d <strtol+0x78>
c0105616:	8b 45 08             	mov    0x8(%ebp),%eax
c0105619:	40                   	inc    %eax
c010561a:	8a 00                	mov    (%eax),%al
c010561c:	3c 78                	cmp    $0x78,%al
c010561e:	75 0d                	jne    c010562d <strtol+0x78>
        s += 2, base = 16;
c0105620:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105624:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c010562b:	eb 28                	jmp    c0105655 <strtol+0xa0>
    }
    else if (base == 0 && s[0] == '0') {
c010562d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105631:	75 15                	jne    c0105648 <strtol+0x93>
c0105633:	8b 45 08             	mov    0x8(%ebp),%eax
c0105636:	8a 00                	mov    (%eax),%al
c0105638:	3c 30                	cmp    $0x30,%al
c010563a:	75 0c                	jne    c0105648 <strtol+0x93>
        s ++, base = 8;
c010563c:	ff 45 08             	incl   0x8(%ebp)
c010563f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105646:	eb 0d                	jmp    c0105655 <strtol+0xa0>
    }
    else if (base == 0) {
c0105648:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010564c:	75 07                	jne    c0105655 <strtol+0xa0>
        base = 10;
c010564e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105655:	8b 45 08             	mov    0x8(%ebp),%eax
c0105658:	8a 00                	mov    (%eax),%al
c010565a:	3c 2f                	cmp    $0x2f,%al
c010565c:	7e 19                	jle    c0105677 <strtol+0xc2>
c010565e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105661:	8a 00                	mov    (%eax),%al
c0105663:	3c 39                	cmp    $0x39,%al
c0105665:	7f 10                	jg     c0105677 <strtol+0xc2>
            dig = *s - '0';
c0105667:	8b 45 08             	mov    0x8(%ebp),%eax
c010566a:	8a 00                	mov    (%eax),%al
c010566c:	0f be c0             	movsbl %al,%eax
c010566f:	83 e8 30             	sub    $0x30,%eax
c0105672:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105675:	eb 42                	jmp    c01056b9 <strtol+0x104>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105677:	8b 45 08             	mov    0x8(%ebp),%eax
c010567a:	8a 00                	mov    (%eax),%al
c010567c:	3c 60                	cmp    $0x60,%al
c010567e:	7e 19                	jle    c0105699 <strtol+0xe4>
c0105680:	8b 45 08             	mov    0x8(%ebp),%eax
c0105683:	8a 00                	mov    (%eax),%al
c0105685:	3c 7a                	cmp    $0x7a,%al
c0105687:	7f 10                	jg     c0105699 <strtol+0xe4>
            dig = *s - 'a' + 10;
c0105689:	8b 45 08             	mov    0x8(%ebp),%eax
c010568c:	8a 00                	mov    (%eax),%al
c010568e:	0f be c0             	movsbl %al,%eax
c0105691:	83 e8 57             	sub    $0x57,%eax
c0105694:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105697:	eb 20                	jmp    c01056b9 <strtol+0x104>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105699:	8b 45 08             	mov    0x8(%ebp),%eax
c010569c:	8a 00                	mov    (%eax),%al
c010569e:	3c 40                	cmp    $0x40,%al
c01056a0:	7e 39                	jle    c01056db <strtol+0x126>
c01056a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01056a5:	8a 00                	mov    (%eax),%al
c01056a7:	3c 5a                	cmp    $0x5a,%al
c01056a9:	7f 30                	jg     c01056db <strtol+0x126>
            dig = *s - 'A' + 10;
c01056ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01056ae:	8a 00                	mov    (%eax),%al
c01056b0:	0f be c0             	movsbl %al,%eax
c01056b3:	83 e8 37             	sub    $0x37,%eax
c01056b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c01056b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056bc:	3b 45 10             	cmp    0x10(%ebp),%eax
c01056bf:	7d 19                	jge    c01056da <strtol+0x125>
            break;
        }
        s ++, val = (val * base) + dig;
c01056c1:	ff 45 08             	incl   0x8(%ebp)
c01056c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01056c7:	0f af 45 10          	imul   0x10(%ebp),%eax
c01056cb:	89 c2                	mov    %eax,%edx
c01056cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056d0:	01 d0                	add    %edx,%eax
c01056d2:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c01056d5:	e9 7b ff ff ff       	jmp    c0105655 <strtol+0xa0>
            break;
c01056da:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c01056db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01056df:	74 08                	je     c01056e9 <strtol+0x134>
        *endptr = (char *) s;
c01056e1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056e4:	8b 55 08             	mov    0x8(%ebp),%edx
c01056e7:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c01056e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01056ed:	74 07                	je     c01056f6 <strtol+0x141>
c01056ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01056f2:	f7 d8                	neg    %eax
c01056f4:	eb 03                	jmp    c01056f9 <strtol+0x144>
c01056f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c01056f9:	c9                   	leave  
c01056fa:	c3                   	ret    

c01056fb <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c01056fb:	55                   	push   %ebp
c01056fc:	89 e5                	mov    %esp,%ebp
c01056fe:	57                   	push   %edi
c01056ff:	83 ec 24             	sub    $0x24,%esp
c0105702:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105705:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105708:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c010570c:	8b 55 08             	mov    0x8(%ebp),%edx
c010570f:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105712:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105715:	8b 45 10             	mov    0x10(%ebp),%eax
c0105718:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c010571b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c010571e:	8a 45 f7             	mov    -0x9(%ebp),%al
c0105721:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105724:	89 d7                	mov    %edx,%edi
c0105726:	f3 aa                	rep stos %al,%es:(%edi)
c0105728:	89 fa                	mov    %edi,%edx
c010572a:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010572d:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105730:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105733:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105734:	83 c4 24             	add    $0x24,%esp
c0105737:	5f                   	pop    %edi
c0105738:	5d                   	pop    %ebp
c0105739:	c3                   	ret    

c010573a <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c010573a:	55                   	push   %ebp
c010573b:	89 e5                	mov    %esp,%ebp
c010573d:	57                   	push   %edi
c010573e:	56                   	push   %esi
c010573f:	53                   	push   %ebx
c0105740:	83 ec 30             	sub    $0x30,%esp
c0105743:	8b 45 08             	mov    0x8(%ebp),%eax
c0105746:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105749:	8b 45 0c             	mov    0xc(%ebp),%eax
c010574c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010574f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105752:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105755:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105758:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010575b:	73 42                	jae    c010579f <memmove+0x65>
c010575d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105760:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105763:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105766:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105769:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010576c:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010576f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105772:	c1 e8 02             	shr    $0x2,%eax
c0105775:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105777:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010577a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010577d:	89 d7                	mov    %edx,%edi
c010577f:	89 c6                	mov    %eax,%esi
c0105781:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105783:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105786:	83 e1 03             	and    $0x3,%ecx
c0105789:	74 02                	je     c010578d <memmove+0x53>
c010578b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010578d:	89 f0                	mov    %esi,%eax
c010578f:	89 fa                	mov    %edi,%edx
c0105791:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105794:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105797:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c010579a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
c010579d:	eb 36                	jmp    c01057d5 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c010579f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01057a2:	8d 50 ff             	lea    -0x1(%eax),%edx
c01057a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01057a8:	01 c2                	add    %eax,%edx
c01057aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01057ad:	8d 48 ff             	lea    -0x1(%eax),%ecx
c01057b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057b3:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c01057b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01057b9:	89 c1                	mov    %eax,%ecx
c01057bb:	89 d8                	mov    %ebx,%eax
c01057bd:	89 d6                	mov    %edx,%esi
c01057bf:	89 c7                	mov    %eax,%edi
c01057c1:	fd                   	std    
c01057c2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01057c4:	fc                   	cld    
c01057c5:	89 f8                	mov    %edi,%eax
c01057c7:	89 f2                	mov    %esi,%edx
c01057c9:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c01057cc:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01057cf:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c01057d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c01057d5:	83 c4 30             	add    $0x30,%esp
c01057d8:	5b                   	pop    %ebx
c01057d9:	5e                   	pop    %esi
c01057da:	5f                   	pop    %edi
c01057db:	5d                   	pop    %ebp
c01057dc:	c3                   	ret    

c01057dd <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c01057dd:	55                   	push   %ebp
c01057de:	89 e5                	mov    %esp,%ebp
c01057e0:	57                   	push   %edi
c01057e1:	56                   	push   %esi
c01057e2:	83 ec 20             	sub    $0x20,%esp
c01057e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01057e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01057eb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01057f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01057f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c01057f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01057fa:	c1 e8 02             	shr    $0x2,%eax
c01057fd:	89 c1                	mov    %eax,%ecx
    asm volatile (
c01057ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105802:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105805:	89 d7                	mov    %edx,%edi
c0105807:	89 c6                	mov    %eax,%esi
c0105809:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010580b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c010580e:	83 e1 03             	and    $0x3,%ecx
c0105811:	74 02                	je     c0105815 <memcpy+0x38>
c0105813:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105815:	89 f0                	mov    %esi,%eax
c0105817:	89 fa                	mov    %edi,%edx
c0105819:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c010581c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010581f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c0105822:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
c0105825:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105826:	83 c4 20             	add    $0x20,%esp
c0105829:	5e                   	pop    %esi
c010582a:	5f                   	pop    %edi
c010582b:	5d                   	pop    %ebp
c010582c:	c3                   	ret    

c010582d <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c010582d:	55                   	push   %ebp
c010582e:	89 e5                	mov    %esp,%ebp
c0105830:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105833:	8b 45 08             	mov    0x8(%ebp),%eax
c0105836:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105839:	8b 45 0c             	mov    0xc(%ebp),%eax
c010583c:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c010583f:	eb 2a                	jmp    c010586b <memcmp+0x3e>
        if (*s1 != *s2) {
c0105841:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105844:	8a 10                	mov    (%eax),%dl
c0105846:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105849:	8a 00                	mov    (%eax),%al
c010584b:	38 c2                	cmp    %al,%dl
c010584d:	74 16                	je     c0105865 <memcmp+0x38>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c010584f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105852:	8a 00                	mov    (%eax),%al
c0105854:	0f b6 d0             	movzbl %al,%edx
c0105857:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010585a:	8a 00                	mov    (%eax),%al
c010585c:	0f b6 c0             	movzbl %al,%eax
c010585f:	29 c2                	sub    %eax,%edx
c0105861:	89 d0                	mov    %edx,%eax
c0105863:	eb 18                	jmp    c010587d <memcmp+0x50>
        }
        s1 ++, s2 ++;
c0105865:	ff 45 fc             	incl   -0x4(%ebp)
c0105868:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
c010586b:	8b 45 10             	mov    0x10(%ebp),%eax
c010586e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105871:	89 55 10             	mov    %edx,0x10(%ebp)
c0105874:	85 c0                	test   %eax,%eax
c0105876:	75 c9                	jne    c0105841 <memcmp+0x14>
    }
    return 0;
c0105878:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010587d:	c9                   	leave  
c010587e:	c3                   	ret    
