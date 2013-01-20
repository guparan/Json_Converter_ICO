#include <stdio.h>
#include <string.h>

#include "types.h"
#include "y.tab.h"

/* Prototypes */
int start(Node* json);
void prettyPrint(Node* node, int nbTabs, int isPairValue);
void printTab(int nbTabs);


/* First executed function */
int start(Node* json) {
	prettyPrint(json, 0 , false);
	return 0;
}

/* Indentation manager */
void printTab(int nbTabs) {
	int i;
	
	for(i = 0 ; i < nbTabs ; i++) {
		printf("  ");
	}
}

/* Pretty printer */
void prettyPrint(Node* node, int nbTabs, int isPairValue) 
{		
	switch(node->nodeType) 
	{
		case jarray :
			if(isPairValue) printTab(nbTabs);
			printf("[\n");
			if(node->children)
			{
				Node *child = node->children;
				while(child)
				{
					prettyPrint(child, nbTabs+1, false);
					child = child->next;
				}
			}
			
			printTab(nbTabs);
			if(node->next) printf("],\n");
			else 
			{
				printf("]");
				if(isPairValue) printf("\n");
			}
		break;

		case jobject :
			if(isPairValue) printTab(nbTabs);
			printf("{\n");
			if(node->children)
			{
				Node *child = node->children;
				while(child)
				{
					prettyPrint(child, nbTabs+1, false);
					child = child->next;
				}
			}
				
			printTab(nbTabs);
			if(node->next) printf("},\n");
			else
			{
				printf("}");
				if(isPairValue) printf("\n");
			}
		break;
			
		case jpair :
			printTab(nbTabs);
			printf("%s : ", node->string);	
			if(node->children)
			{
				Node *child = node->children;
				while(child)
				{
					if(child->nodeType == jterm) prettyPrint(child, nbTabs+1, true);
					else prettyPrint(child, nbTabs, true);
					child = child->next;
				}
			}
			if(node->next) printf(",\n");
			else printf("\n");
		break;
			
		case jterm :
			printf("%s", node->string);
		break;
	}
}

