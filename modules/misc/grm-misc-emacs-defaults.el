(let ((paths
       (shell-command-to-string
        (format "%s -c 'echo -n $PATH'" (getenv "SHELL")))))
  (setq-default fill-column 120
                indent-tabs-mode nil
                imenu-auto-rescan t)
  (setq backup-directory-alistq `((".*" . ,temporary-file-directory))
        exec-path (split-string paths ":")
        mouse-yank-at-point t
        recentf-save-file (expand-file-name "recentf" grm-base-dir)
        require-final-newline t
        sentence-end-double-space nil
        tramp-backup-directory-alist backup-directory-alist
        uniquify-buffer-name-style 'forward
        uniquify-ignore-buffers-re "^\\*"
        auto-save-file-name-transforms `((".*" ,temporary-file-directory t))))

(with-eval-after-load 'recentf
  (add-to-list 'recentf-exclude "COMMIT_EDITMSG\\'")
  (add-to-list 'recentf-exclude no-littering-var-directory)
  (add-to-list 'recentf-exclude no-littering-etc-directory))

(add-hook 'text-mode-hook 'turn-on-auto-fill)
(fset 'yes-or-no-p 'y-or-n-p)
(minibuffer-depth-indicate-mode +1)
(save-place-mode +1)
(savehist-mode +1)
(winner-mode +1)
(require 'tramp)

(org-babel-do-load-languages
 'org-babel-load-languages
 (mapcar (lambda (lang) (cons lang t))
         `(python
           ruby
           )))

(defun grm-save-buffer-and-directories ()
  (when buffer-file-name
    (let ((dir (file-name-directory buffer-file-name)))
      (when (not (file-exists-p dir))
        (make-directory dir t))
      (when (not (file-exists-p (buffer-file-name)))
        (save-buffer (buffer-file-name))))))

(provide 'grm-misc-emacs-defaults)
