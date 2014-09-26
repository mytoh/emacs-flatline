;;; component.el -*- lexical-binding: t -*-

(require 'subr-x)

(cl-defun flatline:front-space ()
  (if (display-graphic-p) " " "-"))

(cl-defun flatline:column ()
  (propertize "%02c" 'face
              (if (>= (current-column) 80)
                  'flatline:face-80col
                'flatline:face-column)))

(cl-defun flatline:line ()
  (propertize "%02l" 'face 'flatline:face-line))

(cl-defun flatline:modified ()
  (cond (buffer-read-only
         (propertize " RO " 'face 'flatline:face-read-only))
        ((buffer-modified-p)
         (propertize " ** " 'face 'flatline:face-modified))
        (t (propertize " -- " 'face 'flatline:face-not-modified))))

(cl-defun flatline:mule-info ()
  `((current-input-method
     (:propertize ("" current-input-method-title)))
    (:eval (flatline:eol-desc))))

(cl-defun flatline:mnemonic ()
  (propertize (format-mode-line "%z") 'face 'flatline:face-mnemonic))

(setq eol-mnemonic-undecided ":")
(setq eol-mnemonic-unix "␊ unix")
(setq eol-mnemonic-dos "dos")
(setq eol-mnemonic-mac "mac")

(cl-defun flatline:eol-desc ()
  (cl-letf* ((eol (coding-system-eol-type buffer-file-coding-system))
             (mnemonic (coding-system-eol-type-mnemonic buffer-file-coding-system))
             (desc (cl-assoc eol mode-line-eol-desc-cache)))
    (if (and desc (eq (cadr desc) mnemonic))
        (cddr desc)
      (if desc (setq mode-line-eol-desc-cache nil)) ;Flush the cache if stale.
      (setq desc mnemonic)
      (push (cons eol (cons mnemonic desc)) mode-line-eol-desc-cache)
      desc)))

(cl-defun flatline:client ()
  (propertize (if (frame-parameter nil 'client) "@" "/")
              'face 'flatline:face-client))

(cl-defun flatline:major-mode ()
  (cl-concatenate 'string
                  mode-name
                  (if mode-line-process mode-line-process)
                  "%n"))

(cl-defun flatline:minor-mode ()
  (propertize (format-mode-line minor-mode-alist) 'face 'flatline:face-minor-mode))

(cl-defun flatline:warning ()
  (propertize "%e" 'face 'flatline:face-warning))

(cl-defun flatline:misc-info ()
  `(:propertize
    mode-line-misc-info
    face flatline:face-misc-info))

(cl-defun flatline:nyan-mode ()
  (when nyan-mode (list (nyan-create))))

(cl-defun flatline:space (space)
  (propertize space 'face 'flatline:face-space))

(cl-defun flatline:vc-mode ()
  (if vc-mode
      (propertize vc-mode 'face 'flatline:face-vc-mode)
    ""))

(cl-defun flatline:shorten-path (path)
  (cl-letf ((npath (cl-remove-if (lambda (s) (string-empty-p s))
                                 (split-string (abbreviate-file-name (expand-file-name path)) "/"))))
    (cond
      ((< 4 (length npath))
       (concat (if (string= "~" (car npath))
                   "" "/")
               (string-join
                (list
                 (car npath)
                 (cadr npath)
                 "..."
                 (car (last npath 2))
                 (car (last npath)))
                "/")))
      (t path))))

(cl-defun flatline:buffer-directory ()
  (flatline:shorten-path default-directory))

(cl-defun flatline:evil-tag ()
  (if (boundp 'evil-mode-line-tag)
      (cond ((string-match "<I>" evil-mode-line-tag)
             (propertize evil-mode-line-tag 'face
                         (flatline:theme-get-face 'evil-insert)))
            ((string-match "<N>" evil-mode-line-tag)
             (propertize evil-mode-line-tag 'face
                         (flatline:theme-get-face 'evil-normal)))
            ((string-match "<V>" evil-mode-line-tag)
             (propertize evil-mode-line-tag 'face
                         (flatline:theme-get-face 'evil-visual)))
            ((string-match "<O>" evil-mode-line-tag)
             (propertize evil-mode-line-tag 'face
                         (flatline:theme-get-face 'evil-operator)))
            (t
             evil-mode-line-tag))
    ""))

(provide 'flatline-component)

;; Local Variables:
;; byte-compile-warnings: (not cl-functions obsolete)
;; coding: utf-8
;; indent-tabs-mode: nil
;; End:
