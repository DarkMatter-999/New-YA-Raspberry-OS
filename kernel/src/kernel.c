#include "uart.h"
#include "rand.h"
#include "timer.h"

void kernel_main()
{
    // initialize UART1
    uart_init();
    uart_puts("UART1 initialized successfully\n");

    rand_init();
    uart_puts("Random gen initialized successfully\n");

    uart_puts("Waiting 1000000 CPU cycles (ARM CPU): ");
    wait_cycles(1000000);
    uart_puts("OK\n");

    uart_puts("Waiting 1000000 microsec (ARM CPU): ");
    wait_msec(1000000);
    uart_puts("OK\n");

    uart_puts("Waiting 1000000 microsec (BCM System Timer): ");
    if(get_system_timer()==0) {
        uart_puts("Not available\n");
    } else {
        wait_msec_st(1000000);
        uart_puts("OK\n");
    }
    
    // echo back
    while(1) {
        uart_send(uart_getc());
    }
}