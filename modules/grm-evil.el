(setq evil-want-keybinding nil
      evil-want-integration t)
(require 'evil)

(evil-mode +1)
(setcdr evil-insert-state-map nil)

(setq evil-visual-state-cursor 'hbar
      evil-emacs-state-cursor 'bar)

(dolist (mode '(dired-mode calendar-mode image-mode))
  (evil-set-initial-state mode 'emacs))

(autoload 'evil-execute-in-grm-leader-state "grm-leader-mode" nil t)

(with-eval-after-load 'grm-leader-mode
  (define-key evil-grm-leader-state-map [escape] 'evil-grm-leader-state-bail)
  (setq evil-grm-leader-state-tag
        (format " %s " (propertize "<G>"))))

(autoload 'evil-grm-leader-state-p "grm-leader-mode")
(defun evil-visual-activate-hook (&optional command)
  "Enable Visual state if the region is activated."
  (unless (evil-visual-state-p)
    (evil-delay nil
        '(unless (or (evil-visual-state-p)
                     (evil-insert-state-p)
                     (evil-emacs-state-p)
                     (evil-grm-leader-state-p))
           (when (and (region-active-p)
                      (not deactivate-mark))
             (evil-visual-state)))
      'post-command-hook nil t
      "evil-activate-visual-state")))

(defun grm-emacs-state-grm-leader-mode-cursor ()
  (make-local-variable 'evil-emacs-state-cursor)
  (setq evil-emacs-state-cursor 'hollow))
(defun grm-emacs-state-restore-cursor ()
  (setq evil-emacs-state-cursor 'bar))
(with-eval-after-load 'grm-leader-mode
  (add-hook 'grm-leader-mode-enabled-hook #'grm-emacs-state-grm-leader-mode-cursor)
  (add-hook 'grm-leader-mode-disabled-hook #'grm-emacs-state-restore-cursor))

(defun minibuffer-keyboard-quit ()
  "Abort recursive edit.
In Delete Selection mode, if the mark is active, just deactivate it;
then it takes a second \\[keyboard-quit] to abort the minibuffer."
  (interactive)
  (if (and delete-selection-mode transient-mark-mode mark-active)
      (setq deactivate-mark  t)
    (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
    (abort-recursive-edit)))

(require 'evil-nerd-commenter)

(provide 'grm-evil)
