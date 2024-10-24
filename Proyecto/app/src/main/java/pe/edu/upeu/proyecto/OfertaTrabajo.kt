package pe.edu.upeu.proyecto

import java.math.BigDecimal

data class OfertaTrabajo(
    val id: Long,
    val titulo: String,
    val descripcion: String,
    val experiencia: Int,
    val fechaFin: String,
    val fechaInicio: String,
    val formaAca: String,
    val idiomas: String,
    val puesto: String,
    val salario: BigDecimal,
    val vacantes: Int,
    val estado: String
)
