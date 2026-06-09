# ☁️ Home Server: Nube Privada & Automatización con Nextcloud y Docker

Este repositorio contiene la configuración, infraestructura y scripts de automatización utilizados para desplegar un servidor doméstico basado en **Ubuntu Server**, centralizando el almacenamiento privado y herramientas de descarga automatizada.

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