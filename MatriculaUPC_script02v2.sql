-- Insertar 5 estudiantes de ejemplo con turnos de matrícula
INSERT INTO Estudiantes (Nombre, Correo, Codigo, Turno, TieneDeuda, EstaMatriculado, Foto)
VALUES 
('Michael Coaguila', 'michael.coaguila@upc.edu.pe', 'U202220780', '2024-03-15 09:00:00', 0, 1, 'https://e7.pngegg.com/pngimages/166/883/png-clipart-graduation-ceremony-student-academic-degree-graduate-university-education-toga-people-logo.png'),
('Sandra Perez', 'sandra.perez@upc.edu.pe', 'U123456789', '2024-03-15 10:00:00', 0, 0, 'https://e7.pngegg.com/pngimages/572/301/png-clipart-graduation-ceremony-graduate-university-square-academic-cap-computer-icons-academic-degree-school-logo-graduation-ceremony.png'),
('Luis Gutierrez', 'luis.gutierrez@upc.edu.pe', 'U987654321', '2024-03-16 09:30:00', 1, 0, 'https://e7.pngegg.com/pngimages/166/883/png-clipart-graduation-ceremony-student-academic-degree-graduate-university-education-toga-people-logo.png'),
('Ana Ramirez', 'ana.ramirez@upc.edu.pe', 'U135798642', '2024-03-16 11:00:00', 0, 0, 'https://e7.pngegg.com/pngimages/572/301/png-clipart-graduation-ceremony-graduate-university-square-academic-cap-computer-icons-academic-degree-school-logo-graduation-ceremony.png'),
('Carlos Medina', 'carlos.medina@upc.edu.pe', 'U975312468', '2024-03-16 08:30:00', 1, 0, 'https://e7.pngegg.com/pngimages/166/883/png-clipart-graduation-ceremony-student-academic-degree-graduate-university-education-toga-people-logo.png');
GO

-- Insertar usuarios con hash de contraseñas para los estudiantes
INSERT INTO Usuarios (EstudianteID, Correo, Contrasena, Rol)
VALUES 
(1, 'michael.coaguila@upc.edu.pe', '1234', 'Estudiante'),
(2, 'sandra.perez@upc.edu.pe', '1234', 'Estudiante'),
(3, 'luis.gutierrez@upc.edu.pe', '1234', 'Estudiante'),
(4, 'ana.ramirez@upc.edu.pe', '1234', 'Estudiante'),
(5, 'carlos.medina@upc.edu.pe', '1234', 'Estudiante');
GO

-- Insertar sedes
INSERT INTO Sedes (NombreSede)
VALUES ('Campus Monterrico'), ('Campus San Isidro'), ('Campus Villa');
GO

-- Insertar docentes
INSERT INTO Docentes (Nombre, Correo)
VALUES 
('Hilario Padilla', 'hilario.padilla@upc.edu.pe'),
('Ana Perez', 'ana.perez@upc.edu.pe'),
('David Gonzales', 'david.gonzales@upc.edu.pe'),
('Carmen Soto', 'carmen.soto@upc.edu.pe'),
('Roberto Mendez', 'roberto.mendez@upc.edu.pe'),
('Lucia Ortega', 'lucia.ortega@upc.edu.pe'),
('Carlos Rojas', 'carlos.rojas@upc.edu.pe');
GO

-- Insertar cursos para Ingeniería de Sistemas (10 ciclos)
INSERT INTO Cursos (NombreCurso, Creditos, Ciclo)
VALUES 
('Algoritmos y Estructuras de Datos', 4, 3),
('Base de Datos I', 4, 4),
('Cálculo Diferencial', 3, 1),
('Fundamentos de Programación', 4, 1),
('Ingeniería de Software I', 4, 5),
('Inteligencia Artificial', 3, 7),
('Sistemas Operativos', 4, 4),
('Redes de Computadoras', 4, 6),
('Diseño de Sistemas', 4, 5),
('Cálculo Integral', 3, 2),
('Análisis de Algoritmos', 4, 6),
('Seguridad Informática', 3, 8),
('Arquitectura de Computadoras', 4, 6),
('Ingeniería de Requisitos', 4, 4),
('Gestión de Proyectos de TI', 3, 8),
('Big Data', 4, 9),
('Computación en la Nube', 4, 9),
('Tesis I', 5, 10),
('Tesis II', 5, 10),
('Blockchain', 4, 9);
GO

-- Insertar secciones y relacionarlas con cursos y docentes
INSERT INTO Secciones (CursoID, Seccion, DocenteID, SedeID, VacantesOriginales, VacantesRestantes)
VALUES 
(1, 'A32B', 1, 1, 30, 30), 
(2, 'B21A', 2, 2, 40, 40), 
(3, 'C12B', 3, 3, 35, 35),
(4, 'A21B', 4, 1, 25, 25), 
(5, 'B33C', 5, 2, 30, 30),
(6, 'A34B', 3, 2, 40, 40),
(7, 'A12A', 5, 1, 30, 30), 
(8, 'B41B', 4, 3, 35, 35),
(9, 'A43A', 1, 2, 30, 30),
(10, 'C12D', 2, 3, 25, 25),
(11, 'A34C', 4, 1, 30, 30), 
(12, 'B24D', 5, 2, 35, 35),
(13, 'C12E', 6, 3, 20, 20),
(14, 'A32F', 7, 2, 30, 30),
(15, 'B21G', 1, 1, 40, 40),
--
(16, 'A51A', 7, 1, 30, 30), -- Big Data
(17, 'B52B', 1, 3, 35, 35), -- Computación en la Nube
(18, 'A12D', 2, 2, 30, 30), -- Tesis I
(19, 'B24F', 3, 1, 35, 35), -- Tesis II
(20, 'C12F', 4, 2, 30, 30); -- Blockchain
GO

-- Insertar horarios para las secciones
INSERT INTO Horarios (SeccionID, Dia, HoraInicio, HoraFin)
VALUES 
(1, 'Lun', '10:00', '12:00'), 
(2, 'Mar', '08:00', '10:00'), 
(3, 'Mié', '14:00', '16:00'), 
(4, 'Jue', '07:00', '09:00'), 
(5, 'Lun', '12:00', '14:00'), 
(6, 'Vie', '11:00', '13:00'), 
(7, 'Mar', '15:00', '17:00'), 
(8, 'Jue', '09:00', '11:00'), 
(9, 'Mié', '10:00', '12:00'), 
(10, 'Vie', '08:00', '10:00'), 
(11, 'Lun', '14:00', '16:00'), 
(12, 'Mar', '10:00', '12:00'), 
(13, 'Mié', '13:00', '15:00'), 
(14, 'Jue', '12:00', '14:00'), 
(15, 'Vie', '16:00', '18:00'),
--
(16, 'Mar', '12:00', '14:00'),  -- Big Data
(17, 'Mié', '09:00', '11:00'),  -- Computación en la Nube
(18, 'Jue', '13:00', '15:00'),  -- Tesis I
(19, 'Vie', '08:00', '10:00'),  -- Tesis II
(20, 'Lun', '16:00', '18:00');  -- Blockchain
GO

-- Insertar cursos disponibles para los estudiantes de acuerdo a su ciclo
INSERT INTO CursosDisponibles (EstudianteID, CursoID)
VALUES 
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), -- Michael Coaguila (Ciclos 1-4)
(2, 5), (2, 6), (2, 7), (2, 8), (2, 9), (2, 10), (2, 19), -- Sandra Perez (Ciclos 5-6)
(3, 8), (3, 9), (3, 10), (3, 11), (3, 12), (3, 13), -- Luis Gutierrez (Ciclos 7-8)
(4, 11), (4, 12), (4, 13), (4, 14), (4, 15), (4, 16), -- Ana Ramirez (Ciclos 8-9)
(5, 14), (5, 15), (5, 16), (5, 17), (5, 18), (5, 19); -- Carlos Medina (Ciclos 9-10)
GO

-- Insertar matrículas de ejemplo
INSERT INTO Matriculas (EstudianteID, SeccionID)
VALUES 
(1, 1), (1, 2); -- Michael Coaguila
--(2, 5), (2, 6), -- Sandra Perez
--(3, 7), (3, 8), -- Luis Gutierrez
--(4, 9), (4, 10), -- Ana Ramirez
--(5, 11), (5, 12); -- Carlos Medina
GO
