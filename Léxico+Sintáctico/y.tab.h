/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    BINARY_OP = 258,
    UNI_OP = 259,
    SIGNO_BIN_OP = 260,
    ASIGNACION = 261,
    MAIN = 262,
    SI = 263,
    SINO = 264,
    MIENTRAS = 265,
    INI_DECLARACION = 266,
    FIN_DECLARACION = 267,
    LEER = 268,
    HACER = 269,
    HASTA = 270,
    BOOLEANOS = 271,
    PUN_COMA = 272,
    SEPARADOR = 273,
    PAR_IZQ = 274,
    PAR_DER = 275,
    OUT = 276,
    DEVOLVER = 277,
    COR_IZQ = 278,
    COR_DER = 279,
    CONST_INT = 280,
    CONST_FLOAT = 281,
    CONST_CHAR = 282,
    CONST_STRING = 283,
    IDENTIFICADOR = 284,
    TIPO = 285,
    INICIO_BLOQUE = 286,
    FIN_BLOQUE = 287
  };
#endif
/* Tokens.  */
#define BINARY_OP 258
#define UNI_OP 259
#define SIGNO_BIN_OP 260
#define ASIGNACION 261
#define MAIN 262
#define SI 263
#define SINO 264
#define MIENTRAS 265
#define INI_DECLARACION 266
#define FIN_DECLARACION 267
#define LEER 268
#define HACER 269
#define HASTA 270
#define BOOLEANOS 271
#define PUN_COMA 272
#define SEPARADOR 273
#define PAR_IZQ 274
#define PAR_DER 275
#define OUT 276
#define DEVOLVER 277
#define COR_IZQ 278
#define COR_DER 279
#define CONST_INT 280
#define CONST_FLOAT 281
#define CONST_CHAR 282
#define CONST_STRING 283
#define IDENTIFICADOR 284
#define TIPO 285
#define INICIO_BLOQUE 286
#define FIN_BLOQUE 287

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
