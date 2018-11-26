practicas:	main.o y.tab.o tablaSimbolos.o
	gcc -o practicas main.o y.tab.o tablaSimbolos.o

y.tab.o: y.tab.c
	gcc -c y.tab.c -o y.tab.o
	
main.o:	main.c
	gcc -c main.c
	
tablaSimbolos.o: tablaSimbolos.c
	gcc -c -o tablaSimbolos.o tablaSimbolos.c

y.tab.c: practicas_v2.y lex.yy.c
	bison -dtv -o y.tab.c practicas_v2.y
	
lex.yy.c: practicas_v3.l
	flex -l practicas_v3.l

limpia:
	rm -f practicas *.o y.tab.c lex.yy.c
	
todo:
	make limpia
	make practicas
