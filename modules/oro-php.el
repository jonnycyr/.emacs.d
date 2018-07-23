;;;; oro-php.el --- PHP settings and php related functions I've created

;;;; Commentary:

;;; Why do you use setq-local?

;; Using setq-local makes it so that Emacs can act differently depending
;; on the type of file in the buffer.  For example, with setq-local I make
;; it so that PHP candidates for company only appear within PHP-mode buffers.

;;;; Code:

(use-package php-mode
  :mode
  (("[^.][^t][^p][^l]\\.php$" . php-mode))
  :config
  (add-hook 'php-mode-hook
	    '(lambda ()
	       ;;; PHP-mode settings:
               (setq indent-tabs-mode nil
		     c-basic-offset 4
                     php-template-compatibility nil)

               (php-enable-psr2-coding-style)

	       ;;; PHP_CodeSniffer settings:
               (use-package phpcbf
		 :init
		 (setq phpcbf-executable "~/.composer/vendor/squizlabs/php_codesniffer/scripts/phpcbf"
		       phpcbf-standard "PSR2"))

	       ;;; Company-mode settings:
	       ;; Using :with and company-sort-by-backend-importance makes
	       ;; it so that company-lsp entries will always appear before
	       ;; company-dabbrev-code.
	       (setq-local company-transformers '(company-sort-by-backend-importance))
	       (set (make-local-variable 'company-backends)
                    '((company-lsp :with company-dabbrev-code)))

	       ;;; LSP (Language Server Protocol) Settings:
               (add-to-list 'load-path "~/.emacs.d/lsp-php")
               (require 'lsp-php)
	       (custom-set-variables
		;; Composer.json detection after Projectile.
		'(lsp-php-workspace-root-detectors (quote (lsp-php-root-projectile lsp-php-root-composer-json lsp-php-root-vcs)))
	       )
               (lsp-php-enable)

	       ;;; Flycheck Settings:
               (setq-local flycheck-check-syntax-automatically '(save))

	       ;;; Key Bindings:
               ;; [j]ump to definition
               (bind-key "C-c j" 'xref-find-definitions)
	       ;; jump [b]ack
	       (bind-key "C-c b" 'xref-pop-marker-stack)
               ;; [f]ind all references
               (bind-key "C-c f" 'xref-find-references)
               ;; [r]ename
               (bind-key "C-c r" 'lsp-rename)
               ;; [d]escribe thing at point
               (bind-key "C-c d" 'lsp-describe-thing-at-point)
               ;; show documentation [u]nder point
               (bind-key "C-c u" 'lsp-info-under-point)
               ;; [h]ighlight all relevant references to the symbol under point
               (bind-key "C-c h" 'lsp-symbol-highlight))))


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

(defun oro-php-save-whitespace()
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
