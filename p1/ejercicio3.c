#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <mqueue.h>
#include <sys/wait.h>
#include <errno.h> //Control de errores
#include <string.h> //Para la funcion strerror()

#define MAX_SIZE    5
#define QUEUE_NAME  "/una_cola"

int main() {
	// Descriptor de la tubería
	int fildes[2];
	// Buffer para la lectura/escritura
	char buffer[MAX_SIZE + 1];
	// Resultado de las operaciones
	ssize_t bytes_leidos;
	// Para realizar el fork
	pid_t rf;
    int flag,status;
	// Numero aleatorio a generar
	int numeroAleatorio;
	// Variable contador para los bucles
	int i;
    // Semilla para números aleatorios
    srand(time(NULL));
    // Fichero de log
    FILE * fichero;
    // Buffer para logs
    char log_buf[120];
	
	// Creamos la tubería
	status = pipe(fildes);
	if (status == -1) {
	    printf("Error creando la tubería!\n");
	    exit(1);
	}

	// Realizar el fork
	rf = fork();

	switch (rf)
	{
		// Error
		case -1:
			printf ("No he podido crear el proceso hijo \n");
			exit(1);

		// Hijo
		case 0:
			printf ("[HIJO]: mi PID es %d y mi PPID es %d\n", getpid(), getppid());

            close(fildes[1]); // Cerramos extremo de escritura de la tubería
            for(i=0;i<5;i++) {
			    
			    bytes_leidos = read(fildes[0], buffer, MAX_SIZE);
			    
			    sprintf(log_buf,"[HIJO]: leemos el número aleatorio %s de la"
			        " tubería\n", buffer);
			    fichero = fopen("./ejercicio3.txt","w+");
			    fputs(log_buf, fichero);
			    fclose(fichero);
			    
			    //Leemos mensaje
			    printf("[HIJO]: leemos el número aleatorio %s de la tubería\n",
			        buffer);
			        
			    usleep(rand()%1000000);
			}
			close(fildes[0]);
			printf("[HIJO]: tubería cerrada. Salgo...\n");
			
			break; //Saldría del switch()

		// Padre
		default:
			printf ("[PADRE]: mi PID es %d y el PID de mi hijo es %d \n",
			    getpid(), rf);
			
			close(fildes[0]); // Cerramos extremo de lectura de la tubería
			for(i=0;i<5;i++) {
			    // Rellenamos el buffer que vamos a enviar
			    // Semilla de los números aleatorios,
			    // establecida a la hora actual
			    // Número aleatorio entre 0 y 4999
			    numeroAleatorio = rand()%5000;			
			    sprintf(buffer,"%d",numeroAleatorio);
			    
			    // Escribimos al fichero log
			    sprintf(log_buf,"[PADRE]: escribimos el número aleatorio %s en"
			        " la tubería\n", buffer);
			    fichero = fopen("./ejercicio3.txt","w+");
			    fputs(log_buf, fichero);
			    fclose(fichero);
			    
			    printf(log_buf);
			        
			    write(fildes[1], buffer, MAX_SIZE);
			    
			    usleep(rand()%1000000);
			}
			close(fildes[1]);
			printf("[PADRE]: tubería cerrada.\n");

			/*Espera del padre a los hijos*/
			while ((flag = wait(&status)) > 0)
			{
				if (WIFEXITED(status)) 
				{
					printf("Hijo PID:%ld finalizado, estado=%d\n", flag, WEXITSTATUS(status));
				} else if (WIFSIGNALED(status)) {  //Para seniales como las de finalizar o matar
					printf("Hijo  PID:%ld finalizado al recibir la señal %d\n", flag, WTERMSIG(status));
				} else if (WIFSTOPPED(status)) { //Para cuando se para un proceso. Al usar wait() en vez de waitpid() no nos sirve.
					printf("Hijo PID:%ld parado al recibir la señal %d\n", flag,WSTOPSIG(status));
				} else if (WIFCONTINUED(status)){ //Para cuando se reanuda un proceso parado. Al usar wait() en vez de waitpid() no nos sirve.
					printf("Hijo reanudado\n");		  
				}
			}
			if (flag==-1 && errno==ECHILD)
			{
				printf("No hay más hijos que esperar\n");
				printf("status de errno=%d, definido como %s\n", errno, strerror(errno));
			}
			else
			{
				printf("Error en la invocacion de wait o la llamada ha sido interrumpida por una señal.\n");
				exit(EXIT_FAILURE);
			}		 
	}

	exit(0);
}
