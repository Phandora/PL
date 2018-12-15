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
int mylineno = 1;
int expArray = 0;
int aux = 0;
dtipo valorCteArray=desconocido;
int N = 0;
char *codigo;
int mainDeclared = 0;
int etiq=0; 
unsigned int TOPE_TD=0;
DescriptorDeInstrControl TD[MAX_TS];

void insertarVariable(tipoEntrada entrada, char *name, dtipo type){
   
    entradaTS *encontrado = buscarSimbolo(name,1);
    if(encontrado == NULL){
        entradaTS var   =  {.entrada = entrada,
                            .nombre  = name,
                            .tipoDato = type,
                            .parametros = 0,
                            .dimensiones = 0,
                            .TamDimen1 = 0,
                            .TamDimen2 = 0};
        TS[TOPE] = var;
        TOPE++;
     //   printf("Insertar Variable  %s--%d\n",name,type);
    }
    else{        
        printf("(Linea %d) Error semántico: %s ya declarado\n", mylineno, name);
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
        var.nombre  = "marca"; // "marcaNoSubprog"
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
        TOPE--;
        int pos = buscarPos("marca");
        for ( int i = pos; i >= 0; i--){
            if (TS[i].entrada ==funcion){
                funcion_actual= i;
                break;            
            }
        }
    }
    
}

void insertarFuncion(char *name, dtipo type, unsigned int param){
   
    entradaTS *encontrado = buscarSimbolo(name,1);
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
        printf("(Linea %d) Error semántico: %s ya declarada\n", mylineno, name);
    }
}

void insertarArray(char *name, dtipo type, unsigned int dim, int dim1, int dim2){
     
   
    entradaTS *encontrado = buscarSimbolo(name,1);
    if(encontrado == NULL){
        entradaTS var   =    {.entrada = variable,
                            .nombre  = name,
                            .tipoDato = type,
                            .parametros = 0,
                            .dimensiones = dim,
                            .TamDimen1 = dim1,
                            .TamDimen2 = dim2};
        
        TS[TOPE]=var;
        TOPE ++;
    
    }   
    else{
        printf("(Linea %d) Error semántico: Array %s ya declarado\n", mylineno, name);
    }
}

entradaTS * buscarSimbolo(char * nombreSim, int declarar){
    //printf("Busco simbolo %s\n",nombreSim);
    int pos_marca=0;

    if(declarar==1)
        pos_marca= buscarPos("marca");  
    
    
    for ( int i = TOPE-1; i >= pos_marca; i--){
        //printf("%d\n",i);
        if (strcmp(TS[i].nombre, nombreSim) == 0 && (TS[i].entrada != parametro_formal)){
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


/////////////////////////////////////////////////////////
// Funciones para la generación de código intermedio
/////////////////////////////////////////////////////////

char* temporal(){
    char *tmp = (char*) malloc(80*sizeof(char));
    sprintf(tmp, "temp%d", N);
    ++N;
    return tmp;
}


void generaCodigoExpBinaria(atributos *L, atributos a1, atributos op, atributos a2){
    char *tipo = (char*) malloc(5*sizeof(char));
    char *signo = (char*) malloc(2*sizeof(char));
    char *tmp = (char*) malloc(100*sizeof(char));
    char *var1 = malloc(100*sizeof(char));
    char *var2 = malloc(100*sizeof(char));

    signo = op.lexema;

    if(strcmp(op.lexema, ">") == 0 || strcmp(op.lexema, ">=") == 0 || strcmp(op.lexema, "<") == 0 || strcmp(op.lexema, "<=") == 0 ||
       strcmp(op.lexema, "==") == 0 ||strcmp(op.lexema, "!=") == 0){
        tipo = "int";
    }
    else{
        switch(a1.tipo){
            case entero: tipo = "int"; break;
            case real: tipo = "float"; break;
            case caracter: tipo = "char"; break;
            case booleano: tipo = "int"; break;    
        }
    }

    if(a1.vartemp == NULL){
        var1 = a1.lexema;
    } else {
        var1 = a1.vartemp;
    }

    if(a2.vartemp == NULL){
        var2 = a2.lexema;
    } else {
        var2 = a2.vartemp;
    }

    char *localcode = (char*) malloc(200*sizeof(char));
    tmp = temporal();
    sprintf(localcode, "%s %s;\n%s = %s %s %s;\n", tipo, tmp, tmp, var1, signo, var2);
    strcat(codigo, localcode);
    L->vartemp = tmp;
}


void generaCodigoExpUnaria(atributos *L, atributos a1, atributos op){
    char *tipo = (char*) malloc(5*sizeof(char));
    char *signo = (char*) malloc(2*sizeof(char));
    char *tmp = (char*) malloc(100*sizeof(char));
    char *var1 = malloc(100*sizeof(char));

    signo = op.lexema;

    switch(a1.tipo){
        case entero: tipo = "int"; break;
        case real: tipo = "float"; break;
        case caracter: tipo = "char"; break;
        case booleano: tipo = "int"; break;    
    }
    

    if(a1.vartemp == NULL){
        if(strcmp(a1.lexema, "verdadero") == 0)
            var1 = "1";
        else if (strcmp(a1.lexema, "falso") == 0)
            var1 = "0";
        else
            var1 = a1.lexema;
    } else {
        var1 = a1.vartemp;
    }

    char *code = (char*) malloc(100*sizeof(char));
    tmp = temporal();
    sprintf(code, "%s %s;\n%s = %s %s;\n", tipo, tmp, tmp, signo, var1);
    strcat(codigo, code);
    L->vartemp = tmp;
}


void generaDeclaracionVariable(atributos id){
    entradaTS *aux = buscarSimbolo(id.lexema, 0);
    char *tipo = (char*) malloc(5*sizeof(char));
    char *res = (char*) malloc(50*sizeof(char));

    switch(aux->tipoDato){
        case entero: strcpy(tipo, "int"); break;
        case real: strcpy(tipo, "float"); break;
        case caracter: strcpy(tipo, "char"); break;
        case booleano: strcpy(tipo, "int"); break;
    }

    sprintf(res, "%s %s;\n", tipo, id.lexema);
    strcat(codigo, res);
}

char* generarEtiquetas(){
    char *tmp = (char*) malloc(80*sizeof(char));
    sprintf(tmp, "etiqueta%d", etiq);
    ++etiq;
    return tmp;
}

void generarIF(atributos a){
    char *localcode = (char*) malloc(100*sizeof(char));
    DescriptorDeInstrControl tmp = {.EtiquetaSalida = generarEtiquetas(),
                                    .EtiquetaElse = generarEtiquetas()};
    
    
    sprintf(localcode, "if(!%s) goto %s;\n", a.vartemp, tmp.EtiquetaElse);
    strcat(codigo, localcode);
    TD[TOPE_TD] = tmp;  
    TOPE_TD ++;         
}

void generarELSE(){
    char *localcode = (char*) malloc(100*sizeof(char));
    DescriptorDeInstrControl aux = TD[TOPE_TD-1];
    strcat(codigo, aux.EtiquetaElse);
    strcat(codigo, ": //Etiqueta else\n");    
}

