(defpackage #:cl-gro
  (:use #:cl #:cl-vmd #:parse-number)
  (:shadow :atom))



(in-package #:cl-gro)

;; TODO
;; trois choses intéressantes à coder
;; 0. split les fichiers
;; 1. des distributions
;; 2. Gérer les vitesses  FAUT MODIFIER ENCORE LE EXPORT EN GRO
;; 3. régler le probleme d'interactivité avec vmd
;; 4. réécrire la gestion des pat(in-package #:cl-gro)





;; idees
;; (defmacro grid (res nx ny nz dx dy dz)
;;   `(list
;;     ,@(loop for i from 0 below nx
;;             append (loop for j from 0 below ny
;;                          append (loop for k from 0 below nz
;;                                       collect `(list ',res
;;                                                      ,(* i dx)
;;                                                      ,(* j dy)
;;                                                      ,(* k dz)))))))

;; tests
;; (defresidue water
;;   :name "WATER"
;;   :atoms (("O" 0.0000  0.0000 0.0000)
;;           ("H" 0.9572  0.0000 0.0000)
;;           ("H" -0.2390 0.9270 0.0000)))

;; (defresidue hydrogen
;;   :name "hyd"
;;   :atoms (("H" 0.0 0.0 0.0)))

;; (defsystem solvated-box
;;   :title "a solvated box"
;;   :box (10.0 10.0 10.0)
;;   :residues '((water 0.0 0.0 0.0)
;; 	     (water 5.0 5.0 5.0)
;; 	     (water 3.0 3.0 3.0)))

;; (defsystem solvated-box-grid
;;   :title "a solvated box with a grid"
;;   :box (100.0 100.0 100.0)
;;   :residues (grid water 6 6 6 3.0 3.0 3.0))

;; (export-system-gro solvated-box "cl-gro/example.gro")
;; (export-system-gro solvated-box-grid "cl-gro/example-grid.gro")

;; (defparameter solvated-box-read
;;   (import-system-gro "cl-gro/example.gro"))

;; (export-system-gro solvated-box-read
;; 		   "cl-gro/example-read.gro")


;; (defparameter membrane
;;   (import-system-gro "cl-gro/membrane.gro"))

;; (export-system-gro membrane
;; 		   "cl-gro/membrane-read.gro")





