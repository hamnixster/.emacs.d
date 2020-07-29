(org-babel-do-load-languages
 'org-babel-load-languages
 (mapcar (lambda (lang) (cons lang t))
         `(python
           ruby
           shell
           )))

(provide 'grm-feature-org)
