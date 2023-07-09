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

string AstNode::tostring() {
        try{
            switch (this->lex.token_type) {
                case TkType::TK_SP_CHAR:
                    return string(&get<char>(this->lex.token_val), 1);
                case TkType::TK_PR:
                case TkType::TK_OC:
                    return string(get<string>(this->lex.token_val)); 
                case TkType::TK_ID:
                    if (this->func_call) {
                        //return string("call ")+get<string>(this->lex.token_val);
                    }
                    else 
                        //return get<string>(this->lex.token_val);          
                case TkType::TK_LIT_INT:
                    //return to_string(get<int>(this->lex.token_val));
                case TkType::TK_LIT_FLOAT:
                    //return to_string(get<float>(this->lex.token_val));
                case TkType::TK_LIT_BOOL:
                    //return to_string(get<bool>(this->lex.token_val));
                default:
                    return "";
                }
        }
        catch (const std::bad_variant_access& ex){
            std::cout << ex.what() << '\n';
        }
}

void AstNode::reg_func_call(bool value){
    this->func_call = value;
}

void print_tree(shared_ptr<AstNode> tree) {
	cout << tree << " [label=\"" << tree->tostring() << "\"]" << endl;
	
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

