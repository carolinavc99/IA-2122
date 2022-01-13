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

% encomenda - numero de identificação, datahora, tempo máximo de entrega, 
%       peso, volume, preço, rua, cliente
encomenda(1, 12/1/2022/21/35, 2, 5, 2, 56, 1, 1).
encomenda(2, 12/1/2022/21/39, 24, 2, 6, 34, 9, 2).
encomenda(3, 12/1/2022/21/46, 24, 90, 60, 34, 4, 3).
encomenda(4, 12/1/2022/21/50, 12, 300, 50, 46, 7, 4).
encomenda(5, 12/1/2022/21/56, 7, 40, 4, 51, 1, 4).
encomenda(6, 12/1/2022/22/1, 30, 20, 7, 28, 3, 2).
encomenda(7, 12/1/2022/22/2, 22, 4, 7, 36, 5, 1).
encomenda(8, 12/1/2022/22/5, 35, 1, 4, 23, 3, 3).
encomenda(9, 12/1/2022/22/6, 40, 2, 5, 18, 2, 1).
encomenda(10, 12/1/2022/22/7, 48, 10, 5, 10, 2, 2).


% teste
%encomenda(100, 7/01/2022/18/00, 10, 7, 5, 59, 1, 3).

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
entrega(1, 1, 1, 2, bicicleta).
entrega(2, 2, 2, 4, bicicleta).
entrega(3, 3, 3, 1, carro).
entrega(4, 4, 2, 3, fogetao).
entrega(5, 4, 2, 4, fogetao).
entrega(6, 6, 1, 2, mota).
entrega(7, 7, 5, 2, bicicleta).
entrega(8, 8, 2, 5, usainBolt).



%circuito(algoritmo, rua_entrega, [caminho], custo, peso, volume).