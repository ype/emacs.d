;; Block use of arrow keys
;; (global-unset-key (kbd "<left>"))
;; (global-unset-key (kbd "<right>"))
;; (global-unset-key (kbd "<up>"))
;; (global-unset-key (kbd "<down>"))
;; (global-unset-key (kbd "<C-left>"))
;; (global-unset-key (kbd "<C-right>"))
;; (global-unset-key (kbd "<C-up>"))
;; (global-unset-key (kbd "<C-down>"))
;; (global-unset-key (kbd "<M-left>"))
;; (global-unset-key (kbd "<M-right>"))
;; (global-unset-key (kbd "<M-up>"))
;; (global-unset-key (kbd "<M-down>"))

;;Key modifiers
(unless *is-x-toolkit*
  (setq ns-option-modifier 'meta)
  (setq ns-command-modifier 'super)
  (setq ns-right-command-modifier 'hyper)
  (setq ns-right-option-modifier 'alt)
  (setq ns-right-control-modifier 'nil))

(global-set-key (kbd "M-SPC") 'set-mark-command)

;;Quick Open init.el C-x r j e
(set-register ?e (cons 'file "~/.emacs.d/init.el"))

;;Quick Open Cask
(set-register ?c (cons 'file "~/.emacs.d/Cask"))

;;Quick switch text wrap off
(global-set-key (kbd "H-w") 'y_pe/kill-global-wrap)

;;Quick switch text wrap on
(global-set-key (kbd "H-W") 'y_pe/global-wrap)

;;Window move
(windmove-default-keybindings 'super)

;;Switch tabbar to show by major-mode
(defun y_pe/tabbar-group-by-mode ()
  (interactive)
  (tabbar-switch-grouping-method '1))

;;Buffer Switch Remap
(global-set-key (kbd "H-[") 'tabbar-backward-tab)
(global-set-key (kbd "H-]") 'tabbar-forward-tab)
(global-set-key (kbd "H-{") 'tabbar-backward-group)
(global-set-key (kbd "H-}") 'tabbar-forward-group)

;;Switch between two (or more) emacs windows
;;(global-set-key (kbd "C-s-<right>") 'other-frame)
;;(global-set-key (kbd "C-s-<left>") 'other-frame)

;;Recent file open
(global-set-key (kbd "A-/") 'recentf-open-files)

;;Comment out
(global-set-key (kbd "C-;") 'comment-or-uncomment-region)

;;SMEX Keys
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-x x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

;;Yas Keys
;; (define-key yas-minor-mode-map [(tab)] nil) ;;Turn off default tab complete
;; (define-key yas-minor-mode-map (kbd "TAB") nil) ;;Set tab to yas
;; (setq yas/trigger-key (kbd "C-'"))  ;;Set alternate yas key
;; (add-hook 'yas/minor-mode-on-hook
;;           (define-key yas-minor-mode-map yas/trigger-key 'yas-expand))

;;Multiple Cursors
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;;Orgmode
(define-key global-map (kbd "H-a") 'org-agenda)
(define-key global-map (kbd "A-i") 'org-clock-in)
(define-key global-map (kbd "A-o") 'org-clock-out)
(define-key global-map (kbd "A-l") 'org-store-link)
(define-key global-map (kbd "A-L") 'org-insert-link)
(define-key global-map (kbd "A-a") 'org-archive-set-tag)
(define-key global-map (kbd "A-f") 'org-refile)
(define-key global-map (kbd "A-F") 'org-refile-goto-last-stored)
(define-key global-map (kbd "A-r") 'org-capture)
(define-key global-map (kbd "A-p") 'y_pe/phone-call)
(define-key global-map (kbd "A-d") 'y_pe/clock-in-default-task-as-default)
(define-key global-map (kbd "A-e") 'y_pe/clock-in-default-email)
(define-key global-map (kbd "A-c") 'y_pe/clock-in-default-elisp)
(define-key global-map (kbd "A-s") 'y_pe/clock-in-default-school)
(define-key global-map (kbd "A-t") 'org-clock-select-task)
(define-key global-map (kbd "H-e") 'org-set-effort)

;;MAP SET/JUMP Bookmarks fast nav
(global-set-key (kbd "A-q") '(lambda () (interactive) (bookmark-set "SAVED")))
(global-set-key (kbd "A-w") '(lambda () (interactive) (bookmark-jump "SAVED")))

;;Helm
(global-set-key (kbd "C-c c") 'ac-complete-with-helm)
;;Helm projectile
(global-set-key (kbd "C-c h") 'helm-projectile)

;;Helm gtags lookup
(global-set-key (kbd "A-j l") 'helm-gtags-select)
;;Helm jump to definition
(global-set-key (kbd "A-j j") 'helm-gtags-find-tag)

;; Helm Kill Ring
(global-set-key (kbd "C-c C-SPC") 'helm-show-kill-ring)

;;Flyspell
(global-set-key (kbd "M-s p") 'ispell-region)
(global-set-key (kbd "M-s M-s") 'ispell-word)

;;Run shit in iterm tmux
(global-set-key (kbd "H-d") 'y_pe/lldb-tmux-send)
(global-set-key (kbd "H-r") 'y_pe/lldb-tmux-run)
(global-set-key (kbd "H-t") 'y_pe/tmux-any-send)
(global-set-key (kbd "H-x") 'y_pe/xcodebuild)

;;Sudo Search
(defun y_pe/sudo-find()
  (interactive)
  (find-file "/sudo::/etc/passwd"))
(global-set-key (kbd "H-f") 'y_pe/sudo-find)

;;Reload Browser
(global-set-key (kbd "C-x C-r") 'y_pe/reload-browser)

;;Webjump
(global-set-key (kbd "s-j") 'webjump)


(defun paste-giant-comment-line ()
  (interactive)
  (comment-dwim nil)
  (insert "-----------------------------------------------------------------------------")
  (newline-and-indent))
;; Paste giant comment line
;; -----------------------------------------------------------------------------
(global-set-key (kbd "H-;") 'paste-giant-comment-line)

(provide 'init-keybindings)