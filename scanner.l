/* Trabalho de Compiladores - Cleiber Rodrigues e Cintia Valente */
/* Cartões: 00270139 - 00228540 */

%option noyywrap
%option yylineno
%x MULTI_LINE_COMMENT
%x SINGLE_LINE_COMMENT

%{
#include <iostream>    
#include <string>
#include <algorithm>
#include "parser.tab.h"
#include "tree.hh"

using namespace std;

int getLineNumber();

%}

TOKEN_ID  ([a-z]*|_)
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

"int" 		{ yylval.valor_lexico = nullptr; return TK_PR_INT; }
"float" 	{ yylval.valor_lexico = nullptr; return TK_PR_FLOAT; }
"bool" 		{ yylval.valor_lexico = nullptr; return TK_PR_BOOL; }
"if" 		{ yylval.valor_lexico = new AstNode(yylineno, TkType::TK_PR, TkValue("if"));     return TK_PR_IF; }
"else" 		{ yylval.valor_lexico = nullptr; return TK_PR_ELSE; }
"while" 	{ yylval.valor_lexico = new AstNode(yylineno, TkType::TK_PR, TkValue("while"));  return TK_PR_WHILE; }
"return"	{ yylval.valor_lexico = new AstNode(yylineno, TkType::TK_PR, TkValue("return")); return TK_PR_RETURN; }

{INT}     { yylval.valor_lexico = new AstNode(yylineno, TkType::TK_LIT_INT, TkValue(stoi(yytext))); return TK_LIT_INT; }
{FLOAT}   { yylval.valor_lexico = new AstNode(yylineno, TkType::TK_LIT_FLOAT, TkValue(stof(yytext))); return TK_LIT_FLOAT; }
{TRUE}    { yylval.valor_lexico = new AstNode(yylineno, TkType::TK_LIT_BOOL, TkValue(true)); return TK_LIT_TRUE; }
{FALSE}   { yylval.valor_lexico = new AstNode(yylineno, TkType::TK_LIT_BOOL, TkValue(false)); return TK_LIT_FALSE; }

{TOKEN_ID} { 
    yylval.valor_lexico = new AstNode(yylineno, TkType::TK_ID, TkValue(yytext)); 
    return TK_IDENTIFICADOR;
    }


{SPECIAL} { 
    yylval.valor_lexico = nullptr;
    // Ignora caracteres que não irão para a arvore sintática
    if (find(invalid_chars.begin(), invalid_chars.end(), yytext[0]) == invalid_chars.end()) {
        yylval.valor_lexico = new AstNode(yylineno, TkType::TK_SP, TkValue(yytext[0]));
    }
    return yytext[0]; 
    }


"<="		{ yylval.valor_lexico = new AstNode(yylineno, TkType::TK_OC, TkValue("<=")); return TK_OC_LE; }	
">="		{ yylval.valor_lexico = new AstNode(yylineno, TkType::TK_OC, TkValue(">=")); return TK_OC_GE; }	
"=="		{ yylval.valor_lexico = new AstNode(yylineno, TkType::TK_OC, TkValue("==")); return TK_OC_EQ; }
"!="		{ yylval.valor_lexico = new AstNode(yylineno, TkType::TK_OC, TkValue("!=")); return TK_OC_NE; }	
"&"			{ yylval.valor_lexico = new AstNode(yylineno, TkType::TK_OC, TkValue("&"));  return TK_OC_AND; }	
"|" 		{ yylval.valor_lexico = new AstNode(yylineno, TkType::TK_OC, TkValue("|"));  return TK_OC_OR; }	 
"->" 		{ yylval.valor_lexico = new AstNode(yylineno, TkType::TK_OC, TkValue("->")); return TK_OC_MAP; }	




.			{ return TK_ERRO; }

%%
