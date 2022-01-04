% ------ PROFUNDIDADE ------
% ------ CIRCUITOS ------
% Itera sobre a lista de ruas e guarda o Caminho/Distancia para cada rua
circuitos_pfp(Circuitos) :-
	lista_ruas(Ruas),
	circuitos_pfp_aux(Ruas, [], Circuitos).

circuitos_pfp_aux([], Circuitos, Circuitos).

circuitos_pfp_aux([H|T], Lista, Circuitos) :-
	resolve_pfp(H, Caminho, Custo),
	append([Caminho/Custo], Lista, ListaX),
	circuitos_pfp_aux(T, ListaX, Circuitos).

% ------ ALGORITMO ------
% Todos os caminhos para Nodo
resolve_pfp(Nodo, [Nodo|Caminho],C):- pfp(Nodo,[Nodo],Caminho,C).

% Melhor
melhor_pfp(Nodo,S,Custo) :- findall((SS,CC), resolve_pfp(Nodo,SS,CC),L),
    minimo(L, (Sx,Custo)), reverse(Sx, S).

% Corpo principal - devolve o caminho para o nodo
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