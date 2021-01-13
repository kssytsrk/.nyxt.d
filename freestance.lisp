(in-package :nyxt)

;; to add all handlers/redirectors (youtube to invidious, reddit to teddit,
;; instagram to bibliogram, twitter to nitter)
(setq *my-request-resource-handlers* (nconc *my-request-resource-handlers* nx-freestance-handler:*freestance-handlers*))


;; alternatively, you may add each separately
;; (push nx-freestance-handler:invidious-handler *my-request-resource-handlers*)
;; (push nx-freestance-handler:nitter-handler *my-request-resource-handlers*)
;; (push nx-freestance-handler:bibliogram-handler *my-request-resource-handlers*)
;; (push nx-freestance-handler:teddit-handler *my-request-resource-handlers*)

;; to set your preferred instance, either invoke SET-PREFERRED-[name of website]-INSTANCE
;; command in Nyxt (its effect last until you close Nyxt), or write something like this:
;; (setf nx-freestance-handler:*preferred-invidious-instance* "https://invidious.snopyta.org")
