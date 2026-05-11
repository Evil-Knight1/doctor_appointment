import 'package:doctor_appointment/core/utils/app_colors.dart';
import 'package:doctor_appointment/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConsultationFeesWidget extends StatelessWidget {
  final double fee;
  const ConsultationFeesWidget({super.key, required this.fee});

  List<Map<String, dynamic>> get _fees => [
        {'label': 'Online Call', 'amount': '\$${fee.toStringAsFixed(0)}', 'icon': Icons.call_outlined},
        {'label': 'Home Visit', 'amount': '\$${(fee * 1.5).toStringAsFixed(0)}', 'icon': Icons.home_outlined},
        {'label': 'Video Call', 'amount': '\$${(fee * 1.2).toStringAsFixed(0)}', 'icon': Icons.videocam_outlined},
      ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_fees.length, (i) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < 2 ? 10.w : 0),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Icon(
                  _fees[i]['icon'] as IconData,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
                SizedBox(height: 4.h),
                Text(
                  _fees[i]['amount'] as String,
                  style: AppStyles.styleSemiBold22.copyWith(
                    fontSize: 14.sp,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  _fees[i]['label'] as String,
                  style: AppStyles.styleRegular12.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
