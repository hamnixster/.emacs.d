(require 'whitespace)
(setq
 whitespace-line-column 120
 whitespace-style '(face tabs trailing lines-tail))
(global-whitespace-mode 1)
(dolist (face '(whitespace-trailing whitespace-line whitespace-tab))
  (set-face-attribute face nil :background grm-whitespace-background-color))

(provide 'grm-feature-whitespace)
