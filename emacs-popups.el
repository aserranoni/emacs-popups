;;; emacs-popups.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2024 Ariel Serranoni
;;
;; Author: Ariel Serranoni <arielserranoni@gmail.com>
;; Maintainer: Ariel Serranoni <arielserranoni@gmail.com>
;; Created: September 29, 2024
;; Modified: September 29, 2024
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex tools unix vc wp
;; Homepage: https://github.com/aserranoni/emacs-popups
;; Package-Requires: ((emacs "29.1"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary: Package based on Prot's blog post
;;
;;  Description
;;
;;; Code:

;;;###autoload

(defun emacs-popups-popup-frame-delete (&rest _)
  "Kill selected frame if it has parameter `popup-frame'."
  (when (frame-parameter nil 'popup-frame)
    (delete-frame)))

(defmacro emacs-popups-popup-frame-define (command title &optional delete-frame)
  "Define interactive function to call COMMAND in frame with TITLE."
  `(defun ,(intern (format "popup-frame-%s" command)) ()
     (interactive)
     (let* ((display-buffer-alist '(("")
                                    (display-buffer-full-frame)))
            (frame (make-frame
                    '((title . ,title)
                      (window-system . ns)
                      (popup-frame . t)))))
       (select-frame frame)
       (switch-to-buffer " popup-frame-hidden-buffer")
       (condition-case nil
           (progn
             (call-interactively ',command)
             (delete-other-windows))
         (error (delete-frame frame)))
       (when ,delete-frame
         (sit-for 0.2)
         (popup-frame-delete frame)))))

(defmacro emacs-popups-popup-minibuffer-define (command title &optional)
  "Define interactive function to call COMMAND in frame with TITLE."
  `(defun ,(intern (format "minibuffer-frame-%s" command)) ()
     (interactive)
     (let* ((display-buffer-alist '(("")
                                    (display-buffer-full-frame)))
            (frame (make-frame
                    '((minibuffer . only)
                      (title . ,title)
                      (window-system . ns)
                      (popup-frame . t)))))
       (select-frame frame)
       (condition-case err
           (progn
             (call-interactively ',command)
             (delete-frame))
         (error (delete-frame frame))
         (quit (delete-frame frame))))))

(provide 'emacs-popups)
;;; emacs-popups.el ends here
