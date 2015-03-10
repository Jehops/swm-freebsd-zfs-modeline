;;;; swm-freebsd-zfs-modeline.asd

(asdf:defsystem #:swm-freebsd-zfs-modeline
  :description "Show information about a zfs pool in the StumpWM modeline"
  :author "Joseph Mingrone <jrm@ftfl.ca>"
  :license "2-CLAUSE BSD (see COPYRIGHT file for details)"
  :depends-on (#:stumpwm)
  :serial t
  :components ((:file "package")
               (:file "swm-freebsd-zfs-modeline")))
