(defvar grm-init-duration (float-time (time-since grm-before-init-time)))

(setq initial-major-mode 'org-mode
      initial-scratch-message
      (format "* scratch"))

(provide 'grm-startup-finalize)
