create schema Rochoa;

---drop schema Rochoa cascade
CREATE TABLE Rochoa.pacientes (
    id_paciente serial PRIMARY KEY,
    identificacion VARCHAR(15) UNIQUE NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    sexo CHAR(1) CHECK (sexo IN ('M','F')),
    telefono VARCHAR(20),
    email VARCHAR(150) UNIQUE,
    direccion TEXT,
    activo BOOLEAN DEFAULT TRUE,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP
);


---ESPECIALIDAD
CREATE TABLE Rochoa.especialidades (
    id_especialidad serial PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    activo BOOLEAN DEFAULT TRUE,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP
);


---MEDICOS
CREATE TABLE Rochoa.medicos (
    id_medico serial PRIMARY KEY,
    id_especialidad serial NOT NULL,
    identificacion VARCHAR(15) UNIQUE NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(150) UNIQUE,
    activo BOOLEAN DEFAULT TRUE,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP,

    CONSTRAINT fk_medico_especialidad FOREIGN KEY (id_especialidad) REFERENCES Rochoa.especialidades(id_especialidad)
);


-----(TABLAS TRANSACCIONALES)-------
---CITAS
CREATE TABLE Rochoa.citas (
    id_cita serial PRIMARY KEY,
    id_paciente serial NOT NULL,
    id_medico serial NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    estado VARCHAR(20) CHECK (estado IN ('PROGRAMADA','ATENDIDA','CANCELADA')) DEFAULT 'PROGRAMADA',
    activo BOOLEAN DEFAULT TRUE,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP,
  
    CONSTRAINT fk_cita_paciente FOREIGN KEY (id_paciente) REFERENCES Rochoa.pacientes(id_paciente),
    CONSTRAINT fk_cita_medico FOREIGN KEY (id_medico) REFERENCES Rochoa.medicos(id_medico)
);

---CONSULTAS
CREATE TABLE Rochoa.consultas (
    id_consulta serial PRIMARY KEY,
    id_cita serial NOT NULL UNIQUE,
    motivo_consulta TEXT NOT NULL,
    diagnostico TEXT,
    tratamiento TEXT,
    observaciones TEXT,
    activo BOOLEAN DEFAULT TRUE,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP,

    CONSTRAINT fk_consulta_cita FOREIGN KEY (id_cita) REFERENCES Rochoa.citas(id_cita)
);

---PAGOS
CREATE TABLE Rochoa.pagos (
    id_pago serial PRIMARY KEY,
    id_cita serial NOT NULL,
    monto NUMERIC(10,2) NOT NULL CHECK (monto > 0),
    metodo_pago VARCHAR(30) CHECK (metodo_pago IN ('EFECTIVO','TARJETA','TRANSFERENCIA')),
    activo BOOLEAN DEFAULT TRUE,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP,

    CONSTRAINT fk_pago_cita FOREIGN KEY (id_cita) REFERENCES Rochoa.citas(id_cita)
);

