
CREATE OR REPLACE FUNCTION roundQty(BOOLEAN, NUMERIC) RETURNS NUMERIC AS '
-- Copyright (c) 1999-2012 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _fractional ALIAS FOR $1;
  _qty ALIAS FOR $2;
  _scale INTEGER;

BEGIN
  SELECT locale_qty_scale INTO _scale
  FROM locale, usr
  WHERE ((usr_locale_id=locale_id) AND (usr_username=getEffectiveXtUser()));

  IF (_fractional) THEN
    RETURN ROUND(_qty, _scale);
  ELSE
    IF (TRUNC(_qty) < ROUND(_qty, _scale)) THEN
      RETURN (TRUNC(_qty) + 1);
    ELSE
      RETURN TRUNC(_qty);
    END IF;
  END IF;
END;
' LANGUAGE 'plpgsql';

