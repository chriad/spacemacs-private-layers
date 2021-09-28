(defun bookmark+/bmkp-doc ()
  "Enable rainbow identifiers if the major mode is a prog mode."
  (interactive)
  (find-file (concat spacemacs-private-directory "bookmark+/local/bookmark-plus/bookmark+-doc.el"))
  (require 'linkd)
  (linkd-mode))
