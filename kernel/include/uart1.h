#if !defined(UART1_H)
#define UART1_H

void uart1_init();
void uart1_send(unsigned int c);
char uart1_getc();
void uart1_puts(char *s);

void uart1_hex(unsigned int d);

#endif // UART1_H
