#include "uart.h"

void kernel_main()
{
    // initialize UART1
    uart_init();

    uart_puts("Please work\n");
    
    // echo back
    while(1) {
        uart_send(uart_getc());
    }
}