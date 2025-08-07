; by weld
(in-package #:cl-gro)



(defmethod visualize ((system system))
  (export-system-gro system "/tmp/temp.gro")
  (vmd/script
   (mol new "/tmp/temp.gro")
   (mol representation VDW)
   (mol addrep 0)
   (mol top 0)
   (display update)))
