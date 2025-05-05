(in-package #:cl-gro)


(defmethod write-gro ((system system) stream)
  (format stream "~a~%" (system-title system))
  (format stream "~5d~%" 0.0)
  (vdestructuring-bind (length width height) (system-box-size system)
    (format stream "~10,5f~10,5f~10,5f~%" length width height)))
