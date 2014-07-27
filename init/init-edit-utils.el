;; -*- mode: Emacs-Lisp; tab-width: 2; indent-tabs-mode:nil; -*-    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Author: Anton Strilchuk <ype@env.sh>                             ;;
;; URL: http://ype.env.sh                                           ;;
;; Created: 16-06-2014                                              ;;
;; Last-Updated: 27-07-2014                                         ;;
;;  Update #: 19                                                    ;;
;;   By: Anton Strilchuk <ype@env.sh>                               ;;
;;                                                                  ;;
;; Filename: init-edit-utils                                        ;;
;; Version:                                                         ;;
;; Description:                                                     ;;
;;                                                                  ;;
;; Package Requires: ()                                             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require-package 'unfill)
(require-package 'whole-line-or-region)

(when (fboundp 'electric-pair-mode)
  (setq-default electric-pair-mode 1))

(setq-default blink-cursor-delay 0
              blink-cursor-interval 0.4
              bookmark-default-file (expand-file-name ".bookmarks.el" user-emacs-directory)
              buffers-menu-max-size 30
              case-fold-search t
              compilation-scroll-output t
              grep-highlight-matches t
              grep-scroll-output t
              indent-tabs-mode nil
              mouse-yank-at-point t
              save-interprogram-paste-before-kill t
              scroll-preserve-screen-position 'always
              set-mark-command-repeat-pop t
              show-trailing-whitespace t
              tooltip-delay 1.5
              truncate-lines nil
              truncate-partial-width-windows nil)

(when *is-a-mac*
  (setq-default locate-command "mdfind"))

(global-auto-revert-mode)
(setq global-auto-revert-non-file-buffers t
      auto-revert-verbose nil)

;; But don't show trailing whitespace in SQLi, inf-ruby etc.
(dolist (hook '(special-mode-hook
                eww-mode
                term-mode-hook
                comint-mode-hook
                compilation-mode-hook
                twittering-mode-hook
                minibuffer-setup-hook))
  (add-hook hook
            (lambda () (setq show-trailing-whitespace nil))))

(require-package 'whitespace-cleanup-mode)
(global-whitespace-cleanup-mode t)
(diminish 'whitespace-cleanup-mode " ⌴")

(transient-mark-mode t)

(global-set-key (kbd "RET") 'newline-and-indent)
(defun sanityinc/newline-at-end-of-line ()
  "Move to end of line, enter a newline, and reindent."
  (interactive)
  (move-end-of-line 1)
  (newline-and-indent))

(global-set-key (kbd "S-<return>") 'sanityinc/newline-at-end-of-line)

(after-load 'subword
    (diminish 'subword-mode))

(when (fboundp 'global-prettify-symbols-mode)
  (global-prettify-symbols-mode))

;;Undo Tree
;;http://ergoemacs.org/emacs/emacs_best_redo_mode.html
(require-package 'undo-tree)
(global-undo-tree-mode 1)
(diminish 'undo-tree-mode)

(require-package 'highlight-symbol)
(dolist (hook '(prog-mode-hook html-mode-hook))
  (add-hook hook 'highlight-symbol-mode)
  (add-hook hook 'highlight-symbol-nav-mode))
(eval-after-load 'highlight-symbol
  '(diminish 'highlight-symbol-mode))

;;Rainbow Delimiter
(require-package 'rainbow-delimiters)
(global-rainbow-delimiters-mode t)

;;Rainbow Blocks
(require-package 'rainbow-blocks)
(after-load 'rainbow-blocks
  '(diminish 'rainbow-blocks-mode))
(add-hook 'lisp-mode-hook 'rainbow-blocks-mode)
(add-hook 'emacs-lisp-mode-hook 'rainbow-blocks-mode)
(global-set-key (kbd "H-d") 'rainbow-blocks-mode)

(autoload 'zap-up-to-char "misc" "Kill up to, but not including ARGth occurrence of CHAR.")
(global-set-key (kbd "M-Z") 'zap-up-to-char)

(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-defun 'disabled nil)

;;Highlight matching parens
(setq show-paren-style 'expression)
(show-paren-mode 1)

;;----------------------------------------------------------------------------
;; Expand region
;;----------------------------------------------------------------------------
(require-package 'expand-region)
(global-set-key (kbd "C-\-") 'er/expand-region)

(cua-selection-mode t)

;;; Ace Jump
;; C-c SPC => ace-jump-word-mode
;; C-u C-c SPC => ace-jump-char-mode
;; C-u C-u C-c SPC => ace-jump-line-mode
(require-package 'ace-jump-mode)
(global-set-key (kbd "C-\\") 'ace-jump-mode)
(global-set-key (kbd "C-~") 'ace-jump-word-mode)
(global-set-key (kbd "C-`") 'ace-jump-line-mode)

(global-set-key (kbd "C-c J") (lambda () (interactive) (join-line 1)))
(global-set-key (kbd "C-.") 'set-mark-command)
(global-set-key (kbd "C-x C-.") 'pop-global-mark)

(defun duplicate-region (beg end)
  "Insert a copy of the current region after the region."
  (interactive "r")
  (save-excursion
    (goto-char end)
    (insert (buffer-substring beg end))))

(defun duplicate-line-or-region (prefix)
  "Duplicate either the current line or any current region."
  (interactive "*p")
  (whole-line-or-region-call-with-region 'duplicate-region prefix t))

(global-set-key (kbd "C-c C-p") 'duplicate-line-or-region)

;; Force Use Emacs Movement
(global-unset-key [M-left])
(global-unset-key [M-right])

;;----------------------------------------------------------------------------
;; Shift lines up and down with M-up and M-down. When paredit is enabled,
;; it will use those keybindings. For this reason, you might prefer to
;; use M-S-up and M-S-down, which will work even in lisp modes.
;;----------------------------------------------------------------------------
(require-package 'move-dup)
(global-set-key [M-up] 'md/move-lines-up)
(global-set-key [M-down] 'md/move-lines-down)
(global-set-key [M-S-up] 'md/move-lines-up)
(global-set-key [M-S-down] 'md/move-lines-down)

(defun kill-back-to-indentation ()
  "Kill from point back to the first non-whitespace character on the line."
  (interactive)
  (let ((prev-pos (point)))
    (back-to-indentation)
    (kill-region (point) prev-pos)))

(global-set-key (kbd "C-M-<backspace>") 'kill-back-to-indentation)

;;----------------------------------------------------------------------------
;; Fill column indicator
;;----------------------------------------------------------------------------
(when (eval-when-compile (> emacs-major-version 23))
  (require-package 'fill-column-indicator)
  (defun sanityinc/prog-mode-fci-settings ()
    (turn-on-fci-mode)
    (when show-trailing-whitespace
      (set (make-local-variable 'whitespace-style) '(face trailing))
      (whitespace-mode 1)))

  (defun sanityinc/fci-enabled-p ()
    (and (boundp 'fci-mode) fci-mode))

  (defvar sanityinc/fci-mode-suppressed nil)
  (defadvice popup-create (before suppress-fci-mode activate)
    "Suspend fci-mode while popups are visible"
    (let ((fci-enabled (sanityinc/fci-enabled-p)))
      (when fci-enabled
        (set (make-local-variable 'sanityinc/fci-mode-suppressed) fci-enabled)
        (turn-off-fci-mode))))
  (defadvice popup-delete (after restore-fci-mode activate)
    "Restore fci-mode when all popups have closed"
    (when (and sanityinc/fci-mode-suppressed
               (null popup-instances))
      (setq sanityinc/fci-mode-suppressed nil)
      (turn-on-fci-mode)))

  ;; Regenerate fci-mode line images after switching themes
  (defadvice enable-theme (after recompute-fci-face activate)
    (dolist (buffer (buffer-list))
      (with-current-buffer buffer
        (when (sanityinc/fci-enabled-p)
          (turn-on-fci-mode))))))

(defun backward-up-sexp (arg)
  "Jump up to the start of the ARG'th enclosing sexp."
  (interactive "p")
  (let ((ppss (syntax-ppss)))
    (cond ((elt ppss 3)
           (goto-char (elt ppss 8))
           (backward-up-sexp (1- arg)))
          ((backward-up-list arg)))))

(global-set-key [remap backward-up-list] 'backward-up-sexp) ; C-M-u, C-M-up

;;----------------------------------------------------------------------------
;; Cut/copy the current line if no region is active
;;----------------------------------------------------------------------------
(whole-line-or-region-mode t)
(diminish 'whole-line-or-region-mode)
(make-variable-buffer-local 'whole-line-or-region-mode)

(defun suspend-mode-during-cua-rect-selection (mode-name)
  "Add an advice to suspend `MODE-NAME' while selecting a CUA rectangle."
  (let ((flagvar (intern (format "%s-was-active-before-cua-rectangle" mode-name)))
        (advice-name (intern (format "suspend-%s" mode-name))))
    (eval-after-load 'cua-rect
      `(progn
         (defvar ,flagvar nil)
         (make-variable-buffer-local ',flagvar)
         (defadvice cua--activate-rectangle (after ,advice-name activate)
           (setq ,flagvar (and (boundp ',mode-name) ,mode-name))
           (when ,flagvar
             (,mode-name 0)))
         (defadvice cua--deactivate-rectangle (after ,advice-name activate)
           (when ,flagvar
             (,mode-name 1)))))))

(suspend-mode-during-cua-rect-selection 'whole-line-or-region-mode)

(defun sanityinc/open-line-with-reindent (n)
  "A version of `open-line' which reindents the start and end positions.
If there is a fill prefix and/or a `left-margin', insert them
on the new line if the line would have been blank.
With arg N, insert N newlines."
  (interactive "*p")
  (let* ((do-fill-prefix (and fill-prefix (bolp)))
   (do-left-margin (and (bolp) (> (current-left-margin) 0)))
   (loc (point-marker))
   ;; Don't expand an abbrev before point.
   (abbrev-mode nil))
    (delete-horizontal-space t)
    (newline n)
    (indent-according-to-mode)
    (when (eolp)
      (delete-horizontal-space t))
    (goto-char loc)
    (while (> n 0)
      (cond ((bolp)
       (if do-left-margin (indent-to (current-left-margin)))
       (if do-fill-prefix (insert-and-inherit fill-prefix))))
      (forward-line 1)
      (setq n (1- n)))
    (goto-char loc)
    (end-of-line)
    (indent-according-to-mode)))

(global-set-key (kbd "C-o") 'sanityinc/open-line-with-reindent)

;;----------------------------------------------------------------------------
;; Random line sorting
;;----------------------------------------------------------------------------
(defun sort-lines-random (beg end)
  "Sort lines in region randomly."
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region beg end)
      (goto-char (point-min))
      (let ;; To make `end-of-line' and etc. to ignore fields.
          ((inhibit-field-text-motion t))
        (sort-subr nil 'forward-line 'end-of-line nil nil
                   (lambda (s1 s2) (eq (random 2) 0)))))))

(when (executable-find "ag")
  (require-package 'ag)
  (require-package 'wgrep-ag)
  (setq-default ag-highlight-search t)
  (global-set-key (kbd "H-q") 'ag-project)
  (global-set-key (kbd "H-z") 'projectile-ag))

(global-set-key (kbd "H-+") 'enlarge-window)
(global-set-key (kbd "H-_") 'shrink-window)

(require-package 'highlight-escape-sequences)
(hes-mode)

(require-package 'guide-key)
(setq guide-key/guide-key-sequence '("C-x"))
(setq guide-key/recursive-key-sequence-flag t)
(setq guide-key/idle-delay 1.0)
(guide-key-mode 1)
(diminish 'guide-key-mode)

(require-package 'rebox2)
(setq rebox-style-loop '(17 27 21))
(global-set-key [(meta q)] 'rebox-dwim)
(global-set-key [(hyper r)] 'rebox-cycle)

;;,--------------------------------------
;;| Word Count Mode
;;| https://github.com/bnbeckwith/wc-mode
;;`--------------------------------------
(require-package 'wc-mode)
;; Suggested setting
(global-set-key "\C-cw" 'wc-mode)

;;,-------------------------------------------
;;| Multiple Cursors
;;| Mark a bunch of stuff just like in sublime
;;`-------------------------------------------
(require-package 'multiple-cursors)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-+") 'mc/mark-next-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; From active region to multiple cursors:
(global-set-key (kbd "C-c c r") 'set-rectangular-region-anchor)
(global-set-key (kbd "C-c c c") 'mc/edit-lines)
(global-set-key (kbd "C-c c e") 'mc/edit-ends-of-lines)
(global-set-key (kbd "C-c c a") 'mc/edit-beginnings-of-lines)

;;,-----------------------------------------------------------------
;;|  Drag Stuff
;;| it possible to drag stuff (words, region, lines) around in Emacs
;;`-----------------------------------------------------------------
(require-package 'drag-stuff)
(drag-stuff-mode t)

;; No annoy emacs beep
(setq ring-bell-function #'ignore)

;;Delete to trash
(setq delete-by-moving-to-trash t)

;;Y for yes N for no
(defalias 'yes-or-no-p 'y-or-n-p)

;;Confirm Emacs Quit
(set-variable 'confirm-kill-emacs 'yes-or-no-p)

;;Root directory
(setq root-dir (file-name-directory
                (or (buffer-file-name) load-file-name)))

;;Load GTAGS for getting tags from source files
(setq load-path (cons "/usr/local/Cellar/global/6.2.9/share/gtags/" load-path))
(autoload 'gtags-mode "gtags" "" t)
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)

;;Reveal Stuff in OSX Finder
(require-package 'reveal-in-finder)

;;,-----------------------
;;| Quick Conversion tools
;;`-----------------------

;; Seconds to Minutes
(defun m2s (mins)
  "Quick convert minutes to seconds"
  (* mins 60))

;; Seconds to Hour
(defun h2s (hours)
  "Quick convert hours to seconds"
  (* (* hours 60) 60))



;;,-------------------------------------------------------------------
;;| Hide Boring Buffers
;;|
;;| Buffers that are ephemeral and generally uninteresting to the user
;;| have names starting with a space, so that the list-buffers and
;;| buffer-menu commands don't mention them (but if such a buffer
;;| visits a file, it is mentioned). A name starting with space also
;;| initially disables recording undo information
;;`-------------------------------------------------------------------

(defun hide-boring-buffer ()
  "Rename the current buffer to begin with a space"
  (interactive)
  (unless (string-match-p "^ " (buffer-name))
    (rename-buffer (concat " " (buffer-name)))))



;;,-------------------------------------------------------------------
;;| Org-Link-Minor-Mode
;;|
;;| Emacs minor mode that enables org-mode style fontification and
;;| activation of bracket links in modes other than org-mode.
;;|
;;| Org-mode bracket links look like this:
;;|
;;| [[http://www.bbc.co.uk][BBC]]
;;| [[org-link-minor-mode]]
;;|
;;| With this mode enabled, the links will be made active so you can
;;| click on them and displayed so you can see only the description if
;;| present.
;;|
;;| Note that org-toggle-link-display will also work when this mode is
;;| enabled.
;;`-------------------------------------------------------------------

(require-git-package 'seanohalpin/org-link-minor-mode)
(require 'org-link-minor-mode)

(after-load 'org-link-minor-mode
  (diminish 'org-link-minor-mode " ☌")

  (defun ype/toggle-OLMM-1 () (interactive) (org-link-minor-mode 1))
  (defun ype/toggle-OLMM-0 () (interactive) (org-link-minor-mode 0))

  (global-set-key (kbd "A-1") 'ype/toggle-OLMM-1)
  (global-set-key (kbd "A-2") 'ype/toggle-OLMM-0))


;;Linum Mode
(require 'linum)
(require-package 'linum-relative)
(require 'linum-relative)

(defadvice linum-update-window (around linum-dynamic activate)
  (let* ((w (length (number-to-string
                     (count-lines (point-min) (point-max)))))
         (linum-format (concat " %" (number-to-string w) "d ")))
    ad-do-it))


(define-prefix-command 'endless:toggle-map)
;; The manual recommends C-c for user keys, but I like using C-x for
;; global keys and using C-c for mode-specific keys.
(define-key ctl-x-map "t" 'endless:toggle-map)
(define-key endless:toggle-map "l" 'linum-mode)
(define-key endless:toggle-map "r" 'linum-relative-toggle)
(define-key endless:toggle-map "e" 'toggle-debug-on-error)
(define-key endless:toggle-map "F" 'auto-fill-mode)
(define-key endless:toggle-map "c" 'toggle-truncate-lines)
(define-key endless:toggle-map "q" 'toggle-debug-on-quit)
(define-key endless:toggle-map "d" 'read-only-mode)
(define-key endless:toggle-map "g" 'git-gutter-mode)
(define-key endless:toggle-map "t" 'endless/toggle-theme)
(define-key endless:toggle-map "f" 'flycheck-mode)



(provide 'init-edit-utils)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-edit-utils.el ends here
