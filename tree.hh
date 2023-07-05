#pragma once
#include <vector>
#include <variant>
#include <string>
#include <memory>

using namespace std;

enum class TkType {
    TK_SP_CHAR, // char
    TK_PR, // std::string
    TK_OC, // std::string
    TK_ID, // std::string
    TK_LIT_INT, // int
    TK_LIT_FLOAT, // float
    TK_LIT_BOOL, // bool
};

const vector<char> invalid_chars {',', ';', '(', ')', '{', '}', '[', ']'};

typedef variant<string, int, float, char, bool> TkValue;

struct LexValue {
    int line_number;
    TkType token_type;
    TkValue token_val;

    LexValue(int line, TkType token_tp, TkValue value);
};

struct AstNode {
    public:
        LexValue lex;
        vector<shared_ptr<AstNode>> children;

        //Constructor - create only node without child
        AstNode(int number, TkType token_tp, TkValue value);

        //Destructor - free entire tree
        ~AstNode();

        //Function to add child
        void add_child(AstNode *node);

        //Function to print the tree
        void print_tree(shared_ptr<AstNode> tree);

        //Function to export the tree
        void exporta(AstNode *tree);

        //Convert labels into string
        string to_string(void);
};

//Smart pointer for the tree
typedef shared_ptr<AstNode> smart_node;