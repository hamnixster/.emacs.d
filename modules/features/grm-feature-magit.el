(when (member 'evil-magit package-selected-packages)
  (setq evil-magit-state 'normal)
  (require 'evil-magit)
  (with-eval-after-load 'magit-mode
    (define-key transient-map        [escape] 'transient-quit-one)
    (define-key transient-edit-map   [escape] 'transient-quit-one)
    (define-key transient-sticky-map [escape] 'transient-quit-seq)))

(with-eval-after-load 'magit-mode
  (define-key transient-map        "q" 'transient-quit-one)
  (define-key transient-edit-map   "q" 'transient-quit-one)
  (define-key transient-sticky-map "q" 'transient-quit-seq))

(when (member 'grm-leader grm-enabled-features-list)
  (with-eval-after-load 'magit-mode
    (define-key magit-mode-map (kbd "SPC") 'grm-leader-mode-exec)))

(provide 'grm-feature-magit)