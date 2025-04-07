
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	60013103          	ld	sp,1536(sp) # 8000b600 <_GLOBAL_OFFSET_TABLE_+0x8>
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
  asm volatile("csrr %0, mhartid" : "=r" (x) );
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
    80000054:	61070713          	addi	a4,a4,1552 # 8000b660 <timer_scratch>
    80000058:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005c:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000005e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000062:	00006797          	auipc	a5,0x6
    80000066:	4ae78793          	addi	a5,a5,1198 # 80006510 <timervec>
    8000006a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000072:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000076:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000007e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
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
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000094:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000098:	7779                	lui	a4,0xffffe
    8000009a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd94e7>
    8000009e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a0:	6705                	lui	a4,0x1
    800000a2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ac:	00001797          	auipc	a5,0x1
    800000b0:	e2678793          	addi	a5,a5,-474 # 80000ed2 <main>
    800000b4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b8:	4781                	li	a5,0
    800000ba:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000be:	67c1                	lui	a5,0x10
    800000c0:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000ca:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000ce:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d6:	57fd                	li	a5,-1
    800000d8:	83a9                	srli	a5,a5,0xa
    800000da:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000de:	47bd                	li	a5,15
    800000e0:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e4:	00000097          	auipc	ra,0x0
    800000e8:	f38080e7          	jalr	-200(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ec:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
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
    8000012e:	a28080e7          	jalr	-1496(ra) # 80002b52 <either_copyin>
    80000132:	03550463          	beq	a0,s5,8000015a <consolewrite+0x5a>
            break;
        uartputc(c);
    80000136:	fbf44503          	lbu	a0,-65(s0)
    8000013a:	00000097          	auipc	ra,0x0
    8000013e:	7e4080e7          	jalr	2020(ra) # 8000091e <uartputc>
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
    80000190:	61450513          	addi	a0,a0,1556 # 800137a0 <cons>
    80000194:	00001097          	auipc	ra,0x1
    80000198:	aa4080e7          	jalr	-1372(ra) # 80000c38 <acquire>
    while (n > 0)
    {
        // wait until interrupt handler has put some
        // input into cons.buffer.
        while (cons.r == cons.w)
    8000019c:	00013497          	auipc	s1,0x13
    800001a0:	60448493          	addi	s1,s1,1540 # 800137a0 <cons>
            if (killed(myproc()))
            {
                release(&cons.lock);
                return -1;
            }
            sleep(&cons.r, &cons.lock);
    800001a4:	00013917          	auipc	s2,0x13
    800001a8:	69490913          	addi	s2,s2,1684 # 80013838 <cons+0x98>
    while (n > 0)
    800001ac:	0d305763          	blez	s3,8000027a <consoleread+0x10c>
        while (cons.r == cons.w)
    800001b0:	0984a783          	lw	a5,152(s1)
    800001b4:	09c4a703          	lw	a4,156(s1)
    800001b8:	0af71c63          	bne	a4,a5,80000270 <consoleread+0x102>
            if (killed(myproc()))
    800001bc:	00002097          	auipc	ra,0x2
    800001c0:	8ac080e7          	jalr	-1876(ra) # 80001a68 <myproc>
    800001c4:	00002097          	auipc	ra,0x2
    800001c8:	7d8080e7          	jalr	2008(ra) # 8000299c <killed>
    800001cc:	e52d                	bnez	a0,80000236 <consoleread+0xc8>
            sleep(&cons.r, &cons.lock);
    800001ce:	85a6                	mv	a1,s1
    800001d0:	854a                	mv	a0,s2
    800001d2:	00002097          	auipc	ra,0x2
    800001d6:	522080e7          	jalr	1314(ra) # 800026f4 <sleep>
        while (cons.r == cons.w)
    800001da:	0984a783          	lw	a5,152(s1)
    800001de:	09c4a703          	lw	a4,156(s1)
    800001e2:	fcf70de3          	beq	a4,a5,800001bc <consoleread+0x4e>
    800001e6:	ec5e                	sd	s7,24(sp)
        }

        c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001e8:	00013717          	auipc	a4,0x13
    800001ec:	5b870713          	addi	a4,a4,1464 # 800137a0 <cons>
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
    8000021a:	00003097          	auipc	ra,0x3
    8000021e:	8e2080e7          	jalr	-1822(ra) # 80002afc <either_copyout>
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
    8000023a:	56a50513          	addi	a0,a0,1386 # 800137a0 <cons>
    8000023e:	00001097          	auipc	ra,0x1
    80000242:	aae080e7          	jalr	-1362(ra) # 80000cec <release>
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
    80000268:	5cf72a23          	sw	a5,1492(a4) # 80013838 <cons+0x98>
    8000026c:	6be2                	ld	s7,24(sp)
    8000026e:	a031                	j	8000027a <consoleread+0x10c>
    80000270:	ec5e                	sd	s7,24(sp)
    80000272:	bf9d                	j	800001e8 <consoleread+0x7a>
    80000274:	6be2                	ld	s7,24(sp)
    80000276:	a011                	j	8000027a <consoleread+0x10c>
    80000278:	6be2                	ld	s7,24(sp)
    release(&cons.lock);
    8000027a:	00013517          	auipc	a0,0x13
    8000027e:	52650513          	addi	a0,a0,1318 # 800137a0 <cons>
    80000282:	00001097          	auipc	ra,0x1
    80000286:	a6a080e7          	jalr	-1430(ra) # 80000cec <release>
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
    800002a8:	59c080e7          	jalr	1436(ra) # 80000840 <uartputc_sync>
}
    800002ac:	60a2                	ld	ra,8(sp)
    800002ae:	6402                	ld	s0,0(sp)
    800002b0:	0141                	addi	sp,sp,16
    800002b2:	8082                	ret
        uartputc_sync('\b');
    800002b4:	4521                	li	a0,8
    800002b6:	00000097          	auipc	ra,0x0
    800002ba:	58a080e7          	jalr	1418(ra) # 80000840 <uartputc_sync>
        uartputc_sync(' ');
    800002be:	02000513          	li	a0,32
    800002c2:	00000097          	auipc	ra,0x0
    800002c6:	57e080e7          	jalr	1406(ra) # 80000840 <uartputc_sync>
        uartputc_sync('\b');
    800002ca:	4521                	li	a0,8
    800002cc:	00000097          	auipc	ra,0x0
    800002d0:	574080e7          	jalr	1396(ra) # 80000840 <uartputc_sync>
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
    800002e6:	4be50513          	addi	a0,a0,1214 # 800137a0 <cons>
    800002ea:	00001097          	auipc	ra,0x1
    800002ee:	94e080e7          	jalr	-1714(ra) # 80000c38 <acquire>

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
    80000308:	00003097          	auipc	ra,0x3
    8000030c:	8a0080e7          	jalr	-1888(ra) # 80002ba8 <procdump>
            }
        }
        break;
    }

    release(&cons.lock);
    80000310:	00013517          	auipc	a0,0x13
    80000314:	49050513          	addi	a0,a0,1168 # 800137a0 <cons>
    80000318:	00001097          	auipc	ra,0x1
    8000031c:	9d4080e7          	jalr	-1580(ra) # 80000cec <release>
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
    80000336:	46e70713          	addi	a4,a4,1134 # 800137a0 <cons>
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
    80000360:	44478793          	addi	a5,a5,1092 # 800137a0 <cons>
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
    8000038e:	4ae7a783          	lw	a5,1198(a5) # 80013838 <cons+0x98>
    80000392:	9f1d                	subw	a4,a4,a5
    80000394:	08000793          	li	a5,128
    80000398:	f6f71ce3          	bne	a4,a5,80000310 <consoleintr+0x3a>
    8000039c:	a86d                	j	80000456 <consoleintr+0x180>
    8000039e:	e04a                	sd	s2,0(sp)
        while (cons.e != cons.w &&
    800003a0:	00013717          	auipc	a4,0x13
    800003a4:	40070713          	addi	a4,a4,1024 # 800137a0 <cons>
    800003a8:	0a072783          	lw	a5,160(a4)
    800003ac:	09c72703          	lw	a4,156(a4)
               cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n')
    800003b0:	00013497          	auipc	s1,0x13
    800003b4:	3f048493          	addi	s1,s1,1008 # 800137a0 <cons>
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
    800003fa:	3aa70713          	addi	a4,a4,938 # 800137a0 <cons>
    800003fe:	0a072783          	lw	a5,160(a4)
    80000402:	09c72703          	lw	a4,156(a4)
    80000406:	f0f705e3          	beq	a4,a5,80000310 <consoleintr+0x3a>
            cons.e--;
    8000040a:	37fd                	addiw	a5,a5,-1
    8000040c:	00013717          	auipc	a4,0x13
    80000410:	42f72a23          	sw	a5,1076(a4) # 80013840 <cons+0xa0>
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
    80000436:	36e78793          	addi	a5,a5,878 # 800137a0 <cons>
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
    8000045a:	3ec7a323          	sw	a2,998(a5) # 8001383c <cons+0x9c>
                wakeup(&cons.r);
    8000045e:	00013517          	auipc	a0,0x13
    80000462:	3da50513          	addi	a0,a0,986 # 80013838 <cons+0x98>
    80000466:	00002097          	auipc	ra,0x2
    8000046a:	2f2080e7          	jalr	754(ra) # 80002758 <wakeup>
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
    8000047c:	b8858593          	addi	a1,a1,-1144 # 80008000 <etext>
    80000480:	00013517          	auipc	a0,0x13
    80000484:	32050513          	addi	a0,a0,800 # 800137a0 <cons>
    80000488:	00000097          	auipc	ra,0x0
    8000048c:	720080e7          	jalr	1824(ra) # 80000ba8 <initlock>

    uartinit();
    80000490:	00000097          	auipc	ra,0x0
    80000494:	354080e7          	jalr	852(ra) # 800007e4 <uartinit>

    // connect read and write system calls
    // to consoleread and consolewrite.
    devsw[CONSOLE].read = consoleread;
    80000498:	00024797          	auipc	a5,0x24
    8000049c:	ce878793          	addi	a5,a5,-792 # 80024180 <devsw>
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

  if(sign && (sign = xx < 0))
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
  do {
    buf[i++] = digits[x % base];
    800004d4:	2581                	sext.w	a1,a1
    800004d6:	00008617          	auipc	a2,0x8
    800004da:	36a60613          	addi	a2,a2,874 # 80008840 <digits>
    800004de:	883a                	mv	a6,a4
    800004e0:	2705                	addiw	a4,a4,1
    800004e2:	02b577bb          	remuw	a5,a0,a1
    800004e6:	1782                	slli	a5,a5,0x20
    800004e8:	9381                	srli	a5,a5,0x20
    800004ea:	97b2                	add	a5,a5,a2
    800004ec:	0007c783          	lbu	a5,0(a5)
    800004f0:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004f4:	0005079b          	sext.w	a5,a0
    800004f8:	02b5553b          	divuw	a0,a0,a1
    800004fc:	0685                	addi	a3,a3,1
    800004fe:	feb7f0e3          	bgeu	a5,a1,800004de <printint+0x22>

  if(sign)
    80000502:	00088c63          	beqz	a7,8000051a <printint+0x5e>
    buf[i++] = '-';
    80000506:	fe070793          	addi	a5,a4,-32
    8000050a:	00878733          	add	a4,a5,s0
    8000050e:	02d00793          	li	a5,45
    80000512:	fef70823          	sb	a5,-16(a4)
    80000516:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
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
  while(--i >= 0)
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
  if(sign && (sign = xx < 0))
    8000055c:	4885                	li	a7,1
    x = -xx;
    8000055e:	bf85                	j	800004ce <printint+0x12>

0000000080000560 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80000560:	1101                	addi	sp,sp,-32
    80000562:	ec06                	sd	ra,24(sp)
    80000564:	e822                	sd	s0,16(sp)
    80000566:	e426                	sd	s1,8(sp)
    80000568:	1000                	addi	s0,sp,32
    8000056a:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000056c:	00013797          	auipc	a5,0x13
    80000570:	2e07aa23          	sw	zero,756(a5) # 80013860 <pr+0x18>
  printf("panic: ");
    80000574:	00008517          	auipc	a0,0x8
    80000578:	a9450513          	addi	a0,a0,-1388 # 80008008 <etext+0x8>
    8000057c:	00000097          	auipc	ra,0x0
    80000580:	02e080e7          	jalr	46(ra) # 800005aa <printf>
  printf(s);
    80000584:	8526                	mv	a0,s1
    80000586:	00000097          	auipc	ra,0x0
    8000058a:	024080e7          	jalr	36(ra) # 800005aa <printf>
  printf("\n");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	a8250513          	addi	a0,a0,-1406 # 80008010 <etext+0x10>
    80000596:	00000097          	auipc	ra,0x0
    8000059a:	014080e7          	jalr	20(ra) # 800005aa <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000059e:	4785                	li	a5,1
    800005a0:	0000b717          	auipc	a4,0xb
    800005a4:	08f72023          	sw	a5,128(a4) # 8000b620 <panicked>
  for(;;)
    800005a8:	a001                	j	800005a8 <panic+0x48>

00000000800005aa <printf>:
{
    800005aa:	7131                	addi	sp,sp,-192
    800005ac:	fc86                	sd	ra,120(sp)
    800005ae:	f8a2                	sd	s0,112(sp)
    800005b0:	e8d2                	sd	s4,80(sp)
    800005b2:	f06a                	sd	s10,32(sp)
    800005b4:	0100                	addi	s0,sp,128
    800005b6:	8a2a                	mv	s4,a0
    800005b8:	e40c                	sd	a1,8(s0)
    800005ba:	e810                	sd	a2,16(s0)
    800005bc:	ec14                	sd	a3,24(s0)
    800005be:	f018                	sd	a4,32(s0)
    800005c0:	f41c                	sd	a5,40(s0)
    800005c2:	03043823          	sd	a6,48(s0)
    800005c6:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005ca:	00013d17          	auipc	s10,0x13
    800005ce:	296d2d03          	lw	s10,662(s10) # 80013860 <pr+0x18>
  if(locking)
    800005d2:	040d1463          	bnez	s10,8000061a <printf+0x70>
  if (fmt == 0)
    800005d6:	040a0b63          	beqz	s4,8000062c <printf+0x82>
  va_start(ap, fmt);
    800005da:	00840793          	addi	a5,s0,8
    800005de:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005e2:	000a4503          	lbu	a0,0(s4)
    800005e6:	18050b63          	beqz	a0,8000077c <printf+0x1d2>
    800005ea:	f4a6                	sd	s1,104(sp)
    800005ec:	f0ca                	sd	s2,96(sp)
    800005ee:	ecce                	sd	s3,88(sp)
    800005f0:	e4d6                	sd	s5,72(sp)
    800005f2:	e0da                	sd	s6,64(sp)
    800005f4:	fc5e                	sd	s7,56(sp)
    800005f6:	f862                	sd	s8,48(sp)
    800005f8:	f466                	sd	s9,40(sp)
    800005fa:	ec6e                	sd	s11,24(sp)
    800005fc:	4981                	li	s3,0
    if(c != '%'){
    800005fe:	02500b13          	li	s6,37
    switch(c){
    80000602:	07000b93          	li	s7,112
  consputc('x');
    80000606:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000608:	00008a97          	auipc	s5,0x8
    8000060c:	238a8a93          	addi	s5,s5,568 # 80008840 <digits>
    switch(c){
    80000610:	07300c13          	li	s8,115
    80000614:	06400d93          	li	s11,100
    80000618:	a0b1                	j	80000664 <printf+0xba>
    acquire(&pr.lock);
    8000061a:	00013517          	auipc	a0,0x13
    8000061e:	22e50513          	addi	a0,a0,558 # 80013848 <pr>
    80000622:	00000097          	auipc	ra,0x0
    80000626:	616080e7          	jalr	1558(ra) # 80000c38 <acquire>
    8000062a:	b775                	j	800005d6 <printf+0x2c>
    8000062c:	f4a6                	sd	s1,104(sp)
    8000062e:	f0ca                	sd	s2,96(sp)
    80000630:	ecce                	sd	s3,88(sp)
    80000632:	e4d6                	sd	s5,72(sp)
    80000634:	e0da                	sd	s6,64(sp)
    80000636:	fc5e                	sd	s7,56(sp)
    80000638:	f862                	sd	s8,48(sp)
    8000063a:	f466                	sd	s9,40(sp)
    8000063c:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    8000063e:	00008517          	auipc	a0,0x8
    80000642:	9e250513          	addi	a0,a0,-1566 # 80008020 <etext+0x20>
    80000646:	00000097          	auipc	ra,0x0
    8000064a:	f1a080e7          	jalr	-230(ra) # 80000560 <panic>
      consputc(c);
    8000064e:	00000097          	auipc	ra,0x0
    80000652:	c46080e7          	jalr	-954(ra) # 80000294 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000656:	2985                	addiw	s3,s3,1
    80000658:	013a07b3          	add	a5,s4,s3
    8000065c:	0007c503          	lbu	a0,0(a5)
    80000660:	10050563          	beqz	a0,8000076a <printf+0x1c0>
    if(c != '%'){
    80000664:	ff6515e3          	bne	a0,s6,8000064e <printf+0xa4>
    c = fmt[++i] & 0xff;
    80000668:	2985                	addiw	s3,s3,1
    8000066a:	013a07b3          	add	a5,s4,s3
    8000066e:	0007c783          	lbu	a5,0(a5)
    80000672:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80000676:	10078b63          	beqz	a5,8000078c <printf+0x1e2>
    switch(c){
    8000067a:	05778a63          	beq	a5,s7,800006ce <printf+0x124>
    8000067e:	02fbf663          	bgeu	s7,a5,800006aa <printf+0x100>
    80000682:	09878863          	beq	a5,s8,80000712 <printf+0x168>
    80000686:	07800713          	li	a4,120
    8000068a:	0ce79563          	bne	a5,a4,80000754 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    8000068e:	f8843783          	ld	a5,-120(s0)
    80000692:	00878713          	addi	a4,a5,8
    80000696:	f8e43423          	sd	a4,-120(s0)
    8000069a:	4605                	li	a2,1
    8000069c:	85e6                	mv	a1,s9
    8000069e:	4388                	lw	a0,0(a5)
    800006a0:	00000097          	auipc	ra,0x0
    800006a4:	e1c080e7          	jalr	-484(ra) # 800004bc <printint>
      break;
    800006a8:	b77d                	j	80000656 <printf+0xac>
    switch(c){
    800006aa:	09678f63          	beq	a5,s6,80000748 <printf+0x19e>
    800006ae:	0bb79363          	bne	a5,s11,80000754 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    800006b2:	f8843783          	ld	a5,-120(s0)
    800006b6:	00878713          	addi	a4,a5,8
    800006ba:	f8e43423          	sd	a4,-120(s0)
    800006be:	4605                	li	a2,1
    800006c0:	45a9                	li	a1,10
    800006c2:	4388                	lw	a0,0(a5)
    800006c4:	00000097          	auipc	ra,0x0
    800006c8:	df8080e7          	jalr	-520(ra) # 800004bc <printint>
      break;
    800006cc:	b769                	j	80000656 <printf+0xac>
      printptr(va_arg(ap, uint64));
    800006ce:	f8843783          	ld	a5,-120(s0)
    800006d2:	00878713          	addi	a4,a5,8
    800006d6:	f8e43423          	sd	a4,-120(s0)
    800006da:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006de:	03000513          	li	a0,48
    800006e2:	00000097          	auipc	ra,0x0
    800006e6:	bb2080e7          	jalr	-1102(ra) # 80000294 <consputc>
  consputc('x');
    800006ea:	07800513          	li	a0,120
    800006ee:	00000097          	auipc	ra,0x0
    800006f2:	ba6080e7          	jalr	-1114(ra) # 80000294 <consputc>
    800006f6:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006f8:	03c95793          	srli	a5,s2,0x3c
    800006fc:	97d6                	add	a5,a5,s5
    800006fe:	0007c503          	lbu	a0,0(a5)
    80000702:	00000097          	auipc	ra,0x0
    80000706:	b92080e7          	jalr	-1134(ra) # 80000294 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000070a:	0912                	slli	s2,s2,0x4
    8000070c:	34fd                	addiw	s1,s1,-1
    8000070e:	f4ed                	bnez	s1,800006f8 <printf+0x14e>
    80000710:	b799                	j	80000656 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80000712:	f8843783          	ld	a5,-120(s0)
    80000716:	00878713          	addi	a4,a5,8
    8000071a:	f8e43423          	sd	a4,-120(s0)
    8000071e:	6384                	ld	s1,0(a5)
    80000720:	cc89                	beqz	s1,8000073a <printf+0x190>
      for(; *s; s++)
    80000722:	0004c503          	lbu	a0,0(s1)
    80000726:	d905                	beqz	a0,80000656 <printf+0xac>
        consputc(*s);
    80000728:	00000097          	auipc	ra,0x0
    8000072c:	b6c080e7          	jalr	-1172(ra) # 80000294 <consputc>
      for(; *s; s++)
    80000730:	0485                	addi	s1,s1,1
    80000732:	0004c503          	lbu	a0,0(s1)
    80000736:	f96d                	bnez	a0,80000728 <printf+0x17e>
    80000738:	bf39                	j	80000656 <printf+0xac>
        s = "(null)";
    8000073a:	00008497          	auipc	s1,0x8
    8000073e:	8de48493          	addi	s1,s1,-1826 # 80008018 <etext+0x18>
      for(; *s; s++)
    80000742:	02800513          	li	a0,40
    80000746:	b7cd                	j	80000728 <printf+0x17e>
      consputc('%');
    80000748:	855a                	mv	a0,s6
    8000074a:	00000097          	auipc	ra,0x0
    8000074e:	b4a080e7          	jalr	-1206(ra) # 80000294 <consputc>
      break;
    80000752:	b711                	j	80000656 <printf+0xac>
      consputc('%');
    80000754:	855a                	mv	a0,s6
    80000756:	00000097          	auipc	ra,0x0
    8000075a:	b3e080e7          	jalr	-1218(ra) # 80000294 <consputc>
      consputc(c);
    8000075e:	8526                	mv	a0,s1
    80000760:	00000097          	auipc	ra,0x0
    80000764:	b34080e7          	jalr	-1228(ra) # 80000294 <consputc>
      break;
    80000768:	b5fd                	j	80000656 <printf+0xac>
    8000076a:	74a6                	ld	s1,104(sp)
    8000076c:	7906                	ld	s2,96(sp)
    8000076e:	69e6                	ld	s3,88(sp)
    80000770:	6aa6                	ld	s5,72(sp)
    80000772:	6b06                	ld	s6,64(sp)
    80000774:	7be2                	ld	s7,56(sp)
    80000776:	7c42                	ld	s8,48(sp)
    80000778:	7ca2                	ld	s9,40(sp)
    8000077a:	6de2                	ld	s11,24(sp)
  if(locking)
    8000077c:	020d1263          	bnez	s10,800007a0 <printf+0x1f6>
}
    80000780:	70e6                	ld	ra,120(sp)
    80000782:	7446                	ld	s0,112(sp)
    80000784:	6a46                	ld	s4,80(sp)
    80000786:	7d02                	ld	s10,32(sp)
    80000788:	6129                	addi	sp,sp,192
    8000078a:	8082                	ret
    8000078c:	74a6                	ld	s1,104(sp)
    8000078e:	7906                	ld	s2,96(sp)
    80000790:	69e6                	ld	s3,88(sp)
    80000792:	6aa6                	ld	s5,72(sp)
    80000794:	6b06                	ld	s6,64(sp)
    80000796:	7be2                	ld	s7,56(sp)
    80000798:	7c42                	ld	s8,48(sp)
    8000079a:	7ca2                	ld	s9,40(sp)
    8000079c:	6de2                	ld	s11,24(sp)
    8000079e:	bff9                	j	8000077c <printf+0x1d2>
    release(&pr.lock);
    800007a0:	00013517          	auipc	a0,0x13
    800007a4:	0a850513          	addi	a0,a0,168 # 80013848 <pr>
    800007a8:	00000097          	auipc	ra,0x0
    800007ac:	544080e7          	jalr	1348(ra) # 80000cec <release>
}
    800007b0:	bfc1                	j	80000780 <printf+0x1d6>

00000000800007b2 <printfinit>:
    ;
}

void
printfinit(void)
{
    800007b2:	1101                	addi	sp,sp,-32
    800007b4:	ec06                	sd	ra,24(sp)
    800007b6:	e822                	sd	s0,16(sp)
    800007b8:	e426                	sd	s1,8(sp)
    800007ba:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800007bc:	00013497          	auipc	s1,0x13
    800007c0:	08c48493          	addi	s1,s1,140 # 80013848 <pr>
    800007c4:	00008597          	auipc	a1,0x8
    800007c8:	86c58593          	addi	a1,a1,-1940 # 80008030 <etext+0x30>
    800007cc:	8526                	mv	a0,s1
    800007ce:	00000097          	auipc	ra,0x0
    800007d2:	3da080e7          	jalr	986(ra) # 80000ba8 <initlock>
  pr.locking = 1;
    800007d6:	4785                	li	a5,1
    800007d8:	cc9c                	sw	a5,24(s1)
}
    800007da:	60e2                	ld	ra,24(sp)
    800007dc:	6442                	ld	s0,16(sp)
    800007de:	64a2                	ld	s1,8(sp)
    800007e0:	6105                	addi	sp,sp,32
    800007e2:	8082                	ret

00000000800007e4 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007e4:	1141                	addi	sp,sp,-16
    800007e6:	e406                	sd	ra,8(sp)
    800007e8:	e022                	sd	s0,0(sp)
    800007ea:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007ec:	100007b7          	lui	a5,0x10000
    800007f0:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007f4:	10000737          	lui	a4,0x10000
    800007f8:	f8000693          	li	a3,-128
    800007fc:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000800:	468d                	li	a3,3
    80000802:	10000637          	lui	a2,0x10000
    80000806:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000080a:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000080e:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000812:	10000737          	lui	a4,0x10000
    80000816:	461d                	li	a2,7
    80000818:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000081c:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000820:	00008597          	auipc	a1,0x8
    80000824:	81858593          	addi	a1,a1,-2024 # 80008038 <etext+0x38>
    80000828:	00013517          	auipc	a0,0x13
    8000082c:	04050513          	addi	a0,a0,64 # 80013868 <uart_tx_lock>
    80000830:	00000097          	auipc	ra,0x0
    80000834:	378080e7          	jalr	888(ra) # 80000ba8 <initlock>
}
    80000838:	60a2                	ld	ra,8(sp)
    8000083a:	6402                	ld	s0,0(sp)
    8000083c:	0141                	addi	sp,sp,16
    8000083e:	8082                	ret

0000000080000840 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000840:	1101                	addi	sp,sp,-32
    80000842:	ec06                	sd	ra,24(sp)
    80000844:	e822                	sd	s0,16(sp)
    80000846:	e426                	sd	s1,8(sp)
    80000848:	1000                	addi	s0,sp,32
    8000084a:	84aa                	mv	s1,a0
  push_off();
    8000084c:	00000097          	auipc	ra,0x0
    80000850:	3a0080e7          	jalr	928(ra) # 80000bec <push_off>

  if(panicked){
    80000854:	0000b797          	auipc	a5,0xb
    80000858:	dcc7a783          	lw	a5,-564(a5) # 8000b620 <panicked>
    8000085c:	eb85                	bnez	a5,8000088c <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000085e:	10000737          	lui	a4,0x10000
    80000862:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000864:	00074783          	lbu	a5,0(a4)
    80000868:	0207f793          	andi	a5,a5,32
    8000086c:	dfe5                	beqz	a5,80000864 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000086e:	0ff4f513          	zext.b	a0,s1
    80000872:	100007b7          	lui	a5,0x10000
    80000876:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000087a:	00000097          	auipc	ra,0x0
    8000087e:	412080e7          	jalr	1042(ra) # 80000c8c <pop_off>
}
    80000882:	60e2                	ld	ra,24(sp)
    80000884:	6442                	ld	s0,16(sp)
    80000886:	64a2                	ld	s1,8(sp)
    80000888:	6105                	addi	sp,sp,32
    8000088a:	8082                	ret
    for(;;)
    8000088c:	a001                	j	8000088c <uartputc_sync+0x4c>

000000008000088e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000088e:	0000b797          	auipc	a5,0xb
    80000892:	d9a7b783          	ld	a5,-614(a5) # 8000b628 <uart_tx_r>
    80000896:	0000b717          	auipc	a4,0xb
    8000089a:	d9a73703          	ld	a4,-614(a4) # 8000b630 <uart_tx_w>
    8000089e:	06f70f63          	beq	a4,a5,8000091c <uartstart+0x8e>
{
    800008a2:	7139                	addi	sp,sp,-64
    800008a4:	fc06                	sd	ra,56(sp)
    800008a6:	f822                	sd	s0,48(sp)
    800008a8:	f426                	sd	s1,40(sp)
    800008aa:	f04a                	sd	s2,32(sp)
    800008ac:	ec4e                	sd	s3,24(sp)
    800008ae:	e852                	sd	s4,16(sp)
    800008b0:	e456                	sd	s5,8(sp)
    800008b2:	e05a                	sd	s6,0(sp)
    800008b4:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008b6:	10000937          	lui	s2,0x10000
    800008ba:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008bc:	00013a97          	auipc	s5,0x13
    800008c0:	faca8a93          	addi	s5,s5,-84 # 80013868 <uart_tx_lock>
    uart_tx_r += 1;
    800008c4:	0000b497          	auipc	s1,0xb
    800008c8:	d6448493          	addi	s1,s1,-668 # 8000b628 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008cc:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008d0:	0000b997          	auipc	s3,0xb
    800008d4:	d6098993          	addi	s3,s3,-672 # 8000b630 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008d8:	00094703          	lbu	a4,0(s2)
    800008dc:	02077713          	andi	a4,a4,32
    800008e0:	c705                	beqz	a4,80000908 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008e2:	01f7f713          	andi	a4,a5,31
    800008e6:	9756                	add	a4,a4,s5
    800008e8:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800008ec:	0785                	addi	a5,a5,1
    800008ee:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800008f0:	8526                	mv	a0,s1
    800008f2:	00002097          	auipc	ra,0x2
    800008f6:	e66080e7          	jalr	-410(ra) # 80002758 <wakeup>
    WriteReg(THR, c);
    800008fa:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800008fe:	609c                	ld	a5,0(s1)
    80000900:	0009b703          	ld	a4,0(s3)
    80000904:	fcf71ae3          	bne	a4,a5,800008d8 <uartstart+0x4a>
  }
}
    80000908:	70e2                	ld	ra,56(sp)
    8000090a:	7442                	ld	s0,48(sp)
    8000090c:	74a2                	ld	s1,40(sp)
    8000090e:	7902                	ld	s2,32(sp)
    80000910:	69e2                	ld	s3,24(sp)
    80000912:	6a42                	ld	s4,16(sp)
    80000914:	6aa2                	ld	s5,8(sp)
    80000916:	6b02                	ld	s6,0(sp)
    80000918:	6121                	addi	sp,sp,64
    8000091a:	8082                	ret
    8000091c:	8082                	ret

000000008000091e <uartputc>:
{
    8000091e:	7179                	addi	sp,sp,-48
    80000920:	f406                	sd	ra,40(sp)
    80000922:	f022                	sd	s0,32(sp)
    80000924:	ec26                	sd	s1,24(sp)
    80000926:	e84a                	sd	s2,16(sp)
    80000928:	e44e                	sd	s3,8(sp)
    8000092a:	e052                	sd	s4,0(sp)
    8000092c:	1800                	addi	s0,sp,48
    8000092e:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80000930:	00013517          	auipc	a0,0x13
    80000934:	f3850513          	addi	a0,a0,-200 # 80013868 <uart_tx_lock>
    80000938:	00000097          	auipc	ra,0x0
    8000093c:	300080e7          	jalr	768(ra) # 80000c38 <acquire>
  if(panicked){
    80000940:	0000b797          	auipc	a5,0xb
    80000944:	ce07a783          	lw	a5,-800(a5) # 8000b620 <panicked>
    80000948:	e7c9                	bnez	a5,800009d2 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000094a:	0000b717          	auipc	a4,0xb
    8000094e:	ce673703          	ld	a4,-794(a4) # 8000b630 <uart_tx_w>
    80000952:	0000b797          	auipc	a5,0xb
    80000956:	cd67b783          	ld	a5,-810(a5) # 8000b628 <uart_tx_r>
    8000095a:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000095e:	00013997          	auipc	s3,0x13
    80000962:	f0a98993          	addi	s3,s3,-246 # 80013868 <uart_tx_lock>
    80000966:	0000b497          	auipc	s1,0xb
    8000096a:	cc248493          	addi	s1,s1,-830 # 8000b628 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000096e:	0000b917          	auipc	s2,0xb
    80000972:	cc290913          	addi	s2,s2,-830 # 8000b630 <uart_tx_w>
    80000976:	00e79f63          	bne	a5,a4,80000994 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000097a:	85ce                	mv	a1,s3
    8000097c:	8526                	mv	a0,s1
    8000097e:	00002097          	auipc	ra,0x2
    80000982:	d76080e7          	jalr	-650(ra) # 800026f4 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000986:	00093703          	ld	a4,0(s2)
    8000098a:	609c                	ld	a5,0(s1)
    8000098c:	02078793          	addi	a5,a5,32
    80000990:	fee785e3          	beq	a5,a4,8000097a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000994:	00013497          	auipc	s1,0x13
    80000998:	ed448493          	addi	s1,s1,-300 # 80013868 <uart_tx_lock>
    8000099c:	01f77793          	andi	a5,a4,31
    800009a0:	97a6                	add	a5,a5,s1
    800009a2:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009a6:	0705                	addi	a4,a4,1
    800009a8:	0000b797          	auipc	a5,0xb
    800009ac:	c8e7b423          	sd	a4,-888(a5) # 8000b630 <uart_tx_w>
  uartstart();
    800009b0:	00000097          	auipc	ra,0x0
    800009b4:	ede080e7          	jalr	-290(ra) # 8000088e <uartstart>
  release(&uart_tx_lock);
    800009b8:	8526                	mv	a0,s1
    800009ba:	00000097          	auipc	ra,0x0
    800009be:	332080e7          	jalr	818(ra) # 80000cec <release>
}
    800009c2:	70a2                	ld	ra,40(sp)
    800009c4:	7402                	ld	s0,32(sp)
    800009c6:	64e2                	ld	s1,24(sp)
    800009c8:	6942                	ld	s2,16(sp)
    800009ca:	69a2                	ld	s3,8(sp)
    800009cc:	6a02                	ld	s4,0(sp)
    800009ce:	6145                	addi	sp,sp,48
    800009d0:	8082                	ret
    for(;;)
    800009d2:	a001                	j	800009d2 <uartputc+0xb4>

00000000800009d4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009d4:	1141                	addi	sp,sp,-16
    800009d6:	e422                	sd	s0,8(sp)
    800009d8:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009da:	100007b7          	lui	a5,0x10000
    800009de:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800009e0:	0007c783          	lbu	a5,0(a5)
    800009e4:	8b85                	andi	a5,a5,1
    800009e6:	cb81                	beqz	a5,800009f6 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800009e8:	100007b7          	lui	a5,0x10000
    800009ec:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009f0:	6422                	ld	s0,8(sp)
    800009f2:	0141                	addi	sp,sp,16
    800009f4:	8082                	ret
    return -1;
    800009f6:	557d                	li	a0,-1
    800009f8:	bfe5                	j	800009f0 <uartgetc+0x1c>

00000000800009fa <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009fa:	1101                	addi	sp,sp,-32
    800009fc:	ec06                	sd	ra,24(sp)
    800009fe:	e822                	sd	s0,16(sp)
    80000a00:	e426                	sd	s1,8(sp)
    80000a02:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a04:	54fd                	li	s1,-1
    80000a06:	a029                	j	80000a10 <uartintr+0x16>
      break;
    consoleintr(c);
    80000a08:	00000097          	auipc	ra,0x0
    80000a0c:	8ce080e7          	jalr	-1842(ra) # 800002d6 <consoleintr>
    int c = uartgetc();
    80000a10:	00000097          	auipc	ra,0x0
    80000a14:	fc4080e7          	jalr	-60(ra) # 800009d4 <uartgetc>
    if(c == -1)
    80000a18:	fe9518e3          	bne	a0,s1,80000a08 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a1c:	00013497          	auipc	s1,0x13
    80000a20:	e4c48493          	addi	s1,s1,-436 # 80013868 <uart_tx_lock>
    80000a24:	8526                	mv	a0,s1
    80000a26:	00000097          	auipc	ra,0x0
    80000a2a:	212080e7          	jalr	530(ra) # 80000c38 <acquire>
  uartstart();
    80000a2e:	00000097          	auipc	ra,0x0
    80000a32:	e60080e7          	jalr	-416(ra) # 8000088e <uartstart>
  release(&uart_tx_lock);
    80000a36:	8526                	mv	a0,s1
    80000a38:	00000097          	auipc	ra,0x0
    80000a3c:	2b4080e7          	jalr	692(ra) # 80000cec <release>
}
    80000a40:	60e2                	ld	ra,24(sp)
    80000a42:	6442                	ld	s0,16(sp)
    80000a44:	64a2                	ld	s1,8(sp)
    80000a46:	6105                	addi	sp,sp,32
    80000a48:	8082                	ret

0000000080000a4a <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a4a:	1101                	addi	sp,sp,-32
    80000a4c:	ec06                	sd	ra,24(sp)
    80000a4e:	e822                	sd	s0,16(sp)
    80000a50:	e426                	sd	s1,8(sp)
    80000a52:	e04a                	sd	s2,0(sp)
    80000a54:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a56:	03451793          	slli	a5,a0,0x34
    80000a5a:	ebb9                	bnez	a5,80000ab0 <kfree+0x66>
    80000a5c:	84aa                	mv	s1,a0
    80000a5e:	00025797          	auipc	a5,0x25
    80000a62:	8ba78793          	addi	a5,a5,-1862 # 80025318 <end>
    80000a66:	04f56563          	bltu	a0,a5,80000ab0 <kfree+0x66>
    80000a6a:	47c5                	li	a5,17
    80000a6c:	07ee                	slli	a5,a5,0x1b
    80000a6e:	04f57163          	bgeu	a0,a5,80000ab0 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a72:	6605                	lui	a2,0x1
    80000a74:	4585                	li	a1,1
    80000a76:	00000097          	auipc	ra,0x0
    80000a7a:	2be080e7          	jalr	702(ra) # 80000d34 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a7e:	00013917          	auipc	s2,0x13
    80000a82:	e2290913          	addi	s2,s2,-478 # 800138a0 <kmem>
    80000a86:	854a                	mv	a0,s2
    80000a88:	00000097          	auipc	ra,0x0
    80000a8c:	1b0080e7          	jalr	432(ra) # 80000c38 <acquire>
  r->next = kmem.freelist;
    80000a90:	01893783          	ld	a5,24(s2)
    80000a94:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a96:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a9a:	854a                	mv	a0,s2
    80000a9c:	00000097          	auipc	ra,0x0
    80000aa0:	250080e7          	jalr	592(ra) # 80000cec <release>
}
    80000aa4:	60e2                	ld	ra,24(sp)
    80000aa6:	6442                	ld	s0,16(sp)
    80000aa8:	64a2                	ld	s1,8(sp)
    80000aaa:	6902                	ld	s2,0(sp)
    80000aac:	6105                	addi	sp,sp,32
    80000aae:	8082                	ret
    panic("kfree");
    80000ab0:	00007517          	auipc	a0,0x7
    80000ab4:	59050513          	addi	a0,a0,1424 # 80008040 <etext+0x40>
    80000ab8:	00000097          	auipc	ra,0x0
    80000abc:	aa8080e7          	jalr	-1368(ra) # 80000560 <panic>

0000000080000ac0 <freerange>:
{
    80000ac0:	7179                	addi	sp,sp,-48
    80000ac2:	f406                	sd	ra,40(sp)
    80000ac4:	f022                	sd	s0,32(sp)
    80000ac6:	ec26                	sd	s1,24(sp)
    80000ac8:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000aca:	6785                	lui	a5,0x1
    80000acc:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ad0:	00e504b3          	add	s1,a0,a4
    80000ad4:	777d                	lui	a4,0xfffff
    80000ad6:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ad8:	94be                	add	s1,s1,a5
    80000ada:	0295e463          	bltu	a1,s1,80000b02 <freerange+0x42>
    80000ade:	e84a                	sd	s2,16(sp)
    80000ae0:	e44e                	sd	s3,8(sp)
    80000ae2:	e052                	sd	s4,0(sp)
    80000ae4:	892e                	mv	s2,a1
    kfree(p);
    80000ae6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ae8:	6985                	lui	s3,0x1
    kfree(p);
    80000aea:	01448533          	add	a0,s1,s4
    80000aee:	00000097          	auipc	ra,0x0
    80000af2:	f5c080e7          	jalr	-164(ra) # 80000a4a <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000af6:	94ce                	add	s1,s1,s3
    80000af8:	fe9979e3          	bgeu	s2,s1,80000aea <freerange+0x2a>
    80000afc:	6942                	ld	s2,16(sp)
    80000afe:	69a2                	ld	s3,8(sp)
    80000b00:	6a02                	ld	s4,0(sp)
}
    80000b02:	70a2                	ld	ra,40(sp)
    80000b04:	7402                	ld	s0,32(sp)
    80000b06:	64e2                	ld	s1,24(sp)
    80000b08:	6145                	addi	sp,sp,48
    80000b0a:	8082                	ret

0000000080000b0c <kinit>:
{
    80000b0c:	1141                	addi	sp,sp,-16
    80000b0e:	e406                	sd	ra,8(sp)
    80000b10:	e022                	sd	s0,0(sp)
    80000b12:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000b14:	00007597          	auipc	a1,0x7
    80000b18:	53458593          	addi	a1,a1,1332 # 80008048 <etext+0x48>
    80000b1c:	00013517          	auipc	a0,0x13
    80000b20:	d8450513          	addi	a0,a0,-636 # 800138a0 <kmem>
    80000b24:	00000097          	auipc	ra,0x0
    80000b28:	084080e7          	jalr	132(ra) # 80000ba8 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b2c:	45c5                	li	a1,17
    80000b2e:	05ee                	slli	a1,a1,0x1b
    80000b30:	00024517          	auipc	a0,0x24
    80000b34:	7e850513          	addi	a0,a0,2024 # 80025318 <end>
    80000b38:	00000097          	auipc	ra,0x0
    80000b3c:	f88080e7          	jalr	-120(ra) # 80000ac0 <freerange>
}
    80000b40:	60a2                	ld	ra,8(sp)
    80000b42:	6402                	ld	s0,0(sp)
    80000b44:	0141                	addi	sp,sp,16
    80000b46:	8082                	ret

0000000080000b48 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b48:	1101                	addi	sp,sp,-32
    80000b4a:	ec06                	sd	ra,24(sp)
    80000b4c:	e822                	sd	s0,16(sp)
    80000b4e:	e426                	sd	s1,8(sp)
    80000b50:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b52:	00013497          	auipc	s1,0x13
    80000b56:	d4e48493          	addi	s1,s1,-690 # 800138a0 <kmem>
    80000b5a:	8526                	mv	a0,s1
    80000b5c:	00000097          	auipc	ra,0x0
    80000b60:	0dc080e7          	jalr	220(ra) # 80000c38 <acquire>
  r = kmem.freelist;
    80000b64:	6c84                	ld	s1,24(s1)
  if(r)
    80000b66:	c885                	beqz	s1,80000b96 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b68:	609c                	ld	a5,0(s1)
    80000b6a:	00013517          	auipc	a0,0x13
    80000b6e:	d3650513          	addi	a0,a0,-714 # 800138a0 <kmem>
    80000b72:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b74:	00000097          	auipc	ra,0x0
    80000b78:	178080e7          	jalr	376(ra) # 80000cec <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b7c:	6605                	lui	a2,0x1
    80000b7e:	4595                	li	a1,5
    80000b80:	8526                	mv	a0,s1
    80000b82:	00000097          	auipc	ra,0x0
    80000b86:	1b2080e7          	jalr	434(ra) # 80000d34 <memset>
  return (void*)r;
}
    80000b8a:	8526                	mv	a0,s1
    80000b8c:	60e2                	ld	ra,24(sp)
    80000b8e:	6442                	ld	s0,16(sp)
    80000b90:	64a2                	ld	s1,8(sp)
    80000b92:	6105                	addi	sp,sp,32
    80000b94:	8082                	ret
  release(&kmem.lock);
    80000b96:	00013517          	auipc	a0,0x13
    80000b9a:	d0a50513          	addi	a0,a0,-758 # 800138a0 <kmem>
    80000b9e:	00000097          	auipc	ra,0x0
    80000ba2:	14e080e7          	jalr	334(ra) # 80000cec <release>
  if(r)
    80000ba6:	b7d5                	j	80000b8a <kalloc+0x42>

0000000080000ba8 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000ba8:	1141                	addi	sp,sp,-16
    80000baa:	e422                	sd	s0,8(sp)
    80000bac:	0800                	addi	s0,sp,16
  lk->name = name;
    80000bae:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000bb0:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000bb4:	00053823          	sd	zero,16(a0)
}
    80000bb8:	6422                	ld	s0,8(sp)
    80000bba:	0141                	addi	sp,sp,16
    80000bbc:	8082                	ret

0000000080000bbe <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000bbe:	411c                	lw	a5,0(a0)
    80000bc0:	e399                	bnez	a5,80000bc6 <holding+0x8>
    80000bc2:	4501                	li	a0,0
  return r;
}
    80000bc4:	8082                	ret
{
    80000bc6:	1101                	addi	sp,sp,-32
    80000bc8:	ec06                	sd	ra,24(sp)
    80000bca:	e822                	sd	s0,16(sp)
    80000bcc:	e426                	sd	s1,8(sp)
    80000bce:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000bd0:	6904                	ld	s1,16(a0)
    80000bd2:	00001097          	auipc	ra,0x1
    80000bd6:	e7a080e7          	jalr	-390(ra) # 80001a4c <mycpu>
    80000bda:	40a48533          	sub	a0,s1,a0
    80000bde:	00153513          	seqz	a0,a0
}
    80000be2:	60e2                	ld	ra,24(sp)
    80000be4:	6442                	ld	s0,16(sp)
    80000be6:	64a2                	ld	s1,8(sp)
    80000be8:	6105                	addi	sp,sp,32
    80000bea:	8082                	ret

0000000080000bec <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bec:	1101                	addi	sp,sp,-32
    80000bee:	ec06                	sd	ra,24(sp)
    80000bf0:	e822                	sd	s0,16(sp)
    80000bf2:	e426                	sd	s1,8(sp)
    80000bf4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bf6:	100024f3          	csrr	s1,sstatus
    80000bfa:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bfe:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c00:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000c04:	00001097          	auipc	ra,0x1
    80000c08:	e48080e7          	jalr	-440(ra) # 80001a4c <mycpu>
    80000c0c:	5d3c                	lw	a5,120(a0)
    80000c0e:	cf89                	beqz	a5,80000c28 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c10:	00001097          	auipc	ra,0x1
    80000c14:	e3c080e7          	jalr	-452(ra) # 80001a4c <mycpu>
    80000c18:	5d3c                	lw	a5,120(a0)
    80000c1a:	2785                	addiw	a5,a5,1
    80000c1c:	dd3c                	sw	a5,120(a0)
}
    80000c1e:	60e2                	ld	ra,24(sp)
    80000c20:	6442                	ld	s0,16(sp)
    80000c22:	64a2                	ld	s1,8(sp)
    80000c24:	6105                	addi	sp,sp,32
    80000c26:	8082                	ret
    mycpu()->intena = old;
    80000c28:	00001097          	auipc	ra,0x1
    80000c2c:	e24080e7          	jalr	-476(ra) # 80001a4c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000c30:	8085                	srli	s1,s1,0x1
    80000c32:	8885                	andi	s1,s1,1
    80000c34:	dd64                	sw	s1,124(a0)
    80000c36:	bfe9                	j	80000c10 <push_off+0x24>

0000000080000c38 <acquire>:
{
    80000c38:	1101                	addi	sp,sp,-32
    80000c3a:	ec06                	sd	ra,24(sp)
    80000c3c:	e822                	sd	s0,16(sp)
    80000c3e:	e426                	sd	s1,8(sp)
    80000c40:	1000                	addi	s0,sp,32
    80000c42:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c44:	00000097          	auipc	ra,0x0
    80000c48:	fa8080e7          	jalr	-88(ra) # 80000bec <push_off>
  if(holding(lk))
    80000c4c:	8526                	mv	a0,s1
    80000c4e:	00000097          	auipc	ra,0x0
    80000c52:	f70080e7          	jalr	-144(ra) # 80000bbe <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c56:	4705                	li	a4,1
  if(holding(lk))
    80000c58:	e115                	bnez	a0,80000c7c <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c5a:	87ba                	mv	a5,a4
    80000c5c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c60:	2781                	sext.w	a5,a5
    80000c62:	ffe5                	bnez	a5,80000c5a <acquire+0x22>
  __sync_synchronize();
    80000c64:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000c68:	00001097          	auipc	ra,0x1
    80000c6c:	de4080e7          	jalr	-540(ra) # 80001a4c <mycpu>
    80000c70:	e888                	sd	a0,16(s1)
}
    80000c72:	60e2                	ld	ra,24(sp)
    80000c74:	6442                	ld	s0,16(sp)
    80000c76:	64a2                	ld	s1,8(sp)
    80000c78:	6105                	addi	sp,sp,32
    80000c7a:	8082                	ret
    panic("acquire");
    80000c7c:	00007517          	auipc	a0,0x7
    80000c80:	3d450513          	addi	a0,a0,980 # 80008050 <etext+0x50>
    80000c84:	00000097          	auipc	ra,0x0
    80000c88:	8dc080e7          	jalr	-1828(ra) # 80000560 <panic>

0000000080000c8c <pop_off>:

void
pop_off(void)
{
    80000c8c:	1141                	addi	sp,sp,-16
    80000c8e:	e406                	sd	ra,8(sp)
    80000c90:	e022                	sd	s0,0(sp)
    80000c92:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c94:	00001097          	auipc	ra,0x1
    80000c98:	db8080e7          	jalr	-584(ra) # 80001a4c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c9c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000ca0:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000ca2:	e78d                	bnez	a5,80000ccc <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000ca4:	5d3c                	lw	a5,120(a0)
    80000ca6:	02f05b63          	blez	a5,80000cdc <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000caa:	37fd                	addiw	a5,a5,-1
    80000cac:	0007871b          	sext.w	a4,a5
    80000cb0:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000cb2:	eb09                	bnez	a4,80000cc4 <pop_off+0x38>
    80000cb4:	5d7c                	lw	a5,124(a0)
    80000cb6:	c799                	beqz	a5,80000cc4 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000cb8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000cbc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000cc0:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000cc4:	60a2                	ld	ra,8(sp)
    80000cc6:	6402                	ld	s0,0(sp)
    80000cc8:	0141                	addi	sp,sp,16
    80000cca:	8082                	ret
    panic("pop_off - interruptible");
    80000ccc:	00007517          	auipc	a0,0x7
    80000cd0:	38c50513          	addi	a0,a0,908 # 80008058 <etext+0x58>
    80000cd4:	00000097          	auipc	ra,0x0
    80000cd8:	88c080e7          	jalr	-1908(ra) # 80000560 <panic>
    panic("pop_off");
    80000cdc:	00007517          	auipc	a0,0x7
    80000ce0:	39450513          	addi	a0,a0,916 # 80008070 <etext+0x70>
    80000ce4:	00000097          	auipc	ra,0x0
    80000ce8:	87c080e7          	jalr	-1924(ra) # 80000560 <panic>

0000000080000cec <release>:
{
    80000cec:	1101                	addi	sp,sp,-32
    80000cee:	ec06                	sd	ra,24(sp)
    80000cf0:	e822                	sd	s0,16(sp)
    80000cf2:	e426                	sd	s1,8(sp)
    80000cf4:	1000                	addi	s0,sp,32
    80000cf6:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000cf8:	00000097          	auipc	ra,0x0
    80000cfc:	ec6080e7          	jalr	-314(ra) # 80000bbe <holding>
    80000d00:	c115                	beqz	a0,80000d24 <release+0x38>
  lk->cpu = 0;
    80000d02:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000d06:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000d0a:	0310000f          	fence	rw,w
    80000d0e:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000d12:	00000097          	auipc	ra,0x0
    80000d16:	f7a080e7          	jalr	-134(ra) # 80000c8c <pop_off>
}
    80000d1a:	60e2                	ld	ra,24(sp)
    80000d1c:	6442                	ld	s0,16(sp)
    80000d1e:	64a2                	ld	s1,8(sp)
    80000d20:	6105                	addi	sp,sp,32
    80000d22:	8082                	ret
    panic("release");
    80000d24:	00007517          	auipc	a0,0x7
    80000d28:	35450513          	addi	a0,a0,852 # 80008078 <etext+0x78>
    80000d2c:	00000097          	auipc	ra,0x0
    80000d30:	834080e7          	jalr	-1996(ra) # 80000560 <panic>

0000000080000d34 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000d34:	1141                	addi	sp,sp,-16
    80000d36:	e422                	sd	s0,8(sp)
    80000d38:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d3a:	ca19                	beqz	a2,80000d50 <memset+0x1c>
    80000d3c:	87aa                	mv	a5,a0
    80000d3e:	1602                	slli	a2,a2,0x20
    80000d40:	9201                	srli	a2,a2,0x20
    80000d42:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000d46:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000d4a:	0785                	addi	a5,a5,1
    80000d4c:	fee79de3          	bne	a5,a4,80000d46 <memset+0x12>
  }
  return dst;
}
    80000d50:	6422                	ld	s0,8(sp)
    80000d52:	0141                	addi	sp,sp,16
    80000d54:	8082                	ret

0000000080000d56 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d56:	1141                	addi	sp,sp,-16
    80000d58:	e422                	sd	s0,8(sp)
    80000d5a:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d5c:	ca05                	beqz	a2,80000d8c <memcmp+0x36>
    80000d5e:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000d62:	1682                	slli	a3,a3,0x20
    80000d64:	9281                	srli	a3,a3,0x20
    80000d66:	0685                	addi	a3,a3,1
    80000d68:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d6a:	00054783          	lbu	a5,0(a0)
    80000d6e:	0005c703          	lbu	a4,0(a1)
    80000d72:	00e79863          	bne	a5,a4,80000d82 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d76:	0505                	addi	a0,a0,1
    80000d78:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d7a:	fed518e3          	bne	a0,a3,80000d6a <memcmp+0x14>
  }

  return 0;
    80000d7e:	4501                	li	a0,0
    80000d80:	a019                	j	80000d86 <memcmp+0x30>
      return *s1 - *s2;
    80000d82:	40e7853b          	subw	a0,a5,a4
}
    80000d86:	6422                	ld	s0,8(sp)
    80000d88:	0141                	addi	sp,sp,16
    80000d8a:	8082                	ret
  return 0;
    80000d8c:	4501                	li	a0,0
    80000d8e:	bfe5                	j	80000d86 <memcmp+0x30>

0000000080000d90 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d90:	1141                	addi	sp,sp,-16
    80000d92:	e422                	sd	s0,8(sp)
    80000d94:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d96:	c205                	beqz	a2,80000db6 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d98:	02a5e263          	bltu	a1,a0,80000dbc <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d9c:	1602                	slli	a2,a2,0x20
    80000d9e:	9201                	srli	a2,a2,0x20
    80000da0:	00c587b3          	add	a5,a1,a2
{
    80000da4:	872a                	mv	a4,a0
      *d++ = *s++;
    80000da6:	0585                	addi	a1,a1,1
    80000da8:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd9ce9>
    80000daa:	fff5c683          	lbu	a3,-1(a1)
    80000dae:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000db2:	feb79ae3          	bne	a5,a1,80000da6 <memmove+0x16>

  return dst;
}
    80000db6:	6422                	ld	s0,8(sp)
    80000db8:	0141                	addi	sp,sp,16
    80000dba:	8082                	ret
  if(s < d && s + n > d){
    80000dbc:	02061693          	slli	a3,a2,0x20
    80000dc0:	9281                	srli	a3,a3,0x20
    80000dc2:	00d58733          	add	a4,a1,a3
    80000dc6:	fce57be3          	bgeu	a0,a4,80000d9c <memmove+0xc>
    d += n;
    80000dca:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000dcc:	fff6079b          	addiw	a5,a2,-1
    80000dd0:	1782                	slli	a5,a5,0x20
    80000dd2:	9381                	srli	a5,a5,0x20
    80000dd4:	fff7c793          	not	a5,a5
    80000dd8:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000dda:	177d                	addi	a4,a4,-1
    80000ddc:	16fd                	addi	a3,a3,-1
    80000dde:	00074603          	lbu	a2,0(a4)
    80000de2:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000de6:	fef71ae3          	bne	a4,a5,80000dda <memmove+0x4a>
    80000dea:	b7f1                	j	80000db6 <memmove+0x26>

0000000080000dec <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000dec:	1141                	addi	sp,sp,-16
    80000dee:	e406                	sd	ra,8(sp)
    80000df0:	e022                	sd	s0,0(sp)
    80000df2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000df4:	00000097          	auipc	ra,0x0
    80000df8:	f9c080e7          	jalr	-100(ra) # 80000d90 <memmove>
}
    80000dfc:	60a2                	ld	ra,8(sp)
    80000dfe:	6402                	ld	s0,0(sp)
    80000e00:	0141                	addi	sp,sp,16
    80000e02:	8082                	ret

0000000080000e04 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000e04:	1141                	addi	sp,sp,-16
    80000e06:	e422                	sd	s0,8(sp)
    80000e08:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000e0a:	ce11                	beqz	a2,80000e26 <strncmp+0x22>
    80000e0c:	00054783          	lbu	a5,0(a0)
    80000e10:	cf89                	beqz	a5,80000e2a <strncmp+0x26>
    80000e12:	0005c703          	lbu	a4,0(a1)
    80000e16:	00f71a63          	bne	a4,a5,80000e2a <strncmp+0x26>
    n--, p++, q++;
    80000e1a:	367d                	addiw	a2,a2,-1
    80000e1c:	0505                	addi	a0,a0,1
    80000e1e:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000e20:	f675                	bnez	a2,80000e0c <strncmp+0x8>
  if(n == 0)
    return 0;
    80000e22:	4501                	li	a0,0
    80000e24:	a801                	j	80000e34 <strncmp+0x30>
    80000e26:	4501                	li	a0,0
    80000e28:	a031                	j	80000e34 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000e2a:	00054503          	lbu	a0,0(a0)
    80000e2e:	0005c783          	lbu	a5,0(a1)
    80000e32:	9d1d                	subw	a0,a0,a5
}
    80000e34:	6422                	ld	s0,8(sp)
    80000e36:	0141                	addi	sp,sp,16
    80000e38:	8082                	ret

0000000080000e3a <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e3a:	1141                	addi	sp,sp,-16
    80000e3c:	e422                	sd	s0,8(sp)
    80000e3e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e40:	87aa                	mv	a5,a0
    80000e42:	86b2                	mv	a3,a2
    80000e44:	367d                	addiw	a2,a2,-1
    80000e46:	02d05563          	blez	a3,80000e70 <strncpy+0x36>
    80000e4a:	0785                	addi	a5,a5,1
    80000e4c:	0005c703          	lbu	a4,0(a1)
    80000e50:	fee78fa3          	sb	a4,-1(a5)
    80000e54:	0585                	addi	a1,a1,1
    80000e56:	f775                	bnez	a4,80000e42 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000e58:	873e                	mv	a4,a5
    80000e5a:	9fb5                	addw	a5,a5,a3
    80000e5c:	37fd                	addiw	a5,a5,-1
    80000e5e:	00c05963          	blez	a2,80000e70 <strncpy+0x36>
    *s++ = 0;
    80000e62:	0705                	addi	a4,a4,1
    80000e64:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000e68:	40e786bb          	subw	a3,a5,a4
    80000e6c:	fed04be3          	bgtz	a3,80000e62 <strncpy+0x28>
  return os;
}
    80000e70:	6422                	ld	s0,8(sp)
    80000e72:	0141                	addi	sp,sp,16
    80000e74:	8082                	ret

0000000080000e76 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e76:	1141                	addi	sp,sp,-16
    80000e78:	e422                	sd	s0,8(sp)
    80000e7a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e7c:	02c05363          	blez	a2,80000ea2 <safestrcpy+0x2c>
    80000e80:	fff6069b          	addiw	a3,a2,-1
    80000e84:	1682                	slli	a3,a3,0x20
    80000e86:	9281                	srli	a3,a3,0x20
    80000e88:	96ae                	add	a3,a3,a1
    80000e8a:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e8c:	00d58963          	beq	a1,a3,80000e9e <safestrcpy+0x28>
    80000e90:	0585                	addi	a1,a1,1
    80000e92:	0785                	addi	a5,a5,1
    80000e94:	fff5c703          	lbu	a4,-1(a1)
    80000e98:	fee78fa3          	sb	a4,-1(a5)
    80000e9c:	fb65                	bnez	a4,80000e8c <safestrcpy+0x16>
    ;
  *s = 0;
    80000e9e:	00078023          	sb	zero,0(a5)
  return os;
}
    80000ea2:	6422                	ld	s0,8(sp)
    80000ea4:	0141                	addi	sp,sp,16
    80000ea6:	8082                	ret

0000000080000ea8 <strlen>:

int
strlen(const char *s)
{
    80000ea8:	1141                	addi	sp,sp,-16
    80000eaa:	e422                	sd	s0,8(sp)
    80000eac:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000eae:	00054783          	lbu	a5,0(a0)
    80000eb2:	cf91                	beqz	a5,80000ece <strlen+0x26>
    80000eb4:	0505                	addi	a0,a0,1
    80000eb6:	87aa                	mv	a5,a0
    80000eb8:	86be                	mv	a3,a5
    80000eba:	0785                	addi	a5,a5,1
    80000ebc:	fff7c703          	lbu	a4,-1(a5)
    80000ec0:	ff65                	bnez	a4,80000eb8 <strlen+0x10>
    80000ec2:	40a6853b          	subw	a0,a3,a0
    80000ec6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000ec8:	6422                	ld	s0,8(sp)
    80000eca:	0141                	addi	sp,sp,16
    80000ecc:	8082                	ret
  for(n = 0; s[n]; n++)
    80000ece:	4501                	li	a0,0
    80000ed0:	bfe5                	j	80000ec8 <strlen+0x20>

0000000080000ed2 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000ed2:	1141                	addi	sp,sp,-16
    80000ed4:	e406                	sd	ra,8(sp)
    80000ed6:	e022                	sd	s0,0(sp)
    80000ed8:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000eda:	00001097          	auipc	ra,0x1
    80000ede:	b62080e7          	jalr	-1182(ra) # 80001a3c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000ee2:	0000a717          	auipc	a4,0xa
    80000ee6:	75670713          	addi	a4,a4,1878 # 8000b638 <started>
  if(cpuid() == 0){
    80000eea:	c139                	beqz	a0,80000f30 <main+0x5e>
    while(started == 0)
    80000eec:	431c                	lw	a5,0(a4)
    80000eee:	2781                	sext.w	a5,a5
    80000ef0:	dff5                	beqz	a5,80000eec <main+0x1a>
      ;
    __sync_synchronize();
    80000ef2:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000ef6:	00001097          	auipc	ra,0x1
    80000efa:	b46080e7          	jalr	-1210(ra) # 80001a3c <cpuid>
    80000efe:	85aa                	mv	a1,a0
    80000f00:	00007517          	auipc	a0,0x7
    80000f04:	19850513          	addi	a0,a0,408 # 80008098 <etext+0x98>
    80000f08:	fffff097          	auipc	ra,0xfffff
    80000f0c:	6a2080e7          	jalr	1698(ra) # 800005aa <printf>
    kvminithart();    // turn on paging
    80000f10:	00000097          	auipc	ra,0x0
    80000f14:	0d8080e7          	jalr	216(ra) # 80000fe8 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000f18:	00002097          	auipc	ra,0x2
    80000f1c:	eee080e7          	jalr	-274(ra) # 80002e06 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f20:	00005097          	auipc	ra,0x5
    80000f24:	634080e7          	jalr	1588(ra) # 80006554 <plicinithart>
  }

  scheduler();        
    80000f28:	00001097          	auipc	ra,0x1
    80000f2c:	014080e7          	jalr	20(ra) # 80001f3c <scheduler>
    consoleinit();
    80000f30:	fffff097          	auipc	ra,0xfffff
    80000f34:	540080e7          	jalr	1344(ra) # 80000470 <consoleinit>
    printfinit();
    80000f38:	00000097          	auipc	ra,0x0
    80000f3c:	87a080e7          	jalr	-1926(ra) # 800007b2 <printfinit>
    printf("\n");
    80000f40:	00007517          	auipc	a0,0x7
    80000f44:	0d050513          	addi	a0,a0,208 # 80008010 <etext+0x10>
    80000f48:	fffff097          	auipc	ra,0xfffff
    80000f4c:	662080e7          	jalr	1634(ra) # 800005aa <printf>
    printf("xv6 kernel is booting\n");
    80000f50:	00007517          	auipc	a0,0x7
    80000f54:	13050513          	addi	a0,a0,304 # 80008080 <etext+0x80>
    80000f58:	fffff097          	auipc	ra,0xfffff
    80000f5c:	652080e7          	jalr	1618(ra) # 800005aa <printf>
    printf("\n");
    80000f60:	00007517          	auipc	a0,0x7
    80000f64:	0b050513          	addi	a0,a0,176 # 80008010 <etext+0x10>
    80000f68:	fffff097          	auipc	ra,0xfffff
    80000f6c:	642080e7          	jalr	1602(ra) # 800005aa <printf>
    kinit();         // physical page allocator
    80000f70:	00000097          	auipc	ra,0x0
    80000f74:	b9c080e7          	jalr	-1124(ra) # 80000b0c <kinit>
    kvminit();       // create kernel page table
    80000f78:	00000097          	auipc	ra,0x0
    80000f7c:	326080e7          	jalr	806(ra) # 8000129e <kvminit>
    kvminithart();   // turn on paging
    80000f80:	00000097          	auipc	ra,0x0
    80000f84:	068080e7          	jalr	104(ra) # 80000fe8 <kvminithart>
    procinit();      // process table
    80000f88:	00001097          	auipc	ra,0x1
    80000f8c:	034080e7          	jalr	52(ra) # 80001fbc <procinit>
    trapinit();      // trap vectors
    80000f90:	00002097          	auipc	ra,0x2
    80000f94:	e4e080e7          	jalr	-434(ra) # 80002dde <trapinit>
    trapinithart();  // install kernel trap vector
    80000f98:	00002097          	auipc	ra,0x2
    80000f9c:	e6e080e7          	jalr	-402(ra) # 80002e06 <trapinithart>
    plicinit();      // set up interrupt controller
    80000fa0:	00005097          	auipc	ra,0x5
    80000fa4:	59a080e7          	jalr	1434(ra) # 8000653a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000fa8:	00005097          	auipc	ra,0x5
    80000fac:	5ac080e7          	jalr	1452(ra) # 80006554 <plicinithart>
    binit();         // buffer cache
    80000fb0:	00002097          	auipc	ra,0x2
    80000fb4:	67a080e7          	jalr	1658(ra) # 8000362a <binit>
    iinit();         // inode table
    80000fb8:	00003097          	auipc	ra,0x3
    80000fbc:	d30080e7          	jalr	-720(ra) # 80003ce8 <iinit>
    fileinit();      // file table
    80000fc0:	00004097          	auipc	ra,0x4
    80000fc4:	ce0080e7          	jalr	-800(ra) # 80004ca0 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000fc8:	00005097          	auipc	ra,0x5
    80000fcc:	694080e7          	jalr	1684(ra) # 8000665c <virtio_disk_init>
    userinit();      // first user process
    80000fd0:	00001097          	auipc	ra,0x1
    80000fd4:	194080e7          	jalr	404(ra) # 80002164 <userinit>
    __sync_synchronize();
    80000fd8:	0330000f          	fence	rw,rw
    started = 1;
    80000fdc:	4785                	li	a5,1
    80000fde:	0000a717          	auipc	a4,0xa
    80000fe2:	64f72d23          	sw	a5,1626(a4) # 8000b638 <started>
    80000fe6:	b789                	j	80000f28 <main+0x56>

0000000080000fe8 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000fe8:	1141                	addi	sp,sp,-16
    80000fea:	e422                	sd	s0,8(sp)
    80000fec:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000fee:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000ff2:	0000a797          	auipc	a5,0xa
    80000ff6:	64e7b783          	ld	a5,1614(a5) # 8000b640 <kernel_pagetable>
    80000ffa:	83b1                	srli	a5,a5,0xc
    80000ffc:	577d                	li	a4,-1
    80000ffe:	177e                	slli	a4,a4,0x3f
    80001000:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80001002:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80001006:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    8000100a:	6422                	ld	s0,8(sp)
    8000100c:	0141                	addi	sp,sp,16
    8000100e:	8082                	ret

0000000080001010 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80001010:	7139                	addi	sp,sp,-64
    80001012:	fc06                	sd	ra,56(sp)
    80001014:	f822                	sd	s0,48(sp)
    80001016:	f426                	sd	s1,40(sp)
    80001018:	f04a                	sd	s2,32(sp)
    8000101a:	ec4e                	sd	s3,24(sp)
    8000101c:	e852                	sd	s4,16(sp)
    8000101e:	e456                	sd	s5,8(sp)
    80001020:	e05a                	sd	s6,0(sp)
    80001022:	0080                	addi	s0,sp,64
    80001024:	84aa                	mv	s1,a0
    80001026:	89ae                	mv	s3,a1
    80001028:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000102a:	57fd                	li	a5,-1
    8000102c:	83e9                	srli	a5,a5,0x1a
    8000102e:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80001030:	4b31                	li	s6,12
  if(va >= MAXVA)
    80001032:	04b7f263          	bgeu	a5,a1,80001076 <walk+0x66>
    panic("walk");
    80001036:	00007517          	auipc	a0,0x7
    8000103a:	07a50513          	addi	a0,a0,122 # 800080b0 <etext+0xb0>
    8000103e:	fffff097          	auipc	ra,0xfffff
    80001042:	522080e7          	jalr	1314(ra) # 80000560 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001046:	060a8663          	beqz	s5,800010b2 <walk+0xa2>
    8000104a:	00000097          	auipc	ra,0x0
    8000104e:	afe080e7          	jalr	-1282(ra) # 80000b48 <kalloc>
    80001052:	84aa                	mv	s1,a0
    80001054:	c529                	beqz	a0,8000109e <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80001056:	6605                	lui	a2,0x1
    80001058:	4581                	li	a1,0
    8000105a:	00000097          	auipc	ra,0x0
    8000105e:	cda080e7          	jalr	-806(ra) # 80000d34 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001062:	00c4d793          	srli	a5,s1,0xc
    80001066:	07aa                	slli	a5,a5,0xa
    80001068:	0017e793          	ori	a5,a5,1
    8000106c:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001070:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd9cdf>
    80001072:	036a0063          	beq	s4,s6,80001092 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80001076:	0149d933          	srl	s2,s3,s4
    8000107a:	1ff97913          	andi	s2,s2,511
    8000107e:	090e                	slli	s2,s2,0x3
    80001080:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001082:	00093483          	ld	s1,0(s2)
    80001086:	0014f793          	andi	a5,s1,1
    8000108a:	dfd5                	beqz	a5,80001046 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000108c:	80a9                	srli	s1,s1,0xa
    8000108e:	04b2                	slli	s1,s1,0xc
    80001090:	b7c5                	j	80001070 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80001092:	00c9d513          	srli	a0,s3,0xc
    80001096:	1ff57513          	andi	a0,a0,511
    8000109a:	050e                	slli	a0,a0,0x3
    8000109c:	9526                	add	a0,a0,s1
}
    8000109e:	70e2                	ld	ra,56(sp)
    800010a0:	7442                	ld	s0,48(sp)
    800010a2:	74a2                	ld	s1,40(sp)
    800010a4:	7902                	ld	s2,32(sp)
    800010a6:	69e2                	ld	s3,24(sp)
    800010a8:	6a42                	ld	s4,16(sp)
    800010aa:	6aa2                	ld	s5,8(sp)
    800010ac:	6b02                	ld	s6,0(sp)
    800010ae:	6121                	addi	sp,sp,64
    800010b0:	8082                	ret
        return 0;
    800010b2:	4501                	li	a0,0
    800010b4:	b7ed                	j	8000109e <walk+0x8e>

00000000800010b6 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800010b6:	57fd                	li	a5,-1
    800010b8:	83e9                	srli	a5,a5,0x1a
    800010ba:	00b7f463          	bgeu	a5,a1,800010c2 <walkaddr+0xc>
    return 0;
    800010be:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800010c0:	8082                	ret
{
    800010c2:	1141                	addi	sp,sp,-16
    800010c4:	e406                	sd	ra,8(sp)
    800010c6:	e022                	sd	s0,0(sp)
    800010c8:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800010ca:	4601                	li	a2,0
    800010cc:	00000097          	auipc	ra,0x0
    800010d0:	f44080e7          	jalr	-188(ra) # 80001010 <walk>
  if(pte == 0)
    800010d4:	c105                	beqz	a0,800010f4 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800010d6:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800010d8:	0117f693          	andi	a3,a5,17
    800010dc:	4745                	li	a4,17
    return 0;
    800010de:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800010e0:	00e68663          	beq	a3,a4,800010ec <walkaddr+0x36>
}
    800010e4:	60a2                	ld	ra,8(sp)
    800010e6:	6402                	ld	s0,0(sp)
    800010e8:	0141                	addi	sp,sp,16
    800010ea:	8082                	ret
  pa = PTE2PA(*pte);
    800010ec:	83a9                	srli	a5,a5,0xa
    800010ee:	00c79513          	slli	a0,a5,0xc
  return pa;
    800010f2:	bfcd                	j	800010e4 <walkaddr+0x2e>
    return 0;
    800010f4:	4501                	li	a0,0
    800010f6:	b7fd                	j	800010e4 <walkaddr+0x2e>

00000000800010f8 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800010f8:	715d                	addi	sp,sp,-80
    800010fa:	e486                	sd	ra,72(sp)
    800010fc:	e0a2                	sd	s0,64(sp)
    800010fe:	fc26                	sd	s1,56(sp)
    80001100:	f84a                	sd	s2,48(sp)
    80001102:	f44e                	sd	s3,40(sp)
    80001104:	f052                	sd	s4,32(sp)
    80001106:	ec56                	sd	s5,24(sp)
    80001108:	e85a                	sd	s6,16(sp)
    8000110a:	e45e                	sd	s7,8(sp)
    8000110c:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000110e:	c639                	beqz	a2,8000115c <mappages+0x64>
    80001110:	8aaa                	mv	s5,a0
    80001112:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80001114:	777d                	lui	a4,0xfffff
    80001116:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000111a:	fff58993          	addi	s3,a1,-1
    8000111e:	99b2                	add	s3,s3,a2
    80001120:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80001124:	893e                	mv	s2,a5
    80001126:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000112a:	6b85                	lui	s7,0x1
    8000112c:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80001130:	4605                	li	a2,1
    80001132:	85ca                	mv	a1,s2
    80001134:	8556                	mv	a0,s5
    80001136:	00000097          	auipc	ra,0x0
    8000113a:	eda080e7          	jalr	-294(ra) # 80001010 <walk>
    8000113e:	cd1d                	beqz	a0,8000117c <mappages+0x84>
    if(*pte & PTE_V)
    80001140:	611c                	ld	a5,0(a0)
    80001142:	8b85                	andi	a5,a5,1
    80001144:	e785                	bnez	a5,8000116c <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001146:	80b1                	srli	s1,s1,0xc
    80001148:	04aa                	slli	s1,s1,0xa
    8000114a:	0164e4b3          	or	s1,s1,s6
    8000114e:	0014e493          	ori	s1,s1,1
    80001152:	e104                	sd	s1,0(a0)
    if(a == last)
    80001154:	05390063          	beq	s2,s3,80001194 <mappages+0x9c>
    a += PGSIZE;
    80001158:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000115a:	bfc9                	j	8000112c <mappages+0x34>
    panic("mappages: size");
    8000115c:	00007517          	auipc	a0,0x7
    80001160:	f5c50513          	addi	a0,a0,-164 # 800080b8 <etext+0xb8>
    80001164:	fffff097          	auipc	ra,0xfffff
    80001168:	3fc080e7          	jalr	1020(ra) # 80000560 <panic>
      panic("mappages: remap");
    8000116c:	00007517          	auipc	a0,0x7
    80001170:	f5c50513          	addi	a0,a0,-164 # 800080c8 <etext+0xc8>
    80001174:	fffff097          	auipc	ra,0xfffff
    80001178:	3ec080e7          	jalr	1004(ra) # 80000560 <panic>
      return -1;
    8000117c:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000117e:	60a6                	ld	ra,72(sp)
    80001180:	6406                	ld	s0,64(sp)
    80001182:	74e2                	ld	s1,56(sp)
    80001184:	7942                	ld	s2,48(sp)
    80001186:	79a2                	ld	s3,40(sp)
    80001188:	7a02                	ld	s4,32(sp)
    8000118a:	6ae2                	ld	s5,24(sp)
    8000118c:	6b42                	ld	s6,16(sp)
    8000118e:	6ba2                	ld	s7,8(sp)
    80001190:	6161                	addi	sp,sp,80
    80001192:	8082                	ret
  return 0;
    80001194:	4501                	li	a0,0
    80001196:	b7e5                	j	8000117e <mappages+0x86>

0000000080001198 <kvmmap>:
{
    80001198:	1141                	addi	sp,sp,-16
    8000119a:	e406                	sd	ra,8(sp)
    8000119c:	e022                	sd	s0,0(sp)
    8000119e:	0800                	addi	s0,sp,16
    800011a0:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800011a2:	86b2                	mv	a3,a2
    800011a4:	863e                	mv	a2,a5
    800011a6:	00000097          	auipc	ra,0x0
    800011aa:	f52080e7          	jalr	-174(ra) # 800010f8 <mappages>
    800011ae:	e509                	bnez	a0,800011b8 <kvmmap+0x20>
}
    800011b0:	60a2                	ld	ra,8(sp)
    800011b2:	6402                	ld	s0,0(sp)
    800011b4:	0141                	addi	sp,sp,16
    800011b6:	8082                	ret
    panic("kvmmap");
    800011b8:	00007517          	auipc	a0,0x7
    800011bc:	f2050513          	addi	a0,a0,-224 # 800080d8 <etext+0xd8>
    800011c0:	fffff097          	auipc	ra,0xfffff
    800011c4:	3a0080e7          	jalr	928(ra) # 80000560 <panic>

00000000800011c8 <kvmmake>:
{
    800011c8:	1101                	addi	sp,sp,-32
    800011ca:	ec06                	sd	ra,24(sp)
    800011cc:	e822                	sd	s0,16(sp)
    800011ce:	e426                	sd	s1,8(sp)
    800011d0:	e04a                	sd	s2,0(sp)
    800011d2:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800011d4:	00000097          	auipc	ra,0x0
    800011d8:	974080e7          	jalr	-1676(ra) # 80000b48 <kalloc>
    800011dc:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800011de:	6605                	lui	a2,0x1
    800011e0:	4581                	li	a1,0
    800011e2:	00000097          	auipc	ra,0x0
    800011e6:	b52080e7          	jalr	-1198(ra) # 80000d34 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800011ea:	4719                	li	a4,6
    800011ec:	6685                	lui	a3,0x1
    800011ee:	10000637          	lui	a2,0x10000
    800011f2:	100005b7          	lui	a1,0x10000
    800011f6:	8526                	mv	a0,s1
    800011f8:	00000097          	auipc	ra,0x0
    800011fc:	fa0080e7          	jalr	-96(ra) # 80001198 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001200:	4719                	li	a4,6
    80001202:	6685                	lui	a3,0x1
    80001204:	10001637          	lui	a2,0x10001
    80001208:	100015b7          	lui	a1,0x10001
    8000120c:	8526                	mv	a0,s1
    8000120e:	00000097          	auipc	ra,0x0
    80001212:	f8a080e7          	jalr	-118(ra) # 80001198 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001216:	4719                	li	a4,6
    80001218:	004006b7          	lui	a3,0x400
    8000121c:	0c000637          	lui	a2,0xc000
    80001220:	0c0005b7          	lui	a1,0xc000
    80001224:	8526                	mv	a0,s1
    80001226:	00000097          	auipc	ra,0x0
    8000122a:	f72080e7          	jalr	-142(ra) # 80001198 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000122e:	00007917          	auipc	s2,0x7
    80001232:	dd290913          	addi	s2,s2,-558 # 80008000 <etext>
    80001236:	4729                	li	a4,10
    80001238:	80007697          	auipc	a3,0x80007
    8000123c:	dc868693          	addi	a3,a3,-568 # 8000 <_entry-0x7fff8000>
    80001240:	4605                	li	a2,1
    80001242:	067e                	slli	a2,a2,0x1f
    80001244:	85b2                	mv	a1,a2
    80001246:	8526                	mv	a0,s1
    80001248:	00000097          	auipc	ra,0x0
    8000124c:	f50080e7          	jalr	-176(ra) # 80001198 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001250:	46c5                	li	a3,17
    80001252:	06ee                	slli	a3,a3,0x1b
    80001254:	4719                	li	a4,6
    80001256:	412686b3          	sub	a3,a3,s2
    8000125a:	864a                	mv	a2,s2
    8000125c:	85ca                	mv	a1,s2
    8000125e:	8526                	mv	a0,s1
    80001260:	00000097          	auipc	ra,0x0
    80001264:	f38080e7          	jalr	-200(ra) # 80001198 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001268:	4729                	li	a4,10
    8000126a:	6685                	lui	a3,0x1
    8000126c:	00006617          	auipc	a2,0x6
    80001270:	d9460613          	addi	a2,a2,-620 # 80007000 <_trampoline>
    80001274:	040005b7          	lui	a1,0x4000
    80001278:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000127a:	05b2                	slli	a1,a1,0xc
    8000127c:	8526                	mv	a0,s1
    8000127e:	00000097          	auipc	ra,0x0
    80001282:	f1a080e7          	jalr	-230(ra) # 80001198 <kvmmap>
  proc_mapstacks(kpgtbl);
    80001286:	8526                	mv	a0,s1
    80001288:	00000097          	auipc	ra,0x0
    8000128c:	6ec080e7          	jalr	1772(ra) # 80001974 <proc_mapstacks>
}
    80001290:	8526                	mv	a0,s1
    80001292:	60e2                	ld	ra,24(sp)
    80001294:	6442                	ld	s0,16(sp)
    80001296:	64a2                	ld	s1,8(sp)
    80001298:	6902                	ld	s2,0(sp)
    8000129a:	6105                	addi	sp,sp,32
    8000129c:	8082                	ret

000000008000129e <kvminit>:
{
    8000129e:	1141                	addi	sp,sp,-16
    800012a0:	e406                	sd	ra,8(sp)
    800012a2:	e022                	sd	s0,0(sp)
    800012a4:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800012a6:	00000097          	auipc	ra,0x0
    800012aa:	f22080e7          	jalr	-222(ra) # 800011c8 <kvmmake>
    800012ae:	0000a797          	auipc	a5,0xa
    800012b2:	38a7b923          	sd	a0,914(a5) # 8000b640 <kernel_pagetable>
}
    800012b6:	60a2                	ld	ra,8(sp)
    800012b8:	6402                	ld	s0,0(sp)
    800012ba:	0141                	addi	sp,sp,16
    800012bc:	8082                	ret

00000000800012be <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800012be:	715d                	addi	sp,sp,-80
    800012c0:	e486                	sd	ra,72(sp)
    800012c2:	e0a2                	sd	s0,64(sp)
    800012c4:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800012c6:	03459793          	slli	a5,a1,0x34
    800012ca:	e39d                	bnez	a5,800012f0 <uvmunmap+0x32>
    800012cc:	f84a                	sd	s2,48(sp)
    800012ce:	f44e                	sd	s3,40(sp)
    800012d0:	f052                	sd	s4,32(sp)
    800012d2:	ec56                	sd	s5,24(sp)
    800012d4:	e85a                	sd	s6,16(sp)
    800012d6:	e45e                	sd	s7,8(sp)
    800012d8:	8a2a                	mv	s4,a0
    800012da:	892e                	mv	s2,a1
    800012dc:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012de:	0632                	slli	a2,a2,0xc
    800012e0:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800012e4:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012e6:	6b05                	lui	s6,0x1
    800012e8:	0935fb63          	bgeu	a1,s3,8000137e <uvmunmap+0xc0>
    800012ec:	fc26                	sd	s1,56(sp)
    800012ee:	a8a9                	j	80001348 <uvmunmap+0x8a>
    800012f0:	fc26                	sd	s1,56(sp)
    800012f2:	f84a                	sd	s2,48(sp)
    800012f4:	f44e                	sd	s3,40(sp)
    800012f6:	f052                	sd	s4,32(sp)
    800012f8:	ec56                	sd	s5,24(sp)
    800012fa:	e85a                	sd	s6,16(sp)
    800012fc:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800012fe:	00007517          	auipc	a0,0x7
    80001302:	de250513          	addi	a0,a0,-542 # 800080e0 <etext+0xe0>
    80001306:	fffff097          	auipc	ra,0xfffff
    8000130a:	25a080e7          	jalr	602(ra) # 80000560 <panic>
      panic("uvmunmap: walk");
    8000130e:	00007517          	auipc	a0,0x7
    80001312:	dea50513          	addi	a0,a0,-534 # 800080f8 <etext+0xf8>
    80001316:	fffff097          	auipc	ra,0xfffff
    8000131a:	24a080e7          	jalr	586(ra) # 80000560 <panic>
      panic("uvmunmap: not mapped");
    8000131e:	00007517          	auipc	a0,0x7
    80001322:	dea50513          	addi	a0,a0,-534 # 80008108 <etext+0x108>
    80001326:	fffff097          	auipc	ra,0xfffff
    8000132a:	23a080e7          	jalr	570(ra) # 80000560 <panic>
      panic("uvmunmap: not a leaf");
    8000132e:	00007517          	auipc	a0,0x7
    80001332:	df250513          	addi	a0,a0,-526 # 80008120 <etext+0x120>
    80001336:	fffff097          	auipc	ra,0xfffff
    8000133a:	22a080e7          	jalr	554(ra) # 80000560 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    8000133e:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001342:	995a                	add	s2,s2,s6
    80001344:	03397c63          	bgeu	s2,s3,8000137c <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001348:	4601                	li	a2,0
    8000134a:	85ca                	mv	a1,s2
    8000134c:	8552                	mv	a0,s4
    8000134e:	00000097          	auipc	ra,0x0
    80001352:	cc2080e7          	jalr	-830(ra) # 80001010 <walk>
    80001356:	84aa                	mv	s1,a0
    80001358:	d95d                	beqz	a0,8000130e <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    8000135a:	6108                	ld	a0,0(a0)
    8000135c:	00157793          	andi	a5,a0,1
    80001360:	dfdd                	beqz	a5,8000131e <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001362:	3ff57793          	andi	a5,a0,1023
    80001366:	fd7784e3          	beq	a5,s7,8000132e <uvmunmap+0x70>
    if(do_free){
    8000136a:	fc0a8ae3          	beqz	s5,8000133e <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    8000136e:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001370:	0532                	slli	a0,a0,0xc
    80001372:	fffff097          	auipc	ra,0xfffff
    80001376:	6d8080e7          	jalr	1752(ra) # 80000a4a <kfree>
    8000137a:	b7d1                	j	8000133e <uvmunmap+0x80>
    8000137c:	74e2                	ld	s1,56(sp)
    8000137e:	7942                	ld	s2,48(sp)
    80001380:	79a2                	ld	s3,40(sp)
    80001382:	7a02                	ld	s4,32(sp)
    80001384:	6ae2                	ld	s5,24(sp)
    80001386:	6b42                	ld	s6,16(sp)
    80001388:	6ba2                	ld	s7,8(sp)
  }
}
    8000138a:	60a6                	ld	ra,72(sp)
    8000138c:	6406                	ld	s0,64(sp)
    8000138e:	6161                	addi	sp,sp,80
    80001390:	8082                	ret

0000000080001392 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001392:	1101                	addi	sp,sp,-32
    80001394:	ec06                	sd	ra,24(sp)
    80001396:	e822                	sd	s0,16(sp)
    80001398:	e426                	sd	s1,8(sp)
    8000139a:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000139c:	fffff097          	auipc	ra,0xfffff
    800013a0:	7ac080e7          	jalr	1964(ra) # 80000b48 <kalloc>
    800013a4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800013a6:	c519                	beqz	a0,800013b4 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800013a8:	6605                	lui	a2,0x1
    800013aa:	4581                	li	a1,0
    800013ac:	00000097          	auipc	ra,0x0
    800013b0:	988080e7          	jalr	-1656(ra) # 80000d34 <memset>
  return pagetable;
}
    800013b4:	8526                	mv	a0,s1
    800013b6:	60e2                	ld	ra,24(sp)
    800013b8:	6442                	ld	s0,16(sp)
    800013ba:	64a2                	ld	s1,8(sp)
    800013bc:	6105                	addi	sp,sp,32
    800013be:	8082                	ret

00000000800013c0 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800013c0:	7179                	addi	sp,sp,-48
    800013c2:	f406                	sd	ra,40(sp)
    800013c4:	f022                	sd	s0,32(sp)
    800013c6:	ec26                	sd	s1,24(sp)
    800013c8:	e84a                	sd	s2,16(sp)
    800013ca:	e44e                	sd	s3,8(sp)
    800013cc:	e052                	sd	s4,0(sp)
    800013ce:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800013d0:	6785                	lui	a5,0x1
    800013d2:	04f67863          	bgeu	a2,a5,80001422 <uvmfirst+0x62>
    800013d6:	8a2a                	mv	s4,a0
    800013d8:	89ae                	mv	s3,a1
    800013da:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800013dc:	fffff097          	auipc	ra,0xfffff
    800013e0:	76c080e7          	jalr	1900(ra) # 80000b48 <kalloc>
    800013e4:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800013e6:	6605                	lui	a2,0x1
    800013e8:	4581                	li	a1,0
    800013ea:	00000097          	auipc	ra,0x0
    800013ee:	94a080e7          	jalr	-1718(ra) # 80000d34 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800013f2:	4779                	li	a4,30
    800013f4:	86ca                	mv	a3,s2
    800013f6:	6605                	lui	a2,0x1
    800013f8:	4581                	li	a1,0
    800013fa:	8552                	mv	a0,s4
    800013fc:	00000097          	auipc	ra,0x0
    80001400:	cfc080e7          	jalr	-772(ra) # 800010f8 <mappages>
  memmove(mem, src, sz);
    80001404:	8626                	mv	a2,s1
    80001406:	85ce                	mv	a1,s3
    80001408:	854a                	mv	a0,s2
    8000140a:	00000097          	auipc	ra,0x0
    8000140e:	986080e7          	jalr	-1658(ra) # 80000d90 <memmove>
}
    80001412:	70a2                	ld	ra,40(sp)
    80001414:	7402                	ld	s0,32(sp)
    80001416:	64e2                	ld	s1,24(sp)
    80001418:	6942                	ld	s2,16(sp)
    8000141a:	69a2                	ld	s3,8(sp)
    8000141c:	6a02                	ld	s4,0(sp)
    8000141e:	6145                	addi	sp,sp,48
    80001420:	8082                	ret
    panic("uvmfirst: more than a page");
    80001422:	00007517          	auipc	a0,0x7
    80001426:	d1650513          	addi	a0,a0,-746 # 80008138 <etext+0x138>
    8000142a:	fffff097          	auipc	ra,0xfffff
    8000142e:	136080e7          	jalr	310(ra) # 80000560 <panic>

0000000080001432 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001432:	1101                	addi	sp,sp,-32
    80001434:	ec06                	sd	ra,24(sp)
    80001436:	e822                	sd	s0,16(sp)
    80001438:	e426                	sd	s1,8(sp)
    8000143a:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000143c:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000143e:	00b67d63          	bgeu	a2,a1,80001458 <uvmdealloc+0x26>
    80001442:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001444:	6785                	lui	a5,0x1
    80001446:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001448:	00f60733          	add	a4,a2,a5
    8000144c:	76fd                	lui	a3,0xfffff
    8000144e:	8f75                	and	a4,a4,a3
    80001450:	97ae                	add	a5,a5,a1
    80001452:	8ff5                	and	a5,a5,a3
    80001454:	00f76863          	bltu	a4,a5,80001464 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001458:	8526                	mv	a0,s1
    8000145a:	60e2                	ld	ra,24(sp)
    8000145c:	6442                	ld	s0,16(sp)
    8000145e:	64a2                	ld	s1,8(sp)
    80001460:	6105                	addi	sp,sp,32
    80001462:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001464:	8f99                	sub	a5,a5,a4
    80001466:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001468:	4685                	li	a3,1
    8000146a:	0007861b          	sext.w	a2,a5
    8000146e:	85ba                	mv	a1,a4
    80001470:	00000097          	auipc	ra,0x0
    80001474:	e4e080e7          	jalr	-434(ra) # 800012be <uvmunmap>
    80001478:	b7c5                	j	80001458 <uvmdealloc+0x26>

000000008000147a <uvmalloc>:
  if(newsz < oldsz)
    8000147a:	0ab66b63          	bltu	a2,a1,80001530 <uvmalloc+0xb6>
{
    8000147e:	7139                	addi	sp,sp,-64
    80001480:	fc06                	sd	ra,56(sp)
    80001482:	f822                	sd	s0,48(sp)
    80001484:	ec4e                	sd	s3,24(sp)
    80001486:	e852                	sd	s4,16(sp)
    80001488:	e456                	sd	s5,8(sp)
    8000148a:	0080                	addi	s0,sp,64
    8000148c:	8aaa                	mv	s5,a0
    8000148e:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001490:	6785                	lui	a5,0x1
    80001492:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001494:	95be                	add	a1,a1,a5
    80001496:	77fd                	lui	a5,0xfffff
    80001498:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000149c:	08c9fc63          	bgeu	s3,a2,80001534 <uvmalloc+0xba>
    800014a0:	f426                	sd	s1,40(sp)
    800014a2:	f04a                	sd	s2,32(sp)
    800014a4:	e05a                	sd	s6,0(sp)
    800014a6:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800014a8:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800014ac:	fffff097          	auipc	ra,0xfffff
    800014b0:	69c080e7          	jalr	1692(ra) # 80000b48 <kalloc>
    800014b4:	84aa                	mv	s1,a0
    if(mem == 0){
    800014b6:	c915                	beqz	a0,800014ea <uvmalloc+0x70>
    memset(mem, 0, PGSIZE);
    800014b8:	6605                	lui	a2,0x1
    800014ba:	4581                	li	a1,0
    800014bc:	00000097          	auipc	ra,0x0
    800014c0:	878080e7          	jalr	-1928(ra) # 80000d34 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800014c4:	875a                	mv	a4,s6
    800014c6:	86a6                	mv	a3,s1
    800014c8:	6605                	lui	a2,0x1
    800014ca:	85ca                	mv	a1,s2
    800014cc:	8556                	mv	a0,s5
    800014ce:	00000097          	auipc	ra,0x0
    800014d2:	c2a080e7          	jalr	-982(ra) # 800010f8 <mappages>
    800014d6:	ed05                	bnez	a0,8000150e <uvmalloc+0x94>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800014d8:	6785                	lui	a5,0x1
    800014da:	993e                	add	s2,s2,a5
    800014dc:	fd4968e3          	bltu	s2,s4,800014ac <uvmalloc+0x32>
  return newsz;
    800014e0:	8552                	mv	a0,s4
    800014e2:	74a2                	ld	s1,40(sp)
    800014e4:	7902                	ld	s2,32(sp)
    800014e6:	6b02                	ld	s6,0(sp)
    800014e8:	a821                	j	80001500 <uvmalloc+0x86>
      uvmdealloc(pagetable, a, oldsz);
    800014ea:	864e                	mv	a2,s3
    800014ec:	85ca                	mv	a1,s2
    800014ee:	8556                	mv	a0,s5
    800014f0:	00000097          	auipc	ra,0x0
    800014f4:	f42080e7          	jalr	-190(ra) # 80001432 <uvmdealloc>
      return 0;
    800014f8:	4501                	li	a0,0
    800014fa:	74a2                	ld	s1,40(sp)
    800014fc:	7902                	ld	s2,32(sp)
    800014fe:	6b02                	ld	s6,0(sp)
}
    80001500:	70e2                	ld	ra,56(sp)
    80001502:	7442                	ld	s0,48(sp)
    80001504:	69e2                	ld	s3,24(sp)
    80001506:	6a42                	ld	s4,16(sp)
    80001508:	6aa2                	ld	s5,8(sp)
    8000150a:	6121                	addi	sp,sp,64
    8000150c:	8082                	ret
      kfree(mem);
    8000150e:	8526                	mv	a0,s1
    80001510:	fffff097          	auipc	ra,0xfffff
    80001514:	53a080e7          	jalr	1338(ra) # 80000a4a <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001518:	864e                	mv	a2,s3
    8000151a:	85ca                	mv	a1,s2
    8000151c:	8556                	mv	a0,s5
    8000151e:	00000097          	auipc	ra,0x0
    80001522:	f14080e7          	jalr	-236(ra) # 80001432 <uvmdealloc>
      return 0;
    80001526:	4501                	li	a0,0
    80001528:	74a2                	ld	s1,40(sp)
    8000152a:	7902                	ld	s2,32(sp)
    8000152c:	6b02                	ld	s6,0(sp)
    8000152e:	bfc9                	j	80001500 <uvmalloc+0x86>
    return oldsz;
    80001530:	852e                	mv	a0,a1
}
    80001532:	8082                	ret
  return newsz;
    80001534:	8532                	mv	a0,a2
    80001536:	b7e9                	j	80001500 <uvmalloc+0x86>

0000000080001538 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001538:	7179                	addi	sp,sp,-48
    8000153a:	f406                	sd	ra,40(sp)
    8000153c:	f022                	sd	s0,32(sp)
    8000153e:	ec26                	sd	s1,24(sp)
    80001540:	e84a                	sd	s2,16(sp)
    80001542:	e44e                	sd	s3,8(sp)
    80001544:	e052                	sd	s4,0(sp)
    80001546:	1800                	addi	s0,sp,48
    80001548:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000154a:	84aa                	mv	s1,a0
    8000154c:	6905                	lui	s2,0x1
    8000154e:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001550:	4985                	li	s3,1
    80001552:	a829                	j	8000156c <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001554:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001556:	00c79513          	slli	a0,a5,0xc
    8000155a:	00000097          	auipc	ra,0x0
    8000155e:	fde080e7          	jalr	-34(ra) # 80001538 <freewalk>
      pagetable[i] = 0;
    80001562:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001566:	04a1                	addi	s1,s1,8
    80001568:	03248163          	beq	s1,s2,8000158a <freewalk+0x52>
    pte_t pte = pagetable[i];
    8000156c:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000156e:	00f7f713          	andi	a4,a5,15
    80001572:	ff3701e3          	beq	a4,s3,80001554 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001576:	8b85                	andi	a5,a5,1
    80001578:	d7fd                	beqz	a5,80001566 <freewalk+0x2e>
      panic("freewalk: leaf");
    8000157a:	00007517          	auipc	a0,0x7
    8000157e:	bde50513          	addi	a0,a0,-1058 # 80008158 <etext+0x158>
    80001582:	fffff097          	auipc	ra,0xfffff
    80001586:	fde080e7          	jalr	-34(ra) # 80000560 <panic>
    }
  }
  kfree((void*)pagetable);
    8000158a:	8552                	mv	a0,s4
    8000158c:	fffff097          	auipc	ra,0xfffff
    80001590:	4be080e7          	jalr	1214(ra) # 80000a4a <kfree>
}
    80001594:	70a2                	ld	ra,40(sp)
    80001596:	7402                	ld	s0,32(sp)
    80001598:	64e2                	ld	s1,24(sp)
    8000159a:	6942                	ld	s2,16(sp)
    8000159c:	69a2                	ld	s3,8(sp)
    8000159e:	6a02                	ld	s4,0(sp)
    800015a0:	6145                	addi	sp,sp,48
    800015a2:	8082                	ret

00000000800015a4 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800015a4:	1101                	addi	sp,sp,-32
    800015a6:	ec06                	sd	ra,24(sp)
    800015a8:	e822                	sd	s0,16(sp)
    800015aa:	e426                	sd	s1,8(sp)
    800015ac:	1000                	addi	s0,sp,32
    800015ae:	84aa                	mv	s1,a0
  if(sz > 0)
    800015b0:	e999                	bnez	a1,800015c6 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800015b2:	8526                	mv	a0,s1
    800015b4:	00000097          	auipc	ra,0x0
    800015b8:	f84080e7          	jalr	-124(ra) # 80001538 <freewalk>
}
    800015bc:	60e2                	ld	ra,24(sp)
    800015be:	6442                	ld	s0,16(sp)
    800015c0:	64a2                	ld	s1,8(sp)
    800015c2:	6105                	addi	sp,sp,32
    800015c4:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800015c6:	6785                	lui	a5,0x1
    800015c8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800015ca:	95be                	add	a1,a1,a5
    800015cc:	4685                	li	a3,1
    800015ce:	00c5d613          	srli	a2,a1,0xc
    800015d2:	4581                	li	a1,0
    800015d4:	00000097          	auipc	ra,0x0
    800015d8:	cea080e7          	jalr	-790(ra) # 800012be <uvmunmap>
    800015dc:	bfd9                	j	800015b2 <uvmfree+0xe>

00000000800015de <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800015de:	c679                	beqz	a2,800016ac <uvmcopy+0xce>
{
    800015e0:	715d                	addi	sp,sp,-80
    800015e2:	e486                	sd	ra,72(sp)
    800015e4:	e0a2                	sd	s0,64(sp)
    800015e6:	fc26                	sd	s1,56(sp)
    800015e8:	f84a                	sd	s2,48(sp)
    800015ea:	f44e                	sd	s3,40(sp)
    800015ec:	f052                	sd	s4,32(sp)
    800015ee:	ec56                	sd	s5,24(sp)
    800015f0:	e85a                	sd	s6,16(sp)
    800015f2:	e45e                	sd	s7,8(sp)
    800015f4:	0880                	addi	s0,sp,80
    800015f6:	8b2a                	mv	s6,a0
    800015f8:	8aae                	mv	s5,a1
    800015fa:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    800015fc:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    800015fe:	4601                	li	a2,0
    80001600:	85ce                	mv	a1,s3
    80001602:	855a                	mv	a0,s6
    80001604:	00000097          	auipc	ra,0x0
    80001608:	a0c080e7          	jalr	-1524(ra) # 80001010 <walk>
    8000160c:	c531                	beqz	a0,80001658 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    8000160e:	6118                	ld	a4,0(a0)
    80001610:	00177793          	andi	a5,a4,1
    80001614:	cbb1                	beqz	a5,80001668 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001616:	00a75593          	srli	a1,a4,0xa
    8000161a:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    8000161e:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80001622:	fffff097          	auipc	ra,0xfffff
    80001626:	526080e7          	jalr	1318(ra) # 80000b48 <kalloc>
    8000162a:	892a                	mv	s2,a0
    8000162c:	c939                	beqz	a0,80001682 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    8000162e:	6605                	lui	a2,0x1
    80001630:	85de                	mv	a1,s7
    80001632:	fffff097          	auipc	ra,0xfffff
    80001636:	75e080e7          	jalr	1886(ra) # 80000d90 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000163a:	8726                	mv	a4,s1
    8000163c:	86ca                	mv	a3,s2
    8000163e:	6605                	lui	a2,0x1
    80001640:	85ce                	mv	a1,s3
    80001642:	8556                	mv	a0,s5
    80001644:	00000097          	auipc	ra,0x0
    80001648:	ab4080e7          	jalr	-1356(ra) # 800010f8 <mappages>
    8000164c:	e515                	bnez	a0,80001678 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    8000164e:	6785                	lui	a5,0x1
    80001650:	99be                	add	s3,s3,a5
    80001652:	fb49e6e3          	bltu	s3,s4,800015fe <uvmcopy+0x20>
    80001656:	a081                	j	80001696 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80001658:	00007517          	auipc	a0,0x7
    8000165c:	b1050513          	addi	a0,a0,-1264 # 80008168 <etext+0x168>
    80001660:	fffff097          	auipc	ra,0xfffff
    80001664:	f00080e7          	jalr	-256(ra) # 80000560 <panic>
      panic("uvmcopy: page not present");
    80001668:	00007517          	auipc	a0,0x7
    8000166c:	b2050513          	addi	a0,a0,-1248 # 80008188 <etext+0x188>
    80001670:	fffff097          	auipc	ra,0xfffff
    80001674:	ef0080e7          	jalr	-272(ra) # 80000560 <panic>
      kfree(mem);
    80001678:	854a                	mv	a0,s2
    8000167a:	fffff097          	auipc	ra,0xfffff
    8000167e:	3d0080e7          	jalr	976(ra) # 80000a4a <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001682:	4685                	li	a3,1
    80001684:	00c9d613          	srli	a2,s3,0xc
    80001688:	4581                	li	a1,0
    8000168a:	8556                	mv	a0,s5
    8000168c:	00000097          	auipc	ra,0x0
    80001690:	c32080e7          	jalr	-974(ra) # 800012be <uvmunmap>
  return -1;
    80001694:	557d                	li	a0,-1
}
    80001696:	60a6                	ld	ra,72(sp)
    80001698:	6406                	ld	s0,64(sp)
    8000169a:	74e2                	ld	s1,56(sp)
    8000169c:	7942                	ld	s2,48(sp)
    8000169e:	79a2                	ld	s3,40(sp)
    800016a0:	7a02                	ld	s4,32(sp)
    800016a2:	6ae2                	ld	s5,24(sp)
    800016a4:	6b42                	ld	s6,16(sp)
    800016a6:	6ba2                	ld	s7,8(sp)
    800016a8:	6161                	addi	sp,sp,80
    800016aa:	8082                	ret
  return 0;
    800016ac:	4501                	li	a0,0
}
    800016ae:	8082                	ret

00000000800016b0 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800016b0:	1141                	addi	sp,sp,-16
    800016b2:	e406                	sd	ra,8(sp)
    800016b4:	e022                	sd	s0,0(sp)
    800016b6:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800016b8:	4601                	li	a2,0
    800016ba:	00000097          	auipc	ra,0x0
    800016be:	956080e7          	jalr	-1706(ra) # 80001010 <walk>
  if(pte == 0)
    800016c2:	c901                	beqz	a0,800016d2 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800016c4:	611c                	ld	a5,0(a0)
    800016c6:	9bbd                	andi	a5,a5,-17
    800016c8:	e11c                	sd	a5,0(a0)
}
    800016ca:	60a2                	ld	ra,8(sp)
    800016cc:	6402                	ld	s0,0(sp)
    800016ce:	0141                	addi	sp,sp,16
    800016d0:	8082                	ret
    panic("uvmclear");
    800016d2:	00007517          	auipc	a0,0x7
    800016d6:	ad650513          	addi	a0,a0,-1322 # 800081a8 <etext+0x1a8>
    800016da:	fffff097          	auipc	ra,0xfffff
    800016de:	e86080e7          	jalr	-378(ra) # 80000560 <panic>

00000000800016e2 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800016e2:	c6bd                	beqz	a3,80001750 <copyout+0x6e>
{
    800016e4:	715d                	addi	sp,sp,-80
    800016e6:	e486                	sd	ra,72(sp)
    800016e8:	e0a2                	sd	s0,64(sp)
    800016ea:	fc26                	sd	s1,56(sp)
    800016ec:	f84a                	sd	s2,48(sp)
    800016ee:	f44e                	sd	s3,40(sp)
    800016f0:	f052                	sd	s4,32(sp)
    800016f2:	ec56                	sd	s5,24(sp)
    800016f4:	e85a                	sd	s6,16(sp)
    800016f6:	e45e                	sd	s7,8(sp)
    800016f8:	e062                	sd	s8,0(sp)
    800016fa:	0880                	addi	s0,sp,80
    800016fc:	8b2a                	mv	s6,a0
    800016fe:	8c2e                	mv	s8,a1
    80001700:	8a32                	mv	s4,a2
    80001702:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001704:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001706:	6a85                	lui	s5,0x1
    80001708:	a015                	j	8000172c <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    8000170a:	9562                	add	a0,a0,s8
    8000170c:	0004861b          	sext.w	a2,s1
    80001710:	85d2                	mv	a1,s4
    80001712:	41250533          	sub	a0,a0,s2
    80001716:	fffff097          	auipc	ra,0xfffff
    8000171a:	67a080e7          	jalr	1658(ra) # 80000d90 <memmove>

    len -= n;
    8000171e:	409989b3          	sub	s3,s3,s1
    src += n;
    80001722:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80001724:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001728:	02098263          	beqz	s3,8000174c <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    8000172c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001730:	85ca                	mv	a1,s2
    80001732:	855a                	mv	a0,s6
    80001734:	00000097          	auipc	ra,0x0
    80001738:	982080e7          	jalr	-1662(ra) # 800010b6 <walkaddr>
    if(pa0 == 0)
    8000173c:	cd01                	beqz	a0,80001754 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    8000173e:	418904b3          	sub	s1,s2,s8
    80001742:	94d6                	add	s1,s1,s5
    if(n > len)
    80001744:	fc99f3e3          	bgeu	s3,s1,8000170a <copyout+0x28>
    80001748:	84ce                	mv	s1,s3
    8000174a:	b7c1                	j	8000170a <copyout+0x28>
  }
  return 0;
    8000174c:	4501                	li	a0,0
    8000174e:	a021                	j	80001756 <copyout+0x74>
    80001750:	4501                	li	a0,0
}
    80001752:	8082                	ret
      return -1;
    80001754:	557d                	li	a0,-1
}
    80001756:	60a6                	ld	ra,72(sp)
    80001758:	6406                	ld	s0,64(sp)
    8000175a:	74e2                	ld	s1,56(sp)
    8000175c:	7942                	ld	s2,48(sp)
    8000175e:	79a2                	ld	s3,40(sp)
    80001760:	7a02                	ld	s4,32(sp)
    80001762:	6ae2                	ld	s5,24(sp)
    80001764:	6b42                	ld	s6,16(sp)
    80001766:	6ba2                	ld	s7,8(sp)
    80001768:	6c02                	ld	s8,0(sp)
    8000176a:	6161                	addi	sp,sp,80
    8000176c:	8082                	ret

000000008000176e <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000176e:	caa5                	beqz	a3,800017de <copyin+0x70>
{
    80001770:	715d                	addi	sp,sp,-80
    80001772:	e486                	sd	ra,72(sp)
    80001774:	e0a2                	sd	s0,64(sp)
    80001776:	fc26                	sd	s1,56(sp)
    80001778:	f84a                	sd	s2,48(sp)
    8000177a:	f44e                	sd	s3,40(sp)
    8000177c:	f052                	sd	s4,32(sp)
    8000177e:	ec56                	sd	s5,24(sp)
    80001780:	e85a                	sd	s6,16(sp)
    80001782:	e45e                	sd	s7,8(sp)
    80001784:	e062                	sd	s8,0(sp)
    80001786:	0880                	addi	s0,sp,80
    80001788:	8b2a                	mv	s6,a0
    8000178a:	8a2e                	mv	s4,a1
    8000178c:	8c32                	mv	s8,a2
    8000178e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001790:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001792:	6a85                	lui	s5,0x1
    80001794:	a01d                	j	800017ba <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001796:	018505b3          	add	a1,a0,s8
    8000179a:	0004861b          	sext.w	a2,s1
    8000179e:	412585b3          	sub	a1,a1,s2
    800017a2:	8552                	mv	a0,s4
    800017a4:	fffff097          	auipc	ra,0xfffff
    800017a8:	5ec080e7          	jalr	1516(ra) # 80000d90 <memmove>

    len -= n;
    800017ac:	409989b3          	sub	s3,s3,s1
    dst += n;
    800017b0:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    800017b2:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800017b6:	02098263          	beqz	s3,800017da <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    800017ba:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800017be:	85ca                	mv	a1,s2
    800017c0:	855a                	mv	a0,s6
    800017c2:	00000097          	auipc	ra,0x0
    800017c6:	8f4080e7          	jalr	-1804(ra) # 800010b6 <walkaddr>
    if(pa0 == 0)
    800017ca:	cd01                	beqz	a0,800017e2 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    800017cc:	418904b3          	sub	s1,s2,s8
    800017d0:	94d6                	add	s1,s1,s5
    if(n > len)
    800017d2:	fc99f2e3          	bgeu	s3,s1,80001796 <copyin+0x28>
    800017d6:	84ce                	mv	s1,s3
    800017d8:	bf7d                	j	80001796 <copyin+0x28>
  }
  return 0;
    800017da:	4501                	li	a0,0
    800017dc:	a021                	j	800017e4 <copyin+0x76>
    800017de:	4501                	li	a0,0
}
    800017e0:	8082                	ret
      return -1;
    800017e2:	557d                	li	a0,-1
}
    800017e4:	60a6                	ld	ra,72(sp)
    800017e6:	6406                	ld	s0,64(sp)
    800017e8:	74e2                	ld	s1,56(sp)
    800017ea:	7942                	ld	s2,48(sp)
    800017ec:	79a2                	ld	s3,40(sp)
    800017ee:	7a02                	ld	s4,32(sp)
    800017f0:	6ae2                	ld	s5,24(sp)
    800017f2:	6b42                	ld	s6,16(sp)
    800017f4:	6ba2                	ld	s7,8(sp)
    800017f6:	6c02                	ld	s8,0(sp)
    800017f8:	6161                	addi	sp,sp,80
    800017fa:	8082                	ret

00000000800017fc <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800017fc:	cacd                	beqz	a3,800018ae <copyinstr+0xb2>
{
    800017fe:	715d                	addi	sp,sp,-80
    80001800:	e486                	sd	ra,72(sp)
    80001802:	e0a2                	sd	s0,64(sp)
    80001804:	fc26                	sd	s1,56(sp)
    80001806:	f84a                	sd	s2,48(sp)
    80001808:	f44e                	sd	s3,40(sp)
    8000180a:	f052                	sd	s4,32(sp)
    8000180c:	ec56                	sd	s5,24(sp)
    8000180e:	e85a                	sd	s6,16(sp)
    80001810:	e45e                	sd	s7,8(sp)
    80001812:	0880                	addi	s0,sp,80
    80001814:	8a2a                	mv	s4,a0
    80001816:	8b2e                	mv	s6,a1
    80001818:	8bb2                	mv	s7,a2
    8000181a:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    8000181c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000181e:	6985                	lui	s3,0x1
    80001820:	a825                	j	80001858 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001822:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001826:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001828:	37fd                	addiw	a5,a5,-1
    8000182a:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    8000182e:	60a6                	ld	ra,72(sp)
    80001830:	6406                	ld	s0,64(sp)
    80001832:	74e2                	ld	s1,56(sp)
    80001834:	7942                	ld	s2,48(sp)
    80001836:	79a2                	ld	s3,40(sp)
    80001838:	7a02                	ld	s4,32(sp)
    8000183a:	6ae2                	ld	s5,24(sp)
    8000183c:	6b42                	ld	s6,16(sp)
    8000183e:	6ba2                	ld	s7,8(sp)
    80001840:	6161                	addi	sp,sp,80
    80001842:	8082                	ret
    80001844:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80001848:	9742                	add	a4,a4,a6
      --max;
    8000184a:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    8000184e:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80001852:	04e58663          	beq	a1,a4,8000189e <copyinstr+0xa2>
{
    80001856:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80001858:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    8000185c:	85a6                	mv	a1,s1
    8000185e:	8552                	mv	a0,s4
    80001860:	00000097          	auipc	ra,0x0
    80001864:	856080e7          	jalr	-1962(ra) # 800010b6 <walkaddr>
    if(pa0 == 0)
    80001868:	cd0d                	beqz	a0,800018a2 <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    8000186a:	417486b3          	sub	a3,s1,s7
    8000186e:	96ce                	add	a3,a3,s3
    if(n > max)
    80001870:	00d97363          	bgeu	s2,a3,80001876 <copyinstr+0x7a>
    80001874:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80001876:	955e                	add	a0,a0,s7
    80001878:	8d05                	sub	a0,a0,s1
    while(n > 0){
    8000187a:	c695                	beqz	a3,800018a6 <copyinstr+0xaa>
    8000187c:	87da                	mv	a5,s6
    8000187e:	885a                	mv	a6,s6
      if(*p == '\0'){
    80001880:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80001884:	96da                	add	a3,a3,s6
    80001886:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001888:	00f60733          	add	a4,a2,a5
    8000188c:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd9ce8>
    80001890:	db49                	beqz	a4,80001822 <copyinstr+0x26>
        *dst = *p;
    80001892:	00e78023          	sb	a4,0(a5)
      dst++;
    80001896:	0785                	addi	a5,a5,1
    while(n > 0){
    80001898:	fed797e3          	bne	a5,a3,80001886 <copyinstr+0x8a>
    8000189c:	b765                	j	80001844 <copyinstr+0x48>
    8000189e:	4781                	li	a5,0
    800018a0:	b761                	j	80001828 <copyinstr+0x2c>
      return -1;
    800018a2:	557d                	li	a0,-1
    800018a4:	b769                	j	8000182e <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    800018a6:	6b85                	lui	s7,0x1
    800018a8:	9ba6                	add	s7,s7,s1
    800018aa:	87da                	mv	a5,s6
    800018ac:	b76d                	j	80001856 <copyinstr+0x5a>
  int got_null = 0;
    800018ae:	4781                	li	a5,0
  if(got_null){
    800018b0:	37fd                	addiw	a5,a5,-1
    800018b2:	0007851b          	sext.w	a0,a5
}
    800018b6:	8082                	ret

00000000800018b8 <opt_scheduler>:
        }
    }
}

// Optimized Scheduler
void opt_scheduler(void){
    800018b8:	1141                	addi	sp,sp,-16
    800018ba:	e422                	sd	s0,8(sp)
    800018bc:	0800                	addi	s0,sp,16
    return;
}
    800018be:	6422                	ld	s0,8(sp)
    800018c0:	0141                	addi	sp,sp,16
    800018c2:	8082                	ret

00000000800018c4 <rr_scheduler>:
{
    800018c4:	7139                	addi	sp,sp,-64
    800018c6:	fc06                	sd	ra,56(sp)
    800018c8:	f822                	sd	s0,48(sp)
    800018ca:	f426                	sd	s1,40(sp)
    800018cc:	f04a                	sd	s2,32(sp)
    800018ce:	ec4e                	sd	s3,24(sp)
    800018d0:	e852                	sd	s4,16(sp)
    800018d2:	e456                	sd	s5,8(sp)
    800018d4:	e05a                	sd	s6,0(sp)
    800018d6:	0080                	addi	s0,sp,64
  asm volatile("mv %0, tp" : "=r" (x) );
    800018d8:	8792                	mv	a5,tp
    int id = r_tp();
    800018da:	2781                	sext.w	a5,a5
    c->proc = 0;
    800018dc:	00012a97          	auipc	s5,0x12
    800018e0:	fe4a8a93          	addi	s5,s5,-28 # 800138c0 <cpus>
    800018e4:	00779713          	slli	a4,a5,0x7
    800018e8:	00ea86b3          	add	a3,s5,a4
    800018ec:	0006b023          	sd	zero,0(a3) # fffffffffffff000 <end+0xffffffff7ffd9ce8>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018f0:	100026f3          	csrr	a3,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800018f4:	0026e693          	ori	a3,a3,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018f8:	10069073          	csrw	sstatus,a3
            swtch(&c->context, &p->context);
    800018fc:	0721                	addi	a4,a4,8
    800018fe:	9aba                	add	s5,s5,a4
    for (p = proc; p < &proc[NPROC]; p++)
    80001900:	00013497          	auipc	s1,0x13
    80001904:	a3848493          	addi	s1,s1,-1480 # 80014338 <proc>
        if (p->state == RUNNABLE)
    80001908:	498d                	li	s3,3
            p->state = RUNNING;
    8000190a:	4b11                	li	s6,4
            c->proc = p;
    8000190c:	079e                	slli	a5,a5,0x7
    8000190e:	00012a17          	auipc	s4,0x12
    80001912:	fb2a0a13          	addi	s4,s4,-78 # 800138c0 <cpus>
    80001916:	9a3e                	add	s4,s4,a5
    for (p = proc; p < &proc[NPROC]; p++)
    80001918:	00018917          	auipc	s2,0x18
    8000191c:	62090913          	addi	s2,s2,1568 # 80019f38 <tickslock>
    80001920:	a811                	j	80001934 <rr_scheduler+0x70>
        release(&p->lock);
    80001922:	8526                	mv	a0,s1
    80001924:	fffff097          	auipc	ra,0xfffff
    80001928:	3c8080e7          	jalr	968(ra) # 80000cec <release>
    for (p = proc; p < &proc[NPROC]; p++)
    8000192c:	17048493          	addi	s1,s1,368
    80001930:	03248863          	beq	s1,s2,80001960 <rr_scheduler+0x9c>
        acquire(&p->lock);
    80001934:	8526                	mv	a0,s1
    80001936:	fffff097          	auipc	ra,0xfffff
    8000193a:	302080e7          	jalr	770(ra) # 80000c38 <acquire>
        if (p->state == RUNNABLE)
    8000193e:	4c9c                	lw	a5,24(s1)
    80001940:	ff3791e3          	bne	a5,s3,80001922 <rr_scheduler+0x5e>
            p->state = RUNNING;
    80001944:	0164ac23          	sw	s6,24(s1)
            c->proc = p;
    80001948:	009a3023          	sd	s1,0(s4)
            swtch(&c->context, &p->context);
    8000194c:	06848593          	addi	a1,s1,104
    80001950:	8556                	mv	a0,s5
    80001952:	00001097          	auipc	ra,0x1
    80001956:	422080e7          	jalr	1058(ra) # 80002d74 <swtch>
            c->proc = 0;
    8000195a:	000a3023          	sd	zero,0(s4)
    8000195e:	b7d1                	j	80001922 <rr_scheduler+0x5e>
}
    80001960:	70e2                	ld	ra,56(sp)
    80001962:	7442                	ld	s0,48(sp)
    80001964:	74a2                	ld	s1,40(sp)
    80001966:	7902                	ld	s2,32(sp)
    80001968:	69e2                	ld	s3,24(sp)
    8000196a:	6a42                	ld	s4,16(sp)
    8000196c:	6aa2                	ld	s5,8(sp)
    8000196e:	6b02                	ld	s6,0(sp)
    80001970:	6121                	addi	sp,sp,64
    80001972:	8082                	ret

0000000080001974 <proc_mapstacks>:
{
    80001974:	7139                	addi	sp,sp,-64
    80001976:	fc06                	sd	ra,56(sp)
    80001978:	f822                	sd	s0,48(sp)
    8000197a:	f426                	sd	s1,40(sp)
    8000197c:	f04a                	sd	s2,32(sp)
    8000197e:	ec4e                	sd	s3,24(sp)
    80001980:	e852                	sd	s4,16(sp)
    80001982:	e456                	sd	s5,8(sp)
    80001984:	e05a                	sd	s6,0(sp)
    80001986:	0080                	addi	s0,sp,64
    80001988:	8a2a                	mv	s4,a0
    for (p = proc; p < &proc[NPROC]; p++)
    8000198a:	00013497          	auipc	s1,0x13
    8000198e:	9ae48493          	addi	s1,s1,-1618 # 80014338 <proc>
        uint64 va = KSTACK((int)(p - proc));
    80001992:	8b26                	mv	s6,s1
    80001994:	ff4df937          	lui	s2,0xff4df
    80001998:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b96a5>
    8000199c:	0936                	slli	s2,s2,0xd
    8000199e:	6f590913          	addi	s2,s2,1781
    800019a2:	0936                	slli	s2,s2,0xd
    800019a4:	bd390913          	addi	s2,s2,-1069
    800019a8:	0932                	slli	s2,s2,0xc
    800019aa:	7a790913          	addi	s2,s2,1959
    800019ae:	040009b7          	lui	s3,0x4000
    800019b2:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800019b4:	09b2                	slli	s3,s3,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    800019b6:	00018a97          	auipc	s5,0x18
    800019ba:	582a8a93          	addi	s5,s5,1410 # 80019f38 <tickslock>
        char *pa = kalloc();
    800019be:	fffff097          	auipc	ra,0xfffff
    800019c2:	18a080e7          	jalr	394(ra) # 80000b48 <kalloc>
    800019c6:	862a                	mv	a2,a0
        if (pa == 0)
    800019c8:	c121                	beqz	a0,80001a08 <proc_mapstacks+0x94>
        uint64 va = KSTACK((int)(p - proc));
    800019ca:	416485b3          	sub	a1,s1,s6
    800019ce:	8591                	srai	a1,a1,0x4
    800019d0:	032585b3          	mul	a1,a1,s2
    800019d4:	2585                	addiw	a1,a1,1
    800019d6:	00d5959b          	slliw	a1,a1,0xd
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800019da:	4719                	li	a4,6
    800019dc:	6685                	lui	a3,0x1
    800019de:	40b985b3          	sub	a1,s3,a1
    800019e2:	8552                	mv	a0,s4
    800019e4:	fffff097          	auipc	ra,0xfffff
    800019e8:	7b4080e7          	jalr	1972(ra) # 80001198 <kvmmap>
    for (p = proc; p < &proc[NPROC]; p++)
    800019ec:	17048493          	addi	s1,s1,368
    800019f0:	fd5497e3          	bne	s1,s5,800019be <proc_mapstacks+0x4a>
}
    800019f4:	70e2                	ld	ra,56(sp)
    800019f6:	7442                	ld	s0,48(sp)
    800019f8:	74a2                	ld	s1,40(sp)
    800019fa:	7902                	ld	s2,32(sp)
    800019fc:	69e2                	ld	s3,24(sp)
    800019fe:	6a42                	ld	s4,16(sp)
    80001a00:	6aa2                	ld	s5,8(sp)
    80001a02:	6b02                	ld	s6,0(sp)
    80001a04:	6121                	addi	sp,sp,64
    80001a06:	8082                	ret
            panic("kalloc");
    80001a08:	00006517          	auipc	a0,0x6
    80001a0c:	7b050513          	addi	a0,a0,1968 # 800081b8 <etext+0x1b8>
    80001a10:	fffff097          	auipc	ra,0xfffff
    80001a14:	b50080e7          	jalr	-1200(ra) # 80000560 <panic>

0000000080001a18 <copy_array>:
{
    80001a18:	1141                	addi	sp,sp,-16
    80001a1a:	e422                	sd	s0,8(sp)
    80001a1c:	0800                	addi	s0,sp,16
    for (int i = 0; i < len; i++)
    80001a1e:	00c05c63          	blez	a2,80001a36 <copy_array+0x1e>
    80001a22:	87aa                	mv	a5,a0
    80001a24:	9532                	add	a0,a0,a2
        dst[i] = src[i];
    80001a26:	0007c703          	lbu	a4,0(a5)
    80001a2a:	00e58023          	sb	a4,0(a1)
    for (int i = 0; i < len; i++)
    80001a2e:	0785                	addi	a5,a5,1
    80001a30:	0585                	addi	a1,a1,1
    80001a32:	fea79ae3          	bne	a5,a0,80001a26 <copy_array+0xe>
}
    80001a36:	6422                	ld	s0,8(sp)
    80001a38:	0141                	addi	sp,sp,16
    80001a3a:	8082                	ret

0000000080001a3c <cpuid>:
{
    80001a3c:	1141                	addi	sp,sp,-16
    80001a3e:	e422                	sd	s0,8(sp)
    80001a40:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001a42:	8512                	mv	a0,tp
}
    80001a44:	2501                	sext.w	a0,a0
    80001a46:	6422                	ld	s0,8(sp)
    80001a48:	0141                	addi	sp,sp,16
    80001a4a:	8082                	ret

0000000080001a4c <mycpu>:
{
    80001a4c:	1141                	addi	sp,sp,-16
    80001a4e:	e422                	sd	s0,8(sp)
    80001a50:	0800                	addi	s0,sp,16
    80001a52:	8792                	mv	a5,tp
    struct cpu *c = &cpus[id];
    80001a54:	2781                	sext.w	a5,a5
    80001a56:	079e                	slli	a5,a5,0x7
}
    80001a58:	00012517          	auipc	a0,0x12
    80001a5c:	e6850513          	addi	a0,a0,-408 # 800138c0 <cpus>
    80001a60:	953e                	add	a0,a0,a5
    80001a62:	6422                	ld	s0,8(sp)
    80001a64:	0141                	addi	sp,sp,16
    80001a66:	8082                	ret

0000000080001a68 <myproc>:
{
    80001a68:	1101                	addi	sp,sp,-32
    80001a6a:	ec06                	sd	ra,24(sp)
    80001a6c:	e822                	sd	s0,16(sp)
    80001a6e:	e426                	sd	s1,8(sp)
    80001a70:	1000                	addi	s0,sp,32
    push_off();
    80001a72:	fffff097          	auipc	ra,0xfffff
    80001a76:	17a080e7          	jalr	378(ra) # 80000bec <push_off>
    80001a7a:	8792                	mv	a5,tp
    struct proc *p = c->proc;
    80001a7c:	2781                	sext.w	a5,a5
    80001a7e:	079e                	slli	a5,a5,0x7
    80001a80:	00012717          	auipc	a4,0x12
    80001a84:	e4070713          	addi	a4,a4,-448 # 800138c0 <cpus>
    80001a88:	97ba                	add	a5,a5,a4
    80001a8a:	6384                	ld	s1,0(a5)
    pop_off();
    80001a8c:	fffff097          	auipc	ra,0xfffff
    80001a90:	200080e7          	jalr	512(ra) # 80000c8c <pop_off>
}
    80001a94:	8526                	mv	a0,s1
    80001a96:	60e2                	ld	ra,24(sp)
    80001a98:	6442                	ld	s0,16(sp)
    80001a9a:	64a2                	ld	s1,8(sp)
    80001a9c:	6105                	addi	sp,sp,32
    80001a9e:	8082                	ret

0000000080001aa0 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80001aa0:	1141                	addi	sp,sp,-16
    80001aa2:	e406                	sd	ra,8(sp)
    80001aa4:	e022                	sd	s0,0(sp)
    80001aa6:	0800                	addi	s0,sp,16
    static int first = 1;

    // Still holding p->lock from scheduler.
    release(&myproc()->lock);
    80001aa8:	00000097          	auipc	ra,0x0
    80001aac:	fc0080e7          	jalr	-64(ra) # 80001a68 <myproc>
    80001ab0:	fffff097          	auipc	ra,0xfffff
    80001ab4:	23c080e7          	jalr	572(ra) # 80000cec <release>

    if (first)
    80001ab8:	0000a797          	auipc	a5,0xa
    80001abc:	a787a783          	lw	a5,-1416(a5) # 8000b530 <first.1>
    80001ac0:	eb89                	bnez	a5,80001ad2 <forkret+0x32>
        // be run from main().
        first = 0;
        fsinit(ROOTDEV);
    }

    usertrapret();
    80001ac2:	00001097          	auipc	ra,0x1
    80001ac6:	35c080e7          	jalr	860(ra) # 80002e1e <usertrapret>
}
    80001aca:	60a2                	ld	ra,8(sp)
    80001acc:	6402                	ld	s0,0(sp)
    80001ace:	0141                	addi	sp,sp,16
    80001ad0:	8082                	ret
        first = 0;
    80001ad2:	0000a797          	auipc	a5,0xa
    80001ad6:	a407af23          	sw	zero,-1442(a5) # 8000b530 <first.1>
        fsinit(ROOTDEV);
    80001ada:	4505                	li	a0,1
    80001adc:	00002097          	auipc	ra,0x2
    80001ae0:	18c080e7          	jalr	396(ra) # 80003c68 <fsinit>
    80001ae4:	bff9                	j	80001ac2 <forkret+0x22>

0000000080001ae6 <allocpid>:
{
    80001ae6:	1101                	addi	sp,sp,-32
    80001ae8:	ec06                	sd	ra,24(sp)
    80001aea:	e822                	sd	s0,16(sp)
    80001aec:	e426                	sd	s1,8(sp)
    80001aee:	e04a                	sd	s2,0(sp)
    80001af0:	1000                	addi	s0,sp,32
    acquire(&pid_lock);
    80001af2:	00012917          	auipc	s2,0x12
    80001af6:	1ce90913          	addi	s2,s2,462 # 80013cc0 <pid_lock>
    80001afa:	854a                	mv	a0,s2
    80001afc:	fffff097          	auipc	ra,0xfffff
    80001b00:	13c080e7          	jalr	316(ra) # 80000c38 <acquire>
    pid = nextpid;
    80001b04:	0000a797          	auipc	a5,0xa
    80001b08:	a3c78793          	addi	a5,a5,-1476 # 8000b540 <nextpid>
    80001b0c:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    80001b0e:	0014871b          	addiw	a4,s1,1
    80001b12:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    80001b14:	854a                	mv	a0,s2
    80001b16:	fffff097          	auipc	ra,0xfffff
    80001b1a:	1d6080e7          	jalr	470(ra) # 80000cec <release>
}
    80001b1e:	8526                	mv	a0,s1
    80001b20:	60e2                	ld	ra,24(sp)
    80001b22:	6442                	ld	s0,16(sp)
    80001b24:	64a2                	ld	s1,8(sp)
    80001b26:	6902                	ld	s2,0(sp)
    80001b28:	6105                	addi	sp,sp,32
    80001b2a:	8082                	ret

0000000080001b2c <proc_pagetable>:
{
    80001b2c:	1101                	addi	sp,sp,-32
    80001b2e:	ec06                	sd	ra,24(sp)
    80001b30:	e822                	sd	s0,16(sp)
    80001b32:	e426                	sd	s1,8(sp)
    80001b34:	e04a                	sd	s2,0(sp)
    80001b36:	1000                	addi	s0,sp,32
    80001b38:	892a                	mv	s2,a0
    pagetable = uvmcreate();
    80001b3a:	00000097          	auipc	ra,0x0
    80001b3e:	858080e7          	jalr	-1960(ra) # 80001392 <uvmcreate>
    80001b42:	84aa                	mv	s1,a0
    if (pagetable == 0)
    80001b44:	c121                	beqz	a0,80001b84 <proc_pagetable+0x58>
    if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001b46:	4729                	li	a4,10
    80001b48:	00005697          	auipc	a3,0x5
    80001b4c:	4b868693          	addi	a3,a3,1208 # 80007000 <_trampoline>
    80001b50:	6605                	lui	a2,0x1
    80001b52:	040005b7          	lui	a1,0x4000
    80001b56:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b58:	05b2                	slli	a1,a1,0xc
    80001b5a:	fffff097          	auipc	ra,0xfffff
    80001b5e:	59e080e7          	jalr	1438(ra) # 800010f8 <mappages>
    80001b62:	02054863          	bltz	a0,80001b92 <proc_pagetable+0x66>
    if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80001b66:	4719                	li	a4,6
    80001b68:	06093683          	ld	a3,96(s2)
    80001b6c:	6605                	lui	a2,0x1
    80001b6e:	020005b7          	lui	a1,0x2000
    80001b72:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001b74:	05b6                	slli	a1,a1,0xd
    80001b76:	8526                	mv	a0,s1
    80001b78:	fffff097          	auipc	ra,0xfffff
    80001b7c:	580080e7          	jalr	1408(ra) # 800010f8 <mappages>
    80001b80:	02054163          	bltz	a0,80001ba2 <proc_pagetable+0x76>
}
    80001b84:	8526                	mv	a0,s1
    80001b86:	60e2                	ld	ra,24(sp)
    80001b88:	6442                	ld	s0,16(sp)
    80001b8a:	64a2                	ld	s1,8(sp)
    80001b8c:	6902                	ld	s2,0(sp)
    80001b8e:	6105                	addi	sp,sp,32
    80001b90:	8082                	ret
        uvmfree(pagetable, 0);
    80001b92:	4581                	li	a1,0
    80001b94:	8526                	mv	a0,s1
    80001b96:	00000097          	auipc	ra,0x0
    80001b9a:	a0e080e7          	jalr	-1522(ra) # 800015a4 <uvmfree>
        return 0;
    80001b9e:	4481                	li	s1,0
    80001ba0:	b7d5                	j	80001b84 <proc_pagetable+0x58>
        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001ba2:	4681                	li	a3,0
    80001ba4:	4605                	li	a2,1
    80001ba6:	040005b7          	lui	a1,0x4000
    80001baa:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001bac:	05b2                	slli	a1,a1,0xc
    80001bae:	8526                	mv	a0,s1
    80001bb0:	fffff097          	auipc	ra,0xfffff
    80001bb4:	70e080e7          	jalr	1806(ra) # 800012be <uvmunmap>
        uvmfree(pagetable, 0);
    80001bb8:	4581                	li	a1,0
    80001bba:	8526                	mv	a0,s1
    80001bbc:	00000097          	auipc	ra,0x0
    80001bc0:	9e8080e7          	jalr	-1560(ra) # 800015a4 <uvmfree>
        return 0;
    80001bc4:	4481                	li	s1,0
    80001bc6:	bf7d                	j	80001b84 <proc_pagetable+0x58>

0000000080001bc8 <proc_freepagetable>:
{
    80001bc8:	1101                	addi	sp,sp,-32
    80001bca:	ec06                	sd	ra,24(sp)
    80001bcc:	e822                	sd	s0,16(sp)
    80001bce:	e426                	sd	s1,8(sp)
    80001bd0:	e04a                	sd	s2,0(sp)
    80001bd2:	1000                	addi	s0,sp,32
    80001bd4:	84aa                	mv	s1,a0
    80001bd6:	892e                	mv	s2,a1
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001bd8:	4681                	li	a3,0
    80001bda:	4605                	li	a2,1
    80001bdc:	040005b7          	lui	a1,0x4000
    80001be0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001be2:	05b2                	slli	a1,a1,0xc
    80001be4:	fffff097          	auipc	ra,0xfffff
    80001be8:	6da080e7          	jalr	1754(ra) # 800012be <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001bec:	4681                	li	a3,0
    80001bee:	4605                	li	a2,1
    80001bf0:	020005b7          	lui	a1,0x2000
    80001bf4:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001bf6:	05b6                	slli	a1,a1,0xd
    80001bf8:	8526                	mv	a0,s1
    80001bfa:	fffff097          	auipc	ra,0xfffff
    80001bfe:	6c4080e7          	jalr	1732(ra) # 800012be <uvmunmap>
    uvmfree(pagetable, sz);
    80001c02:	85ca                	mv	a1,s2
    80001c04:	8526                	mv	a0,s1
    80001c06:	00000097          	auipc	ra,0x0
    80001c0a:	99e080e7          	jalr	-1634(ra) # 800015a4 <uvmfree>
}
    80001c0e:	60e2                	ld	ra,24(sp)
    80001c10:	6442                	ld	s0,16(sp)
    80001c12:	64a2                	ld	s1,8(sp)
    80001c14:	6902                	ld	s2,0(sp)
    80001c16:	6105                	addi	sp,sp,32
    80001c18:	8082                	ret

0000000080001c1a <freeproc>:
{
    80001c1a:	1101                	addi	sp,sp,-32
    80001c1c:	ec06                	sd	ra,24(sp)
    80001c1e:	e822                	sd	s0,16(sp)
    80001c20:	e426                	sd	s1,8(sp)
    80001c22:	1000                	addi	s0,sp,32
    80001c24:	84aa                	mv	s1,a0
    if (p->trapframe)
    80001c26:	7128                	ld	a0,96(a0)
    80001c28:	c509                	beqz	a0,80001c32 <freeproc+0x18>
        kfree((void *)p->trapframe);
    80001c2a:	fffff097          	auipc	ra,0xfffff
    80001c2e:	e20080e7          	jalr	-480(ra) # 80000a4a <kfree>
    p->trapframe = 0;
    80001c32:	0604b023          	sd	zero,96(s1)
    if (p->pagetable)
    80001c36:	6ca8                	ld	a0,88(s1)
    80001c38:	c511                	beqz	a0,80001c44 <freeproc+0x2a>
        proc_freepagetable(p->pagetable, p->sz);
    80001c3a:	68ac                	ld	a1,80(s1)
    80001c3c:	00000097          	auipc	ra,0x0
    80001c40:	f8c080e7          	jalr	-116(ra) # 80001bc8 <proc_freepagetable>
    p->pagetable = 0;
    80001c44:	0404bc23          	sd	zero,88(s1)
    p->sz = 0;
    80001c48:	0404b823          	sd	zero,80(s1)
    p->pid = 0;
    80001c4c:	0204a823          	sw	zero,48(s1)
    p->parent = 0;
    80001c50:	0404b023          	sd	zero,64(s1)
    p->name[0] = 0;
    80001c54:	16048023          	sb	zero,352(s1)
    p->chan = 0;
    80001c58:	0204b023          	sd	zero,32(s1)
    p->killed = 0;
    80001c5c:	0204a423          	sw	zero,40(s1)
    p->xstate = 0;
    80001c60:	0204a623          	sw	zero,44(s1)
    p->state = UNUSED;
    80001c64:	0004ac23          	sw	zero,24(s1)
}
    80001c68:	60e2                	ld	ra,24(sp)
    80001c6a:	6442                	ld	s0,16(sp)
    80001c6c:	64a2                	ld	s1,8(sp)
    80001c6e:	6105                	addi	sp,sp,32
    80001c70:	8082                	ret

0000000080001c72 <allocproc>:
{
    80001c72:	1101                	addi	sp,sp,-32
    80001c74:	ec06                	sd	ra,24(sp)
    80001c76:	e822                	sd	s0,16(sp)
    80001c78:	e426                	sd	s1,8(sp)
    80001c7a:	e04a                	sd	s2,0(sp)
    80001c7c:	1000                	addi	s0,sp,32
    for (p = proc; p < &proc[NPROC]; p++){
    80001c7e:	00012497          	auipc	s1,0x12
    80001c82:	6ba48493          	addi	s1,s1,1722 # 80014338 <proc>
    80001c86:	00018917          	auipc	s2,0x18
    80001c8a:	2b290913          	addi	s2,s2,690 # 80019f38 <tickslock>
        acquire(&p->lock);
    80001c8e:	8526                	mv	a0,s1
    80001c90:	fffff097          	auipc	ra,0xfffff
    80001c94:	fa8080e7          	jalr	-88(ra) # 80000c38 <acquire>
        if(p->state == UNUSED){
    80001c98:	4c9c                	lw	a5,24(s1)
    80001c9a:	cf81                	beqz	a5,80001cb2 <allocproc+0x40>
            release(&p->lock);
    80001c9c:	8526                	mv	a0,s1
    80001c9e:	fffff097          	auipc	ra,0xfffff
    80001ca2:	04e080e7          	jalr	78(ra) # 80000cec <release>
    for (p = proc; p < &proc[NPROC]; p++){
    80001ca6:	17048493          	addi	s1,s1,368
    80001caa:	ff2492e3          	bne	s1,s2,80001c8e <allocproc+0x1c>
    return 0;
    80001cae:	4481                	li	s1,0
    80001cb0:	a8a9                	j	80001d0a <allocproc+0x98>
    p->pid = allocpid();
    80001cb2:	00000097          	auipc	ra,0x0
    80001cb6:	e34080e7          	jalr	-460(ra) # 80001ae6 <allocpid>
    80001cba:	d888                	sw	a0,48(s1)
    p->state = USED;
    80001cbc:	4785                	li	a5,1
    80001cbe:	cc9c                	sw	a5,24(s1)
    p->priority = 0;
    80001cc0:	0204aa23          	sw	zero,52(s1)
    p->used_time = 0;
    80001cc4:	0204ac23          	sw	zero,56(s1)
    if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001cc8:	fffff097          	auipc	ra,0xfffff
    80001ccc:	e80080e7          	jalr	-384(ra) # 80000b48 <kalloc>
    80001cd0:	892a                	mv	s2,a0
    80001cd2:	f0a8                	sd	a0,96(s1)
    80001cd4:	c131                	beqz	a0,80001d18 <allocproc+0xa6>
    p->pagetable = proc_pagetable(p);
    80001cd6:	8526                	mv	a0,s1
    80001cd8:	00000097          	auipc	ra,0x0
    80001cdc:	e54080e7          	jalr	-428(ra) # 80001b2c <proc_pagetable>
    80001ce0:	892a                	mv	s2,a0
    80001ce2:	eca8                	sd	a0,88(s1)
    if(p->pagetable == 0){
    80001ce4:	c531                	beqz	a0,80001d30 <allocproc+0xbe>
    memset(&p->context, 0, sizeof(p->context));
    80001ce6:	07000613          	li	a2,112
    80001cea:	4581                	li	a1,0
    80001cec:	06848513          	addi	a0,s1,104
    80001cf0:	fffff097          	auipc	ra,0xfffff
    80001cf4:	044080e7          	jalr	68(ra) # 80000d34 <memset>
    p->context.ra = (uint64)forkret;
    80001cf8:	00000797          	auipc	a5,0x0
    80001cfc:	da878793          	addi	a5,a5,-600 # 80001aa0 <forkret>
    80001d00:	f4bc                	sd	a5,104(s1)
    p->context.sp = p->kstack + PGSIZE;
    80001d02:	64bc                	ld	a5,72(s1)
    80001d04:	6705                	lui	a4,0x1
    80001d06:	97ba                	add	a5,a5,a4
    80001d08:	f8bc                	sd	a5,112(s1)
}
    80001d0a:	8526                	mv	a0,s1
    80001d0c:	60e2                	ld	ra,24(sp)
    80001d0e:	6442                	ld	s0,16(sp)
    80001d10:	64a2                	ld	s1,8(sp)
    80001d12:	6902                	ld	s2,0(sp)
    80001d14:	6105                	addi	sp,sp,32
    80001d16:	8082                	ret
        freeproc(p);
    80001d18:	8526                	mv	a0,s1
    80001d1a:	00000097          	auipc	ra,0x0
    80001d1e:	f00080e7          	jalr	-256(ra) # 80001c1a <freeproc>
        release(&p->lock);
    80001d22:	8526                	mv	a0,s1
    80001d24:	fffff097          	auipc	ra,0xfffff
    80001d28:	fc8080e7          	jalr	-56(ra) # 80000cec <release>
        return 0;
    80001d2c:	84ca                	mv	s1,s2
    80001d2e:	bff1                	j	80001d0a <allocproc+0x98>
        freeproc(p);
    80001d30:	8526                	mv	a0,s1
    80001d32:	00000097          	auipc	ra,0x0
    80001d36:	ee8080e7          	jalr	-280(ra) # 80001c1a <freeproc>
        release(&p->lock);
    80001d3a:	8526                	mv	a0,s1
    80001d3c:	fffff097          	auipc	ra,0xfffff
    80001d40:	fb0080e7          	jalr	-80(ra) # 80000cec <release>
        return 0;
    80001d44:	84ca                	mv	s1,s2
    80001d46:	b7d1                	j	80001d0a <allocproc+0x98>

0000000080001d48 <growproc>:
{
    80001d48:	1101                	addi	sp,sp,-32
    80001d4a:	ec06                	sd	ra,24(sp)
    80001d4c:	e822                	sd	s0,16(sp)
    80001d4e:	e426                	sd	s1,8(sp)
    80001d50:	e04a                	sd	s2,0(sp)
    80001d52:	1000                	addi	s0,sp,32
    80001d54:	892a                	mv	s2,a0
    struct proc *p = myproc();
    80001d56:	00000097          	auipc	ra,0x0
    80001d5a:	d12080e7          	jalr	-750(ra) # 80001a68 <myproc>
    80001d5e:	84aa                	mv	s1,a0
    sz = p->sz;
    80001d60:	692c                	ld	a1,80(a0)
    if (n > 0)
    80001d62:	01204c63          	bgtz	s2,80001d7a <growproc+0x32>
    else if (n < 0)
    80001d66:	02094663          	bltz	s2,80001d92 <growproc+0x4a>
    p->sz = sz;
    80001d6a:	e8ac                	sd	a1,80(s1)
    return 0;
    80001d6c:	4501                	li	a0,0
}
    80001d6e:	60e2                	ld	ra,24(sp)
    80001d70:	6442                	ld	s0,16(sp)
    80001d72:	64a2                	ld	s1,8(sp)
    80001d74:	6902                	ld	s2,0(sp)
    80001d76:	6105                	addi	sp,sp,32
    80001d78:	8082                	ret
        if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    80001d7a:	4691                	li	a3,4
    80001d7c:	00b90633          	add	a2,s2,a1
    80001d80:	6d28                	ld	a0,88(a0)
    80001d82:	fffff097          	auipc	ra,0xfffff
    80001d86:	6f8080e7          	jalr	1784(ra) # 8000147a <uvmalloc>
    80001d8a:	85aa                	mv	a1,a0
    80001d8c:	fd79                	bnez	a0,80001d6a <growproc+0x22>
            return -1;
    80001d8e:	557d                	li	a0,-1
    80001d90:	bff9                	j	80001d6e <growproc+0x26>
        sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001d92:	00b90633          	add	a2,s2,a1
    80001d96:	6d28                	ld	a0,88(a0)
    80001d98:	fffff097          	auipc	ra,0xfffff
    80001d9c:	69a080e7          	jalr	1690(ra) # 80001432 <uvmdealloc>
    80001da0:	85aa                	mv	a1,a0
    80001da2:	b7e1                	j	80001d6a <growproc+0x22>

0000000080001da4 <ps>:
{
    80001da4:	715d                	addi	sp,sp,-80
    80001da6:	e486                	sd	ra,72(sp)
    80001da8:	e0a2                	sd	s0,64(sp)
    80001daa:	fc26                	sd	s1,56(sp)
    80001dac:	f84a                	sd	s2,48(sp)
    80001dae:	f44e                	sd	s3,40(sp)
    80001db0:	f052                	sd	s4,32(sp)
    80001db2:	ec56                	sd	s5,24(sp)
    80001db4:	e85a                	sd	s6,16(sp)
    80001db6:	e45e                	sd	s7,8(sp)
    80001db8:	e062                	sd	s8,0(sp)
    80001dba:	0880                	addi	s0,sp,80
    80001dbc:	84aa                	mv	s1,a0
    80001dbe:	8bae                	mv	s7,a1
    void *result = (void *)myproc()->sz;
    80001dc0:	00000097          	auipc	ra,0x0
    80001dc4:	ca8080e7          	jalr	-856(ra) # 80001a68 <myproc>
        return result;
    80001dc8:	4901                	li	s2,0
    if (count == 0)
    80001dca:	0c0b8663          	beqz	s7,80001e96 <ps+0xf2>
    void *result = (void *)myproc()->sz;
    80001dce:	05053b03          	ld	s6,80(a0)
    if (growproc(count * sizeof(struct user_proc)) < 0)
    80001dd2:	003b951b          	slliw	a0,s7,0x3
    80001dd6:	0175053b          	addw	a0,a0,s7
    80001dda:	0025151b          	slliw	a0,a0,0x2
    80001dde:	2501                	sext.w	a0,a0
    80001de0:	00000097          	auipc	ra,0x0
    80001de4:	f68080e7          	jalr	-152(ra) # 80001d48 <growproc>
    80001de8:	12054f63          	bltz	a0,80001f26 <ps+0x182>
    struct user_proc loc_result[count];
    80001dec:	003b9a13          	slli	s4,s7,0x3
    80001df0:	9a5e                	add	s4,s4,s7
    80001df2:	0a0a                	slli	s4,s4,0x2
    80001df4:	00fa0793          	addi	a5,s4,15
    80001df8:	8391                	srli	a5,a5,0x4
    80001dfa:	0792                	slli	a5,a5,0x4
    80001dfc:	40f10133          	sub	sp,sp,a5
    80001e00:	8a8a                	mv	s5,sp
    struct proc *p = proc + start;
    80001e02:	17000793          	li	a5,368
    80001e06:	02f484b3          	mul	s1,s1,a5
    80001e0a:	00012797          	auipc	a5,0x12
    80001e0e:	52e78793          	addi	a5,a5,1326 # 80014338 <proc>
    80001e12:	94be                	add	s1,s1,a5
    if (p >= &proc[NPROC])
    80001e14:	00018797          	auipc	a5,0x18
    80001e18:	12478793          	addi	a5,a5,292 # 80019f38 <tickslock>
        return result;
    80001e1c:	4901                	li	s2,0
    if (p >= &proc[NPROC])
    80001e1e:	06f4fc63          	bgeu	s1,a5,80001e96 <ps+0xf2>
    acquire(&wait_lock);
    80001e22:	00012517          	auipc	a0,0x12
    80001e26:	eb650513          	addi	a0,a0,-330 # 80013cd8 <wait_lock>
    80001e2a:	fffff097          	auipc	ra,0xfffff
    80001e2e:	e0e080e7          	jalr	-498(ra) # 80000c38 <acquire>
        if (localCount == count)
    80001e32:	014a8913          	addi	s2,s5,20
    uint8 localCount = 0;
    80001e36:	4981                	li	s3,0
    for (; p < &proc[NPROC]; p++)
    80001e38:	00018c17          	auipc	s8,0x18
    80001e3c:	100c0c13          	addi	s8,s8,256 # 80019f38 <tickslock>
    80001e40:	a851                	j	80001ed4 <ps+0x130>
            loc_result[localCount].state = UNUSED;
    80001e42:	00399793          	slli	a5,s3,0x3
    80001e46:	97ce                	add	a5,a5,s3
    80001e48:	078a                	slli	a5,a5,0x2
    80001e4a:	97d6                	add	a5,a5,s5
    80001e4c:	0007a023          	sw	zero,0(a5)
            release(&p->lock);
    80001e50:	8526                	mv	a0,s1
    80001e52:	fffff097          	auipc	ra,0xfffff
    80001e56:	e9a080e7          	jalr	-358(ra) # 80000cec <release>
    release(&wait_lock);
    80001e5a:	00012517          	auipc	a0,0x12
    80001e5e:	e7e50513          	addi	a0,a0,-386 # 80013cd8 <wait_lock>
    80001e62:	fffff097          	auipc	ra,0xfffff
    80001e66:	e8a080e7          	jalr	-374(ra) # 80000cec <release>
    if (localCount < count)
    80001e6a:	0179f963          	bgeu	s3,s7,80001e7c <ps+0xd8>
        loc_result[localCount].state = UNUSED; // if we reach the end of processes
    80001e6e:	00399793          	slli	a5,s3,0x3
    80001e72:	97ce                	add	a5,a5,s3
    80001e74:	078a                	slli	a5,a5,0x2
    80001e76:	97d6                	add	a5,a5,s5
    80001e78:	0007a023          	sw	zero,0(a5)
    void *result = (void *)myproc()->sz;
    80001e7c:	895a                	mv	s2,s6
    copyout(myproc()->pagetable, (uint64)result, (void *)loc_result, count * sizeof(struct user_proc));
    80001e7e:	00000097          	auipc	ra,0x0
    80001e82:	bea080e7          	jalr	-1046(ra) # 80001a68 <myproc>
    80001e86:	86d2                	mv	a3,s4
    80001e88:	8656                	mv	a2,s5
    80001e8a:	85da                	mv	a1,s6
    80001e8c:	6d28                	ld	a0,88(a0)
    80001e8e:	00000097          	auipc	ra,0x0
    80001e92:	854080e7          	jalr	-1964(ra) # 800016e2 <copyout>
}
    80001e96:	854a                	mv	a0,s2
    80001e98:	fb040113          	addi	sp,s0,-80
    80001e9c:	60a6                	ld	ra,72(sp)
    80001e9e:	6406                	ld	s0,64(sp)
    80001ea0:	74e2                	ld	s1,56(sp)
    80001ea2:	7942                	ld	s2,48(sp)
    80001ea4:	79a2                	ld	s3,40(sp)
    80001ea6:	7a02                	ld	s4,32(sp)
    80001ea8:	6ae2                	ld	s5,24(sp)
    80001eaa:	6b42                	ld	s6,16(sp)
    80001eac:	6ba2                	ld	s7,8(sp)
    80001eae:	6c02                	ld	s8,0(sp)
    80001eb0:	6161                	addi	sp,sp,80
    80001eb2:	8082                	ret
        release(&p->lock);
    80001eb4:	8526                	mv	a0,s1
    80001eb6:	fffff097          	auipc	ra,0xfffff
    80001eba:	e36080e7          	jalr	-458(ra) # 80000cec <release>
        localCount++;
    80001ebe:	2985                	addiw	s3,s3,1
    80001ec0:	0ff9f993          	zext.b	s3,s3
    for (; p < &proc[NPROC]; p++)
    80001ec4:	17048493          	addi	s1,s1,368
    80001ec8:	f984f9e3          	bgeu	s1,s8,80001e5a <ps+0xb6>
        if (localCount == count)
    80001ecc:	02490913          	addi	s2,s2,36
    80001ed0:	053b8d63          	beq	s7,s3,80001f2a <ps+0x186>
        acquire(&p->lock);
    80001ed4:	8526                	mv	a0,s1
    80001ed6:	fffff097          	auipc	ra,0xfffff
    80001eda:	d62080e7          	jalr	-670(ra) # 80000c38 <acquire>
        if (p->state == UNUSED)
    80001ede:	4c9c                	lw	a5,24(s1)
    80001ee0:	d3ad                	beqz	a5,80001e42 <ps+0x9e>
        loc_result[localCount].state = p->state;
    80001ee2:	fef92623          	sw	a5,-20(s2)
        loc_result[localCount].killed = p->killed;
    80001ee6:	549c                	lw	a5,40(s1)
    80001ee8:	fef92823          	sw	a5,-16(s2)
        loc_result[localCount].xstate = p->xstate;
    80001eec:	54dc                	lw	a5,44(s1)
    80001eee:	fef92a23          	sw	a5,-12(s2)
        loc_result[localCount].pid = p->pid;
    80001ef2:	589c                	lw	a5,48(s1)
    80001ef4:	fef92c23          	sw	a5,-8(s2)
        copy_array(p->name, loc_result[localCount].name, 16);
    80001ef8:	4641                	li	a2,16
    80001efa:	85ca                	mv	a1,s2
    80001efc:	16048513          	addi	a0,s1,352
    80001f00:	00000097          	auipc	ra,0x0
    80001f04:	b18080e7          	jalr	-1256(ra) # 80001a18 <copy_array>
        if (p->parent != 0) // init
    80001f08:	60a8                	ld	a0,64(s1)
    80001f0a:	d54d                	beqz	a0,80001eb4 <ps+0x110>
            acquire(&p->parent->lock);
    80001f0c:	fffff097          	auipc	ra,0xfffff
    80001f10:	d2c080e7          	jalr	-724(ra) # 80000c38 <acquire>
            loc_result[localCount].parent_id = p->parent->pid;
    80001f14:	60a8                	ld	a0,64(s1)
    80001f16:	591c                	lw	a5,48(a0)
    80001f18:	fef92e23          	sw	a5,-4(s2)
            release(&p->parent->lock);
    80001f1c:	fffff097          	auipc	ra,0xfffff
    80001f20:	dd0080e7          	jalr	-560(ra) # 80000cec <release>
    80001f24:	bf41                	j	80001eb4 <ps+0x110>
        return result;
    80001f26:	4901                	li	s2,0
    80001f28:	b7bd                	j	80001e96 <ps+0xf2>
    release(&wait_lock);
    80001f2a:	00012517          	auipc	a0,0x12
    80001f2e:	dae50513          	addi	a0,a0,-594 # 80013cd8 <wait_lock>
    80001f32:	fffff097          	auipc	ra,0xfffff
    80001f36:	dba080e7          	jalr	-582(ra) # 80000cec <release>
    if (localCount < count)
    80001f3a:	b789                	j	80001e7c <ps+0xd8>

0000000080001f3c <scheduler>:
{
    80001f3c:	1101                	addi	sp,sp,-32
    80001f3e:	ec06                	sd	ra,24(sp)
    80001f40:	e822                	sd	s0,16(sp)
    80001f42:	e426                	sd	s1,8(sp)
    80001f44:	e04a                	sd	s2,0(sp)
    80001f46:	1000                	addi	s0,sp,32
    void (*old_scheduler)(void) = sched_pointer;
    80001f48:	00009797          	auipc	a5,0x9
    80001f4c:	5f07b783          	ld	a5,1520(a5) # 8000b538 <sched_pointer>
        if (old_scheduler != sched_pointer)
    80001f50:	00009497          	auipc	s1,0x9
    80001f54:	5e848493          	addi	s1,s1,1512 # 8000b538 <sched_pointer>
            printf("Scheduler switched\n");
    80001f58:	00006917          	auipc	s2,0x6
    80001f5c:	26890913          	addi	s2,s2,616 # 800081c0 <etext+0x1c0>
    80001f60:	a809                	j	80001f72 <scheduler+0x36>
    80001f62:	854a                	mv	a0,s2
    80001f64:	ffffe097          	auipc	ra,0xffffe
    80001f68:	646080e7          	jalr	1606(ra) # 800005aa <printf>
        (*sched_pointer)();
    80001f6c:	609c                	ld	a5,0(s1)
    80001f6e:	9782                	jalr	a5
        old_scheduler = sched_pointer;
    80001f70:	609c                	ld	a5,0(s1)
        if (old_scheduler != sched_pointer)
    80001f72:	6098                	ld	a4,0(s1)
    80001f74:	fef717e3          	bne	a4,a5,80001f62 <scheduler+0x26>
    80001f78:	bfd5                	j	80001f6c <scheduler+0x30>

0000000080001f7a <initQueue>:
void initQueue(){
    80001f7a:	1141                	addi	sp,sp,-16
    80001f7c:	e422                	sd	s0,8(sp)
    80001f7e:	0800                	addi	s0,sp,16
    for(int i = 0; i < NQUEUES; i++) {
    80001f80:	00012797          	auipc	a5,0x12
    80001f84:	d7078793          	addi	a5,a5,-656 # 80013cf0 <pQueues>
    80001f88:	00009717          	auipc	a4,0x9
    80001f8c:	5c870713          	addi	a4,a4,1480 # 8000b550 <quanta>
    80001f90:	00012597          	auipc	a1,0x12
    80001f94:	39058593          	addi	a1,a1,912 # 80014320 <runq_lock>
        pQueues[i].rear = -1;
    80001f98:	567d                	li	a2,-1
        pQueues[i].front = 0;
    80001f9a:	2007a023          	sw	zero,512(a5)
        pQueues[i].rear = -1;
    80001f9e:	20c7a223          	sw	a2,516(a5)
        pQueues[i].pCount = 0;
    80001fa2:	2007a423          	sw	zero,520(a5)
        pQueues[i].time_quantum = quanta[i];
    80001fa6:	4314                	lw	a3,0(a4)
    80001fa8:	20d7a623          	sw	a3,524(a5)
    for(int i = 0; i < NQUEUES; i++) {
    80001fac:	21078793          	addi	a5,a5,528
    80001fb0:	0711                	addi	a4,a4,4
    80001fb2:	feb794e3          	bne	a5,a1,80001f9a <initQueue+0x20>
}
    80001fb6:	6422                	ld	s0,8(sp)
    80001fb8:	0141                	addi	sp,sp,16
    80001fba:	8082                	ret

0000000080001fbc <procinit>:
{
    80001fbc:	7139                	addi	sp,sp,-64
    80001fbe:	fc06                	sd	ra,56(sp)
    80001fc0:	f822                	sd	s0,48(sp)
    80001fc2:	f426                	sd	s1,40(sp)
    80001fc4:	f04a                	sd	s2,32(sp)
    80001fc6:	ec4e                	sd	s3,24(sp)
    80001fc8:	e852                	sd	s4,16(sp)
    80001fca:	e456                	sd	s5,8(sp)
    80001fcc:	e05a                	sd	s6,0(sp)
    80001fce:	0080                	addi	s0,sp,64
    initlock(&pid_lock, "nextpid");
    80001fd0:	00006597          	auipc	a1,0x6
    80001fd4:	20858593          	addi	a1,a1,520 # 800081d8 <etext+0x1d8>
    80001fd8:	00012517          	auipc	a0,0x12
    80001fdc:	ce850513          	addi	a0,a0,-792 # 80013cc0 <pid_lock>
    80001fe0:	fffff097          	auipc	ra,0xfffff
    80001fe4:	bc8080e7          	jalr	-1080(ra) # 80000ba8 <initlock>
    initlock(&wait_lock, "wait_lock");
    80001fe8:	00006597          	auipc	a1,0x6
    80001fec:	1f858593          	addi	a1,a1,504 # 800081e0 <etext+0x1e0>
    80001ff0:	00012517          	auipc	a0,0x12
    80001ff4:	ce850513          	addi	a0,a0,-792 # 80013cd8 <wait_lock>
    80001ff8:	fffff097          	auipc	ra,0xfffff
    80001ffc:	bb0080e7          	jalr	-1104(ra) # 80000ba8 <initlock>
    initQueue();
    80002000:	00000097          	auipc	ra,0x0
    80002004:	f7a080e7          	jalr	-134(ra) # 80001f7a <initQueue>
    for (p = proc; p < &proc[NPROC]; p++)
    80002008:	00012497          	auipc	s1,0x12
    8000200c:	33048493          	addi	s1,s1,816 # 80014338 <proc>
        initlock(&p->lock, "proc");
    80002010:	00006b17          	auipc	s6,0x6
    80002014:	1e0b0b13          	addi	s6,s6,480 # 800081f0 <etext+0x1f0>
        p->kstack = KSTACK((int)(p - proc));
    80002018:	8aa6                	mv	s5,s1
    8000201a:	ff4df937          	lui	s2,0xff4df
    8000201e:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b96a5>
    80002022:	0936                	slli	s2,s2,0xd
    80002024:	6f590913          	addi	s2,s2,1781
    80002028:	0936                	slli	s2,s2,0xd
    8000202a:	bd390913          	addi	s2,s2,-1069
    8000202e:	0932                	slli	s2,s2,0xc
    80002030:	7a790913          	addi	s2,s2,1959
    80002034:	040009b7          	lui	s3,0x4000
    80002038:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    8000203a:	09b2                	slli	s3,s3,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    8000203c:	00018a17          	auipc	s4,0x18
    80002040:	efca0a13          	addi	s4,s4,-260 # 80019f38 <tickslock>
        initlock(&p->lock, "proc");
    80002044:	85da                	mv	a1,s6
    80002046:	8526                	mv	a0,s1
    80002048:	fffff097          	auipc	ra,0xfffff
    8000204c:	b60080e7          	jalr	-1184(ra) # 80000ba8 <initlock>
        p->state = UNUSED;
    80002050:	0004ac23          	sw	zero,24(s1)
        p->priority = 0;
    80002054:	0204aa23          	sw	zero,52(s1)
        p->used_time = 0;
    80002058:	0204ac23          	sw	zero,56(s1)
        p->kstack = KSTACK((int)(p - proc));
    8000205c:	415487b3          	sub	a5,s1,s5
    80002060:	8791                	srai	a5,a5,0x4
    80002062:	032787b3          	mul	a5,a5,s2
    80002066:	2785                	addiw	a5,a5,1
    80002068:	00d7979b          	slliw	a5,a5,0xd
    8000206c:	40f987b3          	sub	a5,s3,a5
    80002070:	e4bc                	sd	a5,72(s1)
    for (p = proc; p < &proc[NPROC]; p++)
    80002072:	17048493          	addi	s1,s1,368
    80002076:	fd4497e3          	bne	s1,s4,80002044 <procinit+0x88>
}
    8000207a:	70e2                	ld	ra,56(sp)
    8000207c:	7442                	ld	s0,48(sp)
    8000207e:	74a2                	ld	s1,40(sp)
    80002080:	7902                	ld	s2,32(sp)
    80002082:	69e2                	ld	s3,24(sp)
    80002084:	6a42                	ld	s4,16(sp)
    80002086:	6aa2                	ld	s5,8(sp)
    80002088:	6b02                	ld	s6,0(sp)
    8000208a:	6121                	addi	sp,sp,64
    8000208c:	8082                	ret

000000008000208e <isQueueEmpty>:
int isQueueEmpty(Queue* queues) {
    8000208e:	1141                	addi	sp,sp,-16
    80002090:	e422                	sd	s0,8(sp)
    80002092:	0800                	addi	s0,sp,16
    return queues->rear == -1;
    80002094:	20452503          	lw	a0,516(a0)
    80002098:	0505                	addi	a0,a0,1
}
    8000209a:	00153513          	seqz	a0,a0
    8000209e:	6422                	ld	s0,8(sp)
    800020a0:	0141                	addi	sp,sp,16
    800020a2:	8082                	ret

00000000800020a4 <isQueueFull>:
int isQueueFull(Queue* queues) {
    800020a4:	1141                	addi	sp,sp,-16
    800020a6:	e422                	sd	s0,8(sp)
    800020a8:	0800                	addi	s0,sp,16
    return queues->rear == NPROC-1;
    800020aa:	20452503          	lw	a0,516(a0)
    800020ae:	fc150513          	addi	a0,a0,-63
}
    800020b2:	00153513          	seqz	a0,a0
    800020b6:	6422                	ld	s0,8(sp)
    800020b8:	0141                	addi	sp,sp,16
    800020ba:	8082                	ret

00000000800020bc <enqueue>:
void enqueue(Queue* queues, struct proc* process) {
    800020bc:	1101                	addi	sp,sp,-32
    800020be:	ec06                	sd	ra,24(sp)
    800020c0:	e822                	sd	s0,16(sp)
    800020c2:	e426                	sd	s1,8(sp)
    800020c4:	e04a                	sd	s2,0(sp)
    800020c6:	1000                	addi	s0,sp,32
    800020c8:	892a                	mv	s2,a0
    800020ca:	84ae                	mv	s1,a1
    acquire(&runq_lock);
    800020cc:	00012517          	auipc	a0,0x12
    800020d0:	25450513          	addi	a0,a0,596 # 80014320 <runq_lock>
    800020d4:	fffff097          	auipc	ra,0xfffff
    800020d8:	b64080e7          	jalr	-1180(ra) # 80000c38 <acquire>
    return queues->rear == NPROC-1;
    800020dc:	20492603          	lw	a2,516(s2)
    if (isQueueFull(queues)) {
    800020e0:	03f00793          	li	a5,63
    800020e4:	04f60863          	beq	a2,a5,80002134 <enqueue+0x78>
    for (int i = 0; i <= queues->rear; i++) {
    800020e8:	87ca                	mv	a5,s2
    800020ea:	4701                	li	a4,0
    800020ec:	06064663          	bltz	a2,80002158 <enqueue+0x9c>
        if (queues->queue[i] == process) {
    800020f0:	6394                	ld	a3,0(a5)
    800020f2:	04968a63          	beq	a3,s1,80002146 <enqueue+0x8a>
    for (int i = 0; i <= queues->rear; i++) {
    800020f6:	2705                	addiw	a4,a4,1
    800020f8:	07a1                	addi	a5,a5,8
    800020fa:	fee65be3          	bge	a2,a4,800020f0 <enqueue+0x34>
    queues->rear++;
    800020fe:	2605                	addiw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    80002100:	0006079b          	sext.w	a5,a2
    80002104:	20c92223          	sw	a2,516(s2)
    queues->queue[queues->rear] = process;
    80002108:	078e                	slli	a5,a5,0x3
    8000210a:	97ca                	add	a5,a5,s2
    8000210c:	e384                	sd	s1,0(a5)
    queues->pCount++;
    8000210e:	20892783          	lw	a5,520(s2)
    80002112:	2785                	addiw	a5,a5,1
    80002114:	20f92423          	sw	a5,520(s2)
    release(&runq_lock);
    80002118:	00012517          	auipc	a0,0x12
    8000211c:	20850513          	addi	a0,a0,520 # 80014320 <runq_lock>
    80002120:	fffff097          	auipc	ra,0xfffff
    80002124:	bcc080e7          	jalr	-1076(ra) # 80000cec <release>
}
    80002128:	60e2                	ld	ra,24(sp)
    8000212a:	6442                	ld	s0,16(sp)
    8000212c:	64a2                	ld	s1,8(sp)
    8000212e:	6902                	ld	s2,0(sp)
    80002130:	6105                	addi	sp,sp,32
    80002132:	8082                	ret
        release(&runq_lock);
    80002134:	00012517          	auipc	a0,0x12
    80002138:	1ec50513          	addi	a0,a0,492 # 80014320 <runq_lock>
    8000213c:	fffff097          	auipc	ra,0xfffff
    80002140:	bb0080e7          	jalr	-1104(ra) # 80000cec <release>
        return;
    80002144:	b7d5                	j	80002128 <enqueue+0x6c>
            release(&runq_lock);
    80002146:	00012517          	auipc	a0,0x12
    8000214a:	1da50513          	addi	a0,a0,474 # 80014320 <runq_lock>
    8000214e:	fffff097          	auipc	ra,0xfffff
    80002152:	b9e080e7          	jalr	-1122(ra) # 80000cec <release>
            return;
    80002156:	bfc9                	j	80002128 <enqueue+0x6c>
    if (isQueueEmpty(queues)) {
    80002158:	57fd                	li	a5,-1
    8000215a:	faf612e3          	bne	a2,a5,800020fe <enqueue+0x42>
        queues->front = 0;
    8000215e:	20092023          	sw	zero,512(s2)
    80002162:	bf71                	j	800020fe <enqueue+0x42>

0000000080002164 <userinit>:
{
    80002164:	1101                	addi	sp,sp,-32
    80002166:	ec06                	sd	ra,24(sp)
    80002168:	e822                	sd	s0,16(sp)
    8000216a:	e426                	sd	s1,8(sp)
    8000216c:	1000                	addi	s0,sp,32
    struct proc *p = allocproc();
    8000216e:	00000097          	auipc	ra,0x0
    80002172:	b04080e7          	jalr	-1276(ra) # 80001c72 <allocproc>
    80002176:	84aa                	mv	s1,a0
    initproc = p;
    80002178:	00009797          	auipc	a5,0x9
    8000217c:	4ca7b823          	sd	a0,1232(a5) # 8000b648 <initproc>
    uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80002180:	03400613          	li	a2,52
    80002184:	00009597          	auipc	a1,0x9
    80002188:	3dc58593          	addi	a1,a1,988 # 8000b560 <initcode>
    8000218c:	6d28                	ld	a0,88(a0)
    8000218e:	fffff097          	auipc	ra,0xfffff
    80002192:	232080e7          	jalr	562(ra) # 800013c0 <uvmfirst>
    p->sz = PGSIZE;
    80002196:	6785                	lui	a5,0x1
    80002198:	e8bc                	sd	a5,80(s1)
    p->trapframe->epc = 0;     // user program counter (entry point is 0)
    8000219a:	70b8                	ld	a4,96(s1)
    8000219c:	00073c23          	sd	zero,24(a4)
    p->trapframe->sp = PGSIZE;  // user stack pointer
    800021a0:	70b8                	ld	a4,96(s1)
    800021a2:	fb1c                	sd	a5,48(a4)
    safestrcpy(p->name, "initcode", sizeof(p->name));
    800021a4:	4641                	li	a2,16
    800021a6:	00006597          	auipc	a1,0x6
    800021aa:	05258593          	addi	a1,a1,82 # 800081f8 <etext+0x1f8>
    800021ae:	16048513          	addi	a0,s1,352
    800021b2:	fffff097          	auipc	ra,0xfffff
    800021b6:	cc4080e7          	jalr	-828(ra) # 80000e76 <safestrcpy>
    p->cwd = namei("/");
    800021ba:	00006517          	auipc	a0,0x6
    800021be:	04e50513          	addi	a0,a0,78 # 80008208 <etext+0x208>
    800021c2:	00002097          	auipc	ra,0x2
    800021c6:	4f8080e7          	jalr	1272(ra) # 800046ba <namei>
    800021ca:	14a4bc23          	sd	a0,344(s1)
    p->state = RUNNABLE;
    800021ce:	478d                	li	a5,3
    800021d0:	cc9c                	sw	a5,24(s1)
    enqueue(&pQueues[p->priority], p);
    800021d2:	58d8                	lw	a4,52(s1)
    800021d4:	00571793          	slli	a5,a4,0x5
    800021d8:	97ba                	add	a5,a5,a4
    800021da:	0792                	slli	a5,a5,0x4
    800021dc:	85a6                	mv	a1,s1
    800021de:	00012517          	auipc	a0,0x12
    800021e2:	b1250513          	addi	a0,a0,-1262 # 80013cf0 <pQueues>
    800021e6:	953e                	add	a0,a0,a5
    800021e8:	00000097          	auipc	ra,0x0
    800021ec:	ed4080e7          	jalr	-300(ra) # 800020bc <enqueue>
    release(&p->lock);
    800021f0:	8526                	mv	a0,s1
    800021f2:	fffff097          	auipc	ra,0xfffff
    800021f6:	afa080e7          	jalr	-1286(ra) # 80000cec <release>
}
    800021fa:	60e2                	ld	ra,24(sp)
    800021fc:	6442                	ld	s0,16(sp)
    800021fe:	64a2                	ld	s1,8(sp)
    80002200:	6105                	addi	sp,sp,32
    80002202:	8082                	ret

0000000080002204 <fork>:
int fork(void) {
    80002204:	7139                	addi	sp,sp,-64
    80002206:	fc06                	sd	ra,56(sp)
    80002208:	f822                	sd	s0,48(sp)
    8000220a:	f04a                	sd	s2,32(sp)
    8000220c:	e456                	sd	s5,8(sp)
    8000220e:	0080                	addi	s0,sp,64
    struct proc *p = myproc();
    80002210:	00000097          	auipc	ra,0x0
    80002214:	858080e7          	jalr	-1960(ra) # 80001a68 <myproc>
    80002218:	8aaa                	mv	s5,a0
    if ((np = allocproc()) == 0) 
    8000221a:	00000097          	auipc	ra,0x0
    8000221e:	a58080e7          	jalr	-1448(ra) # 80001c72 <allocproc>
    80002222:	14050063          	beqz	a0,80002362 <fork+0x15e>
    80002226:	ec4e                	sd	s3,24(sp)
    80002228:	89aa                	mv	s3,a0
    if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    8000222a:	050ab603          	ld	a2,80(s5)
    8000222e:	6d2c                	ld	a1,88(a0)
    80002230:	058ab503          	ld	a0,88(s5)
    80002234:	fffff097          	auipc	ra,0xfffff
    80002238:	3aa080e7          	jalr	938(ra) # 800015de <uvmcopy>
    8000223c:	04054a63          	bltz	a0,80002290 <fork+0x8c>
    80002240:	f426                	sd	s1,40(sp)
    80002242:	e852                	sd	s4,16(sp)
    np->sz = p->sz;
    80002244:	050ab783          	ld	a5,80(s5)
    80002248:	04f9b823          	sd	a5,80(s3)
    *(np->trapframe) = *(p->trapframe);
    8000224c:	060ab683          	ld	a3,96(s5)
    80002250:	87b6                	mv	a5,a3
    80002252:	0609b703          	ld	a4,96(s3)
    80002256:	12068693          	addi	a3,a3,288
    8000225a:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000225e:	6788                	ld	a0,8(a5)
    80002260:	6b8c                	ld	a1,16(a5)
    80002262:	6f90                	ld	a2,24(a5)
    80002264:	01073023          	sd	a6,0(a4)
    80002268:	e708                	sd	a0,8(a4)
    8000226a:	eb0c                	sd	a1,16(a4)
    8000226c:	ef10                	sd	a2,24(a4)
    8000226e:	02078793          	addi	a5,a5,32
    80002272:	02070713          	addi	a4,a4,32
    80002276:	fed792e3          	bne	a5,a3,8000225a <fork+0x56>
    np->trapframe->a0 = 0;
    8000227a:	0609b783          	ld	a5,96(s3)
    8000227e:	0607b823          	sd	zero,112(a5)
    for (i = 0; i < NOFILE; i++)
    80002282:	0d8a8493          	addi	s1,s5,216
    80002286:	0d898913          	addi	s2,s3,216
    8000228a:	158a8a13          	addi	s4,s5,344
    8000228e:	a015                	j	800022b2 <fork+0xae>
        freeproc(np);
    80002290:	854e                	mv	a0,s3
    80002292:	00000097          	auipc	ra,0x0
    80002296:	988080e7          	jalr	-1656(ra) # 80001c1a <freeproc>
        release(&np->lock);
    8000229a:	854e                	mv	a0,s3
    8000229c:	fffff097          	auipc	ra,0xfffff
    800022a0:	a50080e7          	jalr	-1456(ra) # 80000cec <release>
        return -1;
    800022a4:	597d                	li	s2,-1
    800022a6:	69e2                	ld	s3,24(sp)
    800022a8:	a075                	j	80002354 <fork+0x150>
    for (i = 0; i < NOFILE; i++)
    800022aa:	04a1                	addi	s1,s1,8
    800022ac:	0921                	addi	s2,s2,8
    800022ae:	01448b63          	beq	s1,s4,800022c4 <fork+0xc0>
        if (p->ofile[i])
    800022b2:	6088                	ld	a0,0(s1)
    800022b4:	d97d                	beqz	a0,800022aa <fork+0xa6>
            np->ofile[i] = filedup(p->ofile[i]);
    800022b6:	00003097          	auipc	ra,0x3
    800022ba:	a7c080e7          	jalr	-1412(ra) # 80004d32 <filedup>
    800022be:	00a93023          	sd	a0,0(s2)
    800022c2:	b7e5                	j	800022aa <fork+0xa6>
    np->cwd = idup(p->cwd);
    800022c4:	158ab503          	ld	a0,344(s5)
    800022c8:	00002097          	auipc	ra,0x2
    800022cc:	be6080e7          	jalr	-1050(ra) # 80003eae <idup>
    800022d0:	14a9bc23          	sd	a0,344(s3)
    safestrcpy(np->name, p->name, sizeof(p->name));
    800022d4:	4641                	li	a2,16
    800022d6:	160a8593          	addi	a1,s5,352
    800022da:	16098513          	addi	a0,s3,352
    800022de:	fffff097          	auipc	ra,0xfffff
    800022e2:	b98080e7          	jalr	-1128(ra) # 80000e76 <safestrcpy>
    pid = np->pid;
    800022e6:	0309a903          	lw	s2,48(s3)
    release(&np->lock);
    800022ea:	854e                	mv	a0,s3
    800022ec:	fffff097          	auipc	ra,0xfffff
    800022f0:	a00080e7          	jalr	-1536(ra) # 80000cec <release>
    acquire(&wait_lock);
    800022f4:	00012497          	auipc	s1,0x12
    800022f8:	9e448493          	addi	s1,s1,-1564 # 80013cd8 <wait_lock>
    800022fc:	8526                	mv	a0,s1
    800022fe:	fffff097          	auipc	ra,0xfffff
    80002302:	93a080e7          	jalr	-1734(ra) # 80000c38 <acquire>
    np->parent = p;
    80002306:	0559b023          	sd	s5,64(s3)
    release(&wait_lock);
    8000230a:	8526                	mv	a0,s1
    8000230c:	fffff097          	auipc	ra,0xfffff
    80002310:	9e0080e7          	jalr	-1568(ra) # 80000cec <release>
    acquire(&np->lock);
    80002314:	854e                	mv	a0,s3
    80002316:	fffff097          	auipc	ra,0xfffff
    8000231a:	922080e7          	jalr	-1758(ra) # 80000c38 <acquire>
    np->state = RUNNABLE;
    8000231e:	478d                	li	a5,3
    80002320:	00f9ac23          	sw	a5,24(s3)
    enqueue(&pQueues[np->priority], np);
    80002324:	0349a703          	lw	a4,52(s3)
    80002328:	00571793          	slli	a5,a4,0x5
    8000232c:	97ba                	add	a5,a5,a4
    8000232e:	0792                	slli	a5,a5,0x4
    80002330:	85ce                	mv	a1,s3
    80002332:	00012517          	auipc	a0,0x12
    80002336:	9be50513          	addi	a0,a0,-1602 # 80013cf0 <pQueues>
    8000233a:	953e                	add	a0,a0,a5
    8000233c:	00000097          	auipc	ra,0x0
    80002340:	d80080e7          	jalr	-640(ra) # 800020bc <enqueue>
    release(&np->lock);
    80002344:	854e                	mv	a0,s3
    80002346:	fffff097          	auipc	ra,0xfffff
    8000234a:	9a6080e7          	jalr	-1626(ra) # 80000cec <release>
    return pid;
    8000234e:	74a2                	ld	s1,40(sp)
    80002350:	69e2                	ld	s3,24(sp)
    80002352:	6a42                	ld	s4,16(sp)
}
    80002354:	854a                	mv	a0,s2
    80002356:	70e2                	ld	ra,56(sp)
    80002358:	7442                	ld	s0,48(sp)
    8000235a:	7902                	ld	s2,32(sp)
    8000235c:	6aa2                	ld	s5,8(sp)
    8000235e:	6121                	addi	sp,sp,64
    80002360:	8082                	ret
        return -1;
    80002362:	597d                	li	s2,-1
    80002364:	bfc5                	j	80002354 <fork+0x150>

0000000080002366 <dequeue>:
struct proc* dequeue(Queue* queues, struct proc* process) {
    80002366:	1101                	addi	sp,sp,-32
    80002368:	ec06                	sd	ra,24(sp)
    8000236a:	e822                	sd	s0,16(sp)
    8000236c:	e426                	sd	s1,8(sp)
    8000236e:	e04a                	sd	s2,0(sp)
    80002370:	1000                	addi	s0,sp,32
    80002372:	892a                	mv	s2,a0
    80002374:	84ae                	mv	s1,a1
    acquire(&runq_lock);
    80002376:	00012517          	auipc	a0,0x12
    8000237a:	faa50513          	addi	a0,a0,-86 # 80014320 <runq_lock>
    8000237e:	fffff097          	auipc	ra,0xfffff
    80002382:	8ba080e7          	jalr	-1862(ra) # 80000c38 <acquire>
    return queues->rear == -1;
    80002386:	20492603          	lw	a2,516(s2)
    if (isQueueEmpty(queues)) {
    8000238a:	57fd                	li	a5,-1
    8000238c:	02f60863          	beq	a2,a5,800023bc <dequeue+0x56>
    if (process != 0) {
    80002390:	c0c5                	beqz	s1,80002430 <dequeue+0xca>
        for (int i = 0; i <= queues->rear; i++) {
    80002392:	00064b63          	bltz	a2,800023a8 <dequeue+0x42>
    80002396:	87ca                	mv	a5,s2
    80002398:	4701                	li	a4,0
            if (queues->queue[i] == process) {
    8000239a:	6394                	ld	a3,0(a5)
    8000239c:	02968a63          	beq	a3,s1,800023d0 <dequeue+0x6a>
        for (int i = 0; i <= queues->rear; i++) {
    800023a0:	2705                	addiw	a4,a4,1
    800023a2:	07a1                	addi	a5,a5,8
    800023a4:	fee65be3          	bge	a2,a4,8000239a <dequeue+0x34>
            release(&runq_lock);
    800023a8:	00012517          	auipc	a0,0x12
    800023ac:	f7850513          	addi	a0,a0,-136 # 80014320 <runq_lock>
    800023b0:	fffff097          	auipc	ra,0xfffff
    800023b4:	93c080e7          	jalr	-1732(ra) # 80000cec <release>
            return 0;
    800023b8:	4501                	li	a0,0
    800023ba:	a0ad                	j	80002424 <dequeue+0xbe>
        release(&runq_lock);
    800023bc:	00012517          	auipc	a0,0x12
    800023c0:	f6450513          	addi	a0,a0,-156 # 80014320 <runq_lock>
    800023c4:	fffff097          	auipc	ra,0xfffff
    800023c8:	928080e7          	jalr	-1752(ra) # 80000cec <release>
        return 0;
    800023cc:	4501                	li	a0,0
    800023ce:	a899                	j	80002424 <dequeue+0xbe>
        if (index == -1) {
    800023d0:	57fd                	li	a5,-1
    800023d2:	fcf70be3          	beq	a4,a5,800023a8 <dequeue+0x42>
    for (int i = index; i < queues->rear; i++) {
    800023d6:	02c75163          	bge	a4,a2,800023f8 <dequeue+0x92>
    800023da:	00371793          	slli	a5,a4,0x3
    800023de:	97ca                	add	a5,a5,s2
    800023e0:	40e606bb          	subw	a3,a2,a4
    800023e4:	1682                	slli	a3,a3,0x20
    800023e6:	9281                	srli	a3,a3,0x20
    800023e8:	96ba                	add	a3,a3,a4
    800023ea:	068e                	slli	a3,a3,0x3
    800023ec:	96ca                	add	a3,a3,s2
        queues->queue[i] = queues->queue[i + 1];
    800023ee:	6798                	ld	a4,8(a5)
    800023f0:	e398                	sd	a4,0(a5)
    for (int i = index; i < queues->rear; i++) {
    800023f2:	07a1                	addi	a5,a5,8
    800023f4:	fed79de3          	bne	a5,a3,800023ee <dequeue+0x88>
    queues->rear--;
    800023f8:	367d                	addiw	a2,a2,-1
    800023fa:	0006071b          	sext.w	a4,a2
    800023fe:	20c92223          	sw	a2,516(s2)
    queues->pCount--;
    80002402:	20892783          	lw	a5,520(s2)
    80002406:	37fd                	addiw	a5,a5,-1
    80002408:	20f92423          	sw	a5,520(s2)
    if (queues->rear == -1)
    8000240c:	57fd                	li	a5,-1
    8000240e:	02f70563          	beq	a4,a5,80002438 <dequeue+0xd2>
    release(&runq_lock);
    80002412:	00012517          	auipc	a0,0x12
    80002416:	f0e50513          	addi	a0,a0,-242 # 80014320 <runq_lock>
    8000241a:	fffff097          	auipc	ra,0xfffff
    8000241e:	8d2080e7          	jalr	-1838(ra) # 80000cec <release>
    return p;
    80002422:	8526                	mv	a0,s1
}
    80002424:	60e2                	ld	ra,24(sp)
    80002426:	6442                	ld	s0,16(sp)
    80002428:	64a2                	ld	s1,8(sp)
    8000242a:	6902                	ld	s2,0(sp)
    8000242c:	6105                	addi	sp,sp,32
    8000242e:	8082                	ret
        p = queues->queue[0];
    80002430:	00093483          	ld	s1,0(s2)
        index = 0;
    80002434:	4701                	li	a4,0
    80002436:	b745                	j	800023d6 <dequeue+0x70>
        queues->front = 0;
    80002438:	20092023          	sw	zero,512(s2)
    8000243c:	bfd9                	j	80002412 <dequeue+0xac>

000000008000243e <mlfq_scheduler>:
void mlfq_scheduler(void) {
    8000243e:	7159                	addi	sp,sp,-112
    80002440:	f486                	sd	ra,104(sp)
    80002442:	f0a2                	sd	s0,96(sp)
    80002444:	eca6                	sd	s1,88(sp)
    80002446:	e8ca                	sd	s2,80(sp)
    80002448:	e4ce                	sd	s3,72(sp)
    8000244a:	e0d2                	sd	s4,64(sp)
    8000244c:	fc56                	sd	s5,56(sp)
    8000244e:	f85a                	sd	s6,48(sp)
    80002450:	f45e                	sd	s7,40(sp)
    80002452:	f062                	sd	s8,32(sp)
    80002454:	ec66                	sd	s9,24(sp)
    80002456:	e86a                	sd	s10,16(sp)
    80002458:	e46e                	sd	s11,8(sp)
    8000245a:	1880                	addi	s0,sp,112
    8000245c:	8792                	mv	a5,tp
    int id = r_tp();
    8000245e:	2781                	sext.w	a5,a5
    c->proc = 0;
    80002460:	00779693          	slli	a3,a5,0x7
    80002464:	00011717          	auipc	a4,0x11
    80002468:	45c70713          	addi	a4,a4,1116 # 800138c0 <cpus>
    8000246c:	9736                	add	a4,a4,a3
    8000246e:	00073023          	sd	zero,0(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002472:	10002773          	csrr	a4,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002476:	00276713          	ori	a4,a4,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000247a:	10071073          	csrw	sstatus,a4
    8000247e:	00012c97          	auipc	s9,0x12
    80002482:	ea2c8c93          	addi	s9,s9,-350 # 80014320 <runq_lock>
                if (p->state == RUNNABLE) {
    80002486:	4b8d                	li	s7,3
                    c->proc = p;
    80002488:	00011d97          	auipc	s11,0x11
    8000248c:	438d8d93          	addi	s11,s11,1080 # 800138c0 <cpus>
    80002490:	00dd8d33          	add	s10,s11,a3
                    swtch(&c->context, &p->context);
    80002494:	00868793          	addi	a5,a3,8
    80002498:	9dbe                	add	s11,s11,a5
        for (int q = 0; q < NQUEUES; q++) {
    8000249a:	00012a17          	auipc	s4,0x12
    8000249e:	856a0a13          	addi	s4,s4,-1962 # 80013cf0 <pQueues>
            if (isQueueEmpty(&pQueues[q]))
    800024a2:	5c7d                	li	s8,-1
            for (int i = 0; i < size; i++) {
    800024a4:	4a81                	li	s5,0
    800024a6:	a88d                	j	80002518 <mlfq_scheduler+0xda>
                    acquire(&p->lock);
    800024a8:	ffffe097          	auipc	ra,0xffffe
    800024ac:	790080e7          	jalr	1936(ra) # 80000c38 <acquire>
                    p->state = RUNNING;
    800024b0:	4791                	li	a5,4
    800024b2:	cc9c                	sw	a5,24(s1)
                    c->proc = p;
    800024b4:	009d3023          	sd	s1,0(s10)
                    swtch(&c->context, &p->context);
    800024b8:	06848593          	addi	a1,s1,104
    800024bc:	856e                	mv	a0,s11
    800024be:	00001097          	auipc	ra,0x1
    800024c2:	8b6080e7          	jalr	-1866(ra) # 80002d74 <swtch>
                    c->proc = 0;
    800024c6:	000d3023          	sd	zero,0(s10)
                    release(&p->lock);
    800024ca:	8526                	mv	a0,s1
    800024cc:	fffff097          	auipc	ra,0xfffff
    800024d0:	820080e7          	jalr	-2016(ra) # 80000cec <release>
                    p->used_time += pQueues[q].time_quantum;
    800024d4:	5c98                	lw	a4,56(s1)
    800024d6:	20c9a783          	lw	a5,524(s3)
    800024da:	9fb9                	addw	a5,a5,a4
    800024dc:	0007871b          	sext.w	a4,a5
    800024e0:	dc9c                	sw	a5,56(s1)
                    if (p->used_time >= pQueues[q].time_quantum && p->priority < NQUEUES - 1) {
    800024e2:	20c9a783          	lw	a5,524(s3)
    800024e6:	00f74663          	blt	a4,a5,800024f2 <mlfq_scheduler+0xb4>
    800024ea:	58dc                	lw	a5,52(s1)
    800024ec:	4705                	li	a4,1
    800024ee:	04f75063          	bge	a4,a5,8000252e <mlfq_scheduler+0xf0>
                    enqueue(&pQueues[p->priority], p);
    800024f2:	58d8                	lw	a4,52(s1)
    800024f4:	00571793          	slli	a5,a4,0x5
    800024f8:	97ba                	add	a5,a5,a4
    800024fa:	0792                	slli	a5,a5,0x4
    800024fc:	85a6                	mv	a1,s1
    800024fe:	00011517          	auipc	a0,0x11
    80002502:	7f250513          	addi	a0,a0,2034 # 80013cf0 <pQueues>
    80002506:	953e                	add	a0,a0,a5
    80002508:	00000097          	auipc	ra,0x0
    8000250c:	bb4080e7          	jalr	-1100(ra) # 800020bc <enqueue>
        for (int q = 0; q < NQUEUES; q++) {
    80002510:	210a0a13          	addi	s4,s4,528
    80002514:	f99a03e3          	beq	s4,s9,8000249a <mlfq_scheduler+0x5c>
    return queues->rear == -1;
    80002518:	89d2                	mv	s3,s4
            if (isQueueEmpty(&pQueues[q]))
    8000251a:	204a2783          	lw	a5,516(s4)
    8000251e:	ff8789e3          	beq	a5,s8,80002510 <mlfq_scheduler+0xd2>
            int size = pQueues[q].pCount;
    80002522:	208a2b03          	lw	s6,520(s4)
            for (int i = 0; i < size; i++) {
    80002526:	ff6055e3          	blez	s6,80002510 <mlfq_scheduler+0xd2>
    8000252a:	8956                	mv	s2,s5
    8000252c:	a809                	j	8000253e <mlfq_scheduler+0x100>
                        p->priority++;
    8000252e:	2785                	addiw	a5,a5,1
    80002530:	d8dc                	sw	a5,52(s1)
                        p->used_time = 0;
    80002532:	0204ac23          	sw	zero,56(s1)
    80002536:	bf75                	j	800024f2 <mlfq_scheduler+0xb4>
            for (int i = 0; i < size; i++) {
    80002538:	2905                	addiw	s2,s2,1
    8000253a:	fd2b0be3          	beq	s6,s2,80002510 <mlfq_scheduler+0xd2>
                p = dequeue(&pQueues[q], 0);
    8000253e:	85d6                	mv	a1,s5
    80002540:	854e                	mv	a0,s3
    80002542:	00000097          	auipc	ra,0x0
    80002546:	e24080e7          	jalr	-476(ra) # 80002366 <dequeue>
    8000254a:	84aa                	mv	s1,a0
                if (p == 0)
    8000254c:	d575                	beqz	a0,80002538 <mlfq_scheduler+0xfa>
                if (p->state == UNUSED)
    8000254e:	4d1c                	lw	a5,24(a0)
    80002550:	d7e5                	beqz	a5,80002538 <mlfq_scheduler+0xfa>
                if (p->state == RUNNABLE) {
    80002552:	f5778be3          	beq	a5,s7,800024a8 <mlfq_scheduler+0x6a>
                    enqueue(&pQueues[q], p);
    80002556:	85aa                	mv	a1,a0
    80002558:	854e                	mv	a0,s3
    8000255a:	00000097          	auipc	ra,0x0
    8000255e:	b62080e7          	jalr	-1182(ra) # 800020bc <enqueue>
    80002562:	bfd9                	j	80002538 <mlfq_scheduler+0xfa>

0000000080002564 <sched>:
{
    80002564:	7179                	addi	sp,sp,-48
    80002566:	f406                	sd	ra,40(sp)
    80002568:	f022                	sd	s0,32(sp)
    8000256a:	ec26                	sd	s1,24(sp)
    8000256c:	e84a                	sd	s2,16(sp)
    8000256e:	e44e                	sd	s3,8(sp)
    80002570:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80002572:	fffff097          	auipc	ra,0xfffff
    80002576:	4f6080e7          	jalr	1270(ra) # 80001a68 <myproc>
    8000257a:	84aa                	mv	s1,a0
    if (!holding(&p->lock))
    8000257c:	ffffe097          	auipc	ra,0xffffe
    80002580:	642080e7          	jalr	1602(ra) # 80000bbe <holding>
    80002584:	c53d                	beqz	a0,800025f2 <sched+0x8e>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002586:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    80002588:	2781                	sext.w	a5,a5
    8000258a:	079e                	slli	a5,a5,0x7
    8000258c:	00011717          	auipc	a4,0x11
    80002590:	33470713          	addi	a4,a4,820 # 800138c0 <cpus>
    80002594:	97ba                	add	a5,a5,a4
    80002596:	5fb8                	lw	a4,120(a5)
    80002598:	4785                	li	a5,1
    8000259a:	06f71463          	bne	a4,a5,80002602 <sched+0x9e>
    if (p->state == RUNNING)
    8000259e:	4c98                	lw	a4,24(s1)
    800025a0:	4791                	li	a5,4
    800025a2:	06f70863          	beq	a4,a5,80002612 <sched+0xae>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025a6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800025aa:	8b89                	andi	a5,a5,2
    if (intr_get())
    800025ac:	ebbd                	bnez	a5,80002622 <sched+0xbe>
  asm volatile("mv %0, tp" : "=r" (x) );
    800025ae:	8792                	mv	a5,tp
    intena = mycpu()->intena;
    800025b0:	00011917          	auipc	s2,0x11
    800025b4:	31090913          	addi	s2,s2,784 # 800138c0 <cpus>
    800025b8:	2781                	sext.w	a5,a5
    800025ba:	079e                	slli	a5,a5,0x7
    800025bc:	97ca                	add	a5,a5,s2
    800025be:	07c7a983          	lw	s3,124(a5)
    800025c2:	8592                	mv	a1,tp
    swtch(&p->context, &mycpu()->context);
    800025c4:	2581                	sext.w	a1,a1
    800025c6:	059e                	slli	a1,a1,0x7
    800025c8:	05a1                	addi	a1,a1,8
    800025ca:	95ca                	add	a1,a1,s2
    800025cc:	06848513          	addi	a0,s1,104
    800025d0:	00000097          	auipc	ra,0x0
    800025d4:	7a4080e7          	jalr	1956(ra) # 80002d74 <swtch>
    800025d8:	8792                	mv	a5,tp
    mycpu()->intena = intena;
    800025da:	2781                	sext.w	a5,a5
    800025dc:	079e                	slli	a5,a5,0x7
    800025de:	993e                	add	s2,s2,a5
    800025e0:	07392e23          	sw	s3,124(s2)
}
    800025e4:	70a2                	ld	ra,40(sp)
    800025e6:	7402                	ld	s0,32(sp)
    800025e8:	64e2                	ld	s1,24(sp)
    800025ea:	6942                	ld	s2,16(sp)
    800025ec:	69a2                	ld	s3,8(sp)
    800025ee:	6145                	addi	sp,sp,48
    800025f0:	8082                	ret
        panic("sched p->lock");
    800025f2:	00006517          	auipc	a0,0x6
    800025f6:	c1e50513          	addi	a0,a0,-994 # 80008210 <etext+0x210>
    800025fa:	ffffe097          	auipc	ra,0xffffe
    800025fe:	f66080e7          	jalr	-154(ra) # 80000560 <panic>
        panic("sched locks");
    80002602:	00006517          	auipc	a0,0x6
    80002606:	c1e50513          	addi	a0,a0,-994 # 80008220 <etext+0x220>
    8000260a:	ffffe097          	auipc	ra,0xffffe
    8000260e:	f56080e7          	jalr	-170(ra) # 80000560 <panic>
        panic("sched running");
    80002612:	00006517          	auipc	a0,0x6
    80002616:	c1e50513          	addi	a0,a0,-994 # 80008230 <etext+0x230>
    8000261a:	ffffe097          	auipc	ra,0xffffe
    8000261e:	f46080e7          	jalr	-186(ra) # 80000560 <panic>
        panic("sched interruptible");
    80002622:	00006517          	auipc	a0,0x6
    80002626:	c1e50513          	addi	a0,a0,-994 # 80008240 <etext+0x240>
    8000262a:	ffffe097          	auipc	ra,0xffffe
    8000262e:	f36080e7          	jalr	-202(ra) # 80000560 <panic>

0000000080002632 <yield>:
void yield(uint64 reason) {
    80002632:	1101                	addi	sp,sp,-32
    80002634:	ec06                	sd	ra,24(sp)
    80002636:	e822                	sd	s0,16(sp)
    80002638:	e426                	sd	s1,8(sp)
    8000263a:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    8000263c:	fffff097          	auipc	ra,0xfffff
    80002640:	42c080e7          	jalr	1068(ra) # 80001a68 <myproc>
    80002644:	84aa                	mv	s1,a0
    acquire(&p->lock);
    80002646:	ffffe097          	auipc	ra,0xffffe
    8000264a:	5f2080e7          	jalr	1522(ra) # 80000c38 <acquire>
    if (p->used_time >= pQueues[p->priority].time_quantum) {
    8000264e:	58d8                	lw	a4,52(s1)
    80002650:	00571793          	slli	a5,a4,0x5
    80002654:	97ba                	add	a5,a5,a4
    80002656:	0792                	slli	a5,a5,0x4
    80002658:	00011697          	auipc	a3,0x11
    8000265c:	26868693          	addi	a3,a3,616 # 800138c0 <cpus>
    80002660:	97b6                	add	a5,a5,a3
    80002662:	5c94                	lw	a3,56(s1)
    80002664:	63c7a783          	lw	a5,1596(a5)
    80002668:	04f6c563          	blt	a3,a5,800026b2 <yield+0x80>
        p->used_time = 0;
    8000266c:	0204ac23          	sw	zero,56(s1)
        if (p->priority < NQUEUES - 1) {
    80002670:	4785                	li	a5,1
    80002672:	06e7d063          	bge	a5,a4,800026d2 <yield+0xa0>
            dequeue(&pQueues[p->priority], p);
    80002676:	00571793          	slli	a5,a4,0x5
    8000267a:	97ba                	add	a5,a5,a4
    8000267c:	0792                	slli	a5,a5,0x4
    8000267e:	85a6                	mv	a1,s1
    80002680:	00011517          	auipc	a0,0x11
    80002684:	67050513          	addi	a0,a0,1648 # 80013cf0 <pQueues>
    80002688:	953e                	add	a0,a0,a5
    8000268a:	00000097          	auipc	ra,0x0
    8000268e:	cdc080e7          	jalr	-804(ra) # 80002366 <dequeue>
    80002692:	4701                	li	a4,0
            p->priority++;
    80002694:	d8d8                	sw	a4,52(s1)
        enqueue(&pQueues[p->priority], p);
    80002696:	00571793          	slli	a5,a4,0x5
    8000269a:	97ba                	add	a5,a5,a4
    8000269c:	0792                	slli	a5,a5,0x4
    8000269e:	85a6                	mv	a1,s1
    800026a0:	00011517          	auipc	a0,0x11
    800026a4:	65050513          	addi	a0,a0,1616 # 80013cf0 <pQueues>
    800026a8:	953e                	add	a0,a0,a5
    800026aa:	00000097          	auipc	ra,0x0
    800026ae:	a12080e7          	jalr	-1518(ra) # 800020bc <enqueue>
    p->state = RUNNABLE;
    800026b2:	478d                	li	a5,3
    800026b4:	cc9c                	sw	a5,24(s1)
    sched();
    800026b6:	00000097          	auipc	ra,0x0
    800026ba:	eae080e7          	jalr	-338(ra) # 80002564 <sched>
    release(&p->lock);
    800026be:	8526                	mv	a0,s1
    800026c0:	ffffe097          	auipc	ra,0xffffe
    800026c4:	62c080e7          	jalr	1580(ra) # 80000cec <release>
}
    800026c8:	60e2                	ld	ra,24(sp)
    800026ca:	6442                	ld	s0,16(sp)
    800026cc:	64a2                	ld	s1,8(sp)
    800026ce:	6105                	addi	sp,sp,32
    800026d0:	8082                	ret
            dequeue(&pQueues[p->priority], p);
    800026d2:	00571793          	slli	a5,a4,0x5
    800026d6:	97ba                	add	a5,a5,a4
    800026d8:	0792                	slli	a5,a5,0x4
    800026da:	85a6                	mv	a1,s1
    800026dc:	00011517          	auipc	a0,0x11
    800026e0:	61450513          	addi	a0,a0,1556 # 80013cf0 <pQueues>
    800026e4:	953e                	add	a0,a0,a5
    800026e6:	00000097          	auipc	ra,0x0
    800026ea:	c80080e7          	jalr	-896(ra) # 80002366 <dequeue>
            p->priority++;
    800026ee:	58d8                	lw	a4,52(s1)
    800026f0:	2705                	addiw	a4,a4,1
    800026f2:	b74d                	j	80002694 <yield+0x62>

00000000800026f4 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    800026f4:	7179                	addi	sp,sp,-48
    800026f6:	f406                	sd	ra,40(sp)
    800026f8:	f022                	sd	s0,32(sp)
    800026fa:	ec26                	sd	s1,24(sp)
    800026fc:	e84a                	sd	s2,16(sp)
    800026fe:	e44e                	sd	s3,8(sp)
    80002700:	1800                	addi	s0,sp,48
    80002702:	89aa                	mv	s3,a0
    80002704:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80002706:	fffff097          	auipc	ra,0xfffff
    8000270a:	362080e7          	jalr	866(ra) # 80001a68 <myproc>
    8000270e:	84aa                	mv	s1,a0
    // Once we hold p->lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup locks p->lock),
    // so it's okay to release lk.

    acquire(&p->lock); // DOC: sleeplock1
    80002710:	ffffe097          	auipc	ra,0xffffe
    80002714:	528080e7          	jalr	1320(ra) # 80000c38 <acquire>
    release(lk);
    80002718:	854a                	mv	a0,s2
    8000271a:	ffffe097          	auipc	ra,0xffffe
    8000271e:	5d2080e7          	jalr	1490(ra) # 80000cec <release>

    // Go to sleep.
    p->chan = chan;
    80002722:	0334b023          	sd	s3,32(s1)
    p->state = SLEEPING;
    80002726:	4789                	li	a5,2
    80002728:	cc9c                	sw	a5,24(s1)

    sched();
    8000272a:	00000097          	auipc	ra,0x0
    8000272e:	e3a080e7          	jalr	-454(ra) # 80002564 <sched>

    // Tidy up.
    p->chan = 0;
    80002732:	0204b023          	sd	zero,32(s1)

    // Reacquire original lock.
    release(&p->lock);
    80002736:	8526                	mv	a0,s1
    80002738:	ffffe097          	auipc	ra,0xffffe
    8000273c:	5b4080e7          	jalr	1460(ra) # 80000cec <release>
    acquire(lk);
    80002740:	854a                	mv	a0,s2
    80002742:	ffffe097          	auipc	ra,0xffffe
    80002746:	4f6080e7          	jalr	1270(ra) # 80000c38 <acquire>
}
    8000274a:	70a2                	ld	ra,40(sp)
    8000274c:	7402                	ld	s0,32(sp)
    8000274e:	64e2                	ld	s1,24(sp)
    80002750:	6942                	ld	s2,16(sp)
    80002752:	69a2                	ld	s3,8(sp)
    80002754:	6145                	addi	sp,sp,48
    80002756:	8082                	ret

0000000080002758 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    80002758:	7139                	addi	sp,sp,-64
    8000275a:	fc06                	sd	ra,56(sp)
    8000275c:	f822                	sd	s0,48(sp)
    8000275e:	f426                	sd	s1,40(sp)
    80002760:	f04a                	sd	s2,32(sp)
    80002762:	ec4e                	sd	s3,24(sp)
    80002764:	e852                	sd	s4,16(sp)
    80002766:	e456                	sd	s5,8(sp)
    80002768:	0080                	addi	s0,sp,64
    8000276a:	8a2a                	mv	s4,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    8000276c:	00012497          	auipc	s1,0x12
    80002770:	bcc48493          	addi	s1,s1,-1076 # 80014338 <proc>
    {
        if (p != myproc())
        {
            acquire(&p->lock);
            if (p->state == SLEEPING && p->chan == chan)
    80002774:	4989                	li	s3,2
            {
                p->state = RUNNABLE;
    80002776:	4a8d                	li	s5,3
    for (p = proc; p < &proc[NPROC]; p++)
    80002778:	00017917          	auipc	s2,0x17
    8000277c:	7c090913          	addi	s2,s2,1984 # 80019f38 <tickslock>
    80002780:	a811                	j	80002794 <wakeup+0x3c>
            }
            release(&p->lock);
    80002782:	8526                	mv	a0,s1
    80002784:	ffffe097          	auipc	ra,0xffffe
    80002788:	568080e7          	jalr	1384(ra) # 80000cec <release>
    for (p = proc; p < &proc[NPROC]; p++)
    8000278c:	17048493          	addi	s1,s1,368
    80002790:	03248663          	beq	s1,s2,800027bc <wakeup+0x64>
        if (p != myproc())
    80002794:	fffff097          	auipc	ra,0xfffff
    80002798:	2d4080e7          	jalr	724(ra) # 80001a68 <myproc>
    8000279c:	fea488e3          	beq	s1,a0,8000278c <wakeup+0x34>
            acquire(&p->lock);
    800027a0:	8526                	mv	a0,s1
    800027a2:	ffffe097          	auipc	ra,0xffffe
    800027a6:	496080e7          	jalr	1174(ra) # 80000c38 <acquire>
            if (p->state == SLEEPING && p->chan == chan)
    800027aa:	4c9c                	lw	a5,24(s1)
    800027ac:	fd379be3          	bne	a5,s3,80002782 <wakeup+0x2a>
    800027b0:	709c                	ld	a5,32(s1)
    800027b2:	fd4798e3          	bne	a5,s4,80002782 <wakeup+0x2a>
                p->state = RUNNABLE;
    800027b6:	0154ac23          	sw	s5,24(s1)
    800027ba:	b7e1                	j	80002782 <wakeup+0x2a>
        }
    }
}
    800027bc:	70e2                	ld	ra,56(sp)
    800027be:	7442                	ld	s0,48(sp)
    800027c0:	74a2                	ld	s1,40(sp)
    800027c2:	7902                	ld	s2,32(sp)
    800027c4:	69e2                	ld	s3,24(sp)
    800027c6:	6a42                	ld	s4,16(sp)
    800027c8:	6aa2                	ld	s5,8(sp)
    800027ca:	6121                	addi	sp,sp,64
    800027cc:	8082                	ret

00000000800027ce <reparent>:
{
    800027ce:	7179                	addi	sp,sp,-48
    800027d0:	f406                	sd	ra,40(sp)
    800027d2:	f022                	sd	s0,32(sp)
    800027d4:	ec26                	sd	s1,24(sp)
    800027d6:	e84a                	sd	s2,16(sp)
    800027d8:	e44e                	sd	s3,8(sp)
    800027da:	e052                	sd	s4,0(sp)
    800027dc:	1800                	addi	s0,sp,48
    800027de:	892a                	mv	s2,a0
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800027e0:	00012497          	auipc	s1,0x12
    800027e4:	b5848493          	addi	s1,s1,-1192 # 80014338 <proc>
            pp->parent = initproc;
    800027e8:	00009a17          	auipc	s4,0x9
    800027ec:	e60a0a13          	addi	s4,s4,-416 # 8000b648 <initproc>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800027f0:	00017997          	auipc	s3,0x17
    800027f4:	74898993          	addi	s3,s3,1864 # 80019f38 <tickslock>
    800027f8:	a029                	j	80002802 <reparent+0x34>
    800027fa:	17048493          	addi	s1,s1,368
    800027fe:	01348d63          	beq	s1,s3,80002818 <reparent+0x4a>
        if (pp->parent == p)
    80002802:	60bc                	ld	a5,64(s1)
    80002804:	ff279be3          	bne	a5,s2,800027fa <reparent+0x2c>
            pp->parent = initproc;
    80002808:	000a3503          	ld	a0,0(s4)
    8000280c:	e0a8                	sd	a0,64(s1)
            wakeup(initproc);
    8000280e:	00000097          	auipc	ra,0x0
    80002812:	f4a080e7          	jalr	-182(ra) # 80002758 <wakeup>
    80002816:	b7d5                	j	800027fa <reparent+0x2c>
}
    80002818:	70a2                	ld	ra,40(sp)
    8000281a:	7402                	ld	s0,32(sp)
    8000281c:	64e2                	ld	s1,24(sp)
    8000281e:	6942                	ld	s2,16(sp)
    80002820:	69a2                	ld	s3,8(sp)
    80002822:	6a02                	ld	s4,0(sp)
    80002824:	6145                	addi	sp,sp,48
    80002826:	8082                	ret

0000000080002828 <exit>:
{
    80002828:	7179                	addi	sp,sp,-48
    8000282a:	f406                	sd	ra,40(sp)
    8000282c:	f022                	sd	s0,32(sp)
    8000282e:	ec26                	sd	s1,24(sp)
    80002830:	e84a                	sd	s2,16(sp)
    80002832:	e44e                	sd	s3,8(sp)
    80002834:	e052                	sd	s4,0(sp)
    80002836:	1800                	addi	s0,sp,48
    80002838:	8a2a                	mv	s4,a0
    struct proc *p = myproc();
    8000283a:	fffff097          	auipc	ra,0xfffff
    8000283e:	22e080e7          	jalr	558(ra) # 80001a68 <myproc>
    80002842:	89aa                	mv	s3,a0
    if (p == initproc)
    80002844:	00009797          	auipc	a5,0x9
    80002848:	e047b783          	ld	a5,-508(a5) # 8000b648 <initproc>
    8000284c:	0d850493          	addi	s1,a0,216
    80002850:	15850913          	addi	s2,a0,344
    80002854:	02a79363          	bne	a5,a0,8000287a <exit+0x52>
        panic("init exiting");
    80002858:	00006517          	auipc	a0,0x6
    8000285c:	a0050513          	addi	a0,a0,-1536 # 80008258 <etext+0x258>
    80002860:	ffffe097          	auipc	ra,0xffffe
    80002864:	d00080e7          	jalr	-768(ra) # 80000560 <panic>
            fileclose(f);
    80002868:	00002097          	auipc	ra,0x2
    8000286c:	51c080e7          	jalr	1308(ra) # 80004d84 <fileclose>
            p->ofile[fd] = 0;
    80002870:	0004b023          	sd	zero,0(s1)
    for (int fd = 0; fd < NOFILE; fd++)
    80002874:	04a1                	addi	s1,s1,8
    80002876:	01248563          	beq	s1,s2,80002880 <exit+0x58>
        if (p->ofile[fd])
    8000287a:	6088                	ld	a0,0(s1)
    8000287c:	f575                	bnez	a0,80002868 <exit+0x40>
    8000287e:	bfdd                	j	80002874 <exit+0x4c>
    begin_op();
    80002880:	00002097          	auipc	ra,0x2
    80002884:	03a080e7          	jalr	58(ra) # 800048ba <begin_op>
    iput(p->cwd);
    80002888:	1589b503          	ld	a0,344(s3)
    8000288c:	00002097          	auipc	ra,0x2
    80002890:	81e080e7          	jalr	-2018(ra) # 800040aa <iput>
    end_op();
    80002894:	00002097          	auipc	ra,0x2
    80002898:	0a0080e7          	jalr	160(ra) # 80004934 <end_op>
    p->cwd = 0;
    8000289c:	1409bc23          	sd	zero,344(s3)
    acquire(&wait_lock);
    800028a0:	00011497          	auipc	s1,0x11
    800028a4:	43848493          	addi	s1,s1,1080 # 80013cd8 <wait_lock>
    800028a8:	8526                	mv	a0,s1
    800028aa:	ffffe097          	auipc	ra,0xffffe
    800028ae:	38e080e7          	jalr	910(ra) # 80000c38 <acquire>
    reparent(p);
    800028b2:	854e                	mv	a0,s3
    800028b4:	00000097          	auipc	ra,0x0
    800028b8:	f1a080e7          	jalr	-230(ra) # 800027ce <reparent>
    wakeup(p->parent);
    800028bc:	0409b503          	ld	a0,64(s3)
    800028c0:	00000097          	auipc	ra,0x0
    800028c4:	e98080e7          	jalr	-360(ra) # 80002758 <wakeup>
    acquire(&p->lock);
    800028c8:	854e                	mv	a0,s3
    800028ca:	ffffe097          	auipc	ra,0xffffe
    800028ce:	36e080e7          	jalr	878(ra) # 80000c38 <acquire>
    p->xstate = status;
    800028d2:	0349a623          	sw	s4,44(s3)
    p->state = ZOMBIE;
    800028d6:	4795                	li	a5,5
    800028d8:	00f9ac23          	sw	a5,24(s3)
    release(&wait_lock);
    800028dc:	8526                	mv	a0,s1
    800028de:	ffffe097          	auipc	ra,0xffffe
    800028e2:	40e080e7          	jalr	1038(ra) # 80000cec <release>
    sched();
    800028e6:	00000097          	auipc	ra,0x0
    800028ea:	c7e080e7          	jalr	-898(ra) # 80002564 <sched>
    panic("zombie exit");
    800028ee:	00006517          	auipc	a0,0x6
    800028f2:	97a50513          	addi	a0,a0,-1670 # 80008268 <etext+0x268>
    800028f6:	ffffe097          	auipc	ra,0xffffe
    800028fa:	c6a080e7          	jalr	-918(ra) # 80000560 <panic>

00000000800028fe <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    800028fe:	7179                	addi	sp,sp,-48
    80002900:	f406                	sd	ra,40(sp)
    80002902:	f022                	sd	s0,32(sp)
    80002904:	ec26                	sd	s1,24(sp)
    80002906:	e84a                	sd	s2,16(sp)
    80002908:	e44e                	sd	s3,8(sp)
    8000290a:	1800                	addi	s0,sp,48
    8000290c:	892a                	mv	s2,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    8000290e:	00012497          	auipc	s1,0x12
    80002912:	a2a48493          	addi	s1,s1,-1494 # 80014338 <proc>
    80002916:	00017997          	auipc	s3,0x17
    8000291a:	62298993          	addi	s3,s3,1570 # 80019f38 <tickslock>
    {
        acquire(&p->lock);
    8000291e:	8526                	mv	a0,s1
    80002920:	ffffe097          	auipc	ra,0xffffe
    80002924:	318080e7          	jalr	792(ra) # 80000c38 <acquire>
        if (p->pid == pid)
    80002928:	589c                	lw	a5,48(s1)
    8000292a:	01278d63          	beq	a5,s2,80002944 <kill+0x46>
                p->state = RUNNABLE;
            }
            release(&p->lock);
            return 0;
        }
        release(&p->lock);
    8000292e:	8526                	mv	a0,s1
    80002930:	ffffe097          	auipc	ra,0xffffe
    80002934:	3bc080e7          	jalr	956(ra) # 80000cec <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80002938:	17048493          	addi	s1,s1,368
    8000293c:	ff3491e3          	bne	s1,s3,8000291e <kill+0x20>
    }
    return -1;
    80002940:	557d                	li	a0,-1
    80002942:	a829                	j	8000295c <kill+0x5e>
            p->killed = 1;
    80002944:	4785                	li	a5,1
    80002946:	d49c                	sw	a5,40(s1)
            if (p->state == SLEEPING)
    80002948:	4c98                	lw	a4,24(s1)
    8000294a:	4789                	li	a5,2
    8000294c:	00f70f63          	beq	a4,a5,8000296a <kill+0x6c>
            release(&p->lock);
    80002950:	8526                	mv	a0,s1
    80002952:	ffffe097          	auipc	ra,0xffffe
    80002956:	39a080e7          	jalr	922(ra) # 80000cec <release>
            return 0;
    8000295a:	4501                	li	a0,0
}
    8000295c:	70a2                	ld	ra,40(sp)
    8000295e:	7402                	ld	s0,32(sp)
    80002960:	64e2                	ld	s1,24(sp)
    80002962:	6942                	ld	s2,16(sp)
    80002964:	69a2                	ld	s3,8(sp)
    80002966:	6145                	addi	sp,sp,48
    80002968:	8082                	ret
                p->state = RUNNABLE;
    8000296a:	478d                	li	a5,3
    8000296c:	cc9c                	sw	a5,24(s1)
    8000296e:	b7cd                	j	80002950 <kill+0x52>

0000000080002970 <setkilled>:

void setkilled(struct proc *p)
{
    80002970:	1101                	addi	sp,sp,-32
    80002972:	ec06                	sd	ra,24(sp)
    80002974:	e822                	sd	s0,16(sp)
    80002976:	e426                	sd	s1,8(sp)
    80002978:	1000                	addi	s0,sp,32
    8000297a:	84aa                	mv	s1,a0
    acquire(&p->lock);
    8000297c:	ffffe097          	auipc	ra,0xffffe
    80002980:	2bc080e7          	jalr	700(ra) # 80000c38 <acquire>
    p->killed = 1;
    80002984:	4785                	li	a5,1
    80002986:	d49c                	sw	a5,40(s1)
    release(&p->lock);
    80002988:	8526                	mv	a0,s1
    8000298a:	ffffe097          	auipc	ra,0xffffe
    8000298e:	362080e7          	jalr	866(ra) # 80000cec <release>
}
    80002992:	60e2                	ld	ra,24(sp)
    80002994:	6442                	ld	s0,16(sp)
    80002996:	64a2                	ld	s1,8(sp)
    80002998:	6105                	addi	sp,sp,32
    8000299a:	8082                	ret

000000008000299c <killed>:

int killed(struct proc *p)
{
    8000299c:	1101                	addi	sp,sp,-32
    8000299e:	ec06                	sd	ra,24(sp)
    800029a0:	e822                	sd	s0,16(sp)
    800029a2:	e426                	sd	s1,8(sp)
    800029a4:	e04a                	sd	s2,0(sp)
    800029a6:	1000                	addi	s0,sp,32
    800029a8:	84aa                	mv	s1,a0
    int k;

    acquire(&p->lock);
    800029aa:	ffffe097          	auipc	ra,0xffffe
    800029ae:	28e080e7          	jalr	654(ra) # 80000c38 <acquire>
    k = p->killed;
    800029b2:	0284a903          	lw	s2,40(s1)
    release(&p->lock);
    800029b6:	8526                	mv	a0,s1
    800029b8:	ffffe097          	auipc	ra,0xffffe
    800029bc:	334080e7          	jalr	820(ra) # 80000cec <release>
    return k;
}
    800029c0:	854a                	mv	a0,s2
    800029c2:	60e2                	ld	ra,24(sp)
    800029c4:	6442                	ld	s0,16(sp)
    800029c6:	64a2                	ld	s1,8(sp)
    800029c8:	6902                	ld	s2,0(sp)
    800029ca:	6105                	addi	sp,sp,32
    800029cc:	8082                	ret

00000000800029ce <wait>:
{
    800029ce:	715d                	addi	sp,sp,-80
    800029d0:	e486                	sd	ra,72(sp)
    800029d2:	e0a2                	sd	s0,64(sp)
    800029d4:	fc26                	sd	s1,56(sp)
    800029d6:	f84a                	sd	s2,48(sp)
    800029d8:	f44e                	sd	s3,40(sp)
    800029da:	f052                	sd	s4,32(sp)
    800029dc:	ec56                	sd	s5,24(sp)
    800029de:	e85a                	sd	s6,16(sp)
    800029e0:	e45e                	sd	s7,8(sp)
    800029e2:	e062                	sd	s8,0(sp)
    800029e4:	0880                	addi	s0,sp,80
    800029e6:	8b2a                	mv	s6,a0
    struct proc *p = myproc();
    800029e8:	fffff097          	auipc	ra,0xfffff
    800029ec:	080080e7          	jalr	128(ra) # 80001a68 <myproc>
    800029f0:	892a                	mv	s2,a0
    acquire(&wait_lock);
    800029f2:	00011517          	auipc	a0,0x11
    800029f6:	2e650513          	addi	a0,a0,742 # 80013cd8 <wait_lock>
    800029fa:	ffffe097          	auipc	ra,0xffffe
    800029fe:	23e080e7          	jalr	574(ra) # 80000c38 <acquire>
        havekids = 0;
    80002a02:	4b81                	li	s7,0
                if (pp->state == ZOMBIE)
    80002a04:	4a15                	li	s4,5
                havekids = 1;
    80002a06:	4a85                	li	s5,1
        for (pp = proc; pp < &proc[NPROC]; pp++)
    80002a08:	00017997          	auipc	s3,0x17
    80002a0c:	53098993          	addi	s3,s3,1328 # 80019f38 <tickslock>
        sleep(p, &wait_lock); // DOC: wait-sleep
    80002a10:	00011c17          	auipc	s8,0x11
    80002a14:	2c8c0c13          	addi	s8,s8,712 # 80013cd8 <wait_lock>
    80002a18:	a0d1                	j	80002adc <wait+0x10e>
                    pid = pp->pid;
    80002a1a:	0304a983          	lw	s3,48(s1)
                    if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002a1e:	000b0e63          	beqz	s6,80002a3a <wait+0x6c>
    80002a22:	4691                	li	a3,4
    80002a24:	02c48613          	addi	a2,s1,44
    80002a28:	85da                	mv	a1,s6
    80002a2a:	05893503          	ld	a0,88(s2)
    80002a2e:	fffff097          	auipc	ra,0xfffff
    80002a32:	cb4080e7          	jalr	-844(ra) # 800016e2 <copyout>
    80002a36:	04054163          	bltz	a0,80002a78 <wait+0xaa>
                    freeproc(pp);
    80002a3a:	8526                	mv	a0,s1
    80002a3c:	fffff097          	auipc	ra,0xfffff
    80002a40:	1de080e7          	jalr	478(ra) # 80001c1a <freeproc>
                    release(&pp->lock);
    80002a44:	8526                	mv	a0,s1
    80002a46:	ffffe097          	auipc	ra,0xffffe
    80002a4a:	2a6080e7          	jalr	678(ra) # 80000cec <release>
                    release(&wait_lock);
    80002a4e:	00011517          	auipc	a0,0x11
    80002a52:	28a50513          	addi	a0,a0,650 # 80013cd8 <wait_lock>
    80002a56:	ffffe097          	auipc	ra,0xffffe
    80002a5a:	296080e7          	jalr	662(ra) # 80000cec <release>
}
    80002a5e:	854e                	mv	a0,s3
    80002a60:	60a6                	ld	ra,72(sp)
    80002a62:	6406                	ld	s0,64(sp)
    80002a64:	74e2                	ld	s1,56(sp)
    80002a66:	7942                	ld	s2,48(sp)
    80002a68:	79a2                	ld	s3,40(sp)
    80002a6a:	7a02                	ld	s4,32(sp)
    80002a6c:	6ae2                	ld	s5,24(sp)
    80002a6e:	6b42                	ld	s6,16(sp)
    80002a70:	6ba2                	ld	s7,8(sp)
    80002a72:	6c02                	ld	s8,0(sp)
    80002a74:	6161                	addi	sp,sp,80
    80002a76:	8082                	ret
                        release(&pp->lock);
    80002a78:	8526                	mv	a0,s1
    80002a7a:	ffffe097          	auipc	ra,0xffffe
    80002a7e:	272080e7          	jalr	626(ra) # 80000cec <release>
                        release(&wait_lock);
    80002a82:	00011517          	auipc	a0,0x11
    80002a86:	25650513          	addi	a0,a0,598 # 80013cd8 <wait_lock>
    80002a8a:	ffffe097          	auipc	ra,0xffffe
    80002a8e:	262080e7          	jalr	610(ra) # 80000cec <release>
                        return -1;
    80002a92:	59fd                	li	s3,-1
    80002a94:	b7e9                	j	80002a5e <wait+0x90>
        for (pp = proc; pp < &proc[NPROC]; pp++)
    80002a96:	17048493          	addi	s1,s1,368
    80002a9a:	03348463          	beq	s1,s3,80002ac2 <wait+0xf4>
            if (pp->parent == p)
    80002a9e:	60bc                	ld	a5,64(s1)
    80002aa0:	ff279be3          	bne	a5,s2,80002a96 <wait+0xc8>
                acquire(&pp->lock);
    80002aa4:	8526                	mv	a0,s1
    80002aa6:	ffffe097          	auipc	ra,0xffffe
    80002aaa:	192080e7          	jalr	402(ra) # 80000c38 <acquire>
                if (pp->state == ZOMBIE)
    80002aae:	4c9c                	lw	a5,24(s1)
    80002ab0:	f74785e3          	beq	a5,s4,80002a1a <wait+0x4c>
                release(&pp->lock);
    80002ab4:	8526                	mv	a0,s1
    80002ab6:	ffffe097          	auipc	ra,0xffffe
    80002aba:	236080e7          	jalr	566(ra) # 80000cec <release>
                havekids = 1;
    80002abe:	8756                	mv	a4,s5
    80002ac0:	bfd9                	j	80002a96 <wait+0xc8>
        if (!havekids || killed(p))
    80002ac2:	c31d                	beqz	a4,80002ae8 <wait+0x11a>
    80002ac4:	854a                	mv	a0,s2
    80002ac6:	00000097          	auipc	ra,0x0
    80002aca:	ed6080e7          	jalr	-298(ra) # 8000299c <killed>
    80002ace:	ed09                	bnez	a0,80002ae8 <wait+0x11a>
        sleep(p, &wait_lock); // DOC: wait-sleep
    80002ad0:	85e2                	mv	a1,s8
    80002ad2:	854a                	mv	a0,s2
    80002ad4:	00000097          	auipc	ra,0x0
    80002ad8:	c20080e7          	jalr	-992(ra) # 800026f4 <sleep>
        havekids = 0;
    80002adc:	875e                	mv	a4,s7
        for (pp = proc; pp < &proc[NPROC]; pp++)
    80002ade:	00012497          	auipc	s1,0x12
    80002ae2:	85a48493          	addi	s1,s1,-1958 # 80014338 <proc>
    80002ae6:	bf65                	j	80002a9e <wait+0xd0>
            release(&wait_lock);
    80002ae8:	00011517          	auipc	a0,0x11
    80002aec:	1f050513          	addi	a0,a0,496 # 80013cd8 <wait_lock>
    80002af0:	ffffe097          	auipc	ra,0xffffe
    80002af4:	1fc080e7          	jalr	508(ra) # 80000cec <release>
            return -1;
    80002af8:	59fd                	li	s3,-1
    80002afa:	b795                	j	80002a5e <wait+0x90>

0000000080002afc <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002afc:	7179                	addi	sp,sp,-48
    80002afe:	f406                	sd	ra,40(sp)
    80002b00:	f022                	sd	s0,32(sp)
    80002b02:	ec26                	sd	s1,24(sp)
    80002b04:	e84a                	sd	s2,16(sp)
    80002b06:	e44e                	sd	s3,8(sp)
    80002b08:	e052                	sd	s4,0(sp)
    80002b0a:	1800                	addi	s0,sp,48
    80002b0c:	84aa                	mv	s1,a0
    80002b0e:	892e                	mv	s2,a1
    80002b10:	89b2                	mv	s3,a2
    80002b12:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    80002b14:	fffff097          	auipc	ra,0xfffff
    80002b18:	f54080e7          	jalr	-172(ra) # 80001a68 <myproc>
    if (user_dst)
    80002b1c:	c08d                	beqz	s1,80002b3e <either_copyout+0x42>
    {
        return copyout(p->pagetable, dst, src, len);
    80002b1e:	86d2                	mv	a3,s4
    80002b20:	864e                	mv	a2,s3
    80002b22:	85ca                	mv	a1,s2
    80002b24:	6d28                	ld	a0,88(a0)
    80002b26:	fffff097          	auipc	ra,0xfffff
    80002b2a:	bbc080e7          	jalr	-1092(ra) # 800016e2 <copyout>
    else
    {
        memmove((char *)dst, src, len);
        return 0;
    }
}
    80002b2e:	70a2                	ld	ra,40(sp)
    80002b30:	7402                	ld	s0,32(sp)
    80002b32:	64e2                	ld	s1,24(sp)
    80002b34:	6942                	ld	s2,16(sp)
    80002b36:	69a2                	ld	s3,8(sp)
    80002b38:	6a02                	ld	s4,0(sp)
    80002b3a:	6145                	addi	sp,sp,48
    80002b3c:	8082                	ret
        memmove((char *)dst, src, len);
    80002b3e:	000a061b          	sext.w	a2,s4
    80002b42:	85ce                	mv	a1,s3
    80002b44:	854a                	mv	a0,s2
    80002b46:	ffffe097          	auipc	ra,0xffffe
    80002b4a:	24a080e7          	jalr	586(ra) # 80000d90 <memmove>
        return 0;
    80002b4e:	8526                	mv	a0,s1
    80002b50:	bff9                	j	80002b2e <either_copyout+0x32>

0000000080002b52 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002b52:	7179                	addi	sp,sp,-48
    80002b54:	f406                	sd	ra,40(sp)
    80002b56:	f022                	sd	s0,32(sp)
    80002b58:	ec26                	sd	s1,24(sp)
    80002b5a:	e84a                	sd	s2,16(sp)
    80002b5c:	e44e                	sd	s3,8(sp)
    80002b5e:	e052                	sd	s4,0(sp)
    80002b60:	1800                	addi	s0,sp,48
    80002b62:	892a                	mv	s2,a0
    80002b64:	84ae                	mv	s1,a1
    80002b66:	89b2                	mv	s3,a2
    80002b68:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    80002b6a:	fffff097          	auipc	ra,0xfffff
    80002b6e:	efe080e7          	jalr	-258(ra) # 80001a68 <myproc>
    if (user_src)
    80002b72:	c08d                	beqz	s1,80002b94 <either_copyin+0x42>
    {
        return copyin(p->pagetable, dst, src, len);
    80002b74:	86d2                	mv	a3,s4
    80002b76:	864e                	mv	a2,s3
    80002b78:	85ca                	mv	a1,s2
    80002b7a:	6d28                	ld	a0,88(a0)
    80002b7c:	fffff097          	auipc	ra,0xfffff
    80002b80:	bf2080e7          	jalr	-1038(ra) # 8000176e <copyin>
    else
    {
        memmove(dst, (char *)src, len);
        return 0;
    }
}
    80002b84:	70a2                	ld	ra,40(sp)
    80002b86:	7402                	ld	s0,32(sp)
    80002b88:	64e2                	ld	s1,24(sp)
    80002b8a:	6942                	ld	s2,16(sp)
    80002b8c:	69a2                	ld	s3,8(sp)
    80002b8e:	6a02                	ld	s4,0(sp)
    80002b90:	6145                	addi	sp,sp,48
    80002b92:	8082                	ret
        memmove(dst, (char *)src, len);
    80002b94:	000a061b          	sext.w	a2,s4
    80002b98:	85ce                	mv	a1,s3
    80002b9a:	854a                	mv	a0,s2
    80002b9c:	ffffe097          	auipc	ra,0xffffe
    80002ba0:	1f4080e7          	jalr	500(ra) # 80000d90 <memmove>
        return 0;
    80002ba4:	8526                	mv	a0,s1
    80002ba6:	bff9                	j	80002b84 <either_copyin+0x32>

0000000080002ba8 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    80002ba8:	715d                	addi	sp,sp,-80
    80002baa:	e486                	sd	ra,72(sp)
    80002bac:	e0a2                	sd	s0,64(sp)
    80002bae:	fc26                	sd	s1,56(sp)
    80002bb0:	f84a                	sd	s2,48(sp)
    80002bb2:	f44e                	sd	s3,40(sp)
    80002bb4:	f052                	sd	s4,32(sp)
    80002bb6:	ec56                	sd	s5,24(sp)
    80002bb8:	e85a                	sd	s6,16(sp)
    80002bba:	e45e                	sd	s7,8(sp)
    80002bbc:	0880                	addi	s0,sp,80
        [RUNNING] "run   ",
        [ZOMBIE] "zombie"};
    struct proc *p;
    char *state;

    printf("\n");
    80002bbe:	00005517          	auipc	a0,0x5
    80002bc2:	45250513          	addi	a0,a0,1106 # 80008010 <etext+0x10>
    80002bc6:	ffffe097          	auipc	ra,0xffffe
    80002bca:	9e4080e7          	jalr	-1564(ra) # 800005aa <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80002bce:	00012497          	auipc	s1,0x12
    80002bd2:	8ca48493          	addi	s1,s1,-1846 # 80014498 <proc+0x160>
    80002bd6:	00017917          	auipc	s2,0x17
    80002bda:	4c290913          	addi	s2,s2,1218 # 8001a098 <bcache+0x148>
    {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002bde:	4b15                	li	s6,5
            state = states[p->state];
        else
            state = "???";
    80002be0:	00005997          	auipc	s3,0x5
    80002be4:	69898993          	addi	s3,s3,1688 # 80008278 <etext+0x278>
        printf("%d <%s %s", p->pid, state, p->name);
    80002be8:	00005a97          	auipc	s5,0x5
    80002bec:	698a8a93          	addi	s5,s5,1688 # 80008280 <etext+0x280>
        printf("\n");
    80002bf0:	00005a17          	auipc	s4,0x5
    80002bf4:	420a0a13          	addi	s4,s4,1056 # 80008010 <etext+0x10>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002bf8:	00006b97          	auipc	s7,0x6
    80002bfc:	c60b8b93          	addi	s7,s7,-928 # 80008858 <states.0>
    80002c00:	a00d                	j	80002c22 <procdump+0x7a>
        printf("%d <%s %s", p->pid, state, p->name);
    80002c02:	ed06a583          	lw	a1,-304(a3)
    80002c06:	8556                	mv	a0,s5
    80002c08:	ffffe097          	auipc	ra,0xffffe
    80002c0c:	9a2080e7          	jalr	-1630(ra) # 800005aa <printf>
        printf("\n");
    80002c10:	8552                	mv	a0,s4
    80002c12:	ffffe097          	auipc	ra,0xffffe
    80002c16:	998080e7          	jalr	-1640(ra) # 800005aa <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80002c1a:	17048493          	addi	s1,s1,368
    80002c1e:	03248263          	beq	s1,s2,80002c42 <procdump+0x9a>
        if (p->state == UNUSED)
    80002c22:	86a6                	mv	a3,s1
    80002c24:	eb84a783          	lw	a5,-328(s1)
    80002c28:	dbed                	beqz	a5,80002c1a <procdump+0x72>
            state = "???";
    80002c2a:	864e                	mv	a2,s3
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002c2c:	fcfb6be3          	bltu	s6,a5,80002c02 <procdump+0x5a>
    80002c30:	02079713          	slli	a4,a5,0x20
    80002c34:	01d75793          	srli	a5,a4,0x1d
    80002c38:	97de                	add	a5,a5,s7
    80002c3a:	6390                	ld	a2,0(a5)
    80002c3c:	f279                	bnez	a2,80002c02 <procdump+0x5a>
            state = "???";
    80002c3e:	864e                	mv	a2,s3
    80002c40:	b7c9                	j	80002c02 <procdump+0x5a>
    }
}
    80002c42:	60a6                	ld	ra,72(sp)
    80002c44:	6406                	ld	s0,64(sp)
    80002c46:	74e2                	ld	s1,56(sp)
    80002c48:	7942                	ld	s2,48(sp)
    80002c4a:	79a2                	ld	s3,40(sp)
    80002c4c:	7a02                	ld	s4,32(sp)
    80002c4e:	6ae2                	ld	s5,24(sp)
    80002c50:	6b42                	ld	s6,16(sp)
    80002c52:	6ba2                	ld	s7,8(sp)
    80002c54:	6161                	addi	sp,sp,80
    80002c56:	8082                	ret

0000000080002c58 <schedls>:

void schedls()
{
    80002c58:	7139                	addi	sp,sp,-64
    80002c5a:	fc06                	sd	ra,56(sp)
    80002c5c:	f822                	sd	s0,48(sp)
    80002c5e:	f426                	sd	s1,40(sp)
    80002c60:	f04a                	sd	s2,32(sp)
    80002c62:	ec4e                	sd	s3,24(sp)
    80002c64:	e852                	sd	s4,16(sp)
    80002c66:	e456                	sd	s5,8(sp)
    80002c68:	e05a                	sd	s6,0(sp)
    80002c6a:	0080                	addi	s0,sp,64
    printf("[ ]\tScheduler Name\tScheduler ID\n");
    80002c6c:	00005517          	auipc	a0,0x5
    80002c70:	62450513          	addi	a0,a0,1572 # 80008290 <etext+0x290>
    80002c74:	ffffe097          	auipc	ra,0xffffe
    80002c78:	936080e7          	jalr	-1738(ra) # 800005aa <printf>
    printf("====================================\n");
    80002c7c:	00005517          	auipc	a0,0x5
    80002c80:	63c50513          	addi	a0,a0,1596 # 800082b8 <etext+0x2b8>
    80002c84:	ffffe097          	auipc	ra,0xffffe
    80002c88:	926080e7          	jalr	-1754(ra) # 800005aa <printf>
    for (int i = 0; i < SCHEDC; i++)
    80002c8c:	00009497          	auipc	s1,0x9
    80002c90:	90c48493          	addi	s1,s1,-1780 # 8000b598 <available_schedulers>
    80002c94:	00009a97          	auipc	s5,0x9
    80002c98:	964a8a93          	addi	s5,s5,-1692 # 8000b5f8 <_GLOBAL_OFFSET_TABLE_>
    {
        if (available_schedulers[i].impl == sched_pointer)
    80002c9c:	00009a17          	auipc	s4,0x9
    80002ca0:	89ca0a13          	addi	s4,s4,-1892 # 8000b538 <sched_pointer>
        {
            printf("[*]\t");
        }
        else
        {
            printf("   \t");
    80002ca4:	00005b17          	auipc	s6,0x5
    80002ca8:	644b0b13          	addi	s6,s6,1604 # 800082e8 <etext+0x2e8>
        }
        printf("%s\t%d\n", available_schedulers[i].name, available_schedulers[i].id);
    80002cac:	00005997          	auipc	s3,0x5
    80002cb0:	64498993          	addi	s3,s3,1604 # 800082f0 <etext+0x2f0>
    80002cb4:	a02d                	j	80002cde <schedls+0x86>
            printf("[*]\t");
    80002cb6:	00005517          	auipc	a0,0x5
    80002cba:	62a50513          	addi	a0,a0,1578 # 800082e0 <etext+0x2e0>
    80002cbe:	ffffe097          	auipc	ra,0xffffe
    80002cc2:	8ec080e7          	jalr	-1812(ra) # 800005aa <printf>
        printf("%s\t%d\n", available_schedulers[i].name, available_schedulers[i].id);
    80002cc6:	01892603          	lw	a2,24(s2)
    80002cca:	85ca                	mv	a1,s2
    80002ccc:	854e                	mv	a0,s3
    80002cce:	ffffe097          	auipc	ra,0xffffe
    80002cd2:	8dc080e7          	jalr	-1828(ra) # 800005aa <printf>
    for (int i = 0; i < SCHEDC; i++)
    80002cd6:	02048493          	addi	s1,s1,32
    80002cda:	01548e63          	beq	s1,s5,80002cf6 <schedls+0x9e>
        if (available_schedulers[i].impl == sched_pointer)
    80002cde:	8926                	mv	s2,s1
    80002ce0:	6898                	ld	a4,16(s1)
    80002ce2:	000a3783          	ld	a5,0(s4)
    80002ce6:	fcf708e3          	beq	a4,a5,80002cb6 <schedls+0x5e>
            printf("   \t");
    80002cea:	855a                	mv	a0,s6
    80002cec:	ffffe097          	auipc	ra,0xffffe
    80002cf0:	8be080e7          	jalr	-1858(ra) # 800005aa <printf>
    80002cf4:	bfc9                	j	80002cc6 <schedls+0x6e>
    }
    printf("\n*: current scheduler\n\n");
    80002cf6:	00005517          	auipc	a0,0x5
    80002cfa:	60250513          	addi	a0,a0,1538 # 800082f8 <etext+0x2f8>
    80002cfe:	ffffe097          	auipc	ra,0xffffe
    80002d02:	8ac080e7          	jalr	-1876(ra) # 800005aa <printf>
}
    80002d06:	70e2                	ld	ra,56(sp)
    80002d08:	7442                	ld	s0,48(sp)
    80002d0a:	74a2                	ld	s1,40(sp)
    80002d0c:	7902                	ld	s2,32(sp)
    80002d0e:	69e2                	ld	s3,24(sp)
    80002d10:	6a42                	ld	s4,16(sp)
    80002d12:	6aa2                	ld	s5,8(sp)
    80002d14:	6b02                	ld	s6,0(sp)
    80002d16:	6121                	addi	sp,sp,64
    80002d18:	8082                	ret

0000000080002d1a <schedset>:

void schedset(int id)
{
    80002d1a:	1141                	addi	sp,sp,-16
    80002d1c:	e406                	sd	ra,8(sp)
    80002d1e:	e022                	sd	s0,0(sp)
    80002d20:	0800                	addi	s0,sp,16
    if (id < 0 || SCHEDC <= id)
    80002d22:	4709                	li	a4,2
    80002d24:	02a76f63          	bltu	a4,a0,80002d62 <schedset+0x48>
    {
        printf("Scheduler unchanged: ID out of range\n");
        return;
    }
    sched_pointer = available_schedulers[id].impl;
    80002d28:	00551793          	slli	a5,a0,0x5
    80002d2c:	00009717          	auipc	a4,0x9
    80002d30:	82470713          	addi	a4,a4,-2012 # 8000b550 <quanta>
    80002d34:	973e                	add	a4,a4,a5
    80002d36:	6f38                	ld	a4,88(a4)
    80002d38:	00009697          	auipc	a3,0x9
    80002d3c:	80e6b023          	sd	a4,-2048(a3) # 8000b538 <sched_pointer>
    printf("Scheduler successfully changed to %s\n", available_schedulers[id].name);
    80002d40:	00009597          	auipc	a1,0x9
    80002d44:	85858593          	addi	a1,a1,-1960 # 8000b598 <available_schedulers>
    80002d48:	95be                	add	a1,a1,a5
    80002d4a:	00005517          	auipc	a0,0x5
    80002d4e:	5ee50513          	addi	a0,a0,1518 # 80008338 <etext+0x338>
    80002d52:	ffffe097          	auipc	ra,0xffffe
    80002d56:	858080e7          	jalr	-1960(ra) # 800005aa <printf>
    80002d5a:	60a2                	ld	ra,8(sp)
    80002d5c:	6402                	ld	s0,0(sp)
    80002d5e:	0141                	addi	sp,sp,16
    80002d60:	8082                	ret
        printf("Scheduler unchanged: ID out of range\n");
    80002d62:	00005517          	auipc	a0,0x5
    80002d66:	5ae50513          	addi	a0,a0,1454 # 80008310 <etext+0x310>
    80002d6a:	ffffe097          	auipc	ra,0xffffe
    80002d6e:	840080e7          	jalr	-1984(ra) # 800005aa <printf>
        return;
    80002d72:	b7e5                	j	80002d5a <schedset+0x40>

0000000080002d74 <swtch>:
    80002d74:	00153023          	sd	ra,0(a0)
    80002d78:	00253423          	sd	sp,8(a0)
    80002d7c:	e900                	sd	s0,16(a0)
    80002d7e:	ed04                	sd	s1,24(a0)
    80002d80:	03253023          	sd	s2,32(a0)
    80002d84:	03353423          	sd	s3,40(a0)
    80002d88:	03453823          	sd	s4,48(a0)
    80002d8c:	03553c23          	sd	s5,56(a0)
    80002d90:	05653023          	sd	s6,64(a0)
    80002d94:	05753423          	sd	s7,72(a0)
    80002d98:	05853823          	sd	s8,80(a0)
    80002d9c:	05953c23          	sd	s9,88(a0)
    80002da0:	07a53023          	sd	s10,96(a0)
    80002da4:	07b53423          	sd	s11,104(a0)
    80002da8:	0005b083          	ld	ra,0(a1)
    80002dac:	0085b103          	ld	sp,8(a1)
    80002db0:	6980                	ld	s0,16(a1)
    80002db2:	6d84                	ld	s1,24(a1)
    80002db4:	0205b903          	ld	s2,32(a1)
    80002db8:	0285b983          	ld	s3,40(a1)
    80002dbc:	0305ba03          	ld	s4,48(a1)
    80002dc0:	0385ba83          	ld	s5,56(a1)
    80002dc4:	0405bb03          	ld	s6,64(a1)
    80002dc8:	0485bb83          	ld	s7,72(a1)
    80002dcc:	0505bc03          	ld	s8,80(a1)
    80002dd0:	0585bc83          	ld	s9,88(a1)
    80002dd4:	0605bd03          	ld	s10,96(a1)
    80002dd8:	0685bd83          	ld	s11,104(a1)
    80002ddc:	8082                	ret

0000000080002dde <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80002dde:	1141                	addi	sp,sp,-16
    80002de0:	e406                	sd	ra,8(sp)
    80002de2:	e022                	sd	s0,0(sp)
    80002de4:	0800                	addi	s0,sp,16
    initlock(&tickslock, "time");
    80002de6:	00005597          	auipc	a1,0x5
    80002dea:	5aa58593          	addi	a1,a1,1450 # 80008390 <etext+0x390>
    80002dee:	00017517          	auipc	a0,0x17
    80002df2:	14a50513          	addi	a0,a0,330 # 80019f38 <tickslock>
    80002df6:	ffffe097          	auipc	ra,0xffffe
    80002dfa:	db2080e7          	jalr	-590(ra) # 80000ba8 <initlock>
}
    80002dfe:	60a2                	ld	ra,8(sp)
    80002e00:	6402                	ld	s0,0(sp)
    80002e02:	0141                	addi	sp,sp,16
    80002e04:	8082                	ret

0000000080002e06 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80002e06:	1141                	addi	sp,sp,-16
    80002e08:	e422                	sd	s0,8(sp)
    80002e0a:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002e0c:	00003797          	auipc	a5,0x3
    80002e10:	67478793          	addi	a5,a5,1652 # 80006480 <kernelvec>
    80002e14:	10579073          	csrw	stvec,a5
    w_stvec((uint64)kernelvec);
}
    80002e18:	6422                	ld	s0,8(sp)
    80002e1a:	0141                	addi	sp,sp,16
    80002e1c:	8082                	ret

0000000080002e1e <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80002e1e:	1141                	addi	sp,sp,-16
    80002e20:	e406                	sd	ra,8(sp)
    80002e22:	e022                	sd	s0,0(sp)
    80002e24:	0800                	addi	s0,sp,16
    struct proc *p = myproc();
    80002e26:	fffff097          	auipc	ra,0xfffff
    80002e2a:	c42080e7          	jalr	-958(ra) # 80001a68 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e2e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002e32:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002e34:	10079073          	csrw	sstatus,a5
    // kerneltrap() to usertrap(), so turn off interrupts until
    // we're back in user space, where usertrap() is correct.
    intr_off();

    // send syscalls, interrupts, and exceptions to uservec in trampoline.S
    uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002e38:	00004697          	auipc	a3,0x4
    80002e3c:	1c868693          	addi	a3,a3,456 # 80007000 <_trampoline>
    80002e40:	00004717          	auipc	a4,0x4
    80002e44:	1c070713          	addi	a4,a4,448 # 80007000 <_trampoline>
    80002e48:	8f15                	sub	a4,a4,a3
    80002e4a:	040007b7          	lui	a5,0x4000
    80002e4e:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002e50:	07b2                	slli	a5,a5,0xc
    80002e52:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002e54:	10571073          	csrw	stvec,a4
    w_stvec(trampoline_uservec);

    // set up trapframe values that uservec will need when
    // the process next traps into the kernel.
    p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002e58:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002e5a:	18002673          	csrr	a2,satp
    80002e5e:	e310                	sd	a2,0(a4)
    p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002e60:	7130                	ld	a2,96(a0)
    80002e62:	6538                	ld	a4,72(a0)
    80002e64:	6585                	lui	a1,0x1
    80002e66:	972e                	add	a4,a4,a1
    80002e68:	e618                	sd	a4,8(a2)
    p->trapframe->kernel_trap = (uint64)usertrap;
    80002e6a:	7138                	ld	a4,96(a0)
    80002e6c:	00000617          	auipc	a2,0x0
    80002e70:	13860613          	addi	a2,a2,312 # 80002fa4 <usertrap>
    80002e74:	eb10                	sd	a2,16(a4)
    p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002e76:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002e78:	8612                	mv	a2,tp
    80002e7a:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e7c:	10002773          	csrr	a4,sstatus
    // set up the registers that trampoline.S's sret will use
    // to get to user space.

    // set S Previous Privilege mode to User.
    unsigned long x = r_sstatus();
    x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002e80:	eff77713          	andi	a4,a4,-257
    x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002e84:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002e88:	10071073          	csrw	sstatus,a4
    w_sstatus(x);

    // set S Exception Program Counter to the saved user pc.
    w_sepc(p->trapframe->epc);
    80002e8c:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002e8e:	6f18                	ld	a4,24(a4)
    80002e90:	14171073          	csrw	sepc,a4

    // tell trampoline.S the user page table to switch to.
    uint64 satp = MAKE_SATP(p->pagetable);
    80002e94:	6d28                	ld	a0,88(a0)
    80002e96:	8131                	srli	a0,a0,0xc

    // jump to userret in trampoline.S at the top of memory, which
    // switches to the user page table, restores user registers,
    // and switches to user mode with sret.
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002e98:	00004717          	auipc	a4,0x4
    80002e9c:	20470713          	addi	a4,a4,516 # 8000709c <userret>
    80002ea0:	8f15                	sub	a4,a4,a3
    80002ea2:	97ba                	add	a5,a5,a4
    ((void (*)(uint64))trampoline_userret)(satp);
    80002ea4:	577d                	li	a4,-1
    80002ea6:	177e                	slli	a4,a4,0x3f
    80002ea8:	8d59                	or	a0,a0,a4
    80002eaa:	9782                	jalr	a5
}
    80002eac:	60a2                	ld	ra,8(sp)
    80002eae:	6402                	ld	s0,0(sp)
    80002eb0:	0141                	addi	sp,sp,16
    80002eb2:	8082                	ret

0000000080002eb4 <clockintr>:
    w_sepc(sepc);
    w_sstatus(sstatus);
}

void clockintr()
{
    80002eb4:	1101                	addi	sp,sp,-32
    80002eb6:	ec06                	sd	ra,24(sp)
    80002eb8:	e822                	sd	s0,16(sp)
    80002eba:	e426                	sd	s1,8(sp)
    80002ebc:	1000                	addi	s0,sp,32
    acquire(&tickslock);
    80002ebe:	00017497          	auipc	s1,0x17
    80002ec2:	07a48493          	addi	s1,s1,122 # 80019f38 <tickslock>
    80002ec6:	8526                	mv	a0,s1
    80002ec8:	ffffe097          	auipc	ra,0xffffe
    80002ecc:	d70080e7          	jalr	-656(ra) # 80000c38 <acquire>
    ticks++;
    80002ed0:	00008517          	auipc	a0,0x8
    80002ed4:	78050513          	addi	a0,a0,1920 # 8000b650 <ticks>
    80002ed8:	411c                	lw	a5,0(a0)
    80002eda:	2785                	addiw	a5,a5,1
    80002edc:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80002ede:	00000097          	auipc	ra,0x0
    80002ee2:	87a080e7          	jalr	-1926(ra) # 80002758 <wakeup>
    release(&tickslock);
    80002ee6:	8526                	mv	a0,s1
    80002ee8:	ffffe097          	auipc	ra,0xffffe
    80002eec:	e04080e7          	jalr	-508(ra) # 80000cec <release>
}
    80002ef0:	60e2                	ld	ra,24(sp)
    80002ef2:	6442                	ld	s0,16(sp)
    80002ef4:	64a2                	ld	s1,8(sp)
    80002ef6:	6105                	addi	sp,sp,32
    80002ef8:	8082                	ret

0000000080002efa <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002efa:	142027f3          	csrr	a5,scause

        return 2;
    }
    else
    {
        return 0;
    80002efe:	4501                	li	a0,0
    if ((scause & 0x8000000000000000L) &&
    80002f00:	0a07d163          	bgez	a5,80002fa2 <devintr+0xa8>
{
    80002f04:	1101                	addi	sp,sp,-32
    80002f06:	ec06                	sd	ra,24(sp)
    80002f08:	e822                	sd	s0,16(sp)
    80002f0a:	1000                	addi	s0,sp,32
        (scause & 0xff) == 9)
    80002f0c:	0ff7f713          	zext.b	a4,a5
    if ((scause & 0x8000000000000000L) &&
    80002f10:	46a5                	li	a3,9
    80002f12:	00d70c63          	beq	a4,a3,80002f2a <devintr+0x30>
    else if (scause == 0x8000000000000001L)
    80002f16:	577d                	li	a4,-1
    80002f18:	177e                	slli	a4,a4,0x3f
    80002f1a:	0705                	addi	a4,a4,1
        return 0;
    80002f1c:	4501                	li	a0,0
    else if (scause == 0x8000000000000001L)
    80002f1e:	06e78163          	beq	a5,a4,80002f80 <devintr+0x86>
    }
}
    80002f22:	60e2                	ld	ra,24(sp)
    80002f24:	6442                	ld	s0,16(sp)
    80002f26:	6105                	addi	sp,sp,32
    80002f28:	8082                	ret
    80002f2a:	e426                	sd	s1,8(sp)
        int irq = plic_claim();
    80002f2c:	00003097          	auipc	ra,0x3
    80002f30:	660080e7          	jalr	1632(ra) # 8000658c <plic_claim>
    80002f34:	84aa                	mv	s1,a0
        if (irq == UART0_IRQ)
    80002f36:	47a9                	li	a5,10
    80002f38:	00f50963          	beq	a0,a5,80002f4a <devintr+0x50>
        else if (irq == VIRTIO0_IRQ)
    80002f3c:	4785                	li	a5,1
    80002f3e:	00f50b63          	beq	a0,a5,80002f54 <devintr+0x5a>
        return 1;
    80002f42:	4505                	li	a0,1
        else if (irq)
    80002f44:	ec89                	bnez	s1,80002f5e <devintr+0x64>
    80002f46:	64a2                	ld	s1,8(sp)
    80002f48:	bfe9                	j	80002f22 <devintr+0x28>
            uartintr();
    80002f4a:	ffffe097          	auipc	ra,0xffffe
    80002f4e:	ab0080e7          	jalr	-1360(ra) # 800009fa <uartintr>
        if (irq)
    80002f52:	a839                	j	80002f70 <devintr+0x76>
            virtio_disk_intr();
    80002f54:	00004097          	auipc	ra,0x4
    80002f58:	b62080e7          	jalr	-1182(ra) # 80006ab6 <virtio_disk_intr>
        if (irq)
    80002f5c:	a811                	j	80002f70 <devintr+0x76>
            printf("unexpected interrupt irq=%d\n", irq);
    80002f5e:	85a6                	mv	a1,s1
    80002f60:	00005517          	auipc	a0,0x5
    80002f64:	43850513          	addi	a0,a0,1080 # 80008398 <etext+0x398>
    80002f68:	ffffd097          	auipc	ra,0xffffd
    80002f6c:	642080e7          	jalr	1602(ra) # 800005aa <printf>
            plic_complete(irq);
    80002f70:	8526                	mv	a0,s1
    80002f72:	00003097          	auipc	ra,0x3
    80002f76:	63e080e7          	jalr	1598(ra) # 800065b0 <plic_complete>
        return 1;
    80002f7a:	4505                	li	a0,1
    80002f7c:	64a2                	ld	s1,8(sp)
    80002f7e:	b755                	j	80002f22 <devintr+0x28>
        if (cpuid() == 0)
    80002f80:	fffff097          	auipc	ra,0xfffff
    80002f84:	abc080e7          	jalr	-1348(ra) # 80001a3c <cpuid>
    80002f88:	c901                	beqz	a0,80002f98 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002f8a:	144027f3          	csrr	a5,sip
        w_sip(r_sip() & ~2);
    80002f8e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002f90:	14479073          	csrw	sip,a5
        return 2;
    80002f94:	4509                	li	a0,2
    80002f96:	b771                	j	80002f22 <devintr+0x28>
            clockintr();
    80002f98:	00000097          	auipc	ra,0x0
    80002f9c:	f1c080e7          	jalr	-228(ra) # 80002eb4 <clockintr>
    80002fa0:	b7ed                	j	80002f8a <devintr+0x90>
}
    80002fa2:	8082                	ret

0000000080002fa4 <usertrap>:
{
    80002fa4:	1101                	addi	sp,sp,-32
    80002fa6:	ec06                	sd	ra,24(sp)
    80002fa8:	e822                	sd	s0,16(sp)
    80002faa:	e426                	sd	s1,8(sp)
    80002fac:	e04a                	sd	s2,0(sp)
    80002fae:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002fb0:	100027f3          	csrr	a5,sstatus
    if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002fb4:	1007f793          	andi	a5,a5,256
    80002fb8:	e3b1                	bnez	a5,80002ffc <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002fba:	00003797          	auipc	a5,0x3
    80002fbe:	4c678793          	addi	a5,a5,1222 # 80006480 <kernelvec>
    80002fc2:	10579073          	csrw	stvec,a5
    struct proc *p = myproc();
    80002fc6:	fffff097          	auipc	ra,0xfffff
    80002fca:	aa2080e7          	jalr	-1374(ra) # 80001a68 <myproc>
    80002fce:	84aa                	mv	s1,a0
    p->trapframe->epc = r_sepc();
    80002fd0:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002fd2:	14102773          	csrr	a4,sepc
    80002fd6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002fd8:	14202773          	csrr	a4,scause
    if (r_scause() == 8)
    80002fdc:	47a1                	li	a5,8
    80002fde:	02f70763          	beq	a4,a5,8000300c <usertrap+0x68>
    else if ((which_dev = devintr()) != 0)
    80002fe2:	00000097          	auipc	ra,0x0
    80002fe6:	f18080e7          	jalr	-232(ra) # 80002efa <devintr>
    80002fea:	892a                	mv	s2,a0
    80002fec:	c151                	beqz	a0,80003070 <usertrap+0xcc>
    if (killed(p))
    80002fee:	8526                	mv	a0,s1
    80002ff0:	00000097          	auipc	ra,0x0
    80002ff4:	9ac080e7          	jalr	-1620(ra) # 8000299c <killed>
    80002ff8:	c929                	beqz	a0,8000304a <usertrap+0xa6>
    80002ffa:	a099                	j	80003040 <usertrap+0x9c>
        panic("usertrap: not from user mode");
    80002ffc:	00005517          	auipc	a0,0x5
    80003000:	3bc50513          	addi	a0,a0,956 # 800083b8 <etext+0x3b8>
    80003004:	ffffd097          	auipc	ra,0xffffd
    80003008:	55c080e7          	jalr	1372(ra) # 80000560 <panic>
        if (killed(p))
    8000300c:	00000097          	auipc	ra,0x0
    80003010:	990080e7          	jalr	-1648(ra) # 8000299c <killed>
    80003014:	e921                	bnez	a0,80003064 <usertrap+0xc0>
        p->trapframe->epc += 4;
    80003016:	70b8                	ld	a4,96(s1)
    80003018:	6f1c                	ld	a5,24(a4)
    8000301a:	0791                	addi	a5,a5,4
    8000301c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000301e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80003022:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003026:	10079073          	csrw	sstatus,a5
        syscall();
    8000302a:	00000097          	auipc	ra,0x0
    8000302e:	2d8080e7          	jalr	728(ra) # 80003302 <syscall>
    if (killed(p))
    80003032:	8526                	mv	a0,s1
    80003034:	00000097          	auipc	ra,0x0
    80003038:	968080e7          	jalr	-1688(ra) # 8000299c <killed>
    8000303c:	c911                	beqz	a0,80003050 <usertrap+0xac>
    8000303e:	4901                	li	s2,0
        exit(-1);
    80003040:	557d                	li	a0,-1
    80003042:	fffff097          	auipc	ra,0xfffff
    80003046:	7e6080e7          	jalr	2022(ra) # 80002828 <exit>
    if (which_dev == 2)
    8000304a:	4789                	li	a5,2
    8000304c:	04f90f63          	beq	s2,a5,800030aa <usertrap+0x106>
    usertrapret();
    80003050:	00000097          	auipc	ra,0x0
    80003054:	dce080e7          	jalr	-562(ra) # 80002e1e <usertrapret>
}
    80003058:	60e2                	ld	ra,24(sp)
    8000305a:	6442                	ld	s0,16(sp)
    8000305c:	64a2                	ld	s1,8(sp)
    8000305e:	6902                	ld	s2,0(sp)
    80003060:	6105                	addi	sp,sp,32
    80003062:	8082                	ret
            exit(-1);
    80003064:	557d                	li	a0,-1
    80003066:	fffff097          	auipc	ra,0xfffff
    8000306a:	7c2080e7          	jalr	1986(ra) # 80002828 <exit>
    8000306e:	b765                	j	80003016 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003070:	142025f3          	csrr	a1,scause
        printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80003074:	5890                	lw	a2,48(s1)
    80003076:	00005517          	auipc	a0,0x5
    8000307a:	36250513          	addi	a0,a0,866 # 800083d8 <etext+0x3d8>
    8000307e:	ffffd097          	auipc	ra,0xffffd
    80003082:	52c080e7          	jalr	1324(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003086:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000308a:	14302673          	csrr	a2,stval
        printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    8000308e:	00005517          	auipc	a0,0x5
    80003092:	37a50513          	addi	a0,a0,890 # 80008408 <etext+0x408>
    80003096:	ffffd097          	auipc	ra,0xffffd
    8000309a:	514080e7          	jalr	1300(ra) # 800005aa <printf>
        setkilled(p);
    8000309e:	8526                	mv	a0,s1
    800030a0:	00000097          	auipc	ra,0x0
    800030a4:	8d0080e7          	jalr	-1840(ra) # 80002970 <setkilled>
    800030a8:	b769                	j	80003032 <usertrap+0x8e>
        yield(YIELD_TIMER);
    800030aa:	4505                	li	a0,1
    800030ac:	fffff097          	auipc	ra,0xfffff
    800030b0:	586080e7          	jalr	1414(ra) # 80002632 <yield>
    800030b4:	bf71                	j	80003050 <usertrap+0xac>

00000000800030b6 <kerneltrap>:
{
    800030b6:	7179                	addi	sp,sp,-48
    800030b8:	f406                	sd	ra,40(sp)
    800030ba:	f022                	sd	s0,32(sp)
    800030bc:	ec26                	sd	s1,24(sp)
    800030be:	e84a                	sd	s2,16(sp)
    800030c0:	e44e                	sd	s3,8(sp)
    800030c2:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800030c4:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800030c8:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800030cc:	142029f3          	csrr	s3,scause
    if ((sstatus & SSTATUS_SPP) == 0)
    800030d0:	1004f793          	andi	a5,s1,256
    800030d4:	cb85                	beqz	a5,80003104 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800030d6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800030da:	8b89                	andi	a5,a5,2
    if (intr_get() != 0)
    800030dc:	ef85                	bnez	a5,80003114 <kerneltrap+0x5e>
    if ((which_dev = devintr()) == 0)
    800030de:	00000097          	auipc	ra,0x0
    800030e2:	e1c080e7          	jalr	-484(ra) # 80002efa <devintr>
    800030e6:	cd1d                	beqz	a0,80003124 <kerneltrap+0x6e>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800030e8:	4789                	li	a5,2
    800030ea:	06f50a63          	beq	a0,a5,8000315e <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800030ee:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800030f2:	10049073          	csrw	sstatus,s1
}
    800030f6:	70a2                	ld	ra,40(sp)
    800030f8:	7402                	ld	s0,32(sp)
    800030fa:	64e2                	ld	s1,24(sp)
    800030fc:	6942                	ld	s2,16(sp)
    800030fe:	69a2                	ld	s3,8(sp)
    80003100:	6145                	addi	sp,sp,48
    80003102:	8082                	ret
        panic("kerneltrap: not from supervisor mode");
    80003104:	00005517          	auipc	a0,0x5
    80003108:	32450513          	addi	a0,a0,804 # 80008428 <etext+0x428>
    8000310c:	ffffd097          	auipc	ra,0xffffd
    80003110:	454080e7          	jalr	1108(ra) # 80000560 <panic>
        panic("kerneltrap: interrupts enabled");
    80003114:	00005517          	auipc	a0,0x5
    80003118:	33c50513          	addi	a0,a0,828 # 80008450 <etext+0x450>
    8000311c:	ffffd097          	auipc	ra,0xffffd
    80003120:	444080e7          	jalr	1092(ra) # 80000560 <panic>
        printf("scause %p\n", scause);
    80003124:	85ce                	mv	a1,s3
    80003126:	00005517          	auipc	a0,0x5
    8000312a:	34a50513          	addi	a0,a0,842 # 80008470 <etext+0x470>
    8000312e:	ffffd097          	auipc	ra,0xffffd
    80003132:	47c080e7          	jalr	1148(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003136:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000313a:	14302673          	csrr	a2,stval
        printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    8000313e:	00005517          	auipc	a0,0x5
    80003142:	34250513          	addi	a0,a0,834 # 80008480 <etext+0x480>
    80003146:	ffffd097          	auipc	ra,0xffffd
    8000314a:	464080e7          	jalr	1124(ra) # 800005aa <printf>
        panic("kerneltrap");
    8000314e:	00005517          	auipc	a0,0x5
    80003152:	34a50513          	addi	a0,a0,842 # 80008498 <etext+0x498>
    80003156:	ffffd097          	auipc	ra,0xffffd
    8000315a:	40a080e7          	jalr	1034(ra) # 80000560 <panic>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000315e:	fffff097          	auipc	ra,0xfffff
    80003162:	90a080e7          	jalr	-1782(ra) # 80001a68 <myproc>
    80003166:	d541                	beqz	a0,800030ee <kerneltrap+0x38>
    80003168:	fffff097          	auipc	ra,0xfffff
    8000316c:	900080e7          	jalr	-1792(ra) # 80001a68 <myproc>
    80003170:	4d18                	lw	a4,24(a0)
    80003172:	4791                	li	a5,4
    80003174:	f6f71de3          	bne	a4,a5,800030ee <kerneltrap+0x38>
        yield(YIELD_OTHER);
    80003178:	4509                	li	a0,2
    8000317a:	fffff097          	auipc	ra,0xfffff
    8000317e:	4b8080e7          	jalr	1208(ra) # 80002632 <yield>
    80003182:	b7b5                	j	800030ee <kerneltrap+0x38>

0000000080003184 <argraw>:
    return strlen(buf);
}

static uint64
argraw(int n)
{
    80003184:	1101                	addi	sp,sp,-32
    80003186:	ec06                	sd	ra,24(sp)
    80003188:	e822                	sd	s0,16(sp)
    8000318a:	e426                	sd	s1,8(sp)
    8000318c:	1000                	addi	s0,sp,32
    8000318e:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    80003190:	fffff097          	auipc	ra,0xfffff
    80003194:	8d8080e7          	jalr	-1832(ra) # 80001a68 <myproc>
    switch (n)
    80003198:	4795                	li	a5,5
    8000319a:	0497e163          	bltu	a5,s1,800031dc <argraw+0x58>
    8000319e:	048a                	slli	s1,s1,0x2
    800031a0:	00005717          	auipc	a4,0x5
    800031a4:	6e870713          	addi	a4,a4,1768 # 80008888 <states.0+0x30>
    800031a8:	94ba                	add	s1,s1,a4
    800031aa:	409c                	lw	a5,0(s1)
    800031ac:	97ba                	add	a5,a5,a4
    800031ae:	8782                	jr	a5
    {
    case 0:
        return p->trapframe->a0;
    800031b0:	713c                	ld	a5,96(a0)
    800031b2:	7ba8                	ld	a0,112(a5)
    case 5:
        return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
}
    800031b4:	60e2                	ld	ra,24(sp)
    800031b6:	6442                	ld	s0,16(sp)
    800031b8:	64a2                	ld	s1,8(sp)
    800031ba:	6105                	addi	sp,sp,32
    800031bc:	8082                	ret
        return p->trapframe->a1;
    800031be:	713c                	ld	a5,96(a0)
    800031c0:	7fa8                	ld	a0,120(a5)
    800031c2:	bfcd                	j	800031b4 <argraw+0x30>
        return p->trapframe->a2;
    800031c4:	713c                	ld	a5,96(a0)
    800031c6:	63c8                	ld	a0,128(a5)
    800031c8:	b7f5                	j	800031b4 <argraw+0x30>
        return p->trapframe->a3;
    800031ca:	713c                	ld	a5,96(a0)
    800031cc:	67c8                	ld	a0,136(a5)
    800031ce:	b7dd                	j	800031b4 <argraw+0x30>
        return p->trapframe->a4;
    800031d0:	713c                	ld	a5,96(a0)
    800031d2:	6bc8                	ld	a0,144(a5)
    800031d4:	b7c5                	j	800031b4 <argraw+0x30>
        return p->trapframe->a5;
    800031d6:	713c                	ld	a5,96(a0)
    800031d8:	6fc8                	ld	a0,152(a5)
    800031da:	bfe9                	j	800031b4 <argraw+0x30>
    panic("argraw");
    800031dc:	00005517          	auipc	a0,0x5
    800031e0:	2cc50513          	addi	a0,a0,716 # 800084a8 <etext+0x4a8>
    800031e4:	ffffd097          	auipc	ra,0xffffd
    800031e8:	37c080e7          	jalr	892(ra) # 80000560 <panic>

00000000800031ec <fetchaddr>:
{
    800031ec:	1101                	addi	sp,sp,-32
    800031ee:	ec06                	sd	ra,24(sp)
    800031f0:	e822                	sd	s0,16(sp)
    800031f2:	e426                	sd	s1,8(sp)
    800031f4:	e04a                	sd	s2,0(sp)
    800031f6:	1000                	addi	s0,sp,32
    800031f8:	84aa                	mv	s1,a0
    800031fa:	892e                	mv	s2,a1
    struct proc *p = myproc();
    800031fc:	fffff097          	auipc	ra,0xfffff
    80003200:	86c080e7          	jalr	-1940(ra) # 80001a68 <myproc>
    if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80003204:	693c                	ld	a5,80(a0)
    80003206:	02f4f863          	bgeu	s1,a5,80003236 <fetchaddr+0x4a>
    8000320a:	00848713          	addi	a4,s1,8
    8000320e:	02e7e663          	bltu	a5,a4,8000323a <fetchaddr+0x4e>
    if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80003212:	46a1                	li	a3,8
    80003214:	8626                	mv	a2,s1
    80003216:	85ca                	mv	a1,s2
    80003218:	6d28                	ld	a0,88(a0)
    8000321a:	ffffe097          	auipc	ra,0xffffe
    8000321e:	554080e7          	jalr	1364(ra) # 8000176e <copyin>
    80003222:	00a03533          	snez	a0,a0
    80003226:	40a00533          	neg	a0,a0
}
    8000322a:	60e2                	ld	ra,24(sp)
    8000322c:	6442                	ld	s0,16(sp)
    8000322e:	64a2                	ld	s1,8(sp)
    80003230:	6902                	ld	s2,0(sp)
    80003232:	6105                	addi	sp,sp,32
    80003234:	8082                	ret
        return -1;
    80003236:	557d                	li	a0,-1
    80003238:	bfcd                	j	8000322a <fetchaddr+0x3e>
    8000323a:	557d                	li	a0,-1
    8000323c:	b7fd                	j	8000322a <fetchaddr+0x3e>

000000008000323e <fetchstr>:
{
    8000323e:	7179                	addi	sp,sp,-48
    80003240:	f406                	sd	ra,40(sp)
    80003242:	f022                	sd	s0,32(sp)
    80003244:	ec26                	sd	s1,24(sp)
    80003246:	e84a                	sd	s2,16(sp)
    80003248:	e44e                	sd	s3,8(sp)
    8000324a:	1800                	addi	s0,sp,48
    8000324c:	892a                	mv	s2,a0
    8000324e:	84ae                	mv	s1,a1
    80003250:	89b2                	mv	s3,a2
    struct proc *p = myproc();
    80003252:	fffff097          	auipc	ra,0xfffff
    80003256:	816080e7          	jalr	-2026(ra) # 80001a68 <myproc>
    if (copyinstr(p->pagetable, buf, addr, max) < 0)
    8000325a:	86ce                	mv	a3,s3
    8000325c:	864a                	mv	a2,s2
    8000325e:	85a6                	mv	a1,s1
    80003260:	6d28                	ld	a0,88(a0)
    80003262:	ffffe097          	auipc	ra,0xffffe
    80003266:	59a080e7          	jalr	1434(ra) # 800017fc <copyinstr>
    8000326a:	00054e63          	bltz	a0,80003286 <fetchstr+0x48>
    return strlen(buf);
    8000326e:	8526                	mv	a0,s1
    80003270:	ffffe097          	auipc	ra,0xffffe
    80003274:	c38080e7          	jalr	-968(ra) # 80000ea8 <strlen>
}
    80003278:	70a2                	ld	ra,40(sp)
    8000327a:	7402                	ld	s0,32(sp)
    8000327c:	64e2                	ld	s1,24(sp)
    8000327e:	6942                	ld	s2,16(sp)
    80003280:	69a2                	ld	s3,8(sp)
    80003282:	6145                	addi	sp,sp,48
    80003284:	8082                	ret
        return -1;
    80003286:	557d                	li	a0,-1
    80003288:	bfc5                	j	80003278 <fetchstr+0x3a>

000000008000328a <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip)
{
    8000328a:	1101                	addi	sp,sp,-32
    8000328c:	ec06                	sd	ra,24(sp)
    8000328e:	e822                	sd	s0,16(sp)
    80003290:	e426                	sd	s1,8(sp)
    80003292:	1000                	addi	s0,sp,32
    80003294:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80003296:	00000097          	auipc	ra,0x0
    8000329a:	eee080e7          	jalr	-274(ra) # 80003184 <argraw>
    8000329e:	c088                	sw	a0,0(s1)
}
    800032a0:	60e2                	ld	ra,24(sp)
    800032a2:	6442                	ld	s0,16(sp)
    800032a4:	64a2                	ld	s1,8(sp)
    800032a6:	6105                	addi	sp,sp,32
    800032a8:	8082                	ret

00000000800032aa <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip)
{
    800032aa:	1101                	addi	sp,sp,-32
    800032ac:	ec06                	sd	ra,24(sp)
    800032ae:	e822                	sd	s0,16(sp)
    800032b0:	e426                	sd	s1,8(sp)
    800032b2:	1000                	addi	s0,sp,32
    800032b4:	84ae                	mv	s1,a1
    *ip = argraw(n);
    800032b6:	00000097          	auipc	ra,0x0
    800032ba:	ece080e7          	jalr	-306(ra) # 80003184 <argraw>
    800032be:	e088                	sd	a0,0(s1)
}
    800032c0:	60e2                	ld	ra,24(sp)
    800032c2:	6442                	ld	s0,16(sp)
    800032c4:	64a2                	ld	s1,8(sp)
    800032c6:	6105                	addi	sp,sp,32
    800032c8:	8082                	ret

00000000800032ca <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    800032ca:	7179                	addi	sp,sp,-48
    800032cc:	f406                	sd	ra,40(sp)
    800032ce:	f022                	sd	s0,32(sp)
    800032d0:	ec26                	sd	s1,24(sp)
    800032d2:	e84a                	sd	s2,16(sp)
    800032d4:	1800                	addi	s0,sp,48
    800032d6:	84ae                	mv	s1,a1
    800032d8:	8932                	mv	s2,a2
    uint64 addr;
    argaddr(n, &addr);
    800032da:	fd840593          	addi	a1,s0,-40
    800032de:	00000097          	auipc	ra,0x0
    800032e2:	fcc080e7          	jalr	-52(ra) # 800032aa <argaddr>
    return fetchstr(addr, buf, max);
    800032e6:	864a                	mv	a2,s2
    800032e8:	85a6                	mv	a1,s1
    800032ea:	fd843503          	ld	a0,-40(s0)
    800032ee:	00000097          	auipc	ra,0x0
    800032f2:	f50080e7          	jalr	-176(ra) # 8000323e <fetchstr>
}
    800032f6:	70a2                	ld	ra,40(sp)
    800032f8:	7402                	ld	s0,32(sp)
    800032fa:	64e2                	ld	s1,24(sp)
    800032fc:	6942                	ld	s2,16(sp)
    800032fe:	6145                	addi	sp,sp,48
    80003300:	8082                	ret

0000000080003302 <syscall>:
    [SYS_yield] sys_yield,
    [SYS_getprio] sys_getprio,
};

void syscall(void)
{
    80003302:	1101                	addi	sp,sp,-32
    80003304:	ec06                	sd	ra,24(sp)
    80003306:	e822                	sd	s0,16(sp)
    80003308:	e426                	sd	s1,8(sp)
    8000330a:	e04a                	sd	s2,0(sp)
    8000330c:	1000                	addi	s0,sp,32
    int num;
    struct proc *p = myproc();
    8000330e:	ffffe097          	auipc	ra,0xffffe
    80003312:	75a080e7          	jalr	1882(ra) # 80001a68 <myproc>
    80003316:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    80003318:	06053903          	ld	s2,96(a0)
    8000331c:	0a893783          	ld	a5,168(s2)
    80003320:	0007869b          	sext.w	a3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    80003324:	37fd                	addiw	a5,a5,-1
    80003326:	4765                	li	a4,25
    80003328:	00f76f63          	bltu	a4,a5,80003346 <syscall+0x44>
    8000332c:	00369713          	slli	a4,a3,0x3
    80003330:	00005797          	auipc	a5,0x5
    80003334:	57078793          	addi	a5,a5,1392 # 800088a0 <syscalls>
    80003338:	97ba                	add	a5,a5,a4
    8000333a:	639c                	ld	a5,0(a5)
    8000333c:	c789                	beqz	a5,80003346 <syscall+0x44>
    {
        // Use num to lookup the system call function for num, call it,
        // and store its return value in p->trapframe->a0
        p->trapframe->a0 = syscalls[num]();
    8000333e:	9782                	jalr	a5
    80003340:	06a93823          	sd	a0,112(s2)
    80003344:	a839                	j	80003362 <syscall+0x60>
    }
    else
    {
        printf("%d %s: unknown sys call %d\n",
    80003346:	16048613          	addi	a2,s1,352
    8000334a:	588c                	lw	a1,48(s1)
    8000334c:	00005517          	auipc	a0,0x5
    80003350:	16450513          	addi	a0,a0,356 # 800084b0 <etext+0x4b0>
    80003354:	ffffd097          	auipc	ra,0xffffd
    80003358:	256080e7          	jalr	598(ra) # 800005aa <printf>
               p->pid, p->name, num);
        p->trapframe->a0 = -1;
    8000335c:	70bc                	ld	a5,96(s1)
    8000335e:	577d                	li	a4,-1
    80003360:	fbb8                	sd	a4,112(a5)
    }
}
    80003362:	60e2                	ld	ra,24(sp)
    80003364:	6442                	ld	s0,16(sp)
    80003366:	64a2                	ld	s1,8(sp)
    80003368:	6902                	ld	s2,0(sp)
    8000336a:	6105                	addi	sp,sp,32
    8000336c:	8082                	ret

000000008000336e <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000336e:	1101                	addi	sp,sp,-32
    80003370:	ec06                	sd	ra,24(sp)
    80003372:	e822                	sd	s0,16(sp)
    80003374:	1000                	addi	s0,sp,32
    int n;
    argint(0, &n);
    80003376:	fec40593          	addi	a1,s0,-20
    8000337a:	4501                	li	a0,0
    8000337c:	00000097          	auipc	ra,0x0
    80003380:	f0e080e7          	jalr	-242(ra) # 8000328a <argint>
    exit(n);
    80003384:	fec42503          	lw	a0,-20(s0)
    80003388:	fffff097          	auipc	ra,0xfffff
    8000338c:	4a0080e7          	jalr	1184(ra) # 80002828 <exit>
    return 0; // not reached
}
    80003390:	4501                	li	a0,0
    80003392:	60e2                	ld	ra,24(sp)
    80003394:	6442                	ld	s0,16(sp)
    80003396:	6105                	addi	sp,sp,32
    80003398:	8082                	ret

000000008000339a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000339a:	1141                	addi	sp,sp,-16
    8000339c:	e406                	sd	ra,8(sp)
    8000339e:	e022                	sd	s0,0(sp)
    800033a0:	0800                	addi	s0,sp,16
    return myproc()->pid;
    800033a2:	ffffe097          	auipc	ra,0xffffe
    800033a6:	6c6080e7          	jalr	1734(ra) # 80001a68 <myproc>
}
    800033aa:	5908                	lw	a0,48(a0)
    800033ac:	60a2                	ld	ra,8(sp)
    800033ae:	6402                	ld	s0,0(sp)
    800033b0:	0141                	addi	sp,sp,16
    800033b2:	8082                	ret

00000000800033b4 <sys_fork>:

uint64
sys_fork(void)
{
    800033b4:	1141                	addi	sp,sp,-16
    800033b6:	e406                	sd	ra,8(sp)
    800033b8:	e022                	sd	s0,0(sp)
    800033ba:	0800                	addi	s0,sp,16
    return fork();
    800033bc:	fffff097          	auipc	ra,0xfffff
    800033c0:	e48080e7          	jalr	-440(ra) # 80002204 <fork>
}
    800033c4:	60a2                	ld	ra,8(sp)
    800033c6:	6402                	ld	s0,0(sp)
    800033c8:	0141                	addi	sp,sp,16
    800033ca:	8082                	ret

00000000800033cc <sys_wait>:

uint64
sys_wait(void)
{
    800033cc:	1101                	addi	sp,sp,-32
    800033ce:	ec06                	sd	ra,24(sp)
    800033d0:	e822                	sd	s0,16(sp)
    800033d2:	1000                	addi	s0,sp,32
    uint64 p;
    argaddr(0, &p);
    800033d4:	fe840593          	addi	a1,s0,-24
    800033d8:	4501                	li	a0,0
    800033da:	00000097          	auipc	ra,0x0
    800033de:	ed0080e7          	jalr	-304(ra) # 800032aa <argaddr>
    return wait(p);
    800033e2:	fe843503          	ld	a0,-24(s0)
    800033e6:	fffff097          	auipc	ra,0xfffff
    800033ea:	5e8080e7          	jalr	1512(ra) # 800029ce <wait>
}
    800033ee:	60e2                	ld	ra,24(sp)
    800033f0:	6442                	ld	s0,16(sp)
    800033f2:	6105                	addi	sp,sp,32
    800033f4:	8082                	ret

00000000800033f6 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800033f6:	7179                	addi	sp,sp,-48
    800033f8:	f406                	sd	ra,40(sp)
    800033fa:	f022                	sd	s0,32(sp)
    800033fc:	ec26                	sd	s1,24(sp)
    800033fe:	1800                	addi	s0,sp,48
    uint64 addr;
    int n;

    argint(0, &n);
    80003400:	fdc40593          	addi	a1,s0,-36
    80003404:	4501                	li	a0,0
    80003406:	00000097          	auipc	ra,0x0
    8000340a:	e84080e7          	jalr	-380(ra) # 8000328a <argint>
    addr = myproc()->sz;
    8000340e:	ffffe097          	auipc	ra,0xffffe
    80003412:	65a080e7          	jalr	1626(ra) # 80001a68 <myproc>
    80003416:	6924                	ld	s1,80(a0)
    if (growproc(n) < 0)
    80003418:	fdc42503          	lw	a0,-36(s0)
    8000341c:	fffff097          	auipc	ra,0xfffff
    80003420:	92c080e7          	jalr	-1748(ra) # 80001d48 <growproc>
    80003424:	00054863          	bltz	a0,80003434 <sys_sbrk+0x3e>
        return -1;
    return addr;
}
    80003428:	8526                	mv	a0,s1
    8000342a:	70a2                	ld	ra,40(sp)
    8000342c:	7402                	ld	s0,32(sp)
    8000342e:	64e2                	ld	s1,24(sp)
    80003430:	6145                	addi	sp,sp,48
    80003432:	8082                	ret
        return -1;
    80003434:	54fd                	li	s1,-1
    80003436:	bfcd                	j	80003428 <sys_sbrk+0x32>

0000000080003438 <sys_sleep>:

uint64
sys_sleep(void)
{
    80003438:	7139                	addi	sp,sp,-64
    8000343a:	fc06                	sd	ra,56(sp)
    8000343c:	f822                	sd	s0,48(sp)
    8000343e:	f04a                	sd	s2,32(sp)
    80003440:	0080                	addi	s0,sp,64
    int n;
    uint ticks0;

    argint(0, &n);
    80003442:	fcc40593          	addi	a1,s0,-52
    80003446:	4501                	li	a0,0
    80003448:	00000097          	auipc	ra,0x0
    8000344c:	e42080e7          	jalr	-446(ra) # 8000328a <argint>
    acquire(&tickslock);
    80003450:	00017517          	auipc	a0,0x17
    80003454:	ae850513          	addi	a0,a0,-1304 # 80019f38 <tickslock>
    80003458:	ffffd097          	auipc	ra,0xffffd
    8000345c:	7e0080e7          	jalr	2016(ra) # 80000c38 <acquire>
    ticks0 = ticks;
    80003460:	00008917          	auipc	s2,0x8
    80003464:	1f092903          	lw	s2,496(s2) # 8000b650 <ticks>
    while (ticks - ticks0 < n)
    80003468:	fcc42783          	lw	a5,-52(s0)
    8000346c:	c3b9                	beqz	a5,800034b2 <sys_sleep+0x7a>
    8000346e:	f426                	sd	s1,40(sp)
    80003470:	ec4e                	sd	s3,24(sp)
        if (killed(myproc()))
        {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
    80003472:	00017997          	auipc	s3,0x17
    80003476:	ac698993          	addi	s3,s3,-1338 # 80019f38 <tickslock>
    8000347a:	00008497          	auipc	s1,0x8
    8000347e:	1d648493          	addi	s1,s1,470 # 8000b650 <ticks>
        if (killed(myproc()))
    80003482:	ffffe097          	auipc	ra,0xffffe
    80003486:	5e6080e7          	jalr	1510(ra) # 80001a68 <myproc>
    8000348a:	fffff097          	auipc	ra,0xfffff
    8000348e:	512080e7          	jalr	1298(ra) # 8000299c <killed>
    80003492:	ed15                	bnez	a0,800034ce <sys_sleep+0x96>
        sleep(&ticks, &tickslock);
    80003494:	85ce                	mv	a1,s3
    80003496:	8526                	mv	a0,s1
    80003498:	fffff097          	auipc	ra,0xfffff
    8000349c:	25c080e7          	jalr	604(ra) # 800026f4 <sleep>
    while (ticks - ticks0 < n)
    800034a0:	409c                	lw	a5,0(s1)
    800034a2:	412787bb          	subw	a5,a5,s2
    800034a6:	fcc42703          	lw	a4,-52(s0)
    800034aa:	fce7ece3          	bltu	a5,a4,80003482 <sys_sleep+0x4a>
    800034ae:	74a2                	ld	s1,40(sp)
    800034b0:	69e2                	ld	s3,24(sp)
    }
    release(&tickslock);
    800034b2:	00017517          	auipc	a0,0x17
    800034b6:	a8650513          	addi	a0,a0,-1402 # 80019f38 <tickslock>
    800034ba:	ffffe097          	auipc	ra,0xffffe
    800034be:	832080e7          	jalr	-1998(ra) # 80000cec <release>
    return 0;
    800034c2:	4501                	li	a0,0
}
    800034c4:	70e2                	ld	ra,56(sp)
    800034c6:	7442                	ld	s0,48(sp)
    800034c8:	7902                	ld	s2,32(sp)
    800034ca:	6121                	addi	sp,sp,64
    800034cc:	8082                	ret
            release(&tickslock);
    800034ce:	00017517          	auipc	a0,0x17
    800034d2:	a6a50513          	addi	a0,a0,-1430 # 80019f38 <tickslock>
    800034d6:	ffffe097          	auipc	ra,0xffffe
    800034da:	816080e7          	jalr	-2026(ra) # 80000cec <release>
            return -1;
    800034de:	557d                	li	a0,-1
    800034e0:	74a2                	ld	s1,40(sp)
    800034e2:	69e2                	ld	s3,24(sp)
    800034e4:	b7c5                	j	800034c4 <sys_sleep+0x8c>

00000000800034e6 <sys_kill>:

uint64
sys_kill(void)
{
    800034e6:	1101                	addi	sp,sp,-32
    800034e8:	ec06                	sd	ra,24(sp)
    800034ea:	e822                	sd	s0,16(sp)
    800034ec:	1000                	addi	s0,sp,32
    int pid;

    argint(0, &pid);
    800034ee:	fec40593          	addi	a1,s0,-20
    800034f2:	4501                	li	a0,0
    800034f4:	00000097          	auipc	ra,0x0
    800034f8:	d96080e7          	jalr	-618(ra) # 8000328a <argint>
    return kill(pid);
    800034fc:	fec42503          	lw	a0,-20(s0)
    80003500:	fffff097          	auipc	ra,0xfffff
    80003504:	3fe080e7          	jalr	1022(ra) # 800028fe <kill>
}
    80003508:	60e2                	ld	ra,24(sp)
    8000350a:	6442                	ld	s0,16(sp)
    8000350c:	6105                	addi	sp,sp,32
    8000350e:	8082                	ret

0000000080003510 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80003510:	1101                	addi	sp,sp,-32
    80003512:	ec06                	sd	ra,24(sp)
    80003514:	e822                	sd	s0,16(sp)
    80003516:	e426                	sd	s1,8(sp)
    80003518:	1000                	addi	s0,sp,32
    uint xticks;

    acquire(&tickslock);
    8000351a:	00017517          	auipc	a0,0x17
    8000351e:	a1e50513          	addi	a0,a0,-1506 # 80019f38 <tickslock>
    80003522:	ffffd097          	auipc	ra,0xffffd
    80003526:	716080e7          	jalr	1814(ra) # 80000c38 <acquire>
    xticks = ticks;
    8000352a:	00008497          	auipc	s1,0x8
    8000352e:	1264a483          	lw	s1,294(s1) # 8000b650 <ticks>
    release(&tickslock);
    80003532:	00017517          	auipc	a0,0x17
    80003536:	a0650513          	addi	a0,a0,-1530 # 80019f38 <tickslock>
    8000353a:	ffffd097          	auipc	ra,0xffffd
    8000353e:	7b2080e7          	jalr	1970(ra) # 80000cec <release>
    return xticks;
}
    80003542:	02049513          	slli	a0,s1,0x20
    80003546:	9101                	srli	a0,a0,0x20
    80003548:	60e2                	ld	ra,24(sp)
    8000354a:	6442                	ld	s0,16(sp)
    8000354c:	64a2                	ld	s1,8(sp)
    8000354e:	6105                	addi	sp,sp,32
    80003550:	8082                	ret

0000000080003552 <sys_ps>:

void *
sys_ps(void)
{
    80003552:	1101                	addi	sp,sp,-32
    80003554:	ec06                	sd	ra,24(sp)
    80003556:	e822                	sd	s0,16(sp)
    80003558:	1000                	addi	s0,sp,32
    int start = 0, count = 0;
    8000355a:	fe042623          	sw	zero,-20(s0)
    8000355e:	fe042423          	sw	zero,-24(s0)
    argint(0, &start);
    80003562:	fec40593          	addi	a1,s0,-20
    80003566:	4501                	li	a0,0
    80003568:	00000097          	auipc	ra,0x0
    8000356c:	d22080e7          	jalr	-734(ra) # 8000328a <argint>
    argint(1, &count);
    80003570:	fe840593          	addi	a1,s0,-24
    80003574:	4505                	li	a0,1
    80003576:	00000097          	auipc	ra,0x0
    8000357a:	d14080e7          	jalr	-748(ra) # 8000328a <argint>
    return ps((uint8)start, (uint8)count);
    8000357e:	fe844583          	lbu	a1,-24(s0)
    80003582:	fec44503          	lbu	a0,-20(s0)
    80003586:	fffff097          	auipc	ra,0xfffff
    8000358a:	81e080e7          	jalr	-2018(ra) # 80001da4 <ps>
}
    8000358e:	60e2                	ld	ra,24(sp)
    80003590:	6442                	ld	s0,16(sp)
    80003592:	6105                	addi	sp,sp,32
    80003594:	8082                	ret

0000000080003596 <sys_schedls>:

uint64 sys_schedls(void)
{
    80003596:	1141                	addi	sp,sp,-16
    80003598:	e406                	sd	ra,8(sp)
    8000359a:	e022                	sd	s0,0(sp)
    8000359c:	0800                	addi	s0,sp,16
    schedls();
    8000359e:	fffff097          	auipc	ra,0xfffff
    800035a2:	6ba080e7          	jalr	1722(ra) # 80002c58 <schedls>
    return 0;
}
    800035a6:	4501                	li	a0,0
    800035a8:	60a2                	ld	ra,8(sp)
    800035aa:	6402                	ld	s0,0(sp)
    800035ac:	0141                	addi	sp,sp,16
    800035ae:	8082                	ret

00000000800035b0 <sys_schedset>:

uint64 sys_schedset(void)
{
    800035b0:	1101                	addi	sp,sp,-32
    800035b2:	ec06                	sd	ra,24(sp)
    800035b4:	e822                	sd	s0,16(sp)
    800035b6:	1000                	addi	s0,sp,32
    int id = 0;
    800035b8:	fe042623          	sw	zero,-20(s0)
    argint(0, &id);
    800035bc:	fec40593          	addi	a1,s0,-20
    800035c0:	4501                	li	a0,0
    800035c2:	00000097          	auipc	ra,0x0
    800035c6:	cc8080e7          	jalr	-824(ra) # 8000328a <argint>
    schedset(id - 1);
    800035ca:	fec42503          	lw	a0,-20(s0)
    800035ce:	357d                	addiw	a0,a0,-1
    800035d0:	fffff097          	auipc	ra,0xfffff
    800035d4:	74a080e7          	jalr	1866(ra) # 80002d1a <schedset>
    return 0;
}
    800035d8:	4501                	li	a0,0
    800035da:	60e2                	ld	ra,24(sp)
    800035dc:	6442                	ld	s0,16(sp)
    800035de:	6105                	addi	sp,sp,32
    800035e0:	8082                	ret

00000000800035e2 <sys_yield>:

uint64 sys_yield(void)
{
    800035e2:	1141                	addi	sp,sp,-16
    800035e4:	e406                	sd	ra,8(sp)
    800035e6:	e022                	sd	s0,0(sp)
    800035e8:	0800                	addi	s0,sp,16
    yield(YIELD_OTHER);
    800035ea:	4509                	li	a0,2
    800035ec:	fffff097          	auipc	ra,0xfffff
    800035f0:	046080e7          	jalr	70(ra) # 80002632 <yield>
    return 0;
}
    800035f4:	4501                	li	a0,0
    800035f6:	60a2                	ld	ra,8(sp)
    800035f8:	6402                	ld	s0,0(sp)
    800035fa:	0141                	addi	sp,sp,16
    800035fc:	8082                	ret

00000000800035fe <sys_getprio>:

uint64 sys_getprio(void)
{
    800035fe:	1141                	addi	sp,sp,-16
    80003600:	e406                	sd	ra,8(sp)
    80003602:	e022                	sd	s0,0(sp)
    80003604:	0800                	addi	s0,sp,16
    printf("The priority of the current process is %d\n", myproc()->priority);
    80003606:	ffffe097          	auipc	ra,0xffffe
    8000360a:	462080e7          	jalr	1122(ra) # 80001a68 <myproc>
    8000360e:	594c                	lw	a1,52(a0)
    80003610:	00005517          	auipc	a0,0x5
    80003614:	ec050513          	addi	a0,a0,-320 # 800084d0 <etext+0x4d0>
    80003618:	ffffd097          	auipc	ra,0xffffd
    8000361c:	f92080e7          	jalr	-110(ra) # 800005aa <printf>
    return 0;
    80003620:	4501                	li	a0,0
    80003622:	60a2                	ld	ra,8(sp)
    80003624:	6402                	ld	s0,0(sp)
    80003626:	0141                	addi	sp,sp,16
    80003628:	8082                	ret

000000008000362a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000362a:	7179                	addi	sp,sp,-48
    8000362c:	f406                	sd	ra,40(sp)
    8000362e:	f022                	sd	s0,32(sp)
    80003630:	ec26                	sd	s1,24(sp)
    80003632:	e84a                	sd	s2,16(sp)
    80003634:	e44e                	sd	s3,8(sp)
    80003636:	e052                	sd	s4,0(sp)
    80003638:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000363a:	00005597          	auipc	a1,0x5
    8000363e:	ec658593          	addi	a1,a1,-314 # 80008500 <etext+0x500>
    80003642:	00017517          	auipc	a0,0x17
    80003646:	90e50513          	addi	a0,a0,-1778 # 80019f50 <bcache>
    8000364a:	ffffd097          	auipc	ra,0xffffd
    8000364e:	55e080e7          	jalr	1374(ra) # 80000ba8 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003652:	0001f797          	auipc	a5,0x1f
    80003656:	8fe78793          	addi	a5,a5,-1794 # 80021f50 <bcache+0x8000>
    8000365a:	0001f717          	auipc	a4,0x1f
    8000365e:	b5e70713          	addi	a4,a4,-1186 # 800221b8 <bcache+0x8268>
    80003662:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003666:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000366a:	00017497          	auipc	s1,0x17
    8000366e:	8fe48493          	addi	s1,s1,-1794 # 80019f68 <bcache+0x18>
    b->next = bcache.head.next;
    80003672:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003674:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003676:	00005a17          	auipc	s4,0x5
    8000367a:	e92a0a13          	addi	s4,s4,-366 # 80008508 <etext+0x508>
    b->next = bcache.head.next;
    8000367e:	2b893783          	ld	a5,696(s2)
    80003682:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003684:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003688:	85d2                	mv	a1,s4
    8000368a:	01048513          	addi	a0,s1,16
    8000368e:	00001097          	auipc	ra,0x1
    80003692:	4e8080e7          	jalr	1256(ra) # 80004b76 <initsleeplock>
    bcache.head.next->prev = b;
    80003696:	2b893783          	ld	a5,696(s2)
    8000369a:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000369c:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800036a0:	45848493          	addi	s1,s1,1112
    800036a4:	fd349de3          	bne	s1,s3,8000367e <binit+0x54>
  }
}
    800036a8:	70a2                	ld	ra,40(sp)
    800036aa:	7402                	ld	s0,32(sp)
    800036ac:	64e2                	ld	s1,24(sp)
    800036ae:	6942                	ld	s2,16(sp)
    800036b0:	69a2                	ld	s3,8(sp)
    800036b2:	6a02                	ld	s4,0(sp)
    800036b4:	6145                	addi	sp,sp,48
    800036b6:	8082                	ret

00000000800036b8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800036b8:	7179                	addi	sp,sp,-48
    800036ba:	f406                	sd	ra,40(sp)
    800036bc:	f022                	sd	s0,32(sp)
    800036be:	ec26                	sd	s1,24(sp)
    800036c0:	e84a                	sd	s2,16(sp)
    800036c2:	e44e                	sd	s3,8(sp)
    800036c4:	1800                	addi	s0,sp,48
    800036c6:	892a                	mv	s2,a0
    800036c8:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800036ca:	00017517          	auipc	a0,0x17
    800036ce:	88650513          	addi	a0,a0,-1914 # 80019f50 <bcache>
    800036d2:	ffffd097          	auipc	ra,0xffffd
    800036d6:	566080e7          	jalr	1382(ra) # 80000c38 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800036da:	0001f497          	auipc	s1,0x1f
    800036de:	b2e4b483          	ld	s1,-1234(s1) # 80022208 <bcache+0x82b8>
    800036e2:	0001f797          	auipc	a5,0x1f
    800036e6:	ad678793          	addi	a5,a5,-1322 # 800221b8 <bcache+0x8268>
    800036ea:	02f48f63          	beq	s1,a5,80003728 <bread+0x70>
    800036ee:	873e                	mv	a4,a5
    800036f0:	a021                	j	800036f8 <bread+0x40>
    800036f2:	68a4                	ld	s1,80(s1)
    800036f4:	02e48a63          	beq	s1,a4,80003728 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800036f8:	449c                	lw	a5,8(s1)
    800036fa:	ff279ce3          	bne	a5,s2,800036f2 <bread+0x3a>
    800036fe:	44dc                	lw	a5,12(s1)
    80003700:	ff3799e3          	bne	a5,s3,800036f2 <bread+0x3a>
      b->refcnt++;
    80003704:	40bc                	lw	a5,64(s1)
    80003706:	2785                	addiw	a5,a5,1
    80003708:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000370a:	00017517          	auipc	a0,0x17
    8000370e:	84650513          	addi	a0,a0,-1978 # 80019f50 <bcache>
    80003712:	ffffd097          	auipc	ra,0xffffd
    80003716:	5da080e7          	jalr	1498(ra) # 80000cec <release>
      acquiresleep(&b->lock);
    8000371a:	01048513          	addi	a0,s1,16
    8000371e:	00001097          	auipc	ra,0x1
    80003722:	492080e7          	jalr	1170(ra) # 80004bb0 <acquiresleep>
      return b;
    80003726:	a8b9                	j	80003784 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003728:	0001f497          	auipc	s1,0x1f
    8000372c:	ad84b483          	ld	s1,-1320(s1) # 80022200 <bcache+0x82b0>
    80003730:	0001f797          	auipc	a5,0x1f
    80003734:	a8878793          	addi	a5,a5,-1400 # 800221b8 <bcache+0x8268>
    80003738:	00f48863          	beq	s1,a5,80003748 <bread+0x90>
    8000373c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000373e:	40bc                	lw	a5,64(s1)
    80003740:	cf81                	beqz	a5,80003758 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003742:	64a4                	ld	s1,72(s1)
    80003744:	fee49de3          	bne	s1,a4,8000373e <bread+0x86>
  panic("bget: no buffers");
    80003748:	00005517          	auipc	a0,0x5
    8000374c:	dc850513          	addi	a0,a0,-568 # 80008510 <etext+0x510>
    80003750:	ffffd097          	auipc	ra,0xffffd
    80003754:	e10080e7          	jalr	-496(ra) # 80000560 <panic>
      b->dev = dev;
    80003758:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000375c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003760:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003764:	4785                	li	a5,1
    80003766:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003768:	00016517          	auipc	a0,0x16
    8000376c:	7e850513          	addi	a0,a0,2024 # 80019f50 <bcache>
    80003770:	ffffd097          	auipc	ra,0xffffd
    80003774:	57c080e7          	jalr	1404(ra) # 80000cec <release>
      acquiresleep(&b->lock);
    80003778:	01048513          	addi	a0,s1,16
    8000377c:	00001097          	auipc	ra,0x1
    80003780:	434080e7          	jalr	1076(ra) # 80004bb0 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003784:	409c                	lw	a5,0(s1)
    80003786:	cb89                	beqz	a5,80003798 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003788:	8526                	mv	a0,s1
    8000378a:	70a2                	ld	ra,40(sp)
    8000378c:	7402                	ld	s0,32(sp)
    8000378e:	64e2                	ld	s1,24(sp)
    80003790:	6942                	ld	s2,16(sp)
    80003792:	69a2                	ld	s3,8(sp)
    80003794:	6145                	addi	sp,sp,48
    80003796:	8082                	ret
    virtio_disk_rw(b, 0);
    80003798:	4581                	li	a1,0
    8000379a:	8526                	mv	a0,s1
    8000379c:	00003097          	auipc	ra,0x3
    800037a0:	0ec080e7          	jalr	236(ra) # 80006888 <virtio_disk_rw>
    b->valid = 1;
    800037a4:	4785                	li	a5,1
    800037a6:	c09c                	sw	a5,0(s1)
  return b;
    800037a8:	b7c5                	j	80003788 <bread+0xd0>

00000000800037aa <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800037aa:	1101                	addi	sp,sp,-32
    800037ac:	ec06                	sd	ra,24(sp)
    800037ae:	e822                	sd	s0,16(sp)
    800037b0:	e426                	sd	s1,8(sp)
    800037b2:	1000                	addi	s0,sp,32
    800037b4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800037b6:	0541                	addi	a0,a0,16
    800037b8:	00001097          	auipc	ra,0x1
    800037bc:	492080e7          	jalr	1170(ra) # 80004c4a <holdingsleep>
    800037c0:	cd01                	beqz	a0,800037d8 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800037c2:	4585                	li	a1,1
    800037c4:	8526                	mv	a0,s1
    800037c6:	00003097          	auipc	ra,0x3
    800037ca:	0c2080e7          	jalr	194(ra) # 80006888 <virtio_disk_rw>
}
    800037ce:	60e2                	ld	ra,24(sp)
    800037d0:	6442                	ld	s0,16(sp)
    800037d2:	64a2                	ld	s1,8(sp)
    800037d4:	6105                	addi	sp,sp,32
    800037d6:	8082                	ret
    panic("bwrite");
    800037d8:	00005517          	auipc	a0,0x5
    800037dc:	d5050513          	addi	a0,a0,-688 # 80008528 <etext+0x528>
    800037e0:	ffffd097          	auipc	ra,0xffffd
    800037e4:	d80080e7          	jalr	-640(ra) # 80000560 <panic>

00000000800037e8 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800037e8:	1101                	addi	sp,sp,-32
    800037ea:	ec06                	sd	ra,24(sp)
    800037ec:	e822                	sd	s0,16(sp)
    800037ee:	e426                	sd	s1,8(sp)
    800037f0:	e04a                	sd	s2,0(sp)
    800037f2:	1000                	addi	s0,sp,32
    800037f4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800037f6:	01050913          	addi	s2,a0,16
    800037fa:	854a                	mv	a0,s2
    800037fc:	00001097          	auipc	ra,0x1
    80003800:	44e080e7          	jalr	1102(ra) # 80004c4a <holdingsleep>
    80003804:	c925                	beqz	a0,80003874 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80003806:	854a                	mv	a0,s2
    80003808:	00001097          	auipc	ra,0x1
    8000380c:	3fe080e7          	jalr	1022(ra) # 80004c06 <releasesleep>

  acquire(&bcache.lock);
    80003810:	00016517          	auipc	a0,0x16
    80003814:	74050513          	addi	a0,a0,1856 # 80019f50 <bcache>
    80003818:	ffffd097          	auipc	ra,0xffffd
    8000381c:	420080e7          	jalr	1056(ra) # 80000c38 <acquire>
  b->refcnt--;
    80003820:	40bc                	lw	a5,64(s1)
    80003822:	37fd                	addiw	a5,a5,-1
    80003824:	0007871b          	sext.w	a4,a5
    80003828:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000382a:	e71d                	bnez	a4,80003858 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000382c:	68b8                	ld	a4,80(s1)
    8000382e:	64bc                	ld	a5,72(s1)
    80003830:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003832:	68b8                	ld	a4,80(s1)
    80003834:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003836:	0001e797          	auipc	a5,0x1e
    8000383a:	71a78793          	addi	a5,a5,1818 # 80021f50 <bcache+0x8000>
    8000383e:	2b87b703          	ld	a4,696(a5)
    80003842:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003844:	0001f717          	auipc	a4,0x1f
    80003848:	97470713          	addi	a4,a4,-1676 # 800221b8 <bcache+0x8268>
    8000384c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000384e:	2b87b703          	ld	a4,696(a5)
    80003852:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003854:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003858:	00016517          	auipc	a0,0x16
    8000385c:	6f850513          	addi	a0,a0,1784 # 80019f50 <bcache>
    80003860:	ffffd097          	auipc	ra,0xffffd
    80003864:	48c080e7          	jalr	1164(ra) # 80000cec <release>
}
    80003868:	60e2                	ld	ra,24(sp)
    8000386a:	6442                	ld	s0,16(sp)
    8000386c:	64a2                	ld	s1,8(sp)
    8000386e:	6902                	ld	s2,0(sp)
    80003870:	6105                	addi	sp,sp,32
    80003872:	8082                	ret
    panic("brelse");
    80003874:	00005517          	auipc	a0,0x5
    80003878:	cbc50513          	addi	a0,a0,-836 # 80008530 <etext+0x530>
    8000387c:	ffffd097          	auipc	ra,0xffffd
    80003880:	ce4080e7          	jalr	-796(ra) # 80000560 <panic>

0000000080003884 <bpin>:

void
bpin(struct buf *b) {
    80003884:	1101                	addi	sp,sp,-32
    80003886:	ec06                	sd	ra,24(sp)
    80003888:	e822                	sd	s0,16(sp)
    8000388a:	e426                	sd	s1,8(sp)
    8000388c:	1000                	addi	s0,sp,32
    8000388e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003890:	00016517          	auipc	a0,0x16
    80003894:	6c050513          	addi	a0,a0,1728 # 80019f50 <bcache>
    80003898:	ffffd097          	auipc	ra,0xffffd
    8000389c:	3a0080e7          	jalr	928(ra) # 80000c38 <acquire>
  b->refcnt++;
    800038a0:	40bc                	lw	a5,64(s1)
    800038a2:	2785                	addiw	a5,a5,1
    800038a4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800038a6:	00016517          	auipc	a0,0x16
    800038aa:	6aa50513          	addi	a0,a0,1706 # 80019f50 <bcache>
    800038ae:	ffffd097          	auipc	ra,0xffffd
    800038b2:	43e080e7          	jalr	1086(ra) # 80000cec <release>
}
    800038b6:	60e2                	ld	ra,24(sp)
    800038b8:	6442                	ld	s0,16(sp)
    800038ba:	64a2                	ld	s1,8(sp)
    800038bc:	6105                	addi	sp,sp,32
    800038be:	8082                	ret

00000000800038c0 <bunpin>:

void
bunpin(struct buf *b) {
    800038c0:	1101                	addi	sp,sp,-32
    800038c2:	ec06                	sd	ra,24(sp)
    800038c4:	e822                	sd	s0,16(sp)
    800038c6:	e426                	sd	s1,8(sp)
    800038c8:	1000                	addi	s0,sp,32
    800038ca:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800038cc:	00016517          	auipc	a0,0x16
    800038d0:	68450513          	addi	a0,a0,1668 # 80019f50 <bcache>
    800038d4:	ffffd097          	auipc	ra,0xffffd
    800038d8:	364080e7          	jalr	868(ra) # 80000c38 <acquire>
  b->refcnt--;
    800038dc:	40bc                	lw	a5,64(s1)
    800038de:	37fd                	addiw	a5,a5,-1
    800038e0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800038e2:	00016517          	auipc	a0,0x16
    800038e6:	66e50513          	addi	a0,a0,1646 # 80019f50 <bcache>
    800038ea:	ffffd097          	auipc	ra,0xffffd
    800038ee:	402080e7          	jalr	1026(ra) # 80000cec <release>
}
    800038f2:	60e2                	ld	ra,24(sp)
    800038f4:	6442                	ld	s0,16(sp)
    800038f6:	64a2                	ld	s1,8(sp)
    800038f8:	6105                	addi	sp,sp,32
    800038fa:	8082                	ret

00000000800038fc <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800038fc:	1101                	addi	sp,sp,-32
    800038fe:	ec06                	sd	ra,24(sp)
    80003900:	e822                	sd	s0,16(sp)
    80003902:	e426                	sd	s1,8(sp)
    80003904:	e04a                	sd	s2,0(sp)
    80003906:	1000                	addi	s0,sp,32
    80003908:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000390a:	00d5d59b          	srliw	a1,a1,0xd
    8000390e:	0001f797          	auipc	a5,0x1f
    80003912:	d1e7a783          	lw	a5,-738(a5) # 8002262c <sb+0x1c>
    80003916:	9dbd                	addw	a1,a1,a5
    80003918:	00000097          	auipc	ra,0x0
    8000391c:	da0080e7          	jalr	-608(ra) # 800036b8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003920:	0074f713          	andi	a4,s1,7
    80003924:	4785                	li	a5,1
    80003926:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000392a:	14ce                	slli	s1,s1,0x33
    8000392c:	90d9                	srli	s1,s1,0x36
    8000392e:	00950733          	add	a4,a0,s1
    80003932:	05874703          	lbu	a4,88(a4)
    80003936:	00e7f6b3          	and	a3,a5,a4
    8000393a:	c69d                	beqz	a3,80003968 <bfree+0x6c>
    8000393c:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000393e:	94aa                	add	s1,s1,a0
    80003940:	fff7c793          	not	a5,a5
    80003944:	8f7d                	and	a4,a4,a5
    80003946:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000394a:	00001097          	auipc	ra,0x1
    8000394e:	148080e7          	jalr	328(ra) # 80004a92 <log_write>
  brelse(bp);
    80003952:	854a                	mv	a0,s2
    80003954:	00000097          	auipc	ra,0x0
    80003958:	e94080e7          	jalr	-364(ra) # 800037e8 <brelse>
}
    8000395c:	60e2                	ld	ra,24(sp)
    8000395e:	6442                	ld	s0,16(sp)
    80003960:	64a2                	ld	s1,8(sp)
    80003962:	6902                	ld	s2,0(sp)
    80003964:	6105                	addi	sp,sp,32
    80003966:	8082                	ret
    panic("freeing free block");
    80003968:	00005517          	auipc	a0,0x5
    8000396c:	bd050513          	addi	a0,a0,-1072 # 80008538 <etext+0x538>
    80003970:	ffffd097          	auipc	ra,0xffffd
    80003974:	bf0080e7          	jalr	-1040(ra) # 80000560 <panic>

0000000080003978 <balloc>:
{
    80003978:	711d                	addi	sp,sp,-96
    8000397a:	ec86                	sd	ra,88(sp)
    8000397c:	e8a2                	sd	s0,80(sp)
    8000397e:	e4a6                	sd	s1,72(sp)
    80003980:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003982:	0001f797          	auipc	a5,0x1f
    80003986:	c927a783          	lw	a5,-878(a5) # 80022614 <sb+0x4>
    8000398a:	10078f63          	beqz	a5,80003aa8 <balloc+0x130>
    8000398e:	e0ca                	sd	s2,64(sp)
    80003990:	fc4e                	sd	s3,56(sp)
    80003992:	f852                	sd	s4,48(sp)
    80003994:	f456                	sd	s5,40(sp)
    80003996:	f05a                	sd	s6,32(sp)
    80003998:	ec5e                	sd	s7,24(sp)
    8000399a:	e862                	sd	s8,16(sp)
    8000399c:	e466                	sd	s9,8(sp)
    8000399e:	8baa                	mv	s7,a0
    800039a0:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800039a2:	0001fb17          	auipc	s6,0x1f
    800039a6:	c6eb0b13          	addi	s6,s6,-914 # 80022610 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800039aa:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800039ac:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800039ae:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800039b0:	6c89                	lui	s9,0x2
    800039b2:	a061                	j	80003a3a <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    800039b4:	97ca                	add	a5,a5,s2
    800039b6:	8e55                	or	a2,a2,a3
    800039b8:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800039bc:	854a                	mv	a0,s2
    800039be:	00001097          	auipc	ra,0x1
    800039c2:	0d4080e7          	jalr	212(ra) # 80004a92 <log_write>
        brelse(bp);
    800039c6:	854a                	mv	a0,s2
    800039c8:	00000097          	auipc	ra,0x0
    800039cc:	e20080e7          	jalr	-480(ra) # 800037e8 <brelse>
  bp = bread(dev, bno);
    800039d0:	85a6                	mv	a1,s1
    800039d2:	855e                	mv	a0,s7
    800039d4:	00000097          	auipc	ra,0x0
    800039d8:	ce4080e7          	jalr	-796(ra) # 800036b8 <bread>
    800039dc:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800039de:	40000613          	li	a2,1024
    800039e2:	4581                	li	a1,0
    800039e4:	05850513          	addi	a0,a0,88
    800039e8:	ffffd097          	auipc	ra,0xffffd
    800039ec:	34c080e7          	jalr	844(ra) # 80000d34 <memset>
  log_write(bp);
    800039f0:	854a                	mv	a0,s2
    800039f2:	00001097          	auipc	ra,0x1
    800039f6:	0a0080e7          	jalr	160(ra) # 80004a92 <log_write>
  brelse(bp);
    800039fa:	854a                	mv	a0,s2
    800039fc:	00000097          	auipc	ra,0x0
    80003a00:	dec080e7          	jalr	-532(ra) # 800037e8 <brelse>
}
    80003a04:	6906                	ld	s2,64(sp)
    80003a06:	79e2                	ld	s3,56(sp)
    80003a08:	7a42                	ld	s4,48(sp)
    80003a0a:	7aa2                	ld	s5,40(sp)
    80003a0c:	7b02                	ld	s6,32(sp)
    80003a0e:	6be2                	ld	s7,24(sp)
    80003a10:	6c42                	ld	s8,16(sp)
    80003a12:	6ca2                	ld	s9,8(sp)
}
    80003a14:	8526                	mv	a0,s1
    80003a16:	60e6                	ld	ra,88(sp)
    80003a18:	6446                	ld	s0,80(sp)
    80003a1a:	64a6                	ld	s1,72(sp)
    80003a1c:	6125                	addi	sp,sp,96
    80003a1e:	8082                	ret
    brelse(bp);
    80003a20:	854a                	mv	a0,s2
    80003a22:	00000097          	auipc	ra,0x0
    80003a26:	dc6080e7          	jalr	-570(ra) # 800037e8 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003a2a:	015c87bb          	addw	a5,s9,s5
    80003a2e:	00078a9b          	sext.w	s5,a5
    80003a32:	004b2703          	lw	a4,4(s6)
    80003a36:	06eaf163          	bgeu	s5,a4,80003a98 <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
    80003a3a:	41fad79b          	sraiw	a5,s5,0x1f
    80003a3e:	0137d79b          	srliw	a5,a5,0x13
    80003a42:	015787bb          	addw	a5,a5,s5
    80003a46:	40d7d79b          	sraiw	a5,a5,0xd
    80003a4a:	01cb2583          	lw	a1,28(s6)
    80003a4e:	9dbd                	addw	a1,a1,a5
    80003a50:	855e                	mv	a0,s7
    80003a52:	00000097          	auipc	ra,0x0
    80003a56:	c66080e7          	jalr	-922(ra) # 800036b8 <bread>
    80003a5a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003a5c:	004b2503          	lw	a0,4(s6)
    80003a60:	000a849b          	sext.w	s1,s5
    80003a64:	8762                	mv	a4,s8
    80003a66:	faa4fde3          	bgeu	s1,a0,80003a20 <balloc+0xa8>
      m = 1 << (bi % 8);
    80003a6a:	00777693          	andi	a3,a4,7
    80003a6e:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003a72:	41f7579b          	sraiw	a5,a4,0x1f
    80003a76:	01d7d79b          	srliw	a5,a5,0x1d
    80003a7a:	9fb9                	addw	a5,a5,a4
    80003a7c:	4037d79b          	sraiw	a5,a5,0x3
    80003a80:	00f90633          	add	a2,s2,a5
    80003a84:	05864603          	lbu	a2,88(a2)
    80003a88:	00c6f5b3          	and	a1,a3,a2
    80003a8c:	d585                	beqz	a1,800039b4 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003a8e:	2705                	addiw	a4,a4,1
    80003a90:	2485                	addiw	s1,s1,1
    80003a92:	fd471ae3          	bne	a4,s4,80003a66 <balloc+0xee>
    80003a96:	b769                	j	80003a20 <balloc+0xa8>
    80003a98:	6906                	ld	s2,64(sp)
    80003a9a:	79e2                	ld	s3,56(sp)
    80003a9c:	7a42                	ld	s4,48(sp)
    80003a9e:	7aa2                	ld	s5,40(sp)
    80003aa0:	7b02                	ld	s6,32(sp)
    80003aa2:	6be2                	ld	s7,24(sp)
    80003aa4:	6c42                	ld	s8,16(sp)
    80003aa6:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80003aa8:	00005517          	auipc	a0,0x5
    80003aac:	aa850513          	addi	a0,a0,-1368 # 80008550 <etext+0x550>
    80003ab0:	ffffd097          	auipc	ra,0xffffd
    80003ab4:	afa080e7          	jalr	-1286(ra) # 800005aa <printf>
  return 0;
    80003ab8:	4481                	li	s1,0
    80003aba:	bfa9                	j	80003a14 <balloc+0x9c>

0000000080003abc <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003abc:	7179                	addi	sp,sp,-48
    80003abe:	f406                	sd	ra,40(sp)
    80003ac0:	f022                	sd	s0,32(sp)
    80003ac2:	ec26                	sd	s1,24(sp)
    80003ac4:	e84a                	sd	s2,16(sp)
    80003ac6:	e44e                	sd	s3,8(sp)
    80003ac8:	1800                	addi	s0,sp,48
    80003aca:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003acc:	47ad                	li	a5,11
    80003ace:	02b7e863          	bltu	a5,a1,80003afe <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80003ad2:	02059793          	slli	a5,a1,0x20
    80003ad6:	01e7d593          	srli	a1,a5,0x1e
    80003ada:	00b504b3          	add	s1,a0,a1
    80003ade:	0504a903          	lw	s2,80(s1)
    80003ae2:	08091263          	bnez	s2,80003b66 <bmap+0xaa>
      addr = balloc(ip->dev);
    80003ae6:	4108                	lw	a0,0(a0)
    80003ae8:	00000097          	auipc	ra,0x0
    80003aec:	e90080e7          	jalr	-368(ra) # 80003978 <balloc>
    80003af0:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003af4:	06090963          	beqz	s2,80003b66 <bmap+0xaa>
        return 0;
      ip->addrs[bn] = addr;
    80003af8:	0524a823          	sw	s2,80(s1)
    80003afc:	a0ad                	j	80003b66 <bmap+0xaa>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003afe:	ff45849b          	addiw	s1,a1,-12
    80003b02:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003b06:	0ff00793          	li	a5,255
    80003b0a:	08e7e863          	bltu	a5,a4,80003b9a <bmap+0xde>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003b0e:	08052903          	lw	s2,128(a0)
    80003b12:	00091f63          	bnez	s2,80003b30 <bmap+0x74>
      addr = balloc(ip->dev);
    80003b16:	4108                	lw	a0,0(a0)
    80003b18:	00000097          	auipc	ra,0x0
    80003b1c:	e60080e7          	jalr	-416(ra) # 80003978 <balloc>
    80003b20:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003b24:	04090163          	beqz	s2,80003b66 <bmap+0xaa>
    80003b28:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003b2a:	0929a023          	sw	s2,128(s3)
    80003b2e:	a011                	j	80003b32 <bmap+0x76>
    80003b30:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003b32:	85ca                	mv	a1,s2
    80003b34:	0009a503          	lw	a0,0(s3)
    80003b38:	00000097          	auipc	ra,0x0
    80003b3c:	b80080e7          	jalr	-1152(ra) # 800036b8 <bread>
    80003b40:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003b42:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003b46:	02049713          	slli	a4,s1,0x20
    80003b4a:	01e75593          	srli	a1,a4,0x1e
    80003b4e:	00b784b3          	add	s1,a5,a1
    80003b52:	0004a903          	lw	s2,0(s1)
    80003b56:	02090063          	beqz	s2,80003b76 <bmap+0xba>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003b5a:	8552                	mv	a0,s4
    80003b5c:	00000097          	auipc	ra,0x0
    80003b60:	c8c080e7          	jalr	-884(ra) # 800037e8 <brelse>
    return addr;
    80003b64:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003b66:	854a                	mv	a0,s2
    80003b68:	70a2                	ld	ra,40(sp)
    80003b6a:	7402                	ld	s0,32(sp)
    80003b6c:	64e2                	ld	s1,24(sp)
    80003b6e:	6942                	ld	s2,16(sp)
    80003b70:	69a2                	ld	s3,8(sp)
    80003b72:	6145                	addi	sp,sp,48
    80003b74:	8082                	ret
      addr = balloc(ip->dev);
    80003b76:	0009a503          	lw	a0,0(s3)
    80003b7a:	00000097          	auipc	ra,0x0
    80003b7e:	dfe080e7          	jalr	-514(ra) # 80003978 <balloc>
    80003b82:	0005091b          	sext.w	s2,a0
      if(addr){
    80003b86:	fc090ae3          	beqz	s2,80003b5a <bmap+0x9e>
        a[bn] = addr;
    80003b8a:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003b8e:	8552                	mv	a0,s4
    80003b90:	00001097          	auipc	ra,0x1
    80003b94:	f02080e7          	jalr	-254(ra) # 80004a92 <log_write>
    80003b98:	b7c9                	j	80003b5a <bmap+0x9e>
    80003b9a:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003b9c:	00005517          	auipc	a0,0x5
    80003ba0:	9cc50513          	addi	a0,a0,-1588 # 80008568 <etext+0x568>
    80003ba4:	ffffd097          	auipc	ra,0xffffd
    80003ba8:	9bc080e7          	jalr	-1604(ra) # 80000560 <panic>

0000000080003bac <iget>:
{
    80003bac:	7179                	addi	sp,sp,-48
    80003bae:	f406                	sd	ra,40(sp)
    80003bb0:	f022                	sd	s0,32(sp)
    80003bb2:	ec26                	sd	s1,24(sp)
    80003bb4:	e84a                	sd	s2,16(sp)
    80003bb6:	e44e                	sd	s3,8(sp)
    80003bb8:	e052                	sd	s4,0(sp)
    80003bba:	1800                	addi	s0,sp,48
    80003bbc:	89aa                	mv	s3,a0
    80003bbe:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003bc0:	0001f517          	auipc	a0,0x1f
    80003bc4:	a7050513          	addi	a0,a0,-1424 # 80022630 <itable>
    80003bc8:	ffffd097          	auipc	ra,0xffffd
    80003bcc:	070080e7          	jalr	112(ra) # 80000c38 <acquire>
  empty = 0;
    80003bd0:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003bd2:	0001f497          	auipc	s1,0x1f
    80003bd6:	a7648493          	addi	s1,s1,-1418 # 80022648 <itable+0x18>
    80003bda:	00020697          	auipc	a3,0x20
    80003bde:	4fe68693          	addi	a3,a3,1278 # 800240d8 <log>
    80003be2:	a039                	j	80003bf0 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003be4:	02090b63          	beqz	s2,80003c1a <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003be8:	08848493          	addi	s1,s1,136
    80003bec:	02d48a63          	beq	s1,a3,80003c20 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003bf0:	449c                	lw	a5,8(s1)
    80003bf2:	fef059e3          	blez	a5,80003be4 <iget+0x38>
    80003bf6:	4098                	lw	a4,0(s1)
    80003bf8:	ff3716e3          	bne	a4,s3,80003be4 <iget+0x38>
    80003bfc:	40d8                	lw	a4,4(s1)
    80003bfe:	ff4713e3          	bne	a4,s4,80003be4 <iget+0x38>
      ip->ref++;
    80003c02:	2785                	addiw	a5,a5,1
    80003c04:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003c06:	0001f517          	auipc	a0,0x1f
    80003c0a:	a2a50513          	addi	a0,a0,-1494 # 80022630 <itable>
    80003c0e:	ffffd097          	auipc	ra,0xffffd
    80003c12:	0de080e7          	jalr	222(ra) # 80000cec <release>
      return ip;
    80003c16:	8926                	mv	s2,s1
    80003c18:	a03d                	j	80003c46 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003c1a:	f7f9                	bnez	a5,80003be8 <iget+0x3c>
      empty = ip;
    80003c1c:	8926                	mv	s2,s1
    80003c1e:	b7e9                	j	80003be8 <iget+0x3c>
  if(empty == 0)
    80003c20:	02090c63          	beqz	s2,80003c58 <iget+0xac>
  ip->dev = dev;
    80003c24:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003c28:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003c2c:	4785                	li	a5,1
    80003c2e:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003c32:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003c36:	0001f517          	auipc	a0,0x1f
    80003c3a:	9fa50513          	addi	a0,a0,-1542 # 80022630 <itable>
    80003c3e:	ffffd097          	auipc	ra,0xffffd
    80003c42:	0ae080e7          	jalr	174(ra) # 80000cec <release>
}
    80003c46:	854a                	mv	a0,s2
    80003c48:	70a2                	ld	ra,40(sp)
    80003c4a:	7402                	ld	s0,32(sp)
    80003c4c:	64e2                	ld	s1,24(sp)
    80003c4e:	6942                	ld	s2,16(sp)
    80003c50:	69a2                	ld	s3,8(sp)
    80003c52:	6a02                	ld	s4,0(sp)
    80003c54:	6145                	addi	sp,sp,48
    80003c56:	8082                	ret
    panic("iget: no inodes");
    80003c58:	00005517          	auipc	a0,0x5
    80003c5c:	92850513          	addi	a0,a0,-1752 # 80008580 <etext+0x580>
    80003c60:	ffffd097          	auipc	ra,0xffffd
    80003c64:	900080e7          	jalr	-1792(ra) # 80000560 <panic>

0000000080003c68 <fsinit>:
fsinit(int dev) {
    80003c68:	7179                	addi	sp,sp,-48
    80003c6a:	f406                	sd	ra,40(sp)
    80003c6c:	f022                	sd	s0,32(sp)
    80003c6e:	ec26                	sd	s1,24(sp)
    80003c70:	e84a                	sd	s2,16(sp)
    80003c72:	e44e                	sd	s3,8(sp)
    80003c74:	1800                	addi	s0,sp,48
    80003c76:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003c78:	4585                	li	a1,1
    80003c7a:	00000097          	auipc	ra,0x0
    80003c7e:	a3e080e7          	jalr	-1474(ra) # 800036b8 <bread>
    80003c82:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003c84:	0001f997          	auipc	s3,0x1f
    80003c88:	98c98993          	addi	s3,s3,-1652 # 80022610 <sb>
    80003c8c:	02000613          	li	a2,32
    80003c90:	05850593          	addi	a1,a0,88
    80003c94:	854e                	mv	a0,s3
    80003c96:	ffffd097          	auipc	ra,0xffffd
    80003c9a:	0fa080e7          	jalr	250(ra) # 80000d90 <memmove>
  brelse(bp);
    80003c9e:	8526                	mv	a0,s1
    80003ca0:	00000097          	auipc	ra,0x0
    80003ca4:	b48080e7          	jalr	-1208(ra) # 800037e8 <brelse>
  if(sb.magic != FSMAGIC)
    80003ca8:	0009a703          	lw	a4,0(s3)
    80003cac:	102037b7          	lui	a5,0x10203
    80003cb0:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003cb4:	02f71263          	bne	a4,a5,80003cd8 <fsinit+0x70>
  initlog(dev, &sb);
    80003cb8:	0001f597          	auipc	a1,0x1f
    80003cbc:	95858593          	addi	a1,a1,-1704 # 80022610 <sb>
    80003cc0:	854a                	mv	a0,s2
    80003cc2:	00001097          	auipc	ra,0x1
    80003cc6:	b60080e7          	jalr	-1184(ra) # 80004822 <initlog>
}
    80003cca:	70a2                	ld	ra,40(sp)
    80003ccc:	7402                	ld	s0,32(sp)
    80003cce:	64e2                	ld	s1,24(sp)
    80003cd0:	6942                	ld	s2,16(sp)
    80003cd2:	69a2                	ld	s3,8(sp)
    80003cd4:	6145                	addi	sp,sp,48
    80003cd6:	8082                	ret
    panic("invalid file system");
    80003cd8:	00005517          	auipc	a0,0x5
    80003cdc:	8b850513          	addi	a0,a0,-1864 # 80008590 <etext+0x590>
    80003ce0:	ffffd097          	auipc	ra,0xffffd
    80003ce4:	880080e7          	jalr	-1920(ra) # 80000560 <panic>

0000000080003ce8 <iinit>:
{
    80003ce8:	7179                	addi	sp,sp,-48
    80003cea:	f406                	sd	ra,40(sp)
    80003cec:	f022                	sd	s0,32(sp)
    80003cee:	ec26                	sd	s1,24(sp)
    80003cf0:	e84a                	sd	s2,16(sp)
    80003cf2:	e44e                	sd	s3,8(sp)
    80003cf4:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003cf6:	00005597          	auipc	a1,0x5
    80003cfa:	8b258593          	addi	a1,a1,-1870 # 800085a8 <etext+0x5a8>
    80003cfe:	0001f517          	auipc	a0,0x1f
    80003d02:	93250513          	addi	a0,a0,-1742 # 80022630 <itable>
    80003d06:	ffffd097          	auipc	ra,0xffffd
    80003d0a:	ea2080e7          	jalr	-350(ra) # 80000ba8 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003d0e:	0001f497          	auipc	s1,0x1f
    80003d12:	94a48493          	addi	s1,s1,-1718 # 80022658 <itable+0x28>
    80003d16:	00020997          	auipc	s3,0x20
    80003d1a:	3d298993          	addi	s3,s3,978 # 800240e8 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003d1e:	00005917          	auipc	s2,0x5
    80003d22:	89290913          	addi	s2,s2,-1902 # 800085b0 <etext+0x5b0>
    80003d26:	85ca                	mv	a1,s2
    80003d28:	8526                	mv	a0,s1
    80003d2a:	00001097          	auipc	ra,0x1
    80003d2e:	e4c080e7          	jalr	-436(ra) # 80004b76 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003d32:	08848493          	addi	s1,s1,136
    80003d36:	ff3498e3          	bne	s1,s3,80003d26 <iinit+0x3e>
}
    80003d3a:	70a2                	ld	ra,40(sp)
    80003d3c:	7402                	ld	s0,32(sp)
    80003d3e:	64e2                	ld	s1,24(sp)
    80003d40:	6942                	ld	s2,16(sp)
    80003d42:	69a2                	ld	s3,8(sp)
    80003d44:	6145                	addi	sp,sp,48
    80003d46:	8082                	ret

0000000080003d48 <ialloc>:
{
    80003d48:	7139                	addi	sp,sp,-64
    80003d4a:	fc06                	sd	ra,56(sp)
    80003d4c:	f822                	sd	s0,48(sp)
    80003d4e:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003d50:	0001f717          	auipc	a4,0x1f
    80003d54:	8cc72703          	lw	a4,-1844(a4) # 8002261c <sb+0xc>
    80003d58:	4785                	li	a5,1
    80003d5a:	06e7f463          	bgeu	a5,a4,80003dc2 <ialloc+0x7a>
    80003d5e:	f426                	sd	s1,40(sp)
    80003d60:	f04a                	sd	s2,32(sp)
    80003d62:	ec4e                	sd	s3,24(sp)
    80003d64:	e852                	sd	s4,16(sp)
    80003d66:	e456                	sd	s5,8(sp)
    80003d68:	e05a                	sd	s6,0(sp)
    80003d6a:	8aaa                	mv	s5,a0
    80003d6c:	8b2e                	mv	s6,a1
    80003d6e:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003d70:	0001fa17          	auipc	s4,0x1f
    80003d74:	8a0a0a13          	addi	s4,s4,-1888 # 80022610 <sb>
    80003d78:	00495593          	srli	a1,s2,0x4
    80003d7c:	018a2783          	lw	a5,24(s4)
    80003d80:	9dbd                	addw	a1,a1,a5
    80003d82:	8556                	mv	a0,s5
    80003d84:	00000097          	auipc	ra,0x0
    80003d88:	934080e7          	jalr	-1740(ra) # 800036b8 <bread>
    80003d8c:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003d8e:	05850993          	addi	s3,a0,88
    80003d92:	00f97793          	andi	a5,s2,15
    80003d96:	079a                	slli	a5,a5,0x6
    80003d98:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003d9a:	00099783          	lh	a5,0(s3)
    80003d9e:	cf9d                	beqz	a5,80003ddc <ialloc+0x94>
    brelse(bp);
    80003da0:	00000097          	auipc	ra,0x0
    80003da4:	a48080e7          	jalr	-1464(ra) # 800037e8 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003da8:	0905                	addi	s2,s2,1
    80003daa:	00ca2703          	lw	a4,12(s4)
    80003dae:	0009079b          	sext.w	a5,s2
    80003db2:	fce7e3e3          	bltu	a5,a4,80003d78 <ialloc+0x30>
    80003db6:	74a2                	ld	s1,40(sp)
    80003db8:	7902                	ld	s2,32(sp)
    80003dba:	69e2                	ld	s3,24(sp)
    80003dbc:	6a42                	ld	s4,16(sp)
    80003dbe:	6aa2                	ld	s5,8(sp)
    80003dc0:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003dc2:	00004517          	auipc	a0,0x4
    80003dc6:	7f650513          	addi	a0,a0,2038 # 800085b8 <etext+0x5b8>
    80003dca:	ffffc097          	auipc	ra,0xffffc
    80003dce:	7e0080e7          	jalr	2016(ra) # 800005aa <printf>
  return 0;
    80003dd2:	4501                	li	a0,0
}
    80003dd4:	70e2                	ld	ra,56(sp)
    80003dd6:	7442                	ld	s0,48(sp)
    80003dd8:	6121                	addi	sp,sp,64
    80003dda:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003ddc:	04000613          	li	a2,64
    80003de0:	4581                	li	a1,0
    80003de2:	854e                	mv	a0,s3
    80003de4:	ffffd097          	auipc	ra,0xffffd
    80003de8:	f50080e7          	jalr	-176(ra) # 80000d34 <memset>
      dip->type = type;
    80003dec:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003df0:	8526                	mv	a0,s1
    80003df2:	00001097          	auipc	ra,0x1
    80003df6:	ca0080e7          	jalr	-864(ra) # 80004a92 <log_write>
      brelse(bp);
    80003dfa:	8526                	mv	a0,s1
    80003dfc:	00000097          	auipc	ra,0x0
    80003e00:	9ec080e7          	jalr	-1556(ra) # 800037e8 <brelse>
      return iget(dev, inum);
    80003e04:	0009059b          	sext.w	a1,s2
    80003e08:	8556                	mv	a0,s5
    80003e0a:	00000097          	auipc	ra,0x0
    80003e0e:	da2080e7          	jalr	-606(ra) # 80003bac <iget>
    80003e12:	74a2                	ld	s1,40(sp)
    80003e14:	7902                	ld	s2,32(sp)
    80003e16:	69e2                	ld	s3,24(sp)
    80003e18:	6a42                	ld	s4,16(sp)
    80003e1a:	6aa2                	ld	s5,8(sp)
    80003e1c:	6b02                	ld	s6,0(sp)
    80003e1e:	bf5d                	j	80003dd4 <ialloc+0x8c>

0000000080003e20 <iupdate>:
{
    80003e20:	1101                	addi	sp,sp,-32
    80003e22:	ec06                	sd	ra,24(sp)
    80003e24:	e822                	sd	s0,16(sp)
    80003e26:	e426                	sd	s1,8(sp)
    80003e28:	e04a                	sd	s2,0(sp)
    80003e2a:	1000                	addi	s0,sp,32
    80003e2c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003e2e:	415c                	lw	a5,4(a0)
    80003e30:	0047d79b          	srliw	a5,a5,0x4
    80003e34:	0001e597          	auipc	a1,0x1e
    80003e38:	7f45a583          	lw	a1,2036(a1) # 80022628 <sb+0x18>
    80003e3c:	9dbd                	addw	a1,a1,a5
    80003e3e:	4108                	lw	a0,0(a0)
    80003e40:	00000097          	auipc	ra,0x0
    80003e44:	878080e7          	jalr	-1928(ra) # 800036b8 <bread>
    80003e48:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003e4a:	05850793          	addi	a5,a0,88
    80003e4e:	40d8                	lw	a4,4(s1)
    80003e50:	8b3d                	andi	a4,a4,15
    80003e52:	071a                	slli	a4,a4,0x6
    80003e54:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003e56:	04449703          	lh	a4,68(s1)
    80003e5a:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003e5e:	04649703          	lh	a4,70(s1)
    80003e62:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003e66:	04849703          	lh	a4,72(s1)
    80003e6a:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003e6e:	04a49703          	lh	a4,74(s1)
    80003e72:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003e76:	44f8                	lw	a4,76(s1)
    80003e78:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003e7a:	03400613          	li	a2,52
    80003e7e:	05048593          	addi	a1,s1,80
    80003e82:	00c78513          	addi	a0,a5,12
    80003e86:	ffffd097          	auipc	ra,0xffffd
    80003e8a:	f0a080e7          	jalr	-246(ra) # 80000d90 <memmove>
  log_write(bp);
    80003e8e:	854a                	mv	a0,s2
    80003e90:	00001097          	auipc	ra,0x1
    80003e94:	c02080e7          	jalr	-1022(ra) # 80004a92 <log_write>
  brelse(bp);
    80003e98:	854a                	mv	a0,s2
    80003e9a:	00000097          	auipc	ra,0x0
    80003e9e:	94e080e7          	jalr	-1714(ra) # 800037e8 <brelse>
}
    80003ea2:	60e2                	ld	ra,24(sp)
    80003ea4:	6442                	ld	s0,16(sp)
    80003ea6:	64a2                	ld	s1,8(sp)
    80003ea8:	6902                	ld	s2,0(sp)
    80003eaa:	6105                	addi	sp,sp,32
    80003eac:	8082                	ret

0000000080003eae <idup>:
{
    80003eae:	1101                	addi	sp,sp,-32
    80003eb0:	ec06                	sd	ra,24(sp)
    80003eb2:	e822                	sd	s0,16(sp)
    80003eb4:	e426                	sd	s1,8(sp)
    80003eb6:	1000                	addi	s0,sp,32
    80003eb8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003eba:	0001e517          	auipc	a0,0x1e
    80003ebe:	77650513          	addi	a0,a0,1910 # 80022630 <itable>
    80003ec2:	ffffd097          	auipc	ra,0xffffd
    80003ec6:	d76080e7          	jalr	-650(ra) # 80000c38 <acquire>
  ip->ref++;
    80003eca:	449c                	lw	a5,8(s1)
    80003ecc:	2785                	addiw	a5,a5,1
    80003ece:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003ed0:	0001e517          	auipc	a0,0x1e
    80003ed4:	76050513          	addi	a0,a0,1888 # 80022630 <itable>
    80003ed8:	ffffd097          	auipc	ra,0xffffd
    80003edc:	e14080e7          	jalr	-492(ra) # 80000cec <release>
}
    80003ee0:	8526                	mv	a0,s1
    80003ee2:	60e2                	ld	ra,24(sp)
    80003ee4:	6442                	ld	s0,16(sp)
    80003ee6:	64a2                	ld	s1,8(sp)
    80003ee8:	6105                	addi	sp,sp,32
    80003eea:	8082                	ret

0000000080003eec <ilock>:
{
    80003eec:	1101                	addi	sp,sp,-32
    80003eee:	ec06                	sd	ra,24(sp)
    80003ef0:	e822                	sd	s0,16(sp)
    80003ef2:	e426                	sd	s1,8(sp)
    80003ef4:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003ef6:	c10d                	beqz	a0,80003f18 <ilock+0x2c>
    80003ef8:	84aa                	mv	s1,a0
    80003efa:	451c                	lw	a5,8(a0)
    80003efc:	00f05e63          	blez	a5,80003f18 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80003f00:	0541                	addi	a0,a0,16
    80003f02:	00001097          	auipc	ra,0x1
    80003f06:	cae080e7          	jalr	-850(ra) # 80004bb0 <acquiresleep>
  if(ip->valid == 0){
    80003f0a:	40bc                	lw	a5,64(s1)
    80003f0c:	cf99                	beqz	a5,80003f2a <ilock+0x3e>
}
    80003f0e:	60e2                	ld	ra,24(sp)
    80003f10:	6442                	ld	s0,16(sp)
    80003f12:	64a2                	ld	s1,8(sp)
    80003f14:	6105                	addi	sp,sp,32
    80003f16:	8082                	ret
    80003f18:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003f1a:	00004517          	auipc	a0,0x4
    80003f1e:	6b650513          	addi	a0,a0,1718 # 800085d0 <etext+0x5d0>
    80003f22:	ffffc097          	auipc	ra,0xffffc
    80003f26:	63e080e7          	jalr	1598(ra) # 80000560 <panic>
    80003f2a:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003f2c:	40dc                	lw	a5,4(s1)
    80003f2e:	0047d79b          	srliw	a5,a5,0x4
    80003f32:	0001e597          	auipc	a1,0x1e
    80003f36:	6f65a583          	lw	a1,1782(a1) # 80022628 <sb+0x18>
    80003f3a:	9dbd                	addw	a1,a1,a5
    80003f3c:	4088                	lw	a0,0(s1)
    80003f3e:	fffff097          	auipc	ra,0xfffff
    80003f42:	77a080e7          	jalr	1914(ra) # 800036b8 <bread>
    80003f46:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003f48:	05850593          	addi	a1,a0,88
    80003f4c:	40dc                	lw	a5,4(s1)
    80003f4e:	8bbd                	andi	a5,a5,15
    80003f50:	079a                	slli	a5,a5,0x6
    80003f52:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003f54:	00059783          	lh	a5,0(a1)
    80003f58:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003f5c:	00259783          	lh	a5,2(a1)
    80003f60:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003f64:	00459783          	lh	a5,4(a1)
    80003f68:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003f6c:	00659783          	lh	a5,6(a1)
    80003f70:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003f74:	459c                	lw	a5,8(a1)
    80003f76:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003f78:	03400613          	li	a2,52
    80003f7c:	05b1                	addi	a1,a1,12
    80003f7e:	05048513          	addi	a0,s1,80
    80003f82:	ffffd097          	auipc	ra,0xffffd
    80003f86:	e0e080e7          	jalr	-498(ra) # 80000d90 <memmove>
    brelse(bp);
    80003f8a:	854a                	mv	a0,s2
    80003f8c:	00000097          	auipc	ra,0x0
    80003f90:	85c080e7          	jalr	-1956(ra) # 800037e8 <brelse>
    ip->valid = 1;
    80003f94:	4785                	li	a5,1
    80003f96:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003f98:	04449783          	lh	a5,68(s1)
    80003f9c:	c399                	beqz	a5,80003fa2 <ilock+0xb6>
    80003f9e:	6902                	ld	s2,0(sp)
    80003fa0:	b7bd                	j	80003f0e <ilock+0x22>
      panic("ilock: no type");
    80003fa2:	00004517          	auipc	a0,0x4
    80003fa6:	63650513          	addi	a0,a0,1590 # 800085d8 <etext+0x5d8>
    80003faa:	ffffc097          	auipc	ra,0xffffc
    80003fae:	5b6080e7          	jalr	1462(ra) # 80000560 <panic>

0000000080003fb2 <iunlock>:
{
    80003fb2:	1101                	addi	sp,sp,-32
    80003fb4:	ec06                	sd	ra,24(sp)
    80003fb6:	e822                	sd	s0,16(sp)
    80003fb8:	e426                	sd	s1,8(sp)
    80003fba:	e04a                	sd	s2,0(sp)
    80003fbc:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003fbe:	c905                	beqz	a0,80003fee <iunlock+0x3c>
    80003fc0:	84aa                	mv	s1,a0
    80003fc2:	01050913          	addi	s2,a0,16
    80003fc6:	854a                	mv	a0,s2
    80003fc8:	00001097          	auipc	ra,0x1
    80003fcc:	c82080e7          	jalr	-894(ra) # 80004c4a <holdingsleep>
    80003fd0:	cd19                	beqz	a0,80003fee <iunlock+0x3c>
    80003fd2:	449c                	lw	a5,8(s1)
    80003fd4:	00f05d63          	blez	a5,80003fee <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003fd8:	854a                	mv	a0,s2
    80003fda:	00001097          	auipc	ra,0x1
    80003fde:	c2c080e7          	jalr	-980(ra) # 80004c06 <releasesleep>
}
    80003fe2:	60e2                	ld	ra,24(sp)
    80003fe4:	6442                	ld	s0,16(sp)
    80003fe6:	64a2                	ld	s1,8(sp)
    80003fe8:	6902                	ld	s2,0(sp)
    80003fea:	6105                	addi	sp,sp,32
    80003fec:	8082                	ret
    panic("iunlock");
    80003fee:	00004517          	auipc	a0,0x4
    80003ff2:	5fa50513          	addi	a0,a0,1530 # 800085e8 <etext+0x5e8>
    80003ff6:	ffffc097          	auipc	ra,0xffffc
    80003ffa:	56a080e7          	jalr	1386(ra) # 80000560 <panic>

0000000080003ffe <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003ffe:	7179                	addi	sp,sp,-48
    80004000:	f406                	sd	ra,40(sp)
    80004002:	f022                	sd	s0,32(sp)
    80004004:	ec26                	sd	s1,24(sp)
    80004006:	e84a                	sd	s2,16(sp)
    80004008:	e44e                	sd	s3,8(sp)
    8000400a:	1800                	addi	s0,sp,48
    8000400c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000400e:	05050493          	addi	s1,a0,80
    80004012:	08050913          	addi	s2,a0,128
    80004016:	a021                	j	8000401e <itrunc+0x20>
    80004018:	0491                	addi	s1,s1,4
    8000401a:	01248d63          	beq	s1,s2,80004034 <itrunc+0x36>
    if(ip->addrs[i]){
    8000401e:	408c                	lw	a1,0(s1)
    80004020:	dde5                	beqz	a1,80004018 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80004022:	0009a503          	lw	a0,0(s3)
    80004026:	00000097          	auipc	ra,0x0
    8000402a:	8d6080e7          	jalr	-1834(ra) # 800038fc <bfree>
      ip->addrs[i] = 0;
    8000402e:	0004a023          	sw	zero,0(s1)
    80004032:	b7dd                	j	80004018 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80004034:	0809a583          	lw	a1,128(s3)
    80004038:	ed99                	bnez	a1,80004056 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000403a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000403e:	854e                	mv	a0,s3
    80004040:	00000097          	auipc	ra,0x0
    80004044:	de0080e7          	jalr	-544(ra) # 80003e20 <iupdate>
}
    80004048:	70a2                	ld	ra,40(sp)
    8000404a:	7402                	ld	s0,32(sp)
    8000404c:	64e2                	ld	s1,24(sp)
    8000404e:	6942                	ld	s2,16(sp)
    80004050:	69a2                	ld	s3,8(sp)
    80004052:	6145                	addi	sp,sp,48
    80004054:	8082                	ret
    80004056:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80004058:	0009a503          	lw	a0,0(s3)
    8000405c:	fffff097          	auipc	ra,0xfffff
    80004060:	65c080e7          	jalr	1628(ra) # 800036b8 <bread>
    80004064:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80004066:	05850493          	addi	s1,a0,88
    8000406a:	45850913          	addi	s2,a0,1112
    8000406e:	a021                	j	80004076 <itrunc+0x78>
    80004070:	0491                	addi	s1,s1,4
    80004072:	01248b63          	beq	s1,s2,80004088 <itrunc+0x8a>
      if(a[j])
    80004076:	408c                	lw	a1,0(s1)
    80004078:	dde5                	beqz	a1,80004070 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    8000407a:	0009a503          	lw	a0,0(s3)
    8000407e:	00000097          	auipc	ra,0x0
    80004082:	87e080e7          	jalr	-1922(ra) # 800038fc <bfree>
    80004086:	b7ed                	j	80004070 <itrunc+0x72>
    brelse(bp);
    80004088:	8552                	mv	a0,s4
    8000408a:	fffff097          	auipc	ra,0xfffff
    8000408e:	75e080e7          	jalr	1886(ra) # 800037e8 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80004092:	0809a583          	lw	a1,128(s3)
    80004096:	0009a503          	lw	a0,0(s3)
    8000409a:	00000097          	auipc	ra,0x0
    8000409e:	862080e7          	jalr	-1950(ra) # 800038fc <bfree>
    ip->addrs[NDIRECT] = 0;
    800040a2:	0809a023          	sw	zero,128(s3)
    800040a6:	6a02                	ld	s4,0(sp)
    800040a8:	bf49                	j	8000403a <itrunc+0x3c>

00000000800040aa <iput>:
{
    800040aa:	1101                	addi	sp,sp,-32
    800040ac:	ec06                	sd	ra,24(sp)
    800040ae:	e822                	sd	s0,16(sp)
    800040b0:	e426                	sd	s1,8(sp)
    800040b2:	1000                	addi	s0,sp,32
    800040b4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800040b6:	0001e517          	auipc	a0,0x1e
    800040ba:	57a50513          	addi	a0,a0,1402 # 80022630 <itable>
    800040be:	ffffd097          	auipc	ra,0xffffd
    800040c2:	b7a080e7          	jalr	-1158(ra) # 80000c38 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800040c6:	4498                	lw	a4,8(s1)
    800040c8:	4785                	li	a5,1
    800040ca:	02f70263          	beq	a4,a5,800040ee <iput+0x44>
  ip->ref--;
    800040ce:	449c                	lw	a5,8(s1)
    800040d0:	37fd                	addiw	a5,a5,-1
    800040d2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800040d4:	0001e517          	auipc	a0,0x1e
    800040d8:	55c50513          	addi	a0,a0,1372 # 80022630 <itable>
    800040dc:	ffffd097          	auipc	ra,0xffffd
    800040e0:	c10080e7          	jalr	-1008(ra) # 80000cec <release>
}
    800040e4:	60e2                	ld	ra,24(sp)
    800040e6:	6442                	ld	s0,16(sp)
    800040e8:	64a2                	ld	s1,8(sp)
    800040ea:	6105                	addi	sp,sp,32
    800040ec:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800040ee:	40bc                	lw	a5,64(s1)
    800040f0:	dff9                	beqz	a5,800040ce <iput+0x24>
    800040f2:	04a49783          	lh	a5,74(s1)
    800040f6:	ffe1                	bnez	a5,800040ce <iput+0x24>
    800040f8:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800040fa:	01048913          	addi	s2,s1,16
    800040fe:	854a                	mv	a0,s2
    80004100:	00001097          	auipc	ra,0x1
    80004104:	ab0080e7          	jalr	-1360(ra) # 80004bb0 <acquiresleep>
    release(&itable.lock);
    80004108:	0001e517          	auipc	a0,0x1e
    8000410c:	52850513          	addi	a0,a0,1320 # 80022630 <itable>
    80004110:	ffffd097          	auipc	ra,0xffffd
    80004114:	bdc080e7          	jalr	-1060(ra) # 80000cec <release>
    itrunc(ip);
    80004118:	8526                	mv	a0,s1
    8000411a:	00000097          	auipc	ra,0x0
    8000411e:	ee4080e7          	jalr	-284(ra) # 80003ffe <itrunc>
    ip->type = 0;
    80004122:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80004126:	8526                	mv	a0,s1
    80004128:	00000097          	auipc	ra,0x0
    8000412c:	cf8080e7          	jalr	-776(ra) # 80003e20 <iupdate>
    ip->valid = 0;
    80004130:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80004134:	854a                	mv	a0,s2
    80004136:	00001097          	auipc	ra,0x1
    8000413a:	ad0080e7          	jalr	-1328(ra) # 80004c06 <releasesleep>
    acquire(&itable.lock);
    8000413e:	0001e517          	auipc	a0,0x1e
    80004142:	4f250513          	addi	a0,a0,1266 # 80022630 <itable>
    80004146:	ffffd097          	auipc	ra,0xffffd
    8000414a:	af2080e7          	jalr	-1294(ra) # 80000c38 <acquire>
    8000414e:	6902                	ld	s2,0(sp)
    80004150:	bfbd                	j	800040ce <iput+0x24>

0000000080004152 <iunlockput>:
{
    80004152:	1101                	addi	sp,sp,-32
    80004154:	ec06                	sd	ra,24(sp)
    80004156:	e822                	sd	s0,16(sp)
    80004158:	e426                	sd	s1,8(sp)
    8000415a:	1000                	addi	s0,sp,32
    8000415c:	84aa                	mv	s1,a0
  iunlock(ip);
    8000415e:	00000097          	auipc	ra,0x0
    80004162:	e54080e7          	jalr	-428(ra) # 80003fb2 <iunlock>
  iput(ip);
    80004166:	8526                	mv	a0,s1
    80004168:	00000097          	auipc	ra,0x0
    8000416c:	f42080e7          	jalr	-190(ra) # 800040aa <iput>
}
    80004170:	60e2                	ld	ra,24(sp)
    80004172:	6442                	ld	s0,16(sp)
    80004174:	64a2                	ld	s1,8(sp)
    80004176:	6105                	addi	sp,sp,32
    80004178:	8082                	ret

000000008000417a <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000417a:	1141                	addi	sp,sp,-16
    8000417c:	e422                	sd	s0,8(sp)
    8000417e:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80004180:	411c                	lw	a5,0(a0)
    80004182:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80004184:	415c                	lw	a5,4(a0)
    80004186:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80004188:	04451783          	lh	a5,68(a0)
    8000418c:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80004190:	04a51783          	lh	a5,74(a0)
    80004194:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80004198:	04c56783          	lwu	a5,76(a0)
    8000419c:	e99c                	sd	a5,16(a1)
}
    8000419e:	6422                	ld	s0,8(sp)
    800041a0:	0141                	addi	sp,sp,16
    800041a2:	8082                	ret

00000000800041a4 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800041a4:	457c                	lw	a5,76(a0)
    800041a6:	10d7e563          	bltu	a5,a3,800042b0 <readi+0x10c>
{
    800041aa:	7159                	addi	sp,sp,-112
    800041ac:	f486                	sd	ra,104(sp)
    800041ae:	f0a2                	sd	s0,96(sp)
    800041b0:	eca6                	sd	s1,88(sp)
    800041b2:	e0d2                	sd	s4,64(sp)
    800041b4:	fc56                	sd	s5,56(sp)
    800041b6:	f85a                	sd	s6,48(sp)
    800041b8:	f45e                	sd	s7,40(sp)
    800041ba:	1880                	addi	s0,sp,112
    800041bc:	8b2a                	mv	s6,a0
    800041be:	8bae                	mv	s7,a1
    800041c0:	8a32                	mv	s4,a2
    800041c2:	84b6                	mv	s1,a3
    800041c4:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800041c6:	9f35                	addw	a4,a4,a3
    return 0;
    800041c8:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800041ca:	0cd76a63          	bltu	a4,a3,8000429e <readi+0xfa>
    800041ce:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800041d0:	00e7f463          	bgeu	a5,a4,800041d8 <readi+0x34>
    n = ip->size - off;
    800041d4:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800041d8:	0a0a8963          	beqz	s5,8000428a <readi+0xe6>
    800041dc:	e8ca                	sd	s2,80(sp)
    800041de:	f062                	sd	s8,32(sp)
    800041e0:	ec66                	sd	s9,24(sp)
    800041e2:	e86a                	sd	s10,16(sp)
    800041e4:	e46e                	sd	s11,8(sp)
    800041e6:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800041e8:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800041ec:	5c7d                	li	s8,-1
    800041ee:	a82d                	j	80004228 <readi+0x84>
    800041f0:	020d1d93          	slli	s11,s10,0x20
    800041f4:	020ddd93          	srli	s11,s11,0x20
    800041f8:	05890613          	addi	a2,s2,88
    800041fc:	86ee                	mv	a3,s11
    800041fe:	963a                	add	a2,a2,a4
    80004200:	85d2                	mv	a1,s4
    80004202:	855e                	mv	a0,s7
    80004204:	fffff097          	auipc	ra,0xfffff
    80004208:	8f8080e7          	jalr	-1800(ra) # 80002afc <either_copyout>
    8000420c:	05850d63          	beq	a0,s8,80004266 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80004210:	854a                	mv	a0,s2
    80004212:	fffff097          	auipc	ra,0xfffff
    80004216:	5d6080e7          	jalr	1494(ra) # 800037e8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000421a:	013d09bb          	addw	s3,s10,s3
    8000421e:	009d04bb          	addw	s1,s10,s1
    80004222:	9a6e                	add	s4,s4,s11
    80004224:	0559fd63          	bgeu	s3,s5,8000427e <readi+0xda>
    uint addr = bmap(ip, off/BSIZE);
    80004228:	00a4d59b          	srliw	a1,s1,0xa
    8000422c:	855a                	mv	a0,s6
    8000422e:	00000097          	auipc	ra,0x0
    80004232:	88e080e7          	jalr	-1906(ra) # 80003abc <bmap>
    80004236:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000423a:	c9b1                	beqz	a1,8000428e <readi+0xea>
    bp = bread(ip->dev, addr);
    8000423c:	000b2503          	lw	a0,0(s6)
    80004240:	fffff097          	auipc	ra,0xfffff
    80004244:	478080e7          	jalr	1144(ra) # 800036b8 <bread>
    80004248:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000424a:	3ff4f713          	andi	a4,s1,1023
    8000424e:	40ec87bb          	subw	a5,s9,a4
    80004252:	413a86bb          	subw	a3,s5,s3
    80004256:	8d3e                	mv	s10,a5
    80004258:	2781                	sext.w	a5,a5
    8000425a:	0006861b          	sext.w	a2,a3
    8000425e:	f8f679e3          	bgeu	a2,a5,800041f0 <readi+0x4c>
    80004262:	8d36                	mv	s10,a3
    80004264:	b771                	j	800041f0 <readi+0x4c>
      brelse(bp);
    80004266:	854a                	mv	a0,s2
    80004268:	fffff097          	auipc	ra,0xfffff
    8000426c:	580080e7          	jalr	1408(ra) # 800037e8 <brelse>
      tot = -1;
    80004270:	59fd                	li	s3,-1
      break;
    80004272:	6946                	ld	s2,80(sp)
    80004274:	7c02                	ld	s8,32(sp)
    80004276:	6ce2                	ld	s9,24(sp)
    80004278:	6d42                	ld	s10,16(sp)
    8000427a:	6da2                	ld	s11,8(sp)
    8000427c:	a831                	j	80004298 <readi+0xf4>
    8000427e:	6946                	ld	s2,80(sp)
    80004280:	7c02                	ld	s8,32(sp)
    80004282:	6ce2                	ld	s9,24(sp)
    80004284:	6d42                	ld	s10,16(sp)
    80004286:	6da2                	ld	s11,8(sp)
    80004288:	a801                	j	80004298 <readi+0xf4>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000428a:	89d6                	mv	s3,s5
    8000428c:	a031                	j	80004298 <readi+0xf4>
    8000428e:	6946                	ld	s2,80(sp)
    80004290:	7c02                	ld	s8,32(sp)
    80004292:	6ce2                	ld	s9,24(sp)
    80004294:	6d42                	ld	s10,16(sp)
    80004296:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80004298:	0009851b          	sext.w	a0,s3
    8000429c:	69a6                	ld	s3,72(sp)
}
    8000429e:	70a6                	ld	ra,104(sp)
    800042a0:	7406                	ld	s0,96(sp)
    800042a2:	64e6                	ld	s1,88(sp)
    800042a4:	6a06                	ld	s4,64(sp)
    800042a6:	7ae2                	ld	s5,56(sp)
    800042a8:	7b42                	ld	s6,48(sp)
    800042aa:	7ba2                	ld	s7,40(sp)
    800042ac:	6165                	addi	sp,sp,112
    800042ae:	8082                	ret
    return 0;
    800042b0:	4501                	li	a0,0
}
    800042b2:	8082                	ret

00000000800042b4 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800042b4:	457c                	lw	a5,76(a0)
    800042b6:	10d7ee63          	bltu	a5,a3,800043d2 <writei+0x11e>
{
    800042ba:	7159                	addi	sp,sp,-112
    800042bc:	f486                	sd	ra,104(sp)
    800042be:	f0a2                	sd	s0,96(sp)
    800042c0:	e8ca                	sd	s2,80(sp)
    800042c2:	e0d2                	sd	s4,64(sp)
    800042c4:	fc56                	sd	s5,56(sp)
    800042c6:	f85a                	sd	s6,48(sp)
    800042c8:	f45e                	sd	s7,40(sp)
    800042ca:	1880                	addi	s0,sp,112
    800042cc:	8aaa                	mv	s5,a0
    800042ce:	8bae                	mv	s7,a1
    800042d0:	8a32                	mv	s4,a2
    800042d2:	8936                	mv	s2,a3
    800042d4:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800042d6:	00e687bb          	addw	a5,a3,a4
    800042da:	0ed7ee63          	bltu	a5,a3,800043d6 <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800042de:	00043737          	lui	a4,0x43
    800042e2:	0ef76c63          	bltu	a4,a5,800043da <writei+0x126>
    800042e6:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800042e8:	0c0b0d63          	beqz	s6,800043c2 <writei+0x10e>
    800042ec:	eca6                	sd	s1,88(sp)
    800042ee:	f062                	sd	s8,32(sp)
    800042f0:	ec66                	sd	s9,24(sp)
    800042f2:	e86a                	sd	s10,16(sp)
    800042f4:	e46e                	sd	s11,8(sp)
    800042f6:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800042f8:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800042fc:	5c7d                	li	s8,-1
    800042fe:	a091                	j	80004342 <writei+0x8e>
    80004300:	020d1d93          	slli	s11,s10,0x20
    80004304:	020ddd93          	srli	s11,s11,0x20
    80004308:	05848513          	addi	a0,s1,88
    8000430c:	86ee                	mv	a3,s11
    8000430e:	8652                	mv	a2,s4
    80004310:	85de                	mv	a1,s7
    80004312:	953a                	add	a0,a0,a4
    80004314:	fffff097          	auipc	ra,0xfffff
    80004318:	83e080e7          	jalr	-1986(ra) # 80002b52 <either_copyin>
    8000431c:	07850263          	beq	a0,s8,80004380 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80004320:	8526                	mv	a0,s1
    80004322:	00000097          	auipc	ra,0x0
    80004326:	770080e7          	jalr	1904(ra) # 80004a92 <log_write>
    brelse(bp);
    8000432a:	8526                	mv	a0,s1
    8000432c:	fffff097          	auipc	ra,0xfffff
    80004330:	4bc080e7          	jalr	1212(ra) # 800037e8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004334:	013d09bb          	addw	s3,s10,s3
    80004338:	012d093b          	addw	s2,s10,s2
    8000433c:	9a6e                	add	s4,s4,s11
    8000433e:	0569f663          	bgeu	s3,s6,8000438a <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80004342:	00a9559b          	srliw	a1,s2,0xa
    80004346:	8556                	mv	a0,s5
    80004348:	fffff097          	auipc	ra,0xfffff
    8000434c:	774080e7          	jalr	1908(ra) # 80003abc <bmap>
    80004350:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80004354:	c99d                	beqz	a1,8000438a <writei+0xd6>
    bp = bread(ip->dev, addr);
    80004356:	000aa503          	lw	a0,0(s5)
    8000435a:	fffff097          	auipc	ra,0xfffff
    8000435e:	35e080e7          	jalr	862(ra) # 800036b8 <bread>
    80004362:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004364:	3ff97713          	andi	a4,s2,1023
    80004368:	40ec87bb          	subw	a5,s9,a4
    8000436c:	413b06bb          	subw	a3,s6,s3
    80004370:	8d3e                	mv	s10,a5
    80004372:	2781                	sext.w	a5,a5
    80004374:	0006861b          	sext.w	a2,a3
    80004378:	f8f674e3          	bgeu	a2,a5,80004300 <writei+0x4c>
    8000437c:	8d36                	mv	s10,a3
    8000437e:	b749                	j	80004300 <writei+0x4c>
      brelse(bp);
    80004380:	8526                	mv	a0,s1
    80004382:	fffff097          	auipc	ra,0xfffff
    80004386:	466080e7          	jalr	1126(ra) # 800037e8 <brelse>
  }

  if(off > ip->size)
    8000438a:	04caa783          	lw	a5,76(s5)
    8000438e:	0327fc63          	bgeu	a5,s2,800043c6 <writei+0x112>
    ip->size = off;
    80004392:	052aa623          	sw	s2,76(s5)
    80004396:	64e6                	ld	s1,88(sp)
    80004398:	7c02                	ld	s8,32(sp)
    8000439a:	6ce2                	ld	s9,24(sp)
    8000439c:	6d42                	ld	s10,16(sp)
    8000439e:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800043a0:	8556                	mv	a0,s5
    800043a2:	00000097          	auipc	ra,0x0
    800043a6:	a7e080e7          	jalr	-1410(ra) # 80003e20 <iupdate>

  return tot;
    800043aa:	0009851b          	sext.w	a0,s3
    800043ae:	69a6                	ld	s3,72(sp)
}
    800043b0:	70a6                	ld	ra,104(sp)
    800043b2:	7406                	ld	s0,96(sp)
    800043b4:	6946                	ld	s2,80(sp)
    800043b6:	6a06                	ld	s4,64(sp)
    800043b8:	7ae2                	ld	s5,56(sp)
    800043ba:	7b42                	ld	s6,48(sp)
    800043bc:	7ba2                	ld	s7,40(sp)
    800043be:	6165                	addi	sp,sp,112
    800043c0:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800043c2:	89da                	mv	s3,s6
    800043c4:	bff1                	j	800043a0 <writei+0xec>
    800043c6:	64e6                	ld	s1,88(sp)
    800043c8:	7c02                	ld	s8,32(sp)
    800043ca:	6ce2                	ld	s9,24(sp)
    800043cc:	6d42                	ld	s10,16(sp)
    800043ce:	6da2                	ld	s11,8(sp)
    800043d0:	bfc1                	j	800043a0 <writei+0xec>
    return -1;
    800043d2:	557d                	li	a0,-1
}
    800043d4:	8082                	ret
    return -1;
    800043d6:	557d                	li	a0,-1
    800043d8:	bfe1                	j	800043b0 <writei+0xfc>
    return -1;
    800043da:	557d                	li	a0,-1
    800043dc:	bfd1                	j	800043b0 <writei+0xfc>

00000000800043de <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800043de:	1141                	addi	sp,sp,-16
    800043e0:	e406                	sd	ra,8(sp)
    800043e2:	e022                	sd	s0,0(sp)
    800043e4:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800043e6:	4639                	li	a2,14
    800043e8:	ffffd097          	auipc	ra,0xffffd
    800043ec:	a1c080e7          	jalr	-1508(ra) # 80000e04 <strncmp>
}
    800043f0:	60a2                	ld	ra,8(sp)
    800043f2:	6402                	ld	s0,0(sp)
    800043f4:	0141                	addi	sp,sp,16
    800043f6:	8082                	ret

00000000800043f8 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800043f8:	7139                	addi	sp,sp,-64
    800043fa:	fc06                	sd	ra,56(sp)
    800043fc:	f822                	sd	s0,48(sp)
    800043fe:	f426                	sd	s1,40(sp)
    80004400:	f04a                	sd	s2,32(sp)
    80004402:	ec4e                	sd	s3,24(sp)
    80004404:	e852                	sd	s4,16(sp)
    80004406:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80004408:	04451703          	lh	a4,68(a0)
    8000440c:	4785                	li	a5,1
    8000440e:	00f71a63          	bne	a4,a5,80004422 <dirlookup+0x2a>
    80004412:	892a                	mv	s2,a0
    80004414:	89ae                	mv	s3,a1
    80004416:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80004418:	457c                	lw	a5,76(a0)
    8000441a:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000441c:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000441e:	e79d                	bnez	a5,8000444c <dirlookup+0x54>
    80004420:	a8a5                	j	80004498 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80004422:	00004517          	auipc	a0,0x4
    80004426:	1ce50513          	addi	a0,a0,462 # 800085f0 <etext+0x5f0>
    8000442a:	ffffc097          	auipc	ra,0xffffc
    8000442e:	136080e7          	jalr	310(ra) # 80000560 <panic>
      panic("dirlookup read");
    80004432:	00004517          	auipc	a0,0x4
    80004436:	1d650513          	addi	a0,a0,470 # 80008608 <etext+0x608>
    8000443a:	ffffc097          	auipc	ra,0xffffc
    8000443e:	126080e7          	jalr	294(ra) # 80000560 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004442:	24c1                	addiw	s1,s1,16
    80004444:	04c92783          	lw	a5,76(s2)
    80004448:	04f4f763          	bgeu	s1,a5,80004496 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000444c:	4741                	li	a4,16
    8000444e:	86a6                	mv	a3,s1
    80004450:	fc040613          	addi	a2,s0,-64
    80004454:	4581                	li	a1,0
    80004456:	854a                	mv	a0,s2
    80004458:	00000097          	auipc	ra,0x0
    8000445c:	d4c080e7          	jalr	-692(ra) # 800041a4 <readi>
    80004460:	47c1                	li	a5,16
    80004462:	fcf518e3          	bne	a0,a5,80004432 <dirlookup+0x3a>
    if(de.inum == 0)
    80004466:	fc045783          	lhu	a5,-64(s0)
    8000446a:	dfe1                	beqz	a5,80004442 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000446c:	fc240593          	addi	a1,s0,-62
    80004470:	854e                	mv	a0,s3
    80004472:	00000097          	auipc	ra,0x0
    80004476:	f6c080e7          	jalr	-148(ra) # 800043de <namecmp>
    8000447a:	f561                	bnez	a0,80004442 <dirlookup+0x4a>
      if(poff)
    8000447c:	000a0463          	beqz	s4,80004484 <dirlookup+0x8c>
        *poff = off;
    80004480:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80004484:	fc045583          	lhu	a1,-64(s0)
    80004488:	00092503          	lw	a0,0(s2)
    8000448c:	fffff097          	auipc	ra,0xfffff
    80004490:	720080e7          	jalr	1824(ra) # 80003bac <iget>
    80004494:	a011                	j	80004498 <dirlookup+0xa0>
  return 0;
    80004496:	4501                	li	a0,0
}
    80004498:	70e2                	ld	ra,56(sp)
    8000449a:	7442                	ld	s0,48(sp)
    8000449c:	74a2                	ld	s1,40(sp)
    8000449e:	7902                	ld	s2,32(sp)
    800044a0:	69e2                	ld	s3,24(sp)
    800044a2:	6a42                	ld	s4,16(sp)
    800044a4:	6121                	addi	sp,sp,64
    800044a6:	8082                	ret

00000000800044a8 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800044a8:	711d                	addi	sp,sp,-96
    800044aa:	ec86                	sd	ra,88(sp)
    800044ac:	e8a2                	sd	s0,80(sp)
    800044ae:	e4a6                	sd	s1,72(sp)
    800044b0:	e0ca                	sd	s2,64(sp)
    800044b2:	fc4e                	sd	s3,56(sp)
    800044b4:	f852                	sd	s4,48(sp)
    800044b6:	f456                	sd	s5,40(sp)
    800044b8:	f05a                	sd	s6,32(sp)
    800044ba:	ec5e                	sd	s7,24(sp)
    800044bc:	e862                	sd	s8,16(sp)
    800044be:	e466                	sd	s9,8(sp)
    800044c0:	1080                	addi	s0,sp,96
    800044c2:	84aa                	mv	s1,a0
    800044c4:	8b2e                	mv	s6,a1
    800044c6:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800044c8:	00054703          	lbu	a4,0(a0)
    800044cc:	02f00793          	li	a5,47
    800044d0:	02f70263          	beq	a4,a5,800044f4 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800044d4:	ffffd097          	auipc	ra,0xffffd
    800044d8:	594080e7          	jalr	1428(ra) # 80001a68 <myproc>
    800044dc:	15853503          	ld	a0,344(a0)
    800044e0:	00000097          	auipc	ra,0x0
    800044e4:	9ce080e7          	jalr	-1586(ra) # 80003eae <idup>
    800044e8:	8a2a                	mv	s4,a0
  while(*path == '/')
    800044ea:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800044ee:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800044f0:	4b85                	li	s7,1
    800044f2:	a875                	j	800045ae <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    800044f4:	4585                	li	a1,1
    800044f6:	4505                	li	a0,1
    800044f8:	fffff097          	auipc	ra,0xfffff
    800044fc:	6b4080e7          	jalr	1716(ra) # 80003bac <iget>
    80004500:	8a2a                	mv	s4,a0
    80004502:	b7e5                	j	800044ea <namex+0x42>
      iunlockput(ip);
    80004504:	8552                	mv	a0,s4
    80004506:	00000097          	auipc	ra,0x0
    8000450a:	c4c080e7          	jalr	-948(ra) # 80004152 <iunlockput>
      return 0;
    8000450e:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80004510:	8552                	mv	a0,s4
    80004512:	60e6                	ld	ra,88(sp)
    80004514:	6446                	ld	s0,80(sp)
    80004516:	64a6                	ld	s1,72(sp)
    80004518:	6906                	ld	s2,64(sp)
    8000451a:	79e2                	ld	s3,56(sp)
    8000451c:	7a42                	ld	s4,48(sp)
    8000451e:	7aa2                	ld	s5,40(sp)
    80004520:	7b02                	ld	s6,32(sp)
    80004522:	6be2                	ld	s7,24(sp)
    80004524:	6c42                	ld	s8,16(sp)
    80004526:	6ca2                	ld	s9,8(sp)
    80004528:	6125                	addi	sp,sp,96
    8000452a:	8082                	ret
      iunlock(ip);
    8000452c:	8552                	mv	a0,s4
    8000452e:	00000097          	auipc	ra,0x0
    80004532:	a84080e7          	jalr	-1404(ra) # 80003fb2 <iunlock>
      return ip;
    80004536:	bfe9                	j	80004510 <namex+0x68>
      iunlockput(ip);
    80004538:	8552                	mv	a0,s4
    8000453a:	00000097          	auipc	ra,0x0
    8000453e:	c18080e7          	jalr	-1000(ra) # 80004152 <iunlockput>
      return 0;
    80004542:	8a4e                	mv	s4,s3
    80004544:	b7f1                	j	80004510 <namex+0x68>
  len = path - s;
    80004546:	40998633          	sub	a2,s3,s1
    8000454a:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    8000454e:	099c5863          	bge	s8,s9,800045de <namex+0x136>
    memmove(name, s, DIRSIZ);
    80004552:	4639                	li	a2,14
    80004554:	85a6                	mv	a1,s1
    80004556:	8556                	mv	a0,s5
    80004558:	ffffd097          	auipc	ra,0xffffd
    8000455c:	838080e7          	jalr	-1992(ra) # 80000d90 <memmove>
    80004560:	84ce                	mv	s1,s3
  while(*path == '/')
    80004562:	0004c783          	lbu	a5,0(s1)
    80004566:	01279763          	bne	a5,s2,80004574 <namex+0xcc>
    path++;
    8000456a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000456c:	0004c783          	lbu	a5,0(s1)
    80004570:	ff278de3          	beq	a5,s2,8000456a <namex+0xc2>
    ilock(ip);
    80004574:	8552                	mv	a0,s4
    80004576:	00000097          	auipc	ra,0x0
    8000457a:	976080e7          	jalr	-1674(ra) # 80003eec <ilock>
    if(ip->type != T_DIR){
    8000457e:	044a1783          	lh	a5,68(s4)
    80004582:	f97791e3          	bne	a5,s7,80004504 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80004586:	000b0563          	beqz	s6,80004590 <namex+0xe8>
    8000458a:	0004c783          	lbu	a5,0(s1)
    8000458e:	dfd9                	beqz	a5,8000452c <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004590:	4601                	li	a2,0
    80004592:	85d6                	mv	a1,s5
    80004594:	8552                	mv	a0,s4
    80004596:	00000097          	auipc	ra,0x0
    8000459a:	e62080e7          	jalr	-414(ra) # 800043f8 <dirlookup>
    8000459e:	89aa                	mv	s3,a0
    800045a0:	dd41                	beqz	a0,80004538 <namex+0x90>
    iunlockput(ip);
    800045a2:	8552                	mv	a0,s4
    800045a4:	00000097          	auipc	ra,0x0
    800045a8:	bae080e7          	jalr	-1106(ra) # 80004152 <iunlockput>
    ip = next;
    800045ac:	8a4e                	mv	s4,s3
  while(*path == '/')
    800045ae:	0004c783          	lbu	a5,0(s1)
    800045b2:	01279763          	bne	a5,s2,800045c0 <namex+0x118>
    path++;
    800045b6:	0485                	addi	s1,s1,1
  while(*path == '/')
    800045b8:	0004c783          	lbu	a5,0(s1)
    800045bc:	ff278de3          	beq	a5,s2,800045b6 <namex+0x10e>
  if(*path == 0)
    800045c0:	cb9d                	beqz	a5,800045f6 <namex+0x14e>
  while(*path != '/' && *path != 0)
    800045c2:	0004c783          	lbu	a5,0(s1)
    800045c6:	89a6                	mv	s3,s1
  len = path - s;
    800045c8:	4c81                	li	s9,0
    800045ca:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800045cc:	01278963          	beq	a5,s2,800045de <namex+0x136>
    800045d0:	dbbd                	beqz	a5,80004546 <namex+0x9e>
    path++;
    800045d2:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800045d4:	0009c783          	lbu	a5,0(s3)
    800045d8:	ff279ce3          	bne	a5,s2,800045d0 <namex+0x128>
    800045dc:	b7ad                	j	80004546 <namex+0x9e>
    memmove(name, s, len);
    800045de:	2601                	sext.w	a2,a2
    800045e0:	85a6                	mv	a1,s1
    800045e2:	8556                	mv	a0,s5
    800045e4:	ffffc097          	auipc	ra,0xffffc
    800045e8:	7ac080e7          	jalr	1964(ra) # 80000d90 <memmove>
    name[len] = 0;
    800045ec:	9cd6                	add	s9,s9,s5
    800045ee:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800045f2:	84ce                	mv	s1,s3
    800045f4:	b7bd                	j	80004562 <namex+0xba>
  if(nameiparent){
    800045f6:	f00b0de3          	beqz	s6,80004510 <namex+0x68>
    iput(ip);
    800045fa:	8552                	mv	a0,s4
    800045fc:	00000097          	auipc	ra,0x0
    80004600:	aae080e7          	jalr	-1362(ra) # 800040aa <iput>
    return 0;
    80004604:	4a01                	li	s4,0
    80004606:	b729                	j	80004510 <namex+0x68>

0000000080004608 <dirlink>:
{
    80004608:	7139                	addi	sp,sp,-64
    8000460a:	fc06                	sd	ra,56(sp)
    8000460c:	f822                	sd	s0,48(sp)
    8000460e:	f04a                	sd	s2,32(sp)
    80004610:	ec4e                	sd	s3,24(sp)
    80004612:	e852                	sd	s4,16(sp)
    80004614:	0080                	addi	s0,sp,64
    80004616:	892a                	mv	s2,a0
    80004618:	8a2e                	mv	s4,a1
    8000461a:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000461c:	4601                	li	a2,0
    8000461e:	00000097          	auipc	ra,0x0
    80004622:	dda080e7          	jalr	-550(ra) # 800043f8 <dirlookup>
    80004626:	ed25                	bnez	a0,8000469e <dirlink+0x96>
    80004628:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000462a:	04c92483          	lw	s1,76(s2)
    8000462e:	c49d                	beqz	s1,8000465c <dirlink+0x54>
    80004630:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004632:	4741                	li	a4,16
    80004634:	86a6                	mv	a3,s1
    80004636:	fc040613          	addi	a2,s0,-64
    8000463a:	4581                	li	a1,0
    8000463c:	854a                	mv	a0,s2
    8000463e:	00000097          	auipc	ra,0x0
    80004642:	b66080e7          	jalr	-1178(ra) # 800041a4 <readi>
    80004646:	47c1                	li	a5,16
    80004648:	06f51163          	bne	a0,a5,800046aa <dirlink+0xa2>
    if(de.inum == 0)
    8000464c:	fc045783          	lhu	a5,-64(s0)
    80004650:	c791                	beqz	a5,8000465c <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004652:	24c1                	addiw	s1,s1,16
    80004654:	04c92783          	lw	a5,76(s2)
    80004658:	fcf4ede3          	bltu	s1,a5,80004632 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000465c:	4639                	li	a2,14
    8000465e:	85d2                	mv	a1,s4
    80004660:	fc240513          	addi	a0,s0,-62
    80004664:	ffffc097          	auipc	ra,0xffffc
    80004668:	7d6080e7          	jalr	2006(ra) # 80000e3a <strncpy>
  de.inum = inum;
    8000466c:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004670:	4741                	li	a4,16
    80004672:	86a6                	mv	a3,s1
    80004674:	fc040613          	addi	a2,s0,-64
    80004678:	4581                	li	a1,0
    8000467a:	854a                	mv	a0,s2
    8000467c:	00000097          	auipc	ra,0x0
    80004680:	c38080e7          	jalr	-968(ra) # 800042b4 <writei>
    80004684:	1541                	addi	a0,a0,-16
    80004686:	00a03533          	snez	a0,a0
    8000468a:	40a00533          	neg	a0,a0
    8000468e:	74a2                	ld	s1,40(sp)
}
    80004690:	70e2                	ld	ra,56(sp)
    80004692:	7442                	ld	s0,48(sp)
    80004694:	7902                	ld	s2,32(sp)
    80004696:	69e2                	ld	s3,24(sp)
    80004698:	6a42                	ld	s4,16(sp)
    8000469a:	6121                	addi	sp,sp,64
    8000469c:	8082                	ret
    iput(ip);
    8000469e:	00000097          	auipc	ra,0x0
    800046a2:	a0c080e7          	jalr	-1524(ra) # 800040aa <iput>
    return -1;
    800046a6:	557d                	li	a0,-1
    800046a8:	b7e5                	j	80004690 <dirlink+0x88>
      panic("dirlink read");
    800046aa:	00004517          	auipc	a0,0x4
    800046ae:	f6e50513          	addi	a0,a0,-146 # 80008618 <etext+0x618>
    800046b2:	ffffc097          	auipc	ra,0xffffc
    800046b6:	eae080e7          	jalr	-338(ra) # 80000560 <panic>

00000000800046ba <namei>:

struct inode*
namei(char *path)
{
    800046ba:	1101                	addi	sp,sp,-32
    800046bc:	ec06                	sd	ra,24(sp)
    800046be:	e822                	sd	s0,16(sp)
    800046c0:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800046c2:	fe040613          	addi	a2,s0,-32
    800046c6:	4581                	li	a1,0
    800046c8:	00000097          	auipc	ra,0x0
    800046cc:	de0080e7          	jalr	-544(ra) # 800044a8 <namex>
}
    800046d0:	60e2                	ld	ra,24(sp)
    800046d2:	6442                	ld	s0,16(sp)
    800046d4:	6105                	addi	sp,sp,32
    800046d6:	8082                	ret

00000000800046d8 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800046d8:	1141                	addi	sp,sp,-16
    800046da:	e406                	sd	ra,8(sp)
    800046dc:	e022                	sd	s0,0(sp)
    800046de:	0800                	addi	s0,sp,16
    800046e0:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800046e2:	4585                	li	a1,1
    800046e4:	00000097          	auipc	ra,0x0
    800046e8:	dc4080e7          	jalr	-572(ra) # 800044a8 <namex>
}
    800046ec:	60a2                	ld	ra,8(sp)
    800046ee:	6402                	ld	s0,0(sp)
    800046f0:	0141                	addi	sp,sp,16
    800046f2:	8082                	ret

00000000800046f4 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800046f4:	1101                	addi	sp,sp,-32
    800046f6:	ec06                	sd	ra,24(sp)
    800046f8:	e822                	sd	s0,16(sp)
    800046fa:	e426                	sd	s1,8(sp)
    800046fc:	e04a                	sd	s2,0(sp)
    800046fe:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004700:	00020917          	auipc	s2,0x20
    80004704:	9d890913          	addi	s2,s2,-1576 # 800240d8 <log>
    80004708:	01892583          	lw	a1,24(s2)
    8000470c:	02892503          	lw	a0,40(s2)
    80004710:	fffff097          	auipc	ra,0xfffff
    80004714:	fa8080e7          	jalr	-88(ra) # 800036b8 <bread>
    80004718:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000471a:	02c92603          	lw	a2,44(s2)
    8000471e:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004720:	00c05f63          	blez	a2,8000473e <write_head+0x4a>
    80004724:	00020717          	auipc	a4,0x20
    80004728:	9e470713          	addi	a4,a4,-1564 # 80024108 <log+0x30>
    8000472c:	87aa                	mv	a5,a0
    8000472e:	060a                	slli	a2,a2,0x2
    80004730:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80004732:	4314                	lw	a3,0(a4)
    80004734:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80004736:	0711                	addi	a4,a4,4
    80004738:	0791                	addi	a5,a5,4
    8000473a:	fec79ce3          	bne	a5,a2,80004732 <write_head+0x3e>
  }
  bwrite(buf);
    8000473e:	8526                	mv	a0,s1
    80004740:	fffff097          	auipc	ra,0xfffff
    80004744:	06a080e7          	jalr	106(ra) # 800037aa <bwrite>
  brelse(buf);
    80004748:	8526                	mv	a0,s1
    8000474a:	fffff097          	auipc	ra,0xfffff
    8000474e:	09e080e7          	jalr	158(ra) # 800037e8 <brelse>
}
    80004752:	60e2                	ld	ra,24(sp)
    80004754:	6442                	ld	s0,16(sp)
    80004756:	64a2                	ld	s1,8(sp)
    80004758:	6902                	ld	s2,0(sp)
    8000475a:	6105                	addi	sp,sp,32
    8000475c:	8082                	ret

000000008000475e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000475e:	00020797          	auipc	a5,0x20
    80004762:	9a67a783          	lw	a5,-1626(a5) # 80024104 <log+0x2c>
    80004766:	0af05d63          	blez	a5,80004820 <install_trans+0xc2>
{
    8000476a:	7139                	addi	sp,sp,-64
    8000476c:	fc06                	sd	ra,56(sp)
    8000476e:	f822                	sd	s0,48(sp)
    80004770:	f426                	sd	s1,40(sp)
    80004772:	f04a                	sd	s2,32(sp)
    80004774:	ec4e                	sd	s3,24(sp)
    80004776:	e852                	sd	s4,16(sp)
    80004778:	e456                	sd	s5,8(sp)
    8000477a:	e05a                	sd	s6,0(sp)
    8000477c:	0080                	addi	s0,sp,64
    8000477e:	8b2a                	mv	s6,a0
    80004780:	00020a97          	auipc	s5,0x20
    80004784:	988a8a93          	addi	s5,s5,-1656 # 80024108 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004788:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000478a:	00020997          	auipc	s3,0x20
    8000478e:	94e98993          	addi	s3,s3,-1714 # 800240d8 <log>
    80004792:	a00d                	j	800047b4 <install_trans+0x56>
    brelse(lbuf);
    80004794:	854a                	mv	a0,s2
    80004796:	fffff097          	auipc	ra,0xfffff
    8000479a:	052080e7          	jalr	82(ra) # 800037e8 <brelse>
    brelse(dbuf);
    8000479e:	8526                	mv	a0,s1
    800047a0:	fffff097          	auipc	ra,0xfffff
    800047a4:	048080e7          	jalr	72(ra) # 800037e8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800047a8:	2a05                	addiw	s4,s4,1
    800047aa:	0a91                	addi	s5,s5,4
    800047ac:	02c9a783          	lw	a5,44(s3)
    800047b0:	04fa5e63          	bge	s4,a5,8000480c <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800047b4:	0189a583          	lw	a1,24(s3)
    800047b8:	014585bb          	addw	a1,a1,s4
    800047bc:	2585                	addiw	a1,a1,1
    800047be:	0289a503          	lw	a0,40(s3)
    800047c2:	fffff097          	auipc	ra,0xfffff
    800047c6:	ef6080e7          	jalr	-266(ra) # 800036b8 <bread>
    800047ca:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800047cc:	000aa583          	lw	a1,0(s5)
    800047d0:	0289a503          	lw	a0,40(s3)
    800047d4:	fffff097          	auipc	ra,0xfffff
    800047d8:	ee4080e7          	jalr	-284(ra) # 800036b8 <bread>
    800047dc:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800047de:	40000613          	li	a2,1024
    800047e2:	05890593          	addi	a1,s2,88
    800047e6:	05850513          	addi	a0,a0,88
    800047ea:	ffffc097          	auipc	ra,0xffffc
    800047ee:	5a6080e7          	jalr	1446(ra) # 80000d90 <memmove>
    bwrite(dbuf);  // write dst to disk
    800047f2:	8526                	mv	a0,s1
    800047f4:	fffff097          	auipc	ra,0xfffff
    800047f8:	fb6080e7          	jalr	-74(ra) # 800037aa <bwrite>
    if(recovering == 0)
    800047fc:	f80b1ce3          	bnez	s6,80004794 <install_trans+0x36>
      bunpin(dbuf);
    80004800:	8526                	mv	a0,s1
    80004802:	fffff097          	auipc	ra,0xfffff
    80004806:	0be080e7          	jalr	190(ra) # 800038c0 <bunpin>
    8000480a:	b769                	j	80004794 <install_trans+0x36>
}
    8000480c:	70e2                	ld	ra,56(sp)
    8000480e:	7442                	ld	s0,48(sp)
    80004810:	74a2                	ld	s1,40(sp)
    80004812:	7902                	ld	s2,32(sp)
    80004814:	69e2                	ld	s3,24(sp)
    80004816:	6a42                	ld	s4,16(sp)
    80004818:	6aa2                	ld	s5,8(sp)
    8000481a:	6b02                	ld	s6,0(sp)
    8000481c:	6121                	addi	sp,sp,64
    8000481e:	8082                	ret
    80004820:	8082                	ret

0000000080004822 <initlog>:
{
    80004822:	7179                	addi	sp,sp,-48
    80004824:	f406                	sd	ra,40(sp)
    80004826:	f022                	sd	s0,32(sp)
    80004828:	ec26                	sd	s1,24(sp)
    8000482a:	e84a                	sd	s2,16(sp)
    8000482c:	e44e                	sd	s3,8(sp)
    8000482e:	1800                	addi	s0,sp,48
    80004830:	892a                	mv	s2,a0
    80004832:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004834:	00020497          	auipc	s1,0x20
    80004838:	8a448493          	addi	s1,s1,-1884 # 800240d8 <log>
    8000483c:	00004597          	auipc	a1,0x4
    80004840:	dec58593          	addi	a1,a1,-532 # 80008628 <etext+0x628>
    80004844:	8526                	mv	a0,s1
    80004846:	ffffc097          	auipc	ra,0xffffc
    8000484a:	362080e7          	jalr	866(ra) # 80000ba8 <initlock>
  log.start = sb->logstart;
    8000484e:	0149a583          	lw	a1,20(s3)
    80004852:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004854:	0109a783          	lw	a5,16(s3)
    80004858:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000485a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000485e:	854a                	mv	a0,s2
    80004860:	fffff097          	auipc	ra,0xfffff
    80004864:	e58080e7          	jalr	-424(ra) # 800036b8 <bread>
  log.lh.n = lh->n;
    80004868:	4d30                	lw	a2,88(a0)
    8000486a:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000486c:	00c05f63          	blez	a2,8000488a <initlog+0x68>
    80004870:	87aa                	mv	a5,a0
    80004872:	00020717          	auipc	a4,0x20
    80004876:	89670713          	addi	a4,a4,-1898 # 80024108 <log+0x30>
    8000487a:	060a                	slli	a2,a2,0x2
    8000487c:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000487e:	4ff4                	lw	a3,92(a5)
    80004880:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004882:	0791                	addi	a5,a5,4
    80004884:	0711                	addi	a4,a4,4
    80004886:	fec79ce3          	bne	a5,a2,8000487e <initlog+0x5c>
  brelse(buf);
    8000488a:	fffff097          	auipc	ra,0xfffff
    8000488e:	f5e080e7          	jalr	-162(ra) # 800037e8 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004892:	4505                	li	a0,1
    80004894:	00000097          	auipc	ra,0x0
    80004898:	eca080e7          	jalr	-310(ra) # 8000475e <install_trans>
  log.lh.n = 0;
    8000489c:	00020797          	auipc	a5,0x20
    800048a0:	8607a423          	sw	zero,-1944(a5) # 80024104 <log+0x2c>
  write_head(); // clear the log
    800048a4:	00000097          	auipc	ra,0x0
    800048a8:	e50080e7          	jalr	-432(ra) # 800046f4 <write_head>
}
    800048ac:	70a2                	ld	ra,40(sp)
    800048ae:	7402                	ld	s0,32(sp)
    800048b0:	64e2                	ld	s1,24(sp)
    800048b2:	6942                	ld	s2,16(sp)
    800048b4:	69a2                	ld	s3,8(sp)
    800048b6:	6145                	addi	sp,sp,48
    800048b8:	8082                	ret

00000000800048ba <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800048ba:	1101                	addi	sp,sp,-32
    800048bc:	ec06                	sd	ra,24(sp)
    800048be:	e822                	sd	s0,16(sp)
    800048c0:	e426                	sd	s1,8(sp)
    800048c2:	e04a                	sd	s2,0(sp)
    800048c4:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800048c6:	00020517          	auipc	a0,0x20
    800048ca:	81250513          	addi	a0,a0,-2030 # 800240d8 <log>
    800048ce:	ffffc097          	auipc	ra,0xffffc
    800048d2:	36a080e7          	jalr	874(ra) # 80000c38 <acquire>
  while(1){
    if(log.committing){
    800048d6:	00020497          	auipc	s1,0x20
    800048da:	80248493          	addi	s1,s1,-2046 # 800240d8 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800048de:	4979                	li	s2,30
    800048e0:	a039                	j	800048ee <begin_op+0x34>
      sleep(&log, &log.lock);
    800048e2:	85a6                	mv	a1,s1
    800048e4:	8526                	mv	a0,s1
    800048e6:	ffffe097          	auipc	ra,0xffffe
    800048ea:	e0e080e7          	jalr	-498(ra) # 800026f4 <sleep>
    if(log.committing){
    800048ee:	50dc                	lw	a5,36(s1)
    800048f0:	fbed                	bnez	a5,800048e2 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800048f2:	5098                	lw	a4,32(s1)
    800048f4:	2705                	addiw	a4,a4,1
    800048f6:	0027179b          	slliw	a5,a4,0x2
    800048fa:	9fb9                	addw	a5,a5,a4
    800048fc:	0017979b          	slliw	a5,a5,0x1
    80004900:	54d4                	lw	a3,44(s1)
    80004902:	9fb5                	addw	a5,a5,a3
    80004904:	00f95963          	bge	s2,a5,80004916 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004908:	85a6                	mv	a1,s1
    8000490a:	8526                	mv	a0,s1
    8000490c:	ffffe097          	auipc	ra,0xffffe
    80004910:	de8080e7          	jalr	-536(ra) # 800026f4 <sleep>
    80004914:	bfe9                	j	800048ee <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004916:	0001f517          	auipc	a0,0x1f
    8000491a:	7c250513          	addi	a0,a0,1986 # 800240d8 <log>
    8000491e:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80004920:	ffffc097          	auipc	ra,0xffffc
    80004924:	3cc080e7          	jalr	972(ra) # 80000cec <release>
      break;
    }
  }
}
    80004928:	60e2                	ld	ra,24(sp)
    8000492a:	6442                	ld	s0,16(sp)
    8000492c:	64a2                	ld	s1,8(sp)
    8000492e:	6902                	ld	s2,0(sp)
    80004930:	6105                	addi	sp,sp,32
    80004932:	8082                	ret

0000000080004934 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004934:	7139                	addi	sp,sp,-64
    80004936:	fc06                	sd	ra,56(sp)
    80004938:	f822                	sd	s0,48(sp)
    8000493a:	f426                	sd	s1,40(sp)
    8000493c:	f04a                	sd	s2,32(sp)
    8000493e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004940:	0001f497          	auipc	s1,0x1f
    80004944:	79848493          	addi	s1,s1,1944 # 800240d8 <log>
    80004948:	8526                	mv	a0,s1
    8000494a:	ffffc097          	auipc	ra,0xffffc
    8000494e:	2ee080e7          	jalr	750(ra) # 80000c38 <acquire>
  log.outstanding -= 1;
    80004952:	509c                	lw	a5,32(s1)
    80004954:	37fd                	addiw	a5,a5,-1
    80004956:	0007891b          	sext.w	s2,a5
    8000495a:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000495c:	50dc                	lw	a5,36(s1)
    8000495e:	e7b9                	bnez	a5,800049ac <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    80004960:	06091163          	bnez	s2,800049c2 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004964:	0001f497          	auipc	s1,0x1f
    80004968:	77448493          	addi	s1,s1,1908 # 800240d8 <log>
    8000496c:	4785                	li	a5,1
    8000496e:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004970:	8526                	mv	a0,s1
    80004972:	ffffc097          	auipc	ra,0xffffc
    80004976:	37a080e7          	jalr	890(ra) # 80000cec <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000497a:	54dc                	lw	a5,44(s1)
    8000497c:	06f04763          	bgtz	a5,800049ea <end_op+0xb6>
    acquire(&log.lock);
    80004980:	0001f497          	auipc	s1,0x1f
    80004984:	75848493          	addi	s1,s1,1880 # 800240d8 <log>
    80004988:	8526                	mv	a0,s1
    8000498a:	ffffc097          	auipc	ra,0xffffc
    8000498e:	2ae080e7          	jalr	686(ra) # 80000c38 <acquire>
    log.committing = 0;
    80004992:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004996:	8526                	mv	a0,s1
    80004998:	ffffe097          	auipc	ra,0xffffe
    8000499c:	dc0080e7          	jalr	-576(ra) # 80002758 <wakeup>
    release(&log.lock);
    800049a0:	8526                	mv	a0,s1
    800049a2:	ffffc097          	auipc	ra,0xffffc
    800049a6:	34a080e7          	jalr	842(ra) # 80000cec <release>
}
    800049aa:	a815                	j	800049de <end_op+0xaa>
    800049ac:	ec4e                	sd	s3,24(sp)
    800049ae:	e852                	sd	s4,16(sp)
    800049b0:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800049b2:	00004517          	auipc	a0,0x4
    800049b6:	c7e50513          	addi	a0,a0,-898 # 80008630 <etext+0x630>
    800049ba:	ffffc097          	auipc	ra,0xffffc
    800049be:	ba6080e7          	jalr	-1114(ra) # 80000560 <panic>
    wakeup(&log);
    800049c2:	0001f497          	auipc	s1,0x1f
    800049c6:	71648493          	addi	s1,s1,1814 # 800240d8 <log>
    800049ca:	8526                	mv	a0,s1
    800049cc:	ffffe097          	auipc	ra,0xffffe
    800049d0:	d8c080e7          	jalr	-628(ra) # 80002758 <wakeup>
  release(&log.lock);
    800049d4:	8526                	mv	a0,s1
    800049d6:	ffffc097          	auipc	ra,0xffffc
    800049da:	316080e7          	jalr	790(ra) # 80000cec <release>
}
    800049de:	70e2                	ld	ra,56(sp)
    800049e0:	7442                	ld	s0,48(sp)
    800049e2:	74a2                	ld	s1,40(sp)
    800049e4:	7902                	ld	s2,32(sp)
    800049e6:	6121                	addi	sp,sp,64
    800049e8:	8082                	ret
    800049ea:	ec4e                	sd	s3,24(sp)
    800049ec:	e852                	sd	s4,16(sp)
    800049ee:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800049f0:	0001fa97          	auipc	s5,0x1f
    800049f4:	718a8a93          	addi	s5,s5,1816 # 80024108 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800049f8:	0001fa17          	auipc	s4,0x1f
    800049fc:	6e0a0a13          	addi	s4,s4,1760 # 800240d8 <log>
    80004a00:	018a2583          	lw	a1,24(s4)
    80004a04:	012585bb          	addw	a1,a1,s2
    80004a08:	2585                	addiw	a1,a1,1
    80004a0a:	028a2503          	lw	a0,40(s4)
    80004a0e:	fffff097          	auipc	ra,0xfffff
    80004a12:	caa080e7          	jalr	-854(ra) # 800036b8 <bread>
    80004a16:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004a18:	000aa583          	lw	a1,0(s5)
    80004a1c:	028a2503          	lw	a0,40(s4)
    80004a20:	fffff097          	auipc	ra,0xfffff
    80004a24:	c98080e7          	jalr	-872(ra) # 800036b8 <bread>
    80004a28:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004a2a:	40000613          	li	a2,1024
    80004a2e:	05850593          	addi	a1,a0,88
    80004a32:	05848513          	addi	a0,s1,88
    80004a36:	ffffc097          	auipc	ra,0xffffc
    80004a3a:	35a080e7          	jalr	858(ra) # 80000d90 <memmove>
    bwrite(to);  // write the log
    80004a3e:	8526                	mv	a0,s1
    80004a40:	fffff097          	auipc	ra,0xfffff
    80004a44:	d6a080e7          	jalr	-662(ra) # 800037aa <bwrite>
    brelse(from);
    80004a48:	854e                	mv	a0,s3
    80004a4a:	fffff097          	auipc	ra,0xfffff
    80004a4e:	d9e080e7          	jalr	-610(ra) # 800037e8 <brelse>
    brelse(to);
    80004a52:	8526                	mv	a0,s1
    80004a54:	fffff097          	auipc	ra,0xfffff
    80004a58:	d94080e7          	jalr	-620(ra) # 800037e8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004a5c:	2905                	addiw	s2,s2,1
    80004a5e:	0a91                	addi	s5,s5,4
    80004a60:	02ca2783          	lw	a5,44(s4)
    80004a64:	f8f94ee3          	blt	s2,a5,80004a00 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004a68:	00000097          	auipc	ra,0x0
    80004a6c:	c8c080e7          	jalr	-884(ra) # 800046f4 <write_head>
    install_trans(0); // Now install writes to home locations
    80004a70:	4501                	li	a0,0
    80004a72:	00000097          	auipc	ra,0x0
    80004a76:	cec080e7          	jalr	-788(ra) # 8000475e <install_trans>
    log.lh.n = 0;
    80004a7a:	0001f797          	auipc	a5,0x1f
    80004a7e:	6807a523          	sw	zero,1674(a5) # 80024104 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004a82:	00000097          	auipc	ra,0x0
    80004a86:	c72080e7          	jalr	-910(ra) # 800046f4 <write_head>
    80004a8a:	69e2                	ld	s3,24(sp)
    80004a8c:	6a42                	ld	s4,16(sp)
    80004a8e:	6aa2                	ld	s5,8(sp)
    80004a90:	bdc5                	j	80004980 <end_op+0x4c>

0000000080004a92 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004a92:	1101                	addi	sp,sp,-32
    80004a94:	ec06                	sd	ra,24(sp)
    80004a96:	e822                	sd	s0,16(sp)
    80004a98:	e426                	sd	s1,8(sp)
    80004a9a:	e04a                	sd	s2,0(sp)
    80004a9c:	1000                	addi	s0,sp,32
    80004a9e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004aa0:	0001f917          	auipc	s2,0x1f
    80004aa4:	63890913          	addi	s2,s2,1592 # 800240d8 <log>
    80004aa8:	854a                	mv	a0,s2
    80004aaa:	ffffc097          	auipc	ra,0xffffc
    80004aae:	18e080e7          	jalr	398(ra) # 80000c38 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004ab2:	02c92603          	lw	a2,44(s2)
    80004ab6:	47f5                	li	a5,29
    80004ab8:	06c7c563          	blt	a5,a2,80004b22 <log_write+0x90>
    80004abc:	0001f797          	auipc	a5,0x1f
    80004ac0:	6387a783          	lw	a5,1592(a5) # 800240f4 <log+0x1c>
    80004ac4:	37fd                	addiw	a5,a5,-1
    80004ac6:	04f65e63          	bge	a2,a5,80004b22 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004aca:	0001f797          	auipc	a5,0x1f
    80004ace:	62e7a783          	lw	a5,1582(a5) # 800240f8 <log+0x20>
    80004ad2:	06f05063          	blez	a5,80004b32 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004ad6:	4781                	li	a5,0
    80004ad8:	06c05563          	blez	a2,80004b42 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004adc:	44cc                	lw	a1,12(s1)
    80004ade:	0001f717          	auipc	a4,0x1f
    80004ae2:	62a70713          	addi	a4,a4,1578 # 80024108 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004ae6:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004ae8:	4314                	lw	a3,0(a4)
    80004aea:	04b68c63          	beq	a3,a1,80004b42 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80004aee:	2785                	addiw	a5,a5,1
    80004af0:	0711                	addi	a4,a4,4
    80004af2:	fef61be3          	bne	a2,a5,80004ae8 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004af6:	0621                	addi	a2,a2,8
    80004af8:	060a                	slli	a2,a2,0x2
    80004afa:	0001f797          	auipc	a5,0x1f
    80004afe:	5de78793          	addi	a5,a5,1502 # 800240d8 <log>
    80004b02:	97b2                	add	a5,a5,a2
    80004b04:	44d8                	lw	a4,12(s1)
    80004b06:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004b08:	8526                	mv	a0,s1
    80004b0a:	fffff097          	auipc	ra,0xfffff
    80004b0e:	d7a080e7          	jalr	-646(ra) # 80003884 <bpin>
    log.lh.n++;
    80004b12:	0001f717          	auipc	a4,0x1f
    80004b16:	5c670713          	addi	a4,a4,1478 # 800240d8 <log>
    80004b1a:	575c                	lw	a5,44(a4)
    80004b1c:	2785                	addiw	a5,a5,1
    80004b1e:	d75c                	sw	a5,44(a4)
    80004b20:	a82d                	j	80004b5a <log_write+0xc8>
    panic("too big a transaction");
    80004b22:	00004517          	auipc	a0,0x4
    80004b26:	b1e50513          	addi	a0,a0,-1250 # 80008640 <etext+0x640>
    80004b2a:	ffffc097          	auipc	ra,0xffffc
    80004b2e:	a36080e7          	jalr	-1482(ra) # 80000560 <panic>
    panic("log_write outside of trans");
    80004b32:	00004517          	auipc	a0,0x4
    80004b36:	b2650513          	addi	a0,a0,-1242 # 80008658 <etext+0x658>
    80004b3a:	ffffc097          	auipc	ra,0xffffc
    80004b3e:	a26080e7          	jalr	-1498(ra) # 80000560 <panic>
  log.lh.block[i] = b->blockno;
    80004b42:	00878693          	addi	a3,a5,8
    80004b46:	068a                	slli	a3,a3,0x2
    80004b48:	0001f717          	auipc	a4,0x1f
    80004b4c:	59070713          	addi	a4,a4,1424 # 800240d8 <log>
    80004b50:	9736                	add	a4,a4,a3
    80004b52:	44d4                	lw	a3,12(s1)
    80004b54:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004b56:	faf609e3          	beq	a2,a5,80004b08 <log_write+0x76>
  }
  release(&log.lock);
    80004b5a:	0001f517          	auipc	a0,0x1f
    80004b5e:	57e50513          	addi	a0,a0,1406 # 800240d8 <log>
    80004b62:	ffffc097          	auipc	ra,0xffffc
    80004b66:	18a080e7          	jalr	394(ra) # 80000cec <release>
}
    80004b6a:	60e2                	ld	ra,24(sp)
    80004b6c:	6442                	ld	s0,16(sp)
    80004b6e:	64a2                	ld	s1,8(sp)
    80004b70:	6902                	ld	s2,0(sp)
    80004b72:	6105                	addi	sp,sp,32
    80004b74:	8082                	ret

0000000080004b76 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004b76:	1101                	addi	sp,sp,-32
    80004b78:	ec06                	sd	ra,24(sp)
    80004b7a:	e822                	sd	s0,16(sp)
    80004b7c:	e426                	sd	s1,8(sp)
    80004b7e:	e04a                	sd	s2,0(sp)
    80004b80:	1000                	addi	s0,sp,32
    80004b82:	84aa                	mv	s1,a0
    80004b84:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004b86:	00004597          	auipc	a1,0x4
    80004b8a:	af258593          	addi	a1,a1,-1294 # 80008678 <etext+0x678>
    80004b8e:	0521                	addi	a0,a0,8
    80004b90:	ffffc097          	auipc	ra,0xffffc
    80004b94:	018080e7          	jalr	24(ra) # 80000ba8 <initlock>
  lk->name = name;
    80004b98:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004b9c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004ba0:	0204a423          	sw	zero,40(s1)
}
    80004ba4:	60e2                	ld	ra,24(sp)
    80004ba6:	6442                	ld	s0,16(sp)
    80004ba8:	64a2                	ld	s1,8(sp)
    80004baa:	6902                	ld	s2,0(sp)
    80004bac:	6105                	addi	sp,sp,32
    80004bae:	8082                	ret

0000000080004bb0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004bb0:	1101                	addi	sp,sp,-32
    80004bb2:	ec06                	sd	ra,24(sp)
    80004bb4:	e822                	sd	s0,16(sp)
    80004bb6:	e426                	sd	s1,8(sp)
    80004bb8:	e04a                	sd	s2,0(sp)
    80004bba:	1000                	addi	s0,sp,32
    80004bbc:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004bbe:	00850913          	addi	s2,a0,8
    80004bc2:	854a                	mv	a0,s2
    80004bc4:	ffffc097          	auipc	ra,0xffffc
    80004bc8:	074080e7          	jalr	116(ra) # 80000c38 <acquire>
  while (lk->locked) {
    80004bcc:	409c                	lw	a5,0(s1)
    80004bce:	cb89                	beqz	a5,80004be0 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004bd0:	85ca                	mv	a1,s2
    80004bd2:	8526                	mv	a0,s1
    80004bd4:	ffffe097          	auipc	ra,0xffffe
    80004bd8:	b20080e7          	jalr	-1248(ra) # 800026f4 <sleep>
  while (lk->locked) {
    80004bdc:	409c                	lw	a5,0(s1)
    80004bde:	fbed                	bnez	a5,80004bd0 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004be0:	4785                	li	a5,1
    80004be2:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004be4:	ffffd097          	auipc	ra,0xffffd
    80004be8:	e84080e7          	jalr	-380(ra) # 80001a68 <myproc>
    80004bec:	591c                	lw	a5,48(a0)
    80004bee:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004bf0:	854a                	mv	a0,s2
    80004bf2:	ffffc097          	auipc	ra,0xffffc
    80004bf6:	0fa080e7          	jalr	250(ra) # 80000cec <release>
}
    80004bfa:	60e2                	ld	ra,24(sp)
    80004bfc:	6442                	ld	s0,16(sp)
    80004bfe:	64a2                	ld	s1,8(sp)
    80004c00:	6902                	ld	s2,0(sp)
    80004c02:	6105                	addi	sp,sp,32
    80004c04:	8082                	ret

0000000080004c06 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004c06:	1101                	addi	sp,sp,-32
    80004c08:	ec06                	sd	ra,24(sp)
    80004c0a:	e822                	sd	s0,16(sp)
    80004c0c:	e426                	sd	s1,8(sp)
    80004c0e:	e04a                	sd	s2,0(sp)
    80004c10:	1000                	addi	s0,sp,32
    80004c12:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004c14:	00850913          	addi	s2,a0,8
    80004c18:	854a                	mv	a0,s2
    80004c1a:	ffffc097          	auipc	ra,0xffffc
    80004c1e:	01e080e7          	jalr	30(ra) # 80000c38 <acquire>
  lk->locked = 0;
    80004c22:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004c26:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004c2a:	8526                	mv	a0,s1
    80004c2c:	ffffe097          	auipc	ra,0xffffe
    80004c30:	b2c080e7          	jalr	-1236(ra) # 80002758 <wakeup>
  release(&lk->lk);
    80004c34:	854a                	mv	a0,s2
    80004c36:	ffffc097          	auipc	ra,0xffffc
    80004c3a:	0b6080e7          	jalr	182(ra) # 80000cec <release>
}
    80004c3e:	60e2                	ld	ra,24(sp)
    80004c40:	6442                	ld	s0,16(sp)
    80004c42:	64a2                	ld	s1,8(sp)
    80004c44:	6902                	ld	s2,0(sp)
    80004c46:	6105                	addi	sp,sp,32
    80004c48:	8082                	ret

0000000080004c4a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004c4a:	7179                	addi	sp,sp,-48
    80004c4c:	f406                	sd	ra,40(sp)
    80004c4e:	f022                	sd	s0,32(sp)
    80004c50:	ec26                	sd	s1,24(sp)
    80004c52:	e84a                	sd	s2,16(sp)
    80004c54:	1800                	addi	s0,sp,48
    80004c56:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004c58:	00850913          	addi	s2,a0,8
    80004c5c:	854a                	mv	a0,s2
    80004c5e:	ffffc097          	auipc	ra,0xffffc
    80004c62:	fda080e7          	jalr	-38(ra) # 80000c38 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004c66:	409c                	lw	a5,0(s1)
    80004c68:	ef91                	bnez	a5,80004c84 <holdingsleep+0x3a>
    80004c6a:	4481                	li	s1,0
  release(&lk->lk);
    80004c6c:	854a                	mv	a0,s2
    80004c6e:	ffffc097          	auipc	ra,0xffffc
    80004c72:	07e080e7          	jalr	126(ra) # 80000cec <release>
  return r;
}
    80004c76:	8526                	mv	a0,s1
    80004c78:	70a2                	ld	ra,40(sp)
    80004c7a:	7402                	ld	s0,32(sp)
    80004c7c:	64e2                	ld	s1,24(sp)
    80004c7e:	6942                	ld	s2,16(sp)
    80004c80:	6145                	addi	sp,sp,48
    80004c82:	8082                	ret
    80004c84:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004c86:	0284a983          	lw	s3,40(s1)
    80004c8a:	ffffd097          	auipc	ra,0xffffd
    80004c8e:	dde080e7          	jalr	-546(ra) # 80001a68 <myproc>
    80004c92:	5904                	lw	s1,48(a0)
    80004c94:	413484b3          	sub	s1,s1,s3
    80004c98:	0014b493          	seqz	s1,s1
    80004c9c:	69a2                	ld	s3,8(sp)
    80004c9e:	b7f9                	j	80004c6c <holdingsleep+0x22>

0000000080004ca0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004ca0:	1141                	addi	sp,sp,-16
    80004ca2:	e406                	sd	ra,8(sp)
    80004ca4:	e022                	sd	s0,0(sp)
    80004ca6:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004ca8:	00004597          	auipc	a1,0x4
    80004cac:	9e058593          	addi	a1,a1,-1568 # 80008688 <etext+0x688>
    80004cb0:	0001f517          	auipc	a0,0x1f
    80004cb4:	57050513          	addi	a0,a0,1392 # 80024220 <ftable>
    80004cb8:	ffffc097          	auipc	ra,0xffffc
    80004cbc:	ef0080e7          	jalr	-272(ra) # 80000ba8 <initlock>
}
    80004cc0:	60a2                	ld	ra,8(sp)
    80004cc2:	6402                	ld	s0,0(sp)
    80004cc4:	0141                	addi	sp,sp,16
    80004cc6:	8082                	ret

0000000080004cc8 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004cc8:	1101                	addi	sp,sp,-32
    80004cca:	ec06                	sd	ra,24(sp)
    80004ccc:	e822                	sd	s0,16(sp)
    80004cce:	e426                	sd	s1,8(sp)
    80004cd0:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004cd2:	0001f517          	auipc	a0,0x1f
    80004cd6:	54e50513          	addi	a0,a0,1358 # 80024220 <ftable>
    80004cda:	ffffc097          	auipc	ra,0xffffc
    80004cde:	f5e080e7          	jalr	-162(ra) # 80000c38 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004ce2:	0001f497          	auipc	s1,0x1f
    80004ce6:	55648493          	addi	s1,s1,1366 # 80024238 <ftable+0x18>
    80004cea:	00020717          	auipc	a4,0x20
    80004cee:	4ee70713          	addi	a4,a4,1262 # 800251d8 <disk>
    if(f->ref == 0){
    80004cf2:	40dc                	lw	a5,4(s1)
    80004cf4:	cf99                	beqz	a5,80004d12 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004cf6:	02848493          	addi	s1,s1,40
    80004cfa:	fee49ce3          	bne	s1,a4,80004cf2 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004cfe:	0001f517          	auipc	a0,0x1f
    80004d02:	52250513          	addi	a0,a0,1314 # 80024220 <ftable>
    80004d06:	ffffc097          	auipc	ra,0xffffc
    80004d0a:	fe6080e7          	jalr	-26(ra) # 80000cec <release>
  return 0;
    80004d0e:	4481                	li	s1,0
    80004d10:	a819                	j	80004d26 <filealloc+0x5e>
      f->ref = 1;
    80004d12:	4785                	li	a5,1
    80004d14:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004d16:	0001f517          	auipc	a0,0x1f
    80004d1a:	50a50513          	addi	a0,a0,1290 # 80024220 <ftable>
    80004d1e:	ffffc097          	auipc	ra,0xffffc
    80004d22:	fce080e7          	jalr	-50(ra) # 80000cec <release>
}
    80004d26:	8526                	mv	a0,s1
    80004d28:	60e2                	ld	ra,24(sp)
    80004d2a:	6442                	ld	s0,16(sp)
    80004d2c:	64a2                	ld	s1,8(sp)
    80004d2e:	6105                	addi	sp,sp,32
    80004d30:	8082                	ret

0000000080004d32 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004d32:	1101                	addi	sp,sp,-32
    80004d34:	ec06                	sd	ra,24(sp)
    80004d36:	e822                	sd	s0,16(sp)
    80004d38:	e426                	sd	s1,8(sp)
    80004d3a:	1000                	addi	s0,sp,32
    80004d3c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004d3e:	0001f517          	auipc	a0,0x1f
    80004d42:	4e250513          	addi	a0,a0,1250 # 80024220 <ftable>
    80004d46:	ffffc097          	auipc	ra,0xffffc
    80004d4a:	ef2080e7          	jalr	-270(ra) # 80000c38 <acquire>
  if(f->ref < 1)
    80004d4e:	40dc                	lw	a5,4(s1)
    80004d50:	02f05263          	blez	a5,80004d74 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004d54:	2785                	addiw	a5,a5,1
    80004d56:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004d58:	0001f517          	auipc	a0,0x1f
    80004d5c:	4c850513          	addi	a0,a0,1224 # 80024220 <ftable>
    80004d60:	ffffc097          	auipc	ra,0xffffc
    80004d64:	f8c080e7          	jalr	-116(ra) # 80000cec <release>
  return f;
}
    80004d68:	8526                	mv	a0,s1
    80004d6a:	60e2                	ld	ra,24(sp)
    80004d6c:	6442                	ld	s0,16(sp)
    80004d6e:	64a2                	ld	s1,8(sp)
    80004d70:	6105                	addi	sp,sp,32
    80004d72:	8082                	ret
    panic("filedup");
    80004d74:	00004517          	auipc	a0,0x4
    80004d78:	91c50513          	addi	a0,a0,-1764 # 80008690 <etext+0x690>
    80004d7c:	ffffb097          	auipc	ra,0xffffb
    80004d80:	7e4080e7          	jalr	2020(ra) # 80000560 <panic>

0000000080004d84 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004d84:	7139                	addi	sp,sp,-64
    80004d86:	fc06                	sd	ra,56(sp)
    80004d88:	f822                	sd	s0,48(sp)
    80004d8a:	f426                	sd	s1,40(sp)
    80004d8c:	0080                	addi	s0,sp,64
    80004d8e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004d90:	0001f517          	auipc	a0,0x1f
    80004d94:	49050513          	addi	a0,a0,1168 # 80024220 <ftable>
    80004d98:	ffffc097          	auipc	ra,0xffffc
    80004d9c:	ea0080e7          	jalr	-352(ra) # 80000c38 <acquire>
  if(f->ref < 1)
    80004da0:	40dc                	lw	a5,4(s1)
    80004da2:	04f05c63          	blez	a5,80004dfa <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80004da6:	37fd                	addiw	a5,a5,-1
    80004da8:	0007871b          	sext.w	a4,a5
    80004dac:	c0dc                	sw	a5,4(s1)
    80004dae:	06e04263          	bgtz	a4,80004e12 <fileclose+0x8e>
    80004db2:	f04a                	sd	s2,32(sp)
    80004db4:	ec4e                	sd	s3,24(sp)
    80004db6:	e852                	sd	s4,16(sp)
    80004db8:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004dba:	0004a903          	lw	s2,0(s1)
    80004dbe:	0094ca83          	lbu	s5,9(s1)
    80004dc2:	0104ba03          	ld	s4,16(s1)
    80004dc6:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004dca:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004dce:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004dd2:	0001f517          	auipc	a0,0x1f
    80004dd6:	44e50513          	addi	a0,a0,1102 # 80024220 <ftable>
    80004dda:	ffffc097          	auipc	ra,0xffffc
    80004dde:	f12080e7          	jalr	-238(ra) # 80000cec <release>

  if(ff.type == FD_PIPE){
    80004de2:	4785                	li	a5,1
    80004de4:	04f90463          	beq	s2,a5,80004e2c <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004de8:	3979                	addiw	s2,s2,-2
    80004dea:	4785                	li	a5,1
    80004dec:	0527fb63          	bgeu	a5,s2,80004e42 <fileclose+0xbe>
    80004df0:	7902                	ld	s2,32(sp)
    80004df2:	69e2                	ld	s3,24(sp)
    80004df4:	6a42                	ld	s4,16(sp)
    80004df6:	6aa2                	ld	s5,8(sp)
    80004df8:	a02d                	j	80004e22 <fileclose+0x9e>
    80004dfa:	f04a                	sd	s2,32(sp)
    80004dfc:	ec4e                	sd	s3,24(sp)
    80004dfe:	e852                	sd	s4,16(sp)
    80004e00:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004e02:	00004517          	auipc	a0,0x4
    80004e06:	89650513          	addi	a0,a0,-1898 # 80008698 <etext+0x698>
    80004e0a:	ffffb097          	auipc	ra,0xffffb
    80004e0e:	756080e7          	jalr	1878(ra) # 80000560 <panic>
    release(&ftable.lock);
    80004e12:	0001f517          	auipc	a0,0x1f
    80004e16:	40e50513          	addi	a0,a0,1038 # 80024220 <ftable>
    80004e1a:	ffffc097          	auipc	ra,0xffffc
    80004e1e:	ed2080e7          	jalr	-302(ra) # 80000cec <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004e22:	70e2                	ld	ra,56(sp)
    80004e24:	7442                	ld	s0,48(sp)
    80004e26:	74a2                	ld	s1,40(sp)
    80004e28:	6121                	addi	sp,sp,64
    80004e2a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004e2c:	85d6                	mv	a1,s5
    80004e2e:	8552                	mv	a0,s4
    80004e30:	00000097          	auipc	ra,0x0
    80004e34:	3a2080e7          	jalr	930(ra) # 800051d2 <pipeclose>
    80004e38:	7902                	ld	s2,32(sp)
    80004e3a:	69e2                	ld	s3,24(sp)
    80004e3c:	6a42                	ld	s4,16(sp)
    80004e3e:	6aa2                	ld	s5,8(sp)
    80004e40:	b7cd                	j	80004e22 <fileclose+0x9e>
    begin_op();
    80004e42:	00000097          	auipc	ra,0x0
    80004e46:	a78080e7          	jalr	-1416(ra) # 800048ba <begin_op>
    iput(ff.ip);
    80004e4a:	854e                	mv	a0,s3
    80004e4c:	fffff097          	auipc	ra,0xfffff
    80004e50:	25e080e7          	jalr	606(ra) # 800040aa <iput>
    end_op();
    80004e54:	00000097          	auipc	ra,0x0
    80004e58:	ae0080e7          	jalr	-1312(ra) # 80004934 <end_op>
    80004e5c:	7902                	ld	s2,32(sp)
    80004e5e:	69e2                	ld	s3,24(sp)
    80004e60:	6a42                	ld	s4,16(sp)
    80004e62:	6aa2                	ld	s5,8(sp)
    80004e64:	bf7d                	j	80004e22 <fileclose+0x9e>

0000000080004e66 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004e66:	715d                	addi	sp,sp,-80
    80004e68:	e486                	sd	ra,72(sp)
    80004e6a:	e0a2                	sd	s0,64(sp)
    80004e6c:	fc26                	sd	s1,56(sp)
    80004e6e:	f44e                	sd	s3,40(sp)
    80004e70:	0880                	addi	s0,sp,80
    80004e72:	84aa                	mv	s1,a0
    80004e74:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004e76:	ffffd097          	auipc	ra,0xffffd
    80004e7a:	bf2080e7          	jalr	-1038(ra) # 80001a68 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004e7e:	409c                	lw	a5,0(s1)
    80004e80:	37f9                	addiw	a5,a5,-2
    80004e82:	4705                	li	a4,1
    80004e84:	04f76863          	bltu	a4,a5,80004ed4 <filestat+0x6e>
    80004e88:	f84a                	sd	s2,48(sp)
    80004e8a:	892a                	mv	s2,a0
    ilock(f->ip);
    80004e8c:	6c88                	ld	a0,24(s1)
    80004e8e:	fffff097          	auipc	ra,0xfffff
    80004e92:	05e080e7          	jalr	94(ra) # 80003eec <ilock>
    stati(f->ip, &st);
    80004e96:	fb840593          	addi	a1,s0,-72
    80004e9a:	6c88                	ld	a0,24(s1)
    80004e9c:	fffff097          	auipc	ra,0xfffff
    80004ea0:	2de080e7          	jalr	734(ra) # 8000417a <stati>
    iunlock(f->ip);
    80004ea4:	6c88                	ld	a0,24(s1)
    80004ea6:	fffff097          	auipc	ra,0xfffff
    80004eaa:	10c080e7          	jalr	268(ra) # 80003fb2 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004eae:	46e1                	li	a3,24
    80004eb0:	fb840613          	addi	a2,s0,-72
    80004eb4:	85ce                	mv	a1,s3
    80004eb6:	05893503          	ld	a0,88(s2)
    80004eba:	ffffd097          	auipc	ra,0xffffd
    80004ebe:	828080e7          	jalr	-2008(ra) # 800016e2 <copyout>
    80004ec2:	41f5551b          	sraiw	a0,a0,0x1f
    80004ec6:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004ec8:	60a6                	ld	ra,72(sp)
    80004eca:	6406                	ld	s0,64(sp)
    80004ecc:	74e2                	ld	s1,56(sp)
    80004ece:	79a2                	ld	s3,40(sp)
    80004ed0:	6161                	addi	sp,sp,80
    80004ed2:	8082                	ret
  return -1;
    80004ed4:	557d                	li	a0,-1
    80004ed6:	bfcd                	j	80004ec8 <filestat+0x62>

0000000080004ed8 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004ed8:	7179                	addi	sp,sp,-48
    80004eda:	f406                	sd	ra,40(sp)
    80004edc:	f022                	sd	s0,32(sp)
    80004ede:	e84a                	sd	s2,16(sp)
    80004ee0:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004ee2:	00854783          	lbu	a5,8(a0)
    80004ee6:	cbc5                	beqz	a5,80004f96 <fileread+0xbe>
    80004ee8:	ec26                	sd	s1,24(sp)
    80004eea:	e44e                	sd	s3,8(sp)
    80004eec:	84aa                	mv	s1,a0
    80004eee:	89ae                	mv	s3,a1
    80004ef0:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004ef2:	411c                	lw	a5,0(a0)
    80004ef4:	4705                	li	a4,1
    80004ef6:	04e78963          	beq	a5,a4,80004f48 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004efa:	470d                	li	a4,3
    80004efc:	04e78f63          	beq	a5,a4,80004f5a <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004f00:	4709                	li	a4,2
    80004f02:	08e79263          	bne	a5,a4,80004f86 <fileread+0xae>
    ilock(f->ip);
    80004f06:	6d08                	ld	a0,24(a0)
    80004f08:	fffff097          	auipc	ra,0xfffff
    80004f0c:	fe4080e7          	jalr	-28(ra) # 80003eec <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004f10:	874a                	mv	a4,s2
    80004f12:	5094                	lw	a3,32(s1)
    80004f14:	864e                	mv	a2,s3
    80004f16:	4585                	li	a1,1
    80004f18:	6c88                	ld	a0,24(s1)
    80004f1a:	fffff097          	auipc	ra,0xfffff
    80004f1e:	28a080e7          	jalr	650(ra) # 800041a4 <readi>
    80004f22:	892a                	mv	s2,a0
    80004f24:	00a05563          	blez	a0,80004f2e <fileread+0x56>
      f->off += r;
    80004f28:	509c                	lw	a5,32(s1)
    80004f2a:	9fa9                	addw	a5,a5,a0
    80004f2c:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004f2e:	6c88                	ld	a0,24(s1)
    80004f30:	fffff097          	auipc	ra,0xfffff
    80004f34:	082080e7          	jalr	130(ra) # 80003fb2 <iunlock>
    80004f38:	64e2                	ld	s1,24(sp)
    80004f3a:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004f3c:	854a                	mv	a0,s2
    80004f3e:	70a2                	ld	ra,40(sp)
    80004f40:	7402                	ld	s0,32(sp)
    80004f42:	6942                	ld	s2,16(sp)
    80004f44:	6145                	addi	sp,sp,48
    80004f46:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004f48:	6908                	ld	a0,16(a0)
    80004f4a:	00000097          	auipc	ra,0x0
    80004f4e:	400080e7          	jalr	1024(ra) # 8000534a <piperead>
    80004f52:	892a                	mv	s2,a0
    80004f54:	64e2                	ld	s1,24(sp)
    80004f56:	69a2                	ld	s3,8(sp)
    80004f58:	b7d5                	j	80004f3c <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004f5a:	02451783          	lh	a5,36(a0)
    80004f5e:	03079693          	slli	a3,a5,0x30
    80004f62:	92c1                	srli	a3,a3,0x30
    80004f64:	4725                	li	a4,9
    80004f66:	02d76a63          	bltu	a4,a3,80004f9a <fileread+0xc2>
    80004f6a:	0792                	slli	a5,a5,0x4
    80004f6c:	0001f717          	auipc	a4,0x1f
    80004f70:	21470713          	addi	a4,a4,532 # 80024180 <devsw>
    80004f74:	97ba                	add	a5,a5,a4
    80004f76:	639c                	ld	a5,0(a5)
    80004f78:	c78d                	beqz	a5,80004fa2 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80004f7a:	4505                	li	a0,1
    80004f7c:	9782                	jalr	a5
    80004f7e:	892a                	mv	s2,a0
    80004f80:	64e2                	ld	s1,24(sp)
    80004f82:	69a2                	ld	s3,8(sp)
    80004f84:	bf65                	j	80004f3c <fileread+0x64>
    panic("fileread");
    80004f86:	00003517          	auipc	a0,0x3
    80004f8a:	72250513          	addi	a0,a0,1826 # 800086a8 <etext+0x6a8>
    80004f8e:	ffffb097          	auipc	ra,0xffffb
    80004f92:	5d2080e7          	jalr	1490(ra) # 80000560 <panic>
    return -1;
    80004f96:	597d                	li	s2,-1
    80004f98:	b755                	j	80004f3c <fileread+0x64>
      return -1;
    80004f9a:	597d                	li	s2,-1
    80004f9c:	64e2                	ld	s1,24(sp)
    80004f9e:	69a2                	ld	s3,8(sp)
    80004fa0:	bf71                	j	80004f3c <fileread+0x64>
    80004fa2:	597d                	li	s2,-1
    80004fa4:	64e2                	ld	s1,24(sp)
    80004fa6:	69a2                	ld	s3,8(sp)
    80004fa8:	bf51                	j	80004f3c <fileread+0x64>

0000000080004faa <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004faa:	00954783          	lbu	a5,9(a0)
    80004fae:	12078963          	beqz	a5,800050e0 <filewrite+0x136>
{
    80004fb2:	715d                	addi	sp,sp,-80
    80004fb4:	e486                	sd	ra,72(sp)
    80004fb6:	e0a2                	sd	s0,64(sp)
    80004fb8:	f84a                	sd	s2,48(sp)
    80004fba:	f052                	sd	s4,32(sp)
    80004fbc:	e85a                	sd	s6,16(sp)
    80004fbe:	0880                	addi	s0,sp,80
    80004fc0:	892a                	mv	s2,a0
    80004fc2:	8b2e                	mv	s6,a1
    80004fc4:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004fc6:	411c                	lw	a5,0(a0)
    80004fc8:	4705                	li	a4,1
    80004fca:	02e78763          	beq	a5,a4,80004ff8 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004fce:	470d                	li	a4,3
    80004fd0:	02e78a63          	beq	a5,a4,80005004 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004fd4:	4709                	li	a4,2
    80004fd6:	0ee79863          	bne	a5,a4,800050c6 <filewrite+0x11c>
    80004fda:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004fdc:	0cc05463          	blez	a2,800050a4 <filewrite+0xfa>
    80004fe0:	fc26                	sd	s1,56(sp)
    80004fe2:	ec56                	sd	s5,24(sp)
    80004fe4:	e45e                	sd	s7,8(sp)
    80004fe6:	e062                	sd	s8,0(sp)
    int i = 0;
    80004fe8:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80004fea:	6b85                	lui	s7,0x1
    80004fec:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004ff0:	6c05                	lui	s8,0x1
    80004ff2:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004ff6:	a851                	j	8000508a <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80004ff8:	6908                	ld	a0,16(a0)
    80004ffa:	00000097          	auipc	ra,0x0
    80004ffe:	248080e7          	jalr	584(ra) # 80005242 <pipewrite>
    80005002:	a85d                	j	800050b8 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80005004:	02451783          	lh	a5,36(a0)
    80005008:	03079693          	slli	a3,a5,0x30
    8000500c:	92c1                	srli	a3,a3,0x30
    8000500e:	4725                	li	a4,9
    80005010:	0cd76a63          	bltu	a4,a3,800050e4 <filewrite+0x13a>
    80005014:	0792                	slli	a5,a5,0x4
    80005016:	0001f717          	auipc	a4,0x1f
    8000501a:	16a70713          	addi	a4,a4,362 # 80024180 <devsw>
    8000501e:	97ba                	add	a5,a5,a4
    80005020:	679c                	ld	a5,8(a5)
    80005022:	c3f9                	beqz	a5,800050e8 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80005024:	4505                	li	a0,1
    80005026:	9782                	jalr	a5
    80005028:	a841                	j	800050b8 <filewrite+0x10e>
      if(n1 > max)
    8000502a:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    8000502e:	00000097          	auipc	ra,0x0
    80005032:	88c080e7          	jalr	-1908(ra) # 800048ba <begin_op>
      ilock(f->ip);
    80005036:	01893503          	ld	a0,24(s2)
    8000503a:	fffff097          	auipc	ra,0xfffff
    8000503e:	eb2080e7          	jalr	-334(ra) # 80003eec <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80005042:	8756                	mv	a4,s5
    80005044:	02092683          	lw	a3,32(s2)
    80005048:	01698633          	add	a2,s3,s6
    8000504c:	4585                	li	a1,1
    8000504e:	01893503          	ld	a0,24(s2)
    80005052:	fffff097          	auipc	ra,0xfffff
    80005056:	262080e7          	jalr	610(ra) # 800042b4 <writei>
    8000505a:	84aa                	mv	s1,a0
    8000505c:	00a05763          	blez	a0,8000506a <filewrite+0xc0>
        f->off += r;
    80005060:	02092783          	lw	a5,32(s2)
    80005064:	9fa9                	addw	a5,a5,a0
    80005066:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000506a:	01893503          	ld	a0,24(s2)
    8000506e:	fffff097          	auipc	ra,0xfffff
    80005072:	f44080e7          	jalr	-188(ra) # 80003fb2 <iunlock>
      end_op();
    80005076:	00000097          	auipc	ra,0x0
    8000507a:	8be080e7          	jalr	-1858(ra) # 80004934 <end_op>

      if(r != n1){
    8000507e:	029a9563          	bne	s5,s1,800050a8 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80005082:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80005086:	0149da63          	bge	s3,s4,8000509a <filewrite+0xf0>
      int n1 = n - i;
    8000508a:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    8000508e:	0004879b          	sext.w	a5,s1
    80005092:	f8fbdce3          	bge	s7,a5,8000502a <filewrite+0x80>
    80005096:	84e2                	mv	s1,s8
    80005098:	bf49                	j	8000502a <filewrite+0x80>
    8000509a:	74e2                	ld	s1,56(sp)
    8000509c:	6ae2                	ld	s5,24(sp)
    8000509e:	6ba2                	ld	s7,8(sp)
    800050a0:	6c02                	ld	s8,0(sp)
    800050a2:	a039                	j	800050b0 <filewrite+0x106>
    int i = 0;
    800050a4:	4981                	li	s3,0
    800050a6:	a029                	j	800050b0 <filewrite+0x106>
    800050a8:	74e2                	ld	s1,56(sp)
    800050aa:	6ae2                	ld	s5,24(sp)
    800050ac:	6ba2                	ld	s7,8(sp)
    800050ae:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    800050b0:	033a1e63          	bne	s4,s3,800050ec <filewrite+0x142>
    800050b4:	8552                	mv	a0,s4
    800050b6:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800050b8:	60a6                	ld	ra,72(sp)
    800050ba:	6406                	ld	s0,64(sp)
    800050bc:	7942                	ld	s2,48(sp)
    800050be:	7a02                	ld	s4,32(sp)
    800050c0:	6b42                	ld	s6,16(sp)
    800050c2:	6161                	addi	sp,sp,80
    800050c4:	8082                	ret
    800050c6:	fc26                	sd	s1,56(sp)
    800050c8:	f44e                	sd	s3,40(sp)
    800050ca:	ec56                	sd	s5,24(sp)
    800050cc:	e45e                	sd	s7,8(sp)
    800050ce:	e062                	sd	s8,0(sp)
    panic("filewrite");
    800050d0:	00003517          	auipc	a0,0x3
    800050d4:	5e850513          	addi	a0,a0,1512 # 800086b8 <etext+0x6b8>
    800050d8:	ffffb097          	auipc	ra,0xffffb
    800050dc:	488080e7          	jalr	1160(ra) # 80000560 <panic>
    return -1;
    800050e0:	557d                	li	a0,-1
}
    800050e2:	8082                	ret
      return -1;
    800050e4:	557d                	li	a0,-1
    800050e6:	bfc9                	j	800050b8 <filewrite+0x10e>
    800050e8:	557d                	li	a0,-1
    800050ea:	b7f9                	j	800050b8 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    800050ec:	557d                	li	a0,-1
    800050ee:	79a2                	ld	s3,40(sp)
    800050f0:	b7e1                	j	800050b8 <filewrite+0x10e>

00000000800050f2 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800050f2:	7179                	addi	sp,sp,-48
    800050f4:	f406                	sd	ra,40(sp)
    800050f6:	f022                	sd	s0,32(sp)
    800050f8:	ec26                	sd	s1,24(sp)
    800050fa:	e052                	sd	s4,0(sp)
    800050fc:	1800                	addi	s0,sp,48
    800050fe:	84aa                	mv	s1,a0
    80005100:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80005102:	0005b023          	sd	zero,0(a1)
    80005106:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000510a:	00000097          	auipc	ra,0x0
    8000510e:	bbe080e7          	jalr	-1090(ra) # 80004cc8 <filealloc>
    80005112:	e088                	sd	a0,0(s1)
    80005114:	cd49                	beqz	a0,800051ae <pipealloc+0xbc>
    80005116:	00000097          	auipc	ra,0x0
    8000511a:	bb2080e7          	jalr	-1102(ra) # 80004cc8 <filealloc>
    8000511e:	00aa3023          	sd	a0,0(s4)
    80005122:	c141                	beqz	a0,800051a2 <pipealloc+0xb0>
    80005124:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80005126:	ffffc097          	auipc	ra,0xffffc
    8000512a:	a22080e7          	jalr	-1502(ra) # 80000b48 <kalloc>
    8000512e:	892a                	mv	s2,a0
    80005130:	c13d                	beqz	a0,80005196 <pipealloc+0xa4>
    80005132:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80005134:	4985                	li	s3,1
    80005136:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000513a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000513e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80005142:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80005146:	00003597          	auipc	a1,0x3
    8000514a:	58258593          	addi	a1,a1,1410 # 800086c8 <etext+0x6c8>
    8000514e:	ffffc097          	auipc	ra,0xffffc
    80005152:	a5a080e7          	jalr	-1446(ra) # 80000ba8 <initlock>
  (*f0)->type = FD_PIPE;
    80005156:	609c                	ld	a5,0(s1)
    80005158:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000515c:	609c                	ld	a5,0(s1)
    8000515e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80005162:	609c                	ld	a5,0(s1)
    80005164:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80005168:	609c                	ld	a5,0(s1)
    8000516a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000516e:	000a3783          	ld	a5,0(s4)
    80005172:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80005176:	000a3783          	ld	a5,0(s4)
    8000517a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000517e:	000a3783          	ld	a5,0(s4)
    80005182:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80005186:	000a3783          	ld	a5,0(s4)
    8000518a:	0127b823          	sd	s2,16(a5)
  return 0;
    8000518e:	4501                	li	a0,0
    80005190:	6942                	ld	s2,16(sp)
    80005192:	69a2                	ld	s3,8(sp)
    80005194:	a03d                	j	800051c2 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80005196:	6088                	ld	a0,0(s1)
    80005198:	c119                	beqz	a0,8000519e <pipealloc+0xac>
    8000519a:	6942                	ld	s2,16(sp)
    8000519c:	a029                	j	800051a6 <pipealloc+0xb4>
    8000519e:	6942                	ld	s2,16(sp)
    800051a0:	a039                	j	800051ae <pipealloc+0xbc>
    800051a2:	6088                	ld	a0,0(s1)
    800051a4:	c50d                	beqz	a0,800051ce <pipealloc+0xdc>
    fileclose(*f0);
    800051a6:	00000097          	auipc	ra,0x0
    800051aa:	bde080e7          	jalr	-1058(ra) # 80004d84 <fileclose>
  if(*f1)
    800051ae:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800051b2:	557d                	li	a0,-1
  if(*f1)
    800051b4:	c799                	beqz	a5,800051c2 <pipealloc+0xd0>
    fileclose(*f1);
    800051b6:	853e                	mv	a0,a5
    800051b8:	00000097          	auipc	ra,0x0
    800051bc:	bcc080e7          	jalr	-1076(ra) # 80004d84 <fileclose>
  return -1;
    800051c0:	557d                	li	a0,-1
}
    800051c2:	70a2                	ld	ra,40(sp)
    800051c4:	7402                	ld	s0,32(sp)
    800051c6:	64e2                	ld	s1,24(sp)
    800051c8:	6a02                	ld	s4,0(sp)
    800051ca:	6145                	addi	sp,sp,48
    800051cc:	8082                	ret
  return -1;
    800051ce:	557d                	li	a0,-1
    800051d0:	bfcd                	j	800051c2 <pipealloc+0xd0>

00000000800051d2 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800051d2:	1101                	addi	sp,sp,-32
    800051d4:	ec06                	sd	ra,24(sp)
    800051d6:	e822                	sd	s0,16(sp)
    800051d8:	e426                	sd	s1,8(sp)
    800051da:	e04a                	sd	s2,0(sp)
    800051dc:	1000                	addi	s0,sp,32
    800051de:	84aa                	mv	s1,a0
    800051e0:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800051e2:	ffffc097          	auipc	ra,0xffffc
    800051e6:	a56080e7          	jalr	-1450(ra) # 80000c38 <acquire>
  if(writable){
    800051ea:	02090d63          	beqz	s2,80005224 <pipeclose+0x52>
    pi->writeopen = 0;
    800051ee:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800051f2:	21848513          	addi	a0,s1,536
    800051f6:	ffffd097          	auipc	ra,0xffffd
    800051fa:	562080e7          	jalr	1378(ra) # 80002758 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800051fe:	2204b783          	ld	a5,544(s1)
    80005202:	eb95                	bnez	a5,80005236 <pipeclose+0x64>
    release(&pi->lock);
    80005204:	8526                	mv	a0,s1
    80005206:	ffffc097          	auipc	ra,0xffffc
    8000520a:	ae6080e7          	jalr	-1306(ra) # 80000cec <release>
    kfree((char*)pi);
    8000520e:	8526                	mv	a0,s1
    80005210:	ffffc097          	auipc	ra,0xffffc
    80005214:	83a080e7          	jalr	-1990(ra) # 80000a4a <kfree>
  } else
    release(&pi->lock);
}
    80005218:	60e2                	ld	ra,24(sp)
    8000521a:	6442                	ld	s0,16(sp)
    8000521c:	64a2                	ld	s1,8(sp)
    8000521e:	6902                	ld	s2,0(sp)
    80005220:	6105                	addi	sp,sp,32
    80005222:	8082                	ret
    pi->readopen = 0;
    80005224:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80005228:	21c48513          	addi	a0,s1,540
    8000522c:	ffffd097          	auipc	ra,0xffffd
    80005230:	52c080e7          	jalr	1324(ra) # 80002758 <wakeup>
    80005234:	b7e9                	j	800051fe <pipeclose+0x2c>
    release(&pi->lock);
    80005236:	8526                	mv	a0,s1
    80005238:	ffffc097          	auipc	ra,0xffffc
    8000523c:	ab4080e7          	jalr	-1356(ra) # 80000cec <release>
}
    80005240:	bfe1                	j	80005218 <pipeclose+0x46>

0000000080005242 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80005242:	711d                	addi	sp,sp,-96
    80005244:	ec86                	sd	ra,88(sp)
    80005246:	e8a2                	sd	s0,80(sp)
    80005248:	e4a6                	sd	s1,72(sp)
    8000524a:	e0ca                	sd	s2,64(sp)
    8000524c:	fc4e                	sd	s3,56(sp)
    8000524e:	f852                	sd	s4,48(sp)
    80005250:	f456                	sd	s5,40(sp)
    80005252:	1080                	addi	s0,sp,96
    80005254:	84aa                	mv	s1,a0
    80005256:	8aae                	mv	s5,a1
    80005258:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000525a:	ffffd097          	auipc	ra,0xffffd
    8000525e:	80e080e7          	jalr	-2034(ra) # 80001a68 <myproc>
    80005262:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80005264:	8526                	mv	a0,s1
    80005266:	ffffc097          	auipc	ra,0xffffc
    8000526a:	9d2080e7          	jalr	-1582(ra) # 80000c38 <acquire>
  while(i < n){
    8000526e:	0d405863          	blez	s4,8000533e <pipewrite+0xfc>
    80005272:	f05a                	sd	s6,32(sp)
    80005274:	ec5e                	sd	s7,24(sp)
    80005276:	e862                	sd	s8,16(sp)
  int i = 0;
    80005278:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000527a:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000527c:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80005280:	21c48b93          	addi	s7,s1,540
    80005284:	a089                	j	800052c6 <pipewrite+0x84>
      release(&pi->lock);
    80005286:	8526                	mv	a0,s1
    80005288:	ffffc097          	auipc	ra,0xffffc
    8000528c:	a64080e7          	jalr	-1436(ra) # 80000cec <release>
      return -1;
    80005290:	597d                	li	s2,-1
    80005292:	7b02                	ld	s6,32(sp)
    80005294:	6be2                	ld	s7,24(sp)
    80005296:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80005298:	854a                	mv	a0,s2
    8000529a:	60e6                	ld	ra,88(sp)
    8000529c:	6446                	ld	s0,80(sp)
    8000529e:	64a6                	ld	s1,72(sp)
    800052a0:	6906                	ld	s2,64(sp)
    800052a2:	79e2                	ld	s3,56(sp)
    800052a4:	7a42                	ld	s4,48(sp)
    800052a6:	7aa2                	ld	s5,40(sp)
    800052a8:	6125                	addi	sp,sp,96
    800052aa:	8082                	ret
      wakeup(&pi->nread);
    800052ac:	8562                	mv	a0,s8
    800052ae:	ffffd097          	auipc	ra,0xffffd
    800052b2:	4aa080e7          	jalr	1194(ra) # 80002758 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800052b6:	85a6                	mv	a1,s1
    800052b8:	855e                	mv	a0,s7
    800052ba:	ffffd097          	auipc	ra,0xffffd
    800052be:	43a080e7          	jalr	1082(ra) # 800026f4 <sleep>
  while(i < n){
    800052c2:	05495f63          	bge	s2,s4,80005320 <pipewrite+0xde>
    if(pi->readopen == 0 || killed(pr)){
    800052c6:	2204a783          	lw	a5,544(s1)
    800052ca:	dfd5                	beqz	a5,80005286 <pipewrite+0x44>
    800052cc:	854e                	mv	a0,s3
    800052ce:	ffffd097          	auipc	ra,0xffffd
    800052d2:	6ce080e7          	jalr	1742(ra) # 8000299c <killed>
    800052d6:	f945                	bnez	a0,80005286 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800052d8:	2184a783          	lw	a5,536(s1)
    800052dc:	21c4a703          	lw	a4,540(s1)
    800052e0:	2007879b          	addiw	a5,a5,512
    800052e4:	fcf704e3          	beq	a4,a5,800052ac <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800052e8:	4685                	li	a3,1
    800052ea:	01590633          	add	a2,s2,s5
    800052ee:	faf40593          	addi	a1,s0,-81
    800052f2:	0589b503          	ld	a0,88(s3)
    800052f6:	ffffc097          	auipc	ra,0xffffc
    800052fa:	478080e7          	jalr	1144(ra) # 8000176e <copyin>
    800052fe:	05650263          	beq	a0,s6,80005342 <pipewrite+0x100>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80005302:	21c4a783          	lw	a5,540(s1)
    80005306:	0017871b          	addiw	a4,a5,1
    8000530a:	20e4ae23          	sw	a4,540(s1)
    8000530e:	1ff7f793          	andi	a5,a5,511
    80005312:	97a6                	add	a5,a5,s1
    80005314:	faf44703          	lbu	a4,-81(s0)
    80005318:	00e78c23          	sb	a4,24(a5)
      i++;
    8000531c:	2905                	addiw	s2,s2,1
    8000531e:	b755                	j	800052c2 <pipewrite+0x80>
    80005320:	7b02                	ld	s6,32(sp)
    80005322:	6be2                	ld	s7,24(sp)
    80005324:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80005326:	21848513          	addi	a0,s1,536
    8000532a:	ffffd097          	auipc	ra,0xffffd
    8000532e:	42e080e7          	jalr	1070(ra) # 80002758 <wakeup>
  release(&pi->lock);
    80005332:	8526                	mv	a0,s1
    80005334:	ffffc097          	auipc	ra,0xffffc
    80005338:	9b8080e7          	jalr	-1608(ra) # 80000cec <release>
  return i;
    8000533c:	bfb1                	j	80005298 <pipewrite+0x56>
  int i = 0;
    8000533e:	4901                	li	s2,0
    80005340:	b7dd                	j	80005326 <pipewrite+0xe4>
    80005342:	7b02                	ld	s6,32(sp)
    80005344:	6be2                	ld	s7,24(sp)
    80005346:	6c42                	ld	s8,16(sp)
    80005348:	bff9                	j	80005326 <pipewrite+0xe4>

000000008000534a <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000534a:	715d                	addi	sp,sp,-80
    8000534c:	e486                	sd	ra,72(sp)
    8000534e:	e0a2                	sd	s0,64(sp)
    80005350:	fc26                	sd	s1,56(sp)
    80005352:	f84a                	sd	s2,48(sp)
    80005354:	f44e                	sd	s3,40(sp)
    80005356:	f052                	sd	s4,32(sp)
    80005358:	ec56                	sd	s5,24(sp)
    8000535a:	0880                	addi	s0,sp,80
    8000535c:	84aa                	mv	s1,a0
    8000535e:	892e                	mv	s2,a1
    80005360:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80005362:	ffffc097          	auipc	ra,0xffffc
    80005366:	706080e7          	jalr	1798(ra) # 80001a68 <myproc>
    8000536a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000536c:	8526                	mv	a0,s1
    8000536e:	ffffc097          	auipc	ra,0xffffc
    80005372:	8ca080e7          	jalr	-1846(ra) # 80000c38 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005376:	2184a703          	lw	a4,536(s1)
    8000537a:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000537e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005382:	02f71963          	bne	a4,a5,800053b4 <piperead+0x6a>
    80005386:	2244a783          	lw	a5,548(s1)
    8000538a:	cf95                	beqz	a5,800053c6 <piperead+0x7c>
    if(killed(pr)){
    8000538c:	8552                	mv	a0,s4
    8000538e:	ffffd097          	auipc	ra,0xffffd
    80005392:	60e080e7          	jalr	1550(ra) # 8000299c <killed>
    80005396:	e10d                	bnez	a0,800053b8 <piperead+0x6e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005398:	85a6                	mv	a1,s1
    8000539a:	854e                	mv	a0,s3
    8000539c:	ffffd097          	auipc	ra,0xffffd
    800053a0:	358080e7          	jalr	856(ra) # 800026f4 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800053a4:	2184a703          	lw	a4,536(s1)
    800053a8:	21c4a783          	lw	a5,540(s1)
    800053ac:	fcf70de3          	beq	a4,a5,80005386 <piperead+0x3c>
    800053b0:	e85a                	sd	s6,16(sp)
    800053b2:	a819                	j	800053c8 <piperead+0x7e>
    800053b4:	e85a                	sd	s6,16(sp)
    800053b6:	a809                	j	800053c8 <piperead+0x7e>
      release(&pi->lock);
    800053b8:	8526                	mv	a0,s1
    800053ba:	ffffc097          	auipc	ra,0xffffc
    800053be:	932080e7          	jalr	-1742(ra) # 80000cec <release>
      return -1;
    800053c2:	59fd                	li	s3,-1
    800053c4:	a0a5                	j	8000542c <piperead+0xe2>
    800053c6:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800053c8:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800053ca:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800053cc:	05505463          	blez	s5,80005414 <piperead+0xca>
    if(pi->nread == pi->nwrite)
    800053d0:	2184a783          	lw	a5,536(s1)
    800053d4:	21c4a703          	lw	a4,540(s1)
    800053d8:	02f70e63          	beq	a4,a5,80005414 <piperead+0xca>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800053dc:	0017871b          	addiw	a4,a5,1
    800053e0:	20e4ac23          	sw	a4,536(s1)
    800053e4:	1ff7f793          	andi	a5,a5,511
    800053e8:	97a6                	add	a5,a5,s1
    800053ea:	0187c783          	lbu	a5,24(a5)
    800053ee:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800053f2:	4685                	li	a3,1
    800053f4:	fbf40613          	addi	a2,s0,-65
    800053f8:	85ca                	mv	a1,s2
    800053fa:	058a3503          	ld	a0,88(s4)
    800053fe:	ffffc097          	auipc	ra,0xffffc
    80005402:	2e4080e7          	jalr	740(ra) # 800016e2 <copyout>
    80005406:	01650763          	beq	a0,s6,80005414 <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000540a:	2985                	addiw	s3,s3,1
    8000540c:	0905                	addi	s2,s2,1
    8000540e:	fd3a91e3          	bne	s5,s3,800053d0 <piperead+0x86>
    80005412:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80005414:	21c48513          	addi	a0,s1,540
    80005418:	ffffd097          	auipc	ra,0xffffd
    8000541c:	340080e7          	jalr	832(ra) # 80002758 <wakeup>
  release(&pi->lock);
    80005420:	8526                	mv	a0,s1
    80005422:	ffffc097          	auipc	ra,0xffffc
    80005426:	8ca080e7          	jalr	-1846(ra) # 80000cec <release>
    8000542a:	6b42                	ld	s6,16(sp)
  return i;
}
    8000542c:	854e                	mv	a0,s3
    8000542e:	60a6                	ld	ra,72(sp)
    80005430:	6406                	ld	s0,64(sp)
    80005432:	74e2                	ld	s1,56(sp)
    80005434:	7942                	ld	s2,48(sp)
    80005436:	79a2                	ld	s3,40(sp)
    80005438:	7a02                	ld	s4,32(sp)
    8000543a:	6ae2                	ld	s5,24(sp)
    8000543c:	6161                	addi	sp,sp,80
    8000543e:	8082                	ret

0000000080005440 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80005440:	1141                	addi	sp,sp,-16
    80005442:	e422                	sd	s0,8(sp)
    80005444:	0800                	addi	s0,sp,16
    80005446:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80005448:	8905                	andi	a0,a0,1
    8000544a:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    8000544c:	8b89                	andi	a5,a5,2
    8000544e:	c399                	beqz	a5,80005454 <flags2perm+0x14>
      perm |= PTE_W;
    80005450:	00456513          	ori	a0,a0,4
    return perm;
}
    80005454:	6422                	ld	s0,8(sp)
    80005456:	0141                	addi	sp,sp,16
    80005458:	8082                	ret

000000008000545a <exec>:

int
exec(char *path, char **argv)
{
    8000545a:	df010113          	addi	sp,sp,-528
    8000545e:	20113423          	sd	ra,520(sp)
    80005462:	20813023          	sd	s0,512(sp)
    80005466:	ffa6                	sd	s1,504(sp)
    80005468:	fbca                	sd	s2,496(sp)
    8000546a:	0c00                	addi	s0,sp,528
    8000546c:	892a                	mv	s2,a0
    8000546e:	dea43c23          	sd	a0,-520(s0)
    80005472:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80005476:	ffffc097          	auipc	ra,0xffffc
    8000547a:	5f2080e7          	jalr	1522(ra) # 80001a68 <myproc>
    8000547e:	84aa                	mv	s1,a0

  begin_op();
    80005480:	fffff097          	auipc	ra,0xfffff
    80005484:	43a080e7          	jalr	1082(ra) # 800048ba <begin_op>

  if((ip = namei(path)) == 0){
    80005488:	854a                	mv	a0,s2
    8000548a:	fffff097          	auipc	ra,0xfffff
    8000548e:	230080e7          	jalr	560(ra) # 800046ba <namei>
    80005492:	c135                	beqz	a0,800054f6 <exec+0x9c>
    80005494:	f3d2                	sd	s4,480(sp)
    80005496:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80005498:	fffff097          	auipc	ra,0xfffff
    8000549c:	a54080e7          	jalr	-1452(ra) # 80003eec <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800054a0:	04000713          	li	a4,64
    800054a4:	4681                	li	a3,0
    800054a6:	e5040613          	addi	a2,s0,-432
    800054aa:	4581                	li	a1,0
    800054ac:	8552                	mv	a0,s4
    800054ae:	fffff097          	auipc	ra,0xfffff
    800054b2:	cf6080e7          	jalr	-778(ra) # 800041a4 <readi>
    800054b6:	04000793          	li	a5,64
    800054ba:	00f51a63          	bne	a0,a5,800054ce <exec+0x74>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800054be:	e5042703          	lw	a4,-432(s0)
    800054c2:	464c47b7          	lui	a5,0x464c4
    800054c6:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800054ca:	02f70c63          	beq	a4,a5,80005502 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800054ce:	8552                	mv	a0,s4
    800054d0:	fffff097          	auipc	ra,0xfffff
    800054d4:	c82080e7          	jalr	-894(ra) # 80004152 <iunlockput>
    end_op();
    800054d8:	fffff097          	auipc	ra,0xfffff
    800054dc:	45c080e7          	jalr	1116(ra) # 80004934 <end_op>
  }
  return -1;
    800054e0:	557d                	li	a0,-1
    800054e2:	7a1e                	ld	s4,480(sp)
}
    800054e4:	20813083          	ld	ra,520(sp)
    800054e8:	20013403          	ld	s0,512(sp)
    800054ec:	74fe                	ld	s1,504(sp)
    800054ee:	795e                	ld	s2,496(sp)
    800054f0:	21010113          	addi	sp,sp,528
    800054f4:	8082                	ret
    end_op();
    800054f6:	fffff097          	auipc	ra,0xfffff
    800054fa:	43e080e7          	jalr	1086(ra) # 80004934 <end_op>
    return -1;
    800054fe:	557d                	li	a0,-1
    80005500:	b7d5                	j	800054e4 <exec+0x8a>
    80005502:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80005504:	8526                	mv	a0,s1
    80005506:	ffffc097          	auipc	ra,0xffffc
    8000550a:	626080e7          	jalr	1574(ra) # 80001b2c <proc_pagetable>
    8000550e:	8b2a                	mv	s6,a0
    80005510:	30050f63          	beqz	a0,8000582e <exec+0x3d4>
    80005514:	f7ce                	sd	s3,488(sp)
    80005516:	efd6                	sd	s5,472(sp)
    80005518:	e7de                	sd	s7,456(sp)
    8000551a:	e3e2                	sd	s8,448(sp)
    8000551c:	ff66                	sd	s9,440(sp)
    8000551e:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005520:	e7042d03          	lw	s10,-400(s0)
    80005524:	e8845783          	lhu	a5,-376(s0)
    80005528:	14078d63          	beqz	a5,80005682 <exec+0x228>
    8000552c:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000552e:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005530:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80005532:	6c85                	lui	s9,0x1
    80005534:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80005538:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000553c:	6a85                	lui	s5,0x1
    8000553e:	a0b5                	j	800055aa <exec+0x150>
      panic("loadseg: address should exist");
    80005540:	00003517          	auipc	a0,0x3
    80005544:	19050513          	addi	a0,a0,400 # 800086d0 <etext+0x6d0>
    80005548:	ffffb097          	auipc	ra,0xffffb
    8000554c:	018080e7          	jalr	24(ra) # 80000560 <panic>
    if(sz - i < PGSIZE)
    80005550:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80005552:	8726                	mv	a4,s1
    80005554:	012c06bb          	addw	a3,s8,s2
    80005558:	4581                	li	a1,0
    8000555a:	8552                	mv	a0,s4
    8000555c:	fffff097          	auipc	ra,0xfffff
    80005560:	c48080e7          	jalr	-952(ra) # 800041a4 <readi>
    80005564:	2501                	sext.w	a0,a0
    80005566:	28a49863          	bne	s1,a0,800057f6 <exec+0x39c>
  for(i = 0; i < sz; i += PGSIZE){
    8000556a:	012a893b          	addw	s2,s5,s2
    8000556e:	03397563          	bgeu	s2,s3,80005598 <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    80005572:	02091593          	slli	a1,s2,0x20
    80005576:	9181                	srli	a1,a1,0x20
    80005578:	95de                	add	a1,a1,s7
    8000557a:	855a                	mv	a0,s6
    8000557c:	ffffc097          	auipc	ra,0xffffc
    80005580:	b3a080e7          	jalr	-1222(ra) # 800010b6 <walkaddr>
    80005584:	862a                	mv	a2,a0
    if(pa == 0)
    80005586:	dd4d                	beqz	a0,80005540 <exec+0xe6>
    if(sz - i < PGSIZE)
    80005588:	412984bb          	subw	s1,s3,s2
    8000558c:	0004879b          	sext.w	a5,s1
    80005590:	fcfcf0e3          	bgeu	s9,a5,80005550 <exec+0xf6>
    80005594:	84d6                	mv	s1,s5
    80005596:	bf6d                	j	80005550 <exec+0xf6>
    sz = sz1;
    80005598:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000559c:	2d85                	addiw	s11,s11,1
    8000559e:	038d0d1b          	addiw	s10,s10,56
    800055a2:	e8845783          	lhu	a5,-376(s0)
    800055a6:	08fdd663          	bge	s11,a5,80005632 <exec+0x1d8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800055aa:	2d01                	sext.w	s10,s10
    800055ac:	03800713          	li	a4,56
    800055b0:	86ea                	mv	a3,s10
    800055b2:	e1840613          	addi	a2,s0,-488
    800055b6:	4581                	li	a1,0
    800055b8:	8552                	mv	a0,s4
    800055ba:	fffff097          	auipc	ra,0xfffff
    800055be:	bea080e7          	jalr	-1046(ra) # 800041a4 <readi>
    800055c2:	03800793          	li	a5,56
    800055c6:	20f51063          	bne	a0,a5,800057c6 <exec+0x36c>
    if(ph.type != ELF_PROG_LOAD)
    800055ca:	e1842783          	lw	a5,-488(s0)
    800055ce:	4705                	li	a4,1
    800055d0:	fce796e3          	bne	a5,a4,8000559c <exec+0x142>
    if(ph.memsz < ph.filesz)
    800055d4:	e4043483          	ld	s1,-448(s0)
    800055d8:	e3843783          	ld	a5,-456(s0)
    800055dc:	1ef4e963          	bltu	s1,a5,800057ce <exec+0x374>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800055e0:	e2843783          	ld	a5,-472(s0)
    800055e4:	94be                	add	s1,s1,a5
    800055e6:	1ef4e863          	bltu	s1,a5,800057d6 <exec+0x37c>
    if(ph.vaddr % PGSIZE != 0)
    800055ea:	df043703          	ld	a4,-528(s0)
    800055ee:	8ff9                	and	a5,a5,a4
    800055f0:	1e079763          	bnez	a5,800057de <exec+0x384>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800055f4:	e1c42503          	lw	a0,-484(s0)
    800055f8:	00000097          	auipc	ra,0x0
    800055fc:	e48080e7          	jalr	-440(ra) # 80005440 <flags2perm>
    80005600:	86aa                	mv	a3,a0
    80005602:	8626                	mv	a2,s1
    80005604:	85ca                	mv	a1,s2
    80005606:	855a                	mv	a0,s6
    80005608:	ffffc097          	auipc	ra,0xffffc
    8000560c:	e72080e7          	jalr	-398(ra) # 8000147a <uvmalloc>
    80005610:	e0a43423          	sd	a0,-504(s0)
    80005614:	1c050963          	beqz	a0,800057e6 <exec+0x38c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005618:	e2843b83          	ld	s7,-472(s0)
    8000561c:	e2042c03          	lw	s8,-480(s0)
    80005620:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005624:	00098463          	beqz	s3,8000562c <exec+0x1d2>
    80005628:	4901                	li	s2,0
    8000562a:	b7a1                	j	80005572 <exec+0x118>
    sz = sz1;
    8000562c:	e0843903          	ld	s2,-504(s0)
    80005630:	b7b5                	j	8000559c <exec+0x142>
    80005632:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80005634:	8552                	mv	a0,s4
    80005636:	fffff097          	auipc	ra,0xfffff
    8000563a:	b1c080e7          	jalr	-1252(ra) # 80004152 <iunlockput>
  end_op();
    8000563e:	fffff097          	auipc	ra,0xfffff
    80005642:	2f6080e7          	jalr	758(ra) # 80004934 <end_op>
  p = myproc();
    80005646:	ffffc097          	auipc	ra,0xffffc
    8000564a:	422080e7          	jalr	1058(ra) # 80001a68 <myproc>
    8000564e:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80005650:	05053c83          	ld	s9,80(a0)
  sz = PGROUNDUP(sz);
    80005654:	6985                	lui	s3,0x1
    80005656:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80005658:	99ca                	add	s3,s3,s2
    8000565a:	77fd                	lui	a5,0xfffff
    8000565c:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005660:	4691                	li	a3,4
    80005662:	6609                	lui	a2,0x2
    80005664:	964e                	add	a2,a2,s3
    80005666:	85ce                	mv	a1,s3
    80005668:	855a                	mv	a0,s6
    8000566a:	ffffc097          	auipc	ra,0xffffc
    8000566e:	e10080e7          	jalr	-496(ra) # 8000147a <uvmalloc>
    80005672:	892a                	mv	s2,a0
    80005674:	e0a43423          	sd	a0,-504(s0)
    80005678:	e519                	bnez	a0,80005686 <exec+0x22c>
  if(pagetable)
    8000567a:	e1343423          	sd	s3,-504(s0)
    8000567e:	4a01                	li	s4,0
    80005680:	aaa5                	j	800057f8 <exec+0x39e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005682:	4901                	li	s2,0
    80005684:	bf45                	j	80005634 <exec+0x1da>
  uvmclear(pagetable, sz-2*PGSIZE);
    80005686:	75f9                	lui	a1,0xffffe
    80005688:	95aa                	add	a1,a1,a0
    8000568a:	855a                	mv	a0,s6
    8000568c:	ffffc097          	auipc	ra,0xffffc
    80005690:	024080e7          	jalr	36(ra) # 800016b0 <uvmclear>
  stackbase = sp - PGSIZE;
    80005694:	7bfd                	lui	s7,0xfffff
    80005696:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80005698:	e0043783          	ld	a5,-512(s0)
    8000569c:	6388                	ld	a0,0(a5)
    8000569e:	c52d                	beqz	a0,80005708 <exec+0x2ae>
    800056a0:	e9040993          	addi	s3,s0,-368
    800056a4:	f9040c13          	addi	s8,s0,-112
    800056a8:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800056aa:	ffffb097          	auipc	ra,0xffffb
    800056ae:	7fe080e7          	jalr	2046(ra) # 80000ea8 <strlen>
    800056b2:	0015079b          	addiw	a5,a0,1
    800056b6:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800056ba:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800056be:	13796863          	bltu	s2,s7,800057ee <exec+0x394>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800056c2:	e0043d03          	ld	s10,-512(s0)
    800056c6:	000d3a03          	ld	s4,0(s10)
    800056ca:	8552                	mv	a0,s4
    800056cc:	ffffb097          	auipc	ra,0xffffb
    800056d0:	7dc080e7          	jalr	2012(ra) # 80000ea8 <strlen>
    800056d4:	0015069b          	addiw	a3,a0,1
    800056d8:	8652                	mv	a2,s4
    800056da:	85ca                	mv	a1,s2
    800056dc:	855a                	mv	a0,s6
    800056de:	ffffc097          	auipc	ra,0xffffc
    800056e2:	004080e7          	jalr	4(ra) # 800016e2 <copyout>
    800056e6:	10054663          	bltz	a0,800057f2 <exec+0x398>
    ustack[argc] = sp;
    800056ea:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800056ee:	0485                	addi	s1,s1,1
    800056f0:	008d0793          	addi	a5,s10,8
    800056f4:	e0f43023          	sd	a5,-512(s0)
    800056f8:	008d3503          	ld	a0,8(s10)
    800056fc:	c909                	beqz	a0,8000570e <exec+0x2b4>
    if(argc >= MAXARG)
    800056fe:	09a1                	addi	s3,s3,8
    80005700:	fb8995e3          	bne	s3,s8,800056aa <exec+0x250>
  ip = 0;
    80005704:	4a01                	li	s4,0
    80005706:	a8cd                	j	800057f8 <exec+0x39e>
  sp = sz;
    80005708:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    8000570c:	4481                	li	s1,0
  ustack[argc] = 0;
    8000570e:	00349793          	slli	a5,s1,0x3
    80005712:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd9c78>
    80005716:	97a2                	add	a5,a5,s0
    80005718:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000571c:	00148693          	addi	a3,s1,1
    80005720:	068e                	slli	a3,a3,0x3
    80005722:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005726:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    8000572a:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    8000572e:	f57966e3          	bltu	s2,s7,8000567a <exec+0x220>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005732:	e9040613          	addi	a2,s0,-368
    80005736:	85ca                	mv	a1,s2
    80005738:	855a                	mv	a0,s6
    8000573a:	ffffc097          	auipc	ra,0xffffc
    8000573e:	fa8080e7          	jalr	-88(ra) # 800016e2 <copyout>
    80005742:	0e054863          	bltz	a0,80005832 <exec+0x3d8>
  p->trapframe->a1 = sp;
    80005746:	060ab783          	ld	a5,96(s5) # 1060 <_entry-0x7fffefa0>
    8000574a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000574e:	df843783          	ld	a5,-520(s0)
    80005752:	0007c703          	lbu	a4,0(a5)
    80005756:	cf11                	beqz	a4,80005772 <exec+0x318>
    80005758:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000575a:	02f00693          	li	a3,47
    8000575e:	a039                	j	8000576c <exec+0x312>
      last = s+1;
    80005760:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80005764:	0785                	addi	a5,a5,1
    80005766:	fff7c703          	lbu	a4,-1(a5)
    8000576a:	c701                	beqz	a4,80005772 <exec+0x318>
    if(*s == '/')
    8000576c:	fed71ce3          	bne	a4,a3,80005764 <exec+0x30a>
    80005770:	bfc5                	j	80005760 <exec+0x306>
  safestrcpy(p->name, last, sizeof(p->name));
    80005772:	4641                	li	a2,16
    80005774:	df843583          	ld	a1,-520(s0)
    80005778:	160a8513          	addi	a0,s5,352
    8000577c:	ffffb097          	auipc	ra,0xffffb
    80005780:	6fa080e7          	jalr	1786(ra) # 80000e76 <safestrcpy>
  oldpagetable = p->pagetable;
    80005784:	058ab503          	ld	a0,88(s5)
  p->pagetable = pagetable;
    80005788:	056abc23          	sd	s6,88(s5)
  p->sz = sz;
    8000578c:	e0843783          	ld	a5,-504(s0)
    80005790:	04fab823          	sd	a5,80(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005794:	060ab783          	ld	a5,96(s5)
    80005798:	e6843703          	ld	a4,-408(s0)
    8000579c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000579e:	060ab783          	ld	a5,96(s5)
    800057a2:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800057a6:	85e6                	mv	a1,s9
    800057a8:	ffffc097          	auipc	ra,0xffffc
    800057ac:	420080e7          	jalr	1056(ra) # 80001bc8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800057b0:	0004851b          	sext.w	a0,s1
    800057b4:	79be                	ld	s3,488(sp)
    800057b6:	7a1e                	ld	s4,480(sp)
    800057b8:	6afe                	ld	s5,472(sp)
    800057ba:	6b5e                	ld	s6,464(sp)
    800057bc:	6bbe                	ld	s7,456(sp)
    800057be:	6c1e                	ld	s8,448(sp)
    800057c0:	7cfa                	ld	s9,440(sp)
    800057c2:	7d5a                	ld	s10,432(sp)
    800057c4:	b305                	j	800054e4 <exec+0x8a>
    800057c6:	e1243423          	sd	s2,-504(s0)
    800057ca:	7dba                	ld	s11,424(sp)
    800057cc:	a035                	j	800057f8 <exec+0x39e>
    800057ce:	e1243423          	sd	s2,-504(s0)
    800057d2:	7dba                	ld	s11,424(sp)
    800057d4:	a015                	j	800057f8 <exec+0x39e>
    800057d6:	e1243423          	sd	s2,-504(s0)
    800057da:	7dba                	ld	s11,424(sp)
    800057dc:	a831                	j	800057f8 <exec+0x39e>
    800057de:	e1243423          	sd	s2,-504(s0)
    800057e2:	7dba                	ld	s11,424(sp)
    800057e4:	a811                	j	800057f8 <exec+0x39e>
    800057e6:	e1243423          	sd	s2,-504(s0)
    800057ea:	7dba                	ld	s11,424(sp)
    800057ec:	a031                	j	800057f8 <exec+0x39e>
  ip = 0;
    800057ee:	4a01                	li	s4,0
    800057f0:	a021                	j	800057f8 <exec+0x39e>
    800057f2:	4a01                	li	s4,0
  if(pagetable)
    800057f4:	a011                	j	800057f8 <exec+0x39e>
    800057f6:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    800057f8:	e0843583          	ld	a1,-504(s0)
    800057fc:	855a                	mv	a0,s6
    800057fe:	ffffc097          	auipc	ra,0xffffc
    80005802:	3ca080e7          	jalr	970(ra) # 80001bc8 <proc_freepagetable>
  return -1;
    80005806:	557d                	li	a0,-1
  if(ip){
    80005808:	000a1b63          	bnez	s4,8000581e <exec+0x3c4>
    8000580c:	79be                	ld	s3,488(sp)
    8000580e:	7a1e                	ld	s4,480(sp)
    80005810:	6afe                	ld	s5,472(sp)
    80005812:	6b5e                	ld	s6,464(sp)
    80005814:	6bbe                	ld	s7,456(sp)
    80005816:	6c1e                	ld	s8,448(sp)
    80005818:	7cfa                	ld	s9,440(sp)
    8000581a:	7d5a                	ld	s10,432(sp)
    8000581c:	b1e1                	j	800054e4 <exec+0x8a>
    8000581e:	79be                	ld	s3,488(sp)
    80005820:	6afe                	ld	s5,472(sp)
    80005822:	6b5e                	ld	s6,464(sp)
    80005824:	6bbe                	ld	s7,456(sp)
    80005826:	6c1e                	ld	s8,448(sp)
    80005828:	7cfa                	ld	s9,440(sp)
    8000582a:	7d5a                	ld	s10,432(sp)
    8000582c:	b14d                	j	800054ce <exec+0x74>
    8000582e:	6b5e                	ld	s6,464(sp)
    80005830:	b979                	j	800054ce <exec+0x74>
  sz = sz1;
    80005832:	e0843983          	ld	s3,-504(s0)
    80005836:	b591                	j	8000567a <exec+0x220>

0000000080005838 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005838:	7179                	addi	sp,sp,-48
    8000583a:	f406                	sd	ra,40(sp)
    8000583c:	f022                	sd	s0,32(sp)
    8000583e:	ec26                	sd	s1,24(sp)
    80005840:	e84a                	sd	s2,16(sp)
    80005842:	1800                	addi	s0,sp,48
    80005844:	892e                	mv	s2,a1
    80005846:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005848:	fdc40593          	addi	a1,s0,-36
    8000584c:	ffffe097          	auipc	ra,0xffffe
    80005850:	a3e080e7          	jalr	-1474(ra) # 8000328a <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005854:	fdc42703          	lw	a4,-36(s0)
    80005858:	47bd                	li	a5,15
    8000585a:	02e7eb63          	bltu	a5,a4,80005890 <argfd+0x58>
    8000585e:	ffffc097          	auipc	ra,0xffffc
    80005862:	20a080e7          	jalr	522(ra) # 80001a68 <myproc>
    80005866:	fdc42703          	lw	a4,-36(s0)
    8000586a:	01a70793          	addi	a5,a4,26
    8000586e:	078e                	slli	a5,a5,0x3
    80005870:	953e                	add	a0,a0,a5
    80005872:	651c                	ld	a5,8(a0)
    80005874:	c385                	beqz	a5,80005894 <argfd+0x5c>
    return -1;
  if(pfd)
    80005876:	00090463          	beqz	s2,8000587e <argfd+0x46>
    *pfd = fd;
    8000587a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000587e:	4501                	li	a0,0
  if(pf)
    80005880:	c091                	beqz	s1,80005884 <argfd+0x4c>
    *pf = f;
    80005882:	e09c                	sd	a5,0(s1)
}
    80005884:	70a2                	ld	ra,40(sp)
    80005886:	7402                	ld	s0,32(sp)
    80005888:	64e2                	ld	s1,24(sp)
    8000588a:	6942                	ld	s2,16(sp)
    8000588c:	6145                	addi	sp,sp,48
    8000588e:	8082                	ret
    return -1;
    80005890:	557d                	li	a0,-1
    80005892:	bfcd                	j	80005884 <argfd+0x4c>
    80005894:	557d                	li	a0,-1
    80005896:	b7fd                	j	80005884 <argfd+0x4c>

0000000080005898 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005898:	1101                	addi	sp,sp,-32
    8000589a:	ec06                	sd	ra,24(sp)
    8000589c:	e822                	sd	s0,16(sp)
    8000589e:	e426                	sd	s1,8(sp)
    800058a0:	1000                	addi	s0,sp,32
    800058a2:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800058a4:	ffffc097          	auipc	ra,0xffffc
    800058a8:	1c4080e7          	jalr	452(ra) # 80001a68 <myproc>
    800058ac:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800058ae:	0d850793          	addi	a5,a0,216
    800058b2:	4501                	li	a0,0
    800058b4:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800058b6:	6398                	ld	a4,0(a5)
    800058b8:	cb19                	beqz	a4,800058ce <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800058ba:	2505                	addiw	a0,a0,1
    800058bc:	07a1                	addi	a5,a5,8
    800058be:	fed51ce3          	bne	a0,a3,800058b6 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800058c2:	557d                	li	a0,-1
}
    800058c4:	60e2                	ld	ra,24(sp)
    800058c6:	6442                	ld	s0,16(sp)
    800058c8:	64a2                	ld	s1,8(sp)
    800058ca:	6105                	addi	sp,sp,32
    800058cc:	8082                	ret
      p->ofile[fd] = f;
    800058ce:	01a50793          	addi	a5,a0,26
    800058d2:	078e                	slli	a5,a5,0x3
    800058d4:	963e                	add	a2,a2,a5
    800058d6:	e604                	sd	s1,8(a2)
      return fd;
    800058d8:	b7f5                	j	800058c4 <fdalloc+0x2c>

00000000800058da <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800058da:	715d                	addi	sp,sp,-80
    800058dc:	e486                	sd	ra,72(sp)
    800058de:	e0a2                	sd	s0,64(sp)
    800058e0:	fc26                	sd	s1,56(sp)
    800058e2:	f84a                	sd	s2,48(sp)
    800058e4:	f44e                	sd	s3,40(sp)
    800058e6:	ec56                	sd	s5,24(sp)
    800058e8:	e85a                	sd	s6,16(sp)
    800058ea:	0880                	addi	s0,sp,80
    800058ec:	8b2e                	mv	s6,a1
    800058ee:	89b2                	mv	s3,a2
    800058f0:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800058f2:	fb040593          	addi	a1,s0,-80
    800058f6:	fffff097          	auipc	ra,0xfffff
    800058fa:	de2080e7          	jalr	-542(ra) # 800046d8 <nameiparent>
    800058fe:	84aa                	mv	s1,a0
    80005900:	14050e63          	beqz	a0,80005a5c <create+0x182>
    return 0;

  ilock(dp);
    80005904:	ffffe097          	auipc	ra,0xffffe
    80005908:	5e8080e7          	jalr	1512(ra) # 80003eec <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000590c:	4601                	li	a2,0
    8000590e:	fb040593          	addi	a1,s0,-80
    80005912:	8526                	mv	a0,s1
    80005914:	fffff097          	auipc	ra,0xfffff
    80005918:	ae4080e7          	jalr	-1308(ra) # 800043f8 <dirlookup>
    8000591c:	8aaa                	mv	s5,a0
    8000591e:	c539                	beqz	a0,8000596c <create+0x92>
    iunlockput(dp);
    80005920:	8526                	mv	a0,s1
    80005922:	fffff097          	auipc	ra,0xfffff
    80005926:	830080e7          	jalr	-2000(ra) # 80004152 <iunlockput>
    ilock(ip);
    8000592a:	8556                	mv	a0,s5
    8000592c:	ffffe097          	auipc	ra,0xffffe
    80005930:	5c0080e7          	jalr	1472(ra) # 80003eec <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005934:	4789                	li	a5,2
    80005936:	02fb1463          	bne	s6,a5,8000595e <create+0x84>
    8000593a:	044ad783          	lhu	a5,68(s5)
    8000593e:	37f9                	addiw	a5,a5,-2
    80005940:	17c2                	slli	a5,a5,0x30
    80005942:	93c1                	srli	a5,a5,0x30
    80005944:	4705                	li	a4,1
    80005946:	00f76c63          	bltu	a4,a5,8000595e <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000594a:	8556                	mv	a0,s5
    8000594c:	60a6                	ld	ra,72(sp)
    8000594e:	6406                	ld	s0,64(sp)
    80005950:	74e2                	ld	s1,56(sp)
    80005952:	7942                	ld	s2,48(sp)
    80005954:	79a2                	ld	s3,40(sp)
    80005956:	6ae2                	ld	s5,24(sp)
    80005958:	6b42                	ld	s6,16(sp)
    8000595a:	6161                	addi	sp,sp,80
    8000595c:	8082                	ret
    iunlockput(ip);
    8000595e:	8556                	mv	a0,s5
    80005960:	ffffe097          	auipc	ra,0xffffe
    80005964:	7f2080e7          	jalr	2034(ra) # 80004152 <iunlockput>
    return 0;
    80005968:	4a81                	li	s5,0
    8000596a:	b7c5                	j	8000594a <create+0x70>
    8000596c:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    8000596e:	85da                	mv	a1,s6
    80005970:	4088                	lw	a0,0(s1)
    80005972:	ffffe097          	auipc	ra,0xffffe
    80005976:	3d6080e7          	jalr	982(ra) # 80003d48 <ialloc>
    8000597a:	8a2a                	mv	s4,a0
    8000597c:	c531                	beqz	a0,800059c8 <create+0xee>
  ilock(ip);
    8000597e:	ffffe097          	auipc	ra,0xffffe
    80005982:	56e080e7          	jalr	1390(ra) # 80003eec <ilock>
  ip->major = major;
    80005986:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000598a:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000598e:	4905                	li	s2,1
    80005990:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80005994:	8552                	mv	a0,s4
    80005996:	ffffe097          	auipc	ra,0xffffe
    8000599a:	48a080e7          	jalr	1162(ra) # 80003e20 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000599e:	032b0d63          	beq	s6,s2,800059d8 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800059a2:	004a2603          	lw	a2,4(s4)
    800059a6:	fb040593          	addi	a1,s0,-80
    800059aa:	8526                	mv	a0,s1
    800059ac:	fffff097          	auipc	ra,0xfffff
    800059b0:	c5c080e7          	jalr	-932(ra) # 80004608 <dirlink>
    800059b4:	08054163          	bltz	a0,80005a36 <create+0x15c>
  iunlockput(dp);
    800059b8:	8526                	mv	a0,s1
    800059ba:	ffffe097          	auipc	ra,0xffffe
    800059be:	798080e7          	jalr	1944(ra) # 80004152 <iunlockput>
  return ip;
    800059c2:	8ad2                	mv	s5,s4
    800059c4:	7a02                	ld	s4,32(sp)
    800059c6:	b751                	j	8000594a <create+0x70>
    iunlockput(dp);
    800059c8:	8526                	mv	a0,s1
    800059ca:	ffffe097          	auipc	ra,0xffffe
    800059ce:	788080e7          	jalr	1928(ra) # 80004152 <iunlockput>
    return 0;
    800059d2:	8ad2                	mv	s5,s4
    800059d4:	7a02                	ld	s4,32(sp)
    800059d6:	bf95                	j	8000594a <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800059d8:	004a2603          	lw	a2,4(s4)
    800059dc:	00003597          	auipc	a1,0x3
    800059e0:	d1458593          	addi	a1,a1,-748 # 800086f0 <etext+0x6f0>
    800059e4:	8552                	mv	a0,s4
    800059e6:	fffff097          	auipc	ra,0xfffff
    800059ea:	c22080e7          	jalr	-990(ra) # 80004608 <dirlink>
    800059ee:	04054463          	bltz	a0,80005a36 <create+0x15c>
    800059f2:	40d0                	lw	a2,4(s1)
    800059f4:	00003597          	auipc	a1,0x3
    800059f8:	d0458593          	addi	a1,a1,-764 # 800086f8 <etext+0x6f8>
    800059fc:	8552                	mv	a0,s4
    800059fe:	fffff097          	auipc	ra,0xfffff
    80005a02:	c0a080e7          	jalr	-1014(ra) # 80004608 <dirlink>
    80005a06:	02054863          	bltz	a0,80005a36 <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    80005a0a:	004a2603          	lw	a2,4(s4)
    80005a0e:	fb040593          	addi	a1,s0,-80
    80005a12:	8526                	mv	a0,s1
    80005a14:	fffff097          	auipc	ra,0xfffff
    80005a18:	bf4080e7          	jalr	-1036(ra) # 80004608 <dirlink>
    80005a1c:	00054d63          	bltz	a0,80005a36 <create+0x15c>
    dp->nlink++;  // for ".."
    80005a20:	04a4d783          	lhu	a5,74(s1)
    80005a24:	2785                	addiw	a5,a5,1
    80005a26:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005a2a:	8526                	mv	a0,s1
    80005a2c:	ffffe097          	auipc	ra,0xffffe
    80005a30:	3f4080e7          	jalr	1012(ra) # 80003e20 <iupdate>
    80005a34:	b751                	j	800059b8 <create+0xde>
  ip->nlink = 0;
    80005a36:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80005a3a:	8552                	mv	a0,s4
    80005a3c:	ffffe097          	auipc	ra,0xffffe
    80005a40:	3e4080e7          	jalr	996(ra) # 80003e20 <iupdate>
  iunlockput(ip);
    80005a44:	8552                	mv	a0,s4
    80005a46:	ffffe097          	auipc	ra,0xffffe
    80005a4a:	70c080e7          	jalr	1804(ra) # 80004152 <iunlockput>
  iunlockput(dp);
    80005a4e:	8526                	mv	a0,s1
    80005a50:	ffffe097          	auipc	ra,0xffffe
    80005a54:	702080e7          	jalr	1794(ra) # 80004152 <iunlockput>
  return 0;
    80005a58:	7a02                	ld	s4,32(sp)
    80005a5a:	bdc5                	j	8000594a <create+0x70>
    return 0;
    80005a5c:	8aaa                	mv	s5,a0
    80005a5e:	b5f5                	j	8000594a <create+0x70>

0000000080005a60 <sys_dup>:
{
    80005a60:	7179                	addi	sp,sp,-48
    80005a62:	f406                	sd	ra,40(sp)
    80005a64:	f022                	sd	s0,32(sp)
    80005a66:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005a68:	fd840613          	addi	a2,s0,-40
    80005a6c:	4581                	li	a1,0
    80005a6e:	4501                	li	a0,0
    80005a70:	00000097          	auipc	ra,0x0
    80005a74:	dc8080e7          	jalr	-568(ra) # 80005838 <argfd>
    return -1;
    80005a78:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005a7a:	02054763          	bltz	a0,80005aa8 <sys_dup+0x48>
    80005a7e:	ec26                	sd	s1,24(sp)
    80005a80:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80005a82:	fd843903          	ld	s2,-40(s0)
    80005a86:	854a                	mv	a0,s2
    80005a88:	00000097          	auipc	ra,0x0
    80005a8c:	e10080e7          	jalr	-496(ra) # 80005898 <fdalloc>
    80005a90:	84aa                	mv	s1,a0
    return -1;
    80005a92:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005a94:	00054f63          	bltz	a0,80005ab2 <sys_dup+0x52>
  filedup(f);
    80005a98:	854a                	mv	a0,s2
    80005a9a:	fffff097          	auipc	ra,0xfffff
    80005a9e:	298080e7          	jalr	664(ra) # 80004d32 <filedup>
  return fd;
    80005aa2:	87a6                	mv	a5,s1
    80005aa4:	64e2                	ld	s1,24(sp)
    80005aa6:	6942                	ld	s2,16(sp)
}
    80005aa8:	853e                	mv	a0,a5
    80005aaa:	70a2                	ld	ra,40(sp)
    80005aac:	7402                	ld	s0,32(sp)
    80005aae:	6145                	addi	sp,sp,48
    80005ab0:	8082                	ret
    80005ab2:	64e2                	ld	s1,24(sp)
    80005ab4:	6942                	ld	s2,16(sp)
    80005ab6:	bfcd                	j	80005aa8 <sys_dup+0x48>

0000000080005ab8 <sys_read>:
{
    80005ab8:	7179                	addi	sp,sp,-48
    80005aba:	f406                	sd	ra,40(sp)
    80005abc:	f022                	sd	s0,32(sp)
    80005abe:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005ac0:	fd840593          	addi	a1,s0,-40
    80005ac4:	4505                	li	a0,1
    80005ac6:	ffffd097          	auipc	ra,0xffffd
    80005aca:	7e4080e7          	jalr	2020(ra) # 800032aa <argaddr>
  argint(2, &n);
    80005ace:	fe440593          	addi	a1,s0,-28
    80005ad2:	4509                	li	a0,2
    80005ad4:	ffffd097          	auipc	ra,0xffffd
    80005ad8:	7b6080e7          	jalr	1974(ra) # 8000328a <argint>
  if(argfd(0, 0, &f) < 0)
    80005adc:	fe840613          	addi	a2,s0,-24
    80005ae0:	4581                	li	a1,0
    80005ae2:	4501                	li	a0,0
    80005ae4:	00000097          	auipc	ra,0x0
    80005ae8:	d54080e7          	jalr	-684(ra) # 80005838 <argfd>
    80005aec:	87aa                	mv	a5,a0
    return -1;
    80005aee:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005af0:	0007cc63          	bltz	a5,80005b08 <sys_read+0x50>
  return fileread(f, p, n);
    80005af4:	fe442603          	lw	a2,-28(s0)
    80005af8:	fd843583          	ld	a1,-40(s0)
    80005afc:	fe843503          	ld	a0,-24(s0)
    80005b00:	fffff097          	auipc	ra,0xfffff
    80005b04:	3d8080e7          	jalr	984(ra) # 80004ed8 <fileread>
}
    80005b08:	70a2                	ld	ra,40(sp)
    80005b0a:	7402                	ld	s0,32(sp)
    80005b0c:	6145                	addi	sp,sp,48
    80005b0e:	8082                	ret

0000000080005b10 <sys_write>:
{
    80005b10:	7179                	addi	sp,sp,-48
    80005b12:	f406                	sd	ra,40(sp)
    80005b14:	f022                	sd	s0,32(sp)
    80005b16:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005b18:	fd840593          	addi	a1,s0,-40
    80005b1c:	4505                	li	a0,1
    80005b1e:	ffffd097          	auipc	ra,0xffffd
    80005b22:	78c080e7          	jalr	1932(ra) # 800032aa <argaddr>
  argint(2, &n);
    80005b26:	fe440593          	addi	a1,s0,-28
    80005b2a:	4509                	li	a0,2
    80005b2c:	ffffd097          	auipc	ra,0xffffd
    80005b30:	75e080e7          	jalr	1886(ra) # 8000328a <argint>
  if(argfd(0, 0, &f) < 0)
    80005b34:	fe840613          	addi	a2,s0,-24
    80005b38:	4581                	li	a1,0
    80005b3a:	4501                	li	a0,0
    80005b3c:	00000097          	auipc	ra,0x0
    80005b40:	cfc080e7          	jalr	-772(ra) # 80005838 <argfd>
    80005b44:	87aa                	mv	a5,a0
    return -1;
    80005b46:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005b48:	0007cc63          	bltz	a5,80005b60 <sys_write+0x50>
  return filewrite(f, p, n);
    80005b4c:	fe442603          	lw	a2,-28(s0)
    80005b50:	fd843583          	ld	a1,-40(s0)
    80005b54:	fe843503          	ld	a0,-24(s0)
    80005b58:	fffff097          	auipc	ra,0xfffff
    80005b5c:	452080e7          	jalr	1106(ra) # 80004faa <filewrite>
}
    80005b60:	70a2                	ld	ra,40(sp)
    80005b62:	7402                	ld	s0,32(sp)
    80005b64:	6145                	addi	sp,sp,48
    80005b66:	8082                	ret

0000000080005b68 <sys_close>:
{
    80005b68:	1101                	addi	sp,sp,-32
    80005b6a:	ec06                	sd	ra,24(sp)
    80005b6c:	e822                	sd	s0,16(sp)
    80005b6e:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005b70:	fe040613          	addi	a2,s0,-32
    80005b74:	fec40593          	addi	a1,s0,-20
    80005b78:	4501                	li	a0,0
    80005b7a:	00000097          	auipc	ra,0x0
    80005b7e:	cbe080e7          	jalr	-834(ra) # 80005838 <argfd>
    return -1;
    80005b82:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005b84:	02054463          	bltz	a0,80005bac <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005b88:	ffffc097          	auipc	ra,0xffffc
    80005b8c:	ee0080e7          	jalr	-288(ra) # 80001a68 <myproc>
    80005b90:	fec42783          	lw	a5,-20(s0)
    80005b94:	07e9                	addi	a5,a5,26
    80005b96:	078e                	slli	a5,a5,0x3
    80005b98:	953e                	add	a0,a0,a5
    80005b9a:	00053423          	sd	zero,8(a0)
  fileclose(f);
    80005b9e:	fe043503          	ld	a0,-32(s0)
    80005ba2:	fffff097          	auipc	ra,0xfffff
    80005ba6:	1e2080e7          	jalr	482(ra) # 80004d84 <fileclose>
  return 0;
    80005baa:	4781                	li	a5,0
}
    80005bac:	853e                	mv	a0,a5
    80005bae:	60e2                	ld	ra,24(sp)
    80005bb0:	6442                	ld	s0,16(sp)
    80005bb2:	6105                	addi	sp,sp,32
    80005bb4:	8082                	ret

0000000080005bb6 <sys_fstat>:
{
    80005bb6:	1101                	addi	sp,sp,-32
    80005bb8:	ec06                	sd	ra,24(sp)
    80005bba:	e822                	sd	s0,16(sp)
    80005bbc:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005bbe:	fe040593          	addi	a1,s0,-32
    80005bc2:	4505                	li	a0,1
    80005bc4:	ffffd097          	auipc	ra,0xffffd
    80005bc8:	6e6080e7          	jalr	1766(ra) # 800032aa <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005bcc:	fe840613          	addi	a2,s0,-24
    80005bd0:	4581                	li	a1,0
    80005bd2:	4501                	li	a0,0
    80005bd4:	00000097          	auipc	ra,0x0
    80005bd8:	c64080e7          	jalr	-924(ra) # 80005838 <argfd>
    80005bdc:	87aa                	mv	a5,a0
    return -1;
    80005bde:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005be0:	0007ca63          	bltz	a5,80005bf4 <sys_fstat+0x3e>
  return filestat(f, st);
    80005be4:	fe043583          	ld	a1,-32(s0)
    80005be8:	fe843503          	ld	a0,-24(s0)
    80005bec:	fffff097          	auipc	ra,0xfffff
    80005bf0:	27a080e7          	jalr	634(ra) # 80004e66 <filestat>
}
    80005bf4:	60e2                	ld	ra,24(sp)
    80005bf6:	6442                	ld	s0,16(sp)
    80005bf8:	6105                	addi	sp,sp,32
    80005bfa:	8082                	ret

0000000080005bfc <sys_link>:
{
    80005bfc:	7169                	addi	sp,sp,-304
    80005bfe:	f606                	sd	ra,296(sp)
    80005c00:	f222                	sd	s0,288(sp)
    80005c02:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005c04:	08000613          	li	a2,128
    80005c08:	ed040593          	addi	a1,s0,-304
    80005c0c:	4501                	li	a0,0
    80005c0e:	ffffd097          	auipc	ra,0xffffd
    80005c12:	6bc080e7          	jalr	1724(ra) # 800032ca <argstr>
    return -1;
    80005c16:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005c18:	12054663          	bltz	a0,80005d44 <sys_link+0x148>
    80005c1c:	08000613          	li	a2,128
    80005c20:	f5040593          	addi	a1,s0,-176
    80005c24:	4505                	li	a0,1
    80005c26:	ffffd097          	auipc	ra,0xffffd
    80005c2a:	6a4080e7          	jalr	1700(ra) # 800032ca <argstr>
    return -1;
    80005c2e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005c30:	10054a63          	bltz	a0,80005d44 <sys_link+0x148>
    80005c34:	ee26                	sd	s1,280(sp)
  begin_op();
    80005c36:	fffff097          	auipc	ra,0xfffff
    80005c3a:	c84080e7          	jalr	-892(ra) # 800048ba <begin_op>
  if((ip = namei(old)) == 0){
    80005c3e:	ed040513          	addi	a0,s0,-304
    80005c42:	fffff097          	auipc	ra,0xfffff
    80005c46:	a78080e7          	jalr	-1416(ra) # 800046ba <namei>
    80005c4a:	84aa                	mv	s1,a0
    80005c4c:	c949                	beqz	a0,80005cde <sys_link+0xe2>
  ilock(ip);
    80005c4e:	ffffe097          	auipc	ra,0xffffe
    80005c52:	29e080e7          	jalr	670(ra) # 80003eec <ilock>
  if(ip->type == T_DIR){
    80005c56:	04449703          	lh	a4,68(s1)
    80005c5a:	4785                	li	a5,1
    80005c5c:	08f70863          	beq	a4,a5,80005cec <sys_link+0xf0>
    80005c60:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80005c62:	04a4d783          	lhu	a5,74(s1)
    80005c66:	2785                	addiw	a5,a5,1
    80005c68:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005c6c:	8526                	mv	a0,s1
    80005c6e:	ffffe097          	auipc	ra,0xffffe
    80005c72:	1b2080e7          	jalr	434(ra) # 80003e20 <iupdate>
  iunlock(ip);
    80005c76:	8526                	mv	a0,s1
    80005c78:	ffffe097          	auipc	ra,0xffffe
    80005c7c:	33a080e7          	jalr	826(ra) # 80003fb2 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005c80:	fd040593          	addi	a1,s0,-48
    80005c84:	f5040513          	addi	a0,s0,-176
    80005c88:	fffff097          	auipc	ra,0xfffff
    80005c8c:	a50080e7          	jalr	-1456(ra) # 800046d8 <nameiparent>
    80005c90:	892a                	mv	s2,a0
    80005c92:	cd35                	beqz	a0,80005d0e <sys_link+0x112>
  ilock(dp);
    80005c94:	ffffe097          	auipc	ra,0xffffe
    80005c98:	258080e7          	jalr	600(ra) # 80003eec <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005c9c:	00092703          	lw	a4,0(s2)
    80005ca0:	409c                	lw	a5,0(s1)
    80005ca2:	06f71163          	bne	a4,a5,80005d04 <sys_link+0x108>
    80005ca6:	40d0                	lw	a2,4(s1)
    80005ca8:	fd040593          	addi	a1,s0,-48
    80005cac:	854a                	mv	a0,s2
    80005cae:	fffff097          	auipc	ra,0xfffff
    80005cb2:	95a080e7          	jalr	-1702(ra) # 80004608 <dirlink>
    80005cb6:	04054763          	bltz	a0,80005d04 <sys_link+0x108>
  iunlockput(dp);
    80005cba:	854a                	mv	a0,s2
    80005cbc:	ffffe097          	auipc	ra,0xffffe
    80005cc0:	496080e7          	jalr	1174(ra) # 80004152 <iunlockput>
  iput(ip);
    80005cc4:	8526                	mv	a0,s1
    80005cc6:	ffffe097          	auipc	ra,0xffffe
    80005cca:	3e4080e7          	jalr	996(ra) # 800040aa <iput>
  end_op();
    80005cce:	fffff097          	auipc	ra,0xfffff
    80005cd2:	c66080e7          	jalr	-922(ra) # 80004934 <end_op>
  return 0;
    80005cd6:	4781                	li	a5,0
    80005cd8:	64f2                	ld	s1,280(sp)
    80005cda:	6952                	ld	s2,272(sp)
    80005cdc:	a0a5                	j	80005d44 <sys_link+0x148>
    end_op();
    80005cde:	fffff097          	auipc	ra,0xfffff
    80005ce2:	c56080e7          	jalr	-938(ra) # 80004934 <end_op>
    return -1;
    80005ce6:	57fd                	li	a5,-1
    80005ce8:	64f2                	ld	s1,280(sp)
    80005cea:	a8a9                	j	80005d44 <sys_link+0x148>
    iunlockput(ip);
    80005cec:	8526                	mv	a0,s1
    80005cee:	ffffe097          	auipc	ra,0xffffe
    80005cf2:	464080e7          	jalr	1124(ra) # 80004152 <iunlockput>
    end_op();
    80005cf6:	fffff097          	auipc	ra,0xfffff
    80005cfa:	c3e080e7          	jalr	-962(ra) # 80004934 <end_op>
    return -1;
    80005cfe:	57fd                	li	a5,-1
    80005d00:	64f2                	ld	s1,280(sp)
    80005d02:	a089                	j	80005d44 <sys_link+0x148>
    iunlockput(dp);
    80005d04:	854a                	mv	a0,s2
    80005d06:	ffffe097          	auipc	ra,0xffffe
    80005d0a:	44c080e7          	jalr	1100(ra) # 80004152 <iunlockput>
  ilock(ip);
    80005d0e:	8526                	mv	a0,s1
    80005d10:	ffffe097          	auipc	ra,0xffffe
    80005d14:	1dc080e7          	jalr	476(ra) # 80003eec <ilock>
  ip->nlink--;
    80005d18:	04a4d783          	lhu	a5,74(s1)
    80005d1c:	37fd                	addiw	a5,a5,-1
    80005d1e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005d22:	8526                	mv	a0,s1
    80005d24:	ffffe097          	auipc	ra,0xffffe
    80005d28:	0fc080e7          	jalr	252(ra) # 80003e20 <iupdate>
  iunlockput(ip);
    80005d2c:	8526                	mv	a0,s1
    80005d2e:	ffffe097          	auipc	ra,0xffffe
    80005d32:	424080e7          	jalr	1060(ra) # 80004152 <iunlockput>
  end_op();
    80005d36:	fffff097          	auipc	ra,0xfffff
    80005d3a:	bfe080e7          	jalr	-1026(ra) # 80004934 <end_op>
  return -1;
    80005d3e:	57fd                	li	a5,-1
    80005d40:	64f2                	ld	s1,280(sp)
    80005d42:	6952                	ld	s2,272(sp)
}
    80005d44:	853e                	mv	a0,a5
    80005d46:	70b2                	ld	ra,296(sp)
    80005d48:	7412                	ld	s0,288(sp)
    80005d4a:	6155                	addi	sp,sp,304
    80005d4c:	8082                	ret

0000000080005d4e <sys_unlink>:
{
    80005d4e:	7151                	addi	sp,sp,-240
    80005d50:	f586                	sd	ra,232(sp)
    80005d52:	f1a2                	sd	s0,224(sp)
    80005d54:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005d56:	08000613          	li	a2,128
    80005d5a:	f3040593          	addi	a1,s0,-208
    80005d5e:	4501                	li	a0,0
    80005d60:	ffffd097          	auipc	ra,0xffffd
    80005d64:	56a080e7          	jalr	1386(ra) # 800032ca <argstr>
    80005d68:	1a054a63          	bltz	a0,80005f1c <sys_unlink+0x1ce>
    80005d6c:	eda6                	sd	s1,216(sp)
  begin_op();
    80005d6e:	fffff097          	auipc	ra,0xfffff
    80005d72:	b4c080e7          	jalr	-1204(ra) # 800048ba <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005d76:	fb040593          	addi	a1,s0,-80
    80005d7a:	f3040513          	addi	a0,s0,-208
    80005d7e:	fffff097          	auipc	ra,0xfffff
    80005d82:	95a080e7          	jalr	-1702(ra) # 800046d8 <nameiparent>
    80005d86:	84aa                	mv	s1,a0
    80005d88:	cd71                	beqz	a0,80005e64 <sys_unlink+0x116>
  ilock(dp);
    80005d8a:	ffffe097          	auipc	ra,0xffffe
    80005d8e:	162080e7          	jalr	354(ra) # 80003eec <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005d92:	00003597          	auipc	a1,0x3
    80005d96:	95e58593          	addi	a1,a1,-1698 # 800086f0 <etext+0x6f0>
    80005d9a:	fb040513          	addi	a0,s0,-80
    80005d9e:	ffffe097          	auipc	ra,0xffffe
    80005da2:	640080e7          	jalr	1600(ra) # 800043de <namecmp>
    80005da6:	14050c63          	beqz	a0,80005efe <sys_unlink+0x1b0>
    80005daa:	00003597          	auipc	a1,0x3
    80005dae:	94e58593          	addi	a1,a1,-1714 # 800086f8 <etext+0x6f8>
    80005db2:	fb040513          	addi	a0,s0,-80
    80005db6:	ffffe097          	auipc	ra,0xffffe
    80005dba:	628080e7          	jalr	1576(ra) # 800043de <namecmp>
    80005dbe:	14050063          	beqz	a0,80005efe <sys_unlink+0x1b0>
    80005dc2:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005dc4:	f2c40613          	addi	a2,s0,-212
    80005dc8:	fb040593          	addi	a1,s0,-80
    80005dcc:	8526                	mv	a0,s1
    80005dce:	ffffe097          	auipc	ra,0xffffe
    80005dd2:	62a080e7          	jalr	1578(ra) # 800043f8 <dirlookup>
    80005dd6:	892a                	mv	s2,a0
    80005dd8:	12050263          	beqz	a0,80005efc <sys_unlink+0x1ae>
  ilock(ip);
    80005ddc:	ffffe097          	auipc	ra,0xffffe
    80005de0:	110080e7          	jalr	272(ra) # 80003eec <ilock>
  if(ip->nlink < 1)
    80005de4:	04a91783          	lh	a5,74(s2)
    80005de8:	08f05563          	blez	a5,80005e72 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005dec:	04491703          	lh	a4,68(s2)
    80005df0:	4785                	li	a5,1
    80005df2:	08f70963          	beq	a4,a5,80005e84 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80005df6:	4641                	li	a2,16
    80005df8:	4581                	li	a1,0
    80005dfa:	fc040513          	addi	a0,s0,-64
    80005dfe:	ffffb097          	auipc	ra,0xffffb
    80005e02:	f36080e7          	jalr	-202(ra) # 80000d34 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005e06:	4741                	li	a4,16
    80005e08:	f2c42683          	lw	a3,-212(s0)
    80005e0c:	fc040613          	addi	a2,s0,-64
    80005e10:	4581                	li	a1,0
    80005e12:	8526                	mv	a0,s1
    80005e14:	ffffe097          	auipc	ra,0xffffe
    80005e18:	4a0080e7          	jalr	1184(ra) # 800042b4 <writei>
    80005e1c:	47c1                	li	a5,16
    80005e1e:	0af51b63          	bne	a0,a5,80005ed4 <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80005e22:	04491703          	lh	a4,68(s2)
    80005e26:	4785                	li	a5,1
    80005e28:	0af70f63          	beq	a4,a5,80005ee6 <sys_unlink+0x198>
  iunlockput(dp);
    80005e2c:	8526                	mv	a0,s1
    80005e2e:	ffffe097          	auipc	ra,0xffffe
    80005e32:	324080e7          	jalr	804(ra) # 80004152 <iunlockput>
  ip->nlink--;
    80005e36:	04a95783          	lhu	a5,74(s2)
    80005e3a:	37fd                	addiw	a5,a5,-1
    80005e3c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005e40:	854a                	mv	a0,s2
    80005e42:	ffffe097          	auipc	ra,0xffffe
    80005e46:	fde080e7          	jalr	-34(ra) # 80003e20 <iupdate>
  iunlockput(ip);
    80005e4a:	854a                	mv	a0,s2
    80005e4c:	ffffe097          	auipc	ra,0xffffe
    80005e50:	306080e7          	jalr	774(ra) # 80004152 <iunlockput>
  end_op();
    80005e54:	fffff097          	auipc	ra,0xfffff
    80005e58:	ae0080e7          	jalr	-1312(ra) # 80004934 <end_op>
  return 0;
    80005e5c:	4501                	li	a0,0
    80005e5e:	64ee                	ld	s1,216(sp)
    80005e60:	694e                	ld	s2,208(sp)
    80005e62:	a84d                	j	80005f14 <sys_unlink+0x1c6>
    end_op();
    80005e64:	fffff097          	auipc	ra,0xfffff
    80005e68:	ad0080e7          	jalr	-1328(ra) # 80004934 <end_op>
    return -1;
    80005e6c:	557d                	li	a0,-1
    80005e6e:	64ee                	ld	s1,216(sp)
    80005e70:	a055                	j	80005f14 <sys_unlink+0x1c6>
    80005e72:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80005e74:	00003517          	auipc	a0,0x3
    80005e78:	88c50513          	addi	a0,a0,-1908 # 80008700 <etext+0x700>
    80005e7c:	ffffa097          	auipc	ra,0xffffa
    80005e80:	6e4080e7          	jalr	1764(ra) # 80000560 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005e84:	04c92703          	lw	a4,76(s2)
    80005e88:	02000793          	li	a5,32
    80005e8c:	f6e7f5e3          	bgeu	a5,a4,80005df6 <sys_unlink+0xa8>
    80005e90:	e5ce                	sd	s3,200(sp)
    80005e92:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005e96:	4741                	li	a4,16
    80005e98:	86ce                	mv	a3,s3
    80005e9a:	f1840613          	addi	a2,s0,-232
    80005e9e:	4581                	li	a1,0
    80005ea0:	854a                	mv	a0,s2
    80005ea2:	ffffe097          	auipc	ra,0xffffe
    80005ea6:	302080e7          	jalr	770(ra) # 800041a4 <readi>
    80005eaa:	47c1                	li	a5,16
    80005eac:	00f51c63          	bne	a0,a5,80005ec4 <sys_unlink+0x176>
    if(de.inum != 0)
    80005eb0:	f1845783          	lhu	a5,-232(s0)
    80005eb4:	e7b5                	bnez	a5,80005f20 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005eb6:	29c1                	addiw	s3,s3,16
    80005eb8:	04c92783          	lw	a5,76(s2)
    80005ebc:	fcf9ede3          	bltu	s3,a5,80005e96 <sys_unlink+0x148>
    80005ec0:	69ae                	ld	s3,200(sp)
    80005ec2:	bf15                	j	80005df6 <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80005ec4:	00003517          	auipc	a0,0x3
    80005ec8:	85450513          	addi	a0,a0,-1964 # 80008718 <etext+0x718>
    80005ecc:	ffffa097          	auipc	ra,0xffffa
    80005ed0:	694080e7          	jalr	1684(ra) # 80000560 <panic>
    80005ed4:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80005ed6:	00003517          	auipc	a0,0x3
    80005eda:	85a50513          	addi	a0,a0,-1958 # 80008730 <etext+0x730>
    80005ede:	ffffa097          	auipc	ra,0xffffa
    80005ee2:	682080e7          	jalr	1666(ra) # 80000560 <panic>
    dp->nlink--;
    80005ee6:	04a4d783          	lhu	a5,74(s1)
    80005eea:	37fd                	addiw	a5,a5,-1
    80005eec:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005ef0:	8526                	mv	a0,s1
    80005ef2:	ffffe097          	auipc	ra,0xffffe
    80005ef6:	f2e080e7          	jalr	-210(ra) # 80003e20 <iupdate>
    80005efa:	bf0d                	j	80005e2c <sys_unlink+0xde>
    80005efc:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80005efe:	8526                	mv	a0,s1
    80005f00:	ffffe097          	auipc	ra,0xffffe
    80005f04:	252080e7          	jalr	594(ra) # 80004152 <iunlockput>
  end_op();
    80005f08:	fffff097          	auipc	ra,0xfffff
    80005f0c:	a2c080e7          	jalr	-1492(ra) # 80004934 <end_op>
  return -1;
    80005f10:	557d                	li	a0,-1
    80005f12:	64ee                	ld	s1,216(sp)
}
    80005f14:	70ae                	ld	ra,232(sp)
    80005f16:	740e                	ld	s0,224(sp)
    80005f18:	616d                	addi	sp,sp,240
    80005f1a:	8082                	ret
    return -1;
    80005f1c:	557d                	li	a0,-1
    80005f1e:	bfdd                	j	80005f14 <sys_unlink+0x1c6>
    iunlockput(ip);
    80005f20:	854a                	mv	a0,s2
    80005f22:	ffffe097          	auipc	ra,0xffffe
    80005f26:	230080e7          	jalr	560(ra) # 80004152 <iunlockput>
    goto bad;
    80005f2a:	694e                	ld	s2,208(sp)
    80005f2c:	69ae                	ld	s3,200(sp)
    80005f2e:	bfc1                	j	80005efe <sys_unlink+0x1b0>

0000000080005f30 <sys_open>:

uint64
sys_open(void)
{
    80005f30:	7131                	addi	sp,sp,-192
    80005f32:	fd06                	sd	ra,184(sp)
    80005f34:	f922                	sd	s0,176(sp)
    80005f36:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005f38:	f4c40593          	addi	a1,s0,-180
    80005f3c:	4505                	li	a0,1
    80005f3e:	ffffd097          	auipc	ra,0xffffd
    80005f42:	34c080e7          	jalr	844(ra) # 8000328a <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005f46:	08000613          	li	a2,128
    80005f4a:	f5040593          	addi	a1,s0,-176
    80005f4e:	4501                	li	a0,0
    80005f50:	ffffd097          	auipc	ra,0xffffd
    80005f54:	37a080e7          	jalr	890(ra) # 800032ca <argstr>
    80005f58:	87aa                	mv	a5,a0
    return -1;
    80005f5a:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005f5c:	0a07ce63          	bltz	a5,80006018 <sys_open+0xe8>
    80005f60:	f526                	sd	s1,168(sp)

  begin_op();
    80005f62:	fffff097          	auipc	ra,0xfffff
    80005f66:	958080e7          	jalr	-1704(ra) # 800048ba <begin_op>

  if(omode & O_CREATE){
    80005f6a:	f4c42783          	lw	a5,-180(s0)
    80005f6e:	2007f793          	andi	a5,a5,512
    80005f72:	cfd5                	beqz	a5,8000602e <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005f74:	4681                	li	a3,0
    80005f76:	4601                	li	a2,0
    80005f78:	4589                	li	a1,2
    80005f7a:	f5040513          	addi	a0,s0,-176
    80005f7e:	00000097          	auipc	ra,0x0
    80005f82:	95c080e7          	jalr	-1700(ra) # 800058da <create>
    80005f86:	84aa                	mv	s1,a0
    if(ip == 0){
    80005f88:	cd41                	beqz	a0,80006020 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005f8a:	04449703          	lh	a4,68(s1)
    80005f8e:	478d                	li	a5,3
    80005f90:	00f71763          	bne	a4,a5,80005f9e <sys_open+0x6e>
    80005f94:	0464d703          	lhu	a4,70(s1)
    80005f98:	47a5                	li	a5,9
    80005f9a:	0ee7e163          	bltu	a5,a4,8000607c <sys_open+0x14c>
    80005f9e:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005fa0:	fffff097          	auipc	ra,0xfffff
    80005fa4:	d28080e7          	jalr	-728(ra) # 80004cc8 <filealloc>
    80005fa8:	892a                	mv	s2,a0
    80005faa:	c97d                	beqz	a0,800060a0 <sys_open+0x170>
    80005fac:	ed4e                	sd	s3,152(sp)
    80005fae:	00000097          	auipc	ra,0x0
    80005fb2:	8ea080e7          	jalr	-1814(ra) # 80005898 <fdalloc>
    80005fb6:	89aa                	mv	s3,a0
    80005fb8:	0c054e63          	bltz	a0,80006094 <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005fbc:	04449703          	lh	a4,68(s1)
    80005fc0:	478d                	li	a5,3
    80005fc2:	0ef70c63          	beq	a4,a5,800060ba <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005fc6:	4789                	li	a5,2
    80005fc8:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005fcc:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005fd0:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005fd4:	f4c42783          	lw	a5,-180(s0)
    80005fd8:	0017c713          	xori	a4,a5,1
    80005fdc:	8b05                	andi	a4,a4,1
    80005fde:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005fe2:	0037f713          	andi	a4,a5,3
    80005fe6:	00e03733          	snez	a4,a4
    80005fea:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005fee:	4007f793          	andi	a5,a5,1024
    80005ff2:	c791                	beqz	a5,80005ffe <sys_open+0xce>
    80005ff4:	04449703          	lh	a4,68(s1)
    80005ff8:	4789                	li	a5,2
    80005ffa:	0cf70763          	beq	a4,a5,800060c8 <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    80005ffe:	8526                	mv	a0,s1
    80006000:	ffffe097          	auipc	ra,0xffffe
    80006004:	fb2080e7          	jalr	-78(ra) # 80003fb2 <iunlock>
  end_op();
    80006008:	fffff097          	auipc	ra,0xfffff
    8000600c:	92c080e7          	jalr	-1748(ra) # 80004934 <end_op>

  return fd;
    80006010:	854e                	mv	a0,s3
    80006012:	74aa                	ld	s1,168(sp)
    80006014:	790a                	ld	s2,160(sp)
    80006016:	69ea                	ld	s3,152(sp)
}
    80006018:	70ea                	ld	ra,184(sp)
    8000601a:	744a                	ld	s0,176(sp)
    8000601c:	6129                	addi	sp,sp,192
    8000601e:	8082                	ret
      end_op();
    80006020:	fffff097          	auipc	ra,0xfffff
    80006024:	914080e7          	jalr	-1772(ra) # 80004934 <end_op>
      return -1;
    80006028:	557d                	li	a0,-1
    8000602a:	74aa                	ld	s1,168(sp)
    8000602c:	b7f5                	j	80006018 <sys_open+0xe8>
    if((ip = namei(path)) == 0){
    8000602e:	f5040513          	addi	a0,s0,-176
    80006032:	ffffe097          	auipc	ra,0xffffe
    80006036:	688080e7          	jalr	1672(ra) # 800046ba <namei>
    8000603a:	84aa                	mv	s1,a0
    8000603c:	c90d                	beqz	a0,8000606e <sys_open+0x13e>
    ilock(ip);
    8000603e:	ffffe097          	auipc	ra,0xffffe
    80006042:	eae080e7          	jalr	-338(ra) # 80003eec <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80006046:	04449703          	lh	a4,68(s1)
    8000604a:	4785                	li	a5,1
    8000604c:	f2f71fe3          	bne	a4,a5,80005f8a <sys_open+0x5a>
    80006050:	f4c42783          	lw	a5,-180(s0)
    80006054:	d7a9                	beqz	a5,80005f9e <sys_open+0x6e>
      iunlockput(ip);
    80006056:	8526                	mv	a0,s1
    80006058:	ffffe097          	auipc	ra,0xffffe
    8000605c:	0fa080e7          	jalr	250(ra) # 80004152 <iunlockput>
      end_op();
    80006060:	fffff097          	auipc	ra,0xfffff
    80006064:	8d4080e7          	jalr	-1836(ra) # 80004934 <end_op>
      return -1;
    80006068:	557d                	li	a0,-1
    8000606a:	74aa                	ld	s1,168(sp)
    8000606c:	b775                	j	80006018 <sys_open+0xe8>
      end_op();
    8000606e:	fffff097          	auipc	ra,0xfffff
    80006072:	8c6080e7          	jalr	-1850(ra) # 80004934 <end_op>
      return -1;
    80006076:	557d                	li	a0,-1
    80006078:	74aa                	ld	s1,168(sp)
    8000607a:	bf79                	j	80006018 <sys_open+0xe8>
    iunlockput(ip);
    8000607c:	8526                	mv	a0,s1
    8000607e:	ffffe097          	auipc	ra,0xffffe
    80006082:	0d4080e7          	jalr	212(ra) # 80004152 <iunlockput>
    end_op();
    80006086:	fffff097          	auipc	ra,0xfffff
    8000608a:	8ae080e7          	jalr	-1874(ra) # 80004934 <end_op>
    return -1;
    8000608e:	557d                	li	a0,-1
    80006090:	74aa                	ld	s1,168(sp)
    80006092:	b759                	j	80006018 <sys_open+0xe8>
      fileclose(f);
    80006094:	854a                	mv	a0,s2
    80006096:	fffff097          	auipc	ra,0xfffff
    8000609a:	cee080e7          	jalr	-786(ra) # 80004d84 <fileclose>
    8000609e:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800060a0:	8526                	mv	a0,s1
    800060a2:	ffffe097          	auipc	ra,0xffffe
    800060a6:	0b0080e7          	jalr	176(ra) # 80004152 <iunlockput>
    end_op();
    800060aa:	fffff097          	auipc	ra,0xfffff
    800060ae:	88a080e7          	jalr	-1910(ra) # 80004934 <end_op>
    return -1;
    800060b2:	557d                	li	a0,-1
    800060b4:	74aa                	ld	s1,168(sp)
    800060b6:	790a                	ld	s2,160(sp)
    800060b8:	b785                	j	80006018 <sys_open+0xe8>
    f->type = FD_DEVICE;
    800060ba:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    800060be:	04649783          	lh	a5,70(s1)
    800060c2:	02f91223          	sh	a5,36(s2)
    800060c6:	b729                	j	80005fd0 <sys_open+0xa0>
    itrunc(ip);
    800060c8:	8526                	mv	a0,s1
    800060ca:	ffffe097          	auipc	ra,0xffffe
    800060ce:	f34080e7          	jalr	-204(ra) # 80003ffe <itrunc>
    800060d2:	b735                	j	80005ffe <sys_open+0xce>

00000000800060d4 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800060d4:	7175                	addi	sp,sp,-144
    800060d6:	e506                	sd	ra,136(sp)
    800060d8:	e122                	sd	s0,128(sp)
    800060da:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800060dc:	ffffe097          	auipc	ra,0xffffe
    800060e0:	7de080e7          	jalr	2014(ra) # 800048ba <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800060e4:	08000613          	li	a2,128
    800060e8:	f7040593          	addi	a1,s0,-144
    800060ec:	4501                	li	a0,0
    800060ee:	ffffd097          	auipc	ra,0xffffd
    800060f2:	1dc080e7          	jalr	476(ra) # 800032ca <argstr>
    800060f6:	02054963          	bltz	a0,80006128 <sys_mkdir+0x54>
    800060fa:	4681                	li	a3,0
    800060fc:	4601                	li	a2,0
    800060fe:	4585                	li	a1,1
    80006100:	f7040513          	addi	a0,s0,-144
    80006104:	fffff097          	auipc	ra,0xfffff
    80006108:	7d6080e7          	jalr	2006(ra) # 800058da <create>
    8000610c:	cd11                	beqz	a0,80006128 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000610e:	ffffe097          	auipc	ra,0xffffe
    80006112:	044080e7          	jalr	68(ra) # 80004152 <iunlockput>
  end_op();
    80006116:	fffff097          	auipc	ra,0xfffff
    8000611a:	81e080e7          	jalr	-2018(ra) # 80004934 <end_op>
  return 0;
    8000611e:	4501                	li	a0,0
}
    80006120:	60aa                	ld	ra,136(sp)
    80006122:	640a                	ld	s0,128(sp)
    80006124:	6149                	addi	sp,sp,144
    80006126:	8082                	ret
    end_op();
    80006128:	fffff097          	auipc	ra,0xfffff
    8000612c:	80c080e7          	jalr	-2036(ra) # 80004934 <end_op>
    return -1;
    80006130:	557d                	li	a0,-1
    80006132:	b7fd                	j	80006120 <sys_mkdir+0x4c>

0000000080006134 <sys_mknod>:

uint64
sys_mknod(void)
{
    80006134:	7135                	addi	sp,sp,-160
    80006136:	ed06                	sd	ra,152(sp)
    80006138:	e922                	sd	s0,144(sp)
    8000613a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000613c:	ffffe097          	auipc	ra,0xffffe
    80006140:	77e080e7          	jalr	1918(ra) # 800048ba <begin_op>
  argint(1, &major);
    80006144:	f6c40593          	addi	a1,s0,-148
    80006148:	4505                	li	a0,1
    8000614a:	ffffd097          	auipc	ra,0xffffd
    8000614e:	140080e7          	jalr	320(ra) # 8000328a <argint>
  argint(2, &minor);
    80006152:	f6840593          	addi	a1,s0,-152
    80006156:	4509                	li	a0,2
    80006158:	ffffd097          	auipc	ra,0xffffd
    8000615c:	132080e7          	jalr	306(ra) # 8000328a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80006160:	08000613          	li	a2,128
    80006164:	f7040593          	addi	a1,s0,-144
    80006168:	4501                	li	a0,0
    8000616a:	ffffd097          	auipc	ra,0xffffd
    8000616e:	160080e7          	jalr	352(ra) # 800032ca <argstr>
    80006172:	02054b63          	bltz	a0,800061a8 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80006176:	f6841683          	lh	a3,-152(s0)
    8000617a:	f6c41603          	lh	a2,-148(s0)
    8000617e:	458d                	li	a1,3
    80006180:	f7040513          	addi	a0,s0,-144
    80006184:	fffff097          	auipc	ra,0xfffff
    80006188:	756080e7          	jalr	1878(ra) # 800058da <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000618c:	cd11                	beqz	a0,800061a8 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000618e:	ffffe097          	auipc	ra,0xffffe
    80006192:	fc4080e7          	jalr	-60(ra) # 80004152 <iunlockput>
  end_op();
    80006196:	ffffe097          	auipc	ra,0xffffe
    8000619a:	79e080e7          	jalr	1950(ra) # 80004934 <end_op>
  return 0;
    8000619e:	4501                	li	a0,0
}
    800061a0:	60ea                	ld	ra,152(sp)
    800061a2:	644a                	ld	s0,144(sp)
    800061a4:	610d                	addi	sp,sp,160
    800061a6:	8082                	ret
    end_op();
    800061a8:	ffffe097          	auipc	ra,0xffffe
    800061ac:	78c080e7          	jalr	1932(ra) # 80004934 <end_op>
    return -1;
    800061b0:	557d                	li	a0,-1
    800061b2:	b7fd                	j	800061a0 <sys_mknod+0x6c>

00000000800061b4 <sys_chdir>:

uint64
sys_chdir(void)
{
    800061b4:	7135                	addi	sp,sp,-160
    800061b6:	ed06                	sd	ra,152(sp)
    800061b8:	e922                	sd	s0,144(sp)
    800061ba:	e14a                	sd	s2,128(sp)
    800061bc:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800061be:	ffffc097          	auipc	ra,0xffffc
    800061c2:	8aa080e7          	jalr	-1878(ra) # 80001a68 <myproc>
    800061c6:	892a                	mv	s2,a0
  
  begin_op();
    800061c8:	ffffe097          	auipc	ra,0xffffe
    800061cc:	6f2080e7          	jalr	1778(ra) # 800048ba <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800061d0:	08000613          	li	a2,128
    800061d4:	f6040593          	addi	a1,s0,-160
    800061d8:	4501                	li	a0,0
    800061da:	ffffd097          	auipc	ra,0xffffd
    800061de:	0f0080e7          	jalr	240(ra) # 800032ca <argstr>
    800061e2:	04054d63          	bltz	a0,8000623c <sys_chdir+0x88>
    800061e6:	e526                	sd	s1,136(sp)
    800061e8:	f6040513          	addi	a0,s0,-160
    800061ec:	ffffe097          	auipc	ra,0xffffe
    800061f0:	4ce080e7          	jalr	1230(ra) # 800046ba <namei>
    800061f4:	84aa                	mv	s1,a0
    800061f6:	c131                	beqz	a0,8000623a <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    800061f8:	ffffe097          	auipc	ra,0xffffe
    800061fc:	cf4080e7          	jalr	-780(ra) # 80003eec <ilock>
  if(ip->type != T_DIR){
    80006200:	04449703          	lh	a4,68(s1)
    80006204:	4785                	li	a5,1
    80006206:	04f71163          	bne	a4,a5,80006248 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000620a:	8526                	mv	a0,s1
    8000620c:	ffffe097          	auipc	ra,0xffffe
    80006210:	da6080e7          	jalr	-602(ra) # 80003fb2 <iunlock>
  iput(p->cwd);
    80006214:	15893503          	ld	a0,344(s2)
    80006218:	ffffe097          	auipc	ra,0xffffe
    8000621c:	e92080e7          	jalr	-366(ra) # 800040aa <iput>
  end_op();
    80006220:	ffffe097          	auipc	ra,0xffffe
    80006224:	714080e7          	jalr	1812(ra) # 80004934 <end_op>
  p->cwd = ip;
    80006228:	14993c23          	sd	s1,344(s2)
  return 0;
    8000622c:	4501                	li	a0,0
    8000622e:	64aa                	ld	s1,136(sp)
}
    80006230:	60ea                	ld	ra,152(sp)
    80006232:	644a                	ld	s0,144(sp)
    80006234:	690a                	ld	s2,128(sp)
    80006236:	610d                	addi	sp,sp,160
    80006238:	8082                	ret
    8000623a:	64aa                	ld	s1,136(sp)
    end_op();
    8000623c:	ffffe097          	auipc	ra,0xffffe
    80006240:	6f8080e7          	jalr	1784(ra) # 80004934 <end_op>
    return -1;
    80006244:	557d                	li	a0,-1
    80006246:	b7ed                	j	80006230 <sys_chdir+0x7c>
    iunlockput(ip);
    80006248:	8526                	mv	a0,s1
    8000624a:	ffffe097          	auipc	ra,0xffffe
    8000624e:	f08080e7          	jalr	-248(ra) # 80004152 <iunlockput>
    end_op();
    80006252:	ffffe097          	auipc	ra,0xffffe
    80006256:	6e2080e7          	jalr	1762(ra) # 80004934 <end_op>
    return -1;
    8000625a:	557d                	li	a0,-1
    8000625c:	64aa                	ld	s1,136(sp)
    8000625e:	bfc9                	j	80006230 <sys_chdir+0x7c>

0000000080006260 <sys_exec>:

uint64
sys_exec(void)
{
    80006260:	7121                	addi	sp,sp,-448
    80006262:	ff06                	sd	ra,440(sp)
    80006264:	fb22                	sd	s0,432(sp)
    80006266:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80006268:	e4840593          	addi	a1,s0,-440
    8000626c:	4505                	li	a0,1
    8000626e:	ffffd097          	auipc	ra,0xffffd
    80006272:	03c080e7          	jalr	60(ra) # 800032aa <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80006276:	08000613          	li	a2,128
    8000627a:	f5040593          	addi	a1,s0,-176
    8000627e:	4501                	li	a0,0
    80006280:	ffffd097          	auipc	ra,0xffffd
    80006284:	04a080e7          	jalr	74(ra) # 800032ca <argstr>
    80006288:	87aa                	mv	a5,a0
    return -1;
    8000628a:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000628c:	0e07c263          	bltz	a5,80006370 <sys_exec+0x110>
    80006290:	f726                	sd	s1,424(sp)
    80006292:	f34a                	sd	s2,416(sp)
    80006294:	ef4e                	sd	s3,408(sp)
    80006296:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80006298:	10000613          	li	a2,256
    8000629c:	4581                	li	a1,0
    8000629e:	e5040513          	addi	a0,s0,-432
    800062a2:	ffffb097          	auipc	ra,0xffffb
    800062a6:	a92080e7          	jalr	-1390(ra) # 80000d34 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800062aa:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800062ae:	89a6                	mv	s3,s1
    800062b0:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800062b2:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800062b6:	00391513          	slli	a0,s2,0x3
    800062ba:	e4040593          	addi	a1,s0,-448
    800062be:	e4843783          	ld	a5,-440(s0)
    800062c2:	953e                	add	a0,a0,a5
    800062c4:	ffffd097          	auipc	ra,0xffffd
    800062c8:	f28080e7          	jalr	-216(ra) # 800031ec <fetchaddr>
    800062cc:	02054a63          	bltz	a0,80006300 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    800062d0:	e4043783          	ld	a5,-448(s0)
    800062d4:	c7b9                	beqz	a5,80006322 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800062d6:	ffffb097          	auipc	ra,0xffffb
    800062da:	872080e7          	jalr	-1934(ra) # 80000b48 <kalloc>
    800062de:	85aa                	mv	a1,a0
    800062e0:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800062e4:	cd11                	beqz	a0,80006300 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800062e6:	6605                	lui	a2,0x1
    800062e8:	e4043503          	ld	a0,-448(s0)
    800062ec:	ffffd097          	auipc	ra,0xffffd
    800062f0:	f52080e7          	jalr	-174(ra) # 8000323e <fetchstr>
    800062f4:	00054663          	bltz	a0,80006300 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    800062f8:	0905                	addi	s2,s2,1
    800062fa:	09a1                	addi	s3,s3,8
    800062fc:	fb491de3          	bne	s2,s4,800062b6 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006300:	f5040913          	addi	s2,s0,-176
    80006304:	6088                	ld	a0,0(s1)
    80006306:	c125                	beqz	a0,80006366 <sys_exec+0x106>
    kfree(argv[i]);
    80006308:	ffffa097          	auipc	ra,0xffffa
    8000630c:	742080e7          	jalr	1858(ra) # 80000a4a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006310:	04a1                	addi	s1,s1,8
    80006312:	ff2499e3          	bne	s1,s2,80006304 <sys_exec+0xa4>
  return -1;
    80006316:	557d                	li	a0,-1
    80006318:	74ba                	ld	s1,424(sp)
    8000631a:	791a                	ld	s2,416(sp)
    8000631c:	69fa                	ld	s3,408(sp)
    8000631e:	6a5a                	ld	s4,400(sp)
    80006320:	a881                	j	80006370 <sys_exec+0x110>
      argv[i] = 0;
    80006322:	0009079b          	sext.w	a5,s2
    80006326:	078e                	slli	a5,a5,0x3
    80006328:	fd078793          	addi	a5,a5,-48
    8000632c:	97a2                	add	a5,a5,s0
    8000632e:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80006332:	e5040593          	addi	a1,s0,-432
    80006336:	f5040513          	addi	a0,s0,-176
    8000633a:	fffff097          	auipc	ra,0xfffff
    8000633e:	120080e7          	jalr	288(ra) # 8000545a <exec>
    80006342:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006344:	f5040993          	addi	s3,s0,-176
    80006348:	6088                	ld	a0,0(s1)
    8000634a:	c901                	beqz	a0,8000635a <sys_exec+0xfa>
    kfree(argv[i]);
    8000634c:	ffffa097          	auipc	ra,0xffffa
    80006350:	6fe080e7          	jalr	1790(ra) # 80000a4a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006354:	04a1                	addi	s1,s1,8
    80006356:	ff3499e3          	bne	s1,s3,80006348 <sys_exec+0xe8>
  return ret;
    8000635a:	854a                	mv	a0,s2
    8000635c:	74ba                	ld	s1,424(sp)
    8000635e:	791a                	ld	s2,416(sp)
    80006360:	69fa                	ld	s3,408(sp)
    80006362:	6a5a                	ld	s4,400(sp)
    80006364:	a031                	j	80006370 <sys_exec+0x110>
  return -1;
    80006366:	557d                	li	a0,-1
    80006368:	74ba                	ld	s1,424(sp)
    8000636a:	791a                	ld	s2,416(sp)
    8000636c:	69fa                	ld	s3,408(sp)
    8000636e:	6a5a                	ld	s4,400(sp)
}
    80006370:	70fa                	ld	ra,440(sp)
    80006372:	745a                	ld	s0,432(sp)
    80006374:	6139                	addi	sp,sp,448
    80006376:	8082                	ret

0000000080006378 <sys_pipe>:

uint64
sys_pipe(void)
{
    80006378:	7139                	addi	sp,sp,-64
    8000637a:	fc06                	sd	ra,56(sp)
    8000637c:	f822                	sd	s0,48(sp)
    8000637e:	f426                	sd	s1,40(sp)
    80006380:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80006382:	ffffb097          	auipc	ra,0xffffb
    80006386:	6e6080e7          	jalr	1766(ra) # 80001a68 <myproc>
    8000638a:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000638c:	fd840593          	addi	a1,s0,-40
    80006390:	4501                	li	a0,0
    80006392:	ffffd097          	auipc	ra,0xffffd
    80006396:	f18080e7          	jalr	-232(ra) # 800032aa <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000639a:	fc840593          	addi	a1,s0,-56
    8000639e:	fd040513          	addi	a0,s0,-48
    800063a2:	fffff097          	auipc	ra,0xfffff
    800063a6:	d50080e7          	jalr	-688(ra) # 800050f2 <pipealloc>
    return -1;
    800063aa:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800063ac:	0c054463          	bltz	a0,80006474 <sys_pipe+0xfc>
  fd0 = -1;
    800063b0:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800063b4:	fd043503          	ld	a0,-48(s0)
    800063b8:	fffff097          	auipc	ra,0xfffff
    800063bc:	4e0080e7          	jalr	1248(ra) # 80005898 <fdalloc>
    800063c0:	fca42223          	sw	a0,-60(s0)
    800063c4:	08054b63          	bltz	a0,8000645a <sys_pipe+0xe2>
    800063c8:	fc843503          	ld	a0,-56(s0)
    800063cc:	fffff097          	auipc	ra,0xfffff
    800063d0:	4cc080e7          	jalr	1228(ra) # 80005898 <fdalloc>
    800063d4:	fca42023          	sw	a0,-64(s0)
    800063d8:	06054863          	bltz	a0,80006448 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800063dc:	4691                	li	a3,4
    800063de:	fc440613          	addi	a2,s0,-60
    800063e2:	fd843583          	ld	a1,-40(s0)
    800063e6:	6ca8                	ld	a0,88(s1)
    800063e8:	ffffb097          	auipc	ra,0xffffb
    800063ec:	2fa080e7          	jalr	762(ra) # 800016e2 <copyout>
    800063f0:	02054063          	bltz	a0,80006410 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800063f4:	4691                	li	a3,4
    800063f6:	fc040613          	addi	a2,s0,-64
    800063fa:	fd843583          	ld	a1,-40(s0)
    800063fe:	0591                	addi	a1,a1,4
    80006400:	6ca8                	ld	a0,88(s1)
    80006402:	ffffb097          	auipc	ra,0xffffb
    80006406:	2e0080e7          	jalr	736(ra) # 800016e2 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000640a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000640c:	06055463          	bgez	a0,80006474 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80006410:	fc442783          	lw	a5,-60(s0)
    80006414:	07e9                	addi	a5,a5,26
    80006416:	078e                	slli	a5,a5,0x3
    80006418:	97a6                	add	a5,a5,s1
    8000641a:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    8000641e:	fc042783          	lw	a5,-64(s0)
    80006422:	07e9                	addi	a5,a5,26
    80006424:	078e                	slli	a5,a5,0x3
    80006426:	94be                	add	s1,s1,a5
    80006428:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    8000642c:	fd043503          	ld	a0,-48(s0)
    80006430:	fffff097          	auipc	ra,0xfffff
    80006434:	954080e7          	jalr	-1708(ra) # 80004d84 <fileclose>
    fileclose(wf);
    80006438:	fc843503          	ld	a0,-56(s0)
    8000643c:	fffff097          	auipc	ra,0xfffff
    80006440:	948080e7          	jalr	-1720(ra) # 80004d84 <fileclose>
    return -1;
    80006444:	57fd                	li	a5,-1
    80006446:	a03d                	j	80006474 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80006448:	fc442783          	lw	a5,-60(s0)
    8000644c:	0007c763          	bltz	a5,8000645a <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80006450:	07e9                	addi	a5,a5,26
    80006452:	078e                	slli	a5,a5,0x3
    80006454:	97a6                	add	a5,a5,s1
    80006456:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    8000645a:	fd043503          	ld	a0,-48(s0)
    8000645e:	fffff097          	auipc	ra,0xfffff
    80006462:	926080e7          	jalr	-1754(ra) # 80004d84 <fileclose>
    fileclose(wf);
    80006466:	fc843503          	ld	a0,-56(s0)
    8000646a:	fffff097          	auipc	ra,0xfffff
    8000646e:	91a080e7          	jalr	-1766(ra) # 80004d84 <fileclose>
    return -1;
    80006472:	57fd                	li	a5,-1
}
    80006474:	853e                	mv	a0,a5
    80006476:	70e2                	ld	ra,56(sp)
    80006478:	7442                	ld	s0,48(sp)
    8000647a:	74a2                	ld	s1,40(sp)
    8000647c:	6121                	addi	sp,sp,64
    8000647e:	8082                	ret

0000000080006480 <kernelvec>:
    80006480:	7111                	addi	sp,sp,-256
    80006482:	e006                	sd	ra,0(sp)
    80006484:	e40a                	sd	sp,8(sp)
    80006486:	e80e                	sd	gp,16(sp)
    80006488:	ec12                	sd	tp,24(sp)
    8000648a:	f016                	sd	t0,32(sp)
    8000648c:	f41a                	sd	t1,40(sp)
    8000648e:	f81e                	sd	t2,48(sp)
    80006490:	fc22                	sd	s0,56(sp)
    80006492:	e0a6                	sd	s1,64(sp)
    80006494:	e4aa                	sd	a0,72(sp)
    80006496:	e8ae                	sd	a1,80(sp)
    80006498:	ecb2                	sd	a2,88(sp)
    8000649a:	f0b6                	sd	a3,96(sp)
    8000649c:	f4ba                	sd	a4,104(sp)
    8000649e:	f8be                	sd	a5,112(sp)
    800064a0:	fcc2                	sd	a6,120(sp)
    800064a2:	e146                	sd	a7,128(sp)
    800064a4:	e54a                	sd	s2,136(sp)
    800064a6:	e94e                	sd	s3,144(sp)
    800064a8:	ed52                	sd	s4,152(sp)
    800064aa:	f156                	sd	s5,160(sp)
    800064ac:	f55a                	sd	s6,168(sp)
    800064ae:	f95e                	sd	s7,176(sp)
    800064b0:	fd62                	sd	s8,184(sp)
    800064b2:	e1e6                	sd	s9,192(sp)
    800064b4:	e5ea                	sd	s10,200(sp)
    800064b6:	e9ee                	sd	s11,208(sp)
    800064b8:	edf2                	sd	t3,216(sp)
    800064ba:	f1f6                	sd	t4,224(sp)
    800064bc:	f5fa                	sd	t5,232(sp)
    800064be:	f9fe                	sd	t6,240(sp)
    800064c0:	bf7fc0ef          	jal	800030b6 <kerneltrap>
    800064c4:	6082                	ld	ra,0(sp)
    800064c6:	6122                	ld	sp,8(sp)
    800064c8:	61c2                	ld	gp,16(sp)
    800064ca:	7282                	ld	t0,32(sp)
    800064cc:	7322                	ld	t1,40(sp)
    800064ce:	73c2                	ld	t2,48(sp)
    800064d0:	7462                	ld	s0,56(sp)
    800064d2:	6486                	ld	s1,64(sp)
    800064d4:	6526                	ld	a0,72(sp)
    800064d6:	65c6                	ld	a1,80(sp)
    800064d8:	6666                	ld	a2,88(sp)
    800064da:	7686                	ld	a3,96(sp)
    800064dc:	7726                	ld	a4,104(sp)
    800064de:	77c6                	ld	a5,112(sp)
    800064e0:	7866                	ld	a6,120(sp)
    800064e2:	688a                	ld	a7,128(sp)
    800064e4:	692a                	ld	s2,136(sp)
    800064e6:	69ca                	ld	s3,144(sp)
    800064e8:	6a6a                	ld	s4,152(sp)
    800064ea:	7a8a                	ld	s5,160(sp)
    800064ec:	7b2a                	ld	s6,168(sp)
    800064ee:	7bca                	ld	s7,176(sp)
    800064f0:	7c6a                	ld	s8,184(sp)
    800064f2:	6c8e                	ld	s9,192(sp)
    800064f4:	6d2e                	ld	s10,200(sp)
    800064f6:	6dce                	ld	s11,208(sp)
    800064f8:	6e6e                	ld	t3,216(sp)
    800064fa:	7e8e                	ld	t4,224(sp)
    800064fc:	7f2e                	ld	t5,232(sp)
    800064fe:	7fce                	ld	t6,240(sp)
    80006500:	6111                	addi	sp,sp,256
    80006502:	10200073          	sret
    80006506:	00000013          	nop
    8000650a:	00000013          	nop
    8000650e:	0001                	nop

0000000080006510 <timervec>:
    80006510:	34051573          	csrrw	a0,mscratch,a0
    80006514:	e10c                	sd	a1,0(a0)
    80006516:	e510                	sd	a2,8(a0)
    80006518:	e914                	sd	a3,16(a0)
    8000651a:	6d0c                	ld	a1,24(a0)
    8000651c:	7110                	ld	a2,32(a0)
    8000651e:	6194                	ld	a3,0(a1)
    80006520:	96b2                	add	a3,a3,a2
    80006522:	e194                	sd	a3,0(a1)
    80006524:	4589                	li	a1,2
    80006526:	14459073          	csrw	sip,a1
    8000652a:	6914                	ld	a3,16(a0)
    8000652c:	6510                	ld	a2,8(a0)
    8000652e:	610c                	ld	a1,0(a0)
    80006530:	34051573          	csrrw	a0,mscratch,a0
    80006534:	30200073          	mret
	...

000000008000653a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000653a:	1141                	addi	sp,sp,-16
    8000653c:	e422                	sd	s0,8(sp)
    8000653e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006540:	0c0007b7          	lui	a5,0xc000
    80006544:	4705                	li	a4,1
    80006546:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006548:	0c0007b7          	lui	a5,0xc000
    8000654c:	c3d8                	sw	a4,4(a5)
}
    8000654e:	6422                	ld	s0,8(sp)
    80006550:	0141                	addi	sp,sp,16
    80006552:	8082                	ret

0000000080006554 <plicinithart>:

void
plicinithart(void)
{
    80006554:	1141                	addi	sp,sp,-16
    80006556:	e406                	sd	ra,8(sp)
    80006558:	e022                	sd	s0,0(sp)
    8000655a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000655c:	ffffb097          	auipc	ra,0xffffb
    80006560:	4e0080e7          	jalr	1248(ra) # 80001a3c <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006564:	0085171b          	slliw	a4,a0,0x8
    80006568:	0c0027b7          	lui	a5,0xc002
    8000656c:	97ba                	add	a5,a5,a4
    8000656e:	40200713          	li	a4,1026
    80006572:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006576:	00d5151b          	slliw	a0,a0,0xd
    8000657a:	0c2017b7          	lui	a5,0xc201
    8000657e:	97aa                	add	a5,a5,a0
    80006580:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80006584:	60a2                	ld	ra,8(sp)
    80006586:	6402                	ld	s0,0(sp)
    80006588:	0141                	addi	sp,sp,16
    8000658a:	8082                	ret

000000008000658c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000658c:	1141                	addi	sp,sp,-16
    8000658e:	e406                	sd	ra,8(sp)
    80006590:	e022                	sd	s0,0(sp)
    80006592:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006594:	ffffb097          	auipc	ra,0xffffb
    80006598:	4a8080e7          	jalr	1192(ra) # 80001a3c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000659c:	00d5151b          	slliw	a0,a0,0xd
    800065a0:	0c2017b7          	lui	a5,0xc201
    800065a4:	97aa                	add	a5,a5,a0
  return irq;
}
    800065a6:	43c8                	lw	a0,4(a5)
    800065a8:	60a2                	ld	ra,8(sp)
    800065aa:	6402                	ld	s0,0(sp)
    800065ac:	0141                	addi	sp,sp,16
    800065ae:	8082                	ret

00000000800065b0 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800065b0:	1101                	addi	sp,sp,-32
    800065b2:	ec06                	sd	ra,24(sp)
    800065b4:	e822                	sd	s0,16(sp)
    800065b6:	e426                	sd	s1,8(sp)
    800065b8:	1000                	addi	s0,sp,32
    800065ba:	84aa                	mv	s1,a0
  int hart = cpuid();
    800065bc:	ffffb097          	auipc	ra,0xffffb
    800065c0:	480080e7          	jalr	1152(ra) # 80001a3c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800065c4:	00d5151b          	slliw	a0,a0,0xd
    800065c8:	0c2017b7          	lui	a5,0xc201
    800065cc:	97aa                	add	a5,a5,a0
    800065ce:	c3c4                	sw	s1,4(a5)
}
    800065d0:	60e2                	ld	ra,24(sp)
    800065d2:	6442                	ld	s0,16(sp)
    800065d4:	64a2                	ld	s1,8(sp)
    800065d6:	6105                	addi	sp,sp,32
    800065d8:	8082                	ret

00000000800065da <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800065da:	1141                	addi	sp,sp,-16
    800065dc:	e406                	sd	ra,8(sp)
    800065de:	e022                	sd	s0,0(sp)
    800065e0:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800065e2:	479d                	li	a5,7
    800065e4:	04a7cc63          	blt	a5,a0,8000663c <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800065e8:	0001f797          	auipc	a5,0x1f
    800065ec:	bf078793          	addi	a5,a5,-1040 # 800251d8 <disk>
    800065f0:	97aa                	add	a5,a5,a0
    800065f2:	0187c783          	lbu	a5,24(a5)
    800065f6:	ebb9                	bnez	a5,8000664c <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800065f8:	00451693          	slli	a3,a0,0x4
    800065fc:	0001f797          	auipc	a5,0x1f
    80006600:	bdc78793          	addi	a5,a5,-1060 # 800251d8 <disk>
    80006604:	6398                	ld	a4,0(a5)
    80006606:	9736                	add	a4,a4,a3
    80006608:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    8000660c:	6398                	ld	a4,0(a5)
    8000660e:	9736                	add	a4,a4,a3
    80006610:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80006614:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006618:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    8000661c:	97aa                	add	a5,a5,a0
    8000661e:	4705                	li	a4,1
    80006620:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80006624:	0001f517          	auipc	a0,0x1f
    80006628:	bcc50513          	addi	a0,a0,-1076 # 800251f0 <disk+0x18>
    8000662c:	ffffc097          	auipc	ra,0xffffc
    80006630:	12c080e7          	jalr	300(ra) # 80002758 <wakeup>
}
    80006634:	60a2                	ld	ra,8(sp)
    80006636:	6402                	ld	s0,0(sp)
    80006638:	0141                	addi	sp,sp,16
    8000663a:	8082                	ret
    panic("free_desc 1");
    8000663c:	00002517          	auipc	a0,0x2
    80006640:	10450513          	addi	a0,a0,260 # 80008740 <etext+0x740>
    80006644:	ffffa097          	auipc	ra,0xffffa
    80006648:	f1c080e7          	jalr	-228(ra) # 80000560 <panic>
    panic("free_desc 2");
    8000664c:	00002517          	auipc	a0,0x2
    80006650:	10450513          	addi	a0,a0,260 # 80008750 <etext+0x750>
    80006654:	ffffa097          	auipc	ra,0xffffa
    80006658:	f0c080e7          	jalr	-244(ra) # 80000560 <panic>

000000008000665c <virtio_disk_init>:
{
    8000665c:	1101                	addi	sp,sp,-32
    8000665e:	ec06                	sd	ra,24(sp)
    80006660:	e822                	sd	s0,16(sp)
    80006662:	e426                	sd	s1,8(sp)
    80006664:	e04a                	sd	s2,0(sp)
    80006666:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006668:	00002597          	auipc	a1,0x2
    8000666c:	0f858593          	addi	a1,a1,248 # 80008760 <etext+0x760>
    80006670:	0001f517          	auipc	a0,0x1f
    80006674:	c9050513          	addi	a0,a0,-880 # 80025300 <disk+0x128>
    80006678:	ffffa097          	auipc	ra,0xffffa
    8000667c:	530080e7          	jalr	1328(ra) # 80000ba8 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006680:	100017b7          	lui	a5,0x10001
    80006684:	4398                	lw	a4,0(a5)
    80006686:	2701                	sext.w	a4,a4
    80006688:	747277b7          	lui	a5,0x74727
    8000668c:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006690:	18f71c63          	bne	a4,a5,80006828 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006694:	100017b7          	lui	a5,0x10001
    80006698:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    8000669a:	439c                	lw	a5,0(a5)
    8000669c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000669e:	4709                	li	a4,2
    800066a0:	18e79463          	bne	a5,a4,80006828 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800066a4:	100017b7          	lui	a5,0x10001
    800066a8:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800066aa:	439c                	lw	a5,0(a5)
    800066ac:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800066ae:	16e79d63          	bne	a5,a4,80006828 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800066b2:	100017b7          	lui	a5,0x10001
    800066b6:	47d8                	lw	a4,12(a5)
    800066b8:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800066ba:	554d47b7          	lui	a5,0x554d4
    800066be:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800066c2:	16f71363          	bne	a4,a5,80006828 <virtio_disk_init+0x1cc>
  *R(VIRTIO_MMIO_STATUS) = status;
    800066c6:	100017b7          	lui	a5,0x10001
    800066ca:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800066ce:	4705                	li	a4,1
    800066d0:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800066d2:	470d                	li	a4,3
    800066d4:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800066d6:	10001737          	lui	a4,0x10001
    800066da:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800066dc:	c7ffe737          	lui	a4,0xc7ffe
    800066e0:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd9447>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800066e4:	8ef9                	and	a3,a3,a4
    800066e6:	10001737          	lui	a4,0x10001
    800066ea:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    800066ec:	472d                	li	a4,11
    800066ee:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800066f0:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    800066f4:	439c                	lw	a5,0(a5)
    800066f6:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800066fa:	8ba1                	andi	a5,a5,8
    800066fc:	12078e63          	beqz	a5,80006838 <virtio_disk_init+0x1dc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006700:	100017b7          	lui	a5,0x10001
    80006704:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80006708:	100017b7          	lui	a5,0x10001
    8000670c:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80006710:	439c                	lw	a5,0(a5)
    80006712:	2781                	sext.w	a5,a5
    80006714:	12079a63          	bnez	a5,80006848 <virtio_disk_init+0x1ec>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006718:	100017b7          	lui	a5,0x10001
    8000671c:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80006720:	439c                	lw	a5,0(a5)
    80006722:	2781                	sext.w	a5,a5
  if(max == 0)
    80006724:	12078a63          	beqz	a5,80006858 <virtio_disk_init+0x1fc>
  if(max < NUM)
    80006728:	471d                	li	a4,7
    8000672a:	12f77f63          	bgeu	a4,a5,80006868 <virtio_disk_init+0x20c>
  disk.desc = kalloc();
    8000672e:	ffffa097          	auipc	ra,0xffffa
    80006732:	41a080e7          	jalr	1050(ra) # 80000b48 <kalloc>
    80006736:	0001f497          	auipc	s1,0x1f
    8000673a:	aa248493          	addi	s1,s1,-1374 # 800251d8 <disk>
    8000673e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006740:	ffffa097          	auipc	ra,0xffffa
    80006744:	408080e7          	jalr	1032(ra) # 80000b48 <kalloc>
    80006748:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000674a:	ffffa097          	auipc	ra,0xffffa
    8000674e:	3fe080e7          	jalr	1022(ra) # 80000b48 <kalloc>
    80006752:	87aa                	mv	a5,a0
    80006754:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006756:	6088                	ld	a0,0(s1)
    80006758:	12050063          	beqz	a0,80006878 <virtio_disk_init+0x21c>
    8000675c:	0001f717          	auipc	a4,0x1f
    80006760:	a8473703          	ld	a4,-1404(a4) # 800251e0 <disk+0x8>
    80006764:	10070a63          	beqz	a4,80006878 <virtio_disk_init+0x21c>
    80006768:	10078863          	beqz	a5,80006878 <virtio_disk_init+0x21c>
  memset(disk.desc, 0, PGSIZE);
    8000676c:	6605                	lui	a2,0x1
    8000676e:	4581                	li	a1,0
    80006770:	ffffa097          	auipc	ra,0xffffa
    80006774:	5c4080e7          	jalr	1476(ra) # 80000d34 <memset>
  memset(disk.avail, 0, PGSIZE);
    80006778:	0001f497          	auipc	s1,0x1f
    8000677c:	a6048493          	addi	s1,s1,-1440 # 800251d8 <disk>
    80006780:	6605                	lui	a2,0x1
    80006782:	4581                	li	a1,0
    80006784:	6488                	ld	a0,8(s1)
    80006786:	ffffa097          	auipc	ra,0xffffa
    8000678a:	5ae080e7          	jalr	1454(ra) # 80000d34 <memset>
  memset(disk.used, 0, PGSIZE);
    8000678e:	6605                	lui	a2,0x1
    80006790:	4581                	li	a1,0
    80006792:	6888                	ld	a0,16(s1)
    80006794:	ffffa097          	auipc	ra,0xffffa
    80006798:	5a0080e7          	jalr	1440(ra) # 80000d34 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000679c:	100017b7          	lui	a5,0x10001
    800067a0:	4721                	li	a4,8
    800067a2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800067a4:	4098                	lw	a4,0(s1)
    800067a6:	100017b7          	lui	a5,0x10001
    800067aa:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800067ae:	40d8                	lw	a4,4(s1)
    800067b0:	100017b7          	lui	a5,0x10001
    800067b4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800067b8:	649c                	ld	a5,8(s1)
    800067ba:	0007869b          	sext.w	a3,a5
    800067be:	10001737          	lui	a4,0x10001
    800067c2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800067c6:	9781                	srai	a5,a5,0x20
    800067c8:	10001737          	lui	a4,0x10001
    800067cc:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800067d0:	689c                	ld	a5,16(s1)
    800067d2:	0007869b          	sext.w	a3,a5
    800067d6:	10001737          	lui	a4,0x10001
    800067da:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800067de:	9781                	srai	a5,a5,0x20
    800067e0:	10001737          	lui	a4,0x10001
    800067e4:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800067e8:	10001737          	lui	a4,0x10001
    800067ec:	4785                	li	a5,1
    800067ee:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    800067f0:	00f48c23          	sb	a5,24(s1)
    800067f4:	00f48ca3          	sb	a5,25(s1)
    800067f8:	00f48d23          	sb	a5,26(s1)
    800067fc:	00f48da3          	sb	a5,27(s1)
    80006800:	00f48e23          	sb	a5,28(s1)
    80006804:	00f48ea3          	sb	a5,29(s1)
    80006808:	00f48f23          	sb	a5,30(s1)
    8000680c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006810:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006814:	100017b7          	lui	a5,0x10001
    80006818:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000681c:	60e2                	ld	ra,24(sp)
    8000681e:	6442                	ld	s0,16(sp)
    80006820:	64a2                	ld	s1,8(sp)
    80006822:	6902                	ld	s2,0(sp)
    80006824:	6105                	addi	sp,sp,32
    80006826:	8082                	ret
    panic("could not find virtio disk");
    80006828:	00002517          	auipc	a0,0x2
    8000682c:	f4850513          	addi	a0,a0,-184 # 80008770 <etext+0x770>
    80006830:	ffffa097          	auipc	ra,0xffffa
    80006834:	d30080e7          	jalr	-720(ra) # 80000560 <panic>
    panic("virtio disk FEATURES_OK unset");
    80006838:	00002517          	auipc	a0,0x2
    8000683c:	f5850513          	addi	a0,a0,-168 # 80008790 <etext+0x790>
    80006840:	ffffa097          	auipc	ra,0xffffa
    80006844:	d20080e7          	jalr	-736(ra) # 80000560 <panic>
    panic("virtio disk should not be ready");
    80006848:	00002517          	auipc	a0,0x2
    8000684c:	f6850513          	addi	a0,a0,-152 # 800087b0 <etext+0x7b0>
    80006850:	ffffa097          	auipc	ra,0xffffa
    80006854:	d10080e7          	jalr	-752(ra) # 80000560 <panic>
    panic("virtio disk has no queue 0");
    80006858:	00002517          	auipc	a0,0x2
    8000685c:	f7850513          	addi	a0,a0,-136 # 800087d0 <etext+0x7d0>
    80006860:	ffffa097          	auipc	ra,0xffffa
    80006864:	d00080e7          	jalr	-768(ra) # 80000560 <panic>
    panic("virtio disk max queue too short");
    80006868:	00002517          	auipc	a0,0x2
    8000686c:	f8850513          	addi	a0,a0,-120 # 800087f0 <etext+0x7f0>
    80006870:	ffffa097          	auipc	ra,0xffffa
    80006874:	cf0080e7          	jalr	-784(ra) # 80000560 <panic>
    panic("virtio disk kalloc");
    80006878:	00002517          	auipc	a0,0x2
    8000687c:	f9850513          	addi	a0,a0,-104 # 80008810 <etext+0x810>
    80006880:	ffffa097          	auipc	ra,0xffffa
    80006884:	ce0080e7          	jalr	-800(ra) # 80000560 <panic>

0000000080006888 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006888:	7159                	addi	sp,sp,-112
    8000688a:	f486                	sd	ra,104(sp)
    8000688c:	f0a2                	sd	s0,96(sp)
    8000688e:	eca6                	sd	s1,88(sp)
    80006890:	e8ca                	sd	s2,80(sp)
    80006892:	e4ce                	sd	s3,72(sp)
    80006894:	e0d2                	sd	s4,64(sp)
    80006896:	fc56                	sd	s5,56(sp)
    80006898:	f85a                	sd	s6,48(sp)
    8000689a:	f45e                	sd	s7,40(sp)
    8000689c:	f062                	sd	s8,32(sp)
    8000689e:	ec66                	sd	s9,24(sp)
    800068a0:	1880                	addi	s0,sp,112
    800068a2:	8a2a                	mv	s4,a0
    800068a4:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800068a6:	00c52c83          	lw	s9,12(a0)
    800068aa:	001c9c9b          	slliw	s9,s9,0x1
    800068ae:	1c82                	slli	s9,s9,0x20
    800068b0:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800068b4:	0001f517          	auipc	a0,0x1f
    800068b8:	a4c50513          	addi	a0,a0,-1460 # 80025300 <disk+0x128>
    800068bc:	ffffa097          	auipc	ra,0xffffa
    800068c0:	37c080e7          	jalr	892(ra) # 80000c38 <acquire>
  for(int i = 0; i < 3; i++){
    800068c4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800068c6:	44a1                	li	s1,8
      disk.free[i] = 0;
    800068c8:	0001fb17          	auipc	s6,0x1f
    800068cc:	910b0b13          	addi	s6,s6,-1776 # 800251d8 <disk>
  for(int i = 0; i < 3; i++){
    800068d0:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800068d2:	0001fc17          	auipc	s8,0x1f
    800068d6:	a2ec0c13          	addi	s8,s8,-1490 # 80025300 <disk+0x128>
    800068da:	a0ad                	j	80006944 <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    800068dc:	00fb0733          	add	a4,s6,a5
    800068e0:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    800068e4:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800068e6:	0207c563          	bltz	a5,80006910 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800068ea:	2905                	addiw	s2,s2,1
    800068ec:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800068ee:	05590f63          	beq	s2,s5,8000694c <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    800068f2:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800068f4:	0001f717          	auipc	a4,0x1f
    800068f8:	8e470713          	addi	a4,a4,-1820 # 800251d8 <disk>
    800068fc:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800068fe:	01874683          	lbu	a3,24(a4)
    80006902:	fee9                	bnez	a3,800068dc <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    80006904:	2785                	addiw	a5,a5,1
    80006906:	0705                	addi	a4,a4,1
    80006908:	fe979be3          	bne	a5,s1,800068fe <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000690c:	57fd                	li	a5,-1
    8000690e:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80006910:	03205163          	blez	s2,80006932 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    80006914:	f9042503          	lw	a0,-112(s0)
    80006918:	00000097          	auipc	ra,0x0
    8000691c:	cc2080e7          	jalr	-830(ra) # 800065da <free_desc>
      for(int j = 0; j < i; j++)
    80006920:	4785                	li	a5,1
    80006922:	0127d863          	bge	a5,s2,80006932 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    80006926:	f9442503          	lw	a0,-108(s0)
    8000692a:	00000097          	auipc	ra,0x0
    8000692e:	cb0080e7          	jalr	-848(ra) # 800065da <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006932:	85e2                	mv	a1,s8
    80006934:	0001f517          	auipc	a0,0x1f
    80006938:	8bc50513          	addi	a0,a0,-1860 # 800251f0 <disk+0x18>
    8000693c:	ffffc097          	auipc	ra,0xffffc
    80006940:	db8080e7          	jalr	-584(ra) # 800026f4 <sleep>
  for(int i = 0; i < 3; i++){
    80006944:	f9040613          	addi	a2,s0,-112
    80006948:	894e                	mv	s2,s3
    8000694a:	b765                	j	800068f2 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000694c:	f9042503          	lw	a0,-112(s0)
    80006950:	00451693          	slli	a3,a0,0x4

  if(write)
    80006954:	0001f797          	auipc	a5,0x1f
    80006958:	88478793          	addi	a5,a5,-1916 # 800251d8 <disk>
    8000695c:	00a50713          	addi	a4,a0,10
    80006960:	0712                	slli	a4,a4,0x4
    80006962:	973e                	add	a4,a4,a5
    80006964:	01703633          	snez	a2,s7
    80006968:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000696a:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    8000696e:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006972:	6398                	ld	a4,0(a5)
    80006974:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006976:	0a868613          	addi	a2,a3,168
    8000697a:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000697c:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000697e:	6390                	ld	a2,0(a5)
    80006980:	00d605b3          	add	a1,a2,a3
    80006984:	4741                	li	a4,16
    80006986:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006988:	4805                	li	a6,1
    8000698a:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    8000698e:	f9442703          	lw	a4,-108(s0)
    80006992:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006996:	0712                	slli	a4,a4,0x4
    80006998:	963a                	add	a2,a2,a4
    8000699a:	058a0593          	addi	a1,s4,88
    8000699e:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800069a0:	0007b883          	ld	a7,0(a5)
    800069a4:	9746                	add	a4,a4,a7
    800069a6:	40000613          	li	a2,1024
    800069aa:	c710                	sw	a2,8(a4)
  if(write)
    800069ac:	001bb613          	seqz	a2,s7
    800069b0:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800069b4:	00166613          	ori	a2,a2,1
    800069b8:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800069bc:	f9842583          	lw	a1,-104(s0)
    800069c0:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800069c4:	00250613          	addi	a2,a0,2
    800069c8:	0612                	slli	a2,a2,0x4
    800069ca:	963e                	add	a2,a2,a5
    800069cc:	577d                	li	a4,-1
    800069ce:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800069d2:	0592                	slli	a1,a1,0x4
    800069d4:	98ae                	add	a7,a7,a1
    800069d6:	03068713          	addi	a4,a3,48
    800069da:	973e                	add	a4,a4,a5
    800069dc:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800069e0:	6398                	ld	a4,0(a5)
    800069e2:	972e                	add	a4,a4,a1
    800069e4:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800069e8:	4689                	li	a3,2
    800069ea:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    800069ee:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800069f2:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    800069f6:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800069fa:	6794                	ld	a3,8(a5)
    800069fc:	0026d703          	lhu	a4,2(a3)
    80006a00:	8b1d                	andi	a4,a4,7
    80006a02:	0706                	slli	a4,a4,0x1
    80006a04:	96ba                	add	a3,a3,a4
    80006a06:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80006a0a:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80006a0e:	6798                	ld	a4,8(a5)
    80006a10:	00275783          	lhu	a5,2(a4)
    80006a14:	2785                	addiw	a5,a5,1
    80006a16:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006a1a:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006a1e:	100017b7          	lui	a5,0x10001
    80006a22:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006a26:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80006a2a:	0001f917          	auipc	s2,0x1f
    80006a2e:	8d690913          	addi	s2,s2,-1834 # 80025300 <disk+0x128>
  while(b->disk == 1) {
    80006a32:	4485                	li	s1,1
    80006a34:	01079c63          	bne	a5,a6,80006a4c <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80006a38:	85ca                	mv	a1,s2
    80006a3a:	8552                	mv	a0,s4
    80006a3c:	ffffc097          	auipc	ra,0xffffc
    80006a40:	cb8080e7          	jalr	-840(ra) # 800026f4 <sleep>
  while(b->disk == 1) {
    80006a44:	004a2783          	lw	a5,4(s4)
    80006a48:	fe9788e3          	beq	a5,s1,80006a38 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80006a4c:	f9042903          	lw	s2,-112(s0)
    80006a50:	00290713          	addi	a4,s2,2
    80006a54:	0712                	slli	a4,a4,0x4
    80006a56:	0001e797          	auipc	a5,0x1e
    80006a5a:	78278793          	addi	a5,a5,1922 # 800251d8 <disk>
    80006a5e:	97ba                	add	a5,a5,a4
    80006a60:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006a64:	0001e997          	auipc	s3,0x1e
    80006a68:	77498993          	addi	s3,s3,1908 # 800251d8 <disk>
    80006a6c:	00491713          	slli	a4,s2,0x4
    80006a70:	0009b783          	ld	a5,0(s3)
    80006a74:	97ba                	add	a5,a5,a4
    80006a76:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006a7a:	854a                	mv	a0,s2
    80006a7c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006a80:	00000097          	auipc	ra,0x0
    80006a84:	b5a080e7          	jalr	-1190(ra) # 800065da <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006a88:	8885                	andi	s1,s1,1
    80006a8a:	f0ed                	bnez	s1,80006a6c <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006a8c:	0001f517          	auipc	a0,0x1f
    80006a90:	87450513          	addi	a0,a0,-1932 # 80025300 <disk+0x128>
    80006a94:	ffffa097          	auipc	ra,0xffffa
    80006a98:	258080e7          	jalr	600(ra) # 80000cec <release>
}
    80006a9c:	70a6                	ld	ra,104(sp)
    80006a9e:	7406                	ld	s0,96(sp)
    80006aa0:	64e6                	ld	s1,88(sp)
    80006aa2:	6946                	ld	s2,80(sp)
    80006aa4:	69a6                	ld	s3,72(sp)
    80006aa6:	6a06                	ld	s4,64(sp)
    80006aa8:	7ae2                	ld	s5,56(sp)
    80006aaa:	7b42                	ld	s6,48(sp)
    80006aac:	7ba2                	ld	s7,40(sp)
    80006aae:	7c02                	ld	s8,32(sp)
    80006ab0:	6ce2                	ld	s9,24(sp)
    80006ab2:	6165                	addi	sp,sp,112
    80006ab4:	8082                	ret

0000000080006ab6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006ab6:	1101                	addi	sp,sp,-32
    80006ab8:	ec06                	sd	ra,24(sp)
    80006aba:	e822                	sd	s0,16(sp)
    80006abc:	e426                	sd	s1,8(sp)
    80006abe:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006ac0:	0001e497          	auipc	s1,0x1e
    80006ac4:	71848493          	addi	s1,s1,1816 # 800251d8 <disk>
    80006ac8:	0001f517          	auipc	a0,0x1f
    80006acc:	83850513          	addi	a0,a0,-1992 # 80025300 <disk+0x128>
    80006ad0:	ffffa097          	auipc	ra,0xffffa
    80006ad4:	168080e7          	jalr	360(ra) # 80000c38 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006ad8:	100017b7          	lui	a5,0x10001
    80006adc:	53b8                	lw	a4,96(a5)
    80006ade:	8b0d                	andi	a4,a4,3
    80006ae0:	100017b7          	lui	a5,0x10001
    80006ae4:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80006ae6:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006aea:	689c                	ld	a5,16(s1)
    80006aec:	0204d703          	lhu	a4,32(s1)
    80006af0:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80006af4:	04f70863          	beq	a4,a5,80006b44 <virtio_disk_intr+0x8e>
    __sync_synchronize();
    80006af8:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006afc:	6898                	ld	a4,16(s1)
    80006afe:	0204d783          	lhu	a5,32(s1)
    80006b02:	8b9d                	andi	a5,a5,7
    80006b04:	078e                	slli	a5,a5,0x3
    80006b06:	97ba                	add	a5,a5,a4
    80006b08:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006b0a:	00278713          	addi	a4,a5,2
    80006b0e:	0712                	slli	a4,a4,0x4
    80006b10:	9726                	add	a4,a4,s1
    80006b12:	01074703          	lbu	a4,16(a4)
    80006b16:	e721                	bnez	a4,80006b5e <virtio_disk_intr+0xa8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006b18:	0789                	addi	a5,a5,2
    80006b1a:	0792                	slli	a5,a5,0x4
    80006b1c:	97a6                	add	a5,a5,s1
    80006b1e:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80006b20:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006b24:	ffffc097          	auipc	ra,0xffffc
    80006b28:	c34080e7          	jalr	-972(ra) # 80002758 <wakeup>

    disk.used_idx += 1;
    80006b2c:	0204d783          	lhu	a5,32(s1)
    80006b30:	2785                	addiw	a5,a5,1
    80006b32:	17c2                	slli	a5,a5,0x30
    80006b34:	93c1                	srli	a5,a5,0x30
    80006b36:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006b3a:	6898                	ld	a4,16(s1)
    80006b3c:	00275703          	lhu	a4,2(a4)
    80006b40:	faf71ce3          	bne	a4,a5,80006af8 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    80006b44:	0001e517          	auipc	a0,0x1e
    80006b48:	7bc50513          	addi	a0,a0,1980 # 80025300 <disk+0x128>
    80006b4c:	ffffa097          	auipc	ra,0xffffa
    80006b50:	1a0080e7          	jalr	416(ra) # 80000cec <release>
}
    80006b54:	60e2                	ld	ra,24(sp)
    80006b56:	6442                	ld	s0,16(sp)
    80006b58:	64a2                	ld	s1,8(sp)
    80006b5a:	6105                	addi	sp,sp,32
    80006b5c:	8082                	ret
      panic("virtio_disk_intr status");
    80006b5e:	00002517          	auipc	a0,0x2
    80006b62:	cca50513          	addi	a0,a0,-822 # 80008828 <etext+0x828>
    80006b66:	ffffa097          	auipc	ra,0xffffa
    80006b6a:	9fa080e7          	jalr	-1542(ra) # 80000560 <panic>
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
