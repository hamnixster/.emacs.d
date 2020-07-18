(with-eval-after-load 'magit
  (add-hook 'magit-popup-mode-hook
            (lambda () (setq show-trailing-whitespace nil))))

(setq evil-magit-state 'normal)
(require 'evil-magit)

(provide 'grm-misc-magit)
