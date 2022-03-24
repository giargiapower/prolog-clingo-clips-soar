num_col(4).
num_righe(4).
%pos(riga, colonna, tessera).
% usiamo assert e regret per aggiungere e rimuovere conoscenza del dominio. in questo modo basta
% aggiungere i nuovi valori nelle celle e rimuovere quelli vecchi che non valgono più.
% es |-|1| --> sposto 1 ovvero pos(0, 1, 1)  a sinistra e quindi aggiorno quel pos e metto quello nuovo
% -> pos(0,0,1)  , pos(0 ,1, 0).
