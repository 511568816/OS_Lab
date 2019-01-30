
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	b8 20 0d 11 00       	mov    $0x110d20,%eax
  10000b:	2d 16 fa 10 00       	sub    $0x10fa16,%eax
  100010:	83 ec 04             	sub    $0x4,%esp
  100013:	50                   	push   %eax
  100014:	6a 00                	push   $0x0
  100016:	68 16 fa 10 00       	push   $0x10fa16
  10001b:	e8 a6 32 00 00       	call   1032c6 <memset>
  100020:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100023:	e8 f8 14 00 00       	call   101520 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100028:	c7 45 f4 60 34 10 00 	movl   $0x103460,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10002f:	83 ec 08             	sub    $0x8,%esp
  100032:	ff 75 f4             	pushl  -0xc(%ebp)
  100035:	68 7c 34 10 00       	push   $0x10347c
  10003a:	e8 f3 02 00 00       	call   100332 <cprintf>
  10003f:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100042:	e8 ee 07 00 00       	call   100835 <print_kerninfo>

    grade_backtrace();
  100047:	e8 79 00 00 00       	call   1000c5 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10004c:	e8 76 29 00 00       	call   1029c7 <pmm_init>

    pic_init();                 // init interrupt controller
  100051:	e8 14 16 00 00       	call   10166a <pic_init>
    idt_init();                 // init interrupt descriptor table
  100056:	e8 78 17 00 00       	call   1017d3 <idt_init>

    clock_init();               // init clock interrupt
  10005b:	e8 fa 0c 00 00       	call   100d5a <clock_init>
    intr_enable();              // enable irq interrupt
  100060:	e8 77 15 00 00       	call   1015dc <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  100065:	e8 4c 01 00 00       	call   1001b6 <lab1_switch_test>

    /* do nothing */
    while (1);
  10006a:	eb fe                	jmp    10006a <kern_init+0x6a>

0010006c <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10006c:	55                   	push   %ebp
  10006d:	89 e5                	mov    %esp,%ebp
  10006f:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
  100072:	83 ec 04             	sub    $0x4,%esp
  100075:	6a 00                	push   $0x0
  100077:	6a 00                	push   $0x0
  100079:	6a 00                	push   $0x0
  10007b:	e8 f4 0b 00 00       	call   100c74 <mon_backtrace>
  100080:	83 c4 10             	add    $0x10,%esp
}
  100083:	90                   	nop
  100084:	c9                   	leave  
  100085:	c3                   	ret    

00100086 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100086:	55                   	push   %ebp
  100087:	89 e5                	mov    %esp,%ebp
  100089:	53                   	push   %ebx
  10008a:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  10008d:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  100090:	8b 55 0c             	mov    0xc(%ebp),%edx
  100093:	8d 5d 08             	lea    0x8(%ebp),%ebx
  100096:	8b 45 08             	mov    0x8(%ebp),%eax
  100099:	51                   	push   %ecx
  10009a:	52                   	push   %edx
  10009b:	53                   	push   %ebx
  10009c:	50                   	push   %eax
  10009d:	e8 ca ff ff ff       	call   10006c <grade_backtrace2>
  1000a2:	83 c4 10             	add    $0x10,%esp
}
  1000a5:	90                   	nop
  1000a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000a9:	c9                   	leave  
  1000aa:	c3                   	ret    

001000ab <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000ab:	55                   	push   %ebp
  1000ac:	89 e5                	mov    %esp,%ebp
  1000ae:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
  1000b1:	83 ec 08             	sub    $0x8,%esp
  1000b4:	ff 75 10             	pushl  0x10(%ebp)
  1000b7:	ff 75 08             	pushl  0x8(%ebp)
  1000ba:	e8 c7 ff ff ff       	call   100086 <grade_backtrace1>
  1000bf:	83 c4 10             	add    $0x10,%esp
}
  1000c2:	90                   	nop
  1000c3:	c9                   	leave  
  1000c4:	c3                   	ret    

001000c5 <grade_backtrace>:

void
grade_backtrace(void) {
  1000c5:	55                   	push   %ebp
  1000c6:	89 e5                	mov    %esp,%ebp
  1000c8:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000cb:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000d0:	83 ec 04             	sub    $0x4,%esp
  1000d3:	68 00 00 ff ff       	push   $0xffff0000
  1000d8:	50                   	push   %eax
  1000d9:	6a 00                	push   $0x0
  1000db:	e8 cb ff ff ff       	call   1000ab <grade_backtrace0>
  1000e0:	83 c4 10             	add    $0x10,%esp
}
  1000e3:	90                   	nop
  1000e4:	c9                   	leave  
  1000e5:	c3                   	ret    

001000e6 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  1000e6:	55                   	push   %ebp
  1000e7:	89 e5                	mov    %esp,%ebp
  1000e9:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  1000ec:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  1000ef:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  1000f2:	8c 45 f2             	mov    %es,-0xe(%ebp)
  1000f5:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  1000f8:	66 8b 45 f6          	mov    -0xa(%ebp),%ax
  1000fc:	0f b7 c0             	movzwl %ax,%eax
  1000ff:	83 e0 03             	and    $0x3,%eax
  100102:	89 c2                	mov    %eax,%edx
  100104:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100109:	83 ec 04             	sub    $0x4,%esp
  10010c:	52                   	push   %edx
  10010d:	50                   	push   %eax
  10010e:	68 81 34 10 00       	push   $0x103481
  100113:	e8 1a 02 00 00       	call   100332 <cprintf>
  100118:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  10011b:	66 8b 45 f6          	mov    -0xa(%ebp),%ax
  10011f:	0f b7 d0             	movzwl %ax,%edx
  100122:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100127:	83 ec 04             	sub    $0x4,%esp
  10012a:	52                   	push   %edx
  10012b:	50                   	push   %eax
  10012c:	68 8f 34 10 00       	push   $0x10348f
  100131:	e8 fc 01 00 00       	call   100332 <cprintf>
  100136:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  100139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10013c:	0f b7 d0             	movzwl %ax,%edx
  10013f:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100144:	83 ec 04             	sub    $0x4,%esp
  100147:	52                   	push   %edx
  100148:	50                   	push   %eax
  100149:	68 9d 34 10 00       	push   $0x10349d
  10014e:	e8 df 01 00 00       	call   100332 <cprintf>
  100153:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  100156:	66 8b 45 f2          	mov    -0xe(%ebp),%ax
  10015a:	0f b7 d0             	movzwl %ax,%edx
  10015d:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100162:	83 ec 04             	sub    $0x4,%esp
  100165:	52                   	push   %edx
  100166:	50                   	push   %eax
  100167:	68 ab 34 10 00       	push   $0x1034ab
  10016c:	e8 c1 01 00 00       	call   100332 <cprintf>
  100171:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  100174:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100177:	0f b7 d0             	movzwl %ax,%edx
  10017a:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  10017f:	83 ec 04             	sub    $0x4,%esp
  100182:	52                   	push   %edx
  100183:	50                   	push   %eax
  100184:	68 b9 34 10 00       	push   $0x1034b9
  100189:	e8 a4 01 00 00       	call   100332 <cprintf>
  10018e:	83 c4 10             	add    $0x10,%esp
    round ++;
  100191:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100196:	40                   	inc    %eax
  100197:	a3 20 fa 10 00       	mov    %eax,0x10fa20
}
  10019c:	90                   	nop
  10019d:	c9                   	leave  
  10019e:	c3                   	ret    

0010019f <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  10019f:	55                   	push   %ebp
  1001a0:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
    asm volatile (
  1001a2:	83 ec 08             	sub    $0x8,%esp
  1001a5:	cd 78                	int    $0x78
  1001a7:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  1001a9:	90                   	nop
  1001aa:	5d                   	pop    %ebp
  1001ab:	c3                   	ret    

001001ac <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001ac:	55                   	push   %ebp
  1001ad:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	asm volatile (
  1001af:	cd 79                	int    $0x79
  1001b1:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
  1001b3:	90                   	nop
  1001b4:	5d                   	pop    %ebp
  1001b5:	c3                   	ret    

001001b6 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001b6:	55                   	push   %ebp
  1001b7:	89 e5                	mov    %esp,%ebp
  1001b9:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
  1001bc:	e8 25 ff ff ff       	call   1000e6 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001c1:	83 ec 0c             	sub    $0xc,%esp
  1001c4:	68 c8 34 10 00       	push   $0x1034c8
  1001c9:	e8 64 01 00 00       	call   100332 <cprintf>
  1001ce:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  1001d1:	e8 c9 ff ff ff       	call   10019f <lab1_switch_to_user>
    cprintf("%d ticks\n", ticks);
  1001d6:	a1 08 09 11 00       	mov    0x110908,%eax
  1001db:	83 ec 08             	sub    $0x8,%esp
  1001de:	50                   	push   %eax
  1001df:	68 e7 34 10 00       	push   $0x1034e7
  1001e4:	e8 49 01 00 00       	call   100332 <cprintf>
  1001e9:	83 c4 10             	add    $0x10,%esp
    lab1_print_cur_status();
  1001ec:	e8 f5 fe ff ff       	call   1000e6 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001f1:	83 ec 0c             	sub    $0xc,%esp
  1001f4:	68 f4 34 10 00       	push   $0x1034f4
  1001f9:	e8 34 01 00 00       	call   100332 <cprintf>
  1001fe:	83 c4 10             	add    $0x10,%esp
    cprintf("%d ticks\n", ticks);
  100201:	a1 08 09 11 00       	mov    0x110908,%eax
  100206:	83 ec 08             	sub    $0x8,%esp
  100209:	50                   	push   %eax
  10020a:	68 e7 34 10 00       	push   $0x1034e7
  10020f:	e8 1e 01 00 00       	call   100332 <cprintf>
  100214:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
  100217:	e8 90 ff ff ff       	call   1001ac <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10021c:	e8 c5 fe ff ff       	call   1000e6 <lab1_print_cur_status>
}
  100221:	90                   	nop
  100222:	c9                   	leave  
  100223:	c3                   	ret    

00100224 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100224:	55                   	push   %ebp
  100225:	89 e5                	mov    %esp,%ebp
  100227:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
  10022a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10022e:	74 13                	je     100243 <readline+0x1f>
        cprintf("%s", prompt);
  100230:	83 ec 08             	sub    $0x8,%esp
  100233:	ff 75 08             	pushl  0x8(%ebp)
  100236:	68 13 35 10 00       	push   $0x103513
  10023b:	e8 f2 00 00 00       	call   100332 <cprintf>
  100240:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
  100243:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  10024a:	e8 6d 01 00 00       	call   1003bc <getchar>
  10024f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100252:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100256:	79 0a                	jns    100262 <readline+0x3e>
            return NULL;
  100258:	b8 00 00 00 00       	mov    $0x0,%eax
  10025d:	e9 81 00 00 00       	jmp    1002e3 <readline+0xbf>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100262:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100266:	7e 2b                	jle    100293 <readline+0x6f>
  100268:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10026f:	7f 22                	jg     100293 <readline+0x6f>
            cputchar(c);
  100271:	83 ec 0c             	sub    $0xc,%esp
  100274:	ff 75 f0             	pushl  -0x10(%ebp)
  100277:	e8 dc 00 00 00       	call   100358 <cputchar>
  10027c:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
  10027f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100282:	8d 50 01             	lea    0x1(%eax),%edx
  100285:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100288:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10028b:	88 90 40 fa 10 00    	mov    %dl,0x10fa40(%eax)
  100291:	eb 4b                	jmp    1002de <readline+0xba>
        }
        else if (c == '\b' && i > 0) {
  100293:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100297:	75 19                	jne    1002b2 <readline+0x8e>
  100299:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10029d:	7e 13                	jle    1002b2 <readline+0x8e>
            cputchar(c);
  10029f:	83 ec 0c             	sub    $0xc,%esp
  1002a2:	ff 75 f0             	pushl  -0x10(%ebp)
  1002a5:	e8 ae 00 00 00       	call   100358 <cputchar>
  1002aa:	83 c4 10             	add    $0x10,%esp
            i --;
  1002ad:	ff 4d f4             	decl   -0xc(%ebp)
  1002b0:	eb 2c                	jmp    1002de <readline+0xba>
        }
        else if (c == '\n' || c == '\r') {
  1002b2:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002b6:	74 06                	je     1002be <readline+0x9a>
  1002b8:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002bc:	75 8c                	jne    10024a <readline+0x26>
            cputchar(c);
  1002be:	83 ec 0c             	sub    $0xc,%esp
  1002c1:	ff 75 f0             	pushl  -0x10(%ebp)
  1002c4:	e8 8f 00 00 00       	call   100358 <cputchar>
  1002c9:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
  1002cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002cf:	05 40 fa 10 00       	add    $0x10fa40,%eax
  1002d4:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002d7:	b8 40 fa 10 00       	mov    $0x10fa40,%eax
  1002dc:	eb 05                	jmp    1002e3 <readline+0xbf>
        c = getchar();
  1002de:	e9 67 ff ff ff       	jmp    10024a <readline+0x26>
        }
    }
}
  1002e3:	c9                   	leave  
  1002e4:	c3                   	ret    

001002e5 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002e5:	55                   	push   %ebp
  1002e6:	89 e5                	mov    %esp,%ebp
  1002e8:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  1002eb:	83 ec 0c             	sub    $0xc,%esp
  1002ee:	ff 75 08             	pushl  0x8(%ebp)
  1002f1:	e8 5b 12 00 00       	call   101551 <cons_putc>
  1002f6:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  1002f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002fc:	8b 00                	mov    (%eax),%eax
  1002fe:	8d 50 01             	lea    0x1(%eax),%edx
  100301:	8b 45 0c             	mov    0xc(%ebp),%eax
  100304:	89 10                	mov    %edx,(%eax)
}
  100306:	90                   	nop
  100307:	c9                   	leave  
  100308:	c3                   	ret    

00100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100309:	55                   	push   %ebp
  10030a:	89 e5                	mov    %esp,%ebp
  10030c:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  10030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100316:	ff 75 0c             	pushl  0xc(%ebp)
  100319:	ff 75 08             	pushl  0x8(%ebp)
  10031c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10031f:	50                   	push   %eax
  100320:	68 e5 02 10 00       	push   $0x1002e5
  100325:	e8 4a 28 00 00       	call   102b74 <vprintfmt>
  10032a:	83 c4 10             	add    $0x10,%esp
    return cnt;
  10032d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100330:	c9                   	leave  
  100331:	c3                   	ret    

00100332 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100332:	55                   	push   %ebp
  100333:	89 e5                	mov    %esp,%ebp
  100335:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100338:	8d 45 0c             	lea    0xc(%ebp),%eax
  10033b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10033e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100341:	83 ec 08             	sub    $0x8,%esp
  100344:	50                   	push   %eax
  100345:	ff 75 08             	pushl  0x8(%ebp)
  100348:	e8 bc ff ff ff       	call   100309 <vcprintf>
  10034d:	83 c4 10             	add    $0x10,%esp
  100350:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100353:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100356:	c9                   	leave  
  100357:	c3                   	ret    

00100358 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100358:	55                   	push   %ebp
  100359:	89 e5                	mov    %esp,%ebp
  10035b:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  10035e:	83 ec 0c             	sub    $0xc,%esp
  100361:	ff 75 08             	pushl  0x8(%ebp)
  100364:	e8 e8 11 00 00       	call   101551 <cons_putc>
  100369:	83 c4 10             	add    $0x10,%esp
}
  10036c:	90                   	nop
  10036d:	c9                   	leave  
  10036e:	c3                   	ret    

0010036f <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10036f:	55                   	push   %ebp
  100370:	89 e5                	mov    %esp,%ebp
  100372:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  100375:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  10037c:	eb 14                	jmp    100392 <cputs+0x23>
        cputch(c, &cnt);
  10037e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100382:	83 ec 08             	sub    $0x8,%esp
  100385:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100388:	52                   	push   %edx
  100389:	50                   	push   %eax
  10038a:	e8 56 ff ff ff       	call   1002e5 <cputch>
  10038f:	83 c4 10             	add    $0x10,%esp
    while ((c = *str ++) != '\0') {
  100392:	8b 45 08             	mov    0x8(%ebp),%eax
  100395:	8d 50 01             	lea    0x1(%eax),%edx
  100398:	89 55 08             	mov    %edx,0x8(%ebp)
  10039b:	8a 00                	mov    (%eax),%al
  10039d:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003a0:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003a4:	75 d8                	jne    10037e <cputs+0xf>
    }
    cputch('\n', &cnt);
  1003a6:	83 ec 08             	sub    $0x8,%esp
  1003a9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003ac:	50                   	push   %eax
  1003ad:	6a 0a                	push   $0xa
  1003af:	e8 31 ff ff ff       	call   1002e5 <cputch>
  1003b4:	83 c4 10             	add    $0x10,%esp
    return cnt;
  1003b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003ba:	c9                   	leave  
  1003bb:	c3                   	ret    

001003bc <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003bc:	55                   	push   %ebp
  1003bd:	89 e5                	mov    %esp,%ebp
  1003bf:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003c2:	90                   	nop
  1003c3:	e8 b9 11 00 00       	call   101581 <cons_getc>
  1003c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003cf:	74 f2                	je     1003c3 <getchar+0x7>
        /* do nothing */;
    return c;
  1003d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003d4:	c9                   	leave  
  1003d5:	c3                   	ret    

001003d6 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003d6:	55                   	push   %ebp
  1003d7:	89 e5                	mov    %esp,%ebp
  1003d9:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003df:	8b 00                	mov    (%eax),%eax
  1003e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003e4:	8b 45 10             	mov    0x10(%ebp),%eax
  1003e7:	8b 00                	mov    (%eax),%eax
  1003e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003f3:	e9 c9 00 00 00       	jmp    1004c1 <stab_binsearch+0xeb>
        int true_m = (l + r) / 2, m = true_m;
  1003f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1003fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1003fe:	01 d0                	add    %edx,%eax
  100400:	89 c2                	mov    %eax,%edx
  100402:	c1 ea 1f             	shr    $0x1f,%edx
  100405:	01 d0                	add    %edx,%eax
  100407:	d1 f8                	sar    %eax
  100409:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10040c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10040f:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100412:	eb 03                	jmp    100417 <stab_binsearch+0x41>
            m --;
  100414:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  100417:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10041a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10041d:	7c 1e                	jl     10043d <stab_binsearch+0x67>
  10041f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100422:	89 d0                	mov    %edx,%eax
  100424:	01 c0                	add    %eax,%eax
  100426:	01 d0                	add    %edx,%eax
  100428:	c1 e0 02             	shl    $0x2,%eax
  10042b:	89 c2                	mov    %eax,%edx
  10042d:	8b 45 08             	mov    0x8(%ebp),%eax
  100430:	01 d0                	add    %edx,%eax
  100432:	8a 40 04             	mov    0x4(%eax),%al
  100435:	0f b6 c0             	movzbl %al,%eax
  100438:	39 45 14             	cmp    %eax,0x14(%ebp)
  10043b:	75 d7                	jne    100414 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  10043d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100440:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100443:	7d 09                	jge    10044e <stab_binsearch+0x78>
            l = true_m + 1;
  100445:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100448:	40                   	inc    %eax
  100449:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10044c:	eb 73                	jmp    1004c1 <stab_binsearch+0xeb>
        }

        // actual binary search
        any_matches = 1;
  10044e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100455:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100458:	89 d0                	mov    %edx,%eax
  10045a:	01 c0                	add    %eax,%eax
  10045c:	01 d0                	add    %edx,%eax
  10045e:	c1 e0 02             	shl    $0x2,%eax
  100461:	89 c2                	mov    %eax,%edx
  100463:	8b 45 08             	mov    0x8(%ebp),%eax
  100466:	01 d0                	add    %edx,%eax
  100468:	8b 40 08             	mov    0x8(%eax),%eax
  10046b:	39 45 18             	cmp    %eax,0x18(%ebp)
  10046e:	76 11                	jbe    100481 <stab_binsearch+0xab>
            *region_left = m;
  100470:	8b 45 0c             	mov    0xc(%ebp),%eax
  100473:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100476:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100478:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10047b:	40                   	inc    %eax
  10047c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10047f:	eb 40                	jmp    1004c1 <stab_binsearch+0xeb>
        } else if (stabs[m].n_value > addr) {
  100481:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100484:	89 d0                	mov    %edx,%eax
  100486:	01 c0                	add    %eax,%eax
  100488:	01 d0                	add    %edx,%eax
  10048a:	c1 e0 02             	shl    $0x2,%eax
  10048d:	89 c2                	mov    %eax,%edx
  10048f:	8b 45 08             	mov    0x8(%ebp),%eax
  100492:	01 d0                	add    %edx,%eax
  100494:	8b 40 08             	mov    0x8(%eax),%eax
  100497:	39 45 18             	cmp    %eax,0x18(%ebp)
  10049a:	73 14                	jae    1004b0 <stab_binsearch+0xda>
            *region_right = m - 1;
  10049c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10049f:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004a2:	8b 45 10             	mov    0x10(%ebp),%eax
  1004a5:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004aa:	48                   	dec    %eax
  1004ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004ae:	eb 11                	jmp    1004c1 <stab_binsearch+0xeb>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004b6:	89 10                	mov    %edx,(%eax)
            l = m;
  1004b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004be:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1004c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004c4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004c7:	0f 8e 2b ff ff ff    	jle    1003f8 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  1004cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004d1:	75 0f                	jne    1004e2 <stab_binsearch+0x10c>
        *region_right = *region_left - 1;
  1004d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004d6:	8b 00                	mov    (%eax),%eax
  1004d8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004db:	8b 45 10             	mov    0x10(%ebp),%eax
  1004de:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1004e0:	eb 3d                	jmp    10051f <stab_binsearch+0x149>
        l = *region_right;
  1004e2:	8b 45 10             	mov    0x10(%ebp),%eax
  1004e5:	8b 00                	mov    (%eax),%eax
  1004e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004ea:	eb 03                	jmp    1004ef <stab_binsearch+0x119>
  1004ec:	ff 4d fc             	decl   -0x4(%ebp)
  1004ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004f2:	8b 00                	mov    (%eax),%eax
  1004f4:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1004f7:	7e 1e                	jle    100517 <stab_binsearch+0x141>
  1004f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004fc:	89 d0                	mov    %edx,%eax
  1004fe:	01 c0                	add    %eax,%eax
  100500:	01 d0                	add    %edx,%eax
  100502:	c1 e0 02             	shl    $0x2,%eax
  100505:	89 c2                	mov    %eax,%edx
  100507:	8b 45 08             	mov    0x8(%ebp),%eax
  10050a:	01 d0                	add    %edx,%eax
  10050c:	8a 40 04             	mov    0x4(%eax),%al
  10050f:	0f b6 c0             	movzbl %al,%eax
  100512:	39 45 14             	cmp    %eax,0x14(%ebp)
  100515:	75 d5                	jne    1004ec <stab_binsearch+0x116>
        *region_left = l;
  100517:	8b 45 0c             	mov    0xc(%ebp),%eax
  10051a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10051d:	89 10                	mov    %edx,(%eax)
}
  10051f:	90                   	nop
  100520:	c9                   	leave  
  100521:	c3                   	ret    

00100522 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100522:	55                   	push   %ebp
  100523:	89 e5                	mov    %esp,%ebp
  100525:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100528:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052b:	c7 00 18 35 10 00    	movl   $0x103518,(%eax)
    info->eip_line = 0;
  100531:	8b 45 0c             	mov    0xc(%ebp),%eax
  100534:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10053b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053e:	c7 40 08 18 35 10 00 	movl   $0x103518,0x8(%eax)
    info->eip_fn_namelen = 9;
  100545:	8b 45 0c             	mov    0xc(%ebp),%eax
  100548:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10054f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100552:	8b 55 08             	mov    0x8(%ebp),%edx
  100555:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100558:	8b 45 0c             	mov    0xc(%ebp),%eax
  10055b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100562:	c7 45 f4 ac 3d 10 00 	movl   $0x103dac,-0xc(%ebp)
    stab_end = __STAB_END__;
  100569:	c7 45 f0 4c c7 10 00 	movl   $0x10c74c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100570:	c7 45 ec 4d c7 10 00 	movl   $0x10c74d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100577:	c7 45 e8 53 e8 10 00 	movl   $0x10e853,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10057e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100581:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100584:	76 0a                	jbe    100590 <debuginfo_eip+0x6e>
  100586:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100589:	48                   	dec    %eax
  10058a:	8a 00                	mov    (%eax),%al
  10058c:	84 c0                	test   %al,%al
  10058e:	74 0a                	je     10059a <debuginfo_eip+0x78>
        return -1;
  100590:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100595:	e9 99 02 00 00       	jmp    100833 <debuginfo_eip+0x311>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  10059a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005a4:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1005a7:	c1 f8 02             	sar    $0x2,%eax
  1005aa:	89 c2                	mov    %eax,%edx
  1005ac:	89 d0                	mov    %edx,%eax
  1005ae:	c1 e0 02             	shl    $0x2,%eax
  1005b1:	01 d0                	add    %edx,%eax
  1005b3:	c1 e0 02             	shl    $0x2,%eax
  1005b6:	01 d0                	add    %edx,%eax
  1005b8:	c1 e0 02             	shl    $0x2,%eax
  1005bb:	01 d0                	add    %edx,%eax
  1005bd:	89 c1                	mov    %eax,%ecx
  1005bf:	c1 e1 08             	shl    $0x8,%ecx
  1005c2:	01 c8                	add    %ecx,%eax
  1005c4:	89 c1                	mov    %eax,%ecx
  1005c6:	c1 e1 10             	shl    $0x10,%ecx
  1005c9:	01 c8                	add    %ecx,%eax
  1005cb:	01 c0                	add    %eax,%eax
  1005cd:	01 d0                	add    %edx,%eax
  1005cf:	48                   	dec    %eax
  1005d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005d3:	ff 75 08             	pushl  0x8(%ebp)
  1005d6:	6a 64                	push   $0x64
  1005d8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005db:	50                   	push   %eax
  1005dc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005df:	50                   	push   %eax
  1005e0:	ff 75 f4             	pushl  -0xc(%ebp)
  1005e3:	e8 ee fd ff ff       	call   1003d6 <stab_binsearch>
  1005e8:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
  1005eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005ee:	85 c0                	test   %eax,%eax
  1005f0:	75 0a                	jne    1005fc <debuginfo_eip+0xda>
        return -1;
  1005f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005f7:	e9 37 02 00 00       	jmp    100833 <debuginfo_eip+0x311>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100602:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100605:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100608:	ff 75 08             	pushl  0x8(%ebp)
  10060b:	6a 24                	push   $0x24
  10060d:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100610:	50                   	push   %eax
  100611:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100614:	50                   	push   %eax
  100615:	ff 75 f4             	pushl  -0xc(%ebp)
  100618:	e8 b9 fd ff ff       	call   1003d6 <stab_binsearch>
  10061d:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
  100620:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100623:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100626:	39 c2                	cmp    %eax,%edx
  100628:	7f 78                	jg     1006a2 <debuginfo_eip+0x180>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10062a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10062d:	89 c2                	mov    %eax,%edx
  10062f:	89 d0                	mov    %edx,%eax
  100631:	01 c0                	add    %eax,%eax
  100633:	01 d0                	add    %edx,%eax
  100635:	c1 e0 02             	shl    $0x2,%eax
  100638:	89 c2                	mov    %eax,%edx
  10063a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10063d:	01 d0                	add    %edx,%eax
  10063f:	8b 10                	mov    (%eax),%edx
  100641:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100644:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100647:	39 c2                	cmp    %eax,%edx
  100649:	73 22                	jae    10066d <debuginfo_eip+0x14b>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10064b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10064e:	89 c2                	mov    %eax,%edx
  100650:	89 d0                	mov    %edx,%eax
  100652:	01 c0                	add    %eax,%eax
  100654:	01 d0                	add    %edx,%eax
  100656:	c1 e0 02             	shl    $0x2,%eax
  100659:	89 c2                	mov    %eax,%edx
  10065b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10065e:	01 d0                	add    %edx,%eax
  100660:	8b 10                	mov    (%eax),%edx
  100662:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100665:	01 c2                	add    %eax,%edx
  100667:	8b 45 0c             	mov    0xc(%ebp),%eax
  10066a:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10066d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100670:	89 c2                	mov    %eax,%edx
  100672:	89 d0                	mov    %edx,%eax
  100674:	01 c0                	add    %eax,%eax
  100676:	01 d0                	add    %edx,%eax
  100678:	c1 e0 02             	shl    $0x2,%eax
  10067b:	89 c2                	mov    %eax,%edx
  10067d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100680:	01 d0                	add    %edx,%eax
  100682:	8b 50 08             	mov    0x8(%eax),%edx
  100685:	8b 45 0c             	mov    0xc(%ebp),%eax
  100688:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  10068b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10068e:	8b 40 10             	mov    0x10(%eax),%eax
  100691:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100694:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100697:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10069a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10069d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006a0:	eb 15                	jmp    1006b7 <debuginfo_eip+0x195>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a5:	8b 55 08             	mov    0x8(%ebp),%edx
  1006a8:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006ae:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006b4:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ba:	8b 40 08             	mov    0x8(%eax),%eax
  1006bd:	83 ec 08             	sub    $0x8,%esp
  1006c0:	6a 3a                	push   $0x3a
  1006c2:	50                   	push   %eax
  1006c3:	e8 8c 2a 00 00       	call   103154 <strfind>
  1006c8:	83 c4 10             	add    $0x10,%esp
  1006cb:	89 c2                	mov    %eax,%edx
  1006cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d0:	8b 40 08             	mov    0x8(%eax),%eax
  1006d3:	29 c2                	sub    %eax,%edx
  1006d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d8:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006db:	83 ec 0c             	sub    $0xc,%esp
  1006de:	ff 75 08             	pushl  0x8(%ebp)
  1006e1:	6a 44                	push   $0x44
  1006e3:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006e6:	50                   	push   %eax
  1006e7:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1006ea:	50                   	push   %eax
  1006eb:	ff 75 f4             	pushl  -0xc(%ebp)
  1006ee:	e8 e3 fc ff ff       	call   1003d6 <stab_binsearch>
  1006f3:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
  1006f6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1006f9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1006fc:	39 c2                	cmp    %eax,%edx
  1006fe:	7f 24                	jg     100724 <debuginfo_eip+0x202>
        info->eip_line = stabs[rline].n_desc;
  100700:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100703:	89 c2                	mov    %eax,%edx
  100705:	89 d0                	mov    %edx,%eax
  100707:	01 c0                	add    %eax,%eax
  100709:	01 d0                	add    %edx,%eax
  10070b:	c1 e0 02             	shl    $0x2,%eax
  10070e:	89 c2                	mov    %eax,%edx
  100710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100713:	01 d0                	add    %edx,%eax
  100715:	66 8b 40 06          	mov    0x6(%eax),%ax
  100719:	0f b7 d0             	movzwl %ax,%edx
  10071c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10071f:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100722:	eb 11                	jmp    100735 <debuginfo_eip+0x213>
        return -1;
  100724:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100729:	e9 05 01 00 00       	jmp    100833 <debuginfo_eip+0x311>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10072e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100731:	48                   	dec    %eax
  100732:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100735:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100738:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10073b:	39 c2                	cmp    %eax,%edx
  10073d:	7c 54                	jl     100793 <debuginfo_eip+0x271>
           && stabs[lline].n_type != N_SOL
  10073f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100742:	89 c2                	mov    %eax,%edx
  100744:	89 d0                	mov    %edx,%eax
  100746:	01 c0                	add    %eax,%eax
  100748:	01 d0                	add    %edx,%eax
  10074a:	c1 e0 02             	shl    $0x2,%eax
  10074d:	89 c2                	mov    %eax,%edx
  10074f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100752:	01 d0                	add    %edx,%eax
  100754:	8a 40 04             	mov    0x4(%eax),%al
  100757:	3c 84                	cmp    $0x84,%al
  100759:	74 38                	je     100793 <debuginfo_eip+0x271>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10075b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10075e:	89 c2                	mov    %eax,%edx
  100760:	89 d0                	mov    %edx,%eax
  100762:	01 c0                	add    %eax,%eax
  100764:	01 d0                	add    %edx,%eax
  100766:	c1 e0 02             	shl    $0x2,%eax
  100769:	89 c2                	mov    %eax,%edx
  10076b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10076e:	01 d0                	add    %edx,%eax
  100770:	8a 40 04             	mov    0x4(%eax),%al
  100773:	3c 64                	cmp    $0x64,%al
  100775:	75 b7                	jne    10072e <debuginfo_eip+0x20c>
  100777:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10077a:	89 c2                	mov    %eax,%edx
  10077c:	89 d0                	mov    %edx,%eax
  10077e:	01 c0                	add    %eax,%eax
  100780:	01 d0                	add    %edx,%eax
  100782:	c1 e0 02             	shl    $0x2,%eax
  100785:	89 c2                	mov    %eax,%edx
  100787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10078a:	01 d0                	add    %edx,%eax
  10078c:	8b 40 08             	mov    0x8(%eax),%eax
  10078f:	85 c0                	test   %eax,%eax
  100791:	74 9b                	je     10072e <debuginfo_eip+0x20c>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  100793:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100796:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100799:	39 c2                	cmp    %eax,%edx
  10079b:	7c 42                	jl     1007df <debuginfo_eip+0x2bd>
  10079d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007a0:	89 c2                	mov    %eax,%edx
  1007a2:	89 d0                	mov    %edx,%eax
  1007a4:	01 c0                	add    %eax,%eax
  1007a6:	01 d0                	add    %edx,%eax
  1007a8:	c1 e0 02             	shl    $0x2,%eax
  1007ab:	89 c2                	mov    %eax,%edx
  1007ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007b0:	01 d0                	add    %edx,%eax
  1007b2:	8b 10                	mov    (%eax),%edx
  1007b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1007b7:	2b 45 ec             	sub    -0x14(%ebp),%eax
  1007ba:	39 c2                	cmp    %eax,%edx
  1007bc:	73 21                	jae    1007df <debuginfo_eip+0x2bd>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007c1:	89 c2                	mov    %eax,%edx
  1007c3:	89 d0                	mov    %edx,%eax
  1007c5:	01 c0                	add    %eax,%eax
  1007c7:	01 d0                	add    %edx,%eax
  1007c9:	c1 e0 02             	shl    $0x2,%eax
  1007cc:	89 c2                	mov    %eax,%edx
  1007ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007d1:	01 d0                	add    %edx,%eax
  1007d3:	8b 10                	mov    (%eax),%edx
  1007d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007d8:	01 c2                	add    %eax,%edx
  1007da:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007dd:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007df:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007e5:	39 c2                	cmp    %eax,%edx
  1007e7:	7d 45                	jge    10082e <debuginfo_eip+0x30c>
        for (lline = lfun + 1;
  1007e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007ec:	40                   	inc    %eax
  1007ed:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1007f0:	eb 16                	jmp    100808 <debuginfo_eip+0x2e6>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1007f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007f5:	8b 40 14             	mov    0x14(%eax),%eax
  1007f8:	8d 50 01             	lea    0x1(%eax),%edx
  1007fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007fe:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  100801:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100804:	40                   	inc    %eax
  100805:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100808:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10080b:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  10080e:	39 c2                	cmp    %eax,%edx
  100810:	7d 1c                	jge    10082e <debuginfo_eip+0x30c>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100812:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100815:	89 c2                	mov    %eax,%edx
  100817:	89 d0                	mov    %edx,%eax
  100819:	01 c0                	add    %eax,%eax
  10081b:	01 d0                	add    %edx,%eax
  10081d:	c1 e0 02             	shl    $0x2,%eax
  100820:	89 c2                	mov    %eax,%edx
  100822:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100825:	01 d0                	add    %edx,%eax
  100827:	8a 40 04             	mov    0x4(%eax),%al
  10082a:	3c a0                	cmp    $0xa0,%al
  10082c:	74 c4                	je     1007f2 <debuginfo_eip+0x2d0>
        }
    }
    return 0;
  10082e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100833:	c9                   	leave  
  100834:	c3                   	ret    

00100835 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100835:	55                   	push   %ebp
  100836:	89 e5                	mov    %esp,%ebp
  100838:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10083b:	83 ec 0c             	sub    $0xc,%esp
  10083e:	68 22 35 10 00       	push   $0x103522
  100843:	e8 ea fa ff ff       	call   100332 <cprintf>
  100848:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10084b:	83 ec 08             	sub    $0x8,%esp
  10084e:	68 00 00 10 00       	push   $0x100000
  100853:	68 3b 35 10 00       	push   $0x10353b
  100858:	e8 d5 fa ff ff       	call   100332 <cprintf>
  10085d:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  100860:	83 ec 08             	sub    $0x8,%esp
  100863:	68 4a 34 10 00       	push   $0x10344a
  100868:	68 53 35 10 00       	push   $0x103553
  10086d:	e8 c0 fa ff ff       	call   100332 <cprintf>
  100872:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100875:	83 ec 08             	sub    $0x8,%esp
  100878:	68 16 fa 10 00       	push   $0x10fa16
  10087d:	68 6b 35 10 00       	push   $0x10356b
  100882:	e8 ab fa ff ff       	call   100332 <cprintf>
  100887:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  10088a:	83 ec 08             	sub    $0x8,%esp
  10088d:	68 20 0d 11 00       	push   $0x110d20
  100892:	68 83 35 10 00       	push   $0x103583
  100897:	e8 96 fa ff ff       	call   100332 <cprintf>
  10089c:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  10089f:	b8 20 0d 11 00       	mov    $0x110d20,%eax
  1008a4:	2d 00 00 10 00       	sub    $0x100000,%eax
  1008a9:	05 ff 03 00 00       	add    $0x3ff,%eax
  1008ae:	85 c0                	test   %eax,%eax
  1008b0:	79 05                	jns    1008b7 <print_kerninfo+0x82>
  1008b2:	05 ff 03 00 00       	add    $0x3ff,%eax
  1008b7:	c1 f8 0a             	sar    $0xa,%eax
  1008ba:	83 ec 08             	sub    $0x8,%esp
  1008bd:	50                   	push   %eax
  1008be:	68 9c 35 10 00       	push   $0x10359c
  1008c3:	e8 6a fa ff ff       	call   100332 <cprintf>
  1008c8:	83 c4 10             	add    $0x10,%esp
}
  1008cb:	90                   	nop
  1008cc:	c9                   	leave  
  1008cd:	c3                   	ret    

001008ce <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008ce:	55                   	push   %ebp
  1008cf:	89 e5                	mov    %esp,%ebp
  1008d1:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008d7:	83 ec 08             	sub    $0x8,%esp
  1008da:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008dd:	50                   	push   %eax
  1008de:	ff 75 08             	pushl  0x8(%ebp)
  1008e1:	e8 3c fc ff ff       	call   100522 <debuginfo_eip>
  1008e6:	83 c4 10             	add    $0x10,%esp
  1008e9:	85 c0                	test   %eax,%eax
  1008eb:	74 15                	je     100902 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1008ed:	83 ec 08             	sub    $0x8,%esp
  1008f0:	ff 75 08             	pushl  0x8(%ebp)
  1008f3:	68 c6 35 10 00       	push   $0x1035c6
  1008f8:	e8 35 fa ff ff       	call   100332 <cprintf>
  1008fd:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100900:	eb 63                	jmp    100965 <print_debuginfo+0x97>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100902:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100909:	eb 1a                	jmp    100925 <print_debuginfo+0x57>
            fnname[j] = info.eip_fn_name[j];
  10090b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10090e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100911:	01 d0                	add    %edx,%eax
  100913:	8a 00                	mov    (%eax),%al
  100915:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10091b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10091e:	01 ca                	add    %ecx,%edx
  100920:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100922:	ff 45 f4             	incl   -0xc(%ebp)
  100925:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100928:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  10092b:	7c de                	jl     10090b <print_debuginfo+0x3d>
        fnname[j] = '\0';
  10092d:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100936:	01 d0                	add    %edx,%eax
  100938:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  10093b:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  10093e:	8b 55 08             	mov    0x8(%ebp),%edx
  100941:	89 d1                	mov    %edx,%ecx
  100943:	29 c1                	sub    %eax,%ecx
  100945:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100948:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10094b:	83 ec 0c             	sub    $0xc,%esp
  10094e:	51                   	push   %ecx
  10094f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100955:	51                   	push   %ecx
  100956:	52                   	push   %edx
  100957:	50                   	push   %eax
  100958:	68 e2 35 10 00       	push   $0x1035e2
  10095d:	e8 d0 f9 ff ff       	call   100332 <cprintf>
  100962:	83 c4 20             	add    $0x20,%esp
}
  100965:	90                   	nop
  100966:	c9                   	leave  
  100967:	c3                   	ret    

00100968 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100968:	55                   	push   %ebp
  100969:	89 e5                	mov    %esp,%ebp
  10096b:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  10096e:	8b 45 04             	mov    0x4(%ebp),%eax
  100971:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100974:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100977:	c9                   	leave  
  100978:	c3                   	ret    

00100979 <print_stackframe>:
 上一层[ebp]   <-------- [esp/当前ebp]
 局部变量      低位地址
 参考资料：https://www.jianshu.com/p/8e3c962af1a6
 */
void
print_stackframe(void) {
  100979:	55                   	push   %ebp
  10097a:	89 e5                	mov    %esp,%ebp
  10097c:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  10097f:	89 e8                	mov    %ebp,%eax
  100981:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  100984:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    /* LAB1 2017011313 : STEP 1 */
    uint32_t curr_ebp, curr_eip;
    // (1) call read_ebp() to get the value of ebp. the type is (uint32_t)
    curr_ebp = read_ebp();
  100987:	89 45 f4             	mov    %eax,-0xc(%ebp)
    // (2) call read_eip() to get the value of eip. the type is (uint32_t);
    curr_eip = read_eip();
  10098a:	e8 d9 ff ff ff       	call   100968 <read_eip>
  10098f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // (3) from 0 .. STACKFRAME_DEPTH
    for (int stack_level = 0; stack_level <= STACKFRAME_DEPTH; ++stack_level) {
  100992:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100999:	e9 91 00 00 00       	jmp    100a2f <print_stackframe+0xb6>
        // (3.1) printf value of ebp, eip
        cprintf("ebp: 0x%08x eip: 0x%08x ", curr_ebp, curr_eip);
  10099e:	83 ec 04             	sub    $0x4,%esp
  1009a1:	ff 75 f0             	pushl  -0x10(%ebp)
  1009a4:	ff 75 f4             	pushl  -0xc(%ebp)
  1009a7:	68 f4 35 10 00       	push   $0x1035f4
  1009ac:	e8 81 f9 ff ff       	call   100332 <cprintf>
  1009b1:	83 c4 10             	add    $0x10,%esp
        // (3.2) (uint32_t)calling arguments [0..4] = the contents in address (uint32_t)ebp +2 [0..4]
        cprintf("args:");
  1009b4:	83 ec 0c             	sub    $0xc,%esp
  1009b7:	68 0d 36 10 00       	push   $0x10360d
  1009bc:	e8 71 f9 ff ff       	call   100332 <cprintf>
  1009c1:	83 c4 10             	add    $0x10,%esp
        // 未定义uint_32与整数的加法，且sizeof(uint_32) == 4，故先转换位指针再做加法。后面同理。
        for (int arg_num = 0; arg_num < 4; ++arg_num)
  1009c4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  1009cb:	eb 28                	jmp    1009f5 <print_stackframe+0x7c>
            cprintf("0x%8x ", *((uint32_t*)curr_ebp + 2 + arg_num));
  1009cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009d0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1009d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009da:	01 d0                	add    %edx,%eax
  1009dc:	83 c0 08             	add    $0x8,%eax
  1009df:	8b 00                	mov    (%eax),%eax
  1009e1:	83 ec 08             	sub    $0x8,%esp
  1009e4:	50                   	push   %eax
  1009e5:	68 13 36 10 00       	push   $0x103613
  1009ea:	e8 43 f9 ff ff       	call   100332 <cprintf>
  1009ef:	83 c4 10             	add    $0x10,%esp
        for (int arg_num = 0; arg_num < 4; ++arg_num)
  1009f2:	ff 45 e8             	incl   -0x18(%ebp)
  1009f5:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  1009f9:	7e d2                	jle    1009cd <print_stackframe+0x54>
        // (3.3) cprintf("\n");
        cprintf("\n");
  1009fb:	83 ec 0c             	sub    $0xc,%esp
  1009fe:	68 1a 36 10 00       	push   $0x10361a
  100a03:	e8 2a f9 ff ff       	call   100332 <cprintf>
  100a08:	83 c4 10             	add    $0x10,%esp
        // (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
        print_debuginfo(curr_eip);
  100a0b:	83 ec 0c             	sub    $0xc,%esp
  100a0e:	ff 75 f0             	pushl  -0x10(%ebp)
  100a11:	e8 b8 fe ff ff       	call   1008ce <print_debuginfo>
  100a16:	83 c4 10             	add    $0x10,%esp
        // (3.5) popup a calling stackframe
        //           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
        //                   the calling funciton's ebp = ss:[ebp]
        curr_eip = *((uint32_t*)curr_ebp + 1);
  100a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a1c:	83 c0 04             	add    $0x4,%eax
  100a1f:	8b 00                	mov    (%eax),%eax
  100a21:	89 45 f0             	mov    %eax,-0x10(%ebp)
        curr_ebp = *((uint32_t*)curr_ebp);
  100a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a27:	8b 00                	mov    (%eax),%eax
  100a29:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (int stack_level = 0; stack_level <= STACKFRAME_DEPTH; ++stack_level) {
  100a2c:	ff 45 ec             	incl   -0x14(%ebp)
  100a2f:	83 7d ec 14          	cmpl   $0x14,-0x14(%ebp)
  100a33:	0f 8e 65 ff ff ff    	jle    10099e <print_stackframe+0x25>
    }
}
  100a39:	90                   	nop
  100a3a:	c9                   	leave  
  100a3b:	c3                   	ret    

00100a3c <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a3c:	55                   	push   %ebp
  100a3d:	89 e5                	mov    %esp,%ebp
  100a3f:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
  100a42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a49:	eb 0c                	jmp    100a57 <parse+0x1b>
            *buf ++ = '\0';
  100a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  100a4e:	8d 50 01             	lea    0x1(%eax),%edx
  100a51:	89 55 08             	mov    %edx,0x8(%ebp)
  100a54:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a57:	8b 45 08             	mov    0x8(%ebp),%eax
  100a5a:	8a 00                	mov    (%eax),%al
  100a5c:	84 c0                	test   %al,%al
  100a5e:	74 1d                	je     100a7d <parse+0x41>
  100a60:	8b 45 08             	mov    0x8(%ebp),%eax
  100a63:	8a 00                	mov    (%eax),%al
  100a65:	0f be c0             	movsbl %al,%eax
  100a68:	83 ec 08             	sub    $0x8,%esp
  100a6b:	50                   	push   %eax
  100a6c:	68 9c 36 10 00       	push   $0x10369c
  100a71:	e8 ae 26 00 00       	call   103124 <strchr>
  100a76:	83 c4 10             	add    $0x10,%esp
  100a79:	85 c0                	test   %eax,%eax
  100a7b:	75 ce                	jne    100a4b <parse+0xf>
        }
        if (*buf == '\0') {
  100a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  100a80:	8a 00                	mov    (%eax),%al
  100a82:	84 c0                	test   %al,%al
  100a84:	74 62                	je     100ae8 <parse+0xac>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100a86:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100a8a:	75 12                	jne    100a9e <parse+0x62>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100a8c:	83 ec 08             	sub    $0x8,%esp
  100a8f:	6a 10                	push   $0x10
  100a91:	68 a1 36 10 00       	push   $0x1036a1
  100a96:	e8 97 f8 ff ff       	call   100332 <cprintf>
  100a9b:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aa1:	8d 50 01             	lea    0x1(%eax),%edx
  100aa4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100aa7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100aae:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ab1:	01 c2                	add    %eax,%edx
  100ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  100ab6:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ab8:	eb 03                	jmp    100abd <parse+0x81>
            buf ++;
  100aba:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100abd:	8b 45 08             	mov    0x8(%ebp),%eax
  100ac0:	8a 00                	mov    (%eax),%al
  100ac2:	84 c0                	test   %al,%al
  100ac4:	74 91                	je     100a57 <parse+0x1b>
  100ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  100ac9:	8a 00                	mov    (%eax),%al
  100acb:	0f be c0             	movsbl %al,%eax
  100ace:	83 ec 08             	sub    $0x8,%esp
  100ad1:	50                   	push   %eax
  100ad2:	68 9c 36 10 00       	push   $0x10369c
  100ad7:	e8 48 26 00 00       	call   103124 <strchr>
  100adc:	83 c4 10             	add    $0x10,%esp
  100adf:	85 c0                	test   %eax,%eax
  100ae1:	74 d7                	je     100aba <parse+0x7e>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100ae3:	e9 6f ff ff ff       	jmp    100a57 <parse+0x1b>
            break;
  100ae8:	90                   	nop
        }
    }
    return argc;
  100ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100aec:	c9                   	leave  
  100aed:	c3                   	ret    

00100aee <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100aee:	55                   	push   %ebp
  100aef:	89 e5                	mov    %esp,%ebp
  100af1:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100af4:	83 ec 08             	sub    $0x8,%esp
  100af7:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100afa:	50                   	push   %eax
  100afb:	ff 75 08             	pushl  0x8(%ebp)
  100afe:	e8 39 ff ff ff       	call   100a3c <parse>
  100b03:	83 c4 10             	add    $0x10,%esp
  100b06:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b09:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b0d:	75 0a                	jne    100b19 <runcmd+0x2b>
        return 0;
  100b0f:	b8 00 00 00 00       	mov    $0x0,%eax
  100b14:	e9 80 00 00 00       	jmp    100b99 <runcmd+0xab>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b20:	eb 56                	jmp    100b78 <runcmd+0x8a>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b22:	8b 55 b0             	mov    -0x50(%ebp),%edx
  100b25:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100b28:	89 c8                	mov    %ecx,%eax
  100b2a:	01 c0                	add    %eax,%eax
  100b2c:	01 c8                	add    %ecx,%eax
  100b2e:	c1 e0 02             	shl    $0x2,%eax
  100b31:	05 00 f0 10 00       	add    $0x10f000,%eax
  100b36:	8b 00                	mov    (%eax),%eax
  100b38:	83 ec 08             	sub    $0x8,%esp
  100b3b:	52                   	push   %edx
  100b3c:	50                   	push   %eax
  100b3d:	e8 4a 25 00 00       	call   10308c <strcmp>
  100b42:	83 c4 10             	add    $0x10,%esp
  100b45:	85 c0                	test   %eax,%eax
  100b47:	75 2c                	jne    100b75 <runcmd+0x87>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b4c:	89 d0                	mov    %edx,%eax
  100b4e:	01 c0                	add    %eax,%eax
  100b50:	01 d0                	add    %edx,%eax
  100b52:	c1 e0 02             	shl    $0x2,%eax
  100b55:	05 08 f0 10 00       	add    $0x10f008,%eax
  100b5a:	8b 10                	mov    (%eax),%edx
  100b5c:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b5f:	83 c0 04             	add    $0x4,%eax
  100b62:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100b65:	49                   	dec    %ecx
  100b66:	83 ec 04             	sub    $0x4,%esp
  100b69:	ff 75 0c             	pushl  0xc(%ebp)
  100b6c:	50                   	push   %eax
  100b6d:	51                   	push   %ecx
  100b6e:	ff d2                	call   *%edx
  100b70:	83 c4 10             	add    $0x10,%esp
  100b73:	eb 24                	jmp    100b99 <runcmd+0xab>
    for (i = 0; i < NCOMMANDS; i ++) {
  100b75:	ff 45 f4             	incl   -0xc(%ebp)
  100b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b7b:	83 f8 02             	cmp    $0x2,%eax
  100b7e:	76 a2                	jbe    100b22 <runcmd+0x34>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100b80:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100b83:	83 ec 08             	sub    $0x8,%esp
  100b86:	50                   	push   %eax
  100b87:	68 bf 36 10 00       	push   $0x1036bf
  100b8c:	e8 a1 f7 ff ff       	call   100332 <cprintf>
  100b91:	83 c4 10             	add    $0x10,%esp
    return 0;
  100b94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100b99:	c9                   	leave  
  100b9a:	c3                   	ret    

00100b9b <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100b9b:	55                   	push   %ebp
  100b9c:	89 e5                	mov    %esp,%ebp
  100b9e:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100ba1:	83 ec 0c             	sub    $0xc,%esp
  100ba4:	68 d8 36 10 00       	push   $0x1036d8
  100ba9:	e8 84 f7 ff ff       	call   100332 <cprintf>
  100bae:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100bb1:	83 ec 0c             	sub    $0xc,%esp
  100bb4:	68 00 37 10 00       	push   $0x103700
  100bb9:	e8 74 f7 ff ff       	call   100332 <cprintf>
  100bbe:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100bc1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100bc5:	74 0e                	je     100bd5 <kmonitor+0x3a>
        print_trapframe(tf);
  100bc7:	83 ec 0c             	sub    $0xc,%esp
  100bca:	ff 75 08             	pushl  0x8(%ebp)
  100bcd:	e8 a2 0d 00 00       	call   101974 <print_trapframe>
  100bd2:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100bd5:	83 ec 0c             	sub    $0xc,%esp
  100bd8:	68 25 37 10 00       	push   $0x103725
  100bdd:	e8 42 f6 ff ff       	call   100224 <readline>
  100be2:	83 c4 10             	add    $0x10,%esp
  100be5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100be8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100bec:	74 e7                	je     100bd5 <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
  100bee:	83 ec 08             	sub    $0x8,%esp
  100bf1:	ff 75 08             	pushl  0x8(%ebp)
  100bf4:	ff 75 f4             	pushl  -0xc(%ebp)
  100bf7:	e8 f2 fe ff ff       	call   100aee <runcmd>
  100bfc:	83 c4 10             	add    $0x10,%esp
  100bff:	85 c0                	test   %eax,%eax
  100c01:	78 02                	js     100c05 <kmonitor+0x6a>
        if ((buf = readline("K> ")) != NULL) {
  100c03:	eb d0                	jmp    100bd5 <kmonitor+0x3a>
                break;
  100c05:	90                   	nop
            }
        }
    }
}
  100c06:	90                   	nop
  100c07:	c9                   	leave  
  100c08:	c3                   	ret    

00100c09 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c09:	55                   	push   %ebp
  100c0a:	89 e5                	mov    %esp,%ebp
  100c0c:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c0f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c16:	eb 3b                	jmp    100c53 <mon_help+0x4a>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c1b:	89 d0                	mov    %edx,%eax
  100c1d:	01 c0                	add    %eax,%eax
  100c1f:	01 d0                	add    %edx,%eax
  100c21:	c1 e0 02             	shl    $0x2,%eax
  100c24:	05 04 f0 10 00       	add    $0x10f004,%eax
  100c29:	8b 10                	mov    (%eax),%edx
  100c2b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100c2e:	89 c8                	mov    %ecx,%eax
  100c30:	01 c0                	add    %eax,%eax
  100c32:	01 c8                	add    %ecx,%eax
  100c34:	c1 e0 02             	shl    $0x2,%eax
  100c37:	05 00 f0 10 00       	add    $0x10f000,%eax
  100c3c:	8b 00                	mov    (%eax),%eax
  100c3e:	83 ec 04             	sub    $0x4,%esp
  100c41:	52                   	push   %edx
  100c42:	50                   	push   %eax
  100c43:	68 29 37 10 00       	push   $0x103729
  100c48:	e8 e5 f6 ff ff       	call   100332 <cprintf>
  100c4d:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NCOMMANDS; i ++) {
  100c50:	ff 45 f4             	incl   -0xc(%ebp)
  100c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c56:	83 f8 02             	cmp    $0x2,%eax
  100c59:	76 bd                	jbe    100c18 <mon_help+0xf>
    }
    return 0;
  100c5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c60:	c9                   	leave  
  100c61:	c3                   	ret    

00100c62 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c62:	55                   	push   %ebp
  100c63:	89 e5                	mov    %esp,%ebp
  100c65:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c68:	e8 c8 fb ff ff       	call   100835 <print_kerninfo>
    return 0;
  100c6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c72:	c9                   	leave  
  100c73:	c3                   	ret    

00100c74 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100c74:	55                   	push   %ebp
  100c75:	89 e5                	mov    %esp,%ebp
  100c77:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100c7a:	e8 fa fc ff ff       	call   100979 <print_stackframe>
    return 0;
  100c7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c84:	c9                   	leave  
  100c85:	c3                   	ret    

00100c86 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100c86:	55                   	push   %ebp
  100c87:	89 e5                	mov    %esp,%ebp
  100c89:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
  100c8c:	a1 40 fe 10 00       	mov    0x10fe40,%eax
  100c91:	85 c0                	test   %eax,%eax
  100c93:	75 5f                	jne    100cf4 <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
  100c95:	c7 05 40 fe 10 00 01 	movl   $0x1,0x10fe40
  100c9c:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100c9f:	8d 45 14             	lea    0x14(%ebp),%eax
  100ca2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100ca5:	83 ec 04             	sub    $0x4,%esp
  100ca8:	ff 75 0c             	pushl  0xc(%ebp)
  100cab:	ff 75 08             	pushl  0x8(%ebp)
  100cae:	68 32 37 10 00       	push   $0x103732
  100cb3:	e8 7a f6 ff ff       	call   100332 <cprintf>
  100cb8:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cbe:	83 ec 08             	sub    $0x8,%esp
  100cc1:	50                   	push   %eax
  100cc2:	ff 75 10             	pushl  0x10(%ebp)
  100cc5:	e8 3f f6 ff ff       	call   100309 <vcprintf>
  100cca:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100ccd:	83 ec 0c             	sub    $0xc,%esp
  100cd0:	68 4e 37 10 00       	push   $0x10374e
  100cd5:	e8 58 f6 ff ff       	call   100332 <cprintf>
  100cda:	83 c4 10             	add    $0x10,%esp
    
    cprintf("stack trackback:\n");
  100cdd:	83 ec 0c             	sub    $0xc,%esp
  100ce0:	68 50 37 10 00       	push   $0x103750
  100ce5:	e8 48 f6 ff ff       	call   100332 <cprintf>
  100cea:	83 c4 10             	add    $0x10,%esp
    print_stackframe();
  100ced:	e8 87 fc ff ff       	call   100979 <print_stackframe>
  100cf2:	eb 01                	jmp    100cf5 <__panic+0x6f>
        goto panic_dead;
  100cf4:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  100cf5:	e8 e9 08 00 00       	call   1015e3 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100cfa:	83 ec 0c             	sub    $0xc,%esp
  100cfd:	6a 00                	push   $0x0
  100cff:	e8 97 fe ff ff       	call   100b9b <kmonitor>
  100d04:	83 c4 10             	add    $0x10,%esp
  100d07:	eb f1                	jmp    100cfa <__panic+0x74>

00100d09 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d09:	55                   	push   %ebp
  100d0a:	89 e5                	mov    %esp,%ebp
  100d0c:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
  100d0f:	8d 45 14             	lea    0x14(%ebp),%eax
  100d12:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d15:	83 ec 04             	sub    $0x4,%esp
  100d18:	ff 75 0c             	pushl  0xc(%ebp)
  100d1b:	ff 75 08             	pushl  0x8(%ebp)
  100d1e:	68 62 37 10 00       	push   $0x103762
  100d23:	e8 0a f6 ff ff       	call   100332 <cprintf>
  100d28:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d2e:	83 ec 08             	sub    $0x8,%esp
  100d31:	50                   	push   %eax
  100d32:	ff 75 10             	pushl  0x10(%ebp)
  100d35:	e8 cf f5 ff ff       	call   100309 <vcprintf>
  100d3a:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100d3d:	83 ec 0c             	sub    $0xc,%esp
  100d40:	68 4e 37 10 00       	push   $0x10374e
  100d45:	e8 e8 f5 ff ff       	call   100332 <cprintf>
  100d4a:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  100d4d:	90                   	nop
  100d4e:	c9                   	leave  
  100d4f:	c3                   	ret    

00100d50 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d50:	55                   	push   %ebp
  100d51:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d53:	a1 40 fe 10 00       	mov    0x10fe40,%eax
}
  100d58:	5d                   	pop    %ebp
  100d59:	c3                   	ret    

00100d5a <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d5a:	55                   	push   %ebp
  100d5b:	89 e5                	mov    %esp,%ebp
  100d5d:	83 ec 18             	sub    $0x18,%esp
  100d60:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100d66:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d6a:	8a 45 ed             	mov    -0x13(%ebp),%al
  100d6d:	66 8b 55 ee          	mov    -0x12(%ebp),%dx
  100d71:	ee                   	out    %al,(%dx)
  100d72:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d78:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d7c:	8a 45 f1             	mov    -0xf(%ebp),%al
  100d7f:	66 8b 55 f2          	mov    -0xe(%ebp),%dx
  100d83:	ee                   	out    %al,(%dx)
  100d84:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100d8a:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
  100d8e:	8a 45 f5             	mov    -0xb(%ebp),%al
  100d91:	66 8b 55 f6          	mov    -0xa(%ebp),%dx
  100d95:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d96:	c7 05 08 09 11 00 00 	movl   $0x0,0x110908
  100d9d:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100da0:	83 ec 0c             	sub    $0xc,%esp
  100da3:	68 80 37 10 00       	push   $0x103780
  100da8:	e8 85 f5 ff ff       	call   100332 <cprintf>
  100dad:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100db0:	83 ec 0c             	sub    $0xc,%esp
  100db3:	6a 00                	push   $0x0
  100db5:	e8 84 08 00 00       	call   10163e <pic_enable>
  100dba:	83 c4 10             	add    $0x10,%esp
}
  100dbd:	90                   	nop
  100dbe:	c9                   	leave  
  100dbf:	c3                   	ret    

00100dc0 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100dc0:	55                   	push   %ebp
  100dc1:	89 e5                	mov    %esp,%ebp
  100dc3:	83 ec 10             	sub    $0x10,%esp
  100dc6:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100dcc:	66 8b 45 f2          	mov    -0xe(%ebp),%ax
  100dd0:	89 c2                	mov    %eax,%edx
  100dd2:	ec                   	in     (%dx),%al
  100dd3:	88 45 f1             	mov    %al,-0xf(%ebp)
  100dd6:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100ddc:	66 8b 45 f6          	mov    -0xa(%ebp),%ax
  100de0:	89 c2                	mov    %eax,%edx
  100de2:	ec                   	in     (%dx),%al
  100de3:	88 45 f5             	mov    %al,-0xb(%ebp)
  100de6:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100dec:	66 8b 45 fa          	mov    -0x6(%ebp),%ax
  100df0:	89 c2                	mov    %eax,%edx
  100df2:	ec                   	in     (%dx),%al
  100df3:	88 45 f9             	mov    %al,-0x7(%ebp)
  100df6:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100dfc:	66 8b 45 fe          	mov    -0x2(%ebp),%ax
  100e00:	89 c2                	mov    %eax,%edx
  100e02:	ec                   	in     (%dx),%al
  100e03:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e06:	90                   	nop
  100e07:	c9                   	leave  
  100e08:	c3                   	ret    

00100e09 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e09:	55                   	push   %ebp
  100e0a:	89 e5                	mov    %esp,%ebp
  100e0c:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e0f:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e16:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e19:	66 8b 00             	mov    (%eax),%ax
  100e1c:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e23:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e28:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e2b:	66 8b 00             	mov    (%eax),%ax
  100e2e:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e32:	74 12                	je     100e46 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e34:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e3b:	66 c7 05 66 fe 10 00 	movw   $0x3b4,0x10fe66
  100e42:	b4 03 
  100e44:	eb 13                	jmp    100e59 <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e46:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100e49:	66 8b 45 fa          	mov    -0x6(%ebp),%ax
  100e4d:	66 89 02             	mov    %ax,(%edx)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e50:	66 c7 05 66 fe 10 00 	movw   $0x3d4,0x10fe66
  100e57:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e59:	66 a1 66 fe 10 00    	mov    0x10fe66,%ax
  100e5f:	0f b7 c0             	movzwl %ax,%eax
  100e62:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100e66:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e6a:	8a 45 e5             	mov    -0x1b(%ebp),%al
  100e6d:	66 8b 55 e6          	mov    -0x1a(%ebp),%dx
  100e71:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e72:	66 a1 66 fe 10 00    	mov    0x10fe66,%ax
  100e78:	40                   	inc    %eax
  100e79:	0f b7 c0             	movzwl %ax,%eax
  100e7c:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e80:	66 8b 45 ea          	mov    -0x16(%ebp),%ax
  100e84:	89 c2                	mov    %eax,%edx
  100e86:	ec                   	in     (%dx),%al
  100e87:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100e8a:	8a 45 e9             	mov    -0x17(%ebp),%al
  100e8d:	0f b6 c0             	movzbl %al,%eax
  100e90:	c1 e0 08             	shl    $0x8,%eax
  100e93:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e96:	66 a1 66 fe 10 00    	mov    0x10fe66,%ax
  100e9c:	0f b7 c0             	movzwl %ax,%eax
  100e9f:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100ea3:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ea7:	8a 45 ed             	mov    -0x13(%ebp),%al
  100eaa:	66 8b 55 ee          	mov    -0x12(%ebp),%dx
  100eae:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100eaf:	66 a1 66 fe 10 00    	mov    0x10fe66,%ax
  100eb5:	40                   	inc    %eax
  100eb6:	0f b7 c0             	movzwl %ax,%eax
  100eb9:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ebd:	66 8b 45 f2          	mov    -0xe(%ebp),%ax
  100ec1:	89 c2                	mov    %eax,%edx
  100ec3:	ec                   	in     (%dx),%al
  100ec4:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100ec7:	8a 45 f1             	mov    -0xf(%ebp),%al
  100eca:	0f b6 c0             	movzbl %al,%eax
  100ecd:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100ed0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ed3:	a3 60 fe 10 00       	mov    %eax,0x10fe60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100edb:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
}
  100ee1:	90                   	nop
  100ee2:	c9                   	leave  
  100ee3:	c3                   	ret    

00100ee4 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100ee4:	55                   	push   %ebp
  100ee5:	89 e5                	mov    %esp,%ebp
  100ee7:	83 ec 38             	sub    $0x38,%esp
  100eea:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100ef0:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ef4:	8a 45 d1             	mov    -0x2f(%ebp),%al
  100ef7:	66 8b 55 d2          	mov    -0x2e(%ebp),%dx
  100efb:	ee                   	out    %al,(%dx)
  100efc:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100f02:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
  100f06:	8a 45 d5             	mov    -0x2b(%ebp),%al
  100f09:	66 8b 55 d6          	mov    -0x2a(%ebp),%dx
  100f0d:	ee                   	out    %al,(%dx)
  100f0e:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100f14:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
  100f18:	8a 45 d9             	mov    -0x27(%ebp),%al
  100f1b:	66 8b 55 da          	mov    -0x26(%ebp),%dx
  100f1f:	ee                   	out    %al,(%dx)
  100f20:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f26:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100f2a:	8a 45 dd             	mov    -0x23(%ebp),%al
  100f2d:	66 8b 55 de          	mov    -0x22(%ebp),%dx
  100f31:	ee                   	out    %al,(%dx)
  100f32:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100f38:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
  100f3c:	8a 45 e1             	mov    -0x1f(%ebp),%al
  100f3f:	66 8b 55 e2          	mov    -0x1e(%ebp),%dx
  100f43:	ee                   	out    %al,(%dx)
  100f44:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100f4a:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  100f4e:	8a 45 e5             	mov    -0x1b(%ebp),%al
  100f51:	66 8b 55 e6          	mov    -0x1a(%ebp),%dx
  100f55:	ee                   	out    %al,(%dx)
  100f56:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f5c:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
  100f60:	8a 45 e9             	mov    -0x17(%ebp),%al
  100f63:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
  100f67:	ee                   	out    %al,(%dx)
  100f68:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f6e:	66 8b 45 ee          	mov    -0x12(%ebp),%ax
  100f72:	89 c2                	mov    %eax,%edx
  100f74:	ec                   	in     (%dx),%al
  100f75:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100f78:	8a 45 ed             	mov    -0x13(%ebp),%al
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f7b:	3c ff                	cmp    $0xff,%al
  100f7d:	0f 95 c0             	setne  %al
  100f80:	0f b6 c0             	movzbl %al,%eax
  100f83:	a3 68 fe 10 00       	mov    %eax,0x10fe68
  100f88:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f8e:	66 8b 45 f2          	mov    -0xe(%ebp),%ax
  100f92:	89 c2                	mov    %eax,%edx
  100f94:	ec                   	in     (%dx),%al
  100f95:	88 45 f1             	mov    %al,-0xf(%ebp)
  100f98:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  100f9e:	66 8b 45 f6          	mov    -0xa(%ebp),%ax
  100fa2:	89 c2                	mov    %eax,%edx
  100fa4:	ec                   	in     (%dx),%al
  100fa5:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fa8:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  100fad:	85 c0                	test   %eax,%eax
  100faf:	74 0d                	je     100fbe <serial_init+0xda>
        pic_enable(IRQ_COM1);
  100fb1:	83 ec 0c             	sub    $0xc,%esp
  100fb4:	6a 04                	push   $0x4
  100fb6:	e8 83 06 00 00       	call   10163e <pic_enable>
  100fbb:	83 c4 10             	add    $0x10,%esp
    }
}
  100fbe:	90                   	nop
  100fbf:	c9                   	leave  
  100fc0:	c3                   	ret    

00100fc1 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fc1:	55                   	push   %ebp
  100fc2:	89 e5                	mov    %esp,%ebp
  100fc4:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fc7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fce:	eb 08                	jmp    100fd8 <lpt_putc_sub+0x17>
        delay();
  100fd0:	e8 eb fd ff ff       	call   100dc0 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fd5:	ff 45 fc             	incl   -0x4(%ebp)
  100fd8:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100fde:	66 8b 45 fa          	mov    -0x6(%ebp),%ax
  100fe2:	89 c2                	mov    %eax,%edx
  100fe4:	ec                   	in     (%dx),%al
  100fe5:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100fe8:	8a 45 f9             	mov    -0x7(%ebp),%al
  100feb:	84 c0                	test   %al,%al
  100fed:	78 09                	js     100ff8 <lpt_putc_sub+0x37>
  100fef:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100ff6:	7e d8                	jle    100fd0 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  100ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  100ffb:	0f b6 c0             	movzbl %al,%eax
  100ffe:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  101004:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101007:	8a 45 ed             	mov    -0x13(%ebp),%al
  10100a:	66 8b 55 ee          	mov    -0x12(%ebp),%dx
  10100e:	ee                   	out    %al,(%dx)
  10100f:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101015:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101019:	8a 45 f1             	mov    -0xf(%ebp),%al
  10101c:	66 8b 55 f2          	mov    -0xe(%ebp),%dx
  101020:	ee                   	out    %al,(%dx)
  101021:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101027:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
  10102b:	8a 45 f5             	mov    -0xb(%ebp),%al
  10102e:	66 8b 55 f6          	mov    -0xa(%ebp),%dx
  101032:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101033:	90                   	nop
  101034:	c9                   	leave  
  101035:	c3                   	ret    

00101036 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101036:	55                   	push   %ebp
  101037:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  101039:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10103d:	74 0d                	je     10104c <lpt_putc+0x16>
        lpt_putc_sub(c);
  10103f:	ff 75 08             	pushl  0x8(%ebp)
  101042:	e8 7a ff ff ff       	call   100fc1 <lpt_putc_sub>
  101047:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  10104a:	eb 1e                	jmp    10106a <lpt_putc+0x34>
        lpt_putc_sub('\b');
  10104c:	6a 08                	push   $0x8
  10104e:	e8 6e ff ff ff       	call   100fc1 <lpt_putc_sub>
  101053:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  101056:	6a 20                	push   $0x20
  101058:	e8 64 ff ff ff       	call   100fc1 <lpt_putc_sub>
  10105d:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  101060:	6a 08                	push   $0x8
  101062:	e8 5a ff ff ff       	call   100fc1 <lpt_putc_sub>
  101067:	83 c4 04             	add    $0x4,%esp
}
  10106a:	90                   	nop
  10106b:	c9                   	leave  
  10106c:	c3                   	ret    

0010106d <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  10106d:	55                   	push   %ebp
  10106e:	89 e5                	mov    %esp,%ebp
  101070:	53                   	push   %ebx
  101071:	83 ec 24             	sub    $0x24,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101074:	8b 45 08             	mov    0x8(%ebp),%eax
  101077:	b0 00                	mov    $0x0,%al
  101079:	85 c0                	test   %eax,%eax
  10107b:	75 07                	jne    101084 <cga_putc+0x17>
        c |= 0x0700;
  10107d:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101084:	8b 45 08             	mov    0x8(%ebp),%eax
  101087:	0f b6 c0             	movzbl %al,%eax
  10108a:	83 f8 0a             	cmp    $0xa,%eax
  10108d:	74 4a                	je     1010d9 <cga_putc+0x6c>
  10108f:	83 f8 0d             	cmp    $0xd,%eax
  101092:	74 54                	je     1010e8 <cga_putc+0x7b>
  101094:	83 f8 08             	cmp    $0x8,%eax
  101097:	75 77                	jne    101110 <cga_putc+0xa3>
    case '\b':
        if (crt_pos > 0) {
  101099:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  10109f:	66 85 c0             	test   %ax,%ax
  1010a2:	0f 84 8e 00 00 00    	je     101136 <cga_putc+0xc9>
            crt_pos --;
  1010a8:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  1010ae:	48                   	dec    %eax
  1010af:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1010b8:	b0 00                	mov    $0x0,%al
  1010ba:	83 c8 20             	or     $0x20,%eax
  1010bd:	89 c2                	mov    %eax,%edx
  1010bf:	8b 0d 60 fe 10 00    	mov    0x10fe60,%ecx
  1010c5:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  1010cb:	0f b7 c0             	movzwl %ax,%eax
  1010ce:	01 c0                	add    %eax,%eax
  1010d0:	01 c1                	add    %eax,%ecx
  1010d2:	89 d0                	mov    %edx,%eax
  1010d4:	66 89 01             	mov    %ax,(%ecx)
        }
        break;
  1010d7:	eb 5d                	jmp    101136 <cga_putc+0xc9>
    case '\n':
        crt_pos += CRT_COLS;
  1010d9:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  1010df:	83 c0 50             	add    $0x50,%eax
  1010e2:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1010e8:	66 8b 0d 64 fe 10 00 	mov    0x10fe64,%cx
  1010ef:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  1010f5:	bb 50 00 00 00       	mov    $0x50,%ebx
  1010fa:	ba 00 00 00 00       	mov    $0x0,%edx
  1010ff:	66 f7 f3             	div    %bx
  101102:	89 d0                	mov    %edx,%eax
  101104:	29 c1                	sub    %eax,%ecx
  101106:	89 c8                	mov    %ecx,%eax
  101108:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
        break;
  10110e:	eb 27                	jmp    101137 <cga_putc+0xca>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101110:	8b 0d 60 fe 10 00    	mov    0x10fe60,%ecx
  101116:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  10111c:	8d 50 01             	lea    0x1(%eax),%edx
  10111f:	66 89 15 64 fe 10 00 	mov    %dx,0x10fe64
  101126:	0f b7 c0             	movzwl %ax,%eax
  101129:	01 c0                	add    %eax,%eax
  10112b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  10112e:	8b 45 08             	mov    0x8(%ebp),%eax
  101131:	66 89 02             	mov    %ax,(%edx)
        break;
  101134:	eb 01                	jmp    101137 <cga_putc+0xca>
        break;
  101136:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101137:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  10113d:	66 3d cf 07          	cmp    $0x7cf,%ax
  101141:	76 58                	jbe    10119b <cga_putc+0x12e>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101143:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  101148:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10114e:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  101153:	83 ec 04             	sub    $0x4,%esp
  101156:	68 00 0f 00 00       	push   $0xf00
  10115b:	52                   	push   %edx
  10115c:	50                   	push   %eax
  10115d:	e8 a3 21 00 00       	call   103305 <memmove>
  101162:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101165:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10116c:	eb 15                	jmp    101183 <cga_putc+0x116>
            crt_buf[i] = 0x0700 | ' ';
  10116e:	8b 15 60 fe 10 00    	mov    0x10fe60,%edx
  101174:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101177:	01 c0                	add    %eax,%eax
  101179:	01 d0                	add    %edx,%eax
  10117b:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101180:	ff 45 f4             	incl   -0xc(%ebp)
  101183:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10118a:	7e e2                	jle    10116e <cga_putc+0x101>
        }
        crt_pos -= CRT_COLS;
  10118c:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  101192:	83 e8 50             	sub    $0x50,%eax
  101195:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  10119b:	66 a1 66 fe 10 00    	mov    0x10fe66,%ax
  1011a1:	0f b7 c0             	movzwl %ax,%eax
  1011a4:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  1011a8:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
  1011ac:	8a 45 e5             	mov    -0x1b(%ebp),%al
  1011af:	66 8b 55 e6          	mov    -0x1a(%ebp),%dx
  1011b3:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011b4:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  1011ba:	66 c1 e8 08          	shr    $0x8,%ax
  1011be:	0f b6 d0             	movzbl %al,%edx
  1011c1:	66 a1 66 fe 10 00    	mov    0x10fe66,%ax
  1011c7:	40                   	inc    %eax
  1011c8:	0f b7 c0             	movzwl %ax,%eax
  1011cb:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  1011cf:	88 55 e9             	mov    %dl,-0x17(%ebp)
  1011d2:	8a 45 e9             	mov    -0x17(%ebp),%al
  1011d5:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
  1011d9:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  1011da:	66 a1 66 fe 10 00    	mov    0x10fe66,%ax
  1011e0:	0f b7 c0             	movzwl %ax,%eax
  1011e3:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  1011e7:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
  1011eb:	8a 45 ed             	mov    -0x13(%ebp),%al
  1011ee:	66 8b 55 ee          	mov    -0x12(%ebp),%dx
  1011f2:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  1011f3:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  1011f9:	0f b6 d0             	movzbl %al,%edx
  1011fc:	66 a1 66 fe 10 00    	mov    0x10fe66,%ax
  101202:	40                   	inc    %eax
  101203:	0f b7 c0             	movzwl %ax,%eax
  101206:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  10120a:	88 55 f1             	mov    %dl,-0xf(%ebp)
  10120d:	8a 45 f1             	mov    -0xf(%ebp),%al
  101210:	66 8b 55 f2          	mov    -0xe(%ebp),%dx
  101214:	ee                   	out    %al,(%dx)
}
  101215:	90                   	nop
  101216:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101219:	c9                   	leave  
  10121a:	c3                   	ret    

0010121b <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  10121b:	55                   	push   %ebp
  10121c:	89 e5                	mov    %esp,%ebp
  10121e:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101221:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101228:	eb 08                	jmp    101232 <serial_putc_sub+0x17>
        delay();
  10122a:	e8 91 fb ff ff       	call   100dc0 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10122f:	ff 45 fc             	incl   -0x4(%ebp)
  101232:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101238:	66 8b 45 fa          	mov    -0x6(%ebp),%ax
  10123c:	89 c2                	mov    %eax,%edx
  10123e:	ec                   	in     (%dx),%al
  10123f:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101242:	8a 45 f9             	mov    -0x7(%ebp),%al
  101245:	0f b6 c0             	movzbl %al,%eax
  101248:	83 e0 20             	and    $0x20,%eax
  10124b:	85 c0                	test   %eax,%eax
  10124d:	75 09                	jne    101258 <serial_putc_sub+0x3d>
  10124f:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101256:	7e d2                	jle    10122a <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  101258:	8b 45 08             	mov    0x8(%ebp),%eax
  10125b:	0f b6 c0             	movzbl %al,%eax
  10125e:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101264:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101267:	8a 45 f5             	mov    -0xb(%ebp),%al
  10126a:	66 8b 55 f6          	mov    -0xa(%ebp),%dx
  10126e:	ee                   	out    %al,(%dx)
}
  10126f:	90                   	nop
  101270:	c9                   	leave  
  101271:	c3                   	ret    

00101272 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101272:	55                   	push   %ebp
  101273:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  101275:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101279:	74 0d                	je     101288 <serial_putc+0x16>
        serial_putc_sub(c);
  10127b:	ff 75 08             	pushl  0x8(%ebp)
  10127e:	e8 98 ff ff ff       	call   10121b <serial_putc_sub>
  101283:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  101286:	eb 1e                	jmp    1012a6 <serial_putc+0x34>
        serial_putc_sub('\b');
  101288:	6a 08                	push   $0x8
  10128a:	e8 8c ff ff ff       	call   10121b <serial_putc_sub>
  10128f:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  101292:	6a 20                	push   $0x20
  101294:	e8 82 ff ff ff       	call   10121b <serial_putc_sub>
  101299:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  10129c:	6a 08                	push   $0x8
  10129e:	e8 78 ff ff ff       	call   10121b <serial_putc_sub>
  1012a3:	83 c4 04             	add    $0x4,%esp
}
  1012a6:	90                   	nop
  1012a7:	c9                   	leave  
  1012a8:	c3                   	ret    

001012a9 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012a9:	55                   	push   %ebp
  1012aa:	89 e5                	mov    %esp,%ebp
  1012ac:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012af:	eb 33                	jmp    1012e4 <cons_intr+0x3b>
        if (c != 0) {
  1012b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1012b5:	74 2d                	je     1012e4 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1012b7:	a1 84 00 11 00       	mov    0x110084,%eax
  1012bc:	8d 50 01             	lea    0x1(%eax),%edx
  1012bf:	89 15 84 00 11 00    	mov    %edx,0x110084
  1012c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1012c8:	88 90 80 fe 10 00    	mov    %dl,0x10fe80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1012ce:	a1 84 00 11 00       	mov    0x110084,%eax
  1012d3:	3d 00 02 00 00       	cmp    $0x200,%eax
  1012d8:	75 0a                	jne    1012e4 <cons_intr+0x3b>
                cons.wpos = 0;
  1012da:	c7 05 84 00 11 00 00 	movl   $0x0,0x110084
  1012e1:	00 00 00 
    while ((c = (*proc)()) != -1) {
  1012e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1012e7:	ff d0                	call   *%eax
  1012e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1012ec:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1012f0:	75 bf                	jne    1012b1 <cons_intr+0x8>
            }
        }
    }
}
  1012f2:	90                   	nop
  1012f3:	c9                   	leave  
  1012f4:	c3                   	ret    

001012f5 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1012f5:	55                   	push   %ebp
  1012f6:	89 e5                	mov    %esp,%ebp
  1012f8:	83 ec 10             	sub    $0x10,%esp
  1012fb:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101301:	66 8b 45 fa          	mov    -0x6(%ebp),%ax
  101305:	89 c2                	mov    %eax,%edx
  101307:	ec                   	in     (%dx),%al
  101308:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10130b:	8a 45 f9             	mov    -0x7(%ebp),%al
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10130e:	0f b6 c0             	movzbl %al,%eax
  101311:	83 e0 01             	and    $0x1,%eax
  101314:	85 c0                	test   %eax,%eax
  101316:	75 07                	jne    10131f <serial_proc_data+0x2a>
        return -1;
  101318:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10131d:	eb 29                	jmp    101348 <serial_proc_data+0x53>
  10131f:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101325:	66 8b 45 f6          	mov    -0xa(%ebp),%ax
  101329:	89 c2                	mov    %eax,%edx
  10132b:	ec                   	in     (%dx),%al
  10132c:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  10132f:	8a 45 f5             	mov    -0xb(%ebp),%al
    }
    int c = inb(COM1 + COM_RX);
  101332:	0f b6 c0             	movzbl %al,%eax
  101335:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101338:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  10133c:	75 07                	jne    101345 <serial_proc_data+0x50>
        c = '\b';
  10133e:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101345:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101348:	c9                   	leave  
  101349:	c3                   	ret    

0010134a <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  10134a:	55                   	push   %ebp
  10134b:	89 e5                	mov    %esp,%ebp
  10134d:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
  101350:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  101355:	85 c0                	test   %eax,%eax
  101357:	74 10                	je     101369 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  101359:	83 ec 0c             	sub    $0xc,%esp
  10135c:	68 f5 12 10 00       	push   $0x1012f5
  101361:	e8 43 ff ff ff       	call   1012a9 <cons_intr>
  101366:	83 c4 10             	add    $0x10,%esp
    }
}
  101369:	90                   	nop
  10136a:	c9                   	leave  
  10136b:	c3                   	ret    

0010136c <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  10136c:	55                   	push   %ebp
  10136d:	89 e5                	mov    %esp,%ebp
  10136f:	83 ec 28             	sub    $0x28,%esp
  101372:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101378:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10137b:	89 c2                	mov    %eax,%edx
  10137d:	ec                   	in     (%dx),%al
  10137e:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101381:	8a 45 ef             	mov    -0x11(%ebp),%al
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101384:	0f b6 c0             	movzbl %al,%eax
  101387:	83 e0 01             	and    $0x1,%eax
  10138a:	85 c0                	test   %eax,%eax
  10138c:	75 0a                	jne    101398 <kbd_proc_data+0x2c>
        return -1;
  10138e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101393:	e9 52 01 00 00       	jmp    1014ea <kbd_proc_data+0x17e>
  101398:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10139e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1013a1:	89 c2                	mov    %eax,%edx
  1013a3:	ec                   	in     (%dx),%al
  1013a4:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013a7:	8a 45 eb             	mov    -0x15(%ebp),%al
    }

    data = inb(KBDATAP);
  1013aa:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1013ad:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1013b1:	75 17                	jne    1013ca <kbd_proc_data+0x5e>
        // E0 escape character
        shift |= E0ESC;
  1013b3:	a1 88 00 11 00       	mov    0x110088,%eax
  1013b8:	83 c8 40             	or     $0x40,%eax
  1013bb:	a3 88 00 11 00       	mov    %eax,0x110088
        return 0;
  1013c0:	b8 00 00 00 00       	mov    $0x0,%eax
  1013c5:	e9 20 01 00 00       	jmp    1014ea <kbd_proc_data+0x17e>
    } else if (data & 0x80) {
  1013ca:	8a 45 f3             	mov    -0xd(%ebp),%al
  1013cd:	84 c0                	test   %al,%al
  1013cf:	79 44                	jns    101415 <kbd_proc_data+0xa9>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1013d1:	a1 88 00 11 00       	mov    0x110088,%eax
  1013d6:	83 e0 40             	and    $0x40,%eax
  1013d9:	85 c0                	test   %eax,%eax
  1013db:	75 08                	jne    1013e5 <kbd_proc_data+0x79>
  1013dd:	8a 45 f3             	mov    -0xd(%ebp),%al
  1013e0:	83 e0 7f             	and    $0x7f,%eax
  1013e3:	eb 03                	jmp    1013e8 <kbd_proc_data+0x7c>
  1013e5:	8a 45 f3             	mov    -0xd(%ebp),%al
  1013e8:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1013eb:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013ef:	8a 80 40 f0 10 00    	mov    0x10f040(%eax),%al
  1013f5:	83 c8 40             	or     $0x40,%eax
  1013f8:	0f b6 c0             	movzbl %al,%eax
  1013fb:	f7 d0                	not    %eax
  1013fd:	89 c2                	mov    %eax,%edx
  1013ff:	a1 88 00 11 00       	mov    0x110088,%eax
  101404:	21 d0                	and    %edx,%eax
  101406:	a3 88 00 11 00       	mov    %eax,0x110088
        return 0;
  10140b:	b8 00 00 00 00       	mov    $0x0,%eax
  101410:	e9 d5 00 00 00       	jmp    1014ea <kbd_proc_data+0x17e>
    } else if (shift & E0ESC) {
  101415:	a1 88 00 11 00       	mov    0x110088,%eax
  10141a:	83 e0 40             	and    $0x40,%eax
  10141d:	85 c0                	test   %eax,%eax
  10141f:	74 11                	je     101432 <kbd_proc_data+0xc6>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101421:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101425:	a1 88 00 11 00       	mov    0x110088,%eax
  10142a:	83 e0 bf             	and    $0xffffffbf,%eax
  10142d:	a3 88 00 11 00       	mov    %eax,0x110088
    }

    shift |= shiftcode[data];
  101432:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101436:	8a 80 40 f0 10 00    	mov    0x10f040(%eax),%al
  10143c:	0f b6 d0             	movzbl %al,%edx
  10143f:	a1 88 00 11 00       	mov    0x110088,%eax
  101444:	09 d0                	or     %edx,%eax
  101446:	a3 88 00 11 00       	mov    %eax,0x110088
    shift ^= togglecode[data];
  10144b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10144f:	8a 80 40 f1 10 00    	mov    0x10f140(%eax),%al
  101455:	0f b6 d0             	movzbl %al,%edx
  101458:	a1 88 00 11 00       	mov    0x110088,%eax
  10145d:	31 d0                	xor    %edx,%eax
  10145f:	a3 88 00 11 00       	mov    %eax,0x110088

    c = charcode[shift & (CTL | SHIFT)][data];
  101464:	a1 88 00 11 00       	mov    0x110088,%eax
  101469:	83 e0 03             	and    $0x3,%eax
  10146c:	8b 14 85 40 f5 10 00 	mov    0x10f540(,%eax,4),%edx
  101473:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101477:	01 d0                	add    %edx,%eax
  101479:	8a 00                	mov    (%eax),%al
  10147b:	0f b6 c0             	movzbl %al,%eax
  10147e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101481:	a1 88 00 11 00       	mov    0x110088,%eax
  101486:	83 e0 08             	and    $0x8,%eax
  101489:	85 c0                	test   %eax,%eax
  10148b:	74 22                	je     1014af <kbd_proc_data+0x143>
        if ('a' <= c && c <= 'z')
  10148d:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101491:	7e 0c                	jle    10149f <kbd_proc_data+0x133>
  101493:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101497:	7f 06                	jg     10149f <kbd_proc_data+0x133>
            c += 'A' - 'a';
  101499:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  10149d:	eb 10                	jmp    1014af <kbd_proc_data+0x143>
        else if ('A' <= c && c <= 'Z')
  10149f:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014a3:	7e 0a                	jle    1014af <kbd_proc_data+0x143>
  1014a5:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1014a9:	7f 04                	jg     1014af <kbd_proc_data+0x143>
            c += 'a' - 'A';
  1014ab:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1014af:	a1 88 00 11 00       	mov    0x110088,%eax
  1014b4:	f7 d0                	not    %eax
  1014b6:	83 e0 06             	and    $0x6,%eax
  1014b9:	85 c0                	test   %eax,%eax
  1014bb:	75 2a                	jne    1014e7 <kbd_proc_data+0x17b>
  1014bd:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1014c4:	75 21                	jne    1014e7 <kbd_proc_data+0x17b>
        cprintf("Rebooting!\n");
  1014c6:	83 ec 0c             	sub    $0xc,%esp
  1014c9:	68 9b 37 10 00       	push   $0x10379b
  1014ce:	e8 5f ee ff ff       	call   100332 <cprintf>
  1014d3:	83 c4 10             	add    $0x10,%esp
  1014d6:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1014dc:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1014e0:	8a 45 e7             	mov    -0x19(%ebp),%al
  1014e3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1014e6:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1014e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1014ea:	c9                   	leave  
  1014eb:	c3                   	ret    

001014ec <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1014ec:	55                   	push   %ebp
  1014ed:	89 e5                	mov    %esp,%ebp
  1014ef:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
  1014f2:	83 ec 0c             	sub    $0xc,%esp
  1014f5:	68 6c 13 10 00       	push   $0x10136c
  1014fa:	e8 aa fd ff ff       	call   1012a9 <cons_intr>
  1014ff:	83 c4 10             	add    $0x10,%esp
}
  101502:	90                   	nop
  101503:	c9                   	leave  
  101504:	c3                   	ret    

00101505 <kbd_init>:

static void
kbd_init(void) {
  101505:	55                   	push   %ebp
  101506:	89 e5                	mov    %esp,%ebp
  101508:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
  10150b:	e8 dc ff ff ff       	call   1014ec <kbd_intr>
    pic_enable(IRQ_KBD);
  101510:	83 ec 0c             	sub    $0xc,%esp
  101513:	6a 01                	push   $0x1
  101515:	e8 24 01 00 00       	call   10163e <pic_enable>
  10151a:	83 c4 10             	add    $0x10,%esp
}
  10151d:	90                   	nop
  10151e:	c9                   	leave  
  10151f:	c3                   	ret    

00101520 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101520:	55                   	push   %ebp
  101521:	89 e5                	mov    %esp,%ebp
  101523:	83 ec 08             	sub    $0x8,%esp
    cga_init();
  101526:	e8 de f8 ff ff       	call   100e09 <cga_init>
    serial_init();
  10152b:	e8 b4 f9 ff ff       	call   100ee4 <serial_init>
    kbd_init();
  101530:	e8 d0 ff ff ff       	call   101505 <kbd_init>
    if (!serial_exists) {
  101535:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  10153a:	85 c0                	test   %eax,%eax
  10153c:	75 10                	jne    10154e <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  10153e:	83 ec 0c             	sub    $0xc,%esp
  101541:	68 a7 37 10 00       	push   $0x1037a7
  101546:	e8 e7 ed ff ff       	call   100332 <cprintf>
  10154b:	83 c4 10             	add    $0x10,%esp
    }
}
  10154e:	90                   	nop
  10154f:	c9                   	leave  
  101550:	c3                   	ret    

00101551 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101551:	55                   	push   %ebp
  101552:	89 e5                	mov    %esp,%ebp
  101554:	83 ec 08             	sub    $0x8,%esp
    lpt_putc(c);
  101557:	ff 75 08             	pushl  0x8(%ebp)
  10155a:	e8 d7 fa ff ff       	call   101036 <lpt_putc>
  10155f:	83 c4 04             	add    $0x4,%esp
    cga_putc(c);
  101562:	83 ec 0c             	sub    $0xc,%esp
  101565:	ff 75 08             	pushl  0x8(%ebp)
  101568:	e8 00 fb ff ff       	call   10106d <cga_putc>
  10156d:	83 c4 10             	add    $0x10,%esp
    serial_putc(c);
  101570:	83 ec 0c             	sub    $0xc,%esp
  101573:	ff 75 08             	pushl  0x8(%ebp)
  101576:	e8 f7 fc ff ff       	call   101272 <serial_putc>
  10157b:	83 c4 10             	add    $0x10,%esp
}
  10157e:	90                   	nop
  10157f:	c9                   	leave  
  101580:	c3                   	ret    

00101581 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101581:	55                   	push   %ebp
  101582:	89 e5                	mov    %esp,%ebp
  101584:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  101587:	e8 be fd ff ff       	call   10134a <serial_intr>
    kbd_intr();
  10158c:	e8 5b ff ff ff       	call   1014ec <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  101591:	8b 15 80 00 11 00    	mov    0x110080,%edx
  101597:	a1 84 00 11 00       	mov    0x110084,%eax
  10159c:	39 c2                	cmp    %eax,%edx
  10159e:	74 35                	je     1015d5 <cons_getc+0x54>
        c = cons.buf[cons.rpos ++];
  1015a0:	a1 80 00 11 00       	mov    0x110080,%eax
  1015a5:	8d 50 01             	lea    0x1(%eax),%edx
  1015a8:	89 15 80 00 11 00    	mov    %edx,0x110080
  1015ae:	8a 80 80 fe 10 00    	mov    0x10fe80(%eax),%al
  1015b4:	0f b6 c0             	movzbl %al,%eax
  1015b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1015ba:	a1 80 00 11 00       	mov    0x110080,%eax
  1015bf:	3d 00 02 00 00       	cmp    $0x200,%eax
  1015c4:	75 0a                	jne    1015d0 <cons_getc+0x4f>
            cons.rpos = 0;
  1015c6:	c7 05 80 00 11 00 00 	movl   $0x0,0x110080
  1015cd:	00 00 00 
        }
        return c;
  1015d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1015d3:	eb 05                	jmp    1015da <cons_getc+0x59>
    }
    return 0;
  1015d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1015da:	c9                   	leave  
  1015db:	c3                   	ret    

001015dc <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1015dc:	55                   	push   %ebp
  1015dd:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1015df:	fb                   	sti    
    sti();
}
  1015e0:	90                   	nop
  1015e1:	5d                   	pop    %ebp
  1015e2:	c3                   	ret    

001015e3 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1015e3:	55                   	push   %ebp
  1015e4:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  1015e6:	fa                   	cli    
    cli();
}
  1015e7:	90                   	nop
  1015e8:	5d                   	pop    %ebp
  1015e9:	c3                   	ret    

001015ea <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1015ea:	55                   	push   %ebp
  1015eb:	89 e5                	mov    %esp,%ebp
  1015ed:	83 ec 14             	sub    $0x14,%esp
  1015f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1015f3:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1015f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1015fa:	66 a3 50 f5 10 00    	mov    %ax,0x10f550
    if (did_init) {
  101600:	a1 8c 00 11 00       	mov    0x11008c,%eax
  101605:	85 c0                	test   %eax,%eax
  101607:	74 32                	je     10163b <pic_setmask+0x51>
        outb(IO_PIC1 + 1, mask);
  101609:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10160c:	0f b6 c0             	movzbl %al,%eax
  10160f:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  101615:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101618:	8a 45 f9             	mov    -0x7(%ebp),%al
  10161b:	66 8b 55 fa          	mov    -0x6(%ebp),%dx
  10161f:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101620:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101623:	66 c1 e8 08          	shr    $0x8,%ax
  101627:	0f b6 c0             	movzbl %al,%eax
  10162a:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101630:	88 45 fd             	mov    %al,-0x3(%ebp)
  101633:	8a 45 fd             	mov    -0x3(%ebp),%al
  101636:	66 8b 55 fe          	mov    -0x2(%ebp),%dx
  10163a:	ee                   	out    %al,(%dx)
    }
}
  10163b:	90                   	nop
  10163c:	c9                   	leave  
  10163d:	c3                   	ret    

0010163e <pic_enable>:

void
pic_enable(unsigned int irq) {
  10163e:	55                   	push   %ebp
  10163f:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  101641:	8b 45 08             	mov    0x8(%ebp),%eax
  101644:	ba 01 00 00 00       	mov    $0x1,%edx
  101649:	88 c1                	mov    %al,%cl
  10164b:	d3 e2                	shl    %cl,%edx
  10164d:	89 d0                	mov    %edx,%eax
  10164f:	f7 d0                	not    %eax
  101651:	89 c2                	mov    %eax,%edx
  101653:	66 a1 50 f5 10 00    	mov    0x10f550,%ax
  101659:	21 d0                	and    %edx,%eax
  10165b:	0f b7 c0             	movzwl %ax,%eax
  10165e:	50                   	push   %eax
  10165f:	e8 86 ff ff ff       	call   1015ea <pic_setmask>
  101664:	83 c4 04             	add    $0x4,%esp
}
  101667:	90                   	nop
  101668:	c9                   	leave  
  101669:	c3                   	ret    

0010166a <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10166a:	55                   	push   %ebp
  10166b:	89 e5                	mov    %esp,%ebp
  10166d:	83 ec 40             	sub    $0x40,%esp
    did_init = 1;
  101670:	c7 05 8c 00 11 00 01 	movl   $0x1,0x11008c
  101677:	00 00 00 
  10167a:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  101680:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
  101684:	8a 45 c9             	mov    -0x37(%ebp),%al
  101687:	66 8b 55 ca          	mov    -0x36(%ebp),%dx
  10168b:	ee                   	out    %al,(%dx)
  10168c:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  101692:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
  101696:	8a 45 cd             	mov    -0x33(%ebp),%al
  101699:	66 8b 55 ce          	mov    -0x32(%ebp),%dx
  10169d:	ee                   	out    %al,(%dx)
  10169e:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1016a4:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
  1016a8:	8a 45 d1             	mov    -0x2f(%ebp),%al
  1016ab:	66 8b 55 d2          	mov    -0x2e(%ebp),%dx
  1016af:	ee                   	out    %al,(%dx)
  1016b0:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  1016b6:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
  1016ba:	8a 45 d5             	mov    -0x2b(%ebp),%al
  1016bd:	66 8b 55 d6          	mov    -0x2a(%ebp),%dx
  1016c1:	ee                   	out    %al,(%dx)
  1016c2:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  1016c8:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
  1016cc:	8a 45 d9             	mov    -0x27(%ebp),%al
  1016cf:	66 8b 55 da          	mov    -0x26(%ebp),%dx
  1016d3:	ee                   	out    %al,(%dx)
  1016d4:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  1016da:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
  1016de:	8a 45 dd             	mov    -0x23(%ebp),%al
  1016e1:	66 8b 55 de          	mov    -0x22(%ebp),%dx
  1016e5:	ee                   	out    %al,(%dx)
  1016e6:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  1016ec:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
  1016f0:	8a 45 e1             	mov    -0x1f(%ebp),%al
  1016f3:	66 8b 55 e2          	mov    -0x1e(%ebp),%dx
  1016f7:	ee                   	out    %al,(%dx)
  1016f8:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  1016fe:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
  101702:	8a 45 e5             	mov    -0x1b(%ebp),%al
  101705:	66 8b 55 e6          	mov    -0x1a(%ebp),%dx
  101709:	ee                   	out    %al,(%dx)
  10170a:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101710:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
  101714:	8a 45 e9             	mov    -0x17(%ebp),%al
  101717:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
  10171b:	ee                   	out    %al,(%dx)
  10171c:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  101722:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
  101726:	8a 45 ed             	mov    -0x13(%ebp),%al
  101729:	66 8b 55 ee          	mov    -0x12(%ebp),%dx
  10172d:	ee                   	out    %al,(%dx)
  10172e:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  101734:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
  101738:	8a 45 f1             	mov    -0xf(%ebp),%al
  10173b:	66 8b 55 f2          	mov    -0xe(%ebp),%dx
  10173f:	ee                   	out    %al,(%dx)
  101740:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101746:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
  10174a:	8a 45 f5             	mov    -0xb(%ebp),%al
  10174d:	66 8b 55 f6          	mov    -0xa(%ebp),%dx
  101751:	ee                   	out    %al,(%dx)
  101752:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  101758:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
  10175c:	8a 45 f9             	mov    -0x7(%ebp),%al
  10175f:	66 8b 55 fa          	mov    -0x6(%ebp),%dx
  101763:	ee                   	out    %al,(%dx)
  101764:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  10176a:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
  10176e:	8a 45 fd             	mov    -0x3(%ebp),%al
  101771:	66 8b 55 fe          	mov    -0x2(%ebp),%dx
  101775:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101776:	66 a1 50 f5 10 00    	mov    0x10f550,%ax
  10177c:	66 83 f8 ff          	cmp    $0xffff,%ax
  101780:	74 12                	je     101794 <pic_init+0x12a>
        pic_setmask(irq_mask);
  101782:	66 a1 50 f5 10 00    	mov    0x10f550,%ax
  101788:	0f b7 c0             	movzwl %ax,%eax
  10178b:	50                   	push   %eax
  10178c:	e8 59 fe ff ff       	call   1015ea <pic_setmask>
  101791:	83 c4 04             	add    $0x4,%esp
    }
}
  101794:	90                   	nop
  101795:	c9                   	leave  
  101796:	c3                   	ret    

00101797 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101797:	55                   	push   %ebp
  101798:	89 e5                	mov    %esp,%ebp
  10179a:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10179d:	83 ec 08             	sub    $0x8,%esp
  1017a0:	6a 64                	push   $0x64
  1017a2:	68 e0 37 10 00       	push   $0x1037e0
  1017a7:	e8 86 eb ff ff       	call   100332 <cprintf>
  1017ac:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  1017af:	83 ec 0c             	sub    $0xc,%esp
  1017b2:	68 ea 37 10 00       	push   $0x1037ea
  1017b7:	e8 76 eb ff ff       	call   100332 <cprintf>
  1017bc:	83 c4 10             	add    $0x10,%esp
    panic("EOT: kernel seems ok.");
  1017bf:	83 ec 04             	sub    $0x4,%esp
  1017c2:	68 f8 37 10 00       	push   $0x1037f8
  1017c7:	6a 12                	push   $0x12
  1017c9:	68 0e 38 10 00       	push   $0x10380e
  1017ce:	e8 b3 f4 ff ff       	call   100c86 <__panic>

001017d3 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1017d3:	55                   	push   %ebp
  1017d4:	89 e5                	mov    %esp,%ebp
  1017d6:	83 ec 10             	sub    $0x10,%esp
    // gate：处理函数的入口地址
    // istrap：系统段设置为1，中断门设置为0
    // sel：段选择子 
    // off：偏移量
    // dpl：特权级
    for (int i = 0; i < 256; ++i) 
  1017d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1017e0:	e9 b8 00 00 00       	jmp    10189d <idt_init+0xca>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1017e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1017e8:	8b 04 85 e0 f5 10 00 	mov    0x10f5e0(,%eax,4),%eax
  1017ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1017f2:	66 89 04 d5 a0 00 11 	mov    %ax,0x1100a0(,%edx,8)
  1017f9:	00 
  1017fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1017fd:	66 c7 04 c5 a2 00 11 	movw   $0x8,0x1100a2(,%eax,8)
  101804:	00 08 00 
  101807:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10180a:	8a 14 c5 a4 00 11 00 	mov    0x1100a4(,%eax,8),%dl
  101811:	83 e2 e0             	and    $0xffffffe0,%edx
  101814:	88 14 c5 a4 00 11 00 	mov    %dl,0x1100a4(,%eax,8)
  10181b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10181e:	8a 14 c5 a4 00 11 00 	mov    0x1100a4(,%eax,8),%dl
  101825:	83 e2 1f             	and    $0x1f,%edx
  101828:	88 14 c5 a4 00 11 00 	mov    %dl,0x1100a4(,%eax,8)
  10182f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101832:	8a 14 c5 a5 00 11 00 	mov    0x1100a5(,%eax,8),%dl
  101839:	83 e2 f0             	and    $0xfffffff0,%edx
  10183c:	83 ca 0e             	or     $0xe,%edx
  10183f:	88 14 c5 a5 00 11 00 	mov    %dl,0x1100a5(,%eax,8)
  101846:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101849:	8a 14 c5 a5 00 11 00 	mov    0x1100a5(,%eax,8),%dl
  101850:	83 e2 ef             	and    $0xffffffef,%edx
  101853:	88 14 c5 a5 00 11 00 	mov    %dl,0x1100a5(,%eax,8)
  10185a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10185d:	8a 14 c5 a5 00 11 00 	mov    0x1100a5(,%eax,8),%dl
  101864:	83 e2 9f             	and    $0xffffff9f,%edx
  101867:	88 14 c5 a5 00 11 00 	mov    %dl,0x1100a5(,%eax,8)
  10186e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101871:	8a 14 c5 a5 00 11 00 	mov    0x1100a5(,%eax,8),%dl
  101878:	83 ca 80             	or     $0xffffff80,%edx
  10187b:	88 14 c5 a5 00 11 00 	mov    %dl,0x1100a5(,%eax,8)
  101882:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101885:	8b 04 85 e0 f5 10 00 	mov    0x10f5e0(,%eax,4),%eax
  10188c:	c1 e8 10             	shr    $0x10,%eax
  10188f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101892:	66 89 04 d5 a6 00 11 	mov    %ax,0x1100a6(,%edx,8)
  101899:	00 
    for (int i = 0; i < 256; ++i) 
  10189a:	ff 45 fc             	incl   -0x4(%ebp)
  10189d:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  1018a4:	0f 8e 3b ff ff ff    	jle    1017e5 <idt_init+0x12>
    // T_SWITCH_TOK 定义于kern/trap/trap/h，也可以使用T_SWITCH_TOU
   	// 用于设置用户态到内核态的切换
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  1018aa:	a1 c4 f7 10 00       	mov    0x10f7c4,%eax
  1018af:	66 a3 68 04 11 00    	mov    %ax,0x110468
  1018b5:	66 c7 05 6a 04 11 00 	movw   $0x8,0x11046a
  1018bc:	08 00 
  1018be:	a0 6c 04 11 00       	mov    0x11046c,%al
  1018c3:	83 e0 e0             	and    $0xffffffe0,%eax
  1018c6:	a2 6c 04 11 00       	mov    %al,0x11046c
  1018cb:	a0 6c 04 11 00       	mov    0x11046c,%al
  1018d0:	83 e0 1f             	and    $0x1f,%eax
  1018d3:	a2 6c 04 11 00       	mov    %al,0x11046c
  1018d8:	a0 6d 04 11 00       	mov    0x11046d,%al
  1018dd:	83 e0 f0             	and    $0xfffffff0,%eax
  1018e0:	83 c8 0e             	or     $0xe,%eax
  1018e3:	a2 6d 04 11 00       	mov    %al,0x11046d
  1018e8:	a0 6d 04 11 00       	mov    0x11046d,%al
  1018ed:	83 e0 ef             	and    $0xffffffef,%eax
  1018f0:	a2 6d 04 11 00       	mov    %al,0x11046d
  1018f5:	a0 6d 04 11 00       	mov    0x11046d,%al
  1018fa:	83 c8 60             	or     $0x60,%eax
  1018fd:	a2 6d 04 11 00       	mov    %al,0x11046d
  101902:	a0 6d 04 11 00       	mov    0x11046d,%al
  101907:	83 c8 80             	or     $0xffffff80,%eax
  10190a:	a2 6d 04 11 00       	mov    %al,0x11046d
  10190f:	a1 c4 f7 10 00       	mov    0x10f7c4,%eax
  101914:	c1 e8 10             	shr    $0x10,%eax
  101917:	66 a3 6e 04 11 00    	mov    %ax,0x11046e
  10191d:	c7 45 f8 60 f5 10 00 	movl   $0x10f560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  101924:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101927:	0f 01 18             	lidtl  (%eax)
	// load IDT
    lidt(&idt_pd);
}
  10192a:	90                   	nop
  10192b:	c9                   	leave  
  10192c:	c3                   	ret    

0010192d <trapname>:

static const char *
trapname(int trapno) {
  10192d:	55                   	push   %ebp
  10192e:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101930:	8b 45 08             	mov    0x8(%ebp),%eax
  101933:	83 f8 13             	cmp    $0x13,%eax
  101936:	77 0c                	ja     101944 <trapname+0x17>
        return excnames[trapno];
  101938:	8b 45 08             	mov    0x8(%ebp),%eax
  10193b:	8b 04 85 60 3b 10 00 	mov    0x103b60(,%eax,4),%eax
  101942:	eb 18                	jmp    10195c <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101944:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101948:	7e 0d                	jle    101957 <trapname+0x2a>
  10194a:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  10194e:	7f 07                	jg     101957 <trapname+0x2a>
        return "Hardware Interrupt";
  101950:	b8 1f 38 10 00       	mov    $0x10381f,%eax
  101955:	eb 05                	jmp    10195c <trapname+0x2f>
    }
    return "(unknown trap)";
  101957:	b8 32 38 10 00       	mov    $0x103832,%eax
}
  10195c:	5d                   	pop    %ebp
  10195d:	c3                   	ret    

0010195e <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  10195e:	55                   	push   %ebp
  10195f:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101961:	8b 45 08             	mov    0x8(%ebp),%eax
  101964:	66 8b 40 3c          	mov    0x3c(%eax),%ax
  101968:	66 83 f8 08          	cmp    $0x8,%ax
  10196c:	0f 94 c0             	sete   %al
  10196f:	0f b6 c0             	movzbl %al,%eax
}
  101972:	5d                   	pop    %ebp
  101973:	c3                   	ret    

00101974 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101974:	55                   	push   %ebp
  101975:	89 e5                	mov    %esp,%ebp
  101977:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
  10197a:	83 ec 08             	sub    $0x8,%esp
  10197d:	ff 75 08             	pushl  0x8(%ebp)
  101980:	68 73 38 10 00       	push   $0x103873
  101985:	e8 a8 e9 ff ff       	call   100332 <cprintf>
  10198a:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  10198d:	8b 45 08             	mov    0x8(%ebp),%eax
  101990:	83 ec 0c             	sub    $0xc,%esp
  101993:	50                   	push   %eax
  101994:	e8 ba 01 00 00       	call   101b53 <print_regs>
  101999:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  10199c:	8b 45 08             	mov    0x8(%ebp),%eax
  10199f:	66 8b 40 2c          	mov    0x2c(%eax),%ax
  1019a3:	0f b7 c0             	movzwl %ax,%eax
  1019a6:	83 ec 08             	sub    $0x8,%esp
  1019a9:	50                   	push   %eax
  1019aa:	68 84 38 10 00       	push   $0x103884
  1019af:	e8 7e e9 ff ff       	call   100332 <cprintf>
  1019b4:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  1019b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1019ba:	66 8b 40 28          	mov    0x28(%eax),%ax
  1019be:	0f b7 c0             	movzwl %ax,%eax
  1019c1:	83 ec 08             	sub    $0x8,%esp
  1019c4:	50                   	push   %eax
  1019c5:	68 97 38 10 00       	push   $0x103897
  1019ca:	e8 63 e9 ff ff       	call   100332 <cprintf>
  1019cf:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  1019d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1019d5:	66 8b 40 24          	mov    0x24(%eax),%ax
  1019d9:	0f b7 c0             	movzwl %ax,%eax
  1019dc:	83 ec 08             	sub    $0x8,%esp
  1019df:	50                   	push   %eax
  1019e0:	68 aa 38 10 00       	push   $0x1038aa
  1019e5:	e8 48 e9 ff ff       	call   100332 <cprintf>
  1019ea:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  1019ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1019f0:	66 8b 40 20          	mov    0x20(%eax),%ax
  1019f4:	0f b7 c0             	movzwl %ax,%eax
  1019f7:	83 ec 08             	sub    $0x8,%esp
  1019fa:	50                   	push   %eax
  1019fb:	68 bd 38 10 00       	push   $0x1038bd
  101a00:	e8 2d e9 ff ff       	call   100332 <cprintf>
  101a05:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a08:	8b 45 08             	mov    0x8(%ebp),%eax
  101a0b:	8b 40 30             	mov    0x30(%eax),%eax
  101a0e:	83 ec 0c             	sub    $0xc,%esp
  101a11:	50                   	push   %eax
  101a12:	e8 16 ff ff ff       	call   10192d <trapname>
  101a17:	83 c4 10             	add    $0x10,%esp
  101a1a:	89 c2                	mov    %eax,%edx
  101a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a1f:	8b 40 30             	mov    0x30(%eax),%eax
  101a22:	83 ec 04             	sub    $0x4,%esp
  101a25:	52                   	push   %edx
  101a26:	50                   	push   %eax
  101a27:	68 d0 38 10 00       	push   $0x1038d0
  101a2c:	e8 01 e9 ff ff       	call   100332 <cprintf>
  101a31:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  101a34:	8b 45 08             	mov    0x8(%ebp),%eax
  101a37:	8b 40 34             	mov    0x34(%eax),%eax
  101a3a:	83 ec 08             	sub    $0x8,%esp
  101a3d:	50                   	push   %eax
  101a3e:	68 e2 38 10 00       	push   $0x1038e2
  101a43:	e8 ea e8 ff ff       	call   100332 <cprintf>
  101a48:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a4e:	8b 40 38             	mov    0x38(%eax),%eax
  101a51:	83 ec 08             	sub    $0x8,%esp
  101a54:	50                   	push   %eax
  101a55:	68 f1 38 10 00       	push   $0x1038f1
  101a5a:	e8 d3 e8 ff ff       	call   100332 <cprintf>
  101a5f:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101a62:	8b 45 08             	mov    0x8(%ebp),%eax
  101a65:	66 8b 40 3c          	mov    0x3c(%eax),%ax
  101a69:	0f b7 c0             	movzwl %ax,%eax
  101a6c:	83 ec 08             	sub    $0x8,%esp
  101a6f:	50                   	push   %eax
  101a70:	68 00 39 10 00       	push   $0x103900
  101a75:	e8 b8 e8 ff ff       	call   100332 <cprintf>
  101a7a:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a80:	8b 40 40             	mov    0x40(%eax),%eax
  101a83:	83 ec 08             	sub    $0x8,%esp
  101a86:	50                   	push   %eax
  101a87:	68 13 39 10 00       	push   $0x103913
  101a8c:	e8 a1 e8 ff ff       	call   100332 <cprintf>
  101a91:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101a94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101a9b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101aa2:	eb 43                	jmp    101ae7 <print_trapframe+0x173>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa7:	8b 50 40             	mov    0x40(%eax),%edx
  101aaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101aad:	21 d0                	and    %edx,%eax
  101aaf:	85 c0                	test   %eax,%eax
  101ab1:	74 29                	je     101adc <print_trapframe+0x168>
  101ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ab6:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  101abd:	85 c0                	test   %eax,%eax
  101abf:	74 1b                	je     101adc <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
  101ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ac4:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  101acb:	83 ec 08             	sub    $0x8,%esp
  101ace:	50                   	push   %eax
  101acf:	68 22 39 10 00       	push   $0x103922
  101ad4:	e8 59 e8 ff ff       	call   100332 <cprintf>
  101ad9:	83 c4 10             	add    $0x10,%esp
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101adc:	ff 45 f4             	incl   -0xc(%ebp)
  101adf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101ae2:	01 c0                	add    %eax,%eax
  101ae4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  101ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101aea:	83 f8 17             	cmp    $0x17,%eax
  101aed:	76 b5                	jbe    101aa4 <print_trapframe+0x130>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101aef:	8b 45 08             	mov    0x8(%ebp),%eax
  101af2:	8b 40 40             	mov    0x40(%eax),%eax
  101af5:	c1 e8 0c             	shr    $0xc,%eax
  101af8:	83 e0 03             	and    $0x3,%eax
  101afb:	83 ec 08             	sub    $0x8,%esp
  101afe:	50                   	push   %eax
  101aff:	68 26 39 10 00       	push   $0x103926
  101b04:	e8 29 e8 ff ff       	call   100332 <cprintf>
  101b09:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  101b0c:	83 ec 0c             	sub    $0xc,%esp
  101b0f:	ff 75 08             	pushl  0x8(%ebp)
  101b12:	e8 47 fe ff ff       	call   10195e <trap_in_kernel>
  101b17:	83 c4 10             	add    $0x10,%esp
  101b1a:	85 c0                	test   %eax,%eax
  101b1c:	75 32                	jne    101b50 <print_trapframe+0x1dc>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b21:	8b 40 44             	mov    0x44(%eax),%eax
  101b24:	83 ec 08             	sub    $0x8,%esp
  101b27:	50                   	push   %eax
  101b28:	68 2f 39 10 00       	push   $0x10392f
  101b2d:	e8 00 e8 ff ff       	call   100332 <cprintf>
  101b32:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b35:	8b 45 08             	mov    0x8(%ebp),%eax
  101b38:	66 8b 40 48          	mov    0x48(%eax),%ax
  101b3c:	0f b7 c0             	movzwl %ax,%eax
  101b3f:	83 ec 08             	sub    $0x8,%esp
  101b42:	50                   	push   %eax
  101b43:	68 3e 39 10 00       	push   $0x10393e
  101b48:	e8 e5 e7 ff ff       	call   100332 <cprintf>
  101b4d:	83 c4 10             	add    $0x10,%esp
    }
}
  101b50:	90                   	nop
  101b51:	c9                   	leave  
  101b52:	c3                   	ret    

00101b53 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101b53:	55                   	push   %ebp
  101b54:	89 e5                	mov    %esp,%ebp
  101b56:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101b59:	8b 45 08             	mov    0x8(%ebp),%eax
  101b5c:	8b 00                	mov    (%eax),%eax
  101b5e:	83 ec 08             	sub    $0x8,%esp
  101b61:	50                   	push   %eax
  101b62:	68 51 39 10 00       	push   $0x103951
  101b67:	e8 c6 e7 ff ff       	call   100332 <cprintf>
  101b6c:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b72:	8b 40 04             	mov    0x4(%eax),%eax
  101b75:	83 ec 08             	sub    $0x8,%esp
  101b78:	50                   	push   %eax
  101b79:	68 60 39 10 00       	push   $0x103960
  101b7e:	e8 af e7 ff ff       	call   100332 <cprintf>
  101b83:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101b86:	8b 45 08             	mov    0x8(%ebp),%eax
  101b89:	8b 40 08             	mov    0x8(%eax),%eax
  101b8c:	83 ec 08             	sub    $0x8,%esp
  101b8f:	50                   	push   %eax
  101b90:	68 6f 39 10 00       	push   $0x10396f
  101b95:	e8 98 e7 ff ff       	call   100332 <cprintf>
  101b9a:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba0:	8b 40 0c             	mov    0xc(%eax),%eax
  101ba3:	83 ec 08             	sub    $0x8,%esp
  101ba6:	50                   	push   %eax
  101ba7:	68 7e 39 10 00       	push   $0x10397e
  101bac:	e8 81 e7 ff ff       	call   100332 <cprintf>
  101bb1:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb7:	8b 40 10             	mov    0x10(%eax),%eax
  101bba:	83 ec 08             	sub    $0x8,%esp
  101bbd:	50                   	push   %eax
  101bbe:	68 8d 39 10 00       	push   $0x10398d
  101bc3:	e8 6a e7 ff ff       	call   100332 <cprintf>
  101bc8:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bce:	8b 40 14             	mov    0x14(%eax),%eax
  101bd1:	83 ec 08             	sub    $0x8,%esp
  101bd4:	50                   	push   %eax
  101bd5:	68 9c 39 10 00       	push   $0x10399c
  101bda:	e8 53 e7 ff ff       	call   100332 <cprintf>
  101bdf:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101be2:	8b 45 08             	mov    0x8(%ebp),%eax
  101be5:	8b 40 18             	mov    0x18(%eax),%eax
  101be8:	83 ec 08             	sub    $0x8,%esp
  101beb:	50                   	push   %eax
  101bec:	68 ab 39 10 00       	push   $0x1039ab
  101bf1:	e8 3c e7 ff ff       	call   100332 <cprintf>
  101bf6:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  101bfc:	8b 40 1c             	mov    0x1c(%eax),%eax
  101bff:	83 ec 08             	sub    $0x8,%esp
  101c02:	50                   	push   %eax
  101c03:	68 ba 39 10 00       	push   $0x1039ba
  101c08:	e8 25 e7 ff ff       	call   100332 <cprintf>
  101c0d:	83 c4 10             	add    $0x10,%esp
}
  101c10:	90                   	nop
  101c11:	c9                   	leave  
  101c12:	c3                   	ret    

00101c13 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c13:	55                   	push   %ebp
  101c14:	89 e5                	mov    %esp,%ebp
  101c16:	83 ec 18             	sub    $0x18,%esp
    char c;

    switch (tf->tf_trapno) {
  101c19:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1c:	8b 40 30             	mov    0x30(%eax),%eax
  101c1f:	83 f8 2f             	cmp    $0x2f,%eax
  101c22:	77 1d                	ja     101c41 <trap_dispatch+0x2e>
  101c24:	83 f8 2e             	cmp    $0x2e,%eax
  101c27:	0f 83 be 01 00 00    	jae    101deb <trap_dispatch+0x1d8>
  101c2d:	83 f8 21             	cmp    $0x21,%eax
  101c30:	74 7d                	je     101caf <trap_dispatch+0x9c>
  101c32:	83 f8 24             	cmp    $0x24,%eax
  101c35:	74 51                	je     101c88 <trap_dispatch+0x75>
  101c37:	83 f8 20             	cmp    $0x20,%eax
  101c3a:	74 1c                	je     101c58 <trap_dispatch+0x45>
  101c3c:	e9 74 01 00 00       	jmp    101db5 <trap_dispatch+0x1a2>
  101c41:	83 f8 78             	cmp    $0x78,%eax
  101c44:	0f 84 8c 00 00 00    	je     101cd6 <trap_dispatch+0xc3>
  101c4a:	83 f8 79             	cmp    $0x79,%eax
  101c4d:	0f 84 f4 00 00 00    	je     101d47 <trap_dispatch+0x134>
  101c53:	e9 5d 01 00 00       	jmp    101db5 <trap_dispatch+0x1a2>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ++ticks;
  101c58:	a1 08 09 11 00       	mov    0x110908,%eax
  101c5d:	40                   	inc    %eax
  101c5e:	a3 08 09 11 00       	mov    %eax,0x110908
        if (ticks % TICK_NUM == 0)
  101c63:	a1 08 09 11 00       	mov    0x110908,%eax
  101c68:	b9 64 00 00 00       	mov    $0x64,%ecx
  101c6d:	ba 00 00 00 00       	mov    $0x0,%edx
  101c72:	f7 f1                	div    %ecx
  101c74:	89 d0                	mov    %edx,%eax
  101c76:	85 c0                	test   %eax,%eax
  101c78:	0f 85 70 01 00 00    	jne    101dee <trap_dispatch+0x1db>
            print_ticks();
  101c7e:	e8 14 fb ff ff       	call   101797 <print_ticks>
        break;
  101c83:	e9 66 01 00 00       	jmp    101dee <trap_dispatch+0x1db>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101c88:	e8 f4 f8 ff ff       	call   101581 <cons_getc>
  101c8d:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101c90:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101c94:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101c98:	83 ec 04             	sub    $0x4,%esp
  101c9b:	52                   	push   %edx
  101c9c:	50                   	push   %eax
  101c9d:	68 c9 39 10 00       	push   $0x1039c9
  101ca2:	e8 8b e6 ff ff       	call   100332 <cprintf>
  101ca7:	83 c4 10             	add    $0x10,%esp
        break;
  101caa:	e9 46 01 00 00       	jmp    101df5 <trap_dispatch+0x1e2>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101caf:	e8 cd f8 ff ff       	call   101581 <cons_getc>
  101cb4:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101cb7:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101cbb:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101cbf:	83 ec 04             	sub    $0x4,%esp
  101cc2:	52                   	push   %edx
  101cc3:	50                   	push   %eax
  101cc4:	68 db 39 10 00       	push   $0x1039db
  101cc9:	e8 64 e6 ff ff       	call   100332 <cprintf>
  101cce:	83 c4 10             	add    $0x10,%esp
        break;
  101cd1:	e9 1f 01 00 00       	jmp    101df5 <trap_dispatch+0x1e2>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
  101cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd9:	66 8b 40 3c          	mov    0x3c(%eax),%ax
  101cdd:	66 83 f8 1b          	cmp    $0x1b,%ax
  101ce1:	0f 84 0a 01 00 00    	je     101df1 <trap_dispatch+0x1de>
            tf->tf_ds = tf->tf_es = tf->tf_fs = tf->tf_gs = tf->tf_ss = USER_DS;
  101ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  101cea:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
  101cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf3:	66 8b 40 48          	mov    0x48(%eax),%ax
  101cf7:	8b 55 08             	mov    0x8(%ebp),%edx
  101cfa:	66 89 42 20          	mov    %ax,0x20(%edx)
  101cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  101d01:	66 8b 40 20          	mov    0x20(%eax),%ax
  101d05:	8b 55 08             	mov    0x8(%ebp),%edx
  101d08:	66 89 42 24          	mov    %ax,0x24(%edx)
  101d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  101d0f:	66 8b 40 24          	mov    0x24(%eax),%ax
  101d13:	8b 55 08             	mov    0x8(%ebp),%edx
  101d16:	66 89 42 28          	mov    %ax,0x28(%edx)
  101d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d1d:	66 8b 40 28          	mov    0x28(%eax),%ax
  101d21:	8b 55 08             	mov    0x8(%ebp),%edx
  101d24:	66 89 42 2c          	mov    %ax,0x2c(%edx)
            tf->tf_cs = USER_CS;
  101d28:	8b 45 08             	mov    0x8(%ebp),%eax
  101d2b:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
            tf->tf_eflags |= FL_IOPL_MASK;
  101d31:	8b 45 08             	mov    0x8(%ebp),%eax
  101d34:	8b 40 40             	mov    0x40(%eax),%eax
  101d37:	80 cc 30             	or     $0x30,%ah
  101d3a:	89 c2                	mov    %eax,%edx
  101d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  101d3f:	89 50 40             	mov    %edx,0x40(%eax)
        }
        break;
  101d42:	e9 aa 00 00 00       	jmp    101df1 <trap_dispatch+0x1de>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
  101d47:	8b 45 08             	mov    0x8(%ebp),%eax
  101d4a:	66 8b 40 3c          	mov    0x3c(%eax),%ax
  101d4e:	66 83 f8 08          	cmp    $0x8,%ax
  101d52:	0f 84 9c 00 00 00    	je     101df4 <trap_dispatch+0x1e1>
            tf->tf_ds = tf->tf_es = tf->tf_fs = tf->tf_gs = tf->tf_ss = KERNEL_DS;
  101d58:	8b 45 08             	mov    0x8(%ebp),%eax
  101d5b:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
  101d61:	8b 45 08             	mov    0x8(%ebp),%eax
  101d64:	66 8b 40 48          	mov    0x48(%eax),%ax
  101d68:	8b 55 08             	mov    0x8(%ebp),%edx
  101d6b:	66 89 42 20          	mov    %ax,0x20(%edx)
  101d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  101d72:	66 8b 40 20          	mov    0x20(%eax),%ax
  101d76:	8b 55 08             	mov    0x8(%ebp),%edx
  101d79:	66 89 42 24          	mov    %ax,0x24(%edx)
  101d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  101d80:	66 8b 40 24          	mov    0x24(%eax),%ax
  101d84:	8b 55 08             	mov    0x8(%ebp),%edx
  101d87:	66 89 42 28          	mov    %ax,0x28(%edx)
  101d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  101d8e:	66 8b 40 28          	mov    0x28(%eax),%ax
  101d92:	8b 55 08             	mov    0x8(%ebp),%edx
  101d95:	66 89 42 2c          	mov    %ax,0x2c(%edx)
            tf->tf_cs = KERNEL_CS;
  101d99:	8b 45 08             	mov    0x8(%ebp),%eax
  101d9c:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101da2:	8b 45 08             	mov    0x8(%ebp),%eax
  101da5:	8b 40 40             	mov    0x40(%eax),%eax
  101da8:	80 e4 cf             	and    $0xcf,%ah
  101dab:	89 c2                	mov    %eax,%edx
  101dad:	8b 45 08             	mov    0x8(%ebp),%eax
  101db0:	89 50 40             	mov    %edx,0x40(%eax)
        }
        break;
  101db3:	eb 3f                	jmp    101df4 <trap_dispatch+0x1e1>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101db5:	8b 45 08             	mov    0x8(%ebp),%eax
  101db8:	66 8b 40 3c          	mov    0x3c(%eax),%ax
  101dbc:	0f b7 c0             	movzwl %ax,%eax
  101dbf:	83 e0 03             	and    $0x3,%eax
  101dc2:	85 c0                	test   %eax,%eax
  101dc4:	75 2f                	jne    101df5 <trap_dispatch+0x1e2>
            print_trapframe(tf);
  101dc6:	83 ec 0c             	sub    $0xc,%esp
  101dc9:	ff 75 08             	pushl  0x8(%ebp)
  101dcc:	e8 a3 fb ff ff       	call   101974 <print_trapframe>
  101dd1:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101dd4:	83 ec 04             	sub    $0x4,%esp
  101dd7:	68 ea 39 10 00       	push   $0x1039ea
  101ddc:	68 c8 00 00 00       	push   $0xc8
  101de1:	68 0e 38 10 00       	push   $0x10380e
  101de6:	e8 9b ee ff ff       	call   100c86 <__panic>
        break;
  101deb:	90                   	nop
  101dec:	eb 07                	jmp    101df5 <trap_dispatch+0x1e2>
        break;
  101dee:	90                   	nop
  101def:	eb 04                	jmp    101df5 <trap_dispatch+0x1e2>
        break;
  101df1:	90                   	nop
  101df2:	eb 01                	jmp    101df5 <trap_dispatch+0x1e2>
        break;
  101df4:	90                   	nop
        }
    }
}
  101df5:	90                   	nop
  101df6:	c9                   	leave  
  101df7:	c3                   	ret    

00101df8 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101df8:	55                   	push   %ebp
  101df9:	89 e5                	mov    %esp,%ebp
  101dfb:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101dfe:	83 ec 0c             	sub    $0xc,%esp
  101e01:	ff 75 08             	pushl  0x8(%ebp)
  101e04:	e8 0a fe ff ff       	call   101c13 <trap_dispatch>
  101e09:	83 c4 10             	add    $0x10,%esp
}
  101e0c:	90                   	nop
  101e0d:	c9                   	leave  
  101e0e:	c3                   	ret    

00101e0f <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101e0f:	1e                   	push   %ds
    pushl %es
  101e10:	06                   	push   %es
    pushl %fs
  101e11:	0f a0                	push   %fs
    pushl %gs
  101e13:	0f a8                	push   %gs
    pushal
  101e15:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101e16:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101e1b:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101e1d:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101e1f:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101e20:	e8 d3 ff ff ff       	call   101df8 <trap>

    # pop the pushed stack pointer
    popl %esp
  101e25:	5c                   	pop    %esp

00101e26 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101e26:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101e27:	0f a9                	pop    %gs
    popl %fs
  101e29:	0f a1                	pop    %fs
    popl %es
  101e2b:	07                   	pop    %es
    popl %ds
  101e2c:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101e2d:	83 c4 08             	add    $0x8,%esp
    iret
  101e30:	cf                   	iret   

00101e31 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101e31:	6a 00                	push   $0x0
  pushl $0
  101e33:	6a 00                	push   $0x0
  jmp __alltraps
  101e35:	e9 d5 ff ff ff       	jmp    101e0f <__alltraps>

00101e3a <vector1>:
.globl vector1
vector1:
  pushl $0
  101e3a:	6a 00                	push   $0x0
  pushl $1
  101e3c:	6a 01                	push   $0x1
  jmp __alltraps
  101e3e:	e9 cc ff ff ff       	jmp    101e0f <__alltraps>

00101e43 <vector2>:
.globl vector2
vector2:
  pushl $0
  101e43:	6a 00                	push   $0x0
  pushl $2
  101e45:	6a 02                	push   $0x2
  jmp __alltraps
  101e47:	e9 c3 ff ff ff       	jmp    101e0f <__alltraps>

00101e4c <vector3>:
.globl vector3
vector3:
  pushl $0
  101e4c:	6a 00                	push   $0x0
  pushl $3
  101e4e:	6a 03                	push   $0x3
  jmp __alltraps
  101e50:	e9 ba ff ff ff       	jmp    101e0f <__alltraps>

00101e55 <vector4>:
.globl vector4
vector4:
  pushl $0
  101e55:	6a 00                	push   $0x0
  pushl $4
  101e57:	6a 04                	push   $0x4
  jmp __alltraps
  101e59:	e9 b1 ff ff ff       	jmp    101e0f <__alltraps>

00101e5e <vector5>:
.globl vector5
vector5:
  pushl $0
  101e5e:	6a 00                	push   $0x0
  pushl $5
  101e60:	6a 05                	push   $0x5
  jmp __alltraps
  101e62:	e9 a8 ff ff ff       	jmp    101e0f <__alltraps>

00101e67 <vector6>:
.globl vector6
vector6:
  pushl $0
  101e67:	6a 00                	push   $0x0
  pushl $6
  101e69:	6a 06                	push   $0x6
  jmp __alltraps
  101e6b:	e9 9f ff ff ff       	jmp    101e0f <__alltraps>

00101e70 <vector7>:
.globl vector7
vector7:
  pushl $0
  101e70:	6a 00                	push   $0x0
  pushl $7
  101e72:	6a 07                	push   $0x7
  jmp __alltraps
  101e74:	e9 96 ff ff ff       	jmp    101e0f <__alltraps>

00101e79 <vector8>:
.globl vector8
vector8:
  pushl $8
  101e79:	6a 08                	push   $0x8
  jmp __alltraps
  101e7b:	e9 8f ff ff ff       	jmp    101e0f <__alltraps>

00101e80 <vector9>:
.globl vector9
vector9:
  pushl $0
  101e80:	6a 00                	push   $0x0
  pushl $9
  101e82:	6a 09                	push   $0x9
  jmp __alltraps
  101e84:	e9 86 ff ff ff       	jmp    101e0f <__alltraps>

00101e89 <vector10>:
.globl vector10
vector10:
  pushl $10
  101e89:	6a 0a                	push   $0xa
  jmp __alltraps
  101e8b:	e9 7f ff ff ff       	jmp    101e0f <__alltraps>

00101e90 <vector11>:
.globl vector11
vector11:
  pushl $11
  101e90:	6a 0b                	push   $0xb
  jmp __alltraps
  101e92:	e9 78 ff ff ff       	jmp    101e0f <__alltraps>

00101e97 <vector12>:
.globl vector12
vector12:
  pushl $12
  101e97:	6a 0c                	push   $0xc
  jmp __alltraps
  101e99:	e9 71 ff ff ff       	jmp    101e0f <__alltraps>

00101e9e <vector13>:
.globl vector13
vector13:
  pushl $13
  101e9e:	6a 0d                	push   $0xd
  jmp __alltraps
  101ea0:	e9 6a ff ff ff       	jmp    101e0f <__alltraps>

00101ea5 <vector14>:
.globl vector14
vector14:
  pushl $14
  101ea5:	6a 0e                	push   $0xe
  jmp __alltraps
  101ea7:	e9 63 ff ff ff       	jmp    101e0f <__alltraps>

00101eac <vector15>:
.globl vector15
vector15:
  pushl $0
  101eac:	6a 00                	push   $0x0
  pushl $15
  101eae:	6a 0f                	push   $0xf
  jmp __alltraps
  101eb0:	e9 5a ff ff ff       	jmp    101e0f <__alltraps>

00101eb5 <vector16>:
.globl vector16
vector16:
  pushl $0
  101eb5:	6a 00                	push   $0x0
  pushl $16
  101eb7:	6a 10                	push   $0x10
  jmp __alltraps
  101eb9:	e9 51 ff ff ff       	jmp    101e0f <__alltraps>

00101ebe <vector17>:
.globl vector17
vector17:
  pushl $17
  101ebe:	6a 11                	push   $0x11
  jmp __alltraps
  101ec0:	e9 4a ff ff ff       	jmp    101e0f <__alltraps>

00101ec5 <vector18>:
.globl vector18
vector18:
  pushl $0
  101ec5:	6a 00                	push   $0x0
  pushl $18
  101ec7:	6a 12                	push   $0x12
  jmp __alltraps
  101ec9:	e9 41 ff ff ff       	jmp    101e0f <__alltraps>

00101ece <vector19>:
.globl vector19
vector19:
  pushl $0
  101ece:	6a 00                	push   $0x0
  pushl $19
  101ed0:	6a 13                	push   $0x13
  jmp __alltraps
  101ed2:	e9 38 ff ff ff       	jmp    101e0f <__alltraps>

00101ed7 <vector20>:
.globl vector20
vector20:
  pushl $0
  101ed7:	6a 00                	push   $0x0
  pushl $20
  101ed9:	6a 14                	push   $0x14
  jmp __alltraps
  101edb:	e9 2f ff ff ff       	jmp    101e0f <__alltraps>

00101ee0 <vector21>:
.globl vector21
vector21:
  pushl $0
  101ee0:	6a 00                	push   $0x0
  pushl $21
  101ee2:	6a 15                	push   $0x15
  jmp __alltraps
  101ee4:	e9 26 ff ff ff       	jmp    101e0f <__alltraps>

00101ee9 <vector22>:
.globl vector22
vector22:
  pushl $0
  101ee9:	6a 00                	push   $0x0
  pushl $22
  101eeb:	6a 16                	push   $0x16
  jmp __alltraps
  101eed:	e9 1d ff ff ff       	jmp    101e0f <__alltraps>

00101ef2 <vector23>:
.globl vector23
vector23:
  pushl $0
  101ef2:	6a 00                	push   $0x0
  pushl $23
  101ef4:	6a 17                	push   $0x17
  jmp __alltraps
  101ef6:	e9 14 ff ff ff       	jmp    101e0f <__alltraps>

00101efb <vector24>:
.globl vector24
vector24:
  pushl $0
  101efb:	6a 00                	push   $0x0
  pushl $24
  101efd:	6a 18                	push   $0x18
  jmp __alltraps
  101eff:	e9 0b ff ff ff       	jmp    101e0f <__alltraps>

00101f04 <vector25>:
.globl vector25
vector25:
  pushl $0
  101f04:	6a 00                	push   $0x0
  pushl $25
  101f06:	6a 19                	push   $0x19
  jmp __alltraps
  101f08:	e9 02 ff ff ff       	jmp    101e0f <__alltraps>

00101f0d <vector26>:
.globl vector26
vector26:
  pushl $0
  101f0d:	6a 00                	push   $0x0
  pushl $26
  101f0f:	6a 1a                	push   $0x1a
  jmp __alltraps
  101f11:	e9 f9 fe ff ff       	jmp    101e0f <__alltraps>

00101f16 <vector27>:
.globl vector27
vector27:
  pushl $0
  101f16:	6a 00                	push   $0x0
  pushl $27
  101f18:	6a 1b                	push   $0x1b
  jmp __alltraps
  101f1a:	e9 f0 fe ff ff       	jmp    101e0f <__alltraps>

00101f1f <vector28>:
.globl vector28
vector28:
  pushl $0
  101f1f:	6a 00                	push   $0x0
  pushl $28
  101f21:	6a 1c                	push   $0x1c
  jmp __alltraps
  101f23:	e9 e7 fe ff ff       	jmp    101e0f <__alltraps>

00101f28 <vector29>:
.globl vector29
vector29:
  pushl $0
  101f28:	6a 00                	push   $0x0
  pushl $29
  101f2a:	6a 1d                	push   $0x1d
  jmp __alltraps
  101f2c:	e9 de fe ff ff       	jmp    101e0f <__alltraps>

00101f31 <vector30>:
.globl vector30
vector30:
  pushl $0
  101f31:	6a 00                	push   $0x0
  pushl $30
  101f33:	6a 1e                	push   $0x1e
  jmp __alltraps
  101f35:	e9 d5 fe ff ff       	jmp    101e0f <__alltraps>

00101f3a <vector31>:
.globl vector31
vector31:
  pushl $0
  101f3a:	6a 00                	push   $0x0
  pushl $31
  101f3c:	6a 1f                	push   $0x1f
  jmp __alltraps
  101f3e:	e9 cc fe ff ff       	jmp    101e0f <__alltraps>

00101f43 <vector32>:
.globl vector32
vector32:
  pushl $0
  101f43:	6a 00                	push   $0x0
  pushl $32
  101f45:	6a 20                	push   $0x20
  jmp __alltraps
  101f47:	e9 c3 fe ff ff       	jmp    101e0f <__alltraps>

00101f4c <vector33>:
.globl vector33
vector33:
  pushl $0
  101f4c:	6a 00                	push   $0x0
  pushl $33
  101f4e:	6a 21                	push   $0x21
  jmp __alltraps
  101f50:	e9 ba fe ff ff       	jmp    101e0f <__alltraps>

00101f55 <vector34>:
.globl vector34
vector34:
  pushl $0
  101f55:	6a 00                	push   $0x0
  pushl $34
  101f57:	6a 22                	push   $0x22
  jmp __alltraps
  101f59:	e9 b1 fe ff ff       	jmp    101e0f <__alltraps>

00101f5e <vector35>:
.globl vector35
vector35:
  pushl $0
  101f5e:	6a 00                	push   $0x0
  pushl $35
  101f60:	6a 23                	push   $0x23
  jmp __alltraps
  101f62:	e9 a8 fe ff ff       	jmp    101e0f <__alltraps>

00101f67 <vector36>:
.globl vector36
vector36:
  pushl $0
  101f67:	6a 00                	push   $0x0
  pushl $36
  101f69:	6a 24                	push   $0x24
  jmp __alltraps
  101f6b:	e9 9f fe ff ff       	jmp    101e0f <__alltraps>

00101f70 <vector37>:
.globl vector37
vector37:
  pushl $0
  101f70:	6a 00                	push   $0x0
  pushl $37
  101f72:	6a 25                	push   $0x25
  jmp __alltraps
  101f74:	e9 96 fe ff ff       	jmp    101e0f <__alltraps>

00101f79 <vector38>:
.globl vector38
vector38:
  pushl $0
  101f79:	6a 00                	push   $0x0
  pushl $38
  101f7b:	6a 26                	push   $0x26
  jmp __alltraps
  101f7d:	e9 8d fe ff ff       	jmp    101e0f <__alltraps>

00101f82 <vector39>:
.globl vector39
vector39:
  pushl $0
  101f82:	6a 00                	push   $0x0
  pushl $39
  101f84:	6a 27                	push   $0x27
  jmp __alltraps
  101f86:	e9 84 fe ff ff       	jmp    101e0f <__alltraps>

00101f8b <vector40>:
.globl vector40
vector40:
  pushl $0
  101f8b:	6a 00                	push   $0x0
  pushl $40
  101f8d:	6a 28                	push   $0x28
  jmp __alltraps
  101f8f:	e9 7b fe ff ff       	jmp    101e0f <__alltraps>

00101f94 <vector41>:
.globl vector41
vector41:
  pushl $0
  101f94:	6a 00                	push   $0x0
  pushl $41
  101f96:	6a 29                	push   $0x29
  jmp __alltraps
  101f98:	e9 72 fe ff ff       	jmp    101e0f <__alltraps>

00101f9d <vector42>:
.globl vector42
vector42:
  pushl $0
  101f9d:	6a 00                	push   $0x0
  pushl $42
  101f9f:	6a 2a                	push   $0x2a
  jmp __alltraps
  101fa1:	e9 69 fe ff ff       	jmp    101e0f <__alltraps>

00101fa6 <vector43>:
.globl vector43
vector43:
  pushl $0
  101fa6:	6a 00                	push   $0x0
  pushl $43
  101fa8:	6a 2b                	push   $0x2b
  jmp __alltraps
  101faa:	e9 60 fe ff ff       	jmp    101e0f <__alltraps>

00101faf <vector44>:
.globl vector44
vector44:
  pushl $0
  101faf:	6a 00                	push   $0x0
  pushl $44
  101fb1:	6a 2c                	push   $0x2c
  jmp __alltraps
  101fb3:	e9 57 fe ff ff       	jmp    101e0f <__alltraps>

00101fb8 <vector45>:
.globl vector45
vector45:
  pushl $0
  101fb8:	6a 00                	push   $0x0
  pushl $45
  101fba:	6a 2d                	push   $0x2d
  jmp __alltraps
  101fbc:	e9 4e fe ff ff       	jmp    101e0f <__alltraps>

00101fc1 <vector46>:
.globl vector46
vector46:
  pushl $0
  101fc1:	6a 00                	push   $0x0
  pushl $46
  101fc3:	6a 2e                	push   $0x2e
  jmp __alltraps
  101fc5:	e9 45 fe ff ff       	jmp    101e0f <__alltraps>

00101fca <vector47>:
.globl vector47
vector47:
  pushl $0
  101fca:	6a 00                	push   $0x0
  pushl $47
  101fcc:	6a 2f                	push   $0x2f
  jmp __alltraps
  101fce:	e9 3c fe ff ff       	jmp    101e0f <__alltraps>

00101fd3 <vector48>:
.globl vector48
vector48:
  pushl $0
  101fd3:	6a 00                	push   $0x0
  pushl $48
  101fd5:	6a 30                	push   $0x30
  jmp __alltraps
  101fd7:	e9 33 fe ff ff       	jmp    101e0f <__alltraps>

00101fdc <vector49>:
.globl vector49
vector49:
  pushl $0
  101fdc:	6a 00                	push   $0x0
  pushl $49
  101fde:	6a 31                	push   $0x31
  jmp __alltraps
  101fe0:	e9 2a fe ff ff       	jmp    101e0f <__alltraps>

00101fe5 <vector50>:
.globl vector50
vector50:
  pushl $0
  101fe5:	6a 00                	push   $0x0
  pushl $50
  101fe7:	6a 32                	push   $0x32
  jmp __alltraps
  101fe9:	e9 21 fe ff ff       	jmp    101e0f <__alltraps>

00101fee <vector51>:
.globl vector51
vector51:
  pushl $0
  101fee:	6a 00                	push   $0x0
  pushl $51
  101ff0:	6a 33                	push   $0x33
  jmp __alltraps
  101ff2:	e9 18 fe ff ff       	jmp    101e0f <__alltraps>

00101ff7 <vector52>:
.globl vector52
vector52:
  pushl $0
  101ff7:	6a 00                	push   $0x0
  pushl $52
  101ff9:	6a 34                	push   $0x34
  jmp __alltraps
  101ffb:	e9 0f fe ff ff       	jmp    101e0f <__alltraps>

00102000 <vector53>:
.globl vector53
vector53:
  pushl $0
  102000:	6a 00                	push   $0x0
  pushl $53
  102002:	6a 35                	push   $0x35
  jmp __alltraps
  102004:	e9 06 fe ff ff       	jmp    101e0f <__alltraps>

00102009 <vector54>:
.globl vector54
vector54:
  pushl $0
  102009:	6a 00                	push   $0x0
  pushl $54
  10200b:	6a 36                	push   $0x36
  jmp __alltraps
  10200d:	e9 fd fd ff ff       	jmp    101e0f <__alltraps>

00102012 <vector55>:
.globl vector55
vector55:
  pushl $0
  102012:	6a 00                	push   $0x0
  pushl $55
  102014:	6a 37                	push   $0x37
  jmp __alltraps
  102016:	e9 f4 fd ff ff       	jmp    101e0f <__alltraps>

0010201b <vector56>:
.globl vector56
vector56:
  pushl $0
  10201b:	6a 00                	push   $0x0
  pushl $56
  10201d:	6a 38                	push   $0x38
  jmp __alltraps
  10201f:	e9 eb fd ff ff       	jmp    101e0f <__alltraps>

00102024 <vector57>:
.globl vector57
vector57:
  pushl $0
  102024:	6a 00                	push   $0x0
  pushl $57
  102026:	6a 39                	push   $0x39
  jmp __alltraps
  102028:	e9 e2 fd ff ff       	jmp    101e0f <__alltraps>

0010202d <vector58>:
.globl vector58
vector58:
  pushl $0
  10202d:	6a 00                	push   $0x0
  pushl $58
  10202f:	6a 3a                	push   $0x3a
  jmp __alltraps
  102031:	e9 d9 fd ff ff       	jmp    101e0f <__alltraps>

00102036 <vector59>:
.globl vector59
vector59:
  pushl $0
  102036:	6a 00                	push   $0x0
  pushl $59
  102038:	6a 3b                	push   $0x3b
  jmp __alltraps
  10203a:	e9 d0 fd ff ff       	jmp    101e0f <__alltraps>

0010203f <vector60>:
.globl vector60
vector60:
  pushl $0
  10203f:	6a 00                	push   $0x0
  pushl $60
  102041:	6a 3c                	push   $0x3c
  jmp __alltraps
  102043:	e9 c7 fd ff ff       	jmp    101e0f <__alltraps>

00102048 <vector61>:
.globl vector61
vector61:
  pushl $0
  102048:	6a 00                	push   $0x0
  pushl $61
  10204a:	6a 3d                	push   $0x3d
  jmp __alltraps
  10204c:	e9 be fd ff ff       	jmp    101e0f <__alltraps>

00102051 <vector62>:
.globl vector62
vector62:
  pushl $0
  102051:	6a 00                	push   $0x0
  pushl $62
  102053:	6a 3e                	push   $0x3e
  jmp __alltraps
  102055:	e9 b5 fd ff ff       	jmp    101e0f <__alltraps>

0010205a <vector63>:
.globl vector63
vector63:
  pushl $0
  10205a:	6a 00                	push   $0x0
  pushl $63
  10205c:	6a 3f                	push   $0x3f
  jmp __alltraps
  10205e:	e9 ac fd ff ff       	jmp    101e0f <__alltraps>

00102063 <vector64>:
.globl vector64
vector64:
  pushl $0
  102063:	6a 00                	push   $0x0
  pushl $64
  102065:	6a 40                	push   $0x40
  jmp __alltraps
  102067:	e9 a3 fd ff ff       	jmp    101e0f <__alltraps>

0010206c <vector65>:
.globl vector65
vector65:
  pushl $0
  10206c:	6a 00                	push   $0x0
  pushl $65
  10206e:	6a 41                	push   $0x41
  jmp __alltraps
  102070:	e9 9a fd ff ff       	jmp    101e0f <__alltraps>

00102075 <vector66>:
.globl vector66
vector66:
  pushl $0
  102075:	6a 00                	push   $0x0
  pushl $66
  102077:	6a 42                	push   $0x42
  jmp __alltraps
  102079:	e9 91 fd ff ff       	jmp    101e0f <__alltraps>

0010207e <vector67>:
.globl vector67
vector67:
  pushl $0
  10207e:	6a 00                	push   $0x0
  pushl $67
  102080:	6a 43                	push   $0x43
  jmp __alltraps
  102082:	e9 88 fd ff ff       	jmp    101e0f <__alltraps>

00102087 <vector68>:
.globl vector68
vector68:
  pushl $0
  102087:	6a 00                	push   $0x0
  pushl $68
  102089:	6a 44                	push   $0x44
  jmp __alltraps
  10208b:	e9 7f fd ff ff       	jmp    101e0f <__alltraps>

00102090 <vector69>:
.globl vector69
vector69:
  pushl $0
  102090:	6a 00                	push   $0x0
  pushl $69
  102092:	6a 45                	push   $0x45
  jmp __alltraps
  102094:	e9 76 fd ff ff       	jmp    101e0f <__alltraps>

00102099 <vector70>:
.globl vector70
vector70:
  pushl $0
  102099:	6a 00                	push   $0x0
  pushl $70
  10209b:	6a 46                	push   $0x46
  jmp __alltraps
  10209d:	e9 6d fd ff ff       	jmp    101e0f <__alltraps>

001020a2 <vector71>:
.globl vector71
vector71:
  pushl $0
  1020a2:	6a 00                	push   $0x0
  pushl $71
  1020a4:	6a 47                	push   $0x47
  jmp __alltraps
  1020a6:	e9 64 fd ff ff       	jmp    101e0f <__alltraps>

001020ab <vector72>:
.globl vector72
vector72:
  pushl $0
  1020ab:	6a 00                	push   $0x0
  pushl $72
  1020ad:	6a 48                	push   $0x48
  jmp __alltraps
  1020af:	e9 5b fd ff ff       	jmp    101e0f <__alltraps>

001020b4 <vector73>:
.globl vector73
vector73:
  pushl $0
  1020b4:	6a 00                	push   $0x0
  pushl $73
  1020b6:	6a 49                	push   $0x49
  jmp __alltraps
  1020b8:	e9 52 fd ff ff       	jmp    101e0f <__alltraps>

001020bd <vector74>:
.globl vector74
vector74:
  pushl $0
  1020bd:	6a 00                	push   $0x0
  pushl $74
  1020bf:	6a 4a                	push   $0x4a
  jmp __alltraps
  1020c1:	e9 49 fd ff ff       	jmp    101e0f <__alltraps>

001020c6 <vector75>:
.globl vector75
vector75:
  pushl $0
  1020c6:	6a 00                	push   $0x0
  pushl $75
  1020c8:	6a 4b                	push   $0x4b
  jmp __alltraps
  1020ca:	e9 40 fd ff ff       	jmp    101e0f <__alltraps>

001020cf <vector76>:
.globl vector76
vector76:
  pushl $0
  1020cf:	6a 00                	push   $0x0
  pushl $76
  1020d1:	6a 4c                	push   $0x4c
  jmp __alltraps
  1020d3:	e9 37 fd ff ff       	jmp    101e0f <__alltraps>

001020d8 <vector77>:
.globl vector77
vector77:
  pushl $0
  1020d8:	6a 00                	push   $0x0
  pushl $77
  1020da:	6a 4d                	push   $0x4d
  jmp __alltraps
  1020dc:	e9 2e fd ff ff       	jmp    101e0f <__alltraps>

001020e1 <vector78>:
.globl vector78
vector78:
  pushl $0
  1020e1:	6a 00                	push   $0x0
  pushl $78
  1020e3:	6a 4e                	push   $0x4e
  jmp __alltraps
  1020e5:	e9 25 fd ff ff       	jmp    101e0f <__alltraps>

001020ea <vector79>:
.globl vector79
vector79:
  pushl $0
  1020ea:	6a 00                	push   $0x0
  pushl $79
  1020ec:	6a 4f                	push   $0x4f
  jmp __alltraps
  1020ee:	e9 1c fd ff ff       	jmp    101e0f <__alltraps>

001020f3 <vector80>:
.globl vector80
vector80:
  pushl $0
  1020f3:	6a 00                	push   $0x0
  pushl $80
  1020f5:	6a 50                	push   $0x50
  jmp __alltraps
  1020f7:	e9 13 fd ff ff       	jmp    101e0f <__alltraps>

001020fc <vector81>:
.globl vector81
vector81:
  pushl $0
  1020fc:	6a 00                	push   $0x0
  pushl $81
  1020fe:	6a 51                	push   $0x51
  jmp __alltraps
  102100:	e9 0a fd ff ff       	jmp    101e0f <__alltraps>

00102105 <vector82>:
.globl vector82
vector82:
  pushl $0
  102105:	6a 00                	push   $0x0
  pushl $82
  102107:	6a 52                	push   $0x52
  jmp __alltraps
  102109:	e9 01 fd ff ff       	jmp    101e0f <__alltraps>

0010210e <vector83>:
.globl vector83
vector83:
  pushl $0
  10210e:	6a 00                	push   $0x0
  pushl $83
  102110:	6a 53                	push   $0x53
  jmp __alltraps
  102112:	e9 f8 fc ff ff       	jmp    101e0f <__alltraps>

00102117 <vector84>:
.globl vector84
vector84:
  pushl $0
  102117:	6a 00                	push   $0x0
  pushl $84
  102119:	6a 54                	push   $0x54
  jmp __alltraps
  10211b:	e9 ef fc ff ff       	jmp    101e0f <__alltraps>

00102120 <vector85>:
.globl vector85
vector85:
  pushl $0
  102120:	6a 00                	push   $0x0
  pushl $85
  102122:	6a 55                	push   $0x55
  jmp __alltraps
  102124:	e9 e6 fc ff ff       	jmp    101e0f <__alltraps>

00102129 <vector86>:
.globl vector86
vector86:
  pushl $0
  102129:	6a 00                	push   $0x0
  pushl $86
  10212b:	6a 56                	push   $0x56
  jmp __alltraps
  10212d:	e9 dd fc ff ff       	jmp    101e0f <__alltraps>

00102132 <vector87>:
.globl vector87
vector87:
  pushl $0
  102132:	6a 00                	push   $0x0
  pushl $87
  102134:	6a 57                	push   $0x57
  jmp __alltraps
  102136:	e9 d4 fc ff ff       	jmp    101e0f <__alltraps>

0010213b <vector88>:
.globl vector88
vector88:
  pushl $0
  10213b:	6a 00                	push   $0x0
  pushl $88
  10213d:	6a 58                	push   $0x58
  jmp __alltraps
  10213f:	e9 cb fc ff ff       	jmp    101e0f <__alltraps>

00102144 <vector89>:
.globl vector89
vector89:
  pushl $0
  102144:	6a 00                	push   $0x0
  pushl $89
  102146:	6a 59                	push   $0x59
  jmp __alltraps
  102148:	e9 c2 fc ff ff       	jmp    101e0f <__alltraps>

0010214d <vector90>:
.globl vector90
vector90:
  pushl $0
  10214d:	6a 00                	push   $0x0
  pushl $90
  10214f:	6a 5a                	push   $0x5a
  jmp __alltraps
  102151:	e9 b9 fc ff ff       	jmp    101e0f <__alltraps>

00102156 <vector91>:
.globl vector91
vector91:
  pushl $0
  102156:	6a 00                	push   $0x0
  pushl $91
  102158:	6a 5b                	push   $0x5b
  jmp __alltraps
  10215a:	e9 b0 fc ff ff       	jmp    101e0f <__alltraps>

0010215f <vector92>:
.globl vector92
vector92:
  pushl $0
  10215f:	6a 00                	push   $0x0
  pushl $92
  102161:	6a 5c                	push   $0x5c
  jmp __alltraps
  102163:	e9 a7 fc ff ff       	jmp    101e0f <__alltraps>

00102168 <vector93>:
.globl vector93
vector93:
  pushl $0
  102168:	6a 00                	push   $0x0
  pushl $93
  10216a:	6a 5d                	push   $0x5d
  jmp __alltraps
  10216c:	e9 9e fc ff ff       	jmp    101e0f <__alltraps>

00102171 <vector94>:
.globl vector94
vector94:
  pushl $0
  102171:	6a 00                	push   $0x0
  pushl $94
  102173:	6a 5e                	push   $0x5e
  jmp __alltraps
  102175:	e9 95 fc ff ff       	jmp    101e0f <__alltraps>

0010217a <vector95>:
.globl vector95
vector95:
  pushl $0
  10217a:	6a 00                	push   $0x0
  pushl $95
  10217c:	6a 5f                	push   $0x5f
  jmp __alltraps
  10217e:	e9 8c fc ff ff       	jmp    101e0f <__alltraps>

00102183 <vector96>:
.globl vector96
vector96:
  pushl $0
  102183:	6a 00                	push   $0x0
  pushl $96
  102185:	6a 60                	push   $0x60
  jmp __alltraps
  102187:	e9 83 fc ff ff       	jmp    101e0f <__alltraps>

0010218c <vector97>:
.globl vector97
vector97:
  pushl $0
  10218c:	6a 00                	push   $0x0
  pushl $97
  10218e:	6a 61                	push   $0x61
  jmp __alltraps
  102190:	e9 7a fc ff ff       	jmp    101e0f <__alltraps>

00102195 <vector98>:
.globl vector98
vector98:
  pushl $0
  102195:	6a 00                	push   $0x0
  pushl $98
  102197:	6a 62                	push   $0x62
  jmp __alltraps
  102199:	e9 71 fc ff ff       	jmp    101e0f <__alltraps>

0010219e <vector99>:
.globl vector99
vector99:
  pushl $0
  10219e:	6a 00                	push   $0x0
  pushl $99
  1021a0:	6a 63                	push   $0x63
  jmp __alltraps
  1021a2:	e9 68 fc ff ff       	jmp    101e0f <__alltraps>

001021a7 <vector100>:
.globl vector100
vector100:
  pushl $0
  1021a7:	6a 00                	push   $0x0
  pushl $100
  1021a9:	6a 64                	push   $0x64
  jmp __alltraps
  1021ab:	e9 5f fc ff ff       	jmp    101e0f <__alltraps>

001021b0 <vector101>:
.globl vector101
vector101:
  pushl $0
  1021b0:	6a 00                	push   $0x0
  pushl $101
  1021b2:	6a 65                	push   $0x65
  jmp __alltraps
  1021b4:	e9 56 fc ff ff       	jmp    101e0f <__alltraps>

001021b9 <vector102>:
.globl vector102
vector102:
  pushl $0
  1021b9:	6a 00                	push   $0x0
  pushl $102
  1021bb:	6a 66                	push   $0x66
  jmp __alltraps
  1021bd:	e9 4d fc ff ff       	jmp    101e0f <__alltraps>

001021c2 <vector103>:
.globl vector103
vector103:
  pushl $0
  1021c2:	6a 00                	push   $0x0
  pushl $103
  1021c4:	6a 67                	push   $0x67
  jmp __alltraps
  1021c6:	e9 44 fc ff ff       	jmp    101e0f <__alltraps>

001021cb <vector104>:
.globl vector104
vector104:
  pushl $0
  1021cb:	6a 00                	push   $0x0
  pushl $104
  1021cd:	6a 68                	push   $0x68
  jmp __alltraps
  1021cf:	e9 3b fc ff ff       	jmp    101e0f <__alltraps>

001021d4 <vector105>:
.globl vector105
vector105:
  pushl $0
  1021d4:	6a 00                	push   $0x0
  pushl $105
  1021d6:	6a 69                	push   $0x69
  jmp __alltraps
  1021d8:	e9 32 fc ff ff       	jmp    101e0f <__alltraps>

001021dd <vector106>:
.globl vector106
vector106:
  pushl $0
  1021dd:	6a 00                	push   $0x0
  pushl $106
  1021df:	6a 6a                	push   $0x6a
  jmp __alltraps
  1021e1:	e9 29 fc ff ff       	jmp    101e0f <__alltraps>

001021e6 <vector107>:
.globl vector107
vector107:
  pushl $0
  1021e6:	6a 00                	push   $0x0
  pushl $107
  1021e8:	6a 6b                	push   $0x6b
  jmp __alltraps
  1021ea:	e9 20 fc ff ff       	jmp    101e0f <__alltraps>

001021ef <vector108>:
.globl vector108
vector108:
  pushl $0
  1021ef:	6a 00                	push   $0x0
  pushl $108
  1021f1:	6a 6c                	push   $0x6c
  jmp __alltraps
  1021f3:	e9 17 fc ff ff       	jmp    101e0f <__alltraps>

001021f8 <vector109>:
.globl vector109
vector109:
  pushl $0
  1021f8:	6a 00                	push   $0x0
  pushl $109
  1021fa:	6a 6d                	push   $0x6d
  jmp __alltraps
  1021fc:	e9 0e fc ff ff       	jmp    101e0f <__alltraps>

00102201 <vector110>:
.globl vector110
vector110:
  pushl $0
  102201:	6a 00                	push   $0x0
  pushl $110
  102203:	6a 6e                	push   $0x6e
  jmp __alltraps
  102205:	e9 05 fc ff ff       	jmp    101e0f <__alltraps>

0010220a <vector111>:
.globl vector111
vector111:
  pushl $0
  10220a:	6a 00                	push   $0x0
  pushl $111
  10220c:	6a 6f                	push   $0x6f
  jmp __alltraps
  10220e:	e9 fc fb ff ff       	jmp    101e0f <__alltraps>

00102213 <vector112>:
.globl vector112
vector112:
  pushl $0
  102213:	6a 00                	push   $0x0
  pushl $112
  102215:	6a 70                	push   $0x70
  jmp __alltraps
  102217:	e9 f3 fb ff ff       	jmp    101e0f <__alltraps>

0010221c <vector113>:
.globl vector113
vector113:
  pushl $0
  10221c:	6a 00                	push   $0x0
  pushl $113
  10221e:	6a 71                	push   $0x71
  jmp __alltraps
  102220:	e9 ea fb ff ff       	jmp    101e0f <__alltraps>

00102225 <vector114>:
.globl vector114
vector114:
  pushl $0
  102225:	6a 00                	push   $0x0
  pushl $114
  102227:	6a 72                	push   $0x72
  jmp __alltraps
  102229:	e9 e1 fb ff ff       	jmp    101e0f <__alltraps>

0010222e <vector115>:
.globl vector115
vector115:
  pushl $0
  10222e:	6a 00                	push   $0x0
  pushl $115
  102230:	6a 73                	push   $0x73
  jmp __alltraps
  102232:	e9 d8 fb ff ff       	jmp    101e0f <__alltraps>

00102237 <vector116>:
.globl vector116
vector116:
  pushl $0
  102237:	6a 00                	push   $0x0
  pushl $116
  102239:	6a 74                	push   $0x74
  jmp __alltraps
  10223b:	e9 cf fb ff ff       	jmp    101e0f <__alltraps>

00102240 <vector117>:
.globl vector117
vector117:
  pushl $0
  102240:	6a 00                	push   $0x0
  pushl $117
  102242:	6a 75                	push   $0x75
  jmp __alltraps
  102244:	e9 c6 fb ff ff       	jmp    101e0f <__alltraps>

00102249 <vector118>:
.globl vector118
vector118:
  pushl $0
  102249:	6a 00                	push   $0x0
  pushl $118
  10224b:	6a 76                	push   $0x76
  jmp __alltraps
  10224d:	e9 bd fb ff ff       	jmp    101e0f <__alltraps>

00102252 <vector119>:
.globl vector119
vector119:
  pushl $0
  102252:	6a 00                	push   $0x0
  pushl $119
  102254:	6a 77                	push   $0x77
  jmp __alltraps
  102256:	e9 b4 fb ff ff       	jmp    101e0f <__alltraps>

0010225b <vector120>:
.globl vector120
vector120:
  pushl $0
  10225b:	6a 00                	push   $0x0
  pushl $120
  10225d:	6a 78                	push   $0x78
  jmp __alltraps
  10225f:	e9 ab fb ff ff       	jmp    101e0f <__alltraps>

00102264 <vector121>:
.globl vector121
vector121:
  pushl $0
  102264:	6a 00                	push   $0x0
  pushl $121
  102266:	6a 79                	push   $0x79
  jmp __alltraps
  102268:	e9 a2 fb ff ff       	jmp    101e0f <__alltraps>

0010226d <vector122>:
.globl vector122
vector122:
  pushl $0
  10226d:	6a 00                	push   $0x0
  pushl $122
  10226f:	6a 7a                	push   $0x7a
  jmp __alltraps
  102271:	e9 99 fb ff ff       	jmp    101e0f <__alltraps>

00102276 <vector123>:
.globl vector123
vector123:
  pushl $0
  102276:	6a 00                	push   $0x0
  pushl $123
  102278:	6a 7b                	push   $0x7b
  jmp __alltraps
  10227a:	e9 90 fb ff ff       	jmp    101e0f <__alltraps>

0010227f <vector124>:
.globl vector124
vector124:
  pushl $0
  10227f:	6a 00                	push   $0x0
  pushl $124
  102281:	6a 7c                	push   $0x7c
  jmp __alltraps
  102283:	e9 87 fb ff ff       	jmp    101e0f <__alltraps>

00102288 <vector125>:
.globl vector125
vector125:
  pushl $0
  102288:	6a 00                	push   $0x0
  pushl $125
  10228a:	6a 7d                	push   $0x7d
  jmp __alltraps
  10228c:	e9 7e fb ff ff       	jmp    101e0f <__alltraps>

00102291 <vector126>:
.globl vector126
vector126:
  pushl $0
  102291:	6a 00                	push   $0x0
  pushl $126
  102293:	6a 7e                	push   $0x7e
  jmp __alltraps
  102295:	e9 75 fb ff ff       	jmp    101e0f <__alltraps>

0010229a <vector127>:
.globl vector127
vector127:
  pushl $0
  10229a:	6a 00                	push   $0x0
  pushl $127
  10229c:	6a 7f                	push   $0x7f
  jmp __alltraps
  10229e:	e9 6c fb ff ff       	jmp    101e0f <__alltraps>

001022a3 <vector128>:
.globl vector128
vector128:
  pushl $0
  1022a3:	6a 00                	push   $0x0
  pushl $128
  1022a5:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1022aa:	e9 60 fb ff ff       	jmp    101e0f <__alltraps>

001022af <vector129>:
.globl vector129
vector129:
  pushl $0
  1022af:	6a 00                	push   $0x0
  pushl $129
  1022b1:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1022b6:	e9 54 fb ff ff       	jmp    101e0f <__alltraps>

001022bb <vector130>:
.globl vector130
vector130:
  pushl $0
  1022bb:	6a 00                	push   $0x0
  pushl $130
  1022bd:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1022c2:	e9 48 fb ff ff       	jmp    101e0f <__alltraps>

001022c7 <vector131>:
.globl vector131
vector131:
  pushl $0
  1022c7:	6a 00                	push   $0x0
  pushl $131
  1022c9:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1022ce:	e9 3c fb ff ff       	jmp    101e0f <__alltraps>

001022d3 <vector132>:
.globl vector132
vector132:
  pushl $0
  1022d3:	6a 00                	push   $0x0
  pushl $132
  1022d5:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1022da:	e9 30 fb ff ff       	jmp    101e0f <__alltraps>

001022df <vector133>:
.globl vector133
vector133:
  pushl $0
  1022df:	6a 00                	push   $0x0
  pushl $133
  1022e1:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1022e6:	e9 24 fb ff ff       	jmp    101e0f <__alltraps>

001022eb <vector134>:
.globl vector134
vector134:
  pushl $0
  1022eb:	6a 00                	push   $0x0
  pushl $134
  1022ed:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1022f2:	e9 18 fb ff ff       	jmp    101e0f <__alltraps>

001022f7 <vector135>:
.globl vector135
vector135:
  pushl $0
  1022f7:	6a 00                	push   $0x0
  pushl $135
  1022f9:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1022fe:	e9 0c fb ff ff       	jmp    101e0f <__alltraps>

00102303 <vector136>:
.globl vector136
vector136:
  pushl $0
  102303:	6a 00                	push   $0x0
  pushl $136
  102305:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10230a:	e9 00 fb ff ff       	jmp    101e0f <__alltraps>

0010230f <vector137>:
.globl vector137
vector137:
  pushl $0
  10230f:	6a 00                	push   $0x0
  pushl $137
  102311:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102316:	e9 f4 fa ff ff       	jmp    101e0f <__alltraps>

0010231b <vector138>:
.globl vector138
vector138:
  pushl $0
  10231b:	6a 00                	push   $0x0
  pushl $138
  10231d:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102322:	e9 e8 fa ff ff       	jmp    101e0f <__alltraps>

00102327 <vector139>:
.globl vector139
vector139:
  pushl $0
  102327:	6a 00                	push   $0x0
  pushl $139
  102329:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  10232e:	e9 dc fa ff ff       	jmp    101e0f <__alltraps>

00102333 <vector140>:
.globl vector140
vector140:
  pushl $0
  102333:	6a 00                	push   $0x0
  pushl $140
  102335:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10233a:	e9 d0 fa ff ff       	jmp    101e0f <__alltraps>

0010233f <vector141>:
.globl vector141
vector141:
  pushl $0
  10233f:	6a 00                	push   $0x0
  pushl $141
  102341:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102346:	e9 c4 fa ff ff       	jmp    101e0f <__alltraps>

0010234b <vector142>:
.globl vector142
vector142:
  pushl $0
  10234b:	6a 00                	push   $0x0
  pushl $142
  10234d:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102352:	e9 b8 fa ff ff       	jmp    101e0f <__alltraps>

00102357 <vector143>:
.globl vector143
vector143:
  pushl $0
  102357:	6a 00                	push   $0x0
  pushl $143
  102359:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10235e:	e9 ac fa ff ff       	jmp    101e0f <__alltraps>

00102363 <vector144>:
.globl vector144
vector144:
  pushl $0
  102363:	6a 00                	push   $0x0
  pushl $144
  102365:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10236a:	e9 a0 fa ff ff       	jmp    101e0f <__alltraps>

0010236f <vector145>:
.globl vector145
vector145:
  pushl $0
  10236f:	6a 00                	push   $0x0
  pushl $145
  102371:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102376:	e9 94 fa ff ff       	jmp    101e0f <__alltraps>

0010237b <vector146>:
.globl vector146
vector146:
  pushl $0
  10237b:	6a 00                	push   $0x0
  pushl $146
  10237d:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102382:	e9 88 fa ff ff       	jmp    101e0f <__alltraps>

00102387 <vector147>:
.globl vector147
vector147:
  pushl $0
  102387:	6a 00                	push   $0x0
  pushl $147
  102389:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10238e:	e9 7c fa ff ff       	jmp    101e0f <__alltraps>

00102393 <vector148>:
.globl vector148
vector148:
  pushl $0
  102393:	6a 00                	push   $0x0
  pushl $148
  102395:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10239a:	e9 70 fa ff ff       	jmp    101e0f <__alltraps>

0010239f <vector149>:
.globl vector149
vector149:
  pushl $0
  10239f:	6a 00                	push   $0x0
  pushl $149
  1023a1:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1023a6:	e9 64 fa ff ff       	jmp    101e0f <__alltraps>

001023ab <vector150>:
.globl vector150
vector150:
  pushl $0
  1023ab:	6a 00                	push   $0x0
  pushl $150
  1023ad:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1023b2:	e9 58 fa ff ff       	jmp    101e0f <__alltraps>

001023b7 <vector151>:
.globl vector151
vector151:
  pushl $0
  1023b7:	6a 00                	push   $0x0
  pushl $151
  1023b9:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1023be:	e9 4c fa ff ff       	jmp    101e0f <__alltraps>

001023c3 <vector152>:
.globl vector152
vector152:
  pushl $0
  1023c3:	6a 00                	push   $0x0
  pushl $152
  1023c5:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1023ca:	e9 40 fa ff ff       	jmp    101e0f <__alltraps>

001023cf <vector153>:
.globl vector153
vector153:
  pushl $0
  1023cf:	6a 00                	push   $0x0
  pushl $153
  1023d1:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1023d6:	e9 34 fa ff ff       	jmp    101e0f <__alltraps>

001023db <vector154>:
.globl vector154
vector154:
  pushl $0
  1023db:	6a 00                	push   $0x0
  pushl $154
  1023dd:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1023e2:	e9 28 fa ff ff       	jmp    101e0f <__alltraps>

001023e7 <vector155>:
.globl vector155
vector155:
  pushl $0
  1023e7:	6a 00                	push   $0x0
  pushl $155
  1023e9:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1023ee:	e9 1c fa ff ff       	jmp    101e0f <__alltraps>

001023f3 <vector156>:
.globl vector156
vector156:
  pushl $0
  1023f3:	6a 00                	push   $0x0
  pushl $156
  1023f5:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1023fa:	e9 10 fa ff ff       	jmp    101e0f <__alltraps>

001023ff <vector157>:
.globl vector157
vector157:
  pushl $0
  1023ff:	6a 00                	push   $0x0
  pushl $157
  102401:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102406:	e9 04 fa ff ff       	jmp    101e0f <__alltraps>

0010240b <vector158>:
.globl vector158
vector158:
  pushl $0
  10240b:	6a 00                	push   $0x0
  pushl $158
  10240d:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102412:	e9 f8 f9 ff ff       	jmp    101e0f <__alltraps>

00102417 <vector159>:
.globl vector159
vector159:
  pushl $0
  102417:	6a 00                	push   $0x0
  pushl $159
  102419:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10241e:	e9 ec f9 ff ff       	jmp    101e0f <__alltraps>

00102423 <vector160>:
.globl vector160
vector160:
  pushl $0
  102423:	6a 00                	push   $0x0
  pushl $160
  102425:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10242a:	e9 e0 f9 ff ff       	jmp    101e0f <__alltraps>

0010242f <vector161>:
.globl vector161
vector161:
  pushl $0
  10242f:	6a 00                	push   $0x0
  pushl $161
  102431:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102436:	e9 d4 f9 ff ff       	jmp    101e0f <__alltraps>

0010243b <vector162>:
.globl vector162
vector162:
  pushl $0
  10243b:	6a 00                	push   $0x0
  pushl $162
  10243d:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102442:	e9 c8 f9 ff ff       	jmp    101e0f <__alltraps>

00102447 <vector163>:
.globl vector163
vector163:
  pushl $0
  102447:	6a 00                	push   $0x0
  pushl $163
  102449:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  10244e:	e9 bc f9 ff ff       	jmp    101e0f <__alltraps>

00102453 <vector164>:
.globl vector164
vector164:
  pushl $0
  102453:	6a 00                	push   $0x0
  pushl $164
  102455:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10245a:	e9 b0 f9 ff ff       	jmp    101e0f <__alltraps>

0010245f <vector165>:
.globl vector165
vector165:
  pushl $0
  10245f:	6a 00                	push   $0x0
  pushl $165
  102461:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102466:	e9 a4 f9 ff ff       	jmp    101e0f <__alltraps>

0010246b <vector166>:
.globl vector166
vector166:
  pushl $0
  10246b:	6a 00                	push   $0x0
  pushl $166
  10246d:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102472:	e9 98 f9 ff ff       	jmp    101e0f <__alltraps>

00102477 <vector167>:
.globl vector167
vector167:
  pushl $0
  102477:	6a 00                	push   $0x0
  pushl $167
  102479:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10247e:	e9 8c f9 ff ff       	jmp    101e0f <__alltraps>

00102483 <vector168>:
.globl vector168
vector168:
  pushl $0
  102483:	6a 00                	push   $0x0
  pushl $168
  102485:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10248a:	e9 80 f9 ff ff       	jmp    101e0f <__alltraps>

0010248f <vector169>:
.globl vector169
vector169:
  pushl $0
  10248f:	6a 00                	push   $0x0
  pushl $169
  102491:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102496:	e9 74 f9 ff ff       	jmp    101e0f <__alltraps>

0010249b <vector170>:
.globl vector170
vector170:
  pushl $0
  10249b:	6a 00                	push   $0x0
  pushl $170
  10249d:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1024a2:	e9 68 f9 ff ff       	jmp    101e0f <__alltraps>

001024a7 <vector171>:
.globl vector171
vector171:
  pushl $0
  1024a7:	6a 00                	push   $0x0
  pushl $171
  1024a9:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1024ae:	e9 5c f9 ff ff       	jmp    101e0f <__alltraps>

001024b3 <vector172>:
.globl vector172
vector172:
  pushl $0
  1024b3:	6a 00                	push   $0x0
  pushl $172
  1024b5:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1024ba:	e9 50 f9 ff ff       	jmp    101e0f <__alltraps>

001024bf <vector173>:
.globl vector173
vector173:
  pushl $0
  1024bf:	6a 00                	push   $0x0
  pushl $173
  1024c1:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1024c6:	e9 44 f9 ff ff       	jmp    101e0f <__alltraps>

001024cb <vector174>:
.globl vector174
vector174:
  pushl $0
  1024cb:	6a 00                	push   $0x0
  pushl $174
  1024cd:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1024d2:	e9 38 f9 ff ff       	jmp    101e0f <__alltraps>

001024d7 <vector175>:
.globl vector175
vector175:
  pushl $0
  1024d7:	6a 00                	push   $0x0
  pushl $175
  1024d9:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1024de:	e9 2c f9 ff ff       	jmp    101e0f <__alltraps>

001024e3 <vector176>:
.globl vector176
vector176:
  pushl $0
  1024e3:	6a 00                	push   $0x0
  pushl $176
  1024e5:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1024ea:	e9 20 f9 ff ff       	jmp    101e0f <__alltraps>

001024ef <vector177>:
.globl vector177
vector177:
  pushl $0
  1024ef:	6a 00                	push   $0x0
  pushl $177
  1024f1:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1024f6:	e9 14 f9 ff ff       	jmp    101e0f <__alltraps>

001024fb <vector178>:
.globl vector178
vector178:
  pushl $0
  1024fb:	6a 00                	push   $0x0
  pushl $178
  1024fd:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102502:	e9 08 f9 ff ff       	jmp    101e0f <__alltraps>

00102507 <vector179>:
.globl vector179
vector179:
  pushl $0
  102507:	6a 00                	push   $0x0
  pushl $179
  102509:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10250e:	e9 fc f8 ff ff       	jmp    101e0f <__alltraps>

00102513 <vector180>:
.globl vector180
vector180:
  pushl $0
  102513:	6a 00                	push   $0x0
  pushl $180
  102515:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10251a:	e9 f0 f8 ff ff       	jmp    101e0f <__alltraps>

0010251f <vector181>:
.globl vector181
vector181:
  pushl $0
  10251f:	6a 00                	push   $0x0
  pushl $181
  102521:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102526:	e9 e4 f8 ff ff       	jmp    101e0f <__alltraps>

0010252b <vector182>:
.globl vector182
vector182:
  pushl $0
  10252b:	6a 00                	push   $0x0
  pushl $182
  10252d:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102532:	e9 d8 f8 ff ff       	jmp    101e0f <__alltraps>

00102537 <vector183>:
.globl vector183
vector183:
  pushl $0
  102537:	6a 00                	push   $0x0
  pushl $183
  102539:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  10253e:	e9 cc f8 ff ff       	jmp    101e0f <__alltraps>

00102543 <vector184>:
.globl vector184
vector184:
  pushl $0
  102543:	6a 00                	push   $0x0
  pushl $184
  102545:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10254a:	e9 c0 f8 ff ff       	jmp    101e0f <__alltraps>

0010254f <vector185>:
.globl vector185
vector185:
  pushl $0
  10254f:	6a 00                	push   $0x0
  pushl $185
  102551:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102556:	e9 b4 f8 ff ff       	jmp    101e0f <__alltraps>

0010255b <vector186>:
.globl vector186
vector186:
  pushl $0
  10255b:	6a 00                	push   $0x0
  pushl $186
  10255d:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102562:	e9 a8 f8 ff ff       	jmp    101e0f <__alltraps>

00102567 <vector187>:
.globl vector187
vector187:
  pushl $0
  102567:	6a 00                	push   $0x0
  pushl $187
  102569:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10256e:	e9 9c f8 ff ff       	jmp    101e0f <__alltraps>

00102573 <vector188>:
.globl vector188
vector188:
  pushl $0
  102573:	6a 00                	push   $0x0
  pushl $188
  102575:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  10257a:	e9 90 f8 ff ff       	jmp    101e0f <__alltraps>

0010257f <vector189>:
.globl vector189
vector189:
  pushl $0
  10257f:	6a 00                	push   $0x0
  pushl $189
  102581:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102586:	e9 84 f8 ff ff       	jmp    101e0f <__alltraps>

0010258b <vector190>:
.globl vector190
vector190:
  pushl $0
  10258b:	6a 00                	push   $0x0
  pushl $190
  10258d:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102592:	e9 78 f8 ff ff       	jmp    101e0f <__alltraps>

00102597 <vector191>:
.globl vector191
vector191:
  pushl $0
  102597:	6a 00                	push   $0x0
  pushl $191
  102599:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10259e:	e9 6c f8 ff ff       	jmp    101e0f <__alltraps>

001025a3 <vector192>:
.globl vector192
vector192:
  pushl $0
  1025a3:	6a 00                	push   $0x0
  pushl $192
  1025a5:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1025aa:	e9 60 f8 ff ff       	jmp    101e0f <__alltraps>

001025af <vector193>:
.globl vector193
vector193:
  pushl $0
  1025af:	6a 00                	push   $0x0
  pushl $193
  1025b1:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1025b6:	e9 54 f8 ff ff       	jmp    101e0f <__alltraps>

001025bb <vector194>:
.globl vector194
vector194:
  pushl $0
  1025bb:	6a 00                	push   $0x0
  pushl $194
  1025bd:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1025c2:	e9 48 f8 ff ff       	jmp    101e0f <__alltraps>

001025c7 <vector195>:
.globl vector195
vector195:
  pushl $0
  1025c7:	6a 00                	push   $0x0
  pushl $195
  1025c9:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1025ce:	e9 3c f8 ff ff       	jmp    101e0f <__alltraps>

001025d3 <vector196>:
.globl vector196
vector196:
  pushl $0
  1025d3:	6a 00                	push   $0x0
  pushl $196
  1025d5:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1025da:	e9 30 f8 ff ff       	jmp    101e0f <__alltraps>

001025df <vector197>:
.globl vector197
vector197:
  pushl $0
  1025df:	6a 00                	push   $0x0
  pushl $197
  1025e1:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1025e6:	e9 24 f8 ff ff       	jmp    101e0f <__alltraps>

001025eb <vector198>:
.globl vector198
vector198:
  pushl $0
  1025eb:	6a 00                	push   $0x0
  pushl $198
  1025ed:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1025f2:	e9 18 f8 ff ff       	jmp    101e0f <__alltraps>

001025f7 <vector199>:
.globl vector199
vector199:
  pushl $0
  1025f7:	6a 00                	push   $0x0
  pushl $199
  1025f9:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1025fe:	e9 0c f8 ff ff       	jmp    101e0f <__alltraps>

00102603 <vector200>:
.globl vector200
vector200:
  pushl $0
  102603:	6a 00                	push   $0x0
  pushl $200
  102605:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10260a:	e9 00 f8 ff ff       	jmp    101e0f <__alltraps>

0010260f <vector201>:
.globl vector201
vector201:
  pushl $0
  10260f:	6a 00                	push   $0x0
  pushl $201
  102611:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102616:	e9 f4 f7 ff ff       	jmp    101e0f <__alltraps>

0010261b <vector202>:
.globl vector202
vector202:
  pushl $0
  10261b:	6a 00                	push   $0x0
  pushl $202
  10261d:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102622:	e9 e8 f7 ff ff       	jmp    101e0f <__alltraps>

00102627 <vector203>:
.globl vector203
vector203:
  pushl $0
  102627:	6a 00                	push   $0x0
  pushl $203
  102629:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  10262e:	e9 dc f7 ff ff       	jmp    101e0f <__alltraps>

00102633 <vector204>:
.globl vector204
vector204:
  pushl $0
  102633:	6a 00                	push   $0x0
  pushl $204
  102635:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10263a:	e9 d0 f7 ff ff       	jmp    101e0f <__alltraps>

0010263f <vector205>:
.globl vector205
vector205:
  pushl $0
  10263f:	6a 00                	push   $0x0
  pushl $205
  102641:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102646:	e9 c4 f7 ff ff       	jmp    101e0f <__alltraps>

0010264b <vector206>:
.globl vector206
vector206:
  pushl $0
  10264b:	6a 00                	push   $0x0
  pushl $206
  10264d:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102652:	e9 b8 f7 ff ff       	jmp    101e0f <__alltraps>

00102657 <vector207>:
.globl vector207
vector207:
  pushl $0
  102657:	6a 00                	push   $0x0
  pushl $207
  102659:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  10265e:	e9 ac f7 ff ff       	jmp    101e0f <__alltraps>

00102663 <vector208>:
.globl vector208
vector208:
  pushl $0
  102663:	6a 00                	push   $0x0
  pushl $208
  102665:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  10266a:	e9 a0 f7 ff ff       	jmp    101e0f <__alltraps>

0010266f <vector209>:
.globl vector209
vector209:
  pushl $0
  10266f:	6a 00                	push   $0x0
  pushl $209
  102671:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102676:	e9 94 f7 ff ff       	jmp    101e0f <__alltraps>

0010267b <vector210>:
.globl vector210
vector210:
  pushl $0
  10267b:	6a 00                	push   $0x0
  pushl $210
  10267d:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102682:	e9 88 f7 ff ff       	jmp    101e0f <__alltraps>

00102687 <vector211>:
.globl vector211
vector211:
  pushl $0
  102687:	6a 00                	push   $0x0
  pushl $211
  102689:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10268e:	e9 7c f7 ff ff       	jmp    101e0f <__alltraps>

00102693 <vector212>:
.globl vector212
vector212:
  pushl $0
  102693:	6a 00                	push   $0x0
  pushl $212
  102695:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  10269a:	e9 70 f7 ff ff       	jmp    101e0f <__alltraps>

0010269f <vector213>:
.globl vector213
vector213:
  pushl $0
  10269f:	6a 00                	push   $0x0
  pushl $213
  1026a1:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1026a6:	e9 64 f7 ff ff       	jmp    101e0f <__alltraps>

001026ab <vector214>:
.globl vector214
vector214:
  pushl $0
  1026ab:	6a 00                	push   $0x0
  pushl $214
  1026ad:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1026b2:	e9 58 f7 ff ff       	jmp    101e0f <__alltraps>

001026b7 <vector215>:
.globl vector215
vector215:
  pushl $0
  1026b7:	6a 00                	push   $0x0
  pushl $215
  1026b9:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1026be:	e9 4c f7 ff ff       	jmp    101e0f <__alltraps>

001026c3 <vector216>:
.globl vector216
vector216:
  pushl $0
  1026c3:	6a 00                	push   $0x0
  pushl $216
  1026c5:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1026ca:	e9 40 f7 ff ff       	jmp    101e0f <__alltraps>

001026cf <vector217>:
.globl vector217
vector217:
  pushl $0
  1026cf:	6a 00                	push   $0x0
  pushl $217
  1026d1:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1026d6:	e9 34 f7 ff ff       	jmp    101e0f <__alltraps>

001026db <vector218>:
.globl vector218
vector218:
  pushl $0
  1026db:	6a 00                	push   $0x0
  pushl $218
  1026dd:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1026e2:	e9 28 f7 ff ff       	jmp    101e0f <__alltraps>

001026e7 <vector219>:
.globl vector219
vector219:
  pushl $0
  1026e7:	6a 00                	push   $0x0
  pushl $219
  1026e9:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1026ee:	e9 1c f7 ff ff       	jmp    101e0f <__alltraps>

001026f3 <vector220>:
.globl vector220
vector220:
  pushl $0
  1026f3:	6a 00                	push   $0x0
  pushl $220
  1026f5:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1026fa:	e9 10 f7 ff ff       	jmp    101e0f <__alltraps>

001026ff <vector221>:
.globl vector221
vector221:
  pushl $0
  1026ff:	6a 00                	push   $0x0
  pushl $221
  102701:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102706:	e9 04 f7 ff ff       	jmp    101e0f <__alltraps>

0010270b <vector222>:
.globl vector222
vector222:
  pushl $0
  10270b:	6a 00                	push   $0x0
  pushl $222
  10270d:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102712:	e9 f8 f6 ff ff       	jmp    101e0f <__alltraps>

00102717 <vector223>:
.globl vector223
vector223:
  pushl $0
  102717:	6a 00                	push   $0x0
  pushl $223
  102719:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  10271e:	e9 ec f6 ff ff       	jmp    101e0f <__alltraps>

00102723 <vector224>:
.globl vector224
vector224:
  pushl $0
  102723:	6a 00                	push   $0x0
  pushl $224
  102725:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10272a:	e9 e0 f6 ff ff       	jmp    101e0f <__alltraps>

0010272f <vector225>:
.globl vector225
vector225:
  pushl $0
  10272f:	6a 00                	push   $0x0
  pushl $225
  102731:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102736:	e9 d4 f6 ff ff       	jmp    101e0f <__alltraps>

0010273b <vector226>:
.globl vector226
vector226:
  pushl $0
  10273b:	6a 00                	push   $0x0
  pushl $226
  10273d:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102742:	e9 c8 f6 ff ff       	jmp    101e0f <__alltraps>

00102747 <vector227>:
.globl vector227
vector227:
  pushl $0
  102747:	6a 00                	push   $0x0
  pushl $227
  102749:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  10274e:	e9 bc f6 ff ff       	jmp    101e0f <__alltraps>

00102753 <vector228>:
.globl vector228
vector228:
  pushl $0
  102753:	6a 00                	push   $0x0
  pushl $228
  102755:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10275a:	e9 b0 f6 ff ff       	jmp    101e0f <__alltraps>

0010275f <vector229>:
.globl vector229
vector229:
  pushl $0
  10275f:	6a 00                	push   $0x0
  pushl $229
  102761:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102766:	e9 a4 f6 ff ff       	jmp    101e0f <__alltraps>

0010276b <vector230>:
.globl vector230
vector230:
  pushl $0
  10276b:	6a 00                	push   $0x0
  pushl $230
  10276d:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102772:	e9 98 f6 ff ff       	jmp    101e0f <__alltraps>

00102777 <vector231>:
.globl vector231
vector231:
  pushl $0
  102777:	6a 00                	push   $0x0
  pushl $231
  102779:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10277e:	e9 8c f6 ff ff       	jmp    101e0f <__alltraps>

00102783 <vector232>:
.globl vector232
vector232:
  pushl $0
  102783:	6a 00                	push   $0x0
  pushl $232
  102785:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  10278a:	e9 80 f6 ff ff       	jmp    101e0f <__alltraps>

0010278f <vector233>:
.globl vector233
vector233:
  pushl $0
  10278f:	6a 00                	push   $0x0
  pushl $233
  102791:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102796:	e9 74 f6 ff ff       	jmp    101e0f <__alltraps>

0010279b <vector234>:
.globl vector234
vector234:
  pushl $0
  10279b:	6a 00                	push   $0x0
  pushl $234
  10279d:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1027a2:	e9 68 f6 ff ff       	jmp    101e0f <__alltraps>

001027a7 <vector235>:
.globl vector235
vector235:
  pushl $0
  1027a7:	6a 00                	push   $0x0
  pushl $235
  1027a9:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1027ae:	e9 5c f6 ff ff       	jmp    101e0f <__alltraps>

001027b3 <vector236>:
.globl vector236
vector236:
  pushl $0
  1027b3:	6a 00                	push   $0x0
  pushl $236
  1027b5:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1027ba:	e9 50 f6 ff ff       	jmp    101e0f <__alltraps>

001027bf <vector237>:
.globl vector237
vector237:
  pushl $0
  1027bf:	6a 00                	push   $0x0
  pushl $237
  1027c1:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1027c6:	e9 44 f6 ff ff       	jmp    101e0f <__alltraps>

001027cb <vector238>:
.globl vector238
vector238:
  pushl $0
  1027cb:	6a 00                	push   $0x0
  pushl $238
  1027cd:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1027d2:	e9 38 f6 ff ff       	jmp    101e0f <__alltraps>

001027d7 <vector239>:
.globl vector239
vector239:
  pushl $0
  1027d7:	6a 00                	push   $0x0
  pushl $239
  1027d9:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1027de:	e9 2c f6 ff ff       	jmp    101e0f <__alltraps>

001027e3 <vector240>:
.globl vector240
vector240:
  pushl $0
  1027e3:	6a 00                	push   $0x0
  pushl $240
  1027e5:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1027ea:	e9 20 f6 ff ff       	jmp    101e0f <__alltraps>

001027ef <vector241>:
.globl vector241
vector241:
  pushl $0
  1027ef:	6a 00                	push   $0x0
  pushl $241
  1027f1:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1027f6:	e9 14 f6 ff ff       	jmp    101e0f <__alltraps>

001027fb <vector242>:
.globl vector242
vector242:
  pushl $0
  1027fb:	6a 00                	push   $0x0
  pushl $242
  1027fd:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102802:	e9 08 f6 ff ff       	jmp    101e0f <__alltraps>

00102807 <vector243>:
.globl vector243
vector243:
  pushl $0
  102807:	6a 00                	push   $0x0
  pushl $243
  102809:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10280e:	e9 fc f5 ff ff       	jmp    101e0f <__alltraps>

00102813 <vector244>:
.globl vector244
vector244:
  pushl $0
  102813:	6a 00                	push   $0x0
  pushl $244
  102815:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  10281a:	e9 f0 f5 ff ff       	jmp    101e0f <__alltraps>

0010281f <vector245>:
.globl vector245
vector245:
  pushl $0
  10281f:	6a 00                	push   $0x0
  pushl $245
  102821:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102826:	e9 e4 f5 ff ff       	jmp    101e0f <__alltraps>

0010282b <vector246>:
.globl vector246
vector246:
  pushl $0
  10282b:	6a 00                	push   $0x0
  pushl $246
  10282d:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102832:	e9 d8 f5 ff ff       	jmp    101e0f <__alltraps>

00102837 <vector247>:
.globl vector247
vector247:
  pushl $0
  102837:	6a 00                	push   $0x0
  pushl $247
  102839:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  10283e:	e9 cc f5 ff ff       	jmp    101e0f <__alltraps>

00102843 <vector248>:
.globl vector248
vector248:
  pushl $0
  102843:	6a 00                	push   $0x0
  pushl $248
  102845:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  10284a:	e9 c0 f5 ff ff       	jmp    101e0f <__alltraps>

0010284f <vector249>:
.globl vector249
vector249:
  pushl $0
  10284f:	6a 00                	push   $0x0
  pushl $249
  102851:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102856:	e9 b4 f5 ff ff       	jmp    101e0f <__alltraps>

0010285b <vector250>:
.globl vector250
vector250:
  pushl $0
  10285b:	6a 00                	push   $0x0
  pushl $250
  10285d:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102862:	e9 a8 f5 ff ff       	jmp    101e0f <__alltraps>

00102867 <vector251>:
.globl vector251
vector251:
  pushl $0
  102867:	6a 00                	push   $0x0
  pushl $251
  102869:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  10286e:	e9 9c f5 ff ff       	jmp    101e0f <__alltraps>

00102873 <vector252>:
.globl vector252
vector252:
  pushl $0
  102873:	6a 00                	push   $0x0
  pushl $252
  102875:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  10287a:	e9 90 f5 ff ff       	jmp    101e0f <__alltraps>

0010287f <vector253>:
.globl vector253
vector253:
  pushl $0
  10287f:	6a 00                	push   $0x0
  pushl $253
  102881:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102886:	e9 84 f5 ff ff       	jmp    101e0f <__alltraps>

0010288b <vector254>:
.globl vector254
vector254:
  pushl $0
  10288b:	6a 00                	push   $0x0
  pushl $254
  10288d:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102892:	e9 78 f5 ff ff       	jmp    101e0f <__alltraps>

00102897 <vector255>:
.globl vector255
vector255:
  pushl $0
  102897:	6a 00                	push   $0x0
  pushl $255
  102899:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  10289e:	e9 6c f5 ff ff       	jmp    101e0f <__alltraps>

001028a3 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  1028a3:	55                   	push   %ebp
  1028a4:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  1028a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1028a9:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  1028ac:	b8 23 00 00 00       	mov    $0x23,%eax
  1028b1:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  1028b3:	b8 23 00 00 00       	mov    $0x23,%eax
  1028b8:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  1028ba:	b8 10 00 00 00       	mov    $0x10,%eax
  1028bf:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  1028c1:	b8 10 00 00 00       	mov    $0x10,%eax
  1028c6:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  1028c8:	b8 10 00 00 00       	mov    $0x10,%eax
  1028cd:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  1028cf:	ea d6 28 10 00 08 00 	ljmp   $0x8,$0x1028d6
}
  1028d6:	90                   	nop
  1028d7:	5d                   	pop    %ebp
  1028d8:	c3                   	ret    

001028d9 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  1028d9:	55                   	push   %ebp
  1028da:	89 e5                	mov    %esp,%ebp
  1028dc:	83 ec 10             	sub    $0x10,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  1028df:	b8 20 09 11 00       	mov    $0x110920,%eax
  1028e4:	05 00 04 00 00       	add    $0x400,%eax
  1028e9:	a3 a4 08 11 00       	mov    %eax,0x1108a4
    ts.ts_ss0 = KERNEL_DS;
  1028ee:	66 c7 05 a8 08 11 00 	movw   $0x10,0x1108a8
  1028f5:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  1028f7:	66 c7 05 08 fa 10 00 	movw   $0x68,0x10fa08
  1028fe:	68 00 
  102900:	b8 a0 08 11 00       	mov    $0x1108a0,%eax
  102905:	66 a3 0a fa 10 00    	mov    %ax,0x10fa0a
  10290b:	b8 a0 08 11 00       	mov    $0x1108a0,%eax
  102910:	c1 e8 10             	shr    $0x10,%eax
  102913:	a2 0c fa 10 00       	mov    %al,0x10fa0c
  102918:	a0 0d fa 10 00       	mov    0x10fa0d,%al
  10291d:	83 e0 f0             	and    $0xfffffff0,%eax
  102920:	83 c8 09             	or     $0x9,%eax
  102923:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102928:	a0 0d fa 10 00       	mov    0x10fa0d,%al
  10292d:	83 c8 10             	or     $0x10,%eax
  102930:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102935:	a0 0d fa 10 00       	mov    0x10fa0d,%al
  10293a:	83 e0 9f             	and    $0xffffff9f,%eax
  10293d:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102942:	a0 0d fa 10 00       	mov    0x10fa0d,%al
  102947:	83 c8 80             	or     $0xffffff80,%eax
  10294a:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  10294f:	a0 0e fa 10 00       	mov    0x10fa0e,%al
  102954:	83 e0 f0             	and    $0xfffffff0,%eax
  102957:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  10295c:	a0 0e fa 10 00       	mov    0x10fa0e,%al
  102961:	83 e0 ef             	and    $0xffffffef,%eax
  102964:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102969:	a0 0e fa 10 00       	mov    0x10fa0e,%al
  10296e:	83 e0 df             	and    $0xffffffdf,%eax
  102971:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102976:	a0 0e fa 10 00       	mov    0x10fa0e,%al
  10297b:	83 c8 40             	or     $0x40,%eax
  10297e:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102983:	a0 0e fa 10 00       	mov    0x10fa0e,%al
  102988:	83 e0 7f             	and    $0x7f,%eax
  10298b:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102990:	b8 a0 08 11 00       	mov    $0x1108a0,%eax
  102995:	c1 e8 18             	shr    $0x18,%eax
  102998:	a2 0f fa 10 00       	mov    %al,0x10fa0f
    gdt[SEG_TSS].sd_s = 0;
  10299d:	a0 0d fa 10 00       	mov    0x10fa0d,%al
  1029a2:	83 e0 ef             	and    $0xffffffef,%eax
  1029a5:	a2 0d fa 10 00       	mov    %al,0x10fa0d

    // reload all segment registers
    lgdt(&gdt_pd);
  1029aa:	68 10 fa 10 00       	push   $0x10fa10
  1029af:	e8 ef fe ff ff       	call   1028a3 <lgdt>
  1029b4:	83 c4 04             	add    $0x4,%esp
  1029b7:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  1029bd:	66 8b 45 fe          	mov    -0x2(%ebp),%ax
  1029c1:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  1029c4:	90                   	nop
  1029c5:	c9                   	leave  
  1029c6:	c3                   	ret    

001029c7 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  1029c7:	55                   	push   %ebp
  1029c8:	89 e5                	mov    %esp,%ebp
    gdt_init();
  1029ca:	e8 0a ff ff ff       	call   1028d9 <gdt_init>
}
  1029cf:	90                   	nop
  1029d0:	5d                   	pop    %ebp
  1029d1:	c3                   	ret    

001029d2 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1029d2:	55                   	push   %ebp
  1029d3:	89 e5                	mov    %esp,%ebp
  1029d5:	83 ec 38             	sub    $0x38,%esp
  1029d8:	8b 45 10             	mov    0x10(%ebp),%eax
  1029db:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1029de:	8b 45 14             	mov    0x14(%ebp),%eax
  1029e1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1029e4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1029e7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1029ea:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1029ed:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1029f0:	8b 45 18             	mov    0x18(%ebp),%eax
  1029f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1029f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1029f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1029fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1029ff:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102a02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102a08:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102a0c:	74 1c                	je     102a2a <printnum+0x58>
  102a0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a11:	ba 00 00 00 00       	mov    $0x0,%edx
  102a16:	f7 75 e4             	divl   -0x1c(%ebp)
  102a19:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102a1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a1f:	ba 00 00 00 00       	mov    $0x0,%edx
  102a24:	f7 75 e4             	divl   -0x1c(%ebp)
  102a27:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102a2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102a2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102a30:	f7 75 e4             	divl   -0x1c(%ebp)
  102a33:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102a36:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102a39:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102a3c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102a3f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102a42:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102a45:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102a48:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102a4b:	8b 45 18             	mov    0x18(%ebp),%eax
  102a4e:	ba 00 00 00 00       	mov    $0x0,%edx
  102a53:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  102a56:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  102a59:	19 d1                	sbb    %edx,%ecx
  102a5b:	72 35                	jb     102a92 <printnum+0xc0>
        printnum(putch, putdat, result, base, width - 1, padc);
  102a5d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102a60:	48                   	dec    %eax
  102a61:	83 ec 04             	sub    $0x4,%esp
  102a64:	ff 75 20             	pushl  0x20(%ebp)
  102a67:	50                   	push   %eax
  102a68:	ff 75 18             	pushl  0x18(%ebp)
  102a6b:	ff 75 ec             	pushl  -0x14(%ebp)
  102a6e:	ff 75 e8             	pushl  -0x18(%ebp)
  102a71:	ff 75 0c             	pushl  0xc(%ebp)
  102a74:	ff 75 08             	pushl  0x8(%ebp)
  102a77:	e8 56 ff ff ff       	call   1029d2 <printnum>
  102a7c:	83 c4 20             	add    $0x20,%esp
  102a7f:	eb 1a                	jmp    102a9b <printnum+0xc9>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102a81:	83 ec 08             	sub    $0x8,%esp
  102a84:	ff 75 0c             	pushl  0xc(%ebp)
  102a87:	ff 75 20             	pushl  0x20(%ebp)
  102a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  102a8d:	ff d0                	call   *%eax
  102a8f:	83 c4 10             	add    $0x10,%esp
        while (-- width > 0)
  102a92:	ff 4d 1c             	decl   0x1c(%ebp)
  102a95:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102a99:	7f e6                	jg     102a81 <printnum+0xaf>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102a9b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102a9e:	05 30 3c 10 00       	add    $0x103c30,%eax
  102aa3:	8a 00                	mov    (%eax),%al
  102aa5:	0f be c0             	movsbl %al,%eax
  102aa8:	83 ec 08             	sub    $0x8,%esp
  102aab:	ff 75 0c             	pushl  0xc(%ebp)
  102aae:	50                   	push   %eax
  102aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  102ab2:	ff d0                	call   *%eax
  102ab4:	83 c4 10             	add    $0x10,%esp
}
  102ab7:	90                   	nop
  102ab8:	c9                   	leave  
  102ab9:	c3                   	ret    

00102aba <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102aba:	55                   	push   %ebp
  102abb:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102abd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102ac1:	7e 14                	jle    102ad7 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  102ac6:	8b 00                	mov    (%eax),%eax
  102ac8:	8d 48 08             	lea    0x8(%eax),%ecx
  102acb:	8b 55 08             	mov    0x8(%ebp),%edx
  102ace:	89 0a                	mov    %ecx,(%edx)
  102ad0:	8b 50 04             	mov    0x4(%eax),%edx
  102ad3:	8b 00                	mov    (%eax),%eax
  102ad5:	eb 30                	jmp    102b07 <getuint+0x4d>
    }
    else if (lflag) {
  102ad7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102adb:	74 16                	je     102af3 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102add:	8b 45 08             	mov    0x8(%ebp),%eax
  102ae0:	8b 00                	mov    (%eax),%eax
  102ae2:	8d 48 04             	lea    0x4(%eax),%ecx
  102ae5:	8b 55 08             	mov    0x8(%ebp),%edx
  102ae8:	89 0a                	mov    %ecx,(%edx)
  102aea:	8b 00                	mov    (%eax),%eax
  102aec:	ba 00 00 00 00       	mov    $0x0,%edx
  102af1:	eb 14                	jmp    102b07 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102af3:	8b 45 08             	mov    0x8(%ebp),%eax
  102af6:	8b 00                	mov    (%eax),%eax
  102af8:	8d 48 04             	lea    0x4(%eax),%ecx
  102afb:	8b 55 08             	mov    0x8(%ebp),%edx
  102afe:	89 0a                	mov    %ecx,(%edx)
  102b00:	8b 00                	mov    (%eax),%eax
  102b02:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102b07:	5d                   	pop    %ebp
  102b08:	c3                   	ret    

00102b09 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102b09:	55                   	push   %ebp
  102b0a:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102b0c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102b10:	7e 14                	jle    102b26 <getint+0x1d>
        return va_arg(*ap, long long);
  102b12:	8b 45 08             	mov    0x8(%ebp),%eax
  102b15:	8b 00                	mov    (%eax),%eax
  102b17:	8d 48 08             	lea    0x8(%eax),%ecx
  102b1a:	8b 55 08             	mov    0x8(%ebp),%edx
  102b1d:	89 0a                	mov    %ecx,(%edx)
  102b1f:	8b 50 04             	mov    0x4(%eax),%edx
  102b22:	8b 00                	mov    (%eax),%eax
  102b24:	eb 28                	jmp    102b4e <getint+0x45>
    }
    else if (lflag) {
  102b26:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102b2a:	74 12                	je     102b3e <getint+0x35>
        return va_arg(*ap, long);
  102b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  102b2f:	8b 00                	mov    (%eax),%eax
  102b31:	8d 48 04             	lea    0x4(%eax),%ecx
  102b34:	8b 55 08             	mov    0x8(%ebp),%edx
  102b37:	89 0a                	mov    %ecx,(%edx)
  102b39:	8b 00                	mov    (%eax),%eax
  102b3b:	99                   	cltd   
  102b3c:	eb 10                	jmp    102b4e <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  102b41:	8b 00                	mov    (%eax),%eax
  102b43:	8d 48 04             	lea    0x4(%eax),%ecx
  102b46:	8b 55 08             	mov    0x8(%ebp),%edx
  102b49:	89 0a                	mov    %ecx,(%edx)
  102b4b:	8b 00                	mov    (%eax),%eax
  102b4d:	99                   	cltd   
    }
}
  102b4e:	5d                   	pop    %ebp
  102b4f:	c3                   	ret    

00102b50 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102b50:	55                   	push   %ebp
  102b51:	89 e5                	mov    %esp,%ebp
  102b53:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  102b56:	8d 45 14             	lea    0x14(%ebp),%eax
  102b59:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b5f:	50                   	push   %eax
  102b60:	ff 75 10             	pushl  0x10(%ebp)
  102b63:	ff 75 0c             	pushl  0xc(%ebp)
  102b66:	ff 75 08             	pushl  0x8(%ebp)
  102b69:	e8 06 00 00 00       	call   102b74 <vprintfmt>
  102b6e:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  102b71:	90                   	nop
  102b72:	c9                   	leave  
  102b73:	c3                   	ret    

00102b74 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102b74:	55                   	push   %ebp
  102b75:	89 e5                	mov    %esp,%ebp
  102b77:	56                   	push   %esi
  102b78:	53                   	push   %ebx
  102b79:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102b7c:	eb 17                	jmp    102b95 <vprintfmt+0x21>
            if (ch == '\0') {
  102b7e:	85 db                	test   %ebx,%ebx
  102b80:	0f 84 7c 03 00 00    	je     102f02 <vprintfmt+0x38e>
                return;
            }
            putch(ch, putdat);
  102b86:	83 ec 08             	sub    $0x8,%esp
  102b89:	ff 75 0c             	pushl  0xc(%ebp)
  102b8c:	53                   	push   %ebx
  102b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  102b90:	ff d0                	call   *%eax
  102b92:	83 c4 10             	add    $0x10,%esp
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102b95:	8b 45 10             	mov    0x10(%ebp),%eax
  102b98:	8d 50 01             	lea    0x1(%eax),%edx
  102b9b:	89 55 10             	mov    %edx,0x10(%ebp)
  102b9e:	8a 00                	mov    (%eax),%al
  102ba0:	0f b6 d8             	movzbl %al,%ebx
  102ba3:	83 fb 25             	cmp    $0x25,%ebx
  102ba6:	75 d6                	jne    102b7e <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  102ba8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102bac:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102bb3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102bb6:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102bb9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102bc0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102bc3:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102bc6:	8b 45 10             	mov    0x10(%ebp),%eax
  102bc9:	8d 50 01             	lea    0x1(%eax),%edx
  102bcc:	89 55 10             	mov    %edx,0x10(%ebp)
  102bcf:	8a 00                	mov    (%eax),%al
  102bd1:	0f b6 d8             	movzbl %al,%ebx
  102bd4:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102bd7:	83 f8 55             	cmp    $0x55,%eax
  102bda:	0f 87 fa 02 00 00    	ja     102eda <vprintfmt+0x366>
  102be0:	8b 04 85 54 3c 10 00 	mov    0x103c54(,%eax,4),%eax
  102be7:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102be9:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102bed:	eb d7                	jmp    102bc6 <vprintfmt+0x52>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102bef:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102bf3:	eb d1                	jmp    102bc6 <vprintfmt+0x52>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102bf5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102bfc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102bff:	89 d0                	mov    %edx,%eax
  102c01:	c1 e0 02             	shl    $0x2,%eax
  102c04:	01 d0                	add    %edx,%eax
  102c06:	01 c0                	add    %eax,%eax
  102c08:	01 d8                	add    %ebx,%eax
  102c0a:	83 e8 30             	sub    $0x30,%eax
  102c0d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102c10:	8b 45 10             	mov    0x10(%ebp),%eax
  102c13:	8a 00                	mov    (%eax),%al
  102c15:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102c18:	83 fb 2f             	cmp    $0x2f,%ebx
  102c1b:	7e 35                	jle    102c52 <vprintfmt+0xde>
  102c1d:	83 fb 39             	cmp    $0x39,%ebx
  102c20:	7f 30                	jg     102c52 <vprintfmt+0xde>
            for (precision = 0; ; ++ fmt) {
  102c22:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  102c25:	eb d5                	jmp    102bfc <vprintfmt+0x88>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  102c27:	8b 45 14             	mov    0x14(%ebp),%eax
  102c2a:	8d 50 04             	lea    0x4(%eax),%edx
  102c2d:	89 55 14             	mov    %edx,0x14(%ebp)
  102c30:	8b 00                	mov    (%eax),%eax
  102c32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102c35:	eb 1c                	jmp    102c53 <vprintfmt+0xdf>

        case '.':
            if (width < 0)
  102c37:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102c3b:	79 89                	jns    102bc6 <vprintfmt+0x52>
                width = 0;
  102c3d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102c44:	eb 80                	jmp    102bc6 <vprintfmt+0x52>

        case '#':
            altflag = 1;
  102c46:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102c4d:	e9 74 ff ff ff       	jmp    102bc6 <vprintfmt+0x52>
            goto process_precision;
  102c52:	90                   	nop

        process_precision:
            if (width < 0)
  102c53:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102c57:	0f 89 69 ff ff ff    	jns    102bc6 <vprintfmt+0x52>
                width = precision, precision = -1;
  102c5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c60:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102c63:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102c6a:	e9 57 ff ff ff       	jmp    102bc6 <vprintfmt+0x52>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102c6f:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  102c72:	e9 4f ff ff ff       	jmp    102bc6 <vprintfmt+0x52>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102c77:	8b 45 14             	mov    0x14(%ebp),%eax
  102c7a:	8d 50 04             	lea    0x4(%eax),%edx
  102c7d:	89 55 14             	mov    %edx,0x14(%ebp)
  102c80:	8b 00                	mov    (%eax),%eax
  102c82:	83 ec 08             	sub    $0x8,%esp
  102c85:	ff 75 0c             	pushl  0xc(%ebp)
  102c88:	50                   	push   %eax
  102c89:	8b 45 08             	mov    0x8(%ebp),%eax
  102c8c:	ff d0                	call   *%eax
  102c8e:	83 c4 10             	add    $0x10,%esp
            break;
  102c91:	e9 67 02 00 00       	jmp    102efd <vprintfmt+0x389>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102c96:	8b 45 14             	mov    0x14(%ebp),%eax
  102c99:	8d 50 04             	lea    0x4(%eax),%edx
  102c9c:	89 55 14             	mov    %edx,0x14(%ebp)
  102c9f:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102ca1:	85 db                	test   %ebx,%ebx
  102ca3:	79 02                	jns    102ca7 <vprintfmt+0x133>
                err = -err;
  102ca5:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102ca7:	83 fb 06             	cmp    $0x6,%ebx
  102caa:	7f 0b                	jg     102cb7 <vprintfmt+0x143>
  102cac:	8b 34 9d 14 3c 10 00 	mov    0x103c14(,%ebx,4),%esi
  102cb3:	85 f6                	test   %esi,%esi
  102cb5:	75 19                	jne    102cd0 <vprintfmt+0x15c>
                printfmt(putch, putdat, "error %d", err);
  102cb7:	53                   	push   %ebx
  102cb8:	68 41 3c 10 00       	push   $0x103c41
  102cbd:	ff 75 0c             	pushl  0xc(%ebp)
  102cc0:	ff 75 08             	pushl  0x8(%ebp)
  102cc3:	e8 88 fe ff ff       	call   102b50 <printfmt>
  102cc8:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102ccb:	e9 2d 02 00 00       	jmp    102efd <vprintfmt+0x389>
                printfmt(putch, putdat, "%s", p);
  102cd0:	56                   	push   %esi
  102cd1:	68 4a 3c 10 00       	push   $0x103c4a
  102cd6:	ff 75 0c             	pushl  0xc(%ebp)
  102cd9:	ff 75 08             	pushl  0x8(%ebp)
  102cdc:	e8 6f fe ff ff       	call   102b50 <printfmt>
  102ce1:	83 c4 10             	add    $0x10,%esp
            break;
  102ce4:	e9 14 02 00 00       	jmp    102efd <vprintfmt+0x389>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102ce9:	8b 45 14             	mov    0x14(%ebp),%eax
  102cec:	8d 50 04             	lea    0x4(%eax),%edx
  102cef:	89 55 14             	mov    %edx,0x14(%ebp)
  102cf2:	8b 30                	mov    (%eax),%esi
  102cf4:	85 f6                	test   %esi,%esi
  102cf6:	75 05                	jne    102cfd <vprintfmt+0x189>
                p = "(null)";
  102cf8:	be 4d 3c 10 00       	mov    $0x103c4d,%esi
            }
            if (width > 0 && padc != '-') {
  102cfd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d01:	7e 74                	jle    102d77 <vprintfmt+0x203>
  102d03:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102d07:	74 6e                	je     102d77 <vprintfmt+0x203>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102d09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102d0c:	83 ec 08             	sub    $0x8,%esp
  102d0f:	50                   	push   %eax
  102d10:	56                   	push   %esi
  102d11:	e8 d3 02 00 00       	call   102fe9 <strnlen>
  102d16:	83 c4 10             	add    $0x10,%esp
  102d19:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102d1c:	29 c2                	sub    %eax,%edx
  102d1e:	89 d0                	mov    %edx,%eax
  102d20:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102d23:	eb 16                	jmp    102d3b <vprintfmt+0x1c7>
                    putch(padc, putdat);
  102d25:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102d29:	83 ec 08             	sub    $0x8,%esp
  102d2c:	ff 75 0c             	pushl  0xc(%ebp)
  102d2f:	50                   	push   %eax
  102d30:	8b 45 08             	mov    0x8(%ebp),%eax
  102d33:	ff d0                	call   *%eax
  102d35:	83 c4 10             	add    $0x10,%esp
                for (width -= strnlen(p, precision); width > 0; width --) {
  102d38:	ff 4d e8             	decl   -0x18(%ebp)
  102d3b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d3f:	7f e4                	jg     102d25 <vprintfmt+0x1b1>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102d41:	eb 34                	jmp    102d77 <vprintfmt+0x203>
                if (altflag && (ch < ' ' || ch > '~')) {
  102d43:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102d47:	74 1c                	je     102d65 <vprintfmt+0x1f1>
  102d49:	83 fb 1f             	cmp    $0x1f,%ebx
  102d4c:	7e 05                	jle    102d53 <vprintfmt+0x1df>
  102d4e:	83 fb 7e             	cmp    $0x7e,%ebx
  102d51:	7e 12                	jle    102d65 <vprintfmt+0x1f1>
                    putch('?', putdat);
  102d53:	83 ec 08             	sub    $0x8,%esp
  102d56:	ff 75 0c             	pushl  0xc(%ebp)
  102d59:	6a 3f                	push   $0x3f
  102d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  102d5e:	ff d0                	call   *%eax
  102d60:	83 c4 10             	add    $0x10,%esp
  102d63:	eb 0f                	jmp    102d74 <vprintfmt+0x200>
                }
                else {
                    putch(ch, putdat);
  102d65:	83 ec 08             	sub    $0x8,%esp
  102d68:	ff 75 0c             	pushl  0xc(%ebp)
  102d6b:	53                   	push   %ebx
  102d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d6f:	ff d0                	call   *%eax
  102d71:	83 c4 10             	add    $0x10,%esp
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102d74:	ff 4d e8             	decl   -0x18(%ebp)
  102d77:	89 f0                	mov    %esi,%eax
  102d79:	8d 70 01             	lea    0x1(%eax),%esi
  102d7c:	8a 00                	mov    (%eax),%al
  102d7e:	0f be d8             	movsbl %al,%ebx
  102d81:	85 db                	test   %ebx,%ebx
  102d83:	74 24                	je     102da9 <vprintfmt+0x235>
  102d85:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d89:	78 b8                	js     102d43 <vprintfmt+0x1cf>
  102d8b:	ff 4d e4             	decl   -0x1c(%ebp)
  102d8e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d92:	79 af                	jns    102d43 <vprintfmt+0x1cf>
                }
            }
            for (; width > 0; width --) {
  102d94:	eb 13                	jmp    102da9 <vprintfmt+0x235>
                putch(' ', putdat);
  102d96:	83 ec 08             	sub    $0x8,%esp
  102d99:	ff 75 0c             	pushl  0xc(%ebp)
  102d9c:	6a 20                	push   $0x20
  102d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  102da1:	ff d0                	call   *%eax
  102da3:	83 c4 10             	add    $0x10,%esp
            for (; width > 0; width --) {
  102da6:	ff 4d e8             	decl   -0x18(%ebp)
  102da9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102dad:	7f e7                	jg     102d96 <vprintfmt+0x222>
            }
            break;
  102daf:	e9 49 01 00 00       	jmp    102efd <vprintfmt+0x389>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102db4:	83 ec 08             	sub    $0x8,%esp
  102db7:	ff 75 e0             	pushl  -0x20(%ebp)
  102dba:	8d 45 14             	lea    0x14(%ebp),%eax
  102dbd:	50                   	push   %eax
  102dbe:	e8 46 fd ff ff       	call   102b09 <getint>
  102dc3:	83 c4 10             	add    $0x10,%esp
  102dc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102dc9:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102dcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102dcf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102dd2:	85 d2                	test   %edx,%edx
  102dd4:	79 23                	jns    102df9 <vprintfmt+0x285>
                putch('-', putdat);
  102dd6:	83 ec 08             	sub    $0x8,%esp
  102dd9:	ff 75 0c             	pushl  0xc(%ebp)
  102ddc:	6a 2d                	push   $0x2d
  102dde:	8b 45 08             	mov    0x8(%ebp),%eax
  102de1:	ff d0                	call   *%eax
  102de3:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  102de6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102de9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102dec:	f7 d8                	neg    %eax
  102dee:	83 d2 00             	adc    $0x0,%edx
  102df1:	f7 da                	neg    %edx
  102df3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102df6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102df9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102e00:	e9 9f 00 00 00       	jmp    102ea4 <vprintfmt+0x330>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102e05:	83 ec 08             	sub    $0x8,%esp
  102e08:	ff 75 e0             	pushl  -0x20(%ebp)
  102e0b:	8d 45 14             	lea    0x14(%ebp),%eax
  102e0e:	50                   	push   %eax
  102e0f:	e8 a6 fc ff ff       	call   102aba <getuint>
  102e14:	83 c4 10             	add    $0x10,%esp
  102e17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e1a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102e1d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102e24:	eb 7e                	jmp    102ea4 <vprintfmt+0x330>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102e26:	83 ec 08             	sub    $0x8,%esp
  102e29:	ff 75 e0             	pushl  -0x20(%ebp)
  102e2c:	8d 45 14             	lea    0x14(%ebp),%eax
  102e2f:	50                   	push   %eax
  102e30:	e8 85 fc ff ff       	call   102aba <getuint>
  102e35:	83 c4 10             	add    $0x10,%esp
  102e38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e3b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102e3e:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102e45:	eb 5d                	jmp    102ea4 <vprintfmt+0x330>

        // pointer
        case 'p':
            putch('0', putdat);
  102e47:	83 ec 08             	sub    $0x8,%esp
  102e4a:	ff 75 0c             	pushl  0xc(%ebp)
  102e4d:	6a 30                	push   $0x30
  102e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  102e52:	ff d0                	call   *%eax
  102e54:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  102e57:	83 ec 08             	sub    $0x8,%esp
  102e5a:	ff 75 0c             	pushl  0xc(%ebp)
  102e5d:	6a 78                	push   $0x78
  102e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  102e62:	ff d0                	call   *%eax
  102e64:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102e67:	8b 45 14             	mov    0x14(%ebp),%eax
  102e6a:	8d 50 04             	lea    0x4(%eax),%edx
  102e6d:	89 55 14             	mov    %edx,0x14(%ebp)
  102e70:	8b 00                	mov    (%eax),%eax
  102e72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102e7c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  102e83:	eb 1f                	jmp    102ea4 <vprintfmt+0x330>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  102e85:	83 ec 08             	sub    $0x8,%esp
  102e88:	ff 75 e0             	pushl  -0x20(%ebp)
  102e8b:	8d 45 14             	lea    0x14(%ebp),%eax
  102e8e:	50                   	push   %eax
  102e8f:	e8 26 fc ff ff       	call   102aba <getuint>
  102e94:	83 c4 10             	add    $0x10,%esp
  102e97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e9a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  102e9d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  102ea4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  102ea8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102eab:	83 ec 04             	sub    $0x4,%esp
  102eae:	52                   	push   %edx
  102eaf:	ff 75 e8             	pushl  -0x18(%ebp)
  102eb2:	50                   	push   %eax
  102eb3:	ff 75 f4             	pushl  -0xc(%ebp)
  102eb6:	ff 75 f0             	pushl  -0x10(%ebp)
  102eb9:	ff 75 0c             	pushl  0xc(%ebp)
  102ebc:	ff 75 08             	pushl  0x8(%ebp)
  102ebf:	e8 0e fb ff ff       	call   1029d2 <printnum>
  102ec4:	83 c4 20             	add    $0x20,%esp
            break;
  102ec7:	eb 34                	jmp    102efd <vprintfmt+0x389>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  102ec9:	83 ec 08             	sub    $0x8,%esp
  102ecc:	ff 75 0c             	pushl  0xc(%ebp)
  102ecf:	53                   	push   %ebx
  102ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ed3:	ff d0                	call   *%eax
  102ed5:	83 c4 10             	add    $0x10,%esp
            break;
  102ed8:	eb 23                	jmp    102efd <vprintfmt+0x389>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  102eda:	83 ec 08             	sub    $0x8,%esp
  102edd:	ff 75 0c             	pushl  0xc(%ebp)
  102ee0:	6a 25                	push   $0x25
  102ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  102ee5:	ff d0                	call   *%eax
  102ee7:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  102eea:	ff 4d 10             	decl   0x10(%ebp)
  102eed:	eb 03                	jmp    102ef2 <vprintfmt+0x37e>
  102eef:	ff 4d 10             	decl   0x10(%ebp)
  102ef2:	8b 45 10             	mov    0x10(%ebp),%eax
  102ef5:	48                   	dec    %eax
  102ef6:	8a 00                	mov    (%eax),%al
  102ef8:	3c 25                	cmp    $0x25,%al
  102efa:	75 f3                	jne    102eef <vprintfmt+0x37b>
                /* do nothing */;
            break;
  102efc:	90                   	nop
    while (1) {
  102efd:	e9 7a fc ff ff       	jmp    102b7c <vprintfmt+0x8>
                return;
  102f02:	90                   	nop
        }
    }
}
  102f03:	8d 65 f8             	lea    -0x8(%ebp),%esp
  102f06:	5b                   	pop    %ebx
  102f07:	5e                   	pop    %esi
  102f08:	5d                   	pop    %ebp
  102f09:	c3                   	ret    

00102f0a <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  102f0a:	55                   	push   %ebp
  102f0b:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  102f0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f10:	8b 40 08             	mov    0x8(%eax),%eax
  102f13:	8d 50 01             	lea    0x1(%eax),%edx
  102f16:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f19:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  102f1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f1f:	8b 10                	mov    (%eax),%edx
  102f21:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f24:	8b 40 04             	mov    0x4(%eax),%eax
  102f27:	39 c2                	cmp    %eax,%edx
  102f29:	73 12                	jae    102f3d <sprintputch+0x33>
        *b->buf ++ = ch;
  102f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f2e:	8b 00                	mov    (%eax),%eax
  102f30:	8d 48 01             	lea    0x1(%eax),%ecx
  102f33:	8b 55 0c             	mov    0xc(%ebp),%edx
  102f36:	89 0a                	mov    %ecx,(%edx)
  102f38:	8b 55 08             	mov    0x8(%ebp),%edx
  102f3b:	88 10                	mov    %dl,(%eax)
    }
}
  102f3d:	90                   	nop
  102f3e:	5d                   	pop    %ebp
  102f3f:	c3                   	ret    

00102f40 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  102f40:	55                   	push   %ebp
  102f41:	89 e5                	mov    %esp,%ebp
  102f43:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  102f46:	8d 45 14             	lea    0x14(%ebp),%eax
  102f49:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  102f4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f4f:	50                   	push   %eax
  102f50:	ff 75 10             	pushl  0x10(%ebp)
  102f53:	ff 75 0c             	pushl  0xc(%ebp)
  102f56:	ff 75 08             	pushl  0x8(%ebp)
  102f59:	e8 0b 00 00 00       	call   102f69 <vsnprintf>
  102f5e:	83 c4 10             	add    $0x10,%esp
  102f61:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  102f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102f67:	c9                   	leave  
  102f68:	c3                   	ret    

00102f69 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  102f69:	55                   	push   %ebp
  102f6a:	89 e5                	mov    %esp,%ebp
  102f6c:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  102f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  102f72:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f78:	8d 50 ff             	lea    -0x1(%eax),%edx
  102f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  102f7e:	01 d0                	add    %edx,%eax
  102f80:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f83:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  102f8a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102f8e:	74 0a                	je     102f9a <vsnprintf+0x31>
  102f90:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102f93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f96:	39 c2                	cmp    %eax,%edx
  102f98:	76 07                	jbe    102fa1 <vsnprintf+0x38>
        return -E_INVAL;
  102f9a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  102f9f:	eb 20                	jmp    102fc1 <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  102fa1:	ff 75 14             	pushl  0x14(%ebp)
  102fa4:	ff 75 10             	pushl  0x10(%ebp)
  102fa7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  102faa:	50                   	push   %eax
  102fab:	68 0a 2f 10 00       	push   $0x102f0a
  102fb0:	e8 bf fb ff ff       	call   102b74 <vprintfmt>
  102fb5:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  102fb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fbb:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  102fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102fc1:	c9                   	leave  
  102fc2:	c3                   	ret    

00102fc3 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102fc3:	55                   	push   %ebp
  102fc4:	89 e5                	mov    %esp,%ebp
  102fc6:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102fc9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102fd0:	eb 03                	jmp    102fd5 <strlen+0x12>
        cnt ++;
  102fd2:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  102fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  102fd8:	8d 50 01             	lea    0x1(%eax),%edx
  102fdb:	89 55 08             	mov    %edx,0x8(%ebp)
  102fde:	8a 00                	mov    (%eax),%al
  102fe0:	84 c0                	test   %al,%al
  102fe2:	75 ee                	jne    102fd2 <strlen+0xf>
    }
    return cnt;
  102fe4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102fe7:	c9                   	leave  
  102fe8:	c3                   	ret    

00102fe9 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102fe9:	55                   	push   %ebp
  102fea:	89 e5                	mov    %esp,%ebp
  102fec:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102fef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102ff6:	eb 03                	jmp    102ffb <strnlen+0x12>
        cnt ++;
  102ff8:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102ffb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102ffe:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103001:	73 0f                	jae    103012 <strnlen+0x29>
  103003:	8b 45 08             	mov    0x8(%ebp),%eax
  103006:	8d 50 01             	lea    0x1(%eax),%edx
  103009:	89 55 08             	mov    %edx,0x8(%ebp)
  10300c:	8a 00                	mov    (%eax),%al
  10300e:	84 c0                	test   %al,%al
  103010:	75 e6                	jne    102ff8 <strnlen+0xf>
    }
    return cnt;
  103012:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  103015:	c9                   	leave  
  103016:	c3                   	ret    

00103017 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  103017:	55                   	push   %ebp
  103018:	89 e5                	mov    %esp,%ebp
  10301a:	57                   	push   %edi
  10301b:	56                   	push   %esi
  10301c:	83 ec 20             	sub    $0x20,%esp
  10301f:	8b 45 08             	mov    0x8(%ebp),%eax
  103022:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103025:	8b 45 0c             	mov    0xc(%ebp),%eax
  103028:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  10302b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10302e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103031:	89 d1                	mov    %edx,%ecx
  103033:	89 c2                	mov    %eax,%edx
  103035:	89 ce                	mov    %ecx,%esi
  103037:	89 d7                	mov    %edx,%edi
  103039:	ac                   	lods   %ds:(%esi),%al
  10303a:	aa                   	stos   %al,%es:(%edi)
  10303b:	84 c0                	test   %al,%al
  10303d:	75 fa                	jne    103039 <strcpy+0x22>
  10303f:	89 fa                	mov    %edi,%edx
  103041:	89 f1                	mov    %esi,%ecx
  103043:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103046:	89 55 e8             	mov    %edx,-0x18(%ebp)
  103049:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  10304c:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  10304f:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  103050:	83 c4 20             	add    $0x20,%esp
  103053:	5e                   	pop    %esi
  103054:	5f                   	pop    %edi
  103055:	5d                   	pop    %ebp
  103056:	c3                   	ret    

00103057 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  103057:	55                   	push   %ebp
  103058:	89 e5                	mov    %esp,%ebp
  10305a:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  10305d:	8b 45 08             	mov    0x8(%ebp),%eax
  103060:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  103063:	eb 1c                	jmp    103081 <strncpy+0x2a>
        if ((*p = *src) != '\0') {
  103065:	8b 45 0c             	mov    0xc(%ebp),%eax
  103068:	8a 10                	mov    (%eax),%dl
  10306a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10306d:	88 10                	mov    %dl,(%eax)
  10306f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103072:	8a 00                	mov    (%eax),%al
  103074:	84 c0                	test   %al,%al
  103076:	74 03                	je     10307b <strncpy+0x24>
            src ++;
  103078:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  10307b:	ff 45 fc             	incl   -0x4(%ebp)
  10307e:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  103081:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103085:	75 de                	jne    103065 <strncpy+0xe>
    }
    return dst;
  103087:	8b 45 08             	mov    0x8(%ebp),%eax
}
  10308a:	c9                   	leave  
  10308b:	c3                   	ret    

0010308c <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  10308c:	55                   	push   %ebp
  10308d:	89 e5                	mov    %esp,%ebp
  10308f:	57                   	push   %edi
  103090:	56                   	push   %esi
  103091:	83 ec 20             	sub    $0x20,%esp
  103094:	8b 45 08             	mov    0x8(%ebp),%eax
  103097:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10309a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10309d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  1030a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1030a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030a6:	89 d1                	mov    %edx,%ecx
  1030a8:	89 c2                	mov    %eax,%edx
  1030aa:	89 ce                	mov    %ecx,%esi
  1030ac:	89 d7                	mov    %edx,%edi
  1030ae:	ac                   	lods   %ds:(%esi),%al
  1030af:	ae                   	scas   %es:(%edi),%al
  1030b0:	75 08                	jne    1030ba <strcmp+0x2e>
  1030b2:	84 c0                	test   %al,%al
  1030b4:	75 f8                	jne    1030ae <strcmp+0x22>
  1030b6:	31 c0                	xor    %eax,%eax
  1030b8:	eb 04                	jmp    1030be <strcmp+0x32>
  1030ba:	19 c0                	sbb    %eax,%eax
  1030bc:	0c 01                	or     $0x1,%al
  1030be:	89 fa                	mov    %edi,%edx
  1030c0:	89 f1                	mov    %esi,%ecx
  1030c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1030c5:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1030c8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  1030cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  1030ce:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1030cf:	83 c4 20             	add    $0x20,%esp
  1030d2:	5e                   	pop    %esi
  1030d3:	5f                   	pop    %edi
  1030d4:	5d                   	pop    %ebp
  1030d5:	c3                   	ret    

001030d6 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1030d6:	55                   	push   %ebp
  1030d7:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1030d9:	eb 09                	jmp    1030e4 <strncmp+0xe>
        n --, s1 ++, s2 ++;
  1030db:	ff 4d 10             	decl   0x10(%ebp)
  1030de:	ff 45 08             	incl   0x8(%ebp)
  1030e1:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1030e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1030e8:	74 17                	je     103101 <strncmp+0x2b>
  1030ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1030ed:	8a 00                	mov    (%eax),%al
  1030ef:	84 c0                	test   %al,%al
  1030f1:	74 0e                	je     103101 <strncmp+0x2b>
  1030f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1030f6:	8a 10                	mov    (%eax),%dl
  1030f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030fb:	8a 00                	mov    (%eax),%al
  1030fd:	38 c2                	cmp    %al,%dl
  1030ff:	74 da                	je     1030db <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  103101:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103105:	74 16                	je     10311d <strncmp+0x47>
  103107:	8b 45 08             	mov    0x8(%ebp),%eax
  10310a:	8a 00                	mov    (%eax),%al
  10310c:	0f b6 d0             	movzbl %al,%edx
  10310f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103112:	8a 00                	mov    (%eax),%al
  103114:	0f b6 c0             	movzbl %al,%eax
  103117:	29 c2                	sub    %eax,%edx
  103119:	89 d0                	mov    %edx,%eax
  10311b:	eb 05                	jmp    103122 <strncmp+0x4c>
  10311d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103122:	5d                   	pop    %ebp
  103123:	c3                   	ret    

00103124 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  103124:	55                   	push   %ebp
  103125:	89 e5                	mov    %esp,%ebp
  103127:	83 ec 04             	sub    $0x4,%esp
  10312a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10312d:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103130:	eb 12                	jmp    103144 <strchr+0x20>
        if (*s == c) {
  103132:	8b 45 08             	mov    0x8(%ebp),%eax
  103135:	8a 00                	mov    (%eax),%al
  103137:	38 45 fc             	cmp    %al,-0x4(%ebp)
  10313a:	75 05                	jne    103141 <strchr+0x1d>
            return (char *)s;
  10313c:	8b 45 08             	mov    0x8(%ebp),%eax
  10313f:	eb 11                	jmp    103152 <strchr+0x2e>
        }
        s ++;
  103141:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  103144:	8b 45 08             	mov    0x8(%ebp),%eax
  103147:	8a 00                	mov    (%eax),%al
  103149:	84 c0                	test   %al,%al
  10314b:	75 e5                	jne    103132 <strchr+0xe>
    }
    return NULL;
  10314d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103152:	c9                   	leave  
  103153:	c3                   	ret    

00103154 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  103154:	55                   	push   %ebp
  103155:	89 e5                	mov    %esp,%ebp
  103157:	83 ec 04             	sub    $0x4,%esp
  10315a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10315d:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103160:	eb 0d                	jmp    10316f <strfind+0x1b>
        if (*s == c) {
  103162:	8b 45 08             	mov    0x8(%ebp),%eax
  103165:	8a 00                	mov    (%eax),%al
  103167:	38 45 fc             	cmp    %al,-0x4(%ebp)
  10316a:	74 0e                	je     10317a <strfind+0x26>
            break;
        }
        s ++;
  10316c:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  10316f:	8b 45 08             	mov    0x8(%ebp),%eax
  103172:	8a 00                	mov    (%eax),%al
  103174:	84 c0                	test   %al,%al
  103176:	75 ea                	jne    103162 <strfind+0xe>
  103178:	eb 01                	jmp    10317b <strfind+0x27>
            break;
  10317a:	90                   	nop
    }
    return (char *)s;
  10317b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  10317e:	c9                   	leave  
  10317f:	c3                   	ret    

00103180 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  103180:	55                   	push   %ebp
  103181:	89 e5                	mov    %esp,%ebp
  103183:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  103186:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  10318d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  103194:	eb 03                	jmp    103199 <strtol+0x19>
        s ++;
  103196:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  103199:	8b 45 08             	mov    0x8(%ebp),%eax
  10319c:	8a 00                	mov    (%eax),%al
  10319e:	3c 20                	cmp    $0x20,%al
  1031a0:	74 f4                	je     103196 <strtol+0x16>
  1031a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1031a5:	8a 00                	mov    (%eax),%al
  1031a7:	3c 09                	cmp    $0x9,%al
  1031a9:	74 eb                	je     103196 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  1031ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1031ae:	8a 00                	mov    (%eax),%al
  1031b0:	3c 2b                	cmp    $0x2b,%al
  1031b2:	75 05                	jne    1031b9 <strtol+0x39>
        s ++;
  1031b4:	ff 45 08             	incl   0x8(%ebp)
  1031b7:	eb 13                	jmp    1031cc <strtol+0x4c>
    }
    else if (*s == '-') {
  1031b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1031bc:	8a 00                	mov    (%eax),%al
  1031be:	3c 2d                	cmp    $0x2d,%al
  1031c0:	75 0a                	jne    1031cc <strtol+0x4c>
        s ++, neg = 1;
  1031c2:	ff 45 08             	incl   0x8(%ebp)
  1031c5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  1031cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1031d0:	74 06                	je     1031d8 <strtol+0x58>
  1031d2:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  1031d6:	75 20                	jne    1031f8 <strtol+0x78>
  1031d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1031db:	8a 00                	mov    (%eax),%al
  1031dd:	3c 30                	cmp    $0x30,%al
  1031df:	75 17                	jne    1031f8 <strtol+0x78>
  1031e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1031e4:	40                   	inc    %eax
  1031e5:	8a 00                	mov    (%eax),%al
  1031e7:	3c 78                	cmp    $0x78,%al
  1031e9:	75 0d                	jne    1031f8 <strtol+0x78>
        s += 2, base = 16;
  1031eb:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  1031ef:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  1031f6:	eb 28                	jmp    103220 <strtol+0xa0>
    }
    else if (base == 0 && s[0] == '0') {
  1031f8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1031fc:	75 15                	jne    103213 <strtol+0x93>
  1031fe:	8b 45 08             	mov    0x8(%ebp),%eax
  103201:	8a 00                	mov    (%eax),%al
  103203:	3c 30                	cmp    $0x30,%al
  103205:	75 0c                	jne    103213 <strtol+0x93>
        s ++, base = 8;
  103207:	ff 45 08             	incl   0x8(%ebp)
  10320a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  103211:	eb 0d                	jmp    103220 <strtol+0xa0>
    }
    else if (base == 0) {
  103213:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103217:	75 07                	jne    103220 <strtol+0xa0>
        base = 10;
  103219:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  103220:	8b 45 08             	mov    0x8(%ebp),%eax
  103223:	8a 00                	mov    (%eax),%al
  103225:	3c 2f                	cmp    $0x2f,%al
  103227:	7e 19                	jle    103242 <strtol+0xc2>
  103229:	8b 45 08             	mov    0x8(%ebp),%eax
  10322c:	8a 00                	mov    (%eax),%al
  10322e:	3c 39                	cmp    $0x39,%al
  103230:	7f 10                	jg     103242 <strtol+0xc2>
            dig = *s - '0';
  103232:	8b 45 08             	mov    0x8(%ebp),%eax
  103235:	8a 00                	mov    (%eax),%al
  103237:	0f be c0             	movsbl %al,%eax
  10323a:	83 e8 30             	sub    $0x30,%eax
  10323d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103240:	eb 42                	jmp    103284 <strtol+0x104>
        }
        else if (*s >= 'a' && *s <= 'z') {
  103242:	8b 45 08             	mov    0x8(%ebp),%eax
  103245:	8a 00                	mov    (%eax),%al
  103247:	3c 60                	cmp    $0x60,%al
  103249:	7e 19                	jle    103264 <strtol+0xe4>
  10324b:	8b 45 08             	mov    0x8(%ebp),%eax
  10324e:	8a 00                	mov    (%eax),%al
  103250:	3c 7a                	cmp    $0x7a,%al
  103252:	7f 10                	jg     103264 <strtol+0xe4>
            dig = *s - 'a' + 10;
  103254:	8b 45 08             	mov    0x8(%ebp),%eax
  103257:	8a 00                	mov    (%eax),%al
  103259:	0f be c0             	movsbl %al,%eax
  10325c:	83 e8 57             	sub    $0x57,%eax
  10325f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103262:	eb 20                	jmp    103284 <strtol+0x104>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  103264:	8b 45 08             	mov    0x8(%ebp),%eax
  103267:	8a 00                	mov    (%eax),%al
  103269:	3c 40                	cmp    $0x40,%al
  10326b:	7e 39                	jle    1032a6 <strtol+0x126>
  10326d:	8b 45 08             	mov    0x8(%ebp),%eax
  103270:	8a 00                	mov    (%eax),%al
  103272:	3c 5a                	cmp    $0x5a,%al
  103274:	7f 30                	jg     1032a6 <strtol+0x126>
            dig = *s - 'A' + 10;
  103276:	8b 45 08             	mov    0x8(%ebp),%eax
  103279:	8a 00                	mov    (%eax),%al
  10327b:	0f be c0             	movsbl %al,%eax
  10327e:	83 e8 37             	sub    $0x37,%eax
  103281:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  103284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103287:	3b 45 10             	cmp    0x10(%ebp),%eax
  10328a:	7d 19                	jge    1032a5 <strtol+0x125>
            break;
        }
        s ++, val = (val * base) + dig;
  10328c:	ff 45 08             	incl   0x8(%ebp)
  10328f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103292:	0f af 45 10          	imul   0x10(%ebp),%eax
  103296:	89 c2                	mov    %eax,%edx
  103298:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10329b:	01 d0                	add    %edx,%eax
  10329d:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  1032a0:	e9 7b ff ff ff       	jmp    103220 <strtol+0xa0>
            break;
  1032a5:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  1032a6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1032aa:	74 08                	je     1032b4 <strtol+0x134>
        *endptr = (char *) s;
  1032ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032af:	8b 55 08             	mov    0x8(%ebp),%edx
  1032b2:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1032b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1032b8:	74 07                	je     1032c1 <strtol+0x141>
  1032ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1032bd:	f7 d8                	neg    %eax
  1032bf:	eb 03                	jmp    1032c4 <strtol+0x144>
  1032c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  1032c4:	c9                   	leave  
  1032c5:	c3                   	ret    

001032c6 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  1032c6:	55                   	push   %ebp
  1032c7:	89 e5                	mov    %esp,%ebp
  1032c9:	57                   	push   %edi
  1032ca:	83 ec 24             	sub    $0x24,%esp
  1032cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032d0:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  1032d3:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  1032d7:	8b 55 08             	mov    0x8(%ebp),%edx
  1032da:	89 55 f8             	mov    %edx,-0x8(%ebp)
  1032dd:	88 45 f7             	mov    %al,-0x9(%ebp)
  1032e0:	8b 45 10             	mov    0x10(%ebp),%eax
  1032e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  1032e6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1032e9:	8a 45 f7             	mov    -0x9(%ebp),%al
  1032ec:	8b 55 f8             	mov    -0x8(%ebp),%edx
  1032ef:	89 d7                	mov    %edx,%edi
  1032f1:	f3 aa                	rep stos %al,%es:(%edi)
  1032f3:	89 fa                	mov    %edi,%edx
  1032f5:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1032f8:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  1032fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1032fe:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  1032ff:	83 c4 24             	add    $0x24,%esp
  103302:	5f                   	pop    %edi
  103303:	5d                   	pop    %ebp
  103304:	c3                   	ret    

00103305 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  103305:	55                   	push   %ebp
  103306:	89 e5                	mov    %esp,%ebp
  103308:	57                   	push   %edi
  103309:	56                   	push   %esi
  10330a:	53                   	push   %ebx
  10330b:	83 ec 30             	sub    $0x30,%esp
  10330e:	8b 45 08             	mov    0x8(%ebp),%eax
  103311:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103314:	8b 45 0c             	mov    0xc(%ebp),%eax
  103317:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10331a:	8b 45 10             	mov    0x10(%ebp),%eax
  10331d:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  103320:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103323:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103326:	73 42                	jae    10336a <memmove+0x65>
  103328:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10332b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10332e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103331:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103334:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103337:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10333a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10333d:	c1 e8 02             	shr    $0x2,%eax
  103340:	89 c1                	mov    %eax,%ecx
    asm volatile (
  103342:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103345:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103348:	89 d7                	mov    %edx,%edi
  10334a:	89 c6                	mov    %eax,%esi
  10334c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10334e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  103351:	83 e1 03             	and    $0x3,%ecx
  103354:	74 02                	je     103358 <memmove+0x53>
  103356:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103358:	89 f0                	mov    %esi,%eax
  10335a:	89 fa                	mov    %edi,%edx
  10335c:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  10335f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103362:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  103365:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  103368:	eb 36                	jmp    1033a0 <memmove+0x9b>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  10336a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10336d:	8d 50 ff             	lea    -0x1(%eax),%edx
  103370:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103373:	01 c2                	add    %eax,%edx
  103375:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103378:	8d 48 ff             	lea    -0x1(%eax),%ecx
  10337b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10337e:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  103381:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103384:	89 c1                	mov    %eax,%ecx
  103386:	89 d8                	mov    %ebx,%eax
  103388:	89 d6                	mov    %edx,%esi
  10338a:	89 c7                	mov    %eax,%edi
  10338c:	fd                   	std    
  10338d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10338f:	fc                   	cld    
  103390:	89 f8                	mov    %edi,%eax
  103392:	89 f2                	mov    %esi,%edx
  103394:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  103397:	89 55 c8             	mov    %edx,-0x38(%ebp)
  10339a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  10339d:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1033a0:	83 c4 30             	add    $0x30,%esp
  1033a3:	5b                   	pop    %ebx
  1033a4:	5e                   	pop    %esi
  1033a5:	5f                   	pop    %edi
  1033a6:	5d                   	pop    %ebp
  1033a7:	c3                   	ret    

001033a8 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1033a8:	55                   	push   %ebp
  1033a9:	89 e5                	mov    %esp,%ebp
  1033ab:	57                   	push   %edi
  1033ac:	56                   	push   %esi
  1033ad:	83 ec 20             	sub    $0x20,%esp
  1033b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1033b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1033b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033bc:	8b 45 10             	mov    0x10(%ebp),%eax
  1033bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1033c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033c5:	c1 e8 02             	shr    $0x2,%eax
  1033c8:	89 c1                	mov    %eax,%ecx
    asm volatile (
  1033ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1033cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033d0:	89 d7                	mov    %edx,%edi
  1033d2:	89 c6                	mov    %eax,%esi
  1033d4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1033d6:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1033d9:	83 e1 03             	and    $0x3,%ecx
  1033dc:	74 02                	je     1033e0 <memcpy+0x38>
  1033de:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1033e0:	89 f0                	mov    %esi,%eax
  1033e2:	89 fa                	mov    %edi,%edx
  1033e4:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1033e7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1033ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  1033ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  1033f0:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  1033f1:	83 c4 20             	add    $0x20,%esp
  1033f4:	5e                   	pop    %esi
  1033f5:	5f                   	pop    %edi
  1033f6:	5d                   	pop    %ebp
  1033f7:	c3                   	ret    

001033f8 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  1033f8:	55                   	push   %ebp
  1033f9:	89 e5                	mov    %esp,%ebp
  1033fb:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  1033fe:	8b 45 08             	mov    0x8(%ebp),%eax
  103401:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  103404:	8b 45 0c             	mov    0xc(%ebp),%eax
  103407:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  10340a:	eb 2a                	jmp    103436 <memcmp+0x3e>
        if (*s1 != *s2) {
  10340c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10340f:	8a 10                	mov    (%eax),%dl
  103411:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103414:	8a 00                	mov    (%eax),%al
  103416:	38 c2                	cmp    %al,%dl
  103418:	74 16                	je     103430 <memcmp+0x38>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  10341a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10341d:	8a 00                	mov    (%eax),%al
  10341f:	0f b6 d0             	movzbl %al,%edx
  103422:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103425:	8a 00                	mov    (%eax),%al
  103427:	0f b6 c0             	movzbl %al,%eax
  10342a:	29 c2                	sub    %eax,%edx
  10342c:	89 d0                	mov    %edx,%eax
  10342e:	eb 18                	jmp    103448 <memcmp+0x50>
        }
        s1 ++, s2 ++;
  103430:	ff 45 fc             	incl   -0x4(%ebp)
  103433:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  103436:	8b 45 10             	mov    0x10(%ebp),%eax
  103439:	8d 50 ff             	lea    -0x1(%eax),%edx
  10343c:	89 55 10             	mov    %edx,0x10(%ebp)
  10343f:	85 c0                	test   %eax,%eax
  103441:	75 c9                	jne    10340c <memcmp+0x14>
    }
    return 0;
  103443:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103448:	c9                   	leave  
  103449:	c3                   	ret    
