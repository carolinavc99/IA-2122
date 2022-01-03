% ------ LARGURA ------
% Código tirado de git --- !!!  COPIADO NÃO USAR NEM DEIXAR NO CÓDIGO  !!! ---
resolvePPCusto(Inicial,Final,[Inicial|Caminho],Custo):-
    primeiroprofundidadeCusto(Inicial,Final,[Inicial],Caminho,Custo).

primeiroprofundidadeCusto(Nodo,Final, _, [], 0):-Nodo ==Final.

primeiroprofundidadeCusto(Nodo,Final,Historico,[NodoProx|Caminho],Custo):-
    adjacenteCusto(Nodo,NodoProx,CustoMovimento),
    not(member(NodoProx, Historico)),
    primeiroprofundidadeCusto(NodoProx,Final,[NodoProx|Historico],Caminho,Custo2),
    Custo is CustoMovimento + Custo2.

adjacenteCusto(Nodo, NodoProx, Custo):-
    adjacente(Nodo,NodoProx,Custo).

% !!! ver warning acima !!!


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