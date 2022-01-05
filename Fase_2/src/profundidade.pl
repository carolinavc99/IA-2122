% ------ PROFUNDIDADE ------
% ------ CIRCUITOS ------
% Itera sobre a lista de ruas e guarda o Caminho/Distancia para cada rua

dfs(Orig,Dest,Cam/C):- 
    dfs2(Orig,Dest,[Orig]/0,Cam/C). 
dfs2(Dest,Dest,LA/Custo,Cam/Custo):- 
    reverse(LA,Cam).
dfs2(Act,Dest,LA/Custo_LA,Cam/C):- 
    adjacente(Act,X,Custo_aresta), 
    \+ member(X,LA), 
    Custo is Custo_aresta+Custo_LA,
    dfs2(X,Dest,[X|LA]/Custo,Cam/C).

