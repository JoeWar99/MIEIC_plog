:-use_module(library(lists)).
:-use_module(library(between)).
:-use_module(library(system)).
:-[board].
:-[lib].
:-[puzzles].

main(Matrix, N) :-
    % Generates a board bazed on predefined boards
    generate_board(N, Selected, Matrix),
    once(printBoard(Selected, N)),
    % Solves the random puzzle
    solver(Matrix, N),
    % prints the game Board
    once(printBoard(Matrix, N)).

solver(Matrix, N) :-
    % Resets time for statistics
    reset_timer,
    % Stores the matrix as 1 dimension
    append(Matrix, OneListMatrix),
    % Specifies the domain of the matrix
    domain(OneListMatrix, 0, 4), 
    % Restrictions for lines
    solveMatrix(Matrix),
    % Restrictions for columns
    transpose(Matrix, TMatrix),
    solveMatrix(TMatrix), 
    % labeling of the one list matrix
    !, labeling([], OneListMatrix),
    % prints elapsed time
    print_time.

% Solves received matrix (solves only the lines)
solveMatrix([]).
solveMatrix([H|T]) :-
    automaton(H, _, H, [source(s), sink(s3), sink(o2)],
        [
            arc(s, 0, s),
            arc(s, 1, o3),
            arc(s, 4, s1),
            
            arc(s1, 0, s1, [C+1]),
            arc(s1, 2, s2),
            arc(s1, 3, s4),
            arc(s1, 4, o1),

            arc(s2, 0, s2, [C-1]),
            arc(s2, 4, s3),

            arc(o1, 0, o1),
            arc(o1, 1, o2),

            arc(o2, 0, o2),

            arc(o3, 0, o3),
            arc(o3, 4, o4),

            arc(o4, 0, o4),
            arc(o4, 4, o2),

            arc(s3, 0, s3),

            arc(s4, 0, s4, [C-1]),
            arc(s4, 4, s3)
        ],
        [C], [0], [DeltaDist]
    ),    
    solveLine(H),
    solveMatrix(T).

% Restricts each line (2 dots and 1 letter per line + restricts line)
solveLine([], _).
solveLine([H | T], DeltaDist):-  
    DeltaDist #= 0 #<= H #= 2,
    DeltaDist #\=0 #<= H #= 3,
    solveLine(T).