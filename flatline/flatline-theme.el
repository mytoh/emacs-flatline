;;; theme.el -*- lexical-binding: t -*-

(require 'glof)
(require 'flatline-theme-default "flatline/themes/default")
(require 'flatline-theme-solarized-dark "flatline/themes/solarized-dark")

(defcustom flatline:theme 'default
  "flatline theme (symbol)")

(cl-defun flatline:set-theme (name)
  (setq flatline:theme name))

(cl-defun flatline:theme-get-face (part)
  (cl-letf* ((active-name
              (intern (string-join
                       `( "flatline"
                          ,(symbol-name flatline:theme)
                          ,(glof:string part))
                       "-")))
             (inactive-name
              (intern (string-join
                       `( "flatline"
                          ,(symbol-name flatline:theme)
                          ,(glof:string part)
                          "inactive")
                       "-"))))
    (if (flatline:selected-window-active-p)
        active-name
      (if (facep inactive-name)
          inactive-name
        active-name))))

(provide 'flatline-theme)

;; Local Variables:
;; coding: utf-8
;; indent-tabs-mode: nil
;; End:
