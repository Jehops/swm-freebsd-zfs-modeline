# `swm-freebsd-zfs-modeline`

Put any of %P, %O, %T, %F, %p, %R, or %W in your StumpWM mode-line format string
(*screen-mode-line-format*) to show zfs pool name, occupied space, total space
available, free space, percentage of total space used, current read rate, and
current write rate, respectively.  Disk spaces are in GiB and rates are in
MiB/s.  Disk space values are for a specified pool and the rates are for a
specified device.

In addition to the lisp code, there is a small Bourne shell script, ml_zfs.sh.
Make sure this script is executable by the user running StumpWM and within the
user's $PATH.  You need to customize the disk and pool variables at the top to
reflect your setup.  You may also want to customize certain settings, such as
the interval between updates.

FAQ

Q: What do I need to put in my ~/.stumpwmrc to get this working?

A: First, make sure the source is in your load-path.  To add it, use something
like
```lisp
    (add-to-load-path "/usr/home/jrm/scm/swm-freebsd-zfs-modeline")
```
Next, load the module with
```lisp
    (load-module "swm-freebsd-zfs-modeline")
```

Finally create a mode-line format string with any of in it, %P, %O, %T, %F, %p,
%R, or %W, e.g.,
```lisp
    (setf *screen-mode-line-format* "^[^8*%P^] %O/%T^[^9*GiB^] %F^[^9*GiB^] %p^[^9*%%^] %R^[^9*MiB/s^] %W^[^9*MiB/s^]")
```

Q: So, why use a separate script?  Couldn't all the code be contained within the
module?

A: Yes, it could.  I tried doing that with and without threads.  I found StumpWM
became less responsive in both cases.  Don't you prefer a snappy StumpWM?

Q: Will this only run on FreeBSD?

A: By default, yes, but it should be quite simple to modify ml_zfs.sh to get it
working on your OS.