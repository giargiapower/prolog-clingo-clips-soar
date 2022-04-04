%applicabile(AZ,S)
    applicabile(nord, pos(Riga, _)):-
    Riga>0.
    
    applicabile(sud, pos(Riga, _)):- num_righe(NR),
    Riga<NR.
    
    applicabile(est, pos(_, Colonna)):- num_col(NC),
    Colonna<NC.
    
    applicabile(ovest, pos(_, Colonna)):- 
    Colonna>0.
    
    %prendi la posizione dello 0 e il numero di colonne, a questo punto calcoliamo la pozizione 
    %del valore sopra lo 0 e scorriamo la lista 
    
    trasforma(nord, Lista, Next_Lista) :- pos(X, Y), 
        %print(Lista),
        num_col(NC), 
        C is (NC*(X-1) + mod(Y, NC)), 
        scorri_nord(Lista, Next_Lista, C).
    
    
    %abbiamo aggiornato la lista dunque salviamo la nuova posizione dello 0 nel dominio
    continue_nord([], _, _):-
        %print(Next_Lista),    
        retract(pos(X,Y)),
        Sub is X-1, 
        assertz(pos(Sub, Y)).

%abbiamo trovato la vecchia posizione di 0 dunque sostituiamolo con il valore che stava sopra e 
%proseguiamo lo scorrimento.
    continue_nord([0|Tail], [Value|Next_Lista], Value) :-
        continue_nord(Tail, Next_Lista, _).

 % se non abbiamo trovato ancora lo 0 inserisci il valore nella nuova lista e scorri   
    continue_nord([Head|Tail], [Head|Next_Lista], Value) :-
        continue_nord(Tail, Next_Lista, Value).
    
    % se il contatore è arrivato a 0 vuol dire che siamo arrivati alla posizione da swappare con lo 0
    % sostituiamo il valore con 0 e portiamocelo dietro in modo tale da sostituirlo con lo 0 nella
    %vecchia posizione
    scorri_nord([Head|Tail], [0|Next_Lista], 0) :-
        continue_nord(Tail, Next_Lista, Head),
        !.
    
    %se il contatore non è ancora arrivato a 0 allora decrementalo e continuiamo a scorrere
    scorri_nord([Head|Tail], [Head|Next_Lista], C) :- 
        H is C-1, 
        scorri_nord(Tail, Next_Lista, H).
