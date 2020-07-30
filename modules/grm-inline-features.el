(grm-feature-config-inline
 no-littering
 (require 'no-littering))

(grm-feature-config-inline
 smart-mode-line
 (setq sml/theme 'respectful)
 (sml/setup))

(grm-feature-config-inline
 grm-mode
 (require 'grm-mode)
 (global-grm-mode +1))

(grm-feature-config-inline
 undo-tree
 (setq undo-tree-history-directory-alist
       `((".*" . ,temporary-file-directory))
       undo-tree-auto-save-history t)
 (global-undo-tree-mode))

(grm-feature-config-inline
 dimmer
 (require 'dimmer)
 (dimmer-configure-which-key)
 (dimmer-configure-helm)
 (dimmer-configure-magit)
 (dimmer-configure-hydra)
 (dimmer-configure-gnus)
 (dimmer-mode t))

(grm-feature-config-inline
 diff-hl
 (global-diff-hl-mode +1)
 (setq diff-hl-side 'left)
 (add-hook 'dired-mode-hook 'diff-hl-dired-mode)
 (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))

(grm-feature-config-inline
 indent-guide
 (setq indent-guide-delay 0.1)
 (indent-guide-global-mode))

(grm-feature-config-inline
 yas
 (require 'yasnippet)
 (setq yas-snippet-dirs '(grm-snippets-dir))
 (yas-global-mode 1))

(grm-feature-config-inline
 restart-emacs
 (defun grm-restart-emacs ()
   (interactive)
   (restart-emacs (list "-q" "--load" user-init-file)))
 (when (member 'grm-leader-mode grm-enabled-features-list)
   (grm-leader-define-key ?q "C-r" 'grm-restart-emacs)))

(provide 'grm-inline-features)
