/*
 * F(s)=g(s)+h(s)
 * OPEN = nodi da espandere
 * CLOSED = nodi già visitati
 */



astar_start(Solution):-
    iniziale(S),
    heuristic(S,H),
    astar_aux((H,node(S,[])),[],Solution),!.

%caso base nessuna azione o nodo da visitare no soluzione

%astar_aux(+Open, +Closed, -Solution)
astar_aux([],_,_):-
    write('no solution\n').







heuristic(Lista, H) :- distanza_m(Lista, 0 , 0, H).



%il 16 andrà modificato con num_col(X)*num_col(X) circa  
% praticamente deve sommare la distanza di tutti i valori della lista quindi
%arriva fino all'ultimo elemento della matrice che si trova in pos 15
distanza_m(_, 16 , Temp, H) :-
    H is Temp, 
    !.

% cerca il valore,a questo punto calcola la distanza dalla sua corretta posizione 
% ovvero se 5 si trova in posizione 2 la distanza è (5-1)-2 perchè il 5 dovrebbe stare 
% in posizione 4 meno 2 che è la posizione attuale .
% il risultato parziale lo sommiamo a temp che verrà poi passato a H quando avrà sommato 
% tutte le distanze 
% sistemare la posizione 0 che deve stare in fondo 
distanza_m(Lista, C , Temp, H) :- 
    find_value(Lista, C, Value),
    calcola_h(Value, C, Res),
    %Temp is Temp+Res,
    K is C+1,
    distanza_m(Lista, K , Temp+Res, H).


% scorri la lista fino a trovare il valore e ritornalo
find_value([Head|_], 0 , Head) :- !.
 

find_value([_|Tail], C , Value):-
    K is C-1,
    find_value(Tail, K , Value).

calcola_h(0, C, Res) :-
    X1 is 3,
    Y1 is 3,
    X2 is floor(C/4),
    Y2 is mod(C, 4),
    Res is abs(X1-X2)+abs(Y1-Y2),
    !.

calcola_h(Value, C, Res) :-
    K is Value-1,
    X1 is floor(K/4),
    Y1 is mod(K, 4),
    X2 is floor(C/4),
    Y2 is mod(C, 4),
    Res is abs(X1-X2)+abs(Y1-Y2).

% heuristic(+State, -Heuristic)
% distanza i1 da goal
%heuristic(pos(Xs,Ys), H):-
%    distance(l1),
%    finale(pos(X,Y)),
%    H is abs(Xs-X)+abs(Ys-Y).
%distanza i2 da goal
%heuristic(pos(Xs,Ys), H):-
%    distance(l2),
%    finale(pos(X,Y)),
%    H is sqrt((Xs-X)^2+abs(Ys-Y)^2).
%max tra le due distanze
%heuristic(pos(Xs,Ys), H):-
%    distance(linf),
%    finale(pos(X,Y)),
%    H is max((Xs-X),(Ys-Y)).
