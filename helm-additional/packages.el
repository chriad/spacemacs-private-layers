;;; packages.el --- helm-additional layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2021 Sylvain Benner & Contributors
;;
;; Author: chriad <chriad@folio>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `helm-additional-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `helm-additional/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `helm-additional/pre-init-PACKAGE' and/or
;;   `helm-additional/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst helm-additional-packages
  '(
    helm-apt
    helm-unicode
    ;;helm-github-stars
    ;;helm-slime
    (helm-emmet :toggle (configuration-layer/layer-used-p 'html))
    helm-firefox
    helm-file-preview
    ;; helm-describe-modes
    ;; helm-file-preview
    ;; helm-bbdb
    helm-atoms
    ;; helm-bibtex
    ;; helm-bibtexkey
    ;; helm-rg
    ;; helm-recoll
    ;;helm-emms
    ;;helm-system-packages
    ;;helm-sly
    (helm-fuzzy-find :excluded t)
    ;; helm
    )
  )


(defun helm-additional/init-helm-emmet ()
  (use-package helm-emmet
    :defer t
    :init
    (spacemacs/set-leader-keys-for-major-mode 'sgml-mode
      "m" 'helm-emmet)))

(defun helm-additional/init-helm-firefox ()
  (use-package helm-firefox
    :defer t
    ))

(defun helm-additional/init-helm-apt ()
  (use-package helm-apt
    :defer t
    ))
(defun helm-additional/init-helm-unicode ()
  (use-package helm-unicode
    :defer t
    ))



;; (defun helm-additional/init-helm-bibtex ()
;;   (use-package helm-bibtex
;;     :defer t
;;     ))

(defun helm-additional/init-helm-atoms ()
  (use-package helm-atoms
    :defer t
    ))

(defun helm-additional/init-helm-file-preview ()
  (use-package helm-file-preview
    :defer t))

;; (defun helm-additional/init-helm-rg ()
;;   (use-package helm-rg
;;     :defer t
;;     ;; :config
;;     ;; Add actions for inserting org file link from selected match
;; ; https://notes.alexkehayias.com/org-roam/
;;   ;; (defun insert-org-mode-link-from-helm-result (candidate)
;;   ;;   (interactive)
;;   ;;   (with-helm-current-buffer
;;   ;;     (insert (format "[[file:%s][%s]]"
;;   ;;                     (plist-get candidate :file)
;;   ;;                     ;; Extract the title from the file name
;;   ;;                     (subst-char-in-string
;;   ;;                      ?_ ?\s
;;   ;;                      (first
;;   ;;                       (split-string
;;   ;;                        (first
;;   ;;                         (last
;;   ;;                          (split-string (plist-get candidate :file) "\\-")))
;;   ;;                        "\\.")))))))

;;   ;; (helm-add-action-to-source "Insert org-mode link"
;;   ;;                            'insert-org-mode-link-from-helm-result
;;   ;;                            helm-rg-process-source)

;;     ))

;; (helm-recoll-create-source "home" "~/.recoll")

;; (defun helm-additional/pre-init-helm ()
;;   (spacemacs|use-package-add-hook helm
;;     :post-config
;;     (helm-adaptive-mode 1)
;;     ))
