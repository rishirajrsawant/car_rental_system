import 'package:flutter/material.dart';
import 'models/car.dart';
import 'models/car_type.dart';
import 'models/inventory.dart';
import 'services/car_rental_system.dart';
import 'screens/home_screen.dart';

void main() {
  // Initialize inventory with limited cars
  List<Car> cars = [
    Car(
      id: '1',
      type: CarType.sedan,
      model: 'Toyota Camry',
      color: 'Red',
      pricePerDay: 50.0,
    ),
    Car(
      id: '2',
      type: CarType.suv,
      model: 'Honda CR-V',
      color: 'Blue',
      pricePerDay: 70.0,
    ),
    Car(
      id: '3',
      type: CarType.van,
      model: 'Dodge Grand Caravan',
      color: 'White',
      pricePerDay: 90.0,
    ),
    Car(
      id: '4',
      type: CarType.sedan,
      model: 'Honda City',
      color: 'Grey',
      pricePerDay: 60.0,
    ),
    Car(
      id: '5',
      type: CarType.suv,
      model: 'Toyota Fortuner',
      color: 'Black',
      pricePerDay: 80.0,
    ),
    Car(
      id: '6',
      type: CarType.van,
      model: 'Ford Transit',
      color: 'Silver',
      pricePerDay: 100.0,
    ),
    Car(
      id: '7',
      type: CarType.sedan,
      model: 'Volkswagen Passat',
      color: 'Gravity Black',
      pricePerDay: 65.0,
    ),
  ];

  Inventory inventory = Inventory(cars);
  CarRentalSystem carRentalSystem = CarRentalSystem(inventory);

  runApp(MyApp(carRentalSystem));
}

class MyApp extends StatelessWidget {
  final CarRentalSystem carRentalSystem;

  MyApp(this.carRentalSystem);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Car Rental System',
      theme: ThemeData(
        primaryColor: Colors.black45,
        scaffoldBackgroundColor: Colors.black45,
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          onPrimary: Colors.black45,
          secondary: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Colors.white,
            fontFamily: "Poppins",
          ),
        ),
        appBarTheme: const AppBarTheme(
          color: Colors.black,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: "Poppins",
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, // Button background color
            foregroundColor: Colors.black, // Button text color
            textStyle: const TextStyle(
              fontSize: 16,
              fontFamily: "Poppins",
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: Colors.black,
            textStyle: const TextStyle(
              fontSize: 16,
              fontFamily: "Poppins",
            ),
          ),
        ),
      ),
      home: HomeScreen(carRentalSystem: carRentalSystem),
    );
  }
}
