%applicabile(AZ,S)
applicabile(nord, pos(Riga, Colonna)):-
    Riga>0.
    
    applicabile(sud, pos(Riga, Colonna)):- num_righe(NR),
    Riga<NR.
    
    applicabile(est, pos(Riga, Colonna)):- num_col(NC),
    Colonna<NC.
    
    applicabile(ovest, pos(Riga, Colonna)):- 
    Colonna>0.
    
    %prendi la posizione dello 0 e il numero di colonne, a questo punto calcoliamo la pozizione 
    %del valore sopra lo 0 e scorriamo la lista 
    
    trasforma(nord, Lista, Next_Lista) :- pos(X, Y), 
        num_col(NC), 
        C is (NC*(X-1) + mod(Y, NC)), 
        scorri_nord(Lista, Next_Lista, C).
    
    
    %abbiamo aggiornato la lista dunque salviamo la nuova posizione dello 0 nel dominio
    continue_nord([], Next_Lista, _):-    
        retract(pos(X,Y)), 
        assertz(pos(X-1, Y)).

%abbiamo trovato la vecchia posizione di 0 dunque sostituiamolo con il valore che stava sopra e 
%proseguiamo lo scorrimento.
    continue_nord([0|Tail], Next_Lista, Value) :-
        continue_nord(Tail, [Value|Next_Lista]).

 % se non abbiamo trovato ancora lo 0 inserisci il valore nella nuova lista e scorri   
    continue_nord([Head|Tail], Next_Lista, _) :-
        continue_nord(Tail, [Head|Next_Lista]).
    
    % se il contatore è arrivato a 0 vuol dire che siamo arrivati alla posizione da swappare con lo 0
    % sostituiamo il valore con 0 e portiamocelo dietro in modo tale da sostituirlo con lo 0 nella
    %vecchia posizione
    scorri_nord([Head|Tail], Next_Lista, 0) :-
        continue_nord(Tail, [0|Next_Lista], Head).
    
    %
    scorri_nord([Head|Tail], Next_Lista, C) :- 
        H is C-1, 
        scorri_nord(Tail, [Head|Next_Lista], H).
