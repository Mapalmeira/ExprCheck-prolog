:- module(lexer_tests, [run_lexer_tests/0]).
:- use_module('../src/lexer/lexer').
:- encoding(utf8).
:- use_module('unit_test').

valid_input("", [tok_eof]).
valid_input("0", [tok_int(0), tok_eof]).
valid_input("42", [tok_int(42), tok_eof]).
valid_input("3.14", [tok_real(3.14), tok_eof]).
valid_input("0.001", [tok_real(0.001), tok_eof]).
valid_input("1+2", [tok_int(1), tok_plus, tok_int(2), tok_eof]).
valid_input("1 + 2", [tok_int(1), tok_plus, tok_int(2), tok_eof]).
valid_input("  1   +    2  ", [tok_int(1), tok_plus, tok_int(2), tok_eof]).
valid_input("1-2", [tok_int(1), tok_minus, tok_int(2), tok_eof]).
valid_input("1 * 2", [tok_int(1), tok_star, tok_int(2), tok_eof]).
valid_input("1/2", [tok_int(1), tok_slash, tok_int(2), tok_eof]).
valid_input("2^3", [tok_int(2), tok_caret, tok_int(3), tok_eof]).
valid_input("2^3^4", [tok_int(2), tok_caret, tok_int(3), tok_caret, tok_int(4), tok_eof]).
valid_input("(1)", [tok_lparen, tok_int(1), tok_rparen, tok_eof]).
valid_input("((1))", [tok_lparen, tok_lparen, tok_int(1), tok_rparen, tok_rparen, tok_eof]).
valid_input("(1 + 2)", [tok_lparen, tok_int(1), tok_plus, tok_int(2), tok_rparen, tok_eof]).
valid_input("(1 + 2) * 3", [tok_lparen, tok_int(1), tok_plus, tok_int(2), tok_rparen, tok_star, tok_int(3), tok_eof]).
valid_input("1 + (2 * 3)", [tok_int(1), tok_plus, tok_lparen, tok_int(2), tok_star, tok_int(3), tok_rparen, tok_eof]).
valid_input("(1 + 2 * 3", [tok_lparen, tok_int(1), tok_plus, tok_int(2), tok_star, tok_int(3), tok_eof]).
valid_input("1 + 2)", [tok_int(1), tok_plus, tok_int(2), tok_rparen, tok_eof]).
valid_input("()", [tok_lparen, tok_rparen, tok_eof]).
valid_input("( )", [tok_lparen, tok_rparen, tok_eof]).
valid_input("((()))", [tok_lparen, tok_lparen, tok_lparen, tok_rparen, tok_rparen, tok_rparen, tok_eof]).
valid_input("1 + -2", [tok_int(1), tok_plus, tok_minus, tok_int(2), tok_eof]).
valid_input("-1 + 2", [tok_minus, tok_int(1), tok_plus, tok_int(2), tok_eof]).
valid_input("+1", [tok_plus, tok_int(1), tok_eof]).
valid_input("+1.5", [tok_plus, tok_real(1.5), tok_eof]).
valid_input("-3.5", [tok_minus, tok_real(3.5), tok_eof]).
valid_input("1+-2", [tok_int(1), tok_plus, tok_minus, tok_int(2), tok_eof]).
valid_input("1--2", [tok_int(1), tok_minus, tok_minus, tok_int(2), tok_eof]).
valid_input("1++2", [tok_int(1), tok_plus, tok_plus, tok_int(2), tok_eof]).
valid_input("1**2", [tok_int(1), tok_star, tok_star, tok_int(2), tok_eof]).
valid_input("1//2", [tok_int(1), tok_slash, tok_slash, tok_int(2), tok_eof]).
valid_input("1^^2", [tok_int(1), tok_caret, tok_caret, tok_int(2), tok_eof]).

invalid_input(".", lexer_error("Caractere inválido", ".")).
invalid_input("..", lexer_error("Caractere inválido", ".")).
invalid_input("...", lexer_error("Caractere inválido", ".")).
invalid_input(".1", lexer_error("Caractere inválido", ".")).
invalid_input("1.", lexer_error("Número real mal formado (esperava-se números após o ponto)", "1.")).
invalid_input("1..", lexer_error("Número real mal formado (esperava-se números após o ponto)", "1.")).
invalid_input("1.2.3", lexer_error("Número real mal formado (múltiplos pontos)", "1.2.")).
invalid_input("00.1.2", lexer_error("Número real mal formado (múltiplos pontos)", "00.1.")).
invalid_input("1 + a", lexer_error("Caractere inválido", "a")).
invalid_input("a + 1", lexer_error("Caractere inválido", "a")).
invalid_input("1 + A", lexer_error("Caractere inválido", "A")).
invalid_input("x", lexer_error("Caractere inválido", "x")).
invalid_input("@", lexer_error("Caractere inválido", "@")).
invalid_input("#", lexer_error("Caractere inválido", "#")).
invalid_input("$", lexer_error("Caractere inválido", "$")).
invalid_input("%", lexer_error("Caractere inválido", "%")).
invalid_input("&", lexer_error("Caractere inválido", "&")).
invalid_input("!", lexer_error("Caractere inválido", "!")).
invalid_input("? ", lexer_error("Caractere inválido", "?")).
invalid_input("1 + @", lexer_error("Caractere inválido", "@")).
invalid_input("2 & 3", lexer_error("Caractere inválido", "&")).
invalid_input("4 | 5", lexer_error("Caractere inválido", "|")).
invalid_input("6 ~ 7", lexer_error("Caractere inválido", "~")).
invalid_input("8 = 9", lexer_error("Caractere inválido", "=")).
invalid_input("10 , 11", lexer_error("Caractere inválido", ",")).
invalid_input("12 ; 13", lexer_error("Caractere inválido", ";")).
invalid_input("14 : 15", lexer_error("Caractere inválido", ":")).
invalid_input("16 _ 17", lexer_error("Caractere inválido", "_")).
invalid_input("18 ` 19", lexer_error("Caractere inválido", "`")).

valid_input_test(Input, Expected, Result) :- lexer:lexer_string(Input, Tokens),
    assert_equals(Expected, Tokens, Result).

invalid_input_test(Input, ExpectedError, Result) :-
    assert_throws(
        lexer:lexer_string(Input, _),
        ExpectedError,
        Result
    ).

test(Name, lexer_tests:valid_input_test(Input, Expected)) :-
    valid_input(Input, Expected),
    format(atom(Name), "teste (entrada válida): ~q", [Input]).

test(Name, lexer_tests:invalid_input_test(Input, Expected)) :-
    invalid_input(Input, Expected),
    format(atom(Name), "teste (entrada inválida) ~q", [Input]).

run_lexer_tests :- run_suite(lexer_tests), !.