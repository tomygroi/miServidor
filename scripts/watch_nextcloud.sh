#!/bin/bash

# =====================================================================
# CONFIGURACIÓN LOCAL (Modificar con tus datos reales en el servidor)
# =====================================================================
MONITOR_DIR="/mnt/nextcloud_1tb/data/TU_USUARIO_NEXTCLOUD/files"
TELEGRAM_USER="TU_USUARIO_DE_TELEGRAM"
CALLMEBOT_APIKEY="TU_APIKEY_DE_CALLMEBOT"
# =====================================================================

echo "Vigilando subidas reales filtrando solo basura de MeTube..."

inotifywait -m -r -e close_write -e moved_to -e moved_from -e delete --format '%e;%w;%f' "$MONITOR_DIR" | while read -r line
do
    EVENT=$(echo "$line" | cut -d';' -f1)
    FULL_PATH=$(echo "$line" | cut -d';' -f2)
    FILE_NAME=$(echo "$line" | cut -d';' -f3)

    # 1. Control de nombres vacíos
    if [ -z "$FILE_NAME" ]; then
        continue
    fi

    # 2. ESCUDO ANTI-SPAM QUIRÚRGICO (Filtra la basura de MeTube y Nextcloud)
    if [[ "$FILE_NAME" == *.tmp ]] || [[ "$FILE_NAME" == *.part ]] || [[ "$FILE_NAME" == *.ocTransfer* ]] || [[ "$FILE_NAME" == *".queue.json"* ]] || [[ "$FILE_NAME" == *".completed.json"* ]] || [[ "$FILE_NAME" == ".templates" ]]; then
        continue
    fi

    # Bloqueamos archivos ocultos que empiezan con punto
    if [[ "$FILE_NAME" == .* ]]; then
        continue
    fi

    # Limpieza de ruta para legibilidad en el mensaje
    CLEAN_PATH=$(echo "$FULL_PATH" | sed "s|${MONITOR_DIR}||")
    if [ -z "$CLEAN_PATH" ]; then
        CLEAN_PATH="/"
    fi

    # Ignoramos si la actividad ocurre dentro de la papelera de reciclaje
    if [[ "$CLEAN_PATH" == */files_trashbin/* ]]; then
        continue
    fi

    # Métrica de espacio disponible en el disco de 1TB
    DISK_INFO=$(df -h /mnt/nextcloud_1tb | tail -n 1)
    DISK_FREE=$(echo "$DISK_INFO" | awk '{print $4}')
    DISK_USED_PCT=$(echo "$DISK_INFO" | awk '{print $5}')
    INFO_DISCO="📊 Almacenamiento: $DISK_USED_PCT usado (Quedan $DISK_FREE libre)"

    # Lógica de detección de eventos: ¿Es una subida/renombre o una eliminación?
    if [[ "$EVENT" == *"DELETE"* ]] || [[ "$EVENT" == *"MOVED_FROM"* ]]; then
        TEXTO_RAW="🗑️ Archivo eliminado de tu nube%0A%0A📄 Nombre: $FILE_NAME%0A📂 Ruta: $CLEAN_PATH%0A%0A$INFO_DISCO"
    else
        if [ ! -e "${FULL_PATH}${FILE_NAME}" ]; then
            TEXTO_RAW="🗑️ Carpeta/Archivo eliminado de tu nube%0A%0A📄 Nombre: $FILE_NAME%0A📂 Ruta: $CLEAN_PATH%0A%0A$INFO_DISCO"
        else
            TEXTO_RAW="🟢 ¡Nuevo archivo listo en la nube! ☁️%0A%0A📄 Nombre: $FILE_NAME%0A📂 Ruta: $CLEAN_PATH%0A%0A$INFO_DISCO"
        fi
    fi

    # Formateo de URL reemplazando espacios por el caracter '+'
    TEXTO_URL=$(echo "$TEXTO_RAW" | tr ' ' '+')

    # Envío de la petición HTTP GET al endpoint de CallMeBot
    curl -s -X GET "https://api.callmebot.com/text.php?user=${TELEGRAM_USER}&text=${TEXTO_URL}&apikey=${CALLMEBOT_APIKEY}" > /dev/null
done