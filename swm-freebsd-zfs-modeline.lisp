;; swm-freebsd-zfs-modeline.lisp
;;
;; Put %P %O %T %F %p in your modeline format string to show the zfs pool name,
;; space occupied, total space, free space, and percentage of space occupied for
;; the pool respectively.  All sizes are in GiB.
;;

(in-package #:swm-freebsd-zfs-modeline)

(defvar *free* "0")
(defvar *occupied* "0")
(defvar *percent* "0")
(defvar *pool* "")
(defvar *read* "0.0")
(defvar *total* "0")
(defvar *write* "0.0")
(defvar *zfs-stream* nil)

(defun set-zfs-stream ()
  (setf *zfs-stream*
	(sb-ext:process-output
	 (sb-ext:run-program "ml_zfs.sh" nil
			     :output :stream
			     :search t
			     :wait nil))))

(defun fmt-zfs-pool-modeline (ml)
  "Return the zfs pool name"
  (when (not *zfs-stream*)
    (set-zfs-stream))
  (when (listen *zfs-stream*)
    (let ((zfs-info (stumpwm::split-string
		     (read-line *zfs-stream* nil "") " ")))
      (setf *pool* (car zfs-info))
      (setf *occupied* (nth 1 zfs-info))
      (setf *total* (nth 2 zfs-info))
      (setf *free* (nth 3 zfs-info))
      (setf *percent* (nth 4 zfs-info))
      (setf *read* (nth 5 zfs-info))
      (setf *write* (nth 6 zfs-info))))
  (format nil "~a" *pool*))

(defun fmt-zfs-occupied-modeline (ml)
  "Return the space occupied in the zfs pool in GiB"
  (declare (ignore ml))
  (format nil "~3d" (read-from-string *occupied*)))

(defun fmt-zfs-total-modeline (ml)
  "Return the total space available to the zfs pool in GiB"
  (declare (ignore ml))
  (format nil "~3d" (read-from-string *total*)))

(defun fmt-zfs-free-modeline (ml)
  "Return the free space available to the zfs pool in GiB"
  (declare (ignore ml))
  (format nil "~3d" (read-from-string *free*)))

(defun fmt-zfs-percent-modeline (ml)
  "Return the percentage of total space used in GiB for the zfs pool"
  (declare (ignore ml))
  (format nil "~3d" (read-from-string *percent*)))

(defun fmt-disk-read-modeline (ml)
  "Return the disk read throughput in MiB/s"
  (declare (ignore ml))
  (format nil "~5,1f" (read-from-string *read*)))

(defun fmt-disk-write-modeline (ml)
  "Return the disk write throughput in MiB/s"
  (declare (ignore ml))
  (format nil "~5,1f" (read-from-string *write*)))

;; Install formatters
(stumpwm::add-screen-mode-line-formatter #\F #'fmt-zfs-free-modeline)
(stumpwm::add-screen-mode-line-formatter #\O #'fmt-zfs-occupied-modeline)
(stumpwm::add-screen-mode-line-formatter #\P #'fmt-zfs-pool-modeline)
(stumpwm::add-screen-mode-line-formatter #\p #'fmt-zfs-percent-modeline)
(stumpwm::add-screen-mode-line-formatter #\T #'fmt-zfs-total-modeline)
(stumpwm::add-screen-mode-line-formatter #\R #'fmt-disk-read-modeline)
(stumpwm::add-screen-mode-line-formatter #\W #'fmt-disk-write-modeline)
