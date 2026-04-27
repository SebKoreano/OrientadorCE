/* ==================================================
   Preguntas
   ================================================== */

pregunta(tecnologia, "Te interesa la tecnologia y entender como funcionan los sistemas?").
pregunta(computadores, "Te llaman la atencion los computadores y la programacion?").
pregunta(innovacion, "Disfrutas explorar ideas nuevas y tecnologicas?").
pregunta(salud, "Te interesa el area de la salud y el bienestar de otras personas?").
pregunta(ciencia, "Te gusta aprender ciencia y comprender como funciona el mundo?").
pregunta(personas, "Te gusta trabajar o ayudar a otras personas?").
pregunta(leyes, "Te interesan las leyes, la justicia y las normas?").
pregunta(lectura, "Te gusta leer y analizar textos con detalle?").
pregunta(justicia, "Te motiva defender lo justo y tomar decisiones imparciales?").
pregunta(diseno, "Te atrae crear, imaginar y dar forma a ideas visuales?").
pregunta(estetica, "Te importa mucho la estetica, la forma y la presentacion?").
pregunta(agroecosistemas, "Te interesan los sistemas de produccion y el entorno natural?").
pregunta(campo, "Te gusta trabajar al aire libre o en el campo?").
pregunta(estrellas, "Te interesan el espacio, las estrellas y la exploracion?").
pregunta(comida, "Te gusta la comida, cocinar o experimentar con sabores?").
pregunta(experiencias, "Te gusta crear experiencias memorables para otras personas?").
pregunta(historia, "Te interesa la historia y el pasado de las civilizaciones?").
pregunta(animales, "Te interesan los animales y los seres vivos?").
pregunta(ventas, "Te interesa vender, convencer o negociar con otras personas?").
pregunta(biologiaTema, "Te interesa la biologia, los seres vivos y los ecosistemas?").
pregunta(matematicas, "Te gustan las matematicas y el razonamiento numerico?").

pregunta(logica, "Se te facilita razonar de forma logica y ordenada?").
pregunta(problemas, "Disfrutas resolver problemas complejos?").
pregunta(analisis, "Te resulta facil analizar informacion y sacar conclusiones?").
pregunta(resiliencia, "Mantienes la calma y sigues adelante ante dificultades?").
pregunta(disciplina, "Eres constante y disciplinado con tus tareas?").
pregunta(etica, "Sueles actuar con responsabilidad y sentido etico?").
pregunta(persuasion, "Tienes facilidad para persuadir o convencer a otros?").
pregunta(memoria, "Tienes buena memoria para recordar detalles?").
pregunta(vision, "Tienes buena vision espacial o para imaginar formas?").
pregunta(planificacion, "Te organizas bien y planificas antes de actuar?").
pregunta(creatividad, "Generas ideas originales con facilidad?").
pregunta(recursos, "Sabes administrar recursos y aprovechar lo que tienes?").
pregunta(aislamiento, "Trabajas bien incluso cuando estas solo o aislado?").
pregunta(presion, "Rindes bien cuando trabajas bajo presion?").
pregunta(paciencia, "Tienes paciencia para procesos largos o detallados?").
pregunta(metodo_cientifico, "Te sientes comodo con el metodo cientifico y la investigacion?").
pregunta(rechazo, "Toleras bien el rechazo o la critica en situaciones de trabajo?").

pregunta(ambiguedad, "Te incomoda no tener claridad o instrucciones precisas?").
pregunta(rutina, "La rutina te desmotiva con facilidad?").
pregunta(impaciencia, "Te cuesta esperar resultados o trabajar con calma?").
pregunta(intolerancia, "Te cuesta tratar con personas muy distintas a ti?").
pregunta(horarios, "Los horarios estrictos o exigentes te incomodan?").
pregunta(burocracia, "La burocracia y los procedimientos largos te desmotivan?").
pregunta(subjetividad, "Te incomoda trabajar con opiniones muy subjetivas?").
pregunta(trabajo, "Te pesa el trabajo constante o muy demandante?").
pregunta(funcionalidad, "Te cuesta priorizar lo funcional sobre lo estetico?").
pregunta(sedentarismo, "Tienes un estilo de vida muy sedentario?").
pregunta(confinamiento, "Te incomoda estar en espacios cerrados o confinados?").
pregunta(gratificacion, "Te cuesta esperar beneficios o resultados a largo plazo?").
pregunta(observacion, "Te cansa fijarte en detalles durante mucho tiempo?").
pregunta(introversion, "Eres una persona reservada a la que le cuesta comunicarse con los demas?").


/* ==================================================
   Lista de carreras disponibles
   ================================================== */

carrera(ingenieriaCE, "Ingenieria en computadores").
carrera(medicina, "Medicina").
carrera(derecho, "Derecho").
carrera(arquitectura, "Arquitectura").
carrera(agricola, "Agricola"). 
carrera(astronauta, "Astronauta").
carrera(gastronomia, "Gastronomia").
carrera(arquelogia, "Arqueologia").
carrera(biologia, "Biologia").
carrera(agenteVentas, "Agente de ventas").

/* ==================================================
   Afinidades
   ================================================== */

afinidad(computadores, ingenieriaCE).
afinidad(tecnologia, ingenieriaCE).
afinidad(innovacion, ingenieriaCE).

afinidad(salud, medicina).
afinidad(ciencia, medicina).
afinidad(personas, medicina).

afinidad(leyes, derecho).
afinidad(lectura, derecho).
afinidad(justicia, derecho).

afinidad(diseno, arquitectura).
afinidad(estetica, arquitectura).
afinidad(tecnologia, arquitectura).

afinidad(agroecosistemas, agricola).
afinidad(biologiaTema, agricola).
afinidad(campo, agricola).

afinidad(estrellas, astronauta).
afinidad(innovacion, astronauta).
afinidad(tecnologia, astronauta).

afinidad(comida, gastronomia).
afinidad(innovacion, gastronomia).
afinidad(experiencias, gastronomia).

afinidad(historia, arquelogia).
afinidad(justicia, arquelogia).
afinidad(campo, arquelogia).

afinidad(animales, biologia).
afinidad(biologiaTema, biologia).
afinidad(campo, biologia).

afinidad(ventas, agenteVentas).
afinidad(justicia, agenteVentas).
afinidad(personas, agenteVentas).

/* ==================================================
   Fortalezas
   ================================================== */

fortaleza(logica, ingenieriaCE).
fortaleza(problemas, ingenieriaCE).
fortaleza(analisis, ingenieriaCE).
fortaleza(matematicas, ingenieriaCE).

fortaleza(resiliencia, medicina).
fortaleza(disciplina, medicina).
fortaleza(etica, medicina).

fortaleza(persuasion, derecho).
fortaleza(memoria, derecho).
fortaleza(analisis, derecho).

fortaleza(vision, arquitectura).
fortaleza(planificacion, arquitectura).
fortaleza(creatividad, arquitectura).

fortaleza(recursos, agricola).
fortaleza(planificacion, agricola).
fortaleza(problemas, agricola).

fortaleza(aislamiento, astronauta).
fortaleza(disciplina, astronauta).
fortaleza(resiliencia, astronauta).

fortaleza(presion, gastronomia).
fortaleza(creatividad, gastronomia).
fortaleza(etica, gastronomia).

fortaleza(paciencia, arquelogia).
fortaleza(memoria, arquelogia).
fortaleza(planificacion, arquelogia).

fortaleza(ciencia, biologia).
fortaleza(disciplina, biologia).
fortaleza(analisis, biologia).
fortaleza(biologiaTema, biologia).

fortaleza(rechazo, agenteVentas).
fortaleza(persuasion, agenteVentas).
fortaleza(creatividad, agenteVentas).


/* ==================================================
   Antagonias
   ================================================== */

antagonia(ambiguedad, ingenieriaCE).
antagonia(rutina, ingenieriaCE).
antagonia(impaciencia, ingenieriaCE).

antagonia(intolerancia, medicina).
antagonia(horarios, medicina).
antagonia(burocracia, medicina).

antagonia(subjetividad, derecho).
antagonia(rutina, derecho).
antagonia(trabajo, derecho).

antagonia(funcionalidad, arquitectura).
antagonia(rutina, arquitectura).
antagonia(impaciencia, arquitectura).

antagonia(sedentarismo, agricola).
antagonia(horarios, agricola).
antagonia(burocracia, agricola).

antagonia(confinamiento, astronauta).
antagonia(rutina, astronauta).
antagonia(ambiguedad, astronauta).

antagonia(trabajo, gastronomia).
antagonia(horarios, gastronomia).
antagonia(burocracia, gastronomia).

antagonia(gratificacion, arquelogia).
antagonia(rutina, arquelogia).
antagonia(trabajo, arquelogia).

antagonia(observacion, biologia).
antagonia(horarios, biologia).
antagonia(ambiguedad, biologia).

antagonia(introversion, agenteVentas).
antagonia(rutina, agenteVentas).
antagonia(impaciencia, agenteVentas).