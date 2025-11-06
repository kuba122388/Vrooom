import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/loading_widget.dart';
import 'package:vrooom/core/common/widgets/search_user_module.dart';
import 'package:vrooom/domain/entities/user.dart';
import 'package:vrooom/domain/usecases/user/get_all_users_usecase.dart';
import 'package:vrooom/presentation/admin/widgets/admin_app_bar.dart';
import 'package:vrooom/presentation/admin/widgets/admin_drawer.dart';
import 'package:vrooom/presentation/admin/widgets/user_information_entity.dart';

import '../../../../core/configs/di/service_locator.dart';
import '../../../../core/configs/theme/app_spacing.dart';

class ManageUsersPage extends StatefulWidget {
  const ManageUsersPage({super.key});

  @override
  State<ManageUsersPage> createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<ManageUsersPage> {
  final GetAllUsersUsecase _getAllUsersUsecase = sl();
  bool _isLoading = true;
  List<User> _usersList = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final result = await _getAllUsersUsecase();

    result.fold((error) {
      print("=== ERROR OCCURED === $error");
      setState(() {
        _errorMessage = error;
        _isLoading = false;
      });
    }, (usersList) {
      print("=== USERS LOADED ===");
      setState(() {
        _usersList = usersList;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdminAppBar(title: "Manage Users"),
      drawer: const AdminDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SearchUserModule(),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                "Users",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              LoadingWidget(
                isLoading: _isLoading,
                errorMessage: _errorMessage,
                futureResultObj: _usersList,
                emptyResultMsg: "No Users data found.",
                futureBuilder: _buildUsersDetails,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsersDetails() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _usersList.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        return UserInformationEntity(
          user: _usersList[index],
        );
      },
    );
  }
}
