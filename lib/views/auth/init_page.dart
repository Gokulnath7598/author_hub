import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/message_bloc/message_bloc.dart';
import '../home/home_page.dart';


class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  late final MessageBloc messageBloc;

  @override
  void initState() {
    messageBloc = BlocProvider.of<MessageBloc>(context);
    messageBloc.add(GetMessages(isInitialSync: true));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}
