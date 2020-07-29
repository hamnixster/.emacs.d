(require 'grm-leader-mode)
(setq grm-leader-literal-key " "
      grm-leader-special '(?i)
      grm-leader-mod-alist
      '((nil . "C-")
        (" " . "")
        ("m" . "M-")
        ("," . "C-M-")
        ))

(grm-leader-mode)

(when (member 'which-key grm-enabled-features-list)
  (setq grm-leader-which-key t))

(provide 'grm-feature-grm-leader)
