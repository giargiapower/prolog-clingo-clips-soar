:- dynamic([pos/2]).
:- dynamic([s/6]).
%num_col(4).
%num_righe(4).
num_col(4).
num_righe(4).
%pos(riga, colonna, tessera).
% usiamo assert e regret per aggiungere e rimuovere conoscenza del dominio. in questo modo basta
% aggiungere i nuovi valori nelle celle e rimuovere quelli vecchi che non valgono più.
% es |-|1| --> sposto 1 ovvero pos(0, 1, 1)  a sinistra e quindi aggiorno quel pos e metto quello nuovo
% -> pos(0,0,1)  , pos(0 ,1, 0).
%iniziale([3,5,1,2,15,9,7,6,12,11,0,4,10,8,14,13]).
%iniziale([1,2,3,4,5,6,7,8,0,9,10,11,12,13,14,15]).
%iniziale([6,13,7,10,8,9,11,0,15,2,12,5,14,3,1,4]).
%iniziale([1, 2 ,3 ,4 ,0, 6, 7, 8, 5, 10, 11, 12, 9, 13, 14, 15]).
iniziale([5,1,2,4,9,6,3,8,13,7,12,0,14,10,11,15]).
finale([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0]).
%finale([1,2,3,4,5,6,7,8,0]).
%e([2,2,2,2,2,2,0,4,2,2,1,3,3,1,4,2]).
%pos(2,2). 
%stato finale ?somma distanze da loro posizione corretta = 0
%ci sarà da inserire una euristica 
%[3, 3, 2, 3, 2, 2, 2, 4, 4, 2, 1, 1, 3, 3, 2, 5].
%s(Stato, Lista_Direzioni, Profondità, Costo, X0, Y0, )
%s([3,5,1,2,15,9,7,6,12,11,0,4,10,8,14,13], [start],  0, 34, 2, 2).
%s([1,2,3,4,5,6,7,8,0,9,10,11,12,13,14,15], [start],  0, 14, 2, 0).
%s([6,13,7,10,8,9,11,0,15,2,12,5,14,3,1,4], [start],  0,  40, 1, 3).
s([5,1,2,4,9,6,3,8,13,7,12,0,14,10,11,15], [start],  0,  24, 2, 3).
%s([2,4,3,7,1,6,0,5,8], start,  0, 8, 2, 0).

