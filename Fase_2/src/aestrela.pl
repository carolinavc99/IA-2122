% ------ A Estrela ------
% ------ CIRCUITOS ------
%circuito(algoritmo, rua_entrega, [caminho], custo, peso, volume).

circuitos_aestrela:-
	lista_ruas(Ruas),
	circuitos_aestrela_aux(Ruas).

circuitos_aestrela_aux([H|T]):-
	primeiro_aestrela(H, Caminho/Custo),
	assert(circuito(aestrela, H, Caminho, Custo, 0, 0)),
	!, 
	circuitos_aestrela_aux(T).

circuitos_aestrela_aux([]).

/*
circuitos_aestrela(Circuitos) :-
	lista_ruas(Ruas),
	circuitos_aestrela_aux(Ruas, [], Circuitos).

circuitos_aestrela_aux([], Circuitos, Circuitos).

circuitos_aestrela_aux([H|T], Lista, Circuitos) :-
	primeiro_aestrela(H, Caminho/Custo),
	append([Caminho/Custo], Lista, ListaX),
	circuitos_aestrela_aux(T, ListaX, Circuitos).
*/

% ------ ALGORITMO ------
primeiro_aestrela(Destino, R/C) :-
	resolve_aestrela(Destino, RI/C),
	reverse(RI,R).

resolve_aestrela(Nodo, Caminho/Custo) :-
	estima(Nodo, Estima),
	aestrela([[Nodo]/0/Estima], InvCaminho/Custo/_),
	reverse(InvCaminho, Caminho),
	!.

aestrela(Caminhos, Caminho) :-
	obtem_melhor(Caminhos, Caminho),
	Caminho = [Nodo|_]/_/_,
	goal(Nodo).

aestrela(Caminhos, SolucaoCaminho) :-
	obtem_melhor(Caminhos, MelhorCaminho),
	seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
	expande_aestrela(MelhorCaminho, ExpCaminhos),
	append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
    aestrela(NovoCaminhos, SolucaoCaminho).	

expande_aestrela(Caminho, ExpCaminhos) :-
	findall(NovoCaminho, adjacenteAE(Caminho,NovoCaminho), ExpCaminhos).

% ------ AUXILIARES ------
obtem_melhor([Caminho],Caminho) :- !.

obtem_melhor([Caminho1/Custo1/Est1,_/Custo2/Est2|Caminhos], MelhorCaminho) :-
    Custo1 + Est1 =< Custo2 + Est2, !,
    obtem_melhor([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho).

obtem_melhor([_|Caminhos], MelhorCaminho) :- % caso caminho 2 seja melhor que caminho 1 (da cláusula anterior), este último é descartado
    obtem_melhor(Caminhos, MelhorCaminho).

adjacenteAE([Nodo|Caminho]/Custo/_, [ProxNodo,Nodo|Caminho]/NovoCusto/Est) :-
	adjacente(Nodo, ProxNodo, PassoCusto),
	\+member(ProxNodo, Caminho),
	NovoCusto is Custo + PassoCusto,
	estima(ProxNodo, Est).