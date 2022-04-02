:- dynamic([pos/2]).
num_col(4).
num_righe(4).
%pos(riga, colonna, tessera).
% usiamo assert e regret per aggiungere e rimuovere conoscenza del dominio. in questo modo basta
% aggiungere i nuovi valori nelle celle e rimuovere quelli vecchi che non valgono più.
% es |-|1| --> sposto 1 ovvero pos(0, 1, 1)  a sinistra e quindi aggiorno quel pos e metto quello nuovo
% -> pos(0,0,1)  , pos(0 ,1, 0).
iniziale([8,0,9,7,14,4,5,3,6,15,13,10,1,2,11,12]).
e([3, 3, 2, 3, 2, 2, 2, 4, 4, 2, 1, 1, 3, 3, 2, 5]).
pos(0,1).
%stato finale ?somma distanze da loro posizione corretta = 0
%ci sarà da inserire una euristica 
%[3, 3, 2, 3, 2, 2, 2, 4, 4, 2, 1, 1, 3, 3, 2, 5].
