(setq user-init-file (or load-file-name (buffer-file-name)))
(setq user-emacs-directory (file-name-directory user-init-file))
(defvar grm-base-dir    user-emacs-directory)
(defvar grm-startup-dir (expand-file-name "startup" grm-base-dir))
(defvar grm-modules-dir (expand-file-name "modules" grm-base-dir))
(add-to-list 'load-path grm-startup-dir)
(add-to-list 'load-path grm-modules-dir)

(setq custom-file (expand-file-name "grm-custom.el" grm-startup-dir))

(require 'package)
(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
                         ("gnu"       . "http://elpa.gnu.org/packages/")
                         ("melpa"     . "http://melpa.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")))
(package-initialize)
(require 'grm-custom)

(defun grm-install-all-packages ()
  "Use this command to install all the packages.
It reads from package-selected-packages and
installs these packages one by one."
  (interactive)
  (package-refresh-contents)
  (dolist (pkg package-selected-packages)
    (package-installed-p pkg)
    (ignore-errors
      (package-install pkg))))

(progn
  "Checks if packages need to be installed and does so if necessary."
  (when (catch 'break
          (dolist (pkg package-selected-packages)
            (unless (package-installed-p pkg)
              (throw 'break t))))
    (grm-install-all-packages)))

(require 'no-littering)

(require 'grm-mode)
(require 'grm-leader-mode)
(grm-leader-mode)
(setq grm-leader-literal-key " "
      grm-leader-special '(?i)
      grm-leader-mod-alist
      '((nil . "C-")
        (" " . "")
        ("m" . "M-")
        ("," . "C-M-")
        ))

(setq evil-want-keybinding nil
      evil-want-integration t)

(require 'evil)
;; eager loading commands helps grm-leader work the first time.... maybe?
(require 'evil-commands)
(evil-mode +1)

(define-key evil-normal-state-map (kbd "SPC") 'grm-leader-mode-exec)
(define-key evil-visual-state-map (kbd "SPC") 'grm-leader-mode-exec)
(define-key evil-motion-state-map (kbd "SPC") 'grm-leader-mode-exec)

(require 'which-key)
(which-key-mode +1)
(setq grm-leader-which-key t)
