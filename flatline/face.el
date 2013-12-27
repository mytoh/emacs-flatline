;;; face.el -*- lexical-binding: t -*-

;;;; faces

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


(provide 'flatline-face)

;; Local Variables:
;; byte-compile-warnings: (not cl-functions obsolete)
;; coding: utf-8
;; indent-tabs-mode: nil
;; End:
