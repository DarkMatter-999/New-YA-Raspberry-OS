#include "uart.h"
#include "mbox.h"
#include "rand.h"

void kernel_main()
{
    // initialize UART1
    uart_init();
    uart_puts("UART1 initialized successfully\n");

    rand_init();
    uart_puts("Random gen initialized successfully\n");

    uart_puts("Random number: ");
    uart_hex(rand(0,4294967295));
    uart_puts("\n");
    
    // echo back
    while(1) {
        uart_send(uart_getc());
    }
}