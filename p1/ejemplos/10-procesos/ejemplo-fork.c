#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h> //Control de errores
#include <string.h> //Para la funcion strerror()

int main()
{
    pid_t rf;
    int flag,status;
    rf = fork();
    switch (rf)
    {
    	case -1:
        printf ("No he podido crear el proceso hijo \n");
        exit(EXIT_FAILURE);
  	  case 0:
        printf ("Soy el hijo, mi PID es %d y mi PPID es %d \n", getpid(), getppid());
        exit(EXIT_SUCCESS);
  	  default:
        printf ("Soy el padre, mi PID es %d y el PID de mi hijo es %d \n", getpid(), rf);
    }

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
