# Makefile for brainfuck - lex
CC = gcc
YACC = bison
LEX = flex
CFLAGS = -std=c99 -g

all: bfint bfenc

bfint: lex.yy.c 
	gcc -g -o $@ $< -I. -ll
lex.yy.c: bfint.l
	lex bfint.l

bfenc: lex2.yy.c 
	gcc -g -o $@ $< -I. -ll
lex2.yy.c: bfenc.l
	lex bfenc.l && mv lex.yy.c lex2.yy.c

clean:
	-@rm lex.yy.c bfint lex2.yy.c bfenc
