/* =========================
   Hace la interacción:
   pregunta -> lee respuesta -> normaliza -> manda al BNF
   -> muestra arbol y semantica
   ========================= */

:- ['BD.pl', 'BNF.pl'].
:- use_module(library(readutil)).


/* iniciar
   arranca con una pregunta por defecto.
*/
iniciar :-
    hacer_pregunta(tecnologia).


/* hacer_pregunta
   recibe un tema, busca su pregunta en BD,
   lee la respuesta y la analiza con el BNF.
*/
hacer_pregunta(Tema) :-
    pregunta(Tema, TextoPregunta),
    nl,
    write('OrientadorCE: '), writeln(TextoPregunta),
    write('Usuario: '),
    read_line_to_string(user_input, Entrada),
    normalizar_entrada(Entrada, Tokens),
    (
        analizar_respuesta(Tema, Tokens, Arbol, Semantica)
        ->
        write('Arbol = '), writeln(Arbol),
        write('Semantica = '), writeln(Semantica)
        ;
        writeln('No pude interpretar la respuesta. Usa una frase natural como "me gusta la tecnologia" o "no me interesan las matematicas"; el sistema no acepta solo si/no.')
    ).


/* normalizar_entrada
   pasa la entrada a minusculas,
   quita tildes y signos básicos,
   y la convierte en lista de átomos.
*/
normalizar_entrada(Entrada, Tokens) :-
    string_lower(Entrada, EntradaMinuscula),
    string_chars(EntradaMinuscula, Caracteres),
    maplist(normalizar_caracter, Caracteres, CaracteresNormalizados),
    string_chars(EntradaLimpia, CaracteresNormalizados),
    split_string(EntradaLimpia, " ", " ", Partes),
    quitar_vacios(Partes, PartesLimpias),
    maplist(atom_string, Tokens, PartesLimpias).


/* quitar_vacios
   elimina strings vacíos de una lista.
*/
quitar_vacios([], []).
quitar_vacios([""|Resto], Resultado) :-
    quitar_vacios(Resto, Resultado).
quitar_vacios([X|Resto], [X|Resultado]) :-
    X \= "",
    quitar_vacios(Resto, Resultado).


/* normalizar_caracter
   reemplaza tildes y signos por versiones simples.
*/
normalizar_caracter('á', 'a').
normalizar_caracter('é', 'e').
normalizar_caracter('í', 'i').
normalizar_caracter('ó', 'o').
normalizar_caracter('ú', 'u').
normalizar_caracter('Á', 'a').
normalizar_caracter('É', 'e').
normalizar_caracter('Í', 'i').
normalizar_caracter('Ó', 'o').
normalizar_caracter('Ú', 'u').
normalizar_caracter('ñ', 'n').
normalizar_caracter('Ñ', 'n').

normalizar_caracter('.', ' ').
normalizar_caracter(',', ' ').
normalizar_caracter(';', ' ').
normalizar_caracter(':', ' ').
normalizar_caracter('!', ' ').
normalizar_caracter('¡', ' ').
normalizar_caracter('?', ' ').
normalizar_caracter('¿', ' ').
normalizar_caracter('"', ' ').
normalizar_caracter('(', ' ').
normalizar_caracter(')', ' ').

normalizar_caracter(Caracter, Caracter).
