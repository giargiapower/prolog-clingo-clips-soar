%applicabile(AZ,S)
applicabile(nord, pos(Riga, Colonna, Cella)):- Cella is 0,
Riga>0.

applicabile(sud, pos(Riga, Colonna, Cella)):- Cella is 0,
num_righe(NR),
Riga<NR.

applicabile(est, pos(Riga, Colonna, Cella)):- Cella is 0,
num_col(NC),
Colonna<NC.

applicabile(ovest, pos(Riga, Colonna, Cella)):- Cella is 0,
Colonna>0.

%trasforma(AZ, S, NUOVO_S)
trasforma(nord, pos(Riga, Colonna, 0),...).
