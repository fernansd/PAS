#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include <string.h>
#include <grp.h>

void mostraAyuda(int error);
void infoGrupo(struct group *gr, int lang);

int main (int argc, char **argv)
{
	int c;
	/* Estructura a utilizar por getoptlong */
	static struct option long_options[] =
	{
		/* Opciones que no van a actuar sobre un flag */
		/* "opcion", recibe o no un argumento, 0,
		   identificador de la opción */
		{"english",	 no_argument,	   0, 'e'},
		{"spanish",  no_argument,	   0, 's'},
		{"help",  no_argument,	   0, 'h'},
		{"all",  no_argument,	   0, 'a'},
		{"group",  required_argument, 0, 'g'},
		/* Necesario para indicar el final de las opciones */
		{0, 0, 0, 0}
	};

	/* Estas variables servirán para almacenar el resultado
           de procesar la línea de comandos */
	int langEsp = 0;
	int langEng = 0;
	int allFlag = 0;
	char *gValue = NULL;

	/* getopt_long guardará el índice de la opción en esta variable. */
	int option_index = 0;
	
	/* Deshabilitar la impresión de errores por defecto */
	/* opterr=0; */
	while ((c = getopt_long (argc, argv, "abc:d:f:",
		                long_options, &option_index))!=-1)
	{
		/* El usuario ha terminado de introducir opciones */
		if (c == -1)
			break;

		switch (c)
		{

		case 'e':
			langEng = 1;
			break;

		case 's':
			langEsp = 1;
			break;

		case 'g':
			gValue = optarg;
			break;

		case 'a':
			allFlag = 1;
			break;

		case 'h':
			mostraAyuda(0);
			exit(0);
			break;

		case '?':
			/* getopt_long ya imprime su mensaje de error, no 
			   es necesario hacer nada */
			/* Si queremos imprimir nuestros propios errores,
                           debemos poner opterr=0 y hacer algo así:
			if (optopt == 'c')
				fprintf (stderr, "La opción %c requiere un argumento.\n", optopt);*/
			break;

		default:
			abort ();
		}
	}
	
	// Comprueba si hay conflicto en las flag de idioma
    if (langEng && langEsp) {
        fprintf(stderr, "No se pueden usar las opciones 'e' y 's' a la vez\n");
        langEng = 0;
        langEsp = 0;
    }
    // Detecta idioma del sistema si no hay ninguno fijado
    if (!(langEsp || langEng)) {
        char *lang;
        lang = getenv("LANG");
        if (strstr(lang, "ES")) {
            langEsp = 1;
        } else {
            langEng = 1; // Idioma por defecto
        }
    }
    
    if (gValue) {
        int gid;
        struct group * gr;
        if ((gid = atoi(gValue)) == 0) {
            gr = (struct group*)getgrnam(gValue);
        } else {
            gr = (struct group*)getgrgid(gid);
        }
        infoGrupo(gr, langEsp);
    }
    
    if (allFlag) {
    	printf("Falta por implementar\n");
    }
    
    

	exit (0);
}

// Muestra la ayuda del programa, se le debe proporcionar un parámetro para
// saber si se imprime por un error al llamar la ejecución o por petición
// del usuario
void mostraAyuda(int error) {
	// Solo si hay error invocando el programa
	if(error)
		printf("La invocación correcta del programa es: <ejecutable> [opciones]\n");
	
	printf("Opciones:\n"
		"\t[--spanish -s] mensajes de programa es español\n"
		"\t[--english -e] mensajes del progrma en inglés\n"
		"\tLas flag de idioma [--spanish -s] y [--english -e] juntas\n"
		"\t[--help -h] sirve para invocar la ayuda del programa\n"
		"\t[--all -a] sirve para imprimir por pantalla toda la información de "
		" los grupos del sistema\n"
		"\t[--group -g] permite obtener informaicón sobre un grupo determinado"
		", el cual se pasa como parámetro\n");
	
	
}

// Recibe como idioma la variable langEsp
void infoGrupo(struct group *gr, int lang) {
    int i=0;
    if (lang == 0) {
        printf("Group Information\n==============\n");
        printf("\tName: %s\n", gr->gr_name);
        printf("\tGID: %d\n", gr->gr_gid);
        printf("\tGroup Members:\n");
        while (gr->gr_mem[i] != NULL)
            printf("\t\t-%s\n",gr->gr_mem[i]);
    } else if (lang == 1) {
        printf("Información de grupo\n==============\n");
        printf("\tNombre: %s\n", gr->gr_name);
        printf("\tGID: %d\n", gr-> gr_gid);
        printf("\tMiembros del grupo:\n");
        while (gr->gr_mem[i] != NULL)
            printf("\t-%s\n",gr->gr_mem[i]);
    } else {
        printf("Error en código de idioma al imprimir datos de grupo\n");
    }
}



