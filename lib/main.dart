
import 'package:flutter/material.dart';

void main() {
  runApp(const MasnaeiApp());
}

class MasnaeiApp extends StatelessWidget {
  const MasnaeiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'مصنعي',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: 'Arial',
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final passwordController = TextEditingController();
  String role = 'manager';
  String error = '';

  void login() {
    // بيانات تجريبية للواجهة فقط
    final correct = passwordController.text == '1234';

    if (!correct) {
      setState(() => error = 'كلمة المرور غير صحيحة');
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MachinesPage(isManager: role == 'manager'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xfff2f5f9),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(Icons.factory, size: 65, color: Colors.blue),
                    const SizedBox(height: 12),
                    const Text(
                      'مصنعي',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text('اختر نوع الحساب'),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: role,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'نوع المستخدم',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'manager',
                          child: Text('مدير'),
                        ),
                        DropdownMenuItem(
                          value: 'worker',
                          child: Text('عامل - مشاهدة فقط'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() => role = value!);
                      },
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'كلمة المرور',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      onSubmitted: (_) => login(),
                    ),
                    if (error.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(error, style: const TextStyle(color: Colors.red)),
                    ],
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: login,
                        child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text('تسجيل الدخول'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'نسخة تجريبية - كلمة المرور 1234',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Machine {
  Machine(this.name);

  final String name;
  bool heater = false;
  bool motor = false;
  bool running = false;

  String lastOn = '—';
  String lastOff = '—';
  String firstStart = '—';
}

class MachinesPage extends StatefulWidget {
  const MachinesPage({super.key, required this.isManager});

  final bool isManager;

  @override
  State<MachinesPage> createState() => _MachinesPageState();
}

class _MachinesPageState extends State<MachinesPage> {
  final List<Machine> machines = List.generate(
    10,
    (index) => Machine('الآلة ${index + 1}'),
  );

  String now() {
    final d = DateTime.now();
    return '${d.year}/${d.month}/${d.day} '
        '${d.hour.toString().padLeft(2, '0')}:'
        '${d.minute.toString().padLeft(2, '0')}';
  }

  void toggleMachine(Machine machine, bool value) {
    setState(() {
      machine.running = value;
    });
  }

  Widget signal(String title, bool active) {
    return Row(
      children: [
        Icon(
          Icons.circle,
          size: 12,
          color: active ? Colors.green : Colors.grey,
        ),
        const SizedBox(width: 7),
        Text('$title: ${active ? 'يعمل' : 'متوقف'}'),
      ],
    );
  }

  Widget timeRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(title)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget machineCard(Machine machine) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.precision_manufacturing,
                    color: Colors.blue, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    machine.name,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  machine.running ? 'أمر التشغيل ON' : 'أمر التشغيل OFF',
                  style: TextStyle(
                    color: machine.running ? Colors.green : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            signal('إشارة السخان', machine.heater),
            const SizedBox(height: 8),
            signal('إشارة المحرك', machine.motor),
            const Divider(height: 20),
            timeRow('آخر تشغيل للسخان', machine.lastOn),
            timeRow('آخر إيقاف للسخان', machine.lastOff),
            timeRow('أول تشغيل للمحرك', machine.firstStart),
            if (widget.isManager) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => toggleMachine(machine, true),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('تشغيل'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => toggleMachine(machine, false),
                      icon: const Icon(Icons.stop),
                      label: const Text('إيقاف'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('مصنعي'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(14),
          children: [
            Text(
              widget.isManager ? 'لوحة تحكم المدير' : 'لوحة مشاهدة العامل',
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'حالة الآلات العشر',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ...machines.map(machineCard),
          ],
        ),
      ),
    );
  }
}

