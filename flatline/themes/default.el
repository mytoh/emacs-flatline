;;; default.el -*- lexical-binding: t -*-

(cl-defun flatline:theme-get-face (part)
  (intern
   (string-join `( "flatline"
                   "theme"
                   ,(symbol-name flatline:theme)
                   ,(symbol-name part)) "-")))

(defface flatline-theme-default-edge
  '((t (:foreground "gray10"
                    :background "Cadetblue3"
                    :box nil)))
  "face for left")

(defface flatline-theme-default-sub
  '((t (:foreground "gray70"
                    :background  "#123550"
                    :box nil)))
  "face for sub")

(defface flatline-theme-default-sub-sub
  '((t (:foreground  "white"
                     :background  "#112230"
                     :box nil)))
  "face for left sub sub")

(provide 'flatline-theme-default)

;; Local Variables:
;; coding: utf-8
;; indent-tabs-mode: nil
;; End:
