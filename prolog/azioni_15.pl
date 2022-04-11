%applicabile(AZ,S)
    applicabile(nord):-
    pos(Riga, _),
    Riga>0.
    
    applicabile(sud):- pos(Riga, _), 
    num_righe(NR),
    Riga<NR-1.
    
    applicabile(est):- pos(_, Colonna),
    num_col(NC),
    Colonna<NC-1.
    
    applicabile(ovest):- pos(_, Colonna),
    Colonna>0.
    
  
%CERCHIAMO IL VALORE DA SWAPPARE CON LO 0
    cerca_valore([Head| _], 0, Head) :- !.


    cerca_valore([_| Tail], C, Value) :- 
        H is C-1,
        cerca_valore(Tail, H, Value).

%SCORRIAMO TUTTA LA LISTA, SWAPPIAMO LO 0 COL VALORE E QUANDO ARRIVIAMO ALLA FINE AGGIORNIAMO LA NUOVA
%POSIZIONE DELLO 0

    scorri([], _, _).

    scorri([0|Tail], Value ,  [Value|Next_Lista]) :-
        scorri(Tail, Value ,  Next_Lista),
        !.

  
    scorri([Value|Tail], Value ,  [0|Next_Lista]) :-
        scorri(Tail, Value , Next_Lista),
        !.
    
    scorri([Head|Tail], Value , [Head|Next_Lista]) :- 
        scorri(Tail, Value , Next_Lista).

    update_nord(X, Y):- Sub is X-1,
        retractall(pos(X,Y)), 
        assertz(pos(Sub, Y)).


    update_sud(X, Y):- Add is X+1, 
        retract(pos(X,Y)),
        assertz(pos(Add, Y)).



    update_est(X, Y):- Add is Y+1,
        retract(pos(X,Y)), 
        assertz(pos(X, Add)).



    update_ovest(X, Y):- Sub is Y-1,
        retract(pos(X,Y)), 
        assertz(pos(X, Sub)).


    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %NORD
    
   trasforma(nord, Lista, Next_Lista) :- pos(X, Y), 
   num_col(NC), 
   C is (NC*(X-1) + mod(Y, NC)), 
   cerca_valore(Lista, C, Value),
   scorri(Lista, Value, Next_Lista),
   update_nord(X, Y).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %SUD 
   trasforma(sud, Lista, Next_Lista) :- pos(X, Y), 
   num_col(NC), 
   C is (NC*(X+1) + mod(Y, NC)), 
   C>=0,
   cerca_valore(Lista, C, Value),
   scorri(Lista, Value, Next_Lista),
   update_sud(X, Y).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %OVEST
   trasforma(ovest, Lista, Next_Lista) :- pos(X, Y), 
        num_col(NC), 
        C is (NC*(X) + mod(Y, NC)-1), 
        C>=0,
        cerca_valore(Lista, C, Value),
        scorri(Lista, Value, Next_Lista),
        update_ovest(X, Y).
    


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %EST
   trasforma(est, Lista, Next_Lista) :- pos(X, Y), 
        num_col(NC), 
        C is (NC*(X) + mod(Y, NC) + 1), 
        C>=0,
        cerca_valore(Lista, C, Value),
        scorri(Lista, Value, Next_Lista),
        update_est(X, Y).
    


