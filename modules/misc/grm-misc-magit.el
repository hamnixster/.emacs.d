(with-eval-after-load 'magit
  (add-hook 'magit-popup-mode-hook
            (lambda () (setq show-trailing-whitespace nil))))

(setq evil-magit-state 'normal)
(require 'evil-magit)

(with-eval-after-load 'magit-mode
  (define-key transient-map        "q" 'transient-quit-one)
  (define-key transient-edit-map   "q" 'transient-quit-one)
  (define-key transient-sticky-map "q" 'transient-quit-seq))

(provide 'grm-misc-magit)
