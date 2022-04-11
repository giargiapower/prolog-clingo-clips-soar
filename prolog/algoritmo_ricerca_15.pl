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