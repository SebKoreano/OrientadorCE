/* =========================
    Hace la interaccion completa:
    preguntas secuenciales -> parser -> acumulacion
    -> puntuacion -> recomendacion final
   ========================= */

:- ['BD.pl', 'BNF.pl'].
:- use_module(library(readutil)).
:- dynamic(respuesta_semantica/1).


/* iniciar
    punto de entrada principal.
*/
iniciar :-
     orientar.


/* orientar
    ejecuta la sesion completa de preguntas y recomendacion.
*/
orientar :-
     limpiar_sesion,
     temas_orientacion(Temas),
     nl,
     writeln('=== Bienvenido a OrientadorCE ==='),
     writeln('Responde con frases naturales como "me gusta la tecnologia" o "no me gusta la rutina".'),
     preguntar_temas(Temas),
     mostrar_resultado_final.


/* limpiar_sesion
    borra respuestas previas para una nueva corrida.
*/
limpiar_sesion :-
     retractall(respuesta_semantica(_)).


/* temas_orientacion
    obtiene todos los temas preguntables directamente desde BD.pl,
    sin lista hardcodeada. Cualquier cambio en BD se refleja automaticamente.
*/
temas_orientacion(Temas) :-
    findall(T, pregunta(T, _), Temas).


/* preguntar_temas
    recorre todos los temas y acumula semanticas validas.
*/
preguntar_temas([]).
preguntar_temas([Tema|Resto]) :-
     hacer_pregunta_con_reintentos(Tema, 2, Resultado),
     (
          Resultado = ok(Semantica)
          ->
          assertz(respuesta_semantica(Semantica))
          ;
          true
     ),
     preguntar_temas(Resto).


/* hacer_pregunta/2
    devuelve ok(Semantica) o error_parseo.
*/
hacer_pregunta(Tema, Resultado) :-
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
        write('Semantica = '), writeln(Semantica),
        Resultado = ok(Semantica)
        ;
        writeln('No pude interpretar la respuesta. Usa una frase natural como "me gusta la tecnologia" o "no me interesan las matematicas"; el sistema no acepta solo si/no.'),
        Resultado = error_parseo
    ).


/* hacer_pregunta_con_reintentos
   reintenta parsear hasta MaxReintentos veces.
*/
hacer_pregunta_con_reintentos(Tema, MaxReintentos, Resultado) :-
    hacer_pregunta(Tema, PrimerIntento),
    resolver_reintentos(Tema, MaxReintentos, PrimerIntento, Resultado).

resolver_reintentos(_Tema, _IntentosRestantes, ok(Semantica), ok(Semantica)).
resolver_reintentos(Tema, IntentosRestantes, error_parseo, Resultado) :-
    (
        IntentosRestantes > 0
        ->
        NuevoIntento is IntentosRestantes - 1,
        writeln('Intentemos de nuevo con otra frase...'),
        hacer_pregunta(Tema, SiguienteIntento),
        resolver_reintentos(Tema, NuevoIntento, SiguienteIntento, Resultado)
        ;
        writeln('Pasaremos a la siguiente pregunta.'),
        Resultado = omitida
    ).


/* mostrar_resultado_final
   calcula y muestra la mejor recomendacion.
*/
mostrar_resultado_final :-
    findall(R, respuesta_semantica(R), Respuestas),
    (
        Respuestas = []
        ->
        nl,
        writeln('No se pudo construir una recomendacion porque no hubo respuestas interpretables.')
        ;
        calcular_ranking(Respuestas, Ranking),
        mostrar_recomendacion(Ranking)
    ).


/* calcular_ranking
   genera puntajes por carrera y los ordena de mayor a menor.
*/
calcular_ranking(Respuestas, RankingOrdenado) :-
    findall(
        puntaje(CarreraId, NombreCarrera, Puntaje),
        (
            carrera(CarreraId, NombreCarrera),
            puntaje_carrera(CarreraId, Respuestas, Puntaje)
        ),
        Ranking
    ),
    predsort(comparar_puntajes, Ranking, RankingOrdenado).

comparar_puntajes(Orden, puntaje(_, _, P1), puntaje(_, _, P2)) :-
    compare(Orden, P2, P1).


/* puntaje_carrera
   suma aportes de cada respuesta semantica para una carrera.
*/
puntaje_carrera(_CarreraId, [], 0).
puntaje_carrera(CarreraId, [Semantica|Resto], PuntajeTotal) :-
    aporte_semantica(CarreraId, Semantica, AporteActual),
    puntaje_carrera(CarreraId, Resto, PuntajeResto),
    PuntajeTotal is AporteActual + PuntajeResto.


/* aporte_semantica
   reglas basicas:
   - afinidad/fortaleza positiva suma, negativa resta
   - antagonia positiva resta, negativa suma
*/
aporte_semantica(CarreraId, semantica(_, Intencion, referente(Referente), _), Aporte) :-
    aporte_afinidad(CarreraId, Referente, Intencion, A1),
    aporte_fortaleza(CarreraId, Referente, Intencion, A2),
    aporte_antagonia(CarreraId, Referente, Intencion, A3),
    Aporte is A1 + A2 + A3.

aporte_afinidad(CarreraId, Referente, Intencion, Aporte) :-
    (
        afinidad(Referente, CarreraId)
        -> aporte_por_tipo(afinidad, Intencion, Aporte)
        ; Aporte = 0
    ).

aporte_fortaleza(CarreraId, Referente, Intencion, Aporte) :-
    (
        fortaleza(Referente, CarreraId)
        -> aporte_por_tipo(fortaleza, Intencion, Aporte)
        ; Aporte = 0
    ).

aporte_antagonia(CarreraId, Referente, Intencion, Aporte) :-
    (
        antagonia(Referente, CarreraId)
        -> aporte_por_tipo(antagonia, Intencion, Aporte)
        ; Aporte = 0
    ).

aporte_por_tipo(afinidad, positiva, 2).
aporte_por_tipo(afinidad, negativa, -1).
aporte_por_tipo(fortaleza, positiva, 2).
aporte_por_tipo(fortaleza, negativa, -1).
aporte_por_tipo(antagonia, positiva, -2).
aporte_por_tipo(antagonia, negativa, 1).


/* mostrar_recomendacion
   imprime recomendacion principal y top 3.
*/
mostrar_recomendacion([puntaje(_, MejorNombre, MejorPuntaje)|Resto]) :-
    nl,
    writeln('=== Resultado final ==='),
    format('Dadas tus preferencias te recomendaria estudiar ~w.~n', [MejorNombre]),
    format('Puntaje obtenido: ~w~n', [MejorPuntaje]),
    mostrar_top_3(Resto, 2).

mostrar_top_3([], _).
mostrar_top_3(_, Posicion) :-
    Posicion > 3,
    !.
mostrar_top_3([puntaje(_, Nombre, Puntaje)|Resto], Posicion) :-
    format('Alternativa ~w: ~w (puntaje ~w)~n', [Posicion, Nombre, Puntaje]),
    Siguiente is Posicion + 1,
    mostrar_top_3(Resto, Siguiente).


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