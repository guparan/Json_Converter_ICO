%{

#include "global.h"

%}

%token  TABLEAU_JSON OBJET_JSON VALEUR_JSON
%token  CROCHET_GAUCHE CROCHET_DROITE
%token  ACCOLADE_GAUCHE ACCOLADE_DROITE
%token  DOUBLE_POINT VIRGULE
%token  FIN

%left VIRGULE
%left DOUBLE_POINT

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
    VALEUR_JSON      { $$=$1; }
  | Expression VIRGULE Expression  { $$= ??? ; }
  | Expression DOUBLE_POINT Expression { $$= ??? ; }
  | ACCOLADE_GAUCHE Expression ACCOLADE_DROITE  { $$=$2; }
  | CROCHET_GAUCHE Expression CROCHET_DROITE  { $$=$2; }
  ;

%%

int yyerror(char *s) {
  printf("%s\n",s);
}

int main(void) {
  yyparse();
}
