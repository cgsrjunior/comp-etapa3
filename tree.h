typedef struct LexValue
{
    int line_number;
    char tk_type[30];
    int tk_value;

};


typedef struct Node
{
    int value;
    Node* left_child;
    Node* right_child;
} Tree;


struct Node* newNode(int data);