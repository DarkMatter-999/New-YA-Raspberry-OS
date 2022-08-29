#include "uart.h"
#include "rand.h"
#include "power.h"

void kernel_main()
{
    // initialize UART1
    uart_init();
    uart_puts("UART1 initialized successfully\n");

    rand_init();
    uart_puts("Random gen initialized successfully\n");

    char c;
    while(1) {
        uart_puts(" 1 - power off\n 2 - reset\nChoose one: ");
        power_off();
        c=uart_getc();
        uart_send(c);
        uart_puts("\n\n");
        if(c=='1') { uart_puts("Powering off\n"); power_off(); }
        if(c=='2') { uart_puts("Reseting\n"); reset(); }
    }
}