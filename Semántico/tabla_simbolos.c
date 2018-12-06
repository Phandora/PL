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
int decSubprog = 0;         /* Variable control */


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
     //   printf("Insertar Variable  %s--%d\n",name,type);
    }
    else{
        yyerror();
        printf("Error semántico %s ya declarado", name);
    }
}



void insertarMarca(){
    entradaTS var;
    if(decSubprog){
        var.entrada = marca;
        var.nombre  = "marca";
        var.tipoDato = desconocido;
        var.parametros = 0;
        var.dimensiones = 0;
        var.TamDimen1 = 0;
        var.TamDimen2 = 0;
    }
    else{
        var.entrada = marca;
        var.nombre  = "marcaNoSubprog";
        var.tipoDato = desconocido;
        var.parametros = 0;
        var.dimensiones = 0;
        var.TamDimen1 = 0;
        var.TamDimen2 = 0; 
    }

	TS[TOPE] = var; 
	TOPE++;
 //   printf("Marca insertada\n");

    // Si hemos insertado un subprograma, hay que insertar los parámetros
    // como variables locales.
    if(TOPE > 1 && decSubprog){
        int lastFuncPos = -1;
        for(int i = TOPE; i > 0; --i)
            if(TS[i].entrada == funcion){
                lastFuncPos = i;
                break;
            }        
            

        // Buscar parámetros formales:
        for(int i = lastFuncPos; i<TOPE; ++i)
            if(TS[i].entrada == parametro_formal)
                insertarVariable(variable, TS[i].nombre, TS[i].tipoDato);        
    }
}

void eliminarBloque(){
  
    //printf("Elimino Bloque\n");
	while (TS[TOPE-1].entrada != marca && TOPE > 0){
		//printf("%d",TOPE);
        //printf("\n");
        TOPE--;
	}
	if(TOPE>0){
        int pos = buscarPos("marca");
        TOPE--;
        for ( int i = pos; i >= 0; i--){
            if (TS[i].entrada ==funcion){
                funcion_actual= i;
                break;            
            }
        }
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
		///printf("Inserto funcion %s\n",name);
    }
    else{
        yyerror();
        printf("Error semántico %s ya declarado", name);
    }
}

void insertarArray(char *name, dtipo type, unsigned int dim, int dim1, int dim2){
    
    entradaTS *encontrado = buscarSimbolo(name);
    if(encontrado == NULL){
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
    else{
        yyerror();
        printf("Error array %s ya declarado\n",name);
    }
}

entradaTS * buscarSimbolo(char * nombreSim){
    //printf("Busco simbolo %s\n",nombreSim);
    int pos_marca= buscarPos("marca");  


    for ( int i = TOPE-1; i >= pos_marca; i--){
        //printf("%d\n",i);
        if (strcmp(TS[i].nombre, nombreSim) == 0){
           // printf("Encontrado simbolo %s\n",nombreSim);
            return &TS[i];
        }
    
    }

   // printf("Busco simbolo y no encuentro %s\n",nombreSim);
    return NULL;
}

int buscarPos(char * nombreSim){
  //  printf("Busco pos de %s\n",nombreSim);
    for ( int i = TOPE-1; i >= 0; i--){
        if (strcmp(TS[i].nombre, nombreSim) == 0){
		//	printf("Busco simbolo y esta en la pos %d\n",i);
            return i;
		}
    }
	
}

void updateParam(){
   // printf("Aumentando el numero de parametros\n");
    ++TS[funcion_actual].parametros;
}


void valores_en_pila(){
	for ( int i = 0; i < TOPE; i++){
		printf("PILA- Pos:%d  Nombre:%s  Tipo:%d , entrada: %d \n",i,TS[i].nombre,TS[i].tipoDato,TS[i].entrada);
	}
}

