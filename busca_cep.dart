import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Endereco {
  String cep;
  String logradouro;
  String complemento;
  String bairro;
  String localidade;
  String uf;

  Endereco({
    required this.cep,
    required this.logradouro,
    required this.complemento,
    required this.bairro,
    required this.localidade,
    required this.uf,
  });

  factory Endereco.fromJson(Map<String, dynamic> json) {
    return Endereco(
      cep: json['cep'],
      logradouro: json['logradouro'],
      complemento: json['complemento'],
      bairro: json['bairro'],
      localidade: json['localidade'],
      uf: json['uf'],
    );
  }

  @override
  String toString() {
    return '''
    CEP: $cep
    Logradouro: $logradouro
    Complemento: $complemento
    Bairro: $bairro
    Localidade: $localidade
    UF: $uf
    ''';
  }
}

Future<Endereco> fetchEndereco(String cep) async {
  final response = await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));

  if (response.statusCode == 200) {
    return Endereco.fromJson(json.decode(response.body));
  } else {
    throw Exception('Falha ao carregar os dados do CEP.');
  }
}

void main() async {
  String input;

  do {
    print('Digite um CEP (ou 0 para sair):');
    input = stdin.readLineSync() ?? '';
    if (input != '0') {
      input = input.replaceAll('-', '');

      if (input.length != 8) {
        print('CEP inválido. Tente novamente.');
        continue;
      }

      try {
        final endereco = await fetchEndereco(input);
        print(endereco);
      } catch (e) {
        print('Erro ao buscar o CEP: $e');
      }
    }
  } while (input != '0');
}

//'01001-000','20000-000','30140-001','40010-001','50030-001','60060-000','70002-900','80010-000','90010-250','01000-000'
