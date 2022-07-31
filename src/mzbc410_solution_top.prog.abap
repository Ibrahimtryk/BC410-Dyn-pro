*&---------------------------------------------------------------------*
*& Include MZBC410_SOLUTION_TOP                              Modulpool        SAPMZBC410_SOLUTION
*&
*&---------------------------------------------------------------------*
PROGRAM sapmzbc410_solution.

TABLES sdyn_conn.
TABLES sflight.
tables saplane.
tables ZDYNN_WKO.

DATA gs_sflight TYPE sflight.
DATA gt_screen TYPE TABLE OF screen.
DATA gv_mikro TYPE i.
DATA gv_details TYPE c LENGTH 15 VALUE 'Dyn Details'.
DATA gv_icon_flugdatum TYPE icons-text.
DATA gv_text TYPE c LENGTH 8.
DATA gv_text2 TYPE c LENGTH 20.
DATA ok_code TYPE sy-ucomm.
DATA ok_code_save TYPE sy-ucomm.
DATA rahmen_felder TYPE c LENGTH 50 VALUE 'überschrift dynamisch erzeugt'.
DATA gv_check1 TYPE c LENGTH 1 .
DATA gv_seatsfree TYPE i.
data: begin of gs_modus,
       view,
       maintain_flights,
       maintain_bookings,
      END OF gs_modus.

data gv_answer type c LENGTH 1.

data gs_saplane type saplane.
data gv_check_optimaler_typ.

data dynnr type sy-dynnr.

controls my_tabstrip type tabstrip.
controls my_table_control type TABLEVIEW USING SCREEN 130.
data gs_cols like line of my_table_control-cols.

data it_sdyn_book type TABLE OF sdyn_book.
data wa_sdyn_book type sdyn_book.
tables sdyn_book.
data gv_not_cancelled type c LENGTH 1 value 'X'.
data gt_sbook type TABLE OF sbook.

data smoker type c LENGTH 1.
