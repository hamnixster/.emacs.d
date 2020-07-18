(setq undo-tree-history-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq undo-tree-auto-save-history t)
(global-undo-tree-mode)

(provide 'grm-misc-undo-tree)
