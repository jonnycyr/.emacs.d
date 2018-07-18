;;; oro-php.el --- PHP related functions I've created

;;; Commentary:

;;; Code:
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
