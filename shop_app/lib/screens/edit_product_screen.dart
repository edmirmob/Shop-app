import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/product_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlControler = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<ProductProvider>(context, listen: false)
            .findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl':_editedProduct.imageUrl
          'imageUrl': '',
        };
        _imageUrlControler.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlControler.dispose();
    _imageUrlFocusNode.dispose();

    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlControler.text.isEmpty ||
          (!_imageUrlControler.text.startsWith('hhtp') &&
              !_imageUrlControler.text.startsWith('https')) ||
          (!_imageUrlControler.text.endsWith('.jpg') &&
              !_imageUrlControler.text.endsWith('.png') &&
              !_imageUrlControler.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
     await Provider.of<ProductProvider>(context, listen: false)
          .updateProducts(_editedProduct.id, _editedProduct);
     
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<ProductProvider>(context, listen: false)
            .addProducts(_editedProduct);
      } catch (error) {
       await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Greška!!'),
                  content: Text('Došlo je do greške!!'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    ),
                  ],
                ));
      } 
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
     setState(() {
        _isLoading = false;
      });

    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                          initialValue: _initValues['title'],
                          decoration: InputDecoration(labelText: 'Title'),
                          textInputAction: TextInputAction.next,
                          maxLength: 25,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_priceFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Upisite vrijednost..';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                                title: value,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: _editedProduct.imageUrl);
                          }),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Upisite broj, polje praznp!';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Upisite pravilan broj';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Upisite broj veći od 0';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              price: double.parse(value),
                              imageUrl: _editedProduct.imageUrl);
                        },
                      ),
                      TextFormField(
                          initialValue: _initValues['description'],
                          decoration: InputDecoration(labelText: 'Description'),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          focusNode: _descriptionFocusNode,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Upisite opis';
                            }
                            if (value.length < 10) {
                              return 'Upisati najmanje deset karaktera';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                                title: _editedProduct.title,
                                description: value,
                                price: _editedProduct.price,
                                imageUrl: _editedProduct.imageUrl);
                          }),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: _imageUrlControler.text.isEmpty
                                ? Text('Enter a URL')
                                : FittedBox(
                                    child:
                                        Image.network(_imageUrlControler.text),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                                //initialValue: _initValues['imageUrl'],
                                decoration:
                                    InputDecoration(labelText: 'Image URL'),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                controller: _imageUrlControler,
                                onFieldSubmitted: (_) {
                                  _saveForm();
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Unesite sliku!!';
                                  }
                                  if (!value.startsWith('hhtp') &&
                                      !value.startsWith('https')) {
                                    return 'Unesite pravilnu internet sliku';
                                  }
                                  if (!value.endsWith('.jpg') &&
                                      !value.endsWith('.png') &&
                                      !value.endsWith('.jpeg')) {
                                    return 'Unijeti pravilnu sliku';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _editedProduct = Product(
                                      id: _editedProduct.id,
                                      isFavorite: _editedProduct.isFavorite,
                                      title: _editedProduct.title,
                                      description: _editedProduct.description,
                                      price: _editedProduct.price,
                                      imageUrl: value);
                                }),
                          )
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
