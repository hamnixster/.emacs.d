(require 'cl-lib)
(require 's)

(defcustom grm-leader-literal-key
  " "
  "The key used for literal interpretation."
  :group 'grm-leader
  :type 'string)

(defcustom grm-leader-mod-alist
  '((nil . "C-")
    (" " . ""))
  "List of keys and their associated modifer."
  :group 'grm-leader
  :type '(alist))

(defcustom grm-leader-exempt-predicates
  '()
  "List of predicates checked before enabling grm-leader-local-mode.
All predicates must return nil for grm-leader-local-mode to start."
  :group 'grm-leader
  :type '(repeat function))

(defvar grm-leader-global-mode nil
  "Activate GLeader mode on all buffers?")

(defvar grm-leader-special nil)

(defvar grm-leader-which-key nil)
(defvar grm-leader-which-key-thread nil)
(defvar grm-leader-which-key-received nil)
(defvar grm-leader-which-key-map nil)
(defvar grm-leader-which-key-mod nil)
(defvar grm-current-bindings nil)
(defvar grm-special-bindings nil)
(defvar grm-last-key-string "")
(defvar grm-universal-arg nil)

(defvar grm-leader-local-mode-map
  (let ((map (make-sparse-keymap)))
    (suppress-keymap map t)
    (define-key map [remap self-insert-command] 'grm-leader-mode-self-insert)
    (dolist (i (number-sequence 32 255))
      (define-key map (vector i) 'grm-leader-mode-self-insert))
    (define-key map [escape] 'grm-leader-mode-deactivate)
    map))

(define-minor-mode grm-leader-local-mode
  "Minor mode for running commands."
  nil " GLeader" grm-leader-local-mode-map
  (if grm-leader-local-mode
      (run-hooks 'grm-leader-mode-enabled-hook)
    (run-hooks 'grm-leader-mode-disabled-hook)))

(defun grm-leader-ensure-priority-bindings ()
  (unless (and (listp (car emulation-mode-map-alists))
               (car (assoc 'grm-leader-local-mode (car emulation-mode-map-alists))))
    (cl-delete-if
     (lambda (alist)
       (and (listp alist)
            (car (assoc 'grm-leader-local-mode alist))))
     emulation-mode-map-alists)
    (add-to-list
     'emulation-mode-map-alists
     `((grm-leader-local-mode . ,grm-leader-local-mode-map)))))

(defun grm-leader-accept-input ()
  (when grm-leader-which-key
    (setq grm-current-bindings (which-key--get-current-bindings)
          grm-special-bindings
          (mapcar
           (lambda (sp)
             (cons sp (symbol-name (key-binding (read-kbd-macro (format "C-c %c" sp))))))
           grm-leader-special)))
  (grm-leader-ensure-priority-bindings)
  (when grm-leader-which-key
    (setq grm-leader-which-key-thread
          (make-thread 'grm-leader-which-key-top)))
  (setq grm-last-key-string
        (format
         "%s%s"
         (if grm-universal-arg
             (if (consp grm-universal-arg)
                 (apply 'concat (make-list (floor (/ (log (car grm-universal-arg)) (log 4))) "C-u "))
               (format "C-u %s " grm-universal-arg))
           "")
         (cdr (assoc nil grm-leader-mod-alist))))
  (message grm-last-key-string))

(add-hook 'grm-leader-mode-enabled-hook 'grm-leader-accept-input)

(defun grm-leader-mode-sanitized-key-string (key)
  "Convert any special events to textual."
  (cl-case key
    (tab "TAB")
    (?\  "SPC")
    (left "<left>")
    (right "<right>")
    (prior "<prior>")
    (next "<next>")
    (backspace "DEL")
    (return "RET")
    (escape "ESC")
    (?\^\[ "ESC")
    (t (char-to-string key))))

(defun grm-leader-key-string-after-consuming-key (key key-string-so-far)
  "Interpret grm-leader-mode special keys for KEY (consumes more keys if
appropriate). Append to keysequence."
  (let ((key-consumed t) next-modifier next-key)
    (setq next-modifier
          (cond
           ((and
             (stringp key)
             (not (eq nil (assoc key grm-leader-mod-alist)))
             (not (eq nil key)))
            (cdr (assoc key grm-leader-mod-alist)))
           (t
            (setq key-consumed nil)
            (cdr (assoc nil grm-leader-mod-alist))
            )))
    (setq next-key
          (if key-consumed
              (progn
                (setq grm-last-key-string
                      (format
                       "%s%s"
                       (if grm-universal-arg
                           (if (consp grm-universal-arg)
                               (apply 'concat (make-list (floor (/ (log (car grm-universal-arg)) (log 4))) "C-u "))
                             (format "C-u %s " grm-universal-arg))
                         "")
                       (format
                        "%s%s"
                        (if key-string-so-far (format "%s " key-string-so-far) "")
                        next-modifier)))
                (message grm-last-key-string)
                (when grm-leader-which-key
                  (setq grm-leader-which-key-map
                        (if key-string-so-far
                            (key-binding (read-kbd-macro key-string-so-far t))
                          nil))
                  (setq grm-leader-which-key-mod (cdr (assoc key grm-leader-mod-alist)))
                  (setq grm-leader-which-key-thread (make-thread 'grm-leader-which-key-with-map))
                  )
                (grm-leader-mode-sanitized-key-string (read-key key-string-so-far)))
            key))

    (when grm-leader-which-key
      (setq grm-leader-which-key-received t)
      (let ((which-key-inhibit t))
        (which-key--hide-popup-ignore-command)))

    (if key-string-so-far
        (concat key-string-so-far " " next-modifier next-key)
      (concat next-modifier next-key))))

(defun grm-leader-mode-lookup-command (key-string)
  "Execute extended keymaps such as C-c, or call command.
KEY-STRING is the command to lookup."
  (let* ((key-vector (read-kbd-macro key-string t))
         (binding (key-binding key-vector)))
    (cond ((commandp binding)
           (setq last-command-event (aref key-vector (- (length key-vector) 1)))
           (grm-leader-mode-deactivate)
           (setq grm-last-key-string
                 (format
                  "%s%s"
                  (if grm-universal-arg
                      (if (consp grm-universal-arg)
                          (apply 'concat (make-list (floor (/ (log (car grm-universal-arg)) (log 4))) "C-u "))
                        (format "C-u %s " grm-universal-arg))
                    "")
                  key-string))
           (message grm-last-key-string)
           binding)
          ((keymapp binding)
           (grm-leader-mode-lookup-key-sequence nil key-string))
          ((eq "" key-string)
           (message "Bailing from GLeader.")
           'grm-leader-mode-deactivate)
          (:else
           (grm-leader-mode-deactivate)
           (error "GLeader: Unknown key binding for `%s`" key-string)))))

(defun grm-leader-mode-lookup-key-sequence (&optional key key-string-so-far)
  (interactive)
  (when (and grm-leader-which-key (eq nil key))
    (setq grm-leader-which-key-map (key-binding (read-kbd-macro key-string-so-far t)))
    (setq grm-leader-which-key-mod (cdr (assoc nil grm-leader-mod-alist)))
    (setq grm-leader-which-key-thread (make-thread 'grm-leader-which-key-with-map))
    )

  (when (eq nil key)
    (setq grm-last-key-string
          (format
           "%s%s"
           (if grm-universal-arg
               (if (consp grm-universal-arg)
                   (apply 'concat (make-list (floor (/ (log (car grm-universal-arg)) (log 4))) "C-u "))
                 (format "C-u %s " grm-universal-arg))
             "")
           (format
            "%s%s"
            (if key-string-so-far (format "%s " key-string-so-far) "")
            (cdr (assoc nil grm-leader-mod-alist)))))
    (message grm-last-key-string))

  (let ((sanitized-key
         (if key-string-so-far (grm-leader-mode-sanitized-key-string (or key (read-key key-string-so-far)))
           (grm-leader-mode-sanitized-key-string (or key (read-key key-string-so-far))))))
    (when grm-leader-which-key
      (setq grm-leader-which-key-received t)
      (let ((which-key-inhibit t))
        (which-key--hide-popup-ignore-command)))
    (grm-leader-mode-lookup-command
     (cond ((and key (member key grm-leader-special) (null key-string-so-far))
            (format "C-c %c" key))
           ((and key (eq key (string-to-char grm-leader-literal-key)) (null key-string-so-far))
            "")
           (:else
            (grm-leader-key-string-after-consuming-key sanitized-key key-string-so-far))))))

(defun grm-leader-mode-upper-p (char)
  "Is the given CHAR upper case?"
  (and (>= char ?A) (<= char ?Z)))

(defun grm-leader-mode-self-insert ()
  "Handle self-insert keys."
  (interactive)
  (when grm-leader-which-key
    (setq grm-leader-which-key-received t)
    (let ((which-key-inhibit t))
      (which-key--hide-popup-ignore-command)))
  (let* ((command-vec (this-command-keys-vector))
         (initial-key (aref command-vec (- (length command-vec) 1)))
         (binding (grm-leader-mode-lookup-key-sequence initial-key)))
    (when (grm-leader-mode-upper-p initial-key)
      (setq this-command-keys-shift-translated t))
    (setq this-original-command binding)
    (setq this-command binding)
    ;; `real-this-command' is used by emacs to populate
    ;; `last-repeatable-command', which is used by `repeat'.
    (setq real-this-command binding)
    (if (commandp binding t)
        (let* ((current-prefix-arg grm-universal-arg)
               (binding
                (if (and (consp current-prefix-arg)
                         (eq binding 'universal-argument))
                    'universal-argument-more
                  binding)))
          (call-interactively binding))
      (execute-kbd-macro binding))))

(defun grm-leader-passes-predicates-p ()
  "Return non-nil if all `grm-leader-exempt-predicates' return nil."
  (not
   (catch 'disable
     (let ((preds grm-leader-exempt-predicates))
       (while preds
         (when (funcall (car preds))
           (throw 'disable t))
         (setq preds (cdr preds)))))))

(defun grm-leader-mode-deactivate ()
  "Deactivate GLeader mode locally."
  (interactive)
  (when grm-leader-which-key
    (setq grm-leader-which-key-received t)
    (let ((which-key-inhibit t))
      (which-key--hide-popup-ignore-command)))
  (grm-leader-local-mode -1))

(defun grm-leader-mode-exec (arg)
  (interactive "P")
  (setq grm-universal-arg arg)
  (when (and grm-leader-global-mode
             (grm-leader-passes-predicates-p))
    (grm-leader-local-mode 1)))

(defun grm-leader-mode ()
  "Toggle global GLeader mode."
  (interactive)
  (setq grm-leader-global-mode (not grm-leader-global-mode)))

(defun grm-leader-setup-special-maps ()
  (setq grm-leader-maps-alist
        (mapcar
         (lambda (char)
           (cons char (intern (format "C-c %c map" char))))
         grm-leader-special-map))
  (dolist (map-key grm-leader-maps-alist)
    (define-prefix-command (cdr map-key)))
  )

(defun grm-leader-bind-special-maps (host-map)
  (dolist (map-key grm-leader-maps-alist)
    (define-key host-map
      (kbd (format "C-c %c" (car map-key)))
      (cdr map-key))))

(defun grm-leader-define-key (map-char key-seq command)
  (define-key
    (cdr (assq map-char grm-leader-maps-alist))
    (kbd key-seq)
    command))

(defun grm-leader-define-keys (map-char key-command-alist)
  (dolist (key-command key-command-alist)
    (grm-leader-define-key map-char (car key-command) (cdr key-command))))

(defun grm-leader-which-key-with-map ()
  (let* ((map grm-leader-which-key-map)
         (mod grm-leader-which-key-mod)
         (matcher (format "^<?%s" mod))
         (non-matcher (format "%s.-" matcher)))
    (setq grm-leader-which-key-received nil)
    (sit-for which-key-idle-delay)
    (when (and grm-leader-local-mode
               (not grm-leader-which-key-received)
               (not (which-key--popup-showing-p)))
      (grm-which-key--create-buffer-and-show
       nil map
       (lambda (binding)
         (and (not (s-matches? non-matcher (car binding)))
              (s-matches? matcher (car binding)))
         )
       (lambda (unformatted)
         (dolist (key unformatted)
           (setcar key (replace-regexp-in-string mod "" (car key))))
         (when (string= mod (cdr (assoc nil grm-leader-mod-alist)))
           (setq unformatted
                 (cl-remove-if
                  (lambda (key)
                    (string=
                     (grm-leader-mode-sanitized-key-string (string-to-char grm-leader-literal-key))
                     (car key)))
                  unformatted))
           (setq unformatted
                 (cons
                  (cons
                   (grm-leader-mode-sanitized-key-string (string-to-char grm-leader-literal-key))
                   "no-modifier")
                  unformatted))
           (dolist (mod grm-leader-mod-alist)
             (when (not (or (eq nil (car mod)) (string= "" (cdr mod))))
               (progn
                 (setq unformatted
                       (cl-remove-if
                        (lambda (key) (string= (car mod) (car key)))
                        unformatted))
                 (setq unformatted (cons mod unformatted))))))
         unformatted
         )
       )
      ))
  (let (message-log-max)
    (message grm-last-key-string)))

(defun grm-leader-which-key-top ()
  (setq grm-leader-which-key-received nil)
  (sit-for which-key-idle-delay)
  (when (and grm-leader-local-mode
             (not grm-leader-which-key-received)
             (not (which-key--popup-showing-p)))
    (let* ((mod (cdr (assoc nil grm-leader-mod-alist)))
           (matcher (format "^<?%s" mod))
           (re-literal-matcher
            (format "%s%s"
                    matcher
                    (grm-leader-mode-sanitized-key-string (string-to-char grm-leader-literal-key))))
           (non-matcher (format "%s.-" matcher)))
      (grm-which-key--create-buffer-and-show
       nil nil
       (lambda (binding)
         (and (not (s-matches? non-matcher (car binding)))
              (not (s-matches? re-literal-matcher (car binding)))
              (s-matches? matcher (car binding))
              ))
       (lambda (unformatted)
         (dolist (key unformatted)
           (setcar key (replace-regexp-in-string mod "" (car key))))
         (setq unformatted
               (cl-acons (grm-leader-mode-sanitized-key-string (string-to-char grm-leader-literal-key))
                         "grm-leader-mode-deactivate"
                         unformatted))
         (dolist (mod grm-leader-mod-alist)
           (when (not (or (eq nil (car mod)) (string= "" (cdr mod))))
             (progn
               (setq unformatted
                     (cl-remove-if
                      (lambda (key) (string= (car mod) (car key)))
                      unformatted))
               (setq unformatted (cons mod unformatted)))))
         (dolist (sp grm-leader-special)
           (setq unformatted
                 (cl-remove-if
                  (lambda (key)
                    (string= (grm-leader-mode-sanitized-key-string sp) (car key)))
                  unformatted))
           (when (assq sp grm-special-bindings)
             (setq unformatted
                   (cl-acons
                    (grm-leader-mode-sanitized-key-string sp)
                    (cdr (assq sp grm-special-bindings))
                    unformatted))))
         unformatted))))
  (let (message-log-max)
    (message grm-last-key-string)))

(with-eval-after-load 'which-key
  (defun grm-which-key--create-buffer-and-show
      (&optional prefix-keys from-keymap filter preformat prefix-title)
    "Fill `which-key--buffer' with key descriptions and reformat.
Finally, show the buffer."
    (let ((start-time (current-time))
          (formatted-keys (grm-which-key--get-bindings
                           prefix-keys from-keymap filter preformat))
          (prefix-desc (key-description prefix-keys)))
      (cond ((= (length formatted-keys) 0)
             (setq grm-last-key-string
                   (format
                    "%s%s"
                    (if grm-universal-arg
                        (if (consp grm-universal-arg)
                            (apply 'concat (make-list (floor (/ (log (car grm-universal-arg)) (log 4))) "C-u "))
                          (format "C-u %s " grm-universal-arg))
                      "")
                    (format "%s which-key: There are no keys to show" grm-last-key-string)))
             )
            ((listp which-key-side-window-location)
             (setq which-key--last-try-2-loc
                   (apply #'which-key--try-2-side-windows
                          formatted-keys prefix-keys prefix-title
                          which-key-side-window-location)))
            (t (setq which-key--pages-obj
                     (which-key--create-pages
                      formatted-keys prefix-keys prefix-title))
               (which-key--show-page)))
      (which-key--debug-message
       "On prefix \"%s\" which-key took %.0f ms." prefix-desc
       (* 1000 (float-time (time-since start-time))))))

  (defun grm-which-key--get-bindings (&optional prefix keymap filter preformat recursive)
    "Collect key bindings.
If KEYMAP is nil, collect from current buffer using the current
key sequence as a prefix. Otherwise, collect from KEYMAP. FILTER
is a function to use to filter the bindings. If RECURSIVE is
non-nil, then bindings are collected recursively for all prefixes."
    (let* ((unformatted
            (cond ((keymapp keymap)
                   (which-key--get-keymap-bindings keymap recursive))
                  (keymap
                   (error "%s is not a keymap" keymap))
                  (grm-current-bindings grm-current-bindings)
                  (t
                   (which-key--get-current-bindings prefix)))))
      (when filter
        (setq unformatted (cl-remove-if-not filter unformatted)))
      (when preformat
        (setq unformatted (funcall preformat unformatted)))
      (when which-key-sort-order
        (setq unformatted
              (sort unformatted which-key-sort-order)))
      (which-key--format-and-replace unformatted prefix recursive)))
  )

(provide 'grm-leader-mode)
