%{
#include <stdio.h>
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

"*"             printf("BINARY_OP ");
"/"             printf("BINARY_OP ");
"=="            printf("BINARY_OP ");
"!="            printf("BINARY_OP ");
"<="            printf("BINARY_OP ");
">="            printf("BINARY_OP ");
"<"             printf("BINARY_OP ");
">"             printf("BINARY_OP ");
"&&"            printf("BINARY_OP ");
"||"            printf("BINARY_OP ");
"^"             printf("BINARY_OP ");
"**"            printf("BINARY_OP ");
"++"            printf("UNI_OP ");
"--"            printf("UNI_OP ");
"!"             printf("UNI_OP ");
"+"             printf("SIGNO_BIN_OP ");
"-"             printf("SIGNO_BIN_OP ");
"="             printf("ASIGNACION ");
"principal"     printf("MAIN ");
"si"            printf("SI ");
"mientras"      printf("MIENTRAS ");
"var"           printf("INI_DECLARACION ");
"finvar"        printf("FIN_DECLARACION ");
"entrada"       printf("LEER ");
"hacer"         printf("HACER ");
"hasta"         printf("HASTA ");
"verdadero"     printf("BOOLEANOS ");
"falso"         printf("BOOLEANOS ");
";"             printf("PUN_COMA ");
","             printf("SEPARADOR ");
"("             printf("PAR_IZQ ");
")"             printf("PAR_DER ");
"salida"        printf("OUT ");
"devolver"      printf("DEVOLVER ");
"["             printf("COR_IZQ ");
"]"             printf("COR_DER ");
{entero}        printf("CONST_INT ");
{real}          printf("CONST_FLOAT ");
{char}          printf("CONST_CHAR ");
{string}        printf("CONST_STRING ");
"entero"        printf("TIPO ");
"booleano"      printf("TIPO ");
"caracter"      printf("TIPO ");
"real"          printf("TIPO ");
"{"             printf("INICIO_BLOQUE ");
"}"             printf("FIN_BLOQUE ");
{ident}         printf("IDENTIFICADOR ");
\n              printf("\n");
\t              printf("\t ");
" "             ;
{otros}         printf("\n(Linea %d) Error léxico: token %s\n", yylineno, yytext);

%%

int main (int argc, char** argv) {
    if (argc != 2) {
        exit(1);
    }
    else {
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