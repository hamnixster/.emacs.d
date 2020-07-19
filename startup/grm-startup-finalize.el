(defvar grm-init-duration (float-time (time-since grm-before-init-time)))

(defun random-choice (items)
  (let* ((size (length items))
         (index (random size)))
    (nth index items)))

(let ((quotes
       '("There's a good part of Computer Science that's like magic.\n  Unfortunately there's a bad part of Computer Science that's like religion."
         "If I have not seen as far as others, it is because giants were standing on my shoulders."
         "The computer revolution is a revolution in the way we think and in the way we express what we think."
         "Nothing brings fear to my heart more than a floating point number."
         "We can only see a short distance ahead, but we can see plenty there that needs to be done."
         "One day ladies will take their computers for walks in the park and tell each other,\n  \"My little computer said such a funny thing this morning\".")))
  (setq initial-major-mode 'org-mode
        initial-scratch-message
        (format "* %s \n  %s\n" (format-time-string "%Y-%m-%d") (random-choice quotes))))

(provide 'grm-startup-finalize)
