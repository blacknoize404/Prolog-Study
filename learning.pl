% equipo 1 desarrollar una sumatoria de las notas de los estudiantes, promedio de la nota de todos los estudiantes

% equipo 2 (método se va a llamar verMatrícula) según una lista de estudiantes, mostrar si cada estudiante 
% pertenece a la carrera del argumento, entrada una lista de estudiantes, y la carrera en cuestión, devuelve 
% una lista de booleanos por cada estudiante).

student(carlos, 25, informatica, [maths, history, uml], [6,10,3]).
student(juan, 19, informatica, [maths, history, uml], [4,4,4]).
student(luis, 23, informatica, [guts], [5,5,5]).
student(roberto, 20, arquitectura, [matematicas, dibujo, historia], [7, 8, 9]).
student(maria, 22, arquitectura, [matematicas, dibujo, historia], [8, 9, 10]).
student(pedro, 21, arquitectura, [matematicas, dibujo, historia], [6, 7, 8]).


get_lectures_of_student(S, Lectures):- student(S,_,_,Lectures,_).
get_notes_of_student(S, Notes):- student(S,_,_,_,Notes).
get_first_lecture_of_student(S, First):- student(S,_,_,[First|_],_).

get_average_of_student(Name, Average):- 
    student(Name,_,_,_,Notes),
    sum_list(Notes, Sum), 
    length(Notes, Length), 
    (Length > 0 -> 
        Average is div(Sum, Length); 
        Average is 0
    ).

get_average(Notes, Average):- 
    sum_list(Notes, Sum), 
    length(Notes, Length), 
    (Length > 0 -> 
        Average is div(Sum, Length); 
        Average is 0
    ).

% a)
best_student:-
    student(Name, _, _, _, Notes),
    get_average(Notes, Average),
    forall(
        (student(OtherName, _, _, _, OtherNotes), Name \= OtherName),
        (get_average(OtherNotes, OtherAverage), Average >= OtherAverage)
    ),
    write('El mejor estudiante es: '),
    write(Name),
    !.

% Caso base para la lista esté vacía.
print_list([]):-!.

% Muestro en consola cada elemento de la lista en una línea separada de forma recursiva.
print_list([H|T]):- 
    write(H), 
    nl, 
    print_list(T).

% b)
get_students_of_career(Career):- 
    % obtengo todos los nombres de estudiantes que estén en dicha carrera
    findall(Name, student(Name,_,Career,_,_), List),
    % cuento el tamaño
    length(List, Length), 
    % si el tamaño es mayor que 0 muestro el mensaje
    (Length > 0 -> 
        write('Los estudiantes que pertenecen a la carrera de '), 
        write(Career), 
        write(' son:'),
        nl,
        print_list(List);
        % en caso contrario, muestro el mensaje
        write('No hay estudiantes que pertenezcan a dicha carrera') 
    ).
  
% c)
get_lectures_of_career(Career) :-
    % obtengo todas las listas de asignaturas de cada estudiante que coincida con dicha carrera
    findall(Lectures, student(_, _, Career, Lectures, _), AllLectures), 
    % convierte una lista de listas en una lista simple.
    flatten(AllLectures, FlattenLectures), 
    % remuevo duplicados.
    list_to_set(FlattenLectures, NoRepeatedLectures), 
    % cuento el tamaño
    length(NoRepeatedLectures, Length),
    % si el tamaño es mayor que 0 muestro el mensaje
    (Length > 0 -> 
        write('Las asignaturas registradas en la carrera de '),
        write(Career), 
        write(' son: '),
        nl,
        print_list(NoRepeatedLectures);
        % en caso contrario emito un mensaje
        write('No se encontraron asignaturas para esa carrera o no esta registrada en el sistema')
    ).

% Caso base para cuando las listas se vacíen.
print_pairs([],[]):-!.

% Esta función se encarga de escribir una línea formateada con el nombre y la nota de cada uno de los estudiantes.
print_pairs([AKH|AKT], [AVH|AVT]):- 
    write('El estudiante '),
    write(AVH),
    write(' con '),
    write(AKH),
    write(' puntos de promedio.'),
    nl, 
    % Paso a la siguiente iteración de la recursividad solo con la cola.
    print_pairs(AKT, AVT).

% d)
best_students(Career) :-

    % Creo una lista con un par de valores que tengan el promedio de las notas de cada uno y sus respectivos nombres.
    findall(
        Average-Student,
        (student(Student, _, Career, _, Grades), get_average(Grades, Average)),
        StudentAverages),
    
    % obtengo el tamaño de la lista de estudiantes
    length(StudentAverages, Length),

    % si el tamaño es mayor que 0 muestro el mensaje
    (Length > 0 -> 
        
        % Ordeno atendiendo a la clave de forma ascendente.
        keysort(StudentAverages, Sorted), 

        % extraigo del par sus claves y valores en listas separadas
        pairs_keys_values(Sorted, Averages, Names),

        % muestro en consola la respuesta
        write('Los estudiantes ordenados por su promedio de notas de forma ascendente son: '),
        nl,
        
        % muestro una línea formateada para cada uno de los estudiantes y su promedio
        print_pairs(Averages, Names);

        % en caso contrario emito un mensaje
        write('No se encontraron estudiantes para ordenar por su promedio')
    ).
