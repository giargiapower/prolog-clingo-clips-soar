% cerca_soluzione(-ListaAzioni)
cerca_soluzione(ListaAzioni):-
    iniziale(SIniziale),
    profondita(SIniziale,ListaAzioni,[]).

% profondita(S,ListaAzioni,Visitati)
profondita(S,[],_):-finale(S),!.

profondita(S,[Az|ListaAzioni],Visitati):-
    applicabile(Az),
    trasforma(Az,S,SNuovo),
    \+member(SNuovo,Visitati),
    profondita(SNuovo,ListaAzioni,[S|Visitati]).


a_star_start(SIniziale,ListaAzioni,Chiusi, Aperti, Costi):- 
    a_star(ListaAzioni,Chiusi, [SIniziale|Aperti] , [Costi|Tail]).



a_star(ListaAzioni,Chiusi, Aperti, Costi).
% prendi tra gli aperti lo stato di costo minore 
% se finale termina
% altrimenti marcalo come chiuso
%calcola nord sud est ovest e rispettivi costi
% salva stati nella lista Aperti e costi nella lista Costi

