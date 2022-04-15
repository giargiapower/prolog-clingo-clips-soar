% cerca_soluzione(-ListaAzioni)
cerca_soluzione(ListaAzioni):-
    iniziale(SIniziale),
    pos(X, Y).
    profondita(SIniziale,ListaAzioni, X ,Y, []).

% profondita(S,ListaAzioni,Visitati)
profondita(S,[],_ , _ , _):-finale(S),!.

profondita(S,[Az|ListaAzioni],X, Y , Visitati):-
    applicabile(Az),
    trasforma(Az,S,SNuovo),
    \+member(SNuovo,Visitati),
    profondita(SNuovo,ListaAzioni,[S|Visitati]).


a_star_start(SIniziale,ListaAzioni, Aperti, Costi):- 
    a_star(ListaAzioni, [SIniziale|Aperti] , [0], Temp, 1).



a_star(ListaAzioni , Aperti, Costi, I).
% prendi tra gli aperti lo stato di costo minore 
% se finale termina
% altrimenti rimuovilo dagli aperti 
%calcola nord sud est ovest e rispettivi costo = I + costi e salvali in temp
% salva stati nella lista Aperti e costi nella lista Costi

