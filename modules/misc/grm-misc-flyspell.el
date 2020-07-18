(require 'flyspell)

(add-hook 'text-mode-hook
          'flyspell-mode)

(add-hook 'prog-mode-hook
          'flyspell-prog-mode)

(add-to-list 'ispell-dictionary-alist
             (quote ("CA_English" "[[:alpha:]]" "[^[:alpha:]]" "['’]" t ("-d" "en_CA") nil utf-8)))

(setq
 ispell-dictionary "CA_English"
 ispell-program-name "hunspell")

(provide 'grm-misc-flyspell)
