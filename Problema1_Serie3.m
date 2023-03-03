# Cargar la librería de PostgreSQL
pkg load database

# Establecer la conexión con la base de datos
conn = pq_connect(setdbopts('dbname','estudiantes','host','localhost','port','5432', 'user', 'postgres', 'password', 'server'))

# Crear la tabla de estudiantes
query = "CREATE TABLE IF NOT EXISTS estudiantes (id SERIAL PRIMARY KEY, nombre VARCHAR(50) NOT NULL, edad INTEGER NOT NULL, genero VARCHAR(10) NOT NULL, direccion VARCHAR(100) NOT NULL);";
db_execute(conn, query);

# Función para agregar un nuevo estudiante
function agregarEstudiante(conn)
    nombre = input("Ingrese el nombre del estudiante: ", 's');
    edad = input("Ingrese la edad del estudiante: ");
    genero = input("Ingrese el género del estudiante (M/F): ", 's');
    direccion = input("Ingrese la dirección del estudiante: ", 's');
    
    query = sprintf("INSERT INTO estudiantes (nombre, edad, genero, direccion) 
                     VALUES ('%s', %d, '%s', '%s')", nombre, edad, genero, direccion);
    db_execute(conn, query);
    printf("Estudiante agregado correctamente.\n");
endfunction

# Función para editar la información de un estudiante existente
function editarEstudiante(conn)
    id = input("Ingrese el ID del estudiante a editar: ");
    query = sprintf("SELECT * FROM estudiantes WHERE id=%d", id);
    result = db_query(conn, query);
    
    if (numel(result.data) == 0)
        printf("No se encontró ningún estudiante con ese ID.\n");
    else
        nombre = input("Ingrese el nuevo nombre del estudiante: ", 's');
        edad = input("Ingrese la nueva edad del estudiante: ");
        genero = input("Ingrese el nuevo género del estudiante (M/F): ", 's');
        direccion = input("Ingrese la nueva dirección del estudiante: ", 's');
        
        query = sprintf("UPDATE estudiantes SET nombre='%s', edad=%d, genero='%s', direccion='%s' WHERE id=%d",nombre, edad, genero, direccion, id);
        pq_execute(conn, query);
        printf("Estudiante actualizado correctamente.\n");
    endif
endfunction

# Función para eliminar un estudiante de la base de datos
function eliminarEstudiante(conn)
    id = input("Ingrese el ID del estudiante a eliminar: ");
    query = sprintf("SELECT * FROM estudiantes WHERE id=%d", id);
    result = db_query(conn, query);
    
    if (numel(result.data) == 0)
        printf("No se encontró ningún estudiante con ese ID.\n");
    else
        query = sprintf("DELETE FROM estudiantes WHERE id=%d", id);
        db_execute(conn, query);
        printf("Estudiante eliminado correctamente.\n");
    endif
endfunction

# Función para ver el historial de estudiantes
function verHistorial(conn)
    query = "SELECT * FROM estudiantes";
    result = db_query(conn, query);
    
    if (numel(result.data) == 0)
        printf("No se encontraron estudiantes en la base de datos.\n");
    else
        printf("ID\tNombre\t\tEdad\tGénero\tDirección\n");
        printf("---------------------------------------------------------------\n");
        for i = 1:size(result.data,1)
           
