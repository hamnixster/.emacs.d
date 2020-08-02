(projectile-mode)
(when (member 'helm grm-enabled-features-list)
  (helm-projectile-on)
  (defalias 'helm-ff-switch-to-eshell 'helm-ff-switch-to-shell)
  (when (member 'ft-leader grm-enabled-features-list)
    (ft-leader-define-keys
     ?f
     '(
       ("C-f" . grm-try-helm-projectile-find-file-dwim)
       ("C-p" . helm-projectile-switch-project)
       ("C-r" . grm-try-helm-projectile-recentf)
       ("C-s" . helm-projectile-ag)
       ))))

(provide 'grm-feature-projectile)
