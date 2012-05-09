(in-package :cg-user)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; File

#+ignore
(defun menu-file-load (stafile)
  (interactive (:menu ("File" "Load"))
               :filename ("StaFile:"
                          "USeconomic.sta" ; "*.sta"
                          ))
  (when (probe-file-safe stafile)
    (load-stafile stafile)))

(defun ask-user-for-sta-file ()
  (ask-user-for-existing-pathname
   "STA File"
   :initial-directory "statvis-ml"
   :change-current-directory-p t
   :allowed-types '(("STA Files" . "*.sta"))))

(defun show-file (file)
  (with-open-file (in file :external-format :932)
    (let ((eof (list nil))
          (ch nil))
      (while (not (eq eof (setq ch (read-char in nil eof))))
        (write-char ch *standard-output*)))))

(defun menu-file-open-sta-as-chart ()
  (interactive (:menu ("File" "Open as Chart")))
  (let ((stafile (ask-user-for-sta-file)))
    (when stafile
      (when (probe-file-safe stafile)
        (let ((statdata (load-stafile stafile)))
          (when statdata
            (pop-up-chart-window statdata)))))))

(defun menu-file-open-sta-as-table ()
  (interactive (:menu ("File" "Open as Table")))
  (let ((stafile (ask-user-for-sta-file)))
    (when stafile
      (when (probe-file-safe stafile)
        (let ((statdata (load-stafile stafile)))
          (when statdata
            (pop-up-table-window statdata)))))))

(defun menu-file-open-sta-as-file ()
  (interactive (:menu ("File" "Open as File")))
  (let ((stafile (ask-user-for-sta-file)))
    (when stafile
      (with-output-to-text-window ((namestring stafile) :width :adjust)
        (show-file stafile)))))


(defun menu-file-load-script ()
  (interactive (:menu ("File" "-Load Script")))
  (statvis-load-script-command))

(defun menu-file-save-script ()
  (interactive (:menu ("File" "Save Script")))
  (statvis-save-script-command))

(defun menu-file-redraw ()
  (interactive (:menu ("File" "-Redraw Tree")))
  (redraw-statdata-network))

(defun menu-file-exit ()
  (interactive (:menu ("File" "-Exit")))
  (close (find-window :main-frame)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Configuration


(defun menu-config-chart-style (view di vas fit co
                                imtpmt idml imti imalms imilms
                                vmtpmt vdml vmti vrt vrb
                                width height)
  (interactive
   (:menu ("Configuration" "Default Chart Style"))
   :element ("View:"
             *statvis-chart-view*
             :of-small-set '(:line :bar))
   :boolean ("DrawIcons:"
             *statvis-chart-di*
             :available-form '(eq view :line))
   :boolean ("ValuesStacked:"
             *statvis-chart-vas*
             :available-form '(eq view :bar))
   :boolean ("Fit:" *statvis-chart-fit*)
   :element ("Orientation:"
             *statvis-chart-co*
             :of-small-set '(:vertical :horizontal))
   ;; Item axis
   :number ("-ItemMinorTicsPerMajorTic:"
            *statvis-chart-imtpmt*
            :of-small-range '(1 1000))
   :boolean ("ItemDrawMinorLabels:"
             *statvis-chart-idml*)
   :number ("ItemMinorTicIncrement:"
            *statvis-chart-imti*
            :of-small-range '(1 1000))
   :number ("ItemMajorLabelMinSpacing:"
            *statvis-chart-imalms*
            :of-small-range '(1 100))
   :number ("ItemMinorLabelMinSpacing:"
            *statvis-chart-imilms*
            :of-small-range '(1 100))
   ;; Value axis
   :number ("-ValueMinorTicsPerMajorTic:" 
            (or *statvis-chart-vmtpmt* 1)
            :of-small-range '(1 1000)
            :available-check nil)
   :boolean ("ValueDrawMinorLabels:"
             *statvis-chart-vdml*)
   :number ("ValueMajorTicIncrement:"
            (or *statvis-chart-vmti* 1)
            :of-small-range '(1 10000)
            :available-check nil)
   :number ("ValueRangeTop:"
            (or *statvis-chart-vrt* 1)
            ;; :of-small-range  '(-1000 1000)
            :available-check nil)
   :number ("ValueRangeBottom:"
            (or *statvis-chart-vrb* 1)
            ;; :of-small-range '(-1000 1000)
            :available-check nil)
   ;; Width, Height
   :number ("-Width:" *statvis-chart-width*
                      :of-range '(100 1000))
   :number ("Height:" *statvis-chart-height*
                      :of-range '(100 1000)))
  (setq *statvis-chart-view* view)
  (when (available-p di)
    (setq *statvis-chart-di* di))
  (when (available-p vas)
    (setq *statvis-chart-vas* vas))
  (setq *statvis-chart-fit* fit
        *statvis-chart-co* co
        *statvis-chart-imtpmt* imtpmt
        *statvis-chart-idml* idml
        *statvis-chart-imti* imti
        *statvis-chart-imalms* imalms
        *statvis-chart-imilms* imilms
        *statvis-chart-vmtpmt* (if-available vmtpmt)
        *statvis-chart-vdml* vdml
        *statvis-chart-vmti* (if-available vmti)
        *statvis-chart-vrt* (if-available vrt)
        *statvis-chart-vrb* (if-available vrb)
        *statvis-chart-width* width
        *statvis-chart-height* height))

(defun menu-config-table-style (cellwidth minwidth maxwidth height)
  (interactive (:menu ("Configuration" "Default Table Style"))
               :number ("CellWidth:" *statvis-table-cellwidth*
                                     :of-range '(10 300))
               :number ("MinWidth:" *statvis-table-minwidth*
                                    :of-range '(100 1000))
               :number ("MaxWidth:" *statvis-table-maxwidth*
                                    :of-range '(100 1000))
               :number ("Height:" *statvis-table-height*
                                  :of-range '(100 1000)))
  (setq *statvis-table-cellwidth* cellwidth
        *statvis-table-minwidth* minwidth
        *statvis-table-maxwidth* maxwidth
        *statvis-table-height* height))


(defun menu-config-node (width height hspace vspace figure
                         fontname fontsize fontstyle
                         thickness linestyle default-color)
  (interactive (:menu ("Configuration" "Default Node Display Properties")
                      :apply :on-change)
               :number   ("Width:"    (box-width *default-node-box*)
                                      :of-range '(1 300))
               :number   ("Height:"   (box-height *default-node-box*)
                                      :of-range '(1 300))
               :number   ("Hspace:"   *layout-network-sugiyama-hspace*
                                      :of-range '(1 300))
               :number   ("Vspace:"   *layout-network-sugiyama-vspace*
                                      :of-range '(1 300))
               :element  ("Figure:"   *default-node-figure*
                                      :of-small-set
                                      '(:circle :box :rounded-box))
               ;; ------------------------------------------------------
               :fontname ("-FontName:" (font-face *default-node-font*))
               :number   ("FontSize:" (font-size *default-node-font*)
                                      :of-range '(8 72))
               :subset   ("FontStyle:" (font-style *default-node-font*)
                                       :of-small-set
                                       '(:bold :italic :underline))
               ;; ------------------------------------------------------
               :number   ("-Thickness:" *default-node-thickness*
                                       :of-range '(1 10))
               :element  ("LineStyle:" *default-node-linestyle*
                                       :of-small-set
                                       '(:solid :dot :dash :dash-dot
                                         :double-dot :long-dash
                                         :dash-double-dot))
               :color    ("-DefaultColor:" *default-node-color*
                                           :predefined t))
  (let ((redraw (or (/= *layout-network-sugiyama-hspace* hspace)
                    (/= *layout-network-sugiyama-vspace* vspace))))
    (setq *default-node-box* (make-box 0 0 width height)
          *layout-network-sugiyama-hspace* hspace
          *layout-network-sugiyama-vspace* vspace
          *default-node-figure* figure
          *default-node-font* (make-font-ex nil fontname fontsize fontstyle)
          *default-node-thickness* thickness
          *default-node-linestyle* linestyle
          *default-node-color* default-color)
    (when redraw
      (redraw-statdata-network))))

(defun menu-config-reset ()
  (interactive (:menu ("Configuration" "Reset Configuration")))
  (statvis-save-config *statvis-default-cfgfile* t)
  (statvis-load-config *statvis-default-cfgfile*))
  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Help

(defun menu-help-about-statvis ()
  (interactive (:menu ("Help" "About STAT-VIS")))
  (with-output-to-text-window ("About STAT-VIS" :width 200 :height 100)
    (format t "Version ~a" statvis-version)))

(defun menu-help-naganuma-rtt ()
  (interactive (:menu ("Help" "Naganuma" "rtt.txt")))
  (with-output-to-text-window ("rtt.txt" :width :adjust :height 600)
    (show-file "statvis-ml/rtt.txt")))


(defun menu-help-naganuma-ukgas ()
  (interactive (:menu ("Help" "Naganuma" "ukgas.txt")))
  (with-output-to-text-window ("ukgas.txt" :width :adjust :height 600)
    (show-file "statvis-ml/ukgas.txt")))
  
(defun menu-help-changelog ()
  (interactive (:menu ("Help" "Change Log")))
  (with-output-to-text-window ("Change Log" :width :adjust)
    (format t "~
* Version 0.19
1. char �X�^�C���̕ۑ�
2. sibling �œ���R�}���h�����s����Ă�΁A����� chart �p�����[�^��

* Version 0.18
1. �c���[�̃Z�[�u�ƃ��[�h

* Version 0.17
1. ���C���E�C���h�E�ɑ���̃c���[��\��

* Version 0.16
1. parcor filtering �̃T�|�[�g

* Version 0.15
1. ar-prediction  method �p�����[�^�� GUI ��ǉ�
2. ���s�R�[�h�� Unix �ɓ���
3. parcor filtering �̃T�|�[�g�͖�����

* Version 0.14
1. acf �� ccf �� type ���w�肷�� GUI ��ǉ�

* Version 0.13
1. .sta �t�@�C�� item-labels �̏d���`�F�b�N

* Version 0.12
1. �e�[�u���̃T�C�Y�w�� Configuration -> Default Table Style �ǉ�

* Version 0.11
1. ML periodgram�Asmoothing=raw �̃P�[�X�̃o�O (GUI �C���^�t�F�[�X) fix

* Version 0.10
1. ���n��f�[�^�����̏ꍇ�A�����ɂ͂��ꎩ�g���o���悤�ɂ���
2. ���x�����ł̓��{��̎������̌��𒼂���

* Version 0.09
1. �r���œr�؂��f�[�^(�\���̌��f�[�^��)�̍Ō�̎����ɏc������ꂽ
   �c���̐F�̓f�[�^�̐��̐F�ŁA��->�L�̏��Ŏ����A�L->�����̏��Ŕj��

* Version 0.08
1. chart-widget �̃o�O (���� bar �Ŗ{��������Ȃ��ƃ_���̌�) fix �p�b�`����ꂽ

* Version 0.07
1. �ړ����σ��j���[�Ɍ��ʂ̂ݕ\������ ResultOnly (�f�t�H���g�� t)����ꂽ

* Version 0.06
1. Interval Summary, average �̃o�O fix
2. Interval Summary, average �e���ϒl�̑Ώۋ�Ԓ��̍ŏ��ő��\��

* Version 0.05
1. Chart/Table �ɃR�����g�o�̓E�C���h�E��ǉ�
2. HoltWinters seasonal(:additive, :multiplicative)  �p�����[�^�� GUI �ǉ�
3. �����̃����������p������悤�ɂ���(�������͂܂�)

* Version 0.04
1. ML Lib ma ���[�̏����̏C��
2. HotWinters frequency �̏�����f�[�^�� / 3 �ɐ���

* Version 0.03
1. ML Lib HoltWinters-prediction, ar-prediction �ւ̃C���^�t�F�[�X�ǉ�
2. ML Lib ma �� SV moving-average ���l�Ɍ��O���t�Əd�ˍ��킹�ĕ\��
3. GUI �̏C��(���l�͈̔́A�f�t�H���g�l)�̕ύX��

* Version 0.02
1. GUI �̏C��: Chart �� Table �̈����̐�����
2. ML Lib �� ma, acf, ccf, periodgram �ւ̃C���^�t�F�[�X��ǉ�
")))

(defun menu-help-todo ()
  (interactive (:menu ("Help" "ToDo")))
  (with-output-to-text-window ("ToDo" :width :adjust)
    (format t "~
* �����������̎�������
* �O���t�̍���
* Table, Chart �E�C���h�E�ɏ��\���T�u�E�C���h�E��t��
* ML Lib �Ƃ̃C���^�t�F�[�X�� brush up
* Linux 64 bit �Ή�
* �c���[�X�N���v�g
")))



(defun menu-help-private-interactive ()
  (interactive (:menu ("Help" "-Private" "Interactive Demo")))
  (run-shell-command "interactive" :wait nil))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Help -> Private
;;; C:/Program Files/acl81/examples/cg/chart-tutorial.cl


(defvar *chart-widget* nil)

(defun menu-help-chart-tutorials-first ()
  (interactive (:menu ("Help" "Private" "Chart Tutorial" "First")))
  (let* ((width 400)
         (height 400)
         (chart-widget
          (make-instance 'chart-widget
            :title "Bowling Scores"
            :chart-view *statvis-chart-view*
            :chart-objects #((:id :doris)
                             (:id :tal)
                             (:id :hubert))
            :item-axis (make-instance 'item-axis
                         :axis-label "Month"
                         :minor-tics-per-major-tic 3
                         :draw-minor-labels nil
                         :on-print-major-label
                         (lambda (month-symbol)
                           (format nil "~:(~a~)" month-symbol)))
            :value-axis (make-instance 'value-axis
                          :axis-label "Average Scores"
                          :margin-inside-axis-label 8
                          :range-bottom 0
                          :range-top 900
                          :major-tic-increment 300)
            :bar-chart-view (make-instance 'bar-chart-view
                              :values-are-stacked *statvis-chart-vas*
                              :bar-width 16
                              :bar-spacing 8)
            :chart-legend (make-instance 'chart-legend
                            :on-print-chart-object
                            (lambda (value)
                              (format nil "~:(~a~)" value)))
            :right-attachment :right
            :bottom-attachment :bottom
            :left 0 :top 0
            :width width :height height))
         (dialog (make-window :chart-tutorial
                   :class 'dialog
                   :owner (screen *system*)
                   :title "Sample Chart"
                   :scrollbars nil
                   :interior (make-box-relative 0 40 width height)
                   :dialog-items (list chart-widget))))
    ;;
    (setq *chart-widget* chart-widget)
    ;;
    (dotimes (item-index 12)
      (dotimes (object-index 3)
        (set-chart-value
         chart-widget
         :item-id (aref #(january february march april may june july
                          august september october november december)
                        item-index)
         :object-id (aref #(:doris :tal :hubert)
                          object-index)
         :value (+ 100 (random 150)))))
    ;;
    dialog))


(defun menu-help-chart-tutorials-empty ()
  (interactive (:menu ("Help" "Private" "Chart Tutorial" "Empty")))
  (let* ((width 500)
         (height 500)
         (chart-widget (make-instance 'chart-widget
                         :chart-view :bar
                         :right-attachment :right
                         :bottom-attachment :bottom
                         :left 0 :top 0
                         :width width :height height))
         (dialog (make-window :chart-tutorial
                   :class 'dialog
                   :owner (screen *system*)
                   :title "Chart Tutorial"
                   :scrollbars nil
                   :interior (make-box-relative 0 40 width height)
                   :dialog-items (list chart-widget))))
    (setq *chart-widget* chart-widget)
    dialog))


(defun menu-help-chart-tutorials-final-1 ()
  (interactive (:menu ("Help" "Private" "Chart Tutorial" "Final-1")))  
  (let* ((width 800)
         (height 400)
         (object-ids #(:doris :hubert :myrtle :cloyd
                       :tal :gladys))
         (chart-widget
          (make-instance 'chart-widget
            :chart-view :line
            :title "Bowling Scores"
            :chart-objects (map 'vector (lambda (id)
                                          (list :id id))
                                object-ids)
            :item-axis (make-instance 'item-axis
                         :axis-label "Date"
                         
                         ;; This one is for data values
                         ;; per minor tic, which in this
                         ;; case is months per quarter.
                         :minor-tic-increment 3
                         
                         ;; A minor tic for each quarter of the year.
                         :minor-tics-per-major-tic 4
                         
                         ;; Draw each major label AFTER its tic
                         ;; mark by half of a major increment.
                         ;; This draws the year in the middle
                         ;; of the set of values for the year.
                         :draw-major-labels :after
                         
                         :draw-minor-labels t
                         :draw-major-grid-lines t
                         :draw-minor-grid-lines t
                         
                         ;; You wouldn't normally spell out each year
                         ;; in English words, but we do so here to
                         ;; illustrate how a major tic label can
                         ;; span across multiple minor tic labels.
                         :major-label-wrapping nil
                         :on-print-major-label
                         (lambda (month-and-year)
                           (format nil "~:(~r~)"
                                   (second month-and-year)))

                         :on-print-minor-label
                         (lambda (month-and-year)
                           (format nil "~:(~a~)"
                                   (first month-and-year)))
                         )
            :value-axis (make-instance 'value-axis
                          :axis-label "Average Scores"
                          :margin-inside-axis-label 8
                          :major-tic-increment 300)
            :line-graph-view (make-instance 'line-graph-view
                               :values-are-stacked nil
                               :draw-icons nil)
            :chart-legend (make-instance 'chart-legend
                            :on-print-chart-object
                            (lambda (value)
                              (format nil "~:(~a~)" value)))
            :right-attachment :right
            :bottom-attachment :bottom
            :left 0 :top 0
            :width width :height height))
         (dialog (make-window :chart-tutorial
                   :class 'dialog
                   :owner (screen *system*)
                   :title "Sample Chart"
                   :scrollbars nil
                   :interior (make-box-relative 0 40 width height)
                   :dialog-items (list chart-widget))))
    (dotimes (item-index 36)
      (dotimes (object-index 6)
        (set-chart-value
         chart-widget
         :item-id (list (aref #(january february march april may
                                june july august september
                                october november december)
                              (mod item-index 12))
                        (+ 2004 (floor item-index 12)))
         :object-id (aref object-ids object-index)
         :value (max 100
                     (min 300
                          (+ (if (plusp item-index)
                                 (chart-value
                                  chart-widget
                                  :item-index (1- item-index)
                                  :object-index object-index)
                               (+ 100 (random 150)))
                             (random 21)
                             -10))))))
    dialog))


(defun menu-help-chart-tutorials-final-2 ()
  (interactive (:menu ("Help" "Private" "Chart Tutorial" "Final-2")))
  (let* ((width 400)
         (height 400)
         (data #(
                 ((2005 sep 12) :doris 164 :tal 156 :temperature 72)
                 ((2006 jan 31) :doris 155 :tal 162 :temperature 68)
                 ((2006 feb 18) :doris 150 :tal 173 :temperature 66)
                 ((2006 aug 18) :doris 172 :tal 148 :temperature 79)
                 ((2006 sep 12) :doris 168 :tal 152 :temperature 77)
                 ))
         (value-axis-2 (make-instance 'value-axis
                         :axis-label "Temperature (red dashes)"
                         :draw-minor-grid-lines nil
                         :draw-minor-labels nil
                         :axis-width 2
                         :axis-color red
                         :major-grid-line-color
                         (make-rgb :red 255 :green 196 :blue 196)
                         :major-label-color dark-red))
         (chart-widget
          (make-instance 'chart-widget
            :title "Bowling Scores and Room Temperature"
            :footnote (format nil "Doris bowls better when it's warmer, ~
                        while Tal bowls betters when it's cooler.")
            :chart-view :line
            :chart-objects #((:id :doris)
                             (:id :tal)
                             (:id :temperature :value-axis 2))
            :item-axis (make-instance 'item-axis
                         :on-print-major-label
                         (lambda (value)
                           (format nil "~:(~a~) ~a ~a"
                                   (second value)(third value)
                                   (first value))))
            :value-axis (make-instance 'value-axis
                          :axis-label "Scores"
                          :axis-width 2
                          :axis-color blue
                          :major-label-color dark-blue
                          :minor-label-color dark-blue)
            :value-axis-2 value-axis-2
            :line-graph-view (make-instance 'line-graph-view
                               :line-dashings
                               '(:solid :solid :dash)
                               :line-colors
                               '(blue dark-green red))
            :fit-chart-items t
            :chart-items-max-index (1- (length data))
            :chart-value-returner
            (lambda (chart-widget value-type item-index
                     object-index object-id)
              (declare (ignore chart-widget object-index))
              (let* ((item-entry (elt data item-index)))
                (case value-type
                  (:id (first item-entry))
                  (:value (getf (rest item-entry) object-id)))))
            
            ;; The legend's print function indicates which
            ;; value goes with each axis.
            :chart-legend
            (make-instance 'chart-legend
              :on-print-chart-object
              (lambda (value)
                (format nil "~:(~a~) (~a axis)"
                        value (case value
                                (:temperature "right")
                                (t "left")))))
            
            :right-attachment :right
            :bottom-attachment :bottom
            :left 0 :top 0
            :width width :height height))
         (dialog (make-window :bowling-and-temperature
                   :class 'dialog
                   :owner (screen *system*)
                   :title "Bowling Scores and Temperature"
                   :scrollbars nil
                   :interior (make-box-relative 0 80 width height)
                   :dialog-items (list chart-widget))))
    
    ;; A final animation:
    ;; Reverse the temperature axis several times to show
    ;; correlations in each orientation.
    (dotimes (j 4)
      (sleep 2)
      (setf (invert-axis value-axis-2) t)
      (sleep 2)
      (setf (invert-axis value-axis-2) nil))
    
    dialog))
