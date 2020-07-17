;; Start server
(add-hook 'after-init-hook
          (lambda ()
            (require 'server)
            (or (server-running-p) (server-start))))

(defun grm-install-all-packages ()
  "Use this command to install all the packages.
It reads from package-selected-packages and
installs these packages one by one."
  (interactive)
  (package-refresh-contents)
  (let ((counter 0)
        (total (length package-selected-packages)))
    (dolist (pkg package-selected-packages)
      (setq counter (1+ counter))
      (package-installed-p pkg)
      (ignore-errors
        (package-install pkg)))))

(progn
  "Checks if packages need to be installed and does so if necessary."
  (when (catch 'break
          (dolist (pkg package-selected-packages)
            (unless (package-installed-p pkg)
              (throw 'break t))))
    (grm-install-all-packages)))

(require 'no-littering)

(provide 'grm-startup-init)
