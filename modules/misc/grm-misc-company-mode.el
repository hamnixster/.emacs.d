(global-company-mode +1)
(company-quickhelp-mode +1)
(setq company-backends
      '((company-robe
         company-files
         company-keywords
         company-yasnippet
         company-elisp)))

(provide 'grm-misc-company-mode)
