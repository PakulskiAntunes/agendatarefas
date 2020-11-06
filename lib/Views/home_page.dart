import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:agendatarefas/helpers/aviso_pages.dart';
import 'package:agendatarefas/models/aviso.dart';
import 'package:agendatarefas/views/aviso_dialog.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Aviso> _avisoList = [];
  AvisoPages _helper = AvisoPages();
  bool _carrega = true;

  @override
  void initState() {
    super.initState();
    _helper.getAll().then((list) {
      setState(() {
        _avisoList = list;
        _carrega = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Tarefas')),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: _addNewAviso),
      body: _buildAvisoList(),
    );
  }

  Widget _buildAvisoList() {
    if (_avisoList.isEmpty) {
      return Center(
        child: _carrega ? CircularProgressIndicator() : Text('Sem Tarefas!'),
      );
    } else {
      return ListView.builder(
        itemBuilder: _buildAvisoItemSlidable,
        itemCount: _avisoList.length,
      );
    }
  }


  //exibe tarefas em lista
  Widget _buildAvisoItem(BuildContext context, int index) {
    final aviso = _avisoList[index];
    return ListTile(
      leading: CircleAvatar(
        child: Text(aviso.titlo[0]),
      ),
      title: Text(aviso.titlo),
      subtitle: Text(aviso.descrip)      
    );
  }

// Adiciona Ação as tarefas
  Widget _buildAvisoItemSlidable(BuildContext context, int index) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.2,
      child: _buildAvisoItem(context, index),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Editar',
          color: Colors.blue,
          icon: Icons.edit,
          onTap: () {
            _addNewAviso(editaAviso: _avisoList[index], index: index);
          },
        ),
        IconSlideAction(
          caption: 'Realizado',
          color: Colors.green,
          icon: Icons.check_circle,
          onTap: () {
            _deleteAviso(deletedAviso: _avisoList[index], index: index);
          },
        ),
      ],
    );
  }

// adiciona tarefa ou edita tarefa
  Future _addNewAviso({Aviso editaAviso, int index}) async {
    final aviso = await showDialog<Aviso>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AvisoDialog(aviso: editaAviso);
      },
    );
    if (aviso != null) {
      setState(() {
        if (index == null) {
          _avisoList.add(aviso);
          _helper.save(aviso);
        } else {
          _avisoList[index] = aviso;
          _helper.update(aviso);
        }
      });
    }
  }

// excluir tarefa
  void _deleteAviso({Aviso deletedAviso, int index}) {
    setState(() {
      _avisoList.removeAt(index);
    });
    _helper.delete(deletedAviso.id);
    Flushbar(
      title: "Excluir Tarefas",
      message: "Tarefa \"${deletedAviso.titlo}\" Removida.",
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      duration: Duration(seconds: 3),
      mainButton: FlatButton(
        child: Text(
          "Desfazer",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          setState(() {
            _avisoList.insert(index, deletedAviso);
            _helper.update(deletedAviso);
          });
        },
      ),
    )..show(context);
  }
}
