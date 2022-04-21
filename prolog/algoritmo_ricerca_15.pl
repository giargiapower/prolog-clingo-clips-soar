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
    assertz(s(SIniziale, start,  0, 0, 2, 2)),
    a_star([SIniziale] , [] , 0 , [], Percorso).




% se lo stato scelto è il finale ritorniamo Percorso che avrà la lista corretta di tutti i movimenti
a_star(Aperti, Chiusi, Profondita, ListaAzioni, Percorso) :- 
    find_costo_minore(Aperti, Value, 1, _, Stato),
    finale(Stato),
    Percorso = ListaAzioni,
    !.

%cerchiamo il costo minore tra gli aperti
% cerchiamo nella conoscenza lo stato trovato in modo tale da tirarci fuori le sue informazioni
%  rimuoviamo lo stato che abbiamo scelto tra gli aperti
%  sistemiamo la lista di azioni se abbiamo saltato ad un nodo di profondità inferiore a dove siamo arrivati
% valutiamo il nodo espandendolo e lavorando sui suoi figli
a_star(Aperti, Chiusi, Profondita, ListaAzioni, Percorso) :- 
    find_costo_minore(Aperti, Value, 1, _, Stato),
    s(Stato, Direzione, _, _, _, _),
    rimuovi_stato_aperto(Aperti, Stato, NewAperti),
    sistema_azioni(ListaAzioni, Direzione, Profondita, NewListaAzioni),
    P2 is Profondita+1,
    expand_node(Stato, Aperti, Chiusi, P2, NewAperti, NewChiusi),
    %scorri_nodi(+Aperti, +Chiusi, +ListNewNodes, +P2, -NewAperti, -NewChiusi),
    a_star(NewAperti, NewChiusi, Profondita+1, NewListaAzioni , Percorso).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


expand_node(Stato, Aperti, Chiusi, Profondita, NewAperti, NewChiusi):-
    espandi(Stato, [nord, sud, est, ovest], NewNodes, Actions),

    !.


%%%%%%%%%%%%%%%%%%%%%%%%%%

espandi(Stato, [], NewNodes, AzioniEseguite) :-
    !.

% se è fattibile applica trasformazione
espandi(Stato, [Head|Tail], [SNuovo|NewNodes], [Head|AzioniEseguite]) :-
    s(Stato, _, Profondita, _, X0, Y0),
    %applicabile(Az, X, Y),
    %trasforma(Az,X, Y, S, X2, Y2, SNuovo),
    % crea s
    % espandi(Stato, Tail, NewNodes, AzioniEseguite) 
    !.

% altrimenti  passa alla prossima azione 
espandi(Stato, [Head|Tail], NewNodes, AzioniEseguite) :-
    espandi(Stato, Tail, NewNodes, AzioniEseguite),
    %
    % espandi(Stato, Tail, NewNodes, AzioniEseguite) 
    !.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% inserisco in coda la nuova direzione e delle vecchie mantengo solo quelle 
% che appartengono a stati di profondità inferiore a quella che sto inserendo
sistema_azioni([Head|Tail], Direzione, 0, [Direzione|NewListaAzioni]):-
    !.

sistema_azioni([Head|Tail], Direzione, P, [Head|NewListaAzioni]):-
    P2 is P-1,
    sistema_azioni(Tail, Direzione, P2, NewListaAzioni).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% se abbiamo scorso tutti i figli fermiamoci
scorri_nodi(Aperti, Chiusi, [], Profondita, Direzioni, NewAperti, NewChiusi):-
    NewChiusi is Chiusi,
    NewAperti is Aperti,
    !.

% calcola f(x)= g(x)+h(x) , ponendo g(x)= profondita
% controlla il nuovo nodo
% passa al nodo successivo
scorri_nodi(Aperti, Chiusi, [Head|Tail], Profondita, NewAperti, NewChiusi):-
    heuristic(Head, Value),
    %F is Value+Profondita,
    %controlla_presenza(Aperti, Chiusi, Profondita, F, Head, TempAperti, TempChiusi),
    scorri_nodi(TempAperti, TempChiusi, Tail, Profondita, NewAperti, NewChiusi).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% se il nodo lo abbiamo già trovato allora ci siamo già passati dunque 
% se lo stato è tra i chiusi mettilo tra gli aperti
controlla_presenza(Aperti, Chiusi, Profondita, F, Stato , _, TempAperti, TempChiusi):-
    %s(Head, _ , _ , _),
    %aggiornaChiusi(Head, Aperti , Chiusi,TempAperti, TempChiusi)
    !.

% se non è mai stato trovato allora salvalo nella conoscenza e nella lista di aperti
controlla_presenza(Aperti, Chiusi, Profondita, F, Stato, Direzione,[Head|Aperti] , _):-
    assertz(s(Head, Direzione, Profondita, F)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
find_costo_minore([], _, _, Temp, Stato):-
    Stato = Temp.


find_costo_minore([Head|Tail], Value, Flag, Temp, Stato):-
    Flag ==1,
    s(Head,_,_,Costo),
    find_costo_minore(Tail, Costo, 0, Head, Stato),
    !.

find_costo_minore([Head|Tail], Value, Flag, Temp, Stato):-
    Flag ==0,
    s(Head,_,_,Costo),
    Costo<Value,
    find_costo_minore(Tail, Costo, 0, Head, Stato),
    !.

find_costo_minore([Head|Tail], Value, Flag, Temp, Stato):-
    Flag ==0,
    s(Head,_,_,Costo),
    Costo>=Value,
    find_costo_minore(Tail, Value, 0, Temp, Stato),
    !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



rimuovi_stato_aperto([Head|Tail], Stato, NewAperti) :-
    Stato==Head,
    rimuovi_stato_aperto(Tail, Stato, NewAperti),
    !.

rimuovi_stato_aperto([Head|Tail], Stato, [Head|NewAperti]) :-
    rimuovi_stato_aperto(Tail, Stato, NewAperti).

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
