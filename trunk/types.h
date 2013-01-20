#ifndef PARSE_TREE_H
#define PARSE_TREE_H

typedef enum { jarray, jobject, jvalue, jpair, jterm } NodeType;
typedef enum { true, false, null, string, number } ValType;


typedef struct nodeStruct {
	NodeType nodeType;
	char* string; // can be the name or the value of a pair
	struct nodeStruct *next; // another elements of same type
	struct nodeStruct *children; // child elements
} Node;

extern int sym[26];


#endif
