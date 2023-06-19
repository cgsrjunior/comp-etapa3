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

"int" 		{ return TK_PR_INT; }
"float" 	{ return TK_PR_FLOAT; }
"bool" 		{ return TK_PR_BOOL; }
"if" 		{ return TK_PR_IF; }
"else" 		{ return TK_PR_ELSE; }
"while" 	{ return TK_PR_WHILE; }
"return"	{ return TK_PR_RETURN; }

{INT}     { return TK_LIT_INT; }
{FLOAT}   { return TK_LIT_FLOAT; }
{TRUE}    { return TK_LIT_TRUE; }
{FALSE}   { return TK_LIT_FALSE; }

{TOKEN_ID} { return TK_IDENTIFICADOR; }


{SPECIAL} { return yytext[0]; }


"<="			return TK_OC_LE;
">="			return TK_OC_GE;
"=="			return TK_OC_EQ;
"!="			return TK_OC_NE;
"&"				return TK_OC_AND;
"|" 			return TK_OC_OR; 
"->" 			return TK_OC_MAP;

.			{ return TK_ERRO; }

%%

int get_line_number() {
	return yylineno;
}