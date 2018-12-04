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
        printf("Insertar Variable  %s--%d\n",name,type);
    }
    else{
        printf("Error Sintáctico %s ya declarado", name);
    }
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
    printf("Marca insertada\n");
}

void eliminarBloque(){
    printf("Elimino Bloque\n");
	while (TS[TOPE].entrada != marca && TOPE > 0){
		TOPE--;
	}
	if(TOPE>0){
        TOPE--;
    }
    
}

void insertarFuncion(char *name, dtipo type, unsigned int param){
   
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
		printf("Inserto funcion %s\n",name);
    }
    else{
        printf("Error Sintáctico %s ya declarado", name);
    }
}

void insertarArray(char *name, dtipo type, unsigned int dim, int dim1, int dim2){
    
    entradaTS var   =    {.entrada = variable,
                          .nombre  = name,
                          .tipoDato = type,
                          .parametros = 0,
                          .dimensiones = dim,
                          .TamDimen1 = dim1,
                          .TamDimen2 = dim2};
    
    TS[TOPE];
    TOPE ++;
	printf("Inserto array %s\n",name);
}

entradaTS * buscarSimbolo(char * nombreSim){
    printf("Busco simbolo %s\n",nombreSim);
    for ( int i = TOPE-1; i >= 0; i--){
        //printf("%d\n",i);
        if (strcmp(TS[i].nombre, nombreSim) == 0){
            printf("Encontrado simbolo %s\n",nombreSim);
            return &TS[i];
        }
    
    }

    printf("Busco simbolo y no encuentro %s\n",nombreSim);
    return NULL;
}

int buscarPos(char * nombreSim){
    printf("Busco pos de %s\n",nombreSim);
    for ( int i = TOPE-1; i >= 0; i--){
        if (strcmp(TS[i].nombre, nombreSim) == 0){
			printf("Busco simbolo y esta en la pos %d\n",i);
            return i;
		}
    }
	
}


void updateParam(){
    printf("Aumentando el numero de parametros\n");
    ++TS[funcion_actual].parametros;
}


void valores_en_pila(){
	for ( int i = 0; i < TOPE; i++){
		printf("PILA- Pos:%d  Nombre:%s  Tipo:%d \n",i,TS[i].nombre,TS[i].tipoDato);
	}
}

