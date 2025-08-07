(asdf:defsystem #:cl-gro
  :description "A DSL to build molecular dynamics system in gromacs"
  :author "weld"
  :license "to-be-defined"
  :version "0.1"
  :depends-on ("cl-vmd" "parse-number" "fiveam")
  :components ((:file "package")
	       (:file "system")
	       (:file "residue")
	       (:file "atom")
	       (:file "import")
	       (:file "visualize")
	       (:module "examples"
		:components ((:file "run-demo")))
	       (:module "tests"
		:components ((:file "package")
			     (:file "tests")))))
