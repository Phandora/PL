/* Falta la prioridad de los operadores */
%{
#include <stdio.h>
%}

%token BINARY_OP
%token UNI_OP
%token SIGNO_BIN_OP
%token ASIGNACION
%token MAIN
%token SI
%token SINO
%token MIENTRAS
%token INI_DECLARACION
%token FIN_DECLARACION
%token LEER
%token HACER
%token HASTA
%token BOOLEANOS
%token PUN_COMA
%token SEPARADOR
%token PAR_IZQ
%token PAR_DER
%token OUT
%token DEVOLVER
%token COR_IZQ
%token COR_DER
%token CONST_INT
%token CONST_FLOAT
%token CONST_CHAR
%token CONST_STRING
%token IDENTIFICADOR
%token TIPO
%token INICIO_BLOQUE
%token FIN_BLOQUE

/* Símbolo inicial de la gramática */
%start programa

%%

programa    : cabecera_programa bloque
            ;

bloque :  inicio_de_bloque
		      declar_de_variables_locales
          declar_de_subprogs
          sentencias
          fin_de_bloque
       ;
         
declar_de_subprogs : declar_de_subprogs declar_subprog
									 |
                   ;
                     
declar_subprog : cabecera_subprog bloque
							 ;         

declar_de_variables_locales : marca_ini_declar_variables
															  variables_locales
                                marca_fin_declar_variables 
                              ;

marca_ini_declar_variables : INI_DECLARACION
													 ;

marca_fin_declar_variables : FIN_DECLARACION
														;
                              
cabecera_programa : MAIN
                  ;

inicio_de_bloque : INICIO_BLOQUE
								 ;

fin_de_bloque : FIN_BLOQUE
							;
                
variables_locales : variables_locales cuerpo_declar_variables
									| cuerpo_declar_variables
                  ;


cuerpo_declar_variables : tipo lista_variables PUN_COMA
												;

lista_variables : identificador
								| identificador SEPARADOR lista_variables
                ;
                          
cabecera_subprog : tipo identificador_var PAR_IZQ lista_parametros PAR_DER
								 | tipo identificador_var PAR_IZQ PAR_DER
                 ;
                 
lista_parametros : lista_parametros SEPARADOR tipo identificador
								 | tipo identificador
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
          ;

sentencia_asignacion : identificador ASIGNACION expresion
									  ;
                    
sentencia_si : SI PAR_IZQ expresion PAR_DER sentencia
						 | SI PAR_IZQ expresion PAR_DER sentencia
             	 SINO sentencia
             ;
             
sentencia_mientras : MIENTRAS PAR_IZQ expresion PAR_DER sentencia
									 ;

sentencia_entrada : LEER  lista_variables PUN_COMA
									;

sentencia_salida : OUT lista_exp_cad PUN_COMA
								 ;
                 
lista_exp_cad : lista_expresiones SEPARADOR exp_cad
							| exp_cad
              ;

exp_cad : expresion
				| cadena
        ;
  
cadena : CONST_STRING
       ;

sentencia_devolver : DEVOLVER expresion PUN_COMA
								   ;


sentencia_hacer_hasta : HACER sentencia HASTA PAR_IZQ expresion PAR_DER PUN_COMA
											;



lista_expresiones : lista_expresiones expresion
								  | expresion
                  ;
                  

expresion : PAR_IZQ expresion PAR_DER
					|	op_unario expresion
          | expresion op_binario expresion
          | identificador
					| constante
          | llamar_funcion
          ;

array : identificador_var COR_IZQ expresion COR_DER 
			| identificador_var COR_IZQ expresion SEPARADOR expresion COR_DER
      ;



lista_expresiones : expresion SEPARADOR lista_expresiones
									| expresion
                  ;

llamar_funcion : identificador PAR_IZQ lista_expresiones PAR_DER fin_sentencia
							 | identificador PAR_IZQ PAR_DER fin_sentencia
               ;

op_unario : UNI_OP
					| signo
          ;

signo : SIGNO_BIN_OP
			;

fin_sentencia : PUN_COMA
							|
              ;

op_binario : BINARY_OP
						;

constante_entera : CONST_INT
									;

constante_booleana : BOOLEANOS
										;

constante_real : CONST_FLOAT
								;

constante_caracter : CONST_CHAR
										;

identificador : identificador_var
							| array
              ;

identificador_var : IDENTIFICADOR 
										;

tipo : TIPO
			;

constante : constante_entera
					| constante_booleana
          | constante_caracter
          | constante_real
          | constante_array_entero
          | constante_array_real
          | constante_array_caracter
          | constante_array_booleano
          ;

sc : signo
		|
    ;

constante_array_entero : INICIO_BLOQUE sc constante_entera PAR_IZQ SEPARADOR sc constante_entera PAR_DER FIN_BLOQUE
													| INICIO_BLOQUE sc constante_entera PAR_IZQ SEPARADOR sc constante_entera PAR_DER BINARY_OP PUN_COMA sc constante_entera PAR_IZQ SEPARADOR sc constante_entera PAR_DER FIN_BLOQUE
                          ;

constante_array_real : INICIO_BLOQUE sc constante_real PAR_IZQ SEPARADOR sc constante_real PAR_DER FIN_BLOQUE
													| INICIO_BLOQUE sc constante_real PAR_IZQ SEPARADOR sc constante_real PAR_DER BINARY_OP PUN_COMA sc constante_real PAR_IZQ SEPARADOR sc constante_real PAR_DER FIN_BLOQUE
                          ;

constante_array_caracter : INICIO_BLOQUE constante_caracter PAR_IZQ SEPARADOR constante_caracter PAR_DER FIN_BLOQUE
													| INICIO_BLOQUE constante_caracter PAR_IZQ SEPARADOR constante_caracter PAR_DER BINARY_OP PUN_COMA constante_caracter PAR_IZQ SEPARADOR constante_caracter PAR_DER FIN_BLOQUE
                          ;

constante_array_booleano : INICIO_BLOQUE constante_booleana PAR_IZQ SEPARADOR constante_booleana PAR_DER FIN_BLOQUE
													| INICIO_BLOQUE constante_booleana PAR_IZQ SEPARADOR constante_booleana PAR_DER BINARY_OP PUN_COMA constante_booleana PAR_IZQ SEPARADOR constante_booleana PAR_DER FIN_BLOQUE
                          ;



%%

#include "lex.yy.c"

void yyerror(char* s) {
    printf("Error: %s", s);
}

int main(){
    yyparse();
}
