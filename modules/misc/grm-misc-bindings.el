;; leader
(setq grm-leader-special '(?q ?w ?t ?y ?i ?o
                           ?d ?f ?g ?j
                           ?z ?v ?b))
(defcustom grm-leader-mod-alist
  '((nil . "C-")
    ("," . "C-M-")
    ("m" . "M-"))
  "List of keys and their associated modifer."
  :group 'grm-leader
  :type '(alist))

(define-key evil-normal-state-map (kbd "SPC") 'evil-execute-in-grm-leader-state)
(define-key evil-visual-state-map (kbd "SPC") 'evil-execute-in-grm-leader-state)
(define-key evil-motion-state-map (kbd "SPC") 'evil-execute-in-grm-leader-state)

(define-prefix-command 'ctrl-c-q-map)
(define-key grm-mode-map (kbd "C-c q") 'ctrl-c-q-map)
(define-key ctrl-c-q-map (kbd "R") 'restart-emacs)

(define-key grm-mode-map (kbd "C-c w") 'evil-window-map)

(define-prefix-command 'ctrl-c-g-map)
(define-key grm-mode-map (kbd "C-c g") 'ctrl-c-g-map)

(define-prefix-command 'ctrl-c-f-map)
(define-key grm-mode-map (kbd "C-c f") 'ctrl-c-f-map)

;; emacs
(global-set-key (kbd "C-x C-z") nil)
(global-set-key (kbd "C-x f") 'find-file)

;; window
(define-key grm-mode-map (kbd "C-x C-1") 'delete-other-windows)
(define-key grm-mode-map (kbd "C-x C-2") 'split-window-below)
(define-key grm-mode-map (kbd "C-x C-3") 'split-window-right)
(define-key grm-mode-map (kbd "C-x C-0") 'delete-window)

;; company
(define-key grm-mode-map (kbd "C-c C-y") 'company-yasnippet)
(grm-key-chord-define company-active-map "jk"        'company-complete)
(define-key           company-active-map (kbd "C-j") 'company-select-next)
(define-key           company-active-map (kbd "C-k") 'company-select-previous)
(define-key           company-active-map [escape] 'keyboard-quit)

;; evil
(define-key evil-insert-state-map (kbd "<escape>") 'evil-normal-state)
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
(global-set-key [escape]          'evil-exit-emacs-state)
(define-key grm-mode-map [escape] 'minibuffer-keyboard-quit)
(define-key evil-normal-state-map "gc" 'evilnc-comment-operator)

;; helm
(define-key helm-find-files-map [C-backspace]   'helm-find-files-up-one-level)
(define-key helm-find-files-map (kbd "C-h")     'helm-find-files-up-one-level)
(define-key helm-map            (kbd "C-j")     'helm-next-line)
(define-key helm-map            (kbd "C-k")     'helm-previous-line)
(with-eval-after-load 'grm-leader-mode
  (define-key grm-leader-local-mode-map (kbd "SPC") 'helm-mini))

(define-key grm-mode-map        (kbd "M-x")     'helm-M-x)
(define-key grm-mode-map        (kbd "C-x C-f") 'helm-projectile)
(define-key grm-mode-map        (kbd "C-c C-z") 'helm-projectile-ag)
(define-key grm-mode-map        (kbd "C-x C-b") 'helm-mini)
(define-key grm-mode-map        (kbd "C-x C-y") 'helm-show-kill-ring)

;; magit
(define-key ctrl-c-g-map "s" #'magit-status)
(with-eval-after-load 'magit-mode
  ;; literally cannot figure out how to get grm-leader to work for anything in magit :(
  ;; (define-key magit-mode-map (kbd "SPC") 'evil-execute-in-grm-leader-state)
  ;; (define-key magit-mode-map (kbd "C-c x f") 'find-file)
  (define-key transient-map        [escape] 'transient-quit-one)
  (define-key transient-edit-map   [escape] 'transient-quit-one)
  (define-key transient-sticky-map [escape] 'transient-quit-seq)
  (define-key transient-map        "q" 'transient-quit-one)
  (define-key transient-edit-map   "q" 'transient-quit-one)
  (define-key transient-sticky-map "q" 'transient-quit-seq))

;; which-key
(define-key grm-mode-map (kbd "C-c ?") 'which-key-show-top-level)
(define-key grm-mode-map (kbd "C-c /") 'grm-which-key-show-major-mode-keymap)

;; rails
(with-eval-after-load 'projectile-rails-mode
  (define-key projectile-rails-mode-map (kbd "C-c r") 'projectile-rails-command-map))

(provide 'grm-misc-bindings)
