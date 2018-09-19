function abort {
    echo "Sicherung wurde abgebrochen"
    exit
}

# Parameter laden

# Parameterdatei pruefen
if [ $# -eq 0 ]
  then
    echo "Keine Parameterdatei angegeben"
    abort
fi

if [ ! -f $1 ]
then
    echo "Parameterdatei $1 existiert nicht"
    abort
fi

source $1

TIME=$(date +%Y%m%d_%H%M%S)

BACKUP_TGT=$BACKUP_BASEDIR/$BACKUP_PROFILE
BACKUP_IND=$BACKUP_BASEDIR/.$BACKUP_PROFILE

LOG_DIR=$BACKUP_BASEDIR/${BACKUP_PROFILE}_log
LOG_FILE=$LOG_DIR/$TIME.log

BACKUP_DEF=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )/source_directories.txt

RSYNC_OPTS="-a -r -v --delete --log-file=$LOG_FILE --files-from=$BACKUP_DEF --stats -h"

# Parameter pruefen
if [ ! -f $SOURCE_BASEDIR ]
then
    echo "Basisverzeichnis der Quelle $SOURCE_BASEDIR existiert nicht. Es wird keine Sicherung durchgefuehrt."
    abort
fi
if [ ! -f $BACKUP_DEF ]
then
    echo "Sicherungsdefinition $BACKUP_DEF existiert nicht. Es wird keine Sicherung durchgefuehrt."
    abort
fi

if [ ! -d $BACKUP_BASEDIR ]
then
    echo "Laufwerk $BACKUP_BASEDIR existiert nicht. Es wird keine Sicherung durchgefuehrt."
    abort
fi

if [ ! -f $BACKUP_IND ]
then
    echo "Indikator-Datei $BACKUP_IND nicht vorhanden. Es wird keine Sicherung durchgefuehrt."
    abort
fi

# Sicherung durchfuehren
echo "***************************DATENSICHERUNG*******************************"
echo "*"
echo "*   Startzeit:             $TIME"
echo "*   Sicherungsdefinition:  $BACKUP_DEF"
echo "*   Zielverzeichnis:       $BACKUP_TGT"
echo "*   Protokolldatei:        $LOG_FILE"
echo "*"
echo "************************************************************************"


mkdir -p $LOG_DIR
mkdir -p $BACKUP_TGT

rsync $RSYNC_OPTS / $BACKUP_TGT

echo Sicherung erfolgreich abgeschlossen.

