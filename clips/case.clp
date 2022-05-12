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
  (slot citta (default any))
  (slot zona (default any))
  (slot quartiere (default any))
  (slot numBagni (type INTEGER))
  (slot numVani (type INTEGER))
  (slot numPiano (type INTEGER))
  (slot prezzo (type INTEGER))
  (slot terrazzino (type SYMBOL) (allowed-symbols si no))
  (slot boxAuto)
  (multislot serviziCitta (default nill))
)


(deffacts HOUSES::house-list 
  (house (citta torino) (zona centro) (quartiere crocetta) (numBagni 1) (numVani 3) (numPiano 2) (prezzo 80) (terrazzino si) (boxAuto 15))
  (house (citta torino) (zona centro) (quartiere vanchiglia) (numBagni 2) (numVani 5) (numPiano 5) (prezzo 180) (terrazzino si))
)



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
  (slot question)
  (slot answer)
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

  
)


