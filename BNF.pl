/* =========================
   BNF del orientador vocacional
   - reconoce oraciones en lenguaje natural
   - identifica sintagmas nominales y verbales
   - infiere intencion afirmativa o negativa
   - genera una reformulacion canonica en espanol
   ========================= */


/* analizar_respuesta
   Punto de entrada esperado por Logic.pl
*/
analizar_respuesta(Tema, Tokens, Arbol, Semantica) :-
    phrase(oracion(Tema, Arbol, Datos), Tokens),
    construir_semantica(Tema, Datos, Semantica).


/* =========================
   Reglas de alto nivel
   ========================= */

oracion(Tema, oracion(SN, SV), datos(Intencion, Referente, Texto)) -->
    sintagma_nominal(SN, yo),
    sintagma_verbal(Tema, SV, Intencion, Referente, Texto).

oracion(Tema, oracion_eliptica(Locucion), datos(Intencion, Tema, Texto)) -->
    locucion_respuesta(Locucion, Intencion),
    { tema_por_defecto(Tema, Texto) }.


/* =========================
   Sintagma nominal
   ========================= */

sintagma_nominal(sn_eliptico(pronombre(yo)), yo) --> [].
sintagma_nominal(sn(pronombre(Token)), yo) -->
    pronombre_sujeto(Token).

pronombre_sujeto(Token) -->
    [Token],
    { lex_pronombre_sujeto(Token) }.


/* =========================
   Sintagma verbal
   ========================= */

sintagma_verbal(Tema, sv(Neg, Pron, Verbo, Intensificador, Complemento), Intencion, Referente, Texto) -->
    negacion_opcional(Neg, Negacion),
    pronombre_objeto(Pron),
    verbo_gusto(Verbo, PolaridadBase),
    intensificador_opcional(Intensificador),
    complemento_opcional(Tema, Complemento, Referente, Texto),
    { resolver_intencion(Negacion, PolaridadBase, Intencion) }.

sintagma_verbal(Tema, sv(Neg, Verbo, Intensificador, Complemento), Intencion, Referente, Texto) -->
    negacion_opcional(Neg, Negacion),
    verbo_preferencia(Verbo, PolaridadBase),
    intensificador_opcional(Intensificador),
    complemento_opcional(Tema, Complemento, Referente, Texto),
    { resolver_intencion(Negacion, PolaridadBase, Intencion) }.


/* =========================
   Componentes del SV
   ========================= */

negacion_opcional(negacion(no), invertida) --> [no].
negacion_opcional(sin_negacion, directa) --> [].

pronombre_objeto(pronombre_objeto(Token)) -->
    [Token],
    { lex_pronombre_objeto(Token) }.

verbo_gusto(verbo(Token, Polaridad), Polaridad) -->
    [Token],
    { lex_verbo_gusto(Token, Polaridad) }.

verbo_preferencia(verbo(Token, Polaridad), Polaridad) -->
    [Token],
    { lex_verbo_preferencia(Token, Polaridad) }.

intensificador_opcional(intensificador(Token)) -->
    [Token],
    { lex_intensificador(Token) }.
intensificador_opcional(sin_intensificador) --> [].


/* =========================
   Complementos
   ========================= */

complemento_opcional(_Tema, complemento(Objeto), Referente, Texto) -->
    objeto(Objeto, Referente, Texto).
complemento_opcional(Tema, complemento_implicito(tema(Tema)), Tema, Texto) -->
    [],
    { tema_por_defecto(Tema, Texto) }.

objeto(sn_objeto(Det, Nombre), Referente, Texto) -->
    determinante_opcional(Det),
    nombre_tema(Nombre, Referente, Texto).

objeto(frase_verbal_nominalizada(Actividad), Referente, Texto) -->
    actividad(Actividad, Referente, Texto).

determinante_opcional(determinante(Token)) -->
    [Token],
    { lex_determinante(Token) }.
determinante_opcional(sin_determinante) --> [].

nombre_tema(nombre(Token), tecnologia, 'la tecnologia') -->
    [Token],
    { lex_nombre_tema(Token, tecnologia) }.
nombre_tema(nombre(Token), matematicas, 'las matematicas') -->
    [Token],
    { lex_nombre_tema(Token, matematicas) }.
nombre_tema(nombre(Token), personas, 'las personas') -->
    [Token],
    { lex_nombre_tema(Token, personas) }.
nombre_tema(nombre(Token), problemas, 'los problemas') -->
    [Token],
    { lex_nombre_tema(Token, problemas) }.

actividad(actividad(verbo_infinitivo(escuchar), Complemento), escuchar, Texto) -->
    [escuchar],
    complemento_escuchar_opcional(Complemento),
    { construir_texto_actividad(escuchar, Complemento, Texto) }.

actividad(actividad(verbo_infinitivo(hablar), Complemento), hablar, Texto) -->
    [hablar],
    complemento_hablar_opcional(Complemento),
    { construir_texto_actividad(hablar, Complemento, Texto) }.

actividad(actividad(verbo_infinitivo(resolver), nombre(problemas)), problemas, 'resolver problemas') -->
    [resolver],
    [problemas].

actividad(actividad(verbo_infinitivo(ayudar), Prep, SN), personas, 'ayudar a las personas') -->
    [ayudar],
    preposicion_a(Prep),
    sintagma_personas(SN).

actividad(actividad(verbo_infinitivo(trabajar), Prep, SN), personas, 'trabajar con personas') -->
    [trabajar],
    preposicion_con(Prep),
    sintagma_personas(SN).

complemento_escuchar_opcional(complemento_prep(Prep, SN)) -->
    preposicion_a(Prep),
    sintagma_personas(SN).
complemento_escuchar_opcional(sin_complemento) --> [].

complemento_hablar_opcional(complemento_prep(Prep, SN)) -->
    preposicion_con(Prep),
    sintagma_personas(SN).
complemento_hablar_opcional(sin_complemento) --> [].

preposicion_a(preposicion(a)) --> [a].
preposicion_con(preposicion(con)) --> [con].

sintagma_personas(sn_personas(Det, Nombre)) -->
    determinante_opcional(Det),
    nombre_personas(Nombre).

nombre_personas(nombre(Token)) -->
    [Token],
    { lex_nombre_personas(Token) }.


/* =========================
   Locuciones elipticas
   ========================= */

locucion_respuesta(locucion_negativa(no_mucho), negativa) --> [no, mucho].
locucion_respuesta(locucion_negativa(para_nada), negativa) --> [para, nada].
locucion_respuesta(locucion_positiva(me_encanta), positiva) --> [me, encanta].


/* =========================
   Semantica
   ========================= */

resolver_intencion(directa, positiva, positiva).
resolver_intencion(directa, negativa, negativa).
resolver_intencion(invertida, positiva, negativa).
resolver_intencion(invertida, negativa, positiva).

construir_semantica(Tema, datos(Intencion, Referente, Texto), semantica(Tema, Intencion, referente(Referente), canonica(Canonica))) :-
    construir_canonica(Intencion, Texto, Canonica).

construir_canonica(positiva, Texto, Canonica) :-
    atomic_list_concat(['me gusta ', Texto], Canonica).

construir_canonica(negativa, Texto, Canonica) :-
    atomic_list_concat(['no me gusta ', Texto], Canonica).

tema_por_defecto(tecnologia, 'la tecnologia').
tema_por_defecto(matematicas, 'las matematicas').
tema_por_defecto(personas, 'las personas').
tema_por_defecto(problemas, 'resolver problemas').
tema_por_defecto(comunicacion, 'comunicarse').

construir_texto_actividad(escuchar, sin_complemento, 'escuchar').
construir_texto_actividad(escuchar, complemento_prep(_, _), 'escuchar a las personas').
construir_texto_actividad(hablar, sin_complemento, 'hablar').
construir_texto_actividad(hablar, complemento_prep(_, _), 'hablar con personas').


/* =========================
   Lexico
   ========================= */

lex_pronombre_sujeto(yo).

lex_pronombre_objeto(me).

lex_verbo_gusto(gusta, positiva).
lex_verbo_gusto(gustan, positiva).
lex_verbo_gusto(encanta, positiva).
lex_verbo_gusto(encantan, positiva).
lex_verbo_gusto(interesa, positiva).
lex_verbo_gusto(interesan, positiva).
lex_verbo_gusto(atrae, positiva).
lex_verbo_gusto(atraen, positiva).
lex_verbo_gusto(disgusta, negativa).
lex_verbo_gusto(disgustan, negativa).
lex_verbo_gusto(desagrada, negativa).
lex_verbo_gusto(desagradan, negativa).

lex_verbo_preferencia(prefiero, positiva).
lex_verbo_preferencia(disfruto, positiva).
lex_verbo_preferencia(adoro, positiva).
lex_verbo_preferencia(amo, positiva).
lex_verbo_preferencia(odio, negativa).
lex_verbo_preferencia(detesto, negativa).
lex_verbo_preferencia(rechazo, negativa).
lex_verbo_preferencia(evito, negativa).

lex_intensificador(mucho).
lex_intensificador(bastante).
lex_intensificador(realmente).
lex_intensificador(mas).

lex_determinante(la).
lex_determinante(el).
lex_determinante(las).
lex_determinante(los).

lex_nombre_tema(tecnologia, tecnologia).
lex_nombre_tema(computadoras, tecnologia).
lex_nombre_tema(programacion, tecnologia).
lex_nombre_tema(sistemas, tecnologia).

lex_nombre_tema(matematicas, matematicas).
lex_nombre_tema(numeros, matematicas).
lex_nombre_tema(calculo, matematicas).

lex_nombre_tema(personas, personas).
lex_nombre_tema(gente, personas).

lex_nombre_tema(problemas, problemas).
lex_nombre_tema(retos, problemas).

lex_nombre_personas(personas).
lex_nombre_personas(gente).
lex_nombre_personas(demas).
