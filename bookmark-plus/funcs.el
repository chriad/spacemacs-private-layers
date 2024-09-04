;;;;   ;; TODO transient defachievment -> one bookmark of each known type
;;; helper functions
(defun chriad/bmkp-list-types ()
  (interactive)
  ;; TODO print in temporary, fileless buffer
  (pp (bmkp-types-alist)))


(defun chriad/bmkp-help ()
  (interactive)
  (message "Getting Bookmark+ doc from file commentary...")
  (finder-commentary "bookmark+-doc")
  (when (condition-case nil (require 'linkd nil t) (error nil)) (linkd-mode 1))
  (when (condition-case nil (require 'fit-frame nil t) (error nil))
    (fit-frame)))

(defun count-bookmarks () (seq-length bookmark-alist))

(defun helm-documentation-f ()
  (call-interactively 'helm-documentation))


;;; register existing bookmarks with bookmark+
;; now-bookmark

;; TODO probably a macro
(defun chriad/bmkp-register-new-simple-type-bookmark (name filterf)
  "(chriad/bmkp-register-new-simple-type-bookmark \"helm-ff-session-bookmark\" helm-ff-bookmark-jump)
Return the two functions and eval (bmkp-define-history-variables)"
  (ignore))

(defun nov-bookmark-p (bookmark)
  (eq (bookmark-get-handler bookmark) 'nov-bookmark-jump-handler))

(defun bmkp-nov-bookmark-alist-only ()
  (bookmark-maybe-load-default-file)
  (bmkp-remove-if-not #'nov-bookmark-p bookmark-alist))

;; helpful-bookmark
(defun helpful-bookmark-p (bookmark)
  (eq (bookmark-get-handler bookmark) 'helpful--bookmark-jump))

(defun bmkp-helpful-bookmark-alist-only ()
  (bookmark-maybe-load-default-file)
  (bmkp-remove-if-not #'helpful-bookmark-p bookmark-alist))


;; helm-ff-session-bookmark
(defun helm-ff-session-bookmark-p (bookmark)
  (eq (bookmark-get-handler bookmark) 'helm-ff-bookmark-jump))

(defun bmkp-helm-ff-session-bookmark-alist-only ()
  (bookmark-maybe-load-default-file)
  (bmkp-remove-if-not #'helm-ff-session-bookmark-p bookmark-alist))


;; (defun magit-bookmark-p (bookmark)
;;   (eq (bookmark-get-handler bookmark) 'magit--handle-bookmark))

;; (defun bmkp-magit-bookmark-alist-only ()
;;   (bookmark-maybe-load-default-file)
;;   (bmkp-remove-if-not #'magit-bookmark-p bookmark-alist))



;;; define your own bookmarks
;; TODO create org-fc bookmark type that will review a bookmarked card (i.e. headline) when triggered. The jump handler should run org-fc. Maybe also intgrate bookmark+ tags with card filtering in org-fc
(defun org-fc-bookmark-p (bookmark)
  (ignore))

;; 
(defun lib-bookmark-make-record ()
  (require 'package-lint)
  ;; TODO check (package-lint--get-package-prefix)=nil. Then dispatch to normal bookmark-default-record
  ;; TODO difference between point and position?
  ;; TODO if nil assume builtin?
  `(,@(bookmark-make-record-default t nil nil) ;; no-file context=yes point=yes
    (pkg       . ,(package-lint--get-package-prefix))
    (libpath   . ,(buffer-file-name))
    (handler   . lib-bookmark-jump)))

(defun el-pkg-p ()
  (require 'package-lint)
  (if (package-lint--get-package-prefix) t nil))

(add-hook 'emacs-lisp-mode-hook #'(lambda () (if (el-pkg-p)
                                            (setq-local bookmark-make-record-function #'lib-bookmark-make-record))))

;; bookmark to a library known to emacs. Path can change when updating packages, so no file path.
(defun lib-bookmark-jump (bookmark)
  "Create and switch to helpful bookmark BOOKMARK."
  (let* ((pkg (bookmark-prop-get bookmark 'pkg))
         (position (bookmark-prop-get bookmark 'position))
         (oldpath (bookmark-prop-get bookmark 'libpath))
         (newpath  (find-library-name pkg)))
    ;; check if package has been updated since last visit
    ;; add new path to list 'revisions to track change
    (unless (equal oldpath newpath) (message "Package update detected"))
    (find-file newpath)
    (goto-char position)))


;; (defun lib-bookmark-jump (bookmark)
;;   "Create and switch to helpful bookmark BOOKMARK."
;;   (let ((pkg (bookmark-prop-get bookmark 'pkg)))
;;     (find-file (find-library-name pkg))))



