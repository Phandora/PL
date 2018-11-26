
#include "tablaSimbolos.h"
#include <stdio.h>
#include <string.h>

long int TOPE=-1;
Entrada TS[MAX_ENTRADAS];
TipoDato global_tipo = Desconocido;
int subProg = 0;
int tope_subprog=-1;
int linea_actual=1;
int funcionActual = -1;
int contador_param=0;
int pila_fun[MAX_ENTRADAS];
int tope_fun=-1;
int pila_cont[MAX_ENTRADAS];
int tope_cont=-1;
int hay_error=0;



//------------  Funciones ------------------------
/**
 * Ajusta la variable global_tipo segun se cambie el tipo en las declaraciones de variables
 */
void ajustaTipo(Atributos e) {
	if (e.atrib==0) {
		global_tipo=Entero;
	}
	else if (e.atrib==1) {
		global_tipo=Real;
	}
	else if (e.atrib==3) {
		global_tipo=Caracter;
	}
	else if (e.atrib==2) {
		global_tipo=Logico;
	}
	else {
		fprintf(stderr,"Error linea %d: Tipo irreconocible.\n",linea_actual);
		//exit(1);
		hay_error=1;
	}
}

/**
 * Inserta un nuevo identificador en la tabla de simbolos
 */
void TS_InsertaIDENT(Atributos e, int NumDim, int TamDim1, int TamDim2) {
	//Buscar si existe un identificador igual en la tabla de simbolos en el mismo bloque
	int encontrada_marca = 0;
	int i = TOPE;
	while (i>=0 && !encontrada_marca) {
		if (strcmp(e.lexema,TS[i].nombre)==0) {
			fprintf(stderr,"Error linea %d: Identificador %s ya declarado previamente en este bloque.\n",linea_actual,e.lexema);
			//exit(1);
			hay_error=1;
		}
		if (TS[i].tipoEntrada==Marca) {
			encontrada_marca=1;
		}
		i--;
	}

	//Como no se ha encontrado, procedemos a insertarlo
	anyadir_entrada(Variable,e.lexema,global_tipo,0,NumDim,TamDim1,TamDim2);
}

/**
 * Inserta una marca de comienzo de un bloque
 */
void TS_InsertaMARCA() {
	anyadir_entrada(Marca,"",Desconocido,0,0,0,0);
	if (subProg==1) {
		//printf("Marca: subprog==1\n");
		int i=TOPE;
		int encontrada_marca=0;
		int encontrada_funcion=0;
		while (i>=0 && !encontrada_funcion) {
			if (!encontrada_marca && TS[i].tipoEntrada==Marca) {
				encontrada_marca=1;
			}
			if (TS[i].tipoEntrada==Funcion) {
				encontrada_funcion=1;
			}
			if (encontrada_marca && TS[i].tipoEntrada==Parametro_formal) {
				anyadir_entrada(Variable,strdup(TS[i].nombre),TS[i].tipoDato,TS[i].Parametros,TS[i].NumeroDimensiones,TS[i].tamanyoDim1,TS[i].tamanyoDim2);
			}
			i--;
		}
	}
}

/**
 * Inserta una entrada de subprograma en la tabla de simbolos
 */
void TS_InsertaSUBPROG(Atributos ident, Atributos tipoRetorno) {
	anyadir_entrada(Funcion,strdup(ident.lexema),global_tipo,0,tipoRetorno.numDim,tipoRetorno.tamDim1,tipoRetorno.tamDim2);
	tope_subprog=TOPE;
}

/**
 * Inserta una entrada de parametro formal de un subprograma en la tabla de simbolos
 */
void TS_InsertaPARAMF(Atributos e) {
	if (tope_subprog>-1) {
		TS[tope_subprog].Parametros += 1;
		anyadir_entrada(Parametro_formal,strdup(e.lexema),global_tipo,0,e.numDim,e.tamDim1,e.tamDim2);
	}
	else {
		fprintf(stderr,"Error inesperado linea %d: no se puede añadir el parametro formal.\n",linea_actual);
		//exit(1);
		hay_error=1;
	}
}

/**
 * Indica si el atributo es un array o no
 */
int esArray(Atributos e) {
	return (e.numDim!=0);
}

/**
 * Indica que si siendo arrays los dos atributos tienen el mismo tamanyo.
 */
int mismoTamanyo(Atributos e1, Atributos e2) {
	return (e1.numDim==e2.numDim && e1.tamDim1==e2.tamDim1 && e1.tamDim2==e2.tamDim2);
}

/**
 * Busca la entrada de tipo Funcion mas proxima desde el tope de la tabla de simbolos
 * y devuelve el indice. Si no la encuentra devuelve -1
 */
int TS_BuscarFuncionProxima() {
	int i = TOPE;
	int encontrado = 0;
	int encontrada_marca=0;
	int indice = -1;
	while (i >= 0 && !encontrado) {
		if (TS[i].tipoEntrada==Marca) {
			encontrada_marca=1;
		}
		if (encontrada_marca && TS[i].tipoEntrada==Funcion) {
			encontrado = 1;
			indice = i;
		}
		i--;
	}
	return indice;
}

/**
 * Comprobacion semantica de la sentencia de retorno.
 * Comprueba que el tipo de expresion es el mismo que el de la funcion
 * donde se encuentra
 */
void TS_CompruebaSENTRETORNO(Atributos expresion, Atributos* retorno) {
	int indice = TS_BuscarFuncionProxima();
	if (indice>-1) {
		if (expresion.tipo!=TS[indice].tipoDato) {
			fprintf(stderr,"Error linea %d: La expresion de la sentencia retorno no es del tipo que devuelve la funcion.\n",linea_actual);
			//exit(1);
			hay_error=1;
		}
		Atributos tmp;
		tmp.numDim=TS[indice].NumeroDimensiones;
		tmp.tamDim1=TS[indice].tamanyoDim1;
		tmp.tamDim2=TS[indice].tamanyoDim2;
		if (!mismoTamanyo(expresion,tmp)) {
			fprintf(stderr,"Error linea %d: La expresion de la sentencia retorno no es del mismo tamanyo que la que devuelve la funcion.\n",linea_actual);
			//exit(1);
			hay_error=1;
		}
		retorno->tipo=expresion.tipo;
		retorno->numDim=expresion.numDim;
		retorno->tamDim1=expresion.tamDim1;
		retorno->tamDim2=expresion.tamDim2;
	}
	else {
		fprintf(stderr,"Error linea %d: La sentencia retorno no se encuentra declarada dentro de ninguna funcion.\n",linea_actual);
		//exit(1);
		hay_error=1;
	}
}

/**
 * Busca el identificador en la tabla de simbolos y lo rellena en el atributo de salida
 */
void TS_GetIDENT(Atributos identificador, Atributos* res) {
	Entrada e;
	int indice=buscarEntrada(identificador.lexema,&e);
	int seguir=1;
	while(seguir) {
		if (indice>-1 && e.tipoEntrada==Variable)
			seguir=0;
		if (indice==-1)
			seguir=0;
		indice=buscarEntrada(identificador.lexema,&e);
	}
	if(indice==-1) {
		fprintf(stderr,"Error linea %d: No se ha encontrado el identificador %s.\n",linea_actual,identificador.lexema);
	}
	res->lexema=strdup(e.nombre);
	res->tipo=e.tipoDato;
	res->numDim=e.NumeroDimensiones;
	res->tamDim1=e.tamanyoDim1;
	res->tamDim2=e.tamanyoDim2;
}

/**
 * Comprobacion semantica de la operacion NOT
 */
void TS_OPNOT(Atributos operador, Atributos o, Atributos* res) {
	if (o.tipo != Logico || esArray(o)) {
		fprintf(stderr,
				"Error linea %d: El operador NOT espera una expresion de tipo Logico.",
				linea_actual);
		//exit(1);
		hay_error=1;
	}
	res->tipo = Logico;
	res->numDim = 0;
	res->tamDim1 = 0;
	res->tamDim2 = 0;
}

/**
 * Comprobacion semantica de los operadores unarios + y -
 */
void TS_OPSUMARESunario(Atributos operador, Atributos o, Atributos* res) {
	if ((o.tipo != Real && o.tipo != Entero) || esArray(o)) {
		fprintf(stderr,"Error linea %d: El operador + o - esperaba una expresion de tipo Real o Entero.",linea_actual);
		//exit(1);
		hay_error=1;
	}
	res->tipo = o.tipo;
	res->numDim = 0;
	res->tamDim1 = 0;
	res->tamDim2 = 0;
}

/**
 * Comprobacion semantica de las operaciones * y /
 */
void TS_OPMULDIV(Atributos o1, Atributos operador, Atributos o2, Atributos* res) {
	if (o1.tipo != o2.tipo) {
			fprintf(stderr,
					"Error linea %d: El operador * o / espera que los tipos de los operandos sean iguales.\n",
					linea_actual);
			//exit(1);
			hay_error=1;
		}
		if (o1.tipo != Entero && o2.tipo != Real) {
			fprintf(stderr,
					"Error linea %d: Tipo invalido de los operandos. Se esperaba Entero o Real para los dos operandos.\n",
					linea_actual);
			//exit(1);
			hay_error=1;
		}
		if (esArray(o1) && esArray(o2)){
			if(mismoTamanyo(o1,o2)) {
				res->tipo = o1.tipo;
				res->numDim = o1.numDim;
				res->tamDim1 = o1.tamDim1;
				res->tamDim2 = o1.tamDim2;
			}
			else {
				fprintf(stderr,"Error linea %d: Los arrays son de distinto tamanyo.",linea_actual);
				//exit(1);
				hay_error=1;
			}
		}
		else if (esArray(o1) && !esArray(o2)) {
			res->tipo = o1.tipo;
			res->numDim = o1.numDim;
			res->tamDim1 = o1.tamDim1;
			res->tamDim2 = o1.tamDim2;
		}
		else if (!esArray(o1) && esArray(o2)) {
			if (strcmp(operador.lexema,"/")==0) {
				fprintf(stderr,"Error linea %d: No se puede dividir un valor con un array.",linea_actual);
				//exit(1);
				hay_error=1;
			}
			else {
				res->tipo = o2.tipo;
				res->numDim = o2.numDim;
				res->tamDim1 = o2.tamDim1;
				res->tamDim2 = o2.tamDim2;
			}
		}
		else {
			res->tipo = o1.tipo;
			res->numDim = 0;
			res->tamDim1 = 0;
			res->tamDim2 = 0;
		}
}

/**
 * Comprobacion semantica de las operaciones || y XOR
 */
void TS_OPOR(Atributos o1, Atributos operador, Atributos o2, Atributos* res) {
	if (o1.tipo != o2.tipo) {
		fprintf(stderr,
				"Error linea %d: El operador OR o XOR espera que los tipos de los operandos sean iguales.",
				linea_actual);
		//exit(1);
		hay_error=1;
	}
	if (o1.tipo != Logico || esArray(o1) || esArray(o2)) {
		fprintf(stderr,
				"Error linea %d: Tipo invalido de los operandos. Se esperaba Logico para los dos operandos.",
				linea_actual);
		//exit(1);
		hay_error=1;
	}
	res->tipo = Logico;
	res->numDim = 0;
	res->tamDim1 = 0;
	res->tamDim2 = 0;
}

/**
 * Comprobacion semantica de la operacion **
 */
void TS_OPPOT(Atributos o1, Atributos operador, Atributos o2, Atributos* res) {
	if (o1.tipo != o2.tipo) {
		fprintf(stderr,
				"Error linea %d: El operador ** espera que los tipos de los operandos sean iguales.",
				linea_actual);
		//exit(1);
		hay_error=1;
	}
	if (o1.tipo != Entero && o2.tipo != Real) {
		fprintf(stderr,
				"Error linea %d: Tipo invalido de los operandos. Se esperaba Entero o Real para los dos operandos.\n",
				linea_actual);
		//exit(1);
		hay_error=1;
	}
	if (esArray(o1) && esArray(o2)) {
		if (o1.tamDim1 == o2.tamDim2) {
			res->tipo = o1.tipo;
			res->tamDim1 = o2.tamDim1;
			res->tamDim2 = o1.tamDim2;
			res->numDim = (res->tamDim2 > 0) ? 2 : 1;
			//printf("resultado: \n"); imprimeAtributo(*res);
		} else {
			fprintf(stderr,
					"Error linea %d: No puede realizarse la multiplicacion de matrices porque los tamanyos de los arrays son invalidos.\n",
					linea_actual);
			//exit(1);
			hay_error=1;
		}
	} else if (esArray(o1) || esArray(o2)) {
		fprintf(stderr,
				"Error linea %d: Operandos invalidos para el operador **.\n",
				linea_actual);
		//exit(1);
		hay_error=1;
	} else {
		res->tipo = o1.tipo;
		res->numDim = 0;
		res->tamDim1 = 0;
		res->tamDim2 = 0;
	}

}

/**
 * Comprobacion semantica de las operaciones <, >, <= y >=
 */
void TS_OPREL(Atributos o1, Atributos operador, Atributos o2, Atributos* res) {
	if (o1.tipo != o2.tipo) {
		fprintf(stderr,
				"Error linea %d: El operador <,>,<= o >= espera que los tipos de los operandos sean iguales.",
				linea_actual);
		//exit(1);
		hay_error=1;
	}
	if ((o1.tipo != Entero && o2.tipo != Real) || esArray(o1) || esArray(o2)) {
		fprintf(stderr,
				"Error linea %d: Tipo invalido de los operandos. Se esperaba Entero o Real para los dos operandos.",
				linea_actual);
		//exit(1);
		hay_error=1;
	}
	res->tipo = Logico;
	res->numDim = 0;
	res->tamDim1 = 0;
	res->tamDim2 = 0;
}

/**
 * Comprobacion semantica de las operaciones == y !=
 */
void TS_OPIGUAL(Atributos o1, Atributos operador, Atributos o2, Atributos* res) {
	if (o1.tipo != o2.tipo) {
		fprintf(stderr,
				"Error linea %d: El operador == o != espera que los tipos de los operandos sean iguales.",
				linea_actual);
		//exit(1);
		hay_error=1;
	}
	if (esArray(o1) || esArray(o2)) {
		fprintf(stderr,
				"Error linea %d: Tipo invalido de los operandos. Se esperaba Entero o Real para los dos operandos.",
				linea_actual);
		//exit(1);
		hay_error=1;
	}
	res->tipo = Logico;
	res->numDim = 0;
	res->tamDim1 = 0;
	res->tamDim2 = 0;
}

/**
 * Comprobacion semantica de las operaciones &&
 */
void TS_OPAND(Atributos o1, Atributos operador, Atributos o2, Atributos* res) {
	if (o1.tipo != o2.tipo) {
		fprintf(stderr,
				"Error linea %d: El operador AND espera que los tipos de los operandos sean iguales.",
				linea_actual);
		//exit(1);
		hay_error=1;
	}
	if (o1.tipo != Logico || esArray(o1) || esArray(o2)) {
		fprintf(stderr,
				"Error linea %d: Tipo invalido de los operandos. Se esperaba Logico para los dos operandos.",
				linea_actual);
		//exit(1);
		hay_error=1;
	}
	res->tipo = Logico;
	res->numDim = 0;
	res->tamDim1 = 0;
	res->tamDim2 = 0;
}

/**
 * Comprobacion semantica de las operaciones binarias + y -
 */
void TS_OPSUMRES(Atributos o1, Atributos operador, Atributos o2, Atributos* res) {
	if (o1.tipo != o2.tipo) {
		fprintf(stderr,
				"Error linea %d: El operador + o - espera que los tipos de los operandos sean iguales.",
				linea_actual);
		//exit(1);
		hay_error=1;
	}
	if (o1.tipo != Entero && o2.tipo != Real) {
		fprintf(stderr,
				"Error linea %d: Tipo invalido de los operandos. Se esperaba Entero o Real para los dos operandos.",
				linea_actual);
		//exit(1);
		hay_error=1;
	}
	if (esArray(o1) && esArray(o2)){
		if(mismoTamanyo(o1,o2)) {
			res->tipo = o1.tipo;
			res->numDim = o1.numDim;
			res->tamDim1 = o1.tamDim1;
			res->tamDim2 = o1.tamDim2;
		}
		else {
			fprintf(stderr,"Error linea %d: Los arrays son de distinto tamanyo.",linea_actual);
			//exit(1);
			hay_error=1;
		}
	}
	else if (esArray(o1) && !esArray(o2)) {
		res->tipo = o1.tipo;
		res->numDim = o1.numDim;
		res->tamDim1 = o1.tamDim1;
		res->tamDim2 = o1.tamDim2;
	}
	else if (!esArray(o1) && esArray(o2)) {
		if (strcmp(operador.lexema,"-")==0) {
			fprintf(stderr,"Error linea %d: No se puede restar un valor con un array.",linea_actual);
			//exit(1);
			hay_error=1;
		}
		else {
			res->tipo = o2.tipo;
			res->numDim = o2.numDim;
			res->tamDim1 = o2.tamDim1;
			res->tamDim2 = o2.tamDim2;
		}
	}
	else {
		res->tipo = o1.tipo;
		res->numDim = 0;
		res->tamDim1 = 0;
		res->tamDim2 = 0;
	}
}

/**
 * Comprobacion semantica de la llamada a subprograma
 */
void TS_LlamadaFuncion(Atributos identificador, Atributos* res) {
	//Buscar la entrada de la funcion
	Entrada e;
	int indice = buscarEntrada(identificador.lexema,&e);
	int seguir=1;
	while(seguir) {
		if (indice>-1 && e.tipoEntrada==Funcion) {
			seguir=0;
		}
		if (indice==-1) {
			seguir=0;
		}
	}
	if (indice>-1 && e.tipoEntrada==Funcion) {
		pila_fun[tope_fun+1]=indice;
		tope_fun++;
		pila_cont[tope_cont+1]=0;
		tope_cont++;
	}
	else {
		fprintf(stderr,"Error linea %d: No se ha encontrado la funcion con nombre %s.\n",linea_actual,identificador.lexema);
		//exit(1);
		hay_error=1;
	}

}

/**
 * Comprobacion semantica de cada parametro en una llamada a una funcion
 */
void TS_CompruebaParametro(Atributos parametro) {

	//printf("\n\nLinea Actual: %d \nParametro %d\n",linea_actual,pila_cont[tope_cont]);
	//imprimeAtributo(parametro);
	Entrada e = TS[pila_fun[tope_fun]+1+pila_cont[tope_cont]];
	//printf("Entrada de la tabla de simbolos %d\n",pila_fun[tope_fun]+1+pila_cont[tope_cont]);
	//imprimirEntrada(&e);

	if (pila_cont[tope_cont]>=TS[pila_fun[tope_fun]].Parametros) {
		//printf("Contador de parametros: %d\n",pila_cont[tope_cont]);
		fprintf(stderr,"Error linea %d: Se han pasado demasiados parametros a la funcion.\n",linea_actual);
		//exit(1);
		hay_error=1;
	}
	if (e.tipoDato!=parametro.tipo) {
		fprintf(stderr,"Error linea %d: El tipo de parametro %d no coincide.\n",linea_actual,pila_cont[tope_cont]);
		//exit(1);
		hay_error=1;
	}
	Atributos tmp; tmp.numDim=e.NumeroDimensiones; tmp.tamDim1=e.tamanyoDim1; tmp.tamDim2=e.tamanyoDim2;
	if (!mismoTamanyo(tmp,parametro)) {
		fprintf(stderr,"Error linea %d: No concuerda el tamanyo del parametro %d.\n",linea_actual,pila_cont[tope_cont]);
		hay_error=1;
	}
	pila_cont[tope_cont]++;

}

/**
  * Anyade una entrada a la tabla de simbolos 
**/
void anyadir_entrada(TipoEntrada tipoEntrada, char* nombre,  TipoDato tipoDato, int Parametros, int NumeroDimensiones, int tamanyoDim1, int tamanyoDim2) {
    if ((TOPE+1)<MAX_ENTRADAS) {
        TS[TOPE+1].tipoEntrada=tipoEntrada;
        TS[TOPE+1].nombre = nombre;
        TS[TOPE+1].tipoDato = tipoDato;
        TS[TOPE+1].Parametros = Parametros;
        TS[TOPE+1].tamanyoDim1 = tamanyoDim1;
        TS[TOPE+1].tamanyoDim2 = tamanyoDim2;
        TS[TOPE+1].NumeroDimensiones = NumeroDimensiones;
        TOPE++;
    }
    else {
        fprintf(stderr,"Error: Superado limite de la tabla de simbolos");
        //exit(1);
        hay_error=1;
    }
}

/**
  * Quita todas las entradas hasta que encuentre una entrada especial de marca
**/
void quitarBloqueCompleto() {
    while (TS[TOPE].tipoEntrada!=Marca && (TOPE-1)>-1) {
        TOPE--;
    }
    if (TS[TOPE].tipoEntrada==Marca) {
        TOPE--;
    }
}

/**
  * Busca una entrada dado su nombre:
  * Si la encuentra devuelve el indice donde se encuentra la entrada
  * Si no la encuentra devuelve -1
**/
int buscarEntrada (char* nombre, Entrada* entrada) {
    int i=TOPE;
    int encontrado=0;
    int indice=-1;
    while(i>=0 && !encontrado) {
        if(strcmp(TS[i].nombre,nombre)==0) {
            encontrado=1;
            indice=i;
            *entrada = TS[i];
        }
        i--;
    }
    return indice;
}

/**
 * Imprime como una cadena de caracteres una entrada de la tabla de simbolos dada
 */
void imprimirEntrada(Entrada* e) {
    printf("Tipo Entrada: ");
    imprimeTipoEntrada(e->tipoEntrada);
    printf("\n");
    printf("Nombre: %s\n",e->nombre);
    printf("Tipo Dato: ");
    imprimeTipoDato(e->tipoDato);
    printf("\n");
    printf("Parametros: %d\n",e->Parametros);
    printf("Numero de dimensiones: %d\n",e->NumeroDimensiones);
    printf("Tamanyo Dim1: %d\n",e->tamanyoDim1);
    printf("Tamanyo Dim2: %d\n",e->tamanyoDim2);
}

/**
  * Imprime como cadena el tipo de entrada dado
**/
void imprimeTipoEntrada(TipoEntrada tipo) {
    switch(tipo) {
        case Marca:
            printf("Marca");
            break;
        case Funcion:
            printf("Funcion");
            break;
        case Variable:
            printf("Variable");
            break;
        case Parametro_formal:
            printf("Parametro-formal");
            break;
    }
}

/**
  * Imprime como cadena el tipo de dato dado
**/ 
void imprimeTipoDato(TipoDato tipo) {
    switch(tipo) {
        case Logico:
            printf("Logico");
            break;
        case Caracter:
            printf("Caracter");
            break;
        case Real:
            printf("Real");
            break;
        case Entero:
            printf("Entero");
            break;
        case Array:
            printf("Array");
            break;
        case Desconocido:
            printf("Desconocido");
            break;
        case NoAsignado:
        	printf("No Asignado");
        	break;
    }
}

/**
 * Imprime por pantalla la tabla de simbolos a continuacion del mensaje dado
 */
void imprimeTS(char* mensaje) {
	printf("%s\n",mensaje);
	int i;
	for (i = 0; i <= TOPE; i++) {
		Entrada* e = &TS[i];
		printf("Entrada %d\n", i);
		imprimirEntrada(e);
		printf("\n\n");
	}
	printf("Tope de tabla: %ld\n", TOPE);
}

/**
 * Imprime por pantalla la informacion asociada al atributo
 */
void imprimeAtributo(Atributos e) {
	printf("Atrib: %d\n",e.atrib);
	printf("Lexema: %s\n",e.lexema);
	printf("Tipo: "); imprimeTipoDato(e.tipo); printf("\n");
	printf("Num Dim: %d\n",e.numDim);
	printf("TamDim1: %d\n",e.tamDim1);
	printf("TamDim2: %d\n",e.tamDim2);
}
