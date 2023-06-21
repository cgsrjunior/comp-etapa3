/* Trabalho de Compiladores - Cleiber Rodrigues e Cintia Valente */
/* Cartões: 00270139 - 00228540 */

%option noyywrap
%option yylineno
%x MULTI_LINE_COMMENT
%x SINGLE_LINE_COMMENT

%{
#include "parser.tab.h"

int getLineNumber();

%}

TOKEN_ID  (?:[a-z]*|_)
SPECIAL [-,;!*(\)\{\}+/<>=%–]
CHAR    '[^']'
STRING  \"[^"\n]*\"
INT     [0-9]+
FLOAT   [0-9]*[.][0-9]+
TRUE    "true"
FALSE   "false"

%%

<INITIAL>"//"                   BEGIN(SINGLE_LINE_COMMENT);
<SINGLE_LINE_COMMENT>"\n"       BEGIN(INITIAL);
<SINGLE_LINE_COMMENT>.|"\n"     { /* do nothing */ }

<INITIAL>"/*"        BEGIN(MULTI_LINE_COMMENT);
<MULTI_LINE_COMMENT>"*/"        BEGIN(INITIAL);
<MULTI_LINE_COMMENT>.|"\n"     { /* do nothing */ }

[\n]        {  }
[ \t\n\r\s]+      {/* Skips blanks and tabs */ }

"int" 		{ 
	yylval.valor_lexico = asd_new(create_lex_value(yylineno, TK_PR_INT, strdup(yytext))); 
	return TK_PR_INT; 
}

"float" 	{ 
	yylval.valor_lexico = asd_new(create_lex_value(yylineno, TK_PR_FLOAT, strdup(yytext))); 
	return TK_PR_FLOAT; 
}

"bool" 		{ 
	yylval.valor_lexico = asd_new(create_lex_value(yylineno, TK_PR_BOOL, strdup(yytext)));
 	return TK_PR_BOOL;
}

"if" 		{ 
	yylval.valor_lexico = asd_new(create_lex_value(yylineno, TK_PR_IF, strdup(yytext)));
 	return TK_PR_IF;
}

"else" 		{ 
 yylval.valor_lexico = asd_new(create_lex_value(yylineno, TK_PR_ELSE, strdup(yytext)))
 return TK_PR_ELSE; 
}

"while" 	{ 
	yylval.valor_lexico = asd_new(create_lex_value(yylineno, TK_PR_WHILE, strdup(yytext)))
	return TK_PR_WHILE; 
}

"return"	{ 
	yylval.valor_lexico = asd_new(create_lex_value(yylineno, TK_PR_RETURN, strdup(yytext)))
	return TK_PR_RETURN;
}


{INT}     { 
	yylval.valor_lexico = asd_new(create_lex_value(yylineno, TK_LIT_INT, strdup(yytext)));
	return TK_LIT_INT; 
}

{FLOAT}   {
	yylval.valor_lexico = asd_new(create_lex_value(yylineno, TK_LIT_FLOAT, strdup(yytext)));
	return TK_LIT_FLOAT;
}

{TRUE}    {
	yylval.valor_lexico = asd_new(create_lex_value(yylineno, TK_LIT_TRUE, strdup(yytext)));
	return TK_LIT_TRUE; 
}

{FALSE}   {
	yylval.valor_lexico = asd_new(create_lex_value(yylineno, TK_LIT_FALSE, strdup(yytext))); 
	return TK_LIT_FALSE; 
}

{TOKEN_ID} { 
	yylval.valor_lexico = asd_new(create_lex_value(yylineno, TK_IDENTIFICADOR, strdup(yytext))); 
	return TK_IDENTIFICADOR;
}


{SPECIAL} { return yytext[0]; }


"<="		{
	yylval.valor_lexico = asd_new(create_lex_value(yylineno, TK_OC_LE, strdup(yytext)));
	return TK_OC_LE; 
}	
">="		{
	yylval.valor_lexico = asd_new(create_lex_value(yylineno, TK_OC_GE, strdup(yytext)));
	return TK_OC_GE; 
}

"=="		{
	yylval.valor_lexico = asd_new(create_lex_value(yylineno, TK_OC_EQ, strdup(yytext)));
	return TK_OC_EQ; 
}

"!="		{
	yylval.valor_lexico = asd_new(create_lex_value(yylineno, TK_OC_NE, strdup(yytext)));
	return TK_OC_NE; 
}

"&"				return TK_OC_AND;
"|" 			return TK_OC_OR; 
"->" 			return TK_OC_MAP;

.			{ return TK_ERRO; }

%%

int get_line_number() {
	return yylineno;
}