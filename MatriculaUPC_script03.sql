-- Autenticar Usuario
CREATE PROCEDURE sp_AuthUsuario
    @Correo NVARCHAR(100),
    @Contrasena NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si las credenciales son válidas
    IF EXISTS (SELECT 1 FROM Usuarios WHERE Correo = @Correo AND Contrasena = @Contrasena)
    BEGIN
        -- Devolver el EstudianteID y la información básica del estudiante
        SELECT E.EstudianteID, E.Nombre, E.Codigo, E.Turno, E.TieneDeuda, E.EstaMatriculado, E.Foto
        FROM Usuarios U
        INNER JOIN Estudiantes E ON U.EstudianteID = E.EstudianteID
        WHERE U.Correo = @Correo;
    END
    ELSE
    BEGIN
        RAISERROR('Correo o contraseña incorrectos.', 16, 1);
    END
END
GO

-- Obtener información de todos los estudiantes
CREATE PROCEDURE sp_GetTodosEstudiantes
AS
BEGIN
    SET NOCOUNT ON;

    -- Obtener todos los estudiantes con su información básica
    SELECT 
        E.EstudianteID,
        E.Nombre,
		E.Codigo,
        U.Correo,
        E.Turno,
        E.TieneDeuda,
        E.EstaMatriculado,
		E.Foto
    FROM 
        Estudiantes E
    INNER JOIN 
        Usuarios U ON E.EstudianteID = U.EstudianteID;
END
GO


-- Procedimiento para obtener los datos del estudiante a partir de su EstudianteID
CREATE PROCEDURE sp_GetDatosEstudiante
    @EstudianteID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Obtener los datos del estudiante con su EstudianteID
    SELECT 
        E.EstudianteID,
        E.Nombre,
		E.Codigo,
        U.Correo,
        E.Turno,
        E.TieneDeuda,
        E.EstaMatriculado,
		E.Foto
    FROM 
        Estudiantes E
    INNER JOIN 
        Usuarios U ON E.EstudianteID = U.EstudianteID
    WHERE 
        E.EstudianteID = @EstudianteID;
END
GO


-- Procedimiento para obtener los cursos disponibles para un estudiante a partir de su EstudianteID
CREATE PROCEDURE sp_GetCursosDisponiblesPorEstudiante
    @EstudianteID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Obtener los cursos disponibles para un estudiante
    SELECT 
        C.CursoID,
        C.NombreCurso,
        C.Creditos,
        C.Ciclo
    FROM 
        Cursos C
    INNER JOIN 
        CursosDisponibles CD ON C.CursoID = CD.CursoID
    WHERE 
        CD.EstudianteID = @EstudianteID;
END
GO


--  Procedimiento para obtener las secciones de un curso a partir de su CursoID
CREATE PROCEDURE sp_GetSeccionesPorCurso
    @CursoID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Obtener las secciones para un curso específico junto con el nombre del docente y la sede
    SELECT 
        S.SeccionID,
        S.Seccion,
        D.Nombre AS Docente,          -- Obtener el nombre del docente desde la tabla Docentes
        SD.NombreSede AS Sede,        -- Obtener el nombre de la sede desde la tabla Sedes
        S.VacantesOriginales,
        S.VacantesRestantes
    FROM 
        Secciones S
    LEFT JOIN 
        Docentes D ON S.DocenteID = D.DocenteID -- Unir con la tabla Docentes
    LEFT JOIN 
        Sedes SD ON S.SedeID = SD.SedeID        -- Unir con la tabla Sedes
    WHERE 
        S.CursoID = @CursoID;
END
GO



-- Procedimiento para obtener el horario de una sección a partir de su SeccionID
CREATE PROCEDURE sp_GetHorarioPorSeccion
    @SeccionID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Obtener el horario para una sección específica
    SELECT 
        H.Dia,
        H.HoraInicio,
        H.HoraFin
    FROM 
        Horarios H
    WHERE 
        H.SeccionID = @SeccionID;
END
GO


-- Procedimiento almacenado para obtener los cursos matriculados de un estudiante
CREATE PROCEDURE sp_GetCursosMatriculadosPorEstudiante
    @EstudianteID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Obtener los cursos matriculados para el estudiante
    SELECT 
        C.CursoID,
        C.NombreCurso,
        S.Seccion,
        D.Nombre AS Docente,
        SD.NombreSede AS Sede
    FROM 
        Matriculas M
    INNER JOIN 
        Secciones S ON M.SeccionID = S.SeccionID
    INNER JOIN 
        Cursos C ON S.CursoID = C.CursoID
    LEFT JOIN 
        Docentes D ON S.DocenteID = D.DocenteID
    LEFT JOIN 
        Sedes SD ON S.SedeID = SD.SedeID
    WHERE 
        M.EstudianteID = @EstudianteID;
END
GO


-- Procedimiento almacenado para obtener el horario de un curso a partir de su CursoID
CREATE PROCEDURE sp_GetHorarioPorCurso
    @CursoID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Obtener los horarios para las secciones de un curso específico
    SELECT 
        H.Dia,
        H.HoraInicio,
        H.HoraFin
    FROM 
        Secciones S
    INNER JOIN 
        Horarios H ON S.SeccionID = H.SeccionID
    WHERE 
        S.CursoID = @CursoID;
END
GO


--
CREATE PROCEDURE sp_RegistrarMatricula
    @EstudianteID INT,
    @SeccionID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Iniciar la transacción
        BEGIN TRANSACTION;

        -- Comprobar si el estudiante ya está matriculado en la misma sección
        IF EXISTS (SELECT 1 FROM Matriculas WHERE EstudianteID = @EstudianteID AND SeccionID = @SeccionID)
        BEGIN
            PRINT 'El estudiante ya está matriculado en esta sección. Se omite la actualización de vacantes.';

            -- Asegurarse de que la variable EstaMatriculado esté en true
            UPDATE Estudiantes
            SET EstaMatriculado = 1
            WHERE EstudianteID = @EstudianteID;

            -- Finalizar la transacción y salir
            COMMIT TRANSACTION;
            RETURN;
        END

        -- Verificar y actualizar las vacantes restantes en la sección en una sola operación
        UPDATE Secciones
        SET VacantesRestantes = VacantesRestantes - 1
        WHERE SeccionID = @SeccionID AND VacantesRestantes > 0;

        -- Verificar si la actualización afectó alguna fila (si no, es porque no hay vacantes)
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No hay vacantes disponibles en esta sección.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Insertar la matrícula en la tabla Matriculas
        INSERT INTO Matriculas (EstudianteID, SeccionID, FechaMatricula)
        VALUES (@EstudianteID, @SeccionID, GETDATE());

        -- Actualizar la variable EstaMatriculado a true en la tabla Estudiantes
        UPDATE Estudiantes
        SET EstaMatriculado = 1
        WHERE EstudianteID = @EstudianteID;

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        -- Mensaje de confirmación
        PRINT 'Matrícula registrada con éxito';

    END TRY
    BEGIN CATCH
        -- Si ocurre un error, revertir todas las operaciones
        ROLLBACK TRANSACTION;

        -- Mostrar el error
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
END
GO


-- 
CREATE PROCEDURE sp_GetDatosEstudiantePorID
    @EstudianteID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Selecciona todos los datos solicitados del estudiante basado en su ID
    SELECT 
        E.EstudianteID,
        E.Nombre,
        E.Codigo,
        E.Correo,
        E.Turno,
        E.TieneDeuda,
        E.EstaMatriculado,
        E.Foto
    FROM 
        Estudiantes E
    WHERE 
        E.EstudianteID = @EstudianteID;
END
GO
