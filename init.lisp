(in-package :nyxt)

(define-configuration browser
  ((startup-function (make-startup-function :buffer-fn #'dashboard))))

(define-configuration buffer
  ((default-modes (append '(emacs-mode) ;; '(vi-normal-mode)
                          %slot-default%))))

(define-configuration web-buffer
  ((default-modes (append
                   '(auto-mode
                     emacs-mode
                     noscript-mode
                     blocker-mode
                     reduce-tracking-mode)
                   %slot-default%))))

;;;; Can't set this. Why? TODO: investigate
;; (setf nyxt::*invisible-modes*
;;       (nconc nyxt::*invisible-modes*
;;              '("certificate-exception-mode"
;;                "reduce-tracking-mode"
;;                "blocker-mode")))

(defvar *my-request-resource-handlers* '())

(load-after-system :nx-freestance-handler (nyxt-init-file "freestance.lisp"))

(define-configuration buffer
  ((request-resource-hook
    (reduce #'hooks:add-hook
            *my-request-resource-handlers*
            :initial-value %slot-default%))))

(nyxt::load-lisp "~/.config/nyxt/percentage.lisp")

;;;; Don't want all these right now
;; (nyxt::load-lisp "~/.config/nyxt/theme.lisp")
;; (nyxt::load-lisp "~/.config/nyxt/smol-improvements.lisp")
;; (define-configuration web-buffer
;;     ((default-modes (append '(emacs-colorscheme-mode)
;; 			    %slot-default%))))
(nyxt::load-lisp "~/.config/nyxt/theme-minimal.lisp")

(define-configuration buffer
    ((download-path (make-instance 'download-data-path
                                 :dirname "~/usr/tmp/"))
     (bookmarks-path (make-instance 'bookmarks-data-path
                                  :basename "~/usr/bkm/bookmarks.lisp"))
     (auto-mode-rules-data-path (make-instance 'auto-mode-rules-data-path
					       :basename "~/.config/nyxt/auto-mode-rules.lisp"))
     (history-data-path (make-instance 'history-data-path
				       :basename "/dev/null"))
     (override-map (let ((map (make-keymap "override-map")))
		     (define-key map
		       "M-x" 'execute-command)))))

;; Where did this go? TODO: investigate
;; (setf nyxt/vcs:*vcs-projects-roots* '("~/common-lisp"
;;                                       "~/usr/dev/cloned"
;;                                       "~/.emacs.d/mypkgs"))

(echo "Init file loaded.")
