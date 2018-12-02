%{
/**
  * Practicas.y
  * Especificacion YACC del lenguaje
**/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "msj.err"
#include "tablaSimbolos.h"

/**
  * La siguiente declaracion permite que 'yyerror' se pueda invocar desde el fuente de lex (practicas.l)
**/
void yyerror (char* msg);
%}

/**
  * Para uso de mensajes de error sintáctico con BISON.
  * La siguiente declaración provoca que ’bison’, ante un error sintáctico,
  * visualice mensajes de error con indicación de los tokens que se esperaban
  * en el lugar en el que produjo el error (SÓLO FUNCIONA CON BISON=2.1).
  * Para Bison2.1 es mediante

  * #define YYERROR_VERBOSE
  * En caso de usar mensajes de error mediante ’mes’ y ’mes2’ (ver apéndice D)
  * nada de lo anterior debe tenerse en cuenta.
**/
%error-verbose

/**
  * A continuacion declaramos los nombres simbolicos de los tokens
  * byacc se encarga de asociar a cada uno un codigo
**/

%left OPOR
%left OPAND
%left OPIGUAL
%left OPREL
%left SUMRES
%left OPMULDIV
%left OPPOT
%left OPNOT
%left CORIZQ CORDER

%token PARIZQ PARDER
/*%token CORIZQ CORDER*/
%token COMA PYC
%token INIVARIABLES FINVARIABLES
%token PROGRAMAPRIN
%token ENTRADA SALIDA
%token CONDSI CONDSINO CONDREPITE CONDCICLO CONDHASTA
%token TIPOBASICO
%token ASIGNACION
%token LLAVEIZQ LLAVEDER
%token SENTRETORNO
%token CONSTANTE_CADENA CONSTANTE_ENTERA CONSTANTE
%token IDENTIFICADOR

%%

/***********************  PRODUCCIONES  **************************/

Programa	: PROGRAMAPRIN	bloque	;

bloque : LLAVEIZQ { TS_InsertaMARCA(); /*imprimeTS("Bloque insertada");*/ } Declar_de_variables_locales	Declar_de_subprogs  Sentencias LLAVEDER { quitarBloqueCompleto(); /*imprimeTS("Quitado Bloque");*/ }	;

/*** Declaracion de variables ******/
Declar_de_variables_locales :	INIVARIABLES Variables_locales FINVARIABLES 
							| ;	          	           

Variables_locales : Variables_locales Cuerpo_declar_variables 
		            | Cuerpo_declar_variables ;
		            
Cuerpo_declar_variables : TIPOBASICO {ajustaTipo($1);} lista_identificadores_o_matrices PYC  
                        | error ;

lista_identificadores_o_matrices : lista_identificadores_o_matrices COMA identificador_o_matriz
				                   | identificador_o_matriz
				                   | error ;

identificador_o_matriz : IDENTIFICADOR dimension_matriz { TS_InsertaIDENT($1,$2.numDim, $2.tamDim1, $2.tamDim2); /*imprimeTS("Insertado Identificador Array");*/ }
			             | IDENTIFICADOR { TS_InsertaIDENT($1,0,0,0); /*imprimeTS("Insertado Identificador");*/}
			             ;

dimension_matriz : CORIZQ CONSTANTE_ENTERA COMA CONSTANTE_ENTERA CORDER { $$.numDim=2; $$.tamDim1=atoi($4.lexema); $$.tamDim2=atoi($2.lexema); }
		           | CORIZQ CONSTANTE_ENTERA CORDER  { $$.numDim=1; $$.tamDim1=atoi($2.lexema); }
		           | error ;
		       
/**** Definicion de subprogramas *****/

Declar_de_subprogs	:	Declar_de_subprogs Declar_subprog
 					| ;

Declar_subprog	:	Cabecera_subprograma { subProg=1; } bloque {subProg=0; } ;

Cabecera_subprograma	:	tipo_retorno IDENTIFICADOR { TS_InsertaSUBPROG($2,$1); /*imprimeTS("Insertado Subprograma");*/ } PARIZQ lista_parametros_2 PARDER 
                        ;
	
tipo_retorno : TIPOBASICO dimension_matriz { ajustaTipo($1);  $$.numDim=$2.numDim; $$.tamDim1=$2.tamDim1; $$.tamDim2=$2.tamDim2; $$.tipo=global_tipo; /*printf("Atributo retorno array:\n"); imprimeAtributo($$);*/}
	           | TIPOBASICO { ajustaTipo($1);  $$.numDim=0; $$.tamDim1=0; $$.tamDim2=0; $$.tipo=global_tipo; /*printf("Atributo retorno:\n"); imprimeAtributo($$);*/};
	           
lista_parametros_2 : lista_parametros
                    | ;
	              
lista_parametros : lista_parametros COMA parametro
		           | parametro 
		           | error ;
         
parametro : TIPOBASICO IDENTIFICADOR dimension_matriz { ajustaTipo($1); $$.numDim=$3.numDim; $$.tamDim1=$3.tamDim1; $$.tamDim2=$3.tamDim2; $$.lexema=strdup($2.lexema); TS_InsertaPARAMF($$); /*imprimeTS("Insertado parametro formal");*/ }
	        | TIPOBASICO IDENTIFICADOR { ajustaTipo($1); $$.numDim=0; $$.tamDim1=0; $$.tamDim2=0; $$.lexema=strdup($2.lexema); TS_InsertaPARAMF($$); /*imprimeTS("Insertado parametro formal")*/;} 
	        ;
	        
	        
/****  Sentencias  ******/	            
Sentencias : Sentencias Sentencia 
	       | ;
	       
	         
Sentencia : bloque
	        | sentencia_asignacion PYC
     	    | sentencia_if 
	        | sentencia_while 
	        | sentencia_entrada PYC
	        | sentencia_salida PYC
	        | sentencia_return PYC
	        | sentencia_until PYC
	        | error ;
	               

sentencia_asignacion : posicion_memoria ASIGNACION expresion {if($1.tipo!=$3.tipo) {
                                                                fprintf(stderr,"Error linea %d: Los tipos de la parte izquierda y derecha no coinciden.\n",linea_actual);
                                                                //exit(1);
                                                               }
                                                              if(!mismoTamanyo($1,$3)) {
                                                              	fprintf(stderr,"Error linea %d: La parte izquierda y la parte derecha deben tener el mismo tamanyo.\n",linea_actual);
                                                              	//exit(1);
                                                              }
                                                              }
                     | error ;

sentencia_if : CONDSI PARIZQ expresion PARDER Sentencia CONDSINO Sentencia {if($3.tipo!=Logico){ 
                                                                    			fprintf(stderr,"Error linea %d: La expresion no es de tipo logico.\n",linea_actual);
                                                                    			//exit(1);
                                                                			}                                                                
                                                               			   }
	           | CONDSI PARIZQ expresion PARDER Sentencia {if($3.tipo!=Logico){ 
                                                           	fprintf(stderr,"Error linea %d: La expresion no es de tipo logico.\n",linea_actual);
                                                            //exit(1);
                                                           }                                                                
                                                          }
	           ;
	           
sentencia_until : CONDREPITE Sentencia CONDHASTA PARIZQ expresion PARDER {if($5.tipo!=Logico){ 
                                                                    		fprintf(stderr,"Error linea %d: La expresion no es de tipo logico.\n",linea_actual);
                                                                    		//exit(1);
                                                                		  }                                                                
                                                               			 }
                ;

sentencia_while : CONDCICLO PARIZQ expresion PARDER Sentencia  {if($3.tipo!=Logico){ 
                                                                    fprintf(stderr,"Error linea %d: La expresion no es de tipo logico.\n",linea_actual);
                                                                    //exit(1);
                                                                }                                                                
                                                               }
				;

sentencia_entrada : ENTRADA lista_posiciones_memoria ;

sentencia_salida : SALIDA lista_salida ;

sentencia_return : SENTRETORNO expresion {TS_CompruebaSENTRETORNO($2,&$$);} ;

lista_salida : lista_salida COMA expresion_salida 
	           | expresion_salida ;
	           
expresion_salida : expresion
		           | CONSTANTE_CADENA ;
		            
lista_posiciones_memoria : lista_posiciones_memoria COMA posicion_memoria	
			               | posicion_memoria 
			               ;
			               
indice_matriz  : CORIZQ expresion COMA expresion CORDER { if ($2.tipo!=Entero || $4.tipo!=Entero) {
                                                          	fprintf(stderr,"Error linea %d: Los tipos de la expresiones deben ser Entero.",linea_actual);
                                                          	//exit(1);
                                                          }
                                                          $$.numDim=2;
                                                        }
		         | CORIZQ expresion CORDER { if($2.tipo!=Entero) {
		                                        fprintf(stderr,"Error linea %d: El tipo de la expresion deben ser Entero.",linea_actual);
                                                //exit(1);
                                              }
                                              $$.numDim=1;
                                           }
		         ;
		         
posicion_memoria : IDENTIFICADOR indice_matriz {TS_GetIDENT($1,&$$); /*printf("Posicion de memoria encontrada:\n"); imprimeAtributo($$);*/
												if($$.numDim!=$2.numDim) {
													fprintf(stderr,"Error linea %d: Numero de dimensiones pasadas no coincide con el numero de dimensiones de las que dispone el array.\n",linea_actual);
													//exit(1);
												}
												$$.numDim=0; $$.tamDim1=0; $$.tamDim2=0;
											   }
		           | IDENTIFICADOR {TS_GetIDENT($1,&$$); /*printf("Posicion de memoria encontrada:\n"); imprimeAtributo($$);*/ };
		           
/********  Expresiones  *********/		           
		           
expresion : PARIZQ expresion PARDER  { $$.tipo = $2.tipo; $$.numDim=$2.numDim; $$.tamDim1=$2.tamDim1; $$.tamDim2=$2.tamDim2; }
	    	| OPNOT expresion {TS_OPNOT($1,$2,&$$); }
		    | SUMRES expresion %prec OPNOT {TS_OPSUMARESunario($1,$2,&$$);}
		    | expresion OPMULDIV expresion {TS_OPMULDIV($1,$2,$3,&$$);}
		    | expresion OPOR expresion {TS_OPOR($1,$2,$3,&$$);}
		    | expresion OPPOT expresion {TS_OPPOT($1,$2,$3,&$$);}
		    | expresion OPREL expresion {TS_OPREL($1,$2,$3,&$$);}
		    | expresion OPIGUAL expresion {TS_OPIGUAL($1,$2,$3,&$$);}
		    | expresion OPAND expresion {TS_OPAND($1,$2,$3,&$$);}
		    | expresion SUMRES expresion {TS_OPSUMRES($1,$2,$3,&$$);}
		    | IDENTIFICADOR {TS_GetIDENT($1,&$$); /*printf("Identificador encontrado:\n"); imprimeAtributo($$);*/ }
		    | constante {$$.tipo = $1.tipo; $$.numDim=$1.numDim; $$.tamDim1=$1.tamDim1; $$.tamDim2=$1.tamDim2; /*printf("Constante encontrada:\n"); imprimeAtributo($$);*/}
		    | acceso_a_matriz {$$.tipo=$1.tipo; $$.numDim=$1.numDim; } 
		    | llamadas_subprog {$$.tipo = $1.tipo; $$.numDim=$1.numDim; $$.tamDim1=$1.tamDim1; $$.tamDim2=$1.tamDim2; /*printf("Llamada a funcion encontrada:\n"); imprimeAtributo($$);*/} 
		    | error ;
		    
constante : CONSTANTE_ENTERA { $$.tipo=Entero;$$.numDim=0; $$.tamDim1=0; $$.tamDim2=0; }
	    	| CONSTANTE      { switch($1.atrib) { 
	    						case 0: $$.tipo=Real; break;
	    						case 1: $$.tipo=Logico; break;
	    						case 2: $$.tipo=Caracter; break;
	    					   }
	    						$$.numDim=0; $$.tamDim1=0; $$.tamDim2=0;
	    					 }
	    	| constantematriz {$$.tipo=$1.tipo; $$.numDim=$1.numDim; $$.tamDim1=$1.tamDim1; $$.tamDim2=$1.tamDim2; /*printf("Constante matriz encontrada:\n"); imprimeAtributo($$);*/}
	    	;
	    	
constantematriz : LLAVEIZQ lista_expresiones_matriz fila_matriz LLAVEDER {if($2.tamDim1!=$3.tamDim1) {
																			fprintf(stderr,"Error linea %d: La constante matriz esta definida incorrectamente.",linea_actual);
																			//exit(1);
												  				   		  }
												  				   		  if($2.tipo!=$3.tipo) {
												  				    		fprintf(stderr,"Error linea %d: Los tipos de la constante matriz no son coincidentes.",linea_actual);
												  				    		//exit(1);
												  				   		  }
												  				   		  $$.numDim=2; $$.tamDim2=$3.tamDim2+1; $$.tamDim1=$3.tamDim1; 
												  				   		  $$.tipo=$2.tipo;
												 				  		}
		          | LLAVEIZQ lista_expresiones_matriz LLAVEDER {$$.numDim=1; $$.tamDim1=$2.tamDim1; $$.tipo = $2.tipo;}
		          ;
		          
fila_matriz : fila_matriz PYC lista_expresiones_matriz {if($1.tamDim1!=$3.tamDim1) {
															fprintf(stderr,"Error linea %d: La constante matriz esta definida incorrectamente.",linea_actual);
															//exit(1);
												  		}
												  		if ($1.tipo!=$3.tipo) {
												    		fprintf(stderr,"Error linea %d: Los tipos de las expresiones de la constante matriz no coinciden.",linea_actual);
												    		//exit(1);
												  		}
												  		$$.tamDim2=$1.tamDim2+1; $$.tamDim1=$3.tamDim1; $$.tipo=$1.tipo;
												 		}
	          | PYC lista_expresiones_matriz  {$$.tamDim2=1; $$.tamDim1=$2.tamDim1; $$.tipo=$2.tipo;}
	          ;
	          
lista_expresiones_matriz : lista_expresiones_matriz COMA expresion { if($1.tipo!=$3.tipo) {
                                                                        fprintf(stderr,"Error linea %d: Los tipos en las expresiones de la constante matriz no coinciden.",linea_actual);
                                                                        //exit(1);
                                                                     }
                                                                     $$.tamDim1=$1.tamDim1+1; $$.tipo=$1.tipo;
                                                                   }
						 | expresion { $$.tamDim1=1; $$.tipo=$1.tipo; }
						 ;	          
	          
acceso_a_matriz : expresion indice_matriz { /*printf("expresion\n"); imprimeAtributo($1);*/
											/*printf("expresion\n"); imprimeAtributo($2);*/
											if ($1.numDim!=$2.numDim) {
												fprintf(stderr,"Error linea %d: No coincide el tamanyo de la expresion con los indices pasados.\n",linea_actual);
												//exit(1);
											}
											$$.tipo=$1.tipo; $$.numDim=0; $$.tamDim1=0; $$.tamDim2=0; }
				;

llamadas_subprog : IDENTIFICADOR {TS_LlamadaFuncion($1,&$$);} PARIZQ lista_expresiones PARDER { /*printf("Llamada a funcion: \n"); imprimirEntrada(&TS[funcionActual]);*/ if(TS[pila_fun[tope_fun]].Parametros!=$4.tamDim1) {
																											 fprintf(stderr,"Error linea %d: No se han pasado el numero de parametros correctos a la funcion.\n",linea_actual);
		           																							//exit(1);
		           															    						  }
		           															    			    $$.tipo=TS[pila_fun[tope_fun]].tipoDato;
		           															    			    $$.numDim=TS[pila_fun[tope_fun]].NumeroDimensiones;
		           															    			    $$.tamDim1=TS[pila_fun[tope_fun]].tamanyoDim1;
		           															    			    $$.tamDim2=TS[pila_fun[tope_fun]].tamanyoDim2;
		           															    			    /*printf("Llamada a la funcion RES\n"); imprimeAtributo($$);*/
		           															    			    tope_fun--;
		           															    			    tope_cont--;	           															    						  
		           															    			  }		           															    						
		           ;
lista_expresiones : lista_expresiones COMA expresion {$$.tamDim1=$1.tamDim1+1; TS_CompruebaParametro($3);}
		            | expresion {$$.tamDim1=1; TS_CompruebaParametro($1);}
		            |			{$$.tamDim1=0;}
		            ;	        

%%

/**
  * Aqui incluimos el fichero generado por el 'lex'
  * que implementa la funcion 'yylex'
**/
#ifdef DOSWINDOWS
#include "lexyy.c"
#else
#include "lex.yy.c"
#endif



/**
  * se debe implementar la funcion yyerror. En este caso
  * simplemente escribimos el mensaje de error en pantalla
**/
void yyerror (char* msg) {
	fprintf(stderr,"[Linea %d]: %s\n", linea_actual, msg);
}




