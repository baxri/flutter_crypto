import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './repositories/crypto_repository.dart';
import './blocs/crypto/crypto_bloc.dart';

import './screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CryptoBloc>(
      create: (_) =>
          CryptoBloc(cryptoRepository: CryptoRepository())..add(AppStarted()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Crypto App',
        theme: ThemeData(
          primaryColor: Colors.black,
          accentColor: Colors.tealAccent,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
