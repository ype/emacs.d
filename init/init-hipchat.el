;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Filename: init-hipchat                                         ;;;
;;; Created: 04-02-2015                                            ;;;
;;; Author: Anton Strilchuk <anton@env.sh>                         ;;;
;;; URL: http://ype.env.sh                                         ;;;
;;; Version:                                                       ;;;
;;; Last-Updated: 17-03-2015                                       ;;;
;;;  Update #: 51                                                  ;;;
;;;   By: Anton Strilchuk <anton@env.sh>                           ;;;
;;;                                                                ;;;
;;; Description:                                                   ;;;
;;;                                                                ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(provide 'init-hipchat)

(require-package 'jabber)
(require 'jabber)

(setq jabber-history-enabled t
 jabber-use-global-history nil
 jabber-backlog-number 20
 jabber-backlog-days 5.0
 jabber-auto-reconnect t
 jabber-chat-foreign-prompt-format "%n@%t> "
 jabber-chat-local-prompt-format "%t>>> "
 jabber-groupchat-prompt-format "%n@%t> "
 jabber-groupchat-buffer-format "*-jg-%n-*"
 jabber-roster-show-bindings nil
 jabber-roster-show-title nil
 jabber-show-resources nil
 jabber-roster-buffer "*-roster-*"
 jabber-roster-line-format "%-25n %S %s"
 jabber-chat-buffer-format "*-jc-%n-*"
 jabber-muc-private-buffer-format "*-jp-%g-%n-*"
 jabber-chat-time-format "%H:%M:%S"
 jabber-rare-time-format "====================================\n%d/%m/%y %H:00\n===================================="
 jabber-chat-buffer-show-avatar nil
 jabber-chatstates-confirm nil
 jabber-show-offline-contacts nil
 jabber-events-confirm-composing t
 jabber-activity-query-unread nil
 jabber-activity-mode t
 jabber-muc-colorize-foreign t
 jabber-mode-line-compact t
 jabber-mode-line-mode t)

(add-hook 'jabber-roster-mode-hook (lambda () (toggle-truncate-lines t)))
(define-key jabber-chat-mode-map (kbd "RET") 'newline)
(define-key jabber-chat-mode-map [M-return] 'jabber-chat-buffer-send)
(add-hook 'jabber-chat-mode-hook 'goto-address)
(add-hook 'jabber-chat-mode-hook 'flyspell-mode)

;; Username & nickname fields from https://banno.hipchat.com/account/xmpp
(setq hipchat-username "19927_1625468"
      hipchat-nickname "Anton Strilchuk"
      hipchat-password nil)

(setq hipchat-autojoin-rooms
      '("adaptavist" "dell" "wallboards" "developer"
        "infrastructure_chat" "infrastructure_changes"
        "street_market_lunch" "adaptavist_football" "show__tell"))

(setq hipchat-chat-domain "chat.hipchat.com")
(setq hipchat-muc-domain "conf.hipchat.com")

(defun hipchat-join-autojoin-rooms ()
  "Log into all autojoin rooms."
  (interactive)
  (dolist (room-name hipchat-autojoin-rooms)
    (hipchat-join-room room-name)))

(defun hipchat-jack-in ()
  (interactive)
  (jabber-connect-all)
  (sauron-jabber-start)
  (hipchat-join-autojoin-rooms))

(defun hipchat-join-room (room-name)
  (interactive "sRoom (e.g. data_services): ")
  (jabber-groupchat-join (jabber-read-account) (concat (hipchat-org-id) "_" room-name "@" hipchat-muc-domain) hipchat-nickname))

(defun hipchat-jabber-id ()
  "Your personal jabber id: xxxx_yyyy@chat.hipchat.com."
  (concat hipchat-username "@" hipchat-chat-domain))

(defun hipchat-org-id ()
  "Org part of your hipchat username."
  (car (split-string hipchat-username "_")))

(defun hipchat-room-id (room-name)
  "Constructs room url, e.g. xxxx_room-name@conf.hipchat.com"
  (concat (hipchat-org-id) "_" room-name "@" hipchat-muc-domain))
(defun hipchat-decorate-nickname (nickname)
  (let* ((trimmed (replace-regexp-in-string "\\`[ \t\n]*" "" (replace-regexp-in-string "[ \t\n]*\\'" "" nickname)))
         (already-decorated (string-match "@" trimmed)))
    (if already-decorated
        trimmed
      (replace-regexp-in-string "^\\(.+?\\)\\:\\{0,1\\}$" "@\"\\1\"" trimmed))))

(defun hipchat-mention (nickname)
  "Search for a nickname, hipchat-decorate it and insert it at point."
  (interactive (list (jabber-muc-read-nickname jabber-group "Mention: ")))
  (insert (concat (hipchat-decorate-nickname nickname) " ")))

(setq hipchat-interactive-decorate-nick-marker nil)
(defun hipchat-mark-for-interactive-decorate-nick ()
  "Marks point before starting a nickname completing read."
  (interactive)
  (make-local-variable 'hipchat-interactive-decorate-nick-marker)
  (setq hipchat-interactive-decorate-nick-marker (point)))

(defun hipchat-interactive-decorate-nick-from-mark ()
  "Hipchat-decorates a nick that was marked for decoration."
  (interactive)
  (save-restriction
    (narrow-to-region hipchat-interactive-decorate-nick-marker (point))
    (let ((nick (thing-at-point 'line)))
      (delete-region (point-min) (point-max))
      (insert (concat (hipchat-decorate-nickname nick) " "))))
  (setq hipchat-interactive-decorate-nick-from-mark nil))
(setq jabber-alert-presence-hooks nil)
(defun jabber-message-content-message (from buffer text)
  (when (or jabber-message-alert-same-buffer
            (not (memq (selected-window) (get-buffer-window-list buffer))))
    (if (jabber-muc-sender-p from)
        (format "%s: %s" (jabber-jid-resource from) text)
      (format "%s: %s" (jabber-jid-displayname from) text))))
(setq jabber-alert-message-function 'jabber-message-content-message)

(add-to-list 'jabber-account-list `(,(hipchat-jabber-id)
                                    (:password . ,hipchat-password)
                                    (:network-server . ,hipchat-chat-domain)
                                    (:port . 5223)
                                    (:connection-type . ssl)))

(setq hipchat-keymap
      (let ((map (make-sparse-keymap)))
        (define-key map (kbd "TAB") 'hipchat-jabber-mention-decorator)
        (define-key map (kbd "C-x C-j m") 'hipchat-mark-for-interactive-decorate-nick)
        (define-key map (kbd "C-x C-j RET") 'hipchat-interactive-decorate-nick-from-mark)
        map))

;; ;;;###autoload
;; (define-minor-mode hipchat-mode "Hipchat Jabber mode"
;;   :group 'hipchat
;;   :lighter " hipchat"
;;   :keymap hipchat-keymap)

;; (defun turn-on-hipchat-mode ()
;;   (interactive)
;;   (hipchat-mode t))

;; (defun turn-off-hipchat-mode ()
;;   (interactive)
;;   (hipchat-mode -1))

;; (add-hook 'jabber-chat-mode-hook '(lambda () (when (search "hipchat" (buffer-name)) (turn-on-hipchat-mode))))
;; (add-hook 'jabber-lost-connection-hooks 'turn-on-hipchat-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;init-hipchat.el ends here
