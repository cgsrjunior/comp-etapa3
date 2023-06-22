#
# UFRGS - Compiladores - Etapa 1
# Cleiber Rodrigues e Cintia Valente
# Cartões 00270139 - 00228540
#
# Makefile for single compiler call

etapa2: compile_font
	gcc -o etapa2 lex.yy.o parser.tab.o tree.o main.o -lfl
compile_font: parser.tab.c lex.yy.c
	gcc -c parser.tab.c lex.yy.c tree.h tree.c main.c	
parser.tab.c: parser.y
	bison -d parser.y
lex.yy.c: scanner.l
	flex scanner.l


clean:
	rm *.o lex.yy.c parser.tab.c *.h etapa2