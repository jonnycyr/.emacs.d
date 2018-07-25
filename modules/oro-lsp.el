;;; oro-lsp.el --- Language Server Protocol

;;; Commentary:

;;; Code:
(use-package lsp-mode
  :config
  (setq lsp-response-timeout 25))

(use-package lsp-ui
   :after lsp-mode
   :config
   (add-hook 'lsp-mode-hook 'lsp-ui-mode))

(use-package company-lsp
  :after (lsp-mode company))

;; (require 'lsp-imenu)
;; (add-hook 'lsp-after-open-hook 'lsp-enable-imenu)

;; (require 'lsp-ui-sideline)
;; (add-hook 'lsp-after-open-hook 'lsp-ui-sideline-enable)

;; (require 'lsp-ui-peek)
;; (add-hook 'lsp-after-open-hook 'lsp-ui-peek-enable)

(require 'lsp-ui-doc)

;; Disable all other features of lsp-ui-doc
(setq lsp-ui-doc-enable nil
      lsp-ui-peek-enable nil
      lsp-ui-sideline-enable nil
      lsp-ui-imenu-enable nil
      lsp-ui-flycheck-enable nil)

(setq lsp-ui-doc-position 'at-point
      lsp-ui-sideline-show-flycheck nil)

(provide 'oro-lsp)
;;; oro-lsp.el ends here
