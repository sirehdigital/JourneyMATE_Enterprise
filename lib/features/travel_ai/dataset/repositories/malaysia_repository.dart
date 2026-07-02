import '../models/airport.dart';
import '../models/attraction.dart';
import '../models/country.dart';
import '../models/destination.dart';
import '../models/district.dart';
import '../models/hotel.dart';
import '../models/mosque.dart';
import '../models/restaurant.dart';
import '../models/state.dart';
import '../models/tourism_event.dart';
import '../models/transport_hub.dart';
import '../services/dataset_loader_service.dart';

class MalaysiaRepository {
  MalaysiaRepository({DatasetLoaderService? loader})
    : _loader = loader ?? const DatasetLoaderService();

  final DatasetLoaderService _loader;

  Future<Country> loadCountry() async {
    final map = await _loader.loadJsonMap('assets/data/malaysia/country.json');
    return Country.fromMap(map);
  }

  Future<List<MalaysiaState>> loadStates() async {
    final records = await _loader.loadJsonList('assets/data/malaysia/states');
    return records.map(MalaysiaState.fromMap).toList(growable: false);
  }

  Future<List<District>> loadDistricts() async {
    final records = await _loader.loadJsonList('assets/data/malaysia/districts');
    return records.map(District.fromMap).toList(growable: false);
  }

  Future<List<Destination>> loadDestinations() async {
    final records = await _loader.loadJsonList(
      'assets/data/malaysia/destinations',
    );
    return records.map(Destination.fromMap).toList(growable: false);
  }

  Future<List<Attraction>> loadAttractions() async {
    final records = await _loader.loadJsonList(
      'assets/data/malaysia/destinations',
    );
    return records.map(Attraction.fromMap).toList(growable: false);
  }

  Future<List<Hotel>> loadHotels() async {
    final records = await _loader.loadJsonList('assets/data/malaysia/hotels');
    return records.map(Hotel.fromMap).toList(growable: false);
  }

  Future<List<Restaurant>> loadRestaurants() async {
    final records = await _loader.loadJsonList(
      'assets/data/malaysia/restaurants',
    );
    return records.map(Restaurant.fromMap).toList(growable: false);
  }

  Future<List<Mosque>> loadMosques() async {
    final records = await _loader.loadJsonList('assets/data/malaysia/mosques');
    return records.map(Mosque.fromMap).toList(growable: false);
  }

  Future<List<Airport>> loadAirports() async {
    final records = await _loader.loadJsonList('assets/data/malaysia/airports');
    return records.map(Airport.fromMap).toList(growable: false);
  }

  Future<List<TransportHub>> loadTransport() async {
    final records = await _loader.loadJsonList('assets/data/malaysia/transport');
    return records.map(TransportHub.fromMap).toList(growable: false);
  }

  Future<List<TourismEvent>> loadEvents() async {
    final records = await _loader.loadJsonList('assets/data/malaysia/events');
    return records.map(TourismEvent.fromMap).toList(growable: false);
  }
}
