import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minhas_notacoes/model/anotacao.dart';
import 'package:minhas_notacoes/service/anotacao_db.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ScreenHome extends StatefulWidget {
  @override
  _ScreenHomeState createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  var _db = AnotacaoDB();
  List<Anotacao> _anotacoes = List<Anotacao>();



  exibirTelaCadastro({Anotacao anotacao}){
    String funcao ="";
    if (anotacao == null){
      _tituloController.text = "";
      _descricaoController.text = "";
      funcao = "Salvar";
    }
    else{
      _tituloController.text = anotacao.titulo;
      _descricaoController.text = anotacao.descricao;
      funcao = "Atualizar";
    }
    showDialog(
     context: context,
      builder: (context){
       return AlertDialog(
        title: Text(funcao + " anotação"),
         content: Column(
           mainAxisSize: MainAxisSize.min,
           children: <Widget>[
             TextField(
               controller: _tituloController,
               autofocus: true,
               decoration: InputDecoration(
                 labelText: "Titulo",
                 hintText: "Digite o Título ..."
               ),
             ),
             Padding(
               padding: EdgeInsets.only(top:10),
             ),
             TextField(
               controller: _descricaoController,
               decoration: InputDecoration(
                   labelText: "Descrição",
                   hintText: "Digite a Descrição ..."
               ),
             ),
           ],
         ),
         actions: <Widget>[

           RaisedButton(
             child: Text("Cancelar"),
             onPressed: ()=> Navigator.pop(context),
           ),
           RaisedButton(
             child: Text(funcao),
             onPressed: (){
               _salvarAtualizarAnotacao(nota: anotacao);
               Navigator.pop(context);
             } ,
           ),
         ],
       );
      }
    );

  }

  _salvarAtualizarAnotacao({Anotacao nota}) async{
    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;
    if(nota == null){
      if(descricao != "" && titulo != "" ){
        Anotacao anotacao = Anotacao(titulo,descricao,DateTime.now().toString());
        int resultado  = await _db.saveAnotacao(anotacao);
        _tituloController.clear();
        _descricaoController.clear();
      }
    }
    else{
      print("Update");
      nota.titulo = _tituloController.text;
      nota.descricao = _descricaoController.text;
      int resultado = await  _db.atualizarAnotacao(nota);
    }
    _recuperarAnotacoes();
  }

  _deletarAnotacao(int id) async{
   int resultado  = await _db.deletarAnotacao(id);
   _recuperarAnotacoes();

  }

  _exibirTelaDelete(context,id){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Deletear anotação"),
            content:Text("Confirma exclusão ?"),
            actions: <Widget>[

              RaisedButton(
                child: Text("Cancelar"),
                onPressed: ()=> Navigator.pop(context),
              ),
              RaisedButton(
                child: Text("SIM"),
                onPressed: (){
                  _deletarAnotacao(id);
                  Navigator.pop(context);
                } ,
              ),
            ],
          );
        }
    );
  }




  _recuperarAnotacoes()async{
    List<Map> anotacoesRecuperadas = await _db.recuperarAnotacoes();
    List<Anotacao> anotacoesTemporaria = Anotacao.getAnotacoesfromMap(anotacoesRecuperadas);
    setState(() {
      _anotacoes = anotacoesTemporaria;
    });
    anotacoesTemporaria = null;
  }
  @override
  void initState(){
    super.initState();
    _recuperarAnotacoes();
  }

  String formatData(String data){
    initializeDateFormatting("pt_BR");
    var formater = DateFormat("dd/MM/y HH:mm");
    DateTime dataConvertida = DateTime.parse(data);
    return  formater.format(dataConvertida);
  }

  Widget exibirLista(){
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
              itemCount: _anotacoes.length,
              itemBuilder: (context,index){
                final anotacao = _anotacoes[index];
                return Card(
                  child: ListTile(
                    title: Text(anotacao.titulo),
                    subtitle: Text("${formatData(anotacao.data)} - ${anotacao.descricao}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                            //_anotacao = anotacao;
                            exibirTelaCadastro(anotacao: anotacao);
                          },
                          child: Icon(
                              Icons.edit,
                              color: Colors.green
                            ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 12),
                        ),
                        GestureDetector(
                          onTap: (){
                            _exibirTelaDelete(context, anotacao.id);
                          },
                          child: Icon(
                              Icons.remove_circle,
                              color: Colors.red
                          ),
                        ),

                      ],
                    ),
                  ),
                );
              }
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas anotações"),
        backgroundColor: Colors.lightGreen,
      ),
      body: exibirLista(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed:exibirTelaCadastro,
        child: Icon(Icons.add),
      ),
    );
  }
}
