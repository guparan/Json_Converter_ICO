%{

#include "global.h"

%}

blancs      [ \t]+

chiffre     [0-9]
entier      [1-9]{chiffre}*
exposant    [eE][+-]?{entier}
nbflottant  {entier}("."{chiffre}+)?{exposant}?

chaine      \"[^\"\\\/\b\f\n\r\t\u]+\"		/* C'est beau hein ? */
jobject		\{ {chaine} : {jvalue}(", "{chaine} : {jvalue})* \}
jarray      \[ {jobject}(", "{jobject})* \]
jvalue      null | true | false | {chaine} | {nbflottant} | {jobject} | {jarray}
	  

%%

{blancs}  { /* On ignore */ }

{nbflottant}  {
      yylval=atof(yytext);
      return(NOMBRE);
    }

"+"   return(PLUS);
"-"   return(MOINS);

"*"   return(FOIS);
"/"   return(DIVISE);

"^"   return(PUISSANCE);

"("   return(PARENTHESE_GAUCHE);
")"   return(PARENTHESE_DROITE);

"\n"  return(FIN);