import 'package:ai_test/database.dart';
import 'package:ai_test/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';

final database = AppDatabase();
firebase.FirebaseAuth auth = firebase.FirebaseAuth.instance;
FirebaseFirestore fireStore = FirebaseFirestore.instance;
CollectionReference usersRef = fireStore.collection('Users');

Future<void> signUp(context,String name, String email, String password) async {
  try {
    final credential = await firebase.FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if(credential.user != null){
      auth.currentUser!.updateDisplayName(name);
      await addUserToFirebaseDatabase(password);
      await addUserToDriftDatabase(password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green[100],
          content:  Text('Sign Up Successfully',style: TextStyle(color: Colors.green[800]),),
        ),
      );
      Future.delayed(
        const Duration(seconds : 2),
            () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ChatScreen(),
          ),
        ),);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red[100],
          content: Text('SignUp failed. Please try again.', style: TextStyle(color: Colors.red[900]),),
        ),
      );
    }
  } on firebase.FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red[100],
          content: Text('The password provided is too weak.', style: TextStyle(color: Colors.red[900]),),
        ),
      );
    } else if (e.code == 'email-already-in-use') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red[100],
          content: Text('The account already exists for that email.', style: TextStyle(color: Colors.red[900]),),
        ),
      );
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red[100],
          content: Text('SignUp failed. Please try again.', style: TextStyle(color: Colors.red[900]),),
        ),
      );
    }
  }
}

Future<void> login(context, String email, String password) async {
  try {
    final credential = await firebase.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    );
    if (credential.user != null) {
      await addUserToFirebaseDatabase(password);
      await addUserToDriftDatabase(password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green[100],
          content: Text('Login Successfully', style: TextStyle(color: Colors.green[800]),),
        ),
      );
      Future.delayed(
        const Duration(seconds: 2),
            () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ChatScreen(),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red[100],
          content: Text('Login failed. Please try again.', style: TextStyle(color: Colors.red[900]),),
        ),
      );
    }
  } on firebase.FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red[100],
          content: Text('No user found for that email.', style: TextStyle(color: Colors.red[900]),),
        ),
      );
    } else if (e.code == 'wrong-password') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red[100],
          content: Text('Wrong password provided for that user.', style: TextStyle(color: Colors.red[900]),),
        ),
      );
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red[100],
          content: Text('Login failed. Please try again.', style: TextStyle(color: Colors.red[900]),),
        ),
      );
    }
  }
}




Future<void> deleteUser(String id) async {
  User? user;
  final stream = database.select(database.users)..where((t) => t.id.equals(id));
  final userRecord = await stream.getSingle();
  user = User(
    id: userRecord.id,
    name: userRecord.name,
    email: userRecord.email,
    password: userRecord.password,
  );
  await database.delete(database.users).delete(user);
}

Future<List<User>> getDataBase()async{
  List<User> allItems =
  await database.select(database.users).get();
  return allItems;
}

Future<void> addUserToFirebaseDatabase(String password) async {
  QuerySnapshot searchUser = await usersRef
      .where('id', isEqualTo: auth.currentUser!.uid)
      .limit(1)
      .get();

  if (searchUser.docs.isEmpty) {
  Map<String, dynamic> user = {};
  user['id'] = auth.currentUser!.uid;
  user['name'] = auth.currentUser!.displayName;
  user['email'] = auth.currentUser!.email;
  user['password'] = password;
  await usersRef.doc(auth.currentUser!.uid).set(user);
}}

Future<void> addUserToDriftDatabase(String password) async {
  List<User> allUsers = await getDataBase();
  bool isExist = false;
  for(var item in allUsers){
    if(item.id == auth.currentUser!.uid){
      isExist = true;
      break;
    }
  }
  if(!isExist){
   await database.into(database.users).insertReturningOrNull(UsersCompanion.insert(
      id: auth.currentUser!.uid,
      name: Value(auth.currentUser!.displayName),
      email: Value(auth.currentUser!.email),
      password: Value(password),
      rememberMe: const Value(true),
    ));
  }
}
