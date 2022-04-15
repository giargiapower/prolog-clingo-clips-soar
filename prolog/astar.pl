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







heuristic(Lista, H) :- distanza_m(Lista, 0 , Temp, H).



%il 16 andrà modificato con num_col(X)*num_col(X) circa  
% praticamente deve sommare la distanza di tutti i valori della lista quindi
%arriva fino all'ultimo elemento della matrice che si trova in pos 15
distanza_m(Lista, 15 , Temp, H) :-
    H is Temp.

% cerca il valore,a questo punto calcola la distanza dalla sua corretta posizione 
% ovvero se 5 si trova in posizione 2 la distanza è (5-1)-2 perchè il 5 dovrebbe stare 
% in posizione 4 meno 2 che è la posizione attuale .
% il risultato parziale lo sommiamo a temp che verrà poi passato a H quando avrà sommato 
% tutte le distanze 
distanza_m(Lista, C , Temp, H) :- 
    find_value(Lista, C, Value),
    Temp is Temp+abs((Value-1)-C),
    distanza_m(Lista, C+1 , Temp, H).


% scorri la lista fino a trovare il valore e ritornalo
find_value([Head|Tail], 0 , Head) :- !.
 

find_value([Head|Tail], C , Value):-
    K is C-1,
    find_value(Tail, K , Value).


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
