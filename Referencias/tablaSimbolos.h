
#ifndef __TABLA_SIMBOLOS_H
#define __TABLA_SIMBOLOS_H

#include <stdio.h>
#include <stdlib.h>

//Indica el tipo de entrada para la tabla de simbolos
typedef enum  {
    Marca=0,
    Funcion,
    Variable,
    Parametro_formal
} TipoEntrada;

//Enumeracion de los tipos del lenguaje
typedef enum {
    Logico=0,
    Caracter,
    Real,
    Entero,
    Array,
    Desconocido,
    NoAsignado
} TipoDato;


//Representa una entrada en la tabla de simbolos
typedef struct {
    TipoEntrada tipoEntrada;
    char* nombre;
    TipoDato tipoDato;
    int Parametros;
    int NumeroDimensiones;
    int tamanyoDim1;
    int tamanyoDim2;
} Entrada;

typedef struct {
    int atrib;
    char* lexema;
    TipoDato tipo;
    int numDim;
    int tamDim1;
    int tamDim2;
} Atributos;


#define YYSTYPE Atributos
#define MAX_ENTRADAS 500
extern Entrada TS[MAX_ENTRADAS];
extern long int TOPE;
extern TipoDato global_tipo;				// Variable global para almacenar el tipo en las declaraciones
extern int subProg;							// Variable que indica el comienzo de una declaracion de un subprograma o funcion
extern int tope_subprog;					// Sirve para indicar en que indice se encuentra la entrada de subprograma para cuando se inserten las entradas de los parametros
extern int linea_actual;					// Variable que almacena la linea actual por la cual se va analizando
extern int funcionActual;				    // Variable que almacena el indice de la entrada de la TS de la funcion que se esta analizando para realizar la comprobacion de tipos a sus parametros
extern int contador_param;					// Contador que sirve para llevar la cuenta de que parametro estamos analizando
extern int pila_fun[MAX_ENTRADAS];
extern int tope_fun;
extern int pila_cont[MAX_ENTRADAS];
extern int tope_cont;

//------------  Funciones adicionales  ----------------------------------------------
/**
 * Ajusta la variable global_tipo segun se cambie el tipo en las declaraciones de variables
 */
void ajustaTipo(Atributos e);

/**
 * Inserta un nuevo identificador en la tabla de simbolos
 */
void TS_InsertaIDENT(Atributos e, int NumDim, int TamDim1, int TamDim2);

/**
 * Inserta una marca de comienzo de un bloque
 */
void TS_InsertaMARCA();

/**
 * Inserta una entrada de subprograma en la tabla de simbolos
 */
void TS_InsertaSUBPROG(Atributos ident, Atributos tipoRetorno);

/**
 * Inserta una entrada de parametro formal de un subprograma en la tabla de simbolos
 */
void TS_InsertaPARAMF(Atributos e);

/**
 * Indica si el atributo es un array o no
 */
int esArray(Atributos e);

/**
 * Indica que si siendo arrays los dos atributos tienen el mismo tamanyo.
 */
int mismoTamanyo(Atributos e1, Atributos e2);

//------------  Funciones para las comprobaciones semanticas ------------------------
/**
 * Busca la entrada de tipo Funcion mas proxima desde el tope de la tabla de simbolos
 * y devuelve el indice
 */
int TS_BuscarFuncionProxima();

/**
 * Comprobacion semantica de la sentencia de retorno.
 * Comprueba que el tipo de expresion es el mismo que el de la funcion
 * donde se encuentra
 */
void TS_CompruebaSENTRETORNO(Atributos expresion, Atributos* retorno);

/**
 * Busca el identificador en la tabla de simbolos y lo rellena en el atributo de salida
 */
void TS_GetIDENT(Atributos identificador, Atributos* res);

/**
 * Comprobacion semantica de la operacion NOT
 */
void TS_OPNOT(Atributos operador, Atributos o, Atributos* res);

/**
 * Comprobacion semantica de los operadores unarios + y -
 */
void TS_OPSUMARESunario(Atributos operador, Atributos o, Atributos* res);

/**
 * Comprobacion semantica de las operaciones * y /
 */
void TS_OPMULDIV(Atributos o1, Atributos operador, Atributos o2, Atributos* res);

/**
 * Comprobacion semantica de las operaciones || y XOR
 */
void TS_OPOR(Atributos o1, Atributos operador, Atributos o2, Atributos* res);

/**
 * Comprobacion semantica de la operacion **
 */
void TS_OPPOT(Atributos o1, Atributos operador, Atributos o2, Atributos* res);

/**
 * Comprobacion semantica de las operaciones <, >, <= y >=
 */
void TS_OPREL(Atributos o1, Atributos operador, Atributos o2, Atributos* res);

/**
 * Comprobacion semantica de las operaciones == y !=
 */
void TS_OPIGUAL(Atributos o1, Atributos operador, Atributos o2, Atributos* res);

/**
 * Comprobacion semantica de las operaciones &&
 */
void TS_OPAND(Atributos o1, Atributos operador, Atributos o2, Atributos* res);

/**
 * Comprobacion semantica de las operaciones binarias + y -
 */
void TS_OPSUMRES(Atributos o1, Atributos operador, Atributos o2, Atributos* res);

/**
 * Comprobacion semantica de la llamada a subprograma
 */
void TS_LlamadaFuncion(Atributos identificador, Atributos* res);

/**
 * Comprobacion semantica de cada parametro en una llamada a una funcion
 */
void TS_CompruebaParametro(Atributos parametro);


//------------  Funciones de manejo de la Tabla de Simbolos  ------------------------
/**
  * Anyade una entrada a la tabla de simbolos 
**/
void anyadir_entrada(TipoEntrada tipoEntrada, char* nombre,  TipoDato tipoDato, int Parametros, int NumeroDimensiones, int tamanyoDim1, int tamanyoDim2);

/**
  * Quita todas las entradas hasta que encuentre una entrada especial de marca
**/
void quitarBloqueCompleto();

/**
  * Busca una entrada dado su nombre:
  * Si la encuentra devuelve el indice donde se encuentra la entrada
  * Si no la encuentra devuelve -1
**/
int buscarEntrada (char* nombre, Entrada* entrada);




//----------------------  Funciones de Impresion --------------------------------------

/**
 * Imprime como una cadena de caracteres una entrada de la tabla de simbolos dada
 */
void imprimirEntrada(Entrada* e);

/**
  * Imprime como cadena el tipo de entrada dado
**/
void imprimeTipoEntrada(TipoEntrada tipo);

/**
  * Imprime como cadena el tipo de dato dado
**/ 
void imprimeTipoDato(TipoDato tipo);

/**
 * Imprime por pantalla la tabla de simbolos a continuacion del mensaje dado
 */
void imprimeTS(char* mensaje);

/**
 * Imprime por pantalla la informacion asociada al atributo
 */
void imprimeAtributo(Atributos e);


#endif
