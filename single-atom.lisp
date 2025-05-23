(in-package #:cl-gro)


(defclass single-atom ()
  ((name :initarg :single-atom-name
	 :type symbol
	 :accessor single-atom-name)
   (position :initarg :single-atom-position
	     :type (vector float 3)
	     :accessor single-atom-position)))
