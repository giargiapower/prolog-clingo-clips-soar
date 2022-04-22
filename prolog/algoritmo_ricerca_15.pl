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

%struttura : s(Stato, Direzione, Profondità, Costo, X0, Y0) ci serve per capire se siamo già passati per quello stato
% aggiungiamo lo stato iniziale alla nostra conoscenza
% iniziamo astar 
a_star_start(SIniziale,Percorso):- 
    a_star([SIniziale] , [] , [], Percorso).



% se lo stato scelto è il finale ritorniamo Percorso che avrà la lista corretta di tutti i movimenti
a_star(Aperti, _, ListaAzioni, Percorso) :- 
    costo_minore(Aperti, Stato),
    finale(Stato),
    Percorso = ListaAzioni,
    !.

%cerchiamo il costo minore tra gli aperti
% cerchiamo nella conoscenza lo stato trovato in modo tale da tirarci fuori le sue informazioni
%  rimuoviamo lo stato che abbiamo scelto tra gli aperti
%  sistemiamo la lista di azioni se abbiamo saltato ad un nodo di profondità inferiore a dove siamo arrivati
% valutiamo il nodo espandendolo e lavorando sui suoi figli
a_star(Aperti, Chiusi, ListaAzioni, Percorso) :- 
    costo_minore(Aperti, Stato),
    s(Stato, Direzione, Profondita , _, _, _),
    rimuovi_stato(Aperti, Stato, NewAperti),
    sistema_azioni(ListaAzioni, Direzione, Profondita, NewListaAzioni),
    P2 is Profondita+1,
    expand_node(Stato, Aperti, Chiusi, P2, NewAperti, NewChiusi),
    a_star(NewAperti, [Stato|NewChiusi], NewListaAzioni , Percorso).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


expand_node(Stato, Aperti, Chiusi, Profondita, NewAperti, NewChiusi):-
    espandi(Stato, [nord, sud, est, ovest], Profondita, NewNodes),
    scorri_nodi(NewNodes, Aperti, Chiusi, NewAperti, NewChiusi).


%%%%%%%%%%%%%%%%%%%%%%%%%%

espandi(_, [], _, _) :-
    !.

% se è fattibile applica trasformazione
espandi(Stato, [Head|Tail], Profondita, [SNuovo|NewNodes]) :-
    s(Stato, _, Profondita, _, X, Y),
    applicabile(Head, X, Y),
    trasforma(Head,X, Y, Stato, X2, Y2, SNuovo),
    crea_s(SNuovo, Head, Profondita, X2, Y2),
    espandi(Stato, Tail, Profondita, NewNodes),
    !.

% altrimenti  passa alla prossima azione 
espandi(Stato, [_|Tail], Profondita, NewNodes) :-
    espandi(Stato, Tail, Profondita, NewNodes).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% non creare lo stato se presente nel dominio
crea_s(SNuovo, _, _, _, _) :-
    s(SNuovo, _, _, _, _, _),
    !.

% crea lo stato se non presente nel dominio
crea_s(SNuovo, Direzione, Profondita, X, Y) :-
    heuristic(SNuovo, Value),
    F is Value+Profondita,
    assertz(s(SNuovo, Direzione, Profondita, F, X, Y)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% inserisco in coda la nuova direzione e delle vecchie mantengo solo quelle 
% che appartengono a stati di profondità inferiore a quella che sto inserendo
sistema_azioni(_, Direzione, 0, [Direzione|_]):-
    !.

sistema_azioni([Head|Tail], Direzione, P, [Head|NewListaAzioni]):-
    P2 is P-1,
    sistema_azioni(Tail, Direzione, P2, NewListaAzioni).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% se abbiamo scorso tutti i figli fermiamoci
scorri_nodi([], Aperti, Chiusi, Aperti, Chiusi):-
    !.

% controlla il nuovo nodo
% passa al nodo successivo
scorri_nodi([Head|Tail], Aperti, Chiusi, NewAperti, NewChiusi):-
    aggiorna_liste(Head , Aperti, Chiusi, TempAperti, TempChiusi),
    scorri_nodi(Tail, TempAperti, TempChiusi, NewAperti, NewChiusi).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% se lo stato non è ne tra gli aperti ne tra i chiusi aggiungilo agli aperti
aggiorna_liste(Stato, Aperti, Chiusi , [Stato|Aperti], Chiusi):-
    \+member(Stato,Aperti),
    \+member(Stato,Chiusi),
    !.

%se è tra i chiusi mettilo negli aperti
aggiorna_liste(Stato, Aperti, Chiusi , [Stato|Aperti], NewChiusi):-
    member(Stato,Chiusi),
    rimuovi_stato(Chiusi, Stato, NewChiusi),
    !.


%in tutti gli altri casi non fare nulla 
aggiorna_liste(_, Aperti, Chiusi , Aperti, Chiusi).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%s(Stato, Direzione, Profondità, Costo, X0, Y0)

costo_minore([Head|Tail], Stato) :-
    s(Head,_,_,Costo, _,_),
    find_costo_minore(Tail, Costo, Head, Stato),
    !.

find_costo_minore([], _, Temp, Stato):-
    Stato = Temp, 
    !.


find_costo_minore([Head|Tail], Value, _, Stato):-
    s(Head,_,_,Costo, _,_),
    Costo<Value,
    find_costo_minore(Tail, Costo, Head, Stato),
    !.

find_costo_minore([Head|Tail], Value, Temp, Stato):-
    s(Head,_,_,Costo, _,_),
    Costo>=Value,
    find_costo_minore(Tail, Value, Temp, Stato),
    !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rimuovi_stato([], _, []).


rimuovi_stato([Head|Tail], Stato, NewList) :-
    Stato==Head,
    rimuovi_stato(Tail, Stato, NewList),
    !.

rimuovi_stato([Head|Tail], Stato, [Head|NewList]) :-
    rimuovi_stato(Tail, Stato, NewList).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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
