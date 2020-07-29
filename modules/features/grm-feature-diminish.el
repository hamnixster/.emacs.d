(defmacro grm-diminish (file mode-name)
  `(with-eval-after-load ',file
     (diminish ',mode-name)))

(defun grm-diminish-essential ()
  (interactive)
  (defun grm-misc-diminish-helm ()
    (diminish 'helm-mode)
    (remove-hook 'helm-mode-hook #'grm-misc-diminish-helm))
  (with-eval-after-load 'helm
    (add-hook 'helm-mode-hook #'grm-misc-diminish-helm))
  (grm-diminish beacon beacon-mode)
  (grm-diminish company company-mode)
  (grm-diminish eldoc eldoc-mode)
  (grm-diminish grm-mode grm-mode)
  (grm-diminish indent-guide indent-guide-mode)
  (grm-diminish undo-tree undo-tree-mode)
  (grm-diminish whitespace-cleanup-mode whitespace-cleanup-mode)
  (grm-diminish which-key which-key-mode)
  (grm-diminish helm helm-ff-cache-mode)
  (grm-diminish projectile projectile-mode)
  (diminish 'yas-minor-mode)
  (diminish 'abbrev-mode)
  (diminish 'global-whitespace-mode)
  )

(grm-diminish-essential)

(provide 'grm-feature-diminish)
