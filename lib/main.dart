import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import 'package:geocoding/geocoding.dart';

const supabaseUrl = 'https://wxsrvwglhxehoxjptuuz.supabase.co';
const supabaseKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind4c3J2d2dsaHhlaG94anB0dXV6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM0MDk2MzEsImV4cCI6MjA1ODk4NTYzMX0.jErayHSGDcdaBwsIKPDz5iL7k2yj9B6FtM6JBrjfJQo';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  final supabase = Supabase.instance.client;
  final List<dynamic> response = await Supabase.instance.client
      .from('test')
      .select('id');

  print(
    "--------------------------------------------------------------------------------------------------",
  );
  print(response);

  runApp(FoodRescueApp());
}

class FoodRescueApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Rescue App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: UserTypeSelectionPage(),
    );
  }
}

// User Type Selection Page
class UserTypeSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade200, Colors.green.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Food Rescue',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green,
                  minimumSize: Size(250, 50),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.school),
                    SizedBox(width: 10),
                    Text('Orphanage Login'),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(userType: 'orphanage'),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green,
                  minimumSize: Size(250, 50),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.hotel),
                    SizedBox(width: 10),
                    Text('Hotel Login'),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(userType: 'hotel'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Login Page
class LoginPage extends StatefulWidget {
  final String userType;

  LoginPage({required this.userType});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade200, Colors.green.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // User Type Icon
                      Icon(
                        widget.userType == 'hotel' ? Icons.hotel : Icons.school,
                        size: 80,
                        color: Colors.green,
                      ),
                      SizedBox(height: 20),
                      Text(
                        '${widget.userType.capitalize()} Login',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: 'Username',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter username';
                          }
                          return null;
                        },
                        onSaved: (value) => _username = value!,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                        onSaved: (value) => _password = value!,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _login,
                        child: Text('Login'),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      SignUpPage(userType: widget.userType),
                            ),
                          );
                        },
                        child: Text('Create New Account'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // TODO: Add authentication logic
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  HomePage(userType: widget.userType, username: _username),
        ),
      );
    }
  }
}

double? _latitude;
double? _longitude;
String _currentAddress = '';

// Sign Up Page
class SignUpPage extends StatefulWidget {
  final String userType;

  SignUpPage({required this.userType});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _signUpData = {};
  String _currentAddress = "Tap to get location";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade200, Colors.green.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.userType == 'hotel' ? Icons.hotel : Icons.school,
                        size: 80,
                        color: Colors.green,
                      ),
                      SizedBox(height: 20),
                      Text(
                        '${widget.userType[0].toUpperCase()}${widget.userType.substring(1)} Sign Up',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildTextFormField(
                        label: 'Username',
                        icon: Icons.person,
                        onSaved: (value) => _signUpData['username'] = value!,
                      ),
                      SizedBox(height: 20),
                      _buildTextFormField(
                        label: 'Password',
                        icon: Icons.lock,
                        obscureText: true,
                        onSaved: (value) => _signUpData['password'] = value!,
                      ),
                      SizedBox(height: 20),
                      _buildTextFormField(
                        label: 'Mobile Number',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        onSaved: (value) => _signUpData['mobileno'] = value!,
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: _getCurrentLocation,
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.location_on),
                              labelText: 'Location',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            controller: TextEditingController(
                              text: _currentAddress,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please get your location';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildTextFormField(
                        label:
                            widget.userType == 'orphanage'
                                ? 'Orphanage Name'
                                : 'Hotel Name',
                        icon:
                            widget.userType == 'orphanage'
                                ? Icons.school
                                : Icons.hotel,
                        onSaved: (value) => _signUpData['name'] = value!,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _signUp,
                        child: Text('Sign Up'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    required IconData icon,
    required void Function(String?) onSaved,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
      onSaved: onSaved,
    );
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Location services are disabled.")),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Location permission is denied.")),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Location permission is permanently denied.")),
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress =
            "${place.street}, ${place.locality}, ${place.country}";
        _signUpData['latitude'] = position.latitude.toString();
        _signUpData['longitude'] = position.longitude.toString();
        print(
          "---------------------------------------------------------------",
        );
        print(_signUpData['latitude']);
        print(_signUpData['longitude']);
        print(_signUpData);
      });

      _signUpData['location'] = _currentAddress;
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // TODO: Add sign up logic to save user data
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => HomePage(
                userType: widget.userType,
                username: _signUpData['username']!,
              ),
        ),
      );
    }
    print(
      "------------------------------------------------------------------------------------------",
    );
    print(_signUpData);
    // print(_currentAddress);
    saveUserDataToSupabase();
  }

  Future<void> saveUserDataToSupabase() async {
    var uuid = Uuid();
    String userId = uuid.v4();
    final Map<String, dynamic> data = {
      'user_id': userId,
      'username': _signUpData['username'],
      'name': _signUpData['name'],
      'mobileno': _signUpData['mobileno'],
      'location': _signUpData['location'],
      'latitude': _signUpData['latitude'],
      'longitude': _signUpData['longitude'],
      'password': _signUpData['password'],
    };
    try {
      final response = await Supabase.instance.client
          .from('orphanages')
          .insert(_signUpData);

      if (response.error == null) {
        print('User data inserted successfully!');
      } else {
        print('Insert error: ${response.error!.message}');
      }
    } catch (e) {
      print('Error saving data: $e');
    }
  }
}

// Home Page
class HomePage extends StatefulWidget {
  final String userType;
  final String username;

  const HomePage({Key? key, required this.userType, required this.username})
    : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<FoodItem> foodItems = [];
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // TODO: Implement navigation logic for different bottom nav items
    switch (index) {
      case 0: // Home
        // Already on home page
        break;
      case 1: // Messages
        _showUnimplementedFeature('Messages');
        break;
      case 2: // History
        _showUnimplementedFeature('History');
        break;
      case 3: // Profile
        _showUnimplementedFeature('Profile');
        break;
    }
  }

  void _showUnimplementedFeature(String featureName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$featureName feature coming soon!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.username}'),
        actions: [
          if (widget.userType == 'hotel')
            IconButton(icon: const Icon(Icons.add), onPressed: _addFoodItem),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildBody() {
    if (foodItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.userType == 'hotel'
                  ? Icons.add_circle_outline
                  : Icons.no_food_outlined,
              size: 100,
              color: Colors.green.shade300,
            ),
            SizedBox(height: 20),
            Text(
              widget.userType == 'hotel'
                  ? 'Add your first food donation'
                  : 'No food donations available',
              style: TextStyle(fontSize: 18, color: Colors.green.shade600),
            ),
            if (widget.userType == 'hotel') SizedBox(height: 20),
            if (widget.userType == 'hotel')
              ElevatedButton.icon(
                onPressed: _addFoodItem,
                icon: Icon(Icons.add),
                label: Text('Add Food Item'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
          ],
        ),
      );
    }
    return widget.userType == 'hotel' ? _hotelHomeView() : _orphanageHomeView();
  }

  Widget _hotelHomeView() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: foodItems.length,
            itemBuilder: (context, index) {
              return FoodItemCard(foodItem: foodItems[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _orphanageHomeView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Available Food Donations',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: foodItems.length,
              itemBuilder: (context, index) {
                return FoodItemCard(foodItem: foodItems[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addFoodItem() async {
    final newItem = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddFoodItemPage()),
    );

    if (newItem != null) {
      setState(() {
        foodItems.add(newItem);
      });
    }
  }
}

// Add Food Item Page
class AddFoodItemPage extends StatefulWidget {
  @override
  _AddFoodItemPageState createState() => _AddFoodItemPageState();
}

class _AddFoodItemPageState extends State<AddFoodItemPage> {
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  final _picker = ImagePicker();

  TextEditingController foodNameController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Food Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      _imageFile == null
                          ? const Center(child: Text('Tap to add image'))
                          : Image.file(_imageFile!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 20),

              // Food Name
              TextFormField(
                controller: foodNameController,
                decoration: const InputDecoration(
                  labelText: 'Food Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter food name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Expiry Date
              TextFormField(
                controller: expiryDateController,
                decoration: const InputDecoration(
                  labelText: 'Expiry Date',
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    expiryDateController.text =
                        "${picked.day}/${picked.month}/${picked.year}";
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter expiry date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Quantity
              TextFormField(
                controller: quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Save Button
              ElevatedButton(
                onPressed: _saveFoodItem,
                child: const Text('Save Food Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveFoodItem() {
    if (_formKey.currentState!.validate()) {
      final newFoodItem = FoodItem(
        name: foodNameController.text,
        expiryDate: expiryDateController.text,
        quantity: int.parse(quantityController.text),
        image: _imageFile,
      );

      Navigator.pop(context, newFoodItem);
    }
  }
}

// Food Item Model
class FoodItem {
  final String name;
  final String expiryDate;
  final int quantity;
  final File? image;

  FoodItem({
    required this.name,
    required this.expiryDate,
    required this.quantity,
    this.image,
  });
}

// Food Item Card Widget
class FoodItemCard extends StatelessWidget {
  final FoodItem foodItem;

  const FoodItemCard({Key? key, required this.foodItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (foodItem.image != null)
            Image.file(
              foodItem.image!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  foodItem.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text('Expiry Date: ${foodItem.expiryDate}'),
                Text('Quantity: ${foodItem.quantity}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Extension to capitalize first letter of string
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
