;----------------------------------------------------------------------------------
; 				TWO HANDLED CUP HOLDER				   
;----------------------------------------------------------------------------------
(vl-load-com);Load Vl library
(setq DialogPath "C:/Pinky/cupHolderWindow.dcl") ;Static path to the DCL window
(load "C:/Pinky/VlaUtils.lsp")

; MAIN FUNCTION    ; the main function that calls the dialog window
(defun C:CUPHOLDER ( / dcl_id result dir list1 list2 list6
		    baseProfile fig ps1 c3 c4 height c7_Toffset selectionu1 selectionu1_1 Holder2)
  (setq mSpace (getModelSpace)) 						; get Model Space for vla-functions 
  (setq dcl_id (load_dialog DialogPath))  					; Load DCL file 
  (if (not (new_dialog "CupDialog" dcl_id)) (progn (alert "Cannot load dialog.") (exit)))
(start_list "handle_type") (mapcar 'add_list '("Triangle" "Oval" "Rectangle")) (end_list)  	 
(start_list "handle_width") (mapcar 'add_list '("Thin" "Medium" "Thick")) (end_list)   	 
  ; Set defaults
  (if (= heightVal nil) (setq heightVal "110")) (set_tile "cup_height" heightVal)
  (if (= lowerDiamVal nil) (setq lowerDiamVal "60")) (set_tile "lower_dia" lowerDiamVal)
  (if (= upperDiamVal nil) (setq upperDiamVal "80")) (set_tile "upper_dia" upperDiamVal)
  (if (= cutoutWidthVal nil) (setq cutoutWidthVal "20")) (set_tile "cut_width" cutoutWidthVal)
  (if (= cutoutTopVal nil) (setq cutoutTopVal "15")) (set_tile "cut_top_dist" cutoutTopVal)
  (if (= cutoutBottomVal nil) (setq cutoutBottomVal "20")) (set_tile "cut_bottom_dist" cutoutBottomVal)
  (if (= handleSizeVal nil) (setq handleSizeVal "65")) (set_tile "handle_size" handleSizeVal)
  (if (= handleTypeVal nil) (setq handleTypeVal "0")) (set_tile "handle_type" handleTypeVal)
  (if (= handleThicknessVal nil) (setq handleThicknessVal "1")) (set_tile "handle_width" handleThicknessVal)
  (if (= pod_stl1 nil) (setq pod_stl1 "0")) (set_tile "sav_stl" pod_stl1)
(action_tile "accept" "(acceptCallback)")							; OK button
(action_tile "cancel" "(done_dialog 0)")							; Cancel button
  (setq result (start_dialog))  								; Show dialog
  (unload_dialog dcl_id)  									; Cleanup


  
  (if (= result 1) (progn 									; Process result
	(agregateValues)										;Calculates points for 2D geometry
	(SetRealisticView)										;Changes the view to isometric
	(drawLWPoly list1 1)										;Draws a closed contour for the outer part of the holder
	(UT_revolve mSpace (list baseProfile) (list 0.0 0.0) (list 0.0 100.0) 360.0)			;Revoves the contour
	(setq selectionu1_1 (ssadd (entlast)))
	(drawLWPoly list2 1)										;Draws a closed contour for the cup's body
	(UT_revolve mSpace (list baseProfile) (list 0.0 0.0) (list 0.0 100.0) 360.0)			;Revoves the contour
	(setq subSS_1 (ssadd (entlast)))   
	(cut_holder_poly list6)										;Draws a closed contour for cutting the handle slot
	(setq fig (entlast))
	(UT_extrude mSpace (list fig) (* (atof upperDiamVal) 2.0))					;Extrudes the closed contour and creates a 3D Solid
	(UT_move3D (ssadd (entlast)) (list 0.0 0.0 0.0) (list 0.0 0.0 (- (atof upperDiamVal))))		;Moves the 3D Solid along the Z axis
	(setq subSS (ssadd (entlast) subSS_1))
	    
	(setq ps1 (list (- (car (nth 1 list2)) c4) (+ (cadr (nth 1 list2)) c3)) ps2 (car (mirror-points-y (list ps1)))) ;Starting points for the handles
	(handles_n ps1 ps2) 										;Program for drawing the handles
	(UT_union selectionu1)  									;Combines the objects
	(UT_subtract selectionu1_1 subSS)								;Subtracts the objects
	(setq Holder2 (ssadd)) (ssadd (ssname selectionu1_1 0) Holder2)
	(UT_rotate3D Holder2 (list 0.0 0.0 0.0) (list 20.0 0.0 0.0) 90.0)    			;Rotates the finished cup holder to make it upright

	(if (=  pod_stl1 "1") (progn (setq dfil (getfiled "Select A Directory" "C:/Pinky/stl/CupHolder1" "stl" (+ 1 2)))
	(setvar "FACETRES" 10.0) (setvar 'FILEDIA 0) (vl-cmdf "_.STLOUT" selectionu1_1 "" "_Y" dfil) (setvar 'FILEDIA 1)));Saves the STL file
    );end progn
);end if
   (vl-cmdf "_.zoom" "_extents")
(princ)); end of defun : CUPHOLDER


; ACCEPT CALLBACK
; runs after the accept button of the dialog window has been clicked
(defun acceptCallback ( / )
	  (setq heightVal (get_tile "cup_height")
	  lowerDiamVal (get_tile "lower_dia")
	  upperDiamVal (get_tile "upper_dia")
	  cutoutWidthVal (get_tile "cut_width")
	  cutoutBottomVal (get_tile "cut_bottom_dist")
	  cutoutTopVal (get_tile "cut_top_dist")
	  handleTypeVal (get_tile "handle_type")
	  handleSizeVal (get_tile "handle_size")
	  handleThicknessVal (get_tile "handle_width")
	  pod_stl1 (get_tile "sav_stl"))
  	(if (ValidateInputs) (done_dialog 1))	  
); end of defun : acceptCallback

; INPUT VALIDATION
; Validates the given inputs, returns true if everything is fine
(defun ValidateInputs ( / h l u cw cb ct hs)
  (setq h  (atof (get_tile "cup_height")))
  (setq l  (atof (get_tile "lower_dia")))
  (setq u  (atof (get_tile "upper_dia")))
  (setq cutW (atof (get_tile "cut_width")))
  (setq cutB (atof (get_tile "cut_bottom_dist")))
  (setq Lh (atof (get_tile "handle_size")))
  (cond
 ((or (< h 100) (> h 180)) (progn (alert "Cup height (H) must be between 100mm and 180mm!") (mode_tile "cup_height" 2)) nil)			 		; height between 5 and 30 cm
 ((or (< l 40) (> l 150)) (progn (alert "Lower diameter (DL) out of range. Must be between 40mm and 150mm!") (mode_tile "lower_dia" 2)) nil) 		; upper and lower diameter between 3 and 15 cm
 ((or (< Lh 55) (> Lh 160)) (progn (alert "Lh must be between 55mm and 160mm!") (mode_tile "handle_size" 2)) nil)			 		; height between 5 and 30 cm
 ((or (< u 40) (> u 150)) (progn (alert "Upper diameter (DU) out of range. Must be between 40mm and 150mm!") (mode_tile "upper_dia" 2)) nil)    		; upper diameter => lower diameter
 ((or (< cutB 10) (> cutB 50)) (progn (alert "Distance From Bottom (HL) out of range. Must be between 10mm and 50mm!") (mode_tile "cut_bottom_dist" 2)) nil)    		; upper diameter => lower diameter
 ((or (< cutW 5) (> cutW 25)) (progn (alert "Width (L) out of range. Must be between 5mm and 25mm!") (mode_tile "cut_width" 2)) nil)    		; upper diameter => lower diameter
 ((< u l) (progn (alert "Upper diameter must be larger than or equal to lower diameter!") (mode_tile "upper_dia" 2)) nil)
    (T T)
  )
);end of defun : ValidateInputs

; SETTING THE VALUES  ; sets the global values with the agregated values from the dialog window
(defun agregateValues ( / c1_wallThickness c2_Boffset delta_path_handle  
		       diam1U diam2L p0 p01 p02 p03 p04 angh p05 p06 p1a p2a p1 p2 p3 p4
		       Hhandle whit_C p30a p31a p35 P34 P33a P33 P32 list4 list5 c5 c6 c8 c9)
  				;Constant dimensions - Constans	
  (setq c1_wallThickness 3.5 	;Wall thickness         					c1
	c2_Boffset 8.0       	;Bottom ring thickness 						c2
	c3 1.5			;									c3
	c4 5.0   		;Handle path extension into the cup 					c4
	c5 3.5			;									c5
	c6 3.5			;									c6
	c7_Toffset 8.0      	; Distance from the upper edge of the cup for drinking	c7
	c8 40.0			;									c8
	c9 3.0			;									c9
	)
   						;;Parameters
  (setq diam1U (atof upperDiamVal)		;Large diameter - upper 
	diam2L (atof lowerDiamVal)		; Small diameter - lower
	height (atof heightVal)			; Cup height
	)
;Points for holder 1 - outer 
;Points for the outer and inner contours of the cup holder
  (setq p0 (list 0.0 0.0)
	p01 (polar p0 (/ pi 2.0) c1_wallThickness)
	p02 (polar p01 0.0 (/ diam2L 2.0))
	p04 (polar p01 (/ pi 2.0) height)
	p03 (polar p04 0.0 (/ diam1U 2.0))
	angh (angle p02 p03)
	p05 (polar p03 angh (- c7_Toffset))
	p06 (polar p02 pi c2_Boffset)
	p1a (polar p06 (- (/ pi 2.0)) c1_wallThickness)
	p2a (polar p02 (- (/ pi 2.0)) c1_wallThickness)
	p1 (polar p2a 0.0 (* c1_wallThickness 2.0))
	p2 (polar p02 0.0 c1_wallThickness)
	p3 (polar p05 0.0 c1_wallThickness)
	p4 (list (car p06) (cadr p05))
	list1 (list p1a p1 p2 p3 p4)
	list2 (list p01 p02 p03 p04)
	)
;Dimensions for the handle slots of the existing cup
  (setq Hhandle (- height (atof cutoutBottomVal)) ;Height at which the slot starts
	whit_C (+ (atof cutoutWidthVal) c5 c5)		  ;Slot width
;;;	rad_c c9			  ;Slot fillet radius
	)
;Geometry points for two vertical slots 
;Points for holder 1 - in2
(setq p30a (polar p04 (- (/ pi 2)) (+ Hhandle c6))
      p30 (polar p30a 0.0 (- (/ whit_C 2.0) c9))
      p31a (polar p30a 0.0 (/ whit_C 2.0))
      p31 (polar p31a (/ pi 2.0) c9)
      p35 (polar p04 0.0 (+ (/ whit_C 2.0) c8))
      P34 (polar p35 (/ pi 2.0) (- c7_Toffset))
      P33a (polar (polar p04 (/ pi 2.0) (- c7_Toffset)) 0.0 (/ whit_C 2.0))
      P33 (polar p33a 0.0 c9)
      P32 (polar p33a (- (/ pi 2.0)) c9)
list4 (list p30 p31 p32 p33 p34 p35)
list5 (mirror-points-y list4)
list6 (append list4 (reverse list5))
      )
  ); end of defun : agregateValues




;Function for creating a 3D model of two handles									
(defun handles_n (points1 points2 / a b Rs Hh R entPath1 entPath2)
(cond ((= handleThicknessVal "0") (setq b 6.0 a 10.0 Rs 3.0))
((= handleThicknessVal "1") (setq b 7.0 a 12.0 Rs 3.0))
((= handleThicknessVal "2") (setq b 8.0 a 15.0 Rs 3.0)))
(setq points1 (polar points1 (/ pi 2.0) (/ a 2.0))
      points2 (polar points2 (/ pi 2.0) (/ a 2.0))) 
(RECab points1 a b Rs)							     ;Draws the handle cross-section
(UT_rotate3D (ssadd (entlast)) points1 (polar points1 (/ pi 2.0) 10.0) 90.0) ;Rotates the cross-section
(setq section_L (entlast))
(RECab points2 a b Rs)							     ;Draws the handle cross-section
(UT_rotate3D (ssadd (entlast)) points2 (polar points2 (/ pi 2.0) 10.0) 90.0) ;Rotates the cross-section
(setq section_R (entlast))
(setq Hh (- height c3 c3 c7_Toffset a) R (/ Hh 2))
(cond ((= handleTypeVal "0") (handle_poly2 points1 Lh Hh 10.0))			;Triangular handle
((= handleTypeVal "1") (handle_poly1 points1 Hh R Lh))				;Oval handle 
((= handleTypeVal "2") (handle_poly3 points1 Lh Hh 8.0)))			;Rectangular handle
(SweepPline section_L entPath1)						;Extrudes the left handle along the path
(setq selectionu1_2 (ssadd (entlast) selectionu1_1))
(DeleteLastPoly entPath1) (DeleteLastPoly section_L)
(SweepPline section_R entPath2)						;Extrudes the right handle along the path
(setq selectionu1 (ssadd (entlast) selectionu1_2))
(DeleteLastPoly entPath2) (DeleteLastPoly section_R)		       
);end of defun : handles_n

;##################################################
;#                                                #
;#       Functions for drawing polylines          #
;#                                                #
;##################################################


; 1. Function for drawing a rectangle with rounded corners (fillet)
(defun RECab (points h b r / p0 p1 p2 p3 p4 p5 p6 p7 p8 cls) 
(setq   p1 (polar (polar points (/ pi 2.0) (/ h 2)) pi (- (/ b 2.0) r))
  	p2 (polar (polar p1 pi r) (- (/ pi 2.0)) r)
  	p3 (polar p2 (- (/ pi 2)) (- h r r))
    	p4 (polar (polar p3 (- (/ pi 2)) r) 0.0 r)
  	p5 (polar p4 0.0 (- b r r))
  	p6 (polar (polar p5 0.0 r) (/ pi 2.0) r)
	p7 (polar p6 (/ pi 2.0) (- h r r))
  	p8 (polar (polar p7 (/ pi 2) r) pi r)
  	cls 1
  )
(entmake (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity") '(100 . "AcDbPolyline") '(90 . 8);Number of points (vertices) in the polyline
		 (cons 10  p1) '(40 . 0.0) '(41 . 0.0) '(42 . 0.414214) '(91 . 0)
		 (cons 10 p2) (cons 10  p3) '(40 . 0.0) '(41 . 0.0) '(42 . 0.414214) '(91 . 0)
		 (cons 10  p4) (cons 10  p5) '(40 . 0.0) '(41 . 0.0) '(42 . 0.414214) '(91 . 0)
		 (cons 10  p6) (cons 10  p7) '(40 . 0.0) '(41 . 0.0) '(42 . 0.414214) '(91 . 0)	 
		 (cons 10  p8) (cons 70 cls)));end entmake
   (princ));end of defun : RECab

;2. Draws a handle with one arc
(defun handle_poly1 (points1-1 Hh-1 R-1 Lh-1 / dis1 p2 p3 p4 listpointh bulgehandle bulgehandle1)
  (setq dis1 (- Lh-1 R-1)
	p2 (polar points1-1 0.0 dis1)
	p4 (polar points1-1 (/ pi 2.0) Hh-1)
	p3 (polar p4 0.0 dis1)	
listpointh (list points1-1 p2 p3 p4)
listpointhm (mirror-points-y listpointh)
bulgehandle (GetBulge (nth 1 listpointh) (nth 2 listpointh) (/ (distance (nth 1 listpointh) (nth 2 listpointh)) 2.0))
bulgehandle1 (GetBulge (nth 1 listpointhm) (nth 2 listpointhm) (/ (distance (nth 1 listpointhm) (nth 2 listpointhm)) 2.0))
    )
 (entmake (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity") '(100 . "AcDbPolyline") '(90 . 4);Number of points (vertices) in the polyline
		(cons 10  (nth 0 listpointh))
	       (cons 10 (nth 1 listpointh)) '(40 . 0.0) '(41 . 0.0) (cons 42 bulgehandle) '(91 . 0)
		(cons 10  (nth 2 listpointh)) '(91 . 0)
		 (cons 10  (nth 3 listpointh))
		 (cons 70 0)
		 ));end entmake
  (setq entPath1 (entlast)) (princ)
(entmake (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity") '(100 . "AcDbPolyline") '(90 . 4);Number of points (vertices) in the polyline
		 (cons 10  (nth 0 listpointhm))
	       (cons 10 (nth 1 listpointhm)) '(40 . 0.0) '(41 . 0.0) (cons 42 (- bulgehandle1)) '(91 . 0)
		 (cons 10  (nth 2 listpointhm)) '(91 . 0)
		 (cons 10  (nth 3 listpointhm))
		 (cons 70 0)
		 ));end entmake
  (setq entPath2 (entlast)) (princ));end of defun : handle_poly1
; 3. Draws second handle
(defun handle_poly2 (pointi2 L2 H2 rad1 / p1 p2 p3 p4 r1 r2 a12 a23 a32 a34 alpha1 alpha2 d1 d2 t2_1 t2_2 t3_1 t3_2 b1 b2 mlistp2)
  ; 1. Defining radii and base angle points
  (setq r1 rad1   ;Radius at vertex P2
;;;        r2 (- L2 40.0) ;Radius at vertex P3
	r2 25.0
	L2 (+ L2 (* 1.6 r2))
  )
  (setq p1 pointi2
        p2 (polar p1 0.0 (* rad1 0.8))
        p3 (polar (polar p1 (/ pi 2.0) H2) 0.0 L2)
        p4 (polar p1 (/ pi 2.0) H2)
  )
  ; 2. CALCULATIONS FOR VERTEX P2 (between lines P1->P2 and P2->P3)
  (setq a12 (angle p2 p1)
        a23 (angle p2 p3)
        alpha1 (abs (- a12 a23))
  )
  (if (> alpha1 pi) (setq alpha1 (- (* 2.0 pi) alpha1)))
  
  ;Tangent distance and tangent points at P2
  (setq d1 (/ r1 (/ (sin (/ alpha1 2.0)) (cos (/ alpha1 2.0))))
        t2_1 (polar p2 a12 d1) ; Where the rounding at P2 starts
        t2_2 (polar p2 a23 d1) ; Where the rounding at P2 ends
  )
  ;Bulge coefficient for P2
  ;Formula: tan((pi - alpha) / 4). The sign depends on the turning direction.
  (setq b1 (abs (tan (/ (- pi alpha1) 4.0))))
  ;Determining the turning direction using the cross product (Z component)
  (if (< (- (* (- (car p2) (car p1)) (- (cadr p3) (cadr p2)))
            (* (- (cadr p2) (cadr p1)) (- (car p3) (car p2)))) 0)
    (setq b1 (- b1)) ;Right turn -> negative bulge
  )
  ; 3. CALCULATIONS FOR VERTEX P3 (between lines P2->P3 and P3->P4)
  (setq a32 (angle p3 p2)
        a34 (angle p3 p4)
        alpha2 (abs (- a32 a34))
  )
  (if (> alpha2 pi) (setq alpha2 (- (* 2.0 pi) alpha2)))
  ;Tangent distance and tangent points at P3
  (setq d2 (/ r2 (/ (sin (/ alpha2 2.0)) (cos (/ alpha2 2.0))))
        t3_1 (polar p3 a32 d2) ;Where the rounding at P3 starts
        t3_2 (polar p3 a34 d2) ;Where the rounding at P3 ends
  )
  ;Bulge coefficient for P3
  (setq b2 (abs (tan (/ (- pi alpha2) 4.0))))
  (if (< (- (* (- (car p3) (car t2_2)) (- (cadr p4) (cadr p3)))
            (* (- (cadr p3) (cadr t2_2)) (- (car p4) (car p3)))) 0)
    (setq b2 (- b2)) ;Right turn -> negative bulge
  )
(entmake (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity") '(100 . "AcDbPolyline") '(90 . 6);Total number of vertices in the polyline
      '(70 . 0)                       ;Open polyline
      (cons 10 p1)     
      (cons 10 t2_1) (cons 42 b1)  
      (cons 10 t2_2) 
      (cons 10 t3_1) (cons 42 b2)   
      (cons 10 t3_2)
      (cons 10 p4)))
(setq entPath1 (entlast)) (princ)
(setq mlistp2 (mirror-points-y (list p1 t2_1 t2_2 t3_1 t3_2 p4)))
(entmake (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity") '(100 . "AcDbPolyline") '(90 . 6);Total number of vertices in the polyline
      '(70 . 0)                       ;Open polyline
      (cons 10 (nth 0  mlistp2))     
      (cons 10 (nth 1  mlistp2)) (cons 42 (- b1))  
      (cons 10 (nth 2  mlistp2))
      (cons 10 (nth 3  mlistp2)) (cons 42 (- b2))   
      (cons 10 (nth 4  mlistp2))
      (cons 10 (nth 5  mlistp2))))
(setq entPath2 (entlast)) (princ) 
); end of defun : handle_poly2
; 4. Draws third handle
(defun handle_poly3 (pointi Len1 Height1 rad1 / p17 p18 p19 p20 p21 mlistp1)
  (setq p17 (polar pointi 0.0 (- Len1 rad1))
	p18 (polar (polar pointi 0.0 Len1) (/ pi 2.0) rad1)
	p19 (polar (polar pointi 0.0 Len1) (/ pi 2.0) (- Height1 rad1))
	p20 (polar (polar p19 (/ pi 2.0) rad1) pi rad1)
	p21 (polar pointi (/ pi 2.0) Height1)
	)
  (entmake (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity") '(100 . "AcDbPolyline") '(90 . 6);Number of points (vertices) in the polyline
		 (cons 10  pointi)
		 (cons 10  p17) '(40 . 0.0) '(41 . 0.0) '(42 . 0.414214) '(91 . 0)
		 (cons 10 p18)
		 (cons 10 p19) '(40 . 0.0) '(41 . 0.0) '(42 . 0.414214) '(91 . 0)
		 (cons 10  p20)
		 (cons 10  p21)
		 (cons 70 0)
		 ));end entmake
    (setq entPath1 (entlast)) (princ) 
(setq mlistp1 (mirror-points-y (list pointi p17 p18 p19 p20 p21)))
   (entmake (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity") '(100 . "AcDbPolyline") '(90 . 6);Number of points (vertices) in the polyline
		 (cons 10  (nth 0  mlistp1))
		 (cons 10  (nth 1  mlistp1)) '(40 . 0.0) '(41 . 0.0) '(42 . -0.414214) '(91 . 0)
		 (cons 10 (nth 2  mlistp1))
		 (cons 10 (nth 3  mlistp1)) '(40 . 0.0) '(41 . 0.0) '(42 . -0.414214) '(91 . 0)
		 (cons 10  (nth 4  mlistp1))
		 (cons 10  (nth 5  mlistp1))
		 (cons 70 0)
		 ));end entmake
    (setq entPath2 (entlast)) (princ) 
   );end of defun : handle_poly3

;This function draws a closed polyline for cutting holes using 12 points
(defun cut_holder_poly (listpoint / )
(entmake (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity") '(100 . "AcDbPolyline") '(90 . 12);Number of points (vertices) in the polyline
(cons 10  (nth 0 listpoint)) '(40 . 0.0) '(41 . 0.0) '(42 . 0.414214) '(91 . 0)
(cons 10 (nth 1 listpoint))
(cons 10  (nth 2 listpoint)) '(40 . 0.0) '(41 . 0.0) '(42 . -0.414214) '(91 . 0)
(cons 10  (nth 3 listpoint))
(cons 10  (nth 4 listpoint))
(cons 10  (nth 5 listpoint))
(cons 10  (nth 6 listpoint))
(cons 10  (nth 7 listpoint))
(cons 10  (nth 8 listpoint)) '(40 . 0.0) '(41 . 0.0) '(42 . -0.414214) '(91 . 0)	 
(cons 10  (nth 9 listpoint))
(cons 10  (nth 10 listpoint)) '(40 . 0.0) '(41 . 0.0) '(42 . 0.414214)
(cons 10  (nth 11 listpoint))
		 (cons 70 1)));end entmake
   (princ));end of defun :cut_holder_poly

;##################################################
;#                                                #
;#              Helper functions                  #
;#                                                #
;##################################################

						
; 1. Function for creating mirrored points
(defun mirror-points-y (lst) (mapcar '(lambda (pt) (list (- (car pt)) (cadr pt))) lst)) ; end of defun :mirror-points-y


; 2. Function that draws a polyline using entmakex.
;Requires lst - a list of points, and cls 1 - for a closed polyline or 0 - for an open polyline
(defun drawLWPoly (lst cls / )
(setq baseProfile (entmakex (append (list (cons 0 "LWPOLYLINE") (cons 100 "AcDbEntity") (cons 100 "AcDbPolyline")
                         (cons 90 (length lst)) ;if there are 5 points this will be (90 . 5)
                         (cons 70 cls)) 	;(70 . 0) -  open | (70 . 1) - closed
                   (mapcar (function (lambda (p) (cons 10 p))) lst))))); end of defun : drawLWPoly
;--------------------------------------------------------------------------
; 3. Calculates the bulge for polylines with arcs 
(defun GetBulge (p1 p2 rad / dist h)
  (setq dist (distance p1 p2)) ; Chord length
  (if (<= (* 2.0 rad) dist)
    (setq h rad) ;If the radius is minimal (semicircle)
    (setq h (- rad (sqrt (- (* rad rad) (* (/ dist 2.0) (/ dist 2.0))))))
  )
  (/ (* 2.0 h) dist) ; Returns bulge value
); end of defun :GetBulge

; 4. Helper function for tangent
(defun tan (ang) (/ (sin ang) (cos ang))); end of defun :tan

; 5. Function for deleting polylines 
(defun DeleteLastPoly (ent /  vla-obj )
(if (and ent (member (cdr (assoc 0 (entget ent))) '("LWPOLYLINE" "POLYLINE")))
(progn (setq vla-obj (vlax-ename->vla-object ent)) (vla-delete vla-obj))) (princ)); end of defun : DeleteLastPoly

;6. Sets the isometric realistic view.
(defun SetRealisticView ( / acadObj doc viewObj dirPt )
(setq acadObj (vlax-get-acad-object)) (setq doc (vla-get-ActiveDocument acadObj))
(setq viewObj (vla-get-ActiveViewport doc)) (setq dirPt (vlax-3d-point '(-1.0 -1.0 1.0)))
(vla-put-Direction viewObj dirPt) (vla-put-ActiveViewport doc viewObj) (vl-cmdf "_.VSCURRENT" "_Realistic") 
  ); end of defun :SetRealisticView


;7. Extrudes the handle profile along a path
(defun SweepPline (entProf entPath / acadObj activeDoc blockObj objProf objPath regionList objRegion objSolid)
  (setq acadObj (vlax-get-acad-object) activeDoc (vla-get-activedocument acadObj))
  ;Correctly determine the current model space
  (if (= (vla-get-activespace activeDoc) acModelSpace) (setq blockObj (vla-get-modelspace activeDoc)) (setq blockObj (vla-get-paperspace activeDoc)))
    (if (and entProf entPath)
    (progn
      (setq objProf (vlax-ename->vla-object entProf))
      (setq objPath (vlax-ename->vla-object entPath)) 
      ;Creating a region using only vlax-invoke (WITHOUT safearray/variant)
      (setq regionList (vl-catch-all-apply 'vlax-invoke (list blockObj 'AddRegion (list objProf))))
      (if (and regionList (not (vl-catch-all-error-p regionList)))
        (progn
          ;Since vlax-invoke returns a plain LISP list, get the first element directly using car
          (setq objRegion (car regionList))
          ;Extruding the region along the path
          (setq objSolid (vl-catch-all-apply 'vla-addextrudedsolidalongpath (list blockObj objRegion objPath)))
          (if (not (vl-catch-all-error-p objSolid))
            (progn
              (vla-delete objRegion) ;Delete the helper region
            )
            (progn
              (princ (strcat "\nError during extrusion: " (vl-catch-all-error-message objSolid)))
              (vla-delete objRegion) ;Delete the region to prevent duplicate objects
            )
          )
        )
        (princ "\nError: The profile cannot be converted into a region. Check whether it is perpendicular or completely closed.")
      )
    )
    (princ "\nError: Invalid profile or path.")
  )
  (vla-regen activeDoc acAllViewports)  
  (princ));; end of defun : SweepPline

;;;(alert "C:CupHolder  program is loaded. \n\nWrite CupHolder in the console to start it.")

