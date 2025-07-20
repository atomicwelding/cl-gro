(defpackage #:cl-gro
  (:use #:cl #:cl-vmd)
  (:shadow :atom))

;; TODO
;; trois choses intéressantes à coder
;; 1. des distributions
;; 2. lire des .gro

(in-package #:cl-gro)

(defclass system ()
  ((title :initarg :system-title
	 :accessor system-title)
   (residues :initarg :system-residues
	  :accessor system-residues)
   (box-size :initarg :system-box-size
	     :accessor system-box-size)))

(defclass residue ()
  ((residue-number :initarg :residue-number
		   :accessor residue-number
		   :initform nil)
   (residue-name :initarg :residue-name
		 :accessor residue-name)
   (atoms :initarg :residue-atoms
	  :accessor residue-atoms)
   (x :initarg :residue-x
      :accessor residue-x)
   (y :initarg :residue-y
      :accessor residue-y)
   (z :initarg :residue-z
      :accessor residue-z)))

(defclass atom ()
  ((name :initarg :atom-name
	 :accessor atom-name)
   (number :initarg :atom-number
	   :accessor atom-number
	   :initform nil)
   (x :initarg :atom-x
      :accessor atom-x)
   (y :initarg :atom-y
      :accessor atom-y)
   (z :initarg :atom-z
      :accessor atom-z)))


(defmacro defresidue (symbol &key name atoms)
  `(defun ,symbol (x y z)
     (make-instance 'residue
		    :residue-name ,name
		    :residue-x x
		    :residue-y y
		    :residue-z z
		    :residue-atoms
		    (list ,@(loop for (aname dx dy dz) in atoms
				  collect `(make-instance 'atom
							  :atom-name ,aname
							  :atom-x (+ ,dx x)
							  :atom-y (+ ,dy y)
							  :atom-z (+ ,dz z)))))))


(defmacro defsystem (symbol &key title box residues)
  `(defparameter ,symbol
     (make-instance 'system
       :system-title ,title
       :system-box-size ',box
       :system-residues
       (mapcar (lambda (spec)
                 (destructuring-bind (res x y z) spec
                   (funcall res x y z)))
               ,residues))))


(defmethod initialize-instance :after ((system system) &key)
  (loop for residue in (system-residues system)
	for resnum from 1 to (length (system-residues system))
	with atomnum = 1
	do
	   (setf (residue-number residue) resnum)
	   (loop for atom in (residue-atoms residue)
		 do
		    (setf (atom-number atom) atomnum))))


(defmethod number-atoms-in ((residue residue))
  (length (residue-atoms residue)))


(defmethod number-atoms-in ((system system))
  (loop for residue in (system-residues system)
       sum (number-atoms-in residue)))


(defmethod as-gro-string ((atom atom))
  (format nil "~5a~5d~8,3f~8,3f~8,3f~%"
	  (atom-name atom)
	  (atom-number atom)
	  (atom-x atom)
	  (atom-y atom)
	  (atom-z atom)))


(defmethod as-gro-string ((residue residue))
  (apply #'concatenate 'string
         (loop for atom in (residue-atoms residue)
               for resnum = (residue-number residue)
               for resname = (residue-name residue)
               collect (format nil "~5d~5<~a~>~5<~a~>~5d~8,3f~8,3f~8,3f~%"
                               resnum
                               resname
                               (atom-name atom)
                               (atom-number atom)
                               (atom-x atom)
			       (atom-y atom)
			       (atom-z atom)))))


(defmethod as-gro-string ((system system))
  (concatenate 'string
	       (format nil "~a~%" (system-title system))
	       (format nil "~5d~%" (number-atoms-in system))
	       (apply #'concatenate 'string (mapcar #'as-gro-string (system-residues system)))
	       (format nil "~8,5f ~8,5f ~8,5f~%" 
		       (first (system-box-size system)) 
		       (second (system-box-size system)) 
		       (third (system-box-size system)))))


(defmethod export-system-gro ((system system) filename)
  (with-open-file (f filename :direction :output
			      :if-exists :supersede
			      :if-does-not-exist :create
			      :external-format :utf-8)
    (format t "Writing ~a ...~%" filename)
    (format f "~a" (as-gro-string system))
    (format t "Done!~%")))


;; idees
(defmacro grid (res nx ny nz dx dy dz)
  `(list
     ,@(loop for i from 0 below nx
             append (loop for j from 0 below ny
                          append (loop for k from 0 below nz
                                       collect `(list ',res
                                                      ,(* i dx)
                                                      ,(* j dy)
                                                      ,(* k dz)))))))


;; (defun visualize (path)
;;   (send-vmd (concatenate 'string "mol new " path))
;;   (sleep 0.1)
;;   (send-vmd "mol representation VDW")
;;   (send-vmd "mol color Name")
;;   (send-vmd "mol addrep 0"))

;; tests
(defresidue water
  :name "WATER"
  :atoms (("O" 0.0000  0.0000 0.0000)
          ("H" 0.9572  0.0000 0.0000)
          ("H" -0.2390 0.9270 0.0000)))

(defresidue hydrogen
  :name "hyd"
  :atoms (("H" 0.0 0.0 0.0)))

(defsystem solvated-box
  :title "a solvated box"
  :box (10.0 10.0 10.0)
  :residues '((water 0.0 0.0 0.0)
	     (water 5.0 5.0 5.0)
	     (water 3.0 3.0 3.0)))

(defsystem solvated-box-grid
  :title "a solvated box with a grid"
  :box (100.0 100.0 100.0)
  :residues (grid water 6 6 6 3.0 3.0 3.0))

(export-system-gro solvated-box "cl-gro/example.gro")
(export-system-gro solvated-box-grid "cl-gro/example-grid.gro")
