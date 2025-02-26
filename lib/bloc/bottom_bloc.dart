import 'package:flutter_bloc/flutter_bloc.dart';

// States for Bottom Navigation
enum BottomNavState { home, schedule, membership, profile }

class BottomNavBloc extends Cubit<BottomNavState> {
  BottomNavBloc() : super(BottomNavState.home);

  void updateTab(int index) {
    switch (index) {
      case 0:
        emit(BottomNavState.home);
        break;
      case 1:
        emit(BottomNavState.schedule);
        break;
      case 2:
        emit(BottomNavState.membership);
        break;
      case 3:
        emit(BottomNavState.profile);
        break;
    }
  }
}
