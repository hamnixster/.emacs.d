(require 'grm-leader-mode)
(setq
 grm-leader-no-modifier-top-level-command 'helm-M-x
 grm-leader-special-map '(?q ?w ?f ?g ?i)
 grm-leader-special-command '(?o)
 grm-leader-mod-alist
 '((nil . "C-")
   ("SPC" . "")
   ("m" . "M-")
   ("," . "C-M-")
   ))

(grm-leader-mode)
(grm-leader-setup-special-maps)

(if (member 'grm-mode grm-enabled-features-list)
    (progn
      (define-key grm-mode-map (kbd "C-c o") 'move-end-of-line)
      (grm-leader-bind-special-maps grm-mode-map))
  (progn
    (global-set-key (kbd "C-c o") 'move-end-of-line)
    (grm-leader-bind-special-maps)))

(when (member 'which-key grm-enabled-features-list)
  (setq grm-leader-which-key t))

(define-key grm-leader-local-mode-map [escape] 'grm-leader-mode-deactivate)

(provide 'grm-feature-grm-leader)
