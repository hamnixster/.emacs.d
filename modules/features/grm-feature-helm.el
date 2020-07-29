(defun grm-try-helm-projectile-find-file-dwim (&rest args)
  (interactive)
  (if (projectile-project-p)
      (helm-projectile-find-file-dwim)
    (helm-projectile-switch-project args)))

(defun grm-try-helm-projectile-recentf (&rest args)
  (interactive)
  (if (projectile-project-p)
      (helm-projectile-recentf args)
    (helm-projectile-switch-project args)))

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

(provide 'grm-feature-helm)