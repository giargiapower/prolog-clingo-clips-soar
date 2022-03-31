num_col(4).
num_righe(4).
%pos(riga, colonna, tessera).
% usiamo assert e regret per aggiungere e rimuovere conoscenza del dominio. in questo modo basta
% aggiungere i nuovi valori nelle celle e rimuovere quelli vecchi che non valgono più.
% es |-|1| --> sposto 1 ovvero pos(0, 1, 1)  a sinistra e quindi aggiorno quel pos e metto quello nuovo
% -> pos(0,0,1)  , pos(0 ,1, 0).
pos(0,0,6).
pos(0,1,13).
pos(0,2,1).
pos(0,3,7).
pos(1,0,0).
pos(1,1,9).
pos(1,2,4).
pos(1,3,12).
pos(2,0,10).
pos(2,1,2).
pos(2,2,11).
pos(2,3,14).
pos(3,0,3).
pos(3,1,5).
pos(3,2,15).
pos(3,3,8).
%ci sarà da inserire una euristica 
