;;; flatline-window -*- lexical-binding: t; coding: utf-8; -*-

;;; Code:

;; code from [[github.com/milkypostman/powerline]]

(defvar flatline:*selected-window* nil)

(defun flatline:set-selected-window ()
  "sets the variable `flatline-selected-window` appropriately"
  (when (not (minibuffer-window-active-p (frame-selected-window)))
    (setq flatline:*selected-window* (frame-selected-window))))

(add-hook 'window-configuration-change-hook 'flatline:set-selected-window)
(add-hook 'focus-in-hook 'flatline:set-selected-window)
(add-hook 'focus-out-hook 'flatline:set-selected-window)

(defadvice select-window (after flatline:select-window activate)
  "makes powerline aware of window changes"
  (flatline:set-selected-window))

(defun flatline:selected-window-active-p ()
  "Return whether the current window is active."
  (eq flatline:*selected-window* (selected-window)))

(provide 'flatline-window)

;;; flatline-window.el ends here
