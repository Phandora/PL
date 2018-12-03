%{
#include <stdlib.h>
#include <string.h>
#include "tablaSimbolos.h"

#define MAXLONBUFFER 50
char buffer[MAXLONBUFFER];

%}
%option yylineno
%option noyywrap

digito	[0-9]
letra	[a-zA-Z]
simbolos ["_"]

constante_entera	({digito})+
constante_logica	("Verdadero"|"Falso")
constante_real 	({digito})+("."({digito})*)?
constante_caracter	\'(\\.|[^\\'])\'
constante_cadena 	\"(\\.|[^\\"])*\"

blanco		[ \t\b]+

%%

"!"		    {yylval.lexema=strdup(yytext); yylval.atrib=0; return OPNOT;} 
"+"  		{yylval.lexema=strdup(yytext); yylval.atrib=0; return SUMRES;}
"-"  		{yylval.lexema=strdup(yytext); yylval.atrib=1; return SUMRES;}
"*"		    {yylval.lexema=strdup(yytext); yylval.atrib=0; return OPMULDIV;}
"/"         {yylval.lexema=strdup(yytext); yylval.atrib=1; return OPMULDIV;}
"**"		{yylval.lexema=strdup(yytext); yylval.atrib=0; return OPPOT;}
"<"		    {yylval.lexema=strdup(yytext); yylval.atrib=0; return OPREL;}
">"		    {yylval.lexema=strdup(yytext); yylval.atrib=1; return OPREL;}
">="		{yylval.lexema=strdup(yytext); yylval.atrib=2; return OPREL;}
"<="		{yylval.lexema=strdup(yytext); yylval.atrib=3; return OPREL;}
"=="		{yylval.lexema=strdup(yytext); yylval.atrib=0; return OPIGUAL;}
"!="		{yylval.lexema=strdup(yytext); yylval.atrib=1; return OPIGUAL;}
"&&"		{yylval.lexema=strdup(yytext); yylval.atrib=0; return OPAND;}
"||"		{yylval.lexema=strdup(yytext); yylval.atrib=0; return OPOR;}
"XOR"		{yylval.lexema=strdup(yytext); yylval.atrib=1; return OPOR;}
"("		    { return PARIZQ;}
")"		    { return PARDER;}
"["		    { return CORIZQ;}
"]"		    { return CORDER;}
","		    { return COMA;}
";"		    {return PYC;}
"Mientras"		{ return CONDCICLO;}
"Variables"		{ return INIVARIABLES;}
"Fin_Variables"	{return FINVARIABLES;}
"Principal"	    { return PROGRAMAPRIN;}
"Leer"		    { return ENTRADA;}
"Escribe"		{ return SALIDA;}
"Si"		    { return CONDSI;}
"sino"		    { return CONDSINO;}
"Repite"		{ return CONDREPITE;}
"Hasta"		    { return CONDHASTA;}
"Entero"		{yylval.atrib=0; return TIPOBASICO;}
"Real"		    {yylval.atrib=1; return TIPOBASICO;}
"Logico"	   	{yylval.atrib=2; return TIPOBASICO;}
"Caracter"	    {yylval.atrib=3; return TIPOBASICO;}
"="		        { return ASIGNACION;}
"{"		        { return LLAVEIZQ;}
"}"		        { return LLAVEDER;}
"Retorno"		{ return SENTRETORNO;}

{constante_cadena} 		{ return CONSTANTE_CADENA;}
{constante_entera}		{yylval.lexema=strdup(yytext); return CONSTANTE_ENTERA;}
{constante_real}		{yylval.lexema=strdup(yytext); yylval.atrib=0; return CONSTANTE;}
{constante_logica}		{yylval.atrib=1; return CONSTANTE;}
{constante_caracter}	{yylval.atrib=2; return CONSTANTE;}

{letra}({letra}|{digito}|{simbolos})*		{yylval.lexema=strdup(yytext); return IDENTIFICADOR;}	

\n			{++linea_actual;}
{blanco}	{ ; }
.			{ sprintf(buffer, "el(los) caracter(es) '%s' no forma(n) ningun token conocido",yytext); yyerror(buffer); }

%%

/*main() {
	int val;
	val = yylex();
	while(val != 0) {
		printf(" %d\n",val);
		val = yylex();
	}
	exit(1);
}*/

