import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:doctor_appointment/core/utils/app_dimensions.dart';
import 'package:doctor_appointment/core/services/service_locator.dart';
import 'package:doctor_appointment/features/home/data/models/home_model.dart';
import 'package:doctor_appointment/core/utils/routes.dart';
import 'package:doctor_appointment/core/utils/app_colors.dart';
import 'package:doctor_appointment/features/doctors/logic/specializations_cubit.dart';
import 'package:doctor_appointment/features/doctors/logic/specializations_state.dart';
import 'package:doctor_appointment/core/utils/specialty_mapper.dart';
import '../widgets/shared_app_bar.dart';
import '../widgets/speciality_grid_card.dart';

class DoctorSpecialityView extends StatelessWidget {
  const DoctorSpecialityView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SpecializationsCubit>()..fetchSpecializations(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: const SharedAppBar(title: 'Doctor Speciality'),
        body: BlocBuilder<SpecializationsCubit, SpecializationsState>(
          builder: (context, state) {
            if (state is SpecializationsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SpecializationsFailure) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is SpecializationsSuccess) {
              final specialities = state.specializations;
              if (specialities.isEmpty) {
                return const Center(child: Text('No specialities found.'));
              }
              return GridView.builder(
                padding: EdgeInsets.all(AppSpacing.lg),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                  childAspectRatio: 1,
                ),
                itemCount: specialities.length,
                itemBuilder: (context, index) {
                  final spec = specialities[index];
                  final theme = SpecialtyMapper.getThemeForSpecialty(spec.name);
                  // Map API entity to SpecialityModel for UI
                  final model = SpecialityModel(
                    name: spec.name,
                    icon: theme.icon,
                    color: theme.color,
                    bgColor: theme.bgColor,
                  );
                  return SpecialityGridCard(
                    speciality: model,
                    onTap: () => context.pushNamed(
                      Routes.recommendationView,
                      extra: model.name,
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

}
