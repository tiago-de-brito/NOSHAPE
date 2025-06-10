import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AcompanharProgressoScreen extends StatefulWidget {
  final int usuarioId;

  AcompanharProgressoScreen({required this.usuarioId});

  @override
  _AcompanharProgressoScreenState createState() => _AcompanharProgressoScreenState();
}

class _AcompanharProgressoScreenState extends State<AcompanharProgressoScreen> {
  List<Map<String, dynamic>> progresso = [];
  List<String> exerciciosDisponiveis = [];
  String? exercicioSelecionado;

   // Getter que gera a lista de FlSpot para o gráfico
List<FlSpot> get pontos {
  return progresso.asMap().entries.map((entry) {
    final index = entry.key.toDouble();
    final cargaRaw = entry.value['carga_total'];
    double carga = 0;
    if (cargaRaw is int) {
      carga = cargaRaw.toDouble();
    } else if (cargaRaw is double) {
      carga = cargaRaw;
    } else if (cargaRaw is String) {
      carga = double.tryParse(cargaRaw) ?? 0;
    }
    return FlSpot(index, carga);
  }).toList();
}

  // Getter que gera os labels do eixo X (ex: meses ou dias)
List<String> get labels {  
return progresso.map((e) {
  final dataStr = e['data']?.toString() ?? '';
  if (dataStr.isEmpty) return '';
  final date = DateTime.tryParse(dataStr);
  if (date == null) return '';
  // Exemplo: "10/05"
  return '${date.day}/${date.month}';
}).toList();

}
  @override
  void initState() {
    super.initState();
    buscarExercicios();
  }

  Future<void> buscarExercicios() async {
    final response = await http.get(Uri.parse('http://192.168.0.58:3000/treinos/${widget.usuarioId}'));
    if (response.statusCode == 200) {
      final List dados = json.decode(response.body);
      final nomes = dados.map((e) => e['nome_exercicio'] as String).toSet().toList();
      setState(() {
        exerciciosDisponiveis = nomes;
        if (nomes.isNotEmpty) {
          exercicioSelecionado = nomes[0];
          buscarProgresso();
        }
      });
    } else {
      print('Erro ao buscar exercícios: ${response.statusCode}');
    }
  }

  Future<void> buscarProgresso() async {
    if (exercicioSelecionado == null) return;

    final response = await http.get(
      Uri.parse('http://192.168.0.58:3000/progresso/${widget.usuarioId}/${Uri.encodeComponent(exercicioSelecionado!)}'),
    );

    if (response.statusCode == 200) {
      final List dados = json.decode(response.body);
      setState(() {
        progresso = dados.cast<Map<String, dynamic>>();
      });
    } else {
      print('Erro ao buscar progresso: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Progresso')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (exerciciosDisponiveis.isNotEmpty)
              DropdownButton<String>(
                value: exercicioSelecionado,
                onChanged: (value) {
                  setState(() {
                    exercicioSelecionado = value;
                  });
                  buscarProgresso();
                },
                items: exerciciosDisponiveis.map((String exercicio) {
                  return DropdownMenuItem<String>(
                    value: exercicio,
                    child: Text(exercicio),
                  );
                }).toList(),
              ),
            SizedBox(height: 16),
            Expanded(
  child: pontos.isEmpty
      ? Center(child: Text('Nenhum dado para mostrar.'))
      : LineChart(
          LineChartData(
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < 0 || index >= labels.length) return Container();
                    return Text(labels[index], style: TextStyle(fontSize: 10));
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: pontos,
                isCurved: true,
                barWidth: 3,
                color: Colors.blue,
                belowBarData: BarAreaData(show: false),
                dotData: FlDotData(show: true),
              ),
            ],
          ),
        ),
),
          ],
        ),
      ),
    );
  }
}
