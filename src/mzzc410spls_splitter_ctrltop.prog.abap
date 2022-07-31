*&---------------------------------------------------------------------*
*&  Include           MBC410SPLS_SPLITTER_TOP
*&---------------------------------------------------------------------*
PROGRAM sapmbc410spls_splitter_ctrl.

TABLES  sdyn_conn.

DATA: ok_code                LIKE sy-ucomm,
      go_splitter            TYPE REF TO cl_dynpro_splitter,
      gt_flight              TYPE STANDARD TABLE OF spfli,
      go_alv                 TYPE REF TO cl_salv_table,
      gv_custom_control_name TYPE scrfname VALUE 'CONTAINER1',
      go_alv_container       TYPE REF TO cl_gui_custom_container.
