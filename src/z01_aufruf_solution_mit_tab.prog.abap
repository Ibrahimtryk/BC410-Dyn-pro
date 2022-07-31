*&---------------------------------------------------------------------*
*& Report Z01_AUFRUF_SOLUTION_MIT_TAB
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z01_aufruf_solution_mit_tab.

DATA gs_bdc TYPE bdcdata.
DATA gt_bdc TYPE TABLE OF bdcdata.

gs_bdc-program = 'SAPMZBC410_SOLUTION'.
gs_bdc-dynpro =  '0100'.
gs_bdc-dynbegin = 'X'.

APPEND gs_bdc TO gt_bdc.
CLEAR gs_bdc.

gs_bdc-fnam = 'SDYN_CONN-CARRID'.
gs_bdc-fval = 'LH'.
APPEND gs_bdc TO gt_bdc.
CLEAR gs_bdc.

gs_bdc-fnam = 'SDYN_CONN-CONNID'.
gs_bdc-fval = '0400'.
APPEND gs_bdc TO gt_bdc.
CLEAR gs_bdc.

gs_bdc-fnam = 'SDYN_CONN-FLDATE'.
gs_bdc-fval = '26.11.2022'.
APPEND gs_bdc TO gt_bdc.
CLEAR gs_bdc.

gs_bdc-fnam = 'BDC_OKCODE'.
gs_bdc-fval = 'FC3'.
APPEND gs_bdc TO gt_bdc.
CLEAR gs_bdc.

gs_bdc-program = 'SAPMZBC410_SOLUTION'.
gs_bdc-dynpro =  '0100'.
gs_bdc-dynbegin = 'X'.
append gs_bdc to gt_bdc.

CLEAR gs_bdc.
gs_bdc-fnam = 'BDC_OKCODE'.
gs_bdc-fval = 'SELE'.
APPEND gs_bdc TO gt_bdc.

CALL TRANSACTION 'Z00SOLUTION' USING gt_bdc MODE 'E'.
MESSAGE 'Zurück im aufrufenden Programm' TYPE 'I'.
