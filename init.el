;;; init.el --- The configurations needed for every wandering samurai.

;;; Commentary:

;;; Code:

;;; straight.el setup
;; bootstrap
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; install use-package
(straight-use-package 'use-package)
(straight-use-package 'diminish)
(straight-use-package 'bind-key)

;; The following command is equivalent to use-package-always-ensure
;; but instead straight.el is used instead of package.el
(setq straight-use-package-by-default t)

;; There's some issues installing org using straight.el -
;; this hack gets around all of that (from the github page)
(require 'subr-x)
(straight-use-package 'git)

(defun org-git-version ()
  "The Git version of org-mode.
Inserted by installing org-mode or when a release is made."
  (require 'git)
  (let ((git-repo (expand-file-name
                   "straight/repos/org/" user-emacs-directory)))
    (string-trim
     (git-run "describe"
              "--match=release\*"
              "--abbrev=6"
              "HEAD"))))

(defun org-release ()
  "The release version of org-mode.
Inserted by installing org-mode or when a release is made."
  (require 'git)
  (let ((git-repo (expand-file-name
                   "straight/repos/org/" user-emacs-directory)))
    (string-trim
     (string-remove-prefix
      "release_"
      (git-run "describe"
               "--match=release\*"
               "--abbrev=0"
               "HEAD")))))

(provide 'org-version)

(straight-use-package 'org) 

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

;; Loading everything
(add-to-list 'load-path "~/.emacs.d/oro/")
(add-to-list 'load-path "~/.emacs.d/lib")
(add-to-list 'load-path "~/.emacs.d/modules/")

;; Core
(require 'oro-navigation)
(require 'oro-completion)
(require 'oro-org)

;; Lib
(require 'oro-lib-org)

;; Modules
(require 'oro-appearance)

;;; oro-lsp needs to go before all settings for programming languages
;;; because it does the preliminary setup of LSP
;;; It's currently commented out since I'm working out slowness related kinks in Oro
;; (require 'oro-lsp)
(require 'oro-php)

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

(use-package org-wiki
  :straight (org-wiki :type git :host github :repo "caiorss/org-wiki")
  :config
  (setq org-wiki-location "~/Dropbox/org/"))

(setq org-directory "~/Dropbox/org")

(setq org-agenda-files '("~/Dropbox/org/next_actions.org"
			 "~/Dropbox/org/projects.org"
			 "~/Dropbox/org/work_projects.org"
			 "~/Dropbox/org/work_next_actions.org"
			 "~/Dropbox/org/inbox.org"))

;; GTD contexts start with an @ sign
;; All other tags are common ones that I use
(setq org-tag-alist '(("@work" . ?w)
		      ("@home" . ?h)
		      ("@pc" . ?p)
		      ("@errands" . ?e)
		      ("@contact" . ?c) 
                      ("plan" . ?q)
                      ("schedule" . ?s)
		      ("blog" . ?b)
                      ("next_action" . ?n)
		      ("waiting_for" . ?w)))

(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cc" 'org-capture)
(define-key global-map "\C-cw" 'org-refile)
(define-key global-map "\C-cd" 'org-deadline)
(define-key global-map "\C-cq" 'org-set-tags-command)

(setq org-default-notes-file "~Dropbox/org/inbox.org")
(setq org-startup-with-inline-images "inlineimages")

(setq org-refile-use-outline-path 'file)
(setq org-refile-targets '((org-agenda-files :level . 1)
                           ("~/Dropbox/org/someday.org" :level . 1)
                           ("~/Dropbox/org/work_someday.org" :level . 1)
			   ("~/Dropbox/org/inbox.org" :level . 1)
			   ("~/Dropbox/org/work_next_actions.org" :level . 1)
			   ("~/Dropbox/org/next_actions.org" :level . 1)))
      
(setq org-outline-path-complete-in-steps nil)         ; Refile in a single go
(setq org-refile-allow-creating-parent-nodes 'confirm)

(setq org-agenda-custom-commands
      '(("w" "Agenda with work-related tasks"
	 ((agenda "")
	  (tags-todo "@work&next_action")))
      ("r" "Agenda with things that need to be refiled"
	 ((agenda "")
	  (tags "refile")))
      ("a" "Next action items, not work related"
       ((agenda "")
	(org-agenda-files '("~/Dropbox/org/next_actions.org"))
	(tags "next_action-@work")))
      ("D" "All items that you are currently doing"
       ((agenda "")
	(todo "DOING")))
      ("n" "All next action items"
         ((agenda "")
          (tags-todo "next_action")))))

(setq org-capture-templates
 ' (("i" "Quick capture inbox" entry (file "~/Dropbox/org/inbox.org")
        "* TODO")))

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

(use-package eyebrowse
  :config
  (eyebrowse-mode t))

(use-package multiple-cursors)
(global-set-key (kbd "<f12>") 'mc/edit-lines)


;;(use-package ggtags)
;;(setq ggtags-executable-directory "/usr/local/bin/bin/")

;;; init.el ends here
