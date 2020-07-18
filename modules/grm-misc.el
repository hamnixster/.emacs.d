(require 'grm-misc-loader)

(defvar grm-enabled-misc-settings-list
  '(
    emacs-defaults

    performance
    ))

(mapc 'grm-misc-enable-setting grm-enabled-misc-settings-list)

(provide 'grm-misc)
