-- NO create trigger statements here. the updater will create them.

SELECT dropIfExists('TRIGGER', 'pkguiformbeforetrigger');
CREATE OR REPLACE FUNCTION _pkguiformbeforetrigger() RETURNS "trigger" AS $$
DECLARE
  _uiformid     INTEGER;
  _debug        BOOL := false;

BEGIN
  IF (TG_OP = 'UPDATE') THEN
    RETURN NEW;

  ELSIF (TG_OP = 'INSERT') THEN
    RETURN NEW;

  ELSIF (TG_OP = 'DELETE') THEN
    RETURN OLD;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION _pkguiformalterTrigger() RETURNS TRIGGER AS $$
BEGIN
  IF (pkgMayBeModified(TG_TABLE_SCHEMA)) THEN
    IF (TG_OP = 'DELETE') THEN
      RETURN OLD;
    ELSE
      RETURN NEW;
    END IF;
  END IF;

  IF (TG_OP = 'INSERT') THEN
    RAISE EXCEPTION 'You may not create forms in packages except using the xTuple Updater utility';

  ELSIF (TG_OP = 'UPDATE') THEN
    RAISE EXCEPTION 'You may not alter forms in packages except using the xTuple Updater utility';

  ELSIF (TG_OP = 'DELETE') THEN
    RAISE EXCEPTION 'You may not delete forms from packages. Try deleting or disabling the package.';

  END IF;

  RETURN NEW;
END;

$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION _pkguiformaftertrigger() RETURNS TRIGGER AS $$
BEGIN
  IF (TG_OP = 'DELETE') THEN
    DELETE FROM pkgitem
    WHERE ((pkgitem_type='U')
       AND (pkgitem_item_id=OLD.uiform_id)
       AND (pkgitem_pkghead_id IN (SELECT pkghead_id
                                   FROM pkghead
                                   WHERE pkghead_name = TG_TABLE_SCHEMA)));
    RETURN OLD;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';
