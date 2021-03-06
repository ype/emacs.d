;;; -*- mode: Emacs-Lisp; tab-width: 2; indent-tabs-mode:nil; -*-  ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Author: Anton Strilchuk <anton@isoty.pe>                       ;;;
;;; URL: http://isoty.pe                                           ;;;
;;; Created: 07-04-2014                                            ;;;
;;; Last-Updated: 11-03-2015                                       ;;;
;;;   By: Anton Strilchuk <anton@env.sh>                           ;;;
;;;                                                                ;;;
;;; Filename: init-git                                             ;;;
;;; Description: Git Setup                                         ;;;
;;;                                                                ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require-package 'magit)
(require-package 'git-blame)
(require-package 'git-gutter-fringe)
(require-package 'git-commit-mode)
(require-package 'git-rebase-mode)
(require-package 'gitignore-mode)
(require-package 'gitconfig-mode)
(require-package 'git-messenger)
(require-package 'git-timemachine)

(setq-default
 magit-save-some-buffers nil
 magit-process-popup-time 10
 magit-diff-refine-hunk t
 magit-completing-read-function 'magit-ido-completing-read)

;; Hint: customize `magit-repo-dirs' so that you can use H-s to
;; quickly open magit on any one of your projects.
;;Magit
(global-set-key (kbd "H-s") 'magit-status)
(global-set-key (kbd "H-l") 'magit-log)

(after-load 'magit
  (define-key magit-status-mode-map (kbd "C-M-<up>") 'magit-goto-parent-section))

(global-set-key (kbd "H-x b") 'magit-blame-mode)

(after-load 'magit
  (defadvice magit-status
      (around magit-fullscreen activate)
    (window-configuration-to-register :magit-status-fullscreen)
    ad-do-it
    (delete-other-windows))

  (defadvice magit-log
      (around magit-fullscreen activate)
    (window-configuration-to-register :magit-log-fullscreen)
    ad-do-it
    (delete-other-windows))

  (defun magit-status-quit-session ()
    "Restores the previous window configuration and kills the magit buffer"
    (interactive)
    (kill-buffer)
    (when (get-register :magit-status-fullscreen)
      (ignore-errors
        (jump-to-register :magit-status-fullscreen))))

    (defun magit-log-quit-session ()
    "Restores the previous window configuration and kills the magit buffer"
    (interactive)
    (kill-buffer)
    (when (get-register :magit-log-fullscreen)
      (ignore-errors
        (jump-to-register :magit-log-fullscreen))))

    (define-key magit-status-mode-map (kbd "q") 'magit-status-quit-session)
    (define-key magit-log-mode-map (kbd "q") 'magit-log-quit-session))

;; When we start working on git-backed files, use git-wip if available
(after-load 'magit
  (global-magit-wip-save-mode 1)
  (diminish 'magit-wip-save-mode))

(after-load 'magit
  (diminish 'magit-auto-revert-mode))

;; Use the fringe version of git-gutter
(require 'git-gutter-fringe)
(global-git-gutter-mode +1)
(setq git-gutter:lighter " ♊ƒ")
(setq-default right-fringe-width  10)
(setq git-gutter-fr:side 'right-fringe)
(set-face-foreground 'git-gutter-fr:modified "#33CCFF")
(set-face-foreground 'git-gutter-fr:added "#3CCF33")
(set-face-foreground 'git-gutter-fr:deleted "#FF33CF")

(when *is-a-mac*
  (after-load 'magit
    (add-hook 'magit-mode-hook (lambda () (local-unset-key [(meta h)])))))

;; git-svn support
(require-package 'magit-svn)
(autoload 'magit-svn-enabled "magit-svn")
(defun sanityinc/maybe-enable-magit-svn-mode ()
  (when (magit-svn-enabled)
    (magit-svn-mode)))
(add-hook 'magit-status-mode-hook #'sanityinc/maybe-enable-magit-svn-mode)

(after-load 'compile
  (dolist (defn (list '(git-svn-updated "^\t[A-Z]\t\\(.*\\)$" 1 nil nil 0 1)
                      '(git-svn-needs-update "^\\(.*\\): needs update$" 1 nil nil 2 1)))
    (add-to-list 'compilation-error-regexp-alist-alist defn)
    (add-to-list 'compilation-error-regexp-alist (car defn))))

(defvar git-svn--available-commands nil "Cached list of git svn subcommands")

(defun git-svn (dir)
  "Run a git svn subcommand in DIR."
  (interactive "DSelect directory: ")
  (unless git-svn--available-commands
    (setq git-svn--available-commands
          (sanityinc/string-all-matches
           "^  \\([a-z\\-]+\\) +"
           (shell-command-to-string "git svn help") 1)))
  (let* ((default-directory (vc-git-root dir))
         (compilation-buffer-name-function (lambda (major-mode-name) "*git-svn*")))
    (compile (concat "git svn "
                     (ido-completing-read "git-svn command: " git-svn--available-commands nil t)))))

(require-package 'git-messenger)
(global-set-key (kbd "H-x p") #'git-messenger:popup-message)

;; github
(require-package 'gist) ; for gist-list
(require-package 'yagist) ; for yagist-region-or-buffer...
(global-set-key (kbd "H-x 1") 'yagist-region-or-buffer-private)
(global-set-key (kbd "H-x 2") 'yagist-region-or-buffer)
(global-set-key (kbd "H-x \`") 'gist-list)

(require-package 'github-browse-file)
(require-package 'bug-reference-github)
(add-hook 'prog-mode-hook 'bug-reference-prog-mode)

;; Git Clone the easy way
(defun git-clone (user repo directory)
  (interactive "sUser: \nsRepo: \nDTo: ")
  (async-shell-command
   (concat "git clone git@github.com:" user "/" repo ".git " directory repo))
  (message "%s/%s To: %s" user repo directory))

;; Git Training Wheels
(require-package 'git-commit-training-wheels-mode)
(add-hook 'git-commit-mode-hook 'git-commit-training-wheels-mode)

;; Check Git on Quit
(require-package 'vc-check-status)
(vc-check-status-activate 1)

(provide 'init-git)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-git.el ends here
