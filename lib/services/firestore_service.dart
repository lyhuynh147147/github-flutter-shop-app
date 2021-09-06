import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


/*
class FirestoreService{
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _db = FirebaseFirestore.instance;
  //Product product;
  static final FirestoreService _firestoreService =
  FirestoreService._internal();

  FirestoreService._internal();
  factory FirestoreService() {
    return _firestoreService;
  }
  final CollectionReference usersRef =
  FirebaseFirestore.instance.collection("Users");

  final CollectionReference productsRef =
  FirebaseFirestore.instance.collection("Products");

  String getUserId() {
    return _firebaseAuth.currentUser.uid;
  }

  Stream<List<Product>> getProducts(){
    return productsRef

    */
/*_db.collection('Product')
      .doc('geTjx15Ser4f2lzXKbSL')
        .collection('Test')*//*

        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((e) => Product.fromFirestore(e.data(),e.id))
        .toList());
  }

  Stream<List<Product>> get(){
    return productsRef

        */
/*_db.collection('Products')
        .doc('geTjx15Ser4f2lzXKbSL')
        .collection('Test')*//*

        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((e) => Product.fromFirestore(e.data(),e.id))
        .toList());
  }

  List<Products> products =[];
  Products productsData;
  Future<List<Products>> getP() async {
    List<Products> newList = [];
    QuerySnapshot querySnapshot =
    await FirebaseFirestore
        .instance
        .collection("Products")
        .get();
    querySnapshot.docs.forEach(
          (element) {
        productsData = Products(
          color: element.data()['color'],
          id: element.data()['id'],
          image: element.data()['image'],
          name: element.data()["name"],
          price: element.data()["price"],
          size: element.data()['size'],
          description: element.data()['description'],
        );
        newList.add(productsData);
      },
    );
    products = newList;

  }

  Future<void> saveProduct(Product product){
    return _db.collection('Products')
        */
/*.doc("n7vCtbCfDv0vERndRTL3")
        .collection("tie")*//*

        .doc(product.id)
        .set(product.toMap());
  }



  Future<void> removeProduct(String productId){
    return usersRef
        .doc(getUserId())
        .collection("Cart")
        .doc(productId)
        .delete()
        .then((value) => print("User deleted"))
        .catchError((e)=>print("Failed to delete user: $e"));;
  }



  ///
  Stream<List<Product>> getNotes() {
    return usersRef
        .doc(getUserId())
        .collection("Cart")
        .snapshots()
        .map(
          (snapshot) =>
          snapshot.docs.map(
                (doc) => Product.fromFirestore(doc.data(), doc.id),
          ).toList(),
    );
  }

  */
/*Future<void> addNote(Product note) {
    return _db
        .collection('Users')
        .doc(getUserId())
        .collection("Cart")
        .add(note.toMap());
  }*//*


  Future<void> deleteProduct(String id) {
    return usersRef
        .doc(getUserId())
        .collection("Cart")
        .doc(id)
        .delete()
        .then((value) => print("User deleted"))
        .catchError((e)=>print("Failed to delete user: $e"));;
  }

  Future<void> getPro() async {
    List item =[];
    try {
      await productsRef.doc('geTjx15Ser4f2lzXKbSL')
          .collection('Test').get().then((querySnapshot) {
            querySnapshot.docs.forEach((element) {
              item.add(element.data());
            });
      });
    } catch (e){
      print(e.toString());
      return null;
    }

  }

  */
/*Future<void> updateNote(Product note) {
    return _db
        .collection('Users')
        .doc(getUserId())
        .collection('Cart')
        .doc(note.id)
        .update(note.toMap());
  }*//*




}*/
