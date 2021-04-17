(in-package :nyxt)

;; to add all handlers/redirectors (youtube to invidious, reddit to teddit,
;; instagram to bibliogram, twitter to nitter)
(setq *my-request-resource-handlers* (nconc *my-request-resource-handlers* nx-freestance-handler:*freestance-handlers*))
