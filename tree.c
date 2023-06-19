#include <stdio.h>

struct Node* newNode(int data)
{
    // Allocate memory for new node
    struct Node* node = (struct node*) malloc(sizeof(struct node));
 
    // Assign data to this node
    node->data = data;
 
    // Initialize left and
    // right children as NULL
    node->left = NULL;
    node->right = NULL;
    return (node);
}