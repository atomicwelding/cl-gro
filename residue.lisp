; by weld
(in-package #:cl-gro)



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



(defmethod number-atoms-in ((residue residue))
  (length (residue-atoms residue)))



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



(defmethod compute-residue-center ((residue residue))
  (let* ((atoms (residue-atoms residue))
	 (n (length atoms)))
    (if (zerop n)
        (values 0.0 0.0 0.0)
        (loop for atom in atoms
              sum (atom-x atom) into sx
              sum (atom-y atom) into sy
              sum (atom-z atom) into sz
              finally (return (values (/ sx n) (/ sy n) (/ sz n)))))))
