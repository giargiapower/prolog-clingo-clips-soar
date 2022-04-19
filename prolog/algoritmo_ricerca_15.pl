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

%struttura : s(Stato, Direzione, Profondità, Costo) ci serve per capire se siamo già passati per quello stato
% aggiungiamo lo stato iniziale alla nostra conoscenza
% iniziamo astar 
a_star_start(SIniziale,ListaAzioni):- 
    assertz(s(SIniziale, start,  0, 0)),
    a_star([SIniziale] , [] , 0 , []).


%cerchiamo il costo minore tra gli aperti
% cerchiamo nella conoscenza lo stato trovato in modo tale da tirarci fuori le sue informazioni
%  rimuoviamo lo stato che abbiamo scelto tra gli aperti
%  sistemiamo la lista di azioni se abbiamo saltato ad un nodo di profondità inferiore a dove siamo arrivati
% valutiamo il nodo espandendolo e lavorando sui suoi figli
a_star(Aperti, Chiusi, Profondita, ListaAzioni) :- 
    %find_costo_minore(+Aperti, -Stato),
    %s(Stato, Direzione, _, _),
    %rimuovi_stato_aperto(+Aperti, -NewAperti),
    %sistema_azioni(+ListaAzioni, +Profondita, -NewListaAzioni),
    valutazione_nodo(Stato, +Aperti, +[Stato|Chiusi], +Profondita, -[Direzione|NewListaAzioni]).

% se lo stato scelto è il finale printa la lista di azioni e termina 
valutazione_nodo(Stato, _, _, _, ListaAzioni) :-
    finale(Stato),
    write(ListaAzioni),
    !.

% se non è lo stato finale espandi il nodo 
% aumenta la profondita
% valutiamo i nuovi nodi 
% richiama astar
valutazione_nodo(Stato, Aperti, Chiusi, Profondita, ListaAzioni) :-
    %expand_node(+Stato, -ListNewNodes, -ListDirections),
    %P2 is Profondita+1,
    %scorri_nodi(+Aperti, +Chiusi, +ListNewNodes, +P2, +ListDirections, -NewAperti, -NewChiusi),
    a_star(NewAperti, NewChiusi, P2, ListaAzioni). 

% se abbiamo scorso tutti i figli fermiamoci
scorri_nodi(Aperti, Chiusi, [], Profondita, Direzioni, NewAperti, NewChiusi):-
    NewChiusi is Chiusi,
    NewAperti is Aperti,
    !.

% calcola f(x)= g(x)+h(x) , ponendo g(x)= profondita
% controlla il nuovo nodo
% passa al nodo successivo
scorri_nodi(Aperti, Chiusi, [Head|Tail], Profondita, [HeadD|TailD], NewAperti, NewChiusi):-
    heuristic(Head, Value),
    %F is Value+Profondita,
    %controlla_presenza(Aperti, Chiusi, Profondita, F, Head, HeadD, TempAperti, TempChiusi),
    scorri_nodi(TempAperti, TempChiusi, Tail, Profondita, TailD, NewAperti, NewChiusi).


% se il nodo lo abbiamo già trovato allora ci siamo già passati dunque 
% se lo stato è tra i chiusi mettilo tra gli aperti
controlla_presenza(Aperti, Chiusi, Profondita, F, Head,TempAperti, TempChiusi):-
    %s(Head, _ , _ , _),
    %aggiornaChiusi(Head, Aperti , Chiusi,TempAperti, TempChiusi)
    !.

% se non è mai stato trovato allora salvalo nella conoscenza e nella lista di aperti
controlla_presenza(Aperti, Chiusi, Profondita, F, Head, Direzione,[Head|Aperti] , _):-
    assertz(s(Head, Direzione, Profondita, F)).




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
