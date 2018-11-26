prueba: y.tab.o
	gcc -o prueba y.tab.o
y.tab.o: y.tab.c
	gcc -c y.tab.c
y.tab.c: yacc.y lex.yy.c
	bison -dtv -Wconflicts-sr -Wconflicts-rr  -o y.tab.c yacc.y
lex.yy.c: lex.l
	lex -l lex.l
clean:
	rm -f prueba y.tab.o y.tab.c lex.yy.c y.tab.h
all:
	make clean
	make prueba
