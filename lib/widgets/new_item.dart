import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shoplisting/data/categories.dart';
import 'package:shoplisting/models/category.dart';
import 'package:shoplisting/models/grocery.dart';
//import 'package:shoplisting/models/grocery.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;
  final _formKey = GlobalKey<FormState>();
  var _isSending = false;
  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });
      final url = Uri.https('shoplisting-8b15c-default-rtdb.firebaseio.com',
          'shopping-list.json');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': _enteredName,
          'quantity': _enteredQuantity,
          'category': _selectedCategory.title,
        }),
      );

      final Map<String, dynamic> resData = json.decode(response.body);

      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop(GroceryItem(
        id: resData['name'],
        name: _enteredName,
        quantity: _enteredQuantity,
        category: _selectedCategory,
      ));
      // Navigator.of(context).pop(GroceryItem(
      //   id: DateTime.now().toString(),
      //   name: _enteredName,
      //   quantity: _enteredQuantity,
      //   category: _selectedCategory,
      // ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a new Item')),
      body: Padding(
        padding: const EdgeInsets.all(13),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text('Name'),
                  ),
                  onSaved: (value) {
                    _enteredName = value!;
                  },
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 50) {
                      return 'Must be between 1 and 50 characters.';
                    }
                    return null;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        onSaved: (value) {
                          _enteredQuantity = int.parse(value!);
                        },
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) == null ||
                              int.tryParse(value)! <= 0) {
                            return 'Must be a valid positve number';
                          }
                          return null;
                        },
                        decoration:
                            const InputDecoration(label: Text('Quantity')),
                        initialValue: '1',
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: DropdownButtonFormField(
                          value: _selectedCategory,
                          items: [
                            for (final category in categories.entries)
                              DropdownMenuItem(
                                  value: category.value,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        color: category.value.color,
                                      ),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      Text(category.value.title)
                                    ],
                                  ))
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value!;
                            });
                          }),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: _isSending
                            ? null
                            : () {
                                _formKey.currentState!.reset();
                              },
                        child: const Text('Reset')),
                    ElevatedButton(
                        onPressed: _isSending ? null : _saveItem,
                        child: _isSending
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(),
                              )
                            : const Text('Add new Item'))
                  ],
                )
              ],
            )),
      ),
    );
  }
}










// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shoplisting/data/categories.dart';
// //import 'package:shoplisting/data/dummy_items.dart';
// import 'package:shoplisting/widgets/new_item.dart';

// import '../models/grocery.dart';

// class GroceryList extends StatefulWidget {
//   const GroceryList({super.key});

//   @override
//   State<GroceryList> createState() => _GroceryListState();
// }

// class _GroceryListState extends State<GroceryList> {
//   List<GroceryItem> _groceryItems = [];
//   // var isLoading = true;
//   Future<List<GroceryItem>>? _loadedItem;
//   String? _error;
//   @override
//   void initState() {
//     _loadedItem = _loadItems();
//     super.initState();
//     //  _loadItems();
//   }

//   // void _loadItems() async {
//   //   final url = Uri.https(
//   //       'shoplisting-8b15c-default-rtdb.firebaseio.com', 'shopping-list.json');
//   //   try {
//   //     final response = await http.get(
//   //       url,
//   //     );

//   //     if (response.statusCode >= 400) {}
//   //     if (response.body == 'null') {
//   //       setState(() {
//   //         isLoading = false;
//   //       });
//   //       return;
//   //     }

//   //     final Map<String, dynamic> listData = json.decode(response.body);
//   //     final List<GroceryItem> loadedItems = [];
//   //     for (final item in listData.entries) {
//   //       final category = categories.entries
//   //           .firstWhere(
//   //             (catItem) => catItem.value.title == item.value['category'],
//   //           )
//   //           .value;
//   //       loadedItems.add(GroceryItem(
//   //           id: item.key,
//   //           name: item.value['name'],
//   //           quantity: item.value['quantity'],
//   //           category: category));
//   //     }

//   //     setState(() {
//   //       _groceryItems = loadedItems;
//   //       isLoading = false;
//   //     });
//   //   } catch (err) {
//   //     setState(() {
//   //       _error = 'Something went wrong. Please try again later.';
//   //     });
//   //   }
//   // }
//   Future<List<GroceryItem>> _loadItems() async {
//     final url = Uri.https(
//         'shoplisting-8b15c-default-rtdb.firebaseio.com', 'shopping-list.json');

//     final response = await http.get(
//       url,
//     );

//     if (response.statusCode >= 400) {
//       throw Exception();
//     }
//     if (response.body == 'null') {
//       return [];
//     }

//     final Map<String, dynamic> listData = json.decode(response.body);
//     final List<GroceryItem> loadedItems = [];
//     for (final item in listData.entries) {
//       final category = categories.entries
//           .firstWhere(
//             (catItem) => catItem.value.title == item.value['category'],
//           )
//           .value;
//       loadedItems.add(GroceryItem(
//           id: item.key,
//           name: item.value['name'],
//           quantity: item.value['quantity'],
//           category: category));
//     }

//     return loadedItems;
//   }

//   void _addItem() async {
//     try {
//       final newItem = await Navigator.of(context)
//           .push<GroceryItem>(MaterialPageRoute(builder: (ctx) {
//         return const NewItem();
//       }));

//       if (newItem == null) {
//         return;
//       }

//       setState(() {
//         _groceryItems.add(newItem);
//       });
//     } catch (err) {
//       rethrow;
//     }
//     // if (newItem == null) {
//     //   return;
//     // }
//     // setState(() {
//     //   _groceryItems.add(newItem);
//     // });
//   }

//   void _removeItem(GroceryItem item) async {
//     final index = _groceryItems.indexOf(item);
//     setState(() {
//       _groceryItems.remove(item);
//     });
//     final url = Uri.https('shoplisting-8b15c-default-rtdb.firebaseio.com',
//         'shopping-list/${item.id}.json');
//     final response = await http.delete(url);
//     if (response.statusCode >= 400) {
//       setState(() {
//         _groceryItems.insert(index, item);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     Widget content = const Center(
//       child: Column(
//         children: [CircularProgressIndicator(), Text('No item Added Yet')],
//       ),
//     );
//     // if (isLoading) {
//     //   content = const Center(
//     //     child: CircularProgressIndicator(),
//     //   );
//     // }
//     if (_groceryItems.isNotEmpty) {
//       content = ListView.builder(
//           itemCount: _groceryItems.length,
//           itemBuilder: (context, index) {
//             return Dismissible(
//               key: ValueKey(_groceryItems[index].id),
//               onDismissed: (direction) {
//                 _removeItem(_groceryItems[index]);
//               },
//               child: ListTile(
//                 leading: Container(
//                   width: 24,
//                   height: 24,
//                   color: _groceryItems[index].category.color,
//                 ),
//                 trailing: Text(_groceryItems[index].quantity.toString()),
//                 title: Text(_groceryItems[index].name),
//               ),
//             );
//           });
//     }
//     if (_error != null) {
//       content = Center(child: Text(_error!));
//     }
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Youur Groceries'),
//           actions: [
//             IconButton(onPressed: _addItem, icon: const Icon(Icons.add))
//           ],
//         ),
//         // body: content,
//         body: FutureBuilder(
//             future: _loadedItem,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 const Center(
//                   child: Column(
//                     children: [
//                       CircularProgressIndicator(),
//                       Text('No item Added Yet')
//                     ],
//                   ),
//                 );
//               }
//               if (snapshot.hasData) {
//                 return Center(
//                   child: Text(snapshot.error.toString()),
//                 );
//               }
//               if (snapshot.data!.isEmpty) {
//                 return const Center(
//                     child: Column(
//                   children: [
//                     CircularProgressIndicator(),
//                     Text('No item Added Yet')
//                   ],
//                 ));
//               }
//               return ListView.builder(
//                   itemCount: snapshot.data!.length,
//                   itemBuilder: (context, index) {
//                     return Dismissible(
//                       key: ValueKey(snapshot.data![index].id),
//                       onDismissed: (direction) {
//                         _removeItem(snapshot.data![index]);
//                       },
//                       child: ListTile(
//                         leading: Container(
//                           width: 24,
//                           height: 24,
//                           color: snapshot.data![index].category.color,
//                         ),
//                         trailing:
//                             Text(snapshot.data![index].quantity.toString()),
//                         title: Text(snapshot.data![index].name),
//                       ),
//                     );
//                   });
//             }));
//   }
// }
