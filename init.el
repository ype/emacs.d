;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Author: Anton Strilchuk <anton@env.sh>                         ;;;
;;; URL: http://ype.env.sh                                         ;;;
;;; Created: 16-06-2014                                            ;;;
;;; Last-Updated: 02-01-2015                                       ;;;
;;;  Update #: 146                                                 ;;;
;;;   By: Anton Strilchuk <anton@env.sh>                           ;;;
;;;                                                                ;;;
;;; Filename: init                                                 ;;;
;;; Version: 0.1.1.1                                               ;;;
;;; Description: ype'S emacs conf                                  ;;;
;;;                                                                ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(let ((minver 24))
  (unless (>= emacs-major-version minver)
    (error "UPDATE TIME! This Emacs requires v%s or higher" minver)))

(defconst *is-a-mac* (eq system-type 'darwin))
(defconst *is-x-toolkit* (eq window-system 'x))
(defconst *is-ns-toolkit* (eq window-system 'ns))

(add-to-list 'load-path (expand-file-name "init" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "init-tools" user-emacs-directory))

;; Add function for requiring git submodules
(require 'init-git-submodules)

;; Measure startup time
(require 'init-benchmarking)

;; ---------------- ;;
;; Bootstrap Config ;;
;; ---------------- ;;
;;(require 'init-compat)
(require 'init-utils)
(require 'oVr-mode)
(require 'init-prefix-keys)

;; Package.el
(require 'init-elpa)
;; Paradox Package Rankings from GitHub
(require 'init-paradox-github)

;; $PATH
(require 'init-exec-path)

;; wgrep needed for init-edit-utils
(require-package 'wgrep)
(require-package 'project-local-variables)
(require-package 'diminish)
(require-package 'scratch)
(require-package 'mwe-log-commands)

(setq temporary-file-directory (expand-file-name "backup" user-emacs-directory))
;;Buffer Backups (files in ~/.emacs.d/backup)
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying t    ; Don't delink hardlinks
      version-control t      ; Use version numbers on backups
      delete-old-versions t  ; Automatically delete excess backups
      kept-new-versions 20   ; how many of the newest versions to keep
      kept-old-versions 5    ; and how many of the old
      )

(setq user-mail-address "anton@env.sh"
      user-full-name "Anton Strilchuk")

(require 'init-keys) ; Keys and Passwords, do not include in public git
(require 'init-frame-hooks)
(require 'init-xterm)
(require-package 'fold-dwim)
(require-package 'dash)
;;Appearance Setup
(require 'init-theme)
(require 'init-tabbar)
(require 'init-gui-frames)
(require 'init-appearance)
(when *is-a-mac*
  (require 'init-font))

;;Customizations
(add-to-list 'load-path (expand-file-name "custom" user-emacs-directory))
(require-git-submodule 'terminal-notifier t)

;;Search Modes
(require 'init-search)
(require 'init-ido)
(require 'init-auto-complete)
(require 'init-windows)
(require 'init-sessions)

(require 'init-edit-utils)
(require 'init-helpers)
(require 'init-paredit)
(require 'init-flycheck)

;;Project management
(require-package 'ack-and-a-half)

;;Git
(require 'init-git)

;; Code Modes
(require 'init-javascript)
(require 'init-lisp)
(require 'init-slime)
(require 'init-common-lisp)
(require 'init-clojure)
(require 'init-literate-clojure)
(require 'init-python)
(require 'init-go)
(require 'init-ruby)
(require 'init-oascript)

;;Custom Functions
;;(require 'init-random-defuns)

;;Jump to Page
(require 'init-webjump)

;;HELM
(require 'init-helm)

;;Auto Header
(require 'header2)
(require 'init-headers)

;;Clean up modeline
;;(load "clean-modeline")

;;Markdown mode
(require 'init-markdown)

;; Org-Sync
(require-git-submodule 'org-sync)
(require 'os)

;;The Big Giant Org
(require 'init-org)
(require 'init-org-publish)
(require 'init-proj-manage)

(when (executable-find "google")
  (require 'init-gcal))

;;; Quick create blog post
;; set posts directory
;; (require 'init-blog-post)

;;; Org Custom Macros
;; (require 'init-org-macros)

;; R in Emacs
(require 'init-ess)

;;LATEX
(require 'init-latex)

;;MU4E
(require 'init-contacts)
(require 'init-mu4e)

;;Dash
(require 'init-dash)

;; Finances
(require 'init-ledger)

;;Social Networking
(require 'init-social)

;;Custom Keybindings
(require 'init-keybindings)


;;,---------------------
;;| MISC
;;| miscellaneous stuff
;;`---------------------

;; Writing
(require 'init-deft)
(require 'init-writing)

;; Web
(require 'init-web)

;; Health
(require 'init-rsi)

;; News and Reading
(require 'init-feeds)
(require 'el-pocket)
(el-pocket-load-auth)
;;(require 'init-spritz)

;; Slack
;;(require 'init-slack)

;;IRC
;;(require 'init-irc)

;; OSX Browse
;;(require 'init-browse)

;;,--------------------------------------------------
;;| MISC: OSX Printing
;;| From: http://www.emacswiki.org/emacs/MacPrintMode
;;`--------------------------------------------------
(add-to-list 'load-path (expand-file-name "misc" user-emacs-directory))
;;(require 'mac-print-mode)

(require-package 'gnuplot)
(when *is-a-mac*
  (require-package 'osx-location))
(require-package 'regex-tool)

;;----------------------------------------------------------------------------
;; Byte compile every .el file into a .elc file in the
;; given directory. Must go after all init-* require.
;; Source: http://ubuntuforums.org/archive/index.php/t-183638.html
;;----------------------------------------------------------------------------
(defun lw:byte-compile-directory(directory)
  (interactive
   (list
    (read-file-name "Lisp directory: ")))
  (byte-recompile-directory directory 0 t))
;;----------------------------------------------------------------------------
;; Allow access from emacsclient
;;----------------------------------------------------------------------------
(require 'server)
(unless (server-running-p)
  (server-start))

;;----------------------------------------------------------------------------
;; variables configured via the interactive 'customize' interface
;;----------------------------------------------------------------------------
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;;(set-frame-font (ype/font-name-replace-size (face-font 'default) 14) t)

;; Update info docs
(add-hook 'Info-mode-hook		; After Info-mode has started
          (lambda ()
            (setq Info-additional-directory-list Info-default-directory-list)))

(require 'init-locales)
(add-hook 'after-init-hook
          (lambda ()
            (message "init completed in %.2fms"
                     (sanityinc/time-subtract-millis after-init-time before-init-time))))

;; Time Tracking
(require 'init-wakatime)

;; Clock in default task (Daily Dose)
;; Jump: [[file:init/init-org.el::%3B%3B|%20DEFAULT%20TASK%20IDs][Default task ID function]]
;;(ype/clock-in-default-task-as-default)
;;(run-at-time "60 min" 3600 'org-agenda-list)
;;(type-break-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init.el ends here
;; Local Variables:
;; coding: utf-8
;; no-byte-compile: t
;; End:

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)
