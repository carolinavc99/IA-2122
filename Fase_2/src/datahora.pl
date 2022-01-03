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

% Soma um certo número de horas a uma data e devolve a nova data
soma_horas_data(Horas, D/M/A/H/Mi, D1/M1/A1/H1/Mi1) :-
    date_time_stamp(date(A,M,D,H,Mi,0,0,-,-), Stamp),
    Segundos is Horas * 60,
    Soma is Stamp + Segundos,
    stamp_date_time(Soma, DataX, local),
    date_time_value(year, DataX, A1),
    date_time_value(month, DataX, M1),
    date_time_value(day, DataX, D1),
    date_time_value(hour, DataX, H1),
    date_time_value(minute, DataX, Min1).