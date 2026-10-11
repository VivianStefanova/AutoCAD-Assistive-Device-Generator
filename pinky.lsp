
(vl-load-com)							

;;1. MAIN FUNCTION											1
(defun C:Pinky ( / R1 R2 R3 c1 c2 a2 a3 c3 pc1a
		pc1 list2 list3 list4 ang1 ang2 ang2_2
		a1e a2e blockObj flag2 flag3 pt3 ss ime_blokc ime_blokc-1 srad filesList
		file_namepa my_data ss slist13 slist14 dfil dfil-n dfil-n1)
(vl-cmdf "_.UCS" "_W")
(setq c1 13.0 c2 3.0 c3 9.0 flag2 0 flag3 0)					;Input parameters

  (PINKY_DIALOG_1)							;Dialog 1 – File Operations               3


 (while (= flag2 0)  
  (PINKY_DIALOG_2)					;Dialog 2
 (if (= flag3 0) (PINKY_DIALOG_3))					;Dialog 3
   );end while-flag2
(if (= flag3 0) (progn
(command "_.vpoint" '(-1.0 -1.0 1.0))	  			;Changes the view to an isometric view

(draw_base R1 c1 c2 c3)						;Draws closed polyline 1 with entmakex
(setq list1 (entlast))						;Saves the last drawn object - polyline 1
(VlaRevolveByLine (entlast) (list 0.0 0.0 0.0) (list 0.0 50.0 0.0) (* 2.0 pi));Creates a solid model by revolving a polyline around an axis defined by two points, through a specified angle
(setq list2 (ssadd (entlast)))					;Saves the last drawn object - solid 1
(rotobj (ssadd (entlast)) (list 0.0 0.0 0.0) (list 100.0 0.0 0.0) 90.0);Rotates an object around an axis by a specified angle
(setq list2 (ssadd (entlast)))					;Saves the last drawn object - solid 1

 (if (= tog_text_pod "1") (progn 
(if (= Fibonachi "1") (DistributeFibonacci (list 0.0 0.0 a2) R1 srad) (DistributeSpheres (list 0.0 0.0 a2) R1 srad));Small spheres for a rough texture
(if (= subtract_s "1") (Sub3D-Objects list2 gFibSphereSelection)
  (progn (Union3D-Objects gFibSphereSelection) (Union3D-Objects (ssadd (entlast) list2))));Subtracts multiple solids from one solid (subtracts the small spheres from the sphere)	
(setq list2 (ssadd (entlast)))					;Saves the last drawn object - solid 1
))

(CreateCylinder (polar pc1 0.0 a1e) R3 120.0)			;Creates a cylinder using a center point, radius, and height
(rotobj (ssadd (entlast)) pc1a pc2 ang2_2)			;Rotates an object around an axis by an angle
(setq list3 (ssadd (entlast)))					;Saves the last drawn object - cylinder 1
(rotobj list3 (list 0.0 0.0 0.0) (list 100.0 0.0 0.0) 90.0)	;Rotates an object around an axis by an angle
(setq list3 (ssadd (entlast)))					;Saves the last drawn object - cylinder 1
(CreateCylinder (polar pc2 pi a2e) R2 120.0)			;Creates a cylinder using a center point, radius, and height
(rotobj (ssadd (entlast)) pc2 pc1a ang1)			;Rotates an object around an axis by an angle
(rotobj (ssadd (entlast)) pc1a (list 0.0 150.0 0.0) ang2)	;Rotates an object around an axis by an angle
(rotobj (ssadd (entlast)) (list 0.0 0.0 0.0) (list 100.0 0.0 0.0) 90.0);Rotates !only one! object around an axis by an angle
(setq list4 (ssadd (entlast) list3))				;saves the last drawn object - cylinder 1 and cylinder 2 in one selection
(Sub3D-Objects list2 list4)					;Subtracts several solids from a single solid (e.g., the two cylinders from the sphere).
(setq list4 (ssadd (entlast)))
(DeleteObj list1)						;Delete polyline 1
(InsertBlockWithArgs ime_blokc 0.0 0.0 (cadr pt3) 1.0)		;Inserts a block at the elevation of point P3
(setq explodedArray (vla-Explode blockObj))			;Explode block
(vla-Delete blockObj)						;Deletes the not exploded block
(setq ss (ssadd (entlast) list4))				;Selecting the solids thst will be merged 
(Union3D-Objects ss)						;Unites 3D solids (the exploded block with the base)
  (setq slist13 (ssadd (entlast)))
(InsertBlockWithArgs ime_blokc-1 0.0 0.0 (cadr pt3) 1.0)	;nserts a block at the elevation of point P3
(setq explodedArray (vla-Explode blockObj))			;Explode block
(vla-Delete blockObj)						;Deletes the not exploded block
(vla-zoomall (vlax-get-acad-object))				;;zoom all

(setq slist14 (ssadd (entlast)))

(if (= tog_real_pod "1") (SetRealisticFast));realistic view
(if (= pod_saveas2 "1") (pinky_d4)) (if (= pod_savenp3 "1") (pinky_d4)); Save to a text file

(if (=  pod_stl "1") (progn (setq dfil (getfiled "Select A Directory" "C:/Pinky/stl/Pinky1" "stl" (+ 1 2)))
(setq dfil-n (substr dfil 1 (- (strlen dfil) 4)) dfil-n1 (strcat dfil-n "-1.stl")) ;Creates the filename for the second STL file—for the Pinky cap
(setvar "FACETRES" 10.0)  (setvar 'FILEDIA 0) (command "_stlout" slist13 "" "_Y" dfil) (command "_stlout" slist14 "" "_Y" dfil-n1) (setvar 'FILEDIA 1)));Saves two STL files

));end if flg3
  );end defun


;##################################################
;#                                                #
;#                  DIALOG 1                      #
;#                                                #
;##################################################
				
;;;(PINKY_DIALOG_1) - Dialog for working with files							2
(defun PINKY_DIALOG_1 (/ Dcl_Id)
(setq Dcl_Id (load_dialog "C:/Pinky/Pinky.dcl"))						;Loads dialog window
(if (not (new_dialog "Pinky2" Dcl_Id)) (progn (alert
"No file or window definition found.\nFile path:C:/Pinky/Pinky.dcl \nWindow name:Pinky2") (exit) ))
  
(setq filesList (vl-directory-files "C:/Pinky/Dat" "*.dat" 1))					;Gets the names of all files with the .dat extension from the C:/Pinky/Dat directory.
(start_list "file_list_1") (mapcar 'add_list filesList) (end_list) (set_tile "file_list_1" "0") ;Loads a list into field 1
(GetFirstWords "Elia.dat")									;;3.1. Opens a text file and reads the first word of each line.
(start_list "file_list_2") (mapcar 'add_list word_list) (end_list) (set_tile "file_list_2" "0") ;Loads a list into field 2
(mode_tile "file_list_1" 1)  (mode_tile "file_list_2" 1) (mode_tile "delete_record" 1) (set_tile "dsave" "1") 
(action_tile "get_p" "(if (= $value \"1\")
       (progn (mode_tile \"file_list_1\" 0) (mode_tile \"file_list_2\" 0) (mode_tile \"delete_record\" 0)(setq flag5 1)) ;  (Show)
       (progn (mode_tile \"file_list_1\" 1) (mode_tile \"file_list_2\" 1) (mode_tile \"delete_record\" 1) (setq flag5 0)) ; (Hide)
     )") 
(action_tile "file_list_1" "(setq nomlist $value) (action_list_1)")
(action_tile "file_list_2" "(setq nomlist2 $value) (action_list_2) ")
(action_tile "delete_record" "(delete_record1)")						;Deletes a record—a line from a .dat file with a specific name.
(action_tile "accept" "(get_data_pink_DIAL_1) (done_dialog)")
(action_tile "cancel" "(setq flag2 1 flag3 1) (done_dialog)") 
(start_dialog) (unload_dialog Dcl_Id) (princ)
  );end defun	




;;;(action_list_1) Actions when something is selected from the list on the first dialog window				2.1
(defun action_list_1 ( / word_list) 
(setq pod_flist1 nomlist file_namep (nth (atoi pod_flist1) filesList)    )
(GetFirstWords file_namep) (start_list "file_list_2") (mapcar 'add_list word_list) (end_list) (set_tile "file_list_2" "0")
  );end defun
;;;;(GetFirstWords filenamep) Opens a text file and reads the first word of each line    			2.1.1
(defun GetFirstWords (filenamep / file_path file_handle current_line first_word )
  (setq file_path (strcat "C:\\Pinky\\Dat\\" filenamep)) 							; 1. Static path to the file
   (setq word_list nil) 											; Initialize an empty list for the result
  (if (setq file_handle (open file_path "r"))									; 2. Checking if the file exists and opening it for reading ("r")
    (progn
      (while (setq current_line (read-line file_handle))							; 3. Reading the file line by line until the end of the file
        (setq current_line (vl-string-trim " \t" current_line))							;Removing extra spaces at the beginning and end of the line
        (if (/= current_line "")										;Checking if the line is empty
          (progn
            (setq first_word (read current_line))								;The read takes only the first expression from the text
            (setq word_list (cons (vl-prin1-to-string first_word) word_list))					;Convert it to string and add it to our list.
          )))
      (close file_handle)											;Closing the file 
      (setq word_list (reverse word_list))									; 4. We reverse the list because (cons) arranges the elements in reverse order
    )
    (princ (strcat "\nError: File at " file_path " not found!")))
  ;The function returns the list
  word_list
);end defun

;;;(action_list_2) Actions when something is selected from the list on the second dialog window				2.2
(defun action_list_2 ( / )
(setq file_namepa (nth (atoi (get_tile "file_list_1")) filesList))
(setq my_data (ReadSpecificLineData file_namepa (atoi nomlist2)))
(set_tile "data" (nth 1 my_data))			;Shows the year month day hour
  );end defun
;;;2.3. (delete_record1)  Deletes a line from the text file									2.3
(defun delete_record1 (/)
(setq	del_line1 (+ (atoi (get_tile "file_list_2")) 1)
	pod_flist1 (get_tile "file_list_1")
	file_namep (nth (atoi pod_flist1) filesList)
	)
(DeletePinkyLine file_namep del_line1) (if (= nomlist nil) (setq nomlist "0"))     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (action_list_1)								
  );end defun

;;;2.4 (get_data_pink_DIAL_1) Retrieves data from the dialog window	1								2.4
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
      ang22_pod (nth 9 my_data)  								       
      ))
);end defun



;##################################################
;#                                                #
;#                  DIALOG 2                      #
;#                                                #
;##################################################


;;;4. (PINKY_DIALOG_2) Opens a dialog window 1									4
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

;;;5. (savedatpink) -  Retrieves data from the dialog window 1							5

(defun savedatpink (/)
  
(cond ((or (< R1 15.0) (> R1 70.0)) (progn (alert "Sphere diameter D must be between 30 and 140[mm]")(mode_tile "Diam" 2)) nil)
      ((or (< R2 5.0) (> R2 25.0)) (progn (alert "Radius R1 must be between 5 and 25[mm]") (mode_tile "Rad1" 2)) nil)
      ((or (< a1e 0.0) (> a1e R2)) (progn (alert "Distance d1 must be between 0 and R1[mm]") (mode_tile "a1" 2)) nil)
      ((or (< ang1 -90.0) (> ang1 90.0)) (progn (alert "Angle a1 must be between -90 and 90[deg]") (mode_tile "ang11" 2)) nil)
      ((or (< ang2 -120.0) (> ang2 120.0)) (progn (alert "Angle a12 must be between -120 and 120[deg]") (mode_tile "ang12" 2)) nil)
      ((or (< a2e 0.0) (> a2e R3)) (progn (alert "Distance d2 must be between 0 and R2[mm]") (mode_tile "a2" 2)) nil)
      ((or (< ang2 -90.0) (> ang2 90.0)) (progn (alert "Angle a3 must be between -90 and 90[deg]") (mode_tile "ang22" 2)) nil)
      ((or (< R3 5.0) (> R3 25.0)) (progn (alert "R3 must be between 5 and 25[mm]") (mode_tile "Rad2" 2)) nil)
      (T T)
      )     
  );end defun





;##################################################
;#                                                #
;#                  DIALOG 3                      #
;#                                                #
;##################################################

;;;6. (PINKY_DIALOG_3) Opens dialog window 3									6
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
;;;7. (savedatpink2) - Retrieves data from the dialog window 3							7
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
	((= Block1_pod "1") (setq ime_blokc "p2" c3 9.0 ime_blokc-1 "p2-1"))
	((= Block1_pod "2") (setq ime_blokc "p3" c3 11.3 ime_blokc-1 "p3-1"))
	((= Block1_pod "3") (setq ime_blokc "p4" c3 12.1 ime_blokc-1 "p4-1"))
    )
  (cond ((= srad_pod "0") (setq srad 1.0))
	((= srad_pod "1") (setq srad 1.25))
	((= srad_pod "2") (setq srad 1.5))
	((= srad_pod "3") (setq srad 1.75))
	((= srad_pod "4") (setq srad 2.0))
	((= srad_pod "3") (setq srad 2.5))
    )
)

;##################################################
;#                                                #
;#                  DIALOGS END                   #
;#                                                #
;##################################################




;;;8. (draw_base) -Calculates points and draws the base geometry—a closed polyline.				8
(defun draw_base (R1 c1 c2 c3 / bulge pt2 pt3x pt4 pt5)
(setq pt1 '(0.0 0.0)     
	pt2 (polar pt1 0.0 c1)
	pt3x (polar pt1 0.0 (/ c3 2.0))
      	a2 (sqrt (- (* R1 R1) (* c1 c1)))
	a3 (sqrt (- (* R1 R1) (* (/ c3 2.0) (/ c3 2.0))))
	pt3 (polar pt3x (/ pi 2.0) (+ a2 a3))
	pt5 (list 0.0 c2)			
      	Pt4 (polar pt5 0.0 (/ c3 2.0))	
      	pc1a (polar pt1 (/ pi 2.0) a2)
	pc1 (polar pc1a 0.0 R1)
	pc2 (polar pc1a pi R1)
      bulge (GetBulge pt2 pt3 R1)
	)
(entmake (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity") '(100 . "AcDbPolyline") '(90 . 5)                
      '(70 . 1)                ;
      (cons 10 pt1)
      (cons 10 pt2) (cons 42 bulge)          ; Puts an arc after pt2
      (cons 10 pt3)
      (cons 10 pt4)
      (cons 10 pt5)))
  );end defun



;;;8.1 (GetBulge) Calculates the bulge for constructing arcs within the polylines					8.1
(defun GetBulge (p1 p2 rad / dist h)
  (setq dist (distance p1 p2)) 			;Chord length 
  (if (<= (* 2.0 rad) dist)
    (setq h rad) 				;If the radius is minimal (a semicircle)
    (setq h (- rad (sqrt (- (* rad rad) (* (/ dist 2.0) (/ dist 2.0))))))
  )
  (/ (* 2.0 h) dist) 				;Returns bulge value
);end defun

;;;9. (VlaRevolveByLine) Rotates a closed polyline by an angle to create a solid object			9
;Requires two points for the axis and a rotation angle.
(defun VlaRevolveByLine (polyEname p1 p2 anglerot / acadObj doc space lineEname polyVla lineVla regionList regionObj axisDir solidObj )
   (if (/= polyEname nil)
    (progn
      (setq acadObj (vlax-get-acad-object)
            doc     (vla-get-ActiveDocument acadObj)
            space   (vla-get-ModelSpace doc)
            polyVla (vlax-ename->vla-object polyEname)
      )
      ;Creates a region
      (setq regionList (vla-AddRegion space (vlax-make-variant (vlax-safearray-fill (vlax-make-safearray vlax-vbObject '(0 . 0)) (list polyVla)))))
      (setq regionObj (vlax-safearray-get-element (vlax-variant-value regionList) 0)) 
      (setq axisDir (mapcar '- p2 p1));Calculates directional vector (p2 - p1)
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
;;;10. (CreateCylinder pt rad hgt) Creates a cylinder defined by a center, radius, and height					10
(defun CreateCylinder ( pt rad hgt / acadObj doc modelSpace wcsPt centerPt cylObj )
  (if (and pt rad hgt (> rad 0) (/= hgt 0))
    (progn
      (setq acadObj (vlax-get-acad-object))
      (setq doc (vla-get-ActiveDocument acadObj))
      (setq modelSpace (vla-get-ModelSpace doc))
      (setq wcsPt (trans pt 1 0));Transforming the point from the current UCS (1) to the WCS (0) for ActiveX
      (setq centerPt (vlax-3d-point wcsPt))
      (setq cylObj (vla-AddCylinder modelSpace centerPt rad hgt)) ;Creates a cylinder
      ;Returns the object
      cylObj
    )
    nil
  )
)
;;;11. (mobj Sobj pm1 pm2) - A function that moves an object from one base point to another			11
(defun mobj (Sobj pm1 pm2 / v1 v2 obj)
              (setq obj (vlax-ename->vla-object (ssname Sobj 0)))	 ;Convert the selected object to a VLA object
              (setq v1 (vlax-3d-point pm1)) (setq v2 (vlax-3d-point pm2)); Converting 3D points into ActiveX Variant arrays
              (vla-Move obj v1 v2)
  );end defun
;;;12. (rotobj Sobjr pm1 pm2 angler) - Function that rotates an object around an axis defined by two points by a specific angle	  	12
(defun rotobj (Sobjr pm1 pm2 angler / v1 v2 angle_rad obj)
                  (setq angle_rad (* angler (/ pi 180.0)))	      	     ; Converting the angle from degrees to radians
                  (setq obj (vlax-ename->vla-object (ssname Sobjr 0)))	     ; Convert the object to a VLA object 
                  (setq v1 (vlax-3d-point pm1)) (setq v2 (vlax-3d-point pm2)); Converting points to ActiveX 3D vectors
                  (vla-Rotate3D obj v1 v2 angle_rad)			     
  );end defun
;;;14. (InsertBlockWithArgs blockName xCoord yCoord zCoord scale) - Inserts a block created in the current drawing		14
(defun InsertBlockWithArgs (blockName xCoord yCoord zCoord scale / acadObj docObj modelSpace blocksObj insPoint) 
  (setq insPoint (vlax-3d-point (list xCoord yCoord zCoord))) ;Converting coordinates to ActiveX format
  (setq acadObj (vlax-get-acad-object))			   
  (setq docObj (vla-get-ActiveDocument acadObj))
  (setq modelSpace (vla-get-ModelSpace docObj))
  (setq blocksObj (vla-get-Blocks docObj))
  ;Checking if the block exists and inserting it
  (if (not (vl-catch-all-error-p (vl-catch-all-apply 'vla-Item (list blocksObj blockName))))
      ;Insertion with uniform X, Y, Z scaling and 0.0 rotation
      (setq blockObj (vla-InsertBlock modelSpace insPoint blockName scale scale scale 0.0))
    (princ (strcat "\nError:'" blockName "' was not found!"))
  )
)
;;;15. (DeleteObj ent) - Deleting selected object								15
(defun DeleteObj (ent / )
  (if ent
    (vla-delete (vlax-ename->vla-object ent))
    (princ "\nAn object was not selected.")
  )
  (princ) 
)
;;;16. (Sub3D-Objects list2 list4) - Subtracts one or more solids from a single solid		16
;; Arguments: 
;;   mainSS - selection set containing the main object (the first element)
;;   subSS  - selection set containing the objects to be subtracted
(defun Sub3D-Objects (mainSS subSS / mainEname mainVla i subEname subVla)
  (if (and mainSS subSS (> (sslength mainSS) 0))
    (progn
      (setq mainEname (ssname mainSS 0)) ; 1. We take the first object from the main selection set and turn it into a VLA object
      (setq mainVla (vlax-ename->vla-object mainEname))
      (if (= (vla-get-ObjectName mainVla) "AcDb3dSolid") ;Check if the main object is a 3D solid
        (progn 
          (setq i 0) ; 2. Loop for iterating over all objects for subtraction (subSS)
          (while (< i (sslength subSS))
            (setq subEname (ssname subSS i))
            (setq subVla (vlax-ename->vla-object subEname))   
            (if (= (vla-get-ObjectName subVla) "AcDb3dSolid") ;Check whether the current object to be subtracted is a 3D solid
              (vla-Boolean mainVla 2 subVla)  ; 2 = acSubtraction (Subtraction) 0 = acUnion (Union) 1 = acIntersection (Intersection)
            )
            (setq i (1+ i))
          )
          (vla-Update mainVla)
          t ;Success
        )
        nil ;The main object is not a 3D solid
      )
    )
    nil ;Empty selection sets
  )
)

;;;17. (Union3D-Objects ss) - Merge objects in selection ss						17
;;   ss - selection set (created with ssadd) containing 3D Solids
(defun Union3D-Objects (ss / mainEname mainVla i subEname subVla)
  (if (and ss (> (sslength ss) 1));Checks if the selection set exists and if it has at least two objects
    (progn
      (setq mainEname (ssname ss 0)) ; 1. Getting the first object (index 0) as a base and create a VLA object.
      (setq mainVla (vlax-ename->vla-object mainEname))
      (if (= (vla-get-ObjectName mainVla) "AcDb3dSolid");Check if the first object is a 3D Solid
        (progn
          (setq i 1);; 2. Starting the loop from the second object to the end of the set
          (while (< i (sslength ss))
            (setq subEname (ssname ss i))
            (setq subVla (vlax-ename->vla-object subEname))
            (if (= (vla-get-ObjectName subVla) "AcDb3dSolid");Check if the current object is a 3D Solid
              (vla-Boolean mainVla 0 subVla) ;; 0 = acUnion (Union)
            )
            (setq i (1+ i))
          )
          (vla-Update mainVla)
          t ;Success
        nil ;The first object is not a 3D Solid
      )
    )
    nil ;The selection contains less then two solids
  )
    )
)

;;;18. (SetRealisticFast) Sets realistic view				18
(defun SetRealisticFast ()
  (vla-SendCommand (vla-get-ActiveDocument (vlax-get-acad-object)) "_.vscurrent _realistic ")
  (princ)
)
;;;19. (Create3DSphereVL centerPt radius) Creates a 3D Sphere								19
(defun Create3DSphereVL (centerPt radius / acadObj docObj mSpace normPt centerVariant sphereObj)
  (vl-catch-all-apply
    '(lambda ()
       (setq normPt (list (car centerPt) (cadr centerPt) (if (caddr centerPt) (caddr centerPt) 0.0)));Ensure that the point is a list with exactly 3 elements (X Y Z)
       (setq acadObj (vlax-get-acad-object))
       (setq docObj (vla-get-ActiveDocument acadObj))
       (setq mSpace (vla-get-ModelSpace docObj))
       (setq centerVariant (vlax-3d-point normPt)) ;Transformation of the LISP list into an ActiveX Variant
       (setq sphereObj (vla-AddSphere mSpace centerVariant radius)); Creating the sphere
       sphereObj
     )));end defun

;; 20 (DistributeSpheres) Primary function for distributing texture spheres using an array				20
(defun DistributeSpheres (centerPt bigRadius smallRadius / latSteps lonSteps 
                               i j lat lon x y z currentPt sphereObj sphereEname) 
;;;  (setq centerPt    (list 0.0 0.0 150.0)) ;Center of the large sphere
;;;  (setq bigRadius   100.0)             ;Radius of the large sphere
;;;  (setq smallRadius 1.5)               ;Radius of the small spheres
  (setq latSteps    12)                ;Number of steps across the width (vertically)
  (setq lonSteps    21)                ;Number of steps along the length (horizontally)
  (setq gSphereSelection (ssadd)) ;; 1. Creating a new empty selection set
  
  (defun AddToSet (obj) ;Local helper function to convert and add to the selection
    (if obj
      (progn
        (setq sphereEname (vlax-vla-object->ename obj));Convert VLA-Object to Entity Name (ename)
        (ssadd sphereEname gSphereSelection) ;Adding the object to the selection set
      )
    )
  );end defun for helper function

  (setq i 1) ;Latitudinal cycle
  (while (< i latSteps)
    (setq lat (- (* (/ (float i) latSteps) pi) (/ pi 2.0)))
    (setq j 0) ;Longitude loop
    (while (< j lonSteps)
      (setq lon (* (/ (float j) lonSteps) 2.0 pi))
      (setq x (+ (car centerPt)   (* bigRadius (cos lat) (cos lon))))
      (setq y (+ (cadr centerPt)  (* bigRadius (cos lat) (sin lon))))
      (setq z (+ (caddr centerPt) (* bigRadius (sin lat))))
      (setq currentPt (list x y z))
    (if (and (> i 1) (< i 11)) (progn					;Removing spheres close the the two poles!!!!!
      (setq sphereObj (Create3DSphereVL currentPt smallRadius)) ;Generating the sphere and storing it in a variable
      (AddToSet sphereObj) ;Adding the sphere to a selection
      ))
      (setq j (1+ j))
    )
    (setq i (1+ i))
  ) 

  (setq gFibSphereSelection gSphereSelection)
);end defun


;; 21 (DistributeFibonacci centerPt bigRadiu) Main function for small Fibonacci sphere distribution						21
(defun DistributeFibonacci (centerPt bigRadius smallRadius / totalSpheres 
                                  goldenRatio i phi theta cosTheta sinTheta x y z currentPt sphereObj sphereEname)
;;;  (setq centerPt     (list 0.0 0.0 0.0)) ;Center of the large sphere
;;;  (setq bigRadius    100.0)             ;Radius of the large sphere
;;;  (setq smallRadius  2.0)               ;Radius of the small spheres
  (setq totalSpheres 200)               ;Total number of spheres for uniform distribution
  (setq goldenRatio (* pi (- 3.0 (sqrt 5.0))));Golden ratio (angle in radians for optimal rotation)
  (setq gFibSphereSelection (ssadd));; 1.Creating a new empty selection set
  (defun AddToFibSet (obj);Helper local function to add to the selection
    (if obj
      (progn
        (setq sphereEname (vlax-vla-object->ename obj))
        (ssadd sphereEname gFibSphereSelection)
      )
    )
  );end defun for helper function
  (setq i 0)
  (while (< i totalSpheres)
    ;; 1. Calculating the Z position (linearly distributed from 1 to -1).
    ;An offset (0.5 / totalSpheres) is added to avoid the poles
    (setq cosTheta (- 1.0 (/ (+ (float i) 0.5) (/ totalSpheres 2.0))))
    (setq sinTheta (sqrt (- 1.0 (* cosTheta cosTheta)))) 
    (setq phi (* i goldenRatio)) ;; 2. Calculating the angle around the vertical Z-axis.
    ;; 3. Spherical trigonometric formulas for X, Y, and Z
    (setq x (+ (car centerPt)   (* bigRadius sinTheta (cos phi))))
    (setq y (+ (cadr centerPt)  (* bigRadius sinTheta (sin phi))))
    (setq z (+ (caddr centerPt) (* bigRadius cosTheta)))
    (setq currentPt (list x y z))

    (if (and (> i 10) (< i 190)) (progn 			;Removing the points close to the two poles!!!!!
    ;Generate the sphere and add it to the selection
    (setq sphereObj (Create3DSphereVL currentPt smallRadius))
    (AddToFibSet sphereObj)
));end if
    (setq i (1+ i))
  ) 

);end defun


;;;22. (WritePinky) A function that saves geometric parameters to an external file				22
(defun WritePinky (fName1 Pname Pdata Pdiam Pr1 Pd1 Pang11 Pang12 Pr2 Pd2 Pang21 / f FilePath)
  (setq FilePath (strcat "C:\\Pinky\\Dat\\" fName1)) 
  (setq f (open FilePath "a")) ;Open the file for writing and appending ("a")
  (write-line (strcat Pname " " Pdata " " Pdiam " " Pr1 " " Pd1 " " Pang11 " " Pang12 " " Pr2 " " Pd2 " " Pang21) f)
      (close f)
);end defun

;;;23. (DeletePinkyLine )Deletes a line from a .dat file. A function that deletes a single line from an external text file 					23
(defun DeletePinkyLine (filename line_to_delete / file_path file_handle current_line line_counter lines_list write_handle )
  (setq file_path (strcat "C:\\Pinky\\Dat\\" filename))				;; 1. Specifying the exact path to the file
  (if (findfile file_path)							;; 2. Checking if the file exists
    (progn
      (setq file_handle (open file_path "r"))					;; 4. Open the file for reading ("r")
      (setq line_counter 1)
      (setq lines_list nil)
      (while (setq current_line (read-line file_handle))			;Reading the file line by line until the end of the file
        (if (/= line_counter line_to_delete)					;If the current row is NOT the one to be deleted, we save it in a list
          (setq lines_list (cons current_line lines_list))
        )
        (setq line_counter (1+ line_counter))
      )
      (close file_handle) 							
      (setq lines_list (reverse lines_list))					;Reversing the list because (cons) arranges them in reverse order.
      
      (setq write_handle (open file_path "w"))					;; 5. Opening the same file for writhing ("w"), which deletes its old content
		;; Writing back only the preserved lines
	  (foreach line lines_list					  
        (write-line line write_handle)
      )
      (close write_handle) 
    )
  )
  (princ)
);end defun


;;;;24. (ReadSpecificLineData) Reads data from the text file and assigns it to the geometric dimensions in dialog window 2		24
(defun ReadSpecificLineData ( file_name line_to_read / folder_path full_path file_handle line_counter 
                                                       current_line raw_list result_list raw_dt 
                                                       year month day hours minutes item )
  (setq folder_path "C:\\Pinky\\dat\\");; 1. Static path to the folder with the data files
  (setq full_path (strcat folder_path file_name))
  (setq result_list nil)
  (if (setq file_handle (open full_path "r"));; 2. Opening the file for reading
    (progn
      (setq line_counter 0) 
      (while (and (<= line_counter line_to_read) (setq current_line (read-line file_handle)));Getting to the desired row
        (if (= line_counter line_to_read)
          (setq raw_list (read (strcat "(" current_line ")")))
        )
        (setq line_counter (1+ line_counter))
      )
      (close file_handle)
      (if raw_list 	;; 3. Data processing if the record is found
        (progn
          ;Populate the list with text values
          (foreach item raw_list
            (setq result_list (cons (vl-prin1-to-string item) result_list))
          )
          ;We reverse the list to restore its original order (indices 0 to 9)
          (setq result_list (reverse result_list))
        )
      )
    )
  )
  ;Returns a list of 10 strings, or nil if the file/line is missing
  result_list 
);end defun


;;; 25. (GetTimeStr) Gets the current year and time.						25
(defun GetTimeStr ( / cdate_val cdate_str year month day hours minutes time_string )
  (setq cdate_val (getvar "CDATE")) ;; 1. Getting the current time from AutoCAD
  (setq cdate_str (rtos cdate_val 2 6))
  (setq year    (substr cdate_str 1 4))  ; Year
  (setq month   (substr cdate_str 5 2))  ; Month
  (setq day     (substr cdate_str 7 2))  ; Day
  (setq hours   (substr cdate_str 10 2)) ; Hour
  (setq minutes (substr cdate_str 12 2)) ; Minute
  (setq time_string (strcat year "y" month "m" day "d" hours ":" minutes))
);end defun




;;; 26. (pinky_d4) Dialog window 4
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




