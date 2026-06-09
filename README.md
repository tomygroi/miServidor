# ☁️ Home Server: Nube Privada & Automatización con Nextcloud y Docker

Este repositorio contiene la configuración, infraestructura y scripts de automatización utilizados para desplegar un servidor doméstico basado en **Ubuntu Server**, centralizando el almacenamiento de archivos y fotos privado y automatizacion de descarga de contenido.

---
# 📃 Objetivos:
* **Centralizar el Almacenamiento Personal:** Crear una nube privada utilizando Nextcloud para almacenar y gestionar archivos de forma segura.
* **Almacenamiento Ilimitado:** Ya basta de pagar por un almacenamiento extra ya que tenes una quota limitada.
* **Control total de <u>TUS</u> Archivos:** Al subirlo a una nube de terceros nunca terminan siendo de tu propiedad que uno mismo tenga el control <u>TOTAL</u> de los archivos.

### 🛠️ Stack de Tecnología e Infraestructura del Proyecto

| Categoría | Tecnologías Clave |
| :--- | :--- |
| **DevOps & Plataformas** | ![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat-square&logo=linux&logoColor=black) ![Ubuntu Server](https://img.shields.io/badge/Ubuntu_Server-E95420?style=flat-square&logo=ubuntu&logoColor=white) ![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white) |
| **Almacenamiento & Apps** | ![Nextcloud](https://img.shields.io/badge/Nextcloud-0082C9?style=flat-square&logo=nextcloud&logoColor=white) |
| **Networking & Conectividad** | ![Tailscale](https://img.shields.io/badge/Tailscale-56347C?style=flat-square&logo=tailscale&logoColor=white) |

---

## 🚀 Características del Proyecto

* **Almacenamiento Autohospedado (Self-Hosted):** Despliegue de Nextcloud mediante Docker-Compose utilizando un volumen de almacenamiento montado en un disco externo de 1TB.
* **Redes Privadas Seguras (Mesh VPN):** Integración con **Tailscale** para acceder a la nube de forma remota y segura desde cualquier dispositivo fuera de la red local, prescindiendo de la apertura de puertos complejos en el router hogareño.
* **Monitoreo Automático en Tiempo Real:** Script en Bash integrado con el motor del kernel `inotify-tools` que vigila el directorio de archivos y envía notificaciones instantáneas a Telegram (vía CallMeBot) cuando se procesan nuevas subidas o eliminaciones.
* **Filtrado de Spam Quirúrgico:** Lógica implementada en el monitor de archivos para omitir de forma inteligente las escrituras de archivos temporales (`.tmp`, `.part`, `.json`) generadas por contenedores de descargas automatizadas (como MeTube).
* **Conexion Remota via SSH:** Al utilizar linux disponemos de la gran ventaja de conectarnos por la misma consola por *SSH* y poder trabajar mas comodamente desde nuestra casa

---

## 📁 Estructura del Repositorio

* `/docker`: Contiene los archivos `docker-compose.yml` base para la orquestación de los contenedores.
* `/scripts`: Scripts en Bash optimizados para el monitoreo del sistema de archivos y alertas de almacenamiento.

---

## ⚙️ Notas de Despliegue (Machete Rápido)

### 1. Dependencias del Servidor
Para que los scripts de monitoreo funcionen, el servidor requiere:

```bash
sudo apt update && sudo apt install inotify-tools curl -y
```

### **2. Configuración del Servicio de Monitoreo**

El script se configuró como un servicio nativo del sistema mediante systemd para asegurar su ejecución constante en segundo plano y su persistencia tras reinicios del servidor.
* Crear el archivo del servicio:  
   ```bash  
   sudo nano /etc/systemd/system/nextcloud-watch.service
    ```

* Añadir la siguiente estructura:  
   ```TOML  
   \[Unit\]  
   Description\=Nextcloud File Watcher Service  
   After\=network.target
   
   \[Service\]  
   Type\=simple  
   ExecStart\=/bin/bash /mnt/nextcloud\_1tb/scripts/watch\_nextcloud.sh  
   Restart\=always  
   RestartSec\=5

   \[Install\]  
   WantedBy\=multi-user.target
    ```

* Habilitar y arrancar el servicio para que corra desde el inicio:  
   ```bash  
   sudo systemctl daemon-reload  
   sudo systemctl enable nextcloud-watch.service  
   sudo systemctl start nextcloud-watch.service
    ```

## **🛠️ Guía de Uso del Monitor Automático**

Para el ejemplo usaremos **Metube**, un contenedor que aprovecha un video de youtube y lo convierte a un video/audio descargable. Este ejemplo puede ser usado con cualquier tipo de conversor que se requiera: El script procesa los eventos del kernel generados en las carpetas de Nextcloud. Gracias a la inclusión del filtro robusto anti-spam para **MeTube**, el comportamiento de las alertas funciona de la siguiente manera:

* **Durante la descarga:** MeTube crea múltiples archivos temporales .tmp y metadatos .json en el disco. El script los detecta e intercepta, descartándolos al instante para evitar saturar el canal de Telegram.  
* **Al finalizar la descarga:** En cuanto el archivo se consolida con su nombre y extensión definitiva (ej: .mp4 o .mp3), el sistema dispara una única notificación limpia con el estado del almacenamiento del disco de 1TB.

## **🛡️ Seguridad y Buenas Prácticas**

* **Cero Puertos Abiertos:** Al utilizar **Tailscale**, el servidor no expone los puertos 80 o 443 al internet público tradicional, lo que mitiga ataques de escaneo de puertos (port-scanning) y vulnerabilidades web directas.  
* **Separación de Credenciales:** Las claves de API críticas, tokens de servicios de mensajería y nombres de usuario específicos se manejan localmente mediante variables declaradas dentro del servidor, evitando su filtración en repositorios públicos.  
* **Persistencia Segura:** El uso de volúmenes de Docker hacia el disco de 1TB garantiza que, ante cualquier caída, actualización de contenedores o fallo del sistema operativo base, los datos personales permanezcan intactos y aislados.