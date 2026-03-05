:- module(main, []).
:- use_module(lexer/lexer).
:- use_module(lexer/token).
:- use_module(parser/parser).

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
execute_mode("B", Expr) :-
    run_syntactic(Expr).
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

run_syntactic(Expr) :-
    catch(
        ( once(lexer_string(Expr, Tokens)),
          writeln("\n[Validação Léxica]"),
          writeln("VÁLIDO - Tokens"),
          print_tokens_tree(Tokens),
          
          once(parse(Tokens, AST)),
          writeln("\n[Validação Sintática]"),
          writeln("VÁLIDO - Árvore Sintática (AST)"),
          print_ast_tree("", true, AST)
        ),
        Error,
        ( writeln("\nINVÁLIDO - Erro"),
          print_error(Error)
        )
    ).

print_ast_tree(Prefix, IsLast, AST) :-
    get_label(AST, Label),
    get_branch(IsLast, Branch),
    format("~s~s~w~n", [Prefix, Branch, Label]),
    get_indent(IsLast, Indent),
    string_concat(Prefix, Indent, NewPrefix),
    ( get_children(AST, Children) ->
        print_children(NewPrefix, Children)
    ; true
    ).

print_children(_, []).
print_children(Prefix, [Child]) :-
    print_ast_tree(Prefix, true, Child), !.
print_children(Prefix, [H|T]) :-
    print_ast_tree(Prefix, false, H),
    print_children(Prefix, T).

get_branch(true, "└── ").
get_branch(false, "├── ").

get_indent(true, "    ").
get_indent(false, "│   ").

get_label(sum(_, _), "Sum (+)").
get_label(sub(_, _), "Sub (-)").
get_label(mul(_, _), "Mul (*)").
get_label(div(_, _), "Div (/)").
get_label(pow(_, _), "Pow (^)").
get_label(neg(_), "Neg (-)").
get_label(pos(_), "Pos (+)").
get_label(int(N), Label) :- format(string(Label), "IntVal ~w", [N]).
get_label(real(R), Label) :- format(string(Label), "RealVal ~w", [R]).

get_children(sum(L, R), [L, R]).
get_children(sub(L, R), [L, R]).
get_children(mul(L, R), [L, R]).
get_children(div(L, R), [L, R]).
get_children(pow(L, R), [L, R]).
get_children(neg(E), [E]).
get_children(pos(E), [E]).

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
    writeln("            === Bem-vindo ao ExprCheck ==="),
    writeln("========================================================").

prompt(Message, Input) :-
    write(Message),
    flush_output,
    read_line_to_string(user_input, Input).