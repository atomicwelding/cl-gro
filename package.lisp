(defpackage #:cl-gro
  (:use #:cl)
  (:shadow :atom))

(in-package #:cl-gro)

(defclass system ()
  ((title :initarg :system-title
	 :accessor system-title)
   (atoms :initarg :system-atoms
	  :accessor system-atoms)
   (box-size :initarg :system-box-size
	     :accessor system-box-size)))


(defclass atom ()
  ((residue-number :initarg :atom-residue-number
		   :accessor atom-residue-number)
   (residue-name :initarg :atom-residue-name
		 :accessor atom-residue-name)
   (name :initarg :atom-name
	 :accessor atom-name)
   (number :initarg :atom-number
	   :accessor atom-number)
   (x :initarg :atom-x
      :accessor atom-x)
   (y :initarg :atom-y
      :accessor atom-y)
   (z :initarg :atom-z
      :accessor atom-z)))


(defmethod as-gro-string ((atom atom))
  (format nil "~5d~5a~5a~5d~8,3f~8,3f~8,3f~%"
	  (atom-residue-number atom)
	  (atom-residue-name atom)
	  (atom-name atom)
	  (atom-number atom)
	  (atom-x atom)
	  (atom-y atom)
	  (atom-z atom)))


(defmethod as-gro-string ((system system))
  (concatenate 'string
	       (format nil "~a~%" (system-title system))
	       (format nil "~5d~%" (length (system-atoms system)))
	       (apply #'concatenate 'string (mapcar #'as-gro-string (system-atoms system)))
	       (format nil "~{~8,5f~^~}" (system-box-size system))))




(defmethod export-system-gro ((system system) filename)
  (with-open-file (f filename :direction :output
			      :if-exists :supersede
			      :if-does-not-exist :create
			      :external-format :utf-8)
    (format t "Writing ~a ...~%" filename)
    (format f "~a" (as-gro-string system))
    (format t "Done!~%")))




;; idees



;; tests
(defparameter *test-atom* (make-instance 'atom
					 :atom-residue-number 1
					 :atom-residue-name "ALA"
					 :atom-name "H"
					 :atom-number 1
					 :atom-x 0.5
					 :atom-y 0.5
					 :atom-z 0.5))

(defparameter *test-system* (make-instance 'system
					   :system-title "test"
					   :system-atoms (list *test-atom*)
					   :system-box-size (list 1.0 1.0 3.0)))
