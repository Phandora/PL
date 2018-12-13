prueba: y.tab.o tabla_simbolos.o
	gcc -o prueba y.tab.o tabla_simbolos.o 
tabla_simbolos.o: tabla_simbolos.c
	gcc -c -o tabla_simbolos.o tabla_simbolos.c -std=c99
y.tab.o: y.tab.c
	gcc -c y.tab.c
y.tab.c: yacc.y lex.yy.c
	bison -dtv -Wconflicts-sr -Wconflicts-rr  -o y.tab.c yacc.y
lex.yy.c: lex.l
	lex -l lex.l
clean:
	rm -f prueba *.o y.tab.c lex.yy.c y.tab.h y.output
all:
	make clean
	make prueba

