% ------ GRAFO ------
aresta(centro, rua2, 6).
aresta(rua2, rua3, 7).
aresta(rua3, rua5, 3).
aresta(rua5, rua10, 2).
aresta(rua3, rua4, 2).
aresta(rua4, rua9, 6).
aresta(rua2, rua8, 2).
aresta(rua8, rua9, 1).
aresta(rua9, rua7, 4).
aresta(rua7, rua6, 8).
aresta(rua6, rua8, 2).
aresta(rua6, rua1, 6).
aresta(rua1, centro, 5).

% Adjacente
adjacente(Nodo, ProxNodo, C) :- aresta(Nodo,ProxNodo,C).
adjacente(Nodo, ProxNodo, C) :- aresta(ProxNodo,Nodo,C).

goal(centro). % correto?

estima(rua1,5).
estima(rua2,6).
estima(rua3,15).
estima(rua4,17).
estima(rua5,16).
estima(rua6,11).
estima(rua7,19).
estima(rua8,13).
estima(rua9,14).
estima(rua10,28).
estima(centro,0).