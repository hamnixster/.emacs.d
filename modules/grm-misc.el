(require 'grm-misc-loader)

(defvar grm-enabled-misc-settings-list
  '(
    helm
    projectile
    auto-insert

    emacs-defaults
    performance
    diminish
    undo-tree
    which-key

    magit

    diff-hl
    beacon-mode
    indent-guide

    smartparens

    bindings
    ))

(mapc 'grm-misc-enable-setting grm-enabled-misc-settings-list)

(provide 'grm-misc)
