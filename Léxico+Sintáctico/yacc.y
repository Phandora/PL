%{
#include <stdio.h>
%}

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

programa : MAIN bloque ;

bloque : INICIO_BLOQUE
         declar_de_variables_locales
         declar_de_subprogs
         sentencias
         FIN_BLOQUE ;
         
declar_de_subprogs : declar_de_subprogs declar_subprog
                   | ;
                     
declar_subprog : cabecera_subprog bloque ;         

declar_de_variables_locales : INI_DECLARACION
                              variables_locales
                              FIN_DECLARACION ;

variables_locales : variables_locales cuerpo_declar_variables
                  | cuerpo_declar_variables ;

cuerpo_declar_variables : TIPO lista_variables PUN_COMA ;

lista_variables : identificador
                 identificador SEPARADOR lista_variables ;
                          
cabecera_subprog : TIPO IDENTIFICADOR PAR_IZQ lista_parametros PAR_DER
                 | TIPO IDENTIFICADOR PAR_IZQ PAR_DER ;
                 
lista_parametros : lista_parametros SEPARADOR TIPO identificador
                 | TIPO identificador ;

sentencias : sentencias sentencia
           | sentencia ;

sentencia : bloque
          | sentencia_asignacion
          | sentencia_si
          | sentencia_mientras
          | sentencia_entrada
          | sentencia_salida
          | sentencia_devolver
          | sentencia_hacer_hasta ;

sentencia_asignacion : identificador ASIGNACION expresion ;
                    
sentencia_si : SI PAR_IZQ expresion PAR_DER sentencia
             | SI PAR_IZQ expresion PAR_DER sentencia SINO sentencia ;
             
sentencia_mientras : MIENTRAS PAR_IZQ expresion PAR_DER sentencia ;

sentencia_entrada : LEER lista_variables PUN_COMA ;

sentencia_salida : OUT lista_exp_cad PUN_COMA ;
                 
lista_exp_cad : lista_expresiones SEPARADOR exp_cad
              | exp_cad ;

exp_cad : expresion
        | CONST_STRING ;
  
sentencia_devolver : DEVOLVER expresion PUN_COMA ;

sentencia_hacer_hasta : HACER sentencia HASTA PAR_IZQ expresion PAR_DER PUN_COMA ;
                  
expresion : PAR_IZQ expresion PAR_DER
          |	UNI_OP expresion
          | SIGNO_BIN_OP expresion %prec UNI_OP
          | expresion OR_OP expresion
          | expresion AND_OP expresion
          | expresion XOR_OP expresion
          | expresion SIGNO_BIN_OP expresion
          | expresion MULTIDIV_OP expresion
          | expresion RELATIONAL_OP expresion
          | expresion EQNEQ_OP expresion
          | identificador
          | constante
          | llamar_funcion ;

array : IDENTIFICADOR COR_IZQ expresion COR_DER 
      | IDENTIFICADOR COR_IZQ expresion SEPARADOR expresion COR_DER ;

lista_expresiones : lista_expresiones SEPARADOR expresion
                  | expresion ;

llamar_funcion : IDENTIFICADOR PAR_IZQ lista_expresiones PAR_DER
               | IDENTIFICADOR PAR_IZQ PAR_DER ;

constante_entera : CONST_INT ;

constante_booleana : BOOLEANOS ;

constante_real : CONST_FLOAT ;

constante_caracter : CONST_CHAR ;

identificador : IDENTIFICADOR
              | array ;

constante : constante_entera
          | constante_booleana
          | constante_caracter
          | constante_real
          | constante_array_entero
          | constante_array_real
          | constante_array_caracter
          | constante_array_booleano ;

signo : SIGNO_BIN_OP
      | ;

constante_array_entero : INICIO_BLOQUE signo constante_entera PAR_IZQ SEPARADOR signo constante_entera PAR_DER FIN_BLOQUE
                       | INICIO_BLOQUE signo constante_entera PAR_IZQ SEPARADOR signo constante_entera PAR_DER  PUN_COMA signo constante_entera PAR_IZQ SEPARADOR signo constante_entera PAR_DER FIN_BLOQUE ;

constante_array_real : INICIO_BLOQUE signo constante_real PAR_IZQ SEPARADOR signo constante_real PAR_DER FIN_BLOQUE
                     | INICIO_BLOQUE signo constante_real PAR_IZQ SEPARADOR signo constante_real PAR_DER  PUN_COMA signo constante_real PAR_IZQ SEPARADOR signo constante_real PAR_DER FIN_BLOQUE ;

constante_array_caracter : INICIO_BLOQUE constante_caracter PAR_IZQ SEPARADOR constante_caracter PAR_DER FIN_BLOQUE
                         | INICIO_BLOQUE constante_caracter PAR_IZQ SEPARADOR constante_caracter PAR_DER  PUN_COMA constante_caracter PAR_IZQ SEPARADOR constante_caracter PAR_DER FIN_BLOQUE ;

constante_array_booleano : INICIO_BLOQUE constante_booleana PAR_IZQ SEPARADOR constante_booleana PAR_DER FIN_BLOQUE
                         | INICIO_BLOQUE constante_booleana PAR_IZQ SEPARADOR constante_booleana PAR_DER  PUN_COMA constante_booleana PAR_IZQ SEPARADOR constante_booleana PAR_DER FIN_BLOQUE ;


%%

#include "lex.yy.c"

void yyerror(char* s) {
    printf("Error: %s", s);
}

int main(){
    yyparse();
}
