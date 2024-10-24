package pe.edu.upeu.proyecto

import android.content.Context
import android.os.Bundle
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.navigation.NavHostController
import androidx.navigation.compose.rememberNavController
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import pe.edu.upeu.proyecto.navigation.NavGraph
import pe.edu.upeu.proyecto.ui.theme.ProyectoTheme
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.math.BigDecimal

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            ProyectoTheme {
                Surface(color = MaterialTheme.colorScheme.background) {
                    val navController = rememberNavController()
                    NavGraph(navController = navController)
                }
            }
        }
    }
}

@Composable
fun OfertaListScreen(navController: NavHostController) {
    val context = LocalContext.current
    val apiService = RetrofitClient.apiService
    val coroutineScope = rememberCoroutineScope()
    var ofertas by remember { mutableStateOf(listOf<OfertaTrabajo>()) }

    // Lanzamos una coroutine para cargar los datos de la API
    LaunchedEffect(Unit) {
        try {
            val response = withContext(Dispatchers.IO) {
                apiService.getAllOfertas().execute()
            }
            if (response.isSuccessful) {
                ofertas = response.body() ?: listOf()
            } else {
                Toast.makeText(context, "Error al cargar las ofertas: ${response.errorBody()?.string()}", Toast.LENGTH_SHORT).show()
            }
        } catch (e: Exception) {
            Toast.makeText(context, "Error de red: ${e.message ?: "desconocido"}", Toast.LENGTH_SHORT).show()
            e.printStackTrace()
        }
    }

    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text(
            text = "Lista de Ofertas de Trabajo",
            style = MaterialTheme.typography.headlineMedium,
            modifier = Modifier.padding(bottom = 16.dp)
        )
        Button(onClick = {
            navController.navigate("form_screen")
        }) {
            Text("Añadir Oferta")
        }

        Spacer(modifier = Modifier.height(16.dp))
        Divider()

        // Listado
        LazyColumn(modifier = Modifier.weight(1f)) {
            items(ofertas) { oferta ->
                OfertaItem(
                    oferta = oferta,
                    onEditClick = {
                        navController.navigate("form_screen/${oferta.id}")
                    },
                    onDeleteClick = {
                        coroutineScope.launch {
                            eliminarOferta(oferta.id, apiService, context) {
                                ofertas = ofertas.filter { it.id != oferta.id }
                            }
                        }
                    }
                )
                Divider()
            }
        }

        Spacer(modifier = Modifier.height(16.dp))
    }
}

suspend fun eliminarOferta(id: Long, apiService: ApiService, context: Context, onSuccess: () -> Unit) {
    try {
        val response = withContext(Dispatchers.IO) {
            apiService.deleteOferta(id).execute()
        }
        if (response.isSuccessful) {
            withContext(Dispatchers.Main) {
                Toast.makeText(context, "Oferta eliminada con éxito", Toast.LENGTH_SHORT).show()
                onSuccess()
            }
        } else {
            withContext(Dispatchers.Main) {
                Toast.makeText(context, "Error al eliminar la oferta", Toast.LENGTH_SHORT).show()
            }
        }
    } catch (e: Exception) {
        withContext(Dispatchers.Main) {
            Toast.makeText(context, "Fallo al conectar con el servidor", Toast.LENGTH_SHORT).show()
            e.printStackTrace()
        }
    }
}

@Composable
fun OfertaItem(oferta: OfertaTrabajo, onEditClick: () -> Unit, onDeleteClick: () -> Unit) {
    Column(modifier = Modifier.padding(8.dp)) {
        Text(text = oferta.titulo, style = MaterialTheme.typography.titleLarge)
        Text(text = oferta.descripcion)
        Text(text = "Salario: ${oferta.salario}", style = MaterialTheme.typography.bodyMedium)

        Spacer(modifier = Modifier.height(8.dp))

        Row(horizontalArrangement = Arrangement.SpaceBetween, modifier = Modifier.fillMaxWidth()) {
            Button(onClick = onEditClick) {
                Text("Editar")
            }
            Button(onClick = onDeleteClick) {
                Text("Eliminar")
            }
        }
    }
}


@Composable
fun FormScreen(navController: NavHostController, ofertaId: Long? = null) {
    // Variables de estado para los campos del formulario
    var titulo by remember { mutableStateOf("") }
    var descripcion by remember { mutableStateOf("") }
    var experiencia by remember { mutableStateOf("") }
    var fechaFin by remember { mutableStateOf("") }
    var fechaInicio by remember { mutableStateOf("") }
    var formaAca by remember { mutableStateOf("") }
    var idiomas by remember { mutableStateOf("") }
    var puesto by remember { mutableStateOf("") }
    var salario by remember { mutableStateOf("") }
    var vacantes by remember { mutableStateOf("") }
    var estado by remember { mutableStateOf("") }

    val context = LocalContext.current
    val apiService = RetrofitClient.apiService
    val coroutineScope = rememberCoroutineScope()

    LaunchedEffect(ofertaId) {
        if (ofertaId != null) {
            // Cargar datos de la oferta si se está editando
            val response = withContext(Dispatchers.IO) {
                apiService.getOfertaById(ofertaId).execute()
            }
            if (response.isSuccessful) {
                response.body()?.let { oferta ->
                    titulo = oferta.titulo
                    descripcion = oferta.descripcion
                    experiencia = oferta.experiencia.toString()
                    fechaInicio = oferta.fechaInicio
                    fechaFin = oferta.fechaFin
                    formaAca = oferta.formaAca
                    idiomas = oferta.idiomas
                    puesto = oferta.puesto
                    salario = oferta.salario.toString()
                    vacantes = oferta.vacantes.toString()
                    estado = oferta.estado
                }
            } else {
                Toast.makeText(context, "Error al cargar la oferta", Toast.LENGTH_SHORT).show()
            }
        }
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp)
            .verticalScroll(rememberScrollState())
    ) {
        Text(
            text = if (ofertaId == null) "Formulario para Nueva Oferta" else "Editar Oferta de Trabajo",
            style = MaterialTheme.typography.headlineMedium
        )
        Spacer(modifier = Modifier.height(16.dp))

        TextField(
            value = titulo,
            onValueChange = { titulo = it },
            label = { Text("Título") }
        )
        Spacer(modifier = Modifier.height(8.dp))

        TextField(
            value = descripcion,
            onValueChange = { descripcion = it },
            label = { Text("Descripción") }
        )
        Spacer(modifier = Modifier.height(8.dp))

        TextField(
            value = experiencia,
            onValueChange = { experiencia = it },
            label = { Text("Experiencia (en años)") },
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number)
        )
        Spacer(modifier = Modifier.height(8.dp))

        // Selección de fecha de inicio
        TextField(
            value = fechaInicio,
            onValueChange = { fechaInicio = it },
            label = { Text("Fecha de Inicio") },
            readOnly = true,
            modifier = Modifier.clickable {
                // Aquí podrías implementar un DatePickerDialog para seleccionar la fecha
            }
        )
        Spacer(modifier = Modifier.height(8.dp))

        // Selección de fecha de fin
        TextField(
            value = fechaFin,
            onValueChange = { fechaFin = it },
            label = { Text("Fecha de Fin") },
            readOnly = true,
            modifier = Modifier.clickable {
                // Aquí podrías implementar un DatePickerDialog para seleccionar la fecha
            }
        )
        Spacer(modifier = Modifier.height(8.dp))

        TextField(
            value = formaAca,
            onValueChange = { formaAca = it },
            label = { Text("Formación Académica") }
        )
        Spacer(modifier = Modifier.height(8.dp))

        TextField(
            value = idiomas,
            onValueChange = { idiomas = it },
            label = { Text("Idiomas") }
        )
        Spacer(modifier = Modifier.height(8.dp))

        TextField(
            value = puesto,
            onValueChange = { puesto = it },
            label = { Text("Puesto") }
        )
        Spacer(modifier = Modifier.height(8.dp))

        TextField(
            value = salario,
            onValueChange = { salario = it },
            label = { Text("Salario (en USD)") },
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number)
        )
        Spacer(modifier = Modifier.height(8.dp))

        TextField(
            value = vacantes,
            onValueChange = { vacantes = it },
            label = { Text("Vacantes") },
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number)
        )
        Spacer(modifier = Modifier.height(8.dp))

        TextField(
            value = estado,
            onValueChange = { estado = it },
            label = { Text("Estado") }
        )
        Spacer(modifier = Modifier.height(16.dp))

        // Botones en una fila (Row)
        Row(
            horizontalArrangement = Arrangement.SpaceBetween,
            modifier = Modifier.fillMaxWidth()
        ) {
            Button(onClick = {
                coroutineScope.launch {
                    val nuevaOferta = OfertaTrabajo(
                        id = ofertaId ?: 0L, // Si es null, se crea una nueva oferta
                        titulo = titulo,
                        descripcion = descripcion,
                        experiencia = experiencia.toIntOrNull() ?: 0,
                        fechaInicio = fechaInicio,
                        fechaFin = fechaFin,
                        formaAca = formaAca,
                        idiomas = idiomas,
                        puesto = puesto,
                        salario = BigDecimal(salario.toDoubleOrNull() ?: 0.0),
                        vacantes = vacantes.toIntOrNull() ?: 1,
                        estado = estado
                    )

                    if (ofertaId != null) {
                        // Actualizar oferta existente
                        apiService.updateOferta(ofertaId, nuevaOferta).enqueue(object : Callback<OfertaTrabajo> {
                            override fun onResponse(call: Call<OfertaTrabajo>, response: Response<OfertaTrabajo>) {
                                if (response.isSuccessful) {
                                    Toast.makeText(context, "Oferta actualizada con éxito", Toast.LENGTH_SHORT).show()
                                    navController.popBackStack() // Regresa a la pantalla anterior
                                } else {
                                    Toast.makeText(context, "Error al actualizar la oferta", Toast.LENGTH_SHORT).show()
                                }
                            }

                            override fun onFailure(call: Call<OfertaTrabajo>, t: Throwable) {
                                Toast.makeText(context, "Fallo al conectar con el servidor", Toast.LENGTH_SHORT).show()
                            }
                        })
                    } else {
                        // Crear nueva oferta
                        apiService.createOferta(nuevaOferta).enqueue(object : Callback<OfertaTrabajo> {
                            override fun onResponse(call: Call<OfertaTrabajo>, response: Response<OfertaTrabajo>) {
                                if (response.isSuccessful) {
                                    Toast.makeText(context, "Oferta guardada con éxito", Toast.LENGTH_SHORT).show()
                                    navController.popBackStack() // Regresa a la pantalla anterior
                                } else {
                                    Toast.makeText(context, "Error al guardar la oferta", Toast.LENGTH_SHORT).show()
                                }
                            }

                            override fun onFailure(call: Call<OfertaTrabajo>, t: Throwable) {
                                Toast.makeText(context, "Fallo al conectar con el servidor", Toast.LENGTH_SHORT).show()
                            }
                        })
                    }
                }
            }) {
                Text("Guardar Oferta")
            }

            Button(onClick = {
                navController.navigate("list_screen")
            }) {
                Text("Salir")
            }
        }
    }
}



@Preview(showBackground = true)
@Composable
fun DefaultPreview() {
    ProyectoTheme {
        val navController = rememberNavController()
        NavGraph(navController = navController)
    }
}
