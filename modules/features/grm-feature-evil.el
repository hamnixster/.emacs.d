(setq evil-want-keybinding nil
      evil-want-integration t
      evil-visual-state-cursor 'hbar
      evil-emacs-state-cursor 'bar)

(require 'evil)
(evil-mode +1)
(dolist (mode grm-start-in-emacs-modes)
  (evil-set-initial-state mode 'emacs))

(when (member 'grm-leader grm-enabled-features-list)
  (add-hook 'evil-local-mode-hook #'grm-leader-ensure-priority-bindings)
  (define-key evil-normal-state-map (kbd "SPC") 'grm-leader-mode-exec)
  (define-key evil-visual-state-map (kbd "SPC") 'grm-leader-mode-exec)
  (define-key evil-motion-state-map (kbd "SPC") 'grm-leader-mode-exec)
  (grm-leader-define-keys
   ?w
   '(
     ("C-a" . balance-windows)
     ("C-s" . evil-window-split)
     ("C-r" . evil-window-vsplit)
     ("C-q" . evil-quit)
     ("C-n" . evil-window-left)
     ("C-e" . evil-window-down)
     ("C-i" . evil-window-up)
     ("C-o" . evil-window-right)
     ("n" . evil-window-move-far-left)
     ("e" . evil-window-move-very-bottom)
     ("i" . evil-window-move-very-top)
     ("o" . evil-window-move-far-right)
     )))

(when (member 'evil-nerd-commenter package-selected-packages)
  (require 'evil-nerd-commenter)
  (define-key evil-normal-state-map "gc" 'evilnc-comment-operator))

(define-key evil-insert-state-map (kbd "<escape>") 'evil-normal-state)
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
(global-set-key [escape]          'evil-exit-emacs-state)

(when (member 'grm-mode grm-enabled-features-list)
  (define-key grm-mode-map [escape] 'minibuffer-keyboard-quit))

(provide 'grm-feature-evil)
