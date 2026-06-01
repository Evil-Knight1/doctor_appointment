import 'package:doctor_appointment/core/config/app_config.dart';
import 'package:doctor_appointment/core/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_launcher/map_launcher.dart';

class ClinicLocationCard extends StatefulWidget {
  const ClinicLocationCard({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  final double latitude;
  final double longitude;
  final String address;

  @override
  State<ClinicLocationCard> createState() => _ClinicLocationCardState();
}

class _ClinicLocationCardState extends State<ClinicLocationCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _mapScale;
  late final Animation<double> _pinScale;
  late final Animation<double> _pinOpacity;

  late final String _mapUrl;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _mapScale = Tween<double>(begin: 1, end: 1.35).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _pinScale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.65, 1, curve: Curves.elasticOut),
      ),
    );

    _pinOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.7, 1)),
    );

    _mapUrl =
        'https://maps.googleapis.com/maps/api/staticmap'
        '?center=${widget.latitude},${widget.longitude}'
        '&zoom=15'
        '&size=1000x600'
        '&maptype=roadmap'
        '&markers=color:red%7C'
        '${widget.latitude},${widget.longitude}'
        '&key=${getIt<AppConfig>().googleMapsApiKey}';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    await _controller.forward(from: 0);

    final maps = await MapLauncher.installedMaps;

    if (maps.isNotEmpty) {
      await maps.first.showMarker(
        coords: Coords(widget.latitude, widget.longitude),
        title: widget.address,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        height: 190.h,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedMapPreview(animation: _mapScale, mapUrl: _mapUrl),

            const _MapGradientOverlay(),

            Align(
              alignment: Alignment.center,
              child: AnimatedLocationPin(
                scaleAnimation: _pinScale,
                opacityAnimation: _pinOpacity,
              ),
            ),

            LocationInfoOverlay(address: widget.address),
          ],
        ),
      ),
    );
  }
}

class AnimatedMapPreview extends StatelessWidget {
  const AnimatedMapPreview({
    super.key,
    required this.animation,
    required this.mapUrl,
  });

  final Animation<double> animation;
  final String mapUrl;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, _) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..translate(0.0, -20.0 * (animation.value - 1))
            ..scale(animation.value),
          child: Image.network(
            mapUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }

              return Container(
                color: Colors.grey.shade200,
                child: const Center(child: CircularProgressIndicator()),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey.shade300,
                child: const Center(child: Icon(Icons.map_rounded, size: 48)),
              );
            },
          ),
        );
      },
    );
  }
}

class AnimatedLocationPin extends StatelessWidget {
  const AnimatedLocationPin({
    super.key,
    required this.scaleAnimation,
    required this.opacityAnimation,
  });

  final Animation<double> scaleAnimation;
  final Animation<double> opacityAnimation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FadeTransition(
      opacity: opacityAnimation,
      child: ScaleTransition(
        scale: scaleAnimation,
        child: Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .15),
                blurRadius: 18,
              ),
            ],
          ),
          child: Icon(
            Icons.location_on_rounded,
            color: theme.colorScheme.primary,
            size: 34.sp,
          ),
        ),
      ),
    );
  }
}

class LocationInfoOverlay extends StatelessWidget {
  const LocationInfoOverlay({super.key, required this.address});

  final String address;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 18.w,
      right: 18.w,
      bottom: 18.h,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Clinic Location',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: 4.h),

                Text(
                  address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white70, fontSize: 13.sp),
                ),
              ],
            ),
          ),

          Icon(Icons.open_in_new_rounded, color: Colors.white, size: 22.sp),
        ],
      ),
    );
  }
}

class _MapGradientOverlay extends StatelessWidget {
  const _MapGradientOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black.withValues(alpha: .45), Colors.transparent],
        ),
      ),
    );
  }
}
