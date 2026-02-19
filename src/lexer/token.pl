:- module(token, [token/1, show_token/2]).

token(tok_eof).
token(tok_lparen).
token(tok_rparen).
token(tok_star).
token(tok_slash).
token(tok_caret).
token(tok_plus).
token(tok_minus).
token(tok_int(X)) :- integer(X).
token(tok_real(X)) :- float(X).

show_token(tok_eof, "EOF").
show_token(tok_lparen, "(").
show_token(tok_rparen, ")").
show_token(tok_star, "*").
show_token(tok_slash, "/").
show_token(tok_caret, "^").
show_token(tok_plus, "+").
show_token(tok_minus, "-").
show_token(tok_int(X), Text) :- number_string(X, Text).
show_token(tok_real(X), Text) :- number_string(X, Text).