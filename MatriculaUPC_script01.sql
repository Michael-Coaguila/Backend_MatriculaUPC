-- Crear la base de datos
CREATE DATABASE MatriculaUPC;
GO

-- Usar la base de datos creada
USE MatriculaUPC;
GO

-- Crear la tabla de Estudiantes con el campo de Foto
CREATE TABLE Estudiantes (
    EstudianteID INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100) NOT NULL,
    Correo NVARCHAR(100) UNIQUE NOT NULL,
	Codigo NVARCHAR(50) UNIQUE NOT NULL,
    Turno DATETIME NOT NULL, -- Turno con fecha y hora para la matrícula
    TieneDeuda BIT DEFAULT 0, -- Indica si tiene deuda
    EstaMatriculado BIT DEFAULT 0, -- Indica si está actualmente matriculado
    Foto NVARCHAR(255) -- Almacenar la ruta o URL de la foto del estudiante
);
GO

-- Crear la tabla de Usuarios (para el login)
CREATE TABLE Usuarios (
    UsuarioID INT PRIMARY KEY IDENTITY(1,1),
    EstudianteID INT FOREIGN KEY REFERENCES Estudiantes(EstudianteID) ON DELETE CASCADE, -- Eliminar usuario si se elimina el estudiante
    Correo NVARCHAR(100) UNIQUE NOT NULL,
    Contrasena NVARCHAR(255) NOT NULL, -- Usar un hash de contraseña en producción
    Rol NVARCHAR(50) DEFAULT 'Estudiante' -- Establecemos roles como 'Estudiante', 'Admin', etc.
);
GO

-- Crear la tabla de Cursos
CREATE TABLE Cursos (
    CursoID INT PRIMARY KEY IDENTITY(1,1),
    NombreCurso NVARCHAR(100) NOT NULL,
    Creditos INT NOT NULL,
    Ciclo INT NOT NULL -- Ciclo al que pertenece el curso
);
GO

-- Crear la tabla de CursosDisponibles (Relación entre Estudiantes y Cursos Disponibles)
CREATE TABLE CursosDisponibles (
    EstudianteID INT FOREIGN KEY REFERENCES Estudiantes(EstudianteID) ON DELETE CASCADE, -- Si se elimina el estudiante, eliminar sus cursos disponibles
    CursoID INT FOREIGN KEY REFERENCES Cursos(CursoID) ON DELETE CASCADE, -- Si se elimina el curso, eliminar de los cursos disponibles
    PRIMARY KEY (EstudianteID, CursoID) -- Llave compuesta para asegurar la unicidad
);
GO

-- Crear la tabla de Sedes
CREATE TABLE Sedes (
    SedeID INT PRIMARY KEY IDENTITY(1,1),
    NombreSede NVARCHAR(100) NOT NULL
);
GO

-- Crear la tabla de Docentes
CREATE TABLE Docentes (
    DocenteID INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100) NOT NULL,
    Correo NVARCHAR(100) UNIQUE NOT NULL
);
GO

-- Crear la tabla de Secciones
CREATE TABLE Secciones (
    SeccionID INT PRIMARY KEY IDENTITY(1,1),
    CursoID INT FOREIGN KEY REFERENCES Cursos(CursoID) ON DELETE CASCADE, -- Si se elimina el curso, eliminar las secciones correspondientes
    Seccion NVARCHAR(10) NOT NULL,
    DocenteID INT FOREIGN KEY REFERENCES Docentes(DocenteID) ON DELETE SET NULL, -- Si se elimina el docente, se puede asignar NULL
    SedeID INT FOREIGN KEY REFERENCES Sedes(SedeID) ON DELETE SET NULL, -- Si se elimina la sede, se puede asignar NULL
    VacantesOriginales INT NOT NULL, -- Cantidad de vacantes originales
    VacantesRestantes INT NOT NULL -- Cantidad de vacantes restantes
);
GO

-- Crear la tabla de Horarios
CREATE TABLE Horarios (
    HorarioID INT PRIMARY KEY IDENTITY(1,1),
    SeccionID INT FOREIGN KEY REFERENCES Secciones(SeccionID) ON DELETE CASCADE, -- Si se elimina la sección, eliminar sus horarios
    Dia NVARCHAR(10) NOT NULL,
    HoraInicio TIME NOT NULL,
    HoraFin TIME NOT NULL,
    CONSTRAINT UQ_Horarios UNIQUE (SeccionID, Dia, HoraInicio, HoraFin) -- Garantiza que no se repitan horarios para la misma sección
);
GO

-- Crear la tabla de Matriculas con validación para cursos disponibles
CREATE TABLE Matriculas (
    MatriculaID INT PRIMARY KEY IDENTITY(1,1),
    EstudianteID INT FOREIGN KEY REFERENCES Estudiantes(EstudianteID) ON DELETE CASCADE, -- Si se elimina el estudiante, eliminar la matrícula
    SeccionID INT FOREIGN KEY REFERENCES Secciones(SeccionID) ON DELETE CASCADE, -- Si se elimina la sección, eliminar la matrícula
    FechaMatricula DATETIME DEFAULT GETDATE()
);
GO



