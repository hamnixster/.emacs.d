(grm-feature-config-inline no-littering
  (require 'no-littering))

(grm-feature-config-inline smart-mode-line
  (setq sml/theme 'respectful)
  (sml/setup))

(grm-feature-config-inline grm-mode
  (require 'grm-mode)
  (global-grm-mode +1))

(grm-feature-config-inline undo-tree
  (setq undo-tree-history-directory-alist
        `((".*" . ,temporary-file-directory))
        undo-tree-auto-save-history t)
  (global-undo-tree-mode))

(grm-feature-config-inline dimmer
  (require 'dimmer)
  (dimmer-configure-which-key)
  (dimmer-configure-helm)
  (dimmer-configure-magit)
  (dimmer-configure-hydra)
  (dimmer-configure-gnus)
  (dimmer-mode t))

(grm-feature-config-inline diff-hl
  (global-diff-hl-mode +1)
  (setq diff-hl-side 'left)
  (add-hook 'dired-mode-hook 'diff-hl-dired-mode)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))

(grm-feature-config-inline indent-guide
  (setq indent-guide-delay 0.1)
  (indent-guide-global-mode))

(grm-feature-config-inline yas
  (require 'yasnippet)
  (setq yas-snippet-dirs '(grm-snippets-dir))
  (yas-global-mode 1))

(grm-feature-config-inline restart-emacs
  (defun grm-restart-emacs ()
    (interactive)
    (restart-emacs (list "-q" "--load" user-init-file)))
  (when (member 'ft-leader grm-enabled-features-list)
    (ft-leader-define-key ?q "C-r" 'grm-restart-emacs)))

(grm-feature-config-inline smartparens
  (require 'smartparens-config)
  (add-hook 'emacs-lisp-mode-hook #'smartparens-mode))

(grm-feature-config-inline whitespace-cleanup
  (global-whitespace-cleanup-mode))

(grm-feature-config-inline aggressive-indent
  (add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)
  (add-hook 'ruby-mode-hook #'aggressive-indent-mode))

(grm-feature-config-inline markdown
  (when (member 'ft-leader package-selected-packages)
    (add-hook 'markdown-mode-hook #'markdownfmt-enable-on-save)))

(grm-feature-config-inline highlight-symbol
  (setq highlight-symbol-idle-delay 0.1)
  (add-hook 'emacs-lisp-mode-hook 'highlight-symbol-mode)
  (add-hook 'ruby-mode-hook 'highlight-symbol-mode))

(grm-feature-config-inline flycheck
  (global-flycheck-mode))

(grm-feature-config-inline fira-code
  (add-hook 'prog-mode-hook 'fira-code-mode)
  (add-hook 'text-mode-hook 'fira-code-mode))

(grm-feature-config-inline avy
  (cond ((eq 'colemack grm-keyboard-layout)
         (setq avy-keys '(?a ?r ?s ?t ?n ?e ?i ?o)))
        ((eq 'qwerty grm-keyboard-layout)
         (setq avy-keys '(?a ?s ?d ?f ?h ?j ?k ?l))))
  (define-key grm-mode-map (kbd "C-c :") 'avy-goto-char))

(provide 'grm-inline-features)
