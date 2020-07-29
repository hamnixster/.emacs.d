(grm-feature-config-inline
 no-littering
 (require 'no-littering))

(grm-feature-config-inline
 grm-mode
 (require 'grm-mode)
 (global-grm-mode +1))

(grm-feature-config-inline
 evil-nerd-commenter
 (require 'evil-nerd-commenter))

(grm-feature-config-inline
 projectile
 (projectile-mode)
 (when (member 'helm grm-enabled-features-list)
   (helm-projectile-on)
   (defalias 'helm-ff-switch-to-eshell 'helm-ff-switch-to-shell)))

(provide 'grm-inline-features)
