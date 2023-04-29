#lang racket

(require "PRIMPL.rkt")
;(provide primpl-assemble)

;; data types
;; see readme for definition of prim-inst (primpl instruction)
;;                        and a-prim-inst (a-primpl instruction)
;; an assoc is
;; (cons sym (listof any))

;;------------------------------Helpers----------------------------------------

;; (rm-var-nm inst-lst revs-store acc) removes a-primpl instructions that involves naming a variable
;; rm-var-nm : (listof a-prim-inst) empty empty -> (listof a-prim-inst)
(define (rm-var-nm inst-lst revs-store acc)
  (cond [(empty? inst-lst) (list (reverse revs-store) acc)]
        [else
         (define v (first inst-lst))
         (define l (length revs-store))
         (match v
           [`(halt)
            (rm-var-nm (rest inst-lst)
                                   (cons 0 revs-store)
                                   acc)]
           [`(lit ,dest)
            (rm-var-nm (rest inst-lst)
                                   (cons dest revs-store)
                                   acc)]
           [`(const ,(? symbol? sym) ,dest)
            (rm-var-nm (rest inst-lst)
                                   revs-store
                                   (duplicate-cons `(,sym (,dest const)) acc))]
           [`(data ,(? symbol? sym) (,nat ,dest))
            (unless (and (integer? nat) (> nat 0)) (error "incorrect"))
            (rm-var-nm (rest inst-lst)
                                   (append (build-list nat (lambda (x) dest)) revs-store)
                                   (duplicate-cons `(,sym (,l data)) acc))]
           [(cons 'data (cons (? symbol? sym) lst-var))
            (rm-var-nm
             (rest inst-lst)
             (foldl cons revs-store (if (empty? lst-var) (error "incorrect") lst-var))
             (duplicate-cons `(,sym (,l data)) acc))]
           [`(label ,(? symbol? sym))
            (rm-var-nm (rest inst-lst)
                                   revs-store
                                   (duplicate-cons `(,sym (,l label)) acc))]
           [(? symbol? x) (error "incorrect")]
           [x (rm-var-nm (rest inst-lst)
                                     (cons x revs-store)
                                     acc)])]))

;; (duplicate-cons x lst) is like cons but prevents duplicate from appearing
;;  in the resulting association list
;; duplicate-cons : assoc assoc-list -> assoc-list
(define (duplicate-cons x lst)
  (map (lambda (y)
         (when (symbol=? (first x) (first y))
           (error "duplicate")))
       lst)
  (cons x lst))

;; (replace tbl len) removes occuring nested referencing in tbl
;; replace : assoc-list -> assoc-list
(define (replace tbl len)
  (for [(i len)]
    (match (list-ref tbl i) ;; Racket built-in list-ref is almost O(1). For improvement, change this to a vector.
      [`(,key1 (,val1 ,type1))
       (when (equal? key1 val1) (error "circular"))
       (for [(j len)]
         (if (= i j)
             (void)
             (match (list-ref tbl j)
               [`(,key2 (,val2 ,type2))
                (cond[ (equal? key1 val2)                     
                       (set! tbl (list-set tbl j `(,key2 (,val1 ,type2))))]
                     [else (void)])])))]))
  tbl)

;; (error-check assoc-list) checks if any undefined variable remains in
;;  assoc-list
;; error-check : assoc-list -> assoc-list
(define (error-check assoc-list)
  (map (lambda (x)
         (match x
           [`(,key (,val ,type))
            (when (symbol? val) (error "undefined" val))
            x]))
       assoc-list))

;; (match-opd opd hash-tbl label?) replaces var-names in instruction with
;;  what it refers to
;; match-opd : (anyof num (num) sym) hash-table bool -> opd
(define (match-opd opd hash-tbl label?)
  (match opd
    [(? number? opd) opd]
    [`(,(? number? i)) opd]
    [(? symbol? opd)
     (define res (hash-ref hash-tbl opd 'unbound))
     (match res
       ['unbound (error "undefined" opd)]
       [`((,dest label)) (if label?
                            dest
                            (error "incorrect" opd))]
       [`((,dest const)) (if label?
                             (error "incorrect" opd)
                             dest)]
       [`((,dest data)) (list dest)])]
    [`(,i ,j)
     (list (match i
             [(? symbol? v)
              (define res (hash-ref hash-tbl v 'unbound))
              (match res
                ['unbound (error "undefined" v)]
                [`((,dest 'label)) (error "incorrect")]
                [x (first (first x))])]
             [x x])
           (match-ind j hash-tbl))]))



;; (match-opd opd hash-tbl label?) replaces var-names in instruction with
;;  what it refers to
;; match-opd : (anyof num (num) sym) hash-table bool -> opd
(define (match-ind opd hash-tbl)
  (match opd
    [`(,(? number? i)) opd]
    [`(,(? number? i) (,(? number? j))) opd]
    [`(,(? number? i) ,(? symbol? j))
     (define res (hash-ref hash-tbl j 'unbound))
     (match res
       ['unbound (error "undefined" j)]
       [`((,dest 'label)) (error "incorrect")]
       [x (list i (list (first (first x))))])]
    [(? symbol? opd)
     (define res (hash-ref hash-tbl opd 'unbound))
     (match res
       ['unbound (error "undefined" opd)]
       [`((,dest data)) (list dest)]
       [x (error "incorrect")])]
    [`(,i ,j)
     (list (match i
             [(? symbol? v)
              (define res (hash-ref hash-tbl v 'unbound))
              (match res
                ['unbound (error "undefined" v)]
                [`((,dest 'label)) (error "incorrect")]
                [x (first (first x))])]
             [x x])
           (match-ind j hash-tbl))]))


;;--------------------------------------------Assembler--------------------------------------------


;; primpl-assemble : (listof a-prim-inst) -> (listof prim-inst)
(define (primpl-assemble inst-lst)
  (define lst-nd-assoc (rm-var-nm inst-lst empty empty))
  (define hash-tbl (make-hash (error-check (replace (second lst-nd-assoc)
                                                    (length (second lst-nd-assoc))))))
  (map (lambda (v)
         (match v
           [(? number? v) v]
           [(? symbol? v)
            (define res (hash-ref hash-tbl v 'unbound))
            (match res
              ['unbound (error "undefined" v)]
              [x (first (first x))])]
           [`(branch ,opd1 ,opd2)
            `(branch ,(match-opd opd1 hash-tbl false)
                     ,(match-opd opd2 hash-tbl true))]
           [`(jump ,opd)
            `(jump ,(match-opd opd hash-tbl true))]
           [`(jsr ,dest ,pc)
            `(jsr ,(match-ind dest hash-tbl)
                  ,(match-opd pc hash-tbl true))]
           [`(,op ,dest ,opd1 ,opd2)
            `(,op ,(match-ind dest hash-tbl)
                  ,(match-opd opd1 hash-tbl false)
                  ,(match-opd opd2 hash-tbl false))]
           [`(,op ,dest ,opd)
            `(,op ,(match-ind dest hash-tbl)
                  ,(match-opd opd hash-tbl false))]
           [`(print-val ,opd)
            `(print-val ,(match-opd opd hash-tbl false))]
           [`(print-string ,str)
            `(print-string ,str)]
           ))
       (first lst-nd-assoc)))

(define test-prog '((label LOOP-TOP)        ; loop-top:
                    (gt TMP1 X 0)           ;  tmp1 <- (x > 0)
                    (branch TMP1 LOOP-CONT) ;  if tmp1 goto loop-cont
                    (jump LOOP-DONE)        ;  goto loop-done
                    (label LOOP-CONT)       ; loop-cont:
                    (mul Y 2 Y)             ;  y <- 2 * y
                    (sub X X 1)             ;  x <- x - 1
                    (print-val Y)           ;  print y
                    (print-string "\n")     ;  print "\n"
                    (jump LOOP-TOP)         ;  goto loop-top
                    (label LOOP-DONE)       ; loop-done:
                    (halt)                  ;  halt
                    (data X 10)
                    (data Y 1)
                    (data TMP1 0)))


