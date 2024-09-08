;(require 'bookmark+-mac)
;(require 'bookmark+)
;;;;
;;; helper functions

;;; Helpful bookmarks should be named
;;; bmkp-tags-list    *helpful variable*
;;; not
;;; *helpful ...* ...   --- Unknown location ---

(defun chriad/bookmark-set-tag-prompt ()
    "Prompt for tag"
  (interactive)
  (let ((bmkp-prompt-for-tags-flag t))
    (call-interactively 'bookmark-set)))

(defun chriad/bmkp-list-types ()
  (interactive)
  ;; TODO print in temporary, fileless buffer
  (pp (bmkp-types-alist)))



(defun count-bookmarks () (seq-length bookmark-alist))


;;; bookmarked functions
(defun chriad/find-data-directory ()
  (find-file-other-window data-directory))

(defun chriad/bmkp-help ()
  (message "Getting Bookmark+ doc from file commentary...")
  (finder-commentary "bookmark+-doc")
  (when (condition-case nil (require 'linkd nil t) (error nil)) (linkd-mode 1))
  (when (condition-case nil (require 'fit-frame nil t) (error nil))
    (fit-frame)))

;;; register existing bookmarks with bookmark+
;; now-bookmark

;(defmacro chriad/bmkp-register-new-simple-type-bookmark (name doc-string handler-function)
; "A simple type is one that can simply be checked by its handler function"
; (let* ((command (intern (format "bmkp-%s-bookmark-alist-only" name)))
;        (command2 (intern (format "bmkp-bmenu-show-only-%s-bookmarks" name))))
;    `(progn
;     (defun ,command ()
;       ,doc-string
;       (bookmark-maybe-load-default-file)
;       (bmkp-remove-if-not
;        (lambda () (eq (bookmark-get-handler bookmark) ,handler-function))
;        bookmark-alist)))
;    (bmkp-define-history-variables)
;    `(bmkp-define-show-only-command ,name ,doc-string ,command)
;    `(define-key bookmark-bmenu-mode-map [remap bmkp-bmenu-show-only-desktop-bookmarks]
;                 ',command2)))

;; register new bookmark with bookmark+, i.e. add jump command and bmenu filter and key in use map
;(chriad/bmkp-register-new-simple-type-bookmark "nov" "A bookmark for epub" 'nov-bookmark-jump-handler)



;; (defun nov-bookmark-p (bookmark)
;;   (eq (bookmark-get-handler bookmark) 'nov-bookmark-jump-handler))

;; (defun bmkp-nov-bookmark-alist-only ()
;;   (bookmark-maybe-load-default-file)
;;   (bmkp-remove-if-not #'nov-bookmark-p bookmark-alist))

;; helpful-bookmark
;; TODO make record function aware of helpful sections
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

;(bmkp-define-show-only-command "helm-ff-session" "bookmark to helm find file session" bmkp-helm-ff-session-bookmark-alist-only)
;(bmkp-define-show-only-command "helpful-bookmark" "bookmark to helm find file session" bmkp-helpful-bookmark-alist-only)


;(define-key bookmark-bmenu-mode-map [remap bmkp-bmenu-show-only-desktop-bookmarks]
;            'bmkp-bmenu-show-only-helpful-bookmark-bookmarks)

;; (defun magit-bookmark-p (bookmark)
;;   (eq (bookmark-get-handler bookmark) 'magit--handle-bookmark))

;; (defun bmkp-magit-bookmark-alist-only ()
;;   (bookmark-maybe-load-default-file)
;;   (bmkp-remove-if-not #'magit-bookmark-p bookmark-alist))



;;; define your own bookmarks
;; TODO create org-fc bookmark type that will review a bookmarked card (i.e. headline) when triggered. The jump handler should run org-fc. Maybe also intgrate bookmark+ tags with card filtering in org-fc
(defun org-fc-bookmark-p (bookmark)
  (ignore))

;; bookmark to a library known to emacs. Path can change when updating packages, so no file path.
;; TODO use pkg-info-library-source pkg
;; TODO use epl.el emacs package library
;; TODO use maybe package-user-dir
;; use locate-library

;; package-alist


;; ((geiser-guile #s(package-desc geiser-guile
;;                                (0 28 2)
;;                                "Guile and Geiser talk to each other"
;;                                ((emacs
;;                                  (26 1))
;;                                 (transient
;;                                  (0 3))
;;                                 (geiser
;;                                  (0 28 1)))
;;                                nil nil "/gnu/store/kkmd2l7i8jakmq31yc7pgnd27d0xpxf3-emacs-geiser-guile-0.28.2/share/emacs/site-lisp/geiser-guile-0.28.2"
;;                                ((:url . "https://gitlab.com/emacs-geiser/guile")
;;                                 (:keywords "languages" "guile" "scheme" "geiser")
;;                                 (:maintainer "Jose Antonio Ortega Ruiz" . "(jao@gnu.org)")
;;                                 (:authors
;;                                  ("Jose Antonio Ortega Ruiz" . "(jao@gnu.org)")))
;;                                nil))

(defun lib-bookmark-jump (bookmark)
  "Create and switch to helpful bookmark BOOKMARK."
  (let* ((pkg (bookmark-prop-get bookmark 'pkg))
         (position (bookmark-prop-get bookmark 'position))
         (oldpath (bookmark-prop-get bookmark 'libpath))
         (newpath  (find-library pkg)))
    ;; check if package has been updated since last visit
    ;; add new path to list 'revisions to track change
    ;; bookmark-current-bookmark set-prop?
    (unless (equal oldpath newpath) (message "Package update detected"))
    (find-file newpath)
    (goto-char position)))


;; (defun lib-bookmark-jump (bookmark)
;;   "Create and switch to helpful bookmark BOOKMARK."
;;   (let ((pkg (bookmark-prop-get bookmark 'pkg)))
;;     (find-file (find-library-name pkg))))


;; A library name is the filename of an Emacs Lisp library located in a directory under load-path
(defun lib-bookmark-make-record ()
  ;; (require 'package-lint)
  ;; TODO check (package-lint--get-package-prefix)=nil. Then dispatch to normal bookmark-default-record
  ;; TODO difference between point and position?
  ;; TODO if nil assume builtin?
  ;; epl-find-built-in-package
  ;; epl-find-installed-package
  ;; `epl-built-in-packages', `epl-installed-packages', `
  ;; find-library also finds non .el files in packages unlike locate-library
  ;; package-vc-p: is vc controlled, then bookmark revision
  ;; TODO: missnamed buffers demo.org<org-fc-20...>
  (if (find-library (file-name-nondirectory (buffer-file-name)))
  `(,@(bookmark-make-record-default t nil nil) ;; no-file context=yes point=yes
    (pkg       . ,(file-name-nondirectory (buffer-file-name)))
    (libpath   . ,(buffer-file-name))
    (handler   . lib-bookmark-jump))
  `(,@(bookmark-make-record-default))))

;; (defun el-pkg-p ()
;;   (require 'package-lint)
;;   (if (package-lint--get-package-prefix) t nil))

;; TODO modify such that all files on load path will have this
(add-hook 'emacs-lisp-mode-hook #'(lambda () (setq-local bookmark-make-record-function #'lib-bookmark-make-record)))




;; buffer-substring-no-properties returns string, but I want list
(defun bmkp-make-lambda-bookmark-from-region (&optional msg-p) ; Bound globally to `C-x x c F'.
  "Create a bookmark that invokes FUNCTION when \"jumped\" to.
You are prompted for the bookmark name and the name of the function.
But with a prefix arg the last keyboard macro defined is used instead
of prompting you for a function.

Returns the new bookmark (internal record).

Non-interactively, non-nil optional arg MSG-P means display a status
message."
  (mark-sexp)
  (setq bookmark-name (bmkp-completing-read-lax "> "))
  (bookmark-store bookmark-name `(,@(bookmark-make-record-default 'NO-FILE 'NO-CONTEXT 0 nil 'NO-REGION)
                                  (function . (lambda () ,(buffer-substring-no-properties (region-beginning) (region-end))))
                                  (handler  . bmkp-jump-function))
                  nil nil (not msg-p))
  (let ((new  (bmkp-bookmark-record-from-name bookmark-name 'NOERROR)))
    (unless (memq new bmkp-latest-bookmark-alist)
      (setq bmkp-latest-bookmark-alist  (cons new bmkp-latest-bookmark-alist)))
    (bookmark-bmenu-surreptitiously-rebuild-list (not msg-p)) new))

;; eval (bmkp-make-lambda-bookmark-from-region "test") on a region which is a legal function body form

(message "test")

;; TODO transient defachievment -> one bookmark of each known type


