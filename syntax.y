%{
	#define YYDEBUG 0
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "types.h"
 
	Node* toPair(char* name, Node* value);
	Node* addNextNode(Node* current, Node* next);
	Node* toValue(char* val, int nodeType);
	Node* toObject(Node* pairs_set);
	Node* toArray(Node* values_set);
	int start(Node* json);
    int yylex(void);
    void yyerror(char *);
    
    extern char * yytext;
    extern FILE* yyin;
    int sym[26];                    /* symbol table */
%}

%union {           
    Node *nPtr;  
    char *str;        
};

%token <str> JNUM
%token <str> JSTRING
%token JTRUE
%token JFALSE
%token JNULL

%type <nPtr> object array value pair values_set pairs_set

%start json

%%

json:
        object 					{ start($1); }
		| array					{ start($1); }
        ;

object:
        '{' pairs_set '}'		{ $$ = toObject($2); }
        | '{''}'				{ $$ = toObject(NULL); }	
        ;
        
array:
		'[' values_set ']'		{ $$ = toArray($2); }
		| '[' ']'				{ $$ = toArray(NULL); }
		;
		
values_set:
		value					{ $$ = $1; }
		| value ',' values_set	{ $$ = addNextNode($1, $3); }
		;
		
pairs_set:
		pair					{ $$ = $1; }
		| pair ',' pairs_set	{ $$ = addNextNode($1, $3); }
		;

pair:							
		JSTRING ':' value		{ $$ = toPair($1, $3); }
		;

value: 	
		object					{ $$ = $1; }
		| array					{ $$ = $1; }
		| JSTRING				{ $$ = toValue($1, string); }
		| JNUM					{ $$ = toValue($1, number); }
		| JTRUE					{ $$ = toValue("true", true); }
		| JFALSE				{ $$ = toValue("false", false); }
		| JNULL					{ $$ = toValue("null", null); }
		;


%%

Node* toPair(char* name, Node* value) {
	Node *pairNode;

    /* allocate Node */
    if ((pairNode = (Node*)malloc(sizeof(Node))) == NULL)
        yyerror("out of memory");

    /* copy information */
    pairNode->string = (char*) malloc(strlen(name)+1);
    strcpy(pairNode->string, name);	
    pairNode->children = value;
    pairNode->nodeType = jpair;
    
    return pairNode;
}

Node* addNextNode(Node* current, Node* next) {
	current->next = next;
	
	return current;
}

Node* toValue(char* val, int valType) {
	Node *valueNode;

    /* allocate Node */
    if ((valueNode = malloc(sizeof(Node))) == NULL)
        yyerror("out of memory");

    /* copy information */
    valueNode->nodeType = jterm; // terminal type
    valueNode->string = malloc(strlen(val)+1);
    strcpy(valueNode->string, val);
	//valueNode->valType = valType;
    
    return valueNode;
}

Node* toObject(Node* pairs_set) {
	Node *objectNode;

    /* allocate Node */
    if ((objectNode = malloc(sizeof(Node))) == NULL)
        printf("out of memory\n");

    /* copy information */
    objectNode->nodeType = jobject;
    objectNode->children = pairs_set;
    
    return objectNode;
}

Node* toArray(Node* values_set) {
	Node *arrayNode;

    /* allocate Node */
    if ((arrayNode = malloc(sizeof(Node))) == NULL)
        yyerror("out of memory");

    /* copy information */
    arrayNode->nodeType = jarray;
    arrayNode->children = values_set;
    
    return arrayNode;
}
	

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}


int main( int argc, char **argv ) {
	
	++argv, --argc;
	if ( argc > 0 )
		yyin = fopen( argv[0], "r" );
	else
		yyin = stdin;
		
	#if YYDEBUG
        yydebug = 1;
    #endif
    yyparse();
	
    return 0;
}
