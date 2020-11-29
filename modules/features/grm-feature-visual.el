(setq-default cursor-type 'bar
              indicate-empty-lines t)
(setq custom-safe-themes t
      default-frame-alist `((font . ,grm-font-string))
      echo-keystrokes 0.01
      inhibit-startup-screen t
      scroll-conservatively 100000
      scroll-margin 10
      scroll-preserve-screen-position 1
      use-dialog-box nil
      )

(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(blink-cursor-mode -1)
(column-number-mode t)
(show-paren-mode t)
(size-indication-mode t)
(set-frame-font grm-font-string)

(provide 'grm-feature-visual)
