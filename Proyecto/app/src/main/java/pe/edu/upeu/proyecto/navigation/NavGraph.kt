package pe.edu.upeu.proyecto.navigation

import androidx.compose.runtime.Composable
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import pe.edu.upeu.proyecto.FormScreen
import pe.edu.upeu.proyecto.OfertaListScreen


@Composable
fun NavGraph(navController: NavHostController) {
    NavHost(navController = navController, startDestination = "list_screen") {
        composable("list_screen") {
            OfertaListScreen(navController)
        }
        composable("form_screen/{ofertaId}") { backStackEntry ->
            val ofertaId = backStackEntry.arguments?.getString("ofertaId")?.toLongOrNull()
            FormScreen(navController = navController, ofertaId = ofertaId)
        }
        composable("form_screen") {
            FormScreen(navController)
        }
    }
}
