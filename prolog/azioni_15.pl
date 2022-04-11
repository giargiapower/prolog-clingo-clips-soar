:- discontiguous trasforma/3.
:- discontiguous scorri_sud/3.
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

    scorri([], _, _, est):- 
        pos(X,Y),
        Add is Y+1,
        retract(pos(X,Y)), 
        assertz(pos(X, Add)).

    scorri([], _, _, ovest):-   
        pos(X,Y), 
        Sub is Y-1,
        retract(pos(X,Y)), 
        assertz(pos(X, Sub)).

    
    scorri([], _, _, sud):-    
        pos(X,Y),
        Add is X+1, 
        retract(pos(X,Y)),
        assertz(pos(Add, Y)).
    
    scorri([], _, _, nord):-   
        pos(X,Y),
        Sub is X-1,
        retractall(pos(X,Y)), 
        assertz(pos(Sub, Y)), !.


    scorri([0|Tail], Value ,  [Value|Next_Lista], W) :-
        scorri(Tail, Value ,  Next_Lista, W),
        !.

  
    scorri([Value|Tail], Value ,  [0|Next_Lista], W) :-
        scorri(Tail, Value , Next_Lista, W),
        !.
    
    scorri([Head|Tail], Value , [Head|Next_Lista] , W) :- 
        scorri(Tail, Value , Next_Lista, W).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %NORD
    
   trasforma(nord, Lista, Next_Lista) :- pos(X, Y), 
   num_col(NC), 
   C is (NC*(X-1) + mod(Y, NC)), 
   cerca_valore(Lista, C, Value),
   scorri(Lista, Value, Next_Lista, nord).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %SUD 
   trasforma(sud, Lista, Next_Lista) :- pos(X, Y), 
   num_col(NC), 
   C is (NC*(X+1) + mod(Y, NC)), 
   C>=0,
   write(C),
   write(" "),
   cerca_valore(Lista, C, Value),
   scorri(Lista, Value, Next_Lista, sud).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %OVEST
   trasforma(ovest, Lista, Next_Lista) :- pos(X, Y), 
        num_col(NC), 
        C is (NC*(X) + mod(Y, NC)-1), 
        C>=0,
        write(C),
        write(" "),
        cerca_valore(Lista, C, Value),
        scorri(Lista, Value, Next_Lista, ovest).
    
    


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %EST
   trasforma(est, Lista, Next_Lista) :- pos(X, Y), 
        num_col(NC), 
        C is (NC*(X) + mod(Y, NC) + 1), 
        C>=0,
        cerca_valore(Lista, C, Value),
        scorri(Lista, Value, Next_Lista, est).
    
    


