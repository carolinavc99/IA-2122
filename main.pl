% ------ BASE DE CONHECIMENTO ------

% veículos - tipo (3), carga (máxima), velocidade (média), preço
veiculo(bicicleta, 5, 10, 5).
veiculo(mota, 20,35,10).
veiculo(carro, 100,25,15).

% estafetas - numero de identificação, nome
estafeta(est1, 'Lomberto Felgado').
estafeta(est2, 'Marie Madalaide').
estafeta(est3, 'Davim Ariezes').
estafeta(est4, 'Sofira Mangostim').
estafeta(est5, 'Miriana Rubardezes').

% encomenda - numero de identificação, datahora, tempo máximo de entrega, peso, volume, preço, rua, veiculo
% NOTA: o volume não vai interessar para cálculo nenhum, logo fica sempre 5
% para calcular o preço de uma entrega de carro, fazer: preco(Tempo_máximo_entrega, carro, P). P vai unificar com o preço.
% ATENÇÃO! Ter em atenção o peso da entrega porque cada veículo tem um limite de peso. Por exemplo é impossível ter uma entrega de 200kg pois nenhum veículo é capaz de carregar tal peso.
% ATENÇÃO! Ao criar encomenda (ainda não fiz esse predicado), o programa vai atribuir o veículo automaticamente. O que vai fazer é essencialmente ver qual é o veículo mais ecológico que consegue carregar essa encomenda, ou seja, começa por ver se a bicicleta a pode carregar. Se não, vê se a mota consegue. Se não, vê se o carro consegue.
% Logo, uma encomenda de 20 kilos é SEMPRE levada por uma mota, enquanto que uma encomenda de 30 kilos é sempre levada por um carro, e uma encomenda de 4 kilos é sempre levada por uma bicicleta.
encomenda(enc1, 1/1/2021/18/30, 2, 10, 5, 56, rua1).
encomenda(enc2, 20/7/2021/10/00, 24, 40, 5, 44, rua2).
encomenda(enc3, 20/7/2021/9/20, 4, 5, 5, 54, rua3).
encomenda(enc4, 20/7/2021/16/00, 1, 15, 5, 62, rua4).
encomenda(enc5, 2/8/2021/3/40, 4, 20, 5, 59, rua5).
encomenda(enc6, 2/8/2021/15/50, 6, 25, 5, 62, rua6).
encomenda(enc7, 2/8/2021/17/10, 2, 96, 5, 66, rua7).
encomenda(enc8, 2/8/2021/20/00, 2, 4, 5, 56, rua8).

% freguesias - codigo de identificação
freguesia(f1).
freguesia(f2).
freguesia(f3).
freguesia(f4).
freguesia(f5).

% ruas - codigo de identificação, id da freguesia
rua(r1, f1).
rua(r2, f1).
rua(r3, f2).
rua(r4, f2).
rua(r5, f3).
rua(r6, f3).
rua(r7, f4).
rua(r8, f4).
rua(r9, f5).
rua(r10, f5).

% clientes - numero de identificação, nome, id da rua de morada
cliente(c1, 'Filmina Ribano', r1).
cliente(c2, 'Santónio Mabalares', r2).
cliente(c3, 'Namuel Ponino', r3).
cliente(c4, 'Diliana Ramaz', r4).
cliente(c5, 'Sarina Compares', r5).
cliente(c6, 'Romana Sardezes', r6).
cliente(c7, 'Carminela Lopanor', r7).
cliente(c8, 'Iolina Rumos', r8).

% entregas - número de identificação, encomenda, estafeta, classificação (0-5), veiculo
entrega(ent1, enc1, est1, 5, bicicleta).
entrega(ent2, enc2, est2, 3, carro).
entrega(ent3, enc3, est3, 2, bicicleta).
entrega(ent4, enc4, est4, 1, mota).
entrega(ent5, enc5, est1, 4, mota).
entrega(ent6, enc6, est3, 2, carro).
entrega(ent7, enc7, est1, 4, bicicleta).

% ----------- GRAFO -----------
% 10 ruas
% as freguesias servem puramente para estatística, pelo que não se devem incluir no grafo
% o algoritmo de pesquisa a utilizar, por indicação do professor, é o de pesquisa gulosa. Logo fazer um grafo que vá de acordo com isso


% ------ FUNCIONALIDADES NECESSÁRIAS ------
% estas funcionalidades são, para *quando o programa está a correr*, fazer coisas do tipo: criar uma nova encomenda, criar um novo estafeta, fazer uma entrega, etc. Não é necessário fazer isto já, principalmente sem o grafo feito!
% pedir encomenda
% fazer entrega ( estafeta escolhe, aleatoriamente, o veículo)
% navegação?
% etc

% ------ FUNCIONALIDADES PEDIDAS ------
% (1) O estafeta que utilizou mais vezes um meio de transporte mais ecológico
%f1_estafetaEcologico(R) :- f1_aux(L,V).

f1_aux(L,bicicleta) :- findall(Estafeta,entrega(_,_,Estafeta,_,bicicleta),Lista),Lista \= [],!, L is Lista.
f1_aux(L,mota) :- findall(Estafeta,entrega(_,_,Estafeta,_,mota),Lista),Lista \= [],!, L is Lista.
f1_aux(L,carro) :- findall(Estafeta,entrega(_,_,Estafeta,_,carro),Lista),Lista \= [], L is Lista.

% (2) Que estafetas entregaram determinadas encomendas a determinado cliente
f2_estafetasCliente(C,R).

% (3) Os clientes servidos por determinado estafeta
f3_clientesEstafeta(E,R).

% (4) O valor faturado pela Green Distribution num determinado dia
f4_faturacaoDia(D,R).

% (5) As zonas com maior volume de entregas
f5_zonasMaiorVolume(R).

% (6) Classificação média de um dado estafeta
f6_classificacaoMedia(E,R).

% (7) Número total de entregas pelos meios de transporte, em determinado intervalo de tempo
f7_entregasVeiculoIntervalo(V,Ii,If,R).

% (8) Número total de entregas pelos estafetas, em determinado intervalo de tempo
% por "estafetas" (plural), interpreto todas as entregas num dado intervalo de tempo
f8_entregasEstafetaIntervalo(DI/MI/AI/HI/MiI, DF/MF/AF/HF/MiF, R) :-
    findall(Entrega, 
    (entrega(Entrega, Encomenda,_,_,_), 
        encomenda(Encomenda, D/M/A/H/Mi,_,_,_,_,_),
        f8_aux_intervalo(D/M/A/H/Mi, DI/MI/AI/HI/MiI, DF/MF/AF/HF/MiF)),
    R).

% True se datahora dada está entre o intervalo de tempo dado
f8_aux_intervalo(D/M/A/H/Mi, DI/MI/AI/HI/MiI, DF/MF/AF/HF/MiF) :- 
    datahoramenor(DI/MI/AI/HI/MiI, D/M/A/H/Mi),
    datahoramenor(D/M/A/H/Mi, DF/MF/AF/HF/MiF).

% (9) Peso total transportado por um estafeta num determinado dia
f9_pesoEstafetaDia(Estafeta,D/M/A,R) :-
    % encontrar todas as encomendas que o estafeta entregou
    % filtrar encomendas daquele dia
    findall(Peso, (entrega(_, Encomenda, Estafeta,_,_), encomenda(Encomenda, D/M/A/_/_,_,Peso,_,_,_)), Pesos),
    % somatório do peso
    sumlist(Pesos,R).

% encomenda(enc8, 2/8/2021/20/00, 2, (4,) 5, 56, rua8).

% ------ FUNCIONALIDADES EXTRA ------
% (esta secção é à nossa escolha)

% (1) implementar mais meios de transporte
    %veiculo(hoverboard, 5, 15, 2) % mais rapido que a bicicleta mas menos ecológico pois usa energia


% ------ PREDICADOS AUXILIARES ------
% Devolve a datahora atual no formato pedido
datahora(D/M/A/H/Min) :-
    get_time(Epoch),
    stamp_date_time(Epoch, DateTime, local),
    date_time_value(year, DateTime, A),
    date_time_value(month, DateTime, M),
    date_time_value(day, DateTime, D),
    date_time_value(hour, DateTime, H),
    date_time_value(minute, DateTime, Min).

% True se data1 é menor que data2
datahoramenor(D1/M1/A1/H1/Mi1, D2/M2/A2/H2/Mi2) :-
    % calcula o número de segundos desde o Epoch até à data dada
    date_time_stamp(date(A1,M1,D1,H1,Mi1,0,0,-,-), Stamp1),
    date_time_stamp(date(A2,M2,D2,H2,Mi2,0,0,-,-), Stamp2),
    R1 is integer(Stamp1),
    R2 is integer(Stamp2),
    R1 =< R2.

% Calcula o preço da encomenda: 5 (base) + 48 - tempo_em_horas + preço_veiculo
preco(TLimite, Veiculo, P) :-
    veiculo(Veiculo,_,_,PrecoVeiculo),
    P is 5 + 48 - TLimite + PrecoVeiculo.

% Determina qual o veículo a usar para a entrega
determinarVeiculo(Peso, Veiculo):-
    veiculo(MVeiculo, MPeso, _ , _),
    Peso =< MPeso,
    Veiculo is MVeiculo.

% Calcula o elemento mais frequente numa lista -- NÃO FUNCIONA --
elemento_mais_frequente(Lista, E) :-
    sort(Lista, [H|T]), % a sort limpa elementos repetidos
    elemento_mais_frequente_aux(Lista, [H|T], H, 0),
    E is H.
    
% -- NÃO FUNCIONA --
% este predicado está a matar-me não consigo fazer com recursividade de cauda decente
elemento_mais_frequente_aux(Lista, [H], H, Frequencia) :-
    frequencia(H, Lista, Frequencia).
elemento_mais_frequente_aux(Lista, [H|T], H, Frequencia) :-
    frequencia(H, Lista, Fx),
    elemento_mais_frequente_aux(Lista, T, H, Fx),
    Frequencia < Fx.
elemento_mais_frequente_aux(Lista, [H|T], Elemento, Frequencia) :-
    frequencia(H, Lista, Fx),
    elemento_mais_frequente_aux(Lista, T, Elemento, Frequencia),
    Frequencia > Fx.

% Calcula frequência de um elemento numa lista
frequencia(E, [], 0).
frequencia(E, [E|T], F) :- frequencia(E, T, F1), F is F1 + 1.
frequencia(E, [H|T], F) :- frequencia(E, T, F).