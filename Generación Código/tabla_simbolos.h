#ifndef _TABLA_SIMBOLOS_H
#define _TABLA_SIMBOLOS_H
#include <stdio.h>
#include <stdlib.h>

typedef enum {
    marca,
    funcion,            /* si es subprograma */
    variable,           /* si es variable */
    parametro_formal,   /* si es parametro formal */
} tipoEntrada ;

typedef struct {
    char *EtiquetaEntrada ;   /**/
    char *EtiquetaSalida ;    /**/
    char *EtiquetaElse ;      /**/
    char *NombreVarControl ;  /**/
} DescriptorDeInstrControl ;  

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
extern unsigned int TOPE_TD;
extern unsigned int Subprog ;      /* Indicador de comienzo de bloque de un subprog */
extern entradaTS TS[MAX_TS] ;      /* Pila de la tabla de símbolos */
extern DescriptorDeInstrControl TD[MAX_TS];
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
extern int N;                   /*Generacion de temporales*/
extern int etiq;                /*Generacion de etiquetas*/
extern char *codigo;            /*Codigo general del programa*/
extern char *etiquetado;        /*Codigo del etiquetado*/            
extern int mainDeclared;        /*Booleano de declaracion del main*/
extern int IO_TOPE;

extern int mylineno;            /* Número de línea para errores semánticos */

typedef struct {
    int atrib ;     /* Atributo del símbolo (si tiene) */
    char *lexema ;  /* Nombre del lexema */
    dtipo tipo ;    /* Tipo del símbolo */
    int dimension;
    int tamadim1;
    int tamadim2;
    char *vartemp;
    dtipo tipoVarTemp;
} atributos ;

extern atributos IOExpresions[100];  /* Para contar las expresiones de una función printf o scanf*/

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

/* Funciones para la generación de código intermedio */
char* temporal();
void generaCodigoExpBinaria(atributos *L, atributos a1, atributos op, atributos a2);
void generaCodigoExpUnaria(atributos *L, atributos a1, atributos op);
void generaDeclaracionVariable(atributos id);
/*
*   Funcion para la creacion de etiquetas necesarias para realizar los bucles
*   y las intracciones if else (?)
*/
char* generarEtiquetas();
/*
*   Funcion para generar las intrucciones if
*
*/
void generarIF(atributos a);
void generarELSE();
void generaWHILE(atributos a);
void Etiquetado(char* etiqENTRADA);
void generaOUT();
void generaIN();

#endif