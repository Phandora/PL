/*----- Seccion de Declaraciones --------------*/
%{
#include <stdio.h>
int yylval;
%}

%option yylineno
%option noyywrap

/*----- Seccion de Reglas ----------------*/
%%

"*" {  printf("BINARY_OP");}
"/" {  printf("BINARY_OP");}
"==" {  printf("BINARY_OP");}
"!=" {  printf("BINARY_OP");}
"<=" {  printf("BINARY_OP");}
">=" {  printf("BINARY_OP");}
"<"  {  printf("BINARY_OP");}
"&&" {  printf("BINARY_OP");}
"||" {  printf("BINARY_OP");}
"^"  {  printf("BINARY_OP");}
"**" {  printf("BINARY_OP");}
"++" {  printf("UNI_OP");}
"--" {  printf("UNI_OP");}
"!" {  printf("UNI_OP");}
"+" {  printf("SIGNO_BIN_OP");}
"-" {  printf("SIGNO_BIN_OP");}
"principal"     {  printf("MAIN ");}
"si"     {  printf("SI ");}
"mientras"     {  printf("MIENTRAS ");}
"var"      {  printf("INI_DECLARACION ");}
"finvar"       {  printf("FIN_DECLARACION ");}
"entrada"        {  printf("LEER ");}
"hacer"      {  printf("HACER ");}
"hasta"  {  printf("HASTA ");}
"verdadero"         {  printf("BOOLEANOS");}
"falso"         {  printf("BOOLEANOS");}      
";"    {  printf("PUN_COMA ");}
","    {  printf("SEPARADOR ");}
"("    {  printf("PAR_IZQ ");}
")"    {  printf("PAR_DER ");}
"salida"    {  printf("OUT ");}
"devolver"    {  printf("DEVOLVER ");}
"["    {  printf("COR_IZQ ");}
"]"    {  printf("COR_DER ");}
[0-9]*                   { printf("CONST_INT ");}
[0-9]*\.[0-9]+           { printf("CONST_FLOAT ");}
"'"[^"'"]"'"             { printf("CONST_CHAR ");}
\"[^\"]*\"               { printf("CONST_STRING ");}
"entero"       {  printf("TIPO ");}
"booleano"     {  printf("TIPO ");}
"caracter"      {  printf("TIPO ");}
"real"      {  printf("TIPO ");}
"{"    {  printf("INICIO_BLOQUE ");}
"}"    {  printf("FIN_BLOQUE ");}
.                           { printf("(Line ) %d No reconocido'%s'",yylineno,yytext); }

%%
/*----- Seccion de Procedimientos --------*/
int main (int argc, char** argv) {

	if (argc <= 1) {
		exit(1);
	}else {
		yyin = fopen(argv[1], "r");
		int val;
		val = yylex();
		while (val != 0) {
			printf("%d ", val);
			val = yylex();
      }
	}
	exit(1);
}
