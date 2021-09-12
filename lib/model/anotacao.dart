
class Anotacao{
    int id;
    String titulo;
    String descricao;
    String data;

    Anotacao(this.titulo, this.descricao, this.data,{this.id});

    Anotacao.fromMap(Map map){
      this.id = map["id"];
      this.titulo  =  map["titulo"];
      this.descricao  =  map["descricao"];
      this.data  =  map["data"];
    }

    static List<Anotacao> getAnotacoesfromMap(List<Map> entradas){
      List<Anotacao> anotacoes = List<Anotacao>();
      for(var item in entradas){
        int id = item["id"];
        String titulo  =  item["titulo"];
        String descricao  =  item["descricao"];
        String data  =  item["data"];
        Anotacao anotacao = Anotacao(titulo, descricao,data,id: id);
        //print (anotacao.titulo);
        anotacoes.add(anotacao);
      }
      return anotacoes;
    }

    Map toMap(){
      Map<String,dynamic> map = {
        "titulo" : this.titulo,
        "descricao" : this.descricao,
        "data" : this.data
      };

      if(this.id != null){
        map["id"] = this.id;
      }
      return map;
    }

}