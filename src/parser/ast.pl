:- module(ast, [ast/1]).

ast(int(I)) :- integer(I).
ast(real(R)) :- float(R).
ast(sum(A, B)) :- ast(A), ast(B).
ast(sub(A, B)) :- ast(A), ast(B).
ast(mul(A, B)) :- ast(A), ast(B).
ast(div(A, B)) :- ast(A), ast(B).
ast(pow(A, B)) :- ast(A), ast(B).
ast(neg(A))    :- ast(A).
ast(pos(A))    :- ast(A).