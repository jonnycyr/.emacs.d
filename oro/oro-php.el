;;;; oro-php.el --- PHP related functions I've created

;;;; Commentary:

;;;; Code:

;;;; PHP Settings
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
	       (custom-set-variables
		;; Composer.json detection after Projectile.
		'(lsp-php-workspace-root-detectors (quote (lsp-php-root-projectile lsp-php-root-composer-json lsp-php-root-vcs)))
	       )
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
	       (setq phpcbf-executable "~/.composer/vendor/squizlabs/php_codesniffer/scripts/phpcbf"
		     phpcbf-standard "PSR2")
	       ;(custom-set-variables
		;'(phpcbf-executable "~/.composer/vendor/bin/phpcbf")
		;'(phpcbf-standard "PSR2"))

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

;;;; PHP Related Custom Functions
(require 'php-mode)
(require 'cc-mode)

;;; Style is the same as the PSR2 style defined here:
;;; https://github.com/ejmr/php-mode/blob/cf1907be2ddca079146ef258ba95d525f17787e3/php-mode.el
;;; The only change is setting php-style-delete-trailing-whitespace to nil
(c-add-style
 "psr2-whitespace"
 '("php"
   (c-offsets-alist . ((statement-cont . +)))
   (c-indent-comments-syntactically-p . t)
   (fill-column . 78)
   (show-trailing-whitespace . t)
   (php-style-delete-trailing-whitespace . nil)))

(defun jonny-php-save-whitespace()
  "Prevents the deletion of any whitespace within a PHP file"
  (interactive)
  (php-set-style "psr2-whitespace")
  (setq-local delete-trailing-lines nil)
  (whitespace-mode -1)
  (flycheck-mode -1)
  (electric-indent-local-mode -1)
)

(provide 'oro-php)
;;; oro-php.el ends here
