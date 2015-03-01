;;; flatline.el --- flat modeline -*- lexical-binding: t -*-

;;; Code:

;;; http://amitp.blogspot.jp/2011/08/emacs-custom-mode-line.html

(require 'cl-lib)
(require 'seq)

(require 'flatline-face "flatline/flatline-face")
(require 'flatline-pulse "flatline/flatline-pulse")
(require 'flatline-theme "flatline/flatline-theme")
(require 'flatline-window "flatline/flatline-window")

(defgroup flatline nil
  "Faces used in the mode line."
  :group 'mode-line)

(defcustom flatline:mode-line
  '(("%b" . flatline:buffer)
    (flatline:major-mode . flatline:major-mode)
    (flatline:minor-mode . flatline:minor-mode)
    fill
    (flatline:column . flatline:column)
    (flatline:line . flatline:line)
    (flatline:buffer-directory . flatline:buffer-directory))
  "mode-line-format for flatline"
  :type 'list
  :group 'flatline)

(cl-defun flatline:pad (str &optional n)
  (cl-letf ((num (or n 1)))
    (pcase str
      ("" str)
      (_ (cl-concatenate 'string
                         (make-string num ?\s)
                         str
                         (make-string num ?\s))))))

(cl-defmethod flatline:make-pulse ((pulse string))
  (flatline:pad pulse))

(cl-defmethod flatline:make-pulse ((pulse list))
  (pcase-let ((`(,value . ,sym) pulse))
    (cl-typecase value
      (string
       (pcase sym
         ((pred facep)
          (cl-letf ((str (flatline:pad value))
                    (face sym))
            `(:propertize ,str face ,face)))
         ((pred symbolp)
          (cl-letf ((str (flatline:pad value))
                    (face (flatline:theme-get-face sym)))
            `(:propertize ,str face ,face)))))
      (symbol
       (pcase value
         (`fill
          `(:eval (flatline:make-pulse-fill ',sym)))
         ((and (pred fboundp)
               (guard (facep sym)))
          `(:eval
            ((lambda ()
               (propertize (flatline:pad (,value))
                           'face ',sym)))))
         ((and (pred fboundp)
               (guard (symbolp sym)))
          `(:eval
            ((lambda ()
               (propertize (flatline:pad (,value))
                           'face ',(flatline:theme-get-face sym)))))))))))

(cl-defmethod flatline:make-pulse ((pulse symbol))
  (pcase pulse
    (`fill `(:eval (flatline:make-pulse-fill
                    (flatline:theme-get-face 'fill))))
    (_ (cond ((fboundp pulse)
              `(:eval
                (,pulse)))))))

(cl-defun flatline:make-pulse-fill (face)
  (cl-letf* ((face (cond ((facep face) face)
                         ((symbolp face) (flatline:theme-get-face face))))
             (right-pulses (cl-rest (or (cl-member 'fill flatline:mode-line)
                                        (cl-member-if (lambda (x)
                                                        (if (consp x)
                                                            (cl-equalp 'fill (cl-first x))
                                                          nil))
                                                      flatline:mode-line))))
             (rlen (flatline:width (seq-map #'flatline:make-pulse right-pulses))))
    (if (eq 'right (get-scroll-bar-mode))
        (propertize " " 'display `((space :align-to (- right-fringe ,(+ 1 rlen))))
                    'face face)
      (propertize " "
                  'display `((space :align-to (- right-fringe ,(+ 4 rlen))))
                  'face face))))

(cl-defun flatline:add (pulse)
  (if (and (boundp 'flatline:mode-line)
           (not (null flatline:mode-line)))
      (setq flatline:mode-line
            (append flatline:mode-line (list pulse)))
    (setq flatline:mode-line `(,pulse))))

(cl-defun flatline:width (value)
  (if (not value)
      0
    (string-width
     (format-mode-line value))))

(cl-defun flatline:set-default ()
  (setq-default mode-line-format
                (seq-map
                 #'flatline:make-pulse
                 flatline:mode-line)))

(cl-defun flatline:update ()
  (flatline:set-default)
  (force-mode-line-update))

(cl-defun flatline:mode-start ()
  (if flatline-mode
      (flatline:update)))

(cl-defun flatline-update ()
  (interactive)
  (flatline:update))

(define-minor-mode flatline-mode
  :init-value nil
  :group 'modeline
  (flatline:mode-start))


(provide 'flatline)

;;; flatline.el ends here
