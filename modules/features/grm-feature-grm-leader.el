(require 'grm-leader-mode)
(setq grm-leader-literal-key " "
      grm-leader-special-map '(?q ?w ?f ?g ?i)
      grm-leader-maps-alist
      (mapcar
       (lambda (char)
         (cons char (intern (format "grm-leader-C-%c-map" char))))
       grm-leader-special-map)
      grm-leader-special-command '(?o)
      grm-leader-special (append grm-leader-special-map grm-leader-special-command)
      grm-leader-mod-alist
      '((nil . "C-")
        (" " . "")
        ("m" . "M-")
        ("," . "C-M-")
        ))

(grm-leader-mode)

(when (member 'which-key grm-enabled-features-list)
  (setq grm-leader-which-key t))

(dolist (map-key grm-leader-maps-alist)
  (define-prefix-command (cdr map-key)))

(when (member 'grm-mode grm-enabled-features-list)
  (dolist (map-key grm-leader-maps-alist)
    (define-key grm-mode-map
      (kbd (format "C-c %c" (car map-key)))
      (cdr map-key))))

(defun grm-leader-define-key (map-char key-seq command)
  (define-key
    (cdr (assq map-char grm-leader-maps-alist))
    (kbd key-seq)
    command))

(defun grm-leader-define-keys (map-char key-command-alist)
  (dolist (key-command key-command-alist)
    (grm-leader-define-key map-char (car key-command) (cdr key-command))))

(provide 'grm-feature-grm-leader)
