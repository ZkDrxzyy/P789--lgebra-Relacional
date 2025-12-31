# Prácticas 7, 8 y 9.- "Operaciones del Álgebra Relacional"
# Base de Datos: Sillas y Mesas Hernández
## **Autores:** 
- González González Erick Emiliano
- De La Rosa Hernández Tania


Curso: Bases de Datos

Fecha: Enero 2026


--------------------------------------------------------------------

Este proyecto implementa una solución integral bajo la **Modalidad B (Despliegue Inmediato con Docker)**. Consiste en un sistema de gestión para una empresa de renta de mobiliario, permitiendo la ejecución de 20 consultas complejas que demuestran la equivalencia entre el Álgebra Relacional, el Cálculo Relacional y SQL.

---

## 🧱 Estructura del proyecto
```bash
Práctica789/
│
├── app/                    # Código fuente de la aplicación
│   ├── main.py             # Menú interactivo y lógica de consultas
│   └── requirements.txt    # Dependencias de Python (mysql-connector)
│
├── database/               # Scripts de base de datos
│   └── init.sql            # Definición de tablas y poblado (>120 registros)
│
├── screenshots/            # Capturas de funcionamiento
│
├── Dockerfile              # Configuración de imagen para la App
└── docker-compose.yml      # Orquestador de servicios (App + DB)

```
---

## 🚀 Instrucciones de Despliegue

Para ejecutar este proyecto, solo es necesario tener instalado **Docker** y **Docker Compose**. No se requiere instalar Python ni MySQL localmente.

1. **Clonar el repositorio:**
   ```bash
   git clone <https://github.com/ZkDrxzyy/P789--lgebra-Relacional>
   cd Práctica789
   ```
   
2. **Levantar el entorno:**
  ```bash
  docker-compose up --build -d
  ```

3. **Acceder al Menú Interactivo:**
(En otra terminal)
  ```bash
  docker attach app_consultas
  ```
(Presione Enter una vez dentro para visualizar el menú).

---

## 🛠️ Tecnologías Utilizadas
* Base de Datos: MySQL 8.0 (Contenedorizado).
* Lenguaje: Python 3.10 (Contenedorizado).
* Orquestación: Docker Compose.
* Volúmenes: Carga automática de init.sql con más de 120 registros (Caso Integrador).

---

## 📊 Contenido de las Prácticas

1. **Práctica 7: Operadores Básicos**

Ejecución de operaciones fundamentales de la teoría de conjuntos y el álgebra relacional:
* Selección ($\sigma$): Filtrado de tuplas bajo condiciones específicas.
* Proyección ($\pi$): Selección de atributos relevantes.
* Unión, Intersección y Diferencia ($\cup, \cap, -$): Manipulación de conjuntos de datos.
<br></br>

2. **Práctica 8: Reuniones y Agregación**

Consultas que involucran la relación entre múltiples tablas:
* Inner Join, Left Join y Natural Join.
* Funciones de Agregación: **SUM**, **AVG**, **COUNT**, **MAX**.
* Agrupamiento: Uso de **GROUP BY** y filtros de grupo con **HAVING**.
<br></br>

3. **Práctica 9: Equivalencia y Cálculo Relacional**

Demostración de la potencia del lenguaje mediante:
* División Relacional ($\div$): Consultas de cuantificación universal (ej. Clientes que rentaron TODOS los artículos).
* Cálculo Relacional de Tuplas (CRT): Expresiones formales con cuantificadores existenciales ($\exists$) y universales ($\forall$).

---

## 📸 Capturas de Funcionamiento

![image alt](https://github.com/ZkDrxzyy/P789--lgebra-Relacional/blob/f23e40821bfdeba950c18dc881dba5263334635b/screenshots/Captura%20de%20pantalla%202025-12-31%20150716.png)

![image alt](https://github.com/ZkDrxzyy/P789--lgebra-Relacional/blob/f23e40821bfdeba950c18dc881dba5263334635b/screenshots/Captura%20de%20pantalla%202025-12-31%20150741.png)

### ⚠️ Nota importante: Todas las expresiones en álgebra/ cálculos correspondientes a cada consulta se muestran e imprimen dentro de la terminal al ejecutar el main.py, por lo que no se incluyen textualmente en este documento.

---
*Proyecto académico — 2026-1 3CV5 Bases de datos*
