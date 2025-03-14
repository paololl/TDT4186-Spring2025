
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	55013103          	ld	sp,1360(sp) # 8000b550 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	076000ef          	jal	8000008c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
    uint64 x;
    asm volatile("csrr %0, mhartid" : "=r"(x));
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    8000003a:	6318                	ld	a4,0(a4)
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	9732                	add	a4,a4,a2
    80000046:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00259693          	slli	a3,a1,0x2
    8000004c:	96ae                	add	a3,a3,a1
    8000004e:	068e                	slli	a3,a3,0x3
    80000050:	0000b717          	auipc	a4,0xb
    80000054:	57070713          	addi	a4,a4,1392 # 8000b5c0 <timer_scratch>
    80000058:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005c:	f310                	sd	a2,32(a4)
}

static inline void
w_mscratch(uint64 x)
{
    asm volatile("csrw mscratch, %0" : : "r"(x));
    8000005e:	34071073          	csrw	mscratch,a4
    asm volatile("csrw mtvec, %0" : : "r"(x));
    80000062:	00006797          	auipc	a5,0x6
    80000066:	40e78793          	addi	a5,a5,1038 # 80006470 <timervec>
    8000006a:	30579073          	csrw	mtvec,a5
    asm volatile("csrr %0, mstatus" : "=r"(x));
    8000006e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000072:	0087e793          	ori	a5,a5,8
    asm volatile("csrw mstatus, %0" : : "r"(x));
    80000076:	30079073          	csrw	mstatus,a5
    asm volatile("csrr %0, mie" : "=r"(x));
    8000007a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000007e:	0807e793          	ori	a5,a5,128
    asm volatile("csrw mie, %0" : : "r"(x));
    80000082:	30479073          	csrw	mie,a5
}
    80000086:	6422                	ld	s0,8(sp)
    80000088:	0141                	addi	sp,sp,16
    8000008a:	8082                	ret

000000008000008c <start>:
{
    8000008c:	1141                	addi	sp,sp,-16
    8000008e:	e406                	sd	ra,8(sp)
    80000090:	e022                	sd	s0,0(sp)
    80000092:	0800                	addi	s0,sp,16
    asm volatile("csrr %0, mstatus" : "=r"(x));
    80000094:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000098:	7779                	lui	a4,0xffffe
    8000009a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fdb9dcf>
    8000009e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a0:	6705                	lui	a4,0x1
    800000a2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a6:	8fd9                	or	a5,a5,a4
    asm volatile("csrw mstatus, %0" : : "r"(x));
    800000a8:	30079073          	csrw	mstatus,a5
    asm volatile("csrw mepc, %0" : : "r"(x));
    800000ac:	00001797          	auipc	a5,0x1
    800000b0:	08678793          	addi	a5,a5,134 # 80001132 <main>
    800000b4:	34179073          	csrw	mepc,a5
    asm volatile("csrw satp, %0" : : "r"(x));
    800000b8:	4781                	li	a5,0
    800000ba:	18079073          	csrw	satp,a5
    asm volatile("csrw medeleg, %0" : : "r"(x));
    800000be:	67c1                	lui	a5,0x10
    800000c0:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c2:	30279073          	csrw	medeleg,a5
    asm volatile("csrw mideleg, %0" : : "r"(x));
    800000c6:	30379073          	csrw	mideleg,a5
    asm volatile("csrr %0, sie" : "=r"(x));
    800000ca:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000ce:	2227e793          	ori	a5,a5,546
    asm volatile("csrw sie, %0" : : "r"(x));
    800000d2:	10479073          	csrw	sie,a5
    asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    800000d6:	57fd                	li	a5,-1
    800000d8:	83a9                	srli	a5,a5,0xa
    800000da:	3b079073          	csrw	pmpaddr0,a5
    asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    800000de:	47bd                	li	a5,15
    800000e0:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e4:	00000097          	auipc	ra,0x0
    800000e8:	f38080e7          	jalr	-200(ra) # 8000001c <timerinit>
    asm volatile("csrr %0, mhartid" : "=r"(x));
    800000ec:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f0:	2781                	sext.w	a5,a5
}

static inline void
w_tp(uint64 x)
{
    asm volatile("mv tp, %0" : : "r"(x));
    800000f2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f4:	30200073          	mret
}
    800000f8:	60a2                	ld	ra,8(sp)
    800000fa:	6402                	ld	s0,0(sp)
    800000fc:	0141                	addi	sp,sp,16
    800000fe:	8082                	ret

0000000080000100 <consolewrite>:

//
// user write()s to the console go here.
//
int consolewrite(int user_src, uint64 src, int n)
{
    80000100:	715d                	addi	sp,sp,-80
    80000102:	e486                	sd	ra,72(sp)
    80000104:	e0a2                	sd	s0,64(sp)
    80000106:	f84a                	sd	s2,48(sp)
    80000108:	0880                	addi	s0,sp,80
    int i;

    for (i = 0; i < n; i++)
    8000010a:	04c05663          	blez	a2,80000156 <consolewrite+0x56>
    8000010e:	fc26                	sd	s1,56(sp)
    80000110:	f44e                	sd	s3,40(sp)
    80000112:	f052                	sd	s4,32(sp)
    80000114:	ec56                	sd	s5,24(sp)
    80000116:	8a2a                	mv	s4,a0
    80000118:	84ae                	mv	s1,a1
    8000011a:	89b2                	mv	s3,a2
    8000011c:	4901                	li	s2,0
    {
        char c;
        if (either_copyin(&c, user_src, src + i, 1) == -1)
    8000011e:	5afd                	li	s5,-1
    80000120:	4685                	li	a3,1
    80000122:	8626                	mv	a2,s1
    80000124:	85d2                	mv	a1,s4
    80000126:	fbf40513          	addi	a0,s0,-65
    8000012a:	00003097          	auipc	ra,0x3
    8000012e:	8a0080e7          	jalr	-1888(ra) # 800029ca <either_copyin>
    80000132:	03550463          	beq	a0,s5,8000015a <consolewrite+0x5a>
            break;
        uartputc(c);
    80000136:	fbf44503          	lbu	a0,-65(s0)
    8000013a:	00000097          	auipc	ra,0x0
    8000013e:	7f6080e7          	jalr	2038(ra) # 80000930 <uartputc>
    for (i = 0; i < n; i++)
    80000142:	2905                	addiw	s2,s2,1
    80000144:	0485                	addi	s1,s1,1
    80000146:	fd299de3          	bne	s3,s2,80000120 <consolewrite+0x20>
    8000014a:	894e                	mv	s2,s3
    8000014c:	74e2                	ld	s1,56(sp)
    8000014e:	79a2                	ld	s3,40(sp)
    80000150:	7a02                	ld	s4,32(sp)
    80000152:	6ae2                	ld	s5,24(sp)
    80000154:	a039                	j	80000162 <consolewrite+0x62>
    80000156:	4901                	li	s2,0
    80000158:	a029                	j	80000162 <consolewrite+0x62>
    8000015a:	74e2                	ld	s1,56(sp)
    8000015c:	79a2                	ld	s3,40(sp)
    8000015e:	7a02                	ld	s4,32(sp)
    80000160:	6ae2                	ld	s5,24(sp)
    }

    return i;
}
    80000162:	854a                	mv	a0,s2
    80000164:	60a6                	ld	ra,72(sp)
    80000166:	6406                	ld	s0,64(sp)
    80000168:	7942                	ld	s2,48(sp)
    8000016a:	6161                	addi	sp,sp,80
    8000016c:	8082                	ret

000000008000016e <consoleread>:
// copy (up to) a whole input line to dst.
// user_dist indicates whether dst is a user
// or kernel address.
//
int consoleread(int user_dst, uint64 dst, int n)
{
    8000016e:	711d                	addi	sp,sp,-96
    80000170:	ec86                	sd	ra,88(sp)
    80000172:	e8a2                	sd	s0,80(sp)
    80000174:	e4a6                	sd	s1,72(sp)
    80000176:	e0ca                	sd	s2,64(sp)
    80000178:	fc4e                	sd	s3,56(sp)
    8000017a:	f852                	sd	s4,48(sp)
    8000017c:	f456                	sd	s5,40(sp)
    8000017e:	f05a                	sd	s6,32(sp)
    80000180:	1080                	addi	s0,sp,96
    80000182:	8aaa                	mv	s5,a0
    80000184:	8a2e                	mv	s4,a1
    80000186:	89b2                	mv	s3,a2
    uint target;
    int c;
    char cbuf;

    target = n;
    80000188:	00060b1b          	sext.w	s6,a2
    acquire(&cons.lock);
    8000018c:	00013517          	auipc	a0,0x13
    80000190:	57450513          	addi	a0,a0,1396 # 80013700 <cons>
    80000194:	00001097          	auipc	ra,0x1
    80000198:	d04080e7          	jalr	-764(ra) # 80000e98 <acquire>
    while (n > 0)
    {
        // wait until interrupt handler has put some
        // input into cons.buffer.
        while (cons.r == cons.w)
    8000019c:	00013497          	auipc	s1,0x13
    800001a0:	56448493          	addi	s1,s1,1380 # 80013700 <cons>
            if (killed(myproc()))
            {
                release(&cons.lock);
                return -1;
            }
            sleep(&cons.r, &cons.lock);
    800001a4:	00013917          	auipc	s2,0x13
    800001a8:	5f490913          	addi	s2,s2,1524 # 80013798 <cons+0x98>
    while (n > 0)
    800001ac:	0d305763          	blez	s3,8000027a <consoleread+0x10c>
        while (cons.r == cons.w)
    800001b0:	0984a783          	lw	a5,152(s1)
    800001b4:	09c4a703          	lw	a4,156(s1)
    800001b8:	0af71c63          	bne	a4,a5,80000270 <consoleread+0x102>
            if (killed(myproc()))
    800001bc:	00002097          	auipc	ra,0x2
    800001c0:	bd0080e7          	jalr	-1072(ra) # 80001d8c <myproc>
    800001c4:	00002097          	auipc	ra,0x2
    800001c8:	650080e7          	jalr	1616(ra) # 80002814 <killed>
    800001cc:	e52d                	bnez	a0,80000236 <consoleread+0xc8>
            sleep(&cons.r, &cons.lock);
    800001ce:	85a6                	mv	a1,s1
    800001d0:	854a                	mv	a0,s2
    800001d2:	00002097          	auipc	ra,0x2
    800001d6:	36c080e7          	jalr	876(ra) # 8000253e <sleep>
        while (cons.r == cons.w)
    800001da:	0984a783          	lw	a5,152(s1)
    800001de:	09c4a703          	lw	a4,156(s1)
    800001e2:	fcf70de3          	beq	a4,a5,800001bc <consoleread+0x4e>
    800001e6:	ec5e                	sd	s7,24(sp)
        }

        c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001e8:	00013717          	auipc	a4,0x13
    800001ec:	51870713          	addi	a4,a4,1304 # 80013700 <cons>
    800001f0:	0017869b          	addiw	a3,a5,1
    800001f4:	08d72c23          	sw	a3,152(a4)
    800001f8:	07f7f693          	andi	a3,a5,127
    800001fc:	9736                	add	a4,a4,a3
    800001fe:	01874703          	lbu	a4,24(a4)
    80000202:	00070b9b          	sext.w	s7,a4

        if (c == C('D'))
    80000206:	4691                	li	a3,4
    80000208:	04db8a63          	beq	s7,a3,8000025c <consoleread+0xee>
            }
            break;
        }

        // copy the input byte to the user-space buffer.
        cbuf = c;
    8000020c:	fae407a3          	sb	a4,-81(s0)
        if (either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000210:	4685                	li	a3,1
    80000212:	faf40613          	addi	a2,s0,-81
    80000216:	85d2                	mv	a1,s4
    80000218:	8556                	mv	a0,s5
    8000021a:	00002097          	auipc	ra,0x2
    8000021e:	75a080e7          	jalr	1882(ra) # 80002974 <either_copyout>
    80000222:	57fd                	li	a5,-1
    80000224:	04f50a63          	beq	a0,a5,80000278 <consoleread+0x10a>
            break;

        dst++;
    80000228:	0a05                	addi	s4,s4,1
        --n;
    8000022a:	39fd                	addiw	s3,s3,-1

        if (c == '\n')
    8000022c:	47a9                	li	a5,10
    8000022e:	06fb8163          	beq	s7,a5,80000290 <consoleread+0x122>
    80000232:	6be2                	ld	s7,24(sp)
    80000234:	bfa5                	j	800001ac <consoleread+0x3e>
                release(&cons.lock);
    80000236:	00013517          	auipc	a0,0x13
    8000023a:	4ca50513          	addi	a0,a0,1226 # 80013700 <cons>
    8000023e:	00001097          	auipc	ra,0x1
    80000242:	d0e080e7          	jalr	-754(ra) # 80000f4c <release>
                return -1;
    80000246:	557d                	li	a0,-1
        }
    }
    release(&cons.lock);

    return target - n;
}
    80000248:	60e6                	ld	ra,88(sp)
    8000024a:	6446                	ld	s0,80(sp)
    8000024c:	64a6                	ld	s1,72(sp)
    8000024e:	6906                	ld	s2,64(sp)
    80000250:	79e2                	ld	s3,56(sp)
    80000252:	7a42                	ld	s4,48(sp)
    80000254:	7aa2                	ld	s5,40(sp)
    80000256:	7b02                	ld	s6,32(sp)
    80000258:	6125                	addi	sp,sp,96
    8000025a:	8082                	ret
            if (n < target)
    8000025c:	0009871b          	sext.w	a4,s3
    80000260:	01677a63          	bgeu	a4,s6,80000274 <consoleread+0x106>
                cons.r--;
    80000264:	00013717          	auipc	a4,0x13
    80000268:	52f72a23          	sw	a5,1332(a4) # 80013798 <cons+0x98>
    8000026c:	6be2                	ld	s7,24(sp)
    8000026e:	a031                	j	8000027a <consoleread+0x10c>
    80000270:	ec5e                	sd	s7,24(sp)
    80000272:	bf9d                	j	800001e8 <consoleread+0x7a>
    80000274:	6be2                	ld	s7,24(sp)
    80000276:	a011                	j	8000027a <consoleread+0x10c>
    80000278:	6be2                	ld	s7,24(sp)
    release(&cons.lock);
    8000027a:	00013517          	auipc	a0,0x13
    8000027e:	48650513          	addi	a0,a0,1158 # 80013700 <cons>
    80000282:	00001097          	auipc	ra,0x1
    80000286:	cca080e7          	jalr	-822(ra) # 80000f4c <release>
    return target - n;
    8000028a:	413b053b          	subw	a0,s6,s3
    8000028e:	bf6d                	j	80000248 <consoleread+0xda>
    80000290:	6be2                	ld	s7,24(sp)
    80000292:	b7e5                	j	8000027a <consoleread+0x10c>

0000000080000294 <consputc>:
{
    80000294:	1141                	addi	sp,sp,-16
    80000296:	e406                	sd	ra,8(sp)
    80000298:	e022                	sd	s0,0(sp)
    8000029a:	0800                	addi	s0,sp,16
    if (c == BACKSPACE)
    8000029c:	10000793          	li	a5,256
    800002a0:	00f50a63          	beq	a0,a5,800002b4 <consputc+0x20>
        uartputc_sync(c);
    800002a4:	00000097          	auipc	ra,0x0
    800002a8:	5ae080e7          	jalr	1454(ra) # 80000852 <uartputc_sync>
}
    800002ac:	60a2                	ld	ra,8(sp)
    800002ae:	6402                	ld	s0,0(sp)
    800002b0:	0141                	addi	sp,sp,16
    800002b2:	8082                	ret
        uartputc_sync('\b');
    800002b4:	4521                	li	a0,8
    800002b6:	00000097          	auipc	ra,0x0
    800002ba:	59c080e7          	jalr	1436(ra) # 80000852 <uartputc_sync>
        uartputc_sync(' ');
    800002be:	02000513          	li	a0,32
    800002c2:	00000097          	auipc	ra,0x0
    800002c6:	590080e7          	jalr	1424(ra) # 80000852 <uartputc_sync>
        uartputc_sync('\b');
    800002ca:	4521                	li	a0,8
    800002cc:	00000097          	auipc	ra,0x0
    800002d0:	586080e7          	jalr	1414(ra) # 80000852 <uartputc_sync>
    800002d4:	bfe1                	j	800002ac <consputc+0x18>

00000000800002d6 <consoleintr>:
// uartintr() calls this for input character.
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void consoleintr(int c)
{
    800002d6:	1101                	addi	sp,sp,-32
    800002d8:	ec06                	sd	ra,24(sp)
    800002da:	e822                	sd	s0,16(sp)
    800002dc:	e426                	sd	s1,8(sp)
    800002de:	1000                	addi	s0,sp,32
    800002e0:	84aa                	mv	s1,a0
    acquire(&cons.lock);
    800002e2:	00013517          	auipc	a0,0x13
    800002e6:	41e50513          	addi	a0,a0,1054 # 80013700 <cons>
    800002ea:	00001097          	auipc	ra,0x1
    800002ee:	bae080e7          	jalr	-1106(ra) # 80000e98 <acquire>

    switch (c)
    800002f2:	47d5                	li	a5,21
    800002f4:	0af48563          	beq	s1,a5,8000039e <consoleintr+0xc8>
    800002f8:	0297c963          	blt	a5,s1,8000032a <consoleintr+0x54>
    800002fc:	47a1                	li	a5,8
    800002fe:	0ef48c63          	beq	s1,a5,800003f6 <consoleintr+0x120>
    80000302:	47c1                	li	a5,16
    80000304:	10f49f63          	bne	s1,a5,80000422 <consoleintr+0x14c>
    {
    case C('P'): // Print process list.
        procdump();
    80000308:	00002097          	auipc	ra,0x2
    8000030c:	718080e7          	jalr	1816(ra) # 80002a20 <procdump>
            }
        }
        break;
    }

    release(&cons.lock);
    80000310:	00013517          	auipc	a0,0x13
    80000314:	3f050513          	addi	a0,a0,1008 # 80013700 <cons>
    80000318:	00001097          	auipc	ra,0x1
    8000031c:	c34080e7          	jalr	-972(ra) # 80000f4c <release>
}
    80000320:	60e2                	ld	ra,24(sp)
    80000322:	6442                	ld	s0,16(sp)
    80000324:	64a2                	ld	s1,8(sp)
    80000326:	6105                	addi	sp,sp,32
    80000328:	8082                	ret
    switch (c)
    8000032a:	07f00793          	li	a5,127
    8000032e:	0cf48463          	beq	s1,a5,800003f6 <consoleintr+0x120>
        if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE)
    80000332:	00013717          	auipc	a4,0x13
    80000336:	3ce70713          	addi	a4,a4,974 # 80013700 <cons>
    8000033a:	0a072783          	lw	a5,160(a4)
    8000033e:	09872703          	lw	a4,152(a4)
    80000342:	9f99                	subw	a5,a5,a4
    80000344:	07f00713          	li	a4,127
    80000348:	fcf764e3          	bltu	a4,a5,80000310 <consoleintr+0x3a>
            c = (c == '\r') ? '\n' : c;
    8000034c:	47b5                	li	a5,13
    8000034e:	0cf48d63          	beq	s1,a5,80000428 <consoleintr+0x152>
            consputc(c);
    80000352:	8526                	mv	a0,s1
    80000354:	00000097          	auipc	ra,0x0
    80000358:	f40080e7          	jalr	-192(ra) # 80000294 <consputc>
            cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000035c:	00013797          	auipc	a5,0x13
    80000360:	3a478793          	addi	a5,a5,932 # 80013700 <cons>
    80000364:	0a07a683          	lw	a3,160(a5)
    80000368:	0016871b          	addiw	a4,a3,1
    8000036c:	0007061b          	sext.w	a2,a4
    80000370:	0ae7a023          	sw	a4,160(a5)
    80000374:	07f6f693          	andi	a3,a3,127
    80000378:	97b6                	add	a5,a5,a3
    8000037a:	00978c23          	sb	s1,24(a5)
            if (c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE)
    8000037e:	47a9                	li	a5,10
    80000380:	0cf48b63          	beq	s1,a5,80000456 <consoleintr+0x180>
    80000384:	4791                	li	a5,4
    80000386:	0cf48863          	beq	s1,a5,80000456 <consoleintr+0x180>
    8000038a:	00013797          	auipc	a5,0x13
    8000038e:	40e7a783          	lw	a5,1038(a5) # 80013798 <cons+0x98>
    80000392:	9f1d                	subw	a4,a4,a5
    80000394:	08000793          	li	a5,128
    80000398:	f6f71ce3          	bne	a4,a5,80000310 <consoleintr+0x3a>
    8000039c:	a86d                	j	80000456 <consoleintr+0x180>
    8000039e:	e04a                	sd	s2,0(sp)
        while (cons.e != cons.w &&
    800003a0:	00013717          	auipc	a4,0x13
    800003a4:	36070713          	addi	a4,a4,864 # 80013700 <cons>
    800003a8:	0a072783          	lw	a5,160(a4)
    800003ac:	09c72703          	lw	a4,156(a4)
               cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n')
    800003b0:	00013497          	auipc	s1,0x13
    800003b4:	35048493          	addi	s1,s1,848 # 80013700 <cons>
        while (cons.e != cons.w &&
    800003b8:	4929                	li	s2,10
    800003ba:	02f70a63          	beq	a4,a5,800003ee <consoleintr+0x118>
               cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n')
    800003be:	37fd                	addiw	a5,a5,-1
    800003c0:	07f7f713          	andi	a4,a5,127
    800003c4:	9726                	add	a4,a4,s1
        while (cons.e != cons.w &&
    800003c6:	01874703          	lbu	a4,24(a4)
    800003ca:	03270463          	beq	a4,s2,800003f2 <consoleintr+0x11c>
            cons.e--;
    800003ce:	0af4a023          	sw	a5,160(s1)
            consputc(BACKSPACE);
    800003d2:	10000513          	li	a0,256
    800003d6:	00000097          	auipc	ra,0x0
    800003da:	ebe080e7          	jalr	-322(ra) # 80000294 <consputc>
        while (cons.e != cons.w &&
    800003de:	0a04a783          	lw	a5,160(s1)
    800003e2:	09c4a703          	lw	a4,156(s1)
    800003e6:	fcf71ce3          	bne	a4,a5,800003be <consoleintr+0xe8>
    800003ea:	6902                	ld	s2,0(sp)
    800003ec:	b715                	j	80000310 <consoleintr+0x3a>
    800003ee:	6902                	ld	s2,0(sp)
    800003f0:	b705                	j	80000310 <consoleintr+0x3a>
    800003f2:	6902                	ld	s2,0(sp)
    800003f4:	bf31                	j	80000310 <consoleintr+0x3a>
        if (cons.e != cons.w)
    800003f6:	00013717          	auipc	a4,0x13
    800003fa:	30a70713          	addi	a4,a4,778 # 80013700 <cons>
    800003fe:	0a072783          	lw	a5,160(a4)
    80000402:	09c72703          	lw	a4,156(a4)
    80000406:	f0f705e3          	beq	a4,a5,80000310 <consoleintr+0x3a>
            cons.e--;
    8000040a:	37fd                	addiw	a5,a5,-1
    8000040c:	00013717          	auipc	a4,0x13
    80000410:	38f72a23          	sw	a5,916(a4) # 800137a0 <cons+0xa0>
            consputc(BACKSPACE);
    80000414:	10000513          	li	a0,256
    80000418:	00000097          	auipc	ra,0x0
    8000041c:	e7c080e7          	jalr	-388(ra) # 80000294 <consputc>
    80000420:	bdc5                	j	80000310 <consoleintr+0x3a>
        if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE)
    80000422:	ee0487e3          	beqz	s1,80000310 <consoleintr+0x3a>
    80000426:	b731                	j	80000332 <consoleintr+0x5c>
            consputc(c);
    80000428:	4529                	li	a0,10
    8000042a:	00000097          	auipc	ra,0x0
    8000042e:	e6a080e7          	jalr	-406(ra) # 80000294 <consputc>
            cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000432:	00013797          	auipc	a5,0x13
    80000436:	2ce78793          	addi	a5,a5,718 # 80013700 <cons>
    8000043a:	0a07a703          	lw	a4,160(a5)
    8000043e:	0017069b          	addiw	a3,a4,1
    80000442:	0006861b          	sext.w	a2,a3
    80000446:	0ad7a023          	sw	a3,160(a5)
    8000044a:	07f77713          	andi	a4,a4,127
    8000044e:	97ba                	add	a5,a5,a4
    80000450:	4729                	li	a4,10
    80000452:	00e78c23          	sb	a4,24(a5)
                cons.w = cons.e;
    80000456:	00013797          	auipc	a5,0x13
    8000045a:	34c7a323          	sw	a2,838(a5) # 8001379c <cons+0x9c>
                wakeup(&cons.r);
    8000045e:	00013517          	auipc	a0,0x13
    80000462:	33a50513          	addi	a0,a0,826 # 80013798 <cons+0x98>
    80000466:	00002097          	auipc	ra,0x2
    8000046a:	13c080e7          	jalr	316(ra) # 800025a2 <wakeup>
    8000046e:	b54d                	j	80000310 <consoleintr+0x3a>

0000000080000470 <consoleinit>:

void consoleinit(void)
{
    80000470:	1141                	addi	sp,sp,-16
    80000472:	e406                	sd	ra,8(sp)
    80000474:	e022                	sd	s0,0(sp)
    80000476:	0800                	addi	s0,sp,16
    initlock(&cons.lock, "cons");
    80000478:	00008597          	auipc	a1,0x8
    8000047c:	b9858593          	addi	a1,a1,-1128 # 80008010 <__func__.1+0x8>
    80000480:	00013517          	auipc	a0,0x13
    80000484:	28050513          	addi	a0,a0,640 # 80013700 <cons>
    80000488:	00001097          	auipc	ra,0x1
    8000048c:	980080e7          	jalr	-1664(ra) # 80000e08 <initlock>

    uartinit();
    80000490:	00000097          	auipc	ra,0x0
    80000494:	366080e7          	jalr	870(ra) # 800007f6 <uartinit>

    // connect read and write system calls
    // to consoleread and consolewrite.
    devsw[CONSOLE].read = consoleread;
    80000498:	00243797          	auipc	a5,0x243
    8000049c:	40078793          	addi	a5,a5,1024 # 80243898 <devsw>
    800004a0:	00000717          	auipc	a4,0x0
    800004a4:	cce70713          	addi	a4,a4,-818 # 8000016e <consoleread>
    800004a8:	eb98                	sd	a4,16(a5)
    devsw[CONSOLE].write = consolewrite;
    800004aa:	00000717          	auipc	a4,0x0
    800004ae:	c5670713          	addi	a4,a4,-938 # 80000100 <consolewrite>
    800004b2:	ef98                	sd	a4,24(a5)
}
    800004b4:	60a2                	ld	ra,8(sp)
    800004b6:	6402                	ld	s0,0(sp)
    800004b8:	0141                	addi	sp,sp,16
    800004ba:	8082                	ret

00000000800004bc <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004bc:	7179                	addi	sp,sp,-48
    800004be:	f406                	sd	ra,40(sp)
    800004c0:	f022                	sd	s0,32(sp)
    800004c2:	1800                	addi	s0,sp,48
    char buf[16];
    int i;
    uint x;

    if (sign && (sign = xx < 0))
    800004c4:	c219                	beqz	a2,800004ca <printint+0xe>
    800004c6:	08054963          	bltz	a0,80000558 <printint+0x9c>
        x = -xx;
    else
        x = xx;
    800004ca:	2501                	sext.w	a0,a0
    800004cc:	4881                	li	a7,0
    800004ce:	fd040693          	addi	a3,s0,-48

    i = 0;
    800004d2:	4701                	li	a4,0
    do
    {
        buf[i++] = digits[x % base];
    800004d4:	2581                	sext.w	a1,a1
    800004d6:	00008617          	auipc	a2,0x8
    800004da:	39260613          	addi	a2,a2,914 # 80008868 <digits>
    800004de:	883a                	mv	a6,a4
    800004e0:	2705                	addiw	a4,a4,1
    800004e2:	02b577bb          	remuw	a5,a0,a1
    800004e6:	1782                	slli	a5,a5,0x20
    800004e8:	9381                	srli	a5,a5,0x20
    800004ea:	97b2                	add	a5,a5,a2
    800004ec:	0007c783          	lbu	a5,0(a5)
    800004f0:	00f68023          	sb	a5,0(a3)
    } while ((x /= base) != 0);
    800004f4:	0005079b          	sext.w	a5,a0
    800004f8:	02b5553b          	divuw	a0,a0,a1
    800004fc:	0685                	addi	a3,a3,1
    800004fe:	feb7f0e3          	bgeu	a5,a1,800004de <printint+0x22>

    if (sign)
    80000502:	00088c63          	beqz	a7,8000051a <printint+0x5e>
        buf[i++] = '-';
    80000506:	fe070793          	addi	a5,a4,-32
    8000050a:	00878733          	add	a4,a5,s0
    8000050e:	02d00793          	li	a5,45
    80000512:	fef70823          	sb	a5,-16(a4)
    80000516:	0028071b          	addiw	a4,a6,2

    while (--i >= 0)
    8000051a:	02e05b63          	blez	a4,80000550 <printint+0x94>
    8000051e:	ec26                	sd	s1,24(sp)
    80000520:	e84a                	sd	s2,16(sp)
    80000522:	fd040793          	addi	a5,s0,-48
    80000526:	00e784b3          	add	s1,a5,a4
    8000052a:	fff78913          	addi	s2,a5,-1
    8000052e:	993a                	add	s2,s2,a4
    80000530:	377d                	addiw	a4,a4,-1
    80000532:	1702                	slli	a4,a4,0x20
    80000534:	9301                	srli	a4,a4,0x20
    80000536:	40e90933          	sub	s2,s2,a4
        consputc(buf[i]);
    8000053a:	fff4c503          	lbu	a0,-1(s1)
    8000053e:	00000097          	auipc	ra,0x0
    80000542:	d56080e7          	jalr	-682(ra) # 80000294 <consputc>
    while (--i >= 0)
    80000546:	14fd                	addi	s1,s1,-1
    80000548:	ff2499e3          	bne	s1,s2,8000053a <printint+0x7e>
    8000054c:	64e2                	ld	s1,24(sp)
    8000054e:	6942                	ld	s2,16(sp)
}
    80000550:	70a2                	ld	ra,40(sp)
    80000552:	7402                	ld	s0,32(sp)
    80000554:	6145                	addi	sp,sp,48
    80000556:	8082                	ret
        x = -xx;
    80000558:	40a0053b          	negw	a0,a0
    if (sign && (sign = xx < 0))
    8000055c:	4885                	li	a7,1
        x = -xx;
    8000055e:	bf85                	j	800004ce <printint+0x12>

0000000080000560 <panic>:
    if (locking)
        release(&pr.lock);
}

void panic(char *s, ...)
{
    80000560:	711d                	addi	sp,sp,-96
    80000562:	ec06                	sd	ra,24(sp)
    80000564:	e822                	sd	s0,16(sp)
    80000566:	e426                	sd	s1,8(sp)
    80000568:	1000                	addi	s0,sp,32
    8000056a:	84aa                	mv	s1,a0
    8000056c:	e40c                	sd	a1,8(s0)
    8000056e:	e810                	sd	a2,16(s0)
    80000570:	ec14                	sd	a3,24(s0)
    80000572:	f018                	sd	a4,32(s0)
    80000574:	f41c                	sd	a5,40(s0)
    80000576:	03043823          	sd	a6,48(s0)
    8000057a:	03143c23          	sd	a7,56(s0)
    pr.locking = 0;
    8000057e:	00013797          	auipc	a5,0x13
    80000582:	2407a123          	sw	zero,578(a5) # 800137c0 <pr+0x18>
    printf("panic: ");
    80000586:	00008517          	auipc	a0,0x8
    8000058a:	a9250513          	addi	a0,a0,-1390 # 80008018 <__func__.1+0x10>
    8000058e:	00000097          	auipc	ra,0x0
    80000592:	02e080e7          	jalr	46(ra) # 800005bc <printf>
    printf(s);
    80000596:	8526                	mv	a0,s1
    80000598:	00000097          	auipc	ra,0x0
    8000059c:	024080e7          	jalr	36(ra) # 800005bc <printf>
    printf("\n");
    800005a0:	00008517          	auipc	a0,0x8
    800005a4:	a8050513          	addi	a0,a0,-1408 # 80008020 <__func__.1+0x18>
    800005a8:	00000097          	auipc	ra,0x0
    800005ac:	014080e7          	jalr	20(ra) # 800005bc <printf>
    panicked = 1; // freeze uart output from other CPUs
    800005b0:	4785                	li	a5,1
    800005b2:	0000b717          	auipc	a4,0xb
    800005b6:	faf72f23          	sw	a5,-66(a4) # 8000b570 <panicked>
    for (;;)
    800005ba:	a001                	j	800005ba <panic+0x5a>

00000000800005bc <printf>:
{
    800005bc:	7131                	addi	sp,sp,-192
    800005be:	fc86                	sd	ra,120(sp)
    800005c0:	f8a2                	sd	s0,112(sp)
    800005c2:	e8d2                	sd	s4,80(sp)
    800005c4:	f06a                	sd	s10,32(sp)
    800005c6:	0100                	addi	s0,sp,128
    800005c8:	8a2a                	mv	s4,a0
    800005ca:	e40c                	sd	a1,8(s0)
    800005cc:	e810                	sd	a2,16(s0)
    800005ce:	ec14                	sd	a3,24(s0)
    800005d0:	f018                	sd	a4,32(s0)
    800005d2:	f41c                	sd	a5,40(s0)
    800005d4:	03043823          	sd	a6,48(s0)
    800005d8:	03143c23          	sd	a7,56(s0)
    locking = pr.locking;
    800005dc:	00013d17          	auipc	s10,0x13
    800005e0:	1e4d2d03          	lw	s10,484(s10) # 800137c0 <pr+0x18>
    if (locking)
    800005e4:	040d1463          	bnez	s10,8000062c <printf+0x70>
    if (fmt == 0)
    800005e8:	040a0b63          	beqz	s4,8000063e <printf+0x82>
    va_start(ap, fmt);
    800005ec:	00840793          	addi	a5,s0,8
    800005f0:	f8f43423          	sd	a5,-120(s0)
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
    800005f4:	000a4503          	lbu	a0,0(s4)
    800005f8:	18050b63          	beqz	a0,8000078e <printf+0x1d2>
    800005fc:	f4a6                	sd	s1,104(sp)
    800005fe:	f0ca                	sd	s2,96(sp)
    80000600:	ecce                	sd	s3,88(sp)
    80000602:	e4d6                	sd	s5,72(sp)
    80000604:	e0da                	sd	s6,64(sp)
    80000606:	fc5e                	sd	s7,56(sp)
    80000608:	f862                	sd	s8,48(sp)
    8000060a:	f466                	sd	s9,40(sp)
    8000060c:	ec6e                	sd	s11,24(sp)
    8000060e:	4981                	li	s3,0
        if (c != '%')
    80000610:	02500b13          	li	s6,37
        switch (c)
    80000614:	07000b93          	li	s7,112
    consputc('x');
    80000618:	4cc1                	li	s9,16
        consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000061a:	00008a97          	auipc	s5,0x8
    8000061e:	24ea8a93          	addi	s5,s5,590 # 80008868 <digits>
        switch (c)
    80000622:	07300c13          	li	s8,115
    80000626:	06400d93          	li	s11,100
    8000062a:	a0b1                	j	80000676 <printf+0xba>
        acquire(&pr.lock);
    8000062c:	00013517          	auipc	a0,0x13
    80000630:	17c50513          	addi	a0,a0,380 # 800137a8 <pr>
    80000634:	00001097          	auipc	ra,0x1
    80000638:	864080e7          	jalr	-1948(ra) # 80000e98 <acquire>
    8000063c:	b775                	j	800005e8 <printf+0x2c>
    8000063e:	f4a6                	sd	s1,104(sp)
    80000640:	f0ca                	sd	s2,96(sp)
    80000642:	ecce                	sd	s3,88(sp)
    80000644:	e4d6                	sd	s5,72(sp)
    80000646:	e0da                	sd	s6,64(sp)
    80000648:	fc5e                	sd	s7,56(sp)
    8000064a:	f862                	sd	s8,48(sp)
    8000064c:	f466                	sd	s9,40(sp)
    8000064e:	ec6e                	sd	s11,24(sp)
        panic("null fmt");
    80000650:	00008517          	auipc	a0,0x8
    80000654:	9e050513          	addi	a0,a0,-1568 # 80008030 <__func__.1+0x28>
    80000658:	00000097          	auipc	ra,0x0
    8000065c:	f08080e7          	jalr	-248(ra) # 80000560 <panic>
            consputc(c);
    80000660:	00000097          	auipc	ra,0x0
    80000664:	c34080e7          	jalr	-972(ra) # 80000294 <consputc>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
    80000668:	2985                	addiw	s3,s3,1
    8000066a:	013a07b3          	add	a5,s4,s3
    8000066e:	0007c503          	lbu	a0,0(a5)
    80000672:	10050563          	beqz	a0,8000077c <printf+0x1c0>
        if (c != '%')
    80000676:	ff6515e3          	bne	a0,s6,80000660 <printf+0xa4>
        c = fmt[++i] & 0xff;
    8000067a:	2985                	addiw	s3,s3,1
    8000067c:	013a07b3          	add	a5,s4,s3
    80000680:	0007c783          	lbu	a5,0(a5)
    80000684:	0007849b          	sext.w	s1,a5
        if (c == 0)
    80000688:	10078b63          	beqz	a5,8000079e <printf+0x1e2>
        switch (c)
    8000068c:	05778a63          	beq	a5,s7,800006e0 <printf+0x124>
    80000690:	02fbf663          	bgeu	s7,a5,800006bc <printf+0x100>
    80000694:	09878863          	beq	a5,s8,80000724 <printf+0x168>
    80000698:	07800713          	li	a4,120
    8000069c:	0ce79563          	bne	a5,a4,80000766 <printf+0x1aa>
            printint(va_arg(ap, int), 16, 1);
    800006a0:	f8843783          	ld	a5,-120(s0)
    800006a4:	00878713          	addi	a4,a5,8
    800006a8:	f8e43423          	sd	a4,-120(s0)
    800006ac:	4605                	li	a2,1
    800006ae:	85e6                	mv	a1,s9
    800006b0:	4388                	lw	a0,0(a5)
    800006b2:	00000097          	auipc	ra,0x0
    800006b6:	e0a080e7          	jalr	-502(ra) # 800004bc <printint>
            break;
    800006ba:	b77d                	j	80000668 <printf+0xac>
        switch (c)
    800006bc:	09678f63          	beq	a5,s6,8000075a <printf+0x19e>
    800006c0:	0bb79363          	bne	a5,s11,80000766 <printf+0x1aa>
            printint(va_arg(ap, int), 10, 1);
    800006c4:	f8843783          	ld	a5,-120(s0)
    800006c8:	00878713          	addi	a4,a5,8
    800006cc:	f8e43423          	sd	a4,-120(s0)
    800006d0:	4605                	li	a2,1
    800006d2:	45a9                	li	a1,10
    800006d4:	4388                	lw	a0,0(a5)
    800006d6:	00000097          	auipc	ra,0x0
    800006da:	de6080e7          	jalr	-538(ra) # 800004bc <printint>
            break;
    800006de:	b769                	j	80000668 <printf+0xac>
            printptr(va_arg(ap, uint64));
    800006e0:	f8843783          	ld	a5,-120(s0)
    800006e4:	00878713          	addi	a4,a5,8
    800006e8:	f8e43423          	sd	a4,-120(s0)
    800006ec:	0007b903          	ld	s2,0(a5)
    consputc('0');
    800006f0:	03000513          	li	a0,48
    800006f4:	00000097          	auipc	ra,0x0
    800006f8:	ba0080e7          	jalr	-1120(ra) # 80000294 <consputc>
    consputc('x');
    800006fc:	07800513          	li	a0,120
    80000700:	00000097          	auipc	ra,0x0
    80000704:	b94080e7          	jalr	-1132(ra) # 80000294 <consputc>
    80000708:	84e6                	mv	s1,s9
        consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000070a:	03c95793          	srli	a5,s2,0x3c
    8000070e:	97d6                	add	a5,a5,s5
    80000710:	0007c503          	lbu	a0,0(a5)
    80000714:	00000097          	auipc	ra,0x0
    80000718:	b80080e7          	jalr	-1152(ra) # 80000294 <consputc>
    for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000071c:	0912                	slli	s2,s2,0x4
    8000071e:	34fd                	addiw	s1,s1,-1
    80000720:	f4ed                	bnez	s1,8000070a <printf+0x14e>
    80000722:	b799                	j	80000668 <printf+0xac>
            if ((s = va_arg(ap, char *)) == 0)
    80000724:	f8843783          	ld	a5,-120(s0)
    80000728:	00878713          	addi	a4,a5,8
    8000072c:	f8e43423          	sd	a4,-120(s0)
    80000730:	6384                	ld	s1,0(a5)
    80000732:	cc89                	beqz	s1,8000074c <printf+0x190>
            for (; *s; s++)
    80000734:	0004c503          	lbu	a0,0(s1)
    80000738:	d905                	beqz	a0,80000668 <printf+0xac>
                consputc(*s);
    8000073a:	00000097          	auipc	ra,0x0
    8000073e:	b5a080e7          	jalr	-1190(ra) # 80000294 <consputc>
            for (; *s; s++)
    80000742:	0485                	addi	s1,s1,1
    80000744:	0004c503          	lbu	a0,0(s1)
    80000748:	f96d                	bnez	a0,8000073a <printf+0x17e>
    8000074a:	bf39                	j	80000668 <printf+0xac>
                s = "(null)";
    8000074c:	00008497          	auipc	s1,0x8
    80000750:	8dc48493          	addi	s1,s1,-1828 # 80008028 <__func__.1+0x20>
            for (; *s; s++)
    80000754:	02800513          	li	a0,40
    80000758:	b7cd                	j	8000073a <printf+0x17e>
            consputc('%');
    8000075a:	855a                	mv	a0,s6
    8000075c:	00000097          	auipc	ra,0x0
    80000760:	b38080e7          	jalr	-1224(ra) # 80000294 <consputc>
            break;
    80000764:	b711                	j	80000668 <printf+0xac>
            consputc('%');
    80000766:	855a                	mv	a0,s6
    80000768:	00000097          	auipc	ra,0x0
    8000076c:	b2c080e7          	jalr	-1236(ra) # 80000294 <consputc>
            consputc(c);
    80000770:	8526                	mv	a0,s1
    80000772:	00000097          	auipc	ra,0x0
    80000776:	b22080e7          	jalr	-1246(ra) # 80000294 <consputc>
            break;
    8000077a:	b5fd                	j	80000668 <printf+0xac>
    8000077c:	74a6                	ld	s1,104(sp)
    8000077e:	7906                	ld	s2,96(sp)
    80000780:	69e6                	ld	s3,88(sp)
    80000782:	6aa6                	ld	s5,72(sp)
    80000784:	6b06                	ld	s6,64(sp)
    80000786:	7be2                	ld	s7,56(sp)
    80000788:	7c42                	ld	s8,48(sp)
    8000078a:	7ca2                	ld	s9,40(sp)
    8000078c:	6de2                	ld	s11,24(sp)
    if (locking)
    8000078e:	020d1263          	bnez	s10,800007b2 <printf+0x1f6>
}
    80000792:	70e6                	ld	ra,120(sp)
    80000794:	7446                	ld	s0,112(sp)
    80000796:	6a46                	ld	s4,80(sp)
    80000798:	7d02                	ld	s10,32(sp)
    8000079a:	6129                	addi	sp,sp,192
    8000079c:	8082                	ret
    8000079e:	74a6                	ld	s1,104(sp)
    800007a0:	7906                	ld	s2,96(sp)
    800007a2:	69e6                	ld	s3,88(sp)
    800007a4:	6aa6                	ld	s5,72(sp)
    800007a6:	6b06                	ld	s6,64(sp)
    800007a8:	7be2                	ld	s7,56(sp)
    800007aa:	7c42                	ld	s8,48(sp)
    800007ac:	7ca2                	ld	s9,40(sp)
    800007ae:	6de2                	ld	s11,24(sp)
    800007b0:	bff9                	j	8000078e <printf+0x1d2>
        release(&pr.lock);
    800007b2:	00013517          	auipc	a0,0x13
    800007b6:	ff650513          	addi	a0,a0,-10 # 800137a8 <pr>
    800007ba:	00000097          	auipc	ra,0x0
    800007be:	792080e7          	jalr	1938(ra) # 80000f4c <release>
}
    800007c2:	bfc1                	j	80000792 <printf+0x1d6>

00000000800007c4 <printfinit>:
        ;
}

void printfinit(void)
{
    800007c4:	1101                	addi	sp,sp,-32
    800007c6:	ec06                	sd	ra,24(sp)
    800007c8:	e822                	sd	s0,16(sp)
    800007ca:	e426                	sd	s1,8(sp)
    800007cc:	1000                	addi	s0,sp,32
    initlock(&pr.lock, "pr");
    800007ce:	00013497          	auipc	s1,0x13
    800007d2:	fda48493          	addi	s1,s1,-38 # 800137a8 <pr>
    800007d6:	00008597          	auipc	a1,0x8
    800007da:	86a58593          	addi	a1,a1,-1942 # 80008040 <__func__.1+0x38>
    800007de:	8526                	mv	a0,s1
    800007e0:	00000097          	auipc	ra,0x0
    800007e4:	628080e7          	jalr	1576(ra) # 80000e08 <initlock>
    pr.locking = 1;
    800007e8:	4785                	li	a5,1
    800007ea:	cc9c                	sw	a5,24(s1)
}
    800007ec:	60e2                	ld	ra,24(sp)
    800007ee:	6442                	ld	s0,16(sp)
    800007f0:	64a2                	ld	s1,8(sp)
    800007f2:	6105                	addi	sp,sp,32
    800007f4:	8082                	ret

00000000800007f6 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007f6:	1141                	addi	sp,sp,-16
    800007f8:	e406                	sd	ra,8(sp)
    800007fa:	e022                	sd	s0,0(sp)
    800007fc:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007fe:	100007b7          	lui	a5,0x10000
    80000802:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000806:	10000737          	lui	a4,0x10000
    8000080a:	f8000693          	li	a3,-128
    8000080e:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000812:	468d                	li	a3,3
    80000814:	10000637          	lui	a2,0x10000
    80000818:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000081c:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000820:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000824:	10000737          	lui	a4,0x10000
    80000828:	461d                	li	a2,7
    8000082a:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000082e:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000832:	00008597          	auipc	a1,0x8
    80000836:	81658593          	addi	a1,a1,-2026 # 80008048 <__func__.1+0x40>
    8000083a:	00013517          	auipc	a0,0x13
    8000083e:	f8e50513          	addi	a0,a0,-114 # 800137c8 <uart_tx_lock>
    80000842:	00000097          	auipc	ra,0x0
    80000846:	5c6080e7          	jalr	1478(ra) # 80000e08 <initlock>
}
    8000084a:	60a2                	ld	ra,8(sp)
    8000084c:	6402                	ld	s0,0(sp)
    8000084e:	0141                	addi	sp,sp,16
    80000850:	8082                	ret

0000000080000852 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000852:	1101                	addi	sp,sp,-32
    80000854:	ec06                	sd	ra,24(sp)
    80000856:	e822                	sd	s0,16(sp)
    80000858:	e426                	sd	s1,8(sp)
    8000085a:	1000                	addi	s0,sp,32
    8000085c:	84aa                	mv	s1,a0
  push_off();
    8000085e:	00000097          	auipc	ra,0x0
    80000862:	5ee080e7          	jalr	1518(ra) # 80000e4c <push_off>

  if(panicked){
    80000866:	0000b797          	auipc	a5,0xb
    8000086a:	d0a7a783          	lw	a5,-758(a5) # 8000b570 <panicked>
    8000086e:	eb85                	bnez	a5,8000089e <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000870:	10000737          	lui	a4,0x10000
    80000874:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000876:	00074783          	lbu	a5,0(a4)
    8000087a:	0207f793          	andi	a5,a5,32
    8000087e:	dfe5                	beqz	a5,80000876 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000880:	0ff4f513          	zext.b	a0,s1
    80000884:	100007b7          	lui	a5,0x10000
    80000888:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000088c:	00000097          	auipc	ra,0x0
    80000890:	660080e7          	jalr	1632(ra) # 80000eec <pop_off>
}
    80000894:	60e2                	ld	ra,24(sp)
    80000896:	6442                	ld	s0,16(sp)
    80000898:	64a2                	ld	s1,8(sp)
    8000089a:	6105                	addi	sp,sp,32
    8000089c:	8082                	ret
    for(;;)
    8000089e:	a001                	j	8000089e <uartputc_sync+0x4c>

00000000800008a0 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800008a0:	0000b797          	auipc	a5,0xb
    800008a4:	cd87b783          	ld	a5,-808(a5) # 8000b578 <uart_tx_r>
    800008a8:	0000b717          	auipc	a4,0xb
    800008ac:	cd873703          	ld	a4,-808(a4) # 8000b580 <uart_tx_w>
    800008b0:	06f70f63          	beq	a4,a5,8000092e <uartstart+0x8e>
{
    800008b4:	7139                	addi	sp,sp,-64
    800008b6:	fc06                	sd	ra,56(sp)
    800008b8:	f822                	sd	s0,48(sp)
    800008ba:	f426                	sd	s1,40(sp)
    800008bc:	f04a                	sd	s2,32(sp)
    800008be:	ec4e                	sd	s3,24(sp)
    800008c0:	e852                	sd	s4,16(sp)
    800008c2:	e456                	sd	s5,8(sp)
    800008c4:	e05a                	sd	s6,0(sp)
    800008c6:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008c8:	10000937          	lui	s2,0x10000
    800008cc:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008ce:	00013a97          	auipc	s5,0x13
    800008d2:	efaa8a93          	addi	s5,s5,-262 # 800137c8 <uart_tx_lock>
    uart_tx_r += 1;
    800008d6:	0000b497          	auipc	s1,0xb
    800008da:	ca248493          	addi	s1,s1,-862 # 8000b578 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008de:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008e2:	0000b997          	auipc	s3,0xb
    800008e6:	c9e98993          	addi	s3,s3,-866 # 8000b580 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008ea:	00094703          	lbu	a4,0(s2)
    800008ee:	02077713          	andi	a4,a4,32
    800008f2:	c705                	beqz	a4,8000091a <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008f4:	01f7f713          	andi	a4,a5,31
    800008f8:	9756                	add	a4,a4,s5
    800008fa:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800008fe:	0785                	addi	a5,a5,1
    80000900:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    80000902:	8526                	mv	a0,s1
    80000904:	00002097          	auipc	ra,0x2
    80000908:	c9e080e7          	jalr	-866(ra) # 800025a2 <wakeup>
    WriteReg(THR, c);
    8000090c:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80000910:	609c                	ld	a5,0(s1)
    80000912:	0009b703          	ld	a4,0(s3)
    80000916:	fcf71ae3          	bne	a4,a5,800008ea <uartstart+0x4a>
  }
}
    8000091a:	70e2                	ld	ra,56(sp)
    8000091c:	7442                	ld	s0,48(sp)
    8000091e:	74a2                	ld	s1,40(sp)
    80000920:	7902                	ld	s2,32(sp)
    80000922:	69e2                	ld	s3,24(sp)
    80000924:	6a42                	ld	s4,16(sp)
    80000926:	6aa2                	ld	s5,8(sp)
    80000928:	6b02                	ld	s6,0(sp)
    8000092a:	6121                	addi	sp,sp,64
    8000092c:	8082                	ret
    8000092e:	8082                	ret

0000000080000930 <uartputc>:
{
    80000930:	7179                	addi	sp,sp,-48
    80000932:	f406                	sd	ra,40(sp)
    80000934:	f022                	sd	s0,32(sp)
    80000936:	ec26                	sd	s1,24(sp)
    80000938:	e84a                	sd	s2,16(sp)
    8000093a:	e44e                	sd	s3,8(sp)
    8000093c:	e052                	sd	s4,0(sp)
    8000093e:	1800                	addi	s0,sp,48
    80000940:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80000942:	00013517          	auipc	a0,0x13
    80000946:	e8650513          	addi	a0,a0,-378 # 800137c8 <uart_tx_lock>
    8000094a:	00000097          	auipc	ra,0x0
    8000094e:	54e080e7          	jalr	1358(ra) # 80000e98 <acquire>
  if(panicked){
    80000952:	0000b797          	auipc	a5,0xb
    80000956:	c1e7a783          	lw	a5,-994(a5) # 8000b570 <panicked>
    8000095a:	e7c9                	bnez	a5,800009e4 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000095c:	0000b717          	auipc	a4,0xb
    80000960:	c2473703          	ld	a4,-988(a4) # 8000b580 <uart_tx_w>
    80000964:	0000b797          	auipc	a5,0xb
    80000968:	c147b783          	ld	a5,-1004(a5) # 8000b578 <uart_tx_r>
    8000096c:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000970:	00013997          	auipc	s3,0x13
    80000974:	e5898993          	addi	s3,s3,-424 # 800137c8 <uart_tx_lock>
    80000978:	0000b497          	auipc	s1,0xb
    8000097c:	c0048493          	addi	s1,s1,-1024 # 8000b578 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000980:	0000b917          	auipc	s2,0xb
    80000984:	c0090913          	addi	s2,s2,-1024 # 8000b580 <uart_tx_w>
    80000988:	00e79f63          	bne	a5,a4,800009a6 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000098c:	85ce                	mv	a1,s3
    8000098e:	8526                	mv	a0,s1
    80000990:	00002097          	auipc	ra,0x2
    80000994:	bae080e7          	jalr	-1106(ra) # 8000253e <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000998:	00093703          	ld	a4,0(s2)
    8000099c:	609c                	ld	a5,0(s1)
    8000099e:	02078793          	addi	a5,a5,32
    800009a2:	fee785e3          	beq	a5,a4,8000098c <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800009a6:	00013497          	auipc	s1,0x13
    800009aa:	e2248493          	addi	s1,s1,-478 # 800137c8 <uart_tx_lock>
    800009ae:	01f77793          	andi	a5,a4,31
    800009b2:	97a6                	add	a5,a5,s1
    800009b4:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009b8:	0705                	addi	a4,a4,1
    800009ba:	0000b797          	auipc	a5,0xb
    800009be:	bce7b323          	sd	a4,-1082(a5) # 8000b580 <uart_tx_w>
  uartstart();
    800009c2:	00000097          	auipc	ra,0x0
    800009c6:	ede080e7          	jalr	-290(ra) # 800008a0 <uartstart>
  release(&uart_tx_lock);
    800009ca:	8526                	mv	a0,s1
    800009cc:	00000097          	auipc	ra,0x0
    800009d0:	580080e7          	jalr	1408(ra) # 80000f4c <release>
}
    800009d4:	70a2                	ld	ra,40(sp)
    800009d6:	7402                	ld	s0,32(sp)
    800009d8:	64e2                	ld	s1,24(sp)
    800009da:	6942                	ld	s2,16(sp)
    800009dc:	69a2                	ld	s3,8(sp)
    800009de:	6a02                	ld	s4,0(sp)
    800009e0:	6145                	addi	sp,sp,48
    800009e2:	8082                	ret
    for(;;)
    800009e4:	a001                	j	800009e4 <uartputc+0xb4>

00000000800009e6 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009e6:	1141                	addi	sp,sp,-16
    800009e8:	e422                	sd	s0,8(sp)
    800009ea:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009ec:	100007b7          	lui	a5,0x10000
    800009f0:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800009f2:	0007c783          	lbu	a5,0(a5)
    800009f6:	8b85                	andi	a5,a5,1
    800009f8:	cb81                	beqz	a5,80000a08 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800009fa:	100007b7          	lui	a5,0x10000
    800009fe:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80000a02:	6422                	ld	s0,8(sp)
    80000a04:	0141                	addi	sp,sp,16
    80000a06:	8082                	ret
    return -1;
    80000a08:	557d                	li	a0,-1
    80000a0a:	bfe5                	j	80000a02 <uartgetc+0x1c>

0000000080000a0c <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000a0c:	1101                	addi	sp,sp,-32
    80000a0e:	ec06                	sd	ra,24(sp)
    80000a10:	e822                	sd	s0,16(sp)
    80000a12:	e426                	sd	s1,8(sp)
    80000a14:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a16:	54fd                	li	s1,-1
    80000a18:	a029                	j	80000a22 <uartintr+0x16>
      break;
    consoleintr(c);
    80000a1a:	00000097          	auipc	ra,0x0
    80000a1e:	8bc080e7          	jalr	-1860(ra) # 800002d6 <consoleintr>
    int c = uartgetc();
    80000a22:	00000097          	auipc	ra,0x0
    80000a26:	fc4080e7          	jalr	-60(ra) # 800009e6 <uartgetc>
    if(c == -1)
    80000a2a:	fe9518e3          	bne	a0,s1,80000a1a <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a2e:	00013497          	auipc	s1,0x13
    80000a32:	d9a48493          	addi	s1,s1,-614 # 800137c8 <uart_tx_lock>
    80000a36:	8526                	mv	a0,s1
    80000a38:	00000097          	auipc	ra,0x0
    80000a3c:	460080e7          	jalr	1120(ra) # 80000e98 <acquire>
  uartstart();
    80000a40:	00000097          	auipc	ra,0x0
    80000a44:	e60080e7          	jalr	-416(ra) # 800008a0 <uartstart>
  release(&uart_tx_lock);
    80000a48:	8526                	mv	a0,s1
    80000a4a:	00000097          	auipc	ra,0x0
    80000a4e:	502080e7          	jalr	1282(ra) # 80000f4c <release>
}
    80000a52:	60e2                	ld	ra,24(sp)
    80000a54:	6442                	ld	s0,16(sp)
    80000a56:	64a2                	ld	s1,8(sp)
    80000a58:	6105                	addi	sp,sp,32
    80000a5a:	8082                	ret

0000000080000a5c <kfree>:
// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa)
{
    80000a5c:	1101                	addi	sp,sp,-32
    80000a5e:	ec06                	sd	ra,24(sp)
    80000a60:	e822                	sd	s0,16(sp)
    80000a62:	e426                	sd	s1,8(sp)
    80000a64:	1000                	addi	s0,sp,32
    80000a66:	84aa                	mv	s1,a0
    if (MAX_PAGES != 0)
    80000a68:	0000b797          	auipc	a5,0xb
    80000a6c:	b287b783          	ld	a5,-1240(a5) # 8000b590 <MAX_PAGES>
    80000a70:	c799                	beqz	a5,80000a7e <kfree+0x22>
        assert(FREE_PAGES < MAX_PAGES);
    80000a72:	0000b717          	auipc	a4,0xb
    80000a76:	b1673703          	ld	a4,-1258(a4) # 8000b588 <FREE_PAGES>
    80000a7a:	08f77363          	bgeu	a4,a5,80000b00 <kfree+0xa4>
    struct run *r;

    if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000a7e:	03449793          	slli	a5,s1,0x34
    80000a82:	ebcd                	bnez	a5,80000b34 <kfree+0xd8>
    80000a84:	00244797          	auipc	a5,0x244
    80000a88:	fac78793          	addi	a5,a5,-84 # 80244a30 <end>
    80000a8c:	0af4e463          	bltu	s1,a5,80000b34 <kfree+0xd8>
    80000a90:	47c5                	li	a5,17
    80000a92:	07ee                	slli	a5,a5,0x1b
    80000a94:	0af4f063          	bgeu	s1,a5,80000b34 <kfree+0xd8>
        panic("kfree");

    // Decrement reference count and only free the page if the count reaches 0
    acquire(&kmem.lock);
    80000a98:	00013517          	auipc	a0,0x13
    80000a9c:	d6850513          	addi	a0,a0,-664 # 80013800 <kmem>
    80000aa0:	00000097          	auipc	ra,0x0
    80000aa4:	3f8080e7          	jalr	1016(ra) # 80000e98 <acquire>
    int page_index = (uint64)pa / PGSIZE;
    80000aa8:	00c4d793          	srli	a5,s1,0xc
    80000aac:	2781                	sext.w	a5,a5
    if (kmem.reference_count[page_index] > 0) {
    80000aae:	00878693          	addi	a3,a5,8
    80000ab2:	068a                	slli	a3,a3,0x2
    80000ab4:	00013717          	auipc	a4,0x13
    80000ab8:	d4c70713          	addi	a4,a4,-692 # 80013800 <kmem>
    80000abc:	9736                	add	a4,a4,a3
    80000abe:	4318                	lw	a4,0(a4)
    80000ac0:	00e05a63          	blez	a4,80000ad4 <kfree+0x78>
        kmem.reference_count[page_index]--;
    80000ac4:	8636                	mv	a2,a3
    80000ac6:	00013697          	auipc	a3,0x13
    80000aca:	d3a68693          	addi	a3,a3,-710 # 80013800 <kmem>
    80000ace:	96b2                	add	a3,a3,a2
    80000ad0:	377d                	addiw	a4,a4,-1
    80000ad2:	c298                	sw	a4,0(a3)
    }
    if (kmem.reference_count[page_index] == 0) {
    80000ad4:	07a1                	addi	a5,a5,8
    80000ad6:	078a                	slli	a5,a5,0x2
    80000ad8:	00013717          	auipc	a4,0x13
    80000adc:	d2870713          	addi	a4,a4,-728 # 80013800 <kmem>
    80000ae0:	97ba                	add	a5,a5,a4
    80000ae2:	439c                	lw	a5,0(a5)
    80000ae4:	c3a5                	beqz	a5,80000b44 <kfree+0xe8>
        r = (struct run *)pa;
        r->next = kmem.freelist;
        kmem.freelist = r;
        FREE_PAGES++;
    }
    release(&kmem.lock);
    80000ae6:	00013517          	auipc	a0,0x13
    80000aea:	d1a50513          	addi	a0,a0,-742 # 80013800 <kmem>
    80000aee:	00000097          	auipc	ra,0x0
    80000af2:	45e080e7          	jalr	1118(ra) # 80000f4c <release>
}
    80000af6:	60e2                	ld	ra,24(sp)
    80000af8:	6442                	ld	s0,16(sp)
    80000afa:	64a2                	ld	s1,8(sp)
    80000afc:	6105                	addi	sp,sp,32
    80000afe:	8082                	ret
        assert(FREE_PAGES < MAX_PAGES);
    80000b00:	03b00693          	li	a3,59
    80000b04:	00007617          	auipc	a2,0x7
    80000b08:	50460613          	addi	a2,a2,1284 # 80008008 <__func__.1>
    80000b0c:	00007597          	auipc	a1,0x7
    80000b10:	54458593          	addi	a1,a1,1348 # 80008050 <__func__.1+0x48>
    80000b14:	00007517          	auipc	a0,0x7
    80000b18:	54c50513          	addi	a0,a0,1356 # 80008060 <__func__.1+0x58>
    80000b1c:	00000097          	auipc	ra,0x0
    80000b20:	aa0080e7          	jalr	-1376(ra) # 800005bc <printf>
    80000b24:	00007517          	auipc	a0,0x7
    80000b28:	54c50513          	addi	a0,a0,1356 # 80008070 <__func__.1+0x68>
    80000b2c:	00000097          	auipc	ra,0x0
    80000b30:	a34080e7          	jalr	-1484(ra) # 80000560 <panic>
        panic("kfree");
    80000b34:	00007517          	auipc	a0,0x7
    80000b38:	54c50513          	addi	a0,a0,1356 # 80008080 <__func__.1+0x78>
    80000b3c:	00000097          	auipc	ra,0x0
    80000b40:	a24080e7          	jalr	-1500(ra) # 80000560 <panic>
        memset(pa, 1, PGSIZE);
    80000b44:	6605                	lui	a2,0x1
    80000b46:	4585                	li	a1,1
    80000b48:	8526                	mv	a0,s1
    80000b4a:	00000097          	auipc	ra,0x0
    80000b4e:	44a080e7          	jalr	1098(ra) # 80000f94 <memset>
        r->next = kmem.freelist;
    80000b52:	00013797          	auipc	a5,0x13
    80000b56:	cae78793          	addi	a5,a5,-850 # 80013800 <kmem>
    80000b5a:	6f98                	ld	a4,24(a5)
    80000b5c:	e098                	sd	a4,0(s1)
        kmem.freelist = r;
    80000b5e:	ef84                	sd	s1,24(a5)
        FREE_PAGES++;
    80000b60:	0000b717          	auipc	a4,0xb
    80000b64:	a2870713          	addi	a4,a4,-1496 # 8000b588 <FREE_PAGES>
    80000b68:	631c                	ld	a5,0(a4)
    80000b6a:	0785                	addi	a5,a5,1
    80000b6c:	e31c                	sd	a5,0(a4)
    80000b6e:	bfa5                	j	80000ae6 <kfree+0x8a>

0000000080000b70 <freerange>:
{
    80000b70:	7179                	addi	sp,sp,-48
    80000b72:	f406                	sd	ra,40(sp)
    80000b74:	f022                	sd	s0,32(sp)
    80000b76:	ec26                	sd	s1,24(sp)
    80000b78:	1800                	addi	s0,sp,48
    p = (char *)PGROUNDUP((uint64)pa_start);
    80000b7a:	6785                	lui	a5,0x1
    80000b7c:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000b80:	00e504b3          	add	s1,a0,a4
    80000b84:	777d                	lui	a4,0xfffff
    80000b86:	8cf9                	and	s1,s1,a4
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000b88:	94be                	add	s1,s1,a5
    80000b8a:	0295e463          	bltu	a1,s1,80000bb2 <freerange+0x42>
    80000b8e:	e84a                	sd	s2,16(sp)
    80000b90:	e44e                	sd	s3,8(sp)
    80000b92:	e052                	sd	s4,0(sp)
    80000b94:	892e                	mv	s2,a1
        kfree(p);
    80000b96:	7a7d                	lui	s4,0xfffff
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000b98:	6985                	lui	s3,0x1
        kfree(p);
    80000b9a:	01448533          	add	a0,s1,s4
    80000b9e:	00000097          	auipc	ra,0x0
    80000ba2:	ebe080e7          	jalr	-322(ra) # 80000a5c <kfree>
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000ba6:	94ce                	add	s1,s1,s3
    80000ba8:	fe9979e3          	bgeu	s2,s1,80000b9a <freerange+0x2a>
    80000bac:	6942                	ld	s2,16(sp)
    80000bae:	69a2                	ld	s3,8(sp)
    80000bb0:	6a02                	ld	s4,0(sp)
}
    80000bb2:	70a2                	ld	ra,40(sp)
    80000bb4:	7402                	ld	s0,32(sp)
    80000bb6:	64e2                	ld	s1,24(sp)
    80000bb8:	6145                	addi	sp,sp,48
    80000bba:	8082                	ret

0000000080000bbc <kinit>:
{
    80000bbc:	1141                	addi	sp,sp,-16
    80000bbe:	e406                	sd	ra,8(sp)
    80000bc0:	e022                	sd	s0,0(sp)
    80000bc2:	0800                	addi	s0,sp,16
    initlock(&kmem.lock, "kmem");
    80000bc4:	00007597          	auipc	a1,0x7
    80000bc8:	4c458593          	addi	a1,a1,1220 # 80008088 <__func__.1+0x80>
    80000bcc:	00013517          	auipc	a0,0x13
    80000bd0:	c3450513          	addi	a0,a0,-972 # 80013800 <kmem>
    80000bd4:	00000097          	auipc	ra,0x0
    80000bd8:	234080e7          	jalr	564(ra) # 80000e08 <initlock>
    for (int i = 0; i < PHYSTOP / PGSIZE; i++) {
    80000bdc:	00013797          	auipc	a5,0x13
    80000be0:	c4478793          	addi	a5,a5,-956 # 80013820 <kmem+0x20>
    80000be4:	00233717          	auipc	a4,0x233
    80000be8:	c3c70713          	addi	a4,a4,-964 # 80233820 <cpus>
        kmem.reference_count[i] = 0; // Initialize reference counts to 0
    80000bec:	0007a023          	sw	zero,0(a5)
    for (int i = 0; i < PHYSTOP / PGSIZE; i++) {
    80000bf0:	0791                	addi	a5,a5,4
    80000bf2:	fee79de3          	bne	a5,a4,80000bec <kinit+0x30>
    freerange(end, (void *)PHYSTOP);
    80000bf6:	45c5                	li	a1,17
    80000bf8:	05ee                	slli	a1,a1,0x1b
    80000bfa:	00244517          	auipc	a0,0x244
    80000bfe:	e3650513          	addi	a0,a0,-458 # 80244a30 <end>
    80000c02:	00000097          	auipc	ra,0x0
    80000c06:	f6e080e7          	jalr	-146(ra) # 80000b70 <freerange>
    MAX_PAGES = FREE_PAGES;
    80000c0a:	0000b797          	auipc	a5,0xb
    80000c0e:	97e7b783          	ld	a5,-1666(a5) # 8000b588 <FREE_PAGES>
    80000c12:	0000b717          	auipc	a4,0xb
    80000c16:	96f73f23          	sd	a5,-1666(a4) # 8000b590 <MAX_PAGES>
}
    80000c1a:	60a2                	ld	ra,8(sp)
    80000c1c:	6402                	ld	s0,0(sp)
    80000c1e:	0141                	addi	sp,sp,16
    80000c20:	8082                	ret

0000000080000c22 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000c22:	1101                	addi	sp,sp,-32
    80000c24:	ec06                	sd	ra,24(sp)
    80000c26:	e822                	sd	s0,16(sp)
    80000c28:	e426                	sd	s1,8(sp)
    80000c2a:	1000                	addi	s0,sp,32
    assert(FREE_PAGES > 0);
    80000c2c:	0000b797          	auipc	a5,0xb
    80000c30:	95c7b783          	ld	a5,-1700(a5) # 8000b588 <FREE_PAGES>
    80000c34:	c7a5                	beqz	a5,80000c9c <kalloc+0x7a>
    struct run *r;

    acquire(&kmem.lock);
    80000c36:	00013517          	auipc	a0,0x13
    80000c3a:	bca50513          	addi	a0,a0,-1078 # 80013800 <kmem>
    80000c3e:	00000097          	auipc	ra,0x0
    80000c42:	25a080e7          	jalr	602(ra) # 80000e98 <acquire>
    r = kmem.freelist;
    80000c46:	00013497          	auipc	s1,0x13
    80000c4a:	bd24b483          	ld	s1,-1070(s1) # 80013818 <kmem+0x18>
    if (r) {
    80000c4e:	c0c9                	beqz	s1,80000cd0 <kalloc+0xae>
        kmem.freelist = r->next;
    80000c50:	609c                	ld	a5,0(s1)
    80000c52:	00013517          	auipc	a0,0x13
    80000c56:	bae50513          	addi	a0,a0,-1106 # 80013800 <kmem>
    80000c5a:	ed1c                	sd	a5,24(a0)
        int page_index = (uint64)r / PGSIZE;
    80000c5c:	00c4d793          	srli	a5,s1,0xc
        kmem.reference_count[page_index] = 1; // Initialize reference count to 1
    80000c60:	2781                	sext.w	a5,a5
    80000c62:	07a1                	addi	a5,a5,8
    80000c64:	078a                	slli	a5,a5,0x2
    80000c66:	97aa                	add	a5,a5,a0
    80000c68:	4705                	li	a4,1
    80000c6a:	c398                	sw	a4,0(a5)
    }
    release(&kmem.lock);
    80000c6c:	00000097          	auipc	ra,0x0
    80000c70:	2e0080e7          	jalr	736(ra) # 80000f4c <release>

    if (r)
        memset((char *)r, 5, PGSIZE); // fill with junk
    80000c74:	6605                	lui	a2,0x1
    80000c76:	4595                	li	a1,5
    80000c78:	8526                	mv	a0,s1
    80000c7a:	00000097          	auipc	ra,0x0
    80000c7e:	31a080e7          	jalr	794(ra) # 80000f94 <memset>
    FREE_PAGES--;
    80000c82:	0000b717          	auipc	a4,0xb
    80000c86:	90670713          	addi	a4,a4,-1786 # 8000b588 <FREE_PAGES>
    80000c8a:	631c                	ld	a5,0(a4)
    80000c8c:	17fd                	addi	a5,a5,-1
    80000c8e:	e31c                	sd	a5,0(a4)
    return (void *)r;
}
    80000c90:	8526                	mv	a0,s1
    80000c92:	60e2                	ld	ra,24(sp)
    80000c94:	6442                	ld	s0,16(sp)
    80000c96:	64a2                	ld	s1,8(sp)
    80000c98:	6105                	addi	sp,sp,32
    80000c9a:	8082                	ret
    assert(FREE_PAGES > 0);
    80000c9c:	05900693          	li	a3,89
    80000ca0:	00007617          	auipc	a2,0x7
    80000ca4:	36060613          	addi	a2,a2,864 # 80008000 <etext>
    80000ca8:	00007597          	auipc	a1,0x7
    80000cac:	3a858593          	addi	a1,a1,936 # 80008050 <__func__.1+0x48>
    80000cb0:	00007517          	auipc	a0,0x7
    80000cb4:	3b050513          	addi	a0,a0,944 # 80008060 <__func__.1+0x58>
    80000cb8:	00000097          	auipc	ra,0x0
    80000cbc:	904080e7          	jalr	-1788(ra) # 800005bc <printf>
    80000cc0:	00007517          	auipc	a0,0x7
    80000cc4:	3b050513          	addi	a0,a0,944 # 80008070 <__func__.1+0x68>
    80000cc8:	00000097          	auipc	ra,0x0
    80000ccc:	898080e7          	jalr	-1896(ra) # 80000560 <panic>
    release(&kmem.lock);
    80000cd0:	00013517          	auipc	a0,0x13
    80000cd4:	b3050513          	addi	a0,a0,-1232 # 80013800 <kmem>
    80000cd8:	00000097          	auipc	ra,0x0
    80000cdc:	274080e7          	jalr	628(ra) # 80000f4c <release>
    if (r)
    80000ce0:	b74d                	j	80000c82 <kalloc+0x60>

0000000080000ce2 <incref>:

// Increment reference count for a physical page
void
incref(void *pa) {
    80000ce2:	1101                	addi	sp,sp,-32
    80000ce4:	ec06                	sd	ra,24(sp)
    80000ce6:	e822                	sd	s0,16(sp)
    80000ce8:	e426                	sd	s1,8(sp)
    80000cea:	1000                	addi	s0,sp,32
    if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000cec:	03451793          	slli	a5,a0,0x34
    80000cf0:	ebb1                	bnez	a5,80000d44 <incref+0x62>
    80000cf2:	84aa                	mv	s1,a0
    80000cf4:	00244797          	auipc	a5,0x244
    80000cf8:	d3c78793          	addi	a5,a5,-708 # 80244a30 <end>
    80000cfc:	04f56463          	bltu	a0,a5,80000d44 <incref+0x62>
    80000d00:	47c5                	li	a5,17
    80000d02:	07ee                	slli	a5,a5,0x1b
    80000d04:	04f57063          	bgeu	a0,a5,80000d44 <incref+0x62>
        panic("incref: invalid physical address");

    acquire(&kmem.lock);
    80000d08:	00013517          	auipc	a0,0x13
    80000d0c:	af850513          	addi	a0,a0,-1288 # 80013800 <kmem>
    80000d10:	00000097          	auipc	ra,0x0
    80000d14:	188080e7          	jalr	392(ra) # 80000e98 <acquire>
    int page_index = (uint64)pa / PGSIZE;
    80000d18:	00c4d793          	srli	a5,s1,0xc
    80000d1c:	2781                	sext.w	a5,a5
    kmem.reference_count[page_index]++;
    80000d1e:	00013517          	auipc	a0,0x13
    80000d22:	ae250513          	addi	a0,a0,-1310 # 80013800 <kmem>
    80000d26:	07a1                	addi	a5,a5,8
    80000d28:	078a                	slli	a5,a5,0x2
    80000d2a:	97aa                	add	a5,a5,a0
    80000d2c:	4398                	lw	a4,0(a5)
    80000d2e:	2705                	addiw	a4,a4,1
    80000d30:	c398                	sw	a4,0(a5)
    release(&kmem.lock);
    80000d32:	00000097          	auipc	ra,0x0
    80000d36:	21a080e7          	jalr	538(ra) # 80000f4c <release>
}
    80000d3a:	60e2                	ld	ra,24(sp)
    80000d3c:	6442                	ld	s0,16(sp)
    80000d3e:	64a2                	ld	s1,8(sp)
    80000d40:	6105                	addi	sp,sp,32
    80000d42:	8082                	ret
        panic("incref: invalid physical address");
    80000d44:	00007517          	auipc	a0,0x7
    80000d48:	34c50513          	addi	a0,a0,844 # 80008090 <__func__.1+0x88>
    80000d4c:	00000097          	auipc	ra,0x0
    80000d50:	814080e7          	jalr	-2028(ra) # 80000560 <panic>

0000000080000d54 <decref>:

// Decrement reference count for a physical page
void
decref(void *pa) {
    80000d54:	1101                	addi	sp,sp,-32
    80000d56:	ec06                	sd	ra,24(sp)
    80000d58:	e822                	sd	s0,16(sp)
    80000d5a:	e426                	sd	s1,8(sp)
    80000d5c:	1000                	addi	s0,sp,32
    if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000d5e:	03451793          	slli	a5,a0,0x34
    80000d62:	ebd9                	bnez	a5,80000df8 <decref+0xa4>
    80000d64:	84aa                	mv	s1,a0
    80000d66:	00244797          	auipc	a5,0x244
    80000d6a:	cca78793          	addi	a5,a5,-822 # 80244a30 <end>
    80000d6e:	08f56563          	bltu	a0,a5,80000df8 <decref+0xa4>
    80000d72:	47c5                	li	a5,17
    80000d74:	07ee                	slli	a5,a5,0x1b
    80000d76:	08f57163          	bgeu	a0,a5,80000df8 <decref+0xa4>
        panic("decref: invalid physical address");

    acquire(&kmem.lock);
    80000d7a:	00013517          	auipc	a0,0x13
    80000d7e:	a8650513          	addi	a0,a0,-1402 # 80013800 <kmem>
    80000d82:	00000097          	auipc	ra,0x0
    80000d86:	116080e7          	jalr	278(ra) # 80000e98 <acquire>
    int page_index = (uint64)pa / PGSIZE;
    80000d8a:	00c4d793          	srli	a5,s1,0xc
    80000d8e:	2781                	sext.w	a5,a5
    if (kmem.reference_count[page_index] > 0) {
    80000d90:	00878693          	addi	a3,a5,8
    80000d94:	068a                	slli	a3,a3,0x2
    80000d96:	00013717          	auipc	a4,0x13
    80000d9a:	a6a70713          	addi	a4,a4,-1430 # 80013800 <kmem>
    80000d9e:	9736                	add	a4,a4,a3
    80000da0:	4318                	lw	a4,0(a4)
    80000da2:	00e05a63          	blez	a4,80000db6 <decref+0x62>
        kmem.reference_count[page_index]--;
    80000da6:	8636                	mv	a2,a3
    80000da8:	00013697          	auipc	a3,0x13
    80000dac:	a5868693          	addi	a3,a3,-1448 # 80013800 <kmem>
    80000db0:	96b2                	add	a3,a3,a2
    80000db2:	377d                	addiw	a4,a4,-1
    80000db4:	c298                	sw	a4,0(a3)
    }
    if (kmem.reference_count[page_index] == 0) {
    80000db6:	07a1                	addi	a5,a5,8
    80000db8:	078a                	slli	a5,a5,0x2
    80000dba:	00013717          	auipc	a4,0x13
    80000dbe:	a4670713          	addi	a4,a4,-1466 # 80013800 <kmem>
    80000dc2:	97ba                	add	a5,a5,a4
    80000dc4:	439c                	lw	a5,0(a5)
    80000dc6:	ef81                	bnez	a5,80000dde <decref+0x8a>
        // Free the page if the reference count reaches 0
        struct run *r = (struct run *)pa;
        r->next = kmem.freelist;
    80000dc8:	87ba                	mv	a5,a4
    80000dca:	6f18                	ld	a4,24(a4)
    80000dcc:	e098                	sd	a4,0(s1)
        kmem.freelist = r;
    80000dce:	ef84                	sd	s1,24(a5)
        FREE_PAGES++;
    80000dd0:	0000a717          	auipc	a4,0xa
    80000dd4:	7b870713          	addi	a4,a4,1976 # 8000b588 <FREE_PAGES>
    80000dd8:	631c                	ld	a5,0(a4)
    80000dda:	0785                	addi	a5,a5,1
    80000ddc:	e31c                	sd	a5,0(a4)
    }
    release(&kmem.lock);
    80000dde:	00013517          	auipc	a0,0x13
    80000de2:	a2250513          	addi	a0,a0,-1502 # 80013800 <kmem>
    80000de6:	00000097          	auipc	ra,0x0
    80000dea:	166080e7          	jalr	358(ra) # 80000f4c <release>
    80000dee:	60e2                	ld	ra,24(sp)
    80000df0:	6442                	ld	s0,16(sp)
    80000df2:	64a2                	ld	s1,8(sp)
    80000df4:	6105                	addi	sp,sp,32
    80000df6:	8082                	ret
        panic("decref: invalid physical address");
    80000df8:	00007517          	auipc	a0,0x7
    80000dfc:	2c050513          	addi	a0,a0,704 # 800080b8 <__func__.1+0xb0>
    80000e00:	fffff097          	auipc	ra,0xfffff
    80000e04:	760080e7          	jalr	1888(ra) # 80000560 <panic>

0000000080000e08 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000e08:	1141                	addi	sp,sp,-16
    80000e0a:	e422                	sd	s0,8(sp)
    80000e0c:	0800                	addi	s0,sp,16
  lk->name = name;
    80000e0e:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000e10:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000e14:	00053823          	sd	zero,16(a0)
}
    80000e18:	6422                	ld	s0,8(sp)
    80000e1a:	0141                	addi	sp,sp,16
    80000e1c:	8082                	ret

0000000080000e1e <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000e1e:	411c                	lw	a5,0(a0)
    80000e20:	e399                	bnez	a5,80000e26 <holding+0x8>
    80000e22:	4501                	li	a0,0
  return r;
}
    80000e24:	8082                	ret
{
    80000e26:	1101                	addi	sp,sp,-32
    80000e28:	ec06                	sd	ra,24(sp)
    80000e2a:	e822                	sd	s0,16(sp)
    80000e2c:	e426                	sd	s1,8(sp)
    80000e2e:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000e30:	6904                	ld	s1,16(a0)
    80000e32:	00001097          	auipc	ra,0x1
    80000e36:	f3e080e7          	jalr	-194(ra) # 80001d70 <mycpu>
    80000e3a:	40a48533          	sub	a0,s1,a0
    80000e3e:	00153513          	seqz	a0,a0
}
    80000e42:	60e2                	ld	ra,24(sp)
    80000e44:	6442                	ld	s0,16(sp)
    80000e46:	64a2                	ld	s1,8(sp)
    80000e48:	6105                	addi	sp,sp,32
    80000e4a:	8082                	ret

0000000080000e4c <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000e4c:	1101                	addi	sp,sp,-32
    80000e4e:	ec06                	sd	ra,24(sp)
    80000e50:	e822                	sd	s0,16(sp)
    80000e52:	e426                	sd	s1,8(sp)
    80000e54:	1000                	addi	s0,sp,32
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80000e56:	100024f3          	csrr	s1,sstatus
    80000e5a:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000e5e:	9bf5                	andi	a5,a5,-3
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80000e60:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000e64:	00001097          	auipc	ra,0x1
    80000e68:	f0c080e7          	jalr	-244(ra) # 80001d70 <mycpu>
    80000e6c:	5d3c                	lw	a5,120(a0)
    80000e6e:	cf89                	beqz	a5,80000e88 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000e70:	00001097          	auipc	ra,0x1
    80000e74:	f00080e7          	jalr	-256(ra) # 80001d70 <mycpu>
    80000e78:	5d3c                	lw	a5,120(a0)
    80000e7a:	2785                	addiw	a5,a5,1
    80000e7c:	dd3c                	sw	a5,120(a0)
}
    80000e7e:	60e2                	ld	ra,24(sp)
    80000e80:	6442                	ld	s0,16(sp)
    80000e82:	64a2                	ld	s1,8(sp)
    80000e84:	6105                	addi	sp,sp,32
    80000e86:	8082                	ret
    mycpu()->intena = old;
    80000e88:	00001097          	auipc	ra,0x1
    80000e8c:	ee8080e7          	jalr	-280(ra) # 80001d70 <mycpu>
    return (x & SSTATUS_SIE) != 0;
    80000e90:	8085                	srli	s1,s1,0x1
    80000e92:	8885                	andi	s1,s1,1
    80000e94:	dd64                	sw	s1,124(a0)
    80000e96:	bfe9                	j	80000e70 <push_off+0x24>

0000000080000e98 <acquire>:
{
    80000e98:	1101                	addi	sp,sp,-32
    80000e9a:	ec06                	sd	ra,24(sp)
    80000e9c:	e822                	sd	s0,16(sp)
    80000e9e:	e426                	sd	s1,8(sp)
    80000ea0:	1000                	addi	s0,sp,32
    80000ea2:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000ea4:	00000097          	auipc	ra,0x0
    80000ea8:	fa8080e7          	jalr	-88(ra) # 80000e4c <push_off>
  if(holding(lk))
    80000eac:	8526                	mv	a0,s1
    80000eae:	00000097          	auipc	ra,0x0
    80000eb2:	f70080e7          	jalr	-144(ra) # 80000e1e <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000eb6:	4705                	li	a4,1
  if(holding(lk))
    80000eb8:	e115                	bnez	a0,80000edc <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000eba:	87ba                	mv	a5,a4
    80000ebc:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000ec0:	2781                	sext.w	a5,a5
    80000ec2:	ffe5                	bnez	a5,80000eba <acquire+0x22>
  __sync_synchronize();
    80000ec4:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000ec8:	00001097          	auipc	ra,0x1
    80000ecc:	ea8080e7          	jalr	-344(ra) # 80001d70 <mycpu>
    80000ed0:	e888                	sd	a0,16(s1)
}
    80000ed2:	60e2                	ld	ra,24(sp)
    80000ed4:	6442                	ld	s0,16(sp)
    80000ed6:	64a2                	ld	s1,8(sp)
    80000ed8:	6105                	addi	sp,sp,32
    80000eda:	8082                	ret
    panic("acquire");
    80000edc:	00007517          	auipc	a0,0x7
    80000ee0:	20450513          	addi	a0,a0,516 # 800080e0 <__func__.1+0xd8>
    80000ee4:	fffff097          	auipc	ra,0xfffff
    80000ee8:	67c080e7          	jalr	1660(ra) # 80000560 <panic>

0000000080000eec <pop_off>:

void
pop_off(void)
{
    80000eec:	1141                	addi	sp,sp,-16
    80000eee:	e406                	sd	ra,8(sp)
    80000ef0:	e022                	sd	s0,0(sp)
    80000ef2:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000ef4:	00001097          	auipc	ra,0x1
    80000ef8:	e7c080e7          	jalr	-388(ra) # 80001d70 <mycpu>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80000efc:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    80000f00:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000f02:	e78d                	bnez	a5,80000f2c <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000f04:	5d3c                	lw	a5,120(a0)
    80000f06:	02f05b63          	blez	a5,80000f3c <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000f0a:	37fd                	addiw	a5,a5,-1
    80000f0c:	0007871b          	sext.w	a4,a5
    80000f10:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000f12:	eb09                	bnez	a4,80000f24 <pop_off+0x38>
    80000f14:	5d7c                	lw	a5,124(a0)
    80000f16:	c799                	beqz	a5,80000f24 <pop_off+0x38>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80000f18:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000f1c:	0027e793          	ori	a5,a5,2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80000f20:	10079073          	csrw	sstatus,a5
    intr_on();
    80000f24:	60a2                	ld	ra,8(sp)
    80000f26:	6402                	ld	s0,0(sp)
    80000f28:	0141                	addi	sp,sp,16
    80000f2a:	8082                	ret
    panic("pop_off - interruptible");
    80000f2c:	00007517          	auipc	a0,0x7
    80000f30:	1bc50513          	addi	a0,a0,444 # 800080e8 <__func__.1+0xe0>
    80000f34:	fffff097          	auipc	ra,0xfffff
    80000f38:	62c080e7          	jalr	1580(ra) # 80000560 <panic>
    panic("pop_off");
    80000f3c:	00007517          	auipc	a0,0x7
    80000f40:	1c450513          	addi	a0,a0,452 # 80008100 <__func__.1+0xf8>
    80000f44:	fffff097          	auipc	ra,0xfffff
    80000f48:	61c080e7          	jalr	1564(ra) # 80000560 <panic>

0000000080000f4c <release>:
{
    80000f4c:	1101                	addi	sp,sp,-32
    80000f4e:	ec06                	sd	ra,24(sp)
    80000f50:	e822                	sd	s0,16(sp)
    80000f52:	e426                	sd	s1,8(sp)
    80000f54:	1000                	addi	s0,sp,32
    80000f56:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000f58:	00000097          	auipc	ra,0x0
    80000f5c:	ec6080e7          	jalr	-314(ra) # 80000e1e <holding>
    80000f60:	c115                	beqz	a0,80000f84 <release+0x38>
  lk->cpu = 0;
    80000f62:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000f66:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000f6a:	0310000f          	fence	rw,w
    80000f6e:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000f72:	00000097          	auipc	ra,0x0
    80000f76:	f7a080e7          	jalr	-134(ra) # 80000eec <pop_off>
}
    80000f7a:	60e2                	ld	ra,24(sp)
    80000f7c:	6442                	ld	s0,16(sp)
    80000f7e:	64a2                	ld	s1,8(sp)
    80000f80:	6105                	addi	sp,sp,32
    80000f82:	8082                	ret
    panic("release");
    80000f84:	00007517          	auipc	a0,0x7
    80000f88:	18450513          	addi	a0,a0,388 # 80008108 <__func__.1+0x100>
    80000f8c:	fffff097          	auipc	ra,0xfffff
    80000f90:	5d4080e7          	jalr	1492(ra) # 80000560 <panic>

0000000080000f94 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000f94:	1141                	addi	sp,sp,-16
    80000f96:	e422                	sd	s0,8(sp)
    80000f98:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000f9a:	ca19                	beqz	a2,80000fb0 <memset+0x1c>
    80000f9c:	87aa                	mv	a5,a0
    80000f9e:	1602                	slli	a2,a2,0x20
    80000fa0:	9201                	srli	a2,a2,0x20
    80000fa2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000fa6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000faa:	0785                	addi	a5,a5,1
    80000fac:	fee79de3          	bne	a5,a4,80000fa6 <memset+0x12>
  }
  return dst;
}
    80000fb0:	6422                	ld	s0,8(sp)
    80000fb2:	0141                	addi	sp,sp,16
    80000fb4:	8082                	ret

0000000080000fb6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000fb6:	1141                	addi	sp,sp,-16
    80000fb8:	e422                	sd	s0,8(sp)
    80000fba:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000fbc:	ca05                	beqz	a2,80000fec <memcmp+0x36>
    80000fbe:	fff6069b          	addiw	a3,a2,-1
    80000fc2:	1682                	slli	a3,a3,0x20
    80000fc4:	9281                	srli	a3,a3,0x20
    80000fc6:	0685                	addi	a3,a3,1
    80000fc8:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000fca:	00054783          	lbu	a5,0(a0)
    80000fce:	0005c703          	lbu	a4,0(a1)
    80000fd2:	00e79863          	bne	a5,a4,80000fe2 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000fd6:	0505                	addi	a0,a0,1
    80000fd8:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000fda:	fed518e3          	bne	a0,a3,80000fca <memcmp+0x14>
  }

  return 0;
    80000fde:	4501                	li	a0,0
    80000fe0:	a019                	j	80000fe6 <memcmp+0x30>
      return *s1 - *s2;
    80000fe2:	40e7853b          	subw	a0,a5,a4
}
    80000fe6:	6422                	ld	s0,8(sp)
    80000fe8:	0141                	addi	sp,sp,16
    80000fea:	8082                	ret
  return 0;
    80000fec:	4501                	li	a0,0
    80000fee:	bfe5                	j	80000fe6 <memcmp+0x30>

0000000080000ff0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000ff0:	1141                	addi	sp,sp,-16
    80000ff2:	e422                	sd	s0,8(sp)
    80000ff4:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000ff6:	c205                	beqz	a2,80001016 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000ff8:	02a5e263          	bltu	a1,a0,8000101c <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000ffc:	1602                	slli	a2,a2,0x20
    80000ffe:	9201                	srli	a2,a2,0x20
    80001000:	00c587b3          	add	a5,a1,a2
{
    80001004:	872a                	mv	a4,a0
      *d++ = *s++;
    80001006:	0585                	addi	a1,a1,1
    80001008:	0705                	addi	a4,a4,1
    8000100a:	fff5c683          	lbu	a3,-1(a1)
    8000100e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80001012:	feb79ae3          	bne	a5,a1,80001006 <memmove+0x16>

  return dst;
}
    80001016:	6422                	ld	s0,8(sp)
    80001018:	0141                	addi	sp,sp,16
    8000101a:	8082                	ret
  if(s < d && s + n > d){
    8000101c:	02061693          	slli	a3,a2,0x20
    80001020:	9281                	srli	a3,a3,0x20
    80001022:	00d58733          	add	a4,a1,a3
    80001026:	fce57be3          	bgeu	a0,a4,80000ffc <memmove+0xc>
    d += n;
    8000102a:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000102c:	fff6079b          	addiw	a5,a2,-1
    80001030:	1782                	slli	a5,a5,0x20
    80001032:	9381                	srli	a5,a5,0x20
    80001034:	fff7c793          	not	a5,a5
    80001038:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000103a:	177d                	addi	a4,a4,-1
    8000103c:	16fd                	addi	a3,a3,-1
    8000103e:	00074603          	lbu	a2,0(a4)
    80001042:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80001046:	fef71ae3          	bne	a4,a5,8000103a <memmove+0x4a>
    8000104a:	b7f1                	j	80001016 <memmove+0x26>

000000008000104c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000104c:	1141                	addi	sp,sp,-16
    8000104e:	e406                	sd	ra,8(sp)
    80001050:	e022                	sd	s0,0(sp)
    80001052:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80001054:	00000097          	auipc	ra,0x0
    80001058:	f9c080e7          	jalr	-100(ra) # 80000ff0 <memmove>
}
    8000105c:	60a2                	ld	ra,8(sp)
    8000105e:	6402                	ld	s0,0(sp)
    80001060:	0141                	addi	sp,sp,16
    80001062:	8082                	ret

0000000080001064 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80001064:	1141                	addi	sp,sp,-16
    80001066:	e422                	sd	s0,8(sp)
    80001068:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000106a:	ce11                	beqz	a2,80001086 <strncmp+0x22>
    8000106c:	00054783          	lbu	a5,0(a0)
    80001070:	cf89                	beqz	a5,8000108a <strncmp+0x26>
    80001072:	0005c703          	lbu	a4,0(a1)
    80001076:	00f71a63          	bne	a4,a5,8000108a <strncmp+0x26>
    n--, p++, q++;
    8000107a:	367d                	addiw	a2,a2,-1
    8000107c:	0505                	addi	a0,a0,1
    8000107e:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80001080:	f675                	bnez	a2,8000106c <strncmp+0x8>
  if(n == 0)
    return 0;
    80001082:	4501                	li	a0,0
    80001084:	a801                	j	80001094 <strncmp+0x30>
    80001086:	4501                	li	a0,0
    80001088:	a031                	j	80001094 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    8000108a:	00054503          	lbu	a0,0(a0)
    8000108e:	0005c783          	lbu	a5,0(a1)
    80001092:	9d1d                	subw	a0,a0,a5
}
    80001094:	6422                	ld	s0,8(sp)
    80001096:	0141                	addi	sp,sp,16
    80001098:	8082                	ret

000000008000109a <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000109a:	1141                	addi	sp,sp,-16
    8000109c:	e422                	sd	s0,8(sp)
    8000109e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800010a0:	87aa                	mv	a5,a0
    800010a2:	86b2                	mv	a3,a2
    800010a4:	367d                	addiw	a2,a2,-1
    800010a6:	02d05563          	blez	a3,800010d0 <strncpy+0x36>
    800010aa:	0785                	addi	a5,a5,1
    800010ac:	0005c703          	lbu	a4,0(a1)
    800010b0:	fee78fa3          	sb	a4,-1(a5)
    800010b4:	0585                	addi	a1,a1,1
    800010b6:	f775                	bnez	a4,800010a2 <strncpy+0x8>
    ;
  while(n-- > 0)
    800010b8:	873e                	mv	a4,a5
    800010ba:	9fb5                	addw	a5,a5,a3
    800010bc:	37fd                	addiw	a5,a5,-1
    800010be:	00c05963          	blez	a2,800010d0 <strncpy+0x36>
    *s++ = 0;
    800010c2:	0705                	addi	a4,a4,1
    800010c4:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800010c8:	40e786bb          	subw	a3,a5,a4
    800010cc:	fed04be3          	bgtz	a3,800010c2 <strncpy+0x28>
  return os;
}
    800010d0:	6422                	ld	s0,8(sp)
    800010d2:	0141                	addi	sp,sp,16
    800010d4:	8082                	ret

00000000800010d6 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800010d6:	1141                	addi	sp,sp,-16
    800010d8:	e422                	sd	s0,8(sp)
    800010da:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800010dc:	02c05363          	blez	a2,80001102 <safestrcpy+0x2c>
    800010e0:	fff6069b          	addiw	a3,a2,-1
    800010e4:	1682                	slli	a3,a3,0x20
    800010e6:	9281                	srli	a3,a3,0x20
    800010e8:	96ae                	add	a3,a3,a1
    800010ea:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800010ec:	00d58963          	beq	a1,a3,800010fe <safestrcpy+0x28>
    800010f0:	0585                	addi	a1,a1,1
    800010f2:	0785                	addi	a5,a5,1
    800010f4:	fff5c703          	lbu	a4,-1(a1)
    800010f8:	fee78fa3          	sb	a4,-1(a5)
    800010fc:	fb65                	bnez	a4,800010ec <safestrcpy+0x16>
    ;
  *s = 0;
    800010fe:	00078023          	sb	zero,0(a5)
  return os;
}
    80001102:	6422                	ld	s0,8(sp)
    80001104:	0141                	addi	sp,sp,16
    80001106:	8082                	ret

0000000080001108 <strlen>:

int
strlen(const char *s)
{
    80001108:	1141                	addi	sp,sp,-16
    8000110a:	e422                	sd	s0,8(sp)
    8000110c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000110e:	00054783          	lbu	a5,0(a0)
    80001112:	cf91                	beqz	a5,8000112e <strlen+0x26>
    80001114:	0505                	addi	a0,a0,1
    80001116:	87aa                	mv	a5,a0
    80001118:	86be                	mv	a3,a5
    8000111a:	0785                	addi	a5,a5,1
    8000111c:	fff7c703          	lbu	a4,-1(a5)
    80001120:	ff65                	bnez	a4,80001118 <strlen+0x10>
    80001122:	40a6853b          	subw	a0,a3,a0
    80001126:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80001128:	6422                	ld	s0,8(sp)
    8000112a:	0141                	addi	sp,sp,16
    8000112c:	8082                	ret
  for(n = 0; s[n]; n++)
    8000112e:	4501                	li	a0,0
    80001130:	bfe5                	j	80001128 <strlen+0x20>

0000000080001132 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80001132:	1141                	addi	sp,sp,-16
    80001134:	e406                	sd	ra,8(sp)
    80001136:	e022                	sd	s0,0(sp)
    80001138:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000113a:	00001097          	auipc	ra,0x1
    8000113e:	c26080e7          	jalr	-986(ra) # 80001d60 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80001142:	0000a717          	auipc	a4,0xa
    80001146:	45670713          	addi	a4,a4,1110 # 8000b598 <started>
  if(cpuid() == 0){
    8000114a:	c139                	beqz	a0,80001190 <main+0x5e>
    while(started == 0)
    8000114c:	431c                	lw	a5,0(a4)
    8000114e:	2781                	sext.w	a5,a5
    80001150:	dff5                	beqz	a5,8000114c <main+0x1a>
      ;
    __sync_synchronize();
    80001152:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80001156:	00001097          	auipc	ra,0x1
    8000115a:	c0a080e7          	jalr	-1014(ra) # 80001d60 <cpuid>
    8000115e:	85aa                	mv	a1,a0
    80001160:	00007517          	auipc	a0,0x7
    80001164:	fc850513          	addi	a0,a0,-56 # 80008128 <__func__.1+0x120>
    80001168:	fffff097          	auipc	ra,0xfffff
    8000116c:	454080e7          	jalr	1108(ra) # 800005bc <printf>
    kvminithart();    // turn on paging
    80001170:	00000097          	auipc	ra,0x0
    80001174:	0d8080e7          	jalr	216(ra) # 80001248 <kvminithart>
    trapinithart();   // install kernel trap vector
    80001178:	00002097          	auipc	ra,0x2
    8000117c:	acc080e7          	jalr	-1332(ra) # 80002c44 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80001180:	00005097          	auipc	ra,0x5
    80001184:	334080e7          	jalr	820(ra) # 800064b4 <plicinithart>
  }

  scheduler();        
    80001188:	00001097          	auipc	ra,0x1
    8000118c:	294080e7          	jalr	660(ra) # 8000241c <scheduler>
    consoleinit();
    80001190:	fffff097          	auipc	ra,0xfffff
    80001194:	2e0080e7          	jalr	736(ra) # 80000470 <consoleinit>
    printfinit();
    80001198:	fffff097          	auipc	ra,0xfffff
    8000119c:	62c080e7          	jalr	1580(ra) # 800007c4 <printfinit>
    printf("\n");
    800011a0:	00007517          	auipc	a0,0x7
    800011a4:	e8050513          	addi	a0,a0,-384 # 80008020 <__func__.1+0x18>
    800011a8:	fffff097          	auipc	ra,0xfffff
    800011ac:	414080e7          	jalr	1044(ra) # 800005bc <printf>
    printf("xv6 kernel is booting\n");
    800011b0:	00007517          	auipc	a0,0x7
    800011b4:	f6050513          	addi	a0,a0,-160 # 80008110 <__func__.1+0x108>
    800011b8:	fffff097          	auipc	ra,0xfffff
    800011bc:	404080e7          	jalr	1028(ra) # 800005bc <printf>
    printf("\n");
    800011c0:	00007517          	auipc	a0,0x7
    800011c4:	e6050513          	addi	a0,a0,-416 # 80008020 <__func__.1+0x18>
    800011c8:	fffff097          	auipc	ra,0xfffff
    800011cc:	3f4080e7          	jalr	1012(ra) # 800005bc <printf>
    kinit();         // physical page allocator
    800011d0:	00000097          	auipc	ra,0x0
    800011d4:	9ec080e7          	jalr	-1556(ra) # 80000bbc <kinit>
    kvminit();       // create kernel page table
    800011d8:	00000097          	auipc	ra,0x0
    800011dc:	326080e7          	jalr	806(ra) # 800014fe <kvminit>
    kvminithart();   // turn on paging
    800011e0:	00000097          	auipc	ra,0x0
    800011e4:	068080e7          	jalr	104(ra) # 80001248 <kvminithart>
    procinit();      // process table
    800011e8:	00001097          	auipc	ra,0x1
    800011ec:	a92080e7          	jalr	-1390(ra) # 80001c7a <procinit>
    trapinit();      // trap vectors
    800011f0:	00002097          	auipc	ra,0x2
    800011f4:	a2c080e7          	jalr	-1492(ra) # 80002c1c <trapinit>
    trapinithart();  // install kernel trap vector
    800011f8:	00002097          	auipc	ra,0x2
    800011fc:	a4c080e7          	jalr	-1460(ra) # 80002c44 <trapinithart>
    plicinit();      // set up interrupt controller
    80001200:	00005097          	auipc	ra,0x5
    80001204:	29a080e7          	jalr	666(ra) # 8000649a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80001208:	00005097          	auipc	ra,0x5
    8000120c:	2ac080e7          	jalr	684(ra) # 800064b4 <plicinithart>
    binit();         // buffer cache
    80001210:	00002097          	auipc	ra,0x2
    80001214:	370080e7          	jalr	880(ra) # 80003580 <binit>
    iinit();         // inode table
    80001218:	00003097          	auipc	ra,0x3
    8000121c:	a26080e7          	jalr	-1498(ra) # 80003c3e <iinit>
    fileinit();      // file table
    80001220:	00004097          	auipc	ra,0x4
    80001224:	9d6080e7          	jalr	-1578(ra) # 80004bf6 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80001228:	00005097          	auipc	ra,0x5
    8000122c:	394080e7          	jalr	916(ra) # 800065bc <virtio_disk_init>
    userinit();      // first user process
    80001230:	00001097          	auipc	ra,0x1
    80001234:	e34080e7          	jalr	-460(ra) # 80002064 <userinit>
    __sync_synchronize();
    80001238:	0330000f          	fence	rw,rw
    started = 1;
    8000123c:	4785                	li	a5,1
    8000123e:	0000a717          	auipc	a4,0xa
    80001242:	34f72d23          	sw	a5,858(a4) # 8000b598 <started>
    80001246:	b789                	j	80001188 <main+0x56>

0000000080001248 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80001248:	1141                	addi	sp,sp,-16
    8000124a:	e422                	sd	s0,8(sp)
    8000124c:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
    // the zero, zero means flush all TLB entries.
    asm volatile("sfence.vma zero, zero");
    8000124e:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80001252:	0000a797          	auipc	a5,0xa
    80001256:	34e7b783          	ld	a5,846(a5) # 8000b5a0 <kernel_pagetable>
    8000125a:	83b1                	srli	a5,a5,0xc
    8000125c:	577d                	li	a4,-1
    8000125e:	177e                	slli	a4,a4,0x3f
    80001260:	8fd9                	or	a5,a5,a4
    asm volatile("csrw satp, %0" : : "r"(x));
    80001262:	18079073          	csrw	satp,a5
    asm volatile("sfence.vma zero, zero");
    80001266:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    8000126a:	6422                	ld	s0,8(sp)
    8000126c:	0141                	addi	sp,sp,16
    8000126e:	8082                	ret

0000000080001270 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80001270:	7139                	addi	sp,sp,-64
    80001272:	fc06                	sd	ra,56(sp)
    80001274:	f822                	sd	s0,48(sp)
    80001276:	f426                	sd	s1,40(sp)
    80001278:	f04a                	sd	s2,32(sp)
    8000127a:	ec4e                	sd	s3,24(sp)
    8000127c:	e852                	sd	s4,16(sp)
    8000127e:	e456                	sd	s5,8(sp)
    80001280:	e05a                	sd	s6,0(sp)
    80001282:	0080                	addi	s0,sp,64
    80001284:	84aa                	mv	s1,a0
    80001286:	89ae                	mv	s3,a1
    80001288:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000128a:	57fd                	li	a5,-1
    8000128c:	83e9                	srli	a5,a5,0x1a
    8000128e:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80001290:	4b31                	li	s6,12
  if(va >= MAXVA)
    80001292:	04b7f263          	bgeu	a5,a1,800012d6 <walk+0x66>
    panic("walk");
    80001296:	00007517          	auipc	a0,0x7
    8000129a:	eaa50513          	addi	a0,a0,-342 # 80008140 <__func__.1+0x138>
    8000129e:	fffff097          	auipc	ra,0xfffff
    800012a2:	2c2080e7          	jalr	706(ra) # 80000560 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800012a6:	060a8663          	beqz	s5,80001312 <walk+0xa2>
    800012aa:	00000097          	auipc	ra,0x0
    800012ae:	978080e7          	jalr	-1672(ra) # 80000c22 <kalloc>
    800012b2:	84aa                	mv	s1,a0
    800012b4:	c529                	beqz	a0,800012fe <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800012b6:	6605                	lui	a2,0x1
    800012b8:	4581                	li	a1,0
    800012ba:	00000097          	auipc	ra,0x0
    800012be:	cda080e7          	jalr	-806(ra) # 80000f94 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800012c2:	00c4d793          	srli	a5,s1,0xc
    800012c6:	07aa                	slli	a5,a5,0xa
    800012c8:	0017e793          	ori	a5,a5,1
    800012cc:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800012d0:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7fdba5c7>
    800012d2:	036a0063          	beq	s4,s6,800012f2 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800012d6:	0149d933          	srl	s2,s3,s4
    800012da:	1ff97913          	andi	s2,s2,511
    800012de:	090e                	slli	s2,s2,0x3
    800012e0:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800012e2:	00093483          	ld	s1,0(s2)
    800012e6:	0014f793          	andi	a5,s1,1
    800012ea:	dfd5                	beqz	a5,800012a6 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800012ec:	80a9                	srli	s1,s1,0xa
    800012ee:	04b2                	slli	s1,s1,0xc
    800012f0:	b7c5                	j	800012d0 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800012f2:	00c9d513          	srli	a0,s3,0xc
    800012f6:	1ff57513          	andi	a0,a0,511
    800012fa:	050e                	slli	a0,a0,0x3
    800012fc:	9526                	add	a0,a0,s1
}
    800012fe:	70e2                	ld	ra,56(sp)
    80001300:	7442                	ld	s0,48(sp)
    80001302:	74a2                	ld	s1,40(sp)
    80001304:	7902                	ld	s2,32(sp)
    80001306:	69e2                	ld	s3,24(sp)
    80001308:	6a42                	ld	s4,16(sp)
    8000130a:	6aa2                	ld	s5,8(sp)
    8000130c:	6b02                	ld	s6,0(sp)
    8000130e:	6121                	addi	sp,sp,64
    80001310:	8082                	ret
        return 0;
    80001312:	4501                	li	a0,0
    80001314:	b7ed                	j	800012fe <walk+0x8e>

0000000080001316 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80001316:	57fd                	li	a5,-1
    80001318:	83e9                	srli	a5,a5,0x1a
    8000131a:	00b7f463          	bgeu	a5,a1,80001322 <walkaddr+0xc>
    return 0;
    8000131e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001320:	8082                	ret
{
    80001322:	1141                	addi	sp,sp,-16
    80001324:	e406                	sd	ra,8(sp)
    80001326:	e022                	sd	s0,0(sp)
    80001328:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000132a:	4601                	li	a2,0
    8000132c:	00000097          	auipc	ra,0x0
    80001330:	f44080e7          	jalr	-188(ra) # 80001270 <walk>
  if(pte == 0)
    80001334:	c105                	beqz	a0,80001354 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80001336:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001338:	0117f693          	andi	a3,a5,17
    8000133c:	4745                	li	a4,17
    return 0;
    8000133e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001340:	00e68663          	beq	a3,a4,8000134c <walkaddr+0x36>
}
    80001344:	60a2                	ld	ra,8(sp)
    80001346:	6402                	ld	s0,0(sp)
    80001348:	0141                	addi	sp,sp,16
    8000134a:	8082                	ret
  pa = PTE2PA(*pte);
    8000134c:	83a9                	srli	a5,a5,0xa
    8000134e:	00c79513          	slli	a0,a5,0xc
  return pa;
    80001352:	bfcd                	j	80001344 <walkaddr+0x2e>
    return 0;
    80001354:	4501                	li	a0,0
    80001356:	b7fd                	j	80001344 <walkaddr+0x2e>

0000000080001358 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001358:	715d                	addi	sp,sp,-80
    8000135a:	e486                	sd	ra,72(sp)
    8000135c:	e0a2                	sd	s0,64(sp)
    8000135e:	fc26                	sd	s1,56(sp)
    80001360:	f84a                	sd	s2,48(sp)
    80001362:	f44e                	sd	s3,40(sp)
    80001364:	f052                	sd	s4,32(sp)
    80001366:	ec56                	sd	s5,24(sp)
    80001368:	e85a                	sd	s6,16(sp)
    8000136a:	e45e                	sd	s7,8(sp)
    8000136c:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000136e:	c639                	beqz	a2,800013bc <mappages+0x64>
    80001370:	8aaa                	mv	s5,a0
    80001372:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80001374:	777d                	lui	a4,0xfffff
    80001376:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000137a:	fff58993          	addi	s3,a1,-1
    8000137e:	99b2                	add	s3,s3,a2
    80001380:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80001384:	893e                	mv	s2,a5
    80001386:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000138a:	6b85                	lui	s7,0x1
    8000138c:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80001390:	4605                	li	a2,1
    80001392:	85ca                	mv	a1,s2
    80001394:	8556                	mv	a0,s5
    80001396:	00000097          	auipc	ra,0x0
    8000139a:	eda080e7          	jalr	-294(ra) # 80001270 <walk>
    8000139e:	cd1d                	beqz	a0,800013dc <mappages+0x84>
    if(*pte & PTE_V)
    800013a0:	611c                	ld	a5,0(a0)
    800013a2:	8b85                	andi	a5,a5,1
    800013a4:	e785                	bnez	a5,800013cc <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800013a6:	80b1                	srli	s1,s1,0xc
    800013a8:	04aa                	slli	s1,s1,0xa
    800013aa:	0164e4b3          	or	s1,s1,s6
    800013ae:	0014e493          	ori	s1,s1,1
    800013b2:	e104                	sd	s1,0(a0)
    if(a == last)
    800013b4:	05390063          	beq	s2,s3,800013f4 <mappages+0x9c>
    a += PGSIZE;
    800013b8:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800013ba:	bfc9                	j	8000138c <mappages+0x34>
    panic("mappages: size");
    800013bc:	00007517          	auipc	a0,0x7
    800013c0:	d8c50513          	addi	a0,a0,-628 # 80008148 <__func__.1+0x140>
    800013c4:	fffff097          	auipc	ra,0xfffff
    800013c8:	19c080e7          	jalr	412(ra) # 80000560 <panic>
      panic("mappages: remap");
    800013cc:	00007517          	auipc	a0,0x7
    800013d0:	d8c50513          	addi	a0,a0,-628 # 80008158 <__func__.1+0x150>
    800013d4:	fffff097          	auipc	ra,0xfffff
    800013d8:	18c080e7          	jalr	396(ra) # 80000560 <panic>
      return -1;
    800013dc:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800013de:	60a6                	ld	ra,72(sp)
    800013e0:	6406                	ld	s0,64(sp)
    800013e2:	74e2                	ld	s1,56(sp)
    800013e4:	7942                	ld	s2,48(sp)
    800013e6:	79a2                	ld	s3,40(sp)
    800013e8:	7a02                	ld	s4,32(sp)
    800013ea:	6ae2                	ld	s5,24(sp)
    800013ec:	6b42                	ld	s6,16(sp)
    800013ee:	6ba2                	ld	s7,8(sp)
    800013f0:	6161                	addi	sp,sp,80
    800013f2:	8082                	ret
  return 0;
    800013f4:	4501                	li	a0,0
    800013f6:	b7e5                	j	800013de <mappages+0x86>

00000000800013f8 <kvmmap>:
{
    800013f8:	1141                	addi	sp,sp,-16
    800013fa:	e406                	sd	ra,8(sp)
    800013fc:	e022                	sd	s0,0(sp)
    800013fe:	0800                	addi	s0,sp,16
    80001400:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001402:	86b2                	mv	a3,a2
    80001404:	863e                	mv	a2,a5
    80001406:	00000097          	auipc	ra,0x0
    8000140a:	f52080e7          	jalr	-174(ra) # 80001358 <mappages>
    8000140e:	e509                	bnez	a0,80001418 <kvmmap+0x20>
}
    80001410:	60a2                	ld	ra,8(sp)
    80001412:	6402                	ld	s0,0(sp)
    80001414:	0141                	addi	sp,sp,16
    80001416:	8082                	ret
    panic("kvmmap");
    80001418:	00007517          	auipc	a0,0x7
    8000141c:	d5050513          	addi	a0,a0,-688 # 80008168 <__func__.1+0x160>
    80001420:	fffff097          	auipc	ra,0xfffff
    80001424:	140080e7          	jalr	320(ra) # 80000560 <panic>

0000000080001428 <kvmmake>:
{
    80001428:	1101                	addi	sp,sp,-32
    8000142a:	ec06                	sd	ra,24(sp)
    8000142c:	e822                	sd	s0,16(sp)
    8000142e:	e426                	sd	s1,8(sp)
    80001430:	e04a                	sd	s2,0(sp)
    80001432:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001434:	fffff097          	auipc	ra,0xfffff
    80001438:	7ee080e7          	jalr	2030(ra) # 80000c22 <kalloc>
    8000143c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000143e:	6605                	lui	a2,0x1
    80001440:	4581                	li	a1,0
    80001442:	00000097          	auipc	ra,0x0
    80001446:	b52080e7          	jalr	-1198(ra) # 80000f94 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000144a:	4719                	li	a4,6
    8000144c:	6685                	lui	a3,0x1
    8000144e:	10000637          	lui	a2,0x10000
    80001452:	100005b7          	lui	a1,0x10000
    80001456:	8526                	mv	a0,s1
    80001458:	00000097          	auipc	ra,0x0
    8000145c:	fa0080e7          	jalr	-96(ra) # 800013f8 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001460:	4719                	li	a4,6
    80001462:	6685                	lui	a3,0x1
    80001464:	10001637          	lui	a2,0x10001
    80001468:	100015b7          	lui	a1,0x10001
    8000146c:	8526                	mv	a0,s1
    8000146e:	00000097          	auipc	ra,0x0
    80001472:	f8a080e7          	jalr	-118(ra) # 800013f8 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001476:	4719                	li	a4,6
    80001478:	004006b7          	lui	a3,0x400
    8000147c:	0c000637          	lui	a2,0xc000
    80001480:	0c0005b7          	lui	a1,0xc000
    80001484:	8526                	mv	a0,s1
    80001486:	00000097          	auipc	ra,0x0
    8000148a:	f72080e7          	jalr	-142(ra) # 800013f8 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000148e:	00007917          	auipc	s2,0x7
    80001492:	b7290913          	addi	s2,s2,-1166 # 80008000 <etext>
    80001496:	4729                	li	a4,10
    80001498:	80007697          	auipc	a3,0x80007
    8000149c:	b6868693          	addi	a3,a3,-1176 # 8000 <_entry-0x7fff8000>
    800014a0:	4605                	li	a2,1
    800014a2:	067e                	slli	a2,a2,0x1f
    800014a4:	85b2                	mv	a1,a2
    800014a6:	8526                	mv	a0,s1
    800014a8:	00000097          	auipc	ra,0x0
    800014ac:	f50080e7          	jalr	-176(ra) # 800013f8 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800014b0:	46c5                	li	a3,17
    800014b2:	06ee                	slli	a3,a3,0x1b
    800014b4:	4719                	li	a4,6
    800014b6:	412686b3          	sub	a3,a3,s2
    800014ba:	864a                	mv	a2,s2
    800014bc:	85ca                	mv	a1,s2
    800014be:	8526                	mv	a0,s1
    800014c0:	00000097          	auipc	ra,0x0
    800014c4:	f38080e7          	jalr	-200(ra) # 800013f8 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800014c8:	4729                	li	a4,10
    800014ca:	6685                	lui	a3,0x1
    800014cc:	00006617          	auipc	a2,0x6
    800014d0:	b3460613          	addi	a2,a2,-1228 # 80007000 <_trampoline>
    800014d4:	040005b7          	lui	a1,0x4000
    800014d8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800014da:	05b2                	slli	a1,a1,0xc
    800014dc:	8526                	mv	a0,s1
    800014de:	00000097          	auipc	ra,0x0
    800014e2:	f1a080e7          	jalr	-230(ra) # 800013f8 <kvmmap>
  proc_mapstacks(kpgtbl);
    800014e6:	8526                	mv	a0,s1
    800014e8:	00000097          	auipc	ra,0x0
    800014ec:	6ee080e7          	jalr	1774(ra) # 80001bd6 <proc_mapstacks>
}
    800014f0:	8526                	mv	a0,s1
    800014f2:	60e2                	ld	ra,24(sp)
    800014f4:	6442                	ld	s0,16(sp)
    800014f6:	64a2                	ld	s1,8(sp)
    800014f8:	6902                	ld	s2,0(sp)
    800014fa:	6105                	addi	sp,sp,32
    800014fc:	8082                	ret

00000000800014fe <kvminit>:
{
    800014fe:	1141                	addi	sp,sp,-16
    80001500:	e406                	sd	ra,8(sp)
    80001502:	e022                	sd	s0,0(sp)
    80001504:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80001506:	00000097          	auipc	ra,0x0
    8000150a:	f22080e7          	jalr	-222(ra) # 80001428 <kvmmake>
    8000150e:	0000a797          	auipc	a5,0xa
    80001512:	08a7b923          	sd	a0,146(a5) # 8000b5a0 <kernel_pagetable>
}
    80001516:	60a2                	ld	ra,8(sp)
    80001518:	6402                	ld	s0,0(sp)
    8000151a:	0141                	addi	sp,sp,16
    8000151c:	8082                	ret

000000008000151e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000151e:	715d                	addi	sp,sp,-80
    80001520:	e486                	sd	ra,72(sp)
    80001522:	e0a2                	sd	s0,64(sp)
    80001524:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001526:	03459793          	slli	a5,a1,0x34
    8000152a:	e39d                	bnez	a5,80001550 <uvmunmap+0x32>
    8000152c:	f84a                	sd	s2,48(sp)
    8000152e:	f44e                	sd	s3,40(sp)
    80001530:	f052                	sd	s4,32(sp)
    80001532:	ec56                	sd	s5,24(sp)
    80001534:	e85a                	sd	s6,16(sp)
    80001536:	e45e                	sd	s7,8(sp)
    80001538:	8a2a                	mv	s4,a0
    8000153a:	892e                	mv	s2,a1
    8000153c:	8b36                	mv	s6,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000153e:	0632                	slli	a2,a2,0xc
    80001540:	00b609b3          	add	s3,a2,a1

    if((pte = walk(pagetable, a, 0)) == 0)
      continue;
    if((*pte & PTE_V) == 0)
      continue;
    if(PTE_FLAGS(*pte) == PTE_V)
    80001544:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001546:	6a85                	lui	s5,0x1
    80001548:	0735fc63          	bgeu	a1,s3,800015c0 <uvmunmap+0xa2>
    8000154c:	fc26                	sd	s1,56(sp)
    8000154e:	a82d                	j	80001588 <uvmunmap+0x6a>
    80001550:	fc26                	sd	s1,56(sp)
    80001552:	f84a                	sd	s2,48(sp)
    80001554:	f44e                	sd	s3,40(sp)
    80001556:	f052                	sd	s4,32(sp)
    80001558:	ec56                	sd	s5,24(sp)
    8000155a:	e85a                	sd	s6,16(sp)
    8000155c:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    8000155e:	00007517          	auipc	a0,0x7
    80001562:	c1250513          	addi	a0,a0,-1006 # 80008170 <__func__.1+0x168>
    80001566:	fffff097          	auipc	ra,0xfffff
    8000156a:	ffa080e7          	jalr	-6(ra) # 80000560 <panic>
      panic("uvmunmap: not a leaf");
    8000156e:	00007517          	auipc	a0,0x7
    80001572:	c1a50513          	addi	a0,a0,-998 # 80008188 <__func__.1+0x180>
    80001576:	fffff097          	auipc	ra,0xfffff
    8000157a:	fea080e7          	jalr	-22(ra) # 80000560 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      decref((void*)pa); // decrement ref count
    }
    *pte = 0;
    8000157e:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001582:	9956                	add	s2,s2,s5
    80001584:	03397d63          	bgeu	s2,s3,800015be <uvmunmap+0xa0>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001588:	4601                	li	a2,0
    8000158a:	85ca                	mv	a1,s2
    8000158c:	8552                	mv	a0,s4
    8000158e:	00000097          	auipc	ra,0x0
    80001592:	ce2080e7          	jalr	-798(ra) # 80001270 <walk>
    80001596:	84aa                	mv	s1,a0
    80001598:	d56d                	beqz	a0,80001582 <uvmunmap+0x64>
    if((*pte & PTE_V) == 0)
    8000159a:	611c                	ld	a5,0(a0)
    8000159c:	0017f713          	andi	a4,a5,1
    800015a0:	d36d                	beqz	a4,80001582 <uvmunmap+0x64>
    if(PTE_FLAGS(*pte) == PTE_V)
    800015a2:	3ff7f713          	andi	a4,a5,1023
    800015a6:	fd7704e3          	beq	a4,s7,8000156e <uvmunmap+0x50>
    if(do_free){
    800015aa:	fc0b0ae3          	beqz	s6,8000157e <uvmunmap+0x60>
      uint64 pa = PTE2PA(*pte);
    800015ae:	83a9                	srli	a5,a5,0xa
      decref((void*)pa); // decrement ref count
    800015b0:	00c79513          	slli	a0,a5,0xc
    800015b4:	fffff097          	auipc	ra,0xfffff
    800015b8:	7a0080e7          	jalr	1952(ra) # 80000d54 <decref>
    800015bc:	b7c9                	j	8000157e <uvmunmap+0x60>
    800015be:	74e2                	ld	s1,56(sp)
    800015c0:	7942                	ld	s2,48(sp)
    800015c2:	79a2                	ld	s3,40(sp)
    800015c4:	7a02                	ld	s4,32(sp)
    800015c6:	6ae2                	ld	s5,24(sp)
    800015c8:	6b42                	ld	s6,16(sp)
    800015ca:	6ba2                	ld	s7,8(sp)
  }
}
    800015cc:	60a6                	ld	ra,72(sp)
    800015ce:	6406                	ld	s0,64(sp)
    800015d0:	6161                	addi	sp,sp,80
    800015d2:	8082                	ret

00000000800015d4 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800015d4:	1101                	addi	sp,sp,-32
    800015d6:	ec06                	sd	ra,24(sp)
    800015d8:	e822                	sd	s0,16(sp)
    800015da:	e426                	sd	s1,8(sp)
    800015dc:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800015de:	fffff097          	auipc	ra,0xfffff
    800015e2:	644080e7          	jalr	1604(ra) # 80000c22 <kalloc>
    800015e6:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800015e8:	c519                	beqz	a0,800015f6 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800015ea:	6605                	lui	a2,0x1
    800015ec:	4581                	li	a1,0
    800015ee:	00000097          	auipc	ra,0x0
    800015f2:	9a6080e7          	jalr	-1626(ra) # 80000f94 <memset>
  return pagetable;
}
    800015f6:	8526                	mv	a0,s1
    800015f8:	60e2                	ld	ra,24(sp)
    800015fa:	6442                	ld	s0,16(sp)
    800015fc:	64a2                	ld	s1,8(sp)
    800015fe:	6105                	addi	sp,sp,32
    80001600:	8082                	ret

0000000080001602 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80001602:	7179                	addi	sp,sp,-48
    80001604:	f406                	sd	ra,40(sp)
    80001606:	f022                	sd	s0,32(sp)
    80001608:	ec26                	sd	s1,24(sp)
    8000160a:	e84a                	sd	s2,16(sp)
    8000160c:	e44e                	sd	s3,8(sp)
    8000160e:	e052                	sd	s4,0(sp)
    80001610:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001612:	6785                	lui	a5,0x1
    80001614:	04f67863          	bgeu	a2,a5,80001664 <uvmfirst+0x62>
    80001618:	8a2a                	mv	s4,a0
    8000161a:	89ae                	mv	s3,a1
    8000161c:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000161e:	fffff097          	auipc	ra,0xfffff
    80001622:	604080e7          	jalr	1540(ra) # 80000c22 <kalloc>
    80001626:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001628:	6605                	lui	a2,0x1
    8000162a:	4581                	li	a1,0
    8000162c:	00000097          	auipc	ra,0x0
    80001630:	968080e7          	jalr	-1688(ra) # 80000f94 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001634:	4779                	li	a4,30
    80001636:	86ca                	mv	a3,s2
    80001638:	6605                	lui	a2,0x1
    8000163a:	4581                	li	a1,0
    8000163c:	8552                	mv	a0,s4
    8000163e:	00000097          	auipc	ra,0x0
    80001642:	d1a080e7          	jalr	-742(ra) # 80001358 <mappages>
  memmove(mem, src, sz);
    80001646:	8626                	mv	a2,s1
    80001648:	85ce                	mv	a1,s3
    8000164a:	854a                	mv	a0,s2
    8000164c:	00000097          	auipc	ra,0x0
    80001650:	9a4080e7          	jalr	-1628(ra) # 80000ff0 <memmove>
}
    80001654:	70a2                	ld	ra,40(sp)
    80001656:	7402                	ld	s0,32(sp)
    80001658:	64e2                	ld	s1,24(sp)
    8000165a:	6942                	ld	s2,16(sp)
    8000165c:	69a2                	ld	s3,8(sp)
    8000165e:	6a02                	ld	s4,0(sp)
    80001660:	6145                	addi	sp,sp,48
    80001662:	8082                	ret
    panic("uvmfirst: more than a page");
    80001664:	00007517          	auipc	a0,0x7
    80001668:	b3c50513          	addi	a0,a0,-1220 # 800081a0 <__func__.1+0x198>
    8000166c:	fffff097          	auipc	ra,0xfffff
    80001670:	ef4080e7          	jalr	-268(ra) # 80000560 <panic>

0000000080001674 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001674:	1101                	addi	sp,sp,-32
    80001676:	ec06                	sd	ra,24(sp)
    80001678:	e822                	sd	s0,16(sp)
    8000167a:	e426                	sd	s1,8(sp)
    8000167c:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000167e:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001680:	00b67d63          	bgeu	a2,a1,8000169a <uvmdealloc+0x26>
    80001684:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001686:	6785                	lui	a5,0x1
    80001688:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000168a:	00f60733          	add	a4,a2,a5
    8000168e:	76fd                	lui	a3,0xfffff
    80001690:	8f75                	and	a4,a4,a3
    80001692:	97ae                	add	a5,a5,a1
    80001694:	8ff5                	and	a5,a5,a3
    80001696:	00f76863          	bltu	a4,a5,800016a6 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000169a:	8526                	mv	a0,s1
    8000169c:	60e2                	ld	ra,24(sp)
    8000169e:	6442                	ld	s0,16(sp)
    800016a0:	64a2                	ld	s1,8(sp)
    800016a2:	6105                	addi	sp,sp,32
    800016a4:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800016a6:	8f99                	sub	a5,a5,a4
    800016a8:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800016aa:	4685                	li	a3,1
    800016ac:	0007861b          	sext.w	a2,a5
    800016b0:	85ba                	mv	a1,a4
    800016b2:	00000097          	auipc	ra,0x0
    800016b6:	e6c080e7          	jalr	-404(ra) # 8000151e <uvmunmap>
    800016ba:	b7c5                	j	8000169a <uvmdealloc+0x26>

00000000800016bc <uvmalloc>:
  if(newsz < oldsz)
    800016bc:	0ab66b63          	bltu	a2,a1,80001772 <uvmalloc+0xb6>
{
    800016c0:	7139                	addi	sp,sp,-64
    800016c2:	fc06                	sd	ra,56(sp)
    800016c4:	f822                	sd	s0,48(sp)
    800016c6:	ec4e                	sd	s3,24(sp)
    800016c8:	e852                	sd	s4,16(sp)
    800016ca:	e456                	sd	s5,8(sp)
    800016cc:	0080                	addi	s0,sp,64
    800016ce:	8aaa                	mv	s5,a0
    800016d0:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800016d2:	6785                	lui	a5,0x1
    800016d4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800016d6:	95be                	add	a1,a1,a5
    800016d8:	77fd                	lui	a5,0xfffff
    800016da:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800016de:	08c9fc63          	bgeu	s3,a2,80001776 <uvmalloc+0xba>
    800016e2:	f426                	sd	s1,40(sp)
    800016e4:	f04a                	sd	s2,32(sp)
    800016e6:	e05a                	sd	s6,0(sp)
    800016e8:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800016ea:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800016ee:	fffff097          	auipc	ra,0xfffff
    800016f2:	534080e7          	jalr	1332(ra) # 80000c22 <kalloc>
    800016f6:	84aa                	mv	s1,a0
    if(mem == 0){
    800016f8:	c915                	beqz	a0,8000172c <uvmalloc+0x70>
    memset(mem, 0, PGSIZE);
    800016fa:	6605                	lui	a2,0x1
    800016fc:	4581                	li	a1,0
    800016fe:	00000097          	auipc	ra,0x0
    80001702:	896080e7          	jalr	-1898(ra) # 80000f94 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001706:	875a                	mv	a4,s6
    80001708:	86a6                	mv	a3,s1
    8000170a:	6605                	lui	a2,0x1
    8000170c:	85ca                	mv	a1,s2
    8000170e:	8556                	mv	a0,s5
    80001710:	00000097          	auipc	ra,0x0
    80001714:	c48080e7          	jalr	-952(ra) # 80001358 <mappages>
    80001718:	ed05                	bnez	a0,80001750 <uvmalloc+0x94>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000171a:	6785                	lui	a5,0x1
    8000171c:	993e                	add	s2,s2,a5
    8000171e:	fd4968e3          	bltu	s2,s4,800016ee <uvmalloc+0x32>
  return newsz;
    80001722:	8552                	mv	a0,s4
    80001724:	74a2                	ld	s1,40(sp)
    80001726:	7902                	ld	s2,32(sp)
    80001728:	6b02                	ld	s6,0(sp)
    8000172a:	a821                	j	80001742 <uvmalloc+0x86>
      uvmdealloc(pagetable, a, oldsz);
    8000172c:	864e                	mv	a2,s3
    8000172e:	85ca                	mv	a1,s2
    80001730:	8556                	mv	a0,s5
    80001732:	00000097          	auipc	ra,0x0
    80001736:	f42080e7          	jalr	-190(ra) # 80001674 <uvmdealloc>
      return 0;
    8000173a:	4501                	li	a0,0
    8000173c:	74a2                	ld	s1,40(sp)
    8000173e:	7902                	ld	s2,32(sp)
    80001740:	6b02                	ld	s6,0(sp)
}
    80001742:	70e2                	ld	ra,56(sp)
    80001744:	7442                	ld	s0,48(sp)
    80001746:	69e2                	ld	s3,24(sp)
    80001748:	6a42                	ld	s4,16(sp)
    8000174a:	6aa2                	ld	s5,8(sp)
    8000174c:	6121                	addi	sp,sp,64
    8000174e:	8082                	ret
      kfree(mem);
    80001750:	8526                	mv	a0,s1
    80001752:	fffff097          	auipc	ra,0xfffff
    80001756:	30a080e7          	jalr	778(ra) # 80000a5c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000175a:	864e                	mv	a2,s3
    8000175c:	85ca                	mv	a1,s2
    8000175e:	8556                	mv	a0,s5
    80001760:	00000097          	auipc	ra,0x0
    80001764:	f14080e7          	jalr	-236(ra) # 80001674 <uvmdealloc>
      return 0;
    80001768:	4501                	li	a0,0
    8000176a:	74a2                	ld	s1,40(sp)
    8000176c:	7902                	ld	s2,32(sp)
    8000176e:	6b02                	ld	s6,0(sp)
    80001770:	bfc9                	j	80001742 <uvmalloc+0x86>
    return oldsz;
    80001772:	852e                	mv	a0,a1
}
    80001774:	8082                	ret
  return newsz;
    80001776:	8532                	mv	a0,a2
    80001778:	b7e9                	j	80001742 <uvmalloc+0x86>

000000008000177a <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000177a:	7179                	addi	sp,sp,-48
    8000177c:	f406                	sd	ra,40(sp)
    8000177e:	f022                	sd	s0,32(sp)
    80001780:	ec26                	sd	s1,24(sp)
    80001782:	e84a                	sd	s2,16(sp)
    80001784:	e44e                	sd	s3,8(sp)
    80001786:	e052                	sd	s4,0(sp)
    80001788:	1800                	addi	s0,sp,48
    8000178a:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000178c:	84aa                	mv	s1,a0
    8000178e:	6905                	lui	s2,0x1
    80001790:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001792:	4985                	li	s3,1
    80001794:	a829                	j	800017ae <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001796:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001798:	00c79513          	slli	a0,a5,0xc
    8000179c:	00000097          	auipc	ra,0x0
    800017a0:	fde080e7          	jalr	-34(ra) # 8000177a <freewalk>
      pagetable[i] = 0;
    800017a4:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800017a8:	04a1                	addi	s1,s1,8
    800017aa:	03248163          	beq	s1,s2,800017cc <freewalk+0x52>
    pte_t pte = pagetable[i];
    800017ae:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800017b0:	00f7f713          	andi	a4,a5,15
    800017b4:	ff3701e3          	beq	a4,s3,80001796 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800017b8:	8b85                	andi	a5,a5,1
    800017ba:	d7fd                	beqz	a5,800017a8 <freewalk+0x2e>
      panic("freewalk: leaf");
    800017bc:	00007517          	auipc	a0,0x7
    800017c0:	a0450513          	addi	a0,a0,-1532 # 800081c0 <__func__.1+0x1b8>
    800017c4:	fffff097          	auipc	ra,0xfffff
    800017c8:	d9c080e7          	jalr	-612(ra) # 80000560 <panic>
    }
  }
  kfree((void*)pagetable);
    800017cc:	8552                	mv	a0,s4
    800017ce:	fffff097          	auipc	ra,0xfffff
    800017d2:	28e080e7          	jalr	654(ra) # 80000a5c <kfree>
}
    800017d6:	70a2                	ld	ra,40(sp)
    800017d8:	7402                	ld	s0,32(sp)
    800017da:	64e2                	ld	s1,24(sp)
    800017dc:	6942                	ld	s2,16(sp)
    800017de:	69a2                	ld	s3,8(sp)
    800017e0:	6a02                	ld	s4,0(sp)
    800017e2:	6145                	addi	sp,sp,48
    800017e4:	8082                	ret

00000000800017e6 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800017e6:	1101                	addi	sp,sp,-32
    800017e8:	ec06                	sd	ra,24(sp)
    800017ea:	e822                	sd	s0,16(sp)
    800017ec:	e426                	sd	s1,8(sp)
    800017ee:	1000                	addi	s0,sp,32
    800017f0:	84aa                	mv	s1,a0
  if(sz > 0)
    800017f2:	e999                	bnez	a1,80001808 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800017f4:	8526                	mv	a0,s1
    800017f6:	00000097          	auipc	ra,0x0
    800017fa:	f84080e7          	jalr	-124(ra) # 8000177a <freewalk>
}
    800017fe:	60e2                	ld	ra,24(sp)
    80001800:	6442                	ld	s0,16(sp)
    80001802:	64a2                	ld	s1,8(sp)
    80001804:	6105                	addi	sp,sp,32
    80001806:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001808:	6785                	lui	a5,0x1
    8000180a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000180c:	95be                	add	a1,a1,a5
    8000180e:	4685                	li	a3,1
    80001810:	00c5d613          	srli	a2,a1,0xc
    80001814:	4581                	li	a1,0
    80001816:	00000097          	auipc	ra,0x0
    8000181a:	d08080e7          	jalr	-760(ra) # 8000151e <uvmunmap>
    8000181e:	bfd9                	j	800017f4 <uvmfree+0xe>

0000000080001820 <uvmcopy>:
// Copies both the page table and the
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
    80001820:	7139                	addi	sp,sp,-64
    80001822:	fc06                	sd	ra,56(sp)
    80001824:	f822                	sd	s0,48(sp)
    80001826:	ec4e                	sd	s3,24(sp)
    80001828:	0080                	addi	s0,sp,64
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  uint newflags; // flags for the new page table.

  for(i = 0; i < sz; i += PGSIZE){
    8000182a:	ca61                	beqz	a2,800018fa <uvmcopy+0xda>
    8000182c:	f426                	sd	s1,40(sp)
    8000182e:	f04a                	sd	s2,32(sp)
    80001830:	e852                	sd	s4,16(sp)
    80001832:	e456                	sd	s5,8(sp)
    80001834:	e05a                	sd	s6,0(sp)
    80001836:	8b2a                	mv	s6,a0
    80001838:	8aae                	mv	s5,a1
    8000183a:	8a32                	mv	s4,a2
    8000183c:	4481                	li	s1,0
      if((pte = walk(old, i, 0)) == 0)
    8000183e:	4601                	li	a2,0
    80001840:	85a6                	mv	a1,s1
    80001842:	855a                	mv	a0,s6
    80001844:	00000097          	auipc	ra,0x0
    80001848:	a2c080e7          	jalr	-1492(ra) # 80001270 <walk>
    8000184c:	cd39                	beqz	a0,800018aa <uvmcopy+0x8a>
          panic("uvmcopy: pte should exist");
      if((*pte & PTE_V) == 0)
    8000184e:	6118                	ld	a4,0(a0)
    80001850:	00177793          	andi	a5,a4,1
    80001854:	c3bd                	beqz	a5,800018ba <uvmcopy+0x9a>
          panic("uvmcopy: page not present");
      pa = PTE2PA(*pte);
    80001856:	00a75913          	srli	s2,a4,0xa
    8000185a:	0932                	slli	s2,s2,0xc
      flags = PTE_FLAGS(*pte);
      
      // Mark parent's page as read-only and set COW.
      *pte &= ~PTE_W;
    8000185c:	ffb77793          	andi	a5,a4,-5
      *pte |= PTE_COW;
    80001860:	1007e793          	ori	a5,a5,256
    80001864:	e11c                	sd	a5,0(a0)
      
      // For the child's mapping, also clear write bit and add COW.
      newflags = (flags & ~PTE_W) | PTE_COW;
      if(mappages(new, i, PGSIZE, pa, newflags) != 0){
    80001866:	2fb77713          	andi	a4,a4,763
    8000186a:	10076713          	ori	a4,a4,256
    8000186e:	86ca                	mv	a3,s2
    80001870:	6605                	lui	a2,0x1
    80001872:	85a6                	mv	a1,s1
    80001874:	8556                	mv	a0,s5
    80001876:	00000097          	auipc	ra,0x0
    8000187a:	ae2080e7          	jalr	-1310(ra) # 80001358 <mappages>
    8000187e:	89aa                	mv	s3,a0
    80001880:	e529                	bnez	a0,800018ca <uvmcopy+0xaa>
          goto err;
      }
      
      incref((void *)pa); // increment ref count
    80001882:	854a                	mv	a0,s2
    80001884:	fffff097          	auipc	ra,0xfffff
    80001888:	45e080e7          	jalr	1118(ra) # 80000ce2 <incref>
  for(i = 0; i < sz; i += PGSIZE){
    8000188c:	6785                	lui	a5,0x1
    8000188e:	94be                	add	s1,s1,a5
    80001890:	fb44e7e3          	bltu	s1,s4,8000183e <uvmcopy+0x1e>
    80001894:	74a2                	ld	s1,40(sp)
    80001896:	7902                	ld	s2,32(sp)
    80001898:	6a42                	ld	s4,16(sp)
    8000189a:	6aa2                	ld	s5,8(sp)
    8000189c:	6b02                	ld	s6,0(sp)

  err:
  if(i > 0)
      uvmunmap(new, 0, i / PGSIZE, 1);
  return -1;
}
    8000189e:	854e                	mv	a0,s3
    800018a0:	70e2                	ld	ra,56(sp)
    800018a2:	7442                	ld	s0,48(sp)
    800018a4:	69e2                	ld	s3,24(sp)
    800018a6:	6121                	addi	sp,sp,64
    800018a8:	8082                	ret
          panic("uvmcopy: pte should exist");
    800018aa:	00007517          	auipc	a0,0x7
    800018ae:	92650513          	addi	a0,a0,-1754 # 800081d0 <__func__.1+0x1c8>
    800018b2:	fffff097          	auipc	ra,0xfffff
    800018b6:	cae080e7          	jalr	-850(ra) # 80000560 <panic>
          panic("uvmcopy: page not present");
    800018ba:	00007517          	auipc	a0,0x7
    800018be:	93650513          	addi	a0,a0,-1738 # 800081f0 <__func__.1+0x1e8>
    800018c2:	fffff097          	auipc	ra,0xfffff
    800018c6:	c9e080e7          	jalr	-866(ra) # 80000560 <panic>
  if(i > 0)
    800018ca:	e881                	bnez	s1,800018da <uvmcopy+0xba>
  return -1;
    800018cc:	59fd                	li	s3,-1
    800018ce:	74a2                	ld	s1,40(sp)
    800018d0:	7902                	ld	s2,32(sp)
    800018d2:	6a42                	ld	s4,16(sp)
    800018d4:	6aa2                	ld	s5,8(sp)
    800018d6:	6b02                	ld	s6,0(sp)
    800018d8:	b7d9                	j	8000189e <uvmcopy+0x7e>
      uvmunmap(new, 0, i / PGSIZE, 1);
    800018da:	4685                	li	a3,1
    800018dc:	00c4d613          	srli	a2,s1,0xc
    800018e0:	4581                	li	a1,0
    800018e2:	8556                	mv	a0,s5
    800018e4:	00000097          	auipc	ra,0x0
    800018e8:	c3a080e7          	jalr	-966(ra) # 8000151e <uvmunmap>
  return -1;
    800018ec:	59fd                	li	s3,-1
    800018ee:	74a2                	ld	s1,40(sp)
    800018f0:	7902                	ld	s2,32(sp)
    800018f2:	6a42                	ld	s4,16(sp)
    800018f4:	6aa2                	ld	s5,8(sp)
    800018f6:	6b02                	ld	s6,0(sp)
    800018f8:	b75d                	j	8000189e <uvmcopy+0x7e>
  return 0;
    800018fa:	4981                	li	s3,0
    800018fc:	b74d                	j	8000189e <uvmcopy+0x7e>

00000000800018fe <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800018fe:	1141                	addi	sp,sp,-16
    80001900:	e406                	sd	ra,8(sp)
    80001902:	e022                	sd	s0,0(sp)
    80001904:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001906:	4601                	li	a2,0
    80001908:	00000097          	auipc	ra,0x0
    8000190c:	968080e7          	jalr	-1688(ra) # 80001270 <walk>
  if(pte == 0)
    80001910:	c901                	beqz	a0,80001920 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001912:	611c                	ld	a5,0(a0)
    80001914:	9bbd                	andi	a5,a5,-17
    80001916:	e11c                	sd	a5,0(a0)
}
    80001918:	60a2                	ld	ra,8(sp)
    8000191a:	6402                	ld	s0,0(sp)
    8000191c:	0141                	addi	sp,sp,16
    8000191e:	8082                	ret
    panic("uvmclear");
    80001920:	00007517          	auipc	a0,0x7
    80001924:	8f050513          	addi	a0,a0,-1808 # 80008210 <__func__.1+0x208>
    80001928:	fffff097          	auipc	ra,0xfffff
    8000192c:	c38080e7          	jalr	-968(ra) # 80000560 <panic>

0000000080001930 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001930:	c6bd                	beqz	a3,8000199e <copyout+0x6e>
{
    80001932:	715d                	addi	sp,sp,-80
    80001934:	e486                	sd	ra,72(sp)
    80001936:	e0a2                	sd	s0,64(sp)
    80001938:	fc26                	sd	s1,56(sp)
    8000193a:	f84a                	sd	s2,48(sp)
    8000193c:	f44e                	sd	s3,40(sp)
    8000193e:	f052                	sd	s4,32(sp)
    80001940:	ec56                	sd	s5,24(sp)
    80001942:	e85a                	sd	s6,16(sp)
    80001944:	e45e                	sd	s7,8(sp)
    80001946:	e062                	sd	s8,0(sp)
    80001948:	0880                	addi	s0,sp,80
    8000194a:	8b2a                	mv	s6,a0
    8000194c:	8c2e                	mv	s8,a1
    8000194e:	8a32                	mv	s4,a2
    80001950:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001952:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001954:	6a85                	lui	s5,0x1
    80001956:	a015                	j	8000197a <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001958:	9562                	add	a0,a0,s8
    8000195a:	0004861b          	sext.w	a2,s1
    8000195e:	85d2                	mv	a1,s4
    80001960:	41250533          	sub	a0,a0,s2
    80001964:	fffff097          	auipc	ra,0xfffff
    80001968:	68c080e7          	jalr	1676(ra) # 80000ff0 <memmove>

    len -= n;
    8000196c:	409989b3          	sub	s3,s3,s1
    src += n;
    80001970:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80001972:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001976:	02098263          	beqz	s3,8000199a <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    8000197a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000197e:	85ca                	mv	a1,s2
    80001980:	855a                	mv	a0,s6
    80001982:	00000097          	auipc	ra,0x0
    80001986:	994080e7          	jalr	-1644(ra) # 80001316 <walkaddr>
    if(pa0 == 0)
    8000198a:	cd01                	beqz	a0,800019a2 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    8000198c:	418904b3          	sub	s1,s2,s8
    80001990:	94d6                	add	s1,s1,s5
    if(n > len)
    80001992:	fc99f3e3          	bgeu	s3,s1,80001958 <copyout+0x28>
    80001996:	84ce                	mv	s1,s3
    80001998:	b7c1                	j	80001958 <copyout+0x28>
  }
  return 0;
    8000199a:	4501                	li	a0,0
    8000199c:	a021                	j	800019a4 <copyout+0x74>
    8000199e:	4501                	li	a0,0
}
    800019a0:	8082                	ret
      return -1;
    800019a2:	557d                	li	a0,-1
}
    800019a4:	60a6                	ld	ra,72(sp)
    800019a6:	6406                	ld	s0,64(sp)
    800019a8:	74e2                	ld	s1,56(sp)
    800019aa:	7942                	ld	s2,48(sp)
    800019ac:	79a2                	ld	s3,40(sp)
    800019ae:	7a02                	ld	s4,32(sp)
    800019b0:	6ae2                	ld	s5,24(sp)
    800019b2:	6b42                	ld	s6,16(sp)
    800019b4:	6ba2                	ld	s7,8(sp)
    800019b6:	6c02                	ld	s8,0(sp)
    800019b8:	6161                	addi	sp,sp,80
    800019ba:	8082                	ret

00000000800019bc <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800019bc:	caa5                	beqz	a3,80001a2c <copyin+0x70>
{
    800019be:	715d                	addi	sp,sp,-80
    800019c0:	e486                	sd	ra,72(sp)
    800019c2:	e0a2                	sd	s0,64(sp)
    800019c4:	fc26                	sd	s1,56(sp)
    800019c6:	f84a                	sd	s2,48(sp)
    800019c8:	f44e                	sd	s3,40(sp)
    800019ca:	f052                	sd	s4,32(sp)
    800019cc:	ec56                	sd	s5,24(sp)
    800019ce:	e85a                	sd	s6,16(sp)
    800019d0:	e45e                	sd	s7,8(sp)
    800019d2:	e062                	sd	s8,0(sp)
    800019d4:	0880                	addi	s0,sp,80
    800019d6:	8b2a                	mv	s6,a0
    800019d8:	8a2e                	mv	s4,a1
    800019da:	8c32                	mv	s8,a2
    800019dc:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800019de:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800019e0:	6a85                	lui	s5,0x1
    800019e2:	a01d                	j	80001a08 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800019e4:	018505b3          	add	a1,a0,s8
    800019e8:	0004861b          	sext.w	a2,s1
    800019ec:	412585b3          	sub	a1,a1,s2
    800019f0:	8552                	mv	a0,s4
    800019f2:	fffff097          	auipc	ra,0xfffff
    800019f6:	5fe080e7          	jalr	1534(ra) # 80000ff0 <memmove>

    len -= n;
    800019fa:	409989b3          	sub	s3,s3,s1
    dst += n;
    800019fe:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001a00:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001a04:	02098263          	beqz	s3,80001a28 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001a08:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001a0c:	85ca                	mv	a1,s2
    80001a0e:	855a                	mv	a0,s6
    80001a10:	00000097          	auipc	ra,0x0
    80001a14:	906080e7          	jalr	-1786(ra) # 80001316 <walkaddr>
    if(pa0 == 0)
    80001a18:	cd01                	beqz	a0,80001a30 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80001a1a:	418904b3          	sub	s1,s2,s8
    80001a1e:	94d6                	add	s1,s1,s5
    if(n > len)
    80001a20:	fc99f2e3          	bgeu	s3,s1,800019e4 <copyin+0x28>
    80001a24:	84ce                	mv	s1,s3
    80001a26:	bf7d                	j	800019e4 <copyin+0x28>
  }
  return 0;
    80001a28:	4501                	li	a0,0
    80001a2a:	a021                	j	80001a32 <copyin+0x76>
    80001a2c:	4501                	li	a0,0
}
    80001a2e:	8082                	ret
      return -1;
    80001a30:	557d                	li	a0,-1
}
    80001a32:	60a6                	ld	ra,72(sp)
    80001a34:	6406                	ld	s0,64(sp)
    80001a36:	74e2                	ld	s1,56(sp)
    80001a38:	7942                	ld	s2,48(sp)
    80001a3a:	79a2                	ld	s3,40(sp)
    80001a3c:	7a02                	ld	s4,32(sp)
    80001a3e:	6ae2                	ld	s5,24(sp)
    80001a40:	6b42                	ld	s6,16(sp)
    80001a42:	6ba2                	ld	s7,8(sp)
    80001a44:	6c02                	ld	s8,0(sp)
    80001a46:	6161                	addi	sp,sp,80
    80001a48:	8082                	ret

0000000080001a4a <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001a4a:	cacd                	beqz	a3,80001afc <copyinstr+0xb2>
{
    80001a4c:	715d                	addi	sp,sp,-80
    80001a4e:	e486                	sd	ra,72(sp)
    80001a50:	e0a2                	sd	s0,64(sp)
    80001a52:	fc26                	sd	s1,56(sp)
    80001a54:	f84a                	sd	s2,48(sp)
    80001a56:	f44e                	sd	s3,40(sp)
    80001a58:	f052                	sd	s4,32(sp)
    80001a5a:	ec56                	sd	s5,24(sp)
    80001a5c:	e85a                	sd	s6,16(sp)
    80001a5e:	e45e                	sd	s7,8(sp)
    80001a60:	0880                	addi	s0,sp,80
    80001a62:	8a2a                	mv	s4,a0
    80001a64:	8b2e                	mv	s6,a1
    80001a66:	8bb2                	mv	s7,a2
    80001a68:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80001a6a:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001a6c:	6985                	lui	s3,0x1
    80001a6e:	a825                	j	80001aa6 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001a70:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001a74:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001a76:	37fd                	addiw	a5,a5,-1
    80001a78:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
    80001a7c:	60a6                	ld	ra,72(sp)
    80001a7e:	6406                	ld	s0,64(sp)
    80001a80:	74e2                	ld	s1,56(sp)
    80001a82:	7942                	ld	s2,48(sp)
    80001a84:	79a2                	ld	s3,40(sp)
    80001a86:	7a02                	ld	s4,32(sp)
    80001a88:	6ae2                	ld	s5,24(sp)
    80001a8a:	6b42                	ld	s6,16(sp)
    80001a8c:	6ba2                	ld	s7,8(sp)
    80001a8e:	6161                	addi	sp,sp,80
    80001a90:	8082                	ret
    80001a92:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80001a96:	9742                	add	a4,a4,a6
      --max;
    80001a98:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80001a9c:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80001aa0:	04e58663          	beq	a1,a4,80001aec <copyinstr+0xa2>
{
    80001aa4:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80001aa6:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80001aaa:	85a6                	mv	a1,s1
    80001aac:	8552                	mv	a0,s4
    80001aae:	00000097          	auipc	ra,0x0
    80001ab2:	868080e7          	jalr	-1944(ra) # 80001316 <walkaddr>
    if(pa0 == 0)
    80001ab6:	cd0d                	beqz	a0,80001af0 <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80001ab8:	417486b3          	sub	a3,s1,s7
    80001abc:	96ce                	add	a3,a3,s3
    if(n > max)
    80001abe:	00d97363          	bgeu	s2,a3,80001ac4 <copyinstr+0x7a>
    80001ac2:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80001ac4:	955e                	add	a0,a0,s7
    80001ac6:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80001ac8:	c695                	beqz	a3,80001af4 <copyinstr+0xaa>
    80001aca:	87da                	mv	a5,s6
    80001acc:	885a                	mv	a6,s6
      if(*p == '\0'){
    80001ace:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80001ad2:	96da                	add	a3,a3,s6
    80001ad4:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001ad6:	00f60733          	add	a4,a2,a5
    80001ada:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7fdba5d0>
    80001ade:	db49                	beqz	a4,80001a70 <copyinstr+0x26>
        *dst = *p;
    80001ae0:	00e78023          	sb	a4,0(a5)
      dst++;
    80001ae4:	0785                	addi	a5,a5,1
    while(n > 0){
    80001ae6:	fed797e3          	bne	a5,a3,80001ad4 <copyinstr+0x8a>
    80001aea:	b765                	j	80001a92 <copyinstr+0x48>
    80001aec:	4781                	li	a5,0
    80001aee:	b761                	j	80001a76 <copyinstr+0x2c>
      return -1;
    80001af0:	557d                	li	a0,-1
    80001af2:	b769                	j	80001a7c <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80001af4:	6b85                	lui	s7,0x1
    80001af6:	9ba6                	add	s7,s7,s1
    80001af8:	87da                	mv	a5,s6
    80001afa:	b76d                	j	80001aa4 <copyinstr+0x5a>
  int got_null = 0;
    80001afc:	4781                	li	a5,0
  if(got_null){
    80001afe:	37fd                	addiw	a5,a5,-1
    80001b00:	0007851b          	sext.w	a0,a5
    80001b04:	8082                	ret

0000000080001b06 <rr_scheduler>:
        (*sched_pointer)();
    }
}

void rr_scheduler(void)
{
    80001b06:	715d                	addi	sp,sp,-80
    80001b08:	e486                	sd	ra,72(sp)
    80001b0a:	e0a2                	sd	s0,64(sp)
    80001b0c:	fc26                	sd	s1,56(sp)
    80001b0e:	f84a                	sd	s2,48(sp)
    80001b10:	f44e                	sd	s3,40(sp)
    80001b12:	f052                	sd	s4,32(sp)
    80001b14:	ec56                	sd	s5,24(sp)
    80001b16:	e85a                	sd	s6,16(sp)
    80001b18:	e45e                	sd	s7,8(sp)
    80001b1a:	e062                	sd	s8,0(sp)
    80001b1c:	0880                	addi	s0,sp,80
    asm volatile("mv %0, tp" : "=r"(x));
    80001b1e:	8792                	mv	a5,tp
    int id = r_tp();
    80001b20:	2781                	sext.w	a5,a5
    struct proc *p;
    struct cpu *c = mycpu();

    c->proc = 0;
    80001b22:	00232a97          	auipc	s5,0x232
    80001b26:	cfea8a93          	addi	s5,s5,-770 # 80233820 <cpus>
    80001b2a:	00779713          	slli	a4,a5,0x7
    80001b2e:	00ea86b3          	add	a3,s5,a4
    80001b32:	0006b023          	sd	zero,0(a3) # fffffffffffff000 <end+0xffffffff7fdba5d0>
                // Switch to chosen process.  It is the process's job
                // to release its lock and then reacquire it
                // before jumping back to us.
                p->state = RUNNING;
                c->proc = p;
                swtch(&c->context, &p->context);
    80001b36:	0721                	addi	a4,a4,8
    80001b38:	9aba                	add	s5,s5,a4
                c->proc = p;
    80001b3a:	8936                	mv	s2,a3
                // check if we are still the right scheduler (or if schedset changed)
                if (sched_pointer != &rr_scheduler)
    80001b3c:	0000ac17          	auipc	s8,0xa
    80001b40:	99cc0c13          	addi	s8,s8,-1636 # 8000b4d8 <sched_pointer>
    80001b44:	00000b97          	auipc	s7,0x0
    80001b48:	fc2b8b93          	addi	s7,s7,-62 # 80001b06 <rr_scheduler>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80001b4c:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001b50:	0027e793          	ori	a5,a5,2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80001b54:	10079073          	csrw	sstatus,a5
        for (p = proc; p < &proc[NPROC]; p++)
    80001b58:	00232497          	auipc	s1,0x232
    80001b5c:	0f848493          	addi	s1,s1,248 # 80233c50 <proc>
            if (p->state == RUNNABLE)
    80001b60:	498d                	li	s3,3
                p->state = RUNNING;
    80001b62:	4b11                	li	s6,4
        for (p = proc; p < &proc[NPROC]; p++)
    80001b64:	00238a17          	auipc	s4,0x238
    80001b68:	aeca0a13          	addi	s4,s4,-1300 # 80239650 <tickslock>
    80001b6c:	a81d                	j	80001ba2 <rr_scheduler+0x9c>
                {
                    release(&p->lock);
    80001b6e:	8526                	mv	a0,s1
    80001b70:	fffff097          	auipc	ra,0xfffff
    80001b74:	3dc080e7          	jalr	988(ra) # 80000f4c <release>
                c->proc = 0;
            }
            release(&p->lock);
        }
    }
}
    80001b78:	60a6                	ld	ra,72(sp)
    80001b7a:	6406                	ld	s0,64(sp)
    80001b7c:	74e2                	ld	s1,56(sp)
    80001b7e:	7942                	ld	s2,48(sp)
    80001b80:	79a2                	ld	s3,40(sp)
    80001b82:	7a02                	ld	s4,32(sp)
    80001b84:	6ae2                	ld	s5,24(sp)
    80001b86:	6b42                	ld	s6,16(sp)
    80001b88:	6ba2                	ld	s7,8(sp)
    80001b8a:	6c02                	ld	s8,0(sp)
    80001b8c:	6161                	addi	sp,sp,80
    80001b8e:	8082                	ret
            release(&p->lock);
    80001b90:	8526                	mv	a0,s1
    80001b92:	fffff097          	auipc	ra,0xfffff
    80001b96:	3ba080e7          	jalr	954(ra) # 80000f4c <release>
        for (p = proc; p < &proc[NPROC]; p++)
    80001b9a:	16848493          	addi	s1,s1,360
    80001b9e:	fb4487e3          	beq	s1,s4,80001b4c <rr_scheduler+0x46>
            acquire(&p->lock);
    80001ba2:	8526                	mv	a0,s1
    80001ba4:	fffff097          	auipc	ra,0xfffff
    80001ba8:	2f4080e7          	jalr	756(ra) # 80000e98 <acquire>
            if (p->state == RUNNABLE)
    80001bac:	4c9c                	lw	a5,24(s1)
    80001bae:	ff3791e3          	bne	a5,s3,80001b90 <rr_scheduler+0x8a>
                p->state = RUNNING;
    80001bb2:	0164ac23          	sw	s6,24(s1)
                c->proc = p;
    80001bb6:	00993023          	sd	s1,0(s2)
                swtch(&c->context, &p->context);
    80001bba:	06048593          	addi	a1,s1,96
    80001bbe:	8556                	mv	a0,s5
    80001bc0:	00001097          	auipc	ra,0x1
    80001bc4:	ff2080e7          	jalr	-14(ra) # 80002bb2 <swtch>
                if (sched_pointer != &rr_scheduler)
    80001bc8:	000c3783          	ld	a5,0(s8)
    80001bcc:	fb7791e3          	bne	a5,s7,80001b6e <rr_scheduler+0x68>
                c->proc = 0;
    80001bd0:	00093023          	sd	zero,0(s2)
    80001bd4:	bf75                	j	80001b90 <rr_scheduler+0x8a>

0000000080001bd6 <proc_mapstacks>:
{
    80001bd6:	7139                	addi	sp,sp,-64
    80001bd8:	fc06                	sd	ra,56(sp)
    80001bda:	f822                	sd	s0,48(sp)
    80001bdc:	f426                	sd	s1,40(sp)
    80001bde:	f04a                	sd	s2,32(sp)
    80001be0:	ec4e                	sd	s3,24(sp)
    80001be2:	e852                	sd	s4,16(sp)
    80001be4:	e456                	sd	s5,8(sp)
    80001be6:	e05a                	sd	s6,0(sp)
    80001be8:	0080                	addi	s0,sp,64
    80001bea:	8a2a                	mv	s4,a0
    for (p = proc; p < &proc[NPROC]; p++)
    80001bec:	00232497          	auipc	s1,0x232
    80001bf0:	06448493          	addi	s1,s1,100 # 80233c50 <proc>
        uint64 va = KSTACK((int)(p - proc));
    80001bf4:	8b26                	mv	s6,s1
    80001bf6:	04fa5937          	lui	s2,0x4fa5
    80001bfa:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80001bfe:	0932                	slli	s2,s2,0xc
    80001c00:	fa590913          	addi	s2,s2,-91
    80001c04:	0932                	slli	s2,s2,0xc
    80001c06:	fa590913          	addi	s2,s2,-91
    80001c0a:	0932                	slli	s2,s2,0xc
    80001c0c:	fa590913          	addi	s2,s2,-91
    80001c10:	040009b7          	lui	s3,0x4000
    80001c14:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001c16:	09b2                	slli	s3,s3,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    80001c18:	00238a97          	auipc	s5,0x238
    80001c1c:	a38a8a93          	addi	s5,s5,-1480 # 80239650 <tickslock>
        char *pa = kalloc();
    80001c20:	fffff097          	auipc	ra,0xfffff
    80001c24:	002080e7          	jalr	2(ra) # 80000c22 <kalloc>
    80001c28:	862a                	mv	a2,a0
        if (pa == 0)
    80001c2a:	c121                	beqz	a0,80001c6a <proc_mapstacks+0x94>
        uint64 va = KSTACK((int)(p - proc));
    80001c2c:	416485b3          	sub	a1,s1,s6
    80001c30:	858d                	srai	a1,a1,0x3
    80001c32:	032585b3          	mul	a1,a1,s2
    80001c36:	2585                	addiw	a1,a1,1
    80001c38:	00d5959b          	slliw	a1,a1,0xd
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001c3c:	4719                	li	a4,6
    80001c3e:	6685                	lui	a3,0x1
    80001c40:	40b985b3          	sub	a1,s3,a1
    80001c44:	8552                	mv	a0,s4
    80001c46:	fffff097          	auipc	ra,0xfffff
    80001c4a:	7b2080e7          	jalr	1970(ra) # 800013f8 <kvmmap>
    for (p = proc; p < &proc[NPROC]; p++)
    80001c4e:	16848493          	addi	s1,s1,360
    80001c52:	fd5497e3          	bne	s1,s5,80001c20 <proc_mapstacks+0x4a>
}
    80001c56:	70e2                	ld	ra,56(sp)
    80001c58:	7442                	ld	s0,48(sp)
    80001c5a:	74a2                	ld	s1,40(sp)
    80001c5c:	7902                	ld	s2,32(sp)
    80001c5e:	69e2                	ld	s3,24(sp)
    80001c60:	6a42                	ld	s4,16(sp)
    80001c62:	6aa2                	ld	s5,8(sp)
    80001c64:	6b02                	ld	s6,0(sp)
    80001c66:	6121                	addi	sp,sp,64
    80001c68:	8082                	ret
            panic("kalloc");
    80001c6a:	00006517          	auipc	a0,0x6
    80001c6e:	5b650513          	addi	a0,a0,1462 # 80008220 <__func__.1+0x218>
    80001c72:	fffff097          	auipc	ra,0xfffff
    80001c76:	8ee080e7          	jalr	-1810(ra) # 80000560 <panic>

0000000080001c7a <procinit>:
{
    80001c7a:	7139                	addi	sp,sp,-64
    80001c7c:	fc06                	sd	ra,56(sp)
    80001c7e:	f822                	sd	s0,48(sp)
    80001c80:	f426                	sd	s1,40(sp)
    80001c82:	f04a                	sd	s2,32(sp)
    80001c84:	ec4e                	sd	s3,24(sp)
    80001c86:	e852                	sd	s4,16(sp)
    80001c88:	e456                	sd	s5,8(sp)
    80001c8a:	e05a                	sd	s6,0(sp)
    80001c8c:	0080                	addi	s0,sp,64
    initlock(&pid_lock, "nextpid");
    80001c8e:	00006597          	auipc	a1,0x6
    80001c92:	59a58593          	addi	a1,a1,1434 # 80008228 <__func__.1+0x220>
    80001c96:	00232517          	auipc	a0,0x232
    80001c9a:	f8a50513          	addi	a0,a0,-118 # 80233c20 <pid_lock>
    80001c9e:	fffff097          	auipc	ra,0xfffff
    80001ca2:	16a080e7          	jalr	362(ra) # 80000e08 <initlock>
    initlock(&wait_lock, "wait_lock");
    80001ca6:	00006597          	auipc	a1,0x6
    80001caa:	58a58593          	addi	a1,a1,1418 # 80008230 <__func__.1+0x228>
    80001cae:	00232517          	auipc	a0,0x232
    80001cb2:	f8a50513          	addi	a0,a0,-118 # 80233c38 <wait_lock>
    80001cb6:	fffff097          	auipc	ra,0xfffff
    80001cba:	152080e7          	jalr	338(ra) # 80000e08 <initlock>
    for (p = proc; p < &proc[NPROC]; p++)
    80001cbe:	00232497          	auipc	s1,0x232
    80001cc2:	f9248493          	addi	s1,s1,-110 # 80233c50 <proc>
        initlock(&p->lock, "proc");
    80001cc6:	00006b17          	auipc	s6,0x6
    80001cca:	57ab0b13          	addi	s6,s6,1402 # 80008240 <__func__.1+0x238>
        p->kstack = KSTACK((int)(p - proc));
    80001cce:	8aa6                	mv	s5,s1
    80001cd0:	04fa5937          	lui	s2,0x4fa5
    80001cd4:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80001cd8:	0932                	slli	s2,s2,0xc
    80001cda:	fa590913          	addi	s2,s2,-91
    80001cde:	0932                	slli	s2,s2,0xc
    80001ce0:	fa590913          	addi	s2,s2,-91
    80001ce4:	0932                	slli	s2,s2,0xc
    80001ce6:	fa590913          	addi	s2,s2,-91
    80001cea:	040009b7          	lui	s3,0x4000
    80001cee:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001cf0:	09b2                	slli	s3,s3,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    80001cf2:	00238a17          	auipc	s4,0x238
    80001cf6:	95ea0a13          	addi	s4,s4,-1698 # 80239650 <tickslock>
        initlock(&p->lock, "proc");
    80001cfa:	85da                	mv	a1,s6
    80001cfc:	8526                	mv	a0,s1
    80001cfe:	fffff097          	auipc	ra,0xfffff
    80001d02:	10a080e7          	jalr	266(ra) # 80000e08 <initlock>
        p->state = UNUSED;
    80001d06:	0004ac23          	sw	zero,24(s1)
        p->kstack = KSTACK((int)(p - proc));
    80001d0a:	415487b3          	sub	a5,s1,s5
    80001d0e:	878d                	srai	a5,a5,0x3
    80001d10:	032787b3          	mul	a5,a5,s2
    80001d14:	2785                	addiw	a5,a5,1
    80001d16:	00d7979b          	slliw	a5,a5,0xd
    80001d1a:	40f987b3          	sub	a5,s3,a5
    80001d1e:	e0bc                	sd	a5,64(s1)
    for (p = proc; p < &proc[NPROC]; p++)
    80001d20:	16848493          	addi	s1,s1,360
    80001d24:	fd449be3          	bne	s1,s4,80001cfa <procinit+0x80>
}
    80001d28:	70e2                	ld	ra,56(sp)
    80001d2a:	7442                	ld	s0,48(sp)
    80001d2c:	74a2                	ld	s1,40(sp)
    80001d2e:	7902                	ld	s2,32(sp)
    80001d30:	69e2                	ld	s3,24(sp)
    80001d32:	6a42                	ld	s4,16(sp)
    80001d34:	6aa2                	ld	s5,8(sp)
    80001d36:	6b02                	ld	s6,0(sp)
    80001d38:	6121                	addi	sp,sp,64
    80001d3a:	8082                	ret

0000000080001d3c <copy_array>:
{
    80001d3c:	1141                	addi	sp,sp,-16
    80001d3e:	e422                	sd	s0,8(sp)
    80001d40:	0800                	addi	s0,sp,16
    for (int i = 0; i < len; i++)
    80001d42:	00c05c63          	blez	a2,80001d5a <copy_array+0x1e>
    80001d46:	87aa                	mv	a5,a0
    80001d48:	9532                	add	a0,a0,a2
        dst[i] = src[i];
    80001d4a:	0007c703          	lbu	a4,0(a5)
    80001d4e:	00e58023          	sb	a4,0(a1)
    for (int i = 0; i < len; i++)
    80001d52:	0785                	addi	a5,a5,1
    80001d54:	0585                	addi	a1,a1,1
    80001d56:	fea79ae3          	bne	a5,a0,80001d4a <copy_array+0xe>
}
    80001d5a:	6422                	ld	s0,8(sp)
    80001d5c:	0141                	addi	sp,sp,16
    80001d5e:	8082                	ret

0000000080001d60 <cpuid>:
{
    80001d60:	1141                	addi	sp,sp,-16
    80001d62:	e422                	sd	s0,8(sp)
    80001d64:	0800                	addi	s0,sp,16
    asm volatile("mv %0, tp" : "=r"(x));
    80001d66:	8512                	mv	a0,tp
}
    80001d68:	2501                	sext.w	a0,a0
    80001d6a:	6422                	ld	s0,8(sp)
    80001d6c:	0141                	addi	sp,sp,16
    80001d6e:	8082                	ret

0000000080001d70 <mycpu>:
{
    80001d70:	1141                	addi	sp,sp,-16
    80001d72:	e422                	sd	s0,8(sp)
    80001d74:	0800                	addi	s0,sp,16
    80001d76:	8792                	mv	a5,tp
    struct cpu *c = &cpus[id];
    80001d78:	2781                	sext.w	a5,a5
    80001d7a:	079e                	slli	a5,a5,0x7
}
    80001d7c:	00232517          	auipc	a0,0x232
    80001d80:	aa450513          	addi	a0,a0,-1372 # 80233820 <cpus>
    80001d84:	953e                	add	a0,a0,a5
    80001d86:	6422                	ld	s0,8(sp)
    80001d88:	0141                	addi	sp,sp,16
    80001d8a:	8082                	ret

0000000080001d8c <myproc>:
{
    80001d8c:	1101                	addi	sp,sp,-32
    80001d8e:	ec06                	sd	ra,24(sp)
    80001d90:	e822                	sd	s0,16(sp)
    80001d92:	e426                	sd	s1,8(sp)
    80001d94:	1000                	addi	s0,sp,32
    push_off();
    80001d96:	fffff097          	auipc	ra,0xfffff
    80001d9a:	0b6080e7          	jalr	182(ra) # 80000e4c <push_off>
    80001d9e:	8792                	mv	a5,tp
    struct proc *p = c->proc;
    80001da0:	2781                	sext.w	a5,a5
    80001da2:	079e                	slli	a5,a5,0x7
    80001da4:	00232717          	auipc	a4,0x232
    80001da8:	a7c70713          	addi	a4,a4,-1412 # 80233820 <cpus>
    80001dac:	97ba                	add	a5,a5,a4
    80001dae:	6384                	ld	s1,0(a5)
    pop_off();
    80001db0:	fffff097          	auipc	ra,0xfffff
    80001db4:	13c080e7          	jalr	316(ra) # 80000eec <pop_off>
}
    80001db8:	8526                	mv	a0,s1
    80001dba:	60e2                	ld	ra,24(sp)
    80001dbc:	6442                	ld	s0,16(sp)
    80001dbe:	64a2                	ld	s1,8(sp)
    80001dc0:	6105                	addi	sp,sp,32
    80001dc2:	8082                	ret

0000000080001dc4 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80001dc4:	1141                	addi	sp,sp,-16
    80001dc6:	e406                	sd	ra,8(sp)
    80001dc8:	e022                	sd	s0,0(sp)
    80001dca:	0800                	addi	s0,sp,16
    static int first = 1;

    // Still holding p->lock from scheduler.
    release(&myproc()->lock);
    80001dcc:	00000097          	auipc	ra,0x0
    80001dd0:	fc0080e7          	jalr	-64(ra) # 80001d8c <myproc>
    80001dd4:	fffff097          	auipc	ra,0xfffff
    80001dd8:	178080e7          	jalr	376(ra) # 80000f4c <release>

    if (first)
    80001ddc:	00009797          	auipc	a5,0x9
    80001de0:	6f47a783          	lw	a5,1780(a5) # 8000b4d0 <first.1>
    80001de4:	eb89                	bnez	a5,80001df6 <forkret+0x32>
        // be run from main().
        first = 0;
        fsinit(ROOTDEV);
    }

    usertrapret();
    80001de6:	00001097          	auipc	ra,0x1
    80001dea:	e76080e7          	jalr	-394(ra) # 80002c5c <usertrapret>
}
    80001dee:	60a2                	ld	ra,8(sp)
    80001df0:	6402                	ld	s0,0(sp)
    80001df2:	0141                	addi	sp,sp,16
    80001df4:	8082                	ret
        first = 0;
    80001df6:	00009797          	auipc	a5,0x9
    80001dfa:	6c07ad23          	sw	zero,1754(a5) # 8000b4d0 <first.1>
        fsinit(ROOTDEV);
    80001dfe:	4505                	li	a0,1
    80001e00:	00002097          	auipc	ra,0x2
    80001e04:	dbe080e7          	jalr	-578(ra) # 80003bbe <fsinit>
    80001e08:	bff9                	j	80001de6 <forkret+0x22>

0000000080001e0a <allocpid>:
{
    80001e0a:	1101                	addi	sp,sp,-32
    80001e0c:	ec06                	sd	ra,24(sp)
    80001e0e:	e822                	sd	s0,16(sp)
    80001e10:	e426                	sd	s1,8(sp)
    80001e12:	e04a                	sd	s2,0(sp)
    80001e14:	1000                	addi	s0,sp,32
    acquire(&pid_lock);
    80001e16:	00232917          	auipc	s2,0x232
    80001e1a:	e0a90913          	addi	s2,s2,-502 # 80233c20 <pid_lock>
    80001e1e:	854a                	mv	a0,s2
    80001e20:	fffff097          	auipc	ra,0xfffff
    80001e24:	078080e7          	jalr	120(ra) # 80000e98 <acquire>
    pid = nextpid;
    80001e28:	00009797          	auipc	a5,0x9
    80001e2c:	6b878793          	addi	a5,a5,1720 # 8000b4e0 <nextpid>
    80001e30:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    80001e32:	0014871b          	addiw	a4,s1,1
    80001e36:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    80001e38:	854a                	mv	a0,s2
    80001e3a:	fffff097          	auipc	ra,0xfffff
    80001e3e:	112080e7          	jalr	274(ra) # 80000f4c <release>
}
    80001e42:	8526                	mv	a0,s1
    80001e44:	60e2                	ld	ra,24(sp)
    80001e46:	6442                	ld	s0,16(sp)
    80001e48:	64a2                	ld	s1,8(sp)
    80001e4a:	6902                	ld	s2,0(sp)
    80001e4c:	6105                	addi	sp,sp,32
    80001e4e:	8082                	ret

0000000080001e50 <proc_pagetable>:
{
    80001e50:	1101                	addi	sp,sp,-32
    80001e52:	ec06                	sd	ra,24(sp)
    80001e54:	e822                	sd	s0,16(sp)
    80001e56:	e426                	sd	s1,8(sp)
    80001e58:	e04a                	sd	s2,0(sp)
    80001e5a:	1000                	addi	s0,sp,32
    80001e5c:	892a                	mv	s2,a0
    pagetable = uvmcreate();
    80001e5e:	fffff097          	auipc	ra,0xfffff
    80001e62:	776080e7          	jalr	1910(ra) # 800015d4 <uvmcreate>
    80001e66:	84aa                	mv	s1,a0
    if (pagetable == 0)
    80001e68:	c121                	beqz	a0,80001ea8 <proc_pagetable+0x58>
    if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001e6a:	4729                	li	a4,10
    80001e6c:	00005697          	auipc	a3,0x5
    80001e70:	19468693          	addi	a3,a3,404 # 80007000 <_trampoline>
    80001e74:	6605                	lui	a2,0x1
    80001e76:	040005b7          	lui	a1,0x4000
    80001e7a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001e7c:	05b2                	slli	a1,a1,0xc
    80001e7e:	fffff097          	auipc	ra,0xfffff
    80001e82:	4da080e7          	jalr	1242(ra) # 80001358 <mappages>
    80001e86:	02054863          	bltz	a0,80001eb6 <proc_pagetable+0x66>
    if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80001e8a:	4719                	li	a4,6
    80001e8c:	05893683          	ld	a3,88(s2)
    80001e90:	6605                	lui	a2,0x1
    80001e92:	020005b7          	lui	a1,0x2000
    80001e96:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001e98:	05b6                	slli	a1,a1,0xd
    80001e9a:	8526                	mv	a0,s1
    80001e9c:	fffff097          	auipc	ra,0xfffff
    80001ea0:	4bc080e7          	jalr	1212(ra) # 80001358 <mappages>
    80001ea4:	02054163          	bltz	a0,80001ec6 <proc_pagetable+0x76>
}
    80001ea8:	8526                	mv	a0,s1
    80001eaa:	60e2                	ld	ra,24(sp)
    80001eac:	6442                	ld	s0,16(sp)
    80001eae:	64a2                	ld	s1,8(sp)
    80001eb0:	6902                	ld	s2,0(sp)
    80001eb2:	6105                	addi	sp,sp,32
    80001eb4:	8082                	ret
        uvmfree(pagetable, 0);
    80001eb6:	4581                	li	a1,0
    80001eb8:	8526                	mv	a0,s1
    80001eba:	00000097          	auipc	ra,0x0
    80001ebe:	92c080e7          	jalr	-1748(ra) # 800017e6 <uvmfree>
        return 0;
    80001ec2:	4481                	li	s1,0
    80001ec4:	b7d5                	j	80001ea8 <proc_pagetable+0x58>
        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001ec6:	4681                	li	a3,0
    80001ec8:	4605                	li	a2,1
    80001eca:	040005b7          	lui	a1,0x4000
    80001ece:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001ed0:	05b2                	slli	a1,a1,0xc
    80001ed2:	8526                	mv	a0,s1
    80001ed4:	fffff097          	auipc	ra,0xfffff
    80001ed8:	64a080e7          	jalr	1610(ra) # 8000151e <uvmunmap>
        uvmfree(pagetable, 0);
    80001edc:	4581                	li	a1,0
    80001ede:	8526                	mv	a0,s1
    80001ee0:	00000097          	auipc	ra,0x0
    80001ee4:	906080e7          	jalr	-1786(ra) # 800017e6 <uvmfree>
        return 0;
    80001ee8:	4481                	li	s1,0
    80001eea:	bf7d                	j	80001ea8 <proc_pagetable+0x58>

0000000080001eec <proc_freepagetable>:
{
    80001eec:	1101                	addi	sp,sp,-32
    80001eee:	ec06                	sd	ra,24(sp)
    80001ef0:	e822                	sd	s0,16(sp)
    80001ef2:	e426                	sd	s1,8(sp)
    80001ef4:	e04a                	sd	s2,0(sp)
    80001ef6:	1000                	addi	s0,sp,32
    80001ef8:	84aa                	mv	s1,a0
    80001efa:	892e                	mv	s2,a1
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001efc:	4681                	li	a3,0
    80001efe:	4605                	li	a2,1
    80001f00:	040005b7          	lui	a1,0x4000
    80001f04:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001f06:	05b2                	slli	a1,a1,0xc
    80001f08:	fffff097          	auipc	ra,0xfffff
    80001f0c:	616080e7          	jalr	1558(ra) # 8000151e <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001f10:	4681                	li	a3,0
    80001f12:	4605                	li	a2,1
    80001f14:	020005b7          	lui	a1,0x2000
    80001f18:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001f1a:	05b6                	slli	a1,a1,0xd
    80001f1c:	8526                	mv	a0,s1
    80001f1e:	fffff097          	auipc	ra,0xfffff
    80001f22:	600080e7          	jalr	1536(ra) # 8000151e <uvmunmap>
    uvmfree(pagetable, sz);
    80001f26:	85ca                	mv	a1,s2
    80001f28:	8526                	mv	a0,s1
    80001f2a:	00000097          	auipc	ra,0x0
    80001f2e:	8bc080e7          	jalr	-1860(ra) # 800017e6 <uvmfree>
}
    80001f32:	60e2                	ld	ra,24(sp)
    80001f34:	6442                	ld	s0,16(sp)
    80001f36:	64a2                	ld	s1,8(sp)
    80001f38:	6902                	ld	s2,0(sp)
    80001f3a:	6105                	addi	sp,sp,32
    80001f3c:	8082                	ret

0000000080001f3e <freeproc>:
{
    80001f3e:	1101                	addi	sp,sp,-32
    80001f40:	ec06                	sd	ra,24(sp)
    80001f42:	e822                	sd	s0,16(sp)
    80001f44:	e426                	sd	s1,8(sp)
    80001f46:	1000                	addi	s0,sp,32
    80001f48:	84aa                	mv	s1,a0
    if (p->trapframe)
    80001f4a:	6d28                	ld	a0,88(a0)
    80001f4c:	c509                	beqz	a0,80001f56 <freeproc+0x18>
        kfree((void *)p->trapframe);
    80001f4e:	fffff097          	auipc	ra,0xfffff
    80001f52:	b0e080e7          	jalr	-1266(ra) # 80000a5c <kfree>
    p->trapframe = 0;
    80001f56:	0404bc23          	sd	zero,88(s1)
    if (p->pagetable)
    80001f5a:	68a8                	ld	a0,80(s1)
    80001f5c:	c511                	beqz	a0,80001f68 <freeproc+0x2a>
        proc_freepagetable(p->pagetable, p->sz);
    80001f5e:	64ac                	ld	a1,72(s1)
    80001f60:	00000097          	auipc	ra,0x0
    80001f64:	f8c080e7          	jalr	-116(ra) # 80001eec <proc_freepagetable>
    p->pagetable = 0;
    80001f68:	0404b823          	sd	zero,80(s1)
    p->sz = 0;
    80001f6c:	0404b423          	sd	zero,72(s1)
    p->pid = 0;
    80001f70:	0204a823          	sw	zero,48(s1)
    p->parent = 0;
    80001f74:	0204bc23          	sd	zero,56(s1)
    p->name[0] = 0;
    80001f78:	14048c23          	sb	zero,344(s1)
    p->chan = 0;
    80001f7c:	0204b023          	sd	zero,32(s1)
    p->killed = 0;
    80001f80:	0204a423          	sw	zero,40(s1)
    p->xstate = 0;
    80001f84:	0204a623          	sw	zero,44(s1)
    p->state = UNUSED;
    80001f88:	0004ac23          	sw	zero,24(s1)
}
    80001f8c:	60e2                	ld	ra,24(sp)
    80001f8e:	6442                	ld	s0,16(sp)
    80001f90:	64a2                	ld	s1,8(sp)
    80001f92:	6105                	addi	sp,sp,32
    80001f94:	8082                	ret

0000000080001f96 <allocproc>:
{
    80001f96:	1101                	addi	sp,sp,-32
    80001f98:	ec06                	sd	ra,24(sp)
    80001f9a:	e822                	sd	s0,16(sp)
    80001f9c:	e426                	sd	s1,8(sp)
    80001f9e:	e04a                	sd	s2,0(sp)
    80001fa0:	1000                	addi	s0,sp,32
    for (p = proc; p < &proc[NPROC]; p++)
    80001fa2:	00232497          	auipc	s1,0x232
    80001fa6:	cae48493          	addi	s1,s1,-850 # 80233c50 <proc>
    80001faa:	00237917          	auipc	s2,0x237
    80001fae:	6a690913          	addi	s2,s2,1702 # 80239650 <tickslock>
        acquire(&p->lock);
    80001fb2:	8526                	mv	a0,s1
    80001fb4:	fffff097          	auipc	ra,0xfffff
    80001fb8:	ee4080e7          	jalr	-284(ra) # 80000e98 <acquire>
        if (p->state == UNUSED)
    80001fbc:	4c9c                	lw	a5,24(s1)
    80001fbe:	cf81                	beqz	a5,80001fd6 <allocproc+0x40>
            release(&p->lock);
    80001fc0:	8526                	mv	a0,s1
    80001fc2:	fffff097          	auipc	ra,0xfffff
    80001fc6:	f8a080e7          	jalr	-118(ra) # 80000f4c <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80001fca:	16848493          	addi	s1,s1,360
    80001fce:	ff2492e3          	bne	s1,s2,80001fb2 <allocproc+0x1c>
    return 0;
    80001fd2:	4481                	li	s1,0
    80001fd4:	a889                	j	80002026 <allocproc+0x90>
    p->pid = allocpid();
    80001fd6:	00000097          	auipc	ra,0x0
    80001fda:	e34080e7          	jalr	-460(ra) # 80001e0a <allocpid>
    80001fde:	d888                	sw	a0,48(s1)
    p->state = USED;
    80001fe0:	4785                	li	a5,1
    80001fe2:	cc9c                	sw	a5,24(s1)
    if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    80001fe4:	fffff097          	auipc	ra,0xfffff
    80001fe8:	c3e080e7          	jalr	-962(ra) # 80000c22 <kalloc>
    80001fec:	892a                	mv	s2,a0
    80001fee:	eca8                	sd	a0,88(s1)
    80001ff0:	c131                	beqz	a0,80002034 <allocproc+0x9e>
    p->pagetable = proc_pagetable(p);
    80001ff2:	8526                	mv	a0,s1
    80001ff4:	00000097          	auipc	ra,0x0
    80001ff8:	e5c080e7          	jalr	-420(ra) # 80001e50 <proc_pagetable>
    80001ffc:	892a                	mv	s2,a0
    80001ffe:	e8a8                	sd	a0,80(s1)
    if (p->pagetable == 0)
    80002000:	c531                	beqz	a0,8000204c <allocproc+0xb6>
    memset(&p->context, 0, sizeof(p->context));
    80002002:	07000613          	li	a2,112
    80002006:	4581                	li	a1,0
    80002008:	06048513          	addi	a0,s1,96
    8000200c:	fffff097          	auipc	ra,0xfffff
    80002010:	f88080e7          	jalr	-120(ra) # 80000f94 <memset>
    p->context.ra = (uint64)forkret;
    80002014:	00000797          	auipc	a5,0x0
    80002018:	db078793          	addi	a5,a5,-592 # 80001dc4 <forkret>
    8000201c:	f0bc                	sd	a5,96(s1)
    p->context.sp = p->kstack + PGSIZE;
    8000201e:	60bc                	ld	a5,64(s1)
    80002020:	6705                	lui	a4,0x1
    80002022:	97ba                	add	a5,a5,a4
    80002024:	f4bc                	sd	a5,104(s1)
}
    80002026:	8526                	mv	a0,s1
    80002028:	60e2                	ld	ra,24(sp)
    8000202a:	6442                	ld	s0,16(sp)
    8000202c:	64a2                	ld	s1,8(sp)
    8000202e:	6902                	ld	s2,0(sp)
    80002030:	6105                	addi	sp,sp,32
    80002032:	8082                	ret
        freeproc(p);
    80002034:	8526                	mv	a0,s1
    80002036:	00000097          	auipc	ra,0x0
    8000203a:	f08080e7          	jalr	-248(ra) # 80001f3e <freeproc>
        release(&p->lock);
    8000203e:	8526                	mv	a0,s1
    80002040:	fffff097          	auipc	ra,0xfffff
    80002044:	f0c080e7          	jalr	-244(ra) # 80000f4c <release>
        return 0;
    80002048:	84ca                	mv	s1,s2
    8000204a:	bff1                	j	80002026 <allocproc+0x90>
        freeproc(p);
    8000204c:	8526                	mv	a0,s1
    8000204e:	00000097          	auipc	ra,0x0
    80002052:	ef0080e7          	jalr	-272(ra) # 80001f3e <freeproc>
        release(&p->lock);
    80002056:	8526                	mv	a0,s1
    80002058:	fffff097          	auipc	ra,0xfffff
    8000205c:	ef4080e7          	jalr	-268(ra) # 80000f4c <release>
        return 0;
    80002060:	84ca                	mv	s1,s2
    80002062:	b7d1                	j	80002026 <allocproc+0x90>

0000000080002064 <userinit>:
{
    80002064:	1101                	addi	sp,sp,-32
    80002066:	ec06                	sd	ra,24(sp)
    80002068:	e822                	sd	s0,16(sp)
    8000206a:	e426                	sd	s1,8(sp)
    8000206c:	1000                	addi	s0,sp,32
    p = allocproc();
    8000206e:	00000097          	auipc	ra,0x0
    80002072:	f28080e7          	jalr	-216(ra) # 80001f96 <allocproc>
    80002076:	84aa                	mv	s1,a0
    initproc = p;
    80002078:	00009797          	auipc	a5,0x9
    8000207c:	52a7b823          	sd	a0,1328(a5) # 8000b5a8 <initproc>
    uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80002080:	03400613          	li	a2,52
    80002084:	00009597          	auipc	a1,0x9
    80002088:	46c58593          	addi	a1,a1,1132 # 8000b4f0 <initcode>
    8000208c:	6928                	ld	a0,80(a0)
    8000208e:	fffff097          	auipc	ra,0xfffff
    80002092:	574080e7          	jalr	1396(ra) # 80001602 <uvmfirst>
    p->sz = PGSIZE;
    80002096:	6785                	lui	a5,0x1
    80002098:	e4bc                	sd	a5,72(s1)
    p->trapframe->epc = 0;     // user program counter
    8000209a:	6cb8                	ld	a4,88(s1)
    8000209c:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    p->trapframe->sp = PGSIZE; // user stack pointer
    800020a0:	6cb8                	ld	a4,88(s1)
    800020a2:	fb1c                	sd	a5,48(a4)
    safestrcpy(p->name, "initcode", sizeof(p->name));
    800020a4:	4641                	li	a2,16
    800020a6:	00006597          	auipc	a1,0x6
    800020aa:	1a258593          	addi	a1,a1,418 # 80008248 <__func__.1+0x240>
    800020ae:	15848513          	addi	a0,s1,344
    800020b2:	fffff097          	auipc	ra,0xfffff
    800020b6:	024080e7          	jalr	36(ra) # 800010d6 <safestrcpy>
    p->cwd = namei("/");
    800020ba:	00006517          	auipc	a0,0x6
    800020be:	19e50513          	addi	a0,a0,414 # 80008258 <__func__.1+0x250>
    800020c2:	00002097          	auipc	ra,0x2
    800020c6:	54e080e7          	jalr	1358(ra) # 80004610 <namei>
    800020ca:	14a4b823          	sd	a0,336(s1)
    p->state = RUNNABLE;
    800020ce:	478d                	li	a5,3
    800020d0:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    800020d2:	8526                	mv	a0,s1
    800020d4:	fffff097          	auipc	ra,0xfffff
    800020d8:	e78080e7          	jalr	-392(ra) # 80000f4c <release>
}
    800020dc:	60e2                	ld	ra,24(sp)
    800020de:	6442                	ld	s0,16(sp)
    800020e0:	64a2                	ld	s1,8(sp)
    800020e2:	6105                	addi	sp,sp,32
    800020e4:	8082                	ret

00000000800020e6 <growproc>:
{
    800020e6:	1101                	addi	sp,sp,-32
    800020e8:	ec06                	sd	ra,24(sp)
    800020ea:	e822                	sd	s0,16(sp)
    800020ec:	e426                	sd	s1,8(sp)
    800020ee:	e04a                	sd	s2,0(sp)
    800020f0:	1000                	addi	s0,sp,32
    800020f2:	892a                	mv	s2,a0
    struct proc *p = myproc();
    800020f4:	00000097          	auipc	ra,0x0
    800020f8:	c98080e7          	jalr	-872(ra) # 80001d8c <myproc>
    800020fc:	84aa                	mv	s1,a0
    sz = p->sz;
    800020fe:	652c                	ld	a1,72(a0)
    if (n > 0)
    80002100:	01204c63          	bgtz	s2,80002118 <growproc+0x32>
    else if (n < 0)
    80002104:	02094663          	bltz	s2,80002130 <growproc+0x4a>
    p->sz = sz;
    80002108:	e4ac                	sd	a1,72(s1)
    return 0;
    8000210a:	4501                	li	a0,0
}
    8000210c:	60e2                	ld	ra,24(sp)
    8000210e:	6442                	ld	s0,16(sp)
    80002110:	64a2                	ld	s1,8(sp)
    80002112:	6902                	ld	s2,0(sp)
    80002114:	6105                	addi	sp,sp,32
    80002116:	8082                	ret
        if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    80002118:	4691                	li	a3,4
    8000211a:	00b90633          	add	a2,s2,a1
    8000211e:	6928                	ld	a0,80(a0)
    80002120:	fffff097          	auipc	ra,0xfffff
    80002124:	59c080e7          	jalr	1436(ra) # 800016bc <uvmalloc>
    80002128:	85aa                	mv	a1,a0
    8000212a:	fd79                	bnez	a0,80002108 <growproc+0x22>
            return -1;
    8000212c:	557d                	li	a0,-1
    8000212e:	bff9                	j	8000210c <growproc+0x26>
        sz = uvmdealloc(p->pagetable, sz, sz + n);
    80002130:	00b90633          	add	a2,s2,a1
    80002134:	6928                	ld	a0,80(a0)
    80002136:	fffff097          	auipc	ra,0xfffff
    8000213a:	53e080e7          	jalr	1342(ra) # 80001674 <uvmdealloc>
    8000213e:	85aa                	mv	a1,a0
    80002140:	b7e1                	j	80002108 <growproc+0x22>

0000000080002142 <ps>:
{
    80002142:	715d                	addi	sp,sp,-80
    80002144:	e486                	sd	ra,72(sp)
    80002146:	e0a2                	sd	s0,64(sp)
    80002148:	fc26                	sd	s1,56(sp)
    8000214a:	f84a                	sd	s2,48(sp)
    8000214c:	f44e                	sd	s3,40(sp)
    8000214e:	f052                	sd	s4,32(sp)
    80002150:	ec56                	sd	s5,24(sp)
    80002152:	e85a                	sd	s6,16(sp)
    80002154:	e45e                	sd	s7,8(sp)
    80002156:	e062                	sd	s8,0(sp)
    80002158:	0880                	addi	s0,sp,80
    8000215a:	84aa                	mv	s1,a0
    8000215c:	8bae                	mv	s7,a1
    void *result = (void *)myproc()->sz;
    8000215e:	00000097          	auipc	ra,0x0
    80002162:	c2e080e7          	jalr	-978(ra) # 80001d8c <myproc>
        return result;
    80002166:	4901                	li	s2,0
    if (count == 0)
    80002168:	0c0b8663          	beqz	s7,80002234 <ps+0xf2>
    void *result = (void *)myproc()->sz;
    8000216c:	04853b03          	ld	s6,72(a0)
    if (growproc(count * sizeof(struct user_proc)) < 0)
    80002170:	003b951b          	slliw	a0,s7,0x3
    80002174:	0175053b          	addw	a0,a0,s7
    80002178:	0025151b          	slliw	a0,a0,0x2
    8000217c:	2501                	sext.w	a0,a0
    8000217e:	00000097          	auipc	ra,0x0
    80002182:	f68080e7          	jalr	-152(ra) # 800020e6 <growproc>
    80002186:	12054f63          	bltz	a0,800022c4 <ps+0x182>
    struct user_proc loc_result[count];
    8000218a:	003b9a13          	slli	s4,s7,0x3
    8000218e:	9a5e                	add	s4,s4,s7
    80002190:	0a0a                	slli	s4,s4,0x2
    80002192:	00fa0793          	addi	a5,s4,15
    80002196:	8391                	srli	a5,a5,0x4
    80002198:	0792                	slli	a5,a5,0x4
    8000219a:	40f10133          	sub	sp,sp,a5
    8000219e:	8a8a                	mv	s5,sp
    struct proc *p = proc + start;
    800021a0:	16800793          	li	a5,360
    800021a4:	02f484b3          	mul	s1,s1,a5
    800021a8:	00232797          	auipc	a5,0x232
    800021ac:	aa878793          	addi	a5,a5,-1368 # 80233c50 <proc>
    800021b0:	94be                	add	s1,s1,a5
    if (p >= &proc[NPROC])
    800021b2:	00237797          	auipc	a5,0x237
    800021b6:	49e78793          	addi	a5,a5,1182 # 80239650 <tickslock>
        return result;
    800021ba:	4901                	li	s2,0
    if (p >= &proc[NPROC])
    800021bc:	06f4fc63          	bgeu	s1,a5,80002234 <ps+0xf2>
    acquire(&wait_lock);
    800021c0:	00232517          	auipc	a0,0x232
    800021c4:	a7850513          	addi	a0,a0,-1416 # 80233c38 <wait_lock>
    800021c8:	fffff097          	auipc	ra,0xfffff
    800021cc:	cd0080e7          	jalr	-816(ra) # 80000e98 <acquire>
        if (localCount == count)
    800021d0:	014a8913          	addi	s2,s5,20
    uint8 localCount = 0;
    800021d4:	4981                	li	s3,0
    for (; p < &proc[NPROC]; p++)
    800021d6:	00237c17          	auipc	s8,0x237
    800021da:	47ac0c13          	addi	s8,s8,1146 # 80239650 <tickslock>
    800021de:	a851                	j	80002272 <ps+0x130>
            loc_result[localCount].state = UNUSED;
    800021e0:	00399793          	slli	a5,s3,0x3
    800021e4:	97ce                	add	a5,a5,s3
    800021e6:	078a                	slli	a5,a5,0x2
    800021e8:	97d6                	add	a5,a5,s5
    800021ea:	0007a023          	sw	zero,0(a5)
            release(&p->lock);
    800021ee:	8526                	mv	a0,s1
    800021f0:	fffff097          	auipc	ra,0xfffff
    800021f4:	d5c080e7          	jalr	-676(ra) # 80000f4c <release>
    release(&wait_lock);
    800021f8:	00232517          	auipc	a0,0x232
    800021fc:	a4050513          	addi	a0,a0,-1472 # 80233c38 <wait_lock>
    80002200:	fffff097          	auipc	ra,0xfffff
    80002204:	d4c080e7          	jalr	-692(ra) # 80000f4c <release>
    if (localCount < count)
    80002208:	0179f963          	bgeu	s3,s7,8000221a <ps+0xd8>
        loc_result[localCount].state = UNUSED; // if we reach the end of processes
    8000220c:	00399793          	slli	a5,s3,0x3
    80002210:	97ce                	add	a5,a5,s3
    80002212:	078a                	slli	a5,a5,0x2
    80002214:	97d6                	add	a5,a5,s5
    80002216:	0007a023          	sw	zero,0(a5)
    void *result = (void *)myproc()->sz;
    8000221a:	895a                	mv	s2,s6
    copyout(myproc()->pagetable, (uint64)result, (void *)loc_result, count * sizeof(struct user_proc));
    8000221c:	00000097          	auipc	ra,0x0
    80002220:	b70080e7          	jalr	-1168(ra) # 80001d8c <myproc>
    80002224:	86d2                	mv	a3,s4
    80002226:	8656                	mv	a2,s5
    80002228:	85da                	mv	a1,s6
    8000222a:	6928                	ld	a0,80(a0)
    8000222c:	fffff097          	auipc	ra,0xfffff
    80002230:	704080e7          	jalr	1796(ra) # 80001930 <copyout>
}
    80002234:	854a                	mv	a0,s2
    80002236:	fb040113          	addi	sp,s0,-80
    8000223a:	60a6                	ld	ra,72(sp)
    8000223c:	6406                	ld	s0,64(sp)
    8000223e:	74e2                	ld	s1,56(sp)
    80002240:	7942                	ld	s2,48(sp)
    80002242:	79a2                	ld	s3,40(sp)
    80002244:	7a02                	ld	s4,32(sp)
    80002246:	6ae2                	ld	s5,24(sp)
    80002248:	6b42                	ld	s6,16(sp)
    8000224a:	6ba2                	ld	s7,8(sp)
    8000224c:	6c02                	ld	s8,0(sp)
    8000224e:	6161                	addi	sp,sp,80
    80002250:	8082                	ret
        release(&p->lock);
    80002252:	8526                	mv	a0,s1
    80002254:	fffff097          	auipc	ra,0xfffff
    80002258:	cf8080e7          	jalr	-776(ra) # 80000f4c <release>
        localCount++;
    8000225c:	2985                	addiw	s3,s3,1
    8000225e:	0ff9f993          	zext.b	s3,s3
    for (; p < &proc[NPROC]; p++)
    80002262:	16848493          	addi	s1,s1,360
    80002266:	f984f9e3          	bgeu	s1,s8,800021f8 <ps+0xb6>
        if (localCount == count)
    8000226a:	02490913          	addi	s2,s2,36
    8000226e:	053b8d63          	beq	s7,s3,800022c8 <ps+0x186>
        acquire(&p->lock);
    80002272:	8526                	mv	a0,s1
    80002274:	fffff097          	auipc	ra,0xfffff
    80002278:	c24080e7          	jalr	-988(ra) # 80000e98 <acquire>
        if (p->state == UNUSED)
    8000227c:	4c9c                	lw	a5,24(s1)
    8000227e:	d3ad                	beqz	a5,800021e0 <ps+0x9e>
        loc_result[localCount].state = p->state;
    80002280:	fef92623          	sw	a5,-20(s2)
        loc_result[localCount].killed = p->killed;
    80002284:	549c                	lw	a5,40(s1)
    80002286:	fef92823          	sw	a5,-16(s2)
        loc_result[localCount].xstate = p->xstate;
    8000228a:	54dc                	lw	a5,44(s1)
    8000228c:	fef92a23          	sw	a5,-12(s2)
        loc_result[localCount].pid = p->pid;
    80002290:	589c                	lw	a5,48(s1)
    80002292:	fef92c23          	sw	a5,-8(s2)
        copy_array(p->name, loc_result[localCount].name, 16);
    80002296:	4641                	li	a2,16
    80002298:	85ca                	mv	a1,s2
    8000229a:	15848513          	addi	a0,s1,344
    8000229e:	00000097          	auipc	ra,0x0
    800022a2:	a9e080e7          	jalr	-1378(ra) # 80001d3c <copy_array>
        if (p->parent != 0) // init
    800022a6:	7c88                	ld	a0,56(s1)
    800022a8:	d54d                	beqz	a0,80002252 <ps+0x110>
            acquire(&p->parent->lock);
    800022aa:	fffff097          	auipc	ra,0xfffff
    800022ae:	bee080e7          	jalr	-1042(ra) # 80000e98 <acquire>
            loc_result[localCount].parent_id = p->parent->pid;
    800022b2:	7c88                	ld	a0,56(s1)
    800022b4:	591c                	lw	a5,48(a0)
    800022b6:	fef92e23          	sw	a5,-4(s2)
            release(&p->parent->lock);
    800022ba:	fffff097          	auipc	ra,0xfffff
    800022be:	c92080e7          	jalr	-878(ra) # 80000f4c <release>
    800022c2:	bf41                	j	80002252 <ps+0x110>
        return result;
    800022c4:	4901                	li	s2,0
    800022c6:	b7bd                	j	80002234 <ps+0xf2>
    release(&wait_lock);
    800022c8:	00232517          	auipc	a0,0x232
    800022cc:	97050513          	addi	a0,a0,-1680 # 80233c38 <wait_lock>
    800022d0:	fffff097          	auipc	ra,0xfffff
    800022d4:	c7c080e7          	jalr	-900(ra) # 80000f4c <release>
    if (localCount < count)
    800022d8:	b789                	j	8000221a <ps+0xd8>

00000000800022da <fork>:
{
    800022da:	7139                	addi	sp,sp,-64
    800022dc:	fc06                	sd	ra,56(sp)
    800022de:	f822                	sd	s0,48(sp)
    800022e0:	f04a                	sd	s2,32(sp)
    800022e2:	e456                	sd	s5,8(sp)
    800022e4:	0080                	addi	s0,sp,64
    struct proc *p = myproc();
    800022e6:	00000097          	auipc	ra,0x0
    800022ea:	aa6080e7          	jalr	-1370(ra) # 80001d8c <myproc>
    800022ee:	8aaa                	mv	s5,a0
    if ((np = allocproc()) == 0) {
    800022f0:	00000097          	auipc	ra,0x0
    800022f4:	ca6080e7          	jalr	-858(ra) # 80001f96 <allocproc>
    800022f8:	12050063          	beqz	a0,80002418 <fork+0x13e>
    800022fc:	e852                	sd	s4,16(sp)
    800022fe:	8a2a                	mv	s4,a0
    if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    80002300:	048ab603          	ld	a2,72(s5)
    80002304:	692c                	ld	a1,80(a0)
    80002306:	050ab503          	ld	a0,80(s5)
    8000230a:	fffff097          	auipc	ra,0xfffff
    8000230e:	516080e7          	jalr	1302(ra) # 80001820 <uvmcopy>
    80002312:	04054a63          	bltz	a0,80002366 <fork+0x8c>
    80002316:	f426                	sd	s1,40(sp)
    80002318:	ec4e                	sd	s3,24(sp)
    np->sz = p->sz;
    8000231a:	048ab783          	ld	a5,72(s5)
    8000231e:	04fa3423          	sd	a5,72(s4)
    *(np->trapframe) = *(p->trapframe);
    80002322:	058ab683          	ld	a3,88(s5)
    80002326:	87b6                	mv	a5,a3
    80002328:	058a3703          	ld	a4,88(s4)
    8000232c:	12068693          	addi	a3,a3,288
    80002330:	0007b803          	ld	a6,0(a5)
    80002334:	6788                	ld	a0,8(a5)
    80002336:	6b8c                	ld	a1,16(a5)
    80002338:	6f90                	ld	a2,24(a5)
    8000233a:	01073023          	sd	a6,0(a4)
    8000233e:	e708                	sd	a0,8(a4)
    80002340:	eb0c                	sd	a1,16(a4)
    80002342:	ef10                	sd	a2,24(a4)
    80002344:	02078793          	addi	a5,a5,32
    80002348:	02070713          	addi	a4,a4,32
    8000234c:	fed792e3          	bne	a5,a3,80002330 <fork+0x56>
    np->trapframe->a0 = 0;
    80002350:	058a3783          	ld	a5,88(s4)
    80002354:	0607b823          	sd	zero,112(a5)
    for (i = 0; i < NOFILE; i++) {
    80002358:	0d0a8493          	addi	s1,s5,208
    8000235c:	0d0a0913          	addi	s2,s4,208
    80002360:	150a8993          	addi	s3,s5,336
    80002364:	a015                	j	80002388 <fork+0xae>
        freeproc(np);
    80002366:	8552                	mv	a0,s4
    80002368:	00000097          	auipc	ra,0x0
    8000236c:	bd6080e7          	jalr	-1066(ra) # 80001f3e <freeproc>
        release(&np->lock);
    80002370:	8552                	mv	a0,s4
    80002372:	fffff097          	auipc	ra,0xfffff
    80002376:	bda080e7          	jalr	-1062(ra) # 80000f4c <release>
        return -1;
    8000237a:	597d                	li	s2,-1
    8000237c:	6a42                	ld	s4,16(sp)
    8000237e:	a071                	j	8000240a <fork+0x130>
    for (i = 0; i < NOFILE; i++) {
    80002380:	04a1                	addi	s1,s1,8
    80002382:	0921                	addi	s2,s2,8
    80002384:	01348b63          	beq	s1,s3,8000239a <fork+0xc0>
        if (p->ofile[i])
    80002388:	6088                	ld	a0,0(s1)
    8000238a:	d97d                	beqz	a0,80002380 <fork+0xa6>
            np->ofile[i] = filedup(p->ofile[i]);
    8000238c:	00003097          	auipc	ra,0x3
    80002390:	8fc080e7          	jalr	-1796(ra) # 80004c88 <filedup>
    80002394:	00a93023          	sd	a0,0(s2)
    80002398:	b7e5                	j	80002380 <fork+0xa6>
    np->cwd = idup(p->cwd);
    8000239a:	150ab503          	ld	a0,336(s5)
    8000239e:	00002097          	auipc	ra,0x2
    800023a2:	a66080e7          	jalr	-1434(ra) # 80003e04 <idup>
    800023a6:	14aa3823          	sd	a0,336(s4)
    safestrcpy(np->name, p->name, sizeof(p->name));
    800023aa:	4641                	li	a2,16
    800023ac:	158a8593          	addi	a1,s5,344
    800023b0:	158a0513          	addi	a0,s4,344
    800023b4:	fffff097          	auipc	ra,0xfffff
    800023b8:	d22080e7          	jalr	-734(ra) # 800010d6 <safestrcpy>
    pid = np->pid;
    800023bc:	030a2903          	lw	s2,48(s4)
    release(&np->lock);
    800023c0:	8552                	mv	a0,s4
    800023c2:	fffff097          	auipc	ra,0xfffff
    800023c6:	b8a080e7          	jalr	-1142(ra) # 80000f4c <release>
    acquire(&wait_lock);
    800023ca:	00232497          	auipc	s1,0x232
    800023ce:	86e48493          	addi	s1,s1,-1938 # 80233c38 <wait_lock>
    800023d2:	8526                	mv	a0,s1
    800023d4:	fffff097          	auipc	ra,0xfffff
    800023d8:	ac4080e7          	jalr	-1340(ra) # 80000e98 <acquire>
    np->parent = p;
    800023dc:	035a3c23          	sd	s5,56(s4)
    release(&wait_lock);
    800023e0:	8526                	mv	a0,s1
    800023e2:	fffff097          	auipc	ra,0xfffff
    800023e6:	b6a080e7          	jalr	-1174(ra) # 80000f4c <release>
    acquire(&np->lock);
    800023ea:	8552                	mv	a0,s4
    800023ec:	fffff097          	auipc	ra,0xfffff
    800023f0:	aac080e7          	jalr	-1364(ra) # 80000e98 <acquire>
    np->state = RUNNABLE;
    800023f4:	478d                	li	a5,3
    800023f6:	00fa2c23          	sw	a5,24(s4)
    release(&np->lock);
    800023fa:	8552                	mv	a0,s4
    800023fc:	fffff097          	auipc	ra,0xfffff
    80002400:	b50080e7          	jalr	-1200(ra) # 80000f4c <release>
    return pid;
    80002404:	74a2                	ld	s1,40(sp)
    80002406:	69e2                	ld	s3,24(sp)
    80002408:	6a42                	ld	s4,16(sp)
}
    8000240a:	854a                	mv	a0,s2
    8000240c:	70e2                	ld	ra,56(sp)
    8000240e:	7442                	ld	s0,48(sp)
    80002410:	7902                	ld	s2,32(sp)
    80002412:	6aa2                	ld	s5,8(sp)
    80002414:	6121                	addi	sp,sp,64
    80002416:	8082                	ret
        return -1;
    80002418:	597d                	li	s2,-1
    8000241a:	bfc5                	j	8000240a <fork+0x130>

000000008000241c <scheduler>:
{
    8000241c:	1101                	addi	sp,sp,-32
    8000241e:	ec06                	sd	ra,24(sp)
    80002420:	e822                	sd	s0,16(sp)
    80002422:	e426                	sd	s1,8(sp)
    80002424:	1000                	addi	s0,sp,32
        (*sched_pointer)();
    80002426:	00009497          	auipc	s1,0x9
    8000242a:	0b248493          	addi	s1,s1,178 # 8000b4d8 <sched_pointer>
    8000242e:	609c                	ld	a5,0(s1)
    80002430:	9782                	jalr	a5
    while (1)
    80002432:	bff5                	j	8000242e <scheduler+0x12>

0000000080002434 <sched>:
{
    80002434:	7179                	addi	sp,sp,-48
    80002436:	f406                	sd	ra,40(sp)
    80002438:	f022                	sd	s0,32(sp)
    8000243a:	ec26                	sd	s1,24(sp)
    8000243c:	e84a                	sd	s2,16(sp)
    8000243e:	e44e                	sd	s3,8(sp)
    80002440:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80002442:	00000097          	auipc	ra,0x0
    80002446:	94a080e7          	jalr	-1718(ra) # 80001d8c <myproc>
    8000244a:	84aa                	mv	s1,a0
    if (!holding(&p->lock))
    8000244c:	fffff097          	auipc	ra,0xfffff
    80002450:	9d2080e7          	jalr	-1582(ra) # 80000e1e <holding>
    80002454:	c53d                	beqz	a0,800024c2 <sched+0x8e>
    80002456:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    80002458:	2781                	sext.w	a5,a5
    8000245a:	079e                	slli	a5,a5,0x7
    8000245c:	00231717          	auipc	a4,0x231
    80002460:	3c470713          	addi	a4,a4,964 # 80233820 <cpus>
    80002464:	97ba                	add	a5,a5,a4
    80002466:	5fb8                	lw	a4,120(a5)
    80002468:	4785                	li	a5,1
    8000246a:	06f71463          	bne	a4,a5,800024d2 <sched+0x9e>
    if (p->state == RUNNING)
    8000246e:	4c98                	lw	a4,24(s1)
    80002470:	4791                	li	a5,4
    80002472:	06f70863          	beq	a4,a5,800024e2 <sched+0xae>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002476:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    8000247a:	8b89                	andi	a5,a5,2
    if (intr_get())
    8000247c:	ebbd                	bnez	a5,800024f2 <sched+0xbe>
    asm volatile("mv %0, tp" : "=r"(x));
    8000247e:	8792                	mv	a5,tp
    intena = mycpu()->intena;
    80002480:	00231917          	auipc	s2,0x231
    80002484:	3a090913          	addi	s2,s2,928 # 80233820 <cpus>
    80002488:	2781                	sext.w	a5,a5
    8000248a:	079e                	slli	a5,a5,0x7
    8000248c:	97ca                	add	a5,a5,s2
    8000248e:	07c7a983          	lw	s3,124(a5)
    80002492:	8592                	mv	a1,tp
    swtch(&p->context, &mycpu()->context);
    80002494:	2581                	sext.w	a1,a1
    80002496:	059e                	slli	a1,a1,0x7
    80002498:	05a1                	addi	a1,a1,8
    8000249a:	95ca                	add	a1,a1,s2
    8000249c:	06048513          	addi	a0,s1,96
    800024a0:	00000097          	auipc	ra,0x0
    800024a4:	712080e7          	jalr	1810(ra) # 80002bb2 <swtch>
    800024a8:	8792                	mv	a5,tp
    mycpu()->intena = intena;
    800024aa:	2781                	sext.w	a5,a5
    800024ac:	079e                	slli	a5,a5,0x7
    800024ae:	993e                	add	s2,s2,a5
    800024b0:	07392e23          	sw	s3,124(s2)
}
    800024b4:	70a2                	ld	ra,40(sp)
    800024b6:	7402                	ld	s0,32(sp)
    800024b8:	64e2                	ld	s1,24(sp)
    800024ba:	6942                	ld	s2,16(sp)
    800024bc:	69a2                	ld	s3,8(sp)
    800024be:	6145                	addi	sp,sp,48
    800024c0:	8082                	ret
        panic("sched p->lock");
    800024c2:	00006517          	auipc	a0,0x6
    800024c6:	d9e50513          	addi	a0,a0,-610 # 80008260 <__func__.1+0x258>
    800024ca:	ffffe097          	auipc	ra,0xffffe
    800024ce:	096080e7          	jalr	150(ra) # 80000560 <panic>
        panic("sched locks");
    800024d2:	00006517          	auipc	a0,0x6
    800024d6:	d9e50513          	addi	a0,a0,-610 # 80008270 <__func__.1+0x268>
    800024da:	ffffe097          	auipc	ra,0xffffe
    800024de:	086080e7          	jalr	134(ra) # 80000560 <panic>
        panic("sched running");
    800024e2:	00006517          	auipc	a0,0x6
    800024e6:	d9e50513          	addi	a0,a0,-610 # 80008280 <__func__.1+0x278>
    800024ea:	ffffe097          	auipc	ra,0xffffe
    800024ee:	076080e7          	jalr	118(ra) # 80000560 <panic>
        panic("sched interruptible");
    800024f2:	00006517          	auipc	a0,0x6
    800024f6:	d9e50513          	addi	a0,a0,-610 # 80008290 <__func__.1+0x288>
    800024fa:	ffffe097          	auipc	ra,0xffffe
    800024fe:	066080e7          	jalr	102(ra) # 80000560 <panic>

0000000080002502 <yield>:
{
    80002502:	1101                	addi	sp,sp,-32
    80002504:	ec06                	sd	ra,24(sp)
    80002506:	e822                	sd	s0,16(sp)
    80002508:	e426                	sd	s1,8(sp)
    8000250a:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    8000250c:	00000097          	auipc	ra,0x0
    80002510:	880080e7          	jalr	-1920(ra) # 80001d8c <myproc>
    80002514:	84aa                	mv	s1,a0
    acquire(&p->lock);
    80002516:	fffff097          	auipc	ra,0xfffff
    8000251a:	982080e7          	jalr	-1662(ra) # 80000e98 <acquire>
    p->state = RUNNABLE;
    8000251e:	478d                	li	a5,3
    80002520:	cc9c                	sw	a5,24(s1)
    sched();
    80002522:	00000097          	auipc	ra,0x0
    80002526:	f12080e7          	jalr	-238(ra) # 80002434 <sched>
    release(&p->lock);
    8000252a:	8526                	mv	a0,s1
    8000252c:	fffff097          	auipc	ra,0xfffff
    80002530:	a20080e7          	jalr	-1504(ra) # 80000f4c <release>
}
    80002534:	60e2                	ld	ra,24(sp)
    80002536:	6442                	ld	s0,16(sp)
    80002538:	64a2                	ld	s1,8(sp)
    8000253a:	6105                	addi	sp,sp,32
    8000253c:	8082                	ret

000000008000253e <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    8000253e:	7179                	addi	sp,sp,-48
    80002540:	f406                	sd	ra,40(sp)
    80002542:	f022                	sd	s0,32(sp)
    80002544:	ec26                	sd	s1,24(sp)
    80002546:	e84a                	sd	s2,16(sp)
    80002548:	e44e                	sd	s3,8(sp)
    8000254a:	1800                	addi	s0,sp,48
    8000254c:	89aa                	mv	s3,a0
    8000254e:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80002550:	00000097          	auipc	ra,0x0
    80002554:	83c080e7          	jalr	-1988(ra) # 80001d8c <myproc>
    80002558:	84aa                	mv	s1,a0
    // Once we hold p->lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup locks p->lock),
    // so it's okay to release lk.

    acquire(&p->lock); // DOC: sleeplock1
    8000255a:	fffff097          	auipc	ra,0xfffff
    8000255e:	93e080e7          	jalr	-1730(ra) # 80000e98 <acquire>
    release(lk);
    80002562:	854a                	mv	a0,s2
    80002564:	fffff097          	auipc	ra,0xfffff
    80002568:	9e8080e7          	jalr	-1560(ra) # 80000f4c <release>

    // Go to sleep.
    p->chan = chan;
    8000256c:	0334b023          	sd	s3,32(s1)
    p->state = SLEEPING;
    80002570:	4789                	li	a5,2
    80002572:	cc9c                	sw	a5,24(s1)

    sched();
    80002574:	00000097          	auipc	ra,0x0
    80002578:	ec0080e7          	jalr	-320(ra) # 80002434 <sched>

    // Tidy up.
    p->chan = 0;
    8000257c:	0204b023          	sd	zero,32(s1)

    // Reacquire original lock.
    release(&p->lock);
    80002580:	8526                	mv	a0,s1
    80002582:	fffff097          	auipc	ra,0xfffff
    80002586:	9ca080e7          	jalr	-1590(ra) # 80000f4c <release>
    acquire(lk);
    8000258a:	854a                	mv	a0,s2
    8000258c:	fffff097          	auipc	ra,0xfffff
    80002590:	90c080e7          	jalr	-1780(ra) # 80000e98 <acquire>
}
    80002594:	70a2                	ld	ra,40(sp)
    80002596:	7402                	ld	s0,32(sp)
    80002598:	64e2                	ld	s1,24(sp)
    8000259a:	6942                	ld	s2,16(sp)
    8000259c:	69a2                	ld	s3,8(sp)
    8000259e:	6145                	addi	sp,sp,48
    800025a0:	8082                	ret

00000000800025a2 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    800025a2:	7139                	addi	sp,sp,-64
    800025a4:	fc06                	sd	ra,56(sp)
    800025a6:	f822                	sd	s0,48(sp)
    800025a8:	f426                	sd	s1,40(sp)
    800025aa:	f04a                	sd	s2,32(sp)
    800025ac:	ec4e                	sd	s3,24(sp)
    800025ae:	e852                	sd	s4,16(sp)
    800025b0:	e456                	sd	s5,8(sp)
    800025b2:	0080                	addi	s0,sp,64
    800025b4:	8a2a                	mv	s4,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    800025b6:	00231497          	auipc	s1,0x231
    800025ba:	69a48493          	addi	s1,s1,1690 # 80233c50 <proc>
    {
        if (p != myproc())
        {
            acquire(&p->lock);
            if (p->state == SLEEPING && p->chan == chan)
    800025be:	4989                	li	s3,2
            {
                p->state = RUNNABLE;
    800025c0:	4a8d                	li	s5,3
    for (p = proc; p < &proc[NPROC]; p++)
    800025c2:	00237917          	auipc	s2,0x237
    800025c6:	08e90913          	addi	s2,s2,142 # 80239650 <tickslock>
    800025ca:	a811                	j	800025de <wakeup+0x3c>
            }
            release(&p->lock);
    800025cc:	8526                	mv	a0,s1
    800025ce:	fffff097          	auipc	ra,0xfffff
    800025d2:	97e080e7          	jalr	-1666(ra) # 80000f4c <release>
    for (p = proc; p < &proc[NPROC]; p++)
    800025d6:	16848493          	addi	s1,s1,360
    800025da:	03248663          	beq	s1,s2,80002606 <wakeup+0x64>
        if (p != myproc())
    800025de:	fffff097          	auipc	ra,0xfffff
    800025e2:	7ae080e7          	jalr	1966(ra) # 80001d8c <myproc>
    800025e6:	fea488e3          	beq	s1,a0,800025d6 <wakeup+0x34>
            acquire(&p->lock);
    800025ea:	8526                	mv	a0,s1
    800025ec:	fffff097          	auipc	ra,0xfffff
    800025f0:	8ac080e7          	jalr	-1876(ra) # 80000e98 <acquire>
            if (p->state == SLEEPING && p->chan == chan)
    800025f4:	4c9c                	lw	a5,24(s1)
    800025f6:	fd379be3          	bne	a5,s3,800025cc <wakeup+0x2a>
    800025fa:	709c                	ld	a5,32(s1)
    800025fc:	fd4798e3          	bne	a5,s4,800025cc <wakeup+0x2a>
                p->state = RUNNABLE;
    80002600:	0154ac23          	sw	s5,24(s1)
    80002604:	b7e1                	j	800025cc <wakeup+0x2a>
        }
    }
}
    80002606:	70e2                	ld	ra,56(sp)
    80002608:	7442                	ld	s0,48(sp)
    8000260a:	74a2                	ld	s1,40(sp)
    8000260c:	7902                	ld	s2,32(sp)
    8000260e:	69e2                	ld	s3,24(sp)
    80002610:	6a42                	ld	s4,16(sp)
    80002612:	6aa2                	ld	s5,8(sp)
    80002614:	6121                	addi	sp,sp,64
    80002616:	8082                	ret

0000000080002618 <reparent>:
{
    80002618:	7179                	addi	sp,sp,-48
    8000261a:	f406                	sd	ra,40(sp)
    8000261c:	f022                	sd	s0,32(sp)
    8000261e:	ec26                	sd	s1,24(sp)
    80002620:	e84a                	sd	s2,16(sp)
    80002622:	e44e                	sd	s3,8(sp)
    80002624:	e052                	sd	s4,0(sp)
    80002626:	1800                	addi	s0,sp,48
    80002628:	892a                	mv	s2,a0
    for (pp = proc; pp < &proc[NPROC]; pp++)
    8000262a:	00231497          	auipc	s1,0x231
    8000262e:	62648493          	addi	s1,s1,1574 # 80233c50 <proc>
            pp->parent = initproc;
    80002632:	00009a17          	auipc	s4,0x9
    80002636:	f76a0a13          	addi	s4,s4,-138 # 8000b5a8 <initproc>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    8000263a:	00237997          	auipc	s3,0x237
    8000263e:	01698993          	addi	s3,s3,22 # 80239650 <tickslock>
    80002642:	a029                	j	8000264c <reparent+0x34>
    80002644:	16848493          	addi	s1,s1,360
    80002648:	01348d63          	beq	s1,s3,80002662 <reparent+0x4a>
        if (pp->parent == p)
    8000264c:	7c9c                	ld	a5,56(s1)
    8000264e:	ff279be3          	bne	a5,s2,80002644 <reparent+0x2c>
            pp->parent = initproc;
    80002652:	000a3503          	ld	a0,0(s4)
    80002656:	fc88                	sd	a0,56(s1)
            wakeup(initproc);
    80002658:	00000097          	auipc	ra,0x0
    8000265c:	f4a080e7          	jalr	-182(ra) # 800025a2 <wakeup>
    80002660:	b7d5                	j	80002644 <reparent+0x2c>
}
    80002662:	70a2                	ld	ra,40(sp)
    80002664:	7402                	ld	s0,32(sp)
    80002666:	64e2                	ld	s1,24(sp)
    80002668:	6942                	ld	s2,16(sp)
    8000266a:	69a2                	ld	s3,8(sp)
    8000266c:	6a02                	ld	s4,0(sp)
    8000266e:	6145                	addi	sp,sp,48
    80002670:	8082                	ret

0000000080002672 <exit>:
{
    80002672:	7179                	addi	sp,sp,-48
    80002674:	f406                	sd	ra,40(sp)
    80002676:	f022                	sd	s0,32(sp)
    80002678:	e052                	sd	s4,0(sp)
    8000267a:	1800                	addi	s0,sp,48
    8000267c:	8a2a                	mv	s4,a0
    struct proc *p = myproc();
    8000267e:	fffff097          	auipc	ra,0xfffff
    80002682:	70e080e7          	jalr	1806(ra) # 80001d8c <myproc>
    if (p == initproc)
    80002686:	00009797          	auipc	a5,0x9
    8000268a:	f227b783          	ld	a5,-222(a5) # 8000b5a8 <initproc>
    8000268e:	02a78b63          	beq	a5,a0,800026c4 <exit+0x52>
    80002692:	ec26                	sd	s1,24(sp)
    80002694:	e84a                	sd	s2,16(sp)
    80002696:	e44e                	sd	s3,8(sp)
    80002698:	892a                	mv	s2,a0
    uvmunmap(p->pagetable, 0, p->sz / PGSIZE, 1);
    8000269a:	6530                	ld	a2,72(a0)
    8000269c:	4685                	li	a3,1
    8000269e:	8231                	srli	a2,a2,0xc
    800026a0:	4581                	li	a1,0
    800026a2:	6928                	ld	a0,80(a0)
    800026a4:	fffff097          	auipc	ra,0xfffff
    800026a8:	e7a080e7          	jalr	-390(ra) # 8000151e <uvmunmap>
    if(p->parent && p->parent->state == SLEEPING){
    800026ac:	03893783          	ld	a5,56(s2)
    800026b0:	c789                	beqz	a5,800026ba <exit+0x48>
    800026b2:	4f94                	lw	a3,24(a5)
    800026b4:	4709                	li	a4,2
    800026b6:	02e68263          	beq	a3,a4,800026da <exit+0x68>
    for (int fd = 0; fd < NOFILE; fd++)
    800026ba:	0d090493          	addi	s1,s2,208
    800026be:	15090993          	addi	s3,s2,336
    800026c2:	a805                	j	800026f2 <exit+0x80>
    800026c4:	ec26                	sd	s1,24(sp)
    800026c6:	e84a                	sd	s2,16(sp)
    800026c8:	e44e                	sd	s3,8(sp)
        panic("init exiting");
    800026ca:	00006517          	auipc	a0,0x6
    800026ce:	bde50513          	addi	a0,a0,-1058 # 800082a8 <__func__.1+0x2a0>
    800026d2:	ffffe097          	auipc	ra,0xffffe
    800026d6:	e8e080e7          	jalr	-370(ra) # 80000560 <panic>
        p->parent->state = RUNNABLE;
    800026da:	470d                	li	a4,3
    800026dc:	cf98                	sw	a4,24(a5)
    800026de:	bff1                	j	800026ba <exit+0x48>
            fileclose(f);
    800026e0:	00002097          	auipc	ra,0x2
    800026e4:	5fa080e7          	jalr	1530(ra) # 80004cda <fileclose>
            p->ofile[fd] = 0;
    800026e8:	0004b023          	sd	zero,0(s1)
    for (int fd = 0; fd < NOFILE; fd++)
    800026ec:	04a1                	addi	s1,s1,8
    800026ee:	01348563          	beq	s1,s3,800026f8 <exit+0x86>
        if (p->ofile[fd])
    800026f2:	6088                	ld	a0,0(s1)
    800026f4:	f575                	bnez	a0,800026e0 <exit+0x6e>
    800026f6:	bfdd                	j	800026ec <exit+0x7a>
    begin_op();
    800026f8:	00002097          	auipc	ra,0x2
    800026fc:	118080e7          	jalr	280(ra) # 80004810 <begin_op>
    iput(p->cwd);
    80002700:	15093503          	ld	a0,336(s2)
    80002704:	00002097          	auipc	ra,0x2
    80002708:	8fc080e7          	jalr	-1796(ra) # 80004000 <iput>
    end_op();
    8000270c:	00002097          	auipc	ra,0x2
    80002710:	17e080e7          	jalr	382(ra) # 8000488a <end_op>
    p->cwd = 0;
    80002714:	14093823          	sd	zero,336(s2)
    acquire(&wait_lock);
    80002718:	00231497          	auipc	s1,0x231
    8000271c:	52048493          	addi	s1,s1,1312 # 80233c38 <wait_lock>
    80002720:	8526                	mv	a0,s1
    80002722:	ffffe097          	auipc	ra,0xffffe
    80002726:	776080e7          	jalr	1910(ra) # 80000e98 <acquire>
    reparent(p);
    8000272a:	854a                	mv	a0,s2
    8000272c:	00000097          	auipc	ra,0x0
    80002730:	eec080e7          	jalr	-276(ra) # 80002618 <reparent>
    wakeup(p->parent);
    80002734:	03893503          	ld	a0,56(s2)
    80002738:	00000097          	auipc	ra,0x0
    8000273c:	e6a080e7          	jalr	-406(ra) # 800025a2 <wakeup>
    acquire(&p->lock);
    80002740:	854a                	mv	a0,s2
    80002742:	ffffe097          	auipc	ra,0xffffe
    80002746:	756080e7          	jalr	1878(ra) # 80000e98 <acquire>
    p->xstate = status;
    8000274a:	03492623          	sw	s4,44(s2)
    p->state = ZOMBIE;
    8000274e:	4795                	li	a5,5
    80002750:	00f92c23          	sw	a5,24(s2)
    release(&wait_lock);
    80002754:	8526                	mv	a0,s1
    80002756:	ffffe097          	auipc	ra,0xffffe
    8000275a:	7f6080e7          	jalr	2038(ra) # 80000f4c <release>
    sched();
    8000275e:	00000097          	auipc	ra,0x0
    80002762:	cd6080e7          	jalr	-810(ra) # 80002434 <sched>
    panic("zombie exit");
    80002766:	00006517          	auipc	a0,0x6
    8000276a:	b5250513          	addi	a0,a0,-1198 # 800082b8 <__func__.1+0x2b0>
    8000276e:	ffffe097          	auipc	ra,0xffffe
    80002772:	df2080e7          	jalr	-526(ra) # 80000560 <panic>

0000000080002776 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    80002776:	7179                	addi	sp,sp,-48
    80002778:	f406                	sd	ra,40(sp)
    8000277a:	f022                	sd	s0,32(sp)
    8000277c:	ec26                	sd	s1,24(sp)
    8000277e:	e84a                	sd	s2,16(sp)
    80002780:	e44e                	sd	s3,8(sp)
    80002782:	1800                	addi	s0,sp,48
    80002784:	892a                	mv	s2,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    80002786:	00231497          	auipc	s1,0x231
    8000278a:	4ca48493          	addi	s1,s1,1226 # 80233c50 <proc>
    8000278e:	00237997          	auipc	s3,0x237
    80002792:	ec298993          	addi	s3,s3,-318 # 80239650 <tickslock>
    {
        acquire(&p->lock);
    80002796:	8526                	mv	a0,s1
    80002798:	ffffe097          	auipc	ra,0xffffe
    8000279c:	700080e7          	jalr	1792(ra) # 80000e98 <acquire>
        if (p->pid == pid)
    800027a0:	589c                	lw	a5,48(s1)
    800027a2:	01278d63          	beq	a5,s2,800027bc <kill+0x46>
                p->state = RUNNABLE;
            }
            release(&p->lock);
            return 0;
        }
        release(&p->lock);
    800027a6:	8526                	mv	a0,s1
    800027a8:	ffffe097          	auipc	ra,0xffffe
    800027ac:	7a4080e7          	jalr	1956(ra) # 80000f4c <release>
    for (p = proc; p < &proc[NPROC]; p++)
    800027b0:	16848493          	addi	s1,s1,360
    800027b4:	ff3491e3          	bne	s1,s3,80002796 <kill+0x20>
    }
    return -1;
    800027b8:	557d                	li	a0,-1
    800027ba:	a829                	j	800027d4 <kill+0x5e>
            p->killed = 1;
    800027bc:	4785                	li	a5,1
    800027be:	d49c                	sw	a5,40(s1)
            if (p->state == SLEEPING)
    800027c0:	4c98                	lw	a4,24(s1)
    800027c2:	4789                	li	a5,2
    800027c4:	00f70f63          	beq	a4,a5,800027e2 <kill+0x6c>
            release(&p->lock);
    800027c8:	8526                	mv	a0,s1
    800027ca:	ffffe097          	auipc	ra,0xffffe
    800027ce:	782080e7          	jalr	1922(ra) # 80000f4c <release>
            return 0;
    800027d2:	4501                	li	a0,0
}
    800027d4:	70a2                	ld	ra,40(sp)
    800027d6:	7402                	ld	s0,32(sp)
    800027d8:	64e2                	ld	s1,24(sp)
    800027da:	6942                	ld	s2,16(sp)
    800027dc:	69a2                	ld	s3,8(sp)
    800027de:	6145                	addi	sp,sp,48
    800027e0:	8082                	ret
                p->state = RUNNABLE;
    800027e2:	478d                	li	a5,3
    800027e4:	cc9c                	sw	a5,24(s1)
    800027e6:	b7cd                	j	800027c8 <kill+0x52>

00000000800027e8 <setkilled>:

void setkilled(struct proc *p)
{
    800027e8:	1101                	addi	sp,sp,-32
    800027ea:	ec06                	sd	ra,24(sp)
    800027ec:	e822                	sd	s0,16(sp)
    800027ee:	e426                	sd	s1,8(sp)
    800027f0:	1000                	addi	s0,sp,32
    800027f2:	84aa                	mv	s1,a0
    acquire(&p->lock);
    800027f4:	ffffe097          	auipc	ra,0xffffe
    800027f8:	6a4080e7          	jalr	1700(ra) # 80000e98 <acquire>
    p->killed = 1;
    800027fc:	4785                	li	a5,1
    800027fe:	d49c                	sw	a5,40(s1)
    release(&p->lock);
    80002800:	8526                	mv	a0,s1
    80002802:	ffffe097          	auipc	ra,0xffffe
    80002806:	74a080e7          	jalr	1866(ra) # 80000f4c <release>
}
    8000280a:	60e2                	ld	ra,24(sp)
    8000280c:	6442                	ld	s0,16(sp)
    8000280e:	64a2                	ld	s1,8(sp)
    80002810:	6105                	addi	sp,sp,32
    80002812:	8082                	ret

0000000080002814 <killed>:

int killed(struct proc *p)
{
    80002814:	1101                	addi	sp,sp,-32
    80002816:	ec06                	sd	ra,24(sp)
    80002818:	e822                	sd	s0,16(sp)
    8000281a:	e426                	sd	s1,8(sp)
    8000281c:	e04a                	sd	s2,0(sp)
    8000281e:	1000                	addi	s0,sp,32
    80002820:	84aa                	mv	s1,a0
    int k;

    acquire(&p->lock);
    80002822:	ffffe097          	auipc	ra,0xffffe
    80002826:	676080e7          	jalr	1654(ra) # 80000e98 <acquire>
    k = p->killed;
    8000282a:	0284a903          	lw	s2,40(s1)
    release(&p->lock);
    8000282e:	8526                	mv	a0,s1
    80002830:	ffffe097          	auipc	ra,0xffffe
    80002834:	71c080e7          	jalr	1820(ra) # 80000f4c <release>
    return k;
}
    80002838:	854a                	mv	a0,s2
    8000283a:	60e2                	ld	ra,24(sp)
    8000283c:	6442                	ld	s0,16(sp)
    8000283e:	64a2                	ld	s1,8(sp)
    80002840:	6902                	ld	s2,0(sp)
    80002842:	6105                	addi	sp,sp,32
    80002844:	8082                	ret

0000000080002846 <wait>:
{
    80002846:	715d                	addi	sp,sp,-80
    80002848:	e486                	sd	ra,72(sp)
    8000284a:	e0a2                	sd	s0,64(sp)
    8000284c:	fc26                	sd	s1,56(sp)
    8000284e:	f84a                	sd	s2,48(sp)
    80002850:	f44e                	sd	s3,40(sp)
    80002852:	f052                	sd	s4,32(sp)
    80002854:	ec56                	sd	s5,24(sp)
    80002856:	e85a                	sd	s6,16(sp)
    80002858:	e45e                	sd	s7,8(sp)
    8000285a:	e062                	sd	s8,0(sp)
    8000285c:	0880                	addi	s0,sp,80
    8000285e:	8b2a                	mv	s6,a0
    struct proc *p = myproc();
    80002860:	fffff097          	auipc	ra,0xfffff
    80002864:	52c080e7          	jalr	1324(ra) # 80001d8c <myproc>
    80002868:	892a                	mv	s2,a0
    acquire(&wait_lock);
    8000286a:	00231517          	auipc	a0,0x231
    8000286e:	3ce50513          	addi	a0,a0,974 # 80233c38 <wait_lock>
    80002872:	ffffe097          	auipc	ra,0xffffe
    80002876:	626080e7          	jalr	1574(ra) # 80000e98 <acquire>
        havekids = 0;
    8000287a:	4b81                	li	s7,0
                if (pp->state == ZOMBIE)
    8000287c:	4a15                	li	s4,5
                havekids = 1;
    8000287e:	4a85                	li	s5,1
        for (pp = proc; pp < &proc[NPROC]; pp++)
    80002880:	00237997          	auipc	s3,0x237
    80002884:	dd098993          	addi	s3,s3,-560 # 80239650 <tickslock>
        sleep(p, &wait_lock); // DOC: wait-sleep
    80002888:	00231c17          	auipc	s8,0x231
    8000288c:	3b0c0c13          	addi	s8,s8,944 # 80233c38 <wait_lock>
    80002890:	a0d1                	j	80002954 <wait+0x10e>
                    pid = pp->pid;
    80002892:	0304a983          	lw	s3,48(s1)
                    if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002896:	000b0e63          	beqz	s6,800028b2 <wait+0x6c>
    8000289a:	4691                	li	a3,4
    8000289c:	02c48613          	addi	a2,s1,44
    800028a0:	85da                	mv	a1,s6
    800028a2:	05093503          	ld	a0,80(s2)
    800028a6:	fffff097          	auipc	ra,0xfffff
    800028aa:	08a080e7          	jalr	138(ra) # 80001930 <copyout>
    800028ae:	04054163          	bltz	a0,800028f0 <wait+0xaa>
                    freeproc(pp);
    800028b2:	8526                	mv	a0,s1
    800028b4:	fffff097          	auipc	ra,0xfffff
    800028b8:	68a080e7          	jalr	1674(ra) # 80001f3e <freeproc>
                    release(&pp->lock);
    800028bc:	8526                	mv	a0,s1
    800028be:	ffffe097          	auipc	ra,0xffffe
    800028c2:	68e080e7          	jalr	1678(ra) # 80000f4c <release>
                    release(&wait_lock);
    800028c6:	00231517          	auipc	a0,0x231
    800028ca:	37250513          	addi	a0,a0,882 # 80233c38 <wait_lock>
    800028ce:	ffffe097          	auipc	ra,0xffffe
    800028d2:	67e080e7          	jalr	1662(ra) # 80000f4c <release>
}
    800028d6:	854e                	mv	a0,s3
    800028d8:	60a6                	ld	ra,72(sp)
    800028da:	6406                	ld	s0,64(sp)
    800028dc:	74e2                	ld	s1,56(sp)
    800028de:	7942                	ld	s2,48(sp)
    800028e0:	79a2                	ld	s3,40(sp)
    800028e2:	7a02                	ld	s4,32(sp)
    800028e4:	6ae2                	ld	s5,24(sp)
    800028e6:	6b42                	ld	s6,16(sp)
    800028e8:	6ba2                	ld	s7,8(sp)
    800028ea:	6c02                	ld	s8,0(sp)
    800028ec:	6161                	addi	sp,sp,80
    800028ee:	8082                	ret
                        release(&pp->lock);
    800028f0:	8526                	mv	a0,s1
    800028f2:	ffffe097          	auipc	ra,0xffffe
    800028f6:	65a080e7          	jalr	1626(ra) # 80000f4c <release>
                        release(&wait_lock);
    800028fa:	00231517          	auipc	a0,0x231
    800028fe:	33e50513          	addi	a0,a0,830 # 80233c38 <wait_lock>
    80002902:	ffffe097          	auipc	ra,0xffffe
    80002906:	64a080e7          	jalr	1610(ra) # 80000f4c <release>
                        return -1;
    8000290a:	59fd                	li	s3,-1
    8000290c:	b7e9                	j	800028d6 <wait+0x90>
        for (pp = proc; pp < &proc[NPROC]; pp++)
    8000290e:	16848493          	addi	s1,s1,360
    80002912:	03348463          	beq	s1,s3,8000293a <wait+0xf4>
            if (pp->parent == p)
    80002916:	7c9c                	ld	a5,56(s1)
    80002918:	ff279be3          	bne	a5,s2,8000290e <wait+0xc8>
                acquire(&pp->lock);
    8000291c:	8526                	mv	a0,s1
    8000291e:	ffffe097          	auipc	ra,0xffffe
    80002922:	57a080e7          	jalr	1402(ra) # 80000e98 <acquire>
                if (pp->state == ZOMBIE)
    80002926:	4c9c                	lw	a5,24(s1)
    80002928:	f74785e3          	beq	a5,s4,80002892 <wait+0x4c>
                release(&pp->lock);
    8000292c:	8526                	mv	a0,s1
    8000292e:	ffffe097          	auipc	ra,0xffffe
    80002932:	61e080e7          	jalr	1566(ra) # 80000f4c <release>
                havekids = 1;
    80002936:	8756                	mv	a4,s5
    80002938:	bfd9                	j	8000290e <wait+0xc8>
        if (!havekids || killed(p))
    8000293a:	c31d                	beqz	a4,80002960 <wait+0x11a>
    8000293c:	854a                	mv	a0,s2
    8000293e:	00000097          	auipc	ra,0x0
    80002942:	ed6080e7          	jalr	-298(ra) # 80002814 <killed>
    80002946:	ed09                	bnez	a0,80002960 <wait+0x11a>
        sleep(p, &wait_lock); // DOC: wait-sleep
    80002948:	85e2                	mv	a1,s8
    8000294a:	854a                	mv	a0,s2
    8000294c:	00000097          	auipc	ra,0x0
    80002950:	bf2080e7          	jalr	-1038(ra) # 8000253e <sleep>
        havekids = 0;
    80002954:	875e                	mv	a4,s7
        for (pp = proc; pp < &proc[NPROC]; pp++)
    80002956:	00231497          	auipc	s1,0x231
    8000295a:	2fa48493          	addi	s1,s1,762 # 80233c50 <proc>
    8000295e:	bf65                	j	80002916 <wait+0xd0>
            release(&wait_lock);
    80002960:	00231517          	auipc	a0,0x231
    80002964:	2d850513          	addi	a0,a0,728 # 80233c38 <wait_lock>
    80002968:	ffffe097          	auipc	ra,0xffffe
    8000296c:	5e4080e7          	jalr	1508(ra) # 80000f4c <release>
            return -1;
    80002970:	59fd                	li	s3,-1
    80002972:	b795                	j	800028d6 <wait+0x90>

0000000080002974 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002974:	7179                	addi	sp,sp,-48
    80002976:	f406                	sd	ra,40(sp)
    80002978:	f022                	sd	s0,32(sp)
    8000297a:	ec26                	sd	s1,24(sp)
    8000297c:	e84a                	sd	s2,16(sp)
    8000297e:	e44e                	sd	s3,8(sp)
    80002980:	e052                	sd	s4,0(sp)
    80002982:	1800                	addi	s0,sp,48
    80002984:	84aa                	mv	s1,a0
    80002986:	892e                	mv	s2,a1
    80002988:	89b2                	mv	s3,a2
    8000298a:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    8000298c:	fffff097          	auipc	ra,0xfffff
    80002990:	400080e7          	jalr	1024(ra) # 80001d8c <myproc>
    if (user_dst)
    80002994:	c08d                	beqz	s1,800029b6 <either_copyout+0x42>
    {
        return copyout(p->pagetable, dst, src, len);
    80002996:	86d2                	mv	a3,s4
    80002998:	864e                	mv	a2,s3
    8000299a:	85ca                	mv	a1,s2
    8000299c:	6928                	ld	a0,80(a0)
    8000299e:	fffff097          	auipc	ra,0xfffff
    800029a2:	f92080e7          	jalr	-110(ra) # 80001930 <copyout>
    else
    {
        memmove((char *)dst, src, len);
        return 0;
    }
}
    800029a6:	70a2                	ld	ra,40(sp)
    800029a8:	7402                	ld	s0,32(sp)
    800029aa:	64e2                	ld	s1,24(sp)
    800029ac:	6942                	ld	s2,16(sp)
    800029ae:	69a2                	ld	s3,8(sp)
    800029b0:	6a02                	ld	s4,0(sp)
    800029b2:	6145                	addi	sp,sp,48
    800029b4:	8082                	ret
        memmove((char *)dst, src, len);
    800029b6:	000a061b          	sext.w	a2,s4
    800029ba:	85ce                	mv	a1,s3
    800029bc:	854a                	mv	a0,s2
    800029be:	ffffe097          	auipc	ra,0xffffe
    800029c2:	632080e7          	jalr	1586(ra) # 80000ff0 <memmove>
        return 0;
    800029c6:	8526                	mv	a0,s1
    800029c8:	bff9                	j	800029a6 <either_copyout+0x32>

00000000800029ca <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800029ca:	7179                	addi	sp,sp,-48
    800029cc:	f406                	sd	ra,40(sp)
    800029ce:	f022                	sd	s0,32(sp)
    800029d0:	ec26                	sd	s1,24(sp)
    800029d2:	e84a                	sd	s2,16(sp)
    800029d4:	e44e                	sd	s3,8(sp)
    800029d6:	e052                	sd	s4,0(sp)
    800029d8:	1800                	addi	s0,sp,48
    800029da:	892a                	mv	s2,a0
    800029dc:	84ae                	mv	s1,a1
    800029de:	89b2                	mv	s3,a2
    800029e0:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    800029e2:	fffff097          	auipc	ra,0xfffff
    800029e6:	3aa080e7          	jalr	938(ra) # 80001d8c <myproc>
    if (user_src)
    800029ea:	c08d                	beqz	s1,80002a0c <either_copyin+0x42>
    {
        return copyin(p->pagetable, dst, src, len);
    800029ec:	86d2                	mv	a3,s4
    800029ee:	864e                	mv	a2,s3
    800029f0:	85ca                	mv	a1,s2
    800029f2:	6928                	ld	a0,80(a0)
    800029f4:	fffff097          	auipc	ra,0xfffff
    800029f8:	fc8080e7          	jalr	-56(ra) # 800019bc <copyin>
    else
    {
        memmove(dst, (char *)src, len);
        return 0;
    }
}
    800029fc:	70a2                	ld	ra,40(sp)
    800029fe:	7402                	ld	s0,32(sp)
    80002a00:	64e2                	ld	s1,24(sp)
    80002a02:	6942                	ld	s2,16(sp)
    80002a04:	69a2                	ld	s3,8(sp)
    80002a06:	6a02                	ld	s4,0(sp)
    80002a08:	6145                	addi	sp,sp,48
    80002a0a:	8082                	ret
        memmove(dst, (char *)src, len);
    80002a0c:	000a061b          	sext.w	a2,s4
    80002a10:	85ce                	mv	a1,s3
    80002a12:	854a                	mv	a0,s2
    80002a14:	ffffe097          	auipc	ra,0xffffe
    80002a18:	5dc080e7          	jalr	1500(ra) # 80000ff0 <memmove>
        return 0;
    80002a1c:	8526                	mv	a0,s1
    80002a1e:	bff9                	j	800029fc <either_copyin+0x32>

0000000080002a20 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    80002a20:	715d                	addi	sp,sp,-80
    80002a22:	e486                	sd	ra,72(sp)
    80002a24:	e0a2                	sd	s0,64(sp)
    80002a26:	fc26                	sd	s1,56(sp)
    80002a28:	f84a                	sd	s2,48(sp)
    80002a2a:	f44e                	sd	s3,40(sp)
    80002a2c:	f052                	sd	s4,32(sp)
    80002a2e:	ec56                	sd	s5,24(sp)
    80002a30:	e85a                	sd	s6,16(sp)
    80002a32:	e45e                	sd	s7,8(sp)
    80002a34:	0880                	addi	s0,sp,80
        [RUNNING] "run   ",
        [ZOMBIE] "zombie"};
    struct proc *p;
    char *state;

    printf("\n");
    80002a36:	00005517          	auipc	a0,0x5
    80002a3a:	5ea50513          	addi	a0,a0,1514 # 80008020 <__func__.1+0x18>
    80002a3e:	ffffe097          	auipc	ra,0xffffe
    80002a42:	b7e080e7          	jalr	-1154(ra) # 800005bc <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80002a46:	00231497          	auipc	s1,0x231
    80002a4a:	36248493          	addi	s1,s1,866 # 80233da8 <proc+0x158>
    80002a4e:	00237917          	auipc	s2,0x237
    80002a52:	d5a90913          	addi	s2,s2,-678 # 802397a8 <bcache+0x140>
    {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002a56:	4b15                	li	s6,5
            state = states[p->state];
        else
            state = "???";
    80002a58:	00006997          	auipc	s3,0x6
    80002a5c:	87098993          	addi	s3,s3,-1936 # 800082c8 <__func__.1+0x2c0>
        printf("%d <%s %s", p->pid, state, p->name);
    80002a60:	00006a97          	auipc	s5,0x6
    80002a64:	870a8a93          	addi	s5,s5,-1936 # 800082d0 <__func__.1+0x2c8>
        printf("\n");
    80002a68:	00005a17          	auipc	s4,0x5
    80002a6c:	5b8a0a13          	addi	s4,s4,1464 # 80008020 <__func__.1+0x18>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002a70:	00006b97          	auipc	s7,0x6
    80002a74:	e10b8b93          	addi	s7,s7,-496 # 80008880 <states.0>
    80002a78:	a00d                	j	80002a9a <procdump+0x7a>
        printf("%d <%s %s", p->pid, state, p->name);
    80002a7a:	ed86a583          	lw	a1,-296(a3)
    80002a7e:	8556                	mv	a0,s5
    80002a80:	ffffe097          	auipc	ra,0xffffe
    80002a84:	b3c080e7          	jalr	-1220(ra) # 800005bc <printf>
        printf("\n");
    80002a88:	8552                	mv	a0,s4
    80002a8a:	ffffe097          	auipc	ra,0xffffe
    80002a8e:	b32080e7          	jalr	-1230(ra) # 800005bc <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80002a92:	16848493          	addi	s1,s1,360
    80002a96:	03248263          	beq	s1,s2,80002aba <procdump+0x9a>
        if (p->state == UNUSED)
    80002a9a:	86a6                	mv	a3,s1
    80002a9c:	ec04a783          	lw	a5,-320(s1)
    80002aa0:	dbed                	beqz	a5,80002a92 <procdump+0x72>
            state = "???";
    80002aa2:	864e                	mv	a2,s3
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002aa4:	fcfb6be3          	bltu	s6,a5,80002a7a <procdump+0x5a>
    80002aa8:	02079713          	slli	a4,a5,0x20
    80002aac:	01d75793          	srli	a5,a4,0x1d
    80002ab0:	97de                	add	a5,a5,s7
    80002ab2:	6390                	ld	a2,0(a5)
    80002ab4:	f279                	bnez	a2,80002a7a <procdump+0x5a>
            state = "???";
    80002ab6:	864e                	mv	a2,s3
    80002ab8:	b7c9                	j	80002a7a <procdump+0x5a>
    }
}
    80002aba:	60a6                	ld	ra,72(sp)
    80002abc:	6406                	ld	s0,64(sp)
    80002abe:	74e2                	ld	s1,56(sp)
    80002ac0:	7942                	ld	s2,48(sp)
    80002ac2:	79a2                	ld	s3,40(sp)
    80002ac4:	7a02                	ld	s4,32(sp)
    80002ac6:	6ae2                	ld	s5,24(sp)
    80002ac8:	6b42                	ld	s6,16(sp)
    80002aca:	6ba2                	ld	s7,8(sp)
    80002acc:	6161                	addi	sp,sp,80
    80002ace:	8082                	ret

0000000080002ad0 <schedls>:

void schedls()
{
    80002ad0:	1141                	addi	sp,sp,-16
    80002ad2:	e406                	sd	ra,8(sp)
    80002ad4:	e022                	sd	s0,0(sp)
    80002ad6:	0800                	addi	s0,sp,16
    printf("[ ]\tScheduler Name\tScheduler ID\n");
    80002ad8:	00006517          	auipc	a0,0x6
    80002adc:	80850513          	addi	a0,a0,-2040 # 800082e0 <__func__.1+0x2d8>
    80002ae0:	ffffe097          	auipc	ra,0xffffe
    80002ae4:	adc080e7          	jalr	-1316(ra) # 800005bc <printf>
    printf("====================================\n");
    80002ae8:	00006517          	auipc	a0,0x6
    80002aec:	82050513          	addi	a0,a0,-2016 # 80008308 <__func__.1+0x300>
    80002af0:	ffffe097          	auipc	ra,0xffffe
    80002af4:	acc080e7          	jalr	-1332(ra) # 800005bc <printf>
    for (int i = 0; i < SCHEDC; i++)
    {
        if (available_schedulers[i].impl == sched_pointer)
    80002af8:	00009717          	auipc	a4,0x9
    80002afc:	a4073703          	ld	a4,-1472(a4) # 8000b538 <available_schedulers+0x10>
    80002b00:	00009797          	auipc	a5,0x9
    80002b04:	9d87b783          	ld	a5,-1576(a5) # 8000b4d8 <sched_pointer>
    80002b08:	04f70663          	beq	a4,a5,80002b54 <schedls+0x84>
        {
            printf("[*]\t");
        }
        else
        {
            printf("   \t");
    80002b0c:	00006517          	auipc	a0,0x6
    80002b10:	82c50513          	addi	a0,a0,-2004 # 80008338 <__func__.1+0x330>
    80002b14:	ffffe097          	auipc	ra,0xffffe
    80002b18:	aa8080e7          	jalr	-1368(ra) # 800005bc <printf>
        }
        printf("%s\t%d\n", available_schedulers[i].name, available_schedulers[i].id);
    80002b1c:	00009617          	auipc	a2,0x9
    80002b20:	a2462603          	lw	a2,-1500(a2) # 8000b540 <available_schedulers+0x18>
    80002b24:	00009597          	auipc	a1,0x9
    80002b28:	a0458593          	addi	a1,a1,-1532 # 8000b528 <available_schedulers>
    80002b2c:	00006517          	auipc	a0,0x6
    80002b30:	81450513          	addi	a0,a0,-2028 # 80008340 <__func__.1+0x338>
    80002b34:	ffffe097          	auipc	ra,0xffffe
    80002b38:	a88080e7          	jalr	-1400(ra) # 800005bc <printf>
    }
    printf("\n*: current scheduler\n\n");
    80002b3c:	00006517          	auipc	a0,0x6
    80002b40:	80c50513          	addi	a0,a0,-2036 # 80008348 <__func__.1+0x340>
    80002b44:	ffffe097          	auipc	ra,0xffffe
    80002b48:	a78080e7          	jalr	-1416(ra) # 800005bc <printf>
}
    80002b4c:	60a2                	ld	ra,8(sp)
    80002b4e:	6402                	ld	s0,0(sp)
    80002b50:	0141                	addi	sp,sp,16
    80002b52:	8082                	ret
            printf("[*]\t");
    80002b54:	00005517          	auipc	a0,0x5
    80002b58:	7dc50513          	addi	a0,a0,2012 # 80008330 <__func__.1+0x328>
    80002b5c:	ffffe097          	auipc	ra,0xffffe
    80002b60:	a60080e7          	jalr	-1440(ra) # 800005bc <printf>
    80002b64:	bf65                	j	80002b1c <schedls+0x4c>

0000000080002b66 <schedset>:

void schedset(int id)
{
    80002b66:	1141                	addi	sp,sp,-16
    80002b68:	e406                	sd	ra,8(sp)
    80002b6a:	e022                	sd	s0,0(sp)
    80002b6c:	0800                	addi	s0,sp,16
    if (id < 0 || SCHEDC <= id)
    80002b6e:	e90d                	bnez	a0,80002ba0 <schedset+0x3a>
    {
        printf("Scheduler unchanged: ID out of range\n");
        return;
    }
    sched_pointer = available_schedulers[id].impl;
    80002b70:	00009797          	auipc	a5,0x9
    80002b74:	9c87b783          	ld	a5,-1592(a5) # 8000b538 <available_schedulers+0x10>
    80002b78:	00009717          	auipc	a4,0x9
    80002b7c:	96f73023          	sd	a5,-1696(a4) # 8000b4d8 <sched_pointer>
    printf("Scheduler successfully changed to %s\n", available_schedulers[id].name);
    80002b80:	00009597          	auipc	a1,0x9
    80002b84:	9a858593          	addi	a1,a1,-1624 # 8000b528 <available_schedulers>
    80002b88:	00006517          	auipc	a0,0x6
    80002b8c:	80050513          	addi	a0,a0,-2048 # 80008388 <__func__.1+0x380>
    80002b90:	ffffe097          	auipc	ra,0xffffe
    80002b94:	a2c080e7          	jalr	-1492(ra) # 800005bc <printf>
    80002b98:	60a2                	ld	ra,8(sp)
    80002b9a:	6402                	ld	s0,0(sp)
    80002b9c:	0141                	addi	sp,sp,16
    80002b9e:	8082                	ret
        printf("Scheduler unchanged: ID out of range\n");
    80002ba0:	00005517          	auipc	a0,0x5
    80002ba4:	7c050513          	addi	a0,a0,1984 # 80008360 <__func__.1+0x358>
    80002ba8:	ffffe097          	auipc	ra,0xffffe
    80002bac:	a14080e7          	jalr	-1516(ra) # 800005bc <printf>
        return;
    80002bb0:	b7e5                	j	80002b98 <schedset+0x32>

0000000080002bb2 <swtch>:
    80002bb2:	00153023          	sd	ra,0(a0)
    80002bb6:	00253423          	sd	sp,8(a0)
    80002bba:	e900                	sd	s0,16(a0)
    80002bbc:	ed04                	sd	s1,24(a0)
    80002bbe:	03253023          	sd	s2,32(a0)
    80002bc2:	03353423          	sd	s3,40(a0)
    80002bc6:	03453823          	sd	s4,48(a0)
    80002bca:	03553c23          	sd	s5,56(a0)
    80002bce:	05653023          	sd	s6,64(a0)
    80002bd2:	05753423          	sd	s7,72(a0)
    80002bd6:	05853823          	sd	s8,80(a0)
    80002bda:	05953c23          	sd	s9,88(a0)
    80002bde:	07a53023          	sd	s10,96(a0)
    80002be2:	07b53423          	sd	s11,104(a0)
    80002be6:	0005b083          	ld	ra,0(a1)
    80002bea:	0085b103          	ld	sp,8(a1)
    80002bee:	6980                	ld	s0,16(a1)
    80002bf0:	6d84                	ld	s1,24(a1)
    80002bf2:	0205b903          	ld	s2,32(a1)
    80002bf6:	0285b983          	ld	s3,40(a1)
    80002bfa:	0305ba03          	ld	s4,48(a1)
    80002bfe:	0385ba83          	ld	s5,56(a1)
    80002c02:	0405bb03          	ld	s6,64(a1)
    80002c06:	0485bb83          	ld	s7,72(a1)
    80002c0a:	0505bc03          	ld	s8,80(a1)
    80002c0e:	0585bc83          	ld	s9,88(a1)
    80002c12:	0605bd03          	ld	s10,96(a1)
    80002c16:	0685bd83          	ld	s11,104(a1)
    80002c1a:	8082                	ret

0000000080002c1c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002c1c:	1141                	addi	sp,sp,-16
    80002c1e:	e406                	sd	ra,8(sp)
    80002c20:	e022                	sd	s0,0(sp)
    80002c22:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002c24:	00005597          	auipc	a1,0x5
    80002c28:	7bc58593          	addi	a1,a1,1980 # 800083e0 <__func__.1+0x3d8>
    80002c2c:	00237517          	auipc	a0,0x237
    80002c30:	a2450513          	addi	a0,a0,-1500 # 80239650 <tickslock>
    80002c34:	ffffe097          	auipc	ra,0xffffe
    80002c38:	1d4080e7          	jalr	468(ra) # 80000e08 <initlock>
}
    80002c3c:	60a2                	ld	ra,8(sp)
    80002c3e:	6402                	ld	s0,0(sp)
    80002c40:	0141                	addi	sp,sp,16
    80002c42:	8082                	ret

0000000080002c44 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002c44:	1141                	addi	sp,sp,-16
    80002c46:	e422                	sd	s0,8(sp)
    80002c48:	0800                	addi	s0,sp,16
    asm volatile("csrw stvec, %0" : : "r"(x));
    80002c4a:	00003797          	auipc	a5,0x3
    80002c4e:	79678793          	addi	a5,a5,1942 # 800063e0 <kernelvec>
    80002c52:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002c56:	6422                	ld	s0,8(sp)
    80002c58:	0141                	addi	sp,sp,16
    80002c5a:	8082                	ret

0000000080002c5c <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002c5c:	1141                	addi	sp,sp,-16
    80002c5e:	e406                	sd	ra,8(sp)
    80002c60:	e022                	sd	s0,0(sp)
    80002c62:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002c64:	fffff097          	auipc	ra,0xfffff
    80002c68:	128080e7          	jalr	296(ra) # 80001d8c <myproc>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002c6c:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002c70:	9bf5                	andi	a5,a5,-3
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80002c72:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002c76:	00004697          	auipc	a3,0x4
    80002c7a:	38a68693          	addi	a3,a3,906 # 80007000 <_trampoline>
    80002c7e:	00004717          	auipc	a4,0x4
    80002c82:	38270713          	addi	a4,a4,898 # 80007000 <_trampoline>
    80002c86:	8f15                	sub	a4,a4,a3
    80002c88:	040007b7          	lui	a5,0x4000
    80002c8c:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002c8e:	07b2                	slli	a5,a5,0xc
    80002c90:	973e                	add	a4,a4,a5
    asm volatile("csrw stvec, %0" : : "r"(x));
    80002c92:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002c96:	6d38                	ld	a4,88(a0)
    asm volatile("csrr %0, satp" : "=r"(x));
    80002c98:	18002673          	csrr	a2,satp
    80002c9c:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002c9e:	6d30                	ld	a2,88(a0)
    80002ca0:	6138                	ld	a4,64(a0)
    80002ca2:	6585                	lui	a1,0x1
    80002ca4:	972e                	add	a4,a4,a1
    80002ca6:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002ca8:	6d38                	ld	a4,88(a0)
    80002caa:	00000617          	auipc	a2,0x0
    80002cae:	13860613          	addi	a2,a2,312 # 80002de2 <usertrap>
    80002cb2:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002cb4:	6d38                	ld	a4,88(a0)
    asm volatile("mv %0, tp" : "=r"(x));
    80002cb6:	8612                	mv	a2,tp
    80002cb8:	f310                	sd	a2,32(a4)
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002cba:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002cbe:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002cc2:	02076713          	ori	a4,a4,32
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80002cc6:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002cca:	6d38                	ld	a4,88(a0)
    asm volatile("csrw sepc, %0" : : "r"(x));
    80002ccc:	6f18                	ld	a4,24(a4)
    80002cce:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002cd2:	6928                	ld	a0,80(a0)
    80002cd4:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002cd6:	00004717          	auipc	a4,0x4
    80002cda:	3c670713          	addi	a4,a4,966 # 8000709c <userret>
    80002cde:	8f15                	sub	a4,a4,a3
    80002ce0:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002ce2:	577d                	li	a4,-1
    80002ce4:	177e                	slli	a4,a4,0x3f
    80002ce6:	8d59                	or	a0,a0,a4
    80002ce8:	9782                	jalr	a5
}
    80002cea:	60a2                	ld	ra,8(sp)
    80002cec:	6402                	ld	s0,0(sp)
    80002cee:	0141                	addi	sp,sp,16
    80002cf0:	8082                	ret

0000000080002cf2 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002cf2:	1101                	addi	sp,sp,-32
    80002cf4:	ec06                	sd	ra,24(sp)
    80002cf6:	e822                	sd	s0,16(sp)
    80002cf8:	e426                	sd	s1,8(sp)
    80002cfa:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002cfc:	00237497          	auipc	s1,0x237
    80002d00:	95448493          	addi	s1,s1,-1708 # 80239650 <tickslock>
    80002d04:	8526                	mv	a0,s1
    80002d06:	ffffe097          	auipc	ra,0xffffe
    80002d0a:	192080e7          	jalr	402(ra) # 80000e98 <acquire>
  ticks++;
    80002d0e:	00009517          	auipc	a0,0x9
    80002d12:	8a250513          	addi	a0,a0,-1886 # 8000b5b0 <ticks>
    80002d16:	411c                	lw	a5,0(a0)
    80002d18:	2785                	addiw	a5,a5,1
    80002d1a:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002d1c:	00000097          	auipc	ra,0x0
    80002d20:	886080e7          	jalr	-1914(ra) # 800025a2 <wakeup>
  release(&tickslock);
    80002d24:	8526                	mv	a0,s1
    80002d26:	ffffe097          	auipc	ra,0xffffe
    80002d2a:	226080e7          	jalr	550(ra) # 80000f4c <release>
}
    80002d2e:	60e2                	ld	ra,24(sp)
    80002d30:	6442                	ld	s0,16(sp)
    80002d32:	64a2                	ld	s1,8(sp)
    80002d34:	6105                	addi	sp,sp,32
    80002d36:	8082                	ret

0000000080002d38 <devintr>:
    asm volatile("csrr %0, scause" : "=r"(x));
    80002d38:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002d3c:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80002d3e:	0a07d163          	bgez	a5,80002de0 <devintr+0xa8>
{
    80002d42:	1101                	addi	sp,sp,-32
    80002d44:	ec06                	sd	ra,24(sp)
    80002d46:	e822                	sd	s0,16(sp)
    80002d48:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80002d4a:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80002d4e:	46a5                	li	a3,9
    80002d50:	00d70c63          	beq	a4,a3,80002d68 <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80002d54:	577d                	li	a4,-1
    80002d56:	177e                	slli	a4,a4,0x3f
    80002d58:	0705                	addi	a4,a4,1
    return 0;
    80002d5a:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002d5c:	06e78163          	beq	a5,a4,80002dbe <devintr+0x86>
  }
}
    80002d60:	60e2                	ld	ra,24(sp)
    80002d62:	6442                	ld	s0,16(sp)
    80002d64:	6105                	addi	sp,sp,32
    80002d66:	8082                	ret
    80002d68:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002d6a:	00003097          	auipc	ra,0x3
    80002d6e:	782080e7          	jalr	1922(ra) # 800064ec <plic_claim>
    80002d72:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002d74:	47a9                	li	a5,10
    80002d76:	00f50963          	beq	a0,a5,80002d88 <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80002d7a:	4785                	li	a5,1
    80002d7c:	00f50b63          	beq	a0,a5,80002d92 <devintr+0x5a>
    return 1;
    80002d80:	4505                	li	a0,1
    } else if(irq){
    80002d82:	ec89                	bnez	s1,80002d9c <devintr+0x64>
    80002d84:	64a2                	ld	s1,8(sp)
    80002d86:	bfe9                	j	80002d60 <devintr+0x28>
      uartintr();
    80002d88:	ffffe097          	auipc	ra,0xffffe
    80002d8c:	c84080e7          	jalr	-892(ra) # 80000a0c <uartintr>
    if(irq)
    80002d90:	a839                	j	80002dae <devintr+0x76>
      virtio_disk_intr();
    80002d92:	00004097          	auipc	ra,0x4
    80002d96:	c84080e7          	jalr	-892(ra) # 80006a16 <virtio_disk_intr>
    if(irq)
    80002d9a:	a811                	j	80002dae <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80002d9c:	85a6                	mv	a1,s1
    80002d9e:	00005517          	auipc	a0,0x5
    80002da2:	64a50513          	addi	a0,a0,1610 # 800083e8 <__func__.1+0x3e0>
    80002da6:	ffffe097          	auipc	ra,0xffffe
    80002daa:	816080e7          	jalr	-2026(ra) # 800005bc <printf>
      plic_complete(irq);
    80002dae:	8526                	mv	a0,s1
    80002db0:	00003097          	auipc	ra,0x3
    80002db4:	760080e7          	jalr	1888(ra) # 80006510 <plic_complete>
    return 1;
    80002db8:	4505                	li	a0,1
    80002dba:	64a2                	ld	s1,8(sp)
    80002dbc:	b755                	j	80002d60 <devintr+0x28>
    if(cpuid() == 0){
    80002dbe:	fffff097          	auipc	ra,0xfffff
    80002dc2:	fa2080e7          	jalr	-94(ra) # 80001d60 <cpuid>
    80002dc6:	c901                	beqz	a0,80002dd6 <devintr+0x9e>
    asm volatile("csrr %0, sip" : "=r"(x));
    80002dc8:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002dcc:	9bf5                	andi	a5,a5,-3
    asm volatile("csrw sip, %0" : : "r"(x));
    80002dce:	14479073          	csrw	sip,a5
    return 2;
    80002dd2:	4509                	li	a0,2
    80002dd4:	b771                	j	80002d60 <devintr+0x28>
      clockintr();
    80002dd6:	00000097          	auipc	ra,0x0
    80002dda:	f1c080e7          	jalr	-228(ra) # 80002cf2 <clockintr>
    80002dde:	b7ed                	j	80002dc8 <devintr+0x90>
}
    80002de0:	8082                	ret

0000000080002de2 <usertrap>:
{
    80002de2:	7179                	addi	sp,sp,-48
    80002de4:	f406                	sd	ra,40(sp)
    80002de6:	f022                	sd	s0,32(sp)
    80002de8:	1800                	addi	s0,sp,48
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002dea:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002dee:	1007f793          	andi	a5,a5,256
    80002df2:	e7bd                	bnez	a5,80002e60 <usertrap+0x7e>
    80002df4:	ec26                	sd	s1,24(sp)
    80002df6:	e84a                	sd	s2,16(sp)
    asm volatile("csrw stvec, %0" : : "r"(x));
    80002df8:	00003797          	auipc	a5,0x3
    80002dfc:	5e878793          	addi	a5,a5,1512 # 800063e0 <kernelvec>
    80002e00:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002e04:	fffff097          	auipc	ra,0xfffff
    80002e08:	f88080e7          	jalr	-120(ra) # 80001d8c <myproc>
    80002e0c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002e0e:	6d3c                	ld	a5,88(a0)
    asm volatile("csrr %0, sepc" : "=r"(x));
    80002e10:	14102773          	csrr	a4,sepc
    80002e14:	ef98                	sd	a4,24(a5)
    asm volatile("csrr %0, scause" : "=r"(x));
    80002e16:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002e1a:	47a1                	li	a5,8
    80002e1c:	04f70e63          	beq	a4,a5,80002e78 <usertrap+0x96>
    80002e20:	14202773          	csrr	a4,scause
  }else if(r_scause() == 15){
    80002e24:	47bd                	li	a5,15
    80002e26:	0ef71e63          	bne	a4,a5,80002f22 <usertrap+0x140>
    asm volatile("csrr %0, stval" : "=r"(x));
    80002e2a:	143025f3          	csrr	a1,stval
    if(fault_addr >= p->sz || fault_addr < PGSIZE){
    80002e2e:	653c                	ld	a5,72(a0)
    80002e30:	00f5f563          	bgeu	a1,a5,80002e3a <usertrap+0x58>
    80002e34:	6785                	lui	a5,0x1
    80002e36:	06f5fb63          	bgeu	a1,a5,80002eac <usertrap+0xca>
      p->killed = 1;
    80002e3a:	4785                	li	a5,1
    80002e3c:	d49c                	sw	a5,40(s1)
  if(killed(p))
    80002e3e:	8526                	mv	a0,s1
    80002e40:	00000097          	auipc	ra,0x0
    80002e44:	9d4080e7          	jalr	-1580(ra) # 80002814 <killed>
    80002e48:	12051763          	bnez	a0,80002f76 <usertrap+0x194>
  usertrapret();
    80002e4c:	00000097          	auipc	ra,0x0
    80002e50:	e10080e7          	jalr	-496(ra) # 80002c5c <usertrapret>
    80002e54:	64e2                	ld	s1,24(sp)
    80002e56:	6942                	ld	s2,16(sp)
}
    80002e58:	70a2                	ld	ra,40(sp)
    80002e5a:	7402                	ld	s0,32(sp)
    80002e5c:	6145                	addi	sp,sp,48
    80002e5e:	8082                	ret
    80002e60:	ec26                	sd	s1,24(sp)
    80002e62:	e84a                	sd	s2,16(sp)
    80002e64:	e44e                	sd	s3,8(sp)
    80002e66:	e052                	sd	s4,0(sp)
    panic("usertrap: not from user mode");
    80002e68:	00005517          	auipc	a0,0x5
    80002e6c:	5a050513          	addi	a0,a0,1440 # 80008408 <__func__.1+0x400>
    80002e70:	ffffd097          	auipc	ra,0xffffd
    80002e74:	6f0080e7          	jalr	1776(ra) # 80000560 <panic>
    if(killed(p))
    80002e78:	00000097          	auipc	ra,0x0
    80002e7c:	99c080e7          	jalr	-1636(ra) # 80002814 <killed>
    80002e80:	e105                	bnez	a0,80002ea0 <usertrap+0xbe>
    p->trapframe->epc += 4;
    80002e82:	6cb8                	ld	a4,88(s1)
    80002e84:	6f1c                	ld	a5,24(a4)
    80002e86:	0791                	addi	a5,a5,4 # 1004 <_entry-0x7fffeffc>
    80002e88:	ef1c                	sd	a5,24(a4)
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002e8a:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002e8e:	0027e793          	ori	a5,a5,2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80002e92:	10079073          	csrw	sstatus,a5
    syscall();
    80002e96:	00000097          	auipc	ra,0x0
    80002e9a:	346080e7          	jalr	838(ra) # 800031dc <syscall>
    80002e9e:	b745                	j	80002e3e <usertrap+0x5c>
      exit(-1);
    80002ea0:	557d                	li	a0,-1
    80002ea2:	fffff097          	auipc	ra,0xfffff
    80002ea6:	7d0080e7          	jalr	2000(ra) # 80002672 <exit>
    80002eaa:	bfe1                	j	80002e82 <usertrap+0xa0>
      pte_t *pte = walk(p->pagetable, fault_addr, 0);
    80002eac:	4601                	li	a2,0
    80002eae:	6928                	ld	a0,80(a0)
    80002eb0:	ffffe097          	auipc	ra,0xffffe
    80002eb4:	3c0080e7          	jalr	960(ra) # 80001270 <walk>
    80002eb8:	892a                	mv	s2,a0
      if(pte && (*pte & PTE_V) && !(*pte & PTE_W)){
    80002eba:	c511                	beqz	a0,80002ec6 <usertrap+0xe4>
    80002ebc:	611c                	ld	a5,0(a0)
    80002ebe:	8b95                	andi	a5,a5,5
    80002ec0:	4705                	li	a4,1
    80002ec2:	00e78563          	beq	a5,a4,80002ecc <usertrap+0xea>
        p->killed = 1;
    80002ec6:	4785                	li	a5,1
    80002ec8:	d49c                	sw	a5,40(s1)
    80002eca:	bf95                	j	80002e3e <usertrap+0x5c>
    80002ecc:	e44e                	sd	s3,8(sp)
        char *mem = kalloc();
    80002ece:	ffffe097          	auipc	ra,0xffffe
    80002ed2:	d54080e7          	jalr	-684(ra) # 80000c22 <kalloc>
    80002ed6:	89aa                	mv	s3,a0
        if(mem == 0){
    80002ed8:	c129                	beqz	a0,80002f1a <usertrap+0x138>
    80002eda:	e052                	sd	s4,0(sp)
          uint64 pa = PTE2PA(*pte);
    80002edc:	00093a03          	ld	s4,0(s2)
    80002ee0:	00aa5a13          	srli	s4,s4,0xa
    80002ee4:	0a32                	slli	s4,s4,0xc
          memmove(mem, (char*)pa, PGSIZE);
    80002ee6:	6605                	lui	a2,0x1
    80002ee8:	85d2                	mv	a1,s4
    80002eea:	ffffe097          	auipc	ra,0xffffe
    80002eee:	106080e7          	jalr	262(ra) # 80000ff0 <memmove>
          *pte = PA2PTE(mem) | PTE_FLAGS(*pte) | PTE_W;
    80002ef2:	00c9d793          	srli	a5,s3,0xc
    80002ef6:	07aa                	slli	a5,a5,0xa
    80002ef8:	00093703          	ld	a4,0(s2)
    80002efc:	2ff77713          	andi	a4,a4,767
          *pte &= ~PTE_COW; 
    80002f00:	8fd9                	or	a5,a5,a4
    80002f02:	0047e793          	ori	a5,a5,4
    80002f06:	00f93023          	sd	a5,0(s2)
          decref((void*)pa);
    80002f0a:	8552                	mv	a0,s4
    80002f0c:	ffffe097          	auipc	ra,0xffffe
    80002f10:	e48080e7          	jalr	-440(ra) # 80000d54 <decref>
    80002f14:	69a2                	ld	s3,8(sp)
    80002f16:	6a02                	ld	s4,0(sp)
    80002f18:	b71d                	j	80002e3e <usertrap+0x5c>
          p->killed = 1;
    80002f1a:	4785                	li	a5,1
    80002f1c:	d49c                	sw	a5,40(s1)
    80002f1e:	69a2                	ld	s3,8(sp)
    80002f20:	bf39                	j	80002e3e <usertrap+0x5c>
  } else if((which_dev = devintr()) != 0){
    80002f22:	00000097          	auipc	ra,0x0
    80002f26:	e16080e7          	jalr	-490(ra) # 80002d38 <devintr>
    80002f2a:	892a                	mv	s2,a0
    80002f2c:	c901                	beqz	a0,80002f3c <usertrap+0x15a>
  if(killed(p))
    80002f2e:	8526                	mv	a0,s1
    80002f30:	00000097          	auipc	ra,0x0
    80002f34:	8e4080e7          	jalr	-1820(ra) # 80002814 <killed>
    80002f38:	c529                	beqz	a0,80002f82 <usertrap+0x1a0>
    80002f3a:	a83d                	j	80002f78 <usertrap+0x196>
    asm volatile("csrr %0, scause" : "=r"(x));
    80002f3c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002f40:	5890                	lw	a2,48(s1)
    80002f42:	00005517          	auipc	a0,0x5
    80002f46:	4e650513          	addi	a0,a0,1254 # 80008428 <__func__.1+0x420>
    80002f4a:	ffffd097          	auipc	ra,0xffffd
    80002f4e:	672080e7          	jalr	1650(ra) # 800005bc <printf>
    asm volatile("csrr %0, sepc" : "=r"(x));
    80002f52:	141025f3          	csrr	a1,sepc
    asm volatile("csrr %0, stval" : "=r"(x));
    80002f56:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002f5a:	00005517          	auipc	a0,0x5
    80002f5e:	4fe50513          	addi	a0,a0,1278 # 80008458 <__func__.1+0x450>
    80002f62:	ffffd097          	auipc	ra,0xffffd
    80002f66:	65a080e7          	jalr	1626(ra) # 800005bc <printf>
    setkilled(p);
    80002f6a:	8526                	mv	a0,s1
    80002f6c:	00000097          	auipc	ra,0x0
    80002f70:	87c080e7          	jalr	-1924(ra) # 800027e8 <setkilled>
    80002f74:	b5e9                	j	80002e3e <usertrap+0x5c>
  if(killed(p))
    80002f76:	4901                	li	s2,0
    exit(-1);
    80002f78:	557d                	li	a0,-1
    80002f7a:	fffff097          	auipc	ra,0xfffff
    80002f7e:	6f8080e7          	jalr	1784(ra) # 80002672 <exit>
  if(which_dev == 2)
    80002f82:	4789                	li	a5,2
    80002f84:	ecf914e3          	bne	s2,a5,80002e4c <usertrap+0x6a>
    yield();
    80002f88:	fffff097          	auipc	ra,0xfffff
    80002f8c:	57a080e7          	jalr	1402(ra) # 80002502 <yield>
    80002f90:	bd75                	j	80002e4c <usertrap+0x6a>

0000000080002f92 <kerneltrap>:
{
    80002f92:	7179                	addi	sp,sp,-48
    80002f94:	f406                	sd	ra,40(sp)
    80002f96:	f022                	sd	s0,32(sp)
    80002f98:	ec26                	sd	s1,24(sp)
    80002f9a:	e84a                	sd	s2,16(sp)
    80002f9c:	e44e                	sd	s3,8(sp)
    80002f9e:	1800                	addi	s0,sp,48
    asm volatile("csrr %0, sepc" : "=r"(x));
    80002fa0:	14102973          	csrr	s2,sepc
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002fa4:	100024f3          	csrr	s1,sstatus
    asm volatile("csrr %0, scause" : "=r"(x));
    80002fa8:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002fac:	1004f793          	andi	a5,s1,256
    80002fb0:	cb85                	beqz	a5,80002fe0 <kerneltrap+0x4e>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002fb2:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    80002fb6:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002fb8:	ef85                	bnez	a5,80002ff0 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002fba:	00000097          	auipc	ra,0x0
    80002fbe:	d7e080e7          	jalr	-642(ra) # 80002d38 <devintr>
    80002fc2:	cd1d                	beqz	a0,80003000 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002fc4:	4789                	li	a5,2
    80002fc6:	06f50a63          	beq	a0,a5,8000303a <kerneltrap+0xa8>
    asm volatile("csrw sepc, %0" : : "r"(x));
    80002fca:	14191073          	csrw	sepc,s2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80002fce:	10049073          	csrw	sstatus,s1
}
    80002fd2:	70a2                	ld	ra,40(sp)
    80002fd4:	7402                	ld	s0,32(sp)
    80002fd6:	64e2                	ld	s1,24(sp)
    80002fd8:	6942                	ld	s2,16(sp)
    80002fda:	69a2                	ld	s3,8(sp)
    80002fdc:	6145                	addi	sp,sp,48
    80002fde:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002fe0:	00005517          	auipc	a0,0x5
    80002fe4:	49850513          	addi	a0,a0,1176 # 80008478 <__func__.1+0x470>
    80002fe8:	ffffd097          	auipc	ra,0xffffd
    80002fec:	578080e7          	jalr	1400(ra) # 80000560 <panic>
    panic("kerneltrap: interrupts enabled");
    80002ff0:	00005517          	auipc	a0,0x5
    80002ff4:	4b050513          	addi	a0,a0,1200 # 800084a0 <__func__.1+0x498>
    80002ff8:	ffffd097          	auipc	ra,0xffffd
    80002ffc:	568080e7          	jalr	1384(ra) # 80000560 <panic>
    printf("scause %p\n", scause);
    80003000:	85ce                	mv	a1,s3
    80003002:	00005517          	auipc	a0,0x5
    80003006:	4be50513          	addi	a0,a0,1214 # 800084c0 <__func__.1+0x4b8>
    8000300a:	ffffd097          	auipc	ra,0xffffd
    8000300e:	5b2080e7          	jalr	1458(ra) # 800005bc <printf>
    asm volatile("csrr %0, sepc" : "=r"(x));
    80003012:	141025f3          	csrr	a1,sepc
    asm volatile("csrr %0, stval" : "=r"(x));
    80003016:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    8000301a:	00005517          	auipc	a0,0x5
    8000301e:	4b650513          	addi	a0,a0,1206 # 800084d0 <__func__.1+0x4c8>
    80003022:	ffffd097          	auipc	ra,0xffffd
    80003026:	59a080e7          	jalr	1434(ra) # 800005bc <printf>
    panic("kerneltrap");
    8000302a:	00005517          	auipc	a0,0x5
    8000302e:	4be50513          	addi	a0,a0,1214 # 800084e8 <__func__.1+0x4e0>
    80003032:	ffffd097          	auipc	ra,0xffffd
    80003036:	52e080e7          	jalr	1326(ra) # 80000560 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000303a:	fffff097          	auipc	ra,0xfffff
    8000303e:	d52080e7          	jalr	-686(ra) # 80001d8c <myproc>
    80003042:	d541                	beqz	a0,80002fca <kerneltrap+0x38>
    80003044:	fffff097          	auipc	ra,0xfffff
    80003048:	d48080e7          	jalr	-696(ra) # 80001d8c <myproc>
    8000304c:	4d18                	lw	a4,24(a0)
    8000304e:	4791                	li	a5,4
    80003050:	f6f71de3          	bne	a4,a5,80002fca <kerneltrap+0x38>
    yield();
    80003054:	fffff097          	auipc	ra,0xfffff
    80003058:	4ae080e7          	jalr	1198(ra) # 80002502 <yield>
    8000305c:	b7bd                	j	80002fca <kerneltrap+0x38>

000000008000305e <argraw>:
    return strlen(buf);
}

static uint64
argraw(int n)
{
    8000305e:	1101                	addi	sp,sp,-32
    80003060:	ec06                	sd	ra,24(sp)
    80003062:	e822                	sd	s0,16(sp)
    80003064:	e426                	sd	s1,8(sp)
    80003066:	1000                	addi	s0,sp,32
    80003068:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    8000306a:	fffff097          	auipc	ra,0xfffff
    8000306e:	d22080e7          	jalr	-734(ra) # 80001d8c <myproc>
    switch (n)
    80003072:	4795                	li	a5,5
    80003074:	0497e163          	bltu	a5,s1,800030b6 <argraw+0x58>
    80003078:	048a                	slli	s1,s1,0x2
    8000307a:	00006717          	auipc	a4,0x6
    8000307e:	83670713          	addi	a4,a4,-1994 # 800088b0 <states.0+0x30>
    80003082:	94ba                	add	s1,s1,a4
    80003084:	409c                	lw	a5,0(s1)
    80003086:	97ba                	add	a5,a5,a4
    80003088:	8782                	jr	a5
    {
    case 0:
        return p->trapframe->a0;
    8000308a:	6d3c                	ld	a5,88(a0)
    8000308c:	7ba8                	ld	a0,112(a5)
    case 5:
        return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
}
    8000308e:	60e2                	ld	ra,24(sp)
    80003090:	6442                	ld	s0,16(sp)
    80003092:	64a2                	ld	s1,8(sp)
    80003094:	6105                	addi	sp,sp,32
    80003096:	8082                	ret
        return p->trapframe->a1;
    80003098:	6d3c                	ld	a5,88(a0)
    8000309a:	7fa8                	ld	a0,120(a5)
    8000309c:	bfcd                	j	8000308e <argraw+0x30>
        return p->trapframe->a2;
    8000309e:	6d3c                	ld	a5,88(a0)
    800030a0:	63c8                	ld	a0,128(a5)
    800030a2:	b7f5                	j	8000308e <argraw+0x30>
        return p->trapframe->a3;
    800030a4:	6d3c                	ld	a5,88(a0)
    800030a6:	67c8                	ld	a0,136(a5)
    800030a8:	b7dd                	j	8000308e <argraw+0x30>
        return p->trapframe->a4;
    800030aa:	6d3c                	ld	a5,88(a0)
    800030ac:	6bc8                	ld	a0,144(a5)
    800030ae:	b7c5                	j	8000308e <argraw+0x30>
        return p->trapframe->a5;
    800030b0:	6d3c                	ld	a5,88(a0)
    800030b2:	6fc8                	ld	a0,152(a5)
    800030b4:	bfe9                	j	8000308e <argraw+0x30>
    panic("argraw");
    800030b6:	00005517          	auipc	a0,0x5
    800030ba:	44250513          	addi	a0,a0,1090 # 800084f8 <__func__.1+0x4f0>
    800030be:	ffffd097          	auipc	ra,0xffffd
    800030c2:	4a2080e7          	jalr	1186(ra) # 80000560 <panic>

00000000800030c6 <fetchaddr>:
{
    800030c6:	1101                	addi	sp,sp,-32
    800030c8:	ec06                	sd	ra,24(sp)
    800030ca:	e822                	sd	s0,16(sp)
    800030cc:	e426                	sd	s1,8(sp)
    800030ce:	e04a                	sd	s2,0(sp)
    800030d0:	1000                	addi	s0,sp,32
    800030d2:	84aa                	mv	s1,a0
    800030d4:	892e                	mv	s2,a1
    struct proc *p = myproc();
    800030d6:	fffff097          	auipc	ra,0xfffff
    800030da:	cb6080e7          	jalr	-842(ra) # 80001d8c <myproc>
    if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800030de:	653c                	ld	a5,72(a0)
    800030e0:	02f4f863          	bgeu	s1,a5,80003110 <fetchaddr+0x4a>
    800030e4:	00848713          	addi	a4,s1,8
    800030e8:	02e7e663          	bltu	a5,a4,80003114 <fetchaddr+0x4e>
    if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800030ec:	46a1                	li	a3,8
    800030ee:	8626                	mv	a2,s1
    800030f0:	85ca                	mv	a1,s2
    800030f2:	6928                	ld	a0,80(a0)
    800030f4:	fffff097          	auipc	ra,0xfffff
    800030f8:	8c8080e7          	jalr	-1848(ra) # 800019bc <copyin>
    800030fc:	00a03533          	snez	a0,a0
    80003100:	40a00533          	neg	a0,a0
}
    80003104:	60e2                	ld	ra,24(sp)
    80003106:	6442                	ld	s0,16(sp)
    80003108:	64a2                	ld	s1,8(sp)
    8000310a:	6902                	ld	s2,0(sp)
    8000310c:	6105                	addi	sp,sp,32
    8000310e:	8082                	ret
        return -1;
    80003110:	557d                	li	a0,-1
    80003112:	bfcd                	j	80003104 <fetchaddr+0x3e>
    80003114:	557d                	li	a0,-1
    80003116:	b7fd                	j	80003104 <fetchaddr+0x3e>

0000000080003118 <fetchstr>:
{
    80003118:	7179                	addi	sp,sp,-48
    8000311a:	f406                	sd	ra,40(sp)
    8000311c:	f022                	sd	s0,32(sp)
    8000311e:	ec26                	sd	s1,24(sp)
    80003120:	e84a                	sd	s2,16(sp)
    80003122:	e44e                	sd	s3,8(sp)
    80003124:	1800                	addi	s0,sp,48
    80003126:	892a                	mv	s2,a0
    80003128:	84ae                	mv	s1,a1
    8000312a:	89b2                	mv	s3,a2
    struct proc *p = myproc();
    8000312c:	fffff097          	auipc	ra,0xfffff
    80003130:	c60080e7          	jalr	-928(ra) # 80001d8c <myproc>
    if (copyinstr(p->pagetable, buf, addr, max) < 0)
    80003134:	86ce                	mv	a3,s3
    80003136:	864a                	mv	a2,s2
    80003138:	85a6                	mv	a1,s1
    8000313a:	6928                	ld	a0,80(a0)
    8000313c:	fffff097          	auipc	ra,0xfffff
    80003140:	90e080e7          	jalr	-1778(ra) # 80001a4a <copyinstr>
    80003144:	00054e63          	bltz	a0,80003160 <fetchstr+0x48>
    return strlen(buf);
    80003148:	8526                	mv	a0,s1
    8000314a:	ffffe097          	auipc	ra,0xffffe
    8000314e:	fbe080e7          	jalr	-66(ra) # 80001108 <strlen>
}
    80003152:	70a2                	ld	ra,40(sp)
    80003154:	7402                	ld	s0,32(sp)
    80003156:	64e2                	ld	s1,24(sp)
    80003158:	6942                	ld	s2,16(sp)
    8000315a:	69a2                	ld	s3,8(sp)
    8000315c:	6145                	addi	sp,sp,48
    8000315e:	8082                	ret
        return -1;
    80003160:	557d                	li	a0,-1
    80003162:	bfc5                	j	80003152 <fetchstr+0x3a>

0000000080003164 <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip)
{
    80003164:	1101                	addi	sp,sp,-32
    80003166:	ec06                	sd	ra,24(sp)
    80003168:	e822                	sd	s0,16(sp)
    8000316a:	e426                	sd	s1,8(sp)
    8000316c:	1000                	addi	s0,sp,32
    8000316e:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80003170:	00000097          	auipc	ra,0x0
    80003174:	eee080e7          	jalr	-274(ra) # 8000305e <argraw>
    80003178:	c088                	sw	a0,0(s1)
}
    8000317a:	60e2                	ld	ra,24(sp)
    8000317c:	6442                	ld	s0,16(sp)
    8000317e:	64a2                	ld	s1,8(sp)
    80003180:	6105                	addi	sp,sp,32
    80003182:	8082                	ret

0000000080003184 <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip)
{
    80003184:	1101                	addi	sp,sp,-32
    80003186:	ec06                	sd	ra,24(sp)
    80003188:	e822                	sd	s0,16(sp)
    8000318a:	e426                	sd	s1,8(sp)
    8000318c:	1000                	addi	s0,sp,32
    8000318e:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80003190:	00000097          	auipc	ra,0x0
    80003194:	ece080e7          	jalr	-306(ra) # 8000305e <argraw>
    80003198:	e088                	sd	a0,0(s1)
}
    8000319a:	60e2                	ld	ra,24(sp)
    8000319c:	6442                	ld	s0,16(sp)
    8000319e:	64a2                	ld	s1,8(sp)
    800031a0:	6105                	addi	sp,sp,32
    800031a2:	8082                	ret

00000000800031a4 <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    800031a4:	7179                	addi	sp,sp,-48
    800031a6:	f406                	sd	ra,40(sp)
    800031a8:	f022                	sd	s0,32(sp)
    800031aa:	ec26                	sd	s1,24(sp)
    800031ac:	e84a                	sd	s2,16(sp)
    800031ae:	1800                	addi	s0,sp,48
    800031b0:	84ae                	mv	s1,a1
    800031b2:	8932                	mv	s2,a2
    uint64 addr;
    argaddr(n, &addr);
    800031b4:	fd840593          	addi	a1,s0,-40
    800031b8:	00000097          	auipc	ra,0x0
    800031bc:	fcc080e7          	jalr	-52(ra) # 80003184 <argaddr>
    return fetchstr(addr, buf, max);
    800031c0:	864a                	mv	a2,s2
    800031c2:	85a6                	mv	a1,s1
    800031c4:	fd843503          	ld	a0,-40(s0)
    800031c8:	00000097          	auipc	ra,0x0
    800031cc:	f50080e7          	jalr	-176(ra) # 80003118 <fetchstr>
}
    800031d0:	70a2                	ld	ra,40(sp)
    800031d2:	7402                	ld	s0,32(sp)
    800031d4:	64e2                	ld	s1,24(sp)
    800031d6:	6942                	ld	s2,16(sp)
    800031d8:	6145                	addi	sp,sp,48
    800031da:	8082                	ret

00000000800031dc <syscall>:
    [SYS_pfreepages] sys_pfreepages,
    [SYS_va2pa] sys_va2pa,
};

void syscall(void)
{
    800031dc:	1101                	addi	sp,sp,-32
    800031de:	ec06                	sd	ra,24(sp)
    800031e0:	e822                	sd	s0,16(sp)
    800031e2:	e426                	sd	s1,8(sp)
    800031e4:	e04a                	sd	s2,0(sp)
    800031e6:	1000                	addi	s0,sp,32
    int num;
    struct proc *p = myproc();
    800031e8:	fffff097          	auipc	ra,0xfffff
    800031ec:	ba4080e7          	jalr	-1116(ra) # 80001d8c <myproc>
    800031f0:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    800031f2:	05853903          	ld	s2,88(a0)
    800031f6:	0a893783          	ld	a5,168(s2)
    800031fa:	0007869b          	sext.w	a3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    800031fe:	37fd                	addiw	a5,a5,-1
    80003200:	4765                	li	a4,25
    80003202:	00f76f63          	bltu	a4,a5,80003220 <syscall+0x44>
    80003206:	00369713          	slli	a4,a3,0x3
    8000320a:	00005797          	auipc	a5,0x5
    8000320e:	6be78793          	addi	a5,a5,1726 # 800088c8 <syscalls>
    80003212:	97ba                	add	a5,a5,a4
    80003214:	639c                	ld	a5,0(a5)
    80003216:	c789                	beqz	a5,80003220 <syscall+0x44>
    {
        // Use num to lookup the system call function for num, call it,
        // and store its return value in p->trapframe->a0
        p->trapframe->a0 = syscalls[num]();
    80003218:	9782                	jalr	a5
    8000321a:	06a93823          	sd	a0,112(s2)
    8000321e:	a839                	j	8000323c <syscall+0x60>
    }
    else
    {
        printf("%d %s: unknown sys call %d\n",
    80003220:	15848613          	addi	a2,s1,344
    80003224:	588c                	lw	a1,48(s1)
    80003226:	00005517          	auipc	a0,0x5
    8000322a:	2da50513          	addi	a0,a0,730 # 80008500 <__func__.1+0x4f8>
    8000322e:	ffffd097          	auipc	ra,0xffffd
    80003232:	38e080e7          	jalr	910(ra) # 800005bc <printf>
               p->pid, p->name, num);
        p->trapframe->a0 = -1;
    80003236:	6cbc                	ld	a5,88(s1)
    80003238:	577d                	li	a4,-1
    8000323a:	fbb8                	sd	a4,112(a5)
    }
}
    8000323c:	60e2                	ld	ra,24(sp)
    8000323e:	6442                	ld	s0,16(sp)
    80003240:	64a2                	ld	s1,8(sp)
    80003242:	6902                	ld	s2,0(sp)
    80003244:	6105                	addi	sp,sp,32
    80003246:	8082                	ret

0000000080003248 <sys_exit>:

extern uint64 FREE_PAGES; // kalloc.c keeps track of those

uint64
sys_exit(void)
{
    80003248:	1101                	addi	sp,sp,-32
    8000324a:	ec06                	sd	ra,24(sp)
    8000324c:	e822                	sd	s0,16(sp)
    8000324e:	1000                	addi	s0,sp,32
    int n;
    argint(0, &n);
    80003250:	fec40593          	addi	a1,s0,-20
    80003254:	4501                	li	a0,0
    80003256:	00000097          	auipc	ra,0x0
    8000325a:	f0e080e7          	jalr	-242(ra) # 80003164 <argint>
    exit(n);
    8000325e:	fec42503          	lw	a0,-20(s0)
    80003262:	fffff097          	auipc	ra,0xfffff
    80003266:	410080e7          	jalr	1040(ra) # 80002672 <exit>
    return 0; // not reached
}
    8000326a:	4501                	li	a0,0
    8000326c:	60e2                	ld	ra,24(sp)
    8000326e:	6442                	ld	s0,16(sp)
    80003270:	6105                	addi	sp,sp,32
    80003272:	8082                	ret

0000000080003274 <sys_getpid>:

uint64
sys_getpid(void)
{
    80003274:	1141                	addi	sp,sp,-16
    80003276:	e406                	sd	ra,8(sp)
    80003278:	e022                	sd	s0,0(sp)
    8000327a:	0800                	addi	s0,sp,16
    return myproc()->pid;
    8000327c:	fffff097          	auipc	ra,0xfffff
    80003280:	b10080e7          	jalr	-1264(ra) # 80001d8c <myproc>
}
    80003284:	5908                	lw	a0,48(a0)
    80003286:	60a2                	ld	ra,8(sp)
    80003288:	6402                	ld	s0,0(sp)
    8000328a:	0141                	addi	sp,sp,16
    8000328c:	8082                	ret

000000008000328e <sys_fork>:

uint64
sys_fork(void)
{
    8000328e:	1141                	addi	sp,sp,-16
    80003290:	e406                	sd	ra,8(sp)
    80003292:	e022                	sd	s0,0(sp)
    80003294:	0800                	addi	s0,sp,16
    return fork();
    80003296:	fffff097          	auipc	ra,0xfffff
    8000329a:	044080e7          	jalr	68(ra) # 800022da <fork>
}
    8000329e:	60a2                	ld	ra,8(sp)
    800032a0:	6402                	ld	s0,0(sp)
    800032a2:	0141                	addi	sp,sp,16
    800032a4:	8082                	ret

00000000800032a6 <sys_wait>:

uint64
sys_wait(void)
{
    800032a6:	1101                	addi	sp,sp,-32
    800032a8:	ec06                	sd	ra,24(sp)
    800032aa:	e822                	sd	s0,16(sp)
    800032ac:	1000                	addi	s0,sp,32
    uint64 p;
    argaddr(0, &p);
    800032ae:	fe840593          	addi	a1,s0,-24
    800032b2:	4501                	li	a0,0
    800032b4:	00000097          	auipc	ra,0x0
    800032b8:	ed0080e7          	jalr	-304(ra) # 80003184 <argaddr>
    return wait(p);
    800032bc:	fe843503          	ld	a0,-24(s0)
    800032c0:	fffff097          	auipc	ra,0xfffff
    800032c4:	586080e7          	jalr	1414(ra) # 80002846 <wait>
}
    800032c8:	60e2                	ld	ra,24(sp)
    800032ca:	6442                	ld	s0,16(sp)
    800032cc:	6105                	addi	sp,sp,32
    800032ce:	8082                	ret

00000000800032d0 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800032d0:	7179                	addi	sp,sp,-48
    800032d2:	f406                	sd	ra,40(sp)
    800032d4:	f022                	sd	s0,32(sp)
    800032d6:	ec26                	sd	s1,24(sp)
    800032d8:	1800                	addi	s0,sp,48
    uint64 addr;
    int n;

    argint(0, &n);
    800032da:	fdc40593          	addi	a1,s0,-36
    800032de:	4501                	li	a0,0
    800032e0:	00000097          	auipc	ra,0x0
    800032e4:	e84080e7          	jalr	-380(ra) # 80003164 <argint>
    addr = myproc()->sz;
    800032e8:	fffff097          	auipc	ra,0xfffff
    800032ec:	aa4080e7          	jalr	-1372(ra) # 80001d8c <myproc>
    800032f0:	6524                	ld	s1,72(a0)
    if (growproc(n) < 0)
    800032f2:	fdc42503          	lw	a0,-36(s0)
    800032f6:	fffff097          	auipc	ra,0xfffff
    800032fa:	df0080e7          	jalr	-528(ra) # 800020e6 <growproc>
    800032fe:	00054863          	bltz	a0,8000330e <sys_sbrk+0x3e>
        return -1;
    return addr;
}
    80003302:	8526                	mv	a0,s1
    80003304:	70a2                	ld	ra,40(sp)
    80003306:	7402                	ld	s0,32(sp)
    80003308:	64e2                	ld	s1,24(sp)
    8000330a:	6145                	addi	sp,sp,48
    8000330c:	8082                	ret
        return -1;
    8000330e:	54fd                	li	s1,-1
    80003310:	bfcd                	j	80003302 <sys_sbrk+0x32>

0000000080003312 <sys_sleep>:

uint64
sys_sleep(void)
{
    80003312:	7139                	addi	sp,sp,-64
    80003314:	fc06                	sd	ra,56(sp)
    80003316:	f822                	sd	s0,48(sp)
    80003318:	f04a                	sd	s2,32(sp)
    8000331a:	0080                	addi	s0,sp,64
    int n;
    uint ticks0;

    argint(0, &n);
    8000331c:	fcc40593          	addi	a1,s0,-52
    80003320:	4501                	li	a0,0
    80003322:	00000097          	auipc	ra,0x0
    80003326:	e42080e7          	jalr	-446(ra) # 80003164 <argint>
    acquire(&tickslock);
    8000332a:	00236517          	auipc	a0,0x236
    8000332e:	32650513          	addi	a0,a0,806 # 80239650 <tickslock>
    80003332:	ffffe097          	auipc	ra,0xffffe
    80003336:	b66080e7          	jalr	-1178(ra) # 80000e98 <acquire>
    ticks0 = ticks;
    8000333a:	00008917          	auipc	s2,0x8
    8000333e:	27692903          	lw	s2,630(s2) # 8000b5b0 <ticks>
    while (ticks - ticks0 < n)
    80003342:	fcc42783          	lw	a5,-52(s0)
    80003346:	c3b9                	beqz	a5,8000338c <sys_sleep+0x7a>
    80003348:	f426                	sd	s1,40(sp)
    8000334a:	ec4e                	sd	s3,24(sp)
        if (killed(myproc()))
        {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
    8000334c:	00236997          	auipc	s3,0x236
    80003350:	30498993          	addi	s3,s3,772 # 80239650 <tickslock>
    80003354:	00008497          	auipc	s1,0x8
    80003358:	25c48493          	addi	s1,s1,604 # 8000b5b0 <ticks>
        if (killed(myproc()))
    8000335c:	fffff097          	auipc	ra,0xfffff
    80003360:	a30080e7          	jalr	-1488(ra) # 80001d8c <myproc>
    80003364:	fffff097          	auipc	ra,0xfffff
    80003368:	4b0080e7          	jalr	1200(ra) # 80002814 <killed>
    8000336c:	ed15                	bnez	a0,800033a8 <sys_sleep+0x96>
        sleep(&ticks, &tickslock);
    8000336e:	85ce                	mv	a1,s3
    80003370:	8526                	mv	a0,s1
    80003372:	fffff097          	auipc	ra,0xfffff
    80003376:	1cc080e7          	jalr	460(ra) # 8000253e <sleep>
    while (ticks - ticks0 < n)
    8000337a:	409c                	lw	a5,0(s1)
    8000337c:	412787bb          	subw	a5,a5,s2
    80003380:	fcc42703          	lw	a4,-52(s0)
    80003384:	fce7ece3          	bltu	a5,a4,8000335c <sys_sleep+0x4a>
    80003388:	74a2                	ld	s1,40(sp)
    8000338a:	69e2                	ld	s3,24(sp)
    }
    release(&tickslock);
    8000338c:	00236517          	auipc	a0,0x236
    80003390:	2c450513          	addi	a0,a0,708 # 80239650 <tickslock>
    80003394:	ffffe097          	auipc	ra,0xffffe
    80003398:	bb8080e7          	jalr	-1096(ra) # 80000f4c <release>
    return 0;
    8000339c:	4501                	li	a0,0
}
    8000339e:	70e2                	ld	ra,56(sp)
    800033a0:	7442                	ld	s0,48(sp)
    800033a2:	7902                	ld	s2,32(sp)
    800033a4:	6121                	addi	sp,sp,64
    800033a6:	8082                	ret
            release(&tickslock);
    800033a8:	00236517          	auipc	a0,0x236
    800033ac:	2a850513          	addi	a0,a0,680 # 80239650 <tickslock>
    800033b0:	ffffe097          	auipc	ra,0xffffe
    800033b4:	b9c080e7          	jalr	-1124(ra) # 80000f4c <release>
            return -1;
    800033b8:	557d                	li	a0,-1
    800033ba:	74a2                	ld	s1,40(sp)
    800033bc:	69e2                	ld	s3,24(sp)
    800033be:	b7c5                	j	8000339e <sys_sleep+0x8c>

00000000800033c0 <sys_kill>:

uint64
sys_kill(void)
{
    800033c0:	1101                	addi	sp,sp,-32
    800033c2:	ec06                	sd	ra,24(sp)
    800033c4:	e822                	sd	s0,16(sp)
    800033c6:	1000                	addi	s0,sp,32
    int pid;

    argint(0, &pid);
    800033c8:	fec40593          	addi	a1,s0,-20
    800033cc:	4501                	li	a0,0
    800033ce:	00000097          	auipc	ra,0x0
    800033d2:	d96080e7          	jalr	-618(ra) # 80003164 <argint>
    return kill(pid);
    800033d6:	fec42503          	lw	a0,-20(s0)
    800033da:	fffff097          	auipc	ra,0xfffff
    800033de:	39c080e7          	jalr	924(ra) # 80002776 <kill>
}
    800033e2:	60e2                	ld	ra,24(sp)
    800033e4:	6442                	ld	s0,16(sp)
    800033e6:	6105                	addi	sp,sp,32
    800033e8:	8082                	ret

00000000800033ea <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800033ea:	1101                	addi	sp,sp,-32
    800033ec:	ec06                	sd	ra,24(sp)
    800033ee:	e822                	sd	s0,16(sp)
    800033f0:	e426                	sd	s1,8(sp)
    800033f2:	1000                	addi	s0,sp,32
    uint xticks;

    acquire(&tickslock);
    800033f4:	00236517          	auipc	a0,0x236
    800033f8:	25c50513          	addi	a0,a0,604 # 80239650 <tickslock>
    800033fc:	ffffe097          	auipc	ra,0xffffe
    80003400:	a9c080e7          	jalr	-1380(ra) # 80000e98 <acquire>
    xticks = ticks;
    80003404:	00008497          	auipc	s1,0x8
    80003408:	1ac4a483          	lw	s1,428(s1) # 8000b5b0 <ticks>
    release(&tickslock);
    8000340c:	00236517          	auipc	a0,0x236
    80003410:	24450513          	addi	a0,a0,580 # 80239650 <tickslock>
    80003414:	ffffe097          	auipc	ra,0xffffe
    80003418:	b38080e7          	jalr	-1224(ra) # 80000f4c <release>
    return xticks;
}
    8000341c:	02049513          	slli	a0,s1,0x20
    80003420:	9101                	srli	a0,a0,0x20
    80003422:	60e2                	ld	ra,24(sp)
    80003424:	6442                	ld	s0,16(sp)
    80003426:	64a2                	ld	s1,8(sp)
    80003428:	6105                	addi	sp,sp,32
    8000342a:	8082                	ret

000000008000342c <sys_ps>:

void *
sys_ps(void)
{
    8000342c:	1101                	addi	sp,sp,-32
    8000342e:	ec06                	sd	ra,24(sp)
    80003430:	e822                	sd	s0,16(sp)
    80003432:	1000                	addi	s0,sp,32
    int start = 0, count = 0;
    80003434:	fe042623          	sw	zero,-20(s0)
    80003438:	fe042423          	sw	zero,-24(s0)
    argint(0, &start);
    8000343c:	fec40593          	addi	a1,s0,-20
    80003440:	4501                	li	a0,0
    80003442:	00000097          	auipc	ra,0x0
    80003446:	d22080e7          	jalr	-734(ra) # 80003164 <argint>
    argint(1, &count);
    8000344a:	fe840593          	addi	a1,s0,-24
    8000344e:	4505                	li	a0,1
    80003450:	00000097          	auipc	ra,0x0
    80003454:	d14080e7          	jalr	-748(ra) # 80003164 <argint>
    return ps((uint8)start, (uint8)count);
    80003458:	fe844583          	lbu	a1,-24(s0)
    8000345c:	fec44503          	lbu	a0,-20(s0)
    80003460:	fffff097          	auipc	ra,0xfffff
    80003464:	ce2080e7          	jalr	-798(ra) # 80002142 <ps>
}
    80003468:	60e2                	ld	ra,24(sp)
    8000346a:	6442                	ld	s0,16(sp)
    8000346c:	6105                	addi	sp,sp,32
    8000346e:	8082                	ret

0000000080003470 <sys_schedls>:

uint64 sys_schedls(void)
{
    80003470:	1141                	addi	sp,sp,-16
    80003472:	e406                	sd	ra,8(sp)
    80003474:	e022                	sd	s0,0(sp)
    80003476:	0800                	addi	s0,sp,16
    schedls();
    80003478:	fffff097          	auipc	ra,0xfffff
    8000347c:	658080e7          	jalr	1624(ra) # 80002ad0 <schedls>
    return 0;
}
    80003480:	4501                	li	a0,0
    80003482:	60a2                	ld	ra,8(sp)
    80003484:	6402                	ld	s0,0(sp)
    80003486:	0141                	addi	sp,sp,16
    80003488:	8082                	ret

000000008000348a <sys_schedset>:

uint64 sys_schedset(void)
{
    8000348a:	1101                	addi	sp,sp,-32
    8000348c:	ec06                	sd	ra,24(sp)
    8000348e:	e822                	sd	s0,16(sp)
    80003490:	1000                	addi	s0,sp,32
    int id = 0;
    80003492:	fe042623          	sw	zero,-20(s0)
    argint(0, &id);
    80003496:	fec40593          	addi	a1,s0,-20
    8000349a:	4501                	li	a0,0
    8000349c:	00000097          	auipc	ra,0x0
    800034a0:	cc8080e7          	jalr	-824(ra) # 80003164 <argint>
    schedset(id - 1);
    800034a4:	fec42503          	lw	a0,-20(s0)
    800034a8:	357d                	addiw	a0,a0,-1
    800034aa:	fffff097          	auipc	ra,0xfffff
    800034ae:	6bc080e7          	jalr	1724(ra) # 80002b66 <schedset>
    return 0;
}
    800034b2:	4501                	li	a0,0
    800034b4:	60e2                	ld	ra,24(sp)
    800034b6:	6442                	ld	s0,16(sp)
    800034b8:	6105                	addi	sp,sp,32
    800034ba:	8082                	ret

00000000800034bc <sys_va2pa>:

uint64 sys_va2pa(void) {
    800034bc:	1101                	addi	sp,sp,-32
    800034be:	ec06                	sd	ra,24(sp)
    800034c0:	e822                	sd	s0,16(sp)
    800034c2:	1000                	addi	s0,sp,32
    uint64 va;
    int pid;
    
    // Retrieve the arguments (these functions return void in your version)
    argaddr(0, &va);
    800034c4:	fe840593          	addi	a1,s0,-24
    800034c8:	4501                	li	a0,0
    800034ca:	00000097          	auipc	ra,0x0
    800034ce:	cba080e7          	jalr	-838(ra) # 80003184 <argaddr>
    argint(1, &pid);
    800034d2:	fe440593          	addi	a1,s0,-28
    800034d6:	4505                	li	a0,1
    800034d8:	00000097          	auipc	ra,0x0
    800034dc:	c8c080e7          	jalr	-884(ra) # 80003164 <argint>

    struct proc *p = 0;

    // If pid is 0, use the current process.
    if (pid == 0) {
    800034e0:	fe442603          	lw	a2,-28(s0)
    800034e4:	00230717          	auipc	a4,0x230
    800034e8:	79c70713          	addi	a4,a4,1948 # 80233c80 <proc+0x30>
        p = myproc();
    } else {
        // Iterate through the global process table 'proc'
        for (int i = 0; i < NPROC; i++) {
    800034ec:	4781                	li	a5,0
    800034ee:	04000593          	li	a1,64
    if (pid == 0) {
    800034f2:	ca19                	beqz	a2,80003508 <sys_va2pa+0x4c>
            if (proc[i].pid == pid) {
    800034f4:	4314                	lw	a3,0(a4)
    800034f6:	02c68063          	beq	a3,a2,80003516 <sys_va2pa+0x5a>
        for (int i = 0; i < NPROC; i++) {
    800034fa:	2785                	addiw	a5,a5,1
    800034fc:	16870713          	addi	a4,a4,360
    80003500:	feb79ae3          	bne	a5,a1,800034f4 <sys_va2pa+0x38>
            }
        }
    }

    if (p == 0)
        return 0;
    80003504:	4501                	li	a0,0
    80003506:	a091                	j	8000354a <sys_va2pa+0x8e>
        p = myproc();
    80003508:	fffff097          	auipc	ra,0xfffff
    8000350c:	884080e7          	jalr	-1916(ra) # 80001d8c <myproc>
    if (p == 0)
    80003510:	ed09                	bnez	a0,8000352a <sys_va2pa+0x6e>
        return 0;
    80003512:	4501                	li	a0,0
    80003514:	a81d                	j	8000354a <sys_va2pa+0x8e>
                p = &proc[i];
    80003516:	16800713          	li	a4,360
    8000351a:	02e787b3          	mul	a5,a5,a4
    8000351e:	00230717          	auipc	a4,0x230
    80003522:	73270713          	addi	a4,a4,1842 # 80233c50 <proc>
    80003526:	00e78533          	add	a0,a5,a4

    // Walk the page table to find the mapping for the virtual address.
    pte_t *pte = walk(p->pagetable, va, 0);
    8000352a:	4601                	li	a2,0
    8000352c:	fe843583          	ld	a1,-24(s0)
    80003530:	6928                	ld	a0,80(a0)
    80003532:	ffffe097          	auipc	ra,0xffffe
    80003536:	d3e080e7          	jalr	-706(ra) # 80001270 <walk>
    if (pte == 0 || ((*pte) & PTE_V) == 0)
    8000353a:	cd01                	beqz	a0,80003552 <sys_va2pa+0x96>
    8000353c:	611c                	ld	a5,0(a0)
    8000353e:	0017f513          	andi	a0,a5,1
    80003542:	c501                	beqz	a0,8000354a <sys_va2pa+0x8e>
        return 0;

    uint64 pa = PTE2PA(*pte);
    80003544:	83a9                	srli	a5,a5,0xa
    80003546:	00c79513          	slli	a0,a5,0xc
    return pa;
}
    8000354a:	60e2                	ld	ra,24(sp)
    8000354c:	6442                	ld	s0,16(sp)
    8000354e:	6105                	addi	sp,sp,32
    80003550:	8082                	ret
        return 0;
    80003552:	4501                	li	a0,0
    80003554:	bfdd                	j	8000354a <sys_va2pa+0x8e>

0000000080003556 <sys_pfreepages>:

uint64 sys_pfreepages(void)
{
    80003556:	1141                	addi	sp,sp,-16
    80003558:	e406                	sd	ra,8(sp)
    8000355a:	e022                	sd	s0,0(sp)
    8000355c:	0800                	addi	s0,sp,16
    printf("%d\n", FREE_PAGES);
    8000355e:	00008597          	auipc	a1,0x8
    80003562:	02a5b583          	ld	a1,42(a1) # 8000b588 <FREE_PAGES>
    80003566:	00005517          	auipc	a0,0x5
    8000356a:	fba50513          	addi	a0,a0,-70 # 80008520 <__func__.1+0x518>
    8000356e:	ffffd097          	auipc	ra,0xffffd
    80003572:	04e080e7          	jalr	78(ra) # 800005bc <printf>
    return 0;
    80003576:	4501                	li	a0,0
    80003578:	60a2                	ld	ra,8(sp)
    8000357a:	6402                	ld	s0,0(sp)
    8000357c:	0141                	addi	sp,sp,16
    8000357e:	8082                	ret

0000000080003580 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003580:	7179                	addi	sp,sp,-48
    80003582:	f406                	sd	ra,40(sp)
    80003584:	f022                	sd	s0,32(sp)
    80003586:	ec26                	sd	s1,24(sp)
    80003588:	e84a                	sd	s2,16(sp)
    8000358a:	e44e                	sd	s3,8(sp)
    8000358c:	e052                	sd	s4,0(sp)
    8000358e:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003590:	00005597          	auipc	a1,0x5
    80003594:	f9858593          	addi	a1,a1,-104 # 80008528 <__func__.1+0x520>
    80003598:	00236517          	auipc	a0,0x236
    8000359c:	0d050513          	addi	a0,a0,208 # 80239668 <bcache>
    800035a0:	ffffe097          	auipc	ra,0xffffe
    800035a4:	868080e7          	jalr	-1944(ra) # 80000e08 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800035a8:	0023e797          	auipc	a5,0x23e
    800035ac:	0c078793          	addi	a5,a5,192 # 80241668 <bcache+0x8000>
    800035b0:	0023e717          	auipc	a4,0x23e
    800035b4:	32070713          	addi	a4,a4,800 # 802418d0 <bcache+0x8268>
    800035b8:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800035bc:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800035c0:	00236497          	auipc	s1,0x236
    800035c4:	0c048493          	addi	s1,s1,192 # 80239680 <bcache+0x18>
    b->next = bcache.head.next;
    800035c8:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800035ca:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800035cc:	00005a17          	auipc	s4,0x5
    800035d0:	f64a0a13          	addi	s4,s4,-156 # 80008530 <__func__.1+0x528>
    b->next = bcache.head.next;
    800035d4:	2b893783          	ld	a5,696(s2)
    800035d8:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800035da:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800035de:	85d2                	mv	a1,s4
    800035e0:	01048513          	addi	a0,s1,16
    800035e4:	00001097          	auipc	ra,0x1
    800035e8:	4e8080e7          	jalr	1256(ra) # 80004acc <initsleeplock>
    bcache.head.next->prev = b;
    800035ec:	2b893783          	ld	a5,696(s2)
    800035f0:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800035f2:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800035f6:	45848493          	addi	s1,s1,1112
    800035fa:	fd349de3          	bne	s1,s3,800035d4 <binit+0x54>
  }
}
    800035fe:	70a2                	ld	ra,40(sp)
    80003600:	7402                	ld	s0,32(sp)
    80003602:	64e2                	ld	s1,24(sp)
    80003604:	6942                	ld	s2,16(sp)
    80003606:	69a2                	ld	s3,8(sp)
    80003608:	6a02                	ld	s4,0(sp)
    8000360a:	6145                	addi	sp,sp,48
    8000360c:	8082                	ret

000000008000360e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000360e:	7179                	addi	sp,sp,-48
    80003610:	f406                	sd	ra,40(sp)
    80003612:	f022                	sd	s0,32(sp)
    80003614:	ec26                	sd	s1,24(sp)
    80003616:	e84a                	sd	s2,16(sp)
    80003618:	e44e                	sd	s3,8(sp)
    8000361a:	1800                	addi	s0,sp,48
    8000361c:	892a                	mv	s2,a0
    8000361e:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003620:	00236517          	auipc	a0,0x236
    80003624:	04850513          	addi	a0,a0,72 # 80239668 <bcache>
    80003628:	ffffe097          	auipc	ra,0xffffe
    8000362c:	870080e7          	jalr	-1936(ra) # 80000e98 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003630:	0023e497          	auipc	s1,0x23e
    80003634:	2f04b483          	ld	s1,752(s1) # 80241920 <bcache+0x82b8>
    80003638:	0023e797          	auipc	a5,0x23e
    8000363c:	29878793          	addi	a5,a5,664 # 802418d0 <bcache+0x8268>
    80003640:	02f48f63          	beq	s1,a5,8000367e <bread+0x70>
    80003644:	873e                	mv	a4,a5
    80003646:	a021                	j	8000364e <bread+0x40>
    80003648:	68a4                	ld	s1,80(s1)
    8000364a:	02e48a63          	beq	s1,a4,8000367e <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000364e:	449c                	lw	a5,8(s1)
    80003650:	ff279ce3          	bne	a5,s2,80003648 <bread+0x3a>
    80003654:	44dc                	lw	a5,12(s1)
    80003656:	ff3799e3          	bne	a5,s3,80003648 <bread+0x3a>
      b->refcnt++;
    8000365a:	40bc                	lw	a5,64(s1)
    8000365c:	2785                	addiw	a5,a5,1
    8000365e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003660:	00236517          	auipc	a0,0x236
    80003664:	00850513          	addi	a0,a0,8 # 80239668 <bcache>
    80003668:	ffffe097          	auipc	ra,0xffffe
    8000366c:	8e4080e7          	jalr	-1820(ra) # 80000f4c <release>
      acquiresleep(&b->lock);
    80003670:	01048513          	addi	a0,s1,16
    80003674:	00001097          	auipc	ra,0x1
    80003678:	492080e7          	jalr	1170(ra) # 80004b06 <acquiresleep>
      return b;
    8000367c:	a8b9                	j	800036da <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000367e:	0023e497          	auipc	s1,0x23e
    80003682:	29a4b483          	ld	s1,666(s1) # 80241918 <bcache+0x82b0>
    80003686:	0023e797          	auipc	a5,0x23e
    8000368a:	24a78793          	addi	a5,a5,586 # 802418d0 <bcache+0x8268>
    8000368e:	00f48863          	beq	s1,a5,8000369e <bread+0x90>
    80003692:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003694:	40bc                	lw	a5,64(s1)
    80003696:	cf81                	beqz	a5,800036ae <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003698:	64a4                	ld	s1,72(s1)
    8000369a:	fee49de3          	bne	s1,a4,80003694 <bread+0x86>
  panic("bget: no buffers");
    8000369e:	00005517          	auipc	a0,0x5
    800036a2:	e9a50513          	addi	a0,a0,-358 # 80008538 <__func__.1+0x530>
    800036a6:	ffffd097          	auipc	ra,0xffffd
    800036aa:	eba080e7          	jalr	-326(ra) # 80000560 <panic>
      b->dev = dev;
    800036ae:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800036b2:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800036b6:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800036ba:	4785                	li	a5,1
    800036bc:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800036be:	00236517          	auipc	a0,0x236
    800036c2:	faa50513          	addi	a0,a0,-86 # 80239668 <bcache>
    800036c6:	ffffe097          	auipc	ra,0xffffe
    800036ca:	886080e7          	jalr	-1914(ra) # 80000f4c <release>
      acquiresleep(&b->lock);
    800036ce:	01048513          	addi	a0,s1,16
    800036d2:	00001097          	auipc	ra,0x1
    800036d6:	434080e7          	jalr	1076(ra) # 80004b06 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800036da:	409c                	lw	a5,0(s1)
    800036dc:	cb89                	beqz	a5,800036ee <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800036de:	8526                	mv	a0,s1
    800036e0:	70a2                	ld	ra,40(sp)
    800036e2:	7402                	ld	s0,32(sp)
    800036e4:	64e2                	ld	s1,24(sp)
    800036e6:	6942                	ld	s2,16(sp)
    800036e8:	69a2                	ld	s3,8(sp)
    800036ea:	6145                	addi	sp,sp,48
    800036ec:	8082                	ret
    virtio_disk_rw(b, 0);
    800036ee:	4581                	li	a1,0
    800036f0:	8526                	mv	a0,s1
    800036f2:	00003097          	auipc	ra,0x3
    800036f6:	0f6080e7          	jalr	246(ra) # 800067e8 <virtio_disk_rw>
    b->valid = 1;
    800036fa:	4785                	li	a5,1
    800036fc:	c09c                	sw	a5,0(s1)
  return b;
    800036fe:	b7c5                	j	800036de <bread+0xd0>

0000000080003700 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003700:	1101                	addi	sp,sp,-32
    80003702:	ec06                	sd	ra,24(sp)
    80003704:	e822                	sd	s0,16(sp)
    80003706:	e426                	sd	s1,8(sp)
    80003708:	1000                	addi	s0,sp,32
    8000370a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000370c:	0541                	addi	a0,a0,16
    8000370e:	00001097          	auipc	ra,0x1
    80003712:	492080e7          	jalr	1170(ra) # 80004ba0 <holdingsleep>
    80003716:	cd01                	beqz	a0,8000372e <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003718:	4585                	li	a1,1
    8000371a:	8526                	mv	a0,s1
    8000371c:	00003097          	auipc	ra,0x3
    80003720:	0cc080e7          	jalr	204(ra) # 800067e8 <virtio_disk_rw>
}
    80003724:	60e2                	ld	ra,24(sp)
    80003726:	6442                	ld	s0,16(sp)
    80003728:	64a2                	ld	s1,8(sp)
    8000372a:	6105                	addi	sp,sp,32
    8000372c:	8082                	ret
    panic("bwrite");
    8000372e:	00005517          	auipc	a0,0x5
    80003732:	e2250513          	addi	a0,a0,-478 # 80008550 <__func__.1+0x548>
    80003736:	ffffd097          	auipc	ra,0xffffd
    8000373a:	e2a080e7          	jalr	-470(ra) # 80000560 <panic>

000000008000373e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000373e:	1101                	addi	sp,sp,-32
    80003740:	ec06                	sd	ra,24(sp)
    80003742:	e822                	sd	s0,16(sp)
    80003744:	e426                	sd	s1,8(sp)
    80003746:	e04a                	sd	s2,0(sp)
    80003748:	1000                	addi	s0,sp,32
    8000374a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000374c:	01050913          	addi	s2,a0,16
    80003750:	854a                	mv	a0,s2
    80003752:	00001097          	auipc	ra,0x1
    80003756:	44e080e7          	jalr	1102(ra) # 80004ba0 <holdingsleep>
    8000375a:	c925                	beqz	a0,800037ca <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    8000375c:	854a                	mv	a0,s2
    8000375e:	00001097          	auipc	ra,0x1
    80003762:	3fe080e7          	jalr	1022(ra) # 80004b5c <releasesleep>

  acquire(&bcache.lock);
    80003766:	00236517          	auipc	a0,0x236
    8000376a:	f0250513          	addi	a0,a0,-254 # 80239668 <bcache>
    8000376e:	ffffd097          	auipc	ra,0xffffd
    80003772:	72a080e7          	jalr	1834(ra) # 80000e98 <acquire>
  b->refcnt--;
    80003776:	40bc                	lw	a5,64(s1)
    80003778:	37fd                	addiw	a5,a5,-1
    8000377a:	0007871b          	sext.w	a4,a5
    8000377e:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003780:	e71d                	bnez	a4,800037ae <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003782:	68b8                	ld	a4,80(s1)
    80003784:	64bc                	ld	a5,72(s1)
    80003786:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003788:	68b8                	ld	a4,80(s1)
    8000378a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000378c:	0023e797          	auipc	a5,0x23e
    80003790:	edc78793          	addi	a5,a5,-292 # 80241668 <bcache+0x8000>
    80003794:	2b87b703          	ld	a4,696(a5)
    80003798:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000379a:	0023e717          	auipc	a4,0x23e
    8000379e:	13670713          	addi	a4,a4,310 # 802418d0 <bcache+0x8268>
    800037a2:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800037a4:	2b87b703          	ld	a4,696(a5)
    800037a8:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800037aa:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800037ae:	00236517          	auipc	a0,0x236
    800037b2:	eba50513          	addi	a0,a0,-326 # 80239668 <bcache>
    800037b6:	ffffd097          	auipc	ra,0xffffd
    800037ba:	796080e7          	jalr	1942(ra) # 80000f4c <release>
}
    800037be:	60e2                	ld	ra,24(sp)
    800037c0:	6442                	ld	s0,16(sp)
    800037c2:	64a2                	ld	s1,8(sp)
    800037c4:	6902                	ld	s2,0(sp)
    800037c6:	6105                	addi	sp,sp,32
    800037c8:	8082                	ret
    panic("brelse");
    800037ca:	00005517          	auipc	a0,0x5
    800037ce:	d8e50513          	addi	a0,a0,-626 # 80008558 <__func__.1+0x550>
    800037d2:	ffffd097          	auipc	ra,0xffffd
    800037d6:	d8e080e7          	jalr	-626(ra) # 80000560 <panic>

00000000800037da <bpin>:

void
bpin(struct buf *b) {
    800037da:	1101                	addi	sp,sp,-32
    800037dc:	ec06                	sd	ra,24(sp)
    800037de:	e822                	sd	s0,16(sp)
    800037e0:	e426                	sd	s1,8(sp)
    800037e2:	1000                	addi	s0,sp,32
    800037e4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800037e6:	00236517          	auipc	a0,0x236
    800037ea:	e8250513          	addi	a0,a0,-382 # 80239668 <bcache>
    800037ee:	ffffd097          	auipc	ra,0xffffd
    800037f2:	6aa080e7          	jalr	1706(ra) # 80000e98 <acquire>
  b->refcnt++;
    800037f6:	40bc                	lw	a5,64(s1)
    800037f8:	2785                	addiw	a5,a5,1
    800037fa:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800037fc:	00236517          	auipc	a0,0x236
    80003800:	e6c50513          	addi	a0,a0,-404 # 80239668 <bcache>
    80003804:	ffffd097          	auipc	ra,0xffffd
    80003808:	748080e7          	jalr	1864(ra) # 80000f4c <release>
}
    8000380c:	60e2                	ld	ra,24(sp)
    8000380e:	6442                	ld	s0,16(sp)
    80003810:	64a2                	ld	s1,8(sp)
    80003812:	6105                	addi	sp,sp,32
    80003814:	8082                	ret

0000000080003816 <bunpin>:

void
bunpin(struct buf *b) {
    80003816:	1101                	addi	sp,sp,-32
    80003818:	ec06                	sd	ra,24(sp)
    8000381a:	e822                	sd	s0,16(sp)
    8000381c:	e426                	sd	s1,8(sp)
    8000381e:	1000                	addi	s0,sp,32
    80003820:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003822:	00236517          	auipc	a0,0x236
    80003826:	e4650513          	addi	a0,a0,-442 # 80239668 <bcache>
    8000382a:	ffffd097          	auipc	ra,0xffffd
    8000382e:	66e080e7          	jalr	1646(ra) # 80000e98 <acquire>
  b->refcnt--;
    80003832:	40bc                	lw	a5,64(s1)
    80003834:	37fd                	addiw	a5,a5,-1
    80003836:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003838:	00236517          	auipc	a0,0x236
    8000383c:	e3050513          	addi	a0,a0,-464 # 80239668 <bcache>
    80003840:	ffffd097          	auipc	ra,0xffffd
    80003844:	70c080e7          	jalr	1804(ra) # 80000f4c <release>
}
    80003848:	60e2                	ld	ra,24(sp)
    8000384a:	6442                	ld	s0,16(sp)
    8000384c:	64a2                	ld	s1,8(sp)
    8000384e:	6105                	addi	sp,sp,32
    80003850:	8082                	ret

0000000080003852 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003852:	1101                	addi	sp,sp,-32
    80003854:	ec06                	sd	ra,24(sp)
    80003856:	e822                	sd	s0,16(sp)
    80003858:	e426                	sd	s1,8(sp)
    8000385a:	e04a                	sd	s2,0(sp)
    8000385c:	1000                	addi	s0,sp,32
    8000385e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003860:	00d5d59b          	srliw	a1,a1,0xd
    80003864:	0023e797          	auipc	a5,0x23e
    80003868:	4e07a783          	lw	a5,1248(a5) # 80241d44 <sb+0x1c>
    8000386c:	9dbd                	addw	a1,a1,a5
    8000386e:	00000097          	auipc	ra,0x0
    80003872:	da0080e7          	jalr	-608(ra) # 8000360e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003876:	0074f713          	andi	a4,s1,7
    8000387a:	4785                	li	a5,1
    8000387c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003880:	14ce                	slli	s1,s1,0x33
    80003882:	90d9                	srli	s1,s1,0x36
    80003884:	00950733          	add	a4,a0,s1
    80003888:	05874703          	lbu	a4,88(a4)
    8000388c:	00e7f6b3          	and	a3,a5,a4
    80003890:	c69d                	beqz	a3,800038be <bfree+0x6c>
    80003892:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003894:	94aa                	add	s1,s1,a0
    80003896:	fff7c793          	not	a5,a5
    8000389a:	8f7d                	and	a4,a4,a5
    8000389c:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800038a0:	00001097          	auipc	ra,0x1
    800038a4:	148080e7          	jalr	328(ra) # 800049e8 <log_write>
  brelse(bp);
    800038a8:	854a                	mv	a0,s2
    800038aa:	00000097          	auipc	ra,0x0
    800038ae:	e94080e7          	jalr	-364(ra) # 8000373e <brelse>
}
    800038b2:	60e2                	ld	ra,24(sp)
    800038b4:	6442                	ld	s0,16(sp)
    800038b6:	64a2                	ld	s1,8(sp)
    800038b8:	6902                	ld	s2,0(sp)
    800038ba:	6105                	addi	sp,sp,32
    800038bc:	8082                	ret
    panic("freeing free block");
    800038be:	00005517          	auipc	a0,0x5
    800038c2:	ca250513          	addi	a0,a0,-862 # 80008560 <__func__.1+0x558>
    800038c6:	ffffd097          	auipc	ra,0xffffd
    800038ca:	c9a080e7          	jalr	-870(ra) # 80000560 <panic>

00000000800038ce <balloc>:
{
    800038ce:	711d                	addi	sp,sp,-96
    800038d0:	ec86                	sd	ra,88(sp)
    800038d2:	e8a2                	sd	s0,80(sp)
    800038d4:	e4a6                	sd	s1,72(sp)
    800038d6:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800038d8:	0023e797          	auipc	a5,0x23e
    800038dc:	4547a783          	lw	a5,1108(a5) # 80241d2c <sb+0x4>
    800038e0:	10078f63          	beqz	a5,800039fe <balloc+0x130>
    800038e4:	e0ca                	sd	s2,64(sp)
    800038e6:	fc4e                	sd	s3,56(sp)
    800038e8:	f852                	sd	s4,48(sp)
    800038ea:	f456                	sd	s5,40(sp)
    800038ec:	f05a                	sd	s6,32(sp)
    800038ee:	ec5e                	sd	s7,24(sp)
    800038f0:	e862                	sd	s8,16(sp)
    800038f2:	e466                	sd	s9,8(sp)
    800038f4:	8baa                	mv	s7,a0
    800038f6:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800038f8:	0023eb17          	auipc	s6,0x23e
    800038fc:	430b0b13          	addi	s6,s6,1072 # 80241d28 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003900:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003902:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003904:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003906:	6c89                	lui	s9,0x2
    80003908:	a061                	j	80003990 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000390a:	97ca                	add	a5,a5,s2
    8000390c:	8e55                	or	a2,a2,a3
    8000390e:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003912:	854a                	mv	a0,s2
    80003914:	00001097          	auipc	ra,0x1
    80003918:	0d4080e7          	jalr	212(ra) # 800049e8 <log_write>
        brelse(bp);
    8000391c:	854a                	mv	a0,s2
    8000391e:	00000097          	auipc	ra,0x0
    80003922:	e20080e7          	jalr	-480(ra) # 8000373e <brelse>
  bp = bread(dev, bno);
    80003926:	85a6                	mv	a1,s1
    80003928:	855e                	mv	a0,s7
    8000392a:	00000097          	auipc	ra,0x0
    8000392e:	ce4080e7          	jalr	-796(ra) # 8000360e <bread>
    80003932:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003934:	40000613          	li	a2,1024
    80003938:	4581                	li	a1,0
    8000393a:	05850513          	addi	a0,a0,88
    8000393e:	ffffd097          	auipc	ra,0xffffd
    80003942:	656080e7          	jalr	1622(ra) # 80000f94 <memset>
  log_write(bp);
    80003946:	854a                	mv	a0,s2
    80003948:	00001097          	auipc	ra,0x1
    8000394c:	0a0080e7          	jalr	160(ra) # 800049e8 <log_write>
  brelse(bp);
    80003950:	854a                	mv	a0,s2
    80003952:	00000097          	auipc	ra,0x0
    80003956:	dec080e7          	jalr	-532(ra) # 8000373e <brelse>
}
    8000395a:	6906                	ld	s2,64(sp)
    8000395c:	79e2                	ld	s3,56(sp)
    8000395e:	7a42                	ld	s4,48(sp)
    80003960:	7aa2                	ld	s5,40(sp)
    80003962:	7b02                	ld	s6,32(sp)
    80003964:	6be2                	ld	s7,24(sp)
    80003966:	6c42                	ld	s8,16(sp)
    80003968:	6ca2                	ld	s9,8(sp)
}
    8000396a:	8526                	mv	a0,s1
    8000396c:	60e6                	ld	ra,88(sp)
    8000396e:	6446                	ld	s0,80(sp)
    80003970:	64a6                	ld	s1,72(sp)
    80003972:	6125                	addi	sp,sp,96
    80003974:	8082                	ret
    brelse(bp);
    80003976:	854a                	mv	a0,s2
    80003978:	00000097          	auipc	ra,0x0
    8000397c:	dc6080e7          	jalr	-570(ra) # 8000373e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003980:	015c87bb          	addw	a5,s9,s5
    80003984:	00078a9b          	sext.w	s5,a5
    80003988:	004b2703          	lw	a4,4(s6)
    8000398c:	06eaf163          	bgeu	s5,a4,800039ee <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
    80003990:	41fad79b          	sraiw	a5,s5,0x1f
    80003994:	0137d79b          	srliw	a5,a5,0x13
    80003998:	015787bb          	addw	a5,a5,s5
    8000399c:	40d7d79b          	sraiw	a5,a5,0xd
    800039a0:	01cb2583          	lw	a1,28(s6)
    800039a4:	9dbd                	addw	a1,a1,a5
    800039a6:	855e                	mv	a0,s7
    800039a8:	00000097          	auipc	ra,0x0
    800039ac:	c66080e7          	jalr	-922(ra) # 8000360e <bread>
    800039b0:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800039b2:	004b2503          	lw	a0,4(s6)
    800039b6:	000a849b          	sext.w	s1,s5
    800039ba:	8762                	mv	a4,s8
    800039bc:	faa4fde3          	bgeu	s1,a0,80003976 <balloc+0xa8>
      m = 1 << (bi % 8);
    800039c0:	00777693          	andi	a3,a4,7
    800039c4:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800039c8:	41f7579b          	sraiw	a5,a4,0x1f
    800039cc:	01d7d79b          	srliw	a5,a5,0x1d
    800039d0:	9fb9                	addw	a5,a5,a4
    800039d2:	4037d79b          	sraiw	a5,a5,0x3
    800039d6:	00f90633          	add	a2,s2,a5
    800039da:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    800039de:	00c6f5b3          	and	a1,a3,a2
    800039e2:	d585                	beqz	a1,8000390a <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800039e4:	2705                	addiw	a4,a4,1
    800039e6:	2485                	addiw	s1,s1,1
    800039e8:	fd471ae3          	bne	a4,s4,800039bc <balloc+0xee>
    800039ec:	b769                	j	80003976 <balloc+0xa8>
    800039ee:	6906                	ld	s2,64(sp)
    800039f0:	79e2                	ld	s3,56(sp)
    800039f2:	7a42                	ld	s4,48(sp)
    800039f4:	7aa2                	ld	s5,40(sp)
    800039f6:	7b02                	ld	s6,32(sp)
    800039f8:	6be2                	ld	s7,24(sp)
    800039fa:	6c42                	ld	s8,16(sp)
    800039fc:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    800039fe:	00005517          	auipc	a0,0x5
    80003a02:	b7a50513          	addi	a0,a0,-1158 # 80008578 <__func__.1+0x570>
    80003a06:	ffffd097          	auipc	ra,0xffffd
    80003a0a:	bb6080e7          	jalr	-1098(ra) # 800005bc <printf>
  return 0;
    80003a0e:	4481                	li	s1,0
    80003a10:	bfa9                	j	8000396a <balloc+0x9c>

0000000080003a12 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003a12:	7179                	addi	sp,sp,-48
    80003a14:	f406                	sd	ra,40(sp)
    80003a16:	f022                	sd	s0,32(sp)
    80003a18:	ec26                	sd	s1,24(sp)
    80003a1a:	e84a                	sd	s2,16(sp)
    80003a1c:	e44e                	sd	s3,8(sp)
    80003a1e:	1800                	addi	s0,sp,48
    80003a20:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003a22:	47ad                	li	a5,11
    80003a24:	02b7e863          	bltu	a5,a1,80003a54 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80003a28:	02059793          	slli	a5,a1,0x20
    80003a2c:	01e7d593          	srli	a1,a5,0x1e
    80003a30:	00b504b3          	add	s1,a0,a1
    80003a34:	0504a903          	lw	s2,80(s1)
    80003a38:	08091263          	bnez	s2,80003abc <bmap+0xaa>
      addr = balloc(ip->dev);
    80003a3c:	4108                	lw	a0,0(a0)
    80003a3e:	00000097          	auipc	ra,0x0
    80003a42:	e90080e7          	jalr	-368(ra) # 800038ce <balloc>
    80003a46:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003a4a:	06090963          	beqz	s2,80003abc <bmap+0xaa>
        return 0;
      ip->addrs[bn] = addr;
    80003a4e:	0524a823          	sw	s2,80(s1)
    80003a52:	a0ad                	j	80003abc <bmap+0xaa>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003a54:	ff45849b          	addiw	s1,a1,-12
    80003a58:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003a5c:	0ff00793          	li	a5,255
    80003a60:	08e7e863          	bltu	a5,a4,80003af0 <bmap+0xde>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003a64:	08052903          	lw	s2,128(a0)
    80003a68:	00091f63          	bnez	s2,80003a86 <bmap+0x74>
      addr = balloc(ip->dev);
    80003a6c:	4108                	lw	a0,0(a0)
    80003a6e:	00000097          	auipc	ra,0x0
    80003a72:	e60080e7          	jalr	-416(ra) # 800038ce <balloc>
    80003a76:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003a7a:	04090163          	beqz	s2,80003abc <bmap+0xaa>
    80003a7e:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003a80:	0929a023          	sw	s2,128(s3)
    80003a84:	a011                	j	80003a88 <bmap+0x76>
    80003a86:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003a88:	85ca                	mv	a1,s2
    80003a8a:	0009a503          	lw	a0,0(s3)
    80003a8e:	00000097          	auipc	ra,0x0
    80003a92:	b80080e7          	jalr	-1152(ra) # 8000360e <bread>
    80003a96:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003a98:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003a9c:	02049713          	slli	a4,s1,0x20
    80003aa0:	01e75593          	srli	a1,a4,0x1e
    80003aa4:	00b784b3          	add	s1,a5,a1
    80003aa8:	0004a903          	lw	s2,0(s1)
    80003aac:	02090063          	beqz	s2,80003acc <bmap+0xba>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003ab0:	8552                	mv	a0,s4
    80003ab2:	00000097          	auipc	ra,0x0
    80003ab6:	c8c080e7          	jalr	-884(ra) # 8000373e <brelse>
    return addr;
    80003aba:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003abc:	854a                	mv	a0,s2
    80003abe:	70a2                	ld	ra,40(sp)
    80003ac0:	7402                	ld	s0,32(sp)
    80003ac2:	64e2                	ld	s1,24(sp)
    80003ac4:	6942                	ld	s2,16(sp)
    80003ac6:	69a2                	ld	s3,8(sp)
    80003ac8:	6145                	addi	sp,sp,48
    80003aca:	8082                	ret
      addr = balloc(ip->dev);
    80003acc:	0009a503          	lw	a0,0(s3)
    80003ad0:	00000097          	auipc	ra,0x0
    80003ad4:	dfe080e7          	jalr	-514(ra) # 800038ce <balloc>
    80003ad8:	0005091b          	sext.w	s2,a0
      if(addr){
    80003adc:	fc090ae3          	beqz	s2,80003ab0 <bmap+0x9e>
        a[bn] = addr;
    80003ae0:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003ae4:	8552                	mv	a0,s4
    80003ae6:	00001097          	auipc	ra,0x1
    80003aea:	f02080e7          	jalr	-254(ra) # 800049e8 <log_write>
    80003aee:	b7c9                	j	80003ab0 <bmap+0x9e>
    80003af0:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003af2:	00005517          	auipc	a0,0x5
    80003af6:	a9e50513          	addi	a0,a0,-1378 # 80008590 <__func__.1+0x588>
    80003afa:	ffffd097          	auipc	ra,0xffffd
    80003afe:	a66080e7          	jalr	-1434(ra) # 80000560 <panic>

0000000080003b02 <iget>:
{
    80003b02:	7179                	addi	sp,sp,-48
    80003b04:	f406                	sd	ra,40(sp)
    80003b06:	f022                	sd	s0,32(sp)
    80003b08:	ec26                	sd	s1,24(sp)
    80003b0a:	e84a                	sd	s2,16(sp)
    80003b0c:	e44e                	sd	s3,8(sp)
    80003b0e:	e052                	sd	s4,0(sp)
    80003b10:	1800                	addi	s0,sp,48
    80003b12:	89aa                	mv	s3,a0
    80003b14:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003b16:	0023e517          	auipc	a0,0x23e
    80003b1a:	23250513          	addi	a0,a0,562 # 80241d48 <itable>
    80003b1e:	ffffd097          	auipc	ra,0xffffd
    80003b22:	37a080e7          	jalr	890(ra) # 80000e98 <acquire>
  empty = 0;
    80003b26:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003b28:	0023e497          	auipc	s1,0x23e
    80003b2c:	23848493          	addi	s1,s1,568 # 80241d60 <itable+0x18>
    80003b30:	00240697          	auipc	a3,0x240
    80003b34:	cc068693          	addi	a3,a3,-832 # 802437f0 <log>
    80003b38:	a039                	j	80003b46 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003b3a:	02090b63          	beqz	s2,80003b70 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003b3e:	08848493          	addi	s1,s1,136
    80003b42:	02d48a63          	beq	s1,a3,80003b76 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003b46:	449c                	lw	a5,8(s1)
    80003b48:	fef059e3          	blez	a5,80003b3a <iget+0x38>
    80003b4c:	4098                	lw	a4,0(s1)
    80003b4e:	ff3716e3          	bne	a4,s3,80003b3a <iget+0x38>
    80003b52:	40d8                	lw	a4,4(s1)
    80003b54:	ff4713e3          	bne	a4,s4,80003b3a <iget+0x38>
      ip->ref++;
    80003b58:	2785                	addiw	a5,a5,1
    80003b5a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003b5c:	0023e517          	auipc	a0,0x23e
    80003b60:	1ec50513          	addi	a0,a0,492 # 80241d48 <itable>
    80003b64:	ffffd097          	auipc	ra,0xffffd
    80003b68:	3e8080e7          	jalr	1000(ra) # 80000f4c <release>
      return ip;
    80003b6c:	8926                	mv	s2,s1
    80003b6e:	a03d                	j	80003b9c <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003b70:	f7f9                	bnez	a5,80003b3e <iget+0x3c>
      empty = ip;
    80003b72:	8926                	mv	s2,s1
    80003b74:	b7e9                	j	80003b3e <iget+0x3c>
  if(empty == 0)
    80003b76:	02090c63          	beqz	s2,80003bae <iget+0xac>
  ip->dev = dev;
    80003b7a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003b7e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003b82:	4785                	li	a5,1
    80003b84:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003b88:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003b8c:	0023e517          	auipc	a0,0x23e
    80003b90:	1bc50513          	addi	a0,a0,444 # 80241d48 <itable>
    80003b94:	ffffd097          	auipc	ra,0xffffd
    80003b98:	3b8080e7          	jalr	952(ra) # 80000f4c <release>
}
    80003b9c:	854a                	mv	a0,s2
    80003b9e:	70a2                	ld	ra,40(sp)
    80003ba0:	7402                	ld	s0,32(sp)
    80003ba2:	64e2                	ld	s1,24(sp)
    80003ba4:	6942                	ld	s2,16(sp)
    80003ba6:	69a2                	ld	s3,8(sp)
    80003ba8:	6a02                	ld	s4,0(sp)
    80003baa:	6145                	addi	sp,sp,48
    80003bac:	8082                	ret
    panic("iget: no inodes");
    80003bae:	00005517          	auipc	a0,0x5
    80003bb2:	9fa50513          	addi	a0,a0,-1542 # 800085a8 <__func__.1+0x5a0>
    80003bb6:	ffffd097          	auipc	ra,0xffffd
    80003bba:	9aa080e7          	jalr	-1622(ra) # 80000560 <panic>

0000000080003bbe <fsinit>:
fsinit(int dev) {
    80003bbe:	7179                	addi	sp,sp,-48
    80003bc0:	f406                	sd	ra,40(sp)
    80003bc2:	f022                	sd	s0,32(sp)
    80003bc4:	ec26                	sd	s1,24(sp)
    80003bc6:	e84a                	sd	s2,16(sp)
    80003bc8:	e44e                	sd	s3,8(sp)
    80003bca:	1800                	addi	s0,sp,48
    80003bcc:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003bce:	4585                	li	a1,1
    80003bd0:	00000097          	auipc	ra,0x0
    80003bd4:	a3e080e7          	jalr	-1474(ra) # 8000360e <bread>
    80003bd8:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003bda:	0023e997          	auipc	s3,0x23e
    80003bde:	14e98993          	addi	s3,s3,334 # 80241d28 <sb>
    80003be2:	02000613          	li	a2,32
    80003be6:	05850593          	addi	a1,a0,88
    80003bea:	854e                	mv	a0,s3
    80003bec:	ffffd097          	auipc	ra,0xffffd
    80003bf0:	404080e7          	jalr	1028(ra) # 80000ff0 <memmove>
  brelse(bp);
    80003bf4:	8526                	mv	a0,s1
    80003bf6:	00000097          	auipc	ra,0x0
    80003bfa:	b48080e7          	jalr	-1208(ra) # 8000373e <brelse>
  if(sb.magic != FSMAGIC)
    80003bfe:	0009a703          	lw	a4,0(s3)
    80003c02:	102037b7          	lui	a5,0x10203
    80003c06:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003c0a:	02f71263          	bne	a4,a5,80003c2e <fsinit+0x70>
  initlog(dev, &sb);
    80003c0e:	0023e597          	auipc	a1,0x23e
    80003c12:	11a58593          	addi	a1,a1,282 # 80241d28 <sb>
    80003c16:	854a                	mv	a0,s2
    80003c18:	00001097          	auipc	ra,0x1
    80003c1c:	b60080e7          	jalr	-1184(ra) # 80004778 <initlog>
}
    80003c20:	70a2                	ld	ra,40(sp)
    80003c22:	7402                	ld	s0,32(sp)
    80003c24:	64e2                	ld	s1,24(sp)
    80003c26:	6942                	ld	s2,16(sp)
    80003c28:	69a2                	ld	s3,8(sp)
    80003c2a:	6145                	addi	sp,sp,48
    80003c2c:	8082                	ret
    panic("invalid file system");
    80003c2e:	00005517          	auipc	a0,0x5
    80003c32:	98a50513          	addi	a0,a0,-1654 # 800085b8 <__func__.1+0x5b0>
    80003c36:	ffffd097          	auipc	ra,0xffffd
    80003c3a:	92a080e7          	jalr	-1750(ra) # 80000560 <panic>

0000000080003c3e <iinit>:
{
    80003c3e:	7179                	addi	sp,sp,-48
    80003c40:	f406                	sd	ra,40(sp)
    80003c42:	f022                	sd	s0,32(sp)
    80003c44:	ec26                	sd	s1,24(sp)
    80003c46:	e84a                	sd	s2,16(sp)
    80003c48:	e44e                	sd	s3,8(sp)
    80003c4a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003c4c:	00005597          	auipc	a1,0x5
    80003c50:	98458593          	addi	a1,a1,-1660 # 800085d0 <__func__.1+0x5c8>
    80003c54:	0023e517          	auipc	a0,0x23e
    80003c58:	0f450513          	addi	a0,a0,244 # 80241d48 <itable>
    80003c5c:	ffffd097          	auipc	ra,0xffffd
    80003c60:	1ac080e7          	jalr	428(ra) # 80000e08 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003c64:	0023e497          	auipc	s1,0x23e
    80003c68:	10c48493          	addi	s1,s1,268 # 80241d70 <itable+0x28>
    80003c6c:	00240997          	auipc	s3,0x240
    80003c70:	b9498993          	addi	s3,s3,-1132 # 80243800 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003c74:	00005917          	auipc	s2,0x5
    80003c78:	96490913          	addi	s2,s2,-1692 # 800085d8 <__func__.1+0x5d0>
    80003c7c:	85ca                	mv	a1,s2
    80003c7e:	8526                	mv	a0,s1
    80003c80:	00001097          	auipc	ra,0x1
    80003c84:	e4c080e7          	jalr	-436(ra) # 80004acc <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003c88:	08848493          	addi	s1,s1,136
    80003c8c:	ff3498e3          	bne	s1,s3,80003c7c <iinit+0x3e>
}
    80003c90:	70a2                	ld	ra,40(sp)
    80003c92:	7402                	ld	s0,32(sp)
    80003c94:	64e2                	ld	s1,24(sp)
    80003c96:	6942                	ld	s2,16(sp)
    80003c98:	69a2                	ld	s3,8(sp)
    80003c9a:	6145                	addi	sp,sp,48
    80003c9c:	8082                	ret

0000000080003c9e <ialloc>:
{
    80003c9e:	7139                	addi	sp,sp,-64
    80003ca0:	fc06                	sd	ra,56(sp)
    80003ca2:	f822                	sd	s0,48(sp)
    80003ca4:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003ca6:	0023e717          	auipc	a4,0x23e
    80003caa:	08e72703          	lw	a4,142(a4) # 80241d34 <sb+0xc>
    80003cae:	4785                	li	a5,1
    80003cb0:	06e7f463          	bgeu	a5,a4,80003d18 <ialloc+0x7a>
    80003cb4:	f426                	sd	s1,40(sp)
    80003cb6:	f04a                	sd	s2,32(sp)
    80003cb8:	ec4e                	sd	s3,24(sp)
    80003cba:	e852                	sd	s4,16(sp)
    80003cbc:	e456                	sd	s5,8(sp)
    80003cbe:	e05a                	sd	s6,0(sp)
    80003cc0:	8aaa                	mv	s5,a0
    80003cc2:	8b2e                	mv	s6,a1
    80003cc4:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003cc6:	0023ea17          	auipc	s4,0x23e
    80003cca:	062a0a13          	addi	s4,s4,98 # 80241d28 <sb>
    80003cce:	00495593          	srli	a1,s2,0x4
    80003cd2:	018a2783          	lw	a5,24(s4)
    80003cd6:	9dbd                	addw	a1,a1,a5
    80003cd8:	8556                	mv	a0,s5
    80003cda:	00000097          	auipc	ra,0x0
    80003cde:	934080e7          	jalr	-1740(ra) # 8000360e <bread>
    80003ce2:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003ce4:	05850993          	addi	s3,a0,88
    80003ce8:	00f97793          	andi	a5,s2,15
    80003cec:	079a                	slli	a5,a5,0x6
    80003cee:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003cf0:	00099783          	lh	a5,0(s3)
    80003cf4:	cf9d                	beqz	a5,80003d32 <ialloc+0x94>
    brelse(bp);
    80003cf6:	00000097          	auipc	ra,0x0
    80003cfa:	a48080e7          	jalr	-1464(ra) # 8000373e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003cfe:	0905                	addi	s2,s2,1
    80003d00:	00ca2703          	lw	a4,12(s4)
    80003d04:	0009079b          	sext.w	a5,s2
    80003d08:	fce7e3e3          	bltu	a5,a4,80003cce <ialloc+0x30>
    80003d0c:	74a2                	ld	s1,40(sp)
    80003d0e:	7902                	ld	s2,32(sp)
    80003d10:	69e2                	ld	s3,24(sp)
    80003d12:	6a42                	ld	s4,16(sp)
    80003d14:	6aa2                	ld	s5,8(sp)
    80003d16:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003d18:	00005517          	auipc	a0,0x5
    80003d1c:	8c850513          	addi	a0,a0,-1848 # 800085e0 <__func__.1+0x5d8>
    80003d20:	ffffd097          	auipc	ra,0xffffd
    80003d24:	89c080e7          	jalr	-1892(ra) # 800005bc <printf>
  return 0;
    80003d28:	4501                	li	a0,0
}
    80003d2a:	70e2                	ld	ra,56(sp)
    80003d2c:	7442                	ld	s0,48(sp)
    80003d2e:	6121                	addi	sp,sp,64
    80003d30:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003d32:	04000613          	li	a2,64
    80003d36:	4581                	li	a1,0
    80003d38:	854e                	mv	a0,s3
    80003d3a:	ffffd097          	auipc	ra,0xffffd
    80003d3e:	25a080e7          	jalr	602(ra) # 80000f94 <memset>
      dip->type = type;
    80003d42:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003d46:	8526                	mv	a0,s1
    80003d48:	00001097          	auipc	ra,0x1
    80003d4c:	ca0080e7          	jalr	-864(ra) # 800049e8 <log_write>
      brelse(bp);
    80003d50:	8526                	mv	a0,s1
    80003d52:	00000097          	auipc	ra,0x0
    80003d56:	9ec080e7          	jalr	-1556(ra) # 8000373e <brelse>
      return iget(dev, inum);
    80003d5a:	0009059b          	sext.w	a1,s2
    80003d5e:	8556                	mv	a0,s5
    80003d60:	00000097          	auipc	ra,0x0
    80003d64:	da2080e7          	jalr	-606(ra) # 80003b02 <iget>
    80003d68:	74a2                	ld	s1,40(sp)
    80003d6a:	7902                	ld	s2,32(sp)
    80003d6c:	69e2                	ld	s3,24(sp)
    80003d6e:	6a42                	ld	s4,16(sp)
    80003d70:	6aa2                	ld	s5,8(sp)
    80003d72:	6b02                	ld	s6,0(sp)
    80003d74:	bf5d                	j	80003d2a <ialloc+0x8c>

0000000080003d76 <iupdate>:
{
    80003d76:	1101                	addi	sp,sp,-32
    80003d78:	ec06                	sd	ra,24(sp)
    80003d7a:	e822                	sd	s0,16(sp)
    80003d7c:	e426                	sd	s1,8(sp)
    80003d7e:	e04a                	sd	s2,0(sp)
    80003d80:	1000                	addi	s0,sp,32
    80003d82:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003d84:	415c                	lw	a5,4(a0)
    80003d86:	0047d79b          	srliw	a5,a5,0x4
    80003d8a:	0023e597          	auipc	a1,0x23e
    80003d8e:	fb65a583          	lw	a1,-74(a1) # 80241d40 <sb+0x18>
    80003d92:	9dbd                	addw	a1,a1,a5
    80003d94:	4108                	lw	a0,0(a0)
    80003d96:	00000097          	auipc	ra,0x0
    80003d9a:	878080e7          	jalr	-1928(ra) # 8000360e <bread>
    80003d9e:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003da0:	05850793          	addi	a5,a0,88
    80003da4:	40d8                	lw	a4,4(s1)
    80003da6:	8b3d                	andi	a4,a4,15
    80003da8:	071a                	slli	a4,a4,0x6
    80003daa:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003dac:	04449703          	lh	a4,68(s1)
    80003db0:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003db4:	04649703          	lh	a4,70(s1)
    80003db8:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003dbc:	04849703          	lh	a4,72(s1)
    80003dc0:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003dc4:	04a49703          	lh	a4,74(s1)
    80003dc8:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003dcc:	44f8                	lw	a4,76(s1)
    80003dce:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003dd0:	03400613          	li	a2,52
    80003dd4:	05048593          	addi	a1,s1,80
    80003dd8:	00c78513          	addi	a0,a5,12
    80003ddc:	ffffd097          	auipc	ra,0xffffd
    80003de0:	214080e7          	jalr	532(ra) # 80000ff0 <memmove>
  log_write(bp);
    80003de4:	854a                	mv	a0,s2
    80003de6:	00001097          	auipc	ra,0x1
    80003dea:	c02080e7          	jalr	-1022(ra) # 800049e8 <log_write>
  brelse(bp);
    80003dee:	854a                	mv	a0,s2
    80003df0:	00000097          	auipc	ra,0x0
    80003df4:	94e080e7          	jalr	-1714(ra) # 8000373e <brelse>
}
    80003df8:	60e2                	ld	ra,24(sp)
    80003dfa:	6442                	ld	s0,16(sp)
    80003dfc:	64a2                	ld	s1,8(sp)
    80003dfe:	6902                	ld	s2,0(sp)
    80003e00:	6105                	addi	sp,sp,32
    80003e02:	8082                	ret

0000000080003e04 <idup>:
{
    80003e04:	1101                	addi	sp,sp,-32
    80003e06:	ec06                	sd	ra,24(sp)
    80003e08:	e822                	sd	s0,16(sp)
    80003e0a:	e426                	sd	s1,8(sp)
    80003e0c:	1000                	addi	s0,sp,32
    80003e0e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003e10:	0023e517          	auipc	a0,0x23e
    80003e14:	f3850513          	addi	a0,a0,-200 # 80241d48 <itable>
    80003e18:	ffffd097          	auipc	ra,0xffffd
    80003e1c:	080080e7          	jalr	128(ra) # 80000e98 <acquire>
  ip->ref++;
    80003e20:	449c                	lw	a5,8(s1)
    80003e22:	2785                	addiw	a5,a5,1
    80003e24:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003e26:	0023e517          	auipc	a0,0x23e
    80003e2a:	f2250513          	addi	a0,a0,-222 # 80241d48 <itable>
    80003e2e:	ffffd097          	auipc	ra,0xffffd
    80003e32:	11e080e7          	jalr	286(ra) # 80000f4c <release>
}
    80003e36:	8526                	mv	a0,s1
    80003e38:	60e2                	ld	ra,24(sp)
    80003e3a:	6442                	ld	s0,16(sp)
    80003e3c:	64a2                	ld	s1,8(sp)
    80003e3e:	6105                	addi	sp,sp,32
    80003e40:	8082                	ret

0000000080003e42 <ilock>:
{
    80003e42:	1101                	addi	sp,sp,-32
    80003e44:	ec06                	sd	ra,24(sp)
    80003e46:	e822                	sd	s0,16(sp)
    80003e48:	e426                	sd	s1,8(sp)
    80003e4a:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003e4c:	c10d                	beqz	a0,80003e6e <ilock+0x2c>
    80003e4e:	84aa                	mv	s1,a0
    80003e50:	451c                	lw	a5,8(a0)
    80003e52:	00f05e63          	blez	a5,80003e6e <ilock+0x2c>
  acquiresleep(&ip->lock);
    80003e56:	0541                	addi	a0,a0,16
    80003e58:	00001097          	auipc	ra,0x1
    80003e5c:	cae080e7          	jalr	-850(ra) # 80004b06 <acquiresleep>
  if(ip->valid == 0){
    80003e60:	40bc                	lw	a5,64(s1)
    80003e62:	cf99                	beqz	a5,80003e80 <ilock+0x3e>
}
    80003e64:	60e2                	ld	ra,24(sp)
    80003e66:	6442                	ld	s0,16(sp)
    80003e68:	64a2                	ld	s1,8(sp)
    80003e6a:	6105                	addi	sp,sp,32
    80003e6c:	8082                	ret
    80003e6e:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003e70:	00004517          	auipc	a0,0x4
    80003e74:	78850513          	addi	a0,a0,1928 # 800085f8 <__func__.1+0x5f0>
    80003e78:	ffffc097          	auipc	ra,0xffffc
    80003e7c:	6e8080e7          	jalr	1768(ra) # 80000560 <panic>
    80003e80:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003e82:	40dc                	lw	a5,4(s1)
    80003e84:	0047d79b          	srliw	a5,a5,0x4
    80003e88:	0023e597          	auipc	a1,0x23e
    80003e8c:	eb85a583          	lw	a1,-328(a1) # 80241d40 <sb+0x18>
    80003e90:	9dbd                	addw	a1,a1,a5
    80003e92:	4088                	lw	a0,0(s1)
    80003e94:	fffff097          	auipc	ra,0xfffff
    80003e98:	77a080e7          	jalr	1914(ra) # 8000360e <bread>
    80003e9c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003e9e:	05850593          	addi	a1,a0,88
    80003ea2:	40dc                	lw	a5,4(s1)
    80003ea4:	8bbd                	andi	a5,a5,15
    80003ea6:	079a                	slli	a5,a5,0x6
    80003ea8:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003eaa:	00059783          	lh	a5,0(a1)
    80003eae:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003eb2:	00259783          	lh	a5,2(a1)
    80003eb6:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003eba:	00459783          	lh	a5,4(a1)
    80003ebe:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003ec2:	00659783          	lh	a5,6(a1)
    80003ec6:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003eca:	459c                	lw	a5,8(a1)
    80003ecc:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003ece:	03400613          	li	a2,52
    80003ed2:	05b1                	addi	a1,a1,12
    80003ed4:	05048513          	addi	a0,s1,80
    80003ed8:	ffffd097          	auipc	ra,0xffffd
    80003edc:	118080e7          	jalr	280(ra) # 80000ff0 <memmove>
    brelse(bp);
    80003ee0:	854a                	mv	a0,s2
    80003ee2:	00000097          	auipc	ra,0x0
    80003ee6:	85c080e7          	jalr	-1956(ra) # 8000373e <brelse>
    ip->valid = 1;
    80003eea:	4785                	li	a5,1
    80003eec:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003eee:	04449783          	lh	a5,68(s1)
    80003ef2:	c399                	beqz	a5,80003ef8 <ilock+0xb6>
    80003ef4:	6902                	ld	s2,0(sp)
    80003ef6:	b7bd                	j	80003e64 <ilock+0x22>
      panic("ilock: no type");
    80003ef8:	00004517          	auipc	a0,0x4
    80003efc:	70850513          	addi	a0,a0,1800 # 80008600 <__func__.1+0x5f8>
    80003f00:	ffffc097          	auipc	ra,0xffffc
    80003f04:	660080e7          	jalr	1632(ra) # 80000560 <panic>

0000000080003f08 <iunlock>:
{
    80003f08:	1101                	addi	sp,sp,-32
    80003f0a:	ec06                	sd	ra,24(sp)
    80003f0c:	e822                	sd	s0,16(sp)
    80003f0e:	e426                	sd	s1,8(sp)
    80003f10:	e04a                	sd	s2,0(sp)
    80003f12:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003f14:	c905                	beqz	a0,80003f44 <iunlock+0x3c>
    80003f16:	84aa                	mv	s1,a0
    80003f18:	01050913          	addi	s2,a0,16
    80003f1c:	854a                	mv	a0,s2
    80003f1e:	00001097          	auipc	ra,0x1
    80003f22:	c82080e7          	jalr	-894(ra) # 80004ba0 <holdingsleep>
    80003f26:	cd19                	beqz	a0,80003f44 <iunlock+0x3c>
    80003f28:	449c                	lw	a5,8(s1)
    80003f2a:	00f05d63          	blez	a5,80003f44 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003f2e:	854a                	mv	a0,s2
    80003f30:	00001097          	auipc	ra,0x1
    80003f34:	c2c080e7          	jalr	-980(ra) # 80004b5c <releasesleep>
}
    80003f38:	60e2                	ld	ra,24(sp)
    80003f3a:	6442                	ld	s0,16(sp)
    80003f3c:	64a2                	ld	s1,8(sp)
    80003f3e:	6902                	ld	s2,0(sp)
    80003f40:	6105                	addi	sp,sp,32
    80003f42:	8082                	ret
    panic("iunlock");
    80003f44:	00004517          	auipc	a0,0x4
    80003f48:	6cc50513          	addi	a0,a0,1740 # 80008610 <__func__.1+0x608>
    80003f4c:	ffffc097          	auipc	ra,0xffffc
    80003f50:	614080e7          	jalr	1556(ra) # 80000560 <panic>

0000000080003f54 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003f54:	7179                	addi	sp,sp,-48
    80003f56:	f406                	sd	ra,40(sp)
    80003f58:	f022                	sd	s0,32(sp)
    80003f5a:	ec26                	sd	s1,24(sp)
    80003f5c:	e84a                	sd	s2,16(sp)
    80003f5e:	e44e                	sd	s3,8(sp)
    80003f60:	1800                	addi	s0,sp,48
    80003f62:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003f64:	05050493          	addi	s1,a0,80
    80003f68:	08050913          	addi	s2,a0,128
    80003f6c:	a021                	j	80003f74 <itrunc+0x20>
    80003f6e:	0491                	addi	s1,s1,4
    80003f70:	01248d63          	beq	s1,s2,80003f8a <itrunc+0x36>
    if(ip->addrs[i]){
    80003f74:	408c                	lw	a1,0(s1)
    80003f76:	dde5                	beqz	a1,80003f6e <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003f78:	0009a503          	lw	a0,0(s3)
    80003f7c:	00000097          	auipc	ra,0x0
    80003f80:	8d6080e7          	jalr	-1834(ra) # 80003852 <bfree>
      ip->addrs[i] = 0;
    80003f84:	0004a023          	sw	zero,0(s1)
    80003f88:	b7dd                	j	80003f6e <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003f8a:	0809a583          	lw	a1,128(s3)
    80003f8e:	ed99                	bnez	a1,80003fac <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003f90:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003f94:	854e                	mv	a0,s3
    80003f96:	00000097          	auipc	ra,0x0
    80003f9a:	de0080e7          	jalr	-544(ra) # 80003d76 <iupdate>
}
    80003f9e:	70a2                	ld	ra,40(sp)
    80003fa0:	7402                	ld	s0,32(sp)
    80003fa2:	64e2                	ld	s1,24(sp)
    80003fa4:	6942                	ld	s2,16(sp)
    80003fa6:	69a2                	ld	s3,8(sp)
    80003fa8:	6145                	addi	sp,sp,48
    80003faa:	8082                	ret
    80003fac:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003fae:	0009a503          	lw	a0,0(s3)
    80003fb2:	fffff097          	auipc	ra,0xfffff
    80003fb6:	65c080e7          	jalr	1628(ra) # 8000360e <bread>
    80003fba:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003fbc:	05850493          	addi	s1,a0,88
    80003fc0:	45850913          	addi	s2,a0,1112
    80003fc4:	a021                	j	80003fcc <itrunc+0x78>
    80003fc6:	0491                	addi	s1,s1,4
    80003fc8:	01248b63          	beq	s1,s2,80003fde <itrunc+0x8a>
      if(a[j])
    80003fcc:	408c                	lw	a1,0(s1)
    80003fce:	dde5                	beqz	a1,80003fc6 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80003fd0:	0009a503          	lw	a0,0(s3)
    80003fd4:	00000097          	auipc	ra,0x0
    80003fd8:	87e080e7          	jalr	-1922(ra) # 80003852 <bfree>
    80003fdc:	b7ed                	j	80003fc6 <itrunc+0x72>
    brelse(bp);
    80003fde:	8552                	mv	a0,s4
    80003fe0:	fffff097          	auipc	ra,0xfffff
    80003fe4:	75e080e7          	jalr	1886(ra) # 8000373e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003fe8:	0809a583          	lw	a1,128(s3)
    80003fec:	0009a503          	lw	a0,0(s3)
    80003ff0:	00000097          	auipc	ra,0x0
    80003ff4:	862080e7          	jalr	-1950(ra) # 80003852 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003ff8:	0809a023          	sw	zero,128(s3)
    80003ffc:	6a02                	ld	s4,0(sp)
    80003ffe:	bf49                	j	80003f90 <itrunc+0x3c>

0000000080004000 <iput>:
{
    80004000:	1101                	addi	sp,sp,-32
    80004002:	ec06                	sd	ra,24(sp)
    80004004:	e822                	sd	s0,16(sp)
    80004006:	e426                	sd	s1,8(sp)
    80004008:	1000                	addi	s0,sp,32
    8000400a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000400c:	0023e517          	auipc	a0,0x23e
    80004010:	d3c50513          	addi	a0,a0,-708 # 80241d48 <itable>
    80004014:	ffffd097          	auipc	ra,0xffffd
    80004018:	e84080e7          	jalr	-380(ra) # 80000e98 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000401c:	4498                	lw	a4,8(s1)
    8000401e:	4785                	li	a5,1
    80004020:	02f70263          	beq	a4,a5,80004044 <iput+0x44>
  ip->ref--;
    80004024:	449c                	lw	a5,8(s1)
    80004026:	37fd                	addiw	a5,a5,-1
    80004028:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000402a:	0023e517          	auipc	a0,0x23e
    8000402e:	d1e50513          	addi	a0,a0,-738 # 80241d48 <itable>
    80004032:	ffffd097          	auipc	ra,0xffffd
    80004036:	f1a080e7          	jalr	-230(ra) # 80000f4c <release>
}
    8000403a:	60e2                	ld	ra,24(sp)
    8000403c:	6442                	ld	s0,16(sp)
    8000403e:	64a2                	ld	s1,8(sp)
    80004040:	6105                	addi	sp,sp,32
    80004042:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80004044:	40bc                	lw	a5,64(s1)
    80004046:	dff9                	beqz	a5,80004024 <iput+0x24>
    80004048:	04a49783          	lh	a5,74(s1)
    8000404c:	ffe1                	bnez	a5,80004024 <iput+0x24>
    8000404e:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80004050:	01048913          	addi	s2,s1,16
    80004054:	854a                	mv	a0,s2
    80004056:	00001097          	auipc	ra,0x1
    8000405a:	ab0080e7          	jalr	-1360(ra) # 80004b06 <acquiresleep>
    release(&itable.lock);
    8000405e:	0023e517          	auipc	a0,0x23e
    80004062:	cea50513          	addi	a0,a0,-790 # 80241d48 <itable>
    80004066:	ffffd097          	auipc	ra,0xffffd
    8000406a:	ee6080e7          	jalr	-282(ra) # 80000f4c <release>
    itrunc(ip);
    8000406e:	8526                	mv	a0,s1
    80004070:	00000097          	auipc	ra,0x0
    80004074:	ee4080e7          	jalr	-284(ra) # 80003f54 <itrunc>
    ip->type = 0;
    80004078:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000407c:	8526                	mv	a0,s1
    8000407e:	00000097          	auipc	ra,0x0
    80004082:	cf8080e7          	jalr	-776(ra) # 80003d76 <iupdate>
    ip->valid = 0;
    80004086:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000408a:	854a                	mv	a0,s2
    8000408c:	00001097          	auipc	ra,0x1
    80004090:	ad0080e7          	jalr	-1328(ra) # 80004b5c <releasesleep>
    acquire(&itable.lock);
    80004094:	0023e517          	auipc	a0,0x23e
    80004098:	cb450513          	addi	a0,a0,-844 # 80241d48 <itable>
    8000409c:	ffffd097          	auipc	ra,0xffffd
    800040a0:	dfc080e7          	jalr	-516(ra) # 80000e98 <acquire>
    800040a4:	6902                	ld	s2,0(sp)
    800040a6:	bfbd                	j	80004024 <iput+0x24>

00000000800040a8 <iunlockput>:
{
    800040a8:	1101                	addi	sp,sp,-32
    800040aa:	ec06                	sd	ra,24(sp)
    800040ac:	e822                	sd	s0,16(sp)
    800040ae:	e426                	sd	s1,8(sp)
    800040b0:	1000                	addi	s0,sp,32
    800040b2:	84aa                	mv	s1,a0
  iunlock(ip);
    800040b4:	00000097          	auipc	ra,0x0
    800040b8:	e54080e7          	jalr	-428(ra) # 80003f08 <iunlock>
  iput(ip);
    800040bc:	8526                	mv	a0,s1
    800040be:	00000097          	auipc	ra,0x0
    800040c2:	f42080e7          	jalr	-190(ra) # 80004000 <iput>
}
    800040c6:	60e2                	ld	ra,24(sp)
    800040c8:	6442                	ld	s0,16(sp)
    800040ca:	64a2                	ld	s1,8(sp)
    800040cc:	6105                	addi	sp,sp,32
    800040ce:	8082                	ret

00000000800040d0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800040d0:	1141                	addi	sp,sp,-16
    800040d2:	e422                	sd	s0,8(sp)
    800040d4:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800040d6:	411c                	lw	a5,0(a0)
    800040d8:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800040da:	415c                	lw	a5,4(a0)
    800040dc:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800040de:	04451783          	lh	a5,68(a0)
    800040e2:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800040e6:	04a51783          	lh	a5,74(a0)
    800040ea:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800040ee:	04c56783          	lwu	a5,76(a0)
    800040f2:	e99c                	sd	a5,16(a1)
}
    800040f4:	6422                	ld	s0,8(sp)
    800040f6:	0141                	addi	sp,sp,16
    800040f8:	8082                	ret

00000000800040fa <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800040fa:	457c                	lw	a5,76(a0)
    800040fc:	10d7e563          	bltu	a5,a3,80004206 <readi+0x10c>
{
    80004100:	7159                	addi	sp,sp,-112
    80004102:	f486                	sd	ra,104(sp)
    80004104:	f0a2                	sd	s0,96(sp)
    80004106:	eca6                	sd	s1,88(sp)
    80004108:	e0d2                	sd	s4,64(sp)
    8000410a:	fc56                	sd	s5,56(sp)
    8000410c:	f85a                	sd	s6,48(sp)
    8000410e:	f45e                	sd	s7,40(sp)
    80004110:	1880                	addi	s0,sp,112
    80004112:	8b2a                	mv	s6,a0
    80004114:	8bae                	mv	s7,a1
    80004116:	8a32                	mv	s4,a2
    80004118:	84b6                	mv	s1,a3
    8000411a:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    8000411c:	9f35                	addw	a4,a4,a3
    return 0;
    8000411e:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80004120:	0cd76a63          	bltu	a4,a3,800041f4 <readi+0xfa>
    80004124:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80004126:	00e7f463          	bgeu	a5,a4,8000412e <readi+0x34>
    n = ip->size - off;
    8000412a:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000412e:	0a0a8963          	beqz	s5,800041e0 <readi+0xe6>
    80004132:	e8ca                	sd	s2,80(sp)
    80004134:	f062                	sd	s8,32(sp)
    80004136:	ec66                	sd	s9,24(sp)
    80004138:	e86a                	sd	s10,16(sp)
    8000413a:	e46e                	sd	s11,8(sp)
    8000413c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000413e:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80004142:	5c7d                	li	s8,-1
    80004144:	a82d                	j	8000417e <readi+0x84>
    80004146:	020d1d93          	slli	s11,s10,0x20
    8000414a:	020ddd93          	srli	s11,s11,0x20
    8000414e:	05890613          	addi	a2,s2,88
    80004152:	86ee                	mv	a3,s11
    80004154:	963a                	add	a2,a2,a4
    80004156:	85d2                	mv	a1,s4
    80004158:	855e                	mv	a0,s7
    8000415a:	fffff097          	auipc	ra,0xfffff
    8000415e:	81a080e7          	jalr	-2022(ra) # 80002974 <either_copyout>
    80004162:	05850d63          	beq	a0,s8,800041bc <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80004166:	854a                	mv	a0,s2
    80004168:	fffff097          	auipc	ra,0xfffff
    8000416c:	5d6080e7          	jalr	1494(ra) # 8000373e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004170:	013d09bb          	addw	s3,s10,s3
    80004174:	009d04bb          	addw	s1,s10,s1
    80004178:	9a6e                	add	s4,s4,s11
    8000417a:	0559fd63          	bgeu	s3,s5,800041d4 <readi+0xda>
    uint addr = bmap(ip, off/BSIZE);
    8000417e:	00a4d59b          	srliw	a1,s1,0xa
    80004182:	855a                	mv	a0,s6
    80004184:	00000097          	auipc	ra,0x0
    80004188:	88e080e7          	jalr	-1906(ra) # 80003a12 <bmap>
    8000418c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80004190:	c9b1                	beqz	a1,800041e4 <readi+0xea>
    bp = bread(ip->dev, addr);
    80004192:	000b2503          	lw	a0,0(s6)
    80004196:	fffff097          	auipc	ra,0xfffff
    8000419a:	478080e7          	jalr	1144(ra) # 8000360e <bread>
    8000419e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800041a0:	3ff4f713          	andi	a4,s1,1023
    800041a4:	40ec87bb          	subw	a5,s9,a4
    800041a8:	413a86bb          	subw	a3,s5,s3
    800041ac:	8d3e                	mv	s10,a5
    800041ae:	2781                	sext.w	a5,a5
    800041b0:	0006861b          	sext.w	a2,a3
    800041b4:	f8f679e3          	bgeu	a2,a5,80004146 <readi+0x4c>
    800041b8:	8d36                	mv	s10,a3
    800041ba:	b771                	j	80004146 <readi+0x4c>
      brelse(bp);
    800041bc:	854a                	mv	a0,s2
    800041be:	fffff097          	auipc	ra,0xfffff
    800041c2:	580080e7          	jalr	1408(ra) # 8000373e <brelse>
      tot = -1;
    800041c6:	59fd                	li	s3,-1
      break;
    800041c8:	6946                	ld	s2,80(sp)
    800041ca:	7c02                	ld	s8,32(sp)
    800041cc:	6ce2                	ld	s9,24(sp)
    800041ce:	6d42                	ld	s10,16(sp)
    800041d0:	6da2                	ld	s11,8(sp)
    800041d2:	a831                	j	800041ee <readi+0xf4>
    800041d4:	6946                	ld	s2,80(sp)
    800041d6:	7c02                	ld	s8,32(sp)
    800041d8:	6ce2                	ld	s9,24(sp)
    800041da:	6d42                	ld	s10,16(sp)
    800041dc:	6da2                	ld	s11,8(sp)
    800041de:	a801                	j	800041ee <readi+0xf4>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800041e0:	89d6                	mv	s3,s5
    800041e2:	a031                	j	800041ee <readi+0xf4>
    800041e4:	6946                	ld	s2,80(sp)
    800041e6:	7c02                	ld	s8,32(sp)
    800041e8:	6ce2                	ld	s9,24(sp)
    800041ea:	6d42                	ld	s10,16(sp)
    800041ec:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800041ee:	0009851b          	sext.w	a0,s3
    800041f2:	69a6                	ld	s3,72(sp)
}
    800041f4:	70a6                	ld	ra,104(sp)
    800041f6:	7406                	ld	s0,96(sp)
    800041f8:	64e6                	ld	s1,88(sp)
    800041fa:	6a06                	ld	s4,64(sp)
    800041fc:	7ae2                	ld	s5,56(sp)
    800041fe:	7b42                	ld	s6,48(sp)
    80004200:	7ba2                	ld	s7,40(sp)
    80004202:	6165                	addi	sp,sp,112
    80004204:	8082                	ret
    return 0;
    80004206:	4501                	li	a0,0
}
    80004208:	8082                	ret

000000008000420a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000420a:	457c                	lw	a5,76(a0)
    8000420c:	10d7ee63          	bltu	a5,a3,80004328 <writei+0x11e>
{
    80004210:	7159                	addi	sp,sp,-112
    80004212:	f486                	sd	ra,104(sp)
    80004214:	f0a2                	sd	s0,96(sp)
    80004216:	e8ca                	sd	s2,80(sp)
    80004218:	e0d2                	sd	s4,64(sp)
    8000421a:	fc56                	sd	s5,56(sp)
    8000421c:	f85a                	sd	s6,48(sp)
    8000421e:	f45e                	sd	s7,40(sp)
    80004220:	1880                	addi	s0,sp,112
    80004222:	8aaa                	mv	s5,a0
    80004224:	8bae                	mv	s7,a1
    80004226:	8a32                	mv	s4,a2
    80004228:	8936                	mv	s2,a3
    8000422a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000422c:	00e687bb          	addw	a5,a3,a4
    80004230:	0ed7ee63          	bltu	a5,a3,8000432c <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80004234:	00043737          	lui	a4,0x43
    80004238:	0ef76c63          	bltu	a4,a5,80004330 <writei+0x126>
    8000423c:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000423e:	0c0b0d63          	beqz	s6,80004318 <writei+0x10e>
    80004242:	eca6                	sd	s1,88(sp)
    80004244:	f062                	sd	s8,32(sp)
    80004246:	ec66                	sd	s9,24(sp)
    80004248:	e86a                	sd	s10,16(sp)
    8000424a:	e46e                	sd	s11,8(sp)
    8000424c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000424e:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80004252:	5c7d                	li	s8,-1
    80004254:	a091                	j	80004298 <writei+0x8e>
    80004256:	020d1d93          	slli	s11,s10,0x20
    8000425a:	020ddd93          	srli	s11,s11,0x20
    8000425e:	05848513          	addi	a0,s1,88
    80004262:	86ee                	mv	a3,s11
    80004264:	8652                	mv	a2,s4
    80004266:	85de                	mv	a1,s7
    80004268:	953a                	add	a0,a0,a4
    8000426a:	ffffe097          	auipc	ra,0xffffe
    8000426e:	760080e7          	jalr	1888(ra) # 800029ca <either_copyin>
    80004272:	07850263          	beq	a0,s8,800042d6 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80004276:	8526                	mv	a0,s1
    80004278:	00000097          	auipc	ra,0x0
    8000427c:	770080e7          	jalr	1904(ra) # 800049e8 <log_write>
    brelse(bp);
    80004280:	8526                	mv	a0,s1
    80004282:	fffff097          	auipc	ra,0xfffff
    80004286:	4bc080e7          	jalr	1212(ra) # 8000373e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000428a:	013d09bb          	addw	s3,s10,s3
    8000428e:	012d093b          	addw	s2,s10,s2
    80004292:	9a6e                	add	s4,s4,s11
    80004294:	0569f663          	bgeu	s3,s6,800042e0 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80004298:	00a9559b          	srliw	a1,s2,0xa
    8000429c:	8556                	mv	a0,s5
    8000429e:	fffff097          	auipc	ra,0xfffff
    800042a2:	774080e7          	jalr	1908(ra) # 80003a12 <bmap>
    800042a6:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800042aa:	c99d                	beqz	a1,800042e0 <writei+0xd6>
    bp = bread(ip->dev, addr);
    800042ac:	000aa503          	lw	a0,0(s5)
    800042b0:	fffff097          	auipc	ra,0xfffff
    800042b4:	35e080e7          	jalr	862(ra) # 8000360e <bread>
    800042b8:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800042ba:	3ff97713          	andi	a4,s2,1023
    800042be:	40ec87bb          	subw	a5,s9,a4
    800042c2:	413b06bb          	subw	a3,s6,s3
    800042c6:	8d3e                	mv	s10,a5
    800042c8:	2781                	sext.w	a5,a5
    800042ca:	0006861b          	sext.w	a2,a3
    800042ce:	f8f674e3          	bgeu	a2,a5,80004256 <writei+0x4c>
    800042d2:	8d36                	mv	s10,a3
    800042d4:	b749                	j	80004256 <writei+0x4c>
      brelse(bp);
    800042d6:	8526                	mv	a0,s1
    800042d8:	fffff097          	auipc	ra,0xfffff
    800042dc:	466080e7          	jalr	1126(ra) # 8000373e <brelse>
  }

  if(off > ip->size)
    800042e0:	04caa783          	lw	a5,76(s5)
    800042e4:	0327fc63          	bgeu	a5,s2,8000431c <writei+0x112>
    ip->size = off;
    800042e8:	052aa623          	sw	s2,76(s5)
    800042ec:	64e6                	ld	s1,88(sp)
    800042ee:	7c02                	ld	s8,32(sp)
    800042f0:	6ce2                	ld	s9,24(sp)
    800042f2:	6d42                	ld	s10,16(sp)
    800042f4:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800042f6:	8556                	mv	a0,s5
    800042f8:	00000097          	auipc	ra,0x0
    800042fc:	a7e080e7          	jalr	-1410(ra) # 80003d76 <iupdate>

  return tot;
    80004300:	0009851b          	sext.w	a0,s3
    80004304:	69a6                	ld	s3,72(sp)
}
    80004306:	70a6                	ld	ra,104(sp)
    80004308:	7406                	ld	s0,96(sp)
    8000430a:	6946                	ld	s2,80(sp)
    8000430c:	6a06                	ld	s4,64(sp)
    8000430e:	7ae2                	ld	s5,56(sp)
    80004310:	7b42                	ld	s6,48(sp)
    80004312:	7ba2                	ld	s7,40(sp)
    80004314:	6165                	addi	sp,sp,112
    80004316:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004318:	89da                	mv	s3,s6
    8000431a:	bff1                	j	800042f6 <writei+0xec>
    8000431c:	64e6                	ld	s1,88(sp)
    8000431e:	7c02                	ld	s8,32(sp)
    80004320:	6ce2                	ld	s9,24(sp)
    80004322:	6d42                	ld	s10,16(sp)
    80004324:	6da2                	ld	s11,8(sp)
    80004326:	bfc1                	j	800042f6 <writei+0xec>
    return -1;
    80004328:	557d                	li	a0,-1
}
    8000432a:	8082                	ret
    return -1;
    8000432c:	557d                	li	a0,-1
    8000432e:	bfe1                	j	80004306 <writei+0xfc>
    return -1;
    80004330:	557d                	li	a0,-1
    80004332:	bfd1                	j	80004306 <writei+0xfc>

0000000080004334 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80004334:	1141                	addi	sp,sp,-16
    80004336:	e406                	sd	ra,8(sp)
    80004338:	e022                	sd	s0,0(sp)
    8000433a:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000433c:	4639                	li	a2,14
    8000433e:	ffffd097          	auipc	ra,0xffffd
    80004342:	d26080e7          	jalr	-730(ra) # 80001064 <strncmp>
}
    80004346:	60a2                	ld	ra,8(sp)
    80004348:	6402                	ld	s0,0(sp)
    8000434a:	0141                	addi	sp,sp,16
    8000434c:	8082                	ret

000000008000434e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000434e:	7139                	addi	sp,sp,-64
    80004350:	fc06                	sd	ra,56(sp)
    80004352:	f822                	sd	s0,48(sp)
    80004354:	f426                	sd	s1,40(sp)
    80004356:	f04a                	sd	s2,32(sp)
    80004358:	ec4e                	sd	s3,24(sp)
    8000435a:	e852                	sd	s4,16(sp)
    8000435c:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000435e:	04451703          	lh	a4,68(a0)
    80004362:	4785                	li	a5,1
    80004364:	00f71a63          	bne	a4,a5,80004378 <dirlookup+0x2a>
    80004368:	892a                	mv	s2,a0
    8000436a:	89ae                	mv	s3,a1
    8000436c:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000436e:	457c                	lw	a5,76(a0)
    80004370:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004372:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004374:	e79d                	bnez	a5,800043a2 <dirlookup+0x54>
    80004376:	a8a5                	j	800043ee <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80004378:	00004517          	auipc	a0,0x4
    8000437c:	2a050513          	addi	a0,a0,672 # 80008618 <__func__.1+0x610>
    80004380:	ffffc097          	auipc	ra,0xffffc
    80004384:	1e0080e7          	jalr	480(ra) # 80000560 <panic>
      panic("dirlookup read");
    80004388:	00004517          	auipc	a0,0x4
    8000438c:	2a850513          	addi	a0,a0,680 # 80008630 <__func__.1+0x628>
    80004390:	ffffc097          	auipc	ra,0xffffc
    80004394:	1d0080e7          	jalr	464(ra) # 80000560 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004398:	24c1                	addiw	s1,s1,16
    8000439a:	04c92783          	lw	a5,76(s2)
    8000439e:	04f4f763          	bgeu	s1,a5,800043ec <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800043a2:	4741                	li	a4,16
    800043a4:	86a6                	mv	a3,s1
    800043a6:	fc040613          	addi	a2,s0,-64
    800043aa:	4581                	li	a1,0
    800043ac:	854a                	mv	a0,s2
    800043ae:	00000097          	auipc	ra,0x0
    800043b2:	d4c080e7          	jalr	-692(ra) # 800040fa <readi>
    800043b6:	47c1                	li	a5,16
    800043b8:	fcf518e3          	bne	a0,a5,80004388 <dirlookup+0x3a>
    if(de.inum == 0)
    800043bc:	fc045783          	lhu	a5,-64(s0)
    800043c0:	dfe1                	beqz	a5,80004398 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800043c2:	fc240593          	addi	a1,s0,-62
    800043c6:	854e                	mv	a0,s3
    800043c8:	00000097          	auipc	ra,0x0
    800043cc:	f6c080e7          	jalr	-148(ra) # 80004334 <namecmp>
    800043d0:	f561                	bnez	a0,80004398 <dirlookup+0x4a>
      if(poff)
    800043d2:	000a0463          	beqz	s4,800043da <dirlookup+0x8c>
        *poff = off;
    800043d6:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800043da:	fc045583          	lhu	a1,-64(s0)
    800043de:	00092503          	lw	a0,0(s2)
    800043e2:	fffff097          	auipc	ra,0xfffff
    800043e6:	720080e7          	jalr	1824(ra) # 80003b02 <iget>
    800043ea:	a011                	j	800043ee <dirlookup+0xa0>
  return 0;
    800043ec:	4501                	li	a0,0
}
    800043ee:	70e2                	ld	ra,56(sp)
    800043f0:	7442                	ld	s0,48(sp)
    800043f2:	74a2                	ld	s1,40(sp)
    800043f4:	7902                	ld	s2,32(sp)
    800043f6:	69e2                	ld	s3,24(sp)
    800043f8:	6a42                	ld	s4,16(sp)
    800043fa:	6121                	addi	sp,sp,64
    800043fc:	8082                	ret

00000000800043fe <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800043fe:	711d                	addi	sp,sp,-96
    80004400:	ec86                	sd	ra,88(sp)
    80004402:	e8a2                	sd	s0,80(sp)
    80004404:	e4a6                	sd	s1,72(sp)
    80004406:	e0ca                	sd	s2,64(sp)
    80004408:	fc4e                	sd	s3,56(sp)
    8000440a:	f852                	sd	s4,48(sp)
    8000440c:	f456                	sd	s5,40(sp)
    8000440e:	f05a                	sd	s6,32(sp)
    80004410:	ec5e                	sd	s7,24(sp)
    80004412:	e862                	sd	s8,16(sp)
    80004414:	e466                	sd	s9,8(sp)
    80004416:	1080                	addi	s0,sp,96
    80004418:	84aa                	mv	s1,a0
    8000441a:	8b2e                	mv	s6,a1
    8000441c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000441e:	00054703          	lbu	a4,0(a0)
    80004422:	02f00793          	li	a5,47
    80004426:	02f70263          	beq	a4,a5,8000444a <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000442a:	ffffe097          	auipc	ra,0xffffe
    8000442e:	962080e7          	jalr	-1694(ra) # 80001d8c <myproc>
    80004432:	15053503          	ld	a0,336(a0)
    80004436:	00000097          	auipc	ra,0x0
    8000443a:	9ce080e7          	jalr	-1586(ra) # 80003e04 <idup>
    8000443e:	8a2a                	mv	s4,a0
  while(*path == '/')
    80004440:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80004444:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004446:	4b85                	li	s7,1
    80004448:	a875                	j	80004504 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    8000444a:	4585                	li	a1,1
    8000444c:	4505                	li	a0,1
    8000444e:	fffff097          	auipc	ra,0xfffff
    80004452:	6b4080e7          	jalr	1716(ra) # 80003b02 <iget>
    80004456:	8a2a                	mv	s4,a0
    80004458:	b7e5                	j	80004440 <namex+0x42>
      iunlockput(ip);
    8000445a:	8552                	mv	a0,s4
    8000445c:	00000097          	auipc	ra,0x0
    80004460:	c4c080e7          	jalr	-948(ra) # 800040a8 <iunlockput>
      return 0;
    80004464:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80004466:	8552                	mv	a0,s4
    80004468:	60e6                	ld	ra,88(sp)
    8000446a:	6446                	ld	s0,80(sp)
    8000446c:	64a6                	ld	s1,72(sp)
    8000446e:	6906                	ld	s2,64(sp)
    80004470:	79e2                	ld	s3,56(sp)
    80004472:	7a42                	ld	s4,48(sp)
    80004474:	7aa2                	ld	s5,40(sp)
    80004476:	7b02                	ld	s6,32(sp)
    80004478:	6be2                	ld	s7,24(sp)
    8000447a:	6c42                	ld	s8,16(sp)
    8000447c:	6ca2                	ld	s9,8(sp)
    8000447e:	6125                	addi	sp,sp,96
    80004480:	8082                	ret
      iunlock(ip);
    80004482:	8552                	mv	a0,s4
    80004484:	00000097          	auipc	ra,0x0
    80004488:	a84080e7          	jalr	-1404(ra) # 80003f08 <iunlock>
      return ip;
    8000448c:	bfe9                	j	80004466 <namex+0x68>
      iunlockput(ip);
    8000448e:	8552                	mv	a0,s4
    80004490:	00000097          	auipc	ra,0x0
    80004494:	c18080e7          	jalr	-1000(ra) # 800040a8 <iunlockput>
      return 0;
    80004498:	8a4e                	mv	s4,s3
    8000449a:	b7f1                	j	80004466 <namex+0x68>
  len = path - s;
    8000449c:	40998633          	sub	a2,s3,s1
    800044a0:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800044a4:	099c5863          	bge	s8,s9,80004534 <namex+0x136>
    memmove(name, s, DIRSIZ);
    800044a8:	4639                	li	a2,14
    800044aa:	85a6                	mv	a1,s1
    800044ac:	8556                	mv	a0,s5
    800044ae:	ffffd097          	auipc	ra,0xffffd
    800044b2:	b42080e7          	jalr	-1214(ra) # 80000ff0 <memmove>
    800044b6:	84ce                	mv	s1,s3
  while(*path == '/')
    800044b8:	0004c783          	lbu	a5,0(s1)
    800044bc:	01279763          	bne	a5,s2,800044ca <namex+0xcc>
    path++;
    800044c0:	0485                	addi	s1,s1,1
  while(*path == '/')
    800044c2:	0004c783          	lbu	a5,0(s1)
    800044c6:	ff278de3          	beq	a5,s2,800044c0 <namex+0xc2>
    ilock(ip);
    800044ca:	8552                	mv	a0,s4
    800044cc:	00000097          	auipc	ra,0x0
    800044d0:	976080e7          	jalr	-1674(ra) # 80003e42 <ilock>
    if(ip->type != T_DIR){
    800044d4:	044a1783          	lh	a5,68(s4)
    800044d8:	f97791e3          	bne	a5,s7,8000445a <namex+0x5c>
    if(nameiparent && *path == '\0'){
    800044dc:	000b0563          	beqz	s6,800044e6 <namex+0xe8>
    800044e0:	0004c783          	lbu	a5,0(s1)
    800044e4:	dfd9                	beqz	a5,80004482 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    800044e6:	4601                	li	a2,0
    800044e8:	85d6                	mv	a1,s5
    800044ea:	8552                	mv	a0,s4
    800044ec:	00000097          	auipc	ra,0x0
    800044f0:	e62080e7          	jalr	-414(ra) # 8000434e <dirlookup>
    800044f4:	89aa                	mv	s3,a0
    800044f6:	dd41                	beqz	a0,8000448e <namex+0x90>
    iunlockput(ip);
    800044f8:	8552                	mv	a0,s4
    800044fa:	00000097          	auipc	ra,0x0
    800044fe:	bae080e7          	jalr	-1106(ra) # 800040a8 <iunlockput>
    ip = next;
    80004502:	8a4e                	mv	s4,s3
  while(*path == '/')
    80004504:	0004c783          	lbu	a5,0(s1)
    80004508:	01279763          	bne	a5,s2,80004516 <namex+0x118>
    path++;
    8000450c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000450e:	0004c783          	lbu	a5,0(s1)
    80004512:	ff278de3          	beq	a5,s2,8000450c <namex+0x10e>
  if(*path == 0)
    80004516:	cb9d                	beqz	a5,8000454c <namex+0x14e>
  while(*path != '/' && *path != 0)
    80004518:	0004c783          	lbu	a5,0(s1)
    8000451c:	89a6                	mv	s3,s1
  len = path - s;
    8000451e:	4c81                	li	s9,0
    80004520:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80004522:	01278963          	beq	a5,s2,80004534 <namex+0x136>
    80004526:	dbbd                	beqz	a5,8000449c <namex+0x9e>
    path++;
    80004528:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    8000452a:	0009c783          	lbu	a5,0(s3)
    8000452e:	ff279ce3          	bne	a5,s2,80004526 <namex+0x128>
    80004532:	b7ad                	j	8000449c <namex+0x9e>
    memmove(name, s, len);
    80004534:	2601                	sext.w	a2,a2
    80004536:	85a6                	mv	a1,s1
    80004538:	8556                	mv	a0,s5
    8000453a:	ffffd097          	auipc	ra,0xffffd
    8000453e:	ab6080e7          	jalr	-1354(ra) # 80000ff0 <memmove>
    name[len] = 0;
    80004542:	9cd6                	add	s9,s9,s5
    80004544:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80004548:	84ce                	mv	s1,s3
    8000454a:	b7bd                	j	800044b8 <namex+0xba>
  if(nameiparent){
    8000454c:	f00b0de3          	beqz	s6,80004466 <namex+0x68>
    iput(ip);
    80004550:	8552                	mv	a0,s4
    80004552:	00000097          	auipc	ra,0x0
    80004556:	aae080e7          	jalr	-1362(ra) # 80004000 <iput>
    return 0;
    8000455a:	4a01                	li	s4,0
    8000455c:	b729                	j	80004466 <namex+0x68>

000000008000455e <dirlink>:
{
    8000455e:	7139                	addi	sp,sp,-64
    80004560:	fc06                	sd	ra,56(sp)
    80004562:	f822                	sd	s0,48(sp)
    80004564:	f04a                	sd	s2,32(sp)
    80004566:	ec4e                	sd	s3,24(sp)
    80004568:	e852                	sd	s4,16(sp)
    8000456a:	0080                	addi	s0,sp,64
    8000456c:	892a                	mv	s2,a0
    8000456e:	8a2e                	mv	s4,a1
    80004570:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004572:	4601                	li	a2,0
    80004574:	00000097          	auipc	ra,0x0
    80004578:	dda080e7          	jalr	-550(ra) # 8000434e <dirlookup>
    8000457c:	ed25                	bnez	a0,800045f4 <dirlink+0x96>
    8000457e:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004580:	04c92483          	lw	s1,76(s2)
    80004584:	c49d                	beqz	s1,800045b2 <dirlink+0x54>
    80004586:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004588:	4741                	li	a4,16
    8000458a:	86a6                	mv	a3,s1
    8000458c:	fc040613          	addi	a2,s0,-64
    80004590:	4581                	li	a1,0
    80004592:	854a                	mv	a0,s2
    80004594:	00000097          	auipc	ra,0x0
    80004598:	b66080e7          	jalr	-1178(ra) # 800040fa <readi>
    8000459c:	47c1                	li	a5,16
    8000459e:	06f51163          	bne	a0,a5,80004600 <dirlink+0xa2>
    if(de.inum == 0)
    800045a2:	fc045783          	lhu	a5,-64(s0)
    800045a6:	c791                	beqz	a5,800045b2 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800045a8:	24c1                	addiw	s1,s1,16
    800045aa:	04c92783          	lw	a5,76(s2)
    800045ae:	fcf4ede3          	bltu	s1,a5,80004588 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800045b2:	4639                	li	a2,14
    800045b4:	85d2                	mv	a1,s4
    800045b6:	fc240513          	addi	a0,s0,-62
    800045ba:	ffffd097          	auipc	ra,0xffffd
    800045be:	ae0080e7          	jalr	-1312(ra) # 8000109a <strncpy>
  de.inum = inum;
    800045c2:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800045c6:	4741                	li	a4,16
    800045c8:	86a6                	mv	a3,s1
    800045ca:	fc040613          	addi	a2,s0,-64
    800045ce:	4581                	li	a1,0
    800045d0:	854a                	mv	a0,s2
    800045d2:	00000097          	auipc	ra,0x0
    800045d6:	c38080e7          	jalr	-968(ra) # 8000420a <writei>
    800045da:	1541                	addi	a0,a0,-16
    800045dc:	00a03533          	snez	a0,a0
    800045e0:	40a00533          	neg	a0,a0
    800045e4:	74a2                	ld	s1,40(sp)
}
    800045e6:	70e2                	ld	ra,56(sp)
    800045e8:	7442                	ld	s0,48(sp)
    800045ea:	7902                	ld	s2,32(sp)
    800045ec:	69e2                	ld	s3,24(sp)
    800045ee:	6a42                	ld	s4,16(sp)
    800045f0:	6121                	addi	sp,sp,64
    800045f2:	8082                	ret
    iput(ip);
    800045f4:	00000097          	auipc	ra,0x0
    800045f8:	a0c080e7          	jalr	-1524(ra) # 80004000 <iput>
    return -1;
    800045fc:	557d                	li	a0,-1
    800045fe:	b7e5                	j	800045e6 <dirlink+0x88>
      panic("dirlink read");
    80004600:	00004517          	auipc	a0,0x4
    80004604:	04050513          	addi	a0,a0,64 # 80008640 <__func__.1+0x638>
    80004608:	ffffc097          	auipc	ra,0xffffc
    8000460c:	f58080e7          	jalr	-168(ra) # 80000560 <panic>

0000000080004610 <namei>:

struct inode*
namei(char *path)
{
    80004610:	1101                	addi	sp,sp,-32
    80004612:	ec06                	sd	ra,24(sp)
    80004614:	e822                	sd	s0,16(sp)
    80004616:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004618:	fe040613          	addi	a2,s0,-32
    8000461c:	4581                	li	a1,0
    8000461e:	00000097          	auipc	ra,0x0
    80004622:	de0080e7          	jalr	-544(ra) # 800043fe <namex>
}
    80004626:	60e2                	ld	ra,24(sp)
    80004628:	6442                	ld	s0,16(sp)
    8000462a:	6105                	addi	sp,sp,32
    8000462c:	8082                	ret

000000008000462e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000462e:	1141                	addi	sp,sp,-16
    80004630:	e406                	sd	ra,8(sp)
    80004632:	e022                	sd	s0,0(sp)
    80004634:	0800                	addi	s0,sp,16
    80004636:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004638:	4585                	li	a1,1
    8000463a:	00000097          	auipc	ra,0x0
    8000463e:	dc4080e7          	jalr	-572(ra) # 800043fe <namex>
}
    80004642:	60a2                	ld	ra,8(sp)
    80004644:	6402                	ld	s0,0(sp)
    80004646:	0141                	addi	sp,sp,16
    80004648:	8082                	ret

000000008000464a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000464a:	1101                	addi	sp,sp,-32
    8000464c:	ec06                	sd	ra,24(sp)
    8000464e:	e822                	sd	s0,16(sp)
    80004650:	e426                	sd	s1,8(sp)
    80004652:	e04a                	sd	s2,0(sp)
    80004654:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004656:	0023f917          	auipc	s2,0x23f
    8000465a:	19a90913          	addi	s2,s2,410 # 802437f0 <log>
    8000465e:	01892583          	lw	a1,24(s2)
    80004662:	02892503          	lw	a0,40(s2)
    80004666:	fffff097          	auipc	ra,0xfffff
    8000466a:	fa8080e7          	jalr	-88(ra) # 8000360e <bread>
    8000466e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004670:	02c92603          	lw	a2,44(s2)
    80004674:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004676:	00c05f63          	blez	a2,80004694 <write_head+0x4a>
    8000467a:	0023f717          	auipc	a4,0x23f
    8000467e:	1a670713          	addi	a4,a4,422 # 80243820 <log+0x30>
    80004682:	87aa                	mv	a5,a0
    80004684:	060a                	slli	a2,a2,0x2
    80004686:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80004688:	4314                	lw	a3,0(a4)
    8000468a:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000468c:	0711                	addi	a4,a4,4
    8000468e:	0791                	addi	a5,a5,4
    80004690:	fec79ce3          	bne	a5,a2,80004688 <write_head+0x3e>
  }
  bwrite(buf);
    80004694:	8526                	mv	a0,s1
    80004696:	fffff097          	auipc	ra,0xfffff
    8000469a:	06a080e7          	jalr	106(ra) # 80003700 <bwrite>
  brelse(buf);
    8000469e:	8526                	mv	a0,s1
    800046a0:	fffff097          	auipc	ra,0xfffff
    800046a4:	09e080e7          	jalr	158(ra) # 8000373e <brelse>
}
    800046a8:	60e2                	ld	ra,24(sp)
    800046aa:	6442                	ld	s0,16(sp)
    800046ac:	64a2                	ld	s1,8(sp)
    800046ae:	6902                	ld	s2,0(sp)
    800046b0:	6105                	addi	sp,sp,32
    800046b2:	8082                	ret

00000000800046b4 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800046b4:	0023f797          	auipc	a5,0x23f
    800046b8:	1687a783          	lw	a5,360(a5) # 8024381c <log+0x2c>
    800046bc:	0af05d63          	blez	a5,80004776 <install_trans+0xc2>
{
    800046c0:	7139                	addi	sp,sp,-64
    800046c2:	fc06                	sd	ra,56(sp)
    800046c4:	f822                	sd	s0,48(sp)
    800046c6:	f426                	sd	s1,40(sp)
    800046c8:	f04a                	sd	s2,32(sp)
    800046ca:	ec4e                	sd	s3,24(sp)
    800046cc:	e852                	sd	s4,16(sp)
    800046ce:	e456                	sd	s5,8(sp)
    800046d0:	e05a                	sd	s6,0(sp)
    800046d2:	0080                	addi	s0,sp,64
    800046d4:	8b2a                	mv	s6,a0
    800046d6:	0023fa97          	auipc	s5,0x23f
    800046da:	14aa8a93          	addi	s5,s5,330 # 80243820 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800046de:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800046e0:	0023f997          	auipc	s3,0x23f
    800046e4:	11098993          	addi	s3,s3,272 # 802437f0 <log>
    800046e8:	a00d                	j	8000470a <install_trans+0x56>
    brelse(lbuf);
    800046ea:	854a                	mv	a0,s2
    800046ec:	fffff097          	auipc	ra,0xfffff
    800046f0:	052080e7          	jalr	82(ra) # 8000373e <brelse>
    brelse(dbuf);
    800046f4:	8526                	mv	a0,s1
    800046f6:	fffff097          	auipc	ra,0xfffff
    800046fa:	048080e7          	jalr	72(ra) # 8000373e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800046fe:	2a05                	addiw	s4,s4,1
    80004700:	0a91                	addi	s5,s5,4
    80004702:	02c9a783          	lw	a5,44(s3)
    80004706:	04fa5e63          	bge	s4,a5,80004762 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000470a:	0189a583          	lw	a1,24(s3)
    8000470e:	014585bb          	addw	a1,a1,s4
    80004712:	2585                	addiw	a1,a1,1
    80004714:	0289a503          	lw	a0,40(s3)
    80004718:	fffff097          	auipc	ra,0xfffff
    8000471c:	ef6080e7          	jalr	-266(ra) # 8000360e <bread>
    80004720:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004722:	000aa583          	lw	a1,0(s5)
    80004726:	0289a503          	lw	a0,40(s3)
    8000472a:	fffff097          	auipc	ra,0xfffff
    8000472e:	ee4080e7          	jalr	-284(ra) # 8000360e <bread>
    80004732:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004734:	40000613          	li	a2,1024
    80004738:	05890593          	addi	a1,s2,88
    8000473c:	05850513          	addi	a0,a0,88
    80004740:	ffffd097          	auipc	ra,0xffffd
    80004744:	8b0080e7          	jalr	-1872(ra) # 80000ff0 <memmove>
    bwrite(dbuf);  // write dst to disk
    80004748:	8526                	mv	a0,s1
    8000474a:	fffff097          	auipc	ra,0xfffff
    8000474e:	fb6080e7          	jalr	-74(ra) # 80003700 <bwrite>
    if(recovering == 0)
    80004752:	f80b1ce3          	bnez	s6,800046ea <install_trans+0x36>
      bunpin(dbuf);
    80004756:	8526                	mv	a0,s1
    80004758:	fffff097          	auipc	ra,0xfffff
    8000475c:	0be080e7          	jalr	190(ra) # 80003816 <bunpin>
    80004760:	b769                	j	800046ea <install_trans+0x36>
}
    80004762:	70e2                	ld	ra,56(sp)
    80004764:	7442                	ld	s0,48(sp)
    80004766:	74a2                	ld	s1,40(sp)
    80004768:	7902                	ld	s2,32(sp)
    8000476a:	69e2                	ld	s3,24(sp)
    8000476c:	6a42                	ld	s4,16(sp)
    8000476e:	6aa2                	ld	s5,8(sp)
    80004770:	6b02                	ld	s6,0(sp)
    80004772:	6121                	addi	sp,sp,64
    80004774:	8082                	ret
    80004776:	8082                	ret

0000000080004778 <initlog>:
{
    80004778:	7179                	addi	sp,sp,-48
    8000477a:	f406                	sd	ra,40(sp)
    8000477c:	f022                	sd	s0,32(sp)
    8000477e:	ec26                	sd	s1,24(sp)
    80004780:	e84a                	sd	s2,16(sp)
    80004782:	e44e                	sd	s3,8(sp)
    80004784:	1800                	addi	s0,sp,48
    80004786:	892a                	mv	s2,a0
    80004788:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000478a:	0023f497          	auipc	s1,0x23f
    8000478e:	06648493          	addi	s1,s1,102 # 802437f0 <log>
    80004792:	00004597          	auipc	a1,0x4
    80004796:	ebe58593          	addi	a1,a1,-322 # 80008650 <__func__.1+0x648>
    8000479a:	8526                	mv	a0,s1
    8000479c:	ffffc097          	auipc	ra,0xffffc
    800047a0:	66c080e7          	jalr	1644(ra) # 80000e08 <initlock>
  log.start = sb->logstart;
    800047a4:	0149a583          	lw	a1,20(s3)
    800047a8:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800047aa:	0109a783          	lw	a5,16(s3)
    800047ae:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800047b0:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800047b4:	854a                	mv	a0,s2
    800047b6:	fffff097          	auipc	ra,0xfffff
    800047ba:	e58080e7          	jalr	-424(ra) # 8000360e <bread>
  log.lh.n = lh->n;
    800047be:	4d30                	lw	a2,88(a0)
    800047c0:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800047c2:	00c05f63          	blez	a2,800047e0 <initlog+0x68>
    800047c6:	87aa                	mv	a5,a0
    800047c8:	0023f717          	auipc	a4,0x23f
    800047cc:	05870713          	addi	a4,a4,88 # 80243820 <log+0x30>
    800047d0:	060a                	slli	a2,a2,0x2
    800047d2:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800047d4:	4ff4                	lw	a3,92(a5)
    800047d6:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800047d8:	0791                	addi	a5,a5,4
    800047da:	0711                	addi	a4,a4,4
    800047dc:	fec79ce3          	bne	a5,a2,800047d4 <initlog+0x5c>
  brelse(buf);
    800047e0:	fffff097          	auipc	ra,0xfffff
    800047e4:	f5e080e7          	jalr	-162(ra) # 8000373e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800047e8:	4505                	li	a0,1
    800047ea:	00000097          	auipc	ra,0x0
    800047ee:	eca080e7          	jalr	-310(ra) # 800046b4 <install_trans>
  log.lh.n = 0;
    800047f2:	0023f797          	auipc	a5,0x23f
    800047f6:	0207a523          	sw	zero,42(a5) # 8024381c <log+0x2c>
  write_head(); // clear the log
    800047fa:	00000097          	auipc	ra,0x0
    800047fe:	e50080e7          	jalr	-432(ra) # 8000464a <write_head>
}
    80004802:	70a2                	ld	ra,40(sp)
    80004804:	7402                	ld	s0,32(sp)
    80004806:	64e2                	ld	s1,24(sp)
    80004808:	6942                	ld	s2,16(sp)
    8000480a:	69a2                	ld	s3,8(sp)
    8000480c:	6145                	addi	sp,sp,48
    8000480e:	8082                	ret

0000000080004810 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004810:	1101                	addi	sp,sp,-32
    80004812:	ec06                	sd	ra,24(sp)
    80004814:	e822                	sd	s0,16(sp)
    80004816:	e426                	sd	s1,8(sp)
    80004818:	e04a                	sd	s2,0(sp)
    8000481a:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000481c:	0023f517          	auipc	a0,0x23f
    80004820:	fd450513          	addi	a0,a0,-44 # 802437f0 <log>
    80004824:	ffffc097          	auipc	ra,0xffffc
    80004828:	674080e7          	jalr	1652(ra) # 80000e98 <acquire>
  while(1){
    if(log.committing){
    8000482c:	0023f497          	auipc	s1,0x23f
    80004830:	fc448493          	addi	s1,s1,-60 # 802437f0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004834:	4979                	li	s2,30
    80004836:	a039                	j	80004844 <begin_op+0x34>
      sleep(&log, &log.lock);
    80004838:	85a6                	mv	a1,s1
    8000483a:	8526                	mv	a0,s1
    8000483c:	ffffe097          	auipc	ra,0xffffe
    80004840:	d02080e7          	jalr	-766(ra) # 8000253e <sleep>
    if(log.committing){
    80004844:	50dc                	lw	a5,36(s1)
    80004846:	fbed                	bnez	a5,80004838 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004848:	5098                	lw	a4,32(s1)
    8000484a:	2705                	addiw	a4,a4,1
    8000484c:	0027179b          	slliw	a5,a4,0x2
    80004850:	9fb9                	addw	a5,a5,a4
    80004852:	0017979b          	slliw	a5,a5,0x1
    80004856:	54d4                	lw	a3,44(s1)
    80004858:	9fb5                	addw	a5,a5,a3
    8000485a:	00f95963          	bge	s2,a5,8000486c <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000485e:	85a6                	mv	a1,s1
    80004860:	8526                	mv	a0,s1
    80004862:	ffffe097          	auipc	ra,0xffffe
    80004866:	cdc080e7          	jalr	-804(ra) # 8000253e <sleep>
    8000486a:	bfe9                	j	80004844 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000486c:	0023f517          	auipc	a0,0x23f
    80004870:	f8450513          	addi	a0,a0,-124 # 802437f0 <log>
    80004874:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80004876:	ffffc097          	auipc	ra,0xffffc
    8000487a:	6d6080e7          	jalr	1750(ra) # 80000f4c <release>
      break;
    }
  }
}
    8000487e:	60e2                	ld	ra,24(sp)
    80004880:	6442                	ld	s0,16(sp)
    80004882:	64a2                	ld	s1,8(sp)
    80004884:	6902                	ld	s2,0(sp)
    80004886:	6105                	addi	sp,sp,32
    80004888:	8082                	ret

000000008000488a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000488a:	7139                	addi	sp,sp,-64
    8000488c:	fc06                	sd	ra,56(sp)
    8000488e:	f822                	sd	s0,48(sp)
    80004890:	f426                	sd	s1,40(sp)
    80004892:	f04a                	sd	s2,32(sp)
    80004894:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004896:	0023f497          	auipc	s1,0x23f
    8000489a:	f5a48493          	addi	s1,s1,-166 # 802437f0 <log>
    8000489e:	8526                	mv	a0,s1
    800048a0:	ffffc097          	auipc	ra,0xffffc
    800048a4:	5f8080e7          	jalr	1528(ra) # 80000e98 <acquire>
  log.outstanding -= 1;
    800048a8:	509c                	lw	a5,32(s1)
    800048aa:	37fd                	addiw	a5,a5,-1
    800048ac:	0007891b          	sext.w	s2,a5
    800048b0:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800048b2:	50dc                	lw	a5,36(s1)
    800048b4:	e7b9                	bnez	a5,80004902 <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    800048b6:	06091163          	bnez	s2,80004918 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800048ba:	0023f497          	auipc	s1,0x23f
    800048be:	f3648493          	addi	s1,s1,-202 # 802437f0 <log>
    800048c2:	4785                	li	a5,1
    800048c4:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800048c6:	8526                	mv	a0,s1
    800048c8:	ffffc097          	auipc	ra,0xffffc
    800048cc:	684080e7          	jalr	1668(ra) # 80000f4c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800048d0:	54dc                	lw	a5,44(s1)
    800048d2:	06f04763          	bgtz	a5,80004940 <end_op+0xb6>
    acquire(&log.lock);
    800048d6:	0023f497          	auipc	s1,0x23f
    800048da:	f1a48493          	addi	s1,s1,-230 # 802437f0 <log>
    800048de:	8526                	mv	a0,s1
    800048e0:	ffffc097          	auipc	ra,0xffffc
    800048e4:	5b8080e7          	jalr	1464(ra) # 80000e98 <acquire>
    log.committing = 0;
    800048e8:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800048ec:	8526                	mv	a0,s1
    800048ee:	ffffe097          	auipc	ra,0xffffe
    800048f2:	cb4080e7          	jalr	-844(ra) # 800025a2 <wakeup>
    release(&log.lock);
    800048f6:	8526                	mv	a0,s1
    800048f8:	ffffc097          	auipc	ra,0xffffc
    800048fc:	654080e7          	jalr	1620(ra) # 80000f4c <release>
}
    80004900:	a815                	j	80004934 <end_op+0xaa>
    80004902:	ec4e                	sd	s3,24(sp)
    80004904:	e852                	sd	s4,16(sp)
    80004906:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80004908:	00004517          	auipc	a0,0x4
    8000490c:	d5050513          	addi	a0,a0,-688 # 80008658 <__func__.1+0x650>
    80004910:	ffffc097          	auipc	ra,0xffffc
    80004914:	c50080e7          	jalr	-944(ra) # 80000560 <panic>
    wakeup(&log);
    80004918:	0023f497          	auipc	s1,0x23f
    8000491c:	ed848493          	addi	s1,s1,-296 # 802437f0 <log>
    80004920:	8526                	mv	a0,s1
    80004922:	ffffe097          	auipc	ra,0xffffe
    80004926:	c80080e7          	jalr	-896(ra) # 800025a2 <wakeup>
  release(&log.lock);
    8000492a:	8526                	mv	a0,s1
    8000492c:	ffffc097          	auipc	ra,0xffffc
    80004930:	620080e7          	jalr	1568(ra) # 80000f4c <release>
}
    80004934:	70e2                	ld	ra,56(sp)
    80004936:	7442                	ld	s0,48(sp)
    80004938:	74a2                	ld	s1,40(sp)
    8000493a:	7902                	ld	s2,32(sp)
    8000493c:	6121                	addi	sp,sp,64
    8000493e:	8082                	ret
    80004940:	ec4e                	sd	s3,24(sp)
    80004942:	e852                	sd	s4,16(sp)
    80004944:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80004946:	0023fa97          	auipc	s5,0x23f
    8000494a:	edaa8a93          	addi	s5,s5,-294 # 80243820 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000494e:	0023fa17          	auipc	s4,0x23f
    80004952:	ea2a0a13          	addi	s4,s4,-350 # 802437f0 <log>
    80004956:	018a2583          	lw	a1,24(s4)
    8000495a:	012585bb          	addw	a1,a1,s2
    8000495e:	2585                	addiw	a1,a1,1
    80004960:	028a2503          	lw	a0,40(s4)
    80004964:	fffff097          	auipc	ra,0xfffff
    80004968:	caa080e7          	jalr	-854(ra) # 8000360e <bread>
    8000496c:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000496e:	000aa583          	lw	a1,0(s5)
    80004972:	028a2503          	lw	a0,40(s4)
    80004976:	fffff097          	auipc	ra,0xfffff
    8000497a:	c98080e7          	jalr	-872(ra) # 8000360e <bread>
    8000497e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004980:	40000613          	li	a2,1024
    80004984:	05850593          	addi	a1,a0,88
    80004988:	05848513          	addi	a0,s1,88
    8000498c:	ffffc097          	auipc	ra,0xffffc
    80004990:	664080e7          	jalr	1636(ra) # 80000ff0 <memmove>
    bwrite(to);  // write the log
    80004994:	8526                	mv	a0,s1
    80004996:	fffff097          	auipc	ra,0xfffff
    8000499a:	d6a080e7          	jalr	-662(ra) # 80003700 <bwrite>
    brelse(from);
    8000499e:	854e                	mv	a0,s3
    800049a0:	fffff097          	auipc	ra,0xfffff
    800049a4:	d9e080e7          	jalr	-610(ra) # 8000373e <brelse>
    brelse(to);
    800049a8:	8526                	mv	a0,s1
    800049aa:	fffff097          	auipc	ra,0xfffff
    800049ae:	d94080e7          	jalr	-620(ra) # 8000373e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800049b2:	2905                	addiw	s2,s2,1
    800049b4:	0a91                	addi	s5,s5,4
    800049b6:	02ca2783          	lw	a5,44(s4)
    800049ba:	f8f94ee3          	blt	s2,a5,80004956 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800049be:	00000097          	auipc	ra,0x0
    800049c2:	c8c080e7          	jalr	-884(ra) # 8000464a <write_head>
    install_trans(0); // Now install writes to home locations
    800049c6:	4501                	li	a0,0
    800049c8:	00000097          	auipc	ra,0x0
    800049cc:	cec080e7          	jalr	-788(ra) # 800046b4 <install_trans>
    log.lh.n = 0;
    800049d0:	0023f797          	auipc	a5,0x23f
    800049d4:	e407a623          	sw	zero,-436(a5) # 8024381c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800049d8:	00000097          	auipc	ra,0x0
    800049dc:	c72080e7          	jalr	-910(ra) # 8000464a <write_head>
    800049e0:	69e2                	ld	s3,24(sp)
    800049e2:	6a42                	ld	s4,16(sp)
    800049e4:	6aa2                	ld	s5,8(sp)
    800049e6:	bdc5                	j	800048d6 <end_op+0x4c>

00000000800049e8 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800049e8:	1101                	addi	sp,sp,-32
    800049ea:	ec06                	sd	ra,24(sp)
    800049ec:	e822                	sd	s0,16(sp)
    800049ee:	e426                	sd	s1,8(sp)
    800049f0:	e04a                	sd	s2,0(sp)
    800049f2:	1000                	addi	s0,sp,32
    800049f4:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800049f6:	0023f917          	auipc	s2,0x23f
    800049fa:	dfa90913          	addi	s2,s2,-518 # 802437f0 <log>
    800049fe:	854a                	mv	a0,s2
    80004a00:	ffffc097          	auipc	ra,0xffffc
    80004a04:	498080e7          	jalr	1176(ra) # 80000e98 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004a08:	02c92603          	lw	a2,44(s2)
    80004a0c:	47f5                	li	a5,29
    80004a0e:	06c7c563          	blt	a5,a2,80004a78 <log_write+0x90>
    80004a12:	0023f797          	auipc	a5,0x23f
    80004a16:	dfa7a783          	lw	a5,-518(a5) # 8024380c <log+0x1c>
    80004a1a:	37fd                	addiw	a5,a5,-1
    80004a1c:	04f65e63          	bge	a2,a5,80004a78 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004a20:	0023f797          	auipc	a5,0x23f
    80004a24:	df07a783          	lw	a5,-528(a5) # 80243810 <log+0x20>
    80004a28:	06f05063          	blez	a5,80004a88 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004a2c:	4781                	li	a5,0
    80004a2e:	06c05563          	blez	a2,80004a98 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004a32:	44cc                	lw	a1,12(s1)
    80004a34:	0023f717          	auipc	a4,0x23f
    80004a38:	dec70713          	addi	a4,a4,-532 # 80243820 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004a3c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004a3e:	4314                	lw	a3,0(a4)
    80004a40:	04b68c63          	beq	a3,a1,80004a98 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80004a44:	2785                	addiw	a5,a5,1
    80004a46:	0711                	addi	a4,a4,4
    80004a48:	fef61be3          	bne	a2,a5,80004a3e <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004a4c:	0621                	addi	a2,a2,8
    80004a4e:	060a                	slli	a2,a2,0x2
    80004a50:	0023f797          	auipc	a5,0x23f
    80004a54:	da078793          	addi	a5,a5,-608 # 802437f0 <log>
    80004a58:	97b2                	add	a5,a5,a2
    80004a5a:	44d8                	lw	a4,12(s1)
    80004a5c:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004a5e:	8526                	mv	a0,s1
    80004a60:	fffff097          	auipc	ra,0xfffff
    80004a64:	d7a080e7          	jalr	-646(ra) # 800037da <bpin>
    log.lh.n++;
    80004a68:	0023f717          	auipc	a4,0x23f
    80004a6c:	d8870713          	addi	a4,a4,-632 # 802437f0 <log>
    80004a70:	575c                	lw	a5,44(a4)
    80004a72:	2785                	addiw	a5,a5,1
    80004a74:	d75c                	sw	a5,44(a4)
    80004a76:	a82d                	j	80004ab0 <log_write+0xc8>
    panic("too big a transaction");
    80004a78:	00004517          	auipc	a0,0x4
    80004a7c:	bf050513          	addi	a0,a0,-1040 # 80008668 <__func__.1+0x660>
    80004a80:	ffffc097          	auipc	ra,0xffffc
    80004a84:	ae0080e7          	jalr	-1312(ra) # 80000560 <panic>
    panic("log_write outside of trans");
    80004a88:	00004517          	auipc	a0,0x4
    80004a8c:	bf850513          	addi	a0,a0,-1032 # 80008680 <__func__.1+0x678>
    80004a90:	ffffc097          	auipc	ra,0xffffc
    80004a94:	ad0080e7          	jalr	-1328(ra) # 80000560 <panic>
  log.lh.block[i] = b->blockno;
    80004a98:	00878693          	addi	a3,a5,8
    80004a9c:	068a                	slli	a3,a3,0x2
    80004a9e:	0023f717          	auipc	a4,0x23f
    80004aa2:	d5270713          	addi	a4,a4,-686 # 802437f0 <log>
    80004aa6:	9736                	add	a4,a4,a3
    80004aa8:	44d4                	lw	a3,12(s1)
    80004aaa:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004aac:	faf609e3          	beq	a2,a5,80004a5e <log_write+0x76>
  }
  release(&log.lock);
    80004ab0:	0023f517          	auipc	a0,0x23f
    80004ab4:	d4050513          	addi	a0,a0,-704 # 802437f0 <log>
    80004ab8:	ffffc097          	auipc	ra,0xffffc
    80004abc:	494080e7          	jalr	1172(ra) # 80000f4c <release>
}
    80004ac0:	60e2                	ld	ra,24(sp)
    80004ac2:	6442                	ld	s0,16(sp)
    80004ac4:	64a2                	ld	s1,8(sp)
    80004ac6:	6902                	ld	s2,0(sp)
    80004ac8:	6105                	addi	sp,sp,32
    80004aca:	8082                	ret

0000000080004acc <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004acc:	1101                	addi	sp,sp,-32
    80004ace:	ec06                	sd	ra,24(sp)
    80004ad0:	e822                	sd	s0,16(sp)
    80004ad2:	e426                	sd	s1,8(sp)
    80004ad4:	e04a                	sd	s2,0(sp)
    80004ad6:	1000                	addi	s0,sp,32
    80004ad8:	84aa                	mv	s1,a0
    80004ada:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004adc:	00004597          	auipc	a1,0x4
    80004ae0:	bc458593          	addi	a1,a1,-1084 # 800086a0 <__func__.1+0x698>
    80004ae4:	0521                	addi	a0,a0,8
    80004ae6:	ffffc097          	auipc	ra,0xffffc
    80004aea:	322080e7          	jalr	802(ra) # 80000e08 <initlock>
  lk->name = name;
    80004aee:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004af2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004af6:	0204a423          	sw	zero,40(s1)
}
    80004afa:	60e2                	ld	ra,24(sp)
    80004afc:	6442                	ld	s0,16(sp)
    80004afe:	64a2                	ld	s1,8(sp)
    80004b00:	6902                	ld	s2,0(sp)
    80004b02:	6105                	addi	sp,sp,32
    80004b04:	8082                	ret

0000000080004b06 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004b06:	1101                	addi	sp,sp,-32
    80004b08:	ec06                	sd	ra,24(sp)
    80004b0a:	e822                	sd	s0,16(sp)
    80004b0c:	e426                	sd	s1,8(sp)
    80004b0e:	e04a                	sd	s2,0(sp)
    80004b10:	1000                	addi	s0,sp,32
    80004b12:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004b14:	00850913          	addi	s2,a0,8
    80004b18:	854a                	mv	a0,s2
    80004b1a:	ffffc097          	auipc	ra,0xffffc
    80004b1e:	37e080e7          	jalr	894(ra) # 80000e98 <acquire>
  while (lk->locked) {
    80004b22:	409c                	lw	a5,0(s1)
    80004b24:	cb89                	beqz	a5,80004b36 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004b26:	85ca                	mv	a1,s2
    80004b28:	8526                	mv	a0,s1
    80004b2a:	ffffe097          	auipc	ra,0xffffe
    80004b2e:	a14080e7          	jalr	-1516(ra) # 8000253e <sleep>
  while (lk->locked) {
    80004b32:	409c                	lw	a5,0(s1)
    80004b34:	fbed                	bnez	a5,80004b26 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004b36:	4785                	li	a5,1
    80004b38:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004b3a:	ffffd097          	auipc	ra,0xffffd
    80004b3e:	252080e7          	jalr	594(ra) # 80001d8c <myproc>
    80004b42:	591c                	lw	a5,48(a0)
    80004b44:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004b46:	854a                	mv	a0,s2
    80004b48:	ffffc097          	auipc	ra,0xffffc
    80004b4c:	404080e7          	jalr	1028(ra) # 80000f4c <release>
}
    80004b50:	60e2                	ld	ra,24(sp)
    80004b52:	6442                	ld	s0,16(sp)
    80004b54:	64a2                	ld	s1,8(sp)
    80004b56:	6902                	ld	s2,0(sp)
    80004b58:	6105                	addi	sp,sp,32
    80004b5a:	8082                	ret

0000000080004b5c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004b5c:	1101                	addi	sp,sp,-32
    80004b5e:	ec06                	sd	ra,24(sp)
    80004b60:	e822                	sd	s0,16(sp)
    80004b62:	e426                	sd	s1,8(sp)
    80004b64:	e04a                	sd	s2,0(sp)
    80004b66:	1000                	addi	s0,sp,32
    80004b68:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004b6a:	00850913          	addi	s2,a0,8
    80004b6e:	854a                	mv	a0,s2
    80004b70:	ffffc097          	auipc	ra,0xffffc
    80004b74:	328080e7          	jalr	808(ra) # 80000e98 <acquire>
  lk->locked = 0;
    80004b78:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004b7c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004b80:	8526                	mv	a0,s1
    80004b82:	ffffe097          	auipc	ra,0xffffe
    80004b86:	a20080e7          	jalr	-1504(ra) # 800025a2 <wakeup>
  release(&lk->lk);
    80004b8a:	854a                	mv	a0,s2
    80004b8c:	ffffc097          	auipc	ra,0xffffc
    80004b90:	3c0080e7          	jalr	960(ra) # 80000f4c <release>
}
    80004b94:	60e2                	ld	ra,24(sp)
    80004b96:	6442                	ld	s0,16(sp)
    80004b98:	64a2                	ld	s1,8(sp)
    80004b9a:	6902                	ld	s2,0(sp)
    80004b9c:	6105                	addi	sp,sp,32
    80004b9e:	8082                	ret

0000000080004ba0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004ba0:	7179                	addi	sp,sp,-48
    80004ba2:	f406                	sd	ra,40(sp)
    80004ba4:	f022                	sd	s0,32(sp)
    80004ba6:	ec26                	sd	s1,24(sp)
    80004ba8:	e84a                	sd	s2,16(sp)
    80004baa:	1800                	addi	s0,sp,48
    80004bac:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004bae:	00850913          	addi	s2,a0,8
    80004bb2:	854a                	mv	a0,s2
    80004bb4:	ffffc097          	auipc	ra,0xffffc
    80004bb8:	2e4080e7          	jalr	740(ra) # 80000e98 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004bbc:	409c                	lw	a5,0(s1)
    80004bbe:	ef91                	bnez	a5,80004bda <holdingsleep+0x3a>
    80004bc0:	4481                	li	s1,0
  release(&lk->lk);
    80004bc2:	854a                	mv	a0,s2
    80004bc4:	ffffc097          	auipc	ra,0xffffc
    80004bc8:	388080e7          	jalr	904(ra) # 80000f4c <release>
  return r;
}
    80004bcc:	8526                	mv	a0,s1
    80004bce:	70a2                	ld	ra,40(sp)
    80004bd0:	7402                	ld	s0,32(sp)
    80004bd2:	64e2                	ld	s1,24(sp)
    80004bd4:	6942                	ld	s2,16(sp)
    80004bd6:	6145                	addi	sp,sp,48
    80004bd8:	8082                	ret
    80004bda:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004bdc:	0284a983          	lw	s3,40(s1)
    80004be0:	ffffd097          	auipc	ra,0xffffd
    80004be4:	1ac080e7          	jalr	428(ra) # 80001d8c <myproc>
    80004be8:	5904                	lw	s1,48(a0)
    80004bea:	413484b3          	sub	s1,s1,s3
    80004bee:	0014b493          	seqz	s1,s1
    80004bf2:	69a2                	ld	s3,8(sp)
    80004bf4:	b7f9                	j	80004bc2 <holdingsleep+0x22>

0000000080004bf6 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004bf6:	1141                	addi	sp,sp,-16
    80004bf8:	e406                	sd	ra,8(sp)
    80004bfa:	e022                	sd	s0,0(sp)
    80004bfc:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004bfe:	00004597          	auipc	a1,0x4
    80004c02:	ab258593          	addi	a1,a1,-1358 # 800086b0 <__func__.1+0x6a8>
    80004c06:	0023f517          	auipc	a0,0x23f
    80004c0a:	d3250513          	addi	a0,a0,-718 # 80243938 <ftable>
    80004c0e:	ffffc097          	auipc	ra,0xffffc
    80004c12:	1fa080e7          	jalr	506(ra) # 80000e08 <initlock>
}
    80004c16:	60a2                	ld	ra,8(sp)
    80004c18:	6402                	ld	s0,0(sp)
    80004c1a:	0141                	addi	sp,sp,16
    80004c1c:	8082                	ret

0000000080004c1e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004c1e:	1101                	addi	sp,sp,-32
    80004c20:	ec06                	sd	ra,24(sp)
    80004c22:	e822                	sd	s0,16(sp)
    80004c24:	e426                	sd	s1,8(sp)
    80004c26:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004c28:	0023f517          	auipc	a0,0x23f
    80004c2c:	d1050513          	addi	a0,a0,-752 # 80243938 <ftable>
    80004c30:	ffffc097          	auipc	ra,0xffffc
    80004c34:	268080e7          	jalr	616(ra) # 80000e98 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004c38:	0023f497          	auipc	s1,0x23f
    80004c3c:	d1848493          	addi	s1,s1,-744 # 80243950 <ftable+0x18>
    80004c40:	00240717          	auipc	a4,0x240
    80004c44:	cb070713          	addi	a4,a4,-848 # 802448f0 <disk>
    if(f->ref == 0){
    80004c48:	40dc                	lw	a5,4(s1)
    80004c4a:	cf99                	beqz	a5,80004c68 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004c4c:	02848493          	addi	s1,s1,40
    80004c50:	fee49ce3          	bne	s1,a4,80004c48 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004c54:	0023f517          	auipc	a0,0x23f
    80004c58:	ce450513          	addi	a0,a0,-796 # 80243938 <ftable>
    80004c5c:	ffffc097          	auipc	ra,0xffffc
    80004c60:	2f0080e7          	jalr	752(ra) # 80000f4c <release>
  return 0;
    80004c64:	4481                	li	s1,0
    80004c66:	a819                	j	80004c7c <filealloc+0x5e>
      f->ref = 1;
    80004c68:	4785                	li	a5,1
    80004c6a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004c6c:	0023f517          	auipc	a0,0x23f
    80004c70:	ccc50513          	addi	a0,a0,-820 # 80243938 <ftable>
    80004c74:	ffffc097          	auipc	ra,0xffffc
    80004c78:	2d8080e7          	jalr	728(ra) # 80000f4c <release>
}
    80004c7c:	8526                	mv	a0,s1
    80004c7e:	60e2                	ld	ra,24(sp)
    80004c80:	6442                	ld	s0,16(sp)
    80004c82:	64a2                	ld	s1,8(sp)
    80004c84:	6105                	addi	sp,sp,32
    80004c86:	8082                	ret

0000000080004c88 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004c88:	1101                	addi	sp,sp,-32
    80004c8a:	ec06                	sd	ra,24(sp)
    80004c8c:	e822                	sd	s0,16(sp)
    80004c8e:	e426                	sd	s1,8(sp)
    80004c90:	1000                	addi	s0,sp,32
    80004c92:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004c94:	0023f517          	auipc	a0,0x23f
    80004c98:	ca450513          	addi	a0,a0,-860 # 80243938 <ftable>
    80004c9c:	ffffc097          	auipc	ra,0xffffc
    80004ca0:	1fc080e7          	jalr	508(ra) # 80000e98 <acquire>
  if(f->ref < 1)
    80004ca4:	40dc                	lw	a5,4(s1)
    80004ca6:	02f05263          	blez	a5,80004cca <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004caa:	2785                	addiw	a5,a5,1
    80004cac:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004cae:	0023f517          	auipc	a0,0x23f
    80004cb2:	c8a50513          	addi	a0,a0,-886 # 80243938 <ftable>
    80004cb6:	ffffc097          	auipc	ra,0xffffc
    80004cba:	296080e7          	jalr	662(ra) # 80000f4c <release>
  return f;
}
    80004cbe:	8526                	mv	a0,s1
    80004cc0:	60e2                	ld	ra,24(sp)
    80004cc2:	6442                	ld	s0,16(sp)
    80004cc4:	64a2                	ld	s1,8(sp)
    80004cc6:	6105                	addi	sp,sp,32
    80004cc8:	8082                	ret
    panic("filedup");
    80004cca:	00004517          	auipc	a0,0x4
    80004cce:	9ee50513          	addi	a0,a0,-1554 # 800086b8 <__func__.1+0x6b0>
    80004cd2:	ffffc097          	auipc	ra,0xffffc
    80004cd6:	88e080e7          	jalr	-1906(ra) # 80000560 <panic>

0000000080004cda <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004cda:	7139                	addi	sp,sp,-64
    80004cdc:	fc06                	sd	ra,56(sp)
    80004cde:	f822                	sd	s0,48(sp)
    80004ce0:	f426                	sd	s1,40(sp)
    80004ce2:	0080                	addi	s0,sp,64
    80004ce4:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004ce6:	0023f517          	auipc	a0,0x23f
    80004cea:	c5250513          	addi	a0,a0,-942 # 80243938 <ftable>
    80004cee:	ffffc097          	auipc	ra,0xffffc
    80004cf2:	1aa080e7          	jalr	426(ra) # 80000e98 <acquire>
  if(f->ref < 1)
    80004cf6:	40dc                	lw	a5,4(s1)
    80004cf8:	04f05c63          	blez	a5,80004d50 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80004cfc:	37fd                	addiw	a5,a5,-1
    80004cfe:	0007871b          	sext.w	a4,a5
    80004d02:	c0dc                	sw	a5,4(s1)
    80004d04:	06e04263          	bgtz	a4,80004d68 <fileclose+0x8e>
    80004d08:	f04a                	sd	s2,32(sp)
    80004d0a:	ec4e                	sd	s3,24(sp)
    80004d0c:	e852                	sd	s4,16(sp)
    80004d0e:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004d10:	0004a903          	lw	s2,0(s1)
    80004d14:	0094ca83          	lbu	s5,9(s1)
    80004d18:	0104ba03          	ld	s4,16(s1)
    80004d1c:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004d20:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004d24:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004d28:	0023f517          	auipc	a0,0x23f
    80004d2c:	c1050513          	addi	a0,a0,-1008 # 80243938 <ftable>
    80004d30:	ffffc097          	auipc	ra,0xffffc
    80004d34:	21c080e7          	jalr	540(ra) # 80000f4c <release>

  if(ff.type == FD_PIPE){
    80004d38:	4785                	li	a5,1
    80004d3a:	04f90463          	beq	s2,a5,80004d82 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004d3e:	3979                	addiw	s2,s2,-2
    80004d40:	4785                	li	a5,1
    80004d42:	0527fb63          	bgeu	a5,s2,80004d98 <fileclose+0xbe>
    80004d46:	7902                	ld	s2,32(sp)
    80004d48:	69e2                	ld	s3,24(sp)
    80004d4a:	6a42                	ld	s4,16(sp)
    80004d4c:	6aa2                	ld	s5,8(sp)
    80004d4e:	a02d                	j	80004d78 <fileclose+0x9e>
    80004d50:	f04a                	sd	s2,32(sp)
    80004d52:	ec4e                	sd	s3,24(sp)
    80004d54:	e852                	sd	s4,16(sp)
    80004d56:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004d58:	00004517          	auipc	a0,0x4
    80004d5c:	96850513          	addi	a0,a0,-1688 # 800086c0 <__func__.1+0x6b8>
    80004d60:	ffffc097          	auipc	ra,0xffffc
    80004d64:	800080e7          	jalr	-2048(ra) # 80000560 <panic>
    release(&ftable.lock);
    80004d68:	0023f517          	auipc	a0,0x23f
    80004d6c:	bd050513          	addi	a0,a0,-1072 # 80243938 <ftable>
    80004d70:	ffffc097          	auipc	ra,0xffffc
    80004d74:	1dc080e7          	jalr	476(ra) # 80000f4c <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004d78:	70e2                	ld	ra,56(sp)
    80004d7a:	7442                	ld	s0,48(sp)
    80004d7c:	74a2                	ld	s1,40(sp)
    80004d7e:	6121                	addi	sp,sp,64
    80004d80:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004d82:	85d6                	mv	a1,s5
    80004d84:	8552                	mv	a0,s4
    80004d86:	00000097          	auipc	ra,0x0
    80004d8a:	3a2080e7          	jalr	930(ra) # 80005128 <pipeclose>
    80004d8e:	7902                	ld	s2,32(sp)
    80004d90:	69e2                	ld	s3,24(sp)
    80004d92:	6a42                	ld	s4,16(sp)
    80004d94:	6aa2                	ld	s5,8(sp)
    80004d96:	b7cd                	j	80004d78 <fileclose+0x9e>
    begin_op();
    80004d98:	00000097          	auipc	ra,0x0
    80004d9c:	a78080e7          	jalr	-1416(ra) # 80004810 <begin_op>
    iput(ff.ip);
    80004da0:	854e                	mv	a0,s3
    80004da2:	fffff097          	auipc	ra,0xfffff
    80004da6:	25e080e7          	jalr	606(ra) # 80004000 <iput>
    end_op();
    80004daa:	00000097          	auipc	ra,0x0
    80004dae:	ae0080e7          	jalr	-1312(ra) # 8000488a <end_op>
    80004db2:	7902                	ld	s2,32(sp)
    80004db4:	69e2                	ld	s3,24(sp)
    80004db6:	6a42                	ld	s4,16(sp)
    80004db8:	6aa2                	ld	s5,8(sp)
    80004dba:	bf7d                	j	80004d78 <fileclose+0x9e>

0000000080004dbc <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004dbc:	715d                	addi	sp,sp,-80
    80004dbe:	e486                	sd	ra,72(sp)
    80004dc0:	e0a2                	sd	s0,64(sp)
    80004dc2:	fc26                	sd	s1,56(sp)
    80004dc4:	f44e                	sd	s3,40(sp)
    80004dc6:	0880                	addi	s0,sp,80
    80004dc8:	84aa                	mv	s1,a0
    80004dca:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004dcc:	ffffd097          	auipc	ra,0xffffd
    80004dd0:	fc0080e7          	jalr	-64(ra) # 80001d8c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004dd4:	409c                	lw	a5,0(s1)
    80004dd6:	37f9                	addiw	a5,a5,-2
    80004dd8:	4705                	li	a4,1
    80004dda:	04f76863          	bltu	a4,a5,80004e2a <filestat+0x6e>
    80004dde:	f84a                	sd	s2,48(sp)
    80004de0:	892a                	mv	s2,a0
    ilock(f->ip);
    80004de2:	6c88                	ld	a0,24(s1)
    80004de4:	fffff097          	auipc	ra,0xfffff
    80004de8:	05e080e7          	jalr	94(ra) # 80003e42 <ilock>
    stati(f->ip, &st);
    80004dec:	fb840593          	addi	a1,s0,-72
    80004df0:	6c88                	ld	a0,24(s1)
    80004df2:	fffff097          	auipc	ra,0xfffff
    80004df6:	2de080e7          	jalr	734(ra) # 800040d0 <stati>
    iunlock(f->ip);
    80004dfa:	6c88                	ld	a0,24(s1)
    80004dfc:	fffff097          	auipc	ra,0xfffff
    80004e00:	10c080e7          	jalr	268(ra) # 80003f08 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004e04:	46e1                	li	a3,24
    80004e06:	fb840613          	addi	a2,s0,-72
    80004e0a:	85ce                	mv	a1,s3
    80004e0c:	05093503          	ld	a0,80(s2)
    80004e10:	ffffd097          	auipc	ra,0xffffd
    80004e14:	b20080e7          	jalr	-1248(ra) # 80001930 <copyout>
    80004e18:	41f5551b          	sraiw	a0,a0,0x1f
    80004e1c:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004e1e:	60a6                	ld	ra,72(sp)
    80004e20:	6406                	ld	s0,64(sp)
    80004e22:	74e2                	ld	s1,56(sp)
    80004e24:	79a2                	ld	s3,40(sp)
    80004e26:	6161                	addi	sp,sp,80
    80004e28:	8082                	ret
  return -1;
    80004e2a:	557d                	li	a0,-1
    80004e2c:	bfcd                	j	80004e1e <filestat+0x62>

0000000080004e2e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004e2e:	7179                	addi	sp,sp,-48
    80004e30:	f406                	sd	ra,40(sp)
    80004e32:	f022                	sd	s0,32(sp)
    80004e34:	e84a                	sd	s2,16(sp)
    80004e36:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004e38:	00854783          	lbu	a5,8(a0)
    80004e3c:	cbc5                	beqz	a5,80004eec <fileread+0xbe>
    80004e3e:	ec26                	sd	s1,24(sp)
    80004e40:	e44e                	sd	s3,8(sp)
    80004e42:	84aa                	mv	s1,a0
    80004e44:	89ae                	mv	s3,a1
    80004e46:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004e48:	411c                	lw	a5,0(a0)
    80004e4a:	4705                	li	a4,1
    80004e4c:	04e78963          	beq	a5,a4,80004e9e <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004e50:	470d                	li	a4,3
    80004e52:	04e78f63          	beq	a5,a4,80004eb0 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004e56:	4709                	li	a4,2
    80004e58:	08e79263          	bne	a5,a4,80004edc <fileread+0xae>
    ilock(f->ip);
    80004e5c:	6d08                	ld	a0,24(a0)
    80004e5e:	fffff097          	auipc	ra,0xfffff
    80004e62:	fe4080e7          	jalr	-28(ra) # 80003e42 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004e66:	874a                	mv	a4,s2
    80004e68:	5094                	lw	a3,32(s1)
    80004e6a:	864e                	mv	a2,s3
    80004e6c:	4585                	li	a1,1
    80004e6e:	6c88                	ld	a0,24(s1)
    80004e70:	fffff097          	auipc	ra,0xfffff
    80004e74:	28a080e7          	jalr	650(ra) # 800040fa <readi>
    80004e78:	892a                	mv	s2,a0
    80004e7a:	00a05563          	blez	a0,80004e84 <fileread+0x56>
      f->off += r;
    80004e7e:	509c                	lw	a5,32(s1)
    80004e80:	9fa9                	addw	a5,a5,a0
    80004e82:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004e84:	6c88                	ld	a0,24(s1)
    80004e86:	fffff097          	auipc	ra,0xfffff
    80004e8a:	082080e7          	jalr	130(ra) # 80003f08 <iunlock>
    80004e8e:	64e2                	ld	s1,24(sp)
    80004e90:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004e92:	854a                	mv	a0,s2
    80004e94:	70a2                	ld	ra,40(sp)
    80004e96:	7402                	ld	s0,32(sp)
    80004e98:	6942                	ld	s2,16(sp)
    80004e9a:	6145                	addi	sp,sp,48
    80004e9c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004e9e:	6908                	ld	a0,16(a0)
    80004ea0:	00000097          	auipc	ra,0x0
    80004ea4:	400080e7          	jalr	1024(ra) # 800052a0 <piperead>
    80004ea8:	892a                	mv	s2,a0
    80004eaa:	64e2                	ld	s1,24(sp)
    80004eac:	69a2                	ld	s3,8(sp)
    80004eae:	b7d5                	j	80004e92 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004eb0:	02451783          	lh	a5,36(a0)
    80004eb4:	03079693          	slli	a3,a5,0x30
    80004eb8:	92c1                	srli	a3,a3,0x30
    80004eba:	4725                	li	a4,9
    80004ebc:	02d76a63          	bltu	a4,a3,80004ef0 <fileread+0xc2>
    80004ec0:	0792                	slli	a5,a5,0x4
    80004ec2:	0023f717          	auipc	a4,0x23f
    80004ec6:	9d670713          	addi	a4,a4,-1578 # 80243898 <devsw>
    80004eca:	97ba                	add	a5,a5,a4
    80004ecc:	639c                	ld	a5,0(a5)
    80004ece:	c78d                	beqz	a5,80004ef8 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80004ed0:	4505                	li	a0,1
    80004ed2:	9782                	jalr	a5
    80004ed4:	892a                	mv	s2,a0
    80004ed6:	64e2                	ld	s1,24(sp)
    80004ed8:	69a2                	ld	s3,8(sp)
    80004eda:	bf65                	j	80004e92 <fileread+0x64>
    panic("fileread");
    80004edc:	00003517          	auipc	a0,0x3
    80004ee0:	7f450513          	addi	a0,a0,2036 # 800086d0 <__func__.1+0x6c8>
    80004ee4:	ffffb097          	auipc	ra,0xffffb
    80004ee8:	67c080e7          	jalr	1660(ra) # 80000560 <panic>
    return -1;
    80004eec:	597d                	li	s2,-1
    80004eee:	b755                	j	80004e92 <fileread+0x64>
      return -1;
    80004ef0:	597d                	li	s2,-1
    80004ef2:	64e2                	ld	s1,24(sp)
    80004ef4:	69a2                	ld	s3,8(sp)
    80004ef6:	bf71                	j	80004e92 <fileread+0x64>
    80004ef8:	597d                	li	s2,-1
    80004efa:	64e2                	ld	s1,24(sp)
    80004efc:	69a2                	ld	s3,8(sp)
    80004efe:	bf51                	j	80004e92 <fileread+0x64>

0000000080004f00 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004f00:	00954783          	lbu	a5,9(a0)
    80004f04:	12078963          	beqz	a5,80005036 <filewrite+0x136>
{
    80004f08:	715d                	addi	sp,sp,-80
    80004f0a:	e486                	sd	ra,72(sp)
    80004f0c:	e0a2                	sd	s0,64(sp)
    80004f0e:	f84a                	sd	s2,48(sp)
    80004f10:	f052                	sd	s4,32(sp)
    80004f12:	e85a                	sd	s6,16(sp)
    80004f14:	0880                	addi	s0,sp,80
    80004f16:	892a                	mv	s2,a0
    80004f18:	8b2e                	mv	s6,a1
    80004f1a:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004f1c:	411c                	lw	a5,0(a0)
    80004f1e:	4705                	li	a4,1
    80004f20:	02e78763          	beq	a5,a4,80004f4e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004f24:	470d                	li	a4,3
    80004f26:	02e78a63          	beq	a5,a4,80004f5a <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004f2a:	4709                	li	a4,2
    80004f2c:	0ee79863          	bne	a5,a4,8000501c <filewrite+0x11c>
    80004f30:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004f32:	0cc05463          	blez	a2,80004ffa <filewrite+0xfa>
    80004f36:	fc26                	sd	s1,56(sp)
    80004f38:	ec56                	sd	s5,24(sp)
    80004f3a:	e45e                	sd	s7,8(sp)
    80004f3c:	e062                	sd	s8,0(sp)
    int i = 0;
    80004f3e:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80004f40:	6b85                	lui	s7,0x1
    80004f42:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004f46:	6c05                	lui	s8,0x1
    80004f48:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004f4c:	a851                	j	80004fe0 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80004f4e:	6908                	ld	a0,16(a0)
    80004f50:	00000097          	auipc	ra,0x0
    80004f54:	248080e7          	jalr	584(ra) # 80005198 <pipewrite>
    80004f58:	a85d                	j	8000500e <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004f5a:	02451783          	lh	a5,36(a0)
    80004f5e:	03079693          	slli	a3,a5,0x30
    80004f62:	92c1                	srli	a3,a3,0x30
    80004f64:	4725                	li	a4,9
    80004f66:	0cd76a63          	bltu	a4,a3,8000503a <filewrite+0x13a>
    80004f6a:	0792                	slli	a5,a5,0x4
    80004f6c:	0023f717          	auipc	a4,0x23f
    80004f70:	92c70713          	addi	a4,a4,-1748 # 80243898 <devsw>
    80004f74:	97ba                	add	a5,a5,a4
    80004f76:	679c                	ld	a5,8(a5)
    80004f78:	c3f9                	beqz	a5,8000503e <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80004f7a:	4505                	li	a0,1
    80004f7c:	9782                	jalr	a5
    80004f7e:	a841                	j	8000500e <filewrite+0x10e>
      if(n1 > max)
    80004f80:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80004f84:	00000097          	auipc	ra,0x0
    80004f88:	88c080e7          	jalr	-1908(ra) # 80004810 <begin_op>
      ilock(f->ip);
    80004f8c:	01893503          	ld	a0,24(s2)
    80004f90:	fffff097          	auipc	ra,0xfffff
    80004f94:	eb2080e7          	jalr	-334(ra) # 80003e42 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004f98:	8756                	mv	a4,s5
    80004f9a:	02092683          	lw	a3,32(s2)
    80004f9e:	01698633          	add	a2,s3,s6
    80004fa2:	4585                	li	a1,1
    80004fa4:	01893503          	ld	a0,24(s2)
    80004fa8:	fffff097          	auipc	ra,0xfffff
    80004fac:	262080e7          	jalr	610(ra) # 8000420a <writei>
    80004fb0:	84aa                	mv	s1,a0
    80004fb2:	00a05763          	blez	a0,80004fc0 <filewrite+0xc0>
        f->off += r;
    80004fb6:	02092783          	lw	a5,32(s2)
    80004fba:	9fa9                	addw	a5,a5,a0
    80004fbc:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004fc0:	01893503          	ld	a0,24(s2)
    80004fc4:	fffff097          	auipc	ra,0xfffff
    80004fc8:	f44080e7          	jalr	-188(ra) # 80003f08 <iunlock>
      end_op();
    80004fcc:	00000097          	auipc	ra,0x0
    80004fd0:	8be080e7          	jalr	-1858(ra) # 8000488a <end_op>

      if(r != n1){
    80004fd4:	029a9563          	bne	s5,s1,80004ffe <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80004fd8:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004fdc:	0149da63          	bge	s3,s4,80004ff0 <filewrite+0xf0>
      int n1 = n - i;
    80004fe0:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80004fe4:	0004879b          	sext.w	a5,s1
    80004fe8:	f8fbdce3          	bge	s7,a5,80004f80 <filewrite+0x80>
    80004fec:	84e2                	mv	s1,s8
    80004fee:	bf49                	j	80004f80 <filewrite+0x80>
    80004ff0:	74e2                	ld	s1,56(sp)
    80004ff2:	6ae2                	ld	s5,24(sp)
    80004ff4:	6ba2                	ld	s7,8(sp)
    80004ff6:	6c02                	ld	s8,0(sp)
    80004ff8:	a039                	j	80005006 <filewrite+0x106>
    int i = 0;
    80004ffa:	4981                	li	s3,0
    80004ffc:	a029                	j	80005006 <filewrite+0x106>
    80004ffe:	74e2                	ld	s1,56(sp)
    80005000:	6ae2                	ld	s5,24(sp)
    80005002:	6ba2                	ld	s7,8(sp)
    80005004:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80005006:	033a1e63          	bne	s4,s3,80005042 <filewrite+0x142>
    8000500a:	8552                	mv	a0,s4
    8000500c:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000500e:	60a6                	ld	ra,72(sp)
    80005010:	6406                	ld	s0,64(sp)
    80005012:	7942                	ld	s2,48(sp)
    80005014:	7a02                	ld	s4,32(sp)
    80005016:	6b42                	ld	s6,16(sp)
    80005018:	6161                	addi	sp,sp,80
    8000501a:	8082                	ret
    8000501c:	fc26                	sd	s1,56(sp)
    8000501e:	f44e                	sd	s3,40(sp)
    80005020:	ec56                	sd	s5,24(sp)
    80005022:	e45e                	sd	s7,8(sp)
    80005024:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80005026:	00003517          	auipc	a0,0x3
    8000502a:	6ba50513          	addi	a0,a0,1722 # 800086e0 <__func__.1+0x6d8>
    8000502e:	ffffb097          	auipc	ra,0xffffb
    80005032:	532080e7          	jalr	1330(ra) # 80000560 <panic>
    return -1;
    80005036:	557d                	li	a0,-1
}
    80005038:	8082                	ret
      return -1;
    8000503a:	557d                	li	a0,-1
    8000503c:	bfc9                	j	8000500e <filewrite+0x10e>
    8000503e:	557d                	li	a0,-1
    80005040:	b7f9                	j	8000500e <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80005042:	557d                	li	a0,-1
    80005044:	79a2                	ld	s3,40(sp)
    80005046:	b7e1                	j	8000500e <filewrite+0x10e>

0000000080005048 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80005048:	7179                	addi	sp,sp,-48
    8000504a:	f406                	sd	ra,40(sp)
    8000504c:	f022                	sd	s0,32(sp)
    8000504e:	ec26                	sd	s1,24(sp)
    80005050:	e052                	sd	s4,0(sp)
    80005052:	1800                	addi	s0,sp,48
    80005054:	84aa                	mv	s1,a0
    80005056:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80005058:	0005b023          	sd	zero,0(a1)
    8000505c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80005060:	00000097          	auipc	ra,0x0
    80005064:	bbe080e7          	jalr	-1090(ra) # 80004c1e <filealloc>
    80005068:	e088                	sd	a0,0(s1)
    8000506a:	cd49                	beqz	a0,80005104 <pipealloc+0xbc>
    8000506c:	00000097          	auipc	ra,0x0
    80005070:	bb2080e7          	jalr	-1102(ra) # 80004c1e <filealloc>
    80005074:	00aa3023          	sd	a0,0(s4)
    80005078:	c141                	beqz	a0,800050f8 <pipealloc+0xb0>
    8000507a:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000507c:	ffffc097          	auipc	ra,0xffffc
    80005080:	ba6080e7          	jalr	-1114(ra) # 80000c22 <kalloc>
    80005084:	892a                	mv	s2,a0
    80005086:	c13d                	beqz	a0,800050ec <pipealloc+0xa4>
    80005088:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    8000508a:	4985                	li	s3,1
    8000508c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80005090:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80005094:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80005098:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000509c:	00003597          	auipc	a1,0x3
    800050a0:	65458593          	addi	a1,a1,1620 # 800086f0 <__func__.1+0x6e8>
    800050a4:	ffffc097          	auipc	ra,0xffffc
    800050a8:	d64080e7          	jalr	-668(ra) # 80000e08 <initlock>
  (*f0)->type = FD_PIPE;
    800050ac:	609c                	ld	a5,0(s1)
    800050ae:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800050b2:	609c                	ld	a5,0(s1)
    800050b4:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800050b8:	609c                	ld	a5,0(s1)
    800050ba:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800050be:	609c                	ld	a5,0(s1)
    800050c0:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800050c4:	000a3783          	ld	a5,0(s4)
    800050c8:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800050cc:	000a3783          	ld	a5,0(s4)
    800050d0:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800050d4:	000a3783          	ld	a5,0(s4)
    800050d8:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800050dc:	000a3783          	ld	a5,0(s4)
    800050e0:	0127b823          	sd	s2,16(a5)
  return 0;
    800050e4:	4501                	li	a0,0
    800050e6:	6942                	ld	s2,16(sp)
    800050e8:	69a2                	ld	s3,8(sp)
    800050ea:	a03d                	j	80005118 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800050ec:	6088                	ld	a0,0(s1)
    800050ee:	c119                	beqz	a0,800050f4 <pipealloc+0xac>
    800050f0:	6942                	ld	s2,16(sp)
    800050f2:	a029                	j	800050fc <pipealloc+0xb4>
    800050f4:	6942                	ld	s2,16(sp)
    800050f6:	a039                	j	80005104 <pipealloc+0xbc>
    800050f8:	6088                	ld	a0,0(s1)
    800050fa:	c50d                	beqz	a0,80005124 <pipealloc+0xdc>
    fileclose(*f0);
    800050fc:	00000097          	auipc	ra,0x0
    80005100:	bde080e7          	jalr	-1058(ra) # 80004cda <fileclose>
  if(*f1)
    80005104:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80005108:	557d                	li	a0,-1
  if(*f1)
    8000510a:	c799                	beqz	a5,80005118 <pipealloc+0xd0>
    fileclose(*f1);
    8000510c:	853e                	mv	a0,a5
    8000510e:	00000097          	auipc	ra,0x0
    80005112:	bcc080e7          	jalr	-1076(ra) # 80004cda <fileclose>
  return -1;
    80005116:	557d                	li	a0,-1
}
    80005118:	70a2                	ld	ra,40(sp)
    8000511a:	7402                	ld	s0,32(sp)
    8000511c:	64e2                	ld	s1,24(sp)
    8000511e:	6a02                	ld	s4,0(sp)
    80005120:	6145                	addi	sp,sp,48
    80005122:	8082                	ret
  return -1;
    80005124:	557d                	li	a0,-1
    80005126:	bfcd                	j	80005118 <pipealloc+0xd0>

0000000080005128 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80005128:	1101                	addi	sp,sp,-32
    8000512a:	ec06                	sd	ra,24(sp)
    8000512c:	e822                	sd	s0,16(sp)
    8000512e:	e426                	sd	s1,8(sp)
    80005130:	e04a                	sd	s2,0(sp)
    80005132:	1000                	addi	s0,sp,32
    80005134:	84aa                	mv	s1,a0
    80005136:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80005138:	ffffc097          	auipc	ra,0xffffc
    8000513c:	d60080e7          	jalr	-672(ra) # 80000e98 <acquire>
  if(writable){
    80005140:	02090d63          	beqz	s2,8000517a <pipeclose+0x52>
    pi->writeopen = 0;
    80005144:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80005148:	21848513          	addi	a0,s1,536
    8000514c:	ffffd097          	auipc	ra,0xffffd
    80005150:	456080e7          	jalr	1110(ra) # 800025a2 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80005154:	2204b783          	ld	a5,544(s1)
    80005158:	eb95                	bnez	a5,8000518c <pipeclose+0x64>
    release(&pi->lock);
    8000515a:	8526                	mv	a0,s1
    8000515c:	ffffc097          	auipc	ra,0xffffc
    80005160:	df0080e7          	jalr	-528(ra) # 80000f4c <release>
    kfree((char*)pi);
    80005164:	8526                	mv	a0,s1
    80005166:	ffffc097          	auipc	ra,0xffffc
    8000516a:	8f6080e7          	jalr	-1802(ra) # 80000a5c <kfree>
  } else
    release(&pi->lock);
}
    8000516e:	60e2                	ld	ra,24(sp)
    80005170:	6442                	ld	s0,16(sp)
    80005172:	64a2                	ld	s1,8(sp)
    80005174:	6902                	ld	s2,0(sp)
    80005176:	6105                	addi	sp,sp,32
    80005178:	8082                	ret
    pi->readopen = 0;
    8000517a:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000517e:	21c48513          	addi	a0,s1,540
    80005182:	ffffd097          	auipc	ra,0xffffd
    80005186:	420080e7          	jalr	1056(ra) # 800025a2 <wakeup>
    8000518a:	b7e9                	j	80005154 <pipeclose+0x2c>
    release(&pi->lock);
    8000518c:	8526                	mv	a0,s1
    8000518e:	ffffc097          	auipc	ra,0xffffc
    80005192:	dbe080e7          	jalr	-578(ra) # 80000f4c <release>
}
    80005196:	bfe1                	j	8000516e <pipeclose+0x46>

0000000080005198 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80005198:	711d                	addi	sp,sp,-96
    8000519a:	ec86                	sd	ra,88(sp)
    8000519c:	e8a2                	sd	s0,80(sp)
    8000519e:	e4a6                	sd	s1,72(sp)
    800051a0:	e0ca                	sd	s2,64(sp)
    800051a2:	fc4e                	sd	s3,56(sp)
    800051a4:	f852                	sd	s4,48(sp)
    800051a6:	f456                	sd	s5,40(sp)
    800051a8:	1080                	addi	s0,sp,96
    800051aa:	84aa                	mv	s1,a0
    800051ac:	8aae                	mv	s5,a1
    800051ae:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800051b0:	ffffd097          	auipc	ra,0xffffd
    800051b4:	bdc080e7          	jalr	-1060(ra) # 80001d8c <myproc>
    800051b8:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800051ba:	8526                	mv	a0,s1
    800051bc:	ffffc097          	auipc	ra,0xffffc
    800051c0:	cdc080e7          	jalr	-804(ra) # 80000e98 <acquire>
  while(i < n){
    800051c4:	0d405863          	blez	s4,80005294 <pipewrite+0xfc>
    800051c8:	f05a                	sd	s6,32(sp)
    800051ca:	ec5e                	sd	s7,24(sp)
    800051cc:	e862                	sd	s8,16(sp)
  int i = 0;
    800051ce:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800051d0:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800051d2:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800051d6:	21c48b93          	addi	s7,s1,540
    800051da:	a089                	j	8000521c <pipewrite+0x84>
      release(&pi->lock);
    800051dc:	8526                	mv	a0,s1
    800051de:	ffffc097          	auipc	ra,0xffffc
    800051e2:	d6e080e7          	jalr	-658(ra) # 80000f4c <release>
      return -1;
    800051e6:	597d                	li	s2,-1
    800051e8:	7b02                	ld	s6,32(sp)
    800051ea:	6be2                	ld	s7,24(sp)
    800051ec:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800051ee:	854a                	mv	a0,s2
    800051f0:	60e6                	ld	ra,88(sp)
    800051f2:	6446                	ld	s0,80(sp)
    800051f4:	64a6                	ld	s1,72(sp)
    800051f6:	6906                	ld	s2,64(sp)
    800051f8:	79e2                	ld	s3,56(sp)
    800051fa:	7a42                	ld	s4,48(sp)
    800051fc:	7aa2                	ld	s5,40(sp)
    800051fe:	6125                	addi	sp,sp,96
    80005200:	8082                	ret
      wakeup(&pi->nread);
    80005202:	8562                	mv	a0,s8
    80005204:	ffffd097          	auipc	ra,0xffffd
    80005208:	39e080e7          	jalr	926(ra) # 800025a2 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000520c:	85a6                	mv	a1,s1
    8000520e:	855e                	mv	a0,s7
    80005210:	ffffd097          	auipc	ra,0xffffd
    80005214:	32e080e7          	jalr	814(ra) # 8000253e <sleep>
  while(i < n){
    80005218:	05495f63          	bge	s2,s4,80005276 <pipewrite+0xde>
    if(pi->readopen == 0 || killed(pr)){
    8000521c:	2204a783          	lw	a5,544(s1)
    80005220:	dfd5                	beqz	a5,800051dc <pipewrite+0x44>
    80005222:	854e                	mv	a0,s3
    80005224:	ffffd097          	auipc	ra,0xffffd
    80005228:	5f0080e7          	jalr	1520(ra) # 80002814 <killed>
    8000522c:	f945                	bnez	a0,800051dc <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000522e:	2184a783          	lw	a5,536(s1)
    80005232:	21c4a703          	lw	a4,540(s1)
    80005236:	2007879b          	addiw	a5,a5,512
    8000523a:	fcf704e3          	beq	a4,a5,80005202 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000523e:	4685                	li	a3,1
    80005240:	01590633          	add	a2,s2,s5
    80005244:	faf40593          	addi	a1,s0,-81
    80005248:	0509b503          	ld	a0,80(s3)
    8000524c:	ffffc097          	auipc	ra,0xffffc
    80005250:	770080e7          	jalr	1904(ra) # 800019bc <copyin>
    80005254:	05650263          	beq	a0,s6,80005298 <pipewrite+0x100>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80005258:	21c4a783          	lw	a5,540(s1)
    8000525c:	0017871b          	addiw	a4,a5,1
    80005260:	20e4ae23          	sw	a4,540(s1)
    80005264:	1ff7f793          	andi	a5,a5,511
    80005268:	97a6                	add	a5,a5,s1
    8000526a:	faf44703          	lbu	a4,-81(s0)
    8000526e:	00e78c23          	sb	a4,24(a5)
      i++;
    80005272:	2905                	addiw	s2,s2,1
    80005274:	b755                	j	80005218 <pipewrite+0x80>
    80005276:	7b02                	ld	s6,32(sp)
    80005278:	6be2                	ld	s7,24(sp)
    8000527a:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    8000527c:	21848513          	addi	a0,s1,536
    80005280:	ffffd097          	auipc	ra,0xffffd
    80005284:	322080e7          	jalr	802(ra) # 800025a2 <wakeup>
  release(&pi->lock);
    80005288:	8526                	mv	a0,s1
    8000528a:	ffffc097          	auipc	ra,0xffffc
    8000528e:	cc2080e7          	jalr	-830(ra) # 80000f4c <release>
  return i;
    80005292:	bfb1                	j	800051ee <pipewrite+0x56>
  int i = 0;
    80005294:	4901                	li	s2,0
    80005296:	b7dd                	j	8000527c <pipewrite+0xe4>
    80005298:	7b02                	ld	s6,32(sp)
    8000529a:	6be2                	ld	s7,24(sp)
    8000529c:	6c42                	ld	s8,16(sp)
    8000529e:	bff9                	j	8000527c <pipewrite+0xe4>

00000000800052a0 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800052a0:	715d                	addi	sp,sp,-80
    800052a2:	e486                	sd	ra,72(sp)
    800052a4:	e0a2                	sd	s0,64(sp)
    800052a6:	fc26                	sd	s1,56(sp)
    800052a8:	f84a                	sd	s2,48(sp)
    800052aa:	f44e                	sd	s3,40(sp)
    800052ac:	f052                	sd	s4,32(sp)
    800052ae:	ec56                	sd	s5,24(sp)
    800052b0:	0880                	addi	s0,sp,80
    800052b2:	84aa                	mv	s1,a0
    800052b4:	892e                	mv	s2,a1
    800052b6:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800052b8:	ffffd097          	auipc	ra,0xffffd
    800052bc:	ad4080e7          	jalr	-1324(ra) # 80001d8c <myproc>
    800052c0:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800052c2:	8526                	mv	a0,s1
    800052c4:	ffffc097          	auipc	ra,0xffffc
    800052c8:	bd4080e7          	jalr	-1068(ra) # 80000e98 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800052cc:	2184a703          	lw	a4,536(s1)
    800052d0:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800052d4:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800052d8:	02f71963          	bne	a4,a5,8000530a <piperead+0x6a>
    800052dc:	2244a783          	lw	a5,548(s1)
    800052e0:	cf95                	beqz	a5,8000531c <piperead+0x7c>
    if(killed(pr)){
    800052e2:	8552                	mv	a0,s4
    800052e4:	ffffd097          	auipc	ra,0xffffd
    800052e8:	530080e7          	jalr	1328(ra) # 80002814 <killed>
    800052ec:	e10d                	bnez	a0,8000530e <piperead+0x6e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800052ee:	85a6                	mv	a1,s1
    800052f0:	854e                	mv	a0,s3
    800052f2:	ffffd097          	auipc	ra,0xffffd
    800052f6:	24c080e7          	jalr	588(ra) # 8000253e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800052fa:	2184a703          	lw	a4,536(s1)
    800052fe:	21c4a783          	lw	a5,540(s1)
    80005302:	fcf70de3          	beq	a4,a5,800052dc <piperead+0x3c>
    80005306:	e85a                	sd	s6,16(sp)
    80005308:	a819                	j	8000531e <piperead+0x7e>
    8000530a:	e85a                	sd	s6,16(sp)
    8000530c:	a809                	j	8000531e <piperead+0x7e>
      release(&pi->lock);
    8000530e:	8526                	mv	a0,s1
    80005310:	ffffc097          	auipc	ra,0xffffc
    80005314:	c3c080e7          	jalr	-964(ra) # 80000f4c <release>
      return -1;
    80005318:	59fd                	li	s3,-1
    8000531a:	a0a5                	j	80005382 <piperead+0xe2>
    8000531c:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000531e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005320:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005322:	05505463          	blez	s5,8000536a <piperead+0xca>
    if(pi->nread == pi->nwrite)
    80005326:	2184a783          	lw	a5,536(s1)
    8000532a:	21c4a703          	lw	a4,540(s1)
    8000532e:	02f70e63          	beq	a4,a5,8000536a <piperead+0xca>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80005332:	0017871b          	addiw	a4,a5,1
    80005336:	20e4ac23          	sw	a4,536(s1)
    8000533a:	1ff7f793          	andi	a5,a5,511
    8000533e:	97a6                	add	a5,a5,s1
    80005340:	0187c783          	lbu	a5,24(a5)
    80005344:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005348:	4685                	li	a3,1
    8000534a:	fbf40613          	addi	a2,s0,-65
    8000534e:	85ca                	mv	a1,s2
    80005350:	050a3503          	ld	a0,80(s4)
    80005354:	ffffc097          	auipc	ra,0xffffc
    80005358:	5dc080e7          	jalr	1500(ra) # 80001930 <copyout>
    8000535c:	01650763          	beq	a0,s6,8000536a <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005360:	2985                	addiw	s3,s3,1
    80005362:	0905                	addi	s2,s2,1
    80005364:	fd3a91e3          	bne	s5,s3,80005326 <piperead+0x86>
    80005368:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000536a:	21c48513          	addi	a0,s1,540
    8000536e:	ffffd097          	auipc	ra,0xffffd
    80005372:	234080e7          	jalr	564(ra) # 800025a2 <wakeup>
  release(&pi->lock);
    80005376:	8526                	mv	a0,s1
    80005378:	ffffc097          	auipc	ra,0xffffc
    8000537c:	bd4080e7          	jalr	-1068(ra) # 80000f4c <release>
    80005380:	6b42                	ld	s6,16(sp)
  return i;
}
    80005382:	854e                	mv	a0,s3
    80005384:	60a6                	ld	ra,72(sp)
    80005386:	6406                	ld	s0,64(sp)
    80005388:	74e2                	ld	s1,56(sp)
    8000538a:	7942                	ld	s2,48(sp)
    8000538c:	79a2                	ld	s3,40(sp)
    8000538e:	7a02                	ld	s4,32(sp)
    80005390:	6ae2                	ld	s5,24(sp)
    80005392:	6161                	addi	sp,sp,80
    80005394:	8082                	ret

0000000080005396 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80005396:	1141                	addi	sp,sp,-16
    80005398:	e422                	sd	s0,8(sp)
    8000539a:	0800                	addi	s0,sp,16
    8000539c:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000539e:	8905                	andi	a0,a0,1
    800053a0:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800053a2:	8b89                	andi	a5,a5,2
    800053a4:	c399                	beqz	a5,800053aa <flags2perm+0x14>
      perm |= PTE_W;
    800053a6:	00456513          	ori	a0,a0,4
    return perm;
}
    800053aa:	6422                	ld	s0,8(sp)
    800053ac:	0141                	addi	sp,sp,16
    800053ae:	8082                	ret

00000000800053b0 <exec>:

int
exec(char *path, char **argv)
{
    800053b0:	df010113          	addi	sp,sp,-528
    800053b4:	20113423          	sd	ra,520(sp)
    800053b8:	20813023          	sd	s0,512(sp)
    800053bc:	ffa6                	sd	s1,504(sp)
    800053be:	fbca                	sd	s2,496(sp)
    800053c0:	0c00                	addi	s0,sp,528
    800053c2:	892a                	mv	s2,a0
    800053c4:	dea43c23          	sd	a0,-520(s0)
    800053c8:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800053cc:	ffffd097          	auipc	ra,0xffffd
    800053d0:	9c0080e7          	jalr	-1600(ra) # 80001d8c <myproc>
    800053d4:	84aa                	mv	s1,a0

  begin_op();
    800053d6:	fffff097          	auipc	ra,0xfffff
    800053da:	43a080e7          	jalr	1082(ra) # 80004810 <begin_op>

  if((ip = namei(path)) == 0){
    800053de:	854a                	mv	a0,s2
    800053e0:	fffff097          	auipc	ra,0xfffff
    800053e4:	230080e7          	jalr	560(ra) # 80004610 <namei>
    800053e8:	c135                	beqz	a0,8000544c <exec+0x9c>
    800053ea:	f3d2                	sd	s4,480(sp)
    800053ec:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800053ee:	fffff097          	auipc	ra,0xfffff
    800053f2:	a54080e7          	jalr	-1452(ra) # 80003e42 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800053f6:	04000713          	li	a4,64
    800053fa:	4681                	li	a3,0
    800053fc:	e5040613          	addi	a2,s0,-432
    80005400:	4581                	li	a1,0
    80005402:	8552                	mv	a0,s4
    80005404:	fffff097          	auipc	ra,0xfffff
    80005408:	cf6080e7          	jalr	-778(ra) # 800040fa <readi>
    8000540c:	04000793          	li	a5,64
    80005410:	00f51a63          	bne	a0,a5,80005424 <exec+0x74>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80005414:	e5042703          	lw	a4,-432(s0)
    80005418:	464c47b7          	lui	a5,0x464c4
    8000541c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005420:	02f70c63          	beq	a4,a5,80005458 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80005424:	8552                	mv	a0,s4
    80005426:	fffff097          	auipc	ra,0xfffff
    8000542a:	c82080e7          	jalr	-894(ra) # 800040a8 <iunlockput>
    end_op();
    8000542e:	fffff097          	auipc	ra,0xfffff
    80005432:	45c080e7          	jalr	1116(ra) # 8000488a <end_op>
  }
  return -1;
    80005436:	557d                	li	a0,-1
    80005438:	7a1e                	ld	s4,480(sp)
}
    8000543a:	20813083          	ld	ra,520(sp)
    8000543e:	20013403          	ld	s0,512(sp)
    80005442:	74fe                	ld	s1,504(sp)
    80005444:	795e                	ld	s2,496(sp)
    80005446:	21010113          	addi	sp,sp,528
    8000544a:	8082                	ret
    end_op();
    8000544c:	fffff097          	auipc	ra,0xfffff
    80005450:	43e080e7          	jalr	1086(ra) # 8000488a <end_op>
    return -1;
    80005454:	557d                	li	a0,-1
    80005456:	b7d5                	j	8000543a <exec+0x8a>
    80005458:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    8000545a:	8526                	mv	a0,s1
    8000545c:	ffffd097          	auipc	ra,0xffffd
    80005460:	9f4080e7          	jalr	-1548(ra) # 80001e50 <proc_pagetable>
    80005464:	8b2a                	mv	s6,a0
    80005466:	30050f63          	beqz	a0,80005784 <exec+0x3d4>
    8000546a:	f7ce                	sd	s3,488(sp)
    8000546c:	efd6                	sd	s5,472(sp)
    8000546e:	e7de                	sd	s7,456(sp)
    80005470:	e3e2                	sd	s8,448(sp)
    80005472:	ff66                	sd	s9,440(sp)
    80005474:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005476:	e7042d03          	lw	s10,-400(s0)
    8000547a:	e8845783          	lhu	a5,-376(s0)
    8000547e:	14078d63          	beqz	a5,800055d8 <exec+0x228>
    80005482:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005484:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005486:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80005488:	6c85                	lui	s9,0x1
    8000548a:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000548e:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80005492:	6a85                	lui	s5,0x1
    80005494:	a0b5                	j	80005500 <exec+0x150>
      panic("loadseg: address should exist");
    80005496:	00003517          	auipc	a0,0x3
    8000549a:	26250513          	addi	a0,a0,610 # 800086f8 <__func__.1+0x6f0>
    8000549e:	ffffb097          	auipc	ra,0xffffb
    800054a2:	0c2080e7          	jalr	194(ra) # 80000560 <panic>
    if(sz - i < PGSIZE)
    800054a6:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800054a8:	8726                	mv	a4,s1
    800054aa:	012c06bb          	addw	a3,s8,s2
    800054ae:	4581                	li	a1,0
    800054b0:	8552                	mv	a0,s4
    800054b2:	fffff097          	auipc	ra,0xfffff
    800054b6:	c48080e7          	jalr	-952(ra) # 800040fa <readi>
    800054ba:	2501                	sext.w	a0,a0
    800054bc:	28a49863          	bne	s1,a0,8000574c <exec+0x39c>
  for(i = 0; i < sz; i += PGSIZE){
    800054c0:	012a893b          	addw	s2,s5,s2
    800054c4:	03397563          	bgeu	s2,s3,800054ee <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    800054c8:	02091593          	slli	a1,s2,0x20
    800054cc:	9181                	srli	a1,a1,0x20
    800054ce:	95de                	add	a1,a1,s7
    800054d0:	855a                	mv	a0,s6
    800054d2:	ffffc097          	auipc	ra,0xffffc
    800054d6:	e44080e7          	jalr	-444(ra) # 80001316 <walkaddr>
    800054da:	862a                	mv	a2,a0
    if(pa == 0)
    800054dc:	dd4d                	beqz	a0,80005496 <exec+0xe6>
    if(sz - i < PGSIZE)
    800054de:	412984bb          	subw	s1,s3,s2
    800054e2:	0004879b          	sext.w	a5,s1
    800054e6:	fcfcf0e3          	bgeu	s9,a5,800054a6 <exec+0xf6>
    800054ea:	84d6                	mv	s1,s5
    800054ec:	bf6d                	j	800054a6 <exec+0xf6>
    sz = sz1;
    800054ee:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800054f2:	2d85                	addiw	s11,s11,1
    800054f4:	038d0d1b          	addiw	s10,s10,56
    800054f8:	e8845783          	lhu	a5,-376(s0)
    800054fc:	08fdd663          	bge	s11,a5,80005588 <exec+0x1d8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005500:	2d01                	sext.w	s10,s10
    80005502:	03800713          	li	a4,56
    80005506:	86ea                	mv	a3,s10
    80005508:	e1840613          	addi	a2,s0,-488
    8000550c:	4581                	li	a1,0
    8000550e:	8552                	mv	a0,s4
    80005510:	fffff097          	auipc	ra,0xfffff
    80005514:	bea080e7          	jalr	-1046(ra) # 800040fa <readi>
    80005518:	03800793          	li	a5,56
    8000551c:	20f51063          	bne	a0,a5,8000571c <exec+0x36c>
    if(ph.type != ELF_PROG_LOAD)
    80005520:	e1842783          	lw	a5,-488(s0)
    80005524:	4705                	li	a4,1
    80005526:	fce796e3          	bne	a5,a4,800054f2 <exec+0x142>
    if(ph.memsz < ph.filesz)
    8000552a:	e4043483          	ld	s1,-448(s0)
    8000552e:	e3843783          	ld	a5,-456(s0)
    80005532:	1ef4e963          	bltu	s1,a5,80005724 <exec+0x374>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005536:	e2843783          	ld	a5,-472(s0)
    8000553a:	94be                	add	s1,s1,a5
    8000553c:	1ef4e863          	bltu	s1,a5,8000572c <exec+0x37c>
    if(ph.vaddr % PGSIZE != 0)
    80005540:	df043703          	ld	a4,-528(s0)
    80005544:	8ff9                	and	a5,a5,a4
    80005546:	1e079763          	bnez	a5,80005734 <exec+0x384>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000554a:	e1c42503          	lw	a0,-484(s0)
    8000554e:	00000097          	auipc	ra,0x0
    80005552:	e48080e7          	jalr	-440(ra) # 80005396 <flags2perm>
    80005556:	86aa                	mv	a3,a0
    80005558:	8626                	mv	a2,s1
    8000555a:	85ca                	mv	a1,s2
    8000555c:	855a                	mv	a0,s6
    8000555e:	ffffc097          	auipc	ra,0xffffc
    80005562:	15e080e7          	jalr	350(ra) # 800016bc <uvmalloc>
    80005566:	e0a43423          	sd	a0,-504(s0)
    8000556a:	1c050963          	beqz	a0,8000573c <exec+0x38c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000556e:	e2843b83          	ld	s7,-472(s0)
    80005572:	e2042c03          	lw	s8,-480(s0)
    80005576:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000557a:	00098463          	beqz	s3,80005582 <exec+0x1d2>
    8000557e:	4901                	li	s2,0
    80005580:	b7a1                	j	800054c8 <exec+0x118>
    sz = sz1;
    80005582:	e0843903          	ld	s2,-504(s0)
    80005586:	b7b5                	j	800054f2 <exec+0x142>
    80005588:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    8000558a:	8552                	mv	a0,s4
    8000558c:	fffff097          	auipc	ra,0xfffff
    80005590:	b1c080e7          	jalr	-1252(ra) # 800040a8 <iunlockput>
  end_op();
    80005594:	fffff097          	auipc	ra,0xfffff
    80005598:	2f6080e7          	jalr	758(ra) # 8000488a <end_op>
  p = myproc();
    8000559c:	ffffc097          	auipc	ra,0xffffc
    800055a0:	7f0080e7          	jalr	2032(ra) # 80001d8c <myproc>
    800055a4:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800055a6:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800055aa:	6985                	lui	s3,0x1
    800055ac:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800055ae:	99ca                	add	s3,s3,s2
    800055b0:	77fd                	lui	a5,0xfffff
    800055b2:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800055b6:	4691                	li	a3,4
    800055b8:	6609                	lui	a2,0x2
    800055ba:	964e                	add	a2,a2,s3
    800055bc:	85ce                	mv	a1,s3
    800055be:	855a                	mv	a0,s6
    800055c0:	ffffc097          	auipc	ra,0xffffc
    800055c4:	0fc080e7          	jalr	252(ra) # 800016bc <uvmalloc>
    800055c8:	892a                	mv	s2,a0
    800055ca:	e0a43423          	sd	a0,-504(s0)
    800055ce:	e519                	bnez	a0,800055dc <exec+0x22c>
  if(pagetable)
    800055d0:	e1343423          	sd	s3,-504(s0)
    800055d4:	4a01                	li	s4,0
    800055d6:	aaa5                	j	8000574e <exec+0x39e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800055d8:	4901                	li	s2,0
    800055da:	bf45                	j	8000558a <exec+0x1da>
  uvmclear(pagetable, sz-2*PGSIZE);
    800055dc:	75f9                	lui	a1,0xffffe
    800055de:	95aa                	add	a1,a1,a0
    800055e0:	855a                	mv	a0,s6
    800055e2:	ffffc097          	auipc	ra,0xffffc
    800055e6:	31c080e7          	jalr	796(ra) # 800018fe <uvmclear>
  stackbase = sp - PGSIZE;
    800055ea:	7bfd                	lui	s7,0xfffff
    800055ec:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800055ee:	e0043783          	ld	a5,-512(s0)
    800055f2:	6388                	ld	a0,0(a5)
    800055f4:	c52d                	beqz	a0,8000565e <exec+0x2ae>
    800055f6:	e9040993          	addi	s3,s0,-368
    800055fa:	f9040c13          	addi	s8,s0,-112
    800055fe:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80005600:	ffffc097          	auipc	ra,0xffffc
    80005604:	b08080e7          	jalr	-1272(ra) # 80001108 <strlen>
    80005608:	0015079b          	addiw	a5,a0,1
    8000560c:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005610:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80005614:	13796863          	bltu	s2,s7,80005744 <exec+0x394>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005618:	e0043d03          	ld	s10,-512(s0)
    8000561c:	000d3a03          	ld	s4,0(s10)
    80005620:	8552                	mv	a0,s4
    80005622:	ffffc097          	auipc	ra,0xffffc
    80005626:	ae6080e7          	jalr	-1306(ra) # 80001108 <strlen>
    8000562a:	0015069b          	addiw	a3,a0,1
    8000562e:	8652                	mv	a2,s4
    80005630:	85ca                	mv	a1,s2
    80005632:	855a                	mv	a0,s6
    80005634:	ffffc097          	auipc	ra,0xffffc
    80005638:	2fc080e7          	jalr	764(ra) # 80001930 <copyout>
    8000563c:	10054663          	bltz	a0,80005748 <exec+0x398>
    ustack[argc] = sp;
    80005640:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80005644:	0485                	addi	s1,s1,1
    80005646:	008d0793          	addi	a5,s10,8
    8000564a:	e0f43023          	sd	a5,-512(s0)
    8000564e:	008d3503          	ld	a0,8(s10)
    80005652:	c909                	beqz	a0,80005664 <exec+0x2b4>
    if(argc >= MAXARG)
    80005654:	09a1                	addi	s3,s3,8
    80005656:	fb8995e3          	bne	s3,s8,80005600 <exec+0x250>
  ip = 0;
    8000565a:	4a01                	li	s4,0
    8000565c:	a8cd                	j	8000574e <exec+0x39e>
  sp = sz;
    8000565e:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80005662:	4481                	li	s1,0
  ustack[argc] = 0;
    80005664:	00349793          	slli	a5,s1,0x3
    80005668:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7fdba560>
    8000566c:	97a2                	add	a5,a5,s0
    8000566e:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80005672:	00148693          	addi	a3,s1,1
    80005676:	068e                	slli	a3,a3,0x3
    80005678:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000567c:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80005680:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80005684:	f57966e3          	bltu	s2,s7,800055d0 <exec+0x220>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005688:	e9040613          	addi	a2,s0,-368
    8000568c:	85ca                	mv	a1,s2
    8000568e:	855a                	mv	a0,s6
    80005690:	ffffc097          	auipc	ra,0xffffc
    80005694:	2a0080e7          	jalr	672(ra) # 80001930 <copyout>
    80005698:	0e054863          	bltz	a0,80005788 <exec+0x3d8>
  p->trapframe->a1 = sp;
    8000569c:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800056a0:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800056a4:	df843783          	ld	a5,-520(s0)
    800056a8:	0007c703          	lbu	a4,0(a5)
    800056ac:	cf11                	beqz	a4,800056c8 <exec+0x318>
    800056ae:	0785                	addi	a5,a5,1
    if(*s == '/')
    800056b0:	02f00693          	li	a3,47
    800056b4:	a039                	j	800056c2 <exec+0x312>
      last = s+1;
    800056b6:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800056ba:	0785                	addi	a5,a5,1
    800056bc:	fff7c703          	lbu	a4,-1(a5)
    800056c0:	c701                	beqz	a4,800056c8 <exec+0x318>
    if(*s == '/')
    800056c2:	fed71ce3          	bne	a4,a3,800056ba <exec+0x30a>
    800056c6:	bfc5                	j	800056b6 <exec+0x306>
  safestrcpy(p->name, last, sizeof(p->name));
    800056c8:	4641                	li	a2,16
    800056ca:	df843583          	ld	a1,-520(s0)
    800056ce:	158a8513          	addi	a0,s5,344
    800056d2:	ffffc097          	auipc	ra,0xffffc
    800056d6:	a04080e7          	jalr	-1532(ra) # 800010d6 <safestrcpy>
  oldpagetable = p->pagetable;
    800056da:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800056de:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800056e2:	e0843783          	ld	a5,-504(s0)
    800056e6:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800056ea:	058ab783          	ld	a5,88(s5)
    800056ee:	e6843703          	ld	a4,-408(s0)
    800056f2:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800056f4:	058ab783          	ld	a5,88(s5)
    800056f8:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800056fc:	85e6                	mv	a1,s9
    800056fe:	ffffc097          	auipc	ra,0xffffc
    80005702:	7ee080e7          	jalr	2030(ra) # 80001eec <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005706:	0004851b          	sext.w	a0,s1
    8000570a:	79be                	ld	s3,488(sp)
    8000570c:	7a1e                	ld	s4,480(sp)
    8000570e:	6afe                	ld	s5,472(sp)
    80005710:	6b5e                	ld	s6,464(sp)
    80005712:	6bbe                	ld	s7,456(sp)
    80005714:	6c1e                	ld	s8,448(sp)
    80005716:	7cfa                	ld	s9,440(sp)
    80005718:	7d5a                	ld	s10,432(sp)
    8000571a:	b305                	j	8000543a <exec+0x8a>
    8000571c:	e1243423          	sd	s2,-504(s0)
    80005720:	7dba                	ld	s11,424(sp)
    80005722:	a035                	j	8000574e <exec+0x39e>
    80005724:	e1243423          	sd	s2,-504(s0)
    80005728:	7dba                	ld	s11,424(sp)
    8000572a:	a015                	j	8000574e <exec+0x39e>
    8000572c:	e1243423          	sd	s2,-504(s0)
    80005730:	7dba                	ld	s11,424(sp)
    80005732:	a831                	j	8000574e <exec+0x39e>
    80005734:	e1243423          	sd	s2,-504(s0)
    80005738:	7dba                	ld	s11,424(sp)
    8000573a:	a811                	j	8000574e <exec+0x39e>
    8000573c:	e1243423          	sd	s2,-504(s0)
    80005740:	7dba                	ld	s11,424(sp)
    80005742:	a031                	j	8000574e <exec+0x39e>
  ip = 0;
    80005744:	4a01                	li	s4,0
    80005746:	a021                	j	8000574e <exec+0x39e>
    80005748:	4a01                	li	s4,0
  if(pagetable)
    8000574a:	a011                	j	8000574e <exec+0x39e>
    8000574c:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    8000574e:	e0843583          	ld	a1,-504(s0)
    80005752:	855a                	mv	a0,s6
    80005754:	ffffc097          	auipc	ra,0xffffc
    80005758:	798080e7          	jalr	1944(ra) # 80001eec <proc_freepagetable>
  return -1;
    8000575c:	557d                	li	a0,-1
  if(ip){
    8000575e:	000a1b63          	bnez	s4,80005774 <exec+0x3c4>
    80005762:	79be                	ld	s3,488(sp)
    80005764:	7a1e                	ld	s4,480(sp)
    80005766:	6afe                	ld	s5,472(sp)
    80005768:	6b5e                	ld	s6,464(sp)
    8000576a:	6bbe                	ld	s7,456(sp)
    8000576c:	6c1e                	ld	s8,448(sp)
    8000576e:	7cfa                	ld	s9,440(sp)
    80005770:	7d5a                	ld	s10,432(sp)
    80005772:	b1e1                	j	8000543a <exec+0x8a>
    80005774:	79be                	ld	s3,488(sp)
    80005776:	6afe                	ld	s5,472(sp)
    80005778:	6b5e                	ld	s6,464(sp)
    8000577a:	6bbe                	ld	s7,456(sp)
    8000577c:	6c1e                	ld	s8,448(sp)
    8000577e:	7cfa                	ld	s9,440(sp)
    80005780:	7d5a                	ld	s10,432(sp)
    80005782:	b14d                	j	80005424 <exec+0x74>
    80005784:	6b5e                	ld	s6,464(sp)
    80005786:	b979                	j	80005424 <exec+0x74>
  sz = sz1;
    80005788:	e0843983          	ld	s3,-504(s0)
    8000578c:	b591                	j	800055d0 <exec+0x220>

000000008000578e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000578e:	7179                	addi	sp,sp,-48
    80005790:	f406                	sd	ra,40(sp)
    80005792:	f022                	sd	s0,32(sp)
    80005794:	ec26                	sd	s1,24(sp)
    80005796:	e84a                	sd	s2,16(sp)
    80005798:	1800                	addi	s0,sp,48
    8000579a:	892e                	mv	s2,a1
    8000579c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000579e:	fdc40593          	addi	a1,s0,-36
    800057a2:	ffffe097          	auipc	ra,0xffffe
    800057a6:	9c2080e7          	jalr	-1598(ra) # 80003164 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800057aa:	fdc42703          	lw	a4,-36(s0)
    800057ae:	47bd                	li	a5,15
    800057b0:	02e7eb63          	bltu	a5,a4,800057e6 <argfd+0x58>
    800057b4:	ffffc097          	auipc	ra,0xffffc
    800057b8:	5d8080e7          	jalr	1496(ra) # 80001d8c <myproc>
    800057bc:	fdc42703          	lw	a4,-36(s0)
    800057c0:	01a70793          	addi	a5,a4,26
    800057c4:	078e                	slli	a5,a5,0x3
    800057c6:	953e                	add	a0,a0,a5
    800057c8:	611c                	ld	a5,0(a0)
    800057ca:	c385                	beqz	a5,800057ea <argfd+0x5c>
    return -1;
  if(pfd)
    800057cc:	00090463          	beqz	s2,800057d4 <argfd+0x46>
    *pfd = fd;
    800057d0:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800057d4:	4501                	li	a0,0
  if(pf)
    800057d6:	c091                	beqz	s1,800057da <argfd+0x4c>
    *pf = f;
    800057d8:	e09c                	sd	a5,0(s1)
}
    800057da:	70a2                	ld	ra,40(sp)
    800057dc:	7402                	ld	s0,32(sp)
    800057de:	64e2                	ld	s1,24(sp)
    800057e0:	6942                	ld	s2,16(sp)
    800057e2:	6145                	addi	sp,sp,48
    800057e4:	8082                	ret
    return -1;
    800057e6:	557d                	li	a0,-1
    800057e8:	bfcd                	j	800057da <argfd+0x4c>
    800057ea:	557d                	li	a0,-1
    800057ec:	b7fd                	j	800057da <argfd+0x4c>

00000000800057ee <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800057ee:	1101                	addi	sp,sp,-32
    800057f0:	ec06                	sd	ra,24(sp)
    800057f2:	e822                	sd	s0,16(sp)
    800057f4:	e426                	sd	s1,8(sp)
    800057f6:	1000                	addi	s0,sp,32
    800057f8:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800057fa:	ffffc097          	auipc	ra,0xffffc
    800057fe:	592080e7          	jalr	1426(ra) # 80001d8c <myproc>
    80005802:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005804:	0d050793          	addi	a5,a0,208
    80005808:	4501                	li	a0,0
    8000580a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000580c:	6398                	ld	a4,0(a5)
    8000580e:	cb19                	beqz	a4,80005824 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005810:	2505                	addiw	a0,a0,1
    80005812:	07a1                	addi	a5,a5,8
    80005814:	fed51ce3          	bne	a0,a3,8000580c <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005818:	557d                	li	a0,-1
}
    8000581a:	60e2                	ld	ra,24(sp)
    8000581c:	6442                	ld	s0,16(sp)
    8000581e:	64a2                	ld	s1,8(sp)
    80005820:	6105                	addi	sp,sp,32
    80005822:	8082                	ret
      p->ofile[fd] = f;
    80005824:	01a50793          	addi	a5,a0,26
    80005828:	078e                	slli	a5,a5,0x3
    8000582a:	963e                	add	a2,a2,a5
    8000582c:	e204                	sd	s1,0(a2)
      return fd;
    8000582e:	b7f5                	j	8000581a <fdalloc+0x2c>

0000000080005830 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005830:	715d                	addi	sp,sp,-80
    80005832:	e486                	sd	ra,72(sp)
    80005834:	e0a2                	sd	s0,64(sp)
    80005836:	fc26                	sd	s1,56(sp)
    80005838:	f84a                	sd	s2,48(sp)
    8000583a:	f44e                	sd	s3,40(sp)
    8000583c:	ec56                	sd	s5,24(sp)
    8000583e:	e85a                	sd	s6,16(sp)
    80005840:	0880                	addi	s0,sp,80
    80005842:	8b2e                	mv	s6,a1
    80005844:	89b2                	mv	s3,a2
    80005846:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005848:	fb040593          	addi	a1,s0,-80
    8000584c:	fffff097          	auipc	ra,0xfffff
    80005850:	de2080e7          	jalr	-542(ra) # 8000462e <nameiparent>
    80005854:	84aa                	mv	s1,a0
    80005856:	14050e63          	beqz	a0,800059b2 <create+0x182>
    return 0;

  ilock(dp);
    8000585a:	ffffe097          	auipc	ra,0xffffe
    8000585e:	5e8080e7          	jalr	1512(ra) # 80003e42 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005862:	4601                	li	a2,0
    80005864:	fb040593          	addi	a1,s0,-80
    80005868:	8526                	mv	a0,s1
    8000586a:	fffff097          	auipc	ra,0xfffff
    8000586e:	ae4080e7          	jalr	-1308(ra) # 8000434e <dirlookup>
    80005872:	8aaa                	mv	s5,a0
    80005874:	c539                	beqz	a0,800058c2 <create+0x92>
    iunlockput(dp);
    80005876:	8526                	mv	a0,s1
    80005878:	fffff097          	auipc	ra,0xfffff
    8000587c:	830080e7          	jalr	-2000(ra) # 800040a8 <iunlockput>
    ilock(ip);
    80005880:	8556                	mv	a0,s5
    80005882:	ffffe097          	auipc	ra,0xffffe
    80005886:	5c0080e7          	jalr	1472(ra) # 80003e42 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000588a:	4789                	li	a5,2
    8000588c:	02fb1463          	bne	s6,a5,800058b4 <create+0x84>
    80005890:	044ad783          	lhu	a5,68(s5)
    80005894:	37f9                	addiw	a5,a5,-2
    80005896:	17c2                	slli	a5,a5,0x30
    80005898:	93c1                	srli	a5,a5,0x30
    8000589a:	4705                	li	a4,1
    8000589c:	00f76c63          	bltu	a4,a5,800058b4 <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800058a0:	8556                	mv	a0,s5
    800058a2:	60a6                	ld	ra,72(sp)
    800058a4:	6406                	ld	s0,64(sp)
    800058a6:	74e2                	ld	s1,56(sp)
    800058a8:	7942                	ld	s2,48(sp)
    800058aa:	79a2                	ld	s3,40(sp)
    800058ac:	6ae2                	ld	s5,24(sp)
    800058ae:	6b42                	ld	s6,16(sp)
    800058b0:	6161                	addi	sp,sp,80
    800058b2:	8082                	ret
    iunlockput(ip);
    800058b4:	8556                	mv	a0,s5
    800058b6:	ffffe097          	auipc	ra,0xffffe
    800058ba:	7f2080e7          	jalr	2034(ra) # 800040a8 <iunlockput>
    return 0;
    800058be:	4a81                	li	s5,0
    800058c0:	b7c5                	j	800058a0 <create+0x70>
    800058c2:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    800058c4:	85da                	mv	a1,s6
    800058c6:	4088                	lw	a0,0(s1)
    800058c8:	ffffe097          	auipc	ra,0xffffe
    800058cc:	3d6080e7          	jalr	982(ra) # 80003c9e <ialloc>
    800058d0:	8a2a                	mv	s4,a0
    800058d2:	c531                	beqz	a0,8000591e <create+0xee>
  ilock(ip);
    800058d4:	ffffe097          	auipc	ra,0xffffe
    800058d8:	56e080e7          	jalr	1390(ra) # 80003e42 <ilock>
  ip->major = major;
    800058dc:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800058e0:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800058e4:	4905                	li	s2,1
    800058e6:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800058ea:	8552                	mv	a0,s4
    800058ec:	ffffe097          	auipc	ra,0xffffe
    800058f0:	48a080e7          	jalr	1162(ra) # 80003d76 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800058f4:	032b0d63          	beq	s6,s2,8000592e <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800058f8:	004a2603          	lw	a2,4(s4)
    800058fc:	fb040593          	addi	a1,s0,-80
    80005900:	8526                	mv	a0,s1
    80005902:	fffff097          	auipc	ra,0xfffff
    80005906:	c5c080e7          	jalr	-932(ra) # 8000455e <dirlink>
    8000590a:	08054163          	bltz	a0,8000598c <create+0x15c>
  iunlockput(dp);
    8000590e:	8526                	mv	a0,s1
    80005910:	ffffe097          	auipc	ra,0xffffe
    80005914:	798080e7          	jalr	1944(ra) # 800040a8 <iunlockput>
  return ip;
    80005918:	8ad2                	mv	s5,s4
    8000591a:	7a02                	ld	s4,32(sp)
    8000591c:	b751                	j	800058a0 <create+0x70>
    iunlockput(dp);
    8000591e:	8526                	mv	a0,s1
    80005920:	ffffe097          	auipc	ra,0xffffe
    80005924:	788080e7          	jalr	1928(ra) # 800040a8 <iunlockput>
    return 0;
    80005928:	8ad2                	mv	s5,s4
    8000592a:	7a02                	ld	s4,32(sp)
    8000592c:	bf95                	j	800058a0 <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000592e:	004a2603          	lw	a2,4(s4)
    80005932:	00003597          	auipc	a1,0x3
    80005936:	de658593          	addi	a1,a1,-538 # 80008718 <__func__.1+0x710>
    8000593a:	8552                	mv	a0,s4
    8000593c:	fffff097          	auipc	ra,0xfffff
    80005940:	c22080e7          	jalr	-990(ra) # 8000455e <dirlink>
    80005944:	04054463          	bltz	a0,8000598c <create+0x15c>
    80005948:	40d0                	lw	a2,4(s1)
    8000594a:	00003597          	auipc	a1,0x3
    8000594e:	dd658593          	addi	a1,a1,-554 # 80008720 <__func__.1+0x718>
    80005952:	8552                	mv	a0,s4
    80005954:	fffff097          	auipc	ra,0xfffff
    80005958:	c0a080e7          	jalr	-1014(ra) # 8000455e <dirlink>
    8000595c:	02054863          	bltz	a0,8000598c <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    80005960:	004a2603          	lw	a2,4(s4)
    80005964:	fb040593          	addi	a1,s0,-80
    80005968:	8526                	mv	a0,s1
    8000596a:	fffff097          	auipc	ra,0xfffff
    8000596e:	bf4080e7          	jalr	-1036(ra) # 8000455e <dirlink>
    80005972:	00054d63          	bltz	a0,8000598c <create+0x15c>
    dp->nlink++;  // for ".."
    80005976:	04a4d783          	lhu	a5,74(s1)
    8000597a:	2785                	addiw	a5,a5,1
    8000597c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005980:	8526                	mv	a0,s1
    80005982:	ffffe097          	auipc	ra,0xffffe
    80005986:	3f4080e7          	jalr	1012(ra) # 80003d76 <iupdate>
    8000598a:	b751                	j	8000590e <create+0xde>
  ip->nlink = 0;
    8000598c:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80005990:	8552                	mv	a0,s4
    80005992:	ffffe097          	auipc	ra,0xffffe
    80005996:	3e4080e7          	jalr	996(ra) # 80003d76 <iupdate>
  iunlockput(ip);
    8000599a:	8552                	mv	a0,s4
    8000599c:	ffffe097          	auipc	ra,0xffffe
    800059a0:	70c080e7          	jalr	1804(ra) # 800040a8 <iunlockput>
  iunlockput(dp);
    800059a4:	8526                	mv	a0,s1
    800059a6:	ffffe097          	auipc	ra,0xffffe
    800059aa:	702080e7          	jalr	1794(ra) # 800040a8 <iunlockput>
  return 0;
    800059ae:	7a02                	ld	s4,32(sp)
    800059b0:	bdc5                	j	800058a0 <create+0x70>
    return 0;
    800059b2:	8aaa                	mv	s5,a0
    800059b4:	b5f5                	j	800058a0 <create+0x70>

00000000800059b6 <sys_dup>:
{
    800059b6:	7179                	addi	sp,sp,-48
    800059b8:	f406                	sd	ra,40(sp)
    800059ba:	f022                	sd	s0,32(sp)
    800059bc:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800059be:	fd840613          	addi	a2,s0,-40
    800059c2:	4581                	li	a1,0
    800059c4:	4501                	li	a0,0
    800059c6:	00000097          	auipc	ra,0x0
    800059ca:	dc8080e7          	jalr	-568(ra) # 8000578e <argfd>
    return -1;
    800059ce:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800059d0:	02054763          	bltz	a0,800059fe <sys_dup+0x48>
    800059d4:	ec26                	sd	s1,24(sp)
    800059d6:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800059d8:	fd843903          	ld	s2,-40(s0)
    800059dc:	854a                	mv	a0,s2
    800059de:	00000097          	auipc	ra,0x0
    800059e2:	e10080e7          	jalr	-496(ra) # 800057ee <fdalloc>
    800059e6:	84aa                	mv	s1,a0
    return -1;
    800059e8:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800059ea:	00054f63          	bltz	a0,80005a08 <sys_dup+0x52>
  filedup(f);
    800059ee:	854a                	mv	a0,s2
    800059f0:	fffff097          	auipc	ra,0xfffff
    800059f4:	298080e7          	jalr	664(ra) # 80004c88 <filedup>
  return fd;
    800059f8:	87a6                	mv	a5,s1
    800059fa:	64e2                	ld	s1,24(sp)
    800059fc:	6942                	ld	s2,16(sp)
}
    800059fe:	853e                	mv	a0,a5
    80005a00:	70a2                	ld	ra,40(sp)
    80005a02:	7402                	ld	s0,32(sp)
    80005a04:	6145                	addi	sp,sp,48
    80005a06:	8082                	ret
    80005a08:	64e2                	ld	s1,24(sp)
    80005a0a:	6942                	ld	s2,16(sp)
    80005a0c:	bfcd                	j	800059fe <sys_dup+0x48>

0000000080005a0e <sys_read>:
{
    80005a0e:	7179                	addi	sp,sp,-48
    80005a10:	f406                	sd	ra,40(sp)
    80005a12:	f022                	sd	s0,32(sp)
    80005a14:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005a16:	fd840593          	addi	a1,s0,-40
    80005a1a:	4505                	li	a0,1
    80005a1c:	ffffd097          	auipc	ra,0xffffd
    80005a20:	768080e7          	jalr	1896(ra) # 80003184 <argaddr>
  argint(2, &n);
    80005a24:	fe440593          	addi	a1,s0,-28
    80005a28:	4509                	li	a0,2
    80005a2a:	ffffd097          	auipc	ra,0xffffd
    80005a2e:	73a080e7          	jalr	1850(ra) # 80003164 <argint>
  if(argfd(0, 0, &f) < 0)
    80005a32:	fe840613          	addi	a2,s0,-24
    80005a36:	4581                	li	a1,0
    80005a38:	4501                	li	a0,0
    80005a3a:	00000097          	auipc	ra,0x0
    80005a3e:	d54080e7          	jalr	-684(ra) # 8000578e <argfd>
    80005a42:	87aa                	mv	a5,a0
    return -1;
    80005a44:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005a46:	0007cc63          	bltz	a5,80005a5e <sys_read+0x50>
  return fileread(f, p, n);
    80005a4a:	fe442603          	lw	a2,-28(s0)
    80005a4e:	fd843583          	ld	a1,-40(s0)
    80005a52:	fe843503          	ld	a0,-24(s0)
    80005a56:	fffff097          	auipc	ra,0xfffff
    80005a5a:	3d8080e7          	jalr	984(ra) # 80004e2e <fileread>
}
    80005a5e:	70a2                	ld	ra,40(sp)
    80005a60:	7402                	ld	s0,32(sp)
    80005a62:	6145                	addi	sp,sp,48
    80005a64:	8082                	ret

0000000080005a66 <sys_write>:
{
    80005a66:	7179                	addi	sp,sp,-48
    80005a68:	f406                	sd	ra,40(sp)
    80005a6a:	f022                	sd	s0,32(sp)
    80005a6c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005a6e:	fd840593          	addi	a1,s0,-40
    80005a72:	4505                	li	a0,1
    80005a74:	ffffd097          	auipc	ra,0xffffd
    80005a78:	710080e7          	jalr	1808(ra) # 80003184 <argaddr>
  argint(2, &n);
    80005a7c:	fe440593          	addi	a1,s0,-28
    80005a80:	4509                	li	a0,2
    80005a82:	ffffd097          	auipc	ra,0xffffd
    80005a86:	6e2080e7          	jalr	1762(ra) # 80003164 <argint>
  if(argfd(0, 0, &f) < 0)
    80005a8a:	fe840613          	addi	a2,s0,-24
    80005a8e:	4581                	li	a1,0
    80005a90:	4501                	li	a0,0
    80005a92:	00000097          	auipc	ra,0x0
    80005a96:	cfc080e7          	jalr	-772(ra) # 8000578e <argfd>
    80005a9a:	87aa                	mv	a5,a0
    return -1;
    80005a9c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005a9e:	0007cc63          	bltz	a5,80005ab6 <sys_write+0x50>
  return filewrite(f, p, n);
    80005aa2:	fe442603          	lw	a2,-28(s0)
    80005aa6:	fd843583          	ld	a1,-40(s0)
    80005aaa:	fe843503          	ld	a0,-24(s0)
    80005aae:	fffff097          	auipc	ra,0xfffff
    80005ab2:	452080e7          	jalr	1106(ra) # 80004f00 <filewrite>
}
    80005ab6:	70a2                	ld	ra,40(sp)
    80005ab8:	7402                	ld	s0,32(sp)
    80005aba:	6145                	addi	sp,sp,48
    80005abc:	8082                	ret

0000000080005abe <sys_close>:
{
    80005abe:	1101                	addi	sp,sp,-32
    80005ac0:	ec06                	sd	ra,24(sp)
    80005ac2:	e822                	sd	s0,16(sp)
    80005ac4:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005ac6:	fe040613          	addi	a2,s0,-32
    80005aca:	fec40593          	addi	a1,s0,-20
    80005ace:	4501                	li	a0,0
    80005ad0:	00000097          	auipc	ra,0x0
    80005ad4:	cbe080e7          	jalr	-834(ra) # 8000578e <argfd>
    return -1;
    80005ad8:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005ada:	02054463          	bltz	a0,80005b02 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005ade:	ffffc097          	auipc	ra,0xffffc
    80005ae2:	2ae080e7          	jalr	686(ra) # 80001d8c <myproc>
    80005ae6:	fec42783          	lw	a5,-20(s0)
    80005aea:	07e9                	addi	a5,a5,26
    80005aec:	078e                	slli	a5,a5,0x3
    80005aee:	953e                	add	a0,a0,a5
    80005af0:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005af4:	fe043503          	ld	a0,-32(s0)
    80005af8:	fffff097          	auipc	ra,0xfffff
    80005afc:	1e2080e7          	jalr	482(ra) # 80004cda <fileclose>
  return 0;
    80005b00:	4781                	li	a5,0
}
    80005b02:	853e                	mv	a0,a5
    80005b04:	60e2                	ld	ra,24(sp)
    80005b06:	6442                	ld	s0,16(sp)
    80005b08:	6105                	addi	sp,sp,32
    80005b0a:	8082                	ret

0000000080005b0c <sys_fstat>:
{
    80005b0c:	1101                	addi	sp,sp,-32
    80005b0e:	ec06                	sd	ra,24(sp)
    80005b10:	e822                	sd	s0,16(sp)
    80005b12:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005b14:	fe040593          	addi	a1,s0,-32
    80005b18:	4505                	li	a0,1
    80005b1a:	ffffd097          	auipc	ra,0xffffd
    80005b1e:	66a080e7          	jalr	1642(ra) # 80003184 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005b22:	fe840613          	addi	a2,s0,-24
    80005b26:	4581                	li	a1,0
    80005b28:	4501                	li	a0,0
    80005b2a:	00000097          	auipc	ra,0x0
    80005b2e:	c64080e7          	jalr	-924(ra) # 8000578e <argfd>
    80005b32:	87aa                	mv	a5,a0
    return -1;
    80005b34:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005b36:	0007ca63          	bltz	a5,80005b4a <sys_fstat+0x3e>
  return filestat(f, st);
    80005b3a:	fe043583          	ld	a1,-32(s0)
    80005b3e:	fe843503          	ld	a0,-24(s0)
    80005b42:	fffff097          	auipc	ra,0xfffff
    80005b46:	27a080e7          	jalr	634(ra) # 80004dbc <filestat>
}
    80005b4a:	60e2                	ld	ra,24(sp)
    80005b4c:	6442                	ld	s0,16(sp)
    80005b4e:	6105                	addi	sp,sp,32
    80005b50:	8082                	ret

0000000080005b52 <sys_link>:
{
    80005b52:	7169                	addi	sp,sp,-304
    80005b54:	f606                	sd	ra,296(sp)
    80005b56:	f222                	sd	s0,288(sp)
    80005b58:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005b5a:	08000613          	li	a2,128
    80005b5e:	ed040593          	addi	a1,s0,-304
    80005b62:	4501                	li	a0,0
    80005b64:	ffffd097          	auipc	ra,0xffffd
    80005b68:	640080e7          	jalr	1600(ra) # 800031a4 <argstr>
    return -1;
    80005b6c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005b6e:	12054663          	bltz	a0,80005c9a <sys_link+0x148>
    80005b72:	08000613          	li	a2,128
    80005b76:	f5040593          	addi	a1,s0,-176
    80005b7a:	4505                	li	a0,1
    80005b7c:	ffffd097          	auipc	ra,0xffffd
    80005b80:	628080e7          	jalr	1576(ra) # 800031a4 <argstr>
    return -1;
    80005b84:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005b86:	10054a63          	bltz	a0,80005c9a <sys_link+0x148>
    80005b8a:	ee26                	sd	s1,280(sp)
  begin_op();
    80005b8c:	fffff097          	auipc	ra,0xfffff
    80005b90:	c84080e7          	jalr	-892(ra) # 80004810 <begin_op>
  if((ip = namei(old)) == 0){
    80005b94:	ed040513          	addi	a0,s0,-304
    80005b98:	fffff097          	auipc	ra,0xfffff
    80005b9c:	a78080e7          	jalr	-1416(ra) # 80004610 <namei>
    80005ba0:	84aa                	mv	s1,a0
    80005ba2:	c949                	beqz	a0,80005c34 <sys_link+0xe2>
  ilock(ip);
    80005ba4:	ffffe097          	auipc	ra,0xffffe
    80005ba8:	29e080e7          	jalr	670(ra) # 80003e42 <ilock>
  if(ip->type == T_DIR){
    80005bac:	04449703          	lh	a4,68(s1)
    80005bb0:	4785                	li	a5,1
    80005bb2:	08f70863          	beq	a4,a5,80005c42 <sys_link+0xf0>
    80005bb6:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80005bb8:	04a4d783          	lhu	a5,74(s1)
    80005bbc:	2785                	addiw	a5,a5,1
    80005bbe:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005bc2:	8526                	mv	a0,s1
    80005bc4:	ffffe097          	auipc	ra,0xffffe
    80005bc8:	1b2080e7          	jalr	434(ra) # 80003d76 <iupdate>
  iunlock(ip);
    80005bcc:	8526                	mv	a0,s1
    80005bce:	ffffe097          	auipc	ra,0xffffe
    80005bd2:	33a080e7          	jalr	826(ra) # 80003f08 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005bd6:	fd040593          	addi	a1,s0,-48
    80005bda:	f5040513          	addi	a0,s0,-176
    80005bde:	fffff097          	auipc	ra,0xfffff
    80005be2:	a50080e7          	jalr	-1456(ra) # 8000462e <nameiparent>
    80005be6:	892a                	mv	s2,a0
    80005be8:	cd35                	beqz	a0,80005c64 <sys_link+0x112>
  ilock(dp);
    80005bea:	ffffe097          	auipc	ra,0xffffe
    80005bee:	258080e7          	jalr	600(ra) # 80003e42 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005bf2:	00092703          	lw	a4,0(s2)
    80005bf6:	409c                	lw	a5,0(s1)
    80005bf8:	06f71163          	bne	a4,a5,80005c5a <sys_link+0x108>
    80005bfc:	40d0                	lw	a2,4(s1)
    80005bfe:	fd040593          	addi	a1,s0,-48
    80005c02:	854a                	mv	a0,s2
    80005c04:	fffff097          	auipc	ra,0xfffff
    80005c08:	95a080e7          	jalr	-1702(ra) # 8000455e <dirlink>
    80005c0c:	04054763          	bltz	a0,80005c5a <sys_link+0x108>
  iunlockput(dp);
    80005c10:	854a                	mv	a0,s2
    80005c12:	ffffe097          	auipc	ra,0xffffe
    80005c16:	496080e7          	jalr	1174(ra) # 800040a8 <iunlockput>
  iput(ip);
    80005c1a:	8526                	mv	a0,s1
    80005c1c:	ffffe097          	auipc	ra,0xffffe
    80005c20:	3e4080e7          	jalr	996(ra) # 80004000 <iput>
  end_op();
    80005c24:	fffff097          	auipc	ra,0xfffff
    80005c28:	c66080e7          	jalr	-922(ra) # 8000488a <end_op>
  return 0;
    80005c2c:	4781                	li	a5,0
    80005c2e:	64f2                	ld	s1,280(sp)
    80005c30:	6952                	ld	s2,272(sp)
    80005c32:	a0a5                	j	80005c9a <sys_link+0x148>
    end_op();
    80005c34:	fffff097          	auipc	ra,0xfffff
    80005c38:	c56080e7          	jalr	-938(ra) # 8000488a <end_op>
    return -1;
    80005c3c:	57fd                	li	a5,-1
    80005c3e:	64f2                	ld	s1,280(sp)
    80005c40:	a8a9                	j	80005c9a <sys_link+0x148>
    iunlockput(ip);
    80005c42:	8526                	mv	a0,s1
    80005c44:	ffffe097          	auipc	ra,0xffffe
    80005c48:	464080e7          	jalr	1124(ra) # 800040a8 <iunlockput>
    end_op();
    80005c4c:	fffff097          	auipc	ra,0xfffff
    80005c50:	c3e080e7          	jalr	-962(ra) # 8000488a <end_op>
    return -1;
    80005c54:	57fd                	li	a5,-1
    80005c56:	64f2                	ld	s1,280(sp)
    80005c58:	a089                	j	80005c9a <sys_link+0x148>
    iunlockput(dp);
    80005c5a:	854a                	mv	a0,s2
    80005c5c:	ffffe097          	auipc	ra,0xffffe
    80005c60:	44c080e7          	jalr	1100(ra) # 800040a8 <iunlockput>
  ilock(ip);
    80005c64:	8526                	mv	a0,s1
    80005c66:	ffffe097          	auipc	ra,0xffffe
    80005c6a:	1dc080e7          	jalr	476(ra) # 80003e42 <ilock>
  ip->nlink--;
    80005c6e:	04a4d783          	lhu	a5,74(s1)
    80005c72:	37fd                	addiw	a5,a5,-1
    80005c74:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005c78:	8526                	mv	a0,s1
    80005c7a:	ffffe097          	auipc	ra,0xffffe
    80005c7e:	0fc080e7          	jalr	252(ra) # 80003d76 <iupdate>
  iunlockput(ip);
    80005c82:	8526                	mv	a0,s1
    80005c84:	ffffe097          	auipc	ra,0xffffe
    80005c88:	424080e7          	jalr	1060(ra) # 800040a8 <iunlockput>
  end_op();
    80005c8c:	fffff097          	auipc	ra,0xfffff
    80005c90:	bfe080e7          	jalr	-1026(ra) # 8000488a <end_op>
  return -1;
    80005c94:	57fd                	li	a5,-1
    80005c96:	64f2                	ld	s1,280(sp)
    80005c98:	6952                	ld	s2,272(sp)
}
    80005c9a:	853e                	mv	a0,a5
    80005c9c:	70b2                	ld	ra,296(sp)
    80005c9e:	7412                	ld	s0,288(sp)
    80005ca0:	6155                	addi	sp,sp,304
    80005ca2:	8082                	ret

0000000080005ca4 <sys_unlink>:
{
    80005ca4:	7151                	addi	sp,sp,-240
    80005ca6:	f586                	sd	ra,232(sp)
    80005ca8:	f1a2                	sd	s0,224(sp)
    80005caa:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005cac:	08000613          	li	a2,128
    80005cb0:	f3040593          	addi	a1,s0,-208
    80005cb4:	4501                	li	a0,0
    80005cb6:	ffffd097          	auipc	ra,0xffffd
    80005cba:	4ee080e7          	jalr	1262(ra) # 800031a4 <argstr>
    80005cbe:	1a054a63          	bltz	a0,80005e72 <sys_unlink+0x1ce>
    80005cc2:	eda6                	sd	s1,216(sp)
  begin_op();
    80005cc4:	fffff097          	auipc	ra,0xfffff
    80005cc8:	b4c080e7          	jalr	-1204(ra) # 80004810 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005ccc:	fb040593          	addi	a1,s0,-80
    80005cd0:	f3040513          	addi	a0,s0,-208
    80005cd4:	fffff097          	auipc	ra,0xfffff
    80005cd8:	95a080e7          	jalr	-1702(ra) # 8000462e <nameiparent>
    80005cdc:	84aa                	mv	s1,a0
    80005cde:	cd71                	beqz	a0,80005dba <sys_unlink+0x116>
  ilock(dp);
    80005ce0:	ffffe097          	auipc	ra,0xffffe
    80005ce4:	162080e7          	jalr	354(ra) # 80003e42 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005ce8:	00003597          	auipc	a1,0x3
    80005cec:	a3058593          	addi	a1,a1,-1488 # 80008718 <__func__.1+0x710>
    80005cf0:	fb040513          	addi	a0,s0,-80
    80005cf4:	ffffe097          	auipc	ra,0xffffe
    80005cf8:	640080e7          	jalr	1600(ra) # 80004334 <namecmp>
    80005cfc:	14050c63          	beqz	a0,80005e54 <sys_unlink+0x1b0>
    80005d00:	00003597          	auipc	a1,0x3
    80005d04:	a2058593          	addi	a1,a1,-1504 # 80008720 <__func__.1+0x718>
    80005d08:	fb040513          	addi	a0,s0,-80
    80005d0c:	ffffe097          	auipc	ra,0xffffe
    80005d10:	628080e7          	jalr	1576(ra) # 80004334 <namecmp>
    80005d14:	14050063          	beqz	a0,80005e54 <sys_unlink+0x1b0>
    80005d18:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005d1a:	f2c40613          	addi	a2,s0,-212
    80005d1e:	fb040593          	addi	a1,s0,-80
    80005d22:	8526                	mv	a0,s1
    80005d24:	ffffe097          	auipc	ra,0xffffe
    80005d28:	62a080e7          	jalr	1578(ra) # 8000434e <dirlookup>
    80005d2c:	892a                	mv	s2,a0
    80005d2e:	12050263          	beqz	a0,80005e52 <sys_unlink+0x1ae>
  ilock(ip);
    80005d32:	ffffe097          	auipc	ra,0xffffe
    80005d36:	110080e7          	jalr	272(ra) # 80003e42 <ilock>
  if(ip->nlink < 1)
    80005d3a:	04a91783          	lh	a5,74(s2)
    80005d3e:	08f05563          	blez	a5,80005dc8 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005d42:	04491703          	lh	a4,68(s2)
    80005d46:	4785                	li	a5,1
    80005d48:	08f70963          	beq	a4,a5,80005dda <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80005d4c:	4641                	li	a2,16
    80005d4e:	4581                	li	a1,0
    80005d50:	fc040513          	addi	a0,s0,-64
    80005d54:	ffffb097          	auipc	ra,0xffffb
    80005d58:	240080e7          	jalr	576(ra) # 80000f94 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005d5c:	4741                	li	a4,16
    80005d5e:	f2c42683          	lw	a3,-212(s0)
    80005d62:	fc040613          	addi	a2,s0,-64
    80005d66:	4581                	li	a1,0
    80005d68:	8526                	mv	a0,s1
    80005d6a:	ffffe097          	auipc	ra,0xffffe
    80005d6e:	4a0080e7          	jalr	1184(ra) # 8000420a <writei>
    80005d72:	47c1                	li	a5,16
    80005d74:	0af51b63          	bne	a0,a5,80005e2a <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80005d78:	04491703          	lh	a4,68(s2)
    80005d7c:	4785                	li	a5,1
    80005d7e:	0af70f63          	beq	a4,a5,80005e3c <sys_unlink+0x198>
  iunlockput(dp);
    80005d82:	8526                	mv	a0,s1
    80005d84:	ffffe097          	auipc	ra,0xffffe
    80005d88:	324080e7          	jalr	804(ra) # 800040a8 <iunlockput>
  ip->nlink--;
    80005d8c:	04a95783          	lhu	a5,74(s2)
    80005d90:	37fd                	addiw	a5,a5,-1
    80005d92:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005d96:	854a                	mv	a0,s2
    80005d98:	ffffe097          	auipc	ra,0xffffe
    80005d9c:	fde080e7          	jalr	-34(ra) # 80003d76 <iupdate>
  iunlockput(ip);
    80005da0:	854a                	mv	a0,s2
    80005da2:	ffffe097          	auipc	ra,0xffffe
    80005da6:	306080e7          	jalr	774(ra) # 800040a8 <iunlockput>
  end_op();
    80005daa:	fffff097          	auipc	ra,0xfffff
    80005dae:	ae0080e7          	jalr	-1312(ra) # 8000488a <end_op>
  return 0;
    80005db2:	4501                	li	a0,0
    80005db4:	64ee                	ld	s1,216(sp)
    80005db6:	694e                	ld	s2,208(sp)
    80005db8:	a84d                	j	80005e6a <sys_unlink+0x1c6>
    end_op();
    80005dba:	fffff097          	auipc	ra,0xfffff
    80005dbe:	ad0080e7          	jalr	-1328(ra) # 8000488a <end_op>
    return -1;
    80005dc2:	557d                	li	a0,-1
    80005dc4:	64ee                	ld	s1,216(sp)
    80005dc6:	a055                	j	80005e6a <sys_unlink+0x1c6>
    80005dc8:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80005dca:	00003517          	auipc	a0,0x3
    80005dce:	95e50513          	addi	a0,a0,-1698 # 80008728 <__func__.1+0x720>
    80005dd2:	ffffa097          	auipc	ra,0xffffa
    80005dd6:	78e080e7          	jalr	1934(ra) # 80000560 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005dda:	04c92703          	lw	a4,76(s2)
    80005dde:	02000793          	li	a5,32
    80005de2:	f6e7f5e3          	bgeu	a5,a4,80005d4c <sys_unlink+0xa8>
    80005de6:	e5ce                	sd	s3,200(sp)
    80005de8:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005dec:	4741                	li	a4,16
    80005dee:	86ce                	mv	a3,s3
    80005df0:	f1840613          	addi	a2,s0,-232
    80005df4:	4581                	li	a1,0
    80005df6:	854a                	mv	a0,s2
    80005df8:	ffffe097          	auipc	ra,0xffffe
    80005dfc:	302080e7          	jalr	770(ra) # 800040fa <readi>
    80005e00:	47c1                	li	a5,16
    80005e02:	00f51c63          	bne	a0,a5,80005e1a <sys_unlink+0x176>
    if(de.inum != 0)
    80005e06:	f1845783          	lhu	a5,-232(s0)
    80005e0a:	e7b5                	bnez	a5,80005e76 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005e0c:	29c1                	addiw	s3,s3,16
    80005e0e:	04c92783          	lw	a5,76(s2)
    80005e12:	fcf9ede3          	bltu	s3,a5,80005dec <sys_unlink+0x148>
    80005e16:	69ae                	ld	s3,200(sp)
    80005e18:	bf15                	j	80005d4c <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80005e1a:	00003517          	auipc	a0,0x3
    80005e1e:	92650513          	addi	a0,a0,-1754 # 80008740 <__func__.1+0x738>
    80005e22:	ffffa097          	auipc	ra,0xffffa
    80005e26:	73e080e7          	jalr	1854(ra) # 80000560 <panic>
    80005e2a:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80005e2c:	00003517          	auipc	a0,0x3
    80005e30:	92c50513          	addi	a0,a0,-1748 # 80008758 <__func__.1+0x750>
    80005e34:	ffffa097          	auipc	ra,0xffffa
    80005e38:	72c080e7          	jalr	1836(ra) # 80000560 <panic>
    dp->nlink--;
    80005e3c:	04a4d783          	lhu	a5,74(s1)
    80005e40:	37fd                	addiw	a5,a5,-1
    80005e42:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005e46:	8526                	mv	a0,s1
    80005e48:	ffffe097          	auipc	ra,0xffffe
    80005e4c:	f2e080e7          	jalr	-210(ra) # 80003d76 <iupdate>
    80005e50:	bf0d                	j	80005d82 <sys_unlink+0xde>
    80005e52:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80005e54:	8526                	mv	a0,s1
    80005e56:	ffffe097          	auipc	ra,0xffffe
    80005e5a:	252080e7          	jalr	594(ra) # 800040a8 <iunlockput>
  end_op();
    80005e5e:	fffff097          	auipc	ra,0xfffff
    80005e62:	a2c080e7          	jalr	-1492(ra) # 8000488a <end_op>
  return -1;
    80005e66:	557d                	li	a0,-1
    80005e68:	64ee                	ld	s1,216(sp)
}
    80005e6a:	70ae                	ld	ra,232(sp)
    80005e6c:	740e                	ld	s0,224(sp)
    80005e6e:	616d                	addi	sp,sp,240
    80005e70:	8082                	ret
    return -1;
    80005e72:	557d                	li	a0,-1
    80005e74:	bfdd                	j	80005e6a <sys_unlink+0x1c6>
    iunlockput(ip);
    80005e76:	854a                	mv	a0,s2
    80005e78:	ffffe097          	auipc	ra,0xffffe
    80005e7c:	230080e7          	jalr	560(ra) # 800040a8 <iunlockput>
    goto bad;
    80005e80:	694e                	ld	s2,208(sp)
    80005e82:	69ae                	ld	s3,200(sp)
    80005e84:	bfc1                	j	80005e54 <sys_unlink+0x1b0>

0000000080005e86 <sys_open>:

uint64
sys_open(void)
{
    80005e86:	7131                	addi	sp,sp,-192
    80005e88:	fd06                	sd	ra,184(sp)
    80005e8a:	f922                	sd	s0,176(sp)
    80005e8c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005e8e:	f4c40593          	addi	a1,s0,-180
    80005e92:	4505                	li	a0,1
    80005e94:	ffffd097          	auipc	ra,0xffffd
    80005e98:	2d0080e7          	jalr	720(ra) # 80003164 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005e9c:	08000613          	li	a2,128
    80005ea0:	f5040593          	addi	a1,s0,-176
    80005ea4:	4501                	li	a0,0
    80005ea6:	ffffd097          	auipc	ra,0xffffd
    80005eaa:	2fe080e7          	jalr	766(ra) # 800031a4 <argstr>
    80005eae:	87aa                	mv	a5,a0
    return -1;
    80005eb0:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005eb2:	0a07ce63          	bltz	a5,80005f6e <sys_open+0xe8>
    80005eb6:	f526                	sd	s1,168(sp)

  begin_op();
    80005eb8:	fffff097          	auipc	ra,0xfffff
    80005ebc:	958080e7          	jalr	-1704(ra) # 80004810 <begin_op>

  if(omode & O_CREATE){
    80005ec0:	f4c42783          	lw	a5,-180(s0)
    80005ec4:	2007f793          	andi	a5,a5,512
    80005ec8:	cfd5                	beqz	a5,80005f84 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005eca:	4681                	li	a3,0
    80005ecc:	4601                	li	a2,0
    80005ece:	4589                	li	a1,2
    80005ed0:	f5040513          	addi	a0,s0,-176
    80005ed4:	00000097          	auipc	ra,0x0
    80005ed8:	95c080e7          	jalr	-1700(ra) # 80005830 <create>
    80005edc:	84aa                	mv	s1,a0
    if(ip == 0){
    80005ede:	cd41                	beqz	a0,80005f76 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005ee0:	04449703          	lh	a4,68(s1)
    80005ee4:	478d                	li	a5,3
    80005ee6:	00f71763          	bne	a4,a5,80005ef4 <sys_open+0x6e>
    80005eea:	0464d703          	lhu	a4,70(s1)
    80005eee:	47a5                	li	a5,9
    80005ef0:	0ee7e163          	bltu	a5,a4,80005fd2 <sys_open+0x14c>
    80005ef4:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005ef6:	fffff097          	auipc	ra,0xfffff
    80005efa:	d28080e7          	jalr	-728(ra) # 80004c1e <filealloc>
    80005efe:	892a                	mv	s2,a0
    80005f00:	c97d                	beqz	a0,80005ff6 <sys_open+0x170>
    80005f02:	ed4e                	sd	s3,152(sp)
    80005f04:	00000097          	auipc	ra,0x0
    80005f08:	8ea080e7          	jalr	-1814(ra) # 800057ee <fdalloc>
    80005f0c:	89aa                	mv	s3,a0
    80005f0e:	0c054e63          	bltz	a0,80005fea <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005f12:	04449703          	lh	a4,68(s1)
    80005f16:	478d                	li	a5,3
    80005f18:	0ef70c63          	beq	a4,a5,80006010 <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005f1c:	4789                	li	a5,2
    80005f1e:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005f22:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005f26:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005f2a:	f4c42783          	lw	a5,-180(s0)
    80005f2e:	0017c713          	xori	a4,a5,1
    80005f32:	8b05                	andi	a4,a4,1
    80005f34:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005f38:	0037f713          	andi	a4,a5,3
    80005f3c:	00e03733          	snez	a4,a4
    80005f40:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005f44:	4007f793          	andi	a5,a5,1024
    80005f48:	c791                	beqz	a5,80005f54 <sys_open+0xce>
    80005f4a:	04449703          	lh	a4,68(s1)
    80005f4e:	4789                	li	a5,2
    80005f50:	0cf70763          	beq	a4,a5,8000601e <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    80005f54:	8526                	mv	a0,s1
    80005f56:	ffffe097          	auipc	ra,0xffffe
    80005f5a:	fb2080e7          	jalr	-78(ra) # 80003f08 <iunlock>
  end_op();
    80005f5e:	fffff097          	auipc	ra,0xfffff
    80005f62:	92c080e7          	jalr	-1748(ra) # 8000488a <end_op>

  return fd;
    80005f66:	854e                	mv	a0,s3
    80005f68:	74aa                	ld	s1,168(sp)
    80005f6a:	790a                	ld	s2,160(sp)
    80005f6c:	69ea                	ld	s3,152(sp)
}
    80005f6e:	70ea                	ld	ra,184(sp)
    80005f70:	744a                	ld	s0,176(sp)
    80005f72:	6129                	addi	sp,sp,192
    80005f74:	8082                	ret
      end_op();
    80005f76:	fffff097          	auipc	ra,0xfffff
    80005f7a:	914080e7          	jalr	-1772(ra) # 8000488a <end_op>
      return -1;
    80005f7e:	557d                	li	a0,-1
    80005f80:	74aa                	ld	s1,168(sp)
    80005f82:	b7f5                	j	80005f6e <sys_open+0xe8>
    if((ip = namei(path)) == 0){
    80005f84:	f5040513          	addi	a0,s0,-176
    80005f88:	ffffe097          	auipc	ra,0xffffe
    80005f8c:	688080e7          	jalr	1672(ra) # 80004610 <namei>
    80005f90:	84aa                	mv	s1,a0
    80005f92:	c90d                	beqz	a0,80005fc4 <sys_open+0x13e>
    ilock(ip);
    80005f94:	ffffe097          	auipc	ra,0xffffe
    80005f98:	eae080e7          	jalr	-338(ra) # 80003e42 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005f9c:	04449703          	lh	a4,68(s1)
    80005fa0:	4785                	li	a5,1
    80005fa2:	f2f71fe3          	bne	a4,a5,80005ee0 <sys_open+0x5a>
    80005fa6:	f4c42783          	lw	a5,-180(s0)
    80005faa:	d7a9                	beqz	a5,80005ef4 <sys_open+0x6e>
      iunlockput(ip);
    80005fac:	8526                	mv	a0,s1
    80005fae:	ffffe097          	auipc	ra,0xffffe
    80005fb2:	0fa080e7          	jalr	250(ra) # 800040a8 <iunlockput>
      end_op();
    80005fb6:	fffff097          	auipc	ra,0xfffff
    80005fba:	8d4080e7          	jalr	-1836(ra) # 8000488a <end_op>
      return -1;
    80005fbe:	557d                	li	a0,-1
    80005fc0:	74aa                	ld	s1,168(sp)
    80005fc2:	b775                	j	80005f6e <sys_open+0xe8>
      end_op();
    80005fc4:	fffff097          	auipc	ra,0xfffff
    80005fc8:	8c6080e7          	jalr	-1850(ra) # 8000488a <end_op>
      return -1;
    80005fcc:	557d                	li	a0,-1
    80005fce:	74aa                	ld	s1,168(sp)
    80005fd0:	bf79                	j	80005f6e <sys_open+0xe8>
    iunlockput(ip);
    80005fd2:	8526                	mv	a0,s1
    80005fd4:	ffffe097          	auipc	ra,0xffffe
    80005fd8:	0d4080e7          	jalr	212(ra) # 800040a8 <iunlockput>
    end_op();
    80005fdc:	fffff097          	auipc	ra,0xfffff
    80005fe0:	8ae080e7          	jalr	-1874(ra) # 8000488a <end_op>
    return -1;
    80005fe4:	557d                	li	a0,-1
    80005fe6:	74aa                	ld	s1,168(sp)
    80005fe8:	b759                	j	80005f6e <sys_open+0xe8>
      fileclose(f);
    80005fea:	854a                	mv	a0,s2
    80005fec:	fffff097          	auipc	ra,0xfffff
    80005ff0:	cee080e7          	jalr	-786(ra) # 80004cda <fileclose>
    80005ff4:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005ff6:	8526                	mv	a0,s1
    80005ff8:	ffffe097          	auipc	ra,0xffffe
    80005ffc:	0b0080e7          	jalr	176(ra) # 800040a8 <iunlockput>
    end_op();
    80006000:	fffff097          	auipc	ra,0xfffff
    80006004:	88a080e7          	jalr	-1910(ra) # 8000488a <end_op>
    return -1;
    80006008:	557d                	li	a0,-1
    8000600a:	74aa                	ld	s1,168(sp)
    8000600c:	790a                	ld	s2,160(sp)
    8000600e:	b785                	j	80005f6e <sys_open+0xe8>
    f->type = FD_DEVICE;
    80006010:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80006014:	04649783          	lh	a5,70(s1)
    80006018:	02f91223          	sh	a5,36(s2)
    8000601c:	b729                	j	80005f26 <sys_open+0xa0>
    itrunc(ip);
    8000601e:	8526                	mv	a0,s1
    80006020:	ffffe097          	auipc	ra,0xffffe
    80006024:	f34080e7          	jalr	-204(ra) # 80003f54 <itrunc>
    80006028:	b735                	j	80005f54 <sys_open+0xce>

000000008000602a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000602a:	7175                	addi	sp,sp,-144
    8000602c:	e506                	sd	ra,136(sp)
    8000602e:	e122                	sd	s0,128(sp)
    80006030:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80006032:	ffffe097          	auipc	ra,0xffffe
    80006036:	7de080e7          	jalr	2014(ra) # 80004810 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000603a:	08000613          	li	a2,128
    8000603e:	f7040593          	addi	a1,s0,-144
    80006042:	4501                	li	a0,0
    80006044:	ffffd097          	auipc	ra,0xffffd
    80006048:	160080e7          	jalr	352(ra) # 800031a4 <argstr>
    8000604c:	02054963          	bltz	a0,8000607e <sys_mkdir+0x54>
    80006050:	4681                	li	a3,0
    80006052:	4601                	li	a2,0
    80006054:	4585                	li	a1,1
    80006056:	f7040513          	addi	a0,s0,-144
    8000605a:	fffff097          	auipc	ra,0xfffff
    8000605e:	7d6080e7          	jalr	2006(ra) # 80005830 <create>
    80006062:	cd11                	beqz	a0,8000607e <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80006064:	ffffe097          	auipc	ra,0xffffe
    80006068:	044080e7          	jalr	68(ra) # 800040a8 <iunlockput>
  end_op();
    8000606c:	fffff097          	auipc	ra,0xfffff
    80006070:	81e080e7          	jalr	-2018(ra) # 8000488a <end_op>
  return 0;
    80006074:	4501                	li	a0,0
}
    80006076:	60aa                	ld	ra,136(sp)
    80006078:	640a                	ld	s0,128(sp)
    8000607a:	6149                	addi	sp,sp,144
    8000607c:	8082                	ret
    end_op();
    8000607e:	fffff097          	auipc	ra,0xfffff
    80006082:	80c080e7          	jalr	-2036(ra) # 8000488a <end_op>
    return -1;
    80006086:	557d                	li	a0,-1
    80006088:	b7fd                	j	80006076 <sys_mkdir+0x4c>

000000008000608a <sys_mknod>:

uint64
sys_mknod(void)
{
    8000608a:	7135                	addi	sp,sp,-160
    8000608c:	ed06                	sd	ra,152(sp)
    8000608e:	e922                	sd	s0,144(sp)
    80006090:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80006092:	ffffe097          	auipc	ra,0xffffe
    80006096:	77e080e7          	jalr	1918(ra) # 80004810 <begin_op>
  argint(1, &major);
    8000609a:	f6c40593          	addi	a1,s0,-148
    8000609e:	4505                	li	a0,1
    800060a0:	ffffd097          	auipc	ra,0xffffd
    800060a4:	0c4080e7          	jalr	196(ra) # 80003164 <argint>
  argint(2, &minor);
    800060a8:	f6840593          	addi	a1,s0,-152
    800060ac:	4509                	li	a0,2
    800060ae:	ffffd097          	auipc	ra,0xffffd
    800060b2:	0b6080e7          	jalr	182(ra) # 80003164 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800060b6:	08000613          	li	a2,128
    800060ba:	f7040593          	addi	a1,s0,-144
    800060be:	4501                	li	a0,0
    800060c0:	ffffd097          	auipc	ra,0xffffd
    800060c4:	0e4080e7          	jalr	228(ra) # 800031a4 <argstr>
    800060c8:	02054b63          	bltz	a0,800060fe <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800060cc:	f6841683          	lh	a3,-152(s0)
    800060d0:	f6c41603          	lh	a2,-148(s0)
    800060d4:	458d                	li	a1,3
    800060d6:	f7040513          	addi	a0,s0,-144
    800060da:	fffff097          	auipc	ra,0xfffff
    800060de:	756080e7          	jalr	1878(ra) # 80005830 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800060e2:	cd11                	beqz	a0,800060fe <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800060e4:	ffffe097          	auipc	ra,0xffffe
    800060e8:	fc4080e7          	jalr	-60(ra) # 800040a8 <iunlockput>
  end_op();
    800060ec:	ffffe097          	auipc	ra,0xffffe
    800060f0:	79e080e7          	jalr	1950(ra) # 8000488a <end_op>
  return 0;
    800060f4:	4501                	li	a0,0
}
    800060f6:	60ea                	ld	ra,152(sp)
    800060f8:	644a                	ld	s0,144(sp)
    800060fa:	610d                	addi	sp,sp,160
    800060fc:	8082                	ret
    end_op();
    800060fe:	ffffe097          	auipc	ra,0xffffe
    80006102:	78c080e7          	jalr	1932(ra) # 8000488a <end_op>
    return -1;
    80006106:	557d                	li	a0,-1
    80006108:	b7fd                	j	800060f6 <sys_mknod+0x6c>

000000008000610a <sys_chdir>:

uint64
sys_chdir(void)
{
    8000610a:	7135                	addi	sp,sp,-160
    8000610c:	ed06                	sd	ra,152(sp)
    8000610e:	e922                	sd	s0,144(sp)
    80006110:	e14a                	sd	s2,128(sp)
    80006112:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80006114:	ffffc097          	auipc	ra,0xffffc
    80006118:	c78080e7          	jalr	-904(ra) # 80001d8c <myproc>
    8000611c:	892a                	mv	s2,a0
  
  begin_op();
    8000611e:	ffffe097          	auipc	ra,0xffffe
    80006122:	6f2080e7          	jalr	1778(ra) # 80004810 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80006126:	08000613          	li	a2,128
    8000612a:	f6040593          	addi	a1,s0,-160
    8000612e:	4501                	li	a0,0
    80006130:	ffffd097          	auipc	ra,0xffffd
    80006134:	074080e7          	jalr	116(ra) # 800031a4 <argstr>
    80006138:	04054d63          	bltz	a0,80006192 <sys_chdir+0x88>
    8000613c:	e526                	sd	s1,136(sp)
    8000613e:	f6040513          	addi	a0,s0,-160
    80006142:	ffffe097          	auipc	ra,0xffffe
    80006146:	4ce080e7          	jalr	1230(ra) # 80004610 <namei>
    8000614a:	84aa                	mv	s1,a0
    8000614c:	c131                	beqz	a0,80006190 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    8000614e:	ffffe097          	auipc	ra,0xffffe
    80006152:	cf4080e7          	jalr	-780(ra) # 80003e42 <ilock>
  if(ip->type != T_DIR){
    80006156:	04449703          	lh	a4,68(s1)
    8000615a:	4785                	li	a5,1
    8000615c:	04f71163          	bne	a4,a5,8000619e <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80006160:	8526                	mv	a0,s1
    80006162:	ffffe097          	auipc	ra,0xffffe
    80006166:	da6080e7          	jalr	-602(ra) # 80003f08 <iunlock>
  iput(p->cwd);
    8000616a:	15093503          	ld	a0,336(s2)
    8000616e:	ffffe097          	auipc	ra,0xffffe
    80006172:	e92080e7          	jalr	-366(ra) # 80004000 <iput>
  end_op();
    80006176:	ffffe097          	auipc	ra,0xffffe
    8000617a:	714080e7          	jalr	1812(ra) # 8000488a <end_op>
  p->cwd = ip;
    8000617e:	14993823          	sd	s1,336(s2)
  return 0;
    80006182:	4501                	li	a0,0
    80006184:	64aa                	ld	s1,136(sp)
}
    80006186:	60ea                	ld	ra,152(sp)
    80006188:	644a                	ld	s0,144(sp)
    8000618a:	690a                	ld	s2,128(sp)
    8000618c:	610d                	addi	sp,sp,160
    8000618e:	8082                	ret
    80006190:	64aa                	ld	s1,136(sp)
    end_op();
    80006192:	ffffe097          	auipc	ra,0xffffe
    80006196:	6f8080e7          	jalr	1784(ra) # 8000488a <end_op>
    return -1;
    8000619a:	557d                	li	a0,-1
    8000619c:	b7ed                	j	80006186 <sys_chdir+0x7c>
    iunlockput(ip);
    8000619e:	8526                	mv	a0,s1
    800061a0:	ffffe097          	auipc	ra,0xffffe
    800061a4:	f08080e7          	jalr	-248(ra) # 800040a8 <iunlockput>
    end_op();
    800061a8:	ffffe097          	auipc	ra,0xffffe
    800061ac:	6e2080e7          	jalr	1762(ra) # 8000488a <end_op>
    return -1;
    800061b0:	557d                	li	a0,-1
    800061b2:	64aa                	ld	s1,136(sp)
    800061b4:	bfc9                	j	80006186 <sys_chdir+0x7c>

00000000800061b6 <sys_exec>:

uint64
sys_exec(void)
{
    800061b6:	7121                	addi	sp,sp,-448
    800061b8:	ff06                	sd	ra,440(sp)
    800061ba:	fb22                	sd	s0,432(sp)
    800061bc:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800061be:	e4840593          	addi	a1,s0,-440
    800061c2:	4505                	li	a0,1
    800061c4:	ffffd097          	auipc	ra,0xffffd
    800061c8:	fc0080e7          	jalr	-64(ra) # 80003184 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800061cc:	08000613          	li	a2,128
    800061d0:	f5040593          	addi	a1,s0,-176
    800061d4:	4501                	li	a0,0
    800061d6:	ffffd097          	auipc	ra,0xffffd
    800061da:	fce080e7          	jalr	-50(ra) # 800031a4 <argstr>
    800061de:	87aa                	mv	a5,a0
    return -1;
    800061e0:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800061e2:	0e07c263          	bltz	a5,800062c6 <sys_exec+0x110>
    800061e6:	f726                	sd	s1,424(sp)
    800061e8:	f34a                	sd	s2,416(sp)
    800061ea:	ef4e                	sd	s3,408(sp)
    800061ec:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800061ee:	10000613          	li	a2,256
    800061f2:	4581                	li	a1,0
    800061f4:	e5040513          	addi	a0,s0,-432
    800061f8:	ffffb097          	auipc	ra,0xffffb
    800061fc:	d9c080e7          	jalr	-612(ra) # 80000f94 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80006200:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80006204:	89a6                	mv	s3,s1
    80006206:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80006208:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000620c:	00391513          	slli	a0,s2,0x3
    80006210:	e4040593          	addi	a1,s0,-448
    80006214:	e4843783          	ld	a5,-440(s0)
    80006218:	953e                	add	a0,a0,a5
    8000621a:	ffffd097          	auipc	ra,0xffffd
    8000621e:	eac080e7          	jalr	-340(ra) # 800030c6 <fetchaddr>
    80006222:	02054a63          	bltz	a0,80006256 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80006226:	e4043783          	ld	a5,-448(s0)
    8000622a:	c7b9                	beqz	a5,80006278 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000622c:	ffffb097          	auipc	ra,0xffffb
    80006230:	9f6080e7          	jalr	-1546(ra) # 80000c22 <kalloc>
    80006234:	85aa                	mv	a1,a0
    80006236:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000623a:	cd11                	beqz	a0,80006256 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000623c:	6605                	lui	a2,0x1
    8000623e:	e4043503          	ld	a0,-448(s0)
    80006242:	ffffd097          	auipc	ra,0xffffd
    80006246:	ed6080e7          	jalr	-298(ra) # 80003118 <fetchstr>
    8000624a:	00054663          	bltz	a0,80006256 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    8000624e:	0905                	addi	s2,s2,1
    80006250:	09a1                	addi	s3,s3,8
    80006252:	fb491de3          	bne	s2,s4,8000620c <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006256:	f5040913          	addi	s2,s0,-176
    8000625a:	6088                	ld	a0,0(s1)
    8000625c:	c125                	beqz	a0,800062bc <sys_exec+0x106>
    kfree(argv[i]);
    8000625e:	ffffa097          	auipc	ra,0xffffa
    80006262:	7fe080e7          	jalr	2046(ra) # 80000a5c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006266:	04a1                	addi	s1,s1,8
    80006268:	ff2499e3          	bne	s1,s2,8000625a <sys_exec+0xa4>
  return -1;
    8000626c:	557d                	li	a0,-1
    8000626e:	74ba                	ld	s1,424(sp)
    80006270:	791a                	ld	s2,416(sp)
    80006272:	69fa                	ld	s3,408(sp)
    80006274:	6a5a                	ld	s4,400(sp)
    80006276:	a881                	j	800062c6 <sys_exec+0x110>
      argv[i] = 0;
    80006278:	0009079b          	sext.w	a5,s2
    8000627c:	078e                	slli	a5,a5,0x3
    8000627e:	fd078793          	addi	a5,a5,-48
    80006282:	97a2                	add	a5,a5,s0
    80006284:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80006288:	e5040593          	addi	a1,s0,-432
    8000628c:	f5040513          	addi	a0,s0,-176
    80006290:	fffff097          	auipc	ra,0xfffff
    80006294:	120080e7          	jalr	288(ra) # 800053b0 <exec>
    80006298:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000629a:	f5040993          	addi	s3,s0,-176
    8000629e:	6088                	ld	a0,0(s1)
    800062a0:	c901                	beqz	a0,800062b0 <sys_exec+0xfa>
    kfree(argv[i]);
    800062a2:	ffffa097          	auipc	ra,0xffffa
    800062a6:	7ba080e7          	jalr	1978(ra) # 80000a5c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800062aa:	04a1                	addi	s1,s1,8
    800062ac:	ff3499e3          	bne	s1,s3,8000629e <sys_exec+0xe8>
  return ret;
    800062b0:	854a                	mv	a0,s2
    800062b2:	74ba                	ld	s1,424(sp)
    800062b4:	791a                	ld	s2,416(sp)
    800062b6:	69fa                	ld	s3,408(sp)
    800062b8:	6a5a                	ld	s4,400(sp)
    800062ba:	a031                	j	800062c6 <sys_exec+0x110>
  return -1;
    800062bc:	557d                	li	a0,-1
    800062be:	74ba                	ld	s1,424(sp)
    800062c0:	791a                	ld	s2,416(sp)
    800062c2:	69fa                	ld	s3,408(sp)
    800062c4:	6a5a                	ld	s4,400(sp)
}
    800062c6:	70fa                	ld	ra,440(sp)
    800062c8:	745a                	ld	s0,432(sp)
    800062ca:	6139                	addi	sp,sp,448
    800062cc:	8082                	ret

00000000800062ce <sys_pipe>:

uint64
sys_pipe(void)
{
    800062ce:	7139                	addi	sp,sp,-64
    800062d0:	fc06                	sd	ra,56(sp)
    800062d2:	f822                	sd	s0,48(sp)
    800062d4:	f426                	sd	s1,40(sp)
    800062d6:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800062d8:	ffffc097          	auipc	ra,0xffffc
    800062dc:	ab4080e7          	jalr	-1356(ra) # 80001d8c <myproc>
    800062e0:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800062e2:	fd840593          	addi	a1,s0,-40
    800062e6:	4501                	li	a0,0
    800062e8:	ffffd097          	auipc	ra,0xffffd
    800062ec:	e9c080e7          	jalr	-356(ra) # 80003184 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800062f0:	fc840593          	addi	a1,s0,-56
    800062f4:	fd040513          	addi	a0,s0,-48
    800062f8:	fffff097          	auipc	ra,0xfffff
    800062fc:	d50080e7          	jalr	-688(ra) # 80005048 <pipealloc>
    return -1;
    80006300:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80006302:	0c054463          	bltz	a0,800063ca <sys_pipe+0xfc>
  fd0 = -1;
    80006306:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000630a:	fd043503          	ld	a0,-48(s0)
    8000630e:	fffff097          	auipc	ra,0xfffff
    80006312:	4e0080e7          	jalr	1248(ra) # 800057ee <fdalloc>
    80006316:	fca42223          	sw	a0,-60(s0)
    8000631a:	08054b63          	bltz	a0,800063b0 <sys_pipe+0xe2>
    8000631e:	fc843503          	ld	a0,-56(s0)
    80006322:	fffff097          	auipc	ra,0xfffff
    80006326:	4cc080e7          	jalr	1228(ra) # 800057ee <fdalloc>
    8000632a:	fca42023          	sw	a0,-64(s0)
    8000632e:	06054863          	bltz	a0,8000639e <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006332:	4691                	li	a3,4
    80006334:	fc440613          	addi	a2,s0,-60
    80006338:	fd843583          	ld	a1,-40(s0)
    8000633c:	68a8                	ld	a0,80(s1)
    8000633e:	ffffb097          	auipc	ra,0xffffb
    80006342:	5f2080e7          	jalr	1522(ra) # 80001930 <copyout>
    80006346:	02054063          	bltz	a0,80006366 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000634a:	4691                	li	a3,4
    8000634c:	fc040613          	addi	a2,s0,-64
    80006350:	fd843583          	ld	a1,-40(s0)
    80006354:	0591                	addi	a1,a1,4
    80006356:	68a8                	ld	a0,80(s1)
    80006358:	ffffb097          	auipc	ra,0xffffb
    8000635c:	5d8080e7          	jalr	1496(ra) # 80001930 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80006360:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006362:	06055463          	bgez	a0,800063ca <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80006366:	fc442783          	lw	a5,-60(s0)
    8000636a:	07e9                	addi	a5,a5,26
    8000636c:	078e                	slli	a5,a5,0x3
    8000636e:	97a6                	add	a5,a5,s1
    80006370:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80006374:	fc042783          	lw	a5,-64(s0)
    80006378:	07e9                	addi	a5,a5,26
    8000637a:	078e                	slli	a5,a5,0x3
    8000637c:	94be                	add	s1,s1,a5
    8000637e:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80006382:	fd043503          	ld	a0,-48(s0)
    80006386:	fffff097          	auipc	ra,0xfffff
    8000638a:	954080e7          	jalr	-1708(ra) # 80004cda <fileclose>
    fileclose(wf);
    8000638e:	fc843503          	ld	a0,-56(s0)
    80006392:	fffff097          	auipc	ra,0xfffff
    80006396:	948080e7          	jalr	-1720(ra) # 80004cda <fileclose>
    return -1;
    8000639a:	57fd                	li	a5,-1
    8000639c:	a03d                	j	800063ca <sys_pipe+0xfc>
    if(fd0 >= 0)
    8000639e:	fc442783          	lw	a5,-60(s0)
    800063a2:	0007c763          	bltz	a5,800063b0 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    800063a6:	07e9                	addi	a5,a5,26
    800063a8:	078e                	slli	a5,a5,0x3
    800063aa:	97a6                	add	a5,a5,s1
    800063ac:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800063b0:	fd043503          	ld	a0,-48(s0)
    800063b4:	fffff097          	auipc	ra,0xfffff
    800063b8:	926080e7          	jalr	-1754(ra) # 80004cda <fileclose>
    fileclose(wf);
    800063bc:	fc843503          	ld	a0,-56(s0)
    800063c0:	fffff097          	auipc	ra,0xfffff
    800063c4:	91a080e7          	jalr	-1766(ra) # 80004cda <fileclose>
    return -1;
    800063c8:	57fd                	li	a5,-1
}
    800063ca:	853e                	mv	a0,a5
    800063cc:	70e2                	ld	ra,56(sp)
    800063ce:	7442                	ld	s0,48(sp)
    800063d0:	74a2                	ld	s1,40(sp)
    800063d2:	6121                	addi	sp,sp,64
    800063d4:	8082                	ret
	...

00000000800063e0 <kernelvec>:
    800063e0:	7111                	addi	sp,sp,-256
    800063e2:	e006                	sd	ra,0(sp)
    800063e4:	e40a                	sd	sp,8(sp)
    800063e6:	e80e                	sd	gp,16(sp)
    800063e8:	ec12                	sd	tp,24(sp)
    800063ea:	f016                	sd	t0,32(sp)
    800063ec:	f41a                	sd	t1,40(sp)
    800063ee:	f81e                	sd	t2,48(sp)
    800063f0:	fc22                	sd	s0,56(sp)
    800063f2:	e0a6                	sd	s1,64(sp)
    800063f4:	e4aa                	sd	a0,72(sp)
    800063f6:	e8ae                	sd	a1,80(sp)
    800063f8:	ecb2                	sd	a2,88(sp)
    800063fa:	f0b6                	sd	a3,96(sp)
    800063fc:	f4ba                	sd	a4,104(sp)
    800063fe:	f8be                	sd	a5,112(sp)
    80006400:	fcc2                	sd	a6,120(sp)
    80006402:	e146                	sd	a7,128(sp)
    80006404:	e54a                	sd	s2,136(sp)
    80006406:	e94e                	sd	s3,144(sp)
    80006408:	ed52                	sd	s4,152(sp)
    8000640a:	f156                	sd	s5,160(sp)
    8000640c:	f55a                	sd	s6,168(sp)
    8000640e:	f95e                	sd	s7,176(sp)
    80006410:	fd62                	sd	s8,184(sp)
    80006412:	e1e6                	sd	s9,192(sp)
    80006414:	e5ea                	sd	s10,200(sp)
    80006416:	e9ee                	sd	s11,208(sp)
    80006418:	edf2                	sd	t3,216(sp)
    8000641a:	f1f6                	sd	t4,224(sp)
    8000641c:	f5fa                	sd	t5,232(sp)
    8000641e:	f9fe                	sd	t6,240(sp)
    80006420:	b73fc0ef          	jal	80002f92 <kerneltrap>
    80006424:	6082                	ld	ra,0(sp)
    80006426:	6122                	ld	sp,8(sp)
    80006428:	61c2                	ld	gp,16(sp)
    8000642a:	7282                	ld	t0,32(sp)
    8000642c:	7322                	ld	t1,40(sp)
    8000642e:	73c2                	ld	t2,48(sp)
    80006430:	7462                	ld	s0,56(sp)
    80006432:	6486                	ld	s1,64(sp)
    80006434:	6526                	ld	a0,72(sp)
    80006436:	65c6                	ld	a1,80(sp)
    80006438:	6666                	ld	a2,88(sp)
    8000643a:	7686                	ld	a3,96(sp)
    8000643c:	7726                	ld	a4,104(sp)
    8000643e:	77c6                	ld	a5,112(sp)
    80006440:	7866                	ld	a6,120(sp)
    80006442:	688a                	ld	a7,128(sp)
    80006444:	692a                	ld	s2,136(sp)
    80006446:	69ca                	ld	s3,144(sp)
    80006448:	6a6a                	ld	s4,152(sp)
    8000644a:	7a8a                	ld	s5,160(sp)
    8000644c:	7b2a                	ld	s6,168(sp)
    8000644e:	7bca                	ld	s7,176(sp)
    80006450:	7c6a                	ld	s8,184(sp)
    80006452:	6c8e                	ld	s9,192(sp)
    80006454:	6d2e                	ld	s10,200(sp)
    80006456:	6dce                	ld	s11,208(sp)
    80006458:	6e6e                	ld	t3,216(sp)
    8000645a:	7e8e                	ld	t4,224(sp)
    8000645c:	7f2e                	ld	t5,232(sp)
    8000645e:	7fce                	ld	t6,240(sp)
    80006460:	6111                	addi	sp,sp,256
    80006462:	10200073          	sret
    80006466:	00000013          	nop
    8000646a:	00000013          	nop
    8000646e:	0001                	nop

0000000080006470 <timervec>:
    80006470:	34051573          	csrrw	a0,mscratch,a0
    80006474:	e10c                	sd	a1,0(a0)
    80006476:	e510                	sd	a2,8(a0)
    80006478:	e914                	sd	a3,16(a0)
    8000647a:	6d0c                	ld	a1,24(a0)
    8000647c:	7110                	ld	a2,32(a0)
    8000647e:	6194                	ld	a3,0(a1)
    80006480:	96b2                	add	a3,a3,a2
    80006482:	e194                	sd	a3,0(a1)
    80006484:	4589                	li	a1,2
    80006486:	14459073          	csrw	sip,a1
    8000648a:	6914                	ld	a3,16(a0)
    8000648c:	6510                	ld	a2,8(a0)
    8000648e:	610c                	ld	a1,0(a0)
    80006490:	34051573          	csrrw	a0,mscratch,a0
    80006494:	30200073          	mret
	...

000000008000649a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000649a:	1141                	addi	sp,sp,-16
    8000649c:	e422                	sd	s0,8(sp)
    8000649e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800064a0:	0c0007b7          	lui	a5,0xc000
    800064a4:	4705                	li	a4,1
    800064a6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800064a8:	0c0007b7          	lui	a5,0xc000
    800064ac:	c3d8                	sw	a4,4(a5)
}
    800064ae:	6422                	ld	s0,8(sp)
    800064b0:	0141                	addi	sp,sp,16
    800064b2:	8082                	ret

00000000800064b4 <plicinithart>:

void
plicinithart(void)
{
    800064b4:	1141                	addi	sp,sp,-16
    800064b6:	e406                	sd	ra,8(sp)
    800064b8:	e022                	sd	s0,0(sp)
    800064ba:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800064bc:	ffffc097          	auipc	ra,0xffffc
    800064c0:	8a4080e7          	jalr	-1884(ra) # 80001d60 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800064c4:	0085171b          	slliw	a4,a0,0x8
    800064c8:	0c0027b7          	lui	a5,0xc002
    800064cc:	97ba                	add	a5,a5,a4
    800064ce:	40200713          	li	a4,1026
    800064d2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800064d6:	00d5151b          	slliw	a0,a0,0xd
    800064da:	0c2017b7          	lui	a5,0xc201
    800064de:	97aa                	add	a5,a5,a0
    800064e0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800064e4:	60a2                	ld	ra,8(sp)
    800064e6:	6402                	ld	s0,0(sp)
    800064e8:	0141                	addi	sp,sp,16
    800064ea:	8082                	ret

00000000800064ec <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800064ec:	1141                	addi	sp,sp,-16
    800064ee:	e406                	sd	ra,8(sp)
    800064f0:	e022                	sd	s0,0(sp)
    800064f2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800064f4:	ffffc097          	auipc	ra,0xffffc
    800064f8:	86c080e7          	jalr	-1940(ra) # 80001d60 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800064fc:	00d5151b          	slliw	a0,a0,0xd
    80006500:	0c2017b7          	lui	a5,0xc201
    80006504:	97aa                	add	a5,a5,a0
  return irq;
}
    80006506:	43c8                	lw	a0,4(a5)
    80006508:	60a2                	ld	ra,8(sp)
    8000650a:	6402                	ld	s0,0(sp)
    8000650c:	0141                	addi	sp,sp,16
    8000650e:	8082                	ret

0000000080006510 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80006510:	1101                	addi	sp,sp,-32
    80006512:	ec06                	sd	ra,24(sp)
    80006514:	e822                	sd	s0,16(sp)
    80006516:	e426                	sd	s1,8(sp)
    80006518:	1000                	addi	s0,sp,32
    8000651a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000651c:	ffffc097          	auipc	ra,0xffffc
    80006520:	844080e7          	jalr	-1980(ra) # 80001d60 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006524:	00d5151b          	slliw	a0,a0,0xd
    80006528:	0c2017b7          	lui	a5,0xc201
    8000652c:	97aa                	add	a5,a5,a0
    8000652e:	c3c4                	sw	s1,4(a5)
}
    80006530:	60e2                	ld	ra,24(sp)
    80006532:	6442                	ld	s0,16(sp)
    80006534:	64a2                	ld	s1,8(sp)
    80006536:	6105                	addi	sp,sp,32
    80006538:	8082                	ret

000000008000653a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000653a:	1141                	addi	sp,sp,-16
    8000653c:	e406                	sd	ra,8(sp)
    8000653e:	e022                	sd	s0,0(sp)
    80006540:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80006542:	479d                	li	a5,7
    80006544:	04a7cc63          	blt	a5,a0,8000659c <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80006548:	0023e797          	auipc	a5,0x23e
    8000654c:	3a878793          	addi	a5,a5,936 # 802448f0 <disk>
    80006550:	97aa                	add	a5,a5,a0
    80006552:	0187c783          	lbu	a5,24(a5)
    80006556:	ebb9                	bnez	a5,800065ac <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006558:	00451693          	slli	a3,a0,0x4
    8000655c:	0023e797          	auipc	a5,0x23e
    80006560:	39478793          	addi	a5,a5,916 # 802448f0 <disk>
    80006564:	6398                	ld	a4,0(a5)
    80006566:	9736                	add	a4,a4,a3
    80006568:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    8000656c:	6398                	ld	a4,0(a5)
    8000656e:	9736                	add	a4,a4,a3
    80006570:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80006574:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006578:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    8000657c:	97aa                	add	a5,a5,a0
    8000657e:	4705                	li	a4,1
    80006580:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80006584:	0023e517          	auipc	a0,0x23e
    80006588:	38450513          	addi	a0,a0,900 # 80244908 <disk+0x18>
    8000658c:	ffffc097          	auipc	ra,0xffffc
    80006590:	016080e7          	jalr	22(ra) # 800025a2 <wakeup>
}
    80006594:	60a2                	ld	ra,8(sp)
    80006596:	6402                	ld	s0,0(sp)
    80006598:	0141                	addi	sp,sp,16
    8000659a:	8082                	ret
    panic("free_desc 1");
    8000659c:	00002517          	auipc	a0,0x2
    800065a0:	1cc50513          	addi	a0,a0,460 # 80008768 <__func__.1+0x760>
    800065a4:	ffffa097          	auipc	ra,0xffffa
    800065a8:	fbc080e7          	jalr	-68(ra) # 80000560 <panic>
    panic("free_desc 2");
    800065ac:	00002517          	auipc	a0,0x2
    800065b0:	1cc50513          	addi	a0,a0,460 # 80008778 <__func__.1+0x770>
    800065b4:	ffffa097          	auipc	ra,0xffffa
    800065b8:	fac080e7          	jalr	-84(ra) # 80000560 <panic>

00000000800065bc <virtio_disk_init>:
{
    800065bc:	1101                	addi	sp,sp,-32
    800065be:	ec06                	sd	ra,24(sp)
    800065c0:	e822                	sd	s0,16(sp)
    800065c2:	e426                	sd	s1,8(sp)
    800065c4:	e04a                	sd	s2,0(sp)
    800065c6:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800065c8:	00002597          	auipc	a1,0x2
    800065cc:	1c058593          	addi	a1,a1,448 # 80008788 <__func__.1+0x780>
    800065d0:	0023e517          	auipc	a0,0x23e
    800065d4:	44850513          	addi	a0,a0,1096 # 80244a18 <disk+0x128>
    800065d8:	ffffb097          	auipc	ra,0xffffb
    800065dc:	830080e7          	jalr	-2000(ra) # 80000e08 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800065e0:	100017b7          	lui	a5,0x10001
    800065e4:	4398                	lw	a4,0(a5)
    800065e6:	2701                	sext.w	a4,a4
    800065e8:	747277b7          	lui	a5,0x74727
    800065ec:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800065f0:	18f71c63          	bne	a4,a5,80006788 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800065f4:	100017b7          	lui	a5,0x10001
    800065f8:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800065fa:	439c                	lw	a5,0(a5)
    800065fc:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800065fe:	4709                	li	a4,2
    80006600:	18e79463          	bne	a5,a4,80006788 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006604:	100017b7          	lui	a5,0x10001
    80006608:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    8000660a:	439c                	lw	a5,0(a5)
    8000660c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000660e:	16e79d63          	bne	a5,a4,80006788 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80006612:	100017b7          	lui	a5,0x10001
    80006616:	47d8                	lw	a4,12(a5)
    80006618:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000661a:	554d47b7          	lui	a5,0x554d4
    8000661e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80006622:	16f71363          	bne	a4,a5,80006788 <virtio_disk_init+0x1cc>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006626:	100017b7          	lui	a5,0x10001
    8000662a:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000662e:	4705                	li	a4,1
    80006630:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006632:	470d                	li	a4,3
    80006634:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80006636:	10001737          	lui	a4,0x10001
    8000663a:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000663c:	c7ffe737          	lui	a4,0xc7ffe
    80006640:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47db9d2f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006644:	8ef9                	and	a3,a3,a4
    80006646:	10001737          	lui	a4,0x10001
    8000664a:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000664c:	472d                	li	a4,11
    8000664e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006650:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80006654:	439c                	lw	a5,0(a5)
    80006656:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000665a:	8ba1                	andi	a5,a5,8
    8000665c:	12078e63          	beqz	a5,80006798 <virtio_disk_init+0x1dc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006660:	100017b7          	lui	a5,0x10001
    80006664:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80006668:	100017b7          	lui	a5,0x10001
    8000666c:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80006670:	439c                	lw	a5,0(a5)
    80006672:	2781                	sext.w	a5,a5
    80006674:	12079a63          	bnez	a5,800067a8 <virtio_disk_init+0x1ec>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006678:	100017b7          	lui	a5,0x10001
    8000667c:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80006680:	439c                	lw	a5,0(a5)
    80006682:	2781                	sext.w	a5,a5
  if(max == 0)
    80006684:	12078a63          	beqz	a5,800067b8 <virtio_disk_init+0x1fc>
  if(max < NUM)
    80006688:	471d                	li	a4,7
    8000668a:	12f77f63          	bgeu	a4,a5,800067c8 <virtio_disk_init+0x20c>
  disk.desc = kalloc();
    8000668e:	ffffa097          	auipc	ra,0xffffa
    80006692:	594080e7          	jalr	1428(ra) # 80000c22 <kalloc>
    80006696:	0023e497          	auipc	s1,0x23e
    8000669a:	25a48493          	addi	s1,s1,602 # 802448f0 <disk>
    8000669e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800066a0:	ffffa097          	auipc	ra,0xffffa
    800066a4:	582080e7          	jalr	1410(ra) # 80000c22 <kalloc>
    800066a8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800066aa:	ffffa097          	auipc	ra,0xffffa
    800066ae:	578080e7          	jalr	1400(ra) # 80000c22 <kalloc>
    800066b2:	87aa                	mv	a5,a0
    800066b4:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800066b6:	6088                	ld	a0,0(s1)
    800066b8:	12050063          	beqz	a0,800067d8 <virtio_disk_init+0x21c>
    800066bc:	0023e717          	auipc	a4,0x23e
    800066c0:	23c73703          	ld	a4,572(a4) # 802448f8 <disk+0x8>
    800066c4:	10070a63          	beqz	a4,800067d8 <virtio_disk_init+0x21c>
    800066c8:	10078863          	beqz	a5,800067d8 <virtio_disk_init+0x21c>
  memset(disk.desc, 0, PGSIZE);
    800066cc:	6605                	lui	a2,0x1
    800066ce:	4581                	li	a1,0
    800066d0:	ffffb097          	auipc	ra,0xffffb
    800066d4:	8c4080e7          	jalr	-1852(ra) # 80000f94 <memset>
  memset(disk.avail, 0, PGSIZE);
    800066d8:	0023e497          	auipc	s1,0x23e
    800066dc:	21848493          	addi	s1,s1,536 # 802448f0 <disk>
    800066e0:	6605                	lui	a2,0x1
    800066e2:	4581                	li	a1,0
    800066e4:	6488                	ld	a0,8(s1)
    800066e6:	ffffb097          	auipc	ra,0xffffb
    800066ea:	8ae080e7          	jalr	-1874(ra) # 80000f94 <memset>
  memset(disk.used, 0, PGSIZE);
    800066ee:	6605                	lui	a2,0x1
    800066f0:	4581                	li	a1,0
    800066f2:	6888                	ld	a0,16(s1)
    800066f4:	ffffb097          	auipc	ra,0xffffb
    800066f8:	8a0080e7          	jalr	-1888(ra) # 80000f94 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800066fc:	100017b7          	lui	a5,0x10001
    80006700:	4721                	li	a4,8
    80006702:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006704:	4098                	lw	a4,0(s1)
    80006706:	100017b7          	lui	a5,0x10001
    8000670a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000670e:	40d8                	lw	a4,4(s1)
    80006710:	100017b7          	lui	a5,0x10001
    80006714:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80006718:	649c                	ld	a5,8(s1)
    8000671a:	0007869b          	sext.w	a3,a5
    8000671e:	10001737          	lui	a4,0x10001
    80006722:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80006726:	9781                	srai	a5,a5,0x20
    80006728:	10001737          	lui	a4,0x10001
    8000672c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80006730:	689c                	ld	a5,16(s1)
    80006732:	0007869b          	sext.w	a3,a5
    80006736:	10001737          	lui	a4,0x10001
    8000673a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000673e:	9781                	srai	a5,a5,0x20
    80006740:	10001737          	lui	a4,0x10001
    80006744:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80006748:	10001737          	lui	a4,0x10001
    8000674c:	4785                	li	a5,1
    8000674e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80006750:	00f48c23          	sb	a5,24(s1)
    80006754:	00f48ca3          	sb	a5,25(s1)
    80006758:	00f48d23          	sb	a5,26(s1)
    8000675c:	00f48da3          	sb	a5,27(s1)
    80006760:	00f48e23          	sb	a5,28(s1)
    80006764:	00f48ea3          	sb	a5,29(s1)
    80006768:	00f48f23          	sb	a5,30(s1)
    8000676c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006770:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006774:	100017b7          	lui	a5,0x10001
    80006778:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000677c:	60e2                	ld	ra,24(sp)
    8000677e:	6442                	ld	s0,16(sp)
    80006780:	64a2                	ld	s1,8(sp)
    80006782:	6902                	ld	s2,0(sp)
    80006784:	6105                	addi	sp,sp,32
    80006786:	8082                	ret
    panic("could not find virtio disk");
    80006788:	00002517          	auipc	a0,0x2
    8000678c:	01050513          	addi	a0,a0,16 # 80008798 <__func__.1+0x790>
    80006790:	ffffa097          	auipc	ra,0xffffa
    80006794:	dd0080e7          	jalr	-560(ra) # 80000560 <panic>
    panic("virtio disk FEATURES_OK unset");
    80006798:	00002517          	auipc	a0,0x2
    8000679c:	02050513          	addi	a0,a0,32 # 800087b8 <__func__.1+0x7b0>
    800067a0:	ffffa097          	auipc	ra,0xffffa
    800067a4:	dc0080e7          	jalr	-576(ra) # 80000560 <panic>
    panic("virtio disk should not be ready");
    800067a8:	00002517          	auipc	a0,0x2
    800067ac:	03050513          	addi	a0,a0,48 # 800087d8 <__func__.1+0x7d0>
    800067b0:	ffffa097          	auipc	ra,0xffffa
    800067b4:	db0080e7          	jalr	-592(ra) # 80000560 <panic>
    panic("virtio disk has no queue 0");
    800067b8:	00002517          	auipc	a0,0x2
    800067bc:	04050513          	addi	a0,a0,64 # 800087f8 <__func__.1+0x7f0>
    800067c0:	ffffa097          	auipc	ra,0xffffa
    800067c4:	da0080e7          	jalr	-608(ra) # 80000560 <panic>
    panic("virtio disk max queue too short");
    800067c8:	00002517          	auipc	a0,0x2
    800067cc:	05050513          	addi	a0,a0,80 # 80008818 <__func__.1+0x810>
    800067d0:	ffffa097          	auipc	ra,0xffffa
    800067d4:	d90080e7          	jalr	-624(ra) # 80000560 <panic>
    panic("virtio disk kalloc");
    800067d8:	00002517          	auipc	a0,0x2
    800067dc:	06050513          	addi	a0,a0,96 # 80008838 <__func__.1+0x830>
    800067e0:	ffffa097          	auipc	ra,0xffffa
    800067e4:	d80080e7          	jalr	-640(ra) # 80000560 <panic>

00000000800067e8 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800067e8:	7159                	addi	sp,sp,-112
    800067ea:	f486                	sd	ra,104(sp)
    800067ec:	f0a2                	sd	s0,96(sp)
    800067ee:	eca6                	sd	s1,88(sp)
    800067f0:	e8ca                	sd	s2,80(sp)
    800067f2:	e4ce                	sd	s3,72(sp)
    800067f4:	e0d2                	sd	s4,64(sp)
    800067f6:	fc56                	sd	s5,56(sp)
    800067f8:	f85a                	sd	s6,48(sp)
    800067fa:	f45e                	sd	s7,40(sp)
    800067fc:	f062                	sd	s8,32(sp)
    800067fe:	ec66                	sd	s9,24(sp)
    80006800:	1880                	addi	s0,sp,112
    80006802:	8a2a                	mv	s4,a0
    80006804:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006806:	00c52c83          	lw	s9,12(a0)
    8000680a:	001c9c9b          	slliw	s9,s9,0x1
    8000680e:	1c82                	slli	s9,s9,0x20
    80006810:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80006814:	0023e517          	auipc	a0,0x23e
    80006818:	20450513          	addi	a0,a0,516 # 80244a18 <disk+0x128>
    8000681c:	ffffa097          	auipc	ra,0xffffa
    80006820:	67c080e7          	jalr	1660(ra) # 80000e98 <acquire>
  for(int i = 0; i < 3; i++){
    80006824:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80006826:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006828:	0023eb17          	auipc	s6,0x23e
    8000682c:	0c8b0b13          	addi	s6,s6,200 # 802448f0 <disk>
  for(int i = 0; i < 3; i++){
    80006830:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006832:	0023ec17          	auipc	s8,0x23e
    80006836:	1e6c0c13          	addi	s8,s8,486 # 80244a18 <disk+0x128>
    8000683a:	a0ad                	j	800068a4 <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    8000683c:	00fb0733          	add	a4,s6,a5
    80006840:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80006844:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006846:	0207c563          	bltz	a5,80006870 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    8000684a:	2905                	addiw	s2,s2,1
    8000684c:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    8000684e:	05590f63          	beq	s2,s5,800068ac <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    80006852:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006854:	0023e717          	auipc	a4,0x23e
    80006858:	09c70713          	addi	a4,a4,156 # 802448f0 <disk>
    8000685c:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000685e:	01874683          	lbu	a3,24(a4)
    80006862:	fee9                	bnez	a3,8000683c <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    80006864:	2785                	addiw	a5,a5,1
    80006866:	0705                	addi	a4,a4,1
    80006868:	fe979be3          	bne	a5,s1,8000685e <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000686c:	57fd                	li	a5,-1
    8000686e:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80006870:	03205163          	blez	s2,80006892 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    80006874:	f9042503          	lw	a0,-112(s0)
    80006878:	00000097          	auipc	ra,0x0
    8000687c:	cc2080e7          	jalr	-830(ra) # 8000653a <free_desc>
      for(int j = 0; j < i; j++)
    80006880:	4785                	li	a5,1
    80006882:	0127d863          	bge	a5,s2,80006892 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    80006886:	f9442503          	lw	a0,-108(s0)
    8000688a:	00000097          	auipc	ra,0x0
    8000688e:	cb0080e7          	jalr	-848(ra) # 8000653a <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006892:	85e2                	mv	a1,s8
    80006894:	0023e517          	auipc	a0,0x23e
    80006898:	07450513          	addi	a0,a0,116 # 80244908 <disk+0x18>
    8000689c:	ffffc097          	auipc	ra,0xffffc
    800068a0:	ca2080e7          	jalr	-862(ra) # 8000253e <sleep>
  for(int i = 0; i < 3; i++){
    800068a4:	f9040613          	addi	a2,s0,-112
    800068a8:	894e                	mv	s2,s3
    800068aa:	b765                	j	80006852 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800068ac:	f9042503          	lw	a0,-112(s0)
    800068b0:	00451693          	slli	a3,a0,0x4

  if(write)
    800068b4:	0023e797          	auipc	a5,0x23e
    800068b8:	03c78793          	addi	a5,a5,60 # 802448f0 <disk>
    800068bc:	00a50713          	addi	a4,a0,10
    800068c0:	0712                	slli	a4,a4,0x4
    800068c2:	973e                	add	a4,a4,a5
    800068c4:	01703633          	snez	a2,s7
    800068c8:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800068ca:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800068ce:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800068d2:	6398                	ld	a4,0(a5)
    800068d4:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800068d6:	0a868613          	addi	a2,a3,168
    800068da:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800068dc:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800068de:	6390                	ld	a2,0(a5)
    800068e0:	00d605b3          	add	a1,a2,a3
    800068e4:	4741                	li	a4,16
    800068e6:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800068e8:	4805                	li	a6,1
    800068ea:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    800068ee:	f9442703          	lw	a4,-108(s0)
    800068f2:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800068f6:	0712                	slli	a4,a4,0x4
    800068f8:	963a                	add	a2,a2,a4
    800068fa:	058a0593          	addi	a1,s4,88
    800068fe:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80006900:	0007b883          	ld	a7,0(a5)
    80006904:	9746                	add	a4,a4,a7
    80006906:	40000613          	li	a2,1024
    8000690a:	c710                	sw	a2,8(a4)
  if(write)
    8000690c:	001bb613          	seqz	a2,s7
    80006910:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006914:	00166613          	ori	a2,a2,1
    80006918:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    8000691c:	f9842583          	lw	a1,-104(s0)
    80006920:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006924:	00250613          	addi	a2,a0,2
    80006928:	0612                	slli	a2,a2,0x4
    8000692a:	963e                	add	a2,a2,a5
    8000692c:	577d                	li	a4,-1
    8000692e:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006932:	0592                	slli	a1,a1,0x4
    80006934:	98ae                	add	a7,a7,a1
    80006936:	03068713          	addi	a4,a3,48
    8000693a:	973e                	add	a4,a4,a5
    8000693c:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80006940:	6398                	ld	a4,0(a5)
    80006942:	972e                	add	a4,a4,a1
    80006944:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006948:	4689                	li	a3,2
    8000694a:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    8000694e:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006952:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80006956:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000695a:	6794                	ld	a3,8(a5)
    8000695c:	0026d703          	lhu	a4,2(a3)
    80006960:	8b1d                	andi	a4,a4,7
    80006962:	0706                	slli	a4,a4,0x1
    80006964:	96ba                	add	a3,a3,a4
    80006966:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000696a:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000696e:	6798                	ld	a4,8(a5)
    80006970:	00275783          	lhu	a5,2(a4)
    80006974:	2785                	addiw	a5,a5,1
    80006976:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000697a:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000697e:	100017b7          	lui	a5,0x10001
    80006982:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006986:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    8000698a:	0023e917          	auipc	s2,0x23e
    8000698e:	08e90913          	addi	s2,s2,142 # 80244a18 <disk+0x128>
  while(b->disk == 1) {
    80006992:	4485                	li	s1,1
    80006994:	01079c63          	bne	a5,a6,800069ac <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80006998:	85ca                	mv	a1,s2
    8000699a:	8552                	mv	a0,s4
    8000699c:	ffffc097          	auipc	ra,0xffffc
    800069a0:	ba2080e7          	jalr	-1118(ra) # 8000253e <sleep>
  while(b->disk == 1) {
    800069a4:	004a2783          	lw	a5,4(s4)
    800069a8:	fe9788e3          	beq	a5,s1,80006998 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800069ac:	f9042903          	lw	s2,-112(s0)
    800069b0:	00290713          	addi	a4,s2,2
    800069b4:	0712                	slli	a4,a4,0x4
    800069b6:	0023e797          	auipc	a5,0x23e
    800069ba:	f3a78793          	addi	a5,a5,-198 # 802448f0 <disk>
    800069be:	97ba                	add	a5,a5,a4
    800069c0:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800069c4:	0023e997          	auipc	s3,0x23e
    800069c8:	f2c98993          	addi	s3,s3,-212 # 802448f0 <disk>
    800069cc:	00491713          	slli	a4,s2,0x4
    800069d0:	0009b783          	ld	a5,0(s3)
    800069d4:	97ba                	add	a5,a5,a4
    800069d6:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800069da:	854a                	mv	a0,s2
    800069dc:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800069e0:	00000097          	auipc	ra,0x0
    800069e4:	b5a080e7          	jalr	-1190(ra) # 8000653a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800069e8:	8885                	andi	s1,s1,1
    800069ea:	f0ed                	bnez	s1,800069cc <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800069ec:	0023e517          	auipc	a0,0x23e
    800069f0:	02c50513          	addi	a0,a0,44 # 80244a18 <disk+0x128>
    800069f4:	ffffa097          	auipc	ra,0xffffa
    800069f8:	558080e7          	jalr	1368(ra) # 80000f4c <release>
}
    800069fc:	70a6                	ld	ra,104(sp)
    800069fe:	7406                	ld	s0,96(sp)
    80006a00:	64e6                	ld	s1,88(sp)
    80006a02:	6946                	ld	s2,80(sp)
    80006a04:	69a6                	ld	s3,72(sp)
    80006a06:	6a06                	ld	s4,64(sp)
    80006a08:	7ae2                	ld	s5,56(sp)
    80006a0a:	7b42                	ld	s6,48(sp)
    80006a0c:	7ba2                	ld	s7,40(sp)
    80006a0e:	7c02                	ld	s8,32(sp)
    80006a10:	6ce2                	ld	s9,24(sp)
    80006a12:	6165                	addi	sp,sp,112
    80006a14:	8082                	ret

0000000080006a16 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006a16:	1101                	addi	sp,sp,-32
    80006a18:	ec06                	sd	ra,24(sp)
    80006a1a:	e822                	sd	s0,16(sp)
    80006a1c:	e426                	sd	s1,8(sp)
    80006a1e:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006a20:	0023e497          	auipc	s1,0x23e
    80006a24:	ed048493          	addi	s1,s1,-304 # 802448f0 <disk>
    80006a28:	0023e517          	auipc	a0,0x23e
    80006a2c:	ff050513          	addi	a0,a0,-16 # 80244a18 <disk+0x128>
    80006a30:	ffffa097          	auipc	ra,0xffffa
    80006a34:	468080e7          	jalr	1128(ra) # 80000e98 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006a38:	100017b7          	lui	a5,0x10001
    80006a3c:	53b8                	lw	a4,96(a5)
    80006a3e:	8b0d                	andi	a4,a4,3
    80006a40:	100017b7          	lui	a5,0x10001
    80006a44:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80006a46:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006a4a:	689c                	ld	a5,16(s1)
    80006a4c:	0204d703          	lhu	a4,32(s1)
    80006a50:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80006a54:	04f70863          	beq	a4,a5,80006aa4 <virtio_disk_intr+0x8e>
    __sync_synchronize();
    80006a58:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006a5c:	6898                	ld	a4,16(s1)
    80006a5e:	0204d783          	lhu	a5,32(s1)
    80006a62:	8b9d                	andi	a5,a5,7
    80006a64:	078e                	slli	a5,a5,0x3
    80006a66:	97ba                	add	a5,a5,a4
    80006a68:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006a6a:	00278713          	addi	a4,a5,2
    80006a6e:	0712                	slli	a4,a4,0x4
    80006a70:	9726                	add	a4,a4,s1
    80006a72:	01074703          	lbu	a4,16(a4)
    80006a76:	e721                	bnez	a4,80006abe <virtio_disk_intr+0xa8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006a78:	0789                	addi	a5,a5,2
    80006a7a:	0792                	slli	a5,a5,0x4
    80006a7c:	97a6                	add	a5,a5,s1
    80006a7e:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80006a80:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006a84:	ffffc097          	auipc	ra,0xffffc
    80006a88:	b1e080e7          	jalr	-1250(ra) # 800025a2 <wakeup>

    disk.used_idx += 1;
    80006a8c:	0204d783          	lhu	a5,32(s1)
    80006a90:	2785                	addiw	a5,a5,1
    80006a92:	17c2                	slli	a5,a5,0x30
    80006a94:	93c1                	srli	a5,a5,0x30
    80006a96:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006a9a:	6898                	ld	a4,16(s1)
    80006a9c:	00275703          	lhu	a4,2(a4)
    80006aa0:	faf71ce3          	bne	a4,a5,80006a58 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    80006aa4:	0023e517          	auipc	a0,0x23e
    80006aa8:	f7450513          	addi	a0,a0,-140 # 80244a18 <disk+0x128>
    80006aac:	ffffa097          	auipc	ra,0xffffa
    80006ab0:	4a0080e7          	jalr	1184(ra) # 80000f4c <release>
}
    80006ab4:	60e2                	ld	ra,24(sp)
    80006ab6:	6442                	ld	s0,16(sp)
    80006ab8:	64a2                	ld	s1,8(sp)
    80006aba:	6105                	addi	sp,sp,32
    80006abc:	8082                	ret
      panic("virtio_disk_intr status");
    80006abe:	00002517          	auipc	a0,0x2
    80006ac2:	d9250513          	addi	a0,a0,-622 # 80008850 <__func__.1+0x848>
    80006ac6:	ffffa097          	auipc	ra,0xffffa
    80006aca:	a9a080e7          	jalr	-1382(ra) # 80000560 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
