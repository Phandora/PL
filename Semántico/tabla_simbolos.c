#include "tabla_simbolos.h"
#include <string.h>


void insertarVariable(tipoEntrada tipo, char *name, dtipo type){
    entradaTS var   =    {.entrada = variable,
                          .nombre  = name,
                          .tipoDato = tipo,
                          .parametros = 0,
                          .dimensiones = 0,
                          .TamDimen1 = 0,
                          .TamDimen2 = 0 };
    
    TS[TOPE] = var;
    TOPE++;
    
}



void insertarMarca(){
	
    entradaTS var   =    {.entrada = marca,
                          .nombre  = "marca",
                          .tipoDato = desconocido,
                          .parametros = 0,
                          .dimensiones = 0,
                          .TamDimen1 = 0,
                          .TamDimen2 = 0 };

	TS[TOPE] = var; 
	TOPE++;
	
}

void eliminarBloque(){
	
	entradaTS vacio =  {.entrada = None,
                        .nombre  = "",
                        .tipoDato = desconocido,
                        .parametros = 0,
                        .dimensiones = 0,
                        .TamDimen1 = 0,
                        .TamDimen2 = 0 };

	while (TS[TOPE].entrada != marca ){
		TS[TOPE]=vacio;
		TOPE--;
	}
	
	TS[TOPE]=vacio; 
	TOPE--;
	
}

void insertarFuncion(char *name, dtipo type, unsigned int param){

    
}



void insertarArray(char *name, dtipo type, unsigned int dim, int dim1, int dim2=0){
    entradaTS var   =    {.entrada = variable,
                          .nombre  = name,
                          .tipoDato = array,
                          .parametros = 0,
                          .dimensiones = dim,
                          .TamDimen1 = dim1,
                          .TamDimen2 = dim2,
                          .tipoArray = type };
    
    TS[TOPE];
    TOPE ++;
    
}

entradaTS * buscarSimbolo(char * nombreSim){
    for ( unsigned int i = TOPE; i >= 0; --i){
        if (strcmp(TS[i].nombre, nombreSim) == 0)
            return &TS[i];
    }

    return NULL;
}
