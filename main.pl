% ------ BASE DE CONHECIMENTO ------
% datahora - dia/mes/ano, hora (relógio de 24h)
datahora(D/2/A,H) :- H >= 1, H < 25,
    D >= 1, D <= 28.
datahora(D/M/A,H) :- H >= 1, H < 25,
    M >= 1, M <= 12,
    D >= 1, ( 2 =:= mod(M,2) 
        -> D <=30 ; D <=31).

% veículos - tipo (3), carga (máxima), velocidade (média), preço
veiculo(bicicleta, 5, 10, 5).
veiculo(mota, 20, 35, 10).
veiculo(carro, 100, 25, 15).

% estafetas - numero de identificação, nome
estafeta(est1, 'Lomberto Felgado').
estafeta(est2, 'Marie Madalaide').
estafeta(est3, 'Davim Ariezes').
estafeta(est4, 'Sofira Mangostim').
estafeta(est5, 'Miriana Rubardezes').

% encomenda - numero de identificação, datahora, tempo máximo de entrega, peso, volume, preço (5 (base) + 48 - tempo_em_horas + preço_veiculo), rua
% encomenda(enc1, datahora(1/1/2021, 17), 2, ) $ Hold on. Como é suposto implementar a passagem de tempo? Also, o cliente diz prazo de entrega mas depois temos de saber quantas entregas foram entregues num dado dia isso vai ser complicado

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

% entregas - número de identificação, encomenda, estafeta, classificação (0-5)
entrega(ent1, enc1, est1, 5).
entrega(ent2, enc2, est2, 3).
entrega(ent3, enc3, est3, 2).
entrega(ent4, enc4, est4, 1).
entrega(ent5, enc5, est1, 4).
entrega(ent6, enc6, est3, 2).

% grafo aranha
% começar simples: 10 zonas, grafo com distâncias e estimativas

% ----------- GRAFO -----------
% 10 ruas
% 5 freguesias - para que servem as frequesias? -acho que é puramente para poder perguntar quantas entregas por freguesia (para estatística)


% ------ FUNCIONALIDADES NECESSÁRIAS ------
% pedir encomenda
% fazer entrega ( estafeta escolhe, aleatoriamente, o veículo)
% navegação?
% etc

% ------ FUNCIONALIDADES PEDIDAS ------
% (1) O estafeta que utilizou mais vezes um meio de transporte mais ecológico
f1_estafetaEcologico(R).

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
f8_entregasEstafetaIntervalo(E,Ii,If,R).

% (9) Peso total transportado por um estafeta num determinado dia
f9_pesoEstafetaDia(E,D,R).

% ------ FUNCIONALIDADES EXTRA ------
% (esta secção é à nossa escolha)

% (1) implementar mais meios de transporte
    %veiculo(hoverboard, 5, 15, 2) % mais rapido que a bicicleta mas menos ecológico pois usa energia