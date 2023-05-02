%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int yylex();
void yyerror(const char *s);
extern FILE *yyin;
%}

%token ARTICLE NOUN VERB PREP EOL

%%

sentences: sentence	{printf("PASS\n");}
    | sentences EOL sentences
    | sentences EOL
;

sentence: nounphrase verbphrase		
;

nounphrase: cmplxnoun
    | cmplxnoun prepphrase
;

verbphrase: cmplxverb
    | cmplxverb prepphrase
;

prepphrase: PREP cmplxnoun
;

cmplxnoun: ARTICLE NOUN
;

cmplxverb: VERB
    | VERB nounphrase
;

%%

int main(int argc, char **argv){
    if (argc != 2){
        fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
        exit(1);
    }
    
    FILE *input = fopen(argv[1],"r");
    if (!input){
        perror("fopen");
        exit(1);
    }
    yyin = input;
    yyparse();
    fclose(input);
    return 0;
}

void yyerror(const char *s){
    printf("FAIL\n");
}

