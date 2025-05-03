import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeviewBody extends StatefulWidget {
  const HomeviewBody({super.key});

  @override
  State<HomeviewBody> createState() => _HomeviewBodyState();
}

class _HomeviewBodyState extends State<HomeviewBody> {
  final TextEditingController _controller = TextEditingController();
  final supabase = Supabase.instance.client;
  List<dynamic> users = [];

  Future<void> insertUser(String name) async {
    await supabase.from('user').insert({'name': name});
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final response = await supabase
        .from('user')
        .select()
        .order('id', ascending: false);
    setState(() {
      users = response;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'اكتب اسم المستخدم',
              suffixIcon: IconButton(
                icon: Icon(Icons.person_add),
                onPressed: () {
                  final name = _controller.text.trim();
                  if (name.isNotEmpty) {
                    insertUser(name);
                    _controller.clear();
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: CircleAvatar(child: Text(user['id'].toString())),
                  title: Text(user['name']),
                  subtitle: Text(user['created_at'] ?? ''),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
