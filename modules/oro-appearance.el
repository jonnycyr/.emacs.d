;;; oro-appearance.el --- summary

;;; Commentary:
;;; Code:


;;; * Font Settings

(set-frame-font "-*-Hack-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1")
(add-to-list 'default-frame-alist
             '(font . "-*-Hack-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1"))

(global-hl-line-mode +1)

;;; * Theme Settings
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

(use-package powerline-evil
  :init
  (powerline-evil-vim-color-theme))

;;; [[https://github.com/myrjola/diminish.el][diminish]]
;;; ** TODO remove diminish and just use delight
(use-package diminish)
;;; [[https://elpa.gnu.org/packages/delight.html][delight]]
(use-package delight)

;; dashboard-banner-logo-title "I use Emacs, which might be thought of as a thermonuclear word processor. - Neal Stephenson"

(use-package dashboard
  :init
  (setq dashboard-banner-logo-title "Whatever you lose, you'll find it again, but what you throw away you'll never get it back. - Himura Kenshin"
	dashboard-startup-banner 'logo
        dashboard-items '((bookmarks . 5)
                          (agenda . 5)))
  ;; (setq dashboard-startup-banner "~/.emacs.d/oro/rurouni-kenshin-oro.jpg")
  :config
  (dashboard-setup-startup-hook))

;; Smooth-scrolling, minimap and distraction-free mode (inspired by the sublime editor)
;; https://github.com/zk-phi/sublimity
(use-package sublimity
  :config
  (require 'sublimity-scroll)
  (require 'sublimity-attractive)
  (setq sublimity-attractive-centering-width nil
	sublimity-scroll-weight 5
	sublimity-scroll-drift-length 10) 
  (sublimity-mode 1))

(provide 'oro-appearance)
;;; oro-appearance.el ends here
