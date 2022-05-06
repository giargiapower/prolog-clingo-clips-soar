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
    a_star([SIniziale] , [],  Percorso).



% se lo stato scelto è il finale ritorniamo Percorso che avrà la lista corretta di tutti i movimenti
a_star([Head|_], _, Percorso) :- 
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
a_star([Head|Tail], Chiusi, Percorso) :- 
    %costo_minore(Aperti, Stato),
    s(Head, _, _ , _, _, _),
    %delete(Aperti, Stato, NewAperti),
    espandi(Head, [nord, sud, est, ovest], NewNodes),
    controlla_chiusi(NewNodes, Chiusi, NodiRimasti, UChiusi),
    scorri_nodi(NodiRimasti, Tail, UAperti),
    a_star(UAperti, [Head|UChiusi], Percorso).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
controlla_chiusi([], Chiusi, _, UChiusi) :-
    UChiusi = Chiusi,
    !. 

controlla_chiusi([Head|Tail], Chiusi, [Head|NodiRimasti], UChiusi) :- 
    \+member(Head,Chiusi),
    controlla_chiusi(Tail, Chiusi, NodiRimasti, UChiusi),
    !.

controlla_chiusi([_|Tail], Chiusi, NodiRimasti, UChiusi) :- 
    controlla_chiusi(Tail, Chiusi, NodiRimasti, UChiusi).

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
    %heuristic(SNuovo, Value),
    %F is Value+P,
    %assertz(s(SNuovo, [Head|Lista_Direzioni], P, F, X2, Y2)),
    espandi(Stato, Tail, NewNodes),
    !.

% altrimenti  passa alla prossima azione 
espandi(Stato, [_|Tail], NewNodes) :-
    espandi(Stato, Tail, NewNodes).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% non creare lo stato se presente nel dominio
crea_s(SNuovo, _, _, _, _) :-
    call(s(SNuovo, _, _, _, _, _)),
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
        s(Stato , _ , _ , _, _ , _),
        s(Head , _ , _ , _, _ , _),
        append([Minori, [Head]], Temp) ,
        sorted_insert(Stato , Tail , Temp, TempAperti) .
        


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

calcola_h(0, _, Res) :-
    %num_col(Col),
    %L is  Col-1,
    %X1 is L,
    %Y1 is L,
    %X2 is floor(C/Col),
    %Y2 is mod(C, Col),
    %Res is abs(X1-X2)+abs(Y1-Y2),
    Res is 0,
    !.

calcola_h(Value, C, Res) :-
    num_col(Col),
    K is Value-1,
    X1 is floor(K/Col),
    Y1 is mod(K, Col),
    X2 is floor(C/Col),
    Y2 is mod(C, Col),
    Res is abs(X1-X2)+abs(Y1-Y2).
