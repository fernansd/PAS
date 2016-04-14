#include <unistd.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pwd.h>
#include <grp.h>

void infoUsuario(struct passwd *pw, int lang);
void infoGrupo(struct group *gr, int lang);

int main (int argc, char **argv)
{
    int uValue = 0,
        langEsp = 0,
        langEng = 0;
    char *nValue = NULL,
         *gValue = NULL;
    int c;

    opterr = 0;
    
    while ((c = getopt (argc, argv, "u:n:g:es")) != -1)
    {
        switch (c)
        {
        case 'u': // Da ID de usuario
            uValue = atoi(optarg);
            break;

        case 'n': // Da nombre de usuario
            nValue = optarg;
            break;

        case 'g': // Da ID o nombre del grupo
            // !!!
            // Puede introducir cadena o entero revisar codigo de esta opción
            gValue = optarg;
            break;

        case 'e': // Fija idioma a inglés
            langEng = 1;
            break;

        case 's': // Fija idioma a español
            langEsp = 1;
            break;

        case '?':
            if (optopt == 'u' || optopt == 'n') {
                fprintf (stderr, "La opción %c requiere un argumento.\n", optopt);
            } else if (isprint (optopt)) {
                fprintf (stderr, "Opción desconocida '-%c'.\n", optopt);
            } else {
                fprintf (stderr, "Caracter `\\x%x'.\n", optopt);
            }
            return 1;

        default:
            abort ();
        }
    }

    // Comprueba si hay conflicto con la identificación del usuario
    if (nValue && uValue) {
        fprintf(stderr, "No se pueden usar las opciones 'n' y 'u' a la vez\n");

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


    // Se imprime la información del usuario, en caso de no pasarse por
    // parametro se usa variable de entorno USER
    struct passwd *pw;
    if (uValue) {
        pw = (struct passwd*)getpwuid(uValue);
    } else if (nValue) {
        pw = (struct passwd*)getpwnam(nValue);
    } else {
        pw = (struct passwd*)getpwnam(getenv("USER"));
    }

    infoUsuario(pw, langEsp); // Imprime información de usuario


    // En caso de haber proporcionado un identificador para grupo
    // se comprueba si ha sido el ID o el nombre
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

    return 0;
}


void infoUsuario(struct passwd *pw, int lang) {

    if (lang == 0) { // Idioma ingles
        printf("Name: %s\n", pw->pw_gecos);
        printf("Password: %s\n", pw->pw_passwd);
        printf("UID: %d\n", pw->pw_uid);
        printf("Home: %s\n", pw->pw_dir);
        printf("Main Group Name: %d\n", pw->pw_gid);
    } else if (lang == 1) { // Idioma español
        printf("Nombre: %s\n", pw->pw_gecos);
        printf("Contraseña: %s\n", pw->pw_passwd);
        printf("UID: %d\n", pw->pw_uid);
        printf("Carpeta inicio: %s\n", pw->pw_dir);
        printf("Número de grupo principal: %d\n", pw->pw_gid);
    } else {
        printf("Error código idioma al imprimir datos usuario\n");
    }
}

// Recibe como idioma la variable langEsp
void infoGrupo(struct group *gr, int lang) {
    int i=0;
    if (lang == 0) {
        printf("Group Information\n==============\n");
        printf("\tName: %s\n", gr->gr_name);
        printf("\tGID: %d\n", gr-> gr_gid);
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
        printf("Error código de idioma al imprimir datos de grupo\n");
    }
}




