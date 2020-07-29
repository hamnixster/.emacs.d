(setq-default fill-column 120
              indent-tabs-mode nil
              imenu-auto-rescan t)
(setq backup-directory-alistq `((".*" . ,temporary-file-directory))
      exec-path
      (split-string
       (shell-command-to-string (format "%s -c 'echo -n $PATH'" (getenv "SHELL")))
       ":")
      mouse-yank-at-point t
      recentf-save-file (expand-file-name "recentf" grm-base-dir)
      recentf-max-menu-items 25
      recentf-max-saved-items 25
      require-final-newline t
      sentence-end-double-space nil
      tramp-backup-directory-alist backup-directory-alist
      uniquify-buffer-name-style 'forward
      uniquify-ignore-buffers-re "^\\*"
      auto-save-file-name-transforms `((".*" ,temporary-file-directory t))
      initial-major-mode 'org-mode
      initial-scratch-message
      (format "* %s\n  %s\n"
              (format-time-string "%Y-%m-%d")
              (grm-random-choice grm-startup-quotes)))

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

(with-eval-after-load 'recentf
  (add-to-list 'recentf-exclude "COMMIT_EDITMSG\\'")
  (add-to-list 'recentf-exclude no-littering-var-directory)
  (add-to-list 'recentf-exclude no-littering-etc-directory))

(add-hook 'text-mode-hook 'turn-on-auto-fill)
(fset 'yes-or-no-p 'y-or-n-p)

(recentf-mode 1)
(minibuffer-depth-indicate-mode +1)
(save-place-mode +1)
(savehist-mode +1)
(winner-mode +1)

;; Prevent GC during minibuffer operations - Taken from DOOM
(defun grm-defer-garbage-collection-h ()
  (setq gc-cons-threshold most-positive-fixnum))
(defun grm-restore-garbage-collection-h ()
  ;; Defer it so that commands launched immediately after will enjoy the
  ;; benefits.
  (run-at-time
   1 nil (lambda () (setq gc-cons-threshold 16777216))))
(add-hook 'minibuffer-setup-hook #'grm-defer-garbage-collection-h)
(add-hook 'minibuffer-exit-hook #'grm-restore-garbage-collection-h)

(when (member 'yas grm-enabled-features-list)
  (require 'warnings)
  (add-to-list 'warning-suppress-types '(yasnippet backquote-change)))

(global-set-key (kbd "C-x C-z") nil) ;; disable suspend frame

(funcall initial-major-mode)

(provide 'grm-feature-emacs)
