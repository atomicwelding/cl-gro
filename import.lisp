; by weld
(in-package #:cl-gro)



(defun import-system-gro (filename)
  (with-open-file (in filename :direction :input :external-format :utf-8)
    (let* ((title (read-line in))
           (natoms (parse-integer (string-trim " " (read-line in))))
           (residue-map (make-hash-table :test #'equal)))
      ;; atoms
      (loop for _ from 1 to natoms
            do (let ((line (read-line in)))
		 
		 (let* ((resnum (parse-integer (subseq line 0 5)))
			(resname (string-trim " " (subseq line 5 10)))
			(atomname (string-trim " " (subseq line 10 15)))
			(atomnum (parse-integer (subseq line 15 20)))
			(x (parse-number (string-trim " " (subseq line 20 28))))
			(y (parse-number (string-trim " " (subseq line 28 36))))
			(z (parse-number (string-trim " " (subseq line 36 44))))
			(key (list resnum resname)))
		   
		   
		   ;; make the atom
		   (let ((atom (make-instance 'atom
					      :atom-name atomname
					      :atom-number atomnum
					      :atom-x x :atom-y y :atom-z z)))

		     ;; velocities?		 
		     (when (>= (length line) 44)
		       (setf (atom-vx atom)
			     (parse-number (string-trim " " (subseq line 44 52))))
		       (setf (atom-vy atom)
			     (parse-number (string-trim " " (subseq line 52 60))))
		       (setf (atom-vz atom)
			     (parse-number (string-trim " " (subseq line 60 68)))))

		     ;; group by residue
		     (push atom (gethash key residue-map))))))

      ;; box-size
      (let* ((box-line (read-line in))
	     (tokens (remove "" (split-sequence:split-sequence #\Space
                                                               (string-trim " " box-line))
			     :test #'string=))
             (box-parts (mapcar #'parse-number tokens))
             (residues '()))
        
	;; build residue
        (maphash
         (lambda (key atom-list)
           (destructuring-bind (resnum resname) key
	     (push (make-instance 'residue
				  :residue-number resnum
				  :residue-name resname
				  :residue-atoms (nreverse atom-list)
				  :residue-x 0.0 :residue-y 0.0 :residue-z 0.0) 
                   residues)))
         residue-map)


	;; assign center of mass
	(loop for residue in residues
	      do (multiple-value-bind (cx cy cz) (compute-residue-center residue)
		   (setf (residue-x residue) cx)
		   (setf (residue-y residue) cy)
		   (setf (residue-z residue) cz)))
        
        ;; make system
        (make-instance 'system
                       :system-title title
                       :system-residues (nreverse residues)
                       :system-box-size box-parts)))))
