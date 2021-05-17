# Makefile for brainfuck - lex
CC = gcc
YACC = bison
LEX = flex
CFLAGS = -std=c99 -g

all: bfint

bfint: lex.yy.c 
	gcc -g -o $@ $< -I. -ll

lex.yy.c: bfint.l
	lex bfint.l

clean:
	-@rm lex.yy.c bfint
