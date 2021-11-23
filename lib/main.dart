import 'package:dog_watcher/infra/graphql/api.dart';
import 'package:dog_watcher/infra/graphql/client.dart';
import 'package:dog_watcher/ui/live.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql/client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp();
  await FirebaseAuth.instance.signInAnonymously();

  final gqClient = GQClient();
  gqClient.setup("https://dog-watcher-333008.an.r.appspot.com/query");

  final payload = GetTokenQuery();
  final resp = await GQClient().query(QueryOptions(document: payload.document));
  final decoded = GetToken$Query.fromJson(resp);
  final token = decoded.rtcToken.token;

  print("token");
  print(dotenv.env["AGORA_APP_ID"]!);
  print(token);

  final app = MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
    home: LivePage.init(token),
    builder: (context, child) {
      // 端末の文字サイズ設定を無効にする
      return MediaQuery(
        child: child!,
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      );
    },
  );

  runApp(app);
}
