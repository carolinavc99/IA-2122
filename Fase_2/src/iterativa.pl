% ------ ITERATIVA ------
% gerar circuitos

% Algoritmo
%iterativa(Orig,Dest,Cam/C,0).
iterativa(Orig,Dest,Cam/C,Iteracoes):-
    dfs_iterativa(Orig,Dest,Cam/C,Iteracoes).

dfs_iterativa(Orig,Dest,Cam/C,Iteracoes):- 
    dfs2_iterativa(Orig,Dest,[Orig]/0,Cam/C,Iteracoes).

dfs2_iterativa(Dest,Dest,LA/Custo,Cam/Custo,Iteracoes):- 
    reverse(LA,Cam).
dfs2_iterativa(Act,Dest,LA/Custo_LA,Cam/C,Iteracoes):- 
    adjacente(Act,X,Custo_aresta), 
    \+ member(X,LA), 
    Custo is Custo_aresta+Custo_LA,
    Iteracoes > 0,
    Iteracoes_recursividade is Iteracoes-1,
    dfs2_iterativa(X,Dest,[X|LA]/Custo,Cam/C,Iteracoes_recursividade).
 
    