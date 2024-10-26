;;; ttl-ts-mode.el --- Major mode for Turtle files using tree-sitter -*- lexical-binding: t -*-

;; Copyright (C) 2024 Eric Berquist

;; Author: Eric Berquist
;; Version: 0.1.0
;; Created: 2024-10-24
;; Package-Requires: ((emacs "29.1"))
;; Keywords: languages ttl turtle
;; URL: https://github.com/berquist/ttl-ts-mode

;; This file is not part of GNU Emacs.

;; This file is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this file.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;;; Code:

(require 'treesit)
(eval-when-compile
  (require 'rx))

(defgroup ttl-ts nil "Customization for ttl-ts-mode." :group 'text)

(defcustom ttl-ts-indent-level 4
  "Number of spaces for each indentation step in `ttl-ts-mode'."
  :type 'integer)

(defvar ttl-ts-treesit-font-lock-rules
  '(:language turtle
              :feature comment
              ((comment) @font-lock-comment-face)

              :language turtle
              :feature iri
              ((iri_reference) @font-lock-function-name-face)

              :language turtle
              :feature prefix
              ((namespace) @font-lock-type-face)

              :language turtle
              :feature suffix
              ((pn_local) @font-lock-constant-face)

              :language turtle
              :feature literal
              ((boolean_literal) @font-lock-constant-face
               ;; From jeeger/ttl-mode: This doesn't work, but may be less
               ;; desirable than the proper prefix:suffix fontification
               ;; anyway.
               ;;
               ;; (datatype) @font-lock-preprocessor-face
               (rdf_literal) @font-lock-constant-face)

              :language turtle
              :feature string
              :override t
              ((string) @font-lock-string-face)

              ;; :language turtle
              ;; :feature keywords
              ;; :override t
              ;; ((prefix_id) @font-lock-preprocessor-face)

              :language turtle
              :feature separators
              :override t
              (["," ";" "."] @font-lock-keyword-face)))

(defvar ttl-ts-indent-rules
  `((turtle
     )))

(defun ttl-ts-setup ()
  "Set up treesit for ttl-ts-mode."
  (setq-local comment-start "# "
              comment-end ""
              treesit-font-lock-settings
              (apply #'treesit-font-lock-rules ttl-ts-treesit-font-lock-rules)
              treesit-font-lock-feature-list
              '((comment)
                (iri prefix suffix literal string)
                (separators))
              treesit-simple-indent-rules ttl-ts-indent-rules
              )
  (treesit-major-mode-setup))

;;;###autoload
(define-derived-mode ttl-ts-mode prog-mode "Turtle (TS)"
  "Major mode for Turtle-serialized RDF using tree-sitter."
  :group 'ttl-ts
  (unless (treesit-ready-p 'turtle)
    (error "Tree-sitter for Turtle is not available"))
  (treesit-parser-create 'turtle)
  (ttl-ts-setup))

;;;###autoload
;;(add-to-list 'auto-mode-alist '("\\.ttl\\'" . ttl-ts-mode))

(provide 'ttl-ts-mode)

;; Local Variables:
;; coding: utf-8
;; End:

;;; ttl-ts-mode.el ends here
