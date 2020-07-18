(require 'grm-misc-loader)

(defvar grm-enabled-misc-settings-list
  '(
    emacs-defaults
    bindings

    performance

    magit
    which-key
    ))

(mapc 'grm-misc-enable-setting grm-enabled-misc-settings-list)

(provide 'grm-misc)
