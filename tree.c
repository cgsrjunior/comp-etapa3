#include <stdio.h>
#include "tree.h"

struct Node* newNode(int data)
{
    // Allocate memory for new node
    struct Node* node = (struct Node*) malloc(sizeof(struct Node));
 
    // Assign data to this node
    node->value = data;
 
    // Initialize left and
    // right children as NULL
    node->left_child = NULL;
    node->right_child = NULL;
    return (node);
}