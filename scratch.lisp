(defparameter *h*
  (make-instance 'single-atom
                 :single-atom-name 'H
                 :single-atom-position #(0.0 0.0 0.0)))

(defparameter *res*
  (make-instance 'residue
                 :residue-name 'OH
                 :residue-atoms (list *h*)))

(setf (system-residues *sys*) (list *res*))

(number-atoms *res*)
(number-atoms *sys*)
