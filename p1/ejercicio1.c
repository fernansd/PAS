#include <unistd.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>

int main (int argc, char **argv)
{
    int uValue = 0,
        langEsp = 0,
        langEng = 0;
    char *nValue = NULL,
         *gValue = NULL;
    int index;
    int c;

    opterr = 0;
    
    while ((c = getopt (argc, argv, "u:n:g:es")) != -1)
    {
        switch (c)
        {
        // Da ID de usuario
        case 'u':
            uValue = atoi(optarg);
            break;
        // Da nombre de usuario
        case 'n':
            nValue = optarg;
            break;
        // Da ID o nombre del grupo
        case 'g':
            // !!!
            // Puede introducir cadena o entero revisar codigo de esta opción
            gValue = optarg;
            break;
        // Fija idioma a inglés
        case 'e':
            langEng = 1;
            break;
        // Fija idioma a español
        case 's':
            langEsp = 1;
            break;
        case '?':
            if (optopt == 'u' || optopt == 'n')
                fprintf (stderr, "La opción %c requiere un argumento.\n", optopt);
            else if (isprint (optopt))
                fprintf (stderr, "Opción desconocida '-%c'.\n", optopt);
            else
                fprintf (stderr, "Caracter `\\x%x'.\n", optopt);
            return 1;
        default:
            abort ();
        }
    }

    if (nValue && uValue) {
        fprintf(stderr, "No se pueden usar las opciones 'n' y 'u' a la vez\n");
        
    }
    if (langEng && langEsp) {
        fprintf(stderr, "No se pueden usar las opciones 'e' y 's' a la vez\n");
        langEng = 0;
        langEsp = 0;
    }
    
    // Detecta idioma si no hay ninguno fijado
    if (!(langEsp || langEng)) {
        char lang[32];
        lang = getenv("LANG");
        if (strstr(lang, "ES")
            langEsp = 1;
        else
            langEng = 1;
    }
    
    
    // Se imprime la información del usuario, en caso de no pasarse por
    // parametro se usa variable de entorno USER
    if (uValue)
        infoUsuarioId(uValue, langEsp);
        // Funcion sin implementar
    else if (nValue)
        infoUsuarioNombre(nValue, langEsp);
        // Funcion sin implementar
    else
        infoUsuarioNombre(getenv("USER"), langEsp);

    return 0;
}

void infoUsuarioId(int id, int lang) {
    struct passwd *pw;
    pw = getpwuid(uValue);
    printf("Nombre: %s\n", pw->pw_gecos);
    printf("Password: %s\n", pw->pw_passwd);
    printf("UID: %d\n", pw->pw_uid);
    printf("Home: %s\n", pw->pw_dir);
    printf("Número de grupo principal: %d\n", pw->pw_gid);
}

void infoUsuarioId(int id, int lang) {
    struct passwd *pw;
    pw = getpwuid(uValue);
    printf("Nombre: %s\n", pw->pw_gecos);
    printf("Password: %s\n", pw->pw_passwd);
    printf("UID: %d\n", pw->pw_uid);
    printf("Home: %s\n", pw->pw_dir);
    printf("Número de grupo principal: %d\n", pw->pw_gid);
}





