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

% encomenda - numero de identificação, datahora, tempo máximo de entrega, peso, volume, preço, rua, cliente
% NOTA: o volume não vai interessar para cálculo nenhum, logo fica sempre 5
% para calcular o preço de uma entrega de carro, fazer: preco(Tempo_máximo_entrega, carro, P). P vai unificar com o preço.
% ATENÇÃO! Ter em atenção o peso da entrega porque cada veículo tem um limite de peso. Por exemplo é impossível ter uma entrega de 200kg pois nenhum veículo é capaz de carregar tal peso.
% ATENÇÃO! Ao criar encomenda (ainda não fiz esse predicado), o programa vai atribuir o veículo automaticamente. O que vai fazer é essencialmente ver qual é o veículo mais ecológico que consegue carregar essa encomenda, ou seja, começa por ver se a bicicleta a pode carregar. Se não, vê se a mota consegue. Se não, vê se o carro consegue.
% Logo, uma encomenda de 20 kilos é SEMPRE levada por uma mota, enquanto que uma encomenda de 30 kilos é sempre levada por um carro, e uma encomenda de 4 kilos é sempre levada por uma bicicleta.
encomenda(enc1, 1/1/2021/18/30, 2, 10, 5, 56, rua1,cli1).
encomenda(enc2, 20/7/2021/10/00, 24, 40, 5, 44, rua2,cli2).
encomenda(enc3, 20/7/2021/9/20, 4, 5, 5, 54, rua3, cli3).
encomenda(enc4, 20/7/2021/16/00, 1, 15, 5, 62, rua4, cli4).
encomenda(enc5, 2/8/2021/3/40, 4, 20, 5, 59, rua5, cli5).
encomenda(enc6, 2/8/2021/15/50, 6, 25, 5, 62, rua6, cli6).
encomenda(enc7, 2/8/2021/17/10, 2, 96, 5, 66, rua7, cli7).
encomenda(enc8, 2/8/2021/20/00, 2, 4, 5, 56, rua8, cli8).
encomenda(enc9, 2/8/2021/20/00, 2, 4, 5, 56, rua8, cli8).
encomenda(enc10, 20/7/2021/10/00, 24, 40, 5, 44, rua2,cli2).

% freguesias - codigo de identificação
freguesia(f1).
freguesia(f2).
freguesia(f3).
freguesia(f4).
freguesia(f5).

% ruas - codigo de identificação, id da freguesia
rua(rua1, f1).
rua(rua2, f1).
rua(rua3, f2).
rua(rua4, f2).
rua(rua5, f3).
rua(rua6, f3).
rua(rua7, f4).
rua(rua8, f4).
rua(rua9, f5).
rua(rua10, f5).

% clientes - numero de identificação, nome, id da rua de morada
cliente(cli1, 'Filmina Ribano', rua1).
cliente(cli2, 'Santónio Mabalares', rua2).
cliente(cli3, 'Namuel Ponino', rua3).
cliente(cli4, 'Diliana Ramaz', rua4).
cliente(cli5, 'Sarina Compares', rua5).
cliente(cli6, 'Romana Sardezes', rua6).
cliente(cli7, 'Carminela Lopanor', rua7).
cliente(cli8, 'Iolina Rumos', rua8).

% entregas - número de identificação, encomenda, estafeta, classificação (0-5), veiculo
entrega(ent1, enc1, est1, 5, bicicleta).
entrega(ent2, enc2, est2, 3, carro).
entrega(ent3, enc3, est3, 2, bicicleta).
entrega(ent4, enc4, est4, 1, mota).
entrega(ent5, enc5, est1, 4, mota).
entrega(ent6, enc6, est3, 2, carro).
entrega(ent7, enc7, est3, 4, bicicleta).
entrega(ent8, enc10, est2, 4, bicicleta).

% ----------- GRAFO -----------
% 10 ruas
% as freguesias servem puramente para estatística, pelo que não se devem incluir no grafo
% o algoritmo de pesquisa a utilizar, por indicação do professor, é o de pesquisa gulosa. Logo fazer um grafo que vá de acordo com isso


% ------ FUNCIONALIDADES NECESSÁRIAS ------
% Criar encomenda
criar_encomenda(EncId, Tempo, Peso, Volume, Rua, ClienteId) :- 
    datahora(Data),
    preco(Tempo, Peso, Preco),
    cliente(ClienteId, Nome, _),
    %id_prox_cliente(NumProxCliente),
    %Id is "cli"/NumProxCliente,
    veiculo_encomenda(Peso, Veiculo),
    assert(encomenda(EncId, Data, Tempo, Peso, Volume, Rua, ClienteId)),
    write("Encomenda realizada:\nCliente: "), write(Nome), write(" "), write(ClienteId),
        write("\nData atual: "), write(Data), 
        write("\nTempo limite de entrega: "), write(Tempo), 
        write("\nPeso: "), write(Peso),
        write("\nVeiculo: "), write(Veiculo),
        write("\nVolume: "), write(Volume),
        write("\nPreço: "), write(Preco),
        write("\nRua: "), write(Rua).

% Calcula número do Id do próximo cliente
id_prox_cliente(Id) :-
    findall(Cliente, cliente(Cliente,_,_), Clientes),
    length(Clientes, L),
    Id is L + 1.

% estas funcionalidades são, para *quando o programa está a correr*, fazer coisas do tipo: criar uma nova encomenda, criar um novo estafeta, fazer uma entrega, etc. Não é necessário fazer isto já, principalmente sem o grafo feito!
% pedir encomenda
% fazer entrega ( estafeta escolhe, aleatoriamente, o veículo)
% navegação?
% etc

% ------ FUNCIONALIDADES PEDIDAS ------
% (1) O estafeta que utilizou mais vezes um meio de transporte mais ecológico
f1_estafetaEcologico(R) :- f1_aux(R,_).

f1_aux(Elem,bicicleta) :- findall(Estafeta,entrega(_,_,Estafeta,_,bicicleta),Lista),elemento_mais_frequente(Lista,Elem).
f1_aux(Elem,mota) :- findall(Estafeta,entrega(_,_,Estafeta,_,mota),Lista),elemento_mais_frequente(Lista,Elem).
f1_aux(Elem,carro) :- findall(Estafeta,entrega(_,_,Estafeta,_,carro),Lista),elemento_mais_frequente(Lista,Elem).

% (2) Que estafetas entregaram determinadas encomendas a determinado cliente
f2_estafetasCliente(C,R):-
    findall((Encomenda, Estafeta), (entrega(_, Encomenda, Estafeta,_,_), encomenda(Encomenda, _,_,_,_,_,_,C)), R).

% (3) Os clientes servidos por determinado estafeta
f3_clientesEstafeta(E,R):-
    findall(Cliente, (entrega(_, Encomenda, E,_,_), encomenda(Encomenda, _/_/_,_,_,_,_,_,Cliente)), L),
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
f9_encomendasEntreguesIntervalo(DI/MI/AI/HI/MiI, DF/MF/AF/HF/MiF) :-
    findall(Entrega, (entrega(Entrega, Encomenda,_,_,_) , encomenda(Encomenda, D/M/A/H/Mi,_,_,_,_,_,_), datahora_intervalo(D/M/A/H/Mi, DI/MI/AI/HI/MiI, DF/MF/AF/HF/MiF)), Entregas),
    % Sabendo quantas foram entregues, então o resto não foi entregue, logo Total - Entregue = NEntregue
    findall(EncID, (encomenda(EncID, D/M/A/H/Mi,_,_,_,_,_,_), datahora_intervalo(D/M/A/H/Mi, DI/MI/AI/HI/MiI, DF/MF/AF/HF/MiF)), EncomendasTotal),
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

% Menu
menu:-
    write('1 - Estafeta que utilizou um meio de transporte mais ecológico mais vezes'),nl,
    write('2 - Estafetas que entregaram determinada(s) encomenda(s) a um determinado cliente'),nl,
    write('3 - Clientes servidos por determinado cliente'),nl,
    write('4 - Valor faturado pela Green Distribution num determinado dia'),nl,
    write('5 - Zonas com maior volume de entregas por parte da Green Distribution'),nl,
    write('6 - Classificação média de satisfação de cliente para um determinado estafeta'),nl,
    write('7 - Número total de entregas pelos diferentes meios de transporte num determinado intervalo de tempo'),nl,
    write('8 - Número total de entregas pelos estafetas num determinado intervalo de tempo'),nl,
    write('9 - Número de encomendas entregues e não entregues pela Green Distribution num determinado periodo de tempo'),nl,
    write('10 - Peso total transportado por estafeta num determinado dia'),nl,
    write('0 - Sair'), nl,
    read(Opcao), Opcao>0, Opcao =<10,
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

call_f1:-
    f1_estafetaEcologico(R),
    write('Estafeta mais ecológico: '),
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
    write('Dia: '),nl, 
    read(Dia),
    write('Mês: '),nl,
    read(Mes),
    write('Ano: '), nl,
    read(Ano),
    f4_faturacaoDia(Dia/Mes/Ano,R), 
    write('Faturaram-se '), write(R), write('€'),nl,nl.

call_f5:-
    write('rua/freguesia: '),nl,
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
    write('Primeira Data -> Dia: '),nl,
    read(Dia1),
    write('Priemira Data -> Mes: '),nl,
    read(Mes1),
    write('Primeira Data -> Ano: '),nl,
    read(Ano1),
    write('Segunda Data -> Dia: '),nl,
    read(Dia2),
    write('Segunda Data -> Mes: '),nl,
    read(Mes2),
    write('Segunda Data -> Ano: '),nl,
    read(Ano2),
    f7_entregasVeiculoIntervalo(Veiculo,Dia1/Mes1/Ano1,Dia2/Mes2/Ano2,R),
    write('Entregas efetuados de '),write(Veiculo),
    write(' na intervalo inserido: '), write(R),nl,nl.





% (1) implementar mais meios de transporte
    %veiculo(hoverboard, 5, 15, 2) % mais rapido que a bicicleta mas menos ecológico pois usa energia


% ------ PREDICADOS AUXILIARES ------
% Devolve a datahora atual no formato utilizado neste projetos
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

% True se datahora dada está entre o intervalo de tempo dado
datahora_intervalo(I, Ii, If) :- 
    datahoramenor(Ii, I),
    datahoramenor(I, If).

% Calcula o preço da encomenda: 5 (base) + 48 - tempo_em_horas + preço_veiculo
preco(TLimite, Peso, P) :-
    veiculo_encomenda(Peso, Veiculo),
    veiculo(Veiculo,_,_,PrecoVeiculo),
    P is 5 + 48 - TLimite + PrecoVeiculo.

% Determina o veículo a utilizar para uma encomenda a partir do peso
veiculo_encomenda(Peso, bicicleta) :- Peso =< 5.
veiculo_encomenda(Peso, mota) :- Peso =< 20.
veiculo_encomenda(Peso, carro) :- Peso =< 100.
veiculo_encomenda(_, _) :- write("Demasiado peso.").


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