(require 'helm)
(require 'helm-mode)
(require 'helm-config)

(defun grm-helm-window-hide-cursor ()
  (with-helm-buffer
    (setq cursor-in-non-selected-windows nil)))

(add-hook 'helm-after-initialize-hook #'grm-helm-window-hide-cursor)

(add-to-list 'display-buffer-alist
                    `(,(rx bos "*helm" (* not-newline) "*" eos)
                         (display-buffer-in-side-window)
                         (inhibit-same-window . t)
                         (window-height . 0.4)))

(provide 'grm-misc-helm)
