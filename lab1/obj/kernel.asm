
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
  10001b:	e8 28 2f 00 00       	call   102f48 <memset>
  100020:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100023:	e8 ff 13 00 00       	call   101427 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100028:	c7 45 f4 e0 30 10 00 	movl   $0x1030e0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10002f:	83 ec 08             	sub    $0x8,%esp
  100032:	ff 75 f4             	pushl  -0xc(%ebp)
  100035:	68 fc 30 10 00       	push   $0x1030fc
  10003a:	e8 b7 02 00 00       	call   1002f6 <cprintf>
  10003f:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100042:	e8 b2 07 00 00       	call   1007f9 <print_kerninfo>

    grade_backtrace();
  100047:	e8 74 00 00 00       	call   1000c0 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10004c:	e8 f8 25 00 00       	call   102649 <pmm_init>

    pic_init();                 // init interrupt controller
  100051:	e8 1b 15 00 00       	call   101571 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100056:	e8 5e 16 00 00       	call   1016b9 <idt_init>

    clock_init();               // init clock interrupt
  10005b:	e8 01 0c 00 00       	call   100c61 <clock_init>
    intr_enable();              // enable irq interrupt
  100060:	e8 7e 14 00 00       	call   1014e3 <intr_enable>
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
  100076:	e8 00 0b 00 00       	call   100b7b <mon_backtrace>
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
  100109:	68 01 31 10 00       	push   $0x103101
  10010e:	e8 e3 01 00 00       	call   1002f6 <cprintf>
  100113:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  100116:	66 8b 45 f6          	mov    -0xa(%ebp),%ax
  10011a:	0f b7 d0             	movzwl %ax,%edx
  10011d:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100122:	83 ec 04             	sub    $0x4,%esp
  100125:	52                   	push   %edx
  100126:	50                   	push   %eax
  100127:	68 0f 31 10 00       	push   $0x10310f
  10012c:	e8 c5 01 00 00       	call   1002f6 <cprintf>
  100131:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  100134:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100137:	0f b7 d0             	movzwl %ax,%edx
  10013a:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  10013f:	83 ec 04             	sub    $0x4,%esp
  100142:	52                   	push   %edx
  100143:	50                   	push   %eax
  100144:	68 1d 31 10 00       	push   $0x10311d
  100149:	e8 a8 01 00 00       	call   1002f6 <cprintf>
  10014e:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  100151:	66 8b 45 f2          	mov    -0xe(%ebp),%ax
  100155:	0f b7 d0             	movzwl %ax,%edx
  100158:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  10015d:	83 ec 04             	sub    $0x4,%esp
  100160:	52                   	push   %edx
  100161:	50                   	push   %eax
  100162:	68 2b 31 10 00       	push   $0x10312b
  100167:	e8 8a 01 00 00       	call   1002f6 <cprintf>
  10016c:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  10016f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100172:	0f b7 d0             	movzwl %ax,%edx
  100175:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  10017a:	83 ec 04             	sub    $0x4,%esp
  10017d:	52                   	push   %edx
  10017e:	50                   	push   %eax
  10017f:	68 39 31 10 00       	push   $0x103139
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
  1001b4:	68 48 31 10 00       	push   $0x103148
  1001b9:	e8 38 01 00 00       	call   1002f6 <cprintf>
  1001be:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  1001c1:	e8 d4 ff ff ff       	call   10019a <lab1_switch_to_user>
    lab1_print_cur_status();
  1001c6:	e8 16 ff ff ff       	call   1000e1 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001cb:	83 ec 0c             	sub    $0xc,%esp
  1001ce:	68 68 31 10 00       	push   $0x103168
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
  1001fa:	68 87 31 10 00       	push   $0x103187
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
  1002b5:	e8 9e 11 00 00       	call   101458 <cons_putc>
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
  1002e9:	e8 08 25 00 00       	call   1027f6 <vprintfmt>
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
  100328:	e8 2b 11 00 00       	call   101458 <cons_putc>
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
  100387:	e8 fc 10 00 00       	call   101488 <cons_getc>
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
  1004ef:	c7 00 8c 31 10 00    	movl   $0x10318c,(%eax)
    info->eip_line = 0;
  1004f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  1004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  100502:	c7 40 08 8c 31 10 00 	movl   $0x10318c,0x8(%eax)
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
  100526:	c7 45 f4 cc 39 10 00 	movl   $0x1039cc,-0xc(%ebp)
    stab_end = __STAB_END__;
  10052d:	c7 45 f0 64 bf 10 00 	movl   $0x10bf64,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100534:	c7 45 ec 65 bf 10 00 	movl   $0x10bf65,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10053b:	c7 45 e8 2d e0 10 00 	movl   $0x10e02d,-0x18(%ebp)

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
  100687:	e8 4a 27 00 00       	call   102dd6 <strfind>
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
  100802:	68 96 31 10 00       	push   $0x103196
  100807:	e8 ea fa ff ff       	call   1002f6 <cprintf>
  10080c:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10080f:	83 ec 08             	sub    $0x8,%esp
  100812:	68 00 00 10 00       	push   $0x100000
  100817:	68 af 31 10 00       	push   $0x1031af
  10081c:	e8 d5 fa ff ff       	call   1002f6 <cprintf>
  100821:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  100824:	83 ec 08             	sub    $0x8,%esp
  100827:	68 cc 30 10 00       	push   $0x1030cc
  10082c:	68 c7 31 10 00       	push   $0x1031c7
  100831:	e8 c0 fa ff ff       	call   1002f6 <cprintf>
  100836:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100839:	83 ec 08             	sub    $0x8,%esp
  10083c:	68 16 fa 10 00       	push   $0x10fa16
  100841:	68 df 31 10 00       	push   $0x1031df
  100846:	e8 ab fa ff ff       	call   1002f6 <cprintf>
  10084b:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  10084e:	83 ec 08             	sub    $0x8,%esp
  100851:	68 20 0d 11 00       	push   $0x110d20
  100856:	68 f7 31 10 00       	push   $0x1031f7
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
  100882:	68 10 32 10 00       	push   $0x103210
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
  1008b7:	68 3a 32 10 00       	push   $0x10323a
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
  10091c:	68 56 32 10 00       	push   $0x103256
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
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  10093d:	55                   	push   %ebp
  10093e:	89 e5                	mov    %esp,%ebp
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
  100940:	90                   	nop
  100941:	5d                   	pop    %ebp
  100942:	c3                   	ret    

00100943 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100943:	55                   	push   %ebp
  100944:	89 e5                	mov    %esp,%ebp
  100946:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
  100949:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100950:	eb 0c                	jmp    10095e <parse+0x1b>
            *buf ++ = '\0';
  100952:	8b 45 08             	mov    0x8(%ebp),%eax
  100955:	8d 50 01             	lea    0x1(%eax),%edx
  100958:	89 55 08             	mov    %edx,0x8(%ebp)
  10095b:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  10095e:	8b 45 08             	mov    0x8(%ebp),%eax
  100961:	8a 00                	mov    (%eax),%al
  100963:	84 c0                	test   %al,%al
  100965:	74 1d                	je     100984 <parse+0x41>
  100967:	8b 45 08             	mov    0x8(%ebp),%eax
  10096a:	8a 00                	mov    (%eax),%al
  10096c:	0f be c0             	movsbl %al,%eax
  10096f:	83 ec 08             	sub    $0x8,%esp
  100972:	50                   	push   %eax
  100973:	68 e8 32 10 00       	push   $0x1032e8
  100978:	e8 29 24 00 00       	call   102da6 <strchr>
  10097d:	83 c4 10             	add    $0x10,%esp
  100980:	85 c0                	test   %eax,%eax
  100982:	75 ce                	jne    100952 <parse+0xf>
        }
        if (*buf == '\0') {
  100984:	8b 45 08             	mov    0x8(%ebp),%eax
  100987:	8a 00                	mov    (%eax),%al
  100989:	84 c0                	test   %al,%al
  10098b:	74 62                	je     1009ef <parse+0xac>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  10098d:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100991:	75 12                	jne    1009a5 <parse+0x62>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100993:	83 ec 08             	sub    $0x8,%esp
  100996:	6a 10                	push   $0x10
  100998:	68 ed 32 10 00       	push   $0x1032ed
  10099d:	e8 54 f9 ff ff       	call   1002f6 <cprintf>
  1009a2:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  1009a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009a8:	8d 50 01             	lea    0x1(%eax),%edx
  1009ab:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1009ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1009b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1009b8:	01 c2                	add    %eax,%edx
  1009ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1009bd:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  1009bf:	eb 03                	jmp    1009c4 <parse+0x81>
            buf ++;
  1009c1:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  1009c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1009c7:	8a 00                	mov    (%eax),%al
  1009c9:	84 c0                	test   %al,%al
  1009cb:	74 91                	je     10095e <parse+0x1b>
  1009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1009d0:	8a 00                	mov    (%eax),%al
  1009d2:	0f be c0             	movsbl %al,%eax
  1009d5:	83 ec 08             	sub    $0x8,%esp
  1009d8:	50                   	push   %eax
  1009d9:	68 e8 32 10 00       	push   $0x1032e8
  1009de:	e8 c3 23 00 00       	call   102da6 <strchr>
  1009e3:	83 c4 10             	add    $0x10,%esp
  1009e6:	85 c0                	test   %eax,%eax
  1009e8:	74 d7                	je     1009c1 <parse+0x7e>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  1009ea:	e9 6f ff ff ff       	jmp    10095e <parse+0x1b>
            break;
  1009ef:	90                   	nop
        }
    }
    return argc;
  1009f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1009f3:	c9                   	leave  
  1009f4:	c3                   	ret    

001009f5 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  1009f5:	55                   	push   %ebp
  1009f6:	89 e5                	mov    %esp,%ebp
  1009f8:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  1009fb:	83 ec 08             	sub    $0x8,%esp
  1009fe:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100a01:	50                   	push   %eax
  100a02:	ff 75 08             	pushl  0x8(%ebp)
  100a05:	e8 39 ff ff ff       	call   100943 <parse>
  100a0a:	83 c4 10             	add    $0x10,%esp
  100a0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100a10:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100a14:	75 0a                	jne    100a20 <runcmd+0x2b>
        return 0;
  100a16:	b8 00 00 00 00       	mov    $0x0,%eax
  100a1b:	e9 80 00 00 00       	jmp    100aa0 <runcmd+0xab>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100a20:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a27:	eb 56                	jmp    100a7f <runcmd+0x8a>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100a29:	8b 55 b0             	mov    -0x50(%ebp),%edx
  100a2c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100a2f:	89 c8                	mov    %ecx,%eax
  100a31:	01 c0                	add    %eax,%eax
  100a33:	01 c8                	add    %ecx,%eax
  100a35:	c1 e0 02             	shl    $0x2,%eax
  100a38:	05 00 f0 10 00       	add    $0x10f000,%eax
  100a3d:	8b 00                	mov    (%eax),%eax
  100a3f:	83 ec 08             	sub    $0x8,%esp
  100a42:	52                   	push   %edx
  100a43:	50                   	push   %eax
  100a44:	e8 c5 22 00 00       	call   102d0e <strcmp>
  100a49:	83 c4 10             	add    $0x10,%esp
  100a4c:	85 c0                	test   %eax,%eax
  100a4e:	75 2c                	jne    100a7c <runcmd+0x87>
            return commands[i].func(argc - 1, argv + 1, tf);
  100a50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100a53:	89 d0                	mov    %edx,%eax
  100a55:	01 c0                	add    %eax,%eax
  100a57:	01 d0                	add    %edx,%eax
  100a59:	c1 e0 02             	shl    $0x2,%eax
  100a5c:	05 08 f0 10 00       	add    $0x10f008,%eax
  100a61:	8b 10                	mov    (%eax),%edx
  100a63:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100a66:	83 c0 04             	add    $0x4,%eax
  100a69:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100a6c:	49                   	dec    %ecx
  100a6d:	83 ec 04             	sub    $0x4,%esp
  100a70:	ff 75 0c             	pushl  0xc(%ebp)
  100a73:	50                   	push   %eax
  100a74:	51                   	push   %ecx
  100a75:	ff d2                	call   *%edx
  100a77:	83 c4 10             	add    $0x10,%esp
  100a7a:	eb 24                	jmp    100aa0 <runcmd+0xab>
    for (i = 0; i < NCOMMANDS; i ++) {
  100a7c:	ff 45 f4             	incl   -0xc(%ebp)
  100a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a82:	83 f8 02             	cmp    $0x2,%eax
  100a85:	76 a2                	jbe    100a29 <runcmd+0x34>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100a87:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100a8a:	83 ec 08             	sub    $0x8,%esp
  100a8d:	50                   	push   %eax
  100a8e:	68 0b 33 10 00       	push   $0x10330b
  100a93:	e8 5e f8 ff ff       	call   1002f6 <cprintf>
  100a98:	83 c4 10             	add    $0x10,%esp
    return 0;
  100a9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100aa0:	c9                   	leave  
  100aa1:	c3                   	ret    

00100aa2 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100aa2:	55                   	push   %ebp
  100aa3:	89 e5                	mov    %esp,%ebp
  100aa5:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100aa8:	83 ec 0c             	sub    $0xc,%esp
  100aab:	68 24 33 10 00       	push   $0x103324
  100ab0:	e8 41 f8 ff ff       	call   1002f6 <cprintf>
  100ab5:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100ab8:	83 ec 0c             	sub    $0xc,%esp
  100abb:	68 4c 33 10 00       	push   $0x10334c
  100ac0:	e8 31 f8 ff ff       	call   1002f6 <cprintf>
  100ac5:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100ac8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100acc:	74 0e                	je     100adc <kmonitor+0x3a>
        print_trapframe(tf);
  100ace:	83 ec 0c             	sub    $0xc,%esp
  100ad1:	ff 75 08             	pushl  0x8(%ebp)
  100ad4:	e8 2d 0c 00 00       	call   101706 <print_trapframe>
  100ad9:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100adc:	83 ec 0c             	sub    $0xc,%esp
  100adf:	68 71 33 10 00       	push   $0x103371
  100ae4:	e8 ff f6 ff ff       	call   1001e8 <readline>
  100ae9:	83 c4 10             	add    $0x10,%esp
  100aec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100aef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100af3:	74 e7                	je     100adc <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
  100af5:	83 ec 08             	sub    $0x8,%esp
  100af8:	ff 75 08             	pushl  0x8(%ebp)
  100afb:	ff 75 f4             	pushl  -0xc(%ebp)
  100afe:	e8 f2 fe ff ff       	call   1009f5 <runcmd>
  100b03:	83 c4 10             	add    $0x10,%esp
  100b06:	85 c0                	test   %eax,%eax
  100b08:	78 02                	js     100b0c <kmonitor+0x6a>
        if ((buf = readline("K> ")) != NULL) {
  100b0a:	eb d0                	jmp    100adc <kmonitor+0x3a>
                break;
  100b0c:	90                   	nop
            }
        }
    }
}
  100b0d:	90                   	nop
  100b0e:	c9                   	leave  
  100b0f:	c3                   	ret    

00100b10 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100b10:	55                   	push   %ebp
  100b11:	89 e5                	mov    %esp,%ebp
  100b13:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b16:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b1d:	eb 3b                	jmp    100b5a <mon_help+0x4a>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100b1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b22:	89 d0                	mov    %edx,%eax
  100b24:	01 c0                	add    %eax,%eax
  100b26:	01 d0                	add    %edx,%eax
  100b28:	c1 e0 02             	shl    $0x2,%eax
  100b2b:	05 04 f0 10 00       	add    $0x10f004,%eax
  100b30:	8b 10                	mov    (%eax),%edx
  100b32:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100b35:	89 c8                	mov    %ecx,%eax
  100b37:	01 c0                	add    %eax,%eax
  100b39:	01 c8                	add    %ecx,%eax
  100b3b:	c1 e0 02             	shl    $0x2,%eax
  100b3e:	05 00 f0 10 00       	add    $0x10f000,%eax
  100b43:	8b 00                	mov    (%eax),%eax
  100b45:	83 ec 04             	sub    $0x4,%esp
  100b48:	52                   	push   %edx
  100b49:	50                   	push   %eax
  100b4a:	68 75 33 10 00       	push   $0x103375
  100b4f:	e8 a2 f7 ff ff       	call   1002f6 <cprintf>
  100b54:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NCOMMANDS; i ++) {
  100b57:	ff 45 f4             	incl   -0xc(%ebp)
  100b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b5d:	83 f8 02             	cmp    $0x2,%eax
  100b60:	76 bd                	jbe    100b1f <mon_help+0xf>
    }
    return 0;
  100b62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100b67:	c9                   	leave  
  100b68:	c3                   	ret    

00100b69 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100b69:	55                   	push   %ebp
  100b6a:	89 e5                	mov    %esp,%ebp
  100b6c:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100b6f:	e8 85 fc ff ff       	call   1007f9 <print_kerninfo>
    return 0;
  100b74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100b79:	c9                   	leave  
  100b7a:	c3                   	ret    

00100b7b <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100b7b:	55                   	push   %ebp
  100b7c:	89 e5                	mov    %esp,%ebp
  100b7e:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100b81:	e8 b7 fd ff ff       	call   10093d <print_stackframe>
    return 0;
  100b86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100b8b:	c9                   	leave  
  100b8c:	c3                   	ret    

00100b8d <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100b8d:	55                   	push   %ebp
  100b8e:	89 e5                	mov    %esp,%ebp
  100b90:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
  100b93:	a1 40 fe 10 00       	mov    0x10fe40,%eax
  100b98:	85 c0                	test   %eax,%eax
  100b9a:	75 5f                	jne    100bfb <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
  100b9c:	c7 05 40 fe 10 00 01 	movl   $0x1,0x10fe40
  100ba3:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100ba6:	8d 45 14             	lea    0x14(%ebp),%eax
  100ba9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100bac:	83 ec 04             	sub    $0x4,%esp
  100baf:	ff 75 0c             	pushl  0xc(%ebp)
  100bb2:	ff 75 08             	pushl  0x8(%ebp)
  100bb5:	68 7e 33 10 00       	push   $0x10337e
  100bba:	e8 37 f7 ff ff       	call   1002f6 <cprintf>
  100bbf:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bc5:	83 ec 08             	sub    $0x8,%esp
  100bc8:	50                   	push   %eax
  100bc9:	ff 75 10             	pushl  0x10(%ebp)
  100bcc:	e8 fc f6 ff ff       	call   1002cd <vcprintf>
  100bd1:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100bd4:	83 ec 0c             	sub    $0xc,%esp
  100bd7:	68 9a 33 10 00       	push   $0x10339a
  100bdc:	e8 15 f7 ff ff       	call   1002f6 <cprintf>
  100be1:	83 c4 10             	add    $0x10,%esp
    
    cprintf("stack trackback:\n");
  100be4:	83 ec 0c             	sub    $0xc,%esp
  100be7:	68 9c 33 10 00       	push   $0x10339c
  100bec:	e8 05 f7 ff ff       	call   1002f6 <cprintf>
  100bf1:	83 c4 10             	add    $0x10,%esp
    print_stackframe();
  100bf4:	e8 44 fd ff ff       	call   10093d <print_stackframe>
  100bf9:	eb 01                	jmp    100bfc <__panic+0x6f>
        goto panic_dead;
  100bfb:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  100bfc:	e8 e9 08 00 00       	call   1014ea <intr_disable>
    while (1) {
        kmonitor(NULL);
  100c01:	83 ec 0c             	sub    $0xc,%esp
  100c04:	6a 00                	push   $0x0
  100c06:	e8 97 fe ff ff       	call   100aa2 <kmonitor>
  100c0b:	83 c4 10             	add    $0x10,%esp
  100c0e:	eb f1                	jmp    100c01 <__panic+0x74>

00100c10 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100c10:	55                   	push   %ebp
  100c11:	89 e5                	mov    %esp,%ebp
  100c13:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
  100c16:	8d 45 14             	lea    0x14(%ebp),%eax
  100c19:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100c1c:	83 ec 04             	sub    $0x4,%esp
  100c1f:	ff 75 0c             	pushl  0xc(%ebp)
  100c22:	ff 75 08             	pushl  0x8(%ebp)
  100c25:	68 ae 33 10 00       	push   $0x1033ae
  100c2a:	e8 c7 f6 ff ff       	call   1002f6 <cprintf>
  100c2f:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c35:	83 ec 08             	sub    $0x8,%esp
  100c38:	50                   	push   %eax
  100c39:	ff 75 10             	pushl  0x10(%ebp)
  100c3c:	e8 8c f6 ff ff       	call   1002cd <vcprintf>
  100c41:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100c44:	83 ec 0c             	sub    $0xc,%esp
  100c47:	68 9a 33 10 00       	push   $0x10339a
  100c4c:	e8 a5 f6 ff ff       	call   1002f6 <cprintf>
  100c51:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  100c54:	90                   	nop
  100c55:	c9                   	leave  
  100c56:	c3                   	ret    

00100c57 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100c57:	55                   	push   %ebp
  100c58:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100c5a:	a1 40 fe 10 00       	mov    0x10fe40,%eax
}
  100c5f:	5d                   	pop    %ebp
  100c60:	c3                   	ret    

00100c61 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100c61:	55                   	push   %ebp
  100c62:	89 e5                	mov    %esp,%ebp
  100c64:	83 ec 18             	sub    $0x18,%esp
  100c67:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100c6d:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100c71:	8a 45 ed             	mov    -0x13(%ebp),%al
  100c74:	66 8b 55 ee          	mov    -0x12(%ebp),%dx
  100c78:	ee                   	out    %al,(%dx)
  100c79:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100c7f:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100c83:	8a 45 f1             	mov    -0xf(%ebp),%al
  100c86:	66 8b 55 f2          	mov    -0xe(%ebp),%dx
  100c8a:	ee                   	out    %al,(%dx)
  100c8b:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100c91:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
  100c95:	8a 45 f5             	mov    -0xb(%ebp),%al
  100c98:	66 8b 55 f6          	mov    -0xa(%ebp),%dx
  100c9c:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100c9d:	c7 05 08 09 11 00 00 	movl   $0x0,0x110908
  100ca4:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100ca7:	83 ec 0c             	sub    $0xc,%esp
  100caa:	68 cc 33 10 00       	push   $0x1033cc
  100caf:	e8 42 f6 ff ff       	call   1002f6 <cprintf>
  100cb4:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100cb7:	83 ec 0c             	sub    $0xc,%esp
  100cba:	6a 00                	push   $0x0
  100cbc:	e8 84 08 00 00       	call   101545 <pic_enable>
  100cc1:	83 c4 10             	add    $0x10,%esp
}
  100cc4:	90                   	nop
  100cc5:	c9                   	leave  
  100cc6:	c3                   	ret    

00100cc7 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100cc7:	55                   	push   %ebp
  100cc8:	89 e5                	mov    %esp,%ebp
  100cca:	83 ec 10             	sub    $0x10,%esp
  100ccd:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100cd3:	66 8b 45 f2          	mov    -0xe(%ebp),%ax
  100cd7:	89 c2                	mov    %eax,%edx
  100cd9:	ec                   	in     (%dx),%al
  100cda:	88 45 f1             	mov    %al,-0xf(%ebp)
  100cdd:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100ce3:	66 8b 45 f6          	mov    -0xa(%ebp),%ax
  100ce7:	89 c2                	mov    %eax,%edx
  100ce9:	ec                   	in     (%dx),%al
  100cea:	88 45 f5             	mov    %al,-0xb(%ebp)
  100ced:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100cf3:	66 8b 45 fa          	mov    -0x6(%ebp),%ax
  100cf7:	89 c2                	mov    %eax,%edx
  100cf9:	ec                   	in     (%dx),%al
  100cfa:	88 45 f9             	mov    %al,-0x7(%ebp)
  100cfd:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100d03:	66 8b 45 fe          	mov    -0x2(%ebp),%ax
  100d07:	89 c2                	mov    %eax,%edx
  100d09:	ec                   	in     (%dx),%al
  100d0a:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100d0d:	90                   	nop
  100d0e:	c9                   	leave  
  100d0f:	c3                   	ret    

00100d10 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100d10:	55                   	push   %ebp
  100d11:	89 e5                	mov    %esp,%ebp
  100d13:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100d16:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100d1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100d20:	66 8b 00             	mov    (%eax),%ax
  100d23:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100d27:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100d2a:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100d2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100d32:	66 8b 00             	mov    (%eax),%ax
  100d35:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100d39:	74 12                	je     100d4d <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100d3b:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100d42:	66 c7 05 66 fe 10 00 	movw   $0x3b4,0x10fe66
  100d49:	b4 03 
  100d4b:	eb 13                	jmp    100d60 <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100d4d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100d50:	66 8b 45 fa          	mov    -0x6(%ebp),%ax
  100d54:	66 89 02             	mov    %ax,(%edx)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100d57:	66 c7 05 66 fe 10 00 	movw   $0x3d4,0x10fe66
  100d5e:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100d60:	66 a1 66 fe 10 00    	mov    0x10fe66,%ax
  100d66:	0f b7 c0             	movzwl %ax,%eax
  100d69:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100d6d:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d71:	8a 45 e5             	mov    -0x1b(%ebp),%al
  100d74:	66 8b 55 e6          	mov    -0x1a(%ebp),%dx
  100d78:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100d79:	66 a1 66 fe 10 00    	mov    0x10fe66,%ax
  100d7f:	40                   	inc    %eax
  100d80:	0f b7 c0             	movzwl %ax,%eax
  100d83:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100d87:	66 8b 45 ea          	mov    -0x16(%ebp),%ax
  100d8b:	89 c2                	mov    %eax,%edx
  100d8d:	ec                   	in     (%dx),%al
  100d8e:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100d91:	8a 45 e9             	mov    -0x17(%ebp),%al
  100d94:	0f b6 c0             	movzbl %al,%eax
  100d97:	c1 e0 08             	shl    $0x8,%eax
  100d9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100d9d:	66 a1 66 fe 10 00    	mov    0x10fe66,%ax
  100da3:	0f b7 c0             	movzwl %ax,%eax
  100da6:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100daa:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100dae:	8a 45 ed             	mov    -0x13(%ebp),%al
  100db1:	66 8b 55 ee          	mov    -0x12(%ebp),%dx
  100db5:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100db6:	66 a1 66 fe 10 00    	mov    0x10fe66,%ax
  100dbc:	40                   	inc    %eax
  100dbd:	0f b7 c0             	movzwl %ax,%eax
  100dc0:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100dc4:	66 8b 45 f2          	mov    -0xe(%ebp),%ax
  100dc8:	89 c2                	mov    %eax,%edx
  100dca:	ec                   	in     (%dx),%al
  100dcb:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100dce:	8a 45 f1             	mov    -0xf(%ebp),%al
  100dd1:	0f b6 c0             	movzbl %al,%eax
  100dd4:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100dd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100dda:	a3 60 fe 10 00       	mov    %eax,0x10fe60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100de2:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
}
  100de8:	90                   	nop
  100de9:	c9                   	leave  
  100dea:	c3                   	ret    

00100deb <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100deb:	55                   	push   %ebp
  100dec:	89 e5                	mov    %esp,%ebp
  100dee:	83 ec 38             	sub    $0x38,%esp
  100df1:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100df7:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100dfb:	8a 45 d1             	mov    -0x2f(%ebp),%al
  100dfe:	66 8b 55 d2          	mov    -0x2e(%ebp),%dx
  100e02:	ee                   	out    %al,(%dx)
  100e03:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100e09:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
  100e0d:	8a 45 d5             	mov    -0x2b(%ebp),%al
  100e10:	66 8b 55 d6          	mov    -0x2a(%ebp),%dx
  100e14:	ee                   	out    %al,(%dx)
  100e15:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100e1b:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
  100e1f:	8a 45 d9             	mov    -0x27(%ebp),%al
  100e22:	66 8b 55 da          	mov    -0x26(%ebp),%dx
  100e26:	ee                   	out    %al,(%dx)
  100e27:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100e2d:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100e31:	8a 45 dd             	mov    -0x23(%ebp),%al
  100e34:	66 8b 55 de          	mov    -0x22(%ebp),%dx
  100e38:	ee                   	out    %al,(%dx)
  100e39:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100e3f:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
  100e43:	8a 45 e1             	mov    -0x1f(%ebp),%al
  100e46:	66 8b 55 e2          	mov    -0x1e(%ebp),%dx
  100e4a:	ee                   	out    %al,(%dx)
  100e4b:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100e51:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  100e55:	8a 45 e5             	mov    -0x1b(%ebp),%al
  100e58:	66 8b 55 e6          	mov    -0x1a(%ebp),%dx
  100e5c:	ee                   	out    %al,(%dx)
  100e5d:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100e63:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
  100e67:	8a 45 e9             	mov    -0x17(%ebp),%al
  100e6a:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
  100e6e:	ee                   	out    %al,(%dx)
  100e6f:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e75:	66 8b 45 ee          	mov    -0x12(%ebp),%ax
  100e79:	89 c2                	mov    %eax,%edx
  100e7b:	ec                   	in     (%dx),%al
  100e7c:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100e7f:	8a 45 ed             	mov    -0x13(%ebp),%al
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100e82:	3c ff                	cmp    $0xff,%al
  100e84:	0f 95 c0             	setne  %al
  100e87:	0f b6 c0             	movzbl %al,%eax
  100e8a:	a3 68 fe 10 00       	mov    %eax,0x10fe68
  100e8f:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e95:	66 8b 45 f2          	mov    -0xe(%ebp),%ax
  100e99:	89 c2                	mov    %eax,%edx
  100e9b:	ec                   	in     (%dx),%al
  100e9c:	88 45 f1             	mov    %al,-0xf(%ebp)
  100e9f:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  100ea5:	66 8b 45 f6          	mov    -0xa(%ebp),%ax
  100ea9:	89 c2                	mov    %eax,%edx
  100eab:	ec                   	in     (%dx),%al
  100eac:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100eaf:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  100eb4:	85 c0                	test   %eax,%eax
  100eb6:	74 0d                	je     100ec5 <serial_init+0xda>
        pic_enable(IRQ_COM1);
  100eb8:	83 ec 0c             	sub    $0xc,%esp
  100ebb:	6a 04                	push   $0x4
  100ebd:	e8 83 06 00 00       	call   101545 <pic_enable>
  100ec2:	83 c4 10             	add    $0x10,%esp
    }
}
  100ec5:	90                   	nop
  100ec6:	c9                   	leave  
  100ec7:	c3                   	ret    

00100ec8 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100ec8:	55                   	push   %ebp
  100ec9:	89 e5                	mov    %esp,%ebp
  100ecb:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100ece:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100ed5:	eb 08                	jmp    100edf <lpt_putc_sub+0x17>
        delay();
  100ed7:	e8 eb fd ff ff       	call   100cc7 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100edc:	ff 45 fc             	incl   -0x4(%ebp)
  100edf:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100ee5:	66 8b 45 fa          	mov    -0x6(%ebp),%ax
  100ee9:	89 c2                	mov    %eax,%edx
  100eeb:	ec                   	in     (%dx),%al
  100eec:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100eef:	8a 45 f9             	mov    -0x7(%ebp),%al
  100ef2:	84 c0                	test   %al,%al
  100ef4:	78 09                	js     100eff <lpt_putc_sub+0x37>
  100ef6:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100efd:	7e d8                	jle    100ed7 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  100eff:	8b 45 08             	mov    0x8(%ebp),%eax
  100f02:	0f b6 c0             	movzbl %al,%eax
  100f05:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  100f0b:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f0e:	8a 45 ed             	mov    -0x13(%ebp),%al
  100f11:	66 8b 55 ee          	mov    -0x12(%ebp),%dx
  100f15:	ee                   	out    %al,(%dx)
  100f16:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  100f1c:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  100f20:	8a 45 f1             	mov    -0xf(%ebp),%al
  100f23:	66 8b 55 f2          	mov    -0xe(%ebp),%dx
  100f27:	ee                   	out    %al,(%dx)
  100f28:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  100f2e:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
  100f32:	8a 45 f5             	mov    -0xb(%ebp),%al
  100f35:	66 8b 55 f6          	mov    -0xa(%ebp),%dx
  100f39:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  100f3a:	90                   	nop
  100f3b:	c9                   	leave  
  100f3c:	c3                   	ret    

00100f3d <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  100f3d:	55                   	push   %ebp
  100f3e:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  100f40:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  100f44:	74 0d                	je     100f53 <lpt_putc+0x16>
        lpt_putc_sub(c);
  100f46:	ff 75 08             	pushl  0x8(%ebp)
  100f49:	e8 7a ff ff ff       	call   100ec8 <lpt_putc_sub>
  100f4e:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  100f51:	eb 1e                	jmp    100f71 <lpt_putc+0x34>
        lpt_putc_sub('\b');
  100f53:	6a 08                	push   $0x8
  100f55:	e8 6e ff ff ff       	call   100ec8 <lpt_putc_sub>
  100f5a:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  100f5d:	6a 20                	push   $0x20
  100f5f:	e8 64 ff ff ff       	call   100ec8 <lpt_putc_sub>
  100f64:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  100f67:	6a 08                	push   $0x8
  100f69:	e8 5a ff ff ff       	call   100ec8 <lpt_putc_sub>
  100f6e:	83 c4 04             	add    $0x4,%esp
}
  100f71:	90                   	nop
  100f72:	c9                   	leave  
  100f73:	c3                   	ret    

00100f74 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  100f74:	55                   	push   %ebp
  100f75:	89 e5                	mov    %esp,%ebp
  100f77:	53                   	push   %ebx
  100f78:	83 ec 24             	sub    $0x24,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  100f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  100f7e:	b0 00                	mov    $0x0,%al
  100f80:	85 c0                	test   %eax,%eax
  100f82:	75 07                	jne    100f8b <cga_putc+0x17>
        c |= 0x0700;
  100f84:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  100f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  100f8e:	0f b6 c0             	movzbl %al,%eax
  100f91:	83 f8 0a             	cmp    $0xa,%eax
  100f94:	74 4a                	je     100fe0 <cga_putc+0x6c>
  100f96:	83 f8 0d             	cmp    $0xd,%eax
  100f99:	74 54                	je     100fef <cga_putc+0x7b>
  100f9b:	83 f8 08             	cmp    $0x8,%eax
  100f9e:	75 77                	jne    101017 <cga_putc+0xa3>
    case '\b':
        if (crt_pos > 0) {
  100fa0:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  100fa6:	66 85 c0             	test   %ax,%ax
  100fa9:	0f 84 8e 00 00 00    	je     10103d <cga_putc+0xc9>
            crt_pos --;
  100faf:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  100fb5:	48                   	dec    %eax
  100fb6:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  100fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  100fbf:	b0 00                	mov    $0x0,%al
  100fc1:	83 c8 20             	or     $0x20,%eax
  100fc4:	89 c2                	mov    %eax,%edx
  100fc6:	8b 0d 60 fe 10 00    	mov    0x10fe60,%ecx
  100fcc:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  100fd2:	0f b7 c0             	movzwl %ax,%eax
  100fd5:	01 c0                	add    %eax,%eax
  100fd7:	01 c1                	add    %eax,%ecx
  100fd9:	89 d0                	mov    %edx,%eax
  100fdb:	66 89 01             	mov    %ax,(%ecx)
        }
        break;
  100fde:	eb 5d                	jmp    10103d <cga_putc+0xc9>
    case '\n':
        crt_pos += CRT_COLS;
  100fe0:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  100fe6:	83 c0 50             	add    $0x50,%eax
  100fe9:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  100fef:	66 8b 0d 64 fe 10 00 	mov    0x10fe64,%cx
  100ff6:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  100ffc:	bb 50 00 00 00       	mov    $0x50,%ebx
  101001:	ba 00 00 00 00       	mov    $0x0,%edx
  101006:	66 f7 f3             	div    %bx
  101009:	89 d0                	mov    %edx,%eax
  10100b:	29 c1                	sub    %eax,%ecx
  10100d:	89 c8                	mov    %ecx,%eax
  10100f:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
        break;
  101015:	eb 27                	jmp    10103e <cga_putc+0xca>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101017:	8b 0d 60 fe 10 00    	mov    0x10fe60,%ecx
  10101d:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  101023:	8d 50 01             	lea    0x1(%eax),%edx
  101026:	66 89 15 64 fe 10 00 	mov    %dx,0x10fe64
  10102d:	0f b7 c0             	movzwl %ax,%eax
  101030:	01 c0                	add    %eax,%eax
  101032:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101035:	8b 45 08             	mov    0x8(%ebp),%eax
  101038:	66 89 02             	mov    %ax,(%edx)
        break;
  10103b:	eb 01                	jmp    10103e <cga_putc+0xca>
        break;
  10103d:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  10103e:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  101044:	66 3d cf 07          	cmp    $0x7cf,%ax
  101048:	76 58                	jbe    1010a2 <cga_putc+0x12e>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10104a:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  10104f:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101055:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  10105a:	83 ec 04             	sub    $0x4,%esp
  10105d:	68 00 0f 00 00       	push   $0xf00
  101062:	52                   	push   %edx
  101063:	50                   	push   %eax
  101064:	e8 1e 1f 00 00       	call   102f87 <memmove>
  101069:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10106c:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101073:	eb 15                	jmp    10108a <cga_putc+0x116>
            crt_buf[i] = 0x0700 | ' ';
  101075:	8b 15 60 fe 10 00    	mov    0x10fe60,%edx
  10107b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10107e:	01 c0                	add    %eax,%eax
  101080:	01 d0                	add    %edx,%eax
  101082:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101087:	ff 45 f4             	incl   -0xc(%ebp)
  10108a:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101091:	7e e2                	jle    101075 <cga_putc+0x101>
        }
        crt_pos -= CRT_COLS;
  101093:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  101099:	83 e8 50             	sub    $0x50,%eax
  10109c:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1010a2:	66 a1 66 fe 10 00    	mov    0x10fe66,%ax
  1010a8:	0f b7 c0             	movzwl %ax,%eax
  1010ab:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  1010af:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
  1010b3:	8a 45 e5             	mov    -0x1b(%ebp),%al
  1010b6:	66 8b 55 e6          	mov    -0x1a(%ebp),%dx
  1010ba:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1010bb:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  1010c1:	66 c1 e8 08          	shr    $0x8,%ax
  1010c5:	0f b6 d0             	movzbl %al,%edx
  1010c8:	66 a1 66 fe 10 00    	mov    0x10fe66,%ax
  1010ce:	40                   	inc    %eax
  1010cf:	0f b7 c0             	movzwl %ax,%eax
  1010d2:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  1010d6:	88 55 e9             	mov    %dl,-0x17(%ebp)
  1010d9:	8a 45 e9             	mov    -0x17(%ebp),%al
  1010dc:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
  1010e0:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  1010e1:	66 a1 66 fe 10 00    	mov    0x10fe66,%ax
  1010e7:	0f b7 c0             	movzwl %ax,%eax
  1010ea:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  1010ee:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
  1010f2:	8a 45 ed             	mov    -0x13(%ebp),%al
  1010f5:	66 8b 55 ee          	mov    -0x12(%ebp),%dx
  1010f9:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  1010fa:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  101100:	0f b6 d0             	movzbl %al,%edx
  101103:	66 a1 66 fe 10 00    	mov    0x10fe66,%ax
  101109:	40                   	inc    %eax
  10110a:	0f b7 c0             	movzwl %ax,%eax
  10110d:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  101111:	88 55 f1             	mov    %dl,-0xf(%ebp)
  101114:	8a 45 f1             	mov    -0xf(%ebp),%al
  101117:	66 8b 55 f2          	mov    -0xe(%ebp),%dx
  10111b:	ee                   	out    %al,(%dx)
}
  10111c:	90                   	nop
  10111d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101120:	c9                   	leave  
  101121:	c3                   	ret    

00101122 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101122:	55                   	push   %ebp
  101123:	89 e5                	mov    %esp,%ebp
  101125:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101128:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10112f:	eb 08                	jmp    101139 <serial_putc_sub+0x17>
        delay();
  101131:	e8 91 fb ff ff       	call   100cc7 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101136:	ff 45 fc             	incl   -0x4(%ebp)
  101139:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10113f:	66 8b 45 fa          	mov    -0x6(%ebp),%ax
  101143:	89 c2                	mov    %eax,%edx
  101145:	ec                   	in     (%dx),%al
  101146:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101149:	8a 45 f9             	mov    -0x7(%ebp),%al
  10114c:	0f b6 c0             	movzbl %al,%eax
  10114f:	83 e0 20             	and    $0x20,%eax
  101152:	85 c0                	test   %eax,%eax
  101154:	75 09                	jne    10115f <serial_putc_sub+0x3d>
  101156:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10115d:	7e d2                	jle    101131 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  10115f:	8b 45 08             	mov    0x8(%ebp),%eax
  101162:	0f b6 c0             	movzbl %al,%eax
  101165:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10116b:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10116e:	8a 45 f5             	mov    -0xb(%ebp),%al
  101171:	66 8b 55 f6          	mov    -0xa(%ebp),%dx
  101175:	ee                   	out    %al,(%dx)
}
  101176:	90                   	nop
  101177:	c9                   	leave  
  101178:	c3                   	ret    

00101179 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101179:	55                   	push   %ebp
  10117a:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  10117c:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101180:	74 0d                	je     10118f <serial_putc+0x16>
        serial_putc_sub(c);
  101182:	ff 75 08             	pushl  0x8(%ebp)
  101185:	e8 98 ff ff ff       	call   101122 <serial_putc_sub>
  10118a:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  10118d:	eb 1e                	jmp    1011ad <serial_putc+0x34>
        serial_putc_sub('\b');
  10118f:	6a 08                	push   $0x8
  101191:	e8 8c ff ff ff       	call   101122 <serial_putc_sub>
  101196:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  101199:	6a 20                	push   $0x20
  10119b:	e8 82 ff ff ff       	call   101122 <serial_putc_sub>
  1011a0:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  1011a3:	6a 08                	push   $0x8
  1011a5:	e8 78 ff ff ff       	call   101122 <serial_putc_sub>
  1011aa:	83 c4 04             	add    $0x4,%esp
}
  1011ad:	90                   	nop
  1011ae:	c9                   	leave  
  1011af:	c3                   	ret    

001011b0 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1011b0:	55                   	push   %ebp
  1011b1:	89 e5                	mov    %esp,%ebp
  1011b3:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1011b6:	eb 33                	jmp    1011eb <cons_intr+0x3b>
        if (c != 0) {
  1011b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1011bc:	74 2d                	je     1011eb <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1011be:	a1 84 00 11 00       	mov    0x110084,%eax
  1011c3:	8d 50 01             	lea    0x1(%eax),%edx
  1011c6:	89 15 84 00 11 00    	mov    %edx,0x110084
  1011cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011cf:	88 90 80 fe 10 00    	mov    %dl,0x10fe80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1011d5:	a1 84 00 11 00       	mov    0x110084,%eax
  1011da:	3d 00 02 00 00       	cmp    $0x200,%eax
  1011df:	75 0a                	jne    1011eb <cons_intr+0x3b>
                cons.wpos = 0;
  1011e1:	c7 05 84 00 11 00 00 	movl   $0x0,0x110084
  1011e8:	00 00 00 
    while ((c = (*proc)()) != -1) {
  1011eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1011ee:	ff d0                	call   *%eax
  1011f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1011f3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1011f7:	75 bf                	jne    1011b8 <cons_intr+0x8>
            }
        }
    }
}
  1011f9:	90                   	nop
  1011fa:	c9                   	leave  
  1011fb:	c3                   	ret    

001011fc <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1011fc:	55                   	push   %ebp
  1011fd:	89 e5                	mov    %esp,%ebp
  1011ff:	83 ec 10             	sub    $0x10,%esp
  101202:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101208:	66 8b 45 fa          	mov    -0x6(%ebp),%ax
  10120c:	89 c2                	mov    %eax,%edx
  10120e:	ec                   	in     (%dx),%al
  10120f:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101212:	8a 45 f9             	mov    -0x7(%ebp),%al
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101215:	0f b6 c0             	movzbl %al,%eax
  101218:	83 e0 01             	and    $0x1,%eax
  10121b:	85 c0                	test   %eax,%eax
  10121d:	75 07                	jne    101226 <serial_proc_data+0x2a>
        return -1;
  10121f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101224:	eb 29                	jmp    10124f <serial_proc_data+0x53>
  101226:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10122c:	66 8b 45 f6          	mov    -0xa(%ebp),%ax
  101230:	89 c2                	mov    %eax,%edx
  101232:	ec                   	in     (%dx),%al
  101233:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101236:	8a 45 f5             	mov    -0xb(%ebp),%al
    }
    int c = inb(COM1 + COM_RX);
  101239:	0f b6 c0             	movzbl %al,%eax
  10123c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  10123f:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101243:	75 07                	jne    10124c <serial_proc_data+0x50>
        c = '\b';
  101245:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10124c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10124f:	c9                   	leave  
  101250:	c3                   	ret    

00101251 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101251:	55                   	push   %ebp
  101252:	89 e5                	mov    %esp,%ebp
  101254:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
  101257:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  10125c:	85 c0                	test   %eax,%eax
  10125e:	74 10                	je     101270 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  101260:	83 ec 0c             	sub    $0xc,%esp
  101263:	68 fc 11 10 00       	push   $0x1011fc
  101268:	e8 43 ff ff ff       	call   1011b0 <cons_intr>
  10126d:	83 c4 10             	add    $0x10,%esp
    }
}
  101270:	90                   	nop
  101271:	c9                   	leave  
  101272:	c3                   	ret    

00101273 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101273:	55                   	push   %ebp
  101274:	89 e5                	mov    %esp,%ebp
  101276:	83 ec 28             	sub    $0x28,%esp
  101279:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10127f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101282:	89 c2                	mov    %eax,%edx
  101284:	ec                   	in     (%dx),%al
  101285:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101288:	8a 45 ef             	mov    -0x11(%ebp),%al
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  10128b:	0f b6 c0             	movzbl %al,%eax
  10128e:	83 e0 01             	and    $0x1,%eax
  101291:	85 c0                	test   %eax,%eax
  101293:	75 0a                	jne    10129f <kbd_proc_data+0x2c>
        return -1;
  101295:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10129a:	e9 52 01 00 00       	jmp    1013f1 <kbd_proc_data+0x17e>
  10129f:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1012a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1012a8:	89 c2                	mov    %eax,%edx
  1012aa:	ec                   	in     (%dx),%al
  1012ab:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1012ae:	8a 45 eb             	mov    -0x15(%ebp),%al
    }

    data = inb(KBDATAP);
  1012b1:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1012b4:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1012b8:	75 17                	jne    1012d1 <kbd_proc_data+0x5e>
        // E0 escape character
        shift |= E0ESC;
  1012ba:	a1 88 00 11 00       	mov    0x110088,%eax
  1012bf:	83 c8 40             	or     $0x40,%eax
  1012c2:	a3 88 00 11 00       	mov    %eax,0x110088
        return 0;
  1012c7:	b8 00 00 00 00       	mov    $0x0,%eax
  1012cc:	e9 20 01 00 00       	jmp    1013f1 <kbd_proc_data+0x17e>
    } else if (data & 0x80) {
  1012d1:	8a 45 f3             	mov    -0xd(%ebp),%al
  1012d4:	84 c0                	test   %al,%al
  1012d6:	79 44                	jns    10131c <kbd_proc_data+0xa9>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1012d8:	a1 88 00 11 00       	mov    0x110088,%eax
  1012dd:	83 e0 40             	and    $0x40,%eax
  1012e0:	85 c0                	test   %eax,%eax
  1012e2:	75 08                	jne    1012ec <kbd_proc_data+0x79>
  1012e4:	8a 45 f3             	mov    -0xd(%ebp),%al
  1012e7:	83 e0 7f             	and    $0x7f,%eax
  1012ea:	eb 03                	jmp    1012ef <kbd_proc_data+0x7c>
  1012ec:	8a 45 f3             	mov    -0xd(%ebp),%al
  1012ef:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1012f2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1012f6:	8a 80 40 f0 10 00    	mov    0x10f040(%eax),%al
  1012fc:	83 c8 40             	or     $0x40,%eax
  1012ff:	0f b6 c0             	movzbl %al,%eax
  101302:	f7 d0                	not    %eax
  101304:	89 c2                	mov    %eax,%edx
  101306:	a1 88 00 11 00       	mov    0x110088,%eax
  10130b:	21 d0                	and    %edx,%eax
  10130d:	a3 88 00 11 00       	mov    %eax,0x110088
        return 0;
  101312:	b8 00 00 00 00       	mov    $0x0,%eax
  101317:	e9 d5 00 00 00       	jmp    1013f1 <kbd_proc_data+0x17e>
    } else if (shift & E0ESC) {
  10131c:	a1 88 00 11 00       	mov    0x110088,%eax
  101321:	83 e0 40             	and    $0x40,%eax
  101324:	85 c0                	test   %eax,%eax
  101326:	74 11                	je     101339 <kbd_proc_data+0xc6>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101328:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10132c:	a1 88 00 11 00       	mov    0x110088,%eax
  101331:	83 e0 bf             	and    $0xffffffbf,%eax
  101334:	a3 88 00 11 00       	mov    %eax,0x110088
    }

    shift |= shiftcode[data];
  101339:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10133d:	8a 80 40 f0 10 00    	mov    0x10f040(%eax),%al
  101343:	0f b6 d0             	movzbl %al,%edx
  101346:	a1 88 00 11 00       	mov    0x110088,%eax
  10134b:	09 d0                	or     %edx,%eax
  10134d:	a3 88 00 11 00       	mov    %eax,0x110088
    shift ^= togglecode[data];
  101352:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101356:	8a 80 40 f1 10 00    	mov    0x10f140(%eax),%al
  10135c:	0f b6 d0             	movzbl %al,%edx
  10135f:	a1 88 00 11 00       	mov    0x110088,%eax
  101364:	31 d0                	xor    %edx,%eax
  101366:	a3 88 00 11 00       	mov    %eax,0x110088

    c = charcode[shift & (CTL | SHIFT)][data];
  10136b:	a1 88 00 11 00       	mov    0x110088,%eax
  101370:	83 e0 03             	and    $0x3,%eax
  101373:	8b 14 85 40 f5 10 00 	mov    0x10f540(,%eax,4),%edx
  10137a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10137e:	01 d0                	add    %edx,%eax
  101380:	8a 00                	mov    (%eax),%al
  101382:	0f b6 c0             	movzbl %al,%eax
  101385:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101388:	a1 88 00 11 00       	mov    0x110088,%eax
  10138d:	83 e0 08             	and    $0x8,%eax
  101390:	85 c0                	test   %eax,%eax
  101392:	74 22                	je     1013b6 <kbd_proc_data+0x143>
        if ('a' <= c && c <= 'z')
  101394:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101398:	7e 0c                	jle    1013a6 <kbd_proc_data+0x133>
  10139a:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  10139e:	7f 06                	jg     1013a6 <kbd_proc_data+0x133>
            c += 'A' - 'a';
  1013a0:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1013a4:	eb 10                	jmp    1013b6 <kbd_proc_data+0x143>
        else if ('A' <= c && c <= 'Z')
  1013a6:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1013aa:	7e 0a                	jle    1013b6 <kbd_proc_data+0x143>
  1013ac:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1013b0:	7f 04                	jg     1013b6 <kbd_proc_data+0x143>
            c += 'a' - 'A';
  1013b2:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1013b6:	a1 88 00 11 00       	mov    0x110088,%eax
  1013bb:	f7 d0                	not    %eax
  1013bd:	83 e0 06             	and    $0x6,%eax
  1013c0:	85 c0                	test   %eax,%eax
  1013c2:	75 2a                	jne    1013ee <kbd_proc_data+0x17b>
  1013c4:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1013cb:	75 21                	jne    1013ee <kbd_proc_data+0x17b>
        cprintf("Rebooting!\n");
  1013cd:	83 ec 0c             	sub    $0xc,%esp
  1013d0:	68 e7 33 10 00       	push   $0x1033e7
  1013d5:	e8 1c ef ff ff       	call   1002f6 <cprintf>
  1013da:	83 c4 10             	add    $0x10,%esp
  1013dd:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1013e3:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1013e7:	8a 45 e7             	mov    -0x19(%ebp),%al
  1013ea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1013ed:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1013ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1013f1:	c9                   	leave  
  1013f2:	c3                   	ret    

001013f3 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1013f3:	55                   	push   %ebp
  1013f4:	89 e5                	mov    %esp,%ebp
  1013f6:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
  1013f9:	83 ec 0c             	sub    $0xc,%esp
  1013fc:	68 73 12 10 00       	push   $0x101273
  101401:	e8 aa fd ff ff       	call   1011b0 <cons_intr>
  101406:	83 c4 10             	add    $0x10,%esp
}
  101409:	90                   	nop
  10140a:	c9                   	leave  
  10140b:	c3                   	ret    

0010140c <kbd_init>:

static void
kbd_init(void) {
  10140c:	55                   	push   %ebp
  10140d:	89 e5                	mov    %esp,%ebp
  10140f:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
  101412:	e8 dc ff ff ff       	call   1013f3 <kbd_intr>
    pic_enable(IRQ_KBD);
  101417:	83 ec 0c             	sub    $0xc,%esp
  10141a:	6a 01                	push   $0x1
  10141c:	e8 24 01 00 00       	call   101545 <pic_enable>
  101421:	83 c4 10             	add    $0x10,%esp
}
  101424:	90                   	nop
  101425:	c9                   	leave  
  101426:	c3                   	ret    

00101427 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101427:	55                   	push   %ebp
  101428:	89 e5                	mov    %esp,%ebp
  10142a:	83 ec 08             	sub    $0x8,%esp
    cga_init();
  10142d:	e8 de f8 ff ff       	call   100d10 <cga_init>
    serial_init();
  101432:	e8 b4 f9 ff ff       	call   100deb <serial_init>
    kbd_init();
  101437:	e8 d0 ff ff ff       	call   10140c <kbd_init>
    if (!serial_exists) {
  10143c:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  101441:	85 c0                	test   %eax,%eax
  101443:	75 10                	jne    101455 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  101445:	83 ec 0c             	sub    $0xc,%esp
  101448:	68 f3 33 10 00       	push   $0x1033f3
  10144d:	e8 a4 ee ff ff       	call   1002f6 <cprintf>
  101452:	83 c4 10             	add    $0x10,%esp
    }
}
  101455:	90                   	nop
  101456:	c9                   	leave  
  101457:	c3                   	ret    

00101458 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101458:	55                   	push   %ebp
  101459:	89 e5                	mov    %esp,%ebp
  10145b:	83 ec 08             	sub    $0x8,%esp
    lpt_putc(c);
  10145e:	ff 75 08             	pushl  0x8(%ebp)
  101461:	e8 d7 fa ff ff       	call   100f3d <lpt_putc>
  101466:	83 c4 04             	add    $0x4,%esp
    cga_putc(c);
  101469:	83 ec 0c             	sub    $0xc,%esp
  10146c:	ff 75 08             	pushl  0x8(%ebp)
  10146f:	e8 00 fb ff ff       	call   100f74 <cga_putc>
  101474:	83 c4 10             	add    $0x10,%esp
    serial_putc(c);
  101477:	83 ec 0c             	sub    $0xc,%esp
  10147a:	ff 75 08             	pushl  0x8(%ebp)
  10147d:	e8 f7 fc ff ff       	call   101179 <serial_putc>
  101482:	83 c4 10             	add    $0x10,%esp
}
  101485:	90                   	nop
  101486:	c9                   	leave  
  101487:	c3                   	ret    

00101488 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101488:	55                   	push   %ebp
  101489:	89 e5                	mov    %esp,%ebp
  10148b:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  10148e:	e8 be fd ff ff       	call   101251 <serial_intr>
    kbd_intr();
  101493:	e8 5b ff ff ff       	call   1013f3 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  101498:	8b 15 80 00 11 00    	mov    0x110080,%edx
  10149e:	a1 84 00 11 00       	mov    0x110084,%eax
  1014a3:	39 c2                	cmp    %eax,%edx
  1014a5:	74 35                	je     1014dc <cons_getc+0x54>
        c = cons.buf[cons.rpos ++];
  1014a7:	a1 80 00 11 00       	mov    0x110080,%eax
  1014ac:	8d 50 01             	lea    0x1(%eax),%edx
  1014af:	89 15 80 00 11 00    	mov    %edx,0x110080
  1014b5:	8a 80 80 fe 10 00    	mov    0x10fe80(%eax),%al
  1014bb:	0f b6 c0             	movzbl %al,%eax
  1014be:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1014c1:	a1 80 00 11 00       	mov    0x110080,%eax
  1014c6:	3d 00 02 00 00       	cmp    $0x200,%eax
  1014cb:	75 0a                	jne    1014d7 <cons_getc+0x4f>
            cons.rpos = 0;
  1014cd:	c7 05 80 00 11 00 00 	movl   $0x0,0x110080
  1014d4:	00 00 00 
        }
        return c;
  1014d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1014da:	eb 05                	jmp    1014e1 <cons_getc+0x59>
    }
    return 0;
  1014dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1014e1:	c9                   	leave  
  1014e2:	c3                   	ret    

001014e3 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1014e3:	55                   	push   %ebp
  1014e4:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1014e6:	fb                   	sti    
    sti();
}
  1014e7:	90                   	nop
  1014e8:	5d                   	pop    %ebp
  1014e9:	c3                   	ret    

001014ea <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1014ea:	55                   	push   %ebp
  1014eb:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  1014ed:	fa                   	cli    
    cli();
}
  1014ee:	90                   	nop
  1014ef:	5d                   	pop    %ebp
  1014f0:	c3                   	ret    

001014f1 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1014f1:	55                   	push   %ebp
  1014f2:	89 e5                	mov    %esp,%ebp
  1014f4:	83 ec 14             	sub    $0x14,%esp
  1014f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1014fa:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1014fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101501:	66 a3 50 f5 10 00    	mov    %ax,0x10f550
    if (did_init) {
  101507:	a1 8c 00 11 00       	mov    0x11008c,%eax
  10150c:	85 c0                	test   %eax,%eax
  10150e:	74 32                	je     101542 <pic_setmask+0x51>
        outb(IO_PIC1 + 1, mask);
  101510:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101513:	0f b6 c0             	movzbl %al,%eax
  101516:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  10151c:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10151f:	8a 45 f9             	mov    -0x7(%ebp),%al
  101522:	66 8b 55 fa          	mov    -0x6(%ebp),%dx
  101526:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101527:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10152a:	66 c1 e8 08          	shr    $0x8,%ax
  10152e:	0f b6 c0             	movzbl %al,%eax
  101531:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101537:	88 45 fd             	mov    %al,-0x3(%ebp)
  10153a:	8a 45 fd             	mov    -0x3(%ebp),%al
  10153d:	66 8b 55 fe          	mov    -0x2(%ebp),%dx
  101541:	ee                   	out    %al,(%dx)
    }
}
  101542:	90                   	nop
  101543:	c9                   	leave  
  101544:	c3                   	ret    

00101545 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101545:	55                   	push   %ebp
  101546:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  101548:	8b 45 08             	mov    0x8(%ebp),%eax
  10154b:	ba 01 00 00 00       	mov    $0x1,%edx
  101550:	88 c1                	mov    %al,%cl
  101552:	d3 e2                	shl    %cl,%edx
  101554:	89 d0                	mov    %edx,%eax
  101556:	f7 d0                	not    %eax
  101558:	89 c2                	mov    %eax,%edx
  10155a:	66 a1 50 f5 10 00    	mov    0x10f550,%ax
  101560:	21 d0                	and    %edx,%eax
  101562:	0f b7 c0             	movzwl %ax,%eax
  101565:	50                   	push   %eax
  101566:	e8 86 ff ff ff       	call   1014f1 <pic_setmask>
  10156b:	83 c4 04             	add    $0x4,%esp
}
  10156e:	90                   	nop
  10156f:	c9                   	leave  
  101570:	c3                   	ret    

00101571 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101571:	55                   	push   %ebp
  101572:	89 e5                	mov    %esp,%ebp
  101574:	83 ec 40             	sub    $0x40,%esp
    did_init = 1;
  101577:	c7 05 8c 00 11 00 01 	movl   $0x1,0x11008c
  10157e:	00 00 00 
  101581:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  101587:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
  10158b:	8a 45 c9             	mov    -0x37(%ebp),%al
  10158e:	66 8b 55 ca          	mov    -0x36(%ebp),%dx
  101592:	ee                   	out    %al,(%dx)
  101593:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  101599:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
  10159d:	8a 45 cd             	mov    -0x33(%ebp),%al
  1015a0:	66 8b 55 ce          	mov    -0x32(%ebp),%dx
  1015a4:	ee                   	out    %al,(%dx)
  1015a5:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1015ab:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
  1015af:	8a 45 d1             	mov    -0x2f(%ebp),%al
  1015b2:	66 8b 55 d2          	mov    -0x2e(%ebp),%dx
  1015b6:	ee                   	out    %al,(%dx)
  1015b7:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  1015bd:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
  1015c1:	8a 45 d5             	mov    -0x2b(%ebp),%al
  1015c4:	66 8b 55 d6          	mov    -0x2a(%ebp),%dx
  1015c8:	ee                   	out    %al,(%dx)
  1015c9:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  1015cf:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
  1015d3:	8a 45 d9             	mov    -0x27(%ebp),%al
  1015d6:	66 8b 55 da          	mov    -0x26(%ebp),%dx
  1015da:	ee                   	out    %al,(%dx)
  1015db:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  1015e1:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
  1015e5:	8a 45 dd             	mov    -0x23(%ebp),%al
  1015e8:	66 8b 55 de          	mov    -0x22(%ebp),%dx
  1015ec:	ee                   	out    %al,(%dx)
  1015ed:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  1015f3:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
  1015f7:	8a 45 e1             	mov    -0x1f(%ebp),%al
  1015fa:	66 8b 55 e2          	mov    -0x1e(%ebp),%dx
  1015fe:	ee                   	out    %al,(%dx)
  1015ff:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  101605:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
  101609:	8a 45 e5             	mov    -0x1b(%ebp),%al
  10160c:	66 8b 55 e6          	mov    -0x1a(%ebp),%dx
  101610:	ee                   	out    %al,(%dx)
  101611:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101617:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
  10161b:	8a 45 e9             	mov    -0x17(%ebp),%al
  10161e:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
  101622:	ee                   	out    %al,(%dx)
  101623:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  101629:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
  10162d:	8a 45 ed             	mov    -0x13(%ebp),%al
  101630:	66 8b 55 ee          	mov    -0x12(%ebp),%dx
  101634:	ee                   	out    %al,(%dx)
  101635:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  10163b:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
  10163f:	8a 45 f1             	mov    -0xf(%ebp),%al
  101642:	66 8b 55 f2          	mov    -0xe(%ebp),%dx
  101646:	ee                   	out    %al,(%dx)
  101647:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  10164d:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
  101651:	8a 45 f5             	mov    -0xb(%ebp),%al
  101654:	66 8b 55 f6          	mov    -0xa(%ebp),%dx
  101658:	ee                   	out    %al,(%dx)
  101659:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  10165f:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
  101663:	8a 45 f9             	mov    -0x7(%ebp),%al
  101666:	66 8b 55 fa          	mov    -0x6(%ebp),%dx
  10166a:	ee                   	out    %al,(%dx)
  10166b:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  101671:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
  101675:	8a 45 fd             	mov    -0x3(%ebp),%al
  101678:	66 8b 55 fe          	mov    -0x2(%ebp),%dx
  10167c:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  10167d:	66 a1 50 f5 10 00    	mov    0x10f550,%ax
  101683:	66 83 f8 ff          	cmp    $0xffff,%ax
  101687:	74 12                	je     10169b <pic_init+0x12a>
        pic_setmask(irq_mask);
  101689:	66 a1 50 f5 10 00    	mov    0x10f550,%ax
  10168f:	0f b7 c0             	movzwl %ax,%eax
  101692:	50                   	push   %eax
  101693:	e8 59 fe ff ff       	call   1014f1 <pic_setmask>
  101698:	83 c4 04             	add    $0x4,%esp
    }
}
  10169b:	90                   	nop
  10169c:	c9                   	leave  
  10169d:	c3                   	ret    

0010169e <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  10169e:	55                   	push   %ebp
  10169f:	89 e5                	mov    %esp,%ebp
  1016a1:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1016a4:	83 ec 08             	sub    $0x8,%esp
  1016a7:	6a 64                	push   $0x64
  1016a9:	68 20 34 10 00       	push   $0x103420
  1016ae:	e8 43 ec ff ff       	call   1002f6 <cprintf>
  1016b3:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  1016b6:	90                   	nop
  1016b7:	c9                   	leave  
  1016b8:	c3                   	ret    

001016b9 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1016b9:	55                   	push   %ebp
  1016ba:	89 e5                	mov    %esp,%ebp
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
  1016bc:	90                   	nop
  1016bd:	5d                   	pop    %ebp
  1016be:	c3                   	ret    

001016bf <trapname>:

static const char *
trapname(int trapno) {
  1016bf:	55                   	push   %ebp
  1016c0:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1016c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1016c5:	83 f8 13             	cmp    $0x13,%eax
  1016c8:	77 0c                	ja     1016d6 <trapname+0x17>
        return excnames[trapno];
  1016ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1016cd:	8b 04 85 80 37 10 00 	mov    0x103780(,%eax,4),%eax
  1016d4:	eb 18                	jmp    1016ee <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1016d6:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1016da:	7e 0d                	jle    1016e9 <trapname+0x2a>
  1016dc:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1016e0:	7f 07                	jg     1016e9 <trapname+0x2a>
        return "Hardware Interrupt";
  1016e2:	b8 2a 34 10 00       	mov    $0x10342a,%eax
  1016e7:	eb 05                	jmp    1016ee <trapname+0x2f>
    }
    return "(unknown trap)";
  1016e9:	b8 3d 34 10 00       	mov    $0x10343d,%eax
}
  1016ee:	5d                   	pop    %ebp
  1016ef:	c3                   	ret    

001016f0 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1016f0:	55                   	push   %ebp
  1016f1:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1016f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1016f6:	66 8b 40 3c          	mov    0x3c(%eax),%ax
  1016fa:	66 83 f8 08          	cmp    $0x8,%ax
  1016fe:	0f 94 c0             	sete   %al
  101701:	0f b6 c0             	movzbl %al,%eax
}
  101704:	5d                   	pop    %ebp
  101705:	c3                   	ret    

00101706 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101706:	55                   	push   %ebp
  101707:	89 e5                	mov    %esp,%ebp
  101709:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
  10170c:	83 ec 08             	sub    $0x8,%esp
  10170f:	ff 75 08             	pushl  0x8(%ebp)
  101712:	68 7e 34 10 00       	push   $0x10347e
  101717:	e8 da eb ff ff       	call   1002f6 <cprintf>
  10171c:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  10171f:	8b 45 08             	mov    0x8(%ebp),%eax
  101722:	83 ec 0c             	sub    $0xc,%esp
  101725:	50                   	push   %eax
  101726:	e8 ba 01 00 00       	call   1018e5 <print_regs>
  10172b:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  10172e:	8b 45 08             	mov    0x8(%ebp),%eax
  101731:	66 8b 40 2c          	mov    0x2c(%eax),%ax
  101735:	0f b7 c0             	movzwl %ax,%eax
  101738:	83 ec 08             	sub    $0x8,%esp
  10173b:	50                   	push   %eax
  10173c:	68 8f 34 10 00       	push   $0x10348f
  101741:	e8 b0 eb ff ff       	call   1002f6 <cprintf>
  101746:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101749:	8b 45 08             	mov    0x8(%ebp),%eax
  10174c:	66 8b 40 28          	mov    0x28(%eax),%ax
  101750:	0f b7 c0             	movzwl %ax,%eax
  101753:	83 ec 08             	sub    $0x8,%esp
  101756:	50                   	push   %eax
  101757:	68 a2 34 10 00       	push   $0x1034a2
  10175c:	e8 95 eb ff ff       	call   1002f6 <cprintf>
  101761:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101764:	8b 45 08             	mov    0x8(%ebp),%eax
  101767:	66 8b 40 24          	mov    0x24(%eax),%ax
  10176b:	0f b7 c0             	movzwl %ax,%eax
  10176e:	83 ec 08             	sub    $0x8,%esp
  101771:	50                   	push   %eax
  101772:	68 b5 34 10 00       	push   $0x1034b5
  101777:	e8 7a eb ff ff       	call   1002f6 <cprintf>
  10177c:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  10177f:	8b 45 08             	mov    0x8(%ebp),%eax
  101782:	66 8b 40 20          	mov    0x20(%eax),%ax
  101786:	0f b7 c0             	movzwl %ax,%eax
  101789:	83 ec 08             	sub    $0x8,%esp
  10178c:	50                   	push   %eax
  10178d:	68 c8 34 10 00       	push   $0x1034c8
  101792:	e8 5f eb ff ff       	call   1002f6 <cprintf>
  101797:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  10179a:	8b 45 08             	mov    0x8(%ebp),%eax
  10179d:	8b 40 30             	mov    0x30(%eax),%eax
  1017a0:	83 ec 0c             	sub    $0xc,%esp
  1017a3:	50                   	push   %eax
  1017a4:	e8 16 ff ff ff       	call   1016bf <trapname>
  1017a9:	83 c4 10             	add    $0x10,%esp
  1017ac:	89 c2                	mov    %eax,%edx
  1017ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1017b1:	8b 40 30             	mov    0x30(%eax),%eax
  1017b4:	83 ec 04             	sub    $0x4,%esp
  1017b7:	52                   	push   %edx
  1017b8:	50                   	push   %eax
  1017b9:	68 db 34 10 00       	push   $0x1034db
  1017be:	e8 33 eb ff ff       	call   1002f6 <cprintf>
  1017c3:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  1017c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1017c9:	8b 40 34             	mov    0x34(%eax),%eax
  1017cc:	83 ec 08             	sub    $0x8,%esp
  1017cf:	50                   	push   %eax
  1017d0:	68 ed 34 10 00       	push   $0x1034ed
  1017d5:	e8 1c eb ff ff       	call   1002f6 <cprintf>
  1017da:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  1017dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1017e0:	8b 40 38             	mov    0x38(%eax),%eax
  1017e3:	83 ec 08             	sub    $0x8,%esp
  1017e6:	50                   	push   %eax
  1017e7:	68 fc 34 10 00       	push   $0x1034fc
  1017ec:	e8 05 eb ff ff       	call   1002f6 <cprintf>
  1017f1:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  1017f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1017f7:	66 8b 40 3c          	mov    0x3c(%eax),%ax
  1017fb:	0f b7 c0             	movzwl %ax,%eax
  1017fe:	83 ec 08             	sub    $0x8,%esp
  101801:	50                   	push   %eax
  101802:	68 0b 35 10 00       	push   $0x10350b
  101807:	e8 ea ea ff ff       	call   1002f6 <cprintf>
  10180c:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  10180f:	8b 45 08             	mov    0x8(%ebp),%eax
  101812:	8b 40 40             	mov    0x40(%eax),%eax
  101815:	83 ec 08             	sub    $0x8,%esp
  101818:	50                   	push   %eax
  101819:	68 1e 35 10 00       	push   $0x10351e
  10181e:	e8 d3 ea ff ff       	call   1002f6 <cprintf>
  101823:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101826:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10182d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101834:	eb 43                	jmp    101879 <print_trapframe+0x173>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101836:	8b 45 08             	mov    0x8(%ebp),%eax
  101839:	8b 50 40             	mov    0x40(%eax),%edx
  10183c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10183f:	21 d0                	and    %edx,%eax
  101841:	85 c0                	test   %eax,%eax
  101843:	74 29                	je     10186e <print_trapframe+0x168>
  101845:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101848:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  10184f:	85 c0                	test   %eax,%eax
  101851:	74 1b                	je     10186e <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
  101853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101856:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  10185d:	83 ec 08             	sub    $0x8,%esp
  101860:	50                   	push   %eax
  101861:	68 2d 35 10 00       	push   $0x10352d
  101866:	e8 8b ea ff ff       	call   1002f6 <cprintf>
  10186b:	83 c4 10             	add    $0x10,%esp
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  10186e:	ff 45 f4             	incl   -0xc(%ebp)
  101871:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101874:	01 c0                	add    %eax,%eax
  101876:	89 45 f0             	mov    %eax,-0x10(%ebp)
  101879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10187c:	83 f8 17             	cmp    $0x17,%eax
  10187f:	76 b5                	jbe    101836 <print_trapframe+0x130>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101881:	8b 45 08             	mov    0x8(%ebp),%eax
  101884:	8b 40 40             	mov    0x40(%eax),%eax
  101887:	c1 e8 0c             	shr    $0xc,%eax
  10188a:	83 e0 03             	and    $0x3,%eax
  10188d:	83 ec 08             	sub    $0x8,%esp
  101890:	50                   	push   %eax
  101891:	68 31 35 10 00       	push   $0x103531
  101896:	e8 5b ea ff ff       	call   1002f6 <cprintf>
  10189b:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  10189e:	83 ec 0c             	sub    $0xc,%esp
  1018a1:	ff 75 08             	pushl  0x8(%ebp)
  1018a4:	e8 47 fe ff ff       	call   1016f0 <trap_in_kernel>
  1018a9:	83 c4 10             	add    $0x10,%esp
  1018ac:	85 c0                	test   %eax,%eax
  1018ae:	75 32                	jne    1018e2 <print_trapframe+0x1dc>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  1018b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1018b3:	8b 40 44             	mov    0x44(%eax),%eax
  1018b6:	83 ec 08             	sub    $0x8,%esp
  1018b9:	50                   	push   %eax
  1018ba:	68 3a 35 10 00       	push   $0x10353a
  1018bf:	e8 32 ea ff ff       	call   1002f6 <cprintf>
  1018c4:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  1018c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1018ca:	66 8b 40 48          	mov    0x48(%eax),%ax
  1018ce:	0f b7 c0             	movzwl %ax,%eax
  1018d1:	83 ec 08             	sub    $0x8,%esp
  1018d4:	50                   	push   %eax
  1018d5:	68 49 35 10 00       	push   $0x103549
  1018da:	e8 17 ea ff ff       	call   1002f6 <cprintf>
  1018df:	83 c4 10             	add    $0x10,%esp
    }
}
  1018e2:	90                   	nop
  1018e3:	c9                   	leave  
  1018e4:	c3                   	ret    

001018e5 <print_regs>:

void
print_regs(struct pushregs *regs) {
  1018e5:	55                   	push   %ebp
  1018e6:	89 e5                	mov    %esp,%ebp
  1018e8:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  1018eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1018ee:	8b 00                	mov    (%eax),%eax
  1018f0:	83 ec 08             	sub    $0x8,%esp
  1018f3:	50                   	push   %eax
  1018f4:	68 5c 35 10 00       	push   $0x10355c
  1018f9:	e8 f8 e9 ff ff       	call   1002f6 <cprintf>
  1018fe:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101901:	8b 45 08             	mov    0x8(%ebp),%eax
  101904:	8b 40 04             	mov    0x4(%eax),%eax
  101907:	83 ec 08             	sub    $0x8,%esp
  10190a:	50                   	push   %eax
  10190b:	68 6b 35 10 00       	push   $0x10356b
  101910:	e8 e1 e9 ff ff       	call   1002f6 <cprintf>
  101915:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101918:	8b 45 08             	mov    0x8(%ebp),%eax
  10191b:	8b 40 08             	mov    0x8(%eax),%eax
  10191e:	83 ec 08             	sub    $0x8,%esp
  101921:	50                   	push   %eax
  101922:	68 7a 35 10 00       	push   $0x10357a
  101927:	e8 ca e9 ff ff       	call   1002f6 <cprintf>
  10192c:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  10192f:	8b 45 08             	mov    0x8(%ebp),%eax
  101932:	8b 40 0c             	mov    0xc(%eax),%eax
  101935:	83 ec 08             	sub    $0x8,%esp
  101938:	50                   	push   %eax
  101939:	68 89 35 10 00       	push   $0x103589
  10193e:	e8 b3 e9 ff ff       	call   1002f6 <cprintf>
  101943:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101946:	8b 45 08             	mov    0x8(%ebp),%eax
  101949:	8b 40 10             	mov    0x10(%eax),%eax
  10194c:	83 ec 08             	sub    $0x8,%esp
  10194f:	50                   	push   %eax
  101950:	68 98 35 10 00       	push   $0x103598
  101955:	e8 9c e9 ff ff       	call   1002f6 <cprintf>
  10195a:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  10195d:	8b 45 08             	mov    0x8(%ebp),%eax
  101960:	8b 40 14             	mov    0x14(%eax),%eax
  101963:	83 ec 08             	sub    $0x8,%esp
  101966:	50                   	push   %eax
  101967:	68 a7 35 10 00       	push   $0x1035a7
  10196c:	e8 85 e9 ff ff       	call   1002f6 <cprintf>
  101971:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101974:	8b 45 08             	mov    0x8(%ebp),%eax
  101977:	8b 40 18             	mov    0x18(%eax),%eax
  10197a:	83 ec 08             	sub    $0x8,%esp
  10197d:	50                   	push   %eax
  10197e:	68 b6 35 10 00       	push   $0x1035b6
  101983:	e8 6e e9 ff ff       	call   1002f6 <cprintf>
  101988:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  10198b:	8b 45 08             	mov    0x8(%ebp),%eax
  10198e:	8b 40 1c             	mov    0x1c(%eax),%eax
  101991:	83 ec 08             	sub    $0x8,%esp
  101994:	50                   	push   %eax
  101995:	68 c5 35 10 00       	push   $0x1035c5
  10199a:	e8 57 e9 ff ff       	call   1002f6 <cprintf>
  10199f:	83 c4 10             	add    $0x10,%esp
}
  1019a2:	90                   	nop
  1019a3:	c9                   	leave  
  1019a4:	c3                   	ret    

001019a5 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  1019a5:	55                   	push   %ebp
  1019a6:	89 e5                	mov    %esp,%ebp
  1019a8:	83 ec 18             	sub    $0x18,%esp
    char c;

    switch (tf->tf_trapno) {
  1019ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1019ae:	8b 40 30             	mov    0x30(%eax),%eax
  1019b1:	83 f8 2f             	cmp    $0x2f,%eax
  1019b4:	77 1e                	ja     1019d4 <trap_dispatch+0x2f>
  1019b6:	83 f8 2e             	cmp    $0x2e,%eax
  1019b9:	0f 83 b4 00 00 00    	jae    101a73 <trap_dispatch+0xce>
  1019bf:	83 f8 21             	cmp    $0x21,%eax
  1019c2:	74 3e                	je     101a02 <trap_dispatch+0x5d>
  1019c4:	83 f8 24             	cmp    $0x24,%eax
  1019c7:	74 15                	je     1019de <trap_dispatch+0x39>
  1019c9:	83 f8 20             	cmp    $0x20,%eax
  1019cc:	0f 84 a4 00 00 00    	je     101a76 <trap_dispatch+0xd1>
  1019d2:	eb 69                	jmp    101a3d <trap_dispatch+0x98>
  1019d4:	83 e8 78             	sub    $0x78,%eax
  1019d7:	83 f8 01             	cmp    $0x1,%eax
  1019da:	77 61                	ja     101a3d <trap_dispatch+0x98>
  1019dc:	eb 48                	jmp    101a26 <trap_dispatch+0x81>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  1019de:	e8 a5 fa ff ff       	call   101488 <cons_getc>
  1019e3:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  1019e6:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  1019ea:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1019ee:	83 ec 04             	sub    $0x4,%esp
  1019f1:	52                   	push   %edx
  1019f2:	50                   	push   %eax
  1019f3:	68 d4 35 10 00       	push   $0x1035d4
  1019f8:	e8 f9 e8 ff ff       	call   1002f6 <cprintf>
  1019fd:	83 c4 10             	add    $0x10,%esp
        break;
  101a00:	eb 75                	jmp    101a77 <trap_dispatch+0xd2>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101a02:	e8 81 fa ff ff       	call   101488 <cons_getc>
  101a07:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101a0a:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101a0e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101a12:	83 ec 04             	sub    $0x4,%esp
  101a15:	52                   	push   %edx
  101a16:	50                   	push   %eax
  101a17:	68 e6 35 10 00       	push   $0x1035e6
  101a1c:	e8 d5 e8 ff ff       	call   1002f6 <cprintf>
  101a21:	83 c4 10             	add    $0x10,%esp
        break;
  101a24:	eb 51                	jmp    101a77 <trap_dispatch+0xd2>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101a26:	83 ec 04             	sub    $0x4,%esp
  101a29:	68 f5 35 10 00       	push   $0x1035f5
  101a2e:	68 a2 00 00 00       	push   $0xa2
  101a33:	68 05 36 10 00       	push   $0x103605
  101a38:	e8 50 f1 ff ff       	call   100b8d <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a40:	66 8b 40 3c          	mov    0x3c(%eax),%ax
  101a44:	0f b7 c0             	movzwl %ax,%eax
  101a47:	83 e0 03             	and    $0x3,%eax
  101a4a:	85 c0                	test   %eax,%eax
  101a4c:	75 29                	jne    101a77 <trap_dispatch+0xd2>
            print_trapframe(tf);
  101a4e:	83 ec 0c             	sub    $0xc,%esp
  101a51:	ff 75 08             	pushl  0x8(%ebp)
  101a54:	e8 ad fc ff ff       	call   101706 <print_trapframe>
  101a59:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101a5c:	83 ec 04             	sub    $0x4,%esp
  101a5f:	68 16 36 10 00       	push   $0x103616
  101a64:	68 ac 00 00 00       	push   $0xac
  101a69:	68 05 36 10 00       	push   $0x103605
  101a6e:	e8 1a f1 ff ff       	call   100b8d <__panic>
        break;
  101a73:	90                   	nop
  101a74:	eb 01                	jmp    101a77 <trap_dispatch+0xd2>
        break;
  101a76:	90                   	nop
        }
    }
}
  101a77:	90                   	nop
  101a78:	c9                   	leave  
  101a79:	c3                   	ret    

00101a7a <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101a7a:	55                   	push   %ebp
  101a7b:	89 e5                	mov    %esp,%ebp
  101a7d:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101a80:	83 ec 0c             	sub    $0xc,%esp
  101a83:	ff 75 08             	pushl  0x8(%ebp)
  101a86:	e8 1a ff ff ff       	call   1019a5 <trap_dispatch>
  101a8b:	83 c4 10             	add    $0x10,%esp
}
  101a8e:	90                   	nop
  101a8f:	c9                   	leave  
  101a90:	c3                   	ret    

00101a91 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101a91:	1e                   	push   %ds
    pushl %es
  101a92:	06                   	push   %es
    pushl %fs
  101a93:	0f a0                	push   %fs
    pushl %gs
  101a95:	0f a8                	push   %gs
    pushal
  101a97:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101a98:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101a9d:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101a9f:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101aa1:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101aa2:	e8 d3 ff ff ff       	call   101a7a <trap>

    # pop the pushed stack pointer
    popl %esp
  101aa7:	5c                   	pop    %esp

00101aa8 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101aa8:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101aa9:	0f a9                	pop    %gs
    popl %fs
  101aab:	0f a1                	pop    %fs
    popl %es
  101aad:	07                   	pop    %es
    popl %ds
  101aae:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101aaf:	83 c4 08             	add    $0x8,%esp
    iret
  101ab2:	cf                   	iret   

00101ab3 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101ab3:	6a 00                	push   $0x0
  pushl $0
  101ab5:	6a 00                	push   $0x0
  jmp __alltraps
  101ab7:	e9 d5 ff ff ff       	jmp    101a91 <__alltraps>

00101abc <vector1>:
.globl vector1
vector1:
  pushl $0
  101abc:	6a 00                	push   $0x0
  pushl $1
  101abe:	6a 01                	push   $0x1
  jmp __alltraps
  101ac0:	e9 cc ff ff ff       	jmp    101a91 <__alltraps>

00101ac5 <vector2>:
.globl vector2
vector2:
  pushl $0
  101ac5:	6a 00                	push   $0x0
  pushl $2
  101ac7:	6a 02                	push   $0x2
  jmp __alltraps
  101ac9:	e9 c3 ff ff ff       	jmp    101a91 <__alltraps>

00101ace <vector3>:
.globl vector3
vector3:
  pushl $0
  101ace:	6a 00                	push   $0x0
  pushl $3
  101ad0:	6a 03                	push   $0x3
  jmp __alltraps
  101ad2:	e9 ba ff ff ff       	jmp    101a91 <__alltraps>

00101ad7 <vector4>:
.globl vector4
vector4:
  pushl $0
  101ad7:	6a 00                	push   $0x0
  pushl $4
  101ad9:	6a 04                	push   $0x4
  jmp __alltraps
  101adb:	e9 b1 ff ff ff       	jmp    101a91 <__alltraps>

00101ae0 <vector5>:
.globl vector5
vector5:
  pushl $0
  101ae0:	6a 00                	push   $0x0
  pushl $5
  101ae2:	6a 05                	push   $0x5
  jmp __alltraps
  101ae4:	e9 a8 ff ff ff       	jmp    101a91 <__alltraps>

00101ae9 <vector6>:
.globl vector6
vector6:
  pushl $0
  101ae9:	6a 00                	push   $0x0
  pushl $6
  101aeb:	6a 06                	push   $0x6
  jmp __alltraps
  101aed:	e9 9f ff ff ff       	jmp    101a91 <__alltraps>

00101af2 <vector7>:
.globl vector7
vector7:
  pushl $0
  101af2:	6a 00                	push   $0x0
  pushl $7
  101af4:	6a 07                	push   $0x7
  jmp __alltraps
  101af6:	e9 96 ff ff ff       	jmp    101a91 <__alltraps>

00101afb <vector8>:
.globl vector8
vector8:
  pushl $8
  101afb:	6a 08                	push   $0x8
  jmp __alltraps
  101afd:	e9 8f ff ff ff       	jmp    101a91 <__alltraps>

00101b02 <vector9>:
.globl vector9
vector9:
  pushl $0
  101b02:	6a 00                	push   $0x0
  pushl $9
  101b04:	6a 09                	push   $0x9
  jmp __alltraps
  101b06:	e9 86 ff ff ff       	jmp    101a91 <__alltraps>

00101b0b <vector10>:
.globl vector10
vector10:
  pushl $10
  101b0b:	6a 0a                	push   $0xa
  jmp __alltraps
  101b0d:	e9 7f ff ff ff       	jmp    101a91 <__alltraps>

00101b12 <vector11>:
.globl vector11
vector11:
  pushl $11
  101b12:	6a 0b                	push   $0xb
  jmp __alltraps
  101b14:	e9 78 ff ff ff       	jmp    101a91 <__alltraps>

00101b19 <vector12>:
.globl vector12
vector12:
  pushl $12
  101b19:	6a 0c                	push   $0xc
  jmp __alltraps
  101b1b:	e9 71 ff ff ff       	jmp    101a91 <__alltraps>

00101b20 <vector13>:
.globl vector13
vector13:
  pushl $13
  101b20:	6a 0d                	push   $0xd
  jmp __alltraps
  101b22:	e9 6a ff ff ff       	jmp    101a91 <__alltraps>

00101b27 <vector14>:
.globl vector14
vector14:
  pushl $14
  101b27:	6a 0e                	push   $0xe
  jmp __alltraps
  101b29:	e9 63 ff ff ff       	jmp    101a91 <__alltraps>

00101b2e <vector15>:
.globl vector15
vector15:
  pushl $0
  101b2e:	6a 00                	push   $0x0
  pushl $15
  101b30:	6a 0f                	push   $0xf
  jmp __alltraps
  101b32:	e9 5a ff ff ff       	jmp    101a91 <__alltraps>

00101b37 <vector16>:
.globl vector16
vector16:
  pushl $0
  101b37:	6a 00                	push   $0x0
  pushl $16
  101b39:	6a 10                	push   $0x10
  jmp __alltraps
  101b3b:	e9 51 ff ff ff       	jmp    101a91 <__alltraps>

00101b40 <vector17>:
.globl vector17
vector17:
  pushl $17
  101b40:	6a 11                	push   $0x11
  jmp __alltraps
  101b42:	e9 4a ff ff ff       	jmp    101a91 <__alltraps>

00101b47 <vector18>:
.globl vector18
vector18:
  pushl $0
  101b47:	6a 00                	push   $0x0
  pushl $18
  101b49:	6a 12                	push   $0x12
  jmp __alltraps
  101b4b:	e9 41 ff ff ff       	jmp    101a91 <__alltraps>

00101b50 <vector19>:
.globl vector19
vector19:
  pushl $0
  101b50:	6a 00                	push   $0x0
  pushl $19
  101b52:	6a 13                	push   $0x13
  jmp __alltraps
  101b54:	e9 38 ff ff ff       	jmp    101a91 <__alltraps>

00101b59 <vector20>:
.globl vector20
vector20:
  pushl $0
  101b59:	6a 00                	push   $0x0
  pushl $20
  101b5b:	6a 14                	push   $0x14
  jmp __alltraps
  101b5d:	e9 2f ff ff ff       	jmp    101a91 <__alltraps>

00101b62 <vector21>:
.globl vector21
vector21:
  pushl $0
  101b62:	6a 00                	push   $0x0
  pushl $21
  101b64:	6a 15                	push   $0x15
  jmp __alltraps
  101b66:	e9 26 ff ff ff       	jmp    101a91 <__alltraps>

00101b6b <vector22>:
.globl vector22
vector22:
  pushl $0
  101b6b:	6a 00                	push   $0x0
  pushl $22
  101b6d:	6a 16                	push   $0x16
  jmp __alltraps
  101b6f:	e9 1d ff ff ff       	jmp    101a91 <__alltraps>

00101b74 <vector23>:
.globl vector23
vector23:
  pushl $0
  101b74:	6a 00                	push   $0x0
  pushl $23
  101b76:	6a 17                	push   $0x17
  jmp __alltraps
  101b78:	e9 14 ff ff ff       	jmp    101a91 <__alltraps>

00101b7d <vector24>:
.globl vector24
vector24:
  pushl $0
  101b7d:	6a 00                	push   $0x0
  pushl $24
  101b7f:	6a 18                	push   $0x18
  jmp __alltraps
  101b81:	e9 0b ff ff ff       	jmp    101a91 <__alltraps>

00101b86 <vector25>:
.globl vector25
vector25:
  pushl $0
  101b86:	6a 00                	push   $0x0
  pushl $25
  101b88:	6a 19                	push   $0x19
  jmp __alltraps
  101b8a:	e9 02 ff ff ff       	jmp    101a91 <__alltraps>

00101b8f <vector26>:
.globl vector26
vector26:
  pushl $0
  101b8f:	6a 00                	push   $0x0
  pushl $26
  101b91:	6a 1a                	push   $0x1a
  jmp __alltraps
  101b93:	e9 f9 fe ff ff       	jmp    101a91 <__alltraps>

00101b98 <vector27>:
.globl vector27
vector27:
  pushl $0
  101b98:	6a 00                	push   $0x0
  pushl $27
  101b9a:	6a 1b                	push   $0x1b
  jmp __alltraps
  101b9c:	e9 f0 fe ff ff       	jmp    101a91 <__alltraps>

00101ba1 <vector28>:
.globl vector28
vector28:
  pushl $0
  101ba1:	6a 00                	push   $0x0
  pushl $28
  101ba3:	6a 1c                	push   $0x1c
  jmp __alltraps
  101ba5:	e9 e7 fe ff ff       	jmp    101a91 <__alltraps>

00101baa <vector29>:
.globl vector29
vector29:
  pushl $0
  101baa:	6a 00                	push   $0x0
  pushl $29
  101bac:	6a 1d                	push   $0x1d
  jmp __alltraps
  101bae:	e9 de fe ff ff       	jmp    101a91 <__alltraps>

00101bb3 <vector30>:
.globl vector30
vector30:
  pushl $0
  101bb3:	6a 00                	push   $0x0
  pushl $30
  101bb5:	6a 1e                	push   $0x1e
  jmp __alltraps
  101bb7:	e9 d5 fe ff ff       	jmp    101a91 <__alltraps>

00101bbc <vector31>:
.globl vector31
vector31:
  pushl $0
  101bbc:	6a 00                	push   $0x0
  pushl $31
  101bbe:	6a 1f                	push   $0x1f
  jmp __alltraps
  101bc0:	e9 cc fe ff ff       	jmp    101a91 <__alltraps>

00101bc5 <vector32>:
.globl vector32
vector32:
  pushl $0
  101bc5:	6a 00                	push   $0x0
  pushl $32
  101bc7:	6a 20                	push   $0x20
  jmp __alltraps
  101bc9:	e9 c3 fe ff ff       	jmp    101a91 <__alltraps>

00101bce <vector33>:
.globl vector33
vector33:
  pushl $0
  101bce:	6a 00                	push   $0x0
  pushl $33
  101bd0:	6a 21                	push   $0x21
  jmp __alltraps
  101bd2:	e9 ba fe ff ff       	jmp    101a91 <__alltraps>

00101bd7 <vector34>:
.globl vector34
vector34:
  pushl $0
  101bd7:	6a 00                	push   $0x0
  pushl $34
  101bd9:	6a 22                	push   $0x22
  jmp __alltraps
  101bdb:	e9 b1 fe ff ff       	jmp    101a91 <__alltraps>

00101be0 <vector35>:
.globl vector35
vector35:
  pushl $0
  101be0:	6a 00                	push   $0x0
  pushl $35
  101be2:	6a 23                	push   $0x23
  jmp __alltraps
  101be4:	e9 a8 fe ff ff       	jmp    101a91 <__alltraps>

00101be9 <vector36>:
.globl vector36
vector36:
  pushl $0
  101be9:	6a 00                	push   $0x0
  pushl $36
  101beb:	6a 24                	push   $0x24
  jmp __alltraps
  101bed:	e9 9f fe ff ff       	jmp    101a91 <__alltraps>

00101bf2 <vector37>:
.globl vector37
vector37:
  pushl $0
  101bf2:	6a 00                	push   $0x0
  pushl $37
  101bf4:	6a 25                	push   $0x25
  jmp __alltraps
  101bf6:	e9 96 fe ff ff       	jmp    101a91 <__alltraps>

00101bfb <vector38>:
.globl vector38
vector38:
  pushl $0
  101bfb:	6a 00                	push   $0x0
  pushl $38
  101bfd:	6a 26                	push   $0x26
  jmp __alltraps
  101bff:	e9 8d fe ff ff       	jmp    101a91 <__alltraps>

00101c04 <vector39>:
.globl vector39
vector39:
  pushl $0
  101c04:	6a 00                	push   $0x0
  pushl $39
  101c06:	6a 27                	push   $0x27
  jmp __alltraps
  101c08:	e9 84 fe ff ff       	jmp    101a91 <__alltraps>

00101c0d <vector40>:
.globl vector40
vector40:
  pushl $0
  101c0d:	6a 00                	push   $0x0
  pushl $40
  101c0f:	6a 28                	push   $0x28
  jmp __alltraps
  101c11:	e9 7b fe ff ff       	jmp    101a91 <__alltraps>

00101c16 <vector41>:
.globl vector41
vector41:
  pushl $0
  101c16:	6a 00                	push   $0x0
  pushl $41
  101c18:	6a 29                	push   $0x29
  jmp __alltraps
  101c1a:	e9 72 fe ff ff       	jmp    101a91 <__alltraps>

00101c1f <vector42>:
.globl vector42
vector42:
  pushl $0
  101c1f:	6a 00                	push   $0x0
  pushl $42
  101c21:	6a 2a                	push   $0x2a
  jmp __alltraps
  101c23:	e9 69 fe ff ff       	jmp    101a91 <__alltraps>

00101c28 <vector43>:
.globl vector43
vector43:
  pushl $0
  101c28:	6a 00                	push   $0x0
  pushl $43
  101c2a:	6a 2b                	push   $0x2b
  jmp __alltraps
  101c2c:	e9 60 fe ff ff       	jmp    101a91 <__alltraps>

00101c31 <vector44>:
.globl vector44
vector44:
  pushl $0
  101c31:	6a 00                	push   $0x0
  pushl $44
  101c33:	6a 2c                	push   $0x2c
  jmp __alltraps
  101c35:	e9 57 fe ff ff       	jmp    101a91 <__alltraps>

00101c3a <vector45>:
.globl vector45
vector45:
  pushl $0
  101c3a:	6a 00                	push   $0x0
  pushl $45
  101c3c:	6a 2d                	push   $0x2d
  jmp __alltraps
  101c3e:	e9 4e fe ff ff       	jmp    101a91 <__alltraps>

00101c43 <vector46>:
.globl vector46
vector46:
  pushl $0
  101c43:	6a 00                	push   $0x0
  pushl $46
  101c45:	6a 2e                	push   $0x2e
  jmp __alltraps
  101c47:	e9 45 fe ff ff       	jmp    101a91 <__alltraps>

00101c4c <vector47>:
.globl vector47
vector47:
  pushl $0
  101c4c:	6a 00                	push   $0x0
  pushl $47
  101c4e:	6a 2f                	push   $0x2f
  jmp __alltraps
  101c50:	e9 3c fe ff ff       	jmp    101a91 <__alltraps>

00101c55 <vector48>:
.globl vector48
vector48:
  pushl $0
  101c55:	6a 00                	push   $0x0
  pushl $48
  101c57:	6a 30                	push   $0x30
  jmp __alltraps
  101c59:	e9 33 fe ff ff       	jmp    101a91 <__alltraps>

00101c5e <vector49>:
.globl vector49
vector49:
  pushl $0
  101c5e:	6a 00                	push   $0x0
  pushl $49
  101c60:	6a 31                	push   $0x31
  jmp __alltraps
  101c62:	e9 2a fe ff ff       	jmp    101a91 <__alltraps>

00101c67 <vector50>:
.globl vector50
vector50:
  pushl $0
  101c67:	6a 00                	push   $0x0
  pushl $50
  101c69:	6a 32                	push   $0x32
  jmp __alltraps
  101c6b:	e9 21 fe ff ff       	jmp    101a91 <__alltraps>

00101c70 <vector51>:
.globl vector51
vector51:
  pushl $0
  101c70:	6a 00                	push   $0x0
  pushl $51
  101c72:	6a 33                	push   $0x33
  jmp __alltraps
  101c74:	e9 18 fe ff ff       	jmp    101a91 <__alltraps>

00101c79 <vector52>:
.globl vector52
vector52:
  pushl $0
  101c79:	6a 00                	push   $0x0
  pushl $52
  101c7b:	6a 34                	push   $0x34
  jmp __alltraps
  101c7d:	e9 0f fe ff ff       	jmp    101a91 <__alltraps>

00101c82 <vector53>:
.globl vector53
vector53:
  pushl $0
  101c82:	6a 00                	push   $0x0
  pushl $53
  101c84:	6a 35                	push   $0x35
  jmp __alltraps
  101c86:	e9 06 fe ff ff       	jmp    101a91 <__alltraps>

00101c8b <vector54>:
.globl vector54
vector54:
  pushl $0
  101c8b:	6a 00                	push   $0x0
  pushl $54
  101c8d:	6a 36                	push   $0x36
  jmp __alltraps
  101c8f:	e9 fd fd ff ff       	jmp    101a91 <__alltraps>

00101c94 <vector55>:
.globl vector55
vector55:
  pushl $0
  101c94:	6a 00                	push   $0x0
  pushl $55
  101c96:	6a 37                	push   $0x37
  jmp __alltraps
  101c98:	e9 f4 fd ff ff       	jmp    101a91 <__alltraps>

00101c9d <vector56>:
.globl vector56
vector56:
  pushl $0
  101c9d:	6a 00                	push   $0x0
  pushl $56
  101c9f:	6a 38                	push   $0x38
  jmp __alltraps
  101ca1:	e9 eb fd ff ff       	jmp    101a91 <__alltraps>

00101ca6 <vector57>:
.globl vector57
vector57:
  pushl $0
  101ca6:	6a 00                	push   $0x0
  pushl $57
  101ca8:	6a 39                	push   $0x39
  jmp __alltraps
  101caa:	e9 e2 fd ff ff       	jmp    101a91 <__alltraps>

00101caf <vector58>:
.globl vector58
vector58:
  pushl $0
  101caf:	6a 00                	push   $0x0
  pushl $58
  101cb1:	6a 3a                	push   $0x3a
  jmp __alltraps
  101cb3:	e9 d9 fd ff ff       	jmp    101a91 <__alltraps>

00101cb8 <vector59>:
.globl vector59
vector59:
  pushl $0
  101cb8:	6a 00                	push   $0x0
  pushl $59
  101cba:	6a 3b                	push   $0x3b
  jmp __alltraps
  101cbc:	e9 d0 fd ff ff       	jmp    101a91 <__alltraps>

00101cc1 <vector60>:
.globl vector60
vector60:
  pushl $0
  101cc1:	6a 00                	push   $0x0
  pushl $60
  101cc3:	6a 3c                	push   $0x3c
  jmp __alltraps
  101cc5:	e9 c7 fd ff ff       	jmp    101a91 <__alltraps>

00101cca <vector61>:
.globl vector61
vector61:
  pushl $0
  101cca:	6a 00                	push   $0x0
  pushl $61
  101ccc:	6a 3d                	push   $0x3d
  jmp __alltraps
  101cce:	e9 be fd ff ff       	jmp    101a91 <__alltraps>

00101cd3 <vector62>:
.globl vector62
vector62:
  pushl $0
  101cd3:	6a 00                	push   $0x0
  pushl $62
  101cd5:	6a 3e                	push   $0x3e
  jmp __alltraps
  101cd7:	e9 b5 fd ff ff       	jmp    101a91 <__alltraps>

00101cdc <vector63>:
.globl vector63
vector63:
  pushl $0
  101cdc:	6a 00                	push   $0x0
  pushl $63
  101cde:	6a 3f                	push   $0x3f
  jmp __alltraps
  101ce0:	e9 ac fd ff ff       	jmp    101a91 <__alltraps>

00101ce5 <vector64>:
.globl vector64
vector64:
  pushl $0
  101ce5:	6a 00                	push   $0x0
  pushl $64
  101ce7:	6a 40                	push   $0x40
  jmp __alltraps
  101ce9:	e9 a3 fd ff ff       	jmp    101a91 <__alltraps>

00101cee <vector65>:
.globl vector65
vector65:
  pushl $0
  101cee:	6a 00                	push   $0x0
  pushl $65
  101cf0:	6a 41                	push   $0x41
  jmp __alltraps
  101cf2:	e9 9a fd ff ff       	jmp    101a91 <__alltraps>

00101cf7 <vector66>:
.globl vector66
vector66:
  pushl $0
  101cf7:	6a 00                	push   $0x0
  pushl $66
  101cf9:	6a 42                	push   $0x42
  jmp __alltraps
  101cfb:	e9 91 fd ff ff       	jmp    101a91 <__alltraps>

00101d00 <vector67>:
.globl vector67
vector67:
  pushl $0
  101d00:	6a 00                	push   $0x0
  pushl $67
  101d02:	6a 43                	push   $0x43
  jmp __alltraps
  101d04:	e9 88 fd ff ff       	jmp    101a91 <__alltraps>

00101d09 <vector68>:
.globl vector68
vector68:
  pushl $0
  101d09:	6a 00                	push   $0x0
  pushl $68
  101d0b:	6a 44                	push   $0x44
  jmp __alltraps
  101d0d:	e9 7f fd ff ff       	jmp    101a91 <__alltraps>

00101d12 <vector69>:
.globl vector69
vector69:
  pushl $0
  101d12:	6a 00                	push   $0x0
  pushl $69
  101d14:	6a 45                	push   $0x45
  jmp __alltraps
  101d16:	e9 76 fd ff ff       	jmp    101a91 <__alltraps>

00101d1b <vector70>:
.globl vector70
vector70:
  pushl $0
  101d1b:	6a 00                	push   $0x0
  pushl $70
  101d1d:	6a 46                	push   $0x46
  jmp __alltraps
  101d1f:	e9 6d fd ff ff       	jmp    101a91 <__alltraps>

00101d24 <vector71>:
.globl vector71
vector71:
  pushl $0
  101d24:	6a 00                	push   $0x0
  pushl $71
  101d26:	6a 47                	push   $0x47
  jmp __alltraps
  101d28:	e9 64 fd ff ff       	jmp    101a91 <__alltraps>

00101d2d <vector72>:
.globl vector72
vector72:
  pushl $0
  101d2d:	6a 00                	push   $0x0
  pushl $72
  101d2f:	6a 48                	push   $0x48
  jmp __alltraps
  101d31:	e9 5b fd ff ff       	jmp    101a91 <__alltraps>

00101d36 <vector73>:
.globl vector73
vector73:
  pushl $0
  101d36:	6a 00                	push   $0x0
  pushl $73
  101d38:	6a 49                	push   $0x49
  jmp __alltraps
  101d3a:	e9 52 fd ff ff       	jmp    101a91 <__alltraps>

00101d3f <vector74>:
.globl vector74
vector74:
  pushl $0
  101d3f:	6a 00                	push   $0x0
  pushl $74
  101d41:	6a 4a                	push   $0x4a
  jmp __alltraps
  101d43:	e9 49 fd ff ff       	jmp    101a91 <__alltraps>

00101d48 <vector75>:
.globl vector75
vector75:
  pushl $0
  101d48:	6a 00                	push   $0x0
  pushl $75
  101d4a:	6a 4b                	push   $0x4b
  jmp __alltraps
  101d4c:	e9 40 fd ff ff       	jmp    101a91 <__alltraps>

00101d51 <vector76>:
.globl vector76
vector76:
  pushl $0
  101d51:	6a 00                	push   $0x0
  pushl $76
  101d53:	6a 4c                	push   $0x4c
  jmp __alltraps
  101d55:	e9 37 fd ff ff       	jmp    101a91 <__alltraps>

00101d5a <vector77>:
.globl vector77
vector77:
  pushl $0
  101d5a:	6a 00                	push   $0x0
  pushl $77
  101d5c:	6a 4d                	push   $0x4d
  jmp __alltraps
  101d5e:	e9 2e fd ff ff       	jmp    101a91 <__alltraps>

00101d63 <vector78>:
.globl vector78
vector78:
  pushl $0
  101d63:	6a 00                	push   $0x0
  pushl $78
  101d65:	6a 4e                	push   $0x4e
  jmp __alltraps
  101d67:	e9 25 fd ff ff       	jmp    101a91 <__alltraps>

00101d6c <vector79>:
.globl vector79
vector79:
  pushl $0
  101d6c:	6a 00                	push   $0x0
  pushl $79
  101d6e:	6a 4f                	push   $0x4f
  jmp __alltraps
  101d70:	e9 1c fd ff ff       	jmp    101a91 <__alltraps>

00101d75 <vector80>:
.globl vector80
vector80:
  pushl $0
  101d75:	6a 00                	push   $0x0
  pushl $80
  101d77:	6a 50                	push   $0x50
  jmp __alltraps
  101d79:	e9 13 fd ff ff       	jmp    101a91 <__alltraps>

00101d7e <vector81>:
.globl vector81
vector81:
  pushl $0
  101d7e:	6a 00                	push   $0x0
  pushl $81
  101d80:	6a 51                	push   $0x51
  jmp __alltraps
  101d82:	e9 0a fd ff ff       	jmp    101a91 <__alltraps>

00101d87 <vector82>:
.globl vector82
vector82:
  pushl $0
  101d87:	6a 00                	push   $0x0
  pushl $82
  101d89:	6a 52                	push   $0x52
  jmp __alltraps
  101d8b:	e9 01 fd ff ff       	jmp    101a91 <__alltraps>

00101d90 <vector83>:
.globl vector83
vector83:
  pushl $0
  101d90:	6a 00                	push   $0x0
  pushl $83
  101d92:	6a 53                	push   $0x53
  jmp __alltraps
  101d94:	e9 f8 fc ff ff       	jmp    101a91 <__alltraps>

00101d99 <vector84>:
.globl vector84
vector84:
  pushl $0
  101d99:	6a 00                	push   $0x0
  pushl $84
  101d9b:	6a 54                	push   $0x54
  jmp __alltraps
  101d9d:	e9 ef fc ff ff       	jmp    101a91 <__alltraps>

00101da2 <vector85>:
.globl vector85
vector85:
  pushl $0
  101da2:	6a 00                	push   $0x0
  pushl $85
  101da4:	6a 55                	push   $0x55
  jmp __alltraps
  101da6:	e9 e6 fc ff ff       	jmp    101a91 <__alltraps>

00101dab <vector86>:
.globl vector86
vector86:
  pushl $0
  101dab:	6a 00                	push   $0x0
  pushl $86
  101dad:	6a 56                	push   $0x56
  jmp __alltraps
  101daf:	e9 dd fc ff ff       	jmp    101a91 <__alltraps>

00101db4 <vector87>:
.globl vector87
vector87:
  pushl $0
  101db4:	6a 00                	push   $0x0
  pushl $87
  101db6:	6a 57                	push   $0x57
  jmp __alltraps
  101db8:	e9 d4 fc ff ff       	jmp    101a91 <__alltraps>

00101dbd <vector88>:
.globl vector88
vector88:
  pushl $0
  101dbd:	6a 00                	push   $0x0
  pushl $88
  101dbf:	6a 58                	push   $0x58
  jmp __alltraps
  101dc1:	e9 cb fc ff ff       	jmp    101a91 <__alltraps>

00101dc6 <vector89>:
.globl vector89
vector89:
  pushl $0
  101dc6:	6a 00                	push   $0x0
  pushl $89
  101dc8:	6a 59                	push   $0x59
  jmp __alltraps
  101dca:	e9 c2 fc ff ff       	jmp    101a91 <__alltraps>

00101dcf <vector90>:
.globl vector90
vector90:
  pushl $0
  101dcf:	6a 00                	push   $0x0
  pushl $90
  101dd1:	6a 5a                	push   $0x5a
  jmp __alltraps
  101dd3:	e9 b9 fc ff ff       	jmp    101a91 <__alltraps>

00101dd8 <vector91>:
.globl vector91
vector91:
  pushl $0
  101dd8:	6a 00                	push   $0x0
  pushl $91
  101dda:	6a 5b                	push   $0x5b
  jmp __alltraps
  101ddc:	e9 b0 fc ff ff       	jmp    101a91 <__alltraps>

00101de1 <vector92>:
.globl vector92
vector92:
  pushl $0
  101de1:	6a 00                	push   $0x0
  pushl $92
  101de3:	6a 5c                	push   $0x5c
  jmp __alltraps
  101de5:	e9 a7 fc ff ff       	jmp    101a91 <__alltraps>

00101dea <vector93>:
.globl vector93
vector93:
  pushl $0
  101dea:	6a 00                	push   $0x0
  pushl $93
  101dec:	6a 5d                	push   $0x5d
  jmp __alltraps
  101dee:	e9 9e fc ff ff       	jmp    101a91 <__alltraps>

00101df3 <vector94>:
.globl vector94
vector94:
  pushl $0
  101df3:	6a 00                	push   $0x0
  pushl $94
  101df5:	6a 5e                	push   $0x5e
  jmp __alltraps
  101df7:	e9 95 fc ff ff       	jmp    101a91 <__alltraps>

00101dfc <vector95>:
.globl vector95
vector95:
  pushl $0
  101dfc:	6a 00                	push   $0x0
  pushl $95
  101dfe:	6a 5f                	push   $0x5f
  jmp __alltraps
  101e00:	e9 8c fc ff ff       	jmp    101a91 <__alltraps>

00101e05 <vector96>:
.globl vector96
vector96:
  pushl $0
  101e05:	6a 00                	push   $0x0
  pushl $96
  101e07:	6a 60                	push   $0x60
  jmp __alltraps
  101e09:	e9 83 fc ff ff       	jmp    101a91 <__alltraps>

00101e0e <vector97>:
.globl vector97
vector97:
  pushl $0
  101e0e:	6a 00                	push   $0x0
  pushl $97
  101e10:	6a 61                	push   $0x61
  jmp __alltraps
  101e12:	e9 7a fc ff ff       	jmp    101a91 <__alltraps>

00101e17 <vector98>:
.globl vector98
vector98:
  pushl $0
  101e17:	6a 00                	push   $0x0
  pushl $98
  101e19:	6a 62                	push   $0x62
  jmp __alltraps
  101e1b:	e9 71 fc ff ff       	jmp    101a91 <__alltraps>

00101e20 <vector99>:
.globl vector99
vector99:
  pushl $0
  101e20:	6a 00                	push   $0x0
  pushl $99
  101e22:	6a 63                	push   $0x63
  jmp __alltraps
  101e24:	e9 68 fc ff ff       	jmp    101a91 <__alltraps>

00101e29 <vector100>:
.globl vector100
vector100:
  pushl $0
  101e29:	6a 00                	push   $0x0
  pushl $100
  101e2b:	6a 64                	push   $0x64
  jmp __alltraps
  101e2d:	e9 5f fc ff ff       	jmp    101a91 <__alltraps>

00101e32 <vector101>:
.globl vector101
vector101:
  pushl $0
  101e32:	6a 00                	push   $0x0
  pushl $101
  101e34:	6a 65                	push   $0x65
  jmp __alltraps
  101e36:	e9 56 fc ff ff       	jmp    101a91 <__alltraps>

00101e3b <vector102>:
.globl vector102
vector102:
  pushl $0
  101e3b:	6a 00                	push   $0x0
  pushl $102
  101e3d:	6a 66                	push   $0x66
  jmp __alltraps
  101e3f:	e9 4d fc ff ff       	jmp    101a91 <__alltraps>

00101e44 <vector103>:
.globl vector103
vector103:
  pushl $0
  101e44:	6a 00                	push   $0x0
  pushl $103
  101e46:	6a 67                	push   $0x67
  jmp __alltraps
  101e48:	e9 44 fc ff ff       	jmp    101a91 <__alltraps>

00101e4d <vector104>:
.globl vector104
vector104:
  pushl $0
  101e4d:	6a 00                	push   $0x0
  pushl $104
  101e4f:	6a 68                	push   $0x68
  jmp __alltraps
  101e51:	e9 3b fc ff ff       	jmp    101a91 <__alltraps>

00101e56 <vector105>:
.globl vector105
vector105:
  pushl $0
  101e56:	6a 00                	push   $0x0
  pushl $105
  101e58:	6a 69                	push   $0x69
  jmp __alltraps
  101e5a:	e9 32 fc ff ff       	jmp    101a91 <__alltraps>

00101e5f <vector106>:
.globl vector106
vector106:
  pushl $0
  101e5f:	6a 00                	push   $0x0
  pushl $106
  101e61:	6a 6a                	push   $0x6a
  jmp __alltraps
  101e63:	e9 29 fc ff ff       	jmp    101a91 <__alltraps>

00101e68 <vector107>:
.globl vector107
vector107:
  pushl $0
  101e68:	6a 00                	push   $0x0
  pushl $107
  101e6a:	6a 6b                	push   $0x6b
  jmp __alltraps
  101e6c:	e9 20 fc ff ff       	jmp    101a91 <__alltraps>

00101e71 <vector108>:
.globl vector108
vector108:
  pushl $0
  101e71:	6a 00                	push   $0x0
  pushl $108
  101e73:	6a 6c                	push   $0x6c
  jmp __alltraps
  101e75:	e9 17 fc ff ff       	jmp    101a91 <__alltraps>

00101e7a <vector109>:
.globl vector109
vector109:
  pushl $0
  101e7a:	6a 00                	push   $0x0
  pushl $109
  101e7c:	6a 6d                	push   $0x6d
  jmp __alltraps
  101e7e:	e9 0e fc ff ff       	jmp    101a91 <__alltraps>

00101e83 <vector110>:
.globl vector110
vector110:
  pushl $0
  101e83:	6a 00                	push   $0x0
  pushl $110
  101e85:	6a 6e                	push   $0x6e
  jmp __alltraps
  101e87:	e9 05 fc ff ff       	jmp    101a91 <__alltraps>

00101e8c <vector111>:
.globl vector111
vector111:
  pushl $0
  101e8c:	6a 00                	push   $0x0
  pushl $111
  101e8e:	6a 6f                	push   $0x6f
  jmp __alltraps
  101e90:	e9 fc fb ff ff       	jmp    101a91 <__alltraps>

00101e95 <vector112>:
.globl vector112
vector112:
  pushl $0
  101e95:	6a 00                	push   $0x0
  pushl $112
  101e97:	6a 70                	push   $0x70
  jmp __alltraps
  101e99:	e9 f3 fb ff ff       	jmp    101a91 <__alltraps>

00101e9e <vector113>:
.globl vector113
vector113:
  pushl $0
  101e9e:	6a 00                	push   $0x0
  pushl $113
  101ea0:	6a 71                	push   $0x71
  jmp __alltraps
  101ea2:	e9 ea fb ff ff       	jmp    101a91 <__alltraps>

00101ea7 <vector114>:
.globl vector114
vector114:
  pushl $0
  101ea7:	6a 00                	push   $0x0
  pushl $114
  101ea9:	6a 72                	push   $0x72
  jmp __alltraps
  101eab:	e9 e1 fb ff ff       	jmp    101a91 <__alltraps>

00101eb0 <vector115>:
.globl vector115
vector115:
  pushl $0
  101eb0:	6a 00                	push   $0x0
  pushl $115
  101eb2:	6a 73                	push   $0x73
  jmp __alltraps
  101eb4:	e9 d8 fb ff ff       	jmp    101a91 <__alltraps>

00101eb9 <vector116>:
.globl vector116
vector116:
  pushl $0
  101eb9:	6a 00                	push   $0x0
  pushl $116
  101ebb:	6a 74                	push   $0x74
  jmp __alltraps
  101ebd:	e9 cf fb ff ff       	jmp    101a91 <__alltraps>

00101ec2 <vector117>:
.globl vector117
vector117:
  pushl $0
  101ec2:	6a 00                	push   $0x0
  pushl $117
  101ec4:	6a 75                	push   $0x75
  jmp __alltraps
  101ec6:	e9 c6 fb ff ff       	jmp    101a91 <__alltraps>

00101ecb <vector118>:
.globl vector118
vector118:
  pushl $0
  101ecb:	6a 00                	push   $0x0
  pushl $118
  101ecd:	6a 76                	push   $0x76
  jmp __alltraps
  101ecf:	e9 bd fb ff ff       	jmp    101a91 <__alltraps>

00101ed4 <vector119>:
.globl vector119
vector119:
  pushl $0
  101ed4:	6a 00                	push   $0x0
  pushl $119
  101ed6:	6a 77                	push   $0x77
  jmp __alltraps
  101ed8:	e9 b4 fb ff ff       	jmp    101a91 <__alltraps>

00101edd <vector120>:
.globl vector120
vector120:
  pushl $0
  101edd:	6a 00                	push   $0x0
  pushl $120
  101edf:	6a 78                	push   $0x78
  jmp __alltraps
  101ee1:	e9 ab fb ff ff       	jmp    101a91 <__alltraps>

00101ee6 <vector121>:
.globl vector121
vector121:
  pushl $0
  101ee6:	6a 00                	push   $0x0
  pushl $121
  101ee8:	6a 79                	push   $0x79
  jmp __alltraps
  101eea:	e9 a2 fb ff ff       	jmp    101a91 <__alltraps>

00101eef <vector122>:
.globl vector122
vector122:
  pushl $0
  101eef:	6a 00                	push   $0x0
  pushl $122
  101ef1:	6a 7a                	push   $0x7a
  jmp __alltraps
  101ef3:	e9 99 fb ff ff       	jmp    101a91 <__alltraps>

00101ef8 <vector123>:
.globl vector123
vector123:
  pushl $0
  101ef8:	6a 00                	push   $0x0
  pushl $123
  101efa:	6a 7b                	push   $0x7b
  jmp __alltraps
  101efc:	e9 90 fb ff ff       	jmp    101a91 <__alltraps>

00101f01 <vector124>:
.globl vector124
vector124:
  pushl $0
  101f01:	6a 00                	push   $0x0
  pushl $124
  101f03:	6a 7c                	push   $0x7c
  jmp __alltraps
  101f05:	e9 87 fb ff ff       	jmp    101a91 <__alltraps>

00101f0a <vector125>:
.globl vector125
vector125:
  pushl $0
  101f0a:	6a 00                	push   $0x0
  pushl $125
  101f0c:	6a 7d                	push   $0x7d
  jmp __alltraps
  101f0e:	e9 7e fb ff ff       	jmp    101a91 <__alltraps>

00101f13 <vector126>:
.globl vector126
vector126:
  pushl $0
  101f13:	6a 00                	push   $0x0
  pushl $126
  101f15:	6a 7e                	push   $0x7e
  jmp __alltraps
  101f17:	e9 75 fb ff ff       	jmp    101a91 <__alltraps>

00101f1c <vector127>:
.globl vector127
vector127:
  pushl $0
  101f1c:	6a 00                	push   $0x0
  pushl $127
  101f1e:	6a 7f                	push   $0x7f
  jmp __alltraps
  101f20:	e9 6c fb ff ff       	jmp    101a91 <__alltraps>

00101f25 <vector128>:
.globl vector128
vector128:
  pushl $0
  101f25:	6a 00                	push   $0x0
  pushl $128
  101f27:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  101f2c:	e9 60 fb ff ff       	jmp    101a91 <__alltraps>

00101f31 <vector129>:
.globl vector129
vector129:
  pushl $0
  101f31:	6a 00                	push   $0x0
  pushl $129
  101f33:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  101f38:	e9 54 fb ff ff       	jmp    101a91 <__alltraps>

00101f3d <vector130>:
.globl vector130
vector130:
  pushl $0
  101f3d:	6a 00                	push   $0x0
  pushl $130
  101f3f:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  101f44:	e9 48 fb ff ff       	jmp    101a91 <__alltraps>

00101f49 <vector131>:
.globl vector131
vector131:
  pushl $0
  101f49:	6a 00                	push   $0x0
  pushl $131
  101f4b:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  101f50:	e9 3c fb ff ff       	jmp    101a91 <__alltraps>

00101f55 <vector132>:
.globl vector132
vector132:
  pushl $0
  101f55:	6a 00                	push   $0x0
  pushl $132
  101f57:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  101f5c:	e9 30 fb ff ff       	jmp    101a91 <__alltraps>

00101f61 <vector133>:
.globl vector133
vector133:
  pushl $0
  101f61:	6a 00                	push   $0x0
  pushl $133
  101f63:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  101f68:	e9 24 fb ff ff       	jmp    101a91 <__alltraps>

00101f6d <vector134>:
.globl vector134
vector134:
  pushl $0
  101f6d:	6a 00                	push   $0x0
  pushl $134
  101f6f:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  101f74:	e9 18 fb ff ff       	jmp    101a91 <__alltraps>

00101f79 <vector135>:
.globl vector135
vector135:
  pushl $0
  101f79:	6a 00                	push   $0x0
  pushl $135
  101f7b:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  101f80:	e9 0c fb ff ff       	jmp    101a91 <__alltraps>

00101f85 <vector136>:
.globl vector136
vector136:
  pushl $0
  101f85:	6a 00                	push   $0x0
  pushl $136
  101f87:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  101f8c:	e9 00 fb ff ff       	jmp    101a91 <__alltraps>

00101f91 <vector137>:
.globl vector137
vector137:
  pushl $0
  101f91:	6a 00                	push   $0x0
  pushl $137
  101f93:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  101f98:	e9 f4 fa ff ff       	jmp    101a91 <__alltraps>

00101f9d <vector138>:
.globl vector138
vector138:
  pushl $0
  101f9d:	6a 00                	push   $0x0
  pushl $138
  101f9f:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  101fa4:	e9 e8 fa ff ff       	jmp    101a91 <__alltraps>

00101fa9 <vector139>:
.globl vector139
vector139:
  pushl $0
  101fa9:	6a 00                	push   $0x0
  pushl $139
  101fab:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  101fb0:	e9 dc fa ff ff       	jmp    101a91 <__alltraps>

00101fb5 <vector140>:
.globl vector140
vector140:
  pushl $0
  101fb5:	6a 00                	push   $0x0
  pushl $140
  101fb7:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  101fbc:	e9 d0 fa ff ff       	jmp    101a91 <__alltraps>

00101fc1 <vector141>:
.globl vector141
vector141:
  pushl $0
  101fc1:	6a 00                	push   $0x0
  pushl $141
  101fc3:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  101fc8:	e9 c4 fa ff ff       	jmp    101a91 <__alltraps>

00101fcd <vector142>:
.globl vector142
vector142:
  pushl $0
  101fcd:	6a 00                	push   $0x0
  pushl $142
  101fcf:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  101fd4:	e9 b8 fa ff ff       	jmp    101a91 <__alltraps>

00101fd9 <vector143>:
.globl vector143
vector143:
  pushl $0
  101fd9:	6a 00                	push   $0x0
  pushl $143
  101fdb:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  101fe0:	e9 ac fa ff ff       	jmp    101a91 <__alltraps>

00101fe5 <vector144>:
.globl vector144
vector144:
  pushl $0
  101fe5:	6a 00                	push   $0x0
  pushl $144
  101fe7:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  101fec:	e9 a0 fa ff ff       	jmp    101a91 <__alltraps>

00101ff1 <vector145>:
.globl vector145
vector145:
  pushl $0
  101ff1:	6a 00                	push   $0x0
  pushl $145
  101ff3:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  101ff8:	e9 94 fa ff ff       	jmp    101a91 <__alltraps>

00101ffd <vector146>:
.globl vector146
vector146:
  pushl $0
  101ffd:	6a 00                	push   $0x0
  pushl $146
  101fff:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102004:	e9 88 fa ff ff       	jmp    101a91 <__alltraps>

00102009 <vector147>:
.globl vector147
vector147:
  pushl $0
  102009:	6a 00                	push   $0x0
  pushl $147
  10200b:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102010:	e9 7c fa ff ff       	jmp    101a91 <__alltraps>

00102015 <vector148>:
.globl vector148
vector148:
  pushl $0
  102015:	6a 00                	push   $0x0
  pushl $148
  102017:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10201c:	e9 70 fa ff ff       	jmp    101a91 <__alltraps>

00102021 <vector149>:
.globl vector149
vector149:
  pushl $0
  102021:	6a 00                	push   $0x0
  pushl $149
  102023:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102028:	e9 64 fa ff ff       	jmp    101a91 <__alltraps>

0010202d <vector150>:
.globl vector150
vector150:
  pushl $0
  10202d:	6a 00                	push   $0x0
  pushl $150
  10202f:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102034:	e9 58 fa ff ff       	jmp    101a91 <__alltraps>

00102039 <vector151>:
.globl vector151
vector151:
  pushl $0
  102039:	6a 00                	push   $0x0
  pushl $151
  10203b:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102040:	e9 4c fa ff ff       	jmp    101a91 <__alltraps>

00102045 <vector152>:
.globl vector152
vector152:
  pushl $0
  102045:	6a 00                	push   $0x0
  pushl $152
  102047:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10204c:	e9 40 fa ff ff       	jmp    101a91 <__alltraps>

00102051 <vector153>:
.globl vector153
vector153:
  pushl $0
  102051:	6a 00                	push   $0x0
  pushl $153
  102053:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102058:	e9 34 fa ff ff       	jmp    101a91 <__alltraps>

0010205d <vector154>:
.globl vector154
vector154:
  pushl $0
  10205d:	6a 00                	push   $0x0
  pushl $154
  10205f:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102064:	e9 28 fa ff ff       	jmp    101a91 <__alltraps>

00102069 <vector155>:
.globl vector155
vector155:
  pushl $0
  102069:	6a 00                	push   $0x0
  pushl $155
  10206b:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102070:	e9 1c fa ff ff       	jmp    101a91 <__alltraps>

00102075 <vector156>:
.globl vector156
vector156:
  pushl $0
  102075:	6a 00                	push   $0x0
  pushl $156
  102077:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10207c:	e9 10 fa ff ff       	jmp    101a91 <__alltraps>

00102081 <vector157>:
.globl vector157
vector157:
  pushl $0
  102081:	6a 00                	push   $0x0
  pushl $157
  102083:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102088:	e9 04 fa ff ff       	jmp    101a91 <__alltraps>

0010208d <vector158>:
.globl vector158
vector158:
  pushl $0
  10208d:	6a 00                	push   $0x0
  pushl $158
  10208f:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102094:	e9 f8 f9 ff ff       	jmp    101a91 <__alltraps>

00102099 <vector159>:
.globl vector159
vector159:
  pushl $0
  102099:	6a 00                	push   $0x0
  pushl $159
  10209b:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1020a0:	e9 ec f9 ff ff       	jmp    101a91 <__alltraps>

001020a5 <vector160>:
.globl vector160
vector160:
  pushl $0
  1020a5:	6a 00                	push   $0x0
  pushl $160
  1020a7:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1020ac:	e9 e0 f9 ff ff       	jmp    101a91 <__alltraps>

001020b1 <vector161>:
.globl vector161
vector161:
  pushl $0
  1020b1:	6a 00                	push   $0x0
  pushl $161
  1020b3:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1020b8:	e9 d4 f9 ff ff       	jmp    101a91 <__alltraps>

001020bd <vector162>:
.globl vector162
vector162:
  pushl $0
  1020bd:	6a 00                	push   $0x0
  pushl $162
  1020bf:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1020c4:	e9 c8 f9 ff ff       	jmp    101a91 <__alltraps>

001020c9 <vector163>:
.globl vector163
vector163:
  pushl $0
  1020c9:	6a 00                	push   $0x0
  pushl $163
  1020cb:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1020d0:	e9 bc f9 ff ff       	jmp    101a91 <__alltraps>

001020d5 <vector164>:
.globl vector164
vector164:
  pushl $0
  1020d5:	6a 00                	push   $0x0
  pushl $164
  1020d7:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1020dc:	e9 b0 f9 ff ff       	jmp    101a91 <__alltraps>

001020e1 <vector165>:
.globl vector165
vector165:
  pushl $0
  1020e1:	6a 00                	push   $0x0
  pushl $165
  1020e3:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1020e8:	e9 a4 f9 ff ff       	jmp    101a91 <__alltraps>

001020ed <vector166>:
.globl vector166
vector166:
  pushl $0
  1020ed:	6a 00                	push   $0x0
  pushl $166
  1020ef:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1020f4:	e9 98 f9 ff ff       	jmp    101a91 <__alltraps>

001020f9 <vector167>:
.globl vector167
vector167:
  pushl $0
  1020f9:	6a 00                	push   $0x0
  pushl $167
  1020fb:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102100:	e9 8c f9 ff ff       	jmp    101a91 <__alltraps>

00102105 <vector168>:
.globl vector168
vector168:
  pushl $0
  102105:	6a 00                	push   $0x0
  pushl $168
  102107:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10210c:	e9 80 f9 ff ff       	jmp    101a91 <__alltraps>

00102111 <vector169>:
.globl vector169
vector169:
  pushl $0
  102111:	6a 00                	push   $0x0
  pushl $169
  102113:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102118:	e9 74 f9 ff ff       	jmp    101a91 <__alltraps>

0010211d <vector170>:
.globl vector170
vector170:
  pushl $0
  10211d:	6a 00                	push   $0x0
  pushl $170
  10211f:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102124:	e9 68 f9 ff ff       	jmp    101a91 <__alltraps>

00102129 <vector171>:
.globl vector171
vector171:
  pushl $0
  102129:	6a 00                	push   $0x0
  pushl $171
  10212b:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102130:	e9 5c f9 ff ff       	jmp    101a91 <__alltraps>

00102135 <vector172>:
.globl vector172
vector172:
  pushl $0
  102135:	6a 00                	push   $0x0
  pushl $172
  102137:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10213c:	e9 50 f9 ff ff       	jmp    101a91 <__alltraps>

00102141 <vector173>:
.globl vector173
vector173:
  pushl $0
  102141:	6a 00                	push   $0x0
  pushl $173
  102143:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102148:	e9 44 f9 ff ff       	jmp    101a91 <__alltraps>

0010214d <vector174>:
.globl vector174
vector174:
  pushl $0
  10214d:	6a 00                	push   $0x0
  pushl $174
  10214f:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102154:	e9 38 f9 ff ff       	jmp    101a91 <__alltraps>

00102159 <vector175>:
.globl vector175
vector175:
  pushl $0
  102159:	6a 00                	push   $0x0
  pushl $175
  10215b:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102160:	e9 2c f9 ff ff       	jmp    101a91 <__alltraps>

00102165 <vector176>:
.globl vector176
vector176:
  pushl $0
  102165:	6a 00                	push   $0x0
  pushl $176
  102167:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10216c:	e9 20 f9 ff ff       	jmp    101a91 <__alltraps>

00102171 <vector177>:
.globl vector177
vector177:
  pushl $0
  102171:	6a 00                	push   $0x0
  pushl $177
  102173:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102178:	e9 14 f9 ff ff       	jmp    101a91 <__alltraps>

0010217d <vector178>:
.globl vector178
vector178:
  pushl $0
  10217d:	6a 00                	push   $0x0
  pushl $178
  10217f:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102184:	e9 08 f9 ff ff       	jmp    101a91 <__alltraps>

00102189 <vector179>:
.globl vector179
vector179:
  pushl $0
  102189:	6a 00                	push   $0x0
  pushl $179
  10218b:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102190:	e9 fc f8 ff ff       	jmp    101a91 <__alltraps>

00102195 <vector180>:
.globl vector180
vector180:
  pushl $0
  102195:	6a 00                	push   $0x0
  pushl $180
  102197:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10219c:	e9 f0 f8 ff ff       	jmp    101a91 <__alltraps>

001021a1 <vector181>:
.globl vector181
vector181:
  pushl $0
  1021a1:	6a 00                	push   $0x0
  pushl $181
  1021a3:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1021a8:	e9 e4 f8 ff ff       	jmp    101a91 <__alltraps>

001021ad <vector182>:
.globl vector182
vector182:
  pushl $0
  1021ad:	6a 00                	push   $0x0
  pushl $182
  1021af:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1021b4:	e9 d8 f8 ff ff       	jmp    101a91 <__alltraps>

001021b9 <vector183>:
.globl vector183
vector183:
  pushl $0
  1021b9:	6a 00                	push   $0x0
  pushl $183
  1021bb:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1021c0:	e9 cc f8 ff ff       	jmp    101a91 <__alltraps>

001021c5 <vector184>:
.globl vector184
vector184:
  pushl $0
  1021c5:	6a 00                	push   $0x0
  pushl $184
  1021c7:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1021cc:	e9 c0 f8 ff ff       	jmp    101a91 <__alltraps>

001021d1 <vector185>:
.globl vector185
vector185:
  pushl $0
  1021d1:	6a 00                	push   $0x0
  pushl $185
  1021d3:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1021d8:	e9 b4 f8 ff ff       	jmp    101a91 <__alltraps>

001021dd <vector186>:
.globl vector186
vector186:
  pushl $0
  1021dd:	6a 00                	push   $0x0
  pushl $186
  1021df:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1021e4:	e9 a8 f8 ff ff       	jmp    101a91 <__alltraps>

001021e9 <vector187>:
.globl vector187
vector187:
  pushl $0
  1021e9:	6a 00                	push   $0x0
  pushl $187
  1021eb:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1021f0:	e9 9c f8 ff ff       	jmp    101a91 <__alltraps>

001021f5 <vector188>:
.globl vector188
vector188:
  pushl $0
  1021f5:	6a 00                	push   $0x0
  pushl $188
  1021f7:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1021fc:	e9 90 f8 ff ff       	jmp    101a91 <__alltraps>

00102201 <vector189>:
.globl vector189
vector189:
  pushl $0
  102201:	6a 00                	push   $0x0
  pushl $189
  102203:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102208:	e9 84 f8 ff ff       	jmp    101a91 <__alltraps>

0010220d <vector190>:
.globl vector190
vector190:
  pushl $0
  10220d:	6a 00                	push   $0x0
  pushl $190
  10220f:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102214:	e9 78 f8 ff ff       	jmp    101a91 <__alltraps>

00102219 <vector191>:
.globl vector191
vector191:
  pushl $0
  102219:	6a 00                	push   $0x0
  pushl $191
  10221b:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102220:	e9 6c f8 ff ff       	jmp    101a91 <__alltraps>

00102225 <vector192>:
.globl vector192
vector192:
  pushl $0
  102225:	6a 00                	push   $0x0
  pushl $192
  102227:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  10222c:	e9 60 f8 ff ff       	jmp    101a91 <__alltraps>

00102231 <vector193>:
.globl vector193
vector193:
  pushl $0
  102231:	6a 00                	push   $0x0
  pushl $193
  102233:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102238:	e9 54 f8 ff ff       	jmp    101a91 <__alltraps>

0010223d <vector194>:
.globl vector194
vector194:
  pushl $0
  10223d:	6a 00                	push   $0x0
  pushl $194
  10223f:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102244:	e9 48 f8 ff ff       	jmp    101a91 <__alltraps>

00102249 <vector195>:
.globl vector195
vector195:
  pushl $0
  102249:	6a 00                	push   $0x0
  pushl $195
  10224b:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102250:	e9 3c f8 ff ff       	jmp    101a91 <__alltraps>

00102255 <vector196>:
.globl vector196
vector196:
  pushl $0
  102255:	6a 00                	push   $0x0
  pushl $196
  102257:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10225c:	e9 30 f8 ff ff       	jmp    101a91 <__alltraps>

00102261 <vector197>:
.globl vector197
vector197:
  pushl $0
  102261:	6a 00                	push   $0x0
  pushl $197
  102263:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102268:	e9 24 f8 ff ff       	jmp    101a91 <__alltraps>

0010226d <vector198>:
.globl vector198
vector198:
  pushl $0
  10226d:	6a 00                	push   $0x0
  pushl $198
  10226f:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102274:	e9 18 f8 ff ff       	jmp    101a91 <__alltraps>

00102279 <vector199>:
.globl vector199
vector199:
  pushl $0
  102279:	6a 00                	push   $0x0
  pushl $199
  10227b:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102280:	e9 0c f8 ff ff       	jmp    101a91 <__alltraps>

00102285 <vector200>:
.globl vector200
vector200:
  pushl $0
  102285:	6a 00                	push   $0x0
  pushl $200
  102287:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10228c:	e9 00 f8 ff ff       	jmp    101a91 <__alltraps>

00102291 <vector201>:
.globl vector201
vector201:
  pushl $0
  102291:	6a 00                	push   $0x0
  pushl $201
  102293:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102298:	e9 f4 f7 ff ff       	jmp    101a91 <__alltraps>

0010229d <vector202>:
.globl vector202
vector202:
  pushl $0
  10229d:	6a 00                	push   $0x0
  pushl $202
  10229f:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1022a4:	e9 e8 f7 ff ff       	jmp    101a91 <__alltraps>

001022a9 <vector203>:
.globl vector203
vector203:
  pushl $0
  1022a9:	6a 00                	push   $0x0
  pushl $203
  1022ab:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1022b0:	e9 dc f7 ff ff       	jmp    101a91 <__alltraps>

001022b5 <vector204>:
.globl vector204
vector204:
  pushl $0
  1022b5:	6a 00                	push   $0x0
  pushl $204
  1022b7:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1022bc:	e9 d0 f7 ff ff       	jmp    101a91 <__alltraps>

001022c1 <vector205>:
.globl vector205
vector205:
  pushl $0
  1022c1:	6a 00                	push   $0x0
  pushl $205
  1022c3:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1022c8:	e9 c4 f7 ff ff       	jmp    101a91 <__alltraps>

001022cd <vector206>:
.globl vector206
vector206:
  pushl $0
  1022cd:	6a 00                	push   $0x0
  pushl $206
  1022cf:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1022d4:	e9 b8 f7 ff ff       	jmp    101a91 <__alltraps>

001022d9 <vector207>:
.globl vector207
vector207:
  pushl $0
  1022d9:	6a 00                	push   $0x0
  pushl $207
  1022db:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1022e0:	e9 ac f7 ff ff       	jmp    101a91 <__alltraps>

001022e5 <vector208>:
.globl vector208
vector208:
  pushl $0
  1022e5:	6a 00                	push   $0x0
  pushl $208
  1022e7:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1022ec:	e9 a0 f7 ff ff       	jmp    101a91 <__alltraps>

001022f1 <vector209>:
.globl vector209
vector209:
  pushl $0
  1022f1:	6a 00                	push   $0x0
  pushl $209
  1022f3:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1022f8:	e9 94 f7 ff ff       	jmp    101a91 <__alltraps>

001022fd <vector210>:
.globl vector210
vector210:
  pushl $0
  1022fd:	6a 00                	push   $0x0
  pushl $210
  1022ff:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102304:	e9 88 f7 ff ff       	jmp    101a91 <__alltraps>

00102309 <vector211>:
.globl vector211
vector211:
  pushl $0
  102309:	6a 00                	push   $0x0
  pushl $211
  10230b:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102310:	e9 7c f7 ff ff       	jmp    101a91 <__alltraps>

00102315 <vector212>:
.globl vector212
vector212:
  pushl $0
  102315:	6a 00                	push   $0x0
  pushl $212
  102317:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  10231c:	e9 70 f7 ff ff       	jmp    101a91 <__alltraps>

00102321 <vector213>:
.globl vector213
vector213:
  pushl $0
  102321:	6a 00                	push   $0x0
  pushl $213
  102323:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102328:	e9 64 f7 ff ff       	jmp    101a91 <__alltraps>

0010232d <vector214>:
.globl vector214
vector214:
  pushl $0
  10232d:	6a 00                	push   $0x0
  pushl $214
  10232f:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102334:	e9 58 f7 ff ff       	jmp    101a91 <__alltraps>

00102339 <vector215>:
.globl vector215
vector215:
  pushl $0
  102339:	6a 00                	push   $0x0
  pushl $215
  10233b:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102340:	e9 4c f7 ff ff       	jmp    101a91 <__alltraps>

00102345 <vector216>:
.globl vector216
vector216:
  pushl $0
  102345:	6a 00                	push   $0x0
  pushl $216
  102347:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10234c:	e9 40 f7 ff ff       	jmp    101a91 <__alltraps>

00102351 <vector217>:
.globl vector217
vector217:
  pushl $0
  102351:	6a 00                	push   $0x0
  pushl $217
  102353:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102358:	e9 34 f7 ff ff       	jmp    101a91 <__alltraps>

0010235d <vector218>:
.globl vector218
vector218:
  pushl $0
  10235d:	6a 00                	push   $0x0
  pushl $218
  10235f:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102364:	e9 28 f7 ff ff       	jmp    101a91 <__alltraps>

00102369 <vector219>:
.globl vector219
vector219:
  pushl $0
  102369:	6a 00                	push   $0x0
  pushl $219
  10236b:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102370:	e9 1c f7 ff ff       	jmp    101a91 <__alltraps>

00102375 <vector220>:
.globl vector220
vector220:
  pushl $0
  102375:	6a 00                	push   $0x0
  pushl $220
  102377:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10237c:	e9 10 f7 ff ff       	jmp    101a91 <__alltraps>

00102381 <vector221>:
.globl vector221
vector221:
  pushl $0
  102381:	6a 00                	push   $0x0
  pushl $221
  102383:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102388:	e9 04 f7 ff ff       	jmp    101a91 <__alltraps>

0010238d <vector222>:
.globl vector222
vector222:
  pushl $0
  10238d:	6a 00                	push   $0x0
  pushl $222
  10238f:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102394:	e9 f8 f6 ff ff       	jmp    101a91 <__alltraps>

00102399 <vector223>:
.globl vector223
vector223:
  pushl $0
  102399:	6a 00                	push   $0x0
  pushl $223
  10239b:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1023a0:	e9 ec f6 ff ff       	jmp    101a91 <__alltraps>

001023a5 <vector224>:
.globl vector224
vector224:
  pushl $0
  1023a5:	6a 00                	push   $0x0
  pushl $224
  1023a7:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1023ac:	e9 e0 f6 ff ff       	jmp    101a91 <__alltraps>

001023b1 <vector225>:
.globl vector225
vector225:
  pushl $0
  1023b1:	6a 00                	push   $0x0
  pushl $225
  1023b3:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1023b8:	e9 d4 f6 ff ff       	jmp    101a91 <__alltraps>

001023bd <vector226>:
.globl vector226
vector226:
  pushl $0
  1023bd:	6a 00                	push   $0x0
  pushl $226
  1023bf:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1023c4:	e9 c8 f6 ff ff       	jmp    101a91 <__alltraps>

001023c9 <vector227>:
.globl vector227
vector227:
  pushl $0
  1023c9:	6a 00                	push   $0x0
  pushl $227
  1023cb:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1023d0:	e9 bc f6 ff ff       	jmp    101a91 <__alltraps>

001023d5 <vector228>:
.globl vector228
vector228:
  pushl $0
  1023d5:	6a 00                	push   $0x0
  pushl $228
  1023d7:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1023dc:	e9 b0 f6 ff ff       	jmp    101a91 <__alltraps>

001023e1 <vector229>:
.globl vector229
vector229:
  pushl $0
  1023e1:	6a 00                	push   $0x0
  pushl $229
  1023e3:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1023e8:	e9 a4 f6 ff ff       	jmp    101a91 <__alltraps>

001023ed <vector230>:
.globl vector230
vector230:
  pushl $0
  1023ed:	6a 00                	push   $0x0
  pushl $230
  1023ef:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1023f4:	e9 98 f6 ff ff       	jmp    101a91 <__alltraps>

001023f9 <vector231>:
.globl vector231
vector231:
  pushl $0
  1023f9:	6a 00                	push   $0x0
  pushl $231
  1023fb:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102400:	e9 8c f6 ff ff       	jmp    101a91 <__alltraps>

00102405 <vector232>:
.globl vector232
vector232:
  pushl $0
  102405:	6a 00                	push   $0x0
  pushl $232
  102407:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  10240c:	e9 80 f6 ff ff       	jmp    101a91 <__alltraps>

00102411 <vector233>:
.globl vector233
vector233:
  pushl $0
  102411:	6a 00                	push   $0x0
  pushl $233
  102413:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102418:	e9 74 f6 ff ff       	jmp    101a91 <__alltraps>

0010241d <vector234>:
.globl vector234
vector234:
  pushl $0
  10241d:	6a 00                	push   $0x0
  pushl $234
  10241f:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102424:	e9 68 f6 ff ff       	jmp    101a91 <__alltraps>

00102429 <vector235>:
.globl vector235
vector235:
  pushl $0
  102429:	6a 00                	push   $0x0
  pushl $235
  10242b:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102430:	e9 5c f6 ff ff       	jmp    101a91 <__alltraps>

00102435 <vector236>:
.globl vector236
vector236:
  pushl $0
  102435:	6a 00                	push   $0x0
  pushl $236
  102437:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  10243c:	e9 50 f6 ff ff       	jmp    101a91 <__alltraps>

00102441 <vector237>:
.globl vector237
vector237:
  pushl $0
  102441:	6a 00                	push   $0x0
  pushl $237
  102443:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102448:	e9 44 f6 ff ff       	jmp    101a91 <__alltraps>

0010244d <vector238>:
.globl vector238
vector238:
  pushl $0
  10244d:	6a 00                	push   $0x0
  pushl $238
  10244f:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102454:	e9 38 f6 ff ff       	jmp    101a91 <__alltraps>

00102459 <vector239>:
.globl vector239
vector239:
  pushl $0
  102459:	6a 00                	push   $0x0
  pushl $239
  10245b:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102460:	e9 2c f6 ff ff       	jmp    101a91 <__alltraps>

00102465 <vector240>:
.globl vector240
vector240:
  pushl $0
  102465:	6a 00                	push   $0x0
  pushl $240
  102467:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  10246c:	e9 20 f6 ff ff       	jmp    101a91 <__alltraps>

00102471 <vector241>:
.globl vector241
vector241:
  pushl $0
  102471:	6a 00                	push   $0x0
  pushl $241
  102473:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102478:	e9 14 f6 ff ff       	jmp    101a91 <__alltraps>

0010247d <vector242>:
.globl vector242
vector242:
  pushl $0
  10247d:	6a 00                	push   $0x0
  pushl $242
  10247f:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102484:	e9 08 f6 ff ff       	jmp    101a91 <__alltraps>

00102489 <vector243>:
.globl vector243
vector243:
  pushl $0
  102489:	6a 00                	push   $0x0
  pushl $243
  10248b:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102490:	e9 fc f5 ff ff       	jmp    101a91 <__alltraps>

00102495 <vector244>:
.globl vector244
vector244:
  pushl $0
  102495:	6a 00                	push   $0x0
  pushl $244
  102497:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  10249c:	e9 f0 f5 ff ff       	jmp    101a91 <__alltraps>

001024a1 <vector245>:
.globl vector245
vector245:
  pushl $0
  1024a1:	6a 00                	push   $0x0
  pushl $245
  1024a3:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1024a8:	e9 e4 f5 ff ff       	jmp    101a91 <__alltraps>

001024ad <vector246>:
.globl vector246
vector246:
  pushl $0
  1024ad:	6a 00                	push   $0x0
  pushl $246
  1024af:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1024b4:	e9 d8 f5 ff ff       	jmp    101a91 <__alltraps>

001024b9 <vector247>:
.globl vector247
vector247:
  pushl $0
  1024b9:	6a 00                	push   $0x0
  pushl $247
  1024bb:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1024c0:	e9 cc f5 ff ff       	jmp    101a91 <__alltraps>

001024c5 <vector248>:
.globl vector248
vector248:
  pushl $0
  1024c5:	6a 00                	push   $0x0
  pushl $248
  1024c7:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1024cc:	e9 c0 f5 ff ff       	jmp    101a91 <__alltraps>

001024d1 <vector249>:
.globl vector249
vector249:
  pushl $0
  1024d1:	6a 00                	push   $0x0
  pushl $249
  1024d3:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1024d8:	e9 b4 f5 ff ff       	jmp    101a91 <__alltraps>

001024dd <vector250>:
.globl vector250
vector250:
  pushl $0
  1024dd:	6a 00                	push   $0x0
  pushl $250
  1024df:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1024e4:	e9 a8 f5 ff ff       	jmp    101a91 <__alltraps>

001024e9 <vector251>:
.globl vector251
vector251:
  pushl $0
  1024e9:	6a 00                	push   $0x0
  pushl $251
  1024eb:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1024f0:	e9 9c f5 ff ff       	jmp    101a91 <__alltraps>

001024f5 <vector252>:
.globl vector252
vector252:
  pushl $0
  1024f5:	6a 00                	push   $0x0
  pushl $252
  1024f7:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1024fc:	e9 90 f5 ff ff       	jmp    101a91 <__alltraps>

00102501 <vector253>:
.globl vector253
vector253:
  pushl $0
  102501:	6a 00                	push   $0x0
  pushl $253
  102503:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102508:	e9 84 f5 ff ff       	jmp    101a91 <__alltraps>

0010250d <vector254>:
.globl vector254
vector254:
  pushl $0
  10250d:	6a 00                	push   $0x0
  pushl $254
  10250f:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102514:	e9 78 f5 ff ff       	jmp    101a91 <__alltraps>

00102519 <vector255>:
.globl vector255
vector255:
  pushl $0
  102519:	6a 00                	push   $0x0
  pushl $255
  10251b:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102520:	e9 6c f5 ff ff       	jmp    101a91 <__alltraps>

00102525 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102525:	55                   	push   %ebp
  102526:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102528:	8b 45 08             	mov    0x8(%ebp),%eax
  10252b:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  10252e:	b8 23 00 00 00       	mov    $0x23,%eax
  102533:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102535:	b8 23 00 00 00       	mov    $0x23,%eax
  10253a:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  10253c:	b8 10 00 00 00       	mov    $0x10,%eax
  102541:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102543:	b8 10 00 00 00       	mov    $0x10,%eax
  102548:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  10254a:	b8 10 00 00 00       	mov    $0x10,%eax
  10254f:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102551:	ea 58 25 10 00 08 00 	ljmp   $0x8,$0x102558
}
  102558:	90                   	nop
  102559:	5d                   	pop    %ebp
  10255a:	c3                   	ret    

0010255b <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  10255b:	55                   	push   %ebp
  10255c:	89 e5                	mov    %esp,%ebp
  10255e:	83 ec 10             	sub    $0x10,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102561:	b8 20 09 11 00       	mov    $0x110920,%eax
  102566:	05 00 04 00 00       	add    $0x400,%eax
  10256b:	a3 a4 08 11 00       	mov    %eax,0x1108a4
    ts.ts_ss0 = KERNEL_DS;
  102570:	66 c7 05 a8 08 11 00 	movw   $0x10,0x1108a8
  102577:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102579:	66 c7 05 08 fa 10 00 	movw   $0x68,0x10fa08
  102580:	68 00 
  102582:	b8 a0 08 11 00       	mov    $0x1108a0,%eax
  102587:	66 a3 0a fa 10 00    	mov    %ax,0x10fa0a
  10258d:	b8 a0 08 11 00       	mov    $0x1108a0,%eax
  102592:	c1 e8 10             	shr    $0x10,%eax
  102595:	a2 0c fa 10 00       	mov    %al,0x10fa0c
  10259a:	a0 0d fa 10 00       	mov    0x10fa0d,%al
  10259f:	83 e0 f0             	and    $0xfffffff0,%eax
  1025a2:	83 c8 09             	or     $0x9,%eax
  1025a5:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  1025aa:	a0 0d fa 10 00       	mov    0x10fa0d,%al
  1025af:	83 c8 10             	or     $0x10,%eax
  1025b2:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  1025b7:	a0 0d fa 10 00       	mov    0x10fa0d,%al
  1025bc:	83 e0 9f             	and    $0xffffff9f,%eax
  1025bf:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  1025c4:	a0 0d fa 10 00       	mov    0x10fa0d,%al
  1025c9:	83 c8 80             	or     $0xffffff80,%eax
  1025cc:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  1025d1:	a0 0e fa 10 00       	mov    0x10fa0e,%al
  1025d6:	83 e0 f0             	and    $0xfffffff0,%eax
  1025d9:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  1025de:	a0 0e fa 10 00       	mov    0x10fa0e,%al
  1025e3:	83 e0 ef             	and    $0xffffffef,%eax
  1025e6:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  1025eb:	a0 0e fa 10 00       	mov    0x10fa0e,%al
  1025f0:	83 e0 df             	and    $0xffffffdf,%eax
  1025f3:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  1025f8:	a0 0e fa 10 00       	mov    0x10fa0e,%al
  1025fd:	83 c8 40             	or     $0x40,%eax
  102600:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102605:	a0 0e fa 10 00       	mov    0x10fa0e,%al
  10260a:	83 e0 7f             	and    $0x7f,%eax
  10260d:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102612:	b8 a0 08 11 00       	mov    $0x1108a0,%eax
  102617:	c1 e8 18             	shr    $0x18,%eax
  10261a:	a2 0f fa 10 00       	mov    %al,0x10fa0f
    gdt[SEG_TSS].sd_s = 0;
  10261f:	a0 0d fa 10 00       	mov    0x10fa0d,%al
  102624:	83 e0 ef             	and    $0xffffffef,%eax
  102627:	a2 0d fa 10 00       	mov    %al,0x10fa0d

    // reload all segment registers
    lgdt(&gdt_pd);
  10262c:	68 10 fa 10 00       	push   $0x10fa10
  102631:	e8 ef fe ff ff       	call   102525 <lgdt>
  102636:	83 c4 04             	add    $0x4,%esp
  102639:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  10263f:	66 8b 45 fe          	mov    -0x2(%ebp),%ax
  102643:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102646:	90                   	nop
  102647:	c9                   	leave  
  102648:	c3                   	ret    

00102649 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102649:	55                   	push   %ebp
  10264a:	89 e5                	mov    %esp,%ebp
    gdt_init();
  10264c:	e8 0a ff ff ff       	call   10255b <gdt_init>
}
  102651:	90                   	nop
  102652:	5d                   	pop    %ebp
  102653:	c3                   	ret    

00102654 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102654:	55                   	push   %ebp
  102655:	89 e5                	mov    %esp,%ebp
  102657:	83 ec 38             	sub    $0x38,%esp
  10265a:	8b 45 10             	mov    0x10(%ebp),%eax
  10265d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102660:	8b 45 14             	mov    0x14(%ebp),%eax
  102663:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102666:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102669:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10266c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10266f:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102672:	8b 45 18             	mov    0x18(%ebp),%eax
  102675:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102678:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10267b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10267e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102681:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102684:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102687:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10268a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10268e:	74 1c                	je     1026ac <printnum+0x58>
  102690:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102693:	ba 00 00 00 00       	mov    $0x0,%edx
  102698:	f7 75 e4             	divl   -0x1c(%ebp)
  10269b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10269e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1026a1:	ba 00 00 00 00       	mov    $0x0,%edx
  1026a6:	f7 75 e4             	divl   -0x1c(%ebp)
  1026a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1026ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1026af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1026b2:	f7 75 e4             	divl   -0x1c(%ebp)
  1026b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1026b8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1026bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1026be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1026c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1026c4:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1026c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1026ca:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1026cd:	8b 45 18             	mov    0x18(%ebp),%eax
  1026d0:	ba 00 00 00 00       	mov    $0x0,%edx
  1026d5:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1026d8:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  1026db:	19 d1                	sbb    %edx,%ecx
  1026dd:	72 35                	jb     102714 <printnum+0xc0>
        printnum(putch, putdat, result, base, width - 1, padc);
  1026df:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1026e2:	48                   	dec    %eax
  1026e3:	83 ec 04             	sub    $0x4,%esp
  1026e6:	ff 75 20             	pushl  0x20(%ebp)
  1026e9:	50                   	push   %eax
  1026ea:	ff 75 18             	pushl  0x18(%ebp)
  1026ed:	ff 75 ec             	pushl  -0x14(%ebp)
  1026f0:	ff 75 e8             	pushl  -0x18(%ebp)
  1026f3:	ff 75 0c             	pushl  0xc(%ebp)
  1026f6:	ff 75 08             	pushl  0x8(%ebp)
  1026f9:	e8 56 ff ff ff       	call   102654 <printnum>
  1026fe:	83 c4 20             	add    $0x20,%esp
  102701:	eb 1a                	jmp    10271d <printnum+0xc9>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102703:	83 ec 08             	sub    $0x8,%esp
  102706:	ff 75 0c             	pushl  0xc(%ebp)
  102709:	ff 75 20             	pushl  0x20(%ebp)
  10270c:	8b 45 08             	mov    0x8(%ebp),%eax
  10270f:	ff d0                	call   *%eax
  102711:	83 c4 10             	add    $0x10,%esp
        while (-- width > 0)
  102714:	ff 4d 1c             	decl   0x1c(%ebp)
  102717:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10271b:	7f e6                	jg     102703 <printnum+0xaf>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  10271d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102720:	05 50 38 10 00       	add    $0x103850,%eax
  102725:	8a 00                	mov    (%eax),%al
  102727:	0f be c0             	movsbl %al,%eax
  10272a:	83 ec 08             	sub    $0x8,%esp
  10272d:	ff 75 0c             	pushl  0xc(%ebp)
  102730:	50                   	push   %eax
  102731:	8b 45 08             	mov    0x8(%ebp),%eax
  102734:	ff d0                	call   *%eax
  102736:	83 c4 10             	add    $0x10,%esp
}
  102739:	90                   	nop
  10273a:	c9                   	leave  
  10273b:	c3                   	ret    

0010273c <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  10273c:	55                   	push   %ebp
  10273d:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10273f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102743:	7e 14                	jle    102759 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102745:	8b 45 08             	mov    0x8(%ebp),%eax
  102748:	8b 00                	mov    (%eax),%eax
  10274a:	8d 48 08             	lea    0x8(%eax),%ecx
  10274d:	8b 55 08             	mov    0x8(%ebp),%edx
  102750:	89 0a                	mov    %ecx,(%edx)
  102752:	8b 50 04             	mov    0x4(%eax),%edx
  102755:	8b 00                	mov    (%eax),%eax
  102757:	eb 30                	jmp    102789 <getuint+0x4d>
    }
    else if (lflag) {
  102759:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10275d:	74 16                	je     102775 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  10275f:	8b 45 08             	mov    0x8(%ebp),%eax
  102762:	8b 00                	mov    (%eax),%eax
  102764:	8d 48 04             	lea    0x4(%eax),%ecx
  102767:	8b 55 08             	mov    0x8(%ebp),%edx
  10276a:	89 0a                	mov    %ecx,(%edx)
  10276c:	8b 00                	mov    (%eax),%eax
  10276e:	ba 00 00 00 00       	mov    $0x0,%edx
  102773:	eb 14                	jmp    102789 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102775:	8b 45 08             	mov    0x8(%ebp),%eax
  102778:	8b 00                	mov    (%eax),%eax
  10277a:	8d 48 04             	lea    0x4(%eax),%ecx
  10277d:	8b 55 08             	mov    0x8(%ebp),%edx
  102780:	89 0a                	mov    %ecx,(%edx)
  102782:	8b 00                	mov    (%eax),%eax
  102784:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102789:	5d                   	pop    %ebp
  10278a:	c3                   	ret    

0010278b <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  10278b:	55                   	push   %ebp
  10278c:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10278e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102792:	7e 14                	jle    1027a8 <getint+0x1d>
        return va_arg(*ap, long long);
  102794:	8b 45 08             	mov    0x8(%ebp),%eax
  102797:	8b 00                	mov    (%eax),%eax
  102799:	8d 48 08             	lea    0x8(%eax),%ecx
  10279c:	8b 55 08             	mov    0x8(%ebp),%edx
  10279f:	89 0a                	mov    %ecx,(%edx)
  1027a1:	8b 50 04             	mov    0x4(%eax),%edx
  1027a4:	8b 00                	mov    (%eax),%eax
  1027a6:	eb 28                	jmp    1027d0 <getint+0x45>
    }
    else if (lflag) {
  1027a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1027ac:	74 12                	je     1027c0 <getint+0x35>
        return va_arg(*ap, long);
  1027ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1027b1:	8b 00                	mov    (%eax),%eax
  1027b3:	8d 48 04             	lea    0x4(%eax),%ecx
  1027b6:	8b 55 08             	mov    0x8(%ebp),%edx
  1027b9:	89 0a                	mov    %ecx,(%edx)
  1027bb:	8b 00                	mov    (%eax),%eax
  1027bd:	99                   	cltd   
  1027be:	eb 10                	jmp    1027d0 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1027c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1027c3:	8b 00                	mov    (%eax),%eax
  1027c5:	8d 48 04             	lea    0x4(%eax),%ecx
  1027c8:	8b 55 08             	mov    0x8(%ebp),%edx
  1027cb:	89 0a                	mov    %ecx,(%edx)
  1027cd:	8b 00                	mov    (%eax),%eax
  1027cf:	99                   	cltd   
    }
}
  1027d0:	5d                   	pop    %ebp
  1027d1:	c3                   	ret    

001027d2 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1027d2:	55                   	push   %ebp
  1027d3:	89 e5                	mov    %esp,%ebp
  1027d5:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  1027d8:	8d 45 14             	lea    0x14(%ebp),%eax
  1027db:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1027de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1027e1:	50                   	push   %eax
  1027e2:	ff 75 10             	pushl  0x10(%ebp)
  1027e5:	ff 75 0c             	pushl  0xc(%ebp)
  1027e8:	ff 75 08             	pushl  0x8(%ebp)
  1027eb:	e8 06 00 00 00       	call   1027f6 <vprintfmt>
  1027f0:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  1027f3:	90                   	nop
  1027f4:	c9                   	leave  
  1027f5:	c3                   	ret    

001027f6 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1027f6:	55                   	push   %ebp
  1027f7:	89 e5                	mov    %esp,%ebp
  1027f9:	56                   	push   %esi
  1027fa:	53                   	push   %ebx
  1027fb:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1027fe:	eb 17                	jmp    102817 <vprintfmt+0x21>
            if (ch == '\0') {
  102800:	85 db                	test   %ebx,%ebx
  102802:	0f 84 7c 03 00 00    	je     102b84 <vprintfmt+0x38e>
                return;
            }
            putch(ch, putdat);
  102808:	83 ec 08             	sub    $0x8,%esp
  10280b:	ff 75 0c             	pushl  0xc(%ebp)
  10280e:	53                   	push   %ebx
  10280f:	8b 45 08             	mov    0x8(%ebp),%eax
  102812:	ff d0                	call   *%eax
  102814:	83 c4 10             	add    $0x10,%esp
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102817:	8b 45 10             	mov    0x10(%ebp),%eax
  10281a:	8d 50 01             	lea    0x1(%eax),%edx
  10281d:	89 55 10             	mov    %edx,0x10(%ebp)
  102820:	8a 00                	mov    (%eax),%al
  102822:	0f b6 d8             	movzbl %al,%ebx
  102825:	83 fb 25             	cmp    $0x25,%ebx
  102828:	75 d6                	jne    102800 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  10282a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  10282e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102835:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102838:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  10283b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102842:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102845:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102848:	8b 45 10             	mov    0x10(%ebp),%eax
  10284b:	8d 50 01             	lea    0x1(%eax),%edx
  10284e:	89 55 10             	mov    %edx,0x10(%ebp)
  102851:	8a 00                	mov    (%eax),%al
  102853:	0f b6 d8             	movzbl %al,%ebx
  102856:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102859:	83 f8 55             	cmp    $0x55,%eax
  10285c:	0f 87 fa 02 00 00    	ja     102b5c <vprintfmt+0x366>
  102862:	8b 04 85 74 38 10 00 	mov    0x103874(,%eax,4),%eax
  102869:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  10286b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  10286f:	eb d7                	jmp    102848 <vprintfmt+0x52>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102871:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102875:	eb d1                	jmp    102848 <vprintfmt+0x52>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102877:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  10287e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102881:	89 d0                	mov    %edx,%eax
  102883:	c1 e0 02             	shl    $0x2,%eax
  102886:	01 d0                	add    %edx,%eax
  102888:	01 c0                	add    %eax,%eax
  10288a:	01 d8                	add    %ebx,%eax
  10288c:	83 e8 30             	sub    $0x30,%eax
  10288f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102892:	8b 45 10             	mov    0x10(%ebp),%eax
  102895:	8a 00                	mov    (%eax),%al
  102897:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  10289a:	83 fb 2f             	cmp    $0x2f,%ebx
  10289d:	7e 35                	jle    1028d4 <vprintfmt+0xde>
  10289f:	83 fb 39             	cmp    $0x39,%ebx
  1028a2:	7f 30                	jg     1028d4 <vprintfmt+0xde>
            for (precision = 0; ; ++ fmt) {
  1028a4:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  1028a7:	eb d5                	jmp    10287e <vprintfmt+0x88>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  1028a9:	8b 45 14             	mov    0x14(%ebp),%eax
  1028ac:	8d 50 04             	lea    0x4(%eax),%edx
  1028af:	89 55 14             	mov    %edx,0x14(%ebp)
  1028b2:	8b 00                	mov    (%eax),%eax
  1028b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1028b7:	eb 1c                	jmp    1028d5 <vprintfmt+0xdf>

        case '.':
            if (width < 0)
  1028b9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1028bd:	79 89                	jns    102848 <vprintfmt+0x52>
                width = 0;
  1028bf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1028c6:	eb 80                	jmp    102848 <vprintfmt+0x52>

        case '#':
            altflag = 1;
  1028c8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1028cf:	e9 74 ff ff ff       	jmp    102848 <vprintfmt+0x52>
            goto process_precision;
  1028d4:	90                   	nop

        process_precision:
            if (width < 0)
  1028d5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1028d9:	0f 89 69 ff ff ff    	jns    102848 <vprintfmt+0x52>
                width = precision, precision = -1;
  1028df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1028e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1028e5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1028ec:	e9 57 ff ff ff       	jmp    102848 <vprintfmt+0x52>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1028f1:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  1028f4:	e9 4f ff ff ff       	jmp    102848 <vprintfmt+0x52>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1028f9:	8b 45 14             	mov    0x14(%ebp),%eax
  1028fc:	8d 50 04             	lea    0x4(%eax),%edx
  1028ff:	89 55 14             	mov    %edx,0x14(%ebp)
  102902:	8b 00                	mov    (%eax),%eax
  102904:	83 ec 08             	sub    $0x8,%esp
  102907:	ff 75 0c             	pushl  0xc(%ebp)
  10290a:	50                   	push   %eax
  10290b:	8b 45 08             	mov    0x8(%ebp),%eax
  10290e:	ff d0                	call   *%eax
  102910:	83 c4 10             	add    $0x10,%esp
            break;
  102913:	e9 67 02 00 00       	jmp    102b7f <vprintfmt+0x389>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102918:	8b 45 14             	mov    0x14(%ebp),%eax
  10291b:	8d 50 04             	lea    0x4(%eax),%edx
  10291e:	89 55 14             	mov    %edx,0x14(%ebp)
  102921:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102923:	85 db                	test   %ebx,%ebx
  102925:	79 02                	jns    102929 <vprintfmt+0x133>
                err = -err;
  102927:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102929:	83 fb 06             	cmp    $0x6,%ebx
  10292c:	7f 0b                	jg     102939 <vprintfmt+0x143>
  10292e:	8b 34 9d 34 38 10 00 	mov    0x103834(,%ebx,4),%esi
  102935:	85 f6                	test   %esi,%esi
  102937:	75 19                	jne    102952 <vprintfmt+0x15c>
                printfmt(putch, putdat, "error %d", err);
  102939:	53                   	push   %ebx
  10293a:	68 61 38 10 00       	push   $0x103861
  10293f:	ff 75 0c             	pushl  0xc(%ebp)
  102942:	ff 75 08             	pushl  0x8(%ebp)
  102945:	e8 88 fe ff ff       	call   1027d2 <printfmt>
  10294a:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  10294d:	e9 2d 02 00 00       	jmp    102b7f <vprintfmt+0x389>
                printfmt(putch, putdat, "%s", p);
  102952:	56                   	push   %esi
  102953:	68 6a 38 10 00       	push   $0x10386a
  102958:	ff 75 0c             	pushl  0xc(%ebp)
  10295b:	ff 75 08             	pushl  0x8(%ebp)
  10295e:	e8 6f fe ff ff       	call   1027d2 <printfmt>
  102963:	83 c4 10             	add    $0x10,%esp
            break;
  102966:	e9 14 02 00 00       	jmp    102b7f <vprintfmt+0x389>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  10296b:	8b 45 14             	mov    0x14(%ebp),%eax
  10296e:	8d 50 04             	lea    0x4(%eax),%edx
  102971:	89 55 14             	mov    %edx,0x14(%ebp)
  102974:	8b 30                	mov    (%eax),%esi
  102976:	85 f6                	test   %esi,%esi
  102978:	75 05                	jne    10297f <vprintfmt+0x189>
                p = "(null)";
  10297a:	be 6d 38 10 00       	mov    $0x10386d,%esi
            }
            if (width > 0 && padc != '-') {
  10297f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102983:	7e 74                	jle    1029f9 <vprintfmt+0x203>
  102985:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102989:	74 6e                	je     1029f9 <vprintfmt+0x203>
                for (width -= strnlen(p, precision); width > 0; width --) {
  10298b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10298e:	83 ec 08             	sub    $0x8,%esp
  102991:	50                   	push   %eax
  102992:	56                   	push   %esi
  102993:	e8 d3 02 00 00       	call   102c6b <strnlen>
  102998:	83 c4 10             	add    $0x10,%esp
  10299b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10299e:	29 c2                	sub    %eax,%edx
  1029a0:	89 d0                	mov    %edx,%eax
  1029a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1029a5:	eb 16                	jmp    1029bd <vprintfmt+0x1c7>
                    putch(padc, putdat);
  1029a7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1029ab:	83 ec 08             	sub    $0x8,%esp
  1029ae:	ff 75 0c             	pushl  0xc(%ebp)
  1029b1:	50                   	push   %eax
  1029b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1029b5:	ff d0                	call   *%eax
  1029b7:	83 c4 10             	add    $0x10,%esp
                for (width -= strnlen(p, precision); width > 0; width --) {
  1029ba:	ff 4d e8             	decl   -0x18(%ebp)
  1029bd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1029c1:	7f e4                	jg     1029a7 <vprintfmt+0x1b1>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1029c3:	eb 34                	jmp    1029f9 <vprintfmt+0x203>
                if (altflag && (ch < ' ' || ch > '~')) {
  1029c5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1029c9:	74 1c                	je     1029e7 <vprintfmt+0x1f1>
  1029cb:	83 fb 1f             	cmp    $0x1f,%ebx
  1029ce:	7e 05                	jle    1029d5 <vprintfmt+0x1df>
  1029d0:	83 fb 7e             	cmp    $0x7e,%ebx
  1029d3:	7e 12                	jle    1029e7 <vprintfmt+0x1f1>
                    putch('?', putdat);
  1029d5:	83 ec 08             	sub    $0x8,%esp
  1029d8:	ff 75 0c             	pushl  0xc(%ebp)
  1029db:	6a 3f                	push   $0x3f
  1029dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1029e0:	ff d0                	call   *%eax
  1029e2:	83 c4 10             	add    $0x10,%esp
  1029e5:	eb 0f                	jmp    1029f6 <vprintfmt+0x200>
                }
                else {
                    putch(ch, putdat);
  1029e7:	83 ec 08             	sub    $0x8,%esp
  1029ea:	ff 75 0c             	pushl  0xc(%ebp)
  1029ed:	53                   	push   %ebx
  1029ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1029f1:	ff d0                	call   *%eax
  1029f3:	83 c4 10             	add    $0x10,%esp
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1029f6:	ff 4d e8             	decl   -0x18(%ebp)
  1029f9:	89 f0                	mov    %esi,%eax
  1029fb:	8d 70 01             	lea    0x1(%eax),%esi
  1029fe:	8a 00                	mov    (%eax),%al
  102a00:	0f be d8             	movsbl %al,%ebx
  102a03:	85 db                	test   %ebx,%ebx
  102a05:	74 24                	je     102a2b <vprintfmt+0x235>
  102a07:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102a0b:	78 b8                	js     1029c5 <vprintfmt+0x1cf>
  102a0d:	ff 4d e4             	decl   -0x1c(%ebp)
  102a10:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102a14:	79 af                	jns    1029c5 <vprintfmt+0x1cf>
                }
            }
            for (; width > 0; width --) {
  102a16:	eb 13                	jmp    102a2b <vprintfmt+0x235>
                putch(' ', putdat);
  102a18:	83 ec 08             	sub    $0x8,%esp
  102a1b:	ff 75 0c             	pushl  0xc(%ebp)
  102a1e:	6a 20                	push   $0x20
  102a20:	8b 45 08             	mov    0x8(%ebp),%eax
  102a23:	ff d0                	call   *%eax
  102a25:	83 c4 10             	add    $0x10,%esp
            for (; width > 0; width --) {
  102a28:	ff 4d e8             	decl   -0x18(%ebp)
  102a2b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102a2f:	7f e7                	jg     102a18 <vprintfmt+0x222>
            }
            break;
  102a31:	e9 49 01 00 00       	jmp    102b7f <vprintfmt+0x389>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102a36:	83 ec 08             	sub    $0x8,%esp
  102a39:	ff 75 e0             	pushl  -0x20(%ebp)
  102a3c:	8d 45 14             	lea    0x14(%ebp),%eax
  102a3f:	50                   	push   %eax
  102a40:	e8 46 fd ff ff       	call   10278b <getint>
  102a45:	83 c4 10             	add    $0x10,%esp
  102a48:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102a4b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102a54:	85 d2                	test   %edx,%edx
  102a56:	79 23                	jns    102a7b <vprintfmt+0x285>
                putch('-', putdat);
  102a58:	83 ec 08             	sub    $0x8,%esp
  102a5b:	ff 75 0c             	pushl  0xc(%ebp)
  102a5e:	6a 2d                	push   $0x2d
  102a60:	8b 45 08             	mov    0x8(%ebp),%eax
  102a63:	ff d0                	call   *%eax
  102a65:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  102a68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102a6e:	f7 d8                	neg    %eax
  102a70:	83 d2 00             	adc    $0x0,%edx
  102a73:	f7 da                	neg    %edx
  102a75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102a78:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102a7b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102a82:	e9 9f 00 00 00       	jmp    102b26 <vprintfmt+0x330>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102a87:	83 ec 08             	sub    $0x8,%esp
  102a8a:	ff 75 e0             	pushl  -0x20(%ebp)
  102a8d:	8d 45 14             	lea    0x14(%ebp),%eax
  102a90:	50                   	push   %eax
  102a91:	e8 a6 fc ff ff       	call   10273c <getuint>
  102a96:	83 c4 10             	add    $0x10,%esp
  102a99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102a9c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102a9f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102aa6:	eb 7e                	jmp    102b26 <vprintfmt+0x330>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102aa8:	83 ec 08             	sub    $0x8,%esp
  102aab:	ff 75 e0             	pushl  -0x20(%ebp)
  102aae:	8d 45 14             	lea    0x14(%ebp),%eax
  102ab1:	50                   	push   %eax
  102ab2:	e8 85 fc ff ff       	call   10273c <getuint>
  102ab7:	83 c4 10             	add    $0x10,%esp
  102aba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102abd:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102ac0:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102ac7:	eb 5d                	jmp    102b26 <vprintfmt+0x330>

        // pointer
        case 'p':
            putch('0', putdat);
  102ac9:	83 ec 08             	sub    $0x8,%esp
  102acc:	ff 75 0c             	pushl  0xc(%ebp)
  102acf:	6a 30                	push   $0x30
  102ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  102ad4:	ff d0                	call   *%eax
  102ad6:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  102ad9:	83 ec 08             	sub    $0x8,%esp
  102adc:	ff 75 0c             	pushl  0xc(%ebp)
  102adf:	6a 78                	push   $0x78
  102ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  102ae4:	ff d0                	call   *%eax
  102ae6:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102ae9:	8b 45 14             	mov    0x14(%ebp),%eax
  102aec:	8d 50 04             	lea    0x4(%eax),%edx
  102aef:	89 55 14             	mov    %edx,0x14(%ebp)
  102af2:	8b 00                	mov    (%eax),%eax
  102af4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102af7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102afe:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  102b05:	eb 1f                	jmp    102b26 <vprintfmt+0x330>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  102b07:	83 ec 08             	sub    $0x8,%esp
  102b0a:	ff 75 e0             	pushl  -0x20(%ebp)
  102b0d:	8d 45 14             	lea    0x14(%ebp),%eax
  102b10:	50                   	push   %eax
  102b11:	e8 26 fc ff ff       	call   10273c <getuint>
  102b16:	83 c4 10             	add    $0x10,%esp
  102b19:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102b1c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  102b1f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  102b26:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  102b2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b2d:	83 ec 04             	sub    $0x4,%esp
  102b30:	52                   	push   %edx
  102b31:	ff 75 e8             	pushl  -0x18(%ebp)
  102b34:	50                   	push   %eax
  102b35:	ff 75 f4             	pushl  -0xc(%ebp)
  102b38:	ff 75 f0             	pushl  -0x10(%ebp)
  102b3b:	ff 75 0c             	pushl  0xc(%ebp)
  102b3e:	ff 75 08             	pushl  0x8(%ebp)
  102b41:	e8 0e fb ff ff       	call   102654 <printnum>
  102b46:	83 c4 20             	add    $0x20,%esp
            break;
  102b49:	eb 34                	jmp    102b7f <vprintfmt+0x389>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  102b4b:	83 ec 08             	sub    $0x8,%esp
  102b4e:	ff 75 0c             	pushl  0xc(%ebp)
  102b51:	53                   	push   %ebx
  102b52:	8b 45 08             	mov    0x8(%ebp),%eax
  102b55:	ff d0                	call   *%eax
  102b57:	83 c4 10             	add    $0x10,%esp
            break;
  102b5a:	eb 23                	jmp    102b7f <vprintfmt+0x389>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  102b5c:	83 ec 08             	sub    $0x8,%esp
  102b5f:	ff 75 0c             	pushl  0xc(%ebp)
  102b62:	6a 25                	push   $0x25
  102b64:	8b 45 08             	mov    0x8(%ebp),%eax
  102b67:	ff d0                	call   *%eax
  102b69:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  102b6c:	ff 4d 10             	decl   0x10(%ebp)
  102b6f:	eb 03                	jmp    102b74 <vprintfmt+0x37e>
  102b71:	ff 4d 10             	decl   0x10(%ebp)
  102b74:	8b 45 10             	mov    0x10(%ebp),%eax
  102b77:	48                   	dec    %eax
  102b78:	8a 00                	mov    (%eax),%al
  102b7a:	3c 25                	cmp    $0x25,%al
  102b7c:	75 f3                	jne    102b71 <vprintfmt+0x37b>
                /* do nothing */;
            break;
  102b7e:	90                   	nop
    while (1) {
  102b7f:	e9 7a fc ff ff       	jmp    1027fe <vprintfmt+0x8>
                return;
  102b84:	90                   	nop
        }
    }
}
  102b85:	8d 65 f8             	lea    -0x8(%ebp),%esp
  102b88:	5b                   	pop    %ebx
  102b89:	5e                   	pop    %esi
  102b8a:	5d                   	pop    %ebp
  102b8b:	c3                   	ret    

00102b8c <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  102b8c:	55                   	push   %ebp
  102b8d:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  102b8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b92:	8b 40 08             	mov    0x8(%eax),%eax
  102b95:	8d 50 01             	lea    0x1(%eax),%edx
  102b98:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b9b:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  102b9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ba1:	8b 10                	mov    (%eax),%edx
  102ba3:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ba6:	8b 40 04             	mov    0x4(%eax),%eax
  102ba9:	39 c2                	cmp    %eax,%edx
  102bab:	73 12                	jae    102bbf <sprintputch+0x33>
        *b->buf ++ = ch;
  102bad:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bb0:	8b 00                	mov    (%eax),%eax
  102bb2:	8d 48 01             	lea    0x1(%eax),%ecx
  102bb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  102bb8:	89 0a                	mov    %ecx,(%edx)
  102bba:	8b 55 08             	mov    0x8(%ebp),%edx
  102bbd:	88 10                	mov    %dl,(%eax)
    }
}
  102bbf:	90                   	nop
  102bc0:	5d                   	pop    %ebp
  102bc1:	c3                   	ret    

00102bc2 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  102bc2:	55                   	push   %ebp
  102bc3:	89 e5                	mov    %esp,%ebp
  102bc5:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  102bc8:	8d 45 14             	lea    0x14(%ebp),%eax
  102bcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  102bce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102bd1:	50                   	push   %eax
  102bd2:	ff 75 10             	pushl  0x10(%ebp)
  102bd5:	ff 75 0c             	pushl  0xc(%ebp)
  102bd8:	ff 75 08             	pushl  0x8(%ebp)
  102bdb:	e8 0b 00 00 00       	call   102beb <vsnprintf>
  102be0:	83 c4 10             	add    $0x10,%esp
  102be3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  102be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102be9:	c9                   	leave  
  102bea:	c3                   	ret    

00102beb <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  102beb:	55                   	push   %ebp
  102bec:	89 e5                	mov    %esp,%ebp
  102bee:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  102bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  102bf4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102bf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bfa:	8d 50 ff             	lea    -0x1(%eax),%edx
  102bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  102c00:	01 d0                	add    %edx,%eax
  102c02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102c05:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  102c0c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102c10:	74 0a                	je     102c1c <vsnprintf+0x31>
  102c12:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102c15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c18:	39 c2                	cmp    %eax,%edx
  102c1a:	76 07                	jbe    102c23 <vsnprintf+0x38>
        return -E_INVAL;
  102c1c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  102c21:	eb 20                	jmp    102c43 <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  102c23:	ff 75 14             	pushl  0x14(%ebp)
  102c26:	ff 75 10             	pushl  0x10(%ebp)
  102c29:	8d 45 ec             	lea    -0x14(%ebp),%eax
  102c2c:	50                   	push   %eax
  102c2d:	68 8c 2b 10 00       	push   $0x102b8c
  102c32:	e8 bf fb ff ff       	call   1027f6 <vprintfmt>
  102c37:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  102c3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102c3d:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  102c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102c43:	c9                   	leave  
  102c44:	c3                   	ret    

00102c45 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102c45:	55                   	push   %ebp
  102c46:	89 e5                	mov    %esp,%ebp
  102c48:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102c4b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102c52:	eb 03                	jmp    102c57 <strlen+0x12>
        cnt ++;
  102c54:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  102c57:	8b 45 08             	mov    0x8(%ebp),%eax
  102c5a:	8d 50 01             	lea    0x1(%eax),%edx
  102c5d:	89 55 08             	mov    %edx,0x8(%ebp)
  102c60:	8a 00                	mov    (%eax),%al
  102c62:	84 c0                	test   %al,%al
  102c64:	75 ee                	jne    102c54 <strlen+0xf>
    }
    return cnt;
  102c66:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102c69:	c9                   	leave  
  102c6a:	c3                   	ret    

00102c6b <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102c6b:	55                   	push   %ebp
  102c6c:	89 e5                	mov    %esp,%ebp
  102c6e:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102c71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102c78:	eb 03                	jmp    102c7d <strnlen+0x12>
        cnt ++;
  102c7a:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102c7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102c80:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102c83:	73 0f                	jae    102c94 <strnlen+0x29>
  102c85:	8b 45 08             	mov    0x8(%ebp),%eax
  102c88:	8d 50 01             	lea    0x1(%eax),%edx
  102c8b:	89 55 08             	mov    %edx,0x8(%ebp)
  102c8e:	8a 00                	mov    (%eax),%al
  102c90:	84 c0                	test   %al,%al
  102c92:	75 e6                	jne    102c7a <strnlen+0xf>
    }
    return cnt;
  102c94:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102c97:	c9                   	leave  
  102c98:	c3                   	ret    

00102c99 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102c99:	55                   	push   %ebp
  102c9a:	89 e5                	mov    %esp,%ebp
  102c9c:	57                   	push   %edi
  102c9d:	56                   	push   %esi
  102c9e:	83 ec 20             	sub    $0x20,%esp
  102ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  102ca4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ca7:	8b 45 0c             	mov    0xc(%ebp),%eax
  102caa:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102cad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cb3:	89 d1                	mov    %edx,%ecx
  102cb5:	89 c2                	mov    %eax,%edx
  102cb7:	89 ce                	mov    %ecx,%esi
  102cb9:	89 d7                	mov    %edx,%edi
  102cbb:	ac                   	lods   %ds:(%esi),%al
  102cbc:	aa                   	stos   %al,%es:(%edi)
  102cbd:	84 c0                	test   %al,%al
  102cbf:	75 fa                	jne    102cbb <strcpy+0x22>
  102cc1:	89 fa                	mov    %edi,%edx
  102cc3:	89 f1                	mov    %esi,%ecx
  102cc5:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102cc8:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102ccb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  102cd1:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102cd2:	83 c4 20             	add    $0x20,%esp
  102cd5:	5e                   	pop    %esi
  102cd6:	5f                   	pop    %edi
  102cd7:	5d                   	pop    %ebp
  102cd8:	c3                   	ret    

00102cd9 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102cd9:	55                   	push   %ebp
  102cda:	89 e5                	mov    %esp,%ebp
  102cdc:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  102ce2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102ce5:	eb 1c                	jmp    102d03 <strncpy+0x2a>
        if ((*p = *src) != '\0') {
  102ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cea:	8a 10                	mov    (%eax),%dl
  102cec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102cef:	88 10                	mov    %dl,(%eax)
  102cf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102cf4:	8a 00                	mov    (%eax),%al
  102cf6:	84 c0                	test   %al,%al
  102cf8:	74 03                	je     102cfd <strncpy+0x24>
            src ++;
  102cfa:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  102cfd:	ff 45 fc             	incl   -0x4(%ebp)
  102d00:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  102d03:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d07:	75 de                	jne    102ce7 <strncpy+0xe>
    }
    return dst;
  102d09:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102d0c:	c9                   	leave  
  102d0d:	c3                   	ret    

00102d0e <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102d0e:	55                   	push   %ebp
  102d0f:	89 e5                	mov    %esp,%ebp
  102d11:	57                   	push   %edi
  102d12:	56                   	push   %esi
  102d13:	83 ec 20             	sub    $0x20,%esp
  102d16:	8b 45 08             	mov    0x8(%ebp),%eax
  102d19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  102d22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d28:	89 d1                	mov    %edx,%ecx
  102d2a:	89 c2                	mov    %eax,%edx
  102d2c:	89 ce                	mov    %ecx,%esi
  102d2e:	89 d7                	mov    %edx,%edi
  102d30:	ac                   	lods   %ds:(%esi),%al
  102d31:	ae                   	scas   %es:(%edi),%al
  102d32:	75 08                	jne    102d3c <strcmp+0x2e>
  102d34:	84 c0                	test   %al,%al
  102d36:	75 f8                	jne    102d30 <strcmp+0x22>
  102d38:	31 c0                	xor    %eax,%eax
  102d3a:	eb 04                	jmp    102d40 <strcmp+0x32>
  102d3c:	19 c0                	sbb    %eax,%eax
  102d3e:	0c 01                	or     $0x1,%al
  102d40:	89 fa                	mov    %edi,%edx
  102d42:	89 f1                	mov    %esi,%ecx
  102d44:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102d47:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102d4a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  102d4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  102d50:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102d51:	83 c4 20             	add    $0x20,%esp
  102d54:	5e                   	pop    %esi
  102d55:	5f                   	pop    %edi
  102d56:	5d                   	pop    %ebp
  102d57:	c3                   	ret    

00102d58 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102d58:	55                   	push   %ebp
  102d59:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102d5b:	eb 09                	jmp    102d66 <strncmp+0xe>
        n --, s1 ++, s2 ++;
  102d5d:	ff 4d 10             	decl   0x10(%ebp)
  102d60:	ff 45 08             	incl   0x8(%ebp)
  102d63:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102d66:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d6a:	74 17                	je     102d83 <strncmp+0x2b>
  102d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d6f:	8a 00                	mov    (%eax),%al
  102d71:	84 c0                	test   %al,%al
  102d73:	74 0e                	je     102d83 <strncmp+0x2b>
  102d75:	8b 45 08             	mov    0x8(%ebp),%eax
  102d78:	8a 10                	mov    (%eax),%dl
  102d7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d7d:	8a 00                	mov    (%eax),%al
  102d7f:	38 c2                	cmp    %al,%dl
  102d81:	74 da                	je     102d5d <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102d83:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d87:	74 16                	je     102d9f <strncmp+0x47>
  102d89:	8b 45 08             	mov    0x8(%ebp),%eax
  102d8c:	8a 00                	mov    (%eax),%al
  102d8e:	0f b6 d0             	movzbl %al,%edx
  102d91:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d94:	8a 00                	mov    (%eax),%al
  102d96:	0f b6 c0             	movzbl %al,%eax
  102d99:	29 c2                	sub    %eax,%edx
  102d9b:	89 d0                	mov    %edx,%eax
  102d9d:	eb 05                	jmp    102da4 <strncmp+0x4c>
  102d9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102da4:	5d                   	pop    %ebp
  102da5:	c3                   	ret    

00102da6 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102da6:	55                   	push   %ebp
  102da7:	89 e5                	mov    %esp,%ebp
  102da9:	83 ec 04             	sub    $0x4,%esp
  102dac:	8b 45 0c             	mov    0xc(%ebp),%eax
  102daf:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102db2:	eb 12                	jmp    102dc6 <strchr+0x20>
        if (*s == c) {
  102db4:	8b 45 08             	mov    0x8(%ebp),%eax
  102db7:	8a 00                	mov    (%eax),%al
  102db9:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102dbc:	75 05                	jne    102dc3 <strchr+0x1d>
            return (char *)s;
  102dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  102dc1:	eb 11                	jmp    102dd4 <strchr+0x2e>
        }
        s ++;
  102dc3:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  102dc9:	8a 00                	mov    (%eax),%al
  102dcb:	84 c0                	test   %al,%al
  102dcd:	75 e5                	jne    102db4 <strchr+0xe>
    }
    return NULL;
  102dcf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102dd4:	c9                   	leave  
  102dd5:	c3                   	ret    

00102dd6 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102dd6:	55                   	push   %ebp
  102dd7:	89 e5                	mov    %esp,%ebp
  102dd9:	83 ec 04             	sub    $0x4,%esp
  102ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ddf:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102de2:	eb 0d                	jmp    102df1 <strfind+0x1b>
        if (*s == c) {
  102de4:	8b 45 08             	mov    0x8(%ebp),%eax
  102de7:	8a 00                	mov    (%eax),%al
  102de9:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102dec:	74 0e                	je     102dfc <strfind+0x26>
            break;
        }
        s ++;
  102dee:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102df1:	8b 45 08             	mov    0x8(%ebp),%eax
  102df4:	8a 00                	mov    (%eax),%al
  102df6:	84 c0                	test   %al,%al
  102df8:	75 ea                	jne    102de4 <strfind+0xe>
  102dfa:	eb 01                	jmp    102dfd <strfind+0x27>
            break;
  102dfc:	90                   	nop
    }
    return (char *)s;
  102dfd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102e00:	c9                   	leave  
  102e01:	c3                   	ret    

00102e02 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102e02:	55                   	push   %ebp
  102e03:	89 e5                	mov    %esp,%ebp
  102e05:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102e08:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102e0f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102e16:	eb 03                	jmp    102e1b <strtol+0x19>
        s ++;
  102e18:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  102e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  102e1e:	8a 00                	mov    (%eax),%al
  102e20:	3c 20                	cmp    $0x20,%al
  102e22:	74 f4                	je     102e18 <strtol+0x16>
  102e24:	8b 45 08             	mov    0x8(%ebp),%eax
  102e27:	8a 00                	mov    (%eax),%al
  102e29:	3c 09                	cmp    $0x9,%al
  102e2b:	74 eb                	je     102e18 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  102e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  102e30:	8a 00                	mov    (%eax),%al
  102e32:	3c 2b                	cmp    $0x2b,%al
  102e34:	75 05                	jne    102e3b <strtol+0x39>
        s ++;
  102e36:	ff 45 08             	incl   0x8(%ebp)
  102e39:	eb 13                	jmp    102e4e <strtol+0x4c>
    }
    else if (*s == '-') {
  102e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  102e3e:	8a 00                	mov    (%eax),%al
  102e40:	3c 2d                	cmp    $0x2d,%al
  102e42:	75 0a                	jne    102e4e <strtol+0x4c>
        s ++, neg = 1;
  102e44:	ff 45 08             	incl   0x8(%ebp)
  102e47:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102e4e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e52:	74 06                	je     102e5a <strtol+0x58>
  102e54:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102e58:	75 20                	jne    102e7a <strtol+0x78>
  102e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  102e5d:	8a 00                	mov    (%eax),%al
  102e5f:	3c 30                	cmp    $0x30,%al
  102e61:	75 17                	jne    102e7a <strtol+0x78>
  102e63:	8b 45 08             	mov    0x8(%ebp),%eax
  102e66:	40                   	inc    %eax
  102e67:	8a 00                	mov    (%eax),%al
  102e69:	3c 78                	cmp    $0x78,%al
  102e6b:	75 0d                	jne    102e7a <strtol+0x78>
        s += 2, base = 16;
  102e6d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102e71:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102e78:	eb 28                	jmp    102ea2 <strtol+0xa0>
    }
    else if (base == 0 && s[0] == '0') {
  102e7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e7e:	75 15                	jne    102e95 <strtol+0x93>
  102e80:	8b 45 08             	mov    0x8(%ebp),%eax
  102e83:	8a 00                	mov    (%eax),%al
  102e85:	3c 30                	cmp    $0x30,%al
  102e87:	75 0c                	jne    102e95 <strtol+0x93>
        s ++, base = 8;
  102e89:	ff 45 08             	incl   0x8(%ebp)
  102e8c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102e93:	eb 0d                	jmp    102ea2 <strtol+0xa0>
    }
    else if (base == 0) {
  102e95:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e99:	75 07                	jne    102ea2 <strtol+0xa0>
        base = 10;
  102e9b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  102ea5:	8a 00                	mov    (%eax),%al
  102ea7:	3c 2f                	cmp    $0x2f,%al
  102ea9:	7e 19                	jle    102ec4 <strtol+0xc2>
  102eab:	8b 45 08             	mov    0x8(%ebp),%eax
  102eae:	8a 00                	mov    (%eax),%al
  102eb0:	3c 39                	cmp    $0x39,%al
  102eb2:	7f 10                	jg     102ec4 <strtol+0xc2>
            dig = *s - '0';
  102eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  102eb7:	8a 00                	mov    (%eax),%al
  102eb9:	0f be c0             	movsbl %al,%eax
  102ebc:	83 e8 30             	sub    $0x30,%eax
  102ebf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ec2:	eb 42                	jmp    102f06 <strtol+0x104>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ec7:	8a 00                	mov    (%eax),%al
  102ec9:	3c 60                	cmp    $0x60,%al
  102ecb:	7e 19                	jle    102ee6 <strtol+0xe4>
  102ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  102ed0:	8a 00                	mov    (%eax),%al
  102ed2:	3c 7a                	cmp    $0x7a,%al
  102ed4:	7f 10                	jg     102ee6 <strtol+0xe4>
            dig = *s - 'a' + 10;
  102ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ed9:	8a 00                	mov    (%eax),%al
  102edb:	0f be c0             	movsbl %al,%eax
  102ede:	83 e8 57             	sub    $0x57,%eax
  102ee1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ee4:	eb 20                	jmp    102f06 <strtol+0x104>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ee9:	8a 00                	mov    (%eax),%al
  102eeb:	3c 40                	cmp    $0x40,%al
  102eed:	7e 39                	jle    102f28 <strtol+0x126>
  102eef:	8b 45 08             	mov    0x8(%ebp),%eax
  102ef2:	8a 00                	mov    (%eax),%al
  102ef4:	3c 5a                	cmp    $0x5a,%al
  102ef6:	7f 30                	jg     102f28 <strtol+0x126>
            dig = *s - 'A' + 10;
  102ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  102efb:	8a 00                	mov    (%eax),%al
  102efd:	0f be c0             	movsbl %al,%eax
  102f00:	83 e8 37             	sub    $0x37,%eax
  102f03:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f09:	3b 45 10             	cmp    0x10(%ebp),%eax
  102f0c:	7d 19                	jge    102f27 <strtol+0x125>
            break;
        }
        s ++, val = (val * base) + dig;
  102f0e:	ff 45 08             	incl   0x8(%ebp)
  102f11:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f14:	0f af 45 10          	imul   0x10(%ebp),%eax
  102f18:	89 c2                	mov    %eax,%edx
  102f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f1d:	01 d0                	add    %edx,%eax
  102f1f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  102f22:	e9 7b ff ff ff       	jmp    102ea2 <strtol+0xa0>
            break;
  102f27:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  102f28:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102f2c:	74 08                	je     102f36 <strtol+0x134>
        *endptr = (char *) s;
  102f2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f31:	8b 55 08             	mov    0x8(%ebp),%edx
  102f34:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102f36:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102f3a:	74 07                	je     102f43 <strtol+0x141>
  102f3c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f3f:	f7 d8                	neg    %eax
  102f41:	eb 03                	jmp    102f46 <strtol+0x144>
  102f43:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102f46:	c9                   	leave  
  102f47:	c3                   	ret    

00102f48 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102f48:	55                   	push   %ebp
  102f49:	89 e5                	mov    %esp,%ebp
  102f4b:	57                   	push   %edi
  102f4c:	83 ec 24             	sub    $0x24,%esp
  102f4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f52:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102f55:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  102f59:	8b 55 08             	mov    0x8(%ebp),%edx
  102f5c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  102f5f:	88 45 f7             	mov    %al,-0x9(%ebp)
  102f62:	8b 45 10             	mov    0x10(%ebp),%eax
  102f65:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102f68:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102f6b:	8a 45 f7             	mov    -0x9(%ebp),%al
  102f6e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102f71:	89 d7                	mov    %edx,%edi
  102f73:	f3 aa                	rep stos %al,%es:(%edi)
  102f75:	89 fa                	mov    %edi,%edx
  102f77:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102f7a:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102f7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f80:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102f81:	83 c4 24             	add    $0x24,%esp
  102f84:	5f                   	pop    %edi
  102f85:	5d                   	pop    %ebp
  102f86:	c3                   	ret    

00102f87 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102f87:	55                   	push   %ebp
  102f88:	89 e5                	mov    %esp,%ebp
  102f8a:	57                   	push   %edi
  102f8b:	56                   	push   %esi
  102f8c:	53                   	push   %ebx
  102f8d:	83 ec 30             	sub    $0x30,%esp
  102f90:	8b 45 08             	mov    0x8(%ebp),%eax
  102f93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f99:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f9c:	8b 45 10             	mov    0x10(%ebp),%eax
  102f9f:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102fa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fa5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102fa8:	73 42                	jae    102fec <memmove+0x65>
  102faa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102fb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fb3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102fb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102fb9:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102fbc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102fbf:	c1 e8 02             	shr    $0x2,%eax
  102fc2:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102fc4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102fc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fca:	89 d7                	mov    %edx,%edi
  102fcc:	89 c6                	mov    %eax,%esi
  102fce:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102fd0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102fd3:	83 e1 03             	and    $0x3,%ecx
  102fd6:	74 02                	je     102fda <memmove+0x53>
  102fd8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102fda:	89 f0                	mov    %esi,%eax
  102fdc:	89 fa                	mov    %edi,%edx
  102fde:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102fe1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102fe4:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  102fe7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  102fea:	eb 36                	jmp    103022 <memmove+0x9b>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102fec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102fef:	8d 50 ff             	lea    -0x1(%eax),%edx
  102ff2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ff5:	01 c2                	add    %eax,%edx
  102ff7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ffa:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102ffd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103000:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  103003:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103006:	89 c1                	mov    %eax,%ecx
  103008:	89 d8                	mov    %ebx,%eax
  10300a:	89 d6                	mov    %edx,%esi
  10300c:	89 c7                	mov    %eax,%edi
  10300e:	fd                   	std    
  10300f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103011:	fc                   	cld    
  103012:	89 f8                	mov    %edi,%eax
  103014:	89 f2                	mov    %esi,%edx
  103016:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  103019:	89 55 c8             	mov    %edx,-0x38(%ebp)
  10301c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  10301f:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  103022:	83 c4 30             	add    $0x30,%esp
  103025:	5b                   	pop    %ebx
  103026:	5e                   	pop    %esi
  103027:	5f                   	pop    %edi
  103028:	5d                   	pop    %ebp
  103029:	c3                   	ret    

0010302a <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  10302a:	55                   	push   %ebp
  10302b:	89 e5                	mov    %esp,%ebp
  10302d:	57                   	push   %edi
  10302e:	56                   	push   %esi
  10302f:	83 ec 20             	sub    $0x20,%esp
  103032:	8b 45 08             	mov    0x8(%ebp),%eax
  103035:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103038:	8b 45 0c             	mov    0xc(%ebp),%eax
  10303b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10303e:	8b 45 10             	mov    0x10(%ebp),%eax
  103041:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103044:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103047:	c1 e8 02             	shr    $0x2,%eax
  10304a:	89 c1                	mov    %eax,%ecx
    asm volatile (
  10304c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10304f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103052:	89 d7                	mov    %edx,%edi
  103054:	89 c6                	mov    %eax,%esi
  103056:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103058:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  10305b:	83 e1 03             	and    $0x3,%ecx
  10305e:	74 02                	je     103062 <memcpy+0x38>
  103060:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103062:	89 f0                	mov    %esi,%eax
  103064:	89 fa                	mov    %edi,%edx
  103066:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  103069:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  10306c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  10306f:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  103072:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  103073:	83 c4 20             	add    $0x20,%esp
  103076:	5e                   	pop    %esi
  103077:	5f                   	pop    %edi
  103078:	5d                   	pop    %ebp
  103079:	c3                   	ret    

0010307a <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  10307a:	55                   	push   %ebp
  10307b:	89 e5                	mov    %esp,%ebp
  10307d:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  103080:	8b 45 08             	mov    0x8(%ebp),%eax
  103083:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  103086:	8b 45 0c             	mov    0xc(%ebp),%eax
  103089:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  10308c:	eb 2a                	jmp    1030b8 <memcmp+0x3e>
        if (*s1 != *s2) {
  10308e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103091:	8a 10                	mov    (%eax),%dl
  103093:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103096:	8a 00                	mov    (%eax),%al
  103098:	38 c2                	cmp    %al,%dl
  10309a:	74 16                	je     1030b2 <memcmp+0x38>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  10309c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10309f:	8a 00                	mov    (%eax),%al
  1030a1:	0f b6 d0             	movzbl %al,%edx
  1030a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1030a7:	8a 00                	mov    (%eax),%al
  1030a9:	0f b6 c0             	movzbl %al,%eax
  1030ac:	29 c2                	sub    %eax,%edx
  1030ae:	89 d0                	mov    %edx,%eax
  1030b0:	eb 18                	jmp    1030ca <memcmp+0x50>
        }
        s1 ++, s2 ++;
  1030b2:	ff 45 fc             	incl   -0x4(%ebp)
  1030b5:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  1030b8:	8b 45 10             	mov    0x10(%ebp),%eax
  1030bb:	8d 50 ff             	lea    -0x1(%eax),%edx
  1030be:	89 55 10             	mov    %edx,0x10(%ebp)
  1030c1:	85 c0                	test   %eax,%eax
  1030c3:	75 c9                	jne    10308e <memcmp+0x14>
    }
    return 0;
  1030c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1030ca:	c9                   	leave  
  1030cb:	c3                   	ret    
