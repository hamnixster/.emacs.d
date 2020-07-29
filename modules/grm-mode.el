;; From http://stackoverflow.com/a/5340797
(defmacro grm-define-highest-priority-mode-function (mode)
  (let ((fn (intern (format "grm-gain-highest-keys-priority-%S" mode))))
    `(defun ,fn (_file)
       "Try to ensure that my keybindings retain priority over other minor modes.
Called via the `after-load-functions' special hook."
       (unless (eq (caar minor-mode-map-alist) ',mode)
         (let ((mykeys (assq ',mode minor-mode-map-alist)))
           (assq-delete-all ',mode minor-mode-map-alist)
           (add-to-list 'minor-mode-map-alist mykeys))))))

(defvar grm-mode-map (make-sparse-keymap))

(define-minor-mode grm-mode
  "\\{grm-mode-map}"
  t " GRM" grm-mode-map :group grm-mode)

(define-globalized-minor-mode global-grm-mode
  grm-mode
  grm-mode-on
  :group 'grm-mode
  :require 'grm-mode)

(defun grm-mode-on ()
  (interactive)
  (grm-mode +1))

(defun grm-mode-off ()
  (interactive)
  (grm-mode -1))

;; Fix the problem when minibuffer first pop up
(defun grm-mode-minibuffer-setup-hook ()
  (remove-hook 'minibuffer-setup-hook #'grm-mode-minibuffer-setup-hook)
  (grm-mode-on))
(add-hook 'minibuffer-setup-hook #'grm-mode-minibuffer-setup-hook)

(defun grm-gain-highest-keys-priority-grm-mode ()
  (grm-define-highest-priority-mode-function grm-mode))
(grm-gain-highest-keys-priority-grm-mode)
(add-hook 'after-load-functions 'grm-gain-highest-keys-priority-grm-mode)

(provide 'grm-mode)
