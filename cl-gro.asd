(asdf:defsystem "cl-gro"
  :description "A DSL to build molecular dynamics system in gromacs"
  :author "weld"
  :license "to-be-defined"
  :version "0.1"
  :depends-on ("cl-vmd" "parse-number")
  :components ((:file "package")
	       (:file "system")
	       (:file "residue")
	       (:file "atom")
	       (:file "import")
	       (:file "visualize")
	       (:module "examples"
		:components ((:file "run-demo")))))


(asdf:defsystem "cl-gro/tests"
  :depends-on ("cl-gro" "fiveam")
  :serial t
  :components ((:file "tests/suites")
	       (:file "tests/tests"))
  :perform (test-op (o c)
             (uiop:symbol-call :fiveam :run! 'cl-gro-tests)))
