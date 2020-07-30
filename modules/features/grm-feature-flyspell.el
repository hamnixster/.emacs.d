(require 'flyspell)

(add-to-list 'ispell-dictionary-alist
             (quote ("CA_English" "[[:alpha:]]" "[^[:alpha:]]" "['’]" t ("-d" "en_CA") nil utf-8)))

(setq ispell-dictionary "CA_English"
      ispell-program-name "hunspell")

(add-hook 'org-mode-hook 'flyspell-mode)
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)

(provide 'grm-feature-flyspell)
