(require 'cl-lib)

(defvar grm-leader-global-mode nil
  "Activate GLeader mode on all buffers?")

(defvar grm-leader-literal-sequence nil
  "Activated after space is pressed in a command sequence.")

(defvar grm-leader-special nil)

(grm-define-highest-priority-mode-function grm-leader-local-mode)
(defun grm-grm-leader-mode-enable-hook ()
  (grm-gain-highest-keys-priority-grm-leader-local-mode nil)
  (setq cursor-type 'hollow))
(add-hook 'grm-leader-mode-enabled-hook 'grm-grm-leader-mode-enable-hook)
(defun grm-grm-leader-mode-disable-hook ()
  (setq cursor-type 'bar))
(add-hook 'grm-leader-mode-disabled-hook 'grm-grm-leader-mode-disable-hook)

(defcustom grm-leader-literal-key
  " "
  "The key used for literal interpretation."
  :group 'grm-leader
  :type 'string)

(defun grm-leader-key-string-after-consuming-key (key key-string-so-far)
  "Interpret grm-leader-mode special keys for key (consumes more keys if
appropriate). Append to keysequence."
  (let ((key-consumed t) next-modifier next-key)
    (message key-string-so-far)
    (setq next-modifier
          (cond
           ((string= key grm-leader-literal-key)
            (setq grm-leader-literal-sequence t)
            "")
           (grm-leader-literal-sequence
            (setq key-consumed nil)
            "")
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
              (grm-leader-mode-sanitized-key-string (read-event key-string-so-far))
            key))
    (if key-string-so-far
        (concat key-string-so-far " " next-modifier next-key)
      (concat next-modifier next-key))))

(defun grm-leader-mode-lookup-command (key-string)
  "Execute extended keymaps such as C-c, or if it is a command,
call it."
  (let* ((key-vector (read-kbd-macro key-string t))
         (binding (key-binding key-vector)))
    (cond ((commandp binding)
           (setq last-command-event (aref key-vector (- (length key-vector) 1)))
           binding)
          ((keymapp binding)
           (grm-leader-mode-lookup-key-sequence nil key-string))
          (:else
           (error "GLeader: Unknown key binding for `%s`" key-string)))))

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
    (t (char-to-string key))))

(defun grm-leader-mode-upper-p (char)
  "Is the given char upper case?"
  (and (>= char ?A)
       (<= char ?Z)
       (/= char ?G)))

(defun grm-leader-mode-lookup-key-sequence (&optional key key-string-so-far)
  (interactive)
  (let ((sanitized-key
         (if key-string-so-far (char-to-string (or key (read-event key-string-so-far)))
           (grm-leader-mode-sanitized-key-string (or key (read-event key-string-so-far))))))
    (grm-leader-mode-lookup-command
     (if (and key (member key grm-leader-special) (null key-string-so-far))
         (progn
           (setq grm-leader-literal-sequence t)
           (format "C-c %c" key))
       (grm-leader-key-string-after-consuming-key sanitized-key key-string-so-far)))))

(defun grm-leader-mode-self-insert ()
  "Handle self-insert keys."
  (interactive)
  (let* ((initial-key (aref (this-command-keys-vector)
                            (- (length (this-command-keys-vector)) 1)))
         (binding (grm-leader-mode-lookup-key-sequence initial-key)))
    (when (grm-leader-mode-upper-p initial-key)
      (setq this-command-keys-shift-translated t))
    (setq this-original-command binding)
    (setq this-command binding)
    ;; `real-this-command' is used by emacs to populate
    ;; `last-repeatable-command', which is used by `repeat'.
    (setq real-this-command binding)
    (setq grm-leader-literal-sequence nil)
    (if (commandp binding t)
        (call-interactively binding)
      (execute-kbd-macro binding))))

(defvar grm-leader-local-mode-map
  (let ((map (make-sparse-keymap)))
    (suppress-keymap map t)
    (define-key map [remap self-insert-command] 'grm-leader-mode-self-insert)
    (let ((i ?\s))
      (while (< i 256)
        (define-key map (vector i) 'grm-leader-mode-self-insert)
        (setq i (1+ i)))
      (define-key map (kbd "DEL") nil))
    map))

(define-minor-mode grm-leader-local-mode
  "Minor mode for running commands."
  nil " GLeader" grm-leader-local-mode-map
  (if grm-leader-local-mode
      (run-hooks 'grm-leader-mode-enabled-hook)
    (run-hooks 'grm-leader-mode-disabled-hook)))

(add-hook 'after-change-major-mode-hook 'grm-leader-mode-maybe-activate)

(defun grm-leader-mode-maybe-activate (&optional status)
  "Activate GLeader mode locally on individual buffers when appropriate."
  (when (not (minibufferp))
    (grm-leader-mode-activate status)))

(defcustom grm-leader-exempt-major-modes
  '(dired-mode
    grep-mode
    vc-annotate-mode
    magit-popup-mode)
  "List of major modes that should not start in grm-leader-local-mode."
  :group 'grm-leader
  :type '(function))

(defun grm-leader-exempt-mode-p ()
  "Return non-nil if major-mode is exempt.
Members of the `grm-leader-exempt-major-modes' list are exempt."
  (memq major-mode grm-leader-exempt-major-modes))

(defun grm-leader-comint-mode-p ()
  "Return non-nil if major-mode is child of comint-mode."
  (grm-leader-mode-child-of-p major-mode 'comint-mode))

(defun grm-leader-git-commit-mode-p ()
  "Return non-nil if a `git-commit-mode' will be enabled in this buffer."
  (and (bound-and-true-p global-git-commit-mode)
       ;; `git-commit-filename-regexp' defined in the same library as
       ;; `global-git-commit-mode'.  Expression above maybe evaluated
       ;; to true because of autoload cookie.  So we perform
       ;; additional check.
       (boundp 'git-commit-filename-regexp)
       buffer-file-name
       (string-match-p git-commit-filename-regexp buffer-file-name)))

(defun grm-leader-view-mode-p ()
  "Return non-nil if view-mode is enabled in current buffer."
  view-mode)

(defun grm-leader-special-mode-p ()
  "Return non-nil if major-mode is child of special-mode."
  (grm-leader-mode-child-of-p major-mode 'special-mode))

(defcustom grm-leader-exempt-predicates
  (list #'grm-leader-exempt-mode-p
        #'grm-leader-comint-mode-p
        #'grm-leader-git-commit-mode-p
        #'grm-leader-view-mode-p
        #'grm-leader-special-mode-p)
  "List of predicates checked before enabling grm-leader-local-mode.
All predicates must return nil for grm-leader-local-mode to start."
  :group 'grm-leader
  :type '(repeat function))

(defun grm-leader-passes-predicates-p ()
  "Return non-nil if all `grm-leader-exempt-predicates' return nil."
  (not
   (catch 'disable
     (let ((preds grm-leader-exempt-predicates))
       (while preds
         (when (funcall (car preds))
           (throw 'disable t))
         (setq preds (cdr preds)))))))

(defun grm-leader-mode-activate (&optional status)
  "Activate GLeader mode locally on individual buffers when appropriate."
  (when (and grm-leader-global-mode
             (grm-leader-passes-predicates-p))
    (grm-leader-local-mode (if status status 1))))

(defvar which-key--grm-leader-mode-key-string nil)
(defvar which-key--grm-leader-mode-support-enabled t)

(defadvice grm-leader-mode-lookup-command
    (around which-key--grm-leader-mode-lookup-command-advice disable)
  (setq which-key--grm-leader-mode-key-string (ad-get-arg 0))
  (unwind-protect
      ad-do-it
    (when (bound-and-true-p which-key-mode)
      (which-key--hide-popup))))

(with-eval-after-load 'which-key
  (defun which-key--grm-leader-this-command-keys ()
    "Version of `this-single-command-keys' corrected for key-chords and god-mode."
    (let ((this-command-keys (this-single-command-keys)))
      (when (and (equal this-command-keys [key-chord])
                 (bound-and-true-p key-chord-mode))
        (setq this-command-keys
              (condition-case nil
                  (let ((rkeys (recent-keys)))
                    (vector 'key-chord
                            ;; Take the two preceding the last one, because the
                            ;; read-event call in key-chord seems to add a
                            ;; spurious key press to this list. Note this is
                            ;; different from guide-key's method which didn't work
                            ;; for me.
                            (aref rkeys (- (length rkeys) 3))
                            (aref rkeys (- (length rkeys) 2))))
                (error (progn
                         (message "which-key error in key-chord handling")
                         [key-chord])))))
      (when (and which-key--grm-leader-mode-support-enabled
                 (bound-and-true-p grm-leader-local-mode)
                 (eq this-command 'grm-leader-mode-self-insert))
        (setq this-command-keys (when which-key--grm-leader-mode-key-string
                                  (kbd which-key--grm-leader-mode-key-string))))
      this-command-keys))
  (defun which-key--update ()
    "Function run by timer to possibly trigger
`which-key--create-buffer-and-show'."
    (let ((prefix-keys (which-key--grm-leader-this-command-keys))
          delay-time)
      (cond ((and (> (length prefix-keys) 0)
                  (or (keymapp (key-binding prefix-keys))
                      ;; Some keymaps are stored here like iso-transl-ctl-x-8-map
                      (keymapp (which-key--safe-lookup-key
                                key-translation-map prefix-keys))
                      ;; just in case someone uses one of these
                      (keymapp (which-key--safe-lookup-key
                                function-key-map prefix-keys)))
                  (not which-key-inhibit)
                  (or (null which-key-allow-regexps)
                      (which-key--any-match-p
                       which-key-allow-regexps (key-description prefix-keys)))
                  (or (null which-key-inhibit-regexps)
                      (not
                       (which-key--any-match-p
                        which-key-inhibit-regexps (key-description prefix-keys))))
                  ;; Do not display the popup if a command is currently being
                  ;; executed
                  (or (and which-key-allow-evil-operators
                           (bound-and-true-p evil-this-operator))
                      (and which-key--grm-leader-mode-support-enabled
                           (bound-and-true-p grm-leader-local-mode)
                           (eq this-command 'grm-leader-mode-self-insert))
                      (null this-command)))
             (when (and (not (equal prefix-keys (which-key--current-prefix)))
                        (or (null which-key-delay-functions)
                            (null (setq delay-time
                                        (run-hook-with-args-until-success
                                         'which-key-delay-functions
                                         (key-description prefix-keys)
                                         (length prefix-keys))))
                            (sit-for delay-time)))
               (setq which-key--automatic-display t)
               (which-key--create-buffer-and-show prefix-keys)
               (when (and which-key-idle-secondary-delay
                          (not which-key--secondary-timer-active))
                 (which-key--start-timer which-key-idle-secondary-delay t))))
            ((and which-key-show-transient-maps
                  (keymapp overriding-terminal-local-map)
                  ;; basic test for it being a hydra
                  (not (eq (lookup-key overriding-terminal-local-map "\C-u")
                           'hydra--universal-argument)))
             (which-key--create-buffer-and-show
              nil overriding-terminal-local-map))
            ((and which-key-show-operator-state-maps
                  (bound-and-true-p evil-state)
                  (eq evil-state 'operator)
                  (not (which-key--popup-showing-p)))
             (which-key--show-evil-operator-keymap))
            (which-key--automatic-display
             (which-key--hide-popup)))))
  (ad-enable-advice
   'grm-leader-mode-lookup-command
   'around 'which-key--grm-leader-mode-lookup-command-advice)
  (ad-activate 'grm-leader-mode-lookup-command))

;; evil integration

(evil-define-state grm-leader
  "Grm-leader state."
  :tag " <G> "
  :message "-- GRM-LEADER MODE --"
  :entry-hook (evil-grm-leader-start-hook)
  :exit-hook (evil-grm-leader-stop-hook)
  :input-method t
  :intercept-esc nil)

(defun evil-grm-leader-start-hook ()
  "Run before entering `evil-grm-leader-state'."
  (grm-leader-local-mode 1)
  (evil-visual-contract-region))

(defun evil-grm-leader-stop-hook ()
  "Run before exiting `evil-grm-leader-state'."
  (grm-leader-local-mode -1))

(defvar evil-execute-in-grm-leader-state-buffer nil)

(defvar evil-grm-leader-last-command nil)

(defun evil-grm-leader-fix-last-command ()
  "Change `last-command' to be the command before `evil-execute-in-grm-leader-state'."
  (setq last-command evil-grm-leader-last-command)
  (setq last-repeatable-command last-command))

(defun evil-execute-in-grm-leader-state ()
  "Execute the next command in grm-leader state."
  (interactive)
  (add-hook 'pre-command-hook #'evil-grm-leader-fix-last-command t)
  (add-hook 'post-command-hook #'evil-stop-execute-in-grm-leader-state t)
  (setq evil-execute-in-grm-leader-state-buffer (current-buffer))
  (setq evil-grm-leader-last-command last-command)
  (cond
   ((evil-visual-state-p)
    (let ((mrk (mark))
          (pnt (point)))
      (evil-grm-leader-state)
      (set-mark mrk)
      (goto-char pnt)))
   (t
    (evil-grm-leader-state)))
  (evil-echo "Switched to grm-leader state for the next command ..."))

(defun evil-stop-execute-in-grm-leader-state ()
  "Switch back to previous evil state."
  (unless (or (eq this-command #'evil-execute-in-grm-leader-state)
              (eq this-command #'universal-argument)
              (eq this-command #'universal-argument-minus)
              (eq this-command #'universal-argument-more)
              (eq this-command #'universal-argument-other-key)
              (eq this-command #'digit-argument)
              (eq this-command #'negative-argument)
              (minibufferp))
    (remove-hook 'pre-command-hook 'evil-grm-leader-fix-last-command)
    (remove-hook 'post-command-hook 'evil-stop-execute-in-grm-leader-state)
    (when (buffer-live-p evil-execute-in-grm-leader-state-buffer)
      (with-current-buffer evil-execute-in-grm-leader-state-buffer
        (if (and (eq evil-previous-state 'visual)
                 (not (use-region-p)))
            (progn
              (evil-change-to-previous-state)
              (evil-exit-visual-state))
          ;; grm: fix wierd back-to-visual-state cursor behavior
          (when (and (use-region-p) (= (point) (region-end)))
            (backward-char))
          (evil-change-to-previous-state))))
    (setq evil-execute-in-grm-leader-state-buffer nil)))

;;; Unconditionally exit Evil-grm-leader state.
(defun evil-grm-leader-state-bail ()
  "Stop current grm-leader command and exit grm-leader state."
  (interactive)
  (evil-stop-execute-in-grm-leader-state)
  (evil-grm-leader-stop-hook)
  (evil-normal-state))

;;;###autoload
(defun grm-leader-mode ()
  "Toggle global GLeader mode."
  (interactive)
  (setq grm-leader-global-mode (not grm-leader-global-mode))
  (if grm-leader-global-mode
      (grm-leader-local-mode 1)
    (grm-leader-local-mode -1)))

(defun grm-leader-mode-all ()
  "Toggle GLeader mode in all buffers."
  (interactive)
  (let ((new-status (if (bound-and-true-p grm-leader-local-mode) -1 1)))
    (setq grm-leader-global-mode t)
    (mapc (lambda (buffer)
            (with-current-buffer buffer
              (grm-leader-mode-activate new-status)))
          (buffer-list))
    (setq grm-leader-global-mode (= new-status 1))))

(defadvice save&set-overriding-map
    (before grm-leader-mode-add-to-universal-argument-map (map) activate compile)
  "This is used to set special keybindings after C-u is
pressed. When grm-leader-mode is active, intercept the call to add in
our own keybindings."
  (if (and grm-leader-local-mode (equal universal-argument-map map))
      (setq map grm-leader-mode-universal-argument-map)))

(grm-define-highest-priority-mode-function grm-leader-local-mode)
(defun grm-grm-leader-mode-enable-hook ()
  (grm-gain-highest-keys-priority-grm-leader-local-mode nil)
  (setq cursor-type 'hollow))
(add-hook 'grm-leader-mode-enabled-hook 'grm-grm-leader-mode-enable-hook)
(defun grm-grm-leader-mode-disable-hook ()
  (setq cursor-type 'bar))
(add-hook 'grm-leader-mode-disabled-hook 'grm-grm-leader-mode-disable-hook)

(provide 'grm-leader-mode)
