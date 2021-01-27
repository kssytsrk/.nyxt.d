(in-package :nyxt-user)

(define-parenscript %percentage ()
  (defun percentage ()
    (let* ((height-of-window (ps:@ window inner-height))
           (content-scrolled (ps:@ window page-y-offset))
           (body-height (if (not (or (eql window undefined)
                                     (eql (ps:@ window document) undefined)
                                     (eql (ps:chain window
                                                    document
                                                    (get-elements-by-tag-name "body"))
                                          undefined)
                                     (eql (ps:chain window
                                                    document
                                                    (get-elements-by-tag-name "body")
                                                    0)
                                          undefined)
                                     (eql (ps:chain window
                                                    document
                                                    (get-elements-by-tag-name "body")
                                                    0
                                                    offset-height)
                                          undefined)))
                          (ps:chain window
                                    document
                                    (get-elements-by-tag-name "body")
                                    0
                                    offset-height)
                          0))
           (total (- body-height height-of-window))
           (prc (* (/ content-scrolled total) 100)))
      (if (> prc 100)
          100
          (round prc))))
  (percentage))

(define-command percentage ()
  "Echo percentage."
  (echo (%percentage)))

