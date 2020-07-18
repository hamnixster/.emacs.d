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

(provide 'grm-rails)
