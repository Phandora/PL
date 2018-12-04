%{
#include <stdio.h>
#include "tabla_simbolos.h"
%}

%error-verbose

%token MAIN
%token INICIO_BLOQUE
%token FIN_BLOQUE
%token PUN_COMA
%token SEPARADOR
%token PAR_IZQ
%token PAR_DER
%token INI_DECLARACION
%token FIN_DECLARACION
%token ASIGNACION
%token COR_IZQ
%token COR_DER
%token SI
%token SINO
%token HACER
%token HASTA
%token MIENTRAS
%token DEVOLVER
%token TIPO
%token LEER
%token OUT
%token BOOLEANOS
%token CONST_INT
%token CONST_FLOAT
%token CONST_CHAR
%token CONST_STRING
%token IDENTIFICADOR

/* Operadores */
%left OR_OP
%left AND_OP
%left XOR_OP
%left EQNEQ_OP
%left RELATIONAL_OP
%left SIGNO_BIN_OP
%left MULTIDIV_OP
%right UNI_OP

/* Símbolo inicial de la gramática */
%start programa

%%

programa : MAIN bloque  ;

bloque : INICIO_BLOQUE {insertarMarca();}
         declar_de_variables_locales
         declar_de_subprogs
         sentencias
         FIN_BLOQUE {eliminarBloque();}
         ;
         
declar_de_subprogs : declar_de_subprogs declar_subprog
                   | ;
                     
declar_subprog : cabecera_subprog bloque ;

declar_de_variables_locales : INI_DECLARACION {decVar = 1;}
                              variables_locales
                              FIN_DECLARACION {decVar = 0;}
							  |;

variables_locales : variables_locales cuerpo_declar_variables
                  | cuerpo_declar_variables 
                  | error ;

cuerpo_declar_variables : TIPO {tipo_global=$1.tipo;} lista_variables PUN_COMA ;

lista_variables : identificador
                | identificador SEPARADOR lista_variables ;
                          
cabecera_subprog : TIPO IDENTIFICADOR {insertarFuncion($2.lexema, $2.tipo, 0); decParam=1;} PAR_IZQ lista_parametros PAR_DER {decParam = 0;}
                 | TIPO IDENTIFICADOR {insertarFuncion($2.lexema, $2.tipo, 0);} PAR_IZQ PAR_DER ;
                 
lista_parametros : lista_parametros SEPARADOR TIPO {updateParam(); tipo_global = $3.tipo;} identificador
                 | TIPO {updateParam(); tipo_global = $1.tipo;} identificador
                 | error
                 ;

sentencias : sentencias sentencia
           | sentencia 
           ;

sentencia : bloque
          | sentencia_asignacion
          | sentencia_si
          | sentencia_mientras
          | sentencia_entrada
          | sentencia_salida
          | sentencia_devolver
          | sentencia_hacer_hasta 
          |error;

sentencia_asignacion : identificador ASIGNACION expresion PUN_COMA {if($1.tipo != $3.tipo) printf("ERROR en la sentencia de asignacion tipo1%d  tipo2%d\n",$1.tipo,$2.tipo);};	 
                    
sentencia_si : SI PAR_IZQ expresion PAR_DER sentencia {if($3.tipo != booleano) printf("ERROR en la sentencia si \n");}
             | SI PAR_IZQ expresion PAR_DER sentencia SINO sentencia {if($3.tipo != booleano) printf("ERROR en la sentencia si-sino \n");};
             
sentencia_mientras : MIENTRAS PAR_IZQ expresion PAR_DER sentencia {if($3.tipo != booleano) printf("ERROR en la sentencia mientras \n");};

sentencia_entrada : LEER lista_var_cad PUN_COMA ;

lista_var_cad : lista_var_cad SEPARADOR identificador
              | CONST_STRING
              | identificador
              ;


sentencia_salida : OUT lista_exp_cad PUN_COMA ;
                 
lista_exp_cad : lista_exp_cad SEPARADOR exp_cad
              | exp_cad 
              ;

exp_cad : expresion
        | CONST_STRING ;
  
sentencia_devolver : DEVOLVER expresion PUN_COMA {if($2.tipo != TS[funcion_actual].tipoDato) printf("ERROR en la sentencia devolver \n");};

sentencia_hacer_hasta : HACER sentencia HASTA PAR_IZQ expresion PAR_DER PUN_COMA {if($5.tipo != booleano) printf("ERROR en la sentencia hacer-hasta \n");};
                  
expresion : PAR_IZQ expresion PAR_DER {$$.tipo = $2.tipo;}
          | UNI_OP expresion {    
                switch($1.atrib){
                    case 0:
                        if($2.tipo != entero && $2.tipo != real) 
                            printf("Error. Tipos no compatibles en expresion Unaria\n");
                        else
                            $$.tipo = $2.tipo;
                    break;
                    case 1:
                        if($2.tipo != entero && $2.tipo != real) 
                            printf("Error. Tipos no compatibles en expresion Unaria\n");
                        else
                            $$.tipo = $2.tipo;                          
                    break;
                    case 2:
                        if($2.tipo != booleano)  
                            printf("Error. Tipos no compatibles en expresion Unaria\n");
                        else
                            $$.tipo = $2.tipo;                          
                    break;
                }
            }  

          | SIGNO_BIN_OP expresion %prec UNI_OP {
                if($2.tipo != entero && $2.tipo != real)
                    printf("Error. Tipos no compatibles en expresion Binaria+Unaria\n");
                else
                    $$.tipo = $2.tipo;                  
            }
          | expresion OR_OP expresion {
                if($1.tipo != $3.tipo){
                    printf("Error. Tipos no compatibles en expresion Or\n");
                }
                else if ($1.tipo != booleano) 
                    printf("ERROR. Tipos no compatibles en expresion Or\n");
                else{
                    $$.tipo = booleano;                   
                }              
          }
          | expresion AND_OP expresion {
                if($1.tipo != $3.tipo){
                    printf("Error. Tipos no compatibles en expresion And\n");
                }
                else if ($1.tipo != booleano) 
                    printf("ERROR. Tipos no compatibles en expresion And\n");
                else{
                    $$.tipo = booleano;                   
                }              
          }
          | expresion XOR_OP expresion 
          {
                if($1.tipo != $3.tipo){
                    printf("Error. Tipos no compatibles en expresion Xor\n");
                }
                else if ($1.tipo != booleano) 
                    printf("ERROR. Tipos no compatibles en expresion Xor\n");
                else{
                    $$.tipo = booleano;                   
                }              
          }
          | expresion SIGNO_BIN_OP expresion
          {if(($1.tipo != $3.tipo) || ($1.tipo == $3.tipo && $1.tipo!=entero && $1.tipo!=real)) 
                printf("Error. Tipos no compatibles en expresion Binaria\n");
            else
                $$.tipo = $1.tipo;
          }
          | expresion MULTIDIV_OP expresion
          {if(($1.tipo != $3.tipo && ($1.tipo==booleano || $1.tipo==caracter || $1.tipo==desconocido) && ($3.tipo==booleano || $3.tipo==caracter || $3.tipo==desconocido)) || ($1.tipo == $3.tipo && $1.tipo!=entero && $1.tipo!=real)) 
                printf("Error. Tipos no compatibles en expresion mutiplicacion y div\n");
            else
                $$.tipo = $1.tipo;
          }
          | expresion RELATIONAL_OP expresion
          {if(($1.tipo != $3.tipo) || ($1.tipo == $3.tipo && $1.tipo!=entero && $1.tipo!=real)) 
                printf("Error. Tipos no compatibles en expresion Condicional_numerica\n");
            else
                $$.tipo = booleano;
          }
          | expresion EQNEQ_OP expresion {
              if($1.tipo != $3.tipo){
                    printf("Error. Tipos no compatibles en expresion Condicional_booleana\n");
                }
                else if ($1.tipo != booleano) 
                    printf("ERROR  Tipos no compatibles en expresion Condicional_booleana\n");
                else{
                    $$.tipo = booleano;                   
                } 
          }
          | identificador {$$.tipo = $1.tipo;}
          | constante {$$.tipo = $1.tipo;}
          | llamar_funcion {$$.tipo = $1.tipo;}
          ;

array : IDENTIFICADOR COR_IZQ expresion COR_DER
      | IDENTIFICADOR COR_IZQ expresion SEPARADOR expresion COR_DER ;

lista_expresiones : lista_expresiones SEPARADOR expresion 
                  {nParam++;
                    if(TS[pos_fun+nParam].tipoDato!=$3.tipo)
                        printf("Error. Parametro de tipo incorrecto \n");                   
                  }
                  | expresion 
                  {nParam=1 ; 
                  if(TS[pos_fun+nParam].tipoDato!=$1.tipo)
                        printf("Error. Parametro de tipo incorrecto  \n");                    
                  };

llamar_funcion : IDENTIFICADOR PAR_IZQ {entradaTS *id = buscarSimbolo($1.lexema);
                    if(id == NULL)
                        printf("funcion no declarada\n");
                    else{ pos_fun= buscarPos($1.lexema);}
				} 
				lista_expresiones PAR_DER
                {entradaTS *id = buscarSimbolo($1.lexema);
                    if(id == NULL)
                        printf("funcion no declarada\n");
                    else{
                        if((*id).parametros!=nParam)
                            printf("numero de parametros erroneos\n");
                        else
                            $$.tipo=(*id).tipoDato;
							
                    }    
                }
               | IDENTIFICADOR PAR_IZQ PAR_DER 
                 {entradaTS *id = buscarSimbolo($1.lexema);
                    if(id == NULL)
                        printf("funcion no declarada\n");
                    else{
                        $$.tipo=(*id).tipoDato;
                    }    
                };

constante_entera : CONST_INT ;

constante_booleana : BOOLEANOS {$$.tipo=booleano;};

constante_real : CONST_FLOAT ;

constante_caracter : CONST_CHAR ;

identificador : IDENTIFICADOR {
        if (decVar)
            insertarVariable(variable, $1.lexema, tipo_global);
        else if(decParam)
            insertarVariable(parametro_formal, $1.lexema, tipo_global);
        else{
            entradaTS *id = buscarSimbolo($1.lexema);
            if(id == NULL)
                printf("identificador no declarado\n");
            else{
                $$.lexema = (*id).nombre;
                $$.tipo = (*id).tipoDato;
				
            }    
        }
    }
              | array ;

constante : constante_entera {$$.tipo=entero;}
          | constante_booleana {$$.tipo=$1.tipo;}
          | constante_caracter {$$.tipo=caracter;}
          | constante_real {$$.tipo=real;}
          | constante_array ;

constante_array : INICIO_BLOQUE lista_expresiones FIN_BLOQUE
                | INICIO_BLOQUE lista_expresiones PUN_COMA lista_expresiones FIN_BLOQUE ;

%%

#include "lex.yy.c"
#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;
 
int yyparse(void);
//int yywrap();

void yyerror(char* s) {
    printf("Error: %s, linea:%d\n", s, yylineno);
}

FILE *abrir_entrada(int argc, char **argv){

	FILE *f=NULL;

	if(argc > 1){

		
		f=fopen(argv[1],"r");

		if(f==NULL){
		
			fprintf(stderr, "Error fichero no encontrado");
			exit(1);

		}else{

			printf("Leyendo fichero\n");

		}

	}else{

		printf("Leyendo entrada estándar\n");

	}
	return f;
	

}

int main(int argc, char **argv){

    yyin= abrir_entrada(argc,argv);
    /*int an = yylex();

    while (an != 0){

	printf("-%d-",an);
	an = yylex();
    
	}*/

    //printf("\n");

    return yyparse();
}
