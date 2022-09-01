#include "uart.h"
#include "rand.h"
#include "lfb.h"

void kernel_main()
{
    // initialize UART1
    uart_init();
    uart_puts("UART1 initialized successfully\n");

    rand_init();
    uart_puts("Random gen initialized successfully\n");

    lfb_init();
    uart_puts("Linear Framebuffer initialized successfully\n");

    // display string with PSF Fonts
    lfb_print(80, 80, "Hello World!");

    // display a UTF-8 string on screen with SSFN
    lfb_proprint(80, 120, "Hello World!");

    while(1) {
        uart_send(uart_getc());
    }
}