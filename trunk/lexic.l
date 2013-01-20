%{

#include "types.h"
#include "y.tab.h"
#include <stdio.h>

void yyerror(char *);

typedef struct _quoteToken {
	struct _quoteToken* next;
	char c;
} quoteToken;

quoteToken* quoteTokens;
quoteToken* lastQuoteToken;

%}

indent		[ \n\t]+
integer		0|[1-9][0-9]*
power		[eE][+-]?{integer}

number		[-]?{integer}["."[0-9]+]?{power}?
string		\"[^\"\/\b\f\n\r\t\u\\]+\"

%%

[{}:,\[\]] {
	return *yytext;
}

{number} {
	yylval.str = strdup(yytext);
	yylval.str[yyleng] = '\0';
	return JNUM;
}

\"[^"\\]*["\\] { 
	/* when we read a " */
	if(yytext[yyleng-1] == '"') 
	{	
		if (yytext[yyleng-2] == '\\') 
		{		
			unput('"');
			yymore();
		}
		else 
		{
			int i;
			yylval.str = strdup(yytext);
			// we replace the " of each \" by the good char
			// because they are replaced to parse correctly the string
			for(i = 1 ; quoteTokens != NULL ; i++) 
			{
				if(yylval.str[i] == '"') 
				{
					yylval.str[i] = quoteTokens->c;
					lastQuoteToken = quoteTokens;
					quoteTokens = quoteTokens->next;
					free(lastQuoteToken);
				}
			}
					
			yylval.str[yyleng] = '\0';
			return JSTRING;
		}
	} 
	else 
	{
		// we read the next character
		char c = input();
		// if it's a valid one
		if (c == 't' || c == 'n' || c == '"' || 
			c == '/' || c == 'f' || c == 'b' || 
			c == 'r' || c == 'u' || c == '\\') 
		{	
			// we save it
			if(quoteTokens == NULL) 
			{
				quoteTokens = malloc(sizeof(quoteToken));
				quoteTokens->c = c;
				lastQuoteToken = quoteTokens;
			} 
			else 
			{
				quoteToken* next = malloc(sizeof(quoteToken));
				next->c = c;
				next->next = NULL;
				lastQuoteToken->next = next;
				lastQuoteToken = next;
			}		
			// we overight it to parse correctly the string								
			unput('"');
			yymore();
		}
		// otherwise we throw an error, but we still parse the string
		else 
		{
			yyerror("Error : wrong use of \\ in the string");
			unput('"');
		}
	}
}


[ \t\n]+    ;
						
"true"		return JTRUE;
"false"		return JFALSE;
"null"		return JNULL;

.			yyerror("Unknown character");

%%

int yywrap(void) {
    return 1;
}