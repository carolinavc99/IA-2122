% ------ GRAFO ------
aresta(centro, 2, 6).
aresta(2, 3, 7).
aresta(3, 5, 3).
aresta(5, 10, 2).
aresta(3, 4, 2).
aresta(4, 9, 6).
aresta(2, 8, 2).
aresta(8, 9, 1).
aresta(9, 7, 4).
aresta(7, 6, 8).
aresta(6, 8, 2).
aresta(6, 1, 6).
aresta(1, centro, 5).

% Adjacente
adjacente(Nodo, ProxNodo, C) :- aresta(Nodo,ProxNodo,C).
adjacente(Nodo, ProxNodo, C) :- aresta(ProxNodo,Nodo,C).

goal(centro).

estima(1,5).
estima(2,6).
estima(3,15).
estima(4,17).
estima(5,16).
estima(6,11).
estima(7,19).
estima(8,13).
estima(9,14).
estima(10,28).
estima(centro,0).