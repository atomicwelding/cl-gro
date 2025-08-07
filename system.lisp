; by weld
(in-package #:cl-gro)



(defclass system ()
  ((title :initarg :system-title
	 :accessor system-title)
   (residues :initarg :system-residues
	  :accessor system-residues)
   (box-size :initarg :system-box-size
	     :accessor system-box-size)))



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
		    (setf (atom-number atom) atomnum)
		    (incf atomnum))))



(defmethod number-atoms-in ((system system))
  (loop for residue in (system-residues system)
       sum (number-atoms-in residue)))



(defmethod as-gro-string ((system system))
  (concatenate 'string
	       (format nil "~a~%" (system-title system))
	       (format nil "~5d~%" (number-atoms-in system))
	       (apply #'concatenate 'string (mapcar #'as-gro-string (system-residues system)))
	       (format nil "   ~8,5f ~8,5f ~8,5f~%" 
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
