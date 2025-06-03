(in-package #:cl-gro)

(defmacro defmolecule (var name &rest atoms)
  `(defparameter ,var
     (make-instance 'residue
       :residue-name ',name
       :residue-atoms
       (list
        ,@(loop for (sym pos) in atoms
                collect `(make-instance 'single-atom
                           :single-atom-name ',sym
                           :single-atom-position ,pos))))))

(defmacro export-gro (path)
  `(with-open-file (f ,path :direction :output :if-exists :supersede)
      (write-gro *current-system* f)))






