#include <iostream>
#include <string>
#include <sstream>
#include <algorithm>
#include "tree.hh"

using namespace std;

extern int yylineno;

LexValue::LexValue(int line, TkType token_tp, TkValue value) {
    this->line_number = line;
    this->token_tp = token_tp;
    this->token_val = value;
}

AstNode::AstNode(int number, TkType token_tp, TkValue value){
    this->lex.line_number = line;
	this->lex.token_type = token_tp;
	this->lex.token_val = value;
}

AstNode::~AstNode()
{
	return nullptr;
}

void AstNode::add_child(AstNode* child) {
    if (child != nullptr) {
        this->children.push_back(Node_p(child));
    }
}

void AstNode::print_tree(shared_ptr<AstNode> tree) {
	cout << tree << " [label=\"" << tree->to_string() << "\"]" << endl;
	
	for (auto& child : arvore->children) {
		cout << arvore << "," << child << endl;
		print_arvore(child);
	}
}

string AstNode::to_string(void) {
    switch (this->lex.token_type) {
        case TokenType::TK_SP_CHAR
            return string(&get<char>(this->lex.token_val), 1);
        case TokenType::TK_PR:
        case TokenType::TK_OC:
            return get<string>(this->lex.token_val); 
        case TokenType::TK_ID:
            if (this->is_func_call) {
                return string("call ")+get<string>(this->lex.token_val);
            }
            else return get<string>(this->lex.token_val);            
        case TokenType::TK_LIT_INT:
            return to_string(get<int>(this->lex.token_val));
        case TokenType::TK_LIT_FLOAT:
            return to_string(get<float>(this->lex.token_val));
        case TokenType::TK_LIT_BOOL:
            return to_string(get<bool>(this->lex.token_val));
        default:
            return "";
    }
}

void exporta(void* arvore) {
    if (arvore != nullptr) {
        auto arv = shared_ptr<Node>((Node*) arvore);
        print_arvore(arv);
    }
}