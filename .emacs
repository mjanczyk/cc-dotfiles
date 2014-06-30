;;; -*- lexical-binding: t -*-

;;; ------------------------------------------------------------
;;;                     chrome & setup
;;; ------------------------------------------------------------

(tool-bar-mode -1)
(menu-bar-mode -1)

(add-to-list 'load-path "~/.emacs.d/")

(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/") t)

;;; ------------------------------------------------------------
;;;                  c/c++ config
;;; ------------------------------------------------------------

(defun my-cc-hook ()
  (setq c-basic-offset 4)
  (setq tab-width 4)
  (setq indent-tabs-mode nil))
(add-hook 'c-mode-hook 'my-cc-hook)

(setq tab-always-indent 'complete)
(add-to-list 'completion-styles 'initials t)

;;; ------------------------------------------------------------
;;;                window navigation
;;; ------------------------------------------------------------

(defun ignore-error-wrapper (fn)
  "Funtion return new function that ignore errors.
   The function wraps a function with `ignore-errors' macro."
  (let ((fn fn))
    (lambda ()
      (interactive)
      (ignore-errors
        (funcall fn)))))

(global-set-key (kbd "S-<left>")  (ignore-error-wrapper 'windmove-left))
(global-set-key (kbd "S-<right>") (ignore-error-wrapper 'windmove-right))
(global-set-key (kbd "S-<up>")    (ignore-error-wrapper 'windmove-up))
(global-set-key (kbd "S-<down>")  (ignore-error-wrapper 'windmove-down))

;;; ------------------------------------------------------------
;;;                        typeface
;;; ------------------------------------------------------------

(set-face-attribute 'default nil :font "Source Code Pro Light 9")
(set-frame-font "Source Code Pro Light 9")

;;; ------------------------------------------------------------
;;;                emacs-clang-complete-async
;;; ------------------------------------------------------------
(require 'auto-complete-clang-async)

(defun ac-cc-mode-setup ()
  (setq ac-clang-complete-executable "~/.emacs.d/clang-complete")
  (setq ac-sources '(ac-source-clang-async))
  (ac-clang-launch-completion-process)
)

(defun ac-common-setup ()
  (setq ac-clang-cflags
	(mapcar (lambda (item) (concat "-I" item))
		(split-string
		 "
 /usr/include/c++/4.6
 /usr/include/c++/4.6/x86_64-linux-gnu/.
 /usr/include/c++/4.6/backward
 /usr/lib/gcc/x86_64-linux-gnu/4.6.1/include
 /usr/local/include
 /usr/lib/gcc/x86_64-linux-gnu/4.6.1/include-fixed
 /usr/include/x86_64-linux-gnu
 /usr/include
 /home/mjanczyk/Projects/ffmpeg-h264-tc/libavcodec
 /home/mjanczyk/Projects/ffmpeg-h264-tc/libavformat
 /home/mjanczyk/Projects/ffmpeg-h264-tc/libavutil
"
               )))
  )

(defun my-ac-config ()
  (add-hook 'c-mode-common-hook 'ac-cc-mode-setup)
  (add-hook 'auto-complete-mode-hook 'ac-common-setup)
  (global-auto-complete-mode t))

(my-ac-config)
