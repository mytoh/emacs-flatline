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

(defcustom flatline:mode-line
  '(("%b" . flatline:face-buffer)
    (flatline:major-mode . flatline:face-major-mode)
    (flatline:minor-mode . flatline:face-minor-mode)
    fill
    (flatline:column . flatline:face-column)
    (flatline:line . flatline:face-line)
    (flatline:buffer-directory . flatline:face-buffer-directory))
  "mode-line-format for flatline"
  :type 'list
  :group 'flatline)

(cl-defun flatline:pad (str &optional n)
  (cl-letf ((num (or n 1)))
    (if (string-empty-p str)
        str
      (cl-concatenate 'string
                      (make-string num ? )
                      str
                      (make-string num ? )))))

(cl-defun flatline:make-component (comp)
  (cl-typecase comp
    (cons (flatline:make-component-list comp))
    (string (flatline:make-component-string comp))
    (symbol (flatline:make-component-symbol comp))))

(cl-defun flatline:make-component-string (comp)
  (flatline:pad comp))

(cl-defun flatline:make-component-list (comp)
  (cl-typecase (car comp)
    (string
     (cl-letf ((str (flatline:pad (car comp)))
               (face (cdr comp)))
       `(:propertize ,str face ,face)))
    (symbol
     (cl-case (car comp)
       (fill `(:eval (flatline:make-component-fill ',(cdr comp))))
       (t (cond ((and (fboundp (car comp))
                      (facep (cdr comp)))
                 `(:eval
                   ((lambda ()
                      (propertize (flatline:pad (,(car comp)))
                                  'face ',(cdr comp))))))))))))

(cl-defun flatline:make-component-symbol (comp)
  (cl-case comp
    (fill `(:eval (flatline:make-component-fill 'flatline:face-normal)))
    (t (cond ((fboundp comp)
              `(:eval
                (,comp)))))))

(cl-defun flatline:make-component-fill (face)
  (cl-letf* ((right-comps (cdr (or (cl-member 'fill flatline:mode-line)
                                   (cl-member-if (lambda (x)
                                                   (if (consp x)
                                                       (equalp 'fill (car x))
                                                     nil))
                                                 flatline:mode-line))))
             (rlen (flatline:width (cl-mapcar 'flatline:make-component right-comps))))
    (if (eq 'right (get-scroll-bar-mode))
        (propertize " " 'display '((space :align-to (- right 21)))
                    'face face)
      (propertize " "
                  'display `((space :align-to (- right ,rlen)))
                  'face face))))

(cl-defun flatline:width (value)
  (if (not value)
      0
    (length (format-mode-line value))))

(cl-defun flatline:set ()
  (setq-default mode-line-format
                (cl-mapcar
                 'flatline:make-component
                 flatline:mode-line)))

(cl-defun flatline:update ()
  (setq mode-line-format
        (cl-mapcar
         'flatline:make-component
         flatline:mode-line))
  (force-mode-line-update))

(cl-defun flatline:mode-start ()
  (if flatline-mode
      (flatline:set)))

(cl-defun flatline-update ()
  (interactive)
  (flatline:update))

(define-minor-mode flatline-mode
  :init-value nil
  :group 'modeline
  (flatline:mode-start))


(provide 'flatline)

;;; flatline.el ends here
