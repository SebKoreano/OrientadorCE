/* interpretar_respuesta(+PreguntaActual, +Tokens, -Arbol, -Semantica)
   PreguntaActual sirve para respuestas cortas como [no,mucho]
   donde el tema no viene explícito en la oración.
*/

interpretar_respuesta(PreguntaActual, Tokens, Arbol, respuesta(Intencion, TemaFinal)) :-
    phrase(oracion(Arbol, respuesta(Intencion, TemaParcial)), Tokens),
    ajustar_tema(PreguntaActual, TemaParcial, TemaFinal).

ajustar_tema(PreguntaActual, indefinido, PreguntaActual).
ajustar_tema(_, Tema, Tema).


/* ========= Gramática principal ========= */

oracion(oracion(SN, SV), Semantica) -->
    sintagma_nominal(SN),
    sintagma_verbal(SV, Semantica).

oracion(oracion(elidido, SV), Semantica) -->
    sintagma_verbal(SV, Semantica).


/* ========= Sintagma nominal ========= */

sintagma_nominal(sn(pronombre(yo))) --> [yo].
sintagma_nominal(sn(pronombre(yo), reflexivo(me))) --> [yo, me].


/* ========= Sintagma verbal ========= */

sintagma_verbal(sv(gusto(Pos), Obj), respuesta(Pos, Tema)) -->
    verbo_gusto(Pos),
    objeto(Tema, Obj).

sintagma_verbal(sv(habilidad(afirmativa), Obj), respuesta(afirmativa, tecnologia)) -->
    verbo_copulativo,
    intensificador_opcional,
    [habil],
    [con],
    objeto_tecnologia(Obj).

sintagma_verbal(sv(interes(afirmativa), Obj), respuesta(afirmativa, personas)) -->
    [me],
    verbo_interes_positivo,
    intensificador_opcional,
    [por],
    objeto_personas(Obj).

sintagma_verbal(sv(disfrute(afirmativa), Acc), respuesta(afirmativa, Tema)) -->
    afirmacion_breve_opcional,
    verbo_disfrute_positivo,
    intensificador_opcional,
    [de],
    accion(Tema, Acc).

sintagma_verbal(sv(preferencia(Modo)), respuesta(afirmativa, Tema)) -->
    verbo_preferencia,
    modo_conversacion(Tema, Modo).

sintagma_verbal(sv(corta(Intencion)), respuesta(Intencion, indefinido)) -->
    respuesta_corta(Intencion).


/* ========= Verbos ========= */

verbo_gusto(afirmativa) --> [amo].
verbo_gusto(afirmativa) --> [adoro].
verbo_gusto(afirmativa) --> [me, gusta].
verbo_gusto(afirmativa) --> [me, encanta].

verbo_gusto(negativa) --> [odio].
verbo_gusto(negativa) --> [detesto].
verbo_gusto(negativa) --> [no, me, gusta].

verbo_copulativo --> [soy].

verbo_interes_positivo --> [intereso].
verbo_interes_positivo --> [interesa].

verbo_disfrute_positivo --> [disfruto].

verbo_preferencia --> [prefiero].


/* ========= Objetos ========= */

objeto(matematicas, obj(matematicas)) -->
    determinante_opcional,
    [matematicas].

objeto(tecnologia, Obj) -->
    objeto_tecnologia(Obj).

objeto(personas, Obj) -->
    objeto_personas(Obj).

objeto_tecnologia(obj(tecnologia)) -->
    determinante_opcional,
    [tecnologia].

objeto_tecnologia(obj(computadoras)) -->
    determinante_opcional,
    [computadoras].

objeto_tecnologia(obj(computador)) -->
    determinante_opcional,
    [computador].

objeto_personas(obj(personas)) -->
    determinante_opcional,
    [personas].


/* ========= Acciones ========= */

accion(problemas, accion(resolver, problemas)) --> [resolver, problemas].
accion(problemas, accion(resolver, problemas)) --> [resolver, los, problemas].
accion(escuchar, accion(escuchar)) --> [escuchar].
accion(hablar, accion(hablar)) --> [hablar].

modo_conversacion(escuchar, escuchar) --> [escuchar].
modo_conversacion(hablar, hablar) --> [hablar].


/* ========= Respuestas cortas ========= */

respuesta_corta(afirmativa) --> [si].
respuesta_corta(afirmativa) --> [si, mucho].
respuesta_corta(negativa) --> [no].
respuesta_corta(negativa) --> [no, mucho].

afirmacion_breve_opcional --> [].
afirmacion_breve_opcional --> [si].

intensificador_opcional --> [].
intensificador_opcional --> [muy].
intensificador_opcional --> [mucho].

determinante_opcional --> [].
determinante_opcional --> [la].
determinante_opcional --> [las].
determinante_opcional --> [el].
determinante_opcional --> [los].