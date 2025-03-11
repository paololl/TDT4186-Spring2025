
user/_hello:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
*/


#include "user.h"

int main(int argc, char *argv[]) {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
   8:	87aa                	mv	a5,a0
   a:	feb43023          	sd	a1,-32(s0)
   e:	fef42623          	sw	a5,-20(s0)
    if (argc == 1) {
  12:	fec42783          	lw	a5,-20(s0)
  16:	0007871b          	sext.w	a4,a5
  1a:	4785                	li	a5,1
  1c:	00f71b63          	bne	a4,a5,32 <main+0x32>
        printf("Hello World\n");
  20:	00001517          	auipc	a0,0x1
  24:	d4050513          	addi	a0,a0,-704 # d60 <malloc+0x13c>
  28:	00001097          	auipc	ra,0x1
  2c:	a0a080e7          	jalr	-1526(ra) # a32 <printf>
  30:	a831                	j	4c <main+0x4c>
    } else {
        printf("Hello %s, nice to meet you!\n", argv[1]);
  32:	fe043783          	ld	a5,-32(s0)
  36:	07a1                	addi	a5,a5,8
  38:	639c                	ld	a5,0(a5)
  3a:	85be                	mv	a1,a5
  3c:	00001517          	auipc	a0,0x1
  40:	d3450513          	addi	a0,a0,-716 # d70 <malloc+0x14c>
  44:	00001097          	auipc	ra,0x1
  48:	9ee080e7          	jalr	-1554(ra) # a32 <printf>
    }
    exit(0);
  4c:	4501                	li	a0,0
  4e:	00000097          	auipc	ra,0x0
  52:	4b4080e7          	jalr	1204(ra) # 502 <exit>

0000000000000056 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  56:	1141                	addi	sp,sp,-16
  58:	e406                	sd	ra,8(sp)
  5a:	e022                	sd	s0,0(sp)
  5c:	0800                	addi	s0,sp,16
  extern int main();
  main();
  5e:	00000097          	auipc	ra,0x0
  62:	fa2080e7          	jalr	-94(ra) # 0 <main>
  exit(0);
  66:	4501                	li	a0,0
  68:	00000097          	auipc	ra,0x0
  6c:	49a080e7          	jalr	1178(ra) # 502 <exit>

0000000000000070 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  70:	7179                	addi	sp,sp,-48
  72:	f422                	sd	s0,40(sp)
  74:	1800                	addi	s0,sp,48
  76:	fca43c23          	sd	a0,-40(s0)
  7a:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
  7e:	fd843783          	ld	a5,-40(s0)
  82:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
  86:	0001                	nop
  88:	fd043703          	ld	a4,-48(s0)
  8c:	00170793          	addi	a5,a4,1
  90:	fcf43823          	sd	a5,-48(s0)
  94:	fd843783          	ld	a5,-40(s0)
  98:	00178693          	addi	a3,a5,1
  9c:	fcd43c23          	sd	a3,-40(s0)
  a0:	00074703          	lbu	a4,0(a4)
  a4:	00e78023          	sb	a4,0(a5)
  a8:	0007c783          	lbu	a5,0(a5)
  ac:	fff1                	bnez	a5,88 <strcpy+0x18>
    ;
  return os;
  ae:	fe843783          	ld	a5,-24(s0)
}
  b2:	853e                	mv	a0,a5
  b4:	7422                	ld	s0,40(sp)
  b6:	6145                	addi	sp,sp,48
  b8:	8082                	ret

00000000000000ba <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ba:	1101                	addi	sp,sp,-32
  bc:	ec22                	sd	s0,24(sp)
  be:	1000                	addi	s0,sp,32
  c0:	fea43423          	sd	a0,-24(s0)
  c4:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
  c8:	a819                	j	de <strcmp+0x24>
    p++, q++;
  ca:	fe843783          	ld	a5,-24(s0)
  ce:	0785                	addi	a5,a5,1
  d0:	fef43423          	sd	a5,-24(s0)
  d4:	fe043783          	ld	a5,-32(s0)
  d8:	0785                	addi	a5,a5,1
  da:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
  de:	fe843783          	ld	a5,-24(s0)
  e2:	0007c783          	lbu	a5,0(a5)
  e6:	cb99                	beqz	a5,fc <strcmp+0x42>
  e8:	fe843783          	ld	a5,-24(s0)
  ec:	0007c703          	lbu	a4,0(a5)
  f0:	fe043783          	ld	a5,-32(s0)
  f4:	0007c783          	lbu	a5,0(a5)
  f8:	fcf709e3          	beq	a4,a5,ca <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
  fc:	fe843783          	ld	a5,-24(s0)
 100:	0007c783          	lbu	a5,0(a5)
 104:	0007871b          	sext.w	a4,a5
 108:	fe043783          	ld	a5,-32(s0)
 10c:	0007c783          	lbu	a5,0(a5)
 110:	2781                	sext.w	a5,a5
 112:	40f707bb          	subw	a5,a4,a5
 116:	2781                	sext.w	a5,a5
}
 118:	853e                	mv	a0,a5
 11a:	6462                	ld	s0,24(sp)
 11c:	6105                	addi	sp,sp,32
 11e:	8082                	ret

0000000000000120 <strlen>:

uint
strlen(const char *s)
{
 120:	7179                	addi	sp,sp,-48
 122:	f422                	sd	s0,40(sp)
 124:	1800                	addi	s0,sp,48
 126:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
 12a:	fe042623          	sw	zero,-20(s0)
 12e:	a031                	j	13a <strlen+0x1a>
 130:	fec42783          	lw	a5,-20(s0)
 134:	2785                	addiw	a5,a5,1
 136:	fef42623          	sw	a5,-20(s0)
 13a:	fec42783          	lw	a5,-20(s0)
 13e:	fd843703          	ld	a4,-40(s0)
 142:	97ba                	add	a5,a5,a4
 144:	0007c783          	lbu	a5,0(a5)
 148:	f7e5                	bnez	a5,130 <strlen+0x10>
    ;
  return n;
 14a:	fec42783          	lw	a5,-20(s0)
}
 14e:	853e                	mv	a0,a5
 150:	7422                	ld	s0,40(sp)
 152:	6145                	addi	sp,sp,48
 154:	8082                	ret

0000000000000156 <memset>:

void*
memset(void *dst, int c, uint n)
{
 156:	7179                	addi	sp,sp,-48
 158:	f422                	sd	s0,40(sp)
 15a:	1800                	addi	s0,sp,48
 15c:	fca43c23          	sd	a0,-40(s0)
 160:	87ae                	mv	a5,a1
 162:	8732                	mv	a4,a2
 164:	fcf42a23          	sw	a5,-44(s0)
 168:	87ba                	mv	a5,a4
 16a:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
 16e:	fd843783          	ld	a5,-40(s0)
 172:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
 176:	fe042623          	sw	zero,-20(s0)
 17a:	a00d                	j	19c <memset+0x46>
    cdst[i] = c;
 17c:	fec42783          	lw	a5,-20(s0)
 180:	fe043703          	ld	a4,-32(s0)
 184:	97ba                	add	a5,a5,a4
 186:	fd442703          	lw	a4,-44(s0)
 18a:	0ff77713          	zext.b	a4,a4
 18e:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
 192:	fec42783          	lw	a5,-20(s0)
 196:	2785                	addiw	a5,a5,1
 198:	fef42623          	sw	a5,-20(s0)
 19c:	fec42703          	lw	a4,-20(s0)
 1a0:	fd042783          	lw	a5,-48(s0)
 1a4:	2781                	sext.w	a5,a5
 1a6:	fcf76be3          	bltu	a4,a5,17c <memset+0x26>
  }
  return dst;
 1aa:	fd843783          	ld	a5,-40(s0)
}
 1ae:	853e                	mv	a0,a5
 1b0:	7422                	ld	s0,40(sp)
 1b2:	6145                	addi	sp,sp,48
 1b4:	8082                	ret

00000000000001b6 <strchr>:

char*
strchr(const char *s, char c)
{
 1b6:	1101                	addi	sp,sp,-32
 1b8:	ec22                	sd	s0,24(sp)
 1ba:	1000                	addi	s0,sp,32
 1bc:	fea43423          	sd	a0,-24(s0)
 1c0:	87ae                	mv	a5,a1
 1c2:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
 1c6:	a01d                	j	1ec <strchr+0x36>
    if(*s == c)
 1c8:	fe843783          	ld	a5,-24(s0)
 1cc:	0007c703          	lbu	a4,0(a5)
 1d0:	fe744783          	lbu	a5,-25(s0)
 1d4:	0ff7f793          	zext.b	a5,a5
 1d8:	00e79563          	bne	a5,a4,1e2 <strchr+0x2c>
      return (char*)s;
 1dc:	fe843783          	ld	a5,-24(s0)
 1e0:	a821                	j	1f8 <strchr+0x42>
  for(; *s; s++)
 1e2:	fe843783          	ld	a5,-24(s0)
 1e6:	0785                	addi	a5,a5,1
 1e8:	fef43423          	sd	a5,-24(s0)
 1ec:	fe843783          	ld	a5,-24(s0)
 1f0:	0007c783          	lbu	a5,0(a5)
 1f4:	fbf1                	bnez	a5,1c8 <strchr+0x12>
  return 0;
 1f6:	4781                	li	a5,0
}
 1f8:	853e                	mv	a0,a5
 1fa:	6462                	ld	s0,24(sp)
 1fc:	6105                	addi	sp,sp,32
 1fe:	8082                	ret

0000000000000200 <gets>:

char*
gets(char *buf, int max)
{
 200:	7179                	addi	sp,sp,-48
 202:	f406                	sd	ra,40(sp)
 204:	f022                	sd	s0,32(sp)
 206:	1800                	addi	s0,sp,48
 208:	fca43c23          	sd	a0,-40(s0)
 20c:	87ae                	mv	a5,a1
 20e:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 212:	fe042623          	sw	zero,-20(s0)
 216:	a8a1                	j	26e <gets+0x6e>
    cc = read(0, &c, 1);
 218:	fe740793          	addi	a5,s0,-25
 21c:	4605                	li	a2,1
 21e:	85be                	mv	a1,a5
 220:	4501                	li	a0,0
 222:	00000097          	auipc	ra,0x0
 226:	2f8080e7          	jalr	760(ra) # 51a <read>
 22a:	87aa                	mv	a5,a0
 22c:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
 230:	fe842783          	lw	a5,-24(s0)
 234:	2781                	sext.w	a5,a5
 236:	04f05763          	blez	a5,284 <gets+0x84>
      break;
    buf[i++] = c;
 23a:	fec42783          	lw	a5,-20(s0)
 23e:	0017871b          	addiw	a4,a5,1
 242:	fee42623          	sw	a4,-20(s0)
 246:	873e                	mv	a4,a5
 248:	fd843783          	ld	a5,-40(s0)
 24c:	97ba                	add	a5,a5,a4
 24e:	fe744703          	lbu	a4,-25(s0)
 252:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
 256:	fe744783          	lbu	a5,-25(s0)
 25a:	873e                	mv	a4,a5
 25c:	47a9                	li	a5,10
 25e:	02f70463          	beq	a4,a5,286 <gets+0x86>
 262:	fe744783          	lbu	a5,-25(s0)
 266:	873e                	mv	a4,a5
 268:	47b5                	li	a5,13
 26a:	00f70e63          	beq	a4,a5,286 <gets+0x86>
  for(i=0; i+1 < max; ){
 26e:	fec42783          	lw	a5,-20(s0)
 272:	2785                	addiw	a5,a5,1
 274:	0007871b          	sext.w	a4,a5
 278:	fd442783          	lw	a5,-44(s0)
 27c:	2781                	sext.w	a5,a5
 27e:	f8f74de3          	blt	a4,a5,218 <gets+0x18>
 282:	a011                	j	286 <gets+0x86>
      break;
 284:	0001                	nop
      break;
  }
  buf[i] = '\0';
 286:	fec42783          	lw	a5,-20(s0)
 28a:	fd843703          	ld	a4,-40(s0)
 28e:	97ba                	add	a5,a5,a4
 290:	00078023          	sb	zero,0(a5)
  return buf;
 294:	fd843783          	ld	a5,-40(s0)
}
 298:	853e                	mv	a0,a5
 29a:	70a2                	ld	ra,40(sp)
 29c:	7402                	ld	s0,32(sp)
 29e:	6145                	addi	sp,sp,48
 2a0:	8082                	ret

00000000000002a2 <stat>:

int
stat(const char *n, struct stat *st)
{
 2a2:	7179                	addi	sp,sp,-48
 2a4:	f406                	sd	ra,40(sp)
 2a6:	f022                	sd	s0,32(sp)
 2a8:	1800                	addi	s0,sp,48
 2aa:	fca43c23          	sd	a0,-40(s0)
 2ae:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2b2:	4581                	li	a1,0
 2b4:	fd843503          	ld	a0,-40(s0)
 2b8:	00000097          	auipc	ra,0x0
 2bc:	28a080e7          	jalr	650(ra) # 542 <open>
 2c0:	87aa                	mv	a5,a0
 2c2:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
 2c6:	fec42783          	lw	a5,-20(s0)
 2ca:	2781                	sext.w	a5,a5
 2cc:	0007d463          	bgez	a5,2d4 <stat+0x32>
    return -1;
 2d0:	57fd                	li	a5,-1
 2d2:	a035                	j	2fe <stat+0x5c>
  r = fstat(fd, st);
 2d4:	fec42783          	lw	a5,-20(s0)
 2d8:	fd043583          	ld	a1,-48(s0)
 2dc:	853e                	mv	a0,a5
 2de:	00000097          	auipc	ra,0x0
 2e2:	27c080e7          	jalr	636(ra) # 55a <fstat>
 2e6:	87aa                	mv	a5,a0
 2e8:	fef42423          	sw	a5,-24(s0)
  close(fd);
 2ec:	fec42783          	lw	a5,-20(s0)
 2f0:	853e                	mv	a0,a5
 2f2:	00000097          	auipc	ra,0x0
 2f6:	238080e7          	jalr	568(ra) # 52a <close>
  return r;
 2fa:	fe842783          	lw	a5,-24(s0)
}
 2fe:	853e                	mv	a0,a5
 300:	70a2                	ld	ra,40(sp)
 302:	7402                	ld	s0,32(sp)
 304:	6145                	addi	sp,sp,48
 306:	8082                	ret

0000000000000308 <atoi>:

int
atoi(const char *s)
{
 308:	7179                	addi	sp,sp,-48
 30a:	f422                	sd	s0,40(sp)
 30c:	1800                	addi	s0,sp,48
 30e:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
 312:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
 316:	a81d                	j	34c <atoi+0x44>
    n = n*10 + *s++ - '0';
 318:	fec42783          	lw	a5,-20(s0)
 31c:	873e                	mv	a4,a5
 31e:	87ba                	mv	a5,a4
 320:	0027979b          	slliw	a5,a5,0x2
 324:	9fb9                	addw	a5,a5,a4
 326:	0017979b          	slliw	a5,a5,0x1
 32a:	0007871b          	sext.w	a4,a5
 32e:	fd843783          	ld	a5,-40(s0)
 332:	00178693          	addi	a3,a5,1
 336:	fcd43c23          	sd	a3,-40(s0)
 33a:	0007c783          	lbu	a5,0(a5)
 33e:	2781                	sext.w	a5,a5
 340:	9fb9                	addw	a5,a5,a4
 342:	2781                	sext.w	a5,a5
 344:	fd07879b          	addiw	a5,a5,-48
 348:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
 34c:	fd843783          	ld	a5,-40(s0)
 350:	0007c783          	lbu	a5,0(a5)
 354:	873e                	mv	a4,a5
 356:	02f00793          	li	a5,47
 35a:	00e7fb63          	bgeu	a5,a4,370 <atoi+0x68>
 35e:	fd843783          	ld	a5,-40(s0)
 362:	0007c783          	lbu	a5,0(a5)
 366:	873e                	mv	a4,a5
 368:	03900793          	li	a5,57
 36c:	fae7f6e3          	bgeu	a5,a4,318 <atoi+0x10>
  return n;
 370:	fec42783          	lw	a5,-20(s0)
}
 374:	853e                	mv	a0,a5
 376:	7422                	ld	s0,40(sp)
 378:	6145                	addi	sp,sp,48
 37a:	8082                	ret

000000000000037c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 37c:	7139                	addi	sp,sp,-64
 37e:	fc22                	sd	s0,56(sp)
 380:	0080                	addi	s0,sp,64
 382:	fca43c23          	sd	a0,-40(s0)
 386:	fcb43823          	sd	a1,-48(s0)
 38a:	87b2                	mv	a5,a2
 38c:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
 390:	fd843783          	ld	a5,-40(s0)
 394:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
 398:	fd043783          	ld	a5,-48(s0)
 39c:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
 3a0:	fe043703          	ld	a4,-32(s0)
 3a4:	fe843783          	ld	a5,-24(s0)
 3a8:	02e7fc63          	bgeu	a5,a4,3e0 <memmove+0x64>
    while(n-- > 0)
 3ac:	a00d                	j	3ce <memmove+0x52>
      *dst++ = *src++;
 3ae:	fe043703          	ld	a4,-32(s0)
 3b2:	00170793          	addi	a5,a4,1
 3b6:	fef43023          	sd	a5,-32(s0)
 3ba:	fe843783          	ld	a5,-24(s0)
 3be:	00178693          	addi	a3,a5,1
 3c2:	fed43423          	sd	a3,-24(s0)
 3c6:	00074703          	lbu	a4,0(a4)
 3ca:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 3ce:	fcc42783          	lw	a5,-52(s0)
 3d2:	fff7871b          	addiw	a4,a5,-1
 3d6:	fce42623          	sw	a4,-52(s0)
 3da:	fcf04ae3          	bgtz	a5,3ae <memmove+0x32>
 3de:	a891                	j	432 <memmove+0xb6>
  } else {
    dst += n;
 3e0:	fcc42783          	lw	a5,-52(s0)
 3e4:	fe843703          	ld	a4,-24(s0)
 3e8:	97ba                	add	a5,a5,a4
 3ea:	fef43423          	sd	a5,-24(s0)
    src += n;
 3ee:	fcc42783          	lw	a5,-52(s0)
 3f2:	fe043703          	ld	a4,-32(s0)
 3f6:	97ba                	add	a5,a5,a4
 3f8:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
 3fc:	a01d                	j	422 <memmove+0xa6>
      *--dst = *--src;
 3fe:	fe043783          	ld	a5,-32(s0)
 402:	17fd                	addi	a5,a5,-1
 404:	fef43023          	sd	a5,-32(s0)
 408:	fe843783          	ld	a5,-24(s0)
 40c:	17fd                	addi	a5,a5,-1
 40e:	fef43423          	sd	a5,-24(s0)
 412:	fe043783          	ld	a5,-32(s0)
 416:	0007c703          	lbu	a4,0(a5)
 41a:	fe843783          	ld	a5,-24(s0)
 41e:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 422:	fcc42783          	lw	a5,-52(s0)
 426:	fff7871b          	addiw	a4,a5,-1
 42a:	fce42623          	sw	a4,-52(s0)
 42e:	fcf048e3          	bgtz	a5,3fe <memmove+0x82>
  }
  return vdst;
 432:	fd843783          	ld	a5,-40(s0)
}
 436:	853e                	mv	a0,a5
 438:	7462                	ld	s0,56(sp)
 43a:	6121                	addi	sp,sp,64
 43c:	8082                	ret

000000000000043e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 43e:	7139                	addi	sp,sp,-64
 440:	fc22                	sd	s0,56(sp)
 442:	0080                	addi	s0,sp,64
 444:	fca43c23          	sd	a0,-40(s0)
 448:	fcb43823          	sd	a1,-48(s0)
 44c:	87b2                	mv	a5,a2
 44e:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
 452:	fd843783          	ld	a5,-40(s0)
 456:	fef43423          	sd	a5,-24(s0)
 45a:	fd043783          	ld	a5,-48(s0)
 45e:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 462:	a0a1                	j	4aa <memcmp+0x6c>
    if (*p1 != *p2) {
 464:	fe843783          	ld	a5,-24(s0)
 468:	0007c703          	lbu	a4,0(a5)
 46c:	fe043783          	ld	a5,-32(s0)
 470:	0007c783          	lbu	a5,0(a5)
 474:	02f70163          	beq	a4,a5,496 <memcmp+0x58>
      return *p1 - *p2;
 478:	fe843783          	ld	a5,-24(s0)
 47c:	0007c783          	lbu	a5,0(a5)
 480:	0007871b          	sext.w	a4,a5
 484:	fe043783          	ld	a5,-32(s0)
 488:	0007c783          	lbu	a5,0(a5)
 48c:	2781                	sext.w	a5,a5
 48e:	40f707bb          	subw	a5,a4,a5
 492:	2781                	sext.w	a5,a5
 494:	a01d                	j	4ba <memcmp+0x7c>
    }
    p1++;
 496:	fe843783          	ld	a5,-24(s0)
 49a:	0785                	addi	a5,a5,1
 49c:	fef43423          	sd	a5,-24(s0)
    p2++;
 4a0:	fe043783          	ld	a5,-32(s0)
 4a4:	0785                	addi	a5,a5,1
 4a6:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 4aa:	fcc42783          	lw	a5,-52(s0)
 4ae:	fff7871b          	addiw	a4,a5,-1
 4b2:	fce42623          	sw	a4,-52(s0)
 4b6:	f7dd                	bnez	a5,464 <memcmp+0x26>
  }
  return 0;
 4b8:	4781                	li	a5,0
}
 4ba:	853e                	mv	a0,a5
 4bc:	7462                	ld	s0,56(sp)
 4be:	6121                	addi	sp,sp,64
 4c0:	8082                	ret

00000000000004c2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4c2:	7179                	addi	sp,sp,-48
 4c4:	f406                	sd	ra,40(sp)
 4c6:	f022                	sd	s0,32(sp)
 4c8:	1800                	addi	s0,sp,48
 4ca:	fea43423          	sd	a0,-24(s0)
 4ce:	feb43023          	sd	a1,-32(s0)
 4d2:	87b2                	mv	a5,a2
 4d4:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
 4d8:	fdc42783          	lw	a5,-36(s0)
 4dc:	863e                	mv	a2,a5
 4de:	fe043583          	ld	a1,-32(s0)
 4e2:	fe843503          	ld	a0,-24(s0)
 4e6:	00000097          	auipc	ra,0x0
 4ea:	e96080e7          	jalr	-362(ra) # 37c <memmove>
 4ee:	87aa                	mv	a5,a0
}
 4f0:	853e                	mv	a0,a5
 4f2:	70a2                	ld	ra,40(sp)
 4f4:	7402                	ld	s0,32(sp)
 4f6:	6145                	addi	sp,sp,48
 4f8:	8082                	ret

00000000000004fa <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4fa:	4885                	li	a7,1
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <exit>:
.global exit
exit:
 li a7, SYS_exit
 502:	4889                	li	a7,2
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <wait>:
.global wait
wait:
 li a7, SYS_wait
 50a:	488d                	li	a7,3
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 512:	4891                	li	a7,4
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <read>:
.global read
read:
 li a7, SYS_read
 51a:	4895                	li	a7,5
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <write>:
.global write
write:
 li a7, SYS_write
 522:	48c1                	li	a7,16
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <close>:
.global close
close:
 li a7, SYS_close
 52a:	48d5                	li	a7,21
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <kill>:
.global kill
kill:
 li a7, SYS_kill
 532:	4899                	li	a7,6
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <exec>:
.global exec
exec:
 li a7, SYS_exec
 53a:	489d                	li	a7,7
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <open>:
.global open
open:
 li a7, SYS_open
 542:	48bd                	li	a7,15
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 54a:	48c5                	li	a7,17
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 552:	48c9                	li	a7,18
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 55a:	48a1                	li	a7,8
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <link>:
.global link
link:
 li a7, SYS_link
 562:	48cd                	li	a7,19
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 56a:	48d1                	li	a7,20
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 572:	48a5                	li	a7,9
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <dup>:
.global dup
dup:
 li a7, SYS_dup
 57a:	48a9                	li	a7,10
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 582:	48ad                	li	a7,11
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 58a:	48b1                	li	a7,12
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 592:	48b5                	li	a7,13
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 59a:	48b9                	li	a7,14
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <getprocesses>:
.global getprocesses
getprocesses:
 li a7, SYS_getprocesses
 5a2:	48d9                	li	a7,22
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5aa:	1101                	addi	sp,sp,-32
 5ac:	ec06                	sd	ra,24(sp)
 5ae:	e822                	sd	s0,16(sp)
 5b0:	1000                	addi	s0,sp,32
 5b2:	87aa                	mv	a5,a0
 5b4:	872e                	mv	a4,a1
 5b6:	fef42623          	sw	a5,-20(s0)
 5ba:	87ba                	mv	a5,a4
 5bc:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 5c0:	feb40713          	addi	a4,s0,-21
 5c4:	fec42783          	lw	a5,-20(s0)
 5c8:	4605                	li	a2,1
 5ca:	85ba                	mv	a1,a4
 5cc:	853e                	mv	a0,a5
 5ce:	00000097          	auipc	ra,0x0
 5d2:	f54080e7          	jalr	-172(ra) # 522 <write>
}
 5d6:	0001                	nop
 5d8:	60e2                	ld	ra,24(sp)
 5da:	6442                	ld	s0,16(sp)
 5dc:	6105                	addi	sp,sp,32
 5de:	8082                	ret

00000000000005e0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5e0:	7139                	addi	sp,sp,-64
 5e2:	fc06                	sd	ra,56(sp)
 5e4:	f822                	sd	s0,48(sp)
 5e6:	0080                	addi	s0,sp,64
 5e8:	87aa                	mv	a5,a0
 5ea:	8736                	mv	a4,a3
 5ec:	fcf42623          	sw	a5,-52(s0)
 5f0:	87ae                	mv	a5,a1
 5f2:	fcf42423          	sw	a5,-56(s0)
 5f6:	87b2                	mv	a5,a2
 5f8:	fcf42223          	sw	a5,-60(s0)
 5fc:	87ba                	mv	a5,a4
 5fe:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 602:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 606:	fc042783          	lw	a5,-64(s0)
 60a:	2781                	sext.w	a5,a5
 60c:	c38d                	beqz	a5,62e <printint+0x4e>
 60e:	fc842783          	lw	a5,-56(s0)
 612:	2781                	sext.w	a5,a5
 614:	0007dd63          	bgez	a5,62e <printint+0x4e>
    neg = 1;
 618:	4785                	li	a5,1
 61a:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 61e:	fc842783          	lw	a5,-56(s0)
 622:	40f007bb          	negw	a5,a5
 626:	2781                	sext.w	a5,a5
 628:	fef42223          	sw	a5,-28(s0)
 62c:	a029                	j	636 <printint+0x56>
  } else {
    x = xx;
 62e:	fc842783          	lw	a5,-56(s0)
 632:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 636:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 63a:	fc442783          	lw	a5,-60(s0)
 63e:	fe442703          	lw	a4,-28(s0)
 642:	02f777bb          	remuw	a5,a4,a5
 646:	0007861b          	sext.w	a2,a5
 64a:	fec42783          	lw	a5,-20(s0)
 64e:	0017871b          	addiw	a4,a5,1
 652:	fee42623          	sw	a4,-20(s0)
 656:	00001697          	auipc	a3,0x1
 65a:	d1a68693          	addi	a3,a3,-742 # 1370 <digits>
 65e:	02061713          	slli	a4,a2,0x20
 662:	9301                	srli	a4,a4,0x20
 664:	9736                	add	a4,a4,a3
 666:	00074703          	lbu	a4,0(a4)
 66a:	17c1                	addi	a5,a5,-16
 66c:	97a2                	add	a5,a5,s0
 66e:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 672:	fc442783          	lw	a5,-60(s0)
 676:	fe442703          	lw	a4,-28(s0)
 67a:	02f757bb          	divuw	a5,a4,a5
 67e:	fef42223          	sw	a5,-28(s0)
 682:	fe442783          	lw	a5,-28(s0)
 686:	2781                	sext.w	a5,a5
 688:	fbcd                	bnez	a5,63a <printint+0x5a>
  if(neg)
 68a:	fe842783          	lw	a5,-24(s0)
 68e:	2781                	sext.w	a5,a5
 690:	cf85                	beqz	a5,6c8 <printint+0xe8>
    buf[i++] = '-';
 692:	fec42783          	lw	a5,-20(s0)
 696:	0017871b          	addiw	a4,a5,1
 69a:	fee42623          	sw	a4,-20(s0)
 69e:	17c1                	addi	a5,a5,-16
 6a0:	97a2                	add	a5,a5,s0
 6a2:	02d00713          	li	a4,45
 6a6:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 6aa:	a839                	j	6c8 <printint+0xe8>
    putc(fd, buf[i]);
 6ac:	fec42783          	lw	a5,-20(s0)
 6b0:	17c1                	addi	a5,a5,-16
 6b2:	97a2                	add	a5,a5,s0
 6b4:	fe07c703          	lbu	a4,-32(a5)
 6b8:	fcc42783          	lw	a5,-52(s0)
 6bc:	85ba                	mv	a1,a4
 6be:	853e                	mv	a0,a5
 6c0:	00000097          	auipc	ra,0x0
 6c4:	eea080e7          	jalr	-278(ra) # 5aa <putc>
  while(--i >= 0)
 6c8:	fec42783          	lw	a5,-20(s0)
 6cc:	37fd                	addiw	a5,a5,-1
 6ce:	fef42623          	sw	a5,-20(s0)
 6d2:	fec42783          	lw	a5,-20(s0)
 6d6:	2781                	sext.w	a5,a5
 6d8:	fc07dae3          	bgez	a5,6ac <printint+0xcc>
}
 6dc:	0001                	nop
 6de:	0001                	nop
 6e0:	70e2                	ld	ra,56(sp)
 6e2:	7442                	ld	s0,48(sp)
 6e4:	6121                	addi	sp,sp,64
 6e6:	8082                	ret

00000000000006e8 <printptr>:

static void
printptr(int fd, uint64 x) {
 6e8:	7179                	addi	sp,sp,-48
 6ea:	f406                	sd	ra,40(sp)
 6ec:	f022                	sd	s0,32(sp)
 6ee:	1800                	addi	s0,sp,48
 6f0:	87aa                	mv	a5,a0
 6f2:	fcb43823          	sd	a1,-48(s0)
 6f6:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 6fa:	fdc42783          	lw	a5,-36(s0)
 6fe:	03000593          	li	a1,48
 702:	853e                	mv	a0,a5
 704:	00000097          	auipc	ra,0x0
 708:	ea6080e7          	jalr	-346(ra) # 5aa <putc>
  putc(fd, 'x');
 70c:	fdc42783          	lw	a5,-36(s0)
 710:	07800593          	li	a1,120
 714:	853e                	mv	a0,a5
 716:	00000097          	auipc	ra,0x0
 71a:	e94080e7          	jalr	-364(ra) # 5aa <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 71e:	fe042623          	sw	zero,-20(s0)
 722:	a82d                	j	75c <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 724:	fd043783          	ld	a5,-48(s0)
 728:	93f1                	srli	a5,a5,0x3c
 72a:	00001717          	auipc	a4,0x1
 72e:	c4670713          	addi	a4,a4,-954 # 1370 <digits>
 732:	97ba                	add	a5,a5,a4
 734:	0007c703          	lbu	a4,0(a5)
 738:	fdc42783          	lw	a5,-36(s0)
 73c:	85ba                	mv	a1,a4
 73e:	853e                	mv	a0,a5
 740:	00000097          	auipc	ra,0x0
 744:	e6a080e7          	jalr	-406(ra) # 5aa <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 748:	fec42783          	lw	a5,-20(s0)
 74c:	2785                	addiw	a5,a5,1
 74e:	fef42623          	sw	a5,-20(s0)
 752:	fd043783          	ld	a5,-48(s0)
 756:	0792                	slli	a5,a5,0x4
 758:	fcf43823          	sd	a5,-48(s0)
 75c:	fec42783          	lw	a5,-20(s0)
 760:	873e                	mv	a4,a5
 762:	47bd                	li	a5,15
 764:	fce7f0e3          	bgeu	a5,a4,724 <printptr+0x3c>
}
 768:	0001                	nop
 76a:	0001                	nop
 76c:	70a2                	ld	ra,40(sp)
 76e:	7402                	ld	s0,32(sp)
 770:	6145                	addi	sp,sp,48
 772:	8082                	ret

0000000000000774 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 774:	715d                	addi	sp,sp,-80
 776:	e486                	sd	ra,72(sp)
 778:	e0a2                	sd	s0,64(sp)
 77a:	0880                	addi	s0,sp,80
 77c:	87aa                	mv	a5,a0
 77e:	fcb43023          	sd	a1,-64(s0)
 782:	fac43c23          	sd	a2,-72(s0)
 786:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 78a:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 78e:	fe042223          	sw	zero,-28(s0)
 792:	a42d                	j	9bc <vprintf+0x248>
    c = fmt[i] & 0xff;
 794:	fe442783          	lw	a5,-28(s0)
 798:	fc043703          	ld	a4,-64(s0)
 79c:	97ba                	add	a5,a5,a4
 79e:	0007c783          	lbu	a5,0(a5)
 7a2:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 7a6:	fe042783          	lw	a5,-32(s0)
 7aa:	2781                	sext.w	a5,a5
 7ac:	eb9d                	bnez	a5,7e2 <vprintf+0x6e>
      if(c == '%'){
 7ae:	fdc42783          	lw	a5,-36(s0)
 7b2:	0007871b          	sext.w	a4,a5
 7b6:	02500793          	li	a5,37
 7ba:	00f71763          	bne	a4,a5,7c8 <vprintf+0x54>
        state = '%';
 7be:	02500793          	li	a5,37
 7c2:	fef42023          	sw	a5,-32(s0)
 7c6:	a2f5                	j	9b2 <vprintf+0x23e>
      } else {
        putc(fd, c);
 7c8:	fdc42783          	lw	a5,-36(s0)
 7cc:	0ff7f713          	zext.b	a4,a5
 7d0:	fcc42783          	lw	a5,-52(s0)
 7d4:	85ba                	mv	a1,a4
 7d6:	853e                	mv	a0,a5
 7d8:	00000097          	auipc	ra,0x0
 7dc:	dd2080e7          	jalr	-558(ra) # 5aa <putc>
 7e0:	aac9                	j	9b2 <vprintf+0x23e>
      }
    } else if(state == '%'){
 7e2:	fe042783          	lw	a5,-32(s0)
 7e6:	0007871b          	sext.w	a4,a5
 7ea:	02500793          	li	a5,37
 7ee:	1cf71263          	bne	a4,a5,9b2 <vprintf+0x23e>
      if(c == 'd'){
 7f2:	fdc42783          	lw	a5,-36(s0)
 7f6:	0007871b          	sext.w	a4,a5
 7fa:	06400793          	li	a5,100
 7fe:	02f71463          	bne	a4,a5,826 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 802:	fb843783          	ld	a5,-72(s0)
 806:	00878713          	addi	a4,a5,8
 80a:	fae43c23          	sd	a4,-72(s0)
 80e:	4398                	lw	a4,0(a5)
 810:	fcc42783          	lw	a5,-52(s0)
 814:	4685                	li	a3,1
 816:	4629                	li	a2,10
 818:	85ba                	mv	a1,a4
 81a:	853e                	mv	a0,a5
 81c:	00000097          	auipc	ra,0x0
 820:	dc4080e7          	jalr	-572(ra) # 5e0 <printint>
 824:	a269                	j	9ae <vprintf+0x23a>
      } else if(c == 'l') {
 826:	fdc42783          	lw	a5,-36(s0)
 82a:	0007871b          	sext.w	a4,a5
 82e:	06c00793          	li	a5,108
 832:	02f71663          	bne	a4,a5,85e <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 836:	fb843783          	ld	a5,-72(s0)
 83a:	00878713          	addi	a4,a5,8
 83e:	fae43c23          	sd	a4,-72(s0)
 842:	639c                	ld	a5,0(a5)
 844:	0007871b          	sext.w	a4,a5
 848:	fcc42783          	lw	a5,-52(s0)
 84c:	4681                	li	a3,0
 84e:	4629                	li	a2,10
 850:	85ba                	mv	a1,a4
 852:	853e                	mv	a0,a5
 854:	00000097          	auipc	ra,0x0
 858:	d8c080e7          	jalr	-628(ra) # 5e0 <printint>
 85c:	aa89                	j	9ae <vprintf+0x23a>
      } else if(c == 'x') {
 85e:	fdc42783          	lw	a5,-36(s0)
 862:	0007871b          	sext.w	a4,a5
 866:	07800793          	li	a5,120
 86a:	02f71463          	bne	a4,a5,892 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 86e:	fb843783          	ld	a5,-72(s0)
 872:	00878713          	addi	a4,a5,8
 876:	fae43c23          	sd	a4,-72(s0)
 87a:	4398                	lw	a4,0(a5)
 87c:	fcc42783          	lw	a5,-52(s0)
 880:	4681                	li	a3,0
 882:	4641                	li	a2,16
 884:	85ba                	mv	a1,a4
 886:	853e                	mv	a0,a5
 888:	00000097          	auipc	ra,0x0
 88c:	d58080e7          	jalr	-680(ra) # 5e0 <printint>
 890:	aa39                	j	9ae <vprintf+0x23a>
      } else if(c == 'p') {
 892:	fdc42783          	lw	a5,-36(s0)
 896:	0007871b          	sext.w	a4,a5
 89a:	07000793          	li	a5,112
 89e:	02f71263          	bne	a4,a5,8c2 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 8a2:	fb843783          	ld	a5,-72(s0)
 8a6:	00878713          	addi	a4,a5,8
 8aa:	fae43c23          	sd	a4,-72(s0)
 8ae:	6398                	ld	a4,0(a5)
 8b0:	fcc42783          	lw	a5,-52(s0)
 8b4:	85ba                	mv	a1,a4
 8b6:	853e                	mv	a0,a5
 8b8:	00000097          	auipc	ra,0x0
 8bc:	e30080e7          	jalr	-464(ra) # 6e8 <printptr>
 8c0:	a0fd                	j	9ae <vprintf+0x23a>
      } else if(c == 's'){
 8c2:	fdc42783          	lw	a5,-36(s0)
 8c6:	0007871b          	sext.w	a4,a5
 8ca:	07300793          	li	a5,115
 8ce:	04f71c63          	bne	a4,a5,926 <vprintf+0x1b2>
        s = va_arg(ap, char*);
 8d2:	fb843783          	ld	a5,-72(s0)
 8d6:	00878713          	addi	a4,a5,8
 8da:	fae43c23          	sd	a4,-72(s0)
 8de:	639c                	ld	a5,0(a5)
 8e0:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 8e4:	fe843783          	ld	a5,-24(s0)
 8e8:	eb8d                	bnez	a5,91a <vprintf+0x1a6>
          s = "(null)";
 8ea:	00000797          	auipc	a5,0x0
 8ee:	4a678793          	addi	a5,a5,1190 # d90 <malloc+0x16c>
 8f2:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 8f6:	a015                	j	91a <vprintf+0x1a6>
          putc(fd, *s);
 8f8:	fe843783          	ld	a5,-24(s0)
 8fc:	0007c703          	lbu	a4,0(a5)
 900:	fcc42783          	lw	a5,-52(s0)
 904:	85ba                	mv	a1,a4
 906:	853e                	mv	a0,a5
 908:	00000097          	auipc	ra,0x0
 90c:	ca2080e7          	jalr	-862(ra) # 5aa <putc>
          s++;
 910:	fe843783          	ld	a5,-24(s0)
 914:	0785                	addi	a5,a5,1
 916:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 91a:	fe843783          	ld	a5,-24(s0)
 91e:	0007c783          	lbu	a5,0(a5)
 922:	fbf9                	bnez	a5,8f8 <vprintf+0x184>
 924:	a069                	j	9ae <vprintf+0x23a>
        }
      } else if(c == 'c'){
 926:	fdc42783          	lw	a5,-36(s0)
 92a:	0007871b          	sext.w	a4,a5
 92e:	06300793          	li	a5,99
 932:	02f71463          	bne	a4,a5,95a <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 936:	fb843783          	ld	a5,-72(s0)
 93a:	00878713          	addi	a4,a5,8
 93e:	fae43c23          	sd	a4,-72(s0)
 942:	439c                	lw	a5,0(a5)
 944:	0ff7f713          	zext.b	a4,a5
 948:	fcc42783          	lw	a5,-52(s0)
 94c:	85ba                	mv	a1,a4
 94e:	853e                	mv	a0,a5
 950:	00000097          	auipc	ra,0x0
 954:	c5a080e7          	jalr	-934(ra) # 5aa <putc>
 958:	a899                	j	9ae <vprintf+0x23a>
      } else if(c == '%'){
 95a:	fdc42783          	lw	a5,-36(s0)
 95e:	0007871b          	sext.w	a4,a5
 962:	02500793          	li	a5,37
 966:	00f71f63          	bne	a4,a5,984 <vprintf+0x210>
        putc(fd, c);
 96a:	fdc42783          	lw	a5,-36(s0)
 96e:	0ff7f713          	zext.b	a4,a5
 972:	fcc42783          	lw	a5,-52(s0)
 976:	85ba                	mv	a1,a4
 978:	853e                	mv	a0,a5
 97a:	00000097          	auipc	ra,0x0
 97e:	c30080e7          	jalr	-976(ra) # 5aa <putc>
 982:	a035                	j	9ae <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 984:	fcc42783          	lw	a5,-52(s0)
 988:	02500593          	li	a1,37
 98c:	853e                	mv	a0,a5
 98e:	00000097          	auipc	ra,0x0
 992:	c1c080e7          	jalr	-996(ra) # 5aa <putc>
        putc(fd, c);
 996:	fdc42783          	lw	a5,-36(s0)
 99a:	0ff7f713          	zext.b	a4,a5
 99e:	fcc42783          	lw	a5,-52(s0)
 9a2:	85ba                	mv	a1,a4
 9a4:	853e                	mv	a0,a5
 9a6:	00000097          	auipc	ra,0x0
 9aa:	c04080e7          	jalr	-1020(ra) # 5aa <putc>
      }
      state = 0;
 9ae:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 9b2:	fe442783          	lw	a5,-28(s0)
 9b6:	2785                	addiw	a5,a5,1
 9b8:	fef42223          	sw	a5,-28(s0)
 9bc:	fe442783          	lw	a5,-28(s0)
 9c0:	fc043703          	ld	a4,-64(s0)
 9c4:	97ba                	add	a5,a5,a4
 9c6:	0007c783          	lbu	a5,0(a5)
 9ca:	dc0795e3          	bnez	a5,794 <vprintf+0x20>
    }
  }
}
 9ce:	0001                	nop
 9d0:	0001                	nop
 9d2:	60a6                	ld	ra,72(sp)
 9d4:	6406                	ld	s0,64(sp)
 9d6:	6161                	addi	sp,sp,80
 9d8:	8082                	ret

00000000000009da <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9da:	7159                	addi	sp,sp,-112
 9dc:	fc06                	sd	ra,56(sp)
 9de:	f822                	sd	s0,48(sp)
 9e0:	0080                	addi	s0,sp,64
 9e2:	fcb43823          	sd	a1,-48(s0)
 9e6:	e010                	sd	a2,0(s0)
 9e8:	e414                	sd	a3,8(s0)
 9ea:	e818                	sd	a4,16(s0)
 9ec:	ec1c                	sd	a5,24(s0)
 9ee:	03043023          	sd	a6,32(s0)
 9f2:	03143423          	sd	a7,40(s0)
 9f6:	87aa                	mv	a5,a0
 9f8:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 9fc:	03040793          	addi	a5,s0,48
 a00:	fcf43423          	sd	a5,-56(s0)
 a04:	fc843783          	ld	a5,-56(s0)
 a08:	fd078793          	addi	a5,a5,-48
 a0c:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 a10:	fe843703          	ld	a4,-24(s0)
 a14:	fdc42783          	lw	a5,-36(s0)
 a18:	863a                	mv	a2,a4
 a1a:	fd043583          	ld	a1,-48(s0)
 a1e:	853e                	mv	a0,a5
 a20:	00000097          	auipc	ra,0x0
 a24:	d54080e7          	jalr	-684(ra) # 774 <vprintf>
}
 a28:	0001                	nop
 a2a:	70e2                	ld	ra,56(sp)
 a2c:	7442                	ld	s0,48(sp)
 a2e:	6165                	addi	sp,sp,112
 a30:	8082                	ret

0000000000000a32 <printf>:

void
printf(const char *fmt, ...)
{
 a32:	7159                	addi	sp,sp,-112
 a34:	f406                	sd	ra,40(sp)
 a36:	f022                	sd	s0,32(sp)
 a38:	1800                	addi	s0,sp,48
 a3a:	fca43c23          	sd	a0,-40(s0)
 a3e:	e40c                	sd	a1,8(s0)
 a40:	e810                	sd	a2,16(s0)
 a42:	ec14                	sd	a3,24(s0)
 a44:	f018                	sd	a4,32(s0)
 a46:	f41c                	sd	a5,40(s0)
 a48:	03043823          	sd	a6,48(s0)
 a4c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a50:	04040793          	addi	a5,s0,64
 a54:	fcf43823          	sd	a5,-48(s0)
 a58:	fd043783          	ld	a5,-48(s0)
 a5c:	fc878793          	addi	a5,a5,-56
 a60:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 a64:	fe843783          	ld	a5,-24(s0)
 a68:	863e                	mv	a2,a5
 a6a:	fd843583          	ld	a1,-40(s0)
 a6e:	4505                	li	a0,1
 a70:	00000097          	auipc	ra,0x0
 a74:	d04080e7          	jalr	-764(ra) # 774 <vprintf>
}
 a78:	0001                	nop
 a7a:	70a2                	ld	ra,40(sp)
 a7c:	7402                	ld	s0,32(sp)
 a7e:	6165                	addi	sp,sp,112
 a80:	8082                	ret

0000000000000a82 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a82:	7179                	addi	sp,sp,-48
 a84:	f422                	sd	s0,40(sp)
 a86:	1800                	addi	s0,sp,48
 a88:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a8c:	fd843783          	ld	a5,-40(s0)
 a90:	17c1                	addi	a5,a5,-16
 a92:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a96:	00001797          	auipc	a5,0x1
 a9a:	90a78793          	addi	a5,a5,-1782 # 13a0 <freep>
 a9e:	639c                	ld	a5,0(a5)
 aa0:	fef43423          	sd	a5,-24(s0)
 aa4:	a815                	j	ad8 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 aa6:	fe843783          	ld	a5,-24(s0)
 aaa:	639c                	ld	a5,0(a5)
 aac:	fe843703          	ld	a4,-24(s0)
 ab0:	00f76f63          	bltu	a4,a5,ace <free+0x4c>
 ab4:	fe043703          	ld	a4,-32(s0)
 ab8:	fe843783          	ld	a5,-24(s0)
 abc:	02e7eb63          	bltu	a5,a4,af2 <free+0x70>
 ac0:	fe843783          	ld	a5,-24(s0)
 ac4:	639c                	ld	a5,0(a5)
 ac6:	fe043703          	ld	a4,-32(s0)
 aca:	02f76463          	bltu	a4,a5,af2 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ace:	fe843783          	ld	a5,-24(s0)
 ad2:	639c                	ld	a5,0(a5)
 ad4:	fef43423          	sd	a5,-24(s0)
 ad8:	fe043703          	ld	a4,-32(s0)
 adc:	fe843783          	ld	a5,-24(s0)
 ae0:	fce7f3e3          	bgeu	a5,a4,aa6 <free+0x24>
 ae4:	fe843783          	ld	a5,-24(s0)
 ae8:	639c                	ld	a5,0(a5)
 aea:	fe043703          	ld	a4,-32(s0)
 aee:	faf77ce3          	bgeu	a4,a5,aa6 <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 af2:	fe043783          	ld	a5,-32(s0)
 af6:	479c                	lw	a5,8(a5)
 af8:	1782                	slli	a5,a5,0x20
 afa:	9381                	srli	a5,a5,0x20
 afc:	0792                	slli	a5,a5,0x4
 afe:	fe043703          	ld	a4,-32(s0)
 b02:	973e                	add	a4,a4,a5
 b04:	fe843783          	ld	a5,-24(s0)
 b08:	639c                	ld	a5,0(a5)
 b0a:	02f71763          	bne	a4,a5,b38 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 b0e:	fe043783          	ld	a5,-32(s0)
 b12:	4798                	lw	a4,8(a5)
 b14:	fe843783          	ld	a5,-24(s0)
 b18:	639c                	ld	a5,0(a5)
 b1a:	479c                	lw	a5,8(a5)
 b1c:	9fb9                	addw	a5,a5,a4
 b1e:	0007871b          	sext.w	a4,a5
 b22:	fe043783          	ld	a5,-32(s0)
 b26:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 b28:	fe843783          	ld	a5,-24(s0)
 b2c:	639c                	ld	a5,0(a5)
 b2e:	6398                	ld	a4,0(a5)
 b30:	fe043783          	ld	a5,-32(s0)
 b34:	e398                	sd	a4,0(a5)
 b36:	a039                	j	b44 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 b38:	fe843783          	ld	a5,-24(s0)
 b3c:	6398                	ld	a4,0(a5)
 b3e:	fe043783          	ld	a5,-32(s0)
 b42:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 b44:	fe843783          	ld	a5,-24(s0)
 b48:	479c                	lw	a5,8(a5)
 b4a:	1782                	slli	a5,a5,0x20
 b4c:	9381                	srli	a5,a5,0x20
 b4e:	0792                	slli	a5,a5,0x4
 b50:	fe843703          	ld	a4,-24(s0)
 b54:	97ba                	add	a5,a5,a4
 b56:	fe043703          	ld	a4,-32(s0)
 b5a:	02f71563          	bne	a4,a5,b84 <free+0x102>
    p->s.size += bp->s.size;
 b5e:	fe843783          	ld	a5,-24(s0)
 b62:	4798                	lw	a4,8(a5)
 b64:	fe043783          	ld	a5,-32(s0)
 b68:	479c                	lw	a5,8(a5)
 b6a:	9fb9                	addw	a5,a5,a4
 b6c:	0007871b          	sext.w	a4,a5
 b70:	fe843783          	ld	a5,-24(s0)
 b74:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b76:	fe043783          	ld	a5,-32(s0)
 b7a:	6398                	ld	a4,0(a5)
 b7c:	fe843783          	ld	a5,-24(s0)
 b80:	e398                	sd	a4,0(a5)
 b82:	a031                	j	b8e <free+0x10c>
  } else
    p->s.ptr = bp;
 b84:	fe843783          	ld	a5,-24(s0)
 b88:	fe043703          	ld	a4,-32(s0)
 b8c:	e398                	sd	a4,0(a5)
  freep = p;
 b8e:	00001797          	auipc	a5,0x1
 b92:	81278793          	addi	a5,a5,-2030 # 13a0 <freep>
 b96:	fe843703          	ld	a4,-24(s0)
 b9a:	e398                	sd	a4,0(a5)
}
 b9c:	0001                	nop
 b9e:	7422                	ld	s0,40(sp)
 ba0:	6145                	addi	sp,sp,48
 ba2:	8082                	ret

0000000000000ba4 <morecore>:

static Header*
morecore(uint nu)
{
 ba4:	7179                	addi	sp,sp,-48
 ba6:	f406                	sd	ra,40(sp)
 ba8:	f022                	sd	s0,32(sp)
 baa:	1800                	addi	s0,sp,48
 bac:	87aa                	mv	a5,a0
 bae:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 bb2:	fdc42783          	lw	a5,-36(s0)
 bb6:	0007871b          	sext.w	a4,a5
 bba:	6785                	lui	a5,0x1
 bbc:	00f77563          	bgeu	a4,a5,bc6 <morecore+0x22>
    nu = 4096;
 bc0:	6785                	lui	a5,0x1
 bc2:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 bc6:	fdc42783          	lw	a5,-36(s0)
 bca:	0047979b          	slliw	a5,a5,0x4
 bce:	2781                	sext.w	a5,a5
 bd0:	2781                	sext.w	a5,a5
 bd2:	853e                	mv	a0,a5
 bd4:	00000097          	auipc	ra,0x0
 bd8:	9b6080e7          	jalr	-1610(ra) # 58a <sbrk>
 bdc:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 be0:	fe843703          	ld	a4,-24(s0)
 be4:	57fd                	li	a5,-1
 be6:	00f71463          	bne	a4,a5,bee <morecore+0x4a>
    return 0;
 bea:	4781                	li	a5,0
 bec:	a03d                	j	c1a <morecore+0x76>
  hp = (Header*)p;
 bee:	fe843783          	ld	a5,-24(s0)
 bf2:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 bf6:	fe043783          	ld	a5,-32(s0)
 bfa:	fdc42703          	lw	a4,-36(s0)
 bfe:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 c00:	fe043783          	ld	a5,-32(s0)
 c04:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x3ec>
 c06:	853e                	mv	a0,a5
 c08:	00000097          	auipc	ra,0x0
 c0c:	e7a080e7          	jalr	-390(ra) # a82 <free>
  return freep;
 c10:	00000797          	auipc	a5,0x0
 c14:	79078793          	addi	a5,a5,1936 # 13a0 <freep>
 c18:	639c                	ld	a5,0(a5)
}
 c1a:	853e                	mv	a0,a5
 c1c:	70a2                	ld	ra,40(sp)
 c1e:	7402                	ld	s0,32(sp)
 c20:	6145                	addi	sp,sp,48
 c22:	8082                	ret

0000000000000c24 <malloc>:

void*
malloc(uint nbytes)
{
 c24:	7139                	addi	sp,sp,-64
 c26:	fc06                	sd	ra,56(sp)
 c28:	f822                	sd	s0,48(sp)
 c2a:	0080                	addi	s0,sp,64
 c2c:	87aa                	mv	a5,a0
 c2e:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c32:	fcc46783          	lwu	a5,-52(s0)
 c36:	07bd                	addi	a5,a5,15
 c38:	8391                	srli	a5,a5,0x4
 c3a:	2781                	sext.w	a5,a5
 c3c:	2785                	addiw	a5,a5,1
 c3e:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 c42:	00000797          	auipc	a5,0x0
 c46:	75e78793          	addi	a5,a5,1886 # 13a0 <freep>
 c4a:	639c                	ld	a5,0(a5)
 c4c:	fef43023          	sd	a5,-32(s0)
 c50:	fe043783          	ld	a5,-32(s0)
 c54:	ef95                	bnez	a5,c90 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 c56:	00000797          	auipc	a5,0x0
 c5a:	73a78793          	addi	a5,a5,1850 # 1390 <base>
 c5e:	fef43023          	sd	a5,-32(s0)
 c62:	00000797          	auipc	a5,0x0
 c66:	73e78793          	addi	a5,a5,1854 # 13a0 <freep>
 c6a:	fe043703          	ld	a4,-32(s0)
 c6e:	e398                	sd	a4,0(a5)
 c70:	00000797          	auipc	a5,0x0
 c74:	73078793          	addi	a5,a5,1840 # 13a0 <freep>
 c78:	6398                	ld	a4,0(a5)
 c7a:	00000797          	auipc	a5,0x0
 c7e:	71678793          	addi	a5,a5,1814 # 1390 <base>
 c82:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 c84:	00000797          	auipc	a5,0x0
 c88:	70c78793          	addi	a5,a5,1804 # 1390 <base>
 c8c:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c90:	fe043783          	ld	a5,-32(s0)
 c94:	639c                	ld	a5,0(a5)
 c96:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 c9a:	fe843783          	ld	a5,-24(s0)
 c9e:	4798                	lw	a4,8(a5)
 ca0:	fdc42783          	lw	a5,-36(s0)
 ca4:	2781                	sext.w	a5,a5
 ca6:	06f76763          	bltu	a4,a5,d14 <malloc+0xf0>
      if(p->s.size == nunits)
 caa:	fe843783          	ld	a5,-24(s0)
 cae:	4798                	lw	a4,8(a5)
 cb0:	fdc42783          	lw	a5,-36(s0)
 cb4:	2781                	sext.w	a5,a5
 cb6:	00e79963          	bne	a5,a4,cc8 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 cba:	fe843783          	ld	a5,-24(s0)
 cbe:	6398                	ld	a4,0(a5)
 cc0:	fe043783          	ld	a5,-32(s0)
 cc4:	e398                	sd	a4,0(a5)
 cc6:	a825                	j	cfe <malloc+0xda>
      else {
        p->s.size -= nunits;
 cc8:	fe843783          	ld	a5,-24(s0)
 ccc:	479c                	lw	a5,8(a5)
 cce:	fdc42703          	lw	a4,-36(s0)
 cd2:	9f99                	subw	a5,a5,a4
 cd4:	0007871b          	sext.w	a4,a5
 cd8:	fe843783          	ld	a5,-24(s0)
 cdc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 cde:	fe843783          	ld	a5,-24(s0)
 ce2:	479c                	lw	a5,8(a5)
 ce4:	1782                	slli	a5,a5,0x20
 ce6:	9381                	srli	a5,a5,0x20
 ce8:	0792                	slli	a5,a5,0x4
 cea:	fe843703          	ld	a4,-24(s0)
 cee:	97ba                	add	a5,a5,a4
 cf0:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 cf4:	fe843783          	ld	a5,-24(s0)
 cf8:	fdc42703          	lw	a4,-36(s0)
 cfc:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 cfe:	00000797          	auipc	a5,0x0
 d02:	6a278793          	addi	a5,a5,1698 # 13a0 <freep>
 d06:	fe043703          	ld	a4,-32(s0)
 d0a:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 d0c:	fe843783          	ld	a5,-24(s0)
 d10:	07c1                	addi	a5,a5,16
 d12:	a091                	j	d56 <malloc+0x132>
    }
    if(p == freep)
 d14:	00000797          	auipc	a5,0x0
 d18:	68c78793          	addi	a5,a5,1676 # 13a0 <freep>
 d1c:	639c                	ld	a5,0(a5)
 d1e:	fe843703          	ld	a4,-24(s0)
 d22:	02f71063          	bne	a4,a5,d42 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 d26:	fdc42783          	lw	a5,-36(s0)
 d2a:	853e                	mv	a0,a5
 d2c:	00000097          	auipc	ra,0x0
 d30:	e78080e7          	jalr	-392(ra) # ba4 <morecore>
 d34:	fea43423          	sd	a0,-24(s0)
 d38:	fe843783          	ld	a5,-24(s0)
 d3c:	e399                	bnez	a5,d42 <malloc+0x11e>
        return 0;
 d3e:	4781                	li	a5,0
 d40:	a819                	j	d56 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d42:	fe843783          	ld	a5,-24(s0)
 d46:	fef43023          	sd	a5,-32(s0)
 d4a:	fe843783          	ld	a5,-24(s0)
 d4e:	639c                	ld	a5,0(a5)
 d50:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 d54:	b799                	j	c9a <malloc+0x76>
  }
}
 d56:	853e                	mv	a0,a5
 d58:	70e2                	ld	ra,56(sp)
 d5a:	7442                	ld	s0,48(sp)
 d5c:	6121                	addi	sp,sp,64
 d5e:	8082                	ret
