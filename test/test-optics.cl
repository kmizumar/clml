
(in-package "TEST")

(define-test test-sample-optics
    (assert-true 
     (optics "sample/syobu.csv" 10 2 10 '("������" "������" "�Ԃт璷" "�Ԃт畝")
             :file-type :csv :csv-type-spec '(string integer integer integer integer) 
             :distance :manhattan :external-format #+allegro :932 #-allegro :sjis)))