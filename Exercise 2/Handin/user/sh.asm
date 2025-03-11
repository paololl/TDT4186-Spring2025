
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
    }
    exit(0);
}

int getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
    write(2, "$ ", 2);
      10:	4609                	li	a2,2
      12:	00001597          	auipc	a1,0x1
      16:	43e58593          	addi	a1,a1,1086 # 1450 <malloc+0x102>
      1a:	4509                	li	a0,2
      1c:	00001097          	auipc	ra,0x1
      20:	f0a080e7          	jalr	-246(ra) # f26 <write>
    memset(buf, 0, nbuf);
      24:	864a                	mv	a2,s2
      26:	4581                	li	a1,0
      28:	8526                	mv	a0,s1
      2a:	00001097          	auipc	ra,0x1
      2e:	ce2080e7          	jalr	-798(ra) # d0c <memset>
    gets(buf, nbuf);
      32:	85ca                	mv	a1,s2
      34:	8526                	mv	a0,s1
      36:	00001097          	auipc	ra,0x1
      3a:	d1c080e7          	jalr	-740(ra) # d52 <gets>
    if (buf[0] == 0) // EOF
      3e:	0004c503          	lbu	a0,0(s1)
      42:	00153513          	seqz	a0,a0
        return -1;
    return 0;
}
      46:	40a00533          	neg	a0,a0
      4a:	60e2                	ld	ra,24(sp)
      4c:	6442                	ld	s0,16(sp)
      4e:	64a2                	ld	s1,8(sp)
      50:	6902                	ld	s2,0(sp)
      52:	6105                	addi	sp,sp,32
      54:	8082                	ret

0000000000000056 <panic>:
    }
    exit(0);
}

void panic(char *s)
{
      56:	1141                	addi	sp,sp,-16
      58:	e406                	sd	ra,8(sp)
      5a:	e022                	sd	s0,0(sp)
      5c:	0800                	addi	s0,sp,16
      5e:	862a                	mv	a2,a0
    fprintf(2, "%s\n", s);
      60:	00001597          	auipc	a1,0x1
      64:	40058593          	addi	a1,a1,1024 # 1460 <malloc+0x112>
      68:	4509                	li	a0,2
      6a:	00001097          	auipc	ra,0x1
      6e:	1fe080e7          	jalr	510(ra) # 1268 <fprintf>
    exit(1);
      72:	4505                	li	a0,1
      74:	00001097          	auipc	ra,0x1
      78:	e92080e7          	jalr	-366(ra) # f06 <exit>

000000000000007c <fork1>:
}

int fork1(void)
{
      7c:	1141                	addi	sp,sp,-16
      7e:	e406                	sd	ra,8(sp)
      80:	e022                	sd	s0,0(sp)
      82:	0800                	addi	s0,sp,16
    int pid;

    pid = fork();
      84:	00001097          	auipc	ra,0x1
      88:	e7a080e7          	jalr	-390(ra) # efe <fork>
    if (pid == -1)
      8c:	57fd                	li	a5,-1
      8e:	00f50663          	beq	a0,a5,9a <fork1+0x1e>
        panic("fork");
    return pid;
}
      92:	60a2                	ld	ra,8(sp)
      94:	6402                	ld	s0,0(sp)
      96:	0141                	addi	sp,sp,16
      98:	8082                	ret
        panic("fork");
      9a:	00001517          	auipc	a0,0x1
      9e:	3ce50513          	addi	a0,a0,974 # 1468 <malloc+0x11a>
      a2:	00000097          	auipc	ra,0x0
      a6:	fb4080e7          	jalr	-76(ra) # 56 <panic>

00000000000000aa <runcmd>:
{
      aa:	7179                	addi	sp,sp,-48
      ac:	f406                	sd	ra,40(sp)
      ae:	f022                	sd	s0,32(sp)
      b0:	1800                	addi	s0,sp,48
    if (cmd == 0)
      b2:	c115                	beqz	a0,d6 <runcmd+0x2c>
      b4:	ec26                	sd	s1,24(sp)
      b6:	84aa                	mv	s1,a0
    switch (cmd->type)
      b8:	4118                	lw	a4,0(a0)
      ba:	4795                	li	a5,5
      bc:	02e7e363          	bltu	a5,a4,e2 <runcmd+0x38>
      c0:	00056783          	lwu	a5,0(a0)
      c4:	078a                	slli	a5,a5,0x2
      c6:	00001717          	auipc	a4,0x1
      ca:	4ba70713          	addi	a4,a4,1210 # 1580 <malloc+0x232>
      ce:	97ba                	add	a5,a5,a4
      d0:	439c                	lw	a5,0(a5)
      d2:	97ba                	add	a5,a5,a4
      d4:	8782                	jr	a5
      d6:	ec26                	sd	s1,24(sp)
        exit(1);
      d8:	4505                	li	a0,1
      da:	00001097          	auipc	ra,0x1
      de:	e2c080e7          	jalr	-468(ra) # f06 <exit>
        panic("runcmd");
      e2:	00001517          	auipc	a0,0x1
      e6:	38e50513          	addi	a0,a0,910 # 1470 <malloc+0x122>
      ea:	00000097          	auipc	ra,0x0
      ee:	f6c080e7          	jalr	-148(ra) # 56 <panic>
        if (ecmd->argv[0] == 0)
      f2:	6508                	ld	a0,8(a0)
      f4:	c515                	beqz	a0,120 <runcmd+0x76>
        exec(ecmd->argv[0], ecmd->argv);
      f6:	00848593          	addi	a1,s1,8
      fa:	00001097          	auipc	ra,0x1
      fe:	e44080e7          	jalr	-444(ra) # f3e <exec>
        fprintf(2, "exec %s failed\n", ecmd->argv[0]);
     102:	6490                	ld	a2,8(s1)
     104:	00001597          	auipc	a1,0x1
     108:	37458593          	addi	a1,a1,884 # 1478 <malloc+0x12a>
     10c:	4509                	li	a0,2
     10e:	00001097          	auipc	ra,0x1
     112:	15a080e7          	jalr	346(ra) # 1268 <fprintf>
    exit(0);
     116:	4501                	li	a0,0
     118:	00001097          	auipc	ra,0x1
     11c:	dee080e7          	jalr	-530(ra) # f06 <exit>
            exit(1);
     120:	4505                	li	a0,1
     122:	00001097          	auipc	ra,0x1
     126:	de4080e7          	jalr	-540(ra) # f06 <exit>
        close(rcmd->fd);
     12a:	5148                	lw	a0,36(a0)
     12c:	00001097          	auipc	ra,0x1
     130:	e02080e7          	jalr	-510(ra) # f2e <close>
        if (open(rcmd->file, rcmd->mode) < 0)
     134:	508c                	lw	a1,32(s1)
     136:	6888                	ld	a0,16(s1)
     138:	00001097          	auipc	ra,0x1
     13c:	e0e080e7          	jalr	-498(ra) # f46 <open>
     140:	00054763          	bltz	a0,14e <runcmd+0xa4>
        runcmd(rcmd->cmd);
     144:	6488                	ld	a0,8(s1)
     146:	00000097          	auipc	ra,0x0
     14a:	f64080e7          	jalr	-156(ra) # aa <runcmd>
            fprintf(2, "open %s failed\n", rcmd->file);
     14e:	6890                	ld	a2,16(s1)
     150:	00001597          	auipc	a1,0x1
     154:	33858593          	addi	a1,a1,824 # 1488 <malloc+0x13a>
     158:	4509                	li	a0,2
     15a:	00001097          	auipc	ra,0x1
     15e:	10e080e7          	jalr	270(ra) # 1268 <fprintf>
            exit(1);
     162:	4505                	li	a0,1
     164:	00001097          	auipc	ra,0x1
     168:	da2080e7          	jalr	-606(ra) # f06 <exit>
        if (fork1() == 0)
     16c:	00000097          	auipc	ra,0x0
     170:	f10080e7          	jalr	-240(ra) # 7c <fork1>
     174:	e511                	bnez	a0,180 <runcmd+0xd6>
            runcmd(lcmd->left);
     176:	6488                	ld	a0,8(s1)
     178:	00000097          	auipc	ra,0x0
     17c:	f32080e7          	jalr	-206(ra) # aa <runcmd>
        wait(0);
     180:	4501                	li	a0,0
     182:	00001097          	auipc	ra,0x1
     186:	d8c080e7          	jalr	-628(ra) # f0e <wait>
        runcmd(lcmd->right);
     18a:	6888                	ld	a0,16(s1)
     18c:	00000097          	auipc	ra,0x0
     190:	f1e080e7          	jalr	-226(ra) # aa <runcmd>
        if (pipe(p) < 0)
     194:	fd840513          	addi	a0,s0,-40
     198:	00001097          	auipc	ra,0x1
     19c:	d7e080e7          	jalr	-642(ra) # f16 <pipe>
     1a0:	04054363          	bltz	a0,1e6 <runcmd+0x13c>
        if (fork1() == 0)
     1a4:	00000097          	auipc	ra,0x0
     1a8:	ed8080e7          	jalr	-296(ra) # 7c <fork1>
     1ac:	e529                	bnez	a0,1f6 <runcmd+0x14c>
            close(1);
     1ae:	4505                	li	a0,1
     1b0:	00001097          	auipc	ra,0x1
     1b4:	d7e080e7          	jalr	-642(ra) # f2e <close>
            dup(p[1]);
     1b8:	fdc42503          	lw	a0,-36(s0)
     1bc:	00001097          	auipc	ra,0x1
     1c0:	dc2080e7          	jalr	-574(ra) # f7e <dup>
            close(p[0]);
     1c4:	fd842503          	lw	a0,-40(s0)
     1c8:	00001097          	auipc	ra,0x1
     1cc:	d66080e7          	jalr	-666(ra) # f2e <close>
            close(p[1]);
     1d0:	fdc42503          	lw	a0,-36(s0)
     1d4:	00001097          	auipc	ra,0x1
     1d8:	d5a080e7          	jalr	-678(ra) # f2e <close>
            runcmd(pcmd->left);
     1dc:	6488                	ld	a0,8(s1)
     1de:	00000097          	auipc	ra,0x0
     1e2:	ecc080e7          	jalr	-308(ra) # aa <runcmd>
            panic("pipe");
     1e6:	00001517          	auipc	a0,0x1
     1ea:	2b250513          	addi	a0,a0,690 # 1498 <malloc+0x14a>
     1ee:	00000097          	auipc	ra,0x0
     1f2:	e68080e7          	jalr	-408(ra) # 56 <panic>
        if (fork1() == 0)
     1f6:	00000097          	auipc	ra,0x0
     1fa:	e86080e7          	jalr	-378(ra) # 7c <fork1>
     1fe:	ed05                	bnez	a0,236 <runcmd+0x18c>
            close(0);
     200:	00001097          	auipc	ra,0x1
     204:	d2e080e7          	jalr	-722(ra) # f2e <close>
            dup(p[0]);
     208:	fd842503          	lw	a0,-40(s0)
     20c:	00001097          	auipc	ra,0x1
     210:	d72080e7          	jalr	-654(ra) # f7e <dup>
            close(p[0]);
     214:	fd842503          	lw	a0,-40(s0)
     218:	00001097          	auipc	ra,0x1
     21c:	d16080e7          	jalr	-746(ra) # f2e <close>
            close(p[1]);
     220:	fdc42503          	lw	a0,-36(s0)
     224:	00001097          	auipc	ra,0x1
     228:	d0a080e7          	jalr	-758(ra) # f2e <close>
            runcmd(pcmd->right);
     22c:	6888                	ld	a0,16(s1)
     22e:	00000097          	auipc	ra,0x0
     232:	e7c080e7          	jalr	-388(ra) # aa <runcmd>
        close(p[0]);
     236:	fd842503          	lw	a0,-40(s0)
     23a:	00001097          	auipc	ra,0x1
     23e:	cf4080e7          	jalr	-780(ra) # f2e <close>
        close(p[1]);
     242:	fdc42503          	lw	a0,-36(s0)
     246:	00001097          	auipc	ra,0x1
     24a:	ce8080e7          	jalr	-792(ra) # f2e <close>
        wait(0);
     24e:	4501                	li	a0,0
     250:	00001097          	auipc	ra,0x1
     254:	cbe080e7          	jalr	-834(ra) # f0e <wait>
        wait(0);
     258:	4501                	li	a0,0
     25a:	00001097          	auipc	ra,0x1
     25e:	cb4080e7          	jalr	-844(ra) # f0e <wait>
        break;
     262:	bd55                	j	116 <runcmd+0x6c>
        if (fork1() == 0)
     264:	00000097          	auipc	ra,0x0
     268:	e18080e7          	jalr	-488(ra) # 7c <fork1>
     26c:	ea0515e3          	bnez	a0,116 <runcmd+0x6c>
            runcmd(bcmd->cmd);
     270:	6488                	ld	a0,8(s1)
     272:	00000097          	auipc	ra,0x0
     276:	e38080e7          	jalr	-456(ra) # aa <runcmd>

000000000000027a <execcmd>:
// PAGEBREAK!
//  Constructors

struct cmd *
execcmd(void)
{
     27a:	1101                	addi	sp,sp,-32
     27c:	ec06                	sd	ra,24(sp)
     27e:	e822                	sd	s0,16(sp)
     280:	e426                	sd	s1,8(sp)
     282:	1000                	addi	s0,sp,32
    struct execcmd *cmd;

    cmd = malloc(sizeof(*cmd));
     284:	0a800513          	li	a0,168
     288:	00001097          	auipc	ra,0x1
     28c:	0c6080e7          	jalr	198(ra) # 134e <malloc>
     290:	84aa                	mv	s1,a0
    memset(cmd, 0, sizeof(*cmd));
     292:	0a800613          	li	a2,168
     296:	4581                	li	a1,0
     298:	00001097          	auipc	ra,0x1
     29c:	a74080e7          	jalr	-1420(ra) # d0c <memset>
    cmd->type = EXEC;
     2a0:	4785                	li	a5,1
     2a2:	c09c                	sw	a5,0(s1)
    return (struct cmd *)cmd;
}
     2a4:	8526                	mv	a0,s1
     2a6:	60e2                	ld	ra,24(sp)
     2a8:	6442                	ld	s0,16(sp)
     2aa:	64a2                	ld	s1,8(sp)
     2ac:	6105                	addi	sp,sp,32
     2ae:	8082                	ret

00000000000002b0 <redircmd>:

struct cmd *
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     2b0:	7139                	addi	sp,sp,-64
     2b2:	fc06                	sd	ra,56(sp)
     2b4:	f822                	sd	s0,48(sp)
     2b6:	f426                	sd	s1,40(sp)
     2b8:	f04a                	sd	s2,32(sp)
     2ba:	ec4e                	sd	s3,24(sp)
     2bc:	e852                	sd	s4,16(sp)
     2be:	e456                	sd	s5,8(sp)
     2c0:	e05a                	sd	s6,0(sp)
     2c2:	0080                	addi	s0,sp,64
     2c4:	8b2a                	mv	s6,a0
     2c6:	8aae                	mv	s5,a1
     2c8:	8a32                	mv	s4,a2
     2ca:	89b6                	mv	s3,a3
     2cc:	893a                	mv	s2,a4
    struct redircmd *cmd;

    cmd = malloc(sizeof(*cmd));
     2ce:	02800513          	li	a0,40
     2d2:	00001097          	auipc	ra,0x1
     2d6:	07c080e7          	jalr	124(ra) # 134e <malloc>
     2da:	84aa                	mv	s1,a0
    memset(cmd, 0, sizeof(*cmd));
     2dc:	02800613          	li	a2,40
     2e0:	4581                	li	a1,0
     2e2:	00001097          	auipc	ra,0x1
     2e6:	a2a080e7          	jalr	-1494(ra) # d0c <memset>
    cmd->type = REDIR;
     2ea:	4789                	li	a5,2
     2ec:	c09c                	sw	a5,0(s1)
    cmd->cmd = subcmd;
     2ee:	0164b423          	sd	s6,8(s1)
    cmd->file = file;
     2f2:	0154b823          	sd	s5,16(s1)
    cmd->efile = efile;
     2f6:	0144bc23          	sd	s4,24(s1)
    cmd->mode = mode;
     2fa:	0334a023          	sw	s3,32(s1)
    cmd->fd = fd;
     2fe:	0324a223          	sw	s2,36(s1)
    return (struct cmd *)cmd;
}
     302:	8526                	mv	a0,s1
     304:	70e2                	ld	ra,56(sp)
     306:	7442                	ld	s0,48(sp)
     308:	74a2                	ld	s1,40(sp)
     30a:	7902                	ld	s2,32(sp)
     30c:	69e2                	ld	s3,24(sp)
     30e:	6a42                	ld	s4,16(sp)
     310:	6aa2                	ld	s5,8(sp)
     312:	6b02                	ld	s6,0(sp)
     314:	6121                	addi	sp,sp,64
     316:	8082                	ret

0000000000000318 <pipecmd>:

struct cmd *
pipecmd(struct cmd *left, struct cmd *right)
{
     318:	7179                	addi	sp,sp,-48
     31a:	f406                	sd	ra,40(sp)
     31c:	f022                	sd	s0,32(sp)
     31e:	ec26                	sd	s1,24(sp)
     320:	e84a                	sd	s2,16(sp)
     322:	e44e                	sd	s3,8(sp)
     324:	1800                	addi	s0,sp,48
     326:	89aa                	mv	s3,a0
     328:	892e                	mv	s2,a1
    struct pipecmd *cmd;

    cmd = malloc(sizeof(*cmd));
     32a:	4561                	li	a0,24
     32c:	00001097          	auipc	ra,0x1
     330:	022080e7          	jalr	34(ra) # 134e <malloc>
     334:	84aa                	mv	s1,a0
    memset(cmd, 0, sizeof(*cmd));
     336:	4661                	li	a2,24
     338:	4581                	li	a1,0
     33a:	00001097          	auipc	ra,0x1
     33e:	9d2080e7          	jalr	-1582(ra) # d0c <memset>
    cmd->type = PIPE;
     342:	478d                	li	a5,3
     344:	c09c                	sw	a5,0(s1)
    cmd->left = left;
     346:	0134b423          	sd	s3,8(s1)
    cmd->right = right;
     34a:	0124b823          	sd	s2,16(s1)
    return (struct cmd *)cmd;
}
     34e:	8526                	mv	a0,s1
     350:	70a2                	ld	ra,40(sp)
     352:	7402                	ld	s0,32(sp)
     354:	64e2                	ld	s1,24(sp)
     356:	6942                	ld	s2,16(sp)
     358:	69a2                	ld	s3,8(sp)
     35a:	6145                	addi	sp,sp,48
     35c:	8082                	ret

000000000000035e <listcmd>:

struct cmd *
listcmd(struct cmd *left, struct cmd *right)
{
     35e:	7179                	addi	sp,sp,-48
     360:	f406                	sd	ra,40(sp)
     362:	f022                	sd	s0,32(sp)
     364:	ec26                	sd	s1,24(sp)
     366:	e84a                	sd	s2,16(sp)
     368:	e44e                	sd	s3,8(sp)
     36a:	1800                	addi	s0,sp,48
     36c:	89aa                	mv	s3,a0
     36e:	892e                	mv	s2,a1
    struct listcmd *cmd;

    cmd = malloc(sizeof(*cmd));
     370:	4561                	li	a0,24
     372:	00001097          	auipc	ra,0x1
     376:	fdc080e7          	jalr	-36(ra) # 134e <malloc>
     37a:	84aa                	mv	s1,a0
    memset(cmd, 0, sizeof(*cmd));
     37c:	4661                	li	a2,24
     37e:	4581                	li	a1,0
     380:	00001097          	auipc	ra,0x1
     384:	98c080e7          	jalr	-1652(ra) # d0c <memset>
    cmd->type = LIST;
     388:	4791                	li	a5,4
     38a:	c09c                	sw	a5,0(s1)
    cmd->left = left;
     38c:	0134b423          	sd	s3,8(s1)
    cmd->right = right;
     390:	0124b823          	sd	s2,16(s1)
    return (struct cmd *)cmd;
}
     394:	8526                	mv	a0,s1
     396:	70a2                	ld	ra,40(sp)
     398:	7402                	ld	s0,32(sp)
     39a:	64e2                	ld	s1,24(sp)
     39c:	6942                	ld	s2,16(sp)
     39e:	69a2                	ld	s3,8(sp)
     3a0:	6145                	addi	sp,sp,48
     3a2:	8082                	ret

00000000000003a4 <backcmd>:

struct cmd *
backcmd(struct cmd *subcmd)
{
     3a4:	1101                	addi	sp,sp,-32
     3a6:	ec06                	sd	ra,24(sp)
     3a8:	e822                	sd	s0,16(sp)
     3aa:	e426                	sd	s1,8(sp)
     3ac:	e04a                	sd	s2,0(sp)
     3ae:	1000                	addi	s0,sp,32
     3b0:	892a                	mv	s2,a0
    struct backcmd *cmd;

    cmd = malloc(sizeof(*cmd));
     3b2:	4541                	li	a0,16
     3b4:	00001097          	auipc	ra,0x1
     3b8:	f9a080e7          	jalr	-102(ra) # 134e <malloc>
     3bc:	84aa                	mv	s1,a0
    memset(cmd, 0, sizeof(*cmd));
     3be:	4641                	li	a2,16
     3c0:	4581                	li	a1,0
     3c2:	00001097          	auipc	ra,0x1
     3c6:	94a080e7          	jalr	-1718(ra) # d0c <memset>
    cmd->type = BACK;
     3ca:	4795                	li	a5,5
     3cc:	c09c                	sw	a5,0(s1)
    cmd->cmd = subcmd;
     3ce:	0124b423          	sd	s2,8(s1)
    return (struct cmd *)cmd;
}
     3d2:	8526                	mv	a0,s1
     3d4:	60e2                	ld	ra,24(sp)
     3d6:	6442                	ld	s0,16(sp)
     3d8:	64a2                	ld	s1,8(sp)
     3da:	6902                	ld	s2,0(sp)
     3dc:	6105                	addi	sp,sp,32
     3de:	8082                	ret

00000000000003e0 <gettoken>:

char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int gettoken(char **ps, char *es, char **q, char **eq)
{
     3e0:	7139                	addi	sp,sp,-64
     3e2:	fc06                	sd	ra,56(sp)
     3e4:	f822                	sd	s0,48(sp)
     3e6:	f426                	sd	s1,40(sp)
     3e8:	f04a                	sd	s2,32(sp)
     3ea:	ec4e                	sd	s3,24(sp)
     3ec:	e852                	sd	s4,16(sp)
     3ee:	e456                	sd	s5,8(sp)
     3f0:	e05a                	sd	s6,0(sp)
     3f2:	0080                	addi	s0,sp,64
     3f4:	8a2a                	mv	s4,a0
     3f6:	892e                	mv	s2,a1
     3f8:	8ab2                	mv	s5,a2
     3fa:	8b36                	mv	s6,a3
    char *s;
    int ret;

    s = *ps;
     3fc:	6104                	ld	s1,0(a0)
    while (s < es && strchr(whitespace, *s))
     3fe:	00002997          	auipc	s3,0x2
     402:	42a98993          	addi	s3,s3,1066 # 2828 <whitespace>
     406:	00b4fe63          	bgeu	s1,a1,422 <gettoken+0x42>
     40a:	0004c583          	lbu	a1,0(s1)
     40e:	854e                	mv	a0,s3
     410:	00001097          	auipc	ra,0x1
     414:	91e080e7          	jalr	-1762(ra) # d2e <strchr>
     418:	c509                	beqz	a0,422 <gettoken+0x42>
        s++;
     41a:	0485                	addi	s1,s1,1
    while (s < es && strchr(whitespace, *s))
     41c:	fe9917e3          	bne	s2,s1,40a <gettoken+0x2a>
     420:	84ca                	mv	s1,s2
    if (q)
     422:	000a8463          	beqz	s5,42a <gettoken+0x4a>
        *q = s;
     426:	009ab023          	sd	s1,0(s5)
    ret = *s;
     42a:	0004c783          	lbu	a5,0(s1)
     42e:	00078a9b          	sext.w	s5,a5
    switch (*s)
     432:	03c00713          	li	a4,60
     436:	06f76663          	bltu	a4,a5,4a2 <gettoken+0xc2>
     43a:	03a00713          	li	a4,58
     43e:	00f76e63          	bltu	a4,a5,45a <gettoken+0x7a>
     442:	cf89                	beqz	a5,45c <gettoken+0x7c>
     444:	02600713          	li	a4,38
     448:	00e78963          	beq	a5,a4,45a <gettoken+0x7a>
     44c:	fd87879b          	addiw	a5,a5,-40
     450:	0ff7f793          	zext.b	a5,a5
     454:	4705                	li	a4,1
     456:	06f76d63          	bltu	a4,a5,4d0 <gettoken+0xf0>
    case '(':
    case ')':
    case ';':
    case '&':
    case '<':
        s++;
     45a:	0485                	addi	s1,s1,1
        ret = 'a';
        while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
            s++;
        break;
    }
    if (eq)
     45c:	000b0463          	beqz	s6,464 <gettoken+0x84>
        *eq = s;
     460:	009b3023          	sd	s1,0(s6)

    while (s < es && strchr(whitespace, *s))
     464:	00002997          	auipc	s3,0x2
     468:	3c498993          	addi	s3,s3,964 # 2828 <whitespace>
     46c:	0124fe63          	bgeu	s1,s2,488 <gettoken+0xa8>
     470:	0004c583          	lbu	a1,0(s1)
     474:	854e                	mv	a0,s3
     476:	00001097          	auipc	ra,0x1
     47a:	8b8080e7          	jalr	-1864(ra) # d2e <strchr>
     47e:	c509                	beqz	a0,488 <gettoken+0xa8>
        s++;
     480:	0485                	addi	s1,s1,1
    while (s < es && strchr(whitespace, *s))
     482:	fe9917e3          	bne	s2,s1,470 <gettoken+0x90>
     486:	84ca                	mv	s1,s2
    *ps = s;
     488:	009a3023          	sd	s1,0(s4)
    return ret;
}
     48c:	8556                	mv	a0,s5
     48e:	70e2                	ld	ra,56(sp)
     490:	7442                	ld	s0,48(sp)
     492:	74a2                	ld	s1,40(sp)
     494:	7902                	ld	s2,32(sp)
     496:	69e2                	ld	s3,24(sp)
     498:	6a42                	ld	s4,16(sp)
     49a:	6aa2                	ld	s5,8(sp)
     49c:	6b02                	ld	s6,0(sp)
     49e:	6121                	addi	sp,sp,64
     4a0:	8082                	ret
    switch (*s)
     4a2:	03e00713          	li	a4,62
     4a6:	02e79163          	bne	a5,a4,4c8 <gettoken+0xe8>
        s++;
     4aa:	00148693          	addi	a3,s1,1
        if (*s == '>')
     4ae:	0014c703          	lbu	a4,1(s1)
     4b2:	03e00793          	li	a5,62
            s++;
     4b6:	0489                	addi	s1,s1,2
            ret = '+';
     4b8:	02b00a93          	li	s5,43
        if (*s == '>')
     4bc:	faf700e3          	beq	a4,a5,45c <gettoken+0x7c>
        s++;
     4c0:	84b6                	mv	s1,a3
    ret = *s;
     4c2:	03e00a93          	li	s5,62
     4c6:	bf59                	j	45c <gettoken+0x7c>
    switch (*s)
     4c8:	07c00713          	li	a4,124
     4cc:	f8e787e3          	beq	a5,a4,45a <gettoken+0x7a>
        while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     4d0:	00002997          	auipc	s3,0x2
     4d4:	35898993          	addi	s3,s3,856 # 2828 <whitespace>
     4d8:	00002a97          	auipc	s5,0x2
     4dc:	348a8a93          	addi	s5,s5,840 # 2820 <symbols>
     4e0:	0524f163          	bgeu	s1,s2,522 <gettoken+0x142>
     4e4:	0004c583          	lbu	a1,0(s1)
     4e8:	854e                	mv	a0,s3
     4ea:	00001097          	auipc	ra,0x1
     4ee:	844080e7          	jalr	-1980(ra) # d2e <strchr>
     4f2:	e50d                	bnez	a0,51c <gettoken+0x13c>
     4f4:	0004c583          	lbu	a1,0(s1)
     4f8:	8556                	mv	a0,s5
     4fa:	00001097          	auipc	ra,0x1
     4fe:	834080e7          	jalr	-1996(ra) # d2e <strchr>
     502:	e911                	bnez	a0,516 <gettoken+0x136>
            s++;
     504:	0485                	addi	s1,s1,1
        while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     506:	fc991fe3          	bne	s2,s1,4e4 <gettoken+0x104>
    if (eq)
     50a:	84ca                	mv	s1,s2
        ret = 'a';
     50c:	06100a93          	li	s5,97
    if (eq)
     510:	f40b18e3          	bnez	s6,460 <gettoken+0x80>
     514:	bf95                	j	488 <gettoken+0xa8>
        ret = 'a';
     516:	06100a93          	li	s5,97
     51a:	b789                	j	45c <gettoken+0x7c>
     51c:	06100a93          	li	s5,97
     520:	bf35                	j	45c <gettoken+0x7c>
     522:	06100a93          	li	s5,97
    if (eq)
     526:	f20b1de3          	bnez	s6,460 <gettoken+0x80>
     52a:	bfb9                	j	488 <gettoken+0xa8>

000000000000052c <peek>:

int peek(char **ps, char *es, char *toks)
{
     52c:	7139                	addi	sp,sp,-64
     52e:	fc06                	sd	ra,56(sp)
     530:	f822                	sd	s0,48(sp)
     532:	f426                	sd	s1,40(sp)
     534:	f04a                	sd	s2,32(sp)
     536:	ec4e                	sd	s3,24(sp)
     538:	e852                	sd	s4,16(sp)
     53a:	e456                	sd	s5,8(sp)
     53c:	0080                	addi	s0,sp,64
     53e:	8a2a                	mv	s4,a0
     540:	892e                	mv	s2,a1
     542:	8ab2                	mv	s5,a2
    char *s;

    s = *ps;
     544:	6104                	ld	s1,0(a0)
    while (s < es && strchr(whitespace, *s))
     546:	00002997          	auipc	s3,0x2
     54a:	2e298993          	addi	s3,s3,738 # 2828 <whitespace>
     54e:	00b4fe63          	bgeu	s1,a1,56a <peek+0x3e>
     552:	0004c583          	lbu	a1,0(s1)
     556:	854e                	mv	a0,s3
     558:	00000097          	auipc	ra,0x0
     55c:	7d6080e7          	jalr	2006(ra) # d2e <strchr>
     560:	c509                	beqz	a0,56a <peek+0x3e>
        s++;
     562:	0485                	addi	s1,s1,1
    while (s < es && strchr(whitespace, *s))
     564:	fe9917e3          	bne	s2,s1,552 <peek+0x26>
     568:	84ca                	mv	s1,s2
    *ps = s;
     56a:	009a3023          	sd	s1,0(s4)
    return *s && strchr(toks, *s);
     56e:	0004c583          	lbu	a1,0(s1)
     572:	4501                	li	a0,0
     574:	e991                	bnez	a1,588 <peek+0x5c>
}
     576:	70e2                	ld	ra,56(sp)
     578:	7442                	ld	s0,48(sp)
     57a:	74a2                	ld	s1,40(sp)
     57c:	7902                	ld	s2,32(sp)
     57e:	69e2                	ld	s3,24(sp)
     580:	6a42                	ld	s4,16(sp)
     582:	6aa2                	ld	s5,8(sp)
     584:	6121                	addi	sp,sp,64
     586:	8082                	ret
    return *s && strchr(toks, *s);
     588:	8556                	mv	a0,s5
     58a:	00000097          	auipc	ra,0x0
     58e:	7a4080e7          	jalr	1956(ra) # d2e <strchr>
     592:	00a03533          	snez	a0,a0
     596:	b7c5                	j	576 <peek+0x4a>

0000000000000598 <parseredirs>:
    return cmd;
}

struct cmd *
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     598:	711d                	addi	sp,sp,-96
     59a:	ec86                	sd	ra,88(sp)
     59c:	e8a2                	sd	s0,80(sp)
     59e:	e4a6                	sd	s1,72(sp)
     5a0:	e0ca                	sd	s2,64(sp)
     5a2:	fc4e                	sd	s3,56(sp)
     5a4:	f852                	sd	s4,48(sp)
     5a6:	f456                	sd	s5,40(sp)
     5a8:	f05a                	sd	s6,32(sp)
     5aa:	ec5e                	sd	s7,24(sp)
     5ac:	1080                	addi	s0,sp,96
     5ae:	8a2a                	mv	s4,a0
     5b0:	89ae                	mv	s3,a1
     5b2:	8932                	mv	s2,a2
    int tok;
    char *q, *eq;

    while (peek(ps, es, "<>"))
     5b4:	00001a97          	auipc	s5,0x1
     5b8:	f0ca8a93          	addi	s5,s5,-244 # 14c0 <malloc+0x172>
    {
        tok = gettoken(ps, es, 0, 0);
        if (gettoken(ps, es, &q, &eq) != 'a')
     5bc:	06100b13          	li	s6,97
            panic("missing file for redirection");
        switch (tok)
     5c0:	03c00b93          	li	s7,60
    while (peek(ps, es, "<>"))
     5c4:	a02d                	j	5ee <parseredirs+0x56>
            panic("missing file for redirection");
     5c6:	00001517          	auipc	a0,0x1
     5ca:	eda50513          	addi	a0,a0,-294 # 14a0 <malloc+0x152>
     5ce:	00000097          	auipc	ra,0x0
     5d2:	a88080e7          	jalr	-1400(ra) # 56 <panic>
        {
        case '<':
            cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     5d6:	4701                	li	a4,0
     5d8:	4681                	li	a3,0
     5da:	fa043603          	ld	a2,-96(s0)
     5de:	fa843583          	ld	a1,-88(s0)
     5e2:	8552                	mv	a0,s4
     5e4:	00000097          	auipc	ra,0x0
     5e8:	ccc080e7          	jalr	-820(ra) # 2b0 <redircmd>
     5ec:	8a2a                	mv	s4,a0
    while (peek(ps, es, "<>"))
     5ee:	8656                	mv	a2,s5
     5f0:	85ca                	mv	a1,s2
     5f2:	854e                	mv	a0,s3
     5f4:	00000097          	auipc	ra,0x0
     5f8:	f38080e7          	jalr	-200(ra) # 52c <peek>
     5fc:	cd25                	beqz	a0,674 <parseredirs+0xdc>
        tok = gettoken(ps, es, 0, 0);
     5fe:	4681                	li	a3,0
     600:	4601                	li	a2,0
     602:	85ca                	mv	a1,s2
     604:	854e                	mv	a0,s3
     606:	00000097          	auipc	ra,0x0
     60a:	dda080e7          	jalr	-550(ra) # 3e0 <gettoken>
     60e:	84aa                	mv	s1,a0
        if (gettoken(ps, es, &q, &eq) != 'a')
     610:	fa040693          	addi	a3,s0,-96
     614:	fa840613          	addi	a2,s0,-88
     618:	85ca                	mv	a1,s2
     61a:	854e                	mv	a0,s3
     61c:	00000097          	auipc	ra,0x0
     620:	dc4080e7          	jalr	-572(ra) # 3e0 <gettoken>
     624:	fb6511e3          	bne	a0,s6,5c6 <parseredirs+0x2e>
        switch (tok)
     628:	fb7487e3          	beq	s1,s7,5d6 <parseredirs+0x3e>
     62c:	03e00793          	li	a5,62
     630:	02f48463          	beq	s1,a5,658 <parseredirs+0xc0>
     634:	02b00793          	li	a5,43
     638:	faf49be3          	bne	s1,a5,5ee <parseredirs+0x56>
            break;
        case '>':
            cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE | O_TRUNC, 1);
            break;
        case '+': // >>
            cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE, 1);
     63c:	4705                	li	a4,1
     63e:	20100693          	li	a3,513
     642:	fa043603          	ld	a2,-96(s0)
     646:	fa843583          	ld	a1,-88(s0)
     64a:	8552                	mv	a0,s4
     64c:	00000097          	auipc	ra,0x0
     650:	c64080e7          	jalr	-924(ra) # 2b0 <redircmd>
     654:	8a2a                	mv	s4,a0
            break;
     656:	bf61                	j	5ee <parseredirs+0x56>
            cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE | O_TRUNC, 1);
     658:	4705                	li	a4,1
     65a:	60100693          	li	a3,1537
     65e:	fa043603          	ld	a2,-96(s0)
     662:	fa843583          	ld	a1,-88(s0)
     666:	8552                	mv	a0,s4
     668:	00000097          	auipc	ra,0x0
     66c:	c48080e7          	jalr	-952(ra) # 2b0 <redircmd>
     670:	8a2a                	mv	s4,a0
            break;
     672:	bfb5                	j	5ee <parseredirs+0x56>
        }
    }
    return cmd;
}
     674:	8552                	mv	a0,s4
     676:	60e6                	ld	ra,88(sp)
     678:	6446                	ld	s0,80(sp)
     67a:	64a6                	ld	s1,72(sp)
     67c:	6906                	ld	s2,64(sp)
     67e:	79e2                	ld	s3,56(sp)
     680:	7a42                	ld	s4,48(sp)
     682:	7aa2                	ld	s5,40(sp)
     684:	7b02                	ld	s6,32(sp)
     686:	6be2                	ld	s7,24(sp)
     688:	6125                	addi	sp,sp,96
     68a:	8082                	ret

000000000000068c <parseexec>:
    return cmd;
}

struct cmd *
parseexec(char **ps, char *es)
{
     68c:	7159                	addi	sp,sp,-112
     68e:	f486                	sd	ra,104(sp)
     690:	f0a2                	sd	s0,96(sp)
     692:	eca6                	sd	s1,88(sp)
     694:	e0d2                	sd	s4,64(sp)
     696:	fc56                	sd	s5,56(sp)
     698:	1880                	addi	s0,sp,112
     69a:	8a2a                	mv	s4,a0
     69c:	8aae                	mv	s5,a1
    char *q, *eq;
    int tok, argc;
    struct execcmd *cmd;
    struct cmd *ret;

    if (peek(ps, es, "("))
     69e:	00001617          	auipc	a2,0x1
     6a2:	e2a60613          	addi	a2,a2,-470 # 14c8 <malloc+0x17a>
     6a6:	00000097          	auipc	ra,0x0
     6aa:	e86080e7          	jalr	-378(ra) # 52c <peek>
     6ae:	ed15                	bnez	a0,6ea <parseexec+0x5e>
     6b0:	e8ca                	sd	s2,80(sp)
     6b2:	e4ce                	sd	s3,72(sp)
     6b4:	f85a                	sd	s6,48(sp)
     6b6:	f45e                	sd	s7,40(sp)
     6b8:	f062                	sd	s8,32(sp)
     6ba:	ec66                	sd	s9,24(sp)
     6bc:	89aa                	mv	s3,a0
        return parseblock(ps, es);

    ret = execcmd();
     6be:	00000097          	auipc	ra,0x0
     6c2:	bbc080e7          	jalr	-1092(ra) # 27a <execcmd>
     6c6:	8c2a                	mv	s8,a0
    cmd = (struct execcmd *)ret;

    argc = 0;
    ret = parseredirs(ret, ps, es);
     6c8:	8656                	mv	a2,s5
     6ca:	85d2                	mv	a1,s4
     6cc:	00000097          	auipc	ra,0x0
     6d0:	ecc080e7          	jalr	-308(ra) # 598 <parseredirs>
     6d4:	84aa                	mv	s1,a0
    while (!peek(ps, es, "|)&;"))
     6d6:	008c0913          	addi	s2,s8,8
     6da:	00001b17          	auipc	s6,0x1
     6de:	e0eb0b13          	addi	s6,s6,-498 # 14e8 <malloc+0x19a>
    {
        if ((tok = gettoken(ps, es, &q, &eq)) == 0)
            break;
        if (tok != 'a')
     6e2:	06100c93          	li	s9,97
            panic("syntax");
        cmd->argv[argc] = q;
        cmd->eargv[argc] = eq;
        argc++;
        if (argc >= MAXARGS)
     6e6:	4ba9                	li	s7,10
    while (!peek(ps, es, "|)&;"))
     6e8:	a081                	j	728 <parseexec+0x9c>
        return parseblock(ps, es);
     6ea:	85d6                	mv	a1,s5
     6ec:	8552                	mv	a0,s4
     6ee:	00000097          	auipc	ra,0x0
     6f2:	1bc080e7          	jalr	444(ra) # 8aa <parseblock>
     6f6:	84aa                	mv	s1,a0
        ret = parseredirs(ret, ps, es);
    }
    cmd->argv[argc] = 0;
    cmd->eargv[argc] = 0;
    return ret;
}
     6f8:	8526                	mv	a0,s1
     6fa:	70a6                	ld	ra,104(sp)
     6fc:	7406                	ld	s0,96(sp)
     6fe:	64e6                	ld	s1,88(sp)
     700:	6a06                	ld	s4,64(sp)
     702:	7ae2                	ld	s5,56(sp)
     704:	6165                	addi	sp,sp,112
     706:	8082                	ret
            panic("syntax");
     708:	00001517          	auipc	a0,0x1
     70c:	dc850513          	addi	a0,a0,-568 # 14d0 <malloc+0x182>
     710:	00000097          	auipc	ra,0x0
     714:	946080e7          	jalr	-1722(ra) # 56 <panic>
        ret = parseredirs(ret, ps, es);
     718:	8656                	mv	a2,s5
     71a:	85d2                	mv	a1,s4
     71c:	8526                	mv	a0,s1
     71e:	00000097          	auipc	ra,0x0
     722:	e7a080e7          	jalr	-390(ra) # 598 <parseredirs>
     726:	84aa                	mv	s1,a0
    while (!peek(ps, es, "|)&;"))
     728:	865a                	mv	a2,s6
     72a:	85d6                	mv	a1,s5
     72c:	8552                	mv	a0,s4
     72e:	00000097          	auipc	ra,0x0
     732:	dfe080e7          	jalr	-514(ra) # 52c <peek>
     736:	e131                	bnez	a0,77a <parseexec+0xee>
        if ((tok = gettoken(ps, es, &q, &eq)) == 0)
     738:	f9040693          	addi	a3,s0,-112
     73c:	f9840613          	addi	a2,s0,-104
     740:	85d6                	mv	a1,s5
     742:	8552                	mv	a0,s4
     744:	00000097          	auipc	ra,0x0
     748:	c9c080e7          	jalr	-868(ra) # 3e0 <gettoken>
     74c:	c51d                	beqz	a0,77a <parseexec+0xee>
        if (tok != 'a')
     74e:	fb951de3          	bne	a0,s9,708 <parseexec+0x7c>
        cmd->argv[argc] = q;
     752:	f9843783          	ld	a5,-104(s0)
     756:	00f93023          	sd	a5,0(s2)
        cmd->eargv[argc] = eq;
     75a:	f9043783          	ld	a5,-112(s0)
     75e:	04f93823          	sd	a5,80(s2)
        argc++;
     762:	2985                	addiw	s3,s3,1
        if (argc >= MAXARGS)
     764:	0921                	addi	s2,s2,8
     766:	fb7999e3          	bne	s3,s7,718 <parseexec+0x8c>
            panic("too many args");
     76a:	00001517          	auipc	a0,0x1
     76e:	d6e50513          	addi	a0,a0,-658 # 14d8 <malloc+0x18a>
     772:	00000097          	auipc	ra,0x0
     776:	8e4080e7          	jalr	-1820(ra) # 56 <panic>
    cmd->argv[argc] = 0;
     77a:	098e                	slli	s3,s3,0x3
     77c:	9c4e                	add	s8,s8,s3
     77e:	000c3423          	sd	zero,8(s8)
    cmd->eargv[argc] = 0;
     782:	040c3c23          	sd	zero,88(s8)
     786:	6946                	ld	s2,80(sp)
     788:	69a6                	ld	s3,72(sp)
     78a:	7b42                	ld	s6,48(sp)
     78c:	7ba2                	ld	s7,40(sp)
     78e:	7c02                	ld	s8,32(sp)
     790:	6ce2                	ld	s9,24(sp)
    return ret;
     792:	b79d                	j	6f8 <parseexec+0x6c>

0000000000000794 <parsepipe>:
{
     794:	7179                	addi	sp,sp,-48
     796:	f406                	sd	ra,40(sp)
     798:	f022                	sd	s0,32(sp)
     79a:	ec26                	sd	s1,24(sp)
     79c:	e84a                	sd	s2,16(sp)
     79e:	e44e                	sd	s3,8(sp)
     7a0:	1800                	addi	s0,sp,48
     7a2:	892a                	mv	s2,a0
     7a4:	89ae                	mv	s3,a1
    cmd = parseexec(ps, es);
     7a6:	00000097          	auipc	ra,0x0
     7aa:	ee6080e7          	jalr	-282(ra) # 68c <parseexec>
     7ae:	84aa                	mv	s1,a0
    if (peek(ps, es, "|"))
     7b0:	00001617          	auipc	a2,0x1
     7b4:	d4060613          	addi	a2,a2,-704 # 14f0 <malloc+0x1a2>
     7b8:	85ce                	mv	a1,s3
     7ba:	854a                	mv	a0,s2
     7bc:	00000097          	auipc	ra,0x0
     7c0:	d70080e7          	jalr	-656(ra) # 52c <peek>
     7c4:	e909                	bnez	a0,7d6 <parsepipe+0x42>
}
     7c6:	8526                	mv	a0,s1
     7c8:	70a2                	ld	ra,40(sp)
     7ca:	7402                	ld	s0,32(sp)
     7cc:	64e2                	ld	s1,24(sp)
     7ce:	6942                	ld	s2,16(sp)
     7d0:	69a2                	ld	s3,8(sp)
     7d2:	6145                	addi	sp,sp,48
     7d4:	8082                	ret
        gettoken(ps, es, 0, 0);
     7d6:	4681                	li	a3,0
     7d8:	4601                	li	a2,0
     7da:	85ce                	mv	a1,s3
     7dc:	854a                	mv	a0,s2
     7de:	00000097          	auipc	ra,0x0
     7e2:	c02080e7          	jalr	-1022(ra) # 3e0 <gettoken>
        cmd = pipecmd(cmd, parsepipe(ps, es));
     7e6:	85ce                	mv	a1,s3
     7e8:	854a                	mv	a0,s2
     7ea:	00000097          	auipc	ra,0x0
     7ee:	faa080e7          	jalr	-86(ra) # 794 <parsepipe>
     7f2:	85aa                	mv	a1,a0
     7f4:	8526                	mv	a0,s1
     7f6:	00000097          	auipc	ra,0x0
     7fa:	b22080e7          	jalr	-1246(ra) # 318 <pipecmd>
     7fe:	84aa                	mv	s1,a0
    return cmd;
     800:	b7d9                	j	7c6 <parsepipe+0x32>

0000000000000802 <parseline>:
{
     802:	7179                	addi	sp,sp,-48
     804:	f406                	sd	ra,40(sp)
     806:	f022                	sd	s0,32(sp)
     808:	ec26                	sd	s1,24(sp)
     80a:	e84a                	sd	s2,16(sp)
     80c:	e44e                	sd	s3,8(sp)
     80e:	e052                	sd	s4,0(sp)
     810:	1800                	addi	s0,sp,48
     812:	892a                	mv	s2,a0
     814:	89ae                	mv	s3,a1
    cmd = parsepipe(ps, es);
     816:	00000097          	auipc	ra,0x0
     81a:	f7e080e7          	jalr	-130(ra) # 794 <parsepipe>
     81e:	84aa                	mv	s1,a0
    while (peek(ps, es, "&"))
     820:	00001a17          	auipc	s4,0x1
     824:	cd8a0a13          	addi	s4,s4,-808 # 14f8 <malloc+0x1aa>
     828:	a839                	j	846 <parseline+0x44>
        gettoken(ps, es, 0, 0);
     82a:	4681                	li	a3,0
     82c:	4601                	li	a2,0
     82e:	85ce                	mv	a1,s3
     830:	854a                	mv	a0,s2
     832:	00000097          	auipc	ra,0x0
     836:	bae080e7          	jalr	-1106(ra) # 3e0 <gettoken>
        cmd = backcmd(cmd);
     83a:	8526                	mv	a0,s1
     83c:	00000097          	auipc	ra,0x0
     840:	b68080e7          	jalr	-1176(ra) # 3a4 <backcmd>
     844:	84aa                	mv	s1,a0
    while (peek(ps, es, "&"))
     846:	8652                	mv	a2,s4
     848:	85ce                	mv	a1,s3
     84a:	854a                	mv	a0,s2
     84c:	00000097          	auipc	ra,0x0
     850:	ce0080e7          	jalr	-800(ra) # 52c <peek>
     854:	f979                	bnez	a0,82a <parseline+0x28>
    if (peek(ps, es, ";"))
     856:	00001617          	auipc	a2,0x1
     85a:	caa60613          	addi	a2,a2,-854 # 1500 <malloc+0x1b2>
     85e:	85ce                	mv	a1,s3
     860:	854a                	mv	a0,s2
     862:	00000097          	auipc	ra,0x0
     866:	cca080e7          	jalr	-822(ra) # 52c <peek>
     86a:	e911                	bnez	a0,87e <parseline+0x7c>
}
     86c:	8526                	mv	a0,s1
     86e:	70a2                	ld	ra,40(sp)
     870:	7402                	ld	s0,32(sp)
     872:	64e2                	ld	s1,24(sp)
     874:	6942                	ld	s2,16(sp)
     876:	69a2                	ld	s3,8(sp)
     878:	6a02                	ld	s4,0(sp)
     87a:	6145                	addi	sp,sp,48
     87c:	8082                	ret
        gettoken(ps, es, 0, 0);
     87e:	4681                	li	a3,0
     880:	4601                	li	a2,0
     882:	85ce                	mv	a1,s3
     884:	854a                	mv	a0,s2
     886:	00000097          	auipc	ra,0x0
     88a:	b5a080e7          	jalr	-1190(ra) # 3e0 <gettoken>
        cmd = listcmd(cmd, parseline(ps, es));
     88e:	85ce                	mv	a1,s3
     890:	854a                	mv	a0,s2
     892:	00000097          	auipc	ra,0x0
     896:	f70080e7          	jalr	-144(ra) # 802 <parseline>
     89a:	85aa                	mv	a1,a0
     89c:	8526                	mv	a0,s1
     89e:	00000097          	auipc	ra,0x0
     8a2:	ac0080e7          	jalr	-1344(ra) # 35e <listcmd>
     8a6:	84aa                	mv	s1,a0
    return cmd;
     8a8:	b7d1                	j	86c <parseline+0x6a>

00000000000008aa <parseblock>:
{
     8aa:	7179                	addi	sp,sp,-48
     8ac:	f406                	sd	ra,40(sp)
     8ae:	f022                	sd	s0,32(sp)
     8b0:	ec26                	sd	s1,24(sp)
     8b2:	e84a                	sd	s2,16(sp)
     8b4:	e44e                	sd	s3,8(sp)
     8b6:	1800                	addi	s0,sp,48
     8b8:	84aa                	mv	s1,a0
     8ba:	892e                	mv	s2,a1
    if (!peek(ps, es, "("))
     8bc:	00001617          	auipc	a2,0x1
     8c0:	c0c60613          	addi	a2,a2,-1012 # 14c8 <malloc+0x17a>
     8c4:	00000097          	auipc	ra,0x0
     8c8:	c68080e7          	jalr	-920(ra) # 52c <peek>
     8cc:	c12d                	beqz	a0,92e <parseblock+0x84>
    gettoken(ps, es, 0, 0);
     8ce:	4681                	li	a3,0
     8d0:	4601                	li	a2,0
     8d2:	85ca                	mv	a1,s2
     8d4:	8526                	mv	a0,s1
     8d6:	00000097          	auipc	ra,0x0
     8da:	b0a080e7          	jalr	-1270(ra) # 3e0 <gettoken>
    cmd = parseline(ps, es);
     8de:	85ca                	mv	a1,s2
     8e0:	8526                	mv	a0,s1
     8e2:	00000097          	auipc	ra,0x0
     8e6:	f20080e7          	jalr	-224(ra) # 802 <parseline>
     8ea:	89aa                	mv	s3,a0
    if (!peek(ps, es, ")"))
     8ec:	00001617          	auipc	a2,0x1
     8f0:	c2c60613          	addi	a2,a2,-980 # 1518 <malloc+0x1ca>
     8f4:	85ca                	mv	a1,s2
     8f6:	8526                	mv	a0,s1
     8f8:	00000097          	auipc	ra,0x0
     8fc:	c34080e7          	jalr	-972(ra) # 52c <peek>
     900:	cd1d                	beqz	a0,93e <parseblock+0x94>
    gettoken(ps, es, 0, 0);
     902:	4681                	li	a3,0
     904:	4601                	li	a2,0
     906:	85ca                	mv	a1,s2
     908:	8526                	mv	a0,s1
     90a:	00000097          	auipc	ra,0x0
     90e:	ad6080e7          	jalr	-1322(ra) # 3e0 <gettoken>
    cmd = parseredirs(cmd, ps, es);
     912:	864a                	mv	a2,s2
     914:	85a6                	mv	a1,s1
     916:	854e                	mv	a0,s3
     918:	00000097          	auipc	ra,0x0
     91c:	c80080e7          	jalr	-896(ra) # 598 <parseredirs>
}
     920:	70a2                	ld	ra,40(sp)
     922:	7402                	ld	s0,32(sp)
     924:	64e2                	ld	s1,24(sp)
     926:	6942                	ld	s2,16(sp)
     928:	69a2                	ld	s3,8(sp)
     92a:	6145                	addi	sp,sp,48
     92c:	8082                	ret
        panic("parseblock");
     92e:	00001517          	auipc	a0,0x1
     932:	bda50513          	addi	a0,a0,-1062 # 1508 <malloc+0x1ba>
     936:	fffff097          	auipc	ra,0xfffff
     93a:	720080e7          	jalr	1824(ra) # 56 <panic>
        panic("syntax - missing )");
     93e:	00001517          	auipc	a0,0x1
     942:	be250513          	addi	a0,a0,-1054 # 1520 <malloc+0x1d2>
     946:	fffff097          	auipc	ra,0xfffff
     94a:	710080e7          	jalr	1808(ra) # 56 <panic>

000000000000094e <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd *
nulterminate(struct cmd *cmd)
{
     94e:	1101                	addi	sp,sp,-32
     950:	ec06                	sd	ra,24(sp)
     952:	e822                	sd	s0,16(sp)
     954:	e426                	sd	s1,8(sp)
     956:	1000                	addi	s0,sp,32
     958:	84aa                	mv	s1,a0
    struct execcmd *ecmd;
    struct listcmd *lcmd;
    struct pipecmd *pcmd;
    struct redircmd *rcmd;

    if (cmd == 0)
     95a:	c521                	beqz	a0,9a2 <nulterminate+0x54>
        return 0;

    switch (cmd->type)
     95c:	4118                	lw	a4,0(a0)
     95e:	4795                	li	a5,5
     960:	04e7e163          	bltu	a5,a4,9a2 <nulterminate+0x54>
     964:	00056783          	lwu	a5,0(a0)
     968:	078a                	slli	a5,a5,0x2
     96a:	00001717          	auipc	a4,0x1
     96e:	c2e70713          	addi	a4,a4,-978 # 1598 <malloc+0x24a>
     972:	97ba                	add	a5,a5,a4
     974:	439c                	lw	a5,0(a5)
     976:	97ba                	add	a5,a5,a4
     978:	8782                	jr	a5
    {
    case EXEC:
        ecmd = (struct execcmd *)cmd;
        for (i = 0; ecmd->argv[i]; i++)
     97a:	651c                	ld	a5,8(a0)
     97c:	c39d                	beqz	a5,9a2 <nulterminate+0x54>
     97e:	01050793          	addi	a5,a0,16
            *ecmd->eargv[i] = 0;
     982:	67b8                	ld	a4,72(a5)
     984:	00070023          	sb	zero,0(a4)
        for (i = 0; ecmd->argv[i]; i++)
     988:	07a1                	addi	a5,a5,8
     98a:	ff87b703          	ld	a4,-8(a5)
     98e:	fb75                	bnez	a4,982 <nulterminate+0x34>
     990:	a809                	j	9a2 <nulterminate+0x54>
        break;

    case REDIR:
        rcmd = (struct redircmd *)cmd;
        nulterminate(rcmd->cmd);
     992:	6508                	ld	a0,8(a0)
     994:	00000097          	auipc	ra,0x0
     998:	fba080e7          	jalr	-70(ra) # 94e <nulterminate>
        *rcmd->efile = 0;
     99c:	6c9c                	ld	a5,24(s1)
     99e:	00078023          	sb	zero,0(a5)
        bcmd = (struct backcmd *)cmd;
        nulterminate(bcmd->cmd);
        break;
    }
    return cmd;
}
     9a2:	8526                	mv	a0,s1
     9a4:	60e2                	ld	ra,24(sp)
     9a6:	6442                	ld	s0,16(sp)
     9a8:	64a2                	ld	s1,8(sp)
     9aa:	6105                	addi	sp,sp,32
     9ac:	8082                	ret
        nulterminate(pcmd->left);
     9ae:	6508                	ld	a0,8(a0)
     9b0:	00000097          	auipc	ra,0x0
     9b4:	f9e080e7          	jalr	-98(ra) # 94e <nulterminate>
        nulterminate(pcmd->right);
     9b8:	6888                	ld	a0,16(s1)
     9ba:	00000097          	auipc	ra,0x0
     9be:	f94080e7          	jalr	-108(ra) # 94e <nulterminate>
        break;
     9c2:	b7c5                	j	9a2 <nulterminate+0x54>
        nulterminate(lcmd->left);
     9c4:	6508                	ld	a0,8(a0)
     9c6:	00000097          	auipc	ra,0x0
     9ca:	f88080e7          	jalr	-120(ra) # 94e <nulterminate>
        nulterminate(lcmd->right);
     9ce:	6888                	ld	a0,16(s1)
     9d0:	00000097          	auipc	ra,0x0
     9d4:	f7e080e7          	jalr	-130(ra) # 94e <nulterminate>
        break;
     9d8:	b7e9                	j	9a2 <nulterminate+0x54>
        nulterminate(bcmd->cmd);
     9da:	6508                	ld	a0,8(a0)
     9dc:	00000097          	auipc	ra,0x0
     9e0:	f72080e7          	jalr	-142(ra) # 94e <nulterminate>
        break;
     9e4:	bf7d                	j	9a2 <nulterminate+0x54>

00000000000009e6 <parsecmd>:
{
     9e6:	7179                	addi	sp,sp,-48
     9e8:	f406                	sd	ra,40(sp)
     9ea:	f022                	sd	s0,32(sp)
     9ec:	ec26                	sd	s1,24(sp)
     9ee:	e84a                	sd	s2,16(sp)
     9f0:	1800                	addi	s0,sp,48
     9f2:	fca43c23          	sd	a0,-40(s0)
    es = s + strlen(s);
     9f6:	84aa                	mv	s1,a0
     9f8:	00000097          	auipc	ra,0x0
     9fc:	2ea080e7          	jalr	746(ra) # ce2 <strlen>
     a00:	1502                	slli	a0,a0,0x20
     a02:	9101                	srli	a0,a0,0x20
     a04:	94aa                	add	s1,s1,a0
    cmd = parseline(&s, es);
     a06:	85a6                	mv	a1,s1
     a08:	fd840513          	addi	a0,s0,-40
     a0c:	00000097          	auipc	ra,0x0
     a10:	df6080e7          	jalr	-522(ra) # 802 <parseline>
     a14:	892a                	mv	s2,a0
    peek(&s, es, "");
     a16:	00001617          	auipc	a2,0x1
     a1a:	a4260613          	addi	a2,a2,-1470 # 1458 <malloc+0x10a>
     a1e:	85a6                	mv	a1,s1
     a20:	fd840513          	addi	a0,s0,-40
     a24:	00000097          	auipc	ra,0x0
     a28:	b08080e7          	jalr	-1272(ra) # 52c <peek>
    if (s != es)
     a2c:	fd843603          	ld	a2,-40(s0)
     a30:	00961e63          	bne	a2,s1,a4c <parsecmd+0x66>
    nulterminate(cmd);
     a34:	854a                	mv	a0,s2
     a36:	00000097          	auipc	ra,0x0
     a3a:	f18080e7          	jalr	-232(ra) # 94e <nulterminate>
}
     a3e:	854a                	mv	a0,s2
     a40:	70a2                	ld	ra,40(sp)
     a42:	7402                	ld	s0,32(sp)
     a44:	64e2                	ld	s1,24(sp)
     a46:	6942                	ld	s2,16(sp)
     a48:	6145                	addi	sp,sp,48
     a4a:	8082                	ret
        fprintf(2, "leftovers: %s\n", s);
     a4c:	00001597          	auipc	a1,0x1
     a50:	aec58593          	addi	a1,a1,-1300 # 1538 <malloc+0x1ea>
     a54:	4509                	li	a0,2
     a56:	00001097          	auipc	ra,0x1
     a5a:	812080e7          	jalr	-2030(ra) # 1268 <fprintf>
        panic("syntax");
     a5e:	00001517          	auipc	a0,0x1
     a62:	a7250513          	addi	a0,a0,-1422 # 14d0 <malloc+0x182>
     a66:	fffff097          	auipc	ra,0xfffff
     a6a:	5f0080e7          	jalr	1520(ra) # 56 <panic>

0000000000000a6e <parse_buffer>:
{
     a6e:	1101                	addi	sp,sp,-32
     a70:	ec06                	sd	ra,24(sp)
     a72:	e822                	sd	s0,16(sp)
     a74:	e426                	sd	s1,8(sp)
     a76:	1000                	addi	s0,sp,32
     a78:	84aa                	mv	s1,a0
    if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ')
     a7a:	00054783          	lbu	a5,0(a0)
     a7e:	06300713          	li	a4,99
     a82:	02e78b63          	beq	a5,a4,ab8 <parse_buffer+0x4a>
    if (buf[0] == 'e' &&
     a86:	06500713          	li	a4,101
     a8a:	00e79863          	bne	a5,a4,a9a <parse_buffer+0x2c>
     a8e:	00154703          	lbu	a4,1(a0)
     a92:	07800793          	li	a5,120
     a96:	06f70b63          	beq	a4,a5,b0c <parse_buffer+0x9e>
    if (fork1() == 0)
     a9a:	fffff097          	auipc	ra,0xfffff
     a9e:	5e2080e7          	jalr	1506(ra) # 7c <fork1>
     aa2:	c551                	beqz	a0,b2e <parse_buffer+0xc0>
    wait(0);
     aa4:	4501                	li	a0,0
     aa6:	00000097          	auipc	ra,0x0
     aaa:	468080e7          	jalr	1128(ra) # f0e <wait>
}
     aae:	60e2                	ld	ra,24(sp)
     ab0:	6442                	ld	s0,16(sp)
     ab2:	64a2                	ld	s1,8(sp)
     ab4:	6105                	addi	sp,sp,32
     ab6:	8082                	ret
    if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ')
     ab8:	00154703          	lbu	a4,1(a0)
     abc:	06400793          	li	a5,100
     ac0:	fcf71de3          	bne	a4,a5,a9a <parse_buffer+0x2c>
     ac4:	00254703          	lbu	a4,2(a0)
     ac8:	02000793          	li	a5,32
     acc:	fcf717e3          	bne	a4,a5,a9a <parse_buffer+0x2c>
        buf[strlen(buf) - 1] = 0; // chop \n
     ad0:	00000097          	auipc	ra,0x0
     ad4:	212080e7          	jalr	530(ra) # ce2 <strlen>
     ad8:	fff5079b          	addiw	a5,a0,-1
     adc:	1782                	slli	a5,a5,0x20
     ade:	9381                	srli	a5,a5,0x20
     ae0:	97a6                	add	a5,a5,s1
     ae2:	00078023          	sb	zero,0(a5)
        if (chdir(buf + 3) < 0)
     ae6:	048d                	addi	s1,s1,3
     ae8:	8526                	mv	a0,s1
     aea:	00000097          	auipc	ra,0x0
     aee:	48c080e7          	jalr	1164(ra) # f76 <chdir>
     af2:	fa055ee3          	bgez	a0,aae <parse_buffer+0x40>
            fprintf(2, "cannot cd %s\n", buf + 3);
     af6:	8626                	mv	a2,s1
     af8:	00001597          	auipc	a1,0x1
     afc:	a5058593          	addi	a1,a1,-1456 # 1548 <malloc+0x1fa>
     b00:	4509                	li	a0,2
     b02:	00000097          	auipc	ra,0x0
     b06:	766080e7          	jalr	1894(ra) # 1268 <fprintf>
     b0a:	b755                	j	aae <parse_buffer+0x40>
        buf[1] == 'x' &&
     b0c:	00254703          	lbu	a4,2(a0)
     b10:	06900793          	li	a5,105
     b14:	f8f713e3          	bne	a4,a5,a9a <parse_buffer+0x2c>
        buf[2] == 'i' &&
     b18:	00354703          	lbu	a4,3(a0)
     b1c:	07400793          	li	a5,116
     b20:	f6f71de3          	bne	a4,a5,a9a <parse_buffer+0x2c>
        exit(0);
     b24:	4501                	li	a0,0
     b26:	00000097          	auipc	ra,0x0
     b2a:	3e0080e7          	jalr	992(ra) # f06 <exit>
        runcmd(parsecmd(buf));
     b2e:	8526                	mv	a0,s1
     b30:	00000097          	auipc	ra,0x0
     b34:	eb6080e7          	jalr	-330(ra) # 9e6 <parsecmd>
     b38:	fffff097          	auipc	ra,0xfffff
     b3c:	572080e7          	jalr	1394(ra) # aa <runcmd>

0000000000000b40 <main>:
{
     b40:	711d                	addi	sp,sp,-96
     b42:	ec86                	sd	ra,88(sp)
     b44:	e8a2                	sd	s0,80(sp)
     b46:	e4a6                	sd	s1,72(sp)
     b48:	e0ca                	sd	s2,64(sp)
     b4a:	fc4e                	sd	s3,56(sp)
     b4c:	1080                	addi	s0,sp,96
     b4e:	892a                	mv	s2,a0
     b50:	89ae                	mv	s3,a1
    while ((fd = open("console", O_RDWR)) >= 0)
     b52:	00001497          	auipc	s1,0x1
     b56:	a0648493          	addi	s1,s1,-1530 # 1558 <malloc+0x20a>
     b5a:	4589                	li	a1,2
     b5c:	8526                	mv	a0,s1
     b5e:	00000097          	auipc	ra,0x0
     b62:	3e8080e7          	jalr	1000(ra) # f46 <open>
     b66:	00054963          	bltz	a0,b78 <main+0x38>
        if (fd >= 3)
     b6a:	4789                	li	a5,2
     b6c:	fea7d7e3          	bge	a5,a0,b5a <main+0x1a>
            close(fd);
     b70:	00000097          	auipc	ra,0x0
     b74:	3be080e7          	jalr	958(ra) # f2e <close>
    if (argc == 2)
     b78:	4789                	li	a5,2
    while (getcmd(buf, sizeof(buf)) >= 0)
     b7a:	00002497          	auipc	s1,0x2
     b7e:	cc648493          	addi	s1,s1,-826 # 2840 <buf.0>
    if (argc == 2)
     b82:	00f90763          	beq	s2,a5,b90 <main+0x50>
     b86:	f852                	sd	s4,48(sp)
     b88:	f456                	sd	s5,40(sp)
     b8a:	f05a                	sd	s6,32(sp)
     b8c:	ec5e                	sd	s7,24(sp)
     b8e:	a85d                	j	c44 <main+0x104>
        char *shell_script_file = argv[1];
     b90:	0089b483          	ld	s1,8(s3)
        int shfd = open(shell_script_file, O_RDWR);
     b94:	4589                	li	a1,2
     b96:	8526                	mv	a0,s1
     b98:	00000097          	auipc	ra,0x0
     b9c:	3ae080e7          	jalr	942(ra) # f46 <open>
     ba0:	89aa                	mv	s3,a0
        if (shfd < 0)
     ba2:	00054f63          	bltz	a0,bc0 <main+0x80>
     ba6:	f852                	sd	s4,48(sp)
     ba8:	f456                	sd	s5,40(sp)
     baa:	f05a                	sd	s6,32(sp)
     bac:	ec5e                	sd	s7,24(sp)
            memset(buf, 0, 120);
     bae:	00002b97          	auipc	s7,0x2
     bb2:	c92b8b93          	addi	s7,s7,-878 # 2840 <buf.0>
                if (c == '\n' || c == '\r')
     bb6:	4a29                	li	s4,10
     bb8:	4ab5                	li	s5,13
            for (i = 0; i + 1 < 120;)
     bba:	07700b13          	li	s6,119
     bbe:	a81d                	j	bf4 <main+0xb4>
     bc0:	f852                	sd	s4,48(sp)
     bc2:	f456                	sd	s5,40(sp)
     bc4:	f05a                	sd	s6,32(sp)
     bc6:	ec5e                	sd	s7,24(sp)
            printf("Failed to open %s\n", shell_script_file);
     bc8:	85a6                	mv	a1,s1
     bca:	00001517          	auipc	a0,0x1
     bce:	99650513          	addi	a0,a0,-1642 # 1560 <malloc+0x212>
     bd2:	00000097          	auipc	ra,0x0
     bd6:	6c4080e7          	jalr	1732(ra) # 1296 <printf>
            exit(1);
     bda:	4505                	li	a0,1
     bdc:	00000097          	auipc	ra,0x0
     be0:	32a080e7          	jalr	810(ra) # f06 <exit>
            buf[i] = '\0';
     be4:	94de                	add	s1,s1,s7
     be6:	00048023          	sb	zero,0(s1)
            parse_buffer(buf);
     bea:	855e                	mv	a0,s7
     bec:	00000097          	auipc	ra,0x0
     bf0:	e82080e7          	jalr	-382(ra) # a6e <parse_buffer>
            memset(buf, 0, 120);
     bf4:	07800613          	li	a2,120
     bf8:	4581                	li	a1,0
     bfa:	855e                	mv	a0,s7
     bfc:	00000097          	auipc	ra,0x0
     c00:	110080e7          	jalr	272(ra) # d0c <memset>
            for (i = 0; i + 1 < 120;)
     c04:	895e                	mv	s2,s7
     c06:	4481                	li	s1,0
                cr = read(shfd, &c, 1);
     c08:	4605                	li	a2,1
     c0a:	faf40593          	addi	a1,s0,-81
     c0e:	854e                	mv	a0,s3
     c10:	00000097          	auipc	ra,0x0
     c14:	30e080e7          	jalr	782(ra) # f1e <read>
                if (cr < 1)
     c18:	04a05463          	blez	a0,c60 <main+0x120>
                if (c == '\n' || c == '\r')
     c1c:	faf44783          	lbu	a5,-81(s0)
     c20:	fd4782e3          	beq	a5,s4,be4 <main+0xa4>
     c24:	fd5780e3          	beq	a5,s5,be4 <main+0xa4>
                buf[i++] = c;
     c28:	2485                	addiw	s1,s1,1
     c2a:	0ff4f493          	zext.b	s1,s1
     c2e:	00f90023          	sb	a5,0(s2)
            for (i = 0; i + 1 < 120;)
     c32:	0905                	addi	s2,s2,1
     c34:	fd649ae3          	bne	s1,s6,c08 <main+0xc8>
     c38:	b775                	j	be4 <main+0xa4>
        parse_buffer(buf);
     c3a:	8526                	mv	a0,s1
     c3c:	00000097          	auipc	ra,0x0
     c40:	e32080e7          	jalr	-462(ra) # a6e <parse_buffer>
    while (getcmd(buf, sizeof(buf)) >= 0)
     c44:	07800593          	li	a1,120
     c48:	8526                	mv	a0,s1
     c4a:	fffff097          	auipc	ra,0xfffff
     c4e:	3b6080e7          	jalr	950(ra) # 0 <getcmd>
     c52:	fe0554e3          	bgez	a0,c3a <main+0xfa>
    exit(0);
     c56:	4501                	li	a0,0
     c58:	00000097          	auipc	ra,0x0
     c5c:	2ae080e7          	jalr	686(ra) # f06 <exit>
            buf[i] = '\0';
     c60:	00002517          	auipc	a0,0x2
     c64:	be050513          	addi	a0,a0,-1056 # 2840 <buf.0>
     c68:	94aa                	add	s1,s1,a0
     c6a:	00048023          	sb	zero,0(s1)
            parse_buffer(buf);
     c6e:	00000097          	auipc	ra,0x0
     c72:	e00080e7          	jalr	-512(ra) # a6e <parse_buffer>
        exit(0);
     c76:	4501                	li	a0,0
     c78:	00000097          	auipc	ra,0x0
     c7c:	28e080e7          	jalr	654(ra) # f06 <exit>

0000000000000c80 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     c80:	1141                	addi	sp,sp,-16
     c82:	e406                	sd	ra,8(sp)
     c84:	e022                	sd	s0,0(sp)
     c86:	0800                	addi	s0,sp,16
  extern int main();
  main();
     c88:	00000097          	auipc	ra,0x0
     c8c:	eb8080e7          	jalr	-328(ra) # b40 <main>
  exit(0);
     c90:	4501                	li	a0,0
     c92:	00000097          	auipc	ra,0x0
     c96:	274080e7          	jalr	628(ra) # f06 <exit>

0000000000000c9a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     c9a:	1141                	addi	sp,sp,-16
     c9c:	e422                	sd	s0,8(sp)
     c9e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     ca0:	87aa                	mv	a5,a0
     ca2:	0585                	addi	a1,a1,1
     ca4:	0785                	addi	a5,a5,1
     ca6:	fff5c703          	lbu	a4,-1(a1)
     caa:	fee78fa3          	sb	a4,-1(a5)
     cae:	fb75                	bnez	a4,ca2 <strcpy+0x8>
    ;
  return os;
}
     cb0:	6422                	ld	s0,8(sp)
     cb2:	0141                	addi	sp,sp,16
     cb4:	8082                	ret

0000000000000cb6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     cb6:	1141                	addi	sp,sp,-16
     cb8:	e422                	sd	s0,8(sp)
     cba:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     cbc:	00054783          	lbu	a5,0(a0)
     cc0:	cb91                	beqz	a5,cd4 <strcmp+0x1e>
     cc2:	0005c703          	lbu	a4,0(a1)
     cc6:	00f71763          	bne	a4,a5,cd4 <strcmp+0x1e>
    p++, q++;
     cca:	0505                	addi	a0,a0,1
     ccc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     cce:	00054783          	lbu	a5,0(a0)
     cd2:	fbe5                	bnez	a5,cc2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     cd4:	0005c503          	lbu	a0,0(a1)
}
     cd8:	40a7853b          	subw	a0,a5,a0
     cdc:	6422                	ld	s0,8(sp)
     cde:	0141                	addi	sp,sp,16
     ce0:	8082                	ret

0000000000000ce2 <strlen>:

uint
strlen(const char *s)
{
     ce2:	1141                	addi	sp,sp,-16
     ce4:	e422                	sd	s0,8(sp)
     ce6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     ce8:	00054783          	lbu	a5,0(a0)
     cec:	cf91                	beqz	a5,d08 <strlen+0x26>
     cee:	0505                	addi	a0,a0,1
     cf0:	87aa                	mv	a5,a0
     cf2:	86be                	mv	a3,a5
     cf4:	0785                	addi	a5,a5,1
     cf6:	fff7c703          	lbu	a4,-1(a5)
     cfa:	ff65                	bnez	a4,cf2 <strlen+0x10>
     cfc:	40a6853b          	subw	a0,a3,a0
     d00:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     d02:	6422                	ld	s0,8(sp)
     d04:	0141                	addi	sp,sp,16
     d06:	8082                	ret
  for(n = 0; s[n]; n++)
     d08:	4501                	li	a0,0
     d0a:	bfe5                	j	d02 <strlen+0x20>

0000000000000d0c <memset>:

void*
memset(void *dst, int c, uint n)
{
     d0c:	1141                	addi	sp,sp,-16
     d0e:	e422                	sd	s0,8(sp)
     d10:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     d12:	ca19                	beqz	a2,d28 <memset+0x1c>
     d14:	87aa                	mv	a5,a0
     d16:	1602                	slli	a2,a2,0x20
     d18:	9201                	srli	a2,a2,0x20
     d1a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     d1e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     d22:	0785                	addi	a5,a5,1
     d24:	fee79de3          	bne	a5,a4,d1e <memset+0x12>
  }
  return dst;
}
     d28:	6422                	ld	s0,8(sp)
     d2a:	0141                	addi	sp,sp,16
     d2c:	8082                	ret

0000000000000d2e <strchr>:

char*
strchr(const char *s, char c)
{
     d2e:	1141                	addi	sp,sp,-16
     d30:	e422                	sd	s0,8(sp)
     d32:	0800                	addi	s0,sp,16
  for(; *s; s++)
     d34:	00054783          	lbu	a5,0(a0)
     d38:	cb99                	beqz	a5,d4e <strchr+0x20>
    if(*s == c)
     d3a:	00f58763          	beq	a1,a5,d48 <strchr+0x1a>
  for(; *s; s++)
     d3e:	0505                	addi	a0,a0,1
     d40:	00054783          	lbu	a5,0(a0)
     d44:	fbfd                	bnez	a5,d3a <strchr+0xc>
      return (char*)s;
  return 0;
     d46:	4501                	li	a0,0
}
     d48:	6422                	ld	s0,8(sp)
     d4a:	0141                	addi	sp,sp,16
     d4c:	8082                	ret
  return 0;
     d4e:	4501                	li	a0,0
     d50:	bfe5                	j	d48 <strchr+0x1a>

0000000000000d52 <gets>:

char*
gets(char *buf, int max)
{
     d52:	711d                	addi	sp,sp,-96
     d54:	ec86                	sd	ra,88(sp)
     d56:	e8a2                	sd	s0,80(sp)
     d58:	e4a6                	sd	s1,72(sp)
     d5a:	e0ca                	sd	s2,64(sp)
     d5c:	fc4e                	sd	s3,56(sp)
     d5e:	f852                	sd	s4,48(sp)
     d60:	f456                	sd	s5,40(sp)
     d62:	f05a                	sd	s6,32(sp)
     d64:	ec5e                	sd	s7,24(sp)
     d66:	1080                	addi	s0,sp,96
     d68:	8baa                	mv	s7,a0
     d6a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     d6c:	892a                	mv	s2,a0
     d6e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     d70:	4aa9                	li	s5,10
     d72:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     d74:	89a6                	mv	s3,s1
     d76:	2485                	addiw	s1,s1,1
     d78:	0344d863          	bge	s1,s4,da8 <gets+0x56>
    cc = read(0, &c, 1);
     d7c:	4605                	li	a2,1
     d7e:	faf40593          	addi	a1,s0,-81
     d82:	4501                	li	a0,0
     d84:	00000097          	auipc	ra,0x0
     d88:	19a080e7          	jalr	410(ra) # f1e <read>
    if(cc < 1)
     d8c:	00a05e63          	blez	a0,da8 <gets+0x56>
    buf[i++] = c;
     d90:	faf44783          	lbu	a5,-81(s0)
     d94:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     d98:	01578763          	beq	a5,s5,da6 <gets+0x54>
     d9c:	0905                	addi	s2,s2,1
     d9e:	fd679be3          	bne	a5,s6,d74 <gets+0x22>
    buf[i++] = c;
     da2:	89a6                	mv	s3,s1
     da4:	a011                	j	da8 <gets+0x56>
     da6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     da8:	99de                	add	s3,s3,s7
     daa:	00098023          	sb	zero,0(s3)
  return buf;
}
     dae:	855e                	mv	a0,s7
     db0:	60e6                	ld	ra,88(sp)
     db2:	6446                	ld	s0,80(sp)
     db4:	64a6                	ld	s1,72(sp)
     db6:	6906                	ld	s2,64(sp)
     db8:	79e2                	ld	s3,56(sp)
     dba:	7a42                	ld	s4,48(sp)
     dbc:	7aa2                	ld	s5,40(sp)
     dbe:	7b02                	ld	s6,32(sp)
     dc0:	6be2                	ld	s7,24(sp)
     dc2:	6125                	addi	sp,sp,96
     dc4:	8082                	ret

0000000000000dc6 <stat>:

int
stat(const char *n, struct stat *st)
{
     dc6:	1101                	addi	sp,sp,-32
     dc8:	ec06                	sd	ra,24(sp)
     dca:	e822                	sd	s0,16(sp)
     dcc:	e04a                	sd	s2,0(sp)
     dce:	1000                	addi	s0,sp,32
     dd0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     dd2:	4581                	li	a1,0
     dd4:	00000097          	auipc	ra,0x0
     dd8:	172080e7          	jalr	370(ra) # f46 <open>
  if(fd < 0)
     ddc:	02054663          	bltz	a0,e08 <stat+0x42>
     de0:	e426                	sd	s1,8(sp)
     de2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     de4:	85ca                	mv	a1,s2
     de6:	00000097          	auipc	ra,0x0
     dea:	178080e7          	jalr	376(ra) # f5e <fstat>
     dee:	892a                	mv	s2,a0
  close(fd);
     df0:	8526                	mv	a0,s1
     df2:	00000097          	auipc	ra,0x0
     df6:	13c080e7          	jalr	316(ra) # f2e <close>
  return r;
     dfa:	64a2                	ld	s1,8(sp)
}
     dfc:	854a                	mv	a0,s2
     dfe:	60e2                	ld	ra,24(sp)
     e00:	6442                	ld	s0,16(sp)
     e02:	6902                	ld	s2,0(sp)
     e04:	6105                	addi	sp,sp,32
     e06:	8082                	ret
    return -1;
     e08:	597d                	li	s2,-1
     e0a:	bfcd                	j	dfc <stat+0x36>

0000000000000e0c <atoi>:

int
atoi(const char *s)
{
     e0c:	1141                	addi	sp,sp,-16
     e0e:	e422                	sd	s0,8(sp)
     e10:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     e12:	00054683          	lbu	a3,0(a0)
     e16:	fd06879b          	addiw	a5,a3,-48
     e1a:	0ff7f793          	zext.b	a5,a5
     e1e:	4625                	li	a2,9
     e20:	02f66863          	bltu	a2,a5,e50 <atoi+0x44>
     e24:	872a                	mv	a4,a0
  n = 0;
     e26:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     e28:	0705                	addi	a4,a4,1
     e2a:	0025179b          	slliw	a5,a0,0x2
     e2e:	9fa9                	addw	a5,a5,a0
     e30:	0017979b          	slliw	a5,a5,0x1
     e34:	9fb5                	addw	a5,a5,a3
     e36:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     e3a:	00074683          	lbu	a3,0(a4)
     e3e:	fd06879b          	addiw	a5,a3,-48
     e42:	0ff7f793          	zext.b	a5,a5
     e46:	fef671e3          	bgeu	a2,a5,e28 <atoi+0x1c>
  return n;
}
     e4a:	6422                	ld	s0,8(sp)
     e4c:	0141                	addi	sp,sp,16
     e4e:	8082                	ret
  n = 0;
     e50:	4501                	li	a0,0
     e52:	bfe5                	j	e4a <atoi+0x3e>

0000000000000e54 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     e54:	1141                	addi	sp,sp,-16
     e56:	e422                	sd	s0,8(sp)
     e58:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     e5a:	02b57463          	bgeu	a0,a1,e82 <memmove+0x2e>
    while(n-- > 0)
     e5e:	00c05f63          	blez	a2,e7c <memmove+0x28>
     e62:	1602                	slli	a2,a2,0x20
     e64:	9201                	srli	a2,a2,0x20
     e66:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     e6a:	872a                	mv	a4,a0
      *dst++ = *src++;
     e6c:	0585                	addi	a1,a1,1
     e6e:	0705                	addi	a4,a4,1
     e70:	fff5c683          	lbu	a3,-1(a1)
     e74:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     e78:	fef71ae3          	bne	a4,a5,e6c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     e7c:	6422                	ld	s0,8(sp)
     e7e:	0141                	addi	sp,sp,16
     e80:	8082                	ret
    dst += n;
     e82:	00c50733          	add	a4,a0,a2
    src += n;
     e86:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     e88:	fec05ae3          	blez	a2,e7c <memmove+0x28>
     e8c:	fff6079b          	addiw	a5,a2,-1
     e90:	1782                	slli	a5,a5,0x20
     e92:	9381                	srli	a5,a5,0x20
     e94:	fff7c793          	not	a5,a5
     e98:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     e9a:	15fd                	addi	a1,a1,-1
     e9c:	177d                	addi	a4,a4,-1
     e9e:	0005c683          	lbu	a3,0(a1)
     ea2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     ea6:	fee79ae3          	bne	a5,a4,e9a <memmove+0x46>
     eaa:	bfc9                	j	e7c <memmove+0x28>

0000000000000eac <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     eac:	1141                	addi	sp,sp,-16
     eae:	e422                	sd	s0,8(sp)
     eb0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     eb2:	ca05                	beqz	a2,ee2 <memcmp+0x36>
     eb4:	fff6069b          	addiw	a3,a2,-1
     eb8:	1682                	slli	a3,a3,0x20
     eba:	9281                	srli	a3,a3,0x20
     ebc:	0685                	addi	a3,a3,1
     ebe:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     ec0:	00054783          	lbu	a5,0(a0)
     ec4:	0005c703          	lbu	a4,0(a1)
     ec8:	00e79863          	bne	a5,a4,ed8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     ecc:	0505                	addi	a0,a0,1
    p2++;
     ece:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     ed0:	fed518e3          	bne	a0,a3,ec0 <memcmp+0x14>
  }
  return 0;
     ed4:	4501                	li	a0,0
     ed6:	a019                	j	edc <memcmp+0x30>
      return *p1 - *p2;
     ed8:	40e7853b          	subw	a0,a5,a4
}
     edc:	6422                	ld	s0,8(sp)
     ede:	0141                	addi	sp,sp,16
     ee0:	8082                	ret
  return 0;
     ee2:	4501                	li	a0,0
     ee4:	bfe5                	j	edc <memcmp+0x30>

0000000000000ee6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     ee6:	1141                	addi	sp,sp,-16
     ee8:	e406                	sd	ra,8(sp)
     eea:	e022                	sd	s0,0(sp)
     eec:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     eee:	00000097          	auipc	ra,0x0
     ef2:	f66080e7          	jalr	-154(ra) # e54 <memmove>
}
     ef6:	60a2                	ld	ra,8(sp)
     ef8:	6402                	ld	s0,0(sp)
     efa:	0141                	addi	sp,sp,16
     efc:	8082                	ret

0000000000000efe <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     efe:	4885                	li	a7,1
 ecall
     f00:	00000073          	ecall
 ret
     f04:	8082                	ret

0000000000000f06 <exit>:
.global exit
exit:
 li a7, SYS_exit
     f06:	4889                	li	a7,2
 ecall
     f08:	00000073          	ecall
 ret
     f0c:	8082                	ret

0000000000000f0e <wait>:
.global wait
wait:
 li a7, SYS_wait
     f0e:	488d                	li	a7,3
 ecall
     f10:	00000073          	ecall
 ret
     f14:	8082                	ret

0000000000000f16 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     f16:	4891                	li	a7,4
 ecall
     f18:	00000073          	ecall
 ret
     f1c:	8082                	ret

0000000000000f1e <read>:
.global read
read:
 li a7, SYS_read
     f1e:	4895                	li	a7,5
 ecall
     f20:	00000073          	ecall
 ret
     f24:	8082                	ret

0000000000000f26 <write>:
.global write
write:
 li a7, SYS_write
     f26:	48c1                	li	a7,16
 ecall
     f28:	00000073          	ecall
 ret
     f2c:	8082                	ret

0000000000000f2e <close>:
.global close
close:
 li a7, SYS_close
     f2e:	48d5                	li	a7,21
 ecall
     f30:	00000073          	ecall
 ret
     f34:	8082                	ret

0000000000000f36 <kill>:
.global kill
kill:
 li a7, SYS_kill
     f36:	4899                	li	a7,6
 ecall
     f38:	00000073          	ecall
 ret
     f3c:	8082                	ret

0000000000000f3e <exec>:
.global exec
exec:
 li a7, SYS_exec
     f3e:	489d                	li	a7,7
 ecall
     f40:	00000073          	ecall
 ret
     f44:	8082                	ret

0000000000000f46 <open>:
.global open
open:
 li a7, SYS_open
     f46:	48bd                	li	a7,15
 ecall
     f48:	00000073          	ecall
 ret
     f4c:	8082                	ret

0000000000000f4e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     f4e:	48c5                	li	a7,17
 ecall
     f50:	00000073          	ecall
 ret
     f54:	8082                	ret

0000000000000f56 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     f56:	48c9                	li	a7,18
 ecall
     f58:	00000073          	ecall
 ret
     f5c:	8082                	ret

0000000000000f5e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     f5e:	48a1                	li	a7,8
 ecall
     f60:	00000073          	ecall
 ret
     f64:	8082                	ret

0000000000000f66 <link>:
.global link
link:
 li a7, SYS_link
     f66:	48cd                	li	a7,19
 ecall
     f68:	00000073          	ecall
 ret
     f6c:	8082                	ret

0000000000000f6e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     f6e:	48d1                	li	a7,20
 ecall
     f70:	00000073          	ecall
 ret
     f74:	8082                	ret

0000000000000f76 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     f76:	48a5                	li	a7,9
 ecall
     f78:	00000073          	ecall
 ret
     f7c:	8082                	ret

0000000000000f7e <dup>:
.global dup
dup:
 li a7, SYS_dup
     f7e:	48a9                	li	a7,10
 ecall
     f80:	00000073          	ecall
 ret
     f84:	8082                	ret

0000000000000f86 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     f86:	48ad                	li	a7,11
 ecall
     f88:	00000073          	ecall
 ret
     f8c:	8082                	ret

0000000000000f8e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     f8e:	48b1                	li	a7,12
 ecall
     f90:	00000073          	ecall
 ret
     f94:	8082                	ret

0000000000000f96 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     f96:	48b5                	li	a7,13
 ecall
     f98:	00000073          	ecall
 ret
     f9c:	8082                	ret

0000000000000f9e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     f9e:	48b9                	li	a7,14
 ecall
     fa0:	00000073          	ecall
 ret
     fa4:	8082                	ret

0000000000000fa6 <ps>:
.global ps
ps:
 li a7, SYS_ps
     fa6:	48d9                	li	a7,22
 ecall
     fa8:	00000073          	ecall
 ret
     fac:	8082                	ret

0000000000000fae <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
     fae:	48dd                	li	a7,23
 ecall
     fb0:	00000073          	ecall
 ret
     fb4:	8082                	ret

0000000000000fb6 <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
     fb6:	48e1                	li	a7,24
 ecall
     fb8:	00000073          	ecall
 ret
     fbc:	8082                	ret

0000000000000fbe <yield>:
.global yield
yield:
 li a7, SYS_yield
     fbe:	48e5                	li	a7,25
 ecall
     fc0:	00000073          	ecall
 ret
     fc4:	8082                	ret

0000000000000fc6 <getprio>:
.global getprio
getprio:
 li a7, SYS_getprio
     fc6:	48e9                	li	a7,26
 ecall
     fc8:	00000073          	ecall
 ret
     fcc:	8082                	ret

0000000000000fce <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     fce:	1101                	addi	sp,sp,-32
     fd0:	ec06                	sd	ra,24(sp)
     fd2:	e822                	sd	s0,16(sp)
     fd4:	1000                	addi	s0,sp,32
     fd6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     fda:	4605                	li	a2,1
     fdc:	fef40593          	addi	a1,s0,-17
     fe0:	00000097          	auipc	ra,0x0
     fe4:	f46080e7          	jalr	-186(ra) # f26 <write>
}
     fe8:	60e2                	ld	ra,24(sp)
     fea:	6442                	ld	s0,16(sp)
     fec:	6105                	addi	sp,sp,32
     fee:	8082                	ret

0000000000000ff0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     ff0:	7139                	addi	sp,sp,-64
     ff2:	fc06                	sd	ra,56(sp)
     ff4:	f822                	sd	s0,48(sp)
     ff6:	f426                	sd	s1,40(sp)
     ff8:	0080                	addi	s0,sp,64
     ffa:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     ffc:	c299                	beqz	a3,1002 <printint+0x12>
     ffe:	0805cb63          	bltz	a1,1094 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    1002:	2581                	sext.w	a1,a1
  neg = 0;
    1004:	4881                	li	a7,0
    1006:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    100a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    100c:	2601                	sext.w	a2,a2
    100e:	00000517          	auipc	a0,0x0
    1012:	5fa50513          	addi	a0,a0,1530 # 1608 <digits>
    1016:	883a                	mv	a6,a4
    1018:	2705                	addiw	a4,a4,1
    101a:	02c5f7bb          	remuw	a5,a1,a2
    101e:	1782                	slli	a5,a5,0x20
    1020:	9381                	srli	a5,a5,0x20
    1022:	97aa                	add	a5,a5,a0
    1024:	0007c783          	lbu	a5,0(a5)
    1028:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    102c:	0005879b          	sext.w	a5,a1
    1030:	02c5d5bb          	divuw	a1,a1,a2
    1034:	0685                	addi	a3,a3,1
    1036:	fec7f0e3          	bgeu	a5,a2,1016 <printint+0x26>
  if(neg)
    103a:	00088c63          	beqz	a7,1052 <printint+0x62>
    buf[i++] = '-';
    103e:	fd070793          	addi	a5,a4,-48
    1042:	00878733          	add	a4,a5,s0
    1046:	02d00793          	li	a5,45
    104a:	fef70823          	sb	a5,-16(a4)
    104e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    1052:	02e05c63          	blez	a4,108a <printint+0x9a>
    1056:	f04a                	sd	s2,32(sp)
    1058:	ec4e                	sd	s3,24(sp)
    105a:	fc040793          	addi	a5,s0,-64
    105e:	00e78933          	add	s2,a5,a4
    1062:	fff78993          	addi	s3,a5,-1
    1066:	99ba                	add	s3,s3,a4
    1068:	377d                	addiw	a4,a4,-1
    106a:	1702                	slli	a4,a4,0x20
    106c:	9301                	srli	a4,a4,0x20
    106e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    1072:	fff94583          	lbu	a1,-1(s2)
    1076:	8526                	mv	a0,s1
    1078:	00000097          	auipc	ra,0x0
    107c:	f56080e7          	jalr	-170(ra) # fce <putc>
  while(--i >= 0)
    1080:	197d                	addi	s2,s2,-1
    1082:	ff3918e3          	bne	s2,s3,1072 <printint+0x82>
    1086:	7902                	ld	s2,32(sp)
    1088:	69e2                	ld	s3,24(sp)
}
    108a:	70e2                	ld	ra,56(sp)
    108c:	7442                	ld	s0,48(sp)
    108e:	74a2                	ld	s1,40(sp)
    1090:	6121                	addi	sp,sp,64
    1092:	8082                	ret
    x = -xx;
    1094:	40b005bb          	negw	a1,a1
    neg = 1;
    1098:	4885                	li	a7,1
    x = -xx;
    109a:	b7b5                	j	1006 <printint+0x16>

000000000000109c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    109c:	715d                	addi	sp,sp,-80
    109e:	e486                	sd	ra,72(sp)
    10a0:	e0a2                	sd	s0,64(sp)
    10a2:	f84a                	sd	s2,48(sp)
    10a4:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    10a6:	0005c903          	lbu	s2,0(a1)
    10aa:	1a090a63          	beqz	s2,125e <vprintf+0x1c2>
    10ae:	fc26                	sd	s1,56(sp)
    10b0:	f44e                	sd	s3,40(sp)
    10b2:	f052                	sd	s4,32(sp)
    10b4:	ec56                	sd	s5,24(sp)
    10b6:	e85a                	sd	s6,16(sp)
    10b8:	e45e                	sd	s7,8(sp)
    10ba:	8aaa                	mv	s5,a0
    10bc:	8bb2                	mv	s7,a2
    10be:	00158493          	addi	s1,a1,1
  state = 0;
    10c2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    10c4:	02500a13          	li	s4,37
    10c8:	4b55                	li	s6,21
    10ca:	a839                	j	10e8 <vprintf+0x4c>
        putc(fd, c);
    10cc:	85ca                	mv	a1,s2
    10ce:	8556                	mv	a0,s5
    10d0:	00000097          	auipc	ra,0x0
    10d4:	efe080e7          	jalr	-258(ra) # fce <putc>
    10d8:	a019                	j	10de <vprintf+0x42>
    } else if(state == '%'){
    10da:	01498d63          	beq	s3,s4,10f4 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
    10de:	0485                	addi	s1,s1,1
    10e0:	fff4c903          	lbu	s2,-1(s1)
    10e4:	16090763          	beqz	s2,1252 <vprintf+0x1b6>
    if(state == 0){
    10e8:	fe0999e3          	bnez	s3,10da <vprintf+0x3e>
      if(c == '%'){
    10ec:	ff4910e3          	bne	s2,s4,10cc <vprintf+0x30>
        state = '%';
    10f0:	89d2                	mv	s3,s4
    10f2:	b7f5                	j	10de <vprintf+0x42>
      if(c == 'd'){
    10f4:	13490463          	beq	s2,s4,121c <vprintf+0x180>
    10f8:	f9d9079b          	addiw	a5,s2,-99
    10fc:	0ff7f793          	zext.b	a5,a5
    1100:	12fb6763          	bltu	s6,a5,122e <vprintf+0x192>
    1104:	f9d9079b          	addiw	a5,s2,-99
    1108:	0ff7f713          	zext.b	a4,a5
    110c:	12eb6163          	bltu	s6,a4,122e <vprintf+0x192>
    1110:	00271793          	slli	a5,a4,0x2
    1114:	00000717          	auipc	a4,0x0
    1118:	49c70713          	addi	a4,a4,1180 # 15b0 <malloc+0x262>
    111c:	97ba                	add	a5,a5,a4
    111e:	439c                	lw	a5,0(a5)
    1120:	97ba                	add	a5,a5,a4
    1122:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    1124:	008b8913          	addi	s2,s7,8
    1128:	4685                	li	a3,1
    112a:	4629                	li	a2,10
    112c:	000ba583          	lw	a1,0(s7)
    1130:	8556                	mv	a0,s5
    1132:	00000097          	auipc	ra,0x0
    1136:	ebe080e7          	jalr	-322(ra) # ff0 <printint>
    113a:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    113c:	4981                	li	s3,0
    113e:	b745                	j	10de <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1140:	008b8913          	addi	s2,s7,8
    1144:	4681                	li	a3,0
    1146:	4629                	li	a2,10
    1148:	000ba583          	lw	a1,0(s7)
    114c:	8556                	mv	a0,s5
    114e:	00000097          	auipc	ra,0x0
    1152:	ea2080e7          	jalr	-350(ra) # ff0 <printint>
    1156:	8bca                	mv	s7,s2
      state = 0;
    1158:	4981                	li	s3,0
    115a:	b751                	j	10de <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    115c:	008b8913          	addi	s2,s7,8
    1160:	4681                	li	a3,0
    1162:	4641                	li	a2,16
    1164:	000ba583          	lw	a1,0(s7)
    1168:	8556                	mv	a0,s5
    116a:	00000097          	auipc	ra,0x0
    116e:	e86080e7          	jalr	-378(ra) # ff0 <printint>
    1172:	8bca                	mv	s7,s2
      state = 0;
    1174:	4981                	li	s3,0
    1176:	b7a5                	j	10de <vprintf+0x42>
    1178:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    117a:	008b8c13          	addi	s8,s7,8
    117e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    1182:	03000593          	li	a1,48
    1186:	8556                	mv	a0,s5
    1188:	00000097          	auipc	ra,0x0
    118c:	e46080e7          	jalr	-442(ra) # fce <putc>
  putc(fd, 'x');
    1190:	07800593          	li	a1,120
    1194:	8556                	mv	a0,s5
    1196:	00000097          	auipc	ra,0x0
    119a:	e38080e7          	jalr	-456(ra) # fce <putc>
    119e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    11a0:	00000b97          	auipc	s7,0x0
    11a4:	468b8b93          	addi	s7,s7,1128 # 1608 <digits>
    11a8:	03c9d793          	srli	a5,s3,0x3c
    11ac:	97de                	add	a5,a5,s7
    11ae:	0007c583          	lbu	a1,0(a5)
    11b2:	8556                	mv	a0,s5
    11b4:	00000097          	auipc	ra,0x0
    11b8:	e1a080e7          	jalr	-486(ra) # fce <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    11bc:	0992                	slli	s3,s3,0x4
    11be:	397d                	addiw	s2,s2,-1
    11c0:	fe0914e3          	bnez	s2,11a8 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    11c4:	8be2                	mv	s7,s8
      state = 0;
    11c6:	4981                	li	s3,0
    11c8:	6c02                	ld	s8,0(sp)
    11ca:	bf11                	j	10de <vprintf+0x42>
        s = va_arg(ap, char*);
    11cc:	008b8993          	addi	s3,s7,8
    11d0:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    11d4:	02090163          	beqz	s2,11f6 <vprintf+0x15a>
        while(*s != 0){
    11d8:	00094583          	lbu	a1,0(s2)
    11dc:	c9a5                	beqz	a1,124c <vprintf+0x1b0>
          putc(fd, *s);
    11de:	8556                	mv	a0,s5
    11e0:	00000097          	auipc	ra,0x0
    11e4:	dee080e7          	jalr	-530(ra) # fce <putc>
          s++;
    11e8:	0905                	addi	s2,s2,1
        while(*s != 0){
    11ea:	00094583          	lbu	a1,0(s2)
    11ee:	f9e5                	bnez	a1,11de <vprintf+0x142>
        s = va_arg(ap, char*);
    11f0:	8bce                	mv	s7,s3
      state = 0;
    11f2:	4981                	li	s3,0
    11f4:	b5ed                	j	10de <vprintf+0x42>
          s = "(null)";
    11f6:	00000917          	auipc	s2,0x0
    11fa:	38290913          	addi	s2,s2,898 # 1578 <malloc+0x22a>
        while(*s != 0){
    11fe:	02800593          	li	a1,40
    1202:	bff1                	j	11de <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
    1204:	008b8913          	addi	s2,s7,8
    1208:	000bc583          	lbu	a1,0(s7)
    120c:	8556                	mv	a0,s5
    120e:	00000097          	auipc	ra,0x0
    1212:	dc0080e7          	jalr	-576(ra) # fce <putc>
    1216:	8bca                	mv	s7,s2
      state = 0;
    1218:	4981                	li	s3,0
    121a:	b5d1                	j	10de <vprintf+0x42>
        putc(fd, c);
    121c:	02500593          	li	a1,37
    1220:	8556                	mv	a0,s5
    1222:	00000097          	auipc	ra,0x0
    1226:	dac080e7          	jalr	-596(ra) # fce <putc>
      state = 0;
    122a:	4981                	li	s3,0
    122c:	bd4d                	j	10de <vprintf+0x42>
        putc(fd, '%');
    122e:	02500593          	li	a1,37
    1232:	8556                	mv	a0,s5
    1234:	00000097          	auipc	ra,0x0
    1238:	d9a080e7          	jalr	-614(ra) # fce <putc>
        putc(fd, c);
    123c:	85ca                	mv	a1,s2
    123e:	8556                	mv	a0,s5
    1240:	00000097          	auipc	ra,0x0
    1244:	d8e080e7          	jalr	-626(ra) # fce <putc>
      state = 0;
    1248:	4981                	li	s3,0
    124a:	bd51                	j	10de <vprintf+0x42>
        s = va_arg(ap, char*);
    124c:	8bce                	mv	s7,s3
      state = 0;
    124e:	4981                	li	s3,0
    1250:	b579                	j	10de <vprintf+0x42>
    1252:	74e2                	ld	s1,56(sp)
    1254:	79a2                	ld	s3,40(sp)
    1256:	7a02                	ld	s4,32(sp)
    1258:	6ae2                	ld	s5,24(sp)
    125a:	6b42                	ld	s6,16(sp)
    125c:	6ba2                	ld	s7,8(sp)
    }
  }
}
    125e:	60a6                	ld	ra,72(sp)
    1260:	6406                	ld	s0,64(sp)
    1262:	7942                	ld	s2,48(sp)
    1264:	6161                	addi	sp,sp,80
    1266:	8082                	ret

0000000000001268 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1268:	715d                	addi	sp,sp,-80
    126a:	ec06                	sd	ra,24(sp)
    126c:	e822                	sd	s0,16(sp)
    126e:	1000                	addi	s0,sp,32
    1270:	e010                	sd	a2,0(s0)
    1272:	e414                	sd	a3,8(s0)
    1274:	e818                	sd	a4,16(s0)
    1276:	ec1c                	sd	a5,24(s0)
    1278:	03043023          	sd	a6,32(s0)
    127c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1280:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1284:	8622                	mv	a2,s0
    1286:	00000097          	auipc	ra,0x0
    128a:	e16080e7          	jalr	-490(ra) # 109c <vprintf>
}
    128e:	60e2                	ld	ra,24(sp)
    1290:	6442                	ld	s0,16(sp)
    1292:	6161                	addi	sp,sp,80
    1294:	8082                	ret

0000000000001296 <printf>:

void
printf(const char *fmt, ...)
{
    1296:	711d                	addi	sp,sp,-96
    1298:	ec06                	sd	ra,24(sp)
    129a:	e822                	sd	s0,16(sp)
    129c:	1000                	addi	s0,sp,32
    129e:	e40c                	sd	a1,8(s0)
    12a0:	e810                	sd	a2,16(s0)
    12a2:	ec14                	sd	a3,24(s0)
    12a4:	f018                	sd	a4,32(s0)
    12a6:	f41c                	sd	a5,40(s0)
    12a8:	03043823          	sd	a6,48(s0)
    12ac:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    12b0:	00840613          	addi	a2,s0,8
    12b4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    12b8:	85aa                	mv	a1,a0
    12ba:	4505                	li	a0,1
    12bc:	00000097          	auipc	ra,0x0
    12c0:	de0080e7          	jalr	-544(ra) # 109c <vprintf>
}
    12c4:	60e2                	ld	ra,24(sp)
    12c6:	6442                	ld	s0,16(sp)
    12c8:	6125                	addi	sp,sp,96
    12ca:	8082                	ret

00000000000012cc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    12cc:	1141                	addi	sp,sp,-16
    12ce:	e422                	sd	s0,8(sp)
    12d0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    12d2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12d6:	00001797          	auipc	a5,0x1
    12da:	55a7b783          	ld	a5,1370(a5) # 2830 <freep>
    12de:	a02d                	j	1308 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    12e0:	4618                	lw	a4,8(a2)
    12e2:	9f2d                	addw	a4,a4,a1
    12e4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    12e8:	6398                	ld	a4,0(a5)
    12ea:	6310                	ld	a2,0(a4)
    12ec:	a83d                	j	132a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    12ee:	ff852703          	lw	a4,-8(a0)
    12f2:	9f31                	addw	a4,a4,a2
    12f4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    12f6:	ff053683          	ld	a3,-16(a0)
    12fa:	a091                	j	133e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    12fc:	6398                	ld	a4,0(a5)
    12fe:	00e7e463          	bltu	a5,a4,1306 <free+0x3a>
    1302:	00e6ea63          	bltu	a3,a4,1316 <free+0x4a>
{
    1306:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1308:	fed7fae3          	bgeu	a5,a3,12fc <free+0x30>
    130c:	6398                	ld	a4,0(a5)
    130e:	00e6e463          	bltu	a3,a4,1316 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1312:	fee7eae3          	bltu	a5,a4,1306 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    1316:	ff852583          	lw	a1,-8(a0)
    131a:	6390                	ld	a2,0(a5)
    131c:	02059813          	slli	a6,a1,0x20
    1320:	01c85713          	srli	a4,a6,0x1c
    1324:	9736                	add	a4,a4,a3
    1326:	fae60de3          	beq	a2,a4,12e0 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    132a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    132e:	4790                	lw	a2,8(a5)
    1330:	02061593          	slli	a1,a2,0x20
    1334:	01c5d713          	srli	a4,a1,0x1c
    1338:	973e                	add	a4,a4,a5
    133a:	fae68ae3          	beq	a3,a4,12ee <free+0x22>
    p->s.ptr = bp->s.ptr;
    133e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1340:	00001717          	auipc	a4,0x1
    1344:	4ef73823          	sd	a5,1264(a4) # 2830 <freep>
}
    1348:	6422                	ld	s0,8(sp)
    134a:	0141                	addi	sp,sp,16
    134c:	8082                	ret

000000000000134e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    134e:	7139                	addi	sp,sp,-64
    1350:	fc06                	sd	ra,56(sp)
    1352:	f822                	sd	s0,48(sp)
    1354:	f426                	sd	s1,40(sp)
    1356:	ec4e                	sd	s3,24(sp)
    1358:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    135a:	02051493          	slli	s1,a0,0x20
    135e:	9081                	srli	s1,s1,0x20
    1360:	04bd                	addi	s1,s1,15
    1362:	8091                	srli	s1,s1,0x4
    1364:	0014899b          	addiw	s3,s1,1
    1368:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    136a:	00001517          	auipc	a0,0x1
    136e:	4c653503          	ld	a0,1222(a0) # 2830 <freep>
    1372:	c915                	beqz	a0,13a6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1374:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1376:	4798                	lw	a4,8(a5)
    1378:	08977e63          	bgeu	a4,s1,1414 <malloc+0xc6>
    137c:	f04a                	sd	s2,32(sp)
    137e:	e852                	sd	s4,16(sp)
    1380:	e456                	sd	s5,8(sp)
    1382:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1384:	8a4e                	mv	s4,s3
    1386:	0009871b          	sext.w	a4,s3
    138a:	6685                	lui	a3,0x1
    138c:	00d77363          	bgeu	a4,a3,1392 <malloc+0x44>
    1390:	6a05                	lui	s4,0x1
    1392:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1396:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    139a:	00001917          	auipc	s2,0x1
    139e:	49690913          	addi	s2,s2,1174 # 2830 <freep>
  if(p == (char*)-1)
    13a2:	5afd                	li	s5,-1
    13a4:	a091                	j	13e8 <malloc+0x9a>
    13a6:	f04a                	sd	s2,32(sp)
    13a8:	e852                	sd	s4,16(sp)
    13aa:	e456                	sd	s5,8(sp)
    13ac:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    13ae:	00001797          	auipc	a5,0x1
    13b2:	50a78793          	addi	a5,a5,1290 # 28b8 <base>
    13b6:	00001717          	auipc	a4,0x1
    13ba:	46f73d23          	sd	a5,1146(a4) # 2830 <freep>
    13be:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    13c0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    13c4:	b7c1                	j	1384 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    13c6:	6398                	ld	a4,0(a5)
    13c8:	e118                	sd	a4,0(a0)
    13ca:	a08d                	j	142c <malloc+0xde>
  hp->s.size = nu;
    13cc:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    13d0:	0541                	addi	a0,a0,16
    13d2:	00000097          	auipc	ra,0x0
    13d6:	efa080e7          	jalr	-262(ra) # 12cc <free>
  return freep;
    13da:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    13de:	c13d                	beqz	a0,1444 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    13e0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    13e2:	4798                	lw	a4,8(a5)
    13e4:	02977463          	bgeu	a4,s1,140c <malloc+0xbe>
    if(p == freep)
    13e8:	00093703          	ld	a4,0(s2)
    13ec:	853e                	mv	a0,a5
    13ee:	fef719e3          	bne	a4,a5,13e0 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
    13f2:	8552                	mv	a0,s4
    13f4:	00000097          	auipc	ra,0x0
    13f8:	b9a080e7          	jalr	-1126(ra) # f8e <sbrk>
  if(p == (char*)-1)
    13fc:	fd5518e3          	bne	a0,s5,13cc <malloc+0x7e>
        return 0;
    1400:	4501                	li	a0,0
    1402:	7902                	ld	s2,32(sp)
    1404:	6a42                	ld	s4,16(sp)
    1406:	6aa2                	ld	s5,8(sp)
    1408:	6b02                	ld	s6,0(sp)
    140a:	a03d                	j	1438 <malloc+0xea>
    140c:	7902                	ld	s2,32(sp)
    140e:	6a42                	ld	s4,16(sp)
    1410:	6aa2                	ld	s5,8(sp)
    1412:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    1414:	fae489e3          	beq	s1,a4,13c6 <malloc+0x78>
        p->s.size -= nunits;
    1418:	4137073b          	subw	a4,a4,s3
    141c:	c798                	sw	a4,8(a5)
        p += p->s.size;
    141e:	02071693          	slli	a3,a4,0x20
    1422:	01c6d713          	srli	a4,a3,0x1c
    1426:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1428:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    142c:	00001717          	auipc	a4,0x1
    1430:	40a73223          	sd	a0,1028(a4) # 2830 <freep>
      return (void*)(p + 1);
    1434:	01078513          	addi	a0,a5,16
  }
}
    1438:	70e2                	ld	ra,56(sp)
    143a:	7442                	ld	s0,48(sp)
    143c:	74a2                	ld	s1,40(sp)
    143e:	69e2                	ld	s3,24(sp)
    1440:	6121                	addi	sp,sp,64
    1442:	8082                	ret
    1444:	7902                	ld	s2,32(sp)
    1446:	6a42                	ld	s4,16(sp)
    1448:	6aa2                	ld	s5,8(sp)
    144a:	6b02                	ld	s6,0(sp)
    144c:	b7f5                	j	1438 <malloc+0xea>
