(asdf:defsystem #:cl-gro
  :description "A common lisp package to build molecular dynamics system in gromacs"
  :author "weld"
  :license "to-be-defined"
  :version "0.1"
  :serial t
  :components ((:file "package")
	       (:file "config")
	       (:file "macros")
	       (:file "utils")
	       (:file "vmd")
	       (:file "single-atom")
	       (:file "residue")
	       (:file "system")
	       (:file "writer")))

(asdf:defsystem #:cl-gro/tests
  :depends-on ("cl-gro" "fiveam")
  :components ((:file "tests/package")
	       (:file "tests/tests")))

(asdf:defsystem #:cl-gro/definitions
  :depends-on ("cl-gro")
  :components ((:file "definitions/package")
	       (:file "definitions/definitions")))
