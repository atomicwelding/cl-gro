;; cl-gro.asd

(asdf:defsystem #:cl-gro
  :description "A common lisp package to build molecular dynamics system in gromacs"
  :author "weld"
  :license "to-be-defined"
  :version "0.1"
  :serial t
  :components ((:file "package")
	       (:file "config")
	       (:file "macros")
	       (:file "utils")
	       (:file "vmd")
	       (:file "single-atom")
	       (:file "residue")
	       (:file "system")
	       (:file "writer")))

(asdf:defsystem #:cl-gro/tests
  :depends-on ("cl-gro" "fiveam")
  :components ((:file "tests/package")
	       (:file "tests/tests")))

(asdf:defsystem #:cl-gro/definitions
  :depends-on ("cl-gro")
  :components ((:file "definitions/package")
	       (:file "definitions/definitions")))


;; config


;; macros.lisp


(in-package #:cl-gro)

(defmacro defmolecule (var name &rest atoms)
  `(defparameter ,var
     (make-instance 'residue
       :residue-name ',name
       :residue-atoms
       (list
        ,@(loop for (sym pos) in atoms
                collect `(make-instance 'single-atom
                           :single-atom-name ',sym
                           :single-atom-position ,pos))))))

(defmacro export-gro (path)
  `(with-open-file (f ,path :direction :output :if-exists :supersede)
      (write-gro *current-system* f)))

;; residue.lisp

(in-package #:cl-gro)


(defclass residue ()
  ((name :initarg :residue-name
	 :type symbol
	 :accessor residue-name)
   (atoms :initarg :residue-atoms ; (list single-atoms)
	  :accessor residue-atoms)))


(defmethod number-atoms ((residue residue))
  (length (residue-atoms residue)))

;; scratch.lisp

(defparameter *h*
  (make-instance 'single-atom
                 :single-atom-name 'H
                 :single-atom-position #(0.0 0.0 0.0)))

(defparameter *res*
  (make-instance 'residue
                 :residue-name 'OH
                 :residue-atoms (list *h*)))

(defparameter *h2o* (make-molecule H2O
				   ((H #(-4.40648 0.97984 0.55337))
				    (O #(-3.81160 0.22047  0.46153))
				    (H #(-3.08631 0.41594 1.07366)))))

(defparameter *sys*
  (make-instance 'system
		 :system-title "A simple test"
		 :system-residues (list *h2o*)))


(number-atoms *res*)
(number-atoms *sys*)

(write-gro *sys* t)
(with-open-file (f "example.gro" :direction :output :if-exists :supersede)
      (write-gro *sys* f))


;;;;--------------------------------------------------------------------
;;;; Exemple d’utilisation
;;;;--------------------------------------------------------------------

;; 1) Déclare une molécule H2O
;; (defmolecule *h2o* H2O
;;   (H  #(-4.40648 0.97984 0.55337))
;;   (O  #(-3.81160 0.22047 0.46153))
;;   (H #(-3.08631  0.41594 1.07366)))



;; 2) Construit un système et le remplit d’eau, puis on l'enregistre
;; (build-system "Solvated box" :box-size #(2.0 2.0 2.0)
;; 	      (fill-box-with *h2o* :spacing #(0.4 0.4 0.4))
;; 	      (export-gro "example.gro"))




;; single-atoms.lisp


(in-package #:cl-gro)


(defclass single-atom ()
  ((name :initarg :single-atom-name
	 :type symbol
	 :accessor single-atom-name)
   (position :initarg :single-atom-position
	     :type (vector float 3)
	     :accessor single-atom-position)))


;; system.lisp

(in-package #:cl-gro)


(defclass system ()
  ((title :initarg :system-title
	  :type string
	  :initform "Empty title"
	  :reader system-title)
   (box-size :initarg :system-box-size ; in nm
	     :type (vector float 3)
	     :initform #(1.0 1.0 1.0)
	     :reader system-box-size)
   (residues :initarg :system-residues
	     :accessor system-residues)))



(defmethod number-atoms ((system system))
  (loop for residue in (system-residues system)
        sum (number-atoms residue)))

;; utils.lisp

(in-package #:cl-gro)


(defmacro vdestructuring-bind (vars vector-form &body body)
  `(destructuring-bind ,vars (coerce ,vector-form 'list)
     ,@body ))



;; writer.lisp


(in-package #:cl-gro)


(defmethod write-gro ((system system) stream)
  (format stream "~a~%" (system-title system))
  (format stream "~5d~%" (number-atoms system)) ;; number of atoms
  (vdestructuring-bind (length width height) (system-box-size system)
    (format stream "~10,5f~10,5f~10,5f~%" length width height)))





(defmethod write-gro ((system system) stream)
  (format stream "~a~%" (system-title system))	; title
  (format stream "~5d~%" (number-atoms system)) ; nb of atoms
  (loop for residue in (system-residues system)
        for resid from 1
        for resname = (residue-name residue)
        do (loop for atom in (residue-atoms residue)
                 for atomid from 1 by 1
                 for atomname = (single-atom-name atom)
                 for pos = (single-atom-position atom)
                 do (vdestructuring-bind (x y z) pos
                      (format stream "~5d~5a~5a~5d~8,3f~8,3f~8,3f~%"
                              resid resname atomname atomid x y z))))
  (vdestructuring-bind (length width height) (system-box-size system)
    (format stream "~10,5f~10,5f~10,5f~%" length width height)))
