import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Términos y condiciones',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.pink,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 9.0,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Text(
                  '''Terminos y condiciones ManaWork.
            
- Este sistema gestiona actividades personales.
- La información proporcionada por el usuario será tratada con confidencialidad.
- Al usar esta aplicación, aceptas las políticas de privacidad y términos de uso.
- No nos hacemos responsables de actividades no completadas por el usuario.
            
Para más información, contacta a thiagocardona7@gmail.com.
Esta aplicacion fue desarrollado en un ambiente de desarrollo seguro en la cual se implementaron
las mejores practicas de seguridad de la informacion y de desarrollo seguro
Trabajamos en base la la ley de Politica de Privacidad y seguridad en datos personales.


Si deseas conocer mas de esta ley visita: https://www.funcionpublica.gov.co/eva/gestornormativo/norma.php?i=49981 ''',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ));
  }
}
