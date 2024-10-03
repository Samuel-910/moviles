package com.pe.edu.upeu.examenw.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Data
public class OfertaTrabajo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String titulo;
    private String descripcion;
    private int experiencia;
    private LocalDate fechaFin;
    private LocalDate fechaInicio;
    private String formaAca;
    private String idiomas;
    private String puesto;
    private BigDecimal salario;
    private int vacantes;
    private String estado;
}
