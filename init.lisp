(in-package :nyxt)

(define-configuration browser
  ((startup-function (make-startup-function :buffer-fn #'dashboard))))

(define-configuration buffer
  ((default-modes (append '(emacs-mode) ;; '(vi-normal-mode)
                          %slot-default))))

(define-configuration web-buffer
  ((default-modes (append
                   '(auto-mode
                     emacs-mode
                     noscript-mode
                     blocker-mode
                     reduce-tracking-mode)
                   %slot-default))))

(setf nyxt::*invisible-modes*
      (nconc nyxt::*invisible-modes*
             '("certificate-exception-mode"
               "reduce-tracking-mode"
               "blocker-mode")))

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
            :initial-value %slot-default))))

(define-configuration buffer
  ((download-path (make-instance 'download-data-path
                                 :dirname "~/usr/tmp/"))))

(nyxt::load-lisp "~/.config/nyxt/percentage.lisp")

(nyxt::load-lisp "~/.config/nyxt/theme.lisp")

(nyxt::load-lisp "~/.config/nyxt/smol-improvements.lisp")

(define-configuration web-buffer
  ((default-modes (append '(emacs-colorscheme-mode)
                          %slot-default))))

(define-configuration buffer
  ((override-map (let ((map (make-keymap "override-map")))
                   (define-key map
                     "M-x" 'execute-command)))))

(setf nyxt/vcs:*vcs-projects-roots* '("~/common-lisp"
                                      "~/usr/dev/cloned"
                                      "~/.emacs.d/mypkgs"))

(echo "Init file loaded.")
