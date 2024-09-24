import 'car.dart';
import 'car_type.dart';

class Inventory {
  final List<Car> cars;

  Inventory(this.cars);

  List<Car> getCarsByType(CarType type) {
    return cars.where((car) => car.type == type).toList();
  }
}
