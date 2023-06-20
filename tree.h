#ifndef _ARVORE_H_
#define _ARVORE_H_

/* Estrutura do valor lexico
(a) número
da linha onde apareceu o lexema; (b) tipo do token
(caractere especial, palavra reservada, operador composto, identificador, literal); (c) valor do token
*/

typedef struct lex_value {
  int line;
  char* token_type;
  char* token_value;
} lex_value_t;

lex_value_t create_lex_value(const int line, const char *token_type, const char* token_value);

typedef struct asd_tree {
  lex_value_t lex_val;
  int number_of_children;
  struct asd_tree **children;
} asd_tree_t;

/*
 * Função asd_new, cria um nó sem filhos com o label informado.
 */
asd_tree_t *asd_new(const lex_value_t label);

/*
 * Função asd_tree, libera recursivamente o nó e seus filhos.
 */
void asd_free(asd_tree_t *tree);

/*
 * Função asd_add_child, adiciona child como filho de tree.
 */
void asd_add_child(asd_tree_t *tree, asd_tree_t *child);

/*
 * Função asd_print, imprime recursivamente a árvore.
 */
void asd_print(asd_tree_t *tree);

/*
 * Função asd_print_graphviz, idem, em formato DOT
 */
void asd_print_graphviz (asd_tree_t *tree);
#endif //_ARVORE_H_
