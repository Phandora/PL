#ifndef _TABLA_SIMBOLOS_H
#define _TABLA_SIMBOLOS_H
#include <stdio.h>

typedef enum {
    marca,
    funcion,            /* si es subprograma */
    variable,           /* si es variable */
    parametro_formal,   /* si es parametro formal */
} tipoEntrada ;

typedef enum {
    entero,
    real,
    caracter,
    booleano,
    desconocido,
    no_asignado
} dtipo ;

typedef struct {
    tipoEntrada entrada ;
    char *nombre ;
    dtipo tipoDato ;
    unsigned int parametros ;
    unsigned int dimensiones ; 
    int TamDimen1 ; /* Tamaño Dimensión 1 */
    int TamDimen2 ; /* Tamaño Dimensión 2 */
} entradaTS ;


#define MAX_TS 500
extern unsigned int TOPE;       /* Tope de la pila */
extern unsigned int Subprog ;      /* Indicador de comienzo de bloque de un subprog */
extern entradaTS TS[MAX_TS] ;      /* Pila de la tabla de símbolos */
extern dtipo tipo_global;          /* Almacena el tipo global */
extern unsigned int funcion_actual;   /* SON LO MISMO */
extern int decVar;             /* Varible control */
extern int decParam;           /* Variable control */
extern int nParam;             /* Variable control */
extern int pos_fun;             /* Variable control */
extern int decSubprog;          /* Variable control */
extern int expArray;
extern int aux;
extern dtipo valorCteArray;

extern int mylineno;            /* Número de línea para errores semánticos */

typedef struct {
    int atrib ;     /* Atributo del símbolo (si tiene) */
    char *lexema ;  /* Nombre del lexema */
    dtipo tipo ;    /* Tipo del símbolo */
    int dimension;
    int tamadim1;
    int tamadim2;
} atributos ;

// A partir de ahora, cada símbolo tiene una estructura de tipo atributos
#define YYSTYPE atributos 

// FUNCIONES:

void insertarVariable(tipoEntrada entrada, char *name, dtipo type);
void insertarFuncion(char *name, dtipo type, unsigned int param);
void insertarArray(char *name, dtipo type, unsigned int dim, int dim1, int dim2);
void eliminarBloque();
entradaTS* buscarSimbolo(char *nombreSim,int declarar);
int buscarPos(char * nombreSim);
void insertarMarca();
void updateParam();
void valores_en_pila();

#endif