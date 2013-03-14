grammar DirkExp;
 
options {
    output=AST;  
    ASTLabelType=CommonTree;  
    language=Java;  
}
 
tokens
{
    INDEX;
    MEMBERACCESS;
    CALL;
    VARIABLE;
    BRACKETEXP;
}
 
expr
    :   logicalOrExpr
    ;
 
logicalOrExpr 
    :   logicalAndExpr (OR logicalAndExpr)* 
    ;
                         
logicalAndExpr
    :   equalityExpr (AND equalityExpr)*  
    ;   
                          
equalityExpr
    :   relationalExpr ((EQUALS|NOTEQUALS)^ relationalExpr)*
    ;
     
relationalExpr
    :   additiveExpr ((LT|LTEQ|GT|GTEQ)^ additiveExpr)? 
    ;
   
additiveExpr
    :   multiplyExpr ((PLUS|MINUS)^ multiplyExpr)*
    ;
 
multiplyExpr
    :   powExpr ((MUL| DIV | MOD)^ powExpr)* 
    ;
    
powExpr
    :   unaryExpr (POWER unaryExpr)? 
    ;   
 
unaryExpr
    :   (PLUS | MINUS | NOT) unaryExpr    
    |   memberExpr 
    ;
        
memberExpr
    :   basicExpr // (memberAccessExpr)* (indexerExpr)?
    ;
 
basicExpr
    :    parenExpr | literal |  memberFunctionExpr;     
        
parenExpr 
    :   LPAREN expr  RPAREN  -> ^(BRACKETEXP expr)
    ; 
     
literal 
    :   numbericLiteral
    |   stringLiteral 
    ;   
     
numbericLiteral
    :   INTEGER_LITERAL 
    |   DECIMAL_LITERAL 
    |   DATETIME_LITERAL
    ;
    
stringLiteral
    :   STRING_LITERAL
    |	variableExpr  
    ;
     
/*     
memberAccessExpr
    :   '.' memberFunctionExpr -> ^(MEMBERACCESS memberFunctionExpr)
    ;
*/
 
memberFunctionExpr
    :   fieldPropertyExpr | methodExpr
    ;
     
fieldPropertyExpr
    :   IDENTIFIER
    ;   
    
methodExpr  
    :   IDENTIFIER LPAREN (argument (COMMA argument)*)? RPAREN -> ^(CALL IDENTIFIER argument*)
    ;
         
/* 
indexerExpr 
    :   LBRACE argument (COMMA argument)* RBRACE -> ^(INDEX argument+)
    ;
*/
     
argument 
    :   expr 
    ;   
 
variableExpr
	: 	LBRACKET IDENTIFIER RBRACKET -> ^(VARIABLE IDENTIFIER)
	;
   
AND 
    :   'and'
    ;
     
OR  
    :   'or'
    ;
 
NOT 
    :   'not'
    ;
 
COMMA   
    :   ',' 
    ;
 
PLUS    
    :   '+' 
    ;
     
MINUS   
    :   '-'
    ;
     
MUL 
    :   '*' 
    ;
     
DIV 
    :   '/' 
    ;
     
MOD 
    :   '%'
    ;
     
POWER   
    :   '^'
    ;
     
EQUALS  :   '=';
     
NOTEQUALS 
    :   '!=' | '<>';
     
LT  :   '<';
LTEQ    :   '<=';
GT  :   '>';
GTEQ    :   '>=';
 
LPAREN
    :   '('
    ;
     
RPAREN  :   ')'
    ;

LBRACE	:	'{'
	;
	
RBRACE	:	'}'
	;

//PARAM	:	LBRACKET! (IDENTIFIER) RBRACKET!;

LBRACKET
    :   '['
    ;
 
RBRACKET
    :   ']'
    ;
     
DATETIME_LITERAL
    :   '\'' STRING_LITERAL '\''
    ;
 
STRING_LITERAL  
    :   '"' (~('"'|'['|']'))* '"'
    ;
 
IDENTIFIER
    :   LETTER (LETTER|Digit)*
    ;
     
fragment LETTER  
    :   'A'..'Z'|'a'..'z'|'_'
    ;
 
DECIMAL_LITERAL
    :   (INTEGER_LITERAL)? '.' Digit* Exponent? 
    ;
 
fragment Exponent 
    :   ('e'|'E') INTEGER_LITERAL
    ;
 
INTEGER_LITERAL 
    :   Digit+ 
    ;   
 
fragment Digit   
    :   '0'..'9'
    ;
 
/* Ignore white spaces */  
WS  
    :  (' '|'\r'|'\t'|'\u000C'|'\n') {$channel=HIDDEN;}
    ;
