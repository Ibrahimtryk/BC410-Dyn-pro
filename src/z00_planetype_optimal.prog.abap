*&---------------------------------------------------------------------*
*& Report Z01_PLANETYPE_OPTIMAL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z00_planetype_optimal.

PARAMETERS pa_occ TYPE sflight-seatsocc.
DATA: gv_plane TYPE saplane-planetype,
      gv_max   TYPE saplane-seatsmax.

SELECT SINGLE planetype seatsmax
  FROM saplane
  INTO (gv_plane, gv_max)
  WHERE seatsmax =
        ( SELECT MIN( seatsmax )
          FROM saplane
          WHERE seatsmax >= pa_occ ).

IF sy-subrc = 0.
  WRITE: / `Kleinstes Flugzeug mit mindestens `&& pa_occ && ` verfügbaren Plätzen`.
  SKIP 2.
  WRITE: / 'Planetype      ', gv_plane,
         / 'Maximale Plätze', gv_max LEFT-JUSTIFIED.
ELSE.
  WRITE 'Kein passendes Flugzeug vorhanden'.
ENDIF.
