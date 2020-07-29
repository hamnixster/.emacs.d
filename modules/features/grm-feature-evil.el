(setq evil-want-keybinding nil
      evil-want-integration t
      evil-visual-state-cursor 'hbar
      evil-emacs-state-cursor 'bar)

(require 'evil)
(evil-mode +1)
(dolist (mode grm-start-in-emacs-modes)
  (evil-set-initial-state mode 'emacs))

(define-key evil-normal-state-map (kbd "SPC") 'grm-leader-mode-exec)
(define-key evil-visual-state-map (kbd "SPC") 'grm-leader-mode-exec)
(define-key evil-motion-state-map (kbd "SPC") 'grm-leader-mode-exec)

(provide 'grm-feature-evil)
