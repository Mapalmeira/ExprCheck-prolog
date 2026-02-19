:- module(lexer,
[
    lexer_string/2,
    raise_lexer_error/2,
    show_lexer_error/2
]).

% ERRO LÉXICO

raise_lexer_error(Msg, Occ) :-
    must_be(string, Msg),
    must_be(string, Occ),
    throw(error(lexer_error(Msg, Occ), _)).

show_lexer_error(lexer_error(Msg, Occ), Text) :-
    string_concat("Erro léxico: ", Msg, T1),
    string_concat(T1, ": ", T2),
    string_concat(T2, Occ, Text).

% WRAPPER STRING → LISTA DE CHARS

lexer_string(Str, Tokens) :-
    string_chars(Str, Chars),
    lexer(Chars, Tokens).

% LEXER PRINCIPAL — determinístico

lexer([], [tok_eof]).

lexer([C|Cs], Tokens) :-
    char_type(C, space),
    !,
    lexer(Cs, Tokens).

lexer([C|Cs], Tokens) :-
    char_type(C, digit),
    !,
    lexer_num([C|Cs], Tokens).

lexer([C|Cs], Tokens) :-
    lexer_symbol(C, Cs, Tokens).

% SÍMBOLOS

lexer_symbol('+', Cs, [tok_plus|T])   :- !, lexer(Cs, T).
lexer_symbol('-', Cs, [tok_minus|T])  :- !, lexer(Cs, T).
lexer_symbol('*', Cs, [tok_star|T])   :- !, lexer(Cs, T).
lexer_symbol('/', Cs, [tok_slash|T])  :- !, lexer(Cs, T).
lexer_symbol('^', Cs, [tok_caret|T])  :- !, lexer(Cs, T).
lexer_symbol('(', Cs, [tok_lparen|T]) :- !, lexer(Cs, T).
lexer_symbol(')', Cs, [tok_rparen|T]) :- !, lexer(Cs, T).

lexer_symbol(C, _, _) :-
    nonvar(C),
    string_chars(Str, [C]),
    raise_lexer_error("Caractere inválido encontrado", Str).

% NÚMEROS INTEIROS

lexer_num(Input, [Tok|RestTokens]) :-
    span_digits(Input, IntDigits, Rest),

    (   Rest = ['.'|AfterDot]
    ->  lexer_real_frac(IntDigits, AfterDot, Tok, Remaining)
    ;   number_from_chars(IntDigits, N),
        Tok = tok_int(N),
        Remaining = Rest
    ),
    lexer(Remaining, RestTokens).

% PARTE REAL


lexer_real_frac(IntDigits, AfterDot, Tok, Remaining) :-
    span_digits(AfterDot, FracDigits, Rest),

    (   FracDigits = []
    ->  append(IntDigits, ['.'], Bad),
        string_chars(Str, Bad),
        raise_lexer_error(
            "Número real mal formado (esperava-se números após o ponto)",
            Str
        )

    ;   Rest = ['.'|_]
    ->  append(IntDigits, ['.'], T1),
        append(T1, FracDigits, T2),
        append(T2, ['.'], Bad),
        string_chars(Str, Bad),
        raise_lexer_error(
            "Número real mal formado (múltiplos pontos)",
            Str
        )

    ;   append(IntDigits, ['.'], T1),
        append(T1, FracDigits, NumChars),
        number_from_chars(NumChars, Real),
        Tok = tok_real(Real),
        Remaining = Rest
    ).

% SPAN DIGITS 


span_digits([], [], []).

span_digits([C|Cs], [C|Ds], Rest) :-
    char_type(C, digit),
    !,
    span_digits(Cs, Ds, Rest).

span_digits(Rest, [], Rest).

% CONVERSÃO NUMÉRICA

number_from_chars(Chars, N) :-
    string_chars(Str, Chars),
    number_string(N, Str).
