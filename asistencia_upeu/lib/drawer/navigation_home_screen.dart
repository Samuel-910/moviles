import 'package:asistencia_upeu/theme/AppTheme.dart';
import 'package:asistencia_upeu/drawer/drawer_user_controller.dart';
import 'package:asistencia_upeu/drawer/home_drawer.dart';
import 'package:asistencia_upeu/ui/Inventario/inventario_main.dart';
import 'package:asistencia_upeu/ui/cliente/cliente_main.dart';
import 'package:asistencia_upeu/ui/file/file_upload_screen.dart';
import 'package:asistencia_upeu/ui/help_screen.dart';
import 'package:asistencia_upeu/ui/pago/pago_main.dart';
import 'package:asistencia_upeu/ui/transaccion/transaccion_main.dart';
import 'package:flutter/material.dart';

class NavigationHomeScreen extends StatefulWidget {
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget? screenView;
  DrawerIndex? drawerIndex;

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = HelpScreen();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      //color: AppTheme.themeData.primaryColor,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.themeData.primaryColor,
          //appBar: CustomAppBar(accionx: accion as Function),
          body: DrawerUserController(
            screenIndex: drawerIndex!!,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
              //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView!!,
            drawerIsOpen: (bool ) {  },
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.HOME) {
        setState(() {
          screenView = HelpScreen(); //MainPersona()
        });
      } else if (drawerIndex == DrawerIndex.Inventario) {
        setState(() {
          screenView = MainInventario();

        });
      }else if (drawerIndex == DrawerIndex.Cliente) {
        setState(() {
          screenView = MainCliente();

        });
      }else if (drawerIndex == DrawerIndex.Pago) {
        setState(() {
          screenView = MainPago();

        });
      }else if (drawerIndex == DrawerIndex.Detalle) {
        setState(() {
          screenView = MainInventario();

        });
      }else if (drawerIndex == DrawerIndex.Transaccion) {
        setState(() {
          screenView = MainTransaccion();

        });
      }else if (drawerIndex == DrawerIndex.File) {
        setState(() {
          screenView = FileUploadScreen();

        });
      } else {
        //do in your way......
      }
    }
  }
}
