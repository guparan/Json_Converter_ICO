%{

#include "global.h"

%}

blancs      [ \t]+

chiffre     [0-9]
entier      [1-9]{chiffre}*
exposant    [eE][+-]?{entier}
nbflottant  {entier}("."{chiffre}+)?{exposant}?

chaine      \"[^\"\\\/\b\f\n\r\t\u]+\"
jobject		\{ {chaine} : {jvalue}(", "{chaine} : {jvalue})* \}
jarray      \[ {jobject}(", "{jobject})* \]
jvalue      null | true | false | {chaine} | {nbflottant} | {jobject} | {jarray}
	  

%%

{blancs}  { /* On ignore */ }

{jarray}  {
      yylval=yytext;
      return(TABLEAU_JSON);
    }
    
{jobject}  {
      yylval=yytext;
      return(OBJET_JSON);
    }   

"["   return(CROCHET_GAUCHE);
"]"   return(CROCHET_DROITE);

"{"   return(ACCOLADE_GAUCHE);
"}"   return(ACCOLADE_DROITE);

":"   return(DOUBLE_POINT);
","   return(VIRGULE);

"\n"  return(FIN);
