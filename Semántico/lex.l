%{
#include <stdio.h>
#include "y.tab.h"
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

"*"             {yylval.lexema=strdup(yytext); yylval.atrib= 0 ;return MULTIDIV_OP ;} 
"/"             {yylval.lexema=strdup(yytext); yylval.atrib= 1 ;return MULTIDIV_OP ;}
"=="            {yylval.lexema=strdup(yytext); yylval.atrib= 0 ;return EQNEQ_OP ;}
"!="            {yylval.lexema=strdup(yytext); yylval.atrib= 1 ;return EQNEQ_OP ;}
"<="            {yylval.lexema=strdup(yytext); yylval.atrib= 0 ;return RELATIONAL_OP ;}
">="            {yylval.lexema=strdup(yytext); yylval.atrib= 1 ;return RELATIONAL_OP ;}
"<"             {yylval.lexema=strdup(yytext); yylval.atrib= 2 ;return RELATIONAL_OP ;}
">"             {yylval.lexema=strdup(yytext); yylval.atrib= 3 ;return RELATIONAL_OP ;}
"&&"            {yylval.lexema=strdup(yytext); yylval.atrib= 0 ;return OR_OP ;}
"||"            {yylval.lexema=strdup(yytext); yylval.atrib= 0 ;return AND_OP ;}
"^"             {yylval.lexema=strdup(yytext); yylval.atrib= 0 ;return XOR_OP ;}
"**"            {yylval.lexema=strdup(yytext); yylval.atrib= 2 ;return MULTIDIV_OP ;}
"++"            {yylval.lexema=strdup(yytext); yylval.atrib= 0 ;return UNI_OP ;}
"--"            {yylval.lexema=strdup(yytext); yylval.atrib= 1 ;return UNI_OP ;}
"!"             {yylval.lexema=strdup(yytext); yylval.atrib= 2 ;return UNI_OP ;}
"+"             {yylval.lexema=strdup(yytext); yylval.atrib= 0 ;return SIGNO_BIN_OP ;}
"-"             {yylval.lexema=strdup(yytext); yylval.atrib= 1 ;return SIGNO_BIN_OP ;}
"="             return ASIGNACION ;
"principal"     return MAIN ;
"si"            return SI ;
"sino"          return SINO ;
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
"entero"        {yylval.atrib=0; return TIPO ;} 
"booleano"      {yylval.atrib=1; return TIPO ;} 
"caracter"      {yylval.atrib=2; return TIPO ;} 
"real"          {yylval.atrib=3; return TIPO ;} 
"{"             return INICIO_BLOQUE ;
"}"             return FIN_BLOQUE ;
{ident}         {yylval.lexema=strdup(yytext); return IDENTIFICADOR ;}
\n              ;
\t              ;
" "             ;
{otros}         printf("\n(Linea %d) Error léxico: token %s\n", yylineno, yytext);

%%
