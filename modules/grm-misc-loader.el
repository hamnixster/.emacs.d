(defsubst grm-misc--make-func-name (feature)
  "Helper function to construct function name of `misc' module by FEATURE."
  (concat "grm-misc-" (symbol-name feature)))

(defmacro grm-misc--defun (feature &rest body)
  "Toplevel macro to define macro of `misc' module by FEATURE and BODY."
  (declare (indent 1))
  (let* ((func-name (grm-misc--make-func-name feature))
         (func-symbol (intern func-name))
         (func-inactive-p (intern (concat func-name "--inactive-p"))))
    `(progn
       (defvar ,func-inactive-p t)
       (defsubst ,func-symbol (&optional v)
         (when (or ,func-inactive-p v)
           (setq ,func-inactive-p nil)
           ,@body)))))

(defmacro grm-misc-config-inline (feature &rest args)
  "Macro for inline settings."
  (declare (indent 1))
  `(grm-misc--defun ,feature
     ,@args))

(defmacro grm-misc-config-infile (feature)
  "Macro for infile settings."
  (declare (indent 1))
  `(defun ,feature ()
     (require ',feature)))

(add-to-list 'load-path (concat grm-modules-dir "/misc"))
(let ((file-basenames
       (mapcar
        #'(lambda (x) (intern (file-name-base x)))
        (directory-files
         (concat grm-modules-dir "/misc") t "^[^#]*.el$"))))
  (dolist (basename file-basenames)
    (eval `(grm-misc-config-infile ,basename))))

(defun grm-misc-enable-setting (feature-name)
  (let ((func-name (grm-misc--make-func-name feature-name)))
    (grm-timed (funcall (intern func-name)) func-name "21grm-misc-details")))

(provide 'grm-misc-loader)
