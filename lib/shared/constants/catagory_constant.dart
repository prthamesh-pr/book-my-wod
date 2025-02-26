import 'package:bookmywod_admin/shared/constants/cross_fit_constant.dart';
import 'package:bookmywod_admin/shared/constants/heavy_lifting_constant.dart';
import 'package:bookmywod_admin/shared/constants/hyrox_constant.dart';

const List<Map<String, dynamic>> catagories = [
  {
    "Name": "Cross Fit",
    "Catagories": "4",
    "Seat": "60",
    "Time": "8:00 PM - 10: 00 AM",
    "Image": "assets/events/crossfit.png",
    "Events": crossFitEvent,
  },
  {
    "Name": "Hyrox",
    "Catagories": "4",
    "Seat": "60",
    "Time": "8:00 PM - 10: 00 AM",
    "Image": "assets/events/hyrox.png",
    "Events": hyroxEvent,
  },
  {
    "Name": "Heavy Lifting",
    "Catagories": "4",
    "Seat": "60",
    "Time": "8:00 PM - 10: 00 AM",
    "Image": "assets/events/heavylifting.png",
    "Events": heavyLiftingEvent,
  },
];
