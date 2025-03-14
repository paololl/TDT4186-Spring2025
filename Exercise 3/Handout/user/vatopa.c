#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

// Helper to convert hex string to unsigned long.
unsigned long hex2ulong(const char *s) {
    unsigned long result = 0;
    if(s[0] == '0' && (s[1] == 'x' || s[1] == 'X'))
        s += 2;
    while(*s) {
        result *= 16;
        if(*s >= '0' && *s <= '9')
            result += *s - '0';
        else if(*s >= 'a' && *s <= 'f')
            result += *s - 'a' + 10;
        else if(*s >= 'A' && *s <= 'F')
            result += *s - 'A' + 10;
        else
            break;
        s++;
    }
    return result;
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: vatopa virtual_address [pid]\n");
        exit(1);
    }
    uint64 va = hex2ulong(argv[1]);
    int pid = 0;
    if (argc > 2) {
        pid = atoi(argv[2]);
    }
    uint64 pa = va2pa(va, pid);
    if (pa == 0) {
        printf("0x0\n");
    } else {
        printf("0x%x\n", pa);
    }
    exit(0);
}
