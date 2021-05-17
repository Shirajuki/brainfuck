# Makefile for brainfuck - lex
CC = gcc 
LEX = flex
yacc = bison
CFLAGS = -std=c99 -g

all: bfc

lex.yy.c: bfc.l
	lex bfc.l

bfc: lex.yy.c 
	gcc -g -o $@ $< -I. -ll

clean:
	-@rm lex.yy.c bfc
