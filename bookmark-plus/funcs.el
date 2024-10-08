;(require 'bookmark+-mac)
;(require 'bookmark+)
;;;;
;;; helper functions

;;; Helpful bookmarks should be named
;;; bmkp-tags-list    *helpful variable*
;;; not
;;; *helpful ...* ...   --- Unknown location ---

;; TODO
;; (eval-when-compile (require 'bookmark+-bmu))
;; (eval-when-compile (require 'bookmark+-1))

(defun chriad/bmkp-set-tag-prompt ()
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
;; package-recompile
;; (defmacro chriad/bmkp-register-new-simple-type-bookmark (name doc-string handler-function)
;;   "A simple type is one that can simply be checked by its handler function"
;;   (let  ((alist-only-cmd (intern (format "bmkp-%s-bookmark-alist-only" name)))
;;          (bmenu-show-only-cmd (intern (format "bmkp-bmenu-show-only-%s-bookmarks" name))))
;;      `(progn
;;        (defun ,alist-only-cmd ()
;;          ,doc-string
;;          (bookmark-maybe-load-default-file)
;;          (bmkp-remove-if-not
;;           (lambda () (eq (bookmark-get-handler bookmark) ',handler-function))
;;           bookmark-alist)))
;;      (bmkp-define-history-variables)
;;      (bmkp-define-show-only-command name ,doc-string ,alist-only-cmd)
;;      ;; `(define-key bookmark-bmenu-mode-map key ',bmenu-show-only-cmd)
;;      ))

;; ;; register new bookmark with bookmark+, i.e. add jump command and bmenu filter and key in use map
;; (chriad/bmkp-register-new-simple-type-bookmark "nov" "A bookmark for epub" 'nov-bookmark-jump-handler)



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

;; TODO use after-set-hook and bookmark-current-bookmark to inspect and ev. change libpath
(defun lib-bookmark-jump (bookmark)
  "Create and switch to helpful bookmark BOOKMARK."
  (let* ((pkg (bookmark-prop-get bookmark 'pkg))
         (position (bookmark-prop-get bookmark 'position))
         (oldpath (bookmark-prop-get bookmark 'libpath))
         (newpath  (find-library-name pkg)))
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
  ;; TODO autoupdate libpath like visits count, bmkp-properties-to-keep
  ;; TODO this could be an autofile bookmark type since file name is const only dir name not! check if bmkp-autofile-p for this but I think not; no autofile does not record region!!!
  ;; TODO if libpatch changes: bmkp=replace-existing-bookmakr
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
    (handler   . lib-bookmark-jump))))

;; (defun el-pkg-p ()
;;   (require 'package-lint)
;;   (if (package-lint--get-package-prefix) t nil))

;; TODO modify such that all files on load path will have this
(add-hook 'emacs-lisp-mode-hook '(lambda () (setq-local bookmark-make-record-function #'lib-bookmark-make-record)))




;; buffer-substring-no-properties returns string, but I want list
(defun chriad/bmkp-make-lambda-bookmark-from-sexp (&optional msg-p) ; Bound globally to `C-x x c F'.
  "Wrap the sexp before point (or the region) into a lambda expression as its body and create a function bookmark"
  ;; (mark-sexp)
  (interactive)
  (setq bookmark-name (bmkp-completing-read-lax "> "))
  (bookmark-store bookmark-name `(,@(bookmark-make-record-default 'NO-FILE 'NO-CONTEXT 0 nil 'NO-REGION)
                                  (function . (lambda () ,(pp-last-sexp)))
                                  (handler  . bmkp-jump-function))
                  nil nil (not msg-p))
  (let ((new  (bmkp-bookmark-record-from-name bookmark-name 'NOERROR)))
    (unless (memq new bmkp-latest-bookmark-alist)
      (setq bmkp-latest-bookmark-alist  (cons new bmkp-latest-bookmark-alist)))
    (bookmark-bmenu-surreptitiously-rebuild-list (not msg-p)) new))

;; TODO transient defachievment -> one bookmark of each known type


