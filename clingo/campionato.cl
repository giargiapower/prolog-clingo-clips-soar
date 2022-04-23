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



%10 {assegna(Team,N):andata(N)} 10:-squadra(Team).
%1 {assegna(Team,N):squadra(Team)} 10:-andata(N).

%2 { partita(T, T1, N, and): assegna(T, N), assegna(T1, N), T != T1 } 2 :- andata(N).

%2 { partita(T, T1, N, rit): assegna(T, N), assegna(T1, N), T != T1 } 2 :- ritorno(N).
%2 { partita(T, T1, N, 2, rit): assegna(T, N), assegna(T1, N), T != T1 } 2 :- andata(N).
%2 { partita(T, T1, N, 3, and): assegna(T, N), assegna(T1, N), T != T1 } 2 :- andata(N).


% due squadre della stessa città non possono giocare entrambe in casa durante la medesima giornata
%:- partita(S1, S2, N, and), partita(S3, S4, N, and),
   %haCitta(S1, C), haCitta(S3, C),
   %S1 != S3.
 
%:- partita(S1, S2, N, and), partita(S3, S4, N, rit),
  %haCitta(S1, C), haCitta(S3, C),
   %S1 != S3.

%:-andata(N),squadra(T1),squadra(T2),assegna(T1,N1),assegna(T2,N2),N1!=N2.

%:-andata(N1), ritorno(N2), N1!=N2.




#show assegna/2.
%#show partita/4.

