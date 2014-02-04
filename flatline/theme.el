;;; theme.el -*- lexical-binding: t -*-

(require 'flatline-theme-default "flatline/themes/default")
(require 'flatline-theme-solarized-dark "flatline/themes/solarized-dark")

(defcustom flatline:theme 'default
  "flatline theme (symbol)")

(cl-defun flatline:set-theme (name)
  (setq flatline:theme name))

(cl-defun flatline:theme-get-face (part)
  (intern
   (string-join `( "flatline"
                   "theme"
                   ,(symbol-name flatline:theme)
                   ,(symbol-name part)) "-")))

(provide 'flatline-theme)

;; Local Variables:
;; coding: utf-8
;; indent-tabs-mode: nil
;; End:
