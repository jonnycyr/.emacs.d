;;; jonny-org.el --- elisp functions that do org-related things

;;; Commentary:


;;; Code:
(defun jonny-create-project()
  "Asks for the project name, description, and url - then inserts an org entry based on that."
  (interactive)
  (let ((project-name (read-from-minibuffer "Enter the project name: "))
	(project-desc (read-from-minibuffer "Enter a small description: "))
	(project-url (read-from-minibuffer "Enter a project url: ")))
  (insert (format "* %s
%s\n
%s
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
		  ))))

(provide 'jonny-org)
;;; jonny-org.el ends here
