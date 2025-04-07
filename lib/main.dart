import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _temaEscuro = false;

  void _alternarTema() {
    setState(() {
      _temaEscuro = !_temaEscuro;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _temaEscuro ? ThemeMode.dark : ThemeMode.light,
      home: TodoListPage(onToggleTheme: _alternarTema),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TodoListPage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const TodoListPage({super.key, required this.onToggleTheme});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final List<Tarefa> _tarefas = [];
  final TextEditingController _controller = TextEditingController();

  void _adicionarTarefa(String titulo) {
    setState(() {
      _tarefas.add(Tarefa(titulo));
    });
    _controller.clear();
  }

  void _alternarConcluida(int index) {
    setState(() {
      _tarefas[index].concluida = !_tarefas[index].concluida;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.onToggleTheme,
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Nova tarefa',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      _adicionarTarefa(_controller.text.trim());
                    }
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tarefas.length,
              itemBuilder: (context, index) {
                final tarefa = _tarefas[index];
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: tarefa.concluida ? 0.5 : 1.0,
                  child: CheckboxListTile(
                    title: Text(
                      tarefa.titulo,
                      style: TextStyle(
                        decoration: tarefa.concluida
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    value: tarefa.concluida,
                    onChanged: (_) => _alternarConcluida(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Tarefa {
  String titulo;
  bool concluida;

  Tarefa(this.titulo, {this.concluida = false});
}
