:- dynamic([pos/2]).
num_col(4).
num_righe(4).
%pos(riga, colonna, tessera).
% usiamo assert e regret per aggiungere e rimuovere conoscenza del dominio. in questo modo basta
% aggiungere i nuovi valori nelle celle e rimuovere quelli vecchi che non valgono più.
% es |-|1| --> sposto 1 ovvero pos(0, 1, 1)  a sinistra e quindi aggiorno quel pos e metto quello nuovo
% -> pos(0,0,1)  , pos(0 ,1, 0).
iniziale([3,5,1,2,15,9,7,6,12,11,0,4,10,8,14,13]).
finale([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0]).
e(34).
%e([2,2,2,2,2,2,0,4,2,2,1,3,3,1,4,2]).
pos(2,2).
%stato finale ?somma distanze da loro posizione corretta = 0
%ci sarà da inserire una euristica 
%[3, 3, 2, 3, 2, 2, 2, 4, 4, 2, 1, 1, 3, 3, 2, 5].
