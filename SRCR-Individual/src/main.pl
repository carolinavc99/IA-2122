:-include("adjacencia.pl").
:-include("capacidade.pl").
:-include("auxiliares.pl").
:-include("rua.pl").
:-set_prolog_flag(answer_write_options,[max_depth(0)]).
:-set_prolog_flag(stack_limit, 10 000 000 000).
:-dynamic move/3.
:-dynamic rua/7.

rua(-9.13440,38.69784,0,"Garagem","Rua do Alecrim","",0).
move(0,15805,0.01357).



rua(-9.16239,38.71291,9999,"Depósito","R Remolares","Garagem",0).
move(15868,9999,0.01932).
move(9999,0,0.03179).

inicio(0).
fim(0).

% Procura Não Informada

% Depth First
depthFirst(Nodo, Destino, [Nodo|Caminho],Custo):-
    statistics(runtime,[Start|_]),
        depth(Nodo, Destino, [Nodo], Caminho2, Custo),
        length(Caminho2,C),
        C > 2,
    fim(F),
    completaCaminho(Caminho2,[F],Caminho),
    statistics(runtime,[Stop|_]),
    Runtime is Stop-Start,
    write("Tempo: "),write(Runtime).

depth(Destino, Destino, _, [], 0).

depth(Nodo, Destino, Visited, [ProxNodo|Caminho],Custo):-
    adjacente(Nodo, ProxNodo,CustoRua),
    \+ member(ProxNodo, Visited),
    depth(ProxNodo, Destino, [Nodo|Visited], Caminho, CustoAcumulado),
    Custo is CustoRua + CustoAcumulado.

% Breadth First
breadthFirst(Nodo, Fim, Caminho, Custo):-
    statistics(runtime,[Start|_]),
    breadth(Fim, [[Nodo]], Caminho2),
    length(Caminho2,C),
    C > 2,
    calcularCusto(Caminho2,Custo),
    fim(F),
    completaCaminho(Caminho2,[F],Caminho),
    statistics(runtime,[Stop|_]),
    Runtime is Stop-Start,
    write("Tempo: "),write(Runtime).

breadth(Fim, [[Fim|T]|_], Caminho):-
    inverso([Fim|T],Caminho).

breadth(Fim,[H|T],Caminho):-
    H = [Atual|_],
    findall([X|H],
        (Dest\==Atual,adjacente(Atual,X,_),\+ member(X,H)),
        Novos),
    append(T,Novos,Todos),
    breadth(Fim,Todos,Caminho).

adjacente(Nodo, NodoProx, Distancia):-
    move(Nodo, NodoProx, Distancia).

adjacente(Nodo, NodoProx, Distancia):-
    move(NodoProx, Nodo, Distancia).

completaCaminho(Caminho,Adicional,Final):-
    append(Caminho,Adicional,Final).

calcularCusto([_],0).   
calcularCusto([],0).
calcularCusto([Nodo,NodoProx|T],Custo):-
    adjacente(Nodo,NodoProx,CustoLigacao),
    calcularCusto([NodoProx|T],CustoAcumulado),
    Custo is CustoLigacao + CustoAcumulado.

% Busca Iterativa Limitada em Profundidade
depthIterativeSearch(Nodo, Destino, [Nodo|Caminho],Custo, Altura):-
    statistics(runtime,[Start|_]),
    depthIterative(Nodo, Destino, [Nodo], Caminho2, Custo, Altura),
    length(Caminho2,C),
    C > 2,
    fim(F),
    completaCaminho(Caminho2,[F],Caminho),
    statistics(runtime,[Stop|_]),
    Runtime is Stop-Start,
    write("Tempo: "),write(Runtime).

depthIterative(Destino,Destino,_,[],0,Altura):-
    Altura >= 0.

depthIterative(Nodo, Destino, Visited, [ProxNodo|Caminho], Custo, Altura):-
    adjacente(Nodo, ProxNodo,CustoRua),
    \+ member(ProxNodo, Visited),
    AlturaReduzida is Altura - 1,
    depthIterative(ProxNodo, Destino, [Nodo|Visited], Caminho, CustoAcumulado, AlturaReduzida),
    Custo is CustoRua + CustoAcumulado.

% Procura Seletiva  
depthSelectiveSearch(Nodo, Destino, [Nodo|Caminho], Custo, Pontos):-
    depthSelective(Nodo, Destino, [Nodo], Caminho2, Custo, Pontos),
    length(Caminho2,C),
    C > 2,
    fim(F),
    completaCaminho(Caminho2,[F],Caminho).

depthSelective(Destino, Destino, _, [], 0, Pontos).

depthSelective(Nodo, Destino, Visited, [ProxNodo|Caminho],Custo, Pontos):-
    adjacente(Nodo, ProxNodo,CustoRua),
    \+ member(ProxNodo, Visited),
    member(ProxNodo,Pontos),
    depthSelective(ProxNodo, Destino, [Nodo|Visited], Caminho, CustoAcumulado, Pontos),
    Custo is CustoRua + CustoAcumulado.


% Circuito com mais pontos de recolha
circuitoMaisPontos(Nodo, Destino, [Nodo|Caminho],Custo,L):-
    findall(([Nodo|Caminho],C),(depthFirst(Nodo, Destino, [Nodo|Caminho],Custo), length([Nodo|Caminho],C)),L2),
    maximo(L2,L).

% Circuito mais rápido
circuitoMaisRapido(Nodo, Destino, [Nodo|Caminho],Custo,L):-
    findall(([Nodo|Caminho],Custo),depthFirst(Nodo, Destino, [Nodo|Caminho],Custo),L2),
    minimo(L2,L).

% Procura Informada

estima(Nodo, NodoProx,R):-
	rua(Lat1,Long1,Nodo,_,_,_,_),
	rua(Lat2,Long2,NodoProx,_,_,_,_),
	distanciaEuclidiana(Lat1,Lat2,Long1,Long2,R).

distanciaEuclidiana(X1,X2,Y1,Y2, R):- 
	R is sqrt((X2-X1)^2 + (Y2-Y1)^2).

% A*

resolveAEstrela(Nodo, Fim, Caminho/Custo) :-
    statistics(runtime,[Start|_]),
    estima(Nodo, Destino, Estimativa),
    aestrela([[Nodo]/0/Estima], Fim, CaminhoInverso/Custo/_),
    inverso(CaminhoInverso, Caminho2),
    length(Caminho2,C),
    C > 2,
    fim(F),
    completaCaminho(Caminho2,[F],Caminho),
    statistics(runtime,[Stop|_]),
    Runtime is Stop-Start,
    write("Tempo: "),write(Runtime).

aestrela(Caminhos, Fim, Caminho) :-
	obtem_melhor(Caminhos, Caminho),
	Caminho = [Nodo|_]/_/_,
    Nodo == Fim.

aestrela(Caminhos, Fim, SolucaoCaminho) :-
    obtem_melhor(Caminhos, MelhorCaminho),
    seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
    expandeAEstrela(MelhorCaminho, Fim, ExpCaminhos),
    append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
    aestrela(NovoCaminhos, Fim, SolucaoCaminho).

obtem_melhor([Caminho], Caminho) :- !.

obtem_melhor([Caminho1/Custo1/Est1,_/Custo2/Est2|Caminhos], MelhorCaminho) :-
	Custo1 + Est1 =< Custo2 + Est2, !,
	obtem_melhor([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho).
	
obtem_melhor([_|Caminhos], MelhorCaminho) :- 
	obtem_melhor(Caminhos, MelhorCaminho).
    
expandeAEstrela(Caminho, Fim, ExpCaminhos) :-
findall(NovoCaminho, adjacenteG(Caminho,Fim,NovoCaminho), ExpCaminhos).

adjacenteG([Nodo|Caminho]/Custo/_, Fim, [ProxNodo,Nodo|Caminho]/NovoCusto/Est) :-
	adjacente(Nodo, ProxNodo, PassoCusto),\+ member(ProxNodo, Caminho),
	NovoCusto is Custo + PassoCusto,
	estima(ProxNodo,Fim, Est).

% Greedy
resolveGulosa(Nodo, Destino, Caminho/Custo) :-
    statistics(runtime,[Start|_]),
    estima(Nodo, Destino, Estimativa),
    agulosa([[Nodo]/0/Estimativa], Destino, CaminhoInverso/Custo/_),
    inverso(CaminhoInverso, Caminho2),
    length(Caminho2,C),
    C >  2,
    fim(F),
    completaCaminho(Caminho2,[F],Caminho),
    statistics(runtime,[Stop|_]),
    Runtime is Stop-Start,
    write("Tempo: "),write(Runtime).

agulosa(Caminhos, Destino, Caminho) :-
    obtem_melhor_g(Caminhos, Caminho),
    Caminho = [Destino|_]/_/_.

agulosa(Caminhos, Destino, SolucaoCaminho) :-
    obtem_melhor_g(Caminhos, MelhorCaminho),
    seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
    expandeGulosa(MelhorCaminho, ExpCaminhos, Destino),
    append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
    agulosa(NovoCaminhos, Destino, SolucaoCaminho).

obtem_melhor_g([Caminho], Caminho) :- !.

obtem_melhor_g([Caminho1/Custo1/Est1,_/Custo2/Est2|Caminhos], MelhorCaminho) :-
	Est1 =< Est2, !,
	obtem_melhor_g([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho).

obtem_melhor_g([_|Caminhos], MelhorCaminho) :- 
	obtem_melhor_g(Caminhos, MelhorCaminho).

expandeGulosa(Caminho, ExpCaminhos, Destino) :-
	findall(NovoCaminho, adjacenteG(Caminho, Destino,NovoCaminho), ExpCaminhos).
