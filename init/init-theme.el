;;; -*- mode: Emacs-Lisp; tab-width: 2; indent-tabs-mode:nil; -*-  ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Author: Anton Strilchuk <anton@isoty.pe>                       ;;;
;;; URL: http://isoty.pe                                           ;;;
;;; Created: 24-03-2014                                            ;;;
;;; Last-Updated: 02-01-2015                                       ;;;
;;;   By: Anton Strilchuk <anton@env.sh>                           ;;;
;;;                                                                ;;;
;;; Filename: init-theme                                           ;;;
;;; Description: Setup for: Color-theme, Powerline, and tabbars    ;;;
;;;                                                                ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(provide 'init-theme)
;;;Powerline
(require-git-submodule 'powerline t)
(powerline-vim-theme)
(package-install 'sublime-themes)
(add-to-list 'load-path (expand-file-name "~/Dropbox/ype/emacs-packages/36-symbols-theme/"))
(require '36-symbols-theme)

;;(require '36-symbols)
;;(setq 36-symbols-high-contrast-mode-line nil)
;; Change Light Based on OSX Ambient Light Sensor Values
(setq direct-sun 44000000)

(setq ambient-light 1)

;;(setq light-theme '36-symbols-light)
(setq dark-theme '36-symbols)
(setq light-theme 'mccarthy)

(defun light-level ()
  "Access the level of light detected by the LMU sensor on Macbook Pros"
  (string-to-number (shell-command-to-string "~/.emacs.d/light/LMU-sensor")))

(defun adjust-theme-to-light ()
  "Picks a theme according to the level of ambient light in the room"
  (cond ((= ambient-light 1)
         (if (> (light-level) direct-sun)
             (progn
               (enable-theme light-theme)
               (disable-theme dark-theme))
           (progn
             (enable-theme dark-theme)
             (disable-theme light-theme))))
        ((= ambient-light 0)
         (message "LMU Theme Switcher Disabled"))))

(defun ype:toggle-lmu-theme-switch-on ()
  (interactive)
  (setq ambient-light 1)
  (adjust-theme-to-light))

(defun ype:toggle-lmu-theme-switch-off ()
  (interactive)
  (setq ambient-light 0))

;;,-------------------------------------------------
;;| Change theme based on OSX ambient light sensor
;;| BUG: Occasionally Crashes Emacs
;;|
;;| eg. check light sensor every hour
;;`-------------------------------------------------
(run-at-time 0 (* 60 60) 'adjust-theme-to-light)
