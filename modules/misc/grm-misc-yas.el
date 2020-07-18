(require 'yasnippet)
(setq yas-snippet-dirs
      '("~/.emacs.d/snippets"))
(yas-global-mode 1)

(require 'warnings)
(add-to-list 'warning-suppress-types '(yasnippet backquote-change))

(provide 'grm-misc-yas)
