membro(X, [X|_]).
membro(X, [_|Xs]):-
	membro(X, Xs).

inverso(Xs, Ys):-
	inverso(Xs, [], Ys).

inverso([], Xs, Xs).
inverso([X|Xs],Ys, Zs):-
	inverso(Xs, [X|Ys], Zs).

minimo([(P,X)],(P,X)).
minimo([(P,X)|L],(Py,Y)):- minimo(L,(Py,Y)), X>Y.
minimo([(Px,X)|L],(Px,X)):- minimo(L,(Py,Y)), X=<Y.

maximo([(P,X)],(P,X)).
maximo([(P,X)|L],(Py,Y)):- maximo(L,(Py,Y)), X=<Y.
maximo([(Px,X)|L],(Px,X)):- maximo(L,(Py,Y)), X>Y.


seleciona(E, [E|Xs], Xs).
seleciona(E, [X|Xs], [X|Ys]) :- seleciona(E, Xs, Ys).