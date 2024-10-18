# Proyecto: Mora2

Bienvenido al repositorio de **Mora2**, un juego desarrollado en **Godot Engine**. Este documento explica la estructura del proyecto para facilitar la colaboración y el desarrollo.

## Tabla de Contenidos

- [Estructura del Proyecto](#estructura-del-proyecto)
  - [1. assets](#1-assets)
  - [2. components](#2-components)
  - [3. scenes](#3-scenes)
    - [3.1. characters](#31-characters)
    - [3.2. levels](#32-levels)
    - [3.3. objects](#33-objects)
    - [3.4. ui](#34-ui)
- [Cómo Seguir la Estructura](#cómo-seguir-la-estructura)
- [Diagramas de Estructura](#diagramas-de-estructura)
- [Contribución](#contribución)
- [Contacto](#contacto)

---

## Estructura del Proyecto

La estructura del proyecto está organizada de manera que cada carpeta y archivo tenga un lugar lógico, facilitando el acceso y modificación.

### 1. assets

Contiene todos los recursos estáticos del juego, como fuentes, sonidos y sprites.

- **fonts/**: Archivos de fuentes utilizados en el juego.
- **sounds/**: Archivos de audio y efectos de sonido.
- **sprites/**: Imágenes y sprites para personajes, objetos y escenarios.

### 2. components

Scripts genéricos y reutilizables que pueden ser utilizados en varias partes del juego.

- **hitbox.gd**: Script que define la caja de impacto para detectar colisiones ofensivas.
- **hurtbox.gd**: Script que define la caja de daño para detectar colisiones defensivas.

### 3. scenes

Contiene todas las escenas del juego, organizadas por tipo.

#### 3.1. characters

Escenas y scripts relacionados con los personajes del juego.

- **enemies/**: Escena de enemigos genéricos (`enemies.tscn`).
- **enemy/**: Escena y script para un tipo específico de enemigo (`enemy.tscn`, `enemy.gd`).
- **enemys/**: Otra variante de enemigos (asegúrate de consolidar si es redundante).
- **player/**: Escena y script del jugador (`player.tscn`, `player.gd`).

#### 3.2. levels

Escenas que representan los diferentes niveles o áreas del juego.

- **dm_1.tscn**, **dm_2.tscn**: Escenas de niveles específicos.
- **END.tscn**: Escena del nivel final.
- **level_1.tscn**, **node_2d.tscn**, **otradimension.tscn**, **otradimension1.tscn**: Otros niveles o dimensiones del juego.
- **test.tscn**: Escena de prueba para experimentación y testing.

#### 3.3. objects

Escenas de objetos interactivos y estáticos del juego.

- **meta/**: Escena y script de la meta o línea de llegada (`meta.tscn`, `meta.gd`).
- **platforms/**: Escenas de plataformas utilizadas en los niveles (`platform.tscn`, `platforms.tscn`).

#### 3.4. ui

Escenas y scripts relacionados con la interfaz de usuario.

- **creditos/**: Escena y script de los créditos (`creditos.tscn`, `credits.gd`, `Credits.tscn`).
- **loser/**: Escena mostrada al perder el juego (`Loser.tscn`).
- **main_menu/**: Escena del menú principal (`MainMenu.tscn`).
- **menu_pausa/**: Escena y script del menú de pausa (`pausarmenu.tscn`, `pausarmenu.gd`).
- **winner/**: Escena mostrada al ganar el juego (`Winner.tscn`).

### 4. scripts

Scripts globales y aquellos que no están directamente asociados con una escena específica.

- **character_body_2d.gd**: Script base para personajes que heredan de `CharacterBody2D`.
- **control.gd**: Script para manejar controles generales del juego.
- **Global.gd**: Script autoload que contiene variables y funciones globales.

---

## Cómo Seguir la Estructura

Al agregar nuevos archivos o modificar existentes, sigue estas pautas:

1. **Agrupa por Funcionalidad**: Coloca archivos relacionados en la misma carpeta. Por ejemplo, escenas y scripts de un enemigo específico deben estar juntos.

2. **Mantén la Consistencia**: Usa nombres descriptivos y consistentes para archivos y carpetas. Evita duplicados o nombres confusos.

3. **Scripts Asociados con Escenas**: Siempre que sea posible, coloca el script en la misma carpeta que su escena asociada para facilitar el acceso.

4. **Actualiza las Referencias**: Si mueves o renombras archivos, asegúrate de actualizar todas las referencias en el proyecto.