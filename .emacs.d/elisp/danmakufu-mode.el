;;; danmakufu-mode.el --- A major mode for writing Danmakufu scripts.

;; Copyright (C) 2011 Eric Arnebäck <erkastina@hotmail.com>

;; Version: 1.0

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2 of
;; the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be
;; useful, but WITHOUT ANY WARRANTY; without even the implied
;; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
;; PURPOSE.  See the GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public
;; License along with this program; if not, write to the Free
;; Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
;; MA 02111-1307 USA

;;; Commentary:

;; This mode makes writing Danmakufu scripts in Emacs easier.
;;
;; To install: put this file on the load-path and place the following
;; in your .emacs file:
;;   (require 'danmakufu-mode)
;; danmakufu-mode will now be activated when opening files of the
;; extension ".dan"
;;
;; Or you can just start it manually with: `M-x danmakufu-mode'
;;

;;; Code:

(require 'cc-mode)

(eval-when-compile
  (require 'cc-langs)
  (require 'cc-fonts))

(eval-and-compile
  ;; c++-mode is preferred as a base because c++ supports single line comments.
  (c-add-language 'danmakufu-mode 'c++-mode))

; these can be found cc-langs.el

(c-lang-defconst c-simple-stmt-kwds
 danmakufu (append '("function" "task") (c-lang-const
 c-simple-stmt-kwds)))

;; function could be found here before.
 (c-lang-defconst c-block-stmt-2-kwds
   danmakufu (append '("loop" "ascent" "descent" "if" "while" "if"
   "else" "sub" "let" "case" "local" "ShotData") (c-lang-const c-modifier-kwds)))

(c-lang-defconst c-case-kwds
  "The keyword\(s) which introduce a \"case\" like construct.
This construct is \"<keyword> <expression> :\"."
  t nil
  awk nil)

(c-lang-defconst c-label-kwds
  "Keywords introducing colon terminated labels in blocks."
  t nil
  awk nil)

(defconst danmakufu-font-lock-keywords-1 (c-lang-const c-matchers-1 danmakufu)
  "Minimal highlighting for Danmakufu mode.")

(c-lang-defconst c-matchers-2-custom
  t (append (c-lang-const c-matchers-1)
	    (c-lang-const c-basic-matchers-before)
	    (c-lang-const c-basic-matchers-after)))

(c-lang-defconst c-matchers-3-custom
  t (append (c-lang-const c-matchers-1)
	    (c-lang-const c-basic-matchers-before)
	    (c-lang-const c-basic-matchers-after)))


(defconst danmakufu-font-lock-keywords-2 (c-lang-const c-matchers-2-custom danmakufu)
  "Fast normal highlighting for Danmakufu mode.")

(defconst danmakufu-font-lock-keywords-3 (c-lang-const c-matchers-3-custom danmakufu)
  "Accurate normal highlighting for Danmakufu mode.")

(defvar danmakufu-font-lock-keywords danmakufu-font-lock-keywords-3
  "Default expressions to highlight in Danmakufu mode.")

(defvar danmakufu-mode-syntax-table nil
  "Syntax table used in danmakufu-mode buffers.")

(or danmakufu-mode-syntax-table
    (setq danmakufu-mode-syntax-table
	  (funcall (c-lang-const c-make-mode-syntax-table danmakufu))))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.dan" . danmakufu-mode))

;;;###autoload
(defun danmakufu-mode ()
  "Major mode for editing Danmakufu scripts

Key bindings:
\\{c-mode-map}"
  (interactive)
  (kill-all-local-variables)
  (c-initialize-cc-mode t)
  (set-syntax-table danmakufu-mode-syntax-table)
  (setq major-mode 'danmakufu-mode
	mode-name "Danmakufu")
  (use-local-map c-mode-map)
  (c-init-language-vars danmakufu-mode)
  (c-common-init 'danmakufu-mode)
  (run-hooks 'c-mode-common-hook)
  (run-hooks 'danmakufu-mode-hook)
  (c-update-modeline))

(provide 'danmakufu-mode)
