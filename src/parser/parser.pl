:- module(parser, [parse/2]).
:- use_module('../lexer/token').
:- use_module(ast).

parse(Tokens, AST) :-
    phrase(parse_sum(AST), Tokens, [tok_eof]).

% Soma
parse_sum(AST) --> parse_mul(Left), sum_builder(Left, AST).

sum_builder(Left, AST) --> [tok_plus],  parse_mul(Right), {Next = sum(Left, Right)}, sum_builder(Next, AST).
sum_builder(Left, AST) --> [tok_minus], parse_mul(Right), {Next = sub(Left, Right)}, sum_builder(Next, AST).
sum_builder(AST, AST)  --> [].

% Multiplicação
parse_mul(AST) --> parse_pow(Left), mul_builder(Left, AST).

mul_builder(Left, AST) --> [tok_star],  parse_pow(Right), {Next = mul(Left, Right)}, mul_builder(Next, AST).
mul_builder(Left, AST) --> [tok_slash], parse_pow(Right), {Next = div(Left, Right)}, mul_builder(Next, AST).
mul_builder(AST, AST)  --> [].

% Exponenciação
parse_pow(AST) --> parse_unary(Left), pow_builder(Left, AST).

pow_builder(Left, pow(Left, Right)) --> [tok_caret], parse_pow(Right).
pow_builder(AST, AST)                    --> [].

% Unário
parse_unary(neg(AST)) --> [tok_minus], parse_primary(AST).
parse_unary(pos(AST)) --> [tok_plus],  parse_primary(AST).
parse_unary(AST)           --> parse_primary(AST).

% Primário
parse_primary(int(N))  --> [tok_int(N)].
parse_primary(real(R)) --> [tok_real(R)].
parse_primary(AST)          --> [tok_lparen], parse_sum(AST), [tok_rparen].