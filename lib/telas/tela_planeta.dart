import 'package:flutter/material.dart';
import 'package:myapp/controles/controle_planeta.dart';

import '../modelos/planeta.dart';

class TelaPlaneta extends StatefulWidget {
  final bool isIncluir;
  final Planeta planeta;
  final Function() onFinalizado;

  const TelaPlaneta({
    super.key,
    required this.isIncluir,
    required this.planeta,
    required this.onFinalizado,
  });

  @override
  State<TelaPlaneta> createState() => _TelaPlanetaState();
}

class _TelaPlanetaState extends State<TelaPlaneta> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _apelidoController = TextEditingController();

  final ControlePlaneta _controlePlaneta = ControlePlaneta();

  late Planeta _planeta;

  @override
  void initState() {
    _planeta = widget.planeta;
    _nameController.text = _planeta.nome;
    _sizeController.text = _planeta.tamanho.toString();
    _distanceController.text = _planeta.distancia.toString();
    _apelidoController.text = _planeta.apelido ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _apelidoController.dispose();
    _distanceController.dispose();
    _sizeController.dispose();

    super.dispose();
  }

  Future<void> _inserirPlaneta() async {
    await _controlePlaneta.inserirPlaneta(_planeta);
  }

  Future<void> _alterarPlaneta() async {
    await _controlePlaneta.alterarPlaneta(_planeta);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (widget.isIncluir) {
        _inserirPlaneta();
      } else {
        _alterarPlaneta();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dados do planeta foram ${widget.isIncluir ? 'incluídos' : 'alterados'} com sucesso!')),
      );
      Navigator.of(context).pop();
      widget.onFinalizado();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 3,
        title: Text('Cadastrar planeta'),
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 3) {
                      return 'Por favor, insira o nome do planeta (3 caracteres minimo)';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _planeta.nome = value!;
                  },
                ),
                SizedBox(height: 10),

                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _sizeController,
                  decoration: InputDecoration(
                    labelText: 'Tamanho (em Km)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o tamanho do planeta ';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor, insira um valor numerico valido';
                    }
                    if (double.parse(value) < 0) {
                      return 'Por favor, insira um valor positivo';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _planeta.tamanho = double.parse(value!);
                  },
                ),
                SizedBox(height: 10),

                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _distanceController,
                  decoration: InputDecoration(
                    labelText: 'Distancia até o Sol (em AU)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a distancia do planeta ';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor, insira um valor numerico valido';
                    }
                    if (double.parse(value) < 0) {
                      return 'Por favor, insira um valor positivo';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _planeta.distancia = double.parse(value!);
                  },
                ),
                SizedBox(height: 10),

                TextFormField(
                  controller: _apelidoController,
                  decoration: InputDecoration(
                    labelText: 'Apelido',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  onSaved: (value) {
                    _planeta.apelido = value!;
                  },
                ),

                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                ElevatedButton(
                  onPressed:() => Navigator.of(context).pop(), //_submitForm,
                  child: Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: _submitForm, //_submitForm,
                  child: Text('Confirmar'),
                ),
                ],)
              ],
            ),
          ),
        ),
      ),
    );
  }
}