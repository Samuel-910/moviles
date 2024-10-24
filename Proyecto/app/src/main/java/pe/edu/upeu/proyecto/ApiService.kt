package pe.edu.upeu.proyecto

import retrofit2.Call
import retrofit2.http.*

interface ApiService {

    @GET("ofertaTrabajo")
    fun getAllOfertas(): Call<List<OfertaTrabajo>>

    @GET("ofertaTrabajo/{id}")
    fun getOfertaById(@Path("id") id: Long): Call<OfertaTrabajo>

    @POST("ofertaTrabajo")
    fun createOferta(@Body oferta: OfertaTrabajo): Call<OfertaTrabajo>

    @PUT("ofertaTrabajo/{id}")
    fun updateOferta(@Path("id") id: Long, @Body oferta: OfertaTrabajo): Call<OfertaTrabajo>

    @DELETE("ofertaTrabajo/{id}")
    fun deleteOferta(@Path("id") id: Long): Call<Void>
}
