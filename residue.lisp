(in-package #:cl-gro)


(defclass residue ()
  ((name :initarg :residue-name
	 :type symbol
	 :accessor residue-name)
   (atoms :initarg :residue-atoms ; (list single-atoms)
	  :accessor residue-atoms)))


(defmethod number-atoms ((residue residue))
  (length (residue-atoms residue)))

