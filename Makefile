all :
	bison -y -d syntax.y
	flex lexic.l
	gcc -c y.tab.c lex.yy.c
	gcc y.tab.o lex.yy.o prettyPrinter.c -o prettyPrinter


clean :
	rm y.tab.c *.o y.tab.h lex.yy.c prettyPrinter
