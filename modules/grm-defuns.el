(defsubst grm-feature--make-func-name (feature)
  "Helper function to construct function name of `feature' module by FEATURE."
  (concat "grm-feature-" (symbol-name feature)))

(defmacro grm-feature--defun (feature &rest body)
  "Toplevel macro to define macro of `feature' module by FEATURE and BODY."
  (declare (indent 1))
  (let* ((func-name (grm-feature--make-func-name feature))
         (func-symbol (intern func-name))
         (func-inactive-p (intern (concat func-name "--inactive-p"))))
    `(progn
       (defvar ,func-inactive-p t)
       (defsubst ,func-symbol (&optional v)
         (when (or ,func-inactive-p v)
           (setq ,func-inactive-p nil)
           ,@body)))))

(defmacro grm-feature-config-inline (feature &rest args)
  "Macro for inline settings."
  (declare (indent 1))
  `(grm-feature--defun ,feature ,@args))

(defmacro grm-feature-config-infile (feature)
  "Macro for infile settings."
  (declare (indent 1))
  `(defun ,feature ()
     (require ',feature)))

(defun grm-enable-feature (feature-name)
  (let ((func-name (grm-feature--make-func-name feature-name)))
    (funcall (intern func-name))))

(defun grm-enable-features ()
  (let ((file-basenames
         (mapcar
          #'(lambda (x) (intern (file-name-base x)))
          (directory-files
           grm-features-dir t "^[^#]*.el$"))))
    (dolist (basename file-basenames)
      (eval `(grm-feature-config-infile ,basename))))

  (mapc 'grm-enable-feature grm-enabled-features-list))

(defun minibuffer-keyboard-quit ()
  "Abort recursive edit.
In Delete Selection mode, if the mark is active, just deactivate it;
then it takes a second \\[keyboard-quit] to abort the minibuffer."
  (interactive)
  (if (and delete-selection-mode transient-mark-mode mark-active)
      (setq deactivate-mark  t)
    (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
    (abort-recursive-edit)))

(defun grm-install-all-packages ()
  "Use this command to install all the packages.
It reads from package-selected-packages and
installs these packages one by one."
  (interactive)
  (package-refresh-contents)
  (dolist (pkg package-selected-packages)
    (package-installed-p pkg)
    (ignore-errors
      (package-install pkg))))

(defun grm-ensure-all-packages ()
  "Check if packages need to be installed and does so if necessary."
  (when (catch 'break
          (dolist (pkg package-selected-packages)
            (unless (package-installed-p pkg)
              (throw 'break t))))
    (grm-install-all-packages)))

(defun grm-random-choice (items)
  (let* ((size (length items))
         (index (random size)))
    (nth index items)))

(defun grm-save-buffer-and-directories ()
  (when buffer-file-name
    (let ((dir (file-name-directory buffer-file-name)))
      (when (not (file-exists-p dir))
        (make-directory dir t))
      (when (not (file-exists-p (buffer-file-name)))
        (save-buffer (buffer-file-name))))))

(provide 'grm-defuns)
