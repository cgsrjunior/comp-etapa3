
/* Trabalho de Compiladores - Cleiber Rodrigues e Cintia Valente */
/* Cartões: 00270139 - 00228540 */

%{
#include "tree.hh"
#include <iostream>
#include <memory>
extern int get_line_number(void);
extern void *arvore;
int yylex(void);
int yyerror (const char *message);
%}


%union {
      LexVal valor_lexico
      AstNode* ast;
}

%define parse.error verbose

%token<valor_lexico> TK_PR_INT
%token<valor_lexico> TK_PR_FLOAT
%token<valor_lexico> TK_PR_BOOL
%token<valor_lexico> TK_PR_IF
%token<valor_lexico> TK_PR_ELSE
%token<valor_lexico> TK_PR_WHILE
%token<valor_lexico> TK_PR_RETURN
%token<valor_lexico> TK_OC_LE
%token<valor_lexico> TK_OC_GE
%token<valor_lexico> TK_OC_EQ
%token<valor_lexico> TK_OC_NE
%token<valor_lexico> TK_OC_AND
%token<valor_lexico> TK_OC_OR
%token<valor_lexico> TK_OC_MAP
%token<valor_lexico> TK_IDENTIFICADOR
%token<valor_lexico> TK_LIT_INT
%token<valor_lexico> TK_LIT_FLOAT
%token<valor_lexico> TK_LIT_FALSE
%token<valor_lexico> TK_LIT_TRUE
%token<valor_lexico> TK_ERRO
%token<valor_lexico> '-' '!' '*' '/' '%' '+' '<' '>' '&' '|' '='

%type<ast> programa
%type<ast> list_decl
%type<ast> decl
%type<ast> var
%type<ast> list_id
%type<ast> type
%type<ast> func
%type<ast> header
%type<ast> list_param
%type<ast> body
%type<ast> list_cmd
%type<ast> cmd
%type<ast> cmd_flux_ctrl
%type<ast> cmd_func_call
%type<ast> func_call_param
%type<ast> unary_operand
%type<ast> bin_sec_expr
%type<ast> bin_thr_expr
%type<ast> bin_fou_expr
%type<ast> bin_fif_expr
%type<ast> bin_six_expr
%type<ast> bin_sev_expr
%type<ast> expr
%type<ast> expr_1
%type<ast> expr_2
%type<ast> expr_3
%type<ast> expr_4
%type<ast> expr_5
%type<ast> unary_expr
%type<ast> parenthesis_prec
%type<ast> operand
%type<ast> list_arg
%type<ast> cmd_return
%type<ast> cmd_atrib
%type<ast> cmd_var
%type<ast> atrib_var
%type<ast> list_id_atrib
%type<ast> id_atrib
%type<ast> lit
%type<ast> id_label
%type<ast> name_func
%type<ast> id_param

%start programa

%%

programa    : list_decl {$$ = $1; arvore = $$;}
            ;            
        
list_decl   : decl list_decl {
              if($$!=nullptr){
                  $$ = $1;
                  $$->add_child($2);
               }
               else{
                  $$ = $2;
               }
            }
            | {$$ = nullptr;}
            ;

decl        : var  {$$ = $1;}
            | func {$$ = $1;}
            ;

var         : type list_id ';' {$$ = nullptr;}
            ;

list_id     : list_id ',' id_label {$$ = nullptr;}
            | id_label {$$ = nullptr;}
            ;

type        : TK_PR_INT   {$$ = nullptr;}
            | TK_PR_FLOAT {$$ = nullptr;}
            | TK_PR_BOOL  {$$ = nullptr;}
            ;

func        : header body {$$ = $1; $$->add_child($2);}
            ;

header      : name_func '(' list_param ')' TK_OC_MAP type {$$ = $5;}
            ;


list_param  : list_param ',' id_param {$$ = nullptr;}
            | id_param {$$ = nullptr;}
            | {$$ = nullptr;}
            ;


body        : '{' list_cmd '}' {$$ = $2;}
            ;


list_cmd    :  cmd ';' list_cmd {
               if($1 != nullptr){
                  $$  = $1;
                  $$->add_child($3);
               }
               else{
                  $$ = $3;
               }
            }
            |  {$$ = nullptr;}
            ;

cmd         : cmd_var         {$$ = $1;}
            | cmd_atrib       {$$ = $1;}
            | cmd_func_call   {$$ = $1;}
            | cmd_return      {$$ = $1;}
            | cmd_flux_ctrl   {$$ = $1;}
            | body            {$$ = $1;}
            ;

cmd_flux_ctrl   : TK_PR_IF '(' expr ')' body {$$ = $1; $$->add_child($3); $$->add_child($5);}
                | TK_PR_IF '(' expr ')' body TK_PR_ELSE body {$$ = $1; $$->add_child($3); $$->add_child($5); $$->add_child($7);}
                | TK_PR_WHILE '(' expr ')' body {$$ = $1; $$->add_child($3); $$->add_child($5);}


cmd_func_call: name_func '(' list_arg ')'    {$$ = $1; $$->add_child($3);}
             ;

func_call_param : name_func '(' list_arg ')' {$$ = $1; $$->add_child($3);}
                ;


unary_operand : '-'     {$$ = $1;}
              | '!'     {$$ = $1;}
              ;

bin_sec_expr : '*'      {$$ = $1;}
             | '/'      {$$ = $1;}
             | '%'      {$$ = $1;}
             ;

bin_thr_expr : '+'      {$$ = $1;}
             | '-'      {$$ = $1;}
             ;

bin_fou_expr : '<'      {$$ = $1;}
             | '>'      {$$ = $1;}
             | TK_OC_LE {$$ = $1;}
             | TK_OC_GE {$$ = $1;}
             ;

bin_fif_expr : TK_OC_NE {$$ = $1;}
             | TK_OC_EQ {$$ = $1;}
             ;

bin_six_expr: TK_OC_AND {$$ = $1;}
             ;

bin_sev_expr: TK_OC_OR {$$ = $1}
             ;

expr: expr_1 {$$ = $1;} 
    | expr bin_sev_expr expr_1 {$$ = $2; $$->add_child($1); $$->add_child($3);}
    | {$$ = nullptr;}
    ;

expr_1: expr_2 {$$ = $1;}
      | expr_1 bin_six_expr expr_2 {$$ = $2; $$->add_child($1); $$->add_child($3);}
      ;

expr_2: expr_3 {$$ = $1;}
      | expr_2 bin_fif_expr expr_3 {$$ = $2; $$->add_child($1); $$->add_child($3);}
      ;

expr_3: expr_4                     {$$ = $1;}
      | expr_3 bin_fou_expr expr_4 {$$ = $2; $$->add_child($1); $$->add_child($3);}
      ;

expr_4: expr_5                     {$$ = $1;}
      | expr_4 bin_thr_expr expr_5 {$$ = $2; $$->add_child($1); $$->add_child($3);}
      ;

expr_5: unary_expr                     {$$ = $1;}
      | expr_5 bin_sec_expr unary_expr {$$ = $2; $$->add_child($1); $$->add_child($3);}
      ;

unary_expr: parenthesis_prec               {$$ = $1;}
          | unary_operand parenthesis_prec {$$ = $1; $$->add_child($2);}
          ;

parenthesis_prec    :  operand      {$$ = $1;}
                    | '(' expr ')'  {$$ = $2;}
                    ;

operand     : id_label        {$$ = $1;}
            | lit             {$$ = $1;}
            | func_call_param {$$ = $1;}
            ;


list_arg    : list_arg ',' expr {$$ = $1; $$->add_child($3);}
            | expr {$$ = $1;}
            ;

cmd_return  : TK_PR_RETURN expr {$$ = $1; $$->add_child($2);}
            ;

cmd_atrib   : id_label '=' expr {$$ = $2; $$->add_child($1); $$->add_child($3);}
            ;

cmd_var     : atrib_var {$$ = $1}
            ;

atrib_var   : type list_id_atrib {$$ = $2;}
            ;

list_id_atrib   : list_id_atrib ',' id_atrib{
                  if ($$ != nullptr) {
                        $$ = $3; 
                        $$->add_child($1);
                  } else {
                        $$ = $1;
                  }
                }
                | id_atrib {$$ = $1;}
                ;

id_atrib        : id_label TK_OC_LE lit {$$ = $2; $$->add_child($1); $$->add_child($3);}
                | id_label {$$ = $1;}
                ;

lit             : TK_LIT_INT   {$$ = $1;}
                | TK_LIT_FLOAT {$$ = $1;}
                | TK_LIT_TRUE  {$$ = $1;}
                | TK_LIT_FALSE {$$ = $1;}
                ;

id_label: TK_IDENTIFICADOR {$$ = nullptr;}
        ;      

name_func: TK_IDENTIFICADOR {$$ = nullptr;}
         ;     

id_param: type TK_IDENTIFICADOR {$$ = nullptr; delete $2}
        ;

%%
int yyerror (const char *message)
{
    printf("Error line %d: %s\n", get_line_number(), message);
    return 1;
}