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

programa : MAIN {decSubprog = 1;} bloque {decSubprog = 0;};

bloque : INICIO_BLOQUE {insertarMarca();}
         declar_de_variables_locales
         declar_de_subprogs
         sentencias
         FIN_BLOQUE {eliminarBloque();}
         ;
         
declar_de_subprogs : declar_de_subprogs declar_subprog
                   | ;
                     
declar_subprog : {decSubprog = 1;} cabecera_subprog bloque {decSubprog = 0;};

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
                          
cabecera_subprog : TIPO IDENTIFICADOR PAR_IZQ {insertarFuncion($2.lexema, $2.tipo, 0); decParam=1;} lista_parametros PAR_DER {decParam = 0;}
                 | TIPO IDENTIFICADOR PAR_IZQ PAR_DER {insertarFuncion($2.lexema, $2.tipo, 0);};
                 
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

sentencia_asignacion : identificador ASIGNACION expresion PUN_COMA {
    if($1.dimension != $3.dimension)
        printf("\n(Linea %d) Error semantico : dimensiones incompatibles en la asignación.\n", mylineno); 
    else
        switch($1.dimension){
            case 0: //Variable 
                if($1.tipo != $3.tipo && (($1.tipo==booleano || $1.tipo==caracter || $1.tipo==desconocido) || ($3.tipo==booleano || $3.tipo==caracter || $3.tipo==desconocido)))
                    printf("\n(Linea %d) Error semantico : tipos incompatibles en la asignación.\n", mylineno);	 
                break;
            case 1:
                if($1.tamadim1 != $3.tamadim1)
                    printf("\n(Linea %d) Error semantico : tamaños incompatibles en la asignación.\n", mylineno);	 
                else if($1.tipo != $3.tipo && (($1.tipo==booleano || $1.tipo==caracter || $1.tipo==desconocido) || ($3.tipo==booleano || $3.tipo==caracter || $3.tipo==desconocido)))
                        printf("\n(Linea %d) Error semantico : tipos incompatibles en la asignación.\n", mylineno);
                break;
            case 2:
                if($1.tamadim1 != $3.tamadim1 || $1.tamadim2 != $3.tamadim2)
                    printf("\n(Linea %d) Error semantico : tamaños incompatibles en la asignación.\n", mylineno);	 
                else if($1.tipo != $3.tipo && (($1.tipo==booleano || $1.tipo==caracter || $1.tipo==desconocido) || ($3.tipo==booleano || $3.tipo==caracter || $3.tipo==desconocido)))
                        printf("\n(Linea %d) Error semantico : tipos incompatibles en la asignación.\n", mylineno);
                break;
        }
};	 
                    
sentencia_si : SI PAR_IZQ expresion PAR_DER sentencia {
            if(( $3.dimension !=0 )||$3.tipo != booleano){ 
               printf("\n(Linea %d) Error semantico : expresión invalida en la sentencia condicional.\n", mylineno); 
            }
            };
            | SI PAR_IZQ expresion PAR_DER sentencia SINO sentencia {if(( $3.dimension !=0 )||$3.tipo != booleano){ printf("\n(Linea %d) Error semantico : expresión invalida en la sentencia condicional.\n", mylineno); }};
             
sentencia_mientras : MIENTRAS PAR_IZQ expresion PAR_DER sentencia {if(($3.dimension !=0)||$3.tipo != booleano){ printf("\n(Linea %d) Error semantico : expresión invalida en la sentencia mientras.\n", mylineno); }};

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
  
sentencia_devolver : DEVOLVER expresion PUN_COMA {if((TS[funcion_actual].dimensiones != 0 )||$2.tipo != TS[funcion_actual].tipoDato){ printf("\n(Linea %d) Error semantico : tipo devuelto incompatible con la función\n", mylineno); }};

sentencia_hacer_hasta : HACER sentencia HASTA PAR_IZQ expresion PAR_DER PUN_COMA {if(($5.dimension !=0)||$5.tipo != booleano){ printf("\n(Linea %d) Error semantico : expresión invalida en la sentencia hacer hasta.\n", mylineno); }};
                  
expresion : PAR_IZQ expresion PAR_DER {$$.tipo = $2.tipo; $$.dimension = $2.dimension; $$.tamadim1  = $2.tamadim1; $$.tamadim2  = $2.tamadim2;}
          | UNI_OP expresion {    
                switch($2.atrib){
                    case 0:
                        if(($2.dimension !=0)|| $2.tipo != entero && $2.tipo != real){
                            printf("\n(Linea %d) Error semantico : Tipos no compatibles en expresion Unaria\n", mylineno);
                        }                            
                         else{
                            $$.tipo = $2.tipo; 
                            $$.dimension = $2.dimension;
                            $$.tamadim1  = $2.tamadim1;
                            $$.tamadim2  = $2.tamadim2;  
                        }
                    break;
                    case 1:
                        if(($2.dimension !=0)||$2.tipo != entero && $2.tipo != real){
                            printf("\n(Linea %d) Error semantico : Tipos no compatibles en expresion Unaria\n", mylineno);
                         }
                         else{
                            $$.tipo = $2.tipo; 
                            $$.dimension = $2.dimension;
                            $$.tamadim1  = $2.tamadim1;
                            $$.tamadim2  = $2.tamadim2;  
                        }                         
                    break;
                    case 2:
                        if(($2.dimension !=0)|| $2.tipo != booleano){
                            printf("\n(Linea %d) Error semantico : Tipos no compatibles en expresion Unaria\n", mylineno);
                         }                            
                         else{
                            $$.tipo = $2.tipo; 
                            $$.dimension = $2.dimension;
                            $$.tamadim1  = $2.tamadim1;
                            $$.tamadim2  = $2.tamadim2;  
                        }                         
                    break;
                }
            }  

          | SIGNO_BIN_OP expresion %prec UNI_OP {
                if(($2.dimension !=0)||$2.tipo != entero && $2.tipo != real){
                    printf("\n(Linea %d) Error semantico : Tipos no compatibles en expresion Unaria\n", mylineno);
                 }
                else{
                    $$.tipo = $2.tipo; 
                    $$.dimension = $2.dimension;
                    $$.tamadim1  = $2.tamadim1;
                    $$.tamadim2  = $2.tamadim2;  
                 }
            }
          | expresion OR_OP expresion {
                if(($1.dimension !=0)||($3.dimension !=0)|| $1.tipo != $3.tipo){
                    printf("\n(Linea %d) Error semantico : Tipos no compatibles en expresion OR\n", mylineno);
                }
                else if ($1.tipo != booleano){ 
                    printf("\n(Linea %d) Error semantico : Tipos no compatibles en expresion OR\n", mylineno);
                 }
                else{ 
                    $$.tipo = booleano;
                    $$.dimension = 0;
                    $$.tamadim1 = 0;
                    $$.tamadim2 = 0;  
                }                 
          }
          | expresion AND_OP expresion {
                if(($1.dimension !=0)||($3.dimension !=0)||$1.tipo != $3.tipo){
                    printf("\n(Linea %d) Error semantico : Tipos no compatibles en expresion AND\n", mylineno);
                }
                else{ 
                    if ($1.tipo != booleano){ 
                        printf("\n(Linea %d) Error semantico : Tipos no compatibles en expresion AND\n", mylineno);
                    }
                    else{ 
                        $$.tipo = booleano;
                        $$.dimension = 0;
                        $$.tamadim1 = 0;
                        $$.tamadim2 = 0;  
                    }
                }                
          }
          | expresion XOR_OP expresion 
          {
                if(($1.dimension !=0)||($3.dimension !=0)||$1.tipo != $3.tipo){
                    printf("\n(Linea %d) Error semantico : Tipos no compatibles en expresion XOR\n", mylineno);
                }
                else if ($1.tipo != booleano){
                    printf("\n(Linea %d) Error semantico : Tipos no compatibles en expresion XOR\n", mylineno);
               }                    
                else{ 
                $$.tipo = booleano;
                $$.dimension = 0;
                $$.tamadim1 = 0;
                $$.tamadim2 = 0;  
               }            
          }
          | expresion SIGNO_BIN_OP expresion
          {
            switch($2.atrib){
                case 0:
                    if($1.tipo != $3.tipo && (($1.tipo==booleano || $1.tipo==caracter || $1.tipo==desconocido) || ($3.tipo==booleano || $3.tipo==caracter || $3.tipo==desconocido)) || ($1.tipo == $3.tipo && $1.tipo!=entero && $1.tipo!=real)) {
                        printf("\n(Linea %d) Error semantico : Tipos no compatibles en expresion Binaria (%s)\n", mylineno, $2.lexema);
                    }
                    else if(($1.dimension !=$3.dimension)){
                    
                        if(($1.dimension ==0 )&&($3.dimension !=0)) {
                            $$.tipo = $3.tipo;
                            $$.dimension = $3.dimension;
                            $$.tamadim1  = $3.tamadim1;
                            $$.tamadim2  = $3.tamadim2;
                            
                        }
                        else if(($1.dimension !=0 )&&($3.dimension ==0)) {
                            $$.tipo = $1.tipo;
                            $$.dimension = $1.dimension;
                            $$.tamadim1  = $1.tamadim1;
                            $$.tamadim2  = $1.tamadim2;
                            
                        }
                        else{
                             printf("\n(Linea %d) Error semantico : Dimensiones no compatibles en expresion Binaria (%s) de arrays\n", mylineno, $2.lexema);
                        }
                    }
                    else{
                        if ($1.tamadim1 == $3.tamadim1 && $1.tamadim2 == $3.tamadim2 ){
                                $$.tipo = $1.tipo;
                                $$.dimension = $1.dimension;
                                $$.tamadim1  = $1.tamadim1;
                                $$.tamadim2  = $1.tamadim2;
                        }
                        else{
                          printf("\n(Linea %d) Error semantico : Tamaños no compatibles en expresion Binaria (%s) de arrays\n", mylineno, $2.lexema);
                            
                        }
                    }
                    break;
                case 1:
                    if($1.tipo != $3.tipo && (($1.tipo==booleano || $1.tipo==caracter || $1.tipo==desconocido) || ($3.tipo==booleano || $3.tipo==caracter || $3.tipo==desconocido)) || ($1.tipo == $3.tipo && $1.tipo!=entero && $1.tipo!=real)) {
                         printf("\n(Linea %d) Error semantico : Tipos no compatibles en expresion Binaria (%s)\n", mylineno, $2.lexema);
                    }
                    else if(($1.dimension !=$3.dimension)){
                        if(($1.dimension !=0 )&&($3.dimension ==0)) {
                            $$.tipo = $1.tipo;
                            $$.dimension = $1.dimension;
                            $$.tamadim1  = $1.tamadim1;
                            $$.tamadim2  = $1.tamadim2;
                            
                        }
                        else{
                            printf("\n(Linea %d) Error semantico : Dimensiones no compatibles en expresion Binaria (%s) de arrays\n", mylineno, $2.lexema);
                        }
                    }
                    else{
                        if ($1.tamadim1 == $3.tamadim1 && $1.tamadim2 == $3.tamadim2 ){
                                $$.tipo = $1.tipo;
                                $$.dimension = $1.dimension;
                                $$.tamadim1  = $1.tamadim1;
                                $$.tamadim2  = $1.tamadim2;
                        }
                        else{
                          printf("\n(Linea %d) Error semantico : Tamaños no compatibles en expresion Binaria (%s) de arrays\n", mylineno, $2.lexema);
                        }
                    }
                    break;
                    
            }                
            
          }
          | expresion MULTIDIV_OP expresion
          {
              switch($2.atrib){
                case 0:
                    if($1.tipo != $3.tipo && (($1.tipo==booleano || $1.tipo==caracter || $1.tipo==desconocido) || ($3.tipo==booleano || $3.tipo==caracter || $3.tipo==desconocido)) || ($1.tipo == $3.tipo && $1.tipo!=entero && $1.tipo!=real)) {
                         printf("\n(Linea %d) Error semantico : Tipos no compatibles en expresion Binaria (%s)\n", mylineno, $2.lexema);
                    }
                    else if(($1.dimension !=$3.dimension)){
                    
                        if(($1.dimension ==0 )&&($3.dimension !=0)) {
                            $$.tipo = $3.tipo;
                            $$.dimension = $3.dimension;
                            $$.tamadim1  = $3.tamadim1;
                            $$.tamadim2  = $3.tamadim2;
                            
                        }
                        else if(($1.dimension !=0 )&&($3.dimension ==0)) {
                            $$.tipo = $1.tipo;
                            $$.dimension = $1.dimension;
                            $$.tamadim1  = $1.tamadim1;
                            $$.tamadim2  = $1.tamadim2;
                            
                        }
                        else{
                             printf("\n(Linea %d) Error semantico : Dimensiones no compatibles en expresion Binaria (%s) de arrays\n", mylineno, $2.lexema);
                        }
                    }
                    else{
                        if ($1.tamadim1 == $3.tamadim1 && $1.tamadim2 == $3.tamadim2 ){
                                $$.tipo = $1.tipo;
                                $$.dimension = $1.dimension;
                                $$.tamadim1  = $1.tamadim1;
                                $$.tamadim2  = $1.tamadim2;
                        }
                        else{
                          printf("\n(Linea %d) Error semantico : Tamaños no compatibles en expresion Binaria (%s) de arrays\n", mylineno, $2.lexema);
                        }
                    }
                    break;
                case 1:
                    if(($1.tipo != $3.tipo) && (($1.tipo==booleano || $1.tipo==caracter || $1.tipo==desconocido) || ($3.tipo==booleano || $3.tipo==caracter || $3.tipo==desconocido)) || ($1.tipo == $3.tipo && $1.tipo!=entero && $1.tipo!=real)) {
                         printf("\n(Linea %d) Error semantico : Tipos no compatibles en expresion división de arrays\n", mylineno);
                    }
                    else if(($1.dimension !=$3.dimension)){
                        if(($1.dimension !=0 )&&($3.dimension ==0)) {
                            $$.tipo = $1.tipo;
                            $$.dimension = $1.dimension;
                            $$.tamadim1  = $1.tamadim1;
                            $$.tamadim2  = $1.tamadim2;
                            
                        }
                        else{
                             printf("\n(Linea %d) Error semantico : Dimensiones no compatibles en expresion división de arrays\n", mylineno);
                        }
                    }
                    else{
                         if ($1.tamadim1 == $3.tamadim1 && $1.tamadim2 == $3.tamadim2 ){
                                $$.tipo = $1.tipo;
                                $$.dimension = $1.dimension;
                                $$.tamadim1  = $1.tamadim1;
                                $$.tamadim2  = $1.tamadim2;
                        }
                        else{
                         printf("\n(Linea %d) Error semantico : Tamaños no compatibles en expresion división de arrays\n", mylineno);
                        }
                    }
                    break;
                case 2:
                    if(($1.tipo != $3.tipo) && (($1.tipo==booleano || $1.tipo==caracter || $1.tipo==desconocido) || ($3.tipo==booleano || $3.tipo==caracter || $3.tipo==desconocido)) || ($1.tipo == $3.tipo && $1.tipo!=entero && $1.tipo!=real)) {
                         printf("\n(Linea %d) Error semantico : Tipos no compatibles en expresion multiplicacion matrices de arrays\n", mylineno);
                    }
                    else if(($1.dimension !=$3.dimension)){
                         printf("\n(Linea %d) Error semantico : Dimension no compatible en expresion multiplicacion de matrices\n", mylineno);
                    }
                    else{
                         if ($1.tamadim2 == $3.tamadim1){ //a[1][2]**b[2][3]
                                $$.tipo = $1.tipo;
                                $$.dimension = $1.dimension;
                                $$.tamadim1  = $1.tamadim1; // en el pdf esta al contrario 3
                                $$.tamadim2  = $3.tamadim2; //1
                        }
                        else{
                            printf("\n(Linea %d) Error semantico : Tamaños no compatibles en expresion multiplicacion de matrices\n", mylineno);

                        }                    
                    }
                    break; 

            }                           
          }
          | expresion RELATIONAL_OP expresion
          {if(($1.dimension !=0)||($3.dimension !=0)||$1.tipo != $3.tipo && (($1.tipo==booleano || $1.tipo==caracter || $1.tipo==desconocido) || ($3.tipo==booleano || $3.tipo==caracter || $3.tipo==desconocido)) || ($1.tipo == $3.tipo && $1.tipo!=entero && $1.tipo!=real)) {
                printf("\n(Linea %d) Error semantico : Tipos no compatibles en expresion Condicional numerica\n", mylineno);
             }
            else{ 
                $$.tipo = booleano;
                $$.dimension = 0;
                $$.tamadim1 = 0;
                $$.tamadim2 = 0;  
            }
          }
          | expresion EQNEQ_OP expresion {
              if(($1.dimension !=0)||($3.dimension !=0)|| $1.tipo != $3.tipo ){
                    printf("\n(Linea %d) Error semantico : Tipos no compatibles en expresion Condicional booleana\n", mylineno);

                }
                else{
                    $$.tipo = booleano;            
                    $$.dimension = 0;
                    $$.tamadim1 = 0;
                    $$.tamadim2 = 0;       
                } 
          }
          | identificador {$$.tipo = $1.tipo; 
                           $$.dimension = $1.dimension;
                           $$.tamadim1 = $1.tamadim1;
                           $$.tamadim2 = $1.tamadim2;}
          | constante {$$.tipo = $1.tipo;
                            $$.dimension = $1.dimension;
                            $$.tamadim1  = $1.tamadim1;
                            $$.tamadim2  = $1.tamadim2;}
          | llamar_funcion {$$.tipo = $1.tipo;
                            $$.dimension = $1.dimension;
                            $$.tamadim1  = $1.tamadim1;
                            $$.tamadim2  = $1.tamadim2;}
          ;

array : IDENTIFICADOR COR_IZQ expresion COR_DER {
    if(decVar){
        if($3.tipo == entero)
            if(atoi($3.lexema) > 0)
                insertarArray($1.lexema, tipo_global, 1, atoi($3.lexema), 0);
            else
                printf("\n(Linea %d) Error semantico : El tamaño de un array debe ser positivo\n", mylineno);
        else
            printf("\n(Linea %d) Error semantico : El tamaño de un array debe ser un entero sin signo\n", mylineno);
    }else{
        if($3.tipo == entero){
            if(atoi($3.lexema) > 0){
                entradaTS *id = buscarSimbolo($1.lexema,0);
                if(id == NULL){
                    printf("\n(Linea %d) Error semantico : Array no declarado\n", mylineno);
                }               
                else{
                    if(id->dimensiones == 2)
                        printf("\n(Linea %d) Error semantico : Falta un índice\n", mylineno);
                    else{
                         // $$.lexema = (*id).nombre;  De momento no sabemos el valor de la pos de memoria
                        $$.tipo = (*id).tipoDato;
                        $$.dimension = 0;
                        $$.tamadim1 = 0;
                        $$.tamadim2 = 0;
                    }
                } 
            } else
                printf("\n(Linea %d) Error semantico : El tamaño de un array debe ser positivo\n", mylineno);
        }
        else
            printf("\n(Linea %d) Error semantico : El tamaño de un array debe ser un entero sin signo\n", mylineno);
    } 
}
      | IDENTIFICADOR COR_IZQ expresion SEPARADOR expresion COR_DER {
    if(decVar){
        if($3.tipo == entero && $5.tipo == entero)
            if(atoi($3.lexema) > 0 && atoi($5.lexema) > 0)
                insertarArray($1.lexema, tipo_global, 2, atoi($3.lexema), atoi($5.lexema));
            else
                printf("\n(Linea %d) Error semantico : Los tamaños de una matriz deben ser positivos\n", mylineno);
        else
            printf("\n(Linea %d) Error semantico : Los tamaños de una matriz deben ser un entero sin signo\n", mylineno);
    
    }else{
        if($3.tipo == entero && $5.tipo == entero){
            if(atoi($3.lexema) > 0 && atoi($5.lexema) > 0){
                entradaTS *id = buscarSimbolo($1.lexema,0);
                if(id == NULL){
                    printf("\n(Linea %d) Error semantico : Indentificador no declarado\n", mylineno);
                }               
                else{
                    if ((*id).dimensiones ==1){
                        printf("\n(Linea %d) Error semantico : Sobra un índice\n", mylineno);
                    }
                    else{                                        
                        // $$.lexema = (*id).nombre; De momento no sabemos el valor de la pos de memoria
                        $$.tipo = (*id).tipoDato;
                        $$.dimension = 0;
                        $$.tamadim1 = 0;
                        $$.tamadim2 = 0;
                    }
                } 
            }else
                printf("\n(Linea %d) Error semantico : Los tamaños de una matriz deben ser positivos\n", mylineno);
        }
        else
            printf("\n(Linea %d) Error semantico : Los tamaños de una matriz deben ser un entero sin signo\n", mylineno);
    }
};

lista_expresiones : lista_expresiones SEPARADOR expresion 
                  {nParam++;
                   if (expArray==1){
                      if (valorCteArray != $3.tipo)
                         printf("\n(Linea %d) Error semantico : %s Parámetro de tipo incorrecto en array\n", mylineno, $3.lexema); 
                  }
                  else {
                        if(TS[pos_fun+nParam].tipoDato!=$3.tipo){
                            printf("\n(Linea %d) Error semantico : %s Parámetro de tipo incorrecto\n", mylineno, $3.lexema);                 
                        }
                  }
                  }
                  | expresion 
                  {nParam=1 ; 
                  if (expArray==1){
                      valorCteArray = $1.tipo;
                  }
                  else {
                    if(TS[pos_fun+nParam].tipoDato!=$1.tipo){
                            printf("\n(Linea %d) Error semantico : %s Parámetro de tipo incorrecto\n", mylineno, $1.lexema);                 
                        }
                  }                    
                  };

llamar_funcion : IDENTIFICADOR PAR_IZQ {entradaTS *id = buscarSimbolo($1.lexema,0);
                    if(id == NULL){
                        printf("\n(Linea %d) Error semantico : Función no declarada\n", mylineno);                 
                    }
                    else{ pos_fun= buscarPos($1.lexema);}
				} 
				lista_expresiones PAR_DER
                {entradaTS *id = buscarSimbolo($1.lexema,0);
                    if(id == NULL){
                        printf("\n(Linea %d) Error semantico : Función no declarada\n", mylineno);                 
                        }
                    else{
                        if((*id).parametros!=nParam){
                            printf("\n(Linea %d) Error semantico : Número de parámetros erróneos\n", mylineno);                 
                            }
                        else
                            $$.tipo=(*id).tipoDato;
							
                    }    
                }
               | IDENTIFICADOR PAR_IZQ PAR_DER 
                 {entradaTS *id = buscarSimbolo($1.lexema,0);
                    if(id == NULL){
                        printf("\n(Linea %d) Error semantico : Función no declarada\n", mylineno);                 
                    } 
                    else{
                        $$.tipo=(*id).tipoDato;
                    }    
                };

constante_entera : CONST_INT {$$.tipo=entero;};

constante_booleana : BOOLEANOS {$$.tipo=booleano;};

constante_real : CONST_FLOAT {$$.tipo=real;};

constante_caracter : CONST_CHAR {$$.tipo=caracter;};

identificador : IDENTIFICADOR {
        if (decVar)
            insertarVariable(variable, $1.lexema, tipo_global);
        else if(decParam)
            insertarVariable(parametro_formal, $1.lexema, tipo_global);
        else{
            entradaTS *id = buscarSimbolo($1.lexema,0);
            if(id == NULL){
                printf("\n(Linea %d) Error semantico : Identificador no declarado\n", mylineno);                  
            }               
            else{
                $$.lexema = (*id).nombre;
                $$.tipo = (*id).tipoDato;
                $$.dimension = (*id).dimensiones;
                $$.tamadim1 = (*id).TamDimen1;
                $$.tamadim2 = (*id).TamDimen2;
            }    
        }
    }
    | array { $$.lexema = $1.lexema;
            $$.tipo = $1.tipo;
            $$.dimension = $1.dimension;
            $$.tamadim1 = $1.tamadim1;
            $$.tamadim2 = $1.tamadim2;
            };

constante : constante_entera {$$.tipo=entero;  $$.dimension=0; $$.tamadim1 = 0; $$.tamadim2 = 0; }
          | constante_booleana {$$.tipo=$1.tipo; $$.dimension=0; $$.tamadim1 = 0; $$.tamadim2 = 0;}
          | constante_caracter {$$.tipo=caracter; $$.dimension=0; $$.tamadim1 = 0; $$.tamadim2 = 0;}
          | constante_real {$$.tipo=real; $$.dimension=0; $$.tamadim1 = 0; $$.tamadim2 = 0;}
          | {expArray = 1;} constante_array {
              $$.tipo = $2.tipo; 
              $$.dimension = $2.dimension; 
              $$.tamadim1 = $2.tamadim1; 
              $$.tamadim2 = $2.tamadim2; 
              $$.tipo = $2.tipo;};

constante_array : INICIO_BLOQUE lista_expresiones FIN_BLOQUE {expArray = 0; $$.dimension=1; $$.tamadim1=nParam; $$.tamadim2 = 0; $$.tipo = valorCteArray;}
                | INICIO_BLOQUE lista_expresiones PUN_COMA {aux = nParam;} lista_expresiones FIN_BLOQUE {expArray = 0; $$.dimension=2; $$.tamadim1 = aux ;$$.tamadim2 = nParam; $$.tipo = valorCteArray;};

%%

#include "lex.yy.c"
#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;
 
int yyparse(void);
//int yywrap();

void yyerror(char* s) {
    printf("\n(Linea %d): %s", yylineno, s);
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
