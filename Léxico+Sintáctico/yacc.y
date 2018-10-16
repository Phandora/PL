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


%%

#include "lex.yy.c"

void yyerror(char* s) {
    printf("Error: %s", s);
}

int main(){
    yyparse();
}
