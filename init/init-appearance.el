;;; -*- mode: Emacs-Lisp; tab-width: 2; indent-tabs-mode:nil; -*-  ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Author: Anton Strilchuk <anton@isoty.pe>                       ;;;
;;; URL: http://isoty.pe                                           ;;;
;;; Created: 24-03-2014                                            ;;;
;;; Last-Updated: 29-03-2014                                       ;;;
;;;   By: Anton Strilchuk <anton@isoty.pe>                         ;;;
;;;                                                                ;;;
;;; Filename: init-appearance                                      ;;;
;;; Description: Setup for the look and feel of emacs              ;;;
;;; Files Required: init-theme                                     ;;;
;;;                                                                ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Default theme
(dark)

;;; Wrap Text
(global-visual-line-mode 1)

;;; Highlight Cursor Line
(global-hl-line-mode 1)

;;; Column Numbers
(column-number-mode 1)

;;; Remove Toolbar
(tool-bar-mode -1)

;;; Remove scrollbar
(scroll-bar-mode -1)

(require 'pretty-mode)
(global-pretty-mode t)

;;Make things look pretty
(require 'pretty-symbols)

;;Less Flickery Display
(setq redisplay-dont-pause t)

;;Don't display battery life
(display-battery-mode -1)
(size-indication-mode -1)

;; Nicer scrolling with mouse wheel/trackpad.
(unless (and (boundp 'mac-mouse-wheel-smooth-scroll) mac-mouse-wheel-smooth-scroll)
  (global-set-key [wheel-down] (lambda () (interactive) (scroll-up-command 1)))
  (global-set-key [wheel-up] (lambda () (interactive) (scroll-down-command 1)))
  (global-set-key [double-wheel-down] (lambda () (interactive) (scroll-up-command 2)))
  (global-set-key [double-wheel-up] (lambda () (interactive) (scroll-down-command 2)))
  (global-set-key [triple-wheel-down] (lambda () (interactive) (scroll-up-command 4)))
  (global-set-key [triple-wheel-up] (lambda () (interactive) (scroll-down-command 4))))

(setq-default scroll-up-aggressively 0.01 scroll-down-aggressively 0.01)

(defun disable-all-pretty-highlighting ()
  "Quick function to turn off pretty-mode when it gets annoying"
  (pretty-mode -1)
  (pretty-symbols-mode -1))

;;Page break line mode
(require 'page-break-lines)
(global-page-break-lines-mode)
"Examples Line below ^L (C-q C-l)"


;;Highlight
;;FIXME
;;TODO
;; (require 'fic-ext-mode)
;; (defun fic-ext-mode-modes ()
;;   (interactive)
;;   (add-hook 'emacs-lisp-mode-hook 'fic-ext-mode)
;;   (add-hook 'lisp-mode-hook 'fic-ext-mode)
;;   (add-hook 'web-mode-hook 'fic-ext-mode)
;;   (add-hook 'c-mode-common-hook 'fic-ext-mode)
;;   (add-hook 'python-mode-hook 'fic-ext-mode))
;;(fic-ext-mode-modes)

;;(require 'wiki-nav)
;;(global-wiki-nav-mode)

(provide 'init-appearance)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-appearance.el ends here
