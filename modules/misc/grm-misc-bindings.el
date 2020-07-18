(define-prefix-command 'ctrl-c-q-map)
(define-key grm-mode-map (kbd "C-c q") 'ctrl-c-q-map)
(define-key ctrl-c-q-map (kbd "R") 'restart-emacs)

(define-key grm-mode-map (kbd "C-c w") 'evil-window-map)

(define-prefix-command 'ctrl-c-g-map)
(define-key grm-mode-map (kbd "C-c g") 'ctrl-c-g-map)

(define-prefix-command 'ctrl-c-f-map)
(define-key grm-mode-map (kbd "C-c f") 'ctrl-c-f-map)

(define-key grm-mode-map          (kbd "C-x C-1") 'delete-other-windows)
(define-key grm-mode-map          (kbd "C-x C-2") 'split-window-below)
(define-key grm-mode-map          (kbd "C-x C-3") 'split-window-right)
(define-key grm-mode-map          (kbd "C-x C-0") 'delete-window)

;; magit
(define-key ctrl-c-g-map "s" #'magit-status)

;; which-key
(define-key grm-mode-map (kbd "C-c ?") 'which-key-show-top-level)
(define-key grm-mode-map (kbd "C-c /") 'grm-which-key-show-major-mode-keymap)

(provide 'grm-misc-bindings)
