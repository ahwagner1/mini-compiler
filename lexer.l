%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "SymbolTable.h"
#include "parser.tab.h"
%}

%%
[a-zA-z]+ 							{ yylval.str = strdup(yytext); return ID; }
[0-9]+(\.[0-9]+)?				    { yylval.dbl = atof(yytext); return DOUBLE; }
"("		                            { return LPAREN; }
")"		                            { return RPAREN; }
";"		                            { return SEMI; }
"+"                                 { return PLUS; }
"-"		                            { return MINUS; }
"*"		                            { return MULT; }
"/"		                            { return DIV; }
"="		                            { return EQUALS; }
"if"								{ return IF; }
"else"								{ return ELSE; }
"for"								{ return FOR; }
"<"									{ return LT; }
">"									{ return GT; }
"<="								{ return LE; }
">="								{ return GE; }
"=="								{ return EQ; }
"!="								{ return NE; }
"++"								{ return INC; }
"--" 								{ return DEC; }
[ \t\n]		                        ; /* ignore whitespace */
.		                            { printf("Unrecognized token: %s\n", yytext); } /* return the single characters token*/
%%
