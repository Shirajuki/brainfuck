%{
#include <stdio.h>
// PARSER ENUM
typedef enum {
	END_OF_FUCK, 
	INCREMENT_POINTER,
	DECREMENT_POINTER,
	INCREMENT_BYTE,
	DECREMENT_BYTE,
	OUTPUT_BYTE,
	INPUT_BYTE,
	JUMP_FORWARD,
	JUMP_BACKWARD,
} node_index_t;

// Pointer array
char array[30000] = {0};
char *ptr = &array[0];

// Node struct
typedef struct n {
	node_index_t type;
	uint64_t n_children;
	struct n **children;
} node_t;
void node_init(node_t *n, node_index_t type, uint64_t n_children, ...);
void node_parse(node_t *node);

node_t *root;
node_t *loop;
node_t *instruction;

int nchild = 0;
int njumpchild = 0;
int i = 0;
%}

/* definitions */
WHITESPACE   [\t\n\r\v\ ]+
%%
">"                    { return INCREMENT_POINTER; }
"<"                    { return DECREMENT_POINTER; }
"+"                    { return INCREMENT_BYTE; }
"-"                    { return DECREMENT_BYTE; }
"."                    { return OUTPUT_BYTE; }
","                    { return INPUT_BYTE; }
"["                    { return JUMP_FORWARD; }
"]"                    { return JUMP_BACKWARD; }
<<EOF>>                { return END_OF_FUCK; }
{WHITESPACE}           { /* IGNORED */ }
.                      { /* IGNORED */ }
%%
/* Take the memory allocated to a node and fill it in with the given elements */
void node_init (node_t *nd, node_index_t type, uint64_t n_children, ...)
{
	nd->type = type; // type
	nd->n_children = n_children; // number of children
	nd->children = (node_t **) malloc(n_children * sizeof( node_t * )); // Fill in children
}

void node_parse(node_t *node)
{
	switch (node->type)
	{
		case INCREMENT_POINTER:
			++ptr;
		break;
		case DECREMENT_POINTER:
			--ptr;
		break;
		case INCREMENT_BYTE:
			++*ptr;
		break;
		case DECREMENT_BYTE:
			--*ptr;
		break;
		case OUTPUT_BYTE:
			printf("%c", *ptr);
		break;
		case INPUT_BYTE:
			scanf("%c", ptr);
		break;
		case JUMP_FORWARD:
			if (!*ptr)
				i += node->n_children;
		break;
		case JUMP_BACKWARD:
			if (*ptr)
				//printf("p%d\n",i);
				i -= node->n_children;
				//printf("p%d\n",i);
		break;
	}
}
int main(void) {
	root = (node_t *) malloc(sizeof(node_t));
	node_init(root, END_OF_FUCK, 100000); // Cap at about 100000 instructions
	
	int fklexing = 1;
	node_index_t token;
	while (fklexing)
	{
		token = yylex();
		switch (token)
		{
			case END_OF_FUCK:
				fklexing = 0; // End loop
				root->n_children = nchild; // Update children count
			break;
			case INCREMENT_POINTER: case DECREMENT_POINTER: case INCREMENT_BYTE:
			case DECREMENT_BYTE: case OUTPUT_BYTE: case INPUT_BYTE:
			case JUMP_FORWARD:
				njumpchild++;
				if (token == JUMP_FORWARD) njumpchild = 0;
				instruction = (node_t *) malloc(sizeof(node_t));
				node_init(instruction, token, 0);
				root->children[nchild++] = instruction;
			break;
			case JUMP_BACKWARD:
				njumpchild+=2;
				instruction = (node_t *) malloc(sizeof(node_t));
				node_init(instruction, token, njumpchild);
				root->children[nchild++] = instruction;
				// Update jump forward
				root->children[nchild-njumpchild-1]->n_children = njumpchild;
				njumpchild = 0;
			break;
		}
	}

	// Parse
	while (i < root->n_children)
	{
		node_parse(root->children[i]);
		i++;
	}
  return 0;
}
