class Usuario {
  final int? id; // pode ser nulo, pois será gerado no backend
  final String nome;
  final String sobrenome;
  final String email;
  final String senha;

  Usuario({
    this.id,
    required this.nome,
    required this.sobrenome,
    required this.email,
    required this.senha,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'], // pode ser nulo se não vier no JSON
      nome: json['nome'],
      sobrenome: json['sobrenome'],
      email: json['email'],
      senha: json['senha'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'nome': nome,
      'sobrenome': sobrenome,
      'email': email,
      'senha': senha,
    };

    if (id != null) {
      data['id'] = id;
    }

    return data;
  }
}
