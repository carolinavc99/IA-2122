% ------ PESQUISA GULOSA ------
% ------ CIRCUITOS ------
%circuito(algoritmo, rua_entrega, [caminho], custo, peso, volume).

circuitos_gulosa:-
	lista_ruas(Ruas),
	circuitos_gulosa_aux(Ruas).

circuitos_gulosa_aux([H|T]):-
	primeiro_gulosa(H, Caminho/Custo),
	assert(circuito(gulosa, H, Caminho, Custo, 0, 0)),
    !,
	circuitos_gulosa_aux(T).

circuitos_gulosa_aux([]).
/*
% Itera sobre a lista de ruas e guarda o Caminho/Distancia para cada rua
circuitos_gulosa(Circuitos) :-
	lista_ruas(Ruas),
	circuitos_gulosa_aux(Ruas, [], Circuitos).

circuitos_gulosa_aux([], Circuitos, Circuitos).

circuitos_gulosa_aux([H|T], Lista, Circuitos) :-
	resolve_gulosa(H, Caminho/Custo),
	append([Caminho/Custo], Lista, ListaX),
	circuitos_gulosa_aux(T, ListaX, Circuitos).
*/
% ------ ALGORITMO ------
primeiro_gulosa(Nodo, R/C) :-
    resolve_gulosa(Nodo, RI/C),
    reverse(RI,R).

resolve_gulosa(Nodo,Caminho/Custo) :- 
        estima(Nodo, Estima),
        agulosa([[Nodo]/0/Estima], InvCaminho/Custo/_),
        reverse(InvCaminho, Caminho),
        !.

agulosa(Caminhos, Caminho) :-
    obtem_melhor_g(Caminhos,Caminho),
    Caminho = [Nodo|_]/_/_,
    goal(Nodo).

agulosa(Caminhos, SolucaoCaminho) :-
    obtem_melhor_g(Caminhos,MelhorCaminho),
    remove(MelhorCaminho,Caminhos,OutrosCaminhos),
    expande_gulosa(MelhorCaminho,ExpCaminhos),
    append(OutrosCaminhos,ExpCaminhos,NovoCaminhos),
    agulosa(NovoCaminhos,SolucaoCaminho).


obtem_melhor_g([Caminho],Caminho) :- !.
obtem_melhor_g([Caminho1/Custo1/Est1, _/_/Est2|Caminhos], MelhorCaminho) :-
    Est1 =< Est2, !,
    obtem_melhor_g([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho).
obtem_melhor_g([_|Caminhos], MelhorCaminho) :- obtem_melhor_g(Caminhos, MelhorCaminho).

expande_gulosa(Caminho,ExpCaminhos) :-
    findall(NovoCaminho, adjacenteGu(Caminho,NovoCaminho),ExpCaminhos).

adjacenteGu([Nodo|Caminho]/Custo/_, [ProxNodo,Nodo|Caminho]/NovoCusto/Est) :-
    adjacente(Nodo,ProxNodo,PassoCusto),
    not(member(ProxNodo,Caminho)),
    NovoCusto is Custo + PassoCusto,
    estima(ProxNodo,Est).

remove(E,[E|Xs],Xs).
remove(E,[X|Xs],[X|Ys]) :- remove(E,Xs,Ys).
