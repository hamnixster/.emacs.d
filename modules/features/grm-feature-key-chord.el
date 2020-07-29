(defun grm-key-chord-define (keymap keys command)
  (if (/= 2 (length keys))
      (error "Key-chord keys must have two elements"))
  (let ((key1 (logand 255 (aref keys 0)))
        (key2 (logand 255 (aref keys 1))))
    (define-key keymap (vector 'key-chord key1 key2) command)))

(key-chord-mode +1)
(setq key-chord-two-keys-delay 0.3)
(fset 'key-chord-define 'grm-key-chord-define)

(provide 'grm-feature-key-chord)
