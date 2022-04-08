:- discontiguous trasforma/3.
:- discontiguous scorri_sud/3.
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

    %NORD
    
    trasforma(nord, Lista, Next_Lista) :- pos(X, Y), 
        num_col(NC), 
        C is (NC*(X-1) + mod(Y, NC)), 
        scorri_nord(Lista, Next_Lista, C).
    
    
    %abbiamo aggiornato la lista dunque salviamo la nuova posizione dello 0 nel dominio
    continue_nord([], _, _):-    
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




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %SUD 
   trasforma(sud, Lista, Next_Lista) :- pos(X, Y), 
   num_col(NC), 
   C is (NC*(X+1) + mod(Y, NC)), 
   write(C),
   cerca_valore(Lista, C, Value),
   scorri_sud(Lista, Value, Next_Lista).



scorri_sud([], _, _):-    
   retract(pos(X,Y)),
   Add is X+1, 
   assertz(pos(Add, Y)).


scorri_sud([0|Tail], Value, [Value|Next_Lista]) :- 
    scorri_sud(Tail, Value , Next_Lista).


scorri_sud([Value|Tail], Value, [0|Next_Lista]) :-
   scorri_sud(Tail, Value , Next_Lista).


scorri_sud([Head|Tail], Value , [Head|Next_Lista]) :- 
   scorri_sud(Tail, Value, Next_Lista).


cerca_valore([Head| _], 0, Head).


cerca_valore([_| Tail], C, Value) :- 
    H is C-1,
    cerca_valore(Tail, H, Value).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %EST
   trasforma(est, Lista, Next_Lista) :- pos(X, Y), 
        num_col(NC), 
        C is (NC*(X) + mod(Y, NC)), 
        scorri_est(Lista, Next_Lista, C).
    
    
   
    continue_est([], _, _):-    
        retract(pos(X,Y)),
        Sub is Y-1, 
        assertz(pos(X, Sub)).


    continue_est([0|Tail], [Value|Next_Lista], Value) :-
        continue_est(Tail, Next_Lista, _).

  
    continue_est([Head|Tail], [Head|Next_Lista], Value) :-
        continue_est(Tail, Next_Lista, Value).
    
   
    scorri_est([Head|Tail], [0|Next_Lista], 1) :-
        continue_est(Tail, Next_Lista, Head),
        !.
    
   
    scorri_est([Head|Tail], [Head|Next_Lista], C) :- 
        H is C-1, 
        scorri_est(Tail, Next_Lista, H).





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %OVEST
   trasforma(ovest, Lista, Next_Lista) :- pos(X, Y), 
        num_col(NC), 
        C is (NC*(X) + mod(Y, NC) + 1), 
        cerca_valore(Lista, C, Value),
        scorri_ovest(Lista, Next_Lista, Value).
    
    
    scorri_ovest([], _, _):-    
        retract(pos(X,Y)),
        Add is Y+1, 
        assertz(pos(X, Add)).

    scorri_ovest([0|Tail], [Value|Next_Lista], Value) :-
        scorri_ovest(Tail, Next_Lista, Value),
        !.

    scorri_ovest([Value|Tail], [0|Next_Lista], Value) :-
        scorri_ovest(Tail, Next_Lista, Value),
        !.

    scorri_ovest([Head|Tail], [Head|Next_Lista], Value) :-  
        scorri_ovest(Tail, Next_Lista, Value).


