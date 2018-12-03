#include "tabla_simbolos.h"
#include <string.h>


unsigned int TOPE=0 ;       /* Tope de la pila */
unsigned int Subprog ;      /* Indicador de comienzo de bloque de un subprog */
entradaTS TS[MAX_TS] ;      /* Pila de la tabla de símbolos */
dtipo tipo_global;          /* Almacena el tipo global */
unsigned int funcion_actual = -1;
int decVar = 0;             /* Varible control */
int decParam = 0;           /* Variable control */
int nParam = 0;             /* Variable control */
int pos_fun = 0;             /* Variable control */


void insertarVariable(tipoEntrada entrada, char *name, dtipo type){
    printf("Insertar Variable\n");
    entradaTS *encontrado = buscarSimbolo(name);
    if(encontrado == NULL){
        entradaTS var   =  {.entrada = entrada,
                            .nombre  = name,
                            .tipoDato = type,
                            .parametros = 0,
                            .dimensiones = 0,
                            .TamDimen1 = 0,
                            .TamDimen2 = 0 };
        TS[TOPE] = var;
        TOPE++;
        printf("Variable\n");
    }
    else{
        printf("Error Sintáctico %s ya declarado", name);
    }
}



void insertarMarca(){
    printf("Marca\n");
    entradaTS var   =    {.entrada = marca,
                          .nombre  = "marca",
                          .tipoDato = desconocido,
                          .parametros = 0,
                          .dimensiones = 0,
                          .TamDimen1 = 0,
                          .TamDimen2 = 0 };

	TS[TOPE] = var; 
	TOPE++;
    printf("Marca insertada\n");
}

void eliminarBloque(){
    printf("Elimino\n");
	while (TS[TOPE].entrada != marca && TOPE > 0){
		TOPE--;
	}
	if(TOPE>0){
        TOPE--;
    }
    
}

void insertarFuncion(char *name, dtipo type, unsigned int param){
    printf("Inserto funcion\n");
    entradaTS *encontrado = buscarSimbolo(name);
    if(encontrado == NULL){
        entradaTS var   =    {.entrada = funcion,
                              .nombre  = name,
                              .tipoDato = type,
                              .parametros = param,
                              .dimensiones = 0,
                              .TamDimen1 = 0,
                              .TamDimen2 = 0 };
        TS[TOPE] = var;
        funcion_actual = TOPE;
        TOPE++;
    }
    else{
        printf("Error Sintáctico %s ya declarado", name);
    }
}

void insertarArray(char *name, dtipo type, unsigned int dim, int dim1, int dim2){
    printf("Inserto array\n");
    entradaTS var   =    {.entrada = variable,
                          .nombre  = name,
                          .tipoDato = type,
                          .parametros = 0,
                          .dimensiones = dim,
                          .TamDimen1 = dim1,
                          .TamDimen2 = dim2};
    
    TS[TOPE];
    TOPE ++;
}

entradaTS * buscarSimbolo(char * nombreSim){
    printf("Busco simbolo\n");
    for ( int i = TOPE-1; i >= 0; i--){
        //printf("%d\n",i);
        if (strcmp(TS[i].nombre, nombreSim) == 0){
            printf("Encontrado simbolo\n");
            return &TS[i];
        }
    
    }

    printf("Busco simbolo y no encuentro\n");
    return NULL;
}

int buscarPos(char * nombreSim){
    printf("Busco pos\n");
    for ( int i = TOPE-1; i >= 0; i--){
        if (strcmp(TS[i].nombre, nombreSim) == 0)
            return i;
    }

    return NULL;
}


void updateParam(){
    printf("update\n");
    ++TS[funcion_actual].parametros;
}

