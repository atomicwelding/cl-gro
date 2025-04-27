(asdf:defsystem #:cl-gro
  :description "A common lisp package to build molecular dynamics system in gromacs"
  :author "weld"
  :license "to-be-defined"
  :version "0.1"
  :serial t
  :components ((:file "package")
	       (:file "config")
	       (:file "vmd")))
