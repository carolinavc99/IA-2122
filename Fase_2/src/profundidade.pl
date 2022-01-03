% ------ PROFUNDIDADE ------
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