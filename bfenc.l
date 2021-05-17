%{
#include <stdio.h>
#include <stdlib.h>
// Declaration here
enum {
	END_OF_FUCK = 256,
};

void handle_pointer(int token, int cell);
void handle_byte(int token);

char array[30000] = {0};
char *ptr = &array[0];
int ptr_loc = 0;
int ptr_mov = 0;
%}

/* definitions */
WHITESPACE   [\t\n\r\v\ ]+
%%
.                      { return yytext[0]; }
<<EOF>>                { return END_OF_FUCK; }
%%
// Inc/Dec pointer
void handle_pointer(int token, int cell)
{
	ptr_mov = cell - ptr_loc;
	for (int i = 0; i < abs(ptr_mov); ++i)
		if (ptr_mov < 0)
		{
			printf("<");
			--ptr;
		}
		else
		{
			printf(">");
			++ptr;
		}
}
// Inc/Dec byte
void handle_byte(int token)
{
	ptr_mov = token - *ptr;
	for (int i = 0; i < abs(ptr_mov); ++i)
		if (ptr_mov < 0)
		{
			printf("-");
			--*ptr;
		}
		else
		{
			printf("+");
			++*ptr;
		}
	printf(".");
}
/*
	> increment the data pointer (to point to the next cell to the right).
	< decrement the data pointer (to point to the next cell to the left).
	+ increment (increase by one) the byte at the data pointer.
	- decrement (decrease by one) the byte at the data pointer.
	. output the byte at the data pointer.
	, accept one byte of input, storing its value in the byte at the data pointer.
	[ if the byte at the data pointer is zero, then instead of moving the instruction pointer forward to the next command, jump it forward to the command after the matching ] command.
	] if the byte at the data pointer is nonzero, then instead of moving the instruction pointer forward to the next command, jump it back to the command after the matching [ command.
*/
int main(void) {
	int token;
	// Initializes cell to  [0, 10, 30, 70, 100]
		// whitespace [9-13]
		// special characters + digits [32 - 64]
		// Uppercase letters [65 - 96]
		// Lowercase letters [97 - 126]
	*++ptr = 10;
	*++ptr = 30;
	*++ptr = 70;
	*++ptr = 100;
	ptr -= 4;
	// printf("%d %d %d %d\n", *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4));
	char *init_enc_loop = "++++++++++[>+>+++>+++++++>++++++++++<<<<-]";
	printf("%s", init_enc_loop);
	while (1)
	{
		token = yylex();
		if (token <= 15)
		{
			handle_pointer(token, 1);
			ptr_loc = 1;
		}
		else if (token <= 60)
		{
			handle_pointer(token, 2);
			ptr_loc = 2;
		}
		else if (token <= 90)
		{
			handle_pointer(token, 3);
			ptr_loc = 3;
		}
		else if (token <= 255)
		{
			handle_pointer(token, 4);
			ptr_loc = 4;
		}
		else if (token == END_OF_FUCK) break;
		handle_byte(token);
	}
	return 0;
}
