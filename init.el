;; Startup performance related - Taken from DOOM
(defvar grm--file-name-handler-alist file-name-handler-alist)
(setq gc-cons-threshold most-positive-fixnum ; 2^61 bytes
      gc-cons-percentage 0.6
      file-name-handler-alist nil)

(require 'package)
(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
                         ("gnu"       . "http://elpa.gnu.org/packages/")
                         ("melpa"     . "http://melpa.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")))
(package-initialize)

(defvar grm-base-dir    (file-name-directory load-file-name))
(defvar grm-startup-dir (expand-file-name "startup" grm-base-dir))
(defvar grm-modules-dir (expand-file-name "modules" grm-base-dir))
(setq custom-file (expand-file-name "grm-custom.el" grm-startup-dir))

(add-to-list 'load-path grm-startup-dir)
(add-to-list 'load-path grm-modules-dir)

(require 'grm-startup-profile)
(grm-require 'grm-custom)
(grm-require 'grm-startup-init)
(grm-require 'grm-modules-init)
(grm-require 'grm-startup-finalize)

;; Startup performance related - Taken from DOOM
(setq file-name-handler-alist grm--file-name-handler-alist
      gc-cons-threshold 16777216 ; 16mb
      gc-cons-percentage 0.1)

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
