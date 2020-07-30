(require 'grm-leader-mode)
(setq grm-leader-literal-key " "
      grm-leader-special-map '(?q ?w ?f ?g ?i)
      grm-leader-maps-alist
      (mapcar
       (lambda (char)
         (cons char (intern (format "C-c %c map" char))))
       grm-leader-special-map)
      grm-leader-special-command '(?o)
      grm-leader-special (append grm-leader-special-map grm-leader-special-command)
      grm-leader-mod-alist
      '((nil . "C-")
        ("SPC" . "")
        ("m" . "M-")
        ("," . "C-M-")
        ))

(grm-leader-mode)

(when (member 'which-key grm-enabled-features-list)
  (setq grm-leader-which-key t))

(grm-leader-setup-special-maps)

(when (member 'grm-mode grm-enabled-features-list)
  (grm-leader-bind-special-maps grm-mode-map))

(global-set-key (kbd "C-c o") 'move-end-of-line)

(provide 'grm-feature-grm-leader)
