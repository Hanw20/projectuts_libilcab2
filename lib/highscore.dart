import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HighScore extends StatefulWidget {
  const HighScore({super.key});

  @override
  State<HighScore> createState() => _HighScoreState();
}

class _HighScoreState extends State<HighScore> {
  List<List<String>> scores = [];
  List<double> _opacities = [];

  String getGelar(int correct) {
    if (correct == 5)
      return "Maestro dell'Indovinello (Master of Riddles)";
    else if (correct == 4)
      return "Esperto dell'Indovinello (Expert of Riddles)";
    else if (correct == 3)
      return "Abile Indovinatore (Skillful Guesser)";
    else if (correct == 2)
      return "Principiante dell'Indovinello (Riddle Beginner)";
    else if (correct == 1)
      return "Neofita dell'Indovinello (Riddle Novice)";
    else
      return "Sfortunato Indovinatore (Unlucky Guesser)";
  }

  Future<void> loadScores() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> data = prefs.getStringList("scores") ?? [];

    scores = data.map((e) => e.split("|")).toList();

    setState(() {
      _opacities = List.filled(scores.length, 0.0);
    });

    for (int i = 0; i < scores.length; i++) {
      await Future.delayed(Duration(milliseconds: 300 * i));
      setState(() {
        _opacities[i] = 1.0;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadScores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("High Score"),
        centerTitle: true,
      ),
      backgroundColor: const Color.fromARGB(255, 217, 241, 219),

      body: scores.isEmpty
          ? const Center(child: Text("Belum ada data"))
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(scores.length, (index) {
                int correct = int.parse(scores[index][1]);

                return AnimatedOpacity(
                  opacity: _opacities.length > index ? _opacities[index] : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: index == 0
                          ? Colors.amber.shade200
                          : index == 1
                          ? Colors.grey.shade300
                          : index == 2
                          ? Colors.orange.shade200
                          : Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "#${index + 1}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              scores[index][0],
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(
                              getGelar(correct),
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              scores[index][2],
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(
                              "Benar: $correct/5",
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        },
        child: const Icon(Icons.home),
      ),
    );
  }
}
