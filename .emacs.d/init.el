 ;;;-*-no-byte-compile: t;;-*-

(require 'iso-transl)

(defun is-osx ()
  (eq system-type 'darwin))

(defun is-windows ()
  (eq system-type 'windows-nt))

(defun is-linux ()
  (eq system-type 'gnu/linux))



(require 'cl)

                                        ; make copying text from application to application work on linux.
(setq x-select-enable-clipboard t)

;;Set load path.
(add-to-list 'load-path "~/.emacs.d/elisp/")



                                        ; haven't yet bothered setting up a LaTeX environment on windows.
(if (not (is-windows))
    (load "/usr/share/emacs/site-lisp/auctex.el" nil t t))

;; barely ever use it.
;; (load "/usr/local/share/emacs/site-lisp/preview-latex.el" nil t t)


(add-to-list 'load-path "~/.emacs.d/elisp/site-start.d/")

(setq scroll-conservatively 10000)
(setq scroll-step 1)

;; Redo.
(require 'redo+)
(global-set-key (kbd "C-x C-_") 'redo)


;; Color-theme.
(add-to-list 'load-path "~/.emacs.d/elisp/color-theme-6.6.0/")
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-midnight)))

;; Auctex
(setq TeX-auto-save t)
(setq TeX-parse-self t)

;; Always save files before running latex or tex.
(setq TeX-save-query nil)


;; Makes it so that when you type or delete while a region or marked, that region gets killed.
(delete-selection-mode 1)


;; cperl-mode is preferred to perl-mode
(defalias 'perl-mode 'cperl-mode)


;; Turn off toolbar.
(tool-bar-mode -1)

;; Turn off menubar
(menu-bar-mode -1)


;; Get rid of the scrollbar
(scroll-bar-mode -1)

;; Yasnippet
(add-to-list 'load-path "~/.emacs.d/elisp/yasnippet-0.6.1c/")
(require 'yasnippet)
(require 'dropdown-list)
(yas/initialize)
(yas/load-directory "~/.emacs.d/elisp/yasnippet-0.6.1c/snippets/")

;; Backup files are annoying; I don't need them.
;; (setq make-backup-files nil)

;; ;;stop creating those backup~ files
;; (setq backup-inhibited t)

;; Put autosave files (ie #foo#) and backup files (ie foo~) in ~/.emacs.d/.
;; (custom-set-variables
;;   '(auto-save-file-name-transforms '((".*" "~/.emacs.d/autosaves/\\1" t)))
;;   '(backup-directory-alist '((".*" . "~/.emacs.d/backups/"))))

;; create the autosave dir if necessary, since emacs won't.
                                        ;(make-directory "~/.emacs.d/autosaves/" t)

(setq backup-inhibited t)
                                        ;disable auto save
(setq auto-save-default nil)


;; (setq auto-save-default nil)
;; (setq auto-save-visited-file-name t)
;; (setq auto-save-interval 50)
;; (setq auto-save-timeout 1)

 ;;; Turn of the blinking cursor

(if (fboundp 'blink-cursor-mode)
    (blink-cursor-mode -1))



;; Turn on highlight matching parens when cursor is on one.
(show-paren-mode 1)

;; Ido
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)
(setq ido-file-extensions-order '(".tex" ".org" ".pdf" ".el" ".bib"))

;; Zen Coding
(autoload 'zencoding-mode "zencoding-mode" "Zen" t)
(add-hook 'sgml-mode-hook 'zencoding-mode) ;;;Auto-start on any markup modes

;; Line numbers mode
(autoload 'linum-mode "linum" "toggle line numbers on/off" t)
(global-set-key (kbd "C-<f5>") 'linum-mode)

;; Hippie-expand
(global-set-key (kbd "M-/") 'hippie-expand)

;; Yes or no questions are annoying.
(defalias 'yes-or-no-p 'y-or-n-p)

;; Online search functions.
(defun look-up-base (url-formatter space-replace)
  "Generic base function for web searching"
  (let (search url)
    (setq search
          (if (and transient-mark-mode mark-active)
              (buffer-substring-no-properties (region-beginning) (region-end))
            (thing-at-point 'symbol)))

    (setq search (replace-regexp-in-string " " space-replace search))
    (setq url (funcall url-formatter search))
    (browse-url url)))

(defun google ()
  "Google the word under the cursor"
  (interactive)
  (look-up-base (lambda (search) (concat "http://www.google.com/search?q=" search))"+"))

(defun norstedts-base (lang)
  "Base for Norstedts search."
  (interactive)
  (look-up-base (lambda (search) (concat "http://www.ord.se/oversattning/engelska/?s=" search "&l=" lang))"%20"))


(defun norstedts-en ()
  "Look up the English word under the cursor in Norstedts."
  (interactive)
  (norstedts-base "ENGSVE"))

(defun norstedts-sw ()
  "Look up the Swedish word under the cursor in Norstedts."
  (interactive)
  (norstedts-base "SVEENG"))

(defun wikipedia ()
  "Look up the word under the cursor in wikipedia"
  (interactive)
  (look-up-base
   (lambda (search) (concat "http://en.wikipedia.org/wiki/" search))"_"))


(defun wiktionary-en ()
  "Look up the english word under the cursor in wiktionary"
  (interactive)
  (look-up-base
   (lambda (search) (concat "http://en.wiktionary.org/wiki/" search))"_"))


(defun wiktionary-sw ()
  "Look up the swedish word under the cursor in wiktionary"
  (interactive)
  (look-up-base
   (lambda (search) (concat "http://sv.wiktionary.org/wiki/" search))"_"))

(defun synonyms-en ()
  "Look up synonyms for the english word under the cursor."
  (interactive)
  (look-up-base
   (lambda (search) (concat "http://thesaurus.com/browse/" search))"+"))


(defun synonyms-sw ()
  "Look up synonyms for the swedish word under the cursor."
  (interactive)
  (look-up-base
   (lambda (search) (concat "http://www.synonymer.se/?query=" search))"+"))

(defun perldoc ()
  "Look up synonyms for the swedish word under the cursor."
  (interactive)
  (look-up-base
   (lambda (search) (concat "http://perldoc.perl.org/search.html?q=" search))"+"))


;; Update buffer function.
(global-set-key [f5]
                '(lambda ()
                   "Refresh the buffer from the disk"
                   (interactive)
                   (revert-buffer t (not (buffer-modified-p)) t)))

;; Rainbow mode.
(autoload 'rainbow-mode "rainbow-mode" "Colorize strings that represent colors.
 This will fontify with colors the string like \"#aabbcc\" or \"blue\"." t)
(add-hook 'css-mode-hook (lambda () (rainbow-mode 1)))


;; Org mode.
(add-to-list 'load-path "~/.emacs.d/elisp/org-7.4/lisp")
(add-to-list 'load-path "~/.emacs.d/elisp/org-7.4/contrib/lisp")

(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
(setq org-completion-use-ido t)
(autoload 'org-mode "org" "Org mode" t)

(eval-after-load "org"
  '(progn

     (add-hook 'org-mode-hook
               (let ((original-command (lookup-key org-mode-map [tab])))
                 `(lambda ()
                    (setq yas/fallback-behavior
                          '(apply ,original-command))
                    (local-set-key [tab] 'yas/expand))))
     ))

(defun my-org-export-latex-fix-inputenc ()
  "Set the codingsystem in inputenc to what the buffer is."
  (let* ((cs buffer-file-coding-system)
         (opt (latexenc-coding-system-to-inputenc cs)))
    (when opt
      (goto-char (point-min))
      (while (re-search-forward "\\\\usepackage\\[\\(.*?\\)\\] {inputenc}"
                                nil t)
        (goto-char (match-beginning 1))
        (delete-region (match-beginning 1) (match-end 1))
        (insert opt))
      (save-buffer))))

(eval-after-load "org-latex"
  '(add-hook 'org-export-latex-after-save-hook
             'my-org-export-latex-fix-inputenc))




;; org-mode html export for easy blogging.
(defun org-export-body-as-html ()
  (interactive)
  (org-export-as-html 3 nil nil "blog" t))

(add-hook 'org-mode-hook
          (lambda ()
            (setq org-export-htmlize-output-type 'css)
            (local-set-key (quote [?\C-x ?\C-y]) 'org-export-body-as-html)))

;; Make text mode the default major mode.
(setq default-major-mode 'text-mode)
(setq initial-major-mode 'text-mode)
(setq major-mode 'text-mode)

;; Template

(require 'template)
(template-initialize)

(add-to-list 'template-find-file-commands
             'ido-exit-minibuffer)

;; Sort directories and files separately.
(defun mydired-sort ()
  "Sort dired listings with directories first."
  (save-excursion
    (let (buffer-read-only)
      (forward-line 2) ;;;beyond dir. header
      (sort-regexp-fields t "^.*$" "[ ]*." (point) (point-max)))
    (set-buffer-modified-p nil)))

(defadvice dired-readin
  (after dired-after-updating-hook first () activate)
  "Sort dired listings with directories first before adding marks."
  (mydired-sort))


;; Activate winner mode.
(when (fboundp 'winner-mode)
  (winner-mode 1))

;; Load customizations.
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(setq default-abbrev-mode t)

(setq vc-handled-backends nil)


;; Orgtbl in html-mode;
(add-hook 'html-mode-hook 'turn-on-orgtbl)

;; Always output pdf-files for tex and latex.
(setq TeX-PDF-mode t)

;; Automatically update files in doc-view if they are updated.
(add-hook 'doc-view-mode-hook 'auto-revert-mode)

;; Get rid of the splash screen.
(setq inhibit-startup-message t
      inhibit-startup-echo-area-message t)


;; Always indent when enter is pressed.
(define-key global-map (kbd "RET") 'newline-and-indent)
(add-hook 'LaTeX-mode-hook '(lambda ()
                              (local-set-key (kbd "RET") 'newline-and-indent)))

;; Moving down at the end of the buffer results in newlines.
(setq next-line-add-newlines t)

;; Start up emacs maximized
(defun maximize-frame ()
  "Maximizes the active frame in Windows"
  (interactive)
   ;;;Send a `WM_SYSCOMMAND' message to the active frame with the
   ;;;`SC_MAXIMIZE' parameter.
  (when (is-windows)
    (w32-send-sys-command 61488)))
(add-hook 'window-setup-hook 'maximize-frame t)

;; Don't confirm that I want to create a new buffer or file.
(setq confirm-nonexistent-file-or-buffer nil)

;; Don't prompt if I want to shut down Emacs when it has a live process attached to it.
(setq kill-buffer-query-functions
      (remq 'process-kill-buffer-query-function
            kill-buffer-query-functions))

(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file name new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))

(defun kill-file-and-buffer ()
  "Deletes/kills both current buffer and file it's visiting."
  (interactive)
  (let ((filename buffer-file-name))
    (save-buffer)
    (when filename (delete-file filename))
    (kill-buffer)))

(defadvice kill-ring-save (before slick-copy activate compile)
  "When called interactively with no active region, copy the current line."
  (interactive
   (if mark-active
       (list (region-beginning) (region-end))
     (progn
       (message "Current line is copied.")
       (list (line-beginning-position) (line-beginning-position 2)) ) ) ))

(defadvice kill-region (before slick-copy activate compile)
  "When called interactively with no active region, cut the current line."
  (interactive
   (if mark-active
       (list (region-beginning) (region-end))
     (progn
       (list (line-beginning-position) (line-beginning-position 2)) ) ) ))

;; All deleted files should go to the trash can.
(setq delete-by-moving-to-trash t)

;; Recent files
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-saved-items 70)

(defun ido-recentf-open ()
  "Use `ido-completing-read' to \\[find-file] a recent file"
  (interactive)
  (if (find-file (ido-completing-read "Find recent file: " recentf-list))
      (message "Opening file...")
    (message "Aborting")))

(global-set-key (kbd "C-x C-r") 'ido-recentf-open)

(autoload 'flyspell-mode "flyspell" "On-the-fly spelling checker." t)
(add-hook 'LaTeX-mode-hook 'turn-on-flyspell)
(add-hook 'org-mode-hook 'turn-on-flyspell)
(add-hook 'message-mode-hook 'turn-on-flyspell)
(add-hook 'text-mode-hook 'turn-on-flyspell)
(add-hook 'css-mode-hook 'turn-on-flyspell)
(add-hook 'c-mode-common-hook 'flyspell-prog-mode)
(add-hook 'cc-mode-common-hook 'flyspell-prog-mode)
(add-hook 'cperl-mode-hook 'flyspell-prog-mode)
(add-hook 'emacs-lisp-mode-hook 'flyspell-prog-mode)
(add-hook 'danmakufu-mode-hook 'flyspell-prog-mode)
(add-hook 'scheme-mode-hook 'flyspell-prog-mode)
(add-hook 'j-mode-hook 'flyspell-prog-mode)
(add-hook 'sh-mode-hook 'flyspell-prog-mode)
(add-hook 'makefile-mode-hook 'flyspell-prog-mode)
(add-hook 'lua-mode-hook 'flyspell-prog-mode)

(defun turn-on-flyspell ()
  "Force flyspell-mode on using a positive arg. For use in hooks."
  (interactive)
  (flyspell-mode 1))

(defun count-string-matches (search)
  "Return the number of string atches in the buffer following the point."
  (interactive "sEnter search string:")
  ((let (count 0)
     (while(search-forward search)
       (setq count (1+ count)))
     (message "%i" count))))

 ;;;setting the PC keyboard's various keys to
 ;;;Super or Hyper, for emacs running on Windows.
;; (setq w32-pass-lwindow-to-system nil
;;       w32-pass-rwindow-to-system nil
;;       w32-pass-apps-to-system nil
;;       w32-lwindow-modifier 'super ;Left Windows key
;;       w32-rwindow-modifier 'super ;Right Windows key
;;       w32-apps-modifier 'hyper) ;Menu key

(defun delete-this-buffer-and-file ()
  "Removes file connected to current buffer and kills buffer."
  (interactive)
  (let ((filename (buffer-file-name))
        (buffer (current-buffer))
        (name (buffer-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (when (yes-or-no-p "Are you sure you want to remove this file? ")
        (delete-file filename)
        (kill-buffer buffer)
        (message "File '%s' successfully removed" filename)))))


(autoload 'Lorem-ipsum-insert-sentences "lorem-ipsum" "" t)
(autoload 'Lorem-ipsum-insert-paragraphs "lorem-ipsum" "" t)
(autoload 'Lorem-ipsum-insert-list "lorem-ipsum" "" t)

;;Enable visual-line-mode globally
(global-visual-line-mode 1)


;; Display a nice tip of the day on startup.
(defun totd ()
  (interactive)
  (with-output-to-temp-buffer "*Tip of the day*"
    (let* ((commands (loop for s being the symbols
                           when (commandp s) collect s))
           (command (nth (random (length commands)) commands)))
      (princ
       (concat "Your tip for the day is:\n========================\n\n"
               (describe-function command)
               "\n\nInvoke with:\n\n"
               (with-temp-buffer
                 (where-is command t)
                 (buffer-string))))))
  (delete-window))

(add-hook 'emacs-startup-hook 'my-startup-fcn)
(defun my-startup-fcn ()
  "do fancy things"
  (random t)
  (totd))

;; allow dired to be able to delete or copy a whole dir.
(setq dired-recursive-deletes 'top)

(add-hook 'dired-load-hook
          (function (lambda () (load "dired-x"))))

(add-hook 'dired-mode-hook
          (lambda ()
            (dired-omit-mode -1)
            ))

(require 'dired+)

;; Smex
(setq smex-save-file "~/.emacs.d/smex.save") ;; keep my ~/clean
(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)


(autoload 'describe-unbound-keys "unbound" "Display a list of unbound keystrokes of complexity no greater than MAX.
 Keys are sorted by their complexity; `key-complexity' determines it." t)

;; Make init file easily accessible.
(defun edit-init-file()
  "If the init ifle is already open in a buffer, switch to that buffer. Else open the init file"
  (interactive)
  (if (get-buffer "init.el")
      (switch-to-buffer "init.el")
    (find-file "~/.emacs.d/init.el"))
  (end-of-buffer))

(global-set-key (kbd "C-c i") 'edit-init-file)

;; Turn of annoying bell sounds.
(setq visible-bell nil)
(setq ring-bell-function nil)

(defun strip-quations (str)
  (substring str 1 (-(length str)1)))

(defun copy-matches-re (re)
  "find all lines matching the regexp RE in the current buffer
 putting the matching lines in a buffer named *matching*"
  (interactive "sRegexp to match: ")
  (let ((result-buffer (get-buffer-create "*matching*")))
    (with-current-buffer result-buffer
      (erase-buffer))
    (save-match-data
      (save-excursion
        (goto-char (point-min))
        (while (re-search-forward re nil t)
          (princ (concat(match-string-no-properties 0) "\n") result-buffer))))
    (pop-to-buffer result-buffer)))

(put 'dired-find-alternate-file 'disabled nil)

;; Always open info files in info mode.
(defun info-mode ()
  (interactive)
  (let ((file-name (buffer-file-name)))
    (kill-buffer (current-buffer))
    (info file-name)))
(add-to-list 'auto-mode-alist '("\\.info\\'" . info-mode))

;; Reftex
(setq reftex-plug-into-AUCTeX t)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex) ; with AUCTeX LaTeX mode

;; Always enable latex math mode.
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)

(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer
        (delq (current-buffer)
              (buffer-list))))

(defun kill-all-dired-buffers()
  "Kill all dired buffers."
  (interactive)
  (save-excursion
    (let((count 0))
      (dolist(buffer (buffer-list))
        (set-buffer buffer)
        (when (equal major-mode 'dired-mode)
          (setq count (1+ count))
          (kill-buffer buffer)))
      (message "Killed %i dired buffer(s)." count ))))


;; Auto-fill
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(add-hook 'emacs-lisp-mode-hook 'turn-on-auto-fill)

(autoload 'git-status "git" "Entry point into git-status mode." t)

(autoload 're-builder+ "re-builder+" "Construct a regexp
 interactively+." t)

(setq reb-re-syntax 'string)

(require 'tramp)
                                        ; Disables tramp
                                        ;(setq tramp-mode nil)
                                        ;(setq ido-enable-tramp-completion nil)

(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.conkerorrc$" . js2-mode))


(autoload 'writegood-mode "writegood-mode" "Colorize issues with the writing in the buffer." t)
(global-set-key "\C-cg" 'writegood-mode)

(global-auto-revert-mode t)



(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "/usr/local/bin/conkeror")
                                        ;      browse-url-generic-args '("c:\\conkeror\\application.ini"))

(defun remove-regexp (re)
  "Remove all matches of the regular expression."
  (interactive "sRegexp to remove all occurrences of: ")
  (replace-regexp re ""))

(defun gtd ()
  (interactive)
  (find-file "~/Dropbox/org/tasks.org")
  )


(global-set-key (kbd "C-c b") 'browse-url-at-point)


;;---------------------------------------------------------
;; F3 open dired item with default app in Windows, source:
;; https://github.com/scottjad/dotfiles/blob/master/.emacs
;;---------------------------------------------------------

(defun browse-file-windows (file)
  "Run default Windows application associated with FILE.
If no associated application, then `find-file' FILE."
  (let ((windows-file-name (dired-replace-in-string
                            "/" "\\" (dired-get-filename))))
    (or (condition-case nil
            (w32-shell-execute nil windows-file-name)
          (error nil))
        (find-file windows-file-name))))

(defun browse-file-linux (file)
  (dired-do-shell-command "gnome-open" nil
                          (dired-get-marked-files t
  current-prefix-arg)))


(defun browse-file-osx (file)
  (dired-do-shell-command "open" nil
                          (dired-get-marked-files t current-prefix-arg)))

(defun browse-file (file)
  (cond ((is-linux)
         (browse-file-linux file))
        ((is-windows)
         (browse-file-windows file))
        ((is-osx)
         (browse-file-osx file))
	))

(eval-after-load "dired"
  '(define-key dired-mode-map [f3]
     (lambda () (interactive)
       (browse-file (dired-get-filename)))))

(global-set-key (kbd "\C-c r") 'replace-string)

;; disable auto searching for files unless called explicitly
(setq ido-auto-merge-delay-time 99999)

(define-key ido-file-dir-completion-map (kbd "C-c C-s")
  (lambda()
    (interactive)
    (ido-initiate-auto-merge (current-buffer))))


(setq-default c-electric-flag nil)
(put 'downcase-region 'disabled nil)

(global-set-key (kbd "C-c s") 'interrupt-process)
(setq scheme-program-name "mzscheme.exe")
(require 'quack)

(defun scheme-send-buffer ()
  (interactive)
  "Send the entire current buffer to the inferior Scheme process."
  (scheme-send-region (point-min) (point-max)))


(define-key scheme-mode-map "\C-c\C-b" 'scheme-send-buffer)

(autoload 'j-mode "j-mode.el"  "Major mode for J." t)
(autoload 'j-shell "j-mode.el" "Run J from emacs." t)
(setq auto-mode-alist
      (cons '("\\.ij[rstp]" . j-mode) auto-mode-alist))

(setq j-path "C:/J/j602/bin/")

(add-to-list 'load-path "~/.emacs.d/elisp/python-mode.el/")
(require 'python-mode)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))

(setq auto-mode-alist
      (cons '("SConstruct" . python-mode) auto-mode-alist))
(setq auto-mode-alist
      (cons '("SConscript" . python-mode) auto-mode-alist))

(add-hook 'python-mode-hook 'flyspell-prog-mode)

(defun untabify-buffer ()
  "Untabify the whole buffer"
  (interactive)
  (untabify (point-min) (point-max)))

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(add-hook 'python-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (setq tab-width 4)
            (setq python-indent 4)))

(defun py-execute-buffer-fixed ()
  (interactive)
  (py-execute-buffer)
  (sit-for 1)
  (winner-undo)
  )

(require 'compile)

(global-set-key "\C-xc" 'recompile)


(defun iwb ()
  "indent whole buffer"
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max)))

(global-set-key "\C-cf" 'iwb)

(defun make-clean ()
  (interactive)
  (shell-command "make clean"))

(defun move-line (n)
  "Move the current line up or down by N lines."
  (interactive "p")
  (setq col (current-column))
  (beginning-of-line) (setq start (point))
  (end-of-line) (forward-char) (setq end (point))
  (let ((line-text (delete-and-extract-region start end)))
    (forward-line n)
    (insert line-text)
    ;; restore point to original column in moved line
    (forward-line -1)
    (forward-char col)))

(defun move-line-up (n)
  "Move the current line up by N lines."
  (interactive "p")
  (move-line (if (null n) -1 (- n))))

(defun move-line-down (n)
  "Move the current line down by N lines."
  (interactive "p")
  (move-line (if (null n) 1 n)))

(global-set-key (kbd "M-p") 'move-line-up)
(global-set-key (kbd "M-n") 'move-line-down)


(require 'dired-sort)

(setq dired-listing-switches "-alh")


(setq ispell-program-name "aspell")
(setq ispell-list-command "list")

(setq ispell-extra-args '("--sug-mode=ultra"))

;; See:  http://stackoverflow.com/questions/7279721/running-emacs-ispell-command-doesnt-ask-confirmation-to-save-to-private-diction
(setq ispell-selently-savep t)

(defun turn-on-outline-minor-mode ()
  (outline-minor-mode 1))

(add-hook 'LaTeX-mode-hook 'turn-on-outline-minor-mode)
(add-hook 'latex-mode-hook 'turn-on-outline-minor-mode)
(setq outline-minor-mode-prefix "\C-c\C-o")

(setq compilation-scroll-output 'first-error)

(setq redisplay-dont-pause t)

;; (add-to-list 'auto-mode-alist
;;              '("\\.sh\\'" . (lambda ()
;;                                ;; add major mode setting here, if needed, for example:
;;                                ;; (text-mode)
;;                                (set-buffer-file-coding-system 'unix)
;;                                (save-buffer)
;;                             (shell-script-mode))))



(defun toggle-fullscreen (&optional f)
  (interactive)
  (let ((current-value (frame-parameter nil 'fullscreen)))
    (set-frame-parameter nil 'fullscreen
                         (if (equal 'fullboth current-value)
                             (if (boundp 'old-fullscreen) old-fullscreen nil)
                           (progn (setq old-fullscreen current-value)
                                  'fullboth)))))

(global-set-key [f11] 'toggle-fullscreen)

                                        ; Make new frames fullscreen by default. Note: this hook doesn't do
                                        ; anything to the initial frame if it's in your .emacs, since that
                                        ; file is read _after_ the initial frame is created.
(add-hook 'after-make-frame-functions 'toggle-fullscreen)


;; make sure Emacs ask before closing.
(defun ask-before-closing ()
  "Ask whether or not to close, and then close if y was pressed"
  (interactive)
  (if (y-or-n-p (format "Are you sure you want to exit Emacs? "))
      (if (< emacs-major-version 22)
          (save-buffers-kill-terminal)
        (save-buffers-kill-emacs))
    (message "Canceled exit")))

(when window-system
  (global-set-key (kbd "C-x C-c") 'ask-before-closing))


(autoload 'nasm-mode "~/.emacs.d/elisp/nasm-mode.el" "" t)
(add-to-list 'auto-mode-alist '("\\.\\(asm\\|s\\|inc\\)$"
                                . nasm-mode))

(load "~/.emacs.d/elisp/haskell-mode/haskell-site-file.el")

(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
                                        ;(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

                                        ;(set-terminal-coding-system 'latin-1)
(set-keyboard-coding-system 'latin-1)
                                        ;(set-language-environment 'latin-1)

                                        ; for prolog.
(autoload 'run-prolog "prolog" "Start a Prolog sub-process." t)
(autoload 'prolog-mode "prolog" "Major mode for editing Prolog programs." t)
(autoload 'mercury-mode "prolog" "Major mode for editing Mercury programs." t)
(setq prolog-system 'swi)
(setq auto-mode-alist (append '(("\\.pro$" . prolog-mode)
                                ("\\.m$" . mercury-mode))
                              auto-mode-alist))

(when (is-osx)
  (setq mac-option-modifier 'none)
  (setq mac-command-modifier 'meta))

;;For easy window switching.
(if(is-osx)
    (windmove-default-keybindings 'shift)
  (windmove-default-keybindings 'super))

(if (is-windows)
    (windmove-default-keybindings 'shift))

;; hack that makes sure the proper PATH variable is set in the
;; graphical version of Emacs on OS X.
(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell (replace-regexp-in-string
                          "[ \t\n]*$"
                          ""
                          (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(if (is-osx)
    (if window-system (set-exec-path-from-shell-PATH)))

(add-to-list 'auto-mode-alist '("\\.m$" . objc-mode))

;; Also see:
;; http://groups.google.com/group/gnu.emacs.help/browse_thread/thread/31edd5b417119d72
;; http://emacswiki.org/emacs/IndentingC
;; http://stackoverflow.com/questions/663588/emacs-c-mode-incorrect-indentation
;; http://stackoverflow.com/questions/2461962/emacs-indentation-difficulty
;; http://www.kernel.org/doc/Documentation/CodingStyle


(setq c-default-style '((java-mode . "java") (awk-mode . "awk") (other . "user")))

;; (setq c-default-style "k&r")

                                        ;(c-set-offset 'substatement-open 0)

                                        ;(setq c-default-style "linux"
(setq c-basic-offset 4)

;; ;; http://groups.google.com/group/gnu.emacs.help/browse_thread/thread/31edd5b417119d72
;; (c-add-style "mycodingstyle" '((c-offsets-alist . ((innamespace . 0) ))))

;; ;; c/c++ mode
;; (add-hook 'c-mode-common-hook
;;           '(lambda()
;;              (c-set-style "mycodingstyle")))

                                        ; personal c++ coding style.
(c-add-style "mycodingstyle" '(
                               (c-basic-offset  . 4)
                               (c-comment-only-line-offset . 0)
                               (c-hanging-braces-alist . ((brace-list-open)
                                                          (brace-entry-open)
                                                          (substatement-open after)
                                                          (block-close . c-snug-do-while)
                                                          (arglist-cont-nonempty)))
                               (c-cleanup-list . (brace-else-brace))
                               (c-offsets-alist . ((statement-block-intro . +)
                                                   (knr-argdecl-intro     . 0)
                                                   (substatement-open     . 0)
                                                   (substatement-label    . 0)
                                                   (label                 . 0)
                                                   (statement-cont . +)
                                                   (innamespace . 0)))))

;; ;; c/c++ mode
(add-hook 'c-mode-common-hook
          '(lambda()
             (c-set-style "mycodingstyle")))


                                        ; Add cmake listfile names to the mode list.
(setq auto-mode-alist
      (append
       '(("CMakeLists\\.txt\\'" . cmake-mode))
       '(("\\.cmake\\'" . cmake-mode))
       auto-mode-alist))

(autoload 'cmake-mode "~/.emacs.d/elisp/cmake-mode.el" t)


;; uniquify.el is a helper routine to help give buffer names a better unique name.
(when (load "uniquify" 'NOERROR)
  (require 'uniquify)
  (setq uniquify-buffer-name-style 'forward)
                                        ;(setq uniquify-buffer-name-style 'post-forward)
  )


;; ;; autopair and js2 don't work together, because they both
;; ;; automatically close parentheses, braces, etc.
(add-hook 'js2-mode-hook (lambda () (setq autopair-dont-activate t)))

;; These two don't seem to work together. It results in an infinite
;; loop for some reason
(add-hook 'css-mode-hook (lambda () (setq autopair-dont-activate t)))

(require 'autopair)
(autopair-global-mode) ;enable autopair in all buffers
(setq autopair-blink nil)

(add-hook 'python-mode-hook
          #'(lambda ()
              (push '(?' . ?')
                    (getf autopair-extra-pairs :code))
              (setq autopair-handle-action-fns
                    (list #'autopair-default-handle-action
                          #'autopair-python-triple-quote-action))))

;; (add-hook 'c-mode-common-hook
;;           (lambda()
;;             (hs-minor-mode t)))
;; (put 'autopair-newline 'disabled nil)

(put 'upcase-region 'disabled nil)

(setq mac-allow-anti-aliasing nil)


(setq-default cursor-type 'bar)

(autoload 'lua-mode "lua-mode" "Lua editing mode." t)
(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
(add-to-list 'interpreter-mode-alist '("lua" . lua-mode))


(require 'danmakufu-mode)

(if (not(is-windows))
    (setq shell-file-name "bash")
  ;; When running in Windows, we want to use an alternate shell so we
  ;; can be more unixy.
  (setq shell-file-name "C:/MinGW/msys/1.0/bin/bash")
  (setq explicit-shell-file-name shell-file-name)
  (setenv "PATH"
          (concat ".:/usr/local/bin:/mingw/bin:/bin:"
                  (replace-regexp-in-string " " "\\\\ "
                                            (replace-regexp-in-string "\\\\" "/"
                                                                      (replace-regexp-in-string "\\([A-Za-z]\\):" "/\\1"
                                                                                                (getenv "PATH"))))))

  )



;; Set default font.

(cond
 ((is-osx)
  (set-default-font "Monaco-9"))
 ;; else, linux
 (t
  (set-default-font "Monaco-8")))


(when (is-windows)
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
  (custom-set-faces
   '(default ((t (:inherit nil :stipple nil :background "black"
                           :foreground "grey85" :inverse-video nil :box
                           nil :strike-through nil :overline nil
                           :underline nil :slant normal :weight light
                           :height 80 :width condensed :foundry
                           "outline" :family "Consolas"))))))

;; - '(default ((t (:inherit antialias=none :stipple nil :background "black" :foreg
;; round "grey85" :inverse-video nil :box nil :strike-through nil :overline nil :un
;; derline nil :slant normal :weight normal :height 83 :width normal :foundry "outl
;; ine" :family "Monaco"))))

(when (is-linux)
  (require 'ibus)
  (add-hook 'after-init-hook 'ibus-mode-on)
  (ibus-define-common-key ?\C-j t)
  (setq ibus-agent-file-name "~/.emacs.d/elisp/ibus-el-agent")
  (ibus-define-common-key ?\C-\s nil)
  (ibus-define-common-key ?\C-/ nil))

(set-fontset-font "fontset-default"
                  'japanese-jisx0208
                  '("Osaka" . "iso10646-1"))