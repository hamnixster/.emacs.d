(require 'ft-leader-mode)
(setq
 ft-leader-no-modifier-top-level-command 'helm-M-x
 ft-leader-special-map '(?q ?w ?f ?g ?i)
 ft-leader-special-command '(?o ?:)
 ft-leader-mod-alist
 '((nil . "C-")
   ("SPC" . "")
   ("m" . "M-")
   ("," . "C-M-")
   ))

(ft-leader-mode)
(ft-leader-setup-special-maps)

(if (member 'grm-mode grm-enabled-features-list)
    (progn
      (define-key grm-mode-map (kbd "C-c o") 'move-end-of-line)
      (ft-leader-bind-special-maps grm-mode-map))
  (progn
    (global-set-key (kbd "C-c o") 'move-end-of-line)
    (ft-leader-bind-special-maps)))

(when (member 'which-key grm-enabled-features-list)
  (setq ft-leader-which-key t))

(define-key ft-leader-local-mode-map [escape] 'ft-leader-mode-deactivate)

(provide 'grm-feature-ft-leader)
