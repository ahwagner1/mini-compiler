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
    struct {
        double maxValue;
        int result;
    } conditionResult;
}

%token DOUBLE ID PLUS MINUS MULT DIV EQUALS IF ELSE FOR LT GT EQ NE INC DEC LPAREN RPAREN SEMI LBRACE RBRACE
%type<str> ID
%type<dbl> DOUBLE dbl_op iteration var_declaration for_loop
%type<conditionResult> condition
%lex-param { SymbolTable *symTable }
%parse-param { SymbolTable *symTable }

%debug

%%
program : statement SEMI {}
        | program statement SEMI {}
        ;

statement : var_declaration { } // printf("Variable declaration\n"); }
          | math_expression { } // printf("Math expression\n"); }
          | if_statement	{ } // printf("If statement\n"); }
          | for_loop		{ } // printf("For loop statement\n"); }
          ;

var_declaration: ID EQUALS DOUBLE { addVariable(symTable, $1, $3); printf("%s = %f;\n", $1, $3); }
                | ID EQUALS dbl_op { addVariable(symTable, $1, $3); printf("%s = %f;\n", $1, $3); }
                ;

math_expression : dbl_op { printf("Math expression detected\n"); }
                ;
                
if_statement : IF LPAREN condition RPAREN LBRACE statements RBRACE ELSE LBRACE statements RBRACE 
				{
					printf("Evaluating if condition...\n");
					int conditionRes = $3.result;
					if (conditionRes) {
						printf("Condition evaluted to true, entering \"if\" scope\n");
					}
					else {
						printf("Condition evaluated to false\nEntering \"else\" scope\n");
					}
				}
             | IF LPAREN condition RPAREN LBRACE statements RBRACE
             	{
					printf("Evaluating if condition...\n");
					int conditionRes = $3.result;
					if (conditionRes) {
						printf("Condition evaluted to true, entering if scope\n");
					}
					else {
						printf("Condition evaluated to false\nNo else branch detected, moving to next statement\n");
					}
				}
             ;

statements : statement SEMI 
           | statements statement SEMI 
           ;

for_loop : FOR LPAREN var_declaration SEMI condition SEMI iteration RPAREN LBRACE statements RBRACE
         {
             double initialValue = $3;
             double maxValue = $5.maxValue;
             int conditionResult = $5.result;
             double incrementValue = $7;
             double i = initialValue;

             for (; conditionResult; i += incrementValue) {
                 printf("i = %f\n", i);                 
                 conditionResult = (i < maxValue);
             }
             
             printf("for-loop execution completed\n");
         }
         ;

condition : dbl_op LT dbl_op             { $$.maxValue = fmax($1, $3); $$.result = ($1 < $3); }
          | dbl_op GT dbl_op             { $$.maxValue = fmax($1, $3); $$.result = ($1 > $3); }
          | dbl_op EQ dbl_op             { $$.maxValue = fmax($1, $3); $$.result = ($1 == $3); }
          | dbl_op NE dbl_op             { $$.maxValue = fmax($1, $3); $$.result = ($1 != $3); }
          ;
		  
iteration : ID INC 		{double value = getVariableValue(symTable, $1) + 1; addVariable(symTable, $1, value); $$ = value; }
		  | ID DEC 		{double value = getVariableValue(symTable, $1) + 1; addVariable(symTable, $1, value); $$ = value; }
		  | dbl_op 		{$$ = $1;}
		  ;


dbl_op : DOUBLE                    {$$ = $1;}
       | ID                        {$$ = getVariableValue(symTable, $1); }
       | ID LPAREN dbl_op RPAREN   {$$ = funcCall(symTable, $1, $3);}
       | dbl_op PLUS dbl_op        {$$ = $1 + $3; printf("%f + %f = %f\n", $1, $3, $$); }
       | dbl_op MINUS dbl_op       {$$ = $1 - $3; printf("%f - %f = %f\n", $1, $3, $$);}
       | dbl_op MULT dbl_op        {$$ = $1 * $3; printf("%f * %f = %f\n", $1, $3, $$);}
       | dbl_op DIV dbl_op         {$$ = $1 / $3; printf("%f / %f = %f\n", $1, $3, $$);}
       | LPAREN dbl_op RPAREN      {$$ = $2;}
       ;

%%
int main() {
	//#ifdef YYDEBUG
	//	yydebug = 1;
	//#endif
	
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
    	double res = sin(arg);
    	printf("sin(%f) = %f\n", arg, res);
        return res;
    } else if (strcmp(funcName, "cos") == 0) {
        double res = cos(arg);
    	printf("cos(%f) = %f\n", arg, res);
        return res;
    } else {
        printf("Error: Unknown function '%s'\n", funcName);
        return 0.0;
    }
}
