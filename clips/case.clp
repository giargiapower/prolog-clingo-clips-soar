(defmodule MAIN (export ?ALL))

;;****************
;;* DEFFUNCTIONS *
;;****************

(deffunction MAIN::ask-question (?question ?allowed-values)
   (printout t ?question)
   (bind ?answer (read))
   (if (lexemep ?answer) then (bind ?answer (lowcase ?answer)))
   (while (not (member$ ?answer ?allowed-values)) do
      (printout t ?question)
      (bind ?answer (read))
      (if (lexemep ?answer) then (bind ?answer (lowcase ?answer))))
   ?answer)

;;*****************
;;* INITIAL STATE *
;;*****************

(deftemplate MAIN::attribute
   (slot name)
   (slot value)
   (slot city (default nill))
   (slot certainty (default 100.0)))

(deftemplate MAIN::flag
   (slot profile)
   )

(defrule MAIN::start
  (declare (salience 10000))
  =>
  (set-fact-duplication TRUE)
  (focus PROFILING CHOOSE-PROFILING-HOUSES HOUSES PRINT-RESULTS QUESTIONS CHOOSE-HOUSES HOUSES PRINT-RESULTS))
  

;; se ci sono 2 fatti uguali ma con CF diversi combinali

(defrule MAIN::combine-certainties ""
  (declare (salience 100)
           (auto-focus TRUE))
  ?rem1 <- (attribute (name ?rel) (value ?val) (certainty ?per1))
  ?rem2 <- (attribute (name ?rel) (value ?val) (certainty ?per2))
  (test (neq ?rem1 ?rem2))
  =>
  (retract ?rem1)
  (modify ?rem2 (certainty (/ (- (* 100 (+ ?per1 ?per2)) (* ?per1 ?per2)) 100))))

;;******************
;;* PROFILING RULES *
;;******************

(defmodule PROFILING (import MAIN ?ALL) (export ?ALL))

(deftemplate PROFILING::question
   (slot attribute (default ?NONE))
   (slot the-question (default ?NONE))
   (multislot valid-answers (default ?NONE) (range 1 400) )
   (slot already-asked (default FALSE))
   (slot precursors-name )
   (slot precursors-answer))
   
   
(defrule PROFILING::ask-a-question
   ?f <- (question (already-asked FALSE)
                   (precursors-name nil)
                   (precursors-answer nil)
                   (the-question ?the-question)
                   (attribute ?the-attribute)
                   (valid-answers $?valid-answers))
   =>
   (modify ?f (already-asked TRUE))
   (assert (attribute (name ?the-attribute)
                      (value (ask-question ?the-question ?valid-answers)))))

  ;; se è presente un attribute il cui la cui risposta è il precursore di una question fai la question
  
(defrule PROFILING::precursor-is-ok
   ?f <- (question  (already-asked FALSE)
                   (precursors-name ?prec)
                   (precursors-answer ?preca)
                   (the-question ?the-question)
                   (attribute ?the-attribute)
                   (valid-answers $?valid-answers))
         (attribute (name ?prec) (value ?preca))
   =>
   (modify ?f (already-asked TRUE))
   (assert (attribute (name ?the-attribute)
                      (value (ask-question ?the-question ?valid-answers)))))

(defrule PROFILING::activate-flag
     =>(assert (flag (profile si)))
)

  
;;******************
;;* QUESTION RULES *
;;******************

(defmodule QUESTIONS (import MAIN ?ALL) (export ?ALL))

(deftemplate QUESTIONS::question
   (slot attribute (default ?NONE))
   (slot the-question (default ?NONE))
   (multislot valid-answers (default ?NONE))
   (slot already-asked (default FALSE))
   (slot precursors-name )
   (slot precursors-answer))
   
   
(defrule QUESTIONS::ask-a-question
   ?f <- (question (already-asked FALSE)
                   (precursors-name nil)
                   (precursors-answer nil)
                   (the-question ?the-question)
                   (attribute ?the-attribute)
                   (valid-answers $?valid-answers))
   =>
   (modify ?f (already-asked TRUE))
   (assert (attribute (name ?the-attribute)
                      (value (ask-question ?the-question ?valid-answers)))))

  ;; se è presente un attribute il cui la cui risposta è il precursore di una question fai la question
  
(defrule QUESTIONS::precursor-is-ok
   ?f <- (question  (already-asked FALSE)
                   (precursors-name ?prec)
                   (precursors-answer ?preca)
                   (the-question ?the-question)
                   (attribute ?the-attribute)
                   (valid-answers $?valid-answers))
         (attribute (name ?prec) (value ?preca))
   =>
   (modify ?f (already-asked TRUE))
   (assert (attribute (name ?the-attribute)
                      (value (ask-question ?the-question ?valid-answers)))))




;;***********************
;;* HOUSE-QUESTIONS *
;;***********************

(defmodule HOUSE-QUESTIONS (import QUESTIONS ?ALL))

(deffacts HOUSE-QUESTIONS::question-attributes
  (question (attribute terrazzino)
            (the-question "Vuole una casa con il terrazzino? ")
            (valid-answers si no))
  (question (attribute boxAuto)
            (the-question "Vuole avere un boxAuto?")
            (valid-answers si no))
  (question (attribute numPiano)
            (the-question "A che piano cerca casa?")
            (valid-answers type 1 2 3 4 5 6 unknown))
  (question (attribute numVani)
            (the-question "Quante stanze cerca?")
            (valid-answers 2 3 4 5))
  (question (attribute numBagni)
            (the-question "Quanti bagni vuole? ")
            (valid-answers 1 2 3))
  (question (attribute metropolitana)
            (precursors-name zona_scelta)
            (precursors-answer centro)
            (the-question "Vuole la metropolitana vicina? ")
            (valid-answers si no unknown))
  (question (attribute scuole)
            (precursors-name zona_scelta)
            (precursors-answer centro)
            (the-question "Vuole la scuola vicino a casa? ")
            (valid-answers si no unknown))
  (question (attribute metropolitana)
            (precursors-name zona_scelta)
            (precursors-answer periferia)
            (the-question "Vuole la metropolitana vicina? ")
            (valid-answers si no unknown))
  (question (attribute scuole)
            (precursors-name zona_scelta)
            (precursors-answer periferia)
            (the-question "Vuole la scuola vicino a casa? ")
            (valid-answers si no unknown))
  (question (attribute scuola)
            (precursors-name zona_scelta)
            (precursors-answer prima_cintura)
            (the-question "Vuole la scuola vicino a casa? ")
            (valid-answers si no unknown))
  (question (attribute supermercati)
            (precursors-name zona_scelta)
            (precursors-answer prima_cintura)
            (the-question "Vuole il supermercato vicino a casa? ")
            (valid-answers si no unknown))
  (question (attribute zona_scelta)
            (the-question "cerchi casa in centro, periferia o prima_cintura? ")
            (valid-answers centro periferia prima_cintura))
  (question (attribute citta_scelta)
            (the-question "In quale citta cerca casa? ")
            (valid-answers torino milano roma))
(question (attribute migliore-prezzo)
            (the-question "a quanto ammonta circa il suo budget (5 10 20 50 75 100 110 120 150 175 200 210 220 250 275 300)?")
            (valid-answers 5 10 20 50 75 100 110 120 150 175 200 210 220 250 275 300))
)



;;***********************
;;* FIRST-USER-QUESTIONS *
;;***********************

(defmodule FIRST-USER-QUESTIONS (import PROFILING ?ALL))

(deffacts FIRST-USER-QUESTIONS::question-attributes
  (question (attribute figli)
            (the-question "hai dei figli: si o no? ")
            (valid-answers si no))
  (question (attribute eta_figli)
            (precursors-name figli)
            (precursors-answer si)
            (the-question "sono figli grandi o piccoli? ")
            (valid-answers grandi piccoli))
  (question (attribute mezzi)
            (the-question "usi i mezzi per andare al lavoro? ")
            (valid-answers si no))
  (question (attribute parenti)
            (the-question "vuoi abitare vicino ai tuoi parenti?")
            (valid-answers si no))
  (question (attribute zona_parenti)
            (precursors-name parenti)
            (precursors-answer si)
            (the-question "in che città abitano i tuoi parenti?")
            (valid-answers milano torino roma))
  (question (attribute dim_citta)
            (the-question "vuoi abitare in citta grandi o piccole?")
            (valid-answers grandi piccole))
            )




;;******************
;; The RULES module
;;******************

(defmodule RULES (import MAIN ?ALL) (export ?ALL))
 

;; NOTA BENE IL CF_VALUE NON E' IL CF DELLA RULE MA IL CF DELL'ATTRIBUTO 

 (deftemplate RULES::rule
  (slot certainty (default 100.0))
  (slot question)
  (slot answer)
  (slot attribute)
  (multislot value_attribute)
  (multislot cf_value)
  )

(defrule RULES::remove-question-answer-when-satisfied
  ?f <- (rule (certainty ?c1) 
              (question ?attribute & ~nill)
              (answer ?value & ~nill))
  (attribute (name ?attribute) 
             (value ?value) 
             (certainty ?c2))
  =>
  (modify ?f (certainty (min ?c1 ?c2)) (question nill) (answer nill)))

  (defrule RULES::conclude-new-attribute
  ?f <- (rule (certainty ?c1) 
              (question nill)
              (answer nill) 
              (attribute ?attribute)
              (value_attribute ?value $?rest)
              (cf_value ?c2 $?cf_rest))
  =>
  (modify ?f (value_attribute ?rest) (cf_value ?cf_rest))
  (assert (attribute (name ?attribute) 
                     (value ?value)
                     (certainty (/ (* ?c1 ?c2) 100)))))

;;*******************************
;;* CHOOSE PROFILING HOUSES RULES *
;;*******************************

(defmodule CHOOSE-PROFILING-HOUSES (import RULES ?ALL)
                         (import PROFILING ?ALL)
                            (import MAIN ?ALL))

(defrule CHOOSE-PROFILING-HOUSES::startit => (focus RULES))

(deffacts the-houses-rules

;; regole per la profilazione utente
(rule (question zona_parenti)
        (answer milano)
        (attribute citta)
        (value_attribute milano torino roma)
        (cf_value 90 10 10)
        )
(rule (question zona_parenti)
        (answer torino)
        (attribute citta)
        (value_attribute milano torino roma)
        (cf_value 10 90 10)
        )
(rule (question zona_parenti)
        (answer roma)
        (attribute citta)
        (value_attribute milano torino roma)
        (cf_value 10 10 90)
        )

  (rule (question figli)
        (answer si)
        (attribute scuole)
        (value_attribute si no)
        (cf_value 80 10)
        )

 (rule (question figli)
        (answer no)
        (attribute scuole)
        (value_attribute no si)
        (cf_value 80 10)
        )

(rule (question figli)
      (answer si)
      (attribute migliore-quartiere)
      (value_attribute crocetta campidoglio san_donato centro_storico citta_studi ponte_nuovo flaminio testaccio boccea magliana)
      (cf_value 80 60 40 70 80 70 50 80 50 30)
      )

(rule (question figli)
      (answer si)
      (attribute migliore-zona)
      (value_attribute centro prima_cintura periferia)
      (cf_value 70 50 30)
      )

(rule (question figli)
      (answer no)
      (attribute migliore-zona)
      (value_attribute centro prima_cintura periferia)
      (cf_value 60 70 70)
      )

(rule (question eta_figli) 
      (answer grandi)
      (attribute migliore-quartiere) 
      (value_attribute vanchiglia campidoglio citta_studi centro_storico testaccio flaminio) 
      (cf_value 80 50 70 80 60 60)
      )

(rule (question figli) 
      (answer no)
      (attribute migliore-quartiere)
      (value_attribute crocetta san_paolo san_donato centrale ponte_nuovo pilone flaminio magliana boccea)
      (cf_value 40 80 70 50 40 70 60 70 30)
      )


(rule (question mezzi)
      (answer si)
      (attribute migliore-citta)
      (value_attribute milano torino roma)
      (cf_value 70 60 50)
      )

(rule (question mezzi)
      (answer no)
      (attribute migliore-quartiere)
      (value_attribute san_paolo vanchiglia campidoglio pilone centro_storico sassi flaminio boccea magliana)
      (cf_value 80 40 60 80 50 70 40 50 70)
      )

(rule (question dim_citta)
      (answer grandi)
      (attribute migliore-citta)
      (value_attribute milano roma torino)
      (cf_value 80 70 50)
      )

(rule (question dim_citta)
      (answer piccole)
      (attribute migliore-citta)
      (value_attribute torino milano roma)
      (cf_value 80 50 30)
      )

)





;;*******************************
;;* CHOOSE HOUSES RULES *
;;*******************************

(defmodule CHOOSE-HOUSES (import RULES ?ALL)
                        (import QUESTIONS ?ALL)
                            (import MAIN ?ALL))

(defrule CHOOSE-HOUSES::startit => (focus RULES))

(deffacts the-houses-rules
;;regole specifiche sulla scelta della casa (serve un modulo diverso??)

(rule (question citta_scelta)
        (answer milano)
        (attribute migliore-citta)
        (value_attribute milano torino roma)
        (cf_value 90 10 10)
        )
(rule (question citta_scelta)
        (answer torino)
        (attribute migliore-citta)
        (value_attribute milano torino roma)
        (cf_value 10 90 10)
        )
(rule (question citta_scelta)
        (answer roma)
        (attribute migliore-citta)
        (value_attribute milano torino roma)
        (cf_value 10 10 90)
        )

(rule (question zona_scelta)
        (answer centro)
        (attribute migliore-zona)
        (value_attribute centro periferia prima_cintura)
        (cf_value 90 10 10)
        )
(rule (question zona_scelta)
        (answer periferia)
        (attribute migliore-zona)
        (value_attribute centro periferia prima_cintura)
        (cf_value 10 90 10)
        )
(rule (question zona_scelta)
        (answer prima_cintura)
        (attribute migliore-zona)
        (value_attribute centro periferia prima_cintura)
        (cf_value 10 10 90)
        )

(rule (question terrazzino)
        (answer si)
        (attribute migliore-quartiere)
        (value_attribute crocetta vanchiglia san_donato san_paolo centro_storico porta_venezia pillone magliana boccea teastaccio)
        (cf_value 80 60 40 70 70 40 80 50 70 80)
        )

(rule (question boxAuto)
        (answer si)
        (attribute migliore-quartiere)
        (value_attribute crocetta vanchiglia san_donato san_paolo centro_storico porta_venezia pillone magliana boccea teastaccio flaminio)
        (cf_value 80 70 40 30 70 40 80 80 40 50 40)
        )

(rule (question metropolitana)
        (answer si)
        (attribute migliore-quartiere)
        (value_attribute crocetta vanchiglia campidoglio san_donato centro_storico porta_venezia sassi lazzareto boccea teastaccio magliana flaminio)
        (cf_value 70 70 40 30 80 70 40 80 40 80 50 80)
        )

(rule (question scuole)
        (answer si)
        (attribute migliore-quartiere)
        (value_attribute crocetta vanchiglia campidoglio cenisia centro_storico porta_venezia sassi pillone boccea teastaccio magliana flaminio)
        (cf_value 80 70 70 40 80 50 70 40 60 50)
        )

(rule (question supermercati)
        (answer si)
        (attribute migliore-quartiere)
        (value_attribute crocetta vanchiglia campidoglio cenisia centro_storico porta_venezia sassi pillone boccea teastaccio magliana flaminio)
        (cf_value 80 40 70 70 40 80 70 40 70 80 70 80)
        )

(rule (question numBagni)
        (answer 1)
        (attribute numBagni)
        (value_attribute 1 2 3)
        (cf_value 80 50 10)
        )

(rule (question numBagni)
        (answer 2)
        (attribute numBagni)
        (value_attribute 1 2 3)
        (cf_value 50 80 50)
        )

(rule (question numBagni)
        (answer 3)
        (attribute numBagni)
        (value_attribute 1 2 3)
        (cf_value 10 50 80)
        )

(rule (question numVani)
        (answer 2)
        (attribute numBagni)
        (value_attribute 2 3 4 5)
        (cf_value 80 60 30 10)
        )

(rule (question numVani)
        (answer 3)
        (attribute numBagni)
        (value_attribute 2 3 4 5)
        (cf_value 50 80 50 30)
        )

(rule (question numVani)
        (answer 4)
        (attribute numBagni)
        (value_attribute 2 3 4 5)
        (cf_value 30 50 80 50)
        )

(rule (question numVani)
        (answer 5)
        (attribute numBagni)
        (value_attribute 2 3 4 5)
        (cf_value 10 30 60 80)
        )



)

;;******************
;; The HOUSES module
;;******************


(defmodule HOUSES (import MAIN ?ALL))

;; questi sono gli attributi con cui fa la scelta  da sistemare ovvero deve 
;; essere come house 
(deffacts any-attributes
  (attribute (name migliore-citta) (value any))
  (attribute (name migliore-zona) (value any))
  (attribute (name migliore-quartiere) (value any))
  (attribute (name numBagni) (value any))
  (attribute (name numVani) (value any))
  (attribute (name numPiano) (value any))
  (attribute (name migliore-prezzo) (value any))
  (attribute (name terrazzino) (value any))
  (attribute (name boxAuto) (value any)) 
  (attribute (name metropolitana) (value any))
  (attribute (name scuole) (value any))
  (attribute (name supermercati) (value any))
)

(deftemplate HOUSES::house
  (slot indirizzo (default nill))
  (slot citta (default any))
  (slot zona (default any))
  (slot quartiere (default any))
  (slot numBagni (type INTEGER))
  (slot numVani (type INTEGER))
  (slot numPiano (type INTEGER))
  (slot prezzo (type INTEGER))
  (slot terrazzino (type SYMBOL) (allowed-symbols si no))
  (slot boxAuto)
  (slot metropolitana (default nill))
  (slot scuole (default nill))
  (slot supermercati (default nill))
)


(deffacts HOUSES::house-list 
  (house  (indirizzo via_antonio_bertola_22) (citta torino) (zona centro) (quartiere crocetta) (numBagni 1) (numVani 3) (numPiano 2) (prezzo 380) (terrazzino si) (boxAuto si) (metropolitana si) (scuole si) (supermercati si))
  (house (indirizzo via_cesare_balbo_2)(citta torino) (zona centro) (quartiere vanchiglia) (numBagni 2) (numVani 5) (numPiano 5) (prezzo 180) (terrazzino si) (boxAuto si) (metropolitana si) (scuole si) (supermercati no))
  (house (indirizzo via_cesare_balbo_34)(citta torino) (zona centro) (quartiere vanchiglia) (numBagni 1) (numVani 2) (numPiano 1) (prezzo 40) (terrazzino no) (boxAuto no) (metropolitana si) (scuole si) (supermercati no))
  (house (indirizzo via_michele_lessona_10)(citta torino) (zona prima_cintura) (quartiere campidoglio) (numBagni 1) (numVani 2) (numPiano 4) (prezzo 100) (terrazzino no) (boxAuto no) (metropolitana no) (scuole si) (supermercati no))
  (house (indirizzo via_svizzera_51)(citta torino) (zona prima_cintura) (quartiere campidoglio) (numBagni 3) (numVani 2) (numPiano 1) (prezzo 50) (terrazzino si) (boxAuto si) (metropolitana no) (scuole si) (supermercati si))
  (house (indirizzo via_pinelli_100)(citta torino) (zona prima_cintura) (quartiere san_donato) (numBagni 2) (numVani 3) (numPiano 3) (prezzo 80) (terrazzino no) (boxAuto no) (metropolitana no) (scuole si) (supermercati si))
  (house (indirizzo via_germansca_21)(citta torino) (zona periferia) (quartiere cenisia) (numBagni 1) (numVani 3) (numPiano 2) (prezzo 60) (terrazzino si) (boxAuto no) (metropolitana no) (scuole no) (supermercati si))
  (house (indirizzo corso_giulio_39)(citta torino) (zona centro) (quartiere bariera) (numBagni 2) (numVani 5) (numPiano 5) (prezzo 200) (terrazzino si) (boxAuto si) (metropolitana no) (scuole si) (supermercati si))
  (house (indirizzo corso_inglilterra_41)(citta torino) (zona centro) (quartiere san_donato) (numBagni 1) (numVani 3) (numPiano 2) (prezzo 48) (terrazzino no) (boxAuto si) (metropolitana si) (scuole no) (supermercati si))
  (house (indirizzo via_vigone_31)(citta torino) (zona periferia) (quartiere san_paolo) (numBagni 2) (numVani 3) (numPiano 3) (prezzo 56) (terrazzino no) (boxAuto no) (metropolitana no) (scuole no) (supermercati si))

  (house (indirizzo piazza_della_scala_2)(citta milano) (zona centro) (quartiere centro_storico) (numBagni 1) (numVani 3) (numPiano 1) (prezzo 150) (terrazzino si) (boxAuto si) (metropolitana si) (scuole si) (supermercati no))
  (house (indirizzo viale_piave_8)(citta milano) (zona centro) (quartiere porta_venezia) (numBagni 2) (numVani 4) (numPiano 3) (prezzo 60) (terrazzino no) (boxAuto no) (metropolitana si) (scuole no) (supermercati si))
  (house (indirizzo via_gramsci)(citta milano) (zona prima_cintura) (quartiere foramgno) (numBagni 3) (numVani 2) (numPiano 4) (prezzo 80) (terrazzino no) (boxAuto si) (metropolitana no) (scuole si) (supermercati si))
  (house (indirizzo via_svizzera_51)(citta milano) (zona periferia) (quartiere sassi) (numBagni 2) (numVani 5) (numPiano 2) (prezzo 90) (terrazzino si) (boxAuto si) (metropolitana no) (scuole si) (supermercati si))
  (house (indirizzo via_svezia_51)(citta milano) (zona periferia) (quartiere pilone) (numBagni 3) (numVani 2) (numPiano 6) (prezzo 100) (terrazzino si) (boxAuto si) (metropolitana no) (scuole no) (supermercati no))
  (house (indirizzo viale_romagna)(citta milano) (zona centro) (quartiere citta_studi) (numBagni 2) (numVani 4) (numPiano 2) (prezzo 200) (terrazzino si) (boxAuto no) (metropolitana no) (scuole si) (supermercati si))
  (house (indirizzo viale_fratelli_cervi_8)(citta milano) (zona prima_cintura) (quartiere milano2) (numBagni 1) (numVani 4) (numPiano 4) (prezzo 69) (terrazzino si) (boxAuto si) (metropolitana no) (scuole si) (supermercati si))
  (house (indirizzo via_asiago_21)(citta milano) (zona periferia) (quartiere ponte_nuovo) (numBagni 2) (numVani 4) (numPiano 1) (prezzo 80) (terrazzino no) (boxAuto no) (metropolitana si) (scuole si) (supermercati no))
  (house (indirizzo via_pompeo_30)(citta milano) (zona centro) (quartiere centale) (numBagni 3) (numVani 6) (numPiano 1) (prezzo 280) (terrazzino si) (boxAuto si) (metropolitana si) (scuole si) (supermercati si))
  (house (indirizzo via_senigalia_9)(citta milano) (zona centro) (quartiere lazzareto) (numBagni 1) (numVani 2) (numPiano 1) (prezzo 50) (terrazzino si) (boxAuto si) (metropolitana no) (scuole si) (supermercati si))


  (house (indirizzo via_vignola_51)(citta roma) (zona centro) (quartiere flaminio) (numBagni 1) (numVani 2) (numPiano 1) (prezzo 50) (terrazzino si) (boxAuto no) (metropolitana si) (scuole si) (supermercati si))
  (house (indirizzo via_marchetti_52)(citta roma) (zona periferia) (quartiere magliana) (numBagni 2) (numVani 3) (numPiano 2) (prezzo 100) (terrazzino no) (boxAuto si) (metropolitana no) (scuole no) (supermercati si))
  (house (indirizzo via_boccea_3)(citta roma) (zona prima_cintura) (quartiere boccea) (numBagni 1) (numVani 3) (numPiano 3) (prezzo 150) (terrazzino si) (boxAuto no) (metropolitana si) (scuole no) (supermercati si))
  (house (indirizzo via_reni_1)(citta roma) (zona centro) (quartiere flaminio) (numBagni 1) (numVani 3) (numPiano 4) (prezzo 150) (terrazzino si) (boxAuto si) (metropolitana si) (scuole si) (supermercati no))
  (house (indirizzo via_boccea_11)(citta roma) (zona prima_cintura) (quartiere boccea) (numBagni 1) (numVani 2) (numPiano 2) (prezzo 250) (terrazzino no) (boxAuto no) (metropolitana no) (scuole si) (supermercati si))
  (house (indirizzo via_reni_60)(citta roma) (zona centro) (quartiere flaminio) (numBagni 3) (numVani 2) (numPiano 3) (prezzo 350) (terrazzino si) (boxAuto no) (metropolitana si) (scuole no) (supermercati no))
  (house (indirizzo via_manuzio_2)(citta roma) (zona periferia) (quartiere testaccio) (numBagni 3) (numVani 2) (numPiano 4) (prezzo 250) (terrazzino no) (boxAuto no) (metropolitana no) (scuole si) (supermercati si))
  (house (indirizzo via_boccea_11)(citta roma) (zona prima_cintura) (quartiere boccea) (numBagni 2) (numVani 2) (numPiano 1) (prezzo 150) (terrazzino si) (boxAuto si) (metropolitana si) (scuole si) (supermercati no))
  (house (indirizzo via_bregno_7)(citta roma) (zona centro) (quartiere flaminio) (numBagni 1) (numVani 1) (numPiano 2) (prezzo 50) (terrazzino no) (boxAuto si) (metropolitana no) (scuole no) (supermercati si))
  (house (indirizzo via_franklin_5)(citta roma) (zona periferia) (quartiere testaccio) (numBagni 3) (numVani 2) (numPiano 3) (prezzo 120) (terrazzino si) (boxAuto no) (metropolitana si) (scuole si) (supermercati no))
    

)


;; va sistemata la generazione delle case perche vanno inseriti tutti gli attributi di house  e 
;; di attribute, inoltre per gli attributi laschi come miglioreprezzo e metri quadri in (value ?p)..
;; bisogna mettere che sia minore di MAX e magggiore di MIN altrimenti matcha solo i valori esatti
(defrule HOUSES::generate-house-profiling
  (flag (profile si))
  (house (indirizzo ?i)
        (citta ?c)
        (zona  ?z )
        (quartiere ?q )
        (scuole ?sc )
        )
  (attribute (name migliore-citta) (value ?c) (certainty ?certainty-0))
  (attribute (name migliore-zona) (value ?z) (certainty ?certainty-1))
  (attribute (name migliore-quartiere) (value ?q) (certainty ?certainty-2))
  (attribute (name scuole) (value ?sc) (certainty ?certainty-3))
  =>
  (assert (attribute (name house) (value ?i) (city ?c) 
                     (certainty (min ?certainty-0 ?certainty-1 ?certainty-2 ?certainty-3)))))



;; visto che per la profilazione usiamo solo qualche attributo può avere senso avere un generate house per il secondo blocco di domande?
;;ho provato a eseguirlo e in questo modo mi da risultati sia per la profilazione utente che per le domande specifiche delle case
;;ho corretto un attributo nelle QUESTIONS perchè l'avevo scritto male e non prendeva le domande con precursor
;;ho aggiunto nel focus del main dopo QUESTIONS di nuovo CHOOSE-HOUSES HOUSES PRINT-RESULTS per vedere se continuava l'interazione e sembra funzionare

;; attributi che lasciamo laschi numBagni(da quello che ha messo l'utente in su) numVani (da quello che ha messo l'utente in su) 
;; numPiano(da quello che ha messo l'utente in su) prezzo(in un intorno di -50 e +50) 
(defrule HOUSES::generate-house
    (flag (profile no))
  (house (indirizzo ?i)
      (citta ?c)
      (zona  ?z )
      (quartiere ?q )
      (numBagni ?nb)
      (numVani ?nv)
      (numPiano ?np)
      (prezzo ?pr)
      (terrazzino ?tr)
      (boxAuto ?bx)
      (metropolitana ?mp)
      (scuole ?sc )
      (supermercati ?sm)
       )

 (attribute (name migliore-citta) (value ?c) (certainty ?certainty-0))
 (attribute (name migliore-zona) (value ?z) (certainty ?certainty-1))
  (attribute (name migliore-quartiere) (value ?q) (certainty ?certainty-2))
  (attribute (name numBagni) (value ?ba&:(neq ?ba any) & ?ba&:(>= (integer ?ba)  ?nb)) (certainty ?certainty-3))
  (attribute (name numVani) (value ?v&:(neq ?v any) & ?v&:(>= (integer ?v) (integer ?nv)) & ?v&:(neq ?v nill)) (certainty ?certainty-4))
  (attribute (name numPiano) (value ?numP&:(neq ?numP any) & ?numP&:(>= (integer ?numP) (integer ?np)) & ?numP&:(neq ?numP nill)) (certainty ?certainty-5))
  ;;(attribute (name migliore-prezzo) (value ?mpr&:(neq ?mpr any) & ?mpr&:(>= (integer ?mpr) (+ (integer ?pr) 50)) & ?mpr&:(<= (integer ?mpr) (- (integer ?pr) 50)) & ?mpr&:(neq ?mpr nill)) (certainty ?certainty-6))
  (attribute (name terrazzino) (value ?tr) (certainty ?certainty-7))
  (attribute (name boxAuto) (value ?bx) (certainty ?certainty-8))
  (attribute (name metropolitana) (value ?mp) (certainty ?certainty-9))
  (attribute (name scuole) (value ?sc) (certainty ?certainty-10))
  (attribute (name supermercati) (value ?sm) (certainty ?certainty-11))
  =>
  (assert (attribute (name house) (value ?i) (city ?c) 
                    (certainty (min ?certainty-0 ?certainty-1 ?certainty-2 ?certainty-3 ?certainty-4 ?certainty-5 ?certainty-7 ?certainty-8 ?certainty-9 ?certainty-10 ?certainty-11)))))
 ;;?certainty-6 



;;*****************************
;;* PRINT SELECTED HOUSE RULES *
;;*****************************

(defmodule PRINT-RESULTS (import MAIN ?ALL))

(defrule PRINT-RESULTS::deactivate-flag
      (declare (salience -100))
      ?f <- (flag (profile si))
      =>
     (modify ?f (profile no))
)

(defrule PRINT-RESULTS::header ""
   (declare (salience 10))
   =>
   (printout t "MAYBE THESE HOUSES MAY INTEREST YOU" crlf)
   (printout t "  HOUSE      CITY        CERTAINTY" crlf)
   (printout t " -------------------------------" crlf)
   (assert (phase print-house)))

(defrule PRINT-RESULTS::print-house ""
  ?rem <- (attribute (name house) (value ?name) (city ?c) (certainty ?per))	  
  (not (attribute (name house) (certainty ?per1&:(> ?per1 ?per))))
  =>
  (retract ?rem)
  (format t " %-24s %-24s %2d%%%n" ?name ?c ?per))

(defrule PRINT-RESULTS::remove-poor-house-choices ""
  ?rem <- (attribute (name house) (certainty ?per&:(< ?per 20)))
  =>
  (retract ?rem))

(defrule PRINT-RESULTS::end-spaces ""
   (not (attribute (name house)))
   =>
   (printout t ))


