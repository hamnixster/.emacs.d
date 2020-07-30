(require 'chruby)
(chruby "2.7.1")

(setq inf-ruby-default-implementation "pry"
      inf-ruby-first-prompt-pattern "^\\[[0-9]+\\] pry\\((.*)\\)> *"
      inf-ruby-prompt-pattern "^\\[[0-9]+\\] pry\\((.*)\\)[>*\"'] *")

(add-hook 'ruby-mode-hook 'robe-mode)

(advice-add 'inf-ruby-console-auto :before #'chruby-use-corresponding)

(require 'rspec-mode)
(setq inf-ruby-console-environment "development")

(require 'inf-ruby)
(defun ruby-send-string (str)
  "Send a string to the inf-ruby-proc and return the output as an elisp string"
  (if (not (inf-ruby-buffer)) ""
    (comint-send-string (inf-ruby-proc) (format "%s\n" str))
    (let ((proc (inf-ruby-proc)))
      (with-current-buffer (or (inf-ruby-buffer)
                               inf-ruby-buffer)
        (while (not (and comint-last-prompt
                         (goto-char (car comint-last-prompt))
                         (looking-at inf-ruby-first-prompt-pattern)))
          (accept-process-output proc))
        (re-search-backward inf-ruby-prompt-pattern)
        (or (re-search-forward " => " (car comint-last-prompt) t)
            ;; Evaluation seems to have failed.
            ;; Try to extract the error string.
            (let* ((inhibit-field-text-motion t)
                   (s (buffer-substring-no-properties (point) (line-end-position))))
              (while (string-match inf-ruby-prompt-pattern s)
                (setq s (replace-match "" t t s)))
              (error "%s" s)))
        (buffer-substring-no-properties (point) (line-end-position))))))

(add-hook 'ruby-mode-hook (lambda () (setq flycheck-checker 'ruby-standard)))

(defun rails-classify-file ()
  (string-trim
   (ruby-send-string
    (format "'%s'.split(/#{Rails.root}\\/app\\//).last.split('/', 2).last.classify"
            (file-name-sans-extension (buffer-file-name)))) "\"" "\""))

(defun rails-classify-file-modules ()
  (string-join
   (mapcar (lambda (x) (format "module %s" x))
           (split-string (rails-classify-file) "::"))
   "\n"))

(defun rails-classify-file-modules-class ()
  (let* ((mods (split-string (rails-classify-file) "::"))
         (modules (butlast mods))
         (class (car (reverse mods))))
    (string-join
     (append
      (mapcar (lambda (x) (format "module %s" x)) modules)
      (list (format "class %s" class)))
     "\n")))

(defun rails-classify-file-modules-ends ()
  (string-join
   (make-list
    (length (split-string (rails-classify-file) "::"))
    "end")
   "\n"))

(projectile-rails-global-mode)
(add-hook 'after-init-hook 'inf-ruby-switch-setup)

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))

(require 'mmm-auto)
(setq mmm-global-mode 'auto)
(mmm-add-mode-ext-class 'html-erb-mode "\\.html\\.erb\\'" 'erb)
(add-to-list 'auto-mode-alist '("\\.html\\.erb\\'" . html-erb-mode))
(setq mmm-submode-decoration-level 0
      mmm-parse-when-idle t)
(require 'erblint)

(provide 'grm-feature-ruby)
