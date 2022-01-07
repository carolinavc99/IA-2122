:- [grafo].
:- [datahora].
:- [base_conhecimento].

% Pesquisa informada
:- [gulosa].
:- [aestrela].

% Pesquisa não informada
:- [profundidade].
:- [largura].
:- [iterativa].

% conhecimento e evolução
:- [conhecimento].

:- [multi_entrega].

% ------ REGRAS PARA EVITAR WARNINGS ------
:- style_check(-discontiguous).
:- style_check(-singleton).

:- discontiguous excecao/1.

:-dynamic circuito/6.

% ------ VARIÁVEIS GLOBAIS ------
lista_veiculos(L) :- findall(Veiculo, veiculo(Veiculo,_,_,_), L).
lista_ruas(L) :- findall(Rua, rua(Rua,_), L).
lista_algoritmos(L) :- L is [aestrela, gulosa, profundidade, largura, iterativa].

% ------ OBJETIVOS SEGUNDA FASE ------
% (1) gerar circuitos de entrega para cada rua

%circuito(algoritmo, rua_entrega, [caminho], custo, peso, volume).
gerar_circuitos :-
    circuitos_aestrela,
    circuitos_gulosa,
    circuitos_profundidade,
    circuitos_largura,
    circuitos_iterativa.

% (2) representação dos diversos pontos de entrega em forma de grafo

% --- os circuitos a comparar são por exemplo para a rua10 usando as diferentes pesquisas ---
% Incrementar circuitos para que possam ser comparados
incrementa_circuito(Algoritmo, Rua, Volume, Peso) :-
    circuito(Algoritmo, Rua, Ca, C, V, P),
    X is Volume + V,
    Y is Peso + P,
    retract(circuito(Algoritmo, Rua, Ca, C, V, P)),
    assert(circuito(Algoritmo, Rua, Ca, C, X,Y)).

% (3) identificar quais os circuitos com maior número de entregas (por volume e por peso)
maior_numero_entregas:-
    findall(V, circuito(_, _, _, _, _, V), Vx),
    findall(P, circuito(_, _, _, _, P, _), Px),
    max_list(Vx, MaxV),
    max_list(Px, MaxP),
    circuito(A1, R1, Ca1, C1, P1, MaxV),
    circuito(A2, R2, Ca2, C2, MaxP, V2),
    write('Circuito com maior volume total entregue: '),nl,
    write('Algoritmo - '), write(A1),nl,
    write('Rua - '), write(R1),nl,
    write('Peso - '), write(P1),nl,
    write('Volume - '), write(MaxV),nl,
    write('Caminho - '), write(Ca1), nl,
    write('Custo - '), write(C1), nl,
    nl,
    write('Circuito com maior peso total entregue: '),nl,
    write('Algoritmo - '), write(A2),nl,
    write('Rua - '), write(R2),nl,
    write('Peso - '), write(MaxP),nl,
    write('Volume - '), write(V2),nl,
    write('Caminho - '), write(Ca2), nl,
    write('Custo - '), write(C2), nl,
    !.

% (4) comparar circuitos de entrega tendo em conta os indicadores de produtividade
%tempo
%distancia

% (5) escolher o circuito mais rápido (critério de distância)

% (6) escolher o circuito mais ecológico (critério de tempo)


% ------ Auxiliares às pesquisas ------    
seleciona(E, [E|Xs], Xs).
seleciona(E, [X|Xs], [X|Ys]) :- seleciona(E, Xs, Ys).

membro(X, [X|_]).
membro(X, [_|Xs]) :- membro(X,Xs).

% -----------------------------------------
% ------ FUNCIONALIDADES NECESSÁRIAS ------
% -----------------------------------------
% Criar novo estafeta
criar_estafeta(EstId, Nome) :-
    evolucao(estafeta(EstId, Nome)).

% Criar nova encomenda
criar_encomenda(EncId, Tempo, Peso, Volume, Rua, ClienteId) :- 
    (encomenda(EncId, _,_,_,_,_,_,_) -> write('Id  da encomenda já existe.');
        (datahora(Data),
        preco(Tempo, Preco),
        cliente(ClienteId, Nome, _),
        rua(Rua,_),
        evolucao(encomenda(EncId, Data, Tempo, Peso, Volume, Rua, ClienteId)),
        write('Encomenda realizada:\nCliente: '), write(Nome), write(' '), write(ClienteId),
            write('\nData atual: '), write(Data), 
            write('\nTempo limite de entrega: '), write(Tempo), 
            write('\nPeso: '), write(Peso),
            write('\nVolume: '), write(Volume),
            write('\nPreço: '), write(Preco),
            write('\nRua: '), write(Rua)
        )
    ).

% Criar nova freguesia
criar_freguesia(Id) :-
    evolucao(freguesia(Id)),
    write('Freguesia criada.').

% Criar nova rua
criar_rua(RId, FId) :-
    evolucao(rua(RId,FId)),
    write('Rua criada.').

% Criar novo cliente
criar_cliente(ClienteId, Nome, Rua) :-
    evolucao(cliente(ClienteId,Nome,Rua)),
    write('Cliente criado.').

% Criar nova entrega
% ao fazer entrega ele acede à lista de circuitos e aumenta os contadors peso e volume
criar_entrega(EntId, EncId, EstId, Class, Algoritmo) :-
    encomenda(EncId,_,_,Peso,Volume,_,Rua,_),
    estafeta(EstId,_),
    Class =< 5, Class >= 0,
    % criar circuito
    sup_veiculo_encomenda(EncId, Algoritmo, Veiculo),
    incrementa_circuito(Algoritmo, Rua, Volume, Peso),
    evolucao(entrega(EntId, EncId, EstId, Class, Veiculo)).

% ele é que escolhe o algoritmo, tentando que tenha o custo mínimo
criar_entrega_rapida(EntId,EncId,EstId,Class):-
    encomenda(Enc,_,_,Peso,Volume,_,Rua,_),
    estafeta(Est,_),
    Class =< 5, Class >= 0,
    veiculo_encomenda_rapida(EncId, Algoritmo, Veiculo),
    incrementa_circuito(Algoritmo, Rua, Volume, Peso),
    evolucao(entrega(EntId, EncId, EstId, Class, Veiculo)).

% ele é que escolhe o algoritmo, tentando que tenha o veiculo mais ecologico
criar_entrega_ecologica(EntId,EncId,EstId,Class):-
    encomenda(Enc,_,_,Peso,Volume,_,Rua,_),
    estafeta(Est,_),
    Class =< 5, Class >= 0,
    veiculo_encomenda_ecologica(EncId, Algoritmo, Veiculo),
    incrementa_circuito(Algoritmo, Rua, Volume, Peso),
    evolucao(entrega(EntId, EncId, EstId, Class, Veiculo)).

% ------ FUNCIONALIDADES PEDIDAS ------
% (1) O estafeta que utilizou mais vezes um meio de transporte mais ecológico
f1_estafetaEcologico(R) :- f1_aux(R,_).

% Por ordem de mais amigo do ambiente para menos
f1_aux(Elem,usainBolt) :- findall(Estafeta,entrega(_,_,Estafeta,_,usainBolt),Lista),elemento_mais_frequente(Lista,Elem).
f1_aux(Elem,bicicleta) :- findall(Estafeta,entrega(_,_,Estafeta,_,bicicleta),Lista),elemento_mais_frequente(Lista,Elem).
f1_aux(Elem,mota) :- findall(Estafeta,entrega(_,_,Estafeta,_,mota),Lista),elemento_mais_frequente(Lista,Elem).
f1_aux(Elem,carro) :- findall(Estafeta,entrega(_,_,Estafeta,_,carro),Lista),elemento_mais_frequente(Lista,Elem).
f1_aux(Elem,rollsRoyce) :- findall(Estafeta,entrega(_,_,Estafeta,_,rollsRoyce),Lista),elemento_mais_frequente(Lista,Elem).
f1_aux(Elem,jato) :- findall(Estafeta,entrega(_,_,Estafeta,_,jato),Lista),elemento_mais_frequente(Lista,Elem).
f1_aux(Elem,fogetao) :- findall(Estafeta,entrega(_,_,Estafeta,_,fogetao),Lista),elemento_mais_frequente(Lista,Elem).

% (2) Que estafetas entregaram determinadas encomendas a determinado cliente
f2_estafetasCliente(C,R):-
    findall((Encomenda, Estafeta), (entrega(_, Encomenda, Estafeta,_,_), encomenda(Encomenda, _,_,_,_,_,_,C)), R).

% (3) Os clientes servidos por determinado estafeta
f3_clientesEstafeta(E,R):-
    findall(Cliente, (entrega(_, Encomenda, E,_,_), encomenda(Encomenda, _,_,_,_,_,_,Cliente)), L),
    sort(L,R).

% (4) O valor faturado pela Green Distribution num determinado dia
f4_faturacaoDia(D/M/A,R):-
    findall(Preco, (entrega(_, Encomenda,_,_,_), encomenda(Encomenda, D/M/A/_/_,_,_,Preco,_,_,_)), Precos),
    sumlist(Precos,R).

% (5) As zonas com maior volume de entregas
% Interpreto em: imprime as zonas por ordem de número de entregas, zona pode ser rua ou freguesia
f5_zonasMaiorVolume(rua,RuasN):-
        findall(Rua, 
            (entrega(_,Encomenda,_,_,_), 
            encomenda(Encomenda,_,_,_,_,_,Rua,_)),
            Ruas),
        f5_aux(Ruas,RuasN).

f5_zonasMaiorVolume(freguesia,FreguesiasN):-
        findall(Freguesia, 
            (entrega(_,Encomenda,_,_,_), 
            encomenda(Encomenda,_,_,_,_,_,Rua,_),
            rua(Rua,Freguesia)), 
            Freguesias),
        f5_aux(Freguesias,FreguesiasN).

% (6) Classificação média de um dado estafeta
f6_classificacaoMedia(E,R) :-
    findall(Class, entrega(_,_,E,Class,_), Classes),
    length(Classes, Length),
    Length =\= 0,
    sumlist(Classes, Sum),
    R is div(Sum, Length).

% (7) Número total de entregas pelos meios de transporte, em determinado intervalo de tempo
f7_entregasVeiculoIntervalo(V,Ii,If,R) :- % veiculo, intervalo inicial, intervalo final, resposta
    findall(Entrega, 
    (entrega(Entrega, Encomenda,_,_,V), 
        encomenda(Encomenda, I,_,_,_,_,_,_),
        datahora_intervalo(I, Ii, If)),
    Lista),
    length(Lista,R).

% (8) Número total de entregas pelos estafetas, em determinado intervalo de tempo
% por 'estafetas' (plural), interpreto todas as entregas num dado intervalo de tempo
f8_entregasEstafetaIntervalo(Ii, If, R) :-
    findall(Entrega, 
    (entrega(Entrega, Encomenda,_,_,_),
        encomenda(Encomenda, I,_,_,_,_,_,_),
        datahora_intervalo(I, Ii, If)),
    Lista),
    length(Lista,R).

% (9) Número de encomendas entregues e não entregues pela Green Distribution, num determinado período de tempo
f9_encomendasEntreguesIntervalo(Ii, If) :-
    findall(Entrega, (entrega(Entrega, Encomenda,_,_,_) , encomenda(Encomenda, I,_,_,_,_,_,_), datahora_intervalo(I, Ii, If)), Entregas),
    % Sabendo quantas foram entregues, então o resto não foi entregue, logo Total - Entregue = NEntregue
    findall(EncID, (encomenda(EncID, I,_,_,_,_,_,_), datahora_intervalo(I, Ii, If)), EncomendasTotal),
    length(Entregas, E),
    length(EncomendasTotal, ET),
    NE is ET - E,
    write('Encomendas entregues: '), write(E), write('\nEncomendas não entregues: '), write(NE).

% (10) Peso total transportado por um estafeta num determinado dia
f10_pesoEstafetaDia(Estafeta,D/M/A,R) :-
    % encontrar todas as encomendas que o estafeta entregou
    % filtrar encomendas daquele dia
    findall(Peso, (entrega(_, Encomenda, Estafeta,_,_), encomenda(Encomenda, D/M/A/_/_,_,Peso,_,_,_,_)), Pesos),
    % somatório do peso
    sumlist(Pesos,R).

% ------ FUNCIONALIDADES EXTRA ------
% (1) menu
% em baixo

% (2) mais meios de transporte
% em cima ^


% ------ PREDICADOS AUXILIARES ------
% Calcula o preço da encomenda: 10 (base) + 48 - tempo_em_horas
preco(TLimite, P) :-
    (TLimite > 48 -> write('Tempo máximo de agendamento é 48 horas.');
        P is 10 + 48 - TLimite).

% Calcula o tempo de entrega de uma encomenda considerando o decréscimo de velocidade comforme o peso
tempo_de_entrega(VelocidadeBaseVeiculo, DecrescimoVelocidadeVeiculo, Peso, Distancia, TempoViagem) :-
    VelocidadeVeiculo is VelocidadeBaseVeiculo - (DecrescimoVelocidadeVeiculo * Peso),
    TempoViagem is Distancia / VelocidadeVeiculo.

% Calcula o tempo de regresso de uma entrega
tempo_de_regresso(VelocidadeBaseVeiculo, Distancia, TempoViagem) :- 
    tempo_de_entrega(VelocidadeBaseVeiculo, 0, 0, Distancia, TempoViagem).

% Calcula a distância (custo) para uma rua segundo um algoritmo
distancia_por_algoritmo(aestrela, Nodo, Distancia) :- % destino
    resolve_aestrela(Nodo, _/Distancia).
distancia_por_algoritmo(gulosa, Nodo, Distancia) :- % destino
    resolve_gulosa(Nodo, _/Distancia).
distancia_por_algoritmo(profundidade, Nodo, Distancia) :- % origem destino
    primeiro_dfs(Nodo, _/Distancia).
distancia_por_algoritmo(largura, Nodo, Distancia) :- % origem destino
    primeiro_bfs(Nodo, _/Distancia).
distancia_por_algoritmo(iterativa, Nodo, Distancia) :- % origem destino
    primeiro_it(Nodo, _/Distancia).

% Determina o veículo a utilizar para uma encomenda
sup_veiculo_encomenda(EncID, Algoritmo, V) :- 
    lista_veiculos(Veiculos),
    veiculo_encomenda(EncID, Veiculos, V, Algoritmo).

veiculo_encomenda(EncID, [H|L], V, Algoritmo) :-
    encomenda(EncID, DataEncomenda, Prazo, Peso, _, _, RuaID, _),
    veiculo_encomenda_aux(DataEncomenda, Prazo, Peso, RuaID, V, Algoritmo).
veiculo_encomenda(EncID, [H|L], V, Algoritmo) :- !, veiculo_encomenda(EncID, L, V, Algoritmo).
veiculo_encomenda(_, [], _, _) :- write('Não é possível fazer esta encomenda.').


veiculo_encomenda_aux(DataEncomenda, Prazo, Peso, RuaID, Veiculo, Algoritmo) :- 
    % 0. calcular a distancia
    distancia_por_algoritmo(Algoritmo, RuaID, Distancia),
    % 1. calcular o tempo de viagem
    veiculo(Veiculo, Carga, VelocidadeBaseVeiculo, DecrescimoVelocidadeVeiculo),
    Peso =< Carga,
    tempo_de_entrega(VelocidadeBaseVeiculo, DecrescimoVelocidadeVeiculo, Peso, Distancia, TempoViagem),
    % 2. Testar se: data atual + tempo de viagem <= data da encomenda + prazo de entrega
    datahora(DataAtual),
    soma_horas_data(TempoViagem, DataAtual, DataComViagem),
    soma_horas_data(Prazo, DataEncomenda, DataLimite),
    datahoramenor(DataComViagem, DataLimite).
        
% devolve o algoritmo e o veiculo que dão o resultado com menos custo (mais rapido)
veiculo_encomenda_rapida(EncId, Algoritmo, Veiculo):-
    encomenda(EncId, _,_,Peso, _,_,Rua,_),
    
    % escolhe o algoritmo com menos custo
    findall(Custo, circuito(_, Rua, _, Custo, _, _), Circuitos),
    min_list(Circuitos, MinCusto),
    circuito(Algoritmo, Rua, _, MinCusto, _, _),
    
    % escolhe o veiculo que consegue ir mais rapido
    findall(Velocidade, veiculo(Vx, _, Velocidade,_), Velocidades),
    max_list(Velocidades, MaxVelocidade),
    veiculo(Veiculo, Carga, MaxVelocidade, Decrescimo).


% devolve o algoritmo e o veiculo que dão o resultado de menor tempo de entrega (mais ecologico)
veiculo_encomenda_ecologica(EncId, Algoritmo, Veiculo):-
    encomenda(EncId, DataEncomenda, Prazo, Peso, _,_, Rua, _),
    
    % tirar o custo mínimo
    findall(Custo, circuito(_, Rua, _, Custo, _, _), Custos),
    min_list(Custos, MinCusto),
    circuito(Algoritmo, Rua, _, MinCusto, _, _),

    % ver o primeiro veiculo que consegue entregar a tempo
    veiculo_encomenda_aux(DataEncomenda, Prazo, Peso, Rua, Veiculo, Algoritmo).


% Calcula a ordem dos elementos mais frequentes numa lista, de maior para menor, através de eliminação
f5_aux([],[]).
f5_aux(ListaAll,[Elem|ListaFinal]):-
        elemento_mais_frequente(ListaAll,Elem),
        delete(ListaAll,Elem,ListaIterada),
        f5_aux(ListaIterada,ListaFinal).

% Calcula o elemento mais frequente de uma lista
elemento_mais_frequente([],0).
elemento_mais_frequente(Lista, E) :-
    sort(Lista, [H|T]), % a sort limpa elementos repetidos
    elemento_mais_frequente_aux(Lista, [H|T], HN, _),
    E = HN.
    
elemento_mais_frequente_aux(Lista, [H], H, Frequencia) :-
    frequencia(H, Lista, Frequencia).
elemento_mais_frequente_aux(Lista, [H|T], H, Fx) :-
    frequencia(H, Lista, Fx),
    elemento_mais_frequente_aux(Lista, T, _, Frequencia),
    Frequencia =< Fx.
elemento_mais_frequente_aux(Lista, [H|T], Elemento, Frequencia) :-
    frequencia(H, Lista, Fx),
    elemento_mais_frequente_aux(Lista, T, Elemento, Frequencia),
    Frequencia > Fx.
    
% Calcula frequência de um elemento numa lista
frequencia(_, [], 0).
frequencia(E, [E|T], F) :- frequencia(E, T, F1), F is F1 + 1.
frequencia(E, [H|T], F) :- E \= H,
    frequencia(E, T, F).

% Gera o próximo ID disponível
gera_id(estafeta, R):-
    findall(ID, estafeta(ID, _), Lista),
    gera_id_aux(Lista, R).
gera_id(encomenda, R) :-
    findall(ID, encomenda(ID,_,_,_,_,_,_,_), Lista),
    gera_id_aux(Lista, R).
gera_id(cliente, R) :-
    findall(ID, cliente(ID, _, _), Lista),
    gera_id_aux(Lista, R).
gera_id(entrega, R) :-
    findall(ID, entrega(ID,_,_,_,_), Lista),
    gera_id_aux(Lista, R).
gera_id(freguesia, R) :-
    findall(ID, freguesia(ID), Lista),
    gera_id_aux(Lista, R).
gera_id(rua, R) :-
    findall(ID, rua(ID,_), Lista),
    gera_id_aux(Lista, R).

gera_id_aux(Lista, R):-
    max_list(Lista, Max),
    R is Max + 1.

% ------ Menu ------
fase1:-
    write('------------------------------------------------- FASE 1 -------------------------------------------------'),nl,
    write('1 - Estafeta que utilizou um meio de transporte mais ecológico mais vezes'),nl,
    write('2 - Estafetas que entregaram determinada(s) encomenda(s) a um determinado cliente'),nl,
    write('3 - Clientes servidos por determinado cliente'),nl,
    write('4 - Valor faturado pela Green Distribution num determinado dia'),nl,
    write('5 - Zonas com maior volume de entregas por parte da Green Distribution'),nl,
    write('6 - Classificação média de satisfação de cliente para um determinado estafeta'),nl,
    write('7 - Número total de entregas pelos diferentes meios de transporte num determinado intervalo de tempo'),nl,
    write('8 - Número total de entregas pelos estafetas num determinado intervalo de tempo'),nl,
    write('9 - Número de encomendas entregues e não entregues pela Green Distribution num determinado período de tempo'),nl,
    write('10 - Peso total transportado por estafeta num determinado dia'),nl,
    write('----------------------------------------------------------------------------------------------------------'),nl,
    write('0 - Sair'), nl,
    write('----------------------------------------------------------------------------------------------------------'),nl,
    read(Opcao), Opcao>=0, Opcao =<10,
    fazOpcao(f1, Opcao).

fase2:-
    write('------------------------------------------------- FASE 2 -------------------------------------------------'),nl,
    write('1 - Gerar circuitos de entrega'), nl,
    write('2 - Circuitos com maior número de entregas (por volume e por peso)'), nl,
    write('3 - Comparar circuitos de entrega tendo em conta os indicadores de produtividade'), nl,
    write('4 - Escolher o circuito mais rápido (por distância)'), nl,
    write('5 - Escolher o circuito mais ecológico (por tempo)'), nl,
    write('6 - Multi entrega'), nl,
    write('----------------------------------------------------------------------------------------------------------'),nl,
    write('0 - Sair'), nl,
    write('----------------------------------------------------------------------------------------------------------'),nl,
    read(Opcao), Opcao >= 0, Opcao =< 8,
    fazOpcao(f2, Opcao).

menu:-
    write('------------------------------------------------ IA 21/22 ------------------------------------------------'),nl,
    write('1 - Criar Estafeta'),nl,
    write('2 - Criar Encomenda'),nl,
    write('3 - Criar Freguesia'),nl,
    write('4 - Criar Rua'),nl,
    write('5 - Criar Cliente'),nl,
    write('6 - Criar Entrega'),nl,
    write('----------------------------------------------------------------------------------------------------------'),nl,
    write('7 - Fase 1'), nl,
    write('8 - Fase 2'), nl,
    write('----------------------------------------------------------------------------------------------------------'),nl,
    write('0 - Sair'), nl,
    write('----------------------------------------------------------------------------------------------------------'),nl,
    read(Opcao), Opcao >= 0, Opcao =< 8,
    fazOpcao(m, Opcao).

% Menu Principal
fazOpcao(m,1):-call_criar_estafeta, menu.
fazOpcao(m,2):-call_criar_encomenda, menu.
fazOpcao(m,3):-call_criar_freguesia, menu.
fazOpcao(m,4):-call_criar_rua, menu.
fazOpcao(m,5):-call_criar_cliente, menu.
fazOpcao(m,6):-call_criar_entrega, menu.
fazOpcao(m,7):-fase1.
fazOpcao(m,8):-fase2.
fazOpcao(m,0).

% Fase 1    
fazOpcao(f1,1):-call_f1, fase1.
fazOpcao(f1,2):-call_f2, fase1.
fazOpcao(f1,3):-call_f3, fase1.
fazOpcao(f1,4):-call_f4, fase1.
fazOpcao(f1,5):-call_f5, fase1.
fazOpcao(f1,6):-call_f6, fase1.
fazOpcao(f1,7):-call_f7, fase1.
fazOpcao(f1,8):-call_f8, fase1.
fazOpcao(f1,9):-call_f9, fase1.
fazOpcao(f1,10):-call_f10, fase1.
fazOpcao(f1,0):-menu.


% Fase 2
fazOpcao(f2,1):-gerar_circuitos, fase2.
fazOpcao(f2,2):-call_maior_numero_entregas, fase2.
fazOpcao(f2,3):-call_comparar_circuitos_indicadores, fase2.
fazOpcao(f2,4):-call_criar_entrega_rapida, fase2.
fazOpcao(f2,5):-call_criar_entrega_ecologica, fase2.
fazOpcao(f2,6):-call_comparar_multi_entrega, fase2.
fazOpcao(f2,0):-menu.


call_criar_estafeta:-
    gera_id(estafeta, Codigo),
    write('Nome (entre plicas): '), nl,
    read(Nome),
    criar_estafeta(Codigo,Nome),nl,nl.

call_criar_encomenda:-
    gera_id(encomenda, Codigo),
    write('Tempo de entrega: '),nl,
    read(Tempo),
    write('Peso: '),nl,
    read(Peso),
    write('Volume: '),nl,
    read(Volume),
    write('Rua: '),nl,
    read(Rua),
    write('Cliente: '),nl,
    read(Cliente),
    criar_encomenda(Codigo,Tempo,Peso,Volume,Rua,Cliente),
    write('Id de Encomenda: '), write(Codigo), nl.

call_criar_freguesia:-
    gera_id(freguesia, Codigo),
    criar_freguesia(Codigo).

call_criar_rua:-
    gera_id(rua, Rua),
    write('Código da freguesia: '),nl,
    read(Freguesia),
    criar_rua(Rua,Freguesia).

call_criar_cliente:-
    gera_id(cliente, Codigo),
    write('Nome: '),nl,
    read(Nome),
    write('Rua: '),nl,
    read(Rua),
    criar_cliente(Codigo,Nome,Rua).

call_criar_entrega:-
    gera_id(entrega, Entrega),
    write('Código de encomenda: '),nl,
    read(Encomenda),
    write('Código de estafeta: '),nl,
    read(Estafeta),
    write('Classificação (0-5): '),nl,
    read(Cls),
    write('Algoritmo (aestrela, gulosa, profundidade, largura, iterativa): '),nl,
    read(Algoritmo),
    encomenda(Encomenda,_,_,_,_,_,_,_),
    estafeta(Estafeta,_),
    criar_entrega(Entrega,Encomenda,Estafeta,Cls, Algoritmo),
    write('Id de Entrega: '), write(Entrega), nl.

call_f1:-
    f1_estafetaEcologico(R),
    write('Estafeta mais ecológico: '),nl,
    write(R),nl,nl.

call_f2:-
    write('Código de Cliente: '),nl,
    read(Codigo),
    f2_estafetasCliente(Codigo,R),
    write('(Encomenda,Estafeta)'),nl,
    write(R),nl,nl.

call_f3:-
    write('Código de Estafeta: '),nl,
    read(Codigo),
    f3_clientesEstafeta(Codigo,R),
    write('Clientes servidos por '), write(Codigo), write(': '),nl,
    write(R),nl,nl.

call_f4:-
    write('Data no formato: D/M/A/ (separado por barra): '),nl,
    read(Data),
    f4_faturacaoDia(Data,R), 
    write('Faturaram-se '), write(R), write('€'),nl,nl.

call_f5:-
    write('Rua/Freguesia: '),nl,
    read(Opcao),
    f5_zonasMaiorVolume(Opcao,R),
    write('Maior volume ---------> Menor Volume'),nl,
    write(R),nl,nl.

call_f6:-
    write('Código de Estafeta: '),nl,
    read(Codigo),
    f6_classificacaoMedia(Codigo,R),
    write('Classificação média: '), write(R),nl,nl.

call_f7:-
    write('Veículo: '),nl,
    read(Veiculo),
    write('Primeira Data no formato: D/M/A/Hora/Minuto (separado por barra): '),nl,
    read(Data1),
    write('Segunda Data no formato: D/M/A/Hora/Minuto (separado por barra): '),nl,
    read(Data2),
    f7_entregasVeiculoIntervalo(Veiculo,Data1,Data2,R),
    write('Entregas efetuadas de '),write(Veiculo),
    write(' no intervalo inserido: '), write(R),nl,nl.

call_f8:-
    write('Primeira Data no formato: D/M/A/Hora/Minuto (separado por barra): '),nl,
    read(Data1),
    write('Segunda Data no formato: D/M/A/Hora/Minuto (separado por barra): '),nl,
    read(Data2),
    f8_entregasEstafetaIntervalo(Data1,Data2,R),
    write('Entregas no intervalo de tempo selecionado: '), write(R),nl,nl.

call_f9:-
    write('Primeira Data no formato: D/M/A/Hora/Minuto (separado por barra): '),nl,
    read(Data1),
    write('Segunda Data no formato: D/M/A/Hora/Minuto (separado por barra): '),nl,
    read(Data2),
    f9_encomendasEntreguesIntervalo(Data1,Data2), nl,nl.

call_f10:-
    write('Estafeta: '),nl,
    read(Estafeta),
    write('Data no formato: D/M/A (separado por barra): '),nl,
    read(Data),
    f10_pesoEstafetaDia(Estafeta,Data,R),
    write('O peso total transportado por '), write(Estafeta),
    write(' é: '), write(R),nl,nl.


call_maior_numero_entregas:-
    maior_numero_entregas.

call_criar_entrega_ecologica:-
    gera_id(entrega, Codigo_entrega),
    write('Código de encomenda: '),nl,
    read(Codigo_encomenda),
    write('Código de estafeta: '),nl,
    read(Codigo_estafeta),
    write('Classificação (0-5): '),nl,
    read(Classificacao),
    encomenda(Codigo_encomenda,_,_,_,_,_,_,_),
    estafeta(Codigo_estafeta,_),
    criar_entrega_ecologica(Codigo_entrega,Codigo_encomenda,Codigo_estafeta,Classificacao),
    write('Id de Entrega: '), write(Codigo_entrega), nl.


call_criar_entrega_rapida:-
    gera_id(entrega, Codigo_entrega),
    write('Código de encomenda: '),nl,
    read(Codigo_encomenda),
    write('Código de estafeta: '),nl,
    read(Codigo_estafeta),
    write('Classificação (0-5): '),nl,
    read(Classificacao),
    encomenda(Codigo_encomenda,_,_,_,_,_,_,_),
    estafeta(Codigo_estafeta,_),
    criar_entrega_rapida(Codigo_entrega,Codigo_encomenda,Codigo_estafeta,Classificacao),
    write('Id de Entrega: '), write(Codigo_entrega), nl.

call_comparar_multi_entrega.


call_comparar_circuitos_indicadores:-
    % comparar distancia
    write('Distância:'),nl,
    write('------ Aestrela ------'), nl,
    findall(Distancia1, 
        circuito(aestrela,_, _, Distancia1, _, _), 
        ListaAE),
    sort(ListaAE, SortedAE),
    comparar_aux(SortedAE, aestrela, distancia),

    write('------ Gulosa ------'), nl,
    findall(Distancia2, 
        circuito(gulosa,_, _, Distancia2, _, _), 
        ListaG),
    sort(ListaG, SortedG),
    comparar_aux(SortedG, gulosa, distancia),

    write('------ Profundidade ------'), nl,
    findall(Distancia3, 
        circuito(profundidade,_, _, Distancia3, _, _), 
        ListaP),
    sort(ListaP, SortedP),
    comparar_aux(SortedP, profundidade, distancia),

    write('------ Largura ------'), nl,
    findall(Distancia4, 
        circuito(largura,_, _, Distancia4, _, _), 
        ListaL),
    sort(ListaL, SortedL),
    comparar_aux(SortedL, largura, distancia),

    write('------ Iterativa ------'), nl,
    findall(Distancia5, 
        circuito(iterativa,_, _, Distancia5, _, _), 
        ListaI),
    sort(ListaI, SortedI),
    comparar_aux(SortedI, iterativa, distancia),

    % comparar tempo de viagem
    write('Tempo de Viagem:'),nl,
    write('------ Aestrela ------'), nl,
    % extrair os tempos de entrega das encomendas
    findall((Enc6, Veiculo6, Rua6, Tempo6, Distancia6), (
        entrega(Ent6, Enc6, Est6, Class6, Veiculo6), 
        encomenda(Enc6, Data6, Prazo6, Peso6, Volume6, Preco6, Rua6, _),
        veiculo(Veiculo6, Carga6, Velocidade6, Decrescimo6),
        distancia_por_algoritmo(aestrela, Rua6, Distancia6),
        tempo_de_entrega(Velocidade6, Decrescimo6, Peso6, Distancia6, Tempo6)
        ), TemposAE),
    sort(TemposAE, STemposAE),
    comparar_aux(STemposAE, aestrela, tempo),

    write('------ Gulosa ------'), nl,
    % extrair os tempos de entrega das encomendas
    findall((Enc7, Veiculo7, Rua7, Tempo7, Distancia7), (
        entrega(Ent7, Enc7, Est7, Class7, Veiculo7), 
        encomenda(Enc7, Data7, Prazo7, Peso7, Volume7, Preco7, Rua7, _),
        veiculo(Veiculo7, Carga7, Velocidade7, Decrescimo7),
        distancia_por_algoritmo(gulosa, Rua7, Distancia7),
        tempo_de_entrega(Velocidade7, Decrescimo7, Peso7, Distancia7, Tempo7)
        ), TemposG),
    sort(TemposG, STemposG),
    comparar_aux(STemposG, gulosa, tempo),

    write('------ Profundidade ------'), nl,
    % extrair os tempos de entrega das encomendas
    findall((Enc8, Veiculo8, Rua8, Tempo8, Distancia8), (
        entrega(Ent8, Enc8, Est8, Class8, Veiculo8), 
        encomenda(Enc8, Data8, Prazo8, Peso8, Volume8, Preco8, Rua8, _),
        veiculo(Veiculo8, Carga8, Velocidade8, Decrescimo8),
        distancia_por_algoritmo(profundidade, Rua8, Distancia8),
        tempo_de_entrega(Velocidade8, Decrescimo8, Peso8, Distancia8, Tempo8)
        ), TemposP),
    sort(TemposP, STemposP),
    comparar_aux(STemposP, profundidade, tempo),

    write('------ Largura ------'), nl,
    % extrair os tempos de entrega das encomendas
    findall((Enc9, Veiculo9, Rua9, Tempo9, Distancia9), (
        entrega(Ent9, Enc9, Est9, Class9, Veiculo9), 
        encomenda(Enc9, Data9, Prazo9, Peso9, Volume9, Preco9, Rua9, _),
        veiculo(Veiculo9, Carga9, Velocidade9, Decrescimo9),
        distancia_por_algoritmo(largura, Rua9, Distancia9),
        tempo_de_entrega(Velocidade9, Decrescimo9, Peso9, Distancia9, Tempo9)
        ), TemposL),
    sort(TemposL, STemposL),
    comparar_aux(STemposL, largura, tempo),

    write('------ Iterativa ------'), nl,
    % extrair os tempos de entrega das encomendas
    findall((Enc8, Veiculo8, Rua8, Tempo8, Distancia8), (
        entrega(Ent8, Enc8, Est8, Class8, Veiculo8), 
        encomenda(Enc8, Data8, Prazo8, Peso8, Volume8, Preco8, Rua8, _),
        veiculo(Veiculo8, Carga8, Velocidade8, Decrescimo8),
        distancia_por_algoritmo(iterativa, Rua8, Distancia8),
        tempo_de_entrega(Velocidade8, Decrescimo8, Peso8, Distancia8, Tempo8)
        ), TemposI),
    sort(TemposI, STemposI),
    comparar_aux(STemposI, iterativa, tempo),
    nl.

comparar_aux([H|T], Algoritmo, distancia):-
    circuito(Algoritmo, Rua, Caminho, H, Peso, Volume),
    write('circuito('),
        write(Algoritmo), write(','), write(Rua), write(','), 
        write(Caminho), write(','), write(H), write(','), 
        write(Peso), write(','), write(Volume), write(')'),
    nl,!,
    comparar_aux(T, Algoritmo, distancia).


comparar_aux([(Enc, Veiculo, Rua, Tempo, Distancia)|T], Algoritmo, tempo):-
    % ver cada circuito que utilizam
    % ordenar esses circuitos
    circuito(Algoritmo, Rua, Caminho, Custo, Peso, Volume),
    write('Encomenda: '), write(Enc), write(' - '),
    write('circuito('),
        write(Algoritmo), write(','), write(Rua), write(','), 
        write(Caminho), write(','), write(Distancia), write(','), 
        write(Peso), write(','), write(Volume), write(')'),
    write(' - Tempo:'), write(Tempo),
    nl,!,
    comparar_aux(T, Algoritmo, tempo).


comparar_aux([], _, _):-nl.