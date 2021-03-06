;;; -*- mode: Emacs-Lisp; tab-width: 2; indent-tabs-mode:nil; -*-  ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Author: Anton Strilchuk <anton@isoty.pe>                       ;;;
;;; URL: http://isoty.pe                                           ;;;
;;; Created: 20-05-2014                                            ;;;
;; Last-Updated: 16-11-2014                                         ;;
;;   By: Anton Strilchuk <anton@env.sh>                             ;;
;;;                                                                ;;;
;;; Filename: init-web                                             ;;;
;;; Version:                                                       ;;;
;;; Description:                                                   ;;;
;;;                                                                ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'init-nxml)
(require 'init-css)
;;Web Mode
(require-package 'web-mode)
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(setq web-mode-extra-auto-pairs
      '(("erb"  . (("open" "close")))
        ("php"  . (("open" "close")
                   ("open" "close")))
        ))
(defun web-mode-hook ()
  (add-hook 'local-write-file-hooks
            (lambda ()
              (delete-trailing-whitespace)
              nil)))

(add-hook 'web-mode-hook  'web-mode-hook)

;;Emmet
(require-package 'emmet-mode)
(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.


;;,---------------
;;| WebDev Helpers
;;`---------------
(require-package 'know-your-http-well)
(require-package 'restclient)
(add-to-list 'auto-mode-alist '("\\.rest\\'" . restclient-mode))



(provide 'init-web)
