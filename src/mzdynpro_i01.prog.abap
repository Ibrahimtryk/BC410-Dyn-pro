
*&---------------------------------------------------------------------*
*&  Include           MZDYNPRO_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
 case ok_code.
   when  'EXIT'.
     leave program.
 endcase.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  READ_SFLIGHT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE read_sflight INPUT.
 select single * from sflight
   into sflight
   where carrid = sflight-carrid
     and connid = sflight-connid
     and fldate = sflight-fldate.
ENDMODULE.
