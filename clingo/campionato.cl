squadra(inter;juventus;roma;lazio;milan;genoa;sassuolo;torino;fiorentina;sampdoria).

andata(1..10).
ritorno(1..19).

citta(inter,milano).
citta(juventus, torino).
citta(roma,roma).
citta(lazio,roma).
citta(genoa,genova).
citta(milan,milano).
citta(sassuolo,sassuolo).
citta(torino,torino).
citta(fiorentina,firenze).
citta(sampdoria,genova).

struttura(milano,sansiro).
struttura(torino,allianzStadium).
struttura(roma,olimpico).
struttura(genova,luigiFerraris).
struttura(sassuaolo,mapei).
struttura(fiorentina,comunale).

1 {assegna(Team,Stadio):struttura(Citta,Stadio)} 1:-squadra(Team).

1 {assegna(Team,N):andata(N)} 1:-squadra(Team).
1 {assegna(Team,N):squadra(Team)} 10:-andata(N).

:-andata(N),squadra(T1),squadra(T2),assegna(T1,N),assegna(T2,N),T1<>T2.



#show assegna/2.
