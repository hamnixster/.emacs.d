(global-company-mode +1)
(when (member 'company-quickhelp package-selected-packages)
  (company-quickhelp-mode +1))
(setq company-backends
      '((company-robe
         company-files
         company-keywords
         company-yasnippet
         company-elisp)))

(define-key company-active-map [escape] 'keyboard-quit)

(when (member 'grm-mode grm-enabled-features-list)
  (define-key grm-mode-map (kbd "C-c C-y") 'company-yasnippet))

(when (member 'key-chord grm-enabled-features-list)
  (grm-key-chord-define company-active-map "ei" 'company-complete))

(provide 'grm-feature-company)
