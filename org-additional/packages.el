;;; packages.el --- org-additional layer packages file for Spacemacs.
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
;; added to `org-additional-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `org-additional/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `org-additional/pre-init-PACKAGE' and/or
;;   `org-additional/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst org-additional-packages
  '(
    ;; (org-fc
    ;;  :location (recipe :fetcher git
    ;;                    :url "https://git.sr.ht/~l3kn/org-fc"
    ;;                    :files (:defaults "awk" "demo.org")))
    (org-starless :location (recipe
                             :fetcher github
                             :repo "TonCherAmi/org-starless"))
    (org-babel-hide-markers-mode :location (recipe
                             :fetcher github
                             :repo "amno1/org-babel-hide-markers-mode"))
    )
)

;; (use-package hydra)

;; (defun org-additional/init-org-fc ()
;;   (use-package org-fc
;;     :defer t
;;     :custom (org-fc-directories '("~/roam/"))
;;     :config
;;     (require 'org-fc-hydra)
;;     (require 'org-fc-keymap-hint)
;;     ;; :init (add-hook 'org-mode-hook #'org-starless-mode)
;;     (global-set-key (kbd "C-c f") 'org-fc-hydra/body)
;;     ;; (setq org-fc-directories '("~/roam/"))
;;     (evil-define-minor-mode-key '(normal insert emacs) 'org-fc-review-flip-mode
;;       (kbd "RET") 'org-fc-review-flip
;;       (kbd "n") 'org-fc-review-flip
;;       (kbd "s") 'org-fc-review-suspend-card
;;       (kbd "q") 'org-fc-review-quit)

;;     (evil-define-minor-mode-key '(normal insert emacs) 'org-fc-review-rate-mode
;;       (kbd "a") 'org-fc-review-rate-again
;;       (kbd "h") 'org-fc-review-rate-hard
;;       (kbd "g") 'org-fc-review-rate-good
;;       (kbd "e") 'org-fc-review-rate-easy
;;       (kbd "s") 'org-fc-review-suspend-card
;;       (kbd "q") 'org-fc-review-quit)
;;     ))



(defun org-additional/init-org-starless ()
  (use-package org-starless
    :defer t
    ))

(defun org-additional/init-org-babel-hide-markers-mode ()
  (use-package org-babel-hide-markers-mode
    :defer t
    :init (spacemacs/set-leader-keys-for-major-mode 'org-mode
            "ox" 'org-babel-hide-markers-mode)
    ))
