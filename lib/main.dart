import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as location;
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

class UserData {
  static String userId = '';
  static String username = '';
  static String userType = '';
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
  var _user_id;

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

  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // TODO: Add authentication logic
      final supabase = Supabase.instance.client;

      try {
        final response =
            await supabase
                .from(widget.userType)
                .select()
                .eq('username', _username)
                .eq('password', _password)
                .maybeSingle(); // returns null if not found, avoids crash

        print("Query Result: $response");

        if (response != null) {
          UserData.userId = response['user_id'];
          UserData.username = _username;
          UserData.userType = widget.userType;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      HomePage(userType: widget.userType, username: _username),
            ),
          );

          print("User ID: ${response['user_id']}");
        } else {
          _showError('Invalid username or password.');
        }
      } on PostgrestException catch (e) {
        print("PostgrestException: ${e.message}");
        _showError('Login failed: ${e.message}');
      } catch (e) {
        print("Unknown error: $e");
        _showError('An error occurred. Please try again.');
      }
    }
  }

  void get_user_id() async {
    final supabase = Supabase.instance.client;
    _user_id =
        await supabase
            .from(widget.userType)
            .select()
            .eq('username', _username)
            .eq('password', _password)
            .maybeSingle();
    print("--------------------------------");
    print("user_id: $_user_id");
    print(_user_id['user_id']);
    print(_user_id);
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Login Error'),
            content: Text(message),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
    );
  }
}

double? _latitude;
double? _longitude;
String _currentAddress = '';

// Sign Up Page
class SignUpPage extends StatefulWidget {
  final String userType;
  String tablename = "";

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
    String tableName = widget.userType == 'orphanage' ? 'orphanage' : 'hotel';
    try {
      final response = await Supabase.instance.client
          .from(tableName)
          .insert(data);
      print(
        "----------------------------------------------------------------------------",
      );
      print(data);
      print(data['latitude']);
      print(data['longitude']);

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
  GoogleMapController? _mapController;
  LatLng _currentPosition = const LatLng(20.5937, 78.9629); // Default to India
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 1:
        _showUnimplementedFeature('Messages');
        break;
      case 2:
        _showUnimplementedFeature('History');
        break;
      case 3:
        _showUnimplementedFeature('Profile');
        break;
    }
  }

  void _showUnimplementedFeature(String featureName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$featureName feature coming soon!')),
    );
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _markers.add(
          Marker(
            markerId: const MarkerId('current_location'),
            position: _currentPosition,
            infoWindow: const InfoWindow(title: "You are here"),
          ),
        );
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition, 15),
      );
    }
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
    if (_selectedIndex != 0) {
      return const Center(child: Text('Feature coming soon!'));
    }

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _currentPosition,
            zoom: 5,
          ),
          onMapCreated: (controller) => _mapController = controller,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          markers: _markers,
        ),
        if (widget.userType == 'hotel' && foodItems.isEmpty)
          if (widget.userType == 'orphanage' && foodItems.isNotEmpty)
            _orphanageHomeView(),
      ],
    );
  }

  Widget _buildEmptyHotelView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_circle_outline,
            size: 100,
            color: Colors.green.shade300,
          ),
          const SizedBox(height: 20),
          Text(
            'Add your first food donation',
            style: TextStyle(fontSize: 18, color: Colors.green.shade600),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _addFoodItem,
            icon: const Icon(Icons.add),
            label: const Text('Add Food Item'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _orphanageHomeView() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.white.withOpacity(0.9),
        height: 200,
        child: ListView.builder(
          itemCount: foodItems.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(foodItems[index].name),
              subtitle: Text('Quantity: ${foodItems[index].quantity}'),
              onTap: () {
                // Zoom to food item's location (if available)
              },
            );
          },
        ),
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
        // Optionally add a marker for the new item if it has location
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
  final user_id = UserData.userId;
  final user_type = UserData.userType;

  TextEditingController foodNameController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController delevaryController = TextEditingController();

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
              // Food Name
              TextFormField(
                controller: delevaryController,
                decoration: const InputDecoration(
                  labelText: 'Delivary',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Delivary details';
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

  void _saveFoodItem() async {
    print("-------------------------------------------------");
    print(UserData.userId);
    if (_formKey.currentState!.validate()) {
      final uuid = const Uuid().v4(); // unique ID for image file
      String? imageUrl;

      try {
        // Upload Image to Supabase Storage
        if (_imageFile != null) {
          final imageBytes = await _imageFile!.readAsBytes();
          final imageExt = _imageFile!.path.split('.').last;
          final imagePath = 'food_image/$uuid.$imageExt';

          final storageResponse = await Supabase.instance.client.storage
              .from('food-image') // your Supabase bucket name
              .uploadBinary(imagePath, imageBytes);

          if (storageResponse.isEmpty) {
            throw Exception('Image upload failed.');
          }

          // Get public URL
          final imagePublicUrl = Supabase.instance.client.storage
              .from('food-image')
              .getPublicUrl(imagePath);

          imageUrl = imagePublicUrl;
          print(imageUrl);
        }

        // Insert into Supabase Database
        final response = await Supabase.instance.client
            .from('food_items')
            .insert({
              'name': foodNameController.text,
              'expiry_date': expiryDateController.text,
              'quantity': int.parse(quantityController.text),
              'delivary': delevaryController.text,
              'image_url': imageUrl,
              'user_id': user_id,
            });
        /*
        if (response.error != null) {
          throw Exception(response.error!.message);
        }
*/
        // Clear form and show success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Food item added successfully!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
        print("------------------------------------------");
        print('error$e');
      }
    }
  }
}

// Food Item Model
class FoodItem {
  final String name;
  final String expiryDate;
  final int quantity;
  final String delivary;
  final File? image;

  FoodItem({
    required this.name,
    required this.expiryDate,
    required this.quantity,
    required this.delivary,
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
