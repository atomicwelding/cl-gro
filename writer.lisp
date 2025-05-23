(in-package #:cl-gro)


(defmethod write-gro ((system system) stream)
  (format stream "~a~%" (system-title system))
  (format stream "~5d~%" (number-atoms system)) ;; number of atoms
  (vdestructuring-bind (length width height) (system-box-size system)
    (format stream "~10,5f~10,5f~10,5f~%" length width height)))





(defmethod write-gro ((system system) stream)
  (format stream "~a~%" (system-title system))	; title
  (format stream "~5d~%" (number-atoms system)) ; nb of atoms
  (loop for residue in (system-residues system)
        for resid from 1
        for resname = (residue-name residue)
        do (loop for atom in (residue-atoms residue)
                 for atomid from 1 by 1
                 for atomname = (single-atom-name atom)
                 for pos = (single-atom-position atom)
                 do (vdestructuring-bind (x y z) pos
                      (format stream "~5d~5a~5a~5d~8,3f~8,3f~8,3f~%"
                              resid resname atomname atomid x y z))))
  (vdestructuring-bind (length width height) (system-box-size system)
    (format stream "~10,5f~10,5f~10,5f~%" length width height)))
