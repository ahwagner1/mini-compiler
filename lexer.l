%{
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include "SymbolTable.h"
#include "parser.tab.h"
%}

%%
"if"								{ return IF; }
"for"								{ return FOR; }
"else"								{ return ELSE; }
[a-zA-z]+ 							{ yylval.str = strdup(yytext); return ID; }
[0-9]+(\.[0-9]+)?				    { yylval.dbl = atof(yytext); return DOUBLE; }
"("		                            { return LPAREN; }
")"		                            { return RPAREN; }
"{"									{ return LBRACE; }
"}"									{ return RBRACE; }
";"		                            { return SEMI; }
"+"                                 { return PLUS; }
"-"		                            { return MINUS; }
"*"		                            { return MULT; }
"/"		                            { return DIV; }
"="		                            { return EQUALS; }
"<"									{ return LT; }
">"									{ return GT; }
"=="								{ return EQ; }
"!="								{ return NE; }
"++"								{ return INC; }
"--" 								{ return DEC; }
[ \t\n]		                        ; /* ignore whitespace */
.		                            { printf("Unrecognized token: %s\n", yytext); } /* return unrecognized tokens*/
%%
