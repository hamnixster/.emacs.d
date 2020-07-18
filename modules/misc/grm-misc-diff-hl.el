(global-diff-hl-mode +1)
(setq diff-hl-side 'left)
(add-hook 'dired-mode-hook 'diff-hl-dired-mode)
(add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)

(provide 'grm-misc-diff-hl)
