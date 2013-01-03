%{

#include "global.h"
#include "arbre.h"

%}

%token  JSON_ARRAY JSON_OBJECT JSON_VALUE
%token  LEFT_BRACKET RIGHT_BRACKET
%token  LEFT_BRACE RIGHT_BRACE
%token  COLON COMA
%token  END

%left COMA
%left COLON

%start Input
%%

Input:
    /* Vide */
  | Input Line
  ;

Line:
    END
  | Expression END    { printf("Resultat : %f\n",$1); }
  ;

Expression:
    JSON_VALUE      { $$=$1; }
  | Expression COMA Expression  { $$=  ; }
  | Expression COLON Expression { $$= ??? ; }
  | LEFT_BRACE Expression RIGHT_BRACE  { $$=$2; }
  | LEFT_BRACKET Expression RIGHT_BRACKET  { $$=$2; }
  ;

%%

int yyerror(char *s) {
  printf("%s\n",s);
}

int main(void) {
  yyparse();
}
