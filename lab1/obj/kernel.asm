
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
  10001b:	e8 6c 31 00 00       	call   10318c <memset>
  100020:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100023:	e8 bc 14 00 00       	call   1014e4 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100028:	c7 45 f4 20 33 10 00 	movl   $0x103320,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10002f:	83 ec 08             	sub    $0x8,%esp
  100032:	ff 75 f4             	pushl  -0xc(%ebp)
  100035:	68 3c 33 10 00       	push   $0x10333c
  10003a:	e8 b7 02 00 00       	call   1002f6 <cprintf>
  10003f:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100042:	e8 b2 07 00 00       	call   1007f9 <print_kerninfo>

    grade_backtrace();
  100047:	e8 74 00 00 00       	call   1000c0 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10004c:	e8 3c 28 00 00       	call   10288d <pmm_init>

    pic_init();                 // init interrupt controller
  100051:	e8 d8 15 00 00       	call   10162e <pic_init>
    idt_init();                 // init interrupt descriptor table
  100056:	e8 1b 17 00 00       	call   101776 <idt_init>

    clock_init();               // init clock interrupt
  10005b:	e8 be 0c 00 00       	call   100d1e <clock_init>
    intr_enable();              // enable irq interrupt
  100060:	e8 3b 15 00 00       	call   1015a0 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100065:	eb fe                	jmp    100065 <kern_init+0x65>

00100067 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100067:	55                   	push   %ebp
  100068:	89 e5                	mov    %esp,%ebp
  10006a:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
  10006d:	83 ec 04             	sub    $0x4,%esp
  100070:	6a 00                	push   $0x0
  100072:	6a 00                	push   $0x0
  100074:	6a 00                	push   $0x0
  100076:	e8 bd 0b 00 00       	call   100c38 <mon_backtrace>
  10007b:	83 c4 10             	add    $0x10,%esp
}
  10007e:	90                   	nop
  10007f:	c9                   	leave  
  100080:	c3                   	ret    

00100081 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100081:	55                   	push   %ebp
  100082:	89 e5                	mov    %esp,%ebp
  100084:	53                   	push   %ebx
  100085:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  100088:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  10008b:	8b 55 0c             	mov    0xc(%ebp),%edx
  10008e:	8d 5d 08             	lea    0x8(%ebp),%ebx
  100091:	8b 45 08             	mov    0x8(%ebp),%eax
  100094:	51                   	push   %ecx
  100095:	52                   	push   %edx
  100096:	53                   	push   %ebx
  100097:	50                   	push   %eax
  100098:	e8 ca ff ff ff       	call   100067 <grade_backtrace2>
  10009d:	83 c4 10             	add    $0x10,%esp
}
  1000a0:	90                   	nop
  1000a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000a4:	c9                   	leave  
  1000a5:	c3                   	ret    

001000a6 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000a6:	55                   	push   %ebp
  1000a7:	89 e5                	mov    %esp,%ebp
  1000a9:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
  1000ac:	83 ec 08             	sub    $0x8,%esp
  1000af:	ff 75 10             	pushl  0x10(%ebp)
  1000b2:	ff 75 08             	pushl  0x8(%ebp)
  1000b5:	e8 c7 ff ff ff       	call   100081 <grade_backtrace1>
  1000ba:	83 c4 10             	add    $0x10,%esp
}
  1000bd:	90                   	nop
  1000be:	c9                   	leave  
  1000bf:	c3                   	ret    

001000c0 <grade_backtrace>:

void
grade_backtrace(void) {
  1000c0:	55                   	push   %ebp
  1000c1:	89 e5                	mov    %esp,%ebp
  1000c3:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000c6:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000cb:	83 ec 04             	sub    $0x4,%esp
  1000ce:	68 00 00 ff ff       	push   $0xffff0000
  1000d3:	50                   	push   %eax
  1000d4:	6a 00                	push   $0x0
  1000d6:	e8 cb ff ff ff       	call   1000a6 <grade_backtrace0>
  1000db:	83 c4 10             	add    $0x10,%esp
}
  1000de:	90                   	nop
  1000df:	c9                   	leave  
  1000e0:	c3                   	ret    

001000e1 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  1000e1:	55                   	push   %ebp
  1000e2:	89 e5                	mov    %esp,%ebp
  1000e4:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  1000e7:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  1000ea:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  1000ed:	8c 45 f2             	mov    %es,-0xe(%ebp)
  1000f0:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  1000f3:	66 8b 45 f6          	mov    -0xa(%ebp),%ax
  1000f7:	0f b7 c0             	movzwl %ax,%eax
  1000fa:	83 e0 03             	and    $0x3,%eax
  1000fd:	89 c2                	mov    %eax,%edx
  1000ff:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100104:	83 ec 04             	sub    $0x4,%esp
  100107:	52                   	push   %edx
  100108:	50                   	push   %eax
  100109:	68 41 33 10 00       	push   $0x103341
  10010e:	e8 e3 01 00 00       	call   1002f6 <cprintf>
  100113:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  100116:	66 8b 45 f6          	mov    -0xa(%ebp),%ax
  10011a:	0f b7 d0             	movzwl %ax,%edx
  10011d:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100122:	83 ec 04             	sub    $0x4,%esp
  100125:	52                   	push   %edx
  100126:	50                   	push   %eax
  100127:	68 4f 33 10 00       	push   $0x10334f
  10012c:	e8 c5 01 00 00       	call   1002f6 <cprintf>
  100131:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  100134:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100137:	0f b7 d0             	movzwl %ax,%edx
  10013a:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  10013f:	83 ec 04             	sub    $0x4,%esp
  100142:	52                   	push   %edx
  100143:	50                   	push   %eax
  100144:	68 5d 33 10 00       	push   $0x10335d
  100149:	e8 a8 01 00 00       	call   1002f6 <cprintf>
  10014e:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  100151:	66 8b 45 f2          	mov    -0xe(%ebp),%ax
  100155:	0f b7 d0             	movzwl %ax,%edx
  100158:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  10015d:	83 ec 04             	sub    $0x4,%esp
  100160:	52                   	push   %edx
  100161:	50                   	push   %eax
  100162:	68 6b 33 10 00       	push   $0x10336b
  100167:	e8 8a 01 00 00       	call   1002f6 <cprintf>
  10016c:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  10016f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100172:	0f b7 d0             	movzwl %ax,%edx
  100175:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  10017a:	83 ec 04             	sub    $0x4,%esp
  10017d:	52                   	push   %edx
  10017e:	50                   	push   %eax
  10017f:	68 79 33 10 00       	push   $0x103379
  100184:	e8 6d 01 00 00       	call   1002f6 <cprintf>
  100189:	83 c4 10             	add    $0x10,%esp
    round ++;
  10018c:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100191:	40                   	inc    %eax
  100192:	a3 20 fa 10 00       	mov    %eax,0x10fa20
}
  100197:	90                   	nop
  100198:	c9                   	leave  
  100199:	c3                   	ret    

0010019a <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  10019a:	55                   	push   %ebp
  10019b:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  10019d:	90                   	nop
  10019e:	5d                   	pop    %ebp
  10019f:	c3                   	ret    

001001a0 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001a0:	55                   	push   %ebp
  1001a1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001a3:	90                   	nop
  1001a4:	5d                   	pop    %ebp
  1001a5:	c3                   	ret    

001001a6 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001a6:	55                   	push   %ebp
  1001a7:	89 e5                	mov    %esp,%ebp
  1001a9:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
  1001ac:	e8 30 ff ff ff       	call   1000e1 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001b1:	83 ec 0c             	sub    $0xc,%esp
  1001b4:	68 88 33 10 00       	push   $0x103388
  1001b9:	e8 38 01 00 00       	call   1002f6 <cprintf>
  1001be:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  1001c1:	e8 d4 ff ff ff       	call   10019a <lab1_switch_to_user>
    lab1_print_cur_status();
  1001c6:	e8 16 ff ff ff       	call   1000e1 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001cb:	83 ec 0c             	sub    $0xc,%esp
  1001ce:	68 a8 33 10 00       	push   $0x1033a8
  1001d3:	e8 1e 01 00 00       	call   1002f6 <cprintf>
  1001d8:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
  1001db:	e8 c0 ff ff ff       	call   1001a0 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  1001e0:	e8 fc fe ff ff       	call   1000e1 <lab1_print_cur_status>
}
  1001e5:	90                   	nop
  1001e6:	c9                   	leave  
  1001e7:	c3                   	ret    

001001e8 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  1001e8:	55                   	push   %ebp
  1001e9:	89 e5                	mov    %esp,%ebp
  1001eb:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
  1001ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1001f2:	74 13                	je     100207 <readline+0x1f>
        cprintf("%s", prompt);
  1001f4:	83 ec 08             	sub    $0x8,%esp
  1001f7:	ff 75 08             	pushl  0x8(%ebp)
  1001fa:	68 c7 33 10 00       	push   $0x1033c7
  1001ff:	e8 f2 00 00 00       	call   1002f6 <cprintf>
  100204:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
  100207:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  10020e:	e8 6d 01 00 00       	call   100380 <getchar>
  100213:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100216:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10021a:	79 0a                	jns    100226 <readline+0x3e>
            return NULL;
  10021c:	b8 00 00 00 00       	mov    $0x0,%eax
  100221:	e9 81 00 00 00       	jmp    1002a7 <readline+0xbf>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100226:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10022a:	7e 2b                	jle    100257 <readline+0x6f>
  10022c:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100233:	7f 22                	jg     100257 <readline+0x6f>
            cputchar(c);
  100235:	83 ec 0c             	sub    $0xc,%esp
  100238:	ff 75 f0             	pushl  -0x10(%ebp)
  10023b:	e8 dc 00 00 00       	call   10031c <cputchar>
  100240:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
  100243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100246:	8d 50 01             	lea    0x1(%eax),%edx
  100249:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10024c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10024f:	88 90 40 fa 10 00    	mov    %dl,0x10fa40(%eax)
  100255:	eb 4b                	jmp    1002a2 <readline+0xba>
        }
        else if (c == '\b' && i > 0) {
  100257:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10025b:	75 19                	jne    100276 <readline+0x8e>
  10025d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100261:	7e 13                	jle    100276 <readline+0x8e>
            cputchar(c);
  100263:	83 ec 0c             	sub    $0xc,%esp
  100266:	ff 75 f0             	pushl  -0x10(%ebp)
  100269:	e8 ae 00 00 00       	call   10031c <cputchar>
  10026e:	83 c4 10             	add    $0x10,%esp
            i --;
  100271:	ff 4d f4             	decl   -0xc(%ebp)
  100274:	eb 2c                	jmp    1002a2 <readline+0xba>
        }
        else if (c == '\n' || c == '\r') {
  100276:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  10027a:	74 06                	je     100282 <readline+0x9a>
  10027c:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  100280:	75 8c                	jne    10020e <readline+0x26>
            cputchar(c);
  100282:	83 ec 0c             	sub    $0xc,%esp
  100285:	ff 75 f0             	pushl  -0x10(%ebp)
  100288:	e8 8f 00 00 00       	call   10031c <cputchar>
  10028d:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
  100290:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100293:	05 40 fa 10 00       	add    $0x10fa40,%eax
  100298:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  10029b:	b8 40 fa 10 00       	mov    $0x10fa40,%eax
  1002a0:	eb 05                	jmp    1002a7 <readline+0xbf>
        c = getchar();
  1002a2:	e9 67 ff ff ff       	jmp    10020e <readline+0x26>
        }
    }
}
  1002a7:	c9                   	leave  
  1002a8:	c3                   	ret    

001002a9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002a9:	55                   	push   %ebp
  1002aa:	89 e5                	mov    %esp,%ebp
  1002ac:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  1002af:	83 ec 0c             	sub    $0xc,%esp
  1002b2:	ff 75 08             	pushl  0x8(%ebp)
  1002b5:	e8 5b 12 00 00       	call   101515 <cons_putc>
  1002ba:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  1002bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002c0:	8b 00                	mov    (%eax),%eax
  1002c2:	8d 50 01             	lea    0x1(%eax),%edx
  1002c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002c8:	89 10                	mov    %edx,(%eax)
}
  1002ca:	90                   	nop
  1002cb:	c9                   	leave  
  1002cc:	c3                   	ret    

001002cd <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002cd:	55                   	push   %ebp
  1002ce:	89 e5                	mov    %esp,%ebp
  1002d0:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  1002d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002da:	ff 75 0c             	pushl  0xc(%ebp)
  1002dd:	ff 75 08             	pushl  0x8(%ebp)
  1002e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1002e3:	50                   	push   %eax
  1002e4:	68 a9 02 10 00       	push   $0x1002a9
  1002e9:	e8 4c 27 00 00       	call   102a3a <vprintfmt>
  1002ee:	83 c4 10             	add    $0x10,%esp
    return cnt;
  1002f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002f4:	c9                   	leave  
  1002f5:	c3                   	ret    

001002f6 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  1002f6:	55                   	push   %ebp
  1002f7:	89 e5                	mov    %esp,%ebp
  1002f9:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1002fc:	8d 45 0c             	lea    0xc(%ebp),%eax
  1002ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100302:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100305:	83 ec 08             	sub    $0x8,%esp
  100308:	50                   	push   %eax
  100309:	ff 75 08             	pushl  0x8(%ebp)
  10030c:	e8 bc ff ff ff       	call   1002cd <vcprintf>
  100311:	83 c4 10             	add    $0x10,%esp
  100314:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100317:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10031a:	c9                   	leave  
  10031b:	c3                   	ret    

0010031c <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  10031c:	55                   	push   %ebp
  10031d:	89 e5                	mov    %esp,%ebp
  10031f:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100322:	83 ec 0c             	sub    $0xc,%esp
  100325:	ff 75 08             	pushl  0x8(%ebp)
  100328:	e8 e8 11 00 00       	call   101515 <cons_putc>
  10032d:	83 c4 10             	add    $0x10,%esp
}
  100330:	90                   	nop
  100331:	c9                   	leave  
  100332:	c3                   	ret    

00100333 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100333:	55                   	push   %ebp
  100334:	89 e5                	mov    %esp,%ebp
  100336:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  100339:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100340:	eb 14                	jmp    100356 <cputs+0x23>
        cputch(c, &cnt);
  100342:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100346:	83 ec 08             	sub    $0x8,%esp
  100349:	8d 55 f0             	lea    -0x10(%ebp),%edx
  10034c:	52                   	push   %edx
  10034d:	50                   	push   %eax
  10034e:	e8 56 ff ff ff       	call   1002a9 <cputch>
  100353:	83 c4 10             	add    $0x10,%esp
    while ((c = *str ++) != '\0') {
  100356:	8b 45 08             	mov    0x8(%ebp),%eax
  100359:	8d 50 01             	lea    0x1(%eax),%edx
  10035c:	89 55 08             	mov    %edx,0x8(%ebp)
  10035f:	8a 00                	mov    (%eax),%al
  100361:	88 45 f7             	mov    %al,-0x9(%ebp)
  100364:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100368:	75 d8                	jne    100342 <cputs+0xf>
    }
    cputch('\n', &cnt);
  10036a:	83 ec 08             	sub    $0x8,%esp
  10036d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100370:	50                   	push   %eax
  100371:	6a 0a                	push   $0xa
  100373:	e8 31 ff ff ff       	call   1002a9 <cputch>
  100378:	83 c4 10             	add    $0x10,%esp
    return cnt;
  10037b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  10037e:	c9                   	leave  
  10037f:	c3                   	ret    

00100380 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  100380:	55                   	push   %ebp
  100381:	89 e5                	mov    %esp,%ebp
  100383:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  100386:	90                   	nop
  100387:	e8 b9 11 00 00       	call   101545 <cons_getc>
  10038c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10038f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100393:	74 f2                	je     100387 <getchar+0x7>
        /* do nothing */;
    return c;
  100395:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100398:	c9                   	leave  
  100399:	c3                   	ret    

0010039a <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  10039a:	55                   	push   %ebp
  10039b:	89 e5                	mov    %esp,%ebp
  10039d:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003a3:	8b 00                	mov    (%eax),%eax
  1003a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003a8:	8b 45 10             	mov    0x10(%ebp),%eax
  1003ab:	8b 00                	mov    (%eax),%eax
  1003ad:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003b7:	e9 c9 00 00 00       	jmp    100485 <stab_binsearch+0xeb>
        int true_m = (l + r) / 2, m = true_m;
  1003bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1003bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1003c2:	01 d0                	add    %edx,%eax
  1003c4:	89 c2                	mov    %eax,%edx
  1003c6:	c1 ea 1f             	shr    $0x1f,%edx
  1003c9:	01 d0                	add    %edx,%eax
  1003cb:	d1 f8                	sar    %eax
  1003cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1003d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1003d3:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003d6:	eb 03                	jmp    1003db <stab_binsearch+0x41>
            m --;
  1003d8:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  1003db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003de:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1003e1:	7c 1e                	jl     100401 <stab_binsearch+0x67>
  1003e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1003e6:	89 d0                	mov    %edx,%eax
  1003e8:	01 c0                	add    %eax,%eax
  1003ea:	01 d0                	add    %edx,%eax
  1003ec:	c1 e0 02             	shl    $0x2,%eax
  1003ef:	89 c2                	mov    %eax,%edx
  1003f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1003f4:	01 d0                	add    %edx,%eax
  1003f6:	8a 40 04             	mov    0x4(%eax),%al
  1003f9:	0f b6 c0             	movzbl %al,%eax
  1003fc:	39 45 14             	cmp    %eax,0x14(%ebp)
  1003ff:	75 d7                	jne    1003d8 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  100401:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100404:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100407:	7d 09                	jge    100412 <stab_binsearch+0x78>
            l = true_m + 1;
  100409:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10040c:	40                   	inc    %eax
  10040d:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100410:	eb 73                	jmp    100485 <stab_binsearch+0xeb>
        }

        // actual binary search
        any_matches = 1;
  100412:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100419:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10041c:	89 d0                	mov    %edx,%eax
  10041e:	01 c0                	add    %eax,%eax
  100420:	01 d0                	add    %edx,%eax
  100422:	c1 e0 02             	shl    $0x2,%eax
  100425:	89 c2                	mov    %eax,%edx
  100427:	8b 45 08             	mov    0x8(%ebp),%eax
  10042a:	01 d0                	add    %edx,%eax
  10042c:	8b 40 08             	mov    0x8(%eax),%eax
  10042f:	39 45 18             	cmp    %eax,0x18(%ebp)
  100432:	76 11                	jbe    100445 <stab_binsearch+0xab>
            *region_left = m;
  100434:	8b 45 0c             	mov    0xc(%ebp),%eax
  100437:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10043a:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10043c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10043f:	40                   	inc    %eax
  100440:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100443:	eb 40                	jmp    100485 <stab_binsearch+0xeb>
        } else if (stabs[m].n_value > addr) {
  100445:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100448:	89 d0                	mov    %edx,%eax
  10044a:	01 c0                	add    %eax,%eax
  10044c:	01 d0                	add    %edx,%eax
  10044e:	c1 e0 02             	shl    $0x2,%eax
  100451:	89 c2                	mov    %eax,%edx
  100453:	8b 45 08             	mov    0x8(%ebp),%eax
  100456:	01 d0                	add    %edx,%eax
  100458:	8b 40 08             	mov    0x8(%eax),%eax
  10045b:	39 45 18             	cmp    %eax,0x18(%ebp)
  10045e:	73 14                	jae    100474 <stab_binsearch+0xda>
            *region_right = m - 1;
  100460:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100463:	8d 50 ff             	lea    -0x1(%eax),%edx
  100466:	8b 45 10             	mov    0x10(%ebp),%eax
  100469:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10046b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10046e:	48                   	dec    %eax
  10046f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100472:	eb 11                	jmp    100485 <stab_binsearch+0xeb>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100474:	8b 45 0c             	mov    0xc(%ebp),%eax
  100477:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10047a:	89 10                	mov    %edx,(%eax)
            l = m;
  10047c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10047f:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  100482:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  100485:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100488:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  10048b:	0f 8e 2b ff ff ff    	jle    1003bc <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  100491:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100495:	75 0f                	jne    1004a6 <stab_binsearch+0x10c>
        *region_right = *region_left - 1;
  100497:	8b 45 0c             	mov    0xc(%ebp),%eax
  10049a:	8b 00                	mov    (%eax),%eax
  10049c:	8d 50 ff             	lea    -0x1(%eax),%edx
  10049f:	8b 45 10             	mov    0x10(%ebp),%eax
  1004a2:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1004a4:	eb 3d                	jmp    1004e3 <stab_binsearch+0x149>
        l = *region_right;
  1004a6:	8b 45 10             	mov    0x10(%ebp),%eax
  1004a9:	8b 00                	mov    (%eax),%eax
  1004ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004ae:	eb 03                	jmp    1004b3 <stab_binsearch+0x119>
  1004b0:	ff 4d fc             	decl   -0x4(%ebp)
  1004b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004b6:	8b 00                	mov    (%eax),%eax
  1004b8:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1004bb:	7e 1e                	jle    1004db <stab_binsearch+0x141>
  1004bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004c0:	89 d0                	mov    %edx,%eax
  1004c2:	01 c0                	add    %eax,%eax
  1004c4:	01 d0                	add    %edx,%eax
  1004c6:	c1 e0 02             	shl    $0x2,%eax
  1004c9:	89 c2                	mov    %eax,%edx
  1004cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1004ce:	01 d0                	add    %edx,%eax
  1004d0:	8a 40 04             	mov    0x4(%eax),%al
  1004d3:	0f b6 c0             	movzbl %al,%eax
  1004d6:	39 45 14             	cmp    %eax,0x14(%ebp)
  1004d9:	75 d5                	jne    1004b0 <stab_binsearch+0x116>
        *region_left = l;
  1004db:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004de:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004e1:	89 10                	mov    %edx,(%eax)
}
  1004e3:	90                   	nop
  1004e4:	c9                   	leave  
  1004e5:	c3                   	ret    

001004e6 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1004e6:	55                   	push   %ebp
  1004e7:	89 e5                	mov    %esp,%ebp
  1004e9:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1004ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004ef:	c7 00 cc 33 10 00    	movl   $0x1033cc,(%eax)
    info->eip_line = 0;
  1004f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  1004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  100502:	c7 40 08 cc 33 10 00 	movl   $0x1033cc,0x8(%eax)
    info->eip_fn_namelen = 9;
  100509:	8b 45 0c             	mov    0xc(%ebp),%eax
  10050c:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100513:	8b 45 0c             	mov    0xc(%ebp),%eax
  100516:	8b 55 08             	mov    0x8(%ebp),%edx
  100519:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10051c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10051f:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100526:	c7 45 f4 2c 3c 10 00 	movl   $0x103c2c,-0xc(%ebp)
    stab_end = __STAB_END__;
  10052d:	c7 45 f0 28 c4 10 00 	movl   $0x10c428,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100534:	c7 45 ec 29 c4 10 00 	movl   $0x10c429,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10053b:	c7 45 e8 2f e5 10 00 	movl   $0x10e52f,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100542:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100545:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100548:	76 0a                	jbe    100554 <debuginfo_eip+0x6e>
  10054a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10054d:	48                   	dec    %eax
  10054e:	8a 00                	mov    (%eax),%al
  100550:	84 c0                	test   %al,%al
  100552:	74 0a                	je     10055e <debuginfo_eip+0x78>
        return -1;
  100554:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100559:	e9 99 02 00 00       	jmp    1007f7 <debuginfo_eip+0x311>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  10055e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100565:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100568:	2b 45 f4             	sub    -0xc(%ebp),%eax
  10056b:	c1 f8 02             	sar    $0x2,%eax
  10056e:	89 c2                	mov    %eax,%edx
  100570:	89 d0                	mov    %edx,%eax
  100572:	c1 e0 02             	shl    $0x2,%eax
  100575:	01 d0                	add    %edx,%eax
  100577:	c1 e0 02             	shl    $0x2,%eax
  10057a:	01 d0                	add    %edx,%eax
  10057c:	c1 e0 02             	shl    $0x2,%eax
  10057f:	01 d0                	add    %edx,%eax
  100581:	89 c1                	mov    %eax,%ecx
  100583:	c1 e1 08             	shl    $0x8,%ecx
  100586:	01 c8                	add    %ecx,%eax
  100588:	89 c1                	mov    %eax,%ecx
  10058a:	c1 e1 10             	shl    $0x10,%ecx
  10058d:	01 c8                	add    %ecx,%eax
  10058f:	01 c0                	add    %eax,%eax
  100591:	01 d0                	add    %edx,%eax
  100593:	48                   	dec    %eax
  100594:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  100597:	ff 75 08             	pushl  0x8(%ebp)
  10059a:	6a 64                	push   $0x64
  10059c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  10059f:	50                   	push   %eax
  1005a0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005a3:	50                   	push   %eax
  1005a4:	ff 75 f4             	pushl  -0xc(%ebp)
  1005a7:	e8 ee fd ff ff       	call   10039a <stab_binsearch>
  1005ac:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
  1005af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005b2:	85 c0                	test   %eax,%eax
  1005b4:	75 0a                	jne    1005c0 <debuginfo_eip+0xda>
        return -1;
  1005b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005bb:	e9 37 02 00 00       	jmp    1007f7 <debuginfo_eip+0x311>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1005c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1005c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1005cc:	ff 75 08             	pushl  0x8(%ebp)
  1005cf:	6a 24                	push   $0x24
  1005d1:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1005d4:	50                   	push   %eax
  1005d5:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1005d8:	50                   	push   %eax
  1005d9:	ff 75 f4             	pushl  -0xc(%ebp)
  1005dc:	e8 b9 fd ff ff       	call   10039a <stab_binsearch>
  1005e1:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
  1005e4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1005e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1005ea:	39 c2                	cmp    %eax,%edx
  1005ec:	7f 78                	jg     100666 <debuginfo_eip+0x180>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1005ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1005f1:	89 c2                	mov    %eax,%edx
  1005f3:	89 d0                	mov    %edx,%eax
  1005f5:	01 c0                	add    %eax,%eax
  1005f7:	01 d0                	add    %edx,%eax
  1005f9:	c1 e0 02             	shl    $0x2,%eax
  1005fc:	89 c2                	mov    %eax,%edx
  1005fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100601:	01 d0                	add    %edx,%eax
  100603:	8b 10                	mov    (%eax),%edx
  100605:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100608:	2b 45 ec             	sub    -0x14(%ebp),%eax
  10060b:	39 c2                	cmp    %eax,%edx
  10060d:	73 22                	jae    100631 <debuginfo_eip+0x14b>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10060f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100612:	89 c2                	mov    %eax,%edx
  100614:	89 d0                	mov    %edx,%eax
  100616:	01 c0                	add    %eax,%eax
  100618:	01 d0                	add    %edx,%eax
  10061a:	c1 e0 02             	shl    $0x2,%eax
  10061d:	89 c2                	mov    %eax,%edx
  10061f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100622:	01 d0                	add    %edx,%eax
  100624:	8b 10                	mov    (%eax),%edx
  100626:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100629:	01 c2                	add    %eax,%edx
  10062b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10062e:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100631:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100634:	89 c2                	mov    %eax,%edx
  100636:	89 d0                	mov    %edx,%eax
  100638:	01 c0                	add    %eax,%eax
  10063a:	01 d0                	add    %edx,%eax
  10063c:	c1 e0 02             	shl    $0x2,%eax
  10063f:	89 c2                	mov    %eax,%edx
  100641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100644:	01 d0                	add    %edx,%eax
  100646:	8b 50 08             	mov    0x8(%eax),%edx
  100649:	8b 45 0c             	mov    0xc(%ebp),%eax
  10064c:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  10064f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100652:	8b 40 10             	mov    0x10(%eax),%eax
  100655:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100658:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10065b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10065e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100661:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100664:	eb 15                	jmp    10067b <debuginfo_eip+0x195>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100666:	8b 45 0c             	mov    0xc(%ebp),%eax
  100669:	8b 55 08             	mov    0x8(%ebp),%edx
  10066c:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  10066f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100672:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100675:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100678:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  10067b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10067e:	8b 40 08             	mov    0x8(%eax),%eax
  100681:	83 ec 08             	sub    $0x8,%esp
  100684:	6a 3a                	push   $0x3a
  100686:	50                   	push   %eax
  100687:	e8 8e 29 00 00       	call   10301a <strfind>
  10068c:	83 c4 10             	add    $0x10,%esp
  10068f:	89 c2                	mov    %eax,%edx
  100691:	8b 45 0c             	mov    0xc(%ebp),%eax
  100694:	8b 40 08             	mov    0x8(%eax),%eax
  100697:	29 c2                	sub    %eax,%edx
  100699:	8b 45 0c             	mov    0xc(%ebp),%eax
  10069c:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  10069f:	83 ec 0c             	sub    $0xc,%esp
  1006a2:	ff 75 08             	pushl  0x8(%ebp)
  1006a5:	6a 44                	push   $0x44
  1006a7:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006aa:	50                   	push   %eax
  1006ab:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1006ae:	50                   	push   %eax
  1006af:	ff 75 f4             	pushl  -0xc(%ebp)
  1006b2:	e8 e3 fc ff ff       	call   10039a <stab_binsearch>
  1006b7:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
  1006ba:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1006bd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1006c0:	39 c2                	cmp    %eax,%edx
  1006c2:	7f 24                	jg     1006e8 <debuginfo_eip+0x202>
        info->eip_line = stabs[rline].n_desc;
  1006c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1006c7:	89 c2                	mov    %eax,%edx
  1006c9:	89 d0                	mov    %edx,%eax
  1006cb:	01 c0                	add    %eax,%eax
  1006cd:	01 d0                	add    %edx,%eax
  1006cf:	c1 e0 02             	shl    $0x2,%eax
  1006d2:	89 c2                	mov    %eax,%edx
  1006d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006d7:	01 d0                	add    %edx,%eax
  1006d9:	66 8b 40 06          	mov    0x6(%eax),%ax
  1006dd:	0f b7 d0             	movzwl %ax,%edx
  1006e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006e3:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1006e6:	eb 11                	jmp    1006f9 <debuginfo_eip+0x213>
        return -1;
  1006e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006ed:	e9 05 01 00 00       	jmp    1007f7 <debuginfo_eip+0x311>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  1006f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1006f5:	48                   	dec    %eax
  1006f6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  1006f9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1006fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006ff:	39 c2                	cmp    %eax,%edx
  100701:	7c 54                	jl     100757 <debuginfo_eip+0x271>
           && stabs[lline].n_type != N_SOL
  100703:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100706:	89 c2                	mov    %eax,%edx
  100708:	89 d0                	mov    %edx,%eax
  10070a:	01 c0                	add    %eax,%eax
  10070c:	01 d0                	add    %edx,%eax
  10070e:	c1 e0 02             	shl    $0x2,%eax
  100711:	89 c2                	mov    %eax,%edx
  100713:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100716:	01 d0                	add    %edx,%eax
  100718:	8a 40 04             	mov    0x4(%eax),%al
  10071b:	3c 84                	cmp    $0x84,%al
  10071d:	74 38                	je     100757 <debuginfo_eip+0x271>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10071f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100722:	89 c2                	mov    %eax,%edx
  100724:	89 d0                	mov    %edx,%eax
  100726:	01 c0                	add    %eax,%eax
  100728:	01 d0                	add    %edx,%eax
  10072a:	c1 e0 02             	shl    $0x2,%eax
  10072d:	89 c2                	mov    %eax,%edx
  10072f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100732:	01 d0                	add    %edx,%eax
  100734:	8a 40 04             	mov    0x4(%eax),%al
  100737:	3c 64                	cmp    $0x64,%al
  100739:	75 b7                	jne    1006f2 <debuginfo_eip+0x20c>
  10073b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10073e:	89 c2                	mov    %eax,%edx
  100740:	89 d0                	mov    %edx,%eax
  100742:	01 c0                	add    %eax,%eax
  100744:	01 d0                	add    %edx,%eax
  100746:	c1 e0 02             	shl    $0x2,%eax
  100749:	89 c2                	mov    %eax,%edx
  10074b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10074e:	01 d0                	add    %edx,%eax
  100750:	8b 40 08             	mov    0x8(%eax),%eax
  100753:	85 c0                	test   %eax,%eax
  100755:	74 9b                	je     1006f2 <debuginfo_eip+0x20c>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  100757:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10075a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10075d:	39 c2                	cmp    %eax,%edx
  10075f:	7c 42                	jl     1007a3 <debuginfo_eip+0x2bd>
  100761:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100764:	89 c2                	mov    %eax,%edx
  100766:	89 d0                	mov    %edx,%eax
  100768:	01 c0                	add    %eax,%eax
  10076a:	01 d0                	add    %edx,%eax
  10076c:	c1 e0 02             	shl    $0x2,%eax
  10076f:	89 c2                	mov    %eax,%edx
  100771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100774:	01 d0                	add    %edx,%eax
  100776:	8b 10                	mov    (%eax),%edx
  100778:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10077b:	2b 45 ec             	sub    -0x14(%ebp),%eax
  10077e:	39 c2                	cmp    %eax,%edx
  100780:	73 21                	jae    1007a3 <debuginfo_eip+0x2bd>
        info->eip_file = stabstr + stabs[lline].n_strx;
  100782:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100785:	89 c2                	mov    %eax,%edx
  100787:	89 d0                	mov    %edx,%eax
  100789:	01 c0                	add    %eax,%eax
  10078b:	01 d0                	add    %edx,%eax
  10078d:	c1 e0 02             	shl    $0x2,%eax
  100790:	89 c2                	mov    %eax,%edx
  100792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100795:	01 d0                	add    %edx,%eax
  100797:	8b 10                	mov    (%eax),%edx
  100799:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10079c:	01 c2                	add    %eax,%edx
  10079e:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007a1:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007a3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007a6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007a9:	39 c2                	cmp    %eax,%edx
  1007ab:	7d 45                	jge    1007f2 <debuginfo_eip+0x30c>
        for (lline = lfun + 1;
  1007ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007b0:	40                   	inc    %eax
  1007b1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1007b4:	eb 16                	jmp    1007cc <debuginfo_eip+0x2e6>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1007b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007b9:	8b 40 14             	mov    0x14(%eax),%eax
  1007bc:	8d 50 01             	lea    0x1(%eax),%edx
  1007bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007c2:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  1007c5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007c8:	40                   	inc    %eax
  1007c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1007cc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  1007d2:	39 c2                	cmp    %eax,%edx
  1007d4:	7d 1c                	jge    1007f2 <debuginfo_eip+0x30c>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1007d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d9:	89 c2                	mov    %eax,%edx
  1007db:	89 d0                	mov    %edx,%eax
  1007dd:	01 c0                	add    %eax,%eax
  1007df:	01 d0                	add    %edx,%eax
  1007e1:	c1 e0 02             	shl    $0x2,%eax
  1007e4:	89 c2                	mov    %eax,%edx
  1007e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e9:	01 d0                	add    %edx,%eax
  1007eb:	8a 40 04             	mov    0x4(%eax),%al
  1007ee:	3c a0                	cmp    $0xa0,%al
  1007f0:	74 c4                	je     1007b6 <debuginfo_eip+0x2d0>
        }
    }
    return 0;
  1007f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1007f7:	c9                   	leave  
  1007f8:	c3                   	ret    

001007f9 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  1007f9:	55                   	push   %ebp
  1007fa:	89 e5                	mov    %esp,%ebp
  1007fc:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  1007ff:	83 ec 0c             	sub    $0xc,%esp
  100802:	68 d6 33 10 00       	push   $0x1033d6
  100807:	e8 ea fa ff ff       	call   1002f6 <cprintf>
  10080c:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10080f:	83 ec 08             	sub    $0x8,%esp
  100812:	68 00 00 10 00       	push   $0x100000
  100817:	68 ef 33 10 00       	push   $0x1033ef
  10081c:	e8 d5 fa ff ff       	call   1002f6 <cprintf>
  100821:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  100824:	83 ec 08             	sub    $0x8,%esp
  100827:	68 10 33 10 00       	push   $0x103310
  10082c:	68 07 34 10 00       	push   $0x103407
  100831:	e8 c0 fa ff ff       	call   1002f6 <cprintf>
  100836:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100839:	83 ec 08             	sub    $0x8,%esp
  10083c:	68 16 fa 10 00       	push   $0x10fa16
  100841:	68 1f 34 10 00       	push   $0x10341f
  100846:	e8 ab fa ff ff       	call   1002f6 <cprintf>
  10084b:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  10084e:	83 ec 08             	sub    $0x8,%esp
  100851:	68 20 0d 11 00       	push   $0x110d20
  100856:	68 37 34 10 00       	push   $0x103437
  10085b:	e8 96 fa ff ff       	call   1002f6 <cprintf>
  100860:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100863:	b8 20 0d 11 00       	mov    $0x110d20,%eax
  100868:	2d 00 00 10 00       	sub    $0x100000,%eax
  10086d:	05 ff 03 00 00       	add    $0x3ff,%eax
  100872:	85 c0                	test   %eax,%eax
  100874:	79 05                	jns    10087b <print_kerninfo+0x82>
  100876:	05 ff 03 00 00       	add    $0x3ff,%eax
  10087b:	c1 f8 0a             	sar    $0xa,%eax
  10087e:	83 ec 08             	sub    $0x8,%esp
  100881:	50                   	push   %eax
  100882:	68 50 34 10 00       	push   $0x103450
  100887:	e8 6a fa ff ff       	call   1002f6 <cprintf>
  10088c:	83 c4 10             	add    $0x10,%esp
}
  10088f:	90                   	nop
  100890:	c9                   	leave  
  100891:	c3                   	ret    

00100892 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100892:	55                   	push   %ebp
  100893:	89 e5                	mov    %esp,%ebp
  100895:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10089b:	83 ec 08             	sub    $0x8,%esp
  10089e:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008a1:	50                   	push   %eax
  1008a2:	ff 75 08             	pushl  0x8(%ebp)
  1008a5:	e8 3c fc ff ff       	call   1004e6 <debuginfo_eip>
  1008aa:	83 c4 10             	add    $0x10,%esp
  1008ad:	85 c0                	test   %eax,%eax
  1008af:	74 15                	je     1008c6 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1008b1:	83 ec 08             	sub    $0x8,%esp
  1008b4:	ff 75 08             	pushl  0x8(%ebp)
  1008b7:	68 7a 34 10 00       	push   $0x10347a
  1008bc:	e8 35 fa ff ff       	call   1002f6 <cprintf>
  1008c1:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  1008c4:	eb 63                	jmp    100929 <print_debuginfo+0x97>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1008c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1008cd:	eb 1a                	jmp    1008e9 <print_debuginfo+0x57>
            fnname[j] = info.eip_fn_name[j];
  1008cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1008d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008d5:	01 d0                	add    %edx,%eax
  1008d7:	8a 00                	mov    (%eax),%al
  1008d9:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1008df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1008e2:	01 ca                	add    %ecx,%edx
  1008e4:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1008e6:	ff 45 f4             	incl   -0xc(%ebp)
  1008e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1008ec:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1008ef:	7c de                	jl     1008cf <print_debuginfo+0x3d>
        fnname[j] = '\0';
  1008f1:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  1008f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008fa:	01 d0                	add    %edx,%eax
  1008fc:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  1008ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100902:	8b 55 08             	mov    0x8(%ebp),%edx
  100905:	89 d1                	mov    %edx,%ecx
  100907:	29 c1                	sub    %eax,%ecx
  100909:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10090c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10090f:	83 ec 0c             	sub    $0xc,%esp
  100912:	51                   	push   %ecx
  100913:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100919:	51                   	push   %ecx
  10091a:	52                   	push   %edx
  10091b:	50                   	push   %eax
  10091c:	68 96 34 10 00       	push   $0x103496
  100921:	e8 d0 f9 ff ff       	call   1002f6 <cprintf>
  100926:	83 c4 20             	add    $0x20,%esp
}
  100929:	90                   	nop
  10092a:	c9                   	leave  
  10092b:	c3                   	ret    

0010092c <read_eip>:

static __noinline uint32_t
read_eip(void) {
  10092c:	55                   	push   %ebp
  10092d:	89 e5                	mov    %esp,%ebp
  10092f:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100932:	8b 45 04             	mov    0x4(%ebp),%eax
  100935:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100938:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10093b:	c9                   	leave  
  10093c:	c3                   	ret    

0010093d <print_stackframe>:
 上一层[ebp]   <-------- [esp/当前ebp]
 局部变量      低位地址
 参考资料：https://www.jianshu.com/p/8e3c962af1a6
 */
void
print_stackframe(void) {
  10093d:	55                   	push   %ebp
  10093e:	89 e5                	mov    %esp,%ebp
  100940:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100943:	89 e8                	mov    %ebp,%eax
  100945:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  100948:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    /* LAB1 2017011313 : STEP 1 */
    uint32_t curr_ebp, curr_eip;
    // (1) call read_ebp() to get the value of ebp. the type is (uint32_t)
    curr_ebp = read_ebp();
  10094b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    // (2) call read_eip() to get the value of eip. the type is (uint32_t);
    curr_eip = read_eip();
  10094e:	e8 d9 ff ff ff       	call   10092c <read_eip>
  100953:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // (3) from 0 .. STACKFRAME_DEPTH
    for (int stack_level = 0; stack_level <= STACKFRAME_DEPTH; ++stack_level) {
  100956:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  10095d:	e9 91 00 00 00       	jmp    1009f3 <print_stackframe+0xb6>
        // (3.1) printf value of ebp, eip
        cprintf("ebp: 0x%08x eip: 0x%08x ", curr_ebp, curr_eip);
  100962:	83 ec 04             	sub    $0x4,%esp
  100965:	ff 75 f0             	pushl  -0x10(%ebp)
  100968:	ff 75 f4             	pushl  -0xc(%ebp)
  10096b:	68 a8 34 10 00       	push   $0x1034a8
  100970:	e8 81 f9 ff ff       	call   1002f6 <cprintf>
  100975:	83 c4 10             	add    $0x10,%esp
        // (3.2) (uint32_t)calling arguments [0..4] = the contents in address (uint32_t)ebp +2 [0..4]
        cprintf("args:");
  100978:	83 ec 0c             	sub    $0xc,%esp
  10097b:	68 c1 34 10 00       	push   $0x1034c1
  100980:	e8 71 f9 ff ff       	call   1002f6 <cprintf>
  100985:	83 c4 10             	add    $0x10,%esp
        // 未定义uint_32与整数的加法，且sizeof(uint_32) == 4，故先转换位指针再做加法。后面同理。
        for (int arg_num = 0; arg_num < 4; ++arg_num)
  100988:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  10098f:	eb 28                	jmp    1009b9 <print_stackframe+0x7c>
            cprintf("0x%8x ", *((uint32_t*)curr_ebp + 2 + arg_num));
  100991:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100994:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10099b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10099e:	01 d0                	add    %edx,%eax
  1009a0:	83 c0 08             	add    $0x8,%eax
  1009a3:	8b 00                	mov    (%eax),%eax
  1009a5:	83 ec 08             	sub    $0x8,%esp
  1009a8:	50                   	push   %eax
  1009a9:	68 c7 34 10 00       	push   $0x1034c7
  1009ae:	e8 43 f9 ff ff       	call   1002f6 <cprintf>
  1009b3:	83 c4 10             	add    $0x10,%esp
        for (int arg_num = 0; arg_num < 4; ++arg_num)
  1009b6:	ff 45 e8             	incl   -0x18(%ebp)
  1009b9:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  1009bd:	7e d2                	jle    100991 <print_stackframe+0x54>
        // (3.3) cprintf("\n");
        cprintf("\n");
  1009bf:	83 ec 0c             	sub    $0xc,%esp
  1009c2:	68 ce 34 10 00       	push   $0x1034ce
  1009c7:	e8 2a f9 ff ff       	call   1002f6 <cprintf>
  1009cc:	83 c4 10             	add    $0x10,%esp
        // (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
        print_debuginfo(curr_eip);
  1009cf:	83 ec 0c             	sub    $0xc,%esp
  1009d2:	ff 75 f0             	pushl  -0x10(%ebp)
  1009d5:	e8 b8 fe ff ff       	call   100892 <print_debuginfo>
  1009da:	83 c4 10             	add    $0x10,%esp
        // (3.5) popup a calling stackframe
        //           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
        //                   the calling funciton's ebp = ss:[ebp]
        curr_eip = *((uint32_t*)curr_ebp + 1);
  1009dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009e0:	83 c0 04             	add    $0x4,%eax
  1009e3:	8b 00                	mov    (%eax),%eax
  1009e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
        curr_ebp = *((uint32_t*)curr_ebp);
  1009e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009eb:	8b 00                	mov    (%eax),%eax
  1009ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (int stack_level = 0; stack_level <= STACKFRAME_DEPTH; ++stack_level) {
  1009f0:	ff 45 ec             	incl   -0x14(%ebp)
  1009f3:	83 7d ec 14          	cmpl   $0x14,-0x14(%ebp)
  1009f7:	0f 8e 65 ff ff ff    	jle    100962 <print_stackframe+0x25>
    }
}
  1009fd:	90                   	nop
  1009fe:	c9                   	leave  
  1009ff:	c3                   	ret    

00100a00 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a00:	55                   	push   %ebp
  100a01:	89 e5                	mov    %esp,%ebp
  100a03:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
  100a06:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a0d:	eb 0c                	jmp    100a1b <parse+0x1b>
            *buf ++ = '\0';
  100a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  100a12:	8d 50 01             	lea    0x1(%eax),%edx
  100a15:	89 55 08             	mov    %edx,0x8(%ebp)
  100a18:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  100a1e:	8a 00                	mov    (%eax),%al
  100a20:	84 c0                	test   %al,%al
  100a22:	74 1d                	je     100a41 <parse+0x41>
  100a24:	8b 45 08             	mov    0x8(%ebp),%eax
  100a27:	8a 00                	mov    (%eax),%al
  100a29:	0f be c0             	movsbl %al,%eax
  100a2c:	83 ec 08             	sub    $0x8,%esp
  100a2f:	50                   	push   %eax
  100a30:	68 50 35 10 00       	push   $0x103550
  100a35:	e8 b0 25 00 00       	call   102fea <strchr>
  100a3a:	83 c4 10             	add    $0x10,%esp
  100a3d:	85 c0                	test   %eax,%eax
  100a3f:	75 ce                	jne    100a0f <parse+0xf>
        }
        if (*buf == '\0') {
  100a41:	8b 45 08             	mov    0x8(%ebp),%eax
  100a44:	8a 00                	mov    (%eax),%al
  100a46:	84 c0                	test   %al,%al
  100a48:	74 62                	je     100aac <parse+0xac>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100a4a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100a4e:	75 12                	jne    100a62 <parse+0x62>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100a50:	83 ec 08             	sub    $0x8,%esp
  100a53:	6a 10                	push   $0x10
  100a55:	68 55 35 10 00       	push   $0x103555
  100a5a:	e8 97 f8 ff ff       	call   1002f6 <cprintf>
  100a5f:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a65:	8d 50 01             	lea    0x1(%eax),%edx
  100a68:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100a6b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a72:	8b 45 0c             	mov    0xc(%ebp),%eax
  100a75:	01 c2                	add    %eax,%edx
  100a77:	8b 45 08             	mov    0x8(%ebp),%eax
  100a7a:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100a7c:	eb 03                	jmp    100a81 <parse+0x81>
            buf ++;
  100a7e:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100a81:	8b 45 08             	mov    0x8(%ebp),%eax
  100a84:	8a 00                	mov    (%eax),%al
  100a86:	84 c0                	test   %al,%al
  100a88:	74 91                	je     100a1b <parse+0x1b>
  100a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  100a8d:	8a 00                	mov    (%eax),%al
  100a8f:	0f be c0             	movsbl %al,%eax
  100a92:	83 ec 08             	sub    $0x8,%esp
  100a95:	50                   	push   %eax
  100a96:	68 50 35 10 00       	push   $0x103550
  100a9b:	e8 4a 25 00 00       	call   102fea <strchr>
  100aa0:	83 c4 10             	add    $0x10,%esp
  100aa3:	85 c0                	test   %eax,%eax
  100aa5:	74 d7                	je     100a7e <parse+0x7e>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100aa7:	e9 6f ff ff ff       	jmp    100a1b <parse+0x1b>
            break;
  100aac:	90                   	nop
        }
    }
    return argc;
  100aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100ab0:	c9                   	leave  
  100ab1:	c3                   	ret    

00100ab2 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100ab2:	55                   	push   %ebp
  100ab3:	89 e5                	mov    %esp,%ebp
  100ab5:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100ab8:	83 ec 08             	sub    $0x8,%esp
  100abb:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100abe:	50                   	push   %eax
  100abf:	ff 75 08             	pushl  0x8(%ebp)
  100ac2:	e8 39 ff ff ff       	call   100a00 <parse>
  100ac7:	83 c4 10             	add    $0x10,%esp
  100aca:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100acd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100ad1:	75 0a                	jne    100add <runcmd+0x2b>
        return 0;
  100ad3:	b8 00 00 00 00       	mov    $0x0,%eax
  100ad8:	e9 80 00 00 00       	jmp    100b5d <runcmd+0xab>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100add:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100ae4:	eb 56                	jmp    100b3c <runcmd+0x8a>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100ae6:	8b 55 b0             	mov    -0x50(%ebp),%edx
  100ae9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100aec:	89 c8                	mov    %ecx,%eax
  100aee:	01 c0                	add    %eax,%eax
  100af0:	01 c8                	add    %ecx,%eax
  100af2:	c1 e0 02             	shl    $0x2,%eax
  100af5:	05 00 f0 10 00       	add    $0x10f000,%eax
  100afa:	8b 00                	mov    (%eax),%eax
  100afc:	83 ec 08             	sub    $0x8,%esp
  100aff:	52                   	push   %edx
  100b00:	50                   	push   %eax
  100b01:	e8 4c 24 00 00       	call   102f52 <strcmp>
  100b06:	83 c4 10             	add    $0x10,%esp
  100b09:	85 c0                	test   %eax,%eax
  100b0b:	75 2c                	jne    100b39 <runcmd+0x87>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b10:	89 d0                	mov    %edx,%eax
  100b12:	01 c0                	add    %eax,%eax
  100b14:	01 d0                	add    %edx,%eax
  100b16:	c1 e0 02             	shl    $0x2,%eax
  100b19:	05 08 f0 10 00       	add    $0x10f008,%eax
  100b1e:	8b 10                	mov    (%eax),%edx
  100b20:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b23:	83 c0 04             	add    $0x4,%eax
  100b26:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100b29:	49                   	dec    %ecx
  100b2a:	83 ec 04             	sub    $0x4,%esp
  100b2d:	ff 75 0c             	pushl  0xc(%ebp)
  100b30:	50                   	push   %eax
  100b31:	51                   	push   %ecx
  100b32:	ff d2                	call   *%edx
  100b34:	83 c4 10             	add    $0x10,%esp
  100b37:	eb 24                	jmp    100b5d <runcmd+0xab>
    for (i = 0; i < NCOMMANDS; i ++) {
  100b39:	ff 45 f4             	incl   -0xc(%ebp)
  100b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b3f:	83 f8 02             	cmp    $0x2,%eax
  100b42:	76 a2                	jbe    100ae6 <runcmd+0x34>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100b44:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100b47:	83 ec 08             	sub    $0x8,%esp
  100b4a:	50                   	push   %eax
  100b4b:	68 73 35 10 00       	push   $0x103573
  100b50:	e8 a1 f7 ff ff       	call   1002f6 <cprintf>
  100b55:	83 c4 10             	add    $0x10,%esp
    return 0;
  100b58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100b5d:	c9                   	leave  
  100b5e:	c3                   	ret    

00100b5f <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100b5f:	55                   	push   %ebp
  100b60:	89 e5                	mov    %esp,%ebp
  100b62:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100b65:	83 ec 0c             	sub    $0xc,%esp
  100b68:	68 8c 35 10 00       	push   $0x10358c
  100b6d:	e8 84 f7 ff ff       	call   1002f6 <cprintf>
  100b72:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100b75:	83 ec 0c             	sub    $0xc,%esp
  100b78:	68 b4 35 10 00       	push   $0x1035b4
  100b7d:	e8 74 f7 ff ff       	call   1002f6 <cprintf>
  100b82:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100b85:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100b89:	74 0e                	je     100b99 <kmonitor+0x3a>
        print_trapframe(tf);
  100b8b:	83 ec 0c             	sub    $0xc,%esp
  100b8e:	ff 75 08             	pushl  0x8(%ebp)
  100b91:	e8 81 0d 00 00       	call   101917 <print_trapframe>
  100b96:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100b99:	83 ec 0c             	sub    $0xc,%esp
  100b9c:	68 d9 35 10 00       	push   $0x1035d9
  100ba1:	e8 42 f6 ff ff       	call   1001e8 <readline>
  100ba6:	83 c4 10             	add    $0x10,%esp
  100ba9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100bac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100bb0:	74 e7                	je     100b99 <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
  100bb2:	83 ec 08             	sub    $0x8,%esp
  100bb5:	ff 75 08             	pushl  0x8(%ebp)
  100bb8:	ff 75 f4             	pushl  -0xc(%ebp)
  100bbb:	e8 f2 fe ff ff       	call   100ab2 <runcmd>
  100bc0:	83 c4 10             	add    $0x10,%esp
  100bc3:	85 c0                	test   %eax,%eax
  100bc5:	78 02                	js     100bc9 <kmonitor+0x6a>
        if ((buf = readline("K> ")) != NULL) {
  100bc7:	eb d0                	jmp    100b99 <kmonitor+0x3a>
                break;
  100bc9:	90                   	nop
            }
        }
    }
}
  100bca:	90                   	nop
  100bcb:	c9                   	leave  
  100bcc:	c3                   	ret    

00100bcd <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100bcd:	55                   	push   %ebp
  100bce:	89 e5                	mov    %esp,%ebp
  100bd0:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bd3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100bda:	eb 3b                	jmp    100c17 <mon_help+0x4a>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100bdc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bdf:	89 d0                	mov    %edx,%eax
  100be1:	01 c0                	add    %eax,%eax
  100be3:	01 d0                	add    %edx,%eax
  100be5:	c1 e0 02             	shl    $0x2,%eax
  100be8:	05 04 f0 10 00       	add    $0x10f004,%eax
  100bed:	8b 10                	mov    (%eax),%edx
  100bef:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100bf2:	89 c8                	mov    %ecx,%eax
  100bf4:	01 c0                	add    %eax,%eax
  100bf6:	01 c8                	add    %ecx,%eax
  100bf8:	c1 e0 02             	shl    $0x2,%eax
  100bfb:	05 00 f0 10 00       	add    $0x10f000,%eax
  100c00:	8b 00                	mov    (%eax),%eax
  100c02:	83 ec 04             	sub    $0x4,%esp
  100c05:	52                   	push   %edx
  100c06:	50                   	push   %eax
  100c07:	68 dd 35 10 00       	push   $0x1035dd
  100c0c:	e8 e5 f6 ff ff       	call   1002f6 <cprintf>
  100c11:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NCOMMANDS; i ++) {
  100c14:	ff 45 f4             	incl   -0xc(%ebp)
  100c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c1a:	83 f8 02             	cmp    $0x2,%eax
  100c1d:	76 bd                	jbe    100bdc <mon_help+0xf>
    }
    return 0;
  100c1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c24:	c9                   	leave  
  100c25:	c3                   	ret    

00100c26 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c26:	55                   	push   %ebp
  100c27:	89 e5                	mov    %esp,%ebp
  100c29:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c2c:	e8 c8 fb ff ff       	call   1007f9 <print_kerninfo>
    return 0;
  100c31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c36:	c9                   	leave  
  100c37:	c3                   	ret    

00100c38 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100c38:	55                   	push   %ebp
  100c39:	89 e5                	mov    %esp,%ebp
  100c3b:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100c3e:	e8 fa fc ff ff       	call   10093d <print_stackframe>
    return 0;
  100c43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c48:	c9                   	leave  
  100c49:	c3                   	ret    

00100c4a <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100c4a:	55                   	push   %ebp
  100c4b:	89 e5                	mov    %esp,%ebp
  100c4d:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
  100c50:	a1 40 fe 10 00       	mov    0x10fe40,%eax
  100c55:	85 c0                	test   %eax,%eax
  100c57:	75 5f                	jne    100cb8 <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
  100c59:	c7 05 40 fe 10 00 01 	movl   $0x1,0x10fe40
  100c60:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100c63:	8d 45 14             	lea    0x14(%ebp),%eax
  100c66:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100c69:	83 ec 04             	sub    $0x4,%esp
  100c6c:	ff 75 0c             	pushl  0xc(%ebp)
  100c6f:	ff 75 08             	pushl  0x8(%ebp)
  100c72:	68 e6 35 10 00       	push   $0x1035e6
  100c77:	e8 7a f6 ff ff       	call   1002f6 <cprintf>
  100c7c:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c82:	83 ec 08             	sub    $0x8,%esp
  100c85:	50                   	push   %eax
  100c86:	ff 75 10             	pushl  0x10(%ebp)
  100c89:	e8 3f f6 ff ff       	call   1002cd <vcprintf>
  100c8e:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100c91:	83 ec 0c             	sub    $0xc,%esp
  100c94:	68 02 36 10 00       	push   $0x103602
  100c99:	e8 58 f6 ff ff       	call   1002f6 <cprintf>
  100c9e:	83 c4 10             	add    $0x10,%esp
    
    cprintf("stack trackback:\n");
  100ca1:	83 ec 0c             	sub    $0xc,%esp
  100ca4:	68 04 36 10 00       	push   $0x103604
  100ca9:	e8 48 f6 ff ff       	call   1002f6 <cprintf>
  100cae:	83 c4 10             	add    $0x10,%esp
    print_stackframe();
  100cb1:	e8 87 fc ff ff       	call   10093d <print_stackframe>
  100cb6:	eb 01                	jmp    100cb9 <__panic+0x6f>
        goto panic_dead;
  100cb8:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  100cb9:	e8 e9 08 00 00       	call   1015a7 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100cbe:	83 ec 0c             	sub    $0xc,%esp
  100cc1:	6a 00                	push   $0x0
  100cc3:	e8 97 fe ff ff       	call   100b5f <kmonitor>
  100cc8:	83 c4 10             	add    $0x10,%esp
  100ccb:	eb f1                	jmp    100cbe <__panic+0x74>

00100ccd <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100ccd:	55                   	push   %ebp
  100cce:	89 e5                	mov    %esp,%ebp
  100cd0:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
  100cd3:	8d 45 14             	lea    0x14(%ebp),%eax
  100cd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100cd9:	83 ec 04             	sub    $0x4,%esp
  100cdc:	ff 75 0c             	pushl  0xc(%ebp)
  100cdf:	ff 75 08             	pushl  0x8(%ebp)
  100ce2:	68 16 36 10 00       	push   $0x103616
  100ce7:	e8 0a f6 ff ff       	call   1002f6 <cprintf>
  100cec:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cf2:	83 ec 08             	sub    $0x8,%esp
  100cf5:	50                   	push   %eax
  100cf6:	ff 75 10             	pushl  0x10(%ebp)
  100cf9:	e8 cf f5 ff ff       	call   1002cd <vcprintf>
  100cfe:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100d01:	83 ec 0c             	sub    $0xc,%esp
  100d04:	68 02 36 10 00       	push   $0x103602
  100d09:	e8 e8 f5 ff ff       	call   1002f6 <cprintf>
  100d0e:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  100d11:	90                   	nop
  100d12:	c9                   	leave  
  100d13:	c3                   	ret    

00100d14 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d14:	55                   	push   %ebp
  100d15:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d17:	a1 40 fe 10 00       	mov    0x10fe40,%eax
}
  100d1c:	5d                   	pop    %ebp
  100d1d:	c3                   	ret    

00100d1e <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d1e:	55                   	push   %ebp
  100d1f:	89 e5                	mov    %esp,%ebp
  100d21:	83 ec 18             	sub    $0x18,%esp
  100d24:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100d2a:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d2e:	8a 45 ed             	mov    -0x13(%ebp),%al
  100d31:	66 8b 55 ee          	mov    -0x12(%ebp),%dx
  100d35:	ee                   	out    %al,(%dx)
  100d36:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d3c:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d40:	8a 45 f1             	mov    -0xf(%ebp),%al
  100d43:	66 8b 55 f2          	mov    -0xe(%ebp),%dx
  100d47:	ee                   	out    %al,(%dx)
  100d48:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100d4e:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
  100d52:	8a 45 f5             	mov    -0xb(%ebp),%al
  100d55:	66 8b 55 f6          	mov    -0xa(%ebp),%dx
  100d59:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d5a:	c7 05 08 09 11 00 00 	movl   $0x0,0x110908
  100d61:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d64:	83 ec 0c             	sub    $0xc,%esp
  100d67:	68 34 36 10 00       	push   $0x103634
  100d6c:	e8 85 f5 ff ff       	call   1002f6 <cprintf>
  100d71:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100d74:	83 ec 0c             	sub    $0xc,%esp
  100d77:	6a 00                	push   $0x0
  100d79:	e8 84 08 00 00       	call   101602 <pic_enable>
  100d7e:	83 c4 10             	add    $0x10,%esp
}
  100d81:	90                   	nop
  100d82:	c9                   	leave  
  100d83:	c3                   	ret    

00100d84 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100d84:	55                   	push   %ebp
  100d85:	89 e5                	mov    %esp,%ebp
  100d87:	83 ec 10             	sub    $0x10,%esp
  100d8a:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100d90:	66 8b 45 f2          	mov    -0xe(%ebp),%ax
  100d94:	89 c2                	mov    %eax,%edx
  100d96:	ec                   	in     (%dx),%al
  100d97:	88 45 f1             	mov    %al,-0xf(%ebp)
  100d9a:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100da0:	66 8b 45 f6          	mov    -0xa(%ebp),%ax
  100da4:	89 c2                	mov    %eax,%edx
  100da6:	ec                   	in     (%dx),%al
  100da7:	88 45 f5             	mov    %al,-0xb(%ebp)
  100daa:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100db0:	66 8b 45 fa          	mov    -0x6(%ebp),%ax
  100db4:	89 c2                	mov    %eax,%edx
  100db6:	ec                   	in     (%dx),%al
  100db7:	88 45 f9             	mov    %al,-0x7(%ebp)
  100dba:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100dc0:	66 8b 45 fe          	mov    -0x2(%ebp),%ax
  100dc4:	89 c2                	mov    %eax,%edx
  100dc6:	ec                   	in     (%dx),%al
  100dc7:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100dca:	90                   	nop
  100dcb:	c9                   	leave  
  100dcc:	c3                   	ret    

00100dcd <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100dcd:	55                   	push   %ebp
  100dce:	89 e5                	mov    %esp,%ebp
  100dd0:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100dd3:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100dda:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ddd:	66 8b 00             	mov    (%eax),%ax
  100de0:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100de4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100de7:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100dec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100def:	66 8b 00             	mov    (%eax),%ax
  100df2:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100df6:	74 12                	je     100e0a <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100df8:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100dff:	66 c7 05 66 fe 10 00 	movw   $0x3b4,0x10fe66
  100e06:	b4 03 
  100e08:	eb 13                	jmp    100e1d <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e0a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100e0d:	66 8b 45 fa          	mov    -0x6(%ebp),%ax
  100e11:	66 89 02             	mov    %ax,(%edx)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e14:	66 c7 05 66 fe 10 00 	movw   $0x3d4,0x10fe66
  100e1b:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e1d:	66 a1 66 fe 10 00    	mov    0x10fe66,%ax
  100e23:	0f b7 c0             	movzwl %ax,%eax
  100e26:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100e2a:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e2e:	8a 45 e5             	mov    -0x1b(%ebp),%al
  100e31:	66 8b 55 e6          	mov    -0x1a(%ebp),%dx
  100e35:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e36:	66 a1 66 fe 10 00    	mov    0x10fe66,%ax
  100e3c:	40                   	inc    %eax
  100e3d:	0f b7 c0             	movzwl %ax,%eax
  100e40:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e44:	66 8b 45 ea          	mov    -0x16(%ebp),%ax
  100e48:	89 c2                	mov    %eax,%edx
  100e4a:	ec                   	in     (%dx),%al
  100e4b:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100e4e:	8a 45 e9             	mov    -0x17(%ebp),%al
  100e51:	0f b6 c0             	movzbl %al,%eax
  100e54:	c1 e0 08             	shl    $0x8,%eax
  100e57:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e5a:	66 a1 66 fe 10 00    	mov    0x10fe66,%ax
  100e60:	0f b7 c0             	movzwl %ax,%eax
  100e63:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100e67:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e6b:	8a 45 ed             	mov    -0x13(%ebp),%al
  100e6e:	66 8b 55 ee          	mov    -0x12(%ebp),%dx
  100e72:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100e73:	66 a1 66 fe 10 00    	mov    0x10fe66,%ax
  100e79:	40                   	inc    %eax
  100e7a:	0f b7 c0             	movzwl %ax,%eax
  100e7d:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e81:	66 8b 45 f2          	mov    -0xe(%ebp),%ax
  100e85:	89 c2                	mov    %eax,%edx
  100e87:	ec                   	in     (%dx),%al
  100e88:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100e8b:	8a 45 f1             	mov    -0xf(%ebp),%al
  100e8e:	0f b6 c0             	movzbl %al,%eax
  100e91:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100e94:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e97:	a3 60 fe 10 00       	mov    %eax,0x10fe60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100e9f:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
}
  100ea5:	90                   	nop
  100ea6:	c9                   	leave  
  100ea7:	c3                   	ret    

00100ea8 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100ea8:	55                   	push   %ebp
  100ea9:	89 e5                	mov    %esp,%ebp
  100eab:	83 ec 38             	sub    $0x38,%esp
  100eae:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100eb4:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100eb8:	8a 45 d1             	mov    -0x2f(%ebp),%al
  100ebb:	66 8b 55 d2          	mov    -0x2e(%ebp),%dx
  100ebf:	ee                   	out    %al,(%dx)
  100ec0:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100ec6:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
  100eca:	8a 45 d5             	mov    -0x2b(%ebp),%al
  100ecd:	66 8b 55 d6          	mov    -0x2a(%ebp),%dx
  100ed1:	ee                   	out    %al,(%dx)
  100ed2:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100ed8:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
  100edc:	8a 45 d9             	mov    -0x27(%ebp),%al
  100edf:	66 8b 55 da          	mov    -0x26(%ebp),%dx
  100ee3:	ee                   	out    %al,(%dx)
  100ee4:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100eea:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100eee:	8a 45 dd             	mov    -0x23(%ebp),%al
  100ef1:	66 8b 55 de          	mov    -0x22(%ebp),%dx
  100ef5:	ee                   	out    %al,(%dx)
  100ef6:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100efc:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
  100f00:	8a 45 e1             	mov    -0x1f(%ebp),%al
  100f03:	66 8b 55 e2          	mov    -0x1e(%ebp),%dx
  100f07:	ee                   	out    %al,(%dx)
  100f08:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100f0e:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  100f12:	8a 45 e5             	mov    -0x1b(%ebp),%al
  100f15:	66 8b 55 e6          	mov    -0x1a(%ebp),%dx
  100f19:	ee                   	out    %al,(%dx)
  100f1a:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f20:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
  100f24:	8a 45 e9             	mov    -0x17(%ebp),%al
  100f27:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
  100f2b:	ee                   	out    %al,(%dx)
  100f2c:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f32:	66 8b 45 ee          	mov    -0x12(%ebp),%ax
  100f36:	89 c2                	mov    %eax,%edx
  100f38:	ec                   	in     (%dx),%al
  100f39:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100f3c:	8a 45 ed             	mov    -0x13(%ebp),%al
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f3f:	3c ff                	cmp    $0xff,%al
  100f41:	0f 95 c0             	setne  %al
  100f44:	0f b6 c0             	movzbl %al,%eax
  100f47:	a3 68 fe 10 00       	mov    %eax,0x10fe68
  100f4c:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f52:	66 8b 45 f2          	mov    -0xe(%ebp),%ax
  100f56:	89 c2                	mov    %eax,%edx
  100f58:	ec                   	in     (%dx),%al
  100f59:	88 45 f1             	mov    %al,-0xf(%ebp)
  100f5c:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  100f62:	66 8b 45 f6          	mov    -0xa(%ebp),%ax
  100f66:	89 c2                	mov    %eax,%edx
  100f68:	ec                   	in     (%dx),%al
  100f69:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100f6c:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  100f71:	85 c0                	test   %eax,%eax
  100f73:	74 0d                	je     100f82 <serial_init+0xda>
        pic_enable(IRQ_COM1);
  100f75:	83 ec 0c             	sub    $0xc,%esp
  100f78:	6a 04                	push   $0x4
  100f7a:	e8 83 06 00 00       	call   101602 <pic_enable>
  100f7f:	83 c4 10             	add    $0x10,%esp
    }
}
  100f82:	90                   	nop
  100f83:	c9                   	leave  
  100f84:	c3                   	ret    

00100f85 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100f85:	55                   	push   %ebp
  100f86:	89 e5                	mov    %esp,%ebp
  100f88:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100f8b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100f92:	eb 08                	jmp    100f9c <lpt_putc_sub+0x17>
        delay();
  100f94:	e8 eb fd ff ff       	call   100d84 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100f99:	ff 45 fc             	incl   -0x4(%ebp)
  100f9c:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100fa2:	66 8b 45 fa          	mov    -0x6(%ebp),%ax
  100fa6:	89 c2                	mov    %eax,%edx
  100fa8:	ec                   	in     (%dx),%al
  100fa9:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100fac:	8a 45 f9             	mov    -0x7(%ebp),%al
  100faf:	84 c0                	test   %al,%al
  100fb1:	78 09                	js     100fbc <lpt_putc_sub+0x37>
  100fb3:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100fba:	7e d8                	jle    100f94 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  100fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  100fbf:	0f b6 c0             	movzbl %al,%eax
  100fc2:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  100fc8:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fcb:	8a 45 ed             	mov    -0x13(%ebp),%al
  100fce:	66 8b 55 ee          	mov    -0x12(%ebp),%dx
  100fd2:	ee                   	out    %al,(%dx)
  100fd3:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  100fd9:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  100fdd:	8a 45 f1             	mov    -0xf(%ebp),%al
  100fe0:	66 8b 55 f2          	mov    -0xe(%ebp),%dx
  100fe4:	ee                   	out    %al,(%dx)
  100fe5:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  100feb:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
  100fef:	8a 45 f5             	mov    -0xb(%ebp),%al
  100ff2:	66 8b 55 f6          	mov    -0xa(%ebp),%dx
  100ff6:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  100ff7:	90                   	nop
  100ff8:	c9                   	leave  
  100ff9:	c3                   	ret    

00100ffa <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  100ffa:	55                   	push   %ebp
  100ffb:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  100ffd:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101001:	74 0d                	je     101010 <lpt_putc+0x16>
        lpt_putc_sub(c);
  101003:	ff 75 08             	pushl  0x8(%ebp)
  101006:	e8 7a ff ff ff       	call   100f85 <lpt_putc_sub>
  10100b:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  10100e:	eb 1e                	jmp    10102e <lpt_putc+0x34>
        lpt_putc_sub('\b');
  101010:	6a 08                	push   $0x8
  101012:	e8 6e ff ff ff       	call   100f85 <lpt_putc_sub>
  101017:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  10101a:	6a 20                	push   $0x20
  10101c:	e8 64 ff ff ff       	call   100f85 <lpt_putc_sub>
  101021:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  101024:	6a 08                	push   $0x8
  101026:	e8 5a ff ff ff       	call   100f85 <lpt_putc_sub>
  10102b:	83 c4 04             	add    $0x4,%esp
}
  10102e:	90                   	nop
  10102f:	c9                   	leave  
  101030:	c3                   	ret    

00101031 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101031:	55                   	push   %ebp
  101032:	89 e5                	mov    %esp,%ebp
  101034:	53                   	push   %ebx
  101035:	83 ec 24             	sub    $0x24,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101038:	8b 45 08             	mov    0x8(%ebp),%eax
  10103b:	b0 00                	mov    $0x0,%al
  10103d:	85 c0                	test   %eax,%eax
  10103f:	75 07                	jne    101048 <cga_putc+0x17>
        c |= 0x0700;
  101041:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101048:	8b 45 08             	mov    0x8(%ebp),%eax
  10104b:	0f b6 c0             	movzbl %al,%eax
  10104e:	83 f8 0a             	cmp    $0xa,%eax
  101051:	74 4a                	je     10109d <cga_putc+0x6c>
  101053:	83 f8 0d             	cmp    $0xd,%eax
  101056:	74 54                	je     1010ac <cga_putc+0x7b>
  101058:	83 f8 08             	cmp    $0x8,%eax
  10105b:	75 77                	jne    1010d4 <cga_putc+0xa3>
    case '\b':
        if (crt_pos > 0) {
  10105d:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  101063:	66 85 c0             	test   %ax,%ax
  101066:	0f 84 8e 00 00 00    	je     1010fa <cga_putc+0xc9>
            crt_pos --;
  10106c:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  101072:	48                   	dec    %eax
  101073:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101079:	8b 45 08             	mov    0x8(%ebp),%eax
  10107c:	b0 00                	mov    $0x0,%al
  10107e:	83 c8 20             	or     $0x20,%eax
  101081:	89 c2                	mov    %eax,%edx
  101083:	8b 0d 60 fe 10 00    	mov    0x10fe60,%ecx
  101089:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  10108f:	0f b7 c0             	movzwl %ax,%eax
  101092:	01 c0                	add    %eax,%eax
  101094:	01 c1                	add    %eax,%ecx
  101096:	89 d0                	mov    %edx,%eax
  101098:	66 89 01             	mov    %ax,(%ecx)
        }
        break;
  10109b:	eb 5d                	jmp    1010fa <cga_putc+0xc9>
    case '\n':
        crt_pos += CRT_COLS;
  10109d:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  1010a3:	83 c0 50             	add    $0x50,%eax
  1010a6:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1010ac:	66 8b 0d 64 fe 10 00 	mov    0x10fe64,%cx
  1010b3:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  1010b9:	bb 50 00 00 00       	mov    $0x50,%ebx
  1010be:	ba 00 00 00 00       	mov    $0x0,%edx
  1010c3:	66 f7 f3             	div    %bx
  1010c6:	89 d0                	mov    %edx,%eax
  1010c8:	29 c1                	sub    %eax,%ecx
  1010ca:	89 c8                	mov    %ecx,%eax
  1010cc:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
        break;
  1010d2:	eb 27                	jmp    1010fb <cga_putc+0xca>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1010d4:	8b 0d 60 fe 10 00    	mov    0x10fe60,%ecx
  1010da:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  1010e0:	8d 50 01             	lea    0x1(%eax),%edx
  1010e3:	66 89 15 64 fe 10 00 	mov    %dx,0x10fe64
  1010ea:	0f b7 c0             	movzwl %ax,%eax
  1010ed:	01 c0                	add    %eax,%eax
  1010ef:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1010f5:	66 89 02             	mov    %ax,(%edx)
        break;
  1010f8:	eb 01                	jmp    1010fb <cga_putc+0xca>
        break;
  1010fa:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1010fb:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  101101:	66 3d cf 07          	cmp    $0x7cf,%ax
  101105:	76 58                	jbe    10115f <cga_putc+0x12e>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101107:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  10110c:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101112:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  101117:	83 ec 04             	sub    $0x4,%esp
  10111a:	68 00 0f 00 00       	push   $0xf00
  10111f:	52                   	push   %edx
  101120:	50                   	push   %eax
  101121:	e8 a5 20 00 00       	call   1031cb <memmove>
  101126:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101129:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101130:	eb 15                	jmp    101147 <cga_putc+0x116>
            crt_buf[i] = 0x0700 | ' ';
  101132:	8b 15 60 fe 10 00    	mov    0x10fe60,%edx
  101138:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10113b:	01 c0                	add    %eax,%eax
  10113d:	01 d0                	add    %edx,%eax
  10113f:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101144:	ff 45 f4             	incl   -0xc(%ebp)
  101147:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10114e:	7e e2                	jle    101132 <cga_putc+0x101>
        }
        crt_pos -= CRT_COLS;
  101150:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  101156:	83 e8 50             	sub    $0x50,%eax
  101159:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  10115f:	66 a1 66 fe 10 00    	mov    0x10fe66,%ax
  101165:	0f b7 c0             	movzwl %ax,%eax
  101168:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  10116c:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
  101170:	8a 45 e5             	mov    -0x1b(%ebp),%al
  101173:	66 8b 55 e6          	mov    -0x1a(%ebp),%dx
  101177:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101178:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  10117e:	66 c1 e8 08          	shr    $0x8,%ax
  101182:	0f b6 d0             	movzbl %al,%edx
  101185:	66 a1 66 fe 10 00    	mov    0x10fe66,%ax
  10118b:	40                   	inc    %eax
  10118c:	0f b7 c0             	movzwl %ax,%eax
  10118f:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101193:	88 55 e9             	mov    %dl,-0x17(%ebp)
  101196:	8a 45 e9             	mov    -0x17(%ebp),%al
  101199:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
  10119d:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10119e:	66 a1 66 fe 10 00    	mov    0x10fe66,%ax
  1011a4:	0f b7 c0             	movzwl %ax,%eax
  1011a7:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  1011ab:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
  1011af:	8a 45 ed             	mov    -0x13(%ebp),%al
  1011b2:	66 8b 55 ee          	mov    -0x12(%ebp),%dx
  1011b6:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  1011b7:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  1011bd:	0f b6 d0             	movzbl %al,%edx
  1011c0:	66 a1 66 fe 10 00    	mov    0x10fe66,%ax
  1011c6:	40                   	inc    %eax
  1011c7:	0f b7 c0             	movzwl %ax,%eax
  1011ca:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011ce:	88 55 f1             	mov    %dl,-0xf(%ebp)
  1011d1:	8a 45 f1             	mov    -0xf(%ebp),%al
  1011d4:	66 8b 55 f2          	mov    -0xe(%ebp),%dx
  1011d8:	ee                   	out    %al,(%dx)
}
  1011d9:	90                   	nop
  1011da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1011dd:	c9                   	leave  
  1011de:	c3                   	ret    

001011df <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1011df:	55                   	push   %ebp
  1011e0:	89 e5                	mov    %esp,%ebp
  1011e2:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1011e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1011ec:	eb 08                	jmp    1011f6 <serial_putc_sub+0x17>
        delay();
  1011ee:	e8 91 fb ff ff       	call   100d84 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1011f3:	ff 45 fc             	incl   -0x4(%ebp)
  1011f6:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1011fc:	66 8b 45 fa          	mov    -0x6(%ebp),%ax
  101200:	89 c2                	mov    %eax,%edx
  101202:	ec                   	in     (%dx),%al
  101203:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101206:	8a 45 f9             	mov    -0x7(%ebp),%al
  101209:	0f b6 c0             	movzbl %al,%eax
  10120c:	83 e0 20             	and    $0x20,%eax
  10120f:	85 c0                	test   %eax,%eax
  101211:	75 09                	jne    10121c <serial_putc_sub+0x3d>
  101213:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10121a:	7e d2                	jle    1011ee <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  10121c:	8b 45 08             	mov    0x8(%ebp),%eax
  10121f:	0f b6 c0             	movzbl %al,%eax
  101222:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101228:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10122b:	8a 45 f5             	mov    -0xb(%ebp),%al
  10122e:	66 8b 55 f6          	mov    -0xa(%ebp),%dx
  101232:	ee                   	out    %al,(%dx)
}
  101233:	90                   	nop
  101234:	c9                   	leave  
  101235:	c3                   	ret    

00101236 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101236:	55                   	push   %ebp
  101237:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  101239:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10123d:	74 0d                	je     10124c <serial_putc+0x16>
        serial_putc_sub(c);
  10123f:	ff 75 08             	pushl  0x8(%ebp)
  101242:	e8 98 ff ff ff       	call   1011df <serial_putc_sub>
  101247:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  10124a:	eb 1e                	jmp    10126a <serial_putc+0x34>
        serial_putc_sub('\b');
  10124c:	6a 08                	push   $0x8
  10124e:	e8 8c ff ff ff       	call   1011df <serial_putc_sub>
  101253:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  101256:	6a 20                	push   $0x20
  101258:	e8 82 ff ff ff       	call   1011df <serial_putc_sub>
  10125d:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  101260:	6a 08                	push   $0x8
  101262:	e8 78 ff ff ff       	call   1011df <serial_putc_sub>
  101267:	83 c4 04             	add    $0x4,%esp
}
  10126a:	90                   	nop
  10126b:	c9                   	leave  
  10126c:	c3                   	ret    

0010126d <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10126d:	55                   	push   %ebp
  10126e:	89 e5                	mov    %esp,%ebp
  101270:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101273:	eb 33                	jmp    1012a8 <cons_intr+0x3b>
        if (c != 0) {
  101275:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101279:	74 2d                	je     1012a8 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  10127b:	a1 84 00 11 00       	mov    0x110084,%eax
  101280:	8d 50 01             	lea    0x1(%eax),%edx
  101283:	89 15 84 00 11 00    	mov    %edx,0x110084
  101289:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10128c:	88 90 80 fe 10 00    	mov    %dl,0x10fe80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101292:	a1 84 00 11 00       	mov    0x110084,%eax
  101297:	3d 00 02 00 00       	cmp    $0x200,%eax
  10129c:	75 0a                	jne    1012a8 <cons_intr+0x3b>
                cons.wpos = 0;
  10129e:	c7 05 84 00 11 00 00 	movl   $0x0,0x110084
  1012a5:	00 00 00 
    while ((c = (*proc)()) != -1) {
  1012a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1012ab:	ff d0                	call   *%eax
  1012ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1012b0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1012b4:	75 bf                	jne    101275 <cons_intr+0x8>
            }
        }
    }
}
  1012b6:	90                   	nop
  1012b7:	c9                   	leave  
  1012b8:	c3                   	ret    

001012b9 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1012b9:	55                   	push   %ebp
  1012ba:	89 e5                	mov    %esp,%ebp
  1012bc:	83 ec 10             	sub    $0x10,%esp
  1012bf:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1012c5:	66 8b 45 fa          	mov    -0x6(%ebp),%ax
  1012c9:	89 c2                	mov    %eax,%edx
  1012cb:	ec                   	in     (%dx),%al
  1012cc:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012cf:	8a 45 f9             	mov    -0x7(%ebp),%al
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1012d2:	0f b6 c0             	movzbl %al,%eax
  1012d5:	83 e0 01             	and    $0x1,%eax
  1012d8:	85 c0                	test   %eax,%eax
  1012da:	75 07                	jne    1012e3 <serial_proc_data+0x2a>
        return -1;
  1012dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1012e1:	eb 29                	jmp    10130c <serial_proc_data+0x53>
  1012e3:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1012e9:	66 8b 45 f6          	mov    -0xa(%ebp),%ax
  1012ed:	89 c2                	mov    %eax,%edx
  1012ef:	ec                   	in     (%dx),%al
  1012f0:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1012f3:	8a 45 f5             	mov    -0xb(%ebp),%al
    }
    int c = inb(COM1 + COM_RX);
  1012f6:	0f b6 c0             	movzbl %al,%eax
  1012f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1012fc:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101300:	75 07                	jne    101309 <serial_proc_data+0x50>
        c = '\b';
  101302:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101309:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10130c:	c9                   	leave  
  10130d:	c3                   	ret    

0010130e <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  10130e:	55                   	push   %ebp
  10130f:	89 e5                	mov    %esp,%ebp
  101311:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
  101314:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  101319:	85 c0                	test   %eax,%eax
  10131b:	74 10                	je     10132d <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  10131d:	83 ec 0c             	sub    $0xc,%esp
  101320:	68 b9 12 10 00       	push   $0x1012b9
  101325:	e8 43 ff ff ff       	call   10126d <cons_intr>
  10132a:	83 c4 10             	add    $0x10,%esp
    }
}
  10132d:	90                   	nop
  10132e:	c9                   	leave  
  10132f:	c3                   	ret    

00101330 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101330:	55                   	push   %ebp
  101331:	89 e5                	mov    %esp,%ebp
  101333:	83 ec 28             	sub    $0x28,%esp
  101336:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10133c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10133f:	89 c2                	mov    %eax,%edx
  101341:	ec                   	in     (%dx),%al
  101342:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101345:	8a 45 ef             	mov    -0x11(%ebp),%al
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101348:	0f b6 c0             	movzbl %al,%eax
  10134b:	83 e0 01             	and    $0x1,%eax
  10134e:	85 c0                	test   %eax,%eax
  101350:	75 0a                	jne    10135c <kbd_proc_data+0x2c>
        return -1;
  101352:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101357:	e9 52 01 00 00       	jmp    1014ae <kbd_proc_data+0x17e>
  10135c:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101362:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101365:	89 c2                	mov    %eax,%edx
  101367:	ec                   	in     (%dx),%al
  101368:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10136b:	8a 45 eb             	mov    -0x15(%ebp),%al
    }

    data = inb(KBDATAP);
  10136e:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101371:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101375:	75 17                	jne    10138e <kbd_proc_data+0x5e>
        // E0 escape character
        shift |= E0ESC;
  101377:	a1 88 00 11 00       	mov    0x110088,%eax
  10137c:	83 c8 40             	or     $0x40,%eax
  10137f:	a3 88 00 11 00       	mov    %eax,0x110088
        return 0;
  101384:	b8 00 00 00 00       	mov    $0x0,%eax
  101389:	e9 20 01 00 00       	jmp    1014ae <kbd_proc_data+0x17e>
    } else if (data & 0x80) {
  10138e:	8a 45 f3             	mov    -0xd(%ebp),%al
  101391:	84 c0                	test   %al,%al
  101393:	79 44                	jns    1013d9 <kbd_proc_data+0xa9>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101395:	a1 88 00 11 00       	mov    0x110088,%eax
  10139a:	83 e0 40             	and    $0x40,%eax
  10139d:	85 c0                	test   %eax,%eax
  10139f:	75 08                	jne    1013a9 <kbd_proc_data+0x79>
  1013a1:	8a 45 f3             	mov    -0xd(%ebp),%al
  1013a4:	83 e0 7f             	and    $0x7f,%eax
  1013a7:	eb 03                	jmp    1013ac <kbd_proc_data+0x7c>
  1013a9:	8a 45 f3             	mov    -0xd(%ebp),%al
  1013ac:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1013af:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013b3:	8a 80 40 f0 10 00    	mov    0x10f040(%eax),%al
  1013b9:	83 c8 40             	or     $0x40,%eax
  1013bc:	0f b6 c0             	movzbl %al,%eax
  1013bf:	f7 d0                	not    %eax
  1013c1:	89 c2                	mov    %eax,%edx
  1013c3:	a1 88 00 11 00       	mov    0x110088,%eax
  1013c8:	21 d0                	and    %edx,%eax
  1013ca:	a3 88 00 11 00       	mov    %eax,0x110088
        return 0;
  1013cf:	b8 00 00 00 00       	mov    $0x0,%eax
  1013d4:	e9 d5 00 00 00       	jmp    1014ae <kbd_proc_data+0x17e>
    } else if (shift & E0ESC) {
  1013d9:	a1 88 00 11 00       	mov    0x110088,%eax
  1013de:	83 e0 40             	and    $0x40,%eax
  1013e1:	85 c0                	test   %eax,%eax
  1013e3:	74 11                	je     1013f6 <kbd_proc_data+0xc6>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1013e5:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1013e9:	a1 88 00 11 00       	mov    0x110088,%eax
  1013ee:	83 e0 bf             	and    $0xffffffbf,%eax
  1013f1:	a3 88 00 11 00       	mov    %eax,0x110088
    }

    shift |= shiftcode[data];
  1013f6:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013fa:	8a 80 40 f0 10 00    	mov    0x10f040(%eax),%al
  101400:	0f b6 d0             	movzbl %al,%edx
  101403:	a1 88 00 11 00       	mov    0x110088,%eax
  101408:	09 d0                	or     %edx,%eax
  10140a:	a3 88 00 11 00       	mov    %eax,0x110088
    shift ^= togglecode[data];
  10140f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101413:	8a 80 40 f1 10 00    	mov    0x10f140(%eax),%al
  101419:	0f b6 d0             	movzbl %al,%edx
  10141c:	a1 88 00 11 00       	mov    0x110088,%eax
  101421:	31 d0                	xor    %edx,%eax
  101423:	a3 88 00 11 00       	mov    %eax,0x110088

    c = charcode[shift & (CTL | SHIFT)][data];
  101428:	a1 88 00 11 00       	mov    0x110088,%eax
  10142d:	83 e0 03             	and    $0x3,%eax
  101430:	8b 14 85 40 f5 10 00 	mov    0x10f540(,%eax,4),%edx
  101437:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10143b:	01 d0                	add    %edx,%eax
  10143d:	8a 00                	mov    (%eax),%al
  10143f:	0f b6 c0             	movzbl %al,%eax
  101442:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101445:	a1 88 00 11 00       	mov    0x110088,%eax
  10144a:	83 e0 08             	and    $0x8,%eax
  10144d:	85 c0                	test   %eax,%eax
  10144f:	74 22                	je     101473 <kbd_proc_data+0x143>
        if ('a' <= c && c <= 'z')
  101451:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101455:	7e 0c                	jle    101463 <kbd_proc_data+0x133>
  101457:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  10145b:	7f 06                	jg     101463 <kbd_proc_data+0x133>
            c += 'A' - 'a';
  10145d:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101461:	eb 10                	jmp    101473 <kbd_proc_data+0x143>
        else if ('A' <= c && c <= 'Z')
  101463:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101467:	7e 0a                	jle    101473 <kbd_proc_data+0x143>
  101469:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  10146d:	7f 04                	jg     101473 <kbd_proc_data+0x143>
            c += 'a' - 'A';
  10146f:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101473:	a1 88 00 11 00       	mov    0x110088,%eax
  101478:	f7 d0                	not    %eax
  10147a:	83 e0 06             	and    $0x6,%eax
  10147d:	85 c0                	test   %eax,%eax
  10147f:	75 2a                	jne    1014ab <kbd_proc_data+0x17b>
  101481:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101488:	75 21                	jne    1014ab <kbd_proc_data+0x17b>
        cprintf("Rebooting!\n");
  10148a:	83 ec 0c             	sub    $0xc,%esp
  10148d:	68 4f 36 10 00       	push   $0x10364f
  101492:	e8 5f ee ff ff       	call   1002f6 <cprintf>
  101497:	83 c4 10             	add    $0x10,%esp
  10149a:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1014a0:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1014a4:	8a 45 e7             	mov    -0x19(%ebp),%al
  1014a7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1014aa:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1014ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1014ae:	c9                   	leave  
  1014af:	c3                   	ret    

001014b0 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1014b0:	55                   	push   %ebp
  1014b1:	89 e5                	mov    %esp,%ebp
  1014b3:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
  1014b6:	83 ec 0c             	sub    $0xc,%esp
  1014b9:	68 30 13 10 00       	push   $0x101330
  1014be:	e8 aa fd ff ff       	call   10126d <cons_intr>
  1014c3:	83 c4 10             	add    $0x10,%esp
}
  1014c6:	90                   	nop
  1014c7:	c9                   	leave  
  1014c8:	c3                   	ret    

001014c9 <kbd_init>:

static void
kbd_init(void) {
  1014c9:	55                   	push   %ebp
  1014ca:	89 e5                	mov    %esp,%ebp
  1014cc:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
  1014cf:	e8 dc ff ff ff       	call   1014b0 <kbd_intr>
    pic_enable(IRQ_KBD);
  1014d4:	83 ec 0c             	sub    $0xc,%esp
  1014d7:	6a 01                	push   $0x1
  1014d9:	e8 24 01 00 00       	call   101602 <pic_enable>
  1014de:	83 c4 10             	add    $0x10,%esp
}
  1014e1:	90                   	nop
  1014e2:	c9                   	leave  
  1014e3:	c3                   	ret    

001014e4 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1014e4:	55                   	push   %ebp
  1014e5:	89 e5                	mov    %esp,%ebp
  1014e7:	83 ec 08             	sub    $0x8,%esp
    cga_init();
  1014ea:	e8 de f8 ff ff       	call   100dcd <cga_init>
    serial_init();
  1014ef:	e8 b4 f9 ff ff       	call   100ea8 <serial_init>
    kbd_init();
  1014f4:	e8 d0 ff ff ff       	call   1014c9 <kbd_init>
    if (!serial_exists) {
  1014f9:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  1014fe:	85 c0                	test   %eax,%eax
  101500:	75 10                	jne    101512 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  101502:	83 ec 0c             	sub    $0xc,%esp
  101505:	68 5b 36 10 00       	push   $0x10365b
  10150a:	e8 e7 ed ff ff       	call   1002f6 <cprintf>
  10150f:	83 c4 10             	add    $0x10,%esp
    }
}
  101512:	90                   	nop
  101513:	c9                   	leave  
  101514:	c3                   	ret    

00101515 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101515:	55                   	push   %ebp
  101516:	89 e5                	mov    %esp,%ebp
  101518:	83 ec 08             	sub    $0x8,%esp
    lpt_putc(c);
  10151b:	ff 75 08             	pushl  0x8(%ebp)
  10151e:	e8 d7 fa ff ff       	call   100ffa <lpt_putc>
  101523:	83 c4 04             	add    $0x4,%esp
    cga_putc(c);
  101526:	83 ec 0c             	sub    $0xc,%esp
  101529:	ff 75 08             	pushl  0x8(%ebp)
  10152c:	e8 00 fb ff ff       	call   101031 <cga_putc>
  101531:	83 c4 10             	add    $0x10,%esp
    serial_putc(c);
  101534:	83 ec 0c             	sub    $0xc,%esp
  101537:	ff 75 08             	pushl  0x8(%ebp)
  10153a:	e8 f7 fc ff ff       	call   101236 <serial_putc>
  10153f:	83 c4 10             	add    $0x10,%esp
}
  101542:	90                   	nop
  101543:	c9                   	leave  
  101544:	c3                   	ret    

00101545 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101545:	55                   	push   %ebp
  101546:	89 e5                	mov    %esp,%ebp
  101548:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  10154b:	e8 be fd ff ff       	call   10130e <serial_intr>
    kbd_intr();
  101550:	e8 5b ff ff ff       	call   1014b0 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  101555:	8b 15 80 00 11 00    	mov    0x110080,%edx
  10155b:	a1 84 00 11 00       	mov    0x110084,%eax
  101560:	39 c2                	cmp    %eax,%edx
  101562:	74 35                	je     101599 <cons_getc+0x54>
        c = cons.buf[cons.rpos ++];
  101564:	a1 80 00 11 00       	mov    0x110080,%eax
  101569:	8d 50 01             	lea    0x1(%eax),%edx
  10156c:	89 15 80 00 11 00    	mov    %edx,0x110080
  101572:	8a 80 80 fe 10 00    	mov    0x10fe80(%eax),%al
  101578:	0f b6 c0             	movzbl %al,%eax
  10157b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  10157e:	a1 80 00 11 00       	mov    0x110080,%eax
  101583:	3d 00 02 00 00       	cmp    $0x200,%eax
  101588:	75 0a                	jne    101594 <cons_getc+0x4f>
            cons.rpos = 0;
  10158a:	c7 05 80 00 11 00 00 	movl   $0x0,0x110080
  101591:	00 00 00 
        }
        return c;
  101594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101597:	eb 05                	jmp    10159e <cons_getc+0x59>
    }
    return 0;
  101599:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10159e:	c9                   	leave  
  10159f:	c3                   	ret    

001015a0 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1015a0:	55                   	push   %ebp
  1015a1:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1015a3:	fb                   	sti    
    sti();
}
  1015a4:	90                   	nop
  1015a5:	5d                   	pop    %ebp
  1015a6:	c3                   	ret    

001015a7 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1015a7:	55                   	push   %ebp
  1015a8:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  1015aa:	fa                   	cli    
    cli();
}
  1015ab:	90                   	nop
  1015ac:	5d                   	pop    %ebp
  1015ad:	c3                   	ret    

001015ae <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1015ae:	55                   	push   %ebp
  1015af:	89 e5                	mov    %esp,%ebp
  1015b1:	83 ec 14             	sub    $0x14,%esp
  1015b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1015b7:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1015bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1015be:	66 a3 50 f5 10 00    	mov    %ax,0x10f550
    if (did_init) {
  1015c4:	a1 8c 00 11 00       	mov    0x11008c,%eax
  1015c9:	85 c0                	test   %eax,%eax
  1015cb:	74 32                	je     1015ff <pic_setmask+0x51>
        outb(IO_PIC1 + 1, mask);
  1015cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1015d0:	0f b6 c0             	movzbl %al,%eax
  1015d3:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  1015d9:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1015dc:	8a 45 f9             	mov    -0x7(%ebp),%al
  1015df:	66 8b 55 fa          	mov    -0x6(%ebp),%dx
  1015e3:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1015e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1015e7:	66 c1 e8 08          	shr    $0x8,%ax
  1015eb:	0f b6 c0             	movzbl %al,%eax
  1015ee:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  1015f4:	88 45 fd             	mov    %al,-0x3(%ebp)
  1015f7:	8a 45 fd             	mov    -0x3(%ebp),%al
  1015fa:	66 8b 55 fe          	mov    -0x2(%ebp),%dx
  1015fe:	ee                   	out    %al,(%dx)
    }
}
  1015ff:	90                   	nop
  101600:	c9                   	leave  
  101601:	c3                   	ret    

00101602 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101602:	55                   	push   %ebp
  101603:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  101605:	8b 45 08             	mov    0x8(%ebp),%eax
  101608:	ba 01 00 00 00       	mov    $0x1,%edx
  10160d:	88 c1                	mov    %al,%cl
  10160f:	d3 e2                	shl    %cl,%edx
  101611:	89 d0                	mov    %edx,%eax
  101613:	f7 d0                	not    %eax
  101615:	89 c2                	mov    %eax,%edx
  101617:	66 a1 50 f5 10 00    	mov    0x10f550,%ax
  10161d:	21 d0                	and    %edx,%eax
  10161f:	0f b7 c0             	movzwl %ax,%eax
  101622:	50                   	push   %eax
  101623:	e8 86 ff ff ff       	call   1015ae <pic_setmask>
  101628:	83 c4 04             	add    $0x4,%esp
}
  10162b:	90                   	nop
  10162c:	c9                   	leave  
  10162d:	c3                   	ret    

0010162e <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10162e:	55                   	push   %ebp
  10162f:	89 e5                	mov    %esp,%ebp
  101631:	83 ec 40             	sub    $0x40,%esp
    did_init = 1;
  101634:	c7 05 8c 00 11 00 01 	movl   $0x1,0x11008c
  10163b:	00 00 00 
  10163e:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  101644:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
  101648:	8a 45 c9             	mov    -0x37(%ebp),%al
  10164b:	66 8b 55 ca          	mov    -0x36(%ebp),%dx
  10164f:	ee                   	out    %al,(%dx)
  101650:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  101656:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
  10165a:	8a 45 cd             	mov    -0x33(%ebp),%al
  10165d:	66 8b 55 ce          	mov    -0x32(%ebp),%dx
  101661:	ee                   	out    %al,(%dx)
  101662:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101668:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
  10166c:	8a 45 d1             	mov    -0x2f(%ebp),%al
  10166f:	66 8b 55 d2          	mov    -0x2e(%ebp),%dx
  101673:	ee                   	out    %al,(%dx)
  101674:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  10167a:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
  10167e:	8a 45 d5             	mov    -0x2b(%ebp),%al
  101681:	66 8b 55 d6          	mov    -0x2a(%ebp),%dx
  101685:	ee                   	out    %al,(%dx)
  101686:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  10168c:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
  101690:	8a 45 d9             	mov    -0x27(%ebp),%al
  101693:	66 8b 55 da          	mov    -0x26(%ebp),%dx
  101697:	ee                   	out    %al,(%dx)
  101698:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  10169e:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
  1016a2:	8a 45 dd             	mov    -0x23(%ebp),%al
  1016a5:	66 8b 55 de          	mov    -0x22(%ebp),%dx
  1016a9:	ee                   	out    %al,(%dx)
  1016aa:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  1016b0:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
  1016b4:	8a 45 e1             	mov    -0x1f(%ebp),%al
  1016b7:	66 8b 55 e2          	mov    -0x1e(%ebp),%dx
  1016bb:	ee                   	out    %al,(%dx)
  1016bc:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  1016c2:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
  1016c6:	8a 45 e5             	mov    -0x1b(%ebp),%al
  1016c9:	66 8b 55 e6          	mov    -0x1a(%ebp),%dx
  1016cd:	ee                   	out    %al,(%dx)
  1016ce:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  1016d4:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
  1016d8:	8a 45 e9             	mov    -0x17(%ebp),%al
  1016db:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
  1016df:	ee                   	out    %al,(%dx)
  1016e0:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  1016e6:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
  1016ea:	8a 45 ed             	mov    -0x13(%ebp),%al
  1016ed:	66 8b 55 ee          	mov    -0x12(%ebp),%dx
  1016f1:	ee                   	out    %al,(%dx)
  1016f2:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  1016f8:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
  1016fc:	8a 45 f1             	mov    -0xf(%ebp),%al
  1016ff:	66 8b 55 f2          	mov    -0xe(%ebp),%dx
  101703:	ee                   	out    %al,(%dx)
  101704:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  10170a:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
  10170e:	8a 45 f5             	mov    -0xb(%ebp),%al
  101711:	66 8b 55 f6          	mov    -0xa(%ebp),%dx
  101715:	ee                   	out    %al,(%dx)
  101716:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  10171c:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
  101720:	8a 45 f9             	mov    -0x7(%ebp),%al
  101723:	66 8b 55 fa          	mov    -0x6(%ebp),%dx
  101727:	ee                   	out    %al,(%dx)
  101728:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  10172e:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
  101732:	8a 45 fd             	mov    -0x3(%ebp),%al
  101735:	66 8b 55 fe          	mov    -0x2(%ebp),%dx
  101739:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  10173a:	66 a1 50 f5 10 00    	mov    0x10f550,%ax
  101740:	66 83 f8 ff          	cmp    $0xffff,%ax
  101744:	74 12                	je     101758 <pic_init+0x12a>
        pic_setmask(irq_mask);
  101746:	66 a1 50 f5 10 00    	mov    0x10f550,%ax
  10174c:	0f b7 c0             	movzwl %ax,%eax
  10174f:	50                   	push   %eax
  101750:	e8 59 fe ff ff       	call   1015ae <pic_setmask>
  101755:	83 c4 04             	add    $0x4,%esp
    }
}
  101758:	90                   	nop
  101759:	c9                   	leave  
  10175a:	c3                   	ret    

0010175b <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  10175b:	55                   	push   %ebp
  10175c:	89 e5                	mov    %esp,%ebp
  10175e:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101761:	83 ec 08             	sub    $0x8,%esp
  101764:	6a 64                	push   $0x64
  101766:	68 80 36 10 00       	push   $0x103680
  10176b:	e8 86 eb ff ff       	call   1002f6 <cprintf>
  101770:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  101773:	90                   	nop
  101774:	c9                   	leave  
  101775:	c3                   	ret    

00101776 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101776:	55                   	push   %ebp
  101777:	89 e5                	mov    %esp,%ebp
  101779:	83 ec 10             	sub    $0x10,%esp
    // gate：处理函数的入口地址
    // istrap：系统段设置为1，中断门设置为0
    // sel：段选择子 
    // off：偏移量
    // dpl：特权级
    for (int i = 0; i < 256; ++i) 
  10177c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101783:	e9 b8 00 00 00       	jmp    101840 <idt_init+0xca>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  101788:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10178b:	8b 04 85 e0 f5 10 00 	mov    0x10f5e0(,%eax,4),%eax
  101792:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101795:	66 89 04 d5 a0 00 11 	mov    %ax,0x1100a0(,%edx,8)
  10179c:	00 
  10179d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1017a0:	66 c7 04 c5 a2 00 11 	movw   $0x8,0x1100a2(,%eax,8)
  1017a7:	00 08 00 
  1017aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1017ad:	8a 14 c5 a4 00 11 00 	mov    0x1100a4(,%eax,8),%dl
  1017b4:	83 e2 e0             	and    $0xffffffe0,%edx
  1017b7:	88 14 c5 a4 00 11 00 	mov    %dl,0x1100a4(,%eax,8)
  1017be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1017c1:	8a 14 c5 a4 00 11 00 	mov    0x1100a4(,%eax,8),%dl
  1017c8:	83 e2 1f             	and    $0x1f,%edx
  1017cb:	88 14 c5 a4 00 11 00 	mov    %dl,0x1100a4(,%eax,8)
  1017d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1017d5:	8a 14 c5 a5 00 11 00 	mov    0x1100a5(,%eax,8),%dl
  1017dc:	83 e2 f0             	and    $0xfffffff0,%edx
  1017df:	83 ca 0e             	or     $0xe,%edx
  1017e2:	88 14 c5 a5 00 11 00 	mov    %dl,0x1100a5(,%eax,8)
  1017e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1017ec:	8a 14 c5 a5 00 11 00 	mov    0x1100a5(,%eax,8),%dl
  1017f3:	83 e2 ef             	and    $0xffffffef,%edx
  1017f6:	88 14 c5 a5 00 11 00 	mov    %dl,0x1100a5(,%eax,8)
  1017fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101800:	8a 14 c5 a5 00 11 00 	mov    0x1100a5(,%eax,8),%dl
  101807:	83 e2 9f             	and    $0xffffff9f,%edx
  10180a:	88 14 c5 a5 00 11 00 	mov    %dl,0x1100a5(,%eax,8)
  101811:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101814:	8a 14 c5 a5 00 11 00 	mov    0x1100a5(,%eax,8),%dl
  10181b:	83 ca 80             	or     $0xffffff80,%edx
  10181e:	88 14 c5 a5 00 11 00 	mov    %dl,0x1100a5(,%eax,8)
  101825:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101828:	8b 04 85 e0 f5 10 00 	mov    0x10f5e0(,%eax,4),%eax
  10182f:	c1 e8 10             	shr    $0x10,%eax
  101832:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101835:	66 89 04 d5 a6 00 11 	mov    %ax,0x1100a6(,%edx,8)
  10183c:	00 
    for (int i = 0; i < 256; ++i) 
  10183d:	ff 45 fc             	incl   -0x4(%ebp)
  101840:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  101847:	0f 8e 3b ff ff ff    	jle    101788 <idt_init+0x12>
    // T_SWITCH_TOK 定义于kern/trap/trap/h，也可以使用T_SWITCH_TOU
   	// 用于设置用户态到内核态的切换
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  10184d:	a1 c4 f7 10 00       	mov    0x10f7c4,%eax
  101852:	66 a3 68 04 11 00    	mov    %ax,0x110468
  101858:	66 c7 05 6a 04 11 00 	movw   $0x8,0x11046a
  10185f:	08 00 
  101861:	a0 6c 04 11 00       	mov    0x11046c,%al
  101866:	83 e0 e0             	and    $0xffffffe0,%eax
  101869:	a2 6c 04 11 00       	mov    %al,0x11046c
  10186e:	a0 6c 04 11 00       	mov    0x11046c,%al
  101873:	83 e0 1f             	and    $0x1f,%eax
  101876:	a2 6c 04 11 00       	mov    %al,0x11046c
  10187b:	a0 6d 04 11 00       	mov    0x11046d,%al
  101880:	83 e0 f0             	and    $0xfffffff0,%eax
  101883:	83 c8 0e             	or     $0xe,%eax
  101886:	a2 6d 04 11 00       	mov    %al,0x11046d
  10188b:	a0 6d 04 11 00       	mov    0x11046d,%al
  101890:	83 e0 ef             	and    $0xffffffef,%eax
  101893:	a2 6d 04 11 00       	mov    %al,0x11046d
  101898:	a0 6d 04 11 00       	mov    0x11046d,%al
  10189d:	83 c8 60             	or     $0x60,%eax
  1018a0:	a2 6d 04 11 00       	mov    %al,0x11046d
  1018a5:	a0 6d 04 11 00       	mov    0x11046d,%al
  1018aa:	83 c8 80             	or     $0xffffff80,%eax
  1018ad:	a2 6d 04 11 00       	mov    %al,0x11046d
  1018b2:	a1 c4 f7 10 00       	mov    0x10f7c4,%eax
  1018b7:	c1 e8 10             	shr    $0x10,%eax
  1018ba:	66 a3 6e 04 11 00    	mov    %ax,0x11046e
  1018c0:	c7 45 f8 60 f5 10 00 	movl   $0x10f560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  1018c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1018ca:	0f 01 18             	lidtl  (%eax)
	// load IDT
    lidt(&idt_pd);
}
  1018cd:	90                   	nop
  1018ce:	c9                   	leave  
  1018cf:	c3                   	ret    

001018d0 <trapname>:

static const char *
trapname(int trapno) {
  1018d0:	55                   	push   %ebp
  1018d1:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1018d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1018d6:	83 f8 13             	cmp    $0x13,%eax
  1018d9:	77 0c                	ja     1018e7 <trapname+0x17>
        return excnames[trapno];
  1018db:	8b 45 08             	mov    0x8(%ebp),%eax
  1018de:	8b 04 85 e0 39 10 00 	mov    0x1039e0(,%eax,4),%eax
  1018e5:	eb 18                	jmp    1018ff <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1018e7:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1018eb:	7e 0d                	jle    1018fa <trapname+0x2a>
  1018ed:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1018f1:	7f 07                	jg     1018fa <trapname+0x2a>
        return "Hardware Interrupt";
  1018f3:	b8 8a 36 10 00       	mov    $0x10368a,%eax
  1018f8:	eb 05                	jmp    1018ff <trapname+0x2f>
    }
    return "(unknown trap)";
  1018fa:	b8 9d 36 10 00       	mov    $0x10369d,%eax
}
  1018ff:	5d                   	pop    %ebp
  101900:	c3                   	ret    

00101901 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101901:	55                   	push   %ebp
  101902:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101904:	8b 45 08             	mov    0x8(%ebp),%eax
  101907:	66 8b 40 3c          	mov    0x3c(%eax),%ax
  10190b:	66 83 f8 08          	cmp    $0x8,%ax
  10190f:	0f 94 c0             	sete   %al
  101912:	0f b6 c0             	movzbl %al,%eax
}
  101915:	5d                   	pop    %ebp
  101916:	c3                   	ret    

00101917 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101917:	55                   	push   %ebp
  101918:	89 e5                	mov    %esp,%ebp
  10191a:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
  10191d:	83 ec 08             	sub    $0x8,%esp
  101920:	ff 75 08             	pushl  0x8(%ebp)
  101923:	68 de 36 10 00       	push   $0x1036de
  101928:	e8 c9 e9 ff ff       	call   1002f6 <cprintf>
  10192d:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  101930:	8b 45 08             	mov    0x8(%ebp),%eax
  101933:	83 ec 0c             	sub    $0xc,%esp
  101936:	50                   	push   %eax
  101937:	e8 ba 01 00 00       	call   101af6 <print_regs>
  10193c:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  10193f:	8b 45 08             	mov    0x8(%ebp),%eax
  101942:	66 8b 40 2c          	mov    0x2c(%eax),%ax
  101946:	0f b7 c0             	movzwl %ax,%eax
  101949:	83 ec 08             	sub    $0x8,%esp
  10194c:	50                   	push   %eax
  10194d:	68 ef 36 10 00       	push   $0x1036ef
  101952:	e8 9f e9 ff ff       	call   1002f6 <cprintf>
  101957:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  10195a:	8b 45 08             	mov    0x8(%ebp),%eax
  10195d:	66 8b 40 28          	mov    0x28(%eax),%ax
  101961:	0f b7 c0             	movzwl %ax,%eax
  101964:	83 ec 08             	sub    $0x8,%esp
  101967:	50                   	push   %eax
  101968:	68 02 37 10 00       	push   $0x103702
  10196d:	e8 84 e9 ff ff       	call   1002f6 <cprintf>
  101972:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101975:	8b 45 08             	mov    0x8(%ebp),%eax
  101978:	66 8b 40 24          	mov    0x24(%eax),%ax
  10197c:	0f b7 c0             	movzwl %ax,%eax
  10197f:	83 ec 08             	sub    $0x8,%esp
  101982:	50                   	push   %eax
  101983:	68 15 37 10 00       	push   $0x103715
  101988:	e8 69 e9 ff ff       	call   1002f6 <cprintf>
  10198d:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101990:	8b 45 08             	mov    0x8(%ebp),%eax
  101993:	66 8b 40 20          	mov    0x20(%eax),%ax
  101997:	0f b7 c0             	movzwl %ax,%eax
  10199a:	83 ec 08             	sub    $0x8,%esp
  10199d:	50                   	push   %eax
  10199e:	68 28 37 10 00       	push   $0x103728
  1019a3:	e8 4e e9 ff ff       	call   1002f6 <cprintf>
  1019a8:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  1019ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1019ae:	8b 40 30             	mov    0x30(%eax),%eax
  1019b1:	83 ec 0c             	sub    $0xc,%esp
  1019b4:	50                   	push   %eax
  1019b5:	e8 16 ff ff ff       	call   1018d0 <trapname>
  1019ba:	83 c4 10             	add    $0x10,%esp
  1019bd:	89 c2                	mov    %eax,%edx
  1019bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1019c2:	8b 40 30             	mov    0x30(%eax),%eax
  1019c5:	83 ec 04             	sub    $0x4,%esp
  1019c8:	52                   	push   %edx
  1019c9:	50                   	push   %eax
  1019ca:	68 3b 37 10 00       	push   $0x10373b
  1019cf:	e8 22 e9 ff ff       	call   1002f6 <cprintf>
  1019d4:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  1019d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1019da:	8b 40 34             	mov    0x34(%eax),%eax
  1019dd:	83 ec 08             	sub    $0x8,%esp
  1019e0:	50                   	push   %eax
  1019e1:	68 4d 37 10 00       	push   $0x10374d
  1019e6:	e8 0b e9 ff ff       	call   1002f6 <cprintf>
  1019eb:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  1019ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1019f1:	8b 40 38             	mov    0x38(%eax),%eax
  1019f4:	83 ec 08             	sub    $0x8,%esp
  1019f7:	50                   	push   %eax
  1019f8:	68 5c 37 10 00       	push   $0x10375c
  1019fd:	e8 f4 e8 ff ff       	call   1002f6 <cprintf>
  101a02:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101a05:	8b 45 08             	mov    0x8(%ebp),%eax
  101a08:	66 8b 40 3c          	mov    0x3c(%eax),%ax
  101a0c:	0f b7 c0             	movzwl %ax,%eax
  101a0f:	83 ec 08             	sub    $0x8,%esp
  101a12:	50                   	push   %eax
  101a13:	68 6b 37 10 00       	push   $0x10376b
  101a18:	e8 d9 e8 ff ff       	call   1002f6 <cprintf>
  101a1d:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101a20:	8b 45 08             	mov    0x8(%ebp),%eax
  101a23:	8b 40 40             	mov    0x40(%eax),%eax
  101a26:	83 ec 08             	sub    $0x8,%esp
  101a29:	50                   	push   %eax
  101a2a:	68 7e 37 10 00       	push   $0x10377e
  101a2f:	e8 c2 e8 ff ff       	call   1002f6 <cprintf>
  101a34:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101a37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101a3e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101a45:	eb 43                	jmp    101a8a <print_trapframe+0x173>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101a47:	8b 45 08             	mov    0x8(%ebp),%eax
  101a4a:	8b 50 40             	mov    0x40(%eax),%edx
  101a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101a50:	21 d0                	and    %edx,%eax
  101a52:	85 c0                	test   %eax,%eax
  101a54:	74 29                	je     101a7f <print_trapframe+0x168>
  101a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101a59:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  101a60:	85 c0                	test   %eax,%eax
  101a62:	74 1b                	je     101a7f <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
  101a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101a67:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  101a6e:	83 ec 08             	sub    $0x8,%esp
  101a71:	50                   	push   %eax
  101a72:	68 8d 37 10 00       	push   $0x10378d
  101a77:	e8 7a e8 ff ff       	call   1002f6 <cprintf>
  101a7c:	83 c4 10             	add    $0x10,%esp
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101a7f:	ff 45 f4             	incl   -0xc(%ebp)
  101a82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101a85:	01 c0                	add    %eax,%eax
  101a87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  101a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101a8d:	83 f8 17             	cmp    $0x17,%eax
  101a90:	76 b5                	jbe    101a47 <print_trapframe+0x130>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101a92:	8b 45 08             	mov    0x8(%ebp),%eax
  101a95:	8b 40 40             	mov    0x40(%eax),%eax
  101a98:	c1 e8 0c             	shr    $0xc,%eax
  101a9b:	83 e0 03             	and    $0x3,%eax
  101a9e:	83 ec 08             	sub    $0x8,%esp
  101aa1:	50                   	push   %eax
  101aa2:	68 91 37 10 00       	push   $0x103791
  101aa7:	e8 4a e8 ff ff       	call   1002f6 <cprintf>
  101aac:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  101aaf:	83 ec 0c             	sub    $0xc,%esp
  101ab2:	ff 75 08             	pushl  0x8(%ebp)
  101ab5:	e8 47 fe ff ff       	call   101901 <trap_in_kernel>
  101aba:	83 c4 10             	add    $0x10,%esp
  101abd:	85 c0                	test   %eax,%eax
  101abf:	75 32                	jne    101af3 <print_trapframe+0x1dc>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac4:	8b 40 44             	mov    0x44(%eax),%eax
  101ac7:	83 ec 08             	sub    $0x8,%esp
  101aca:	50                   	push   %eax
  101acb:	68 9a 37 10 00       	push   $0x10379a
  101ad0:	e8 21 e8 ff ff       	call   1002f6 <cprintf>
  101ad5:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  101adb:	66 8b 40 48          	mov    0x48(%eax),%ax
  101adf:	0f b7 c0             	movzwl %ax,%eax
  101ae2:	83 ec 08             	sub    $0x8,%esp
  101ae5:	50                   	push   %eax
  101ae6:	68 a9 37 10 00       	push   $0x1037a9
  101aeb:	e8 06 e8 ff ff       	call   1002f6 <cprintf>
  101af0:	83 c4 10             	add    $0x10,%esp
    }
}
  101af3:	90                   	nop
  101af4:	c9                   	leave  
  101af5:	c3                   	ret    

00101af6 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101af6:	55                   	push   %ebp
  101af7:	89 e5                	mov    %esp,%ebp
  101af9:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101afc:	8b 45 08             	mov    0x8(%ebp),%eax
  101aff:	8b 00                	mov    (%eax),%eax
  101b01:	83 ec 08             	sub    $0x8,%esp
  101b04:	50                   	push   %eax
  101b05:	68 bc 37 10 00       	push   $0x1037bc
  101b0a:	e8 e7 e7 ff ff       	call   1002f6 <cprintf>
  101b0f:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101b12:	8b 45 08             	mov    0x8(%ebp),%eax
  101b15:	8b 40 04             	mov    0x4(%eax),%eax
  101b18:	83 ec 08             	sub    $0x8,%esp
  101b1b:	50                   	push   %eax
  101b1c:	68 cb 37 10 00       	push   $0x1037cb
  101b21:	e8 d0 e7 ff ff       	call   1002f6 <cprintf>
  101b26:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101b29:	8b 45 08             	mov    0x8(%ebp),%eax
  101b2c:	8b 40 08             	mov    0x8(%eax),%eax
  101b2f:	83 ec 08             	sub    $0x8,%esp
  101b32:	50                   	push   %eax
  101b33:	68 da 37 10 00       	push   $0x1037da
  101b38:	e8 b9 e7 ff ff       	call   1002f6 <cprintf>
  101b3d:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101b40:	8b 45 08             	mov    0x8(%ebp),%eax
  101b43:	8b 40 0c             	mov    0xc(%eax),%eax
  101b46:	83 ec 08             	sub    $0x8,%esp
  101b49:	50                   	push   %eax
  101b4a:	68 e9 37 10 00       	push   $0x1037e9
  101b4f:	e8 a2 e7 ff ff       	call   1002f6 <cprintf>
  101b54:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101b57:	8b 45 08             	mov    0x8(%ebp),%eax
  101b5a:	8b 40 10             	mov    0x10(%eax),%eax
  101b5d:	83 ec 08             	sub    $0x8,%esp
  101b60:	50                   	push   %eax
  101b61:	68 f8 37 10 00       	push   $0x1037f8
  101b66:	e8 8b e7 ff ff       	call   1002f6 <cprintf>
  101b6b:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b71:	8b 40 14             	mov    0x14(%eax),%eax
  101b74:	83 ec 08             	sub    $0x8,%esp
  101b77:	50                   	push   %eax
  101b78:	68 07 38 10 00       	push   $0x103807
  101b7d:	e8 74 e7 ff ff       	call   1002f6 <cprintf>
  101b82:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101b85:	8b 45 08             	mov    0x8(%ebp),%eax
  101b88:	8b 40 18             	mov    0x18(%eax),%eax
  101b8b:	83 ec 08             	sub    $0x8,%esp
  101b8e:	50                   	push   %eax
  101b8f:	68 16 38 10 00       	push   $0x103816
  101b94:	e8 5d e7 ff ff       	call   1002f6 <cprintf>
  101b99:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b9f:	8b 40 1c             	mov    0x1c(%eax),%eax
  101ba2:	83 ec 08             	sub    $0x8,%esp
  101ba5:	50                   	push   %eax
  101ba6:	68 25 38 10 00       	push   $0x103825
  101bab:	e8 46 e7 ff ff       	call   1002f6 <cprintf>
  101bb0:	83 c4 10             	add    $0x10,%esp
}
  101bb3:	90                   	nop
  101bb4:	c9                   	leave  
  101bb5:	c3                   	ret    

00101bb6 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101bb6:	55                   	push   %ebp
  101bb7:	89 e5                	mov    %esp,%ebp
  101bb9:	83 ec 18             	sub    $0x18,%esp
    char c;

    switch (tf->tf_trapno) {
  101bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  101bbf:	8b 40 30             	mov    0x30(%eax),%eax
  101bc2:	83 f8 2f             	cmp    $0x2f,%eax
  101bc5:	77 1d                	ja     101be4 <trap_dispatch+0x2e>
  101bc7:	83 f8 2e             	cmp    $0x2e,%eax
  101bca:	0f 83 e7 00 00 00    	jae    101cb7 <trap_dispatch+0x101>
  101bd0:	83 f8 21             	cmp    $0x21,%eax
  101bd3:	74 71                	je     101c46 <trap_dispatch+0x90>
  101bd5:	83 f8 24             	cmp    $0x24,%eax
  101bd8:	74 48                	je     101c22 <trap_dispatch+0x6c>
  101bda:	83 f8 20             	cmp    $0x20,%eax
  101bdd:	74 13                	je     101bf2 <trap_dispatch+0x3c>
  101bdf:	e9 9d 00 00 00       	jmp    101c81 <trap_dispatch+0xcb>
  101be4:	83 e8 78             	sub    $0x78,%eax
  101be7:	83 f8 01             	cmp    $0x1,%eax
  101bea:	0f 87 91 00 00 00    	ja     101c81 <trap_dispatch+0xcb>
  101bf0:	eb 78                	jmp    101c6a <trap_dispatch+0xb4>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ++ticks;
  101bf2:	a1 08 09 11 00       	mov    0x110908,%eax
  101bf7:	40                   	inc    %eax
  101bf8:	a3 08 09 11 00       	mov    %eax,0x110908
        if (ticks % TICK_NUM == 0)
  101bfd:	a1 08 09 11 00       	mov    0x110908,%eax
  101c02:	b9 64 00 00 00       	mov    $0x64,%ecx
  101c07:	ba 00 00 00 00       	mov    $0x0,%edx
  101c0c:	f7 f1                	div    %ecx
  101c0e:	89 d0                	mov    %edx,%eax
  101c10:	85 c0                	test   %eax,%eax
  101c12:	0f 85 a2 00 00 00    	jne    101cba <trap_dispatch+0x104>
            print_ticks();
  101c18:	e8 3e fb ff ff       	call   10175b <print_ticks>
        break;
  101c1d:	e9 98 00 00 00       	jmp    101cba <trap_dispatch+0x104>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101c22:	e8 1e f9 ff ff       	call   101545 <cons_getc>
  101c27:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101c2a:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101c2e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101c32:	83 ec 04             	sub    $0x4,%esp
  101c35:	52                   	push   %edx
  101c36:	50                   	push   %eax
  101c37:	68 34 38 10 00       	push   $0x103834
  101c3c:	e8 b5 e6 ff ff       	call   1002f6 <cprintf>
  101c41:	83 c4 10             	add    $0x10,%esp
        break;
  101c44:	eb 75                	jmp    101cbb <trap_dispatch+0x105>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101c46:	e8 fa f8 ff ff       	call   101545 <cons_getc>
  101c4b:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101c4e:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101c52:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101c56:	83 ec 04             	sub    $0x4,%esp
  101c59:	52                   	push   %edx
  101c5a:	50                   	push   %eax
  101c5b:	68 46 38 10 00       	push   $0x103846
  101c60:	e8 91 e6 ff ff       	call   1002f6 <cprintf>
  101c65:	83 c4 10             	add    $0x10,%esp
        break;
  101c68:	eb 51                	jmp    101cbb <trap_dispatch+0x105>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101c6a:	83 ec 04             	sub    $0x4,%esp
  101c6d:	68 55 38 10 00       	push   $0x103855
  101c72:	68 b4 00 00 00       	push   $0xb4
  101c77:	68 65 38 10 00       	push   $0x103865
  101c7c:	e8 c9 ef ff ff       	call   100c4a <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101c81:	8b 45 08             	mov    0x8(%ebp),%eax
  101c84:	66 8b 40 3c          	mov    0x3c(%eax),%ax
  101c88:	0f b7 c0             	movzwl %ax,%eax
  101c8b:	83 e0 03             	and    $0x3,%eax
  101c8e:	85 c0                	test   %eax,%eax
  101c90:	75 29                	jne    101cbb <trap_dispatch+0x105>
            print_trapframe(tf);
  101c92:	83 ec 0c             	sub    $0xc,%esp
  101c95:	ff 75 08             	pushl  0x8(%ebp)
  101c98:	e8 7a fc ff ff       	call   101917 <print_trapframe>
  101c9d:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101ca0:	83 ec 04             	sub    $0x4,%esp
  101ca3:	68 76 38 10 00       	push   $0x103876
  101ca8:	68 be 00 00 00       	push   $0xbe
  101cad:	68 65 38 10 00       	push   $0x103865
  101cb2:	e8 93 ef ff ff       	call   100c4a <__panic>
        break;
  101cb7:	90                   	nop
  101cb8:	eb 01                	jmp    101cbb <trap_dispatch+0x105>
        break;
  101cba:	90                   	nop
        }
    }
}
  101cbb:	90                   	nop
  101cbc:	c9                   	leave  
  101cbd:	c3                   	ret    

00101cbe <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101cbe:	55                   	push   %ebp
  101cbf:	89 e5                	mov    %esp,%ebp
  101cc1:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101cc4:	83 ec 0c             	sub    $0xc,%esp
  101cc7:	ff 75 08             	pushl  0x8(%ebp)
  101cca:	e8 e7 fe ff ff       	call   101bb6 <trap_dispatch>
  101ccf:	83 c4 10             	add    $0x10,%esp
}
  101cd2:	90                   	nop
  101cd3:	c9                   	leave  
  101cd4:	c3                   	ret    

00101cd5 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101cd5:	1e                   	push   %ds
    pushl %es
  101cd6:	06                   	push   %es
    pushl %fs
  101cd7:	0f a0                	push   %fs
    pushl %gs
  101cd9:	0f a8                	push   %gs
    pushal
  101cdb:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101cdc:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101ce1:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101ce3:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101ce5:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101ce6:	e8 d3 ff ff ff       	call   101cbe <trap>

    # pop the pushed stack pointer
    popl %esp
  101ceb:	5c                   	pop    %esp

00101cec <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101cec:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101ced:	0f a9                	pop    %gs
    popl %fs
  101cef:	0f a1                	pop    %fs
    popl %es
  101cf1:	07                   	pop    %es
    popl %ds
  101cf2:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101cf3:	83 c4 08             	add    $0x8,%esp
    iret
  101cf6:	cf                   	iret   

00101cf7 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101cf7:	6a 00                	push   $0x0
  pushl $0
  101cf9:	6a 00                	push   $0x0
  jmp __alltraps
  101cfb:	e9 d5 ff ff ff       	jmp    101cd5 <__alltraps>

00101d00 <vector1>:
.globl vector1
vector1:
  pushl $0
  101d00:	6a 00                	push   $0x0
  pushl $1
  101d02:	6a 01                	push   $0x1
  jmp __alltraps
  101d04:	e9 cc ff ff ff       	jmp    101cd5 <__alltraps>

00101d09 <vector2>:
.globl vector2
vector2:
  pushl $0
  101d09:	6a 00                	push   $0x0
  pushl $2
  101d0b:	6a 02                	push   $0x2
  jmp __alltraps
  101d0d:	e9 c3 ff ff ff       	jmp    101cd5 <__alltraps>

00101d12 <vector3>:
.globl vector3
vector3:
  pushl $0
  101d12:	6a 00                	push   $0x0
  pushl $3
  101d14:	6a 03                	push   $0x3
  jmp __alltraps
  101d16:	e9 ba ff ff ff       	jmp    101cd5 <__alltraps>

00101d1b <vector4>:
.globl vector4
vector4:
  pushl $0
  101d1b:	6a 00                	push   $0x0
  pushl $4
  101d1d:	6a 04                	push   $0x4
  jmp __alltraps
  101d1f:	e9 b1 ff ff ff       	jmp    101cd5 <__alltraps>

00101d24 <vector5>:
.globl vector5
vector5:
  pushl $0
  101d24:	6a 00                	push   $0x0
  pushl $5
  101d26:	6a 05                	push   $0x5
  jmp __alltraps
  101d28:	e9 a8 ff ff ff       	jmp    101cd5 <__alltraps>

00101d2d <vector6>:
.globl vector6
vector6:
  pushl $0
  101d2d:	6a 00                	push   $0x0
  pushl $6
  101d2f:	6a 06                	push   $0x6
  jmp __alltraps
  101d31:	e9 9f ff ff ff       	jmp    101cd5 <__alltraps>

00101d36 <vector7>:
.globl vector7
vector7:
  pushl $0
  101d36:	6a 00                	push   $0x0
  pushl $7
  101d38:	6a 07                	push   $0x7
  jmp __alltraps
  101d3a:	e9 96 ff ff ff       	jmp    101cd5 <__alltraps>

00101d3f <vector8>:
.globl vector8
vector8:
  pushl $8
  101d3f:	6a 08                	push   $0x8
  jmp __alltraps
  101d41:	e9 8f ff ff ff       	jmp    101cd5 <__alltraps>

00101d46 <vector9>:
.globl vector9
vector9:
  pushl $0
  101d46:	6a 00                	push   $0x0
  pushl $9
  101d48:	6a 09                	push   $0x9
  jmp __alltraps
  101d4a:	e9 86 ff ff ff       	jmp    101cd5 <__alltraps>

00101d4f <vector10>:
.globl vector10
vector10:
  pushl $10
  101d4f:	6a 0a                	push   $0xa
  jmp __alltraps
  101d51:	e9 7f ff ff ff       	jmp    101cd5 <__alltraps>

00101d56 <vector11>:
.globl vector11
vector11:
  pushl $11
  101d56:	6a 0b                	push   $0xb
  jmp __alltraps
  101d58:	e9 78 ff ff ff       	jmp    101cd5 <__alltraps>

00101d5d <vector12>:
.globl vector12
vector12:
  pushl $12
  101d5d:	6a 0c                	push   $0xc
  jmp __alltraps
  101d5f:	e9 71 ff ff ff       	jmp    101cd5 <__alltraps>

00101d64 <vector13>:
.globl vector13
vector13:
  pushl $13
  101d64:	6a 0d                	push   $0xd
  jmp __alltraps
  101d66:	e9 6a ff ff ff       	jmp    101cd5 <__alltraps>

00101d6b <vector14>:
.globl vector14
vector14:
  pushl $14
  101d6b:	6a 0e                	push   $0xe
  jmp __alltraps
  101d6d:	e9 63 ff ff ff       	jmp    101cd5 <__alltraps>

00101d72 <vector15>:
.globl vector15
vector15:
  pushl $0
  101d72:	6a 00                	push   $0x0
  pushl $15
  101d74:	6a 0f                	push   $0xf
  jmp __alltraps
  101d76:	e9 5a ff ff ff       	jmp    101cd5 <__alltraps>

00101d7b <vector16>:
.globl vector16
vector16:
  pushl $0
  101d7b:	6a 00                	push   $0x0
  pushl $16
  101d7d:	6a 10                	push   $0x10
  jmp __alltraps
  101d7f:	e9 51 ff ff ff       	jmp    101cd5 <__alltraps>

00101d84 <vector17>:
.globl vector17
vector17:
  pushl $17
  101d84:	6a 11                	push   $0x11
  jmp __alltraps
  101d86:	e9 4a ff ff ff       	jmp    101cd5 <__alltraps>

00101d8b <vector18>:
.globl vector18
vector18:
  pushl $0
  101d8b:	6a 00                	push   $0x0
  pushl $18
  101d8d:	6a 12                	push   $0x12
  jmp __alltraps
  101d8f:	e9 41 ff ff ff       	jmp    101cd5 <__alltraps>

00101d94 <vector19>:
.globl vector19
vector19:
  pushl $0
  101d94:	6a 00                	push   $0x0
  pushl $19
  101d96:	6a 13                	push   $0x13
  jmp __alltraps
  101d98:	e9 38 ff ff ff       	jmp    101cd5 <__alltraps>

00101d9d <vector20>:
.globl vector20
vector20:
  pushl $0
  101d9d:	6a 00                	push   $0x0
  pushl $20
  101d9f:	6a 14                	push   $0x14
  jmp __alltraps
  101da1:	e9 2f ff ff ff       	jmp    101cd5 <__alltraps>

00101da6 <vector21>:
.globl vector21
vector21:
  pushl $0
  101da6:	6a 00                	push   $0x0
  pushl $21
  101da8:	6a 15                	push   $0x15
  jmp __alltraps
  101daa:	e9 26 ff ff ff       	jmp    101cd5 <__alltraps>

00101daf <vector22>:
.globl vector22
vector22:
  pushl $0
  101daf:	6a 00                	push   $0x0
  pushl $22
  101db1:	6a 16                	push   $0x16
  jmp __alltraps
  101db3:	e9 1d ff ff ff       	jmp    101cd5 <__alltraps>

00101db8 <vector23>:
.globl vector23
vector23:
  pushl $0
  101db8:	6a 00                	push   $0x0
  pushl $23
  101dba:	6a 17                	push   $0x17
  jmp __alltraps
  101dbc:	e9 14 ff ff ff       	jmp    101cd5 <__alltraps>

00101dc1 <vector24>:
.globl vector24
vector24:
  pushl $0
  101dc1:	6a 00                	push   $0x0
  pushl $24
  101dc3:	6a 18                	push   $0x18
  jmp __alltraps
  101dc5:	e9 0b ff ff ff       	jmp    101cd5 <__alltraps>

00101dca <vector25>:
.globl vector25
vector25:
  pushl $0
  101dca:	6a 00                	push   $0x0
  pushl $25
  101dcc:	6a 19                	push   $0x19
  jmp __alltraps
  101dce:	e9 02 ff ff ff       	jmp    101cd5 <__alltraps>

00101dd3 <vector26>:
.globl vector26
vector26:
  pushl $0
  101dd3:	6a 00                	push   $0x0
  pushl $26
  101dd5:	6a 1a                	push   $0x1a
  jmp __alltraps
  101dd7:	e9 f9 fe ff ff       	jmp    101cd5 <__alltraps>

00101ddc <vector27>:
.globl vector27
vector27:
  pushl $0
  101ddc:	6a 00                	push   $0x0
  pushl $27
  101dde:	6a 1b                	push   $0x1b
  jmp __alltraps
  101de0:	e9 f0 fe ff ff       	jmp    101cd5 <__alltraps>

00101de5 <vector28>:
.globl vector28
vector28:
  pushl $0
  101de5:	6a 00                	push   $0x0
  pushl $28
  101de7:	6a 1c                	push   $0x1c
  jmp __alltraps
  101de9:	e9 e7 fe ff ff       	jmp    101cd5 <__alltraps>

00101dee <vector29>:
.globl vector29
vector29:
  pushl $0
  101dee:	6a 00                	push   $0x0
  pushl $29
  101df0:	6a 1d                	push   $0x1d
  jmp __alltraps
  101df2:	e9 de fe ff ff       	jmp    101cd5 <__alltraps>

00101df7 <vector30>:
.globl vector30
vector30:
  pushl $0
  101df7:	6a 00                	push   $0x0
  pushl $30
  101df9:	6a 1e                	push   $0x1e
  jmp __alltraps
  101dfb:	e9 d5 fe ff ff       	jmp    101cd5 <__alltraps>

00101e00 <vector31>:
.globl vector31
vector31:
  pushl $0
  101e00:	6a 00                	push   $0x0
  pushl $31
  101e02:	6a 1f                	push   $0x1f
  jmp __alltraps
  101e04:	e9 cc fe ff ff       	jmp    101cd5 <__alltraps>

00101e09 <vector32>:
.globl vector32
vector32:
  pushl $0
  101e09:	6a 00                	push   $0x0
  pushl $32
  101e0b:	6a 20                	push   $0x20
  jmp __alltraps
  101e0d:	e9 c3 fe ff ff       	jmp    101cd5 <__alltraps>

00101e12 <vector33>:
.globl vector33
vector33:
  pushl $0
  101e12:	6a 00                	push   $0x0
  pushl $33
  101e14:	6a 21                	push   $0x21
  jmp __alltraps
  101e16:	e9 ba fe ff ff       	jmp    101cd5 <__alltraps>

00101e1b <vector34>:
.globl vector34
vector34:
  pushl $0
  101e1b:	6a 00                	push   $0x0
  pushl $34
  101e1d:	6a 22                	push   $0x22
  jmp __alltraps
  101e1f:	e9 b1 fe ff ff       	jmp    101cd5 <__alltraps>

00101e24 <vector35>:
.globl vector35
vector35:
  pushl $0
  101e24:	6a 00                	push   $0x0
  pushl $35
  101e26:	6a 23                	push   $0x23
  jmp __alltraps
  101e28:	e9 a8 fe ff ff       	jmp    101cd5 <__alltraps>

00101e2d <vector36>:
.globl vector36
vector36:
  pushl $0
  101e2d:	6a 00                	push   $0x0
  pushl $36
  101e2f:	6a 24                	push   $0x24
  jmp __alltraps
  101e31:	e9 9f fe ff ff       	jmp    101cd5 <__alltraps>

00101e36 <vector37>:
.globl vector37
vector37:
  pushl $0
  101e36:	6a 00                	push   $0x0
  pushl $37
  101e38:	6a 25                	push   $0x25
  jmp __alltraps
  101e3a:	e9 96 fe ff ff       	jmp    101cd5 <__alltraps>

00101e3f <vector38>:
.globl vector38
vector38:
  pushl $0
  101e3f:	6a 00                	push   $0x0
  pushl $38
  101e41:	6a 26                	push   $0x26
  jmp __alltraps
  101e43:	e9 8d fe ff ff       	jmp    101cd5 <__alltraps>

00101e48 <vector39>:
.globl vector39
vector39:
  pushl $0
  101e48:	6a 00                	push   $0x0
  pushl $39
  101e4a:	6a 27                	push   $0x27
  jmp __alltraps
  101e4c:	e9 84 fe ff ff       	jmp    101cd5 <__alltraps>

00101e51 <vector40>:
.globl vector40
vector40:
  pushl $0
  101e51:	6a 00                	push   $0x0
  pushl $40
  101e53:	6a 28                	push   $0x28
  jmp __alltraps
  101e55:	e9 7b fe ff ff       	jmp    101cd5 <__alltraps>

00101e5a <vector41>:
.globl vector41
vector41:
  pushl $0
  101e5a:	6a 00                	push   $0x0
  pushl $41
  101e5c:	6a 29                	push   $0x29
  jmp __alltraps
  101e5e:	e9 72 fe ff ff       	jmp    101cd5 <__alltraps>

00101e63 <vector42>:
.globl vector42
vector42:
  pushl $0
  101e63:	6a 00                	push   $0x0
  pushl $42
  101e65:	6a 2a                	push   $0x2a
  jmp __alltraps
  101e67:	e9 69 fe ff ff       	jmp    101cd5 <__alltraps>

00101e6c <vector43>:
.globl vector43
vector43:
  pushl $0
  101e6c:	6a 00                	push   $0x0
  pushl $43
  101e6e:	6a 2b                	push   $0x2b
  jmp __alltraps
  101e70:	e9 60 fe ff ff       	jmp    101cd5 <__alltraps>

00101e75 <vector44>:
.globl vector44
vector44:
  pushl $0
  101e75:	6a 00                	push   $0x0
  pushl $44
  101e77:	6a 2c                	push   $0x2c
  jmp __alltraps
  101e79:	e9 57 fe ff ff       	jmp    101cd5 <__alltraps>

00101e7e <vector45>:
.globl vector45
vector45:
  pushl $0
  101e7e:	6a 00                	push   $0x0
  pushl $45
  101e80:	6a 2d                	push   $0x2d
  jmp __alltraps
  101e82:	e9 4e fe ff ff       	jmp    101cd5 <__alltraps>

00101e87 <vector46>:
.globl vector46
vector46:
  pushl $0
  101e87:	6a 00                	push   $0x0
  pushl $46
  101e89:	6a 2e                	push   $0x2e
  jmp __alltraps
  101e8b:	e9 45 fe ff ff       	jmp    101cd5 <__alltraps>

00101e90 <vector47>:
.globl vector47
vector47:
  pushl $0
  101e90:	6a 00                	push   $0x0
  pushl $47
  101e92:	6a 2f                	push   $0x2f
  jmp __alltraps
  101e94:	e9 3c fe ff ff       	jmp    101cd5 <__alltraps>

00101e99 <vector48>:
.globl vector48
vector48:
  pushl $0
  101e99:	6a 00                	push   $0x0
  pushl $48
  101e9b:	6a 30                	push   $0x30
  jmp __alltraps
  101e9d:	e9 33 fe ff ff       	jmp    101cd5 <__alltraps>

00101ea2 <vector49>:
.globl vector49
vector49:
  pushl $0
  101ea2:	6a 00                	push   $0x0
  pushl $49
  101ea4:	6a 31                	push   $0x31
  jmp __alltraps
  101ea6:	e9 2a fe ff ff       	jmp    101cd5 <__alltraps>

00101eab <vector50>:
.globl vector50
vector50:
  pushl $0
  101eab:	6a 00                	push   $0x0
  pushl $50
  101ead:	6a 32                	push   $0x32
  jmp __alltraps
  101eaf:	e9 21 fe ff ff       	jmp    101cd5 <__alltraps>

00101eb4 <vector51>:
.globl vector51
vector51:
  pushl $0
  101eb4:	6a 00                	push   $0x0
  pushl $51
  101eb6:	6a 33                	push   $0x33
  jmp __alltraps
  101eb8:	e9 18 fe ff ff       	jmp    101cd5 <__alltraps>

00101ebd <vector52>:
.globl vector52
vector52:
  pushl $0
  101ebd:	6a 00                	push   $0x0
  pushl $52
  101ebf:	6a 34                	push   $0x34
  jmp __alltraps
  101ec1:	e9 0f fe ff ff       	jmp    101cd5 <__alltraps>

00101ec6 <vector53>:
.globl vector53
vector53:
  pushl $0
  101ec6:	6a 00                	push   $0x0
  pushl $53
  101ec8:	6a 35                	push   $0x35
  jmp __alltraps
  101eca:	e9 06 fe ff ff       	jmp    101cd5 <__alltraps>

00101ecf <vector54>:
.globl vector54
vector54:
  pushl $0
  101ecf:	6a 00                	push   $0x0
  pushl $54
  101ed1:	6a 36                	push   $0x36
  jmp __alltraps
  101ed3:	e9 fd fd ff ff       	jmp    101cd5 <__alltraps>

00101ed8 <vector55>:
.globl vector55
vector55:
  pushl $0
  101ed8:	6a 00                	push   $0x0
  pushl $55
  101eda:	6a 37                	push   $0x37
  jmp __alltraps
  101edc:	e9 f4 fd ff ff       	jmp    101cd5 <__alltraps>

00101ee1 <vector56>:
.globl vector56
vector56:
  pushl $0
  101ee1:	6a 00                	push   $0x0
  pushl $56
  101ee3:	6a 38                	push   $0x38
  jmp __alltraps
  101ee5:	e9 eb fd ff ff       	jmp    101cd5 <__alltraps>

00101eea <vector57>:
.globl vector57
vector57:
  pushl $0
  101eea:	6a 00                	push   $0x0
  pushl $57
  101eec:	6a 39                	push   $0x39
  jmp __alltraps
  101eee:	e9 e2 fd ff ff       	jmp    101cd5 <__alltraps>

00101ef3 <vector58>:
.globl vector58
vector58:
  pushl $0
  101ef3:	6a 00                	push   $0x0
  pushl $58
  101ef5:	6a 3a                	push   $0x3a
  jmp __alltraps
  101ef7:	e9 d9 fd ff ff       	jmp    101cd5 <__alltraps>

00101efc <vector59>:
.globl vector59
vector59:
  pushl $0
  101efc:	6a 00                	push   $0x0
  pushl $59
  101efe:	6a 3b                	push   $0x3b
  jmp __alltraps
  101f00:	e9 d0 fd ff ff       	jmp    101cd5 <__alltraps>

00101f05 <vector60>:
.globl vector60
vector60:
  pushl $0
  101f05:	6a 00                	push   $0x0
  pushl $60
  101f07:	6a 3c                	push   $0x3c
  jmp __alltraps
  101f09:	e9 c7 fd ff ff       	jmp    101cd5 <__alltraps>

00101f0e <vector61>:
.globl vector61
vector61:
  pushl $0
  101f0e:	6a 00                	push   $0x0
  pushl $61
  101f10:	6a 3d                	push   $0x3d
  jmp __alltraps
  101f12:	e9 be fd ff ff       	jmp    101cd5 <__alltraps>

00101f17 <vector62>:
.globl vector62
vector62:
  pushl $0
  101f17:	6a 00                	push   $0x0
  pushl $62
  101f19:	6a 3e                	push   $0x3e
  jmp __alltraps
  101f1b:	e9 b5 fd ff ff       	jmp    101cd5 <__alltraps>

00101f20 <vector63>:
.globl vector63
vector63:
  pushl $0
  101f20:	6a 00                	push   $0x0
  pushl $63
  101f22:	6a 3f                	push   $0x3f
  jmp __alltraps
  101f24:	e9 ac fd ff ff       	jmp    101cd5 <__alltraps>

00101f29 <vector64>:
.globl vector64
vector64:
  pushl $0
  101f29:	6a 00                	push   $0x0
  pushl $64
  101f2b:	6a 40                	push   $0x40
  jmp __alltraps
  101f2d:	e9 a3 fd ff ff       	jmp    101cd5 <__alltraps>

00101f32 <vector65>:
.globl vector65
vector65:
  pushl $0
  101f32:	6a 00                	push   $0x0
  pushl $65
  101f34:	6a 41                	push   $0x41
  jmp __alltraps
  101f36:	e9 9a fd ff ff       	jmp    101cd5 <__alltraps>

00101f3b <vector66>:
.globl vector66
vector66:
  pushl $0
  101f3b:	6a 00                	push   $0x0
  pushl $66
  101f3d:	6a 42                	push   $0x42
  jmp __alltraps
  101f3f:	e9 91 fd ff ff       	jmp    101cd5 <__alltraps>

00101f44 <vector67>:
.globl vector67
vector67:
  pushl $0
  101f44:	6a 00                	push   $0x0
  pushl $67
  101f46:	6a 43                	push   $0x43
  jmp __alltraps
  101f48:	e9 88 fd ff ff       	jmp    101cd5 <__alltraps>

00101f4d <vector68>:
.globl vector68
vector68:
  pushl $0
  101f4d:	6a 00                	push   $0x0
  pushl $68
  101f4f:	6a 44                	push   $0x44
  jmp __alltraps
  101f51:	e9 7f fd ff ff       	jmp    101cd5 <__alltraps>

00101f56 <vector69>:
.globl vector69
vector69:
  pushl $0
  101f56:	6a 00                	push   $0x0
  pushl $69
  101f58:	6a 45                	push   $0x45
  jmp __alltraps
  101f5a:	e9 76 fd ff ff       	jmp    101cd5 <__alltraps>

00101f5f <vector70>:
.globl vector70
vector70:
  pushl $0
  101f5f:	6a 00                	push   $0x0
  pushl $70
  101f61:	6a 46                	push   $0x46
  jmp __alltraps
  101f63:	e9 6d fd ff ff       	jmp    101cd5 <__alltraps>

00101f68 <vector71>:
.globl vector71
vector71:
  pushl $0
  101f68:	6a 00                	push   $0x0
  pushl $71
  101f6a:	6a 47                	push   $0x47
  jmp __alltraps
  101f6c:	e9 64 fd ff ff       	jmp    101cd5 <__alltraps>

00101f71 <vector72>:
.globl vector72
vector72:
  pushl $0
  101f71:	6a 00                	push   $0x0
  pushl $72
  101f73:	6a 48                	push   $0x48
  jmp __alltraps
  101f75:	e9 5b fd ff ff       	jmp    101cd5 <__alltraps>

00101f7a <vector73>:
.globl vector73
vector73:
  pushl $0
  101f7a:	6a 00                	push   $0x0
  pushl $73
  101f7c:	6a 49                	push   $0x49
  jmp __alltraps
  101f7e:	e9 52 fd ff ff       	jmp    101cd5 <__alltraps>

00101f83 <vector74>:
.globl vector74
vector74:
  pushl $0
  101f83:	6a 00                	push   $0x0
  pushl $74
  101f85:	6a 4a                	push   $0x4a
  jmp __alltraps
  101f87:	e9 49 fd ff ff       	jmp    101cd5 <__alltraps>

00101f8c <vector75>:
.globl vector75
vector75:
  pushl $0
  101f8c:	6a 00                	push   $0x0
  pushl $75
  101f8e:	6a 4b                	push   $0x4b
  jmp __alltraps
  101f90:	e9 40 fd ff ff       	jmp    101cd5 <__alltraps>

00101f95 <vector76>:
.globl vector76
vector76:
  pushl $0
  101f95:	6a 00                	push   $0x0
  pushl $76
  101f97:	6a 4c                	push   $0x4c
  jmp __alltraps
  101f99:	e9 37 fd ff ff       	jmp    101cd5 <__alltraps>

00101f9e <vector77>:
.globl vector77
vector77:
  pushl $0
  101f9e:	6a 00                	push   $0x0
  pushl $77
  101fa0:	6a 4d                	push   $0x4d
  jmp __alltraps
  101fa2:	e9 2e fd ff ff       	jmp    101cd5 <__alltraps>

00101fa7 <vector78>:
.globl vector78
vector78:
  pushl $0
  101fa7:	6a 00                	push   $0x0
  pushl $78
  101fa9:	6a 4e                	push   $0x4e
  jmp __alltraps
  101fab:	e9 25 fd ff ff       	jmp    101cd5 <__alltraps>

00101fb0 <vector79>:
.globl vector79
vector79:
  pushl $0
  101fb0:	6a 00                	push   $0x0
  pushl $79
  101fb2:	6a 4f                	push   $0x4f
  jmp __alltraps
  101fb4:	e9 1c fd ff ff       	jmp    101cd5 <__alltraps>

00101fb9 <vector80>:
.globl vector80
vector80:
  pushl $0
  101fb9:	6a 00                	push   $0x0
  pushl $80
  101fbb:	6a 50                	push   $0x50
  jmp __alltraps
  101fbd:	e9 13 fd ff ff       	jmp    101cd5 <__alltraps>

00101fc2 <vector81>:
.globl vector81
vector81:
  pushl $0
  101fc2:	6a 00                	push   $0x0
  pushl $81
  101fc4:	6a 51                	push   $0x51
  jmp __alltraps
  101fc6:	e9 0a fd ff ff       	jmp    101cd5 <__alltraps>

00101fcb <vector82>:
.globl vector82
vector82:
  pushl $0
  101fcb:	6a 00                	push   $0x0
  pushl $82
  101fcd:	6a 52                	push   $0x52
  jmp __alltraps
  101fcf:	e9 01 fd ff ff       	jmp    101cd5 <__alltraps>

00101fd4 <vector83>:
.globl vector83
vector83:
  pushl $0
  101fd4:	6a 00                	push   $0x0
  pushl $83
  101fd6:	6a 53                	push   $0x53
  jmp __alltraps
  101fd8:	e9 f8 fc ff ff       	jmp    101cd5 <__alltraps>

00101fdd <vector84>:
.globl vector84
vector84:
  pushl $0
  101fdd:	6a 00                	push   $0x0
  pushl $84
  101fdf:	6a 54                	push   $0x54
  jmp __alltraps
  101fe1:	e9 ef fc ff ff       	jmp    101cd5 <__alltraps>

00101fe6 <vector85>:
.globl vector85
vector85:
  pushl $0
  101fe6:	6a 00                	push   $0x0
  pushl $85
  101fe8:	6a 55                	push   $0x55
  jmp __alltraps
  101fea:	e9 e6 fc ff ff       	jmp    101cd5 <__alltraps>

00101fef <vector86>:
.globl vector86
vector86:
  pushl $0
  101fef:	6a 00                	push   $0x0
  pushl $86
  101ff1:	6a 56                	push   $0x56
  jmp __alltraps
  101ff3:	e9 dd fc ff ff       	jmp    101cd5 <__alltraps>

00101ff8 <vector87>:
.globl vector87
vector87:
  pushl $0
  101ff8:	6a 00                	push   $0x0
  pushl $87
  101ffa:	6a 57                	push   $0x57
  jmp __alltraps
  101ffc:	e9 d4 fc ff ff       	jmp    101cd5 <__alltraps>

00102001 <vector88>:
.globl vector88
vector88:
  pushl $0
  102001:	6a 00                	push   $0x0
  pushl $88
  102003:	6a 58                	push   $0x58
  jmp __alltraps
  102005:	e9 cb fc ff ff       	jmp    101cd5 <__alltraps>

0010200a <vector89>:
.globl vector89
vector89:
  pushl $0
  10200a:	6a 00                	push   $0x0
  pushl $89
  10200c:	6a 59                	push   $0x59
  jmp __alltraps
  10200e:	e9 c2 fc ff ff       	jmp    101cd5 <__alltraps>

00102013 <vector90>:
.globl vector90
vector90:
  pushl $0
  102013:	6a 00                	push   $0x0
  pushl $90
  102015:	6a 5a                	push   $0x5a
  jmp __alltraps
  102017:	e9 b9 fc ff ff       	jmp    101cd5 <__alltraps>

0010201c <vector91>:
.globl vector91
vector91:
  pushl $0
  10201c:	6a 00                	push   $0x0
  pushl $91
  10201e:	6a 5b                	push   $0x5b
  jmp __alltraps
  102020:	e9 b0 fc ff ff       	jmp    101cd5 <__alltraps>

00102025 <vector92>:
.globl vector92
vector92:
  pushl $0
  102025:	6a 00                	push   $0x0
  pushl $92
  102027:	6a 5c                	push   $0x5c
  jmp __alltraps
  102029:	e9 a7 fc ff ff       	jmp    101cd5 <__alltraps>

0010202e <vector93>:
.globl vector93
vector93:
  pushl $0
  10202e:	6a 00                	push   $0x0
  pushl $93
  102030:	6a 5d                	push   $0x5d
  jmp __alltraps
  102032:	e9 9e fc ff ff       	jmp    101cd5 <__alltraps>

00102037 <vector94>:
.globl vector94
vector94:
  pushl $0
  102037:	6a 00                	push   $0x0
  pushl $94
  102039:	6a 5e                	push   $0x5e
  jmp __alltraps
  10203b:	e9 95 fc ff ff       	jmp    101cd5 <__alltraps>

00102040 <vector95>:
.globl vector95
vector95:
  pushl $0
  102040:	6a 00                	push   $0x0
  pushl $95
  102042:	6a 5f                	push   $0x5f
  jmp __alltraps
  102044:	e9 8c fc ff ff       	jmp    101cd5 <__alltraps>

00102049 <vector96>:
.globl vector96
vector96:
  pushl $0
  102049:	6a 00                	push   $0x0
  pushl $96
  10204b:	6a 60                	push   $0x60
  jmp __alltraps
  10204d:	e9 83 fc ff ff       	jmp    101cd5 <__alltraps>

00102052 <vector97>:
.globl vector97
vector97:
  pushl $0
  102052:	6a 00                	push   $0x0
  pushl $97
  102054:	6a 61                	push   $0x61
  jmp __alltraps
  102056:	e9 7a fc ff ff       	jmp    101cd5 <__alltraps>

0010205b <vector98>:
.globl vector98
vector98:
  pushl $0
  10205b:	6a 00                	push   $0x0
  pushl $98
  10205d:	6a 62                	push   $0x62
  jmp __alltraps
  10205f:	e9 71 fc ff ff       	jmp    101cd5 <__alltraps>

00102064 <vector99>:
.globl vector99
vector99:
  pushl $0
  102064:	6a 00                	push   $0x0
  pushl $99
  102066:	6a 63                	push   $0x63
  jmp __alltraps
  102068:	e9 68 fc ff ff       	jmp    101cd5 <__alltraps>

0010206d <vector100>:
.globl vector100
vector100:
  pushl $0
  10206d:	6a 00                	push   $0x0
  pushl $100
  10206f:	6a 64                	push   $0x64
  jmp __alltraps
  102071:	e9 5f fc ff ff       	jmp    101cd5 <__alltraps>

00102076 <vector101>:
.globl vector101
vector101:
  pushl $0
  102076:	6a 00                	push   $0x0
  pushl $101
  102078:	6a 65                	push   $0x65
  jmp __alltraps
  10207a:	e9 56 fc ff ff       	jmp    101cd5 <__alltraps>

0010207f <vector102>:
.globl vector102
vector102:
  pushl $0
  10207f:	6a 00                	push   $0x0
  pushl $102
  102081:	6a 66                	push   $0x66
  jmp __alltraps
  102083:	e9 4d fc ff ff       	jmp    101cd5 <__alltraps>

00102088 <vector103>:
.globl vector103
vector103:
  pushl $0
  102088:	6a 00                	push   $0x0
  pushl $103
  10208a:	6a 67                	push   $0x67
  jmp __alltraps
  10208c:	e9 44 fc ff ff       	jmp    101cd5 <__alltraps>

00102091 <vector104>:
.globl vector104
vector104:
  pushl $0
  102091:	6a 00                	push   $0x0
  pushl $104
  102093:	6a 68                	push   $0x68
  jmp __alltraps
  102095:	e9 3b fc ff ff       	jmp    101cd5 <__alltraps>

0010209a <vector105>:
.globl vector105
vector105:
  pushl $0
  10209a:	6a 00                	push   $0x0
  pushl $105
  10209c:	6a 69                	push   $0x69
  jmp __alltraps
  10209e:	e9 32 fc ff ff       	jmp    101cd5 <__alltraps>

001020a3 <vector106>:
.globl vector106
vector106:
  pushl $0
  1020a3:	6a 00                	push   $0x0
  pushl $106
  1020a5:	6a 6a                	push   $0x6a
  jmp __alltraps
  1020a7:	e9 29 fc ff ff       	jmp    101cd5 <__alltraps>

001020ac <vector107>:
.globl vector107
vector107:
  pushl $0
  1020ac:	6a 00                	push   $0x0
  pushl $107
  1020ae:	6a 6b                	push   $0x6b
  jmp __alltraps
  1020b0:	e9 20 fc ff ff       	jmp    101cd5 <__alltraps>

001020b5 <vector108>:
.globl vector108
vector108:
  pushl $0
  1020b5:	6a 00                	push   $0x0
  pushl $108
  1020b7:	6a 6c                	push   $0x6c
  jmp __alltraps
  1020b9:	e9 17 fc ff ff       	jmp    101cd5 <__alltraps>

001020be <vector109>:
.globl vector109
vector109:
  pushl $0
  1020be:	6a 00                	push   $0x0
  pushl $109
  1020c0:	6a 6d                	push   $0x6d
  jmp __alltraps
  1020c2:	e9 0e fc ff ff       	jmp    101cd5 <__alltraps>

001020c7 <vector110>:
.globl vector110
vector110:
  pushl $0
  1020c7:	6a 00                	push   $0x0
  pushl $110
  1020c9:	6a 6e                	push   $0x6e
  jmp __alltraps
  1020cb:	e9 05 fc ff ff       	jmp    101cd5 <__alltraps>

001020d0 <vector111>:
.globl vector111
vector111:
  pushl $0
  1020d0:	6a 00                	push   $0x0
  pushl $111
  1020d2:	6a 6f                	push   $0x6f
  jmp __alltraps
  1020d4:	e9 fc fb ff ff       	jmp    101cd5 <__alltraps>

001020d9 <vector112>:
.globl vector112
vector112:
  pushl $0
  1020d9:	6a 00                	push   $0x0
  pushl $112
  1020db:	6a 70                	push   $0x70
  jmp __alltraps
  1020dd:	e9 f3 fb ff ff       	jmp    101cd5 <__alltraps>

001020e2 <vector113>:
.globl vector113
vector113:
  pushl $0
  1020e2:	6a 00                	push   $0x0
  pushl $113
  1020e4:	6a 71                	push   $0x71
  jmp __alltraps
  1020e6:	e9 ea fb ff ff       	jmp    101cd5 <__alltraps>

001020eb <vector114>:
.globl vector114
vector114:
  pushl $0
  1020eb:	6a 00                	push   $0x0
  pushl $114
  1020ed:	6a 72                	push   $0x72
  jmp __alltraps
  1020ef:	e9 e1 fb ff ff       	jmp    101cd5 <__alltraps>

001020f4 <vector115>:
.globl vector115
vector115:
  pushl $0
  1020f4:	6a 00                	push   $0x0
  pushl $115
  1020f6:	6a 73                	push   $0x73
  jmp __alltraps
  1020f8:	e9 d8 fb ff ff       	jmp    101cd5 <__alltraps>

001020fd <vector116>:
.globl vector116
vector116:
  pushl $0
  1020fd:	6a 00                	push   $0x0
  pushl $116
  1020ff:	6a 74                	push   $0x74
  jmp __alltraps
  102101:	e9 cf fb ff ff       	jmp    101cd5 <__alltraps>

00102106 <vector117>:
.globl vector117
vector117:
  pushl $0
  102106:	6a 00                	push   $0x0
  pushl $117
  102108:	6a 75                	push   $0x75
  jmp __alltraps
  10210a:	e9 c6 fb ff ff       	jmp    101cd5 <__alltraps>

0010210f <vector118>:
.globl vector118
vector118:
  pushl $0
  10210f:	6a 00                	push   $0x0
  pushl $118
  102111:	6a 76                	push   $0x76
  jmp __alltraps
  102113:	e9 bd fb ff ff       	jmp    101cd5 <__alltraps>

00102118 <vector119>:
.globl vector119
vector119:
  pushl $0
  102118:	6a 00                	push   $0x0
  pushl $119
  10211a:	6a 77                	push   $0x77
  jmp __alltraps
  10211c:	e9 b4 fb ff ff       	jmp    101cd5 <__alltraps>

00102121 <vector120>:
.globl vector120
vector120:
  pushl $0
  102121:	6a 00                	push   $0x0
  pushl $120
  102123:	6a 78                	push   $0x78
  jmp __alltraps
  102125:	e9 ab fb ff ff       	jmp    101cd5 <__alltraps>

0010212a <vector121>:
.globl vector121
vector121:
  pushl $0
  10212a:	6a 00                	push   $0x0
  pushl $121
  10212c:	6a 79                	push   $0x79
  jmp __alltraps
  10212e:	e9 a2 fb ff ff       	jmp    101cd5 <__alltraps>

00102133 <vector122>:
.globl vector122
vector122:
  pushl $0
  102133:	6a 00                	push   $0x0
  pushl $122
  102135:	6a 7a                	push   $0x7a
  jmp __alltraps
  102137:	e9 99 fb ff ff       	jmp    101cd5 <__alltraps>

0010213c <vector123>:
.globl vector123
vector123:
  pushl $0
  10213c:	6a 00                	push   $0x0
  pushl $123
  10213e:	6a 7b                	push   $0x7b
  jmp __alltraps
  102140:	e9 90 fb ff ff       	jmp    101cd5 <__alltraps>

00102145 <vector124>:
.globl vector124
vector124:
  pushl $0
  102145:	6a 00                	push   $0x0
  pushl $124
  102147:	6a 7c                	push   $0x7c
  jmp __alltraps
  102149:	e9 87 fb ff ff       	jmp    101cd5 <__alltraps>

0010214e <vector125>:
.globl vector125
vector125:
  pushl $0
  10214e:	6a 00                	push   $0x0
  pushl $125
  102150:	6a 7d                	push   $0x7d
  jmp __alltraps
  102152:	e9 7e fb ff ff       	jmp    101cd5 <__alltraps>

00102157 <vector126>:
.globl vector126
vector126:
  pushl $0
  102157:	6a 00                	push   $0x0
  pushl $126
  102159:	6a 7e                	push   $0x7e
  jmp __alltraps
  10215b:	e9 75 fb ff ff       	jmp    101cd5 <__alltraps>

00102160 <vector127>:
.globl vector127
vector127:
  pushl $0
  102160:	6a 00                	push   $0x0
  pushl $127
  102162:	6a 7f                	push   $0x7f
  jmp __alltraps
  102164:	e9 6c fb ff ff       	jmp    101cd5 <__alltraps>

00102169 <vector128>:
.globl vector128
vector128:
  pushl $0
  102169:	6a 00                	push   $0x0
  pushl $128
  10216b:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102170:	e9 60 fb ff ff       	jmp    101cd5 <__alltraps>

00102175 <vector129>:
.globl vector129
vector129:
  pushl $0
  102175:	6a 00                	push   $0x0
  pushl $129
  102177:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  10217c:	e9 54 fb ff ff       	jmp    101cd5 <__alltraps>

00102181 <vector130>:
.globl vector130
vector130:
  pushl $0
  102181:	6a 00                	push   $0x0
  pushl $130
  102183:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102188:	e9 48 fb ff ff       	jmp    101cd5 <__alltraps>

0010218d <vector131>:
.globl vector131
vector131:
  pushl $0
  10218d:	6a 00                	push   $0x0
  pushl $131
  10218f:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102194:	e9 3c fb ff ff       	jmp    101cd5 <__alltraps>

00102199 <vector132>:
.globl vector132
vector132:
  pushl $0
  102199:	6a 00                	push   $0x0
  pushl $132
  10219b:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1021a0:	e9 30 fb ff ff       	jmp    101cd5 <__alltraps>

001021a5 <vector133>:
.globl vector133
vector133:
  pushl $0
  1021a5:	6a 00                	push   $0x0
  pushl $133
  1021a7:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1021ac:	e9 24 fb ff ff       	jmp    101cd5 <__alltraps>

001021b1 <vector134>:
.globl vector134
vector134:
  pushl $0
  1021b1:	6a 00                	push   $0x0
  pushl $134
  1021b3:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1021b8:	e9 18 fb ff ff       	jmp    101cd5 <__alltraps>

001021bd <vector135>:
.globl vector135
vector135:
  pushl $0
  1021bd:	6a 00                	push   $0x0
  pushl $135
  1021bf:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1021c4:	e9 0c fb ff ff       	jmp    101cd5 <__alltraps>

001021c9 <vector136>:
.globl vector136
vector136:
  pushl $0
  1021c9:	6a 00                	push   $0x0
  pushl $136
  1021cb:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1021d0:	e9 00 fb ff ff       	jmp    101cd5 <__alltraps>

001021d5 <vector137>:
.globl vector137
vector137:
  pushl $0
  1021d5:	6a 00                	push   $0x0
  pushl $137
  1021d7:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1021dc:	e9 f4 fa ff ff       	jmp    101cd5 <__alltraps>

001021e1 <vector138>:
.globl vector138
vector138:
  pushl $0
  1021e1:	6a 00                	push   $0x0
  pushl $138
  1021e3:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1021e8:	e9 e8 fa ff ff       	jmp    101cd5 <__alltraps>

001021ed <vector139>:
.globl vector139
vector139:
  pushl $0
  1021ed:	6a 00                	push   $0x0
  pushl $139
  1021ef:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1021f4:	e9 dc fa ff ff       	jmp    101cd5 <__alltraps>

001021f9 <vector140>:
.globl vector140
vector140:
  pushl $0
  1021f9:	6a 00                	push   $0x0
  pushl $140
  1021fb:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102200:	e9 d0 fa ff ff       	jmp    101cd5 <__alltraps>

00102205 <vector141>:
.globl vector141
vector141:
  pushl $0
  102205:	6a 00                	push   $0x0
  pushl $141
  102207:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10220c:	e9 c4 fa ff ff       	jmp    101cd5 <__alltraps>

00102211 <vector142>:
.globl vector142
vector142:
  pushl $0
  102211:	6a 00                	push   $0x0
  pushl $142
  102213:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102218:	e9 b8 fa ff ff       	jmp    101cd5 <__alltraps>

0010221d <vector143>:
.globl vector143
vector143:
  pushl $0
  10221d:	6a 00                	push   $0x0
  pushl $143
  10221f:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102224:	e9 ac fa ff ff       	jmp    101cd5 <__alltraps>

00102229 <vector144>:
.globl vector144
vector144:
  pushl $0
  102229:	6a 00                	push   $0x0
  pushl $144
  10222b:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102230:	e9 a0 fa ff ff       	jmp    101cd5 <__alltraps>

00102235 <vector145>:
.globl vector145
vector145:
  pushl $0
  102235:	6a 00                	push   $0x0
  pushl $145
  102237:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10223c:	e9 94 fa ff ff       	jmp    101cd5 <__alltraps>

00102241 <vector146>:
.globl vector146
vector146:
  pushl $0
  102241:	6a 00                	push   $0x0
  pushl $146
  102243:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102248:	e9 88 fa ff ff       	jmp    101cd5 <__alltraps>

0010224d <vector147>:
.globl vector147
vector147:
  pushl $0
  10224d:	6a 00                	push   $0x0
  pushl $147
  10224f:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102254:	e9 7c fa ff ff       	jmp    101cd5 <__alltraps>

00102259 <vector148>:
.globl vector148
vector148:
  pushl $0
  102259:	6a 00                	push   $0x0
  pushl $148
  10225b:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102260:	e9 70 fa ff ff       	jmp    101cd5 <__alltraps>

00102265 <vector149>:
.globl vector149
vector149:
  pushl $0
  102265:	6a 00                	push   $0x0
  pushl $149
  102267:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  10226c:	e9 64 fa ff ff       	jmp    101cd5 <__alltraps>

00102271 <vector150>:
.globl vector150
vector150:
  pushl $0
  102271:	6a 00                	push   $0x0
  pushl $150
  102273:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102278:	e9 58 fa ff ff       	jmp    101cd5 <__alltraps>

0010227d <vector151>:
.globl vector151
vector151:
  pushl $0
  10227d:	6a 00                	push   $0x0
  pushl $151
  10227f:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102284:	e9 4c fa ff ff       	jmp    101cd5 <__alltraps>

00102289 <vector152>:
.globl vector152
vector152:
  pushl $0
  102289:	6a 00                	push   $0x0
  pushl $152
  10228b:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102290:	e9 40 fa ff ff       	jmp    101cd5 <__alltraps>

00102295 <vector153>:
.globl vector153
vector153:
  pushl $0
  102295:	6a 00                	push   $0x0
  pushl $153
  102297:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  10229c:	e9 34 fa ff ff       	jmp    101cd5 <__alltraps>

001022a1 <vector154>:
.globl vector154
vector154:
  pushl $0
  1022a1:	6a 00                	push   $0x0
  pushl $154
  1022a3:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1022a8:	e9 28 fa ff ff       	jmp    101cd5 <__alltraps>

001022ad <vector155>:
.globl vector155
vector155:
  pushl $0
  1022ad:	6a 00                	push   $0x0
  pushl $155
  1022af:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1022b4:	e9 1c fa ff ff       	jmp    101cd5 <__alltraps>

001022b9 <vector156>:
.globl vector156
vector156:
  pushl $0
  1022b9:	6a 00                	push   $0x0
  pushl $156
  1022bb:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1022c0:	e9 10 fa ff ff       	jmp    101cd5 <__alltraps>

001022c5 <vector157>:
.globl vector157
vector157:
  pushl $0
  1022c5:	6a 00                	push   $0x0
  pushl $157
  1022c7:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1022cc:	e9 04 fa ff ff       	jmp    101cd5 <__alltraps>

001022d1 <vector158>:
.globl vector158
vector158:
  pushl $0
  1022d1:	6a 00                	push   $0x0
  pushl $158
  1022d3:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1022d8:	e9 f8 f9 ff ff       	jmp    101cd5 <__alltraps>

001022dd <vector159>:
.globl vector159
vector159:
  pushl $0
  1022dd:	6a 00                	push   $0x0
  pushl $159
  1022df:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1022e4:	e9 ec f9 ff ff       	jmp    101cd5 <__alltraps>

001022e9 <vector160>:
.globl vector160
vector160:
  pushl $0
  1022e9:	6a 00                	push   $0x0
  pushl $160
  1022eb:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1022f0:	e9 e0 f9 ff ff       	jmp    101cd5 <__alltraps>

001022f5 <vector161>:
.globl vector161
vector161:
  pushl $0
  1022f5:	6a 00                	push   $0x0
  pushl $161
  1022f7:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1022fc:	e9 d4 f9 ff ff       	jmp    101cd5 <__alltraps>

00102301 <vector162>:
.globl vector162
vector162:
  pushl $0
  102301:	6a 00                	push   $0x0
  pushl $162
  102303:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102308:	e9 c8 f9 ff ff       	jmp    101cd5 <__alltraps>

0010230d <vector163>:
.globl vector163
vector163:
  pushl $0
  10230d:	6a 00                	push   $0x0
  pushl $163
  10230f:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102314:	e9 bc f9 ff ff       	jmp    101cd5 <__alltraps>

00102319 <vector164>:
.globl vector164
vector164:
  pushl $0
  102319:	6a 00                	push   $0x0
  pushl $164
  10231b:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102320:	e9 b0 f9 ff ff       	jmp    101cd5 <__alltraps>

00102325 <vector165>:
.globl vector165
vector165:
  pushl $0
  102325:	6a 00                	push   $0x0
  pushl $165
  102327:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10232c:	e9 a4 f9 ff ff       	jmp    101cd5 <__alltraps>

00102331 <vector166>:
.globl vector166
vector166:
  pushl $0
  102331:	6a 00                	push   $0x0
  pushl $166
  102333:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102338:	e9 98 f9 ff ff       	jmp    101cd5 <__alltraps>

0010233d <vector167>:
.globl vector167
vector167:
  pushl $0
  10233d:	6a 00                	push   $0x0
  pushl $167
  10233f:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102344:	e9 8c f9 ff ff       	jmp    101cd5 <__alltraps>

00102349 <vector168>:
.globl vector168
vector168:
  pushl $0
  102349:	6a 00                	push   $0x0
  pushl $168
  10234b:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102350:	e9 80 f9 ff ff       	jmp    101cd5 <__alltraps>

00102355 <vector169>:
.globl vector169
vector169:
  pushl $0
  102355:	6a 00                	push   $0x0
  pushl $169
  102357:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  10235c:	e9 74 f9 ff ff       	jmp    101cd5 <__alltraps>

00102361 <vector170>:
.globl vector170
vector170:
  pushl $0
  102361:	6a 00                	push   $0x0
  pushl $170
  102363:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102368:	e9 68 f9 ff ff       	jmp    101cd5 <__alltraps>

0010236d <vector171>:
.globl vector171
vector171:
  pushl $0
  10236d:	6a 00                	push   $0x0
  pushl $171
  10236f:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102374:	e9 5c f9 ff ff       	jmp    101cd5 <__alltraps>

00102379 <vector172>:
.globl vector172
vector172:
  pushl $0
  102379:	6a 00                	push   $0x0
  pushl $172
  10237b:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102380:	e9 50 f9 ff ff       	jmp    101cd5 <__alltraps>

00102385 <vector173>:
.globl vector173
vector173:
  pushl $0
  102385:	6a 00                	push   $0x0
  pushl $173
  102387:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  10238c:	e9 44 f9 ff ff       	jmp    101cd5 <__alltraps>

00102391 <vector174>:
.globl vector174
vector174:
  pushl $0
  102391:	6a 00                	push   $0x0
  pushl $174
  102393:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102398:	e9 38 f9 ff ff       	jmp    101cd5 <__alltraps>

0010239d <vector175>:
.globl vector175
vector175:
  pushl $0
  10239d:	6a 00                	push   $0x0
  pushl $175
  10239f:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1023a4:	e9 2c f9 ff ff       	jmp    101cd5 <__alltraps>

001023a9 <vector176>:
.globl vector176
vector176:
  pushl $0
  1023a9:	6a 00                	push   $0x0
  pushl $176
  1023ab:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1023b0:	e9 20 f9 ff ff       	jmp    101cd5 <__alltraps>

001023b5 <vector177>:
.globl vector177
vector177:
  pushl $0
  1023b5:	6a 00                	push   $0x0
  pushl $177
  1023b7:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1023bc:	e9 14 f9 ff ff       	jmp    101cd5 <__alltraps>

001023c1 <vector178>:
.globl vector178
vector178:
  pushl $0
  1023c1:	6a 00                	push   $0x0
  pushl $178
  1023c3:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1023c8:	e9 08 f9 ff ff       	jmp    101cd5 <__alltraps>

001023cd <vector179>:
.globl vector179
vector179:
  pushl $0
  1023cd:	6a 00                	push   $0x0
  pushl $179
  1023cf:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1023d4:	e9 fc f8 ff ff       	jmp    101cd5 <__alltraps>

001023d9 <vector180>:
.globl vector180
vector180:
  pushl $0
  1023d9:	6a 00                	push   $0x0
  pushl $180
  1023db:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1023e0:	e9 f0 f8 ff ff       	jmp    101cd5 <__alltraps>

001023e5 <vector181>:
.globl vector181
vector181:
  pushl $0
  1023e5:	6a 00                	push   $0x0
  pushl $181
  1023e7:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1023ec:	e9 e4 f8 ff ff       	jmp    101cd5 <__alltraps>

001023f1 <vector182>:
.globl vector182
vector182:
  pushl $0
  1023f1:	6a 00                	push   $0x0
  pushl $182
  1023f3:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1023f8:	e9 d8 f8 ff ff       	jmp    101cd5 <__alltraps>

001023fd <vector183>:
.globl vector183
vector183:
  pushl $0
  1023fd:	6a 00                	push   $0x0
  pushl $183
  1023ff:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102404:	e9 cc f8 ff ff       	jmp    101cd5 <__alltraps>

00102409 <vector184>:
.globl vector184
vector184:
  pushl $0
  102409:	6a 00                	push   $0x0
  pushl $184
  10240b:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102410:	e9 c0 f8 ff ff       	jmp    101cd5 <__alltraps>

00102415 <vector185>:
.globl vector185
vector185:
  pushl $0
  102415:	6a 00                	push   $0x0
  pushl $185
  102417:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10241c:	e9 b4 f8 ff ff       	jmp    101cd5 <__alltraps>

00102421 <vector186>:
.globl vector186
vector186:
  pushl $0
  102421:	6a 00                	push   $0x0
  pushl $186
  102423:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102428:	e9 a8 f8 ff ff       	jmp    101cd5 <__alltraps>

0010242d <vector187>:
.globl vector187
vector187:
  pushl $0
  10242d:	6a 00                	push   $0x0
  pushl $187
  10242f:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102434:	e9 9c f8 ff ff       	jmp    101cd5 <__alltraps>

00102439 <vector188>:
.globl vector188
vector188:
  pushl $0
  102439:	6a 00                	push   $0x0
  pushl $188
  10243b:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102440:	e9 90 f8 ff ff       	jmp    101cd5 <__alltraps>

00102445 <vector189>:
.globl vector189
vector189:
  pushl $0
  102445:	6a 00                	push   $0x0
  pushl $189
  102447:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  10244c:	e9 84 f8 ff ff       	jmp    101cd5 <__alltraps>

00102451 <vector190>:
.globl vector190
vector190:
  pushl $0
  102451:	6a 00                	push   $0x0
  pushl $190
  102453:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102458:	e9 78 f8 ff ff       	jmp    101cd5 <__alltraps>

0010245d <vector191>:
.globl vector191
vector191:
  pushl $0
  10245d:	6a 00                	push   $0x0
  pushl $191
  10245f:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102464:	e9 6c f8 ff ff       	jmp    101cd5 <__alltraps>

00102469 <vector192>:
.globl vector192
vector192:
  pushl $0
  102469:	6a 00                	push   $0x0
  pushl $192
  10246b:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102470:	e9 60 f8 ff ff       	jmp    101cd5 <__alltraps>

00102475 <vector193>:
.globl vector193
vector193:
  pushl $0
  102475:	6a 00                	push   $0x0
  pushl $193
  102477:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  10247c:	e9 54 f8 ff ff       	jmp    101cd5 <__alltraps>

00102481 <vector194>:
.globl vector194
vector194:
  pushl $0
  102481:	6a 00                	push   $0x0
  pushl $194
  102483:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102488:	e9 48 f8 ff ff       	jmp    101cd5 <__alltraps>

0010248d <vector195>:
.globl vector195
vector195:
  pushl $0
  10248d:	6a 00                	push   $0x0
  pushl $195
  10248f:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102494:	e9 3c f8 ff ff       	jmp    101cd5 <__alltraps>

00102499 <vector196>:
.globl vector196
vector196:
  pushl $0
  102499:	6a 00                	push   $0x0
  pushl $196
  10249b:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1024a0:	e9 30 f8 ff ff       	jmp    101cd5 <__alltraps>

001024a5 <vector197>:
.globl vector197
vector197:
  pushl $0
  1024a5:	6a 00                	push   $0x0
  pushl $197
  1024a7:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1024ac:	e9 24 f8 ff ff       	jmp    101cd5 <__alltraps>

001024b1 <vector198>:
.globl vector198
vector198:
  pushl $0
  1024b1:	6a 00                	push   $0x0
  pushl $198
  1024b3:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1024b8:	e9 18 f8 ff ff       	jmp    101cd5 <__alltraps>

001024bd <vector199>:
.globl vector199
vector199:
  pushl $0
  1024bd:	6a 00                	push   $0x0
  pushl $199
  1024bf:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1024c4:	e9 0c f8 ff ff       	jmp    101cd5 <__alltraps>

001024c9 <vector200>:
.globl vector200
vector200:
  pushl $0
  1024c9:	6a 00                	push   $0x0
  pushl $200
  1024cb:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1024d0:	e9 00 f8 ff ff       	jmp    101cd5 <__alltraps>

001024d5 <vector201>:
.globl vector201
vector201:
  pushl $0
  1024d5:	6a 00                	push   $0x0
  pushl $201
  1024d7:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1024dc:	e9 f4 f7 ff ff       	jmp    101cd5 <__alltraps>

001024e1 <vector202>:
.globl vector202
vector202:
  pushl $0
  1024e1:	6a 00                	push   $0x0
  pushl $202
  1024e3:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1024e8:	e9 e8 f7 ff ff       	jmp    101cd5 <__alltraps>

001024ed <vector203>:
.globl vector203
vector203:
  pushl $0
  1024ed:	6a 00                	push   $0x0
  pushl $203
  1024ef:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1024f4:	e9 dc f7 ff ff       	jmp    101cd5 <__alltraps>

001024f9 <vector204>:
.globl vector204
vector204:
  pushl $0
  1024f9:	6a 00                	push   $0x0
  pushl $204
  1024fb:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102500:	e9 d0 f7 ff ff       	jmp    101cd5 <__alltraps>

00102505 <vector205>:
.globl vector205
vector205:
  pushl $0
  102505:	6a 00                	push   $0x0
  pushl $205
  102507:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10250c:	e9 c4 f7 ff ff       	jmp    101cd5 <__alltraps>

00102511 <vector206>:
.globl vector206
vector206:
  pushl $0
  102511:	6a 00                	push   $0x0
  pushl $206
  102513:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102518:	e9 b8 f7 ff ff       	jmp    101cd5 <__alltraps>

0010251d <vector207>:
.globl vector207
vector207:
  pushl $0
  10251d:	6a 00                	push   $0x0
  pushl $207
  10251f:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102524:	e9 ac f7 ff ff       	jmp    101cd5 <__alltraps>

00102529 <vector208>:
.globl vector208
vector208:
  pushl $0
  102529:	6a 00                	push   $0x0
  pushl $208
  10252b:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102530:	e9 a0 f7 ff ff       	jmp    101cd5 <__alltraps>

00102535 <vector209>:
.globl vector209
vector209:
  pushl $0
  102535:	6a 00                	push   $0x0
  pushl $209
  102537:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  10253c:	e9 94 f7 ff ff       	jmp    101cd5 <__alltraps>

00102541 <vector210>:
.globl vector210
vector210:
  pushl $0
  102541:	6a 00                	push   $0x0
  pushl $210
  102543:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102548:	e9 88 f7 ff ff       	jmp    101cd5 <__alltraps>

0010254d <vector211>:
.globl vector211
vector211:
  pushl $0
  10254d:	6a 00                	push   $0x0
  pushl $211
  10254f:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102554:	e9 7c f7 ff ff       	jmp    101cd5 <__alltraps>

00102559 <vector212>:
.globl vector212
vector212:
  pushl $0
  102559:	6a 00                	push   $0x0
  pushl $212
  10255b:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102560:	e9 70 f7 ff ff       	jmp    101cd5 <__alltraps>

00102565 <vector213>:
.globl vector213
vector213:
  pushl $0
  102565:	6a 00                	push   $0x0
  pushl $213
  102567:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  10256c:	e9 64 f7 ff ff       	jmp    101cd5 <__alltraps>

00102571 <vector214>:
.globl vector214
vector214:
  pushl $0
  102571:	6a 00                	push   $0x0
  pushl $214
  102573:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102578:	e9 58 f7 ff ff       	jmp    101cd5 <__alltraps>

0010257d <vector215>:
.globl vector215
vector215:
  pushl $0
  10257d:	6a 00                	push   $0x0
  pushl $215
  10257f:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102584:	e9 4c f7 ff ff       	jmp    101cd5 <__alltraps>

00102589 <vector216>:
.globl vector216
vector216:
  pushl $0
  102589:	6a 00                	push   $0x0
  pushl $216
  10258b:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102590:	e9 40 f7 ff ff       	jmp    101cd5 <__alltraps>

00102595 <vector217>:
.globl vector217
vector217:
  pushl $0
  102595:	6a 00                	push   $0x0
  pushl $217
  102597:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  10259c:	e9 34 f7 ff ff       	jmp    101cd5 <__alltraps>

001025a1 <vector218>:
.globl vector218
vector218:
  pushl $0
  1025a1:	6a 00                	push   $0x0
  pushl $218
  1025a3:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1025a8:	e9 28 f7 ff ff       	jmp    101cd5 <__alltraps>

001025ad <vector219>:
.globl vector219
vector219:
  pushl $0
  1025ad:	6a 00                	push   $0x0
  pushl $219
  1025af:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1025b4:	e9 1c f7 ff ff       	jmp    101cd5 <__alltraps>

001025b9 <vector220>:
.globl vector220
vector220:
  pushl $0
  1025b9:	6a 00                	push   $0x0
  pushl $220
  1025bb:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1025c0:	e9 10 f7 ff ff       	jmp    101cd5 <__alltraps>

001025c5 <vector221>:
.globl vector221
vector221:
  pushl $0
  1025c5:	6a 00                	push   $0x0
  pushl $221
  1025c7:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1025cc:	e9 04 f7 ff ff       	jmp    101cd5 <__alltraps>

001025d1 <vector222>:
.globl vector222
vector222:
  pushl $0
  1025d1:	6a 00                	push   $0x0
  pushl $222
  1025d3:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1025d8:	e9 f8 f6 ff ff       	jmp    101cd5 <__alltraps>

001025dd <vector223>:
.globl vector223
vector223:
  pushl $0
  1025dd:	6a 00                	push   $0x0
  pushl $223
  1025df:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1025e4:	e9 ec f6 ff ff       	jmp    101cd5 <__alltraps>

001025e9 <vector224>:
.globl vector224
vector224:
  pushl $0
  1025e9:	6a 00                	push   $0x0
  pushl $224
  1025eb:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1025f0:	e9 e0 f6 ff ff       	jmp    101cd5 <__alltraps>

001025f5 <vector225>:
.globl vector225
vector225:
  pushl $0
  1025f5:	6a 00                	push   $0x0
  pushl $225
  1025f7:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1025fc:	e9 d4 f6 ff ff       	jmp    101cd5 <__alltraps>

00102601 <vector226>:
.globl vector226
vector226:
  pushl $0
  102601:	6a 00                	push   $0x0
  pushl $226
  102603:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102608:	e9 c8 f6 ff ff       	jmp    101cd5 <__alltraps>

0010260d <vector227>:
.globl vector227
vector227:
  pushl $0
  10260d:	6a 00                	push   $0x0
  pushl $227
  10260f:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102614:	e9 bc f6 ff ff       	jmp    101cd5 <__alltraps>

00102619 <vector228>:
.globl vector228
vector228:
  pushl $0
  102619:	6a 00                	push   $0x0
  pushl $228
  10261b:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102620:	e9 b0 f6 ff ff       	jmp    101cd5 <__alltraps>

00102625 <vector229>:
.globl vector229
vector229:
  pushl $0
  102625:	6a 00                	push   $0x0
  pushl $229
  102627:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  10262c:	e9 a4 f6 ff ff       	jmp    101cd5 <__alltraps>

00102631 <vector230>:
.globl vector230
vector230:
  pushl $0
  102631:	6a 00                	push   $0x0
  pushl $230
  102633:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102638:	e9 98 f6 ff ff       	jmp    101cd5 <__alltraps>

0010263d <vector231>:
.globl vector231
vector231:
  pushl $0
  10263d:	6a 00                	push   $0x0
  pushl $231
  10263f:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102644:	e9 8c f6 ff ff       	jmp    101cd5 <__alltraps>

00102649 <vector232>:
.globl vector232
vector232:
  pushl $0
  102649:	6a 00                	push   $0x0
  pushl $232
  10264b:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102650:	e9 80 f6 ff ff       	jmp    101cd5 <__alltraps>

00102655 <vector233>:
.globl vector233
vector233:
  pushl $0
  102655:	6a 00                	push   $0x0
  pushl $233
  102657:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  10265c:	e9 74 f6 ff ff       	jmp    101cd5 <__alltraps>

00102661 <vector234>:
.globl vector234
vector234:
  pushl $0
  102661:	6a 00                	push   $0x0
  pushl $234
  102663:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102668:	e9 68 f6 ff ff       	jmp    101cd5 <__alltraps>

0010266d <vector235>:
.globl vector235
vector235:
  pushl $0
  10266d:	6a 00                	push   $0x0
  pushl $235
  10266f:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102674:	e9 5c f6 ff ff       	jmp    101cd5 <__alltraps>

00102679 <vector236>:
.globl vector236
vector236:
  pushl $0
  102679:	6a 00                	push   $0x0
  pushl $236
  10267b:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102680:	e9 50 f6 ff ff       	jmp    101cd5 <__alltraps>

00102685 <vector237>:
.globl vector237
vector237:
  pushl $0
  102685:	6a 00                	push   $0x0
  pushl $237
  102687:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  10268c:	e9 44 f6 ff ff       	jmp    101cd5 <__alltraps>

00102691 <vector238>:
.globl vector238
vector238:
  pushl $0
  102691:	6a 00                	push   $0x0
  pushl $238
  102693:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102698:	e9 38 f6 ff ff       	jmp    101cd5 <__alltraps>

0010269d <vector239>:
.globl vector239
vector239:
  pushl $0
  10269d:	6a 00                	push   $0x0
  pushl $239
  10269f:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1026a4:	e9 2c f6 ff ff       	jmp    101cd5 <__alltraps>

001026a9 <vector240>:
.globl vector240
vector240:
  pushl $0
  1026a9:	6a 00                	push   $0x0
  pushl $240
  1026ab:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1026b0:	e9 20 f6 ff ff       	jmp    101cd5 <__alltraps>

001026b5 <vector241>:
.globl vector241
vector241:
  pushl $0
  1026b5:	6a 00                	push   $0x0
  pushl $241
  1026b7:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1026bc:	e9 14 f6 ff ff       	jmp    101cd5 <__alltraps>

001026c1 <vector242>:
.globl vector242
vector242:
  pushl $0
  1026c1:	6a 00                	push   $0x0
  pushl $242
  1026c3:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1026c8:	e9 08 f6 ff ff       	jmp    101cd5 <__alltraps>

001026cd <vector243>:
.globl vector243
vector243:
  pushl $0
  1026cd:	6a 00                	push   $0x0
  pushl $243
  1026cf:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1026d4:	e9 fc f5 ff ff       	jmp    101cd5 <__alltraps>

001026d9 <vector244>:
.globl vector244
vector244:
  pushl $0
  1026d9:	6a 00                	push   $0x0
  pushl $244
  1026db:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1026e0:	e9 f0 f5 ff ff       	jmp    101cd5 <__alltraps>

001026e5 <vector245>:
.globl vector245
vector245:
  pushl $0
  1026e5:	6a 00                	push   $0x0
  pushl $245
  1026e7:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1026ec:	e9 e4 f5 ff ff       	jmp    101cd5 <__alltraps>

001026f1 <vector246>:
.globl vector246
vector246:
  pushl $0
  1026f1:	6a 00                	push   $0x0
  pushl $246
  1026f3:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1026f8:	e9 d8 f5 ff ff       	jmp    101cd5 <__alltraps>

001026fd <vector247>:
.globl vector247
vector247:
  pushl $0
  1026fd:	6a 00                	push   $0x0
  pushl $247
  1026ff:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102704:	e9 cc f5 ff ff       	jmp    101cd5 <__alltraps>

00102709 <vector248>:
.globl vector248
vector248:
  pushl $0
  102709:	6a 00                	push   $0x0
  pushl $248
  10270b:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102710:	e9 c0 f5 ff ff       	jmp    101cd5 <__alltraps>

00102715 <vector249>:
.globl vector249
vector249:
  pushl $0
  102715:	6a 00                	push   $0x0
  pushl $249
  102717:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  10271c:	e9 b4 f5 ff ff       	jmp    101cd5 <__alltraps>

00102721 <vector250>:
.globl vector250
vector250:
  pushl $0
  102721:	6a 00                	push   $0x0
  pushl $250
  102723:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102728:	e9 a8 f5 ff ff       	jmp    101cd5 <__alltraps>

0010272d <vector251>:
.globl vector251
vector251:
  pushl $0
  10272d:	6a 00                	push   $0x0
  pushl $251
  10272f:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102734:	e9 9c f5 ff ff       	jmp    101cd5 <__alltraps>

00102739 <vector252>:
.globl vector252
vector252:
  pushl $0
  102739:	6a 00                	push   $0x0
  pushl $252
  10273b:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102740:	e9 90 f5 ff ff       	jmp    101cd5 <__alltraps>

00102745 <vector253>:
.globl vector253
vector253:
  pushl $0
  102745:	6a 00                	push   $0x0
  pushl $253
  102747:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  10274c:	e9 84 f5 ff ff       	jmp    101cd5 <__alltraps>

00102751 <vector254>:
.globl vector254
vector254:
  pushl $0
  102751:	6a 00                	push   $0x0
  pushl $254
  102753:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102758:	e9 78 f5 ff ff       	jmp    101cd5 <__alltraps>

0010275d <vector255>:
.globl vector255
vector255:
  pushl $0
  10275d:	6a 00                	push   $0x0
  pushl $255
  10275f:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102764:	e9 6c f5 ff ff       	jmp    101cd5 <__alltraps>

00102769 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102769:	55                   	push   %ebp
  10276a:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  10276c:	8b 45 08             	mov    0x8(%ebp),%eax
  10276f:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102772:	b8 23 00 00 00       	mov    $0x23,%eax
  102777:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102779:	b8 23 00 00 00       	mov    $0x23,%eax
  10277e:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102780:	b8 10 00 00 00       	mov    $0x10,%eax
  102785:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102787:	b8 10 00 00 00       	mov    $0x10,%eax
  10278c:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  10278e:	b8 10 00 00 00       	mov    $0x10,%eax
  102793:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102795:	ea 9c 27 10 00 08 00 	ljmp   $0x8,$0x10279c
}
  10279c:	90                   	nop
  10279d:	5d                   	pop    %ebp
  10279e:	c3                   	ret    

0010279f <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  10279f:	55                   	push   %ebp
  1027a0:	89 e5                	mov    %esp,%ebp
  1027a2:	83 ec 10             	sub    $0x10,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  1027a5:	b8 20 09 11 00       	mov    $0x110920,%eax
  1027aa:	05 00 04 00 00       	add    $0x400,%eax
  1027af:	a3 a4 08 11 00       	mov    %eax,0x1108a4
    ts.ts_ss0 = KERNEL_DS;
  1027b4:	66 c7 05 a8 08 11 00 	movw   $0x10,0x1108a8
  1027bb:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  1027bd:	66 c7 05 08 fa 10 00 	movw   $0x68,0x10fa08
  1027c4:	68 00 
  1027c6:	b8 a0 08 11 00       	mov    $0x1108a0,%eax
  1027cb:	66 a3 0a fa 10 00    	mov    %ax,0x10fa0a
  1027d1:	b8 a0 08 11 00       	mov    $0x1108a0,%eax
  1027d6:	c1 e8 10             	shr    $0x10,%eax
  1027d9:	a2 0c fa 10 00       	mov    %al,0x10fa0c
  1027de:	a0 0d fa 10 00       	mov    0x10fa0d,%al
  1027e3:	83 e0 f0             	and    $0xfffffff0,%eax
  1027e6:	83 c8 09             	or     $0x9,%eax
  1027e9:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  1027ee:	a0 0d fa 10 00       	mov    0x10fa0d,%al
  1027f3:	83 c8 10             	or     $0x10,%eax
  1027f6:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  1027fb:	a0 0d fa 10 00       	mov    0x10fa0d,%al
  102800:	83 e0 9f             	and    $0xffffff9f,%eax
  102803:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102808:	a0 0d fa 10 00       	mov    0x10fa0d,%al
  10280d:	83 c8 80             	or     $0xffffff80,%eax
  102810:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102815:	a0 0e fa 10 00       	mov    0x10fa0e,%al
  10281a:	83 e0 f0             	and    $0xfffffff0,%eax
  10281d:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102822:	a0 0e fa 10 00       	mov    0x10fa0e,%al
  102827:	83 e0 ef             	and    $0xffffffef,%eax
  10282a:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  10282f:	a0 0e fa 10 00       	mov    0x10fa0e,%al
  102834:	83 e0 df             	and    $0xffffffdf,%eax
  102837:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  10283c:	a0 0e fa 10 00       	mov    0x10fa0e,%al
  102841:	83 c8 40             	or     $0x40,%eax
  102844:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102849:	a0 0e fa 10 00       	mov    0x10fa0e,%al
  10284e:	83 e0 7f             	and    $0x7f,%eax
  102851:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102856:	b8 a0 08 11 00       	mov    $0x1108a0,%eax
  10285b:	c1 e8 18             	shr    $0x18,%eax
  10285e:	a2 0f fa 10 00       	mov    %al,0x10fa0f
    gdt[SEG_TSS].sd_s = 0;
  102863:	a0 0d fa 10 00       	mov    0x10fa0d,%al
  102868:	83 e0 ef             	and    $0xffffffef,%eax
  10286b:	a2 0d fa 10 00       	mov    %al,0x10fa0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102870:	68 10 fa 10 00       	push   $0x10fa10
  102875:	e8 ef fe ff ff       	call   102769 <lgdt>
  10287a:	83 c4 04             	add    $0x4,%esp
  10287d:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102883:	66 8b 45 fe          	mov    -0x2(%ebp),%ax
  102887:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  10288a:	90                   	nop
  10288b:	c9                   	leave  
  10288c:	c3                   	ret    

0010288d <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  10288d:	55                   	push   %ebp
  10288e:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102890:	e8 0a ff ff ff       	call   10279f <gdt_init>
}
  102895:	90                   	nop
  102896:	5d                   	pop    %ebp
  102897:	c3                   	ret    

00102898 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102898:	55                   	push   %ebp
  102899:	89 e5                	mov    %esp,%ebp
  10289b:	83 ec 38             	sub    $0x38,%esp
  10289e:	8b 45 10             	mov    0x10(%ebp),%eax
  1028a1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1028a4:	8b 45 14             	mov    0x14(%ebp),%eax
  1028a7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1028aa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1028ad:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1028b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1028b3:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1028b6:	8b 45 18             	mov    0x18(%ebp),%eax
  1028b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1028bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1028bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1028c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1028c5:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1028c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1028cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1028ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1028d2:	74 1c                	je     1028f0 <printnum+0x58>
  1028d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1028d7:	ba 00 00 00 00       	mov    $0x0,%edx
  1028dc:	f7 75 e4             	divl   -0x1c(%ebp)
  1028df:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1028e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1028e5:	ba 00 00 00 00       	mov    $0x0,%edx
  1028ea:	f7 75 e4             	divl   -0x1c(%ebp)
  1028ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1028f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1028f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1028f6:	f7 75 e4             	divl   -0x1c(%ebp)
  1028f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1028fc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1028ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102902:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102905:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102908:	89 55 ec             	mov    %edx,-0x14(%ebp)
  10290b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10290e:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102911:	8b 45 18             	mov    0x18(%ebp),%eax
  102914:	ba 00 00 00 00       	mov    $0x0,%edx
  102919:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  10291c:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  10291f:	19 d1                	sbb    %edx,%ecx
  102921:	72 35                	jb     102958 <printnum+0xc0>
        printnum(putch, putdat, result, base, width - 1, padc);
  102923:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102926:	48                   	dec    %eax
  102927:	83 ec 04             	sub    $0x4,%esp
  10292a:	ff 75 20             	pushl  0x20(%ebp)
  10292d:	50                   	push   %eax
  10292e:	ff 75 18             	pushl  0x18(%ebp)
  102931:	ff 75 ec             	pushl  -0x14(%ebp)
  102934:	ff 75 e8             	pushl  -0x18(%ebp)
  102937:	ff 75 0c             	pushl  0xc(%ebp)
  10293a:	ff 75 08             	pushl  0x8(%ebp)
  10293d:	e8 56 ff ff ff       	call   102898 <printnum>
  102942:	83 c4 20             	add    $0x20,%esp
  102945:	eb 1a                	jmp    102961 <printnum+0xc9>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102947:	83 ec 08             	sub    $0x8,%esp
  10294a:	ff 75 0c             	pushl  0xc(%ebp)
  10294d:	ff 75 20             	pushl  0x20(%ebp)
  102950:	8b 45 08             	mov    0x8(%ebp),%eax
  102953:	ff d0                	call   *%eax
  102955:	83 c4 10             	add    $0x10,%esp
        while (-- width > 0)
  102958:	ff 4d 1c             	decl   0x1c(%ebp)
  10295b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10295f:	7f e6                	jg     102947 <printnum+0xaf>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102961:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102964:	05 b0 3a 10 00       	add    $0x103ab0,%eax
  102969:	8a 00                	mov    (%eax),%al
  10296b:	0f be c0             	movsbl %al,%eax
  10296e:	83 ec 08             	sub    $0x8,%esp
  102971:	ff 75 0c             	pushl  0xc(%ebp)
  102974:	50                   	push   %eax
  102975:	8b 45 08             	mov    0x8(%ebp),%eax
  102978:	ff d0                	call   *%eax
  10297a:	83 c4 10             	add    $0x10,%esp
}
  10297d:	90                   	nop
  10297e:	c9                   	leave  
  10297f:	c3                   	ret    

00102980 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102980:	55                   	push   %ebp
  102981:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102983:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102987:	7e 14                	jle    10299d <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102989:	8b 45 08             	mov    0x8(%ebp),%eax
  10298c:	8b 00                	mov    (%eax),%eax
  10298e:	8d 48 08             	lea    0x8(%eax),%ecx
  102991:	8b 55 08             	mov    0x8(%ebp),%edx
  102994:	89 0a                	mov    %ecx,(%edx)
  102996:	8b 50 04             	mov    0x4(%eax),%edx
  102999:	8b 00                	mov    (%eax),%eax
  10299b:	eb 30                	jmp    1029cd <getuint+0x4d>
    }
    else if (lflag) {
  10299d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1029a1:	74 16                	je     1029b9 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  1029a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1029a6:	8b 00                	mov    (%eax),%eax
  1029a8:	8d 48 04             	lea    0x4(%eax),%ecx
  1029ab:	8b 55 08             	mov    0x8(%ebp),%edx
  1029ae:	89 0a                	mov    %ecx,(%edx)
  1029b0:	8b 00                	mov    (%eax),%eax
  1029b2:	ba 00 00 00 00       	mov    $0x0,%edx
  1029b7:	eb 14                	jmp    1029cd <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  1029b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1029bc:	8b 00                	mov    (%eax),%eax
  1029be:	8d 48 04             	lea    0x4(%eax),%ecx
  1029c1:	8b 55 08             	mov    0x8(%ebp),%edx
  1029c4:	89 0a                	mov    %ecx,(%edx)
  1029c6:	8b 00                	mov    (%eax),%eax
  1029c8:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1029cd:	5d                   	pop    %ebp
  1029ce:	c3                   	ret    

001029cf <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1029cf:	55                   	push   %ebp
  1029d0:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1029d2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1029d6:	7e 14                	jle    1029ec <getint+0x1d>
        return va_arg(*ap, long long);
  1029d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1029db:	8b 00                	mov    (%eax),%eax
  1029dd:	8d 48 08             	lea    0x8(%eax),%ecx
  1029e0:	8b 55 08             	mov    0x8(%ebp),%edx
  1029e3:	89 0a                	mov    %ecx,(%edx)
  1029e5:	8b 50 04             	mov    0x4(%eax),%edx
  1029e8:	8b 00                	mov    (%eax),%eax
  1029ea:	eb 28                	jmp    102a14 <getint+0x45>
    }
    else if (lflag) {
  1029ec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1029f0:	74 12                	je     102a04 <getint+0x35>
        return va_arg(*ap, long);
  1029f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1029f5:	8b 00                	mov    (%eax),%eax
  1029f7:	8d 48 04             	lea    0x4(%eax),%ecx
  1029fa:	8b 55 08             	mov    0x8(%ebp),%edx
  1029fd:	89 0a                	mov    %ecx,(%edx)
  1029ff:	8b 00                	mov    (%eax),%eax
  102a01:	99                   	cltd   
  102a02:	eb 10                	jmp    102a14 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102a04:	8b 45 08             	mov    0x8(%ebp),%eax
  102a07:	8b 00                	mov    (%eax),%eax
  102a09:	8d 48 04             	lea    0x4(%eax),%ecx
  102a0c:	8b 55 08             	mov    0x8(%ebp),%edx
  102a0f:	89 0a                	mov    %ecx,(%edx)
  102a11:	8b 00                	mov    (%eax),%eax
  102a13:	99                   	cltd   
    }
}
  102a14:	5d                   	pop    %ebp
  102a15:	c3                   	ret    

00102a16 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102a16:	55                   	push   %ebp
  102a17:	89 e5                	mov    %esp,%ebp
  102a19:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  102a1c:	8d 45 14             	lea    0x14(%ebp),%eax
  102a1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a25:	50                   	push   %eax
  102a26:	ff 75 10             	pushl  0x10(%ebp)
  102a29:	ff 75 0c             	pushl  0xc(%ebp)
  102a2c:	ff 75 08             	pushl  0x8(%ebp)
  102a2f:	e8 06 00 00 00       	call   102a3a <vprintfmt>
  102a34:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  102a37:	90                   	nop
  102a38:	c9                   	leave  
  102a39:	c3                   	ret    

00102a3a <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102a3a:	55                   	push   %ebp
  102a3b:	89 e5                	mov    %esp,%ebp
  102a3d:	56                   	push   %esi
  102a3e:	53                   	push   %ebx
  102a3f:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102a42:	eb 17                	jmp    102a5b <vprintfmt+0x21>
            if (ch == '\0') {
  102a44:	85 db                	test   %ebx,%ebx
  102a46:	0f 84 7c 03 00 00    	je     102dc8 <vprintfmt+0x38e>
                return;
            }
            putch(ch, putdat);
  102a4c:	83 ec 08             	sub    $0x8,%esp
  102a4f:	ff 75 0c             	pushl  0xc(%ebp)
  102a52:	53                   	push   %ebx
  102a53:	8b 45 08             	mov    0x8(%ebp),%eax
  102a56:	ff d0                	call   *%eax
  102a58:	83 c4 10             	add    $0x10,%esp
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102a5b:	8b 45 10             	mov    0x10(%ebp),%eax
  102a5e:	8d 50 01             	lea    0x1(%eax),%edx
  102a61:	89 55 10             	mov    %edx,0x10(%ebp)
  102a64:	8a 00                	mov    (%eax),%al
  102a66:	0f b6 d8             	movzbl %al,%ebx
  102a69:	83 fb 25             	cmp    $0x25,%ebx
  102a6c:	75 d6                	jne    102a44 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  102a6e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102a72:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102a79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102a7c:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102a7f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102a86:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102a89:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102a8c:	8b 45 10             	mov    0x10(%ebp),%eax
  102a8f:	8d 50 01             	lea    0x1(%eax),%edx
  102a92:	89 55 10             	mov    %edx,0x10(%ebp)
  102a95:	8a 00                	mov    (%eax),%al
  102a97:	0f b6 d8             	movzbl %al,%ebx
  102a9a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102a9d:	83 f8 55             	cmp    $0x55,%eax
  102aa0:	0f 87 fa 02 00 00    	ja     102da0 <vprintfmt+0x366>
  102aa6:	8b 04 85 d4 3a 10 00 	mov    0x103ad4(,%eax,4),%eax
  102aad:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102aaf:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102ab3:	eb d7                	jmp    102a8c <vprintfmt+0x52>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102ab5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102ab9:	eb d1                	jmp    102a8c <vprintfmt+0x52>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102abb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102ac2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102ac5:	89 d0                	mov    %edx,%eax
  102ac7:	c1 e0 02             	shl    $0x2,%eax
  102aca:	01 d0                	add    %edx,%eax
  102acc:	01 c0                	add    %eax,%eax
  102ace:	01 d8                	add    %ebx,%eax
  102ad0:	83 e8 30             	sub    $0x30,%eax
  102ad3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102ad6:	8b 45 10             	mov    0x10(%ebp),%eax
  102ad9:	8a 00                	mov    (%eax),%al
  102adb:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102ade:	83 fb 2f             	cmp    $0x2f,%ebx
  102ae1:	7e 35                	jle    102b18 <vprintfmt+0xde>
  102ae3:	83 fb 39             	cmp    $0x39,%ebx
  102ae6:	7f 30                	jg     102b18 <vprintfmt+0xde>
            for (precision = 0; ; ++ fmt) {
  102ae8:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  102aeb:	eb d5                	jmp    102ac2 <vprintfmt+0x88>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  102aed:	8b 45 14             	mov    0x14(%ebp),%eax
  102af0:	8d 50 04             	lea    0x4(%eax),%edx
  102af3:	89 55 14             	mov    %edx,0x14(%ebp)
  102af6:	8b 00                	mov    (%eax),%eax
  102af8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102afb:	eb 1c                	jmp    102b19 <vprintfmt+0xdf>

        case '.':
            if (width < 0)
  102afd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102b01:	79 89                	jns    102a8c <vprintfmt+0x52>
                width = 0;
  102b03:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102b0a:	eb 80                	jmp    102a8c <vprintfmt+0x52>

        case '#':
            altflag = 1;
  102b0c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102b13:	e9 74 ff ff ff       	jmp    102a8c <vprintfmt+0x52>
            goto process_precision;
  102b18:	90                   	nop

        process_precision:
            if (width < 0)
  102b19:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102b1d:	0f 89 69 ff ff ff    	jns    102a8c <vprintfmt+0x52>
                width = precision, precision = -1;
  102b23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b26:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102b29:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102b30:	e9 57 ff ff ff       	jmp    102a8c <vprintfmt+0x52>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102b35:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  102b38:	e9 4f ff ff ff       	jmp    102a8c <vprintfmt+0x52>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102b3d:	8b 45 14             	mov    0x14(%ebp),%eax
  102b40:	8d 50 04             	lea    0x4(%eax),%edx
  102b43:	89 55 14             	mov    %edx,0x14(%ebp)
  102b46:	8b 00                	mov    (%eax),%eax
  102b48:	83 ec 08             	sub    $0x8,%esp
  102b4b:	ff 75 0c             	pushl  0xc(%ebp)
  102b4e:	50                   	push   %eax
  102b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  102b52:	ff d0                	call   *%eax
  102b54:	83 c4 10             	add    $0x10,%esp
            break;
  102b57:	e9 67 02 00 00       	jmp    102dc3 <vprintfmt+0x389>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102b5c:	8b 45 14             	mov    0x14(%ebp),%eax
  102b5f:	8d 50 04             	lea    0x4(%eax),%edx
  102b62:	89 55 14             	mov    %edx,0x14(%ebp)
  102b65:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102b67:	85 db                	test   %ebx,%ebx
  102b69:	79 02                	jns    102b6d <vprintfmt+0x133>
                err = -err;
  102b6b:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102b6d:	83 fb 06             	cmp    $0x6,%ebx
  102b70:	7f 0b                	jg     102b7d <vprintfmt+0x143>
  102b72:	8b 34 9d 94 3a 10 00 	mov    0x103a94(,%ebx,4),%esi
  102b79:	85 f6                	test   %esi,%esi
  102b7b:	75 19                	jne    102b96 <vprintfmt+0x15c>
                printfmt(putch, putdat, "error %d", err);
  102b7d:	53                   	push   %ebx
  102b7e:	68 c1 3a 10 00       	push   $0x103ac1
  102b83:	ff 75 0c             	pushl  0xc(%ebp)
  102b86:	ff 75 08             	pushl  0x8(%ebp)
  102b89:	e8 88 fe ff ff       	call   102a16 <printfmt>
  102b8e:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102b91:	e9 2d 02 00 00       	jmp    102dc3 <vprintfmt+0x389>
                printfmt(putch, putdat, "%s", p);
  102b96:	56                   	push   %esi
  102b97:	68 ca 3a 10 00       	push   $0x103aca
  102b9c:	ff 75 0c             	pushl  0xc(%ebp)
  102b9f:	ff 75 08             	pushl  0x8(%ebp)
  102ba2:	e8 6f fe ff ff       	call   102a16 <printfmt>
  102ba7:	83 c4 10             	add    $0x10,%esp
            break;
  102baa:	e9 14 02 00 00       	jmp    102dc3 <vprintfmt+0x389>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102baf:	8b 45 14             	mov    0x14(%ebp),%eax
  102bb2:	8d 50 04             	lea    0x4(%eax),%edx
  102bb5:	89 55 14             	mov    %edx,0x14(%ebp)
  102bb8:	8b 30                	mov    (%eax),%esi
  102bba:	85 f6                	test   %esi,%esi
  102bbc:	75 05                	jne    102bc3 <vprintfmt+0x189>
                p = "(null)";
  102bbe:	be cd 3a 10 00       	mov    $0x103acd,%esi
            }
            if (width > 0 && padc != '-') {
  102bc3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102bc7:	7e 74                	jle    102c3d <vprintfmt+0x203>
  102bc9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102bcd:	74 6e                	je     102c3d <vprintfmt+0x203>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102bcf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102bd2:	83 ec 08             	sub    $0x8,%esp
  102bd5:	50                   	push   %eax
  102bd6:	56                   	push   %esi
  102bd7:	e8 d3 02 00 00       	call   102eaf <strnlen>
  102bdc:	83 c4 10             	add    $0x10,%esp
  102bdf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102be2:	29 c2                	sub    %eax,%edx
  102be4:	89 d0                	mov    %edx,%eax
  102be6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102be9:	eb 16                	jmp    102c01 <vprintfmt+0x1c7>
                    putch(padc, putdat);
  102beb:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102bef:	83 ec 08             	sub    $0x8,%esp
  102bf2:	ff 75 0c             	pushl  0xc(%ebp)
  102bf5:	50                   	push   %eax
  102bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  102bf9:	ff d0                	call   *%eax
  102bfb:	83 c4 10             	add    $0x10,%esp
                for (width -= strnlen(p, precision); width > 0; width --) {
  102bfe:	ff 4d e8             	decl   -0x18(%ebp)
  102c01:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102c05:	7f e4                	jg     102beb <vprintfmt+0x1b1>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102c07:	eb 34                	jmp    102c3d <vprintfmt+0x203>
                if (altflag && (ch < ' ' || ch > '~')) {
  102c09:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102c0d:	74 1c                	je     102c2b <vprintfmt+0x1f1>
  102c0f:	83 fb 1f             	cmp    $0x1f,%ebx
  102c12:	7e 05                	jle    102c19 <vprintfmt+0x1df>
  102c14:	83 fb 7e             	cmp    $0x7e,%ebx
  102c17:	7e 12                	jle    102c2b <vprintfmt+0x1f1>
                    putch('?', putdat);
  102c19:	83 ec 08             	sub    $0x8,%esp
  102c1c:	ff 75 0c             	pushl  0xc(%ebp)
  102c1f:	6a 3f                	push   $0x3f
  102c21:	8b 45 08             	mov    0x8(%ebp),%eax
  102c24:	ff d0                	call   *%eax
  102c26:	83 c4 10             	add    $0x10,%esp
  102c29:	eb 0f                	jmp    102c3a <vprintfmt+0x200>
                }
                else {
                    putch(ch, putdat);
  102c2b:	83 ec 08             	sub    $0x8,%esp
  102c2e:	ff 75 0c             	pushl  0xc(%ebp)
  102c31:	53                   	push   %ebx
  102c32:	8b 45 08             	mov    0x8(%ebp),%eax
  102c35:	ff d0                	call   *%eax
  102c37:	83 c4 10             	add    $0x10,%esp
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102c3a:	ff 4d e8             	decl   -0x18(%ebp)
  102c3d:	89 f0                	mov    %esi,%eax
  102c3f:	8d 70 01             	lea    0x1(%eax),%esi
  102c42:	8a 00                	mov    (%eax),%al
  102c44:	0f be d8             	movsbl %al,%ebx
  102c47:	85 db                	test   %ebx,%ebx
  102c49:	74 24                	je     102c6f <vprintfmt+0x235>
  102c4b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102c4f:	78 b8                	js     102c09 <vprintfmt+0x1cf>
  102c51:	ff 4d e4             	decl   -0x1c(%ebp)
  102c54:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102c58:	79 af                	jns    102c09 <vprintfmt+0x1cf>
                }
            }
            for (; width > 0; width --) {
  102c5a:	eb 13                	jmp    102c6f <vprintfmt+0x235>
                putch(' ', putdat);
  102c5c:	83 ec 08             	sub    $0x8,%esp
  102c5f:	ff 75 0c             	pushl  0xc(%ebp)
  102c62:	6a 20                	push   $0x20
  102c64:	8b 45 08             	mov    0x8(%ebp),%eax
  102c67:	ff d0                	call   *%eax
  102c69:	83 c4 10             	add    $0x10,%esp
            for (; width > 0; width --) {
  102c6c:	ff 4d e8             	decl   -0x18(%ebp)
  102c6f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102c73:	7f e7                	jg     102c5c <vprintfmt+0x222>
            }
            break;
  102c75:	e9 49 01 00 00       	jmp    102dc3 <vprintfmt+0x389>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102c7a:	83 ec 08             	sub    $0x8,%esp
  102c7d:	ff 75 e0             	pushl  -0x20(%ebp)
  102c80:	8d 45 14             	lea    0x14(%ebp),%eax
  102c83:	50                   	push   %eax
  102c84:	e8 46 fd ff ff       	call   1029cf <getint>
  102c89:	83 c4 10             	add    $0x10,%esp
  102c8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102c8f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102c92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102c98:	85 d2                	test   %edx,%edx
  102c9a:	79 23                	jns    102cbf <vprintfmt+0x285>
                putch('-', putdat);
  102c9c:	83 ec 08             	sub    $0x8,%esp
  102c9f:	ff 75 0c             	pushl  0xc(%ebp)
  102ca2:	6a 2d                	push   $0x2d
  102ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ca7:	ff d0                	call   *%eax
  102ca9:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  102cac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102caf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102cb2:	f7 d8                	neg    %eax
  102cb4:	83 d2 00             	adc    $0x0,%edx
  102cb7:	f7 da                	neg    %edx
  102cb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102cbc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102cbf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102cc6:	e9 9f 00 00 00       	jmp    102d6a <vprintfmt+0x330>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102ccb:	83 ec 08             	sub    $0x8,%esp
  102cce:	ff 75 e0             	pushl  -0x20(%ebp)
  102cd1:	8d 45 14             	lea    0x14(%ebp),%eax
  102cd4:	50                   	push   %eax
  102cd5:	e8 a6 fc ff ff       	call   102980 <getuint>
  102cda:	83 c4 10             	add    $0x10,%esp
  102cdd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ce0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102ce3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102cea:	eb 7e                	jmp    102d6a <vprintfmt+0x330>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102cec:	83 ec 08             	sub    $0x8,%esp
  102cef:	ff 75 e0             	pushl  -0x20(%ebp)
  102cf2:	8d 45 14             	lea    0x14(%ebp),%eax
  102cf5:	50                   	push   %eax
  102cf6:	e8 85 fc ff ff       	call   102980 <getuint>
  102cfb:	83 c4 10             	add    $0x10,%esp
  102cfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d01:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102d04:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102d0b:	eb 5d                	jmp    102d6a <vprintfmt+0x330>

        // pointer
        case 'p':
            putch('0', putdat);
  102d0d:	83 ec 08             	sub    $0x8,%esp
  102d10:	ff 75 0c             	pushl  0xc(%ebp)
  102d13:	6a 30                	push   $0x30
  102d15:	8b 45 08             	mov    0x8(%ebp),%eax
  102d18:	ff d0                	call   *%eax
  102d1a:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  102d1d:	83 ec 08             	sub    $0x8,%esp
  102d20:	ff 75 0c             	pushl  0xc(%ebp)
  102d23:	6a 78                	push   $0x78
  102d25:	8b 45 08             	mov    0x8(%ebp),%eax
  102d28:	ff d0                	call   *%eax
  102d2a:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102d2d:	8b 45 14             	mov    0x14(%ebp),%eax
  102d30:	8d 50 04             	lea    0x4(%eax),%edx
  102d33:	89 55 14             	mov    %edx,0x14(%ebp)
  102d36:	8b 00                	mov    (%eax),%eax
  102d38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d3b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102d42:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  102d49:	eb 1f                	jmp    102d6a <vprintfmt+0x330>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  102d4b:	83 ec 08             	sub    $0x8,%esp
  102d4e:	ff 75 e0             	pushl  -0x20(%ebp)
  102d51:	8d 45 14             	lea    0x14(%ebp),%eax
  102d54:	50                   	push   %eax
  102d55:	e8 26 fc ff ff       	call   102980 <getuint>
  102d5a:	83 c4 10             	add    $0x10,%esp
  102d5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d60:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  102d63:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  102d6a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  102d6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d71:	83 ec 04             	sub    $0x4,%esp
  102d74:	52                   	push   %edx
  102d75:	ff 75 e8             	pushl  -0x18(%ebp)
  102d78:	50                   	push   %eax
  102d79:	ff 75 f4             	pushl  -0xc(%ebp)
  102d7c:	ff 75 f0             	pushl  -0x10(%ebp)
  102d7f:	ff 75 0c             	pushl  0xc(%ebp)
  102d82:	ff 75 08             	pushl  0x8(%ebp)
  102d85:	e8 0e fb ff ff       	call   102898 <printnum>
  102d8a:	83 c4 20             	add    $0x20,%esp
            break;
  102d8d:	eb 34                	jmp    102dc3 <vprintfmt+0x389>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  102d8f:	83 ec 08             	sub    $0x8,%esp
  102d92:	ff 75 0c             	pushl  0xc(%ebp)
  102d95:	53                   	push   %ebx
  102d96:	8b 45 08             	mov    0x8(%ebp),%eax
  102d99:	ff d0                	call   *%eax
  102d9b:	83 c4 10             	add    $0x10,%esp
            break;
  102d9e:	eb 23                	jmp    102dc3 <vprintfmt+0x389>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  102da0:	83 ec 08             	sub    $0x8,%esp
  102da3:	ff 75 0c             	pushl  0xc(%ebp)
  102da6:	6a 25                	push   $0x25
  102da8:	8b 45 08             	mov    0x8(%ebp),%eax
  102dab:	ff d0                	call   *%eax
  102dad:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  102db0:	ff 4d 10             	decl   0x10(%ebp)
  102db3:	eb 03                	jmp    102db8 <vprintfmt+0x37e>
  102db5:	ff 4d 10             	decl   0x10(%ebp)
  102db8:	8b 45 10             	mov    0x10(%ebp),%eax
  102dbb:	48                   	dec    %eax
  102dbc:	8a 00                	mov    (%eax),%al
  102dbe:	3c 25                	cmp    $0x25,%al
  102dc0:	75 f3                	jne    102db5 <vprintfmt+0x37b>
                /* do nothing */;
            break;
  102dc2:	90                   	nop
    while (1) {
  102dc3:	e9 7a fc ff ff       	jmp    102a42 <vprintfmt+0x8>
                return;
  102dc8:	90                   	nop
        }
    }
}
  102dc9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  102dcc:	5b                   	pop    %ebx
  102dcd:	5e                   	pop    %esi
  102dce:	5d                   	pop    %ebp
  102dcf:	c3                   	ret    

00102dd0 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  102dd0:	55                   	push   %ebp
  102dd1:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  102dd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dd6:	8b 40 08             	mov    0x8(%eax),%eax
  102dd9:	8d 50 01             	lea    0x1(%eax),%edx
  102ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ddf:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  102de2:	8b 45 0c             	mov    0xc(%ebp),%eax
  102de5:	8b 10                	mov    (%eax),%edx
  102de7:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dea:	8b 40 04             	mov    0x4(%eax),%eax
  102ded:	39 c2                	cmp    %eax,%edx
  102def:	73 12                	jae    102e03 <sprintputch+0x33>
        *b->buf ++ = ch;
  102df1:	8b 45 0c             	mov    0xc(%ebp),%eax
  102df4:	8b 00                	mov    (%eax),%eax
  102df6:	8d 48 01             	lea    0x1(%eax),%ecx
  102df9:	8b 55 0c             	mov    0xc(%ebp),%edx
  102dfc:	89 0a                	mov    %ecx,(%edx)
  102dfe:	8b 55 08             	mov    0x8(%ebp),%edx
  102e01:	88 10                	mov    %dl,(%eax)
    }
}
  102e03:	90                   	nop
  102e04:	5d                   	pop    %ebp
  102e05:	c3                   	ret    

00102e06 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  102e06:	55                   	push   %ebp
  102e07:	89 e5                	mov    %esp,%ebp
  102e09:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  102e0c:	8d 45 14             	lea    0x14(%ebp),%eax
  102e0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  102e12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e15:	50                   	push   %eax
  102e16:	ff 75 10             	pushl  0x10(%ebp)
  102e19:	ff 75 0c             	pushl  0xc(%ebp)
  102e1c:	ff 75 08             	pushl  0x8(%ebp)
  102e1f:	e8 0b 00 00 00       	call   102e2f <vsnprintf>
  102e24:	83 c4 10             	add    $0x10,%esp
  102e27:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  102e2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102e2d:	c9                   	leave  
  102e2e:	c3                   	ret    

00102e2f <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  102e2f:	55                   	push   %ebp
  102e30:	89 e5                	mov    %esp,%ebp
  102e32:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  102e35:	8b 45 08             	mov    0x8(%ebp),%eax
  102e38:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e3e:	8d 50 ff             	lea    -0x1(%eax),%edx
  102e41:	8b 45 08             	mov    0x8(%ebp),%eax
  102e44:	01 d0                	add    %edx,%eax
  102e46:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e49:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  102e50:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102e54:	74 0a                	je     102e60 <vsnprintf+0x31>
  102e56:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102e59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e5c:	39 c2                	cmp    %eax,%edx
  102e5e:	76 07                	jbe    102e67 <vsnprintf+0x38>
        return -E_INVAL;
  102e60:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  102e65:	eb 20                	jmp    102e87 <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  102e67:	ff 75 14             	pushl  0x14(%ebp)
  102e6a:	ff 75 10             	pushl  0x10(%ebp)
  102e6d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  102e70:	50                   	push   %eax
  102e71:	68 d0 2d 10 00       	push   $0x102dd0
  102e76:	e8 bf fb ff ff       	call   102a3a <vprintfmt>
  102e7b:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  102e7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e81:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  102e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102e87:	c9                   	leave  
  102e88:	c3                   	ret    

00102e89 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102e89:	55                   	push   %ebp
  102e8a:	89 e5                	mov    %esp,%ebp
  102e8c:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102e8f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102e96:	eb 03                	jmp    102e9b <strlen+0x12>
        cnt ++;
  102e98:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  102e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  102e9e:	8d 50 01             	lea    0x1(%eax),%edx
  102ea1:	89 55 08             	mov    %edx,0x8(%ebp)
  102ea4:	8a 00                	mov    (%eax),%al
  102ea6:	84 c0                	test   %al,%al
  102ea8:	75 ee                	jne    102e98 <strlen+0xf>
    }
    return cnt;
  102eaa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102ead:	c9                   	leave  
  102eae:	c3                   	ret    

00102eaf <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102eaf:	55                   	push   %ebp
  102eb0:	89 e5                	mov    %esp,%ebp
  102eb2:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102eb5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102ebc:	eb 03                	jmp    102ec1 <strnlen+0x12>
        cnt ++;
  102ebe:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102ec1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102ec4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102ec7:	73 0f                	jae    102ed8 <strnlen+0x29>
  102ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  102ecc:	8d 50 01             	lea    0x1(%eax),%edx
  102ecf:	89 55 08             	mov    %edx,0x8(%ebp)
  102ed2:	8a 00                	mov    (%eax),%al
  102ed4:	84 c0                	test   %al,%al
  102ed6:	75 e6                	jne    102ebe <strnlen+0xf>
    }
    return cnt;
  102ed8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102edb:	c9                   	leave  
  102edc:	c3                   	ret    

00102edd <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102edd:	55                   	push   %ebp
  102ede:	89 e5                	mov    %esp,%ebp
  102ee0:	57                   	push   %edi
  102ee1:	56                   	push   %esi
  102ee2:	83 ec 20             	sub    $0x20,%esp
  102ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  102ee8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102eeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  102eee:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102ef1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ef7:	89 d1                	mov    %edx,%ecx
  102ef9:	89 c2                	mov    %eax,%edx
  102efb:	89 ce                	mov    %ecx,%esi
  102efd:	89 d7                	mov    %edx,%edi
  102eff:	ac                   	lods   %ds:(%esi),%al
  102f00:	aa                   	stos   %al,%es:(%edi)
  102f01:	84 c0                	test   %al,%al
  102f03:	75 fa                	jne    102eff <strcpy+0x22>
  102f05:	89 fa                	mov    %edi,%edx
  102f07:	89 f1                	mov    %esi,%ecx
  102f09:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102f0c:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102f0f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  102f15:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102f16:	83 c4 20             	add    $0x20,%esp
  102f19:	5e                   	pop    %esi
  102f1a:	5f                   	pop    %edi
  102f1b:	5d                   	pop    %ebp
  102f1c:	c3                   	ret    

00102f1d <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102f1d:	55                   	push   %ebp
  102f1e:	89 e5                	mov    %esp,%ebp
  102f20:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102f23:	8b 45 08             	mov    0x8(%ebp),%eax
  102f26:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102f29:	eb 1c                	jmp    102f47 <strncpy+0x2a>
        if ((*p = *src) != '\0') {
  102f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f2e:	8a 10                	mov    (%eax),%dl
  102f30:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102f33:	88 10                	mov    %dl,(%eax)
  102f35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102f38:	8a 00                	mov    (%eax),%al
  102f3a:	84 c0                	test   %al,%al
  102f3c:	74 03                	je     102f41 <strncpy+0x24>
            src ++;
  102f3e:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  102f41:	ff 45 fc             	incl   -0x4(%ebp)
  102f44:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  102f47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102f4b:	75 de                	jne    102f2b <strncpy+0xe>
    }
    return dst;
  102f4d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102f50:	c9                   	leave  
  102f51:	c3                   	ret    

00102f52 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102f52:	55                   	push   %ebp
  102f53:	89 e5                	mov    %esp,%ebp
  102f55:	57                   	push   %edi
  102f56:	56                   	push   %esi
  102f57:	83 ec 20             	sub    $0x20,%esp
  102f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  102f5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f60:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f63:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  102f66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102f69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f6c:	89 d1                	mov    %edx,%ecx
  102f6e:	89 c2                	mov    %eax,%edx
  102f70:	89 ce                	mov    %ecx,%esi
  102f72:	89 d7                	mov    %edx,%edi
  102f74:	ac                   	lods   %ds:(%esi),%al
  102f75:	ae                   	scas   %es:(%edi),%al
  102f76:	75 08                	jne    102f80 <strcmp+0x2e>
  102f78:	84 c0                	test   %al,%al
  102f7a:	75 f8                	jne    102f74 <strcmp+0x22>
  102f7c:	31 c0                	xor    %eax,%eax
  102f7e:	eb 04                	jmp    102f84 <strcmp+0x32>
  102f80:	19 c0                	sbb    %eax,%eax
  102f82:	0c 01                	or     $0x1,%al
  102f84:	89 fa                	mov    %edi,%edx
  102f86:	89 f1                	mov    %esi,%ecx
  102f88:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f8b:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102f8e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  102f91:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  102f94:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102f95:	83 c4 20             	add    $0x20,%esp
  102f98:	5e                   	pop    %esi
  102f99:	5f                   	pop    %edi
  102f9a:	5d                   	pop    %ebp
  102f9b:	c3                   	ret    

00102f9c <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102f9c:	55                   	push   %ebp
  102f9d:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102f9f:	eb 09                	jmp    102faa <strncmp+0xe>
        n --, s1 ++, s2 ++;
  102fa1:	ff 4d 10             	decl   0x10(%ebp)
  102fa4:	ff 45 08             	incl   0x8(%ebp)
  102fa7:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102faa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102fae:	74 17                	je     102fc7 <strncmp+0x2b>
  102fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  102fb3:	8a 00                	mov    (%eax),%al
  102fb5:	84 c0                	test   %al,%al
  102fb7:	74 0e                	je     102fc7 <strncmp+0x2b>
  102fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  102fbc:	8a 10                	mov    (%eax),%dl
  102fbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fc1:	8a 00                	mov    (%eax),%al
  102fc3:	38 c2                	cmp    %al,%dl
  102fc5:	74 da                	je     102fa1 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102fc7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102fcb:	74 16                	je     102fe3 <strncmp+0x47>
  102fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  102fd0:	8a 00                	mov    (%eax),%al
  102fd2:	0f b6 d0             	movzbl %al,%edx
  102fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fd8:	8a 00                	mov    (%eax),%al
  102fda:	0f b6 c0             	movzbl %al,%eax
  102fdd:	29 c2                	sub    %eax,%edx
  102fdf:	89 d0                	mov    %edx,%eax
  102fe1:	eb 05                	jmp    102fe8 <strncmp+0x4c>
  102fe3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102fe8:	5d                   	pop    %ebp
  102fe9:	c3                   	ret    

00102fea <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102fea:	55                   	push   %ebp
  102feb:	89 e5                	mov    %esp,%ebp
  102fed:	83 ec 04             	sub    $0x4,%esp
  102ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ff3:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102ff6:	eb 12                	jmp    10300a <strchr+0x20>
        if (*s == c) {
  102ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  102ffb:	8a 00                	mov    (%eax),%al
  102ffd:	38 45 fc             	cmp    %al,-0x4(%ebp)
  103000:	75 05                	jne    103007 <strchr+0x1d>
            return (char *)s;
  103002:	8b 45 08             	mov    0x8(%ebp),%eax
  103005:	eb 11                	jmp    103018 <strchr+0x2e>
        }
        s ++;
  103007:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  10300a:	8b 45 08             	mov    0x8(%ebp),%eax
  10300d:	8a 00                	mov    (%eax),%al
  10300f:	84 c0                	test   %al,%al
  103011:	75 e5                	jne    102ff8 <strchr+0xe>
    }
    return NULL;
  103013:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103018:	c9                   	leave  
  103019:	c3                   	ret    

0010301a <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  10301a:	55                   	push   %ebp
  10301b:	89 e5                	mov    %esp,%ebp
  10301d:	83 ec 04             	sub    $0x4,%esp
  103020:	8b 45 0c             	mov    0xc(%ebp),%eax
  103023:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103026:	eb 0d                	jmp    103035 <strfind+0x1b>
        if (*s == c) {
  103028:	8b 45 08             	mov    0x8(%ebp),%eax
  10302b:	8a 00                	mov    (%eax),%al
  10302d:	38 45 fc             	cmp    %al,-0x4(%ebp)
  103030:	74 0e                	je     103040 <strfind+0x26>
            break;
        }
        s ++;
  103032:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  103035:	8b 45 08             	mov    0x8(%ebp),%eax
  103038:	8a 00                	mov    (%eax),%al
  10303a:	84 c0                	test   %al,%al
  10303c:	75 ea                	jne    103028 <strfind+0xe>
  10303e:	eb 01                	jmp    103041 <strfind+0x27>
            break;
  103040:	90                   	nop
    }
    return (char *)s;
  103041:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103044:	c9                   	leave  
  103045:	c3                   	ret    

00103046 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  103046:	55                   	push   %ebp
  103047:	89 e5                	mov    %esp,%ebp
  103049:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  10304c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  103053:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  10305a:	eb 03                	jmp    10305f <strtol+0x19>
        s ++;
  10305c:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  10305f:	8b 45 08             	mov    0x8(%ebp),%eax
  103062:	8a 00                	mov    (%eax),%al
  103064:	3c 20                	cmp    $0x20,%al
  103066:	74 f4                	je     10305c <strtol+0x16>
  103068:	8b 45 08             	mov    0x8(%ebp),%eax
  10306b:	8a 00                	mov    (%eax),%al
  10306d:	3c 09                	cmp    $0x9,%al
  10306f:	74 eb                	je     10305c <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  103071:	8b 45 08             	mov    0x8(%ebp),%eax
  103074:	8a 00                	mov    (%eax),%al
  103076:	3c 2b                	cmp    $0x2b,%al
  103078:	75 05                	jne    10307f <strtol+0x39>
        s ++;
  10307a:	ff 45 08             	incl   0x8(%ebp)
  10307d:	eb 13                	jmp    103092 <strtol+0x4c>
    }
    else if (*s == '-') {
  10307f:	8b 45 08             	mov    0x8(%ebp),%eax
  103082:	8a 00                	mov    (%eax),%al
  103084:	3c 2d                	cmp    $0x2d,%al
  103086:	75 0a                	jne    103092 <strtol+0x4c>
        s ++, neg = 1;
  103088:	ff 45 08             	incl   0x8(%ebp)
  10308b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  103092:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103096:	74 06                	je     10309e <strtol+0x58>
  103098:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  10309c:	75 20                	jne    1030be <strtol+0x78>
  10309e:	8b 45 08             	mov    0x8(%ebp),%eax
  1030a1:	8a 00                	mov    (%eax),%al
  1030a3:	3c 30                	cmp    $0x30,%al
  1030a5:	75 17                	jne    1030be <strtol+0x78>
  1030a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1030aa:	40                   	inc    %eax
  1030ab:	8a 00                	mov    (%eax),%al
  1030ad:	3c 78                	cmp    $0x78,%al
  1030af:	75 0d                	jne    1030be <strtol+0x78>
        s += 2, base = 16;
  1030b1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  1030b5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  1030bc:	eb 28                	jmp    1030e6 <strtol+0xa0>
    }
    else if (base == 0 && s[0] == '0') {
  1030be:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1030c2:	75 15                	jne    1030d9 <strtol+0x93>
  1030c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1030c7:	8a 00                	mov    (%eax),%al
  1030c9:	3c 30                	cmp    $0x30,%al
  1030cb:	75 0c                	jne    1030d9 <strtol+0x93>
        s ++, base = 8;
  1030cd:	ff 45 08             	incl   0x8(%ebp)
  1030d0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  1030d7:	eb 0d                	jmp    1030e6 <strtol+0xa0>
    }
    else if (base == 0) {
  1030d9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1030dd:	75 07                	jne    1030e6 <strtol+0xa0>
        base = 10;
  1030df:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  1030e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1030e9:	8a 00                	mov    (%eax),%al
  1030eb:	3c 2f                	cmp    $0x2f,%al
  1030ed:	7e 19                	jle    103108 <strtol+0xc2>
  1030ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1030f2:	8a 00                	mov    (%eax),%al
  1030f4:	3c 39                	cmp    $0x39,%al
  1030f6:	7f 10                	jg     103108 <strtol+0xc2>
            dig = *s - '0';
  1030f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1030fb:	8a 00                	mov    (%eax),%al
  1030fd:	0f be c0             	movsbl %al,%eax
  103100:	83 e8 30             	sub    $0x30,%eax
  103103:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103106:	eb 42                	jmp    10314a <strtol+0x104>
        }
        else if (*s >= 'a' && *s <= 'z') {
  103108:	8b 45 08             	mov    0x8(%ebp),%eax
  10310b:	8a 00                	mov    (%eax),%al
  10310d:	3c 60                	cmp    $0x60,%al
  10310f:	7e 19                	jle    10312a <strtol+0xe4>
  103111:	8b 45 08             	mov    0x8(%ebp),%eax
  103114:	8a 00                	mov    (%eax),%al
  103116:	3c 7a                	cmp    $0x7a,%al
  103118:	7f 10                	jg     10312a <strtol+0xe4>
            dig = *s - 'a' + 10;
  10311a:	8b 45 08             	mov    0x8(%ebp),%eax
  10311d:	8a 00                	mov    (%eax),%al
  10311f:	0f be c0             	movsbl %al,%eax
  103122:	83 e8 57             	sub    $0x57,%eax
  103125:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103128:	eb 20                	jmp    10314a <strtol+0x104>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  10312a:	8b 45 08             	mov    0x8(%ebp),%eax
  10312d:	8a 00                	mov    (%eax),%al
  10312f:	3c 40                	cmp    $0x40,%al
  103131:	7e 39                	jle    10316c <strtol+0x126>
  103133:	8b 45 08             	mov    0x8(%ebp),%eax
  103136:	8a 00                	mov    (%eax),%al
  103138:	3c 5a                	cmp    $0x5a,%al
  10313a:	7f 30                	jg     10316c <strtol+0x126>
            dig = *s - 'A' + 10;
  10313c:	8b 45 08             	mov    0x8(%ebp),%eax
  10313f:	8a 00                	mov    (%eax),%al
  103141:	0f be c0             	movsbl %al,%eax
  103144:	83 e8 37             	sub    $0x37,%eax
  103147:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  10314a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10314d:	3b 45 10             	cmp    0x10(%ebp),%eax
  103150:	7d 19                	jge    10316b <strtol+0x125>
            break;
        }
        s ++, val = (val * base) + dig;
  103152:	ff 45 08             	incl   0x8(%ebp)
  103155:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103158:	0f af 45 10          	imul   0x10(%ebp),%eax
  10315c:	89 c2                	mov    %eax,%edx
  10315e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103161:	01 d0                	add    %edx,%eax
  103163:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  103166:	e9 7b ff ff ff       	jmp    1030e6 <strtol+0xa0>
            break;
  10316b:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  10316c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103170:	74 08                	je     10317a <strtol+0x134>
        *endptr = (char *) s;
  103172:	8b 45 0c             	mov    0xc(%ebp),%eax
  103175:	8b 55 08             	mov    0x8(%ebp),%edx
  103178:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  10317a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  10317e:	74 07                	je     103187 <strtol+0x141>
  103180:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103183:	f7 d8                	neg    %eax
  103185:	eb 03                	jmp    10318a <strtol+0x144>
  103187:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  10318a:	c9                   	leave  
  10318b:	c3                   	ret    

0010318c <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  10318c:	55                   	push   %ebp
  10318d:	89 e5                	mov    %esp,%ebp
  10318f:	57                   	push   %edi
  103190:	83 ec 24             	sub    $0x24,%esp
  103193:	8b 45 0c             	mov    0xc(%ebp),%eax
  103196:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  103199:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  10319d:	8b 55 08             	mov    0x8(%ebp),%edx
  1031a0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  1031a3:	88 45 f7             	mov    %al,-0x9(%ebp)
  1031a6:	8b 45 10             	mov    0x10(%ebp),%eax
  1031a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  1031ac:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1031af:	8a 45 f7             	mov    -0x9(%ebp),%al
  1031b2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  1031b5:	89 d7                	mov    %edx,%edi
  1031b7:	f3 aa                	rep stos %al,%es:(%edi)
  1031b9:	89 fa                	mov    %edi,%edx
  1031bb:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1031be:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  1031c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1031c4:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  1031c5:	83 c4 24             	add    $0x24,%esp
  1031c8:	5f                   	pop    %edi
  1031c9:	5d                   	pop    %ebp
  1031ca:	c3                   	ret    

001031cb <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  1031cb:	55                   	push   %ebp
  1031cc:	89 e5                	mov    %esp,%ebp
  1031ce:	57                   	push   %edi
  1031cf:	56                   	push   %esi
  1031d0:	53                   	push   %ebx
  1031d1:	83 ec 30             	sub    $0x30,%esp
  1031d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1031d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1031da:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1031e0:	8b 45 10             	mov    0x10(%ebp),%eax
  1031e3:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  1031e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031e9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1031ec:	73 42                	jae    103230 <memmove+0x65>
  1031ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1031f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1031f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1031fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1031fd:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103200:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103203:	c1 e8 02             	shr    $0x2,%eax
  103206:	89 c1                	mov    %eax,%ecx
    asm volatile (
  103208:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10320b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10320e:	89 d7                	mov    %edx,%edi
  103210:	89 c6                	mov    %eax,%esi
  103212:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103214:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  103217:	83 e1 03             	and    $0x3,%ecx
  10321a:	74 02                	je     10321e <memmove+0x53>
  10321c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10321e:	89 f0                	mov    %esi,%eax
  103220:	89 fa                	mov    %edi,%edx
  103222:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  103225:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103228:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  10322b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  10322e:	eb 36                	jmp    103266 <memmove+0x9b>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  103230:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103233:	8d 50 ff             	lea    -0x1(%eax),%edx
  103236:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103239:	01 c2                	add    %eax,%edx
  10323b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10323e:	8d 48 ff             	lea    -0x1(%eax),%ecx
  103241:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103244:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  103247:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10324a:	89 c1                	mov    %eax,%ecx
  10324c:	89 d8                	mov    %ebx,%eax
  10324e:	89 d6                	mov    %edx,%esi
  103250:	89 c7                	mov    %eax,%edi
  103252:	fd                   	std    
  103253:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103255:	fc                   	cld    
  103256:	89 f8                	mov    %edi,%eax
  103258:	89 f2                	mov    %esi,%edx
  10325a:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  10325d:	89 55 c8             	mov    %edx,-0x38(%ebp)
  103260:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  103263:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  103266:	83 c4 30             	add    $0x30,%esp
  103269:	5b                   	pop    %ebx
  10326a:	5e                   	pop    %esi
  10326b:	5f                   	pop    %edi
  10326c:	5d                   	pop    %ebp
  10326d:	c3                   	ret    

0010326e <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  10326e:	55                   	push   %ebp
  10326f:	89 e5                	mov    %esp,%ebp
  103271:	57                   	push   %edi
  103272:	56                   	push   %esi
  103273:	83 ec 20             	sub    $0x20,%esp
  103276:	8b 45 08             	mov    0x8(%ebp),%eax
  103279:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10327c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10327f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103282:	8b 45 10             	mov    0x10(%ebp),%eax
  103285:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103288:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10328b:	c1 e8 02             	shr    $0x2,%eax
  10328e:	89 c1                	mov    %eax,%ecx
    asm volatile (
  103290:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103293:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103296:	89 d7                	mov    %edx,%edi
  103298:	89 c6                	mov    %eax,%esi
  10329a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10329c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  10329f:	83 e1 03             	and    $0x3,%ecx
  1032a2:	74 02                	je     1032a6 <memcpy+0x38>
  1032a4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1032a6:	89 f0                	mov    %esi,%eax
  1032a8:	89 fa                	mov    %edi,%edx
  1032aa:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1032ad:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1032b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  1032b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  1032b6:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  1032b7:	83 c4 20             	add    $0x20,%esp
  1032ba:	5e                   	pop    %esi
  1032bb:	5f                   	pop    %edi
  1032bc:	5d                   	pop    %ebp
  1032bd:	c3                   	ret    

001032be <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  1032be:	55                   	push   %ebp
  1032bf:	89 e5                	mov    %esp,%ebp
  1032c1:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  1032c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1032c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  1032ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032cd:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  1032d0:	eb 2a                	jmp    1032fc <memcmp+0x3e>
        if (*s1 != *s2) {
  1032d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1032d5:	8a 10                	mov    (%eax),%dl
  1032d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1032da:	8a 00                	mov    (%eax),%al
  1032dc:	38 c2                	cmp    %al,%dl
  1032de:	74 16                	je     1032f6 <memcmp+0x38>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  1032e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1032e3:	8a 00                	mov    (%eax),%al
  1032e5:	0f b6 d0             	movzbl %al,%edx
  1032e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1032eb:	8a 00                	mov    (%eax),%al
  1032ed:	0f b6 c0             	movzbl %al,%eax
  1032f0:	29 c2                	sub    %eax,%edx
  1032f2:	89 d0                	mov    %edx,%eax
  1032f4:	eb 18                	jmp    10330e <memcmp+0x50>
        }
        s1 ++, s2 ++;
  1032f6:	ff 45 fc             	incl   -0x4(%ebp)
  1032f9:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  1032fc:	8b 45 10             	mov    0x10(%ebp),%eax
  1032ff:	8d 50 ff             	lea    -0x1(%eax),%edx
  103302:	89 55 10             	mov    %edx,0x10(%ebp)
  103305:	85 c0                	test   %eax,%eax
  103307:	75 c9                	jne    1032d2 <memcmp+0x14>
    }
    return 0;
  103309:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10330e:	c9                   	leave  
  10330f:	c3                   	ret    
