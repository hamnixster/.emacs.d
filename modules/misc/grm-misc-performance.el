;; Prevent GC during minibuffer operations - Taken from DOOM
(defun grm-defer-garbage-collection-h ()
  (setq gc-cons-threshold most-positive-fixnum))
(defun grm-restore-garbage-collection-h ()
  ;; Defer it so that commands launched immediately after will enjoy the
  ;; benefits.
  (run-at-time
   1 nil (lambda () (setq gc-cons-threshold 16777216))))
(add-hook 'minibuffer-setup-hook #'grm-defer-garbage-collection-h)
(add-hook 'minibuffer-exit-hook #'grm-restore-garbage-collection-h)

(provide 'grm-misc-performance)
