;;;; oro-completion.el --- Completion settings using company-mode

;;;; Commentary:
;;
;; This is part of Oro core because I believe that a text editor should offer
;; 

;;;; Code:

;;; Packages
(use-package company)
(use-package company-quickhelp)
(use-package company-statistics)

;;; General company settings
;; I leave setting company-transformers for modules. The default
;; setting, company-sort-by-occurence, is perfect for normal use.
;; In particular cases, I use company-sort-by-backend-importance.
;;
;; For example, in oro-php.el I have the following setting:
;; (company-lsp :with company-dabbrev-code)
;; This is so that company-lsp will always appear before
;; company-dabbrev-code. company-lsp handles variables, functions,
;; etc - and company-dabbrev-code handles all other strings
;; and things that company-lsp may miss.

; minimum prefix length for idle completion
(setq company-minimum-prefix-length 1)

; idle delay in seconds until completion starts automatically
(setq company-idle-delay 0.1)

; idle delay in seconds until tool tip shows
(setq company-tooltip-idle-delay 0.1)

;; company-dabbrev settings
(setq company-dabbrev-minimum-length 1)
(setq company-dabbrev-code-time-limit 2)

; offer completions in comments and strings
(setq company-dabbrev-code-everywhere t)

; case sensitive completion
(setq company-dabbrev-ignore-case nil)

; keep case when completing words
(setq company-dabbrev-downcase nil)



(setq company-quickhelp-delay 0.1)

(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'after-init-hook 'company-quickhelp-mode)
(add-hook 'after-init-hook 'company-statistics-mode)

(provide 'oro-completion)
;;; oro-completion.el ends here
