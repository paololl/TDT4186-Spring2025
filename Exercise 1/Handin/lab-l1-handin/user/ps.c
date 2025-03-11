/*
    @author: Paolo Ludovico Laferla
    @since:  01/05/2025
    @brief:  For this task, we want you to write a small tool that helps us keep track of the currently running
             processes. In order to achieve that, it should list all processes that the OS is currently aware of
             in the following format: proc name(proc id): proc state, one process per line. Implement all
             required parts and think about what should go in the kernel space and the user space.
*/

#include "user.h"

int main() {
    getprocesses();
    exit(0);
}