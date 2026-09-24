
///Dialog_1									Dialog_1
Pinky2 : dialog {label = "Assistive device - Pinky; Dialog 1";
  : row {
  : column {
: boxed_row {label = "Profile and name:";
: column {
: toggle { label = "Get by name:";key = "get_p"; }
  : list_box { label = "Select profile:"; key = "file_list_1"; width = 5; edit_width = 5; height = 5;}
  }
  : column {   
  : button { label = "Delete record"; key = "delete_record"; width = 5;}
  : list_box { label = "Record name:"; key = "file_list_2"; width = 5; edit_width = 5; height = 5;}
  }}
  : row {
    : text { label = "Creation date:"; key = "note_box"; edit_width = 10; }
    : text { label = "- - - -"; key = "data"; width = 16; }
}}
 : column {
:boxed_radio_column {label = "Save mode:";
: radio_button {label = "Don't record"; key = "dsave";}
: radio_button {label = "Save as"; key = "saveas";}
: radio_button {label = "Create a new account"; key = "nprof";}
}//end boxed_radio_COLUMN
    : toggle { label = "Create STL";key = "create_stl"; }
}}
    : row {
     : button { label = "Cancel"; key = "cancel"; width = 12;}
     : button { label = "&Next >>"; key = "accept"; width = 6; is_default = true; }
    }}

///Dialog_2									Dialog_2   
Pinky : dialog {key = "Pinky"; label = "Assistive device - Pinky; Dialog 2";
  : row {
  : boxed_column { label = "Main parameters:";
   : boxed_column { label = "Left finger:";
: row {
    : edit_box { key = "Rad1"; edit_width = 3; fixed_width = true; label = "Radius R1:";}
    : edit_box { key = "a1"; edit_width = 3; fixed_width = true; label = "Distance d1:";}
}
: row {
    : edit_box { key = "ang11"; edit_width = 3; fixed_width = true; label = "Angle a1:";}
    : edit_box { key = "ang12"; edit_width = 3; fixed_width = true; label = "Angle a2:";}
}}
: boxed_column {
  label = "Right finger:";
  : row {
    : edit_box { key = "Rad2"; edit_width = 3; fixed_width = true; label = "Radius R2:";}
    : edit_box { key = "a2"; edit_width = 3; fixed_width = true; label = "Distance d2:";}
    }
    : edit_box { key = "ang22"; edit_width = 3; fixed_width = true; label = "Angle a3:";}
    }}
:column {
: edit_box { key = "Diam"; edit_width = 3; fixed_width = true; label = "Sphere diameter D:";}
: image { key = "im"; height = 10.0; width = 26.0; }
}}
: row {
     : button { label = "Cancel"; key = "cancel"; width = 12;}
     : button {key = "Back1"; label = "<< &Back"; width = 11;}
     : button { label = "&Next >>"; key = "accept"; width = 6; is_default = true; }
    }
}//MyEditBoxes


///Dialog_3									Dialog_3   
Pinky1 : dialog {label = "Assistive device - Pinky; Dialog 3";
 : boxed_row {label = "Tools to be attached:";
 : list_box {key = "Block1"; height = 5; fixed_height = true; width = 17; fixed_width = true;}
: column {
 : toggle {key = "Tog_real"; label = "Realistic view";}
 : toggle {key = "Toggtext"; label = "3D texture";}
      }}
: boxed_row {
    label = "3D texture type:";
    : boxed_radio_column {key = "Radio2"; label = "Array";
    : radio_button {key = "Polar1"; label = "Polar array";}
    : radio_button {key = "Fib1"; label = "Fibonacci spiral";}
  }
: column {
   : toggle {key = "Tog3"; label = "Subtract";}
   : list_box {key = "srad"; label = "Sphere radius"; height = 5; fixed_height = true; width = 17; fixed_width = true;}
      }}
     spacer;
  : row {
    fixed_width = true;
    alignment = centered;
    : cancel_button {width = 11;}
    : button {key = "Back"; label = "<< &Back"; width = 11;}
    : button {key = "Next"; is_default = true; label = "&Next >>"; width = 11;}
    }
}

///Dialog_4									Dialog_4   
Pinky4 : dialog {label = "Pinky; Dialog 4";
    : edit_box { label = "Account name:"; key = "Name_of_ak";}
  : edit_box { label = "Record name:"; key = "Name_of_exp";}
      ok_cancel;
  }