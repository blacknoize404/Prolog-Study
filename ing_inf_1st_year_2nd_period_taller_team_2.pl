%----------------------------------------------------------
%|           Universidad de Holguín (UHo) 2023            |       
%|            ___           ___           ___             |
%|           /\__\         /\__\         /\  \            | 
%|          /:/  /        /:/  /        /::\  \           |
%|         /:/  /        /:/__/        /:/\:\  \          |
%|        /:/  /  ___   /::\  \ ___   /:/  \:\  \         |
%|       /:/__/  /\__\ /:/\:\  /\__\ /:/__/ \:\__\        |
%|       \:\  \ /:/  / \/__\:\/:/  / \:\  \ /:/  /        |
%|        \:\  /:/  /       \::/  /   \:\  /:/  /         |
%|         \:\/:/  /        /:/  /     \:\/:/  /          |
%|          \::/  /        /:/  /       \::/  /           |
%|           \/__/         \/__/         \/__/            |
%|--------------------------------------------------------|
%| Ingeniería Informática | Primer año | Segundo período  |
%|                                                        |
%|            Taller de Matemáticas Discretas             |
%|                                                        |
%|            Tarea orientada para el equipo 2            |
%|--------------------------------------------------------|
%| Integrantes:                                           |
%| Melissa Giraldo Rodríguez                              |
%| Melany Marian Ricardo Rodríguez                        |
%| José Enrique Villafruela Macías                        |
%| Carlos Luis Barnés Infante                             |
%|--------------------------------------------------------|

% Base de conocimientos
student('Ike', 25, informatics, [maths, history, uml], [3,2,3]).
student('Juan', 19, informatics, [maths, history, uml, programming], [4,4,4,3]).
student('Luis', 23, mechanic, [physics], [5]).
student('Roberto', 20, architecture, [desing], [4]).
student('Maria', 22, architecture, [maths, drawing, history], [3, 4, 5]).
student('Pedro', 21, architecture, [drawing, history], [3, 5]).
student('Lisa', 19, informatics, [maths], [3]).
student('Jean', 22, informatics, [discrete_maths], [5]).
student('Rafael', 21, informatics, [uml, discrete_maths], [2, 3]).
student('Catania', 21, antropology, [investigation_methodology], [4]).
student('Xavier', 20, medicine, [cells, pharmacology], [3, 5]).
student('Joan', 20, medicine, [history], [3]).

% Tengo que hacer esta función para el inciso c ya que necesitamos ordenar atendiendo al promedio
% de las notas de cada estudiante.
get_average(Notes, Average):- 

    % uso la función sum_list para realizar la sumatoria de todos los elementos
    % numéricos de la lista.
    sum_list(Notes, Sum), % antes se usaba sumlist pero ha sido depreciado a favor de sum_list
    
    % uso la función length para devolver el tamaño de la lista.
    length(Notes, Length), 

    % si el tamaño es mayor que 0
    (Length > 0 -> 
    
        % devuelvo el promedio
        Average is div(Sum, Length); 
    
        % caso contrario, devuelvo 0 (para evitar la división por 0)
        Average is 0
    ).

% a) Obtener el mejor estudiante respecto a sus notas.
best_student:-
    
    % Obtengo una referencia a las notas del primer estudiante.
    student(Name, _, _, _, Notes),
    
    % Calculo el promedio de dicho primer estudiante
    get_average(Notes, Average),

    % por todos los estudiantes, voy asignando a Name el nombre del estudiante,
    % que vaya encontrando con mayor promedio y nombre distinto a los anteriores.
    forall(
        (student(OtherName, _, _, _, OtherNotes), Name \= OtherName),
        (get_average(OtherNotes, OtherAverage), Average >= OtherAverage)
    ),

    % Imprimo en consola el resultado.
    write('El mejor estudiante es '),
    write(Name), nl,
    
    % necesito terminar de devolver soluciones para student, ya que solo necesito 
    % el primero, así que coloco un corte verde.
    !.

% Caso base para cuando la lista esté vacía.
print_list([]):-!.

% Muestro en consola cada elemento de la lista en una línea separada de forma recursiva.
print_list([H|T]):- 
    write(H), 
    nl, 
    print_list(T).

% b) 1. A partir de una carrera mostrar estudiantes la misma
get_students_of_career:- 

    write('Introduzca la carrera de la cual obtener los estudiantes...\n'),
    read(Career),
    
    % obtengo todos los nombres de estudiantes que estén en dicha carrera
    findall(Name, student(Name,_,Career,_,_), List),
    
    % cuento el tamaño
    length(List, Length), 
    
    % si el tamaño es mayor que 0 muestro el mensaje
    (Length > 0 -> 
        write('Los estudiantes que pertenecen a la carrera de '), 
        write(Career), 
        write(' son:\n'),
        print_list(List);
        % en caso contrario, muestro el mensaje
        write('No hay estudiantes que pertenezcan a dicha carrera\n') 
    ).
  
% b) 2. A partir de una carrera mostrar todas las asignaturas registradas a dicha carrera
get_lectures_of_career :-

    write('Introduzca la carrera de la cual obtener las asignaturas...\n'),
    read(Career),

    % obtengo todas las listas de asignaturas de cada estudiante que coincida con dicha carrera
    findall(Lectures, student(_, _, Career, Lectures, _), AllLectures), 
    
    % como esto devolverá una lista de listas, necesito usar flatten para convertir 
    % dicha lista de listas en una lista simple.
    flatten(AllLectures, FlattenLectures), 
    
    % remuevo duplicados.
    list_to_set(FlattenLectures, NoRepeatedLectures), 
    
    % cuento el tamaño
    length(NoRepeatedLectures, Length),
    
    % si el tamaño es mayor que 0 muestro el mensaje
    (Length > 0 -> 
        write('Las asignaturas registradas en la carrera de '),
        write(Career), 
        write(' son: \n'),
        print_list(NoRepeatedLectures);
        % en caso contrario emito un mensaje
        write('No se encontraron asignaturas para esa carrera o no esta registrada en el sistema\n')
    ).

% Caso base para cuando las listas estén vacías.
print_pairs([],[]):-!.

% Esta función se encarga de escribir una línea formateada con el nombre y la nota de cada uno de los estudiantes.
% AKH es la cabeza de la lista de las notas, AVH, es la cabeza de la lista de los nombres.
% AKT es la cola de la lista de las notas, AVT, es la cola de la lista de los nombres.
print_pairs([AKH|AKT], [AVH|AVT]):- 
    write('El estudiante '),
    write(AVH),
    write(' con '),
    write(AKH),
    write(' puntos de promedio'),
    nl, 
    % Paso a la siguiente iteración de la recursividad solo con la cola.
    print_pairs(AKT, AVT).

% c) A partir de una carrera dada, mostrar estudiantes ordenados de forma ascendente de acuerdo a su nota final.
best_students_of_career :-

    write('Introduzca la carrera de la cual obtener los estudiantes ordenados por sus notas...'), nl,
    read(Career),

    % Creo una lista con un par de valores que tengan el promedio de las notas de cada uno y sus respectivos nombres.
    findall(
        Average-Student,
        (student(Student, _, Career, _, Grades), get_average(Grades, Average)),
        StudentAverages),
    
    % obtengo el tamaño de la lista de estudiantes
    length(StudentAverages, Length),

    % si el tamaño es mayor que 0 muestro el mensaje
    (Length > 0 -> 
        
        % ordeno atendiendo a la clave de forma ascendente.
        keysort(StudentAverages, Sorted), 

        % extraigo del par sus claves y valores en listas separadas
        pairs_keys_values(Sorted, Averages, Names),

        % muestro en consola la respuesta
        write('Los estudiantes ordenados por su promedio de notas de forma ascendente son:\n'),
        
        % muestro una línea formateada para cada uno de los estudiantes y su promedio
        print_pairs(Averages, Names);

        % en caso contrario emito un mensaje
        write('No se encontraron estudiantes para ordenar por su promedio\n')
    ).

% Creo un parser para ejecutar los métodos en dependencia de la opción escogida.
execute(Option):-
    Option == 1, best_student, menu;
    Option == 2, get_students_of_career, menu;
    Option == 3, get_lectures_of_career, menu;
    Option == 4, best_students_of_career, menu;
    Option == 0, true.

% Creo un menú que se mostrará al inicio de la ejecución.
menu:- 
    write('\n***Gestor de estudiantes***\n'),
    write('1. Obtener el mejor estudiante registrado en la base de datos\n'),
    write('2. Obtener todos los estudiantes registrados en una carrera\n'),
    write('3. Obtener todas las asignaturas registradas en una carrera\n'),
    write('4. Obtener todos los estudiantes registrados en una carrera (ordenados de forma ascendente atendiendo a su promedio)\n'),
    write('0. Salir\n'),
    read(Option), execute(Option).

% Ejecuto por defecto menu.
:- menu.