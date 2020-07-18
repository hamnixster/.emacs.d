(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))

(require 'mmm-auto)
(setq mmm-global-mode 'auto)
(mmm-add-mode-ext-class 'html-erb-mode "\\.html\\.erb\\'" 'erb)
(add-to-list 'auto-mode-alist '("\\.html\\.erb\\'" . html-erb-mode))
(setq mmm-submode-decoration-level 0
      mmm-parse-when-idle t)
(require 'erblint)

(provide 'grm-html)
