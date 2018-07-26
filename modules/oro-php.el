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
               ;; TODO Add in support for company-gtags/capf
	       (use-package company-php)
	       (ac-php-core-eldoc-setup)
	       (setq-local company-transformers '(company-sort-by-backend-importance))
	       (set (make-local-variable 'company-backends)
		    '((company-ac-php-backend :with company-dabbrev-code)))
                    ;; '((company-lsp :with company-dabbrev-code)))

	       ;;; LSP (Language Server Protocol) Settings:
               ;; (add-to-list 'load-path "~/.emacs.d/lsp-php")
               ;; (require 'lsp-php)
	       ;; (custom-set-variables
	        	;; Composer.json detection after Projectile.
	       ;; 	'(lsp-php-workspace-root-detectors (quote (lsp-php-root-projectile lsp-php-root-composer-json lsp-php-root-vcs)))
	       ;; )
               ;; (lsp-php-enable)

	       ;;; Flycheck Settings:
	       (defvar-local flycheck-checker 'php-phpcs)
               (setq-local flycheck-check-syntax-automatically '(save))

	       ;;; Key Bindings:
	       ;; (dumb-jump-mode)
	       (ggtags-mode 1)
	       ;; [J]ump to a function definition (at point)
               ;; (local-set-key (kbd "C-c j") 'ac-php-find-symbol-at-point)
	       ;; (local-set-key (kbd "C-c j") 'dumb-jump-go)
	       (local-set-key (kbd "C-c j") 'ggtags-find-definition)

	       ;; Find [r]eferences (at point)
	       (local-set-key (kbd "C-c r") 'ggtags-find-reference)

               ;; Go [b]ack, after jumping
	       ;; (local-set-key (kbd "C-c b") 'dumb-jump-back)
               ;; (local-set-key (kbd "C-c b") 'ac-php-location-stack-back)
	       (local-set-key (kbd "C-c b") 'ggtags-prev-mark)

               ;; Go [f]orward
               ;; (local-set-key (kbd "C-c f") 'ac-php-location-stack-forward)
	       (local-set-key (kbd "C-c f") 'ggtags-next-mark)

               ;; [S]how a function definition (at point)
               (local-set-key (kbd "C-c s") 'ac-php-show-tip)
	       ;; (local-set-key (kbd "C-c q") 'dumb-jump-quick-look)

               ;; Re[m]ake the tags (after a source has changed)
               (local-set-key (kbd "C-c m") 'ac-php-remake-tags)

               ;; Show [p]roject info
               (local-set-key (kbd "C-c p") 'ac-php-show-cur-project-info)

	       ;; Bring up [i]menu
	       (local-set-key (kbd "C-c i") 'helm-imenu))))


	       ;; (require 'bind-key)
	       ;; (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
               ;; (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)

               ;; ;; [j]ump to definition
               ;; (bind-key "C-c j" 'lsp-ui-peek-find-definitions)
	       ;; ;; jump [f]oward
	       ;; (bind-key "C-c f" 'lsp-ui-peek-jump-forward)
	       ;; ;; jump [b]ack
	       ;; (bind-key "C-c b" 'lsp-ui-peek-jump-backward)
               ;; ;; find all [r]eferences
               ;; (bind-key "C-c r" 'lsp-ui-peek-find-references)
               ;; ;; [r]ename
               ;; (bind-key "C-c r" 'lsp-rename)
               ;; ;; [d]escribe thing at point
               ;; (bind-key "C-c d" 'lsp-describe-thing-at-point)
               ;; ;; show documentation [u]nder point
               ;; (bind-key "C-c u" 'lsp-info-under-point)
               ;; ;; [h]ighlight all relevant references to the symbol under point
               ;; (bind-key "C-c h" 'lsp-symbol-highlight))))


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
