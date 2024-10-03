package com.pe.edu.upeu.examenw.service;

import com.pe.edu.upeu.examenw.entity.OfertaTrabajo;

import java.util.List;
import java.util.Optional;

public interface OfertaTrabajoService {
    public List<OfertaTrabajo> listar();
    public OfertaTrabajo guardar(OfertaTrabajo ofertaTrabajo);
    public OfertaTrabajo actualizar(OfertaTrabajo ofertaTrabajo);
    public Optional<OfertaTrabajo> listarPorId(Integer id);
    public void eliminarPorId(Integer id);

}
