import 'package:sign_up_in/models/mytrip_model.dart';

final List<CurrentTrip> currentTrips = [
  CurrentTrip(
    nameGuide: 'John Doe',
    location: 'Da Nang - Ba Na',
    date: '2024-07-15',
    duration: '7 days',
    price: 1200,
    image: 'assets/mytrip/currenttrip1.png',
  ),
];

final List<NextTrip> nextTrips = [
  NextTrip(
    nameGuide: 'Jane Smith',
    location: 'Bangkok, Thailand',
    date: '2024-08-01',
    duration: '5 days',
    price: 1500,
    image: 'assets/mytrip/nexttrip1.png',
  ),
  NextTrip(
    nameGuide: 'Alice Johnson',
    location: 'Hoi An - My Son',
    date: '2024-09-10',
    duration: '6 days',
    price: 1800,
    image: 'assets/mytrip/nexttrip2.png',
  ),
  NextTrip(
    nameGuide: 'Bob Brown',
    location: 'Da Nang - Ba Na',
    date: '2024-07-15',
    duration: '7 days',
    price: 1200,
    image: 'assets/mytrip/nexttrip3.png',
  ),
];

final List<PastTrip> pastTrips = [
  PastTrip(
    nameGuide: 'Emily Davis',
    location: 'Quoc Tu Giam Temple',
    date: '2024-06-01',
    duration: '4 days',
    price: 1000,
    image: 'assets/mytrip/pasttrip1.png',
  ),
  PastTrip(
    nameGuide: 'Michael Wilson',
    location: 'Dinh Doc Lap',
    date: '2024-05-20',
    duration: '5 days',
    price: 1100,
    image: 'assets/mytrip/pasttrip2.png',
  ),
];

final List<WishList> wishLists = [
  WishList(
    nameGuide: 'Sarah Lee',
    location: 'Melbourne - Sydney',
    date: '2024-10-05',
    duration: '7 days',
    price: 2000,
    image: 'assets/mytrip/wishtrip1.png',
  ),
  WishList(
    nameGuide: 'David Kim',
    location: 'Hanoi - Ha Long Bay',
    date: '2024-07-15',
    duration: '7 days',
    price: 1200,
    image: 'assets/mytrip/wishtrip2.png',
  ),
];
