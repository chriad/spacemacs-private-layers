;;; packages.el --- bookmark-plus layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2024 Sylvain Benner & Contributors
;;
;; Author: chriad <chriad@workstation>
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
;; added to `bookmark-plus-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `bookmark-plus/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `bookmark-plus/pre-init-PACKAGE' and/or
;;   `bookmark-plus/post-init-PACKAGE' to customize the package as it is loaded.

;; `apropos'
;; `apropos+'
;; `auth-source'
;; `avoid' ;; builtin
;; `backquote',
;; `bookmark'
;; `bookmark+'
;; `bookmark+-1'
;; `bookmark+-bmu',
;; `bookmark+-key'
;; `bookmark+-lit'
;; `button'
;; `bytecomp'
;; `cconv', ;; builtin
;; `cl-generic'
;; `cl-lib'
;; `cl-macs'
;; `cmds-menu'
;; `col-highlight',
;; `crosshairs'
;; `eieio'
;; `eieio-core'
;; `eieio-loaddefs',
;; `epg-config'
;; `fit-frame'
;; `font-lock'
;; `font-lock+',
;; `frame-fns'
;; `gv' ;; generalized variables
;; `help+'
;; `help-fns'
;; `help-fns+',
;; `help-macro' ;; builtin
;; `help-macro+'
;; `help-mode'
;; `hl-line'
;; `hl-line+',
;; `info'
;; `info+'
;; `kmacro'
;; `macroexp'
;; `menu-bar'
;; `menu-bar+',
;; `misc-cmds'
;; `misc-fns'
;; `naked'
;; `package'
;; `password-cache',
;; `pp'
;; `pp+'
;; `radix-tree'
;; `rect'
;; `replace'
;; `second-sel',
;; `seq'
;; `strings'
;; `syntax'
;; `tabulated-list'
;; `text-mode',
;; `thingatpt'
;; `thingatpt+'
;; `url-handlers'
;; `url-parse',
;; `url-vars'
;; `vline'
;; `w32browser-dlgopen'
;; `wid-edit',
;; `wid-edit+'

;;; Code:

(defconst bookmark-plus-packages
  '(
    (bookmark+ :location (recipe
                          :fetcher wiki
                          :files
                          ("bookmark+.el"
                           "bookmark+-mac.el"
                           "bookmark+-bmu.el"
                           "bookmark+-1.el"
                           "bookmark+-key.el"
                           "bookmark+-lit.el"
                           "bookmark+-doc.el"
                           "bookmark+-chg.el")))
    (linkd :location (recipe :fetcher wiki)) ;; for bookmark+
    (thingatpt+ :location (recipe :fetcher wiki))
    (pp+ :location (recipe :fetcher wiki))
    (font-lock+ :location (recipe :fetcher wiki))
    (help-macro+ :location (recipe :fetcher wiki))
    (help-fns+ :location (recipe :fetcher wiki))
    (misc-fns :location (recipe :fetcher wiki) :excluded t)
    ;; (fit-frame :location (recipe :fetcher wiki))
    )
  "The list of Lisp packages required by the bookmark-plus layer.

Each entry is either:

1. A symbol, which is interpreted as a package to be installed, or

2. A list of the form (PACKAGE KEYS...), where PACKAGE is the
    name of the package to be installed or loaded, and KEYS are
    any number of keyword-value-pairs.

    The following keys are accepted:

    - :excluded (t or nil): Prevent the package from being loaded
      if value is non-nil

    - :location: Specify a custom installation location.
      The following values are legal:

      - The symbol `elpa' (default) means PACKAGE will be
        installed using the Emacs package manager.

      - The symbol `local' directs Spacemacs to load the file at
        `./local/PACKAGE/PACKAGE.el'

      - A list beginning with the symbol `recipe' is a melpa
        recipe.  See: https://github.com/milkypostman/melpa#recipe-format")

(defun bookmark-plus/init-bookmark+ ()
  (use-package bookmark+
    :defer t
    :bind (
           :map bmkp-set-map
           ("C-c I" . bmkp-set-info-bookmark-with-node-name)
           ("C-c t" . chriad/bmkp-set-tag-prompt)
           ("C-c l" . chriad/bmkp-make-lambda-bookmark-from-sexp)
     ;; :map bmkp-jump-map
     ;; ("C-x x O p" . chriad/bookmark-set-tag-prompt)
     ;; ("C-x x O s" . bmkp-bookmark-file-switch-jump)
          :map bookmark-bmenu-mode-map
          ("T a" . bmkp-bmenu-add-tags))))


(defun bookmark-plus/init-linkd ()
  (use-package linkd
    :defer t))

(defun bookmark-plus/init-thingatpt+ ()
  (use-package thingatpt+
    :defer t))


(defun bookmark-plus/init-pp+ ()
  (use-package pp+
    :defer t))


(defun bookmark-plus/init-font-lock+ ()
  (use-package font-lock+
    :defer t))

(defun bookmark-plus/init-help-macro+ ()
  (use-package help-macro+
    :defer t))


(defun bookmark-plus/init-help-fns+ ()
  (use-package help-fns+
    :defer t))

;; (defun bookmark-plus/init-misc-fns ()
;;   (use-package misc-fns
;;     :defer t))

;; (defun bookmark-plus/post-init-helm-bookmarks
;;     (use-package helm-bookmarks
;;       :defer t
;;       :after helm-bookmarks
;;       :config

;;       (defun helm-bookmark-dired-setup-alist ()
;;         "Specialized filter function for Org file bookmarks."
;;         (helm-bookmark-filter-setup-alist 'bmkp-dired-bookmark-p))

;;       (defun helm-source-bookmark-dired-builder ()
;;         (helm-bookmark-build-source "Dired" #'helm-bookmark-dired-setup-alist))

;;       (defvar helm-source-bookmark-dired (helm-source-bookmark-dired-builder))
;;       ))
