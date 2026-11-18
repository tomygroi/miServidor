# ☁️ Home Server: Nube Privada, Gestión de Fotos & Automatización con Nextcloud, Immich y Docker

Este repositorio contiene la configuración, infraestructura y scripts de automatización utilizados para desplegar un servidor doméstico basado en **Ubuntu Server**, centralizando el almacenamiento seguro de archivos, la gestión y copia de seguridad autohospedada de fotos/videos y la automatización de descarga de contenido multimedia.

---
# 📃 Objetivos:
- **Centralizar el Almacenamiento Personal:** Crear una infraestructura privada utilizando **Nextcloud** para archivos/documentos e **Immich** para la gestión de fotos y videos.
- **Almacenamiento Ilimitado:** Evitar el pago de suscripciones recurrentes por cuotas de almacenamiento limitadas en la nube.
- **Control Total de <u>TUS</u> Archivos:** Al subir tus datos a una nube privada autohospedada, garantizás el control <u>TOTAL</u> y la privacidad de tus archivos personales y fotos sin depender de terceros.

---

### 🛠️ Stack de Tecnología e Infraestructura del Proyecto

| Categoría | Tecnologías Clave |
| :--- | :--- |
| **DevOps & Plataformas** | ![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat-square&logo=linux&logoColor=black) ![Ubuntu Server](https://img.shields.io/badge/Ubuntu_Server-E95420?style=flat-square&logo=ubuntu&logoColor=white) ![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white) |
| **Almacenamiento & Apps** | ![Nextcloud](https://img.shields.io/badge/Nextcloud-0082C9?style=flat-square&logo=nextcloud&logoColor=white) ![Immich](https://img.shields.io/badge/Immich-171717?style=flat-square&logo=immich&logoColor=white) ![MeTube](https://img.shields.io/badge/MeTube-FF0000?style=flat-square&logo=youtube&logoColor=white) |
| **Networking & Conectividad** | ![Tailscale](https://img.shields.io/badge/Tailscale-56347C?style=flat-square&logo=tailscale&logoColor=white) |

---

### 💻 Hardware del Servidor (Componentes de la PC)

| Componente | Detalle Técnico |
| :--- | :--- |
| **Procesador (CPU)** | ![Intel](https://img.shields.io/badge/Intel-0071C5?style=flat-square) Intel Core i5-3470 |
| **Memoria RAM** | **x2** 8 GB 1333 MHz (Dual Channel) |
| **Placa Madre (Mother)** | **GIGABYTE GA-Q77M-D2H** (Chipset Intel Q77 con soporte vPro) |
| **Almacenamiento (SO)** | ![SSD](https://img.shields.io/badge/120_GB_SSD-0051BA?style=flat-square) Western Digital Green (Sistema Operativo) |
| **Almacenamiento (Data)** | ![HDD](https://img.shields.io/badge/1_TB_Seagate_Enterprise-737373?style=flat-square) Disco Rígido Exclusivo montado para Nextcloud, Immich y Media |
| **Conectividad (Red)** | ![Ethernet](https://img.shields.io/badge/1_Gbps_Ethernet-0078D4?style=flat-square) Integrada en placa (Conexión por cable LAN) |

---

## 🚀 Características del Proyecto

- **Almacenamiento Autohospedado (Self-Hosted):** Despliegue de servicios mediante **Docker Compose** mapeando volúmenes de almacenamiento persistente montados directamente en el disco secundario de 1TB.
- **Gestión Fotográfica Inteligente con Immich:** Respaldo automático de imágenes y videos en alta calidad desde dispositivos móviles, reemplazando a Google Photos con búsqueda facial, geotagging y reconocimiento de objetos por IA local.
- **Redes Privadas Seguras (Mesh VPN):** Integración con **Tailscale** para acceder a Nextcloud, Immich y la gestión del servidor de forma remota y segura desde cualquier dispositivo fuera de la red local, sin necesidad de abrir puertos en el router hogareño.
- **Monitoreo Automático en Tiempo Real:** Script en Bash integrado con `inotify-tools` que vigila el directorio de descargas/archivos y envía notificaciones instantáneas a Telegram (vía CallMeBot) cuando se procesan nuevas subidas o eliminaciones.
- **Filtrado de Spam Quirúrgico:** Lógica implementada en el monitor de archivos para omitir escrituras de archivos temporales (`.tmp`, `.part`, `.json`) generados por contenedores de descargas automatizadas (como MeTube).
- **Conexión Remota vía SSH:** Administración de bajo nivel mediante la consola remota por SSH dentro del ecosistema Linux.

---

## 📁 Estructura del Repositorio

- `/docker`: Contiene los archivos `docker-compose.yml` para Nextcloud, Immich y los servicios complementarios.
- `/scripts`: Scripts en Bash optimizados para el monitoreo del sistema de archivos y alertas de almacenamiento.

---

## ⚙️ Notas de Despliegue (Machete Rápido)

### 1. Dependencias del Servidor
Para que los scripts de monitoreo y la orquestación funcionen, el servidor requiere:

```bash
sudo apt update && sudo apt install inotify-tools curl docker.io docker-compose-v2 -y
