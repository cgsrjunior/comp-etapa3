#include <iostream>
#include <string>
#include <sstream>
#include <algorithm>
#include "tree.hh"

using namespace std;

extern int yylineno;

AstNode::AstNode(int number, TkType token_tp, TkValue value){
    this->lex.line_number = number;
	this->lex.token_type = token_tp;
	this->lex.token_val = value;
}


void AstNode::add_child(AstNode* child) {
    if (child != nullptr) {
        this->children.push_back(smart_pointer(child));
    }
}

string AstNode::to_string() {
    stringstream ss;
    string output;
    switch (this->lex.token_type) {
        case TkType::TK_SP_CHAR:
            ss << get<char>(this->lex.token_val);
            return output;
        case TkType::TK_PR:
        case TkType::TK_OC:
            ss << get<string>(this->lex.token_val);
            return output; 
        case TkType::TK_ID:
            if (this->func_call) {
                ss << get<string>(this->lex.token_val);
                return "call" + output;
            }
            else return output;            
        case TkType::TK_LIT_INT:
            ss << get<int>(this->lex.token_val);
            return output;
        case TkType::TK_LIT_FLOAT:
            ss << get<float>(this->lex.token_val);
            return output;
        case TkType::TK_LIT_BOOL:
            ss << get<bool>(this->lex.token_val);
            return output;
        default:
            return "";
    }
}

void AstNode::reg_func_call(bool value){
    this->func_call = value;
}

void print_tree(shared_ptr<AstNode> tree) {
	cout << tree << " [label=\"" << tree->to_string() << "\"]" << endl;
	
	for (auto& child : tree->children) {
		cout << tree << "," << child << endl;
		print_tree(child);
	}
}

void exporta(void* tree) {
    if (tree != nullptr) {
        auto arv = shared_ptr<AstNode>((AstNode*) tree);
        print_tree(arv);
    }
}

