;;; Compiled by f2cl version:
;;; ("$Id: f2cl1.l,v 1.209 2008/09/11 14:59:55 rtoy Exp $"
;;;  "$Id: f2cl2.l,v 1.37 2008/02/22 22:19:33 rtoy Rel $"
;;;  "$Id: f2cl3.l,v 1.6 2008/02/22 22:19:33 rtoy Rel $"
;;;  "$Id: f2cl4.l,v 1.7 2008/02/22 22:19:34 rtoy Rel $"
;;;  "$Id: f2cl5.l,v 1.197 2008/09/11 15:03:25 rtoy Exp $"
;;;  "$Id: f2cl6.l,v 1.48 2008/08/24 00:56:27 rtoy Exp $"
;;;  "$Id: macros.l,v 1.106 2008/09/15 15:27:36 rtoy Exp $")

;;; Using Lisp International Allegro CL Enterprise Edition 8.1 [64-bit Linux (x86-64)] (Oct 7, 2008 17:13)
;;; 
;;; Options: ((:prune-labels nil) (:auto-save t)
;;;           (:relaxed-array-decls t) (:coerce-assigns :as-needed)
;;;           (:array-type ':array) (:array-slicing t)
;;;           (:declare-common nil) (:float-format double-float))

(in-package "LAPACK")


(let* ((zero 0.0) (one 1.0))
  (declare (type (double-float 0.0 0.0) zero)
   (type (double-float 1.0 1.0) one) (ignorable zero one))
  (defun dgebd2 (m n a lda d e tauq taup work info)
    (declare (type (array double-float (*)) work taup tauq e d a)
     (type (f2cl-lib:integer4) info lda n m))
    (f2cl-lib:with-multi-array-data ((a double-float a-%data%
                                      a-%offset%)
                                     (d double-float d-%data%
                                      d-%offset%)
                                     (e double-float e-%data%
                                      e-%offset%)
                                     (tauq double-float tauq-%data%
                                      tauq-%offset%)
                                     (taup double-float taup-%data%
                                      taup-%offset%)
                                     (work double-float work-%data%
                                      work-%offset%))
      (prog ((i 0))
            (declare (type (f2cl-lib:integer4) i))
            (setf info 0)
            (cond ((< m 0) (setf info -1))
                  ((< n 0) (setf info -2))
                  ((< lda
                      (max (the f2cl-lib:integer4 1)
                           (the f2cl-lib:integer4 m)))
                   (setf info -4)))
            (cond ((< info 0)
                   (xerbla "DGEBD2" (f2cl-lib:int-sub info))
                   (go end_label)))
            (cond ((>= m n)
                   (f2cl-lib:fdo (i 1 (f2cl-lib:int-add i 1))
                                 ((> i n) nil)
                                 (tagbody
                                     (multiple-value-bind (var-0 var-1
                                                           var-2 var-3
                                                           var-4)
                                         (dlarfg
                                          (f2cl-lib:int-add (f2cl-lib:int-sub m
                                                                              i)
                                                            1)
                                          (f2cl-lib:fref a-%data% (i i)
                                                         ((1 lda)
                                                          (1 *))
                                                         a-%offset%)
                                          (f2cl-lib:array-slice a
                                                                double-float
                                                                ((min (f2cl-lib:int-add i
                                                                                        1)
                                                                      m)
                                                                 i)
                                                                ((1
                                                                  lda)
                                                                 (1
                                                                  *)))
                                          1
                                          (f2cl-lib:fref tauq-%data%
                                                         (i) ((1 *))
                                                         tauq-%offset%))
                                       (declare
                                        (ignore var-0 var-2 var-3))
                                       (setf (f2cl-lib:fref a-%data%
                                                            (i i)
                                                            ((1 lda)
                                                             (1 *))
                                                            a-%offset%)
                                             var-1)
                                       (setf (f2cl-lib:fref tauq-%data%
                                                            (i) ((1 *))
                                                            tauq-%offset%)
                                             var-4))
                                     (setf (f2cl-lib:fref d-%data% (i)
                                                          ((1 *))
                                                          d-%offset%)
                                           (f2cl-lib:fref a-%data%
                                                          (i i)
                                                          ((1 lda)
                                                           (1 *))
                                                          a-%offset%))
                                     (setf (f2cl-lib:fref a-%data%
                                                          (i i)
                                                          ((1 lda)
                                                           (1 *))
                                                          a-%offset%)
                                           one)
                                     (dlarf "Left"
                                      (f2cl-lib:int-add (f2cl-lib:int-sub m
                                                                          i)
                                                        1)
                                      (f2cl-lib:int-sub n i)
                                      (f2cl-lib:array-slice a
                                                            double-float
                                                            (i i)
                                                            ((1 lda)
                                                             (1 *)))
                                      1
                                      (f2cl-lib:fref tauq-%data% (i)
                                                     ((1 *))
                                                     tauq-%offset%)
                                      (f2cl-lib:array-slice a
                                                            double-float
                                                            (i
                                                             (f2cl-lib:int-add i
                                                                               1))
                                                            ((1 lda)
                                                             (1 *)))
                                      lda work)
                                     (setf (f2cl-lib:fref a-%data%
                                                          (i i)
                                                          ((1 lda)
                                                           (1 *))
                                                          a-%offset%)
                                           (f2cl-lib:fref d-%data% (i)
                                                          ((1 *))
                                                          d-%offset%))
                                     (cond ((< i n)
                                            (multiple-value-bind (var-0
                                                                  var-1
                                                                  var-2
                                                                  var-3
                                                                  var-4)
                                                (dlarfg
                                                 (f2cl-lib:int-sub n i)
                                                 (f2cl-lib:fref a-%data%
                                                                (i
                                                                 (f2cl-lib:int-add i
                                                                                   1))
                                                                ((1
                                                                  lda)
                                                                 (1 *))
                                                                a-%offset%)
                                                 (f2cl-lib:array-slice a
                                                                       double-float
                                                                       (i
                                                                        (min (the f2cl-lib:integer4
                                                                                  (f2cl-lib:int-add i
                                                                                                    2))
                                                                             (the f2cl-lib:integer4
                                                                                  n)))
                                                                       ((1
                                                                         lda)
                                                                        (1
                                                                         *)))
                                                 lda
                                                 (f2cl-lib:fref taup-%data%
                                                                (i)
                                                                ((1 *))
                                                                taup-%offset%))
                                              (declare
                                               (ignore var-0 var-2
                                                var-3))
                                              (setf (f2cl-lib:fref a-%data%
                                                                   (i
                                                                    (f2cl-lib:int-add i
                                                                                      1))
                                                                   ((1
                                                                     lda)
                                                                    (1
                                                                     *))
                                                                   a-%offset%)
                                                    var-1)
                                              (setf (f2cl-lib:fref taup-%data%
                                                                   (i)
                                                                   ((1
                                                                     *))
                                                                   taup-%offset%)
                                                    var-4))
                                            (setf (f2cl-lib:fref e-%data%
                                                                 (i)
                                                                 ((1
                                                                   *))
                                                                 e-%offset%)
                                                  (f2cl-lib:fref a-%data%
                                                                 (i
                                                                  (f2cl-lib:int-add i
                                                                                    1))
                                                                 ((1
                                                                   lda)
                                                                  (1
                                                                   *))
                                                                 a-%offset%))
                                            (setf (f2cl-lib:fref a-%data%
                                                                 (i
                                                                  (f2cl-lib:int-add i
                                                                                    1))
                                                                 ((1
                                                                   lda)
                                                                  (1
                                                                   *))
                                                                 a-%offset%)
                                                  one)
                                            (dlarf "Right"
                                             (f2cl-lib:int-sub m i)
                                             (f2cl-lib:int-sub n i)
                                             (f2cl-lib:array-slice a
                                                                   double-float
                                                                   (i
                                                                    (f2cl-lib:int-add i
                                                                                      1))
                                                                   ((1
                                                                     lda)
                                                                    (1
                                                                     *)))
                                             lda
                                             (f2cl-lib:fref taup-%data%
                                                            (i) ((1 *))
                                                            taup-%offset%)
                                             (f2cl-lib:array-slice a
                                                                   double-float
                                                                   ((+ i
                                                                       1)
                                                                    (f2cl-lib:int-add i
                                                                                      1))
                                                                   ((1
                                                                     lda)
                                                                    (1
                                                                     *)))
                                             lda work)
                                            (setf (f2cl-lib:fref a-%data%
                                                                 (i
                                                                  (f2cl-lib:int-add i
                                                                                    1))
                                                                 ((1
                                                                   lda)
                                                                  (1
                                                                   *))
                                                                 a-%offset%)
                                                  (f2cl-lib:fref e-%data%
                                                                 (i)
                                                                 ((1
                                                                   *))
                                                                 e-%offset%)))
                                           (t
                                            (setf (f2cl-lib:fref taup-%data%
                                                                 (i)
                                                                 ((1
                                                                   *))
                                                                 taup-%offset%)
                                                  zero)))
                                   label10)))
                  (t
                   (f2cl-lib:fdo (i 1 (f2cl-lib:int-add i 1))
                                 ((> i m) nil)
                                 (tagbody
                                     (multiple-value-bind (var-0 var-1
                                                           var-2 var-3
                                                           var-4)
                                         (dlarfg
                                          (f2cl-lib:int-add (f2cl-lib:int-sub n
                                                                              i)
                                                            1)
                                          (f2cl-lib:fref a-%data% (i i)
                                                         ((1 lda)
                                                          (1 *))
                                                         a-%offset%)
                                          (f2cl-lib:array-slice a
                                                                double-float
                                                                (i
                                                                 (min (the f2cl-lib:integer4
                                                                           (f2cl-lib:int-add i
                                                                                             1))
                                                                      (the f2cl-lib:integer4
                                                                           n)))
                                                                ((1
                                                                  lda)
                                                                 (1
                                                                  *)))
                                          lda
                                          (f2cl-lib:fref taup-%data%
                                                         (i) ((1 *))
                                                         taup-%offset%))
                                       (declare
                                        (ignore var-0 var-2 var-3))
                                       (setf (f2cl-lib:fref a-%data%
                                                            (i i)
                                                            ((1 lda)
                                                             (1 *))
                                                            a-%offset%)
                                             var-1)
                                       (setf (f2cl-lib:fref taup-%data%
                                                            (i) ((1 *))
                                                            taup-%offset%)
                                             var-4))
                                     (setf (f2cl-lib:fref d-%data% (i)
                                                          ((1 *))
                                                          d-%offset%)
                                           (f2cl-lib:fref a-%data%
                                                          (i i)
                                                          ((1 lda)
                                                           (1 *))
                                                          a-%offset%))
                                     (setf (f2cl-lib:fref a-%data%
                                                          (i i)
                                                          ((1 lda)
                                                           (1 *))
                                                          a-%offset%)
                                           one)
                                     (dlarf "Right"
                                      (f2cl-lib:int-sub m i)
                                      (f2cl-lib:int-add (f2cl-lib:int-sub n
                                                                          i)
                                                        1)
                                      (f2cl-lib:array-slice a
                                                            double-float
                                                            (i i)
                                                            ((1 lda)
                                                             (1 *)))
                                      lda
                                      (f2cl-lib:fref taup-%data% (i)
                                                     ((1 *))
                                                     taup-%offset%)
                                      (f2cl-lib:array-slice a
                                                            double-float
                                                            ((min (f2cl-lib:int-add i
                                                                                    1)
                                                                  m)
                                                             i)
                                                            ((1 lda)
                                                             (1 *)))
                                      lda work)
                                     (setf (f2cl-lib:fref a-%data%
                                                          (i i)
                                                          ((1 lda)
                                                           (1 *))
                                                          a-%offset%)
                                           (f2cl-lib:fref d-%data% (i)
                                                          ((1 *))
                                                          d-%offset%))
                                     (cond ((< i m)
                                            (multiple-value-bind (var-0
                                                                  var-1
                                                                  var-2
                                                                  var-3
                                                                  var-4)
                                                (dlarfg
                                                 (f2cl-lib:int-sub m i)
                                                 (f2cl-lib:fref a-%data%
                                                                ((f2cl-lib:int-add i
                                                                                   1)
                                                                 i)
                                                                ((1
                                                                  lda)
                                                                 (1 *))
                                                                a-%offset%)
                                                 (f2cl-lib:array-slice a
                                                                       double-float
                                                                       ((min (f2cl-lib:int-add i
                                                                                               2)
                                                                             m)
                                                                        i)
                                                                       ((1
                                                                         lda)
                                                                        (1
                                                                         *)))
                                                 1
                                                 (f2cl-lib:fref tauq-%data%
                                                                (i)
                                                                ((1 *))
                                                                tauq-%offset%))
                                              (declare
                                               (ignore var-0 var-2
                                                var-3))
                                              (setf (f2cl-lib:fref a-%data%
                                                                   ((f2cl-lib:int-add i
                                                                                      1)
                                                                    i)
                                                                   ((1
                                                                     lda)
                                                                    (1
                                                                     *))
                                                                   a-%offset%)
                                                    var-1)
                                              (setf (f2cl-lib:fref tauq-%data%
                                                                   (i)
                                                                   ((1
                                                                     *))
                                                                   tauq-%offset%)
                                                    var-4))
                                            (setf (f2cl-lib:fref e-%data%
                                                                 (i)
                                                                 ((1
                                                                   *))
                                                                 e-%offset%)
                                                  (f2cl-lib:fref a-%data%
                                                                 ((f2cl-lib:int-add i
                                                                                    1)
                                                                  i)
                                                                 ((1
                                                                   lda)
                                                                  (1
                                                                   *))
                                                                 a-%offset%))
                                            (setf (f2cl-lib:fref a-%data%
                                                                 ((f2cl-lib:int-add i
                                                                                    1)
                                                                  i)
                                                                 ((1
                                                                   lda)
                                                                  (1
                                                                   *))
                                                                 a-%offset%)
                                                  one)
                                            (dlarf "Left"
                                             (f2cl-lib:int-sub m i)
                                             (f2cl-lib:int-sub n i)
                                             (f2cl-lib:array-slice a
                                                                   double-float
                                                                   ((+ i
                                                                       1)
                                                                    i)
                                                                   ((1
                                                                     lda)
                                                                    (1
                                                                     *)))
                                             1
                                             (f2cl-lib:fref tauq-%data%
                                                            (i) ((1 *))
                                                            tauq-%offset%)
                                             (f2cl-lib:array-slice a
                                                                   double-float
                                                                   ((+ i
                                                                       1)
                                                                    (f2cl-lib:int-add i
                                                                                      1))
                                                                   ((1
                                                                     lda)
                                                                    (1
                                                                     *)))
                                             lda work)
                                            (setf (f2cl-lib:fref a-%data%
                                                                 ((f2cl-lib:int-add i
                                                                                    1)
                                                                  i)
                                                                 ((1
                                                                   lda)
                                                                  (1
                                                                   *))
                                                                 a-%offset%)
                                                  (f2cl-lib:fref e-%data%
                                                                 (i)
                                                                 ((1
                                                                   *))
                                                                 e-%offset%)))
                                           (t
                                            (setf (f2cl-lib:fref tauq-%data%
                                                                 (i)
                                                                 ((1
                                                                   *))
                                                                 tauq-%offset%)
                                                  zero)))
                                   label20))))
            (go end_label)
       end_label (return (values nil nil nil nil nil nil nil nil nil
                                 info))))))

(in-package #-gcl #:cl-user #+gcl "CL-USER")
#+#.(cl:if (cl:find-package '#:f2cl) '(and) '(or))
(eval-when (:load-toplevel :compile-toplevel :execute)
  (setf (gethash 'fortran-to-lisp::dgebd2
                 fortran-to-lisp::*f2cl-function-info*)
        (fortran-to-lisp::make-f2cl-finfo :arg-types '((fortran-to-lisp::integer4)
                                                       (fortran-to-lisp::integer4)
                                                       (array
                                                        double-float
                                                        (*))
                                                       (fortran-to-lisp::integer4)
                                                       (array
                                                        double-float
                                                        (*))
                                                       (array
                                                        double-float
                                                        (*))
                                                       (array
                                                        double-float
                                                        (*))
                                                       (array
                                                        double-float
                                                        (*))
                                                       (array
                                                        double-float
                                                        (*))
                                                       (fortran-to-lisp::integer4))
          :return-values '(nil nil nil nil nil nil nil nil nil
                           fortran-to-lisp::info)
          :calls '(fortran-to-lisp::dlarf fortran-to-lisp::dlarfg
                   fortran-to-lisp::xerbla))))

