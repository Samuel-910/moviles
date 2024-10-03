package com.pe.edu.upeu.examenw.service.impl;

import com.pe.edu.upeu.examenw.entity.OfertaTrabajo;
import com.pe.edu.upeu.examenw.repository.OfertaTrabajoRepository;
import com.pe.edu.upeu.examenw.service.OfertaTrabajoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class OfertaTrabajoServiceImpl implements OfertaTrabajoService {
    @Autowired
    private OfertaTrabajoRepository ofertaTrabajoRepository;
    @Override
    public List<OfertaTrabajo> listar() {
        return ofertaTrabajoRepository.findAll();
    }
    @Override
    public OfertaTrabajo guardar(OfertaTrabajo ofertaTrabajo) {
        return ofertaTrabajoRepository.save(ofertaTrabajo);
    }
    @Override
    public OfertaTrabajo actualizar(OfertaTrabajo ofertaTrabajo) {
        // Verificar si la oferta ya existe en la base de datos
        Optional<OfertaTrabajo> existingOferta = ofertaTrabajoRepository.findById(Math.toIntExact(ofertaTrabajo.getId()));
        if (existingOferta.isPresent()) {
            OfertaTrabajo ofertaToUpdate = existingOferta.get();
            // Actualizar los campos necesarios
            ofertaToUpdate.setTitulo(ofertaTrabajo.getTitulo());
            ofertaToUpdate.setDescripcion(ofertaTrabajo.getDescripcion());
            ofertaToUpdate.setExperiencia(ofertaTrabajo.getExperiencia());
            ofertaToUpdate.setFechaInicio(ofertaTrabajo.getFechaInicio());
            ofertaToUpdate.setFechaFin(ofertaTrabajo.getFechaFin());
            ofertaToUpdate.setFormaAca(ofertaTrabajo.getFormaAca());
            ofertaToUpdate.setIdiomas(ofertaTrabajo.getIdiomas());
            ofertaToUpdate.setPuesto(ofertaTrabajo.getPuesto());
            ofertaToUpdate.setSalario(ofertaTrabajo.getSalario());
            ofertaToUpdate.setVacantes(ofertaTrabajo.getVacantes());
            ofertaToUpdate.setEstado(ofertaTrabajo.getEstado());
            // Guardar los cambios
            return ofertaTrabajoRepository.save(ofertaToUpdate);
        } else {
            throw new RuntimeException("Oferta no encontrada con el ID: " + ofertaTrabajo.getId());
        }
    }
    @Override
    public Optional<OfertaTrabajo> listarPorId(Integer id) {
        return ofertaTrabajoRepository.findById(id);
    }
    @Override
    public void eliminarPorId(Integer id) {
        ofertaTrabajoRepository.deleteById(id);
    }
}
