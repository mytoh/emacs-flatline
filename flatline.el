;;; flatline.el --- flat modeline

;;; Code:

;;; http://amitp.blogspot.jp/2011/08/emacs-custom-mode-line.html

(eval-when-compile
  (require 'cl-lib))

(defgroup flatline nil
  "Faces used in the mode line."
  :group 'mode-line)

(cl-defun flatline:front-space ()
  `(:eval (if (display-graphic-p) " " "-")))

(cl-defun flatline:column ()
  `(:eval (propertize "%02c" 'face
                      (if (>= (current-column) 80)
                          'flatline:face-80col
                        'flatline:face-column))))

(cl-defun flatline:line ()
  `(:eval (propertize "%02l" 'face 'flatline:face-line)))

(cl-defun flatline:modified ()
  `(:eval
    (cond (buffer-read-only
           (propertize " RO " 'face 'flatline:face-read-only))
          ((buffer-modified-p)
           (propertize " ** " 'face 'flatline:face-modified))
          (t (propertize " -- " 'face 'flatline:face-not-modified)))))

(cl-defun flatline:mule-info ()
  `((current-input-method
     (:propertize ("" current-input-method-title)))
    (:eval (flatline:eol-desc))))

(cl-defun flatline:mnemonic ()
  `(:eval
    (propertize (format-mode-line "%z") 'face 'flatline:face-mnemonic)))

(setq eol-mnemonic-undecided ":")
(setq eol-mnemonic-unix "unix")
(setq eol-mnemonic-dos "dos")
(setq eol-mnemonic-mac "mac")

(cl-defun flatline:eol-desc ()
  (cl-letf* ((eol (coding-system-eol-type buffer-file-coding-system))
             (mnemonic (coding-system-eol-type-mnemonic buffer-file-coding-system))
             (desc (cl-assoc eol mode-line-eol-desc-cache)))
    (if (and desc (eq (cadr desc) mnemonic))
        (cddr desc)
      (if desc (setq mode-line-eol-desc-cache nil)) ;Flush the cache if stale.
      (setq desc
            (propertize
             mnemonic
             'face 'flatline:face-eol-desc))
      (push (cons eol (cons mnemonic desc)) mode-line-eol-desc-cache)
      desc)))

(cl-defun flatline:client ()
  `(:eval
    (propertize (if (frame-parameter nil 'client) "@" "/")
                'face 'flatline:face-client)))

(cl-defun flatline:buffer ()
  `(:eval
    (propertize "%b"
                'face 'flatline:face-buffer)))

(cl-defun flatline:major-mode ()
  `(:eval
    (propertize mode-name 'face 'flatline:face-major-mode)
    (propertize mode-line-process 'face 'flatline:face-major-mode)
    (propertize "%n" 'face 'flatline:face-major-mode)))

(cl-defun flatline:minor-mode ()
  `(:eval
    (propertize (format-mode-line minor-mode-alist) 'face 'flatline:face-minor-mode)))

(cl-defun flatline:warning ()
  `(:eval (propertize "%e" 'face 'flatline:face-warning)))

(cl-defun flatline:misc-info ()
  `(:propertize
    mode-line-misc-info
    face flatline:face-misc-info))

(cl-defun flatline:nyan-mode ()
  `(:eval (when nyan-mode (list (nyan-create)))))

(cl-defun flatline:space (space)
  `(:eval (propertize ,space 'face 'flatline:face-space)))

(cl-defun flatline:vc-mode ()
  `(:eval (propertize vc-mode 'face 'flatline:face-vc-mode)))

(cl-defun flatline:shorten-path (path)
  (cl-letf ((npath (cl-remove-if #'(lambda (s) (string= s ""))
                                 (split-string (abbreviate-file-name path) "/"))))
    (cond
     ((< 4 (length npath))
      (concat (if (string= "~" (car npath))
                  "" "/")
              (car npath)
              "/" (cadr npath)
              "/" "..."
              "/" (car (last npath 2))
              "/" (car (last npath))))
     (t path))))

(cl-defun flatline:buffer-directory ()
  `(:eval (propertize (flatline:shorten-path default-directory) 'face 'flatline:face-buffer-directory)))


;; faces

(defgroup flatline-face nil
  "Faces used in the mode line."
  :group 'flatline)

(defface flatline:face-normal
  '((t (:background "gray20" :foreground "gray60" :inverse-video nil :box nil)))
  "flatline base face"
  :group 'flatline-face)

(set-face-attribute 'mode-line nil :foreground "gray60" :background "gray20" :inverse-video nil :box nil)

;; inactive face
(defface flatline:face-inactive
  '((t (:foreground "white" :background "black")))
  "flatline inactive face"
  :group 'flatline-face)
(set-face-attribute 'mode-line-inactive nil
                    :inherit 'flatline:face-inactive)

;; warning
(defface flatline:face-warning
  '((t (:background "gray20" :foreground "red")))
  "flatline warning face"
  :group 'flatline-face)

;; modified
(defface flatline:face-modified
  '((t ( :background "gray20" :foreground "#c82829")))
  "flatline modified face"
  :group 'flatline-face)

(defface flatline:face-not-modified
  '((t ( :background "gray20" :foreground "#386889")))
  "flatline not modified face"
  :group 'flatline-face)

(defface flatline:face-read-only
  '((t ( :background "gray20" :foreground "#4271ae" :box '(:line-width 2 :color "#4271ae"))))
  "flatline read only face"
  :group 'flatline-face)

;; column
(defface flatline:face-column
  '((t (:inherit 'flatline:face-normal)))
  "flatline column face"
  :group 'flatline-face)
(defface flatline:face-80col
  '((t ( :background "gray20" :foreground "red")))
  "flatline 80col face"
  :group 'flatline-face)

;; line
(defface flatline:face-line
  '((t (:foreground "gray60" :background "gray20")))
  "flatline line face"
  :group 'flatline-face)

;; mule info
(defface flatline:face-mnemonic
  '((t (:foreground "gray60" :background "gray20")))
  "flatline mnemonic face"
  :group 'flatline-face)

;; eol desc
(defface flatline:face-eol-desc
  '((t (  :background "gray20" :foreground "#93ef5a")))
  "flatline eol description face"
  :group 'flatline-face)

;; client
(defface flatline:face-client
  '((t (:inherit 'flatline:face-normal)))
  "flatline client face"
  :group 'flatline-face)

;; buffer name
(defface flatline:face-buffer
  '((t ( :background "#3a3a4f" :foreground "#a7bc7a")))
  "flatline buffer face"
  :group 'flatline-face)

;; buffer directory
(defface flatline:face-buffer-directory
  '((t (:foreground "#65cba2" :background "gray20")))
  "flatline buffer directory face"
  :group 'flatline-face)

;; mode name
(defface flatline:face-major-mode
  '((t (  :background "gray20" :foreground "#bb3bbb")))
  "flatline mode name face"
  :group 'flatline-face)

;; minor mode
(defface flatline:face-minor-mode
  '((t (  :background "gray20" :foreground "#6b719e")))
  "flatline minor made face"
  :group 'flatline-face)

;; misc info
(defface flatline:face-misc-info
  '((t ( :background "gray20" :foreground "#c55f3e")))
  "flatline misc info face"
  :group 'flatline-face)

;; vc-mode info
(defface flatline:face-vc-mode
  '((t (:background "gray20" :foreground "#3e9cbb")))
  "flatline vc mode face"
  :group 'flatline-face)

;; space
(defface flatline:face-space
  '((t (:foreground "gray60" :background "gray20")))
  "flatline space face"
  :group 'flatline-face)



;; initialize mode-line
(defcustom flatline:mode-line-format nil
  "flatline mode-line string list"
  :type 'symbol)

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
