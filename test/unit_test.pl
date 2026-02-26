:- module(unit_test, [
    assert_equals/3, 
    assert_throws/3, 
    assert_true/2,
    run_tests/0,
    run_suite/1
]).
:- encoding(utf8).

assert_equals(Expected, Expected, ok).
assert_equals(Expected, Actual, show_error(Message)) :-
    format(string(Message), "\n      Esperava: ~q\n      Recebeu: ~q", [Expected, Actual]).

assert_true(true, ok).
assert_true(false, show_error("\n      Esperava verdadeiro (true)\n      Recebeu falso (fail)")).

assert_throws(Goal, Expected, Result) :-
    catch(Goal, Exception, true),
    analyze_exception(Exception, Expected, Result).

% a exceção esperada foi gerada
analyze_exception(ExpectedException, ExpectedException, ok) :- nonvar(ExpectedException).

% foi gerada uma exceção diferente da esperada
analyze_exception(Exception, ExpectedException, show_error(Message)) :-
    nonvar(Exception),
    format(string(Message), "\n      Esperava a exceção: ~q\n      Recebeu: ~q", [ExpectedException, Exception]).

% não foi gerada a exceção esperada
analyze_exception(Exception, ExpectedException, show_error(Message)) :-
    var(Exception),
    format(string(Message), "\n      Esperava a exceção: ~q\n      Nenhuma exceção foi lançada", [ExpectedException]).
    
run_test(test(Name, Goal), passed) :-
    call(Goal, ok),
    format("  ✓ ~w~n", [Name]).

run_test(test(Name, Goal), failed(Name, Message)) :-
    call(Goal, show_error(Message)),
    format("  ✗ ~w: ~w~n", [Name, Message]).

run_tests_list([], P, P, F, F).

run_tests_list([T|Rest], P0, P, F0, F) :-
    run_test(T, Result),
    update_counters(Result, P0, P1, F0, F1),
    run_tests_list(Rest, P1, P, F1, F).

update_counters(passed, P0, P, F0, F0) :-
    P is P0 + 1.

update_counters(failed(_, _), P0, P0, F0, F) :-
    F is F0 + 1.

run_tests :-
    format("=== Executando testes ===~n"),
    findall(test(N,G), test(N,G), Tests),
    length(Tests, Total),
    run_tests_list(Tests, 0, Passed, 0, Failed),
    format("---~n"),
    format("Total: ~w | Passou: ~w | Falhou: ~w~n", [Total, Passed, Failed]).

run_suite(Module) :-
    format("=== Suíte: ~w ===~n", [Module]),
    findall(test(N,G), Module:test(N,G), Tests),
    length(Tests, Total),
    run_tests_list(Tests, 0, Passed, 0, Failed),
    format("---~n"),
    format("Total: ~w | Passou: ~w | Falhou: ~w~n~n", [Total, Passed, Failed]).