(setq gc-cons-threshold most-positive-fixnum ; 2^61 bytes
      gc-cons-percentage 0.6
      file-name-handler-alist nil)

(setq user-init-file (or load-file-name (buffer-file-name)))
(setq user-emacs-directory (file-name-directory user-init-file))
(defvar grm-base-dir      user-emacs-directory)
(defvar grm-startup-dir   (expand-file-name "startup"   grm-base-dir))
(defvar grm-modules-dir   (expand-file-name "modules"   grm-base-dir))
(defvar grm-features-dir  (expand-file-name "features"  grm-modules-dir))
(defvar grm-snippets-dir  (expand-file-name "snippets"  grm-base-dir))
(defvar grm-templates-dir (expand-file-name "templates" grm-base-dir))
(add-to-list 'load-path grm-startup-dir)
(add-to-list 'load-path grm-modules-dir)
(add-to-list 'load-path grm-features-dir)

(setq custom-file (expand-file-name "grm-custom.el" grm-startup-dir))

(require 'package)
(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
                         ("gnu"       . "http://elpa.gnu.org/packages/")
                         ("melpa"     . "http://melpa.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")))
(package-initialize)
(require 'grm-custom)
(require 'grm-defuns)
(require 'grm-inline-features)

(setq
 user-full-name                  "hamnixster"
 grm-font-string                 "Fira Code:pixelsize=18"
 grm-theme                       'nord
 grm-whitespace-background-color "#3b4252"
 grm-start-in-emacs-modes        '(dired-mode calendar-mode image-mode)
 grm-startup-quotes
 '(
   "The computer revolution is a revolution in the way we think and in the way we express what we think."
   "Nothing brings fear to my heart more than a floating point number."
   "We can only see a short distance ahead, but we can see plenty there that needs to be done."
   )
 grm-enabled-features-list
 '(
   no-littering
   grm-mode
   grm-leader
   key-chord
   visual
   emacs
   restart-emacs
   undo-tree
   smart-mode-line
   dimmer
   indent-guide
   beacon
   whitespace
   which-key
   evil
   helm
   org
   magit
   company
   projectile
   auto-insert
   yas
   diff-hl
   diminish
   )
 )

(grm-ensure-all-packages)
(grm-enable-features)

(setq gc-cons-threshold 16777216 ; 16mb
      gc-cons-percentage 0.1)
