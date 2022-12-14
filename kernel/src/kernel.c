#include "uart.h"
#include "rand.h"
#include "lfb.h"
#include "sd.h"
#include "fat.h"

extern unsigned char _end;

void kernel_main()
{
    // initialize UART1
    uart_init();
    uart_puts("UART: UART1 initialized successfully\n");

    rand_init();
    uart_puts("RAND: Random gen initialized successfully\n");

    lfb_init();
    uart_puts("FB: Linear Framebuffer initialized successfully\n");

    // initialize EMMC and detect SD card type
    if(sd_init()==SD_OK) {
        // read the master boot record and find our partition
        if(fat_getpartition()) {
            // list root directory entries
            fat_listdirectory();
        } else {
            uart_puts("FAT partition not found???\n");
        }
    }
    
    // display string with PSF Fonts
    lfb_print(80, 80, "Hello World!");

    // display a UTF-8 string on screen with SSFN
    lfb_proprint(80, 120, "Hello World!");

    while(1) {
        uart_send(uart_getc());
    }
}