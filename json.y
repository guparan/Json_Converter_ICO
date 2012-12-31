%{

#include "global.h"

%}

%token  TABLEAU_JSON OBJET_JSON
%token  CROCHET_GAUCHE CROCHET_DROITE
%token  ACCOLADE_GAUCHE ACCOLADE_DROITE
%token  DOUBLE_POINT VIRGULE
%token  FIN

%start Input
%%

Input:
    /* Vide */
  | Input Ligne
  ;

Ligne:
    FIN
  | Expression FIN    { printf("Resultat : %f\n",$1); }
  ;

Expression:
    TABLEAU_JSON      { $$=$1; }
    
// Suite à faire...

  | Expression PLUS Expression  { $$=$1+$3; }
  | Expression MOINS Expression { $$=$1-$3; }
  | Expression FOIS Expression  { $$=$1*$3; }
  | Expression DIVISE Expression  { $$=$1/$3; }
  | MOINS Expression %prec NEG  { $$=-$2; }
  | Expression PUISSANCE Expression { $$=pow($1,$3); }
  | PARENTHESE_GAUCHE Expression PARENTHESE_DROITE  { $$=$2; }
  ;

%%

int yyerror(char *s) {
  printf("%s\n",s);
}

int main(void) {
  yyparse();
}
