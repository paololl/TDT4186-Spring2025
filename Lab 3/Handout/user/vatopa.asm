
user/_vatopa:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <hex2ulong>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

// Helper to convert hex string to unsigned long.
unsigned long hex2ulong(const char *s) {
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
   6:	86aa                	mv	a3,a0
    unsigned long result = 0;
    if(s[0] == '0' && (s[1] == 'x' || s[1] == 'X'))
   8:	00054703          	lbu	a4,0(a0)
   c:	03000793          	li	a5,48
  10:	00f70963          	beq	a4,a5,22 <hex2ulong+0x22>
        s += 2;
    while(*s) {
  14:	0006c783          	lbu	a5,0(a3)
  18:	c7ad                	beqz	a5,82 <hex2ulong+0x82>
unsigned long hex2ulong(const char *s) {
  1a:	4501                	li	a0,0
        result *= 16;
        if(*s >= '0' && *s <= '9')
  1c:	4625                	li	a2,9
            result += *s - '0';
        else if(*s >= 'a' && *s <= 'f')
  1e:	4595                	li	a1,5
  20:	a825                	j	58 <hex2ulong+0x58>
    if(s[0] == '0' && (s[1] == 'x' || s[1] == 'X'))
  22:	00154783          	lbu	a5,1(a0)
  26:	0df7f793          	andi	a5,a5,223
  2a:	05800713          	li	a4,88
  2e:	00e78563          	beq	a5,a4,38 <hex2ulong+0x38>
    while(*s) {
  32:	00054783          	lbu	a5,0(a0)
  36:	b7d5                	j	1a <hex2ulong+0x1a>
        s += 2;
  38:	00250693          	addi	a3,a0,2
  3c:	bfe1                	j	14 <hex2ulong+0x14>
        else if(*s >= 'a' && *s <= 'f')
  3e:	f9f7871b          	addiw	a4,a5,-97
  42:	0ff77713          	zext.b	a4,a4
  46:	02e5e463          	bltu	a1,a4,6e <hex2ulong+0x6e>
            result += *s - 'a' + 10;
  4a:	fa97879b          	addiw	a5,a5,-87
  4e:	953e                	add	a0,a0,a5
        else if(*s >= 'A' && *s <= 'F')
            result += *s - 'A' + 10;
        else
            break;
        s++;
  50:	0685                	addi	a3,a3,1
    while(*s) {
  52:	0006c783          	lbu	a5,0(a3)
  56:	c79d                	beqz	a5,84 <hex2ulong+0x84>
        result *= 16;
  58:	0512                	slli	a0,a0,0x4
        if(*s >= '0' && *s <= '9')
  5a:	fd07871b          	addiw	a4,a5,-48
  5e:	0ff77713          	zext.b	a4,a4
  62:	fce66ee3          	bltu	a2,a4,3e <hex2ulong+0x3e>
            result += *s - '0';
  66:	fd07879b          	addiw	a5,a5,-48
  6a:	953e                	add	a0,a0,a5
  6c:	b7d5                	j	50 <hex2ulong+0x50>
        else if(*s >= 'A' && *s <= 'F')
  6e:	fbf7871b          	addiw	a4,a5,-65
  72:	0ff77713          	zext.b	a4,a4
  76:	00e5e763          	bltu	a1,a4,84 <hex2ulong+0x84>
            result += *s - 'A' + 10;
  7a:	fc97879b          	addiw	a5,a5,-55
  7e:	953e                	add	a0,a0,a5
  80:	bfc1                	j	50 <hex2ulong+0x50>
    while(*s) {
  82:	4501                	li	a0,0
    }
    return result;
}
  84:	6422                	ld	s0,8(sp)
  86:	0141                	addi	sp,sp,16
  88:	8082                	ret

000000000000008a <main>:

int main(int argc, char *argv[]) {
  8a:	7179                	addi	sp,sp,-48
  8c:	f406                	sd	ra,40(sp)
  8e:	f022                	sd	s0,32(sp)
  90:	1800                	addi	s0,sp,48
    if (argc < 2) {
  92:	4785                	li	a5,1
  94:	04a7d563          	bge	a5,a0,de <main+0x54>
  98:	ec26                	sd	s1,24(sp)
  9a:	e84a                	sd	s2,16(sp)
  9c:	e44e                	sd	s3,8(sp)
  9e:	84aa                	mv	s1,a0
  a0:	892e                	mv	s2,a1
        printf("Usage: vatopa virtual_address [pid]\n");
        exit(1);
    }
    uint64 va = hex2ulong(argv[1]);
  a2:	6588                	ld	a0,8(a1)
  a4:	00000097          	auipc	ra,0x0
  a8:	f5c080e7          	jalr	-164(ra) # 0 <hex2ulong>
  ac:	89aa                	mv	s3,a0
    int pid = 0;
    if (argc > 2) {
  ae:	4789                	li	a5,2
    int pid = 0;
  b0:	4581                	li	a1,0
    if (argc > 2) {
  b2:	0497c663          	blt	a5,s1,fe <main+0x74>
        pid = atoi(argv[2]);
    }
    uint64 pa = va2pa(va, pid);
  b6:	854e                	mv	a0,s3
  b8:	00000097          	auipc	ra,0x0
  bc:	3a6080e7          	jalr	934(ra) # 45e <va2pa>
  c0:	85aa                	mv	a1,a0
    if (pa == 0) {
  c2:	e531                	bnez	a0,10e <main+0x84>
        printf("0x0\n");
  c4:	00001517          	auipc	a0,0x1
  c8:	85450513          	addi	a0,a0,-1964 # 918 <malloc+0x12a>
  cc:	00000097          	auipc	ra,0x0
  d0:	66a080e7          	jalr	1642(ra) # 736 <printf>
    } else {
        printf("0x%x\n", pa);
    }
    exit(0);
  d4:	4501                	li	a0,0
  d6:	00000097          	auipc	ra,0x0
  da:	2d0080e7          	jalr	720(ra) # 3a6 <exit>
  de:	ec26                	sd	s1,24(sp)
  e0:	e84a                	sd	s2,16(sp)
  e2:	e44e                	sd	s3,8(sp)
        printf("Usage: vatopa virtual_address [pid]\n");
  e4:	00001517          	auipc	a0,0x1
  e8:	80c50513          	addi	a0,a0,-2036 # 8f0 <malloc+0x102>
  ec:	00000097          	auipc	ra,0x0
  f0:	64a080e7          	jalr	1610(ra) # 736 <printf>
        exit(1);
  f4:	4505                	li	a0,1
  f6:	00000097          	auipc	ra,0x0
  fa:	2b0080e7          	jalr	688(ra) # 3a6 <exit>
        pid = atoi(argv[2]);
  fe:	01093503          	ld	a0,16(s2)
 102:	00000097          	auipc	ra,0x0
 106:	1aa080e7          	jalr	426(ra) # 2ac <atoi>
 10a:	85aa                	mv	a1,a0
 10c:	b76d                	j	b6 <main+0x2c>
        printf("0x%x\n", pa);
 10e:	00001517          	auipc	a0,0x1
 112:	81250513          	addi	a0,a0,-2030 # 920 <malloc+0x132>
 116:	00000097          	auipc	ra,0x0
 11a:	620080e7          	jalr	1568(ra) # 736 <printf>
 11e:	bf5d                	j	d4 <main+0x4a>

0000000000000120 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 120:	1141                	addi	sp,sp,-16
 122:	e406                	sd	ra,8(sp)
 124:	e022                	sd	s0,0(sp)
 126:	0800                	addi	s0,sp,16
  extern int main();
  main();
 128:	00000097          	auipc	ra,0x0
 12c:	f62080e7          	jalr	-158(ra) # 8a <main>
  exit(0);
 130:	4501                	li	a0,0
 132:	00000097          	auipc	ra,0x0
 136:	274080e7          	jalr	628(ra) # 3a6 <exit>

000000000000013a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 13a:	1141                	addi	sp,sp,-16
 13c:	e422                	sd	s0,8(sp)
 13e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 140:	87aa                	mv	a5,a0
 142:	0585                	addi	a1,a1,1
 144:	0785                	addi	a5,a5,1
 146:	fff5c703          	lbu	a4,-1(a1)
 14a:	fee78fa3          	sb	a4,-1(a5)
 14e:	fb75                	bnez	a4,142 <strcpy+0x8>
    ;
  return os;
}
 150:	6422                	ld	s0,8(sp)
 152:	0141                	addi	sp,sp,16
 154:	8082                	ret

0000000000000156 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 156:	1141                	addi	sp,sp,-16
 158:	e422                	sd	s0,8(sp)
 15a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 15c:	00054783          	lbu	a5,0(a0)
 160:	cb91                	beqz	a5,174 <strcmp+0x1e>
 162:	0005c703          	lbu	a4,0(a1)
 166:	00f71763          	bne	a4,a5,174 <strcmp+0x1e>
    p++, q++;
 16a:	0505                	addi	a0,a0,1
 16c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 16e:	00054783          	lbu	a5,0(a0)
 172:	fbe5                	bnez	a5,162 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 174:	0005c503          	lbu	a0,0(a1)
}
 178:	40a7853b          	subw	a0,a5,a0
 17c:	6422                	ld	s0,8(sp)
 17e:	0141                	addi	sp,sp,16
 180:	8082                	ret

0000000000000182 <strlen>:

uint
strlen(const char *s)
{
 182:	1141                	addi	sp,sp,-16
 184:	e422                	sd	s0,8(sp)
 186:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 188:	00054783          	lbu	a5,0(a0)
 18c:	cf91                	beqz	a5,1a8 <strlen+0x26>
 18e:	0505                	addi	a0,a0,1
 190:	87aa                	mv	a5,a0
 192:	86be                	mv	a3,a5
 194:	0785                	addi	a5,a5,1
 196:	fff7c703          	lbu	a4,-1(a5)
 19a:	ff65                	bnez	a4,192 <strlen+0x10>
 19c:	40a6853b          	subw	a0,a3,a0
 1a0:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1a2:	6422                	ld	s0,8(sp)
 1a4:	0141                	addi	sp,sp,16
 1a6:	8082                	ret
  for(n = 0; s[n]; n++)
 1a8:	4501                	li	a0,0
 1aa:	bfe5                	j	1a2 <strlen+0x20>

00000000000001ac <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ac:	1141                	addi	sp,sp,-16
 1ae:	e422                	sd	s0,8(sp)
 1b0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1b2:	ca19                	beqz	a2,1c8 <memset+0x1c>
 1b4:	87aa                	mv	a5,a0
 1b6:	1602                	slli	a2,a2,0x20
 1b8:	9201                	srli	a2,a2,0x20
 1ba:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1be:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1c2:	0785                	addi	a5,a5,1
 1c4:	fee79de3          	bne	a5,a4,1be <memset+0x12>
  }
  return dst;
}
 1c8:	6422                	ld	s0,8(sp)
 1ca:	0141                	addi	sp,sp,16
 1cc:	8082                	ret

00000000000001ce <strchr>:

char*
strchr(const char *s, char c)
{
 1ce:	1141                	addi	sp,sp,-16
 1d0:	e422                	sd	s0,8(sp)
 1d2:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1d4:	00054783          	lbu	a5,0(a0)
 1d8:	cb99                	beqz	a5,1ee <strchr+0x20>
    if(*s == c)
 1da:	00f58763          	beq	a1,a5,1e8 <strchr+0x1a>
  for(; *s; s++)
 1de:	0505                	addi	a0,a0,1
 1e0:	00054783          	lbu	a5,0(a0)
 1e4:	fbfd                	bnez	a5,1da <strchr+0xc>
      return (char*)s;
  return 0;
 1e6:	4501                	li	a0,0
}
 1e8:	6422                	ld	s0,8(sp)
 1ea:	0141                	addi	sp,sp,16
 1ec:	8082                	ret
  return 0;
 1ee:	4501                	li	a0,0
 1f0:	bfe5                	j	1e8 <strchr+0x1a>

00000000000001f2 <gets>:

char*
gets(char *buf, int max)
{
 1f2:	711d                	addi	sp,sp,-96
 1f4:	ec86                	sd	ra,88(sp)
 1f6:	e8a2                	sd	s0,80(sp)
 1f8:	e4a6                	sd	s1,72(sp)
 1fa:	e0ca                	sd	s2,64(sp)
 1fc:	fc4e                	sd	s3,56(sp)
 1fe:	f852                	sd	s4,48(sp)
 200:	f456                	sd	s5,40(sp)
 202:	f05a                	sd	s6,32(sp)
 204:	ec5e                	sd	s7,24(sp)
 206:	1080                	addi	s0,sp,96
 208:	8baa                	mv	s7,a0
 20a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 20c:	892a                	mv	s2,a0
 20e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 210:	4aa9                	li	s5,10
 212:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 214:	89a6                	mv	s3,s1
 216:	2485                	addiw	s1,s1,1
 218:	0344d863          	bge	s1,s4,248 <gets+0x56>
    cc = read(0, &c, 1);
 21c:	4605                	li	a2,1
 21e:	faf40593          	addi	a1,s0,-81
 222:	4501                	li	a0,0
 224:	00000097          	auipc	ra,0x0
 228:	19a080e7          	jalr	410(ra) # 3be <read>
    if(cc < 1)
 22c:	00a05e63          	blez	a0,248 <gets+0x56>
    buf[i++] = c;
 230:	faf44783          	lbu	a5,-81(s0)
 234:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 238:	01578763          	beq	a5,s5,246 <gets+0x54>
 23c:	0905                	addi	s2,s2,1
 23e:	fd679be3          	bne	a5,s6,214 <gets+0x22>
    buf[i++] = c;
 242:	89a6                	mv	s3,s1
 244:	a011                	j	248 <gets+0x56>
 246:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 248:	99de                	add	s3,s3,s7
 24a:	00098023          	sb	zero,0(s3)
  return buf;
}
 24e:	855e                	mv	a0,s7
 250:	60e6                	ld	ra,88(sp)
 252:	6446                	ld	s0,80(sp)
 254:	64a6                	ld	s1,72(sp)
 256:	6906                	ld	s2,64(sp)
 258:	79e2                	ld	s3,56(sp)
 25a:	7a42                	ld	s4,48(sp)
 25c:	7aa2                	ld	s5,40(sp)
 25e:	7b02                	ld	s6,32(sp)
 260:	6be2                	ld	s7,24(sp)
 262:	6125                	addi	sp,sp,96
 264:	8082                	ret

0000000000000266 <stat>:

int
stat(const char *n, struct stat *st)
{
 266:	1101                	addi	sp,sp,-32
 268:	ec06                	sd	ra,24(sp)
 26a:	e822                	sd	s0,16(sp)
 26c:	e04a                	sd	s2,0(sp)
 26e:	1000                	addi	s0,sp,32
 270:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 272:	4581                	li	a1,0
 274:	00000097          	auipc	ra,0x0
 278:	172080e7          	jalr	370(ra) # 3e6 <open>
  if(fd < 0)
 27c:	02054663          	bltz	a0,2a8 <stat+0x42>
 280:	e426                	sd	s1,8(sp)
 282:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 284:	85ca                	mv	a1,s2
 286:	00000097          	auipc	ra,0x0
 28a:	178080e7          	jalr	376(ra) # 3fe <fstat>
 28e:	892a                	mv	s2,a0
  close(fd);
 290:	8526                	mv	a0,s1
 292:	00000097          	auipc	ra,0x0
 296:	13c080e7          	jalr	316(ra) # 3ce <close>
  return r;
 29a:	64a2                	ld	s1,8(sp)
}
 29c:	854a                	mv	a0,s2
 29e:	60e2                	ld	ra,24(sp)
 2a0:	6442                	ld	s0,16(sp)
 2a2:	6902                	ld	s2,0(sp)
 2a4:	6105                	addi	sp,sp,32
 2a6:	8082                	ret
    return -1;
 2a8:	597d                	li	s2,-1
 2aa:	bfcd                	j	29c <stat+0x36>

00000000000002ac <atoi>:

int
atoi(const char *s)
{
 2ac:	1141                	addi	sp,sp,-16
 2ae:	e422                	sd	s0,8(sp)
 2b0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2b2:	00054683          	lbu	a3,0(a0)
 2b6:	fd06879b          	addiw	a5,a3,-48
 2ba:	0ff7f793          	zext.b	a5,a5
 2be:	4625                	li	a2,9
 2c0:	02f66863          	bltu	a2,a5,2f0 <atoi+0x44>
 2c4:	872a                	mv	a4,a0
  n = 0;
 2c6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2c8:	0705                	addi	a4,a4,1
 2ca:	0025179b          	slliw	a5,a0,0x2
 2ce:	9fa9                	addw	a5,a5,a0
 2d0:	0017979b          	slliw	a5,a5,0x1
 2d4:	9fb5                	addw	a5,a5,a3
 2d6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2da:	00074683          	lbu	a3,0(a4)
 2de:	fd06879b          	addiw	a5,a3,-48
 2e2:	0ff7f793          	zext.b	a5,a5
 2e6:	fef671e3          	bgeu	a2,a5,2c8 <atoi+0x1c>
  return n;
}
 2ea:	6422                	ld	s0,8(sp)
 2ec:	0141                	addi	sp,sp,16
 2ee:	8082                	ret
  n = 0;
 2f0:	4501                	li	a0,0
 2f2:	bfe5                	j	2ea <atoi+0x3e>

00000000000002f4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2f4:	1141                	addi	sp,sp,-16
 2f6:	e422                	sd	s0,8(sp)
 2f8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2fa:	02b57463          	bgeu	a0,a1,322 <memmove+0x2e>
    while(n-- > 0)
 2fe:	00c05f63          	blez	a2,31c <memmove+0x28>
 302:	1602                	slli	a2,a2,0x20
 304:	9201                	srli	a2,a2,0x20
 306:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 30a:	872a                	mv	a4,a0
      *dst++ = *src++;
 30c:	0585                	addi	a1,a1,1
 30e:	0705                	addi	a4,a4,1
 310:	fff5c683          	lbu	a3,-1(a1)
 314:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 318:	fef71ae3          	bne	a4,a5,30c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 31c:	6422                	ld	s0,8(sp)
 31e:	0141                	addi	sp,sp,16
 320:	8082                	ret
    dst += n;
 322:	00c50733          	add	a4,a0,a2
    src += n;
 326:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 328:	fec05ae3          	blez	a2,31c <memmove+0x28>
 32c:	fff6079b          	addiw	a5,a2,-1
 330:	1782                	slli	a5,a5,0x20
 332:	9381                	srli	a5,a5,0x20
 334:	fff7c793          	not	a5,a5
 338:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 33a:	15fd                	addi	a1,a1,-1
 33c:	177d                	addi	a4,a4,-1
 33e:	0005c683          	lbu	a3,0(a1)
 342:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 346:	fee79ae3          	bne	a5,a4,33a <memmove+0x46>
 34a:	bfc9                	j	31c <memmove+0x28>

000000000000034c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 34c:	1141                	addi	sp,sp,-16
 34e:	e422                	sd	s0,8(sp)
 350:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 352:	ca05                	beqz	a2,382 <memcmp+0x36>
 354:	fff6069b          	addiw	a3,a2,-1
 358:	1682                	slli	a3,a3,0x20
 35a:	9281                	srli	a3,a3,0x20
 35c:	0685                	addi	a3,a3,1
 35e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 360:	00054783          	lbu	a5,0(a0)
 364:	0005c703          	lbu	a4,0(a1)
 368:	00e79863          	bne	a5,a4,378 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 36c:	0505                	addi	a0,a0,1
    p2++;
 36e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 370:	fed518e3          	bne	a0,a3,360 <memcmp+0x14>
  }
  return 0;
 374:	4501                	li	a0,0
 376:	a019                	j	37c <memcmp+0x30>
      return *p1 - *p2;
 378:	40e7853b          	subw	a0,a5,a4
}
 37c:	6422                	ld	s0,8(sp)
 37e:	0141                	addi	sp,sp,16
 380:	8082                	ret
  return 0;
 382:	4501                	li	a0,0
 384:	bfe5                	j	37c <memcmp+0x30>

0000000000000386 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 386:	1141                	addi	sp,sp,-16
 388:	e406                	sd	ra,8(sp)
 38a:	e022                	sd	s0,0(sp)
 38c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 38e:	00000097          	auipc	ra,0x0
 392:	f66080e7          	jalr	-154(ra) # 2f4 <memmove>
}
 396:	60a2                	ld	ra,8(sp)
 398:	6402                	ld	s0,0(sp)
 39a:	0141                	addi	sp,sp,16
 39c:	8082                	ret

000000000000039e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 39e:	4885                	li	a7,1
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3a6:	4889                	li	a7,2
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <wait>:
.global wait
wait:
 li a7, SYS_wait
 3ae:	488d                	li	a7,3
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3b6:	4891                	li	a7,4
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <read>:
.global read
read:
 li a7, SYS_read
 3be:	4895                	li	a7,5
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <write>:
.global write
write:
 li a7, SYS_write
 3c6:	48c1                	li	a7,16
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <close>:
.global close
close:
 li a7, SYS_close
 3ce:	48d5                	li	a7,21
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3d6:	4899                	li	a7,6
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <exec>:
.global exec
exec:
 li a7, SYS_exec
 3de:	489d                	li	a7,7
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <open>:
.global open
open:
 li a7, SYS_open
 3e6:	48bd                	li	a7,15
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3ee:	48c5                	li	a7,17
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3f6:	48c9                	li	a7,18
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3fe:	48a1                	li	a7,8
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <link>:
.global link
link:
 li a7, SYS_link
 406:	48cd                	li	a7,19
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 40e:	48d1                	li	a7,20
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 416:	48a5                	li	a7,9
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <dup>:
.global dup
dup:
 li a7, SYS_dup
 41e:	48a9                	li	a7,10
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 426:	48ad                	li	a7,11
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 42e:	48b1                	li	a7,12
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 436:	48b5                	li	a7,13
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 43e:	48b9                	li	a7,14
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <ps>:
.global ps
ps:
 li a7, SYS_ps
 446:	48d9                	li	a7,22
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 44e:	48dd                	li	a7,23
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 456:	48e1                	li	a7,24
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <va2pa>:
.global va2pa
va2pa:
 li a7, SYS_va2pa
 45e:	48e9                	li	a7,26
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <pfreepages>:
.global pfreepages
pfreepages:
 li a7, SYS_pfreepages
 466:	48e5                	li	a7,25
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 46e:	1101                	addi	sp,sp,-32
 470:	ec06                	sd	ra,24(sp)
 472:	e822                	sd	s0,16(sp)
 474:	1000                	addi	s0,sp,32
 476:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 47a:	4605                	li	a2,1
 47c:	fef40593          	addi	a1,s0,-17
 480:	00000097          	auipc	ra,0x0
 484:	f46080e7          	jalr	-186(ra) # 3c6 <write>
}
 488:	60e2                	ld	ra,24(sp)
 48a:	6442                	ld	s0,16(sp)
 48c:	6105                	addi	sp,sp,32
 48e:	8082                	ret

0000000000000490 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 490:	7139                	addi	sp,sp,-64
 492:	fc06                	sd	ra,56(sp)
 494:	f822                	sd	s0,48(sp)
 496:	f426                	sd	s1,40(sp)
 498:	0080                	addi	s0,sp,64
 49a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 49c:	c299                	beqz	a3,4a2 <printint+0x12>
 49e:	0805cb63          	bltz	a1,534 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4a2:	2581                	sext.w	a1,a1
  neg = 0;
 4a4:	4881                	li	a7,0
 4a6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4aa:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4ac:	2601                	sext.w	a2,a2
 4ae:	00000517          	auipc	a0,0x0
 4b2:	4da50513          	addi	a0,a0,1242 # 988 <digits>
 4b6:	883a                	mv	a6,a4
 4b8:	2705                	addiw	a4,a4,1
 4ba:	02c5f7bb          	remuw	a5,a1,a2
 4be:	1782                	slli	a5,a5,0x20
 4c0:	9381                	srli	a5,a5,0x20
 4c2:	97aa                	add	a5,a5,a0
 4c4:	0007c783          	lbu	a5,0(a5)
 4c8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4cc:	0005879b          	sext.w	a5,a1
 4d0:	02c5d5bb          	divuw	a1,a1,a2
 4d4:	0685                	addi	a3,a3,1
 4d6:	fec7f0e3          	bgeu	a5,a2,4b6 <printint+0x26>
  if(neg)
 4da:	00088c63          	beqz	a7,4f2 <printint+0x62>
    buf[i++] = '-';
 4de:	fd070793          	addi	a5,a4,-48
 4e2:	00878733          	add	a4,a5,s0
 4e6:	02d00793          	li	a5,45
 4ea:	fef70823          	sb	a5,-16(a4)
 4ee:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4f2:	02e05c63          	blez	a4,52a <printint+0x9a>
 4f6:	f04a                	sd	s2,32(sp)
 4f8:	ec4e                	sd	s3,24(sp)
 4fa:	fc040793          	addi	a5,s0,-64
 4fe:	00e78933          	add	s2,a5,a4
 502:	fff78993          	addi	s3,a5,-1
 506:	99ba                	add	s3,s3,a4
 508:	377d                	addiw	a4,a4,-1
 50a:	1702                	slli	a4,a4,0x20
 50c:	9301                	srli	a4,a4,0x20
 50e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 512:	fff94583          	lbu	a1,-1(s2)
 516:	8526                	mv	a0,s1
 518:	00000097          	auipc	ra,0x0
 51c:	f56080e7          	jalr	-170(ra) # 46e <putc>
  while(--i >= 0)
 520:	197d                	addi	s2,s2,-1
 522:	ff3918e3          	bne	s2,s3,512 <printint+0x82>
 526:	7902                	ld	s2,32(sp)
 528:	69e2                	ld	s3,24(sp)
}
 52a:	70e2                	ld	ra,56(sp)
 52c:	7442                	ld	s0,48(sp)
 52e:	74a2                	ld	s1,40(sp)
 530:	6121                	addi	sp,sp,64
 532:	8082                	ret
    x = -xx;
 534:	40b005bb          	negw	a1,a1
    neg = 1;
 538:	4885                	li	a7,1
    x = -xx;
 53a:	b7b5                	j	4a6 <printint+0x16>

000000000000053c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 53c:	715d                	addi	sp,sp,-80
 53e:	e486                	sd	ra,72(sp)
 540:	e0a2                	sd	s0,64(sp)
 542:	f84a                	sd	s2,48(sp)
 544:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 546:	0005c903          	lbu	s2,0(a1)
 54a:	1a090a63          	beqz	s2,6fe <vprintf+0x1c2>
 54e:	fc26                	sd	s1,56(sp)
 550:	f44e                	sd	s3,40(sp)
 552:	f052                	sd	s4,32(sp)
 554:	ec56                	sd	s5,24(sp)
 556:	e85a                	sd	s6,16(sp)
 558:	e45e                	sd	s7,8(sp)
 55a:	8aaa                	mv	s5,a0
 55c:	8bb2                	mv	s7,a2
 55e:	00158493          	addi	s1,a1,1
  state = 0;
 562:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 564:	02500a13          	li	s4,37
 568:	4b55                	li	s6,21
 56a:	a839                	j	588 <vprintf+0x4c>
        putc(fd, c);
 56c:	85ca                	mv	a1,s2
 56e:	8556                	mv	a0,s5
 570:	00000097          	auipc	ra,0x0
 574:	efe080e7          	jalr	-258(ra) # 46e <putc>
 578:	a019                	j	57e <vprintf+0x42>
    } else if(state == '%'){
 57a:	01498d63          	beq	s3,s4,594 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 57e:	0485                	addi	s1,s1,1
 580:	fff4c903          	lbu	s2,-1(s1)
 584:	16090763          	beqz	s2,6f2 <vprintf+0x1b6>
    if(state == 0){
 588:	fe0999e3          	bnez	s3,57a <vprintf+0x3e>
      if(c == '%'){
 58c:	ff4910e3          	bne	s2,s4,56c <vprintf+0x30>
        state = '%';
 590:	89d2                	mv	s3,s4
 592:	b7f5                	j	57e <vprintf+0x42>
      if(c == 'd'){
 594:	13490463          	beq	s2,s4,6bc <vprintf+0x180>
 598:	f9d9079b          	addiw	a5,s2,-99
 59c:	0ff7f793          	zext.b	a5,a5
 5a0:	12fb6763          	bltu	s6,a5,6ce <vprintf+0x192>
 5a4:	f9d9079b          	addiw	a5,s2,-99
 5a8:	0ff7f713          	zext.b	a4,a5
 5ac:	12eb6163          	bltu	s6,a4,6ce <vprintf+0x192>
 5b0:	00271793          	slli	a5,a4,0x2
 5b4:	00000717          	auipc	a4,0x0
 5b8:	37c70713          	addi	a4,a4,892 # 930 <malloc+0x142>
 5bc:	97ba                	add	a5,a5,a4
 5be:	439c                	lw	a5,0(a5)
 5c0:	97ba                	add	a5,a5,a4
 5c2:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5c4:	008b8913          	addi	s2,s7,8
 5c8:	4685                	li	a3,1
 5ca:	4629                	li	a2,10
 5cc:	000ba583          	lw	a1,0(s7)
 5d0:	8556                	mv	a0,s5
 5d2:	00000097          	auipc	ra,0x0
 5d6:	ebe080e7          	jalr	-322(ra) # 490 <printint>
 5da:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5dc:	4981                	li	s3,0
 5de:	b745                	j	57e <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e0:	008b8913          	addi	s2,s7,8
 5e4:	4681                	li	a3,0
 5e6:	4629                	li	a2,10
 5e8:	000ba583          	lw	a1,0(s7)
 5ec:	8556                	mv	a0,s5
 5ee:	00000097          	auipc	ra,0x0
 5f2:	ea2080e7          	jalr	-350(ra) # 490 <printint>
 5f6:	8bca                	mv	s7,s2
      state = 0;
 5f8:	4981                	li	s3,0
 5fa:	b751                	j	57e <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5fc:	008b8913          	addi	s2,s7,8
 600:	4681                	li	a3,0
 602:	4641                	li	a2,16
 604:	000ba583          	lw	a1,0(s7)
 608:	8556                	mv	a0,s5
 60a:	00000097          	auipc	ra,0x0
 60e:	e86080e7          	jalr	-378(ra) # 490 <printint>
 612:	8bca                	mv	s7,s2
      state = 0;
 614:	4981                	li	s3,0
 616:	b7a5                	j	57e <vprintf+0x42>
 618:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 61a:	008b8c13          	addi	s8,s7,8
 61e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 622:	03000593          	li	a1,48
 626:	8556                	mv	a0,s5
 628:	00000097          	auipc	ra,0x0
 62c:	e46080e7          	jalr	-442(ra) # 46e <putc>
  putc(fd, 'x');
 630:	07800593          	li	a1,120
 634:	8556                	mv	a0,s5
 636:	00000097          	auipc	ra,0x0
 63a:	e38080e7          	jalr	-456(ra) # 46e <putc>
 63e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 640:	00000b97          	auipc	s7,0x0
 644:	348b8b93          	addi	s7,s7,840 # 988 <digits>
 648:	03c9d793          	srli	a5,s3,0x3c
 64c:	97de                	add	a5,a5,s7
 64e:	0007c583          	lbu	a1,0(a5)
 652:	8556                	mv	a0,s5
 654:	00000097          	auipc	ra,0x0
 658:	e1a080e7          	jalr	-486(ra) # 46e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 65c:	0992                	slli	s3,s3,0x4
 65e:	397d                	addiw	s2,s2,-1
 660:	fe0914e3          	bnez	s2,648 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 664:	8be2                	mv	s7,s8
      state = 0;
 666:	4981                	li	s3,0
 668:	6c02                	ld	s8,0(sp)
 66a:	bf11                	j	57e <vprintf+0x42>
        s = va_arg(ap, char*);
 66c:	008b8993          	addi	s3,s7,8
 670:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 674:	02090163          	beqz	s2,696 <vprintf+0x15a>
        while(*s != 0){
 678:	00094583          	lbu	a1,0(s2)
 67c:	c9a5                	beqz	a1,6ec <vprintf+0x1b0>
          putc(fd, *s);
 67e:	8556                	mv	a0,s5
 680:	00000097          	auipc	ra,0x0
 684:	dee080e7          	jalr	-530(ra) # 46e <putc>
          s++;
 688:	0905                	addi	s2,s2,1
        while(*s != 0){
 68a:	00094583          	lbu	a1,0(s2)
 68e:	f9e5                	bnez	a1,67e <vprintf+0x142>
        s = va_arg(ap, char*);
 690:	8bce                	mv	s7,s3
      state = 0;
 692:	4981                	li	s3,0
 694:	b5ed                	j	57e <vprintf+0x42>
          s = "(null)";
 696:	00000917          	auipc	s2,0x0
 69a:	29290913          	addi	s2,s2,658 # 928 <malloc+0x13a>
        while(*s != 0){
 69e:	02800593          	li	a1,40
 6a2:	bff1                	j	67e <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 6a4:	008b8913          	addi	s2,s7,8
 6a8:	000bc583          	lbu	a1,0(s7)
 6ac:	8556                	mv	a0,s5
 6ae:	00000097          	auipc	ra,0x0
 6b2:	dc0080e7          	jalr	-576(ra) # 46e <putc>
 6b6:	8bca                	mv	s7,s2
      state = 0;
 6b8:	4981                	li	s3,0
 6ba:	b5d1                	j	57e <vprintf+0x42>
        putc(fd, c);
 6bc:	02500593          	li	a1,37
 6c0:	8556                	mv	a0,s5
 6c2:	00000097          	auipc	ra,0x0
 6c6:	dac080e7          	jalr	-596(ra) # 46e <putc>
      state = 0;
 6ca:	4981                	li	s3,0
 6cc:	bd4d                	j	57e <vprintf+0x42>
        putc(fd, '%');
 6ce:	02500593          	li	a1,37
 6d2:	8556                	mv	a0,s5
 6d4:	00000097          	auipc	ra,0x0
 6d8:	d9a080e7          	jalr	-614(ra) # 46e <putc>
        putc(fd, c);
 6dc:	85ca                	mv	a1,s2
 6de:	8556                	mv	a0,s5
 6e0:	00000097          	auipc	ra,0x0
 6e4:	d8e080e7          	jalr	-626(ra) # 46e <putc>
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	bd51                	j	57e <vprintf+0x42>
        s = va_arg(ap, char*);
 6ec:	8bce                	mv	s7,s3
      state = 0;
 6ee:	4981                	li	s3,0
 6f0:	b579                	j	57e <vprintf+0x42>
 6f2:	74e2                	ld	s1,56(sp)
 6f4:	79a2                	ld	s3,40(sp)
 6f6:	7a02                	ld	s4,32(sp)
 6f8:	6ae2                	ld	s5,24(sp)
 6fa:	6b42                	ld	s6,16(sp)
 6fc:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6fe:	60a6                	ld	ra,72(sp)
 700:	6406                	ld	s0,64(sp)
 702:	7942                	ld	s2,48(sp)
 704:	6161                	addi	sp,sp,80
 706:	8082                	ret

0000000000000708 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 708:	715d                	addi	sp,sp,-80
 70a:	ec06                	sd	ra,24(sp)
 70c:	e822                	sd	s0,16(sp)
 70e:	1000                	addi	s0,sp,32
 710:	e010                	sd	a2,0(s0)
 712:	e414                	sd	a3,8(s0)
 714:	e818                	sd	a4,16(s0)
 716:	ec1c                	sd	a5,24(s0)
 718:	03043023          	sd	a6,32(s0)
 71c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 720:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 724:	8622                	mv	a2,s0
 726:	00000097          	auipc	ra,0x0
 72a:	e16080e7          	jalr	-490(ra) # 53c <vprintf>
}
 72e:	60e2                	ld	ra,24(sp)
 730:	6442                	ld	s0,16(sp)
 732:	6161                	addi	sp,sp,80
 734:	8082                	ret

0000000000000736 <printf>:

void
printf(const char *fmt, ...)
{
 736:	711d                	addi	sp,sp,-96
 738:	ec06                	sd	ra,24(sp)
 73a:	e822                	sd	s0,16(sp)
 73c:	1000                	addi	s0,sp,32
 73e:	e40c                	sd	a1,8(s0)
 740:	e810                	sd	a2,16(s0)
 742:	ec14                	sd	a3,24(s0)
 744:	f018                	sd	a4,32(s0)
 746:	f41c                	sd	a5,40(s0)
 748:	03043823          	sd	a6,48(s0)
 74c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 750:	00840613          	addi	a2,s0,8
 754:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 758:	85aa                	mv	a1,a0
 75a:	4505                	li	a0,1
 75c:	00000097          	auipc	ra,0x0
 760:	de0080e7          	jalr	-544(ra) # 53c <vprintf>
}
 764:	60e2                	ld	ra,24(sp)
 766:	6442                	ld	s0,16(sp)
 768:	6125                	addi	sp,sp,96
 76a:	8082                	ret

000000000000076c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 76c:	1141                	addi	sp,sp,-16
 76e:	e422                	sd	s0,8(sp)
 770:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 772:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 776:	00001797          	auipc	a5,0x1
 77a:	c9a7b783          	ld	a5,-870(a5) # 1410 <freep>
 77e:	a02d                	j	7a8 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 780:	4618                	lw	a4,8(a2)
 782:	9f2d                	addw	a4,a4,a1
 784:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 788:	6398                	ld	a4,0(a5)
 78a:	6310                	ld	a2,0(a4)
 78c:	a83d                	j	7ca <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 78e:	ff852703          	lw	a4,-8(a0)
 792:	9f31                	addw	a4,a4,a2
 794:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 796:	ff053683          	ld	a3,-16(a0)
 79a:	a091                	j	7de <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79c:	6398                	ld	a4,0(a5)
 79e:	00e7e463          	bltu	a5,a4,7a6 <free+0x3a>
 7a2:	00e6ea63          	bltu	a3,a4,7b6 <free+0x4a>
{
 7a6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a8:	fed7fae3          	bgeu	a5,a3,79c <free+0x30>
 7ac:	6398                	ld	a4,0(a5)
 7ae:	00e6e463          	bltu	a3,a4,7b6 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b2:	fee7eae3          	bltu	a5,a4,7a6 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7b6:	ff852583          	lw	a1,-8(a0)
 7ba:	6390                	ld	a2,0(a5)
 7bc:	02059813          	slli	a6,a1,0x20
 7c0:	01c85713          	srli	a4,a6,0x1c
 7c4:	9736                	add	a4,a4,a3
 7c6:	fae60de3          	beq	a2,a4,780 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7ca:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7ce:	4790                	lw	a2,8(a5)
 7d0:	02061593          	slli	a1,a2,0x20
 7d4:	01c5d713          	srli	a4,a1,0x1c
 7d8:	973e                	add	a4,a4,a5
 7da:	fae68ae3          	beq	a3,a4,78e <free+0x22>
    p->s.ptr = bp->s.ptr;
 7de:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7e0:	00001717          	auipc	a4,0x1
 7e4:	c2f73823          	sd	a5,-976(a4) # 1410 <freep>
}
 7e8:	6422                	ld	s0,8(sp)
 7ea:	0141                	addi	sp,sp,16
 7ec:	8082                	ret

00000000000007ee <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7ee:	7139                	addi	sp,sp,-64
 7f0:	fc06                	sd	ra,56(sp)
 7f2:	f822                	sd	s0,48(sp)
 7f4:	f426                	sd	s1,40(sp)
 7f6:	ec4e                	sd	s3,24(sp)
 7f8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7fa:	02051493          	slli	s1,a0,0x20
 7fe:	9081                	srli	s1,s1,0x20
 800:	04bd                	addi	s1,s1,15
 802:	8091                	srli	s1,s1,0x4
 804:	0014899b          	addiw	s3,s1,1
 808:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 80a:	00001517          	auipc	a0,0x1
 80e:	c0653503          	ld	a0,-1018(a0) # 1410 <freep>
 812:	c915                	beqz	a0,846 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 814:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 816:	4798                	lw	a4,8(a5)
 818:	08977e63          	bgeu	a4,s1,8b4 <malloc+0xc6>
 81c:	f04a                	sd	s2,32(sp)
 81e:	e852                	sd	s4,16(sp)
 820:	e456                	sd	s5,8(sp)
 822:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 824:	8a4e                	mv	s4,s3
 826:	0009871b          	sext.w	a4,s3
 82a:	6685                	lui	a3,0x1
 82c:	00d77363          	bgeu	a4,a3,832 <malloc+0x44>
 830:	6a05                	lui	s4,0x1
 832:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 836:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 83a:	00001917          	auipc	s2,0x1
 83e:	bd690913          	addi	s2,s2,-1066 # 1410 <freep>
  if(p == (char*)-1)
 842:	5afd                	li	s5,-1
 844:	a091                	j	888 <malloc+0x9a>
 846:	f04a                	sd	s2,32(sp)
 848:	e852                	sd	s4,16(sp)
 84a:	e456                	sd	s5,8(sp)
 84c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 84e:	00001797          	auipc	a5,0x1
 852:	bd278793          	addi	a5,a5,-1070 # 1420 <base>
 856:	00001717          	auipc	a4,0x1
 85a:	baf73d23          	sd	a5,-1094(a4) # 1410 <freep>
 85e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 860:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 864:	b7c1                	j	824 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 866:	6398                	ld	a4,0(a5)
 868:	e118                	sd	a4,0(a0)
 86a:	a08d                	j	8cc <malloc+0xde>
  hp->s.size = nu;
 86c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 870:	0541                	addi	a0,a0,16
 872:	00000097          	auipc	ra,0x0
 876:	efa080e7          	jalr	-262(ra) # 76c <free>
  return freep;
 87a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 87e:	c13d                	beqz	a0,8e4 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 880:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 882:	4798                	lw	a4,8(a5)
 884:	02977463          	bgeu	a4,s1,8ac <malloc+0xbe>
    if(p == freep)
 888:	00093703          	ld	a4,0(s2)
 88c:	853e                	mv	a0,a5
 88e:	fef719e3          	bne	a4,a5,880 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 892:	8552                	mv	a0,s4
 894:	00000097          	auipc	ra,0x0
 898:	b9a080e7          	jalr	-1126(ra) # 42e <sbrk>
  if(p == (char*)-1)
 89c:	fd5518e3          	bne	a0,s5,86c <malloc+0x7e>
        return 0;
 8a0:	4501                	li	a0,0
 8a2:	7902                	ld	s2,32(sp)
 8a4:	6a42                	ld	s4,16(sp)
 8a6:	6aa2                	ld	s5,8(sp)
 8a8:	6b02                	ld	s6,0(sp)
 8aa:	a03d                	j	8d8 <malloc+0xea>
 8ac:	7902                	ld	s2,32(sp)
 8ae:	6a42                	ld	s4,16(sp)
 8b0:	6aa2                	ld	s5,8(sp)
 8b2:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8b4:	fae489e3          	beq	s1,a4,866 <malloc+0x78>
        p->s.size -= nunits;
 8b8:	4137073b          	subw	a4,a4,s3
 8bc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8be:	02071693          	slli	a3,a4,0x20
 8c2:	01c6d713          	srli	a4,a3,0x1c
 8c6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8c8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8cc:	00001717          	auipc	a4,0x1
 8d0:	b4a73223          	sd	a0,-1212(a4) # 1410 <freep>
      return (void*)(p + 1);
 8d4:	01078513          	addi	a0,a5,16
  }
}
 8d8:	70e2                	ld	ra,56(sp)
 8da:	7442                	ld	s0,48(sp)
 8dc:	74a2                	ld	s1,40(sp)
 8de:	69e2                	ld	s3,24(sp)
 8e0:	6121                	addi	sp,sp,64
 8e2:	8082                	ret
 8e4:	7902                	ld	s2,32(sp)
 8e6:	6a42                	ld	s4,16(sp)
 8e8:	6aa2                	ld	s5,8(sp)
 8ea:	6b02                	ld	s6,0(sp)
 8ec:	b7f5                	j	8d8 <malloc+0xea>
