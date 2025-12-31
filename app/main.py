import mysql.connector
import os
import time
from sys import exit

def conectar_bd():
    """Conexión robusta a MySQL en Docker"""
    while True:
        try:
            conn = mysql.connector.connect(
                host=os.getenv("DB_HOST", "db"),
                user=os.getenv("DB_USER", "root"),
                password=os.getenv("DB_PASSWORD", "root"),
                database=os.getenv("DB_NAME", "sillas_mesas_hernandez")
            )
            return conn
        except mysql.connector.Error:
            print("Esperando conexión con MySQL...")
            time.sleep(3)

def imprimir_tabla(cursor):
    """Muestra los resultados de forma tabular limpia"""
    columnas = [i[0] for i in cursor.description]
    filas = cursor.fetchall()
    if not filas:
        print("\n\033[1;31m[!] Resultado vacío: No se encontraron registros que cumplan los criterios.\033[0m")
        return
    
    print("\n" + "-" * (len(columnas) * 22))
    print(" | ".join(col.center(20) for col in columnas))
    print("-" * (len(columnas) * 22))
    for fila in filas:
        print(" | ".join(str(val).center(20) for val in fila))
    print("-" * (len(columnas) * 22))

def ejecutar_y_mostrar(conn, consulta_dict, num_actual, total):
    """Interfaz visual de cada consulta con contador"""
    os.system('clear' if os.name == 'posix' else 'cls')
    
    print(f"\033[1;34m{'='*85}\033[0m")
    print(f"\033[1;32mCONSULTA [{num_actual}/{total}]: {consulta_dict['t']}\033[0m")
    print(f"\033[1;37mCategoría: {consulta_dict['tp']}\033[0m")
    print(f"\033[1;34m{'='*85}\033[0m")
    print(f"\033[1;33mÁlgebra Relacional (AR):\033[0m\n   {consulta_dict['ar']}")
    print(f"\n\033[1;33mCálculo Relacional (CRT):\033[0m\n   {consulta_dict['crt']}")
    print(f"\n\033[1;33mSQL:\033[0m\n   {consulta_dict['sql']}")
    print(f"\033[1;34m{'='*85}\033[0m")
    
    input("\nPresione ENTER para ejecutar y ver resultados...")
    
    cursor = conn.cursor()
    try:
        cursor.execute(consulta_dict['sql'])
        imprimir_tabla(cursor)
    except mysql.connector.Error as err:
        print(f"\033[1;31mError en SQL: {err}\033[0m")
    finally:
        cursor.close()
    
    input(f"\n\033[1;36m[Siguiente: {num_actual+1 if num_actual < total else 'Fin'}] Presione ENTER para continuar...\033[0m")

# --- DEFINICIÓN DE TODAS LAS CONSULTAS (1 A 20) ---

C_BASICOS = [
    {"t": "Artículos con daños registrados", "tp": "P7: Selección (σ)", "ar": "σ_{cantidadDanada > 0}(Articulo)", "crt": "{t | t ∈ Articulo ∧ t.cantidadDanada > 0}", "sql": "SELECT nombre, cantidadDanada FROM Articulo WHERE cantidadDanada > 0"},
    {"t": "Datos fiscales de empresas", "tp": "P7: Proyección (π)", "ar": "π_{razonSocial, RFC}(ClienteEmpresa)", "crt": "{<r, f> | ∃id, c (<id, r, f, c> ∈ ClienteEmpresa)}", "sql": "SELECT razonSocial, RFC FROM ClienteEmpresa"},
    {"t": "Lista unificada de contactos", "tp": "P7: Unión (∪)", "ar": "π_{nombre}(Cliente) ∪ π_{contacto}(ClienteEmpresa)", "crt": "{t | ∃c(t=c.nom) ∨ ∃e(t=e.con)}", "sql": "SELECT nombre FROM Cliente UNION SELECT contactoEmpresa FROM ClienteEmpresa"},
    {"t": "Clientes particulares contactables", "tp": "P7: Intersección (∩)", "ar": "π_{id}(Particular) ∩ π_{id}(Telefono)", "crt": "{t | t ∈ Part. ∧ ∃tel ∈ Tel (t.id = tel.id)}", "sql": "SELECT idCliente FROM ClienteParticular WHERE idCliente IN (SELECT idCliente FROM Telefono)"},
    {"t": "Artículos sin pedidos", "tp": "P7: Diferencia (-)", "ar": "π_{id}(Articulo) - π_{id}(DetallePedido)", "crt": "{t | t ∈ Articulo ∧ ¬(∃d ∈ Detalle (d.idArt = t.idArt))}", "sql": "SELECT idArticulo, nombre FROM Articulo WHERE idArticulo NOT IN (SELECT idArticulo FROM DetallePedido)"}
]

C_REUNIONES = [
    {"t": "Nombre y monto de pedidos", "tp": "P8: Inner Join (⨝)", "ar": "Cliente ⨝ Pedido", "crt": "{t | ∃c,p (c.id=p.id ∧ t.nom=c.nom ∧ t.mon=p.mon)}", "sql": "SELECT c.nombre, p.montoTotal FROM Cliente c JOIN Pedido p ON c.idCliente = p.idCliente"},
    {"t": "Inventario total y sus rentas", "tp": "P8: Left Join (⟕)", "ar": "Articulo ⟕ DetallePedido", "crt": "N/A (Operador Extendido)", "sql": "SELECT a.nombre, dp.cantidad FROM Articulo a LEFT JOIN DetallePedido dp ON a.idArticulo = dp.idArticulo"},
    {"t": "Paquetes y Artículos (Combinatoria)", "tp": "P8: Producto (×)", "ar": "Paquete × Articulo", "crt": "{<p, a> | p ∈ Paquete ∧ a ∈ Articulo}", "sql": "SELECT p.nombre as Paquete, a.nombre as Articulo FROM Paquete p CROSS JOIN Articulo a LIMIT 10"},
    {"t": "Relación Pedido-Pago", "tp": "P8: Natural Join (*)", "ar": "Pedido * Pago", "crt": "{t | ∃p, pag (p.id=pag.id ∧ t=p+pag)}", "sql": "SELECT * FROM Pedido NATURAL JOIN Pago"},
    {"t": "Rastreo: Cliente -> Mueble", "tp": "P8: Multi-Join", "ar": "Cliente ⨝ Pedido ⨝ Detalle ⨝ Articulo", "crt": "{t | ...}", "sql": "SELECT c.nombre, a.nombre as Mueble FROM Cliente c JOIN Pedido p ON c.idCliente = p.idCliente JOIN DetallePedido dp ON p.idPedido = dp.idPedido JOIN Articulo a ON dp.idArticulo = a.idArticulo"}
]

C_AGREGACION = [
    {"t": "Conteo por estado físico", "tp": "P8: Agrupación (γ)", "ar": "_{estado}γ_{COUNT(id)}(Articulo)", "crt": "N/A", "sql": "SELECT estado, COUNT(*) as Total FROM Articulo GROUP BY estado"},
    {"t": "Recaudación por Pedido", "tp": "P8: Suma (SUM)", "ar": "_{id}γ_{SUM(monto)}(Pago)", "crt": "N/A", "sql": "SELECT idPedido, SUM(monto) as Pagado FROM Pago GROUP BY idPedido"},
    {"t": "Precio promedio de rentas", "tp": "P8: Promedio (AVG)", "ar": "γ_{AVG(costo)}(Articulo)", "crt": "N/A", "sql": "SELECT AVG(costoRenta) FROM Articulo"},
    {"t": "Valor del pedido máximo", "tp": "P8: Máximo (MAX)", "ar": "γ_{MAX(monto)}(Pedido)", "crt": "N/A", "sql": "SELECT MAX(montoTotal) FROM Pedido"},
    {"t": "Clientes frecuentes (>2 pedidos)", "tp": "P8: Having", "ar": "σ_{count>2}(γ_{count}(Pedido))", "crt": "N/A", "sql": "SELECT idCliente, COUNT(*) FROM Pedido GROUP BY idCliente HAVING COUNT(*) > 2"}
]

C_AVANZADOS = [
    {"t": "CLIENTES QUE RENTARON TODO", "tp": "P8/9: División (÷)", "ar": "Rentados ÷ Catálogo", "crt": "{c | c ∈ Cliente ∧ ∀a ∈ Art (Rentó(c,a))}", "sql": "SELECT nombre FROM Cliente c WHERE NOT EXISTS (SELECT a.idArticulo FROM Articulo a WHERE NOT EXISTS (SELECT dp.idArticulo FROM DetallePedido dp JOIN Pedido p ON dp.idPedido = p.idPedido WHERE p.idCliente = c.idCliente AND dp.idArticulo = a.idArticulo))"},
    {"t": "Paquetes con todos los accesorios", "tp": "P8/9: División (÷)", "ar": "PaqArt ÷ Accesorios", "crt": "{p | ∀a ∈ Acc (a ∈ p)}", "sql": "SELECT nombre FROM Paquete pq WHERE NOT EXISTS (SELECT ac.idArticulo FROM Accesorio ac WHERE NOT EXISTS (SELECT pa.idArticulo FROM PaqueteArticulo pa WHERE pa.idPaquete = pq.idPaquete AND pa.idArticulo = ac.idArticulo))"},
    {"t": "Pedidos sin artículos económicos", "tp": "P9: Cálculo (∀)", "ar": "N/A", "crt": "{p | ∀dp (dp ∈ p ⇒ costo > 15)}", "sql": "SELECT idPedido FROM Pedido p WHERE NOT EXISTS (SELECT * FROM DetallePedido dp JOIN Articulo a ON dp.idArticulo = a.idArticulo WHERE dp.idPedido = p.idPedido AND a.costoRenta <= 15)"},
    {"t": "Clientes con Pagos Altos", "tp": "P9: Cálculo (∃)", "ar": "N/A", "crt": "{c | ∃p, ∃pag (p.cl=c.id ∧ pag.p=p.id ∧ pag.m > 5000)}", "sql": "SELECT DISTINCT c.nombre FROM Cliente c JOIN Pedido p ON c.idCliente = p.idCliente JOIN Pago pag ON p.idPedido = pag.idPedido WHERE pag.monto > 5000"},
    {"t": "Clientes que rentaron todas las Sillas", "tp": "P9: División (÷)", "ar": "Rentados ÷ Sillas", "crt": "{c | ∀s ∈ Sillas (c rentó s)}", "sql": "SELECT c.nombre FROM Cliente c WHERE NOT EXISTS (SELECT s.idArticulo FROM Silla s WHERE NOT EXISTS (SELECT dp.idArticulo FROM DetallePedido dp JOIN Pedido p ON dp.idPedido = p.idPedido WHERE p.idCliente = c.idCliente AND dp.idArticulo = s.idArticulo))"}
]

TOTAL_CONSULTAS = C_BASICOS + C_REUNIONES + C_AGREGACION + C_AVANZADOS

# --- LÓGICA DEL MENÚ ---

def menu():
    conexion = conectar_bd()
    while True:
        os.system('clear' if os.name == 'posix' else 'cls')
        print("\033[1;36m")
        print("╔══════════════════════════════════════════════════════════════╗")
        print("║          SILLAS Y MESAS HERNÁNDEZ - MENÚ INTERACTIVO         ║")
        print("╚══════════════════════════════════════════════════════════════╝\033[0m")
        print(" 1. Bloque Práctica 7: Básicas (1 - 5)")
        print(" 2. Bloque Práctica 8: Joins y Agregación (6 - 15)")
        print(" 3. Bloque Práctica 9: División y Cálculo (16 - 20)")
        print(" 4. EJECUTAR LAS 20 CONSULTAS (Secuencial)")
        print(" 0. Salir")
        
        opc = input("\n\033[1;32mSeleccione una opción:\033[0m ")
        
        if opc == "1":
            for i, c in enumerate(C_BASICOS, 1): ejecutar_y_mostrar(conexion, c, i, 5)
        elif opc == "2":
            for i, c in enumerate(C_REUNIONES + C_AGREGACION, 1): ejecutar_y_mostrar(conexion, c, i, 10)
        elif opc == "3":
            for i, c in enumerate(C_AVANZADOS, 1): ejecutar_y_mostrar(conexion, c, i, 5)
        elif opc == "4":
            for i, c in enumerate(TOTAL_CONSULTAS, 1): ejecutar_y_mostrar(conexion, c, i, 20)
        elif opc == "0":
            conexion.close()
            print("\n Saliendo...")
            exit()

if __name__ == "__main__":
    menu()