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
a_star_start(Percorso):- 
    iniziale(SIniziale),
    a_star([SIniziale] ,  Percorso).



% se lo stato scelto è il finale ritorniamo Percorso che avrà la lista corretta di tutti i movimenti
a_star([Head|_], Percorso) :- 
    %costo_minore(Aperti, Stato),
    finale(Head),
    s(Head, Direzioni , _ , _ , _ , _),
    Percorso = Direzioni,
    !.

%cerchiamo il costo minore tra gli aperti
% cerchiamo nella conoscenza lo stato trovato in modo tale da tirarci fuori le sue informazioni
%  rimuoviamo lo stato che abbiamo scelto tra gli aperti
%  sistemiamo la lista di azioni se abbiamo saltato ad un nodo di profondità inferiore a dove siamo arrivati
% valutiamo il nodo espandendolo e lavorando sui suoi figli
a_star([Head|Tail], Percorso) :- 
    %costo_minore(Aperti, Stato),
    s(Head, _, _ , _, _, _),
    %delete(Aperti, Stato, NewAperti),
    espandi(Head, [nord, sud, est, ovest], NewNodes),
    scorri_nodi(NewNodes, Tail, UAperti),
    a_star(UAperti, Percorso).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%expand_node(Stato, Aperti, Chiusi, NewAperti, NewChiusi):-
%    espandi(Stato, [nord, sud, est, ovest], NewNodes),
%    scorri_nodi(NewNodes, Aperti, Chiusi, NewAperti, NewChiusi).


%%%%%%%%%%%%%%%%%%%%%%%%%%

espandi(_, [], []) :-
    !.

% se è fattibile applica trasformazione
espandi(Stato, [Head|Tail], [SNuovo|NewNodes]) :-
    s(Stato, Lista_Direzioni, Profondita, _, X, Y),
    applicabile(Head, X, Y),
    trasforma(Head,X, Y, Stato, X2, Y2, SNuovo),
    P is Profondita+1,
    crea_s(SNuovo, [Head|Lista_Direzioni], P, X2, Y2),
    espandi(Stato, Tail, NewNodes),
    !.

% altrimenti  passa alla prossima azione 
espandi(Stato, [_|Tail], NewNodes) :-
    espandi(Stato, Tail, NewNodes).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% non creare lo stato se presente nel dominio
crea_s(SNuovo, _, _, _, _) :-
    s(SNuovo, _, _, _, _, _),
    !.

% crea lo stato se non presente nel dominio
crea_s(SNuovo, Direzioni, Profondita, X, Y) :-
    heuristic(SNuovo, Value),
    F is Value+Profondita,
    assertz(s(SNuovo, Direzioni, Profondita, F, X, Y)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% se abbiamo scorso tutti i figli fermiamoci
scorri_nodi([], Aperti, Aperti):-
    !.

% controlla il nuovo nodo
% passa al nodo successivo
scorri_nodi([Head|Tail], Aperti, NewAperti):-
    %aggiorna_liste(Head , Aperti, Chiusi, TempAperti, TempChiusi),
    \+member(Head,Aperti),
    sorted_insert(Head , Aperti, [], TempAperti),
    scorri_nodi(Tail, TempAperti, NewAperti),
    !.

scorri_nodi([_|Tail], Aperti, NewAperti):-
    scorri_nodi(Tail, Aperti, NewAperti).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


sorted_insert(Stato , [] , Minori, TempAperti) :-
    append([Minori, [Stato]], TempAperti),
    !.
    

sorted_insert(Stato , [Head|Tail] , Minori, TempAperti) :- 
        s(Stato , _ , _ , Costo, _ , _),
        s(Head , _ , _ , Costo2, _ , _),
        Costo=<Costo2,
        append([Minori, [Stato], [Head], Tail], TempAperti),
        !.

sorted_insert(Stato , [Head|Tail] , Minori, TempAperti) :-
        append([Minori, [Head]], Temp) ,
        sorted_insert(Stato , Tail , Temp, TempAperti) .
        




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
    num_col(Col),
    L is  Col-1,
    X1 is L,
    Y1 is L,
    X2 is floor(C/Col),
    Y2 is mod(C, Col),
    Res is abs(X1-X2)+abs(Y1-Y2),
    !.

calcola_h(Value, C, Res) :-
    num_col(Col),
    K is Value-1,
    X1 is floor(K/Col),
    Y1 is mod(K, Col),
    X2 is floor(C/Col),
    Y2 is mod(C, Col),
    Res is abs(X1-X2)+abs(Y1-Y2).