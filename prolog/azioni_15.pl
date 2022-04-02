%applicabile(AZ,S)
applicabile(nord, pos(Riga, Colonna)):-
    Riga>0.
    
    applicabile(sud, pos(Riga, Colonna)):- num_righe(NR),
    Riga<NR.
    
    applicabile(est, pos(Riga, Colonna)):- num_col(NC),
    Colonna<NC.
    
    applicabile(ovest, pos(Riga, Colonna)):- 
    Colonna>0.
    
    %trasforma(AZ, S, NUOVO_S) aggiorna nel dominio la cella che viene scambiata quindi rimuovila e 
    % aggiungine una nuova  
    
    trasforma(nord, Lista, Next_Lista) :- pos(X, Y), 
        num_col(NC), 
        C is (NC*(X-1) + mod(Y, NC)), 
        scorri_nord(Lista, [Next_Lista], C).
    
    %raggiungere la posizione dello 0 , raggiungere la posizione della casella sopra lo 0 e swappare
    % in più aggiornare la pos() nel dominio.
    
    continue_nord([], Next_Lista):-    
        retract(pos(X,Y)), 
        assertz(pos(X-1, Y)).
    
    continue_nord([Head|Tail], Next_Lista) :-
        continue_nord(Tail, [Head|Next_Lista]).
    
    
    scorri_nord([Head|Tail], Next_Lista, 0) :- pos(X, Y), 
        num_col(NC), 
        %cerca 0 nella lista e sostituiscolo col valore da swappare da sistemare perchè lo 0 potrebbe 
        %essere dopo lo Head quindi non è stato ancora messo in Next_Lista
        select(0, Next_Lista, Head, Next_Lista),
        C is (NC*(X) + mod(Y, NC)),
        continue_nord(Tail, [0|Next_Lista]).
    
    scorri_nord([Head|Tail], Next_Lista, C) :- 
        H is C-1, 
        scorri_nord(Tail, [Head|Next_Lista], H).
