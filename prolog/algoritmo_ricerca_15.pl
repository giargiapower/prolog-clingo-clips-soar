% cerca_soluzione(-ListaAzioni)
cerca_soluzione(ListaAzioni):-
    iniziale(SIniziale),
    pos(X, Y),
    profondita(SIniziale,ListaAzioni, X ,Y, []).

% profondita(S,ListaAzioni,Visitati)
profondita(S,[],_ , _ , _):-finale(S),!.

profondita(S,[Az|ListaAzioni], X, Y , Visitati):-
    applicabile(Az, X, Y),
    trasforma(Az,X, Y, S, X2, Y2, SNuovo),
    \+member(SNuovo,Visitati),
    profondita(SNuovo,ListaAzioni,X2 , Y2, [S|Visitati]).


%a_star_start(SIniziale,ListaAzioni, Aperti, Costi):- 
%    a_star(ListaAzioni, [SIniziale|Aperti] , [0], Temp, 1).



%a_star(ListaAzioni , Aperti, Costi, I).
% prendi tra gli aperti lo stato di costo minore 
% se finale termina
% altrimenti rimuovilo dagli aperti 
%calcola nord sud est ovest e rispettivi costo = I + costi e salvali in temp
% salva stati nella lista Aperti e costi nella lista Costi




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
