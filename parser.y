%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "SymbolTable.h"

/* Prototypes */
void yyerror(SymbolTable *symTable, const char *s);
double funcCall(SymbolTable *symTable, char *funcName, double arg);
%}

%union {
	char *str;
	double dbl;
	int boolean;
}

%token DOUBLE ID PLUS MINUS MULT DIV EQUALS IF ELSE FOR LT GT LE GE EQ NE INC DEC LPAREN RPAREN SEMI
%type<str> ID
%type<dbl> DOUBLE dbl_op iteration
%type<boolean> condition
%lex-param { SymbolTable *symTable }
%parse-param { SymbolTable *symTable }

%debug

%%
program : statement SEMI { printf("Parsed program\n"); }
        | program statement SEMI { printf("Parsed a statement\n"); }
        ;

statement : var_declaration { printf("Variable declaration\n"); }
          | math_expression { printf("Math expression\n"); }
          | if_statement	{ printf("If statement\n"); }
          | for_loop		{ printf("For loop statement\n"); }
          ;

var_declaration: ID EQUALS DOUBLE { addVariable(symTable, $1, $3); }
                | ID EQUALS dbl_op { addVariable(symTable, $1, $3); }
                ;

math_expression : dbl_op { printf("Printed double expression\n"); }
                ;
                
if_statement : IF LPAREN condition RPAREN statement 					{printf("Parsed if statement\n"); }
			 | IF LPAREN condition RPAREN statement ELSE statement	{printf("Parsed if-esle statement\n"); }
			 ;
			 
for_loop : FOR LPAREN var_declaration SEMI condition SEMI iteration RPAREN statement 	{printf("Parsedf for-loop\n"); }
		 ;

condition : dbl_op LE dbl_op {$$ = $1 <= $3;}
		  | dbl_op LT dbl_op {$$ = $1 < $3;}
		  | dbl_op GE dbl_op {$$ = $1 >= $3;}
		  | dbl_op GT dbl_op {$$ = $1 > $3;}
		  | dbl_op EQ dbl_op {$$ = $1 == $3;}
		  | dbl_op NE dbl_op {$$ = $1 != $3;}
		  ;
		  
iteration : ID INC 		{double value = getVariableValue(symTable, $1) + 1; addVariable(symTable, $1, value); $$ = value; }
		  | ID DEC 		{double value = getVariableValue(symTable, $1) + 1; addVariable(symTable, $1, value); $$ = value; }
		  | dbl_op 		{$$ = $1;}
		  ;


dbl_op : DOUBLE                    {$$ = $1;}
       | ID                        {$$ = getVariableValue(symTable, $1); }
       | ID LPAREN dbl_op RPAREN         {$$ = funcCall(symTable, $1, $3);} /* Handle function calls */
       | dbl_op PLUS dbl_op        {$$ = $1 + $3;}
       | dbl_op MINUS dbl_op       {$$ = $1 - $3;}
       | dbl_op MULT dbl_op        {$$ = $1 * $3;}
       | dbl_op DIV dbl_op         {$$ = $1 / $3;}
       | LPAREN dbl_op RPAREN            {$$ = $2;} /* Handle parenthesized expressions */
       ;

%%
int main() {
	#ifdef YYDEBUG
		yydebug = 1;
	#endif
	
	SymbolTable symTable;
	initSymbolTable(&symTable);
	yyparse(&symTable);
	return 0;
}

/* Define yyerror function */
void yyerror(SymbolTable *symTable, const char *s) {
    extern int yylineno;
    extern char *yytext;
    printf("Error: %s (token '%s')\n", s, yytext);
}

/* Define funcCall function */
double funcCall(SymbolTable *symTable, char *funcName, double arg) {
    if (strcmp(funcName, "sin") == 0) {
        return sin(arg);
    } else if (strcmp(funcName, "cos") == 0) {
        return cos(arg);
    } else {
        printf("Error: Unknown function '%s'\n", funcName);
        return 0.0;
    }
}
