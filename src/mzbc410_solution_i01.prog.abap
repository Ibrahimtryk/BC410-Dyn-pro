*----------------------------------------------------------------------*
***INCLUDE MZBC410_SOLUTION_I01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE ok_code.
    WHEN 'FC1' OR 'FC2' OR 'FC3'.
      my_tabstrip-activetab = ok_code.
    WHEN 'BACK'.
      IF sy-datar IS INITIAL.
        LEAVE TO SCREEN 0.
      ELSE.
        CALL FUNCTION 'POPUP_TO_CONFIRM'
          EXPORTING
            titlebar              = 'Dynpro 100 verlassen'
            text_question         = 'Möchten Sie vorher sichern?'
*           TEXT_BUTTON_1         = 'Ja'(001)
            icon_button_1         = 'ICON_OKAY'
*           TEXT_BUTTON_2         = 'Nein'(002)
            icon_button_2         = 'ICON_INCOMPLETE '
            default_button        = '2'
*           DISPLAY_CANCEL_BUTTON = 'X'
*           USERDEFINED_F1_HELP   = ' '
            start_column          = 50
            start_row             = 10
*           POPUP_TYPE            =
            iv_quickinfo_button_1 = 'Programm verlassen '
            iv_quickinfo_button_2 = 'Im Dynpro bleiben '
          IMPORTING
            answer                = gv_answer.  " '1', '2', 'A'
        CASE gv_answer.
          WHEN '1'. "ja
            MESSAGE 'Daten werden noch gesichtert' TYPE 'I'.
          WHEN '2' . "nein
            LEAVE TO SCREEN 0.
          WHEN 'A'.  "Abbruch
        ENDCASE.

      ENDIF.
    WHEN 'TIME'.
      CALL SCREEN 150
      STARTING AT   50   10
      ENDING AT     80   13.
      "  MESSAGE ` Ok-Codeaus Dynpro 150 ` && ok_code TYPE 'I'.
    WHEN 'SAVE'.
      MOVE-CORRESPONDING sdyn_conn TO gs_sflight.
      MOVE sflight-zzpilot TO gs_sflight-zzpilot.
      UPDATE sflight FROM gs_sflight.
      IF sy-subrc = 0.
        MESSAGE 'Update erfolgreicht' TYPE 'S'.
        LEAVE TO SCREEN 100.
      ELSE.
        MESSAGE 'Update fehlgeschlagen' TYPE 'A'.
      ENDIF.
    WHEN 'FC_CHECK1'.
      IF gv_check1 = 'X'.
        gv_seatsfree = gs_sflight-seatsmax - gs_sflight-seatsocc.
      ENDIF.
    WHEN 'FC_OPT_PLANE'.
      SELECT SINGLE planetype seatsmax
          FROM saplane
            INTO (gs_sflight-planetype, gs_sflight-seatsmax)
            WHERE seatsmax =
             ( SELECT MIN( seatsmax )
             FROM saplane
              WHERE seatsmax >= sdyn_conn-seatsocc ).


  ENDCASE.



ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_SFLIGHT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_sflight INPUT.
  SELECT SINGLE * FROM sflight
    INTO gs_sflight
    WHERE carrid = sdyn_conn-carrid
      AND connid = sdyn_conn-connid
      AND fldate = sdyn_conn-fldate.

  CASE sy-subrc.
    WHEN 0.
      SELECT SINGLE carrname url FROM scarr
        INTO (sdyn_conn-carrname, sdyn_conn-zz_url)
        WHERE carrid = sdyn_conn-carrid.
      IF gs_sflight-fldate GE sy-datum.
        PERFORM set_icon
        USING 'ICON_OKAY' 'Heute oder Zukunft ' gv_icon_flugdatum ' '.
      ELSE.
        PERFORM set_icon
        USING 'ICON_INCOMPLETE' 'Vergangenheit ' gv_icon_flugdatum 'Tooltip Past'.
      ENDIF.
      MESSAGE 'Datensatz wurde erfolgreich gelesen' TYPE 'S'.
    WHEN 4.
      MESSAGE e007(bc410).
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PLANETYPE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_planetype INPUT.
  SELECT SINGLE * FROM saplane
    INTO gs_saplane
    WHERE planetype = sdyn_conn-planetype.
  IF sy-subrc = 0.
    IF gs_saplane-seatsmax >= sdyn_conn-seatsocc.
      gs_sflight-seatsmax = gs_saplane-seatsmax.
      gs_sflight-planetype = gs_saplane-planetype.
      CLEAR gv_check_optimaler_typ.
    ELSE.
      "sdyn_conn-planetype = gs_sflight-planetype.
      MESSAGE e109(bc410).

    ENDIF.
  ELSE.
    MESSAGE 'Flugzeugtyp exisitiert nicht' TYPE 'E'.

  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  CASE ok_code.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANCEL'.
      "CLEAR sdyn_conn.
      CLEAR gs_sflight.
      CLEAR sflight.
      SET PARAMETER ID 'CAR' FIELD gs_sflight-carrid.
      SET PARAMETER ID 'CON' FIELD gs_sflight-connid.
      SET PARAMETER ID 'DAY' FIELD gs_sflight-fldate.
      LEAVE TO SCREEN 100.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  NEUES_RELEASE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE neues_release INPUT.
  MESSAGE 'Neues Release' TYPE 'I'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  UPDATE_TABELLE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE update_tabelle INPUT.
  IF sdyn_book-mark = 'X'.

  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  TRANS_TO_GS_SBOOK  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE trans_from_tc INPUT.
  MOVE-CORRESPONDING sdyn_book TO wa_sdyn_book.
  MODIFY it_sdyn_book FROM wa_sdyn_book INDEX my_table_control-current_line.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  UPDATE_SBOOK  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE update_sbook INPUT.
  IF ok_code = 'FC_UPDATE'.
    MOVE-CORRESPONDING it_sdyn_book TO gt_sbook.
    UPDATE sbook FROM TABLE gt_sbook.
    CASE sy-subrc.
      WHEN 0.
        MESSAGE 'Update auf Tabelle Sbook erfolgreicht' TYPE 'S'.
      WHEN 4.
        MESSAGE 'Fataler Fehler bei Update auf Sbook' TYPE 'X'.
    ENDCASE.
  ENDIF.

ENDMODULE.
