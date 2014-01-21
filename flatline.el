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


(defvar flatline:mode-line
  '(("%b" . flatline:face-buffer)
    (flatline:major-mode . flatline:face-major-mode)
    (flatline:minor-mode . flatline:face-minor-mode)
    fill
    (flatline:column . flatline:face-column)
    (flatline:line . flatline:face-line)
    (flatline:buffer-directory . flatline:face-buffer-directory)
    ))

(cl-defun my-buffer-name ()
  (buffer-name (current-buffer)))

(cl-defun flatline:make-component (comp)
  (cl-typecase comp
    (cons (flatline:make-component-list comp))
    (string (flatline:make-component-string comp))
    (symbol (flatline:make-component-symbol comp))))

(cl-defun flatline:make-component-string (comp)
  (cl-concatenate 'string
                  " "
                  comp
                  " "))

(cl-defun flatline:make-component-list (comp)
  (cl-typecase (car comp)
    (string
     (propertize (cl-concatenate 'string
                                 " "
                                 (car comp)
                                 " ")
                 'face (cdr comp)))
    (symbol
     `(:eval
       ((lambda ()
          (propertize (cl-concatenate 'string
                                      " "
                                      (,(car comp))
                                      " ")
                      'face ',(cdr comp))))))))

(cl-defun flatline:make-component-symbol (comp)
  (cl-case comp
    (fill `(:eval (flatline:make-component-fill)))
    (t (cond ((fboundp comp)
              `(:eval
                ((cl-concatenate 'string
                                       " "
                                       (,comp)
                                       " "))))))))

(cl-defun flatline:make-component-fill ()
  (cl-letf* ((right-comps (cdr (cl-member 'fill flatline:mode-line)))
             (len (flatline:width (cl-mapcar 'flatline:make-component right-comps)))
             (face 'flatline:face-normal))
    (if (eq 'right (get-scroll-bar-mode))
        (propertize " " 'display '((space :align-to (- right 21)))
                    'face face)
      (propertize " "
                  'display `((space :align-to (- right (- ,len 3))))
                  'face face))))

(cl-defun flatline:width (value)
  (if (not value)
      0
    (length (format-mode-line value))))

(cl-defun flatline:update ()
  (setq-default mode-line-format
                (cl-mapcar
                 'flatline:make-component
                 flatline:mode-line)))

(cl-defun flatline:mode-start ()
  (if flatline-mode
      (flatline:update)))

(define-minor-mode flatline-mode
  :init-value nil
  :group 'modeline
  (flatline:mode-start))


(provide 'flatline)

;;; flatline.el ends here
