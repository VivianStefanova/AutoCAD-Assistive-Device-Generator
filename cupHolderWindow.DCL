CupDialog : dialog {key = "CupDialog";label = "Cup Holder Generator";
: row { :column {
: boxed_column {label = "Handle";
  : edit_box {key = "handle_size";label = "Handle size, Lh[mm]:";edit_width = 4;fixed_width = true;}
  : popup_list {key = "handle_type";label = "Type:";width = 18;fixed_width = true;}
  : popup_list {key = "handle_width";label = "Thickness:";width = 18;fixed_width = true;}}
  : toggle {key = "sav_stl";label = "Save as stl";fixed_width = true;}}
: boxed_column {label = "Cup body";
  : edit_box {key = "cup_height";label = "Height, H[mm]:";edit_width = 4;fixed_width = true;}
  : edit_box {key = "lower_dia";label = "Lower Diameter, DL[mm]:";edit_width = 4;fixed_width = true;}
  : edit_box {key = "upper_dia";label = "Upper Diameter, DU[mm]:";edit_width = 4;fixed_width = true;}
  : edit_box {key = "cut_width";label = "Cup Handle Width, L[mm]:";edit_width = 4;fixed_width = true;}
  : edit_box {key = "cut_bottom_dist";label = "Distance From Bottom to Handle, HL[mm]:";edit_width = 4;fixed_width = true;}}
} ok_cancel;}
