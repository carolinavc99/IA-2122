% ------ BASE DE CONHECIMENTO ------
% veículos - tipo, carga, velocidade, preço, decrescimento de velocidade em relação ao peso (km/h/kg)
veiculo(usainBolt, 1, 45, 20, 0).
veiculo(bicicleta, 5, 10, 5, 0.7).
veiculo(mota, 20, 35, 10, 0.5).
veiculo(carro, 100, 25, 15, 0.1).
veiculo(rollsRoyce, 150, 120, 80, 0.1).
veiculo(jato, 200, 800, 200, 0.05).
veiculo(fogetao, 48600, 24944, 185e6, 0).

% "Variável" global que guarda a lista ordenada de veículos (mais para menos ecológico)
lista_veiculos([usainBolt, bicicleta, mota, carro, rollsRoyce, jato, fogetao]).

% estafetas - numero de identificação, nome
estafeta(est1, 'Lomberto Felgado').
estafeta(est2, 'Marie Madalaide').
estafeta(est3, 'Davim Ariezes').
estafeta(est4, 'Sofira Mangostim').
estafeta(est5, 'Miriana Rubardezes').

% encomenda - numero de identificação, datahora, tempo máximo de entrega, peso, volume, preço, rua, cliente
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
encomenda(enc11, 2/12/2021/20/11, 3, 0.6, 5, 70, rua3, cli8).
encomenda(enc12, 2/12/2021/20/11, 4, 7, 5, 59, rua1, cli3).

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
entrega(ent9, enc11, est5, 4, usainBolt).