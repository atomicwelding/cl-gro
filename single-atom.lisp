(in-package #:cl-gro)


(defclass single-atom ()
  ((id :initarg :single-atom-id
       :type integer
       :accessor single-atom-id)
   (name :initarg :single-atom-name
	 :type symbol
	 :accessor single-atom-name)
   (position :initarg :single-atom-position
	     :type (vector float 3)
	     :accessor single-atom-position)))
