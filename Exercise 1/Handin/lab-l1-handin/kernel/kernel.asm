
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000e117          	auipc	sp,0xe
    80000004:	e5013103          	ld	sp,-432(sp) # 8000de50 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	1a4000ef          	jal	800001ba <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <r_mhartid>:
#ifndef __ASSEMBLER__

// which hart (core) is this?
static inline uint64
r_mhartid()
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec22                	sd	s0,24(sp)
    80000020:	1000                	addi	s0,sp,32
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
    80000026:	fef43423          	sd	a5,-24(s0)
  return x;
    8000002a:	fe843783          	ld	a5,-24(s0)
}
    8000002e:	853e                	mv	a0,a5
    80000030:	6462                	ld	s0,24(sp)
    80000032:	6105                	addi	sp,sp,32
    80000034:	8082                	ret

0000000080000036 <r_mstatus>:
#define MSTATUS_MPP_U (0L << 11)
#define MSTATUS_MIE (1L << 3)    // machine-mode interrupt enable.

static inline uint64
r_mstatus()
{
    80000036:	1101                	addi	sp,sp,-32
    80000038:	ec22                	sd	s0,24(sp)
    8000003a:	1000                	addi	s0,sp,32
  uint64 x;
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000003c:	300027f3          	csrr	a5,mstatus
    80000040:	fef43423          	sd	a5,-24(s0)
  return x;
    80000044:	fe843783          	ld	a5,-24(s0)
}
    80000048:	853e                	mv	a0,a5
    8000004a:	6462                	ld	s0,24(sp)
    8000004c:	6105                	addi	sp,sp,32
    8000004e:	8082                	ret

0000000080000050 <w_mstatus>:

static inline void 
w_mstatus(uint64 x)
{
    80000050:	1101                	addi	sp,sp,-32
    80000052:	ec22                	sd	s0,24(sp)
    80000054:	1000                	addi	s0,sp,32
    80000056:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000005a:	fe843783          	ld	a5,-24(s0)
    8000005e:	30079073          	csrw	mstatus,a5
}
    80000062:	0001                	nop
    80000064:	6462                	ld	s0,24(sp)
    80000066:	6105                	addi	sp,sp,32
    80000068:	8082                	ret

000000008000006a <w_mepc>:
// machine exception program counter, holds the
// instruction address to which a return from
// exception will go.
static inline void 
w_mepc(uint64 x)
{
    8000006a:	1101                	addi	sp,sp,-32
    8000006c:	ec22                	sd	s0,24(sp)
    8000006e:	1000                	addi	s0,sp,32
    80000070:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000074:	fe843783          	ld	a5,-24(s0)
    80000078:	34179073          	csrw	mepc,a5
}
    8000007c:	0001                	nop
    8000007e:	6462                	ld	s0,24(sp)
    80000080:	6105                	addi	sp,sp,32
    80000082:	8082                	ret

0000000080000084 <r_sie>:
#define SIE_SEIE (1L << 9) // external
#define SIE_STIE (1L << 5) // timer
#define SIE_SSIE (1L << 1) // software
static inline uint64
r_sie()
{
    80000084:	1101                	addi	sp,sp,-32
    80000086:	ec22                	sd	s0,24(sp)
    80000088:	1000                	addi	s0,sp,32
  uint64 x;
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000008a:	104027f3          	csrr	a5,sie
    8000008e:	fef43423          	sd	a5,-24(s0)
  return x;
    80000092:	fe843783          	ld	a5,-24(s0)
}
    80000096:	853e                	mv	a0,a5
    80000098:	6462                	ld	s0,24(sp)
    8000009a:	6105                	addi	sp,sp,32
    8000009c:	8082                	ret

000000008000009e <w_sie>:

static inline void 
w_sie(uint64 x)
{
    8000009e:	1101                	addi	sp,sp,-32
    800000a0:	ec22                	sd	s0,24(sp)
    800000a2:	1000                	addi	s0,sp,32
    800000a4:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw sie, %0" : : "r" (x));
    800000a8:	fe843783          	ld	a5,-24(s0)
    800000ac:	10479073          	csrw	sie,a5
}
    800000b0:	0001                	nop
    800000b2:	6462                	ld	s0,24(sp)
    800000b4:	6105                	addi	sp,sp,32
    800000b6:	8082                	ret

00000000800000b8 <r_mie>:
#define MIE_MEIE (1L << 11) // external
#define MIE_MTIE (1L << 7)  // timer
#define MIE_MSIE (1L << 3)  // software
static inline uint64
r_mie()
{
    800000b8:	1101                	addi	sp,sp,-32
    800000ba:	ec22                	sd	s0,24(sp)
    800000bc:	1000                	addi	s0,sp,32
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    800000be:	304027f3          	csrr	a5,mie
    800000c2:	fef43423          	sd	a5,-24(s0)
  return x;
    800000c6:	fe843783          	ld	a5,-24(s0)
}
    800000ca:	853e                	mv	a0,a5
    800000cc:	6462                	ld	s0,24(sp)
    800000ce:	6105                	addi	sp,sp,32
    800000d0:	8082                	ret

00000000800000d2 <w_mie>:

static inline void 
w_mie(uint64 x)
{
    800000d2:	1101                	addi	sp,sp,-32
    800000d4:	ec22                	sd	s0,24(sp)
    800000d6:	1000                	addi	s0,sp,32
    800000d8:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw mie, %0" : : "r" (x));
    800000dc:	fe843783          	ld	a5,-24(s0)
    800000e0:	30479073          	csrw	mie,a5
}
    800000e4:	0001                	nop
    800000e6:	6462                	ld	s0,24(sp)
    800000e8:	6105                	addi	sp,sp,32
    800000ea:	8082                	ret

00000000800000ec <w_medeleg>:
  return x;
}

static inline void 
w_medeleg(uint64 x)
{
    800000ec:	1101                	addi	sp,sp,-32
    800000ee:	ec22                	sd	s0,24(sp)
    800000f0:	1000                	addi	s0,sp,32
    800000f2:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000f6:	fe843783          	ld	a5,-24(s0)
    800000fa:	30279073          	csrw	medeleg,a5
}
    800000fe:	0001                	nop
    80000100:	6462                	ld	s0,24(sp)
    80000102:	6105                	addi	sp,sp,32
    80000104:	8082                	ret

0000000080000106 <w_mideleg>:
  return x;
}

static inline void 
w_mideleg(uint64 x)
{
    80000106:	1101                	addi	sp,sp,-32
    80000108:	ec22                	sd	s0,24(sp)
    8000010a:	1000                	addi	s0,sp,32
    8000010c:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80000110:	fe843783          	ld	a5,-24(s0)
    80000114:	30379073          	csrw	mideleg,a5
}
    80000118:	0001                	nop
    8000011a:	6462                	ld	s0,24(sp)
    8000011c:	6105                	addi	sp,sp,32
    8000011e:	8082                	ret

0000000080000120 <w_mtvec>:
}

// Machine-mode interrupt vector
static inline void 
w_mtvec(uint64 x)
{
    80000120:	1101                	addi	sp,sp,-32
    80000122:	ec22                	sd	s0,24(sp)
    80000124:	1000                	addi	s0,sp,32
    80000126:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000012a:	fe843783          	ld	a5,-24(s0)
    8000012e:	30579073          	csrw	mtvec,a5
}
    80000132:	0001                	nop
    80000134:	6462                	ld	s0,24(sp)
    80000136:	6105                	addi	sp,sp,32
    80000138:	8082                	ret

000000008000013a <w_pmpcfg0>:

// Physical Memory Protection
static inline void
w_pmpcfg0(uint64 x)
{
    8000013a:	1101                	addi	sp,sp,-32
    8000013c:	ec22                	sd	s0,24(sp)
    8000013e:	1000                	addi	s0,sp,32
    80000140:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80000144:	fe843783          	ld	a5,-24(s0)
    80000148:	3a079073          	csrw	pmpcfg0,a5
}
    8000014c:	0001                	nop
    8000014e:	6462                	ld	s0,24(sp)
    80000150:	6105                	addi	sp,sp,32
    80000152:	8082                	ret

0000000080000154 <w_pmpaddr0>:

static inline void
w_pmpaddr0(uint64 x)
{
    80000154:	1101                	addi	sp,sp,-32
    80000156:	ec22                	sd	s0,24(sp)
    80000158:	1000                	addi	s0,sp,32
    8000015a:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    8000015e:	fe843783          	ld	a5,-24(s0)
    80000162:	3b079073          	csrw	pmpaddr0,a5
}
    80000166:	0001                	nop
    80000168:	6462                	ld	s0,24(sp)
    8000016a:	6105                	addi	sp,sp,32
    8000016c:	8082                	ret

000000008000016e <w_satp>:

// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
    8000016e:	1101                	addi	sp,sp,-32
    80000170:	ec22                	sd	s0,24(sp)
    80000172:	1000                	addi	s0,sp,32
    80000174:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw satp, %0" : : "r" (x));
    80000178:	fe843783          	ld	a5,-24(s0)
    8000017c:	18079073          	csrw	satp,a5
}
    80000180:	0001                	nop
    80000182:	6462                	ld	s0,24(sp)
    80000184:	6105                	addi	sp,sp,32
    80000186:	8082                	ret

0000000080000188 <w_mscratch>:
  return x;
}

static inline void 
w_mscratch(uint64 x)
{
    80000188:	1101                	addi	sp,sp,-32
    8000018a:	ec22                	sd	s0,24(sp)
    8000018c:	1000                	addi	s0,sp,32
    8000018e:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000192:	fe843783          	ld	a5,-24(s0)
    80000196:	34079073          	csrw	mscratch,a5
}
    8000019a:	0001                	nop
    8000019c:	6462                	ld	s0,24(sp)
    8000019e:	6105                	addi	sp,sp,32
    800001a0:	8082                	ret

00000000800001a2 <w_tp>:
  return x;
}

static inline void 
w_tp(uint64 x)
{
    800001a2:	1101                	addi	sp,sp,-32
    800001a4:	ec22                	sd	s0,24(sp)
    800001a6:	1000                	addi	s0,sp,32
    800001a8:	fea43423          	sd	a0,-24(s0)
  asm volatile("mv tp, %0" : : "r" (x));
    800001ac:	fe843783          	ld	a5,-24(s0)
    800001b0:	823e                	mv	tp,a5
}
    800001b2:	0001                	nop
    800001b4:	6462                	ld	s0,24(sp)
    800001b6:	6105                	addi	sp,sp,32
    800001b8:	8082                	ret

00000000800001ba <start>:
extern void timervec();

// entry.S jumps here in machine mode on stack0.
void
start()
{
    800001ba:	1101                	addi	sp,sp,-32
    800001bc:	ec06                	sd	ra,24(sp)
    800001be:	e822                	sd	s0,16(sp)
    800001c0:	1000                	addi	s0,sp,32
  // set M Previous Privilege mode to Supervisor, for mret.
  unsigned long x = r_mstatus();
    800001c2:	00000097          	auipc	ra,0x0
    800001c6:	e74080e7          	jalr	-396(ra) # 80000036 <r_mstatus>
    800001ca:	fea43423          	sd	a0,-24(s0)
  x &= ~MSTATUS_MPP_MASK;
    800001ce:	fe843703          	ld	a4,-24(s0)
    800001d2:	77f9                	lui	a5,0xffffe
    800001d4:	7ff78793          	addi	a5,a5,2047 # ffffffffffffe7ff <end+0xffffffff7ffd74e7>
    800001d8:	8ff9                	and	a5,a5,a4
    800001da:	fef43423          	sd	a5,-24(s0)
  x |= MSTATUS_MPP_S;
    800001de:	fe843703          	ld	a4,-24(s0)
    800001e2:	6785                	lui	a5,0x1
    800001e4:	80078793          	addi	a5,a5,-2048 # 800 <_entry-0x7ffff800>
    800001e8:	8fd9                	or	a5,a5,a4
    800001ea:	fef43423          	sd	a5,-24(s0)
  w_mstatus(x);
    800001ee:	fe843503          	ld	a0,-24(s0)
    800001f2:	00000097          	auipc	ra,0x0
    800001f6:	e5e080e7          	jalr	-418(ra) # 80000050 <w_mstatus>

  // set M Exception Program Counter to main, for mret.
  // requires gcc -mcmodel=medany
  w_mepc((uint64)main);
    800001fa:	00001797          	auipc	a5,0x1
    800001fe:	60e78793          	addi	a5,a5,1550 # 80001808 <main>
    80000202:	853e                	mv	a0,a5
    80000204:	00000097          	auipc	ra,0x0
    80000208:	e66080e7          	jalr	-410(ra) # 8000006a <w_mepc>

  // disable paging for now.
  w_satp(0);
    8000020c:	4501                	li	a0,0
    8000020e:	00000097          	auipc	ra,0x0
    80000212:	f60080e7          	jalr	-160(ra) # 8000016e <w_satp>

  // delegate all interrupts and exceptions to supervisor mode.
  w_medeleg(0xffff);
    80000216:	67c1                	lui	a5,0x10
    80000218:	fff78513          	addi	a0,a5,-1 # ffff <_entry-0x7fff0001>
    8000021c:	00000097          	auipc	ra,0x0
    80000220:	ed0080e7          	jalr	-304(ra) # 800000ec <w_medeleg>
  w_mideleg(0xffff);
    80000224:	67c1                	lui	a5,0x10
    80000226:	fff78513          	addi	a0,a5,-1 # ffff <_entry-0x7fff0001>
    8000022a:	00000097          	auipc	ra,0x0
    8000022e:	edc080e7          	jalr	-292(ra) # 80000106 <w_mideleg>
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80000232:	00000097          	auipc	ra,0x0
    80000236:	e52080e7          	jalr	-430(ra) # 80000084 <r_sie>
    8000023a:	87aa                	mv	a5,a0
    8000023c:	2227e793          	ori	a5,a5,546
    80000240:	853e                	mv	a0,a5
    80000242:	00000097          	auipc	ra,0x0
    80000246:	e5c080e7          	jalr	-420(ra) # 8000009e <w_sie>

  // configure Physical Memory Protection to give supervisor mode
  // access to all of physical memory.
  w_pmpaddr0(0x3fffffffffffffull);
    8000024a:	57fd                	li	a5,-1
    8000024c:	00a7d513          	srli	a0,a5,0xa
    80000250:	00000097          	auipc	ra,0x0
    80000254:	f04080e7          	jalr	-252(ra) # 80000154 <w_pmpaddr0>
  w_pmpcfg0(0xf);
    80000258:	453d                	li	a0,15
    8000025a:	00000097          	auipc	ra,0x0
    8000025e:	ee0080e7          	jalr	-288(ra) # 8000013a <w_pmpcfg0>

  // ask for clock interrupts.
  timerinit();
    80000262:	00000097          	auipc	ra,0x0
    80000266:	032080e7          	jalr	50(ra) # 80000294 <timerinit>

  // keep each CPU's hartid in its tp register, for cpuid().
  int id = r_mhartid();
    8000026a:	00000097          	auipc	ra,0x0
    8000026e:	db2080e7          	jalr	-590(ra) # 8000001c <r_mhartid>
    80000272:	87aa                	mv	a5,a0
    80000274:	fef42223          	sw	a5,-28(s0)
  w_tp(id);
    80000278:	fe442783          	lw	a5,-28(s0)
    8000027c:	853e                	mv	a0,a5
    8000027e:	00000097          	auipc	ra,0x0
    80000282:	f24080e7          	jalr	-220(ra) # 800001a2 <w_tp>

  // switch to supervisor mode and jump to main().
  asm volatile("mret");
    80000286:	30200073          	mret
}
    8000028a:	0001                	nop
    8000028c:	60e2                	ld	ra,24(sp)
    8000028e:	6442                	ld	s0,16(sp)
    80000290:	6105                	addi	sp,sp,32
    80000292:	8082                	ret

0000000080000294 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80000294:	1101                	addi	sp,sp,-32
    80000296:	ec06                	sd	ra,24(sp)
    80000298:	e822                	sd	s0,16(sp)
    8000029a:	1000                	addi	s0,sp,32
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    8000029c:	00000097          	auipc	ra,0x0
    800002a0:	d80080e7          	jalr	-640(ra) # 8000001c <r_mhartid>
    800002a4:	87aa                	mv	a5,a0
    800002a6:	fef42623          	sw	a5,-20(s0)

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
    800002aa:	000f47b7          	lui	a5,0xf4
    800002ae:	24078793          	addi	a5,a5,576 # f4240 <_entry-0x7ff0bdc0>
    800002b2:	fef42423          	sw	a5,-24(s0)
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800002b6:	0200c7b7          	lui	a5,0x200c
    800002ba:	17e1                	addi	a5,a5,-8 # 200bff8 <_entry-0x7dff4008>
    800002bc:	6398                	ld	a4,0(a5)
    800002be:	fe842783          	lw	a5,-24(s0)
    800002c2:	fec42683          	lw	a3,-20(s0)
    800002c6:	0036969b          	slliw	a3,a3,0x3
    800002ca:	2681                	sext.w	a3,a3
    800002cc:	8636                	mv	a2,a3
    800002ce:	020046b7          	lui	a3,0x2004
    800002d2:	96b2                	add	a3,a3,a2
    800002d4:	97ba                	add	a5,a5,a4
    800002d6:	e29c                	sd	a5,0(a3)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800002d8:	fec42703          	lw	a4,-20(s0)
    800002dc:	87ba                	mv	a5,a4
    800002de:	078a                	slli	a5,a5,0x2
    800002e0:	97ba                	add	a5,a5,a4
    800002e2:	078e                	slli	a5,a5,0x3
    800002e4:	00016717          	auipc	a4,0x16
    800002e8:	bbc70713          	addi	a4,a4,-1092 # 80015ea0 <timer_scratch>
    800002ec:	97ba                	add	a5,a5,a4
    800002ee:	fef43023          	sd	a5,-32(s0)
  scratch[3] = CLINT_MTIMECMP(id);
    800002f2:	fec42783          	lw	a5,-20(s0)
    800002f6:	0037979b          	slliw	a5,a5,0x3
    800002fa:	2781                	sext.w	a5,a5
    800002fc:	873e                	mv	a4,a5
    800002fe:	020047b7          	lui	a5,0x2004
    80000302:	973e                	add	a4,a4,a5
    80000304:	fe043783          	ld	a5,-32(s0)
    80000308:	07e1                	addi	a5,a5,24 # 2004018 <_entry-0x7dffbfe8>
    8000030a:	e398                	sd	a4,0(a5)
  scratch[4] = interval;
    8000030c:	fe043783          	ld	a5,-32(s0)
    80000310:	02078793          	addi	a5,a5,32
    80000314:	fe842703          	lw	a4,-24(s0)
    80000318:	e398                	sd	a4,0(a5)
  w_mscratch((uint64)scratch);
    8000031a:	fe043783          	ld	a5,-32(s0)
    8000031e:	853e                	mv	a0,a5
    80000320:	00000097          	auipc	ra,0x0
    80000324:	e68080e7          	jalr	-408(ra) # 80000188 <w_mscratch>

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);
    80000328:	00008797          	auipc	a5,0x8
    8000032c:	57878793          	addi	a5,a5,1400 # 800088a0 <timervec>
    80000330:	853e                	mv	a0,a5
    80000332:	00000097          	auipc	ra,0x0
    80000336:	dee080e7          	jalr	-530(ra) # 80000120 <w_mtvec>

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000033a:	00000097          	auipc	ra,0x0
    8000033e:	cfc080e7          	jalr	-772(ra) # 80000036 <r_mstatus>
    80000342:	87aa                	mv	a5,a0
    80000344:	0087e793          	ori	a5,a5,8
    80000348:	853e                	mv	a0,a5
    8000034a:	00000097          	auipc	ra,0x0
    8000034e:	d06080e7          	jalr	-762(ra) # 80000050 <w_mstatus>

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000352:	00000097          	auipc	ra,0x0
    80000356:	d66080e7          	jalr	-666(ra) # 800000b8 <r_mie>
    8000035a:	87aa                	mv	a5,a0
    8000035c:	0807e793          	ori	a5,a5,128
    80000360:	853e                	mv	a0,a5
    80000362:	00000097          	auipc	ra,0x0
    80000366:	d70080e7          	jalr	-656(ra) # 800000d2 <w_mie>
}
    8000036a:	0001                	nop
    8000036c:	60e2                	ld	ra,24(sp)
    8000036e:	6442                	ld	s0,16(sp)
    80000370:	6105                	addi	sp,sp,32
    80000372:	8082                	ret

0000000080000374 <consputc>:
// called by printf(), and to echo input characters,
// but not from write().
//
void
consputc(int c)
{
    80000374:	1101                	addi	sp,sp,-32
    80000376:	ec06                	sd	ra,24(sp)
    80000378:	e822                	sd	s0,16(sp)
    8000037a:	1000                	addi	s0,sp,32
    8000037c:	87aa                	mv	a5,a0
    8000037e:	fef42623          	sw	a5,-20(s0)
  if(c == BACKSPACE){
    80000382:	fec42783          	lw	a5,-20(s0)
    80000386:	0007871b          	sext.w	a4,a5
    8000038a:	10000793          	li	a5,256
    8000038e:	02f71363          	bne	a4,a5,800003b4 <consputc+0x40>
    // if the user typed backspace, overwrite with a space.
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000392:	4521                	li	a0,8
    80000394:	00001097          	auipc	ra,0x1
    80000398:	aba080e7          	jalr	-1350(ra) # 80000e4e <uartputc_sync>
    8000039c:	02000513          	li	a0,32
    800003a0:	00001097          	auipc	ra,0x1
    800003a4:	aae080e7          	jalr	-1362(ra) # 80000e4e <uartputc_sync>
    800003a8:	4521                	li	a0,8
    800003aa:	00001097          	auipc	ra,0x1
    800003ae:	aa4080e7          	jalr	-1372(ra) # 80000e4e <uartputc_sync>
  } else {
    uartputc_sync(c);
  }
}
    800003b2:	a801                	j	800003c2 <consputc+0x4e>
    uartputc_sync(c);
    800003b4:	fec42783          	lw	a5,-20(s0)
    800003b8:	853e                	mv	a0,a5
    800003ba:	00001097          	auipc	ra,0x1
    800003be:	a94080e7          	jalr	-1388(ra) # 80000e4e <uartputc_sync>
}
    800003c2:	0001                	nop
    800003c4:	60e2                	ld	ra,24(sp)
    800003c6:	6442                	ld	s0,16(sp)
    800003c8:	6105                	addi	sp,sp,32
    800003ca:	8082                	ret

00000000800003cc <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800003cc:	7179                	addi	sp,sp,-48
    800003ce:	f406                	sd	ra,40(sp)
    800003d0:	f022                	sd	s0,32(sp)
    800003d2:	1800                	addi	s0,sp,48
    800003d4:	87aa                	mv	a5,a0
    800003d6:	fcb43823          	sd	a1,-48(s0)
    800003da:	8732                	mv	a4,a2
    800003dc:	fcf42e23          	sw	a5,-36(s0)
    800003e0:	87ba                	mv	a5,a4
    800003e2:	fcf42c23          	sw	a5,-40(s0)
  int i;

  for(i = 0; i < n; i++){
    800003e6:	fe042623          	sw	zero,-20(s0)
    800003ea:	a0a1                	j	80000432 <consolewrite+0x66>
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800003ec:	fec42703          	lw	a4,-20(s0)
    800003f0:	fd043783          	ld	a5,-48(s0)
    800003f4:	00f70633          	add	a2,a4,a5
    800003f8:	fdc42703          	lw	a4,-36(s0)
    800003fc:	feb40793          	addi	a5,s0,-21
    80000400:	4685                	li	a3,1
    80000402:	85ba                	mv	a1,a4
    80000404:	853e                	mv	a0,a5
    80000406:	00003097          	auipc	ra,0x3
    8000040a:	2a0080e7          	jalr	672(ra) # 800036a6 <either_copyin>
    8000040e:	87aa                	mv	a5,a0
    80000410:	873e                	mv	a4,a5
    80000412:	57fd                	li	a5,-1
    80000414:	02f70963          	beq	a4,a5,80000446 <consolewrite+0x7a>
      break;
    uartputc(c);
    80000418:	feb44783          	lbu	a5,-21(s0)
    8000041c:	2781                	sext.w	a5,a5
    8000041e:	853e                	mv	a0,a5
    80000420:	00001097          	auipc	ra,0x1
    80000424:	96e080e7          	jalr	-1682(ra) # 80000d8e <uartputc>
  for(i = 0; i < n; i++){
    80000428:	fec42783          	lw	a5,-20(s0)
    8000042c:	2785                	addiw	a5,a5,1
    8000042e:	fef42623          	sw	a5,-20(s0)
    80000432:	fec42783          	lw	a5,-20(s0)
    80000436:	873e                	mv	a4,a5
    80000438:	fd842783          	lw	a5,-40(s0)
    8000043c:	2701                	sext.w	a4,a4
    8000043e:	2781                	sext.w	a5,a5
    80000440:	faf746e3          	blt	a4,a5,800003ec <consolewrite+0x20>
    80000444:	a011                	j	80000448 <consolewrite+0x7c>
      break;
    80000446:	0001                	nop
  }

  return i;
    80000448:	fec42783          	lw	a5,-20(s0)
}
    8000044c:	853e                	mv	a0,a5
    8000044e:	70a2                	ld	ra,40(sp)
    80000450:	7402                	ld	s0,32(sp)
    80000452:	6145                	addi	sp,sp,48
    80000454:	8082                	ret

0000000080000456 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000456:	7179                	addi	sp,sp,-48
    80000458:	f406                	sd	ra,40(sp)
    8000045a:	f022                	sd	s0,32(sp)
    8000045c:	1800                	addi	s0,sp,48
    8000045e:	87aa                	mv	a5,a0
    80000460:	fcb43823          	sd	a1,-48(s0)
    80000464:	8732                	mv	a4,a2
    80000466:	fcf42e23          	sw	a5,-36(s0)
    8000046a:	87ba                	mv	a5,a4
    8000046c:	fcf42c23          	sw	a5,-40(s0)
  uint target;
  int c;
  char cbuf;

  target = n;
    80000470:	fd842783          	lw	a5,-40(s0)
    80000474:	fef42623          	sw	a5,-20(s0)
  acquire(&cons.lock);
    80000478:	00016517          	auipc	a0,0x16
    8000047c:	b6850513          	addi	a0,a0,-1176 # 80015fe0 <cons>
    80000480:	00001097          	auipc	ra,0x1
    80000484:	dfe080e7          	jalr	-514(ra) # 8000127e <acquire>
  while(n > 0){
    80000488:	a23d                	j	800005b6 <consoleread+0x160>
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
      if(killed(myproc())){
    8000048a:	00002097          	auipc	ra,0x2
    8000048e:	3bc080e7          	jalr	956(ra) # 80002846 <myproc>
    80000492:	87aa                	mv	a5,a0
    80000494:	853e                	mv	a0,a5
    80000496:	00003097          	auipc	ra,0x3
    8000049a:	15c080e7          	jalr	348(ra) # 800035f2 <killed>
    8000049e:	87aa                	mv	a5,a0
    800004a0:	cb99                	beqz	a5,800004b6 <consoleread+0x60>
        release(&cons.lock);
    800004a2:	00016517          	auipc	a0,0x16
    800004a6:	b3e50513          	addi	a0,a0,-1218 # 80015fe0 <cons>
    800004aa:	00001097          	auipc	ra,0x1
    800004ae:	e38080e7          	jalr	-456(ra) # 800012e2 <release>
        return -1;
    800004b2:	57fd                	li	a5,-1
    800004b4:	aa25                	j	800005ec <consoleread+0x196>
      }
      sleep(&cons.r, &cons.lock);
    800004b6:	00016597          	auipc	a1,0x16
    800004ba:	b2a58593          	addi	a1,a1,-1238 # 80015fe0 <cons>
    800004be:	00016517          	auipc	a0,0x16
    800004c2:	bba50513          	addi	a0,a0,-1094 # 80016078 <cons+0x98>
    800004c6:	00003097          	auipc	ra,0x3
    800004ca:	f42080e7          	jalr	-190(ra) # 80003408 <sleep>
    while(cons.r == cons.w){
    800004ce:	00016797          	auipc	a5,0x16
    800004d2:	b1278793          	addi	a5,a5,-1262 # 80015fe0 <cons>
    800004d6:	0987a703          	lw	a4,152(a5)
    800004da:	00016797          	auipc	a5,0x16
    800004de:	b0678793          	addi	a5,a5,-1274 # 80015fe0 <cons>
    800004e2:	09c7a783          	lw	a5,156(a5)
    800004e6:	faf702e3          	beq	a4,a5,8000048a <consoleread+0x34>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800004ea:	00016797          	auipc	a5,0x16
    800004ee:	af678793          	addi	a5,a5,-1290 # 80015fe0 <cons>
    800004f2:	0987a783          	lw	a5,152(a5)
    800004f6:	2781                	sext.w	a5,a5
    800004f8:	0017871b          	addiw	a4,a5,1
    800004fc:	0007069b          	sext.w	a3,a4
    80000500:	00016717          	auipc	a4,0x16
    80000504:	ae070713          	addi	a4,a4,-1312 # 80015fe0 <cons>
    80000508:	08d72c23          	sw	a3,152(a4)
    8000050c:	07f7f793          	andi	a5,a5,127
    80000510:	2781                	sext.w	a5,a5
    80000512:	00016717          	auipc	a4,0x16
    80000516:	ace70713          	addi	a4,a4,-1330 # 80015fe0 <cons>
    8000051a:	1782                	slli	a5,a5,0x20
    8000051c:	9381                	srli	a5,a5,0x20
    8000051e:	97ba                	add	a5,a5,a4
    80000520:	0187c783          	lbu	a5,24(a5)
    80000524:	fef42423          	sw	a5,-24(s0)

    if(c == C('D')){  // end-of-file
    80000528:	fe842783          	lw	a5,-24(s0)
    8000052c:	0007871b          	sext.w	a4,a5
    80000530:	4791                	li	a5,4
    80000532:	02f71963          	bne	a4,a5,80000564 <consoleread+0x10e>
      if(n < target){
    80000536:	fd842703          	lw	a4,-40(s0)
    8000053a:	fec42783          	lw	a5,-20(s0)
    8000053e:	2781                	sext.w	a5,a5
    80000540:	08f77163          	bgeu	a4,a5,800005c2 <consoleread+0x16c>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        cons.r--;
    80000544:	00016797          	auipc	a5,0x16
    80000548:	a9c78793          	addi	a5,a5,-1380 # 80015fe0 <cons>
    8000054c:	0987a783          	lw	a5,152(a5)
    80000550:	37fd                	addiw	a5,a5,-1
    80000552:	0007871b          	sext.w	a4,a5
    80000556:	00016797          	auipc	a5,0x16
    8000055a:	a8a78793          	addi	a5,a5,-1398 # 80015fe0 <cons>
    8000055e:	08e7ac23          	sw	a4,152(a5)
      }
      break;
    80000562:	a085                	j	800005c2 <consoleread+0x16c>
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80000564:	fe842783          	lw	a5,-24(s0)
    80000568:	0ff7f793          	zext.b	a5,a5
    8000056c:	fef403a3          	sb	a5,-25(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000570:	fe740713          	addi	a4,s0,-25
    80000574:	fdc42783          	lw	a5,-36(s0)
    80000578:	4685                	li	a3,1
    8000057a:	863a                	mv	a2,a4
    8000057c:	fd043583          	ld	a1,-48(s0)
    80000580:	853e                	mv	a0,a5
    80000582:	00003097          	auipc	ra,0x3
    80000586:	0b0080e7          	jalr	176(ra) # 80003632 <either_copyout>
    8000058a:	87aa                	mv	a5,a0
    8000058c:	873e                	mv	a4,a5
    8000058e:	57fd                	li	a5,-1
    80000590:	02f70b63          	beq	a4,a5,800005c6 <consoleread+0x170>
      break;

    dst++;
    80000594:	fd043783          	ld	a5,-48(s0)
    80000598:	0785                	addi	a5,a5,1
    8000059a:	fcf43823          	sd	a5,-48(s0)
    --n;
    8000059e:	fd842783          	lw	a5,-40(s0)
    800005a2:	37fd                	addiw	a5,a5,-1
    800005a4:	fcf42c23          	sw	a5,-40(s0)

    if(c == '\n'){
    800005a8:	fe842783          	lw	a5,-24(s0)
    800005ac:	0007871b          	sext.w	a4,a5
    800005b0:	47a9                	li	a5,10
    800005b2:	00f70c63          	beq	a4,a5,800005ca <consoleread+0x174>
  while(n > 0){
    800005b6:	fd842783          	lw	a5,-40(s0)
    800005ba:	2781                	sext.w	a5,a5
    800005bc:	f0f049e3          	bgtz	a5,800004ce <consoleread+0x78>
    800005c0:	a031                	j	800005cc <consoleread+0x176>
      break;
    800005c2:	0001                	nop
    800005c4:	a021                	j	800005cc <consoleread+0x176>
      break;
    800005c6:	0001                	nop
    800005c8:	a011                	j	800005cc <consoleread+0x176>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    800005ca:	0001                	nop
    }
  }
  release(&cons.lock);
    800005cc:	00016517          	auipc	a0,0x16
    800005d0:	a1450513          	addi	a0,a0,-1516 # 80015fe0 <cons>
    800005d4:	00001097          	auipc	ra,0x1
    800005d8:	d0e080e7          	jalr	-754(ra) # 800012e2 <release>

  return target - n;
    800005dc:	fd842783          	lw	a5,-40(s0)
    800005e0:	fec42703          	lw	a4,-20(s0)
    800005e4:	40f707bb          	subw	a5,a4,a5
    800005e8:	2781                	sext.w	a5,a5
    800005ea:	2781                	sext.w	a5,a5
}
    800005ec:	853e                	mv	a0,a5
    800005ee:	70a2                	ld	ra,40(sp)
    800005f0:	7402                	ld	s0,32(sp)
    800005f2:	6145                	addi	sp,sp,48
    800005f4:	8082                	ret

00000000800005f6 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800005f6:	1101                	addi	sp,sp,-32
    800005f8:	ec06                	sd	ra,24(sp)
    800005fa:	e822                	sd	s0,16(sp)
    800005fc:	1000                	addi	s0,sp,32
    800005fe:	87aa                	mv	a5,a0
    80000600:	fef42623          	sw	a5,-20(s0)
  acquire(&cons.lock);
    80000604:	00016517          	auipc	a0,0x16
    80000608:	9dc50513          	addi	a0,a0,-1572 # 80015fe0 <cons>
    8000060c:	00001097          	auipc	ra,0x1
    80000610:	c72080e7          	jalr	-910(ra) # 8000127e <acquire>

  switch(c){
    80000614:	fec42783          	lw	a5,-20(s0)
    80000618:	0007871b          	sext.w	a4,a5
    8000061c:	07f00793          	li	a5,127
    80000620:	0cf70763          	beq	a4,a5,800006ee <consoleintr+0xf8>
    80000624:	fec42783          	lw	a5,-20(s0)
    80000628:	0007871b          	sext.w	a4,a5
    8000062c:	07f00793          	li	a5,127
    80000630:	10e7c363          	blt	a5,a4,80000736 <consoleintr+0x140>
    80000634:	fec42783          	lw	a5,-20(s0)
    80000638:	0007871b          	sext.w	a4,a5
    8000063c:	47d5                	li	a5,21
    8000063e:	06f70163          	beq	a4,a5,800006a0 <consoleintr+0xaa>
    80000642:	fec42783          	lw	a5,-20(s0)
    80000646:	0007871b          	sext.w	a4,a5
    8000064a:	47d5                	li	a5,21
    8000064c:	0ee7c563          	blt	a5,a4,80000736 <consoleintr+0x140>
    80000650:	fec42783          	lw	a5,-20(s0)
    80000654:	0007871b          	sext.w	a4,a5
    80000658:	47a1                	li	a5,8
    8000065a:	08f70a63          	beq	a4,a5,800006ee <consoleintr+0xf8>
    8000065e:	fec42783          	lw	a5,-20(s0)
    80000662:	0007871b          	sext.w	a4,a5
    80000666:	47c1                	li	a5,16
    80000668:	0cf71763          	bne	a4,a5,80000736 <consoleintr+0x140>
  case C('P'):  // Print process list.
    procdump();
    8000066c:	00003097          	auipc	ra,0x3
    80000670:	0ae080e7          	jalr	174(ra) # 8000371a <procdump>
    break;
    80000674:	aad9                	j	8000084a <consoleintr+0x254>
  case C('U'):  // Kill line.
    while(cons.e != cons.w &&
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
      cons.e--;
    80000676:	00016797          	auipc	a5,0x16
    8000067a:	96a78793          	addi	a5,a5,-1686 # 80015fe0 <cons>
    8000067e:	0a07a783          	lw	a5,160(a5)
    80000682:	37fd                	addiw	a5,a5,-1
    80000684:	0007871b          	sext.w	a4,a5
    80000688:	00016797          	auipc	a5,0x16
    8000068c:	95878793          	addi	a5,a5,-1704 # 80015fe0 <cons>
    80000690:	0ae7a023          	sw	a4,160(a5)
      consputc(BACKSPACE);
    80000694:	10000513          	li	a0,256
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	cdc080e7          	jalr	-804(ra) # 80000374 <consputc>
    while(cons.e != cons.w &&
    800006a0:	00016797          	auipc	a5,0x16
    800006a4:	94078793          	addi	a5,a5,-1728 # 80015fe0 <cons>
    800006a8:	0a07a703          	lw	a4,160(a5)
    800006ac:	00016797          	auipc	a5,0x16
    800006b0:	93478793          	addi	a5,a5,-1740 # 80015fe0 <cons>
    800006b4:	09c7a783          	lw	a5,156(a5)
    800006b8:	18f70463          	beq	a4,a5,80000840 <consoleintr+0x24a>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800006bc:	00016797          	auipc	a5,0x16
    800006c0:	92478793          	addi	a5,a5,-1756 # 80015fe0 <cons>
    800006c4:	0a07a783          	lw	a5,160(a5)
    800006c8:	37fd                	addiw	a5,a5,-1
    800006ca:	2781                	sext.w	a5,a5
    800006cc:	07f7f793          	andi	a5,a5,127
    800006d0:	2781                	sext.w	a5,a5
    800006d2:	00016717          	auipc	a4,0x16
    800006d6:	90e70713          	addi	a4,a4,-1778 # 80015fe0 <cons>
    800006da:	1782                	slli	a5,a5,0x20
    800006dc:	9381                	srli	a5,a5,0x20
    800006de:	97ba                	add	a5,a5,a4
    800006e0:	0187c783          	lbu	a5,24(a5)
    while(cons.e != cons.w &&
    800006e4:	873e                	mv	a4,a5
    800006e6:	47a9                	li	a5,10
    800006e8:	f8f717e3          	bne	a4,a5,80000676 <consoleintr+0x80>
    }
    break;
    800006ec:	aa91                	j	80000840 <consoleintr+0x24a>
  case C('H'): // Backspace
  case '\x7f': // Delete key
    if(cons.e != cons.w){
    800006ee:	00016797          	auipc	a5,0x16
    800006f2:	8f278793          	addi	a5,a5,-1806 # 80015fe0 <cons>
    800006f6:	0a07a703          	lw	a4,160(a5)
    800006fa:	00016797          	auipc	a5,0x16
    800006fe:	8e678793          	addi	a5,a5,-1818 # 80015fe0 <cons>
    80000702:	09c7a783          	lw	a5,156(a5)
    80000706:	12f70f63          	beq	a4,a5,80000844 <consoleintr+0x24e>
      cons.e--;
    8000070a:	00016797          	auipc	a5,0x16
    8000070e:	8d678793          	addi	a5,a5,-1834 # 80015fe0 <cons>
    80000712:	0a07a783          	lw	a5,160(a5)
    80000716:	37fd                	addiw	a5,a5,-1
    80000718:	0007871b          	sext.w	a4,a5
    8000071c:	00016797          	auipc	a5,0x16
    80000720:	8c478793          	addi	a5,a5,-1852 # 80015fe0 <cons>
    80000724:	0ae7a023          	sw	a4,160(a5)
      consputc(BACKSPACE);
    80000728:	10000513          	li	a0,256
    8000072c:	00000097          	auipc	ra,0x0
    80000730:	c48080e7          	jalr	-952(ra) # 80000374 <consputc>
    }
    break;
    80000734:	aa01                	j	80000844 <consoleintr+0x24e>
  default:
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000736:	fec42783          	lw	a5,-20(s0)
    8000073a:	2781                	sext.w	a5,a5
    8000073c:	10078663          	beqz	a5,80000848 <consoleintr+0x252>
    80000740:	00016797          	auipc	a5,0x16
    80000744:	8a078793          	addi	a5,a5,-1888 # 80015fe0 <cons>
    80000748:	0a07a703          	lw	a4,160(a5)
    8000074c:	00016797          	auipc	a5,0x16
    80000750:	89478793          	addi	a5,a5,-1900 # 80015fe0 <cons>
    80000754:	0987a783          	lw	a5,152(a5)
    80000758:	40f707bb          	subw	a5,a4,a5
    8000075c:	2781                	sext.w	a5,a5
    8000075e:	873e                	mv	a4,a5
    80000760:	07f00793          	li	a5,127
    80000764:	0ee7e263          	bltu	a5,a4,80000848 <consoleintr+0x252>
      c = (c == '\r') ? '\n' : c;
    80000768:	fec42783          	lw	a5,-20(s0)
    8000076c:	0007871b          	sext.w	a4,a5
    80000770:	47b5                	li	a5,13
    80000772:	00f70563          	beq	a4,a5,8000077c <consoleintr+0x186>
    80000776:	fec42783          	lw	a5,-20(s0)
    8000077a:	a011                	j	8000077e <consoleintr+0x188>
    8000077c:	47a9                	li	a5,10
    8000077e:	fef42623          	sw	a5,-20(s0)

      // echo back to the user.
      consputc(c);
    80000782:	fec42783          	lw	a5,-20(s0)
    80000786:	853e                	mv	a0,a5
    80000788:	00000097          	auipc	ra,0x0
    8000078c:	bec080e7          	jalr	-1044(ra) # 80000374 <consputc>

      // store for consumption by consoleread().
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000790:	00016797          	auipc	a5,0x16
    80000794:	85078793          	addi	a5,a5,-1968 # 80015fe0 <cons>
    80000798:	0a07a783          	lw	a5,160(a5)
    8000079c:	2781                	sext.w	a5,a5
    8000079e:	0017871b          	addiw	a4,a5,1
    800007a2:	0007069b          	sext.w	a3,a4
    800007a6:	00016717          	auipc	a4,0x16
    800007aa:	83a70713          	addi	a4,a4,-1990 # 80015fe0 <cons>
    800007ae:	0ad72023          	sw	a3,160(a4)
    800007b2:	07f7f793          	andi	a5,a5,127
    800007b6:	2781                	sext.w	a5,a5
    800007b8:	fec42703          	lw	a4,-20(s0)
    800007bc:	0ff77713          	zext.b	a4,a4
    800007c0:	00016697          	auipc	a3,0x16
    800007c4:	82068693          	addi	a3,a3,-2016 # 80015fe0 <cons>
    800007c8:	1782                	slli	a5,a5,0x20
    800007ca:	9381                	srli	a5,a5,0x20
    800007cc:	97b6                	add	a5,a5,a3
    800007ce:	00e78c23          	sb	a4,24(a5)

      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    800007d2:	fec42783          	lw	a5,-20(s0)
    800007d6:	0007871b          	sext.w	a4,a5
    800007da:	47a9                	li	a5,10
    800007dc:	02f70d63          	beq	a4,a5,80000816 <consoleintr+0x220>
    800007e0:	fec42783          	lw	a5,-20(s0)
    800007e4:	0007871b          	sext.w	a4,a5
    800007e8:	4791                	li	a5,4
    800007ea:	02f70663          	beq	a4,a5,80000816 <consoleintr+0x220>
    800007ee:	00015797          	auipc	a5,0x15
    800007f2:	7f278793          	addi	a5,a5,2034 # 80015fe0 <cons>
    800007f6:	0a07a703          	lw	a4,160(a5)
    800007fa:	00015797          	auipc	a5,0x15
    800007fe:	7e678793          	addi	a5,a5,2022 # 80015fe0 <cons>
    80000802:	0987a783          	lw	a5,152(a5)
    80000806:	40f707bb          	subw	a5,a4,a5
    8000080a:	2781                	sext.w	a5,a5
    8000080c:	873e                	mv	a4,a5
    8000080e:	08000793          	li	a5,128
    80000812:	02f71b63          	bne	a4,a5,80000848 <consoleintr+0x252>
        // wake up consoleread() if a whole line (or end-of-file)
        // has arrived.
        cons.w = cons.e;
    80000816:	00015797          	auipc	a5,0x15
    8000081a:	7ca78793          	addi	a5,a5,1994 # 80015fe0 <cons>
    8000081e:	0a07a703          	lw	a4,160(a5)
    80000822:	00015797          	auipc	a5,0x15
    80000826:	7be78793          	addi	a5,a5,1982 # 80015fe0 <cons>
    8000082a:	08e7ae23          	sw	a4,156(a5)
        wakeup(&cons.r);
    8000082e:	00016517          	auipc	a0,0x16
    80000832:	84a50513          	addi	a0,a0,-1974 # 80016078 <cons+0x98>
    80000836:	00003097          	auipc	ra,0x3
    8000083a:	c4e080e7          	jalr	-946(ra) # 80003484 <wakeup>
      }
    }
    break;
    8000083e:	a029                	j	80000848 <consoleintr+0x252>
    break;
    80000840:	0001                	nop
    80000842:	a021                	j	8000084a <consoleintr+0x254>
    break;
    80000844:	0001                	nop
    80000846:	a011                	j	8000084a <consoleintr+0x254>
    break;
    80000848:	0001                	nop
  }
  
  release(&cons.lock);
    8000084a:	00015517          	auipc	a0,0x15
    8000084e:	79650513          	addi	a0,a0,1942 # 80015fe0 <cons>
    80000852:	00001097          	auipc	ra,0x1
    80000856:	a90080e7          	jalr	-1392(ra) # 800012e2 <release>
}
    8000085a:	0001                	nop
    8000085c:	60e2                	ld	ra,24(sp)
    8000085e:	6442                	ld	s0,16(sp)
    80000860:	6105                	addi	sp,sp,32
    80000862:	8082                	ret

0000000080000864 <consoleinit>:

void
consoleinit(void)
{
    80000864:	1141                	addi	sp,sp,-16
    80000866:	e406                	sd	ra,8(sp)
    80000868:	e022                	sd	s0,0(sp)
    8000086a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000086c:	0000a597          	auipc	a1,0xa
    80000870:	79458593          	addi	a1,a1,1940 # 8000b000 <etext>
    80000874:	00015517          	auipc	a0,0x15
    80000878:	76c50513          	addi	a0,a0,1900 # 80015fe0 <cons>
    8000087c:	00001097          	auipc	ra,0x1
    80000880:	9d2080e7          	jalr	-1582(ra) # 8000124e <initlock>

  uartinit();
    80000884:	00000097          	auipc	ra,0x0
    80000888:	490080e7          	jalr	1168(ra) # 80000d14 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000088c:	00026797          	auipc	a5,0x26
    80000890:	8f478793          	addi	a5,a5,-1804 # 80026180 <devsw>
    80000894:	00000717          	auipc	a4,0x0
    80000898:	bc270713          	addi	a4,a4,-1086 # 80000456 <consoleread>
    8000089c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000089e:	00026797          	auipc	a5,0x26
    800008a2:	8e278793          	addi	a5,a5,-1822 # 80026180 <devsw>
    800008a6:	00000717          	auipc	a4,0x0
    800008aa:	b2670713          	addi	a4,a4,-1242 # 800003cc <consolewrite>
    800008ae:	ef98                	sd	a4,24(a5)
}
    800008b0:	0001                	nop
    800008b2:	60a2                	ld	ra,8(sp)
    800008b4:	6402                	ld	s0,0(sp)
    800008b6:	0141                	addi	sp,sp,16
    800008b8:	8082                	ret

00000000800008ba <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800008ba:	7139                	addi	sp,sp,-64
    800008bc:	fc06                	sd	ra,56(sp)
    800008be:	f822                	sd	s0,48(sp)
    800008c0:	0080                	addi	s0,sp,64
    800008c2:	87aa                	mv	a5,a0
    800008c4:	86ae                	mv	a3,a1
    800008c6:	8732                	mv	a4,a2
    800008c8:	fcf42623          	sw	a5,-52(s0)
    800008cc:	87b6                	mv	a5,a3
    800008ce:	fcf42423          	sw	a5,-56(s0)
    800008d2:	87ba                	mv	a5,a4
    800008d4:	fcf42223          	sw	a5,-60(s0)
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800008d8:	fc442783          	lw	a5,-60(s0)
    800008dc:	2781                	sext.w	a5,a5
    800008de:	c78d                	beqz	a5,80000908 <printint+0x4e>
    800008e0:	fcc42783          	lw	a5,-52(s0)
    800008e4:	01f7d79b          	srliw	a5,a5,0x1f
    800008e8:	0ff7f793          	zext.b	a5,a5
    800008ec:	fcf42223          	sw	a5,-60(s0)
    800008f0:	fc442783          	lw	a5,-60(s0)
    800008f4:	2781                	sext.w	a5,a5
    800008f6:	cb89                	beqz	a5,80000908 <printint+0x4e>
    x = -xx;
    800008f8:	fcc42783          	lw	a5,-52(s0)
    800008fc:	40f007bb          	negw	a5,a5
    80000900:	2781                	sext.w	a5,a5
    80000902:	fef42423          	sw	a5,-24(s0)
    80000906:	a029                	j	80000910 <printint+0x56>
  else
    x = xx;
    80000908:	fcc42783          	lw	a5,-52(s0)
    8000090c:	fef42423          	sw	a5,-24(s0)

  i = 0;
    80000910:	fe042623          	sw	zero,-20(s0)
  do {
    buf[i++] = digits[x % base];
    80000914:	fc842783          	lw	a5,-56(s0)
    80000918:	fe842703          	lw	a4,-24(s0)
    8000091c:	02f777bb          	remuw	a5,a4,a5
    80000920:	0007861b          	sext.w	a2,a5
    80000924:	fec42783          	lw	a5,-20(s0)
    80000928:	0017871b          	addiw	a4,a5,1
    8000092c:	fee42623          	sw	a4,-20(s0)
    80000930:	0000d697          	auipc	a3,0xd
    80000934:	3e068693          	addi	a3,a3,992 # 8000dd10 <digits>
    80000938:	02061713          	slli	a4,a2,0x20
    8000093c:	9301                	srli	a4,a4,0x20
    8000093e:	9736                	add	a4,a4,a3
    80000940:	00074703          	lbu	a4,0(a4)
    80000944:	17c1                	addi	a5,a5,-16
    80000946:	97a2                	add	a5,a5,s0
    80000948:	fee78423          	sb	a4,-24(a5)
  } while((x /= base) != 0);
    8000094c:	fc842783          	lw	a5,-56(s0)
    80000950:	fe842703          	lw	a4,-24(s0)
    80000954:	02f757bb          	divuw	a5,a4,a5
    80000958:	fef42423          	sw	a5,-24(s0)
    8000095c:	fe842783          	lw	a5,-24(s0)
    80000960:	2781                	sext.w	a5,a5
    80000962:	fbcd                	bnez	a5,80000914 <printint+0x5a>

  if(sign)
    80000964:	fc442783          	lw	a5,-60(s0)
    80000968:	2781                	sext.w	a5,a5
    8000096a:	cb95                	beqz	a5,8000099e <printint+0xe4>
    buf[i++] = '-';
    8000096c:	fec42783          	lw	a5,-20(s0)
    80000970:	0017871b          	addiw	a4,a5,1
    80000974:	fee42623          	sw	a4,-20(s0)
    80000978:	17c1                	addi	a5,a5,-16
    8000097a:	97a2                	add	a5,a5,s0
    8000097c:	02d00713          	li	a4,45
    80000980:	fee78423          	sb	a4,-24(a5)

  while(--i >= 0)
    80000984:	a829                	j	8000099e <printint+0xe4>
    consputc(buf[i]);
    80000986:	fec42783          	lw	a5,-20(s0)
    8000098a:	17c1                	addi	a5,a5,-16
    8000098c:	97a2                	add	a5,a5,s0
    8000098e:	fe87c783          	lbu	a5,-24(a5)
    80000992:	2781                	sext.w	a5,a5
    80000994:	853e                	mv	a0,a5
    80000996:	00000097          	auipc	ra,0x0
    8000099a:	9de080e7          	jalr	-1570(ra) # 80000374 <consputc>
  while(--i >= 0)
    8000099e:	fec42783          	lw	a5,-20(s0)
    800009a2:	37fd                	addiw	a5,a5,-1
    800009a4:	fef42623          	sw	a5,-20(s0)
    800009a8:	fec42783          	lw	a5,-20(s0)
    800009ac:	2781                	sext.w	a5,a5
    800009ae:	fc07dce3          	bgez	a5,80000986 <printint+0xcc>
}
    800009b2:	0001                	nop
    800009b4:	0001                	nop
    800009b6:	70e2                	ld	ra,56(sp)
    800009b8:	7442                	ld	s0,48(sp)
    800009ba:	6121                	addi	sp,sp,64
    800009bc:	8082                	ret

00000000800009be <printptr>:

static void
printptr(uint64 x)
{
    800009be:	7179                	addi	sp,sp,-48
    800009c0:	f406                	sd	ra,40(sp)
    800009c2:	f022                	sd	s0,32(sp)
    800009c4:	1800                	addi	s0,sp,48
    800009c6:	fca43c23          	sd	a0,-40(s0)
  int i;
  consputc('0');
    800009ca:	03000513          	li	a0,48
    800009ce:	00000097          	auipc	ra,0x0
    800009d2:	9a6080e7          	jalr	-1626(ra) # 80000374 <consputc>
  consputc('x');
    800009d6:	07800513          	li	a0,120
    800009da:	00000097          	auipc	ra,0x0
    800009de:	99a080e7          	jalr	-1638(ra) # 80000374 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800009e2:	fe042623          	sw	zero,-20(s0)
    800009e6:	a81d                	j	80000a1c <printptr+0x5e>
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800009e8:	fd843783          	ld	a5,-40(s0)
    800009ec:	93f1                	srli	a5,a5,0x3c
    800009ee:	0000d717          	auipc	a4,0xd
    800009f2:	32270713          	addi	a4,a4,802 # 8000dd10 <digits>
    800009f6:	97ba                	add	a5,a5,a4
    800009f8:	0007c783          	lbu	a5,0(a5)
    800009fc:	2781                	sext.w	a5,a5
    800009fe:	853e                	mv	a0,a5
    80000a00:	00000097          	auipc	ra,0x0
    80000a04:	974080e7          	jalr	-1676(ra) # 80000374 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80000a08:	fec42783          	lw	a5,-20(s0)
    80000a0c:	2785                	addiw	a5,a5,1
    80000a0e:	fef42623          	sw	a5,-20(s0)
    80000a12:	fd843783          	ld	a5,-40(s0)
    80000a16:	0792                	slli	a5,a5,0x4
    80000a18:	fcf43c23          	sd	a5,-40(s0)
    80000a1c:	fec42783          	lw	a5,-20(s0)
    80000a20:	873e                	mv	a4,a5
    80000a22:	47bd                	li	a5,15
    80000a24:	fce7f2e3          	bgeu	a5,a4,800009e8 <printptr+0x2a>
}
    80000a28:	0001                	nop
    80000a2a:	0001                	nop
    80000a2c:	70a2                	ld	ra,40(sp)
    80000a2e:	7402                	ld	s0,32(sp)
    80000a30:	6145                	addi	sp,sp,48
    80000a32:	8082                	ret

0000000080000a34 <printf>:

// Print to the console. only understands %d, %x, %p, %s.
void
printf(char *fmt, ...)
{
    80000a34:	7119                	addi	sp,sp,-128
    80000a36:	fc06                	sd	ra,56(sp)
    80000a38:	f822                	sd	s0,48(sp)
    80000a3a:	0080                	addi	s0,sp,64
    80000a3c:	fca43423          	sd	a0,-56(s0)
    80000a40:	e40c                	sd	a1,8(s0)
    80000a42:	e810                	sd	a2,16(s0)
    80000a44:	ec14                	sd	a3,24(s0)
    80000a46:	f018                	sd	a4,32(s0)
    80000a48:	f41c                	sd	a5,40(s0)
    80000a4a:	03043823          	sd	a6,48(s0)
    80000a4e:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, c, locking;
  char *s;

  locking = pr.locking;
    80000a52:	00015797          	auipc	a5,0x15
    80000a56:	63678793          	addi	a5,a5,1590 # 80016088 <pr>
    80000a5a:	4f9c                	lw	a5,24(a5)
    80000a5c:	fcf42e23          	sw	a5,-36(s0)
  if(locking)
    80000a60:	fdc42783          	lw	a5,-36(s0)
    80000a64:	2781                	sext.w	a5,a5
    80000a66:	cb89                	beqz	a5,80000a78 <printf+0x44>
    acquire(&pr.lock);
    80000a68:	00015517          	auipc	a0,0x15
    80000a6c:	62050513          	addi	a0,a0,1568 # 80016088 <pr>
    80000a70:	00001097          	auipc	ra,0x1
    80000a74:	80e080e7          	jalr	-2034(ra) # 8000127e <acquire>

  if (fmt == 0)
    80000a78:	fc843783          	ld	a5,-56(s0)
    80000a7c:	eb89                	bnez	a5,80000a8e <printf+0x5a>
    panic("null fmt");
    80000a7e:	0000a517          	auipc	a0,0xa
    80000a82:	58a50513          	addi	a0,a0,1418 # 8000b008 <etext+0x8>
    80000a86:	00000097          	auipc	ra,0x0
    80000a8a:	204080e7          	jalr	516(ra) # 80000c8a <panic>

  va_start(ap, fmt);
    80000a8e:	04040793          	addi	a5,s0,64
    80000a92:	fcf43023          	sd	a5,-64(s0)
    80000a96:	fc043783          	ld	a5,-64(s0)
    80000a9a:	fc878793          	addi	a5,a5,-56
    80000a9e:	fcf43823          	sd	a5,-48(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000aa2:	fe042623          	sw	zero,-20(s0)
    80000aa6:	a24d                	j	80000c48 <printf+0x214>
    if(c != '%'){
    80000aa8:	fd842783          	lw	a5,-40(s0)
    80000aac:	0007871b          	sext.w	a4,a5
    80000ab0:	02500793          	li	a5,37
    80000ab4:	00f70a63          	beq	a4,a5,80000ac8 <printf+0x94>
      consputc(c);
    80000ab8:	fd842783          	lw	a5,-40(s0)
    80000abc:	853e                	mv	a0,a5
    80000abe:	00000097          	auipc	ra,0x0
    80000ac2:	8b6080e7          	jalr	-1866(ra) # 80000374 <consputc>
      continue;
    80000ac6:	aaa5                	j	80000c3e <printf+0x20a>
    }
    c = fmt[++i] & 0xff;
    80000ac8:	fec42783          	lw	a5,-20(s0)
    80000acc:	2785                	addiw	a5,a5,1
    80000ace:	fef42623          	sw	a5,-20(s0)
    80000ad2:	fec42783          	lw	a5,-20(s0)
    80000ad6:	fc843703          	ld	a4,-56(s0)
    80000ada:	97ba                	add	a5,a5,a4
    80000adc:	0007c783          	lbu	a5,0(a5)
    80000ae0:	fcf42c23          	sw	a5,-40(s0)
    if(c == 0)
    80000ae4:	fd842783          	lw	a5,-40(s0)
    80000ae8:	2781                	sext.w	a5,a5
    80000aea:	16078e63          	beqz	a5,80000c66 <printf+0x232>
      break;
    switch(c){
    80000aee:	fd842783          	lw	a5,-40(s0)
    80000af2:	0007871b          	sext.w	a4,a5
    80000af6:	07800793          	li	a5,120
    80000afa:	08f70963          	beq	a4,a5,80000b8c <printf+0x158>
    80000afe:	fd842783          	lw	a5,-40(s0)
    80000b02:	0007871b          	sext.w	a4,a5
    80000b06:	07800793          	li	a5,120
    80000b0a:	10e7cc63          	blt	a5,a4,80000c22 <printf+0x1ee>
    80000b0e:	fd842783          	lw	a5,-40(s0)
    80000b12:	0007871b          	sext.w	a4,a5
    80000b16:	07300793          	li	a5,115
    80000b1a:	0af70563          	beq	a4,a5,80000bc4 <printf+0x190>
    80000b1e:	fd842783          	lw	a5,-40(s0)
    80000b22:	0007871b          	sext.w	a4,a5
    80000b26:	07300793          	li	a5,115
    80000b2a:	0ee7cc63          	blt	a5,a4,80000c22 <printf+0x1ee>
    80000b2e:	fd842783          	lw	a5,-40(s0)
    80000b32:	0007871b          	sext.w	a4,a5
    80000b36:	07000793          	li	a5,112
    80000b3a:	06f70863          	beq	a4,a5,80000baa <printf+0x176>
    80000b3e:	fd842783          	lw	a5,-40(s0)
    80000b42:	0007871b          	sext.w	a4,a5
    80000b46:	07000793          	li	a5,112
    80000b4a:	0ce7cc63          	blt	a5,a4,80000c22 <printf+0x1ee>
    80000b4e:	fd842783          	lw	a5,-40(s0)
    80000b52:	0007871b          	sext.w	a4,a5
    80000b56:	02500793          	li	a5,37
    80000b5a:	0af70d63          	beq	a4,a5,80000c14 <printf+0x1e0>
    80000b5e:	fd842783          	lw	a5,-40(s0)
    80000b62:	0007871b          	sext.w	a4,a5
    80000b66:	06400793          	li	a5,100
    80000b6a:	0af71c63          	bne	a4,a5,80000c22 <printf+0x1ee>
    case 'd':
      printint(va_arg(ap, int), 10, 1);
    80000b6e:	fd043783          	ld	a5,-48(s0)
    80000b72:	00878713          	addi	a4,a5,8
    80000b76:	fce43823          	sd	a4,-48(s0)
    80000b7a:	439c                	lw	a5,0(a5)
    80000b7c:	4605                	li	a2,1
    80000b7e:	45a9                	li	a1,10
    80000b80:	853e                	mv	a0,a5
    80000b82:	00000097          	auipc	ra,0x0
    80000b86:	d38080e7          	jalr	-712(ra) # 800008ba <printint>
      break;
    80000b8a:	a855                	j	80000c3e <printf+0x20a>
    case 'x':
      printint(va_arg(ap, int), 16, 1);
    80000b8c:	fd043783          	ld	a5,-48(s0)
    80000b90:	00878713          	addi	a4,a5,8
    80000b94:	fce43823          	sd	a4,-48(s0)
    80000b98:	439c                	lw	a5,0(a5)
    80000b9a:	4605                	li	a2,1
    80000b9c:	45c1                	li	a1,16
    80000b9e:	853e                	mv	a0,a5
    80000ba0:	00000097          	auipc	ra,0x0
    80000ba4:	d1a080e7          	jalr	-742(ra) # 800008ba <printint>
      break;
    80000ba8:	a859                	j	80000c3e <printf+0x20a>
    case 'p':
      printptr(va_arg(ap, uint64));
    80000baa:	fd043783          	ld	a5,-48(s0)
    80000bae:	00878713          	addi	a4,a5,8
    80000bb2:	fce43823          	sd	a4,-48(s0)
    80000bb6:	639c                	ld	a5,0(a5)
    80000bb8:	853e                	mv	a0,a5
    80000bba:	00000097          	auipc	ra,0x0
    80000bbe:	e04080e7          	jalr	-508(ra) # 800009be <printptr>
      break;
    80000bc2:	a8b5                	j	80000c3e <printf+0x20a>
    case 's':
      if((s = va_arg(ap, char*)) == 0)
    80000bc4:	fd043783          	ld	a5,-48(s0)
    80000bc8:	00878713          	addi	a4,a5,8
    80000bcc:	fce43823          	sd	a4,-48(s0)
    80000bd0:	639c                	ld	a5,0(a5)
    80000bd2:	fef43023          	sd	a5,-32(s0)
    80000bd6:	fe043783          	ld	a5,-32(s0)
    80000bda:	e79d                	bnez	a5,80000c08 <printf+0x1d4>
        s = "(null)";
    80000bdc:	0000a797          	auipc	a5,0xa
    80000be0:	43c78793          	addi	a5,a5,1084 # 8000b018 <etext+0x18>
    80000be4:	fef43023          	sd	a5,-32(s0)
      for(; *s; s++)
    80000be8:	a005                	j	80000c08 <printf+0x1d4>
        consputc(*s);
    80000bea:	fe043783          	ld	a5,-32(s0)
    80000bee:	0007c783          	lbu	a5,0(a5)
    80000bf2:	2781                	sext.w	a5,a5
    80000bf4:	853e                	mv	a0,a5
    80000bf6:	fffff097          	auipc	ra,0xfffff
    80000bfa:	77e080e7          	jalr	1918(ra) # 80000374 <consputc>
      for(; *s; s++)
    80000bfe:	fe043783          	ld	a5,-32(s0)
    80000c02:	0785                	addi	a5,a5,1
    80000c04:	fef43023          	sd	a5,-32(s0)
    80000c08:	fe043783          	ld	a5,-32(s0)
    80000c0c:	0007c783          	lbu	a5,0(a5)
    80000c10:	ffe9                	bnez	a5,80000bea <printf+0x1b6>
      break;
    80000c12:	a035                	j	80000c3e <printf+0x20a>
    case '%':
      consputc('%');
    80000c14:	02500513          	li	a0,37
    80000c18:	fffff097          	auipc	ra,0xfffff
    80000c1c:	75c080e7          	jalr	1884(ra) # 80000374 <consputc>
      break;
    80000c20:	a839                	j	80000c3e <printf+0x20a>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
    80000c22:	02500513          	li	a0,37
    80000c26:	fffff097          	auipc	ra,0xfffff
    80000c2a:	74e080e7          	jalr	1870(ra) # 80000374 <consputc>
      consputc(c);
    80000c2e:	fd842783          	lw	a5,-40(s0)
    80000c32:	853e                	mv	a0,a5
    80000c34:	fffff097          	auipc	ra,0xfffff
    80000c38:	740080e7          	jalr	1856(ra) # 80000374 <consputc>
      break;
    80000c3c:	0001                	nop
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000c3e:	fec42783          	lw	a5,-20(s0)
    80000c42:	2785                	addiw	a5,a5,1
    80000c44:	fef42623          	sw	a5,-20(s0)
    80000c48:	fec42783          	lw	a5,-20(s0)
    80000c4c:	fc843703          	ld	a4,-56(s0)
    80000c50:	97ba                	add	a5,a5,a4
    80000c52:	0007c783          	lbu	a5,0(a5)
    80000c56:	fcf42c23          	sw	a5,-40(s0)
    80000c5a:	fd842783          	lw	a5,-40(s0)
    80000c5e:	2781                	sext.w	a5,a5
    80000c60:	e40794e3          	bnez	a5,80000aa8 <printf+0x74>
    80000c64:	a011                	j	80000c68 <printf+0x234>
      break;
    80000c66:	0001                	nop
    }
  }
  va_end(ap);

  if(locking)
    80000c68:	fdc42783          	lw	a5,-36(s0)
    80000c6c:	2781                	sext.w	a5,a5
    80000c6e:	cb89                	beqz	a5,80000c80 <printf+0x24c>
    release(&pr.lock);
    80000c70:	00015517          	auipc	a0,0x15
    80000c74:	41850513          	addi	a0,a0,1048 # 80016088 <pr>
    80000c78:	00000097          	auipc	ra,0x0
    80000c7c:	66a080e7          	jalr	1642(ra) # 800012e2 <release>
}
    80000c80:	0001                	nop
    80000c82:	70e2                	ld	ra,56(sp)
    80000c84:	7442                	ld	s0,48(sp)
    80000c86:	6109                	addi	sp,sp,128
    80000c88:	8082                	ret

0000000080000c8a <panic>:

void
panic(char *s)
{
    80000c8a:	1101                	addi	sp,sp,-32
    80000c8c:	ec06                	sd	ra,24(sp)
    80000c8e:	e822                	sd	s0,16(sp)
    80000c90:	1000                	addi	s0,sp,32
    80000c92:	fea43423          	sd	a0,-24(s0)
  pr.locking = 0;
    80000c96:	00015797          	auipc	a5,0x15
    80000c9a:	3f278793          	addi	a5,a5,1010 # 80016088 <pr>
    80000c9e:	0007ac23          	sw	zero,24(a5)
  printf("panic: ");
    80000ca2:	0000a517          	auipc	a0,0xa
    80000ca6:	37e50513          	addi	a0,a0,894 # 8000b020 <etext+0x20>
    80000caa:	00000097          	auipc	ra,0x0
    80000cae:	d8a080e7          	jalr	-630(ra) # 80000a34 <printf>
  printf(s);
    80000cb2:	fe843503          	ld	a0,-24(s0)
    80000cb6:	00000097          	auipc	ra,0x0
    80000cba:	d7e080e7          	jalr	-642(ra) # 80000a34 <printf>
  printf("\n");
    80000cbe:	0000a517          	auipc	a0,0xa
    80000cc2:	36a50513          	addi	a0,a0,874 # 8000b028 <etext+0x28>
    80000cc6:	00000097          	auipc	ra,0x0
    80000cca:	d6e080e7          	jalr	-658(ra) # 80000a34 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000cce:	0000d797          	auipc	a5,0xd
    80000cd2:	1a278793          	addi	a5,a5,418 # 8000de70 <panicked>
    80000cd6:	4705                	li	a4,1
    80000cd8:	c398                	sw	a4,0(a5)
  for(;;)
    80000cda:	0001                	nop
    80000cdc:	bffd                	j	80000cda <panic+0x50>

0000000080000cde <printfinit>:
    ;
}

void
printfinit(void)
{
    80000cde:	1141                	addi	sp,sp,-16
    80000ce0:	e406                	sd	ra,8(sp)
    80000ce2:	e022                	sd	s0,0(sp)
    80000ce4:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    80000ce6:	0000a597          	auipc	a1,0xa
    80000cea:	34a58593          	addi	a1,a1,842 # 8000b030 <etext+0x30>
    80000cee:	00015517          	auipc	a0,0x15
    80000cf2:	39a50513          	addi	a0,a0,922 # 80016088 <pr>
    80000cf6:	00000097          	auipc	ra,0x0
    80000cfa:	558080e7          	jalr	1368(ra) # 8000124e <initlock>
  pr.locking = 1;
    80000cfe:	00015797          	auipc	a5,0x15
    80000d02:	38a78793          	addi	a5,a5,906 # 80016088 <pr>
    80000d06:	4705                	li	a4,1
    80000d08:	cf98                	sw	a4,24(a5)
}
    80000d0a:	0001                	nop
    80000d0c:	60a2                	ld	ra,8(sp)
    80000d0e:	6402                	ld	s0,0(sp)
    80000d10:	0141                	addi	sp,sp,16
    80000d12:	8082                	ret

0000000080000d14 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80000d14:	1141                	addi	sp,sp,-16
    80000d16:	e406                	sd	ra,8(sp)
    80000d18:	e022                	sd	s0,0(sp)
    80000d1a:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80000d1c:	100007b7          	lui	a5,0x10000
    80000d20:	0785                	addi	a5,a5,1 # 10000001 <_entry-0x6fffffff>
    80000d22:	00078023          	sb	zero,0(a5)

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000d26:	100007b7          	lui	a5,0x10000
    80000d2a:	078d                	addi	a5,a5,3 # 10000003 <_entry-0x6ffffffd>
    80000d2c:	f8000713          	li	a4,-128
    80000d30:	00e78023          	sb	a4,0(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000d34:	100007b7          	lui	a5,0x10000
    80000d38:	470d                	li	a4,3
    80000d3a:	00e78023          	sb	a4,0(a5) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000d3e:	100007b7          	lui	a5,0x10000
    80000d42:	0785                	addi	a5,a5,1 # 10000001 <_entry-0x6fffffff>
    80000d44:	00078023          	sb	zero,0(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000d48:	100007b7          	lui	a5,0x10000
    80000d4c:	078d                	addi	a5,a5,3 # 10000003 <_entry-0x6ffffffd>
    80000d4e:	470d                	li	a4,3
    80000d50:	00e78023          	sb	a4,0(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000d54:	100007b7          	lui	a5,0x10000
    80000d58:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80000d5a:	471d                	li	a4,7
    80000d5c:	00e78023          	sb	a4,0(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80000d60:	100007b7          	lui	a5,0x10000
    80000d64:	0785                	addi	a5,a5,1 # 10000001 <_entry-0x6fffffff>
    80000d66:	470d                	li	a4,3
    80000d68:	00e78023          	sb	a4,0(a5)

  initlock(&uart_tx_lock, "uart");
    80000d6c:	0000a597          	auipc	a1,0xa
    80000d70:	2cc58593          	addi	a1,a1,716 # 8000b038 <etext+0x38>
    80000d74:	00015517          	auipc	a0,0x15
    80000d78:	33450513          	addi	a0,a0,820 # 800160a8 <uart_tx_lock>
    80000d7c:	00000097          	auipc	ra,0x0
    80000d80:	4d2080e7          	jalr	1234(ra) # 8000124e <initlock>
}
    80000d84:	0001                	nop
    80000d86:	60a2                	ld	ra,8(sp)
    80000d88:	6402                	ld	s0,0(sp)
    80000d8a:	0141                	addi	sp,sp,16
    80000d8c:	8082                	ret

0000000080000d8e <uartputc>:
// because it may block, it can't be called
// from interrupts; it's only suitable for use
// by write().
void
uartputc(int c)
{
    80000d8e:	1101                	addi	sp,sp,-32
    80000d90:	ec06                	sd	ra,24(sp)
    80000d92:	e822                	sd	s0,16(sp)
    80000d94:	1000                	addi	s0,sp,32
    80000d96:	87aa                	mv	a5,a0
    80000d98:	fef42623          	sw	a5,-20(s0)
  acquire(&uart_tx_lock);
    80000d9c:	00015517          	auipc	a0,0x15
    80000da0:	30c50513          	addi	a0,a0,780 # 800160a8 <uart_tx_lock>
    80000da4:	00000097          	auipc	ra,0x0
    80000da8:	4da080e7          	jalr	1242(ra) # 8000127e <acquire>

  if(panicked){
    80000dac:	0000d797          	auipc	a5,0xd
    80000db0:	0c478793          	addi	a5,a5,196 # 8000de70 <panicked>
    80000db4:	439c                	lw	a5,0(a5)
    80000db6:	2781                	sext.w	a5,a5
    80000db8:	cf99                	beqz	a5,80000dd6 <uartputc+0x48>
    for(;;)
    80000dba:	0001                	nop
    80000dbc:	bffd                	j	80000dba <uartputc+0x2c>
      ;
  }
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    // buffer is full.
    // wait for uartstart() to open up space in the buffer.
    sleep(&uart_tx_r, &uart_tx_lock);
    80000dbe:	00015597          	auipc	a1,0x15
    80000dc2:	2ea58593          	addi	a1,a1,746 # 800160a8 <uart_tx_lock>
    80000dc6:	0000d517          	auipc	a0,0xd
    80000dca:	0ba50513          	addi	a0,a0,186 # 8000de80 <uart_tx_r>
    80000dce:	00002097          	auipc	ra,0x2
    80000dd2:	63a080e7          	jalr	1594(ra) # 80003408 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000dd6:	0000d797          	auipc	a5,0xd
    80000dda:	0aa78793          	addi	a5,a5,170 # 8000de80 <uart_tx_r>
    80000dde:	639c                	ld	a5,0(a5)
    80000de0:	02078713          	addi	a4,a5,32
    80000de4:	0000d797          	auipc	a5,0xd
    80000de8:	09478793          	addi	a5,a5,148 # 8000de78 <uart_tx_w>
    80000dec:	639c                	ld	a5,0(a5)
    80000dee:	fcf708e3          	beq	a4,a5,80000dbe <uartputc+0x30>
  }
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000df2:	0000d797          	auipc	a5,0xd
    80000df6:	08678793          	addi	a5,a5,134 # 8000de78 <uart_tx_w>
    80000dfa:	639c                	ld	a5,0(a5)
    80000dfc:	8bfd                	andi	a5,a5,31
    80000dfe:	fec42703          	lw	a4,-20(s0)
    80000e02:	0ff77713          	zext.b	a4,a4
    80000e06:	00015697          	auipc	a3,0x15
    80000e0a:	2ba68693          	addi	a3,a3,698 # 800160c0 <uart_tx_buf>
    80000e0e:	97b6                	add	a5,a5,a3
    80000e10:	00e78023          	sb	a4,0(a5)
  uart_tx_w += 1;
    80000e14:	0000d797          	auipc	a5,0xd
    80000e18:	06478793          	addi	a5,a5,100 # 8000de78 <uart_tx_w>
    80000e1c:	639c                	ld	a5,0(a5)
    80000e1e:	00178713          	addi	a4,a5,1
    80000e22:	0000d797          	auipc	a5,0xd
    80000e26:	05678793          	addi	a5,a5,86 # 8000de78 <uart_tx_w>
    80000e2a:	e398                	sd	a4,0(a5)
  uartstart();
    80000e2c:	00000097          	auipc	ra,0x0
    80000e30:	086080e7          	jalr	134(ra) # 80000eb2 <uartstart>
  release(&uart_tx_lock);
    80000e34:	00015517          	auipc	a0,0x15
    80000e38:	27450513          	addi	a0,a0,628 # 800160a8 <uart_tx_lock>
    80000e3c:	00000097          	auipc	ra,0x0
    80000e40:	4a6080e7          	jalr	1190(ra) # 800012e2 <release>
}
    80000e44:	0001                	nop
    80000e46:	60e2                	ld	ra,24(sp)
    80000e48:	6442                	ld	s0,16(sp)
    80000e4a:	6105                	addi	sp,sp,32
    80000e4c:	8082                	ret

0000000080000e4e <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000e4e:	1101                	addi	sp,sp,-32
    80000e50:	ec06                	sd	ra,24(sp)
    80000e52:	e822                	sd	s0,16(sp)
    80000e54:	1000                	addi	s0,sp,32
    80000e56:	87aa                	mv	a5,a0
    80000e58:	fef42623          	sw	a5,-20(s0)
  push_off();
    80000e5c:	00000097          	auipc	ra,0x0
    80000e60:	520080e7          	jalr	1312(ra) # 8000137c <push_off>

  if(panicked){
    80000e64:	0000d797          	auipc	a5,0xd
    80000e68:	00c78793          	addi	a5,a5,12 # 8000de70 <panicked>
    80000e6c:	439c                	lw	a5,0(a5)
    80000e6e:	2781                	sext.w	a5,a5
    80000e70:	c399                	beqz	a5,80000e76 <uartputc_sync+0x28>
    for(;;)
    80000e72:	0001                	nop
    80000e74:	bffd                	j	80000e72 <uartputc_sync+0x24>
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000e76:	0001                	nop
    80000e78:	100007b7          	lui	a5,0x10000
    80000e7c:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80000e7e:	0007c783          	lbu	a5,0(a5)
    80000e82:	0ff7f793          	zext.b	a5,a5
    80000e86:	2781                	sext.w	a5,a5
    80000e88:	0207f793          	andi	a5,a5,32
    80000e8c:	2781                	sext.w	a5,a5
    80000e8e:	d7ed                	beqz	a5,80000e78 <uartputc_sync+0x2a>
    ;
  WriteReg(THR, c);
    80000e90:	100007b7          	lui	a5,0x10000
    80000e94:	fec42703          	lw	a4,-20(s0)
    80000e98:	0ff77713          	zext.b	a4,a4
    80000e9c:	00e78023          	sb	a4,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000ea0:	00000097          	auipc	ra,0x0
    80000ea4:	534080e7          	jalr	1332(ra) # 800013d4 <pop_off>
}
    80000ea8:	0001                	nop
    80000eaa:	60e2                	ld	ra,24(sp)
    80000eac:	6442                	ld	s0,16(sp)
    80000eae:	6105                	addi	sp,sp,32
    80000eb0:	8082                	ret

0000000080000eb2 <uartstart>:
// in the transmit buffer, send it.
// caller must hold uart_tx_lock.
// called from both the top- and bottom-half.
void
uartstart()
{
    80000eb2:	1101                	addi	sp,sp,-32
    80000eb4:	ec06                	sd	ra,24(sp)
    80000eb6:	e822                	sd	s0,16(sp)
    80000eb8:	1000                	addi	s0,sp,32
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000eba:	0000d797          	auipc	a5,0xd
    80000ebe:	fbe78793          	addi	a5,a5,-66 # 8000de78 <uart_tx_w>
    80000ec2:	6398                	ld	a4,0(a5)
    80000ec4:	0000d797          	auipc	a5,0xd
    80000ec8:	fbc78793          	addi	a5,a5,-68 # 8000de80 <uart_tx_r>
    80000ecc:	639c                	ld	a5,0(a5)
    80000ece:	06f70a63          	beq	a4,a5,80000f42 <uartstart+0x90>
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000ed2:	100007b7          	lui	a5,0x10000
    80000ed6:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80000ed8:	0007c783          	lbu	a5,0(a5)
    80000edc:	0ff7f793          	zext.b	a5,a5
    80000ee0:	2781                	sext.w	a5,a5
    80000ee2:	0207f793          	andi	a5,a5,32
    80000ee6:	2781                	sext.w	a5,a5
    80000ee8:	cfb9                	beqz	a5,80000f46 <uartstart+0x94>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000eea:	0000d797          	auipc	a5,0xd
    80000eee:	f9678793          	addi	a5,a5,-106 # 8000de80 <uart_tx_r>
    80000ef2:	639c                	ld	a5,0(a5)
    80000ef4:	8bfd                	andi	a5,a5,31
    80000ef6:	00015717          	auipc	a4,0x15
    80000efa:	1ca70713          	addi	a4,a4,458 # 800160c0 <uart_tx_buf>
    80000efe:	97ba                	add	a5,a5,a4
    80000f00:	0007c783          	lbu	a5,0(a5)
    80000f04:	fef42623          	sw	a5,-20(s0)
    uart_tx_r += 1;
    80000f08:	0000d797          	auipc	a5,0xd
    80000f0c:	f7878793          	addi	a5,a5,-136 # 8000de80 <uart_tx_r>
    80000f10:	639c                	ld	a5,0(a5)
    80000f12:	00178713          	addi	a4,a5,1
    80000f16:	0000d797          	auipc	a5,0xd
    80000f1a:	f6a78793          	addi	a5,a5,-150 # 8000de80 <uart_tx_r>
    80000f1e:	e398                	sd	a4,0(a5)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80000f20:	0000d517          	auipc	a0,0xd
    80000f24:	f6050513          	addi	a0,a0,-160 # 8000de80 <uart_tx_r>
    80000f28:	00002097          	auipc	ra,0x2
    80000f2c:	55c080e7          	jalr	1372(ra) # 80003484 <wakeup>
    
    WriteReg(THR, c);
    80000f30:	100007b7          	lui	a5,0x10000
    80000f34:	fec42703          	lw	a4,-20(s0)
    80000f38:	0ff77713          	zext.b	a4,a4
    80000f3c:	00e78023          	sb	a4,0(a5) # 10000000 <_entry-0x70000000>
  while(1){
    80000f40:	bfad                	j	80000eba <uartstart+0x8>
      return;
    80000f42:	0001                	nop
    80000f44:	a011                	j	80000f48 <uartstart+0x96>
      return;
    80000f46:	0001                	nop
  }
}
    80000f48:	60e2                	ld	ra,24(sp)
    80000f4a:	6442                	ld	s0,16(sp)
    80000f4c:	6105                	addi	sp,sp,32
    80000f4e:	8082                	ret

0000000080000f50 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000f50:	1141                	addi	sp,sp,-16
    80000f52:	e422                	sd	s0,8(sp)
    80000f54:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000f56:	100007b7          	lui	a5,0x10000
    80000f5a:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80000f5c:	0007c783          	lbu	a5,0(a5)
    80000f60:	0ff7f793          	zext.b	a5,a5
    80000f64:	2781                	sext.w	a5,a5
    80000f66:	8b85                	andi	a5,a5,1
    80000f68:	2781                	sext.w	a5,a5
    80000f6a:	cb89                	beqz	a5,80000f7c <uartgetc+0x2c>
    // input data is ready.
    return ReadReg(RHR);
    80000f6c:	100007b7          	lui	a5,0x10000
    80000f70:	0007c783          	lbu	a5,0(a5) # 10000000 <_entry-0x70000000>
    80000f74:	0ff7f793          	zext.b	a5,a5
    80000f78:	2781                	sext.w	a5,a5
    80000f7a:	a011                	j	80000f7e <uartgetc+0x2e>
  } else {
    return -1;
    80000f7c:	57fd                	li	a5,-1
  }
}
    80000f7e:	853e                	mv	a0,a5
    80000f80:	6422                	ld	s0,8(sp)
    80000f82:	0141                	addi	sp,sp,16
    80000f84:	8082                	ret

0000000080000f86 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000f86:	1101                	addi	sp,sp,-32
    80000f88:	ec06                	sd	ra,24(sp)
    80000f8a:	e822                	sd	s0,16(sp)
    80000f8c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    80000f8e:	00000097          	auipc	ra,0x0
    80000f92:	fc2080e7          	jalr	-62(ra) # 80000f50 <uartgetc>
    80000f96:	87aa                	mv	a5,a0
    80000f98:	fef42623          	sw	a5,-20(s0)
    if(c == -1)
    80000f9c:	fec42783          	lw	a5,-20(s0)
    80000fa0:	0007871b          	sext.w	a4,a5
    80000fa4:	57fd                	li	a5,-1
    80000fa6:	00f70a63          	beq	a4,a5,80000fba <uartintr+0x34>
      break;
    consoleintr(c);
    80000faa:	fec42783          	lw	a5,-20(s0)
    80000fae:	853e                	mv	a0,a5
    80000fb0:	fffff097          	auipc	ra,0xfffff
    80000fb4:	646080e7          	jalr	1606(ra) # 800005f6 <consoleintr>
  while(1){
    80000fb8:	bfd9                	j	80000f8e <uartintr+0x8>
      break;
    80000fba:	0001                	nop
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000fbc:	00015517          	auipc	a0,0x15
    80000fc0:	0ec50513          	addi	a0,a0,236 # 800160a8 <uart_tx_lock>
    80000fc4:	00000097          	auipc	ra,0x0
    80000fc8:	2ba080e7          	jalr	698(ra) # 8000127e <acquire>
  uartstart();
    80000fcc:	00000097          	auipc	ra,0x0
    80000fd0:	ee6080e7          	jalr	-282(ra) # 80000eb2 <uartstart>
  release(&uart_tx_lock);
    80000fd4:	00015517          	auipc	a0,0x15
    80000fd8:	0d450513          	addi	a0,a0,212 # 800160a8 <uart_tx_lock>
    80000fdc:	00000097          	auipc	ra,0x0
    80000fe0:	306080e7          	jalr	774(ra) # 800012e2 <release>
}
    80000fe4:	0001                	nop
    80000fe6:	60e2                	ld	ra,24(sp)
    80000fe8:	6442                	ld	s0,16(sp)
    80000fea:	6105                	addi	sp,sp,32
    80000fec:	8082                	ret

0000000080000fee <kinit>:
  struct run *freelist;
} kmem;

void
kinit()
{
    80000fee:	1141                	addi	sp,sp,-16
    80000ff0:	e406                	sd	ra,8(sp)
    80000ff2:	e022                	sd	s0,0(sp)
    80000ff4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000ff6:	0000a597          	auipc	a1,0xa
    80000ffa:	04a58593          	addi	a1,a1,74 # 8000b040 <etext+0x40>
    80000ffe:	00015517          	auipc	a0,0x15
    80001002:	0e250513          	addi	a0,a0,226 # 800160e0 <kmem>
    80001006:	00000097          	auipc	ra,0x0
    8000100a:	248080e7          	jalr	584(ra) # 8000124e <initlock>
  freerange(end, (void*)PHYSTOP);
    8000100e:	47c5                	li	a5,17
    80001010:	01b79593          	slli	a1,a5,0x1b
    80001014:	00026517          	auipc	a0,0x26
    80001018:	30450513          	addi	a0,a0,772 # 80027318 <end>
    8000101c:	00000097          	auipc	ra,0x0
    80001020:	012080e7          	jalr	18(ra) # 8000102e <freerange>
}
    80001024:	0001                	nop
    80001026:	60a2                	ld	ra,8(sp)
    80001028:	6402                	ld	s0,0(sp)
    8000102a:	0141                	addi	sp,sp,16
    8000102c:	8082                	ret

000000008000102e <freerange>:

void
freerange(void *pa_start, void *pa_end)
{
    8000102e:	7179                	addi	sp,sp,-48
    80001030:	f406                	sd	ra,40(sp)
    80001032:	f022                	sd	s0,32(sp)
    80001034:	1800                	addi	s0,sp,48
    80001036:	fca43c23          	sd	a0,-40(s0)
    8000103a:	fcb43823          	sd	a1,-48(s0)
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000103e:	fd843703          	ld	a4,-40(s0)
    80001042:	6785                	lui	a5,0x1
    80001044:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001046:	973e                	add	a4,a4,a5
    80001048:	77fd                	lui	a5,0xfffff
    8000104a:	8ff9                	and	a5,a5,a4
    8000104c:	fef43423          	sd	a5,-24(s0)
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80001050:	a829                	j	8000106a <freerange+0x3c>
    kfree(p);
    80001052:	fe843503          	ld	a0,-24(s0)
    80001056:	00000097          	auipc	ra,0x0
    8000105a:	030080e7          	jalr	48(ra) # 80001086 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000105e:	fe843703          	ld	a4,-24(s0)
    80001062:	6785                	lui	a5,0x1
    80001064:	97ba                	add	a5,a5,a4
    80001066:	fef43423          	sd	a5,-24(s0)
    8000106a:	fe843703          	ld	a4,-24(s0)
    8000106e:	6785                	lui	a5,0x1
    80001070:	97ba                	add	a5,a5,a4
    80001072:	fd043703          	ld	a4,-48(s0)
    80001076:	fcf77ee3          	bgeu	a4,a5,80001052 <freerange+0x24>
}
    8000107a:	0001                	nop
    8000107c:	0001                	nop
    8000107e:	70a2                	ld	ra,40(sp)
    80001080:	7402                	ld	s0,32(sp)
    80001082:	6145                	addi	sp,sp,48
    80001084:	8082                	ret

0000000080001086 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80001086:	7179                	addi	sp,sp,-48
    80001088:	f406                	sd	ra,40(sp)
    8000108a:	f022                	sd	s0,32(sp)
    8000108c:	1800                	addi	s0,sp,48
    8000108e:	fca43c23          	sd	a0,-40(s0)
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80001092:	fd843703          	ld	a4,-40(s0)
    80001096:	6785                	lui	a5,0x1
    80001098:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000109a:	8ff9                	and	a5,a5,a4
    8000109c:	ef99                	bnez	a5,800010ba <kfree+0x34>
    8000109e:	fd843703          	ld	a4,-40(s0)
    800010a2:	00026797          	auipc	a5,0x26
    800010a6:	27678793          	addi	a5,a5,630 # 80027318 <end>
    800010aa:	00f76863          	bltu	a4,a5,800010ba <kfree+0x34>
    800010ae:	fd843703          	ld	a4,-40(s0)
    800010b2:	47c5                	li	a5,17
    800010b4:	07ee                	slli	a5,a5,0x1b
    800010b6:	00f76a63          	bltu	a4,a5,800010ca <kfree+0x44>
    panic("kfree");
    800010ba:	0000a517          	auipc	a0,0xa
    800010be:	f8e50513          	addi	a0,a0,-114 # 8000b048 <etext+0x48>
    800010c2:	00000097          	auipc	ra,0x0
    800010c6:	bc8080e7          	jalr	-1080(ra) # 80000c8a <panic>

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    800010ca:	6605                	lui	a2,0x1
    800010cc:	4585                	li	a1,1
    800010ce:	fd843503          	ld	a0,-40(s0)
    800010d2:	00000097          	auipc	ra,0x0
    800010d6:	380080e7          	jalr	896(ra) # 80001452 <memset>

  r = (struct run*)pa;
    800010da:	fd843783          	ld	a5,-40(s0)
    800010de:	fef43423          	sd	a5,-24(s0)

  acquire(&kmem.lock);
    800010e2:	00015517          	auipc	a0,0x15
    800010e6:	ffe50513          	addi	a0,a0,-2 # 800160e0 <kmem>
    800010ea:	00000097          	auipc	ra,0x0
    800010ee:	194080e7          	jalr	404(ra) # 8000127e <acquire>
  r->next = kmem.freelist;
    800010f2:	00015797          	auipc	a5,0x15
    800010f6:	fee78793          	addi	a5,a5,-18 # 800160e0 <kmem>
    800010fa:	6f98                	ld	a4,24(a5)
    800010fc:	fe843783          	ld	a5,-24(s0)
    80001100:	e398                	sd	a4,0(a5)
  kmem.freelist = r;
    80001102:	00015797          	auipc	a5,0x15
    80001106:	fde78793          	addi	a5,a5,-34 # 800160e0 <kmem>
    8000110a:	fe843703          	ld	a4,-24(s0)
    8000110e:	ef98                	sd	a4,24(a5)
  release(&kmem.lock);
    80001110:	00015517          	auipc	a0,0x15
    80001114:	fd050513          	addi	a0,a0,-48 # 800160e0 <kmem>
    80001118:	00000097          	auipc	ra,0x0
    8000111c:	1ca080e7          	jalr	458(ra) # 800012e2 <release>
}
    80001120:	0001                	nop
    80001122:	70a2                	ld	ra,40(sp)
    80001124:	7402                	ld	s0,32(sp)
    80001126:	6145                	addi	sp,sp,48
    80001128:	8082                	ret

000000008000112a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000112a:	1101                	addi	sp,sp,-32
    8000112c:	ec06                	sd	ra,24(sp)
    8000112e:	e822                	sd	s0,16(sp)
    80001130:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80001132:	00015517          	auipc	a0,0x15
    80001136:	fae50513          	addi	a0,a0,-82 # 800160e0 <kmem>
    8000113a:	00000097          	auipc	ra,0x0
    8000113e:	144080e7          	jalr	324(ra) # 8000127e <acquire>
  r = kmem.freelist;
    80001142:	00015797          	auipc	a5,0x15
    80001146:	f9e78793          	addi	a5,a5,-98 # 800160e0 <kmem>
    8000114a:	6f9c                	ld	a5,24(a5)
    8000114c:	fef43423          	sd	a5,-24(s0)
  if(r)
    80001150:	fe843783          	ld	a5,-24(s0)
    80001154:	cb89                	beqz	a5,80001166 <kalloc+0x3c>
    kmem.freelist = r->next;
    80001156:	fe843783          	ld	a5,-24(s0)
    8000115a:	6398                	ld	a4,0(a5)
    8000115c:	00015797          	auipc	a5,0x15
    80001160:	f8478793          	addi	a5,a5,-124 # 800160e0 <kmem>
    80001164:	ef98                	sd	a4,24(a5)
  release(&kmem.lock);
    80001166:	00015517          	auipc	a0,0x15
    8000116a:	f7a50513          	addi	a0,a0,-134 # 800160e0 <kmem>
    8000116e:	00000097          	auipc	ra,0x0
    80001172:	174080e7          	jalr	372(ra) # 800012e2 <release>

  if(r)
    80001176:	fe843783          	ld	a5,-24(s0)
    8000117a:	cb89                	beqz	a5,8000118c <kalloc+0x62>
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000117c:	6605                	lui	a2,0x1
    8000117e:	4595                	li	a1,5
    80001180:	fe843503          	ld	a0,-24(s0)
    80001184:	00000097          	auipc	ra,0x0
    80001188:	2ce080e7          	jalr	718(ra) # 80001452 <memset>
  return (void*)r;
    8000118c:	fe843783          	ld	a5,-24(s0)
}
    80001190:	853e                	mv	a0,a5
    80001192:	60e2                	ld	ra,24(sp)
    80001194:	6442                	ld	s0,16(sp)
    80001196:	6105                	addi	sp,sp,32
    80001198:	8082                	ret

000000008000119a <r_sstatus>:
{
    8000119a:	1101                	addi	sp,sp,-32
    8000119c:	ec22                	sd	s0,24(sp)
    8000119e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800011a0:	100027f3          	csrr	a5,sstatus
    800011a4:	fef43423          	sd	a5,-24(s0)
  return x;
    800011a8:	fe843783          	ld	a5,-24(s0)
}
    800011ac:	853e                	mv	a0,a5
    800011ae:	6462                	ld	s0,24(sp)
    800011b0:	6105                	addi	sp,sp,32
    800011b2:	8082                	ret

00000000800011b4 <w_sstatus>:
{
    800011b4:	1101                	addi	sp,sp,-32
    800011b6:	ec22                	sd	s0,24(sp)
    800011b8:	1000                	addi	s0,sp,32
    800011ba:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800011be:	fe843783          	ld	a5,-24(s0)
    800011c2:	10079073          	csrw	sstatus,a5
}
    800011c6:	0001                	nop
    800011c8:	6462                	ld	s0,24(sp)
    800011ca:	6105                	addi	sp,sp,32
    800011cc:	8082                	ret

00000000800011ce <intr_on>:
{
    800011ce:	1141                	addi	sp,sp,-16
    800011d0:	e406                	sd	ra,8(sp)
    800011d2:	e022                	sd	s0,0(sp)
    800011d4:	0800                	addi	s0,sp,16
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800011d6:	00000097          	auipc	ra,0x0
    800011da:	fc4080e7          	jalr	-60(ra) # 8000119a <r_sstatus>
    800011de:	87aa                	mv	a5,a0
    800011e0:	0027e793          	ori	a5,a5,2
    800011e4:	853e                	mv	a0,a5
    800011e6:	00000097          	auipc	ra,0x0
    800011ea:	fce080e7          	jalr	-50(ra) # 800011b4 <w_sstatus>
}
    800011ee:	0001                	nop
    800011f0:	60a2                	ld	ra,8(sp)
    800011f2:	6402                	ld	s0,0(sp)
    800011f4:	0141                	addi	sp,sp,16
    800011f6:	8082                	ret

00000000800011f8 <intr_off>:
{
    800011f8:	1141                	addi	sp,sp,-16
    800011fa:	e406                	sd	ra,8(sp)
    800011fc:	e022                	sd	s0,0(sp)
    800011fe:	0800                	addi	s0,sp,16
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001200:	00000097          	auipc	ra,0x0
    80001204:	f9a080e7          	jalr	-102(ra) # 8000119a <r_sstatus>
    80001208:	87aa                	mv	a5,a0
    8000120a:	9bf5                	andi	a5,a5,-3
    8000120c:	853e                	mv	a0,a5
    8000120e:	00000097          	auipc	ra,0x0
    80001212:	fa6080e7          	jalr	-90(ra) # 800011b4 <w_sstatus>
}
    80001216:	0001                	nop
    80001218:	60a2                	ld	ra,8(sp)
    8000121a:	6402                	ld	s0,0(sp)
    8000121c:	0141                	addi	sp,sp,16
    8000121e:	8082                	ret

0000000080001220 <intr_get>:
{
    80001220:	1101                	addi	sp,sp,-32
    80001222:	ec06                	sd	ra,24(sp)
    80001224:	e822                	sd	s0,16(sp)
    80001226:	1000                	addi	s0,sp,32
  uint64 x = r_sstatus();
    80001228:	00000097          	auipc	ra,0x0
    8000122c:	f72080e7          	jalr	-142(ra) # 8000119a <r_sstatus>
    80001230:	fea43423          	sd	a0,-24(s0)
  return (x & SSTATUS_SIE) != 0;
    80001234:	fe843783          	ld	a5,-24(s0)
    80001238:	8b89                	andi	a5,a5,2
    8000123a:	00f037b3          	snez	a5,a5
    8000123e:	0ff7f793          	zext.b	a5,a5
    80001242:	2781                	sext.w	a5,a5
}
    80001244:	853e                	mv	a0,a5
    80001246:	60e2                	ld	ra,24(sp)
    80001248:	6442                	ld	s0,16(sp)
    8000124a:	6105                	addi	sp,sp,32
    8000124c:	8082                	ret

000000008000124e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000124e:	1101                	addi	sp,sp,-32
    80001250:	ec22                	sd	s0,24(sp)
    80001252:	1000                	addi	s0,sp,32
    80001254:	fea43423          	sd	a0,-24(s0)
    80001258:	feb43023          	sd	a1,-32(s0)
  lk->name = name;
    8000125c:	fe843783          	ld	a5,-24(s0)
    80001260:	fe043703          	ld	a4,-32(s0)
    80001264:	e798                	sd	a4,8(a5)
  lk->locked = 0;
    80001266:	fe843783          	ld	a5,-24(s0)
    8000126a:	0007a023          	sw	zero,0(a5)
  lk->cpu = 0;
    8000126e:	fe843783          	ld	a5,-24(s0)
    80001272:	0007b823          	sd	zero,16(a5)
}
    80001276:	0001                	nop
    80001278:	6462                	ld	s0,24(sp)
    8000127a:	6105                	addi	sp,sp,32
    8000127c:	8082                	ret

000000008000127e <acquire>:

// Acquire the lock.
// Loops (spins) until the lock is acquired.
void
acquire(struct spinlock *lk)
{
    8000127e:	1101                	addi	sp,sp,-32
    80001280:	ec06                	sd	ra,24(sp)
    80001282:	e822                	sd	s0,16(sp)
    80001284:	1000                	addi	s0,sp,32
    80001286:	fea43423          	sd	a0,-24(s0)
  push_off(); // disable interrupts to avoid deadlock.
    8000128a:	00000097          	auipc	ra,0x0
    8000128e:	0f2080e7          	jalr	242(ra) # 8000137c <push_off>
  if(holding(lk))
    80001292:	fe843503          	ld	a0,-24(s0)
    80001296:	00000097          	auipc	ra,0x0
    8000129a:	0a2080e7          	jalr	162(ra) # 80001338 <holding>
    8000129e:	87aa                	mv	a5,a0
    800012a0:	cb89                	beqz	a5,800012b2 <acquire+0x34>
    panic("acquire");
    800012a2:	0000a517          	auipc	a0,0xa
    800012a6:	dae50513          	addi	a0,a0,-594 # 8000b050 <etext+0x50>
    800012aa:	00000097          	auipc	ra,0x0
    800012ae:	9e0080e7          	jalr	-1568(ra) # 80000c8a <panic>

  // On RISC-V, sync_lock_test_and_set turns into an atomic swap:
  //   a5 = 1
  //   s1 = &lk->locked
  //   amoswap.w.aq a5, a5, (s1)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800012b2:	0001                	nop
    800012b4:	fe843783          	ld	a5,-24(s0)
    800012b8:	4705                	li	a4,1
    800012ba:	0ce7a72f          	amoswap.w.aq	a4,a4,(a5)
    800012be:	0007079b          	sext.w	a5,a4
    800012c2:	fbed                	bnez	a5,800012b4 <acquire+0x36>

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen strictly after the lock is acquired.
  // On RISC-V, this emits a fence instruction.
  __sync_synchronize();
    800012c4:	0330000f          	fence	rw,rw

  // Record info about lock acquisition for holding() and debugging.
  lk->cpu = mycpu();
    800012c8:	00001097          	auipc	ra,0x1
    800012cc:	544080e7          	jalr	1348(ra) # 8000280c <mycpu>
    800012d0:	872a                	mv	a4,a0
    800012d2:	fe843783          	ld	a5,-24(s0)
    800012d6:	eb98                	sd	a4,16(a5)
}
    800012d8:	0001                	nop
    800012da:	60e2                	ld	ra,24(sp)
    800012dc:	6442                	ld	s0,16(sp)
    800012de:	6105                	addi	sp,sp,32
    800012e0:	8082                	ret

00000000800012e2 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
    800012e2:	1101                	addi	sp,sp,-32
    800012e4:	ec06                	sd	ra,24(sp)
    800012e6:	e822                	sd	s0,16(sp)
    800012e8:	1000                	addi	s0,sp,32
    800012ea:	fea43423          	sd	a0,-24(s0)
  if(!holding(lk))
    800012ee:	fe843503          	ld	a0,-24(s0)
    800012f2:	00000097          	auipc	ra,0x0
    800012f6:	046080e7          	jalr	70(ra) # 80001338 <holding>
    800012fa:	87aa                	mv	a5,a0
    800012fc:	eb89                	bnez	a5,8000130e <release+0x2c>
    panic("release");
    800012fe:	0000a517          	auipc	a0,0xa
    80001302:	d5a50513          	addi	a0,a0,-678 # 8000b058 <etext+0x58>
    80001306:	00000097          	auipc	ra,0x0
    8000130a:	984080e7          	jalr	-1660(ra) # 80000c8a <panic>

  lk->cpu = 0;
    8000130e:	fe843783          	ld	a5,-24(s0)
    80001312:	0007b823          	sd	zero,16(a5)
  // past this point, to ensure that all the stores in the critical
  // section are visible to other CPUs before the lock is released,
  // and that loads in the critical section occur strictly before
  // the lock is released.
  // On RISC-V, this emits a fence instruction.
  __sync_synchronize();
    80001316:	0330000f          	fence	rw,rw
  // implies that an assignment might be implemented with
  // multiple store instructions.
  // On RISC-V, sync_lock_release turns into an atomic swap:
  //   s1 = &lk->locked
  //   amoswap.w zero, zero, (s1)
  __sync_lock_release(&lk->locked);
    8000131a:	fe843783          	ld	a5,-24(s0)
    8000131e:	0310000f          	fence	rw,w
    80001322:	0007a023          	sw	zero,0(a5)

  pop_off();
    80001326:	00000097          	auipc	ra,0x0
    8000132a:	0ae080e7          	jalr	174(ra) # 800013d4 <pop_off>
}
    8000132e:	0001                	nop
    80001330:	60e2                	ld	ra,24(sp)
    80001332:	6442                	ld	s0,16(sp)
    80001334:	6105                	addi	sp,sp,32
    80001336:	8082                	ret

0000000080001338 <holding>:

// Check whether this cpu is holding the lock.
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
    80001338:	7139                	addi	sp,sp,-64
    8000133a:	fc06                	sd	ra,56(sp)
    8000133c:	f822                	sd	s0,48(sp)
    8000133e:	f426                	sd	s1,40(sp)
    80001340:	0080                	addi	s0,sp,64
    80001342:	fca43423          	sd	a0,-56(s0)
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80001346:	fc843783          	ld	a5,-56(s0)
    8000134a:	439c                	lw	a5,0(a5)
    8000134c:	cf89                	beqz	a5,80001366 <holding+0x2e>
    8000134e:	fc843783          	ld	a5,-56(s0)
    80001352:	6b84                	ld	s1,16(a5)
    80001354:	00001097          	auipc	ra,0x1
    80001358:	4b8080e7          	jalr	1208(ra) # 8000280c <mycpu>
    8000135c:	87aa                	mv	a5,a0
    8000135e:	00f49463          	bne	s1,a5,80001366 <holding+0x2e>
    80001362:	4785                	li	a5,1
    80001364:	a011                	j	80001368 <holding+0x30>
    80001366:	4781                	li	a5,0
    80001368:	fcf42e23          	sw	a5,-36(s0)
  return r;
    8000136c:	fdc42783          	lw	a5,-36(s0)
}
    80001370:	853e                	mv	a0,a5
    80001372:	70e2                	ld	ra,56(sp)
    80001374:	7442                	ld	s0,48(sp)
    80001376:	74a2                	ld	s1,40(sp)
    80001378:	6121                	addi	sp,sp,64
    8000137a:	8082                	ret

000000008000137c <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000137c:	1101                	addi	sp,sp,-32
    8000137e:	ec06                	sd	ra,24(sp)
    80001380:	e822                	sd	s0,16(sp)
    80001382:	1000                	addi	s0,sp,32
  int old = intr_get();
    80001384:	00000097          	auipc	ra,0x0
    80001388:	e9c080e7          	jalr	-356(ra) # 80001220 <intr_get>
    8000138c:	87aa                	mv	a5,a0
    8000138e:	fef42623          	sw	a5,-20(s0)

  intr_off();
    80001392:	00000097          	auipc	ra,0x0
    80001396:	e66080e7          	jalr	-410(ra) # 800011f8 <intr_off>
  if(mycpu()->noff == 0)
    8000139a:	00001097          	auipc	ra,0x1
    8000139e:	472080e7          	jalr	1138(ra) # 8000280c <mycpu>
    800013a2:	87aa                	mv	a5,a0
    800013a4:	5fbc                	lw	a5,120(a5)
    800013a6:	eb89                	bnez	a5,800013b8 <push_off+0x3c>
    mycpu()->intena = old;
    800013a8:	00001097          	auipc	ra,0x1
    800013ac:	464080e7          	jalr	1124(ra) # 8000280c <mycpu>
    800013b0:	872a                	mv	a4,a0
    800013b2:	fec42783          	lw	a5,-20(s0)
    800013b6:	df7c                	sw	a5,124(a4)
  mycpu()->noff += 1;
    800013b8:	00001097          	auipc	ra,0x1
    800013bc:	454080e7          	jalr	1108(ra) # 8000280c <mycpu>
    800013c0:	87aa                	mv	a5,a0
    800013c2:	5fb8                	lw	a4,120(a5)
    800013c4:	2705                	addiw	a4,a4,1
    800013c6:	2701                	sext.w	a4,a4
    800013c8:	dfb8                	sw	a4,120(a5)
}
    800013ca:	0001                	nop
    800013cc:	60e2                	ld	ra,24(sp)
    800013ce:	6442                	ld	s0,16(sp)
    800013d0:	6105                	addi	sp,sp,32
    800013d2:	8082                	ret

00000000800013d4 <pop_off>:

void
pop_off(void)
{
    800013d4:	1101                	addi	sp,sp,-32
    800013d6:	ec06                	sd	ra,24(sp)
    800013d8:	e822                	sd	s0,16(sp)
    800013da:	1000                	addi	s0,sp,32
  struct cpu *c = mycpu();
    800013dc:	00001097          	auipc	ra,0x1
    800013e0:	430080e7          	jalr	1072(ra) # 8000280c <mycpu>
    800013e4:	fea43423          	sd	a0,-24(s0)
  if(intr_get())
    800013e8:	00000097          	auipc	ra,0x0
    800013ec:	e38080e7          	jalr	-456(ra) # 80001220 <intr_get>
    800013f0:	87aa                	mv	a5,a0
    800013f2:	cb89                	beqz	a5,80001404 <pop_off+0x30>
    panic("pop_off - interruptible");
    800013f4:	0000a517          	auipc	a0,0xa
    800013f8:	c6c50513          	addi	a0,a0,-916 # 8000b060 <etext+0x60>
    800013fc:	00000097          	auipc	ra,0x0
    80001400:	88e080e7          	jalr	-1906(ra) # 80000c8a <panic>
  if(c->noff < 1)
    80001404:	fe843783          	ld	a5,-24(s0)
    80001408:	5fbc                	lw	a5,120(a5)
    8000140a:	00f04a63          	bgtz	a5,8000141e <pop_off+0x4a>
    panic("pop_off");
    8000140e:	0000a517          	auipc	a0,0xa
    80001412:	c6a50513          	addi	a0,a0,-918 # 8000b078 <etext+0x78>
    80001416:	00000097          	auipc	ra,0x0
    8000141a:	874080e7          	jalr	-1932(ra) # 80000c8a <panic>
  c->noff -= 1;
    8000141e:	fe843783          	ld	a5,-24(s0)
    80001422:	5fbc                	lw	a5,120(a5)
    80001424:	37fd                	addiw	a5,a5,-1
    80001426:	0007871b          	sext.w	a4,a5
    8000142a:	fe843783          	ld	a5,-24(s0)
    8000142e:	dfb8                	sw	a4,120(a5)
  if(c->noff == 0 && c->intena)
    80001430:	fe843783          	ld	a5,-24(s0)
    80001434:	5fbc                	lw	a5,120(a5)
    80001436:	eb89                	bnez	a5,80001448 <pop_off+0x74>
    80001438:	fe843783          	ld	a5,-24(s0)
    8000143c:	5ffc                	lw	a5,124(a5)
    8000143e:	c789                	beqz	a5,80001448 <pop_off+0x74>
    intr_on();
    80001440:	00000097          	auipc	ra,0x0
    80001444:	d8e080e7          	jalr	-626(ra) # 800011ce <intr_on>
}
    80001448:	0001                	nop
    8000144a:	60e2                	ld	ra,24(sp)
    8000144c:	6442                	ld	s0,16(sp)
    8000144e:	6105                	addi	sp,sp,32
    80001450:	8082                	ret

0000000080001452 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80001452:	7179                	addi	sp,sp,-48
    80001454:	f422                	sd	s0,40(sp)
    80001456:	1800                	addi	s0,sp,48
    80001458:	fca43c23          	sd	a0,-40(s0)
    8000145c:	87ae                	mv	a5,a1
    8000145e:	8732                	mv	a4,a2
    80001460:	fcf42a23          	sw	a5,-44(s0)
    80001464:	87ba                	mv	a5,a4
    80001466:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
    8000146a:	fd843783          	ld	a5,-40(s0)
    8000146e:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
    80001472:	fe042623          	sw	zero,-20(s0)
    80001476:	a00d                	j	80001498 <memset+0x46>
    cdst[i] = c;
    80001478:	fec42783          	lw	a5,-20(s0)
    8000147c:	fe043703          	ld	a4,-32(s0)
    80001480:	97ba                	add	a5,a5,a4
    80001482:	fd442703          	lw	a4,-44(s0)
    80001486:	0ff77713          	zext.b	a4,a4
    8000148a:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
    8000148e:	fec42783          	lw	a5,-20(s0)
    80001492:	2785                	addiw	a5,a5,1
    80001494:	fef42623          	sw	a5,-20(s0)
    80001498:	fec42703          	lw	a4,-20(s0)
    8000149c:	fd042783          	lw	a5,-48(s0)
    800014a0:	2781                	sext.w	a5,a5
    800014a2:	fcf76be3          	bltu	a4,a5,80001478 <memset+0x26>
  }
  return dst;
    800014a6:	fd843783          	ld	a5,-40(s0)
}
    800014aa:	853e                	mv	a0,a5
    800014ac:	7422                	ld	s0,40(sp)
    800014ae:	6145                	addi	sp,sp,48
    800014b0:	8082                	ret

00000000800014b2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800014b2:	7139                	addi	sp,sp,-64
    800014b4:	fc22                	sd	s0,56(sp)
    800014b6:	0080                	addi	s0,sp,64
    800014b8:	fca43c23          	sd	a0,-40(s0)
    800014bc:	fcb43823          	sd	a1,-48(s0)
    800014c0:	87b2                	mv	a5,a2
    800014c2:	fcf42623          	sw	a5,-52(s0)
  const uchar *s1, *s2;

  s1 = v1;
    800014c6:	fd843783          	ld	a5,-40(s0)
    800014ca:	fef43423          	sd	a5,-24(s0)
  s2 = v2;
    800014ce:	fd043783          	ld	a5,-48(s0)
    800014d2:	fef43023          	sd	a5,-32(s0)
  while(n-- > 0){
    800014d6:	a0a1                	j	8000151e <memcmp+0x6c>
    if(*s1 != *s2)
    800014d8:	fe843783          	ld	a5,-24(s0)
    800014dc:	0007c703          	lbu	a4,0(a5)
    800014e0:	fe043783          	ld	a5,-32(s0)
    800014e4:	0007c783          	lbu	a5,0(a5)
    800014e8:	02f70163          	beq	a4,a5,8000150a <memcmp+0x58>
      return *s1 - *s2;
    800014ec:	fe843783          	ld	a5,-24(s0)
    800014f0:	0007c783          	lbu	a5,0(a5)
    800014f4:	0007871b          	sext.w	a4,a5
    800014f8:	fe043783          	ld	a5,-32(s0)
    800014fc:	0007c783          	lbu	a5,0(a5)
    80001500:	2781                	sext.w	a5,a5
    80001502:	40f707bb          	subw	a5,a4,a5
    80001506:	2781                	sext.w	a5,a5
    80001508:	a01d                	j	8000152e <memcmp+0x7c>
    s1++, s2++;
    8000150a:	fe843783          	ld	a5,-24(s0)
    8000150e:	0785                	addi	a5,a5,1
    80001510:	fef43423          	sd	a5,-24(s0)
    80001514:	fe043783          	ld	a5,-32(s0)
    80001518:	0785                	addi	a5,a5,1
    8000151a:	fef43023          	sd	a5,-32(s0)
  while(n-- > 0){
    8000151e:	fcc42783          	lw	a5,-52(s0)
    80001522:	fff7871b          	addiw	a4,a5,-1
    80001526:	fce42623          	sw	a4,-52(s0)
    8000152a:	f7dd                	bnez	a5,800014d8 <memcmp+0x26>
  }

  return 0;
    8000152c:	4781                	li	a5,0
}
    8000152e:	853e                	mv	a0,a5
    80001530:	7462                	ld	s0,56(sp)
    80001532:	6121                	addi	sp,sp,64
    80001534:	8082                	ret

0000000080001536 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80001536:	7139                	addi	sp,sp,-64
    80001538:	fc22                	sd	s0,56(sp)
    8000153a:	0080                	addi	s0,sp,64
    8000153c:	fca43c23          	sd	a0,-40(s0)
    80001540:	fcb43823          	sd	a1,-48(s0)
    80001544:	87b2                	mv	a5,a2
    80001546:	fcf42623          	sw	a5,-52(s0)
  const char *s;
  char *d;

  if(n == 0)
    8000154a:	fcc42783          	lw	a5,-52(s0)
    8000154e:	2781                	sext.w	a5,a5
    80001550:	e781                	bnez	a5,80001558 <memmove+0x22>
    return dst;
    80001552:	fd843783          	ld	a5,-40(s0)
    80001556:	a855                	j	8000160a <memmove+0xd4>
  
  s = src;
    80001558:	fd043783          	ld	a5,-48(s0)
    8000155c:	fef43423          	sd	a5,-24(s0)
  d = dst;
    80001560:	fd843783          	ld	a5,-40(s0)
    80001564:	fef43023          	sd	a5,-32(s0)
  if(s < d && s + n > d){
    80001568:	fe843703          	ld	a4,-24(s0)
    8000156c:	fe043783          	ld	a5,-32(s0)
    80001570:	08f77463          	bgeu	a4,a5,800015f8 <memmove+0xc2>
    80001574:	fcc46783          	lwu	a5,-52(s0)
    80001578:	fe843703          	ld	a4,-24(s0)
    8000157c:	97ba                	add	a5,a5,a4
    8000157e:	fe043703          	ld	a4,-32(s0)
    80001582:	06f77b63          	bgeu	a4,a5,800015f8 <memmove+0xc2>
    s += n;
    80001586:	fcc46783          	lwu	a5,-52(s0)
    8000158a:	fe843703          	ld	a4,-24(s0)
    8000158e:	97ba                	add	a5,a5,a4
    80001590:	fef43423          	sd	a5,-24(s0)
    d += n;
    80001594:	fcc46783          	lwu	a5,-52(s0)
    80001598:	fe043703          	ld	a4,-32(s0)
    8000159c:	97ba                	add	a5,a5,a4
    8000159e:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
    800015a2:	a01d                	j	800015c8 <memmove+0x92>
      *--d = *--s;
    800015a4:	fe843783          	ld	a5,-24(s0)
    800015a8:	17fd                	addi	a5,a5,-1
    800015aa:	fef43423          	sd	a5,-24(s0)
    800015ae:	fe043783          	ld	a5,-32(s0)
    800015b2:	17fd                	addi	a5,a5,-1
    800015b4:	fef43023          	sd	a5,-32(s0)
    800015b8:	fe843783          	ld	a5,-24(s0)
    800015bc:	0007c703          	lbu	a4,0(a5)
    800015c0:	fe043783          	ld	a5,-32(s0)
    800015c4:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
    800015c8:	fcc42783          	lw	a5,-52(s0)
    800015cc:	fff7871b          	addiw	a4,a5,-1
    800015d0:	fce42623          	sw	a4,-52(s0)
    800015d4:	fbe1                	bnez	a5,800015a4 <memmove+0x6e>
  if(s < d && s + n > d){
    800015d6:	a805                	j	80001606 <memmove+0xd0>
  } else
    while(n-- > 0)
      *d++ = *s++;
    800015d8:	fe843703          	ld	a4,-24(s0)
    800015dc:	00170793          	addi	a5,a4,1
    800015e0:	fef43423          	sd	a5,-24(s0)
    800015e4:	fe043783          	ld	a5,-32(s0)
    800015e8:	00178693          	addi	a3,a5,1
    800015ec:	fed43023          	sd	a3,-32(s0)
    800015f0:	00074703          	lbu	a4,0(a4)
    800015f4:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
    800015f8:	fcc42783          	lw	a5,-52(s0)
    800015fc:	fff7871b          	addiw	a4,a5,-1
    80001600:	fce42623          	sw	a4,-52(s0)
    80001604:	fbf1                	bnez	a5,800015d8 <memmove+0xa2>

  return dst;
    80001606:	fd843783          	ld	a5,-40(s0)
}
    8000160a:	853e                	mv	a0,a5
    8000160c:	7462                	ld	s0,56(sp)
    8000160e:	6121                	addi	sp,sp,64
    80001610:	8082                	ret

0000000080001612 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80001612:	7179                	addi	sp,sp,-48
    80001614:	f406                	sd	ra,40(sp)
    80001616:	f022                	sd	s0,32(sp)
    80001618:	1800                	addi	s0,sp,48
    8000161a:	fea43423          	sd	a0,-24(s0)
    8000161e:	feb43023          	sd	a1,-32(s0)
    80001622:	87b2                	mv	a5,a2
    80001624:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
    80001628:	fdc42783          	lw	a5,-36(s0)
    8000162c:	863e                	mv	a2,a5
    8000162e:	fe043583          	ld	a1,-32(s0)
    80001632:	fe843503          	ld	a0,-24(s0)
    80001636:	00000097          	auipc	ra,0x0
    8000163a:	f00080e7          	jalr	-256(ra) # 80001536 <memmove>
    8000163e:	87aa                	mv	a5,a0
}
    80001640:	853e                	mv	a0,a5
    80001642:	70a2                	ld	ra,40(sp)
    80001644:	7402                	ld	s0,32(sp)
    80001646:	6145                	addi	sp,sp,48
    80001648:	8082                	ret

000000008000164a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000164a:	7179                	addi	sp,sp,-48
    8000164c:	f422                	sd	s0,40(sp)
    8000164e:	1800                	addi	s0,sp,48
    80001650:	fea43423          	sd	a0,-24(s0)
    80001654:	feb43023          	sd	a1,-32(s0)
    80001658:	87b2                	mv	a5,a2
    8000165a:	fcf42e23          	sw	a5,-36(s0)
  while(n > 0 && *p && *p == *q)
    8000165e:	a005                	j	8000167e <strncmp+0x34>
    n--, p++, q++;
    80001660:	fdc42783          	lw	a5,-36(s0)
    80001664:	37fd                	addiw	a5,a5,-1
    80001666:	fcf42e23          	sw	a5,-36(s0)
    8000166a:	fe843783          	ld	a5,-24(s0)
    8000166e:	0785                	addi	a5,a5,1
    80001670:	fef43423          	sd	a5,-24(s0)
    80001674:	fe043783          	ld	a5,-32(s0)
    80001678:	0785                	addi	a5,a5,1
    8000167a:	fef43023          	sd	a5,-32(s0)
  while(n > 0 && *p && *p == *q)
    8000167e:	fdc42783          	lw	a5,-36(s0)
    80001682:	2781                	sext.w	a5,a5
    80001684:	c385                	beqz	a5,800016a4 <strncmp+0x5a>
    80001686:	fe843783          	ld	a5,-24(s0)
    8000168a:	0007c783          	lbu	a5,0(a5)
    8000168e:	cb99                	beqz	a5,800016a4 <strncmp+0x5a>
    80001690:	fe843783          	ld	a5,-24(s0)
    80001694:	0007c703          	lbu	a4,0(a5)
    80001698:	fe043783          	ld	a5,-32(s0)
    8000169c:	0007c783          	lbu	a5,0(a5)
    800016a0:	fcf700e3          	beq	a4,a5,80001660 <strncmp+0x16>
  if(n == 0)
    800016a4:	fdc42783          	lw	a5,-36(s0)
    800016a8:	2781                	sext.w	a5,a5
    800016aa:	e399                	bnez	a5,800016b0 <strncmp+0x66>
    return 0;
    800016ac:	4781                	li	a5,0
    800016ae:	a839                	j	800016cc <strncmp+0x82>
  return (uchar)*p - (uchar)*q;
    800016b0:	fe843783          	ld	a5,-24(s0)
    800016b4:	0007c783          	lbu	a5,0(a5)
    800016b8:	0007871b          	sext.w	a4,a5
    800016bc:	fe043783          	ld	a5,-32(s0)
    800016c0:	0007c783          	lbu	a5,0(a5)
    800016c4:	2781                	sext.w	a5,a5
    800016c6:	40f707bb          	subw	a5,a4,a5
    800016ca:	2781                	sext.w	a5,a5
}
    800016cc:	853e                	mv	a0,a5
    800016ce:	7422                	ld	s0,40(sp)
    800016d0:	6145                	addi	sp,sp,48
    800016d2:	8082                	ret

00000000800016d4 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800016d4:	7139                	addi	sp,sp,-64
    800016d6:	fc22                	sd	s0,56(sp)
    800016d8:	0080                	addi	s0,sp,64
    800016da:	fca43c23          	sd	a0,-40(s0)
    800016de:	fcb43823          	sd	a1,-48(s0)
    800016e2:	87b2                	mv	a5,a2
    800016e4:	fcf42623          	sw	a5,-52(s0)
  char *os;

  os = s;
    800016e8:	fd843783          	ld	a5,-40(s0)
    800016ec:	fef43423          	sd	a5,-24(s0)
  while(n-- > 0 && (*s++ = *t++) != 0)
    800016f0:	0001                	nop
    800016f2:	fcc42783          	lw	a5,-52(s0)
    800016f6:	fff7871b          	addiw	a4,a5,-1
    800016fa:	fce42623          	sw	a4,-52(s0)
    800016fe:	02f05e63          	blez	a5,8000173a <strncpy+0x66>
    80001702:	fd043703          	ld	a4,-48(s0)
    80001706:	00170793          	addi	a5,a4,1
    8000170a:	fcf43823          	sd	a5,-48(s0)
    8000170e:	fd843783          	ld	a5,-40(s0)
    80001712:	00178693          	addi	a3,a5,1
    80001716:	fcd43c23          	sd	a3,-40(s0)
    8000171a:	00074703          	lbu	a4,0(a4)
    8000171e:	00e78023          	sb	a4,0(a5)
    80001722:	0007c783          	lbu	a5,0(a5)
    80001726:	f7f1                	bnez	a5,800016f2 <strncpy+0x1e>
    ;
  while(n-- > 0)
    80001728:	a809                	j	8000173a <strncpy+0x66>
    *s++ = 0;
    8000172a:	fd843783          	ld	a5,-40(s0)
    8000172e:	00178713          	addi	a4,a5,1
    80001732:	fce43c23          	sd	a4,-40(s0)
    80001736:	00078023          	sb	zero,0(a5)
  while(n-- > 0)
    8000173a:	fcc42783          	lw	a5,-52(s0)
    8000173e:	fff7871b          	addiw	a4,a5,-1
    80001742:	fce42623          	sw	a4,-52(s0)
    80001746:	fef042e3          	bgtz	a5,8000172a <strncpy+0x56>
  return os;
    8000174a:	fe843783          	ld	a5,-24(s0)
}
    8000174e:	853e                	mv	a0,a5
    80001750:	7462                	ld	s0,56(sp)
    80001752:	6121                	addi	sp,sp,64
    80001754:	8082                	ret

0000000080001756 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80001756:	7139                	addi	sp,sp,-64
    80001758:	fc22                	sd	s0,56(sp)
    8000175a:	0080                	addi	s0,sp,64
    8000175c:	fca43c23          	sd	a0,-40(s0)
    80001760:	fcb43823          	sd	a1,-48(s0)
    80001764:	87b2                	mv	a5,a2
    80001766:	fcf42623          	sw	a5,-52(s0)
  char *os;

  os = s;
    8000176a:	fd843783          	ld	a5,-40(s0)
    8000176e:	fef43423          	sd	a5,-24(s0)
  if(n <= 0)
    80001772:	fcc42783          	lw	a5,-52(s0)
    80001776:	2781                	sext.w	a5,a5
    80001778:	00f04563          	bgtz	a5,80001782 <safestrcpy+0x2c>
    return os;
    8000177c:	fe843783          	ld	a5,-24(s0)
    80001780:	a0a9                	j	800017ca <safestrcpy+0x74>
  while(--n > 0 && (*s++ = *t++) != 0)
    80001782:	0001                	nop
    80001784:	fcc42783          	lw	a5,-52(s0)
    80001788:	37fd                	addiw	a5,a5,-1
    8000178a:	fcf42623          	sw	a5,-52(s0)
    8000178e:	fcc42783          	lw	a5,-52(s0)
    80001792:	2781                	sext.w	a5,a5
    80001794:	02f05563          	blez	a5,800017be <safestrcpy+0x68>
    80001798:	fd043703          	ld	a4,-48(s0)
    8000179c:	00170793          	addi	a5,a4,1
    800017a0:	fcf43823          	sd	a5,-48(s0)
    800017a4:	fd843783          	ld	a5,-40(s0)
    800017a8:	00178693          	addi	a3,a5,1
    800017ac:	fcd43c23          	sd	a3,-40(s0)
    800017b0:	00074703          	lbu	a4,0(a4)
    800017b4:	00e78023          	sb	a4,0(a5)
    800017b8:	0007c783          	lbu	a5,0(a5)
    800017bc:	f7e1                	bnez	a5,80001784 <safestrcpy+0x2e>
    ;
  *s = 0;
    800017be:	fd843783          	ld	a5,-40(s0)
    800017c2:	00078023          	sb	zero,0(a5)
  return os;
    800017c6:	fe843783          	ld	a5,-24(s0)
}
    800017ca:	853e                	mv	a0,a5
    800017cc:	7462                	ld	s0,56(sp)
    800017ce:	6121                	addi	sp,sp,64
    800017d0:	8082                	ret

00000000800017d2 <strlen>:

int
strlen(const char *s)
{
    800017d2:	7179                	addi	sp,sp,-48
    800017d4:	f422                	sd	s0,40(sp)
    800017d6:	1800                	addi	s0,sp,48
    800017d8:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
    800017dc:	fe042623          	sw	zero,-20(s0)
    800017e0:	a031                	j	800017ec <strlen+0x1a>
    800017e2:	fec42783          	lw	a5,-20(s0)
    800017e6:	2785                	addiw	a5,a5,1
    800017e8:	fef42623          	sw	a5,-20(s0)
    800017ec:	fec42783          	lw	a5,-20(s0)
    800017f0:	fd843703          	ld	a4,-40(s0)
    800017f4:	97ba                	add	a5,a5,a4
    800017f6:	0007c783          	lbu	a5,0(a5)
    800017fa:	f7e5                	bnez	a5,800017e2 <strlen+0x10>
    ;
  return n;
    800017fc:	fec42783          	lw	a5,-20(s0)
}
    80001800:	853e                	mv	a0,a5
    80001802:	7422                	ld	s0,40(sp)
    80001804:	6145                	addi	sp,sp,48
    80001806:	8082                	ret

0000000080001808 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80001808:	1141                	addi	sp,sp,-16
    8000180a:	e406                	sd	ra,8(sp)
    8000180c:	e022                	sd	s0,0(sp)
    8000180e:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80001810:	00001097          	auipc	ra,0x1
    80001814:	fd8080e7          	jalr	-40(ra) # 800027e8 <cpuid>
    80001818:	87aa                	mv	a5,a0
    8000181a:	efd5                	bnez	a5,800018d6 <main+0xce>
    consoleinit();
    8000181c:	fffff097          	auipc	ra,0xfffff
    80001820:	048080e7          	jalr	72(ra) # 80000864 <consoleinit>
    printfinit();
    80001824:	fffff097          	auipc	ra,0xfffff
    80001828:	4ba080e7          	jalr	1210(ra) # 80000cde <printfinit>
    printf("\n");
    8000182c:	0000a517          	auipc	a0,0xa
    80001830:	85450513          	addi	a0,a0,-1964 # 8000b080 <etext+0x80>
    80001834:	fffff097          	auipc	ra,0xfffff
    80001838:	200080e7          	jalr	512(ra) # 80000a34 <printf>
    printf("xv6 kernel is booting\n");
    8000183c:	0000a517          	auipc	a0,0xa
    80001840:	84c50513          	addi	a0,a0,-1972 # 8000b088 <etext+0x88>
    80001844:	fffff097          	auipc	ra,0xfffff
    80001848:	1f0080e7          	jalr	496(ra) # 80000a34 <printf>
    printf("\n");
    8000184c:	0000a517          	auipc	a0,0xa
    80001850:	83450513          	addi	a0,a0,-1996 # 8000b080 <etext+0x80>
    80001854:	fffff097          	auipc	ra,0xfffff
    80001858:	1e0080e7          	jalr	480(ra) # 80000a34 <printf>
    kinit();         // physical page allocator
    8000185c:	fffff097          	auipc	ra,0xfffff
    80001860:	792080e7          	jalr	1938(ra) # 80000fee <kinit>
    kvminit();       // create kernel page table
    80001864:	00000097          	auipc	ra,0x0
    80001868:	1f4080e7          	jalr	500(ra) # 80001a58 <kvminit>
    kvminithart();   // turn on paging
    8000186c:	00000097          	auipc	ra,0x0
    80001870:	212080e7          	jalr	530(ra) # 80001a7e <kvminithart>
    procinit();      // process table
    80001874:	00001097          	auipc	ra,0x1
    80001878:	ea6080e7          	jalr	-346(ra) # 8000271a <procinit>
    trapinit();      // trap vectors
    8000187c:	00002097          	auipc	ra,0x2
    80001880:	1f6080e7          	jalr	502(ra) # 80003a72 <trapinit>
    trapinithart();  // install kernel trap vector
    80001884:	00002097          	auipc	ra,0x2
    80001888:	218080e7          	jalr	536(ra) # 80003a9c <trapinithart>
    plicinit();      // set up interrupt controller
    8000188c:	00007097          	auipc	ra,0x7
    80001890:	03e080e7          	jalr	62(ra) # 800088ca <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80001894:	00007097          	auipc	ra,0x7
    80001898:	05a080e7          	jalr	90(ra) # 800088ee <plicinithart>
    binit();         // buffer cache
    8000189c:	00003097          	auipc	ra,0x3
    800018a0:	c10080e7          	jalr	-1008(ra) # 800044ac <binit>
    iinit();         // inode table
    800018a4:	00003097          	auipc	ra,0x3
    800018a8:	446080e7          	jalr	1094(ra) # 80004cea <iinit>
    fileinit();      // file table
    800018ac:	00005097          	auipc	ra,0x5
    800018b0:	e24080e7          	jalr	-476(ra) # 800066d0 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800018b4:	00007097          	auipc	ra,0x7
    800018b8:	10e080e7          	jalr	270(ra) # 800089c2 <virtio_disk_init>
    userinit();      // first user process
    800018bc:	00001097          	auipc	ra,0x1
    800018c0:	30a080e7          	jalr	778(ra) # 80002bc6 <userinit>
    __sync_synchronize();
    800018c4:	0330000f          	fence	rw,rw
    started = 1;
    800018c8:	00015797          	auipc	a5,0x15
    800018cc:	83878793          	addi	a5,a5,-1992 # 80016100 <started>
    800018d0:	4705                	li	a4,1
    800018d2:	c398                	sw	a4,0(a5)
    800018d4:	a0a9                	j	8000191e <main+0x116>
  } else {
    while(started == 0)
    800018d6:	0001                	nop
    800018d8:	00015797          	auipc	a5,0x15
    800018dc:	82878793          	addi	a5,a5,-2008 # 80016100 <started>
    800018e0:	439c                	lw	a5,0(a5)
    800018e2:	2781                	sext.w	a5,a5
    800018e4:	dbf5                	beqz	a5,800018d8 <main+0xd0>
      ;
    __sync_synchronize();
    800018e6:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    800018ea:	00001097          	auipc	ra,0x1
    800018ee:	efe080e7          	jalr	-258(ra) # 800027e8 <cpuid>
    800018f2:	87aa                	mv	a5,a0
    800018f4:	85be                	mv	a1,a5
    800018f6:	00009517          	auipc	a0,0x9
    800018fa:	7aa50513          	addi	a0,a0,1962 # 8000b0a0 <etext+0xa0>
    800018fe:	fffff097          	auipc	ra,0xfffff
    80001902:	136080e7          	jalr	310(ra) # 80000a34 <printf>
    kvminithart();    // turn on paging
    80001906:	00000097          	auipc	ra,0x0
    8000190a:	178080e7          	jalr	376(ra) # 80001a7e <kvminithart>
    trapinithart();   // install kernel trap vector
    8000190e:	00002097          	auipc	ra,0x2
    80001912:	18e080e7          	jalr	398(ra) # 80003a9c <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80001916:	00007097          	auipc	ra,0x7
    8000191a:	fd8080e7          	jalr	-40(ra) # 800088ee <plicinithart>
  }

  scheduler();        
    8000191e:	00002097          	auipc	ra,0x2
    80001922:	8be080e7          	jalr	-1858(ra) # 800031dc <scheduler>

0000000080001926 <w_satp>:
{
    80001926:	1101                	addi	sp,sp,-32
    80001928:	ec22                	sd	s0,24(sp)
    8000192a:	1000                	addi	s0,sp,32
    8000192c:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw satp, %0" : : "r" (x));
    80001930:	fe843783          	ld	a5,-24(s0)
    80001934:	18079073          	csrw	satp,a5
}
    80001938:	0001                	nop
    8000193a:	6462                	ld	s0,24(sp)
    8000193c:	6105                	addi	sp,sp,32
    8000193e:	8082                	ret

0000000080001940 <sfence_vma>:
}

// flush the TLB.
static inline void
sfence_vma()
{
    80001940:	1141                	addi	sp,sp,-16
    80001942:	e422                	sd	s0,8(sp)
    80001944:	0800                	addi	s0,sp,16
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80001946:	12000073          	sfence.vma
}
    8000194a:	0001                	nop
    8000194c:	6422                	ld	s0,8(sp)
    8000194e:	0141                	addi	sp,sp,16
    80001950:	8082                	ret

0000000080001952 <kvmmake>:
extern char trampoline[]; // trampoline.S

// Make a direct-map page table for the kernel.
pagetable_t
kvmmake(void)
{
    80001952:	1101                	addi	sp,sp,-32
    80001954:	ec06                	sd	ra,24(sp)
    80001956:	e822                	sd	s0,16(sp)
    80001958:	1000                	addi	s0,sp,32
  pagetable_t kpgtbl;

  kpgtbl = (pagetable_t) kalloc();
    8000195a:	fffff097          	auipc	ra,0xfffff
    8000195e:	7d0080e7          	jalr	2000(ra) # 8000112a <kalloc>
    80001962:	fea43423          	sd	a0,-24(s0)
  memset(kpgtbl, 0, PGSIZE);
    80001966:	6605                	lui	a2,0x1
    80001968:	4581                	li	a1,0
    8000196a:	fe843503          	ld	a0,-24(s0)
    8000196e:	00000097          	auipc	ra,0x0
    80001972:	ae4080e7          	jalr	-1308(ra) # 80001452 <memset>

  // uart registers
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001976:	4719                	li	a4,6
    80001978:	6685                	lui	a3,0x1
    8000197a:	10000637          	lui	a2,0x10000
    8000197e:	100005b7          	lui	a1,0x10000
    80001982:	fe843503          	ld	a0,-24(s0)
    80001986:	00000097          	auipc	ra,0x0
    8000198a:	2a2080e7          	jalr	674(ra) # 80001c28 <kvmmap>

  // virtio mmio disk interface
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000198e:	4719                	li	a4,6
    80001990:	6685                	lui	a3,0x1
    80001992:	10001637          	lui	a2,0x10001
    80001996:	100015b7          	lui	a1,0x10001
    8000199a:	fe843503          	ld	a0,-24(s0)
    8000199e:	00000097          	auipc	ra,0x0
    800019a2:	28a080e7          	jalr	650(ra) # 80001c28 <kvmmap>

  // PLIC
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800019a6:	4719                	li	a4,6
    800019a8:	004006b7          	lui	a3,0x400
    800019ac:	0c000637          	lui	a2,0xc000
    800019b0:	0c0005b7          	lui	a1,0xc000
    800019b4:	fe843503          	ld	a0,-24(s0)
    800019b8:	00000097          	auipc	ra,0x0
    800019bc:	270080e7          	jalr	624(ra) # 80001c28 <kvmmap>

  // map kernel text executable and read-only.
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800019c0:	00009717          	auipc	a4,0x9
    800019c4:	64070713          	addi	a4,a4,1600 # 8000b000 <etext>
    800019c8:	800007b7          	lui	a5,0x80000
    800019cc:	97ba                	add	a5,a5,a4
    800019ce:	4729                	li	a4,10
    800019d0:	86be                	mv	a3,a5
    800019d2:	4785                	li	a5,1
    800019d4:	01f79613          	slli	a2,a5,0x1f
    800019d8:	4785                	li	a5,1
    800019da:	01f79593          	slli	a1,a5,0x1f
    800019de:	fe843503          	ld	a0,-24(s0)
    800019e2:	00000097          	auipc	ra,0x0
    800019e6:	246080e7          	jalr	582(ra) # 80001c28 <kvmmap>

  // map kernel data and the physical RAM we'll make use of.
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800019ea:	00009597          	auipc	a1,0x9
    800019ee:	61658593          	addi	a1,a1,1558 # 8000b000 <etext>
    800019f2:	00009617          	auipc	a2,0x9
    800019f6:	60e60613          	addi	a2,a2,1550 # 8000b000 <etext>
    800019fa:	00009797          	auipc	a5,0x9
    800019fe:	60678793          	addi	a5,a5,1542 # 8000b000 <etext>
    80001a02:	4745                	li	a4,17
    80001a04:	076e                	slli	a4,a4,0x1b
    80001a06:	40f707b3          	sub	a5,a4,a5
    80001a0a:	4719                	li	a4,6
    80001a0c:	86be                	mv	a3,a5
    80001a0e:	fe843503          	ld	a0,-24(s0)
    80001a12:	00000097          	auipc	ra,0x0
    80001a16:	216080e7          	jalr	534(ra) # 80001c28 <kvmmap>

  // map the trampoline for trap entry/exit to
  // the highest virtual address in the kernel.
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001a1a:	00008797          	auipc	a5,0x8
    80001a1e:	5e678793          	addi	a5,a5,1510 # 8000a000 <_trampoline>
    80001a22:	4729                	li	a4,10
    80001a24:	6685                	lui	a3,0x1
    80001a26:	863e                	mv	a2,a5
    80001a28:	040007b7          	lui	a5,0x4000
    80001a2c:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001a2e:	00c79593          	slli	a1,a5,0xc
    80001a32:	fe843503          	ld	a0,-24(s0)
    80001a36:	00000097          	auipc	ra,0x0
    80001a3a:	1f2080e7          	jalr	498(ra) # 80001c28 <kvmmap>

  // allocate and map a kernel stack for each process.
  proc_mapstacks(kpgtbl);
    80001a3e:	fe843503          	ld	a0,-24(s0)
    80001a42:	00001097          	auipc	ra,0x1
    80001a46:	c1c080e7          	jalr	-996(ra) # 8000265e <proc_mapstacks>
  
  return kpgtbl;
    80001a4a:	fe843783          	ld	a5,-24(s0)
}
    80001a4e:	853e                	mv	a0,a5
    80001a50:	60e2                	ld	ra,24(sp)
    80001a52:	6442                	ld	s0,16(sp)
    80001a54:	6105                	addi	sp,sp,32
    80001a56:	8082                	ret

0000000080001a58 <kvminit>:

// Initialize the one kernel_pagetable
void
kvminit(void)
{
    80001a58:	1141                	addi	sp,sp,-16
    80001a5a:	e406                	sd	ra,8(sp)
    80001a5c:	e022                	sd	s0,0(sp)
    80001a5e:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80001a60:	00000097          	auipc	ra,0x0
    80001a64:	ef2080e7          	jalr	-270(ra) # 80001952 <kvmmake>
    80001a68:	872a                	mv	a4,a0
    80001a6a:	0000c797          	auipc	a5,0xc
    80001a6e:	41e78793          	addi	a5,a5,1054 # 8000de88 <kernel_pagetable>
    80001a72:	e398                	sd	a4,0(a5)
}
    80001a74:	0001                	nop
    80001a76:	60a2                	ld	ra,8(sp)
    80001a78:	6402                	ld	s0,0(sp)
    80001a7a:	0141                	addi	sp,sp,16
    80001a7c:	8082                	ret

0000000080001a7e <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80001a7e:	1141                	addi	sp,sp,-16
    80001a80:	e406                	sd	ra,8(sp)
    80001a82:	e022                	sd	s0,0(sp)
    80001a84:	0800                	addi	s0,sp,16
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();
    80001a86:	00000097          	auipc	ra,0x0
    80001a8a:	eba080e7          	jalr	-326(ra) # 80001940 <sfence_vma>

  w_satp(MAKE_SATP(kernel_pagetable));
    80001a8e:	0000c797          	auipc	a5,0xc
    80001a92:	3fa78793          	addi	a5,a5,1018 # 8000de88 <kernel_pagetable>
    80001a96:	639c                	ld	a5,0(a5)
    80001a98:	00c7d713          	srli	a4,a5,0xc
    80001a9c:	57fd                	li	a5,-1
    80001a9e:	17fe                	slli	a5,a5,0x3f
    80001aa0:	8fd9                	or	a5,a5,a4
    80001aa2:	853e                	mv	a0,a5
    80001aa4:	00000097          	auipc	ra,0x0
    80001aa8:	e82080e7          	jalr	-382(ra) # 80001926 <w_satp>

  // flush stale entries from the TLB.
  sfence_vma();
    80001aac:	00000097          	auipc	ra,0x0
    80001ab0:	e94080e7          	jalr	-364(ra) # 80001940 <sfence_vma>
}
    80001ab4:	0001                	nop
    80001ab6:	60a2                	ld	ra,8(sp)
    80001ab8:	6402                	ld	s0,0(sp)
    80001aba:	0141                	addi	sp,sp,16
    80001abc:	8082                	ret

0000000080001abe <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80001abe:	7139                	addi	sp,sp,-64
    80001ac0:	fc06                	sd	ra,56(sp)
    80001ac2:	f822                	sd	s0,48(sp)
    80001ac4:	0080                	addi	s0,sp,64
    80001ac6:	fca43c23          	sd	a0,-40(s0)
    80001aca:	fcb43823          	sd	a1,-48(s0)
    80001ace:	87b2                	mv	a5,a2
    80001ad0:	fcf42623          	sw	a5,-52(s0)
  if(va >= MAXVA)
    80001ad4:	fd043703          	ld	a4,-48(s0)
    80001ad8:	57fd                	li	a5,-1
    80001ada:	83e9                	srli	a5,a5,0x1a
    80001adc:	00e7fa63          	bgeu	a5,a4,80001af0 <walk+0x32>
    panic("walk");
    80001ae0:	00009517          	auipc	a0,0x9
    80001ae4:	5d850513          	addi	a0,a0,1496 # 8000b0b8 <etext+0xb8>
    80001ae8:	fffff097          	auipc	ra,0xfffff
    80001aec:	1a2080e7          	jalr	418(ra) # 80000c8a <panic>

  for(int level = 2; level > 0; level--) {
    80001af0:	4789                	li	a5,2
    80001af2:	fef42623          	sw	a5,-20(s0)
    80001af6:	a851                	j	80001b8a <walk+0xcc>
    pte_t *pte = &pagetable[PX(level, va)];
    80001af8:	fec42783          	lw	a5,-20(s0)
    80001afc:	873e                	mv	a4,a5
    80001afe:	87ba                	mv	a5,a4
    80001b00:	0037979b          	slliw	a5,a5,0x3
    80001b04:	9fb9                	addw	a5,a5,a4
    80001b06:	2781                	sext.w	a5,a5
    80001b08:	27b1                	addiw	a5,a5,12
    80001b0a:	2781                	sext.w	a5,a5
    80001b0c:	873e                	mv	a4,a5
    80001b0e:	fd043783          	ld	a5,-48(s0)
    80001b12:	00e7d7b3          	srl	a5,a5,a4
    80001b16:	1ff7f793          	andi	a5,a5,511
    80001b1a:	078e                	slli	a5,a5,0x3
    80001b1c:	fd843703          	ld	a4,-40(s0)
    80001b20:	97ba                	add	a5,a5,a4
    80001b22:	fef43023          	sd	a5,-32(s0)
    if(*pte & PTE_V) {
    80001b26:	fe043783          	ld	a5,-32(s0)
    80001b2a:	639c                	ld	a5,0(a5)
    80001b2c:	8b85                	andi	a5,a5,1
    80001b2e:	cb89                	beqz	a5,80001b40 <walk+0x82>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001b30:	fe043783          	ld	a5,-32(s0)
    80001b34:	639c                	ld	a5,0(a5)
    80001b36:	83a9                	srli	a5,a5,0xa
    80001b38:	07b2                	slli	a5,a5,0xc
    80001b3a:	fcf43c23          	sd	a5,-40(s0)
    80001b3e:	a089                	j	80001b80 <walk+0xc2>
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001b40:	fcc42783          	lw	a5,-52(s0)
    80001b44:	2781                	sext.w	a5,a5
    80001b46:	cb91                	beqz	a5,80001b5a <walk+0x9c>
    80001b48:	fffff097          	auipc	ra,0xfffff
    80001b4c:	5e2080e7          	jalr	1506(ra) # 8000112a <kalloc>
    80001b50:	fca43c23          	sd	a0,-40(s0)
    80001b54:	fd843783          	ld	a5,-40(s0)
    80001b58:	e399                	bnez	a5,80001b5e <walk+0xa0>
        return 0;
    80001b5a:	4781                	li	a5,0
    80001b5c:	a0a9                	j	80001ba6 <walk+0xe8>
      memset(pagetable, 0, PGSIZE);
    80001b5e:	6605                	lui	a2,0x1
    80001b60:	4581                	li	a1,0
    80001b62:	fd843503          	ld	a0,-40(s0)
    80001b66:	00000097          	auipc	ra,0x0
    80001b6a:	8ec080e7          	jalr	-1812(ra) # 80001452 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001b6e:	fd843783          	ld	a5,-40(s0)
    80001b72:	83b1                	srli	a5,a5,0xc
    80001b74:	07aa                	slli	a5,a5,0xa
    80001b76:	0017e713          	ori	a4,a5,1
    80001b7a:	fe043783          	ld	a5,-32(s0)
    80001b7e:	e398                	sd	a4,0(a5)
  for(int level = 2; level > 0; level--) {
    80001b80:	fec42783          	lw	a5,-20(s0)
    80001b84:	37fd                	addiw	a5,a5,-1
    80001b86:	fef42623          	sw	a5,-20(s0)
    80001b8a:	fec42783          	lw	a5,-20(s0)
    80001b8e:	2781                	sext.w	a5,a5
    80001b90:	f6f044e3          	bgtz	a5,80001af8 <walk+0x3a>
    }
  }
  return &pagetable[PX(0, va)];
    80001b94:	fd043783          	ld	a5,-48(s0)
    80001b98:	83b1                	srli	a5,a5,0xc
    80001b9a:	1ff7f793          	andi	a5,a5,511
    80001b9e:	078e                	slli	a5,a5,0x3
    80001ba0:	fd843703          	ld	a4,-40(s0)
    80001ba4:	97ba                	add	a5,a5,a4
}
    80001ba6:	853e                	mv	a0,a5
    80001ba8:	70e2                	ld	ra,56(sp)
    80001baa:	7442                	ld	s0,48(sp)
    80001bac:	6121                	addi	sp,sp,64
    80001bae:	8082                	ret

0000000080001bb0 <walkaddr>:
// Look up a virtual address, return the physical address,
// or 0 if not mapped.
// Can only be used to look up user pages.
uint64
walkaddr(pagetable_t pagetable, uint64 va)
{
    80001bb0:	7179                	addi	sp,sp,-48
    80001bb2:	f406                	sd	ra,40(sp)
    80001bb4:	f022                	sd	s0,32(sp)
    80001bb6:	1800                	addi	s0,sp,48
    80001bb8:	fca43c23          	sd	a0,-40(s0)
    80001bbc:	fcb43823          	sd	a1,-48(s0)
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80001bc0:	fd043703          	ld	a4,-48(s0)
    80001bc4:	57fd                	li	a5,-1
    80001bc6:	83e9                	srli	a5,a5,0x1a
    80001bc8:	00e7f463          	bgeu	a5,a4,80001bd0 <walkaddr+0x20>
    return 0;
    80001bcc:	4781                	li	a5,0
    80001bce:	a881                	j	80001c1e <walkaddr+0x6e>

  pte = walk(pagetable, va, 0);
    80001bd0:	4601                	li	a2,0
    80001bd2:	fd043583          	ld	a1,-48(s0)
    80001bd6:	fd843503          	ld	a0,-40(s0)
    80001bda:	00000097          	auipc	ra,0x0
    80001bde:	ee4080e7          	jalr	-284(ra) # 80001abe <walk>
    80001be2:	fea43423          	sd	a0,-24(s0)
  if(pte == 0)
    80001be6:	fe843783          	ld	a5,-24(s0)
    80001bea:	e399                	bnez	a5,80001bf0 <walkaddr+0x40>
    return 0;
    80001bec:	4781                	li	a5,0
    80001bee:	a805                	j	80001c1e <walkaddr+0x6e>
  if((*pte & PTE_V) == 0)
    80001bf0:	fe843783          	ld	a5,-24(s0)
    80001bf4:	639c                	ld	a5,0(a5)
    80001bf6:	8b85                	andi	a5,a5,1
    80001bf8:	e399                	bnez	a5,80001bfe <walkaddr+0x4e>
    return 0;
    80001bfa:	4781                	li	a5,0
    80001bfc:	a00d                	j	80001c1e <walkaddr+0x6e>
  if((*pte & PTE_U) == 0)
    80001bfe:	fe843783          	ld	a5,-24(s0)
    80001c02:	639c                	ld	a5,0(a5)
    80001c04:	8bc1                	andi	a5,a5,16
    80001c06:	e399                	bnez	a5,80001c0c <walkaddr+0x5c>
    return 0;
    80001c08:	4781                	li	a5,0
    80001c0a:	a811                	j	80001c1e <walkaddr+0x6e>
  pa = PTE2PA(*pte);
    80001c0c:	fe843783          	ld	a5,-24(s0)
    80001c10:	639c                	ld	a5,0(a5)
    80001c12:	83a9                	srli	a5,a5,0xa
    80001c14:	07b2                	slli	a5,a5,0xc
    80001c16:	fef43023          	sd	a5,-32(s0)
  return pa;
    80001c1a:	fe043783          	ld	a5,-32(s0)
}
    80001c1e:	853e                	mv	a0,a5
    80001c20:	70a2                	ld	ra,40(sp)
    80001c22:	7402                	ld	s0,32(sp)
    80001c24:	6145                	addi	sp,sp,48
    80001c26:	8082                	ret

0000000080001c28 <kvmmap>:
// add a mapping to the kernel page table.
// only used when booting.
// does not flush TLB or enable paging.
void
kvmmap(pagetable_t kpgtbl, uint64 va, uint64 pa, uint64 sz, int perm)
{
    80001c28:	7139                	addi	sp,sp,-64
    80001c2a:	fc06                	sd	ra,56(sp)
    80001c2c:	f822                	sd	s0,48(sp)
    80001c2e:	0080                	addi	s0,sp,64
    80001c30:	fea43423          	sd	a0,-24(s0)
    80001c34:	feb43023          	sd	a1,-32(s0)
    80001c38:	fcc43c23          	sd	a2,-40(s0)
    80001c3c:	fcd43823          	sd	a3,-48(s0)
    80001c40:	87ba                	mv	a5,a4
    80001c42:	fcf42623          	sw	a5,-52(s0)
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001c46:	fcc42783          	lw	a5,-52(s0)
    80001c4a:	873e                	mv	a4,a5
    80001c4c:	fd843683          	ld	a3,-40(s0)
    80001c50:	fd043603          	ld	a2,-48(s0)
    80001c54:	fe043583          	ld	a1,-32(s0)
    80001c58:	fe843503          	ld	a0,-24(s0)
    80001c5c:	00000097          	auipc	ra,0x0
    80001c60:	026080e7          	jalr	38(ra) # 80001c82 <mappages>
    80001c64:	87aa                	mv	a5,a0
    80001c66:	cb89                	beqz	a5,80001c78 <kvmmap+0x50>
    panic("kvmmap");
    80001c68:	00009517          	auipc	a0,0x9
    80001c6c:	45850513          	addi	a0,a0,1112 # 8000b0c0 <etext+0xc0>
    80001c70:	fffff097          	auipc	ra,0xfffff
    80001c74:	01a080e7          	jalr	26(ra) # 80000c8a <panic>
}
    80001c78:	0001                	nop
    80001c7a:	70e2                	ld	ra,56(sp)
    80001c7c:	7442                	ld	s0,48(sp)
    80001c7e:	6121                	addi	sp,sp,64
    80001c80:	8082                	ret

0000000080001c82 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001c82:	711d                	addi	sp,sp,-96
    80001c84:	ec86                	sd	ra,88(sp)
    80001c86:	e8a2                	sd	s0,80(sp)
    80001c88:	1080                	addi	s0,sp,96
    80001c8a:	fca43423          	sd	a0,-56(s0)
    80001c8e:	fcb43023          	sd	a1,-64(s0)
    80001c92:	fac43c23          	sd	a2,-72(s0)
    80001c96:	fad43823          	sd	a3,-80(s0)
    80001c9a:	87ba                	mv	a5,a4
    80001c9c:	faf42623          	sw	a5,-84(s0)
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80001ca0:	fb843783          	ld	a5,-72(s0)
    80001ca4:	eb89                	bnez	a5,80001cb6 <mappages+0x34>
    panic("mappages: size");
    80001ca6:	00009517          	auipc	a0,0x9
    80001caa:	42250513          	addi	a0,a0,1058 # 8000b0c8 <etext+0xc8>
    80001cae:	fffff097          	auipc	ra,0xfffff
    80001cb2:	fdc080e7          	jalr	-36(ra) # 80000c8a <panic>
  
  a = PGROUNDDOWN(va);
    80001cb6:	fc043703          	ld	a4,-64(s0)
    80001cba:	77fd                	lui	a5,0xfffff
    80001cbc:	8ff9                	and	a5,a5,a4
    80001cbe:	fef43423          	sd	a5,-24(s0)
  last = PGROUNDDOWN(va + size - 1);
    80001cc2:	fc043703          	ld	a4,-64(s0)
    80001cc6:	fb843783          	ld	a5,-72(s0)
    80001cca:	97ba                	add	a5,a5,a4
    80001ccc:	fff78713          	addi	a4,a5,-1 # ffffffffffffefff <end+0xffffffff7ffd7ce7>
    80001cd0:	77fd                	lui	a5,0xfffff
    80001cd2:	8ff9                	and	a5,a5,a4
    80001cd4:	fef43023          	sd	a5,-32(s0)
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    80001cd8:	4605                	li	a2,1
    80001cda:	fe843583          	ld	a1,-24(s0)
    80001cde:	fc843503          	ld	a0,-56(s0)
    80001ce2:	00000097          	auipc	ra,0x0
    80001ce6:	ddc080e7          	jalr	-548(ra) # 80001abe <walk>
    80001cea:	fca43c23          	sd	a0,-40(s0)
    80001cee:	fd843783          	ld	a5,-40(s0)
    80001cf2:	e399                	bnez	a5,80001cf8 <mappages+0x76>
      return -1;
    80001cf4:	57fd                	li	a5,-1
    80001cf6:	a085                	j	80001d56 <mappages+0xd4>
    if(*pte & PTE_V)
    80001cf8:	fd843783          	ld	a5,-40(s0)
    80001cfc:	639c                	ld	a5,0(a5)
    80001cfe:	8b85                	andi	a5,a5,1
    80001d00:	cb89                	beqz	a5,80001d12 <mappages+0x90>
      panic("mappages: remap");
    80001d02:	00009517          	auipc	a0,0x9
    80001d06:	3d650513          	addi	a0,a0,982 # 8000b0d8 <etext+0xd8>
    80001d0a:	fffff097          	auipc	ra,0xfffff
    80001d0e:	f80080e7          	jalr	-128(ra) # 80000c8a <panic>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001d12:	fb043783          	ld	a5,-80(s0)
    80001d16:	83b1                	srli	a5,a5,0xc
    80001d18:	00a79713          	slli	a4,a5,0xa
    80001d1c:	fac42783          	lw	a5,-84(s0)
    80001d20:	8fd9                	or	a5,a5,a4
    80001d22:	0017e713          	ori	a4,a5,1
    80001d26:	fd843783          	ld	a5,-40(s0)
    80001d2a:	e398                	sd	a4,0(a5)
    if(a == last)
    80001d2c:	fe843703          	ld	a4,-24(s0)
    80001d30:	fe043783          	ld	a5,-32(s0)
    80001d34:	00f70f63          	beq	a4,a5,80001d52 <mappages+0xd0>
      break;
    a += PGSIZE;
    80001d38:	fe843703          	ld	a4,-24(s0)
    80001d3c:	6785                	lui	a5,0x1
    80001d3e:	97ba                	add	a5,a5,a4
    80001d40:	fef43423          	sd	a5,-24(s0)
    pa += PGSIZE;
    80001d44:	fb043703          	ld	a4,-80(s0)
    80001d48:	6785                	lui	a5,0x1
    80001d4a:	97ba                	add	a5,a5,a4
    80001d4c:	faf43823          	sd	a5,-80(s0)
    if((pte = walk(pagetable, a, 1)) == 0)
    80001d50:	b761                	j	80001cd8 <mappages+0x56>
      break;
    80001d52:	0001                	nop
  }
  return 0;
    80001d54:	4781                	li	a5,0
}
    80001d56:	853e                	mv	a0,a5
    80001d58:	60e6                	ld	ra,88(sp)
    80001d5a:	6446                	ld	s0,80(sp)
    80001d5c:	6125                	addi	sp,sp,96
    80001d5e:	8082                	ret

0000000080001d60 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001d60:	715d                	addi	sp,sp,-80
    80001d62:	e486                	sd	ra,72(sp)
    80001d64:	e0a2                	sd	s0,64(sp)
    80001d66:	0880                	addi	s0,sp,80
    80001d68:	fca43423          	sd	a0,-56(s0)
    80001d6c:	fcb43023          	sd	a1,-64(s0)
    80001d70:	fac43c23          	sd	a2,-72(s0)
    80001d74:	87b6                	mv	a5,a3
    80001d76:	faf42a23          	sw	a5,-76(s0)
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001d7a:	fc043703          	ld	a4,-64(s0)
    80001d7e:	6785                	lui	a5,0x1
    80001d80:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001d82:	8ff9                	and	a5,a5,a4
    80001d84:	cb89                	beqz	a5,80001d96 <uvmunmap+0x36>
    panic("uvmunmap: not aligned");
    80001d86:	00009517          	auipc	a0,0x9
    80001d8a:	36250513          	addi	a0,a0,866 # 8000b0e8 <etext+0xe8>
    80001d8e:	fffff097          	auipc	ra,0xfffff
    80001d92:	efc080e7          	jalr	-260(ra) # 80000c8a <panic>

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001d96:	fc043783          	ld	a5,-64(s0)
    80001d9a:	fef43423          	sd	a5,-24(s0)
    80001d9e:	a045                	j	80001e3e <uvmunmap+0xde>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001da0:	4601                	li	a2,0
    80001da2:	fe843583          	ld	a1,-24(s0)
    80001da6:	fc843503          	ld	a0,-56(s0)
    80001daa:	00000097          	auipc	ra,0x0
    80001dae:	d14080e7          	jalr	-748(ra) # 80001abe <walk>
    80001db2:	fea43023          	sd	a0,-32(s0)
    80001db6:	fe043783          	ld	a5,-32(s0)
    80001dba:	eb89                	bnez	a5,80001dcc <uvmunmap+0x6c>
      panic("uvmunmap: walk");
    80001dbc:	00009517          	auipc	a0,0x9
    80001dc0:	34450513          	addi	a0,a0,836 # 8000b100 <etext+0x100>
    80001dc4:	fffff097          	auipc	ra,0xfffff
    80001dc8:	ec6080e7          	jalr	-314(ra) # 80000c8a <panic>
    if((*pte & PTE_V) == 0)
    80001dcc:	fe043783          	ld	a5,-32(s0)
    80001dd0:	639c                	ld	a5,0(a5)
    80001dd2:	8b85                	andi	a5,a5,1
    80001dd4:	eb89                	bnez	a5,80001de6 <uvmunmap+0x86>
      panic("uvmunmap: not mapped");
    80001dd6:	00009517          	auipc	a0,0x9
    80001dda:	33a50513          	addi	a0,a0,826 # 8000b110 <etext+0x110>
    80001dde:	fffff097          	auipc	ra,0xfffff
    80001de2:	eac080e7          	jalr	-340(ra) # 80000c8a <panic>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001de6:	fe043783          	ld	a5,-32(s0)
    80001dea:	639c                	ld	a5,0(a5)
    80001dec:	3ff7f713          	andi	a4,a5,1023
    80001df0:	4785                	li	a5,1
    80001df2:	00f71a63          	bne	a4,a5,80001e06 <uvmunmap+0xa6>
      panic("uvmunmap: not a leaf");
    80001df6:	00009517          	auipc	a0,0x9
    80001dfa:	33250513          	addi	a0,a0,818 # 8000b128 <etext+0x128>
    80001dfe:	fffff097          	auipc	ra,0xfffff
    80001e02:	e8c080e7          	jalr	-372(ra) # 80000c8a <panic>
    if(do_free){
    80001e06:	fb442783          	lw	a5,-76(s0)
    80001e0a:	2781                	sext.w	a5,a5
    80001e0c:	cf99                	beqz	a5,80001e2a <uvmunmap+0xca>
      uint64 pa = PTE2PA(*pte);
    80001e0e:	fe043783          	ld	a5,-32(s0)
    80001e12:	639c                	ld	a5,0(a5)
    80001e14:	83a9                	srli	a5,a5,0xa
    80001e16:	07b2                	slli	a5,a5,0xc
    80001e18:	fcf43c23          	sd	a5,-40(s0)
      kfree((void*)pa);
    80001e1c:	fd843783          	ld	a5,-40(s0)
    80001e20:	853e                	mv	a0,a5
    80001e22:	fffff097          	auipc	ra,0xfffff
    80001e26:	264080e7          	jalr	612(ra) # 80001086 <kfree>
    }
    *pte = 0;
    80001e2a:	fe043783          	ld	a5,-32(s0)
    80001e2e:	0007b023          	sd	zero,0(a5)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001e32:	fe843703          	ld	a4,-24(s0)
    80001e36:	6785                	lui	a5,0x1
    80001e38:	97ba                	add	a5,a5,a4
    80001e3a:	fef43423          	sd	a5,-24(s0)
    80001e3e:	fb843783          	ld	a5,-72(s0)
    80001e42:	00c79713          	slli	a4,a5,0xc
    80001e46:	fc043783          	ld	a5,-64(s0)
    80001e4a:	97ba                	add	a5,a5,a4
    80001e4c:	fe843703          	ld	a4,-24(s0)
    80001e50:	f4f768e3          	bltu	a4,a5,80001da0 <uvmunmap+0x40>
  }
}
    80001e54:	0001                	nop
    80001e56:	0001                	nop
    80001e58:	60a6                	ld	ra,72(sp)
    80001e5a:	6406                	ld	s0,64(sp)
    80001e5c:	6161                	addi	sp,sp,80
    80001e5e:	8082                	ret

0000000080001e60 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001e60:	1101                	addi	sp,sp,-32
    80001e62:	ec06                	sd	ra,24(sp)
    80001e64:	e822                	sd	s0,16(sp)
    80001e66:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001e68:	fffff097          	auipc	ra,0xfffff
    80001e6c:	2c2080e7          	jalr	706(ra) # 8000112a <kalloc>
    80001e70:	fea43423          	sd	a0,-24(s0)
  if(pagetable == 0)
    80001e74:	fe843783          	ld	a5,-24(s0)
    80001e78:	e399                	bnez	a5,80001e7e <uvmcreate+0x1e>
    return 0;
    80001e7a:	4781                	li	a5,0
    80001e7c:	a819                	j	80001e92 <uvmcreate+0x32>
  memset(pagetable, 0, PGSIZE);
    80001e7e:	6605                	lui	a2,0x1
    80001e80:	4581                	li	a1,0
    80001e82:	fe843503          	ld	a0,-24(s0)
    80001e86:	fffff097          	auipc	ra,0xfffff
    80001e8a:	5cc080e7          	jalr	1484(ra) # 80001452 <memset>
  return pagetable;
    80001e8e:	fe843783          	ld	a5,-24(s0)
}
    80001e92:	853e                	mv	a0,a5
    80001e94:	60e2                	ld	ra,24(sp)
    80001e96:	6442                	ld	s0,16(sp)
    80001e98:	6105                	addi	sp,sp,32
    80001e9a:	8082                	ret

0000000080001e9c <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80001e9c:	7139                	addi	sp,sp,-64
    80001e9e:	fc06                	sd	ra,56(sp)
    80001ea0:	f822                	sd	s0,48(sp)
    80001ea2:	0080                	addi	s0,sp,64
    80001ea4:	fca43c23          	sd	a0,-40(s0)
    80001ea8:	fcb43823          	sd	a1,-48(s0)
    80001eac:	87b2                	mv	a5,a2
    80001eae:	fcf42623          	sw	a5,-52(s0)
  char *mem;

  if(sz >= PGSIZE)
    80001eb2:	fcc42783          	lw	a5,-52(s0)
    80001eb6:	0007871b          	sext.w	a4,a5
    80001eba:	6785                	lui	a5,0x1
    80001ebc:	00f76a63          	bltu	a4,a5,80001ed0 <uvmfirst+0x34>
    panic("uvmfirst: more than a page");
    80001ec0:	00009517          	auipc	a0,0x9
    80001ec4:	28050513          	addi	a0,a0,640 # 8000b140 <etext+0x140>
    80001ec8:	fffff097          	auipc	ra,0xfffff
    80001ecc:	dc2080e7          	jalr	-574(ra) # 80000c8a <panic>
  mem = kalloc();
    80001ed0:	fffff097          	auipc	ra,0xfffff
    80001ed4:	25a080e7          	jalr	602(ra) # 8000112a <kalloc>
    80001ed8:	fea43423          	sd	a0,-24(s0)
  memset(mem, 0, PGSIZE);
    80001edc:	6605                	lui	a2,0x1
    80001ede:	4581                	li	a1,0
    80001ee0:	fe843503          	ld	a0,-24(s0)
    80001ee4:	fffff097          	auipc	ra,0xfffff
    80001ee8:	56e080e7          	jalr	1390(ra) # 80001452 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001eec:	fe843783          	ld	a5,-24(s0)
    80001ef0:	4779                	li	a4,30
    80001ef2:	86be                	mv	a3,a5
    80001ef4:	6605                	lui	a2,0x1
    80001ef6:	4581                	li	a1,0
    80001ef8:	fd843503          	ld	a0,-40(s0)
    80001efc:	00000097          	auipc	ra,0x0
    80001f00:	d86080e7          	jalr	-634(ra) # 80001c82 <mappages>
  memmove(mem, src, sz);
    80001f04:	fcc42783          	lw	a5,-52(s0)
    80001f08:	863e                	mv	a2,a5
    80001f0a:	fd043583          	ld	a1,-48(s0)
    80001f0e:	fe843503          	ld	a0,-24(s0)
    80001f12:	fffff097          	auipc	ra,0xfffff
    80001f16:	624080e7          	jalr	1572(ra) # 80001536 <memmove>
}
    80001f1a:	0001                	nop
    80001f1c:	70e2                	ld	ra,56(sp)
    80001f1e:	7442                	ld	s0,48(sp)
    80001f20:	6121                	addi	sp,sp,64
    80001f22:	8082                	ret

0000000080001f24 <uvmalloc>:

// Allocate PTEs and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
uint64
uvmalloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz, int xperm)
{
    80001f24:	7139                	addi	sp,sp,-64
    80001f26:	fc06                	sd	ra,56(sp)
    80001f28:	f822                	sd	s0,48(sp)
    80001f2a:	0080                	addi	s0,sp,64
    80001f2c:	fca43c23          	sd	a0,-40(s0)
    80001f30:	fcb43823          	sd	a1,-48(s0)
    80001f34:	fcc43423          	sd	a2,-56(s0)
    80001f38:	87b6                	mv	a5,a3
    80001f3a:	fcf42223          	sw	a5,-60(s0)
  char *mem;
  uint64 a;

  if(newsz < oldsz)
    80001f3e:	fc843703          	ld	a4,-56(s0)
    80001f42:	fd043783          	ld	a5,-48(s0)
    80001f46:	00f77563          	bgeu	a4,a5,80001f50 <uvmalloc+0x2c>
    return oldsz;
    80001f4a:	fd043783          	ld	a5,-48(s0)
    80001f4e:	a87d                	j	8000200c <uvmalloc+0xe8>

  oldsz = PGROUNDUP(oldsz);
    80001f50:	fd043703          	ld	a4,-48(s0)
    80001f54:	6785                	lui	a5,0x1
    80001f56:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001f58:	973e                	add	a4,a4,a5
    80001f5a:	77fd                	lui	a5,0xfffff
    80001f5c:	8ff9                	and	a5,a5,a4
    80001f5e:	fcf43823          	sd	a5,-48(s0)
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001f62:	fd043783          	ld	a5,-48(s0)
    80001f66:	fef43423          	sd	a5,-24(s0)
    80001f6a:	a849                	j	80001ffc <uvmalloc+0xd8>
    mem = kalloc();
    80001f6c:	fffff097          	auipc	ra,0xfffff
    80001f70:	1be080e7          	jalr	446(ra) # 8000112a <kalloc>
    80001f74:	fea43023          	sd	a0,-32(s0)
    if(mem == 0){
    80001f78:	fe043783          	ld	a5,-32(s0)
    80001f7c:	ef89                	bnez	a5,80001f96 <uvmalloc+0x72>
      uvmdealloc(pagetable, a, oldsz);
    80001f7e:	fd043603          	ld	a2,-48(s0)
    80001f82:	fe843583          	ld	a1,-24(s0)
    80001f86:	fd843503          	ld	a0,-40(s0)
    80001f8a:	00000097          	auipc	ra,0x0
    80001f8e:	08c080e7          	jalr	140(ra) # 80002016 <uvmdealloc>
      return 0;
    80001f92:	4781                	li	a5,0
    80001f94:	a8a5                	j	8000200c <uvmalloc+0xe8>
    }
    memset(mem, 0, PGSIZE);
    80001f96:	6605                	lui	a2,0x1
    80001f98:	4581                	li	a1,0
    80001f9a:	fe043503          	ld	a0,-32(s0)
    80001f9e:	fffff097          	auipc	ra,0xfffff
    80001fa2:	4b4080e7          	jalr	1204(ra) # 80001452 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001fa6:	fe043783          	ld	a5,-32(s0)
    80001faa:	fc442703          	lw	a4,-60(s0)
    80001fae:	01276713          	ori	a4,a4,18
    80001fb2:	2701                	sext.w	a4,a4
    80001fb4:	86be                	mv	a3,a5
    80001fb6:	6605                	lui	a2,0x1
    80001fb8:	fe843583          	ld	a1,-24(s0)
    80001fbc:	fd843503          	ld	a0,-40(s0)
    80001fc0:	00000097          	auipc	ra,0x0
    80001fc4:	cc2080e7          	jalr	-830(ra) # 80001c82 <mappages>
    80001fc8:	87aa                	mv	a5,a0
    80001fca:	c39d                	beqz	a5,80001ff0 <uvmalloc+0xcc>
      kfree(mem);
    80001fcc:	fe043503          	ld	a0,-32(s0)
    80001fd0:	fffff097          	auipc	ra,0xfffff
    80001fd4:	0b6080e7          	jalr	182(ra) # 80001086 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001fd8:	fd043603          	ld	a2,-48(s0)
    80001fdc:	fe843583          	ld	a1,-24(s0)
    80001fe0:	fd843503          	ld	a0,-40(s0)
    80001fe4:	00000097          	auipc	ra,0x0
    80001fe8:	032080e7          	jalr	50(ra) # 80002016 <uvmdealloc>
      return 0;
    80001fec:	4781                	li	a5,0
    80001fee:	a839                	j	8000200c <uvmalloc+0xe8>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001ff0:	fe843703          	ld	a4,-24(s0)
    80001ff4:	6785                	lui	a5,0x1
    80001ff6:	97ba                	add	a5,a5,a4
    80001ff8:	fef43423          	sd	a5,-24(s0)
    80001ffc:	fe843703          	ld	a4,-24(s0)
    80002000:	fc843783          	ld	a5,-56(s0)
    80002004:	f6f764e3          	bltu	a4,a5,80001f6c <uvmalloc+0x48>
    }
  }
  return newsz;
    80002008:	fc843783          	ld	a5,-56(s0)
}
    8000200c:	853e                	mv	a0,a5
    8000200e:	70e2                	ld	ra,56(sp)
    80002010:	7442                	ld	s0,48(sp)
    80002012:	6121                	addi	sp,sp,64
    80002014:	8082                	ret

0000000080002016 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80002016:	7139                	addi	sp,sp,-64
    80002018:	fc06                	sd	ra,56(sp)
    8000201a:	f822                	sd	s0,48(sp)
    8000201c:	0080                	addi	s0,sp,64
    8000201e:	fca43c23          	sd	a0,-40(s0)
    80002022:	fcb43823          	sd	a1,-48(s0)
    80002026:	fcc43423          	sd	a2,-56(s0)
  if(newsz >= oldsz)
    8000202a:	fc843703          	ld	a4,-56(s0)
    8000202e:	fd043783          	ld	a5,-48(s0)
    80002032:	00f76563          	bltu	a4,a5,8000203c <uvmdealloc+0x26>
    return oldsz;
    80002036:	fd043783          	ld	a5,-48(s0)
    8000203a:	a885                	j	800020aa <uvmdealloc+0x94>

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000203c:	fc843703          	ld	a4,-56(s0)
    80002040:	6785                	lui	a5,0x1
    80002042:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80002044:	973e                	add	a4,a4,a5
    80002046:	77fd                	lui	a5,0xfffff
    80002048:	8f7d                	and	a4,a4,a5
    8000204a:	fd043683          	ld	a3,-48(s0)
    8000204e:	6785                	lui	a5,0x1
    80002050:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80002052:	96be                	add	a3,a3,a5
    80002054:	77fd                	lui	a5,0xfffff
    80002056:	8ff5                	and	a5,a5,a3
    80002058:	04f77763          	bgeu	a4,a5,800020a6 <uvmdealloc+0x90>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000205c:	fd043703          	ld	a4,-48(s0)
    80002060:	6785                	lui	a5,0x1
    80002062:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80002064:	973e                	add	a4,a4,a5
    80002066:	77fd                	lui	a5,0xfffff
    80002068:	8f7d                	and	a4,a4,a5
    8000206a:	fc843683          	ld	a3,-56(s0)
    8000206e:	6785                	lui	a5,0x1
    80002070:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80002072:	96be                	add	a3,a3,a5
    80002074:	77fd                	lui	a5,0xfffff
    80002076:	8ff5                	and	a5,a5,a3
    80002078:	40f707b3          	sub	a5,a4,a5
    8000207c:	83b1                	srli	a5,a5,0xc
    8000207e:	fef42623          	sw	a5,-20(s0)
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80002082:	fc843703          	ld	a4,-56(s0)
    80002086:	6785                	lui	a5,0x1
    80002088:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000208a:	973e                	add	a4,a4,a5
    8000208c:	77fd                	lui	a5,0xfffff
    8000208e:	8ff9                	and	a5,a5,a4
    80002090:	fec42703          	lw	a4,-20(s0)
    80002094:	4685                	li	a3,1
    80002096:	863a                	mv	a2,a4
    80002098:	85be                	mv	a1,a5
    8000209a:	fd843503          	ld	a0,-40(s0)
    8000209e:	00000097          	auipc	ra,0x0
    800020a2:	cc2080e7          	jalr	-830(ra) # 80001d60 <uvmunmap>
  }

  return newsz;
    800020a6:	fc843783          	ld	a5,-56(s0)
}
    800020aa:	853e                	mv	a0,a5
    800020ac:	70e2                	ld	ra,56(sp)
    800020ae:	7442                	ld	s0,48(sp)
    800020b0:	6121                	addi	sp,sp,64
    800020b2:	8082                	ret

00000000800020b4 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800020b4:	7139                	addi	sp,sp,-64
    800020b6:	fc06                	sd	ra,56(sp)
    800020b8:	f822                	sd	s0,48(sp)
    800020ba:	0080                	addi	s0,sp,64
    800020bc:	fca43423          	sd	a0,-56(s0)
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800020c0:	fe042623          	sw	zero,-20(s0)
    800020c4:	a88d                	j	80002136 <freewalk+0x82>
    pte_t pte = pagetable[i];
    800020c6:	fec42783          	lw	a5,-20(s0)
    800020ca:	078e                	slli	a5,a5,0x3
    800020cc:	fc843703          	ld	a4,-56(s0)
    800020d0:	97ba                	add	a5,a5,a4
    800020d2:	639c                	ld	a5,0(a5)
    800020d4:	fef43023          	sd	a5,-32(s0)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800020d8:	fe043783          	ld	a5,-32(s0)
    800020dc:	8b85                	andi	a5,a5,1
    800020de:	cb9d                	beqz	a5,80002114 <freewalk+0x60>
    800020e0:	fe043783          	ld	a5,-32(s0)
    800020e4:	8bb9                	andi	a5,a5,14
    800020e6:	e79d                	bnez	a5,80002114 <freewalk+0x60>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800020e8:	fe043783          	ld	a5,-32(s0)
    800020ec:	83a9                	srli	a5,a5,0xa
    800020ee:	07b2                	slli	a5,a5,0xc
    800020f0:	fcf43c23          	sd	a5,-40(s0)
      freewalk((pagetable_t)child);
    800020f4:	fd843783          	ld	a5,-40(s0)
    800020f8:	853e                	mv	a0,a5
    800020fa:	00000097          	auipc	ra,0x0
    800020fe:	fba080e7          	jalr	-70(ra) # 800020b4 <freewalk>
      pagetable[i] = 0;
    80002102:	fec42783          	lw	a5,-20(s0)
    80002106:	078e                	slli	a5,a5,0x3
    80002108:	fc843703          	ld	a4,-56(s0)
    8000210c:	97ba                	add	a5,a5,a4
    8000210e:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0xffffffff7ffd7ce8>
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80002112:	a829                	j	8000212c <freewalk+0x78>
    } else if(pte & PTE_V){
    80002114:	fe043783          	ld	a5,-32(s0)
    80002118:	8b85                	andi	a5,a5,1
    8000211a:	cb89                	beqz	a5,8000212c <freewalk+0x78>
      panic("freewalk: leaf");
    8000211c:	00009517          	auipc	a0,0x9
    80002120:	04450513          	addi	a0,a0,68 # 8000b160 <etext+0x160>
    80002124:	fffff097          	auipc	ra,0xfffff
    80002128:	b66080e7          	jalr	-1178(ra) # 80000c8a <panic>
  for(int i = 0; i < 512; i++){
    8000212c:	fec42783          	lw	a5,-20(s0)
    80002130:	2785                	addiw	a5,a5,1
    80002132:	fef42623          	sw	a5,-20(s0)
    80002136:	fec42783          	lw	a5,-20(s0)
    8000213a:	0007871b          	sext.w	a4,a5
    8000213e:	1ff00793          	li	a5,511
    80002142:	f8e7d2e3          	bge	a5,a4,800020c6 <freewalk+0x12>
    }
  }
  kfree((void*)pagetable);
    80002146:	fc843503          	ld	a0,-56(s0)
    8000214a:	fffff097          	auipc	ra,0xfffff
    8000214e:	f3c080e7          	jalr	-196(ra) # 80001086 <kfree>
}
    80002152:	0001                	nop
    80002154:	70e2                	ld	ra,56(sp)
    80002156:	7442                	ld	s0,48(sp)
    80002158:	6121                	addi	sp,sp,64
    8000215a:	8082                	ret

000000008000215c <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000215c:	1101                	addi	sp,sp,-32
    8000215e:	ec06                	sd	ra,24(sp)
    80002160:	e822                	sd	s0,16(sp)
    80002162:	1000                	addi	s0,sp,32
    80002164:	fea43423          	sd	a0,-24(s0)
    80002168:	feb43023          	sd	a1,-32(s0)
  if(sz > 0)
    8000216c:	fe043783          	ld	a5,-32(s0)
    80002170:	c385                	beqz	a5,80002190 <uvmfree+0x34>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80002172:	fe043703          	ld	a4,-32(s0)
    80002176:	6785                	lui	a5,0x1
    80002178:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000217a:	97ba                	add	a5,a5,a4
    8000217c:	83b1                	srli	a5,a5,0xc
    8000217e:	4685                	li	a3,1
    80002180:	863e                	mv	a2,a5
    80002182:	4581                	li	a1,0
    80002184:	fe843503          	ld	a0,-24(s0)
    80002188:	00000097          	auipc	ra,0x0
    8000218c:	bd8080e7          	jalr	-1064(ra) # 80001d60 <uvmunmap>
  freewalk(pagetable);
    80002190:	fe843503          	ld	a0,-24(s0)
    80002194:	00000097          	auipc	ra,0x0
    80002198:	f20080e7          	jalr	-224(ra) # 800020b4 <freewalk>
}
    8000219c:	0001                	nop
    8000219e:	60e2                	ld	ra,24(sp)
    800021a0:	6442                	ld	s0,16(sp)
    800021a2:	6105                	addi	sp,sp,32
    800021a4:	8082                	ret

00000000800021a6 <uvmcopy>:
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int
uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
    800021a6:	711d                	addi	sp,sp,-96
    800021a8:	ec86                	sd	ra,88(sp)
    800021aa:	e8a2                	sd	s0,80(sp)
    800021ac:	1080                	addi	s0,sp,96
    800021ae:	faa43c23          	sd	a0,-72(s0)
    800021b2:	fab43823          	sd	a1,-80(s0)
    800021b6:	fac43423          	sd	a2,-88(s0)
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800021ba:	fe043423          	sd	zero,-24(s0)
    800021be:	a0d9                	j	80002284 <uvmcopy+0xde>
    if((pte = walk(old, i, 0)) == 0)
    800021c0:	4601                	li	a2,0
    800021c2:	fe843583          	ld	a1,-24(s0)
    800021c6:	fb843503          	ld	a0,-72(s0)
    800021ca:	00000097          	auipc	ra,0x0
    800021ce:	8f4080e7          	jalr	-1804(ra) # 80001abe <walk>
    800021d2:	fea43023          	sd	a0,-32(s0)
    800021d6:	fe043783          	ld	a5,-32(s0)
    800021da:	eb89                	bnez	a5,800021ec <uvmcopy+0x46>
      panic("uvmcopy: pte should exist");
    800021dc:	00009517          	auipc	a0,0x9
    800021e0:	f9450513          	addi	a0,a0,-108 # 8000b170 <etext+0x170>
    800021e4:	fffff097          	auipc	ra,0xfffff
    800021e8:	aa6080e7          	jalr	-1370(ra) # 80000c8a <panic>
    if((*pte & PTE_V) == 0)
    800021ec:	fe043783          	ld	a5,-32(s0)
    800021f0:	639c                	ld	a5,0(a5)
    800021f2:	8b85                	andi	a5,a5,1
    800021f4:	eb89                	bnez	a5,80002206 <uvmcopy+0x60>
      panic("uvmcopy: page not present");
    800021f6:	00009517          	auipc	a0,0x9
    800021fa:	f9a50513          	addi	a0,a0,-102 # 8000b190 <etext+0x190>
    800021fe:	fffff097          	auipc	ra,0xfffff
    80002202:	a8c080e7          	jalr	-1396(ra) # 80000c8a <panic>
    pa = PTE2PA(*pte);
    80002206:	fe043783          	ld	a5,-32(s0)
    8000220a:	639c                	ld	a5,0(a5)
    8000220c:	83a9                	srli	a5,a5,0xa
    8000220e:	07b2                	slli	a5,a5,0xc
    80002210:	fcf43c23          	sd	a5,-40(s0)
    flags = PTE_FLAGS(*pte);
    80002214:	fe043783          	ld	a5,-32(s0)
    80002218:	639c                	ld	a5,0(a5)
    8000221a:	2781                	sext.w	a5,a5
    8000221c:	3ff7f793          	andi	a5,a5,1023
    80002220:	fcf42a23          	sw	a5,-44(s0)
    if((mem = kalloc()) == 0)
    80002224:	fffff097          	auipc	ra,0xfffff
    80002228:	f06080e7          	jalr	-250(ra) # 8000112a <kalloc>
    8000222c:	fca43423          	sd	a0,-56(s0)
    80002230:	fc843783          	ld	a5,-56(s0)
    80002234:	c3a5                	beqz	a5,80002294 <uvmcopy+0xee>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80002236:	fd843783          	ld	a5,-40(s0)
    8000223a:	6605                	lui	a2,0x1
    8000223c:	85be                	mv	a1,a5
    8000223e:	fc843503          	ld	a0,-56(s0)
    80002242:	fffff097          	auipc	ra,0xfffff
    80002246:	2f4080e7          	jalr	756(ra) # 80001536 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000224a:	fc843783          	ld	a5,-56(s0)
    8000224e:	fd442703          	lw	a4,-44(s0)
    80002252:	86be                	mv	a3,a5
    80002254:	6605                	lui	a2,0x1
    80002256:	fe843583          	ld	a1,-24(s0)
    8000225a:	fb043503          	ld	a0,-80(s0)
    8000225e:	00000097          	auipc	ra,0x0
    80002262:	a24080e7          	jalr	-1500(ra) # 80001c82 <mappages>
    80002266:	87aa                	mv	a5,a0
    80002268:	cb81                	beqz	a5,80002278 <uvmcopy+0xd2>
      kfree(mem);
    8000226a:	fc843503          	ld	a0,-56(s0)
    8000226e:	fffff097          	auipc	ra,0xfffff
    80002272:	e18080e7          	jalr	-488(ra) # 80001086 <kfree>
      goto err;
    80002276:	a005                	j	80002296 <uvmcopy+0xf0>
  for(i = 0; i < sz; i += PGSIZE){
    80002278:	fe843703          	ld	a4,-24(s0)
    8000227c:	6785                	lui	a5,0x1
    8000227e:	97ba                	add	a5,a5,a4
    80002280:	fef43423          	sd	a5,-24(s0)
    80002284:	fe843703          	ld	a4,-24(s0)
    80002288:	fa843783          	ld	a5,-88(s0)
    8000228c:	f2f76ae3          	bltu	a4,a5,800021c0 <uvmcopy+0x1a>
    }
  }
  return 0;
    80002290:	4781                	li	a5,0
    80002292:	a839                	j	800022b0 <uvmcopy+0x10a>
      goto err;
    80002294:	0001                	nop

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80002296:	fe843783          	ld	a5,-24(s0)
    8000229a:	83b1                	srli	a5,a5,0xc
    8000229c:	4685                	li	a3,1
    8000229e:	863e                	mv	a2,a5
    800022a0:	4581                	li	a1,0
    800022a2:	fb043503          	ld	a0,-80(s0)
    800022a6:	00000097          	auipc	ra,0x0
    800022aa:	aba080e7          	jalr	-1350(ra) # 80001d60 <uvmunmap>
  return -1;
    800022ae:	57fd                	li	a5,-1
}
    800022b0:	853e                	mv	a0,a5
    800022b2:	60e6                	ld	ra,88(sp)
    800022b4:	6446                	ld	s0,80(sp)
    800022b6:	6125                	addi	sp,sp,96
    800022b8:	8082                	ret

00000000800022ba <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800022ba:	7179                	addi	sp,sp,-48
    800022bc:	f406                	sd	ra,40(sp)
    800022be:	f022                	sd	s0,32(sp)
    800022c0:	1800                	addi	s0,sp,48
    800022c2:	fca43c23          	sd	a0,-40(s0)
    800022c6:	fcb43823          	sd	a1,-48(s0)
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800022ca:	4601                	li	a2,0
    800022cc:	fd043583          	ld	a1,-48(s0)
    800022d0:	fd843503          	ld	a0,-40(s0)
    800022d4:	fffff097          	auipc	ra,0xfffff
    800022d8:	7ea080e7          	jalr	2026(ra) # 80001abe <walk>
    800022dc:	fea43423          	sd	a0,-24(s0)
  if(pte == 0)
    800022e0:	fe843783          	ld	a5,-24(s0)
    800022e4:	eb89                	bnez	a5,800022f6 <uvmclear+0x3c>
    panic("uvmclear");
    800022e6:	00009517          	auipc	a0,0x9
    800022ea:	eca50513          	addi	a0,a0,-310 # 8000b1b0 <etext+0x1b0>
    800022ee:	fffff097          	auipc	ra,0xfffff
    800022f2:	99c080e7          	jalr	-1636(ra) # 80000c8a <panic>
  *pte &= ~PTE_U;
    800022f6:	fe843783          	ld	a5,-24(s0)
    800022fa:	639c                	ld	a5,0(a5)
    800022fc:	fef7f713          	andi	a4,a5,-17
    80002300:	fe843783          	ld	a5,-24(s0)
    80002304:	e398                	sd	a4,0(a5)
}
    80002306:	0001                	nop
    80002308:	70a2                	ld	ra,40(sp)
    8000230a:	7402                	ld	s0,32(sp)
    8000230c:	6145                	addi	sp,sp,48
    8000230e:	8082                	ret

0000000080002310 <copyout>:
// Copy from kernel to user.
// Copy len bytes from src to virtual address dstva in a given page table.
// Return 0 on success, -1 on error.
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
    80002310:	715d                	addi	sp,sp,-80
    80002312:	e486                	sd	ra,72(sp)
    80002314:	e0a2                	sd	s0,64(sp)
    80002316:	0880                	addi	s0,sp,80
    80002318:	fca43423          	sd	a0,-56(s0)
    8000231c:	fcb43023          	sd	a1,-64(s0)
    80002320:	fac43c23          	sd	a2,-72(s0)
    80002324:	fad43823          	sd	a3,-80(s0)
  uint64 n, va0, pa0;

  while(len > 0){
    80002328:	a055                	j	800023cc <copyout+0xbc>
    va0 = PGROUNDDOWN(dstva);
    8000232a:	fc043703          	ld	a4,-64(s0)
    8000232e:	77fd                	lui	a5,0xfffff
    80002330:	8ff9                	and	a5,a5,a4
    80002332:	fef43023          	sd	a5,-32(s0)
    pa0 = walkaddr(pagetable, va0);
    80002336:	fe043583          	ld	a1,-32(s0)
    8000233a:	fc843503          	ld	a0,-56(s0)
    8000233e:	00000097          	auipc	ra,0x0
    80002342:	872080e7          	jalr	-1934(ra) # 80001bb0 <walkaddr>
    80002346:	fca43c23          	sd	a0,-40(s0)
    if(pa0 == 0)
    8000234a:	fd843783          	ld	a5,-40(s0)
    8000234e:	e399                	bnez	a5,80002354 <copyout+0x44>
      return -1;
    80002350:	57fd                	li	a5,-1
    80002352:	a049                	j	800023d4 <copyout+0xc4>
    n = PGSIZE - (dstva - va0);
    80002354:	fe043703          	ld	a4,-32(s0)
    80002358:	fc043783          	ld	a5,-64(s0)
    8000235c:	8f1d                	sub	a4,a4,a5
    8000235e:	6785                	lui	a5,0x1
    80002360:	97ba                	add	a5,a5,a4
    80002362:	fef43423          	sd	a5,-24(s0)
    if(n > len)
    80002366:	fe843703          	ld	a4,-24(s0)
    8000236a:	fb043783          	ld	a5,-80(s0)
    8000236e:	00e7f663          	bgeu	a5,a4,8000237a <copyout+0x6a>
      n = len;
    80002372:	fb043783          	ld	a5,-80(s0)
    80002376:	fef43423          	sd	a5,-24(s0)
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    8000237a:	fc043703          	ld	a4,-64(s0)
    8000237e:	fe043783          	ld	a5,-32(s0)
    80002382:	8f1d                	sub	a4,a4,a5
    80002384:	fd843783          	ld	a5,-40(s0)
    80002388:	97ba                	add	a5,a5,a4
    8000238a:	873e                	mv	a4,a5
    8000238c:	fe843783          	ld	a5,-24(s0)
    80002390:	2781                	sext.w	a5,a5
    80002392:	863e                	mv	a2,a5
    80002394:	fb843583          	ld	a1,-72(s0)
    80002398:	853a                	mv	a0,a4
    8000239a:	fffff097          	auipc	ra,0xfffff
    8000239e:	19c080e7          	jalr	412(ra) # 80001536 <memmove>

    len -= n;
    800023a2:	fb043703          	ld	a4,-80(s0)
    800023a6:	fe843783          	ld	a5,-24(s0)
    800023aa:	40f707b3          	sub	a5,a4,a5
    800023ae:	faf43823          	sd	a5,-80(s0)
    src += n;
    800023b2:	fb843703          	ld	a4,-72(s0)
    800023b6:	fe843783          	ld	a5,-24(s0)
    800023ba:	97ba                	add	a5,a5,a4
    800023bc:	faf43c23          	sd	a5,-72(s0)
    dstva = va0 + PGSIZE;
    800023c0:	fe043703          	ld	a4,-32(s0)
    800023c4:	6785                	lui	a5,0x1
    800023c6:	97ba                	add	a5,a5,a4
    800023c8:	fcf43023          	sd	a5,-64(s0)
  while(len > 0){
    800023cc:	fb043783          	ld	a5,-80(s0)
    800023d0:	ffa9                	bnez	a5,8000232a <copyout+0x1a>
  }
  return 0;
    800023d2:	4781                	li	a5,0
}
    800023d4:	853e                	mv	a0,a5
    800023d6:	60a6                	ld	ra,72(sp)
    800023d8:	6406                	ld	s0,64(sp)
    800023da:	6161                	addi	sp,sp,80
    800023dc:	8082                	ret

00000000800023de <copyin>:
// Copy from user to kernel.
// Copy len bytes to dst from virtual address srcva in a given page table.
// Return 0 on success, -1 on error.
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
    800023de:	715d                	addi	sp,sp,-80
    800023e0:	e486                	sd	ra,72(sp)
    800023e2:	e0a2                	sd	s0,64(sp)
    800023e4:	0880                	addi	s0,sp,80
    800023e6:	fca43423          	sd	a0,-56(s0)
    800023ea:	fcb43023          	sd	a1,-64(s0)
    800023ee:	fac43c23          	sd	a2,-72(s0)
    800023f2:	fad43823          	sd	a3,-80(s0)
  uint64 n, va0, pa0;

  while(len > 0){
    800023f6:	a055                	j	8000249a <copyin+0xbc>
    va0 = PGROUNDDOWN(srcva);
    800023f8:	fb843703          	ld	a4,-72(s0)
    800023fc:	77fd                	lui	a5,0xfffff
    800023fe:	8ff9                	and	a5,a5,a4
    80002400:	fef43023          	sd	a5,-32(s0)
    pa0 = walkaddr(pagetable, va0);
    80002404:	fe043583          	ld	a1,-32(s0)
    80002408:	fc843503          	ld	a0,-56(s0)
    8000240c:	fffff097          	auipc	ra,0xfffff
    80002410:	7a4080e7          	jalr	1956(ra) # 80001bb0 <walkaddr>
    80002414:	fca43c23          	sd	a0,-40(s0)
    if(pa0 == 0)
    80002418:	fd843783          	ld	a5,-40(s0)
    8000241c:	e399                	bnez	a5,80002422 <copyin+0x44>
      return -1;
    8000241e:	57fd                	li	a5,-1
    80002420:	a049                	j	800024a2 <copyin+0xc4>
    n = PGSIZE - (srcva - va0);
    80002422:	fe043703          	ld	a4,-32(s0)
    80002426:	fb843783          	ld	a5,-72(s0)
    8000242a:	8f1d                	sub	a4,a4,a5
    8000242c:	6785                	lui	a5,0x1
    8000242e:	97ba                	add	a5,a5,a4
    80002430:	fef43423          	sd	a5,-24(s0)
    if(n > len)
    80002434:	fe843703          	ld	a4,-24(s0)
    80002438:	fb043783          	ld	a5,-80(s0)
    8000243c:	00e7f663          	bgeu	a5,a4,80002448 <copyin+0x6a>
      n = len;
    80002440:	fb043783          	ld	a5,-80(s0)
    80002444:	fef43423          	sd	a5,-24(s0)
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80002448:	fb843703          	ld	a4,-72(s0)
    8000244c:	fe043783          	ld	a5,-32(s0)
    80002450:	8f1d                	sub	a4,a4,a5
    80002452:	fd843783          	ld	a5,-40(s0)
    80002456:	97ba                	add	a5,a5,a4
    80002458:	873e                	mv	a4,a5
    8000245a:	fe843783          	ld	a5,-24(s0)
    8000245e:	2781                	sext.w	a5,a5
    80002460:	863e                	mv	a2,a5
    80002462:	85ba                	mv	a1,a4
    80002464:	fc043503          	ld	a0,-64(s0)
    80002468:	fffff097          	auipc	ra,0xfffff
    8000246c:	0ce080e7          	jalr	206(ra) # 80001536 <memmove>

    len -= n;
    80002470:	fb043703          	ld	a4,-80(s0)
    80002474:	fe843783          	ld	a5,-24(s0)
    80002478:	40f707b3          	sub	a5,a4,a5
    8000247c:	faf43823          	sd	a5,-80(s0)
    dst += n;
    80002480:	fc043703          	ld	a4,-64(s0)
    80002484:	fe843783          	ld	a5,-24(s0)
    80002488:	97ba                	add	a5,a5,a4
    8000248a:	fcf43023          	sd	a5,-64(s0)
    srcva = va0 + PGSIZE;
    8000248e:	fe043703          	ld	a4,-32(s0)
    80002492:	6785                	lui	a5,0x1
    80002494:	97ba                	add	a5,a5,a4
    80002496:	faf43c23          	sd	a5,-72(s0)
  while(len > 0){
    8000249a:	fb043783          	ld	a5,-80(s0)
    8000249e:	ffa9                	bnez	a5,800023f8 <copyin+0x1a>
  }
  return 0;
    800024a0:	4781                	li	a5,0
}
    800024a2:	853e                	mv	a0,a5
    800024a4:	60a6                	ld	ra,72(sp)
    800024a6:	6406                	ld	s0,64(sp)
    800024a8:	6161                	addi	sp,sp,80
    800024aa:	8082                	ret

00000000800024ac <copyinstr>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    800024ac:	711d                	addi	sp,sp,-96
    800024ae:	ec86                	sd	ra,88(sp)
    800024b0:	e8a2                	sd	s0,80(sp)
    800024b2:	1080                	addi	s0,sp,96
    800024b4:	faa43c23          	sd	a0,-72(s0)
    800024b8:	fab43823          	sd	a1,-80(s0)
    800024bc:	fac43423          	sd	a2,-88(s0)
    800024c0:	fad43023          	sd	a3,-96(s0)
  uint64 n, va0, pa0;
  int got_null = 0;
    800024c4:	fe042223          	sw	zero,-28(s0)

  while(got_null == 0 && max > 0){
    800024c8:	a0f1                	j	80002594 <copyinstr+0xe8>
    va0 = PGROUNDDOWN(srcva);
    800024ca:	fa843703          	ld	a4,-88(s0)
    800024ce:	77fd                	lui	a5,0xfffff
    800024d0:	8ff9                	and	a5,a5,a4
    800024d2:	fcf43823          	sd	a5,-48(s0)
    pa0 = walkaddr(pagetable, va0);
    800024d6:	fd043583          	ld	a1,-48(s0)
    800024da:	fb843503          	ld	a0,-72(s0)
    800024de:	fffff097          	auipc	ra,0xfffff
    800024e2:	6d2080e7          	jalr	1746(ra) # 80001bb0 <walkaddr>
    800024e6:	fca43423          	sd	a0,-56(s0)
    if(pa0 == 0)
    800024ea:	fc843783          	ld	a5,-56(s0)
    800024ee:	e399                	bnez	a5,800024f4 <copyinstr+0x48>
      return -1;
    800024f0:	57fd                	li	a5,-1
    800024f2:	a87d                	j	800025b0 <copyinstr+0x104>
    n = PGSIZE - (srcva - va0);
    800024f4:	fd043703          	ld	a4,-48(s0)
    800024f8:	fa843783          	ld	a5,-88(s0)
    800024fc:	8f1d                	sub	a4,a4,a5
    800024fe:	6785                	lui	a5,0x1
    80002500:	97ba                	add	a5,a5,a4
    80002502:	fef43423          	sd	a5,-24(s0)
    if(n > max)
    80002506:	fe843703          	ld	a4,-24(s0)
    8000250a:	fa043783          	ld	a5,-96(s0)
    8000250e:	00e7f663          	bgeu	a5,a4,8000251a <copyinstr+0x6e>
      n = max;
    80002512:	fa043783          	ld	a5,-96(s0)
    80002516:	fef43423          	sd	a5,-24(s0)

    char *p = (char *) (pa0 + (srcva - va0));
    8000251a:	fa843703          	ld	a4,-88(s0)
    8000251e:	fd043783          	ld	a5,-48(s0)
    80002522:	8f1d                	sub	a4,a4,a5
    80002524:	fc843783          	ld	a5,-56(s0)
    80002528:	97ba                	add	a5,a5,a4
    8000252a:	fcf43c23          	sd	a5,-40(s0)
    while(n > 0){
    8000252e:	a891                	j	80002582 <copyinstr+0xd6>
      if(*p == '\0'){
    80002530:	fd843783          	ld	a5,-40(s0)
    80002534:	0007c783          	lbu	a5,0(a5) # 1000 <_entry-0x7ffff000>
    80002538:	eb89                	bnez	a5,8000254a <copyinstr+0x9e>
        *dst = '\0';
    8000253a:	fb043783          	ld	a5,-80(s0)
    8000253e:	00078023          	sb	zero,0(a5)
        got_null = 1;
    80002542:	4785                	li	a5,1
    80002544:	fef42223          	sw	a5,-28(s0)
        break;
    80002548:	a081                	j	80002588 <copyinstr+0xdc>
      } else {
        *dst = *p;
    8000254a:	fd843783          	ld	a5,-40(s0)
    8000254e:	0007c703          	lbu	a4,0(a5)
    80002552:	fb043783          	ld	a5,-80(s0)
    80002556:	00e78023          	sb	a4,0(a5)
      }
      --n;
    8000255a:	fe843783          	ld	a5,-24(s0)
    8000255e:	17fd                	addi	a5,a5,-1
    80002560:	fef43423          	sd	a5,-24(s0)
      --max;
    80002564:	fa043783          	ld	a5,-96(s0)
    80002568:	17fd                	addi	a5,a5,-1
    8000256a:	faf43023          	sd	a5,-96(s0)
      p++;
    8000256e:	fd843783          	ld	a5,-40(s0)
    80002572:	0785                	addi	a5,a5,1
    80002574:	fcf43c23          	sd	a5,-40(s0)
      dst++;
    80002578:	fb043783          	ld	a5,-80(s0)
    8000257c:	0785                	addi	a5,a5,1
    8000257e:	faf43823          	sd	a5,-80(s0)
    while(n > 0){
    80002582:	fe843783          	ld	a5,-24(s0)
    80002586:	f7cd                	bnez	a5,80002530 <copyinstr+0x84>
    }

    srcva = va0 + PGSIZE;
    80002588:	fd043703          	ld	a4,-48(s0)
    8000258c:	6785                	lui	a5,0x1
    8000258e:	97ba                	add	a5,a5,a4
    80002590:	faf43423          	sd	a5,-88(s0)
  while(got_null == 0 && max > 0){
    80002594:	fe442783          	lw	a5,-28(s0)
    80002598:	2781                	sext.w	a5,a5
    8000259a:	e781                	bnez	a5,800025a2 <copyinstr+0xf6>
    8000259c:	fa043783          	ld	a5,-96(s0)
    800025a0:	f78d                	bnez	a5,800024ca <copyinstr+0x1e>
  }
  if(got_null){
    800025a2:	fe442783          	lw	a5,-28(s0)
    800025a6:	2781                	sext.w	a5,a5
    800025a8:	c399                	beqz	a5,800025ae <copyinstr+0x102>
    return 0;
    800025aa:	4781                	li	a5,0
    800025ac:	a011                	j	800025b0 <copyinstr+0x104>
  } else {
    return -1;
    800025ae:	57fd                	li	a5,-1
  }
}
    800025b0:	853e                	mv	a0,a5
    800025b2:	60e6                	ld	ra,88(sp)
    800025b4:	6446                	ld	s0,80(sp)
    800025b6:	6125                	addi	sp,sp,96
    800025b8:	8082                	ret

00000000800025ba <r_sstatus>:
{
    800025ba:	1101                	addi	sp,sp,-32
    800025bc:	ec22                	sd	s0,24(sp)
    800025be:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025c0:	100027f3          	csrr	a5,sstatus
    800025c4:	fef43423          	sd	a5,-24(s0)
  return x;
    800025c8:	fe843783          	ld	a5,-24(s0)
}
    800025cc:	853e                	mv	a0,a5
    800025ce:	6462                	ld	s0,24(sp)
    800025d0:	6105                	addi	sp,sp,32
    800025d2:	8082                	ret

00000000800025d4 <w_sstatus>:
{
    800025d4:	1101                	addi	sp,sp,-32
    800025d6:	ec22                	sd	s0,24(sp)
    800025d8:	1000                	addi	s0,sp,32
    800025da:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800025de:	fe843783          	ld	a5,-24(s0)
    800025e2:	10079073          	csrw	sstatus,a5
}
    800025e6:	0001                	nop
    800025e8:	6462                	ld	s0,24(sp)
    800025ea:	6105                	addi	sp,sp,32
    800025ec:	8082                	ret

00000000800025ee <intr_on>:
{
    800025ee:	1141                	addi	sp,sp,-16
    800025f0:	e406                	sd	ra,8(sp)
    800025f2:	e022                	sd	s0,0(sp)
    800025f4:	0800                	addi	s0,sp,16
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800025f6:	00000097          	auipc	ra,0x0
    800025fa:	fc4080e7          	jalr	-60(ra) # 800025ba <r_sstatus>
    800025fe:	87aa                	mv	a5,a0
    80002600:	0027e793          	ori	a5,a5,2
    80002604:	853e                	mv	a0,a5
    80002606:	00000097          	auipc	ra,0x0
    8000260a:	fce080e7          	jalr	-50(ra) # 800025d4 <w_sstatus>
}
    8000260e:	0001                	nop
    80002610:	60a2                	ld	ra,8(sp)
    80002612:	6402                	ld	s0,0(sp)
    80002614:	0141                	addi	sp,sp,16
    80002616:	8082                	ret

0000000080002618 <intr_get>:
{
    80002618:	1101                	addi	sp,sp,-32
    8000261a:	ec06                	sd	ra,24(sp)
    8000261c:	e822                	sd	s0,16(sp)
    8000261e:	1000                	addi	s0,sp,32
  uint64 x = r_sstatus();
    80002620:	00000097          	auipc	ra,0x0
    80002624:	f9a080e7          	jalr	-102(ra) # 800025ba <r_sstatus>
    80002628:	fea43423          	sd	a0,-24(s0)
  return (x & SSTATUS_SIE) != 0;
    8000262c:	fe843783          	ld	a5,-24(s0)
    80002630:	8b89                	andi	a5,a5,2
    80002632:	00f037b3          	snez	a5,a5
    80002636:	0ff7f793          	zext.b	a5,a5
    8000263a:	2781                	sext.w	a5,a5
}
    8000263c:	853e                	mv	a0,a5
    8000263e:	60e2                	ld	ra,24(sp)
    80002640:	6442                	ld	s0,16(sp)
    80002642:	6105                	addi	sp,sp,32
    80002644:	8082                	ret

0000000080002646 <r_tp>:
{
    80002646:	1101                	addi	sp,sp,-32
    80002648:	ec22                	sd	s0,24(sp)
    8000264a:	1000                	addi	s0,sp,32
  asm volatile("mv %0, tp" : "=r" (x) );
    8000264c:	8792                	mv	a5,tp
    8000264e:	fef43423          	sd	a5,-24(s0)
  return x;
    80002652:	fe843783          	ld	a5,-24(s0)
}
    80002656:	853e                	mv	a0,a5
    80002658:	6462                	ld	s0,24(sp)
    8000265a:	6105                	addi	sp,sp,32
    8000265c:	8082                	ret

000000008000265e <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    8000265e:	7139                	addi	sp,sp,-64
    80002660:	fc06                	sd	ra,56(sp)
    80002662:	f822                	sd	s0,48(sp)
    80002664:	0080                	addi	s0,sp,64
    80002666:	fca43423          	sd	a0,-56(s0)
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    8000266a:	00014797          	auipc	a5,0x14
    8000266e:	e9e78793          	addi	a5,a5,-354 # 80016508 <proc>
    80002672:	fef43423          	sd	a5,-24(s0)
    80002676:	a061                	j	800026fe <proc_mapstacks+0xa0>
    char *pa = kalloc();
    80002678:	fffff097          	auipc	ra,0xfffff
    8000267c:	ab2080e7          	jalr	-1358(ra) # 8000112a <kalloc>
    80002680:	fea43023          	sd	a0,-32(s0)
    if(pa == 0)
    80002684:	fe043783          	ld	a5,-32(s0)
    80002688:	eb89                	bnez	a5,8000269a <proc_mapstacks+0x3c>
      panic("kalloc");
    8000268a:	00009517          	auipc	a0,0x9
    8000268e:	b3650513          	addi	a0,a0,-1226 # 8000b1c0 <etext+0x1c0>
    80002692:	ffffe097          	auipc	ra,0xffffe
    80002696:	5f8080e7          	jalr	1528(ra) # 80000c8a <panic>
    uint64 va = KSTACK((int) (p - proc));
    8000269a:	fe843703          	ld	a4,-24(s0)
    8000269e:	00014797          	auipc	a5,0x14
    800026a2:	e6a78793          	addi	a5,a5,-406 # 80016508 <proc>
    800026a6:	40f707b3          	sub	a5,a4,a5
    800026aa:	4037d713          	srai	a4,a5,0x3
    800026ae:	00009797          	auipc	a5,0x9
    800026b2:	c1a78793          	addi	a5,a5,-998 # 8000b2c8 <etext+0x2c8>
    800026b6:	639c                	ld	a5,0(a5)
    800026b8:	02f707b3          	mul	a5,a4,a5
    800026bc:	2781                	sext.w	a5,a5
    800026be:	2785                	addiw	a5,a5,1
    800026c0:	2781                	sext.w	a5,a5
    800026c2:	00d7979b          	slliw	a5,a5,0xd
    800026c6:	2781                	sext.w	a5,a5
    800026c8:	873e                	mv	a4,a5
    800026ca:	040007b7          	lui	a5,0x4000
    800026ce:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    800026d0:	07b2                	slli	a5,a5,0xc
    800026d2:	8f99                	sub	a5,a5,a4
    800026d4:	fcf43c23          	sd	a5,-40(s0)
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800026d8:	fe043783          	ld	a5,-32(s0)
    800026dc:	4719                	li	a4,6
    800026de:	6685                	lui	a3,0x1
    800026e0:	863e                	mv	a2,a5
    800026e2:	fd843583          	ld	a1,-40(s0)
    800026e6:	fc843503          	ld	a0,-56(s0)
    800026ea:	fffff097          	auipc	ra,0xfffff
    800026ee:	53e080e7          	jalr	1342(ra) # 80001c28 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800026f2:	fe843783          	ld	a5,-24(s0)
    800026f6:	16878793          	addi	a5,a5,360
    800026fa:	fef43423          	sd	a5,-24(s0)
    800026fe:	fe843703          	ld	a4,-24(s0)
    80002702:	0001a797          	auipc	a5,0x1a
    80002706:	80678793          	addi	a5,a5,-2042 # 8001bf08 <pid_lock>
    8000270a:	f6f767e3          	bltu	a4,a5,80002678 <proc_mapstacks+0x1a>
  }
}
    8000270e:	0001                	nop
    80002710:	0001                	nop
    80002712:	70e2                	ld	ra,56(sp)
    80002714:	7442                	ld	s0,48(sp)
    80002716:	6121                	addi	sp,sp,64
    80002718:	8082                	ret

000000008000271a <procinit>:

// initialize the proc table.
void
procinit(void)
{
    8000271a:	1101                	addi	sp,sp,-32
    8000271c:	ec06                	sd	ra,24(sp)
    8000271e:	e822                	sd	s0,16(sp)
    80002720:	1000                	addi	s0,sp,32
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80002722:	00009597          	auipc	a1,0x9
    80002726:	aa658593          	addi	a1,a1,-1370 # 8000b1c8 <etext+0x1c8>
    8000272a:	00019517          	auipc	a0,0x19
    8000272e:	7de50513          	addi	a0,a0,2014 # 8001bf08 <pid_lock>
    80002732:	fffff097          	auipc	ra,0xfffff
    80002736:	b1c080e7          	jalr	-1252(ra) # 8000124e <initlock>
  initlock(&wait_lock, "wait_lock");
    8000273a:	00009597          	auipc	a1,0x9
    8000273e:	a9658593          	addi	a1,a1,-1386 # 8000b1d0 <etext+0x1d0>
    80002742:	00019517          	auipc	a0,0x19
    80002746:	7de50513          	addi	a0,a0,2014 # 8001bf20 <wait_lock>
    8000274a:	fffff097          	auipc	ra,0xfffff
    8000274e:	b04080e7          	jalr	-1276(ra) # 8000124e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002752:	00014797          	auipc	a5,0x14
    80002756:	db678793          	addi	a5,a5,-586 # 80016508 <proc>
    8000275a:	fef43423          	sd	a5,-24(s0)
    8000275e:	a0bd                	j	800027cc <procinit+0xb2>
      initlock(&p->lock, "proc");
    80002760:	fe843783          	ld	a5,-24(s0)
    80002764:	00009597          	auipc	a1,0x9
    80002768:	a7c58593          	addi	a1,a1,-1412 # 8000b1e0 <etext+0x1e0>
    8000276c:	853e                	mv	a0,a5
    8000276e:	fffff097          	auipc	ra,0xfffff
    80002772:	ae0080e7          	jalr	-1312(ra) # 8000124e <initlock>
      p->state = UNUSED;
    80002776:	fe843783          	ld	a5,-24(s0)
    8000277a:	0007ac23          	sw	zero,24(a5)
      p->kstack = KSTACK((int) (p - proc));
    8000277e:	fe843703          	ld	a4,-24(s0)
    80002782:	00014797          	auipc	a5,0x14
    80002786:	d8678793          	addi	a5,a5,-634 # 80016508 <proc>
    8000278a:	40f707b3          	sub	a5,a4,a5
    8000278e:	4037d713          	srai	a4,a5,0x3
    80002792:	00009797          	auipc	a5,0x9
    80002796:	b3678793          	addi	a5,a5,-1226 # 8000b2c8 <etext+0x2c8>
    8000279a:	639c                	ld	a5,0(a5)
    8000279c:	02f707b3          	mul	a5,a4,a5
    800027a0:	2781                	sext.w	a5,a5
    800027a2:	2785                	addiw	a5,a5,1
    800027a4:	2781                	sext.w	a5,a5
    800027a6:	00d7979b          	slliw	a5,a5,0xd
    800027aa:	2781                	sext.w	a5,a5
    800027ac:	873e                	mv	a4,a5
    800027ae:	040007b7          	lui	a5,0x4000
    800027b2:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    800027b4:	07b2                	slli	a5,a5,0xc
    800027b6:	8f99                	sub	a5,a5,a4
    800027b8:	873e                	mv	a4,a5
    800027ba:	fe843783          	ld	a5,-24(s0)
    800027be:	e3b8                	sd	a4,64(a5)
  for(p = proc; p < &proc[NPROC]; p++) {
    800027c0:	fe843783          	ld	a5,-24(s0)
    800027c4:	16878793          	addi	a5,a5,360
    800027c8:	fef43423          	sd	a5,-24(s0)
    800027cc:	fe843703          	ld	a4,-24(s0)
    800027d0:	00019797          	auipc	a5,0x19
    800027d4:	73878793          	addi	a5,a5,1848 # 8001bf08 <pid_lock>
    800027d8:	f8f764e3          	bltu	a4,a5,80002760 <procinit+0x46>
  }
}
    800027dc:	0001                	nop
    800027de:	0001                	nop
    800027e0:	60e2                	ld	ra,24(sp)
    800027e2:	6442                	ld	s0,16(sp)
    800027e4:	6105                	addi	sp,sp,32
    800027e6:	8082                	ret

00000000800027e8 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800027e8:	1101                	addi	sp,sp,-32
    800027ea:	ec06                	sd	ra,24(sp)
    800027ec:	e822                	sd	s0,16(sp)
    800027ee:	1000                	addi	s0,sp,32
  int id = r_tp();
    800027f0:	00000097          	auipc	ra,0x0
    800027f4:	e56080e7          	jalr	-426(ra) # 80002646 <r_tp>
    800027f8:	87aa                	mv	a5,a0
    800027fa:	fef42623          	sw	a5,-20(s0)
  return id;
    800027fe:	fec42783          	lw	a5,-20(s0)
}
    80002802:	853e                	mv	a0,a5
    80002804:	60e2                	ld	ra,24(sp)
    80002806:	6442                	ld	s0,16(sp)
    80002808:	6105                	addi	sp,sp,32
    8000280a:	8082                	ret

000000008000280c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    8000280c:	1101                	addi	sp,sp,-32
    8000280e:	ec06                	sd	ra,24(sp)
    80002810:	e822                	sd	s0,16(sp)
    80002812:	1000                	addi	s0,sp,32
  int id = cpuid();
    80002814:	00000097          	auipc	ra,0x0
    80002818:	fd4080e7          	jalr	-44(ra) # 800027e8 <cpuid>
    8000281c:	87aa                	mv	a5,a0
    8000281e:	fef42623          	sw	a5,-20(s0)
  struct cpu *c = &cpus[id];
    80002822:	fec42783          	lw	a5,-20(s0)
    80002826:	00779713          	slli	a4,a5,0x7
    8000282a:	00014797          	auipc	a5,0x14
    8000282e:	8de78793          	addi	a5,a5,-1826 # 80016108 <cpus>
    80002832:	97ba                	add	a5,a5,a4
    80002834:	fef43023          	sd	a5,-32(s0)
  return c;
    80002838:	fe043783          	ld	a5,-32(s0)
}
    8000283c:	853e                	mv	a0,a5
    8000283e:	60e2                	ld	ra,24(sp)
    80002840:	6442                	ld	s0,16(sp)
    80002842:	6105                	addi	sp,sp,32
    80002844:	8082                	ret

0000000080002846 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80002846:	1101                	addi	sp,sp,-32
    80002848:	ec06                	sd	ra,24(sp)
    8000284a:	e822                	sd	s0,16(sp)
    8000284c:	1000                	addi	s0,sp,32
  push_off();
    8000284e:	fffff097          	auipc	ra,0xfffff
    80002852:	b2e080e7          	jalr	-1234(ra) # 8000137c <push_off>
  struct cpu *c = mycpu();
    80002856:	00000097          	auipc	ra,0x0
    8000285a:	fb6080e7          	jalr	-74(ra) # 8000280c <mycpu>
    8000285e:	fea43423          	sd	a0,-24(s0)
  struct proc *p = c->proc;
    80002862:	fe843783          	ld	a5,-24(s0)
    80002866:	639c                	ld	a5,0(a5)
    80002868:	fef43023          	sd	a5,-32(s0)
  pop_off();
    8000286c:	fffff097          	auipc	ra,0xfffff
    80002870:	b68080e7          	jalr	-1176(ra) # 800013d4 <pop_off>
  return p;
    80002874:	fe043783          	ld	a5,-32(s0)
}
    80002878:	853e                	mv	a0,a5
    8000287a:	60e2                	ld	ra,24(sp)
    8000287c:	6442                	ld	s0,16(sp)
    8000287e:	6105                	addi	sp,sp,32
    80002880:	8082                	ret

0000000080002882 <allocpid>:

int
allocpid()
{
    80002882:	1101                	addi	sp,sp,-32
    80002884:	ec06                	sd	ra,24(sp)
    80002886:	e822                	sd	s0,16(sp)
    80002888:	1000                	addi	s0,sp,32
  int pid;
  
  acquire(&pid_lock);
    8000288a:	00019517          	auipc	a0,0x19
    8000288e:	67e50513          	addi	a0,a0,1662 # 8001bf08 <pid_lock>
    80002892:	fffff097          	auipc	ra,0xfffff
    80002896:	9ec080e7          	jalr	-1556(ra) # 8000127e <acquire>
  pid = nextpid;
    8000289a:	0000b797          	auipc	a5,0xb
    8000289e:	46678793          	addi	a5,a5,1126 # 8000dd00 <nextpid>
    800028a2:	439c                	lw	a5,0(a5)
    800028a4:	fef42623          	sw	a5,-20(s0)
  nextpid = nextpid + 1;
    800028a8:	0000b797          	auipc	a5,0xb
    800028ac:	45878793          	addi	a5,a5,1112 # 8000dd00 <nextpid>
    800028b0:	439c                	lw	a5,0(a5)
    800028b2:	2785                	addiw	a5,a5,1
    800028b4:	0007871b          	sext.w	a4,a5
    800028b8:	0000b797          	auipc	a5,0xb
    800028bc:	44878793          	addi	a5,a5,1096 # 8000dd00 <nextpid>
    800028c0:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800028c2:	00019517          	auipc	a0,0x19
    800028c6:	64650513          	addi	a0,a0,1606 # 8001bf08 <pid_lock>
    800028ca:	fffff097          	auipc	ra,0xfffff
    800028ce:	a18080e7          	jalr	-1512(ra) # 800012e2 <release>

  return pid;
    800028d2:	fec42783          	lw	a5,-20(s0)
}
    800028d6:	853e                	mv	a0,a5
    800028d8:	60e2                	ld	ra,24(sp)
    800028da:	6442                	ld	s0,16(sp)
    800028dc:	6105                	addi	sp,sp,32
    800028de:	8082                	ret

00000000800028e0 <allocproc>:
// If found, initialize state required to run in the kernel,
// and return with p->lock held.
// If there are no free procs, or a memory allocation fails, return 0.
static struct proc*
allocproc(void)
{
    800028e0:	1101                	addi	sp,sp,-32
    800028e2:	ec06                	sd	ra,24(sp)
    800028e4:	e822                	sd	s0,16(sp)
    800028e6:	1000                	addi	s0,sp,32
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800028e8:	00014797          	auipc	a5,0x14
    800028ec:	c2078793          	addi	a5,a5,-992 # 80016508 <proc>
    800028f0:	fef43423          	sd	a5,-24(s0)
    800028f4:	a80d                	j	80002926 <allocproc+0x46>
    acquire(&p->lock);
    800028f6:	fe843783          	ld	a5,-24(s0)
    800028fa:	853e                	mv	a0,a5
    800028fc:	fffff097          	auipc	ra,0xfffff
    80002900:	982080e7          	jalr	-1662(ra) # 8000127e <acquire>
    if(p->state == UNUSED) {
    80002904:	fe843783          	ld	a5,-24(s0)
    80002908:	4f9c                	lw	a5,24(a5)
    8000290a:	cb85                	beqz	a5,8000293a <allocproc+0x5a>
      goto found;
    } else {
      release(&p->lock);
    8000290c:	fe843783          	ld	a5,-24(s0)
    80002910:	853e                	mv	a0,a5
    80002912:	fffff097          	auipc	ra,0xfffff
    80002916:	9d0080e7          	jalr	-1584(ra) # 800012e2 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000291a:	fe843783          	ld	a5,-24(s0)
    8000291e:	16878793          	addi	a5,a5,360
    80002922:	fef43423          	sd	a5,-24(s0)
    80002926:	fe843703          	ld	a4,-24(s0)
    8000292a:	00019797          	auipc	a5,0x19
    8000292e:	5de78793          	addi	a5,a5,1502 # 8001bf08 <pid_lock>
    80002932:	fcf762e3          	bltu	a4,a5,800028f6 <allocproc+0x16>
    }
  }
  return 0;
    80002936:	4781                	li	a5,0
    80002938:	a0e1                	j	80002a00 <allocproc+0x120>
      goto found;
    8000293a:	0001                	nop

found:
  p->pid = allocpid();
    8000293c:	00000097          	auipc	ra,0x0
    80002940:	f46080e7          	jalr	-186(ra) # 80002882 <allocpid>
    80002944:	87aa                	mv	a5,a0
    80002946:	873e                	mv	a4,a5
    80002948:	fe843783          	ld	a5,-24(s0)
    8000294c:	db98                	sw	a4,48(a5)
  p->state = USED;
    8000294e:	fe843783          	ld	a5,-24(s0)
    80002952:	4705                	li	a4,1
    80002954:	cf98                	sw	a4,24(a5)

  // Allocate a trapframe page.
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80002956:	ffffe097          	auipc	ra,0xffffe
    8000295a:	7d4080e7          	jalr	2004(ra) # 8000112a <kalloc>
    8000295e:	872a                	mv	a4,a0
    80002960:	fe843783          	ld	a5,-24(s0)
    80002964:	efb8                	sd	a4,88(a5)
    80002966:	fe843783          	ld	a5,-24(s0)
    8000296a:	6fbc                	ld	a5,88(a5)
    8000296c:	e385                	bnez	a5,8000298c <allocproc+0xac>
    freeproc(p);
    8000296e:	fe843503          	ld	a0,-24(s0)
    80002972:	00000097          	auipc	ra,0x0
    80002976:	098080e7          	jalr	152(ra) # 80002a0a <freeproc>
    release(&p->lock);
    8000297a:	fe843783          	ld	a5,-24(s0)
    8000297e:	853e                	mv	a0,a5
    80002980:	fffff097          	auipc	ra,0xfffff
    80002984:	962080e7          	jalr	-1694(ra) # 800012e2 <release>
    return 0;
    80002988:	4781                	li	a5,0
    8000298a:	a89d                	j	80002a00 <allocproc+0x120>
  }

  // An empty user page table.
  p->pagetable = proc_pagetable(p);
    8000298c:	fe843503          	ld	a0,-24(s0)
    80002990:	00000097          	auipc	ra,0x0
    80002994:	118080e7          	jalr	280(ra) # 80002aa8 <proc_pagetable>
    80002998:	872a                	mv	a4,a0
    8000299a:	fe843783          	ld	a5,-24(s0)
    8000299e:	ebb8                	sd	a4,80(a5)
  if(p->pagetable == 0){
    800029a0:	fe843783          	ld	a5,-24(s0)
    800029a4:	6bbc                	ld	a5,80(a5)
    800029a6:	e385                	bnez	a5,800029c6 <allocproc+0xe6>
    freeproc(p);
    800029a8:	fe843503          	ld	a0,-24(s0)
    800029ac:	00000097          	auipc	ra,0x0
    800029b0:	05e080e7          	jalr	94(ra) # 80002a0a <freeproc>
    release(&p->lock);
    800029b4:	fe843783          	ld	a5,-24(s0)
    800029b8:	853e                	mv	a0,a5
    800029ba:	fffff097          	auipc	ra,0xfffff
    800029be:	928080e7          	jalr	-1752(ra) # 800012e2 <release>
    return 0;
    800029c2:	4781                	li	a5,0
    800029c4:	a835                	j	80002a00 <allocproc+0x120>
  }

  // Set up new context to start executing at forkret,
  // which returns to user space.
  memset(&p->context, 0, sizeof(p->context));
    800029c6:	fe843783          	ld	a5,-24(s0)
    800029ca:	06078793          	addi	a5,a5,96
    800029ce:	07000613          	li	a2,112
    800029d2:	4581                	li	a1,0
    800029d4:	853e                	mv	a0,a5
    800029d6:	fffff097          	auipc	ra,0xfffff
    800029da:	a7c080e7          	jalr	-1412(ra) # 80001452 <memset>
  p->context.ra = (uint64)forkret;
    800029de:	00001717          	auipc	a4,0x1
    800029e2:	9da70713          	addi	a4,a4,-1574 # 800033b8 <forkret>
    800029e6:	fe843783          	ld	a5,-24(s0)
    800029ea:	f3b8                	sd	a4,96(a5)
  p->context.sp = p->kstack + PGSIZE;
    800029ec:	fe843783          	ld	a5,-24(s0)
    800029f0:	63b8                	ld	a4,64(a5)
    800029f2:	6785                	lui	a5,0x1
    800029f4:	973e                	add	a4,a4,a5
    800029f6:	fe843783          	ld	a5,-24(s0)
    800029fa:	f7b8                	sd	a4,104(a5)

  return p;
    800029fc:	fe843783          	ld	a5,-24(s0)
}
    80002a00:	853e                	mv	a0,a5
    80002a02:	60e2                	ld	ra,24(sp)
    80002a04:	6442                	ld	s0,16(sp)
    80002a06:	6105                	addi	sp,sp,32
    80002a08:	8082                	ret

0000000080002a0a <freeproc>:
// free a proc structure and the data hanging from it,
// including user pages.
// p->lock must be held.
static void
freeproc(struct proc *p)
{
    80002a0a:	1101                	addi	sp,sp,-32
    80002a0c:	ec06                	sd	ra,24(sp)
    80002a0e:	e822                	sd	s0,16(sp)
    80002a10:	1000                	addi	s0,sp,32
    80002a12:	fea43423          	sd	a0,-24(s0)
  if(p->trapframe)
    80002a16:	fe843783          	ld	a5,-24(s0)
    80002a1a:	6fbc                	ld	a5,88(a5)
    80002a1c:	cb89                	beqz	a5,80002a2e <freeproc+0x24>
    kfree((void*)p->trapframe);
    80002a1e:	fe843783          	ld	a5,-24(s0)
    80002a22:	6fbc                	ld	a5,88(a5)
    80002a24:	853e                	mv	a0,a5
    80002a26:	ffffe097          	auipc	ra,0xffffe
    80002a2a:	660080e7          	jalr	1632(ra) # 80001086 <kfree>
  p->trapframe = 0;
    80002a2e:	fe843783          	ld	a5,-24(s0)
    80002a32:	0407bc23          	sd	zero,88(a5) # 1058 <_entry-0x7fffefa8>
  if(p->pagetable)
    80002a36:	fe843783          	ld	a5,-24(s0)
    80002a3a:	6bbc                	ld	a5,80(a5)
    80002a3c:	cf89                	beqz	a5,80002a56 <freeproc+0x4c>
    proc_freepagetable(p->pagetable, p->sz);
    80002a3e:	fe843783          	ld	a5,-24(s0)
    80002a42:	6bb8                	ld	a4,80(a5)
    80002a44:	fe843783          	ld	a5,-24(s0)
    80002a48:	67bc                	ld	a5,72(a5)
    80002a4a:	85be                	mv	a1,a5
    80002a4c:	853a                	mv	a0,a4
    80002a4e:	00000097          	auipc	ra,0x0
    80002a52:	11a080e7          	jalr	282(ra) # 80002b68 <proc_freepagetable>
  p->pagetable = 0;
    80002a56:	fe843783          	ld	a5,-24(s0)
    80002a5a:	0407b823          	sd	zero,80(a5)
  p->sz = 0;
    80002a5e:	fe843783          	ld	a5,-24(s0)
    80002a62:	0407b423          	sd	zero,72(a5)
  p->pid = 0;
    80002a66:	fe843783          	ld	a5,-24(s0)
    80002a6a:	0207a823          	sw	zero,48(a5)
  p->parent = 0;
    80002a6e:	fe843783          	ld	a5,-24(s0)
    80002a72:	0207bc23          	sd	zero,56(a5)
  p->name[0] = 0;
    80002a76:	fe843783          	ld	a5,-24(s0)
    80002a7a:	14078c23          	sb	zero,344(a5)
  p->chan = 0;
    80002a7e:	fe843783          	ld	a5,-24(s0)
    80002a82:	0207b023          	sd	zero,32(a5)
  p->killed = 0;
    80002a86:	fe843783          	ld	a5,-24(s0)
    80002a8a:	0207a423          	sw	zero,40(a5)
  p->xstate = 0;
    80002a8e:	fe843783          	ld	a5,-24(s0)
    80002a92:	0207a623          	sw	zero,44(a5)
  p->state = UNUSED;
    80002a96:	fe843783          	ld	a5,-24(s0)
    80002a9a:	0007ac23          	sw	zero,24(a5)
}
    80002a9e:	0001                	nop
    80002aa0:	60e2                	ld	ra,24(sp)
    80002aa2:	6442                	ld	s0,16(sp)
    80002aa4:	6105                	addi	sp,sp,32
    80002aa6:	8082                	ret

0000000080002aa8 <proc_pagetable>:

// Create a user page table for a given process, with no user memory,
// but with trampoline and trapframe pages.
pagetable_t
proc_pagetable(struct proc *p)
{
    80002aa8:	7179                	addi	sp,sp,-48
    80002aaa:	f406                	sd	ra,40(sp)
    80002aac:	f022                	sd	s0,32(sp)
    80002aae:	1800                	addi	s0,sp,48
    80002ab0:	fca43c23          	sd	a0,-40(s0)
  pagetable_t pagetable;

  // An empty page table.
  pagetable = uvmcreate();
    80002ab4:	fffff097          	auipc	ra,0xfffff
    80002ab8:	3ac080e7          	jalr	940(ra) # 80001e60 <uvmcreate>
    80002abc:	fea43423          	sd	a0,-24(s0)
  if(pagetable == 0)
    80002ac0:	fe843783          	ld	a5,-24(s0)
    80002ac4:	e399                	bnez	a5,80002aca <proc_pagetable+0x22>
    return 0;
    80002ac6:	4781                	li	a5,0
    80002ac8:	a859                	j	80002b5e <proc_pagetable+0xb6>

  // map the trampoline code (for system call return)
  // at the highest user virtual address.
  // only the supervisor uses it, on the way
  // to/from user space, so not PTE_U.
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80002aca:	00007797          	auipc	a5,0x7
    80002ace:	53678793          	addi	a5,a5,1334 # 8000a000 <_trampoline>
    80002ad2:	4729                	li	a4,10
    80002ad4:	86be                	mv	a3,a5
    80002ad6:	6605                	lui	a2,0x1
    80002ad8:	040007b7          	lui	a5,0x4000
    80002adc:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002ade:	00c79593          	slli	a1,a5,0xc
    80002ae2:	fe843503          	ld	a0,-24(s0)
    80002ae6:	fffff097          	auipc	ra,0xfffff
    80002aea:	19c080e7          	jalr	412(ra) # 80001c82 <mappages>
    80002aee:	87aa                	mv	a5,a0
    80002af0:	0007db63          	bgez	a5,80002b06 <proc_pagetable+0x5e>
              (uint64)trampoline, PTE_R | PTE_X) < 0){
    uvmfree(pagetable, 0);
    80002af4:	4581                	li	a1,0
    80002af6:	fe843503          	ld	a0,-24(s0)
    80002afa:	fffff097          	auipc	ra,0xfffff
    80002afe:	662080e7          	jalr	1634(ra) # 8000215c <uvmfree>
    return 0;
    80002b02:	4781                	li	a5,0
    80002b04:	a8a9                	j	80002b5e <proc_pagetable+0xb6>
  }

  // map the trapframe page just below the trampoline page, for
  // trampoline.S.
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
              (uint64)(p->trapframe), PTE_R | PTE_W) < 0){
    80002b06:	fd843783          	ld	a5,-40(s0)
    80002b0a:	6fbc                	ld	a5,88(a5)
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80002b0c:	4719                	li	a4,6
    80002b0e:	86be                	mv	a3,a5
    80002b10:	6605                	lui	a2,0x1
    80002b12:	020007b7          	lui	a5,0x2000
    80002b16:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80002b18:	00d79593          	slli	a1,a5,0xd
    80002b1c:	fe843503          	ld	a0,-24(s0)
    80002b20:	fffff097          	auipc	ra,0xfffff
    80002b24:	162080e7          	jalr	354(ra) # 80001c82 <mappages>
    80002b28:	87aa                	mv	a5,a0
    80002b2a:	0207d863          	bgez	a5,80002b5a <proc_pagetable+0xb2>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80002b2e:	4681                	li	a3,0
    80002b30:	4605                	li	a2,1
    80002b32:	040007b7          	lui	a5,0x4000
    80002b36:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002b38:	00c79593          	slli	a1,a5,0xc
    80002b3c:	fe843503          	ld	a0,-24(s0)
    80002b40:	fffff097          	auipc	ra,0xfffff
    80002b44:	220080e7          	jalr	544(ra) # 80001d60 <uvmunmap>
    uvmfree(pagetable, 0);
    80002b48:	4581                	li	a1,0
    80002b4a:	fe843503          	ld	a0,-24(s0)
    80002b4e:	fffff097          	auipc	ra,0xfffff
    80002b52:	60e080e7          	jalr	1550(ra) # 8000215c <uvmfree>
    return 0;
    80002b56:	4781                	li	a5,0
    80002b58:	a019                	j	80002b5e <proc_pagetable+0xb6>
  }

  return pagetable;
    80002b5a:	fe843783          	ld	a5,-24(s0)
}
    80002b5e:	853e                	mv	a0,a5
    80002b60:	70a2                	ld	ra,40(sp)
    80002b62:	7402                	ld	s0,32(sp)
    80002b64:	6145                	addi	sp,sp,48
    80002b66:	8082                	ret

0000000080002b68 <proc_freepagetable>:

// Free a process's page table, and free the
// physical memory it refers to.
void
proc_freepagetable(pagetable_t pagetable, uint64 sz)
{
    80002b68:	1101                	addi	sp,sp,-32
    80002b6a:	ec06                	sd	ra,24(sp)
    80002b6c:	e822                	sd	s0,16(sp)
    80002b6e:	1000                	addi	s0,sp,32
    80002b70:	fea43423          	sd	a0,-24(s0)
    80002b74:	feb43023          	sd	a1,-32(s0)
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80002b78:	4681                	li	a3,0
    80002b7a:	4605                	li	a2,1
    80002b7c:	040007b7          	lui	a5,0x4000
    80002b80:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002b82:	00c79593          	slli	a1,a5,0xc
    80002b86:	fe843503          	ld	a0,-24(s0)
    80002b8a:	fffff097          	auipc	ra,0xfffff
    80002b8e:	1d6080e7          	jalr	470(ra) # 80001d60 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80002b92:	4681                	li	a3,0
    80002b94:	4605                	li	a2,1
    80002b96:	020007b7          	lui	a5,0x2000
    80002b9a:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80002b9c:	00d79593          	slli	a1,a5,0xd
    80002ba0:	fe843503          	ld	a0,-24(s0)
    80002ba4:	fffff097          	auipc	ra,0xfffff
    80002ba8:	1bc080e7          	jalr	444(ra) # 80001d60 <uvmunmap>
  uvmfree(pagetable, sz);
    80002bac:	fe043583          	ld	a1,-32(s0)
    80002bb0:	fe843503          	ld	a0,-24(s0)
    80002bb4:	fffff097          	auipc	ra,0xfffff
    80002bb8:	5a8080e7          	jalr	1448(ra) # 8000215c <uvmfree>
}
    80002bbc:	0001                	nop
    80002bbe:	60e2                	ld	ra,24(sp)
    80002bc0:	6442                	ld	s0,16(sp)
    80002bc2:	6105                	addi	sp,sp,32
    80002bc4:	8082                	ret

0000000080002bc6 <userinit>:
};

// Set up first user process.
void
userinit(void)
{
    80002bc6:	1101                	addi	sp,sp,-32
    80002bc8:	ec06                	sd	ra,24(sp)
    80002bca:	e822                	sd	s0,16(sp)
    80002bcc:	1000                	addi	s0,sp,32
  struct proc *p;

  p = allocproc();
    80002bce:	00000097          	auipc	ra,0x0
    80002bd2:	d12080e7          	jalr	-750(ra) # 800028e0 <allocproc>
    80002bd6:	fea43423          	sd	a0,-24(s0)
  initproc = p;
    80002bda:	0000b797          	auipc	a5,0xb
    80002bde:	2b678793          	addi	a5,a5,694 # 8000de90 <initproc>
    80002be2:	fe843703          	ld	a4,-24(s0)
    80002be6:	e398                	sd	a4,0(a5)
  
  // allocate one user page and copy initcode's instructions
  // and data into it.
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80002be8:	fe843783          	ld	a5,-24(s0)
    80002bec:	6bbc                	ld	a5,80(a5)
    80002bee:	03400613          	li	a2,52
    80002bf2:	0000b597          	auipc	a1,0xb
    80002bf6:	13658593          	addi	a1,a1,310 # 8000dd28 <initcode>
    80002bfa:	853e                	mv	a0,a5
    80002bfc:	fffff097          	auipc	ra,0xfffff
    80002c00:	2a0080e7          	jalr	672(ra) # 80001e9c <uvmfirst>
  p->sz = PGSIZE;
    80002c04:	fe843783          	ld	a5,-24(s0)
    80002c08:	6705                	lui	a4,0x1
    80002c0a:	e7b8                	sd	a4,72(a5)

  // prepare for the very first "return" from kernel to user.
  p->trapframe->epc = 0;      // user program counter
    80002c0c:	fe843783          	ld	a5,-24(s0)
    80002c10:	6fbc                	ld	a5,88(a5)
    80002c12:	0007bc23          	sd	zero,24(a5)
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80002c16:	fe843783          	ld	a5,-24(s0)
    80002c1a:	6fbc                	ld	a5,88(a5)
    80002c1c:	6705                	lui	a4,0x1
    80002c1e:	fb98                	sd	a4,48(a5)

  safestrcpy(p->name, "initcode", sizeof(p->name));
    80002c20:	fe843783          	ld	a5,-24(s0)
    80002c24:	15878793          	addi	a5,a5,344
    80002c28:	4641                	li	a2,16
    80002c2a:	00008597          	auipc	a1,0x8
    80002c2e:	5be58593          	addi	a1,a1,1470 # 8000b1e8 <etext+0x1e8>
    80002c32:	853e                	mv	a0,a5
    80002c34:	fffff097          	auipc	ra,0xfffff
    80002c38:	b22080e7          	jalr	-1246(ra) # 80001756 <safestrcpy>
  p->cwd = namei("/");
    80002c3c:	00008517          	auipc	a0,0x8
    80002c40:	5bc50513          	addi	a0,a0,1468 # 8000b1f8 <etext+0x1f8>
    80002c44:	00003097          	auipc	ra,0x3
    80002c48:	1a2080e7          	jalr	418(ra) # 80005de6 <namei>
    80002c4c:	872a                	mv	a4,a0
    80002c4e:	fe843783          	ld	a5,-24(s0)
    80002c52:	14e7b823          	sd	a4,336(a5)

  p->state = RUNNABLE;
    80002c56:	fe843783          	ld	a5,-24(s0)
    80002c5a:	470d                	li	a4,3
    80002c5c:	cf98                	sw	a4,24(a5)

  release(&p->lock);
    80002c5e:	fe843783          	ld	a5,-24(s0)
    80002c62:	853e                	mv	a0,a5
    80002c64:	ffffe097          	auipc	ra,0xffffe
    80002c68:	67e080e7          	jalr	1662(ra) # 800012e2 <release>
}
    80002c6c:	0001                	nop
    80002c6e:	60e2                	ld	ra,24(sp)
    80002c70:	6442                	ld	s0,16(sp)
    80002c72:	6105                	addi	sp,sp,32
    80002c74:	8082                	ret

0000000080002c76 <growproc>:

// Grow or shrink user memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
    80002c76:	7179                	addi	sp,sp,-48
    80002c78:	f406                	sd	ra,40(sp)
    80002c7a:	f022                	sd	s0,32(sp)
    80002c7c:	1800                	addi	s0,sp,48
    80002c7e:	87aa                	mv	a5,a0
    80002c80:	fcf42e23          	sw	a5,-36(s0)
  uint64 sz;
  struct proc *p = myproc();
    80002c84:	00000097          	auipc	ra,0x0
    80002c88:	bc2080e7          	jalr	-1086(ra) # 80002846 <myproc>
    80002c8c:	fea43023          	sd	a0,-32(s0)

  sz = p->sz;
    80002c90:	fe043783          	ld	a5,-32(s0)
    80002c94:	67bc                	ld	a5,72(a5)
    80002c96:	fef43423          	sd	a5,-24(s0)
  if(n > 0){
    80002c9a:	fdc42783          	lw	a5,-36(s0)
    80002c9e:	2781                	sext.w	a5,a5
    80002ca0:	02f05963          	blez	a5,80002cd2 <growproc+0x5c>
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80002ca4:	fe043783          	ld	a5,-32(s0)
    80002ca8:	6ba8                	ld	a0,80(a5)
    80002caa:	fdc42703          	lw	a4,-36(s0)
    80002cae:	fe843783          	ld	a5,-24(s0)
    80002cb2:	97ba                	add	a5,a5,a4
    80002cb4:	4691                	li	a3,4
    80002cb6:	863e                	mv	a2,a5
    80002cb8:	fe843583          	ld	a1,-24(s0)
    80002cbc:	fffff097          	auipc	ra,0xfffff
    80002cc0:	268080e7          	jalr	616(ra) # 80001f24 <uvmalloc>
    80002cc4:	fea43423          	sd	a0,-24(s0)
    80002cc8:	fe843783          	ld	a5,-24(s0)
    80002ccc:	eb95                	bnez	a5,80002d00 <growproc+0x8a>
      return -1;
    80002cce:	57fd                	li	a5,-1
    80002cd0:	a835                	j	80002d0c <growproc+0x96>
    }
  } else if(n < 0){
    80002cd2:	fdc42783          	lw	a5,-36(s0)
    80002cd6:	2781                	sext.w	a5,a5
    80002cd8:	0207d463          	bgez	a5,80002d00 <growproc+0x8a>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80002cdc:	fe043783          	ld	a5,-32(s0)
    80002ce0:	6bb4                	ld	a3,80(a5)
    80002ce2:	fdc42703          	lw	a4,-36(s0)
    80002ce6:	fe843783          	ld	a5,-24(s0)
    80002cea:	97ba                	add	a5,a5,a4
    80002cec:	863e                	mv	a2,a5
    80002cee:	fe843583          	ld	a1,-24(s0)
    80002cf2:	8536                	mv	a0,a3
    80002cf4:	fffff097          	auipc	ra,0xfffff
    80002cf8:	322080e7          	jalr	802(ra) # 80002016 <uvmdealloc>
    80002cfc:	fea43423          	sd	a0,-24(s0)
  }
  p->sz = sz;
    80002d00:	fe043783          	ld	a5,-32(s0)
    80002d04:	fe843703          	ld	a4,-24(s0)
    80002d08:	e7b8                	sd	a4,72(a5)
  return 0;
    80002d0a:	4781                	li	a5,0
}
    80002d0c:	853e                	mv	a0,a5
    80002d0e:	70a2                	ld	ra,40(sp)
    80002d10:	7402                	ld	s0,32(sp)
    80002d12:	6145                	addi	sp,sp,48
    80002d14:	8082                	ret

0000000080002d16 <fork>:

// Create a new process, copying the parent.
// Sets up child kernel stack to return as if from fork() system call.
int
fork(void)
{
    80002d16:	7179                	addi	sp,sp,-48
    80002d18:	f406                	sd	ra,40(sp)
    80002d1a:	f022                	sd	s0,32(sp)
    80002d1c:	1800                	addi	s0,sp,48
  int i, pid;
  struct proc *np;
  struct proc *p = myproc();
    80002d1e:	00000097          	auipc	ra,0x0
    80002d22:	b28080e7          	jalr	-1240(ra) # 80002846 <myproc>
    80002d26:	fea43023          	sd	a0,-32(s0)

  // Allocate process.
  if((np = allocproc()) == 0){
    80002d2a:	00000097          	auipc	ra,0x0
    80002d2e:	bb6080e7          	jalr	-1098(ra) # 800028e0 <allocproc>
    80002d32:	fca43c23          	sd	a0,-40(s0)
    80002d36:	fd843783          	ld	a5,-40(s0)
    80002d3a:	e399                	bnez	a5,80002d40 <fork+0x2a>
    return -1;
    80002d3c:	57fd                	li	a5,-1
    80002d3e:	aab5                	j	80002eba <fork+0x1a4>
  }

  // Copy user memory from parent to child.
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80002d40:	fe043783          	ld	a5,-32(s0)
    80002d44:	6bb8                	ld	a4,80(a5)
    80002d46:	fd843783          	ld	a5,-40(s0)
    80002d4a:	6bb4                	ld	a3,80(a5)
    80002d4c:	fe043783          	ld	a5,-32(s0)
    80002d50:	67bc                	ld	a5,72(a5)
    80002d52:	863e                	mv	a2,a5
    80002d54:	85b6                	mv	a1,a3
    80002d56:	853a                	mv	a0,a4
    80002d58:	fffff097          	auipc	ra,0xfffff
    80002d5c:	44e080e7          	jalr	1102(ra) # 800021a6 <uvmcopy>
    80002d60:	87aa                	mv	a5,a0
    80002d62:	0207d163          	bgez	a5,80002d84 <fork+0x6e>
    freeproc(np);
    80002d66:	fd843503          	ld	a0,-40(s0)
    80002d6a:	00000097          	auipc	ra,0x0
    80002d6e:	ca0080e7          	jalr	-864(ra) # 80002a0a <freeproc>
    release(&np->lock);
    80002d72:	fd843783          	ld	a5,-40(s0)
    80002d76:	853e                	mv	a0,a5
    80002d78:	ffffe097          	auipc	ra,0xffffe
    80002d7c:	56a080e7          	jalr	1386(ra) # 800012e2 <release>
    return -1;
    80002d80:	57fd                	li	a5,-1
    80002d82:	aa25                	j	80002eba <fork+0x1a4>
  }
  np->sz = p->sz;
    80002d84:	fe043783          	ld	a5,-32(s0)
    80002d88:	67b8                	ld	a4,72(a5)
    80002d8a:	fd843783          	ld	a5,-40(s0)
    80002d8e:	e7b8                	sd	a4,72(a5)

  // copy saved user registers.
  *(np->trapframe) = *(p->trapframe);
    80002d90:	fe043783          	ld	a5,-32(s0)
    80002d94:	6fb8                	ld	a4,88(a5)
    80002d96:	fd843783          	ld	a5,-40(s0)
    80002d9a:	6fbc                	ld	a5,88(a5)
    80002d9c:	86be                	mv	a3,a5
    80002d9e:	12000793          	li	a5,288
    80002da2:	863e                	mv	a2,a5
    80002da4:	85ba                	mv	a1,a4
    80002da6:	8536                	mv	a0,a3
    80002da8:	fffff097          	auipc	ra,0xfffff
    80002dac:	86a080e7          	jalr	-1942(ra) # 80001612 <memcpy>

  // Cause fork to return 0 in the child.
  np->trapframe->a0 = 0;
    80002db0:	fd843783          	ld	a5,-40(s0)
    80002db4:	6fbc                	ld	a5,88(a5)
    80002db6:	0607b823          	sd	zero,112(a5)

  // increment reference counts on open file descriptors.
  for(i = 0; i < NOFILE; i++)
    80002dba:	fe042623          	sw	zero,-20(s0)
    80002dbe:	a0a9                	j	80002e08 <fork+0xf2>
    if(p->ofile[i])
    80002dc0:	fe043703          	ld	a4,-32(s0)
    80002dc4:	fec42783          	lw	a5,-20(s0)
    80002dc8:	07e9                	addi	a5,a5,26
    80002dca:	078e                	slli	a5,a5,0x3
    80002dcc:	97ba                	add	a5,a5,a4
    80002dce:	639c                	ld	a5,0(a5)
    80002dd0:	c79d                	beqz	a5,80002dfe <fork+0xe8>
      np->ofile[i] = filedup(p->ofile[i]);
    80002dd2:	fe043703          	ld	a4,-32(s0)
    80002dd6:	fec42783          	lw	a5,-20(s0)
    80002dda:	07e9                	addi	a5,a5,26
    80002ddc:	078e                	slli	a5,a5,0x3
    80002dde:	97ba                	add	a5,a5,a4
    80002de0:	639c                	ld	a5,0(a5)
    80002de2:	853e                	mv	a0,a5
    80002de4:	00004097          	auipc	ra,0x4
    80002de8:	99a080e7          	jalr	-1638(ra) # 8000677e <filedup>
    80002dec:	86aa                	mv	a3,a0
    80002dee:	fd843703          	ld	a4,-40(s0)
    80002df2:	fec42783          	lw	a5,-20(s0)
    80002df6:	07e9                	addi	a5,a5,26
    80002df8:	078e                	slli	a5,a5,0x3
    80002dfa:	97ba                	add	a5,a5,a4
    80002dfc:	e394                	sd	a3,0(a5)
  for(i = 0; i < NOFILE; i++)
    80002dfe:	fec42783          	lw	a5,-20(s0)
    80002e02:	2785                	addiw	a5,a5,1
    80002e04:	fef42623          	sw	a5,-20(s0)
    80002e08:	fec42783          	lw	a5,-20(s0)
    80002e0c:	0007871b          	sext.w	a4,a5
    80002e10:	47bd                	li	a5,15
    80002e12:	fae7d7e3          	bge	a5,a4,80002dc0 <fork+0xaa>
  np->cwd = idup(p->cwd);
    80002e16:	fe043783          	ld	a5,-32(s0)
    80002e1a:	1507b783          	ld	a5,336(a5)
    80002e1e:	853e                	mv	a0,a5
    80002e20:	00002097          	auipc	ra,0x2
    80002e24:	24a080e7          	jalr	586(ra) # 8000506a <idup>
    80002e28:	872a                	mv	a4,a0
    80002e2a:	fd843783          	ld	a5,-40(s0)
    80002e2e:	14e7b823          	sd	a4,336(a5)

  safestrcpy(np->name, p->name, sizeof(p->name));
    80002e32:	fd843783          	ld	a5,-40(s0)
    80002e36:	15878713          	addi	a4,a5,344
    80002e3a:	fe043783          	ld	a5,-32(s0)
    80002e3e:	15878793          	addi	a5,a5,344
    80002e42:	4641                	li	a2,16
    80002e44:	85be                	mv	a1,a5
    80002e46:	853a                	mv	a0,a4
    80002e48:	fffff097          	auipc	ra,0xfffff
    80002e4c:	90e080e7          	jalr	-1778(ra) # 80001756 <safestrcpy>

  pid = np->pid;
    80002e50:	fd843783          	ld	a5,-40(s0)
    80002e54:	5b9c                	lw	a5,48(a5)
    80002e56:	fcf42a23          	sw	a5,-44(s0)

  release(&np->lock);
    80002e5a:	fd843783          	ld	a5,-40(s0)
    80002e5e:	853e                	mv	a0,a5
    80002e60:	ffffe097          	auipc	ra,0xffffe
    80002e64:	482080e7          	jalr	1154(ra) # 800012e2 <release>

  acquire(&wait_lock);
    80002e68:	00019517          	auipc	a0,0x19
    80002e6c:	0b850513          	addi	a0,a0,184 # 8001bf20 <wait_lock>
    80002e70:	ffffe097          	auipc	ra,0xffffe
    80002e74:	40e080e7          	jalr	1038(ra) # 8000127e <acquire>
  np->parent = p;
    80002e78:	fd843783          	ld	a5,-40(s0)
    80002e7c:	fe043703          	ld	a4,-32(s0)
    80002e80:	ff98                	sd	a4,56(a5)
  release(&wait_lock);
    80002e82:	00019517          	auipc	a0,0x19
    80002e86:	09e50513          	addi	a0,a0,158 # 8001bf20 <wait_lock>
    80002e8a:	ffffe097          	auipc	ra,0xffffe
    80002e8e:	458080e7          	jalr	1112(ra) # 800012e2 <release>

  acquire(&np->lock);
    80002e92:	fd843783          	ld	a5,-40(s0)
    80002e96:	853e                	mv	a0,a5
    80002e98:	ffffe097          	auipc	ra,0xffffe
    80002e9c:	3e6080e7          	jalr	998(ra) # 8000127e <acquire>
  np->state = RUNNABLE;
    80002ea0:	fd843783          	ld	a5,-40(s0)
    80002ea4:	470d                	li	a4,3
    80002ea6:	cf98                	sw	a4,24(a5)
  release(&np->lock);
    80002ea8:	fd843783          	ld	a5,-40(s0)
    80002eac:	853e                	mv	a0,a5
    80002eae:	ffffe097          	auipc	ra,0xffffe
    80002eb2:	434080e7          	jalr	1076(ra) # 800012e2 <release>

  return pid;
    80002eb6:	fd442783          	lw	a5,-44(s0)
}
    80002eba:	853e                	mv	a0,a5
    80002ebc:	70a2                	ld	ra,40(sp)
    80002ebe:	7402                	ld	s0,32(sp)
    80002ec0:	6145                	addi	sp,sp,48
    80002ec2:	8082                	ret

0000000080002ec4 <reparent>:

// Pass p's abandoned children to init.
// Caller must hold wait_lock.
void
reparent(struct proc *p)
{
    80002ec4:	7179                	addi	sp,sp,-48
    80002ec6:	f406                	sd	ra,40(sp)
    80002ec8:	f022                	sd	s0,32(sp)
    80002eca:	1800                	addi	s0,sp,48
    80002ecc:	fca43c23          	sd	a0,-40(s0)
  struct proc *pp;

  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002ed0:	00013797          	auipc	a5,0x13
    80002ed4:	63878793          	addi	a5,a5,1592 # 80016508 <proc>
    80002ed8:	fef43423          	sd	a5,-24(s0)
    80002edc:	a081                	j	80002f1c <reparent+0x58>
    if(pp->parent == p){
    80002ede:	fe843783          	ld	a5,-24(s0)
    80002ee2:	7f9c                	ld	a5,56(a5)
    80002ee4:	fd843703          	ld	a4,-40(s0)
    80002ee8:	02f71463          	bne	a4,a5,80002f10 <reparent+0x4c>
      pp->parent = initproc;
    80002eec:	0000b797          	auipc	a5,0xb
    80002ef0:	fa478793          	addi	a5,a5,-92 # 8000de90 <initproc>
    80002ef4:	6398                	ld	a4,0(a5)
    80002ef6:	fe843783          	ld	a5,-24(s0)
    80002efa:	ff98                	sd	a4,56(a5)
      wakeup(initproc);
    80002efc:	0000b797          	auipc	a5,0xb
    80002f00:	f9478793          	addi	a5,a5,-108 # 8000de90 <initproc>
    80002f04:	639c                	ld	a5,0(a5)
    80002f06:	853e                	mv	a0,a5
    80002f08:	00000097          	auipc	ra,0x0
    80002f0c:	57c080e7          	jalr	1404(ra) # 80003484 <wakeup>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002f10:	fe843783          	ld	a5,-24(s0)
    80002f14:	16878793          	addi	a5,a5,360
    80002f18:	fef43423          	sd	a5,-24(s0)
    80002f1c:	fe843703          	ld	a4,-24(s0)
    80002f20:	00019797          	auipc	a5,0x19
    80002f24:	fe878793          	addi	a5,a5,-24 # 8001bf08 <pid_lock>
    80002f28:	faf76be3          	bltu	a4,a5,80002ede <reparent+0x1a>
    }
  }
}
    80002f2c:	0001                	nop
    80002f2e:	0001                	nop
    80002f30:	70a2                	ld	ra,40(sp)
    80002f32:	7402                	ld	s0,32(sp)
    80002f34:	6145                	addi	sp,sp,48
    80002f36:	8082                	ret

0000000080002f38 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait().
void
exit(int status)
{
    80002f38:	7139                	addi	sp,sp,-64
    80002f3a:	fc06                	sd	ra,56(sp)
    80002f3c:	f822                	sd	s0,48(sp)
    80002f3e:	0080                	addi	s0,sp,64
    80002f40:	87aa                	mv	a5,a0
    80002f42:	fcf42623          	sw	a5,-52(s0)
  struct proc *p = myproc();
    80002f46:	00000097          	auipc	ra,0x0
    80002f4a:	900080e7          	jalr	-1792(ra) # 80002846 <myproc>
    80002f4e:	fea43023          	sd	a0,-32(s0)

  if(p == initproc)
    80002f52:	0000b797          	auipc	a5,0xb
    80002f56:	f3e78793          	addi	a5,a5,-194 # 8000de90 <initproc>
    80002f5a:	639c                	ld	a5,0(a5)
    80002f5c:	fe043703          	ld	a4,-32(s0)
    80002f60:	00f71a63          	bne	a4,a5,80002f74 <exit+0x3c>
    panic("init exiting");
    80002f64:	00008517          	auipc	a0,0x8
    80002f68:	29c50513          	addi	a0,a0,668 # 8000b200 <etext+0x200>
    80002f6c:	ffffe097          	auipc	ra,0xffffe
    80002f70:	d1e080e7          	jalr	-738(ra) # 80000c8a <panic>

  // Close all open files.
  for(int fd = 0; fd < NOFILE; fd++){
    80002f74:	fe042623          	sw	zero,-20(s0)
    80002f78:	a881                	j	80002fc8 <exit+0x90>
    if(p->ofile[fd]){
    80002f7a:	fe043703          	ld	a4,-32(s0)
    80002f7e:	fec42783          	lw	a5,-20(s0)
    80002f82:	07e9                	addi	a5,a5,26
    80002f84:	078e                	slli	a5,a5,0x3
    80002f86:	97ba                	add	a5,a5,a4
    80002f88:	639c                	ld	a5,0(a5)
    80002f8a:	cb95                	beqz	a5,80002fbe <exit+0x86>
      struct file *f = p->ofile[fd];
    80002f8c:	fe043703          	ld	a4,-32(s0)
    80002f90:	fec42783          	lw	a5,-20(s0)
    80002f94:	07e9                	addi	a5,a5,26
    80002f96:	078e                	slli	a5,a5,0x3
    80002f98:	97ba                	add	a5,a5,a4
    80002f9a:	639c                	ld	a5,0(a5)
    80002f9c:	fcf43c23          	sd	a5,-40(s0)
      fileclose(f);
    80002fa0:	fd843503          	ld	a0,-40(s0)
    80002fa4:	00004097          	auipc	ra,0x4
    80002fa8:	840080e7          	jalr	-1984(ra) # 800067e4 <fileclose>
      p->ofile[fd] = 0;
    80002fac:	fe043703          	ld	a4,-32(s0)
    80002fb0:	fec42783          	lw	a5,-20(s0)
    80002fb4:	07e9                	addi	a5,a5,26
    80002fb6:	078e                	slli	a5,a5,0x3
    80002fb8:	97ba                	add	a5,a5,a4
    80002fba:	0007b023          	sd	zero,0(a5)
  for(int fd = 0; fd < NOFILE; fd++){
    80002fbe:	fec42783          	lw	a5,-20(s0)
    80002fc2:	2785                	addiw	a5,a5,1
    80002fc4:	fef42623          	sw	a5,-20(s0)
    80002fc8:	fec42783          	lw	a5,-20(s0)
    80002fcc:	0007871b          	sext.w	a4,a5
    80002fd0:	47bd                	li	a5,15
    80002fd2:	fae7d4e3          	bge	a5,a4,80002f7a <exit+0x42>
    }
  }

  begin_op();
    80002fd6:	00003097          	auipc	ra,0x3
    80002fda:	174080e7          	jalr	372(ra) # 8000614a <begin_op>
  iput(p->cwd);
    80002fde:	fe043783          	ld	a5,-32(s0)
    80002fe2:	1507b783          	ld	a5,336(a5)
    80002fe6:	853e                	mv	a0,a5
    80002fe8:	00002097          	auipc	ra,0x2
    80002fec:	25c080e7          	jalr	604(ra) # 80005244 <iput>
  end_op();
    80002ff0:	00003097          	auipc	ra,0x3
    80002ff4:	21c080e7          	jalr	540(ra) # 8000620c <end_op>
  p->cwd = 0;
    80002ff8:	fe043783          	ld	a5,-32(s0)
    80002ffc:	1407b823          	sd	zero,336(a5)

  acquire(&wait_lock);
    80003000:	00019517          	auipc	a0,0x19
    80003004:	f2050513          	addi	a0,a0,-224 # 8001bf20 <wait_lock>
    80003008:	ffffe097          	auipc	ra,0xffffe
    8000300c:	276080e7          	jalr	630(ra) # 8000127e <acquire>

  // Give any children to init.
  reparent(p);
    80003010:	fe043503          	ld	a0,-32(s0)
    80003014:	00000097          	auipc	ra,0x0
    80003018:	eb0080e7          	jalr	-336(ra) # 80002ec4 <reparent>

  // Parent might be sleeping in wait().
  wakeup(p->parent);
    8000301c:	fe043783          	ld	a5,-32(s0)
    80003020:	7f9c                	ld	a5,56(a5)
    80003022:	853e                	mv	a0,a5
    80003024:	00000097          	auipc	ra,0x0
    80003028:	460080e7          	jalr	1120(ra) # 80003484 <wakeup>
  
  acquire(&p->lock);
    8000302c:	fe043783          	ld	a5,-32(s0)
    80003030:	853e                	mv	a0,a5
    80003032:	ffffe097          	auipc	ra,0xffffe
    80003036:	24c080e7          	jalr	588(ra) # 8000127e <acquire>

  p->xstate = status;
    8000303a:	fe043783          	ld	a5,-32(s0)
    8000303e:	fcc42703          	lw	a4,-52(s0)
    80003042:	d7d8                	sw	a4,44(a5)
  p->state = ZOMBIE;
    80003044:	fe043783          	ld	a5,-32(s0)
    80003048:	4715                	li	a4,5
    8000304a:	cf98                	sw	a4,24(a5)

  release(&wait_lock);
    8000304c:	00019517          	auipc	a0,0x19
    80003050:	ed450513          	addi	a0,a0,-300 # 8001bf20 <wait_lock>
    80003054:	ffffe097          	auipc	ra,0xffffe
    80003058:	28e080e7          	jalr	654(ra) # 800012e2 <release>

  // Jump into the scheduler, never to return.
  sched();
    8000305c:	00000097          	auipc	ra,0x0
    80003060:	230080e7          	jalr	560(ra) # 8000328c <sched>
  panic("zombie exit");
    80003064:	00008517          	auipc	a0,0x8
    80003068:	1ac50513          	addi	a0,a0,428 # 8000b210 <etext+0x210>
    8000306c:	ffffe097          	auipc	ra,0xffffe
    80003070:	c1e080e7          	jalr	-994(ra) # 80000c8a <panic>

0000000080003074 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(uint64 addr)
{
    80003074:	7139                	addi	sp,sp,-64
    80003076:	fc06                	sd	ra,56(sp)
    80003078:	f822                	sd	s0,48(sp)
    8000307a:	0080                	addi	s0,sp,64
    8000307c:	fca43423          	sd	a0,-56(s0)
  struct proc *pp;
  int havekids, pid;
  struct proc *p = myproc();
    80003080:	fffff097          	auipc	ra,0xfffff
    80003084:	7c6080e7          	jalr	1990(ra) # 80002846 <myproc>
    80003088:	fca43c23          	sd	a0,-40(s0)

  acquire(&wait_lock);
    8000308c:	00019517          	auipc	a0,0x19
    80003090:	e9450513          	addi	a0,a0,-364 # 8001bf20 <wait_lock>
    80003094:	ffffe097          	auipc	ra,0xffffe
    80003098:	1ea080e7          	jalr	490(ra) # 8000127e <acquire>

  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    8000309c:	fe042223          	sw	zero,-28(s0)
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800030a0:	00013797          	auipc	a5,0x13
    800030a4:	46878793          	addi	a5,a5,1128 # 80016508 <proc>
    800030a8:	fef43423          	sd	a5,-24(s0)
    800030ac:	a8d1                	j	80003180 <wait+0x10c>
      if(pp->parent == p){
    800030ae:	fe843783          	ld	a5,-24(s0)
    800030b2:	7f9c                	ld	a5,56(a5)
    800030b4:	fd843703          	ld	a4,-40(s0)
    800030b8:	0af71e63          	bne	a4,a5,80003174 <wait+0x100>
        // make sure the child isn't still in exit() or swtch().
        acquire(&pp->lock);
    800030bc:	fe843783          	ld	a5,-24(s0)
    800030c0:	853e                	mv	a0,a5
    800030c2:	ffffe097          	auipc	ra,0xffffe
    800030c6:	1bc080e7          	jalr	444(ra) # 8000127e <acquire>

        havekids = 1;
    800030ca:	4785                	li	a5,1
    800030cc:	fef42223          	sw	a5,-28(s0)
        if(pp->state == ZOMBIE){
    800030d0:	fe843783          	ld	a5,-24(s0)
    800030d4:	4f9c                	lw	a5,24(a5)
    800030d6:	873e                	mv	a4,a5
    800030d8:	4795                	li	a5,5
    800030da:	08f71663          	bne	a4,a5,80003166 <wait+0xf2>
          // Found one.
          pid = pp->pid;
    800030de:	fe843783          	ld	a5,-24(s0)
    800030e2:	5b9c                	lw	a5,48(a5)
    800030e4:	fcf42a23          	sw	a5,-44(s0)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800030e8:	fc843783          	ld	a5,-56(s0)
    800030ec:	c7a9                	beqz	a5,80003136 <wait+0xc2>
    800030ee:	fd843783          	ld	a5,-40(s0)
    800030f2:	6bb8                	ld	a4,80(a5)
    800030f4:	fe843783          	ld	a5,-24(s0)
    800030f8:	02c78793          	addi	a5,a5,44
    800030fc:	4691                	li	a3,4
    800030fe:	863e                	mv	a2,a5
    80003100:	fc843583          	ld	a1,-56(s0)
    80003104:	853a                	mv	a0,a4
    80003106:	fffff097          	auipc	ra,0xfffff
    8000310a:	20a080e7          	jalr	522(ra) # 80002310 <copyout>
    8000310e:	87aa                	mv	a5,a0
    80003110:	0207d363          	bgez	a5,80003136 <wait+0xc2>
                                  sizeof(pp->xstate)) < 0) {
            release(&pp->lock);
    80003114:	fe843783          	ld	a5,-24(s0)
    80003118:	853e                	mv	a0,a5
    8000311a:	ffffe097          	auipc	ra,0xffffe
    8000311e:	1c8080e7          	jalr	456(ra) # 800012e2 <release>
            release(&wait_lock);
    80003122:	00019517          	auipc	a0,0x19
    80003126:	dfe50513          	addi	a0,a0,-514 # 8001bf20 <wait_lock>
    8000312a:	ffffe097          	auipc	ra,0xffffe
    8000312e:	1b8080e7          	jalr	440(ra) # 800012e2 <release>
            return -1;
    80003132:	57fd                	li	a5,-1
    80003134:	a879                	j	800031d2 <wait+0x15e>
          }
          freeproc(pp);
    80003136:	fe843503          	ld	a0,-24(s0)
    8000313a:	00000097          	auipc	ra,0x0
    8000313e:	8d0080e7          	jalr	-1840(ra) # 80002a0a <freeproc>
          release(&pp->lock);
    80003142:	fe843783          	ld	a5,-24(s0)
    80003146:	853e                	mv	a0,a5
    80003148:	ffffe097          	auipc	ra,0xffffe
    8000314c:	19a080e7          	jalr	410(ra) # 800012e2 <release>
          release(&wait_lock);
    80003150:	00019517          	auipc	a0,0x19
    80003154:	dd050513          	addi	a0,a0,-560 # 8001bf20 <wait_lock>
    80003158:	ffffe097          	auipc	ra,0xffffe
    8000315c:	18a080e7          	jalr	394(ra) # 800012e2 <release>
          return pid;
    80003160:	fd442783          	lw	a5,-44(s0)
    80003164:	a0bd                	j	800031d2 <wait+0x15e>
        }
        release(&pp->lock);
    80003166:	fe843783          	ld	a5,-24(s0)
    8000316a:	853e                	mv	a0,a5
    8000316c:	ffffe097          	auipc	ra,0xffffe
    80003170:	176080e7          	jalr	374(ra) # 800012e2 <release>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80003174:	fe843783          	ld	a5,-24(s0)
    80003178:	16878793          	addi	a5,a5,360
    8000317c:	fef43423          	sd	a5,-24(s0)
    80003180:	fe843703          	ld	a4,-24(s0)
    80003184:	00019797          	auipc	a5,0x19
    80003188:	d8478793          	addi	a5,a5,-636 # 8001bf08 <pid_lock>
    8000318c:	f2f761e3          	bltu	a4,a5,800030ae <wait+0x3a>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || killed(p)){
    80003190:	fe442783          	lw	a5,-28(s0)
    80003194:	2781                	sext.w	a5,a5
    80003196:	cb89                	beqz	a5,800031a8 <wait+0x134>
    80003198:	fd843503          	ld	a0,-40(s0)
    8000319c:	00000097          	auipc	ra,0x0
    800031a0:	456080e7          	jalr	1110(ra) # 800035f2 <killed>
    800031a4:	87aa                	mv	a5,a0
    800031a6:	cb99                	beqz	a5,800031bc <wait+0x148>
      release(&wait_lock);
    800031a8:	00019517          	auipc	a0,0x19
    800031ac:	d7850513          	addi	a0,a0,-648 # 8001bf20 <wait_lock>
    800031b0:	ffffe097          	auipc	ra,0xffffe
    800031b4:	132080e7          	jalr	306(ra) # 800012e2 <release>
      return -1;
    800031b8:	57fd                	li	a5,-1
    800031ba:	a821                	j	800031d2 <wait+0x15e>
    }
    
    // Wait for a child to exit.
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800031bc:	00019597          	auipc	a1,0x19
    800031c0:	d6458593          	addi	a1,a1,-668 # 8001bf20 <wait_lock>
    800031c4:	fd843503          	ld	a0,-40(s0)
    800031c8:	00000097          	auipc	ra,0x0
    800031cc:	240080e7          	jalr	576(ra) # 80003408 <sleep>
    havekids = 0;
    800031d0:	b5f1                	j	8000309c <wait+0x28>
  }
}
    800031d2:	853e                	mv	a0,a5
    800031d4:	70e2                	ld	ra,56(sp)
    800031d6:	7442                	ld	s0,48(sp)
    800031d8:	6121                	addi	sp,sp,64
    800031da:	8082                	ret

00000000800031dc <scheduler>:
//  - swtch to start running that process.
//  - eventually that process transfers control
//    via swtch back to the scheduler.
void
scheduler(void)
{
    800031dc:	1101                	addi	sp,sp,-32
    800031de:	ec06                	sd	ra,24(sp)
    800031e0:	e822                	sd	s0,16(sp)
    800031e2:	1000                	addi	s0,sp,32
  struct proc *p;
  struct cpu *c = mycpu();
    800031e4:	fffff097          	auipc	ra,0xfffff
    800031e8:	628080e7          	jalr	1576(ra) # 8000280c <mycpu>
    800031ec:	fea43023          	sd	a0,-32(s0)
  
  c->proc = 0;
    800031f0:	fe043783          	ld	a5,-32(s0)
    800031f4:	0007b023          	sd	zero,0(a5)
  for(;;){
    // Avoid deadlock by ensuring that devices can interrupt.
    intr_on();
    800031f8:	fffff097          	auipc	ra,0xfffff
    800031fc:	3f6080e7          	jalr	1014(ra) # 800025ee <intr_on>

    for(p = proc; p < &proc[NPROC]; p++) {
    80003200:	00013797          	auipc	a5,0x13
    80003204:	30878793          	addi	a5,a5,776 # 80016508 <proc>
    80003208:	fef43423          	sd	a5,-24(s0)
    8000320c:	a0bd                	j	8000327a <scheduler+0x9e>
      acquire(&p->lock);
    8000320e:	fe843783          	ld	a5,-24(s0)
    80003212:	853e                	mv	a0,a5
    80003214:	ffffe097          	auipc	ra,0xffffe
    80003218:	06a080e7          	jalr	106(ra) # 8000127e <acquire>
      if(p->state == RUNNABLE) {
    8000321c:	fe843783          	ld	a5,-24(s0)
    80003220:	4f9c                	lw	a5,24(a5)
    80003222:	873e                	mv	a4,a5
    80003224:	478d                	li	a5,3
    80003226:	02f71d63          	bne	a4,a5,80003260 <scheduler+0x84>
        // Switch to chosen process.  It is the process's job
        // to release its lock and then reacquire it
        // before jumping back to us.
        p->state = RUNNING;
    8000322a:	fe843783          	ld	a5,-24(s0)
    8000322e:	4711                	li	a4,4
    80003230:	cf98                	sw	a4,24(a5)
        c->proc = p;
    80003232:	fe043783          	ld	a5,-32(s0)
    80003236:	fe843703          	ld	a4,-24(s0)
    8000323a:	e398                	sd	a4,0(a5)
        swtch(&c->context, &p->context);
    8000323c:	fe043783          	ld	a5,-32(s0)
    80003240:	00878713          	addi	a4,a5,8
    80003244:	fe843783          	ld	a5,-24(s0)
    80003248:	06078793          	addi	a5,a5,96
    8000324c:	85be                	mv	a1,a5
    8000324e:	853a                	mv	a0,a4
    80003250:	00000097          	auipc	ra,0x0
    80003254:	61c080e7          	jalr	1564(ra) # 8000386c <swtch>

        // Process is done running for now.
        // It should have changed its p->state before coming back.
        c->proc = 0;
    80003258:	fe043783          	ld	a5,-32(s0)
    8000325c:	0007b023          	sd	zero,0(a5)
      }
      release(&p->lock);
    80003260:	fe843783          	ld	a5,-24(s0)
    80003264:	853e                	mv	a0,a5
    80003266:	ffffe097          	auipc	ra,0xffffe
    8000326a:	07c080e7          	jalr	124(ra) # 800012e2 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000326e:	fe843783          	ld	a5,-24(s0)
    80003272:	16878793          	addi	a5,a5,360
    80003276:	fef43423          	sd	a5,-24(s0)
    8000327a:	fe843703          	ld	a4,-24(s0)
    8000327e:	00019797          	auipc	a5,0x19
    80003282:	c8a78793          	addi	a5,a5,-886 # 8001bf08 <pid_lock>
    80003286:	f8f764e3          	bltu	a4,a5,8000320e <scheduler+0x32>
    intr_on();
    8000328a:	b7bd                	j	800031f8 <scheduler+0x1c>

000000008000328c <sched>:
// be proc->intena and proc->noff, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
    8000328c:	7179                	addi	sp,sp,-48
    8000328e:	f406                	sd	ra,40(sp)
    80003290:	f022                	sd	s0,32(sp)
    80003292:	ec26                	sd	s1,24(sp)
    80003294:	1800                	addi	s0,sp,48
  int intena;
  struct proc *p = myproc();
    80003296:	fffff097          	auipc	ra,0xfffff
    8000329a:	5b0080e7          	jalr	1456(ra) # 80002846 <myproc>
    8000329e:	fca43c23          	sd	a0,-40(s0)

  if(!holding(&p->lock))
    800032a2:	fd843783          	ld	a5,-40(s0)
    800032a6:	853e                	mv	a0,a5
    800032a8:	ffffe097          	auipc	ra,0xffffe
    800032ac:	090080e7          	jalr	144(ra) # 80001338 <holding>
    800032b0:	87aa                	mv	a5,a0
    800032b2:	eb89                	bnez	a5,800032c4 <sched+0x38>
    panic("sched p->lock");
    800032b4:	00008517          	auipc	a0,0x8
    800032b8:	f6c50513          	addi	a0,a0,-148 # 8000b220 <etext+0x220>
    800032bc:	ffffe097          	auipc	ra,0xffffe
    800032c0:	9ce080e7          	jalr	-1586(ra) # 80000c8a <panic>
  if(mycpu()->noff != 1)
    800032c4:	fffff097          	auipc	ra,0xfffff
    800032c8:	548080e7          	jalr	1352(ra) # 8000280c <mycpu>
    800032cc:	87aa                	mv	a5,a0
    800032ce:	5fbc                	lw	a5,120(a5)
    800032d0:	873e                	mv	a4,a5
    800032d2:	4785                	li	a5,1
    800032d4:	00f70a63          	beq	a4,a5,800032e8 <sched+0x5c>
    panic("sched locks");
    800032d8:	00008517          	auipc	a0,0x8
    800032dc:	f5850513          	addi	a0,a0,-168 # 8000b230 <etext+0x230>
    800032e0:	ffffe097          	auipc	ra,0xffffe
    800032e4:	9aa080e7          	jalr	-1622(ra) # 80000c8a <panic>
  if(p->state == RUNNING)
    800032e8:	fd843783          	ld	a5,-40(s0)
    800032ec:	4f9c                	lw	a5,24(a5)
    800032ee:	873e                	mv	a4,a5
    800032f0:	4791                	li	a5,4
    800032f2:	00f71a63          	bne	a4,a5,80003306 <sched+0x7a>
    panic("sched running");
    800032f6:	00008517          	auipc	a0,0x8
    800032fa:	f4a50513          	addi	a0,a0,-182 # 8000b240 <etext+0x240>
    800032fe:	ffffe097          	auipc	ra,0xffffe
    80003302:	98c080e7          	jalr	-1652(ra) # 80000c8a <panic>
  if(intr_get())
    80003306:	fffff097          	auipc	ra,0xfffff
    8000330a:	312080e7          	jalr	786(ra) # 80002618 <intr_get>
    8000330e:	87aa                	mv	a5,a0
    80003310:	cb89                	beqz	a5,80003322 <sched+0x96>
    panic("sched interruptible");
    80003312:	00008517          	auipc	a0,0x8
    80003316:	f3e50513          	addi	a0,a0,-194 # 8000b250 <etext+0x250>
    8000331a:	ffffe097          	auipc	ra,0xffffe
    8000331e:	970080e7          	jalr	-1680(ra) # 80000c8a <panic>

  intena = mycpu()->intena;
    80003322:	fffff097          	auipc	ra,0xfffff
    80003326:	4ea080e7          	jalr	1258(ra) # 8000280c <mycpu>
    8000332a:	87aa                	mv	a5,a0
    8000332c:	5ffc                	lw	a5,124(a5)
    8000332e:	fcf42a23          	sw	a5,-44(s0)
  swtch(&p->context, &mycpu()->context);
    80003332:	fd843783          	ld	a5,-40(s0)
    80003336:	06078493          	addi	s1,a5,96
    8000333a:	fffff097          	auipc	ra,0xfffff
    8000333e:	4d2080e7          	jalr	1234(ra) # 8000280c <mycpu>
    80003342:	87aa                	mv	a5,a0
    80003344:	07a1                	addi	a5,a5,8
    80003346:	85be                	mv	a1,a5
    80003348:	8526                	mv	a0,s1
    8000334a:	00000097          	auipc	ra,0x0
    8000334e:	522080e7          	jalr	1314(ra) # 8000386c <swtch>
  mycpu()->intena = intena;
    80003352:	fffff097          	auipc	ra,0xfffff
    80003356:	4ba080e7          	jalr	1210(ra) # 8000280c <mycpu>
    8000335a:	872a                	mv	a4,a0
    8000335c:	fd442783          	lw	a5,-44(s0)
    80003360:	df7c                	sw	a5,124(a4)
}
    80003362:	0001                	nop
    80003364:	70a2                	ld	ra,40(sp)
    80003366:	7402                	ld	s0,32(sp)
    80003368:	64e2                	ld	s1,24(sp)
    8000336a:	6145                	addi	sp,sp,48
    8000336c:	8082                	ret

000000008000336e <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
    8000336e:	1101                	addi	sp,sp,-32
    80003370:	ec06                	sd	ra,24(sp)
    80003372:	e822                	sd	s0,16(sp)
    80003374:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80003376:	fffff097          	auipc	ra,0xfffff
    8000337a:	4d0080e7          	jalr	1232(ra) # 80002846 <myproc>
    8000337e:	fea43423          	sd	a0,-24(s0)
  acquire(&p->lock);
    80003382:	fe843783          	ld	a5,-24(s0)
    80003386:	853e                	mv	a0,a5
    80003388:	ffffe097          	auipc	ra,0xffffe
    8000338c:	ef6080e7          	jalr	-266(ra) # 8000127e <acquire>
  p->state = RUNNABLE;
    80003390:	fe843783          	ld	a5,-24(s0)
    80003394:	470d                	li	a4,3
    80003396:	cf98                	sw	a4,24(a5)
  sched();
    80003398:	00000097          	auipc	ra,0x0
    8000339c:	ef4080e7          	jalr	-268(ra) # 8000328c <sched>
  release(&p->lock);
    800033a0:	fe843783          	ld	a5,-24(s0)
    800033a4:	853e                	mv	a0,a5
    800033a6:	ffffe097          	auipc	ra,0xffffe
    800033aa:	f3c080e7          	jalr	-196(ra) # 800012e2 <release>
}
    800033ae:	0001                	nop
    800033b0:	60e2                	ld	ra,24(sp)
    800033b2:	6442                	ld	s0,16(sp)
    800033b4:	6105                	addi	sp,sp,32
    800033b6:	8082                	ret

00000000800033b8 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    800033b8:	1141                	addi	sp,sp,-16
    800033ba:	e406                	sd	ra,8(sp)
    800033bc:	e022                	sd	s0,0(sp)
    800033be:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    800033c0:	fffff097          	auipc	ra,0xfffff
    800033c4:	486080e7          	jalr	1158(ra) # 80002846 <myproc>
    800033c8:	87aa                	mv	a5,a0
    800033ca:	853e                	mv	a0,a5
    800033cc:	ffffe097          	auipc	ra,0xffffe
    800033d0:	f16080e7          	jalr	-234(ra) # 800012e2 <release>

  if (first) {
    800033d4:	0000b797          	auipc	a5,0xb
    800033d8:	93078793          	addi	a5,a5,-1744 # 8000dd04 <first.1>
    800033dc:	439c                	lw	a5,0(a5)
    800033de:	cf81                	beqz	a5,800033f6 <forkret+0x3e>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    first = 0;
    800033e0:	0000b797          	auipc	a5,0xb
    800033e4:	92478793          	addi	a5,a5,-1756 # 8000dd04 <first.1>
    800033e8:	0007a023          	sw	zero,0(a5)
    fsinit(ROOTDEV);
    800033ec:	4505                	li	a0,1
    800033ee:	00001097          	auipc	ra,0x1
    800033f2:	56a080e7          	jalr	1386(ra) # 80004958 <fsinit>
  }

  usertrapret();
    800033f6:	00001097          	auipc	ra,0x1
    800033fa:	828080e7          	jalr	-2008(ra) # 80003c1e <usertrapret>
}
    800033fe:	0001                	nop
    80003400:	60a2                	ld	ra,8(sp)
    80003402:	6402                	ld	s0,0(sp)
    80003404:	0141                	addi	sp,sp,16
    80003406:	8082                	ret

0000000080003408 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80003408:	7179                	addi	sp,sp,-48
    8000340a:	f406                	sd	ra,40(sp)
    8000340c:	f022                	sd	s0,32(sp)
    8000340e:	1800                	addi	s0,sp,48
    80003410:	fca43c23          	sd	a0,-40(s0)
    80003414:	fcb43823          	sd	a1,-48(s0)
  struct proc *p = myproc();
    80003418:	fffff097          	auipc	ra,0xfffff
    8000341c:	42e080e7          	jalr	1070(ra) # 80002846 <myproc>
    80003420:	fea43423          	sd	a0,-24(s0)
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80003424:	fe843783          	ld	a5,-24(s0)
    80003428:	853e                	mv	a0,a5
    8000342a:	ffffe097          	auipc	ra,0xffffe
    8000342e:	e54080e7          	jalr	-428(ra) # 8000127e <acquire>
  release(lk);
    80003432:	fd043503          	ld	a0,-48(s0)
    80003436:	ffffe097          	auipc	ra,0xffffe
    8000343a:	eac080e7          	jalr	-340(ra) # 800012e2 <release>

  // Go to sleep.
  p->chan = chan;
    8000343e:	fe843783          	ld	a5,-24(s0)
    80003442:	fd843703          	ld	a4,-40(s0)
    80003446:	f398                	sd	a4,32(a5)
  p->state = SLEEPING;
    80003448:	fe843783          	ld	a5,-24(s0)
    8000344c:	4709                	li	a4,2
    8000344e:	cf98                	sw	a4,24(a5)

  sched();
    80003450:	00000097          	auipc	ra,0x0
    80003454:	e3c080e7          	jalr	-452(ra) # 8000328c <sched>

  // Tidy up.
  p->chan = 0;
    80003458:	fe843783          	ld	a5,-24(s0)
    8000345c:	0207b023          	sd	zero,32(a5)

  // Reacquire original lock.
  release(&p->lock);
    80003460:	fe843783          	ld	a5,-24(s0)
    80003464:	853e                	mv	a0,a5
    80003466:	ffffe097          	auipc	ra,0xffffe
    8000346a:	e7c080e7          	jalr	-388(ra) # 800012e2 <release>
  acquire(lk);
    8000346e:	fd043503          	ld	a0,-48(s0)
    80003472:	ffffe097          	auipc	ra,0xffffe
    80003476:	e0c080e7          	jalr	-500(ra) # 8000127e <acquire>
}
    8000347a:	0001                	nop
    8000347c:	70a2                	ld	ra,40(sp)
    8000347e:	7402                	ld	s0,32(sp)
    80003480:	6145                	addi	sp,sp,48
    80003482:	8082                	ret

0000000080003484 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80003484:	7179                	addi	sp,sp,-48
    80003486:	f406                	sd	ra,40(sp)
    80003488:	f022                	sd	s0,32(sp)
    8000348a:	1800                	addi	s0,sp,48
    8000348c:	fca43c23          	sd	a0,-40(s0)
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80003490:	00013797          	auipc	a5,0x13
    80003494:	07878793          	addi	a5,a5,120 # 80016508 <proc>
    80003498:	fef43423          	sd	a5,-24(s0)
    8000349c:	a085                	j	800034fc <wakeup+0x78>
    if(p != myproc()){
    8000349e:	fffff097          	auipc	ra,0xfffff
    800034a2:	3a8080e7          	jalr	936(ra) # 80002846 <myproc>
    800034a6:	872a                	mv	a4,a0
    800034a8:	fe843783          	ld	a5,-24(s0)
    800034ac:	04e78263          	beq	a5,a4,800034f0 <wakeup+0x6c>
      acquire(&p->lock);
    800034b0:	fe843783          	ld	a5,-24(s0)
    800034b4:	853e                	mv	a0,a5
    800034b6:	ffffe097          	auipc	ra,0xffffe
    800034ba:	dc8080e7          	jalr	-568(ra) # 8000127e <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800034be:	fe843783          	ld	a5,-24(s0)
    800034c2:	4f9c                	lw	a5,24(a5)
    800034c4:	873e                	mv	a4,a5
    800034c6:	4789                	li	a5,2
    800034c8:	00f71d63          	bne	a4,a5,800034e2 <wakeup+0x5e>
    800034cc:	fe843783          	ld	a5,-24(s0)
    800034d0:	739c                	ld	a5,32(a5)
    800034d2:	fd843703          	ld	a4,-40(s0)
    800034d6:	00f71663          	bne	a4,a5,800034e2 <wakeup+0x5e>
        p->state = RUNNABLE;
    800034da:	fe843783          	ld	a5,-24(s0)
    800034de:	470d                	li	a4,3
    800034e0:	cf98                	sw	a4,24(a5)
      }
      release(&p->lock);
    800034e2:	fe843783          	ld	a5,-24(s0)
    800034e6:	853e                	mv	a0,a5
    800034e8:	ffffe097          	auipc	ra,0xffffe
    800034ec:	dfa080e7          	jalr	-518(ra) # 800012e2 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800034f0:	fe843783          	ld	a5,-24(s0)
    800034f4:	16878793          	addi	a5,a5,360
    800034f8:	fef43423          	sd	a5,-24(s0)
    800034fc:	fe843703          	ld	a4,-24(s0)
    80003500:	00019797          	auipc	a5,0x19
    80003504:	a0878793          	addi	a5,a5,-1528 # 8001bf08 <pid_lock>
    80003508:	f8f76be3          	bltu	a4,a5,8000349e <wakeup+0x1a>
    }
  }
}
    8000350c:	0001                	nop
    8000350e:	0001                	nop
    80003510:	70a2                	ld	ra,40(sp)
    80003512:	7402                	ld	s0,32(sp)
    80003514:	6145                	addi	sp,sp,48
    80003516:	8082                	ret

0000000080003518 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80003518:	7179                	addi	sp,sp,-48
    8000351a:	f406                	sd	ra,40(sp)
    8000351c:	f022                	sd	s0,32(sp)
    8000351e:	1800                	addi	s0,sp,48
    80003520:	87aa                	mv	a5,a0
    80003522:	fcf42e23          	sw	a5,-36(s0)
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80003526:	00013797          	auipc	a5,0x13
    8000352a:	fe278793          	addi	a5,a5,-30 # 80016508 <proc>
    8000352e:	fef43423          	sd	a5,-24(s0)
    80003532:	a0ad                	j	8000359c <kill+0x84>
    acquire(&p->lock);
    80003534:	fe843783          	ld	a5,-24(s0)
    80003538:	853e                	mv	a0,a5
    8000353a:	ffffe097          	auipc	ra,0xffffe
    8000353e:	d44080e7          	jalr	-700(ra) # 8000127e <acquire>
    if(p->pid == pid){
    80003542:	fe843783          	ld	a5,-24(s0)
    80003546:	5b98                	lw	a4,48(a5)
    80003548:	fdc42783          	lw	a5,-36(s0)
    8000354c:	2781                	sext.w	a5,a5
    8000354e:	02e79a63          	bne	a5,a4,80003582 <kill+0x6a>
      p->killed = 1;
    80003552:	fe843783          	ld	a5,-24(s0)
    80003556:	4705                	li	a4,1
    80003558:	d798                	sw	a4,40(a5)
      if(p->state == SLEEPING){
    8000355a:	fe843783          	ld	a5,-24(s0)
    8000355e:	4f9c                	lw	a5,24(a5)
    80003560:	873e                	mv	a4,a5
    80003562:	4789                	li	a5,2
    80003564:	00f71663          	bne	a4,a5,80003570 <kill+0x58>
        // Wake process from sleep().
        p->state = RUNNABLE;
    80003568:	fe843783          	ld	a5,-24(s0)
    8000356c:	470d                	li	a4,3
    8000356e:	cf98                	sw	a4,24(a5)
      }
      release(&p->lock);
    80003570:	fe843783          	ld	a5,-24(s0)
    80003574:	853e                	mv	a0,a5
    80003576:	ffffe097          	auipc	ra,0xffffe
    8000357a:	d6c080e7          	jalr	-660(ra) # 800012e2 <release>
      return 0;
    8000357e:	4781                	li	a5,0
    80003580:	a03d                	j	800035ae <kill+0x96>
    }
    release(&p->lock);
    80003582:	fe843783          	ld	a5,-24(s0)
    80003586:	853e                	mv	a0,a5
    80003588:	ffffe097          	auipc	ra,0xffffe
    8000358c:	d5a080e7          	jalr	-678(ra) # 800012e2 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80003590:	fe843783          	ld	a5,-24(s0)
    80003594:	16878793          	addi	a5,a5,360
    80003598:	fef43423          	sd	a5,-24(s0)
    8000359c:	fe843703          	ld	a4,-24(s0)
    800035a0:	00019797          	auipc	a5,0x19
    800035a4:	96878793          	addi	a5,a5,-1688 # 8001bf08 <pid_lock>
    800035a8:	f8f766e3          	bltu	a4,a5,80003534 <kill+0x1c>
  }
  return -1;
    800035ac:	57fd                	li	a5,-1
}
    800035ae:	853e                	mv	a0,a5
    800035b0:	70a2                	ld	ra,40(sp)
    800035b2:	7402                	ld	s0,32(sp)
    800035b4:	6145                	addi	sp,sp,48
    800035b6:	8082                	ret

00000000800035b8 <setkilled>:

void
setkilled(struct proc *p)
{
    800035b8:	1101                	addi	sp,sp,-32
    800035ba:	ec06                	sd	ra,24(sp)
    800035bc:	e822                	sd	s0,16(sp)
    800035be:	1000                	addi	s0,sp,32
    800035c0:	fea43423          	sd	a0,-24(s0)
  acquire(&p->lock);
    800035c4:	fe843783          	ld	a5,-24(s0)
    800035c8:	853e                	mv	a0,a5
    800035ca:	ffffe097          	auipc	ra,0xffffe
    800035ce:	cb4080e7          	jalr	-844(ra) # 8000127e <acquire>
  p->killed = 1;
    800035d2:	fe843783          	ld	a5,-24(s0)
    800035d6:	4705                	li	a4,1
    800035d8:	d798                	sw	a4,40(a5)
  release(&p->lock);
    800035da:	fe843783          	ld	a5,-24(s0)
    800035de:	853e                	mv	a0,a5
    800035e0:	ffffe097          	auipc	ra,0xffffe
    800035e4:	d02080e7          	jalr	-766(ra) # 800012e2 <release>
}
    800035e8:	0001                	nop
    800035ea:	60e2                	ld	ra,24(sp)
    800035ec:	6442                	ld	s0,16(sp)
    800035ee:	6105                	addi	sp,sp,32
    800035f0:	8082                	ret

00000000800035f2 <killed>:

int
killed(struct proc *p)
{
    800035f2:	7179                	addi	sp,sp,-48
    800035f4:	f406                	sd	ra,40(sp)
    800035f6:	f022                	sd	s0,32(sp)
    800035f8:	1800                	addi	s0,sp,48
    800035fa:	fca43c23          	sd	a0,-40(s0)
  int k;
  
  acquire(&p->lock);
    800035fe:	fd843783          	ld	a5,-40(s0)
    80003602:	853e                	mv	a0,a5
    80003604:	ffffe097          	auipc	ra,0xffffe
    80003608:	c7a080e7          	jalr	-902(ra) # 8000127e <acquire>
  k = p->killed;
    8000360c:	fd843783          	ld	a5,-40(s0)
    80003610:	579c                	lw	a5,40(a5)
    80003612:	fef42623          	sw	a5,-20(s0)
  release(&p->lock);
    80003616:	fd843783          	ld	a5,-40(s0)
    8000361a:	853e                	mv	a0,a5
    8000361c:	ffffe097          	auipc	ra,0xffffe
    80003620:	cc6080e7          	jalr	-826(ra) # 800012e2 <release>
  return k;
    80003624:	fec42783          	lw	a5,-20(s0)
}
    80003628:	853e                	mv	a0,a5
    8000362a:	70a2                	ld	ra,40(sp)
    8000362c:	7402                	ld	s0,32(sp)
    8000362e:	6145                	addi	sp,sp,48
    80003630:	8082                	ret

0000000080003632 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80003632:	7139                	addi	sp,sp,-64
    80003634:	fc06                	sd	ra,56(sp)
    80003636:	f822                	sd	s0,48(sp)
    80003638:	0080                	addi	s0,sp,64
    8000363a:	87aa                	mv	a5,a0
    8000363c:	fcb43823          	sd	a1,-48(s0)
    80003640:	fcc43423          	sd	a2,-56(s0)
    80003644:	fcd43023          	sd	a3,-64(s0)
    80003648:	fcf42e23          	sw	a5,-36(s0)
  struct proc *p = myproc();
    8000364c:	fffff097          	auipc	ra,0xfffff
    80003650:	1fa080e7          	jalr	506(ra) # 80002846 <myproc>
    80003654:	fea43423          	sd	a0,-24(s0)
  if(user_dst){
    80003658:	fdc42783          	lw	a5,-36(s0)
    8000365c:	2781                	sext.w	a5,a5
    8000365e:	c38d                	beqz	a5,80003680 <either_copyout+0x4e>
    return copyout(p->pagetable, dst, src, len);
    80003660:	fe843783          	ld	a5,-24(s0)
    80003664:	6bbc                	ld	a5,80(a5)
    80003666:	fc043683          	ld	a3,-64(s0)
    8000366a:	fc843603          	ld	a2,-56(s0)
    8000366e:	fd043583          	ld	a1,-48(s0)
    80003672:	853e                	mv	a0,a5
    80003674:	fffff097          	auipc	ra,0xfffff
    80003678:	c9c080e7          	jalr	-868(ra) # 80002310 <copyout>
    8000367c:	87aa                	mv	a5,a0
    8000367e:	a839                	j	8000369c <either_copyout+0x6a>
  } else {
    memmove((char *)dst, src, len);
    80003680:	fd043783          	ld	a5,-48(s0)
    80003684:	fc043703          	ld	a4,-64(s0)
    80003688:	2701                	sext.w	a4,a4
    8000368a:	863a                	mv	a2,a4
    8000368c:	fc843583          	ld	a1,-56(s0)
    80003690:	853e                	mv	a0,a5
    80003692:	ffffe097          	auipc	ra,0xffffe
    80003696:	ea4080e7          	jalr	-348(ra) # 80001536 <memmove>
    return 0;
    8000369a:	4781                	li	a5,0
  }
}
    8000369c:	853e                	mv	a0,a5
    8000369e:	70e2                	ld	ra,56(sp)
    800036a0:	7442                	ld	s0,48(sp)
    800036a2:	6121                	addi	sp,sp,64
    800036a4:	8082                	ret

00000000800036a6 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800036a6:	7139                	addi	sp,sp,-64
    800036a8:	fc06                	sd	ra,56(sp)
    800036aa:	f822                	sd	s0,48(sp)
    800036ac:	0080                	addi	s0,sp,64
    800036ae:	fca43c23          	sd	a0,-40(s0)
    800036b2:	87ae                	mv	a5,a1
    800036b4:	fcc43423          	sd	a2,-56(s0)
    800036b8:	fcd43023          	sd	a3,-64(s0)
    800036bc:	fcf42a23          	sw	a5,-44(s0)
  struct proc *p = myproc();
    800036c0:	fffff097          	auipc	ra,0xfffff
    800036c4:	186080e7          	jalr	390(ra) # 80002846 <myproc>
    800036c8:	fea43423          	sd	a0,-24(s0)
  if(user_src){
    800036cc:	fd442783          	lw	a5,-44(s0)
    800036d0:	2781                	sext.w	a5,a5
    800036d2:	c38d                	beqz	a5,800036f4 <either_copyin+0x4e>
    return copyin(p->pagetable, dst, src, len);
    800036d4:	fe843783          	ld	a5,-24(s0)
    800036d8:	6bbc                	ld	a5,80(a5)
    800036da:	fc043683          	ld	a3,-64(s0)
    800036de:	fc843603          	ld	a2,-56(s0)
    800036e2:	fd843583          	ld	a1,-40(s0)
    800036e6:	853e                	mv	a0,a5
    800036e8:	fffff097          	auipc	ra,0xfffff
    800036ec:	cf6080e7          	jalr	-778(ra) # 800023de <copyin>
    800036f0:	87aa                	mv	a5,a0
    800036f2:	a839                	j	80003710 <either_copyin+0x6a>
  } else {
    memmove(dst, (char*)src, len);
    800036f4:	fc843783          	ld	a5,-56(s0)
    800036f8:	fc043703          	ld	a4,-64(s0)
    800036fc:	2701                	sext.w	a4,a4
    800036fe:	863a                	mv	a2,a4
    80003700:	85be                	mv	a1,a5
    80003702:	fd843503          	ld	a0,-40(s0)
    80003706:	ffffe097          	auipc	ra,0xffffe
    8000370a:	e30080e7          	jalr	-464(ra) # 80001536 <memmove>
    return 0;
    8000370e:	4781                	li	a5,0
  }
}
    80003710:	853e                	mv	a0,a5
    80003712:	70e2                	ld	ra,56(sp)
    80003714:	7442                	ld	s0,48(sp)
    80003716:	6121                	addi	sp,sp,64
    80003718:	8082                	ret

000000008000371a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000371a:	1101                	addi	sp,sp,-32
    8000371c:	ec06                	sd	ra,24(sp)
    8000371e:	e822                	sd	s0,16(sp)
    80003720:	1000                	addi	s0,sp,32
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80003722:	00008517          	auipc	a0,0x8
    80003726:	b4650513          	addi	a0,a0,-1210 # 8000b268 <etext+0x268>
    8000372a:	ffffd097          	auipc	ra,0xffffd
    8000372e:	30a080e7          	jalr	778(ra) # 80000a34 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80003732:	00013797          	auipc	a5,0x13
    80003736:	dd678793          	addi	a5,a5,-554 # 80016508 <proc>
    8000373a:	fef43423          	sd	a5,-24(s0)
    8000373e:	a04d                	j	800037e0 <procdump+0xc6>
    if(p->state == UNUSED)
    80003740:	fe843783          	ld	a5,-24(s0)
    80003744:	4f9c                	lw	a5,24(a5)
    80003746:	c7d1                	beqz	a5,800037d2 <procdump+0xb8>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80003748:	fe843783          	ld	a5,-24(s0)
    8000374c:	4f9c                	lw	a5,24(a5)
    8000374e:	873e                	mv	a4,a5
    80003750:	4795                	li	a5,5
    80003752:	02e7ee63          	bltu	a5,a4,8000378e <procdump+0x74>
    80003756:	fe843783          	ld	a5,-24(s0)
    8000375a:	4f9c                	lw	a5,24(a5)
    8000375c:	0000a717          	auipc	a4,0xa
    80003760:	60470713          	addi	a4,a4,1540 # 8000dd60 <states.0>
    80003764:	1782                	slli	a5,a5,0x20
    80003766:	9381                	srli	a5,a5,0x20
    80003768:	078e                	slli	a5,a5,0x3
    8000376a:	97ba                	add	a5,a5,a4
    8000376c:	639c                	ld	a5,0(a5)
    8000376e:	c385                	beqz	a5,8000378e <procdump+0x74>
      state = states[p->state];
    80003770:	fe843783          	ld	a5,-24(s0)
    80003774:	4f9c                	lw	a5,24(a5)
    80003776:	0000a717          	auipc	a4,0xa
    8000377a:	5ea70713          	addi	a4,a4,1514 # 8000dd60 <states.0>
    8000377e:	1782                	slli	a5,a5,0x20
    80003780:	9381                	srli	a5,a5,0x20
    80003782:	078e                	slli	a5,a5,0x3
    80003784:	97ba                	add	a5,a5,a4
    80003786:	639c                	ld	a5,0(a5)
    80003788:	fef43023          	sd	a5,-32(s0)
    8000378c:	a039                	j	8000379a <procdump+0x80>
    else
      state = "???";
    8000378e:	00008797          	auipc	a5,0x8
    80003792:	ae278793          	addi	a5,a5,-1310 # 8000b270 <etext+0x270>
    80003796:	fef43023          	sd	a5,-32(s0)
    printf("%d %s %s", p->pid, state, p->name);
    8000379a:	fe843783          	ld	a5,-24(s0)
    8000379e:	5b98                	lw	a4,48(a5)
    800037a0:	fe843783          	ld	a5,-24(s0)
    800037a4:	15878793          	addi	a5,a5,344
    800037a8:	86be                	mv	a3,a5
    800037aa:	fe043603          	ld	a2,-32(s0)
    800037ae:	85ba                	mv	a1,a4
    800037b0:	00008517          	auipc	a0,0x8
    800037b4:	ac850513          	addi	a0,a0,-1336 # 8000b278 <etext+0x278>
    800037b8:	ffffd097          	auipc	ra,0xffffd
    800037bc:	27c080e7          	jalr	636(ra) # 80000a34 <printf>
    printf("\n");
    800037c0:	00008517          	auipc	a0,0x8
    800037c4:	aa850513          	addi	a0,a0,-1368 # 8000b268 <etext+0x268>
    800037c8:	ffffd097          	auipc	ra,0xffffd
    800037cc:	26c080e7          	jalr	620(ra) # 80000a34 <printf>
    800037d0:	a011                	j	800037d4 <procdump+0xba>
      continue;
    800037d2:	0001                	nop
  for(p = proc; p < &proc[NPROC]; p++){
    800037d4:	fe843783          	ld	a5,-24(s0)
    800037d8:	16878793          	addi	a5,a5,360
    800037dc:	fef43423          	sd	a5,-24(s0)
    800037e0:	fe843703          	ld	a4,-24(s0)
    800037e4:	00018797          	auipc	a5,0x18
    800037e8:	72478793          	addi	a5,a5,1828 # 8001bf08 <pid_lock>
    800037ec:	f4f76ae3          	bltu	a4,a5,80003740 <procdump+0x26>
  }
}
    800037f0:	0001                	nop
    800037f2:	0001                	nop
    800037f4:	60e2                	ld	ra,24(sp)
    800037f6:	6442                	ld	s0,16(sp)
    800037f8:	6105                	addi	sp,sp,32
    800037fa:	8082                	ret

00000000800037fc <getprocesses>:

// Print a list of all process 
// Skips processes which have UNUSED as state
void 
getprocesses(void) {
    800037fc:	1101                	addi	sp,sp,-32
    800037fe:	ec06                	sd	ra,24(sp)
    80003800:	e822                	sd	s0,16(sp)
    80003802:	1000                	addi	s0,sp,32
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++){
    80003804:	00013797          	auipc	a5,0x13
    80003808:	d0478793          	addi	a5,a5,-764 # 80016508 <proc>
    8000380c:	fef43423          	sd	a5,-24(s0)
    80003810:	a83d                	j	8000384e <getprocesses+0x52>
    if(p->state == UNUSED) 
    80003812:	fe843783          	ld	a5,-24(s0)
    80003816:	4f9c                	lw	a5,24(a5)
    80003818:	c7a1                	beqz	a5,80003860 <getprocesses+0x64>
      break;
    printf("%s (%d): %d\n", p->name, p->pid, p->state);
    8000381a:	fe843783          	ld	a5,-24(s0)
    8000381e:	15878713          	addi	a4,a5,344
    80003822:	fe843783          	ld	a5,-24(s0)
    80003826:	5b90                	lw	a2,48(a5)
    80003828:	fe843783          	ld	a5,-24(s0)
    8000382c:	4f9c                	lw	a5,24(a5)
    8000382e:	86be                	mv	a3,a5
    80003830:	85ba                	mv	a1,a4
    80003832:	00008517          	auipc	a0,0x8
    80003836:	a5650513          	addi	a0,a0,-1450 # 8000b288 <etext+0x288>
    8000383a:	ffffd097          	auipc	ra,0xffffd
    8000383e:	1fa080e7          	jalr	506(ra) # 80000a34 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80003842:	fe843783          	ld	a5,-24(s0)
    80003846:	16878793          	addi	a5,a5,360
    8000384a:	fef43423          	sd	a5,-24(s0)
    8000384e:	fe843703          	ld	a4,-24(s0)
    80003852:	00018797          	auipc	a5,0x18
    80003856:	6b678793          	addi	a5,a5,1718 # 8001bf08 <pid_lock>
    8000385a:	faf76ce3          	bltu	a4,a5,80003812 <getprocesses+0x16>
  }

    8000385e:	a011                	j	80003862 <getprocesses+0x66>
      break;
    80003860:	0001                	nop
    80003862:	0001                	nop
    80003864:	60e2                	ld	ra,24(sp)
    80003866:	6442                	ld	s0,16(sp)
    80003868:	6105                	addi	sp,sp,32
    8000386a:	8082                	ret

000000008000386c <swtch>:
    8000386c:	00153023          	sd	ra,0(a0)
    80003870:	00253423          	sd	sp,8(a0)
    80003874:	e900                	sd	s0,16(a0)
    80003876:	ed04                	sd	s1,24(a0)
    80003878:	03253023          	sd	s2,32(a0)
    8000387c:	03353423          	sd	s3,40(a0)
    80003880:	03453823          	sd	s4,48(a0)
    80003884:	03553c23          	sd	s5,56(a0)
    80003888:	05653023          	sd	s6,64(a0)
    8000388c:	05753423          	sd	s7,72(a0)
    80003890:	05853823          	sd	s8,80(a0)
    80003894:	05953c23          	sd	s9,88(a0)
    80003898:	07a53023          	sd	s10,96(a0)
    8000389c:	07b53423          	sd	s11,104(a0)
    800038a0:	0005b083          	ld	ra,0(a1)
    800038a4:	0085b103          	ld	sp,8(a1)
    800038a8:	6980                	ld	s0,16(a1)
    800038aa:	6d84                	ld	s1,24(a1)
    800038ac:	0205b903          	ld	s2,32(a1)
    800038b0:	0285b983          	ld	s3,40(a1)
    800038b4:	0305ba03          	ld	s4,48(a1)
    800038b8:	0385ba83          	ld	s5,56(a1)
    800038bc:	0405bb03          	ld	s6,64(a1)
    800038c0:	0485bb83          	ld	s7,72(a1)
    800038c4:	0505bc03          	ld	s8,80(a1)
    800038c8:	0585bc83          	ld	s9,88(a1)
    800038cc:	0605bd03          	ld	s10,96(a1)
    800038d0:	0685bd83          	ld	s11,104(a1)
    800038d4:	8082                	ret

00000000800038d6 <r_sstatus>:
{
    800038d6:	1101                	addi	sp,sp,-32
    800038d8:	ec22                	sd	s0,24(sp)
    800038da:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800038dc:	100027f3          	csrr	a5,sstatus
    800038e0:	fef43423          	sd	a5,-24(s0)
  return x;
    800038e4:	fe843783          	ld	a5,-24(s0)
}
    800038e8:	853e                	mv	a0,a5
    800038ea:	6462                	ld	s0,24(sp)
    800038ec:	6105                	addi	sp,sp,32
    800038ee:	8082                	ret

00000000800038f0 <w_sstatus>:
{
    800038f0:	1101                	addi	sp,sp,-32
    800038f2:	ec22                	sd	s0,24(sp)
    800038f4:	1000                	addi	s0,sp,32
    800038f6:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800038fa:	fe843783          	ld	a5,-24(s0)
    800038fe:	10079073          	csrw	sstatus,a5
}
    80003902:	0001                	nop
    80003904:	6462                	ld	s0,24(sp)
    80003906:	6105                	addi	sp,sp,32
    80003908:	8082                	ret

000000008000390a <r_sip>:
{
    8000390a:	1101                	addi	sp,sp,-32
    8000390c:	ec22                	sd	s0,24(sp)
    8000390e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sip" : "=r" (x) );
    80003910:	144027f3          	csrr	a5,sip
    80003914:	fef43423          	sd	a5,-24(s0)
  return x;
    80003918:	fe843783          	ld	a5,-24(s0)
}
    8000391c:	853e                	mv	a0,a5
    8000391e:	6462                	ld	s0,24(sp)
    80003920:	6105                	addi	sp,sp,32
    80003922:	8082                	ret

0000000080003924 <w_sip>:
{
    80003924:	1101                	addi	sp,sp,-32
    80003926:	ec22                	sd	s0,24(sp)
    80003928:	1000                	addi	s0,sp,32
    8000392a:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw sip, %0" : : "r" (x));
    8000392e:	fe843783          	ld	a5,-24(s0)
    80003932:	14479073          	csrw	sip,a5
}
    80003936:	0001                	nop
    80003938:	6462                	ld	s0,24(sp)
    8000393a:	6105                	addi	sp,sp,32
    8000393c:	8082                	ret

000000008000393e <w_sepc>:
{
    8000393e:	1101                	addi	sp,sp,-32
    80003940:	ec22                	sd	s0,24(sp)
    80003942:	1000                	addi	s0,sp,32
    80003944:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80003948:	fe843783          	ld	a5,-24(s0)
    8000394c:	14179073          	csrw	sepc,a5
}
    80003950:	0001                	nop
    80003952:	6462                	ld	s0,24(sp)
    80003954:	6105                	addi	sp,sp,32
    80003956:	8082                	ret

0000000080003958 <r_sepc>:
{
    80003958:	1101                	addi	sp,sp,-32
    8000395a:	ec22                	sd	s0,24(sp)
    8000395c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000395e:	141027f3          	csrr	a5,sepc
    80003962:	fef43423          	sd	a5,-24(s0)
  return x;
    80003966:	fe843783          	ld	a5,-24(s0)
}
    8000396a:	853e                	mv	a0,a5
    8000396c:	6462                	ld	s0,24(sp)
    8000396e:	6105                	addi	sp,sp,32
    80003970:	8082                	ret

0000000080003972 <w_stvec>:
{
    80003972:	1101                	addi	sp,sp,-32
    80003974:	ec22                	sd	s0,24(sp)
    80003976:	1000                	addi	s0,sp,32
    80003978:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000397c:	fe843783          	ld	a5,-24(s0)
    80003980:	10579073          	csrw	stvec,a5
}
    80003984:	0001                	nop
    80003986:	6462                	ld	s0,24(sp)
    80003988:	6105                	addi	sp,sp,32
    8000398a:	8082                	ret

000000008000398c <r_satp>:
{
    8000398c:	1101                	addi	sp,sp,-32
    8000398e:	ec22                	sd	s0,24(sp)
    80003990:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, satp" : "=r" (x) );
    80003992:	180027f3          	csrr	a5,satp
    80003996:	fef43423          	sd	a5,-24(s0)
  return x;
    8000399a:	fe843783          	ld	a5,-24(s0)
}
    8000399e:	853e                	mv	a0,a5
    800039a0:	6462                	ld	s0,24(sp)
    800039a2:	6105                	addi	sp,sp,32
    800039a4:	8082                	ret

00000000800039a6 <r_scause>:
{
    800039a6:	1101                	addi	sp,sp,-32
    800039a8:	ec22                	sd	s0,24(sp)
    800039aa:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800039ac:	142027f3          	csrr	a5,scause
    800039b0:	fef43423          	sd	a5,-24(s0)
  return x;
    800039b4:	fe843783          	ld	a5,-24(s0)
}
    800039b8:	853e                	mv	a0,a5
    800039ba:	6462                	ld	s0,24(sp)
    800039bc:	6105                	addi	sp,sp,32
    800039be:	8082                	ret

00000000800039c0 <r_stval>:
{
    800039c0:	1101                	addi	sp,sp,-32
    800039c2:	ec22                	sd	s0,24(sp)
    800039c4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, stval" : "=r" (x) );
    800039c6:	143027f3          	csrr	a5,stval
    800039ca:	fef43423          	sd	a5,-24(s0)
  return x;
    800039ce:	fe843783          	ld	a5,-24(s0)
}
    800039d2:	853e                	mv	a0,a5
    800039d4:	6462                	ld	s0,24(sp)
    800039d6:	6105                	addi	sp,sp,32
    800039d8:	8082                	ret

00000000800039da <intr_on>:
{
    800039da:	1141                	addi	sp,sp,-16
    800039dc:	e406                	sd	ra,8(sp)
    800039de:	e022                	sd	s0,0(sp)
    800039e0:	0800                	addi	s0,sp,16
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800039e2:	00000097          	auipc	ra,0x0
    800039e6:	ef4080e7          	jalr	-268(ra) # 800038d6 <r_sstatus>
    800039ea:	87aa                	mv	a5,a0
    800039ec:	0027e793          	ori	a5,a5,2
    800039f0:	853e                	mv	a0,a5
    800039f2:	00000097          	auipc	ra,0x0
    800039f6:	efe080e7          	jalr	-258(ra) # 800038f0 <w_sstatus>
}
    800039fa:	0001                	nop
    800039fc:	60a2                	ld	ra,8(sp)
    800039fe:	6402                	ld	s0,0(sp)
    80003a00:	0141                	addi	sp,sp,16
    80003a02:	8082                	ret

0000000080003a04 <intr_off>:
{
    80003a04:	1141                	addi	sp,sp,-16
    80003a06:	e406                	sd	ra,8(sp)
    80003a08:	e022                	sd	s0,0(sp)
    80003a0a:	0800                	addi	s0,sp,16
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80003a0c:	00000097          	auipc	ra,0x0
    80003a10:	eca080e7          	jalr	-310(ra) # 800038d6 <r_sstatus>
    80003a14:	87aa                	mv	a5,a0
    80003a16:	9bf5                	andi	a5,a5,-3
    80003a18:	853e                	mv	a0,a5
    80003a1a:	00000097          	auipc	ra,0x0
    80003a1e:	ed6080e7          	jalr	-298(ra) # 800038f0 <w_sstatus>
}
    80003a22:	0001                	nop
    80003a24:	60a2                	ld	ra,8(sp)
    80003a26:	6402                	ld	s0,0(sp)
    80003a28:	0141                	addi	sp,sp,16
    80003a2a:	8082                	ret

0000000080003a2c <intr_get>:
{
    80003a2c:	1101                	addi	sp,sp,-32
    80003a2e:	ec06                	sd	ra,24(sp)
    80003a30:	e822                	sd	s0,16(sp)
    80003a32:	1000                	addi	s0,sp,32
  uint64 x = r_sstatus();
    80003a34:	00000097          	auipc	ra,0x0
    80003a38:	ea2080e7          	jalr	-350(ra) # 800038d6 <r_sstatus>
    80003a3c:	fea43423          	sd	a0,-24(s0)
  return (x & SSTATUS_SIE) != 0;
    80003a40:	fe843783          	ld	a5,-24(s0)
    80003a44:	8b89                	andi	a5,a5,2
    80003a46:	00f037b3          	snez	a5,a5
    80003a4a:	0ff7f793          	zext.b	a5,a5
    80003a4e:	2781                	sext.w	a5,a5
}
    80003a50:	853e                	mv	a0,a5
    80003a52:	60e2                	ld	ra,24(sp)
    80003a54:	6442                	ld	s0,16(sp)
    80003a56:	6105                	addi	sp,sp,32
    80003a58:	8082                	ret

0000000080003a5a <r_tp>:
{
    80003a5a:	1101                	addi	sp,sp,-32
    80003a5c:	ec22                	sd	s0,24(sp)
    80003a5e:	1000                	addi	s0,sp,32
  asm volatile("mv %0, tp" : "=r" (x) );
    80003a60:	8792                	mv	a5,tp
    80003a62:	fef43423          	sd	a5,-24(s0)
  return x;
    80003a66:	fe843783          	ld	a5,-24(s0)
}
    80003a6a:	853e                	mv	a0,a5
    80003a6c:	6462                	ld	s0,24(sp)
    80003a6e:	6105                	addi	sp,sp,32
    80003a70:	8082                	ret

0000000080003a72 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80003a72:	1141                	addi	sp,sp,-16
    80003a74:	e406                	sd	ra,8(sp)
    80003a76:	e022                	sd	s0,0(sp)
    80003a78:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80003a7a:	00008597          	auipc	a1,0x8
    80003a7e:	85658593          	addi	a1,a1,-1962 # 8000b2d0 <etext+0x2d0>
    80003a82:	00018517          	auipc	a0,0x18
    80003a86:	4b650513          	addi	a0,a0,1206 # 8001bf38 <tickslock>
    80003a8a:	ffffd097          	auipc	ra,0xffffd
    80003a8e:	7c4080e7          	jalr	1988(ra) # 8000124e <initlock>
}
    80003a92:	0001                	nop
    80003a94:	60a2                	ld	ra,8(sp)
    80003a96:	6402                	ld	s0,0(sp)
    80003a98:	0141                	addi	sp,sp,16
    80003a9a:	8082                	ret

0000000080003a9c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80003a9c:	1141                	addi	sp,sp,-16
    80003a9e:	e406                	sd	ra,8(sp)
    80003aa0:	e022                	sd	s0,0(sp)
    80003aa2:	0800                	addi	s0,sp,16
  w_stvec((uint64)kernelvec);
    80003aa4:	00005797          	auipc	a5,0x5
    80003aa8:	d6c78793          	addi	a5,a5,-660 # 80008810 <kernelvec>
    80003aac:	853e                	mv	a0,a5
    80003aae:	00000097          	auipc	ra,0x0
    80003ab2:	ec4080e7          	jalr	-316(ra) # 80003972 <w_stvec>
}
    80003ab6:	0001                	nop
    80003ab8:	60a2                	ld	ra,8(sp)
    80003aba:	6402                	ld	s0,0(sp)
    80003abc:	0141                	addi	sp,sp,16
    80003abe:	8082                	ret

0000000080003ac0 <usertrap>:
// handle an interrupt, exception, or system call from user space.
// called from trampoline.S
//
void
usertrap(void)
{
    80003ac0:	7179                	addi	sp,sp,-48
    80003ac2:	f406                	sd	ra,40(sp)
    80003ac4:	f022                	sd	s0,32(sp)
    80003ac6:	ec26                	sd	s1,24(sp)
    80003ac8:	1800                	addi	s0,sp,48
  int which_dev = 0;
    80003aca:	fc042e23          	sw	zero,-36(s0)

  if((r_sstatus() & SSTATUS_SPP) != 0)
    80003ace:	00000097          	auipc	ra,0x0
    80003ad2:	e08080e7          	jalr	-504(ra) # 800038d6 <r_sstatus>
    80003ad6:	87aa                	mv	a5,a0
    80003ad8:	1007f793          	andi	a5,a5,256
    80003adc:	cb89                	beqz	a5,80003aee <usertrap+0x2e>
    panic("usertrap: not from user mode");
    80003ade:	00007517          	auipc	a0,0x7
    80003ae2:	7fa50513          	addi	a0,a0,2042 # 8000b2d8 <etext+0x2d8>
    80003ae6:	ffffd097          	auipc	ra,0xffffd
    80003aea:	1a4080e7          	jalr	420(ra) # 80000c8a <panic>

  // send interrupts and exceptions to kerneltrap(),
  // since we're now in the kernel.
  w_stvec((uint64)kernelvec);
    80003aee:	00005797          	auipc	a5,0x5
    80003af2:	d2278793          	addi	a5,a5,-734 # 80008810 <kernelvec>
    80003af6:	853e                	mv	a0,a5
    80003af8:	00000097          	auipc	ra,0x0
    80003afc:	e7a080e7          	jalr	-390(ra) # 80003972 <w_stvec>

  struct proc *p = myproc();
    80003b00:	fffff097          	auipc	ra,0xfffff
    80003b04:	d46080e7          	jalr	-698(ra) # 80002846 <myproc>
    80003b08:	fca43823          	sd	a0,-48(s0)
  
  // save user program counter.
  p->trapframe->epc = r_sepc();
    80003b0c:	fd043783          	ld	a5,-48(s0)
    80003b10:	6fa4                	ld	s1,88(a5)
    80003b12:	00000097          	auipc	ra,0x0
    80003b16:	e46080e7          	jalr	-442(ra) # 80003958 <r_sepc>
    80003b1a:	87aa                	mv	a5,a0
    80003b1c:	ec9c                	sd	a5,24(s1)
  
  if(r_scause() == 8){
    80003b1e:	00000097          	auipc	ra,0x0
    80003b22:	e88080e7          	jalr	-376(ra) # 800039a6 <r_scause>
    80003b26:	872a                	mv	a4,a0
    80003b28:	47a1                	li	a5,8
    80003b2a:	04f71163          	bne	a4,a5,80003b6c <usertrap+0xac>
    // system call

    if(killed(p))
    80003b2e:	fd043503          	ld	a0,-48(s0)
    80003b32:	00000097          	auipc	ra,0x0
    80003b36:	ac0080e7          	jalr	-1344(ra) # 800035f2 <killed>
    80003b3a:	87aa                	mv	a5,a0
    80003b3c:	c791                	beqz	a5,80003b48 <usertrap+0x88>
      exit(-1);
    80003b3e:	557d                	li	a0,-1
    80003b40:	fffff097          	auipc	ra,0xfffff
    80003b44:	3f8080e7          	jalr	1016(ra) # 80002f38 <exit>

    // sepc points to the ecall instruction,
    // but we want to return to the next instruction.
    p->trapframe->epc += 4;
    80003b48:	fd043783          	ld	a5,-48(s0)
    80003b4c:	6fbc                	ld	a5,88(a5)
    80003b4e:	6f98                	ld	a4,24(a5)
    80003b50:	fd043783          	ld	a5,-48(s0)
    80003b54:	6fbc                	ld	a5,88(a5)
    80003b56:	0711                	addi	a4,a4,4
    80003b58:	ef98                	sd	a4,24(a5)

    // an interrupt will change sepc, scause, and sstatus,
    // so enable only now that we're done with those registers.
    intr_on();
    80003b5a:	00000097          	auipc	ra,0x0
    80003b5e:	e80080e7          	jalr	-384(ra) # 800039da <intr_on>

    syscall();
    80003b62:	00000097          	auipc	ra,0x0
    80003b66:	66c080e7          	jalr	1644(ra) # 800041ce <syscall>
    80003b6a:	a885                	j	80003bda <usertrap+0x11a>
  } else if((which_dev = devintr()) != 0){
    80003b6c:	00000097          	auipc	ra,0x0
    80003b70:	34e080e7          	jalr	846(ra) # 80003eba <devintr>
    80003b74:	87aa                	mv	a5,a0
    80003b76:	fcf42e23          	sw	a5,-36(s0)
    80003b7a:	fdc42783          	lw	a5,-36(s0)
    80003b7e:	2781                	sext.w	a5,a5
    80003b80:	efa9                	bnez	a5,80003bda <usertrap+0x11a>
    // ok
  } else {
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80003b82:	00000097          	auipc	ra,0x0
    80003b86:	e24080e7          	jalr	-476(ra) # 800039a6 <r_scause>
    80003b8a:	872a                	mv	a4,a0
    80003b8c:	fd043783          	ld	a5,-48(s0)
    80003b90:	5b9c                	lw	a5,48(a5)
    80003b92:	863e                	mv	a2,a5
    80003b94:	85ba                	mv	a1,a4
    80003b96:	00007517          	auipc	a0,0x7
    80003b9a:	76250513          	addi	a0,a0,1890 # 8000b2f8 <etext+0x2f8>
    80003b9e:	ffffd097          	auipc	ra,0xffffd
    80003ba2:	e96080e7          	jalr	-362(ra) # 80000a34 <printf>
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003ba6:	00000097          	auipc	ra,0x0
    80003baa:	db2080e7          	jalr	-590(ra) # 80003958 <r_sepc>
    80003bae:	84aa                	mv	s1,a0
    80003bb0:	00000097          	auipc	ra,0x0
    80003bb4:	e10080e7          	jalr	-496(ra) # 800039c0 <r_stval>
    80003bb8:	87aa                	mv	a5,a0
    80003bba:	863e                	mv	a2,a5
    80003bbc:	85a6                	mv	a1,s1
    80003bbe:	00007517          	auipc	a0,0x7
    80003bc2:	76a50513          	addi	a0,a0,1898 # 8000b328 <etext+0x328>
    80003bc6:	ffffd097          	auipc	ra,0xffffd
    80003bca:	e6e080e7          	jalr	-402(ra) # 80000a34 <printf>
    setkilled(p);
    80003bce:	fd043503          	ld	a0,-48(s0)
    80003bd2:	00000097          	auipc	ra,0x0
    80003bd6:	9e6080e7          	jalr	-1562(ra) # 800035b8 <setkilled>
  }

  if(killed(p))
    80003bda:	fd043503          	ld	a0,-48(s0)
    80003bde:	00000097          	auipc	ra,0x0
    80003be2:	a14080e7          	jalr	-1516(ra) # 800035f2 <killed>
    80003be6:	87aa                	mv	a5,a0
    80003be8:	c791                	beqz	a5,80003bf4 <usertrap+0x134>
    exit(-1);
    80003bea:	557d                	li	a0,-1
    80003bec:	fffff097          	auipc	ra,0xfffff
    80003bf0:	34c080e7          	jalr	844(ra) # 80002f38 <exit>

  // give up the CPU if this is a timer interrupt.
  if(which_dev == 2)
    80003bf4:	fdc42783          	lw	a5,-36(s0)
    80003bf8:	0007871b          	sext.w	a4,a5
    80003bfc:	4789                	li	a5,2
    80003bfe:	00f71663          	bne	a4,a5,80003c0a <usertrap+0x14a>
    yield();
    80003c02:	fffff097          	auipc	ra,0xfffff
    80003c06:	76c080e7          	jalr	1900(ra) # 8000336e <yield>

  usertrapret();
    80003c0a:	00000097          	auipc	ra,0x0
    80003c0e:	014080e7          	jalr	20(ra) # 80003c1e <usertrapret>
}
    80003c12:	0001                	nop
    80003c14:	70a2                	ld	ra,40(sp)
    80003c16:	7402                	ld	s0,32(sp)
    80003c18:	64e2                	ld	s1,24(sp)
    80003c1a:	6145                	addi	sp,sp,48
    80003c1c:	8082                	ret

0000000080003c1e <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80003c1e:	715d                	addi	sp,sp,-80
    80003c20:	e486                	sd	ra,72(sp)
    80003c22:	e0a2                	sd	s0,64(sp)
    80003c24:	fc26                	sd	s1,56(sp)
    80003c26:	0880                	addi	s0,sp,80
  struct proc *p = myproc();
    80003c28:	fffff097          	auipc	ra,0xfffff
    80003c2c:	c1e080e7          	jalr	-994(ra) # 80002846 <myproc>
    80003c30:	fca43c23          	sd	a0,-40(s0)

  // we're about to switch the destination of traps from
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();
    80003c34:	00000097          	auipc	ra,0x0
    80003c38:	dd0080e7          	jalr	-560(ra) # 80003a04 <intr_off>

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80003c3c:	00006717          	auipc	a4,0x6
    80003c40:	3c470713          	addi	a4,a4,964 # 8000a000 <_trampoline>
    80003c44:	00006797          	auipc	a5,0x6
    80003c48:	3bc78793          	addi	a5,a5,956 # 8000a000 <_trampoline>
    80003c4c:	8f1d                	sub	a4,a4,a5
    80003c4e:	040007b7          	lui	a5,0x4000
    80003c52:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80003c54:	07b2                	slli	a5,a5,0xc
    80003c56:	97ba                	add	a5,a5,a4
    80003c58:	fcf43823          	sd	a5,-48(s0)
  w_stvec(trampoline_uservec);
    80003c5c:	fd043503          	ld	a0,-48(s0)
    80003c60:	00000097          	auipc	ra,0x0
    80003c64:	d12080e7          	jalr	-750(ra) # 80003972 <w_stvec>

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80003c68:	fd843783          	ld	a5,-40(s0)
    80003c6c:	6fa4                	ld	s1,88(a5)
    80003c6e:	00000097          	auipc	ra,0x0
    80003c72:	d1e080e7          	jalr	-738(ra) # 8000398c <r_satp>
    80003c76:	87aa                	mv	a5,a0
    80003c78:	e09c                	sd	a5,0(s1)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80003c7a:	fd843783          	ld	a5,-40(s0)
    80003c7e:	63b4                	ld	a3,64(a5)
    80003c80:	fd843783          	ld	a5,-40(s0)
    80003c84:	6fbc                	ld	a5,88(a5)
    80003c86:	6705                	lui	a4,0x1
    80003c88:	9736                	add	a4,a4,a3
    80003c8a:	e798                	sd	a4,8(a5)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80003c8c:	fd843783          	ld	a5,-40(s0)
    80003c90:	6fbc                	ld	a5,88(a5)
    80003c92:	00000717          	auipc	a4,0x0
    80003c96:	e2e70713          	addi	a4,a4,-466 # 80003ac0 <usertrap>
    80003c9a:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80003c9c:	fd843783          	ld	a5,-40(s0)
    80003ca0:	6fa4                	ld	s1,88(a5)
    80003ca2:	00000097          	auipc	ra,0x0
    80003ca6:	db8080e7          	jalr	-584(ra) # 80003a5a <r_tp>
    80003caa:	87aa                	mv	a5,a0
    80003cac:	f09c                	sd	a5,32(s1)

  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
    80003cae:	00000097          	auipc	ra,0x0
    80003cb2:	c28080e7          	jalr	-984(ra) # 800038d6 <r_sstatus>
    80003cb6:	fca43423          	sd	a0,-56(s0)
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80003cba:	fc843783          	ld	a5,-56(s0)
    80003cbe:	eff7f793          	andi	a5,a5,-257
    80003cc2:	fcf43423          	sd	a5,-56(s0)
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80003cc6:	fc843783          	ld	a5,-56(s0)
    80003cca:	0207e793          	ori	a5,a5,32
    80003cce:	fcf43423          	sd	a5,-56(s0)
  w_sstatus(x);
    80003cd2:	fc843503          	ld	a0,-56(s0)
    80003cd6:	00000097          	auipc	ra,0x0
    80003cda:	c1a080e7          	jalr	-998(ra) # 800038f0 <w_sstatus>

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80003cde:	fd843783          	ld	a5,-40(s0)
    80003ce2:	6fbc                	ld	a5,88(a5)
    80003ce4:	6f9c                	ld	a5,24(a5)
    80003ce6:	853e                	mv	a0,a5
    80003ce8:	00000097          	auipc	ra,0x0
    80003cec:	c56080e7          	jalr	-938(ra) # 8000393e <w_sepc>

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80003cf0:	fd843783          	ld	a5,-40(s0)
    80003cf4:	6bbc                	ld	a5,80(a5)
    80003cf6:	00c7d713          	srli	a4,a5,0xc
    80003cfa:	57fd                	li	a5,-1
    80003cfc:	17fe                	slli	a5,a5,0x3f
    80003cfe:	8fd9                	or	a5,a5,a4
    80003d00:	fcf43023          	sd	a5,-64(s0)

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80003d04:	00006717          	auipc	a4,0x6
    80003d08:	39870713          	addi	a4,a4,920 # 8000a09c <userret>
    80003d0c:	00006797          	auipc	a5,0x6
    80003d10:	2f478793          	addi	a5,a5,756 # 8000a000 <_trampoline>
    80003d14:	8f1d                	sub	a4,a4,a5
    80003d16:	040007b7          	lui	a5,0x4000
    80003d1a:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80003d1c:	07b2                	slli	a5,a5,0xc
    80003d1e:	97ba                	add	a5,a5,a4
    80003d20:	faf43c23          	sd	a5,-72(s0)
  ((void (*)(uint64))trampoline_userret)(satp);
    80003d24:	fb843783          	ld	a5,-72(s0)
    80003d28:	fc043503          	ld	a0,-64(s0)
    80003d2c:	9782                	jalr	a5
}
    80003d2e:	0001                	nop
    80003d30:	60a6                	ld	ra,72(sp)
    80003d32:	6406                	ld	s0,64(sp)
    80003d34:	74e2                	ld	s1,56(sp)
    80003d36:	6161                	addi	sp,sp,80
    80003d38:	8082                	ret

0000000080003d3a <kerneltrap>:

// interrupts and exceptions from kernel code go here via kernelvec,
// on whatever the current kernel stack is.
void 
kerneltrap()
{
    80003d3a:	7139                	addi	sp,sp,-64
    80003d3c:	fc06                	sd	ra,56(sp)
    80003d3e:	f822                	sd	s0,48(sp)
    80003d40:	f426                	sd	s1,40(sp)
    80003d42:	0080                	addi	s0,sp,64
  int which_dev = 0;
    80003d44:	fc042e23          	sw	zero,-36(s0)
  uint64 sepc = r_sepc();
    80003d48:	00000097          	auipc	ra,0x0
    80003d4c:	c10080e7          	jalr	-1008(ra) # 80003958 <r_sepc>
    80003d50:	fca43823          	sd	a0,-48(s0)
  uint64 sstatus = r_sstatus();
    80003d54:	00000097          	auipc	ra,0x0
    80003d58:	b82080e7          	jalr	-1150(ra) # 800038d6 <r_sstatus>
    80003d5c:	fca43423          	sd	a0,-56(s0)
  uint64 scause = r_scause();
    80003d60:	00000097          	auipc	ra,0x0
    80003d64:	c46080e7          	jalr	-954(ra) # 800039a6 <r_scause>
    80003d68:	fca43023          	sd	a0,-64(s0)
  
  if((sstatus & SSTATUS_SPP) == 0)
    80003d6c:	fc843783          	ld	a5,-56(s0)
    80003d70:	1007f793          	andi	a5,a5,256
    80003d74:	eb89                	bnez	a5,80003d86 <kerneltrap+0x4c>
    panic("kerneltrap: not from supervisor mode");
    80003d76:	00007517          	auipc	a0,0x7
    80003d7a:	5d250513          	addi	a0,a0,1490 # 8000b348 <etext+0x348>
    80003d7e:	ffffd097          	auipc	ra,0xffffd
    80003d82:	f0c080e7          	jalr	-244(ra) # 80000c8a <panic>
  if(intr_get() != 0)
    80003d86:	00000097          	auipc	ra,0x0
    80003d8a:	ca6080e7          	jalr	-858(ra) # 80003a2c <intr_get>
    80003d8e:	87aa                	mv	a5,a0
    80003d90:	cb89                	beqz	a5,80003da2 <kerneltrap+0x68>
    panic("kerneltrap: interrupts enabled");
    80003d92:	00007517          	auipc	a0,0x7
    80003d96:	5de50513          	addi	a0,a0,1502 # 8000b370 <etext+0x370>
    80003d9a:	ffffd097          	auipc	ra,0xffffd
    80003d9e:	ef0080e7          	jalr	-272(ra) # 80000c8a <panic>

  if((which_dev = devintr()) == 0){
    80003da2:	00000097          	auipc	ra,0x0
    80003da6:	118080e7          	jalr	280(ra) # 80003eba <devintr>
    80003daa:	87aa                	mv	a5,a0
    80003dac:	fcf42e23          	sw	a5,-36(s0)
    80003db0:	fdc42783          	lw	a5,-36(s0)
    80003db4:	2781                	sext.w	a5,a5
    80003db6:	e7b9                	bnez	a5,80003e04 <kerneltrap+0xca>
    printf("scause %p\n", scause);
    80003db8:	fc043583          	ld	a1,-64(s0)
    80003dbc:	00007517          	auipc	a0,0x7
    80003dc0:	5d450513          	addi	a0,a0,1492 # 8000b390 <etext+0x390>
    80003dc4:	ffffd097          	auipc	ra,0xffffd
    80003dc8:	c70080e7          	jalr	-912(ra) # 80000a34 <printf>
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003dcc:	00000097          	auipc	ra,0x0
    80003dd0:	b8c080e7          	jalr	-1140(ra) # 80003958 <r_sepc>
    80003dd4:	84aa                	mv	s1,a0
    80003dd6:	00000097          	auipc	ra,0x0
    80003dda:	bea080e7          	jalr	-1046(ra) # 800039c0 <r_stval>
    80003dde:	87aa                	mv	a5,a0
    80003de0:	863e                	mv	a2,a5
    80003de2:	85a6                	mv	a1,s1
    80003de4:	00007517          	auipc	a0,0x7
    80003de8:	5bc50513          	addi	a0,a0,1468 # 8000b3a0 <etext+0x3a0>
    80003dec:	ffffd097          	auipc	ra,0xffffd
    80003df0:	c48080e7          	jalr	-952(ra) # 80000a34 <printf>
    panic("kerneltrap");
    80003df4:	00007517          	auipc	a0,0x7
    80003df8:	5c450513          	addi	a0,a0,1476 # 8000b3b8 <etext+0x3b8>
    80003dfc:	ffffd097          	auipc	ra,0xffffd
    80003e00:	e8e080e7          	jalr	-370(ra) # 80000c8a <panic>
  }

  // give up the CPU if this is a timer interrupt.
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80003e04:	fdc42783          	lw	a5,-36(s0)
    80003e08:	0007871b          	sext.w	a4,a5
    80003e0c:	4789                	li	a5,2
    80003e0e:	02f71663          	bne	a4,a5,80003e3a <kerneltrap+0x100>
    80003e12:	fffff097          	auipc	ra,0xfffff
    80003e16:	a34080e7          	jalr	-1484(ra) # 80002846 <myproc>
    80003e1a:	87aa                	mv	a5,a0
    80003e1c:	cf99                	beqz	a5,80003e3a <kerneltrap+0x100>
    80003e1e:	fffff097          	auipc	ra,0xfffff
    80003e22:	a28080e7          	jalr	-1496(ra) # 80002846 <myproc>
    80003e26:	87aa                	mv	a5,a0
    80003e28:	4f9c                	lw	a5,24(a5)
    80003e2a:	873e                	mv	a4,a5
    80003e2c:	4791                	li	a5,4
    80003e2e:	00f71663          	bne	a4,a5,80003e3a <kerneltrap+0x100>
    yield();
    80003e32:	fffff097          	auipc	ra,0xfffff
    80003e36:	53c080e7          	jalr	1340(ra) # 8000336e <yield>

  // the yield() may have caused some traps to occur,
  // so restore trap registers for use by kernelvec.S's sepc instruction.
  w_sepc(sepc);
    80003e3a:	fd043503          	ld	a0,-48(s0)
    80003e3e:	00000097          	auipc	ra,0x0
    80003e42:	b00080e7          	jalr	-1280(ra) # 8000393e <w_sepc>
  w_sstatus(sstatus);
    80003e46:	fc843503          	ld	a0,-56(s0)
    80003e4a:	00000097          	auipc	ra,0x0
    80003e4e:	aa6080e7          	jalr	-1370(ra) # 800038f0 <w_sstatus>
}
    80003e52:	0001                	nop
    80003e54:	70e2                	ld	ra,56(sp)
    80003e56:	7442                	ld	s0,48(sp)
    80003e58:	74a2                	ld	s1,40(sp)
    80003e5a:	6121                	addi	sp,sp,64
    80003e5c:	8082                	ret

0000000080003e5e <clockintr>:

void
clockintr()
{
    80003e5e:	1141                	addi	sp,sp,-16
    80003e60:	e406                	sd	ra,8(sp)
    80003e62:	e022                	sd	s0,0(sp)
    80003e64:	0800                	addi	s0,sp,16
  acquire(&tickslock);
    80003e66:	00018517          	auipc	a0,0x18
    80003e6a:	0d250513          	addi	a0,a0,210 # 8001bf38 <tickslock>
    80003e6e:	ffffd097          	auipc	ra,0xffffd
    80003e72:	410080e7          	jalr	1040(ra) # 8000127e <acquire>
  ticks++;
    80003e76:	0000a797          	auipc	a5,0xa
    80003e7a:	02278793          	addi	a5,a5,34 # 8000de98 <ticks>
    80003e7e:	439c                	lw	a5,0(a5)
    80003e80:	2785                	addiw	a5,a5,1
    80003e82:	0007871b          	sext.w	a4,a5
    80003e86:	0000a797          	auipc	a5,0xa
    80003e8a:	01278793          	addi	a5,a5,18 # 8000de98 <ticks>
    80003e8e:	c398                	sw	a4,0(a5)
  wakeup(&ticks);
    80003e90:	0000a517          	auipc	a0,0xa
    80003e94:	00850513          	addi	a0,a0,8 # 8000de98 <ticks>
    80003e98:	fffff097          	auipc	ra,0xfffff
    80003e9c:	5ec080e7          	jalr	1516(ra) # 80003484 <wakeup>
  release(&tickslock);
    80003ea0:	00018517          	auipc	a0,0x18
    80003ea4:	09850513          	addi	a0,a0,152 # 8001bf38 <tickslock>
    80003ea8:	ffffd097          	auipc	ra,0xffffd
    80003eac:	43a080e7          	jalr	1082(ra) # 800012e2 <release>
}
    80003eb0:	0001                	nop
    80003eb2:	60a2                	ld	ra,8(sp)
    80003eb4:	6402                	ld	s0,0(sp)
    80003eb6:	0141                	addi	sp,sp,16
    80003eb8:	8082                	ret

0000000080003eba <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80003eba:	1101                	addi	sp,sp,-32
    80003ebc:	ec06                	sd	ra,24(sp)
    80003ebe:	e822                	sd	s0,16(sp)
    80003ec0:	1000                	addi	s0,sp,32
  uint64 scause = r_scause();
    80003ec2:	00000097          	auipc	ra,0x0
    80003ec6:	ae4080e7          	jalr	-1308(ra) # 800039a6 <r_scause>
    80003eca:	fea43423          	sd	a0,-24(s0)

  if((scause & 0x8000000000000000L) &&
    80003ece:	fe843783          	ld	a5,-24(s0)
    80003ed2:	0807d463          	bgez	a5,80003f5a <devintr+0xa0>
     (scause & 0xff) == 9){
    80003ed6:	fe843783          	ld	a5,-24(s0)
    80003eda:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80003ede:	47a5                	li	a5,9
    80003ee0:	06f71d63          	bne	a4,a5,80003f5a <devintr+0xa0>
    // this is a supervisor external interrupt, via PLIC.

    // irq indicates which device interrupted.
    int irq = plic_claim();
    80003ee4:	00005097          	auipc	ra,0x5
    80003ee8:	a5e080e7          	jalr	-1442(ra) # 80008942 <plic_claim>
    80003eec:	87aa                	mv	a5,a0
    80003eee:	fef42223          	sw	a5,-28(s0)

    if(irq == UART0_IRQ){
    80003ef2:	fe442783          	lw	a5,-28(s0)
    80003ef6:	0007871b          	sext.w	a4,a5
    80003efa:	47a9                	li	a5,10
    80003efc:	00f71763          	bne	a4,a5,80003f0a <devintr+0x50>
      uartintr();
    80003f00:	ffffd097          	auipc	ra,0xffffd
    80003f04:	086080e7          	jalr	134(ra) # 80000f86 <uartintr>
    80003f08:	a825                	j	80003f40 <devintr+0x86>
    } else if(irq == VIRTIO0_IRQ){
    80003f0a:	fe442783          	lw	a5,-28(s0)
    80003f0e:	0007871b          	sext.w	a4,a5
    80003f12:	4785                	li	a5,1
    80003f14:	00f71763          	bne	a4,a5,80003f22 <devintr+0x68>
      virtio_disk_intr();
    80003f18:	00005097          	auipc	ra,0x5
    80003f1c:	3ec080e7          	jalr	1004(ra) # 80009304 <virtio_disk_intr>
    80003f20:	a005                	j	80003f40 <devintr+0x86>
    } else if(irq){
    80003f22:	fe442783          	lw	a5,-28(s0)
    80003f26:	2781                	sext.w	a5,a5
    80003f28:	cf81                	beqz	a5,80003f40 <devintr+0x86>
      printf("unexpected interrupt irq=%d\n", irq);
    80003f2a:	fe442783          	lw	a5,-28(s0)
    80003f2e:	85be                	mv	a1,a5
    80003f30:	00007517          	auipc	a0,0x7
    80003f34:	49850513          	addi	a0,a0,1176 # 8000b3c8 <etext+0x3c8>
    80003f38:	ffffd097          	auipc	ra,0xffffd
    80003f3c:	afc080e7          	jalr	-1284(ra) # 80000a34 <printf>
    }

    // the PLIC allows each device to raise at most one
    // interrupt at a time; tell the PLIC the device is
    // now allowed to interrupt again.
    if(irq)
    80003f40:	fe442783          	lw	a5,-28(s0)
    80003f44:	2781                	sext.w	a5,a5
    80003f46:	cb81                	beqz	a5,80003f56 <devintr+0x9c>
      plic_complete(irq);
    80003f48:	fe442783          	lw	a5,-28(s0)
    80003f4c:	853e                	mv	a0,a5
    80003f4e:	00005097          	auipc	ra,0x5
    80003f52:	a32080e7          	jalr	-1486(ra) # 80008980 <plic_complete>

    return 1;
    80003f56:	4785                	li	a5,1
    80003f58:	a081                	j	80003f98 <devintr+0xde>
  } else if(scause == 0x8000000000000001L){
    80003f5a:	fe843703          	ld	a4,-24(s0)
    80003f5e:	57fd                	li	a5,-1
    80003f60:	17fe                	slli	a5,a5,0x3f
    80003f62:	0785                	addi	a5,a5,1
    80003f64:	02f71963          	bne	a4,a5,80003f96 <devintr+0xdc>
    // software interrupt from a machine-mode timer interrupt,
    // forwarded by timervec in kernelvec.S.

    if(cpuid() == 0){
    80003f68:	fffff097          	auipc	ra,0xfffff
    80003f6c:	880080e7          	jalr	-1920(ra) # 800027e8 <cpuid>
    80003f70:	87aa                	mv	a5,a0
    80003f72:	e789                	bnez	a5,80003f7c <devintr+0xc2>
      clockintr();
    80003f74:	00000097          	auipc	ra,0x0
    80003f78:	eea080e7          	jalr	-278(ra) # 80003e5e <clockintr>
    }
    
    // acknowledge the software interrupt by clearing
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);
    80003f7c:	00000097          	auipc	ra,0x0
    80003f80:	98e080e7          	jalr	-1650(ra) # 8000390a <r_sip>
    80003f84:	87aa                	mv	a5,a0
    80003f86:	9bf5                	andi	a5,a5,-3
    80003f88:	853e                	mv	a0,a5
    80003f8a:	00000097          	auipc	ra,0x0
    80003f8e:	99a080e7          	jalr	-1638(ra) # 80003924 <w_sip>

    return 2;
    80003f92:	4789                	li	a5,2
    80003f94:	a011                	j	80003f98 <devintr+0xde>
  } else {
    return 0;
    80003f96:	4781                	li	a5,0
  }
}
    80003f98:	853e                	mv	a0,a5
    80003f9a:	60e2                	ld	ra,24(sp)
    80003f9c:	6442                	ld	s0,16(sp)
    80003f9e:	6105                	addi	sp,sp,32
    80003fa0:	8082                	ret

0000000080003fa2 <fetchaddr>:
#include "defs.h"

// Fetch the uint64 at addr from the current process.
int
fetchaddr(uint64 addr, uint64 *ip)
{
    80003fa2:	7179                	addi	sp,sp,-48
    80003fa4:	f406                	sd	ra,40(sp)
    80003fa6:	f022                	sd	s0,32(sp)
    80003fa8:	1800                	addi	s0,sp,48
    80003faa:	fca43c23          	sd	a0,-40(s0)
    80003fae:	fcb43823          	sd	a1,-48(s0)
  struct proc *p = myproc();
    80003fb2:	fffff097          	auipc	ra,0xfffff
    80003fb6:	894080e7          	jalr	-1900(ra) # 80002846 <myproc>
    80003fba:	fea43423          	sd	a0,-24(s0)
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80003fbe:	fe843783          	ld	a5,-24(s0)
    80003fc2:	67bc                	ld	a5,72(a5)
    80003fc4:	fd843703          	ld	a4,-40(s0)
    80003fc8:	00f77b63          	bgeu	a4,a5,80003fde <fetchaddr+0x3c>
    80003fcc:	fd843783          	ld	a5,-40(s0)
    80003fd0:	00878713          	addi	a4,a5,8
    80003fd4:	fe843783          	ld	a5,-24(s0)
    80003fd8:	67bc                	ld	a5,72(a5)
    80003fda:	00e7f463          	bgeu	a5,a4,80003fe2 <fetchaddr+0x40>
    return -1;
    80003fde:	57fd                	li	a5,-1
    80003fe0:	a01d                	j	80004006 <fetchaddr+0x64>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80003fe2:	fe843783          	ld	a5,-24(s0)
    80003fe6:	6bbc                	ld	a5,80(a5)
    80003fe8:	46a1                	li	a3,8
    80003fea:	fd843603          	ld	a2,-40(s0)
    80003fee:	fd043583          	ld	a1,-48(s0)
    80003ff2:	853e                	mv	a0,a5
    80003ff4:	ffffe097          	auipc	ra,0xffffe
    80003ff8:	3ea080e7          	jalr	1002(ra) # 800023de <copyin>
    80003ffc:	87aa                	mv	a5,a0
    80003ffe:	c399                	beqz	a5,80004004 <fetchaddr+0x62>
    return -1;
    80004000:	57fd                	li	a5,-1
    80004002:	a011                	j	80004006 <fetchaddr+0x64>
  return 0;
    80004004:	4781                	li	a5,0
}
    80004006:	853e                	mv	a0,a5
    80004008:	70a2                	ld	ra,40(sp)
    8000400a:	7402                	ld	s0,32(sp)
    8000400c:	6145                	addi	sp,sp,48
    8000400e:	8082                	ret

0000000080004010 <fetchstr>:

// Fetch the nul-terminated string at addr from the current process.
// Returns length of string, not including nul, or -1 for error.
int
fetchstr(uint64 addr, char *buf, int max)
{
    80004010:	7139                	addi	sp,sp,-64
    80004012:	fc06                	sd	ra,56(sp)
    80004014:	f822                	sd	s0,48(sp)
    80004016:	0080                	addi	s0,sp,64
    80004018:	fca43c23          	sd	a0,-40(s0)
    8000401c:	fcb43823          	sd	a1,-48(s0)
    80004020:	87b2                	mv	a5,a2
    80004022:	fcf42623          	sw	a5,-52(s0)
  struct proc *p = myproc();
    80004026:	fffff097          	auipc	ra,0xfffff
    8000402a:	820080e7          	jalr	-2016(ra) # 80002846 <myproc>
    8000402e:	fea43423          	sd	a0,-24(s0)
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80004032:	fe843783          	ld	a5,-24(s0)
    80004036:	6bbc                	ld	a5,80(a5)
    80004038:	fcc42703          	lw	a4,-52(s0)
    8000403c:	86ba                	mv	a3,a4
    8000403e:	fd843603          	ld	a2,-40(s0)
    80004042:	fd043583          	ld	a1,-48(s0)
    80004046:	853e                	mv	a0,a5
    80004048:	ffffe097          	auipc	ra,0xffffe
    8000404c:	464080e7          	jalr	1124(ra) # 800024ac <copyinstr>
    80004050:	87aa                	mv	a5,a0
    80004052:	0007d463          	bgez	a5,8000405a <fetchstr+0x4a>
    return -1;
    80004056:	57fd                	li	a5,-1
    80004058:	a801                	j	80004068 <fetchstr+0x58>
  return strlen(buf);
    8000405a:	fd043503          	ld	a0,-48(s0)
    8000405e:	ffffd097          	auipc	ra,0xffffd
    80004062:	774080e7          	jalr	1908(ra) # 800017d2 <strlen>
    80004066:	87aa                	mv	a5,a0
}
    80004068:	853e                	mv	a0,a5
    8000406a:	70e2                	ld	ra,56(sp)
    8000406c:	7442                	ld	s0,48(sp)
    8000406e:	6121                	addi	sp,sp,64
    80004070:	8082                	ret

0000000080004072 <argraw>:

static uint64
argraw(int n)
{
    80004072:	7179                	addi	sp,sp,-48
    80004074:	f406                	sd	ra,40(sp)
    80004076:	f022                	sd	s0,32(sp)
    80004078:	1800                	addi	s0,sp,48
    8000407a:	87aa                	mv	a5,a0
    8000407c:	fcf42e23          	sw	a5,-36(s0)
  struct proc *p = myproc();
    80004080:	ffffe097          	auipc	ra,0xffffe
    80004084:	7c6080e7          	jalr	1990(ra) # 80002846 <myproc>
    80004088:	fea43423          	sd	a0,-24(s0)
  switch (n) {
    8000408c:	fdc42783          	lw	a5,-36(s0)
    80004090:	0007871b          	sext.w	a4,a5
    80004094:	4795                	li	a5,5
    80004096:	06e7e263          	bltu	a5,a4,800040fa <argraw+0x88>
    8000409a:	fdc46783          	lwu	a5,-36(s0)
    8000409e:	00279713          	slli	a4,a5,0x2
    800040a2:	00007797          	auipc	a5,0x7
    800040a6:	34e78793          	addi	a5,a5,846 # 8000b3f0 <etext+0x3f0>
    800040aa:	97ba                	add	a5,a5,a4
    800040ac:	439c                	lw	a5,0(a5)
    800040ae:	0007871b          	sext.w	a4,a5
    800040b2:	00007797          	auipc	a5,0x7
    800040b6:	33e78793          	addi	a5,a5,830 # 8000b3f0 <etext+0x3f0>
    800040ba:	97ba                	add	a5,a5,a4
    800040bc:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800040be:	fe843783          	ld	a5,-24(s0)
    800040c2:	6fbc                	ld	a5,88(a5)
    800040c4:	7bbc                	ld	a5,112(a5)
    800040c6:	a091                	j	8000410a <argraw+0x98>
  case 1:
    return p->trapframe->a1;
    800040c8:	fe843783          	ld	a5,-24(s0)
    800040cc:	6fbc                	ld	a5,88(a5)
    800040ce:	7fbc                	ld	a5,120(a5)
    800040d0:	a82d                	j	8000410a <argraw+0x98>
  case 2:
    return p->trapframe->a2;
    800040d2:	fe843783          	ld	a5,-24(s0)
    800040d6:	6fbc                	ld	a5,88(a5)
    800040d8:	63dc                	ld	a5,128(a5)
    800040da:	a805                	j	8000410a <argraw+0x98>
  case 3:
    return p->trapframe->a3;
    800040dc:	fe843783          	ld	a5,-24(s0)
    800040e0:	6fbc                	ld	a5,88(a5)
    800040e2:	67dc                	ld	a5,136(a5)
    800040e4:	a01d                	j	8000410a <argraw+0x98>
  case 4:
    return p->trapframe->a4;
    800040e6:	fe843783          	ld	a5,-24(s0)
    800040ea:	6fbc                	ld	a5,88(a5)
    800040ec:	6bdc                	ld	a5,144(a5)
    800040ee:	a831                	j	8000410a <argraw+0x98>
  case 5:
    return p->trapframe->a5;
    800040f0:	fe843783          	ld	a5,-24(s0)
    800040f4:	6fbc                	ld	a5,88(a5)
    800040f6:	6fdc                	ld	a5,152(a5)
    800040f8:	a809                	j	8000410a <argraw+0x98>
  }
  panic("argraw");
    800040fa:	00007517          	auipc	a0,0x7
    800040fe:	2ee50513          	addi	a0,a0,750 # 8000b3e8 <etext+0x3e8>
    80004102:	ffffd097          	auipc	ra,0xffffd
    80004106:	b88080e7          	jalr	-1144(ra) # 80000c8a <panic>
  return -1;
}
    8000410a:	853e                	mv	a0,a5
    8000410c:	70a2                	ld	ra,40(sp)
    8000410e:	7402                	ld	s0,32(sp)
    80004110:	6145                	addi	sp,sp,48
    80004112:	8082                	ret

0000000080004114 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80004114:	1101                	addi	sp,sp,-32
    80004116:	ec06                	sd	ra,24(sp)
    80004118:	e822                	sd	s0,16(sp)
    8000411a:	1000                	addi	s0,sp,32
    8000411c:	87aa                	mv	a5,a0
    8000411e:	feb43023          	sd	a1,-32(s0)
    80004122:	fef42623          	sw	a5,-20(s0)
  *ip = argraw(n);
    80004126:	fec42783          	lw	a5,-20(s0)
    8000412a:	853e                	mv	a0,a5
    8000412c:	00000097          	auipc	ra,0x0
    80004130:	f46080e7          	jalr	-186(ra) # 80004072 <argraw>
    80004134:	87aa                	mv	a5,a0
    80004136:	0007871b          	sext.w	a4,a5
    8000413a:	fe043783          	ld	a5,-32(s0)
    8000413e:	c398                	sw	a4,0(a5)
}
    80004140:	0001                	nop
    80004142:	60e2                	ld	ra,24(sp)
    80004144:	6442                	ld	s0,16(sp)
    80004146:	6105                	addi	sp,sp,32
    80004148:	8082                	ret

000000008000414a <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000414a:	1101                	addi	sp,sp,-32
    8000414c:	ec06                	sd	ra,24(sp)
    8000414e:	e822                	sd	s0,16(sp)
    80004150:	1000                	addi	s0,sp,32
    80004152:	87aa                	mv	a5,a0
    80004154:	feb43023          	sd	a1,-32(s0)
    80004158:	fef42623          	sw	a5,-20(s0)
  *ip = argraw(n);
    8000415c:	fec42783          	lw	a5,-20(s0)
    80004160:	853e                	mv	a0,a5
    80004162:	00000097          	auipc	ra,0x0
    80004166:	f10080e7          	jalr	-240(ra) # 80004072 <argraw>
    8000416a:	872a                	mv	a4,a0
    8000416c:	fe043783          	ld	a5,-32(s0)
    80004170:	e398                	sd	a4,0(a5)
}
    80004172:	0001                	nop
    80004174:	60e2                	ld	ra,24(sp)
    80004176:	6442                	ld	s0,16(sp)
    80004178:	6105                	addi	sp,sp,32
    8000417a:	8082                	ret

000000008000417c <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000417c:	7179                	addi	sp,sp,-48
    8000417e:	f406                	sd	ra,40(sp)
    80004180:	f022                	sd	s0,32(sp)
    80004182:	1800                	addi	s0,sp,48
    80004184:	87aa                	mv	a5,a0
    80004186:	fcb43823          	sd	a1,-48(s0)
    8000418a:	8732                	mv	a4,a2
    8000418c:	fcf42e23          	sw	a5,-36(s0)
    80004190:	87ba                	mv	a5,a4
    80004192:	fcf42c23          	sw	a5,-40(s0)
  uint64 addr;
  argaddr(n, &addr);
    80004196:	fe840713          	addi	a4,s0,-24
    8000419a:	fdc42783          	lw	a5,-36(s0)
    8000419e:	85ba                	mv	a1,a4
    800041a0:	853e                	mv	a0,a5
    800041a2:	00000097          	auipc	ra,0x0
    800041a6:	fa8080e7          	jalr	-88(ra) # 8000414a <argaddr>
  return fetchstr(addr, buf, max);
    800041aa:	fe843783          	ld	a5,-24(s0)
    800041ae:	fd842703          	lw	a4,-40(s0)
    800041b2:	863a                	mv	a2,a4
    800041b4:	fd043583          	ld	a1,-48(s0)
    800041b8:	853e                	mv	a0,a5
    800041ba:	00000097          	auipc	ra,0x0
    800041be:	e56080e7          	jalr	-426(ra) # 80004010 <fetchstr>
    800041c2:	87aa                	mv	a5,a0
}
    800041c4:	853e                	mv	a0,a5
    800041c6:	70a2                	ld	ra,40(sp)
    800041c8:	7402                	ld	s0,32(sp)
    800041ca:	6145                	addi	sp,sp,48
    800041cc:	8082                	ret

00000000800041ce <syscall>:
[SYS_getprocesses]    sys_getprocesses,
};

void
syscall(void)
{
    800041ce:	7179                	addi	sp,sp,-48
    800041d0:	f406                	sd	ra,40(sp)
    800041d2:	f022                	sd	s0,32(sp)
    800041d4:	ec26                	sd	s1,24(sp)
    800041d6:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    800041d8:	ffffe097          	auipc	ra,0xffffe
    800041dc:	66e080e7          	jalr	1646(ra) # 80002846 <myproc>
    800041e0:	fca43c23          	sd	a0,-40(s0)

  num = p->trapframe->a7;
    800041e4:	fd843783          	ld	a5,-40(s0)
    800041e8:	6fbc                	ld	a5,88(a5)
    800041ea:	77dc                	ld	a5,168(a5)
    800041ec:	fcf42a23          	sw	a5,-44(s0)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800041f0:	fd442783          	lw	a5,-44(s0)
    800041f4:	2781                	sext.w	a5,a5
    800041f6:	04f05263          	blez	a5,8000423a <syscall+0x6c>
    800041fa:	fd442783          	lw	a5,-44(s0)
    800041fe:	873e                	mv	a4,a5
    80004200:	47d9                	li	a5,22
    80004202:	02e7ec63          	bltu	a5,a4,8000423a <syscall+0x6c>
    80004206:	0000a717          	auipc	a4,0xa
    8000420a:	b8a70713          	addi	a4,a4,-1142 # 8000dd90 <syscalls>
    8000420e:	fd442783          	lw	a5,-44(s0)
    80004212:	078e                	slli	a5,a5,0x3
    80004214:	97ba                	add	a5,a5,a4
    80004216:	639c                	ld	a5,0(a5)
    80004218:	c38d                	beqz	a5,8000423a <syscall+0x6c>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000421a:	0000a717          	auipc	a4,0xa
    8000421e:	b7670713          	addi	a4,a4,-1162 # 8000dd90 <syscalls>
    80004222:	fd442783          	lw	a5,-44(s0)
    80004226:	078e                	slli	a5,a5,0x3
    80004228:	97ba                	add	a5,a5,a4
    8000422a:	639c                	ld	a5,0(a5)
    8000422c:	fd843703          	ld	a4,-40(s0)
    80004230:	6f24                	ld	s1,88(a4)
    80004232:	9782                	jalr	a5
    80004234:	87aa                	mv	a5,a0
    80004236:	f8bc                	sd	a5,112(s1)
    80004238:	a815                	j	8000426c <syscall+0x9e>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000423a:	fd843783          	ld	a5,-40(s0)
    8000423e:	5b98                	lw	a4,48(a5)
            p->pid, p->name, num);
    80004240:	fd843783          	ld	a5,-40(s0)
    80004244:	15878793          	addi	a5,a5,344
    printf("%d %s: unknown sys call %d\n",
    80004248:	fd442683          	lw	a3,-44(s0)
    8000424c:	863e                	mv	a2,a5
    8000424e:	85ba                	mv	a1,a4
    80004250:	00007517          	auipc	a0,0x7
    80004254:	1b850513          	addi	a0,a0,440 # 8000b408 <etext+0x408>
    80004258:	ffffc097          	auipc	ra,0xffffc
    8000425c:	7dc080e7          	jalr	2012(ra) # 80000a34 <printf>
    p->trapframe->a0 = -1;
    80004260:	fd843783          	ld	a5,-40(s0)
    80004264:	6fbc                	ld	a5,88(a5)
    80004266:	577d                	li	a4,-1
    80004268:	fbb8                	sd	a4,112(a5)
  }
}
    8000426a:	0001                	nop
    8000426c:	0001                	nop
    8000426e:	70a2                	ld	ra,40(sp)
    80004270:	7402                	ld	s0,32(sp)
    80004272:	64e2                	ld	s1,24(sp)
    80004274:	6145                	addi	sp,sp,48
    80004276:	8082                	ret

0000000080004278 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80004278:	1101                	addi	sp,sp,-32
    8000427a:	ec06                	sd	ra,24(sp)
    8000427c:	e822                	sd	s0,16(sp)
    8000427e:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80004280:	fec40793          	addi	a5,s0,-20
    80004284:	85be                	mv	a1,a5
    80004286:	4501                	li	a0,0
    80004288:	00000097          	auipc	ra,0x0
    8000428c:	e8c080e7          	jalr	-372(ra) # 80004114 <argint>
  exit(n);
    80004290:	fec42783          	lw	a5,-20(s0)
    80004294:	853e                	mv	a0,a5
    80004296:	fffff097          	auipc	ra,0xfffff
    8000429a:	ca2080e7          	jalr	-862(ra) # 80002f38 <exit>
  return 0;  // not reached
    8000429e:	4781                	li	a5,0
}
    800042a0:	853e                	mv	a0,a5
    800042a2:	60e2                	ld	ra,24(sp)
    800042a4:	6442                	ld	s0,16(sp)
    800042a6:	6105                	addi	sp,sp,32
    800042a8:	8082                	ret

00000000800042aa <sys_getpid>:

uint64
sys_getpid(void)
{
    800042aa:	1141                	addi	sp,sp,-16
    800042ac:	e406                	sd	ra,8(sp)
    800042ae:	e022                	sd	s0,0(sp)
    800042b0:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800042b2:	ffffe097          	auipc	ra,0xffffe
    800042b6:	594080e7          	jalr	1428(ra) # 80002846 <myproc>
    800042ba:	87aa                	mv	a5,a0
    800042bc:	5b9c                	lw	a5,48(a5)
}
    800042be:	853e                	mv	a0,a5
    800042c0:	60a2                	ld	ra,8(sp)
    800042c2:	6402                	ld	s0,0(sp)
    800042c4:	0141                	addi	sp,sp,16
    800042c6:	8082                	ret

00000000800042c8 <sys_fork>:

uint64
sys_fork(void)
{
    800042c8:	1141                	addi	sp,sp,-16
    800042ca:	e406                	sd	ra,8(sp)
    800042cc:	e022                	sd	s0,0(sp)
    800042ce:	0800                	addi	s0,sp,16
  return fork();
    800042d0:	fffff097          	auipc	ra,0xfffff
    800042d4:	a46080e7          	jalr	-1466(ra) # 80002d16 <fork>
    800042d8:	87aa                	mv	a5,a0
}
    800042da:	853e                	mv	a0,a5
    800042dc:	60a2                	ld	ra,8(sp)
    800042de:	6402                	ld	s0,0(sp)
    800042e0:	0141                	addi	sp,sp,16
    800042e2:	8082                	ret

00000000800042e4 <sys_wait>:

uint64
sys_wait(void)
{
    800042e4:	1101                	addi	sp,sp,-32
    800042e6:	ec06                	sd	ra,24(sp)
    800042e8:	e822                	sd	s0,16(sp)
    800042ea:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800042ec:	fe840793          	addi	a5,s0,-24
    800042f0:	85be                	mv	a1,a5
    800042f2:	4501                	li	a0,0
    800042f4:	00000097          	auipc	ra,0x0
    800042f8:	e56080e7          	jalr	-426(ra) # 8000414a <argaddr>
  return wait(p);
    800042fc:	fe843783          	ld	a5,-24(s0)
    80004300:	853e                	mv	a0,a5
    80004302:	fffff097          	auipc	ra,0xfffff
    80004306:	d72080e7          	jalr	-654(ra) # 80003074 <wait>
    8000430a:	87aa                	mv	a5,a0
}
    8000430c:	853e                	mv	a0,a5
    8000430e:	60e2                	ld	ra,24(sp)
    80004310:	6442                	ld	s0,16(sp)
    80004312:	6105                	addi	sp,sp,32
    80004314:	8082                	ret

0000000080004316 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80004316:	1101                	addi	sp,sp,-32
    80004318:	ec06                	sd	ra,24(sp)
    8000431a:	e822                	sd	s0,16(sp)
    8000431c:	1000                	addi	s0,sp,32
  uint64 addr;
  int n;

  argint(0, &n);
    8000431e:	fe440793          	addi	a5,s0,-28
    80004322:	85be                	mv	a1,a5
    80004324:	4501                	li	a0,0
    80004326:	00000097          	auipc	ra,0x0
    8000432a:	dee080e7          	jalr	-530(ra) # 80004114 <argint>
  addr = myproc()->sz;
    8000432e:	ffffe097          	auipc	ra,0xffffe
    80004332:	518080e7          	jalr	1304(ra) # 80002846 <myproc>
    80004336:	87aa                	mv	a5,a0
    80004338:	67bc                	ld	a5,72(a5)
    8000433a:	fef43423          	sd	a5,-24(s0)
  if(growproc(n) < 0)
    8000433e:	fe442783          	lw	a5,-28(s0)
    80004342:	853e                	mv	a0,a5
    80004344:	fffff097          	auipc	ra,0xfffff
    80004348:	932080e7          	jalr	-1742(ra) # 80002c76 <growproc>
    8000434c:	87aa                	mv	a5,a0
    8000434e:	0007d463          	bgez	a5,80004356 <sys_sbrk+0x40>
    return -1;
    80004352:	57fd                	li	a5,-1
    80004354:	a019                	j	8000435a <sys_sbrk+0x44>
  return addr;
    80004356:	fe843783          	ld	a5,-24(s0)
}
    8000435a:	853e                	mv	a0,a5
    8000435c:	60e2                	ld	ra,24(sp)
    8000435e:	6442                	ld	s0,16(sp)
    80004360:	6105                	addi	sp,sp,32
    80004362:	8082                	ret

0000000080004364 <sys_sleep>:

uint64
sys_sleep(void)
{
    80004364:	1101                	addi	sp,sp,-32
    80004366:	ec06                	sd	ra,24(sp)
    80004368:	e822                	sd	s0,16(sp)
    8000436a:	1000                	addi	s0,sp,32
  int n;
  uint ticks0;

  argint(0, &n);
    8000436c:	fe840793          	addi	a5,s0,-24
    80004370:	85be                	mv	a1,a5
    80004372:	4501                	li	a0,0
    80004374:	00000097          	auipc	ra,0x0
    80004378:	da0080e7          	jalr	-608(ra) # 80004114 <argint>
  acquire(&tickslock);
    8000437c:	00018517          	auipc	a0,0x18
    80004380:	bbc50513          	addi	a0,a0,-1092 # 8001bf38 <tickslock>
    80004384:	ffffd097          	auipc	ra,0xffffd
    80004388:	efa080e7          	jalr	-262(ra) # 8000127e <acquire>
  ticks0 = ticks;
    8000438c:	0000a797          	auipc	a5,0xa
    80004390:	b0c78793          	addi	a5,a5,-1268 # 8000de98 <ticks>
    80004394:	439c                	lw	a5,0(a5)
    80004396:	fef42623          	sw	a5,-20(s0)
  while(ticks - ticks0 < n){
    8000439a:	a099                	j	800043e0 <sys_sleep+0x7c>
    if(killed(myproc())){
    8000439c:	ffffe097          	auipc	ra,0xffffe
    800043a0:	4aa080e7          	jalr	1194(ra) # 80002846 <myproc>
    800043a4:	87aa                	mv	a5,a0
    800043a6:	853e                	mv	a0,a5
    800043a8:	fffff097          	auipc	ra,0xfffff
    800043ac:	24a080e7          	jalr	586(ra) # 800035f2 <killed>
    800043b0:	87aa                	mv	a5,a0
    800043b2:	cb99                	beqz	a5,800043c8 <sys_sleep+0x64>
      release(&tickslock);
    800043b4:	00018517          	auipc	a0,0x18
    800043b8:	b8450513          	addi	a0,a0,-1148 # 8001bf38 <tickslock>
    800043bc:	ffffd097          	auipc	ra,0xffffd
    800043c0:	f26080e7          	jalr	-218(ra) # 800012e2 <release>
      return -1;
    800043c4:	57fd                	li	a5,-1
    800043c6:	a0a9                	j	80004410 <sys_sleep+0xac>
    }
    sleep(&ticks, &tickslock);
    800043c8:	00018597          	auipc	a1,0x18
    800043cc:	b7058593          	addi	a1,a1,-1168 # 8001bf38 <tickslock>
    800043d0:	0000a517          	auipc	a0,0xa
    800043d4:	ac850513          	addi	a0,a0,-1336 # 8000de98 <ticks>
    800043d8:	fffff097          	auipc	ra,0xfffff
    800043dc:	030080e7          	jalr	48(ra) # 80003408 <sleep>
  while(ticks - ticks0 < n){
    800043e0:	0000a797          	auipc	a5,0xa
    800043e4:	ab878793          	addi	a5,a5,-1352 # 8000de98 <ticks>
    800043e8:	439c                	lw	a5,0(a5)
    800043ea:	fec42703          	lw	a4,-20(s0)
    800043ee:	9f99                	subw	a5,a5,a4
    800043f0:	0007871b          	sext.w	a4,a5
    800043f4:	fe842783          	lw	a5,-24(s0)
    800043f8:	2781                	sext.w	a5,a5
    800043fa:	faf761e3          	bltu	a4,a5,8000439c <sys_sleep+0x38>
  }
  release(&tickslock);
    800043fe:	00018517          	auipc	a0,0x18
    80004402:	b3a50513          	addi	a0,a0,-1222 # 8001bf38 <tickslock>
    80004406:	ffffd097          	auipc	ra,0xffffd
    8000440a:	edc080e7          	jalr	-292(ra) # 800012e2 <release>
  return 0;
    8000440e:	4781                	li	a5,0
}
    80004410:	853e                	mv	a0,a5
    80004412:	60e2                	ld	ra,24(sp)
    80004414:	6442                	ld	s0,16(sp)
    80004416:	6105                	addi	sp,sp,32
    80004418:	8082                	ret

000000008000441a <sys_kill>:

uint64
sys_kill(void)
{
    8000441a:	1101                	addi	sp,sp,-32
    8000441c:	ec06                	sd	ra,24(sp)
    8000441e:	e822                	sd	s0,16(sp)
    80004420:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80004422:	fec40793          	addi	a5,s0,-20
    80004426:	85be                	mv	a1,a5
    80004428:	4501                	li	a0,0
    8000442a:	00000097          	auipc	ra,0x0
    8000442e:	cea080e7          	jalr	-790(ra) # 80004114 <argint>
  return kill(pid);
    80004432:	fec42783          	lw	a5,-20(s0)
    80004436:	853e                	mv	a0,a5
    80004438:	fffff097          	auipc	ra,0xfffff
    8000443c:	0e0080e7          	jalr	224(ra) # 80003518 <kill>
    80004440:	87aa                	mv	a5,a0
}
    80004442:	853e                	mv	a0,a5
    80004444:	60e2                	ld	ra,24(sp)
    80004446:	6442                	ld	s0,16(sp)
    80004448:	6105                	addi	sp,sp,32
    8000444a:	8082                	ret

000000008000444c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000444c:	1101                	addi	sp,sp,-32
    8000444e:	ec06                	sd	ra,24(sp)
    80004450:	e822                	sd	s0,16(sp)
    80004452:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80004454:	00018517          	auipc	a0,0x18
    80004458:	ae450513          	addi	a0,a0,-1308 # 8001bf38 <tickslock>
    8000445c:	ffffd097          	auipc	ra,0xffffd
    80004460:	e22080e7          	jalr	-478(ra) # 8000127e <acquire>
  xticks = ticks;
    80004464:	0000a797          	auipc	a5,0xa
    80004468:	a3478793          	addi	a5,a5,-1484 # 8000de98 <ticks>
    8000446c:	439c                	lw	a5,0(a5)
    8000446e:	fef42623          	sw	a5,-20(s0)
  release(&tickslock);
    80004472:	00018517          	auipc	a0,0x18
    80004476:	ac650513          	addi	a0,a0,-1338 # 8001bf38 <tickslock>
    8000447a:	ffffd097          	auipc	ra,0xffffd
    8000447e:	e68080e7          	jalr	-408(ra) # 800012e2 <release>
  return xticks;
    80004482:	fec46783          	lwu	a5,-20(s0)
}
    80004486:	853e                	mv	a0,a5
    80004488:	60e2                	ld	ra,24(sp)
    8000448a:	6442                	ld	s0,16(sp)
    8000448c:	6105                	addi	sp,sp,32
    8000448e:	8082                	ret

0000000080004490 <sys_getprocesses>:


uint64 
sys_getprocesses(void) 
{
    80004490:	1141                	addi	sp,sp,-16
    80004492:	e406                	sd	ra,8(sp)
    80004494:	e022                	sd	s0,0(sp)
    80004496:	0800                	addi	s0,sp,16
  getprocesses();
    80004498:	fffff097          	auipc	ra,0xfffff
    8000449c:	364080e7          	jalr	868(ra) # 800037fc <getprocesses>
  return 0;
    800044a0:	4781                	li	a5,0
    800044a2:	853e                	mv	a0,a5
    800044a4:	60a2                	ld	ra,8(sp)
    800044a6:	6402                	ld	s0,0(sp)
    800044a8:	0141                	addi	sp,sp,16
    800044aa:	8082                	ret

00000000800044ac <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800044ac:	1101                	addi	sp,sp,-32
    800044ae:	ec06                	sd	ra,24(sp)
    800044b0:	e822                	sd	s0,16(sp)
    800044b2:	1000                	addi	s0,sp,32
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800044b4:	00007597          	auipc	a1,0x7
    800044b8:	f7458593          	addi	a1,a1,-140 # 8000b428 <etext+0x428>
    800044bc:	00018517          	auipc	a0,0x18
    800044c0:	a9450513          	addi	a0,a0,-1388 # 8001bf50 <bcache>
    800044c4:	ffffd097          	auipc	ra,0xffffd
    800044c8:	d8a080e7          	jalr	-630(ra) # 8000124e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800044cc:	00018717          	auipc	a4,0x18
    800044d0:	a8470713          	addi	a4,a4,-1404 # 8001bf50 <bcache>
    800044d4:	67a1                	lui	a5,0x8
    800044d6:	97ba                	add	a5,a5,a4
    800044d8:	00020717          	auipc	a4,0x20
    800044dc:	ce070713          	addi	a4,a4,-800 # 800241b8 <bcache+0x8268>
    800044e0:	2ae7b823          	sd	a4,688(a5) # 82b0 <_entry-0x7fff7d50>
  bcache.head.next = &bcache.head;
    800044e4:	00018717          	auipc	a4,0x18
    800044e8:	a6c70713          	addi	a4,a4,-1428 # 8001bf50 <bcache>
    800044ec:	67a1                	lui	a5,0x8
    800044ee:	97ba                	add	a5,a5,a4
    800044f0:	00020717          	auipc	a4,0x20
    800044f4:	cc870713          	addi	a4,a4,-824 # 800241b8 <bcache+0x8268>
    800044f8:	2ae7bc23          	sd	a4,696(a5) # 82b8 <_entry-0x7fff7d48>
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800044fc:	00018797          	auipc	a5,0x18
    80004500:	a6c78793          	addi	a5,a5,-1428 # 8001bf68 <bcache+0x18>
    80004504:	fef43423          	sd	a5,-24(s0)
    80004508:	a895                	j	8000457c <binit+0xd0>
    b->next = bcache.head.next;
    8000450a:	00018717          	auipc	a4,0x18
    8000450e:	a4670713          	addi	a4,a4,-1466 # 8001bf50 <bcache>
    80004512:	67a1                	lui	a5,0x8
    80004514:	97ba                	add	a5,a5,a4
    80004516:	2b87b703          	ld	a4,696(a5) # 82b8 <_entry-0x7fff7d48>
    8000451a:	fe843783          	ld	a5,-24(s0)
    8000451e:	ebb8                	sd	a4,80(a5)
    b->prev = &bcache.head;
    80004520:	fe843783          	ld	a5,-24(s0)
    80004524:	00020717          	auipc	a4,0x20
    80004528:	c9470713          	addi	a4,a4,-876 # 800241b8 <bcache+0x8268>
    8000452c:	e7b8                	sd	a4,72(a5)
    initsleeplock(&b->lock, "buffer");
    8000452e:	fe843783          	ld	a5,-24(s0)
    80004532:	07c1                	addi	a5,a5,16
    80004534:	00007597          	auipc	a1,0x7
    80004538:	efc58593          	addi	a1,a1,-260 # 8000b430 <etext+0x430>
    8000453c:	853e                	mv	a0,a5
    8000453e:	00002097          	auipc	ra,0x2
    80004542:	01e080e7          	jalr	30(ra) # 8000655c <initsleeplock>
    bcache.head.next->prev = b;
    80004546:	00018717          	auipc	a4,0x18
    8000454a:	a0a70713          	addi	a4,a4,-1526 # 8001bf50 <bcache>
    8000454e:	67a1                	lui	a5,0x8
    80004550:	97ba                	add	a5,a5,a4
    80004552:	2b87b783          	ld	a5,696(a5) # 82b8 <_entry-0x7fff7d48>
    80004556:	fe843703          	ld	a4,-24(s0)
    8000455a:	e7b8                	sd	a4,72(a5)
    bcache.head.next = b;
    8000455c:	00018717          	auipc	a4,0x18
    80004560:	9f470713          	addi	a4,a4,-1548 # 8001bf50 <bcache>
    80004564:	67a1                	lui	a5,0x8
    80004566:	97ba                	add	a5,a5,a4
    80004568:	fe843703          	ld	a4,-24(s0)
    8000456c:	2ae7bc23          	sd	a4,696(a5) # 82b8 <_entry-0x7fff7d48>
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80004570:	fe843783          	ld	a5,-24(s0)
    80004574:	45878793          	addi	a5,a5,1112
    80004578:	fef43423          	sd	a5,-24(s0)
    8000457c:	00020797          	auipc	a5,0x20
    80004580:	c3c78793          	addi	a5,a5,-964 # 800241b8 <bcache+0x8268>
    80004584:	fe843703          	ld	a4,-24(s0)
    80004588:	f8f761e3          	bltu	a4,a5,8000450a <binit+0x5e>
  }
}
    8000458c:	0001                	nop
    8000458e:	0001                	nop
    80004590:	60e2                	ld	ra,24(sp)
    80004592:	6442                	ld	s0,16(sp)
    80004594:	6105                	addi	sp,sp,32
    80004596:	8082                	ret

0000000080004598 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
    80004598:	7179                	addi	sp,sp,-48
    8000459a:	f406                	sd	ra,40(sp)
    8000459c:	f022                	sd	s0,32(sp)
    8000459e:	1800                	addi	s0,sp,48
    800045a0:	87aa                	mv	a5,a0
    800045a2:	872e                	mv	a4,a1
    800045a4:	fcf42e23          	sw	a5,-36(s0)
    800045a8:	87ba                	mv	a5,a4
    800045aa:	fcf42c23          	sw	a5,-40(s0)
  struct buf *b;

  acquire(&bcache.lock);
    800045ae:	00018517          	auipc	a0,0x18
    800045b2:	9a250513          	addi	a0,a0,-1630 # 8001bf50 <bcache>
    800045b6:	ffffd097          	auipc	ra,0xffffd
    800045ba:	cc8080e7          	jalr	-824(ra) # 8000127e <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800045be:	00018717          	auipc	a4,0x18
    800045c2:	99270713          	addi	a4,a4,-1646 # 8001bf50 <bcache>
    800045c6:	67a1                	lui	a5,0x8
    800045c8:	97ba                	add	a5,a5,a4
    800045ca:	2b87b783          	ld	a5,696(a5) # 82b8 <_entry-0x7fff7d48>
    800045ce:	fef43423          	sd	a5,-24(s0)
    800045d2:	a095                	j	80004636 <bget+0x9e>
    if(b->dev == dev && b->blockno == blockno){
    800045d4:	fe843783          	ld	a5,-24(s0)
    800045d8:	4798                	lw	a4,8(a5)
    800045da:	fdc42783          	lw	a5,-36(s0)
    800045de:	2781                	sext.w	a5,a5
    800045e0:	04e79663          	bne	a5,a4,8000462c <bget+0x94>
    800045e4:	fe843783          	ld	a5,-24(s0)
    800045e8:	47d8                	lw	a4,12(a5)
    800045ea:	fd842783          	lw	a5,-40(s0)
    800045ee:	2781                	sext.w	a5,a5
    800045f0:	02e79e63          	bne	a5,a4,8000462c <bget+0x94>
      b->refcnt++;
    800045f4:	fe843783          	ld	a5,-24(s0)
    800045f8:	43bc                	lw	a5,64(a5)
    800045fa:	2785                	addiw	a5,a5,1
    800045fc:	0007871b          	sext.w	a4,a5
    80004600:	fe843783          	ld	a5,-24(s0)
    80004604:	c3b8                	sw	a4,64(a5)
      release(&bcache.lock);
    80004606:	00018517          	auipc	a0,0x18
    8000460a:	94a50513          	addi	a0,a0,-1718 # 8001bf50 <bcache>
    8000460e:	ffffd097          	auipc	ra,0xffffd
    80004612:	cd4080e7          	jalr	-812(ra) # 800012e2 <release>
      acquiresleep(&b->lock);
    80004616:	fe843783          	ld	a5,-24(s0)
    8000461a:	07c1                	addi	a5,a5,16
    8000461c:	853e                	mv	a0,a5
    8000461e:	00002097          	auipc	ra,0x2
    80004622:	f8a080e7          	jalr	-118(ra) # 800065a8 <acquiresleep>
      return b;
    80004626:	fe843783          	ld	a5,-24(s0)
    8000462a:	a07d                	j	800046d8 <bget+0x140>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000462c:	fe843783          	ld	a5,-24(s0)
    80004630:	6bbc                	ld	a5,80(a5)
    80004632:	fef43423          	sd	a5,-24(s0)
    80004636:	fe843703          	ld	a4,-24(s0)
    8000463a:	00020797          	auipc	a5,0x20
    8000463e:	b7e78793          	addi	a5,a5,-1154 # 800241b8 <bcache+0x8268>
    80004642:	f8f719e3          	bne	a4,a5,800045d4 <bget+0x3c>
    }
  }

  // Not cached.
  // Recycle the least recently used (LRU) unused buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80004646:	00018717          	auipc	a4,0x18
    8000464a:	90a70713          	addi	a4,a4,-1782 # 8001bf50 <bcache>
    8000464e:	67a1                	lui	a5,0x8
    80004650:	97ba                	add	a5,a5,a4
    80004652:	2b07b783          	ld	a5,688(a5) # 82b0 <_entry-0x7fff7d50>
    80004656:	fef43423          	sd	a5,-24(s0)
    8000465a:	a8b9                	j	800046b8 <bget+0x120>
    if(b->refcnt == 0) {
    8000465c:	fe843783          	ld	a5,-24(s0)
    80004660:	43bc                	lw	a5,64(a5)
    80004662:	e7b1                	bnez	a5,800046ae <bget+0x116>
      b->dev = dev;
    80004664:	fe843783          	ld	a5,-24(s0)
    80004668:	fdc42703          	lw	a4,-36(s0)
    8000466c:	c798                	sw	a4,8(a5)
      b->blockno = blockno;
    8000466e:	fe843783          	ld	a5,-24(s0)
    80004672:	fd842703          	lw	a4,-40(s0)
    80004676:	c7d8                	sw	a4,12(a5)
      b->valid = 0;
    80004678:	fe843783          	ld	a5,-24(s0)
    8000467c:	0007a023          	sw	zero,0(a5)
      b->refcnt = 1;
    80004680:	fe843783          	ld	a5,-24(s0)
    80004684:	4705                	li	a4,1
    80004686:	c3b8                	sw	a4,64(a5)
      release(&bcache.lock);
    80004688:	00018517          	auipc	a0,0x18
    8000468c:	8c850513          	addi	a0,a0,-1848 # 8001bf50 <bcache>
    80004690:	ffffd097          	auipc	ra,0xffffd
    80004694:	c52080e7          	jalr	-942(ra) # 800012e2 <release>
      acquiresleep(&b->lock);
    80004698:	fe843783          	ld	a5,-24(s0)
    8000469c:	07c1                	addi	a5,a5,16
    8000469e:	853e                	mv	a0,a5
    800046a0:	00002097          	auipc	ra,0x2
    800046a4:	f08080e7          	jalr	-248(ra) # 800065a8 <acquiresleep>
      return b;
    800046a8:	fe843783          	ld	a5,-24(s0)
    800046ac:	a035                	j	800046d8 <bget+0x140>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800046ae:	fe843783          	ld	a5,-24(s0)
    800046b2:	67bc                	ld	a5,72(a5)
    800046b4:	fef43423          	sd	a5,-24(s0)
    800046b8:	fe843703          	ld	a4,-24(s0)
    800046bc:	00020797          	auipc	a5,0x20
    800046c0:	afc78793          	addi	a5,a5,-1284 # 800241b8 <bcache+0x8268>
    800046c4:	f8f71ce3          	bne	a4,a5,8000465c <bget+0xc4>
    }
  }
  panic("bget: no buffers");
    800046c8:	00007517          	auipc	a0,0x7
    800046cc:	d7050513          	addi	a0,a0,-656 # 8000b438 <etext+0x438>
    800046d0:	ffffc097          	auipc	ra,0xffffc
    800046d4:	5ba080e7          	jalr	1466(ra) # 80000c8a <panic>
}
    800046d8:	853e                	mv	a0,a5
    800046da:	70a2                	ld	ra,40(sp)
    800046dc:	7402                	ld	s0,32(sp)
    800046de:	6145                	addi	sp,sp,48
    800046e0:	8082                	ret

00000000800046e2 <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800046e2:	7179                	addi	sp,sp,-48
    800046e4:	f406                	sd	ra,40(sp)
    800046e6:	f022                	sd	s0,32(sp)
    800046e8:	1800                	addi	s0,sp,48
    800046ea:	87aa                	mv	a5,a0
    800046ec:	872e                	mv	a4,a1
    800046ee:	fcf42e23          	sw	a5,-36(s0)
    800046f2:	87ba                	mv	a5,a4
    800046f4:	fcf42c23          	sw	a5,-40(s0)
  struct buf *b;

  b = bget(dev, blockno);
    800046f8:	fd842703          	lw	a4,-40(s0)
    800046fc:	fdc42783          	lw	a5,-36(s0)
    80004700:	85ba                	mv	a1,a4
    80004702:	853e                	mv	a0,a5
    80004704:	00000097          	auipc	ra,0x0
    80004708:	e94080e7          	jalr	-364(ra) # 80004598 <bget>
    8000470c:	fea43423          	sd	a0,-24(s0)
  if(!b->valid) {
    80004710:	fe843783          	ld	a5,-24(s0)
    80004714:	439c                	lw	a5,0(a5)
    80004716:	ef81                	bnez	a5,8000472e <bread+0x4c>
    virtio_disk_rw(b, 0);
    80004718:	4581                	li	a1,0
    8000471a:	fe843503          	ld	a0,-24(s0)
    8000471e:	00005097          	auipc	ra,0x5
    80004722:	8a4080e7          	jalr	-1884(ra) # 80008fc2 <virtio_disk_rw>
    b->valid = 1;
    80004726:	fe843783          	ld	a5,-24(s0)
    8000472a:	4705                	li	a4,1
    8000472c:	c398                	sw	a4,0(a5)
  }
  return b;
    8000472e:	fe843783          	ld	a5,-24(s0)
}
    80004732:	853e                	mv	a0,a5
    80004734:	70a2                	ld	ra,40(sp)
    80004736:	7402                	ld	s0,32(sp)
    80004738:	6145                	addi	sp,sp,48
    8000473a:	8082                	ret

000000008000473c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000473c:	1101                	addi	sp,sp,-32
    8000473e:	ec06                	sd	ra,24(sp)
    80004740:	e822                	sd	s0,16(sp)
    80004742:	1000                	addi	s0,sp,32
    80004744:	fea43423          	sd	a0,-24(s0)
  if(!holdingsleep(&b->lock))
    80004748:	fe843783          	ld	a5,-24(s0)
    8000474c:	07c1                	addi	a5,a5,16
    8000474e:	853e                	mv	a0,a5
    80004750:	00002097          	auipc	ra,0x2
    80004754:	f18080e7          	jalr	-232(ra) # 80006668 <holdingsleep>
    80004758:	87aa                	mv	a5,a0
    8000475a:	eb89                	bnez	a5,8000476c <bwrite+0x30>
    panic("bwrite");
    8000475c:	00007517          	auipc	a0,0x7
    80004760:	cf450513          	addi	a0,a0,-780 # 8000b450 <etext+0x450>
    80004764:	ffffc097          	auipc	ra,0xffffc
    80004768:	526080e7          	jalr	1318(ra) # 80000c8a <panic>
  virtio_disk_rw(b, 1);
    8000476c:	4585                	li	a1,1
    8000476e:	fe843503          	ld	a0,-24(s0)
    80004772:	00005097          	auipc	ra,0x5
    80004776:	850080e7          	jalr	-1968(ra) # 80008fc2 <virtio_disk_rw>
}
    8000477a:	0001                	nop
    8000477c:	60e2                	ld	ra,24(sp)
    8000477e:	6442                	ld	s0,16(sp)
    80004780:	6105                	addi	sp,sp,32
    80004782:	8082                	ret

0000000080004784 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80004784:	1101                	addi	sp,sp,-32
    80004786:	ec06                	sd	ra,24(sp)
    80004788:	e822                	sd	s0,16(sp)
    8000478a:	1000                	addi	s0,sp,32
    8000478c:	fea43423          	sd	a0,-24(s0)
  if(!holdingsleep(&b->lock))
    80004790:	fe843783          	ld	a5,-24(s0)
    80004794:	07c1                	addi	a5,a5,16
    80004796:	853e                	mv	a0,a5
    80004798:	00002097          	auipc	ra,0x2
    8000479c:	ed0080e7          	jalr	-304(ra) # 80006668 <holdingsleep>
    800047a0:	87aa                	mv	a5,a0
    800047a2:	eb89                	bnez	a5,800047b4 <brelse+0x30>
    panic("brelse");
    800047a4:	00007517          	auipc	a0,0x7
    800047a8:	cb450513          	addi	a0,a0,-844 # 8000b458 <etext+0x458>
    800047ac:	ffffc097          	auipc	ra,0xffffc
    800047b0:	4de080e7          	jalr	1246(ra) # 80000c8a <panic>

  releasesleep(&b->lock);
    800047b4:	fe843783          	ld	a5,-24(s0)
    800047b8:	07c1                	addi	a5,a5,16
    800047ba:	853e                	mv	a0,a5
    800047bc:	00002097          	auipc	ra,0x2
    800047c0:	e5a080e7          	jalr	-422(ra) # 80006616 <releasesleep>

  acquire(&bcache.lock);
    800047c4:	00017517          	auipc	a0,0x17
    800047c8:	78c50513          	addi	a0,a0,1932 # 8001bf50 <bcache>
    800047cc:	ffffd097          	auipc	ra,0xffffd
    800047d0:	ab2080e7          	jalr	-1358(ra) # 8000127e <acquire>
  b->refcnt--;
    800047d4:	fe843783          	ld	a5,-24(s0)
    800047d8:	43bc                	lw	a5,64(a5)
    800047da:	37fd                	addiw	a5,a5,-1
    800047dc:	0007871b          	sext.w	a4,a5
    800047e0:	fe843783          	ld	a5,-24(s0)
    800047e4:	c3b8                	sw	a4,64(a5)
  if (b->refcnt == 0) {
    800047e6:	fe843783          	ld	a5,-24(s0)
    800047ea:	43bc                	lw	a5,64(a5)
    800047ec:	e7b5                	bnez	a5,80004858 <brelse+0xd4>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800047ee:	fe843783          	ld	a5,-24(s0)
    800047f2:	6bbc                	ld	a5,80(a5)
    800047f4:	fe843703          	ld	a4,-24(s0)
    800047f8:	6738                	ld	a4,72(a4)
    800047fa:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800047fc:	fe843783          	ld	a5,-24(s0)
    80004800:	67bc                	ld	a5,72(a5)
    80004802:	fe843703          	ld	a4,-24(s0)
    80004806:	6b38                	ld	a4,80(a4)
    80004808:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000480a:	00017717          	auipc	a4,0x17
    8000480e:	74670713          	addi	a4,a4,1862 # 8001bf50 <bcache>
    80004812:	67a1                	lui	a5,0x8
    80004814:	97ba                	add	a5,a5,a4
    80004816:	2b87b703          	ld	a4,696(a5) # 82b8 <_entry-0x7fff7d48>
    8000481a:	fe843783          	ld	a5,-24(s0)
    8000481e:	ebb8                	sd	a4,80(a5)
    b->prev = &bcache.head;
    80004820:	fe843783          	ld	a5,-24(s0)
    80004824:	00020717          	auipc	a4,0x20
    80004828:	99470713          	addi	a4,a4,-1644 # 800241b8 <bcache+0x8268>
    8000482c:	e7b8                	sd	a4,72(a5)
    bcache.head.next->prev = b;
    8000482e:	00017717          	auipc	a4,0x17
    80004832:	72270713          	addi	a4,a4,1826 # 8001bf50 <bcache>
    80004836:	67a1                	lui	a5,0x8
    80004838:	97ba                	add	a5,a5,a4
    8000483a:	2b87b783          	ld	a5,696(a5) # 82b8 <_entry-0x7fff7d48>
    8000483e:	fe843703          	ld	a4,-24(s0)
    80004842:	e7b8                	sd	a4,72(a5)
    bcache.head.next = b;
    80004844:	00017717          	auipc	a4,0x17
    80004848:	70c70713          	addi	a4,a4,1804 # 8001bf50 <bcache>
    8000484c:	67a1                	lui	a5,0x8
    8000484e:	97ba                	add	a5,a5,a4
    80004850:	fe843703          	ld	a4,-24(s0)
    80004854:	2ae7bc23          	sd	a4,696(a5) # 82b8 <_entry-0x7fff7d48>
  }
  
  release(&bcache.lock);
    80004858:	00017517          	auipc	a0,0x17
    8000485c:	6f850513          	addi	a0,a0,1784 # 8001bf50 <bcache>
    80004860:	ffffd097          	auipc	ra,0xffffd
    80004864:	a82080e7          	jalr	-1406(ra) # 800012e2 <release>
}
    80004868:	0001                	nop
    8000486a:	60e2                	ld	ra,24(sp)
    8000486c:	6442                	ld	s0,16(sp)
    8000486e:	6105                	addi	sp,sp,32
    80004870:	8082                	ret

0000000080004872 <bpin>:

void
bpin(struct buf *b) {
    80004872:	1101                	addi	sp,sp,-32
    80004874:	ec06                	sd	ra,24(sp)
    80004876:	e822                	sd	s0,16(sp)
    80004878:	1000                	addi	s0,sp,32
    8000487a:	fea43423          	sd	a0,-24(s0)
  acquire(&bcache.lock);
    8000487e:	00017517          	auipc	a0,0x17
    80004882:	6d250513          	addi	a0,a0,1746 # 8001bf50 <bcache>
    80004886:	ffffd097          	auipc	ra,0xffffd
    8000488a:	9f8080e7          	jalr	-1544(ra) # 8000127e <acquire>
  b->refcnt++;
    8000488e:	fe843783          	ld	a5,-24(s0)
    80004892:	43bc                	lw	a5,64(a5)
    80004894:	2785                	addiw	a5,a5,1
    80004896:	0007871b          	sext.w	a4,a5
    8000489a:	fe843783          	ld	a5,-24(s0)
    8000489e:	c3b8                	sw	a4,64(a5)
  release(&bcache.lock);
    800048a0:	00017517          	auipc	a0,0x17
    800048a4:	6b050513          	addi	a0,a0,1712 # 8001bf50 <bcache>
    800048a8:	ffffd097          	auipc	ra,0xffffd
    800048ac:	a3a080e7          	jalr	-1478(ra) # 800012e2 <release>
}
    800048b0:	0001                	nop
    800048b2:	60e2                	ld	ra,24(sp)
    800048b4:	6442                	ld	s0,16(sp)
    800048b6:	6105                	addi	sp,sp,32
    800048b8:	8082                	ret

00000000800048ba <bunpin>:

void
bunpin(struct buf *b) {
    800048ba:	1101                	addi	sp,sp,-32
    800048bc:	ec06                	sd	ra,24(sp)
    800048be:	e822                	sd	s0,16(sp)
    800048c0:	1000                	addi	s0,sp,32
    800048c2:	fea43423          	sd	a0,-24(s0)
  acquire(&bcache.lock);
    800048c6:	00017517          	auipc	a0,0x17
    800048ca:	68a50513          	addi	a0,a0,1674 # 8001bf50 <bcache>
    800048ce:	ffffd097          	auipc	ra,0xffffd
    800048d2:	9b0080e7          	jalr	-1616(ra) # 8000127e <acquire>
  b->refcnt--;
    800048d6:	fe843783          	ld	a5,-24(s0)
    800048da:	43bc                	lw	a5,64(a5)
    800048dc:	37fd                	addiw	a5,a5,-1
    800048de:	0007871b          	sext.w	a4,a5
    800048e2:	fe843783          	ld	a5,-24(s0)
    800048e6:	c3b8                	sw	a4,64(a5)
  release(&bcache.lock);
    800048e8:	00017517          	auipc	a0,0x17
    800048ec:	66850513          	addi	a0,a0,1640 # 8001bf50 <bcache>
    800048f0:	ffffd097          	auipc	ra,0xffffd
    800048f4:	9f2080e7          	jalr	-1550(ra) # 800012e2 <release>
}
    800048f8:	0001                	nop
    800048fa:	60e2                	ld	ra,24(sp)
    800048fc:	6442                	ld	s0,16(sp)
    800048fe:	6105                	addi	sp,sp,32
    80004900:	8082                	ret

0000000080004902 <readsb>:
struct superblock sb; 

// Read the super block.
static void
readsb(int dev, struct superblock *sb)
{
    80004902:	7179                	addi	sp,sp,-48
    80004904:	f406                	sd	ra,40(sp)
    80004906:	f022                	sd	s0,32(sp)
    80004908:	1800                	addi	s0,sp,48
    8000490a:	87aa                	mv	a5,a0
    8000490c:	fcb43823          	sd	a1,-48(s0)
    80004910:	fcf42e23          	sw	a5,-36(s0)
  struct buf *bp;

  bp = bread(dev, 1);
    80004914:	fdc42783          	lw	a5,-36(s0)
    80004918:	4585                	li	a1,1
    8000491a:	853e                	mv	a0,a5
    8000491c:	00000097          	auipc	ra,0x0
    80004920:	dc6080e7          	jalr	-570(ra) # 800046e2 <bread>
    80004924:	fea43423          	sd	a0,-24(s0)
  memmove(sb, bp->data, sizeof(*sb));
    80004928:	fe843783          	ld	a5,-24(s0)
    8000492c:	05878793          	addi	a5,a5,88
    80004930:	02000613          	li	a2,32
    80004934:	85be                	mv	a1,a5
    80004936:	fd043503          	ld	a0,-48(s0)
    8000493a:	ffffd097          	auipc	ra,0xffffd
    8000493e:	bfc080e7          	jalr	-1028(ra) # 80001536 <memmove>
  brelse(bp);
    80004942:	fe843503          	ld	a0,-24(s0)
    80004946:	00000097          	auipc	ra,0x0
    8000494a:	e3e080e7          	jalr	-450(ra) # 80004784 <brelse>
}
    8000494e:	0001                	nop
    80004950:	70a2                	ld	ra,40(sp)
    80004952:	7402                	ld	s0,32(sp)
    80004954:	6145                	addi	sp,sp,48
    80004956:	8082                	ret

0000000080004958 <fsinit>:

// Init fs
void
fsinit(int dev) {
    80004958:	1101                	addi	sp,sp,-32
    8000495a:	ec06                	sd	ra,24(sp)
    8000495c:	e822                	sd	s0,16(sp)
    8000495e:	1000                	addi	s0,sp,32
    80004960:	87aa                	mv	a5,a0
    80004962:	fef42623          	sw	a5,-20(s0)
  readsb(dev, &sb);
    80004966:	fec42783          	lw	a5,-20(s0)
    8000496a:	00020597          	auipc	a1,0x20
    8000496e:	ca658593          	addi	a1,a1,-858 # 80024610 <sb>
    80004972:	853e                	mv	a0,a5
    80004974:	00000097          	auipc	ra,0x0
    80004978:	f8e080e7          	jalr	-114(ra) # 80004902 <readsb>
  if(sb.magic != FSMAGIC)
    8000497c:	00020797          	auipc	a5,0x20
    80004980:	c9478793          	addi	a5,a5,-876 # 80024610 <sb>
    80004984:	439c                	lw	a5,0(a5)
    80004986:	873e                	mv	a4,a5
    80004988:	102037b7          	lui	a5,0x10203
    8000498c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80004990:	00f70a63          	beq	a4,a5,800049a4 <fsinit+0x4c>
    panic("invalid file system");
    80004994:	00007517          	auipc	a0,0x7
    80004998:	acc50513          	addi	a0,a0,-1332 # 8000b460 <etext+0x460>
    8000499c:	ffffc097          	auipc	ra,0xffffc
    800049a0:	2ee080e7          	jalr	750(ra) # 80000c8a <panic>
  initlog(dev, &sb);
    800049a4:	fec42783          	lw	a5,-20(s0)
    800049a8:	00020597          	auipc	a1,0x20
    800049ac:	c6858593          	addi	a1,a1,-920 # 80024610 <sb>
    800049b0:	853e                	mv	a0,a5
    800049b2:	00001097          	auipc	ra,0x1
    800049b6:	48e080e7          	jalr	1166(ra) # 80005e40 <initlog>
}
    800049ba:	0001                	nop
    800049bc:	60e2                	ld	ra,24(sp)
    800049be:	6442                	ld	s0,16(sp)
    800049c0:	6105                	addi	sp,sp,32
    800049c2:	8082                	ret

00000000800049c4 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
    800049c4:	7179                	addi	sp,sp,-48
    800049c6:	f406                	sd	ra,40(sp)
    800049c8:	f022                	sd	s0,32(sp)
    800049ca:	1800                	addi	s0,sp,48
    800049cc:	87aa                	mv	a5,a0
    800049ce:	872e                	mv	a4,a1
    800049d0:	fcf42e23          	sw	a5,-36(s0)
    800049d4:	87ba                	mv	a5,a4
    800049d6:	fcf42c23          	sw	a5,-40(s0)
  struct buf *bp;

  bp = bread(dev, bno);
    800049da:	fdc42783          	lw	a5,-36(s0)
    800049de:	fd842703          	lw	a4,-40(s0)
    800049e2:	85ba                	mv	a1,a4
    800049e4:	853e                	mv	a0,a5
    800049e6:	00000097          	auipc	ra,0x0
    800049ea:	cfc080e7          	jalr	-772(ra) # 800046e2 <bread>
    800049ee:	fea43423          	sd	a0,-24(s0)
  memset(bp->data, 0, BSIZE);
    800049f2:	fe843783          	ld	a5,-24(s0)
    800049f6:	05878793          	addi	a5,a5,88
    800049fa:	40000613          	li	a2,1024
    800049fe:	4581                	li	a1,0
    80004a00:	853e                	mv	a0,a5
    80004a02:	ffffd097          	auipc	ra,0xffffd
    80004a06:	a50080e7          	jalr	-1456(ra) # 80001452 <memset>
  log_write(bp);
    80004a0a:	fe843503          	ld	a0,-24(s0)
    80004a0e:	00002097          	auipc	ra,0x2
    80004a12:	a1a080e7          	jalr	-1510(ra) # 80006428 <log_write>
  brelse(bp);
    80004a16:	fe843503          	ld	a0,-24(s0)
    80004a1a:	00000097          	auipc	ra,0x0
    80004a1e:	d6a080e7          	jalr	-662(ra) # 80004784 <brelse>
}
    80004a22:	0001                	nop
    80004a24:	70a2                	ld	ra,40(sp)
    80004a26:	7402                	ld	s0,32(sp)
    80004a28:	6145                	addi	sp,sp,48
    80004a2a:	8082                	ret

0000000080004a2c <balloc>:

// Allocate a zeroed disk block.
// returns 0 if out of disk space.
static uint
balloc(uint dev)
{
    80004a2c:	7139                	addi	sp,sp,-64
    80004a2e:	fc06                	sd	ra,56(sp)
    80004a30:	f822                	sd	s0,48(sp)
    80004a32:	0080                	addi	s0,sp,64
    80004a34:	87aa                	mv	a5,a0
    80004a36:	fcf42623          	sw	a5,-52(s0)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
    80004a3a:	fe043023          	sd	zero,-32(s0)
  for(b = 0; b < sb.size; b += BPB){
    80004a3e:	fe042623          	sw	zero,-20(s0)
    80004a42:	a295                	j	80004ba6 <balloc+0x17a>
    bp = bread(dev, BBLOCK(b, sb));
    80004a44:	fec42783          	lw	a5,-20(s0)
    80004a48:	41f7d71b          	sraiw	a4,a5,0x1f
    80004a4c:	0137571b          	srliw	a4,a4,0x13
    80004a50:	9fb9                	addw	a5,a5,a4
    80004a52:	40d7d79b          	sraiw	a5,a5,0xd
    80004a56:	2781                	sext.w	a5,a5
    80004a58:	0007871b          	sext.w	a4,a5
    80004a5c:	00020797          	auipc	a5,0x20
    80004a60:	bb478793          	addi	a5,a5,-1100 # 80024610 <sb>
    80004a64:	4fdc                	lw	a5,28(a5)
    80004a66:	9fb9                	addw	a5,a5,a4
    80004a68:	0007871b          	sext.w	a4,a5
    80004a6c:	fcc42783          	lw	a5,-52(s0)
    80004a70:	85ba                	mv	a1,a4
    80004a72:	853e                	mv	a0,a5
    80004a74:	00000097          	auipc	ra,0x0
    80004a78:	c6e080e7          	jalr	-914(ra) # 800046e2 <bread>
    80004a7c:	fea43023          	sd	a0,-32(s0)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80004a80:	fe042423          	sw	zero,-24(s0)
    80004a84:	a8e9                	j	80004b5e <balloc+0x132>
      m = 1 << (bi % 8);
    80004a86:	fe842783          	lw	a5,-24(s0)
    80004a8a:	8b9d                	andi	a5,a5,7
    80004a8c:	2781                	sext.w	a5,a5
    80004a8e:	4705                	li	a4,1
    80004a90:	00f717bb          	sllw	a5,a4,a5
    80004a94:	fcf42e23          	sw	a5,-36(s0)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80004a98:	fe842783          	lw	a5,-24(s0)
    80004a9c:	41f7d71b          	sraiw	a4,a5,0x1f
    80004aa0:	01d7571b          	srliw	a4,a4,0x1d
    80004aa4:	9fb9                	addw	a5,a5,a4
    80004aa6:	4037d79b          	sraiw	a5,a5,0x3
    80004aaa:	2781                	sext.w	a5,a5
    80004aac:	fe043703          	ld	a4,-32(s0)
    80004ab0:	97ba                	add	a5,a5,a4
    80004ab2:	0587c783          	lbu	a5,88(a5)
    80004ab6:	2781                	sext.w	a5,a5
    80004ab8:	fdc42703          	lw	a4,-36(s0)
    80004abc:	8ff9                	and	a5,a5,a4
    80004abe:	2781                	sext.w	a5,a5
    80004ac0:	ebd1                	bnez	a5,80004b54 <balloc+0x128>
        bp->data[bi/8] |= m;  // Mark block in use.
    80004ac2:	fe842783          	lw	a5,-24(s0)
    80004ac6:	41f7d71b          	sraiw	a4,a5,0x1f
    80004aca:	01d7571b          	srliw	a4,a4,0x1d
    80004ace:	9fb9                	addw	a5,a5,a4
    80004ad0:	4037d79b          	sraiw	a5,a5,0x3
    80004ad4:	2781                	sext.w	a5,a5
    80004ad6:	fe043703          	ld	a4,-32(s0)
    80004ada:	973e                	add	a4,a4,a5
    80004adc:	05874703          	lbu	a4,88(a4)
    80004ae0:	0187169b          	slliw	a3,a4,0x18
    80004ae4:	4186d69b          	sraiw	a3,a3,0x18
    80004ae8:	fdc42703          	lw	a4,-36(s0)
    80004aec:	0187171b          	slliw	a4,a4,0x18
    80004af0:	4187571b          	sraiw	a4,a4,0x18
    80004af4:	8f55                	or	a4,a4,a3
    80004af6:	0187171b          	slliw	a4,a4,0x18
    80004afa:	4187571b          	sraiw	a4,a4,0x18
    80004afe:	0ff77713          	zext.b	a4,a4
    80004b02:	fe043683          	ld	a3,-32(s0)
    80004b06:	97b6                	add	a5,a5,a3
    80004b08:	04e78c23          	sb	a4,88(a5)
        log_write(bp);
    80004b0c:	fe043503          	ld	a0,-32(s0)
    80004b10:	00002097          	auipc	ra,0x2
    80004b14:	918080e7          	jalr	-1768(ra) # 80006428 <log_write>
        brelse(bp);
    80004b18:	fe043503          	ld	a0,-32(s0)
    80004b1c:	00000097          	auipc	ra,0x0
    80004b20:	c68080e7          	jalr	-920(ra) # 80004784 <brelse>
        bzero(dev, b + bi);
    80004b24:	fcc42783          	lw	a5,-52(s0)
    80004b28:	fec42703          	lw	a4,-20(s0)
    80004b2c:	86ba                	mv	a3,a4
    80004b2e:	fe842703          	lw	a4,-24(s0)
    80004b32:	9f35                	addw	a4,a4,a3
    80004b34:	2701                	sext.w	a4,a4
    80004b36:	85ba                	mv	a1,a4
    80004b38:	853e                	mv	a0,a5
    80004b3a:	00000097          	auipc	ra,0x0
    80004b3e:	e8a080e7          	jalr	-374(ra) # 800049c4 <bzero>
        return b + bi;
    80004b42:	fec42783          	lw	a5,-20(s0)
    80004b46:	873e                	mv	a4,a5
    80004b48:	fe842783          	lw	a5,-24(s0)
    80004b4c:	9fb9                	addw	a5,a5,a4
    80004b4e:	2781                	sext.w	a5,a5
    80004b50:	2781                	sext.w	a5,a5
    80004b52:	a8a5                	j	80004bca <balloc+0x19e>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80004b54:	fe842783          	lw	a5,-24(s0)
    80004b58:	2785                	addiw	a5,a5,1
    80004b5a:	fef42423          	sw	a5,-24(s0)
    80004b5e:	fe842783          	lw	a5,-24(s0)
    80004b62:	0007871b          	sext.w	a4,a5
    80004b66:	6789                	lui	a5,0x2
    80004b68:	02f75263          	bge	a4,a5,80004b8c <balloc+0x160>
    80004b6c:	fec42783          	lw	a5,-20(s0)
    80004b70:	873e                	mv	a4,a5
    80004b72:	fe842783          	lw	a5,-24(s0)
    80004b76:	9fb9                	addw	a5,a5,a4
    80004b78:	2781                	sext.w	a5,a5
    80004b7a:	0007871b          	sext.w	a4,a5
    80004b7e:	00020797          	auipc	a5,0x20
    80004b82:	a9278793          	addi	a5,a5,-1390 # 80024610 <sb>
    80004b86:	43dc                	lw	a5,4(a5)
    80004b88:	eef76fe3          	bltu	a4,a5,80004a86 <balloc+0x5a>
      }
    }
    brelse(bp);
    80004b8c:	fe043503          	ld	a0,-32(s0)
    80004b90:	00000097          	auipc	ra,0x0
    80004b94:	bf4080e7          	jalr	-1036(ra) # 80004784 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80004b98:	fec42783          	lw	a5,-20(s0)
    80004b9c:	873e                	mv	a4,a5
    80004b9e:	6789                	lui	a5,0x2
    80004ba0:	9fb9                	addw	a5,a5,a4
    80004ba2:	fef42623          	sw	a5,-20(s0)
    80004ba6:	00020797          	auipc	a5,0x20
    80004baa:	a6a78793          	addi	a5,a5,-1430 # 80024610 <sb>
    80004bae:	43d8                	lw	a4,4(a5)
    80004bb0:	fec42783          	lw	a5,-20(s0)
    80004bb4:	e8e7e8e3          	bltu	a5,a4,80004a44 <balloc+0x18>
  }
  printf("balloc: out of blocks\n");
    80004bb8:	00007517          	auipc	a0,0x7
    80004bbc:	8c050513          	addi	a0,a0,-1856 # 8000b478 <etext+0x478>
    80004bc0:	ffffc097          	auipc	ra,0xffffc
    80004bc4:	e74080e7          	jalr	-396(ra) # 80000a34 <printf>
  return 0;
    80004bc8:	4781                	li	a5,0
}
    80004bca:	853e                	mv	a0,a5
    80004bcc:	70e2                	ld	ra,56(sp)
    80004bce:	7442                	ld	s0,48(sp)
    80004bd0:	6121                	addi	sp,sp,64
    80004bd2:	8082                	ret

0000000080004bd4 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80004bd4:	7179                	addi	sp,sp,-48
    80004bd6:	f406                	sd	ra,40(sp)
    80004bd8:	f022                	sd	s0,32(sp)
    80004bda:	1800                	addi	s0,sp,48
    80004bdc:	87aa                	mv	a5,a0
    80004bde:	872e                	mv	a4,a1
    80004be0:	fcf42e23          	sw	a5,-36(s0)
    80004be4:	87ba                	mv	a5,a4
    80004be6:	fcf42c23          	sw	a5,-40(s0)
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80004bea:	fdc42683          	lw	a3,-36(s0)
    80004bee:	fd842783          	lw	a5,-40(s0)
    80004bf2:	00d7d79b          	srliw	a5,a5,0xd
    80004bf6:	0007871b          	sext.w	a4,a5
    80004bfa:	00020797          	auipc	a5,0x20
    80004bfe:	a1678793          	addi	a5,a5,-1514 # 80024610 <sb>
    80004c02:	4fdc                	lw	a5,28(a5)
    80004c04:	9fb9                	addw	a5,a5,a4
    80004c06:	2781                	sext.w	a5,a5
    80004c08:	85be                	mv	a1,a5
    80004c0a:	8536                	mv	a0,a3
    80004c0c:	00000097          	auipc	ra,0x0
    80004c10:	ad6080e7          	jalr	-1322(ra) # 800046e2 <bread>
    80004c14:	fea43423          	sd	a0,-24(s0)
  bi = b % BPB;
    80004c18:	fd842703          	lw	a4,-40(s0)
    80004c1c:	6789                	lui	a5,0x2
    80004c1e:	17fd                	addi	a5,a5,-1 # 1fff <_entry-0x7fffe001>
    80004c20:	8ff9                	and	a5,a5,a4
    80004c22:	fef42223          	sw	a5,-28(s0)
  m = 1 << (bi % 8);
    80004c26:	fe442783          	lw	a5,-28(s0)
    80004c2a:	8b9d                	andi	a5,a5,7
    80004c2c:	2781                	sext.w	a5,a5
    80004c2e:	4705                	li	a4,1
    80004c30:	00f717bb          	sllw	a5,a4,a5
    80004c34:	fef42023          	sw	a5,-32(s0)
  if((bp->data[bi/8] & m) == 0)
    80004c38:	fe442783          	lw	a5,-28(s0)
    80004c3c:	41f7d71b          	sraiw	a4,a5,0x1f
    80004c40:	01d7571b          	srliw	a4,a4,0x1d
    80004c44:	9fb9                	addw	a5,a5,a4
    80004c46:	4037d79b          	sraiw	a5,a5,0x3
    80004c4a:	2781                	sext.w	a5,a5
    80004c4c:	fe843703          	ld	a4,-24(s0)
    80004c50:	97ba                	add	a5,a5,a4
    80004c52:	0587c783          	lbu	a5,88(a5)
    80004c56:	2781                	sext.w	a5,a5
    80004c58:	fe042703          	lw	a4,-32(s0)
    80004c5c:	8ff9                	and	a5,a5,a4
    80004c5e:	2781                	sext.w	a5,a5
    80004c60:	eb89                	bnez	a5,80004c72 <bfree+0x9e>
    panic("freeing free block");
    80004c62:	00007517          	auipc	a0,0x7
    80004c66:	82e50513          	addi	a0,a0,-2002 # 8000b490 <etext+0x490>
    80004c6a:	ffffc097          	auipc	ra,0xffffc
    80004c6e:	020080e7          	jalr	32(ra) # 80000c8a <panic>
  bp->data[bi/8] &= ~m;
    80004c72:	fe442783          	lw	a5,-28(s0)
    80004c76:	41f7d71b          	sraiw	a4,a5,0x1f
    80004c7a:	01d7571b          	srliw	a4,a4,0x1d
    80004c7e:	9fb9                	addw	a5,a5,a4
    80004c80:	4037d79b          	sraiw	a5,a5,0x3
    80004c84:	2781                	sext.w	a5,a5
    80004c86:	fe843703          	ld	a4,-24(s0)
    80004c8a:	973e                	add	a4,a4,a5
    80004c8c:	05874703          	lbu	a4,88(a4)
    80004c90:	0187169b          	slliw	a3,a4,0x18
    80004c94:	4186d69b          	sraiw	a3,a3,0x18
    80004c98:	fe042703          	lw	a4,-32(s0)
    80004c9c:	0187171b          	slliw	a4,a4,0x18
    80004ca0:	4187571b          	sraiw	a4,a4,0x18
    80004ca4:	fff74713          	not	a4,a4
    80004ca8:	0187171b          	slliw	a4,a4,0x18
    80004cac:	4187571b          	sraiw	a4,a4,0x18
    80004cb0:	8f75                	and	a4,a4,a3
    80004cb2:	0187171b          	slliw	a4,a4,0x18
    80004cb6:	4187571b          	sraiw	a4,a4,0x18
    80004cba:	0ff77713          	zext.b	a4,a4
    80004cbe:	fe843683          	ld	a3,-24(s0)
    80004cc2:	97b6                	add	a5,a5,a3
    80004cc4:	04e78c23          	sb	a4,88(a5)
  log_write(bp);
    80004cc8:	fe843503          	ld	a0,-24(s0)
    80004ccc:	00001097          	auipc	ra,0x1
    80004cd0:	75c080e7          	jalr	1884(ra) # 80006428 <log_write>
  brelse(bp);
    80004cd4:	fe843503          	ld	a0,-24(s0)
    80004cd8:	00000097          	auipc	ra,0x0
    80004cdc:	aac080e7          	jalr	-1364(ra) # 80004784 <brelse>
}
    80004ce0:	0001                	nop
    80004ce2:	70a2                	ld	ra,40(sp)
    80004ce4:	7402                	ld	s0,32(sp)
    80004ce6:	6145                	addi	sp,sp,48
    80004ce8:	8082                	ret

0000000080004cea <iinit>:
  struct inode inode[NINODE];
} itable;

void
iinit()
{
    80004cea:	1101                	addi	sp,sp,-32
    80004cec:	ec06                	sd	ra,24(sp)
    80004cee:	e822                	sd	s0,16(sp)
    80004cf0:	1000                	addi	s0,sp,32
  int i = 0;
    80004cf2:	fe042623          	sw	zero,-20(s0)
  
  initlock(&itable.lock, "itable");
    80004cf6:	00006597          	auipc	a1,0x6
    80004cfa:	7b258593          	addi	a1,a1,1970 # 8000b4a8 <etext+0x4a8>
    80004cfe:	00020517          	auipc	a0,0x20
    80004d02:	93250513          	addi	a0,a0,-1742 # 80024630 <itable>
    80004d06:	ffffc097          	auipc	ra,0xffffc
    80004d0a:	548080e7          	jalr	1352(ra) # 8000124e <initlock>
  for(i = 0; i < NINODE; i++) {
    80004d0e:	fe042623          	sw	zero,-20(s0)
    80004d12:	a82d                	j	80004d4c <iinit+0x62>
    initsleeplock(&itable.inode[i].lock, "inode");
    80004d14:	fec42703          	lw	a4,-20(s0)
    80004d18:	87ba                	mv	a5,a4
    80004d1a:	0792                	slli	a5,a5,0x4
    80004d1c:	97ba                	add	a5,a5,a4
    80004d1e:	078e                	slli	a5,a5,0x3
    80004d20:	02078713          	addi	a4,a5,32
    80004d24:	00020797          	auipc	a5,0x20
    80004d28:	90c78793          	addi	a5,a5,-1780 # 80024630 <itable>
    80004d2c:	97ba                	add	a5,a5,a4
    80004d2e:	07a1                	addi	a5,a5,8
    80004d30:	00006597          	auipc	a1,0x6
    80004d34:	78058593          	addi	a1,a1,1920 # 8000b4b0 <etext+0x4b0>
    80004d38:	853e                	mv	a0,a5
    80004d3a:	00002097          	auipc	ra,0x2
    80004d3e:	822080e7          	jalr	-2014(ra) # 8000655c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80004d42:	fec42783          	lw	a5,-20(s0)
    80004d46:	2785                	addiw	a5,a5,1
    80004d48:	fef42623          	sw	a5,-20(s0)
    80004d4c:	fec42783          	lw	a5,-20(s0)
    80004d50:	0007871b          	sext.w	a4,a5
    80004d54:	03100793          	li	a5,49
    80004d58:	fae7dee3          	bge	a5,a4,80004d14 <iinit+0x2a>
  }
}
    80004d5c:	0001                	nop
    80004d5e:	0001                	nop
    80004d60:	60e2                	ld	ra,24(sp)
    80004d62:	6442                	ld	s0,16(sp)
    80004d64:	6105                	addi	sp,sp,32
    80004d66:	8082                	ret

0000000080004d68 <ialloc>:
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode,
// or NULL if there is no free inode.
struct inode*
ialloc(uint dev, short type)
{
    80004d68:	7139                	addi	sp,sp,-64
    80004d6a:	fc06                	sd	ra,56(sp)
    80004d6c:	f822                	sd	s0,48(sp)
    80004d6e:	0080                	addi	s0,sp,64
    80004d70:	87aa                	mv	a5,a0
    80004d72:	872e                	mv	a4,a1
    80004d74:	fcf42623          	sw	a5,-52(s0)
    80004d78:	87ba                	mv	a5,a4
    80004d7a:	fcf41523          	sh	a5,-54(s0)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    80004d7e:	4785                	li	a5,1
    80004d80:	fef42623          	sw	a5,-20(s0)
    80004d84:	a855                	j	80004e38 <ialloc+0xd0>
    bp = bread(dev, IBLOCK(inum, sb));
    80004d86:	fec42783          	lw	a5,-20(s0)
    80004d8a:	8391                	srli	a5,a5,0x4
    80004d8c:	0007871b          	sext.w	a4,a5
    80004d90:	00020797          	auipc	a5,0x20
    80004d94:	88078793          	addi	a5,a5,-1920 # 80024610 <sb>
    80004d98:	4f9c                	lw	a5,24(a5)
    80004d9a:	9fb9                	addw	a5,a5,a4
    80004d9c:	0007871b          	sext.w	a4,a5
    80004da0:	fcc42783          	lw	a5,-52(s0)
    80004da4:	85ba                	mv	a1,a4
    80004da6:	853e                	mv	a0,a5
    80004da8:	00000097          	auipc	ra,0x0
    80004dac:	93a080e7          	jalr	-1734(ra) # 800046e2 <bread>
    80004db0:	fea43023          	sd	a0,-32(s0)
    dip = (struct dinode*)bp->data + inum%IPB;
    80004db4:	fe043783          	ld	a5,-32(s0)
    80004db8:	05878713          	addi	a4,a5,88
    80004dbc:	fec42783          	lw	a5,-20(s0)
    80004dc0:	8bbd                	andi	a5,a5,15
    80004dc2:	079a                	slli	a5,a5,0x6
    80004dc4:	97ba                	add	a5,a5,a4
    80004dc6:	fcf43c23          	sd	a5,-40(s0)
    if(dip->type == 0){  // a free inode
    80004dca:	fd843783          	ld	a5,-40(s0)
    80004dce:	00079783          	lh	a5,0(a5)
    80004dd2:	eba1                	bnez	a5,80004e22 <ialloc+0xba>
      memset(dip, 0, sizeof(*dip));
    80004dd4:	04000613          	li	a2,64
    80004dd8:	4581                	li	a1,0
    80004dda:	fd843503          	ld	a0,-40(s0)
    80004dde:	ffffc097          	auipc	ra,0xffffc
    80004de2:	674080e7          	jalr	1652(ra) # 80001452 <memset>
      dip->type = type;
    80004de6:	fd843783          	ld	a5,-40(s0)
    80004dea:	fca45703          	lhu	a4,-54(s0)
    80004dee:	00e79023          	sh	a4,0(a5)
      log_write(bp);   // mark it allocated on the disk
    80004df2:	fe043503          	ld	a0,-32(s0)
    80004df6:	00001097          	auipc	ra,0x1
    80004dfa:	632080e7          	jalr	1586(ra) # 80006428 <log_write>
      brelse(bp);
    80004dfe:	fe043503          	ld	a0,-32(s0)
    80004e02:	00000097          	auipc	ra,0x0
    80004e06:	982080e7          	jalr	-1662(ra) # 80004784 <brelse>
      return iget(dev, inum);
    80004e0a:	fec42703          	lw	a4,-20(s0)
    80004e0e:	fcc42783          	lw	a5,-52(s0)
    80004e12:	85ba                	mv	a1,a4
    80004e14:	853e                	mv	a0,a5
    80004e16:	00000097          	auipc	ra,0x0
    80004e1a:	138080e7          	jalr	312(ra) # 80004f4e <iget>
    80004e1e:	87aa                	mv	a5,a0
    80004e20:	a835                	j	80004e5c <ialloc+0xf4>
    }
    brelse(bp);
    80004e22:	fe043503          	ld	a0,-32(s0)
    80004e26:	00000097          	auipc	ra,0x0
    80004e2a:	95e080e7          	jalr	-1698(ra) # 80004784 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80004e2e:	fec42783          	lw	a5,-20(s0)
    80004e32:	2785                	addiw	a5,a5,1
    80004e34:	fef42623          	sw	a5,-20(s0)
    80004e38:	0001f797          	auipc	a5,0x1f
    80004e3c:	7d878793          	addi	a5,a5,2008 # 80024610 <sb>
    80004e40:	47d8                	lw	a4,12(a5)
    80004e42:	fec42783          	lw	a5,-20(s0)
    80004e46:	f4e7e0e3          	bltu	a5,a4,80004d86 <ialloc+0x1e>
  }
  printf("ialloc: no inodes\n");
    80004e4a:	00006517          	auipc	a0,0x6
    80004e4e:	66e50513          	addi	a0,a0,1646 # 8000b4b8 <etext+0x4b8>
    80004e52:	ffffc097          	auipc	ra,0xffffc
    80004e56:	be2080e7          	jalr	-1054(ra) # 80000a34 <printf>
  return 0;
    80004e5a:	4781                	li	a5,0
}
    80004e5c:	853e                	mv	a0,a5
    80004e5e:	70e2                	ld	ra,56(sp)
    80004e60:	7442                	ld	s0,48(sp)
    80004e62:	6121                	addi	sp,sp,64
    80004e64:	8082                	ret

0000000080004e66 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
    80004e66:	7179                	addi	sp,sp,-48
    80004e68:	f406                	sd	ra,40(sp)
    80004e6a:	f022                	sd	s0,32(sp)
    80004e6c:	1800                	addi	s0,sp,48
    80004e6e:	fca43c23          	sd	a0,-40(s0)
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80004e72:	fd843783          	ld	a5,-40(s0)
    80004e76:	4394                	lw	a3,0(a5)
    80004e78:	fd843783          	ld	a5,-40(s0)
    80004e7c:	43dc                	lw	a5,4(a5)
    80004e7e:	0047d79b          	srliw	a5,a5,0x4
    80004e82:	0007871b          	sext.w	a4,a5
    80004e86:	0001f797          	auipc	a5,0x1f
    80004e8a:	78a78793          	addi	a5,a5,1930 # 80024610 <sb>
    80004e8e:	4f9c                	lw	a5,24(a5)
    80004e90:	9fb9                	addw	a5,a5,a4
    80004e92:	2781                	sext.w	a5,a5
    80004e94:	85be                	mv	a1,a5
    80004e96:	8536                	mv	a0,a3
    80004e98:	00000097          	auipc	ra,0x0
    80004e9c:	84a080e7          	jalr	-1974(ra) # 800046e2 <bread>
    80004ea0:	fea43423          	sd	a0,-24(s0)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80004ea4:	fe843783          	ld	a5,-24(s0)
    80004ea8:	05878713          	addi	a4,a5,88
    80004eac:	fd843783          	ld	a5,-40(s0)
    80004eb0:	43dc                	lw	a5,4(a5)
    80004eb2:	1782                	slli	a5,a5,0x20
    80004eb4:	9381                	srli	a5,a5,0x20
    80004eb6:	8bbd                	andi	a5,a5,15
    80004eb8:	079a                	slli	a5,a5,0x6
    80004eba:	97ba                	add	a5,a5,a4
    80004ebc:	fef43023          	sd	a5,-32(s0)
  dip->type = ip->type;
    80004ec0:	fd843783          	ld	a5,-40(s0)
    80004ec4:	04479703          	lh	a4,68(a5)
    80004ec8:	fe043783          	ld	a5,-32(s0)
    80004ecc:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80004ed0:	fd843783          	ld	a5,-40(s0)
    80004ed4:	04679703          	lh	a4,70(a5)
    80004ed8:	fe043783          	ld	a5,-32(s0)
    80004edc:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80004ee0:	fd843783          	ld	a5,-40(s0)
    80004ee4:	04879703          	lh	a4,72(a5)
    80004ee8:	fe043783          	ld	a5,-32(s0)
    80004eec:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80004ef0:	fd843783          	ld	a5,-40(s0)
    80004ef4:	04a79703          	lh	a4,74(a5)
    80004ef8:	fe043783          	ld	a5,-32(s0)
    80004efc:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80004f00:	fd843783          	ld	a5,-40(s0)
    80004f04:	47f8                	lw	a4,76(a5)
    80004f06:	fe043783          	ld	a5,-32(s0)
    80004f0a:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80004f0c:	fe043783          	ld	a5,-32(s0)
    80004f10:	00c78713          	addi	a4,a5,12
    80004f14:	fd843783          	ld	a5,-40(s0)
    80004f18:	05078793          	addi	a5,a5,80
    80004f1c:	03400613          	li	a2,52
    80004f20:	85be                	mv	a1,a5
    80004f22:	853a                	mv	a0,a4
    80004f24:	ffffc097          	auipc	ra,0xffffc
    80004f28:	612080e7          	jalr	1554(ra) # 80001536 <memmove>
  log_write(bp);
    80004f2c:	fe843503          	ld	a0,-24(s0)
    80004f30:	00001097          	auipc	ra,0x1
    80004f34:	4f8080e7          	jalr	1272(ra) # 80006428 <log_write>
  brelse(bp);
    80004f38:	fe843503          	ld	a0,-24(s0)
    80004f3c:	00000097          	auipc	ra,0x0
    80004f40:	848080e7          	jalr	-1976(ra) # 80004784 <brelse>
}
    80004f44:	0001                	nop
    80004f46:	70a2                	ld	ra,40(sp)
    80004f48:	7402                	ld	s0,32(sp)
    80004f4a:	6145                	addi	sp,sp,48
    80004f4c:	8082                	ret

0000000080004f4e <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
    80004f4e:	7179                	addi	sp,sp,-48
    80004f50:	f406                	sd	ra,40(sp)
    80004f52:	f022                	sd	s0,32(sp)
    80004f54:	1800                	addi	s0,sp,48
    80004f56:	87aa                	mv	a5,a0
    80004f58:	872e                	mv	a4,a1
    80004f5a:	fcf42e23          	sw	a5,-36(s0)
    80004f5e:	87ba                	mv	a5,a4
    80004f60:	fcf42c23          	sw	a5,-40(s0)
  struct inode *ip, *empty;

  acquire(&itable.lock);
    80004f64:	0001f517          	auipc	a0,0x1f
    80004f68:	6cc50513          	addi	a0,a0,1740 # 80024630 <itable>
    80004f6c:	ffffc097          	auipc	ra,0xffffc
    80004f70:	312080e7          	jalr	786(ra) # 8000127e <acquire>

  // Is the inode already in the table?
  empty = 0;
    80004f74:	fe043023          	sd	zero,-32(s0)
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80004f78:	0001f797          	auipc	a5,0x1f
    80004f7c:	6d078793          	addi	a5,a5,1744 # 80024648 <itable+0x18>
    80004f80:	fef43423          	sd	a5,-24(s0)
    80004f84:	a89d                	j	80004ffa <iget+0xac>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80004f86:	fe843783          	ld	a5,-24(s0)
    80004f8a:	479c                	lw	a5,8(a5)
    80004f8c:	04f05663          	blez	a5,80004fd8 <iget+0x8a>
    80004f90:	fe843783          	ld	a5,-24(s0)
    80004f94:	4398                	lw	a4,0(a5)
    80004f96:	fdc42783          	lw	a5,-36(s0)
    80004f9a:	2781                	sext.w	a5,a5
    80004f9c:	02e79e63          	bne	a5,a4,80004fd8 <iget+0x8a>
    80004fa0:	fe843783          	ld	a5,-24(s0)
    80004fa4:	43d8                	lw	a4,4(a5)
    80004fa6:	fd842783          	lw	a5,-40(s0)
    80004faa:	2781                	sext.w	a5,a5
    80004fac:	02e79663          	bne	a5,a4,80004fd8 <iget+0x8a>
      ip->ref++;
    80004fb0:	fe843783          	ld	a5,-24(s0)
    80004fb4:	479c                	lw	a5,8(a5)
    80004fb6:	2785                	addiw	a5,a5,1
    80004fb8:	0007871b          	sext.w	a4,a5
    80004fbc:	fe843783          	ld	a5,-24(s0)
    80004fc0:	c798                	sw	a4,8(a5)
      release(&itable.lock);
    80004fc2:	0001f517          	auipc	a0,0x1f
    80004fc6:	66e50513          	addi	a0,a0,1646 # 80024630 <itable>
    80004fca:	ffffc097          	auipc	ra,0xffffc
    80004fce:	318080e7          	jalr	792(ra) # 800012e2 <release>
      return ip;
    80004fd2:	fe843783          	ld	a5,-24(s0)
    80004fd6:	a069                	j	80005060 <iget+0x112>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80004fd8:	fe043783          	ld	a5,-32(s0)
    80004fdc:	eb89                	bnez	a5,80004fee <iget+0xa0>
    80004fde:	fe843783          	ld	a5,-24(s0)
    80004fe2:	479c                	lw	a5,8(a5)
    80004fe4:	e789                	bnez	a5,80004fee <iget+0xa0>
      empty = ip;
    80004fe6:	fe843783          	ld	a5,-24(s0)
    80004fea:	fef43023          	sd	a5,-32(s0)
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80004fee:	fe843783          	ld	a5,-24(s0)
    80004ff2:	08878793          	addi	a5,a5,136
    80004ff6:	fef43423          	sd	a5,-24(s0)
    80004ffa:	fe843703          	ld	a4,-24(s0)
    80004ffe:	00021797          	auipc	a5,0x21
    80005002:	0da78793          	addi	a5,a5,218 # 800260d8 <log>
    80005006:	f8f760e3          	bltu	a4,a5,80004f86 <iget+0x38>
  }

  // Recycle an inode entry.
  if(empty == 0)
    8000500a:	fe043783          	ld	a5,-32(s0)
    8000500e:	eb89                	bnez	a5,80005020 <iget+0xd2>
    panic("iget: no inodes");
    80005010:	00006517          	auipc	a0,0x6
    80005014:	4c050513          	addi	a0,a0,1216 # 8000b4d0 <etext+0x4d0>
    80005018:	ffffc097          	auipc	ra,0xffffc
    8000501c:	c72080e7          	jalr	-910(ra) # 80000c8a <panic>

  ip = empty;
    80005020:	fe043783          	ld	a5,-32(s0)
    80005024:	fef43423          	sd	a5,-24(s0)
  ip->dev = dev;
    80005028:	fe843783          	ld	a5,-24(s0)
    8000502c:	fdc42703          	lw	a4,-36(s0)
    80005030:	c398                	sw	a4,0(a5)
  ip->inum = inum;
    80005032:	fe843783          	ld	a5,-24(s0)
    80005036:	fd842703          	lw	a4,-40(s0)
    8000503a:	c3d8                	sw	a4,4(a5)
  ip->ref = 1;
    8000503c:	fe843783          	ld	a5,-24(s0)
    80005040:	4705                	li	a4,1
    80005042:	c798                	sw	a4,8(a5)
  ip->valid = 0;
    80005044:	fe843783          	ld	a5,-24(s0)
    80005048:	0407a023          	sw	zero,64(a5)
  release(&itable.lock);
    8000504c:	0001f517          	auipc	a0,0x1f
    80005050:	5e450513          	addi	a0,a0,1508 # 80024630 <itable>
    80005054:	ffffc097          	auipc	ra,0xffffc
    80005058:	28e080e7          	jalr	654(ra) # 800012e2 <release>

  return ip;
    8000505c:	fe843783          	ld	a5,-24(s0)
}
    80005060:	853e                	mv	a0,a5
    80005062:	70a2                	ld	ra,40(sp)
    80005064:	7402                	ld	s0,32(sp)
    80005066:	6145                	addi	sp,sp,48
    80005068:	8082                	ret

000000008000506a <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
    8000506a:	1101                	addi	sp,sp,-32
    8000506c:	ec06                	sd	ra,24(sp)
    8000506e:	e822                	sd	s0,16(sp)
    80005070:	1000                	addi	s0,sp,32
    80005072:	fea43423          	sd	a0,-24(s0)
  acquire(&itable.lock);
    80005076:	0001f517          	auipc	a0,0x1f
    8000507a:	5ba50513          	addi	a0,a0,1466 # 80024630 <itable>
    8000507e:	ffffc097          	auipc	ra,0xffffc
    80005082:	200080e7          	jalr	512(ra) # 8000127e <acquire>
  ip->ref++;
    80005086:	fe843783          	ld	a5,-24(s0)
    8000508a:	479c                	lw	a5,8(a5)
    8000508c:	2785                	addiw	a5,a5,1
    8000508e:	0007871b          	sext.w	a4,a5
    80005092:	fe843783          	ld	a5,-24(s0)
    80005096:	c798                	sw	a4,8(a5)
  release(&itable.lock);
    80005098:	0001f517          	auipc	a0,0x1f
    8000509c:	59850513          	addi	a0,a0,1432 # 80024630 <itable>
    800050a0:	ffffc097          	auipc	ra,0xffffc
    800050a4:	242080e7          	jalr	578(ra) # 800012e2 <release>
  return ip;
    800050a8:	fe843783          	ld	a5,-24(s0)
}
    800050ac:	853e                	mv	a0,a5
    800050ae:	60e2                	ld	ra,24(sp)
    800050b0:	6442                	ld	s0,16(sp)
    800050b2:	6105                	addi	sp,sp,32
    800050b4:	8082                	ret

00000000800050b6 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
    800050b6:	7179                	addi	sp,sp,-48
    800050b8:	f406                	sd	ra,40(sp)
    800050ba:	f022                	sd	s0,32(sp)
    800050bc:	1800                	addi	s0,sp,48
    800050be:	fca43c23          	sd	a0,-40(s0)
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    800050c2:	fd843783          	ld	a5,-40(s0)
    800050c6:	c791                	beqz	a5,800050d2 <ilock+0x1c>
    800050c8:	fd843783          	ld	a5,-40(s0)
    800050cc:	479c                	lw	a5,8(a5)
    800050ce:	00f04a63          	bgtz	a5,800050e2 <ilock+0x2c>
    panic("ilock");
    800050d2:	00006517          	auipc	a0,0x6
    800050d6:	40e50513          	addi	a0,a0,1038 # 8000b4e0 <etext+0x4e0>
    800050da:	ffffc097          	auipc	ra,0xffffc
    800050de:	bb0080e7          	jalr	-1104(ra) # 80000c8a <panic>

  acquiresleep(&ip->lock);
    800050e2:	fd843783          	ld	a5,-40(s0)
    800050e6:	07c1                	addi	a5,a5,16
    800050e8:	853e                	mv	a0,a5
    800050ea:	00001097          	auipc	ra,0x1
    800050ee:	4be080e7          	jalr	1214(ra) # 800065a8 <acquiresleep>

  if(ip->valid == 0){
    800050f2:	fd843783          	ld	a5,-40(s0)
    800050f6:	43bc                	lw	a5,64(a5)
    800050f8:	e7e5                	bnez	a5,800051e0 <ilock+0x12a>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800050fa:	fd843783          	ld	a5,-40(s0)
    800050fe:	4394                	lw	a3,0(a5)
    80005100:	fd843783          	ld	a5,-40(s0)
    80005104:	43dc                	lw	a5,4(a5)
    80005106:	0047d79b          	srliw	a5,a5,0x4
    8000510a:	0007871b          	sext.w	a4,a5
    8000510e:	0001f797          	auipc	a5,0x1f
    80005112:	50278793          	addi	a5,a5,1282 # 80024610 <sb>
    80005116:	4f9c                	lw	a5,24(a5)
    80005118:	9fb9                	addw	a5,a5,a4
    8000511a:	2781                	sext.w	a5,a5
    8000511c:	85be                	mv	a1,a5
    8000511e:	8536                	mv	a0,a3
    80005120:	fffff097          	auipc	ra,0xfffff
    80005124:	5c2080e7          	jalr	1474(ra) # 800046e2 <bread>
    80005128:	fea43423          	sd	a0,-24(s0)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000512c:	fe843783          	ld	a5,-24(s0)
    80005130:	05878713          	addi	a4,a5,88
    80005134:	fd843783          	ld	a5,-40(s0)
    80005138:	43dc                	lw	a5,4(a5)
    8000513a:	1782                	slli	a5,a5,0x20
    8000513c:	9381                	srli	a5,a5,0x20
    8000513e:	8bbd                	andi	a5,a5,15
    80005140:	079a                	slli	a5,a5,0x6
    80005142:	97ba                	add	a5,a5,a4
    80005144:	fef43023          	sd	a5,-32(s0)
    ip->type = dip->type;
    80005148:	fe043783          	ld	a5,-32(s0)
    8000514c:	00079703          	lh	a4,0(a5)
    80005150:	fd843783          	ld	a5,-40(s0)
    80005154:	04e79223          	sh	a4,68(a5)
    ip->major = dip->major;
    80005158:	fe043783          	ld	a5,-32(s0)
    8000515c:	00279703          	lh	a4,2(a5)
    80005160:	fd843783          	ld	a5,-40(s0)
    80005164:	04e79323          	sh	a4,70(a5)
    ip->minor = dip->minor;
    80005168:	fe043783          	ld	a5,-32(s0)
    8000516c:	00479703          	lh	a4,4(a5)
    80005170:	fd843783          	ld	a5,-40(s0)
    80005174:	04e79423          	sh	a4,72(a5)
    ip->nlink = dip->nlink;
    80005178:	fe043783          	ld	a5,-32(s0)
    8000517c:	00679703          	lh	a4,6(a5)
    80005180:	fd843783          	ld	a5,-40(s0)
    80005184:	04e79523          	sh	a4,74(a5)
    ip->size = dip->size;
    80005188:	fe043783          	ld	a5,-32(s0)
    8000518c:	4798                	lw	a4,8(a5)
    8000518e:	fd843783          	ld	a5,-40(s0)
    80005192:	c7f8                	sw	a4,76(a5)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80005194:	fd843783          	ld	a5,-40(s0)
    80005198:	05078713          	addi	a4,a5,80
    8000519c:	fe043783          	ld	a5,-32(s0)
    800051a0:	07b1                	addi	a5,a5,12
    800051a2:	03400613          	li	a2,52
    800051a6:	85be                	mv	a1,a5
    800051a8:	853a                	mv	a0,a4
    800051aa:	ffffc097          	auipc	ra,0xffffc
    800051ae:	38c080e7          	jalr	908(ra) # 80001536 <memmove>
    brelse(bp);
    800051b2:	fe843503          	ld	a0,-24(s0)
    800051b6:	fffff097          	auipc	ra,0xfffff
    800051ba:	5ce080e7          	jalr	1486(ra) # 80004784 <brelse>
    ip->valid = 1;
    800051be:	fd843783          	ld	a5,-40(s0)
    800051c2:	4705                	li	a4,1
    800051c4:	c3b8                	sw	a4,64(a5)
    if(ip->type == 0)
    800051c6:	fd843783          	ld	a5,-40(s0)
    800051ca:	04479783          	lh	a5,68(a5)
    800051ce:	eb89                	bnez	a5,800051e0 <ilock+0x12a>
      panic("ilock: no type");
    800051d0:	00006517          	auipc	a0,0x6
    800051d4:	31850513          	addi	a0,a0,792 # 8000b4e8 <etext+0x4e8>
    800051d8:	ffffc097          	auipc	ra,0xffffc
    800051dc:	ab2080e7          	jalr	-1358(ra) # 80000c8a <panic>
  }
}
    800051e0:	0001                	nop
    800051e2:	70a2                	ld	ra,40(sp)
    800051e4:	7402                	ld	s0,32(sp)
    800051e6:	6145                	addi	sp,sp,48
    800051e8:	8082                	ret

00000000800051ea <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
    800051ea:	1101                	addi	sp,sp,-32
    800051ec:	ec06                	sd	ra,24(sp)
    800051ee:	e822                	sd	s0,16(sp)
    800051f0:	1000                	addi	s0,sp,32
    800051f2:	fea43423          	sd	a0,-24(s0)
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800051f6:	fe843783          	ld	a5,-24(s0)
    800051fa:	c385                	beqz	a5,8000521a <iunlock+0x30>
    800051fc:	fe843783          	ld	a5,-24(s0)
    80005200:	07c1                	addi	a5,a5,16
    80005202:	853e                	mv	a0,a5
    80005204:	00001097          	auipc	ra,0x1
    80005208:	464080e7          	jalr	1124(ra) # 80006668 <holdingsleep>
    8000520c:	87aa                	mv	a5,a0
    8000520e:	c791                	beqz	a5,8000521a <iunlock+0x30>
    80005210:	fe843783          	ld	a5,-24(s0)
    80005214:	479c                	lw	a5,8(a5)
    80005216:	00f04a63          	bgtz	a5,8000522a <iunlock+0x40>
    panic("iunlock");
    8000521a:	00006517          	auipc	a0,0x6
    8000521e:	2de50513          	addi	a0,a0,734 # 8000b4f8 <etext+0x4f8>
    80005222:	ffffc097          	auipc	ra,0xffffc
    80005226:	a68080e7          	jalr	-1432(ra) # 80000c8a <panic>

  releasesleep(&ip->lock);
    8000522a:	fe843783          	ld	a5,-24(s0)
    8000522e:	07c1                	addi	a5,a5,16
    80005230:	853e                	mv	a0,a5
    80005232:	00001097          	auipc	ra,0x1
    80005236:	3e4080e7          	jalr	996(ra) # 80006616 <releasesleep>
}
    8000523a:	0001                	nop
    8000523c:	60e2                	ld	ra,24(sp)
    8000523e:	6442                	ld	s0,16(sp)
    80005240:	6105                	addi	sp,sp,32
    80005242:	8082                	ret

0000000080005244 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
    80005244:	1101                	addi	sp,sp,-32
    80005246:	ec06                	sd	ra,24(sp)
    80005248:	e822                	sd	s0,16(sp)
    8000524a:	1000                	addi	s0,sp,32
    8000524c:	fea43423          	sd	a0,-24(s0)
  acquire(&itable.lock);
    80005250:	0001f517          	auipc	a0,0x1f
    80005254:	3e050513          	addi	a0,a0,992 # 80024630 <itable>
    80005258:	ffffc097          	auipc	ra,0xffffc
    8000525c:	026080e7          	jalr	38(ra) # 8000127e <acquire>

  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80005260:	fe843783          	ld	a5,-24(s0)
    80005264:	479c                	lw	a5,8(a5)
    80005266:	873e                	mv	a4,a5
    80005268:	4785                	li	a5,1
    8000526a:	06f71f63          	bne	a4,a5,800052e8 <iput+0xa4>
    8000526e:	fe843783          	ld	a5,-24(s0)
    80005272:	43bc                	lw	a5,64(a5)
    80005274:	cbb5                	beqz	a5,800052e8 <iput+0xa4>
    80005276:	fe843783          	ld	a5,-24(s0)
    8000527a:	04a79783          	lh	a5,74(a5)
    8000527e:	e7ad                	bnez	a5,800052e8 <iput+0xa4>
    // inode has no links and no other references: truncate and free.

    // ip->ref == 1 means no other process can have ip locked,
    // so this acquiresleep() won't block (or deadlock).
    acquiresleep(&ip->lock);
    80005280:	fe843783          	ld	a5,-24(s0)
    80005284:	07c1                	addi	a5,a5,16
    80005286:	853e                	mv	a0,a5
    80005288:	00001097          	auipc	ra,0x1
    8000528c:	320080e7          	jalr	800(ra) # 800065a8 <acquiresleep>

    release(&itable.lock);
    80005290:	0001f517          	auipc	a0,0x1f
    80005294:	3a050513          	addi	a0,a0,928 # 80024630 <itable>
    80005298:	ffffc097          	auipc	ra,0xffffc
    8000529c:	04a080e7          	jalr	74(ra) # 800012e2 <release>

    itrunc(ip);
    800052a0:	fe843503          	ld	a0,-24(s0)
    800052a4:	00000097          	auipc	ra,0x0
    800052a8:	21a080e7          	jalr	538(ra) # 800054be <itrunc>
    ip->type = 0;
    800052ac:	fe843783          	ld	a5,-24(s0)
    800052b0:	04079223          	sh	zero,68(a5)
    iupdate(ip);
    800052b4:	fe843503          	ld	a0,-24(s0)
    800052b8:	00000097          	auipc	ra,0x0
    800052bc:	bae080e7          	jalr	-1106(ra) # 80004e66 <iupdate>
    ip->valid = 0;
    800052c0:	fe843783          	ld	a5,-24(s0)
    800052c4:	0407a023          	sw	zero,64(a5)

    releasesleep(&ip->lock);
    800052c8:	fe843783          	ld	a5,-24(s0)
    800052cc:	07c1                	addi	a5,a5,16
    800052ce:	853e                	mv	a0,a5
    800052d0:	00001097          	auipc	ra,0x1
    800052d4:	346080e7          	jalr	838(ra) # 80006616 <releasesleep>

    acquire(&itable.lock);
    800052d8:	0001f517          	auipc	a0,0x1f
    800052dc:	35850513          	addi	a0,a0,856 # 80024630 <itable>
    800052e0:	ffffc097          	auipc	ra,0xffffc
    800052e4:	f9e080e7          	jalr	-98(ra) # 8000127e <acquire>
  }

  ip->ref--;
    800052e8:	fe843783          	ld	a5,-24(s0)
    800052ec:	479c                	lw	a5,8(a5)
    800052ee:	37fd                	addiw	a5,a5,-1
    800052f0:	0007871b          	sext.w	a4,a5
    800052f4:	fe843783          	ld	a5,-24(s0)
    800052f8:	c798                	sw	a4,8(a5)
  release(&itable.lock);
    800052fa:	0001f517          	auipc	a0,0x1f
    800052fe:	33650513          	addi	a0,a0,822 # 80024630 <itable>
    80005302:	ffffc097          	auipc	ra,0xffffc
    80005306:	fe0080e7          	jalr	-32(ra) # 800012e2 <release>
}
    8000530a:	0001                	nop
    8000530c:	60e2                	ld	ra,24(sp)
    8000530e:	6442                	ld	s0,16(sp)
    80005310:	6105                	addi	sp,sp,32
    80005312:	8082                	ret

0000000080005314 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
    80005314:	1101                	addi	sp,sp,-32
    80005316:	ec06                	sd	ra,24(sp)
    80005318:	e822                	sd	s0,16(sp)
    8000531a:	1000                	addi	s0,sp,32
    8000531c:	fea43423          	sd	a0,-24(s0)
  iunlock(ip);
    80005320:	fe843503          	ld	a0,-24(s0)
    80005324:	00000097          	auipc	ra,0x0
    80005328:	ec6080e7          	jalr	-314(ra) # 800051ea <iunlock>
  iput(ip);
    8000532c:	fe843503          	ld	a0,-24(s0)
    80005330:	00000097          	auipc	ra,0x0
    80005334:	f14080e7          	jalr	-236(ra) # 80005244 <iput>
}
    80005338:	0001                	nop
    8000533a:	60e2                	ld	ra,24(sp)
    8000533c:	6442                	ld	s0,16(sp)
    8000533e:	6105                	addi	sp,sp,32
    80005340:	8082                	ret

0000000080005342 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80005342:	7139                	addi	sp,sp,-64
    80005344:	fc06                	sd	ra,56(sp)
    80005346:	f822                	sd	s0,48(sp)
    80005348:	0080                	addi	s0,sp,64
    8000534a:	fca43423          	sd	a0,-56(s0)
    8000534e:	87ae                	mv	a5,a1
    80005350:	fcf42223          	sw	a5,-60(s0)
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80005354:	fc442783          	lw	a5,-60(s0)
    80005358:	0007871b          	sext.w	a4,a5
    8000535c:	47ad                	li	a5,11
    8000535e:	04e7ee63          	bltu	a5,a4,800053ba <bmap+0x78>
    if((addr = ip->addrs[bn]) == 0){
    80005362:	fc843703          	ld	a4,-56(s0)
    80005366:	fc446783          	lwu	a5,-60(s0)
    8000536a:	07d1                	addi	a5,a5,20
    8000536c:	078a                	slli	a5,a5,0x2
    8000536e:	97ba                	add	a5,a5,a4
    80005370:	439c                	lw	a5,0(a5)
    80005372:	fef42623          	sw	a5,-20(s0)
    80005376:	fec42783          	lw	a5,-20(s0)
    8000537a:	2781                	sext.w	a5,a5
    8000537c:	ef85                	bnez	a5,800053b4 <bmap+0x72>
      addr = balloc(ip->dev);
    8000537e:	fc843783          	ld	a5,-56(s0)
    80005382:	439c                	lw	a5,0(a5)
    80005384:	853e                	mv	a0,a5
    80005386:	fffff097          	auipc	ra,0xfffff
    8000538a:	6a6080e7          	jalr	1702(ra) # 80004a2c <balloc>
    8000538e:	87aa                	mv	a5,a0
    80005390:	fef42623          	sw	a5,-20(s0)
      if(addr == 0)
    80005394:	fec42783          	lw	a5,-20(s0)
    80005398:	2781                	sext.w	a5,a5
    8000539a:	e399                	bnez	a5,800053a0 <bmap+0x5e>
        return 0;
    8000539c:	4781                	li	a5,0
    8000539e:	aa19                	j	800054b4 <bmap+0x172>
      ip->addrs[bn] = addr;
    800053a0:	fc843703          	ld	a4,-56(s0)
    800053a4:	fc446783          	lwu	a5,-60(s0)
    800053a8:	07d1                	addi	a5,a5,20
    800053aa:	078a                	slli	a5,a5,0x2
    800053ac:	97ba                	add	a5,a5,a4
    800053ae:	fec42703          	lw	a4,-20(s0)
    800053b2:	c398                	sw	a4,0(a5)
    }
    return addr;
    800053b4:	fec42783          	lw	a5,-20(s0)
    800053b8:	a8f5                	j	800054b4 <bmap+0x172>
  }
  bn -= NDIRECT;
    800053ba:	fc442783          	lw	a5,-60(s0)
    800053be:	37d1                	addiw	a5,a5,-12
    800053c0:	fcf42223          	sw	a5,-60(s0)

  if(bn < NINDIRECT){
    800053c4:	fc442783          	lw	a5,-60(s0)
    800053c8:	0007871b          	sext.w	a4,a5
    800053cc:	0ff00793          	li	a5,255
    800053d0:	0ce7ea63          	bltu	a5,a4,800054a4 <bmap+0x162>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800053d4:	fc843783          	ld	a5,-56(s0)
    800053d8:	0807a783          	lw	a5,128(a5)
    800053dc:	fef42623          	sw	a5,-20(s0)
    800053e0:	fec42783          	lw	a5,-20(s0)
    800053e4:	2781                	sext.w	a5,a5
    800053e6:	eb85                	bnez	a5,80005416 <bmap+0xd4>
      addr = balloc(ip->dev);
    800053e8:	fc843783          	ld	a5,-56(s0)
    800053ec:	439c                	lw	a5,0(a5)
    800053ee:	853e                	mv	a0,a5
    800053f0:	fffff097          	auipc	ra,0xfffff
    800053f4:	63c080e7          	jalr	1596(ra) # 80004a2c <balloc>
    800053f8:	87aa                	mv	a5,a0
    800053fa:	fef42623          	sw	a5,-20(s0)
      if(addr == 0)
    800053fe:	fec42783          	lw	a5,-20(s0)
    80005402:	2781                	sext.w	a5,a5
    80005404:	e399                	bnez	a5,8000540a <bmap+0xc8>
        return 0;
    80005406:	4781                	li	a5,0
    80005408:	a075                	j	800054b4 <bmap+0x172>
      ip->addrs[NDIRECT] = addr;
    8000540a:	fc843783          	ld	a5,-56(s0)
    8000540e:	fec42703          	lw	a4,-20(s0)
    80005412:	08e7a023          	sw	a4,128(a5)
    }
    bp = bread(ip->dev, addr);
    80005416:	fc843783          	ld	a5,-56(s0)
    8000541a:	439c                	lw	a5,0(a5)
    8000541c:	fec42703          	lw	a4,-20(s0)
    80005420:	85ba                	mv	a1,a4
    80005422:	853e                	mv	a0,a5
    80005424:	fffff097          	auipc	ra,0xfffff
    80005428:	2be080e7          	jalr	702(ra) # 800046e2 <bread>
    8000542c:	fea43023          	sd	a0,-32(s0)
    a = (uint*)bp->data;
    80005430:	fe043783          	ld	a5,-32(s0)
    80005434:	05878793          	addi	a5,a5,88
    80005438:	fcf43c23          	sd	a5,-40(s0)
    if((addr = a[bn]) == 0){
    8000543c:	fc446783          	lwu	a5,-60(s0)
    80005440:	078a                	slli	a5,a5,0x2
    80005442:	fd843703          	ld	a4,-40(s0)
    80005446:	97ba                	add	a5,a5,a4
    80005448:	439c                	lw	a5,0(a5)
    8000544a:	fef42623          	sw	a5,-20(s0)
    8000544e:	fec42783          	lw	a5,-20(s0)
    80005452:	2781                	sext.w	a5,a5
    80005454:	ef9d                	bnez	a5,80005492 <bmap+0x150>
      addr = balloc(ip->dev);
    80005456:	fc843783          	ld	a5,-56(s0)
    8000545a:	439c                	lw	a5,0(a5)
    8000545c:	853e                	mv	a0,a5
    8000545e:	fffff097          	auipc	ra,0xfffff
    80005462:	5ce080e7          	jalr	1486(ra) # 80004a2c <balloc>
    80005466:	87aa                	mv	a5,a0
    80005468:	fef42623          	sw	a5,-20(s0)
      if(addr){
    8000546c:	fec42783          	lw	a5,-20(s0)
    80005470:	2781                	sext.w	a5,a5
    80005472:	c385                	beqz	a5,80005492 <bmap+0x150>
        a[bn] = addr;
    80005474:	fc446783          	lwu	a5,-60(s0)
    80005478:	078a                	slli	a5,a5,0x2
    8000547a:	fd843703          	ld	a4,-40(s0)
    8000547e:	97ba                	add	a5,a5,a4
    80005480:	fec42703          	lw	a4,-20(s0)
    80005484:	c398                	sw	a4,0(a5)
        log_write(bp);
    80005486:	fe043503          	ld	a0,-32(s0)
    8000548a:	00001097          	auipc	ra,0x1
    8000548e:	f9e080e7          	jalr	-98(ra) # 80006428 <log_write>
      }
    }
    brelse(bp);
    80005492:	fe043503          	ld	a0,-32(s0)
    80005496:	fffff097          	auipc	ra,0xfffff
    8000549a:	2ee080e7          	jalr	750(ra) # 80004784 <brelse>
    return addr;
    8000549e:	fec42783          	lw	a5,-20(s0)
    800054a2:	a809                	j	800054b4 <bmap+0x172>
  }

  panic("bmap: out of range");
    800054a4:	00006517          	auipc	a0,0x6
    800054a8:	05c50513          	addi	a0,a0,92 # 8000b500 <etext+0x500>
    800054ac:	ffffb097          	auipc	ra,0xffffb
    800054b0:	7de080e7          	jalr	2014(ra) # 80000c8a <panic>
}
    800054b4:	853e                	mv	a0,a5
    800054b6:	70e2                	ld	ra,56(sp)
    800054b8:	7442                	ld	s0,48(sp)
    800054ba:	6121                	addi	sp,sp,64
    800054bc:	8082                	ret

00000000800054be <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800054be:	7139                	addi	sp,sp,-64
    800054c0:	fc06                	sd	ra,56(sp)
    800054c2:	f822                	sd	s0,48(sp)
    800054c4:	0080                	addi	s0,sp,64
    800054c6:	fca43423          	sd	a0,-56(s0)
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800054ca:	fe042623          	sw	zero,-20(s0)
    800054ce:	a899                	j	80005524 <itrunc+0x66>
    if(ip->addrs[i]){
    800054d0:	fc843703          	ld	a4,-56(s0)
    800054d4:	fec42783          	lw	a5,-20(s0)
    800054d8:	07d1                	addi	a5,a5,20
    800054da:	078a                	slli	a5,a5,0x2
    800054dc:	97ba                	add	a5,a5,a4
    800054de:	439c                	lw	a5,0(a5)
    800054e0:	cf8d                	beqz	a5,8000551a <itrunc+0x5c>
      bfree(ip->dev, ip->addrs[i]);
    800054e2:	fc843783          	ld	a5,-56(s0)
    800054e6:	439c                	lw	a5,0(a5)
    800054e8:	0007869b          	sext.w	a3,a5
    800054ec:	fc843703          	ld	a4,-56(s0)
    800054f0:	fec42783          	lw	a5,-20(s0)
    800054f4:	07d1                	addi	a5,a5,20
    800054f6:	078a                	slli	a5,a5,0x2
    800054f8:	97ba                	add	a5,a5,a4
    800054fa:	439c                	lw	a5,0(a5)
    800054fc:	85be                	mv	a1,a5
    800054fe:	8536                	mv	a0,a3
    80005500:	fffff097          	auipc	ra,0xfffff
    80005504:	6d4080e7          	jalr	1748(ra) # 80004bd4 <bfree>
      ip->addrs[i] = 0;
    80005508:	fc843703          	ld	a4,-56(s0)
    8000550c:	fec42783          	lw	a5,-20(s0)
    80005510:	07d1                	addi	a5,a5,20
    80005512:	078a                	slli	a5,a5,0x2
    80005514:	97ba                	add	a5,a5,a4
    80005516:	0007a023          	sw	zero,0(a5)
  for(i = 0; i < NDIRECT; i++){
    8000551a:	fec42783          	lw	a5,-20(s0)
    8000551e:	2785                	addiw	a5,a5,1
    80005520:	fef42623          	sw	a5,-20(s0)
    80005524:	fec42783          	lw	a5,-20(s0)
    80005528:	0007871b          	sext.w	a4,a5
    8000552c:	47ad                	li	a5,11
    8000552e:	fae7d1e3          	bge	a5,a4,800054d0 <itrunc+0x12>
    }
  }

  if(ip->addrs[NDIRECT]){
    80005532:	fc843783          	ld	a5,-56(s0)
    80005536:	0807a783          	lw	a5,128(a5)
    8000553a:	cbc5                	beqz	a5,800055ea <itrunc+0x12c>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000553c:	fc843783          	ld	a5,-56(s0)
    80005540:	4398                	lw	a4,0(a5)
    80005542:	fc843783          	ld	a5,-56(s0)
    80005546:	0807a783          	lw	a5,128(a5)
    8000554a:	85be                	mv	a1,a5
    8000554c:	853a                	mv	a0,a4
    8000554e:	fffff097          	auipc	ra,0xfffff
    80005552:	194080e7          	jalr	404(ra) # 800046e2 <bread>
    80005556:	fea43023          	sd	a0,-32(s0)
    a = (uint*)bp->data;
    8000555a:	fe043783          	ld	a5,-32(s0)
    8000555e:	05878793          	addi	a5,a5,88
    80005562:	fcf43c23          	sd	a5,-40(s0)
    for(j = 0; j < NINDIRECT; j++){
    80005566:	fe042423          	sw	zero,-24(s0)
    8000556a:	a081                	j	800055aa <itrunc+0xec>
      if(a[j])
    8000556c:	fe842783          	lw	a5,-24(s0)
    80005570:	078a                	slli	a5,a5,0x2
    80005572:	fd843703          	ld	a4,-40(s0)
    80005576:	97ba                	add	a5,a5,a4
    80005578:	439c                	lw	a5,0(a5)
    8000557a:	c39d                	beqz	a5,800055a0 <itrunc+0xe2>
        bfree(ip->dev, a[j]);
    8000557c:	fc843783          	ld	a5,-56(s0)
    80005580:	439c                	lw	a5,0(a5)
    80005582:	0007869b          	sext.w	a3,a5
    80005586:	fe842783          	lw	a5,-24(s0)
    8000558a:	078a                	slli	a5,a5,0x2
    8000558c:	fd843703          	ld	a4,-40(s0)
    80005590:	97ba                	add	a5,a5,a4
    80005592:	439c                	lw	a5,0(a5)
    80005594:	85be                	mv	a1,a5
    80005596:	8536                	mv	a0,a3
    80005598:	fffff097          	auipc	ra,0xfffff
    8000559c:	63c080e7          	jalr	1596(ra) # 80004bd4 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    800055a0:	fe842783          	lw	a5,-24(s0)
    800055a4:	2785                	addiw	a5,a5,1
    800055a6:	fef42423          	sw	a5,-24(s0)
    800055aa:	fe842783          	lw	a5,-24(s0)
    800055ae:	873e                	mv	a4,a5
    800055b0:	0ff00793          	li	a5,255
    800055b4:	fae7fce3          	bgeu	a5,a4,8000556c <itrunc+0xae>
    }
    brelse(bp);
    800055b8:	fe043503          	ld	a0,-32(s0)
    800055bc:	fffff097          	auipc	ra,0xfffff
    800055c0:	1c8080e7          	jalr	456(ra) # 80004784 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800055c4:	fc843783          	ld	a5,-56(s0)
    800055c8:	439c                	lw	a5,0(a5)
    800055ca:	0007871b          	sext.w	a4,a5
    800055ce:	fc843783          	ld	a5,-56(s0)
    800055d2:	0807a783          	lw	a5,128(a5)
    800055d6:	85be                	mv	a1,a5
    800055d8:	853a                	mv	a0,a4
    800055da:	fffff097          	auipc	ra,0xfffff
    800055de:	5fa080e7          	jalr	1530(ra) # 80004bd4 <bfree>
    ip->addrs[NDIRECT] = 0;
    800055e2:	fc843783          	ld	a5,-56(s0)
    800055e6:	0807a023          	sw	zero,128(a5)
  }

  ip->size = 0;
    800055ea:	fc843783          	ld	a5,-56(s0)
    800055ee:	0407a623          	sw	zero,76(a5)
  iupdate(ip);
    800055f2:	fc843503          	ld	a0,-56(s0)
    800055f6:	00000097          	auipc	ra,0x0
    800055fa:	870080e7          	jalr	-1936(ra) # 80004e66 <iupdate>
}
    800055fe:	0001                	nop
    80005600:	70e2                	ld	ra,56(sp)
    80005602:	7442                	ld	s0,48(sp)
    80005604:	6121                	addi	sp,sp,64
    80005606:	8082                	ret

0000000080005608 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80005608:	1101                	addi	sp,sp,-32
    8000560a:	ec22                	sd	s0,24(sp)
    8000560c:	1000                	addi	s0,sp,32
    8000560e:	fea43423          	sd	a0,-24(s0)
    80005612:	feb43023          	sd	a1,-32(s0)
  st->dev = ip->dev;
    80005616:	fe843783          	ld	a5,-24(s0)
    8000561a:	439c                	lw	a5,0(a5)
    8000561c:	0007871b          	sext.w	a4,a5
    80005620:	fe043783          	ld	a5,-32(s0)
    80005624:	c398                	sw	a4,0(a5)
  st->ino = ip->inum;
    80005626:	fe843783          	ld	a5,-24(s0)
    8000562a:	43d8                	lw	a4,4(a5)
    8000562c:	fe043783          	ld	a5,-32(s0)
    80005630:	c3d8                	sw	a4,4(a5)
  st->type = ip->type;
    80005632:	fe843783          	ld	a5,-24(s0)
    80005636:	04479703          	lh	a4,68(a5)
    8000563a:	fe043783          	ld	a5,-32(s0)
    8000563e:	00e79423          	sh	a4,8(a5)
  st->nlink = ip->nlink;
    80005642:	fe843783          	ld	a5,-24(s0)
    80005646:	04a79703          	lh	a4,74(a5)
    8000564a:	fe043783          	ld	a5,-32(s0)
    8000564e:	00e79523          	sh	a4,10(a5)
  st->size = ip->size;
    80005652:	fe843783          	ld	a5,-24(s0)
    80005656:	47fc                	lw	a5,76(a5)
    80005658:	02079713          	slli	a4,a5,0x20
    8000565c:	9301                	srli	a4,a4,0x20
    8000565e:	fe043783          	ld	a5,-32(s0)
    80005662:	eb98                	sd	a4,16(a5)
}
    80005664:	0001                	nop
    80005666:	6462                	ld	s0,24(sp)
    80005668:	6105                	addi	sp,sp,32
    8000566a:	8082                	ret

000000008000566c <readi>:
// Caller must hold ip->lock.
// If user_dst==1, then dst is a user virtual address;
// otherwise, dst is a kernel address.
int
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
    8000566c:	715d                	addi	sp,sp,-80
    8000566e:	e486                	sd	ra,72(sp)
    80005670:	e0a2                	sd	s0,64(sp)
    80005672:	0880                	addi	s0,sp,80
    80005674:	fca43423          	sd	a0,-56(s0)
    80005678:	87ae                	mv	a5,a1
    8000567a:	fac43c23          	sd	a2,-72(s0)
    8000567e:	fcf42223          	sw	a5,-60(s0)
    80005682:	87b6                	mv	a5,a3
    80005684:	fcf42023          	sw	a5,-64(s0)
    80005688:	87ba                	mv	a5,a4
    8000568a:	faf42a23          	sw	a5,-76(s0)
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000568e:	fc843783          	ld	a5,-56(s0)
    80005692:	47f8                	lw	a4,76(a5)
    80005694:	fc042783          	lw	a5,-64(s0)
    80005698:	2781                	sext.w	a5,a5
    8000569a:	00f76f63          	bltu	a4,a5,800056b8 <readi+0x4c>
    8000569e:	fc042783          	lw	a5,-64(s0)
    800056a2:	873e                	mv	a4,a5
    800056a4:	fb442783          	lw	a5,-76(s0)
    800056a8:	9fb9                	addw	a5,a5,a4
    800056aa:	0007871b          	sext.w	a4,a5
    800056ae:	fc042783          	lw	a5,-64(s0)
    800056b2:	2781                	sext.w	a5,a5
    800056b4:	00f77463          	bgeu	a4,a5,800056bc <readi+0x50>
    return 0;
    800056b8:	4781                	li	a5,0
    800056ba:	a299                	j	80005800 <readi+0x194>
  if(off + n > ip->size)
    800056bc:	fc042783          	lw	a5,-64(s0)
    800056c0:	873e                	mv	a4,a5
    800056c2:	fb442783          	lw	a5,-76(s0)
    800056c6:	9fb9                	addw	a5,a5,a4
    800056c8:	0007871b          	sext.w	a4,a5
    800056cc:	fc843783          	ld	a5,-56(s0)
    800056d0:	47fc                	lw	a5,76(a5)
    800056d2:	00e7fa63          	bgeu	a5,a4,800056e6 <readi+0x7a>
    n = ip->size - off;
    800056d6:	fc843783          	ld	a5,-56(s0)
    800056da:	47fc                	lw	a5,76(a5)
    800056dc:	fc042703          	lw	a4,-64(s0)
    800056e0:	9f99                	subw	a5,a5,a4
    800056e2:	faf42a23          	sw	a5,-76(s0)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800056e6:	fe042623          	sw	zero,-20(s0)
    800056ea:	a8f5                	j	800057e6 <readi+0x17a>
    uint addr = bmap(ip, off/BSIZE);
    800056ec:	fc042783          	lw	a5,-64(s0)
    800056f0:	00a7d79b          	srliw	a5,a5,0xa
    800056f4:	2781                	sext.w	a5,a5
    800056f6:	85be                	mv	a1,a5
    800056f8:	fc843503          	ld	a0,-56(s0)
    800056fc:	00000097          	auipc	ra,0x0
    80005700:	c46080e7          	jalr	-954(ra) # 80005342 <bmap>
    80005704:	87aa                	mv	a5,a0
    80005706:	fef42423          	sw	a5,-24(s0)
    if(addr == 0)
    8000570a:	fe842783          	lw	a5,-24(s0)
    8000570e:	2781                	sext.w	a5,a5
    80005710:	c7ed                	beqz	a5,800057fa <readi+0x18e>
      break;
    bp = bread(ip->dev, addr);
    80005712:	fc843783          	ld	a5,-56(s0)
    80005716:	439c                	lw	a5,0(a5)
    80005718:	fe842703          	lw	a4,-24(s0)
    8000571c:	85ba                	mv	a1,a4
    8000571e:	853e                	mv	a0,a5
    80005720:	fffff097          	auipc	ra,0xfffff
    80005724:	fc2080e7          	jalr	-62(ra) # 800046e2 <bread>
    80005728:	fea43023          	sd	a0,-32(s0)
    m = min(n - tot, BSIZE - off%BSIZE);
    8000572c:	fc042783          	lw	a5,-64(s0)
    80005730:	3ff7f793          	andi	a5,a5,1023
    80005734:	2781                	sext.w	a5,a5
    80005736:	40000713          	li	a4,1024
    8000573a:	40f707bb          	subw	a5,a4,a5
    8000573e:	2781                	sext.w	a5,a5
    80005740:	fb442703          	lw	a4,-76(s0)
    80005744:	86ba                	mv	a3,a4
    80005746:	fec42703          	lw	a4,-20(s0)
    8000574a:	40e6873b          	subw	a4,a3,a4
    8000574e:	2701                	sext.w	a4,a4
    80005750:	863a                	mv	a2,a4
    80005752:	0007869b          	sext.w	a3,a5
    80005756:	0006071b          	sext.w	a4,a2
    8000575a:	00d77363          	bgeu	a4,a3,80005760 <readi+0xf4>
    8000575e:	87b2                	mv	a5,a2
    80005760:	fcf42e23          	sw	a5,-36(s0)
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80005764:	fe043783          	ld	a5,-32(s0)
    80005768:	05878713          	addi	a4,a5,88
    8000576c:	fc046783          	lwu	a5,-64(s0)
    80005770:	3ff7f793          	andi	a5,a5,1023
    80005774:	973e                	add	a4,a4,a5
    80005776:	fdc46683          	lwu	a3,-36(s0)
    8000577a:	fc442783          	lw	a5,-60(s0)
    8000577e:	863a                	mv	a2,a4
    80005780:	fb843583          	ld	a1,-72(s0)
    80005784:	853e                	mv	a0,a5
    80005786:	ffffe097          	auipc	ra,0xffffe
    8000578a:	eac080e7          	jalr	-340(ra) # 80003632 <either_copyout>
    8000578e:	87aa                	mv	a5,a0
    80005790:	873e                	mv	a4,a5
    80005792:	57fd                	li	a5,-1
    80005794:	00f71c63          	bne	a4,a5,800057ac <readi+0x140>
      brelse(bp);
    80005798:	fe043503          	ld	a0,-32(s0)
    8000579c:	fffff097          	auipc	ra,0xfffff
    800057a0:	fe8080e7          	jalr	-24(ra) # 80004784 <brelse>
      tot = -1;
    800057a4:	57fd                	li	a5,-1
    800057a6:	fef42623          	sw	a5,-20(s0)
      break;
    800057aa:	a889                	j	800057fc <readi+0x190>
    }
    brelse(bp);
    800057ac:	fe043503          	ld	a0,-32(s0)
    800057b0:	fffff097          	auipc	ra,0xfffff
    800057b4:	fd4080e7          	jalr	-44(ra) # 80004784 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800057b8:	fec42783          	lw	a5,-20(s0)
    800057bc:	873e                	mv	a4,a5
    800057be:	fdc42783          	lw	a5,-36(s0)
    800057c2:	9fb9                	addw	a5,a5,a4
    800057c4:	fef42623          	sw	a5,-20(s0)
    800057c8:	fc042783          	lw	a5,-64(s0)
    800057cc:	873e                	mv	a4,a5
    800057ce:	fdc42783          	lw	a5,-36(s0)
    800057d2:	9fb9                	addw	a5,a5,a4
    800057d4:	fcf42023          	sw	a5,-64(s0)
    800057d8:	fdc46783          	lwu	a5,-36(s0)
    800057dc:	fb843703          	ld	a4,-72(s0)
    800057e0:	97ba                	add	a5,a5,a4
    800057e2:	faf43c23          	sd	a5,-72(s0)
    800057e6:	fec42783          	lw	a5,-20(s0)
    800057ea:	873e                	mv	a4,a5
    800057ec:	fb442783          	lw	a5,-76(s0)
    800057f0:	2701                	sext.w	a4,a4
    800057f2:	2781                	sext.w	a5,a5
    800057f4:	eef76ce3          	bltu	a4,a5,800056ec <readi+0x80>
    800057f8:	a011                	j	800057fc <readi+0x190>
      break;
    800057fa:	0001                	nop
  }
  return tot;
    800057fc:	fec42783          	lw	a5,-20(s0)
}
    80005800:	853e                	mv	a0,a5
    80005802:	60a6                	ld	ra,72(sp)
    80005804:	6406                	ld	s0,64(sp)
    80005806:	6161                	addi	sp,sp,80
    80005808:	8082                	ret

000000008000580a <writei>:
// Returns the number of bytes successfully written.
// If the return value is less than the requested n,
// there was an error of some kind.
int
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
    8000580a:	715d                	addi	sp,sp,-80
    8000580c:	e486                	sd	ra,72(sp)
    8000580e:	e0a2                	sd	s0,64(sp)
    80005810:	0880                	addi	s0,sp,80
    80005812:	fca43423          	sd	a0,-56(s0)
    80005816:	87ae                	mv	a5,a1
    80005818:	fac43c23          	sd	a2,-72(s0)
    8000581c:	fcf42223          	sw	a5,-60(s0)
    80005820:	87b6                	mv	a5,a3
    80005822:	fcf42023          	sw	a5,-64(s0)
    80005826:	87ba                	mv	a5,a4
    80005828:	faf42a23          	sw	a5,-76(s0)
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000582c:	fc843783          	ld	a5,-56(s0)
    80005830:	47f8                	lw	a4,76(a5)
    80005832:	fc042783          	lw	a5,-64(s0)
    80005836:	2781                	sext.w	a5,a5
    80005838:	00f76f63          	bltu	a4,a5,80005856 <writei+0x4c>
    8000583c:	fc042783          	lw	a5,-64(s0)
    80005840:	873e                	mv	a4,a5
    80005842:	fb442783          	lw	a5,-76(s0)
    80005846:	9fb9                	addw	a5,a5,a4
    80005848:	0007871b          	sext.w	a4,a5
    8000584c:	fc042783          	lw	a5,-64(s0)
    80005850:	2781                	sext.w	a5,a5
    80005852:	00f77463          	bgeu	a4,a5,8000585a <writei+0x50>
    return -1;
    80005856:	57fd                	li	a5,-1
    80005858:	a295                	j	800059bc <writei+0x1b2>
  if(off + n > MAXFILE*BSIZE)
    8000585a:	fc042783          	lw	a5,-64(s0)
    8000585e:	873e                	mv	a4,a5
    80005860:	fb442783          	lw	a5,-76(s0)
    80005864:	9fb9                	addw	a5,a5,a4
    80005866:	2781                	sext.w	a5,a5
    80005868:	873e                	mv	a4,a5
    8000586a:	000437b7          	lui	a5,0x43
    8000586e:	00e7f463          	bgeu	a5,a4,80005876 <writei+0x6c>
    return -1;
    80005872:	57fd                	li	a5,-1
    80005874:	a2a1                	j	800059bc <writei+0x1b2>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80005876:	fe042623          	sw	zero,-20(s0)
    8000587a:	a209                	j	8000597c <writei+0x172>
    uint addr = bmap(ip, off/BSIZE);
    8000587c:	fc042783          	lw	a5,-64(s0)
    80005880:	00a7d79b          	srliw	a5,a5,0xa
    80005884:	2781                	sext.w	a5,a5
    80005886:	85be                	mv	a1,a5
    80005888:	fc843503          	ld	a0,-56(s0)
    8000588c:	00000097          	auipc	ra,0x0
    80005890:	ab6080e7          	jalr	-1354(ra) # 80005342 <bmap>
    80005894:	87aa                	mv	a5,a0
    80005896:	fef42423          	sw	a5,-24(s0)
    if(addr == 0)
    8000589a:	fe842783          	lw	a5,-24(s0)
    8000589e:	2781                	sext.w	a5,a5
    800058a0:	cbe5                	beqz	a5,80005990 <writei+0x186>
      break;
    bp = bread(ip->dev, addr);
    800058a2:	fc843783          	ld	a5,-56(s0)
    800058a6:	439c                	lw	a5,0(a5)
    800058a8:	fe842703          	lw	a4,-24(s0)
    800058ac:	85ba                	mv	a1,a4
    800058ae:	853e                	mv	a0,a5
    800058b0:	fffff097          	auipc	ra,0xfffff
    800058b4:	e32080e7          	jalr	-462(ra) # 800046e2 <bread>
    800058b8:	fea43023          	sd	a0,-32(s0)
    m = min(n - tot, BSIZE - off%BSIZE);
    800058bc:	fc042783          	lw	a5,-64(s0)
    800058c0:	3ff7f793          	andi	a5,a5,1023
    800058c4:	2781                	sext.w	a5,a5
    800058c6:	40000713          	li	a4,1024
    800058ca:	40f707bb          	subw	a5,a4,a5
    800058ce:	2781                	sext.w	a5,a5
    800058d0:	fb442703          	lw	a4,-76(s0)
    800058d4:	86ba                	mv	a3,a4
    800058d6:	fec42703          	lw	a4,-20(s0)
    800058da:	40e6873b          	subw	a4,a3,a4
    800058de:	2701                	sext.w	a4,a4
    800058e0:	863a                	mv	a2,a4
    800058e2:	0007869b          	sext.w	a3,a5
    800058e6:	0006071b          	sext.w	a4,a2
    800058ea:	00d77363          	bgeu	a4,a3,800058f0 <writei+0xe6>
    800058ee:	87b2                	mv	a5,a2
    800058f0:	fcf42e23          	sw	a5,-36(s0)
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800058f4:	fe043783          	ld	a5,-32(s0)
    800058f8:	05878713          	addi	a4,a5,88 # 43058 <_entry-0x7ffbcfa8>
    800058fc:	fc046783          	lwu	a5,-64(s0)
    80005900:	3ff7f793          	andi	a5,a5,1023
    80005904:	97ba                	add	a5,a5,a4
    80005906:	fdc46683          	lwu	a3,-36(s0)
    8000590a:	fc442703          	lw	a4,-60(s0)
    8000590e:	fb843603          	ld	a2,-72(s0)
    80005912:	85ba                	mv	a1,a4
    80005914:	853e                	mv	a0,a5
    80005916:	ffffe097          	auipc	ra,0xffffe
    8000591a:	d90080e7          	jalr	-624(ra) # 800036a6 <either_copyin>
    8000591e:	87aa                	mv	a5,a0
    80005920:	873e                	mv	a4,a5
    80005922:	57fd                	li	a5,-1
    80005924:	00f71963          	bne	a4,a5,80005936 <writei+0x12c>
      brelse(bp);
    80005928:	fe043503          	ld	a0,-32(s0)
    8000592c:	fffff097          	auipc	ra,0xfffff
    80005930:	e58080e7          	jalr	-424(ra) # 80004784 <brelse>
      break;
    80005934:	a8b9                	j	80005992 <writei+0x188>
    }
    log_write(bp);
    80005936:	fe043503          	ld	a0,-32(s0)
    8000593a:	00001097          	auipc	ra,0x1
    8000593e:	aee080e7          	jalr	-1298(ra) # 80006428 <log_write>
    brelse(bp);
    80005942:	fe043503          	ld	a0,-32(s0)
    80005946:	fffff097          	auipc	ra,0xfffff
    8000594a:	e3e080e7          	jalr	-450(ra) # 80004784 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000594e:	fec42783          	lw	a5,-20(s0)
    80005952:	873e                	mv	a4,a5
    80005954:	fdc42783          	lw	a5,-36(s0)
    80005958:	9fb9                	addw	a5,a5,a4
    8000595a:	fef42623          	sw	a5,-20(s0)
    8000595e:	fc042783          	lw	a5,-64(s0)
    80005962:	873e                	mv	a4,a5
    80005964:	fdc42783          	lw	a5,-36(s0)
    80005968:	9fb9                	addw	a5,a5,a4
    8000596a:	fcf42023          	sw	a5,-64(s0)
    8000596e:	fdc46783          	lwu	a5,-36(s0)
    80005972:	fb843703          	ld	a4,-72(s0)
    80005976:	97ba                	add	a5,a5,a4
    80005978:	faf43c23          	sd	a5,-72(s0)
    8000597c:	fec42783          	lw	a5,-20(s0)
    80005980:	873e                	mv	a4,a5
    80005982:	fb442783          	lw	a5,-76(s0)
    80005986:	2701                	sext.w	a4,a4
    80005988:	2781                	sext.w	a5,a5
    8000598a:	eef769e3          	bltu	a4,a5,8000587c <writei+0x72>
    8000598e:	a011                	j	80005992 <writei+0x188>
      break;
    80005990:	0001                	nop
  }

  if(off > ip->size)
    80005992:	fc843783          	ld	a5,-56(s0)
    80005996:	47f8                	lw	a4,76(a5)
    80005998:	fc042783          	lw	a5,-64(s0)
    8000599c:	2781                	sext.w	a5,a5
    8000599e:	00f77763          	bgeu	a4,a5,800059ac <writei+0x1a2>
    ip->size = off;
    800059a2:	fc843783          	ld	a5,-56(s0)
    800059a6:	fc042703          	lw	a4,-64(s0)
    800059aa:	c7f8                	sw	a4,76(a5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800059ac:	fc843503          	ld	a0,-56(s0)
    800059b0:	fffff097          	auipc	ra,0xfffff
    800059b4:	4b6080e7          	jalr	1206(ra) # 80004e66 <iupdate>

  return tot;
    800059b8:	fec42783          	lw	a5,-20(s0)
}
    800059bc:	853e                	mv	a0,a5
    800059be:	60a6                	ld	ra,72(sp)
    800059c0:	6406                	ld	s0,64(sp)
    800059c2:	6161                	addi	sp,sp,80
    800059c4:	8082                	ret

00000000800059c6 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800059c6:	1101                	addi	sp,sp,-32
    800059c8:	ec06                	sd	ra,24(sp)
    800059ca:	e822                	sd	s0,16(sp)
    800059cc:	1000                	addi	s0,sp,32
    800059ce:	fea43423          	sd	a0,-24(s0)
    800059d2:	feb43023          	sd	a1,-32(s0)
  return strncmp(s, t, DIRSIZ);
    800059d6:	4639                	li	a2,14
    800059d8:	fe043583          	ld	a1,-32(s0)
    800059dc:	fe843503          	ld	a0,-24(s0)
    800059e0:	ffffc097          	auipc	ra,0xffffc
    800059e4:	c6a080e7          	jalr	-918(ra) # 8000164a <strncmp>
    800059e8:	87aa                	mv	a5,a0
}
    800059ea:	853e                	mv	a0,a5
    800059ec:	60e2                	ld	ra,24(sp)
    800059ee:	6442                	ld	s0,16(sp)
    800059f0:	6105                	addi	sp,sp,32
    800059f2:	8082                	ret

00000000800059f4 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800059f4:	715d                	addi	sp,sp,-80
    800059f6:	e486                	sd	ra,72(sp)
    800059f8:	e0a2                	sd	s0,64(sp)
    800059fa:	0880                	addi	s0,sp,80
    800059fc:	fca43423          	sd	a0,-56(s0)
    80005a00:	fcb43023          	sd	a1,-64(s0)
    80005a04:	fac43c23          	sd	a2,-72(s0)
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80005a08:	fc843783          	ld	a5,-56(s0)
    80005a0c:	04479783          	lh	a5,68(a5)
    80005a10:	873e                	mv	a4,a5
    80005a12:	4785                	li	a5,1
    80005a14:	00f70a63          	beq	a4,a5,80005a28 <dirlookup+0x34>
    panic("dirlookup not DIR");
    80005a18:	00006517          	auipc	a0,0x6
    80005a1c:	b0050513          	addi	a0,a0,-1280 # 8000b518 <etext+0x518>
    80005a20:	ffffb097          	auipc	ra,0xffffb
    80005a24:	26a080e7          	jalr	618(ra) # 80000c8a <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
    80005a28:	fe042623          	sw	zero,-20(s0)
    80005a2c:	a849                	j	80005abe <dirlookup+0xca>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005a2e:	fd840793          	addi	a5,s0,-40
    80005a32:	fec42683          	lw	a3,-20(s0)
    80005a36:	4741                	li	a4,16
    80005a38:	863e                	mv	a2,a5
    80005a3a:	4581                	li	a1,0
    80005a3c:	fc843503          	ld	a0,-56(s0)
    80005a40:	00000097          	auipc	ra,0x0
    80005a44:	c2c080e7          	jalr	-980(ra) # 8000566c <readi>
    80005a48:	87aa                	mv	a5,a0
    80005a4a:	873e                	mv	a4,a5
    80005a4c:	47c1                	li	a5,16
    80005a4e:	00f70a63          	beq	a4,a5,80005a62 <dirlookup+0x6e>
      panic("dirlookup read");
    80005a52:	00006517          	auipc	a0,0x6
    80005a56:	ade50513          	addi	a0,a0,-1314 # 8000b530 <etext+0x530>
    80005a5a:	ffffb097          	auipc	ra,0xffffb
    80005a5e:	230080e7          	jalr	560(ra) # 80000c8a <panic>
    if(de.inum == 0)
    80005a62:	fd845783          	lhu	a5,-40(s0)
    80005a66:	c7b1                	beqz	a5,80005ab2 <dirlookup+0xbe>
      continue;
    if(namecmp(name, de.name) == 0){
    80005a68:	fd840793          	addi	a5,s0,-40
    80005a6c:	0789                	addi	a5,a5,2
    80005a6e:	85be                	mv	a1,a5
    80005a70:	fc043503          	ld	a0,-64(s0)
    80005a74:	00000097          	auipc	ra,0x0
    80005a78:	f52080e7          	jalr	-174(ra) # 800059c6 <namecmp>
    80005a7c:	87aa                	mv	a5,a0
    80005a7e:	eb9d                	bnez	a5,80005ab4 <dirlookup+0xc0>
      // entry matches path element
      if(poff)
    80005a80:	fb843783          	ld	a5,-72(s0)
    80005a84:	c791                	beqz	a5,80005a90 <dirlookup+0x9c>
        *poff = off;
    80005a86:	fb843783          	ld	a5,-72(s0)
    80005a8a:	fec42703          	lw	a4,-20(s0)
    80005a8e:	c398                	sw	a4,0(a5)
      inum = de.inum;
    80005a90:	fd845783          	lhu	a5,-40(s0)
    80005a94:	fef42423          	sw	a5,-24(s0)
      return iget(dp->dev, inum);
    80005a98:	fc843783          	ld	a5,-56(s0)
    80005a9c:	439c                	lw	a5,0(a5)
    80005a9e:	fe842703          	lw	a4,-24(s0)
    80005aa2:	85ba                	mv	a1,a4
    80005aa4:	853e                	mv	a0,a5
    80005aa6:	fffff097          	auipc	ra,0xfffff
    80005aaa:	4a8080e7          	jalr	1192(ra) # 80004f4e <iget>
    80005aae:	87aa                	mv	a5,a0
    80005ab0:	a005                	j	80005ad0 <dirlookup+0xdc>
      continue;
    80005ab2:	0001                	nop
  for(off = 0; off < dp->size; off += sizeof(de)){
    80005ab4:	fec42783          	lw	a5,-20(s0)
    80005ab8:	27c1                	addiw	a5,a5,16
    80005aba:	fef42623          	sw	a5,-20(s0)
    80005abe:	fc843783          	ld	a5,-56(s0)
    80005ac2:	47f8                	lw	a4,76(a5)
    80005ac4:	fec42783          	lw	a5,-20(s0)
    80005ac8:	2781                	sext.w	a5,a5
    80005aca:	f6e7e2e3          	bltu	a5,a4,80005a2e <dirlookup+0x3a>
    }
  }

  return 0;
    80005ace:	4781                	li	a5,0
}
    80005ad0:	853e                	mv	a0,a5
    80005ad2:	60a6                	ld	ra,72(sp)
    80005ad4:	6406                	ld	s0,64(sp)
    80005ad6:	6161                	addi	sp,sp,80
    80005ad8:	8082                	ret

0000000080005ada <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
// Returns 0 on success, -1 on failure (e.g. out of disk blocks).
int
dirlink(struct inode *dp, char *name, uint inum)
{
    80005ada:	715d                	addi	sp,sp,-80
    80005adc:	e486                	sd	ra,72(sp)
    80005ade:	e0a2                	sd	s0,64(sp)
    80005ae0:	0880                	addi	s0,sp,80
    80005ae2:	fca43423          	sd	a0,-56(s0)
    80005ae6:	fcb43023          	sd	a1,-64(s0)
    80005aea:	87b2                	mv	a5,a2
    80005aec:	faf42e23          	sw	a5,-68(s0)
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    80005af0:	4601                	li	a2,0
    80005af2:	fc043583          	ld	a1,-64(s0)
    80005af6:	fc843503          	ld	a0,-56(s0)
    80005afa:	00000097          	auipc	ra,0x0
    80005afe:	efa080e7          	jalr	-262(ra) # 800059f4 <dirlookup>
    80005b02:	fea43023          	sd	a0,-32(s0)
    80005b06:	fe043783          	ld	a5,-32(s0)
    80005b0a:	cb89                	beqz	a5,80005b1c <dirlink+0x42>
    iput(ip);
    80005b0c:	fe043503          	ld	a0,-32(s0)
    80005b10:	fffff097          	auipc	ra,0xfffff
    80005b14:	734080e7          	jalr	1844(ra) # 80005244 <iput>
    return -1;
    80005b18:	57fd                	li	a5,-1
    80005b1a:	a075                	j	80005bc6 <dirlink+0xec>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    80005b1c:	fe042623          	sw	zero,-20(s0)
    80005b20:	a0a1                	j	80005b68 <dirlink+0x8e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005b22:	fd040793          	addi	a5,s0,-48
    80005b26:	fec42683          	lw	a3,-20(s0)
    80005b2a:	4741                	li	a4,16
    80005b2c:	863e                	mv	a2,a5
    80005b2e:	4581                	li	a1,0
    80005b30:	fc843503          	ld	a0,-56(s0)
    80005b34:	00000097          	auipc	ra,0x0
    80005b38:	b38080e7          	jalr	-1224(ra) # 8000566c <readi>
    80005b3c:	87aa                	mv	a5,a0
    80005b3e:	873e                	mv	a4,a5
    80005b40:	47c1                	li	a5,16
    80005b42:	00f70a63          	beq	a4,a5,80005b56 <dirlink+0x7c>
      panic("dirlink read");
    80005b46:	00006517          	auipc	a0,0x6
    80005b4a:	9fa50513          	addi	a0,a0,-1542 # 8000b540 <etext+0x540>
    80005b4e:	ffffb097          	auipc	ra,0xffffb
    80005b52:	13c080e7          	jalr	316(ra) # 80000c8a <panic>
    if(de.inum == 0)
    80005b56:	fd045783          	lhu	a5,-48(s0)
    80005b5a:	cf99                	beqz	a5,80005b78 <dirlink+0x9e>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80005b5c:	fec42783          	lw	a5,-20(s0)
    80005b60:	27c1                	addiw	a5,a5,16
    80005b62:	2781                	sext.w	a5,a5
    80005b64:	fef42623          	sw	a5,-20(s0)
    80005b68:	fc843783          	ld	a5,-56(s0)
    80005b6c:	47f8                	lw	a4,76(a5)
    80005b6e:	fec42783          	lw	a5,-20(s0)
    80005b72:	fae7e8e3          	bltu	a5,a4,80005b22 <dirlink+0x48>
    80005b76:	a011                	j	80005b7a <dirlink+0xa0>
      break;
    80005b78:	0001                	nop
  }

  strncpy(de.name, name, DIRSIZ);
    80005b7a:	fd040793          	addi	a5,s0,-48
    80005b7e:	0789                	addi	a5,a5,2
    80005b80:	4639                	li	a2,14
    80005b82:	fc043583          	ld	a1,-64(s0)
    80005b86:	853e                	mv	a0,a5
    80005b88:	ffffc097          	auipc	ra,0xffffc
    80005b8c:	b4c080e7          	jalr	-1204(ra) # 800016d4 <strncpy>
  de.inum = inum;
    80005b90:	fbc42783          	lw	a5,-68(s0)
    80005b94:	17c2                	slli	a5,a5,0x30
    80005b96:	93c1                	srli	a5,a5,0x30
    80005b98:	fcf41823          	sh	a5,-48(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005b9c:	fd040793          	addi	a5,s0,-48
    80005ba0:	fec42683          	lw	a3,-20(s0)
    80005ba4:	4741                	li	a4,16
    80005ba6:	863e                	mv	a2,a5
    80005ba8:	4581                	li	a1,0
    80005baa:	fc843503          	ld	a0,-56(s0)
    80005bae:	00000097          	auipc	ra,0x0
    80005bb2:	c5c080e7          	jalr	-932(ra) # 8000580a <writei>
    80005bb6:	87aa                	mv	a5,a0
    80005bb8:	873e                	mv	a4,a5
    80005bba:	47c1                	li	a5,16
    80005bbc:	00f70463          	beq	a4,a5,80005bc4 <dirlink+0xea>
    return -1;
    80005bc0:	57fd                	li	a5,-1
    80005bc2:	a011                	j	80005bc6 <dirlink+0xec>

  return 0;
    80005bc4:	4781                	li	a5,0
}
    80005bc6:	853e                	mv	a0,a5
    80005bc8:	60a6                	ld	ra,72(sp)
    80005bca:	6406                	ld	s0,64(sp)
    80005bcc:	6161                	addi	sp,sp,80
    80005bce:	8082                	ret

0000000080005bd0 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
    80005bd0:	7179                	addi	sp,sp,-48
    80005bd2:	f406                	sd	ra,40(sp)
    80005bd4:	f022                	sd	s0,32(sp)
    80005bd6:	1800                	addi	s0,sp,48
    80005bd8:	fca43c23          	sd	a0,-40(s0)
    80005bdc:	fcb43823          	sd	a1,-48(s0)
  char *s;
  int len;

  while(*path == '/')
    80005be0:	a031                	j	80005bec <skipelem+0x1c>
    path++;
    80005be2:	fd843783          	ld	a5,-40(s0)
    80005be6:	0785                	addi	a5,a5,1
    80005be8:	fcf43c23          	sd	a5,-40(s0)
  while(*path == '/')
    80005bec:	fd843783          	ld	a5,-40(s0)
    80005bf0:	0007c783          	lbu	a5,0(a5)
    80005bf4:	873e                	mv	a4,a5
    80005bf6:	02f00793          	li	a5,47
    80005bfa:	fef704e3          	beq	a4,a5,80005be2 <skipelem+0x12>
  if(*path == 0)
    80005bfe:	fd843783          	ld	a5,-40(s0)
    80005c02:	0007c783          	lbu	a5,0(a5)
    80005c06:	e399                	bnez	a5,80005c0c <skipelem+0x3c>
    return 0;
    80005c08:	4781                	li	a5,0
    80005c0a:	a06d                	j	80005cb4 <skipelem+0xe4>
  s = path;
    80005c0c:	fd843783          	ld	a5,-40(s0)
    80005c10:	fef43423          	sd	a5,-24(s0)
  while(*path != '/' && *path != 0)
    80005c14:	a031                	j	80005c20 <skipelem+0x50>
    path++;
    80005c16:	fd843783          	ld	a5,-40(s0)
    80005c1a:	0785                	addi	a5,a5,1
    80005c1c:	fcf43c23          	sd	a5,-40(s0)
  while(*path != '/' && *path != 0)
    80005c20:	fd843783          	ld	a5,-40(s0)
    80005c24:	0007c783          	lbu	a5,0(a5)
    80005c28:	873e                	mv	a4,a5
    80005c2a:	02f00793          	li	a5,47
    80005c2e:	00f70763          	beq	a4,a5,80005c3c <skipelem+0x6c>
    80005c32:	fd843783          	ld	a5,-40(s0)
    80005c36:	0007c783          	lbu	a5,0(a5)
    80005c3a:	fff1                	bnez	a5,80005c16 <skipelem+0x46>
  len = path - s;
    80005c3c:	fd843703          	ld	a4,-40(s0)
    80005c40:	fe843783          	ld	a5,-24(s0)
    80005c44:	40f707b3          	sub	a5,a4,a5
    80005c48:	fef42223          	sw	a5,-28(s0)
  if(len >= DIRSIZ)
    80005c4c:	fe442783          	lw	a5,-28(s0)
    80005c50:	0007871b          	sext.w	a4,a5
    80005c54:	47b5                	li	a5,13
    80005c56:	00e7dc63          	bge	a5,a4,80005c6e <skipelem+0x9e>
    memmove(name, s, DIRSIZ);
    80005c5a:	4639                	li	a2,14
    80005c5c:	fe843583          	ld	a1,-24(s0)
    80005c60:	fd043503          	ld	a0,-48(s0)
    80005c64:	ffffc097          	auipc	ra,0xffffc
    80005c68:	8d2080e7          	jalr	-1838(ra) # 80001536 <memmove>
    80005c6c:	a80d                	j	80005c9e <skipelem+0xce>
  else {
    memmove(name, s, len);
    80005c6e:	fe442783          	lw	a5,-28(s0)
    80005c72:	863e                	mv	a2,a5
    80005c74:	fe843583          	ld	a1,-24(s0)
    80005c78:	fd043503          	ld	a0,-48(s0)
    80005c7c:	ffffc097          	auipc	ra,0xffffc
    80005c80:	8ba080e7          	jalr	-1862(ra) # 80001536 <memmove>
    name[len] = 0;
    80005c84:	fe442783          	lw	a5,-28(s0)
    80005c88:	fd043703          	ld	a4,-48(s0)
    80005c8c:	97ba                	add	a5,a5,a4
    80005c8e:	00078023          	sb	zero,0(a5)
  }
  while(*path == '/')
    80005c92:	a031                	j	80005c9e <skipelem+0xce>
    path++;
    80005c94:	fd843783          	ld	a5,-40(s0)
    80005c98:	0785                	addi	a5,a5,1
    80005c9a:	fcf43c23          	sd	a5,-40(s0)
  while(*path == '/')
    80005c9e:	fd843783          	ld	a5,-40(s0)
    80005ca2:	0007c783          	lbu	a5,0(a5)
    80005ca6:	873e                	mv	a4,a5
    80005ca8:	02f00793          	li	a5,47
    80005cac:	fef704e3          	beq	a4,a5,80005c94 <skipelem+0xc4>
  return path;
    80005cb0:	fd843783          	ld	a5,-40(s0)
}
    80005cb4:	853e                	mv	a0,a5
    80005cb6:	70a2                	ld	ra,40(sp)
    80005cb8:	7402                	ld	s0,32(sp)
    80005cba:	6145                	addi	sp,sp,48
    80005cbc:	8082                	ret

0000000080005cbe <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80005cbe:	7139                	addi	sp,sp,-64
    80005cc0:	fc06                	sd	ra,56(sp)
    80005cc2:	f822                	sd	s0,48(sp)
    80005cc4:	0080                	addi	s0,sp,64
    80005cc6:	fca43c23          	sd	a0,-40(s0)
    80005cca:	87ae                	mv	a5,a1
    80005ccc:	fcc43423          	sd	a2,-56(s0)
    80005cd0:	fcf42a23          	sw	a5,-44(s0)
  struct inode *ip, *next;

  if(*path == '/')
    80005cd4:	fd843783          	ld	a5,-40(s0)
    80005cd8:	0007c783          	lbu	a5,0(a5)
    80005cdc:	873e                	mv	a4,a5
    80005cde:	02f00793          	li	a5,47
    80005ce2:	00f71b63          	bne	a4,a5,80005cf8 <namex+0x3a>
    ip = iget(ROOTDEV, ROOTINO);
    80005ce6:	4585                	li	a1,1
    80005ce8:	4505                	li	a0,1
    80005cea:	fffff097          	auipc	ra,0xfffff
    80005cee:	264080e7          	jalr	612(ra) # 80004f4e <iget>
    80005cf2:	fea43423          	sd	a0,-24(s0)
    80005cf6:	a845                	j	80005da6 <namex+0xe8>
  else
    ip = idup(myproc()->cwd);
    80005cf8:	ffffd097          	auipc	ra,0xffffd
    80005cfc:	b4e080e7          	jalr	-1202(ra) # 80002846 <myproc>
    80005d00:	87aa                	mv	a5,a0
    80005d02:	1507b783          	ld	a5,336(a5)
    80005d06:	853e                	mv	a0,a5
    80005d08:	fffff097          	auipc	ra,0xfffff
    80005d0c:	362080e7          	jalr	866(ra) # 8000506a <idup>
    80005d10:	fea43423          	sd	a0,-24(s0)

  while((path = skipelem(path, name)) != 0){
    80005d14:	a849                	j	80005da6 <namex+0xe8>
    ilock(ip);
    80005d16:	fe843503          	ld	a0,-24(s0)
    80005d1a:	fffff097          	auipc	ra,0xfffff
    80005d1e:	39c080e7          	jalr	924(ra) # 800050b6 <ilock>
    if(ip->type != T_DIR){
    80005d22:	fe843783          	ld	a5,-24(s0)
    80005d26:	04479783          	lh	a5,68(a5)
    80005d2a:	873e                	mv	a4,a5
    80005d2c:	4785                	li	a5,1
    80005d2e:	00f70a63          	beq	a4,a5,80005d42 <namex+0x84>
      iunlockput(ip);
    80005d32:	fe843503          	ld	a0,-24(s0)
    80005d36:	fffff097          	auipc	ra,0xfffff
    80005d3a:	5de080e7          	jalr	1502(ra) # 80005314 <iunlockput>
      return 0;
    80005d3e:	4781                	li	a5,0
    80005d40:	a871                	j	80005ddc <namex+0x11e>
    }
    if(nameiparent && *path == '\0'){
    80005d42:	fd442783          	lw	a5,-44(s0)
    80005d46:	2781                	sext.w	a5,a5
    80005d48:	cf99                	beqz	a5,80005d66 <namex+0xa8>
    80005d4a:	fd843783          	ld	a5,-40(s0)
    80005d4e:	0007c783          	lbu	a5,0(a5)
    80005d52:	eb91                	bnez	a5,80005d66 <namex+0xa8>
      // Stop one level early.
      iunlock(ip);
    80005d54:	fe843503          	ld	a0,-24(s0)
    80005d58:	fffff097          	auipc	ra,0xfffff
    80005d5c:	492080e7          	jalr	1170(ra) # 800051ea <iunlock>
      return ip;
    80005d60:	fe843783          	ld	a5,-24(s0)
    80005d64:	a8a5                	j	80005ddc <namex+0x11e>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
    80005d66:	4601                	li	a2,0
    80005d68:	fc843583          	ld	a1,-56(s0)
    80005d6c:	fe843503          	ld	a0,-24(s0)
    80005d70:	00000097          	auipc	ra,0x0
    80005d74:	c84080e7          	jalr	-892(ra) # 800059f4 <dirlookup>
    80005d78:	fea43023          	sd	a0,-32(s0)
    80005d7c:	fe043783          	ld	a5,-32(s0)
    80005d80:	eb89                	bnez	a5,80005d92 <namex+0xd4>
      iunlockput(ip);
    80005d82:	fe843503          	ld	a0,-24(s0)
    80005d86:	fffff097          	auipc	ra,0xfffff
    80005d8a:	58e080e7          	jalr	1422(ra) # 80005314 <iunlockput>
      return 0;
    80005d8e:	4781                	li	a5,0
    80005d90:	a0b1                	j	80005ddc <namex+0x11e>
    }
    iunlockput(ip);
    80005d92:	fe843503          	ld	a0,-24(s0)
    80005d96:	fffff097          	auipc	ra,0xfffff
    80005d9a:	57e080e7          	jalr	1406(ra) # 80005314 <iunlockput>
    ip = next;
    80005d9e:	fe043783          	ld	a5,-32(s0)
    80005da2:	fef43423          	sd	a5,-24(s0)
  while((path = skipelem(path, name)) != 0){
    80005da6:	fc843583          	ld	a1,-56(s0)
    80005daa:	fd843503          	ld	a0,-40(s0)
    80005dae:	00000097          	auipc	ra,0x0
    80005db2:	e22080e7          	jalr	-478(ra) # 80005bd0 <skipelem>
    80005db6:	fca43c23          	sd	a0,-40(s0)
    80005dba:	fd843783          	ld	a5,-40(s0)
    80005dbe:	ffa1                	bnez	a5,80005d16 <namex+0x58>
  }
  if(nameiparent){
    80005dc0:	fd442783          	lw	a5,-44(s0)
    80005dc4:	2781                	sext.w	a5,a5
    80005dc6:	cb89                	beqz	a5,80005dd8 <namex+0x11a>
    iput(ip);
    80005dc8:	fe843503          	ld	a0,-24(s0)
    80005dcc:	fffff097          	auipc	ra,0xfffff
    80005dd0:	478080e7          	jalr	1144(ra) # 80005244 <iput>
    return 0;
    80005dd4:	4781                	li	a5,0
    80005dd6:	a019                	j	80005ddc <namex+0x11e>
  }
  return ip;
    80005dd8:	fe843783          	ld	a5,-24(s0)
}
    80005ddc:	853e                	mv	a0,a5
    80005dde:	70e2                	ld	ra,56(sp)
    80005de0:	7442                	ld	s0,48(sp)
    80005de2:	6121                	addi	sp,sp,64
    80005de4:	8082                	ret

0000000080005de6 <namei>:

struct inode*
namei(char *path)
{
    80005de6:	7179                	addi	sp,sp,-48
    80005de8:	f406                	sd	ra,40(sp)
    80005dea:	f022                	sd	s0,32(sp)
    80005dec:	1800                	addi	s0,sp,48
    80005dee:	fca43c23          	sd	a0,-40(s0)
  char name[DIRSIZ];
  return namex(path, 0, name);
    80005df2:	fe040793          	addi	a5,s0,-32
    80005df6:	863e                	mv	a2,a5
    80005df8:	4581                	li	a1,0
    80005dfa:	fd843503          	ld	a0,-40(s0)
    80005dfe:	00000097          	auipc	ra,0x0
    80005e02:	ec0080e7          	jalr	-320(ra) # 80005cbe <namex>
    80005e06:	87aa                	mv	a5,a0
}
    80005e08:	853e                	mv	a0,a5
    80005e0a:	70a2                	ld	ra,40(sp)
    80005e0c:	7402                	ld	s0,32(sp)
    80005e0e:	6145                	addi	sp,sp,48
    80005e10:	8082                	ret

0000000080005e12 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80005e12:	1101                	addi	sp,sp,-32
    80005e14:	ec06                	sd	ra,24(sp)
    80005e16:	e822                	sd	s0,16(sp)
    80005e18:	1000                	addi	s0,sp,32
    80005e1a:	fea43423          	sd	a0,-24(s0)
    80005e1e:	feb43023          	sd	a1,-32(s0)
  return namex(path, 1, name);
    80005e22:	fe043603          	ld	a2,-32(s0)
    80005e26:	4585                	li	a1,1
    80005e28:	fe843503          	ld	a0,-24(s0)
    80005e2c:	00000097          	auipc	ra,0x0
    80005e30:	e92080e7          	jalr	-366(ra) # 80005cbe <namex>
    80005e34:	87aa                	mv	a5,a0
}
    80005e36:	853e                	mv	a0,a5
    80005e38:	60e2                	ld	ra,24(sp)
    80005e3a:	6442                	ld	s0,16(sp)
    80005e3c:	6105                	addi	sp,sp,32
    80005e3e:	8082                	ret

0000000080005e40 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev, struct superblock *sb)
{
    80005e40:	1101                	addi	sp,sp,-32
    80005e42:	ec06                	sd	ra,24(sp)
    80005e44:	e822                	sd	s0,16(sp)
    80005e46:	1000                	addi	s0,sp,32
    80005e48:	87aa                	mv	a5,a0
    80005e4a:	feb43023          	sd	a1,-32(s0)
    80005e4e:	fef42623          	sw	a5,-20(s0)
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  initlock(&log.lock, "log");
    80005e52:	00005597          	auipc	a1,0x5
    80005e56:	6fe58593          	addi	a1,a1,1790 # 8000b550 <etext+0x550>
    80005e5a:	00020517          	auipc	a0,0x20
    80005e5e:	27e50513          	addi	a0,a0,638 # 800260d8 <log>
    80005e62:	ffffb097          	auipc	ra,0xffffb
    80005e66:	3ec080e7          	jalr	1004(ra) # 8000124e <initlock>
  log.start = sb->logstart;
    80005e6a:	fe043783          	ld	a5,-32(s0)
    80005e6e:	4bdc                	lw	a5,20(a5)
    80005e70:	0007871b          	sext.w	a4,a5
    80005e74:	00020797          	auipc	a5,0x20
    80005e78:	26478793          	addi	a5,a5,612 # 800260d8 <log>
    80005e7c:	cf98                	sw	a4,24(a5)
  log.size = sb->nlog;
    80005e7e:	fe043783          	ld	a5,-32(s0)
    80005e82:	4b9c                	lw	a5,16(a5)
    80005e84:	0007871b          	sext.w	a4,a5
    80005e88:	00020797          	auipc	a5,0x20
    80005e8c:	25078793          	addi	a5,a5,592 # 800260d8 <log>
    80005e90:	cfd8                	sw	a4,28(a5)
  log.dev = dev;
    80005e92:	00020797          	auipc	a5,0x20
    80005e96:	24678793          	addi	a5,a5,582 # 800260d8 <log>
    80005e9a:	fec42703          	lw	a4,-20(s0)
    80005e9e:	d798                	sw	a4,40(a5)
  recover_from_log();
    80005ea0:	00000097          	auipc	ra,0x0
    80005ea4:	272080e7          	jalr	626(ra) # 80006112 <recover_from_log>
}
    80005ea8:	0001                	nop
    80005eaa:	60e2                	ld	ra,24(sp)
    80005eac:	6442                	ld	s0,16(sp)
    80005eae:	6105                	addi	sp,sp,32
    80005eb0:	8082                	ret

0000000080005eb2 <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(int recovering)
{
    80005eb2:	7139                	addi	sp,sp,-64
    80005eb4:	fc06                	sd	ra,56(sp)
    80005eb6:	f822                	sd	s0,48(sp)
    80005eb8:	0080                	addi	s0,sp,64
    80005eba:	87aa                	mv	a5,a0
    80005ebc:	fcf42623          	sw	a5,-52(s0)
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    80005ec0:	fe042623          	sw	zero,-20(s0)
    80005ec4:	a0f9                	j	80005f92 <install_trans+0xe0>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80005ec6:	00020797          	auipc	a5,0x20
    80005eca:	21278793          	addi	a5,a5,530 # 800260d8 <log>
    80005ece:	579c                	lw	a5,40(a5)
    80005ed0:	0007871b          	sext.w	a4,a5
    80005ed4:	00020797          	auipc	a5,0x20
    80005ed8:	20478793          	addi	a5,a5,516 # 800260d8 <log>
    80005edc:	4f9c                	lw	a5,24(a5)
    80005ede:	fec42683          	lw	a3,-20(s0)
    80005ee2:	9fb5                	addw	a5,a5,a3
    80005ee4:	2781                	sext.w	a5,a5
    80005ee6:	2785                	addiw	a5,a5,1
    80005ee8:	2781                	sext.w	a5,a5
    80005eea:	2781                	sext.w	a5,a5
    80005eec:	85be                	mv	a1,a5
    80005eee:	853a                	mv	a0,a4
    80005ef0:	ffffe097          	auipc	ra,0xffffe
    80005ef4:	7f2080e7          	jalr	2034(ra) # 800046e2 <bread>
    80005ef8:	fea43023          	sd	a0,-32(s0)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80005efc:	00020797          	auipc	a5,0x20
    80005f00:	1dc78793          	addi	a5,a5,476 # 800260d8 <log>
    80005f04:	579c                	lw	a5,40(a5)
    80005f06:	0007869b          	sext.w	a3,a5
    80005f0a:	00020717          	auipc	a4,0x20
    80005f0e:	1ce70713          	addi	a4,a4,462 # 800260d8 <log>
    80005f12:	fec42783          	lw	a5,-20(s0)
    80005f16:	07a1                	addi	a5,a5,8
    80005f18:	078a                	slli	a5,a5,0x2
    80005f1a:	97ba                	add	a5,a5,a4
    80005f1c:	4b9c                	lw	a5,16(a5)
    80005f1e:	2781                	sext.w	a5,a5
    80005f20:	85be                	mv	a1,a5
    80005f22:	8536                	mv	a0,a3
    80005f24:	ffffe097          	auipc	ra,0xffffe
    80005f28:	7be080e7          	jalr	1982(ra) # 800046e2 <bread>
    80005f2c:	fca43c23          	sd	a0,-40(s0)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80005f30:	fd843783          	ld	a5,-40(s0)
    80005f34:	05878713          	addi	a4,a5,88
    80005f38:	fe043783          	ld	a5,-32(s0)
    80005f3c:	05878793          	addi	a5,a5,88
    80005f40:	40000613          	li	a2,1024
    80005f44:	85be                	mv	a1,a5
    80005f46:	853a                	mv	a0,a4
    80005f48:	ffffb097          	auipc	ra,0xffffb
    80005f4c:	5ee080e7          	jalr	1518(ra) # 80001536 <memmove>
    bwrite(dbuf);  // write dst to disk
    80005f50:	fd843503          	ld	a0,-40(s0)
    80005f54:	ffffe097          	auipc	ra,0xffffe
    80005f58:	7e8080e7          	jalr	2024(ra) # 8000473c <bwrite>
    if(recovering == 0)
    80005f5c:	fcc42783          	lw	a5,-52(s0)
    80005f60:	2781                	sext.w	a5,a5
    80005f62:	e799                	bnez	a5,80005f70 <install_trans+0xbe>
      bunpin(dbuf);
    80005f64:	fd843503          	ld	a0,-40(s0)
    80005f68:	fffff097          	auipc	ra,0xfffff
    80005f6c:	952080e7          	jalr	-1710(ra) # 800048ba <bunpin>
    brelse(lbuf);
    80005f70:	fe043503          	ld	a0,-32(s0)
    80005f74:	fffff097          	auipc	ra,0xfffff
    80005f78:	810080e7          	jalr	-2032(ra) # 80004784 <brelse>
    brelse(dbuf);
    80005f7c:	fd843503          	ld	a0,-40(s0)
    80005f80:	fffff097          	auipc	ra,0xfffff
    80005f84:	804080e7          	jalr	-2044(ra) # 80004784 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80005f88:	fec42783          	lw	a5,-20(s0)
    80005f8c:	2785                	addiw	a5,a5,1
    80005f8e:	fef42623          	sw	a5,-20(s0)
    80005f92:	00020797          	auipc	a5,0x20
    80005f96:	14678793          	addi	a5,a5,326 # 800260d8 <log>
    80005f9a:	57d8                	lw	a4,44(a5)
    80005f9c:	fec42783          	lw	a5,-20(s0)
    80005fa0:	2781                	sext.w	a5,a5
    80005fa2:	f2e7c2e3          	blt	a5,a4,80005ec6 <install_trans+0x14>
  }
}
    80005fa6:	0001                	nop
    80005fa8:	0001                	nop
    80005faa:	70e2                	ld	ra,56(sp)
    80005fac:	7442                	ld	s0,48(sp)
    80005fae:	6121                	addi	sp,sp,64
    80005fb0:	8082                	ret

0000000080005fb2 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
    80005fb2:	7179                	addi	sp,sp,-48
    80005fb4:	f406                	sd	ra,40(sp)
    80005fb6:	f022                	sd	s0,32(sp)
    80005fb8:	1800                	addi	s0,sp,48
  struct buf *buf = bread(log.dev, log.start);
    80005fba:	00020797          	auipc	a5,0x20
    80005fbe:	11e78793          	addi	a5,a5,286 # 800260d8 <log>
    80005fc2:	579c                	lw	a5,40(a5)
    80005fc4:	0007871b          	sext.w	a4,a5
    80005fc8:	00020797          	auipc	a5,0x20
    80005fcc:	11078793          	addi	a5,a5,272 # 800260d8 <log>
    80005fd0:	4f9c                	lw	a5,24(a5)
    80005fd2:	2781                	sext.w	a5,a5
    80005fd4:	85be                	mv	a1,a5
    80005fd6:	853a                	mv	a0,a4
    80005fd8:	ffffe097          	auipc	ra,0xffffe
    80005fdc:	70a080e7          	jalr	1802(ra) # 800046e2 <bread>
    80005fe0:	fea43023          	sd	a0,-32(s0)
  struct logheader *lh = (struct logheader *) (buf->data);
    80005fe4:	fe043783          	ld	a5,-32(s0)
    80005fe8:	05878793          	addi	a5,a5,88
    80005fec:	fcf43c23          	sd	a5,-40(s0)
  int i;
  log.lh.n = lh->n;
    80005ff0:	fd843783          	ld	a5,-40(s0)
    80005ff4:	4398                	lw	a4,0(a5)
    80005ff6:	00020797          	auipc	a5,0x20
    80005ffa:	0e278793          	addi	a5,a5,226 # 800260d8 <log>
    80005ffe:	d7d8                	sw	a4,44(a5)
  for (i = 0; i < log.lh.n; i++) {
    80006000:	fe042623          	sw	zero,-20(s0)
    80006004:	a03d                	j	80006032 <read_head+0x80>
    log.lh.block[i] = lh->block[i];
    80006006:	fd843703          	ld	a4,-40(s0)
    8000600a:	fec42783          	lw	a5,-20(s0)
    8000600e:	078a                	slli	a5,a5,0x2
    80006010:	97ba                	add	a5,a5,a4
    80006012:	43d8                	lw	a4,4(a5)
    80006014:	00020697          	auipc	a3,0x20
    80006018:	0c468693          	addi	a3,a3,196 # 800260d8 <log>
    8000601c:	fec42783          	lw	a5,-20(s0)
    80006020:	07a1                	addi	a5,a5,8
    80006022:	078a                	slli	a5,a5,0x2
    80006024:	97b6                	add	a5,a5,a3
    80006026:	cb98                	sw	a4,16(a5)
  for (i = 0; i < log.lh.n; i++) {
    80006028:	fec42783          	lw	a5,-20(s0)
    8000602c:	2785                	addiw	a5,a5,1
    8000602e:	fef42623          	sw	a5,-20(s0)
    80006032:	00020797          	auipc	a5,0x20
    80006036:	0a678793          	addi	a5,a5,166 # 800260d8 <log>
    8000603a:	57d8                	lw	a4,44(a5)
    8000603c:	fec42783          	lw	a5,-20(s0)
    80006040:	2781                	sext.w	a5,a5
    80006042:	fce7c2e3          	blt	a5,a4,80006006 <read_head+0x54>
  }
  brelse(buf);
    80006046:	fe043503          	ld	a0,-32(s0)
    8000604a:	ffffe097          	auipc	ra,0xffffe
    8000604e:	73a080e7          	jalr	1850(ra) # 80004784 <brelse>
}
    80006052:	0001                	nop
    80006054:	70a2                	ld	ra,40(sp)
    80006056:	7402                	ld	s0,32(sp)
    80006058:	6145                	addi	sp,sp,48
    8000605a:	8082                	ret

000000008000605c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000605c:	7179                	addi	sp,sp,-48
    8000605e:	f406                	sd	ra,40(sp)
    80006060:	f022                	sd	s0,32(sp)
    80006062:	1800                	addi	s0,sp,48
  struct buf *buf = bread(log.dev, log.start);
    80006064:	00020797          	auipc	a5,0x20
    80006068:	07478793          	addi	a5,a5,116 # 800260d8 <log>
    8000606c:	579c                	lw	a5,40(a5)
    8000606e:	0007871b          	sext.w	a4,a5
    80006072:	00020797          	auipc	a5,0x20
    80006076:	06678793          	addi	a5,a5,102 # 800260d8 <log>
    8000607a:	4f9c                	lw	a5,24(a5)
    8000607c:	2781                	sext.w	a5,a5
    8000607e:	85be                	mv	a1,a5
    80006080:	853a                	mv	a0,a4
    80006082:	ffffe097          	auipc	ra,0xffffe
    80006086:	660080e7          	jalr	1632(ra) # 800046e2 <bread>
    8000608a:	fea43023          	sd	a0,-32(s0)
  struct logheader *hb = (struct logheader *) (buf->data);
    8000608e:	fe043783          	ld	a5,-32(s0)
    80006092:	05878793          	addi	a5,a5,88
    80006096:	fcf43c23          	sd	a5,-40(s0)
  int i;
  hb->n = log.lh.n;
    8000609a:	00020797          	auipc	a5,0x20
    8000609e:	03e78793          	addi	a5,a5,62 # 800260d8 <log>
    800060a2:	57d8                	lw	a4,44(a5)
    800060a4:	fd843783          	ld	a5,-40(s0)
    800060a8:	c398                	sw	a4,0(a5)
  for (i = 0; i < log.lh.n; i++) {
    800060aa:	fe042623          	sw	zero,-20(s0)
    800060ae:	a03d                	j	800060dc <write_head+0x80>
    hb->block[i] = log.lh.block[i];
    800060b0:	00020717          	auipc	a4,0x20
    800060b4:	02870713          	addi	a4,a4,40 # 800260d8 <log>
    800060b8:	fec42783          	lw	a5,-20(s0)
    800060bc:	07a1                	addi	a5,a5,8
    800060be:	078a                	slli	a5,a5,0x2
    800060c0:	97ba                	add	a5,a5,a4
    800060c2:	4b98                	lw	a4,16(a5)
    800060c4:	fd843683          	ld	a3,-40(s0)
    800060c8:	fec42783          	lw	a5,-20(s0)
    800060cc:	078a                	slli	a5,a5,0x2
    800060ce:	97b6                	add	a5,a5,a3
    800060d0:	c3d8                	sw	a4,4(a5)
  for (i = 0; i < log.lh.n; i++) {
    800060d2:	fec42783          	lw	a5,-20(s0)
    800060d6:	2785                	addiw	a5,a5,1
    800060d8:	fef42623          	sw	a5,-20(s0)
    800060dc:	00020797          	auipc	a5,0x20
    800060e0:	ffc78793          	addi	a5,a5,-4 # 800260d8 <log>
    800060e4:	57d8                	lw	a4,44(a5)
    800060e6:	fec42783          	lw	a5,-20(s0)
    800060ea:	2781                	sext.w	a5,a5
    800060ec:	fce7c2e3          	blt	a5,a4,800060b0 <write_head+0x54>
  }
  bwrite(buf);
    800060f0:	fe043503          	ld	a0,-32(s0)
    800060f4:	ffffe097          	auipc	ra,0xffffe
    800060f8:	648080e7          	jalr	1608(ra) # 8000473c <bwrite>
  brelse(buf);
    800060fc:	fe043503          	ld	a0,-32(s0)
    80006100:	ffffe097          	auipc	ra,0xffffe
    80006104:	684080e7          	jalr	1668(ra) # 80004784 <brelse>
}
    80006108:	0001                	nop
    8000610a:	70a2                	ld	ra,40(sp)
    8000610c:	7402                	ld	s0,32(sp)
    8000610e:	6145                	addi	sp,sp,48
    80006110:	8082                	ret

0000000080006112 <recover_from_log>:

static void
recover_from_log(void)
{
    80006112:	1141                	addi	sp,sp,-16
    80006114:	e406                	sd	ra,8(sp)
    80006116:	e022                	sd	s0,0(sp)
    80006118:	0800                	addi	s0,sp,16
  read_head();
    8000611a:	00000097          	auipc	ra,0x0
    8000611e:	e98080e7          	jalr	-360(ra) # 80005fb2 <read_head>
  install_trans(1); // if committed, copy from log to disk
    80006122:	4505                	li	a0,1
    80006124:	00000097          	auipc	ra,0x0
    80006128:	d8e080e7          	jalr	-626(ra) # 80005eb2 <install_trans>
  log.lh.n = 0;
    8000612c:	00020797          	auipc	a5,0x20
    80006130:	fac78793          	addi	a5,a5,-84 # 800260d8 <log>
    80006134:	0207a623          	sw	zero,44(a5)
  write_head(); // clear the log
    80006138:	00000097          	auipc	ra,0x0
    8000613c:	f24080e7          	jalr	-220(ra) # 8000605c <write_head>
}
    80006140:	0001                	nop
    80006142:	60a2                	ld	ra,8(sp)
    80006144:	6402                	ld	s0,0(sp)
    80006146:	0141                	addi	sp,sp,16
    80006148:	8082                	ret

000000008000614a <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
    8000614a:	1141                	addi	sp,sp,-16
    8000614c:	e406                	sd	ra,8(sp)
    8000614e:	e022                	sd	s0,0(sp)
    80006150:	0800                	addi	s0,sp,16
  acquire(&log.lock);
    80006152:	00020517          	auipc	a0,0x20
    80006156:	f8650513          	addi	a0,a0,-122 # 800260d8 <log>
    8000615a:	ffffb097          	auipc	ra,0xffffb
    8000615e:	124080e7          	jalr	292(ra) # 8000127e <acquire>
  while(1){
    if(log.committing){
    80006162:	00020797          	auipc	a5,0x20
    80006166:	f7678793          	addi	a5,a5,-138 # 800260d8 <log>
    8000616a:	53dc                	lw	a5,36(a5)
    8000616c:	cf91                	beqz	a5,80006188 <begin_op+0x3e>
      sleep(&log, &log.lock);
    8000616e:	00020597          	auipc	a1,0x20
    80006172:	f6a58593          	addi	a1,a1,-150 # 800260d8 <log>
    80006176:	00020517          	auipc	a0,0x20
    8000617a:	f6250513          	addi	a0,a0,-158 # 800260d8 <log>
    8000617e:	ffffd097          	auipc	ra,0xffffd
    80006182:	28a080e7          	jalr	650(ra) # 80003408 <sleep>
    80006186:	bff1                	j	80006162 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80006188:	00020797          	auipc	a5,0x20
    8000618c:	f5078793          	addi	a5,a5,-176 # 800260d8 <log>
    80006190:	57d8                	lw	a4,44(a5)
    80006192:	00020797          	auipc	a5,0x20
    80006196:	f4678793          	addi	a5,a5,-186 # 800260d8 <log>
    8000619a:	539c                	lw	a5,32(a5)
    8000619c:	2785                	addiw	a5,a5,1
    8000619e:	2781                	sext.w	a5,a5
    800061a0:	86be                	mv	a3,a5
    800061a2:	87b6                	mv	a5,a3
    800061a4:	0027979b          	slliw	a5,a5,0x2
    800061a8:	9fb5                	addw	a5,a5,a3
    800061aa:	0017979b          	slliw	a5,a5,0x1
    800061ae:	2781                	sext.w	a5,a5
    800061b0:	9fb9                	addw	a5,a5,a4
    800061b2:	2781                	sext.w	a5,a5
    800061b4:	873e                	mv	a4,a5
    800061b6:	47f9                	li	a5,30
    800061b8:	00e7df63          	bge	a5,a4,800061d6 <begin_op+0x8c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800061bc:	00020597          	auipc	a1,0x20
    800061c0:	f1c58593          	addi	a1,a1,-228 # 800260d8 <log>
    800061c4:	00020517          	auipc	a0,0x20
    800061c8:	f1450513          	addi	a0,a0,-236 # 800260d8 <log>
    800061cc:	ffffd097          	auipc	ra,0xffffd
    800061d0:	23c080e7          	jalr	572(ra) # 80003408 <sleep>
    800061d4:	b779                	j	80006162 <begin_op+0x18>
    } else {
      log.outstanding += 1;
    800061d6:	00020797          	auipc	a5,0x20
    800061da:	f0278793          	addi	a5,a5,-254 # 800260d8 <log>
    800061de:	539c                	lw	a5,32(a5)
    800061e0:	2785                	addiw	a5,a5,1
    800061e2:	0007871b          	sext.w	a4,a5
    800061e6:	00020797          	auipc	a5,0x20
    800061ea:	ef278793          	addi	a5,a5,-270 # 800260d8 <log>
    800061ee:	d398                	sw	a4,32(a5)
      release(&log.lock);
    800061f0:	00020517          	auipc	a0,0x20
    800061f4:	ee850513          	addi	a0,a0,-280 # 800260d8 <log>
    800061f8:	ffffb097          	auipc	ra,0xffffb
    800061fc:	0ea080e7          	jalr	234(ra) # 800012e2 <release>
      break;
    80006200:	0001                	nop
    }
  }
}
    80006202:	0001                	nop
    80006204:	60a2                	ld	ra,8(sp)
    80006206:	6402                	ld	s0,0(sp)
    80006208:	0141                	addi	sp,sp,16
    8000620a:	8082                	ret

000000008000620c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000620c:	1101                	addi	sp,sp,-32
    8000620e:	ec06                	sd	ra,24(sp)
    80006210:	e822                	sd	s0,16(sp)
    80006212:	1000                	addi	s0,sp,32
  int do_commit = 0;
    80006214:	fe042623          	sw	zero,-20(s0)

  acquire(&log.lock);
    80006218:	00020517          	auipc	a0,0x20
    8000621c:	ec050513          	addi	a0,a0,-320 # 800260d8 <log>
    80006220:	ffffb097          	auipc	ra,0xffffb
    80006224:	05e080e7          	jalr	94(ra) # 8000127e <acquire>
  log.outstanding -= 1;
    80006228:	00020797          	auipc	a5,0x20
    8000622c:	eb078793          	addi	a5,a5,-336 # 800260d8 <log>
    80006230:	539c                	lw	a5,32(a5)
    80006232:	37fd                	addiw	a5,a5,-1
    80006234:	0007871b          	sext.w	a4,a5
    80006238:	00020797          	auipc	a5,0x20
    8000623c:	ea078793          	addi	a5,a5,-352 # 800260d8 <log>
    80006240:	d398                	sw	a4,32(a5)
  if(log.committing)
    80006242:	00020797          	auipc	a5,0x20
    80006246:	e9678793          	addi	a5,a5,-362 # 800260d8 <log>
    8000624a:	53dc                	lw	a5,36(a5)
    8000624c:	cb89                	beqz	a5,8000625e <end_op+0x52>
    panic("log.committing");
    8000624e:	00005517          	auipc	a0,0x5
    80006252:	30a50513          	addi	a0,a0,778 # 8000b558 <etext+0x558>
    80006256:	ffffb097          	auipc	ra,0xffffb
    8000625a:	a34080e7          	jalr	-1484(ra) # 80000c8a <panic>
  if(log.outstanding == 0){
    8000625e:	00020797          	auipc	a5,0x20
    80006262:	e7a78793          	addi	a5,a5,-390 # 800260d8 <log>
    80006266:	539c                	lw	a5,32(a5)
    80006268:	eb99                	bnez	a5,8000627e <end_op+0x72>
    do_commit = 1;
    8000626a:	4785                	li	a5,1
    8000626c:	fef42623          	sw	a5,-20(s0)
    log.committing = 1;
    80006270:	00020797          	auipc	a5,0x20
    80006274:	e6878793          	addi	a5,a5,-408 # 800260d8 <log>
    80006278:	4705                	li	a4,1
    8000627a:	d3d8                	sw	a4,36(a5)
    8000627c:	a809                	j	8000628e <end_op+0x82>
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
    8000627e:	00020517          	auipc	a0,0x20
    80006282:	e5a50513          	addi	a0,a0,-422 # 800260d8 <log>
    80006286:	ffffd097          	auipc	ra,0xffffd
    8000628a:	1fe080e7          	jalr	510(ra) # 80003484 <wakeup>
  }
  release(&log.lock);
    8000628e:	00020517          	auipc	a0,0x20
    80006292:	e4a50513          	addi	a0,a0,-438 # 800260d8 <log>
    80006296:	ffffb097          	auipc	ra,0xffffb
    8000629a:	04c080e7          	jalr	76(ra) # 800012e2 <release>

  if(do_commit){
    8000629e:	fec42783          	lw	a5,-20(s0)
    800062a2:	2781                	sext.w	a5,a5
    800062a4:	c3b9                	beqz	a5,800062ea <end_op+0xde>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    800062a6:	00000097          	auipc	ra,0x0
    800062aa:	134080e7          	jalr	308(ra) # 800063da <commit>
    acquire(&log.lock);
    800062ae:	00020517          	auipc	a0,0x20
    800062b2:	e2a50513          	addi	a0,a0,-470 # 800260d8 <log>
    800062b6:	ffffb097          	auipc	ra,0xffffb
    800062ba:	fc8080e7          	jalr	-56(ra) # 8000127e <acquire>
    log.committing = 0;
    800062be:	00020797          	auipc	a5,0x20
    800062c2:	e1a78793          	addi	a5,a5,-486 # 800260d8 <log>
    800062c6:	0207a223          	sw	zero,36(a5)
    wakeup(&log);
    800062ca:	00020517          	auipc	a0,0x20
    800062ce:	e0e50513          	addi	a0,a0,-498 # 800260d8 <log>
    800062d2:	ffffd097          	auipc	ra,0xffffd
    800062d6:	1b2080e7          	jalr	434(ra) # 80003484 <wakeup>
    release(&log.lock);
    800062da:	00020517          	auipc	a0,0x20
    800062de:	dfe50513          	addi	a0,a0,-514 # 800260d8 <log>
    800062e2:	ffffb097          	auipc	ra,0xffffb
    800062e6:	000080e7          	jalr	ra # 800012e2 <release>
  }
}
    800062ea:	0001                	nop
    800062ec:	60e2                	ld	ra,24(sp)
    800062ee:	6442                	ld	s0,16(sp)
    800062f0:	6105                	addi	sp,sp,32
    800062f2:	8082                	ret

00000000800062f4 <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
    800062f4:	7179                	addi	sp,sp,-48
    800062f6:	f406                	sd	ra,40(sp)
    800062f8:	f022                	sd	s0,32(sp)
    800062fa:	1800                	addi	s0,sp,48
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    800062fc:	fe042623          	sw	zero,-20(s0)
    80006300:	a86d                	j	800063ba <write_log+0xc6>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80006302:	00020797          	auipc	a5,0x20
    80006306:	dd678793          	addi	a5,a5,-554 # 800260d8 <log>
    8000630a:	579c                	lw	a5,40(a5)
    8000630c:	0007871b          	sext.w	a4,a5
    80006310:	00020797          	auipc	a5,0x20
    80006314:	dc878793          	addi	a5,a5,-568 # 800260d8 <log>
    80006318:	4f9c                	lw	a5,24(a5)
    8000631a:	fec42683          	lw	a3,-20(s0)
    8000631e:	9fb5                	addw	a5,a5,a3
    80006320:	2781                	sext.w	a5,a5
    80006322:	2785                	addiw	a5,a5,1
    80006324:	2781                	sext.w	a5,a5
    80006326:	2781                	sext.w	a5,a5
    80006328:	85be                	mv	a1,a5
    8000632a:	853a                	mv	a0,a4
    8000632c:	ffffe097          	auipc	ra,0xffffe
    80006330:	3b6080e7          	jalr	950(ra) # 800046e2 <bread>
    80006334:	fea43023          	sd	a0,-32(s0)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80006338:	00020797          	auipc	a5,0x20
    8000633c:	da078793          	addi	a5,a5,-608 # 800260d8 <log>
    80006340:	579c                	lw	a5,40(a5)
    80006342:	0007869b          	sext.w	a3,a5
    80006346:	00020717          	auipc	a4,0x20
    8000634a:	d9270713          	addi	a4,a4,-622 # 800260d8 <log>
    8000634e:	fec42783          	lw	a5,-20(s0)
    80006352:	07a1                	addi	a5,a5,8
    80006354:	078a                	slli	a5,a5,0x2
    80006356:	97ba                	add	a5,a5,a4
    80006358:	4b9c                	lw	a5,16(a5)
    8000635a:	2781                	sext.w	a5,a5
    8000635c:	85be                	mv	a1,a5
    8000635e:	8536                	mv	a0,a3
    80006360:	ffffe097          	auipc	ra,0xffffe
    80006364:	382080e7          	jalr	898(ra) # 800046e2 <bread>
    80006368:	fca43c23          	sd	a0,-40(s0)
    memmove(to->data, from->data, BSIZE);
    8000636c:	fe043783          	ld	a5,-32(s0)
    80006370:	05878713          	addi	a4,a5,88
    80006374:	fd843783          	ld	a5,-40(s0)
    80006378:	05878793          	addi	a5,a5,88
    8000637c:	40000613          	li	a2,1024
    80006380:	85be                	mv	a1,a5
    80006382:	853a                	mv	a0,a4
    80006384:	ffffb097          	auipc	ra,0xffffb
    80006388:	1b2080e7          	jalr	434(ra) # 80001536 <memmove>
    bwrite(to);  // write the log
    8000638c:	fe043503          	ld	a0,-32(s0)
    80006390:	ffffe097          	auipc	ra,0xffffe
    80006394:	3ac080e7          	jalr	940(ra) # 8000473c <bwrite>
    brelse(from);
    80006398:	fd843503          	ld	a0,-40(s0)
    8000639c:	ffffe097          	auipc	ra,0xffffe
    800063a0:	3e8080e7          	jalr	1000(ra) # 80004784 <brelse>
    brelse(to);
    800063a4:	fe043503          	ld	a0,-32(s0)
    800063a8:	ffffe097          	auipc	ra,0xffffe
    800063ac:	3dc080e7          	jalr	988(ra) # 80004784 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800063b0:	fec42783          	lw	a5,-20(s0)
    800063b4:	2785                	addiw	a5,a5,1
    800063b6:	fef42623          	sw	a5,-20(s0)
    800063ba:	00020797          	auipc	a5,0x20
    800063be:	d1e78793          	addi	a5,a5,-738 # 800260d8 <log>
    800063c2:	57d8                	lw	a4,44(a5)
    800063c4:	fec42783          	lw	a5,-20(s0)
    800063c8:	2781                	sext.w	a5,a5
    800063ca:	f2e7cce3          	blt	a5,a4,80006302 <write_log+0xe>
  }
}
    800063ce:	0001                	nop
    800063d0:	0001                	nop
    800063d2:	70a2                	ld	ra,40(sp)
    800063d4:	7402                	ld	s0,32(sp)
    800063d6:	6145                	addi	sp,sp,48
    800063d8:	8082                	ret

00000000800063da <commit>:

static void
commit()
{
    800063da:	1141                	addi	sp,sp,-16
    800063dc:	e406                	sd	ra,8(sp)
    800063de:	e022                	sd	s0,0(sp)
    800063e0:	0800                	addi	s0,sp,16
  if (log.lh.n > 0) {
    800063e2:	00020797          	auipc	a5,0x20
    800063e6:	cf678793          	addi	a5,a5,-778 # 800260d8 <log>
    800063ea:	57dc                	lw	a5,44(a5)
    800063ec:	02f05963          	blez	a5,8000641e <commit+0x44>
    write_log();     // Write modified blocks from cache to log
    800063f0:	00000097          	auipc	ra,0x0
    800063f4:	f04080e7          	jalr	-252(ra) # 800062f4 <write_log>
    write_head();    // Write header to disk -- the real commit
    800063f8:	00000097          	auipc	ra,0x0
    800063fc:	c64080e7          	jalr	-924(ra) # 8000605c <write_head>
    install_trans(0); // Now install writes to home locations
    80006400:	4501                	li	a0,0
    80006402:	00000097          	auipc	ra,0x0
    80006406:	ab0080e7          	jalr	-1360(ra) # 80005eb2 <install_trans>
    log.lh.n = 0;
    8000640a:	00020797          	auipc	a5,0x20
    8000640e:	cce78793          	addi	a5,a5,-818 # 800260d8 <log>
    80006412:	0207a623          	sw	zero,44(a5)
    write_head();    // Erase the transaction from the log
    80006416:	00000097          	auipc	ra,0x0
    8000641a:	c46080e7          	jalr	-954(ra) # 8000605c <write_head>
  }
}
    8000641e:	0001                	nop
    80006420:	60a2                	ld	ra,8(sp)
    80006422:	6402                	ld	s0,0(sp)
    80006424:	0141                	addi	sp,sp,16
    80006426:	8082                	ret

0000000080006428 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80006428:	7179                	addi	sp,sp,-48
    8000642a:	f406                	sd	ra,40(sp)
    8000642c:	f022                	sd	s0,32(sp)
    8000642e:	1800                	addi	s0,sp,48
    80006430:	fca43c23          	sd	a0,-40(s0)
  int i;

  acquire(&log.lock);
    80006434:	00020517          	auipc	a0,0x20
    80006438:	ca450513          	addi	a0,a0,-860 # 800260d8 <log>
    8000643c:	ffffb097          	auipc	ra,0xffffb
    80006440:	e42080e7          	jalr	-446(ra) # 8000127e <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80006444:	00020797          	auipc	a5,0x20
    80006448:	c9478793          	addi	a5,a5,-876 # 800260d8 <log>
    8000644c:	57dc                	lw	a5,44(a5)
    8000644e:	873e                	mv	a4,a5
    80006450:	47f5                	li	a5,29
    80006452:	02e7c063          	blt	a5,a4,80006472 <log_write+0x4a>
    80006456:	00020797          	auipc	a5,0x20
    8000645a:	c8278793          	addi	a5,a5,-894 # 800260d8 <log>
    8000645e:	57d8                	lw	a4,44(a5)
    80006460:	00020797          	auipc	a5,0x20
    80006464:	c7878793          	addi	a5,a5,-904 # 800260d8 <log>
    80006468:	4fdc                	lw	a5,28(a5)
    8000646a:	37fd                	addiw	a5,a5,-1
    8000646c:	2781                	sext.w	a5,a5
    8000646e:	00f74a63          	blt	a4,a5,80006482 <log_write+0x5a>
    panic("too big a transaction");
    80006472:	00005517          	auipc	a0,0x5
    80006476:	0f650513          	addi	a0,a0,246 # 8000b568 <etext+0x568>
    8000647a:	ffffb097          	auipc	ra,0xffffb
    8000647e:	810080e7          	jalr	-2032(ra) # 80000c8a <panic>
  if (log.outstanding < 1)
    80006482:	00020797          	auipc	a5,0x20
    80006486:	c5678793          	addi	a5,a5,-938 # 800260d8 <log>
    8000648a:	539c                	lw	a5,32(a5)
    8000648c:	00f04a63          	bgtz	a5,800064a0 <log_write+0x78>
    panic("log_write outside of trans");
    80006490:	00005517          	auipc	a0,0x5
    80006494:	0f050513          	addi	a0,a0,240 # 8000b580 <etext+0x580>
    80006498:	ffffa097          	auipc	ra,0xffffa
    8000649c:	7f2080e7          	jalr	2034(ra) # 80000c8a <panic>

  for (i = 0; i < log.lh.n; i++) {
    800064a0:	fe042623          	sw	zero,-20(s0)
    800064a4:	a03d                	j	800064d2 <log_write+0xaa>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800064a6:	00020717          	auipc	a4,0x20
    800064aa:	c3270713          	addi	a4,a4,-974 # 800260d8 <log>
    800064ae:	fec42783          	lw	a5,-20(s0)
    800064b2:	07a1                	addi	a5,a5,8
    800064b4:	078a                	slli	a5,a5,0x2
    800064b6:	97ba                	add	a5,a5,a4
    800064b8:	4b9c                	lw	a5,16(a5)
    800064ba:	0007871b          	sext.w	a4,a5
    800064be:	fd843783          	ld	a5,-40(s0)
    800064c2:	47dc                	lw	a5,12(a5)
    800064c4:	02f70263          	beq	a4,a5,800064e8 <log_write+0xc0>
  for (i = 0; i < log.lh.n; i++) {
    800064c8:	fec42783          	lw	a5,-20(s0)
    800064cc:	2785                	addiw	a5,a5,1
    800064ce:	fef42623          	sw	a5,-20(s0)
    800064d2:	00020797          	auipc	a5,0x20
    800064d6:	c0678793          	addi	a5,a5,-1018 # 800260d8 <log>
    800064da:	57d8                	lw	a4,44(a5)
    800064dc:	fec42783          	lw	a5,-20(s0)
    800064e0:	2781                	sext.w	a5,a5
    800064e2:	fce7c2e3          	blt	a5,a4,800064a6 <log_write+0x7e>
    800064e6:	a011                	j	800064ea <log_write+0xc2>
      break;
    800064e8:	0001                	nop
  }
  log.lh.block[i] = b->blockno;
    800064ea:	fd843783          	ld	a5,-40(s0)
    800064ee:	47dc                	lw	a5,12(a5)
    800064f0:	0007871b          	sext.w	a4,a5
    800064f4:	00020697          	auipc	a3,0x20
    800064f8:	be468693          	addi	a3,a3,-1052 # 800260d8 <log>
    800064fc:	fec42783          	lw	a5,-20(s0)
    80006500:	07a1                	addi	a5,a5,8
    80006502:	078a                	slli	a5,a5,0x2
    80006504:	97b6                	add	a5,a5,a3
    80006506:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    80006508:	00020797          	auipc	a5,0x20
    8000650c:	bd078793          	addi	a5,a5,-1072 # 800260d8 <log>
    80006510:	57d8                	lw	a4,44(a5)
    80006512:	fec42783          	lw	a5,-20(s0)
    80006516:	2781                	sext.w	a5,a5
    80006518:	02e79563          	bne	a5,a4,80006542 <log_write+0x11a>
    bpin(b);
    8000651c:	fd843503          	ld	a0,-40(s0)
    80006520:	ffffe097          	auipc	ra,0xffffe
    80006524:	352080e7          	jalr	850(ra) # 80004872 <bpin>
    log.lh.n++;
    80006528:	00020797          	auipc	a5,0x20
    8000652c:	bb078793          	addi	a5,a5,-1104 # 800260d8 <log>
    80006530:	57dc                	lw	a5,44(a5)
    80006532:	2785                	addiw	a5,a5,1
    80006534:	0007871b          	sext.w	a4,a5
    80006538:	00020797          	auipc	a5,0x20
    8000653c:	ba078793          	addi	a5,a5,-1120 # 800260d8 <log>
    80006540:	d7d8                	sw	a4,44(a5)
  }
  release(&log.lock);
    80006542:	00020517          	auipc	a0,0x20
    80006546:	b9650513          	addi	a0,a0,-1130 # 800260d8 <log>
    8000654a:	ffffb097          	auipc	ra,0xffffb
    8000654e:	d98080e7          	jalr	-616(ra) # 800012e2 <release>
}
    80006552:	0001                	nop
    80006554:	70a2                	ld	ra,40(sp)
    80006556:	7402                	ld	s0,32(sp)
    80006558:	6145                	addi	sp,sp,48
    8000655a:	8082                	ret

000000008000655c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000655c:	1101                	addi	sp,sp,-32
    8000655e:	ec06                	sd	ra,24(sp)
    80006560:	e822                	sd	s0,16(sp)
    80006562:	1000                	addi	s0,sp,32
    80006564:	fea43423          	sd	a0,-24(s0)
    80006568:	feb43023          	sd	a1,-32(s0)
  initlock(&lk->lk, "sleep lock");
    8000656c:	fe843783          	ld	a5,-24(s0)
    80006570:	07a1                	addi	a5,a5,8
    80006572:	00005597          	auipc	a1,0x5
    80006576:	02e58593          	addi	a1,a1,46 # 8000b5a0 <etext+0x5a0>
    8000657a:	853e                	mv	a0,a5
    8000657c:	ffffb097          	auipc	ra,0xffffb
    80006580:	cd2080e7          	jalr	-814(ra) # 8000124e <initlock>
  lk->name = name;
    80006584:	fe843783          	ld	a5,-24(s0)
    80006588:	fe043703          	ld	a4,-32(s0)
    8000658c:	f398                	sd	a4,32(a5)
  lk->locked = 0;
    8000658e:	fe843783          	ld	a5,-24(s0)
    80006592:	0007a023          	sw	zero,0(a5)
  lk->pid = 0;
    80006596:	fe843783          	ld	a5,-24(s0)
    8000659a:	0207a423          	sw	zero,40(a5)
}
    8000659e:	0001                	nop
    800065a0:	60e2                	ld	ra,24(sp)
    800065a2:	6442                	ld	s0,16(sp)
    800065a4:	6105                	addi	sp,sp,32
    800065a6:	8082                	ret

00000000800065a8 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800065a8:	1101                	addi	sp,sp,-32
    800065aa:	ec06                	sd	ra,24(sp)
    800065ac:	e822                	sd	s0,16(sp)
    800065ae:	1000                	addi	s0,sp,32
    800065b0:	fea43423          	sd	a0,-24(s0)
  acquire(&lk->lk);
    800065b4:	fe843783          	ld	a5,-24(s0)
    800065b8:	07a1                	addi	a5,a5,8
    800065ba:	853e                	mv	a0,a5
    800065bc:	ffffb097          	auipc	ra,0xffffb
    800065c0:	cc2080e7          	jalr	-830(ra) # 8000127e <acquire>
  while (lk->locked) {
    800065c4:	a819                	j	800065da <acquiresleep+0x32>
    sleep(lk, &lk->lk);
    800065c6:	fe843783          	ld	a5,-24(s0)
    800065ca:	07a1                	addi	a5,a5,8
    800065cc:	85be                	mv	a1,a5
    800065ce:	fe843503          	ld	a0,-24(s0)
    800065d2:	ffffd097          	auipc	ra,0xffffd
    800065d6:	e36080e7          	jalr	-458(ra) # 80003408 <sleep>
  while (lk->locked) {
    800065da:	fe843783          	ld	a5,-24(s0)
    800065de:	439c                	lw	a5,0(a5)
    800065e0:	f3fd                	bnez	a5,800065c6 <acquiresleep+0x1e>
  }
  lk->locked = 1;
    800065e2:	fe843783          	ld	a5,-24(s0)
    800065e6:	4705                	li	a4,1
    800065e8:	c398                	sw	a4,0(a5)
  lk->pid = myproc()->pid;
    800065ea:	ffffc097          	auipc	ra,0xffffc
    800065ee:	25c080e7          	jalr	604(ra) # 80002846 <myproc>
    800065f2:	87aa                	mv	a5,a0
    800065f4:	5b98                	lw	a4,48(a5)
    800065f6:	fe843783          	ld	a5,-24(s0)
    800065fa:	d798                	sw	a4,40(a5)
  release(&lk->lk);
    800065fc:	fe843783          	ld	a5,-24(s0)
    80006600:	07a1                	addi	a5,a5,8
    80006602:	853e                	mv	a0,a5
    80006604:	ffffb097          	auipc	ra,0xffffb
    80006608:	cde080e7          	jalr	-802(ra) # 800012e2 <release>
}
    8000660c:	0001                	nop
    8000660e:	60e2                	ld	ra,24(sp)
    80006610:	6442                	ld	s0,16(sp)
    80006612:	6105                	addi	sp,sp,32
    80006614:	8082                	ret

0000000080006616 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80006616:	1101                	addi	sp,sp,-32
    80006618:	ec06                	sd	ra,24(sp)
    8000661a:	e822                	sd	s0,16(sp)
    8000661c:	1000                	addi	s0,sp,32
    8000661e:	fea43423          	sd	a0,-24(s0)
  acquire(&lk->lk);
    80006622:	fe843783          	ld	a5,-24(s0)
    80006626:	07a1                	addi	a5,a5,8
    80006628:	853e                	mv	a0,a5
    8000662a:	ffffb097          	auipc	ra,0xffffb
    8000662e:	c54080e7          	jalr	-940(ra) # 8000127e <acquire>
  lk->locked = 0;
    80006632:	fe843783          	ld	a5,-24(s0)
    80006636:	0007a023          	sw	zero,0(a5)
  lk->pid = 0;
    8000663a:	fe843783          	ld	a5,-24(s0)
    8000663e:	0207a423          	sw	zero,40(a5)
  wakeup(lk);
    80006642:	fe843503          	ld	a0,-24(s0)
    80006646:	ffffd097          	auipc	ra,0xffffd
    8000664a:	e3e080e7          	jalr	-450(ra) # 80003484 <wakeup>
  release(&lk->lk);
    8000664e:	fe843783          	ld	a5,-24(s0)
    80006652:	07a1                	addi	a5,a5,8
    80006654:	853e                	mv	a0,a5
    80006656:	ffffb097          	auipc	ra,0xffffb
    8000665a:	c8c080e7          	jalr	-884(ra) # 800012e2 <release>
}
    8000665e:	0001                	nop
    80006660:	60e2                	ld	ra,24(sp)
    80006662:	6442                	ld	s0,16(sp)
    80006664:	6105                	addi	sp,sp,32
    80006666:	8082                	ret

0000000080006668 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80006668:	7139                	addi	sp,sp,-64
    8000666a:	fc06                	sd	ra,56(sp)
    8000666c:	f822                	sd	s0,48(sp)
    8000666e:	f426                	sd	s1,40(sp)
    80006670:	0080                	addi	s0,sp,64
    80006672:	fca43423          	sd	a0,-56(s0)
  int r;
  
  acquire(&lk->lk);
    80006676:	fc843783          	ld	a5,-56(s0)
    8000667a:	07a1                	addi	a5,a5,8
    8000667c:	853e                	mv	a0,a5
    8000667e:	ffffb097          	auipc	ra,0xffffb
    80006682:	c00080e7          	jalr	-1024(ra) # 8000127e <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80006686:	fc843783          	ld	a5,-56(s0)
    8000668a:	439c                	lw	a5,0(a5)
    8000668c:	cf99                	beqz	a5,800066aa <holdingsleep+0x42>
    8000668e:	fc843783          	ld	a5,-56(s0)
    80006692:	5784                	lw	s1,40(a5)
    80006694:	ffffc097          	auipc	ra,0xffffc
    80006698:	1b2080e7          	jalr	434(ra) # 80002846 <myproc>
    8000669c:	87aa                	mv	a5,a0
    8000669e:	5b9c                	lw	a5,48(a5)
    800066a0:	8726                	mv	a4,s1
    800066a2:	00f71463          	bne	a4,a5,800066aa <holdingsleep+0x42>
    800066a6:	4785                	li	a5,1
    800066a8:	a011                	j	800066ac <holdingsleep+0x44>
    800066aa:	4781                	li	a5,0
    800066ac:	fcf42e23          	sw	a5,-36(s0)
  release(&lk->lk);
    800066b0:	fc843783          	ld	a5,-56(s0)
    800066b4:	07a1                	addi	a5,a5,8
    800066b6:	853e                	mv	a0,a5
    800066b8:	ffffb097          	auipc	ra,0xffffb
    800066bc:	c2a080e7          	jalr	-982(ra) # 800012e2 <release>
  return r;
    800066c0:	fdc42783          	lw	a5,-36(s0)
}
    800066c4:	853e                	mv	a0,a5
    800066c6:	70e2                	ld	ra,56(sp)
    800066c8:	7442                	ld	s0,48(sp)
    800066ca:	74a2                	ld	s1,40(sp)
    800066cc:	6121                	addi	sp,sp,64
    800066ce:	8082                	ret

00000000800066d0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800066d0:	1141                	addi	sp,sp,-16
    800066d2:	e406                	sd	ra,8(sp)
    800066d4:	e022                	sd	s0,0(sp)
    800066d6:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800066d8:	00005597          	auipc	a1,0x5
    800066dc:	ed858593          	addi	a1,a1,-296 # 8000b5b0 <etext+0x5b0>
    800066e0:	00020517          	auipc	a0,0x20
    800066e4:	b4050513          	addi	a0,a0,-1216 # 80026220 <ftable>
    800066e8:	ffffb097          	auipc	ra,0xffffb
    800066ec:	b66080e7          	jalr	-1178(ra) # 8000124e <initlock>
}
    800066f0:	0001                	nop
    800066f2:	60a2                	ld	ra,8(sp)
    800066f4:	6402                	ld	s0,0(sp)
    800066f6:	0141                	addi	sp,sp,16
    800066f8:	8082                	ret

00000000800066fa <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800066fa:	1101                	addi	sp,sp,-32
    800066fc:	ec06                	sd	ra,24(sp)
    800066fe:	e822                	sd	s0,16(sp)
    80006700:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80006702:	00020517          	auipc	a0,0x20
    80006706:	b1e50513          	addi	a0,a0,-1250 # 80026220 <ftable>
    8000670a:	ffffb097          	auipc	ra,0xffffb
    8000670e:	b74080e7          	jalr	-1164(ra) # 8000127e <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80006712:	00020797          	auipc	a5,0x20
    80006716:	b2678793          	addi	a5,a5,-1242 # 80026238 <ftable+0x18>
    8000671a:	fef43423          	sd	a5,-24(s0)
    8000671e:	a815                	j	80006752 <filealloc+0x58>
    if(f->ref == 0){
    80006720:	fe843783          	ld	a5,-24(s0)
    80006724:	43dc                	lw	a5,4(a5)
    80006726:	e385                	bnez	a5,80006746 <filealloc+0x4c>
      f->ref = 1;
    80006728:	fe843783          	ld	a5,-24(s0)
    8000672c:	4705                	li	a4,1
    8000672e:	c3d8                	sw	a4,4(a5)
      release(&ftable.lock);
    80006730:	00020517          	auipc	a0,0x20
    80006734:	af050513          	addi	a0,a0,-1296 # 80026220 <ftable>
    80006738:	ffffb097          	auipc	ra,0xffffb
    8000673c:	baa080e7          	jalr	-1110(ra) # 800012e2 <release>
      return f;
    80006740:	fe843783          	ld	a5,-24(s0)
    80006744:	a805                	j	80006774 <filealloc+0x7a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80006746:	fe843783          	ld	a5,-24(s0)
    8000674a:	02878793          	addi	a5,a5,40
    8000674e:	fef43423          	sd	a5,-24(s0)
    80006752:	00021797          	auipc	a5,0x21
    80006756:	a8678793          	addi	a5,a5,-1402 # 800271d8 <disk>
    8000675a:	fe843703          	ld	a4,-24(s0)
    8000675e:	fcf761e3          	bltu	a4,a5,80006720 <filealloc+0x26>
    }
  }
  release(&ftable.lock);
    80006762:	00020517          	auipc	a0,0x20
    80006766:	abe50513          	addi	a0,a0,-1346 # 80026220 <ftable>
    8000676a:	ffffb097          	auipc	ra,0xffffb
    8000676e:	b78080e7          	jalr	-1160(ra) # 800012e2 <release>
  return 0;
    80006772:	4781                	li	a5,0
}
    80006774:	853e                	mv	a0,a5
    80006776:	60e2                	ld	ra,24(sp)
    80006778:	6442                	ld	s0,16(sp)
    8000677a:	6105                	addi	sp,sp,32
    8000677c:	8082                	ret

000000008000677e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000677e:	1101                	addi	sp,sp,-32
    80006780:	ec06                	sd	ra,24(sp)
    80006782:	e822                	sd	s0,16(sp)
    80006784:	1000                	addi	s0,sp,32
    80006786:	fea43423          	sd	a0,-24(s0)
  acquire(&ftable.lock);
    8000678a:	00020517          	auipc	a0,0x20
    8000678e:	a9650513          	addi	a0,a0,-1386 # 80026220 <ftable>
    80006792:	ffffb097          	auipc	ra,0xffffb
    80006796:	aec080e7          	jalr	-1300(ra) # 8000127e <acquire>
  if(f->ref < 1)
    8000679a:	fe843783          	ld	a5,-24(s0)
    8000679e:	43dc                	lw	a5,4(a5)
    800067a0:	00f04a63          	bgtz	a5,800067b4 <filedup+0x36>
    panic("filedup");
    800067a4:	00005517          	auipc	a0,0x5
    800067a8:	e1450513          	addi	a0,a0,-492 # 8000b5b8 <etext+0x5b8>
    800067ac:	ffffa097          	auipc	ra,0xffffa
    800067b0:	4de080e7          	jalr	1246(ra) # 80000c8a <panic>
  f->ref++;
    800067b4:	fe843783          	ld	a5,-24(s0)
    800067b8:	43dc                	lw	a5,4(a5)
    800067ba:	2785                	addiw	a5,a5,1
    800067bc:	0007871b          	sext.w	a4,a5
    800067c0:	fe843783          	ld	a5,-24(s0)
    800067c4:	c3d8                	sw	a4,4(a5)
  release(&ftable.lock);
    800067c6:	00020517          	auipc	a0,0x20
    800067ca:	a5a50513          	addi	a0,a0,-1446 # 80026220 <ftable>
    800067ce:	ffffb097          	auipc	ra,0xffffb
    800067d2:	b14080e7          	jalr	-1260(ra) # 800012e2 <release>
  return f;
    800067d6:	fe843783          	ld	a5,-24(s0)
}
    800067da:	853e                	mv	a0,a5
    800067dc:	60e2                	ld	ra,24(sp)
    800067de:	6442                	ld	s0,16(sp)
    800067e0:	6105                	addi	sp,sp,32
    800067e2:	8082                	ret

00000000800067e4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800067e4:	715d                	addi	sp,sp,-80
    800067e6:	e486                	sd	ra,72(sp)
    800067e8:	e0a2                	sd	s0,64(sp)
    800067ea:	0880                	addi	s0,sp,80
    800067ec:	faa43c23          	sd	a0,-72(s0)
  struct file ff;

  acquire(&ftable.lock);
    800067f0:	00020517          	auipc	a0,0x20
    800067f4:	a3050513          	addi	a0,a0,-1488 # 80026220 <ftable>
    800067f8:	ffffb097          	auipc	ra,0xffffb
    800067fc:	a86080e7          	jalr	-1402(ra) # 8000127e <acquire>
  if(f->ref < 1)
    80006800:	fb843783          	ld	a5,-72(s0)
    80006804:	43dc                	lw	a5,4(a5)
    80006806:	00f04a63          	bgtz	a5,8000681a <fileclose+0x36>
    panic("fileclose");
    8000680a:	00005517          	auipc	a0,0x5
    8000680e:	db650513          	addi	a0,a0,-586 # 8000b5c0 <etext+0x5c0>
    80006812:	ffffa097          	auipc	ra,0xffffa
    80006816:	478080e7          	jalr	1144(ra) # 80000c8a <panic>
  if(--f->ref > 0){
    8000681a:	fb843783          	ld	a5,-72(s0)
    8000681e:	43dc                	lw	a5,4(a5)
    80006820:	37fd                	addiw	a5,a5,-1
    80006822:	0007871b          	sext.w	a4,a5
    80006826:	fb843783          	ld	a5,-72(s0)
    8000682a:	c3d8                	sw	a4,4(a5)
    8000682c:	fb843783          	ld	a5,-72(s0)
    80006830:	43dc                	lw	a5,4(a5)
    80006832:	00f05b63          	blez	a5,80006848 <fileclose+0x64>
    release(&ftable.lock);
    80006836:	00020517          	auipc	a0,0x20
    8000683a:	9ea50513          	addi	a0,a0,-1558 # 80026220 <ftable>
    8000683e:	ffffb097          	auipc	ra,0xffffb
    80006842:	aa4080e7          	jalr	-1372(ra) # 800012e2 <release>
    80006846:	a879                	j	800068e4 <fileclose+0x100>
    return;
  }
  ff = *f;
    80006848:	fb843783          	ld	a5,-72(s0)
    8000684c:	638c                	ld	a1,0(a5)
    8000684e:	6790                	ld	a2,8(a5)
    80006850:	6b94                	ld	a3,16(a5)
    80006852:	6f98                	ld	a4,24(a5)
    80006854:	739c                	ld	a5,32(a5)
    80006856:	fcb43423          	sd	a1,-56(s0)
    8000685a:	fcc43823          	sd	a2,-48(s0)
    8000685e:	fcd43c23          	sd	a3,-40(s0)
    80006862:	fee43023          	sd	a4,-32(s0)
    80006866:	fef43423          	sd	a5,-24(s0)
  f->ref = 0;
    8000686a:	fb843783          	ld	a5,-72(s0)
    8000686e:	0007a223          	sw	zero,4(a5)
  f->type = FD_NONE;
    80006872:	fb843783          	ld	a5,-72(s0)
    80006876:	0007a023          	sw	zero,0(a5)
  release(&ftable.lock);
    8000687a:	00020517          	auipc	a0,0x20
    8000687e:	9a650513          	addi	a0,a0,-1626 # 80026220 <ftable>
    80006882:	ffffb097          	auipc	ra,0xffffb
    80006886:	a60080e7          	jalr	-1440(ra) # 800012e2 <release>

  if(ff.type == FD_PIPE){
    8000688a:	fc842783          	lw	a5,-56(s0)
    8000688e:	873e                	mv	a4,a5
    80006890:	4785                	li	a5,1
    80006892:	00f71e63          	bne	a4,a5,800068ae <fileclose+0xca>
    pipeclose(ff.pipe, ff.writable);
    80006896:	fd843783          	ld	a5,-40(s0)
    8000689a:	fd144703          	lbu	a4,-47(s0)
    8000689e:	2701                	sext.w	a4,a4
    800068a0:	85ba                	mv	a1,a4
    800068a2:	853e                	mv	a0,a5
    800068a4:	00000097          	auipc	ra,0x0
    800068a8:	5a6080e7          	jalr	1446(ra) # 80006e4a <pipeclose>
    800068ac:	a825                	j	800068e4 <fileclose+0x100>
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800068ae:	fc842783          	lw	a5,-56(s0)
    800068b2:	873e                	mv	a4,a5
    800068b4:	4789                	li	a5,2
    800068b6:	00f70863          	beq	a4,a5,800068c6 <fileclose+0xe2>
    800068ba:	fc842783          	lw	a5,-56(s0)
    800068be:	873e                	mv	a4,a5
    800068c0:	478d                	li	a5,3
    800068c2:	02f71163          	bne	a4,a5,800068e4 <fileclose+0x100>
    begin_op();
    800068c6:	00000097          	auipc	ra,0x0
    800068ca:	884080e7          	jalr	-1916(ra) # 8000614a <begin_op>
    iput(ff.ip);
    800068ce:	fe043783          	ld	a5,-32(s0)
    800068d2:	853e                	mv	a0,a5
    800068d4:	fffff097          	auipc	ra,0xfffff
    800068d8:	970080e7          	jalr	-1680(ra) # 80005244 <iput>
    end_op();
    800068dc:	00000097          	auipc	ra,0x0
    800068e0:	930080e7          	jalr	-1744(ra) # 8000620c <end_op>
  }
}
    800068e4:	60a6                	ld	ra,72(sp)
    800068e6:	6406                	ld	s0,64(sp)
    800068e8:	6161                	addi	sp,sp,80
    800068ea:	8082                	ret

00000000800068ec <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800068ec:	7139                	addi	sp,sp,-64
    800068ee:	fc06                	sd	ra,56(sp)
    800068f0:	f822                	sd	s0,48(sp)
    800068f2:	0080                	addi	s0,sp,64
    800068f4:	fca43423          	sd	a0,-56(s0)
    800068f8:	fcb43023          	sd	a1,-64(s0)
  struct proc *p = myproc();
    800068fc:	ffffc097          	auipc	ra,0xffffc
    80006900:	f4a080e7          	jalr	-182(ra) # 80002846 <myproc>
    80006904:	fea43423          	sd	a0,-24(s0)
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80006908:	fc843783          	ld	a5,-56(s0)
    8000690c:	439c                	lw	a5,0(a5)
    8000690e:	873e                	mv	a4,a5
    80006910:	4789                	li	a5,2
    80006912:	00f70963          	beq	a4,a5,80006924 <filestat+0x38>
    80006916:	fc843783          	ld	a5,-56(s0)
    8000691a:	439c                	lw	a5,0(a5)
    8000691c:	873e                	mv	a4,a5
    8000691e:	478d                	li	a5,3
    80006920:	06f71263          	bne	a4,a5,80006984 <filestat+0x98>
    ilock(f->ip);
    80006924:	fc843783          	ld	a5,-56(s0)
    80006928:	6f9c                	ld	a5,24(a5)
    8000692a:	853e                	mv	a0,a5
    8000692c:	ffffe097          	auipc	ra,0xffffe
    80006930:	78a080e7          	jalr	1930(ra) # 800050b6 <ilock>
    stati(f->ip, &st);
    80006934:	fc843783          	ld	a5,-56(s0)
    80006938:	6f9c                	ld	a5,24(a5)
    8000693a:	fd040713          	addi	a4,s0,-48
    8000693e:	85ba                	mv	a1,a4
    80006940:	853e                	mv	a0,a5
    80006942:	fffff097          	auipc	ra,0xfffff
    80006946:	cc6080e7          	jalr	-826(ra) # 80005608 <stati>
    iunlock(f->ip);
    8000694a:	fc843783          	ld	a5,-56(s0)
    8000694e:	6f9c                	ld	a5,24(a5)
    80006950:	853e                	mv	a0,a5
    80006952:	fffff097          	auipc	ra,0xfffff
    80006956:	898080e7          	jalr	-1896(ra) # 800051ea <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000695a:	fe843783          	ld	a5,-24(s0)
    8000695e:	6bbc                	ld	a5,80(a5)
    80006960:	fd040713          	addi	a4,s0,-48
    80006964:	46e1                	li	a3,24
    80006966:	863a                	mv	a2,a4
    80006968:	fc043583          	ld	a1,-64(s0)
    8000696c:	853e                	mv	a0,a5
    8000696e:	ffffc097          	auipc	ra,0xffffc
    80006972:	9a2080e7          	jalr	-1630(ra) # 80002310 <copyout>
    80006976:	87aa                	mv	a5,a0
    80006978:	0007d463          	bgez	a5,80006980 <filestat+0x94>
      return -1;
    8000697c:	57fd                	li	a5,-1
    8000697e:	a021                	j	80006986 <filestat+0x9a>
    return 0;
    80006980:	4781                	li	a5,0
    80006982:	a011                	j	80006986 <filestat+0x9a>
  }
  return -1;
    80006984:	57fd                	li	a5,-1
}
    80006986:	853e                	mv	a0,a5
    80006988:	70e2                	ld	ra,56(sp)
    8000698a:	7442                	ld	s0,48(sp)
    8000698c:	6121                	addi	sp,sp,64
    8000698e:	8082                	ret

0000000080006990 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80006990:	7139                	addi	sp,sp,-64
    80006992:	fc06                	sd	ra,56(sp)
    80006994:	f822                	sd	s0,48(sp)
    80006996:	0080                	addi	s0,sp,64
    80006998:	fca43c23          	sd	a0,-40(s0)
    8000699c:	fcb43823          	sd	a1,-48(s0)
    800069a0:	87b2                	mv	a5,a2
    800069a2:	fcf42623          	sw	a5,-52(s0)
  int r = 0;
    800069a6:	fe042623          	sw	zero,-20(s0)

  if(f->readable == 0)
    800069aa:	fd843783          	ld	a5,-40(s0)
    800069ae:	0087c783          	lbu	a5,8(a5)
    800069b2:	e399                	bnez	a5,800069b8 <fileread+0x28>
    return -1;
    800069b4:	57fd                	li	a5,-1
    800069b6:	a23d                	j	80006ae4 <fileread+0x154>

  if(f->type == FD_PIPE){
    800069b8:	fd843783          	ld	a5,-40(s0)
    800069bc:	439c                	lw	a5,0(a5)
    800069be:	873e                	mv	a4,a5
    800069c0:	4785                	li	a5,1
    800069c2:	02f71363          	bne	a4,a5,800069e8 <fileread+0x58>
    r = piperead(f->pipe, addr, n);
    800069c6:	fd843783          	ld	a5,-40(s0)
    800069ca:	6b9c                	ld	a5,16(a5)
    800069cc:	fcc42703          	lw	a4,-52(s0)
    800069d0:	863a                	mv	a2,a4
    800069d2:	fd043583          	ld	a1,-48(s0)
    800069d6:	853e                	mv	a0,a5
    800069d8:	00000097          	auipc	ra,0x0
    800069dc:	66e080e7          	jalr	1646(ra) # 80007046 <piperead>
    800069e0:	87aa                	mv	a5,a0
    800069e2:	fef42623          	sw	a5,-20(s0)
    800069e6:	a8ed                	j	80006ae0 <fileread+0x150>
  } else if(f->type == FD_DEVICE){
    800069e8:	fd843783          	ld	a5,-40(s0)
    800069ec:	439c                	lw	a5,0(a5)
    800069ee:	873e                	mv	a4,a5
    800069f0:	478d                	li	a5,3
    800069f2:	06f71463          	bne	a4,a5,80006a5a <fileread+0xca>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800069f6:	fd843783          	ld	a5,-40(s0)
    800069fa:	02479783          	lh	a5,36(a5)
    800069fe:	0207c663          	bltz	a5,80006a2a <fileread+0x9a>
    80006a02:	fd843783          	ld	a5,-40(s0)
    80006a06:	02479783          	lh	a5,36(a5)
    80006a0a:	873e                	mv	a4,a5
    80006a0c:	47a5                	li	a5,9
    80006a0e:	00e7ce63          	blt	a5,a4,80006a2a <fileread+0x9a>
    80006a12:	fd843783          	ld	a5,-40(s0)
    80006a16:	02479783          	lh	a5,36(a5)
    80006a1a:	0001f717          	auipc	a4,0x1f
    80006a1e:	76670713          	addi	a4,a4,1894 # 80026180 <devsw>
    80006a22:	0792                	slli	a5,a5,0x4
    80006a24:	97ba                	add	a5,a5,a4
    80006a26:	639c                	ld	a5,0(a5)
    80006a28:	e399                	bnez	a5,80006a2e <fileread+0x9e>
      return -1;
    80006a2a:	57fd                	li	a5,-1
    80006a2c:	a865                	j	80006ae4 <fileread+0x154>
    r = devsw[f->major].read(1, addr, n);
    80006a2e:	fd843783          	ld	a5,-40(s0)
    80006a32:	02479783          	lh	a5,36(a5)
    80006a36:	0001f717          	auipc	a4,0x1f
    80006a3a:	74a70713          	addi	a4,a4,1866 # 80026180 <devsw>
    80006a3e:	0792                	slli	a5,a5,0x4
    80006a40:	97ba                	add	a5,a5,a4
    80006a42:	639c                	ld	a5,0(a5)
    80006a44:	fcc42703          	lw	a4,-52(s0)
    80006a48:	863a                	mv	a2,a4
    80006a4a:	fd043583          	ld	a1,-48(s0)
    80006a4e:	4505                	li	a0,1
    80006a50:	9782                	jalr	a5
    80006a52:	87aa                	mv	a5,a0
    80006a54:	fef42623          	sw	a5,-20(s0)
    80006a58:	a061                	j	80006ae0 <fileread+0x150>
  } else if(f->type == FD_INODE){
    80006a5a:	fd843783          	ld	a5,-40(s0)
    80006a5e:	439c                	lw	a5,0(a5)
    80006a60:	873e                	mv	a4,a5
    80006a62:	4789                	li	a5,2
    80006a64:	06f71663          	bne	a4,a5,80006ad0 <fileread+0x140>
    ilock(f->ip);
    80006a68:	fd843783          	ld	a5,-40(s0)
    80006a6c:	6f9c                	ld	a5,24(a5)
    80006a6e:	853e                	mv	a0,a5
    80006a70:	ffffe097          	auipc	ra,0xffffe
    80006a74:	646080e7          	jalr	1606(ra) # 800050b6 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80006a78:	fd843783          	ld	a5,-40(s0)
    80006a7c:	6f88                	ld	a0,24(a5)
    80006a7e:	fd843783          	ld	a5,-40(s0)
    80006a82:	539c                	lw	a5,32(a5)
    80006a84:	fcc42703          	lw	a4,-52(s0)
    80006a88:	86be                	mv	a3,a5
    80006a8a:	fd043603          	ld	a2,-48(s0)
    80006a8e:	4585                	li	a1,1
    80006a90:	fffff097          	auipc	ra,0xfffff
    80006a94:	bdc080e7          	jalr	-1060(ra) # 8000566c <readi>
    80006a98:	87aa                	mv	a5,a0
    80006a9a:	fef42623          	sw	a5,-20(s0)
    80006a9e:	fec42783          	lw	a5,-20(s0)
    80006aa2:	2781                	sext.w	a5,a5
    80006aa4:	00f05d63          	blez	a5,80006abe <fileread+0x12e>
      f->off += r;
    80006aa8:	fd843783          	ld	a5,-40(s0)
    80006aac:	5398                	lw	a4,32(a5)
    80006aae:	fec42783          	lw	a5,-20(s0)
    80006ab2:	9fb9                	addw	a5,a5,a4
    80006ab4:	0007871b          	sext.w	a4,a5
    80006ab8:	fd843783          	ld	a5,-40(s0)
    80006abc:	d398                	sw	a4,32(a5)
    iunlock(f->ip);
    80006abe:	fd843783          	ld	a5,-40(s0)
    80006ac2:	6f9c                	ld	a5,24(a5)
    80006ac4:	853e                	mv	a0,a5
    80006ac6:	ffffe097          	auipc	ra,0xffffe
    80006aca:	724080e7          	jalr	1828(ra) # 800051ea <iunlock>
    80006ace:	a809                	j	80006ae0 <fileread+0x150>
  } else {
    panic("fileread");
    80006ad0:	00005517          	auipc	a0,0x5
    80006ad4:	b0050513          	addi	a0,a0,-1280 # 8000b5d0 <etext+0x5d0>
    80006ad8:	ffffa097          	auipc	ra,0xffffa
    80006adc:	1b2080e7          	jalr	434(ra) # 80000c8a <panic>
  }

  return r;
    80006ae0:	fec42783          	lw	a5,-20(s0)
}
    80006ae4:	853e                	mv	a0,a5
    80006ae6:	70e2                	ld	ra,56(sp)
    80006ae8:	7442                	ld	s0,48(sp)
    80006aea:	6121                	addi	sp,sp,64
    80006aec:	8082                	ret

0000000080006aee <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80006aee:	715d                	addi	sp,sp,-80
    80006af0:	e486                	sd	ra,72(sp)
    80006af2:	e0a2                	sd	s0,64(sp)
    80006af4:	0880                	addi	s0,sp,80
    80006af6:	fca43423          	sd	a0,-56(s0)
    80006afa:	fcb43023          	sd	a1,-64(s0)
    80006afe:	87b2                	mv	a5,a2
    80006b00:	faf42e23          	sw	a5,-68(s0)
  int r, ret = 0;
    80006b04:	fe042623          	sw	zero,-20(s0)

  if(f->writable == 0)
    80006b08:	fc843783          	ld	a5,-56(s0)
    80006b0c:	0097c783          	lbu	a5,9(a5)
    80006b10:	e399                	bnez	a5,80006b16 <filewrite+0x28>
    return -1;
    80006b12:	57fd                	li	a5,-1
    80006b14:	aae1                	j	80006cec <filewrite+0x1fe>

  if(f->type == FD_PIPE){
    80006b16:	fc843783          	ld	a5,-56(s0)
    80006b1a:	439c                	lw	a5,0(a5)
    80006b1c:	873e                	mv	a4,a5
    80006b1e:	4785                	li	a5,1
    80006b20:	02f71363          	bne	a4,a5,80006b46 <filewrite+0x58>
    ret = pipewrite(f->pipe, addr, n);
    80006b24:	fc843783          	ld	a5,-56(s0)
    80006b28:	6b9c                	ld	a5,16(a5)
    80006b2a:	fbc42703          	lw	a4,-68(s0)
    80006b2e:	863a                	mv	a2,a4
    80006b30:	fc043583          	ld	a1,-64(s0)
    80006b34:	853e                	mv	a0,a5
    80006b36:	00000097          	auipc	ra,0x0
    80006b3a:	3bc080e7          	jalr	956(ra) # 80006ef2 <pipewrite>
    80006b3e:	87aa                	mv	a5,a0
    80006b40:	fef42623          	sw	a5,-20(s0)
    80006b44:	a255                	j	80006ce8 <filewrite+0x1fa>
  } else if(f->type == FD_DEVICE){
    80006b46:	fc843783          	ld	a5,-56(s0)
    80006b4a:	439c                	lw	a5,0(a5)
    80006b4c:	873e                	mv	a4,a5
    80006b4e:	478d                	li	a5,3
    80006b50:	06f71463          	bne	a4,a5,80006bb8 <filewrite+0xca>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80006b54:	fc843783          	ld	a5,-56(s0)
    80006b58:	02479783          	lh	a5,36(a5)
    80006b5c:	0207c663          	bltz	a5,80006b88 <filewrite+0x9a>
    80006b60:	fc843783          	ld	a5,-56(s0)
    80006b64:	02479783          	lh	a5,36(a5)
    80006b68:	873e                	mv	a4,a5
    80006b6a:	47a5                	li	a5,9
    80006b6c:	00e7ce63          	blt	a5,a4,80006b88 <filewrite+0x9a>
    80006b70:	fc843783          	ld	a5,-56(s0)
    80006b74:	02479783          	lh	a5,36(a5)
    80006b78:	0001f717          	auipc	a4,0x1f
    80006b7c:	60870713          	addi	a4,a4,1544 # 80026180 <devsw>
    80006b80:	0792                	slli	a5,a5,0x4
    80006b82:	97ba                	add	a5,a5,a4
    80006b84:	679c                	ld	a5,8(a5)
    80006b86:	e399                	bnez	a5,80006b8c <filewrite+0x9e>
      return -1;
    80006b88:	57fd                	li	a5,-1
    80006b8a:	a28d                	j	80006cec <filewrite+0x1fe>
    ret = devsw[f->major].write(1, addr, n);
    80006b8c:	fc843783          	ld	a5,-56(s0)
    80006b90:	02479783          	lh	a5,36(a5)
    80006b94:	0001f717          	auipc	a4,0x1f
    80006b98:	5ec70713          	addi	a4,a4,1516 # 80026180 <devsw>
    80006b9c:	0792                	slli	a5,a5,0x4
    80006b9e:	97ba                	add	a5,a5,a4
    80006ba0:	679c                	ld	a5,8(a5)
    80006ba2:	fbc42703          	lw	a4,-68(s0)
    80006ba6:	863a                	mv	a2,a4
    80006ba8:	fc043583          	ld	a1,-64(s0)
    80006bac:	4505                	li	a0,1
    80006bae:	9782                	jalr	a5
    80006bb0:	87aa                	mv	a5,a0
    80006bb2:	fef42623          	sw	a5,-20(s0)
    80006bb6:	aa0d                	j	80006ce8 <filewrite+0x1fa>
  } else if(f->type == FD_INODE){
    80006bb8:	fc843783          	ld	a5,-56(s0)
    80006bbc:	439c                	lw	a5,0(a5)
    80006bbe:	873e                	mv	a4,a5
    80006bc0:	4789                	li	a5,2
    80006bc2:	10f71b63          	bne	a4,a5,80006cd8 <filewrite+0x1ea>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    80006bc6:	6785                	lui	a5,0x1
    80006bc8:	c0078793          	addi	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    80006bcc:	fef42023          	sw	a5,-32(s0)
    int i = 0;
    80006bd0:	fe042423          	sw	zero,-24(s0)
    while(i < n){
    80006bd4:	a0f9                	j	80006ca2 <filewrite+0x1b4>
      int n1 = n - i;
    80006bd6:	fbc42783          	lw	a5,-68(s0)
    80006bda:	873e                	mv	a4,a5
    80006bdc:	fe842783          	lw	a5,-24(s0)
    80006be0:	40f707bb          	subw	a5,a4,a5
    80006be4:	fef42223          	sw	a5,-28(s0)
      if(n1 > max)
    80006be8:	fe442783          	lw	a5,-28(s0)
    80006bec:	873e                	mv	a4,a5
    80006bee:	fe042783          	lw	a5,-32(s0)
    80006bf2:	2701                	sext.w	a4,a4
    80006bf4:	2781                	sext.w	a5,a5
    80006bf6:	00e7d663          	bge	a5,a4,80006c02 <filewrite+0x114>
        n1 = max;
    80006bfa:	fe042783          	lw	a5,-32(s0)
    80006bfe:	fef42223          	sw	a5,-28(s0)

      begin_op();
    80006c02:	fffff097          	auipc	ra,0xfffff
    80006c06:	548080e7          	jalr	1352(ra) # 8000614a <begin_op>
      ilock(f->ip);
    80006c0a:	fc843783          	ld	a5,-56(s0)
    80006c0e:	6f9c                	ld	a5,24(a5)
    80006c10:	853e                	mv	a0,a5
    80006c12:	ffffe097          	auipc	ra,0xffffe
    80006c16:	4a4080e7          	jalr	1188(ra) # 800050b6 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80006c1a:	fc843783          	ld	a5,-56(s0)
    80006c1e:	6f88                	ld	a0,24(a5)
    80006c20:	fe842703          	lw	a4,-24(s0)
    80006c24:	fc043783          	ld	a5,-64(s0)
    80006c28:	00f70633          	add	a2,a4,a5
    80006c2c:	fc843783          	ld	a5,-56(s0)
    80006c30:	539c                	lw	a5,32(a5)
    80006c32:	fe442703          	lw	a4,-28(s0)
    80006c36:	86be                	mv	a3,a5
    80006c38:	4585                	li	a1,1
    80006c3a:	fffff097          	auipc	ra,0xfffff
    80006c3e:	bd0080e7          	jalr	-1072(ra) # 8000580a <writei>
    80006c42:	87aa                	mv	a5,a0
    80006c44:	fcf42e23          	sw	a5,-36(s0)
    80006c48:	fdc42783          	lw	a5,-36(s0)
    80006c4c:	2781                	sext.w	a5,a5
    80006c4e:	00f05d63          	blez	a5,80006c68 <filewrite+0x17a>
        f->off += r;
    80006c52:	fc843783          	ld	a5,-56(s0)
    80006c56:	5398                	lw	a4,32(a5)
    80006c58:	fdc42783          	lw	a5,-36(s0)
    80006c5c:	9fb9                	addw	a5,a5,a4
    80006c5e:	0007871b          	sext.w	a4,a5
    80006c62:	fc843783          	ld	a5,-56(s0)
    80006c66:	d398                	sw	a4,32(a5)
      iunlock(f->ip);
    80006c68:	fc843783          	ld	a5,-56(s0)
    80006c6c:	6f9c                	ld	a5,24(a5)
    80006c6e:	853e                	mv	a0,a5
    80006c70:	ffffe097          	auipc	ra,0xffffe
    80006c74:	57a080e7          	jalr	1402(ra) # 800051ea <iunlock>
      end_op();
    80006c78:	fffff097          	auipc	ra,0xfffff
    80006c7c:	594080e7          	jalr	1428(ra) # 8000620c <end_op>

      if(r != n1){
    80006c80:	fdc42783          	lw	a5,-36(s0)
    80006c84:	873e                	mv	a4,a5
    80006c86:	fe442783          	lw	a5,-28(s0)
    80006c8a:	2701                	sext.w	a4,a4
    80006c8c:	2781                	sext.w	a5,a5
    80006c8e:	02f71463          	bne	a4,a5,80006cb6 <filewrite+0x1c8>
        // error from writei
        break;
      }
      i += r;
    80006c92:	fe842783          	lw	a5,-24(s0)
    80006c96:	873e                	mv	a4,a5
    80006c98:	fdc42783          	lw	a5,-36(s0)
    80006c9c:	9fb9                	addw	a5,a5,a4
    80006c9e:	fef42423          	sw	a5,-24(s0)
    while(i < n){
    80006ca2:	fe842783          	lw	a5,-24(s0)
    80006ca6:	873e                	mv	a4,a5
    80006ca8:	fbc42783          	lw	a5,-68(s0)
    80006cac:	2701                	sext.w	a4,a4
    80006cae:	2781                	sext.w	a5,a5
    80006cb0:	f2f743e3          	blt	a4,a5,80006bd6 <filewrite+0xe8>
    80006cb4:	a011                	j	80006cb8 <filewrite+0x1ca>
        break;
    80006cb6:	0001                	nop
    }
    ret = (i == n ? n : -1);
    80006cb8:	fe842783          	lw	a5,-24(s0)
    80006cbc:	873e                	mv	a4,a5
    80006cbe:	fbc42783          	lw	a5,-68(s0)
    80006cc2:	2701                	sext.w	a4,a4
    80006cc4:	2781                	sext.w	a5,a5
    80006cc6:	00f71563          	bne	a4,a5,80006cd0 <filewrite+0x1e2>
    80006cca:	fbc42783          	lw	a5,-68(s0)
    80006cce:	a011                	j	80006cd2 <filewrite+0x1e4>
    80006cd0:	57fd                	li	a5,-1
    80006cd2:	fef42623          	sw	a5,-20(s0)
    80006cd6:	a809                	j	80006ce8 <filewrite+0x1fa>
  } else {
    panic("filewrite");
    80006cd8:	00005517          	auipc	a0,0x5
    80006cdc:	90850513          	addi	a0,a0,-1784 # 8000b5e0 <etext+0x5e0>
    80006ce0:	ffffa097          	auipc	ra,0xffffa
    80006ce4:	faa080e7          	jalr	-86(ra) # 80000c8a <panic>
  }

  return ret;
    80006ce8:	fec42783          	lw	a5,-20(s0)
}
    80006cec:	853e                	mv	a0,a5
    80006cee:	60a6                	ld	ra,72(sp)
    80006cf0:	6406                	ld	s0,64(sp)
    80006cf2:	6161                	addi	sp,sp,80
    80006cf4:	8082                	ret

0000000080006cf6 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80006cf6:	7179                	addi	sp,sp,-48
    80006cf8:	f406                	sd	ra,40(sp)
    80006cfa:	f022                	sd	s0,32(sp)
    80006cfc:	1800                	addi	s0,sp,48
    80006cfe:	fca43c23          	sd	a0,-40(s0)
    80006d02:	fcb43823          	sd	a1,-48(s0)
  struct pipe *pi;

  pi = 0;
    80006d06:	fe043423          	sd	zero,-24(s0)
  *f0 = *f1 = 0;
    80006d0a:	fd043783          	ld	a5,-48(s0)
    80006d0e:	0007b023          	sd	zero,0(a5)
    80006d12:	fd043783          	ld	a5,-48(s0)
    80006d16:	6398                	ld	a4,0(a5)
    80006d18:	fd843783          	ld	a5,-40(s0)
    80006d1c:	e398                	sd	a4,0(a5)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80006d1e:	00000097          	auipc	ra,0x0
    80006d22:	9dc080e7          	jalr	-1572(ra) # 800066fa <filealloc>
    80006d26:	872a                	mv	a4,a0
    80006d28:	fd843783          	ld	a5,-40(s0)
    80006d2c:	e398                	sd	a4,0(a5)
    80006d2e:	fd843783          	ld	a5,-40(s0)
    80006d32:	639c                	ld	a5,0(a5)
    80006d34:	c3e9                	beqz	a5,80006df6 <pipealloc+0x100>
    80006d36:	00000097          	auipc	ra,0x0
    80006d3a:	9c4080e7          	jalr	-1596(ra) # 800066fa <filealloc>
    80006d3e:	872a                	mv	a4,a0
    80006d40:	fd043783          	ld	a5,-48(s0)
    80006d44:	e398                	sd	a4,0(a5)
    80006d46:	fd043783          	ld	a5,-48(s0)
    80006d4a:	639c                	ld	a5,0(a5)
    80006d4c:	c7cd                	beqz	a5,80006df6 <pipealloc+0x100>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80006d4e:	ffffa097          	auipc	ra,0xffffa
    80006d52:	3dc080e7          	jalr	988(ra) # 8000112a <kalloc>
    80006d56:	fea43423          	sd	a0,-24(s0)
    80006d5a:	fe843783          	ld	a5,-24(s0)
    80006d5e:	cfd1                	beqz	a5,80006dfa <pipealloc+0x104>
    goto bad;
  pi->readopen = 1;
    80006d60:	fe843783          	ld	a5,-24(s0)
    80006d64:	4705                	li	a4,1
    80006d66:	22e7a023          	sw	a4,544(a5)
  pi->writeopen = 1;
    80006d6a:	fe843783          	ld	a5,-24(s0)
    80006d6e:	4705                	li	a4,1
    80006d70:	22e7a223          	sw	a4,548(a5)
  pi->nwrite = 0;
    80006d74:	fe843783          	ld	a5,-24(s0)
    80006d78:	2007ae23          	sw	zero,540(a5)
  pi->nread = 0;
    80006d7c:	fe843783          	ld	a5,-24(s0)
    80006d80:	2007ac23          	sw	zero,536(a5)
  initlock(&pi->lock, "pipe");
    80006d84:	fe843783          	ld	a5,-24(s0)
    80006d88:	00005597          	auipc	a1,0x5
    80006d8c:	86858593          	addi	a1,a1,-1944 # 8000b5f0 <etext+0x5f0>
    80006d90:	853e                	mv	a0,a5
    80006d92:	ffffa097          	auipc	ra,0xffffa
    80006d96:	4bc080e7          	jalr	1212(ra) # 8000124e <initlock>
  (*f0)->type = FD_PIPE;
    80006d9a:	fd843783          	ld	a5,-40(s0)
    80006d9e:	639c                	ld	a5,0(a5)
    80006da0:	4705                	li	a4,1
    80006da2:	c398                	sw	a4,0(a5)
  (*f0)->readable = 1;
    80006da4:	fd843783          	ld	a5,-40(s0)
    80006da8:	639c                	ld	a5,0(a5)
    80006daa:	4705                	li	a4,1
    80006dac:	00e78423          	sb	a4,8(a5)
  (*f0)->writable = 0;
    80006db0:	fd843783          	ld	a5,-40(s0)
    80006db4:	639c                	ld	a5,0(a5)
    80006db6:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80006dba:	fd843783          	ld	a5,-40(s0)
    80006dbe:	639c                	ld	a5,0(a5)
    80006dc0:	fe843703          	ld	a4,-24(s0)
    80006dc4:	eb98                	sd	a4,16(a5)
  (*f1)->type = FD_PIPE;
    80006dc6:	fd043783          	ld	a5,-48(s0)
    80006dca:	639c                	ld	a5,0(a5)
    80006dcc:	4705                	li	a4,1
    80006dce:	c398                	sw	a4,0(a5)
  (*f1)->readable = 0;
    80006dd0:	fd043783          	ld	a5,-48(s0)
    80006dd4:	639c                	ld	a5,0(a5)
    80006dd6:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80006dda:	fd043783          	ld	a5,-48(s0)
    80006dde:	639c                	ld	a5,0(a5)
    80006de0:	4705                	li	a4,1
    80006de2:	00e784a3          	sb	a4,9(a5)
  (*f1)->pipe = pi;
    80006de6:	fd043783          	ld	a5,-48(s0)
    80006dea:	639c                	ld	a5,0(a5)
    80006dec:	fe843703          	ld	a4,-24(s0)
    80006df0:	eb98                	sd	a4,16(a5)
  return 0;
    80006df2:	4781                	li	a5,0
    80006df4:	a0b1                	j	80006e40 <pipealloc+0x14a>
    goto bad;
    80006df6:	0001                	nop
    80006df8:	a011                	j	80006dfc <pipealloc+0x106>
    goto bad;
    80006dfa:	0001                	nop

 bad:
  if(pi)
    80006dfc:	fe843783          	ld	a5,-24(s0)
    80006e00:	c799                	beqz	a5,80006e0e <pipealloc+0x118>
    kfree((char*)pi);
    80006e02:	fe843503          	ld	a0,-24(s0)
    80006e06:	ffffa097          	auipc	ra,0xffffa
    80006e0a:	280080e7          	jalr	640(ra) # 80001086 <kfree>
  if(*f0)
    80006e0e:	fd843783          	ld	a5,-40(s0)
    80006e12:	639c                	ld	a5,0(a5)
    80006e14:	cb89                	beqz	a5,80006e26 <pipealloc+0x130>
    fileclose(*f0);
    80006e16:	fd843783          	ld	a5,-40(s0)
    80006e1a:	639c                	ld	a5,0(a5)
    80006e1c:	853e                	mv	a0,a5
    80006e1e:	00000097          	auipc	ra,0x0
    80006e22:	9c6080e7          	jalr	-1594(ra) # 800067e4 <fileclose>
  if(*f1)
    80006e26:	fd043783          	ld	a5,-48(s0)
    80006e2a:	639c                	ld	a5,0(a5)
    80006e2c:	cb89                	beqz	a5,80006e3e <pipealloc+0x148>
    fileclose(*f1);
    80006e2e:	fd043783          	ld	a5,-48(s0)
    80006e32:	639c                	ld	a5,0(a5)
    80006e34:	853e                	mv	a0,a5
    80006e36:	00000097          	auipc	ra,0x0
    80006e3a:	9ae080e7          	jalr	-1618(ra) # 800067e4 <fileclose>
  return -1;
    80006e3e:	57fd                	li	a5,-1
}
    80006e40:	853e                	mv	a0,a5
    80006e42:	70a2                	ld	ra,40(sp)
    80006e44:	7402                	ld	s0,32(sp)
    80006e46:	6145                	addi	sp,sp,48
    80006e48:	8082                	ret

0000000080006e4a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80006e4a:	1101                	addi	sp,sp,-32
    80006e4c:	ec06                	sd	ra,24(sp)
    80006e4e:	e822                	sd	s0,16(sp)
    80006e50:	1000                	addi	s0,sp,32
    80006e52:	fea43423          	sd	a0,-24(s0)
    80006e56:	87ae                	mv	a5,a1
    80006e58:	fef42223          	sw	a5,-28(s0)
  acquire(&pi->lock);
    80006e5c:	fe843783          	ld	a5,-24(s0)
    80006e60:	853e                	mv	a0,a5
    80006e62:	ffffa097          	auipc	ra,0xffffa
    80006e66:	41c080e7          	jalr	1052(ra) # 8000127e <acquire>
  if(writable){
    80006e6a:	fe442783          	lw	a5,-28(s0)
    80006e6e:	2781                	sext.w	a5,a5
    80006e70:	cf99                	beqz	a5,80006e8e <pipeclose+0x44>
    pi->writeopen = 0;
    80006e72:	fe843783          	ld	a5,-24(s0)
    80006e76:	2207a223          	sw	zero,548(a5)
    wakeup(&pi->nread);
    80006e7a:	fe843783          	ld	a5,-24(s0)
    80006e7e:	21878793          	addi	a5,a5,536
    80006e82:	853e                	mv	a0,a5
    80006e84:	ffffc097          	auipc	ra,0xffffc
    80006e88:	600080e7          	jalr	1536(ra) # 80003484 <wakeup>
    80006e8c:	a831                	j	80006ea8 <pipeclose+0x5e>
  } else {
    pi->readopen = 0;
    80006e8e:	fe843783          	ld	a5,-24(s0)
    80006e92:	2207a023          	sw	zero,544(a5)
    wakeup(&pi->nwrite);
    80006e96:	fe843783          	ld	a5,-24(s0)
    80006e9a:	21c78793          	addi	a5,a5,540
    80006e9e:	853e                	mv	a0,a5
    80006ea0:	ffffc097          	auipc	ra,0xffffc
    80006ea4:	5e4080e7          	jalr	1508(ra) # 80003484 <wakeup>
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80006ea8:	fe843783          	ld	a5,-24(s0)
    80006eac:	2207a783          	lw	a5,544(a5)
    80006eb0:	e785                	bnez	a5,80006ed8 <pipeclose+0x8e>
    80006eb2:	fe843783          	ld	a5,-24(s0)
    80006eb6:	2247a783          	lw	a5,548(a5)
    80006eba:	ef99                	bnez	a5,80006ed8 <pipeclose+0x8e>
    release(&pi->lock);
    80006ebc:	fe843783          	ld	a5,-24(s0)
    80006ec0:	853e                	mv	a0,a5
    80006ec2:	ffffa097          	auipc	ra,0xffffa
    80006ec6:	420080e7          	jalr	1056(ra) # 800012e2 <release>
    kfree((char*)pi);
    80006eca:	fe843503          	ld	a0,-24(s0)
    80006ece:	ffffa097          	auipc	ra,0xffffa
    80006ed2:	1b8080e7          	jalr	440(ra) # 80001086 <kfree>
    80006ed6:	a809                	j	80006ee8 <pipeclose+0x9e>
  } else
    release(&pi->lock);
    80006ed8:	fe843783          	ld	a5,-24(s0)
    80006edc:	853e                	mv	a0,a5
    80006ede:	ffffa097          	auipc	ra,0xffffa
    80006ee2:	404080e7          	jalr	1028(ra) # 800012e2 <release>
}
    80006ee6:	0001                	nop
    80006ee8:	0001                	nop
    80006eea:	60e2                	ld	ra,24(sp)
    80006eec:	6442                	ld	s0,16(sp)
    80006eee:	6105                	addi	sp,sp,32
    80006ef0:	8082                	ret

0000000080006ef2 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80006ef2:	715d                	addi	sp,sp,-80
    80006ef4:	e486                	sd	ra,72(sp)
    80006ef6:	e0a2                	sd	s0,64(sp)
    80006ef8:	0880                	addi	s0,sp,80
    80006efa:	fca43423          	sd	a0,-56(s0)
    80006efe:	fcb43023          	sd	a1,-64(s0)
    80006f02:	87b2                	mv	a5,a2
    80006f04:	faf42e23          	sw	a5,-68(s0)
  int i = 0;
    80006f08:	fe042623          	sw	zero,-20(s0)
  struct proc *pr = myproc();
    80006f0c:	ffffc097          	auipc	ra,0xffffc
    80006f10:	93a080e7          	jalr	-1734(ra) # 80002846 <myproc>
    80006f14:	fea43023          	sd	a0,-32(s0)

  acquire(&pi->lock);
    80006f18:	fc843783          	ld	a5,-56(s0)
    80006f1c:	853e                	mv	a0,a5
    80006f1e:	ffffa097          	auipc	ra,0xffffa
    80006f22:	360080e7          	jalr	864(ra) # 8000127e <acquire>
  while(i < n){
    80006f26:	a8f1                	j	80007002 <pipewrite+0x110>
    if(pi->readopen == 0 || killed(pr)){
    80006f28:	fc843783          	ld	a5,-56(s0)
    80006f2c:	2207a783          	lw	a5,544(a5)
    80006f30:	cb89                	beqz	a5,80006f42 <pipewrite+0x50>
    80006f32:	fe043503          	ld	a0,-32(s0)
    80006f36:	ffffc097          	auipc	ra,0xffffc
    80006f3a:	6bc080e7          	jalr	1724(ra) # 800035f2 <killed>
    80006f3e:	87aa                	mv	a5,a0
    80006f40:	cb91                	beqz	a5,80006f54 <pipewrite+0x62>
      release(&pi->lock);
    80006f42:	fc843783          	ld	a5,-56(s0)
    80006f46:	853e                	mv	a0,a5
    80006f48:	ffffa097          	auipc	ra,0xffffa
    80006f4c:	39a080e7          	jalr	922(ra) # 800012e2 <release>
      return -1;
    80006f50:	57fd                	li	a5,-1
    80006f52:	a0ed                	j	8000703c <pipewrite+0x14a>
    }
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80006f54:	fc843783          	ld	a5,-56(s0)
    80006f58:	21c7a703          	lw	a4,540(a5)
    80006f5c:	fc843783          	ld	a5,-56(s0)
    80006f60:	2187a783          	lw	a5,536(a5)
    80006f64:	2007879b          	addiw	a5,a5,512
    80006f68:	2781                	sext.w	a5,a5
    80006f6a:	02f71863          	bne	a4,a5,80006f9a <pipewrite+0xa8>
      wakeup(&pi->nread);
    80006f6e:	fc843783          	ld	a5,-56(s0)
    80006f72:	21878793          	addi	a5,a5,536
    80006f76:	853e                	mv	a0,a5
    80006f78:	ffffc097          	auipc	ra,0xffffc
    80006f7c:	50c080e7          	jalr	1292(ra) # 80003484 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80006f80:	fc843783          	ld	a5,-56(s0)
    80006f84:	21c78793          	addi	a5,a5,540
    80006f88:	fc843703          	ld	a4,-56(s0)
    80006f8c:	85ba                	mv	a1,a4
    80006f8e:	853e                	mv	a0,a5
    80006f90:	ffffc097          	auipc	ra,0xffffc
    80006f94:	478080e7          	jalr	1144(ra) # 80003408 <sleep>
    80006f98:	a0ad                	j	80007002 <pipewrite+0x110>
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80006f9a:	fe043783          	ld	a5,-32(s0)
    80006f9e:	6ba8                	ld	a0,80(a5)
    80006fa0:	fec42703          	lw	a4,-20(s0)
    80006fa4:	fc043783          	ld	a5,-64(s0)
    80006fa8:	973e                	add	a4,a4,a5
    80006faa:	fdf40793          	addi	a5,s0,-33
    80006fae:	4685                	li	a3,1
    80006fb0:	863a                	mv	a2,a4
    80006fb2:	85be                	mv	a1,a5
    80006fb4:	ffffb097          	auipc	ra,0xffffb
    80006fb8:	42a080e7          	jalr	1066(ra) # 800023de <copyin>
    80006fbc:	87aa                	mv	a5,a0
    80006fbe:	873e                	mv	a4,a5
    80006fc0:	57fd                	li	a5,-1
    80006fc2:	04f70a63          	beq	a4,a5,80007016 <pipewrite+0x124>
        break;
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80006fc6:	fc843783          	ld	a5,-56(s0)
    80006fca:	21c7a783          	lw	a5,540(a5)
    80006fce:	2781                	sext.w	a5,a5
    80006fd0:	0017871b          	addiw	a4,a5,1
    80006fd4:	0007069b          	sext.w	a3,a4
    80006fd8:	fc843703          	ld	a4,-56(s0)
    80006fdc:	20d72e23          	sw	a3,540(a4)
    80006fe0:	1ff7f793          	andi	a5,a5,511
    80006fe4:	2781                	sext.w	a5,a5
    80006fe6:	fdf44703          	lbu	a4,-33(s0)
    80006fea:	fc843683          	ld	a3,-56(s0)
    80006fee:	1782                	slli	a5,a5,0x20
    80006ff0:	9381                	srli	a5,a5,0x20
    80006ff2:	97b6                	add	a5,a5,a3
    80006ff4:	00e78c23          	sb	a4,24(a5)
      i++;
    80006ff8:	fec42783          	lw	a5,-20(s0)
    80006ffc:	2785                	addiw	a5,a5,1
    80006ffe:	fef42623          	sw	a5,-20(s0)
  while(i < n){
    80007002:	fec42783          	lw	a5,-20(s0)
    80007006:	873e                	mv	a4,a5
    80007008:	fbc42783          	lw	a5,-68(s0)
    8000700c:	2701                	sext.w	a4,a4
    8000700e:	2781                	sext.w	a5,a5
    80007010:	f0f74ce3          	blt	a4,a5,80006f28 <pipewrite+0x36>
    80007014:	a011                	j	80007018 <pipewrite+0x126>
        break;
    80007016:	0001                	nop
    }
  }
  wakeup(&pi->nread);
    80007018:	fc843783          	ld	a5,-56(s0)
    8000701c:	21878793          	addi	a5,a5,536
    80007020:	853e                	mv	a0,a5
    80007022:	ffffc097          	auipc	ra,0xffffc
    80007026:	462080e7          	jalr	1122(ra) # 80003484 <wakeup>
  release(&pi->lock);
    8000702a:	fc843783          	ld	a5,-56(s0)
    8000702e:	853e                	mv	a0,a5
    80007030:	ffffa097          	auipc	ra,0xffffa
    80007034:	2b2080e7          	jalr	690(ra) # 800012e2 <release>

  return i;
    80007038:	fec42783          	lw	a5,-20(s0)
}
    8000703c:	853e                	mv	a0,a5
    8000703e:	60a6                	ld	ra,72(sp)
    80007040:	6406                	ld	s0,64(sp)
    80007042:	6161                	addi	sp,sp,80
    80007044:	8082                	ret

0000000080007046 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80007046:	715d                	addi	sp,sp,-80
    80007048:	e486                	sd	ra,72(sp)
    8000704a:	e0a2                	sd	s0,64(sp)
    8000704c:	0880                	addi	s0,sp,80
    8000704e:	fca43423          	sd	a0,-56(s0)
    80007052:	fcb43023          	sd	a1,-64(s0)
    80007056:	87b2                	mv	a5,a2
    80007058:	faf42e23          	sw	a5,-68(s0)
  int i;
  struct proc *pr = myproc();
    8000705c:	ffffb097          	auipc	ra,0xffffb
    80007060:	7ea080e7          	jalr	2026(ra) # 80002846 <myproc>
    80007064:	fea43023          	sd	a0,-32(s0)
  char ch;

  acquire(&pi->lock);
    80007068:	fc843783          	ld	a5,-56(s0)
    8000706c:	853e                	mv	a0,a5
    8000706e:	ffffa097          	auipc	ra,0xffffa
    80007072:	210080e7          	jalr	528(ra) # 8000127e <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80007076:	a835                	j	800070b2 <piperead+0x6c>
    if(killed(pr)){
    80007078:	fe043503          	ld	a0,-32(s0)
    8000707c:	ffffc097          	auipc	ra,0xffffc
    80007080:	576080e7          	jalr	1398(ra) # 800035f2 <killed>
    80007084:	87aa                	mv	a5,a0
    80007086:	cb91                	beqz	a5,8000709a <piperead+0x54>
      release(&pi->lock);
    80007088:	fc843783          	ld	a5,-56(s0)
    8000708c:	853e                	mv	a0,a5
    8000708e:	ffffa097          	auipc	ra,0xffffa
    80007092:	254080e7          	jalr	596(ra) # 800012e2 <release>
      return -1;
    80007096:	57fd                	li	a5,-1
    80007098:	a8e5                	j	80007190 <piperead+0x14a>
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000709a:	fc843783          	ld	a5,-56(s0)
    8000709e:	21878793          	addi	a5,a5,536
    800070a2:	fc843703          	ld	a4,-56(s0)
    800070a6:	85ba                	mv	a1,a4
    800070a8:	853e                	mv	a0,a5
    800070aa:	ffffc097          	auipc	ra,0xffffc
    800070ae:	35e080e7          	jalr	862(ra) # 80003408 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800070b2:	fc843783          	ld	a5,-56(s0)
    800070b6:	2187a703          	lw	a4,536(a5)
    800070ba:	fc843783          	ld	a5,-56(s0)
    800070be:	21c7a783          	lw	a5,540(a5)
    800070c2:	00f71763          	bne	a4,a5,800070d0 <piperead+0x8a>
    800070c6:	fc843783          	ld	a5,-56(s0)
    800070ca:	2247a783          	lw	a5,548(a5)
    800070ce:	f7cd                	bnez	a5,80007078 <piperead+0x32>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800070d0:	fe042623          	sw	zero,-20(s0)
    800070d4:	a8bd                	j	80007152 <piperead+0x10c>
    if(pi->nread == pi->nwrite)
    800070d6:	fc843783          	ld	a5,-56(s0)
    800070da:	2187a703          	lw	a4,536(a5)
    800070de:	fc843783          	ld	a5,-56(s0)
    800070e2:	21c7a783          	lw	a5,540(a5)
    800070e6:	08f70063          	beq	a4,a5,80007166 <piperead+0x120>
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    800070ea:	fc843783          	ld	a5,-56(s0)
    800070ee:	2187a783          	lw	a5,536(a5)
    800070f2:	2781                	sext.w	a5,a5
    800070f4:	0017871b          	addiw	a4,a5,1
    800070f8:	0007069b          	sext.w	a3,a4
    800070fc:	fc843703          	ld	a4,-56(s0)
    80007100:	20d72c23          	sw	a3,536(a4)
    80007104:	1ff7f793          	andi	a5,a5,511
    80007108:	2781                	sext.w	a5,a5
    8000710a:	fc843703          	ld	a4,-56(s0)
    8000710e:	1782                	slli	a5,a5,0x20
    80007110:	9381                	srli	a5,a5,0x20
    80007112:	97ba                	add	a5,a5,a4
    80007114:	0187c783          	lbu	a5,24(a5)
    80007118:	fcf40fa3          	sb	a5,-33(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000711c:	fe043783          	ld	a5,-32(s0)
    80007120:	6ba8                	ld	a0,80(a5)
    80007122:	fec42703          	lw	a4,-20(s0)
    80007126:	fc043783          	ld	a5,-64(s0)
    8000712a:	97ba                	add	a5,a5,a4
    8000712c:	fdf40713          	addi	a4,s0,-33
    80007130:	4685                	li	a3,1
    80007132:	863a                	mv	a2,a4
    80007134:	85be                	mv	a1,a5
    80007136:	ffffb097          	auipc	ra,0xffffb
    8000713a:	1da080e7          	jalr	474(ra) # 80002310 <copyout>
    8000713e:	87aa                	mv	a5,a0
    80007140:	873e                	mv	a4,a5
    80007142:	57fd                	li	a5,-1
    80007144:	02f70363          	beq	a4,a5,8000716a <piperead+0x124>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80007148:	fec42783          	lw	a5,-20(s0)
    8000714c:	2785                	addiw	a5,a5,1
    8000714e:	fef42623          	sw	a5,-20(s0)
    80007152:	fec42783          	lw	a5,-20(s0)
    80007156:	873e                	mv	a4,a5
    80007158:	fbc42783          	lw	a5,-68(s0)
    8000715c:	2701                	sext.w	a4,a4
    8000715e:	2781                	sext.w	a5,a5
    80007160:	f6f74be3          	blt	a4,a5,800070d6 <piperead+0x90>
    80007164:	a021                	j	8000716c <piperead+0x126>
      break;
    80007166:	0001                	nop
    80007168:	a011                	j	8000716c <piperead+0x126>
      break;
    8000716a:	0001                	nop
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000716c:	fc843783          	ld	a5,-56(s0)
    80007170:	21c78793          	addi	a5,a5,540
    80007174:	853e                	mv	a0,a5
    80007176:	ffffc097          	auipc	ra,0xffffc
    8000717a:	30e080e7          	jalr	782(ra) # 80003484 <wakeup>
  release(&pi->lock);
    8000717e:	fc843783          	ld	a5,-56(s0)
    80007182:	853e                	mv	a0,a5
    80007184:	ffffa097          	auipc	ra,0xffffa
    80007188:	15e080e7          	jalr	350(ra) # 800012e2 <release>
  return i;
    8000718c:	fec42783          	lw	a5,-20(s0)
}
    80007190:	853e                	mv	a0,a5
    80007192:	60a6                	ld	ra,72(sp)
    80007194:	6406                	ld	s0,64(sp)
    80007196:	6161                	addi	sp,sp,80
    80007198:	8082                	ret

000000008000719a <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000719a:	7179                	addi	sp,sp,-48
    8000719c:	f422                	sd	s0,40(sp)
    8000719e:	1800                	addi	s0,sp,48
    800071a0:	87aa                	mv	a5,a0
    800071a2:	fcf42e23          	sw	a5,-36(s0)
    int perm = 0;
    800071a6:	fe042623          	sw	zero,-20(s0)
    if(flags & 0x1)
    800071aa:	fdc42783          	lw	a5,-36(s0)
    800071ae:	8b85                	andi	a5,a5,1
    800071b0:	2781                	sext.w	a5,a5
    800071b2:	c781                	beqz	a5,800071ba <flags2perm+0x20>
      perm = PTE_X;
    800071b4:	47a1                	li	a5,8
    800071b6:	fef42623          	sw	a5,-20(s0)
    if(flags & 0x2)
    800071ba:	fdc42783          	lw	a5,-36(s0)
    800071be:	8b89                	andi	a5,a5,2
    800071c0:	2781                	sext.w	a5,a5
    800071c2:	c799                	beqz	a5,800071d0 <flags2perm+0x36>
      perm |= PTE_W;
    800071c4:	fec42783          	lw	a5,-20(s0)
    800071c8:	0047e793          	ori	a5,a5,4
    800071cc:	fef42623          	sw	a5,-20(s0)
    return perm;
    800071d0:	fec42783          	lw	a5,-20(s0)
}
    800071d4:	853e                	mv	a0,a5
    800071d6:	7422                	ld	s0,40(sp)
    800071d8:	6145                	addi	sp,sp,48
    800071da:	8082                	ret

00000000800071dc <exec>:

int
exec(char *path, char **argv)
{
    800071dc:	de010113          	addi	sp,sp,-544
    800071e0:	20113c23          	sd	ra,536(sp)
    800071e4:	20813823          	sd	s0,528(sp)
    800071e8:	20913423          	sd	s1,520(sp)
    800071ec:	1400                	addi	s0,sp,544
    800071ee:	dea43423          	sd	a0,-536(s0)
    800071f2:	deb43023          	sd	a1,-544(s0)
  char *s, *last;
  int i, off;
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800071f6:	fa043c23          	sd	zero,-72(s0)
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
    800071fa:	fa043023          	sd	zero,-96(s0)
  struct proc *p = myproc();
    800071fe:	ffffb097          	auipc	ra,0xffffb
    80007202:	648080e7          	jalr	1608(ra) # 80002846 <myproc>
    80007206:	f8a43c23          	sd	a0,-104(s0)

  begin_op();
    8000720a:	fffff097          	auipc	ra,0xfffff
    8000720e:	f40080e7          	jalr	-192(ra) # 8000614a <begin_op>

  if((ip = namei(path)) == 0){
    80007212:	de843503          	ld	a0,-536(s0)
    80007216:	fffff097          	auipc	ra,0xfffff
    8000721a:	bd0080e7          	jalr	-1072(ra) # 80005de6 <namei>
    8000721e:	faa43423          	sd	a0,-88(s0)
    80007222:	fa843783          	ld	a5,-88(s0)
    80007226:	e799                	bnez	a5,80007234 <exec+0x58>
    end_op();
    80007228:	fffff097          	auipc	ra,0xfffff
    8000722c:	fe4080e7          	jalr	-28(ra) # 8000620c <end_op>
    return -1;
    80007230:	57fd                	li	a5,-1
    80007232:	a199                	j	80007678 <exec+0x49c>
  }
  ilock(ip);
    80007234:	fa843503          	ld	a0,-88(s0)
    80007238:	ffffe097          	auipc	ra,0xffffe
    8000723c:	e7e080e7          	jalr	-386(ra) # 800050b6 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80007240:	e3040793          	addi	a5,s0,-464
    80007244:	04000713          	li	a4,64
    80007248:	4681                	li	a3,0
    8000724a:	863e                	mv	a2,a5
    8000724c:	4581                	li	a1,0
    8000724e:	fa843503          	ld	a0,-88(s0)
    80007252:	ffffe097          	auipc	ra,0xffffe
    80007256:	41a080e7          	jalr	1050(ra) # 8000566c <readi>
    8000725a:	87aa                	mv	a5,a0
    8000725c:	873e                	mv	a4,a5
    8000725e:	04000793          	li	a5,64
    80007262:	3af71563          	bne	a4,a5,8000760c <exec+0x430>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80007266:	e3042783          	lw	a5,-464(s0)
    8000726a:	873e                	mv	a4,a5
    8000726c:	464c47b7          	lui	a5,0x464c4
    80007270:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80007274:	38f71e63          	bne	a4,a5,80007610 <exec+0x434>
    goto bad;

  if((pagetable = proc_pagetable(p)) == 0)
    80007278:	f9843503          	ld	a0,-104(s0)
    8000727c:	ffffc097          	auipc	ra,0xffffc
    80007280:	82c080e7          	jalr	-2004(ra) # 80002aa8 <proc_pagetable>
    80007284:	faa43023          	sd	a0,-96(s0)
    80007288:	fa043783          	ld	a5,-96(s0)
    8000728c:	38078463          	beqz	a5,80007614 <exec+0x438>
    goto bad;

  // Load program into memory.
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80007290:	fc042623          	sw	zero,-52(s0)
    80007294:	e5043783          	ld	a5,-432(s0)
    80007298:	fcf42423          	sw	a5,-56(s0)
    8000729c:	a0fd                	j	8000738a <exec+0x1ae>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000729e:	df840793          	addi	a5,s0,-520
    800072a2:	fc842683          	lw	a3,-56(s0)
    800072a6:	03800713          	li	a4,56
    800072aa:	863e                	mv	a2,a5
    800072ac:	4581                	li	a1,0
    800072ae:	fa843503          	ld	a0,-88(s0)
    800072b2:	ffffe097          	auipc	ra,0xffffe
    800072b6:	3ba080e7          	jalr	954(ra) # 8000566c <readi>
    800072ba:	87aa                	mv	a5,a0
    800072bc:	873e                	mv	a4,a5
    800072be:	03800793          	li	a5,56
    800072c2:	34f71b63          	bne	a4,a5,80007618 <exec+0x43c>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
    800072c6:	df842783          	lw	a5,-520(s0)
    800072ca:	873e                	mv	a4,a5
    800072cc:	4785                	li	a5,1
    800072ce:	0af71163          	bne	a4,a5,80007370 <exec+0x194>
      continue;
    if(ph.memsz < ph.filesz)
    800072d2:	e2043703          	ld	a4,-480(s0)
    800072d6:	e1843783          	ld	a5,-488(s0)
    800072da:	34f76163          	bltu	a4,a5,8000761c <exec+0x440>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800072de:	e0843703          	ld	a4,-504(s0)
    800072e2:	e2043783          	ld	a5,-480(s0)
    800072e6:	973e                	add	a4,a4,a5
    800072e8:	e0843783          	ld	a5,-504(s0)
    800072ec:	32f76a63          	bltu	a4,a5,80007620 <exec+0x444>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
    800072f0:	e0843703          	ld	a4,-504(s0)
    800072f4:	6785                	lui	a5,0x1
    800072f6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800072f8:	8ff9                	and	a5,a5,a4
    800072fa:	32079563          	bnez	a5,80007624 <exec+0x448>
      goto bad;
    uint64 sz1;
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800072fe:	e0843703          	ld	a4,-504(s0)
    80007302:	e2043783          	ld	a5,-480(s0)
    80007306:	00f704b3          	add	s1,a4,a5
    8000730a:	dfc42783          	lw	a5,-516(s0)
    8000730e:	2781                	sext.w	a5,a5
    80007310:	853e                	mv	a0,a5
    80007312:	00000097          	auipc	ra,0x0
    80007316:	e88080e7          	jalr	-376(ra) # 8000719a <flags2perm>
    8000731a:	87aa                	mv	a5,a0
    8000731c:	86be                	mv	a3,a5
    8000731e:	8626                	mv	a2,s1
    80007320:	fb843583          	ld	a1,-72(s0)
    80007324:	fa043503          	ld	a0,-96(s0)
    80007328:	ffffb097          	auipc	ra,0xffffb
    8000732c:	bfc080e7          	jalr	-1028(ra) # 80001f24 <uvmalloc>
    80007330:	f6a43823          	sd	a0,-144(s0)
    80007334:	f7043783          	ld	a5,-144(s0)
    80007338:	2e078863          	beqz	a5,80007628 <exec+0x44c>
      goto bad;
    sz = sz1;
    8000733c:	f7043783          	ld	a5,-144(s0)
    80007340:	faf43c23          	sd	a5,-72(s0)
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80007344:	e0843783          	ld	a5,-504(s0)
    80007348:	e0043703          	ld	a4,-512(s0)
    8000734c:	0007069b          	sext.w	a3,a4
    80007350:	e1843703          	ld	a4,-488(s0)
    80007354:	2701                	sext.w	a4,a4
    80007356:	fa843603          	ld	a2,-88(s0)
    8000735a:	85be                	mv	a1,a5
    8000735c:	fa043503          	ld	a0,-96(s0)
    80007360:	00000097          	auipc	ra,0x0
    80007364:	32c080e7          	jalr	812(ra) # 8000768c <loadseg>
    80007368:	87aa                	mv	a5,a0
    8000736a:	2c07c163          	bltz	a5,8000762c <exec+0x450>
    8000736e:	a011                	j	80007372 <exec+0x196>
      continue;
    80007370:	0001                	nop
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80007372:	fcc42783          	lw	a5,-52(s0)
    80007376:	2785                	addiw	a5,a5,1
    80007378:	fcf42623          	sw	a5,-52(s0)
    8000737c:	fc842783          	lw	a5,-56(s0)
    80007380:	0387879b          	addiw	a5,a5,56
    80007384:	2781                	sext.w	a5,a5
    80007386:	fcf42423          	sw	a5,-56(s0)
    8000738a:	e6845783          	lhu	a5,-408(s0)
    8000738e:	0007871b          	sext.w	a4,a5
    80007392:	fcc42783          	lw	a5,-52(s0)
    80007396:	2781                	sext.w	a5,a5
    80007398:	f0e7c3e3          	blt	a5,a4,8000729e <exec+0xc2>
      goto bad;
  }
  iunlockput(ip);
    8000739c:	fa843503          	ld	a0,-88(s0)
    800073a0:	ffffe097          	auipc	ra,0xffffe
    800073a4:	f74080e7          	jalr	-140(ra) # 80005314 <iunlockput>
  end_op();
    800073a8:	fffff097          	auipc	ra,0xfffff
    800073ac:	e64080e7          	jalr	-412(ra) # 8000620c <end_op>
  ip = 0;
    800073b0:	fa043423          	sd	zero,-88(s0)

  p = myproc();
    800073b4:	ffffb097          	auipc	ra,0xffffb
    800073b8:	492080e7          	jalr	1170(ra) # 80002846 <myproc>
    800073bc:	f8a43c23          	sd	a0,-104(s0)
  uint64 oldsz = p->sz;
    800073c0:	f9843783          	ld	a5,-104(s0)
    800073c4:	67bc                	ld	a5,72(a5)
    800073c6:	f8f43823          	sd	a5,-112(s0)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible as a stack guard.
  // Use the second as the user stack.
  sz = PGROUNDUP(sz);
    800073ca:	fb843703          	ld	a4,-72(s0)
    800073ce:	6785                	lui	a5,0x1
    800073d0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800073d2:	973e                	add	a4,a4,a5
    800073d4:	77fd                	lui	a5,0xfffff
    800073d6:	8ff9                	and	a5,a5,a4
    800073d8:	faf43c23          	sd	a5,-72(s0)
  uint64 sz1;
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800073dc:	fb843703          	ld	a4,-72(s0)
    800073e0:	6789                	lui	a5,0x2
    800073e2:	97ba                	add	a5,a5,a4
    800073e4:	4691                	li	a3,4
    800073e6:	863e                	mv	a2,a5
    800073e8:	fb843583          	ld	a1,-72(s0)
    800073ec:	fa043503          	ld	a0,-96(s0)
    800073f0:	ffffb097          	auipc	ra,0xffffb
    800073f4:	b34080e7          	jalr	-1228(ra) # 80001f24 <uvmalloc>
    800073f8:	f8a43423          	sd	a0,-120(s0)
    800073fc:	f8843783          	ld	a5,-120(s0)
    80007400:	22078863          	beqz	a5,80007630 <exec+0x454>
    goto bad;
  sz = sz1;
    80007404:	f8843783          	ld	a5,-120(s0)
    80007408:	faf43c23          	sd	a5,-72(s0)
  uvmclear(pagetable, sz-2*PGSIZE);
    8000740c:	fb843703          	ld	a4,-72(s0)
    80007410:	77f9                	lui	a5,0xffffe
    80007412:	97ba                	add	a5,a5,a4
    80007414:	85be                	mv	a1,a5
    80007416:	fa043503          	ld	a0,-96(s0)
    8000741a:	ffffb097          	auipc	ra,0xffffb
    8000741e:	ea0080e7          	jalr	-352(ra) # 800022ba <uvmclear>
  sp = sz;
    80007422:	fb843783          	ld	a5,-72(s0)
    80007426:	faf43823          	sd	a5,-80(s0)
  stackbase = sp - PGSIZE;
    8000742a:	fb043703          	ld	a4,-80(s0)
    8000742e:	77fd                	lui	a5,0xfffff
    80007430:	97ba                	add	a5,a5,a4
    80007432:	f8f43023          	sd	a5,-128(s0)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    80007436:	fc043023          	sd	zero,-64(s0)
    8000743a:	a07d                	j	800074e8 <exec+0x30c>
    if(argc >= MAXARG)
    8000743c:	fc043703          	ld	a4,-64(s0)
    80007440:	47fd                	li	a5,31
    80007442:	1ee7e963          	bltu	a5,a4,80007634 <exec+0x458>
      goto bad;
    sp -= strlen(argv[argc]) + 1;
    80007446:	fc043783          	ld	a5,-64(s0)
    8000744a:	078e                	slli	a5,a5,0x3
    8000744c:	de043703          	ld	a4,-544(s0)
    80007450:	97ba                	add	a5,a5,a4
    80007452:	639c                	ld	a5,0(a5)
    80007454:	853e                	mv	a0,a5
    80007456:	ffffa097          	auipc	ra,0xffffa
    8000745a:	37c080e7          	jalr	892(ra) # 800017d2 <strlen>
    8000745e:	87aa                	mv	a5,a0
    80007460:	2785                	addiw	a5,a5,1 # fffffffffffff001 <end+0xffffffff7ffd7ce9>
    80007462:	2781                	sext.w	a5,a5
    80007464:	873e                	mv	a4,a5
    80007466:	fb043783          	ld	a5,-80(s0)
    8000746a:	8f99                	sub	a5,a5,a4
    8000746c:	faf43823          	sd	a5,-80(s0)
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80007470:	fb043783          	ld	a5,-80(s0)
    80007474:	9bc1                	andi	a5,a5,-16
    80007476:	faf43823          	sd	a5,-80(s0)
    if(sp < stackbase)
    8000747a:	fb043703          	ld	a4,-80(s0)
    8000747e:	f8043783          	ld	a5,-128(s0)
    80007482:	1af76b63          	bltu	a4,a5,80007638 <exec+0x45c>
      goto bad;
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80007486:	fc043783          	ld	a5,-64(s0)
    8000748a:	078e                	slli	a5,a5,0x3
    8000748c:	de043703          	ld	a4,-544(s0)
    80007490:	97ba                	add	a5,a5,a4
    80007492:	6384                	ld	s1,0(a5)
    80007494:	fc043783          	ld	a5,-64(s0)
    80007498:	078e                	slli	a5,a5,0x3
    8000749a:	de043703          	ld	a4,-544(s0)
    8000749e:	97ba                	add	a5,a5,a4
    800074a0:	639c                	ld	a5,0(a5)
    800074a2:	853e                	mv	a0,a5
    800074a4:	ffffa097          	auipc	ra,0xffffa
    800074a8:	32e080e7          	jalr	814(ra) # 800017d2 <strlen>
    800074ac:	87aa                	mv	a5,a0
    800074ae:	2785                	addiw	a5,a5,1
    800074b0:	2781                	sext.w	a5,a5
    800074b2:	86be                	mv	a3,a5
    800074b4:	8626                	mv	a2,s1
    800074b6:	fb043583          	ld	a1,-80(s0)
    800074ba:	fa043503          	ld	a0,-96(s0)
    800074be:	ffffb097          	auipc	ra,0xffffb
    800074c2:	e52080e7          	jalr	-430(ra) # 80002310 <copyout>
    800074c6:	87aa                	mv	a5,a0
    800074c8:	1607ca63          	bltz	a5,8000763c <exec+0x460>
      goto bad;
    ustack[argc] = sp;
    800074cc:	fc043783          	ld	a5,-64(s0)
    800074d0:	078e                	slli	a5,a5,0x3
    800074d2:	1781                	addi	a5,a5,-32
    800074d4:	97a2                	add	a5,a5,s0
    800074d6:	fb043703          	ld	a4,-80(s0)
    800074da:	e8e7b823          	sd	a4,-368(a5)
  for(argc = 0; argv[argc]; argc++) {
    800074de:	fc043783          	ld	a5,-64(s0)
    800074e2:	0785                	addi	a5,a5,1
    800074e4:	fcf43023          	sd	a5,-64(s0)
    800074e8:	fc043783          	ld	a5,-64(s0)
    800074ec:	078e                	slli	a5,a5,0x3
    800074ee:	de043703          	ld	a4,-544(s0)
    800074f2:	97ba                	add	a5,a5,a4
    800074f4:	639c                	ld	a5,0(a5)
    800074f6:	f3b9                	bnez	a5,8000743c <exec+0x260>
  }
  ustack[argc] = 0;
    800074f8:	fc043783          	ld	a5,-64(s0)
    800074fc:	078e                	slli	a5,a5,0x3
    800074fe:	1781                	addi	a5,a5,-32
    80007500:	97a2                	add	a5,a5,s0
    80007502:	e807b823          	sd	zero,-368(a5)

  // push the array of argv[] pointers.
  sp -= (argc+1) * sizeof(uint64);
    80007506:	fc043783          	ld	a5,-64(s0)
    8000750a:	0785                	addi	a5,a5,1
    8000750c:	078e                	slli	a5,a5,0x3
    8000750e:	fb043703          	ld	a4,-80(s0)
    80007512:	40f707b3          	sub	a5,a4,a5
    80007516:	faf43823          	sd	a5,-80(s0)
  sp -= sp % 16;
    8000751a:	fb043783          	ld	a5,-80(s0)
    8000751e:	9bc1                	andi	a5,a5,-16
    80007520:	faf43823          	sd	a5,-80(s0)
  if(sp < stackbase)
    80007524:	fb043703          	ld	a4,-80(s0)
    80007528:	f8043783          	ld	a5,-128(s0)
    8000752c:	10f76a63          	bltu	a4,a5,80007640 <exec+0x464>
    goto bad;
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80007530:	fc043783          	ld	a5,-64(s0)
    80007534:	0785                	addi	a5,a5,1
    80007536:	00379713          	slli	a4,a5,0x3
    8000753a:	e7040793          	addi	a5,s0,-400
    8000753e:	86ba                	mv	a3,a4
    80007540:	863e                	mv	a2,a5
    80007542:	fb043583          	ld	a1,-80(s0)
    80007546:	fa043503          	ld	a0,-96(s0)
    8000754a:	ffffb097          	auipc	ra,0xffffb
    8000754e:	dc6080e7          	jalr	-570(ra) # 80002310 <copyout>
    80007552:	87aa                	mv	a5,a0
    80007554:	0e07c863          	bltz	a5,80007644 <exec+0x468>
    goto bad;

  // arguments to user main(argc, argv)
  // argc is returned via the system call return
  // value, which goes in a0.
  p->trapframe->a1 = sp;
    80007558:	f9843783          	ld	a5,-104(s0)
    8000755c:	6fbc                	ld	a5,88(a5)
    8000755e:	fb043703          	ld	a4,-80(s0)
    80007562:	ffb8                	sd	a4,120(a5)

  // Save program name for debugging.
  for(last=s=path; *s; s++)
    80007564:	de843783          	ld	a5,-536(s0)
    80007568:	fcf43c23          	sd	a5,-40(s0)
    8000756c:	fd843783          	ld	a5,-40(s0)
    80007570:	fcf43823          	sd	a5,-48(s0)
    80007574:	a025                	j	8000759c <exec+0x3c0>
    if(*s == '/')
    80007576:	fd843783          	ld	a5,-40(s0)
    8000757a:	0007c783          	lbu	a5,0(a5)
    8000757e:	873e                	mv	a4,a5
    80007580:	02f00793          	li	a5,47
    80007584:	00f71763          	bne	a4,a5,80007592 <exec+0x3b6>
      last = s+1;
    80007588:	fd843783          	ld	a5,-40(s0)
    8000758c:	0785                	addi	a5,a5,1
    8000758e:	fcf43823          	sd	a5,-48(s0)
  for(last=s=path; *s; s++)
    80007592:	fd843783          	ld	a5,-40(s0)
    80007596:	0785                	addi	a5,a5,1
    80007598:	fcf43c23          	sd	a5,-40(s0)
    8000759c:	fd843783          	ld	a5,-40(s0)
    800075a0:	0007c783          	lbu	a5,0(a5)
    800075a4:	fbe9                	bnez	a5,80007576 <exec+0x39a>
  safestrcpy(p->name, last, sizeof(p->name));
    800075a6:	f9843783          	ld	a5,-104(s0)
    800075aa:	15878793          	addi	a5,a5,344
    800075ae:	4641                	li	a2,16
    800075b0:	fd043583          	ld	a1,-48(s0)
    800075b4:	853e                	mv	a0,a5
    800075b6:	ffffa097          	auipc	ra,0xffffa
    800075ba:	1a0080e7          	jalr	416(ra) # 80001756 <safestrcpy>
    
  // Commit to the user image.
  oldpagetable = p->pagetable;
    800075be:	f9843783          	ld	a5,-104(s0)
    800075c2:	6bbc                	ld	a5,80(a5)
    800075c4:	f6f43c23          	sd	a5,-136(s0)
  p->pagetable = pagetable;
    800075c8:	f9843783          	ld	a5,-104(s0)
    800075cc:	fa043703          	ld	a4,-96(s0)
    800075d0:	ebb8                	sd	a4,80(a5)
  p->sz = sz;
    800075d2:	f9843783          	ld	a5,-104(s0)
    800075d6:	fb843703          	ld	a4,-72(s0)
    800075da:	e7b8                	sd	a4,72(a5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800075dc:	f9843783          	ld	a5,-104(s0)
    800075e0:	6fbc                	ld	a5,88(a5)
    800075e2:	e4843703          	ld	a4,-440(s0)
    800075e6:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800075e8:	f9843783          	ld	a5,-104(s0)
    800075ec:	6fbc                	ld	a5,88(a5)
    800075ee:	fb043703          	ld	a4,-80(s0)
    800075f2:	fb98                	sd	a4,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800075f4:	f9043583          	ld	a1,-112(s0)
    800075f8:	f7843503          	ld	a0,-136(s0)
    800075fc:	ffffb097          	auipc	ra,0xffffb
    80007600:	56c080e7          	jalr	1388(ra) # 80002b68 <proc_freepagetable>

  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80007604:	fc043783          	ld	a5,-64(s0)
    80007608:	2781                	sext.w	a5,a5
    8000760a:	a0bd                	j	80007678 <exec+0x49c>
    goto bad;
    8000760c:	0001                	nop
    8000760e:	a825                	j	80007646 <exec+0x46a>
    goto bad;
    80007610:	0001                	nop
    80007612:	a815                	j	80007646 <exec+0x46a>
    goto bad;
    80007614:	0001                	nop
    80007616:	a805                	j	80007646 <exec+0x46a>
      goto bad;
    80007618:	0001                	nop
    8000761a:	a035                	j	80007646 <exec+0x46a>
      goto bad;
    8000761c:	0001                	nop
    8000761e:	a025                	j	80007646 <exec+0x46a>
      goto bad;
    80007620:	0001                	nop
    80007622:	a015                	j	80007646 <exec+0x46a>
      goto bad;
    80007624:	0001                	nop
    80007626:	a005                	j	80007646 <exec+0x46a>
      goto bad;
    80007628:	0001                	nop
    8000762a:	a831                	j	80007646 <exec+0x46a>
      goto bad;
    8000762c:	0001                	nop
    8000762e:	a821                	j	80007646 <exec+0x46a>
    goto bad;
    80007630:	0001                	nop
    80007632:	a811                	j	80007646 <exec+0x46a>
      goto bad;
    80007634:	0001                	nop
    80007636:	a801                	j	80007646 <exec+0x46a>
      goto bad;
    80007638:	0001                	nop
    8000763a:	a031                	j	80007646 <exec+0x46a>
      goto bad;
    8000763c:	0001                	nop
    8000763e:	a021                	j	80007646 <exec+0x46a>
    goto bad;
    80007640:	0001                	nop
    80007642:	a011                	j	80007646 <exec+0x46a>
    goto bad;
    80007644:	0001                	nop

 bad:
  if(pagetable)
    80007646:	fa043783          	ld	a5,-96(s0)
    8000764a:	cb89                	beqz	a5,8000765c <exec+0x480>
    proc_freepagetable(pagetable, sz);
    8000764c:	fb843583          	ld	a1,-72(s0)
    80007650:	fa043503          	ld	a0,-96(s0)
    80007654:	ffffb097          	auipc	ra,0xffffb
    80007658:	514080e7          	jalr	1300(ra) # 80002b68 <proc_freepagetable>
  if(ip){
    8000765c:	fa843783          	ld	a5,-88(s0)
    80007660:	cb99                	beqz	a5,80007676 <exec+0x49a>
    iunlockput(ip);
    80007662:	fa843503          	ld	a0,-88(s0)
    80007666:	ffffe097          	auipc	ra,0xffffe
    8000766a:	cae080e7          	jalr	-850(ra) # 80005314 <iunlockput>
    end_op();
    8000766e:	fffff097          	auipc	ra,0xfffff
    80007672:	b9e080e7          	jalr	-1122(ra) # 8000620c <end_op>
  }
  return -1;
    80007676:	57fd                	li	a5,-1
}
    80007678:	853e                	mv	a0,a5
    8000767a:	21813083          	ld	ra,536(sp)
    8000767e:	21013403          	ld	s0,528(sp)
    80007682:	20813483          	ld	s1,520(sp)
    80007686:	22010113          	addi	sp,sp,544
    8000768a:	8082                	ret

000000008000768c <loadseg>:
// va must be page-aligned
// and the pages from va to va+sz must already be mapped.
// Returns 0 on success, -1 on failure.
static int
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
    8000768c:	7139                	addi	sp,sp,-64
    8000768e:	fc06                	sd	ra,56(sp)
    80007690:	f822                	sd	s0,48(sp)
    80007692:	0080                	addi	s0,sp,64
    80007694:	fca43c23          	sd	a0,-40(s0)
    80007698:	fcb43823          	sd	a1,-48(s0)
    8000769c:	fcc43423          	sd	a2,-56(s0)
    800076a0:	87b6                	mv	a5,a3
    800076a2:	fcf42223          	sw	a5,-60(s0)
    800076a6:	87ba                	mv	a5,a4
    800076a8:	fcf42023          	sw	a5,-64(s0)
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800076ac:	fe042623          	sw	zero,-20(s0)
    800076b0:	a07d                	j	8000775e <loadseg+0xd2>
    pa = walkaddr(pagetable, va + i);
    800076b2:	fec46703          	lwu	a4,-20(s0)
    800076b6:	fd043783          	ld	a5,-48(s0)
    800076ba:	97ba                	add	a5,a5,a4
    800076bc:	85be                	mv	a1,a5
    800076be:	fd843503          	ld	a0,-40(s0)
    800076c2:	ffffa097          	auipc	ra,0xffffa
    800076c6:	4ee080e7          	jalr	1262(ra) # 80001bb0 <walkaddr>
    800076ca:	fea43023          	sd	a0,-32(s0)
    if(pa == 0)
    800076ce:	fe043783          	ld	a5,-32(s0)
    800076d2:	eb89                	bnez	a5,800076e4 <loadseg+0x58>
      panic("loadseg: address should exist");
    800076d4:	00004517          	auipc	a0,0x4
    800076d8:	f2450513          	addi	a0,a0,-220 # 8000b5f8 <etext+0x5f8>
    800076dc:	ffff9097          	auipc	ra,0xffff9
    800076e0:	5ae080e7          	jalr	1454(ra) # 80000c8a <panic>
    if(sz - i < PGSIZE)
    800076e4:	fc042783          	lw	a5,-64(s0)
    800076e8:	873e                	mv	a4,a5
    800076ea:	fec42783          	lw	a5,-20(s0)
    800076ee:	40f707bb          	subw	a5,a4,a5
    800076f2:	2781                	sext.w	a5,a5
    800076f4:	873e                	mv	a4,a5
    800076f6:	6785                	lui	a5,0x1
    800076f8:	00f77c63          	bgeu	a4,a5,80007710 <loadseg+0x84>
      n = sz - i;
    800076fc:	fc042783          	lw	a5,-64(s0)
    80007700:	873e                	mv	a4,a5
    80007702:	fec42783          	lw	a5,-20(s0)
    80007706:	40f707bb          	subw	a5,a4,a5
    8000770a:	fef42423          	sw	a5,-24(s0)
    8000770e:	a021                	j	80007716 <loadseg+0x8a>
    else
      n = PGSIZE;
    80007710:	6785                	lui	a5,0x1
    80007712:	fef42423          	sw	a5,-24(s0)
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80007716:	fc442783          	lw	a5,-60(s0)
    8000771a:	873e                	mv	a4,a5
    8000771c:	fec42783          	lw	a5,-20(s0)
    80007720:	9fb9                	addw	a5,a5,a4
    80007722:	2781                	sext.w	a5,a5
    80007724:	fe842703          	lw	a4,-24(s0)
    80007728:	86be                	mv	a3,a5
    8000772a:	fe043603          	ld	a2,-32(s0)
    8000772e:	4581                	li	a1,0
    80007730:	fc843503          	ld	a0,-56(s0)
    80007734:	ffffe097          	auipc	ra,0xffffe
    80007738:	f38080e7          	jalr	-200(ra) # 8000566c <readi>
    8000773c:	87aa                	mv	a5,a0
    8000773e:	0007871b          	sext.w	a4,a5
    80007742:	fe842783          	lw	a5,-24(s0)
    80007746:	2781                	sext.w	a5,a5
    80007748:	00e78463          	beq	a5,a4,80007750 <loadseg+0xc4>
      return -1;
    8000774c:	57fd                	li	a5,-1
    8000774e:	a015                	j	80007772 <loadseg+0xe6>
  for(i = 0; i < sz; i += PGSIZE){
    80007750:	fec42783          	lw	a5,-20(s0)
    80007754:	873e                	mv	a4,a5
    80007756:	6785                	lui	a5,0x1
    80007758:	9fb9                	addw	a5,a5,a4
    8000775a:	fef42623          	sw	a5,-20(s0)
    8000775e:	fec42783          	lw	a5,-20(s0)
    80007762:	873e                	mv	a4,a5
    80007764:	fc042783          	lw	a5,-64(s0)
    80007768:	2701                	sext.w	a4,a4
    8000776a:	2781                	sext.w	a5,a5
    8000776c:	f4f763e3          	bltu	a4,a5,800076b2 <loadseg+0x26>
  }
  
  return 0;
    80007770:	4781                	li	a5,0
}
    80007772:	853e                	mv	a0,a5
    80007774:	70e2                	ld	ra,56(sp)
    80007776:	7442                	ld	s0,48(sp)
    80007778:	6121                	addi	sp,sp,64
    8000777a:	8082                	ret

000000008000777c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000777c:	7139                	addi	sp,sp,-64
    8000777e:	fc06                	sd	ra,56(sp)
    80007780:	f822                	sd	s0,48(sp)
    80007782:	0080                	addi	s0,sp,64
    80007784:	87aa                	mv	a5,a0
    80007786:	fcb43823          	sd	a1,-48(s0)
    8000778a:	fcc43423          	sd	a2,-56(s0)
    8000778e:	fcf42e23          	sw	a5,-36(s0)
  int fd;
  struct file *f;

  argint(n, &fd);
    80007792:	fe440713          	addi	a4,s0,-28
    80007796:	fdc42783          	lw	a5,-36(s0)
    8000779a:	85ba                	mv	a1,a4
    8000779c:	853e                	mv	a0,a5
    8000779e:	ffffd097          	auipc	ra,0xffffd
    800077a2:	976080e7          	jalr	-1674(ra) # 80004114 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800077a6:	fe442783          	lw	a5,-28(s0)
    800077aa:	0207c863          	bltz	a5,800077da <argfd+0x5e>
    800077ae:	fe442783          	lw	a5,-28(s0)
    800077b2:	873e                	mv	a4,a5
    800077b4:	47bd                	li	a5,15
    800077b6:	02e7c263          	blt	a5,a4,800077da <argfd+0x5e>
    800077ba:	ffffb097          	auipc	ra,0xffffb
    800077be:	08c080e7          	jalr	140(ra) # 80002846 <myproc>
    800077c2:	872a                	mv	a4,a0
    800077c4:	fe442783          	lw	a5,-28(s0)
    800077c8:	07e9                	addi	a5,a5,26 # 101a <_entry-0x7fffefe6>
    800077ca:	078e                	slli	a5,a5,0x3
    800077cc:	97ba                	add	a5,a5,a4
    800077ce:	639c                	ld	a5,0(a5)
    800077d0:	fef43423          	sd	a5,-24(s0)
    800077d4:	fe843783          	ld	a5,-24(s0)
    800077d8:	e399                	bnez	a5,800077de <argfd+0x62>
    return -1;
    800077da:	57fd                	li	a5,-1
    800077dc:	a015                	j	80007800 <argfd+0x84>
  if(pfd)
    800077de:	fd043783          	ld	a5,-48(s0)
    800077e2:	c791                	beqz	a5,800077ee <argfd+0x72>
    *pfd = fd;
    800077e4:	fe442703          	lw	a4,-28(s0)
    800077e8:	fd043783          	ld	a5,-48(s0)
    800077ec:	c398                	sw	a4,0(a5)
  if(pf)
    800077ee:	fc843783          	ld	a5,-56(s0)
    800077f2:	c791                	beqz	a5,800077fe <argfd+0x82>
    *pf = f;
    800077f4:	fc843783          	ld	a5,-56(s0)
    800077f8:	fe843703          	ld	a4,-24(s0)
    800077fc:	e398                	sd	a4,0(a5)
  return 0;
    800077fe:	4781                	li	a5,0
}
    80007800:	853e                	mv	a0,a5
    80007802:	70e2                	ld	ra,56(sp)
    80007804:	7442                	ld	s0,48(sp)
    80007806:	6121                	addi	sp,sp,64
    80007808:	8082                	ret

000000008000780a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000780a:	7179                	addi	sp,sp,-48
    8000780c:	f406                	sd	ra,40(sp)
    8000780e:	f022                	sd	s0,32(sp)
    80007810:	1800                	addi	s0,sp,48
    80007812:	fca43c23          	sd	a0,-40(s0)
  int fd;
  struct proc *p = myproc();
    80007816:	ffffb097          	auipc	ra,0xffffb
    8000781a:	030080e7          	jalr	48(ra) # 80002846 <myproc>
    8000781e:	fea43023          	sd	a0,-32(s0)

  for(fd = 0; fd < NOFILE; fd++){
    80007822:	fe042623          	sw	zero,-20(s0)
    80007826:	a825                	j	8000785e <fdalloc+0x54>
    if(p->ofile[fd] == 0){
    80007828:	fe043703          	ld	a4,-32(s0)
    8000782c:	fec42783          	lw	a5,-20(s0)
    80007830:	07e9                	addi	a5,a5,26
    80007832:	078e                	slli	a5,a5,0x3
    80007834:	97ba                	add	a5,a5,a4
    80007836:	639c                	ld	a5,0(a5)
    80007838:	ef91                	bnez	a5,80007854 <fdalloc+0x4a>
      p->ofile[fd] = f;
    8000783a:	fe043703          	ld	a4,-32(s0)
    8000783e:	fec42783          	lw	a5,-20(s0)
    80007842:	07e9                	addi	a5,a5,26
    80007844:	078e                	slli	a5,a5,0x3
    80007846:	97ba                	add	a5,a5,a4
    80007848:	fd843703          	ld	a4,-40(s0)
    8000784c:	e398                	sd	a4,0(a5)
      return fd;
    8000784e:	fec42783          	lw	a5,-20(s0)
    80007852:	a831                	j	8000786e <fdalloc+0x64>
  for(fd = 0; fd < NOFILE; fd++){
    80007854:	fec42783          	lw	a5,-20(s0)
    80007858:	2785                	addiw	a5,a5,1
    8000785a:	fef42623          	sw	a5,-20(s0)
    8000785e:	fec42783          	lw	a5,-20(s0)
    80007862:	0007871b          	sext.w	a4,a5
    80007866:	47bd                	li	a5,15
    80007868:	fce7d0e3          	bge	a5,a4,80007828 <fdalloc+0x1e>
    }
  }
  return -1;
    8000786c:	57fd                	li	a5,-1
}
    8000786e:	853e                	mv	a0,a5
    80007870:	70a2                	ld	ra,40(sp)
    80007872:	7402                	ld	s0,32(sp)
    80007874:	6145                	addi	sp,sp,48
    80007876:	8082                	ret

0000000080007878 <sys_dup>:

uint64
sys_dup(void)
{
    80007878:	1101                	addi	sp,sp,-32
    8000787a:	ec06                	sd	ra,24(sp)
    8000787c:	e822                	sd	s0,16(sp)
    8000787e:	1000                	addi	s0,sp,32
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    80007880:	fe040793          	addi	a5,s0,-32
    80007884:	863e                	mv	a2,a5
    80007886:	4581                	li	a1,0
    80007888:	4501                	li	a0,0
    8000788a:	00000097          	auipc	ra,0x0
    8000788e:	ef2080e7          	jalr	-270(ra) # 8000777c <argfd>
    80007892:	87aa                	mv	a5,a0
    80007894:	0007d463          	bgez	a5,8000789c <sys_dup+0x24>
    return -1;
    80007898:	57fd                	li	a5,-1
    8000789a:	a81d                	j	800078d0 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
    8000789c:	fe043783          	ld	a5,-32(s0)
    800078a0:	853e                	mv	a0,a5
    800078a2:	00000097          	auipc	ra,0x0
    800078a6:	f68080e7          	jalr	-152(ra) # 8000780a <fdalloc>
    800078aa:	87aa                	mv	a5,a0
    800078ac:	fef42623          	sw	a5,-20(s0)
    800078b0:	fec42783          	lw	a5,-20(s0)
    800078b4:	2781                	sext.w	a5,a5
    800078b6:	0007d463          	bgez	a5,800078be <sys_dup+0x46>
    return -1;
    800078ba:	57fd                	li	a5,-1
    800078bc:	a811                	j	800078d0 <sys_dup+0x58>
  filedup(f);
    800078be:	fe043783          	ld	a5,-32(s0)
    800078c2:	853e                	mv	a0,a5
    800078c4:	fffff097          	auipc	ra,0xfffff
    800078c8:	eba080e7          	jalr	-326(ra) # 8000677e <filedup>
  return fd;
    800078cc:	fec42783          	lw	a5,-20(s0)
}
    800078d0:	853e                	mv	a0,a5
    800078d2:	60e2                	ld	ra,24(sp)
    800078d4:	6442                	ld	s0,16(sp)
    800078d6:	6105                	addi	sp,sp,32
    800078d8:	8082                	ret

00000000800078da <sys_read>:

uint64
sys_read(void)
{
    800078da:	7179                	addi	sp,sp,-48
    800078dc:	f406                	sd	ra,40(sp)
    800078de:	f022                	sd	s0,32(sp)
    800078e0:	1800                	addi	s0,sp,48
  struct file *f;
  int n;
  uint64 p;

  argaddr(1, &p);
    800078e2:	fd840793          	addi	a5,s0,-40
    800078e6:	85be                	mv	a1,a5
    800078e8:	4505                	li	a0,1
    800078ea:	ffffd097          	auipc	ra,0xffffd
    800078ee:	860080e7          	jalr	-1952(ra) # 8000414a <argaddr>
  argint(2, &n);
    800078f2:	fe440793          	addi	a5,s0,-28
    800078f6:	85be                	mv	a1,a5
    800078f8:	4509                	li	a0,2
    800078fa:	ffffd097          	auipc	ra,0xffffd
    800078fe:	81a080e7          	jalr	-2022(ra) # 80004114 <argint>
  if(argfd(0, 0, &f) < 0)
    80007902:	fe840793          	addi	a5,s0,-24
    80007906:	863e                	mv	a2,a5
    80007908:	4581                	li	a1,0
    8000790a:	4501                	li	a0,0
    8000790c:	00000097          	auipc	ra,0x0
    80007910:	e70080e7          	jalr	-400(ra) # 8000777c <argfd>
    80007914:	87aa                	mv	a5,a0
    80007916:	0007d463          	bgez	a5,8000791e <sys_read+0x44>
    return -1;
    8000791a:	57fd                	li	a5,-1
    8000791c:	a839                	j	8000793a <sys_read+0x60>
  return fileread(f, p, n);
    8000791e:	fe843783          	ld	a5,-24(s0)
    80007922:	fd843703          	ld	a4,-40(s0)
    80007926:	fe442683          	lw	a3,-28(s0)
    8000792a:	8636                	mv	a2,a3
    8000792c:	85ba                	mv	a1,a4
    8000792e:	853e                	mv	a0,a5
    80007930:	fffff097          	auipc	ra,0xfffff
    80007934:	060080e7          	jalr	96(ra) # 80006990 <fileread>
    80007938:	87aa                	mv	a5,a0
}
    8000793a:	853e                	mv	a0,a5
    8000793c:	70a2                	ld	ra,40(sp)
    8000793e:	7402                	ld	s0,32(sp)
    80007940:	6145                	addi	sp,sp,48
    80007942:	8082                	ret

0000000080007944 <sys_write>:

uint64
sys_write(void)
{
    80007944:	7179                	addi	sp,sp,-48
    80007946:	f406                	sd	ra,40(sp)
    80007948:	f022                	sd	s0,32(sp)
    8000794a:	1800                	addi	s0,sp,48
  struct file *f;
  int n;
  uint64 p;
  
  argaddr(1, &p);
    8000794c:	fd840793          	addi	a5,s0,-40
    80007950:	85be                	mv	a1,a5
    80007952:	4505                	li	a0,1
    80007954:	ffffc097          	auipc	ra,0xffffc
    80007958:	7f6080e7          	jalr	2038(ra) # 8000414a <argaddr>
  argint(2, &n);
    8000795c:	fe440793          	addi	a5,s0,-28
    80007960:	85be                	mv	a1,a5
    80007962:	4509                	li	a0,2
    80007964:	ffffc097          	auipc	ra,0xffffc
    80007968:	7b0080e7          	jalr	1968(ra) # 80004114 <argint>
  if(argfd(0, 0, &f) < 0)
    8000796c:	fe840793          	addi	a5,s0,-24
    80007970:	863e                	mv	a2,a5
    80007972:	4581                	li	a1,0
    80007974:	4501                	li	a0,0
    80007976:	00000097          	auipc	ra,0x0
    8000797a:	e06080e7          	jalr	-506(ra) # 8000777c <argfd>
    8000797e:	87aa                	mv	a5,a0
    80007980:	0007d463          	bgez	a5,80007988 <sys_write+0x44>
    return -1;
    80007984:	57fd                	li	a5,-1
    80007986:	a839                	j	800079a4 <sys_write+0x60>

  return filewrite(f, p, n);
    80007988:	fe843783          	ld	a5,-24(s0)
    8000798c:	fd843703          	ld	a4,-40(s0)
    80007990:	fe442683          	lw	a3,-28(s0)
    80007994:	8636                	mv	a2,a3
    80007996:	85ba                	mv	a1,a4
    80007998:	853e                	mv	a0,a5
    8000799a:	fffff097          	auipc	ra,0xfffff
    8000799e:	154080e7          	jalr	340(ra) # 80006aee <filewrite>
    800079a2:	87aa                	mv	a5,a0
}
    800079a4:	853e                	mv	a0,a5
    800079a6:	70a2                	ld	ra,40(sp)
    800079a8:	7402                	ld	s0,32(sp)
    800079aa:	6145                	addi	sp,sp,48
    800079ac:	8082                	ret

00000000800079ae <sys_close>:

uint64
sys_close(void)
{
    800079ae:	1101                	addi	sp,sp,-32
    800079b0:	ec06                	sd	ra,24(sp)
    800079b2:	e822                	sd	s0,16(sp)
    800079b4:	1000                	addi	s0,sp,32
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    800079b6:	fe040713          	addi	a4,s0,-32
    800079ba:	fec40793          	addi	a5,s0,-20
    800079be:	863a                	mv	a2,a4
    800079c0:	85be                	mv	a1,a5
    800079c2:	4501                	li	a0,0
    800079c4:	00000097          	auipc	ra,0x0
    800079c8:	db8080e7          	jalr	-584(ra) # 8000777c <argfd>
    800079cc:	87aa                	mv	a5,a0
    800079ce:	0007d463          	bgez	a5,800079d6 <sys_close+0x28>
    return -1;
    800079d2:	57fd                	li	a5,-1
    800079d4:	a02d                	j	800079fe <sys_close+0x50>
  myproc()->ofile[fd] = 0;
    800079d6:	ffffb097          	auipc	ra,0xffffb
    800079da:	e70080e7          	jalr	-400(ra) # 80002846 <myproc>
    800079de:	872a                	mv	a4,a0
    800079e0:	fec42783          	lw	a5,-20(s0)
    800079e4:	07e9                	addi	a5,a5,26
    800079e6:	078e                	slli	a5,a5,0x3
    800079e8:	97ba                	add	a5,a5,a4
    800079ea:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800079ee:	fe043783          	ld	a5,-32(s0)
    800079f2:	853e                	mv	a0,a5
    800079f4:	fffff097          	auipc	ra,0xfffff
    800079f8:	df0080e7          	jalr	-528(ra) # 800067e4 <fileclose>
  return 0;
    800079fc:	4781                	li	a5,0
}
    800079fe:	853e                	mv	a0,a5
    80007a00:	60e2                	ld	ra,24(sp)
    80007a02:	6442                	ld	s0,16(sp)
    80007a04:	6105                	addi	sp,sp,32
    80007a06:	8082                	ret

0000000080007a08 <sys_fstat>:

uint64
sys_fstat(void)
{
    80007a08:	1101                	addi	sp,sp,-32
    80007a0a:	ec06                	sd	ra,24(sp)
    80007a0c:	e822                	sd	s0,16(sp)
    80007a0e:	1000                	addi	s0,sp,32
  struct file *f;
  uint64 st; // user pointer to struct stat

  argaddr(1, &st);
    80007a10:	fe040793          	addi	a5,s0,-32
    80007a14:	85be                	mv	a1,a5
    80007a16:	4505                	li	a0,1
    80007a18:	ffffc097          	auipc	ra,0xffffc
    80007a1c:	732080e7          	jalr	1842(ra) # 8000414a <argaddr>
  if(argfd(0, 0, &f) < 0)
    80007a20:	fe840793          	addi	a5,s0,-24
    80007a24:	863e                	mv	a2,a5
    80007a26:	4581                	li	a1,0
    80007a28:	4501                	li	a0,0
    80007a2a:	00000097          	auipc	ra,0x0
    80007a2e:	d52080e7          	jalr	-686(ra) # 8000777c <argfd>
    80007a32:	87aa                	mv	a5,a0
    80007a34:	0007d463          	bgez	a5,80007a3c <sys_fstat+0x34>
    return -1;
    80007a38:	57fd                	li	a5,-1
    80007a3a:	a821                	j	80007a52 <sys_fstat+0x4a>
  return filestat(f, st);
    80007a3c:	fe843783          	ld	a5,-24(s0)
    80007a40:	fe043703          	ld	a4,-32(s0)
    80007a44:	85ba                	mv	a1,a4
    80007a46:	853e                	mv	a0,a5
    80007a48:	fffff097          	auipc	ra,0xfffff
    80007a4c:	ea4080e7          	jalr	-348(ra) # 800068ec <filestat>
    80007a50:	87aa                	mv	a5,a0
}
    80007a52:	853e                	mv	a0,a5
    80007a54:	60e2                	ld	ra,24(sp)
    80007a56:	6442                	ld	s0,16(sp)
    80007a58:	6105                	addi	sp,sp,32
    80007a5a:	8082                	ret

0000000080007a5c <sys_link>:

// Create the path new as a link to the same inode as old.
uint64
sys_link(void)
{
    80007a5c:	7169                	addi	sp,sp,-304
    80007a5e:	f606                	sd	ra,296(sp)
    80007a60:	f222                	sd	s0,288(sp)
    80007a62:	1a00                	addi	s0,sp,304
  char name[DIRSIZ], new[MAXPATH], old[MAXPATH];
  struct inode *dp, *ip;

  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80007a64:	ed040793          	addi	a5,s0,-304
    80007a68:	08000613          	li	a2,128
    80007a6c:	85be                	mv	a1,a5
    80007a6e:	4501                	li	a0,0
    80007a70:	ffffc097          	auipc	ra,0xffffc
    80007a74:	70c080e7          	jalr	1804(ra) # 8000417c <argstr>
    80007a78:	87aa                	mv	a5,a0
    80007a7a:	0007cf63          	bltz	a5,80007a98 <sys_link+0x3c>
    80007a7e:	f5040793          	addi	a5,s0,-176
    80007a82:	08000613          	li	a2,128
    80007a86:	85be                	mv	a1,a5
    80007a88:	4505                	li	a0,1
    80007a8a:	ffffc097          	auipc	ra,0xffffc
    80007a8e:	6f2080e7          	jalr	1778(ra) # 8000417c <argstr>
    80007a92:	87aa                	mv	a5,a0
    80007a94:	0007d463          	bgez	a5,80007a9c <sys_link+0x40>
    return -1;
    80007a98:	57fd                	li	a5,-1
    80007a9a:	aaad                	j	80007c14 <sys_link+0x1b8>

  begin_op();
    80007a9c:	ffffe097          	auipc	ra,0xffffe
    80007aa0:	6ae080e7          	jalr	1710(ra) # 8000614a <begin_op>
  if((ip = namei(old)) == 0){
    80007aa4:	ed040793          	addi	a5,s0,-304
    80007aa8:	853e                	mv	a0,a5
    80007aaa:	ffffe097          	auipc	ra,0xffffe
    80007aae:	33c080e7          	jalr	828(ra) # 80005de6 <namei>
    80007ab2:	fea43423          	sd	a0,-24(s0)
    80007ab6:	fe843783          	ld	a5,-24(s0)
    80007aba:	e799                	bnez	a5,80007ac8 <sys_link+0x6c>
    end_op();
    80007abc:	ffffe097          	auipc	ra,0xffffe
    80007ac0:	750080e7          	jalr	1872(ra) # 8000620c <end_op>
    return -1;
    80007ac4:	57fd                	li	a5,-1
    80007ac6:	a2b9                	j	80007c14 <sys_link+0x1b8>
  }

  ilock(ip);
    80007ac8:	fe843503          	ld	a0,-24(s0)
    80007acc:	ffffd097          	auipc	ra,0xffffd
    80007ad0:	5ea080e7          	jalr	1514(ra) # 800050b6 <ilock>
  if(ip->type == T_DIR){
    80007ad4:	fe843783          	ld	a5,-24(s0)
    80007ad8:	04479783          	lh	a5,68(a5)
    80007adc:	873e                	mv	a4,a5
    80007ade:	4785                	li	a5,1
    80007ae0:	00f71e63          	bne	a4,a5,80007afc <sys_link+0xa0>
    iunlockput(ip);
    80007ae4:	fe843503          	ld	a0,-24(s0)
    80007ae8:	ffffe097          	auipc	ra,0xffffe
    80007aec:	82c080e7          	jalr	-2004(ra) # 80005314 <iunlockput>
    end_op();
    80007af0:	ffffe097          	auipc	ra,0xffffe
    80007af4:	71c080e7          	jalr	1820(ra) # 8000620c <end_op>
    return -1;
    80007af8:	57fd                	li	a5,-1
    80007afa:	aa29                	j	80007c14 <sys_link+0x1b8>
  }

  ip->nlink++;
    80007afc:	fe843783          	ld	a5,-24(s0)
    80007b00:	04a79783          	lh	a5,74(a5)
    80007b04:	17c2                	slli	a5,a5,0x30
    80007b06:	93c1                	srli	a5,a5,0x30
    80007b08:	2785                	addiw	a5,a5,1
    80007b0a:	17c2                	slli	a5,a5,0x30
    80007b0c:	93c1                	srli	a5,a5,0x30
    80007b0e:	0107971b          	slliw	a4,a5,0x10
    80007b12:	4107571b          	sraiw	a4,a4,0x10
    80007b16:	fe843783          	ld	a5,-24(s0)
    80007b1a:	04e79523          	sh	a4,74(a5)
  iupdate(ip);
    80007b1e:	fe843503          	ld	a0,-24(s0)
    80007b22:	ffffd097          	auipc	ra,0xffffd
    80007b26:	344080e7          	jalr	836(ra) # 80004e66 <iupdate>
  iunlock(ip);
    80007b2a:	fe843503          	ld	a0,-24(s0)
    80007b2e:	ffffd097          	auipc	ra,0xffffd
    80007b32:	6bc080e7          	jalr	1724(ra) # 800051ea <iunlock>

  if((dp = nameiparent(new, name)) == 0)
    80007b36:	fd040713          	addi	a4,s0,-48
    80007b3a:	f5040793          	addi	a5,s0,-176
    80007b3e:	85ba                	mv	a1,a4
    80007b40:	853e                	mv	a0,a5
    80007b42:	ffffe097          	auipc	ra,0xffffe
    80007b46:	2d0080e7          	jalr	720(ra) # 80005e12 <nameiparent>
    80007b4a:	fea43023          	sd	a0,-32(s0)
    80007b4e:	fe043783          	ld	a5,-32(s0)
    80007b52:	cba5                	beqz	a5,80007bc2 <sys_link+0x166>
    goto bad;
  ilock(dp);
    80007b54:	fe043503          	ld	a0,-32(s0)
    80007b58:	ffffd097          	auipc	ra,0xffffd
    80007b5c:	55e080e7          	jalr	1374(ra) # 800050b6 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80007b60:	fe043783          	ld	a5,-32(s0)
    80007b64:	4398                	lw	a4,0(a5)
    80007b66:	fe843783          	ld	a5,-24(s0)
    80007b6a:	439c                	lw	a5,0(a5)
    80007b6c:	02f71263          	bne	a4,a5,80007b90 <sys_link+0x134>
    80007b70:	fe843783          	ld	a5,-24(s0)
    80007b74:	43d8                	lw	a4,4(a5)
    80007b76:	fd040793          	addi	a5,s0,-48
    80007b7a:	863a                	mv	a2,a4
    80007b7c:	85be                	mv	a1,a5
    80007b7e:	fe043503          	ld	a0,-32(s0)
    80007b82:	ffffe097          	auipc	ra,0xffffe
    80007b86:	f58080e7          	jalr	-168(ra) # 80005ada <dirlink>
    80007b8a:	87aa                	mv	a5,a0
    80007b8c:	0007d963          	bgez	a5,80007b9e <sys_link+0x142>
    iunlockput(dp);
    80007b90:	fe043503          	ld	a0,-32(s0)
    80007b94:	ffffd097          	auipc	ra,0xffffd
    80007b98:	780080e7          	jalr	1920(ra) # 80005314 <iunlockput>
    goto bad;
    80007b9c:	a025                	j	80007bc4 <sys_link+0x168>
  }
  iunlockput(dp);
    80007b9e:	fe043503          	ld	a0,-32(s0)
    80007ba2:	ffffd097          	auipc	ra,0xffffd
    80007ba6:	772080e7          	jalr	1906(ra) # 80005314 <iunlockput>
  iput(ip);
    80007baa:	fe843503          	ld	a0,-24(s0)
    80007bae:	ffffd097          	auipc	ra,0xffffd
    80007bb2:	696080e7          	jalr	1686(ra) # 80005244 <iput>

  end_op();
    80007bb6:	ffffe097          	auipc	ra,0xffffe
    80007bba:	656080e7          	jalr	1622(ra) # 8000620c <end_op>

  return 0;
    80007bbe:	4781                	li	a5,0
    80007bc0:	a891                	j	80007c14 <sys_link+0x1b8>
    goto bad;
    80007bc2:	0001                	nop

bad:
  ilock(ip);
    80007bc4:	fe843503          	ld	a0,-24(s0)
    80007bc8:	ffffd097          	auipc	ra,0xffffd
    80007bcc:	4ee080e7          	jalr	1262(ra) # 800050b6 <ilock>
  ip->nlink--;
    80007bd0:	fe843783          	ld	a5,-24(s0)
    80007bd4:	04a79783          	lh	a5,74(a5)
    80007bd8:	17c2                	slli	a5,a5,0x30
    80007bda:	93c1                	srli	a5,a5,0x30
    80007bdc:	37fd                	addiw	a5,a5,-1
    80007bde:	17c2                	slli	a5,a5,0x30
    80007be0:	93c1                	srli	a5,a5,0x30
    80007be2:	0107971b          	slliw	a4,a5,0x10
    80007be6:	4107571b          	sraiw	a4,a4,0x10
    80007bea:	fe843783          	ld	a5,-24(s0)
    80007bee:	04e79523          	sh	a4,74(a5)
  iupdate(ip);
    80007bf2:	fe843503          	ld	a0,-24(s0)
    80007bf6:	ffffd097          	auipc	ra,0xffffd
    80007bfa:	270080e7          	jalr	624(ra) # 80004e66 <iupdate>
  iunlockput(ip);
    80007bfe:	fe843503          	ld	a0,-24(s0)
    80007c02:	ffffd097          	auipc	ra,0xffffd
    80007c06:	712080e7          	jalr	1810(ra) # 80005314 <iunlockput>
  end_op();
    80007c0a:	ffffe097          	auipc	ra,0xffffe
    80007c0e:	602080e7          	jalr	1538(ra) # 8000620c <end_op>
  return -1;
    80007c12:	57fd                	li	a5,-1
}
    80007c14:	853e                	mv	a0,a5
    80007c16:	70b2                	ld	ra,296(sp)
    80007c18:	7412                	ld	s0,288(sp)
    80007c1a:	6155                	addi	sp,sp,304
    80007c1c:	8082                	ret

0000000080007c1e <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
    80007c1e:	7139                	addi	sp,sp,-64
    80007c20:	fc06                	sd	ra,56(sp)
    80007c22:	f822                	sd	s0,48(sp)
    80007c24:	0080                	addi	s0,sp,64
    80007c26:	fca43423          	sd	a0,-56(s0)
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80007c2a:	02000793          	li	a5,32
    80007c2e:	fef42623          	sw	a5,-20(s0)
    80007c32:	a0b1                	j	80007c7e <isdirempty+0x60>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80007c34:	fd840793          	addi	a5,s0,-40
    80007c38:	fec42683          	lw	a3,-20(s0)
    80007c3c:	4741                	li	a4,16
    80007c3e:	863e                	mv	a2,a5
    80007c40:	4581                	li	a1,0
    80007c42:	fc843503          	ld	a0,-56(s0)
    80007c46:	ffffe097          	auipc	ra,0xffffe
    80007c4a:	a26080e7          	jalr	-1498(ra) # 8000566c <readi>
    80007c4e:	87aa                	mv	a5,a0
    80007c50:	873e                	mv	a4,a5
    80007c52:	47c1                	li	a5,16
    80007c54:	00f70a63          	beq	a4,a5,80007c68 <isdirempty+0x4a>
      panic("isdirempty: readi");
    80007c58:	00004517          	auipc	a0,0x4
    80007c5c:	9c050513          	addi	a0,a0,-1600 # 8000b618 <etext+0x618>
    80007c60:	ffff9097          	auipc	ra,0xffff9
    80007c64:	02a080e7          	jalr	42(ra) # 80000c8a <panic>
    if(de.inum != 0)
    80007c68:	fd845783          	lhu	a5,-40(s0)
    80007c6c:	c399                	beqz	a5,80007c72 <isdirempty+0x54>
      return 0;
    80007c6e:	4781                	li	a5,0
    80007c70:	a839                	j	80007c8e <isdirempty+0x70>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80007c72:	fec42783          	lw	a5,-20(s0)
    80007c76:	27c1                	addiw	a5,a5,16
    80007c78:	2781                	sext.w	a5,a5
    80007c7a:	fef42623          	sw	a5,-20(s0)
    80007c7e:	fc843783          	ld	a5,-56(s0)
    80007c82:	47f8                	lw	a4,76(a5)
    80007c84:	fec42783          	lw	a5,-20(s0)
    80007c88:	fae7e6e3          	bltu	a5,a4,80007c34 <isdirempty+0x16>
  }
  return 1;
    80007c8c:	4785                	li	a5,1
}
    80007c8e:	853e                	mv	a0,a5
    80007c90:	70e2                	ld	ra,56(sp)
    80007c92:	7442                	ld	s0,48(sp)
    80007c94:	6121                	addi	sp,sp,64
    80007c96:	8082                	ret

0000000080007c98 <sys_unlink>:

uint64
sys_unlink(void)
{
    80007c98:	7155                	addi	sp,sp,-208
    80007c9a:	e586                	sd	ra,200(sp)
    80007c9c:	e1a2                	sd	s0,192(sp)
    80007c9e:	0980                	addi	s0,sp,208
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], path[MAXPATH];
  uint off;

  if(argstr(0, path, MAXPATH) < 0)
    80007ca0:	f4040793          	addi	a5,s0,-192
    80007ca4:	08000613          	li	a2,128
    80007ca8:	85be                	mv	a1,a5
    80007caa:	4501                	li	a0,0
    80007cac:	ffffc097          	auipc	ra,0xffffc
    80007cb0:	4d0080e7          	jalr	1232(ra) # 8000417c <argstr>
    80007cb4:	87aa                	mv	a5,a0
    80007cb6:	0007d463          	bgez	a5,80007cbe <sys_unlink+0x26>
    return -1;
    80007cba:	57fd                	li	a5,-1
    80007cbc:	a2d5                	j	80007ea0 <sys_unlink+0x208>

  begin_op();
    80007cbe:	ffffe097          	auipc	ra,0xffffe
    80007cc2:	48c080e7          	jalr	1164(ra) # 8000614a <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80007cc6:	fc040713          	addi	a4,s0,-64
    80007cca:	f4040793          	addi	a5,s0,-192
    80007cce:	85ba                	mv	a1,a4
    80007cd0:	853e                	mv	a0,a5
    80007cd2:	ffffe097          	auipc	ra,0xffffe
    80007cd6:	140080e7          	jalr	320(ra) # 80005e12 <nameiparent>
    80007cda:	fea43423          	sd	a0,-24(s0)
    80007cde:	fe843783          	ld	a5,-24(s0)
    80007ce2:	e799                	bnez	a5,80007cf0 <sys_unlink+0x58>
    end_op();
    80007ce4:	ffffe097          	auipc	ra,0xffffe
    80007ce8:	528080e7          	jalr	1320(ra) # 8000620c <end_op>
    return -1;
    80007cec:	57fd                	li	a5,-1
    80007cee:	aa4d                	j	80007ea0 <sys_unlink+0x208>
  }

  ilock(dp);
    80007cf0:	fe843503          	ld	a0,-24(s0)
    80007cf4:	ffffd097          	auipc	ra,0xffffd
    80007cf8:	3c2080e7          	jalr	962(ra) # 800050b6 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80007cfc:	fc040793          	addi	a5,s0,-64
    80007d00:	00004597          	auipc	a1,0x4
    80007d04:	93058593          	addi	a1,a1,-1744 # 8000b630 <etext+0x630>
    80007d08:	853e                	mv	a0,a5
    80007d0a:	ffffe097          	auipc	ra,0xffffe
    80007d0e:	cbc080e7          	jalr	-836(ra) # 800059c6 <namecmp>
    80007d12:	87aa                	mv	a5,a0
    80007d14:	16078863          	beqz	a5,80007e84 <sys_unlink+0x1ec>
    80007d18:	fc040793          	addi	a5,s0,-64
    80007d1c:	00004597          	auipc	a1,0x4
    80007d20:	91c58593          	addi	a1,a1,-1764 # 8000b638 <etext+0x638>
    80007d24:	853e                	mv	a0,a5
    80007d26:	ffffe097          	auipc	ra,0xffffe
    80007d2a:	ca0080e7          	jalr	-864(ra) # 800059c6 <namecmp>
    80007d2e:	87aa                	mv	a5,a0
    80007d30:	14078a63          	beqz	a5,80007e84 <sys_unlink+0x1ec>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    80007d34:	f3c40713          	addi	a4,s0,-196
    80007d38:	fc040793          	addi	a5,s0,-64
    80007d3c:	863a                	mv	a2,a4
    80007d3e:	85be                	mv	a1,a5
    80007d40:	fe843503          	ld	a0,-24(s0)
    80007d44:	ffffe097          	auipc	ra,0xffffe
    80007d48:	cb0080e7          	jalr	-848(ra) # 800059f4 <dirlookup>
    80007d4c:	fea43023          	sd	a0,-32(s0)
    80007d50:	fe043783          	ld	a5,-32(s0)
    80007d54:	12078a63          	beqz	a5,80007e88 <sys_unlink+0x1f0>
    goto bad;
  ilock(ip);
    80007d58:	fe043503          	ld	a0,-32(s0)
    80007d5c:	ffffd097          	auipc	ra,0xffffd
    80007d60:	35a080e7          	jalr	858(ra) # 800050b6 <ilock>

  if(ip->nlink < 1)
    80007d64:	fe043783          	ld	a5,-32(s0)
    80007d68:	04a79783          	lh	a5,74(a5)
    80007d6c:	00f04a63          	bgtz	a5,80007d80 <sys_unlink+0xe8>
    panic("unlink: nlink < 1");
    80007d70:	00004517          	auipc	a0,0x4
    80007d74:	8d050513          	addi	a0,a0,-1840 # 8000b640 <etext+0x640>
    80007d78:	ffff9097          	auipc	ra,0xffff9
    80007d7c:	f12080e7          	jalr	-238(ra) # 80000c8a <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80007d80:	fe043783          	ld	a5,-32(s0)
    80007d84:	04479783          	lh	a5,68(a5)
    80007d88:	873e                	mv	a4,a5
    80007d8a:	4785                	li	a5,1
    80007d8c:	02f71163          	bne	a4,a5,80007dae <sys_unlink+0x116>
    80007d90:	fe043503          	ld	a0,-32(s0)
    80007d94:	00000097          	auipc	ra,0x0
    80007d98:	e8a080e7          	jalr	-374(ra) # 80007c1e <isdirempty>
    80007d9c:	87aa                	mv	a5,a0
    80007d9e:	eb81                	bnez	a5,80007dae <sys_unlink+0x116>
    iunlockput(ip);
    80007da0:	fe043503          	ld	a0,-32(s0)
    80007da4:	ffffd097          	auipc	ra,0xffffd
    80007da8:	570080e7          	jalr	1392(ra) # 80005314 <iunlockput>
    goto bad;
    80007dac:	a8f9                	j	80007e8a <sys_unlink+0x1f2>
  }

  memset(&de, 0, sizeof(de));
    80007dae:	fd040793          	addi	a5,s0,-48
    80007db2:	4641                	li	a2,16
    80007db4:	4581                	li	a1,0
    80007db6:	853e                	mv	a0,a5
    80007db8:	ffff9097          	auipc	ra,0xffff9
    80007dbc:	69a080e7          	jalr	1690(ra) # 80001452 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80007dc0:	fd040793          	addi	a5,s0,-48
    80007dc4:	f3c42683          	lw	a3,-196(s0)
    80007dc8:	4741                	li	a4,16
    80007dca:	863e                	mv	a2,a5
    80007dcc:	4581                	li	a1,0
    80007dce:	fe843503          	ld	a0,-24(s0)
    80007dd2:	ffffe097          	auipc	ra,0xffffe
    80007dd6:	a38080e7          	jalr	-1480(ra) # 8000580a <writei>
    80007dda:	87aa                	mv	a5,a0
    80007ddc:	873e                	mv	a4,a5
    80007dde:	47c1                	li	a5,16
    80007de0:	00f70a63          	beq	a4,a5,80007df4 <sys_unlink+0x15c>
    panic("unlink: writei");
    80007de4:	00004517          	auipc	a0,0x4
    80007de8:	87450513          	addi	a0,a0,-1932 # 8000b658 <etext+0x658>
    80007dec:	ffff9097          	auipc	ra,0xffff9
    80007df0:	e9e080e7          	jalr	-354(ra) # 80000c8a <panic>
  if(ip->type == T_DIR){
    80007df4:	fe043783          	ld	a5,-32(s0)
    80007df8:	04479783          	lh	a5,68(a5)
    80007dfc:	873e                	mv	a4,a5
    80007dfe:	4785                	li	a5,1
    80007e00:	02f71963          	bne	a4,a5,80007e32 <sys_unlink+0x19a>
    dp->nlink--;
    80007e04:	fe843783          	ld	a5,-24(s0)
    80007e08:	04a79783          	lh	a5,74(a5)
    80007e0c:	17c2                	slli	a5,a5,0x30
    80007e0e:	93c1                	srli	a5,a5,0x30
    80007e10:	37fd                	addiw	a5,a5,-1
    80007e12:	17c2                	slli	a5,a5,0x30
    80007e14:	93c1                	srli	a5,a5,0x30
    80007e16:	0107971b          	slliw	a4,a5,0x10
    80007e1a:	4107571b          	sraiw	a4,a4,0x10
    80007e1e:	fe843783          	ld	a5,-24(s0)
    80007e22:	04e79523          	sh	a4,74(a5)
    iupdate(dp);
    80007e26:	fe843503          	ld	a0,-24(s0)
    80007e2a:	ffffd097          	auipc	ra,0xffffd
    80007e2e:	03c080e7          	jalr	60(ra) # 80004e66 <iupdate>
  }
  iunlockput(dp);
    80007e32:	fe843503          	ld	a0,-24(s0)
    80007e36:	ffffd097          	auipc	ra,0xffffd
    80007e3a:	4de080e7          	jalr	1246(ra) # 80005314 <iunlockput>

  ip->nlink--;
    80007e3e:	fe043783          	ld	a5,-32(s0)
    80007e42:	04a79783          	lh	a5,74(a5)
    80007e46:	17c2                	slli	a5,a5,0x30
    80007e48:	93c1                	srli	a5,a5,0x30
    80007e4a:	37fd                	addiw	a5,a5,-1
    80007e4c:	17c2                	slli	a5,a5,0x30
    80007e4e:	93c1                	srli	a5,a5,0x30
    80007e50:	0107971b          	slliw	a4,a5,0x10
    80007e54:	4107571b          	sraiw	a4,a4,0x10
    80007e58:	fe043783          	ld	a5,-32(s0)
    80007e5c:	04e79523          	sh	a4,74(a5)
  iupdate(ip);
    80007e60:	fe043503          	ld	a0,-32(s0)
    80007e64:	ffffd097          	auipc	ra,0xffffd
    80007e68:	002080e7          	jalr	2(ra) # 80004e66 <iupdate>
  iunlockput(ip);
    80007e6c:	fe043503          	ld	a0,-32(s0)
    80007e70:	ffffd097          	auipc	ra,0xffffd
    80007e74:	4a4080e7          	jalr	1188(ra) # 80005314 <iunlockput>

  end_op();
    80007e78:	ffffe097          	auipc	ra,0xffffe
    80007e7c:	394080e7          	jalr	916(ra) # 8000620c <end_op>

  return 0;
    80007e80:	4781                	li	a5,0
    80007e82:	a839                	j	80007ea0 <sys_unlink+0x208>
    goto bad;
    80007e84:	0001                	nop
    80007e86:	a011                	j	80007e8a <sys_unlink+0x1f2>
    goto bad;
    80007e88:	0001                	nop

bad:
  iunlockput(dp);
    80007e8a:	fe843503          	ld	a0,-24(s0)
    80007e8e:	ffffd097          	auipc	ra,0xffffd
    80007e92:	486080e7          	jalr	1158(ra) # 80005314 <iunlockput>
  end_op();
    80007e96:	ffffe097          	auipc	ra,0xffffe
    80007e9a:	376080e7          	jalr	886(ra) # 8000620c <end_op>
  return -1;
    80007e9e:	57fd                	li	a5,-1
}
    80007ea0:	853e                	mv	a0,a5
    80007ea2:	60ae                	ld	ra,200(sp)
    80007ea4:	640e                	ld	s0,192(sp)
    80007ea6:	6169                	addi	sp,sp,208
    80007ea8:	8082                	ret

0000000080007eaa <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
    80007eaa:	7139                	addi	sp,sp,-64
    80007eac:	fc06                	sd	ra,56(sp)
    80007eae:	f822                	sd	s0,48(sp)
    80007eb0:	0080                	addi	s0,sp,64
    80007eb2:	fca43423          	sd	a0,-56(s0)
    80007eb6:	87ae                	mv	a5,a1
    80007eb8:	8736                	mv	a4,a3
    80007eba:	fcf41323          	sh	a5,-58(s0)
    80007ebe:	87b2                	mv	a5,a2
    80007ec0:	fcf41223          	sh	a5,-60(s0)
    80007ec4:	87ba                	mv	a5,a4
    80007ec6:	fcf41123          	sh	a5,-62(s0)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80007eca:	fd040793          	addi	a5,s0,-48
    80007ece:	85be                	mv	a1,a5
    80007ed0:	fc843503          	ld	a0,-56(s0)
    80007ed4:	ffffe097          	auipc	ra,0xffffe
    80007ed8:	f3e080e7          	jalr	-194(ra) # 80005e12 <nameiparent>
    80007edc:	fea43423          	sd	a0,-24(s0)
    80007ee0:	fe843783          	ld	a5,-24(s0)
    80007ee4:	e399                	bnez	a5,80007eea <create+0x40>
    return 0;
    80007ee6:	4781                	li	a5,0
    80007ee8:	a2dd                	j	800080ce <create+0x224>

  ilock(dp);
    80007eea:	fe843503          	ld	a0,-24(s0)
    80007eee:	ffffd097          	auipc	ra,0xffffd
    80007ef2:	1c8080e7          	jalr	456(ra) # 800050b6 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80007ef6:	fd040793          	addi	a5,s0,-48
    80007efa:	4601                	li	a2,0
    80007efc:	85be                	mv	a1,a5
    80007efe:	fe843503          	ld	a0,-24(s0)
    80007f02:	ffffe097          	auipc	ra,0xffffe
    80007f06:	af2080e7          	jalr	-1294(ra) # 800059f4 <dirlookup>
    80007f0a:	fea43023          	sd	a0,-32(s0)
    80007f0e:	fe043783          	ld	a5,-32(s0)
    80007f12:	cfb9                	beqz	a5,80007f70 <create+0xc6>
    iunlockput(dp);
    80007f14:	fe843503          	ld	a0,-24(s0)
    80007f18:	ffffd097          	auipc	ra,0xffffd
    80007f1c:	3fc080e7          	jalr	1020(ra) # 80005314 <iunlockput>
    ilock(ip);
    80007f20:	fe043503          	ld	a0,-32(s0)
    80007f24:	ffffd097          	auipc	ra,0xffffd
    80007f28:	192080e7          	jalr	402(ra) # 800050b6 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80007f2c:	fc641783          	lh	a5,-58(s0)
    80007f30:	0007871b          	sext.w	a4,a5
    80007f34:	4789                	li	a5,2
    80007f36:	02f71563          	bne	a4,a5,80007f60 <create+0xb6>
    80007f3a:	fe043783          	ld	a5,-32(s0)
    80007f3e:	04479783          	lh	a5,68(a5)
    80007f42:	873e                	mv	a4,a5
    80007f44:	4789                	li	a5,2
    80007f46:	00f70a63          	beq	a4,a5,80007f5a <create+0xb0>
    80007f4a:	fe043783          	ld	a5,-32(s0)
    80007f4e:	04479783          	lh	a5,68(a5)
    80007f52:	873e                	mv	a4,a5
    80007f54:	478d                	li	a5,3
    80007f56:	00f71563          	bne	a4,a5,80007f60 <create+0xb6>
      return ip;
    80007f5a:	fe043783          	ld	a5,-32(s0)
    80007f5e:	aa85                	j	800080ce <create+0x224>
    iunlockput(ip);
    80007f60:	fe043503          	ld	a0,-32(s0)
    80007f64:	ffffd097          	auipc	ra,0xffffd
    80007f68:	3b0080e7          	jalr	944(ra) # 80005314 <iunlockput>
    return 0;
    80007f6c:	4781                	li	a5,0
    80007f6e:	a285                	j	800080ce <create+0x224>
  }

  if((ip = ialloc(dp->dev, type)) == 0){
    80007f70:	fe843783          	ld	a5,-24(s0)
    80007f74:	439c                	lw	a5,0(a5)
    80007f76:	fc641703          	lh	a4,-58(s0)
    80007f7a:	85ba                	mv	a1,a4
    80007f7c:	853e                	mv	a0,a5
    80007f7e:	ffffd097          	auipc	ra,0xffffd
    80007f82:	dea080e7          	jalr	-534(ra) # 80004d68 <ialloc>
    80007f86:	fea43023          	sd	a0,-32(s0)
    80007f8a:	fe043783          	ld	a5,-32(s0)
    80007f8e:	eb89                	bnez	a5,80007fa0 <create+0xf6>
    iunlockput(dp);
    80007f90:	fe843503          	ld	a0,-24(s0)
    80007f94:	ffffd097          	auipc	ra,0xffffd
    80007f98:	380080e7          	jalr	896(ra) # 80005314 <iunlockput>
    return 0;
    80007f9c:	4781                	li	a5,0
    80007f9e:	aa05                	j	800080ce <create+0x224>
  }

  ilock(ip);
    80007fa0:	fe043503          	ld	a0,-32(s0)
    80007fa4:	ffffd097          	auipc	ra,0xffffd
    80007fa8:	112080e7          	jalr	274(ra) # 800050b6 <ilock>
  ip->major = major;
    80007fac:	fe043783          	ld	a5,-32(s0)
    80007fb0:	fc445703          	lhu	a4,-60(s0)
    80007fb4:	04e79323          	sh	a4,70(a5)
  ip->minor = minor;
    80007fb8:	fe043783          	ld	a5,-32(s0)
    80007fbc:	fc245703          	lhu	a4,-62(s0)
    80007fc0:	04e79423          	sh	a4,72(a5)
  ip->nlink = 1;
    80007fc4:	fe043783          	ld	a5,-32(s0)
    80007fc8:	4705                	li	a4,1
    80007fca:	04e79523          	sh	a4,74(a5)
  iupdate(ip);
    80007fce:	fe043503          	ld	a0,-32(s0)
    80007fd2:	ffffd097          	auipc	ra,0xffffd
    80007fd6:	e94080e7          	jalr	-364(ra) # 80004e66 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
    80007fda:	fc641783          	lh	a5,-58(s0)
    80007fde:	0007871b          	sext.w	a4,a5
    80007fe2:	4785                	li	a5,1
    80007fe4:	04f71463          	bne	a4,a5,8000802c <create+0x182>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80007fe8:	fe043783          	ld	a5,-32(s0)
    80007fec:	43dc                	lw	a5,4(a5)
    80007fee:	863e                	mv	a2,a5
    80007ff0:	00003597          	auipc	a1,0x3
    80007ff4:	64058593          	addi	a1,a1,1600 # 8000b630 <etext+0x630>
    80007ff8:	fe043503          	ld	a0,-32(s0)
    80007ffc:	ffffe097          	auipc	ra,0xffffe
    80008000:	ade080e7          	jalr	-1314(ra) # 80005ada <dirlink>
    80008004:	87aa                	mv	a5,a0
    80008006:	0807ca63          	bltz	a5,8000809a <create+0x1f0>
    8000800a:	fe843783          	ld	a5,-24(s0)
    8000800e:	43dc                	lw	a5,4(a5)
    80008010:	863e                	mv	a2,a5
    80008012:	00003597          	auipc	a1,0x3
    80008016:	62658593          	addi	a1,a1,1574 # 8000b638 <etext+0x638>
    8000801a:	fe043503          	ld	a0,-32(s0)
    8000801e:	ffffe097          	auipc	ra,0xffffe
    80008022:	abc080e7          	jalr	-1348(ra) # 80005ada <dirlink>
    80008026:	87aa                	mv	a5,a0
    80008028:	0607c963          	bltz	a5,8000809a <create+0x1f0>
      goto fail;
  }

  if(dirlink(dp, name, ip->inum) < 0)
    8000802c:	fe043783          	ld	a5,-32(s0)
    80008030:	43d8                	lw	a4,4(a5)
    80008032:	fd040793          	addi	a5,s0,-48
    80008036:	863a                	mv	a2,a4
    80008038:	85be                	mv	a1,a5
    8000803a:	fe843503          	ld	a0,-24(s0)
    8000803e:	ffffe097          	auipc	ra,0xffffe
    80008042:	a9c080e7          	jalr	-1380(ra) # 80005ada <dirlink>
    80008046:	87aa                	mv	a5,a0
    80008048:	0407cb63          	bltz	a5,8000809e <create+0x1f4>
    goto fail;

  if(type == T_DIR){
    8000804c:	fc641783          	lh	a5,-58(s0)
    80008050:	0007871b          	sext.w	a4,a5
    80008054:	4785                	li	a5,1
    80008056:	02f71963          	bne	a4,a5,80008088 <create+0x1de>
    // now that success is guaranteed:
    dp->nlink++;  // for ".."
    8000805a:	fe843783          	ld	a5,-24(s0)
    8000805e:	04a79783          	lh	a5,74(a5)
    80008062:	17c2                	slli	a5,a5,0x30
    80008064:	93c1                	srli	a5,a5,0x30
    80008066:	2785                	addiw	a5,a5,1
    80008068:	17c2                	slli	a5,a5,0x30
    8000806a:	93c1                	srli	a5,a5,0x30
    8000806c:	0107971b          	slliw	a4,a5,0x10
    80008070:	4107571b          	sraiw	a4,a4,0x10
    80008074:	fe843783          	ld	a5,-24(s0)
    80008078:	04e79523          	sh	a4,74(a5)
    iupdate(dp);
    8000807c:	fe843503          	ld	a0,-24(s0)
    80008080:	ffffd097          	auipc	ra,0xffffd
    80008084:	de6080e7          	jalr	-538(ra) # 80004e66 <iupdate>
  }

  iunlockput(dp);
    80008088:	fe843503          	ld	a0,-24(s0)
    8000808c:	ffffd097          	auipc	ra,0xffffd
    80008090:	288080e7          	jalr	648(ra) # 80005314 <iunlockput>

  return ip;
    80008094:	fe043783          	ld	a5,-32(s0)
    80008098:	a81d                	j	800080ce <create+0x224>
      goto fail;
    8000809a:	0001                	nop
    8000809c:	a011                	j	800080a0 <create+0x1f6>
    goto fail;
    8000809e:	0001                	nop

 fail:
  // something went wrong. de-allocate ip.
  ip->nlink = 0;
    800080a0:	fe043783          	ld	a5,-32(s0)
    800080a4:	04079523          	sh	zero,74(a5)
  iupdate(ip);
    800080a8:	fe043503          	ld	a0,-32(s0)
    800080ac:	ffffd097          	auipc	ra,0xffffd
    800080b0:	dba080e7          	jalr	-582(ra) # 80004e66 <iupdate>
  iunlockput(ip);
    800080b4:	fe043503          	ld	a0,-32(s0)
    800080b8:	ffffd097          	auipc	ra,0xffffd
    800080bc:	25c080e7          	jalr	604(ra) # 80005314 <iunlockput>
  iunlockput(dp);
    800080c0:	fe843503          	ld	a0,-24(s0)
    800080c4:	ffffd097          	auipc	ra,0xffffd
    800080c8:	250080e7          	jalr	592(ra) # 80005314 <iunlockput>
  return 0;
    800080cc:	4781                	li	a5,0
}
    800080ce:	853e                	mv	a0,a5
    800080d0:	70e2                	ld	ra,56(sp)
    800080d2:	7442                	ld	s0,48(sp)
    800080d4:	6121                	addi	sp,sp,64
    800080d6:	8082                	ret

00000000800080d8 <sys_open>:

uint64
sys_open(void)
{
    800080d8:	7131                	addi	sp,sp,-192
    800080da:	fd06                	sd	ra,184(sp)
    800080dc:	f922                	sd	s0,176(sp)
    800080de:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800080e0:	f4c40793          	addi	a5,s0,-180
    800080e4:	85be                	mv	a1,a5
    800080e6:	4505                	li	a0,1
    800080e8:	ffffc097          	auipc	ra,0xffffc
    800080ec:	02c080e7          	jalr	44(ra) # 80004114 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800080f0:	f5040793          	addi	a5,s0,-176
    800080f4:	08000613          	li	a2,128
    800080f8:	85be                	mv	a1,a5
    800080fa:	4501                	li	a0,0
    800080fc:	ffffc097          	auipc	ra,0xffffc
    80008100:	080080e7          	jalr	128(ra) # 8000417c <argstr>
    80008104:	87aa                	mv	a5,a0
    80008106:	fef42223          	sw	a5,-28(s0)
    8000810a:	fe442783          	lw	a5,-28(s0)
    8000810e:	2781                	sext.w	a5,a5
    80008110:	0007d463          	bgez	a5,80008118 <sys_open+0x40>
    return -1;
    80008114:	57fd                	li	a5,-1
    80008116:	aafd                	j	80008314 <sys_open+0x23c>

  begin_op();
    80008118:	ffffe097          	auipc	ra,0xffffe
    8000811c:	032080e7          	jalr	50(ra) # 8000614a <begin_op>

  if(omode & O_CREATE){
    80008120:	f4c42783          	lw	a5,-180(s0)
    80008124:	2007f793          	andi	a5,a5,512
    80008128:	2781                	sext.w	a5,a5
    8000812a:	c795                	beqz	a5,80008156 <sys_open+0x7e>
    ip = create(path, T_FILE, 0, 0);
    8000812c:	f5040793          	addi	a5,s0,-176
    80008130:	4681                	li	a3,0
    80008132:	4601                	li	a2,0
    80008134:	4589                	li	a1,2
    80008136:	853e                	mv	a0,a5
    80008138:	00000097          	auipc	ra,0x0
    8000813c:	d72080e7          	jalr	-654(ra) # 80007eaa <create>
    80008140:	fea43423          	sd	a0,-24(s0)
    if(ip == 0){
    80008144:	fe843783          	ld	a5,-24(s0)
    80008148:	e7b5                	bnez	a5,800081b4 <sys_open+0xdc>
      end_op();
    8000814a:	ffffe097          	auipc	ra,0xffffe
    8000814e:	0c2080e7          	jalr	194(ra) # 8000620c <end_op>
      return -1;
    80008152:	57fd                	li	a5,-1
    80008154:	a2c1                	j	80008314 <sys_open+0x23c>
    }
  } else {
    if((ip = namei(path)) == 0){
    80008156:	f5040793          	addi	a5,s0,-176
    8000815a:	853e                	mv	a0,a5
    8000815c:	ffffe097          	auipc	ra,0xffffe
    80008160:	c8a080e7          	jalr	-886(ra) # 80005de6 <namei>
    80008164:	fea43423          	sd	a0,-24(s0)
    80008168:	fe843783          	ld	a5,-24(s0)
    8000816c:	e799                	bnez	a5,8000817a <sys_open+0xa2>
      end_op();
    8000816e:	ffffe097          	auipc	ra,0xffffe
    80008172:	09e080e7          	jalr	158(ra) # 8000620c <end_op>
      return -1;
    80008176:	57fd                	li	a5,-1
    80008178:	aa71                	j	80008314 <sys_open+0x23c>
    }
    ilock(ip);
    8000817a:	fe843503          	ld	a0,-24(s0)
    8000817e:	ffffd097          	auipc	ra,0xffffd
    80008182:	f38080e7          	jalr	-200(ra) # 800050b6 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80008186:	fe843783          	ld	a5,-24(s0)
    8000818a:	04479783          	lh	a5,68(a5)
    8000818e:	873e                	mv	a4,a5
    80008190:	4785                	li	a5,1
    80008192:	02f71163          	bne	a4,a5,800081b4 <sys_open+0xdc>
    80008196:	f4c42783          	lw	a5,-180(s0)
    8000819a:	cf89                	beqz	a5,800081b4 <sys_open+0xdc>
      iunlockput(ip);
    8000819c:	fe843503          	ld	a0,-24(s0)
    800081a0:	ffffd097          	auipc	ra,0xffffd
    800081a4:	174080e7          	jalr	372(ra) # 80005314 <iunlockput>
      end_op();
    800081a8:	ffffe097          	auipc	ra,0xffffe
    800081ac:	064080e7          	jalr	100(ra) # 8000620c <end_op>
      return -1;
    800081b0:	57fd                	li	a5,-1
    800081b2:	a28d                	j	80008314 <sys_open+0x23c>
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800081b4:	fe843783          	ld	a5,-24(s0)
    800081b8:	04479783          	lh	a5,68(a5)
    800081bc:	873e                	mv	a4,a5
    800081be:	478d                	li	a5,3
    800081c0:	02f71c63          	bne	a4,a5,800081f8 <sys_open+0x120>
    800081c4:	fe843783          	ld	a5,-24(s0)
    800081c8:	04679783          	lh	a5,70(a5)
    800081cc:	0007ca63          	bltz	a5,800081e0 <sys_open+0x108>
    800081d0:	fe843783          	ld	a5,-24(s0)
    800081d4:	04679783          	lh	a5,70(a5)
    800081d8:	873e                	mv	a4,a5
    800081da:	47a5                	li	a5,9
    800081dc:	00e7de63          	bge	a5,a4,800081f8 <sys_open+0x120>
    iunlockput(ip);
    800081e0:	fe843503          	ld	a0,-24(s0)
    800081e4:	ffffd097          	auipc	ra,0xffffd
    800081e8:	130080e7          	jalr	304(ra) # 80005314 <iunlockput>
    end_op();
    800081ec:	ffffe097          	auipc	ra,0xffffe
    800081f0:	020080e7          	jalr	32(ra) # 8000620c <end_op>
    return -1;
    800081f4:	57fd                	li	a5,-1
    800081f6:	aa39                	j	80008314 <sys_open+0x23c>
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800081f8:	ffffe097          	auipc	ra,0xffffe
    800081fc:	502080e7          	jalr	1282(ra) # 800066fa <filealloc>
    80008200:	fca43c23          	sd	a0,-40(s0)
    80008204:	fd843783          	ld	a5,-40(s0)
    80008208:	cf99                	beqz	a5,80008226 <sys_open+0x14e>
    8000820a:	fd843503          	ld	a0,-40(s0)
    8000820e:	fffff097          	auipc	ra,0xfffff
    80008212:	5fc080e7          	jalr	1532(ra) # 8000780a <fdalloc>
    80008216:	87aa                	mv	a5,a0
    80008218:	fcf42a23          	sw	a5,-44(s0)
    8000821c:	fd442783          	lw	a5,-44(s0)
    80008220:	2781                	sext.w	a5,a5
    80008222:	0207d763          	bgez	a5,80008250 <sys_open+0x178>
    if(f)
    80008226:	fd843783          	ld	a5,-40(s0)
    8000822a:	c799                	beqz	a5,80008238 <sys_open+0x160>
      fileclose(f);
    8000822c:	fd843503          	ld	a0,-40(s0)
    80008230:	ffffe097          	auipc	ra,0xffffe
    80008234:	5b4080e7          	jalr	1460(ra) # 800067e4 <fileclose>
    iunlockput(ip);
    80008238:	fe843503          	ld	a0,-24(s0)
    8000823c:	ffffd097          	auipc	ra,0xffffd
    80008240:	0d8080e7          	jalr	216(ra) # 80005314 <iunlockput>
    end_op();
    80008244:	ffffe097          	auipc	ra,0xffffe
    80008248:	fc8080e7          	jalr	-56(ra) # 8000620c <end_op>
    return -1;
    8000824c:	57fd                	li	a5,-1
    8000824e:	a0d9                	j	80008314 <sys_open+0x23c>
  }

  if(ip->type == T_DEVICE){
    80008250:	fe843783          	ld	a5,-24(s0)
    80008254:	04479783          	lh	a5,68(a5)
    80008258:	873e                	mv	a4,a5
    8000825a:	478d                	li	a5,3
    8000825c:	00f71f63          	bne	a4,a5,8000827a <sys_open+0x1a2>
    f->type = FD_DEVICE;
    80008260:	fd843783          	ld	a5,-40(s0)
    80008264:	470d                	li	a4,3
    80008266:	c398                	sw	a4,0(a5)
    f->major = ip->major;
    80008268:	fe843783          	ld	a5,-24(s0)
    8000826c:	04679703          	lh	a4,70(a5)
    80008270:	fd843783          	ld	a5,-40(s0)
    80008274:	02e79223          	sh	a4,36(a5)
    80008278:	a809                	j	8000828a <sys_open+0x1b2>
  } else {
    f->type = FD_INODE;
    8000827a:	fd843783          	ld	a5,-40(s0)
    8000827e:	4709                	li	a4,2
    80008280:	c398                	sw	a4,0(a5)
    f->off = 0;
    80008282:	fd843783          	ld	a5,-40(s0)
    80008286:	0207a023          	sw	zero,32(a5)
  }
  f->ip = ip;
    8000828a:	fd843783          	ld	a5,-40(s0)
    8000828e:	fe843703          	ld	a4,-24(s0)
    80008292:	ef98                	sd	a4,24(a5)
  f->readable = !(omode & O_WRONLY);
    80008294:	f4c42783          	lw	a5,-180(s0)
    80008298:	8b85                	andi	a5,a5,1
    8000829a:	2781                	sext.w	a5,a5
    8000829c:	0017b793          	seqz	a5,a5
    800082a0:	0ff7f793          	zext.b	a5,a5
    800082a4:	873e                	mv	a4,a5
    800082a6:	fd843783          	ld	a5,-40(s0)
    800082aa:	00e78423          	sb	a4,8(a5)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800082ae:	f4c42783          	lw	a5,-180(s0)
    800082b2:	8b85                	andi	a5,a5,1
    800082b4:	2781                	sext.w	a5,a5
    800082b6:	e791                	bnez	a5,800082c2 <sys_open+0x1ea>
    800082b8:	f4c42783          	lw	a5,-180(s0)
    800082bc:	8b89                	andi	a5,a5,2
    800082be:	2781                	sext.w	a5,a5
    800082c0:	c399                	beqz	a5,800082c6 <sys_open+0x1ee>
    800082c2:	4785                	li	a5,1
    800082c4:	a011                	j	800082c8 <sys_open+0x1f0>
    800082c6:	4781                	li	a5,0
    800082c8:	0ff7f713          	zext.b	a4,a5
    800082cc:	fd843783          	ld	a5,-40(s0)
    800082d0:	00e784a3          	sb	a4,9(a5)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800082d4:	f4c42783          	lw	a5,-180(s0)
    800082d8:	4007f793          	andi	a5,a5,1024
    800082dc:	2781                	sext.w	a5,a5
    800082de:	cf99                	beqz	a5,800082fc <sys_open+0x224>
    800082e0:	fe843783          	ld	a5,-24(s0)
    800082e4:	04479783          	lh	a5,68(a5)
    800082e8:	873e                	mv	a4,a5
    800082ea:	4789                	li	a5,2
    800082ec:	00f71863          	bne	a4,a5,800082fc <sys_open+0x224>
    itrunc(ip);
    800082f0:	fe843503          	ld	a0,-24(s0)
    800082f4:	ffffd097          	auipc	ra,0xffffd
    800082f8:	1ca080e7          	jalr	458(ra) # 800054be <itrunc>
  }

  iunlock(ip);
    800082fc:	fe843503          	ld	a0,-24(s0)
    80008300:	ffffd097          	auipc	ra,0xffffd
    80008304:	eea080e7          	jalr	-278(ra) # 800051ea <iunlock>
  end_op();
    80008308:	ffffe097          	auipc	ra,0xffffe
    8000830c:	f04080e7          	jalr	-252(ra) # 8000620c <end_op>

  return fd;
    80008310:	fd442783          	lw	a5,-44(s0)
}
    80008314:	853e                	mv	a0,a5
    80008316:	70ea                	ld	ra,184(sp)
    80008318:	744a                	ld	s0,176(sp)
    8000831a:	6129                	addi	sp,sp,192
    8000831c:	8082                	ret

000000008000831e <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000831e:	7135                	addi	sp,sp,-160
    80008320:	ed06                	sd	ra,152(sp)
    80008322:	e922                	sd	s0,144(sp)
    80008324:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80008326:	ffffe097          	auipc	ra,0xffffe
    8000832a:	e24080e7          	jalr	-476(ra) # 8000614a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000832e:	f6840793          	addi	a5,s0,-152
    80008332:	08000613          	li	a2,128
    80008336:	85be                	mv	a1,a5
    80008338:	4501                	li	a0,0
    8000833a:	ffffc097          	auipc	ra,0xffffc
    8000833e:	e42080e7          	jalr	-446(ra) # 8000417c <argstr>
    80008342:	87aa                	mv	a5,a0
    80008344:	0207c163          	bltz	a5,80008366 <sys_mkdir+0x48>
    80008348:	f6840793          	addi	a5,s0,-152
    8000834c:	4681                	li	a3,0
    8000834e:	4601                	li	a2,0
    80008350:	4585                	li	a1,1
    80008352:	853e                	mv	a0,a5
    80008354:	00000097          	auipc	ra,0x0
    80008358:	b56080e7          	jalr	-1194(ra) # 80007eaa <create>
    8000835c:	fea43423          	sd	a0,-24(s0)
    80008360:	fe843783          	ld	a5,-24(s0)
    80008364:	e799                	bnez	a5,80008372 <sys_mkdir+0x54>
    end_op();
    80008366:	ffffe097          	auipc	ra,0xffffe
    8000836a:	ea6080e7          	jalr	-346(ra) # 8000620c <end_op>
    return -1;
    8000836e:	57fd                	li	a5,-1
    80008370:	a821                	j	80008388 <sys_mkdir+0x6a>
  }
  iunlockput(ip);
    80008372:	fe843503          	ld	a0,-24(s0)
    80008376:	ffffd097          	auipc	ra,0xffffd
    8000837a:	f9e080e7          	jalr	-98(ra) # 80005314 <iunlockput>
  end_op();
    8000837e:	ffffe097          	auipc	ra,0xffffe
    80008382:	e8e080e7          	jalr	-370(ra) # 8000620c <end_op>
  return 0;
    80008386:	4781                	li	a5,0
}
    80008388:	853e                	mv	a0,a5
    8000838a:	60ea                	ld	ra,152(sp)
    8000838c:	644a                	ld	s0,144(sp)
    8000838e:	610d                	addi	sp,sp,160
    80008390:	8082                	ret

0000000080008392 <sys_mknod>:

uint64
sys_mknod(void)
{
    80008392:	7135                	addi	sp,sp,-160
    80008394:	ed06                	sd	ra,152(sp)
    80008396:	e922                	sd	s0,144(sp)
    80008398:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000839a:	ffffe097          	auipc	ra,0xffffe
    8000839e:	db0080e7          	jalr	-592(ra) # 8000614a <begin_op>
  argint(1, &major);
    800083a2:	f6440793          	addi	a5,s0,-156
    800083a6:	85be                	mv	a1,a5
    800083a8:	4505                	li	a0,1
    800083aa:	ffffc097          	auipc	ra,0xffffc
    800083ae:	d6a080e7          	jalr	-662(ra) # 80004114 <argint>
  argint(2, &minor);
    800083b2:	f6040793          	addi	a5,s0,-160
    800083b6:	85be                	mv	a1,a5
    800083b8:	4509                	li	a0,2
    800083ba:	ffffc097          	auipc	ra,0xffffc
    800083be:	d5a080e7          	jalr	-678(ra) # 80004114 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800083c2:	f6840793          	addi	a5,s0,-152
    800083c6:	08000613          	li	a2,128
    800083ca:	85be                	mv	a1,a5
    800083cc:	4501                	li	a0,0
    800083ce:	ffffc097          	auipc	ra,0xffffc
    800083d2:	dae080e7          	jalr	-594(ra) # 8000417c <argstr>
    800083d6:	87aa                	mv	a5,a0
    800083d8:	0207cc63          	bltz	a5,80008410 <sys_mknod+0x7e>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800083dc:	f6442783          	lw	a5,-156(s0)
    800083e0:	0107971b          	slliw	a4,a5,0x10
    800083e4:	4107571b          	sraiw	a4,a4,0x10
    800083e8:	f6042783          	lw	a5,-160(s0)
    800083ec:	0107969b          	slliw	a3,a5,0x10
    800083f0:	4106d69b          	sraiw	a3,a3,0x10
    800083f4:	f6840793          	addi	a5,s0,-152
    800083f8:	863a                	mv	a2,a4
    800083fa:	458d                	li	a1,3
    800083fc:	853e                	mv	a0,a5
    800083fe:	00000097          	auipc	ra,0x0
    80008402:	aac080e7          	jalr	-1364(ra) # 80007eaa <create>
    80008406:	fea43423          	sd	a0,-24(s0)
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000840a:	fe843783          	ld	a5,-24(s0)
    8000840e:	e799                	bnez	a5,8000841c <sys_mknod+0x8a>
    end_op();
    80008410:	ffffe097          	auipc	ra,0xffffe
    80008414:	dfc080e7          	jalr	-516(ra) # 8000620c <end_op>
    return -1;
    80008418:	57fd                	li	a5,-1
    8000841a:	a821                	j	80008432 <sys_mknod+0xa0>
  }
  iunlockput(ip);
    8000841c:	fe843503          	ld	a0,-24(s0)
    80008420:	ffffd097          	auipc	ra,0xffffd
    80008424:	ef4080e7          	jalr	-268(ra) # 80005314 <iunlockput>
  end_op();
    80008428:	ffffe097          	auipc	ra,0xffffe
    8000842c:	de4080e7          	jalr	-540(ra) # 8000620c <end_op>
  return 0;
    80008430:	4781                	li	a5,0
}
    80008432:	853e                	mv	a0,a5
    80008434:	60ea                	ld	ra,152(sp)
    80008436:	644a                	ld	s0,144(sp)
    80008438:	610d                	addi	sp,sp,160
    8000843a:	8082                	ret

000000008000843c <sys_chdir>:

uint64
sys_chdir(void)
{
    8000843c:	7135                	addi	sp,sp,-160
    8000843e:	ed06                	sd	ra,152(sp)
    80008440:	e922                	sd	s0,144(sp)
    80008442:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80008444:	ffffa097          	auipc	ra,0xffffa
    80008448:	402080e7          	jalr	1026(ra) # 80002846 <myproc>
    8000844c:	fea43423          	sd	a0,-24(s0)
  
  begin_op();
    80008450:	ffffe097          	auipc	ra,0xffffe
    80008454:	cfa080e7          	jalr	-774(ra) # 8000614a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80008458:	f6040793          	addi	a5,s0,-160
    8000845c:	08000613          	li	a2,128
    80008460:	85be                	mv	a1,a5
    80008462:	4501                	li	a0,0
    80008464:	ffffc097          	auipc	ra,0xffffc
    80008468:	d18080e7          	jalr	-744(ra) # 8000417c <argstr>
    8000846c:	87aa                	mv	a5,a0
    8000846e:	0007ce63          	bltz	a5,8000848a <sys_chdir+0x4e>
    80008472:	f6040793          	addi	a5,s0,-160
    80008476:	853e                	mv	a0,a5
    80008478:	ffffe097          	auipc	ra,0xffffe
    8000847c:	96e080e7          	jalr	-1682(ra) # 80005de6 <namei>
    80008480:	fea43023          	sd	a0,-32(s0)
    80008484:	fe043783          	ld	a5,-32(s0)
    80008488:	e799                	bnez	a5,80008496 <sys_chdir+0x5a>
    end_op();
    8000848a:	ffffe097          	auipc	ra,0xffffe
    8000848e:	d82080e7          	jalr	-638(ra) # 8000620c <end_op>
    return -1;
    80008492:	57fd                	li	a5,-1
    80008494:	a0ad                	j	800084fe <sys_chdir+0xc2>
  }
  ilock(ip);
    80008496:	fe043503          	ld	a0,-32(s0)
    8000849a:	ffffd097          	auipc	ra,0xffffd
    8000849e:	c1c080e7          	jalr	-996(ra) # 800050b6 <ilock>
  if(ip->type != T_DIR){
    800084a2:	fe043783          	ld	a5,-32(s0)
    800084a6:	04479783          	lh	a5,68(a5)
    800084aa:	873e                	mv	a4,a5
    800084ac:	4785                	li	a5,1
    800084ae:	00f70e63          	beq	a4,a5,800084ca <sys_chdir+0x8e>
    iunlockput(ip);
    800084b2:	fe043503          	ld	a0,-32(s0)
    800084b6:	ffffd097          	auipc	ra,0xffffd
    800084ba:	e5e080e7          	jalr	-418(ra) # 80005314 <iunlockput>
    end_op();
    800084be:	ffffe097          	auipc	ra,0xffffe
    800084c2:	d4e080e7          	jalr	-690(ra) # 8000620c <end_op>
    return -1;
    800084c6:	57fd                	li	a5,-1
    800084c8:	a81d                	j	800084fe <sys_chdir+0xc2>
  }
  iunlock(ip);
    800084ca:	fe043503          	ld	a0,-32(s0)
    800084ce:	ffffd097          	auipc	ra,0xffffd
    800084d2:	d1c080e7          	jalr	-740(ra) # 800051ea <iunlock>
  iput(p->cwd);
    800084d6:	fe843783          	ld	a5,-24(s0)
    800084da:	1507b783          	ld	a5,336(a5)
    800084de:	853e                	mv	a0,a5
    800084e0:	ffffd097          	auipc	ra,0xffffd
    800084e4:	d64080e7          	jalr	-668(ra) # 80005244 <iput>
  end_op();
    800084e8:	ffffe097          	auipc	ra,0xffffe
    800084ec:	d24080e7          	jalr	-732(ra) # 8000620c <end_op>
  p->cwd = ip;
    800084f0:	fe843783          	ld	a5,-24(s0)
    800084f4:	fe043703          	ld	a4,-32(s0)
    800084f8:	14e7b823          	sd	a4,336(a5)
  return 0;
    800084fc:	4781                	li	a5,0
}
    800084fe:	853e                	mv	a0,a5
    80008500:	60ea                	ld	ra,152(sp)
    80008502:	644a                	ld	s0,144(sp)
    80008504:	610d                	addi	sp,sp,160
    80008506:	8082                	ret

0000000080008508 <sys_exec>:

uint64
sys_exec(void)
{
    80008508:	7161                	addi	sp,sp,-432
    8000850a:	f706                	sd	ra,424(sp)
    8000850c:	f322                	sd	s0,416(sp)
    8000850e:	1b00                	addi	s0,sp,432
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80008510:	e6040793          	addi	a5,s0,-416
    80008514:	85be                	mv	a1,a5
    80008516:	4505                	li	a0,1
    80008518:	ffffc097          	auipc	ra,0xffffc
    8000851c:	c32080e7          	jalr	-974(ra) # 8000414a <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80008520:	f6840793          	addi	a5,s0,-152
    80008524:	08000613          	li	a2,128
    80008528:	85be                	mv	a1,a5
    8000852a:	4501                	li	a0,0
    8000852c:	ffffc097          	auipc	ra,0xffffc
    80008530:	c50080e7          	jalr	-944(ra) # 8000417c <argstr>
    80008534:	87aa                	mv	a5,a0
    80008536:	0007d463          	bgez	a5,8000853e <sys_exec+0x36>
    return -1;
    8000853a:	57fd                	li	a5,-1
    8000853c:	aa8d                	j	800086ae <sys_exec+0x1a6>
  }
  memset(argv, 0, sizeof(argv));
    8000853e:	e6840793          	addi	a5,s0,-408
    80008542:	10000613          	li	a2,256
    80008546:	4581                	li	a1,0
    80008548:	853e                	mv	a0,a5
    8000854a:	ffff9097          	auipc	ra,0xffff9
    8000854e:	f08080e7          	jalr	-248(ra) # 80001452 <memset>
  for(i=0;; i++){
    80008552:	fe042623          	sw	zero,-20(s0)
    if(i >= NELEM(argv)){
    80008556:	fec42783          	lw	a5,-20(s0)
    8000855a:	873e                	mv	a4,a5
    8000855c:	47fd                	li	a5,31
    8000855e:	0ee7ee63          	bltu	a5,a4,8000865a <sys_exec+0x152>
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80008562:	fec42783          	lw	a5,-20(s0)
    80008566:	00379713          	slli	a4,a5,0x3
    8000856a:	e6043783          	ld	a5,-416(s0)
    8000856e:	97ba                	add	a5,a5,a4
    80008570:	e5840713          	addi	a4,s0,-424
    80008574:	85ba                	mv	a1,a4
    80008576:	853e                	mv	a0,a5
    80008578:	ffffc097          	auipc	ra,0xffffc
    8000857c:	a2a080e7          	jalr	-1494(ra) # 80003fa2 <fetchaddr>
    80008580:	87aa                	mv	a5,a0
    80008582:	0c07ce63          	bltz	a5,8000865e <sys_exec+0x156>
      goto bad;
    }
    if(uarg == 0){
    80008586:	e5843783          	ld	a5,-424(s0)
    8000858a:	eb8d                	bnez	a5,800085bc <sys_exec+0xb4>
      argv[i] = 0;
    8000858c:	fec42783          	lw	a5,-20(s0)
    80008590:	078e                	slli	a5,a5,0x3
    80008592:	17c1                	addi	a5,a5,-16
    80008594:	97a2                	add	a5,a5,s0
    80008596:	e607bc23          	sd	zero,-392(a5)
      break;
    8000859a:	0001                	nop
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
      goto bad;
  }

  int ret = exec(path, argv);
    8000859c:	e6840713          	addi	a4,s0,-408
    800085a0:	f6840793          	addi	a5,s0,-152
    800085a4:	85ba                	mv	a1,a4
    800085a6:	853e                	mv	a0,a5
    800085a8:	fffff097          	auipc	ra,0xfffff
    800085ac:	c34080e7          	jalr	-972(ra) # 800071dc <exec>
    800085b0:	87aa                	mv	a5,a0
    800085b2:	fef42423          	sw	a5,-24(s0)

  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800085b6:	fe042623          	sw	zero,-20(s0)
    800085ba:	a8bd                	j	80008638 <sys_exec+0x130>
    argv[i] = kalloc();
    800085bc:	ffff9097          	auipc	ra,0xffff9
    800085c0:	b6e080e7          	jalr	-1170(ra) # 8000112a <kalloc>
    800085c4:	872a                	mv	a4,a0
    800085c6:	fec42783          	lw	a5,-20(s0)
    800085ca:	078e                	slli	a5,a5,0x3
    800085cc:	17c1                	addi	a5,a5,-16
    800085ce:	97a2                	add	a5,a5,s0
    800085d0:	e6e7bc23          	sd	a4,-392(a5)
    if(argv[i] == 0)
    800085d4:	fec42783          	lw	a5,-20(s0)
    800085d8:	078e                	slli	a5,a5,0x3
    800085da:	17c1                	addi	a5,a5,-16
    800085dc:	97a2                	add	a5,a5,s0
    800085de:	e787b783          	ld	a5,-392(a5)
    800085e2:	c3c1                	beqz	a5,80008662 <sys_exec+0x15a>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800085e4:	e5843703          	ld	a4,-424(s0)
    800085e8:	fec42783          	lw	a5,-20(s0)
    800085ec:	078e                	slli	a5,a5,0x3
    800085ee:	17c1                	addi	a5,a5,-16
    800085f0:	97a2                	add	a5,a5,s0
    800085f2:	e787b783          	ld	a5,-392(a5)
    800085f6:	6605                	lui	a2,0x1
    800085f8:	85be                	mv	a1,a5
    800085fa:	853a                	mv	a0,a4
    800085fc:	ffffc097          	auipc	ra,0xffffc
    80008600:	a14080e7          	jalr	-1516(ra) # 80004010 <fetchstr>
    80008604:	87aa                	mv	a5,a0
    80008606:	0607c063          	bltz	a5,80008666 <sys_exec+0x15e>
  for(i=0;; i++){
    8000860a:	fec42783          	lw	a5,-20(s0)
    8000860e:	2785                	addiw	a5,a5,1
    80008610:	fef42623          	sw	a5,-20(s0)
    if(i >= NELEM(argv)){
    80008614:	b789                	j	80008556 <sys_exec+0x4e>
    kfree(argv[i]);
    80008616:	fec42783          	lw	a5,-20(s0)
    8000861a:	078e                	slli	a5,a5,0x3
    8000861c:	17c1                	addi	a5,a5,-16
    8000861e:	97a2                	add	a5,a5,s0
    80008620:	e787b783          	ld	a5,-392(a5)
    80008624:	853e                	mv	a0,a5
    80008626:	ffff9097          	auipc	ra,0xffff9
    8000862a:	a60080e7          	jalr	-1440(ra) # 80001086 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000862e:	fec42783          	lw	a5,-20(s0)
    80008632:	2785                	addiw	a5,a5,1
    80008634:	fef42623          	sw	a5,-20(s0)
    80008638:	fec42783          	lw	a5,-20(s0)
    8000863c:	873e                	mv	a4,a5
    8000863e:	47fd                	li	a5,31
    80008640:	00e7ea63          	bltu	a5,a4,80008654 <sys_exec+0x14c>
    80008644:	fec42783          	lw	a5,-20(s0)
    80008648:	078e                	slli	a5,a5,0x3
    8000864a:	17c1                	addi	a5,a5,-16
    8000864c:	97a2                	add	a5,a5,s0
    8000864e:	e787b783          	ld	a5,-392(a5)
    80008652:	f3f1                	bnez	a5,80008616 <sys_exec+0x10e>

  return ret;
    80008654:	fe842783          	lw	a5,-24(s0)
    80008658:	a899                	j	800086ae <sys_exec+0x1a6>
      goto bad;
    8000865a:	0001                	nop
    8000865c:	a031                	j	80008668 <sys_exec+0x160>
      goto bad;
    8000865e:	0001                	nop
    80008660:	a021                	j	80008668 <sys_exec+0x160>
      goto bad;
    80008662:	0001                	nop
    80008664:	a011                	j	80008668 <sys_exec+0x160>
      goto bad;
    80008666:	0001                	nop

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80008668:	fe042623          	sw	zero,-20(s0)
    8000866c:	a015                	j	80008690 <sys_exec+0x188>
    kfree(argv[i]);
    8000866e:	fec42783          	lw	a5,-20(s0)
    80008672:	078e                	slli	a5,a5,0x3
    80008674:	17c1                	addi	a5,a5,-16
    80008676:	97a2                	add	a5,a5,s0
    80008678:	e787b783          	ld	a5,-392(a5)
    8000867c:	853e                	mv	a0,a5
    8000867e:	ffff9097          	auipc	ra,0xffff9
    80008682:	a08080e7          	jalr	-1528(ra) # 80001086 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80008686:	fec42783          	lw	a5,-20(s0)
    8000868a:	2785                	addiw	a5,a5,1
    8000868c:	fef42623          	sw	a5,-20(s0)
    80008690:	fec42783          	lw	a5,-20(s0)
    80008694:	873e                	mv	a4,a5
    80008696:	47fd                	li	a5,31
    80008698:	00e7ea63          	bltu	a5,a4,800086ac <sys_exec+0x1a4>
    8000869c:	fec42783          	lw	a5,-20(s0)
    800086a0:	078e                	slli	a5,a5,0x3
    800086a2:	17c1                	addi	a5,a5,-16
    800086a4:	97a2                	add	a5,a5,s0
    800086a6:	e787b783          	ld	a5,-392(a5)
    800086aa:	f3f1                	bnez	a5,8000866e <sys_exec+0x166>
  return -1;
    800086ac:	57fd                	li	a5,-1
}
    800086ae:	853e                	mv	a0,a5
    800086b0:	70ba                	ld	ra,424(sp)
    800086b2:	741a                	ld	s0,416(sp)
    800086b4:	615d                	addi	sp,sp,432
    800086b6:	8082                	ret

00000000800086b8 <sys_pipe>:

uint64
sys_pipe(void)
{
    800086b8:	7139                	addi	sp,sp,-64
    800086ba:	fc06                	sd	ra,56(sp)
    800086bc:	f822                	sd	s0,48(sp)
    800086be:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800086c0:	ffffa097          	auipc	ra,0xffffa
    800086c4:	186080e7          	jalr	390(ra) # 80002846 <myproc>
    800086c8:	fea43423          	sd	a0,-24(s0)

  argaddr(0, &fdarray);
    800086cc:	fe040793          	addi	a5,s0,-32
    800086d0:	85be                	mv	a1,a5
    800086d2:	4501                	li	a0,0
    800086d4:	ffffc097          	auipc	ra,0xffffc
    800086d8:	a76080e7          	jalr	-1418(ra) # 8000414a <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800086dc:	fd040713          	addi	a4,s0,-48
    800086e0:	fd840793          	addi	a5,s0,-40
    800086e4:	85ba                	mv	a1,a4
    800086e6:	853e                	mv	a0,a5
    800086e8:	ffffe097          	auipc	ra,0xffffe
    800086ec:	60e080e7          	jalr	1550(ra) # 80006cf6 <pipealloc>
    800086f0:	87aa                	mv	a5,a0
    800086f2:	0007d463          	bgez	a5,800086fa <sys_pipe+0x42>
    return -1;
    800086f6:	57fd                	li	a5,-1
    800086f8:	a219                	j	800087fe <sys_pipe+0x146>
  fd0 = -1;
    800086fa:	57fd                	li	a5,-1
    800086fc:	fcf42623          	sw	a5,-52(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80008700:	fd843783          	ld	a5,-40(s0)
    80008704:	853e                	mv	a0,a5
    80008706:	fffff097          	auipc	ra,0xfffff
    8000870a:	104080e7          	jalr	260(ra) # 8000780a <fdalloc>
    8000870e:	87aa                	mv	a5,a0
    80008710:	fcf42623          	sw	a5,-52(s0)
    80008714:	fcc42783          	lw	a5,-52(s0)
    80008718:	0207c063          	bltz	a5,80008738 <sys_pipe+0x80>
    8000871c:	fd043783          	ld	a5,-48(s0)
    80008720:	853e                	mv	a0,a5
    80008722:	fffff097          	auipc	ra,0xfffff
    80008726:	0e8080e7          	jalr	232(ra) # 8000780a <fdalloc>
    8000872a:	87aa                	mv	a5,a0
    8000872c:	fcf42423          	sw	a5,-56(s0)
    80008730:	fc842783          	lw	a5,-56(s0)
    80008734:	0207df63          	bgez	a5,80008772 <sys_pipe+0xba>
    if(fd0 >= 0)
    80008738:	fcc42783          	lw	a5,-52(s0)
    8000873c:	0007cb63          	bltz	a5,80008752 <sys_pipe+0x9a>
      p->ofile[fd0] = 0;
    80008740:	fcc42783          	lw	a5,-52(s0)
    80008744:	fe843703          	ld	a4,-24(s0)
    80008748:	07e9                	addi	a5,a5,26
    8000874a:	078e                	slli	a5,a5,0x3
    8000874c:	97ba                	add	a5,a5,a4
    8000874e:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80008752:	fd843783          	ld	a5,-40(s0)
    80008756:	853e                	mv	a0,a5
    80008758:	ffffe097          	auipc	ra,0xffffe
    8000875c:	08c080e7          	jalr	140(ra) # 800067e4 <fileclose>
    fileclose(wf);
    80008760:	fd043783          	ld	a5,-48(s0)
    80008764:	853e                	mv	a0,a5
    80008766:	ffffe097          	auipc	ra,0xffffe
    8000876a:	07e080e7          	jalr	126(ra) # 800067e4 <fileclose>
    return -1;
    8000876e:	57fd                	li	a5,-1
    80008770:	a079                	j	800087fe <sys_pipe+0x146>
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80008772:	fe843783          	ld	a5,-24(s0)
    80008776:	6bbc                	ld	a5,80(a5)
    80008778:	fe043703          	ld	a4,-32(s0)
    8000877c:	fcc40613          	addi	a2,s0,-52
    80008780:	4691                	li	a3,4
    80008782:	85ba                	mv	a1,a4
    80008784:	853e                	mv	a0,a5
    80008786:	ffffa097          	auipc	ra,0xffffa
    8000878a:	b8a080e7          	jalr	-1142(ra) # 80002310 <copyout>
    8000878e:	87aa                	mv	a5,a0
    80008790:	0207c463          	bltz	a5,800087b8 <sys_pipe+0x100>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80008794:	fe843783          	ld	a5,-24(s0)
    80008798:	6bb8                	ld	a4,80(a5)
    8000879a:	fe043783          	ld	a5,-32(s0)
    8000879e:	0791                	addi	a5,a5,4
    800087a0:	fc840613          	addi	a2,s0,-56
    800087a4:	4691                	li	a3,4
    800087a6:	85be                	mv	a1,a5
    800087a8:	853a                	mv	a0,a4
    800087aa:	ffffa097          	auipc	ra,0xffffa
    800087ae:	b66080e7          	jalr	-1178(ra) # 80002310 <copyout>
    800087b2:	87aa                	mv	a5,a0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800087b4:	0407d463          	bgez	a5,800087fc <sys_pipe+0x144>
    p->ofile[fd0] = 0;
    800087b8:	fcc42783          	lw	a5,-52(s0)
    800087bc:	fe843703          	ld	a4,-24(s0)
    800087c0:	07e9                	addi	a5,a5,26
    800087c2:	078e                	slli	a5,a5,0x3
    800087c4:	97ba                	add	a5,a5,a4
    800087c6:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800087ca:	fc842783          	lw	a5,-56(s0)
    800087ce:	fe843703          	ld	a4,-24(s0)
    800087d2:	07e9                	addi	a5,a5,26
    800087d4:	078e                	slli	a5,a5,0x3
    800087d6:	97ba                	add	a5,a5,a4
    800087d8:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800087dc:	fd843783          	ld	a5,-40(s0)
    800087e0:	853e                	mv	a0,a5
    800087e2:	ffffe097          	auipc	ra,0xffffe
    800087e6:	002080e7          	jalr	2(ra) # 800067e4 <fileclose>
    fileclose(wf);
    800087ea:	fd043783          	ld	a5,-48(s0)
    800087ee:	853e                	mv	a0,a5
    800087f0:	ffffe097          	auipc	ra,0xffffe
    800087f4:	ff4080e7          	jalr	-12(ra) # 800067e4 <fileclose>
    return -1;
    800087f8:	57fd                	li	a5,-1
    800087fa:	a011                	j	800087fe <sys_pipe+0x146>
  }
  return 0;
    800087fc:	4781                	li	a5,0
}
    800087fe:	853e                	mv	a0,a5
    80008800:	70e2                	ld	ra,56(sp)
    80008802:	7442                	ld	s0,48(sp)
    80008804:	6121                	addi	sp,sp,64
    80008806:	8082                	ret
	...

0000000080008810 <kernelvec>:
    80008810:	7111                	addi	sp,sp,-256
    80008812:	e006                	sd	ra,0(sp)
    80008814:	e40a                	sd	sp,8(sp)
    80008816:	e80e                	sd	gp,16(sp)
    80008818:	ec12                	sd	tp,24(sp)
    8000881a:	f016                	sd	t0,32(sp)
    8000881c:	f41a                	sd	t1,40(sp)
    8000881e:	f81e                	sd	t2,48(sp)
    80008820:	fc22                	sd	s0,56(sp)
    80008822:	e0a6                	sd	s1,64(sp)
    80008824:	e4aa                	sd	a0,72(sp)
    80008826:	e8ae                	sd	a1,80(sp)
    80008828:	ecb2                	sd	a2,88(sp)
    8000882a:	f0b6                	sd	a3,96(sp)
    8000882c:	f4ba                	sd	a4,104(sp)
    8000882e:	f8be                	sd	a5,112(sp)
    80008830:	fcc2                	sd	a6,120(sp)
    80008832:	e146                	sd	a7,128(sp)
    80008834:	e54a                	sd	s2,136(sp)
    80008836:	e94e                	sd	s3,144(sp)
    80008838:	ed52                	sd	s4,152(sp)
    8000883a:	f156                	sd	s5,160(sp)
    8000883c:	f55a                	sd	s6,168(sp)
    8000883e:	f95e                	sd	s7,176(sp)
    80008840:	fd62                	sd	s8,184(sp)
    80008842:	e1e6                	sd	s9,192(sp)
    80008844:	e5ea                	sd	s10,200(sp)
    80008846:	e9ee                	sd	s11,208(sp)
    80008848:	edf2                	sd	t3,216(sp)
    8000884a:	f1f6                	sd	t4,224(sp)
    8000884c:	f5fa                	sd	t5,232(sp)
    8000884e:	f9fe                	sd	t6,240(sp)
    80008850:	ceafb0ef          	jal	80003d3a <kerneltrap>
    80008854:	6082                	ld	ra,0(sp)
    80008856:	6122                	ld	sp,8(sp)
    80008858:	61c2                	ld	gp,16(sp)
    8000885a:	7282                	ld	t0,32(sp)
    8000885c:	7322                	ld	t1,40(sp)
    8000885e:	73c2                	ld	t2,48(sp)
    80008860:	7462                	ld	s0,56(sp)
    80008862:	6486                	ld	s1,64(sp)
    80008864:	6526                	ld	a0,72(sp)
    80008866:	65c6                	ld	a1,80(sp)
    80008868:	6666                	ld	a2,88(sp)
    8000886a:	7686                	ld	a3,96(sp)
    8000886c:	7726                	ld	a4,104(sp)
    8000886e:	77c6                	ld	a5,112(sp)
    80008870:	7866                	ld	a6,120(sp)
    80008872:	688a                	ld	a7,128(sp)
    80008874:	692a                	ld	s2,136(sp)
    80008876:	69ca                	ld	s3,144(sp)
    80008878:	6a6a                	ld	s4,152(sp)
    8000887a:	7a8a                	ld	s5,160(sp)
    8000887c:	7b2a                	ld	s6,168(sp)
    8000887e:	7bca                	ld	s7,176(sp)
    80008880:	7c6a                	ld	s8,184(sp)
    80008882:	6c8e                	ld	s9,192(sp)
    80008884:	6d2e                	ld	s10,200(sp)
    80008886:	6dce                	ld	s11,208(sp)
    80008888:	6e6e                	ld	t3,216(sp)
    8000888a:	7e8e                	ld	t4,224(sp)
    8000888c:	7f2e                	ld	t5,232(sp)
    8000888e:	7fce                	ld	t6,240(sp)
    80008890:	6111                	addi	sp,sp,256
    80008892:	10200073          	sret
    80008896:	00000013          	nop
    8000889a:	00000013          	nop
    8000889e:	0001                	nop

00000000800088a0 <timervec>:
    800088a0:	34051573          	csrrw	a0,mscratch,a0
    800088a4:	e10c                	sd	a1,0(a0)
    800088a6:	e510                	sd	a2,8(a0)
    800088a8:	e914                	sd	a3,16(a0)
    800088aa:	6d0c                	ld	a1,24(a0)
    800088ac:	7110                	ld	a2,32(a0)
    800088ae:	6194                	ld	a3,0(a1)
    800088b0:	96b2                	add	a3,a3,a2
    800088b2:	e194                	sd	a3,0(a1)
    800088b4:	4589                	li	a1,2
    800088b6:	14459073          	csrw	sip,a1
    800088ba:	6914                	ld	a3,16(a0)
    800088bc:	6510                	ld	a2,8(a0)
    800088be:	610c                	ld	a1,0(a0)
    800088c0:	34051573          	csrrw	a0,mscratch,a0
    800088c4:	30200073          	mret
	...

00000000800088ca <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800088ca:	1141                	addi	sp,sp,-16
    800088cc:	e422                	sd	s0,8(sp)
    800088ce:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800088d0:	0c0007b7          	lui	a5,0xc000
    800088d4:	02878793          	addi	a5,a5,40 # c000028 <_entry-0x73ffffd8>
    800088d8:	4705                	li	a4,1
    800088da:	c398                	sw	a4,0(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800088dc:	0c0007b7          	lui	a5,0xc000
    800088e0:	0791                	addi	a5,a5,4 # c000004 <_entry-0x73fffffc>
    800088e2:	4705                	li	a4,1
    800088e4:	c398                	sw	a4,0(a5)
}
    800088e6:	0001                	nop
    800088e8:	6422                	ld	s0,8(sp)
    800088ea:	0141                	addi	sp,sp,16
    800088ec:	8082                	ret

00000000800088ee <plicinithart>:

void
plicinithart(void)
{
    800088ee:	1101                	addi	sp,sp,-32
    800088f0:	ec06                	sd	ra,24(sp)
    800088f2:	e822                	sd	s0,16(sp)
    800088f4:	1000                	addi	s0,sp,32
  int hart = cpuid();
    800088f6:	ffffa097          	auipc	ra,0xffffa
    800088fa:	ef2080e7          	jalr	-270(ra) # 800027e8 <cpuid>
    800088fe:	87aa                	mv	a5,a0
    80008900:	fef42623          	sw	a5,-20(s0)
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80008904:	fec42783          	lw	a5,-20(s0)
    80008908:	0087979b          	slliw	a5,a5,0x8
    8000890c:	2781                	sext.w	a5,a5
    8000890e:	873e                	mv	a4,a5
    80008910:	0c0027b7          	lui	a5,0xc002
    80008914:	08078793          	addi	a5,a5,128 # c002080 <_entry-0x73ffdf80>
    80008918:	97ba                	add	a5,a5,a4
    8000891a:	873e                	mv	a4,a5
    8000891c:	40200793          	li	a5,1026
    80008920:	c31c                	sw	a5,0(a4)

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80008922:	fec42783          	lw	a5,-20(s0)
    80008926:	00d7979b          	slliw	a5,a5,0xd
    8000892a:	2781                	sext.w	a5,a5
    8000892c:	873e                	mv	a4,a5
    8000892e:	0c2017b7          	lui	a5,0xc201
    80008932:	97ba                	add	a5,a5,a4
    80008934:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80008938:	0001                	nop
    8000893a:	60e2                	ld	ra,24(sp)
    8000893c:	6442                	ld	s0,16(sp)
    8000893e:	6105                	addi	sp,sp,32
    80008940:	8082                	ret

0000000080008942 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80008942:	1101                	addi	sp,sp,-32
    80008944:	ec06                	sd	ra,24(sp)
    80008946:	e822                	sd	s0,16(sp)
    80008948:	1000                	addi	s0,sp,32
  int hart = cpuid();
    8000894a:	ffffa097          	auipc	ra,0xffffa
    8000894e:	e9e080e7          	jalr	-354(ra) # 800027e8 <cpuid>
    80008952:	87aa                	mv	a5,a0
    80008954:	fef42623          	sw	a5,-20(s0)
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80008958:	fec42783          	lw	a5,-20(s0)
    8000895c:	00d7979b          	slliw	a5,a5,0xd
    80008960:	2781                	sext.w	a5,a5
    80008962:	873e                	mv	a4,a5
    80008964:	0c2017b7          	lui	a5,0xc201
    80008968:	0791                	addi	a5,a5,4 # c201004 <_entry-0x73dfeffc>
    8000896a:	97ba                	add	a5,a5,a4
    8000896c:	439c                	lw	a5,0(a5)
    8000896e:	fef42423          	sw	a5,-24(s0)
  return irq;
    80008972:	fe842783          	lw	a5,-24(s0)
}
    80008976:	853e                	mv	a0,a5
    80008978:	60e2                	ld	ra,24(sp)
    8000897a:	6442                	ld	s0,16(sp)
    8000897c:	6105                	addi	sp,sp,32
    8000897e:	8082                	ret

0000000080008980 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80008980:	7179                	addi	sp,sp,-48
    80008982:	f406                	sd	ra,40(sp)
    80008984:	f022                	sd	s0,32(sp)
    80008986:	1800                	addi	s0,sp,48
    80008988:	87aa                	mv	a5,a0
    8000898a:	fcf42e23          	sw	a5,-36(s0)
  int hart = cpuid();
    8000898e:	ffffa097          	auipc	ra,0xffffa
    80008992:	e5a080e7          	jalr	-422(ra) # 800027e8 <cpuid>
    80008996:	87aa                	mv	a5,a0
    80008998:	fef42623          	sw	a5,-20(s0)
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000899c:	fec42783          	lw	a5,-20(s0)
    800089a0:	00d7979b          	slliw	a5,a5,0xd
    800089a4:	2781                	sext.w	a5,a5
    800089a6:	873e                	mv	a4,a5
    800089a8:	0c2017b7          	lui	a5,0xc201
    800089ac:	0791                	addi	a5,a5,4 # c201004 <_entry-0x73dfeffc>
    800089ae:	97ba                	add	a5,a5,a4
    800089b0:	873e                	mv	a4,a5
    800089b2:	fdc42783          	lw	a5,-36(s0)
    800089b6:	c31c                	sw	a5,0(a4)
}
    800089b8:	0001                	nop
    800089ba:	70a2                	ld	ra,40(sp)
    800089bc:	7402                	ld	s0,32(sp)
    800089be:	6145                	addi	sp,sp,48
    800089c0:	8082                	ret

00000000800089c2 <virtio_disk_init>:
  
} disk;

void
virtio_disk_init(void)
{
    800089c2:	7179                	addi	sp,sp,-48
    800089c4:	f406                	sd	ra,40(sp)
    800089c6:	f022                	sd	s0,32(sp)
    800089c8:	1800                	addi	s0,sp,48
  uint32 status = 0;
    800089ca:	fe042423          	sw	zero,-24(s0)

  initlock(&disk.vdisk_lock, "virtio_disk");
    800089ce:	00003597          	auipc	a1,0x3
    800089d2:	c9a58593          	addi	a1,a1,-870 # 8000b668 <etext+0x668>
    800089d6:	0001f517          	auipc	a0,0x1f
    800089da:	92a50513          	addi	a0,a0,-1750 # 80027300 <disk+0x128>
    800089de:	ffff9097          	auipc	ra,0xffff9
    800089e2:	870080e7          	jalr	-1936(ra) # 8000124e <initlock>

  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800089e6:	100017b7          	lui	a5,0x10001
    800089ea:	439c                	lw	a5,0(a5)
    800089ec:	2781                	sext.w	a5,a5
    800089ee:	873e                	mv	a4,a5
    800089f0:	747277b7          	lui	a5,0x74727
    800089f4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800089f8:	04f71063          	bne	a4,a5,80008a38 <virtio_disk_init+0x76>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800089fc:	100017b7          	lui	a5,0x10001
    80008a00:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80008a02:	439c                	lw	a5,0(a5)
    80008a04:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80008a06:	873e                	mv	a4,a5
    80008a08:	4789                	li	a5,2
    80008a0a:	02f71763          	bne	a4,a5,80008a38 <virtio_disk_init+0x76>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80008a0e:	100017b7          	lui	a5,0x10001
    80008a12:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80008a14:	439c                	lw	a5,0(a5)
    80008a16:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80008a18:	873e                	mv	a4,a5
    80008a1a:	4789                	li	a5,2
    80008a1c:	00f71e63          	bne	a4,a5,80008a38 <virtio_disk_init+0x76>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80008a20:	100017b7          	lui	a5,0x10001
    80008a24:	07b1                	addi	a5,a5,12 # 1000100c <_entry-0x6fffeff4>
    80008a26:	439c                	lw	a5,0(a5)
    80008a28:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80008a2a:	873e                	mv	a4,a5
    80008a2c:	554d47b7          	lui	a5,0x554d4
    80008a30:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80008a34:	00f70a63          	beq	a4,a5,80008a48 <virtio_disk_init+0x86>
    panic("could not find virtio disk");
    80008a38:	00003517          	auipc	a0,0x3
    80008a3c:	c4050513          	addi	a0,a0,-960 # 8000b678 <etext+0x678>
    80008a40:	ffff8097          	auipc	ra,0xffff8
    80008a44:	24a080e7          	jalr	586(ra) # 80000c8a <panic>
  }
  
  // reset device
  *R(VIRTIO_MMIO_STATUS) = status;
    80008a48:	100017b7          	lui	a5,0x10001
    80008a4c:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x6fffef90>
    80008a50:	fe842703          	lw	a4,-24(s0)
    80008a54:	c398                	sw	a4,0(a5)

  // set ACKNOWLEDGE status bit
  status |= VIRTIO_CONFIG_S_ACKNOWLEDGE;
    80008a56:	fe842783          	lw	a5,-24(s0)
    80008a5a:	0017e793          	ori	a5,a5,1
    80008a5e:	fef42423          	sw	a5,-24(s0)
  *R(VIRTIO_MMIO_STATUS) = status;
    80008a62:	100017b7          	lui	a5,0x10001
    80008a66:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x6fffef90>
    80008a6a:	fe842703          	lw	a4,-24(s0)
    80008a6e:	c398                	sw	a4,0(a5)

  // set DRIVER status bit
  status |= VIRTIO_CONFIG_S_DRIVER;
    80008a70:	fe842783          	lw	a5,-24(s0)
    80008a74:	0027e793          	ori	a5,a5,2
    80008a78:	fef42423          	sw	a5,-24(s0)
  *R(VIRTIO_MMIO_STATUS) = status;
    80008a7c:	100017b7          	lui	a5,0x10001
    80008a80:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x6fffef90>
    80008a84:	fe842703          	lw	a4,-24(s0)
    80008a88:	c398                	sw	a4,0(a5)

  // negotiate features
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80008a8a:	100017b7          	lui	a5,0x10001
    80008a8e:	07c1                	addi	a5,a5,16 # 10001010 <_entry-0x6fffeff0>
    80008a90:	439c                	lw	a5,0(a5)
    80008a92:	2781                	sext.w	a5,a5
    80008a94:	1782                	slli	a5,a5,0x20
    80008a96:	9381                	srli	a5,a5,0x20
    80008a98:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_BLK_F_RO);
    80008a9c:	fe043783          	ld	a5,-32(s0)
    80008aa0:	fdf7f793          	andi	a5,a5,-33
    80008aa4:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_BLK_F_SCSI);
    80008aa8:	fe043783          	ld	a5,-32(s0)
    80008aac:	f7f7f793          	andi	a5,a5,-129
    80008ab0:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_BLK_F_CONFIG_WCE);
    80008ab4:	fe043703          	ld	a4,-32(s0)
    80008ab8:	77fd                	lui	a5,0xfffff
    80008aba:	7ff78793          	addi	a5,a5,2047 # fffffffffffff7ff <end+0xffffffff7ffd84e7>
    80008abe:	8ff9                	and	a5,a5,a4
    80008ac0:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_BLK_F_MQ);
    80008ac4:	fe043703          	ld	a4,-32(s0)
    80008ac8:	77fd                	lui	a5,0xfffff
    80008aca:	17fd                	addi	a5,a5,-1 # ffffffffffffefff <end+0xffffffff7ffd7ce7>
    80008acc:	8ff9                	and	a5,a5,a4
    80008ace:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_F_ANY_LAYOUT);
    80008ad2:	fe043703          	ld	a4,-32(s0)
    80008ad6:	f80007b7          	lui	a5,0xf8000
    80008ada:	17fd                	addi	a5,a5,-1 # fffffffff7ffffff <end+0xffffffff77fd8ce7>
    80008adc:	8ff9                	and	a5,a5,a4
    80008ade:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_RING_F_EVENT_IDX);
    80008ae2:	fe043703          	ld	a4,-32(s0)
    80008ae6:	e00007b7          	lui	a5,0xe0000
    80008aea:	17fd                	addi	a5,a5,-1 # ffffffffdfffffff <end+0xffffffff5ffd8ce7>
    80008aec:	8ff9                	and	a5,a5,a4
    80008aee:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80008af2:	fe043703          	ld	a4,-32(s0)
    80008af6:	f00007b7          	lui	a5,0xf0000
    80008afa:	17fd                	addi	a5,a5,-1 # ffffffffefffffff <end+0xffffffff6ffd8ce7>
    80008afc:	8ff9                	and	a5,a5,a4
    80008afe:	fef43023          	sd	a5,-32(s0)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80008b02:	100017b7          	lui	a5,0x10001
    80008b06:	02078793          	addi	a5,a5,32 # 10001020 <_entry-0x6fffefe0>
    80008b0a:	fe043703          	ld	a4,-32(s0)
    80008b0e:	2701                	sext.w	a4,a4
    80008b10:	c398                	sw	a4,0(a5)

  // tell device that feature negotiation is complete.
  status |= VIRTIO_CONFIG_S_FEATURES_OK;
    80008b12:	fe842783          	lw	a5,-24(s0)
    80008b16:	0087e793          	ori	a5,a5,8
    80008b1a:	fef42423          	sw	a5,-24(s0)
  *R(VIRTIO_MMIO_STATUS) = status;
    80008b1e:	100017b7          	lui	a5,0x10001
    80008b22:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x6fffef90>
    80008b26:	fe842703          	lw	a4,-24(s0)
    80008b2a:	c398                	sw	a4,0(a5)

  // re-read status to ensure FEATURES_OK is set.
  status = *R(VIRTIO_MMIO_STATUS);
    80008b2c:	100017b7          	lui	a5,0x10001
    80008b30:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x6fffef90>
    80008b34:	439c                	lw	a5,0(a5)
    80008b36:	fef42423          	sw	a5,-24(s0)
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80008b3a:	fe842783          	lw	a5,-24(s0)
    80008b3e:	8ba1                	andi	a5,a5,8
    80008b40:	2781                	sext.w	a5,a5
    80008b42:	eb89                	bnez	a5,80008b54 <virtio_disk_init+0x192>
    panic("virtio disk FEATURES_OK unset");
    80008b44:	00003517          	auipc	a0,0x3
    80008b48:	b5450513          	addi	a0,a0,-1196 # 8000b698 <etext+0x698>
    80008b4c:	ffff8097          	auipc	ra,0xffff8
    80008b50:	13e080e7          	jalr	318(ra) # 80000c8a <panic>

  // initialize queue 0.
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80008b54:	100017b7          	lui	a5,0x10001
    80008b58:	03078793          	addi	a5,a5,48 # 10001030 <_entry-0x6fffefd0>
    80008b5c:	0007a023          	sw	zero,0(a5)

  // ensure queue 0 is not in use.
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80008b60:	100017b7          	lui	a5,0x10001
    80008b64:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80008b68:	439c                	lw	a5,0(a5)
    80008b6a:	2781                	sext.w	a5,a5
    80008b6c:	cb89                	beqz	a5,80008b7e <virtio_disk_init+0x1bc>
    panic("virtio disk should not be ready");
    80008b6e:	00003517          	auipc	a0,0x3
    80008b72:	b4a50513          	addi	a0,a0,-1206 # 8000b6b8 <etext+0x6b8>
    80008b76:	ffff8097          	auipc	ra,0xffff8
    80008b7a:	114080e7          	jalr	276(ra) # 80000c8a <panic>

  // check maximum queue size.
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80008b7e:	100017b7          	lui	a5,0x10001
    80008b82:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80008b86:	439c                	lw	a5,0(a5)
    80008b88:	fcf42e23          	sw	a5,-36(s0)
  if(max == 0)
    80008b8c:	fdc42783          	lw	a5,-36(s0)
    80008b90:	2781                	sext.w	a5,a5
    80008b92:	eb89                	bnez	a5,80008ba4 <virtio_disk_init+0x1e2>
    panic("virtio disk has no queue 0");
    80008b94:	00003517          	auipc	a0,0x3
    80008b98:	b4450513          	addi	a0,a0,-1212 # 8000b6d8 <etext+0x6d8>
    80008b9c:	ffff8097          	auipc	ra,0xffff8
    80008ba0:	0ee080e7          	jalr	238(ra) # 80000c8a <panic>
  if(max < NUM)
    80008ba4:	fdc42783          	lw	a5,-36(s0)
    80008ba8:	0007871b          	sext.w	a4,a5
    80008bac:	479d                	li	a5,7
    80008bae:	00e7ea63          	bltu	a5,a4,80008bc2 <virtio_disk_init+0x200>
    panic("virtio disk max queue too short");
    80008bb2:	00003517          	auipc	a0,0x3
    80008bb6:	b4650513          	addi	a0,a0,-1210 # 8000b6f8 <etext+0x6f8>
    80008bba:	ffff8097          	auipc	ra,0xffff8
    80008bbe:	0d0080e7          	jalr	208(ra) # 80000c8a <panic>

  // allocate and zero queue memory.
  disk.desc = kalloc();
    80008bc2:	ffff8097          	auipc	ra,0xffff8
    80008bc6:	568080e7          	jalr	1384(ra) # 8000112a <kalloc>
    80008bca:	872a                	mv	a4,a0
    80008bcc:	0001e797          	auipc	a5,0x1e
    80008bd0:	60c78793          	addi	a5,a5,1548 # 800271d8 <disk>
    80008bd4:	e398                	sd	a4,0(a5)
  disk.avail = kalloc();
    80008bd6:	ffff8097          	auipc	ra,0xffff8
    80008bda:	554080e7          	jalr	1364(ra) # 8000112a <kalloc>
    80008bde:	872a                	mv	a4,a0
    80008be0:	0001e797          	auipc	a5,0x1e
    80008be4:	5f878793          	addi	a5,a5,1528 # 800271d8 <disk>
    80008be8:	e798                	sd	a4,8(a5)
  disk.used = kalloc();
    80008bea:	ffff8097          	auipc	ra,0xffff8
    80008bee:	540080e7          	jalr	1344(ra) # 8000112a <kalloc>
    80008bf2:	872a                	mv	a4,a0
    80008bf4:	0001e797          	auipc	a5,0x1e
    80008bf8:	5e478793          	addi	a5,a5,1508 # 800271d8 <disk>
    80008bfc:	eb98                	sd	a4,16(a5)
  if(!disk.desc || !disk.avail || !disk.used)
    80008bfe:	0001e797          	auipc	a5,0x1e
    80008c02:	5da78793          	addi	a5,a5,1498 # 800271d8 <disk>
    80008c06:	639c                	ld	a5,0(a5)
    80008c08:	cf89                	beqz	a5,80008c22 <virtio_disk_init+0x260>
    80008c0a:	0001e797          	auipc	a5,0x1e
    80008c0e:	5ce78793          	addi	a5,a5,1486 # 800271d8 <disk>
    80008c12:	679c                	ld	a5,8(a5)
    80008c14:	c799                	beqz	a5,80008c22 <virtio_disk_init+0x260>
    80008c16:	0001e797          	auipc	a5,0x1e
    80008c1a:	5c278793          	addi	a5,a5,1474 # 800271d8 <disk>
    80008c1e:	6b9c                	ld	a5,16(a5)
    80008c20:	eb89                	bnez	a5,80008c32 <virtio_disk_init+0x270>
    panic("virtio disk kalloc");
    80008c22:	00003517          	auipc	a0,0x3
    80008c26:	af650513          	addi	a0,a0,-1290 # 8000b718 <etext+0x718>
    80008c2a:	ffff8097          	auipc	ra,0xffff8
    80008c2e:	060080e7          	jalr	96(ra) # 80000c8a <panic>
  memset(disk.desc, 0, PGSIZE);
    80008c32:	0001e797          	auipc	a5,0x1e
    80008c36:	5a678793          	addi	a5,a5,1446 # 800271d8 <disk>
    80008c3a:	639c                	ld	a5,0(a5)
    80008c3c:	6605                	lui	a2,0x1
    80008c3e:	4581                	li	a1,0
    80008c40:	853e                	mv	a0,a5
    80008c42:	ffff9097          	auipc	ra,0xffff9
    80008c46:	810080e7          	jalr	-2032(ra) # 80001452 <memset>
  memset(disk.avail, 0, PGSIZE);
    80008c4a:	0001e797          	auipc	a5,0x1e
    80008c4e:	58e78793          	addi	a5,a5,1422 # 800271d8 <disk>
    80008c52:	679c                	ld	a5,8(a5)
    80008c54:	6605                	lui	a2,0x1
    80008c56:	4581                	li	a1,0
    80008c58:	853e                	mv	a0,a5
    80008c5a:	ffff8097          	auipc	ra,0xffff8
    80008c5e:	7f8080e7          	jalr	2040(ra) # 80001452 <memset>
  memset(disk.used, 0, PGSIZE);
    80008c62:	0001e797          	auipc	a5,0x1e
    80008c66:	57678793          	addi	a5,a5,1398 # 800271d8 <disk>
    80008c6a:	6b9c                	ld	a5,16(a5)
    80008c6c:	6605                	lui	a2,0x1
    80008c6e:	4581                	li	a1,0
    80008c70:	853e                	mv	a0,a5
    80008c72:	ffff8097          	auipc	ra,0xffff8
    80008c76:	7e0080e7          	jalr	2016(ra) # 80001452 <memset>

  // set queue size.
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80008c7a:	100017b7          	lui	a5,0x10001
    80008c7e:	03878793          	addi	a5,a5,56 # 10001038 <_entry-0x6fffefc8>
    80008c82:	4721                	li	a4,8
    80008c84:	c398                	sw	a4,0(a5)

  // write physical addresses.
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80008c86:	0001e797          	auipc	a5,0x1e
    80008c8a:	55278793          	addi	a5,a5,1362 # 800271d8 <disk>
    80008c8e:	639c                	ld	a5,0(a5)
    80008c90:	873e                	mv	a4,a5
    80008c92:	100017b7          	lui	a5,0x10001
    80008c96:	08078793          	addi	a5,a5,128 # 10001080 <_entry-0x6fffef80>
    80008c9a:	2701                	sext.w	a4,a4
    80008c9c:	c398                	sw	a4,0(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80008c9e:	0001e797          	auipc	a5,0x1e
    80008ca2:	53a78793          	addi	a5,a5,1338 # 800271d8 <disk>
    80008ca6:	639c                	ld	a5,0(a5)
    80008ca8:	0207d713          	srli	a4,a5,0x20
    80008cac:	100017b7          	lui	a5,0x10001
    80008cb0:	08478793          	addi	a5,a5,132 # 10001084 <_entry-0x6fffef7c>
    80008cb4:	2701                	sext.w	a4,a4
    80008cb6:	c398                	sw	a4,0(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80008cb8:	0001e797          	auipc	a5,0x1e
    80008cbc:	52078793          	addi	a5,a5,1312 # 800271d8 <disk>
    80008cc0:	679c                	ld	a5,8(a5)
    80008cc2:	873e                	mv	a4,a5
    80008cc4:	100017b7          	lui	a5,0x10001
    80008cc8:	09078793          	addi	a5,a5,144 # 10001090 <_entry-0x6fffef70>
    80008ccc:	2701                	sext.w	a4,a4
    80008cce:	c398                	sw	a4,0(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80008cd0:	0001e797          	auipc	a5,0x1e
    80008cd4:	50878793          	addi	a5,a5,1288 # 800271d8 <disk>
    80008cd8:	679c                	ld	a5,8(a5)
    80008cda:	0207d713          	srli	a4,a5,0x20
    80008cde:	100017b7          	lui	a5,0x10001
    80008ce2:	09478793          	addi	a5,a5,148 # 10001094 <_entry-0x6fffef6c>
    80008ce6:	2701                	sext.w	a4,a4
    80008ce8:	c398                	sw	a4,0(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80008cea:	0001e797          	auipc	a5,0x1e
    80008cee:	4ee78793          	addi	a5,a5,1262 # 800271d8 <disk>
    80008cf2:	6b9c                	ld	a5,16(a5)
    80008cf4:	873e                	mv	a4,a5
    80008cf6:	100017b7          	lui	a5,0x10001
    80008cfa:	0a078793          	addi	a5,a5,160 # 100010a0 <_entry-0x6fffef60>
    80008cfe:	2701                	sext.w	a4,a4
    80008d00:	c398                	sw	a4,0(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80008d02:	0001e797          	auipc	a5,0x1e
    80008d06:	4d678793          	addi	a5,a5,1238 # 800271d8 <disk>
    80008d0a:	6b9c                	ld	a5,16(a5)
    80008d0c:	0207d713          	srli	a4,a5,0x20
    80008d10:	100017b7          	lui	a5,0x10001
    80008d14:	0a478793          	addi	a5,a5,164 # 100010a4 <_entry-0x6fffef5c>
    80008d18:	2701                	sext.w	a4,a4
    80008d1a:	c398                	sw	a4,0(a5)

  // queue is ready.
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80008d1c:	100017b7          	lui	a5,0x10001
    80008d20:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80008d24:	4705                	li	a4,1
    80008d26:	c398                	sw	a4,0(a5)

  // all NUM descriptors start out unused.
  for(int i = 0; i < NUM; i++)
    80008d28:	fe042623          	sw	zero,-20(s0)
    80008d2c:	a005                	j	80008d4c <virtio_disk_init+0x38a>
    disk.free[i] = 1;
    80008d2e:	0001e717          	auipc	a4,0x1e
    80008d32:	4aa70713          	addi	a4,a4,1194 # 800271d8 <disk>
    80008d36:	fec42783          	lw	a5,-20(s0)
    80008d3a:	97ba                	add	a5,a5,a4
    80008d3c:	4705                	li	a4,1
    80008d3e:	00e78c23          	sb	a4,24(a5)
  for(int i = 0; i < NUM; i++)
    80008d42:	fec42783          	lw	a5,-20(s0)
    80008d46:	2785                	addiw	a5,a5,1
    80008d48:	fef42623          	sw	a5,-20(s0)
    80008d4c:	fec42783          	lw	a5,-20(s0)
    80008d50:	0007871b          	sext.w	a4,a5
    80008d54:	479d                	li	a5,7
    80008d56:	fce7dce3          	bge	a5,a4,80008d2e <virtio_disk_init+0x36c>

  // tell device we're completely ready.
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80008d5a:	fe842783          	lw	a5,-24(s0)
    80008d5e:	0047e793          	ori	a5,a5,4
    80008d62:	fef42423          	sw	a5,-24(s0)
  *R(VIRTIO_MMIO_STATUS) = status;
    80008d66:	100017b7          	lui	a5,0x10001
    80008d6a:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x6fffef90>
    80008d6e:	fe842703          	lw	a4,-24(s0)
    80008d72:	c398                	sw	a4,0(a5)

  // plic.c and trap.c arrange for interrupts from VIRTIO0_IRQ.
}
    80008d74:	0001                	nop
    80008d76:	70a2                	ld	ra,40(sp)
    80008d78:	7402                	ld	s0,32(sp)
    80008d7a:	6145                	addi	sp,sp,48
    80008d7c:	8082                	ret

0000000080008d7e <alloc_desc>:

// find a free descriptor, mark it non-free, return its index.
static int
alloc_desc()
{
    80008d7e:	1101                	addi	sp,sp,-32
    80008d80:	ec22                	sd	s0,24(sp)
    80008d82:	1000                	addi	s0,sp,32
  for(int i = 0; i < NUM; i++){
    80008d84:	fe042623          	sw	zero,-20(s0)
    80008d88:	a825                	j	80008dc0 <alloc_desc+0x42>
    if(disk.free[i]){
    80008d8a:	0001e717          	auipc	a4,0x1e
    80008d8e:	44e70713          	addi	a4,a4,1102 # 800271d8 <disk>
    80008d92:	fec42783          	lw	a5,-20(s0)
    80008d96:	97ba                	add	a5,a5,a4
    80008d98:	0187c783          	lbu	a5,24(a5)
    80008d9c:	cf89                	beqz	a5,80008db6 <alloc_desc+0x38>
      disk.free[i] = 0;
    80008d9e:	0001e717          	auipc	a4,0x1e
    80008da2:	43a70713          	addi	a4,a4,1082 # 800271d8 <disk>
    80008da6:	fec42783          	lw	a5,-20(s0)
    80008daa:	97ba                	add	a5,a5,a4
    80008dac:	00078c23          	sb	zero,24(a5)
      return i;
    80008db0:	fec42783          	lw	a5,-20(s0)
    80008db4:	a831                	j	80008dd0 <alloc_desc+0x52>
  for(int i = 0; i < NUM; i++){
    80008db6:	fec42783          	lw	a5,-20(s0)
    80008dba:	2785                	addiw	a5,a5,1
    80008dbc:	fef42623          	sw	a5,-20(s0)
    80008dc0:	fec42783          	lw	a5,-20(s0)
    80008dc4:	0007871b          	sext.w	a4,a5
    80008dc8:	479d                	li	a5,7
    80008dca:	fce7d0e3          	bge	a5,a4,80008d8a <alloc_desc+0xc>
    }
  }
  return -1;
    80008dce:	57fd                	li	a5,-1
}
    80008dd0:	853e                	mv	a0,a5
    80008dd2:	6462                	ld	s0,24(sp)
    80008dd4:	6105                	addi	sp,sp,32
    80008dd6:	8082                	ret

0000000080008dd8 <free_desc>:

// mark a descriptor as free.
static void
free_desc(int i)
{
    80008dd8:	1101                	addi	sp,sp,-32
    80008dda:	ec06                	sd	ra,24(sp)
    80008ddc:	e822                	sd	s0,16(sp)
    80008dde:	1000                	addi	s0,sp,32
    80008de0:	87aa                	mv	a5,a0
    80008de2:	fef42623          	sw	a5,-20(s0)
  if(i >= NUM)
    80008de6:	fec42783          	lw	a5,-20(s0)
    80008dea:	0007871b          	sext.w	a4,a5
    80008dee:	479d                	li	a5,7
    80008df0:	00e7da63          	bge	a5,a4,80008e04 <free_desc+0x2c>
    panic("free_desc 1");
    80008df4:	00003517          	auipc	a0,0x3
    80008df8:	93c50513          	addi	a0,a0,-1732 # 8000b730 <etext+0x730>
    80008dfc:	ffff8097          	auipc	ra,0xffff8
    80008e00:	e8e080e7          	jalr	-370(ra) # 80000c8a <panic>
  if(disk.free[i])
    80008e04:	0001e717          	auipc	a4,0x1e
    80008e08:	3d470713          	addi	a4,a4,980 # 800271d8 <disk>
    80008e0c:	fec42783          	lw	a5,-20(s0)
    80008e10:	97ba                	add	a5,a5,a4
    80008e12:	0187c783          	lbu	a5,24(a5)
    80008e16:	cb89                	beqz	a5,80008e28 <free_desc+0x50>
    panic("free_desc 2");
    80008e18:	00003517          	auipc	a0,0x3
    80008e1c:	92850513          	addi	a0,a0,-1752 # 8000b740 <etext+0x740>
    80008e20:	ffff8097          	auipc	ra,0xffff8
    80008e24:	e6a080e7          	jalr	-406(ra) # 80000c8a <panic>
  disk.desc[i].addr = 0;
    80008e28:	0001e797          	auipc	a5,0x1e
    80008e2c:	3b078793          	addi	a5,a5,944 # 800271d8 <disk>
    80008e30:	6398                	ld	a4,0(a5)
    80008e32:	fec42783          	lw	a5,-20(s0)
    80008e36:	0792                	slli	a5,a5,0x4
    80008e38:	97ba                	add	a5,a5,a4
    80008e3a:	0007b023          	sd	zero,0(a5)
  disk.desc[i].len = 0;
    80008e3e:	0001e797          	auipc	a5,0x1e
    80008e42:	39a78793          	addi	a5,a5,922 # 800271d8 <disk>
    80008e46:	6398                	ld	a4,0(a5)
    80008e48:	fec42783          	lw	a5,-20(s0)
    80008e4c:	0792                	slli	a5,a5,0x4
    80008e4e:	97ba                	add	a5,a5,a4
    80008e50:	0007a423          	sw	zero,8(a5)
  disk.desc[i].flags = 0;
    80008e54:	0001e797          	auipc	a5,0x1e
    80008e58:	38478793          	addi	a5,a5,900 # 800271d8 <disk>
    80008e5c:	6398                	ld	a4,0(a5)
    80008e5e:	fec42783          	lw	a5,-20(s0)
    80008e62:	0792                	slli	a5,a5,0x4
    80008e64:	97ba                	add	a5,a5,a4
    80008e66:	00079623          	sh	zero,12(a5)
  disk.desc[i].next = 0;
    80008e6a:	0001e797          	auipc	a5,0x1e
    80008e6e:	36e78793          	addi	a5,a5,878 # 800271d8 <disk>
    80008e72:	6398                	ld	a4,0(a5)
    80008e74:	fec42783          	lw	a5,-20(s0)
    80008e78:	0792                	slli	a5,a5,0x4
    80008e7a:	97ba                	add	a5,a5,a4
    80008e7c:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80008e80:	0001e717          	auipc	a4,0x1e
    80008e84:	35870713          	addi	a4,a4,856 # 800271d8 <disk>
    80008e88:	fec42783          	lw	a5,-20(s0)
    80008e8c:	97ba                	add	a5,a5,a4
    80008e8e:	4705                	li	a4,1
    80008e90:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80008e94:	0001e517          	auipc	a0,0x1e
    80008e98:	35c50513          	addi	a0,a0,860 # 800271f0 <disk+0x18>
    80008e9c:	ffffa097          	auipc	ra,0xffffa
    80008ea0:	5e8080e7          	jalr	1512(ra) # 80003484 <wakeup>
}
    80008ea4:	0001                	nop
    80008ea6:	60e2                	ld	ra,24(sp)
    80008ea8:	6442                	ld	s0,16(sp)
    80008eaa:	6105                	addi	sp,sp,32
    80008eac:	8082                	ret

0000000080008eae <free_chain>:

// free a chain of descriptors.
static void
free_chain(int i)
{
    80008eae:	7179                	addi	sp,sp,-48
    80008eb0:	f406                	sd	ra,40(sp)
    80008eb2:	f022                	sd	s0,32(sp)
    80008eb4:	1800                	addi	s0,sp,48
    80008eb6:	87aa                	mv	a5,a0
    80008eb8:	fcf42e23          	sw	a5,-36(s0)
  while(1){
    int flag = disk.desc[i].flags;
    80008ebc:	0001e797          	auipc	a5,0x1e
    80008ec0:	31c78793          	addi	a5,a5,796 # 800271d8 <disk>
    80008ec4:	6398                	ld	a4,0(a5)
    80008ec6:	fdc42783          	lw	a5,-36(s0)
    80008eca:	0792                	slli	a5,a5,0x4
    80008ecc:	97ba                	add	a5,a5,a4
    80008ece:	00c7d783          	lhu	a5,12(a5)
    80008ed2:	fef42623          	sw	a5,-20(s0)
    int nxt = disk.desc[i].next;
    80008ed6:	0001e797          	auipc	a5,0x1e
    80008eda:	30278793          	addi	a5,a5,770 # 800271d8 <disk>
    80008ede:	6398                	ld	a4,0(a5)
    80008ee0:	fdc42783          	lw	a5,-36(s0)
    80008ee4:	0792                	slli	a5,a5,0x4
    80008ee6:	97ba                	add	a5,a5,a4
    80008ee8:	00e7d783          	lhu	a5,14(a5)
    80008eec:	fef42423          	sw	a5,-24(s0)
    free_desc(i);
    80008ef0:	fdc42783          	lw	a5,-36(s0)
    80008ef4:	853e                	mv	a0,a5
    80008ef6:	00000097          	auipc	ra,0x0
    80008efa:	ee2080e7          	jalr	-286(ra) # 80008dd8 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80008efe:	fec42783          	lw	a5,-20(s0)
    80008f02:	8b85                	andi	a5,a5,1
    80008f04:	2781                	sext.w	a5,a5
    80008f06:	c791                	beqz	a5,80008f12 <free_chain+0x64>
      i = nxt;
    80008f08:	fe842783          	lw	a5,-24(s0)
    80008f0c:	fcf42e23          	sw	a5,-36(s0)
  while(1){
    80008f10:	b775                	j	80008ebc <free_chain+0xe>
    else
      break;
    80008f12:	0001                	nop
  }
}
    80008f14:	0001                	nop
    80008f16:	70a2                	ld	ra,40(sp)
    80008f18:	7402                	ld	s0,32(sp)
    80008f1a:	6145                	addi	sp,sp,48
    80008f1c:	8082                	ret

0000000080008f1e <alloc3_desc>:

// allocate three descriptors (they need not be contiguous).
// disk transfers always use three descriptors.
static int
alloc3_desc(int *idx)
{
    80008f1e:	7139                	addi	sp,sp,-64
    80008f20:	fc06                	sd	ra,56(sp)
    80008f22:	f822                	sd	s0,48(sp)
    80008f24:	f426                	sd	s1,40(sp)
    80008f26:	0080                	addi	s0,sp,64
    80008f28:	fca43423          	sd	a0,-56(s0)
  for(int i = 0; i < 3; i++){
    80008f2c:	fc042e23          	sw	zero,-36(s0)
    80008f30:	a89d                	j	80008fa6 <alloc3_desc+0x88>
    idx[i] = alloc_desc();
    80008f32:	fdc42783          	lw	a5,-36(s0)
    80008f36:	078a                	slli	a5,a5,0x2
    80008f38:	fc843703          	ld	a4,-56(s0)
    80008f3c:	00f704b3          	add	s1,a4,a5
    80008f40:	00000097          	auipc	ra,0x0
    80008f44:	e3e080e7          	jalr	-450(ra) # 80008d7e <alloc_desc>
    80008f48:	87aa                	mv	a5,a0
    80008f4a:	c09c                	sw	a5,0(s1)
    if(idx[i] < 0){
    80008f4c:	fdc42783          	lw	a5,-36(s0)
    80008f50:	078a                	slli	a5,a5,0x2
    80008f52:	fc843703          	ld	a4,-56(s0)
    80008f56:	97ba                	add	a5,a5,a4
    80008f58:	439c                	lw	a5,0(a5)
    80008f5a:	0407d163          	bgez	a5,80008f9c <alloc3_desc+0x7e>
      for(int j = 0; j < i; j++)
    80008f5e:	fc042c23          	sw	zero,-40(s0)
    80008f62:	a015                	j	80008f86 <alloc3_desc+0x68>
        free_desc(idx[j]);
    80008f64:	fd842783          	lw	a5,-40(s0)
    80008f68:	078a                	slli	a5,a5,0x2
    80008f6a:	fc843703          	ld	a4,-56(s0)
    80008f6e:	97ba                	add	a5,a5,a4
    80008f70:	439c                	lw	a5,0(a5)
    80008f72:	853e                	mv	a0,a5
    80008f74:	00000097          	auipc	ra,0x0
    80008f78:	e64080e7          	jalr	-412(ra) # 80008dd8 <free_desc>
      for(int j = 0; j < i; j++)
    80008f7c:	fd842783          	lw	a5,-40(s0)
    80008f80:	2785                	addiw	a5,a5,1
    80008f82:	fcf42c23          	sw	a5,-40(s0)
    80008f86:	fd842783          	lw	a5,-40(s0)
    80008f8a:	873e                	mv	a4,a5
    80008f8c:	fdc42783          	lw	a5,-36(s0)
    80008f90:	2701                	sext.w	a4,a4
    80008f92:	2781                	sext.w	a5,a5
    80008f94:	fcf748e3          	blt	a4,a5,80008f64 <alloc3_desc+0x46>
      return -1;
    80008f98:	57fd                	li	a5,-1
    80008f9a:	a831                	j	80008fb6 <alloc3_desc+0x98>
  for(int i = 0; i < 3; i++){
    80008f9c:	fdc42783          	lw	a5,-36(s0)
    80008fa0:	2785                	addiw	a5,a5,1
    80008fa2:	fcf42e23          	sw	a5,-36(s0)
    80008fa6:	fdc42783          	lw	a5,-36(s0)
    80008faa:	0007871b          	sext.w	a4,a5
    80008fae:	4789                	li	a5,2
    80008fb0:	f8e7d1e3          	bge	a5,a4,80008f32 <alloc3_desc+0x14>
    }
  }
  return 0;
    80008fb4:	4781                	li	a5,0
}
    80008fb6:	853e                	mv	a0,a5
    80008fb8:	70e2                	ld	ra,56(sp)
    80008fba:	7442                	ld	s0,48(sp)
    80008fbc:	74a2                	ld	s1,40(sp)
    80008fbe:	6121                	addi	sp,sp,64
    80008fc0:	8082                	ret

0000000080008fc2 <virtio_disk_rw>:

void
virtio_disk_rw(struct buf *b, int write)
{
    80008fc2:	7139                	addi	sp,sp,-64
    80008fc4:	fc06                	sd	ra,56(sp)
    80008fc6:	f822                	sd	s0,48(sp)
    80008fc8:	0080                	addi	s0,sp,64
    80008fca:	fca43423          	sd	a0,-56(s0)
    80008fce:	87ae                	mv	a5,a1
    80008fd0:	fcf42223          	sw	a5,-60(s0)
  uint64 sector = b->blockno * (BSIZE / 512);
    80008fd4:	fc843783          	ld	a5,-56(s0)
    80008fd8:	47dc                	lw	a5,12(a5)
    80008fda:	0017979b          	slliw	a5,a5,0x1
    80008fde:	2781                	sext.w	a5,a5
    80008fe0:	1782                	slli	a5,a5,0x20
    80008fe2:	9381                	srli	a5,a5,0x20
    80008fe4:	fef43423          	sd	a5,-24(s0)

  acquire(&disk.vdisk_lock);
    80008fe8:	0001e517          	auipc	a0,0x1e
    80008fec:	31850513          	addi	a0,a0,792 # 80027300 <disk+0x128>
    80008ff0:	ffff8097          	auipc	ra,0xffff8
    80008ff4:	28e080e7          	jalr	654(ra) # 8000127e <acquire>
  // data, one for a 1-byte status result.

  // allocate the three descriptors.
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
    80008ff8:	fd040793          	addi	a5,s0,-48
    80008ffc:	853e                	mv	a0,a5
    80008ffe:	00000097          	auipc	ra,0x0
    80009002:	f20080e7          	jalr	-224(ra) # 80008f1e <alloc3_desc>
    80009006:	87aa                	mv	a5,a0
    80009008:	cf91                	beqz	a5,80009024 <virtio_disk_rw+0x62>
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000900a:	0001e597          	auipc	a1,0x1e
    8000900e:	2f658593          	addi	a1,a1,758 # 80027300 <disk+0x128>
    80009012:	0001e517          	auipc	a0,0x1e
    80009016:	1de50513          	addi	a0,a0,478 # 800271f0 <disk+0x18>
    8000901a:	ffffa097          	auipc	ra,0xffffa
    8000901e:	3ee080e7          	jalr	1006(ra) # 80003408 <sleep>
    if(alloc3_desc(idx) == 0) {
    80009022:	bfd9                	j	80008ff8 <virtio_disk_rw+0x36>
      break;
    80009024:	0001                	nop
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80009026:	fd042783          	lw	a5,-48(s0)
    8000902a:	07a9                	addi	a5,a5,10
    8000902c:	00479713          	slli	a4,a5,0x4
    80009030:	0001e797          	auipc	a5,0x1e
    80009034:	1a878793          	addi	a5,a5,424 # 800271d8 <disk>
    80009038:	97ba                	add	a5,a5,a4
    8000903a:	07a1                	addi	a5,a5,8
    8000903c:	fef43023          	sd	a5,-32(s0)

  if(write)
    80009040:	fc442783          	lw	a5,-60(s0)
    80009044:	2781                	sext.w	a5,a5
    80009046:	c791                	beqz	a5,80009052 <virtio_disk_rw+0x90>
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80009048:	fe043783          	ld	a5,-32(s0)
    8000904c:	4705                	li	a4,1
    8000904e:	c398                	sw	a4,0(a5)
    80009050:	a029                	j	8000905a <virtio_disk_rw+0x98>
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80009052:	fe043783          	ld	a5,-32(s0)
    80009056:	0007a023          	sw	zero,0(a5)
  buf0->reserved = 0;
    8000905a:	fe043783          	ld	a5,-32(s0)
    8000905e:	0007a223          	sw	zero,4(a5)
  buf0->sector = sector;
    80009062:	fe043783          	ld	a5,-32(s0)
    80009066:	fe843703          	ld	a4,-24(s0)
    8000906a:	e798                	sd	a4,8(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    8000906c:	0001e797          	auipc	a5,0x1e
    80009070:	16c78793          	addi	a5,a5,364 # 800271d8 <disk>
    80009074:	6398                	ld	a4,0(a5)
    80009076:	fd042783          	lw	a5,-48(s0)
    8000907a:	0792                	slli	a5,a5,0x4
    8000907c:	97ba                	add	a5,a5,a4
    8000907e:	fe043703          	ld	a4,-32(s0)
    80009082:	e398                	sd	a4,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80009084:	0001e797          	auipc	a5,0x1e
    80009088:	15478793          	addi	a5,a5,340 # 800271d8 <disk>
    8000908c:	6398                	ld	a4,0(a5)
    8000908e:	fd042783          	lw	a5,-48(s0)
    80009092:	0792                	slli	a5,a5,0x4
    80009094:	97ba                	add	a5,a5,a4
    80009096:	4741                	li	a4,16
    80009098:	c798                	sw	a4,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000909a:	0001e797          	auipc	a5,0x1e
    8000909e:	13e78793          	addi	a5,a5,318 # 800271d8 <disk>
    800090a2:	6398                	ld	a4,0(a5)
    800090a4:	fd042783          	lw	a5,-48(s0)
    800090a8:	0792                	slli	a5,a5,0x4
    800090aa:	97ba                	add	a5,a5,a4
    800090ac:	4705                	li	a4,1
    800090ae:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[0]].next = idx[1];
    800090b2:	fd442683          	lw	a3,-44(s0)
    800090b6:	0001e797          	auipc	a5,0x1e
    800090ba:	12278793          	addi	a5,a5,290 # 800271d8 <disk>
    800090be:	6398                	ld	a4,0(a5)
    800090c0:	fd042783          	lw	a5,-48(s0)
    800090c4:	0792                	slli	a5,a5,0x4
    800090c6:	97ba                	add	a5,a5,a4
    800090c8:	03069713          	slli	a4,a3,0x30
    800090cc:	9341                	srli	a4,a4,0x30
    800090ce:	00e79723          	sh	a4,14(a5)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800090d2:	fc843783          	ld	a5,-56(s0)
    800090d6:	05878693          	addi	a3,a5,88
    800090da:	0001e797          	auipc	a5,0x1e
    800090de:	0fe78793          	addi	a5,a5,254 # 800271d8 <disk>
    800090e2:	6398                	ld	a4,0(a5)
    800090e4:	fd442783          	lw	a5,-44(s0)
    800090e8:	0792                	slli	a5,a5,0x4
    800090ea:	97ba                	add	a5,a5,a4
    800090ec:	8736                	mv	a4,a3
    800090ee:	e398                	sd	a4,0(a5)
  disk.desc[idx[1]].len = BSIZE;
    800090f0:	0001e797          	auipc	a5,0x1e
    800090f4:	0e878793          	addi	a5,a5,232 # 800271d8 <disk>
    800090f8:	6398                	ld	a4,0(a5)
    800090fa:	fd442783          	lw	a5,-44(s0)
    800090fe:	0792                	slli	a5,a5,0x4
    80009100:	97ba                	add	a5,a5,a4
    80009102:	40000713          	li	a4,1024
    80009106:	c798                	sw	a4,8(a5)
  if(write)
    80009108:	fc442783          	lw	a5,-60(s0)
    8000910c:	2781                	sext.w	a5,a5
    8000910e:	cf89                	beqz	a5,80009128 <virtio_disk_rw+0x166>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80009110:	0001e797          	auipc	a5,0x1e
    80009114:	0c878793          	addi	a5,a5,200 # 800271d8 <disk>
    80009118:	6398                	ld	a4,0(a5)
    8000911a:	fd442783          	lw	a5,-44(s0)
    8000911e:	0792                	slli	a5,a5,0x4
    80009120:	97ba                	add	a5,a5,a4
    80009122:	00079623          	sh	zero,12(a5)
    80009126:	a829                	j	80009140 <virtio_disk_rw+0x17e>
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80009128:	0001e797          	auipc	a5,0x1e
    8000912c:	0b078793          	addi	a5,a5,176 # 800271d8 <disk>
    80009130:	6398                	ld	a4,0(a5)
    80009132:	fd442783          	lw	a5,-44(s0)
    80009136:	0792                	slli	a5,a5,0x4
    80009138:	97ba                	add	a5,a5,a4
    8000913a:	4709                	li	a4,2
    8000913c:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80009140:	0001e797          	auipc	a5,0x1e
    80009144:	09878793          	addi	a5,a5,152 # 800271d8 <disk>
    80009148:	6398                	ld	a4,0(a5)
    8000914a:	fd442783          	lw	a5,-44(s0)
    8000914e:	0792                	slli	a5,a5,0x4
    80009150:	97ba                	add	a5,a5,a4
    80009152:	00c7d703          	lhu	a4,12(a5)
    80009156:	0001e797          	auipc	a5,0x1e
    8000915a:	08278793          	addi	a5,a5,130 # 800271d8 <disk>
    8000915e:	6394                	ld	a3,0(a5)
    80009160:	fd442783          	lw	a5,-44(s0)
    80009164:	0792                	slli	a5,a5,0x4
    80009166:	97b6                	add	a5,a5,a3
    80009168:	00176713          	ori	a4,a4,1
    8000916c:	1742                	slli	a4,a4,0x30
    8000916e:	9341                	srli	a4,a4,0x30
    80009170:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[1]].next = idx[2];
    80009174:	fd842683          	lw	a3,-40(s0)
    80009178:	0001e797          	auipc	a5,0x1e
    8000917c:	06078793          	addi	a5,a5,96 # 800271d8 <disk>
    80009180:	6398                	ld	a4,0(a5)
    80009182:	fd442783          	lw	a5,-44(s0)
    80009186:	0792                	slli	a5,a5,0x4
    80009188:	97ba                	add	a5,a5,a4
    8000918a:	03069713          	slli	a4,a3,0x30
    8000918e:	9341                	srli	a4,a4,0x30
    80009190:	00e79723          	sh	a4,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80009194:	fd042783          	lw	a5,-48(s0)
    80009198:	0001e717          	auipc	a4,0x1e
    8000919c:	04070713          	addi	a4,a4,64 # 800271d8 <disk>
    800091a0:	0789                	addi	a5,a5,2
    800091a2:	0792                	slli	a5,a5,0x4
    800091a4:	97ba                	add	a5,a5,a4
    800091a6:	577d                	li	a4,-1
    800091a8:	00e78823          	sb	a4,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800091ac:	fd042783          	lw	a5,-48(s0)
    800091b0:	0789                	addi	a5,a5,2
    800091b2:	00479713          	slli	a4,a5,0x4
    800091b6:	0001e797          	auipc	a5,0x1e
    800091ba:	02278793          	addi	a5,a5,34 # 800271d8 <disk>
    800091be:	97ba                	add	a5,a5,a4
    800091c0:	01078693          	addi	a3,a5,16
    800091c4:	0001e797          	auipc	a5,0x1e
    800091c8:	01478793          	addi	a5,a5,20 # 800271d8 <disk>
    800091cc:	6398                	ld	a4,0(a5)
    800091ce:	fd842783          	lw	a5,-40(s0)
    800091d2:	0792                	slli	a5,a5,0x4
    800091d4:	97ba                	add	a5,a5,a4
    800091d6:	8736                	mv	a4,a3
    800091d8:	e398                	sd	a4,0(a5)
  disk.desc[idx[2]].len = 1;
    800091da:	0001e797          	auipc	a5,0x1e
    800091de:	ffe78793          	addi	a5,a5,-2 # 800271d8 <disk>
    800091e2:	6398                	ld	a4,0(a5)
    800091e4:	fd842783          	lw	a5,-40(s0)
    800091e8:	0792                	slli	a5,a5,0x4
    800091ea:	97ba                	add	a5,a5,a4
    800091ec:	4705                	li	a4,1
    800091ee:	c798                	sw	a4,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800091f0:	0001e797          	auipc	a5,0x1e
    800091f4:	fe878793          	addi	a5,a5,-24 # 800271d8 <disk>
    800091f8:	6398                	ld	a4,0(a5)
    800091fa:	fd842783          	lw	a5,-40(s0)
    800091fe:	0792                	slli	a5,a5,0x4
    80009200:	97ba                	add	a5,a5,a4
    80009202:	4709                	li	a4,2
    80009204:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[2]].next = 0;
    80009208:	0001e797          	auipc	a5,0x1e
    8000920c:	fd078793          	addi	a5,a5,-48 # 800271d8 <disk>
    80009210:	6398                	ld	a4,0(a5)
    80009212:	fd842783          	lw	a5,-40(s0)
    80009216:	0792                	slli	a5,a5,0x4
    80009218:	97ba                	add	a5,a5,a4
    8000921a:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000921e:	fc843783          	ld	a5,-56(s0)
    80009222:	4705                	li	a4,1
    80009224:	c3d8                	sw	a4,4(a5)
  disk.info[idx[0]].b = b;
    80009226:	fd042783          	lw	a5,-48(s0)
    8000922a:	0001e717          	auipc	a4,0x1e
    8000922e:	fae70713          	addi	a4,a4,-82 # 800271d8 <disk>
    80009232:	0789                	addi	a5,a5,2
    80009234:	0792                	slli	a5,a5,0x4
    80009236:	97ba                	add	a5,a5,a4
    80009238:	fc843703          	ld	a4,-56(s0)
    8000923c:	e798                	sd	a4,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000923e:	fd042703          	lw	a4,-48(s0)
    80009242:	0001e797          	auipc	a5,0x1e
    80009246:	f9678793          	addi	a5,a5,-106 # 800271d8 <disk>
    8000924a:	6794                	ld	a3,8(a5)
    8000924c:	0001e797          	auipc	a5,0x1e
    80009250:	f8c78793          	addi	a5,a5,-116 # 800271d8 <disk>
    80009254:	679c                	ld	a5,8(a5)
    80009256:	0027d783          	lhu	a5,2(a5)
    8000925a:	2781                	sext.w	a5,a5
    8000925c:	8b9d                	andi	a5,a5,7
    8000925e:	2781                	sext.w	a5,a5
    80009260:	1742                	slli	a4,a4,0x30
    80009262:	9341                	srli	a4,a4,0x30
    80009264:	0786                	slli	a5,a5,0x1
    80009266:	97b6                	add	a5,a5,a3
    80009268:	00e79223          	sh	a4,4(a5)

  __sync_synchronize();
    8000926c:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80009270:	0001e797          	auipc	a5,0x1e
    80009274:	f6878793          	addi	a5,a5,-152 # 800271d8 <disk>
    80009278:	679c                	ld	a5,8(a5)
    8000927a:	0027d703          	lhu	a4,2(a5)
    8000927e:	0001e797          	auipc	a5,0x1e
    80009282:	f5a78793          	addi	a5,a5,-166 # 800271d8 <disk>
    80009286:	679c                	ld	a5,8(a5)
    80009288:	2705                	addiw	a4,a4,1
    8000928a:	1742                	slli	a4,a4,0x30
    8000928c:	9341                	srli	a4,a4,0x30
    8000928e:	00e79123          	sh	a4,2(a5)

  __sync_synchronize();
    80009292:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80009296:	100017b7          	lui	a5,0x10001
    8000929a:	05078793          	addi	a5,a5,80 # 10001050 <_entry-0x6fffefb0>
    8000929e:	0007a023          	sw	zero,0(a5)

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800092a2:	a819                	j	800092b8 <virtio_disk_rw+0x2f6>
    sleep(b, &disk.vdisk_lock);
    800092a4:	0001e597          	auipc	a1,0x1e
    800092a8:	05c58593          	addi	a1,a1,92 # 80027300 <disk+0x128>
    800092ac:	fc843503          	ld	a0,-56(s0)
    800092b0:	ffffa097          	auipc	ra,0xffffa
    800092b4:	158080e7          	jalr	344(ra) # 80003408 <sleep>
  while(b->disk == 1) {
    800092b8:	fc843783          	ld	a5,-56(s0)
    800092bc:	43dc                	lw	a5,4(a5)
    800092be:	873e                	mv	a4,a5
    800092c0:	4785                	li	a5,1
    800092c2:	fef701e3          	beq	a4,a5,800092a4 <virtio_disk_rw+0x2e2>
  }

  disk.info[idx[0]].b = 0;
    800092c6:	fd042783          	lw	a5,-48(s0)
    800092ca:	0001e717          	auipc	a4,0x1e
    800092ce:	f0e70713          	addi	a4,a4,-242 # 800271d8 <disk>
    800092d2:	0789                	addi	a5,a5,2
    800092d4:	0792                	slli	a5,a5,0x4
    800092d6:	97ba                	add	a5,a5,a4
    800092d8:	0007b423          	sd	zero,8(a5)
  free_chain(idx[0]);
    800092dc:	fd042783          	lw	a5,-48(s0)
    800092e0:	853e                	mv	a0,a5
    800092e2:	00000097          	auipc	ra,0x0
    800092e6:	bcc080e7          	jalr	-1076(ra) # 80008eae <free_chain>

  release(&disk.vdisk_lock);
    800092ea:	0001e517          	auipc	a0,0x1e
    800092ee:	01650513          	addi	a0,a0,22 # 80027300 <disk+0x128>
    800092f2:	ffff8097          	auipc	ra,0xffff8
    800092f6:	ff0080e7          	jalr	-16(ra) # 800012e2 <release>
}
    800092fa:	0001                	nop
    800092fc:	70e2                	ld	ra,56(sp)
    800092fe:	7442                	ld	s0,48(sp)
    80009300:	6121                	addi	sp,sp,64
    80009302:	8082                	ret

0000000080009304 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80009304:	1101                	addi	sp,sp,-32
    80009306:	ec06                	sd	ra,24(sp)
    80009308:	e822                	sd	s0,16(sp)
    8000930a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000930c:	0001e517          	auipc	a0,0x1e
    80009310:	ff450513          	addi	a0,a0,-12 # 80027300 <disk+0x128>
    80009314:	ffff8097          	auipc	ra,0xffff8
    80009318:	f6a080e7          	jalr	-150(ra) # 8000127e <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000931c:	100017b7          	lui	a5,0x10001
    80009320:	06078793          	addi	a5,a5,96 # 10001060 <_entry-0x6fffefa0>
    80009324:	439c                	lw	a5,0(a5)
    80009326:	0007871b          	sext.w	a4,a5
    8000932a:	100017b7          	lui	a5,0x10001
    8000932e:	06478793          	addi	a5,a5,100 # 10001064 <_entry-0x6fffef9c>
    80009332:	8b0d                	andi	a4,a4,3
    80009334:	2701                	sext.w	a4,a4
    80009336:	c398                	sw	a4,0(a5)

  __sync_synchronize();
    80009338:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8000933c:	a045                	j	800093dc <virtio_disk_intr+0xd8>
    __sync_synchronize();
    8000933e:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80009342:	0001e797          	auipc	a5,0x1e
    80009346:	e9678793          	addi	a5,a5,-362 # 800271d8 <disk>
    8000934a:	6b98                	ld	a4,16(a5)
    8000934c:	0001e797          	auipc	a5,0x1e
    80009350:	e8c78793          	addi	a5,a5,-372 # 800271d8 <disk>
    80009354:	0207d783          	lhu	a5,32(a5)
    80009358:	2781                	sext.w	a5,a5
    8000935a:	8b9d                	andi	a5,a5,7
    8000935c:	2781                	sext.w	a5,a5
    8000935e:	078e                	slli	a5,a5,0x3
    80009360:	97ba                	add	a5,a5,a4
    80009362:	43dc                	lw	a5,4(a5)
    80009364:	fef42623          	sw	a5,-20(s0)

    if(disk.info[id].status != 0)
    80009368:	0001e717          	auipc	a4,0x1e
    8000936c:	e7070713          	addi	a4,a4,-400 # 800271d8 <disk>
    80009370:	fec42783          	lw	a5,-20(s0)
    80009374:	0789                	addi	a5,a5,2
    80009376:	0792                	slli	a5,a5,0x4
    80009378:	97ba                	add	a5,a5,a4
    8000937a:	0107c783          	lbu	a5,16(a5)
    8000937e:	cb89                	beqz	a5,80009390 <virtio_disk_intr+0x8c>
      panic("virtio_disk_intr status");
    80009380:	00002517          	auipc	a0,0x2
    80009384:	3d050513          	addi	a0,a0,976 # 8000b750 <etext+0x750>
    80009388:	ffff8097          	auipc	ra,0xffff8
    8000938c:	902080e7          	jalr	-1790(ra) # 80000c8a <panic>

    struct buf *b = disk.info[id].b;
    80009390:	0001e717          	auipc	a4,0x1e
    80009394:	e4870713          	addi	a4,a4,-440 # 800271d8 <disk>
    80009398:	fec42783          	lw	a5,-20(s0)
    8000939c:	0789                	addi	a5,a5,2
    8000939e:	0792                	slli	a5,a5,0x4
    800093a0:	97ba                	add	a5,a5,a4
    800093a2:	679c                	ld	a5,8(a5)
    800093a4:	fef43023          	sd	a5,-32(s0)
    b->disk = 0;   // disk is done with buf
    800093a8:	fe043783          	ld	a5,-32(s0)
    800093ac:	0007a223          	sw	zero,4(a5)
    wakeup(b);
    800093b0:	fe043503          	ld	a0,-32(s0)
    800093b4:	ffffa097          	auipc	ra,0xffffa
    800093b8:	0d0080e7          	jalr	208(ra) # 80003484 <wakeup>

    disk.used_idx += 1;
    800093bc:	0001e797          	auipc	a5,0x1e
    800093c0:	e1c78793          	addi	a5,a5,-484 # 800271d8 <disk>
    800093c4:	0207d783          	lhu	a5,32(a5)
    800093c8:	2785                	addiw	a5,a5,1
    800093ca:	03079713          	slli	a4,a5,0x30
    800093ce:	9341                	srli	a4,a4,0x30
    800093d0:	0001e797          	auipc	a5,0x1e
    800093d4:	e0878793          	addi	a5,a5,-504 # 800271d8 <disk>
    800093d8:	02e79023          	sh	a4,32(a5)
  while(disk.used_idx != disk.used->idx){
    800093dc:	0001e797          	auipc	a5,0x1e
    800093e0:	dfc78793          	addi	a5,a5,-516 # 800271d8 <disk>
    800093e4:	0207d703          	lhu	a4,32(a5)
    800093e8:	0001e797          	auipc	a5,0x1e
    800093ec:	df078793          	addi	a5,a5,-528 # 800271d8 <disk>
    800093f0:	6b9c                	ld	a5,16(a5)
    800093f2:	0027d783          	lhu	a5,2(a5)
    800093f6:	2701                	sext.w	a4,a4
    800093f8:	2781                	sext.w	a5,a5
    800093fa:	f4f712e3          	bne	a4,a5,8000933e <virtio_disk_intr+0x3a>
  }

  release(&disk.vdisk_lock);
    800093fe:	0001e517          	auipc	a0,0x1e
    80009402:	f0250513          	addi	a0,a0,-254 # 80027300 <disk+0x128>
    80009406:	ffff8097          	auipc	ra,0xffff8
    8000940a:	edc080e7          	jalr	-292(ra) # 800012e2 <release>
}
    8000940e:	0001                	nop
    80009410:	60e2                	ld	ra,24(sp)
    80009412:	6442                	ld	s0,16(sp)
    80009414:	6105                	addi	sp,sp,32
    80009416:	8082                	ret
	...

000000008000a000 <_trampoline>:
    8000a000:	14051073          	csrw	sscratch,a0
    8000a004:	02000537          	lui	a0,0x2000
    8000a008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000a00a:	0536                	slli	a0,a0,0xd
    8000a00c:	02153423          	sd	ra,40(a0)
    8000a010:	02253823          	sd	sp,48(a0)
    8000a014:	02353c23          	sd	gp,56(a0)
    8000a018:	04453023          	sd	tp,64(a0)
    8000a01c:	04553423          	sd	t0,72(a0)
    8000a020:	04653823          	sd	t1,80(a0)
    8000a024:	04753c23          	sd	t2,88(a0)
    8000a028:	f120                	sd	s0,96(a0)
    8000a02a:	f524                	sd	s1,104(a0)
    8000a02c:	fd2c                	sd	a1,120(a0)
    8000a02e:	e150                	sd	a2,128(a0)
    8000a030:	e554                	sd	a3,136(a0)
    8000a032:	e958                	sd	a4,144(a0)
    8000a034:	ed5c                	sd	a5,152(a0)
    8000a036:	0b053023          	sd	a6,160(a0)
    8000a03a:	0b153423          	sd	a7,168(a0)
    8000a03e:	0b253823          	sd	s2,176(a0)
    8000a042:	0b353c23          	sd	s3,184(a0)
    8000a046:	0d453023          	sd	s4,192(a0)
    8000a04a:	0d553423          	sd	s5,200(a0)
    8000a04e:	0d653823          	sd	s6,208(a0)
    8000a052:	0d753c23          	sd	s7,216(a0)
    8000a056:	0f853023          	sd	s8,224(a0)
    8000a05a:	0f953423          	sd	s9,232(a0)
    8000a05e:	0fa53823          	sd	s10,240(a0)
    8000a062:	0fb53c23          	sd	s11,248(a0)
    8000a066:	11c53023          	sd	t3,256(a0)
    8000a06a:	11d53423          	sd	t4,264(a0)
    8000a06e:	11e53823          	sd	t5,272(a0)
    8000a072:	11f53c23          	sd	t6,280(a0)
    8000a076:	140022f3          	csrr	t0,sscratch
    8000a07a:	06553823          	sd	t0,112(a0)
    8000a07e:	00853103          	ld	sp,8(a0)
    8000a082:	02053203          	ld	tp,32(a0)
    8000a086:	01053283          	ld	t0,16(a0)
    8000a08a:	00053303          	ld	t1,0(a0)
    8000a08e:	12000073          	sfence.vma
    8000a092:	18031073          	csrw	satp,t1
    8000a096:	12000073          	sfence.vma
    8000a09a:	8282                	jr	t0

000000008000a09c <userret>:
    8000a09c:	12000073          	sfence.vma
    8000a0a0:	18051073          	csrw	satp,a0
    8000a0a4:	12000073          	sfence.vma
    8000a0a8:	02000537          	lui	a0,0x2000
    8000a0ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000a0ae:	0536                	slli	a0,a0,0xd
    8000a0b0:	02853083          	ld	ra,40(a0)
    8000a0b4:	03053103          	ld	sp,48(a0)
    8000a0b8:	03853183          	ld	gp,56(a0)
    8000a0bc:	04053203          	ld	tp,64(a0)
    8000a0c0:	04853283          	ld	t0,72(a0)
    8000a0c4:	05053303          	ld	t1,80(a0)
    8000a0c8:	05853383          	ld	t2,88(a0)
    8000a0cc:	7120                	ld	s0,96(a0)
    8000a0ce:	7524                	ld	s1,104(a0)
    8000a0d0:	7d2c                	ld	a1,120(a0)
    8000a0d2:	6150                	ld	a2,128(a0)
    8000a0d4:	6554                	ld	a3,136(a0)
    8000a0d6:	6958                	ld	a4,144(a0)
    8000a0d8:	6d5c                	ld	a5,152(a0)
    8000a0da:	0a053803          	ld	a6,160(a0)
    8000a0de:	0a853883          	ld	a7,168(a0)
    8000a0e2:	0b053903          	ld	s2,176(a0)
    8000a0e6:	0b853983          	ld	s3,184(a0)
    8000a0ea:	0c053a03          	ld	s4,192(a0)
    8000a0ee:	0c853a83          	ld	s5,200(a0)
    8000a0f2:	0d053b03          	ld	s6,208(a0)
    8000a0f6:	0d853b83          	ld	s7,216(a0)
    8000a0fa:	0e053c03          	ld	s8,224(a0)
    8000a0fe:	0e853c83          	ld	s9,232(a0)
    8000a102:	0f053d03          	ld	s10,240(a0)
    8000a106:	0f853d83          	ld	s11,248(a0)
    8000a10a:	10053e03          	ld	t3,256(a0)
    8000a10e:	10853e83          	ld	t4,264(a0)
    8000a112:	11053f03          	ld	t5,272(a0)
    8000a116:	11853f83          	ld	t6,280(a0)
    8000a11a:	7928                	ld	a0,112(a0)
    8000a11c:	10200073          	sret
	...
