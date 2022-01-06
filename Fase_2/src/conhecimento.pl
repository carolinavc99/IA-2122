% ------ CONHECIMENTO ------
:- op(900,xfy,'::').
:- dynamic veiculo/5.
:- dynamic estafeta/2.
:- dynamic freguesia/1.
:- dynamic rua/2.
:- dynamic cliente/3.
:- dynamic entrega/5.
:- dynamic encomenda/8.

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

% ------------------------------------------------------------------------------------------------
% Invariantes de Repetição
% ------------------------------------------------------------------------------------------------

+veiculo(Tipo,Carga,Velocidade,Preco,Decrescimento)::
    (
        findall(
            (Tipo,Carga,Velocidade,Preco,Decrescimento),
            veiculo(Tipo,Carga,Velocidade,Preco,Decrescimento),
            S
        ),
        length(S,N),
        N==1
    ).

+estafeta(Identificacao,Nome)::
    (
        findall(
            ((Identificacao,Nome),
            estafeta(Identificacao,Nome),
            S)
        ),
        length(S,N),
        N==1
    ).

+encomenda(Identificacao,Datahora,Tempo_Entrega,Peso,Volume,Preco,Rua,Cliente)::
    (
        findall(
            ((Identificacao,Datahora,Tempo_Entrega,Peso,Volume,Preco,Rua,Cliente),
            encomenda(Identificacao,Datahora,Tempo_Entrega,Peso,Volume,Preco,Rua,Cliente),
            S)
        ),
        length(S,N),
        N==1
    ).

+freguesia(Identificacao)::
    (
        findall(
            ((Identificacao),
            freguesia(Identificacao),
            S)
        ),
        length(S,N),
        N==1
    ).

+rua(Identificacao,Freguesia)::
    (
        findall(
            ((Identificacao,Freguesia),
            rua(Identificacao,Freguesia),
            S)
        ),
        length(S,N),
        N==1
    ).

+cliente(Identificacao,Nome,Rua)::
    (
        findall(
            ((Identificacao,Nome,Rua),
            cliente(Identificacao,Nome,Rua),
            S)
        ),
        length(S,N),
        N==1
    ).

+entrega(Identificacao,Encomenda,Estafeta,Classificacao,Veiculo)::
    (
        findall(
            ((Identificacao,Encomenda,Estafeta,Classificacao,Veiculo),
            entrega(Identificacao,Encomenda,Estafeta,Classificacao,Veiculo),
            S)
        ),
        length(S,N),
        N==1
    ).