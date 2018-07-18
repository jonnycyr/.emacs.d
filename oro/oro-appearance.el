;;; oro-appearance.el --- summary

;;; Commentary:
;;; Code:


;;; * Font Settings

(set-frame-font "-*-Hack-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1")
(add-to-list 'default-frame-alist
             '(font . "-*-Hack-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1"))

(global-hl-line-mode +1)

(use-package monokai-theme)
(use-package color-theme-sanityinc-tomorrow)
;; (color-theme-sanityinc-tomorrow-day)
;; (color-theme-sanityinc-tomorrow-night)
;; (color-theme-sanityinc-tomorrow-blue)
;; (color-theme-sanityinc-tomorrow-bright)
(color-theme-sanityinc-tomorrow-eighties)
;; (load-theme 'monokai t)

(use-package powerline
  :init
  (powerline-default-theme))

(use-package diminish)

(use-package delight)

(use-package dashboard
  :init
  (setq dashboard-banner-logo-title "I use Emacs, which might be thought of as a thermonuclear word processor. - Neal Stephenson"
	dashboard-startup-banner "~/.emacs.d/oro2.jpeg"
        dashboard-items '((bookmarks . 5)
                          (agenda . 5)))
  :config
  (dashboard-setup-startup-hook))

(provide 'oro-appearance)
;;; oro-appearance.el ends here
