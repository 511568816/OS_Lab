
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
  10001b:	e8 f8 2f 00 00       	call   103018 <memset>
  100020:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100023:	e8 cf 14 00 00       	call   1014f7 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100028:	c7 45 f4 a0 31 10 00 	movl   $0x1031a0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10002f:	83 ec 08             	sub    $0x8,%esp
  100032:	ff 75 f4             	pushl  -0xc(%ebp)
  100035:	68 bc 31 10 00       	push   $0x1031bc
  10003a:	e8 b7 02 00 00       	call   1002f6 <cprintf>
  10003f:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100042:	e8 b2 07 00 00       	call   1007f9 <print_kerninfo>

    grade_backtrace();
  100047:	e8 74 00 00 00       	call   1000c0 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10004c:	e8 c8 26 00 00       	call   102719 <pmm_init>

    pic_init();                 // init interrupt controller
  100051:	e8 eb 15 00 00       	call   101641 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100056:	e8 2e 17 00 00       	call   101789 <idt_init>

    clock_init();               // init clock interrupt
  10005b:	e8 d1 0c 00 00       	call   100d31 <clock_init>
    intr_enable();              // enable irq interrupt
  100060:	e8 4e 15 00 00       	call   1015b3 <intr_enable>
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
  100076:	e8 d0 0b 00 00       	call   100c4b <mon_backtrace>
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
  100109:	68 c1 31 10 00       	push   $0x1031c1
  10010e:	e8 e3 01 00 00       	call   1002f6 <cprintf>
  100113:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  100116:	66 8b 45 f6          	mov    -0xa(%ebp),%ax
  10011a:	0f b7 d0             	movzwl %ax,%edx
  10011d:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100122:	83 ec 04             	sub    $0x4,%esp
  100125:	52                   	push   %edx
  100126:	50                   	push   %eax
  100127:	68 cf 31 10 00       	push   $0x1031cf
  10012c:	e8 c5 01 00 00       	call   1002f6 <cprintf>
  100131:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  100134:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100137:	0f b7 d0             	movzwl %ax,%edx
  10013a:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  10013f:	83 ec 04             	sub    $0x4,%esp
  100142:	52                   	push   %edx
  100143:	50                   	push   %eax
  100144:	68 dd 31 10 00       	push   $0x1031dd
  100149:	e8 a8 01 00 00       	call   1002f6 <cprintf>
  10014e:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  100151:	66 8b 45 f2          	mov    -0xe(%ebp),%ax
  100155:	0f b7 d0             	movzwl %ax,%edx
  100158:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  10015d:	83 ec 04             	sub    $0x4,%esp
  100160:	52                   	push   %edx
  100161:	50                   	push   %eax
  100162:	68 eb 31 10 00       	push   $0x1031eb
  100167:	e8 8a 01 00 00       	call   1002f6 <cprintf>
  10016c:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  10016f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100172:	0f b7 d0             	movzwl %ax,%edx
  100175:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  10017a:	83 ec 04             	sub    $0x4,%esp
  10017d:	52                   	push   %edx
  10017e:	50                   	push   %eax
  10017f:	68 f9 31 10 00       	push   $0x1031f9
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
  1001b4:	68 08 32 10 00       	push   $0x103208
  1001b9:	e8 38 01 00 00       	call   1002f6 <cprintf>
  1001be:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  1001c1:	e8 d4 ff ff ff       	call   10019a <lab1_switch_to_user>
    lab1_print_cur_status();
  1001c6:	e8 16 ff ff ff       	call   1000e1 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001cb:	83 ec 0c             	sub    $0xc,%esp
  1001ce:	68 28 32 10 00       	push   $0x103228
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
  1001fa:	68 47 32 10 00       	push   $0x103247
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
  1002b5:	e8 6e 12 00 00       	call   101528 <cons_putc>
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
  1002e9:	e8 d8 25 00 00       	call   1028c6 <vprintfmt>
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
  100328:	e8 fb 11 00 00       	call   101528 <cons_putc>
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
  100387:	e8 cc 11 00 00       	call   101558 <cons_getc>
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
  1004ef:	c7 00 4c 32 10 00    	movl   $0x10324c,(%eax)
    info->eip_line = 0;
  1004f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  1004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  100502:	c7 40 08 4c 32 10 00 	movl   $0x10324c,0x8(%eax)
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
  100526:	c7 45 f4 cc 3a 10 00 	movl   $0x103acc,-0xc(%ebp)
    stab_end = __STAB_END__;
  10052d:	c7 45 f0 08 c2 10 00 	movl   $0x10c208,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100534:	c7 45 ec 09 c2 10 00 	movl   $0x10c209,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10053b:	c7 45 e8 0f e3 10 00 	movl   $0x10e30f,-0x18(%ebp)

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
  100687:	e8 1a 28 00 00       	call   102ea6 <strfind>
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
  100802:	68 56 32 10 00       	push   $0x103256
  100807:	e8 ea fa ff ff       	call   1002f6 <cprintf>
  10080c:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10080f:	83 ec 08             	sub    $0x8,%esp
  100812:	68 00 00 10 00       	push   $0x100000
  100817:	68 6f 32 10 00       	push   $0x10326f
  10081c:	e8 d5 fa ff ff       	call   1002f6 <cprintf>
  100821:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  100824:	83 ec 08             	sub    $0x8,%esp
  100827:	68 9c 31 10 00       	push   $0x10319c
  10082c:	68 87 32 10 00       	push   $0x103287
  100831:	e8 c0 fa ff ff       	call   1002f6 <cprintf>
  100836:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100839:	83 ec 08             	sub    $0x8,%esp
  10083c:	68 16 fa 10 00       	push   $0x10fa16
  100841:	68 9f 32 10 00       	push   $0x10329f
  100846:	e8 ab fa ff ff       	call   1002f6 <cprintf>
  10084b:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  10084e:	83 ec 08             	sub    $0x8,%esp
  100851:	68 20 0d 11 00       	push   $0x110d20
  100856:	68 b7 32 10 00       	push   $0x1032b7
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
  100882:	68 d0 32 10 00       	push   $0x1032d0
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
  1008b7:	68 fa 32 10 00       	push   $0x1032fa
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
  10091c:	68 16 33 10 00       	push   $0x103316
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
  10095d:	e9 a4 00 00 00       	jmp    100a06 <print_stackframe+0xc9>
        cprintf("stack_level: %d\n", stack_level);
  100962:	83 ec 08             	sub    $0x8,%esp
  100965:	ff 75 ec             	pushl  -0x14(%ebp)
  100968:	68 28 33 10 00       	push   $0x103328
  10096d:	e8 84 f9 ff ff       	call   1002f6 <cprintf>
  100972:	83 c4 10             	add    $0x10,%esp
        
        // (3.1) printf value of ebp, eip
        cprintf("ebp: 0x%08x eip: 0x%08x ", curr_ebp, curr_eip);
  100975:	83 ec 04             	sub    $0x4,%esp
  100978:	ff 75 f0             	pushl  -0x10(%ebp)
  10097b:	ff 75 f4             	pushl  -0xc(%ebp)
  10097e:	68 39 33 10 00       	push   $0x103339
  100983:	e8 6e f9 ff ff       	call   1002f6 <cprintf>
  100988:	83 c4 10             	add    $0x10,%esp
        // (3.2) (uint32_t)calling arguments [0..4] = the contents in address (uint32_t)ebp +2 [0..4]
        cprintf("args:");
  10098b:	83 ec 0c             	sub    $0xc,%esp
  10098e:	68 52 33 10 00       	push   $0x103352
  100993:	e8 5e f9 ff ff       	call   1002f6 <cprintf>
  100998:	83 c4 10             	add    $0x10,%esp
        for (int arg_num = 0; arg_num < 4; ++arg_num)
  10099b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  1009a2:	eb 28                	jmp    1009cc <print_stackframe+0x8f>
            cprintf("0x%8x ", *((uint32_t*)curr_ebp + 2 + arg_num));
  1009a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1009ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009b1:	01 d0                	add    %edx,%eax
  1009b3:	83 c0 08             	add    $0x8,%eax
  1009b6:	8b 00                	mov    (%eax),%eax
  1009b8:	83 ec 08             	sub    $0x8,%esp
  1009bb:	50                   	push   %eax
  1009bc:	68 58 33 10 00       	push   $0x103358
  1009c1:	e8 30 f9 ff ff       	call   1002f6 <cprintf>
  1009c6:	83 c4 10             	add    $0x10,%esp
        for (int arg_num = 0; arg_num < 4; ++arg_num)
  1009c9:	ff 45 e8             	incl   -0x18(%ebp)
  1009cc:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  1009d0:	7e d2                	jle    1009a4 <print_stackframe+0x67>
        
        // (3.3) cprintf("\n");
        cprintf("\n");
  1009d2:	83 ec 0c             	sub    $0xc,%esp
  1009d5:	68 5f 33 10 00       	push   $0x10335f
  1009da:	e8 17 f9 ff ff       	call   1002f6 <cprintf>
  1009df:	83 c4 10             	add    $0x10,%esp
        
        // (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
        print_debuginfo(curr_eip);
  1009e2:	83 ec 0c             	sub    $0xc,%esp
  1009e5:	ff 75 f0             	pushl  -0x10(%ebp)
  1009e8:	e8 a5 fe ff ff       	call   100892 <print_debuginfo>
  1009ed:	83 c4 10             	add    $0x10,%esp
        
        // (3.5) popup a calling stackframe
        //           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
        //                   the calling funciton's ebp = ss:[ebp]
        curr_eip = *((uint32_t*)curr_ebp + 1);
  1009f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f3:	83 c0 04             	add    $0x4,%eax
  1009f6:	8b 00                	mov    (%eax),%eax
  1009f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
        curr_ebp = *((uint32_t*)curr_ebp);
  1009fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009fe:	8b 00                	mov    (%eax),%eax
  100a00:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (int stack_level = 0; stack_level <= STACKFRAME_DEPTH; ++stack_level) {
  100a03:	ff 45 ec             	incl   -0x14(%ebp)
  100a06:	83 7d ec 14          	cmpl   $0x14,-0x14(%ebp)
  100a0a:	0f 8e 52 ff ff ff    	jle    100962 <print_stackframe+0x25>
    }
}
  100a10:	90                   	nop
  100a11:	c9                   	leave  
  100a12:	c3                   	ret    

00100a13 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a13:	55                   	push   %ebp
  100a14:	89 e5                	mov    %esp,%ebp
  100a16:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
  100a19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a20:	eb 0c                	jmp    100a2e <parse+0x1b>
            *buf ++ = '\0';
  100a22:	8b 45 08             	mov    0x8(%ebp),%eax
  100a25:	8d 50 01             	lea    0x1(%eax),%edx
  100a28:	89 55 08             	mov    %edx,0x8(%ebp)
  100a2b:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  100a31:	8a 00                	mov    (%eax),%al
  100a33:	84 c0                	test   %al,%al
  100a35:	74 1d                	je     100a54 <parse+0x41>
  100a37:	8b 45 08             	mov    0x8(%ebp),%eax
  100a3a:	8a 00                	mov    (%eax),%al
  100a3c:	0f be c0             	movsbl %al,%eax
  100a3f:	83 ec 08             	sub    $0x8,%esp
  100a42:	50                   	push   %eax
  100a43:	68 e4 33 10 00       	push   $0x1033e4
  100a48:	e8 29 24 00 00       	call   102e76 <strchr>
  100a4d:	83 c4 10             	add    $0x10,%esp
  100a50:	85 c0                	test   %eax,%eax
  100a52:	75 ce                	jne    100a22 <parse+0xf>
        }
        if (*buf == '\0') {
  100a54:	8b 45 08             	mov    0x8(%ebp),%eax
  100a57:	8a 00                	mov    (%eax),%al
  100a59:	84 c0                	test   %al,%al
  100a5b:	74 62                	je     100abf <parse+0xac>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100a5d:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100a61:	75 12                	jne    100a75 <parse+0x62>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100a63:	83 ec 08             	sub    $0x8,%esp
  100a66:	6a 10                	push   $0x10
  100a68:	68 e9 33 10 00       	push   $0x1033e9
  100a6d:	e8 84 f8 ff ff       	call   1002f6 <cprintf>
  100a72:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a78:	8d 50 01             	lea    0x1(%eax),%edx
  100a7b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100a7e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a85:	8b 45 0c             	mov    0xc(%ebp),%eax
  100a88:	01 c2                	add    %eax,%edx
  100a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  100a8d:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100a8f:	eb 03                	jmp    100a94 <parse+0x81>
            buf ++;
  100a91:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100a94:	8b 45 08             	mov    0x8(%ebp),%eax
  100a97:	8a 00                	mov    (%eax),%al
  100a99:	84 c0                	test   %al,%al
  100a9b:	74 91                	je     100a2e <parse+0x1b>
  100a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa0:	8a 00                	mov    (%eax),%al
  100aa2:	0f be c0             	movsbl %al,%eax
  100aa5:	83 ec 08             	sub    $0x8,%esp
  100aa8:	50                   	push   %eax
  100aa9:	68 e4 33 10 00       	push   $0x1033e4
  100aae:	e8 c3 23 00 00       	call   102e76 <strchr>
  100ab3:	83 c4 10             	add    $0x10,%esp
  100ab6:	85 c0                	test   %eax,%eax
  100ab8:	74 d7                	je     100a91 <parse+0x7e>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100aba:	e9 6f ff ff ff       	jmp    100a2e <parse+0x1b>
            break;
  100abf:	90                   	nop
        }
    }
    return argc;
  100ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100ac3:	c9                   	leave  
  100ac4:	c3                   	ret    

00100ac5 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100ac5:	55                   	push   %ebp
  100ac6:	89 e5                	mov    %esp,%ebp
  100ac8:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100acb:	83 ec 08             	sub    $0x8,%esp
  100ace:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100ad1:	50                   	push   %eax
  100ad2:	ff 75 08             	pushl  0x8(%ebp)
  100ad5:	e8 39 ff ff ff       	call   100a13 <parse>
  100ada:	83 c4 10             	add    $0x10,%esp
  100add:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100ae0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100ae4:	75 0a                	jne    100af0 <runcmd+0x2b>
        return 0;
  100ae6:	b8 00 00 00 00       	mov    $0x0,%eax
  100aeb:	e9 80 00 00 00       	jmp    100b70 <runcmd+0xab>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100af0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100af7:	eb 56                	jmp    100b4f <runcmd+0x8a>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100af9:	8b 55 b0             	mov    -0x50(%ebp),%edx
  100afc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100aff:	89 c8                	mov    %ecx,%eax
  100b01:	01 c0                	add    %eax,%eax
  100b03:	01 c8                	add    %ecx,%eax
  100b05:	c1 e0 02             	shl    $0x2,%eax
  100b08:	05 00 f0 10 00       	add    $0x10f000,%eax
  100b0d:	8b 00                	mov    (%eax),%eax
  100b0f:	83 ec 08             	sub    $0x8,%esp
  100b12:	52                   	push   %edx
  100b13:	50                   	push   %eax
  100b14:	e8 c5 22 00 00       	call   102dde <strcmp>
  100b19:	83 c4 10             	add    $0x10,%esp
  100b1c:	85 c0                	test   %eax,%eax
  100b1e:	75 2c                	jne    100b4c <runcmd+0x87>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b23:	89 d0                	mov    %edx,%eax
  100b25:	01 c0                	add    %eax,%eax
  100b27:	01 d0                	add    %edx,%eax
  100b29:	c1 e0 02             	shl    $0x2,%eax
  100b2c:	05 08 f0 10 00       	add    $0x10f008,%eax
  100b31:	8b 10                	mov    (%eax),%edx
  100b33:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b36:	83 c0 04             	add    $0x4,%eax
  100b39:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100b3c:	49                   	dec    %ecx
  100b3d:	83 ec 04             	sub    $0x4,%esp
  100b40:	ff 75 0c             	pushl  0xc(%ebp)
  100b43:	50                   	push   %eax
  100b44:	51                   	push   %ecx
  100b45:	ff d2                	call   *%edx
  100b47:	83 c4 10             	add    $0x10,%esp
  100b4a:	eb 24                	jmp    100b70 <runcmd+0xab>
    for (i = 0; i < NCOMMANDS; i ++) {
  100b4c:	ff 45 f4             	incl   -0xc(%ebp)
  100b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b52:	83 f8 02             	cmp    $0x2,%eax
  100b55:	76 a2                	jbe    100af9 <runcmd+0x34>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100b57:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100b5a:	83 ec 08             	sub    $0x8,%esp
  100b5d:	50                   	push   %eax
  100b5e:	68 07 34 10 00       	push   $0x103407
  100b63:	e8 8e f7 ff ff       	call   1002f6 <cprintf>
  100b68:	83 c4 10             	add    $0x10,%esp
    return 0;
  100b6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100b70:	c9                   	leave  
  100b71:	c3                   	ret    

00100b72 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100b72:	55                   	push   %ebp
  100b73:	89 e5                	mov    %esp,%ebp
  100b75:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100b78:	83 ec 0c             	sub    $0xc,%esp
  100b7b:	68 20 34 10 00       	push   $0x103420
  100b80:	e8 71 f7 ff ff       	call   1002f6 <cprintf>
  100b85:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100b88:	83 ec 0c             	sub    $0xc,%esp
  100b8b:	68 48 34 10 00       	push   $0x103448
  100b90:	e8 61 f7 ff ff       	call   1002f6 <cprintf>
  100b95:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100b98:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100b9c:	74 0e                	je     100bac <kmonitor+0x3a>
        print_trapframe(tf);
  100b9e:	83 ec 0c             	sub    $0xc,%esp
  100ba1:	ff 75 08             	pushl  0x8(%ebp)
  100ba4:	e8 2d 0c 00 00       	call   1017d6 <print_trapframe>
  100ba9:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100bac:	83 ec 0c             	sub    $0xc,%esp
  100baf:	68 6d 34 10 00       	push   $0x10346d
  100bb4:	e8 2f f6 ff ff       	call   1001e8 <readline>
  100bb9:	83 c4 10             	add    $0x10,%esp
  100bbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100bbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100bc3:	74 e7                	je     100bac <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
  100bc5:	83 ec 08             	sub    $0x8,%esp
  100bc8:	ff 75 08             	pushl  0x8(%ebp)
  100bcb:	ff 75 f4             	pushl  -0xc(%ebp)
  100bce:	e8 f2 fe ff ff       	call   100ac5 <runcmd>
  100bd3:	83 c4 10             	add    $0x10,%esp
  100bd6:	85 c0                	test   %eax,%eax
  100bd8:	78 02                	js     100bdc <kmonitor+0x6a>
        if ((buf = readline("K> ")) != NULL) {
  100bda:	eb d0                	jmp    100bac <kmonitor+0x3a>
                break;
  100bdc:	90                   	nop
            }
        }
    }
}
  100bdd:	90                   	nop
  100bde:	c9                   	leave  
  100bdf:	c3                   	ret    

00100be0 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100be0:	55                   	push   %ebp
  100be1:	89 e5                	mov    %esp,%ebp
  100be3:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100be6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100bed:	eb 3b                	jmp    100c2a <mon_help+0x4a>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100bef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bf2:	89 d0                	mov    %edx,%eax
  100bf4:	01 c0                	add    %eax,%eax
  100bf6:	01 d0                	add    %edx,%eax
  100bf8:	c1 e0 02             	shl    $0x2,%eax
  100bfb:	05 04 f0 10 00       	add    $0x10f004,%eax
  100c00:	8b 10                	mov    (%eax),%edx
  100c02:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100c05:	89 c8                	mov    %ecx,%eax
  100c07:	01 c0                	add    %eax,%eax
  100c09:	01 c8                	add    %ecx,%eax
  100c0b:	c1 e0 02             	shl    $0x2,%eax
  100c0e:	05 00 f0 10 00       	add    $0x10f000,%eax
  100c13:	8b 00                	mov    (%eax),%eax
  100c15:	83 ec 04             	sub    $0x4,%esp
  100c18:	52                   	push   %edx
  100c19:	50                   	push   %eax
  100c1a:	68 71 34 10 00       	push   $0x103471
  100c1f:	e8 d2 f6 ff ff       	call   1002f6 <cprintf>
  100c24:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NCOMMANDS; i ++) {
  100c27:	ff 45 f4             	incl   -0xc(%ebp)
  100c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c2d:	83 f8 02             	cmp    $0x2,%eax
  100c30:	76 bd                	jbe    100bef <mon_help+0xf>
    }
    return 0;
  100c32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c37:	c9                   	leave  
  100c38:	c3                   	ret    

00100c39 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c39:	55                   	push   %ebp
  100c3a:	89 e5                	mov    %esp,%ebp
  100c3c:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c3f:	e8 b5 fb ff ff       	call   1007f9 <print_kerninfo>
    return 0;
  100c44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c49:	c9                   	leave  
  100c4a:	c3                   	ret    

00100c4b <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100c4b:	55                   	push   %ebp
  100c4c:	89 e5                	mov    %esp,%ebp
  100c4e:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100c51:	e8 e7 fc ff ff       	call   10093d <print_stackframe>
    return 0;
  100c56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c5b:	c9                   	leave  
  100c5c:	c3                   	ret    

00100c5d <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100c5d:	55                   	push   %ebp
  100c5e:	89 e5                	mov    %esp,%ebp
  100c60:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
  100c63:	a1 40 fe 10 00       	mov    0x10fe40,%eax
  100c68:	85 c0                	test   %eax,%eax
  100c6a:	75 5f                	jne    100ccb <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
  100c6c:	c7 05 40 fe 10 00 01 	movl   $0x1,0x10fe40
  100c73:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100c76:	8d 45 14             	lea    0x14(%ebp),%eax
  100c79:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100c7c:	83 ec 04             	sub    $0x4,%esp
  100c7f:	ff 75 0c             	pushl  0xc(%ebp)
  100c82:	ff 75 08             	pushl  0x8(%ebp)
  100c85:	68 7a 34 10 00       	push   $0x10347a
  100c8a:	e8 67 f6 ff ff       	call   1002f6 <cprintf>
  100c8f:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c95:	83 ec 08             	sub    $0x8,%esp
  100c98:	50                   	push   %eax
  100c99:	ff 75 10             	pushl  0x10(%ebp)
  100c9c:	e8 2c f6 ff ff       	call   1002cd <vcprintf>
  100ca1:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100ca4:	83 ec 0c             	sub    $0xc,%esp
  100ca7:	68 96 34 10 00       	push   $0x103496
  100cac:	e8 45 f6 ff ff       	call   1002f6 <cprintf>
  100cb1:	83 c4 10             	add    $0x10,%esp
    
    cprintf("stack trackback:\n");
  100cb4:	83 ec 0c             	sub    $0xc,%esp
  100cb7:	68 98 34 10 00       	push   $0x103498
  100cbc:	e8 35 f6 ff ff       	call   1002f6 <cprintf>
  100cc1:	83 c4 10             	add    $0x10,%esp
    print_stackframe();
  100cc4:	e8 74 fc ff ff       	call   10093d <print_stackframe>
  100cc9:	eb 01                	jmp    100ccc <__panic+0x6f>
        goto panic_dead;
  100ccb:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  100ccc:	e8 e9 08 00 00       	call   1015ba <intr_disable>
    while (1) {
        kmonitor(NULL);
  100cd1:	83 ec 0c             	sub    $0xc,%esp
  100cd4:	6a 00                	push   $0x0
  100cd6:	e8 97 fe ff ff       	call   100b72 <kmonitor>
  100cdb:	83 c4 10             	add    $0x10,%esp
  100cde:	eb f1                	jmp    100cd1 <__panic+0x74>

00100ce0 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100ce0:	55                   	push   %ebp
  100ce1:	89 e5                	mov    %esp,%ebp
  100ce3:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
  100ce6:	8d 45 14             	lea    0x14(%ebp),%eax
  100ce9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100cec:	83 ec 04             	sub    $0x4,%esp
  100cef:	ff 75 0c             	pushl  0xc(%ebp)
  100cf2:	ff 75 08             	pushl  0x8(%ebp)
  100cf5:	68 aa 34 10 00       	push   $0x1034aa
  100cfa:	e8 f7 f5 ff ff       	call   1002f6 <cprintf>
  100cff:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d05:	83 ec 08             	sub    $0x8,%esp
  100d08:	50                   	push   %eax
  100d09:	ff 75 10             	pushl  0x10(%ebp)
  100d0c:	e8 bc f5 ff ff       	call   1002cd <vcprintf>
  100d11:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100d14:	83 ec 0c             	sub    $0xc,%esp
  100d17:	68 96 34 10 00       	push   $0x103496
  100d1c:	e8 d5 f5 ff ff       	call   1002f6 <cprintf>
  100d21:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  100d24:	90                   	nop
  100d25:	c9                   	leave  
  100d26:	c3                   	ret    

00100d27 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d27:	55                   	push   %ebp
  100d28:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d2a:	a1 40 fe 10 00       	mov    0x10fe40,%eax
}
  100d2f:	5d                   	pop    %ebp
  100d30:	c3                   	ret    

00100d31 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d31:	55                   	push   %ebp
  100d32:	89 e5                	mov    %esp,%ebp
  100d34:	83 ec 18             	sub    $0x18,%esp
  100d37:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100d3d:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d41:	8a 45 ed             	mov    -0x13(%ebp),%al
  100d44:	66 8b 55 ee          	mov    -0x12(%ebp),%dx
  100d48:	ee                   	out    %al,(%dx)
  100d49:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d4f:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d53:	8a 45 f1             	mov    -0xf(%ebp),%al
  100d56:	66 8b 55 f2          	mov    -0xe(%ebp),%dx
  100d5a:	ee                   	out    %al,(%dx)
  100d5b:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100d61:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
  100d65:	8a 45 f5             	mov    -0xb(%ebp),%al
  100d68:	66 8b 55 f6          	mov    -0xa(%ebp),%dx
  100d6c:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d6d:	c7 05 08 09 11 00 00 	movl   $0x0,0x110908
  100d74:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d77:	83 ec 0c             	sub    $0xc,%esp
  100d7a:	68 c8 34 10 00       	push   $0x1034c8
  100d7f:	e8 72 f5 ff ff       	call   1002f6 <cprintf>
  100d84:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100d87:	83 ec 0c             	sub    $0xc,%esp
  100d8a:	6a 00                	push   $0x0
  100d8c:	e8 84 08 00 00       	call   101615 <pic_enable>
  100d91:	83 c4 10             	add    $0x10,%esp
}
  100d94:	90                   	nop
  100d95:	c9                   	leave  
  100d96:	c3                   	ret    

00100d97 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100d97:	55                   	push   %ebp
  100d98:	89 e5                	mov    %esp,%ebp
  100d9a:	83 ec 10             	sub    $0x10,%esp
  100d9d:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100da3:	66 8b 45 f2          	mov    -0xe(%ebp),%ax
  100da7:	89 c2                	mov    %eax,%edx
  100da9:	ec                   	in     (%dx),%al
  100daa:	88 45 f1             	mov    %al,-0xf(%ebp)
  100dad:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100db3:	66 8b 45 f6          	mov    -0xa(%ebp),%ax
  100db7:	89 c2                	mov    %eax,%edx
  100db9:	ec                   	in     (%dx),%al
  100dba:	88 45 f5             	mov    %al,-0xb(%ebp)
  100dbd:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100dc3:	66 8b 45 fa          	mov    -0x6(%ebp),%ax
  100dc7:	89 c2                	mov    %eax,%edx
  100dc9:	ec                   	in     (%dx),%al
  100dca:	88 45 f9             	mov    %al,-0x7(%ebp)
  100dcd:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100dd3:	66 8b 45 fe          	mov    -0x2(%ebp),%ax
  100dd7:	89 c2                	mov    %eax,%edx
  100dd9:	ec                   	in     (%dx),%al
  100dda:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100ddd:	90                   	nop
  100dde:	c9                   	leave  
  100ddf:	c3                   	ret    

00100de0 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100de0:	55                   	push   %ebp
  100de1:	89 e5                	mov    %esp,%ebp
  100de3:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100de6:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100ded:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100df0:	66 8b 00             	mov    (%eax),%ax
  100df3:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100df7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100dfa:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100dff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e02:	66 8b 00             	mov    (%eax),%ax
  100e05:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e09:	74 12                	je     100e1d <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e0b:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e12:	66 c7 05 66 fe 10 00 	movw   $0x3b4,0x10fe66
  100e19:	b4 03 
  100e1b:	eb 13                	jmp    100e30 <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e1d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100e20:	66 8b 45 fa          	mov    -0x6(%ebp),%ax
  100e24:	66 89 02             	mov    %ax,(%edx)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e27:	66 c7 05 66 fe 10 00 	movw   $0x3d4,0x10fe66
  100e2e:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e30:	66 a1 66 fe 10 00    	mov    0x10fe66,%ax
  100e36:	0f b7 c0             	movzwl %ax,%eax
  100e39:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100e3d:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e41:	8a 45 e5             	mov    -0x1b(%ebp),%al
  100e44:	66 8b 55 e6          	mov    -0x1a(%ebp),%dx
  100e48:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e49:	66 a1 66 fe 10 00    	mov    0x10fe66,%ax
  100e4f:	40                   	inc    %eax
  100e50:	0f b7 c0             	movzwl %ax,%eax
  100e53:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e57:	66 8b 45 ea          	mov    -0x16(%ebp),%ax
  100e5b:	89 c2                	mov    %eax,%edx
  100e5d:	ec                   	in     (%dx),%al
  100e5e:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100e61:	8a 45 e9             	mov    -0x17(%ebp),%al
  100e64:	0f b6 c0             	movzbl %al,%eax
  100e67:	c1 e0 08             	shl    $0x8,%eax
  100e6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e6d:	66 a1 66 fe 10 00    	mov    0x10fe66,%ax
  100e73:	0f b7 c0             	movzwl %ax,%eax
  100e76:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100e7a:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e7e:	8a 45 ed             	mov    -0x13(%ebp),%al
  100e81:	66 8b 55 ee          	mov    -0x12(%ebp),%dx
  100e85:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100e86:	66 a1 66 fe 10 00    	mov    0x10fe66,%ax
  100e8c:	40                   	inc    %eax
  100e8d:	0f b7 c0             	movzwl %ax,%eax
  100e90:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e94:	66 8b 45 f2          	mov    -0xe(%ebp),%ax
  100e98:	89 c2                	mov    %eax,%edx
  100e9a:	ec                   	in     (%dx),%al
  100e9b:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100e9e:	8a 45 f1             	mov    -0xf(%ebp),%al
  100ea1:	0f b6 c0             	movzbl %al,%eax
  100ea4:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100ea7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eaa:	a3 60 fe 10 00       	mov    %eax,0x10fe60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100eb2:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
}
  100eb8:	90                   	nop
  100eb9:	c9                   	leave  
  100eba:	c3                   	ret    

00100ebb <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100ebb:	55                   	push   %ebp
  100ebc:	89 e5                	mov    %esp,%ebp
  100ebe:	83 ec 38             	sub    $0x38,%esp
  100ec1:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100ec7:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ecb:	8a 45 d1             	mov    -0x2f(%ebp),%al
  100ece:	66 8b 55 d2          	mov    -0x2e(%ebp),%dx
  100ed2:	ee                   	out    %al,(%dx)
  100ed3:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100ed9:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
  100edd:	8a 45 d5             	mov    -0x2b(%ebp),%al
  100ee0:	66 8b 55 d6          	mov    -0x2a(%ebp),%dx
  100ee4:	ee                   	out    %al,(%dx)
  100ee5:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100eeb:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
  100eef:	8a 45 d9             	mov    -0x27(%ebp),%al
  100ef2:	66 8b 55 da          	mov    -0x26(%ebp),%dx
  100ef6:	ee                   	out    %al,(%dx)
  100ef7:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100efd:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100f01:	8a 45 dd             	mov    -0x23(%ebp),%al
  100f04:	66 8b 55 de          	mov    -0x22(%ebp),%dx
  100f08:	ee                   	out    %al,(%dx)
  100f09:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100f0f:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
  100f13:	8a 45 e1             	mov    -0x1f(%ebp),%al
  100f16:	66 8b 55 e2          	mov    -0x1e(%ebp),%dx
  100f1a:	ee                   	out    %al,(%dx)
  100f1b:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100f21:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  100f25:	8a 45 e5             	mov    -0x1b(%ebp),%al
  100f28:	66 8b 55 e6          	mov    -0x1a(%ebp),%dx
  100f2c:	ee                   	out    %al,(%dx)
  100f2d:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f33:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
  100f37:	8a 45 e9             	mov    -0x17(%ebp),%al
  100f3a:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
  100f3e:	ee                   	out    %al,(%dx)
  100f3f:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f45:	66 8b 45 ee          	mov    -0x12(%ebp),%ax
  100f49:	89 c2                	mov    %eax,%edx
  100f4b:	ec                   	in     (%dx),%al
  100f4c:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100f4f:	8a 45 ed             	mov    -0x13(%ebp),%al
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f52:	3c ff                	cmp    $0xff,%al
  100f54:	0f 95 c0             	setne  %al
  100f57:	0f b6 c0             	movzbl %al,%eax
  100f5a:	a3 68 fe 10 00       	mov    %eax,0x10fe68
  100f5f:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f65:	66 8b 45 f2          	mov    -0xe(%ebp),%ax
  100f69:	89 c2                	mov    %eax,%edx
  100f6b:	ec                   	in     (%dx),%al
  100f6c:	88 45 f1             	mov    %al,-0xf(%ebp)
  100f6f:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  100f75:	66 8b 45 f6          	mov    -0xa(%ebp),%ax
  100f79:	89 c2                	mov    %eax,%edx
  100f7b:	ec                   	in     (%dx),%al
  100f7c:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100f7f:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  100f84:	85 c0                	test   %eax,%eax
  100f86:	74 0d                	je     100f95 <serial_init+0xda>
        pic_enable(IRQ_COM1);
  100f88:	83 ec 0c             	sub    $0xc,%esp
  100f8b:	6a 04                	push   $0x4
  100f8d:	e8 83 06 00 00       	call   101615 <pic_enable>
  100f92:	83 c4 10             	add    $0x10,%esp
    }
}
  100f95:	90                   	nop
  100f96:	c9                   	leave  
  100f97:	c3                   	ret    

00100f98 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100f98:	55                   	push   %ebp
  100f99:	89 e5                	mov    %esp,%ebp
  100f9b:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100f9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fa5:	eb 08                	jmp    100faf <lpt_putc_sub+0x17>
        delay();
  100fa7:	e8 eb fd ff ff       	call   100d97 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fac:	ff 45 fc             	incl   -0x4(%ebp)
  100faf:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100fb5:	66 8b 45 fa          	mov    -0x6(%ebp),%ax
  100fb9:	89 c2                	mov    %eax,%edx
  100fbb:	ec                   	in     (%dx),%al
  100fbc:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100fbf:	8a 45 f9             	mov    -0x7(%ebp),%al
  100fc2:	84 c0                	test   %al,%al
  100fc4:	78 09                	js     100fcf <lpt_putc_sub+0x37>
  100fc6:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100fcd:	7e d8                	jle    100fa7 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  100fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  100fd2:	0f b6 c0             	movzbl %al,%eax
  100fd5:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  100fdb:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fde:	8a 45 ed             	mov    -0x13(%ebp),%al
  100fe1:	66 8b 55 ee          	mov    -0x12(%ebp),%dx
  100fe5:	ee                   	out    %al,(%dx)
  100fe6:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  100fec:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  100ff0:	8a 45 f1             	mov    -0xf(%ebp),%al
  100ff3:	66 8b 55 f2          	mov    -0xe(%ebp),%dx
  100ff7:	ee                   	out    %al,(%dx)
  100ff8:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  100ffe:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
  101002:	8a 45 f5             	mov    -0xb(%ebp),%al
  101005:	66 8b 55 f6          	mov    -0xa(%ebp),%dx
  101009:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  10100a:	90                   	nop
  10100b:	c9                   	leave  
  10100c:	c3                   	ret    

0010100d <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10100d:	55                   	push   %ebp
  10100e:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  101010:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101014:	74 0d                	je     101023 <lpt_putc+0x16>
        lpt_putc_sub(c);
  101016:	ff 75 08             	pushl  0x8(%ebp)
  101019:	e8 7a ff ff ff       	call   100f98 <lpt_putc_sub>
  10101e:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  101021:	eb 1e                	jmp    101041 <lpt_putc+0x34>
        lpt_putc_sub('\b');
  101023:	6a 08                	push   $0x8
  101025:	e8 6e ff ff ff       	call   100f98 <lpt_putc_sub>
  10102a:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  10102d:	6a 20                	push   $0x20
  10102f:	e8 64 ff ff ff       	call   100f98 <lpt_putc_sub>
  101034:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  101037:	6a 08                	push   $0x8
  101039:	e8 5a ff ff ff       	call   100f98 <lpt_putc_sub>
  10103e:	83 c4 04             	add    $0x4,%esp
}
  101041:	90                   	nop
  101042:	c9                   	leave  
  101043:	c3                   	ret    

00101044 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101044:	55                   	push   %ebp
  101045:	89 e5                	mov    %esp,%ebp
  101047:	53                   	push   %ebx
  101048:	83 ec 24             	sub    $0x24,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10104b:	8b 45 08             	mov    0x8(%ebp),%eax
  10104e:	b0 00                	mov    $0x0,%al
  101050:	85 c0                	test   %eax,%eax
  101052:	75 07                	jne    10105b <cga_putc+0x17>
        c |= 0x0700;
  101054:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10105b:	8b 45 08             	mov    0x8(%ebp),%eax
  10105e:	0f b6 c0             	movzbl %al,%eax
  101061:	83 f8 0a             	cmp    $0xa,%eax
  101064:	74 4a                	je     1010b0 <cga_putc+0x6c>
  101066:	83 f8 0d             	cmp    $0xd,%eax
  101069:	74 54                	je     1010bf <cga_putc+0x7b>
  10106b:	83 f8 08             	cmp    $0x8,%eax
  10106e:	75 77                	jne    1010e7 <cga_putc+0xa3>
    case '\b':
        if (crt_pos > 0) {
  101070:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  101076:	66 85 c0             	test   %ax,%ax
  101079:	0f 84 8e 00 00 00    	je     10110d <cga_putc+0xc9>
            crt_pos --;
  10107f:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  101085:	48                   	dec    %eax
  101086:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  10108c:	8b 45 08             	mov    0x8(%ebp),%eax
  10108f:	b0 00                	mov    $0x0,%al
  101091:	83 c8 20             	or     $0x20,%eax
  101094:	89 c2                	mov    %eax,%edx
  101096:	8b 0d 60 fe 10 00    	mov    0x10fe60,%ecx
  10109c:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  1010a2:	0f b7 c0             	movzwl %ax,%eax
  1010a5:	01 c0                	add    %eax,%eax
  1010a7:	01 c1                	add    %eax,%ecx
  1010a9:	89 d0                	mov    %edx,%eax
  1010ab:	66 89 01             	mov    %ax,(%ecx)
        }
        break;
  1010ae:	eb 5d                	jmp    10110d <cga_putc+0xc9>
    case '\n':
        crt_pos += CRT_COLS;
  1010b0:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  1010b6:	83 c0 50             	add    $0x50,%eax
  1010b9:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1010bf:	66 8b 0d 64 fe 10 00 	mov    0x10fe64,%cx
  1010c6:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  1010cc:	bb 50 00 00 00       	mov    $0x50,%ebx
  1010d1:	ba 00 00 00 00       	mov    $0x0,%edx
  1010d6:	66 f7 f3             	div    %bx
  1010d9:	89 d0                	mov    %edx,%eax
  1010db:	29 c1                	sub    %eax,%ecx
  1010dd:	89 c8                	mov    %ecx,%eax
  1010df:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
        break;
  1010e5:	eb 27                	jmp    10110e <cga_putc+0xca>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1010e7:	8b 0d 60 fe 10 00    	mov    0x10fe60,%ecx
  1010ed:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  1010f3:	8d 50 01             	lea    0x1(%eax),%edx
  1010f6:	66 89 15 64 fe 10 00 	mov    %dx,0x10fe64
  1010fd:	0f b7 c0             	movzwl %ax,%eax
  101100:	01 c0                	add    %eax,%eax
  101102:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101105:	8b 45 08             	mov    0x8(%ebp),%eax
  101108:	66 89 02             	mov    %ax,(%edx)
        break;
  10110b:	eb 01                	jmp    10110e <cga_putc+0xca>
        break;
  10110d:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  10110e:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  101114:	66 3d cf 07          	cmp    $0x7cf,%ax
  101118:	76 58                	jbe    101172 <cga_putc+0x12e>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10111a:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  10111f:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101125:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  10112a:	83 ec 04             	sub    $0x4,%esp
  10112d:	68 00 0f 00 00       	push   $0xf00
  101132:	52                   	push   %edx
  101133:	50                   	push   %eax
  101134:	e8 1e 1f 00 00       	call   103057 <memmove>
  101139:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10113c:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101143:	eb 15                	jmp    10115a <cga_putc+0x116>
            crt_buf[i] = 0x0700 | ' ';
  101145:	8b 15 60 fe 10 00    	mov    0x10fe60,%edx
  10114b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10114e:	01 c0                	add    %eax,%eax
  101150:	01 d0                	add    %edx,%eax
  101152:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101157:	ff 45 f4             	incl   -0xc(%ebp)
  10115a:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101161:	7e e2                	jle    101145 <cga_putc+0x101>
        }
        crt_pos -= CRT_COLS;
  101163:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  101169:	83 e8 50             	sub    $0x50,%eax
  10116c:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101172:	66 a1 66 fe 10 00    	mov    0x10fe66,%ax
  101178:	0f b7 c0             	movzwl %ax,%eax
  10117b:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  10117f:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
  101183:	8a 45 e5             	mov    -0x1b(%ebp),%al
  101186:	66 8b 55 e6          	mov    -0x1a(%ebp),%dx
  10118a:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  10118b:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  101191:	66 c1 e8 08          	shr    $0x8,%ax
  101195:	0f b6 d0             	movzbl %al,%edx
  101198:	66 a1 66 fe 10 00    	mov    0x10fe66,%ax
  10119e:	40                   	inc    %eax
  10119f:	0f b7 c0             	movzwl %ax,%eax
  1011a2:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  1011a6:	88 55 e9             	mov    %dl,-0x17(%ebp)
  1011a9:	8a 45 e9             	mov    -0x17(%ebp),%al
  1011ac:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
  1011b0:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  1011b1:	66 a1 66 fe 10 00    	mov    0x10fe66,%ax
  1011b7:	0f b7 c0             	movzwl %ax,%eax
  1011ba:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  1011be:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
  1011c2:	8a 45 ed             	mov    -0x13(%ebp),%al
  1011c5:	66 8b 55 ee          	mov    -0x12(%ebp),%dx
  1011c9:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  1011ca:	66 a1 64 fe 10 00    	mov    0x10fe64,%ax
  1011d0:	0f b6 d0             	movzbl %al,%edx
  1011d3:	66 a1 66 fe 10 00    	mov    0x10fe66,%ax
  1011d9:	40                   	inc    %eax
  1011da:	0f b7 c0             	movzwl %ax,%eax
  1011dd:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011e1:	88 55 f1             	mov    %dl,-0xf(%ebp)
  1011e4:	8a 45 f1             	mov    -0xf(%ebp),%al
  1011e7:	66 8b 55 f2          	mov    -0xe(%ebp),%dx
  1011eb:	ee                   	out    %al,(%dx)
}
  1011ec:	90                   	nop
  1011ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1011f0:	c9                   	leave  
  1011f1:	c3                   	ret    

001011f2 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1011f2:	55                   	push   %ebp
  1011f3:	89 e5                	mov    %esp,%ebp
  1011f5:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1011f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1011ff:	eb 08                	jmp    101209 <serial_putc_sub+0x17>
        delay();
  101201:	e8 91 fb ff ff       	call   100d97 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101206:	ff 45 fc             	incl   -0x4(%ebp)
  101209:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10120f:	66 8b 45 fa          	mov    -0x6(%ebp),%ax
  101213:	89 c2                	mov    %eax,%edx
  101215:	ec                   	in     (%dx),%al
  101216:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101219:	8a 45 f9             	mov    -0x7(%ebp),%al
  10121c:	0f b6 c0             	movzbl %al,%eax
  10121f:	83 e0 20             	and    $0x20,%eax
  101222:	85 c0                	test   %eax,%eax
  101224:	75 09                	jne    10122f <serial_putc_sub+0x3d>
  101226:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10122d:	7e d2                	jle    101201 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  10122f:	8b 45 08             	mov    0x8(%ebp),%eax
  101232:	0f b6 c0             	movzbl %al,%eax
  101235:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10123b:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10123e:	8a 45 f5             	mov    -0xb(%ebp),%al
  101241:	66 8b 55 f6          	mov    -0xa(%ebp),%dx
  101245:	ee                   	out    %al,(%dx)
}
  101246:	90                   	nop
  101247:	c9                   	leave  
  101248:	c3                   	ret    

00101249 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101249:	55                   	push   %ebp
  10124a:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  10124c:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101250:	74 0d                	je     10125f <serial_putc+0x16>
        serial_putc_sub(c);
  101252:	ff 75 08             	pushl  0x8(%ebp)
  101255:	e8 98 ff ff ff       	call   1011f2 <serial_putc_sub>
  10125a:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  10125d:	eb 1e                	jmp    10127d <serial_putc+0x34>
        serial_putc_sub('\b');
  10125f:	6a 08                	push   $0x8
  101261:	e8 8c ff ff ff       	call   1011f2 <serial_putc_sub>
  101266:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  101269:	6a 20                	push   $0x20
  10126b:	e8 82 ff ff ff       	call   1011f2 <serial_putc_sub>
  101270:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  101273:	6a 08                	push   $0x8
  101275:	e8 78 ff ff ff       	call   1011f2 <serial_putc_sub>
  10127a:	83 c4 04             	add    $0x4,%esp
}
  10127d:	90                   	nop
  10127e:	c9                   	leave  
  10127f:	c3                   	ret    

00101280 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101280:	55                   	push   %ebp
  101281:	89 e5                	mov    %esp,%ebp
  101283:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101286:	eb 33                	jmp    1012bb <cons_intr+0x3b>
        if (c != 0) {
  101288:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10128c:	74 2d                	je     1012bb <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  10128e:	a1 84 00 11 00       	mov    0x110084,%eax
  101293:	8d 50 01             	lea    0x1(%eax),%edx
  101296:	89 15 84 00 11 00    	mov    %edx,0x110084
  10129c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10129f:	88 90 80 fe 10 00    	mov    %dl,0x10fe80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1012a5:	a1 84 00 11 00       	mov    0x110084,%eax
  1012aa:	3d 00 02 00 00       	cmp    $0x200,%eax
  1012af:	75 0a                	jne    1012bb <cons_intr+0x3b>
                cons.wpos = 0;
  1012b1:	c7 05 84 00 11 00 00 	movl   $0x0,0x110084
  1012b8:	00 00 00 
    while ((c = (*proc)()) != -1) {
  1012bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1012be:	ff d0                	call   *%eax
  1012c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1012c3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1012c7:	75 bf                	jne    101288 <cons_intr+0x8>
            }
        }
    }
}
  1012c9:	90                   	nop
  1012ca:	c9                   	leave  
  1012cb:	c3                   	ret    

001012cc <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1012cc:	55                   	push   %ebp
  1012cd:	89 e5                	mov    %esp,%ebp
  1012cf:	83 ec 10             	sub    $0x10,%esp
  1012d2:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1012d8:	66 8b 45 fa          	mov    -0x6(%ebp),%ax
  1012dc:	89 c2                	mov    %eax,%edx
  1012de:	ec                   	in     (%dx),%al
  1012df:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012e2:	8a 45 f9             	mov    -0x7(%ebp),%al
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1012e5:	0f b6 c0             	movzbl %al,%eax
  1012e8:	83 e0 01             	and    $0x1,%eax
  1012eb:	85 c0                	test   %eax,%eax
  1012ed:	75 07                	jne    1012f6 <serial_proc_data+0x2a>
        return -1;
  1012ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1012f4:	eb 29                	jmp    10131f <serial_proc_data+0x53>
  1012f6:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1012fc:	66 8b 45 f6          	mov    -0xa(%ebp),%ax
  101300:	89 c2                	mov    %eax,%edx
  101302:	ec                   	in     (%dx),%al
  101303:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101306:	8a 45 f5             	mov    -0xb(%ebp),%al
    }
    int c = inb(COM1 + COM_RX);
  101309:	0f b6 c0             	movzbl %al,%eax
  10130c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  10130f:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101313:	75 07                	jne    10131c <serial_proc_data+0x50>
        c = '\b';
  101315:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10131c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10131f:	c9                   	leave  
  101320:	c3                   	ret    

00101321 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101321:	55                   	push   %ebp
  101322:	89 e5                	mov    %esp,%ebp
  101324:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
  101327:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  10132c:	85 c0                	test   %eax,%eax
  10132e:	74 10                	je     101340 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  101330:	83 ec 0c             	sub    $0xc,%esp
  101333:	68 cc 12 10 00       	push   $0x1012cc
  101338:	e8 43 ff ff ff       	call   101280 <cons_intr>
  10133d:	83 c4 10             	add    $0x10,%esp
    }
}
  101340:	90                   	nop
  101341:	c9                   	leave  
  101342:	c3                   	ret    

00101343 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101343:	55                   	push   %ebp
  101344:	89 e5                	mov    %esp,%ebp
  101346:	83 ec 28             	sub    $0x28,%esp
  101349:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10134f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101352:	89 c2                	mov    %eax,%edx
  101354:	ec                   	in     (%dx),%al
  101355:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101358:	8a 45 ef             	mov    -0x11(%ebp),%al
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  10135b:	0f b6 c0             	movzbl %al,%eax
  10135e:	83 e0 01             	and    $0x1,%eax
  101361:	85 c0                	test   %eax,%eax
  101363:	75 0a                	jne    10136f <kbd_proc_data+0x2c>
        return -1;
  101365:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10136a:	e9 52 01 00 00       	jmp    1014c1 <kbd_proc_data+0x17e>
  10136f:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101375:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101378:	89 c2                	mov    %eax,%edx
  10137a:	ec                   	in     (%dx),%al
  10137b:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10137e:	8a 45 eb             	mov    -0x15(%ebp),%al
    }

    data = inb(KBDATAP);
  101381:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101384:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101388:	75 17                	jne    1013a1 <kbd_proc_data+0x5e>
        // E0 escape character
        shift |= E0ESC;
  10138a:	a1 88 00 11 00       	mov    0x110088,%eax
  10138f:	83 c8 40             	or     $0x40,%eax
  101392:	a3 88 00 11 00       	mov    %eax,0x110088
        return 0;
  101397:	b8 00 00 00 00       	mov    $0x0,%eax
  10139c:	e9 20 01 00 00       	jmp    1014c1 <kbd_proc_data+0x17e>
    } else if (data & 0x80) {
  1013a1:	8a 45 f3             	mov    -0xd(%ebp),%al
  1013a4:	84 c0                	test   %al,%al
  1013a6:	79 44                	jns    1013ec <kbd_proc_data+0xa9>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1013a8:	a1 88 00 11 00       	mov    0x110088,%eax
  1013ad:	83 e0 40             	and    $0x40,%eax
  1013b0:	85 c0                	test   %eax,%eax
  1013b2:	75 08                	jne    1013bc <kbd_proc_data+0x79>
  1013b4:	8a 45 f3             	mov    -0xd(%ebp),%al
  1013b7:	83 e0 7f             	and    $0x7f,%eax
  1013ba:	eb 03                	jmp    1013bf <kbd_proc_data+0x7c>
  1013bc:	8a 45 f3             	mov    -0xd(%ebp),%al
  1013bf:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1013c2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013c6:	8a 80 40 f0 10 00    	mov    0x10f040(%eax),%al
  1013cc:	83 c8 40             	or     $0x40,%eax
  1013cf:	0f b6 c0             	movzbl %al,%eax
  1013d2:	f7 d0                	not    %eax
  1013d4:	89 c2                	mov    %eax,%edx
  1013d6:	a1 88 00 11 00       	mov    0x110088,%eax
  1013db:	21 d0                	and    %edx,%eax
  1013dd:	a3 88 00 11 00       	mov    %eax,0x110088
        return 0;
  1013e2:	b8 00 00 00 00       	mov    $0x0,%eax
  1013e7:	e9 d5 00 00 00       	jmp    1014c1 <kbd_proc_data+0x17e>
    } else if (shift & E0ESC) {
  1013ec:	a1 88 00 11 00       	mov    0x110088,%eax
  1013f1:	83 e0 40             	and    $0x40,%eax
  1013f4:	85 c0                	test   %eax,%eax
  1013f6:	74 11                	je     101409 <kbd_proc_data+0xc6>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1013f8:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1013fc:	a1 88 00 11 00       	mov    0x110088,%eax
  101401:	83 e0 bf             	and    $0xffffffbf,%eax
  101404:	a3 88 00 11 00       	mov    %eax,0x110088
    }

    shift |= shiftcode[data];
  101409:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10140d:	8a 80 40 f0 10 00    	mov    0x10f040(%eax),%al
  101413:	0f b6 d0             	movzbl %al,%edx
  101416:	a1 88 00 11 00       	mov    0x110088,%eax
  10141b:	09 d0                	or     %edx,%eax
  10141d:	a3 88 00 11 00       	mov    %eax,0x110088
    shift ^= togglecode[data];
  101422:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101426:	8a 80 40 f1 10 00    	mov    0x10f140(%eax),%al
  10142c:	0f b6 d0             	movzbl %al,%edx
  10142f:	a1 88 00 11 00       	mov    0x110088,%eax
  101434:	31 d0                	xor    %edx,%eax
  101436:	a3 88 00 11 00       	mov    %eax,0x110088

    c = charcode[shift & (CTL | SHIFT)][data];
  10143b:	a1 88 00 11 00       	mov    0x110088,%eax
  101440:	83 e0 03             	and    $0x3,%eax
  101443:	8b 14 85 40 f5 10 00 	mov    0x10f540(,%eax,4),%edx
  10144a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10144e:	01 d0                	add    %edx,%eax
  101450:	8a 00                	mov    (%eax),%al
  101452:	0f b6 c0             	movzbl %al,%eax
  101455:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101458:	a1 88 00 11 00       	mov    0x110088,%eax
  10145d:	83 e0 08             	and    $0x8,%eax
  101460:	85 c0                	test   %eax,%eax
  101462:	74 22                	je     101486 <kbd_proc_data+0x143>
        if ('a' <= c && c <= 'z')
  101464:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101468:	7e 0c                	jle    101476 <kbd_proc_data+0x133>
  10146a:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  10146e:	7f 06                	jg     101476 <kbd_proc_data+0x133>
            c += 'A' - 'a';
  101470:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101474:	eb 10                	jmp    101486 <kbd_proc_data+0x143>
        else if ('A' <= c && c <= 'Z')
  101476:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  10147a:	7e 0a                	jle    101486 <kbd_proc_data+0x143>
  10147c:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101480:	7f 04                	jg     101486 <kbd_proc_data+0x143>
            c += 'a' - 'A';
  101482:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101486:	a1 88 00 11 00       	mov    0x110088,%eax
  10148b:	f7 d0                	not    %eax
  10148d:	83 e0 06             	and    $0x6,%eax
  101490:	85 c0                	test   %eax,%eax
  101492:	75 2a                	jne    1014be <kbd_proc_data+0x17b>
  101494:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10149b:	75 21                	jne    1014be <kbd_proc_data+0x17b>
        cprintf("Rebooting!\n");
  10149d:	83 ec 0c             	sub    $0xc,%esp
  1014a0:	68 e3 34 10 00       	push   $0x1034e3
  1014a5:	e8 4c ee ff ff       	call   1002f6 <cprintf>
  1014aa:	83 c4 10             	add    $0x10,%esp
  1014ad:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1014b3:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1014b7:	8a 45 e7             	mov    -0x19(%ebp),%al
  1014ba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1014bd:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1014be:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1014c1:	c9                   	leave  
  1014c2:	c3                   	ret    

001014c3 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1014c3:	55                   	push   %ebp
  1014c4:	89 e5                	mov    %esp,%ebp
  1014c6:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
  1014c9:	83 ec 0c             	sub    $0xc,%esp
  1014cc:	68 43 13 10 00       	push   $0x101343
  1014d1:	e8 aa fd ff ff       	call   101280 <cons_intr>
  1014d6:	83 c4 10             	add    $0x10,%esp
}
  1014d9:	90                   	nop
  1014da:	c9                   	leave  
  1014db:	c3                   	ret    

001014dc <kbd_init>:

static void
kbd_init(void) {
  1014dc:	55                   	push   %ebp
  1014dd:	89 e5                	mov    %esp,%ebp
  1014df:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
  1014e2:	e8 dc ff ff ff       	call   1014c3 <kbd_intr>
    pic_enable(IRQ_KBD);
  1014e7:	83 ec 0c             	sub    $0xc,%esp
  1014ea:	6a 01                	push   $0x1
  1014ec:	e8 24 01 00 00       	call   101615 <pic_enable>
  1014f1:	83 c4 10             	add    $0x10,%esp
}
  1014f4:	90                   	nop
  1014f5:	c9                   	leave  
  1014f6:	c3                   	ret    

001014f7 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1014f7:	55                   	push   %ebp
  1014f8:	89 e5                	mov    %esp,%ebp
  1014fa:	83 ec 08             	sub    $0x8,%esp
    cga_init();
  1014fd:	e8 de f8 ff ff       	call   100de0 <cga_init>
    serial_init();
  101502:	e8 b4 f9 ff ff       	call   100ebb <serial_init>
    kbd_init();
  101507:	e8 d0 ff ff ff       	call   1014dc <kbd_init>
    if (!serial_exists) {
  10150c:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  101511:	85 c0                	test   %eax,%eax
  101513:	75 10                	jne    101525 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  101515:	83 ec 0c             	sub    $0xc,%esp
  101518:	68 ef 34 10 00       	push   $0x1034ef
  10151d:	e8 d4 ed ff ff       	call   1002f6 <cprintf>
  101522:	83 c4 10             	add    $0x10,%esp
    }
}
  101525:	90                   	nop
  101526:	c9                   	leave  
  101527:	c3                   	ret    

00101528 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101528:	55                   	push   %ebp
  101529:	89 e5                	mov    %esp,%ebp
  10152b:	83 ec 08             	sub    $0x8,%esp
    lpt_putc(c);
  10152e:	ff 75 08             	pushl  0x8(%ebp)
  101531:	e8 d7 fa ff ff       	call   10100d <lpt_putc>
  101536:	83 c4 04             	add    $0x4,%esp
    cga_putc(c);
  101539:	83 ec 0c             	sub    $0xc,%esp
  10153c:	ff 75 08             	pushl  0x8(%ebp)
  10153f:	e8 00 fb ff ff       	call   101044 <cga_putc>
  101544:	83 c4 10             	add    $0x10,%esp
    serial_putc(c);
  101547:	83 ec 0c             	sub    $0xc,%esp
  10154a:	ff 75 08             	pushl  0x8(%ebp)
  10154d:	e8 f7 fc ff ff       	call   101249 <serial_putc>
  101552:	83 c4 10             	add    $0x10,%esp
}
  101555:	90                   	nop
  101556:	c9                   	leave  
  101557:	c3                   	ret    

00101558 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101558:	55                   	push   %ebp
  101559:	89 e5                	mov    %esp,%ebp
  10155b:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  10155e:	e8 be fd ff ff       	call   101321 <serial_intr>
    kbd_intr();
  101563:	e8 5b ff ff ff       	call   1014c3 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  101568:	8b 15 80 00 11 00    	mov    0x110080,%edx
  10156e:	a1 84 00 11 00       	mov    0x110084,%eax
  101573:	39 c2                	cmp    %eax,%edx
  101575:	74 35                	je     1015ac <cons_getc+0x54>
        c = cons.buf[cons.rpos ++];
  101577:	a1 80 00 11 00       	mov    0x110080,%eax
  10157c:	8d 50 01             	lea    0x1(%eax),%edx
  10157f:	89 15 80 00 11 00    	mov    %edx,0x110080
  101585:	8a 80 80 fe 10 00    	mov    0x10fe80(%eax),%al
  10158b:	0f b6 c0             	movzbl %al,%eax
  10158e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  101591:	a1 80 00 11 00       	mov    0x110080,%eax
  101596:	3d 00 02 00 00       	cmp    $0x200,%eax
  10159b:	75 0a                	jne    1015a7 <cons_getc+0x4f>
            cons.rpos = 0;
  10159d:	c7 05 80 00 11 00 00 	movl   $0x0,0x110080
  1015a4:	00 00 00 
        }
        return c;
  1015a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1015aa:	eb 05                	jmp    1015b1 <cons_getc+0x59>
    }
    return 0;
  1015ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1015b1:	c9                   	leave  
  1015b2:	c3                   	ret    

001015b3 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1015b3:	55                   	push   %ebp
  1015b4:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1015b6:	fb                   	sti    
    sti();
}
  1015b7:	90                   	nop
  1015b8:	5d                   	pop    %ebp
  1015b9:	c3                   	ret    

001015ba <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1015ba:	55                   	push   %ebp
  1015bb:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  1015bd:	fa                   	cli    
    cli();
}
  1015be:	90                   	nop
  1015bf:	5d                   	pop    %ebp
  1015c0:	c3                   	ret    

001015c1 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1015c1:	55                   	push   %ebp
  1015c2:	89 e5                	mov    %esp,%ebp
  1015c4:	83 ec 14             	sub    $0x14,%esp
  1015c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1015ca:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1015ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1015d1:	66 a3 50 f5 10 00    	mov    %ax,0x10f550
    if (did_init) {
  1015d7:	a1 8c 00 11 00       	mov    0x11008c,%eax
  1015dc:	85 c0                	test   %eax,%eax
  1015de:	74 32                	je     101612 <pic_setmask+0x51>
        outb(IO_PIC1 + 1, mask);
  1015e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1015e3:	0f b6 c0             	movzbl %al,%eax
  1015e6:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  1015ec:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1015ef:	8a 45 f9             	mov    -0x7(%ebp),%al
  1015f2:	66 8b 55 fa          	mov    -0x6(%ebp),%dx
  1015f6:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1015f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1015fa:	66 c1 e8 08          	shr    $0x8,%ax
  1015fe:	0f b6 c0             	movzbl %al,%eax
  101601:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101607:	88 45 fd             	mov    %al,-0x3(%ebp)
  10160a:	8a 45 fd             	mov    -0x3(%ebp),%al
  10160d:	66 8b 55 fe          	mov    -0x2(%ebp),%dx
  101611:	ee                   	out    %al,(%dx)
    }
}
  101612:	90                   	nop
  101613:	c9                   	leave  
  101614:	c3                   	ret    

00101615 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101615:	55                   	push   %ebp
  101616:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  101618:	8b 45 08             	mov    0x8(%ebp),%eax
  10161b:	ba 01 00 00 00       	mov    $0x1,%edx
  101620:	88 c1                	mov    %al,%cl
  101622:	d3 e2                	shl    %cl,%edx
  101624:	89 d0                	mov    %edx,%eax
  101626:	f7 d0                	not    %eax
  101628:	89 c2                	mov    %eax,%edx
  10162a:	66 a1 50 f5 10 00    	mov    0x10f550,%ax
  101630:	21 d0                	and    %edx,%eax
  101632:	0f b7 c0             	movzwl %ax,%eax
  101635:	50                   	push   %eax
  101636:	e8 86 ff ff ff       	call   1015c1 <pic_setmask>
  10163b:	83 c4 04             	add    $0x4,%esp
}
  10163e:	90                   	nop
  10163f:	c9                   	leave  
  101640:	c3                   	ret    

00101641 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101641:	55                   	push   %ebp
  101642:	89 e5                	mov    %esp,%ebp
  101644:	83 ec 40             	sub    $0x40,%esp
    did_init = 1;
  101647:	c7 05 8c 00 11 00 01 	movl   $0x1,0x11008c
  10164e:	00 00 00 
  101651:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  101657:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
  10165b:	8a 45 c9             	mov    -0x37(%ebp),%al
  10165e:	66 8b 55 ca          	mov    -0x36(%ebp),%dx
  101662:	ee                   	out    %al,(%dx)
  101663:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  101669:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
  10166d:	8a 45 cd             	mov    -0x33(%ebp),%al
  101670:	66 8b 55 ce          	mov    -0x32(%ebp),%dx
  101674:	ee                   	out    %al,(%dx)
  101675:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10167b:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
  10167f:	8a 45 d1             	mov    -0x2f(%ebp),%al
  101682:	66 8b 55 d2          	mov    -0x2e(%ebp),%dx
  101686:	ee                   	out    %al,(%dx)
  101687:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  10168d:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
  101691:	8a 45 d5             	mov    -0x2b(%ebp),%al
  101694:	66 8b 55 d6          	mov    -0x2a(%ebp),%dx
  101698:	ee                   	out    %al,(%dx)
  101699:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  10169f:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
  1016a3:	8a 45 d9             	mov    -0x27(%ebp),%al
  1016a6:	66 8b 55 da          	mov    -0x26(%ebp),%dx
  1016aa:	ee                   	out    %al,(%dx)
  1016ab:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  1016b1:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
  1016b5:	8a 45 dd             	mov    -0x23(%ebp),%al
  1016b8:	66 8b 55 de          	mov    -0x22(%ebp),%dx
  1016bc:	ee                   	out    %al,(%dx)
  1016bd:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  1016c3:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
  1016c7:	8a 45 e1             	mov    -0x1f(%ebp),%al
  1016ca:	66 8b 55 e2          	mov    -0x1e(%ebp),%dx
  1016ce:	ee                   	out    %al,(%dx)
  1016cf:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  1016d5:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
  1016d9:	8a 45 e5             	mov    -0x1b(%ebp),%al
  1016dc:	66 8b 55 e6          	mov    -0x1a(%ebp),%dx
  1016e0:	ee                   	out    %al,(%dx)
  1016e1:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  1016e7:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
  1016eb:	8a 45 e9             	mov    -0x17(%ebp),%al
  1016ee:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
  1016f2:	ee                   	out    %al,(%dx)
  1016f3:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  1016f9:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
  1016fd:	8a 45 ed             	mov    -0x13(%ebp),%al
  101700:	66 8b 55 ee          	mov    -0x12(%ebp),%dx
  101704:	ee                   	out    %al,(%dx)
  101705:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  10170b:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
  10170f:	8a 45 f1             	mov    -0xf(%ebp),%al
  101712:	66 8b 55 f2          	mov    -0xe(%ebp),%dx
  101716:	ee                   	out    %al,(%dx)
  101717:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  10171d:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
  101721:	8a 45 f5             	mov    -0xb(%ebp),%al
  101724:	66 8b 55 f6          	mov    -0xa(%ebp),%dx
  101728:	ee                   	out    %al,(%dx)
  101729:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  10172f:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
  101733:	8a 45 f9             	mov    -0x7(%ebp),%al
  101736:	66 8b 55 fa          	mov    -0x6(%ebp),%dx
  10173a:	ee                   	out    %al,(%dx)
  10173b:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  101741:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
  101745:	8a 45 fd             	mov    -0x3(%ebp),%al
  101748:	66 8b 55 fe          	mov    -0x2(%ebp),%dx
  10174c:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  10174d:	66 a1 50 f5 10 00    	mov    0x10f550,%ax
  101753:	66 83 f8 ff          	cmp    $0xffff,%ax
  101757:	74 12                	je     10176b <pic_init+0x12a>
        pic_setmask(irq_mask);
  101759:	66 a1 50 f5 10 00    	mov    0x10f550,%ax
  10175f:	0f b7 c0             	movzwl %ax,%eax
  101762:	50                   	push   %eax
  101763:	e8 59 fe ff ff       	call   1015c1 <pic_setmask>
  101768:	83 c4 04             	add    $0x4,%esp
    }
}
  10176b:	90                   	nop
  10176c:	c9                   	leave  
  10176d:	c3                   	ret    

0010176e <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  10176e:	55                   	push   %ebp
  10176f:	89 e5                	mov    %esp,%ebp
  101771:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101774:	83 ec 08             	sub    $0x8,%esp
  101777:	6a 64                	push   $0x64
  101779:	68 20 35 10 00       	push   $0x103520
  10177e:	e8 73 eb ff ff       	call   1002f6 <cprintf>
  101783:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  101786:	90                   	nop
  101787:	c9                   	leave  
  101788:	c3                   	ret    

00101789 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101789:	55                   	push   %ebp
  10178a:	89 e5                	mov    %esp,%ebp
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
  10178c:	90                   	nop
  10178d:	5d                   	pop    %ebp
  10178e:	c3                   	ret    

0010178f <trapname>:

static const char *
trapname(int trapno) {
  10178f:	55                   	push   %ebp
  101790:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101792:	8b 45 08             	mov    0x8(%ebp),%eax
  101795:	83 f8 13             	cmp    $0x13,%eax
  101798:	77 0c                	ja     1017a6 <trapname+0x17>
        return excnames[trapno];
  10179a:	8b 45 08             	mov    0x8(%ebp),%eax
  10179d:	8b 04 85 80 38 10 00 	mov    0x103880(,%eax,4),%eax
  1017a4:	eb 18                	jmp    1017be <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1017a6:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1017aa:	7e 0d                	jle    1017b9 <trapname+0x2a>
  1017ac:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1017b0:	7f 07                	jg     1017b9 <trapname+0x2a>
        return "Hardware Interrupt";
  1017b2:	b8 2a 35 10 00       	mov    $0x10352a,%eax
  1017b7:	eb 05                	jmp    1017be <trapname+0x2f>
    }
    return "(unknown trap)";
  1017b9:	b8 3d 35 10 00       	mov    $0x10353d,%eax
}
  1017be:	5d                   	pop    %ebp
  1017bf:	c3                   	ret    

001017c0 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1017c0:	55                   	push   %ebp
  1017c1:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1017c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1017c6:	66 8b 40 3c          	mov    0x3c(%eax),%ax
  1017ca:	66 83 f8 08          	cmp    $0x8,%ax
  1017ce:	0f 94 c0             	sete   %al
  1017d1:	0f b6 c0             	movzbl %al,%eax
}
  1017d4:	5d                   	pop    %ebp
  1017d5:	c3                   	ret    

001017d6 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1017d6:	55                   	push   %ebp
  1017d7:	89 e5                	mov    %esp,%ebp
  1017d9:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
  1017dc:	83 ec 08             	sub    $0x8,%esp
  1017df:	ff 75 08             	pushl  0x8(%ebp)
  1017e2:	68 7e 35 10 00       	push   $0x10357e
  1017e7:	e8 0a eb ff ff       	call   1002f6 <cprintf>
  1017ec:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  1017ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1017f2:	83 ec 0c             	sub    $0xc,%esp
  1017f5:	50                   	push   %eax
  1017f6:	e8 ba 01 00 00       	call   1019b5 <print_regs>
  1017fb:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  1017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  101801:	66 8b 40 2c          	mov    0x2c(%eax),%ax
  101805:	0f b7 c0             	movzwl %ax,%eax
  101808:	83 ec 08             	sub    $0x8,%esp
  10180b:	50                   	push   %eax
  10180c:	68 8f 35 10 00       	push   $0x10358f
  101811:	e8 e0 ea ff ff       	call   1002f6 <cprintf>
  101816:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101819:	8b 45 08             	mov    0x8(%ebp),%eax
  10181c:	66 8b 40 28          	mov    0x28(%eax),%ax
  101820:	0f b7 c0             	movzwl %ax,%eax
  101823:	83 ec 08             	sub    $0x8,%esp
  101826:	50                   	push   %eax
  101827:	68 a2 35 10 00       	push   $0x1035a2
  10182c:	e8 c5 ea ff ff       	call   1002f6 <cprintf>
  101831:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101834:	8b 45 08             	mov    0x8(%ebp),%eax
  101837:	66 8b 40 24          	mov    0x24(%eax),%ax
  10183b:	0f b7 c0             	movzwl %ax,%eax
  10183e:	83 ec 08             	sub    $0x8,%esp
  101841:	50                   	push   %eax
  101842:	68 b5 35 10 00       	push   $0x1035b5
  101847:	e8 aa ea ff ff       	call   1002f6 <cprintf>
  10184c:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  10184f:	8b 45 08             	mov    0x8(%ebp),%eax
  101852:	66 8b 40 20          	mov    0x20(%eax),%ax
  101856:	0f b7 c0             	movzwl %ax,%eax
  101859:	83 ec 08             	sub    $0x8,%esp
  10185c:	50                   	push   %eax
  10185d:	68 c8 35 10 00       	push   $0x1035c8
  101862:	e8 8f ea ff ff       	call   1002f6 <cprintf>
  101867:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  10186a:	8b 45 08             	mov    0x8(%ebp),%eax
  10186d:	8b 40 30             	mov    0x30(%eax),%eax
  101870:	83 ec 0c             	sub    $0xc,%esp
  101873:	50                   	push   %eax
  101874:	e8 16 ff ff ff       	call   10178f <trapname>
  101879:	83 c4 10             	add    $0x10,%esp
  10187c:	89 c2                	mov    %eax,%edx
  10187e:	8b 45 08             	mov    0x8(%ebp),%eax
  101881:	8b 40 30             	mov    0x30(%eax),%eax
  101884:	83 ec 04             	sub    $0x4,%esp
  101887:	52                   	push   %edx
  101888:	50                   	push   %eax
  101889:	68 db 35 10 00       	push   $0x1035db
  10188e:	e8 63 ea ff ff       	call   1002f6 <cprintf>
  101893:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  101896:	8b 45 08             	mov    0x8(%ebp),%eax
  101899:	8b 40 34             	mov    0x34(%eax),%eax
  10189c:	83 ec 08             	sub    $0x8,%esp
  10189f:	50                   	push   %eax
  1018a0:	68 ed 35 10 00       	push   $0x1035ed
  1018a5:	e8 4c ea ff ff       	call   1002f6 <cprintf>
  1018aa:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  1018ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1018b0:	8b 40 38             	mov    0x38(%eax),%eax
  1018b3:	83 ec 08             	sub    $0x8,%esp
  1018b6:	50                   	push   %eax
  1018b7:	68 fc 35 10 00       	push   $0x1035fc
  1018bc:	e8 35 ea ff ff       	call   1002f6 <cprintf>
  1018c1:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  1018c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1018c7:	66 8b 40 3c          	mov    0x3c(%eax),%ax
  1018cb:	0f b7 c0             	movzwl %ax,%eax
  1018ce:	83 ec 08             	sub    $0x8,%esp
  1018d1:	50                   	push   %eax
  1018d2:	68 0b 36 10 00       	push   $0x10360b
  1018d7:	e8 1a ea ff ff       	call   1002f6 <cprintf>
  1018dc:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  1018df:	8b 45 08             	mov    0x8(%ebp),%eax
  1018e2:	8b 40 40             	mov    0x40(%eax),%eax
  1018e5:	83 ec 08             	sub    $0x8,%esp
  1018e8:	50                   	push   %eax
  1018e9:	68 1e 36 10 00       	push   $0x10361e
  1018ee:	e8 03 ea ff ff       	call   1002f6 <cprintf>
  1018f3:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  1018f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1018fd:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101904:	eb 43                	jmp    101949 <print_trapframe+0x173>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101906:	8b 45 08             	mov    0x8(%ebp),%eax
  101909:	8b 50 40             	mov    0x40(%eax),%edx
  10190c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10190f:	21 d0                	and    %edx,%eax
  101911:	85 c0                	test   %eax,%eax
  101913:	74 29                	je     10193e <print_trapframe+0x168>
  101915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101918:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  10191f:	85 c0                	test   %eax,%eax
  101921:	74 1b                	je     10193e <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
  101923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101926:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  10192d:	83 ec 08             	sub    $0x8,%esp
  101930:	50                   	push   %eax
  101931:	68 2d 36 10 00       	push   $0x10362d
  101936:	e8 bb e9 ff ff       	call   1002f6 <cprintf>
  10193b:	83 c4 10             	add    $0x10,%esp
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  10193e:	ff 45 f4             	incl   -0xc(%ebp)
  101941:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101944:	01 c0                	add    %eax,%eax
  101946:	89 45 f0             	mov    %eax,-0x10(%ebp)
  101949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10194c:	83 f8 17             	cmp    $0x17,%eax
  10194f:	76 b5                	jbe    101906 <print_trapframe+0x130>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101951:	8b 45 08             	mov    0x8(%ebp),%eax
  101954:	8b 40 40             	mov    0x40(%eax),%eax
  101957:	c1 e8 0c             	shr    $0xc,%eax
  10195a:	83 e0 03             	and    $0x3,%eax
  10195d:	83 ec 08             	sub    $0x8,%esp
  101960:	50                   	push   %eax
  101961:	68 31 36 10 00       	push   $0x103631
  101966:	e8 8b e9 ff ff       	call   1002f6 <cprintf>
  10196b:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  10196e:	83 ec 0c             	sub    $0xc,%esp
  101971:	ff 75 08             	pushl  0x8(%ebp)
  101974:	e8 47 fe ff ff       	call   1017c0 <trap_in_kernel>
  101979:	83 c4 10             	add    $0x10,%esp
  10197c:	85 c0                	test   %eax,%eax
  10197e:	75 32                	jne    1019b2 <print_trapframe+0x1dc>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101980:	8b 45 08             	mov    0x8(%ebp),%eax
  101983:	8b 40 44             	mov    0x44(%eax),%eax
  101986:	83 ec 08             	sub    $0x8,%esp
  101989:	50                   	push   %eax
  10198a:	68 3a 36 10 00       	push   $0x10363a
  10198f:	e8 62 e9 ff ff       	call   1002f6 <cprintf>
  101994:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101997:	8b 45 08             	mov    0x8(%ebp),%eax
  10199a:	66 8b 40 48          	mov    0x48(%eax),%ax
  10199e:	0f b7 c0             	movzwl %ax,%eax
  1019a1:	83 ec 08             	sub    $0x8,%esp
  1019a4:	50                   	push   %eax
  1019a5:	68 49 36 10 00       	push   $0x103649
  1019aa:	e8 47 e9 ff ff       	call   1002f6 <cprintf>
  1019af:	83 c4 10             	add    $0x10,%esp
    }
}
  1019b2:	90                   	nop
  1019b3:	c9                   	leave  
  1019b4:	c3                   	ret    

001019b5 <print_regs>:

void
print_regs(struct pushregs *regs) {
  1019b5:	55                   	push   %ebp
  1019b6:	89 e5                	mov    %esp,%ebp
  1019b8:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  1019bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1019be:	8b 00                	mov    (%eax),%eax
  1019c0:	83 ec 08             	sub    $0x8,%esp
  1019c3:	50                   	push   %eax
  1019c4:	68 5c 36 10 00       	push   $0x10365c
  1019c9:	e8 28 e9 ff ff       	call   1002f6 <cprintf>
  1019ce:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  1019d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1019d4:	8b 40 04             	mov    0x4(%eax),%eax
  1019d7:	83 ec 08             	sub    $0x8,%esp
  1019da:	50                   	push   %eax
  1019db:	68 6b 36 10 00       	push   $0x10366b
  1019e0:	e8 11 e9 ff ff       	call   1002f6 <cprintf>
  1019e5:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  1019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1019eb:	8b 40 08             	mov    0x8(%eax),%eax
  1019ee:	83 ec 08             	sub    $0x8,%esp
  1019f1:	50                   	push   %eax
  1019f2:	68 7a 36 10 00       	push   $0x10367a
  1019f7:	e8 fa e8 ff ff       	call   1002f6 <cprintf>
  1019fc:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  1019ff:	8b 45 08             	mov    0x8(%ebp),%eax
  101a02:	8b 40 0c             	mov    0xc(%eax),%eax
  101a05:	83 ec 08             	sub    $0x8,%esp
  101a08:	50                   	push   %eax
  101a09:	68 89 36 10 00       	push   $0x103689
  101a0e:	e8 e3 e8 ff ff       	call   1002f6 <cprintf>
  101a13:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101a16:	8b 45 08             	mov    0x8(%ebp),%eax
  101a19:	8b 40 10             	mov    0x10(%eax),%eax
  101a1c:	83 ec 08             	sub    $0x8,%esp
  101a1f:	50                   	push   %eax
  101a20:	68 98 36 10 00       	push   $0x103698
  101a25:	e8 cc e8 ff ff       	call   1002f6 <cprintf>
  101a2a:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a30:	8b 40 14             	mov    0x14(%eax),%eax
  101a33:	83 ec 08             	sub    $0x8,%esp
  101a36:	50                   	push   %eax
  101a37:	68 a7 36 10 00       	push   $0x1036a7
  101a3c:	e8 b5 e8 ff ff       	call   1002f6 <cprintf>
  101a41:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101a44:	8b 45 08             	mov    0x8(%ebp),%eax
  101a47:	8b 40 18             	mov    0x18(%eax),%eax
  101a4a:	83 ec 08             	sub    $0x8,%esp
  101a4d:	50                   	push   %eax
  101a4e:	68 b6 36 10 00       	push   $0x1036b6
  101a53:	e8 9e e8 ff ff       	call   1002f6 <cprintf>
  101a58:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a5e:	8b 40 1c             	mov    0x1c(%eax),%eax
  101a61:	83 ec 08             	sub    $0x8,%esp
  101a64:	50                   	push   %eax
  101a65:	68 c5 36 10 00       	push   $0x1036c5
  101a6a:	e8 87 e8 ff ff       	call   1002f6 <cprintf>
  101a6f:	83 c4 10             	add    $0x10,%esp
}
  101a72:	90                   	nop
  101a73:	c9                   	leave  
  101a74:	c3                   	ret    

00101a75 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101a75:	55                   	push   %ebp
  101a76:	89 e5                	mov    %esp,%ebp
  101a78:	83 ec 18             	sub    $0x18,%esp
    char c;

    switch (tf->tf_trapno) {
  101a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a7e:	8b 40 30             	mov    0x30(%eax),%eax
  101a81:	83 f8 2f             	cmp    $0x2f,%eax
  101a84:	77 1e                	ja     101aa4 <trap_dispatch+0x2f>
  101a86:	83 f8 2e             	cmp    $0x2e,%eax
  101a89:	0f 83 b4 00 00 00    	jae    101b43 <trap_dispatch+0xce>
  101a8f:	83 f8 21             	cmp    $0x21,%eax
  101a92:	74 3e                	je     101ad2 <trap_dispatch+0x5d>
  101a94:	83 f8 24             	cmp    $0x24,%eax
  101a97:	74 15                	je     101aae <trap_dispatch+0x39>
  101a99:	83 f8 20             	cmp    $0x20,%eax
  101a9c:	0f 84 a4 00 00 00    	je     101b46 <trap_dispatch+0xd1>
  101aa2:	eb 69                	jmp    101b0d <trap_dispatch+0x98>
  101aa4:	83 e8 78             	sub    $0x78,%eax
  101aa7:	83 f8 01             	cmp    $0x1,%eax
  101aaa:	77 61                	ja     101b0d <trap_dispatch+0x98>
  101aac:	eb 48                	jmp    101af6 <trap_dispatch+0x81>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101aae:	e8 a5 fa ff ff       	call   101558 <cons_getc>
  101ab3:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101ab6:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101aba:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101abe:	83 ec 04             	sub    $0x4,%esp
  101ac1:	52                   	push   %edx
  101ac2:	50                   	push   %eax
  101ac3:	68 d4 36 10 00       	push   $0x1036d4
  101ac8:	e8 29 e8 ff ff       	call   1002f6 <cprintf>
  101acd:	83 c4 10             	add    $0x10,%esp
        break;
  101ad0:	eb 75                	jmp    101b47 <trap_dispatch+0xd2>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101ad2:	e8 81 fa ff ff       	call   101558 <cons_getc>
  101ad7:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101ada:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101ade:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101ae2:	83 ec 04             	sub    $0x4,%esp
  101ae5:	52                   	push   %edx
  101ae6:	50                   	push   %eax
  101ae7:	68 e6 36 10 00       	push   $0x1036e6
  101aec:	e8 05 e8 ff ff       	call   1002f6 <cprintf>
  101af1:	83 c4 10             	add    $0x10,%esp
        break;
  101af4:	eb 51                	jmp    101b47 <trap_dispatch+0xd2>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101af6:	83 ec 04             	sub    $0x4,%esp
  101af9:	68 f5 36 10 00       	push   $0x1036f5
  101afe:	68 a2 00 00 00       	push   $0xa2
  101b03:	68 05 37 10 00       	push   $0x103705
  101b08:	e8 50 f1 ff ff       	call   100c5d <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b10:	66 8b 40 3c          	mov    0x3c(%eax),%ax
  101b14:	0f b7 c0             	movzwl %ax,%eax
  101b17:	83 e0 03             	and    $0x3,%eax
  101b1a:	85 c0                	test   %eax,%eax
  101b1c:	75 29                	jne    101b47 <trap_dispatch+0xd2>
            print_trapframe(tf);
  101b1e:	83 ec 0c             	sub    $0xc,%esp
  101b21:	ff 75 08             	pushl  0x8(%ebp)
  101b24:	e8 ad fc ff ff       	call   1017d6 <print_trapframe>
  101b29:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101b2c:	83 ec 04             	sub    $0x4,%esp
  101b2f:	68 16 37 10 00       	push   $0x103716
  101b34:	68 ac 00 00 00       	push   $0xac
  101b39:	68 05 37 10 00       	push   $0x103705
  101b3e:	e8 1a f1 ff ff       	call   100c5d <__panic>
        break;
  101b43:	90                   	nop
  101b44:	eb 01                	jmp    101b47 <trap_dispatch+0xd2>
        break;
  101b46:	90                   	nop
        }
    }
}
  101b47:	90                   	nop
  101b48:	c9                   	leave  
  101b49:	c3                   	ret    

00101b4a <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101b4a:	55                   	push   %ebp
  101b4b:	89 e5                	mov    %esp,%ebp
  101b4d:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101b50:	83 ec 0c             	sub    $0xc,%esp
  101b53:	ff 75 08             	pushl  0x8(%ebp)
  101b56:	e8 1a ff ff ff       	call   101a75 <trap_dispatch>
  101b5b:	83 c4 10             	add    $0x10,%esp
}
  101b5e:	90                   	nop
  101b5f:	c9                   	leave  
  101b60:	c3                   	ret    

00101b61 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101b61:	1e                   	push   %ds
    pushl %es
  101b62:	06                   	push   %es
    pushl %fs
  101b63:	0f a0                	push   %fs
    pushl %gs
  101b65:	0f a8                	push   %gs
    pushal
  101b67:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101b68:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101b6d:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101b6f:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101b71:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101b72:	e8 d3 ff ff ff       	call   101b4a <trap>

    # pop the pushed stack pointer
    popl %esp
  101b77:	5c                   	pop    %esp

00101b78 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101b78:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101b79:	0f a9                	pop    %gs
    popl %fs
  101b7b:	0f a1                	pop    %fs
    popl %es
  101b7d:	07                   	pop    %es
    popl %ds
  101b7e:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101b7f:	83 c4 08             	add    $0x8,%esp
    iret
  101b82:	cf                   	iret   

00101b83 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101b83:	6a 00                	push   $0x0
  pushl $0
  101b85:	6a 00                	push   $0x0
  jmp __alltraps
  101b87:	e9 d5 ff ff ff       	jmp    101b61 <__alltraps>

00101b8c <vector1>:
.globl vector1
vector1:
  pushl $0
  101b8c:	6a 00                	push   $0x0
  pushl $1
  101b8e:	6a 01                	push   $0x1
  jmp __alltraps
  101b90:	e9 cc ff ff ff       	jmp    101b61 <__alltraps>

00101b95 <vector2>:
.globl vector2
vector2:
  pushl $0
  101b95:	6a 00                	push   $0x0
  pushl $2
  101b97:	6a 02                	push   $0x2
  jmp __alltraps
  101b99:	e9 c3 ff ff ff       	jmp    101b61 <__alltraps>

00101b9e <vector3>:
.globl vector3
vector3:
  pushl $0
  101b9e:	6a 00                	push   $0x0
  pushl $3
  101ba0:	6a 03                	push   $0x3
  jmp __alltraps
  101ba2:	e9 ba ff ff ff       	jmp    101b61 <__alltraps>

00101ba7 <vector4>:
.globl vector4
vector4:
  pushl $0
  101ba7:	6a 00                	push   $0x0
  pushl $4
  101ba9:	6a 04                	push   $0x4
  jmp __alltraps
  101bab:	e9 b1 ff ff ff       	jmp    101b61 <__alltraps>

00101bb0 <vector5>:
.globl vector5
vector5:
  pushl $0
  101bb0:	6a 00                	push   $0x0
  pushl $5
  101bb2:	6a 05                	push   $0x5
  jmp __alltraps
  101bb4:	e9 a8 ff ff ff       	jmp    101b61 <__alltraps>

00101bb9 <vector6>:
.globl vector6
vector6:
  pushl $0
  101bb9:	6a 00                	push   $0x0
  pushl $6
  101bbb:	6a 06                	push   $0x6
  jmp __alltraps
  101bbd:	e9 9f ff ff ff       	jmp    101b61 <__alltraps>

00101bc2 <vector7>:
.globl vector7
vector7:
  pushl $0
  101bc2:	6a 00                	push   $0x0
  pushl $7
  101bc4:	6a 07                	push   $0x7
  jmp __alltraps
  101bc6:	e9 96 ff ff ff       	jmp    101b61 <__alltraps>

00101bcb <vector8>:
.globl vector8
vector8:
  pushl $8
  101bcb:	6a 08                	push   $0x8
  jmp __alltraps
  101bcd:	e9 8f ff ff ff       	jmp    101b61 <__alltraps>

00101bd2 <vector9>:
.globl vector9
vector9:
  pushl $0
  101bd2:	6a 00                	push   $0x0
  pushl $9
  101bd4:	6a 09                	push   $0x9
  jmp __alltraps
  101bd6:	e9 86 ff ff ff       	jmp    101b61 <__alltraps>

00101bdb <vector10>:
.globl vector10
vector10:
  pushl $10
  101bdb:	6a 0a                	push   $0xa
  jmp __alltraps
  101bdd:	e9 7f ff ff ff       	jmp    101b61 <__alltraps>

00101be2 <vector11>:
.globl vector11
vector11:
  pushl $11
  101be2:	6a 0b                	push   $0xb
  jmp __alltraps
  101be4:	e9 78 ff ff ff       	jmp    101b61 <__alltraps>

00101be9 <vector12>:
.globl vector12
vector12:
  pushl $12
  101be9:	6a 0c                	push   $0xc
  jmp __alltraps
  101beb:	e9 71 ff ff ff       	jmp    101b61 <__alltraps>

00101bf0 <vector13>:
.globl vector13
vector13:
  pushl $13
  101bf0:	6a 0d                	push   $0xd
  jmp __alltraps
  101bf2:	e9 6a ff ff ff       	jmp    101b61 <__alltraps>

00101bf7 <vector14>:
.globl vector14
vector14:
  pushl $14
  101bf7:	6a 0e                	push   $0xe
  jmp __alltraps
  101bf9:	e9 63 ff ff ff       	jmp    101b61 <__alltraps>

00101bfe <vector15>:
.globl vector15
vector15:
  pushl $0
  101bfe:	6a 00                	push   $0x0
  pushl $15
  101c00:	6a 0f                	push   $0xf
  jmp __alltraps
  101c02:	e9 5a ff ff ff       	jmp    101b61 <__alltraps>

00101c07 <vector16>:
.globl vector16
vector16:
  pushl $0
  101c07:	6a 00                	push   $0x0
  pushl $16
  101c09:	6a 10                	push   $0x10
  jmp __alltraps
  101c0b:	e9 51 ff ff ff       	jmp    101b61 <__alltraps>

00101c10 <vector17>:
.globl vector17
vector17:
  pushl $17
  101c10:	6a 11                	push   $0x11
  jmp __alltraps
  101c12:	e9 4a ff ff ff       	jmp    101b61 <__alltraps>

00101c17 <vector18>:
.globl vector18
vector18:
  pushl $0
  101c17:	6a 00                	push   $0x0
  pushl $18
  101c19:	6a 12                	push   $0x12
  jmp __alltraps
  101c1b:	e9 41 ff ff ff       	jmp    101b61 <__alltraps>

00101c20 <vector19>:
.globl vector19
vector19:
  pushl $0
  101c20:	6a 00                	push   $0x0
  pushl $19
  101c22:	6a 13                	push   $0x13
  jmp __alltraps
  101c24:	e9 38 ff ff ff       	jmp    101b61 <__alltraps>

00101c29 <vector20>:
.globl vector20
vector20:
  pushl $0
  101c29:	6a 00                	push   $0x0
  pushl $20
  101c2b:	6a 14                	push   $0x14
  jmp __alltraps
  101c2d:	e9 2f ff ff ff       	jmp    101b61 <__alltraps>

00101c32 <vector21>:
.globl vector21
vector21:
  pushl $0
  101c32:	6a 00                	push   $0x0
  pushl $21
  101c34:	6a 15                	push   $0x15
  jmp __alltraps
  101c36:	e9 26 ff ff ff       	jmp    101b61 <__alltraps>

00101c3b <vector22>:
.globl vector22
vector22:
  pushl $0
  101c3b:	6a 00                	push   $0x0
  pushl $22
  101c3d:	6a 16                	push   $0x16
  jmp __alltraps
  101c3f:	e9 1d ff ff ff       	jmp    101b61 <__alltraps>

00101c44 <vector23>:
.globl vector23
vector23:
  pushl $0
  101c44:	6a 00                	push   $0x0
  pushl $23
  101c46:	6a 17                	push   $0x17
  jmp __alltraps
  101c48:	e9 14 ff ff ff       	jmp    101b61 <__alltraps>

00101c4d <vector24>:
.globl vector24
vector24:
  pushl $0
  101c4d:	6a 00                	push   $0x0
  pushl $24
  101c4f:	6a 18                	push   $0x18
  jmp __alltraps
  101c51:	e9 0b ff ff ff       	jmp    101b61 <__alltraps>

00101c56 <vector25>:
.globl vector25
vector25:
  pushl $0
  101c56:	6a 00                	push   $0x0
  pushl $25
  101c58:	6a 19                	push   $0x19
  jmp __alltraps
  101c5a:	e9 02 ff ff ff       	jmp    101b61 <__alltraps>

00101c5f <vector26>:
.globl vector26
vector26:
  pushl $0
  101c5f:	6a 00                	push   $0x0
  pushl $26
  101c61:	6a 1a                	push   $0x1a
  jmp __alltraps
  101c63:	e9 f9 fe ff ff       	jmp    101b61 <__alltraps>

00101c68 <vector27>:
.globl vector27
vector27:
  pushl $0
  101c68:	6a 00                	push   $0x0
  pushl $27
  101c6a:	6a 1b                	push   $0x1b
  jmp __alltraps
  101c6c:	e9 f0 fe ff ff       	jmp    101b61 <__alltraps>

00101c71 <vector28>:
.globl vector28
vector28:
  pushl $0
  101c71:	6a 00                	push   $0x0
  pushl $28
  101c73:	6a 1c                	push   $0x1c
  jmp __alltraps
  101c75:	e9 e7 fe ff ff       	jmp    101b61 <__alltraps>

00101c7a <vector29>:
.globl vector29
vector29:
  pushl $0
  101c7a:	6a 00                	push   $0x0
  pushl $29
  101c7c:	6a 1d                	push   $0x1d
  jmp __alltraps
  101c7e:	e9 de fe ff ff       	jmp    101b61 <__alltraps>

00101c83 <vector30>:
.globl vector30
vector30:
  pushl $0
  101c83:	6a 00                	push   $0x0
  pushl $30
  101c85:	6a 1e                	push   $0x1e
  jmp __alltraps
  101c87:	e9 d5 fe ff ff       	jmp    101b61 <__alltraps>

00101c8c <vector31>:
.globl vector31
vector31:
  pushl $0
  101c8c:	6a 00                	push   $0x0
  pushl $31
  101c8e:	6a 1f                	push   $0x1f
  jmp __alltraps
  101c90:	e9 cc fe ff ff       	jmp    101b61 <__alltraps>

00101c95 <vector32>:
.globl vector32
vector32:
  pushl $0
  101c95:	6a 00                	push   $0x0
  pushl $32
  101c97:	6a 20                	push   $0x20
  jmp __alltraps
  101c99:	e9 c3 fe ff ff       	jmp    101b61 <__alltraps>

00101c9e <vector33>:
.globl vector33
vector33:
  pushl $0
  101c9e:	6a 00                	push   $0x0
  pushl $33
  101ca0:	6a 21                	push   $0x21
  jmp __alltraps
  101ca2:	e9 ba fe ff ff       	jmp    101b61 <__alltraps>

00101ca7 <vector34>:
.globl vector34
vector34:
  pushl $0
  101ca7:	6a 00                	push   $0x0
  pushl $34
  101ca9:	6a 22                	push   $0x22
  jmp __alltraps
  101cab:	e9 b1 fe ff ff       	jmp    101b61 <__alltraps>

00101cb0 <vector35>:
.globl vector35
vector35:
  pushl $0
  101cb0:	6a 00                	push   $0x0
  pushl $35
  101cb2:	6a 23                	push   $0x23
  jmp __alltraps
  101cb4:	e9 a8 fe ff ff       	jmp    101b61 <__alltraps>

00101cb9 <vector36>:
.globl vector36
vector36:
  pushl $0
  101cb9:	6a 00                	push   $0x0
  pushl $36
  101cbb:	6a 24                	push   $0x24
  jmp __alltraps
  101cbd:	e9 9f fe ff ff       	jmp    101b61 <__alltraps>

00101cc2 <vector37>:
.globl vector37
vector37:
  pushl $0
  101cc2:	6a 00                	push   $0x0
  pushl $37
  101cc4:	6a 25                	push   $0x25
  jmp __alltraps
  101cc6:	e9 96 fe ff ff       	jmp    101b61 <__alltraps>

00101ccb <vector38>:
.globl vector38
vector38:
  pushl $0
  101ccb:	6a 00                	push   $0x0
  pushl $38
  101ccd:	6a 26                	push   $0x26
  jmp __alltraps
  101ccf:	e9 8d fe ff ff       	jmp    101b61 <__alltraps>

00101cd4 <vector39>:
.globl vector39
vector39:
  pushl $0
  101cd4:	6a 00                	push   $0x0
  pushl $39
  101cd6:	6a 27                	push   $0x27
  jmp __alltraps
  101cd8:	e9 84 fe ff ff       	jmp    101b61 <__alltraps>

00101cdd <vector40>:
.globl vector40
vector40:
  pushl $0
  101cdd:	6a 00                	push   $0x0
  pushl $40
  101cdf:	6a 28                	push   $0x28
  jmp __alltraps
  101ce1:	e9 7b fe ff ff       	jmp    101b61 <__alltraps>

00101ce6 <vector41>:
.globl vector41
vector41:
  pushl $0
  101ce6:	6a 00                	push   $0x0
  pushl $41
  101ce8:	6a 29                	push   $0x29
  jmp __alltraps
  101cea:	e9 72 fe ff ff       	jmp    101b61 <__alltraps>

00101cef <vector42>:
.globl vector42
vector42:
  pushl $0
  101cef:	6a 00                	push   $0x0
  pushl $42
  101cf1:	6a 2a                	push   $0x2a
  jmp __alltraps
  101cf3:	e9 69 fe ff ff       	jmp    101b61 <__alltraps>

00101cf8 <vector43>:
.globl vector43
vector43:
  pushl $0
  101cf8:	6a 00                	push   $0x0
  pushl $43
  101cfa:	6a 2b                	push   $0x2b
  jmp __alltraps
  101cfc:	e9 60 fe ff ff       	jmp    101b61 <__alltraps>

00101d01 <vector44>:
.globl vector44
vector44:
  pushl $0
  101d01:	6a 00                	push   $0x0
  pushl $44
  101d03:	6a 2c                	push   $0x2c
  jmp __alltraps
  101d05:	e9 57 fe ff ff       	jmp    101b61 <__alltraps>

00101d0a <vector45>:
.globl vector45
vector45:
  pushl $0
  101d0a:	6a 00                	push   $0x0
  pushl $45
  101d0c:	6a 2d                	push   $0x2d
  jmp __alltraps
  101d0e:	e9 4e fe ff ff       	jmp    101b61 <__alltraps>

00101d13 <vector46>:
.globl vector46
vector46:
  pushl $0
  101d13:	6a 00                	push   $0x0
  pushl $46
  101d15:	6a 2e                	push   $0x2e
  jmp __alltraps
  101d17:	e9 45 fe ff ff       	jmp    101b61 <__alltraps>

00101d1c <vector47>:
.globl vector47
vector47:
  pushl $0
  101d1c:	6a 00                	push   $0x0
  pushl $47
  101d1e:	6a 2f                	push   $0x2f
  jmp __alltraps
  101d20:	e9 3c fe ff ff       	jmp    101b61 <__alltraps>

00101d25 <vector48>:
.globl vector48
vector48:
  pushl $0
  101d25:	6a 00                	push   $0x0
  pushl $48
  101d27:	6a 30                	push   $0x30
  jmp __alltraps
  101d29:	e9 33 fe ff ff       	jmp    101b61 <__alltraps>

00101d2e <vector49>:
.globl vector49
vector49:
  pushl $0
  101d2e:	6a 00                	push   $0x0
  pushl $49
  101d30:	6a 31                	push   $0x31
  jmp __alltraps
  101d32:	e9 2a fe ff ff       	jmp    101b61 <__alltraps>

00101d37 <vector50>:
.globl vector50
vector50:
  pushl $0
  101d37:	6a 00                	push   $0x0
  pushl $50
  101d39:	6a 32                	push   $0x32
  jmp __alltraps
  101d3b:	e9 21 fe ff ff       	jmp    101b61 <__alltraps>

00101d40 <vector51>:
.globl vector51
vector51:
  pushl $0
  101d40:	6a 00                	push   $0x0
  pushl $51
  101d42:	6a 33                	push   $0x33
  jmp __alltraps
  101d44:	e9 18 fe ff ff       	jmp    101b61 <__alltraps>

00101d49 <vector52>:
.globl vector52
vector52:
  pushl $0
  101d49:	6a 00                	push   $0x0
  pushl $52
  101d4b:	6a 34                	push   $0x34
  jmp __alltraps
  101d4d:	e9 0f fe ff ff       	jmp    101b61 <__alltraps>

00101d52 <vector53>:
.globl vector53
vector53:
  pushl $0
  101d52:	6a 00                	push   $0x0
  pushl $53
  101d54:	6a 35                	push   $0x35
  jmp __alltraps
  101d56:	e9 06 fe ff ff       	jmp    101b61 <__alltraps>

00101d5b <vector54>:
.globl vector54
vector54:
  pushl $0
  101d5b:	6a 00                	push   $0x0
  pushl $54
  101d5d:	6a 36                	push   $0x36
  jmp __alltraps
  101d5f:	e9 fd fd ff ff       	jmp    101b61 <__alltraps>

00101d64 <vector55>:
.globl vector55
vector55:
  pushl $0
  101d64:	6a 00                	push   $0x0
  pushl $55
  101d66:	6a 37                	push   $0x37
  jmp __alltraps
  101d68:	e9 f4 fd ff ff       	jmp    101b61 <__alltraps>

00101d6d <vector56>:
.globl vector56
vector56:
  pushl $0
  101d6d:	6a 00                	push   $0x0
  pushl $56
  101d6f:	6a 38                	push   $0x38
  jmp __alltraps
  101d71:	e9 eb fd ff ff       	jmp    101b61 <__alltraps>

00101d76 <vector57>:
.globl vector57
vector57:
  pushl $0
  101d76:	6a 00                	push   $0x0
  pushl $57
  101d78:	6a 39                	push   $0x39
  jmp __alltraps
  101d7a:	e9 e2 fd ff ff       	jmp    101b61 <__alltraps>

00101d7f <vector58>:
.globl vector58
vector58:
  pushl $0
  101d7f:	6a 00                	push   $0x0
  pushl $58
  101d81:	6a 3a                	push   $0x3a
  jmp __alltraps
  101d83:	e9 d9 fd ff ff       	jmp    101b61 <__alltraps>

00101d88 <vector59>:
.globl vector59
vector59:
  pushl $0
  101d88:	6a 00                	push   $0x0
  pushl $59
  101d8a:	6a 3b                	push   $0x3b
  jmp __alltraps
  101d8c:	e9 d0 fd ff ff       	jmp    101b61 <__alltraps>

00101d91 <vector60>:
.globl vector60
vector60:
  pushl $0
  101d91:	6a 00                	push   $0x0
  pushl $60
  101d93:	6a 3c                	push   $0x3c
  jmp __alltraps
  101d95:	e9 c7 fd ff ff       	jmp    101b61 <__alltraps>

00101d9a <vector61>:
.globl vector61
vector61:
  pushl $0
  101d9a:	6a 00                	push   $0x0
  pushl $61
  101d9c:	6a 3d                	push   $0x3d
  jmp __alltraps
  101d9e:	e9 be fd ff ff       	jmp    101b61 <__alltraps>

00101da3 <vector62>:
.globl vector62
vector62:
  pushl $0
  101da3:	6a 00                	push   $0x0
  pushl $62
  101da5:	6a 3e                	push   $0x3e
  jmp __alltraps
  101da7:	e9 b5 fd ff ff       	jmp    101b61 <__alltraps>

00101dac <vector63>:
.globl vector63
vector63:
  pushl $0
  101dac:	6a 00                	push   $0x0
  pushl $63
  101dae:	6a 3f                	push   $0x3f
  jmp __alltraps
  101db0:	e9 ac fd ff ff       	jmp    101b61 <__alltraps>

00101db5 <vector64>:
.globl vector64
vector64:
  pushl $0
  101db5:	6a 00                	push   $0x0
  pushl $64
  101db7:	6a 40                	push   $0x40
  jmp __alltraps
  101db9:	e9 a3 fd ff ff       	jmp    101b61 <__alltraps>

00101dbe <vector65>:
.globl vector65
vector65:
  pushl $0
  101dbe:	6a 00                	push   $0x0
  pushl $65
  101dc0:	6a 41                	push   $0x41
  jmp __alltraps
  101dc2:	e9 9a fd ff ff       	jmp    101b61 <__alltraps>

00101dc7 <vector66>:
.globl vector66
vector66:
  pushl $0
  101dc7:	6a 00                	push   $0x0
  pushl $66
  101dc9:	6a 42                	push   $0x42
  jmp __alltraps
  101dcb:	e9 91 fd ff ff       	jmp    101b61 <__alltraps>

00101dd0 <vector67>:
.globl vector67
vector67:
  pushl $0
  101dd0:	6a 00                	push   $0x0
  pushl $67
  101dd2:	6a 43                	push   $0x43
  jmp __alltraps
  101dd4:	e9 88 fd ff ff       	jmp    101b61 <__alltraps>

00101dd9 <vector68>:
.globl vector68
vector68:
  pushl $0
  101dd9:	6a 00                	push   $0x0
  pushl $68
  101ddb:	6a 44                	push   $0x44
  jmp __alltraps
  101ddd:	e9 7f fd ff ff       	jmp    101b61 <__alltraps>

00101de2 <vector69>:
.globl vector69
vector69:
  pushl $0
  101de2:	6a 00                	push   $0x0
  pushl $69
  101de4:	6a 45                	push   $0x45
  jmp __alltraps
  101de6:	e9 76 fd ff ff       	jmp    101b61 <__alltraps>

00101deb <vector70>:
.globl vector70
vector70:
  pushl $0
  101deb:	6a 00                	push   $0x0
  pushl $70
  101ded:	6a 46                	push   $0x46
  jmp __alltraps
  101def:	e9 6d fd ff ff       	jmp    101b61 <__alltraps>

00101df4 <vector71>:
.globl vector71
vector71:
  pushl $0
  101df4:	6a 00                	push   $0x0
  pushl $71
  101df6:	6a 47                	push   $0x47
  jmp __alltraps
  101df8:	e9 64 fd ff ff       	jmp    101b61 <__alltraps>

00101dfd <vector72>:
.globl vector72
vector72:
  pushl $0
  101dfd:	6a 00                	push   $0x0
  pushl $72
  101dff:	6a 48                	push   $0x48
  jmp __alltraps
  101e01:	e9 5b fd ff ff       	jmp    101b61 <__alltraps>

00101e06 <vector73>:
.globl vector73
vector73:
  pushl $0
  101e06:	6a 00                	push   $0x0
  pushl $73
  101e08:	6a 49                	push   $0x49
  jmp __alltraps
  101e0a:	e9 52 fd ff ff       	jmp    101b61 <__alltraps>

00101e0f <vector74>:
.globl vector74
vector74:
  pushl $0
  101e0f:	6a 00                	push   $0x0
  pushl $74
  101e11:	6a 4a                	push   $0x4a
  jmp __alltraps
  101e13:	e9 49 fd ff ff       	jmp    101b61 <__alltraps>

00101e18 <vector75>:
.globl vector75
vector75:
  pushl $0
  101e18:	6a 00                	push   $0x0
  pushl $75
  101e1a:	6a 4b                	push   $0x4b
  jmp __alltraps
  101e1c:	e9 40 fd ff ff       	jmp    101b61 <__alltraps>

00101e21 <vector76>:
.globl vector76
vector76:
  pushl $0
  101e21:	6a 00                	push   $0x0
  pushl $76
  101e23:	6a 4c                	push   $0x4c
  jmp __alltraps
  101e25:	e9 37 fd ff ff       	jmp    101b61 <__alltraps>

00101e2a <vector77>:
.globl vector77
vector77:
  pushl $0
  101e2a:	6a 00                	push   $0x0
  pushl $77
  101e2c:	6a 4d                	push   $0x4d
  jmp __alltraps
  101e2e:	e9 2e fd ff ff       	jmp    101b61 <__alltraps>

00101e33 <vector78>:
.globl vector78
vector78:
  pushl $0
  101e33:	6a 00                	push   $0x0
  pushl $78
  101e35:	6a 4e                	push   $0x4e
  jmp __alltraps
  101e37:	e9 25 fd ff ff       	jmp    101b61 <__alltraps>

00101e3c <vector79>:
.globl vector79
vector79:
  pushl $0
  101e3c:	6a 00                	push   $0x0
  pushl $79
  101e3e:	6a 4f                	push   $0x4f
  jmp __alltraps
  101e40:	e9 1c fd ff ff       	jmp    101b61 <__alltraps>

00101e45 <vector80>:
.globl vector80
vector80:
  pushl $0
  101e45:	6a 00                	push   $0x0
  pushl $80
  101e47:	6a 50                	push   $0x50
  jmp __alltraps
  101e49:	e9 13 fd ff ff       	jmp    101b61 <__alltraps>

00101e4e <vector81>:
.globl vector81
vector81:
  pushl $0
  101e4e:	6a 00                	push   $0x0
  pushl $81
  101e50:	6a 51                	push   $0x51
  jmp __alltraps
  101e52:	e9 0a fd ff ff       	jmp    101b61 <__alltraps>

00101e57 <vector82>:
.globl vector82
vector82:
  pushl $0
  101e57:	6a 00                	push   $0x0
  pushl $82
  101e59:	6a 52                	push   $0x52
  jmp __alltraps
  101e5b:	e9 01 fd ff ff       	jmp    101b61 <__alltraps>

00101e60 <vector83>:
.globl vector83
vector83:
  pushl $0
  101e60:	6a 00                	push   $0x0
  pushl $83
  101e62:	6a 53                	push   $0x53
  jmp __alltraps
  101e64:	e9 f8 fc ff ff       	jmp    101b61 <__alltraps>

00101e69 <vector84>:
.globl vector84
vector84:
  pushl $0
  101e69:	6a 00                	push   $0x0
  pushl $84
  101e6b:	6a 54                	push   $0x54
  jmp __alltraps
  101e6d:	e9 ef fc ff ff       	jmp    101b61 <__alltraps>

00101e72 <vector85>:
.globl vector85
vector85:
  pushl $0
  101e72:	6a 00                	push   $0x0
  pushl $85
  101e74:	6a 55                	push   $0x55
  jmp __alltraps
  101e76:	e9 e6 fc ff ff       	jmp    101b61 <__alltraps>

00101e7b <vector86>:
.globl vector86
vector86:
  pushl $0
  101e7b:	6a 00                	push   $0x0
  pushl $86
  101e7d:	6a 56                	push   $0x56
  jmp __alltraps
  101e7f:	e9 dd fc ff ff       	jmp    101b61 <__alltraps>

00101e84 <vector87>:
.globl vector87
vector87:
  pushl $0
  101e84:	6a 00                	push   $0x0
  pushl $87
  101e86:	6a 57                	push   $0x57
  jmp __alltraps
  101e88:	e9 d4 fc ff ff       	jmp    101b61 <__alltraps>

00101e8d <vector88>:
.globl vector88
vector88:
  pushl $0
  101e8d:	6a 00                	push   $0x0
  pushl $88
  101e8f:	6a 58                	push   $0x58
  jmp __alltraps
  101e91:	e9 cb fc ff ff       	jmp    101b61 <__alltraps>

00101e96 <vector89>:
.globl vector89
vector89:
  pushl $0
  101e96:	6a 00                	push   $0x0
  pushl $89
  101e98:	6a 59                	push   $0x59
  jmp __alltraps
  101e9a:	e9 c2 fc ff ff       	jmp    101b61 <__alltraps>

00101e9f <vector90>:
.globl vector90
vector90:
  pushl $0
  101e9f:	6a 00                	push   $0x0
  pushl $90
  101ea1:	6a 5a                	push   $0x5a
  jmp __alltraps
  101ea3:	e9 b9 fc ff ff       	jmp    101b61 <__alltraps>

00101ea8 <vector91>:
.globl vector91
vector91:
  pushl $0
  101ea8:	6a 00                	push   $0x0
  pushl $91
  101eaa:	6a 5b                	push   $0x5b
  jmp __alltraps
  101eac:	e9 b0 fc ff ff       	jmp    101b61 <__alltraps>

00101eb1 <vector92>:
.globl vector92
vector92:
  pushl $0
  101eb1:	6a 00                	push   $0x0
  pushl $92
  101eb3:	6a 5c                	push   $0x5c
  jmp __alltraps
  101eb5:	e9 a7 fc ff ff       	jmp    101b61 <__alltraps>

00101eba <vector93>:
.globl vector93
vector93:
  pushl $0
  101eba:	6a 00                	push   $0x0
  pushl $93
  101ebc:	6a 5d                	push   $0x5d
  jmp __alltraps
  101ebe:	e9 9e fc ff ff       	jmp    101b61 <__alltraps>

00101ec3 <vector94>:
.globl vector94
vector94:
  pushl $0
  101ec3:	6a 00                	push   $0x0
  pushl $94
  101ec5:	6a 5e                	push   $0x5e
  jmp __alltraps
  101ec7:	e9 95 fc ff ff       	jmp    101b61 <__alltraps>

00101ecc <vector95>:
.globl vector95
vector95:
  pushl $0
  101ecc:	6a 00                	push   $0x0
  pushl $95
  101ece:	6a 5f                	push   $0x5f
  jmp __alltraps
  101ed0:	e9 8c fc ff ff       	jmp    101b61 <__alltraps>

00101ed5 <vector96>:
.globl vector96
vector96:
  pushl $0
  101ed5:	6a 00                	push   $0x0
  pushl $96
  101ed7:	6a 60                	push   $0x60
  jmp __alltraps
  101ed9:	e9 83 fc ff ff       	jmp    101b61 <__alltraps>

00101ede <vector97>:
.globl vector97
vector97:
  pushl $0
  101ede:	6a 00                	push   $0x0
  pushl $97
  101ee0:	6a 61                	push   $0x61
  jmp __alltraps
  101ee2:	e9 7a fc ff ff       	jmp    101b61 <__alltraps>

00101ee7 <vector98>:
.globl vector98
vector98:
  pushl $0
  101ee7:	6a 00                	push   $0x0
  pushl $98
  101ee9:	6a 62                	push   $0x62
  jmp __alltraps
  101eeb:	e9 71 fc ff ff       	jmp    101b61 <__alltraps>

00101ef0 <vector99>:
.globl vector99
vector99:
  pushl $0
  101ef0:	6a 00                	push   $0x0
  pushl $99
  101ef2:	6a 63                	push   $0x63
  jmp __alltraps
  101ef4:	e9 68 fc ff ff       	jmp    101b61 <__alltraps>

00101ef9 <vector100>:
.globl vector100
vector100:
  pushl $0
  101ef9:	6a 00                	push   $0x0
  pushl $100
  101efb:	6a 64                	push   $0x64
  jmp __alltraps
  101efd:	e9 5f fc ff ff       	jmp    101b61 <__alltraps>

00101f02 <vector101>:
.globl vector101
vector101:
  pushl $0
  101f02:	6a 00                	push   $0x0
  pushl $101
  101f04:	6a 65                	push   $0x65
  jmp __alltraps
  101f06:	e9 56 fc ff ff       	jmp    101b61 <__alltraps>

00101f0b <vector102>:
.globl vector102
vector102:
  pushl $0
  101f0b:	6a 00                	push   $0x0
  pushl $102
  101f0d:	6a 66                	push   $0x66
  jmp __alltraps
  101f0f:	e9 4d fc ff ff       	jmp    101b61 <__alltraps>

00101f14 <vector103>:
.globl vector103
vector103:
  pushl $0
  101f14:	6a 00                	push   $0x0
  pushl $103
  101f16:	6a 67                	push   $0x67
  jmp __alltraps
  101f18:	e9 44 fc ff ff       	jmp    101b61 <__alltraps>

00101f1d <vector104>:
.globl vector104
vector104:
  pushl $0
  101f1d:	6a 00                	push   $0x0
  pushl $104
  101f1f:	6a 68                	push   $0x68
  jmp __alltraps
  101f21:	e9 3b fc ff ff       	jmp    101b61 <__alltraps>

00101f26 <vector105>:
.globl vector105
vector105:
  pushl $0
  101f26:	6a 00                	push   $0x0
  pushl $105
  101f28:	6a 69                	push   $0x69
  jmp __alltraps
  101f2a:	e9 32 fc ff ff       	jmp    101b61 <__alltraps>

00101f2f <vector106>:
.globl vector106
vector106:
  pushl $0
  101f2f:	6a 00                	push   $0x0
  pushl $106
  101f31:	6a 6a                	push   $0x6a
  jmp __alltraps
  101f33:	e9 29 fc ff ff       	jmp    101b61 <__alltraps>

00101f38 <vector107>:
.globl vector107
vector107:
  pushl $0
  101f38:	6a 00                	push   $0x0
  pushl $107
  101f3a:	6a 6b                	push   $0x6b
  jmp __alltraps
  101f3c:	e9 20 fc ff ff       	jmp    101b61 <__alltraps>

00101f41 <vector108>:
.globl vector108
vector108:
  pushl $0
  101f41:	6a 00                	push   $0x0
  pushl $108
  101f43:	6a 6c                	push   $0x6c
  jmp __alltraps
  101f45:	e9 17 fc ff ff       	jmp    101b61 <__alltraps>

00101f4a <vector109>:
.globl vector109
vector109:
  pushl $0
  101f4a:	6a 00                	push   $0x0
  pushl $109
  101f4c:	6a 6d                	push   $0x6d
  jmp __alltraps
  101f4e:	e9 0e fc ff ff       	jmp    101b61 <__alltraps>

00101f53 <vector110>:
.globl vector110
vector110:
  pushl $0
  101f53:	6a 00                	push   $0x0
  pushl $110
  101f55:	6a 6e                	push   $0x6e
  jmp __alltraps
  101f57:	e9 05 fc ff ff       	jmp    101b61 <__alltraps>

00101f5c <vector111>:
.globl vector111
vector111:
  pushl $0
  101f5c:	6a 00                	push   $0x0
  pushl $111
  101f5e:	6a 6f                	push   $0x6f
  jmp __alltraps
  101f60:	e9 fc fb ff ff       	jmp    101b61 <__alltraps>

00101f65 <vector112>:
.globl vector112
vector112:
  pushl $0
  101f65:	6a 00                	push   $0x0
  pushl $112
  101f67:	6a 70                	push   $0x70
  jmp __alltraps
  101f69:	e9 f3 fb ff ff       	jmp    101b61 <__alltraps>

00101f6e <vector113>:
.globl vector113
vector113:
  pushl $0
  101f6e:	6a 00                	push   $0x0
  pushl $113
  101f70:	6a 71                	push   $0x71
  jmp __alltraps
  101f72:	e9 ea fb ff ff       	jmp    101b61 <__alltraps>

00101f77 <vector114>:
.globl vector114
vector114:
  pushl $0
  101f77:	6a 00                	push   $0x0
  pushl $114
  101f79:	6a 72                	push   $0x72
  jmp __alltraps
  101f7b:	e9 e1 fb ff ff       	jmp    101b61 <__alltraps>

00101f80 <vector115>:
.globl vector115
vector115:
  pushl $0
  101f80:	6a 00                	push   $0x0
  pushl $115
  101f82:	6a 73                	push   $0x73
  jmp __alltraps
  101f84:	e9 d8 fb ff ff       	jmp    101b61 <__alltraps>

00101f89 <vector116>:
.globl vector116
vector116:
  pushl $0
  101f89:	6a 00                	push   $0x0
  pushl $116
  101f8b:	6a 74                	push   $0x74
  jmp __alltraps
  101f8d:	e9 cf fb ff ff       	jmp    101b61 <__alltraps>

00101f92 <vector117>:
.globl vector117
vector117:
  pushl $0
  101f92:	6a 00                	push   $0x0
  pushl $117
  101f94:	6a 75                	push   $0x75
  jmp __alltraps
  101f96:	e9 c6 fb ff ff       	jmp    101b61 <__alltraps>

00101f9b <vector118>:
.globl vector118
vector118:
  pushl $0
  101f9b:	6a 00                	push   $0x0
  pushl $118
  101f9d:	6a 76                	push   $0x76
  jmp __alltraps
  101f9f:	e9 bd fb ff ff       	jmp    101b61 <__alltraps>

00101fa4 <vector119>:
.globl vector119
vector119:
  pushl $0
  101fa4:	6a 00                	push   $0x0
  pushl $119
  101fa6:	6a 77                	push   $0x77
  jmp __alltraps
  101fa8:	e9 b4 fb ff ff       	jmp    101b61 <__alltraps>

00101fad <vector120>:
.globl vector120
vector120:
  pushl $0
  101fad:	6a 00                	push   $0x0
  pushl $120
  101faf:	6a 78                	push   $0x78
  jmp __alltraps
  101fb1:	e9 ab fb ff ff       	jmp    101b61 <__alltraps>

00101fb6 <vector121>:
.globl vector121
vector121:
  pushl $0
  101fb6:	6a 00                	push   $0x0
  pushl $121
  101fb8:	6a 79                	push   $0x79
  jmp __alltraps
  101fba:	e9 a2 fb ff ff       	jmp    101b61 <__alltraps>

00101fbf <vector122>:
.globl vector122
vector122:
  pushl $0
  101fbf:	6a 00                	push   $0x0
  pushl $122
  101fc1:	6a 7a                	push   $0x7a
  jmp __alltraps
  101fc3:	e9 99 fb ff ff       	jmp    101b61 <__alltraps>

00101fc8 <vector123>:
.globl vector123
vector123:
  pushl $0
  101fc8:	6a 00                	push   $0x0
  pushl $123
  101fca:	6a 7b                	push   $0x7b
  jmp __alltraps
  101fcc:	e9 90 fb ff ff       	jmp    101b61 <__alltraps>

00101fd1 <vector124>:
.globl vector124
vector124:
  pushl $0
  101fd1:	6a 00                	push   $0x0
  pushl $124
  101fd3:	6a 7c                	push   $0x7c
  jmp __alltraps
  101fd5:	e9 87 fb ff ff       	jmp    101b61 <__alltraps>

00101fda <vector125>:
.globl vector125
vector125:
  pushl $0
  101fda:	6a 00                	push   $0x0
  pushl $125
  101fdc:	6a 7d                	push   $0x7d
  jmp __alltraps
  101fde:	e9 7e fb ff ff       	jmp    101b61 <__alltraps>

00101fe3 <vector126>:
.globl vector126
vector126:
  pushl $0
  101fe3:	6a 00                	push   $0x0
  pushl $126
  101fe5:	6a 7e                	push   $0x7e
  jmp __alltraps
  101fe7:	e9 75 fb ff ff       	jmp    101b61 <__alltraps>

00101fec <vector127>:
.globl vector127
vector127:
  pushl $0
  101fec:	6a 00                	push   $0x0
  pushl $127
  101fee:	6a 7f                	push   $0x7f
  jmp __alltraps
  101ff0:	e9 6c fb ff ff       	jmp    101b61 <__alltraps>

00101ff5 <vector128>:
.globl vector128
vector128:
  pushl $0
  101ff5:	6a 00                	push   $0x0
  pushl $128
  101ff7:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  101ffc:	e9 60 fb ff ff       	jmp    101b61 <__alltraps>

00102001 <vector129>:
.globl vector129
vector129:
  pushl $0
  102001:	6a 00                	push   $0x0
  pushl $129
  102003:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102008:	e9 54 fb ff ff       	jmp    101b61 <__alltraps>

0010200d <vector130>:
.globl vector130
vector130:
  pushl $0
  10200d:	6a 00                	push   $0x0
  pushl $130
  10200f:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102014:	e9 48 fb ff ff       	jmp    101b61 <__alltraps>

00102019 <vector131>:
.globl vector131
vector131:
  pushl $0
  102019:	6a 00                	push   $0x0
  pushl $131
  10201b:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102020:	e9 3c fb ff ff       	jmp    101b61 <__alltraps>

00102025 <vector132>:
.globl vector132
vector132:
  pushl $0
  102025:	6a 00                	push   $0x0
  pushl $132
  102027:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10202c:	e9 30 fb ff ff       	jmp    101b61 <__alltraps>

00102031 <vector133>:
.globl vector133
vector133:
  pushl $0
  102031:	6a 00                	push   $0x0
  pushl $133
  102033:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102038:	e9 24 fb ff ff       	jmp    101b61 <__alltraps>

0010203d <vector134>:
.globl vector134
vector134:
  pushl $0
  10203d:	6a 00                	push   $0x0
  pushl $134
  10203f:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102044:	e9 18 fb ff ff       	jmp    101b61 <__alltraps>

00102049 <vector135>:
.globl vector135
vector135:
  pushl $0
  102049:	6a 00                	push   $0x0
  pushl $135
  10204b:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102050:	e9 0c fb ff ff       	jmp    101b61 <__alltraps>

00102055 <vector136>:
.globl vector136
vector136:
  pushl $0
  102055:	6a 00                	push   $0x0
  pushl $136
  102057:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10205c:	e9 00 fb ff ff       	jmp    101b61 <__alltraps>

00102061 <vector137>:
.globl vector137
vector137:
  pushl $0
  102061:	6a 00                	push   $0x0
  pushl $137
  102063:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102068:	e9 f4 fa ff ff       	jmp    101b61 <__alltraps>

0010206d <vector138>:
.globl vector138
vector138:
  pushl $0
  10206d:	6a 00                	push   $0x0
  pushl $138
  10206f:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102074:	e9 e8 fa ff ff       	jmp    101b61 <__alltraps>

00102079 <vector139>:
.globl vector139
vector139:
  pushl $0
  102079:	6a 00                	push   $0x0
  pushl $139
  10207b:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102080:	e9 dc fa ff ff       	jmp    101b61 <__alltraps>

00102085 <vector140>:
.globl vector140
vector140:
  pushl $0
  102085:	6a 00                	push   $0x0
  pushl $140
  102087:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10208c:	e9 d0 fa ff ff       	jmp    101b61 <__alltraps>

00102091 <vector141>:
.globl vector141
vector141:
  pushl $0
  102091:	6a 00                	push   $0x0
  pushl $141
  102093:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102098:	e9 c4 fa ff ff       	jmp    101b61 <__alltraps>

0010209d <vector142>:
.globl vector142
vector142:
  pushl $0
  10209d:	6a 00                	push   $0x0
  pushl $142
  10209f:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1020a4:	e9 b8 fa ff ff       	jmp    101b61 <__alltraps>

001020a9 <vector143>:
.globl vector143
vector143:
  pushl $0
  1020a9:	6a 00                	push   $0x0
  pushl $143
  1020ab:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1020b0:	e9 ac fa ff ff       	jmp    101b61 <__alltraps>

001020b5 <vector144>:
.globl vector144
vector144:
  pushl $0
  1020b5:	6a 00                	push   $0x0
  pushl $144
  1020b7:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1020bc:	e9 a0 fa ff ff       	jmp    101b61 <__alltraps>

001020c1 <vector145>:
.globl vector145
vector145:
  pushl $0
  1020c1:	6a 00                	push   $0x0
  pushl $145
  1020c3:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1020c8:	e9 94 fa ff ff       	jmp    101b61 <__alltraps>

001020cd <vector146>:
.globl vector146
vector146:
  pushl $0
  1020cd:	6a 00                	push   $0x0
  pushl $146
  1020cf:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1020d4:	e9 88 fa ff ff       	jmp    101b61 <__alltraps>

001020d9 <vector147>:
.globl vector147
vector147:
  pushl $0
  1020d9:	6a 00                	push   $0x0
  pushl $147
  1020db:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1020e0:	e9 7c fa ff ff       	jmp    101b61 <__alltraps>

001020e5 <vector148>:
.globl vector148
vector148:
  pushl $0
  1020e5:	6a 00                	push   $0x0
  pushl $148
  1020e7:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1020ec:	e9 70 fa ff ff       	jmp    101b61 <__alltraps>

001020f1 <vector149>:
.globl vector149
vector149:
  pushl $0
  1020f1:	6a 00                	push   $0x0
  pushl $149
  1020f3:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1020f8:	e9 64 fa ff ff       	jmp    101b61 <__alltraps>

001020fd <vector150>:
.globl vector150
vector150:
  pushl $0
  1020fd:	6a 00                	push   $0x0
  pushl $150
  1020ff:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102104:	e9 58 fa ff ff       	jmp    101b61 <__alltraps>

00102109 <vector151>:
.globl vector151
vector151:
  pushl $0
  102109:	6a 00                	push   $0x0
  pushl $151
  10210b:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102110:	e9 4c fa ff ff       	jmp    101b61 <__alltraps>

00102115 <vector152>:
.globl vector152
vector152:
  pushl $0
  102115:	6a 00                	push   $0x0
  pushl $152
  102117:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10211c:	e9 40 fa ff ff       	jmp    101b61 <__alltraps>

00102121 <vector153>:
.globl vector153
vector153:
  pushl $0
  102121:	6a 00                	push   $0x0
  pushl $153
  102123:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102128:	e9 34 fa ff ff       	jmp    101b61 <__alltraps>

0010212d <vector154>:
.globl vector154
vector154:
  pushl $0
  10212d:	6a 00                	push   $0x0
  pushl $154
  10212f:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102134:	e9 28 fa ff ff       	jmp    101b61 <__alltraps>

00102139 <vector155>:
.globl vector155
vector155:
  pushl $0
  102139:	6a 00                	push   $0x0
  pushl $155
  10213b:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102140:	e9 1c fa ff ff       	jmp    101b61 <__alltraps>

00102145 <vector156>:
.globl vector156
vector156:
  pushl $0
  102145:	6a 00                	push   $0x0
  pushl $156
  102147:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10214c:	e9 10 fa ff ff       	jmp    101b61 <__alltraps>

00102151 <vector157>:
.globl vector157
vector157:
  pushl $0
  102151:	6a 00                	push   $0x0
  pushl $157
  102153:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102158:	e9 04 fa ff ff       	jmp    101b61 <__alltraps>

0010215d <vector158>:
.globl vector158
vector158:
  pushl $0
  10215d:	6a 00                	push   $0x0
  pushl $158
  10215f:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102164:	e9 f8 f9 ff ff       	jmp    101b61 <__alltraps>

00102169 <vector159>:
.globl vector159
vector159:
  pushl $0
  102169:	6a 00                	push   $0x0
  pushl $159
  10216b:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102170:	e9 ec f9 ff ff       	jmp    101b61 <__alltraps>

00102175 <vector160>:
.globl vector160
vector160:
  pushl $0
  102175:	6a 00                	push   $0x0
  pushl $160
  102177:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10217c:	e9 e0 f9 ff ff       	jmp    101b61 <__alltraps>

00102181 <vector161>:
.globl vector161
vector161:
  pushl $0
  102181:	6a 00                	push   $0x0
  pushl $161
  102183:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102188:	e9 d4 f9 ff ff       	jmp    101b61 <__alltraps>

0010218d <vector162>:
.globl vector162
vector162:
  pushl $0
  10218d:	6a 00                	push   $0x0
  pushl $162
  10218f:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102194:	e9 c8 f9 ff ff       	jmp    101b61 <__alltraps>

00102199 <vector163>:
.globl vector163
vector163:
  pushl $0
  102199:	6a 00                	push   $0x0
  pushl $163
  10219b:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1021a0:	e9 bc f9 ff ff       	jmp    101b61 <__alltraps>

001021a5 <vector164>:
.globl vector164
vector164:
  pushl $0
  1021a5:	6a 00                	push   $0x0
  pushl $164
  1021a7:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1021ac:	e9 b0 f9 ff ff       	jmp    101b61 <__alltraps>

001021b1 <vector165>:
.globl vector165
vector165:
  pushl $0
  1021b1:	6a 00                	push   $0x0
  pushl $165
  1021b3:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1021b8:	e9 a4 f9 ff ff       	jmp    101b61 <__alltraps>

001021bd <vector166>:
.globl vector166
vector166:
  pushl $0
  1021bd:	6a 00                	push   $0x0
  pushl $166
  1021bf:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1021c4:	e9 98 f9 ff ff       	jmp    101b61 <__alltraps>

001021c9 <vector167>:
.globl vector167
vector167:
  pushl $0
  1021c9:	6a 00                	push   $0x0
  pushl $167
  1021cb:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1021d0:	e9 8c f9 ff ff       	jmp    101b61 <__alltraps>

001021d5 <vector168>:
.globl vector168
vector168:
  pushl $0
  1021d5:	6a 00                	push   $0x0
  pushl $168
  1021d7:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1021dc:	e9 80 f9 ff ff       	jmp    101b61 <__alltraps>

001021e1 <vector169>:
.globl vector169
vector169:
  pushl $0
  1021e1:	6a 00                	push   $0x0
  pushl $169
  1021e3:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1021e8:	e9 74 f9 ff ff       	jmp    101b61 <__alltraps>

001021ed <vector170>:
.globl vector170
vector170:
  pushl $0
  1021ed:	6a 00                	push   $0x0
  pushl $170
  1021ef:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1021f4:	e9 68 f9 ff ff       	jmp    101b61 <__alltraps>

001021f9 <vector171>:
.globl vector171
vector171:
  pushl $0
  1021f9:	6a 00                	push   $0x0
  pushl $171
  1021fb:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102200:	e9 5c f9 ff ff       	jmp    101b61 <__alltraps>

00102205 <vector172>:
.globl vector172
vector172:
  pushl $0
  102205:	6a 00                	push   $0x0
  pushl $172
  102207:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10220c:	e9 50 f9 ff ff       	jmp    101b61 <__alltraps>

00102211 <vector173>:
.globl vector173
vector173:
  pushl $0
  102211:	6a 00                	push   $0x0
  pushl $173
  102213:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102218:	e9 44 f9 ff ff       	jmp    101b61 <__alltraps>

0010221d <vector174>:
.globl vector174
vector174:
  pushl $0
  10221d:	6a 00                	push   $0x0
  pushl $174
  10221f:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102224:	e9 38 f9 ff ff       	jmp    101b61 <__alltraps>

00102229 <vector175>:
.globl vector175
vector175:
  pushl $0
  102229:	6a 00                	push   $0x0
  pushl $175
  10222b:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102230:	e9 2c f9 ff ff       	jmp    101b61 <__alltraps>

00102235 <vector176>:
.globl vector176
vector176:
  pushl $0
  102235:	6a 00                	push   $0x0
  pushl $176
  102237:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10223c:	e9 20 f9 ff ff       	jmp    101b61 <__alltraps>

00102241 <vector177>:
.globl vector177
vector177:
  pushl $0
  102241:	6a 00                	push   $0x0
  pushl $177
  102243:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102248:	e9 14 f9 ff ff       	jmp    101b61 <__alltraps>

0010224d <vector178>:
.globl vector178
vector178:
  pushl $0
  10224d:	6a 00                	push   $0x0
  pushl $178
  10224f:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102254:	e9 08 f9 ff ff       	jmp    101b61 <__alltraps>

00102259 <vector179>:
.globl vector179
vector179:
  pushl $0
  102259:	6a 00                	push   $0x0
  pushl $179
  10225b:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102260:	e9 fc f8 ff ff       	jmp    101b61 <__alltraps>

00102265 <vector180>:
.globl vector180
vector180:
  pushl $0
  102265:	6a 00                	push   $0x0
  pushl $180
  102267:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10226c:	e9 f0 f8 ff ff       	jmp    101b61 <__alltraps>

00102271 <vector181>:
.globl vector181
vector181:
  pushl $0
  102271:	6a 00                	push   $0x0
  pushl $181
  102273:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102278:	e9 e4 f8 ff ff       	jmp    101b61 <__alltraps>

0010227d <vector182>:
.globl vector182
vector182:
  pushl $0
  10227d:	6a 00                	push   $0x0
  pushl $182
  10227f:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102284:	e9 d8 f8 ff ff       	jmp    101b61 <__alltraps>

00102289 <vector183>:
.globl vector183
vector183:
  pushl $0
  102289:	6a 00                	push   $0x0
  pushl $183
  10228b:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102290:	e9 cc f8 ff ff       	jmp    101b61 <__alltraps>

00102295 <vector184>:
.globl vector184
vector184:
  pushl $0
  102295:	6a 00                	push   $0x0
  pushl $184
  102297:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10229c:	e9 c0 f8 ff ff       	jmp    101b61 <__alltraps>

001022a1 <vector185>:
.globl vector185
vector185:
  pushl $0
  1022a1:	6a 00                	push   $0x0
  pushl $185
  1022a3:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1022a8:	e9 b4 f8 ff ff       	jmp    101b61 <__alltraps>

001022ad <vector186>:
.globl vector186
vector186:
  pushl $0
  1022ad:	6a 00                	push   $0x0
  pushl $186
  1022af:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1022b4:	e9 a8 f8 ff ff       	jmp    101b61 <__alltraps>

001022b9 <vector187>:
.globl vector187
vector187:
  pushl $0
  1022b9:	6a 00                	push   $0x0
  pushl $187
  1022bb:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1022c0:	e9 9c f8 ff ff       	jmp    101b61 <__alltraps>

001022c5 <vector188>:
.globl vector188
vector188:
  pushl $0
  1022c5:	6a 00                	push   $0x0
  pushl $188
  1022c7:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1022cc:	e9 90 f8 ff ff       	jmp    101b61 <__alltraps>

001022d1 <vector189>:
.globl vector189
vector189:
  pushl $0
  1022d1:	6a 00                	push   $0x0
  pushl $189
  1022d3:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1022d8:	e9 84 f8 ff ff       	jmp    101b61 <__alltraps>

001022dd <vector190>:
.globl vector190
vector190:
  pushl $0
  1022dd:	6a 00                	push   $0x0
  pushl $190
  1022df:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1022e4:	e9 78 f8 ff ff       	jmp    101b61 <__alltraps>

001022e9 <vector191>:
.globl vector191
vector191:
  pushl $0
  1022e9:	6a 00                	push   $0x0
  pushl $191
  1022eb:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1022f0:	e9 6c f8 ff ff       	jmp    101b61 <__alltraps>

001022f5 <vector192>:
.globl vector192
vector192:
  pushl $0
  1022f5:	6a 00                	push   $0x0
  pushl $192
  1022f7:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1022fc:	e9 60 f8 ff ff       	jmp    101b61 <__alltraps>

00102301 <vector193>:
.globl vector193
vector193:
  pushl $0
  102301:	6a 00                	push   $0x0
  pushl $193
  102303:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102308:	e9 54 f8 ff ff       	jmp    101b61 <__alltraps>

0010230d <vector194>:
.globl vector194
vector194:
  pushl $0
  10230d:	6a 00                	push   $0x0
  pushl $194
  10230f:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102314:	e9 48 f8 ff ff       	jmp    101b61 <__alltraps>

00102319 <vector195>:
.globl vector195
vector195:
  pushl $0
  102319:	6a 00                	push   $0x0
  pushl $195
  10231b:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102320:	e9 3c f8 ff ff       	jmp    101b61 <__alltraps>

00102325 <vector196>:
.globl vector196
vector196:
  pushl $0
  102325:	6a 00                	push   $0x0
  pushl $196
  102327:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10232c:	e9 30 f8 ff ff       	jmp    101b61 <__alltraps>

00102331 <vector197>:
.globl vector197
vector197:
  pushl $0
  102331:	6a 00                	push   $0x0
  pushl $197
  102333:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102338:	e9 24 f8 ff ff       	jmp    101b61 <__alltraps>

0010233d <vector198>:
.globl vector198
vector198:
  pushl $0
  10233d:	6a 00                	push   $0x0
  pushl $198
  10233f:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102344:	e9 18 f8 ff ff       	jmp    101b61 <__alltraps>

00102349 <vector199>:
.globl vector199
vector199:
  pushl $0
  102349:	6a 00                	push   $0x0
  pushl $199
  10234b:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102350:	e9 0c f8 ff ff       	jmp    101b61 <__alltraps>

00102355 <vector200>:
.globl vector200
vector200:
  pushl $0
  102355:	6a 00                	push   $0x0
  pushl $200
  102357:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10235c:	e9 00 f8 ff ff       	jmp    101b61 <__alltraps>

00102361 <vector201>:
.globl vector201
vector201:
  pushl $0
  102361:	6a 00                	push   $0x0
  pushl $201
  102363:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102368:	e9 f4 f7 ff ff       	jmp    101b61 <__alltraps>

0010236d <vector202>:
.globl vector202
vector202:
  pushl $0
  10236d:	6a 00                	push   $0x0
  pushl $202
  10236f:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102374:	e9 e8 f7 ff ff       	jmp    101b61 <__alltraps>

00102379 <vector203>:
.globl vector203
vector203:
  pushl $0
  102379:	6a 00                	push   $0x0
  pushl $203
  10237b:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102380:	e9 dc f7 ff ff       	jmp    101b61 <__alltraps>

00102385 <vector204>:
.globl vector204
vector204:
  pushl $0
  102385:	6a 00                	push   $0x0
  pushl $204
  102387:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10238c:	e9 d0 f7 ff ff       	jmp    101b61 <__alltraps>

00102391 <vector205>:
.globl vector205
vector205:
  pushl $0
  102391:	6a 00                	push   $0x0
  pushl $205
  102393:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102398:	e9 c4 f7 ff ff       	jmp    101b61 <__alltraps>

0010239d <vector206>:
.globl vector206
vector206:
  pushl $0
  10239d:	6a 00                	push   $0x0
  pushl $206
  10239f:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1023a4:	e9 b8 f7 ff ff       	jmp    101b61 <__alltraps>

001023a9 <vector207>:
.globl vector207
vector207:
  pushl $0
  1023a9:	6a 00                	push   $0x0
  pushl $207
  1023ab:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1023b0:	e9 ac f7 ff ff       	jmp    101b61 <__alltraps>

001023b5 <vector208>:
.globl vector208
vector208:
  pushl $0
  1023b5:	6a 00                	push   $0x0
  pushl $208
  1023b7:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1023bc:	e9 a0 f7 ff ff       	jmp    101b61 <__alltraps>

001023c1 <vector209>:
.globl vector209
vector209:
  pushl $0
  1023c1:	6a 00                	push   $0x0
  pushl $209
  1023c3:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1023c8:	e9 94 f7 ff ff       	jmp    101b61 <__alltraps>

001023cd <vector210>:
.globl vector210
vector210:
  pushl $0
  1023cd:	6a 00                	push   $0x0
  pushl $210
  1023cf:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1023d4:	e9 88 f7 ff ff       	jmp    101b61 <__alltraps>

001023d9 <vector211>:
.globl vector211
vector211:
  pushl $0
  1023d9:	6a 00                	push   $0x0
  pushl $211
  1023db:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1023e0:	e9 7c f7 ff ff       	jmp    101b61 <__alltraps>

001023e5 <vector212>:
.globl vector212
vector212:
  pushl $0
  1023e5:	6a 00                	push   $0x0
  pushl $212
  1023e7:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1023ec:	e9 70 f7 ff ff       	jmp    101b61 <__alltraps>

001023f1 <vector213>:
.globl vector213
vector213:
  pushl $0
  1023f1:	6a 00                	push   $0x0
  pushl $213
  1023f3:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1023f8:	e9 64 f7 ff ff       	jmp    101b61 <__alltraps>

001023fd <vector214>:
.globl vector214
vector214:
  pushl $0
  1023fd:	6a 00                	push   $0x0
  pushl $214
  1023ff:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102404:	e9 58 f7 ff ff       	jmp    101b61 <__alltraps>

00102409 <vector215>:
.globl vector215
vector215:
  pushl $0
  102409:	6a 00                	push   $0x0
  pushl $215
  10240b:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102410:	e9 4c f7 ff ff       	jmp    101b61 <__alltraps>

00102415 <vector216>:
.globl vector216
vector216:
  pushl $0
  102415:	6a 00                	push   $0x0
  pushl $216
  102417:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10241c:	e9 40 f7 ff ff       	jmp    101b61 <__alltraps>

00102421 <vector217>:
.globl vector217
vector217:
  pushl $0
  102421:	6a 00                	push   $0x0
  pushl $217
  102423:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102428:	e9 34 f7 ff ff       	jmp    101b61 <__alltraps>

0010242d <vector218>:
.globl vector218
vector218:
  pushl $0
  10242d:	6a 00                	push   $0x0
  pushl $218
  10242f:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102434:	e9 28 f7 ff ff       	jmp    101b61 <__alltraps>

00102439 <vector219>:
.globl vector219
vector219:
  pushl $0
  102439:	6a 00                	push   $0x0
  pushl $219
  10243b:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102440:	e9 1c f7 ff ff       	jmp    101b61 <__alltraps>

00102445 <vector220>:
.globl vector220
vector220:
  pushl $0
  102445:	6a 00                	push   $0x0
  pushl $220
  102447:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10244c:	e9 10 f7 ff ff       	jmp    101b61 <__alltraps>

00102451 <vector221>:
.globl vector221
vector221:
  pushl $0
  102451:	6a 00                	push   $0x0
  pushl $221
  102453:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102458:	e9 04 f7 ff ff       	jmp    101b61 <__alltraps>

0010245d <vector222>:
.globl vector222
vector222:
  pushl $0
  10245d:	6a 00                	push   $0x0
  pushl $222
  10245f:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102464:	e9 f8 f6 ff ff       	jmp    101b61 <__alltraps>

00102469 <vector223>:
.globl vector223
vector223:
  pushl $0
  102469:	6a 00                	push   $0x0
  pushl $223
  10246b:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102470:	e9 ec f6 ff ff       	jmp    101b61 <__alltraps>

00102475 <vector224>:
.globl vector224
vector224:
  pushl $0
  102475:	6a 00                	push   $0x0
  pushl $224
  102477:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10247c:	e9 e0 f6 ff ff       	jmp    101b61 <__alltraps>

00102481 <vector225>:
.globl vector225
vector225:
  pushl $0
  102481:	6a 00                	push   $0x0
  pushl $225
  102483:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102488:	e9 d4 f6 ff ff       	jmp    101b61 <__alltraps>

0010248d <vector226>:
.globl vector226
vector226:
  pushl $0
  10248d:	6a 00                	push   $0x0
  pushl $226
  10248f:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102494:	e9 c8 f6 ff ff       	jmp    101b61 <__alltraps>

00102499 <vector227>:
.globl vector227
vector227:
  pushl $0
  102499:	6a 00                	push   $0x0
  pushl $227
  10249b:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1024a0:	e9 bc f6 ff ff       	jmp    101b61 <__alltraps>

001024a5 <vector228>:
.globl vector228
vector228:
  pushl $0
  1024a5:	6a 00                	push   $0x0
  pushl $228
  1024a7:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1024ac:	e9 b0 f6 ff ff       	jmp    101b61 <__alltraps>

001024b1 <vector229>:
.globl vector229
vector229:
  pushl $0
  1024b1:	6a 00                	push   $0x0
  pushl $229
  1024b3:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1024b8:	e9 a4 f6 ff ff       	jmp    101b61 <__alltraps>

001024bd <vector230>:
.globl vector230
vector230:
  pushl $0
  1024bd:	6a 00                	push   $0x0
  pushl $230
  1024bf:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1024c4:	e9 98 f6 ff ff       	jmp    101b61 <__alltraps>

001024c9 <vector231>:
.globl vector231
vector231:
  pushl $0
  1024c9:	6a 00                	push   $0x0
  pushl $231
  1024cb:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1024d0:	e9 8c f6 ff ff       	jmp    101b61 <__alltraps>

001024d5 <vector232>:
.globl vector232
vector232:
  pushl $0
  1024d5:	6a 00                	push   $0x0
  pushl $232
  1024d7:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1024dc:	e9 80 f6 ff ff       	jmp    101b61 <__alltraps>

001024e1 <vector233>:
.globl vector233
vector233:
  pushl $0
  1024e1:	6a 00                	push   $0x0
  pushl $233
  1024e3:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1024e8:	e9 74 f6 ff ff       	jmp    101b61 <__alltraps>

001024ed <vector234>:
.globl vector234
vector234:
  pushl $0
  1024ed:	6a 00                	push   $0x0
  pushl $234
  1024ef:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1024f4:	e9 68 f6 ff ff       	jmp    101b61 <__alltraps>

001024f9 <vector235>:
.globl vector235
vector235:
  pushl $0
  1024f9:	6a 00                	push   $0x0
  pushl $235
  1024fb:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102500:	e9 5c f6 ff ff       	jmp    101b61 <__alltraps>

00102505 <vector236>:
.globl vector236
vector236:
  pushl $0
  102505:	6a 00                	push   $0x0
  pushl $236
  102507:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  10250c:	e9 50 f6 ff ff       	jmp    101b61 <__alltraps>

00102511 <vector237>:
.globl vector237
vector237:
  pushl $0
  102511:	6a 00                	push   $0x0
  pushl $237
  102513:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102518:	e9 44 f6 ff ff       	jmp    101b61 <__alltraps>

0010251d <vector238>:
.globl vector238
vector238:
  pushl $0
  10251d:	6a 00                	push   $0x0
  pushl $238
  10251f:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102524:	e9 38 f6 ff ff       	jmp    101b61 <__alltraps>

00102529 <vector239>:
.globl vector239
vector239:
  pushl $0
  102529:	6a 00                	push   $0x0
  pushl $239
  10252b:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102530:	e9 2c f6 ff ff       	jmp    101b61 <__alltraps>

00102535 <vector240>:
.globl vector240
vector240:
  pushl $0
  102535:	6a 00                	push   $0x0
  pushl $240
  102537:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  10253c:	e9 20 f6 ff ff       	jmp    101b61 <__alltraps>

00102541 <vector241>:
.globl vector241
vector241:
  pushl $0
  102541:	6a 00                	push   $0x0
  pushl $241
  102543:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102548:	e9 14 f6 ff ff       	jmp    101b61 <__alltraps>

0010254d <vector242>:
.globl vector242
vector242:
  pushl $0
  10254d:	6a 00                	push   $0x0
  pushl $242
  10254f:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102554:	e9 08 f6 ff ff       	jmp    101b61 <__alltraps>

00102559 <vector243>:
.globl vector243
vector243:
  pushl $0
  102559:	6a 00                	push   $0x0
  pushl $243
  10255b:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102560:	e9 fc f5 ff ff       	jmp    101b61 <__alltraps>

00102565 <vector244>:
.globl vector244
vector244:
  pushl $0
  102565:	6a 00                	push   $0x0
  pushl $244
  102567:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  10256c:	e9 f0 f5 ff ff       	jmp    101b61 <__alltraps>

00102571 <vector245>:
.globl vector245
vector245:
  pushl $0
  102571:	6a 00                	push   $0x0
  pushl $245
  102573:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102578:	e9 e4 f5 ff ff       	jmp    101b61 <__alltraps>

0010257d <vector246>:
.globl vector246
vector246:
  pushl $0
  10257d:	6a 00                	push   $0x0
  pushl $246
  10257f:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102584:	e9 d8 f5 ff ff       	jmp    101b61 <__alltraps>

00102589 <vector247>:
.globl vector247
vector247:
  pushl $0
  102589:	6a 00                	push   $0x0
  pushl $247
  10258b:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102590:	e9 cc f5 ff ff       	jmp    101b61 <__alltraps>

00102595 <vector248>:
.globl vector248
vector248:
  pushl $0
  102595:	6a 00                	push   $0x0
  pushl $248
  102597:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  10259c:	e9 c0 f5 ff ff       	jmp    101b61 <__alltraps>

001025a1 <vector249>:
.globl vector249
vector249:
  pushl $0
  1025a1:	6a 00                	push   $0x0
  pushl $249
  1025a3:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1025a8:	e9 b4 f5 ff ff       	jmp    101b61 <__alltraps>

001025ad <vector250>:
.globl vector250
vector250:
  pushl $0
  1025ad:	6a 00                	push   $0x0
  pushl $250
  1025af:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1025b4:	e9 a8 f5 ff ff       	jmp    101b61 <__alltraps>

001025b9 <vector251>:
.globl vector251
vector251:
  pushl $0
  1025b9:	6a 00                	push   $0x0
  pushl $251
  1025bb:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1025c0:	e9 9c f5 ff ff       	jmp    101b61 <__alltraps>

001025c5 <vector252>:
.globl vector252
vector252:
  pushl $0
  1025c5:	6a 00                	push   $0x0
  pushl $252
  1025c7:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1025cc:	e9 90 f5 ff ff       	jmp    101b61 <__alltraps>

001025d1 <vector253>:
.globl vector253
vector253:
  pushl $0
  1025d1:	6a 00                	push   $0x0
  pushl $253
  1025d3:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1025d8:	e9 84 f5 ff ff       	jmp    101b61 <__alltraps>

001025dd <vector254>:
.globl vector254
vector254:
  pushl $0
  1025dd:	6a 00                	push   $0x0
  pushl $254
  1025df:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1025e4:	e9 78 f5 ff ff       	jmp    101b61 <__alltraps>

001025e9 <vector255>:
.globl vector255
vector255:
  pushl $0
  1025e9:	6a 00                	push   $0x0
  pushl $255
  1025eb:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1025f0:	e9 6c f5 ff ff       	jmp    101b61 <__alltraps>

001025f5 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  1025f5:	55                   	push   %ebp
  1025f6:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  1025f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1025fb:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  1025fe:	b8 23 00 00 00       	mov    $0x23,%eax
  102603:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102605:	b8 23 00 00 00       	mov    $0x23,%eax
  10260a:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  10260c:	b8 10 00 00 00       	mov    $0x10,%eax
  102611:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102613:	b8 10 00 00 00       	mov    $0x10,%eax
  102618:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  10261a:	b8 10 00 00 00       	mov    $0x10,%eax
  10261f:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102621:	ea 28 26 10 00 08 00 	ljmp   $0x8,$0x102628
}
  102628:	90                   	nop
  102629:	5d                   	pop    %ebp
  10262a:	c3                   	ret    

0010262b <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  10262b:	55                   	push   %ebp
  10262c:	89 e5                	mov    %esp,%ebp
  10262e:	83 ec 10             	sub    $0x10,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102631:	b8 20 09 11 00       	mov    $0x110920,%eax
  102636:	05 00 04 00 00       	add    $0x400,%eax
  10263b:	a3 a4 08 11 00       	mov    %eax,0x1108a4
    ts.ts_ss0 = KERNEL_DS;
  102640:	66 c7 05 a8 08 11 00 	movw   $0x10,0x1108a8
  102647:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102649:	66 c7 05 08 fa 10 00 	movw   $0x68,0x10fa08
  102650:	68 00 
  102652:	b8 a0 08 11 00       	mov    $0x1108a0,%eax
  102657:	66 a3 0a fa 10 00    	mov    %ax,0x10fa0a
  10265d:	b8 a0 08 11 00       	mov    $0x1108a0,%eax
  102662:	c1 e8 10             	shr    $0x10,%eax
  102665:	a2 0c fa 10 00       	mov    %al,0x10fa0c
  10266a:	a0 0d fa 10 00       	mov    0x10fa0d,%al
  10266f:	83 e0 f0             	and    $0xfffffff0,%eax
  102672:	83 c8 09             	or     $0x9,%eax
  102675:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  10267a:	a0 0d fa 10 00       	mov    0x10fa0d,%al
  10267f:	83 c8 10             	or     $0x10,%eax
  102682:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102687:	a0 0d fa 10 00       	mov    0x10fa0d,%al
  10268c:	83 e0 9f             	and    $0xffffff9f,%eax
  10268f:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102694:	a0 0d fa 10 00       	mov    0x10fa0d,%al
  102699:	83 c8 80             	or     $0xffffff80,%eax
  10269c:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  1026a1:	a0 0e fa 10 00       	mov    0x10fa0e,%al
  1026a6:	83 e0 f0             	and    $0xfffffff0,%eax
  1026a9:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  1026ae:	a0 0e fa 10 00       	mov    0x10fa0e,%al
  1026b3:	83 e0 ef             	and    $0xffffffef,%eax
  1026b6:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  1026bb:	a0 0e fa 10 00       	mov    0x10fa0e,%al
  1026c0:	83 e0 df             	and    $0xffffffdf,%eax
  1026c3:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  1026c8:	a0 0e fa 10 00       	mov    0x10fa0e,%al
  1026cd:	83 c8 40             	or     $0x40,%eax
  1026d0:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  1026d5:	a0 0e fa 10 00       	mov    0x10fa0e,%al
  1026da:	83 e0 7f             	and    $0x7f,%eax
  1026dd:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  1026e2:	b8 a0 08 11 00       	mov    $0x1108a0,%eax
  1026e7:	c1 e8 18             	shr    $0x18,%eax
  1026ea:	a2 0f fa 10 00       	mov    %al,0x10fa0f
    gdt[SEG_TSS].sd_s = 0;
  1026ef:	a0 0d fa 10 00       	mov    0x10fa0d,%al
  1026f4:	83 e0 ef             	and    $0xffffffef,%eax
  1026f7:	a2 0d fa 10 00       	mov    %al,0x10fa0d

    // reload all segment registers
    lgdt(&gdt_pd);
  1026fc:	68 10 fa 10 00       	push   $0x10fa10
  102701:	e8 ef fe ff ff       	call   1025f5 <lgdt>
  102706:	83 c4 04             	add    $0x4,%esp
  102709:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  10270f:	66 8b 45 fe          	mov    -0x2(%ebp),%ax
  102713:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102716:	90                   	nop
  102717:	c9                   	leave  
  102718:	c3                   	ret    

00102719 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102719:	55                   	push   %ebp
  10271a:	89 e5                	mov    %esp,%ebp
    gdt_init();
  10271c:	e8 0a ff ff ff       	call   10262b <gdt_init>
}
  102721:	90                   	nop
  102722:	5d                   	pop    %ebp
  102723:	c3                   	ret    

00102724 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102724:	55                   	push   %ebp
  102725:	89 e5                	mov    %esp,%ebp
  102727:	83 ec 38             	sub    $0x38,%esp
  10272a:	8b 45 10             	mov    0x10(%ebp),%eax
  10272d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102730:	8b 45 14             	mov    0x14(%ebp),%eax
  102733:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102736:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102739:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10273c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10273f:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102742:	8b 45 18             	mov    0x18(%ebp),%eax
  102745:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102748:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10274b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10274e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102751:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102754:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102757:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10275a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10275e:	74 1c                	je     10277c <printnum+0x58>
  102760:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102763:	ba 00 00 00 00       	mov    $0x0,%edx
  102768:	f7 75 e4             	divl   -0x1c(%ebp)
  10276b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10276e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102771:	ba 00 00 00 00       	mov    $0x0,%edx
  102776:	f7 75 e4             	divl   -0x1c(%ebp)
  102779:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10277c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10277f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102782:	f7 75 e4             	divl   -0x1c(%ebp)
  102785:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102788:	89 55 dc             	mov    %edx,-0x24(%ebp)
  10278b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10278e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102791:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102794:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102797:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10279a:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  10279d:	8b 45 18             	mov    0x18(%ebp),%eax
  1027a0:	ba 00 00 00 00       	mov    $0x0,%edx
  1027a5:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1027a8:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  1027ab:	19 d1                	sbb    %edx,%ecx
  1027ad:	72 35                	jb     1027e4 <printnum+0xc0>
        printnum(putch, putdat, result, base, width - 1, padc);
  1027af:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1027b2:	48                   	dec    %eax
  1027b3:	83 ec 04             	sub    $0x4,%esp
  1027b6:	ff 75 20             	pushl  0x20(%ebp)
  1027b9:	50                   	push   %eax
  1027ba:	ff 75 18             	pushl  0x18(%ebp)
  1027bd:	ff 75 ec             	pushl  -0x14(%ebp)
  1027c0:	ff 75 e8             	pushl  -0x18(%ebp)
  1027c3:	ff 75 0c             	pushl  0xc(%ebp)
  1027c6:	ff 75 08             	pushl  0x8(%ebp)
  1027c9:	e8 56 ff ff ff       	call   102724 <printnum>
  1027ce:	83 c4 20             	add    $0x20,%esp
  1027d1:	eb 1a                	jmp    1027ed <printnum+0xc9>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1027d3:	83 ec 08             	sub    $0x8,%esp
  1027d6:	ff 75 0c             	pushl  0xc(%ebp)
  1027d9:	ff 75 20             	pushl  0x20(%ebp)
  1027dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1027df:	ff d0                	call   *%eax
  1027e1:	83 c4 10             	add    $0x10,%esp
        while (-- width > 0)
  1027e4:	ff 4d 1c             	decl   0x1c(%ebp)
  1027e7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1027eb:	7f e6                	jg     1027d3 <printnum+0xaf>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1027ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1027f0:	05 50 39 10 00       	add    $0x103950,%eax
  1027f5:	8a 00                	mov    (%eax),%al
  1027f7:	0f be c0             	movsbl %al,%eax
  1027fa:	83 ec 08             	sub    $0x8,%esp
  1027fd:	ff 75 0c             	pushl  0xc(%ebp)
  102800:	50                   	push   %eax
  102801:	8b 45 08             	mov    0x8(%ebp),%eax
  102804:	ff d0                	call   *%eax
  102806:	83 c4 10             	add    $0x10,%esp
}
  102809:	90                   	nop
  10280a:	c9                   	leave  
  10280b:	c3                   	ret    

0010280c <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  10280c:	55                   	push   %ebp
  10280d:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10280f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102813:	7e 14                	jle    102829 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102815:	8b 45 08             	mov    0x8(%ebp),%eax
  102818:	8b 00                	mov    (%eax),%eax
  10281a:	8d 48 08             	lea    0x8(%eax),%ecx
  10281d:	8b 55 08             	mov    0x8(%ebp),%edx
  102820:	89 0a                	mov    %ecx,(%edx)
  102822:	8b 50 04             	mov    0x4(%eax),%edx
  102825:	8b 00                	mov    (%eax),%eax
  102827:	eb 30                	jmp    102859 <getuint+0x4d>
    }
    else if (lflag) {
  102829:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10282d:	74 16                	je     102845 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  10282f:	8b 45 08             	mov    0x8(%ebp),%eax
  102832:	8b 00                	mov    (%eax),%eax
  102834:	8d 48 04             	lea    0x4(%eax),%ecx
  102837:	8b 55 08             	mov    0x8(%ebp),%edx
  10283a:	89 0a                	mov    %ecx,(%edx)
  10283c:	8b 00                	mov    (%eax),%eax
  10283e:	ba 00 00 00 00       	mov    $0x0,%edx
  102843:	eb 14                	jmp    102859 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102845:	8b 45 08             	mov    0x8(%ebp),%eax
  102848:	8b 00                	mov    (%eax),%eax
  10284a:	8d 48 04             	lea    0x4(%eax),%ecx
  10284d:	8b 55 08             	mov    0x8(%ebp),%edx
  102850:	89 0a                	mov    %ecx,(%edx)
  102852:	8b 00                	mov    (%eax),%eax
  102854:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102859:	5d                   	pop    %ebp
  10285a:	c3                   	ret    

0010285b <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  10285b:	55                   	push   %ebp
  10285c:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10285e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102862:	7e 14                	jle    102878 <getint+0x1d>
        return va_arg(*ap, long long);
  102864:	8b 45 08             	mov    0x8(%ebp),%eax
  102867:	8b 00                	mov    (%eax),%eax
  102869:	8d 48 08             	lea    0x8(%eax),%ecx
  10286c:	8b 55 08             	mov    0x8(%ebp),%edx
  10286f:	89 0a                	mov    %ecx,(%edx)
  102871:	8b 50 04             	mov    0x4(%eax),%edx
  102874:	8b 00                	mov    (%eax),%eax
  102876:	eb 28                	jmp    1028a0 <getint+0x45>
    }
    else if (lflag) {
  102878:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10287c:	74 12                	je     102890 <getint+0x35>
        return va_arg(*ap, long);
  10287e:	8b 45 08             	mov    0x8(%ebp),%eax
  102881:	8b 00                	mov    (%eax),%eax
  102883:	8d 48 04             	lea    0x4(%eax),%ecx
  102886:	8b 55 08             	mov    0x8(%ebp),%edx
  102889:	89 0a                	mov    %ecx,(%edx)
  10288b:	8b 00                	mov    (%eax),%eax
  10288d:	99                   	cltd   
  10288e:	eb 10                	jmp    1028a0 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102890:	8b 45 08             	mov    0x8(%ebp),%eax
  102893:	8b 00                	mov    (%eax),%eax
  102895:	8d 48 04             	lea    0x4(%eax),%ecx
  102898:	8b 55 08             	mov    0x8(%ebp),%edx
  10289b:	89 0a                	mov    %ecx,(%edx)
  10289d:	8b 00                	mov    (%eax),%eax
  10289f:	99                   	cltd   
    }
}
  1028a0:	5d                   	pop    %ebp
  1028a1:	c3                   	ret    

001028a2 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1028a2:	55                   	push   %ebp
  1028a3:	89 e5                	mov    %esp,%ebp
  1028a5:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  1028a8:	8d 45 14             	lea    0x14(%ebp),%eax
  1028ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1028ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1028b1:	50                   	push   %eax
  1028b2:	ff 75 10             	pushl  0x10(%ebp)
  1028b5:	ff 75 0c             	pushl  0xc(%ebp)
  1028b8:	ff 75 08             	pushl  0x8(%ebp)
  1028bb:	e8 06 00 00 00       	call   1028c6 <vprintfmt>
  1028c0:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  1028c3:	90                   	nop
  1028c4:	c9                   	leave  
  1028c5:	c3                   	ret    

001028c6 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1028c6:	55                   	push   %ebp
  1028c7:	89 e5                	mov    %esp,%ebp
  1028c9:	56                   	push   %esi
  1028ca:	53                   	push   %ebx
  1028cb:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1028ce:	eb 17                	jmp    1028e7 <vprintfmt+0x21>
            if (ch == '\0') {
  1028d0:	85 db                	test   %ebx,%ebx
  1028d2:	0f 84 7c 03 00 00    	je     102c54 <vprintfmt+0x38e>
                return;
            }
            putch(ch, putdat);
  1028d8:	83 ec 08             	sub    $0x8,%esp
  1028db:	ff 75 0c             	pushl  0xc(%ebp)
  1028de:	53                   	push   %ebx
  1028df:	8b 45 08             	mov    0x8(%ebp),%eax
  1028e2:	ff d0                	call   *%eax
  1028e4:	83 c4 10             	add    $0x10,%esp
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1028e7:	8b 45 10             	mov    0x10(%ebp),%eax
  1028ea:	8d 50 01             	lea    0x1(%eax),%edx
  1028ed:	89 55 10             	mov    %edx,0x10(%ebp)
  1028f0:	8a 00                	mov    (%eax),%al
  1028f2:	0f b6 d8             	movzbl %al,%ebx
  1028f5:	83 fb 25             	cmp    $0x25,%ebx
  1028f8:	75 d6                	jne    1028d0 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  1028fa:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  1028fe:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102905:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102908:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  10290b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102912:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102915:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102918:	8b 45 10             	mov    0x10(%ebp),%eax
  10291b:	8d 50 01             	lea    0x1(%eax),%edx
  10291e:	89 55 10             	mov    %edx,0x10(%ebp)
  102921:	8a 00                	mov    (%eax),%al
  102923:	0f b6 d8             	movzbl %al,%ebx
  102926:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102929:	83 f8 55             	cmp    $0x55,%eax
  10292c:	0f 87 fa 02 00 00    	ja     102c2c <vprintfmt+0x366>
  102932:	8b 04 85 74 39 10 00 	mov    0x103974(,%eax,4),%eax
  102939:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  10293b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  10293f:	eb d7                	jmp    102918 <vprintfmt+0x52>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102941:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102945:	eb d1                	jmp    102918 <vprintfmt+0x52>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102947:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  10294e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102951:	89 d0                	mov    %edx,%eax
  102953:	c1 e0 02             	shl    $0x2,%eax
  102956:	01 d0                	add    %edx,%eax
  102958:	01 c0                	add    %eax,%eax
  10295a:	01 d8                	add    %ebx,%eax
  10295c:	83 e8 30             	sub    $0x30,%eax
  10295f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102962:	8b 45 10             	mov    0x10(%ebp),%eax
  102965:	8a 00                	mov    (%eax),%al
  102967:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  10296a:	83 fb 2f             	cmp    $0x2f,%ebx
  10296d:	7e 35                	jle    1029a4 <vprintfmt+0xde>
  10296f:	83 fb 39             	cmp    $0x39,%ebx
  102972:	7f 30                	jg     1029a4 <vprintfmt+0xde>
            for (precision = 0; ; ++ fmt) {
  102974:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  102977:	eb d5                	jmp    10294e <vprintfmt+0x88>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  102979:	8b 45 14             	mov    0x14(%ebp),%eax
  10297c:	8d 50 04             	lea    0x4(%eax),%edx
  10297f:	89 55 14             	mov    %edx,0x14(%ebp)
  102982:	8b 00                	mov    (%eax),%eax
  102984:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102987:	eb 1c                	jmp    1029a5 <vprintfmt+0xdf>

        case '.':
            if (width < 0)
  102989:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10298d:	79 89                	jns    102918 <vprintfmt+0x52>
                width = 0;
  10298f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102996:	eb 80                	jmp    102918 <vprintfmt+0x52>

        case '#':
            altflag = 1;
  102998:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  10299f:	e9 74 ff ff ff       	jmp    102918 <vprintfmt+0x52>
            goto process_precision;
  1029a4:	90                   	nop

        process_precision:
            if (width < 0)
  1029a5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1029a9:	0f 89 69 ff ff ff    	jns    102918 <vprintfmt+0x52>
                width = precision, precision = -1;
  1029af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1029b2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1029b5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1029bc:	e9 57 ff ff ff       	jmp    102918 <vprintfmt+0x52>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1029c1:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  1029c4:	e9 4f ff ff ff       	jmp    102918 <vprintfmt+0x52>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1029c9:	8b 45 14             	mov    0x14(%ebp),%eax
  1029cc:	8d 50 04             	lea    0x4(%eax),%edx
  1029cf:	89 55 14             	mov    %edx,0x14(%ebp)
  1029d2:	8b 00                	mov    (%eax),%eax
  1029d4:	83 ec 08             	sub    $0x8,%esp
  1029d7:	ff 75 0c             	pushl  0xc(%ebp)
  1029da:	50                   	push   %eax
  1029db:	8b 45 08             	mov    0x8(%ebp),%eax
  1029de:	ff d0                	call   *%eax
  1029e0:	83 c4 10             	add    $0x10,%esp
            break;
  1029e3:	e9 67 02 00 00       	jmp    102c4f <vprintfmt+0x389>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1029e8:	8b 45 14             	mov    0x14(%ebp),%eax
  1029eb:	8d 50 04             	lea    0x4(%eax),%edx
  1029ee:	89 55 14             	mov    %edx,0x14(%ebp)
  1029f1:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1029f3:	85 db                	test   %ebx,%ebx
  1029f5:	79 02                	jns    1029f9 <vprintfmt+0x133>
                err = -err;
  1029f7:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1029f9:	83 fb 06             	cmp    $0x6,%ebx
  1029fc:	7f 0b                	jg     102a09 <vprintfmt+0x143>
  1029fe:	8b 34 9d 34 39 10 00 	mov    0x103934(,%ebx,4),%esi
  102a05:	85 f6                	test   %esi,%esi
  102a07:	75 19                	jne    102a22 <vprintfmt+0x15c>
                printfmt(putch, putdat, "error %d", err);
  102a09:	53                   	push   %ebx
  102a0a:	68 61 39 10 00       	push   $0x103961
  102a0f:	ff 75 0c             	pushl  0xc(%ebp)
  102a12:	ff 75 08             	pushl  0x8(%ebp)
  102a15:	e8 88 fe ff ff       	call   1028a2 <printfmt>
  102a1a:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102a1d:	e9 2d 02 00 00       	jmp    102c4f <vprintfmt+0x389>
                printfmt(putch, putdat, "%s", p);
  102a22:	56                   	push   %esi
  102a23:	68 6a 39 10 00       	push   $0x10396a
  102a28:	ff 75 0c             	pushl  0xc(%ebp)
  102a2b:	ff 75 08             	pushl  0x8(%ebp)
  102a2e:	e8 6f fe ff ff       	call   1028a2 <printfmt>
  102a33:	83 c4 10             	add    $0x10,%esp
            break;
  102a36:	e9 14 02 00 00       	jmp    102c4f <vprintfmt+0x389>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102a3b:	8b 45 14             	mov    0x14(%ebp),%eax
  102a3e:	8d 50 04             	lea    0x4(%eax),%edx
  102a41:	89 55 14             	mov    %edx,0x14(%ebp)
  102a44:	8b 30                	mov    (%eax),%esi
  102a46:	85 f6                	test   %esi,%esi
  102a48:	75 05                	jne    102a4f <vprintfmt+0x189>
                p = "(null)";
  102a4a:	be 6d 39 10 00       	mov    $0x10396d,%esi
            }
            if (width > 0 && padc != '-') {
  102a4f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102a53:	7e 74                	jle    102ac9 <vprintfmt+0x203>
  102a55:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102a59:	74 6e                	je     102ac9 <vprintfmt+0x203>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102a5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102a5e:	83 ec 08             	sub    $0x8,%esp
  102a61:	50                   	push   %eax
  102a62:	56                   	push   %esi
  102a63:	e8 d3 02 00 00       	call   102d3b <strnlen>
  102a68:	83 c4 10             	add    $0x10,%esp
  102a6b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102a6e:	29 c2                	sub    %eax,%edx
  102a70:	89 d0                	mov    %edx,%eax
  102a72:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102a75:	eb 16                	jmp    102a8d <vprintfmt+0x1c7>
                    putch(padc, putdat);
  102a77:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102a7b:	83 ec 08             	sub    $0x8,%esp
  102a7e:	ff 75 0c             	pushl  0xc(%ebp)
  102a81:	50                   	push   %eax
  102a82:	8b 45 08             	mov    0x8(%ebp),%eax
  102a85:	ff d0                	call   *%eax
  102a87:	83 c4 10             	add    $0x10,%esp
                for (width -= strnlen(p, precision); width > 0; width --) {
  102a8a:	ff 4d e8             	decl   -0x18(%ebp)
  102a8d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102a91:	7f e4                	jg     102a77 <vprintfmt+0x1b1>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102a93:	eb 34                	jmp    102ac9 <vprintfmt+0x203>
                if (altflag && (ch < ' ' || ch > '~')) {
  102a95:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102a99:	74 1c                	je     102ab7 <vprintfmt+0x1f1>
  102a9b:	83 fb 1f             	cmp    $0x1f,%ebx
  102a9e:	7e 05                	jle    102aa5 <vprintfmt+0x1df>
  102aa0:	83 fb 7e             	cmp    $0x7e,%ebx
  102aa3:	7e 12                	jle    102ab7 <vprintfmt+0x1f1>
                    putch('?', putdat);
  102aa5:	83 ec 08             	sub    $0x8,%esp
  102aa8:	ff 75 0c             	pushl  0xc(%ebp)
  102aab:	6a 3f                	push   $0x3f
  102aad:	8b 45 08             	mov    0x8(%ebp),%eax
  102ab0:	ff d0                	call   *%eax
  102ab2:	83 c4 10             	add    $0x10,%esp
  102ab5:	eb 0f                	jmp    102ac6 <vprintfmt+0x200>
                }
                else {
                    putch(ch, putdat);
  102ab7:	83 ec 08             	sub    $0x8,%esp
  102aba:	ff 75 0c             	pushl  0xc(%ebp)
  102abd:	53                   	push   %ebx
  102abe:	8b 45 08             	mov    0x8(%ebp),%eax
  102ac1:	ff d0                	call   *%eax
  102ac3:	83 c4 10             	add    $0x10,%esp
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102ac6:	ff 4d e8             	decl   -0x18(%ebp)
  102ac9:	89 f0                	mov    %esi,%eax
  102acb:	8d 70 01             	lea    0x1(%eax),%esi
  102ace:	8a 00                	mov    (%eax),%al
  102ad0:	0f be d8             	movsbl %al,%ebx
  102ad3:	85 db                	test   %ebx,%ebx
  102ad5:	74 24                	je     102afb <vprintfmt+0x235>
  102ad7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102adb:	78 b8                	js     102a95 <vprintfmt+0x1cf>
  102add:	ff 4d e4             	decl   -0x1c(%ebp)
  102ae0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102ae4:	79 af                	jns    102a95 <vprintfmt+0x1cf>
                }
            }
            for (; width > 0; width --) {
  102ae6:	eb 13                	jmp    102afb <vprintfmt+0x235>
                putch(' ', putdat);
  102ae8:	83 ec 08             	sub    $0x8,%esp
  102aeb:	ff 75 0c             	pushl  0xc(%ebp)
  102aee:	6a 20                	push   $0x20
  102af0:	8b 45 08             	mov    0x8(%ebp),%eax
  102af3:	ff d0                	call   *%eax
  102af5:	83 c4 10             	add    $0x10,%esp
            for (; width > 0; width --) {
  102af8:	ff 4d e8             	decl   -0x18(%ebp)
  102afb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102aff:	7f e7                	jg     102ae8 <vprintfmt+0x222>
            }
            break;
  102b01:	e9 49 01 00 00       	jmp    102c4f <vprintfmt+0x389>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102b06:	83 ec 08             	sub    $0x8,%esp
  102b09:	ff 75 e0             	pushl  -0x20(%ebp)
  102b0c:	8d 45 14             	lea    0x14(%ebp),%eax
  102b0f:	50                   	push   %eax
  102b10:	e8 46 fd ff ff       	call   10285b <getint>
  102b15:	83 c4 10             	add    $0x10,%esp
  102b18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102b1b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102b1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102b24:	85 d2                	test   %edx,%edx
  102b26:	79 23                	jns    102b4b <vprintfmt+0x285>
                putch('-', putdat);
  102b28:	83 ec 08             	sub    $0x8,%esp
  102b2b:	ff 75 0c             	pushl  0xc(%ebp)
  102b2e:	6a 2d                	push   $0x2d
  102b30:	8b 45 08             	mov    0x8(%ebp),%eax
  102b33:	ff d0                	call   *%eax
  102b35:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  102b38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102b3e:	f7 d8                	neg    %eax
  102b40:	83 d2 00             	adc    $0x0,%edx
  102b43:	f7 da                	neg    %edx
  102b45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102b48:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102b4b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102b52:	e9 9f 00 00 00       	jmp    102bf6 <vprintfmt+0x330>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102b57:	83 ec 08             	sub    $0x8,%esp
  102b5a:	ff 75 e0             	pushl  -0x20(%ebp)
  102b5d:	8d 45 14             	lea    0x14(%ebp),%eax
  102b60:	50                   	push   %eax
  102b61:	e8 a6 fc ff ff       	call   10280c <getuint>
  102b66:	83 c4 10             	add    $0x10,%esp
  102b69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102b6c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102b6f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102b76:	eb 7e                	jmp    102bf6 <vprintfmt+0x330>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102b78:	83 ec 08             	sub    $0x8,%esp
  102b7b:	ff 75 e0             	pushl  -0x20(%ebp)
  102b7e:	8d 45 14             	lea    0x14(%ebp),%eax
  102b81:	50                   	push   %eax
  102b82:	e8 85 fc ff ff       	call   10280c <getuint>
  102b87:	83 c4 10             	add    $0x10,%esp
  102b8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102b8d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102b90:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102b97:	eb 5d                	jmp    102bf6 <vprintfmt+0x330>

        // pointer
        case 'p':
            putch('0', putdat);
  102b99:	83 ec 08             	sub    $0x8,%esp
  102b9c:	ff 75 0c             	pushl  0xc(%ebp)
  102b9f:	6a 30                	push   $0x30
  102ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  102ba4:	ff d0                	call   *%eax
  102ba6:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  102ba9:	83 ec 08             	sub    $0x8,%esp
  102bac:	ff 75 0c             	pushl  0xc(%ebp)
  102baf:	6a 78                	push   $0x78
  102bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  102bb4:	ff d0                	call   *%eax
  102bb6:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102bb9:	8b 45 14             	mov    0x14(%ebp),%eax
  102bbc:	8d 50 04             	lea    0x4(%eax),%edx
  102bbf:	89 55 14             	mov    %edx,0x14(%ebp)
  102bc2:	8b 00                	mov    (%eax),%eax
  102bc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102bc7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102bce:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  102bd5:	eb 1f                	jmp    102bf6 <vprintfmt+0x330>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  102bd7:	83 ec 08             	sub    $0x8,%esp
  102bda:	ff 75 e0             	pushl  -0x20(%ebp)
  102bdd:	8d 45 14             	lea    0x14(%ebp),%eax
  102be0:	50                   	push   %eax
  102be1:	e8 26 fc ff ff       	call   10280c <getuint>
  102be6:	83 c4 10             	add    $0x10,%esp
  102be9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102bec:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  102bef:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  102bf6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  102bfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102bfd:	83 ec 04             	sub    $0x4,%esp
  102c00:	52                   	push   %edx
  102c01:	ff 75 e8             	pushl  -0x18(%ebp)
  102c04:	50                   	push   %eax
  102c05:	ff 75 f4             	pushl  -0xc(%ebp)
  102c08:	ff 75 f0             	pushl  -0x10(%ebp)
  102c0b:	ff 75 0c             	pushl  0xc(%ebp)
  102c0e:	ff 75 08             	pushl  0x8(%ebp)
  102c11:	e8 0e fb ff ff       	call   102724 <printnum>
  102c16:	83 c4 20             	add    $0x20,%esp
            break;
  102c19:	eb 34                	jmp    102c4f <vprintfmt+0x389>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  102c1b:	83 ec 08             	sub    $0x8,%esp
  102c1e:	ff 75 0c             	pushl  0xc(%ebp)
  102c21:	53                   	push   %ebx
  102c22:	8b 45 08             	mov    0x8(%ebp),%eax
  102c25:	ff d0                	call   *%eax
  102c27:	83 c4 10             	add    $0x10,%esp
            break;
  102c2a:	eb 23                	jmp    102c4f <vprintfmt+0x389>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  102c2c:	83 ec 08             	sub    $0x8,%esp
  102c2f:	ff 75 0c             	pushl  0xc(%ebp)
  102c32:	6a 25                	push   $0x25
  102c34:	8b 45 08             	mov    0x8(%ebp),%eax
  102c37:	ff d0                	call   *%eax
  102c39:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  102c3c:	ff 4d 10             	decl   0x10(%ebp)
  102c3f:	eb 03                	jmp    102c44 <vprintfmt+0x37e>
  102c41:	ff 4d 10             	decl   0x10(%ebp)
  102c44:	8b 45 10             	mov    0x10(%ebp),%eax
  102c47:	48                   	dec    %eax
  102c48:	8a 00                	mov    (%eax),%al
  102c4a:	3c 25                	cmp    $0x25,%al
  102c4c:	75 f3                	jne    102c41 <vprintfmt+0x37b>
                /* do nothing */;
            break;
  102c4e:	90                   	nop
    while (1) {
  102c4f:	e9 7a fc ff ff       	jmp    1028ce <vprintfmt+0x8>
                return;
  102c54:	90                   	nop
        }
    }
}
  102c55:	8d 65 f8             	lea    -0x8(%ebp),%esp
  102c58:	5b                   	pop    %ebx
  102c59:	5e                   	pop    %esi
  102c5a:	5d                   	pop    %ebp
  102c5b:	c3                   	ret    

00102c5c <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  102c5c:	55                   	push   %ebp
  102c5d:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  102c5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c62:	8b 40 08             	mov    0x8(%eax),%eax
  102c65:	8d 50 01             	lea    0x1(%eax),%edx
  102c68:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c6b:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  102c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c71:	8b 10                	mov    (%eax),%edx
  102c73:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c76:	8b 40 04             	mov    0x4(%eax),%eax
  102c79:	39 c2                	cmp    %eax,%edx
  102c7b:	73 12                	jae    102c8f <sprintputch+0x33>
        *b->buf ++ = ch;
  102c7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c80:	8b 00                	mov    (%eax),%eax
  102c82:	8d 48 01             	lea    0x1(%eax),%ecx
  102c85:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c88:	89 0a                	mov    %ecx,(%edx)
  102c8a:	8b 55 08             	mov    0x8(%ebp),%edx
  102c8d:	88 10                	mov    %dl,(%eax)
    }
}
  102c8f:	90                   	nop
  102c90:	5d                   	pop    %ebp
  102c91:	c3                   	ret    

00102c92 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  102c92:	55                   	push   %ebp
  102c93:	89 e5                	mov    %esp,%ebp
  102c95:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  102c98:	8d 45 14             	lea    0x14(%ebp),%eax
  102c9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  102c9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ca1:	50                   	push   %eax
  102ca2:	ff 75 10             	pushl  0x10(%ebp)
  102ca5:	ff 75 0c             	pushl  0xc(%ebp)
  102ca8:	ff 75 08             	pushl  0x8(%ebp)
  102cab:	e8 0b 00 00 00       	call   102cbb <vsnprintf>
  102cb0:	83 c4 10             	add    $0x10,%esp
  102cb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  102cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102cb9:	c9                   	leave  
  102cba:	c3                   	ret    

00102cbb <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  102cbb:	55                   	push   %ebp
  102cbc:	89 e5                	mov    %esp,%ebp
  102cbe:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  102cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  102cc4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102cc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cca:	8d 50 ff             	lea    -0x1(%eax),%edx
  102ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  102cd0:	01 d0                	add    %edx,%eax
  102cd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102cd5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  102cdc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102ce0:	74 0a                	je     102cec <vsnprintf+0x31>
  102ce2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102ce5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ce8:	39 c2                	cmp    %eax,%edx
  102cea:	76 07                	jbe    102cf3 <vsnprintf+0x38>
        return -E_INVAL;
  102cec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  102cf1:	eb 20                	jmp    102d13 <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  102cf3:	ff 75 14             	pushl  0x14(%ebp)
  102cf6:	ff 75 10             	pushl  0x10(%ebp)
  102cf9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  102cfc:	50                   	push   %eax
  102cfd:	68 5c 2c 10 00       	push   $0x102c5c
  102d02:	e8 bf fb ff ff       	call   1028c6 <vprintfmt>
  102d07:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  102d0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d0d:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  102d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102d13:	c9                   	leave  
  102d14:	c3                   	ret    

00102d15 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102d15:	55                   	push   %ebp
  102d16:	89 e5                	mov    %esp,%ebp
  102d18:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102d1b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102d22:	eb 03                	jmp    102d27 <strlen+0x12>
        cnt ++;
  102d24:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  102d27:	8b 45 08             	mov    0x8(%ebp),%eax
  102d2a:	8d 50 01             	lea    0x1(%eax),%edx
  102d2d:	89 55 08             	mov    %edx,0x8(%ebp)
  102d30:	8a 00                	mov    (%eax),%al
  102d32:	84 c0                	test   %al,%al
  102d34:	75 ee                	jne    102d24 <strlen+0xf>
    }
    return cnt;
  102d36:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102d39:	c9                   	leave  
  102d3a:	c3                   	ret    

00102d3b <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102d3b:	55                   	push   %ebp
  102d3c:	89 e5                	mov    %esp,%ebp
  102d3e:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102d41:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102d48:	eb 03                	jmp    102d4d <strnlen+0x12>
        cnt ++;
  102d4a:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102d4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102d50:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102d53:	73 0f                	jae    102d64 <strnlen+0x29>
  102d55:	8b 45 08             	mov    0x8(%ebp),%eax
  102d58:	8d 50 01             	lea    0x1(%eax),%edx
  102d5b:	89 55 08             	mov    %edx,0x8(%ebp)
  102d5e:	8a 00                	mov    (%eax),%al
  102d60:	84 c0                	test   %al,%al
  102d62:	75 e6                	jne    102d4a <strnlen+0xf>
    }
    return cnt;
  102d64:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102d67:	c9                   	leave  
  102d68:	c3                   	ret    

00102d69 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102d69:	55                   	push   %ebp
  102d6a:	89 e5                	mov    %esp,%ebp
  102d6c:	57                   	push   %edi
  102d6d:	56                   	push   %esi
  102d6e:	83 ec 20             	sub    $0x20,%esp
  102d71:	8b 45 08             	mov    0x8(%ebp),%eax
  102d74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d77:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102d7d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d83:	89 d1                	mov    %edx,%ecx
  102d85:	89 c2                	mov    %eax,%edx
  102d87:	89 ce                	mov    %ecx,%esi
  102d89:	89 d7                	mov    %edx,%edi
  102d8b:	ac                   	lods   %ds:(%esi),%al
  102d8c:	aa                   	stos   %al,%es:(%edi)
  102d8d:	84 c0                	test   %al,%al
  102d8f:	75 fa                	jne    102d8b <strcpy+0x22>
  102d91:	89 fa                	mov    %edi,%edx
  102d93:	89 f1                	mov    %esi,%ecx
  102d95:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102d98:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102d9b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  102da1:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102da2:	83 c4 20             	add    $0x20,%esp
  102da5:	5e                   	pop    %esi
  102da6:	5f                   	pop    %edi
  102da7:	5d                   	pop    %ebp
  102da8:	c3                   	ret    

00102da9 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102da9:	55                   	push   %ebp
  102daa:	89 e5                	mov    %esp,%ebp
  102dac:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102daf:	8b 45 08             	mov    0x8(%ebp),%eax
  102db2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102db5:	eb 1c                	jmp    102dd3 <strncpy+0x2a>
        if ((*p = *src) != '\0') {
  102db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dba:	8a 10                	mov    (%eax),%dl
  102dbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102dbf:	88 10                	mov    %dl,(%eax)
  102dc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102dc4:	8a 00                	mov    (%eax),%al
  102dc6:	84 c0                	test   %al,%al
  102dc8:	74 03                	je     102dcd <strncpy+0x24>
            src ++;
  102dca:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  102dcd:	ff 45 fc             	incl   -0x4(%ebp)
  102dd0:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  102dd3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102dd7:	75 de                	jne    102db7 <strncpy+0xe>
    }
    return dst;
  102dd9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102ddc:	c9                   	leave  
  102ddd:	c3                   	ret    

00102dde <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102dde:	55                   	push   %ebp
  102ddf:	89 e5                	mov    %esp,%ebp
  102de1:	57                   	push   %edi
  102de2:	56                   	push   %esi
  102de3:	83 ec 20             	sub    $0x20,%esp
  102de6:	8b 45 08             	mov    0x8(%ebp),%eax
  102de9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102dec:	8b 45 0c             	mov    0xc(%ebp),%eax
  102def:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  102df2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102df5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102df8:	89 d1                	mov    %edx,%ecx
  102dfa:	89 c2                	mov    %eax,%edx
  102dfc:	89 ce                	mov    %ecx,%esi
  102dfe:	89 d7                	mov    %edx,%edi
  102e00:	ac                   	lods   %ds:(%esi),%al
  102e01:	ae                   	scas   %es:(%edi),%al
  102e02:	75 08                	jne    102e0c <strcmp+0x2e>
  102e04:	84 c0                	test   %al,%al
  102e06:	75 f8                	jne    102e00 <strcmp+0x22>
  102e08:	31 c0                	xor    %eax,%eax
  102e0a:	eb 04                	jmp    102e10 <strcmp+0x32>
  102e0c:	19 c0                	sbb    %eax,%eax
  102e0e:	0c 01                	or     $0x1,%al
  102e10:	89 fa                	mov    %edi,%edx
  102e12:	89 f1                	mov    %esi,%ecx
  102e14:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102e17:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102e1a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  102e1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  102e20:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102e21:	83 c4 20             	add    $0x20,%esp
  102e24:	5e                   	pop    %esi
  102e25:	5f                   	pop    %edi
  102e26:	5d                   	pop    %ebp
  102e27:	c3                   	ret    

00102e28 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102e28:	55                   	push   %ebp
  102e29:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102e2b:	eb 09                	jmp    102e36 <strncmp+0xe>
        n --, s1 ++, s2 ++;
  102e2d:	ff 4d 10             	decl   0x10(%ebp)
  102e30:	ff 45 08             	incl   0x8(%ebp)
  102e33:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102e36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e3a:	74 17                	je     102e53 <strncmp+0x2b>
  102e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  102e3f:	8a 00                	mov    (%eax),%al
  102e41:	84 c0                	test   %al,%al
  102e43:	74 0e                	je     102e53 <strncmp+0x2b>
  102e45:	8b 45 08             	mov    0x8(%ebp),%eax
  102e48:	8a 10                	mov    (%eax),%dl
  102e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e4d:	8a 00                	mov    (%eax),%al
  102e4f:	38 c2                	cmp    %al,%dl
  102e51:	74 da                	je     102e2d <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102e53:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e57:	74 16                	je     102e6f <strncmp+0x47>
  102e59:	8b 45 08             	mov    0x8(%ebp),%eax
  102e5c:	8a 00                	mov    (%eax),%al
  102e5e:	0f b6 d0             	movzbl %al,%edx
  102e61:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e64:	8a 00                	mov    (%eax),%al
  102e66:	0f b6 c0             	movzbl %al,%eax
  102e69:	29 c2                	sub    %eax,%edx
  102e6b:	89 d0                	mov    %edx,%eax
  102e6d:	eb 05                	jmp    102e74 <strncmp+0x4c>
  102e6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102e74:	5d                   	pop    %ebp
  102e75:	c3                   	ret    

00102e76 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102e76:	55                   	push   %ebp
  102e77:	89 e5                	mov    %esp,%ebp
  102e79:	83 ec 04             	sub    $0x4,%esp
  102e7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e7f:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102e82:	eb 12                	jmp    102e96 <strchr+0x20>
        if (*s == c) {
  102e84:	8b 45 08             	mov    0x8(%ebp),%eax
  102e87:	8a 00                	mov    (%eax),%al
  102e89:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102e8c:	75 05                	jne    102e93 <strchr+0x1d>
            return (char *)s;
  102e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  102e91:	eb 11                	jmp    102ea4 <strchr+0x2e>
        }
        s ++;
  102e93:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102e96:	8b 45 08             	mov    0x8(%ebp),%eax
  102e99:	8a 00                	mov    (%eax),%al
  102e9b:	84 c0                	test   %al,%al
  102e9d:	75 e5                	jne    102e84 <strchr+0xe>
    }
    return NULL;
  102e9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102ea4:	c9                   	leave  
  102ea5:	c3                   	ret    

00102ea6 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102ea6:	55                   	push   %ebp
  102ea7:	89 e5                	mov    %esp,%ebp
  102ea9:	83 ec 04             	sub    $0x4,%esp
  102eac:	8b 45 0c             	mov    0xc(%ebp),%eax
  102eaf:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102eb2:	eb 0d                	jmp    102ec1 <strfind+0x1b>
        if (*s == c) {
  102eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  102eb7:	8a 00                	mov    (%eax),%al
  102eb9:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102ebc:	74 0e                	je     102ecc <strfind+0x26>
            break;
        }
        s ++;
  102ebe:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  102ec4:	8a 00                	mov    (%eax),%al
  102ec6:	84 c0                	test   %al,%al
  102ec8:	75 ea                	jne    102eb4 <strfind+0xe>
  102eca:	eb 01                	jmp    102ecd <strfind+0x27>
            break;
  102ecc:	90                   	nop
    }
    return (char *)s;
  102ecd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102ed0:	c9                   	leave  
  102ed1:	c3                   	ret    

00102ed2 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102ed2:	55                   	push   %ebp
  102ed3:	89 e5                	mov    %esp,%ebp
  102ed5:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102ed8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102edf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102ee6:	eb 03                	jmp    102eeb <strtol+0x19>
        s ++;
  102ee8:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  102eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  102eee:	8a 00                	mov    (%eax),%al
  102ef0:	3c 20                	cmp    $0x20,%al
  102ef2:	74 f4                	je     102ee8 <strtol+0x16>
  102ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ef7:	8a 00                	mov    (%eax),%al
  102ef9:	3c 09                	cmp    $0x9,%al
  102efb:	74 eb                	je     102ee8 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  102efd:	8b 45 08             	mov    0x8(%ebp),%eax
  102f00:	8a 00                	mov    (%eax),%al
  102f02:	3c 2b                	cmp    $0x2b,%al
  102f04:	75 05                	jne    102f0b <strtol+0x39>
        s ++;
  102f06:	ff 45 08             	incl   0x8(%ebp)
  102f09:	eb 13                	jmp    102f1e <strtol+0x4c>
    }
    else if (*s == '-') {
  102f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  102f0e:	8a 00                	mov    (%eax),%al
  102f10:	3c 2d                	cmp    $0x2d,%al
  102f12:	75 0a                	jne    102f1e <strtol+0x4c>
        s ++, neg = 1;
  102f14:	ff 45 08             	incl   0x8(%ebp)
  102f17:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102f1e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102f22:	74 06                	je     102f2a <strtol+0x58>
  102f24:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102f28:	75 20                	jne    102f4a <strtol+0x78>
  102f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  102f2d:	8a 00                	mov    (%eax),%al
  102f2f:	3c 30                	cmp    $0x30,%al
  102f31:	75 17                	jne    102f4a <strtol+0x78>
  102f33:	8b 45 08             	mov    0x8(%ebp),%eax
  102f36:	40                   	inc    %eax
  102f37:	8a 00                	mov    (%eax),%al
  102f39:	3c 78                	cmp    $0x78,%al
  102f3b:	75 0d                	jne    102f4a <strtol+0x78>
        s += 2, base = 16;
  102f3d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102f41:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102f48:	eb 28                	jmp    102f72 <strtol+0xa0>
    }
    else if (base == 0 && s[0] == '0') {
  102f4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102f4e:	75 15                	jne    102f65 <strtol+0x93>
  102f50:	8b 45 08             	mov    0x8(%ebp),%eax
  102f53:	8a 00                	mov    (%eax),%al
  102f55:	3c 30                	cmp    $0x30,%al
  102f57:	75 0c                	jne    102f65 <strtol+0x93>
        s ++, base = 8;
  102f59:	ff 45 08             	incl   0x8(%ebp)
  102f5c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102f63:	eb 0d                	jmp    102f72 <strtol+0xa0>
    }
    else if (base == 0) {
  102f65:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102f69:	75 07                	jne    102f72 <strtol+0xa0>
        base = 10;
  102f6b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102f72:	8b 45 08             	mov    0x8(%ebp),%eax
  102f75:	8a 00                	mov    (%eax),%al
  102f77:	3c 2f                	cmp    $0x2f,%al
  102f79:	7e 19                	jle    102f94 <strtol+0xc2>
  102f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  102f7e:	8a 00                	mov    (%eax),%al
  102f80:	3c 39                	cmp    $0x39,%al
  102f82:	7f 10                	jg     102f94 <strtol+0xc2>
            dig = *s - '0';
  102f84:	8b 45 08             	mov    0x8(%ebp),%eax
  102f87:	8a 00                	mov    (%eax),%al
  102f89:	0f be c0             	movsbl %al,%eax
  102f8c:	83 e8 30             	sub    $0x30,%eax
  102f8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f92:	eb 42                	jmp    102fd6 <strtol+0x104>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102f94:	8b 45 08             	mov    0x8(%ebp),%eax
  102f97:	8a 00                	mov    (%eax),%al
  102f99:	3c 60                	cmp    $0x60,%al
  102f9b:	7e 19                	jle    102fb6 <strtol+0xe4>
  102f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  102fa0:	8a 00                	mov    (%eax),%al
  102fa2:	3c 7a                	cmp    $0x7a,%al
  102fa4:	7f 10                	jg     102fb6 <strtol+0xe4>
            dig = *s - 'a' + 10;
  102fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  102fa9:	8a 00                	mov    (%eax),%al
  102fab:	0f be c0             	movsbl %al,%eax
  102fae:	83 e8 57             	sub    $0x57,%eax
  102fb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102fb4:	eb 20                	jmp    102fd6 <strtol+0x104>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  102fb9:	8a 00                	mov    (%eax),%al
  102fbb:	3c 40                	cmp    $0x40,%al
  102fbd:	7e 39                	jle    102ff8 <strtol+0x126>
  102fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  102fc2:	8a 00                	mov    (%eax),%al
  102fc4:	3c 5a                	cmp    $0x5a,%al
  102fc6:	7f 30                	jg     102ff8 <strtol+0x126>
            dig = *s - 'A' + 10;
  102fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  102fcb:	8a 00                	mov    (%eax),%al
  102fcd:	0f be c0             	movsbl %al,%eax
  102fd0:	83 e8 37             	sub    $0x37,%eax
  102fd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102fd9:	3b 45 10             	cmp    0x10(%ebp),%eax
  102fdc:	7d 19                	jge    102ff7 <strtol+0x125>
            break;
        }
        s ++, val = (val * base) + dig;
  102fde:	ff 45 08             	incl   0x8(%ebp)
  102fe1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102fe4:	0f af 45 10          	imul   0x10(%ebp),%eax
  102fe8:	89 c2                	mov    %eax,%edx
  102fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102fed:	01 d0                	add    %edx,%eax
  102fef:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  102ff2:	e9 7b ff ff ff       	jmp    102f72 <strtol+0xa0>
            break;
  102ff7:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  102ff8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102ffc:	74 08                	je     103006 <strtol+0x134>
        *endptr = (char *) s;
  102ffe:	8b 45 0c             	mov    0xc(%ebp),%eax
  103001:	8b 55 08             	mov    0x8(%ebp),%edx
  103004:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  103006:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  10300a:	74 07                	je     103013 <strtol+0x141>
  10300c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10300f:	f7 d8                	neg    %eax
  103011:	eb 03                	jmp    103016 <strtol+0x144>
  103013:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  103016:	c9                   	leave  
  103017:	c3                   	ret    

00103018 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  103018:	55                   	push   %ebp
  103019:	89 e5                	mov    %esp,%ebp
  10301b:	57                   	push   %edi
  10301c:	83 ec 24             	sub    $0x24,%esp
  10301f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103022:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  103025:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  103029:	8b 55 08             	mov    0x8(%ebp),%edx
  10302c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  10302f:	88 45 f7             	mov    %al,-0x9(%ebp)
  103032:	8b 45 10             	mov    0x10(%ebp),%eax
  103035:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  103038:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  10303b:	8a 45 f7             	mov    -0x9(%ebp),%al
  10303e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  103041:	89 d7                	mov    %edx,%edi
  103043:	f3 aa                	rep stos %al,%es:(%edi)
  103045:	89 fa                	mov    %edi,%edx
  103047:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10304a:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  10304d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103050:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  103051:	83 c4 24             	add    $0x24,%esp
  103054:	5f                   	pop    %edi
  103055:	5d                   	pop    %ebp
  103056:	c3                   	ret    

00103057 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  103057:	55                   	push   %ebp
  103058:	89 e5                	mov    %esp,%ebp
  10305a:	57                   	push   %edi
  10305b:	56                   	push   %esi
  10305c:	53                   	push   %ebx
  10305d:	83 ec 30             	sub    $0x30,%esp
  103060:	8b 45 08             	mov    0x8(%ebp),%eax
  103063:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103066:	8b 45 0c             	mov    0xc(%ebp),%eax
  103069:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10306c:	8b 45 10             	mov    0x10(%ebp),%eax
  10306f:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  103072:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103075:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103078:	73 42                	jae    1030bc <memmove+0x65>
  10307a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10307d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103080:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103083:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103086:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103089:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10308c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10308f:	c1 e8 02             	shr    $0x2,%eax
  103092:	89 c1                	mov    %eax,%ecx
    asm volatile (
  103094:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103097:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10309a:	89 d7                	mov    %edx,%edi
  10309c:	89 c6                	mov    %eax,%esi
  10309e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1030a0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1030a3:	83 e1 03             	and    $0x3,%ecx
  1030a6:	74 02                	je     1030aa <memmove+0x53>
  1030a8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1030aa:	89 f0                	mov    %esi,%eax
  1030ac:	89 fa                	mov    %edi,%edx
  1030ae:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  1030b1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1030b4:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  1030b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  1030ba:	eb 36                	jmp    1030f2 <memmove+0x9b>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1030bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1030bf:	8d 50 ff             	lea    -0x1(%eax),%edx
  1030c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030c5:	01 c2                	add    %eax,%edx
  1030c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1030ca:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1030cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030d0:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  1030d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1030d6:	89 c1                	mov    %eax,%ecx
  1030d8:	89 d8                	mov    %ebx,%eax
  1030da:	89 d6                	mov    %edx,%esi
  1030dc:	89 c7                	mov    %eax,%edi
  1030de:	fd                   	std    
  1030df:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1030e1:	fc                   	cld    
  1030e2:	89 f8                	mov    %edi,%eax
  1030e4:	89 f2                	mov    %esi,%edx
  1030e6:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1030e9:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1030ec:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  1030ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1030f2:	83 c4 30             	add    $0x30,%esp
  1030f5:	5b                   	pop    %ebx
  1030f6:	5e                   	pop    %esi
  1030f7:	5f                   	pop    %edi
  1030f8:	5d                   	pop    %ebp
  1030f9:	c3                   	ret    

001030fa <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1030fa:	55                   	push   %ebp
  1030fb:	89 e5                	mov    %esp,%ebp
  1030fd:	57                   	push   %edi
  1030fe:	56                   	push   %esi
  1030ff:	83 ec 20             	sub    $0x20,%esp
  103102:	8b 45 08             	mov    0x8(%ebp),%eax
  103105:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103108:	8b 45 0c             	mov    0xc(%ebp),%eax
  10310b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10310e:	8b 45 10             	mov    0x10(%ebp),%eax
  103111:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103114:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103117:	c1 e8 02             	shr    $0x2,%eax
  10311a:	89 c1                	mov    %eax,%ecx
    asm volatile (
  10311c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10311f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103122:	89 d7                	mov    %edx,%edi
  103124:	89 c6                	mov    %eax,%esi
  103126:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103128:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  10312b:	83 e1 03             	and    $0x3,%ecx
  10312e:	74 02                	je     103132 <memcpy+0x38>
  103130:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103132:	89 f0                	mov    %esi,%eax
  103134:	89 fa                	mov    %edi,%edx
  103136:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  103139:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  10313c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  10313f:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  103142:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  103143:	83 c4 20             	add    $0x20,%esp
  103146:	5e                   	pop    %esi
  103147:	5f                   	pop    %edi
  103148:	5d                   	pop    %ebp
  103149:	c3                   	ret    

0010314a <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  10314a:	55                   	push   %ebp
  10314b:	89 e5                	mov    %esp,%ebp
  10314d:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  103150:	8b 45 08             	mov    0x8(%ebp),%eax
  103153:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  103156:	8b 45 0c             	mov    0xc(%ebp),%eax
  103159:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  10315c:	eb 2a                	jmp    103188 <memcmp+0x3e>
        if (*s1 != *s2) {
  10315e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103161:	8a 10                	mov    (%eax),%dl
  103163:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103166:	8a 00                	mov    (%eax),%al
  103168:	38 c2                	cmp    %al,%dl
  10316a:	74 16                	je     103182 <memcmp+0x38>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  10316c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10316f:	8a 00                	mov    (%eax),%al
  103171:	0f b6 d0             	movzbl %al,%edx
  103174:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103177:	8a 00                	mov    (%eax),%al
  103179:	0f b6 c0             	movzbl %al,%eax
  10317c:	29 c2                	sub    %eax,%edx
  10317e:	89 d0                	mov    %edx,%eax
  103180:	eb 18                	jmp    10319a <memcmp+0x50>
        }
        s1 ++, s2 ++;
  103182:	ff 45 fc             	incl   -0x4(%ebp)
  103185:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  103188:	8b 45 10             	mov    0x10(%ebp),%eax
  10318b:	8d 50 ff             	lea    -0x1(%eax),%edx
  10318e:	89 55 10             	mov    %edx,0x10(%ebp)
  103191:	85 c0                	test   %eax,%eax
  103193:	75 c9                	jne    10315e <memcmp+0x14>
    }
    return 0;
  103195:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10319a:	c9                   	leave  
  10319b:	c3                   	ret    
