#include "SymbolTable.h"
#include <stdio.h>
#include <string.h>

// Initialize the symbol table
void initSymbolTable(SymbolTable *table) {
    table->count = 0;
}

// Add a variable to the symbol table
void addVariable(SymbolTable *table, const char *name, double value) {
    if (table->count < MAX_SYMBOLS) {
        SymbolEntry *entry = &(table->entries[table->count]);
        entry->name = strdup(name);
        entry->value = value;
        table->count++;
    } else {
        printf("Error: Symbol table overflow\n");
    }
}

// Look up a variable in the symbol table
double getVariableValue(SymbolTable *table, const char *name) {
    for (int i = 0; i < table->count; i++) {
        if (strcmp(table->entries[i].name, name) == 0) {
            return table->entries[i].value;
        }
    }
    printf("Error: Variable %s not found\n", name);
    return 0.0; // Default value if variable not found
}
