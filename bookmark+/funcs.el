(defun bookmark+/bmkp-doc ()
  "Enable rainbow identifiers if the major mode is a prog mode."
  (interactive)
  (find-file (concat spacemacs-private-directory "bookmark+/local/bookmark-plus/bookmark+-doc.el"))
  (find-file (concat spacemacs-private-directory "bookmark+/local/bookmark-plus/bookmark+-doc.el"))
  (directory-files (concat user-emacs-directory "/elpa/" emacs-version "/develop/") t (concat "\\(?:bookmark\\+-\\(?:[[:digit:]]\\|\\.\\)*/\\)" "bookmark+-doc.el")))
  (find-file (concat user-emacs-directory  emacs-version "/develop/" "bookmark+\" (string-match-p) "/bookmark+-doc.el"))
  (require 'linkd)
  (linkd-mode))
