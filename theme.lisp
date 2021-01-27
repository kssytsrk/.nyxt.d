;;;; code in this file copies colors from Emacs, hence its working name is
;;;; "emacs-colorscheme-theme"
;;;; for me it worked and looked fine with multiple themes, but it's sort of a
;;;; Russian roulette

;;;; to use all of this, you need to have Emacs and emacs server runnning at the
;;;; time of opening the browser: in Emacs, execute
;;;; M-x server-start RET

(in-package :nyxt-user)

;; TODO: percentage of page viewed
;; (load "~/.config/nyxt/percentage.lisp")
;; (defparameter prc nil)
;; (percentage)
;; (log:info prc)

(defun emacs-face-attribute (face attribute)
  (string-trim "\"" (uiop:run-program (concatenate 'string
                                                   "emacsclient -e \"(face-attribute '"
                                                   (string-downcase (string face))
                                                   " :"
                                                   (string-downcase (string attribute))
                                                   " nil :inherit)\"")
                                      :output '(:string :stripped t))))

(let ((bg (emacs-face-attribute 'default :background))
      (fg (emacs-face-attribute 'default :foreground))
      (mlbg (emacs-face-attribute 'mode-line :background)) ;; modeline bg
      (mlfg (emacs-face-attribute 'mode-line :foreground))
      ;;(ml-inactive-bg (emacs-face-attribute 'mode-line-inactive :background))
      ;;(ml-inactive-fg (emacs-face-attribute 'mode-line-inactive :foreground))
      (ml-highlight-fg (emacs-face-attribute 'mode-line-highlight :foreground))
      (ml-emphasis-fg (emacs-face-attribute 'mode-line-emphasis :foreground))
      (h1 (emacs-face-attribute 'outline-1 :foreground))
      (h2 (emacs-face-attribute 'outline-2 :foreground))
      (h3 (emacs-face-attribute 'outline-3 :foreground))
      (h4 (emacs-face-attribute 'outline-4 :foreground))
      (h5 (emacs-face-attribute 'outline-5 :foreground))
      (h6 (emacs-face-attribute 'outline-6 :foreground))
      (a (emacs-face-attribute 'link :foreground))
      (hrfg (emacs-face-attribute 'vertical-border :foreground))
      (cursor (emacs-face-attribute 'cursor :background))
      (mb-prompt (emacs-face-attribute 'minibuffer-prompt :foreground)) ; minibuffer prompt
      (mb-selection (emacs-face-attribute 'helm-selection :background))
      (mb-separator (emacs-face-attribute 'helm-separator :foreground)))

  ;; minibuffer (bg and fg colors)
  (define-configuration minibuffer
      ((style
        (str:concat
         %slot-default
         (cl-css:css
          `((body
             :border-top ,(str:concat "1px solid" mb-separator)
             :background-color ,bg
             :color ,fg)
            ("#input"
             :border-bottom ,(str:concat "solid 1px " mb-separator))
            ("#cursor"
             :background-color ,cursor
             :color ,fg)
            ("#prompt"
             :color ,mb-prompt)
            (.marked
             :background-color ,mb-selection
             :color ,(if (equal mb-selection fg)
                         bg
                         fg))
            (.selected
             :background-color ,mb-selection
             :color ,(if (equal mb-selection fg)
                         bg
                         fg))))))))

  (defun override (color)
    (concatenate 'string color " !important"))

  ;; internal buffers (help, list, etc)
  (define-configuration internal-buffer
      ((style
        (str:concat
         %slot-default
         (cl-css:css
          `((body
             :background-color ,(override bg)
             :color ,(override fg))
            (hr
             :background-color ,(override bg)
             :color ,(override hrfg))
            (.button
             :background-color ,(override mlbg)
             :color ,(override mlfg))
            (".button:hover"
             :color ,(override ml-highlight-fg))
            (".button:active"
             :color ,(override ml-emphasis-fg))
            (".button:visited"
             :color ,(override ml-highlight-fg))
            (a
             :color ,(override a))
            (h1
             :color ,(override h1))
            (h2
             :color ,(override h2))
            (h3
             :color ,(override h3))
            (h4
             :color ,(override h4))
            (h5
             :color ,(override h5))
            (h6
             :color ,(override h6))))))))

  ;; status bar

  (defun loadingp (&optional (buffer (current-buffer)))
    (and (web-buffer-p buffer)
         (eq (slot-value buffer 'nyxt::load-status) :loading)))

  (defun status-update ()
    (nyxt::print-status))

  (hooks:add-hook nyxt/web-mode:scroll-to-top-after-hook
                  (hooks:make-handler-void #'status-update))
  (hooks:add-hook nyxt/web-mode:scroll-to-bottom-after-hook
                  (hooks:make-handler-void #'status-update))
  (hooks:add-hook nyxt/web-mode:scroll-page-up-after-hook
                  (hooks:make-handler-void #'status-update))
  (hooks:add-hook nyxt/web-mode:scroll-page-down-after-hook
                  (hooks:make-handler-void #'status-update))
  (hooks:add-hook nyxt/web-mode:scroll-down-after-hook
                  (hooks:make-handler-void #'status-update))
  (hooks:add-hook nyxt/web-mode:scroll-up-after-hook
                  (hooks:make-handler-void #'status-update))
  (hooks:add-hook nyxt/web-mode:scroll-to-top-after-hook
                  (hooks:make-handler-void #'status-update))
  (hooks:add-hook nyxt/web-mode:scroll-to-bottom-after-hook
                  (hooks:make-handler-void #'status-update))

  (defun my-status-formatter (window)
    (let* ((buffer (current-buffer window))
           (buffer-count (1+ (or (position buffer
                                           (sort (buffer-list)
                                                 #'string<
                                                 :key #'id))
                                 0))))
      (markup:markup
       (:div :id "status-formatter"
             :style (str:concat "background-color:" mlbg "; color:" mlfg)
             (markup:raw (str:concat
                          (markup:markup
                           (:b (str:concat "[ " (format-status-modes) " ]")))
                          (format nil " (~a/~a) "
                                  buffer-count
                                  (length (buffer-list)))
                          (format nil "~a~a — ~a"
                                  (if (and (web-buffer-p buffer)
                                           (eq (slot-value buffer 'nyxt::load-status) :loading))
                                      "(Loading) "
                                      "")
                                  (object-display (url buffer))
                                  (title buffer))))
             (:span :id "aaa" :style "float:right" (format nil "~:[0~;~:*~a~]%" (%percentage)))))))

  (define-configuration window
      ((message-buffer-style
        (str:concat
         %slot-default
         (cl-css:css
          `((body
             :background-color ,(override bg)
             :color ,(override fg))))))
       (status-formatter #'my-status-formatter)))

  ;; colorscheme for websites/web-buffers, turn on with

  ;; (define-configuration web-buffer
  ;; ((default-modes (append '(emacs-colorscheme-mode)
  ;;                         %slot-default))))

  (nyxt::define-bookmarklet-command %apply-emacs-colorscheme
    "Modify the page with Emacs's colors"
    (str:concat "javascript:document.querySelectorAll('*').forEach(e=> { e.setAttribute('style','background-color:" bg " !important;color:'+(/^A|BU/.test(e.tagName)?" "'" a ";':'" fg ";')+e.getAttribute('style')); e.style.fontFamily='Anonymous Pro,serif'; } )"))

  (define-mode emacs-colorscheme-mode (nyxt/style-mode:style-mode)
    "Mode that styles the page to match the user's Emacs theme."
    ((nyxt/style-mode:style (cl-css:css
                              `((hr
                                 :color ,(override hrfg))
                                (.button
                                 :background-color ,(override mlbg)
                                 :color ,(override mlfg))
                                (".button:hover"
                                 :color ,(override ml-highlight-fg))
                                (".button:active"
                                 :color ,(override ml-emphasis-fg))
                                (".button:visited"
                                 :color ,(override ml-highlight-fg))
                                (a
                                 :color ,(override a))
                                (h1
                                 :color ,(override h1))
                                (h2
                                 :color ,(override h2))
                                (h3
                                 :color ,(override h3))
                                (h4
                                 :color ,(override h4))
                                (h5
                                 :color ,(override h5))
                                (h6
                                 :color ,(override h6)))))
     (constructor
      (lambda (mode)
        (nyxt/style-mode::initialize mode)))))

  (defmethod nyxt/style-mode::apply-style ((mode emacs-colorscheme-mode))
    (if (style mode)
        (apply-emacs-colorscheme)
        (nyxt::html-set-style (style mode) (buffer mode))))

  (defun apply-emacs-colorscheme ()
    (if (find-submode (current-buffer)
                      'emacs-colorscheme)
        (%apply-emacs-colorscheme)))

  (hooks:add-hook nyxt/web-mode:unzoom-page-after-hook
                  (hooks:make-handler-void #'apply-emacs-colorscheme)))
