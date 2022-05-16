;; QUANTI MODULI USARE 
;; DOMANDE_GENERICHE, RULES , PRINTA PRIME PROPOSTE , DEOMANDE_2 , RULES_2, PRINT, RICHIEDI_DOMANDA(DA MAIN?), CONTROLLO_UNKOWN, RULES_UNKNOWN, PRINT

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
   (slot certainty (default 100.0)))

(defrule MAIN::start
  (declare (salience 10000))
  =>
  (set-fact-duplication TRUE)
  (focus QUESTIONS))

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
;;* QUESTION RULES *
;;******************

(defmodule QUESTIONS (import MAIN ?ALL) (export ?ALL))

(deftemplate QUESTIONS::question
   (slot attribute (default ?NONE))
   (slot the-question (default ?NONE))
   (multislot valid-answers (default ?NONE) (range 1 400) )
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
;;* FIRST-USER-QUESTIONS *
;;***********************

(defmodule FIRST-USER-QUESTIONS (import QUESTIONS ?ALL))

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




;;***********************
;;* HOUSE-QUESTIONS *
;;***********************

(defmodule HOUSE-QUESTIONS (import QUESTIONS ?ALL))

(deffacts FIRST-USER-QUESTIONS::question-attributes
  (question (attribute citta_scelta)
            (the-question "In quale citta cerca casa? ")
            (valid-answers torino milano roma))
  (question (attribute zona_scelta)
            (the-question "In quale zona cerca casa? ")
            (valid-answers centro periferia prima_cintura))
  (question (attribute metropolitana)
            (precursors-name zona)
            (precursors-answer centro)
            (the-question "Vuole la metropolitana vicina? ")
            (valid-answers si no unknown))
  (question (attribute scuole)
            (precursors-name zona)
            (precursors-answer centro)
            (the-question "Vuole la scuola vicino a casa? ")
            (valid-answers si no unknown))
  (question (attribute metropolitana)
            (precursors-name zona)
            (precursors-answer periferia)
            (the-question "Vuole la metropolitana vicina? ")
            (valid-answers si no unknown))
  (question (attribute scuole)
            (precursors-name zona)
            (precursors-answer periferia)
            (the-question "Vuole la scuola vicino a casa? ")
            (valid-answers si no unknown))
  (question (attribute scuola)
            (precursors-name zona)
            (precursors-answer prima_cintura)
            (the-question "Vuole la scuola vicino a casa? ")
            (valid-answers si no unknown))
  (question (attribute supermercati)
            (precursors-name zona)
            (precursors-answer prima_cintura)
            (the-question "Vuole il supermercato vicino a casa? ")
            (valid-answers si no unknown))
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




;;*******************************
;;* CHOOSE HAUSES RULES *
;;*******************************

(defmodule CHOOSE-HAUSES (import RULES ?ALL)
                            (import QUESTIONS ?ALL)
                            (import MAIN ?ALL))

(defrule CHOOSE-HAUSES::startit => (focus RULES))

(deffacts the-houses-rules

;; regole per la profilazione utente
(rule (question zona_parenti)
        (answer milano)
        (attribute citta)
        (value_attribute milano, torino, roma)
        (cf_value 90, 10, 10)
        )
(rule (question zona_parenti)
        (answer torino)
        (attribute citta)
        (value_attribute milano, torino, roma)
        (cf_value 10, 90, 10)
        )
(rule (question zona_parenti)
        (answer roma)
        (attribute citta)
        (value_attribute milano, torino, roma)
        (cf_value 10, 10, 90)
        )

  (rule (question figli)
        (answer si)
        (attribute scuole)
        (value_attribute si)
        (cf_value 80)
        )

(rule (question figli)
      (answer si)
      (attribute migliore-quartiere)
      (value_attribute crocetta campidoglio san_donato centro_storico citta_studi ponte_nuovo)
      (cf_value 70 80 60 70 70 70)
      )

(rule (question eta_figli) 
      (answer grandi)
      (attribute migliore-quartiere) 
      (value_attribute vanchiglia citta_studi centro_storico) 
      (cf_value 80 70 80)
      )

(rule (question figli) 
      (answer no)
      (attribute migliore-quartiere)
      (value_attribute crocetta centrale ponte_nuovo san_paolo)
      (cf_value 40 60 70 80)
      )


(rule (question mezzi)
      (answer si)
      (attribute migliore-citta)
      (value_attribute milano torino roma)
      (cf_value 70 50 60)
      )

(rule (question mezzi)
      (answer no)
      (attribute migliore-quartiere)
      (value_attribute san_paolo periferia)
      (cf_value 80 70)
      )

(rule (question dim_citta)
      (answer grandi)
      (attribute migliore-citta)
      (value_attribute milano roma)
      (cf_value 80 70)
      )

(rule (question dim_citta)
      (answer piccole)
      (attribute migliore-citta)
      (value_attribute torino)
      (cf_value 80)
      )

;;regole specifiche sulla scelta della casa (serve un modulo diverso??)

(rule (question citta_scelta)
        (answer milano)
        (attribute citta)
        (value_attribute milano, torino, roma)
        (cf_value 90, 10, 10)
        )
(rule (question citta_scelta)
        (answer torino)
        (attribute citta)
        (value_attribute milano, torino, roma)
        (cf_value 10, 90, 10)
        )
(rule (question citta_scelta)
        (answer roma)
        (attribute citta)
        (value_attribute milano, torino, roma)
        (cf_value 10, 10, 90)
        )

(rule (question zona_scelta)
        (answer centro)
        (attribute zona)
        (value_attribute centro, periferia, prima_cintura)
        (cf_value 90, 10, 10)
        )
(rule (question zona_scelta)
        (answer periferia)
        (attribute zona)
        (value_attribute centro, periferia, prima_cintura)
        (cf_value 10, 90, 10)
        )
(rule (question zona_scelta)
        (answer prima_cintura)
        (attribute zona)
        (value_attribute centro, periferia, prima_cintura)
        (cf_value 10, 10, 90)
        )

(rule (question metropolitana)
        (answer si)
        (attribute zona)
        (value_attribute crocetta vanchiglia campidoglio san_donato cenisia bariera 
                         san_paolo centro_storico porta_venezia testaccio)
        (cf_value 70, 70, 60, 50, 40, 50, 80, 30, 60, 50)
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
  (house (indirizzo via_vigone_31)(citta torino) (zona periferia) (quartiere san_paolo) (numBagni 2) (numVani 3) (numPiano 3) (prezzo 56) (terrazzino si) (boxAuto no) (metropolitana no) (scuole no) (supermercati si))

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
(defrule HOUSES::generate-house
  (house (indirizzo ?i)
        (citta ?c)
        (zona  ?z )
        (quartiere ?q )
        (numBagni ?nb )
        (numVani ?nv )
        (numPiano ?nP )
        (prezzo ?prez)
        (terrazzino ?t )
        (boxAuto ?bx)
        (metropolitana ?mt )
        (scuole ?sc )
        (supermercati ?sup)
        )
  (attribute (name migliore-citta) (value ?p) (certainty ?certainty-3))
  (attribute (name migliore-zona) (value ?z) (certainty ?certainty-1))
  (attribute (name migliore-quartiere) (value ?q) (certainty ?certainty-2))
  (attribute (name minBagni) (value ?p) (certainty ?certainty-3))
  (attribute (name minVani) (value ?p) (certainty ?certainty-3))
  (attribute (name minPiano) (value ?p) (certainty ?certainty-3))
  (attribute (name migliore-prezzo) (value ?p) (certainty ?certainty-3))
  (attribute (name terrazzino) (value ?p) (certainty ?certainty-3))
  (attribute (name boxAuto) (value ?p) (certainty ?certainty-3))
  (attribute (name metropolitana) (value ?p) (certainty ?certainty-3))
  (attribute (name scuole) (value ?p) (certainty ?certainty-3))
  (attribute (name supermercati) (value ?p) (certainty ?certainty-3))
  =>
  (assert (attribute (name indirizzo) (value ?i) 
                     (certainty (min ?certainty-1 ?certainty-2 ?certainty-3)))))


 


