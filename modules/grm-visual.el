(let ((font-string "Fira Code:pixelsize=16"))
  (setq-default cursor-type 'bar
                indicate-empty-lines t)
  (setq
   custom-safe-themes t
   default-frame-alist `((font . ,font-string))
   echo-keystrokes 0.01
   inhibit-startup-message t
   inhibit-startup-screen t
   scroll-conservatively 100000
   scroll-margin 0
   scroll-margin 10
   scroll-preserve-screen-position 1
   use-dialog-box nil
   whitespace-line-column 80
   whitespace-style '(face tabs empty trailing lines-tail)
   x-gtk-use-system-tooltips t)

  (blink-cursor-mode -1)
  (column-number-mode t)
  (global-whitespace-mode)
  (line-number-mode t)
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (show-paren-mode t)
  (size-indication-mode t)
  (tool-bar-mode -1)
  (set-frame-font font-string)
  (load-theme 'nord))

(provide 'grm-visual)
