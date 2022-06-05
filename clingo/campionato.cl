squadra(inter;juventus;roma;lazio;milan;genoa;sassuolo;torino;fiorentina;sampdoria;atalanta;verona;bologna;empoli;cagliari;spezia;venezia;salernitana;udinese;napoli).

andata(1..19).
ritorno(1..19).

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
haCitta(atalanta,bergamo).
haCitta(verona,verona).
haCitta(bologna,bologna).
haCitta(empoli,empoli).
haCitta(cagliari,cagliari).
haCitta(spezia,laSpezia).
haCitta(venezia,venezia).
haCitta(salernitana,salerno).
haCitta(udinese,udine).
haCitta(napoli,napoli).




offreStruttura(milano,sansiro).
offreStruttura(torino,allianzStadium).
offreStruttura(roma,olimpico).
offreStruttura(genova,luigiFerraris).
offreStruttura(sassuolo,mapei).
offreStruttura(firenze,comunale).
offreStruttura(bergamo,gewiss).
offreStruttura(verona,marcantonio).
offreStruttura(bologna,dallAra).
offreStruttura(empoli,castellani).
offreStruttura(cagliari,domus).
offreStruttura(laSpezia,picco).
offreStruttura(venezia,penzo).
offreStruttura(salerno,arechi).
offreStruttura(udine,daciaArena).
offreStruttura(napoli,maradona).

%per ogni squadra assegno lo stadio di appartenenza della sua città
1 {assegna(Team,Stadio,Citta):squadra(Team)} 1:-haCitta(Team,Citta),offreStruttura(Citta,Stadio).


%%%%% ANDATA %%%%%

%per ogni giornata di andata genero 10 partite
10 { partita(Team1, Team2, A, a): assegna(Team1, Stadio1, Citta1), assegna(Team2, Stadio2 ,Citta2), Team1 <> Team2} 10 :- andata(A).

%escludiamo le partite in cui vi è una squadra in comune nella stessa giornata
:- partita(Team1, Team2, A, a), partita(Team3, Team1, A, a), Team2 <> Team3.
:- partita(Team1, Team2, A, a), partita(Team1, Team4, A, a), Team2 <> Team4.
:- partita(Team1, Team2, A, a), partita(Team3, Team2, A, a), Team1 <> Team3.
:- partita(Team1, Team2, A, a), partita(Team2, Team4, A, a), Team1 <> Team4.

% non può esistere una partita a squadre invertite nella stessa giornata di andata
:- partita(Team1, Team2, A1, a), partita(Team2, Team1, A2, a), A1 == A2.

% non possono esistere due partite uguali o inverite in giornate diverse di andata
:- partita(Team1, Team2, A1, a), partita(Team1, Team2, A2, a), A1 <> A2.
:- partita(Team1, Team2, A1, a), partita(Team2, Team1, A2, a), A1 <> A2.

% due squadre della stessa città non possono giocare entrambe in casa durante la medesima giornata di andata
:- partita(Team1, Team2, A, a), partita(Team3, Team4, A, a),haCitta(Team1, Citta1), haCitta(Team3, Citta3), Team1<>Team3, Citta1==Citta3.


%%%%% RITORNO %%%%%

%per ogni giornata di ritorno genero 10 partite
10 { partita(Team1, Team2, R, r): assegna(Team1, Stadio1, Citta1), assegna(Team2, Stadio2 ,Citta2), Team1 <> Team2} 10 :- ritorno(R).

%escludiamo le partite in cui vi è una squadra in comune nella stessa giornata
:- partita(Team1, Team2, R, r), partita(Team3, Team1, R, r), Team2 <> Team3.
:- partita(Team1, Team2, R, r), partita(Team1, Team4, R, r), Team2 <> Team4.
:- partita(Team1, Team2, R, r), partita(Team3, Team2, R, r), Team1 <> Team3.
:- partita(Team1, Team2, R, r), partita(Team2, Team4, R, r), Team1 <> Team4.

% non può esistere una partita a squadre invertite nella stessa giornata di ritorno
:- partita(Team1, Team2, R1, r), partita(Team2, Team1, R2, r), R1 == R2.

% non possono esistere due partite uguali o invertite in giornate diverse di ritorno
:- partita(Team1, Team2, R1, r), partita(Team1, Team2, R2, r), R1 <> R2.
:- partita(Team1, Team2, R1, r), partita(Team2, Team1, R2, r), R1 <> R2.

% due squadre della stessa città non possono giocare entrambe in casa durante la medesima giornata
:- partita(Team1, Team2, R, r), partita(Team3, Team4, R, r),haCitta(Team1, Citta1), haCitta(Team3, Citta3), Team1<>Team3, Citta1==Citta3.


%esclude le partite uguali in giornate diverse e nelle stesse giornate tra andata e ritorno
:-partita(Team1, Team2, A, a), partita(Team1, Team2, R, r), A <> R.
:-partita(Team1, Team2, A, a), partita(Team1, Team2, R, r), A == R.

%esclude le partite simmetriche tra andata e ritorno
:-partita(Team1, Team2, A, a), partita(Team2, Team1, R, r), A == R.


%#show assegna/3.
#show partita/4.
