(unless (category-docstring ?U)
  (define-category ?U "Uppercase")
  (define-category ?u "Lowercase"))
(modify-category-entry (cons ?A ?Z) ?U)
(modify-category-entry (cons ?a ?z) ?u)
(make-variable-buffer-local 'evil-cjk-word-separating-categories)
(defun grm-evil-subword-mode-hook ()
  (if subword-mode
      (push '(?u . ?U) evil-cjk-word-separating-categories)
    (setq evil-cjk-word-separating-categories
          (default-value 'evil-cjk-word-separating-categories))))
(add-hook 'subword-mode-hook #'grm-evil-subword-mode-hook)

(global-subword-mode)

(provide 'grm-feature-subword)
