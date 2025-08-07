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




