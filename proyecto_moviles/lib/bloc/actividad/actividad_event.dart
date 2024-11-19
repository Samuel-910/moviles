part of 'actividad_bloc.dart';

@immutable
sealed class ActividadEvent {}

class ListarActividadEvent extends ActividadEvent{
  ListarActividadEvent(){print("Evento si");}
}
class DeleteActividadEvent extends ActividadEvent{
  ActividadModelo actividad;
  DeleteActividadEvent(this.actividad);
}
class UpdateActividadEvent extends ActividadEvent{
  ActividadModelo actividad;
  UpdateActividadEvent(this.actividad);
}
class CreateActividadEvent extends ActividadEvent{
  ActividadModelo actividad;
  CreateActividadEvent(this.actividad);
}