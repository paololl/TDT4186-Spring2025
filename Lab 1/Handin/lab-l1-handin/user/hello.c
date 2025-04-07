/* 
    @author: Paolo Ludovico Laferla 
    @since:  01/02/2025
    @brief:  The first task in the first lab is to write a small user-space program that takes one optional
             parameter. This program should output the string Hello World if no argument has been supplied
             and Hello [argument], nice to meet you!, where [argument] should be replaced with the
             argument the user of the program provided. The hello program should only read the first argument
             and ignore any additional arguments.
*/


#include "user.h"

int main(int argc, char *argv[]) {
    if (argc == 1) {
        printf("Hello World\n");
    } else {
        printf("Hello %s, nice to meet you!\n", argv[1]);
    }
    exit(0);
}
