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

(cl-defun flatline:mode-line-format ()
  (list
   (flatline:space "  ")
   ;; buffer
   (flatline:buffer)
   (flatline:space " ")

   ;; directory
   (flatline:buffer-directory)
   (flatline:space "  ")
   ;; eol
   (flatline:eol-desc)
   (flatline:space "  ")
   ;; modified
   (flatline:modified)
   ;; column
   '(:eval (propertize "(" 'face 'flatline:face-normal))
   (flatline:column)
   '(:eval (propertize "," 'face 'flatline:face-normal))
   (flatline:line)
   '(:eval (propertize ")" 'face 'flatline:face-normal))
   (flatline:space "  ")
   ;; vc mode
   (flatline:vc-mode)
   (flatline:space "  ")

   '(:eval (propertize "(" 'face 'flatline:face-normal))
   ;; major mode
   (flatline:major-mode)
   ;; minor mode
   (flatline:minor-mode)
   '(:eval (propertize ")" 'face 'flatline:face-normal))

   (flatline:space "  ")
   ;; misc inf
   (flatline:misc-info)
   (flatline:space "  ")
   ;; nyan
   (flatline:nyan-mode)))


(cl-defun flatline:mode-start ()
  (if flatline-mode
      (setq-default mode-line-format
                    (flatline:mode-line-format))))


(define-minor-mode flatline-mode
  :init-value nil
  :group 'modeline
  (flatline:mode-start))


(provide 'flatline)

;;; flatline.el ends here
