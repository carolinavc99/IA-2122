% ------ LARGURA ------

% ------ CIRCUITOS ------
% Itera sobre a lista de ruas e guarda o Caminho/Distancia para cada rua
circuitos_bfs(Circuitos) :-
	lista_ruas(Ruas),
	circuitos_bfs_aux(Ruas, [], Circuitos).

circuitos_bfs_aux([], Circuitos, Circuitos).

circuitos_bfs_aux([H|T], Lista, Circuitos) :-
	bfs(centro, H, Caminho/Custo),
	append([Caminho/Custo], Lista, ListaX),
	circuitos_bfs_aux(T, ListaX, Circuitos).

% ------ ALGORITMO ------
primeiro_bfs(Origem, Destino, X/C):-
    findall(Resultado, bfs(centro, Destino, Resultado), [H/C|T]), reverse(H,X).

bfs(Orig, Dest, Cam/C):- 
    bfs2(Dest,[[Orig]/0],Cam/C).

bfs2(Dest,[[Dest|T]/C|_],Cam/C):- 
    reverse([Dest|T],Cam).

bfs2(Dest,[LA/Custo|Outros],Cam/C):- 
    LA=[Act|_],
    findall([X|LA]/Custo_atualizado,
        (Dest\==Act,adjacente(Act,X,Custo_aresta),\+member(X,LA),Custo_atualizado is Custo+Custo_aresta),Novos),
    append(Outros,Novos,Todos),
    bfs2(Dest,Todos,Cam/C).