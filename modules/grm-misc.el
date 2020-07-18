(require 'grm-misc-loader)

(defvar grm-enabled-misc-settings-list
  '(
    helm
    projectile

    emacs-defaults
    diminish
    bindings

    performance

    auto-insert
    beacon-mode
    magit
    which-key
    diff-hl
    ))

(mapc 'grm-misc-enable-setting grm-enabled-misc-settings-list)

(provide 'grm-misc)
