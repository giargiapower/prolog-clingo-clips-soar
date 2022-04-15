/*
 * F(s)=g(s)+h(s)
 * OPEN = nodi da espandere
 * CLOSED = nodi già visitati
 */



astar_start(Solution):-
    iniziale(S),
    heuristic(S,H),
    astar_aux((H,node(S,[]))],[],Solution),!.

%caso base nessuna azione o nodo da visitare no soluzione

%astar_aux(+Open, +Closed, -Solution)
astar_aux([],_,_):-
    write('no solution\n').






% heuristic(+State, -Heuristic)
% distanza i1 da goal
heuristic(pos(Xs,Ys), H):-
    distance(l1),
    finale(pos(X,Y)),
    H is abs(Xs-X)+abs(Ys-Y).
%distanza i2 da goal
heuristic(pos(Xs,Ys), H):-
    distance(l2),
    finale(pos(X,Y)),
    H is sqrt((Xs-X)^2+abs(Ys-Y)^2).
%max tra le due distanze
heuristic(pos(Xs,Ys), H):-
    distance(linf),
    finale(pos(X,Y)),
    H is max((Xs-X),(Ys-Y)).
