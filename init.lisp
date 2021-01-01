(in-package :nyxt)

(define-configuration browser
    ((startup-function (make-startup-function :buffer-fn #'dashboard))))

(define-configuration buffer
  ((default-modes (append '(emacs-mode) ;; '(vi-normal-mode)
                          %slot-default))))

(define-configuration web-buffer
  ((default-modes (append
                   '(auto-mode
                     noscript-mode
                     blocker-mode
                     reduce-tracking-mode)
                   %slot-default))))

(defparameter old-reddit-handler
  (url-dispatching-handler
   'old-reddit-dispatcher
   (match-host "www.reddit.com")
   (lambda (url)
     (quri:copy-uri url :host "old.reddit.com"))))

(defvar *my-request-resource-handlers* (list old-reddit-handler))

(load-after-system :nx-freestance-handler (nyxt-init-file "freestance.lisp"))

(define-configuration buffer
  ((request-resource-hook
    (reduce #'hooks:add-hook
            *my-request-resource-handlers*
            :initial-value %slot-default))
   (search-engines (list (make-instance 'search-engine
                                        :shortcut "wiki"
                                        :search-url "https://en.wikipedia.org/w/index.php?search=~a"
                                        :fallback-url "https://en.wikipedia.org/")
                         (make-instance 'search-engine
                                        :shortcut "ddg"
                                        :search-url "https://html.duckduckgo.com/html/?q=~a"
                                        :fallback-url "https://html.duckduckgo.com/")))))

;;(nyxt::load-lisp "~/.config/nyxt/percentage.lisp")

(nyxt::load-lisp "~/.config/nyxt/theme.lisp")

(define-configuration web-buffer
  ((default-modes (append '(emacs-colorscheme-mode)
                          %slot-default))))
