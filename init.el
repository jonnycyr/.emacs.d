;;; init.el --- \^-^/

;;; Commentary:

;;; Code:

;; Package Settings
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
(require 'diminish)          
(require 'bind-key)         

(setq-default use-package-always-ensure t)

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

(global-auto-revert-mode t)

;; Loading everything
(add-to-list 'load-path "~/.emacs.d/oro/")
(require 'oro-navigation)
(require 'oro-appearance)
(require 'oro-org)
(require 'oro-php)
(require 'oro-lsp)

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

(use-package company
  :diminish)
(add-hook 'after-init-hook 'global-company-mode)
(setq company-minimum-prefix-length 1) 
(setq company-idle-delay 0.1)

(use-package company-quickhelp)
; case sensitive completion 
(defvar company-dabbrev-ignore-case nil)
; keep case when completing words 
(defvar company-dabbrev-downcase nil)

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

(use-package flycheck-pos-tip)

(use-package flycheck 
  :diminish
  :preface 
  (global-flycheck-mode) 
  (flycheck-pos-tip-mode)
  :config 
  (setq flycheck-check-syntax-automatically '(save))) 

(use-package monky)

(use-package php-mode
  :mode
  (("[^.][^t][^p][^l]\\.php$" . php-mode))
  :config
  (add-hook 'php-mode-hook
	    '(lambda ()
               (setq indent-tabs-mode nil)
               (setq c-basic-offset 4)
               (setq php-template-compatibility nil)
               (php-enable-psr2-coding-style)

               ;(use-package company-php
               ;  :diminish)

               (setq-local company-dabbrev-minimum-length 1)
               (setq-local company-dabbrev-code-time-limit 2)
               (setq-local company-dabbrev-char-regexp "\\\`$sw")
               (setq-local company-dabbrev-code-everywhere t) 

               ;(setq-local company-transformers '(company-sort-by-occurrence))
               (setq-local company-transformers '(company-sort-by-backend-importance))
               (setq-local company-minimum-prefix-length 1)
               (setq-local company-idle-delay 0.1)

               (setq-local company-quickhelp-delay 0.1)

               (company-quickhelp-mode)
	       (company-mode t)

	       ;; Using :with and company-sort-by-backend-importance makes
	       ;; it so that company-lsp entries will always appear before
	       ;; company-dabbrev-code 
	       (set (make-local-variable 'company-backends)
                    '((company-lsp :with company-dabbrev-code)))
               
               (add-to-list 'load-path "~/.emacs.d/lsp-php")
               (require 'lsp-php)
               (lsp-php-enable) 

               ;(setq-local lsp-ui-flycheck-live-reporting nil)  
               ;(setq-local lsp-ui-sideline-show-flycheck nil)
               (setq-local flycheck-check-syntax-automatically '(save)) 

               ; [j]ump to definition 
               (local-set-key (kbd "C-c j") 'xref-find-definitions)
               ; [f]ind all references 
               (local-set-key (kbd "C-c f") 'xref-find-references)
               ; [r]ename 
               (local-set-key (kbd "C-c r") 'lsp-rename)
               ; [d]escribe thing at point 
               (local-set-key (kbd "C-c d") 'lsp-describe-thing-at-point) 
               ; show documentation [u]nder point 
               (local-set-key (kbd "C-c u") 'lsp-info-under-point) 
               ; [h]ighlight all relevant references to the symbol under point 
               (local-set-key (kbd "C-c h") 'lsp-symbol-highlight) 
                 
                 
               ;(ac-php-core-eldoc-setup)
               ;(make-local-variable 'company-backends)
               ;(add-to-list 'company-backends '((company-ac-php-backend company-dabbrev-code) company-capf))
               ;(set (make-local-variable 'company-backends) 
               ;     '((company-lsp company-dabbrev-code) company-capf company-files))
              
               ; [J]ump to a function definition (at point)  
               ;(local-set-key (kbd "C-c j") 'ac-php-find-symbol-at-point)
               ; Go [b]ack, after jumping 
               ;(local-set-key (kbd "C-c b") 'ac-php-location-stack-back)
               ; Go [f]orward 
               ;(local-set-key (kbd "C-c f") 'ac-php-location-stack-forward) 
               ; [S]how a function definition (at point) 
               ;(local-set-key (kbd "C-c s") 'ac-php-show-tip)
               ; [R]emake the tags (after a source has changed)  
               ;(local-set-key (kbd "C-c r") 'ac-php-remake-tags)
               ; Show project [i]nfo
               ;(local-set-key (kbd "C-c i") 'ac-php-show-cur-project-info)  

               (use-package phpcbf)
	       (custom-set-variables
		'(phpcbf-executable "/usr/bin/phpcbf")
		'(phpcbf-standard "PSR2"))
	       (local-set-key (kbd "C-c o") 'phpcbf)

               ; To prevent PHP mode from possibly setting 
               ; this variable, I want ethan-wspace to handle it
               ;(setq-local mode-require-final-newline nil)
               ;(setq-local require-final-newline nil) 

               ; ethan-wspace is an extension that handles whitespace much more carefully 
               ; I wanted to prevent trailing whitespaces from getting deleted when I edit a file 
               ; so that the diff was not ambiguous
               ;(delete-trailing-whitespace nil)
	       ;(use-package ethan-wspace
               ;  :config 
               ;  (ethan-wspace-mode 1)
               ;  (ethan-wspace-highlight-eol-mode 1)
               ;  (ethan-wspace-highlight-many-nls-eof-mode 1)
               ;  (ethan-wspace-highlight-no-nl-eof-mode 1)
                ; (ethan-wspace-highlight-tabs-mode 1)
                ; (setq-local ethan-wspace-errors nil))
))) 

;;; init.el ends here
