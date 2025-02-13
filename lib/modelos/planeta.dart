class Planeta {
  int? id;
  String nome;
  double distancia;
  double tamanho;
  String? apelido;

  //construtor da classe Planeta
  Planeta({
    this.id,
    required this.nome,
    required this.distancia,
    required this.tamanho,
    this.apelido,
  });

  //Construtor alternativo
  Planeta.vazio() : nome = '', distancia = 0, tamanho = 0, apelido = '';

  factory Planeta.fromMap(Map<String, dynamic> map) {
    return Planeta(
      id: map['id'],
      nome: map['nome'],
      distancia: map['distancia'],
      tamanho: map['tamanho'],
      apelido: map['apelido'],
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'distancia': distancia,
      'tamanho': tamanho,
      'apelido': apelido,
    };
  }
}