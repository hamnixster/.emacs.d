(beacon-mode +1)
(dolist (mode '(eshell-mode term-mode))
  (add-to-list 'beacon-dont-blink-major-modes mode))
(setq beacon-blink-when-point-moves-vertically 10
      beacon-blink-when-buffer-changes t
      beacon-size 60
      beacon-color grm-whitespace-background-color)

(provide 'grm-feature-beacon)
