:- use_module(lexer/token).

main :-
    show_token(tok_int(42), T1),
    show_token(tok_plus, T2),
    show_token(tok_real(3.14), T3),
    write(T1),
    write(T2),
    writeln(T3),
    halt.

:- initialization(main).