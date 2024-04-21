// Define a structure to represent a symbol table entry
typedef struct {
    char *name;
    double value;
} SymbolEntry;

// Define a structure to represent the symbol table
#define MAX_SYMBOLS 100
typedef struct {
    SymbolEntry entries[MAX_SYMBOLS];
    int count;
} SymbolTable;

// Function prototypes
void initSymbolTable(SymbolTable *table);
void addVariable(SymbolTable *table, const char *name, double value);
double getVariableValue(SymbolTable *table, const char *name);
