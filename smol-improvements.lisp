(in-package :nyxt)

;; doesn't work the right way yet
(defun downloads-handler (url)
  (cond ((str:ends-with? ".pdf" (quri:render-uri url))
         (define-configuration buffer
           ((download-path (make-instance 'download-data-path
                                          :dirname "~/usr/pdf/dl/")))))
        (t
         (define-configuration buffer
           ((download-path (make-instance 'download-data-path
                                          :dirname "~/usr/tmp/"))))))
  url)


(define-configuration browser
  ((before-download-hook
    (hooks:add-hook %slot-default (make-handler-download #'downloads-handler)))))
