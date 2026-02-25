:- module(cli, []).
:- use_module(lexer/lexer).
:- use_module(lexer/token).

:- encoding(utf8).
:- initialization(main).

main :-
    print_header,
    loop.

loop :-
    prompt("\nDigite a expressão a validar: ", Expr),
    choose_mode(Expr),
    ask_again(Continue),
    ( Continue = yes -> loop
    ; writeln("\nAté logo!")
    ).

choose_mode(Expr) :-
    writeln("\nSelecione o nível de verificação:"),
    writeln("A) Léxico"),
    writeln("B) Sintático"),
    prompt("Escolha (A/B): ", Raw),
    normalize_space(string(Clean), Raw),
    string_upper(Clean, Choice),
    execute_mode(Choice, Expr).

execute_mode("A", Expr) :-
    run_lexical(Expr).
execute_mode("B", _) :-
    writeln("\nTODO: Validação sintática ainda não implementada.").
execute_mode(_, _) :-
    writeln("\nOpção inválida.").

ask_again(Result) :-
    prompt("\nDeseja validar outra expressão? (Y/N): ", Raw),
    normalize_space(string(Clean), Raw),
    string_upper(Clean, Answer),
    ( Answer = "Y" -> Result = yes ; Result = no ).

run_lexical(Expr) :-
    writeln("\n[Validação Léxica]"),
    catch(
        ( once(lexer_string(Expr, Tokens)),
          writeln("VÁLIDO - Tokens"),
          print_tokens_tree(Tokens)
        ),
        Error,
        ( writeln("INVÁLIDO - Erro Léxico"),
          print_error(Error)
        )
    ).

print_tokens_tree([]).
print_tokens_tree([Last]) :-
    show_token(Last, Text),
    format("    └── ~w~n", [Text]).
print_tokens_tree([Tok|Rest]) :-
    show_token(Tok, Text),
    format("    ├── ~w~n", [Text]),
    print_tokens_tree(Rest).

print_error(Error) :-
    format("    ~w~n", [Error]).

print_header :-
    writeln("========================================================"),
    writeln("              === Bem-vindo ao ExprCheck ==="),
    writeln("========================================================").

prompt(Message, Input) :-
    write(Message),
    flush_output,
    read_line_to_string(user_input, Input).