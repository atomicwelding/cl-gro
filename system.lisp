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
	     :accessor system-residues)
   (number-atoms :initarg :system-number-atoms ; to be removed
		 :type integer
		 :reader system-number-atoms)))
