(global-company-mode +1)
(when (member 'company-quickhelp package-selected-packages)
  (company-quickhelp-mode +1))
(setq company-backends
      '((company-robe
         company-files
         company-keywords
         company-yasnippet
         company-elisp)))

(provide 'grm-feature-company)
