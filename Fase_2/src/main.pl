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

% ------ REGRAS PARA EVITAR WARNINGS ------
:-style_check(-discontiguous).


% ------ OBJETIVOS SEGUNDA FASE ------
% gerar circuitos de entrega para cada rua, para cada pesquisa

% --DONE-- representação dos diversos pontos de entrega em forma de grafo

% --- os circuitos a comparar são por exemplo para a rua10 usando as diferentes pesquisas ---
% identificar quais os circuitos com maior número de entregas (por volume e por peso)
maior_numero_entregas(R).

% comparar circuitos de entrega tendo em conta os indicadores de produtividade
%melhor_circuito(tempo,).
%melhor_circuito(distancia,)
% escolher o circuito mais rápido (critério de distância)
% escolher o circuito mais ecológico (critério de tempo)

% ------ CIRCUITOS ------
circuito(RuaID, EstadoInicial, [H|T], EstadoFinal).

% ------ Auxiliares às pesquisas ------

% Obtém melhor caminho de uma lista
obtem_melhor([Caminho],Caminho) :- !.

obtem_melhor([Caminho1/Custo1/Est1,Caminho2/Custo2/Est2|Caminhos], MelhorCaminho) :-
    Custo1 + Est1 =< Custo2 + Est2, !,
    obtem_melhor([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho).

obtem_melhor([_|Caminhos], MelhorCaminho) :- % caso caminho 2 seja melhor que caminho 1 (da cláusula anterior), este último é descartado
    obtem_melhor(Caminhos, MelhorCaminho).
    
seleciona(E, [E|Xs], Xs).
seleciona(E, [X|Xs], [X|Ys]) :- seleciona(E, Xs, Ys).

membro(X, [X|_]).
membro(X, [_|Xs]) :- membro(X,Xs).

% -----------------------------------------
% ------ FUNCIONALIDADES NECESSÁRIAS ------
% -----------------------------------------
% Criar novo estafeta
criar_estafeta(EstId, Nome) :-
    (estafeta(EstId, _) -> write("Id do estafeta já existe.");
        assert(estafeta(EstId, Nome)),
        write("Estafeta criado.")).

% Criar nova encomenda
criar_encomenda(EncId, Tempo, Peso, Volume, Rua, ClienteId) :- 
    (encomenda(EncId, _,_,_,_,_,_,_) -> write("Id  da encomenda já existe.");
        (datahora(Data),
        preco(Tempo, Peso, Preco),
        cliente(ClienteId, Nome, _),
        rua(Rua,_),
        assert(encomenda(EncId, Data, Tempo, Peso, Volume, Rua, ClienteId)),
        write("Encomenda realizada:\nCliente: "), write(Nome), write(" "), write(ClienteId),
            write("\nData atual: "), write(Data), 
            write("\nTempo limite de entrega: "), write(Tempo), 
            write("\nPeso: "), write(Peso),
            write("\nVolume: "), write(Volume),
            write("\nPreço: "), write(Preco),
            write("\nRua: "), write(Rua)
        )
    ).

% Criar nova freguesia
criar_freguesia(Id) :-
    (freguesia(Id) -> write("Freguesia já existe.\n");
        assert(freguesia(Id)),
        write("Freguesia criada.")).

% Criar nova rua
criar_rua(RId, FId) :-
    (rua(RId, _) -> write("Rua já existe.\n");
    assert(rua(RId, FId)),
    write("Rua criada.")).

% Criar novo cliente
criar_cliente(ClienteId, Nome, Rua) :-
    (cliente(ClienteId,_,_) -> write("Id do cliente já existe.");
        assert(cliente(ClienteId, Nome, Rua)),
        write("Cliente criado.")).

% Criar nova entrega
criar_entrega(EntId, EncId, EstId, Class, Veiculo) :-
    (entrega(EntId,_,_,_,_) -> write("Id da entrega já existe.");
        encomenda(EncId,_,_,_,_,_,_,_),
        estafeta(EstId,_),
        veiculo(Veiculo,_,_,_),
        Class =< 5, Class >= 0,
        assert(entrega(EncId, EncId, EstId, Class, Veiculo))).

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
% por "estafetas" (plural), interpreto todas as entregas num dado intervalo de tempo
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
    write("Encomendas entregues: "), write(E), write("\nEncomendas não entregues: "), write(NE).

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
% Calcula o preço da encomenda: 5 (base) + 48 - tempo_em_horas + preço_veiculo
preco(TLimite, Peso, P) :-
    (TLimite > 48 -> write("Tempo máximo de agendamento é 48 horas."); 
        veiculo_encomenda(Peso, Veiculo),
        veiculo(Veiculo,_,_,PrecoVeiculo),
        P is 5 + 48 - TLimite + PrecoVeiculo).

% Calcula o tempo de entrega de uma encomenda considerando o decréscimo de velocidade comforme o peso
tempo_de_entrega(VelocidadeBaseVeiculo, DecrescimoVelocidadeVeiculo, Peso, Distancia, TempoViagem) :-
    VelocidadeVeiculo is VelocidadeBaseVeiculo - (DecrescimoVelocidadeVeiculo * Peso),
    TempoViagem is VelocidadeVeiculo * Distancia.

% Determina o veículo a utilizar para uma encomenda a partir do peso (kg), da distância a percorrer (km), e do prazo limite de entrega (h)
veiculo_encomenda(Peso, EncID, Distancia, [H|L], R) :- % Distancia é calculada pelo algoritmo escolhido
    encomenda(EncID, DataEncomenda, Prazo, Peso, _, _, RuaID, ClienteID),
    % temos de chamar veiculo_encomenda_aux para todos os veículos EM ORDEM DE MAIS ECOLÓGICO PARA MENOS ECOLÓGICO *até* ser encontrado um veículo que consiga chegar ao ponto de entrega dentro do limite de tempo
    veiculo_encomenda_aux(Distancia, EncID, DataEncomenda, Prazo, Peso, RuaID, ClienteID, H),
    R is H.
veiculo_encomenda(Peso, EncID, Distancia, [H|L], R) :- veiculo_encomenda(Peso, EncID, Distancia, L, R).
veiculo_encomenda(Peso, EncID, Distancia, [], R) :- write('Não é possível fazer esta encomenda.').

veiculo_encomenda_aux(Distancia, DataEncomenda, Prazo, Peso, RuaID, ClienteID, Veiculo) :- 
    % 1. calcular o tempo de viagem tendo em conta o decréscimo de velocidade do veiculo
    tempo_de_entrega(VelocidadeBaseVeiculo, DecrescimoVelocidadeVeiculo, Peso, Distancia, TempoViagem),
    % 2. Testar se: data atual + tempo de viagem <= data da encomenda + prazo de entrega
    datahora(DataAtual),
    soma_horas_data(TempoViagem, DataAtual, DataComViagem),
    soma_horas_data(Prazo, DataEncomenda, DataLimite),
    DataComViagem =< DataLimite.


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

% ------ Menu ------
menu:-
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
    write('-----------------------------------------------------------------------------------------------------------'),nl,
    write('11 - Criar Estafeta'),nl,
    write('12 - Criar Encomenda'),nl,
    write('13 - Criar Freguesia'),nl,
    write('14 - Criar Rua'),nl,
    write('15 - Criar Cliente'),nl,
    write('16 - Criar Entrega'),nl,
    write('0 - Sair'), nl,
    read(Opcao), Opcao>=0, Opcao =<16,
    fazOpcao(Opcao).

fazOpcao(1):-call_f1,menu.
fazOpcao(2):-call_f2,menu.
fazOpcao(3):-call_f3,menu.
fazOpcao(4):-call_f4,menu.
fazOpcao(5):-call_f5,menu.
fazOpcao(6):-call_f6,menu.
fazOpcao(7):-call_f7,menu.
fazOpcao(8):-call_f8,menu.
fazOpcao(9):-call_f9,menu.
fazOpcao(10):-call_f10,menu.
fazOpcao(11):-call_criar_estafeta,menu.
fazOpcao(12):-call_criar_encomenda,menu.
fazOpcao(13):-call_criar_freguesia,menu.
fazOpcao(14):-call_criar_rua,menu.
fazOpcao(15):-call_criar_cliente,menu.
fazOpcao(16):-call_criar_entrega,menu.
fazOpcao(0):-halt.

call_criar_estafeta:-
    write('Código no formato estX: '), nl,
    read(Codigo),
    write('Nome (entre aspas): '), nl,
    read(Nome),
    criar_estafeta(Codigo,Nome),nl,nl.

call_criar_encomenda:-
    write('Código no formato encX: '),nl,
    read(Codigo),
    write('Tempo de entrega: '),nl,
    read(Tempo),
    write('Peso: '),nl,
    read(Peso),
    write('Volume: '),nl,
    read(Volume),
    write('Rua: '),nl,
    read(Rua),
    write('Código de Cliente no formato cliX: '),nl,
    read(Cliente),
    criar_encomenda(Codigo,Tempo,Peso,Volume,Rua,Cliente).

call_criar_freguesia:-
    write('Código no formato fX: '),nl,
    read(Codigo),
    criar_freguesia(Codigo).

call_criar_rua:-
    write('Código de rua no formato ruaX: '),nl,
    read(Rua),
    write('Código de freguesia no formato fX: '),nl,
    read(Freguesia),
    criar_rua(Rua,Freguesia).

call_criar_cliente:-
    write('Código no formato cliX: '),nl,
    read(Codigo),
    write('Nome: '),nl,
    read(Nome),
    write('Rua: '),nl,
    read(Rua),
    criar_cliente(Codigo,Nome,Rua).

call_criar_entrega:-
    write('Código de entrega no formato entX: '),nl,
    read(Codigo_entrega),
    write('Código de encomenda no formato encX: '),nl,
    read(Codigo_encomenda),
    write('Código de estafeta no formato estX: '),nl,
    read(Codigo_estafeta),
    write('Classificação (0-5): '),nl,
    read(Classificacao),
    encomenda(Codigo_encomenda,_,_,Peso,_,_,_,_),
    lista_veiculos(L),
    veiculo_encomenda(Peso, Codigo_encomenda, _, L, Veiculo),
    criar_entrega(Codigo_entrega,Codigo_encomenda,Codigo_estafeta,Classificacao,Veiculo).



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