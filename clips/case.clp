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
            (valid-answers si no unknown))
  (question (attribute dim_citta)
            (the-question "preferisci citta grandi o piccole? ")
            (valid-answers grandi , piccole)))


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
  (attribute (name minBagni) (value any))
  (attribute (name minVani) (value any))
  (attribute (name minPiano) (value any))
  (attribute (name migliore-prezzo) (value any))
  (attribute (name terrazzino) (value any))
  (attribute (name boxAuto) (value any)) 
  (attribute (name metropolitana) (value any))
  (attribute (name scuole) (value any))
  (attribute (name supermercati) (value any))
)

(deftemplate HOUSES::house
  (multislot indirizzo (default nill))
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
  (house  (indirizzo via antonio bertola 22) (citta torino) (zona centro) (quartiere crocetta) (numBagni 1) (numVani 3) (numPiano 2) (prezzo 380) (terrazzino si) (boxAuto si) (metropolitana si) (scuole si) (supermercati si))
  (house (indirizzo via cesare balbo 2)(citta torino) (zona centro) (quartiere vanchiglia) (numBagni 2) (numVani 5) (numPiano 5) (prezzo 180) (terrazzino si) (boxAuto si) (metropolitana si) (scuole si) (supermercati no))
  (house (indirizzo via cesare balbo 34)(citta torino) (zona centro) (quartiere vanchiglia) (numBagni 1) (numVani 2) (numPiano 1) (prezzo 40) (terrazzino no) (boxAuto no) (metropolitana si) (scuole si) (supermercati no))
  (house (indirizzo via michele lessona 10)(citta torino) (zona prima_cintura) (quartiere campidoglio) (numBagni 1) (numVani 2) (numPiano 4) (prezzo 100) (terrazzino no) (boxAuto no) (metropolitana no) (scuole si) (supermercati no))
  (house (indirizzo via svizzera 51)(citta torino) (zona prima_cintura) (quartiere campidoglio) (numBagni 3) (numVani 2) (numPiano 1) (prezzo 50) (terrazzino si) (boxAuto si) (metropolitana no) (scuole si) (supermercati si))
  (house (indirizzo via pinelli 100)(citta torino) (zona prima_cintura) (quartiere san_donato) (numBagni 2) (numVani 3) (numPiano 3) (prezzo 80) (terrazzino no) (boxAuto no) (metropolitana no) (scuole si) (supermercati si))
  (house (indirizzo via germansca 21)(citta torino) (zona periferia) (quartiere cenisia) (numBagni 1) (numVani 3) (numPiano 2) (prezzo 60) (terrazzino si) (boxAuto no) (metropolitana no) (scuole no) (supermercati si))
  (house (indirizzo corso giulio 39)(citta torino) (zona centro) (quartiere bariera) (numBagni 2) (numVani 5) (numPiano 5) (prezzo 200) (terrazzino si) (boxAuto si) (metropolitana no) (scuole si) (supermercati si))
  (house (indirizzo corso inglilterra 41)(citta torino) (zona centro) (quartiere san_donato) (numBagni 1) (numVani 3) (numPiano 2) (prezzo 48) (terrazzino no) (boxAuto si) (metropolitana si) (scuole no) (supermercati si))
  (house (indirizzo via vigone 31)(citta torino) (zona periferia) (quartiere san_paolo) (numBagni 2) (numVani 3) (numPiano 3) (prezzo 56) (terrazzino si) (boxAuto no) (metropolitana no) (scuole no) (supermercati si))

  (house (indirizzo piazza della scala 2)(citta milano) (zona centro) (quartiere centro_storico) (numBagni 1) (numVani 3) (numPiano 1) (prezzo 150) (terrazzino si) (boxAuto si) (metropolitana si) (scuole si) (supermercati no))
  (house (indirizzo viale piave 8)(citta milano) (zona centro) (quartiere porta_venezia) (numBagni 2) (numVani 4) (numPiano 3) (prezzo 60) (terrazzino no) (boxAuto no) (metropolitana si) (scuole no) (supermercati si))
  (house (indirizzo via gramsci)(citta milano) (zona prima_cintura) (quartiere foramgno) (numBagni 3) (numVani 2) (numPiano 4) (prezzo 80) (terrazzino no) (boxAuto si) (metropolitana no) (scuole si) (supermercati si))
  (house (indirizzo via svizzera 51)(citta milano) (zona periferia) (quartiere sassi) (numBagni 2) (numVani 5) (numPiano 2) (prezzo 90) (terrazzino si) (boxAuto si) (metropolitana no) (scuole si) (supermercati si))
  (house (indirizzo via svizzera 51)(citta milano) (zona periferia) (quartiere pilone) (numBagni 3) (numVani 2) (numPiano 6) (prezzo 100) (terrazzino si) (boxAuto si) (metropolitana no) (scuole no) (supermercati no))
  (house (indirizzo viale romagna)(citta milano) (zona centro) (quartiere citta_studi) (numBagni 2) (numVani 4) (numPiano 2) (prezzo 200) (terrazzino si) (boxAuto no) (metropolitana no) (scuole si) (supermercati si))
  (house (indirizzo viale fratelli cervi 8)(citta milano) (zona prima_cintura) (quartiere milano2) (numBagni 1) (numVani 4) (numPiano 4) (prezzo 69) (terrazzino si) (boxAuto si) (metropolitana no) (scuole si) (supermercati si))
  (house (indirizzo via asiago 21)(citta milano) (zona periferia) (quartiere ponte_nuovo) (numBagni 2) (numVani 4) (numPiano 1) (prezzo 80) (terrazzino no) (boxAuto no) (metropolitana si) (scuole si) (supermercati no))
  (house (indirizzo via pompeo 30)(citta milano) (zona centro) (quartiere centarle) (numBagni 3) (numVani 6) (numPiano 1) (prezzo 280) (terrazzino si) (boxAuto si) (metropolitana si) (scuole si) (supermercati si))
  (house (indirizzo via senigalia 9)(citta milano) (zona centro) (quartiere lazzareto) (numBagni 1) (numVani 2) (numPiano 1) (prezzo 50) (terrazzino si) (boxAuto si) (metropolitana no) (scuole si) (supermercati si))


  (house (indirizzo via svizzera 51)(citta roma) (zona centro) (quartiere san_salvario) (numBagni 3) (numVani 2) (numPiano 1) (prezzo 50) (terrazzino si) (boxAuto si) (metropolitana no) (scuole si) (supermercati si))
  (house (indirizzo via svizzera 51)(citta roma) (zona centro) (quartiere cenisia) (numBagni 3) (numVani 2) (numPiano 1) (prezzo 50) (terrazzino si) (boxAuto si) (metropolitana no) (scuole si) (supermercati si))
  (house (indirizzo via svizzera 51)(citta roma) (zona periferia) (quartiere mirafiori) (numBagni 3) (numVani 2) (numPiano 1) (prezzo 50) (terrazzino si) (boxAuto si) (metropolitana no) (scuole si) (supermercati si))
  (house (indirizzo via svizzera 51)(citta roma) (zona prima_cintura) (quartiere campidoglio) (numBagni 3) (numVani 2) (numPiano 1) (prezzo 50) (terrazzino si) (boxAuto si) (metropolitana no) (scuole si) (supermercati si))
  (house (indirizzo via svizzera 51)(citta roma) (zona centro) (quartiere quadrilatero) (numBagni 3) (numVani 2) (numPiano 1) (prezzo 50) (terrazzino si) (boxAuto si) (metropolitana no) (scuole si) (supermercati si))
  (house (indirizzo via svizzera 51)(citta roma) (zona centro) (quartiere quadrilatero) (numBagni 3) (numVani 2) (numPiano 1) (prezzo 50) (terrazzino si) (boxAuto si) (metropolitana no) (scuole si) (supermercati si))
  (house (indirizzo via svizzera 51)(citta roma) (zona centro) (quartiere quadrilatero) (numBagni 3) (numVani 2) (numPiano 1) (prezzo 50) (terrazzino si) (boxAuto si) (metropolitana no) (scuole si) (supermercati si))
  (house (indirizzo via svizzera 51)(citta roma) (zona centro) (quartiere quadrilatero) (numBagni 3) (numVani 2) (numPiano 1) (prezzo 50) (terrazzino si) (boxAuto si) (metropolitana no) (scuole si) (supermercati si))
  (house (indirizzo via svizzera 51)(citta roma) (zona centro) (quartiere quadrilatero) (numBagni 3) (numVani 2) (numPiano 1) (prezzo 50) (terrazzino si) (boxAuto si) (metropolitana no) (scuole si) (supermercati si))
  (house (indirizzo via svizzera 51)(citta roma) (zona centro) (quartiere quadrilatero) (numBagni 3) (numVani 2) (numPiano 1) (prezzo 50) (terrazzino si) (boxAuto si) (metropolitana no) (scuole si) (supermercati si))
    

)


;; va sistemata la generazione delle case perche vanno inseriti tutti gli attributi di house  e 
;; di attribute, inoltre per gli attributi laschi come miglioreprezzo e metri quadri in (value ?p)..
;; bisogna mettere che sia minore di MAX e magggiore di MIN altrimenti matcha solo i valori esatti
(defrule HOUSES::generate-house
  (house (citta ?c)
        (zona  ?z )
        (quartiere ?q )
        (prezzo ?p )
        (numBagni ?nB )
        (numVani ?nV )
        (numPiano ?nP )
        (terrazzino ?t ))
  (attribute (name migliore-zona) (value ?z) (certainty ?certainty-1))
  (attribute (name migliore-quartiere) (value ?q) (certainty ?certainty-2))
  (attribute (name migliore-prezzo) (value ?p) (certainty ?certainty-3))
  =>
  (assert (attribute (name house) (value ?c) 
                     (certainty (min ?certainty-1 ?certainty-2 ?certainty-3)))))


 
;;******************
;; The RULES module
;;******************

(defmodule RULES (import MAIN ?ALL) (export ?ALL))
 

;; NOTA BENE IL CF_VALUE NON E' IL CF DELLA RULE MA IL CF DELL'ATTRIBUTO 

 (deftemplate RULES::rule
  (slot certainty (default 100.0))
  (multislot question)
  (multislot answer)
  (multislot attribute)
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

(deffacts the-hauses-rules

  (rule (question figli)
        (answer si)
        (attribute scuole)
        (value_attribute si)
        (cf_value 0.8)
        )

    (rule (question scuole)
        (answer si)
        (attribute migliore-quartiere)
        (value_attribute vanchiglia)
        (cf_value 0.8)
        )


;; regole per la profilazione utente

(rule (question figli)
      (answer si)
      (attribute migliore-quartiere)
      (value_attribute crocetta)
      (cf_value 0.7)
      )

(rule (question figli eta_figli) 
      (answer si grandi)
      (attribute migliore-quartiere) 
      (value_attribute vanchiglia) 
      (cf_value 0.8)
      )

(rule (question figli) 
      (answer no)
      (attribute migliore-quartiere migliore-zona migliore-citta migliore-prezzo)
      (value_attribute crocetta centro torino 100000)
      (cf_value 0.40 0.6 0.3 0.7)
      )

(rule (question mezzi)
      (answer si)
      (attribute migliore-quartiere)
      (value_attribute san_donato)
      (cf_value 0.8)
      )

(rule (question mezzi)
      (answer no)
      (attribute migliore-quartiere)
      (value_attribute san_paolo migliore_zona periferia)
      (cf_value 0.8 0.7)
      )

(rule (question dim_citta)
      (answer grandi)
      (attribute migliore-citta)
      (value_attribute milano roma)
      (cf_value 0.8 0.7)
      )

(rule (question dim_citta)
      (answer piccole)
      (attribute migliore-citta)
      (value_attribute torino)
      (cf_value 0.8)
      )

  
)


