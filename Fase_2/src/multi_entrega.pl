% ------ MULTI-ENTREGA ------
% multi_circuito(algoritmo, [ruas_entrega], [caminho], custo, peso, volume).

%multi_circuito(aestrela,Ruas,Caminho,Custo,Peso,Volume).

%multi_circuito(gulosa,Ruas,Caminho,Custo,Peso,Volume).
%tempo_de_entrega(VelocidadeBaseVeiculo, DecrescimoVelocidadeVeiculo, Peso, Distancia, TempoViagem)
multi_circuito(profundidade,Ruas,Caminho,TempoViagem,Peso):-
    get_caminho_profundidade(Ruas,Caminho,Custo),
    tempo_de_entrega(35,0.5,Peso,Custo,TempoViagem).
    %Caminho de centro para rua1
    %rua1 para rua2 etc
    %juntar caminhos em Caminho
multi_circuito(largura,Ruas,Caminho,TempoViagem,Peso):-
    get_caminho_largura(Ruas,Caminho,Custo),
    tempo_de_entrega(35,0.5,Peso,Custo,TempoViagem).

multi_circuito(iterativa,Ruas,Caminho,TempoViagem,Peso):-
    get_caminho_iterativa(Ruas,Caminho,Custo),
    tempo_de_entrega(35,0.5,Peso,Custo,TempoViagem).

get_caminho_iterativa([Local],Cam,C):-
    iterativa(Local,centro,Cam/C).
get_caminho_iterativa([Local_1,Local_2|T],Caminho,Custo):-
    iterativa(Local_1,Local_2,Cam/C),
    append(Cam,Tail,Caminho),
    get_caminho_iterativa([Local_2|T],[H|Tail],Custo_Recursividade),
    Custo is C+Custo_Recursividade.
get_caminho_iterativa([Local_1,Local_2|T],Caminho,Custo):-
    iterativa(Local_1,Local_2,Cam/C),
    append(Cam,Caminho_Recursividade,Caminho),
    get_caminho_iterativa([Local_2|T],Caminho_Recursividade,Custo_Recursividade),
    Custo is C+Custo_Recursividade.

get_caminho_largura([Local],Cam,C):-
    bfs(Local,centro,Cam/C).
get_caminho_largura([Local_1,Local_2|T],Caminho,Custo):-
    bfs(Local_1,Local_2,Cam/C),
    append(Cam,Tail,Caminho),
    get_caminho_largura([Local_2|T],[H|Tail],Custo_Recursividade),
    Custo is C+Custo_Recursividade.
get_caminho_largura([Local_1,Local_2|T],Caminho,Custo):-
    bfs(Local_1,Local_2,Cam/C),
    append(Cam,Caminho_Recursividade,Caminho),
    get_caminho_largura([Local_2|T],Caminho_Recursividade,Custo_Recursividade),
    Custo is C+Custo_Recursividade.

get_caminho_profundidade([Local],Cam,C):-
    dfs(Local,centro,Cam/C).
get_caminho_profundidade([Local_1,Local_2|T],Caminho,Custo):-
    dfs(Local_1,Local_2,Cam/C),
    append(Cam,Tail,Caminho),
    get_caminho_profundidade([Local_2|T],[H|Tail],Custo_Recursividade),
    Custo is C+Custo_Recursividade.
get_caminho_profundidade([Local_1,Local_2|T],Caminho,Custo):-
    dfs(Local_1,Local_2,Cam/C),
    append(Cam,Caminho_Recursividade,Caminho),
    get_caminho_profundidade([Local_2|T],Caminho_Recursividade,Custo_Recursividade),
    Custo is C+Custo_Recursividade.