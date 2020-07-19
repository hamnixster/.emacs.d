(add-to-list 'load-path (concat grm-modules-dir "/programming"))

(grm-require 'grm-flycheck)
(grm-require 'grm-ruby)
(grm-require 'grm-rails)
(grm-require 'grm-html)

(add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)

(setq highlight-symbol-idle-delay 0.1)
(add-hook 'emacs-lisp-mode-hook 'highlight-symbol-mode)
(add-hook 'ruby-mode-hook 'highlight-symbol-mode)

(provide 'grm-programming)
