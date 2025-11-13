import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vrooom/data/sources/auth/auth_storage.dart';
import 'package:vrooom/presentation/splash/bloc/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final AuthStorage _authStorage;

  SplashCubit({required AuthStorage authStorage})
      : _authStorage = authStorage,
        super(DisplaySplash());

  Future<void> appStarted() async {
    await Future.delayed(const Duration(seconds: 2));

    try {
      final token = await _authStorage.getToken();
      final userId = await _authStorage.getUserId();
      final role = await _authStorage.getRole();

      if (token != null && userId != null && role != null) {
        if (role == 'Role.admin') {
          emit(AuthenticatedAdmin());
        } else {
          emit(AuthenticatedUser());
        }
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(Unauthenticated());
    }
  }

  void reset() {
    emit(DisplaySplash());
  }
}
