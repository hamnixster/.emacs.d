(require 'which-key)
(setq which-key-idle-delay 0.1
      which-key-special-keys nil)
(autoload 'which-key--show-keymap "which-key")
(which-key-mode +1)

(provide 'grm-feature-which-key)
