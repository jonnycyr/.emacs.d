;;; oro-org.el --- elisp functions that do org-related things


;;; Commentary:


;;; Code:
(require 'org)

(defun jonny-org-create-project()
  "Asks for the project name, description, and url - then inserts an org entry based on that."
  (interactive)
  (let ((project-name (read-from-minibuffer "Enter the project name: "))
	(project-desc (read-from-minibuffer "Enter a small description: "))
	(project-url (read-from-minibuffer "Enter a project url: "))
	(project-tag (read-from-minibuffer "Enter a tag: ")))
  (insert (format "* TODO %s
*description*: %s\n
*url*: %s\n
** tasks
** testing
*** setting up test environment
** conversations
** questions
** notes
/each heading is the date in month day day of the week year ex: Mon July 5th, 2000/
** files
** links
"
		  project-name
		  project-desc
		  project-url
		  ))
  (search-backward (format "* TODO %s" project-name))
  (org-set-tags-to project-tag)
  ))

;;; Using the themes found here: https://github.com/fniessen/org-html-themes
(defun jonny-org-export-html()
  (interactive)
  (let ((org-files (directory-files org-directory))))
  (while org-files
    (find-file (concat "~/Dropbox/org/" (car org-files)))
    (set-buffer (concat "~/Dropbox/org/" (car org-files)))
    (org-html-export-to-html (concat "~/Dropbox/org/" (car org-files)))
  ))

(provide 'oro-org)
;;; oro-org.el ends here
