squadra(inter;juventus;roma;lazio;milan;genoa;sassuolo;torino;fiorentina;sampdoria).

andata(1..19).
ritorno(1..10).
giornate(1..38).

haCitta(inter,milano).
haCitta(juventus,torino).
haCitta(roma,roma).
haCitta(lazio,roma).
haCitta(genoa,genova).
haCitta(milan,milano).
haCitta(sassuolo,sassuolo).
haCitta(torino,torino).
haCitta(fiorentina,firenze).
haCitta(sampdoria,genova).

offreStruttura(milano,sansiro).
offreStruttura(torino,allianzStadium).
offreStruttura(roma,olimpico).
offreStruttura(genova,luigiFerraris).
offreStruttura(sassuolo,mapei).
offreStruttura(firenze,comunale).


%assegno uno stadio per ogni squadra
1 {assegna(Team,Stadio):offreStruttura(Citta,Stadio)} 1:-squadra(Team).


%per ogni squadra assegno lo stadio di appartenenza della sua città
1 {assegna(Team,Stadio):squadra(Team)} 1:-haCitta(Team,Citta),offreStruttura(Citta,Stadio).


%creazione delle partite formate da due squadre, suddivise nelle diverse giornate (non funziona come dovrebbe)
2 { partita(Team1, Team2, N): assegna(Team1, Stadio), assegna(Team2, Stadio), Team1 <> Team2 } 2 :- andata(N).


% Esperimenti che ho provato a fare per i vincoli sulle partite al momento sono commentati

% due squadre della stessa città non possono giocare entrambe in casa durante la medesima giornata
%:- partita(Team1, Team2, N), haCitta(Team1, C), haCitta(Team2, C), Team1 != Team2.
 
%:- partita(Team1, Team2, N, and), partita(S3, S4, N, rit),
   %haCitta(S1, C), haCitta(S3, C),
   %S1 != S3.





%#show assegna/2.
#show partita/3.

