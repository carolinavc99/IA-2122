% ------ CONHECIMENTO ------
% --------------------------------------
% PMF
% --------------------------------------
-veiculo(Tipo,Carga,Velocidade,Preco,Decrescimento):-
    not(veiculo(Tipo,Carga,Velocidade,Preco,Decrescimento)),
    not(excecao(veiculo(Tipo,Carga,Velocidade,Preco,Decrescimento))).

-estafeta(Identificacao,Nome):-
    not(estafeta(Identificacao,Nome)),
    not(excecao(estafeta(Identificacao,Nome))).

-encomenda(Identificacao,Datahora,Tempo_Entrega,Peso,Volume,Preco,Rua,Cliente):-
    not(encomenda(Identificacao,Datahora,Tempo_Entrega,Peso,Volume,Preco,Rua,Cliente)),
    not(excecao(encomenda(Identificacao,Datahora,Tempo_Entrega,Peso,Volume,Preco,Rua,Cliente))).

-freguesia(Identificacao):-
    not(freguesia(Identificacao)),
    not(excecao(freguesia(Identificacao))).

-rua(Identificacao,Freguesia):-
    not(rua(Identificacao,Freguesia)),
    not(excecao(rua(Identificacao,Freguesia))).

-cliente(Identificacao,Nome,Rua):-
    not(cliente(Identificacao,Nome,Rua)),
    not(excecao(cliente(Identificacao,Nome,Rua))).

-entrega(Identificacao,Encomenda,Estafeta,Classificacao,Veiculo):-
    not(entrega(Identificacao,Encomenda,Estafeta,Classificacao,Veiculo)),
    not(excecao(entrega(Identificacao,Encomenda,Estafeta,Classificacao,Veiculo))).