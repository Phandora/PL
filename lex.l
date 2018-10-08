/*----- Sección de Declaraciones --------------*/
%{
#include <stdio.h>
int nc, np, nl, llave_abierta, llave_cerrada, comentarios, llamadas_funcion;
void escribir_datos (int dato1, int dato2, int dato3, int dato4, int dato5);
%}

%option yylineno
%option noyywrap

/*----- Seccion de Reglas ----------------*/
%%
([a-zA-Z]|[0-9]|_)+"."([a-zA-Z]|[0-9]|_|" ")*"("([a-zA-Z]|[0-9]|_|"*"|" "|",")*");"      { printf("LLAMADA_FUNCION "); llamadas_funcion++;}
([a-zA-Z]|[0-9]|_|" ")+(" ")*"("([a-zA-Z]|[0-9]|_|"*"|" "|",")*");"      { printf("LLAMADA_FUNCION "); llamadas_funcion++;}
([a-zA-Z]|[0-9]|_|" ")+(" ")*"main"(" ")*"("([a-zA-Z]|[0-9]|_|"*"|" "|",")*")"       { printf("PROGRAMA_PRINCIPAL ");}
([a-zA-Z]|[0-9]|_|" ")+(" ")*"("([a-zA-Z]|[0-9]|_|"*"|" "|",")*")"       { printf("CABECERA_FUNCION ");}
"("([a-zA-Z]|[0-9]|_|"*"|" "|",")*")"                                { printf("PARAMETROS_FUNCION ");}
"("([a-zA-Z]|[0-9]|_|" "|"%")*(" "|","|"."|"<"|">"|"="|"%"|"!")*([a-zA-Z]|[0-9]|_|" "|","|".")*")"                    { printf("COMPARACION ");}
([a-zA-Z]|[0-9]|_)*(" ")*"="(" ")*([a-zA-Z]|[0-9]|_)+(" ")*("+"|"-"|"*"|"/"|"^"|"%")*(" ")*([a-zA-Z]|[0-9]|_)+                    { printf("OPERACION");}
"#include"(" ")*("<"|\")+([a-zA-Z]|[0-9]|_|"*"|" ")*(">"|\")+   {  printf("INCLUYE_LIBRERIA");}


"*" {  printf("BINARY_OP");
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
/*----- Sección de Procedimientos --------*/
int main (int argc, char** argv) {

	if (argc <= 1) {
		exit(1);
	}else {
		yyin = fopen(argv[1], "r");
		int val;
		nl = llave_abierta = llave_cerrada = comentarios = llamadas_funcion = 0;
		val = yylex();
		while (val != 0) {
			printf("%d ", val);
			val = yylex();
		}
		escribir_datos(nl,llave_abierta, llave_cerrada, comentarios, llamadas_funcion);
	}
	exit(1);
}
void escribir_datos (int dato1, int dato2, int dato3, int dato4, int dato5) {
printf("Número de líneas de código=%d\n", dato1);
printf("Número de comentarios en su código=%d\n", dato4);
printf("Número de llamadas a función en su código=%d\n", dato5);
if(dato2!= dato3) printf("Existen bloques sin cerrar, compruebe las llaves de su código\n");
}

