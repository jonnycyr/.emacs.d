;;;; oro-org.el --- Base org settings

;;;; Commentary:

;;; Why is this part of Oro core?

;; Usually I talk about what I believe a text-editor should be
;; as an answer to this question, but to be quite honest -
;; this code could very well be within modules.  I placed this code
;; within core for the following reasons:
;; - org-mode comes with Emacs
;; - org-mode is awesome
;;
;; Org-mode is /really/ awesome.  People even think about switching to
;; Emacs /just/ to use org-mode.

;;; Why should I use org-mode?

;; Our brains can only keep track of so many things at once.  You can
;; be debugging code and keeping track of a stack within your head -
;; and then boom, you have your morning stand-up, you get back to your desk,
;; and you forget everything!  Keeping track of what you're thinking with notes
;; is helpful and it's extremely easy to do that with org-mode.  It's a note-taking
;; application that rivals everything else and the best part is, is that it's built
;; right into your text-editor.  You can take notes quickly and efficiently using
;; your own shortcuts and keybindings.

;;;; Code:
(provide 'oro-org)

(use-package org-pomodoro)

(use-package org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(use-package org-super-agenda)

;;; oro-org.el ends here
