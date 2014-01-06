;;; flatline.el --- flat modeline

;;; Code:

;;; http://amitp.blogspot.jp/2011/08/emacs-custom-mode-line.html

(eval-when-compile
  (require 'cl-lib))

(require 'flatline-face "flatline/face")
(require 'flatline-component "flatline/component")

(defgroup flatline nil
  "Faces used in the mode line."
  :group 'mode-line)

(cl-defmacro flatline:concat (&rest body)
  `(cl-concatenate 'string ,@body))

(cl-defun flatline:mode-line-left ()
  (flatline:concat
   (flatline:buffer)
   (flatline:space "  ")
   (flatline:major-mode)
   (flatline:minor-mode)))

(cl-defun flatline:mode-line-right ()
  (flatline:concat
   (propertize "(" 'face 'flatline:face-normal)
   (flatline:column)
   (propertize "," 'face 'flatline:face-normal)
   (flatline:line)
   (propertize ")" 'face 'flatline:face-normal)
   (flatline:space "  ")
   (flatline:buffer-directory)
   (flatline:space "  ")))

(defun flatline:mode-line-fill ()
  ;; justify right by filling with spaces to right fringe, 20 should be calculated
  (cl-letf* ((len (flatline:width (flatline:mode-line-right)))
             (face 'flatline:face-normal)
             (prop (if (eq 'right (get-scroll-bar-mode))
                       (propertize " " 'display '((space :align-to (- right-fringe 21)))
                                   'face face)
                     (propertize " "
                                 'display `((space :align-to (- right-fringe ,len)))
                                 'face face))))
    prop))

(cl-defun flatline:width (value)
  (if (not value)
      0
    (length (format-mode-line value))))

(cl-defun flatline:create-mode-line ()
  (concat
   (flatline:mode-line-left)
   (flatline:mode-line-fill)
   (flatline:mode-line-right)))

(cl-defun flatline:mode-line-format ()
  '(:eval
    (flatline:create-mode-line)))

(cl-defun flatline:update ()
  (setq-default mode-line-format
                (flatline:mode-line-format)))

(cl-defun flatline:mode-start ()
  (if flatline-mode
      (flatline:update)))


(define-minor-mode flatline-mode
  :init-value nil
  :group 'modeline
  (flatline:mode-start))


(provide 'flatline)

;;; flatline.el ends here
