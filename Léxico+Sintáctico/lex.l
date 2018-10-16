%{
#include <stdio.h>
#include "y_tab.h"
%}

%option yylineno
%option noyywrap

entero      [0-9]*
real        [0-9]*\.[0-9]+
char        \'[^\']+\'
string      \"[^\"]*\"
ident       [a-zA-Z]([a-zA-Z]|[0-9]|_)*
otros       .

%%

"*"             return BINARY_OP;
"/"             return BINARY_OP ;
"=="            return BINARY_OP ;
"!="            return BINARY_OP ;
"<="            return BINARY_OP ;
">="            return BINARY_OP ;
"<"             return BINARY_OP ;
">"             return BINARY_OP ;
"&&"            return BINARY_OP ;
"||"            return BINARY_OP ;
"^"             return BINARY_OP ;
"**"            return BINARY_OP ;
"++"            return UNI_OP ;
"--"            return UNI_OP ;
"!"             return UNI_OP ;
"+"             return SIGNO_BIN_OP ;
"-"             return SIGNO_BIN_OP ;
"="             return ASIGNACION ;
"principal"     return MAIN ;
"si"            return SI ;
"mientras"      return MIENTRAS ;
"var"           return INI_DECLARACION ;
"finvar"        return FIN_DECLARACION ;
"entrada"       return LEER ;
"hacer"         return HACER ;
"hasta"         return HASTA ;
"verdadero"     return BOOLEANOS ;
"falso"         return BOOLEANOS ;
";"             return PUN_COMA ;
","             return SEPARADOR ;
"("             return PAR_IZQ ;
")"             return PAR_DER ;
"salida"        return OUT ;
"devolver"      return DEVOLVER ;
"["             return COR_IZQ ;
"]"             return COR_DER ;
{entero}        return CONST_INT ;
{real}          return CONST_FLOAT ;
{char}          return CONST_CHAR ;
{string}        return CONST_STRING ;
"entero"        return TIPO ;
"booleano"      return TIPO ;
"caracter"      return TIPO ;
"real"          return TIPO ;
"{"             return INICIO_BLOQUE ;
"}"             return FIN_BLOQUE ;
{ident}         return IDENTIFICADOR ;
\n              ;
\t              ;
" "             ;
{otros}         printf("\n(Linea %d) Error léxico: token %s\n", yylineno, yytext);

%%
