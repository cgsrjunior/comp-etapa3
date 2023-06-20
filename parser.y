
/* Trabalho de Compiladores - Cleiber Rodrigues e Cintia Valente */
/* Cartões: 00270139 - 00228540 */

%{
#include <stdio.h>
#include <stdlib.h>
int yylex(void);
int yyerror (const char *message);
extern int get_line_number(void);
%}
%define parse.error verbose

%token TK_PR_INT
%token TK_PR_FLOAT
%token TK_PR_BOOL
%token TK_PR_IF
%token TK_PR_ELSE
%token TK_PR_WHILE
%token TK_PR_RETURN
%token TK_OC_LE
%token TK_OC_GE
%token TK_OC_EQ
%token TK_OC_NE
%token TK_OC_AND
%token TK_OC_OR
%token TK_OC_MAP
%token TK_IDENTIFICADOR
%token TK_LIT_INT
%token TK_LIT_FLOAT
%token TK_LIT_FALSE
%token TK_LIT_TRUE
%token TK_ERRO

%union {
  lex_value_t valor_lexico;
}

%%

programa    : list_decl
            ;            
        
list_decl   : decl list_decl
            |
            ;

decl        : var
            | func
            ;

var         : type list_id ';'
            ;

list_id     : list_id ',' id_label
            | id_label
            ;

type        : TK_PR_INT
            | TK_PR_FLOAT
            | TK_PR_BOOL
            ;

func        : header body
            ;

header      : name_func '(' list_param ')' TK_OC_MAP type

list_param  : list_param ',' id_param
            | id_param
            |
            ;


body        : '{' list_cmd '}'
            ;


list_cmd    :  cmd ';' list_cmd
            |
            ;

cmd         : cmd_var
            | cmd_atrib
            | cmd_func_call
            | cmd_return
            | cmd_flux_ctrl
            | body
            ;

cmd_flux_ctrl   : TK_PR_IF '(' expr ')' body
                | TK_PR_IF '(' expr ')' body TK_PR_ELSE body
                | TK_PR_WHILE '(' expr ')' body


cmd_func_call: name_func '(' list_arg ')'
             ;

func_call_param : name_func '(' list_arg ')'
                ;

unary_operand : '-' 
              | '!' 
              ;

bin_sec_expr : '*' 
             | '/' 
             | '%'
             ;

bin_thr_expr : '+' 
             | '-'
             ;

bin_fou_expr : '<' 
             | '>' 
             | TK_OC_LE  
             | TK_OC_GE 
             ;

bin_fif_expr : TK_OC_NE 
             | TK_OC_EQ 
             ;

bin_six_expr: TK_OC_AND 
             ;

bin_sev_expr: TK_OC_OR
             ;

expr: expr_1 
    | expr bin_sev_expr expr_1
    |
    ;

expr_1: expr_2 
      | expr_1 bin_six_expr expr_2
      ;

expr_2: expr_3 
      | expr_2 bin_fif_expr expr_3
      ;

expr_3: expr_4 
      | expr_3 bin_fou_expr expr_4
      ;

expr_4: expr_5 
      | expr_4 bin_thr_expr expr_5
      ;

expr_5: unary_expr 
      | expr_5 bin_sec_expr unary_expr
      ;

unary_expr: parenthesis_prec 
          | unary_operand parenthesis_prec
          ;

parenthesis_prec    :  operand
                    | '(' expr ')'
                    ;

operand     : id_label
            | lit
            | func_call_param
            ;


list_arg    : list_arg ',' expr
            | expr
            ;

cmd_return  : TK_PR_RETURN expr
            ;

cmd_atrib   : id_label '=' expr
            ;

cmd_var     : atrib_var
            ;

atrib_var   : type list_id_atrib
            ;

list_id_atrib   : list_id_atrib ',' id_atrib
                | id_atrib
                ;

id_atrib        : id_label TK_OC_LE lit
                | id_label
                ;

lit             : TK_LIT_INT
                | TK_LIT_FLOAT
                | TK_LIT_TRUE
                | TK_LIT_FALSE
                ;

id_label: TK_IDENTIFICADOR;
name_func: TK_IDENTIFICADOR;
id_param: type TK_IDENTIFICADOR;

%%
int yyerror (const char *message)
{
    printf("Error line %d: %s\n", get_line_number(), message);
    return 1;
}