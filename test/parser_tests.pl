:- module(parser_tests, [run_parser_tests/0]).
:- use_module('../src/lexer/lexer').
:- use_module('../src/parser/parser').
:- use_module('unit_test').            
:- encoding(utf8).


valid_syntax("1 + 2 * 3", sum(int(1), mul(int(2), int(3)))).
valid_syntax("(3 + 2) * 7", mul(sum(int(3), int(2)), int(7))).
valid_syntax("12.3 + 4.56", sum(real(12.3), real(4.56))).
valid_syntax("5 ^ -2", pow(int(5), neg(int(2)))).
valid_syntax("5 ++ 5", sum(int(5), pos(int(5)))).
valid_syntax("2 ^ 3 ^ 2", pow(int(2), pow(int(3), int(2)))).
valid_syntax("10 - 5 - 2", sub(sub(int(10), int(5)), int(2))).
valid_syntax("10 / 2 * 5", mul(div(int(10), int(2)), int(5))).
valid_syntax("((42))", int(42)).
valid_syntax("-(5 + 2)", neg(sum(int(5), int(2)))).
invalid_input("(5 * 2", parser_error(missing("')'", [tok_eof]))).
invalid_input("1 + @", lexer_error("Caractere inválido", "@")).
invalid_input("()", parser_error(unexpected("um número ou '('", [tok_rparen, tok_eof]))).
invalid_input("5 + * 2", parser_error(unexpected("um número ou '('", [tok_star, tok_int(2), tok_eof]))).

valid_syntax_test(Input, ExpectedAST, Result) :-
    lexer:lexer_string(Input, Tokens),
    parser:parse(Tokens, AST),
    assert_equals(ExpectedAST, AST, Result).

invalid_input_test(Input, ExpectedError, Result) :-
    assert_throws(
        (lexer:lexer_string(Input, Tokens), parser:parse(Tokens, _)),
        ExpectedError,
        Result
    ).

test(Name, parser_tests:valid_syntax_test(In, Out)) :-
    valid_syntax(In, Out),
    format(atom(Name), "Aceito: ~s", [In]).

test(Name, parser_tests:invalid_input_test(In, Err)) :-
    invalid_input(In, Err),
    format(atom(Name), "Rejeitado: ~s", [In]).

run_parser_tests :- run_suite(parser_tests), !.