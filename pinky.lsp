
(vl-load-com)							

;;;1.C:Pinky - Главна функция											1
(defun C:Pinky ( / R1 R2 R3 a1 a2 a3 diamh pc1a
		pc1 list2 list3 list4 ang1 ang2 ang2_2
		a1e a2e blockObj flag2 flag3 pt3 ss ime_blokc ime_blokc-1 srad filesList
		file_namepa my_data ss slist13 slist14 dfil dfil-n dfil-n1)

(command "UCS" "W")

(setq a1 13.0 diamh 9.0)					;;; Whodni parametri 
(setq flag2 0 flag3 0)

  (PINKY_DIALOG_1)							; Диалог 0 работа с файлове							3

 (while (= flag2 0)  
  (PINKY_DIALOG_2)					;Диалог 1
 (if (= flag3 0) (PINKY_DIALOG_3))					;Диалог 2
   );end while-flag2
(if (= flag3 0) (progn
(command "_.vpoint" '(-1.0 -1.0 1.0))	  			;Променя изгледа на изометричен
(draw_base R1 a1 diamh)						;Чертае затворена полилиния 1 с entmakex
(setq list1 (entlast))						;Запазва в паметта последния начертан обект -полилиния 1	
(VlaRevolveByLine (entlast) (list 0.0 0.0 0.0) (list 0.0 50.0 0.0) (* 2.0 pi)); Създава солид модел с револв от полилиния, две точки за ос и ъгъл за револв
(setq list2 (ssadd (entlast)))					;Запазва в паметта последния начертан обект -солид 1
(rotobj (ssadd (entlast)) (list 0.0 0.0 0.0) (list 100.0 0.0 0.0) 90.0);; завърта обект около ос на ъгъл
(setq list2 (ssadd (entlast)))					;Запазва в паметта последния начертан обект -солид 1

 (if (= tog_text_pod "1") (progn 
(if (= Fibonachi "1") (DistributeFibonacci (list 0.0 0.0 a2) R1 srad) (DistributeSpheres (list 0.0 0.0 a2) R1 srad)); malki sferi
(if (= subtract_s "1") (Sub3D-Objects list2 gFibSphereSelection)
  (progn (Union3D-Objects gFibSphereSelection) (Union3D-Objects (ssadd (entlast) list2))));Изважда от 1 Solid няколко solid а (от сферата малките сфери)		
(setq list2 (ssadd (entlast)))					;Запазва в паметта последния начертан обект -солид 1
))

(CreateCylinder (polar pc1 0.0 a1e) R3 120.0)			;;Създава цилиндър с център радиус и височина
(rotobj (ssadd (entlast)) pc1a pc2 ang2_2)			;; завърта обект около ос на ъгъл
(setq list3 (ssadd (entlast)))					;Запазва в паметта последния начертан обект -цилиндър 1
(rotobj list3 (list 0.0 0.0 0.0) (list 100.0 0.0 0.0) 90.0)	;; завърта обект около ос на ъгъл
(setq list3 (ssadd (entlast)))					;Запазва в паметта последния начертан обект -цилиндър 1
(CreateCylinder (polar pc2 pi a2e) R2 120.0)			;;Създава цилиндър с център радиус и височина
(rotobj (ssadd (entlast)) pc2 pc1a ang1)			;; завърта обект около ос на ъгъл
(rotobj (ssadd (entlast)) pc1a (list 0.0 150.0 0.0) ang2)	;; завърта обект около ос на ъгъл
(rotobj (ssadd (entlast)) (list 0.0 0.0 0.0) (list 100.0 0.0 0.0) 90.0);; завърта само един обект около ос на ъгъл							само един обект!!!!!
(setq list4 (ssadd (entlast) list3))				;Запазва в паметта последния начертан обект -цилиндър 2 и цилиндър 1в една селекция
(Sub3D-Objects list2 list4)					;Изважда от 1 Solid няколко solid а (от сферата двата цилиндъра)
(setq list4 (ssadd (entlast)))
(DeleteObj list1)						;Изтрива полилиния 1
(InsertBlockWithArgs ime_blokc 0.0 0.0 (cadr pt3) 1.0)		;;Вмъква блок на височина на точка P3
(setq explodedArray (vla-Explode blockObj))			;;Explode block
(vla-Delete blockObj)						;;Изтрива неексплоднатия блок за да не се повтаря
(setq ss (ssadd (entlast) list4))				; Прави селекция на 3Д солидите за да се обединят
(Union3D-Objects ss)						;Обединява 3д солиди (експлоднатия блок с основата)
  (setq slist13 (ssadd (entlast)))
(InsertBlockWithArgs ime_blokc-1 0.0 0.0 (cadr pt3) 1.0)	;;Вмъква блок на височина на точка P3
(setq explodedArray (vla-Explode blockObj))			;;Explode block
(vla-Delete blockObj)						;;Изтрива неексплоднатия блок за да не се повтаря
(vla-zoomall (vlax-get-acad-object))				;;zoom all

(setq slist14 (ssadd (entlast)))



(if (= tog_real_pod "1") (SetRealisticFast)); realistichen izgled
(if (= pod_saveas2 "1") (pinky_d4)) (if (= pod_savenp3 "1") (pinky_d4)); Zapisva vav txt fajl

(if (=  pod_stl "1") (progn (setq dfil (getfiled "Select A Directory" "C:/Pinky/stl/Pinky1" "stl" (+ 1 2)))
(setq dfil-n (substr dfil 1 (- (strlen dfil) 4)) dfil-n1 (strcat dfil-n "-1.stl")) ; Създава име на втория stl файл, за капачката на Pinky
(setvar "FACETRES" 10.0)  (setvar 'FILEDIA 0) (command "_stlout" slist13 "" "_Y" dfil) (command "_stlout" slist14 "" "_Y" dfil-n1) (setvar 'FILEDIA 1))); Zapisva 2 stl file

));end if flg3

  
  );end defun

;;;Diaog 1							Diaog 1						Diaog 1
;;;Diaog 1							Diaog 1						Diaog 1
;;;																		Dialogs				Dialogs	
;;;(PINKY_DIALOG_1) Диалог 1 работа с файлове										2
(defun PINKY_DIALOG_1 (/ Dcl_Id)
(setq Dcl_Id (load_dialog "C:/Pinky/Pinky.dcl"))						;Зарежда диалоговия прозорец
(if (not (new_dialog "Pinky2" Dcl_Id)) (progn (alert
"No file or window definition found.\nFile path:C:/Pinky/Pinky.dcl \nWindow name:Pinky2") (exit) ))
  
(setq filesList (vl-directory-files "C:/Pinky/Dat" "*.dat" 1))					;;Взема имената на всички файлове с разширение dat от директория C:/Pinky/Dat
(start_list "file_list_1") (mapcar 'add_list filesList) (end_list) (set_tile "file_list_1" "0") ; Зарежда списък с в поле 1
(GetFirstWords "Elia.dat")									;;3.1. Отваря текстови файл и чете първата дума от всеки ред
(start_list "file_list_2") (mapcar 'add_list word_list) (end_list) (set_tile "file_list_2" "0") ; Зарежда списък с в пполе 2
(mode_tile "file_list_1" 1)  (mode_tile "file_list_2" 1) (mode_tile "delete_record" 1) (set_tile "dsave" "1") 
(action_tile "get_p" "(if (= $value \"1\")
       (progn (mode_tile \"file_list_1\" 0) (mode_tile \"file_list_2\" 0) (mode_tile \"delete_record\" 0)(setq flag5 1)) ;  (Show)
       (progn (mode_tile \"file_list_1\" 1) (mode_tile \"file_list_2\" 1) (mode_tile \"delete_record\" 1) (setq flag5 0)) ; (Hide)
     )") 
(action_tile "file_list_1" "(setq nomlist $value) (action_list_1)")
(action_tile "file_list_2" "(setq nomlist2 $value) (action_list_2) ")
(action_tile "delete_record" "(delete_record1)")						;Изтрива запис - ред от dat файл с определено име 
(action_tile "accept" "(get_data_pink_DIAL_1) (done_dialog)")
(action_tile "cancel" "(setq flag2 1 flag3 1) (done_dialog)") 
(start_dialog) (unload_dialog Dcl_Id) (princ)
  );end defun	




;;;(action_list_1) какво се случва ако се избере нещо от списъка на първия лист прозорец				2.1
(defun action_list_1 ( / word_list) 
(setq pod_flist1 nomlist file_namep (nth (atoi pod_flist1) filesList)    )
(GetFirstWords file_namep) (start_list "file_list_2") (mapcar 'add_list word_list) (end_list) (set_tile "file_list_2" "0")
  );end defun
;;;;(GetFirstWords filenamep). Отваря текстови файл и чете първата дума от всеки ред    			2.1.1
(defun GetFirstWords (filenamep / file_path file_handle current_line first_word )
  (setq file_path (strcat "C:\\Pinky\\Dat\\" filenamep)) 							;; 1. Точен път до файла
   (setq word_list nil) 											;; Инициализиране на празен списък за резултата
  (if (setq file_handle (open file_path "r"))									;; 2. Проверка дали файлът съществува и отваряне за четене ("r")
    (progn
      (while (setq current_line (read-line file_handle))							;; 3. Четене на файла ред по ред до самия му край
        (setq current_line (vl-string-trim " \t" current_line))							;; Премахваме излишни интервали в началото и края на реда
        (if (/= current_line "")										;; Проверяваме дали редът не е празен
          (progn
            (setq first_word (read current_line))								;; Трик с функцията (read): тя взима само първия израз от текста
            (setq word_list (cons (vl-prin1-to-string first_word) word_list))					;; Превръщаме го в текст и го добавяме в нашия списък
          )))
      (close file_handle)											;; Задължително затваряне на файла след четенето
      (setq word_list (reverse word_list))									;; 4. Обръщаме списъка, защото (cons) ги подрежда отзад напред
    )
    (princ (strcat "\nГрешка: Файлът " file_path " не може да бъде намерен!")))
  ;; Функция връща списъка като краен резултат
  word_list
);end defun

;;;(action_list_2) какво се случва ако се избере нещо от списъка на втория лист прозорец				2.2
(defun action_list_2 ( / )
(setq file_namepa (nth (atoi (get_tile "file_list_1")) filesList))
(setq my_data (ReadSpecificLineData file_namepa (atoi nomlist2)))
(set_tile "data" (nth 1 my_data))			;Изписва година месец дата час
  );end defun
;;;2.3. (delete_record1)  Изтрива ред от текстовия файл									2.3
(defun delete_record1 (/)
(setq	del_line1 (+ (atoi (get_tile "file_list_2")) 1)
	pod_flist1 (get_tile "file_list_1")
	file_namep (nth (atoi pod_flist1) filesList)
	)
(DeletePinkyLine file_namep del_line1) (if (= nomlist nil) (setq nomlist "0"))     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (action_list_1)								;Зарежда списък в втория лист
  );end defun

;;;2.4 (get_data_pink_DIAL_1) Взема данни от диалоговия прозорец									2.4
(defun get_data_pink_DIAL_1 (/)
  (setq
;;;    add_pppp (get_tile "add_p")
	pod_get_name (get_tile "get_p")
	Name_of_exp1 (get_tile "Name_of_exp")
	file_namepa (nth (atoi (get_tile "file_list_1")) filesList)
	pod_nom_zapis (atoi (get_tile "file_list_2"))
	pod_save1 (get_tile "dsave")
	pod_saveas2 (get_tile "saveas")
	pod_savenp3 (get_tile "nprof")
	pod_stl (get_tile "create_stl"))
(setq my_data (ReadSpecificLineData file_namepa pod_nom_zapis))
(if (= pod_get_name "1")
(setq Diam1_pod (nth 2 my_data)
      Rad1_pod (nth 3 my_data)
	a1_pod (nth 4 my_data)
      ang11_pod (nth 5 my_data)
      ang12_pod (nth 6 my_data)
      Rad2_pod (nth 7 my_data)
      a2_pod (nth 8 my_data)
      ang22_pod (nth 9 my_data)  								;;;;;;;;;;;tuk       
      ))
);end defun



;;;Diaog 2							Diaog 2						Diaog 2
;;;Diaog 2							Diaog 2						Diaog 2




;;;4. (PINKY_DIALOG_2) Извиква диалогов прозорец 1									4
(defun PINKY_DIALOG_2 (/ Dcl_Id)
(setq Dcl_Id (load_dialog "C:/Pinky/Pinky.dcl"))
(if (not (new_dialog "Pinky" Dcl_Id)) (progn (alert
"No file or window definition found.\nFile path:C:/Pinky/Pinky.dcl \nWindow name:Pinky")
					      (exit) ))
(if (= Diam1_pod nil) (setq Diam1_pod "60"))
(if (= Rad1_pod nil) (setq Rad1_pod "8.5")) (if (= a1_pod nil) (setq a1_pod "2.5"))
(if (= ang11_pod nil) (setq ang11_pod "10")) (if (= ang12_pod nil) (setq ang12_pod "15"))
(if (= Rad2_pod nil) (setq Rad2_pod "9")) (if (= a2_pod nil) (setq a2_pod "1.3"))
(if (= ang21_pod nil) (setq ang21_pod "0.0")) (if (= ang22_pod nil) (setq ang22_pod "0.0")) 
  (set_tile "Diam" Diam1_pod)
  (set_tile "Rad1" Rad1_pod) (set_tile "a1" a1_pod) (set_tile "ang11" ang11_pod) (set_tile "ang12" ang12_pod)
  (set_tile "Rad2" Rad2_pod) (set_tile "a2" a2_pod) (set_tile "ang22" ang22_pod)								;;;;;;;;;;;tuk       
  (setq x1 (dimx_tile "im") y1 (dimy_tile "im"))
  (start_image "im") (fill_image 0 0 x1 y1 -15) (slide_image -80 -160 (fix (* x1 1.7)) (fix (* y1 1.7)) "c:/Pinky/p1.sld") (end_image) 
;;;  (action_tile "Back1" "(setq flag2 0) (done_dialog)")											;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(action_tile "accept" "(acceptCallback_pink)")
(action_tile "cancel" "(setq flag2 1 flag3 1) (done_dialog)") 
(start_dialog) (unload_dialog Dcl_Id) (princ)
);end defun	
;;;5. (savedatpink) - Взема данни от диалоговия прозорец 1							5

(defun acceptCallback_pink ( / )
(setq	Diam1_pod (get_tile "Diam")
	R1 (/ (atof Diam1_pod) 2.0)
	Rad1_pod (get_tile "Rad1")
	R2 (atof Rad1_pod)
	Rad2_pod (get_tile "Rad2")
	R3 (atof Rad2_pod)
	ang11_pod (get_tile "ang11")
	ang1 (atof ang11_pod)
	ang12_pod (get_tile "ang12")
	ang2 (atof ang12_pod)
	ang22_pod (get_tile "ang22")
	ang2_2 (atof ang22_pod)
	a1_pod (get_tile "a1")
	a1e (atof a1_pod)
	a2_pod (get_tile "a2")
	a2e (atof a2_pod)
	)	  
  	(if (savedatpink) (done_dialog 1))	  
); end of defun : acceptCallback

(defun savedatpink (/)
  
(cond ((or (< R1 15.0) (> R1 70.0)) (progn (alert "Sphere diameter D must be between 30 and 140[mm]")(mode_tile "Diam" 2)) nil)
      ((or (< R2 5.0) (> R2 25.0)) (progn (alert "Radius R1 must be between 5 and 25[mm]") (mode_tile "Rad1" 2)) nil)
      ((or (< a1e 0.0) (> a1e R2)) (progn (alert "Distance d1 must be between 0 and R1[mm]") (mode_tile "a1" 2)) nil)
      ((or (< ang1 -90.0) (> ang1 90.0)) (progn (alert "Angle a1 must be between -90 and 90[deg]") (mode_tile "ang11" 2)) nil)
      ((or (< ang2 -90.0) (> ang2 90.0)) (progn (alert "Angle a12 must be between -90 and 90[deg]") (mode_tile "ang12" 2)) nil)

      
      ((or (< R3 5.0) (> R3 25.0)) (progn (alert "R3 must be between 5 and 25[mm]") (mode_tile "Rad2" 2)) nil)
      (T T)
      )     
  );end defun








;;;Diaog 3							Diaog 3						Diaog 3
;;;Diaog 3							Diaog 3						Diaog 3

;;;6. (PINKY_DIALOG_3) Извиква диалогов прозорец 3									6
(defun PINKY_DIALOG_3 (/ Dcl_Id1)
(setq Dcl_Id1 (load_dialog "C:/Pinky/Pinky.dcl"))
(if (not (new_dialog "Pinky1" Dcl_Id1)) (progn (alert
"No file or window definition found.\nFile path:C:/Pinky/Pinky.dcl \nWindow name:Pinky1") (exit)))
(setq list_dial (list "Pencil" "Writing pen" "Pen 1 -d11" "Pen 2-d12"))
(start_list "Block1") (mapcar 'add_list list_dial) (end_list)
 (if (= Block1_pod nil) (setq Block1_pod "1")) (set_tile "Block1" Block1_pod)
(setq list_dials (list "1" "1.25" "1.5" "1.75" "2" "2.5"))
(start_list "srad") (mapcar 'add_list list_dials) (end_list)
 (if (= srad_pod nil) (setq srad_pod "1") (set_tile "srad" srad_pod))
 (if (= srad_pod nil) (setq srad_pod "1") (set_tile "srad" srad_pod))
 (if (= tog_real_pod nil) (setq tog_real_pod "0")) (set_tile "Tog_real" tog_real_pod)
 (if (= subtract_s nil) (setq subtract_s "0")) (set_tile "Tog3" subtract_s)
  (set_tile "Toggtext" "0") (mode_tile "Radio2" 1) (mode_tile "srad" 1) (mode_tile "Tog3" 1)
  (set_tile "Fib1" "1")
(action_tile "Toggtext"
    "(if (= $value \"1\")
       (progn (mode_tile \"Radio2\" 0) (mode_tile \"srad\" 0) (mode_tile \"Tog3\" 0)) ;  (Show)
       (progn (mode_tile \"Radio2\" 1) (mode_tile \"srad\" 1) (mode_tile \"Tog3\" 1)) ; (Hide)
     )"
  )
(action_tile "Next" "(savedatpink2) (done_dialog)")
(action_tile "Back" "(setq flag2 0) (done_dialog)")
 (action_tile "cancel" "(setq flag2 1 flag3 1) (done_dialog)")
(start_dialog) (unload_dialog Dcl_Id1) (princ)
);end defun
;;;7. (savedatpink2) - Взема данни от диалоговия прозорец 3							7
(defun savedatpink2 (/)
  (setq	Block1_pod (get_tile "Block1")
	flag2 1
	tog_real_pod (get_tile "Tog_real")
	tog_text_pod (get_tile "Toggtext")
	srad_pod (get_tile "srad")
	Fibonachi (get_tile "Fib1")
	subtract_s (get_tile "Tog3")
	)
  (cond ((= Block1_pod "0") (setq ime_blokc "p1" ime_blokc-1 "p1-1"))
	((= Block1_pod "1") (setq ime_blokc "p2" diamh 9.0 ime_blokc-1 "p2-1"))
	((= Block1_pod "2") (setq ime_blokc "p3" diamh 11.3 ime_blokc-1 "p3-1"))
	((= Block1_pod "3") (setq ime_blokc "p4" diamh 12.1 ime_blokc-1 "p4-1"))
    )
  (cond ((= srad_pod "0") (setq srad 1.0))
	((= srad_pod "1") (setq srad 1.25))
	((= srad_pod "2") (setq srad 1.5))
	((= srad_pod "3") (setq srad 1.75))
	((= srad_pod "4") (setq srad 2.0))
	((= srad_pod "3") (setq srad 2.5))
    )
)
;;;																	end	Dialogs	end				Dialogs










;;;8. (draw_base) - Изчислява точки и чертае основната геометрия - затворена полилиния				8
(defun draw_base (R1 a1 diamh / bulge pt2 pt3x pt4 pt5)
(setq pt1 '(0.0 0.0)
	pt2 (polar pt1 0.0 a1)
	pt3x (polar pt1 0.0 (/ diamh 2.0))
      	a2 (sqrt (- (* R1 R1) (* a1 a1)))
	a3 (sqrt (- (* R1 R1) (* (/ diamh 2.0) (/ diamh 2.0))))
	pt3 (polar pt3x (/ pi 2.0) (+ a2 a3))
	pt5 (list 0.0 3.0)			;Промяна
      	Pt4 (polar pt5 0.0 (/ diamh 2.0))	;която увеличава дълбочината на отвор за химикал или молив    
      	pc1a (polar pt1 (/ pi 2.0) a2)
	pc1 (polar pc1a 0.0 R1)
	pc2 (polar pc1a pi R1)
      bulge (GetBulge pt2 pt3 R1)
	)
(entmake (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity") '(100 . "AcDbPolyline") '(90 . 5)                
      '(70 . 1)                ; 1 = Затворена полилиния (0 = Отворена)
      (cons 10 pt1)
      (cons 10 pt2) (cons 42 bulge)          ; Задава арка след този връх
      (cons 10 pt3)
      (cons 10 pt4)
      (cons 10 pt5)))
  );end defun



;;;8.1 (GetBulge) Изчислява изпъкналост за построяване на дъги с полилинията					8.1
(defun GetBulge (p1 p2 rad / dist h)
  (setq dist (distance p1 p2)) 			; Дължина на хордата
  (if (<= (* 2.0 rad) dist)
    (setq h rad) 				; Ако радиусът е минимален (полукръг)
    (setq h (- rad (sqrt (- (* rad rad) (* (/ dist 2.0) (/ dist 2.0))))))
  )
  (/ (* 2.0 h) dist) 				; Връща bulge стойността
);end defun

;;;9. (VlaRevolveByLine) Завърта затворена полилиния на ъгъл така, че да се получи Solid обект			9
;;Funkcia za Revolve poliline to Solid необходими са две точки за ос i ъгъл на завъртане
(defun VlaRevolveByLine (polyEname p1 p2 anglerot / acadObj doc space lineEname polyVla lineVla regionList regionObj axisDir solidObj )
   (if (/= polyEname nil)
    (progn
      (setq acadObj (vlax-get-acad-object)
            doc     (vla-get-ActiveDocument acadObj)
            space   (vla-get-ModelSpace doc)
            polyVla (vlax-ename->vla-object polyEname)
      )
      ;; Създаване на регион
      (setq regionList (vla-AddRegion space (vlax-make-variant (vlax-safearray-fill (vlax-make-safearray vlax-vbObject '(0 . 0)) (list polyVla)))))
      (setq regionObj (vlax-safearray-get-element (vlax-variant-value regionList) 0)) 
      (setq axisDir (mapcar '- p2 p1));; Изчисляване на 3D вектора на посоката (p2 - p1)
      (setq solidObj (vla-AddRevolvedSolid space 
                                           regionObj 
                                           (vlax-3d-point p1) 
                                           (vlax-3d-point axisDir) 
		       anglerot)
	    )
      (vla-delete regionObj)
    )
  )
  (princ)
);end defun
;;;10. (CreateCylinder pt rad hgt) Създава цилиндър с център радиус и височина					10
(defun CreateCylinder ( pt rad hgt / acadObj doc modelSpace wcsPt centerPt cylObj )
  (if (and pt rad hgt (> rad 0) (/= hgt 0))
    (progn
      (setq acadObj (vlax-get-acad-object))
      (setq doc (vla-get-ActiveDocument acadObj))
      (setq modelSpace (vla-get-ModelSpace doc))
      (setq wcsPt (trans pt 1 0));; Преобразуване на точката от текущата UCS (1) към WCS (0) за ActiveX
      (setq centerPt (vlax-3d-point wcsPt))
      (setq cylObj (vla-AddCylinder modelSpace centerPt rad hgt)) ;; Създаване на цилиндъра
      ;; Връщане на обекта като резултат от функцията
      cylObj
    )
    nil
  )
)
;;;11. (mobj Sobj pm1 pm2) - Функция която премества обект от една базова точка до друга			11
;Funkciq za mestene na 3d obekti
(defun mobj (Sobj pm1 pm2 / v1 v2 obj)
              (setq obj (vlax-ename->vla-object (ssname Sobj 0)))	 ;; Конвертиране на избрания обект във VLA-обект
              (setq v1 (vlax-3d-point pm1)) (setq v2 (vlax-3d-point pm2));; Преобразуване на 3D точките в ActiveX Variant масиви
              (vla-Move obj v1 v2)					 ;; Изпълнение на преместването
  );end defun
;;;12. (rotobj Sobjr pm1 pm2 angler) -  Функция която завърта обект около ос определена от 2 точки на ъгъл	12
;Funkcia za zavartane na 3d solid okolo os ot dve tochki
(defun rotobj (Sobjr pm1 pm2 angler / v1 v2 angle_rad obj)
                  (setq angle_rad (* angler (/ pi 180.0)))	      	     ;;; Конвертиране на ъгъла от градуси в радиани
                  (setq obj (vlax-ename->vla-object (ssname Sobjr 0)))	     ;; Преобразуване на обекта във VLA-обект 
                  (setq v1 (vlax-3d-point pm1)) (setq v2 (vlax-3d-point pm2));; Преобразуване на точките в ActiveX 3D вектори
                  (vla-Rotate3D obj v1 v2 angle_rad)			     ;; Изпълнение на 3D завъртането
  );end defun
;;;14. (InsertBlockWithArgs blockName xCoord yCoord zCoord scale) - Вмъква блок създаден в текущия чертеж	14
;; Подпрограма за вмъкване на блок (с параметри)
(defun InsertBlockWithArgs (blockName xCoord yCoord zCoord scale / acadObj docObj modelSpace blocksObj insPoint) 
  (setq insPoint (vlax-3d-point (list xCoord yCoord zCoord)));; Преобразуване на координатите във формат на ActiveX
  (setq acadObj (vlax-get-acad-object))			    ;; Достъп до обектите на AutoCAD
  (setq docObj (vla-get-ActiveDocument acadObj))
  (setq modelSpace (vla-get-ModelSpace docObj))
  (setq blocksObj (vla-get-Blocks docObj))
  ;; Проверка за съществуване на блока и вмъкване
  (if (not (vl-catch-all-error-p (vl-catch-all-apply 'vla-Item (list blocksObj blockName))))
      ;; Вмъкване с еднакъв мащаб по X, Y, Z и ротация 0.0
      (setq blockObj (vla-InsertBlock modelSpace insPoint blockName scale scale scale 0.0))
    (princ (strcat "\nГрешка: Блокът '" blockName "' не е намерен в чертежа!"))
  )
)
;;;15. (DeleteObj ent) - изтрива избран обект									15
(defun DeleteObj (ent / )
  (if ent
    (vla-delete (vlax-ename->vla-object ent)) ; Превръщане във VLA-обект и изтриване
    (princ "\nНе е избран обект.")
  )
  (princ) 
)
;;;16. (Sub3D-Objects list2 list4) - Изважда от 1 Solid няколко solid а (от сферата двата цилиндъра)		16
;; Аргументи: 
;;   mainSS - selection set, съдържащ главния обект (първия елемент)
;;   subSS  - selection set, съдържащ обектите за изваждане
(defun Sub3D-Objects (mainSS subSS / mainEname mainVla i subEname subVla)
  (if (and mainSS subSS (> (sslength mainSS) 0))
    (progn
      (setq mainEname (ssname mainSS 0));; 1. Вземаме първия обект от главния селекционен сет и го правим VLA-обект
      (setq mainVla (vlax-ename->vla-object mainEname))
      (if (= (vla-get-ObjectName mainVla) "AcDb3dSolid") ;; Проверка дали главният обект е 3D Solid
        (progn 
          (setq i 0);; 2. Цикъл за обхождане на всички обекти в сета за изваждане (subSS)
          (while (< i (sslength subSS))
            (setq subEname (ssname subSS i))
            (setq subVla (vlax-ename->vla-object subEname))   
            (if (= (vla-get-ObjectName subVla) "AcDb3dSolid");; Проверка дали текущият обект за изваждане е 3D Solid
              (vla-Boolean mainVla 2 subVla) ;; Изваждане (2 = acSubtraction) 0 = acUnion (Обединение) 1 = acIntersection (Сечение)
            )
            (setq i (1+ i))
          )
          (vla-Update mainVla)
          t ;; Успешно изпълнение
        )
        nil ;; Главният обект не е 3D Solid
      )
    )
    nil ;; Празни селекционни сетове
  )
)

;;;17. (Union3D-Objects ss) - Обединение на солид обекти избрани с ssad						17
;;   ss - selection set (създаден с ssadd), съдържащ всички 3D Solids
(defun Union3D-Objects (ss / mainEname mainVla i subEname subVla)
  (if (and ss (> (sslength ss) 1));; Проверяваме дали сетът съществува и има поне 2 обекта за съединяване
    (progn
      (setq mainEname (ssname ss 0));; 1. Вземаме първия обект (индекс 0) за основа и го правим VLA-обект
      (setq mainVla (vlax-ename->vla-object mainEname))
      (if (= (vla-get-ObjectName mainVla) "AcDb3dSolid");; Проверка дали първият обект е 3D Solid
        (progn
          (setq i 1);; 2. Започваме цикъл от втория обект (индекс 1) до края на сета
          (while (< i (sslength ss))
            (setq subEname (ssname ss i))
            (setq subVla (vlax-ename->vla-object subEname))
            (if (= (vla-get-ObjectName subVla) "AcDb3dSolid");; Проверка дали текущият обект също е 3D Solid
              (vla-Boolean mainVla 0 subVla) ;; 0 = acUnion (Обединение)
            )
            (setq i (1+ i))
          )
          (vla-Update mainVla)
          t ;; Успех
        )
        nil ;; Първият обект не е 3D Solid
      )
    )
    nil ;; Недостатъчно обекти в селекцията (поне 2 са нужни)
  )
)

;;;18. (SetRealisticFast) Задава реалистично изображение								18
(defun SetRealisticFast ()
  (vla-SendCommand (vla-get-ActiveDocument (vlax-get-acad-object)) "_.vscurrent _realistic ")
  (princ)
)
;;;19. (Create3DSphereVL centerPt radius) ЗСъздава сфера								19
(defun Create3DSphereVL (centerPt radius / acadObj docObj mSpace normPt centerVariant sphereObj)
  (vl-catch-all-apply
    '(lambda ()
       (setq normPt (list (car centerPt) (cadr centerPt) (if (caddr centerPt) (caddr centerPt) 0.0)));; Подсигуряваме, че точката е 3D списък с точно 3 елемента (X Y Z)
       (setq acadObj (vlax-get-acad-object));; Вземане на основните обекти
       (setq docObj (vla-get-ActiveDocument acadObj))
       (setq mSpace (vla-get-ModelSpace docObj))
       (setq centerVariant (vlax-3d-point normPt)) ;; Трансформация на чистия LISP списък в ActiveX Variant
       (setq sphereObj (vla-AddSphere mSpace centerVariant radius));; Създаване на сферата
       sphereObj
     )));end defun

;; 20 (DistributeSpheres) Основна функция за разпределение на малки сфери разпределение с Array						20
(defun DistributeSpheres (centerPt bigRadius smallRadius / latSteps lonSteps 
                               i j lat lon x y z currentPt sphereObj sphereEname) 
;;;  (setq centerPt    (list 0.0 0.0 150.0)) ; Център на голямата сфера
;;;  (setq bigRadius   100.0)             ; Радиус на голямата повърхнина
;;;  (setq smallRadius 1.5)               ; Радиус на малките сфери
  (setq latSteps    12)                ; Брой стъпки по ширина (вертикално)
  (setq lonSteps    21)                ; Брой стъпки по дължина (хоризонтално)
  (setq gSphereSelection (ssadd)) ;; 1. Създаваме нов празен селекционен сет
  
  (defun AddToSet (obj);; Помощна локална функция за преобразуване и добавяне към селекцията
    (if obj
      (progn
        (setq sphereEname (vlax-vla-object->ename obj));; Превръщаме VLA-Object в Entity Name (ename)
        (ssadd sphereEname gSphereSelection);; Добавяме го към селекционния сет
      )
    )
  );end defun na pomostnata funkcia

  (setq i 1);; Цикъл по географска ширина
  (while (< i latSteps)
    (setq lat (- (* (/ (float i) latSteps) pi) (/ pi 2.0)))
    (setq j 0);; Цикъл по географска дължина
    (while (< j lonSteps)
      (setq lon (* (/ (float j) lonSteps) 2.0 pi))
      (setq x (+ (car centerPt)   (* bigRadius (cos lat) (cos lon))))
      (setq y (+ (cadr centerPt)  (* bigRadius (cos lat) (sin lon))))
      (setq z (+ (caddr centerPt) (* bigRadius (sin lat))))
      (setq currentPt (list x y z))
    (if (and (> i 1) (< i 11)) (progn					;; С този иф махам сфери от полюсите (близки до полюсите !!!!!!!!!!!!)										!!!!!
      (setq sphereObj (Create3DSphereVL currentPt smallRadius));; Генерираме сферата и я хващаме в променлива ползват се вече дефинирани функции
      (AddToSet sphereObj);; Добавяме я към селекцията
      ))
      (setq j (1+ j))
    )
    (setq i (1+ i))
  ) 
;;;  (princ "\nПроменливата 'gSphereSelection' е готова за ползване.")
  (setq gFibSphereSelection gSphereSelection)
);end defun


;; 21 (DistributeFibonacci centerPt bigRadiu) Основна функция за разпределение на малки сфери Фибоначи						21
(defun DistributeFibonacci (centerPt bigRadius smallRadius / totalSpheres 
                                  goldenRatio i phi theta cosTheta sinTheta x y z currentPt sphereObj sphereEname)
;;;  (setq centerPt     (list 0.0 0.0 0.0)) ; Център на голямата сфера
;;;  (setq bigRadius    100.0)             ; Радиус на голямата повърхнина
;;;  (setq smallRadius  2.0)               ; Радиус на малките сфери
  (setq totalSpheres 200)               ; Общ брой сфери за перфектно разпределение
  (setq goldenRatio (* pi (- 3.0 (sqrt 5.0))));; Златното сечение (ъгъл в радиани за оптимално завъртане)
  (setq gFibSphereSelection (ssadd));; 1. Създаваме нов празен селекционен сет
  (defun AddToFibSet (obj);; Помощна локална функция за добавяне към селекцията
    (if obj
      (progn
        (setq sphereEname (vlax-vla-object->ename obj))
        (ssadd sphereEname gFibSphereSelection)
      )
    )
  );end defun na pomostnata funkcia
  (setq i 0)
  (while (< i totalSpheres)
    ;; 1. Изчисляваме Z позицията (линейно разпределена от 1 до -1)
    ;; Добавя се отместване (0.5 / totalSpheres), за да се избегнат крайните полюси
    (setq cosTheta (- 1.0 (/ (+ (float i) 0.5) (/ totalSpheres 2.0))))
    (setq sinTheta (sqrt (- 1.0 (* cosTheta cosTheta)))) 
    (setq phi (* i goldenRatio)) ;; 2. Изчисляваме ъгъла около вертикалната ос Z
    ;; 3. Сферични тригонометрични формули за X, Y и Z
    (setq x (+ (car centerPt)   (* bigRadius sinTheta (cos phi))))
    (setq y (+ (cadr centerPt)  (* bigRadius sinTheta (sin phi))))
    (setq z (+ (caddr centerPt) (* bigRadius cosTheta)))
    (setq currentPt (list x y z))

    (if (and (> i 10) (< i 190)) (progn 			;;; С този иф се махат точки близки до двата полюса на сферата  !!!!!!!!!!!!!!										!!!!!!
    ;; Генерираме сферата и я добавяме към селекцията
    (setq sphereObj (Create3DSphereVL currentPt smallRadius))
    (AddToFibSet sphereObj)
));end if
    (setq i (1+ i))
  ) 
;;;  (princ "\nПроменливата 'gFibSphereSelection' е готова за ползване.")
)













;;;22. (WritePinky) Функция която записва геометрични параметри във външен файл 								22
(defun WritePinky (fName1 Pname Pdata Pdiam Pr1 Pd1 Pang11 Pang12 Pr2 Pd2 Pang21 / f FilePath)
  (setq FilePath (strcat "C:\\Pinky\\Dat\\" fName1)) 
  (setq f (open FilePath "a")) ;; Отваряме файла за запис и допълване ("а")
  (write-line (strcat Pname " " Pdata " " Pdiam " " Pr1 " " Pd1 " " Pang11 " " Pang12
		      " " Pr2 " " Pd2 " " Pang21) f)
      (close f)
);end defun
;;;23. (DeletePinkyLine )Изтрива ред на dat файл . Функция която изтрива един ред от външен текстови файл. 					23
(defun DeletePinkyLine (filename line_to_delete / file_path file_handle current_line line_counter lines_list write_handle )
  (setq file_path (strcat "C:\\Pinky\\Dat\\" filename));; 1. Задаване на точния път до файла
  (if (findfile file_path);; 2. Проверка дали файлът изобщо съществува
    (progn
      (setq file_handle (open file_path "r"))				;; 4. Отваряне на файла за четене ("r")
      (setq line_counter 1)
      (setq lines_list nil)
      (while (setq current_line (read-line file_handle))		;; Четем файла ред по ред до самия му край
        (if (/= line_counter line_to_delete)				;; Ако текущият ред НЕ Е този за изтриване, го запазваме в списък
          (setq lines_list (cons current_line lines_list))
        )
        (setq line_counter (1+ line_counter))
      )
      (close file_handle) ; Задължително затваряме файла след четене   
      (setq lines_list (reverse lines_list));; Обръщаме списъка, тъй като (cons) ги подрежда наобратно
      
      (setq write_handle (open file_path "w"));; 5. Отваряне на същия файл за нов запис ("w"), което изтрива старото му съдържание
      ;; Записваме обратно само запазените редове
      (foreach line lines_list
        (write-line line write_handle)
      )
      (close write_handle) ; Задължително затваряме файла след записа
    )
  )
  (princ) ; Чист изход
);end defun


;;;;24. (ReadSpecificLineData) Чете данни от текстовия файл и ги присвоява на геометричните размереи за попълване на диалогов прозорец 2		24
(defun ReadSpecificLineData ( file_name line_to_read / folder_path full_path file_handle line_counter 
                                                       current_line raw_list result_list raw_dt 
                                                       year month day hours minutes item )
  (setq folder_path "C:\\Pinky\\dat\\");; 1. Постоянен път до папката
  (setq full_path (strcat folder_path file_name))
  (setq result_list nil)
  (if (setq file_handle (open full_path "r"));; 2. Отваряне на файла за четене
    (progn
      (setq line_counter 0) ; Броенето вече започва от 0
      (while (and (<= line_counter line_to_read) (setq current_line (read-line file_handle)));; Превъртаме до нужния ред
        (if (= line_counter line_to_read)
          (setq raw_list (read (strcat "(" current_line ")")))
        )
        (setq line_counter (1+ line_counter))
      )
      (close file_handle)
      (if raw_list 	;; 3. Обработка на данните, ако редът е намерен
        (progn
          ;; Пълним списъка с текстови стойности
          (foreach item raw_list
            (setq result_list (cons (vl-prin1-to-string item) result_list))
          )
          ;; Обръщаме списъка, за да си върне оригиналната подредба (индекси 0 до 9)
          (setq result_list (reverse result_list))
        )
      )
    )
  )
  ;; Връща готов списък с 10 стринга или nil, ако файлът/редът липсва
  result_list 
);end defun


;;; 25. (GetTimeStr) Взема текущата година и време												25
(defun GetTimeStr ( / cdate_val cdate_str year month day hours minutes time_string )
  (setq cdate_val (getvar "CDATE")) ;; 1. Взимане на текущото време от AutoCAD
  (setq cdate_str (rtos cdate_val 2 6))
  (setq year    (substr cdate_str 1 4))  ; Година
  (setq month   (substr cdate_str 5 2))  ; Месец
  (setq day     (substr cdate_str 7 2))  ; Ден
  (setq hours   (substr cdate_str 10 2)) ; Час
  (setq minutes (substr cdate_str 12 2)) ; Минута
  (setq time_string (strcat year "g" month "m" day "d" hours ":" minutes))
);end defun








;;;; 26 Диалогов прозорец
(defun pinky_d4 ( / Dcl_Id new-string)
(setq Dcl_Id (load_dialog "C:/Pinky/Pinky.dcl"))
(if (not (new_dialog "Pinky4" Dcl_Id)) (progn (alert
"No file or window definition found.\nFile path:C:/Pinky/Pinky.dcl \nWindow name:Pinky4") (exit) ))
  (if (= pod_saveas2 "1") (progn
(if (= file_namepa nil) (progn (mode_tile "Name_of_ak" 1) (set_tile "Name_of_ak" "Maradona.dat"))
  (progn (mode_tile "Name_of_ak" 1) (setq new-string (substr file_namepa 1 (- (strlen file_namepa) 4))) (set_tile "Name_of_ak" new-string)))
		     ))
 (if (= Name_of_exp1 nil) (set_tile "Name_of_exp" "Pinky1") (set_tile "Name_of_exp" Name_of_exp1))
(action_tile "accept" "(savedatpink4) (done_dialog)")
(action_tile "cancel" "(done_dialog)") 
(start_dialog) (unload_dialog Dcl_Id) (princ)
);end defun


(defun savedatpink4 (/)
(setq	Name_of_exp1 (get_tile "Name_of_exp")
	file_namepa (strcat (get_tile "Name_of_ak") ".dat"))
(setq cdate_str (GetTimeStr))
(WritePinky file_namepa Name_of_exp1 cdate_str Diam1_pod Rad1_pod a1_pod ang11_pod ang12_pod Rad1_pod a2_pod ang22_pod)
);end defun




