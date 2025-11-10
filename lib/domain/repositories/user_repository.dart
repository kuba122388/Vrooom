import 'dart:io';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:vrooom/data/models/user_model.dart';
import 'package:vrooom/domain/entities/booking.dart';

import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<String, List<User>>> getAllUsers();

  Future<Either<String, void>> deleteUserById(int userId);

  Future<Either<String, User>> getCurrentUserInformation();

  Future<Either<String, void>> editCurrentUser(UserModel request);

  Future<Either<String, void>> uploadUserProfilePicture(int userId, File imageFile);

  Future<Either<String, Uint8List>> downloadUserProfilePicture(int userId);

  Future<Either<String, List<Booking>>> getUserActiveRentals();

  Future<Either<String, List<Booking>>> getUserUpcomingRentals();

  Future<Either<String, List<Booking>>> getUserRentalHistory();

  Future<Either<String, int?>> getUserIdByEmail(String email);
}
