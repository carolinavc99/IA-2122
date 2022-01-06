% ------ PROFUNDIDADE ------
% ------ CIRCUITOS ------
%circuito(algoritmo, rua_entrega, [caminho], custo, peso, volume).

circuitos_profundidade:-
	lista_ruas(Ruas),
	circuitos_profundidade_aux(Ruas).

circuitos_profundidade_aux([H|T]):-
	primeiro_dfs(H, Caminho/Custo),
	assert(circuito(profundidade, H, Caminho, Custo, 0, 0)),
    !,
	circuitos_profundidade_aux(T).

circuitos_profundidade_aux([]).
/*
% Itera sobre a lista de ruas e guarda o Caminho/Distancia para cada rua
circuitos_dfs(Circuitos) :-
	lista_ruas(Ruas),
	circuitos_dfs_aux(Ruas, [], Circuitos).

circuitos_dfs_aux([], Circuitos, Circuitos).
circuitos_dfs_aux([H|T], Lista, Circuitos) :-
	primeiro_dfs(H, Caminho/Custo),
	append([Caminho/Custo], Lista, ListaX),
	circuitos_dfs_aux(T, ListaX, Circuitos).
*/
% ------ ALGORITMO ------
% Devolve o primeiro resultado
primeiro_dfs(Destino, H/C) :-
    findall(Resultado, dfs(centro, Destino, Resultado), [H/C|T])/*, reverse(H,X)*/.

% Corpo principal
dfs(Orig,Dest,Cam/C):- 
    dfs2(Orig,Dest,[Orig]/0,Cam/C). 
dfs2(Dest,Dest,LA/Custo,Cam/Custo):- 
    reverse(LA,Cam).
dfs2(Act,Dest,LA/Custo_LA,Cam/C):- 
    adjacente(Act,X,Custo_aresta), 
    \+ member(X,LA), 
    Custo is Custo_aresta+Custo_LA,
    dfs2(X,Dest,[X|LA]/Custo,Cam/C).
