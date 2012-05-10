;;;

(defpackage :test
  (:use
   :cl :lisp-unit :vars :read-data :statistics :assoc
   :cluster-validation :decision-tree :ts-read-data
   :ts-autoregression :ts-util :ts-stat :ts-state-space
   :expl-smthing :hc :k-means :k-nn :linear-regression
   :missing-val :nmf :optics :pca :som :spectral-clustering
   :svm.mu :svm.smo :svm.wss3 :svr :one-class-svm :matrix :random-forest :util 
   :hdp-lda :dpm :text-utilities)
  (:import-from :spectral-clustering :*sample-w*)
  (:import-from :k-means :manhattan-distance)
  (:import-from :hc :numeric-matrix :pick-up-column :pick-up-row))
