% ------ BASE DE CONHECIMENTO ------
:- discontiguous excecao/1.
:- discontiguous encomenda/8.

% veículos - tipo, carga, velocidade, decrescimento de velocidade em relação ao peso (km/h/kg)
veiculo(usainBolt, 1, 45, 0).
veiculo(bicicleta, 5, 10, 0.7).
veiculo(mota, 20, 35, 0.5).
veiculo(carro, 100, 25, 0.1).
veiculo(rollsRoyce, 150, 120, 0.1).
veiculo(jato, 200, 800, 0.05).
veiculo(fogetao, 48600, 24944, 0).

% estafetas - numero de identificação, nome
estafeta(1, 'Lomberto Felgado').
estafeta(2, 'Marie Madalaide').
estafeta(3, 'Davim Ariezes').
estafeta(4, 'Sofira Mangostim').
estafeta(5, 'Miriana Rubardezes').

% encomenda - numero de identificação, datahora, tempo máximo de entrega, peso, volume, preço, rua, cliente
encomenda(1, 1/1/2021/18/30, 2, 10, 5, 56, 1,1).
encomenda(2, 20/7/2021/10/00, 24, 40, 5, 44, 2,2).
encomenda(3, 20/7/2021/9/20, 4, 5, 5, 54, 3, 3).
encomenda(4, 20/7/2021/16/00, 1, 15, 5, 62, 4, 4).
encomenda(5, 2/8/2021/3/40, 4, 20, 5, 59, 5, 5).
encomenda(6, 2/8/2021/15/50, 6, 25, 5, 62, 6, 6).
encomenda(7, 2/8/2021/17/10, 2, 96, 5, 66, 7, 7).
encomenda(8, 2/8/2021/20/00, 2, 4, 5, 56, 8, 8).
encomenda(9, 2/8/2021/20/00, 2, 4, 5, 56, 8, 8).
encomenda(10, 20/7/2021/10/00, 24, 40, 5, 44, 2,2).
encomenda(11, 2/12/2021/20/11, 3, 0.6, 5, 70, 3, 8).
encomenda(12, 2/12/2021/20/11, 4, 7, 5, 59, 1, 3).

% teste
encomenda(100, 7/01/2022/18/00, 10, 7, 5, 59, 1, 3).

%Valor nulo -> incerto
encomenda(13, 5/1/2022/21/00, 1, 2, 5, 59, 10, cliente_desconhecido).

% Impreciso
excecao(encomenda(14, 21/5/2021/21/00,2,2,5,59,10,2)). 
excecao(encomenda(14, 22/5/2021/21/00,2,2,5,59,10,2)). 

% Interdito
encomenda(15,2/3/2021,4,5,5,42,rua_interdita,3).

% freguesias - codigo de identificação
freguesia(1).
freguesia(2).
freguesia(3).
freguesia(4).
freguesia(5).

% ruas - codigo de identificação, id da freguesia
rua(1, 1).
rua(2, 1).
rua(3, 2).
rua(4, 2).
rua(5, 3).
rua(6, 3).
rua(7, 4).
rua(8, 4).
rua(9, 5).
rua(10, 5).

% clientes - numero de identificação, nome, id da rua de morada
cliente(1, 'Filmina Ribano', 1).
cliente(2, 'Santónio Mabalares', 2).
cliente(3, 'Namuel Ponino', 3).
cliente(4, 'Diliana Ramaz', 4).
cliente(5, 'Sarina Compares', 5).
cliente(6, 'Romana Sardezes', 6).
cliente(7, 'Carminela Lopanor', 7).
cliente(8, 'Iolina Rumos', 8).

% entregas - número de identificação, encomenda, estafeta, classificação (0-5), veiculo
entrega(1, 1, 1, 5, bicicleta).
entrega(2, 2, 2, 3, carro).
entrega(3, 3, 3, 2, bicicleta).
entrega(4, 4, 4, 1, mota).
entrega(5, 5, 1, 4, mota).
entrega(6, 6, 3, 2, carro).
entrega(7, 7, 3, 4, bicicleta).
entrega(8, 10, 2, 4, bicicleta).
entrega(9, 11, 5, 4, usainBolt).

%circuito(algoritmo, rua_entrega, [caminho], custo, peso, volume).