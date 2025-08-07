; by weld
(in-package #:cl-gro)



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
      :accessor atom-z)
   (vx :initarg :atom-vx
       :accessor atom-vx
       :initform nil)
   (vy :initarg :atom-vy
       :accessor atom-vy
       :initform nil)
   (vz :initarg :atom-vz
       :accessor atom-vz
       :initform nil)))



(defmethod as-gro-string ((atom atom))
  (format nil "~5a~5d~8,3f~8,3f~8,3f~%"
	  (atom-name atom)
	  (atom-number atom)
	  (atom-x atom)
	  (atom-y atom)
	  (atom-z atom)))
