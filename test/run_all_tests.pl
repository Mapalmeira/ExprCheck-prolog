:- use_module(parser_tests).
:- use_module(lexer_tests).
:- use_module(unit_test).

run_all_tests :-
    unit_test:run_suite(parser_tests),
    unit_test:run_suite(lexer_tests).