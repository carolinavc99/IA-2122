% ------ ITERATIVA ------
% ------ CIRCUITOS ------
%circuito(algoritmo, rua_entrega, [caminho], custo, peso, volume).

circuitos_iterativa:-
	lista_ruas(Ruas),
	circuitos_iterativa_aux(Ruas).

circuitos_iterativa_aux([H|T]):-
	primeiro_it(H, Caminho/Custo),
	assert(circuito(iterativa, H, Caminho, Custo, 0, 0)),
    !,
	circuitos_iterativa_aux(T).

circuitos_iterativa_aux([]).

/*
% Itera sobre a lista de ruas e guarda o Caminho/Distancia para cada rua
circuitos_it(Circuitos) :-
	lista_ruas(Ruas),
	circuitos_it_aux(Ruas, [], Circuitos).

circuitos_it_aux([], Circuitos, Circuitos).

circuitos_it_aux([H|T], Lista, Circuitos) :-
	primeiro_it(H, Caminho/Custo),
	append([Caminho/Custo], Lista, ListaX),
	circuitos_it_aux(T, ListaX, Circuitos).
*/

% ------ ALGORITMO ------
% Devolve o primeiro resultado
primeiro_it(Destino, H/C) :-
    iterativa(centro, Destino, H/C), !.

% Corpo principal
iterativa(Orig,Dest,Cam/C):-
    dfs_iterativa(Orig,Dest,Cam/C,0).

dfs_iterativa(Orig,Dest,Cam/C,Iteracoes):-
    not(dfs2_iterativa(Orig,Dest,[Orig]/0,Cam/C,Iteracoes)),
    Niteracoes is Iteracoes+1,
    dfs_iterativa(Orig,Dest,Cam/C,Niteracoes).

dfs_iterativa(Orig,Dest,Cam/C,Iteracoes):- 
    dfs2_iterativa(Orig,Dest,[Orig]/0,Cam/C,Iteracoes).

dfs2_iterativa(Dest,Dest,LA/Custo,Cam/Custo,_):- 
    reverse(LA,Cam).
dfs2_iterativa(Act,Dest,LA/Custo_LA,Cam/C,Iteracoes):- 
    adjacente(Act,X,Custo_aresta), 
    \+ member(X,LA), 
    Custo is Custo_aresta+Custo_LA,
    Iteracoes > 0,
    Iteracoes_recursividade is Iteracoes-1,
    dfs2_iterativa(X,Dest,[X|LA]/Custo,Cam/C,Iteracoes_recursividade).
 
    