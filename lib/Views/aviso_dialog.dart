import 'package:flutter/material.dart';
import 'package:agendatarefas/models/aviso.dart';

class AvisoDialog extends StatefulWidget {
  final Aviso aviso;

// construtor para receber a tarefa para edição
  AvisoDialog({this.aviso});

  @override
  _AvisoDialogState createState() => _AvisoDialogState();
}

class _AvisoDialogState extends State<AvisoDialog> {
  final _titloController = TextEditingController();
  final _descripController = TextEditingController();

  Aviso _currentAviso = Aviso();

  @override
  void initState() {
    super.initState();
    // verifica se foi enviado alguma tarefa para edição se quiser editar e copiar
    if (widget.aviso != null) {
      _currentAviso = Aviso.fromMap(widget.aviso.toMap());
    }
    _titloController.text = _currentAviso.titlo;
    _descripController.text = _currentAviso.descrip;
  }

  @override
  void dispose() {
    super.dispose();
    _titloController.clear();
    _descripController.clear();
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(widget.aviso == null ? 'Nova Tarefa' : 'Editar Tarefas'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
                controller: _titloController,
                decoration: InputDecoration(labelText: 'Título'),
                autofocus: true
            ),
            TextField(
                controller: _descripController,
                decoration: InputDecoration(labelText: 'Descrição')
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancelar'),
            color: Colors.red,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Salvar'),
            color: Colors.green,  
            onPressed: () {
              _currentAviso.titlo = _titloController.value.text;
              _currentAviso.descrip = _descripController.text;
              Navigator.of(context).pop(_currentAviso);
            },
          ),
        ],
    );
  }
}