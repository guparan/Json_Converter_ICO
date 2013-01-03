%{

#include "global.h"
int total = 0;

%}

indent		[ \n\t]*
integer		0|[1-9][0-9]*
power		[eE][+-]?{integer}

number		[-]?{integer}["."[0-9]+]?{power}?
string		\"[^\"\/\b\f\n\r\t\u\\]+\"

jpair		{string}{indent}":"{indent}{jvalue}
jobject		\{{indent}{jpair}[{indent},{indent}{jpair}]*{indent}\}
jarray		\[{indent}{jobject}({indent}","{indent}{jobject})*{indent}\]
jvalue		"null"|"true"|"false"|{string}|{number}|{jobject}|{jarray}

%%

{jarray} {
	total++;
	yylval = yytext;
	return(JSON_ARRAY);
}
    
{jobject} {
	yylval = yytext;
	return(JSON_OBJECT);
}
    
{jvalue} {
	yylval = yytext;
	return(JSON_VALUE);
}

\[   return(LEFT_BRACKET);
\]   return(RIGHT_BRACKET);

\{   return(LEFT_BRACE);
\}   return(RIGHT_BRACE);

:   return(COLON);
,   return(COMA);

<<EOF>>  return(END);

%%

int main( void ) {
	yylex();
	printf("\nNombre de jarray du fichier : %d\n\n", total);
}