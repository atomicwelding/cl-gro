(in-package #:cl-gro)


(defmacro vdestructuring-bind (vars vector-form &body body)
  `(destructuring-bind ,vars (coerce ,vector-form 'list)
     ,@body ))
