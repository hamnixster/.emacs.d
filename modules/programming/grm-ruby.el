(require 'chruby)
(chruby "2.7.1")

(setq inf-ruby-default-implementation "pry"
      inf-ruby-first-prompt-pattern "^\\[[0-9]+\\] pry\\((.*)\\)> *"
      inf-ruby-prompt-pattern "^\\[[0-9]+\\] pry\\((.*)\\)[>*\"'] *")

(add-hook 'ruby-mode-hook 'robe-mode)

(eval-after-load 'company
  '(push 'company-robe company-backends))

(advice-add 'inf-ruby-console-auto :before #'chruby-use-corresponding)

(provide 'grm-ruby)
