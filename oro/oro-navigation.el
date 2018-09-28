;;;; oro-navigation --- we all gotta go somewhere
;;;; Commentary:

;;; Why is this part of Oro core?

;; Because we all gotta go somewhere.  Being able to quickly and easily
;; navigate around code will make you more efficient and if not -
;; at least you'll look cool with your cursor jumping everywhere.

;;; Why evil?

;;; Why helm?

;;; Code:
;; Navigation
(use-package evil
  :straight t
  :config
  (evil-mode))

(use-package helm-fuzzier)
(use-package helm-flx)
(use-package helm
  :straight t
  :diminish
  :init
  (progn
    (require 'helm-config)
    (require 'helm-fuzzier)
    (setq helm-idle-delay 0.0
          helm-input-idle-delay 0.01
          helm-flx-for-helm-find-files t
          helm-flx-for-helm-locate t
          helm-M-x-fuzzy-match t)
    (helm-mode))
  :bind (("C-c h" . helm-mini)
         ("C-x C-b" . helm-buffers-list)
         ("C-x b" . helm-buffers-list)
         ("C-x l" . helm-locate)
         ("M-x" . helm-M-x)
         ("C-x C-f" . helm-find-files)))

(helm-flx-mode 1)
(helm-fuzzier-mode 1)

(use-package which-key
  :config
  (setq which-key-idle-delay 0.5)
  (which-key-mode))

(use-package neotree
  :config
  (global-set-key [f8] 'neotree-toggle)
  (add-hook 'neotree-mode-hook
            (lambda ()
              (define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter)
              (define-key evil-normal-state-local-map (kbd "SPC") 'neotree-quick-look)
              (define-key evil-normal-state-local-map (kbd "q") 'neotree-hide)
              (define-key evil-normal-state-local-map (kbd "RET") 'neotree-enter))))

(use-package discover
  :config
  (global-discover-mode 1)
)

(discover-add-context-menu
  :context-menu '(isearch
               (description "Isearch, occur and highlighting")
               (actions
                ("Isearch"
                 ("C-s" "isearch forward"))))
  :bind "M-s")

(discover-add-context-menu
  :context-menu '(php-mode
                   (description "PHP major mode related actions and keybindings")
                   (actions
                     ("ac-php"
                       ("C-c j" "ac-php-find-symbol-at-point: Jump to a function definition")
                       ("C-c b" "ac-php-location-stack-back: Go back, after jumping")
                       ("C-c s" "ac-php-show-tip: Show a function's info")
                       ("C-c r" "ac-php-remake-tags: Re-index files")
                       ("C-c i" "ac-php-show-cur-project-info: Show current project info"))))
  :bind "M-p")

(use-package projectile
  :config
  (projectile-mode +1))

(use-package helm-projectile
  :config
  (helm-projectile-on))

(use-package ggtags)
(setq ggtags-executable-directory "/usr/local/bin/bin/")

;; A text folding minor mode for Emacs
;; https://github.com/gregsexton/origami.el
(use-package origami
  :config
  (add-hook 'prog-mode-hook #'origami-mode))

(provide 'oro-navigation)
;;; oro-navigation ends here
