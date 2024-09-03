;;   ;; TODO transient defachievment -> one bookmark of each known type

(defun chriad/bmkp-list-types ()
  (interactive)
  ;; TODO print in temporary, fileless buffer
  (pp (bmkp-types-alist)))

(defun helm-documentation-f ()
  (call-interactively 'helm-documentation))

;; register nov bookmarks

(defun bmkp-nov-bookmark-alist-only ()
  (bookmark-maybe-load-default-file)
  (bmkp-remove-if-not #'nov-bookmark-p bookmark-alist))

(defun nov-bookmark-p (bookmark)
  (eq (bookmark-get-handler bookmark) 'nov-bookmark-jump-handler))

(defun bmkp-helpful-bookmark-alist-only ()
  (bookmark-maybe-load-default-file)
  (bmkp-remove-if-not #'helpful-bookmark-p bookmark-alist))

(defun helpful-bookmark-p (bookmark)
  (eq (bookmark-get-handler bookmark) 'helpful--bookmark-jump))

;; (defun bmkp-helm-ff-session-bookmark-alist-only ()
;;   (bookmark-maybe-load-default-file)
;;   (bmkp-remove-if-not #'helm-ff-session-bookmark-p bookmark-alist))

;; (defun helm-ff-session-bookmark-p (bookmark)
;;   (eq (bookmark-get-handler bookmark) 'helm-ff-bookmark-jump))

;; (defun bmkp-magit-bookmark-alist-only ()
;;   (bookmark-maybe-load-default-file)
;;   (bmkp-remove-if-not #'magit-bookmark-p bookmark-alist))

;; (defun magit-bookmark-p (bookmark)
;;   (eq (bookmark-get-handler bookmark) 'magit--handle-bookmark))

;; TODO create org-fc bookmark type that will review a bookmarked card (i.e. headline) when triggered. The jump handler should run org-fc. Maybe also intgrate bookmark+ tags with card filtering in org-fc
(defun org-fc-bookmark-p (bookmark)
  (ignore))

;; TODO do I have to recompile bookmark+-mac.el each time? -> package-recompile RET bookmark+

;; This provides the `defvar's for all Bookmark+ history variables.
;; Use this again, after you define any of your own filter functions
;; `bmkp-*-alist-only', for new kinds of bookmarks.
;;
;; (bmkp-define-history-variables)   ; Macro defined in `bookmark+-mac.el'.


;; bookmark to a library known to emacs. Path can change when updating packages, so no file path.
(defun lib-bookmark-jump (bookmark)
  "Create and switch to helpful bookmark BOOKMARK."
  (let ((pkg (bookmark-prop-get bookmark 'pkg))
        (position (bookmark-prop-get bookmark 'position)))
    (find-file (find-library-name pkg))
    (goto-char position)))


;; (defun lib-bookmark-jump (bookmark)
;;   "Create and switch to helpful bookmark BOOKMARK."
;;   (let ((pkg (bookmark-prop-get bookmark 'pkg)))
;;     (find-file (find-library-name pkg))))

(defun lib-bookmark-make-record ()
  ;; TODO check (package-lint--get-package-prefix)=nil. Then dispatch to normal bookmark-default-record
  ;; TODO difference between point and position?
  `(,@(bookmark-make-record-default t nil nil) ;; no-file context=yes point=yes
    (pkg . ,(package-lint--get-package-prefix))
    (handler     . lib-bookmark-jump)))



(add-hook 'emacs-lisp-mode-hook #'(lambda () (setq-local bookmark-make-record-function #'lib-bookmark-make-record)))


(defun chriad/bmkp-help ()
  (interactive)
  (message "Getting Bookmark+ doc from file commentary...")
  (finder-commentary "bookmark+-doc")
  (when (condition-case nil (require 'linkd nil t) (error nil)) (linkd-mode 1))
  (when (condition-case nil (require 'fit-frame nil t) (error nil))
    (fit-frame)))
