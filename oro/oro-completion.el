;;;; oro-completion.el --- Completion settings using company-mode

;;;; Commentary:

;;; Why is this part of Oro core?

;; I believe that a text editor should offer asynchronus completion -
;; this makes the main purpose of a text editor much easier to do.

;;; Why company-mode?

;; company-mode was designed from the very beginning to be easy to
;; create backends / frontends / whatever for it by having code that
;; is understandable and nice on the eyes.  If you want to learn more
;; about company (besides just looking at the configuration here),
;; I strongly suggest to look at the source code to get a feel for what
;; you can do.

;;;; Code:

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

(use-package company
  :init
  ;; minimum prefix length for idle completion
  (setq company-minimum-prefix-length 1)

  ;; idle delay in seconds until completion starts automatically
  (setq company-idle-delay 0.1)

  ;; idle delay in seconds until tool tip shows
  (setq company-tooltip-idle-delay 0.1)

  ;; the minimum length for company-dabbrev candidates to appear
  (setq company-dabbrev-minimum-length 1)

  ;; company-dabbrev can spend at most 2 seconds looking for matches
  (setq company-dabbrev-code-time-limit 2)

  ;; offer completions in comments and strings
  (setq company-dabbrev-code-everywhere t)

  ;; case sensitive completion
  (setq company-dabbrev-ignore-case nil)

  ;; keep case when completing words
  (setq company-dabbrev-downcase nil)

  :config
  (global-company-mode))

(use-package company-quickhelp
  :init
  (setq company-quickhelp-delay 0.1)
  :config
  (company-quickhelp-mode))

(use-package company-statistics
  :config
  (company-statistics-mode))

(provide 'oro-completion)
;;; oro-completion.el ends here
