*----------------------------------------------------------------------*
***INCLUDE MBC410SPLS_SPLITTER_F01.
*----------------------------------------------------------------------*
FORM display_flights.

  SELECT * FROM spfli
    INTO TABLE  gt_flight
    WHERE carrid = sdyn_conn-carrid.

  IF go_alv IS INITIAL.
    CREATE OBJECT go_alv_container
      EXPORTING
        container_name = gv_custom_control_name.

* ---CREATE ALV OBJECT
    CALL METHOD cl_salv_table=>factory
      EXPORTING
        r_container  = go_alv_container
      IMPORTING
        r_salv_table = go_alv
      CHANGING
        t_table      = gt_flight.
  ENDIF.
*---DISPLAYING THE ALV
  go_alv->get_columns( )->get_column( 'MANDT' )->set_technical( ).
  go_alv->display( ).

ENDFORM.                 " DISPLAY_FLIGHTS  OUTPUT
