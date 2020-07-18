(setq which-key-idle-delay 1.0
      which-key-special-keys nil)
(autoload 'which-key--show-keymap "which-key")
(defun grm-which-key-show-major-mode-keymap (&optional initial-input)
  "Show the top-level bindings in KEYMAP using which-key. KEYMAP
is selected interactively from all available keymaps."
  (interactive)
  (which-key--show-keymap (symbol-name major-mode)
                          (eval (intern (format "%s-map" major-mode)))))
(which-key-mode +1)

(provide 'grm-misc-which-key)
