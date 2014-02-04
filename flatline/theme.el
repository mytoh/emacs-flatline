;;; theme.el -*- lexical-binding: t -*-

(require 'flatline-theme-default "flatline/themes/default")

(defcustom flatline:theme 'default
  "flatline theme (symbol)")

(cl-defun flatline:set-theme (name)
  (setq flatline:theme name))

(provide 'flatline-theme)

;; Local Variables:
;; coding: utf-8
;; indent-tabs-mode: nil
;; End:
