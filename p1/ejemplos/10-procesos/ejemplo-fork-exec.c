#include <unistd.h>
#include <sys/wait.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h> //Control de errores
#include <string.h> //Para la funcion strerror()

int main()
{
    pid_t pid;
    int status, died;
    int flag,status;

    char *args[] = {"/bin/ls", "-t", "-l", (char *) 0 };

    switch(pid=fork())
    {
		 case -1:
		     printf("can't fork\n");
		     exit(EXIT_FAILURE);
		 case 0 :
		     printf("Hijo %d ejecutando comando ls...\n",getpid()); // código que ejecuta el hijo
		     execv("/bin/ls", args);
		 //default:
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
