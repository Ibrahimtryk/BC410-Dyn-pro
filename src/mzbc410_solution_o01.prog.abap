*----------------------------------------------------------------------*
***INCLUDE MZBC410_SOLUTION_O01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  CASE 'X'.
    WHEN gs_modus-view.
      SET TITLEBAR 'TITEL_0100' WITH TEXT-mo1.
      SET PF-STATUS 'STATUS_0100' EXCLUDING 'SAVE'.
    WHEN gs_modus-maintain_flights.
      SET TITLEBAR 'TITEL_0100' WITH TEXT-mo2.
      SET PF-STATUS 'STATUS_0100' .
    WHEN gs_modus-maintain_bookings.
      SET TITLEBAR 'TITEL_0100' WITH TEXT-mo3.
      SET PF-STATUS 'STATUS_0100' EXCLUDING 'SAVE'.
    WHEN OTHERS.
      SET TITLEBAR 'TITEL_0100' WITH TEXT-mo1.
      gs_modus-view = 'X'.
      SET PF-STATUS 'STATUS_0100' EXCLUDING 'SAVE'.
  ENDCASE.


ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  TRANS_TO_DYNPRO  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE trans_to_dynpro OUTPUT.
  MOVE-CORRESPONDING gs_sflight TO sdyn_conn.
  MOVE gs_sflight-zzpilot TO sflight-zzpilot.

  IF sdyn_conn-price IS INITIAL.
    SET CURSOR FIELD 'SDYN_CONN-PRICE'.
  ELSE.
    SET CURSOR FIELD 'SDYN_CONN-FLDATE' OFFSET 3.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  MANIPULATE_SCREEN  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE modify_screen OUTPUT.
*  LOOP AT SCREEN.
*    IF screen-name = 'P2'.
*      screen-active = 0.
*      MODIFY SCREEN.
*    ENDIF.
*  ENDLOOP.

  IF gs_modus-maintain_flights = 'X'.
    LOOP AT SCREEN.
      IF screen-group4 = 'OPT'.
        screen-input = 1.
        screen-invisible = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.
* AusblendenCheckbox bei Flügen in der Vergangenheit
  IF gs_sflight-fldate < sy-datum.
    gv_check1 = ' '.
    LOOP AT SCREEN.
      IF screen-name = 'GV_CHECK1' .
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.
*Ausblenden Ergebnis der Berechnungen, wenn Checkbox nicht aktiv ist
  IF gv_check1 IS INITIAL.
    LOOP AT SCREEN.
      IF screen-name = 'GV_SEATSFREE' OR screen-name = 'TEXT_FP'.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.

*Ausblenden von leeren Anzeigefeldern, wenn eines leer ist
*  IF sdyn_conn-planetype IS INITIAL.
*    LOOP AT SCREEN.
*      IF screen-group3 = 'AUS'.
*        screen-active = 0.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*  ENDIF.



*  LOOP AT  SCREEN INTO screen.
*    IF screen-name CS 'SDYN_CONN-CONNID'.
*      screen-required = 2.
*      MODIFY screen FROM screen.
*    ENDIF.
*    IF screen-group1 = 'PRC'.
*      screen-input = 1.
*      MODIFY SCREEN.
*    ENDIF.
*    IF screen-group2 = 'VAL'.
*      screen-value_help = 0.
*      MODIFY SCREEN.
*    ENDIF.
*    IF screen-group2 = 'LEN'.
*      screen-length = 12.
*      "screen-intensified = 1.
*      MODIFY SCREEN.
*    ENDIF.

*  ENDLOOP.


ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  CLEAR_OK_CODE  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.
  CLEAR ok_code.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0150  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0150 OUTPUT.
  SET PF-STATUS 'STATUS_0150'.
  SET TITLEBAR 'TITEL_0150'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PILOT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_pilot INPUT.
  MESSAGE 'Pilotenname wirc gecheckt' TYPE 'I'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  GET_SPFLI  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_spfli OUTPUT.
  ON CHANGE OF sdyn_conn-carrid OR sdyn_conn-connid.
    SELECT SINGLE * FROM spfli
      INTO CORRESPONDING FIELDS OF sdyn_conn
      WHERE carrid = sdyn_conn-carrid
        AND connid = sdyn_conn-connid.
  ENDON.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  GET_SAPLANE  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_saplane OUTPUT.
  ON CHANGE OF sdyn_conn-planetype.
    SELECT SINGLE * FROM saplane
      INTO  saplane
      WHERE planetype = sdyn_conn-planetype.
  ENDON.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  FILL_DYNNR  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE fill_dynnr OUTPUT.

  IF ok_code = 'FC1' OR ok_code = 'FC2' OR ok_code = 'FC3'.
    CLEAR gs_modus.
    CASE my_tabstrip-activetab.
      WHEN 'FC1'.
        dynnr = '0110'.
        gs_modus-view = 'X'.
      WHEN 'FC2'.
        dynnr = '0120'.
        gs_modus-maintain_flights = 'X'.
      WHEN 'FC3'.
        dynnr = '0130'.
        gs_modus-maintain_bookings = 'X'.
    ENDCASE.
  ELSE.
    CASE 'X'.
      WHEN gs_modus-view.
        dynnr = '0110'.
        my_tabstrip-activetab = 'FC1'.
        "    MY_TABSTRIP-invisible = space.
      WHEN gs_modus-maintain_flights.
        dynnr = '0120'.
        my_tabstrip-activetab = 'FC2'.
      WHEN gs_modus-maintain_bookings.
        dynnr = '0130'.
        my_tabstrip-activetab = 'FC3'.
        "MY_TABSTRIP-invisible = 'X'.
      WHEN OTHERS.
        dynnr = '0110'.
        my_tabstrip-activetab = 'FC1'.
    ENDCASE.
  ENDIF.


ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  GET_DATEN  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_daten OUTPUT.

  SELECT SINGLE * FROM mara
    INTO CORRESPONDING FIELDS OF zdynn_wko
    WHERE matnr = 'ABC'.

  SELECT SINGLE * FROM kna1
    INTO  CORRESPONDING FIELDS OF zdynn_wko
    WHERE kunnr = '1'.


ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  GET_SBOOK  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_sbook OUTPUT.
  ON CHANGE OF sdyn_conn-carrid OR sdyn_conn-connid OR sdyn_conn-fldate.

    SELECT * FROM sbook
      INTO  CORRESPONDING FIELDS OF TABLE it_sdyn_book
       WHERE carrid = sdyn_conn-carrid
        AND  connid = sdyn_conn-connid
        AND fldate = sdyn_conn-fldate
        AND cancelled <> gv_not_cancelled.

    my_table_control-lines = lines( it_sdyn_book ).
  ENDON.
*  LOOP AT it_sdyn_book INTO wa_sdyn_book.
*    wa_sdyn_book-mark = ' '.
*    MODIFY it_sdyn_book FROM wa_sdyn_book.
*  ENDLOOP.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  TRANS_TO_SDYN_BOOK  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE trans_to_tc OUTPUT.
  MOVE-CORRESPONDING wa_sdyn_book TO sdyn_book.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  ALV_ANZEIGE  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE alv_anzeige OUTPUT.
* ALV Datenreferenzen (sie sind global definiert
  DATA go_alv TYPE REF TO cl_salv_table.
  DATA go_cont TYPE REF TO cl_gui_custom_container.
  " DATA go_func TYPE REF TO cl_salv_functions.

  IF go_cont IS INITIAL.
    CREATE OBJECT go_cont
      EXPORTING
        container_name = 'MY_CUSTOM_CONTROL'.


    cl_salv_table=>factory(
      EXPORTING
*      list_display   = IF_SALV_C_BOOL_SAP=>FALSE
        r_container    = go_cont
      IMPORTING
        r_salv_table   = go_alv
      CHANGING
        t_table        = it_sdyn_book
           ).
*    go_func = go_alv->get_functions( ).
*    go_func->set_all( ).
  ENDIF.
  go_alv->display( ).

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CTR_MODIFY1  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE ctr_modify1 OUTPUT.

  "  my_table_control-fixed_cols = 2.
  "  my_table_control-h_grid = ' '.
  "  my_table_control-v_grid = ' '.
*  LOOP AT my_table_control-cols INTO gs_cols.
*    IF gs_cols-index < 4.
*      gs_cols-screen-intensified = 1.
*
*    ELSE.
*      gs_cols-screen-intensified = 0.
*    ENDIF.
*    MODIFY my_table_control-cols FROM gs_cols.
*
*  ENDLOOP.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  MODIFY_SCREEN_130  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE modify_screen_130 OUTPUT.
  IF sdyn_book-smoker = 'X' AND smoker = 'X'.
    LOOP AT SCREEN.
      screen-intensified = 1.
      MODIFY SCREEN.
    ENDLOOP.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0130  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0130 INPUT.
  DATA gv_flag TYPE c LENGTH 1.
  " FIELD-SYMBOLS <fs_dyn> type sdyn_book.
  CASE ok_code.
    WHEN 'SELE' OR 'DSELE'.

      IF ok_code = 'SELE'.
        gv_flag = 'X'.
      ELSE.
        gv_flag = space.
      ENDIF.

      LOOP AT it_sdyn_book ASSIGNING FIELD-SYMBOL(<fs_dyn>).
        <fs_dyn>-mark = gv_flag.
        "  MODIFY it_sdyn_book FROM wa_sdyn_book .
      ENDLOOP.


    WHEN 'SRTU' OR 'SRTD'.
      READ TABLE my_table_control-cols INTO gs_cols
       WITH KEY selected = 'X'.
      CASE sy-subrc.
        WHEN 0.
          IF ok_code = 'SRTU'.
            SORT it_sdyn_book BY (gs_cols-screen-name+10) ASCENDING.
          ELSE.
            SORT it_sdyn_book BY (gs_cols-screen-name+10) DESCENDING.
          ENDIF.
        WHEN 4.
          MESSAGE 'Keine Spalte markiert' TYPE 'I'.
      ENDCASE.



  ENDCASE.
ENDMODULE.
