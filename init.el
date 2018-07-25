;;; init.el --- The configurations needed for every wandering samurai.

;;; Commentary:

;;; Code:

;;; Package Settings
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;; Use-package can be used to automatically install packages, except itself. This proves that the chicken came before the egg!
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(unless (package-installed-p 'paradox)
  (package-install 'paradox))
(eval-when-compile
  (require 'paradox))
(paradox-enable)

(setq use-package-always-ensure t)

;; I like keeping my packages up-to-date. I want to be able to use Emacs anywhere I can load my dotfiles - so I always want Emacs to act the same. Having
;; my packages always up-to-date is an easy way to make sure that they're all the same version.
;;
;; The command (auto-package-update-now) will update installed Emacs packages right now.
;; The command (auto-package-update-maybe) will update packages if at least auto-package-update-interval days have passed since the last update.
;;
;; [[https://github.com/rranelli/auto-package-update.el][auto-package-update]]
(require 'auto-package-update)
(setq auto-package-update-prompt-before-update t)
(auto-package-update-maybe)

(require 'diminish)
(require 'bind-key)

;; There's some stuff that I definitely /shouldn't/ share on github.
;; (Just search for "removed password" on github)
(load-file "~/Dropbox/org/secrets.el")
(setq auth-sources
    '((:source "~/Dropbox/org/.authinfo.gpg")))

;; Base Emacs options
(fset 'yes-or-no-p 'y-or-n-p)
(global-linum-mode -1)
(scroll-bar-mode -1)

(setq inhibit-eol-conversion t)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;; (global-auto-revert-mode t)

;; Loading everything
(add-to-list 'load-path "~/.emacs.d/oro/")
(add-to-list 'load-path "~/.emacs.d/modules/")
(require 'oro-navigation)
(require 'oro-appearance)
(require 'oro-org)
(require 'oro-appearance)
(require 'oro-completion)

;;; oro-lsp needs to go before all settings for programming languages
;;; because it does the preliminary setup of LSP
;;; It's currently commented out since I'm working out slowness related kinks in Oro
;; (require 'oro-lsp)
(require 'oro-php)

(use-package projectile
  :config
  (projectile-mode +1))

(use-package helm-projectile
  :config
  (helm-projectile-on))

;; Appearance
(use-package beacon
  :init
  (beacon-mode 1))

(use-package rainbow-mode
  :diminish
  :init
  (rainbow-mode 1))

;; Tools
(setq org-src-fontify-natively t
  org-src-tab-acts-natively t
  org-confirm-babel-evaluate nil
  org-edit-src-content-indentation 0)

(use-package ediff)

(setq org-directory "~/Dropbox/org")

(if (eq system-type 'gnu/linux) (setq org-agenda-files '("~/Dropbox/org/tasks.org"
                                                         "~/Dropbox/org/projects.org"
                                                         "~/Dropbox/org/ives_tasks.org"
                                                         "~/Dropbox/org/ives_projects.org"
                                                         "~/Dropbox/org/tickler.org"))
  (setq org-agenda-files "C:/Users/JonathanCyr/Dropbox/org/tasks.org"
                         "C:/Users/JonathanCyr/Dropbox/org/projects.org"
                         "C:/Users/JonathanCyr/Dropbox/org/ives_tasks.org"
                         "C:/Users/JonathanCyr/Dropbox/org/ives_projects.org"))

; These are my GTD contexts
(setq org-tag-alist '(("@work" . ?w)
		      ("@home" . ?h)
		      ("@pc" . ?p)
                      ("@plan" . ?q)
                      ("@schedule" . ?s)
		      ("@read" . ?r)
		      ("@watch" . ?W)
		      ("@listen" . ?l)
		      ("@contact" . ?c)
		      ("@blog" . ?b)
                      ("@nextaction" . ?n)
                      ("@organize" . ?o)
		      ("@errands" . ?e)))

(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cc" 'org-capture)
(define-key global-map "\C-cw" 'org-refile)
(define-key global-map "\C-cd" 'org-deadline)
(define-key global-map "\C-cq" 'org-set-tags-command)

(setq org-default-notes-file "~Dropbox/org/inbox.org")
(setq org-display-inline-images t)
(setq org-redisplay-inline-images t)
(setq org-startup-with-inline-images "inlineimages")

(setq org-refile-use-outline-path 'file)
(setq org-refile-targets '((org-agenda-files :level . 1)
                           ("~/Dropbox/org/someday.org" :level . 1)
                           ("~/Dropbox/org/ives_someday.org" :level . 1)))
(setq org-outline-path-complete-in-steps nil)         ; Refile in a single go
(setq org-refile-allow-creating-parent-nodes 'confirm)

(setq org-agenda-custom-commands
      '(("w" "Agenda with work-related tasks"
	 ((agenda "")
	  (tags-todo "@work")))
      ("r" "Agenda with things that need to be refiled"
	 ((agenda "")
	  (tags "refile")))
      ("n" "All next action items"
         ((agenda "")
          (tags "@nextaction")))))

(setq org-capture-templates
 '(("w" "Ives tasks inbox" entry (file "~/Dropbox/org/ives_tasks.org")
        "* TODO ")
   ("i" "Quick capture inbox" entry (file "~/Dropbox/org/tasks.org")
        "* TODO")
   ("b" "Quick capture for blog" entry (file+headline "~/Dropbox/org/blog.org" "Inbox")
        "** TODO")))

(setq org-archive-location "~/Dropbox/org/archive/%s_archive::")

; To enforce ordering within tasks
(setq org-enforce-todo-dependencies t)

(use-package org-caldav
  :init
  (setq org-caldav-url "https://caldav.fastmail.com/dav/calendars/user/jonathancyr@fastmail.com/")
  (setq org-caldav-calendar-id "64404e83-eb82-4e71-9da3-30f49b85c831")
  (setq org-caldav-inbox "~/Dropbox/org/calendar.org")
  (setq org-caldav-files '("~/Dropbox/org/tickler.org")))

(use-package htmlize)

(use-package eldoc
  :diminish)

(defun do-nothing ()
  (interactive)
  (whitespace-mode -1)
  (flycheck-mode -1)
  (electric-indent-local-mode -1))


(use-package yasnippet
  :diminish
)
(yas-global-mode 1)

(show-paren-mode 1)

(use-package rainbow-delimiters)

(use-package markdown-mode)
(use-package smartparens)
(add-hook 'php-mode-hook #'smartparens-mode)

(use-package indent-guide)
(indent-guide-global-mode)

(setq whitespace-style '(face spaces space-mark tabs tab-mark empty))
(setq whitespace-action nil)

(use-package git-gutter
  :diminish)
(custom-set-variables
 '(git-gutter:handled-backends '(git hg)))
(custom-set-variables
 '(git-gutter:update-interval 2))
(global-git-gutter-mode t)

(global-set-key (kbd "C-x v =") 'git-gutter:popup-diff)
(global-set-key (kbd "C-x p") 'git-gutter:previous-hunk)
(global-set-key (kbd "C-x n") 'git-gutter:next-hunk)

(use-package hl-todo)
(define-key hl-todo-mode-map (kbd "C-c p") 'hl-todo-previous)
(define-key hl-todo-mode-map (kbd "C-c n") 'hl-todo-next)
(define-key hl-todo-mode-map (kbd "C-c o") 'hl-todo-occur)
(global-hl-todo-mode)

(use-package flycheck-pos-tip)

(use-package flycheck
  :diminish
  :preface
  (global-flycheck-mode)
  (flycheck-pos-tip-mode)
  :config
  (setq flycheck-check-syntax-automatically '(save)))

(use-package monky)

(use-package transpose-frame)

(use-package dumb-jump)

(use-package ggtags)
(setq ggtags-executable-directory "/usr/local/bin/bin/")

;;; init.el ends here
