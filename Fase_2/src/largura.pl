% ------ LARGURA ------
depth_first(Goal, Goal, _, [Goal]).
depth_first(Start, Goal, Visited, [Start|Path]) :-
    next_node(Start, Next_node, Visited),
    write(Visited), nl,
    depth_first(Next_node, Goal, [Next_node|Visited], Path).

brdepth_first( Start, Goal, Path):-
    depth_first( Start, Goal, [Start], Path).

consed( A, B, [B|A]).

bfs( Goal, [Visited|Rest], Path) :-                     % take one from front
    Visited = [Start|_],            
    Start \== Goal,
    findall( X,
        ( connected2(X, Start, _), \+ member(X, Visited) ),
        [T|Extend]),
    maplist( consed(Visited), [T|Extend], VisitedExtended),      % make many
    append( Rest, VisitedExtended, UpdatedQueue),       % put them at the end
    bfs( Goal, UpdatedQueue, Path ).

    
next_node(Current, Next, Path) :-
    adjacente(Current, Next, _),
    not(member(Next, Path)).


/*
bfs(Origem, Destino, Caminho) :- bfs2(Destino, [[Origem]], Caminho).
bfs2(Destino, [[Destino|T]|_], Caminho) :- reverse([Destino|T], Caminho), write(Caminho).
bfs2(Destino, [LA|Outros], Caminho) :- 
    LA = [Actual|_],
    findall([X|LA],
    (Destino\==Actual,transicao(Actual, Operacao, X), \+ member(X, LA)), Novos),
    append(Outros, Novos, Todos),
    bfs2(Destino,Todos,Caminho).

% Melhor
melhor(Nodo,S,Custo) :- findall((SS,CC), resolve_pfp(Nodo,SS,CC),L),
    minimo(L, (S,Custo)).

resolve_pfp(Nodo, [Nodo|Caminho],C):- pfp(Nodo,[Nodo],Caminho,C).

pfp(Nodo,_,[],0) :- goal(Nodo).
pfp(Nodo,Historico,[ProxNodo|Caminho],C):-
    adjacente(Nodo,ProxNodo,C1),
    not(membro(ProxNodo,Historico)),
    pfp(ProxNodo,[ProxNodo|Historico],Caminho,C2),
    C is C1 + C2.

% Mínimo
minimo([(P,X)], (P,X)).
minimo([(Px,X)|L], (Py,Y)) :- minimo(L, (Py,Y)), X>Y.
minimo([(Px,X)|L], (Px,X)) :- minimo(L, (Py,Y)), X=<Y.
*/