(add-hook 'find-file-hooks 'auto-insert)
(setq auto-insert-directory (concat grm-base-dir "templates/"))

(autoload 'org-insert-time-stamp "org")

(defun grm-misc-auto-insert-interpreter (lang)
  "Return interpreter string according to LANG."
  (cond ((equal lang 'python) "#! /usr/bin/env python")
        ((equal lang 'bash) "#! /bin/bash")))

(defun grm-misc-auto-insert-script-template (lang)
  "Generate template according to LANG."
  `(
    "Short descriptions: "
    ,(grm-misc-auto-insert-interpreter lang) \n
    "# Author: " (user-full-name) \n
    "# Date: " '(org-insert-time-stamp (current-time)) \n
    "# Description: " str \n))

(with-eval-after-load 'autoinsert
  (progn
    (setq auto-insert-query nil)
    (setq auto-insert-alist nil)
    (add-hook 'find-file-hook 'auto-insert)
    (define-auto-insert '("\\.py\\'" . "Python skeleton")
      (grm-misc-auto-insert-script-template 'python))
    (define-auto-insert '("\\.sh\\'" . "Shell scripts skeleton")
      (grm-misc-auto-insert-script-template 'bash))
    (define-auto-insert '("\\.org\\'" . "Org-mode skeleton")
      '("Short description: "
        "* " (file-name-base (buffer-file-name))))))

(provide 'grm-misc-auto-insert)
