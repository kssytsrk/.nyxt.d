;;;; this is a more minimal version of theme.lisp, it's faster but my theme is
;;;; hardcoded here. also, there's no styling of web pages (i don't feel like
;;;; having it rn)

(in-package :nyxt-user)

(let ((bg "black")
      (fg "#eeeee8")
      (mlbg "#888") ; modeline bg
      (mlfg "black")
      (ml-highlight-fg "grey40")
      (h1 "#eeeee8")
      (a "light blue")      
      (cursor "#eeeee8")
      (mb-prompt "#eeeee8") ; minibuffer prompt
      (mb-separator "red"))

  ;; minibuffer (bg and fg colors)
  (define-configuration prompt-buffer
      ((style
        (str:concat
         %slot-default%
         (cl-css:css
          `((body
             :border-top ,(str:concat "1px solid" mb-separator)
             :background-color ,bg
             :color ,fg)
            ("#input"
	     :background-color ,bg
             :color ,fg
             :border-bottom ,(str:concat "solid 1px " mb-separator))
            ("#cursor"
             :background-color ,cursor
             :color ,fg)
            ("#prompt"
             :color ,mb-prompt)
	    (".source-content"
	     :background-color ,bg)
	    (".source-content th"
	     :background-color ,bg)
	    ("#selection"
	     :background-color ,mlbg
	     :color ,mlfg)
            (.marked
             :background-color "grey40"
             :color "black")
            (.selected
             :background-color "white"
             :color "black")))))))

  (defun override (color)
    (concatenate 'string color " !important"))

  ;; internal buffers (help, list, etc)
  (define-configuration internal-buffer
      ((style
        (str:concat
         %slot-default%
         (cl-css:css
          `((body
             :background-color ,(override bg)
             :color ,(override fg))
            (hr
             :background-color ,(override bg)
             :color ,(override cursor))
            (.button
             :background-color ,(override mlbg)
             :color ,(override mlfg))
            (".button:hover"
             :color ,(override ml-highlight-fg))
            (".button:active"
             :color ,(override ml-highlight-fg))
            (".button:visited"
             :color ,(override ml-highlight-fg))
            (a
             :color ,(override a))
            (h1
             :color ,(override h1))
            (h2
             :color ,(override h1))
            (h3
             :color ,(override h1))
            (h4
             :color ,(override h1))
            (h5
             :color ,(override h1))
            (h6
             :color ,(override h1))))))))

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
                                           (sort (buffer-list) #'string< :key #'id))
                                 0))))
      (markup:markup
       (:div :id "status-formatter"
             :style (str:concat "background-color:" mlbg "; color:" mlfg)
             (:b (str:concat "[ " (format-status-modes (nyxt::current-buffer)
						       (nyxt::current-window)) " ]"))
             (markup:raw
              (format nil " (~a/~a) "
                      buffer-count
                      (length (buffer-list)))
              (format nil "~a~a — ~a"
                      (if (and (web-buffer-p buffer)
                               (eq (slot-value buffer 'nyxt::load-status) :loading))
                          "(Loading) "
                        "")
                      (object-display (url buffer))
                      (title buffer)))
             (:span :id "aaa"
                    :style "float:right"
                      (format nil "~:[0~;~:*~a~]%" (%percentage)
                              ))))))

  (define-configuration window
      ((message-buffer-style
        (str:concat
         %slot-default%
         (cl-css:css
          `((body
             :background-color ,(override bg)
             :color ,(override fg))))))
       (status-formatter #'my-status-formatter))))
