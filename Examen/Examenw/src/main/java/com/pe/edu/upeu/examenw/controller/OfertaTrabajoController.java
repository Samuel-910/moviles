package com.pe.edu.upeu.examenw.controller;

import com.pe.edu.upeu.examenw.entity.OfertaTrabajo;
import com.pe.edu.upeu.examenw.service.OfertaTrabajoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/ofertaTrabajo")
public class OfertaTrabajoController {
    @Autowired
    private OfertaTrabajoService ofertaTrabajoService;
    @GetMapping()
    public ResponseEntity<List<OfertaTrabajo>> list() {
        return ResponseEntity.ok().body(ofertaTrabajoService.listar());
    }
    @PostMapping()
    public ResponseEntity<OfertaTrabajo> save(@RequestBody OfertaTrabajo ofertaTrabajo){
        return ResponseEntity.ok(ofertaTrabajoService.guardar(ofertaTrabajo));
    }
    @PutMapping("/{id}")
    public ResponseEntity<OfertaTrabajo> actualizarOferta(@PathVariable Integer id, @RequestBody OfertaTrabajo ofertaTrabajo) {
        System.out.println("ID recibida en la solicitud PUT: " + id);
        ofertaTrabajo.setId(Long.valueOf(id));  // Aseguramos que el ID del path se establece en la entidad
        OfertaTrabajo ofertaActualizada = ofertaTrabajoService.actualizar(ofertaTrabajo);
        return ResponseEntity.ok(ofertaActualizada);
    }   
    @GetMapping("/{id}")
    public ResponseEntity<OfertaTrabajo> listById(@PathVariable(required = true) Integer id){
        return ResponseEntity.ok().body(ofertaTrabajoService.listarPorId(id).get());
    }
    @DeleteMapping("/{id}")
    public String deleteById(@PathVariable(required = true) Integer id){
        ofertaTrabajoService.eliminarPorId(id);
        return "Eliminacion Correcta";
    }
}
