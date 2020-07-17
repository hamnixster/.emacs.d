(defvar grm-before-init-time (current-time))
(defvar grm--init-time-alist nil
  "Alist containing init time information.")

(defmacro grm-timed (sexp name &optional module)
  (let ((module-name (or module "00default")))
    `(let ((start-time (current-time))
           (init-times (assoc
                        ,module-name
                        grm--init-time-alist)))
       ,sexp
       (let ((elapsed
              (float-time
               (time-subtract
                (current-time)
                start-time))))
         (if init-times
             (push (cons ,name elapsed) (cdr init-times))
           (push (cons ,module-name (list (cons ,name elapsed)))
                 grm--init-time-alist))))))

(defmacro grm-require (library &optional module-name)
  `(grm-timed (require ,library) ,(symbol-name (cadr library)) ,module-name))

(provide 'grm-startup-profile)
