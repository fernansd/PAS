/* Cabeceras */
#include <stdio.h>      /* Entrada salida */
#include <stdlib.h>     /* Utilidades generales */
#include <signal.h>     /* Manejo de señales */
#include <unistd.h>

int dividendo=0, divisor=0;

void mi_manejador_sigfpe(int signal)
{
    printf("Capturé la señal DIVISIÓN por cero\n");
    printf("Division=%d\n", (dividendo/1));
    exit(1);
}

int main()
{
    /* Utilizar la función signal() para asociar nuestras funciones a las señales
       SIGINT, SIGHUP y SIGTERM */
    if (signal(SIGFPE, mi_manejador_sigfpe) == SIG_ERR)
        printf("No puedo asociar la señal SIGFPE al manejador!\n");

    printf("Introduce el dividendo: ");
    scanf("%d", &dividendo);
    printf("Introduce el divisor: ");
    scanf("%d", &divisor);
    printf("Division=%d\n", (dividendo/divisor));
    exit(0);
} /* main() */
